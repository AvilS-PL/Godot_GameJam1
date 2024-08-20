extends Node2D

var health = 30.0
var max_health = 30.0
var grow = 1.0
var stage = -1
var next_stage = [1.5, 2.5, 4.0, 999.0]
var static_body = [5, 8, 16, 23]
@export var stages = []

func _ready():
	stage_spawn()

func stage_spawn():
	stage += 1
	if stage < len(stages):
		if stage > 0:
			var old = get_node(stages[stage - 1])
			var tween2 = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
			tween2.tween_property(old, "visible", false, 1.0)
		var current = get_node(stages[stage])
		current.scale = Vector2(1,0)
		current.visible = true
		current.play("close")
		var tween = create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(current, "scale", Vector2(1,1), 1.0)
	else:
		stage -= 1

func _physics_process(delta):
	$Body/CollisionShape2D.shape.radius = move_toward($Body/CollisionShape2D.shape.radius,static_body[stage],1.0)
	var temp_size = 1.0 + grow
	if stage > 0:
		temp_size -= next_stage[stage - 1]
	else:
		temp_size -= 1.0
	if grow >= next_stage[stage]:
		stage_spawn()
	#grow += 0.01
