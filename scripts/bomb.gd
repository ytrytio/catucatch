extends Area2D

@export var fall_speed = 200.0

func _process(delta):
	if not Statuses.playing: return
	position.y += (fall_speed * delta) + (Statuses.total / 5)
