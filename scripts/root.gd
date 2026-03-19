extends Node2D

const main_color = Color("f0b898")
const red_color = Color("620000ff")

@onready var food: PackedScene = preload("res://scenes/food.tscn")
@onready var bomb: PackedScene = preload("res://scenes/bomb.tscn")

@onready var bg: ColorRect = $BackLayer/Sprite2D
@onready var score = $CanvasLayer/Panel/HBoxContainer/VBoxContainer/ScoreValue
@onready var best = $CanvasLayer/Panel/HBoxContainer/VBoxContainer/HighscoreValue
@onready var player = $Player
@onready var song = $AudioStreamPlayer
@onready var explosion = $Explosion

@onready var restart_button = $CanvasLayer/GameOver/HBoxContainer/Restart
@onready var exit_button = $CanvasLayer/GameOver/HBoxContainer/Exit
@onready var game_over = $CanvasLayer/GameOver
@onready var flashbang = $CanvasLayer/Flashbang
@onready var pause = $CanvasLayer/Pause
@onready var music_slider = $CanvasLayer/Pause/Pause/VBoxContainer/Music/MusicVol
@onready var sounds_slider = $CanvasLayer/Pause/Pause/VBoxContainer/Sounds/SoundsVol

const RESPAWN_TIME = 0.5

var screen_size

func pause_game():
	if Statuses.died: 
		pause.hide()
		return
	pause.visible = !pause.visible
	Statuses.playing = !pause.visible

func restart():
	Statuses.total = 0
	score.text = str(Statuses.total)
	for child in get_children():
		if child is Area2D:
			child.queue_free()
	player.main()
	bg.color = main_color
	game_over.hide()
	flashbang.hide()
	pause.hide()
	Statuses.playing = true
	Statuses.died = false
	song.play()

func _ready() -> void:
	print_tree()
	music_slider.value = Statuses.music_volume * 100.0
	sounds_slider.value = Statuses.sounds_volume * 100.0
	
	best.text = str(Statuses.highscore)
	score.text = str(0)
	screen_size = get_viewport_rect().size
	start_spawn_loop()	
	
func start_spawn_loop():
	while true:
		if not Statuses.playing:
			await get_tree().process_frame
			continue
			
		var wait_time = 1.0 - (Statuses.total / 5) * 0.1
		wait_time = max(wait_time, 0.2)
		
		await get_tree().create_timer(wait_time).timeout
		
		if Statuses.playing:
			var x_pos = randf_range(50, screen_size.x - 50)
			spawn(x_pos)	
	
func _input(event):
	if event.is_action_pressed("pause"):
		pause_game()
	
func spawn(x: float):
	var chance = randf()
	var scene: PackedScene
	
	if chance <= 0.2:
		scene = bomb
	else:
		scene = food
		
	var object: Area2D = scene.instantiate()
	object.z_index = -1
	
	if chance <= 0.2:
		object.body_entered.connect(eat_bomb.bind(object))
	else:
		object.body_entered.connect(eat_food.bind(object))
	
	add_child(object)
	object.position = Vector2(x, -50)
	
func eat_food(_body, object):
	Statuses.total += 1
	score.text = str(Statuses.total)
	object.queue_free()
	player.nom()
	
func eat_bomb(_body, object):
	object.queue_free()
	pause.hide()
	song.stop()
	bg.color = red_color
	player.angry()
	Statuses.playing = false
	Statuses.died = true
	
	if Statuses.total > Statuses.highscore:
		Statuses.highscore = Statuses.total
		Statuses.save_settings()
		best.text = str(Statuses.highscore)
	
	await get_tree().create_timer(1.3).timeout
	explosion.play()
	flashbang.show()
	await get_tree().create_timer(2).timeout
	game_over.show()

func _on_restart_pressed() -> void:
	restart()

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_pause_pressed() -> void:
	pause_game()
	
func _on_resume_pressed() -> void:
	pause_game()

func _on_music_vol_value_changed(value: float) -> void:
	var volume = value / 100.0
	Statuses.set_bus_volume("Music", volume)
	Statuses.save_settings()

func _on_sounds_vol_value_changed(value: float) -> void:
	var volume = value / 100.0
	Statuses.set_bus_volume("Sounds", volume)
	Statuses.save_settings()


func _on_rich_text_label_meta_clicked(meta: Variant) -> void:
	var url = str(meta).strip_edges()
	
	if url.is_empty():
		return
	
	if not (url.begins_with("http://") or url.begins_with("https://")):
		return

	OS.shell_open(url)
