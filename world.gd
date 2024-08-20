extends Node2D

var planet = Polygon2D.new()

#Loads
var mapLoad = load("res://maps/tile_map_0.tscn")
var map
var playerLoad = load("res://units/player/player.tscn")
var player
var armLoad = load("res://units/player/arm.tscn")
var antNest
var antNestLoad = load("res://units/ant/ant_nest.tscn")

func _ready():
	start_game()

func start_game():
	
	map = mapLoad.instantiate()
	add_child(map)
	
	#$Camera2D.position = map.get_node("Spawn").position
	#$Camera2D.zoom = Vector2(3.2,3.2)
	antNest = antNestLoad.instantiate()
	antNest.position = map.get_node("AntNest").position
	add_child(antNest)
	
	await get_tree().create_timer(1.0).timeout
	player = playerLoad.instantiate()
	player.position = map.get_node("Spawn").position
	add_child(player)
	
	var arm = armLoad.instantiate()
	arm.start = player.position
	arm.segments = 30
	arm.segment_size = 0.3
	arm.segment_length = 1
	add_child(arm)

func game_over():
	SceneTransition.change_scene("res://main_menu.tscn")

#func _physics_process(delta):
	#if player != null and $Camera2D.zoom.x >= 1.0:
		#$Camera2D.zoom.x = 4.5 - (player.grow * 1.3)
		#$Camera2D.zoom.y = 4.5 - (player.grow * 1.3)
