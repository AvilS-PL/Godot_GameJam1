extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	var mapLoad = load("res://maps/tile_map_1.tscn")
	var map = mapLoad.instantiate()
	add_child(map)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
