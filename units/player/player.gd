extends Node2D

var scale_speed = 0.01
var health
var max_health
var max_health_tab = [10.0, 20.0, 40.0, 60.0]
var grow = 1.0
var stage = -1
var next_stage = [1.2, 1.5, 2.0, 999.0]
@export var stages = []
var deadLoad = load("res://usables/blood_splash.tscn")

func _ready():
	max_health = max_health_tab[0]
	health = max_health_tab[0]
	get_parent().get_node("Can/HealthBar").max_value = max_health
	get_parent().get_node("Can/HealthBar").value = max_health
	#get_parent().get_node("HealthBar").change_health(max_health, 0.25)
	for i in stages:
		var current = get_node(i)
		current.get_node("StaticBody2D").collision_layer = 0
		current.get_node("Eat").collision_mask = 0
		current.get_node("Hit").collision_layer = 0
	stage_spawn()

func stage_spawn():
	stage += 1
	if stage < len(stages):
		if stage > 0:
			var old = get_node(stages[stage - 1])
			var tween2 = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
			tween2.tween_property(old, "visible", false, 1.0)
			old.queue_free()
		var current = get_node(stages[stage])
		current.get_node("StaticBody2D").collision_layer = 1
		current.get_node("Eat").collision_mask = 8
		current.get_node("Hit").collision_layer = 1
		current.scale = Vector2(1,0)
		current.visible = true
		current.play("eat")
		max_health = max_health_tab[stage]
		health = max_health
		get_parent().get_node("Can/HealthBar").max_value = max_health
		get_parent().get_node("Can/HealthBar").change_health(health, 0.25)
		var tween = create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(current, "scale", Vector2(1,1), 1.0)
	else:
		stage -= 1

func _physics_process(delta):
	#grow += 0.01
	#var temp_size = 1.0 + grow
	#if stage > 0:
		#temp_size -= next_stage[stage - 1]
	#else:
		#temp_size -= 1.0
	if grow >= next_stage[stage]:
		stage_spawn()


func _on_eat_area_entered(area):
	var ran = randi_range(0, 3)
	match ran:
		0: $SEat1.play()
		1: $SEat2.play()
		2: $SEat3.play()
		3: $SEat4.play()
		_: $SEat1.play()
	change_health(area.get_parent().value)
	area.get_parent().kill_yourself()
	grow += area.get_parent().value * scale_speed * get_parent().progress
	var current = get_node(stages[stage])
	current.play("eat")
	var tween = create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(current, "scale", Vector2(1,1.5 - 0.02 * stage * stage), 0.3)
	tween.tween_property(current, "scale", Vector2(1,1), 0.3)


func change_health(amount):
	if health + amount < 0:
		var dead = deadLoad.instantiate()
		dead.position = global_position
		dead.scale.x = 5
		dead.scale.y = 5
		dead.initial_velocity_max = 20
		dead.scale_amount_max = 50
		dead.scale_amount_min = 20
		get_parent().add_child(dead)
		$SDead.play()
		get_parent().game_over()
	elif health + amount > max_health:
		health = max_health
	else:
		health += amount
	get_parent().get_node("Can/HealthBar").change_health(health, 0.25)
