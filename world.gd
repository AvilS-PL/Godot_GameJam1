extends Node2D

var planet = Polygon2D.new()

func _ready():
	var mapLoad = load("res://maps/tile_map_1.tscn")
	var map = mapLoad.instantiate()
	add_child(map)

