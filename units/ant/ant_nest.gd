extends Area2D

var antLoad = load("res://units/ant/ant.tscn") 
var deadLoad = load("res://usables/blood_splash.tscn")
var min = 1.0
var max = 3.0
var size = 1
var value = 10
var destinition = Vector2.ZERO
var paths = []

func _ready():
	scale = Vector2(1,0)
	var tween = create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(1,1), 1.0)

func _on_spawner_timeout():
	$Spawner.wait_time = randf_range(min, max)
	var ant = antLoad.instantiate()
	ant.destinition = destinition
	ant.position = global_position - Vector2(0, 4)
	get_tree().current_scene.add_child(ant)
	$Spawner.start()

func go_back():
	await get_tree().create_timer(0.5).timeout
	$Area2D.collision_layer = 2
	z_index = 0

func kill_yourself():
	
	var dead = deadLoad.instantiate()
	dead.position = global_position
	dead.scale.x = size
	dead.scale.y = size
	get_parent().add_child(dead)
	get_parent().score_up(value)
	queue_free()
