extends RigidBody2D

var destinition = Vector2.ZERO
var speed = 5
var size = 1
var value = 1
var hit = false
var deadLoad = load("res://usables/blood_splash.tscn")

func _ready():
	if destinition.x > position.x:
		$AnimatedSprite2D.play("walk")
	else:
		$AnimatedSprite2D.play("reverse_walk")

func _integrate_forces(state):
	linear_velocity = (destinition - position).normalized() * speed

func go_back():
	await get_tree().create_timer(0.1).timeout
	$Area2D.collision_layer = 2
	$Area2D.collision_mask = 1
	z_index = 0

func kill_yourself():
	var dead = deadLoad.instantiate()
	dead.position = global_position
	dead.scale.x = size
	dead.scale.y = size
	get_parent().add_child(dead)
	get_parent().score_up(value)
	queue_free()

func _on_area_2d_area_entered(area):
	hit = true

func _on_area_2d_area_exited(area):
	hit = false

func _on_hit_timeout():
	if hit:
		var ran = randi_range(0, 2)
		match ran:
			0: $SEat1.play()
			1: $SEat2.play()
			2: $SEat3.play()
			_: $SEat1.play()
		get_parent().get_node("Player").change_health(-size)
