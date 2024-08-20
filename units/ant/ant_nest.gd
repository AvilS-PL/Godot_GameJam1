extends StaticBody2D

var antLoad = load("res://units/ant/ant.tscn") 
var min = 1.0
var max = 3.0

func _on_spawner_timeout():
	$Spawner.wait_time = randf_range(min, max)
	var ant = antLoad.instantiate()
	ant.position = global_position - Vector2(0, 4)
	get_tree().current_scene.add_child(ant)
	$Spawner.start()
