extends Line2D


var start = 180.0
@export var segments = 10
@export var segment_size: float = 1.0
@export var segment_length = 10


func _ready():
	for i in segments:
		add_point(Vector2(100 + i*segment_length, 180))
	var tween = create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	tween.tween_property(self,"start", 130.0, 1.0)


func _physics_process(delta):
	points[0] = get_global_mouse_position()
	for i in get_point_count() - 2:
		points[i+1] = ((points[i+1] - points[i]).normalized() * segment_length) + points[i]
	
	points[get_point_count() - 1] = Vector2(100,start)
	for i in get_point_count() - 1:
		i = get_point_count() - i - 2
		points[i] = ((points[i] - points[i + 1]).normalized() * segment_length) + points[i + 1]
	
	for i in get_point_count() - 2:
		var angle01 = rad_to_deg(points[i].angle_to_point(points[i+1]))
		var angle12 = rad_to_deg(points[i+2].angle_to_point(points[i+1]))
		var odp
		if angle01 * angle12 >= 0:
			odp = abs(angle01) - abs(angle12)
		else:
			odp = abs(angle01) + abs(angle12)
		odp = abs(odp)
		#if odp < 90:
			#points[i] = points[i+1] + Vector2(sin(deg_to_rad(90)),cos(deg_to_rad(90))) * segment_length
	#for i in get_point_count() - 1:
		#if points[i].angle_to_point(points[i+1]) > 90
		#points[i+1] = ((points[i+1] - points[i]).normalized() * segment_length) + points[i]

#function ConstrainDistance(point, anchor, distance) {
  #return ((point - anchor).normalize() * distance) + anchor;
#}
func rotated_point(_center, _angle, _distance):
	return _center + Vector2(sin(_angle),cos(_angle)) * _distance
