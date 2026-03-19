extends Control

@onready var button = $CatPic

var game = load("res://scenes/root.tscn")

func _ready() -> void:
	animate_pulse()

func animate_pulse():
	var tween = create_tween().set_loops().set_process_mode(Tween.TWEEN_PROCESS_IDLE)
	button.pivot_offset = button.size / 2
	
	tween.tween_property(button, "scale", Vector2(1.1, 1.1), 1.0)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)
		
	tween.tween_property(button, "scale", Vector2(1.0, 1.0), 1.0)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)

func play() -> void:
	get_tree().change_scene_to_packed(game)

func _on_cat_pic_pressed() -> void:
	play()
