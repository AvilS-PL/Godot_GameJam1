extends Line2D

var start = Vector2(0,0)
var segments = 10
var segment_size: float = 1.0
var segment_length = 1
var abc = 0
var a = 0

func _ready():
	a = abc
	width = width * segment_size
	add_point(start)

func _physics_process(delta):
	for i in get_point_count():
		if abc + i*segment_length >= 0:
			points[i] = get_parent().points[abc + i*segment_length]
	abc -= segment_length
	if get_point_count() < segments:
		add_point(get_parent().points[a])
	if abc <= -(segments*segment_length):
		queue_free()
