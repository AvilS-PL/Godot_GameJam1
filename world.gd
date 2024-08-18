extends Node2D

var planet = Polygon2D.new()

func _ready():
	pass
	#planet.polygon = poly_circle(800,400)
	#add_child(planet)

func poly_circle(c_radius, c_quality):
	var angle = (PI * 2) / c_quality
	var vector = Vector2(c_radius, 0)
	var points: PackedVector2Array
	for i in c_quality:
		var temp_vector = vector
		#var temp_vector = vector * randf_range(0.99,1.0)
		#points.append(round(vector*10)/10)
		points.append(temp_vector)
		vector = vector.rotated(angle)
	return points


#func _process(delta):
	#if Input.is_action_pressed("ui_right"):
		#planet.rotation += 0.01
	#if Input.is_action_pressed("ui_left"):
		#planet.rotation -= 0.01
