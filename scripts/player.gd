extends CharacterBody2D

@onready var angry_sprite = $Angry
@onready var nom_sprite = $Nom
@onready var main_sprite = $Main
@onready var eat_sound: AudioStreamPlayer = $EatSound
@onready var die_sound: AudioStreamPlayer = $DieSound

@export var speed = 400

var screen_size
var touches = {}

func _ready():
	screen_size = get_viewport_rect().size

func _input(event):
	if not Statuses.playing: 
		touches.clear()
		return
	
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		if event is InputEventScreenTouch:
			if event.pressed:
				touches[event.index] = event.position.x
			else:
				touches.erase(event.index)
		
		elif event is InputEventScreenDrag:
			touches[event.index] = event.position.x

		_update_touch_input()

func _update_touch_input():
	if touches.is_empty():
		Input.action_release("left")
		Input.action_release("right")
		return

	var last_touch_index = touches.keys().back()
	var last_touch_pos_x = touches[last_touch_index]

	if last_touch_pos_x < screen_size.x / 2:
		Input.action_press("left")
		Input.action_release("right")
	else:
		Input.action_press("right")
		Input.action_release("left")

func _physics_process(_delta):
	if not Statuses.playing: 
		velocity.x = 0
		return
	
	var direction = Input.get_axis("left", "right")
	
	velocity.x = direction * speed
	velocity.y = 0
	
	move_and_slide()

	position.x = clamp(position.x, 50, screen_size.x - 50)

func angry():
	main_sprite.hide()
	nom_sprite.hide()
	angry_sprite.show()
	die_sound.play()
	touches.clear()
	Input.action_release("left")
	Input.action_release("right")
	
func main():
	main_sprite.show()
	angry_sprite.hide()
	nom_sprite.hide()
	
func nom():
	main_sprite.hide()
	nom_sprite.show()
	eat_sound.pitch_scale = randf_range(0.9, 1.1)
	eat_sound.play(0.65)
	await get_tree().create_timer(0.5).timeout
	if Statuses.playing:
		main_sprite.show()
		nom_sprite.hide()
