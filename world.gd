extends Node2D

var planet = Polygon2D.new()

var progress = 1.0
var score = 0

var savePath = "user://highscore.save"

#Loads
var mapLoad = load("res://maps/tile_map_0.tscn")
var map
var playerLoad = load("res://units/player/player.tscn")
var player
var armLoad = load("res://units/player/arm.tscn")
var antNestLoad = load("res://units/ant/ant_nest.tscn")
var ratLoad = load("res://units/rat/rat.tscn")
var dogLoad = load("res://units/dog/dog.tscn")

var spawn = Vector2.ZERO
var path = Vector2.ZERO
var tier = 0

func _ready():
	start_game()
	$Tier.stop() #!!!

func start_game():
	
	map = mapLoad.instantiate()
	add_child(map)
	spawn = map.get_node("Spawn").position
	path = map.get_node("Path2D/PathFollow2D")
	
	$Camera2D.position = map.get_node("Spawn").position
	$Camera2D.zoom = Vector2(3.2,3.2)
	
	#await get_tree().create_timer(1.0).timeout #!!!
	#spawn_ant_nest(45) #!!!
	player = playerLoad.instantiate()
	player.position = spawn
	add_child(player)
	
	var arm = armLoad.instantiate()
	arm.start = player.position + Vector2(0, 1)
	arm.segments = 20 #15!!!
	arm.segment_size = 0.3 #0.15!!!
	arm.segment_length = 3 #1 !!!
	player.grow = 1.4#absent !!!
	add_child(arm)

func game_over():
	if FileAccess.file_exists(savePath):
		var file = FileAccess.open(savePath, FileAccess.READ)
		var save_score = file.get_var(score)
		if save_score < score:
			var file2 = FileAccess.open(savePath, FileAccess.WRITE)
			file2.store_var(score)
	else:
		var file = FileAccess.open(savePath, FileAccess.WRITE)
		file.store_var(score)
	SceneTransition.change_scene("res://main_menu.tscn")

func spawn_ant_nest(radius):
	var antNest = antNestLoad.instantiate()
	antNest.destinition = spawn
	var rand = randi_range(0, 360)
	antNest.position = Vector2(radius * sin(deg_to_rad(rand)), radius * cos(deg_to_rad(rand))) + spawn
	add_child(antNest)


func next_tier():
	progress *= 0.96
	tier += 1
	if tier < 3:
		spawn_ant_nest(45 + 5 * tier)
	elif tier == 3:
		$MouseSpawn.start()
	elif tier < 6:
		$MouseSpawn.wait_time -= 1.0
	elif tier == 6:
		$DogSpawn.start()
	elif tier < 9:
		$DogSpawn.wait_time -= 1.0
	elif tier > 15:
		print($MouseSpawn.wait_time)
		if $MouseSpawn.wait_time > 0.2:
			$MouseSpawn.wait_time -= 0.05
		if $DogSpawn.wait_time > 0.2:
			$DogSpawn.wait_time -= 0.05

func _physics_process(delta):
	if player != null and $Camera2D.zoom.x >= 0.8:
		$Camera2D.zoom.x = move_toward($Camera2D.zoom.x, 4.5 - (player.grow * 1.3), 0.1) 
		$Camera2D.zoom.y = move_toward($Camera2D.zoom.y, 4.5 - (player.grow * 1.3), 0.1) 

func score_up(amount):
	score += amount * 100
	$Can/Scorebar/Label.text = str(score)


func _on_mouse_spawn_timeout():
	path.progress_ratio = randf()
	var rat = ratLoad.instantiate()
	rat.destinition = spawn
	rat.position = path.position
	add_child(rat)


func _on_tier_timeout():
	next_tier()


func _on_dog_spawn_timeout():
	path.progress_ratio = randf()
	var dog = dogLoad.instantiate()
	dog.destinition = spawn
	dog.position = path.position
	add_child(dog)
