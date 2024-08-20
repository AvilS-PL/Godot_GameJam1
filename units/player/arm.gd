extends Line2D

@export var speed = 1
@export var start = Vector2(160,140)
@export var segments = 200
@export var segment_size: float = 1.0
@export var segment_length = 1
var eatLoad = load("res://units/player/eat.tscn")
var dest = Vector2.ZERO

func _ready():
	dest = start
	width = width * segment_size
	$Fing.scale.x = segment_size * 1.5
	$Fing.scale.y = segment_size * 1.5
	for i in segments:
		add_point(start)


func _physics_process(delta):
	dest = dest.move_toward(get_global_mouse_position(), speed)
	if dest.x > start.x + segments*segment_length + 1:
		dest.x = start.x + segments*segment_length + 1
	if dest.x < start.x - segments*segment_length - 1:
		dest.x = start.x - segments*segment_length - 1
	if dest.y > start.y + segments*segment_length + 1:
		dest.y = start.y + segments*segment_length + 1
	if dest.y < start.y - segments*segment_length - 1:
		dest.y = start.y - segments*segment_length - 1
	points[get_point_count() - 1] = dest
	for i in get_point_count() - 2:
		i = get_point_count() - i - 2
		points[i] = limit_points(points[i], points[i+1])
	
	points[0] = start
	for i in get_point_count() - 1:
		points[i+1] = limit_points(points[i+1], points[i])
	
	#for i in get_point_count() - 1:
		#if points[i+1].y > 130:
			#points[i+1].y = 130
	$Fing.position = points[get_point_count() - 1]
	$Fing.rotation = points[get_point_count() - 1].angle_to_point(points[get_point_count() - 2]) - deg_to_rad(90)
	if Input.is_action_just_pressed("left_mb"):
		try_eat()


func try_eat():
	var eat = eatLoad.instantiate()
	eat.start = points[get_point_count() - 1]
	eat.segment_size = segment_size
	eat.segment_length = ceil(segments/50.0)
	eat.abc = get_point_count() - 3
	add_child(eat)


func limit_points(point, anchor):
	return ((point - anchor).normalized() * segment_length) + anchor
