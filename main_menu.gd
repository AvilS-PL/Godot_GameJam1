extends Control

var savePath = "user://highscore.save"
var score = 11
# Called when the node enters the scene tree for the first time.
func _ready():
	$Menu/Button/Label.text = "NEW GAME"
	$Menu/Button2/Label.text = "CONTINUE"
	$Menu/Button3/Label.text = "OPTIONS"
	$Menu/Button4/Label.text = "EXIT"
	
	$Menu/Button.connect("clicked", clicked)
	$Menu/Button2.connect("clicked", clicked)
	$Menu/Button3.connect("clicked", clicked)
	$Menu/Button4.connect("clicked", clicked)
	
	var mapLoad = load("res://maps/tile_map_0.tscn")
	var map = mapLoad.instantiate()
	add_child(map)
	if FileAccess.file_exists(savePath):
		var file = FileAccess.open(savePath, FileAccess.READ)
		$Scorebar/Label.text = "Highscore:\n" + str(file.get_var(score))
	else:
		$Scorebar/Label.text = "Highscore:\n0"

func clicked(what):
	if what == "EXIT":
		await get_tree().create_timer(0.1).timeout
		get_tree().quit()
	elif what == "OPTIONS":
		print("opt")
	elif what == "CONTINUE":
		print("play cont")
	elif what == "NEW GAME":
		SceneTransition.change_scene("res://world.tscn")
