extends Area2D

@export var fall_speed = 200.0

var screen_size

func _ready():
	screen_size = get_viewport_rect().size
	
func _process(delta):
	if not Statuses.playing: return
	position.y += (fall_speed * delta) + (Statuses.total / 5)
	if position.y >= screen_size[1] + 100:
		self.queue_free()
