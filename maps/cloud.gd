extends AnimatedSprite2D

var speed = randf_range(0.1, 0.2)

func _ready():
	frame = randi_range(0, 4)

func _physics_process(delta):
	position.x -= speed
	if position.x <= -50:
		queue_free()
