extends Line2D


var start = 180.0
@export var segments = 50
@export var segment_size: float = 1.0
@export var segment_length = 2


func _ready():
	for i in segments:
		add_point(Vector2(100 + i*segment_length, 180))
	var tween = create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	tween.tween_property(self,"start", 130.0, 1.0)


func _physics_process(delta):
	points[get_point_count() - 1] = get_global_mouse_position()
	for i in get_point_count() - 2:
		i = get_point_count() - i - 2
		points[i] = ((points[i] - points[i + 1]).normalized() * segment_length) + points[i + 1]
	
	points[0] = Vector2(100,start)
	for i in get_point_count() - 1:
		points[i+1] = ((points[i+1] - points[i]).normalized() * segment_length) + points[i]
	
	for i in get_point_count() - 1:
		if points[i+1].y > 130:
			points[i+1].y = 130
	#never ever touch this shit, i was working on it and at the end after spending several hours it still doesn't work
	#for i in get_point_count() - 9:
		#var a1 = atan2(points[i].x - points[i+1].x, points[i].y - points[i+1].y)
		#var a2 = atan2(points[i+2].x - points[i+1].x, points[i+2].y - points[i+1].y)
		#var odp = rad_to_deg(a1 - a2)
		#if odp < 0: odp += 360
		#if odp < 90:
			#var diff = points[i+2] - points[i+1]
			#points[i] = diff.rotated(deg_to_rad(-90)) + points[i+1]
		#if odp > 270:
			#var diff = points[i+2] - points[i+1]
			#points[i] = diff.rotated(deg_to_rad(-90)) + points[i+1]
