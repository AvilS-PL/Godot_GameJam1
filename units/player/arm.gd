extends Line2D

var scale_speed = 0.01
@export var speed = 1
@export var start = Vector2(160,140)
@export var segments = 200
@export var segment_size: float = 1.0
@export var segment_length = 1
var eatLoad = load("res://units/player/eat.tscn")
var dest = Vector2.ZERO
var def_width = 14

var selected = true

#var max_size = 1 na razie to samo co slots
var slots = 1

var catch = []
var areas = []

func _ready():
	dest = start
	width = def_width * segment_size
	$Fing.scale.x = segment_size * 1.5
	$Fing.scale.y = segment_size * 1.5
	$Fing.play("open")
	for i in segments:
		add_point(start)

func _physics_process(delta):
	if selected:
		dest = dest.move_toward(get_global_mouse_position(), speed)
		if Input.is_action_just_pressed("left_mb"):
			try_catch()
		if Input.is_action_just_released("left_mb"):
			$Fing.play("open")
			for i in catch:
				i.get_parent().collision_layer = 1
				i.collision_layer = 8
				i.get_parent().go_back()
			catch.clear()
		if Input.is_action_pressed("left_mb") and Input.is_action_just_pressed("right_mb"):
			try_eat()
	if dest.x > start.x + segments*segment_length + 1:
		dest.x = start.x + segments*segment_length + 1
	if dest.x < start.x - segments*segment_length - 1:
		dest.x = start.x - segments*segment_length - 1
	if dest.y > start.y + segments*segment_length + 1:
		dest.y = start.y + segments*segment_length + 1
	if dest.y < start.y - segments*segment_length - 1:
		dest.y = start.y - segments*segment_length - 1
	
	#prevent collapse
	#for i in get_point_count() - 2:
	for i in get_point_count() - 2:
		var p1 = points[get_point_count() - 1 - i] - points[get_point_count() - 2 - i]
		var p_main = points[get_point_count() - 2 - i] - start
		var p2 = points[get_point_count() - 3 - i] - points[get_point_count() - 2 - i]
		
		var ang1 = p1.angle()
		#if ang1 < 0: ang1 += 2*PI
		var ang2 = p2.angle()
		#if ang2 < 0: ang2 += 2*PI
		#if ang1 > ang2: print(ang1 - ang2)
		#else: print(ang2 - ang1)
			
		var ang_main = abs(ang1-ang2)
		var ang_main_reduced = ang_main
		if ang_main_reduced > PI: ang_main_reduced = 2*PI - ang_main
		var b_a = PI/2.2
		#print(ang_main_reduced)
		if ang1 < ang2:
			if ang_main > PI:
				if ang_main_reduced < PI/b_a:
					var pos_main = Vector2(segment_length * cos(ang1-PI/b_a), segment_length * sin(ang1-PI/b_a))
					#"l1"
					pos_main += points[get_point_count() - 2 - i]
					points[get_point_count() - 3 - i] = pos_main
			else:
				if ang_main_reduced < PI/2:
					var pos_main = Vector2(segment_length * cos(ang1+PI/b_a), segment_length * sin(ang1+PI/b_a))
					#"p1"
					pos_main += points[get_point_count() - 2 - i]
					points[get_point_count() - 3 - i] = pos_main
		else:
			if ang_main > PI:
				if ang_main_reduced < PI/b_a:
					var pos_main = Vector2(segment_length * cos(ang1+PI/b_a), segment_length * sin(ang1+PI/b_a))
					#"p2"
					pos_main += points[get_point_count() - 2 - i]
					points[get_point_count() - 3 - i] = pos_main
			else:
				if ang_main_reduced < PI/b_a:
					var pos_main = Vector2(segment_length * cos(ang1-PI/b_a), segment_length * sin(ang1-PI/b_a))
					#"l1"
					pos_main += points[get_point_count() - 2 - i]
					points[get_point_count() - 3 - i] = pos_main
		#if abs(ang1 - ang2) > PI:
			#ang_main = 2*PI - abs(ang1 - ang2)
			#print(ang_main, "l")
			#if ang_main < PI/2:
				#var pos_main = Vector2(segment_length * cos(ang1-PI/2), segment_length * sin(ang1-PI/2))
				#print(ang_main, " | ", pos_main)
				#points[get_point_count() - 3 - i] = pos_main
		#elif (ang1 > 0 and ang2 <0) or (ang1 < 0 and ang2 > 0):
			#print(ang_main)
		#else:
			#if ang1 > ang2:
				#print(ang_main, "l")
			#else:
				#print(ang_main)
	
	#calculate postions for each
	points[get_point_count() - 1] = dest
	for i in get_point_count() - 1:
		i = get_point_count() - i - 2
		points[i] = limit_points(points[i], points[i+1])
	
	#for i in get_point_count() - 2:
			#var p1 = get_point_count() - i - 1
			#for j in get_point_count() - i - 3 :
				#var p2 = p1 - j - 1
				#if points[p1].distance_to(points[p2]) < segment_length:
					#points[p2] = limit_points(points[p2], points[p1])
	
	#limit to start point
	#points[0] = start
	#for i in get_point_count() - 1:
		#points[i+1] = limit_points(points[i+1], points[i])
	
	#for i in get_point_count() - 1:
		#if points[i+1].y > 130:
			#points[i+1].y = 130
	$Fing.position = points[get_point_count() - 1]
	$Fing.rotation = points[get_point_count() - 1].angle_to_point(points[get_point_count() - 2]) - deg_to_rad(90)
	for i in catch:
		i.get_parent().global_position = points[get_point_count() - 1]

func try_catch():
	$Fing.play("close")
	var targets = []
	for i in areas:
		if i.get_parent().size <= slots:
			targets.append(i)
	if targets.size() > 0:
		var temp_slots = slots
		var temp_i = 0
		while temp_slots > 0:
			if targets.size() > temp_i:
				targets[temp_i].get_parent().collision_layer = 0
				targets[temp_i].collision_mask = 0
				catch.append(targets[temp_i])
				temp_slots -= targets[temp_i].get_parent().size
				temp_i += 1
			else:
				break

func try_eat():
	if catch.size() > 0:
		for i in catch:
			if segment_size < 1.0:
				segment_size += i.get_parent().value * scale_speed * get_parent().progress
			i.get_parent().kill_yourself()
		catch.clear()
		width = def_width * segment_size
		$Fing.scale.x = segment_size * 1.5
		$Fing.scale.y = segment_size * 1.5
		slots = ceil(segment_size / 0.2)
		print(slots)
		while segment_size * 100 > segments:
			add_point(points[get_point_count() - 1])
			segments += 1
		var ran = randi_range(0, 3)
		match ran:
			0: $SEat1.play()
			1: $SEat2.play()
			2: $SEat3.play()
			3: $SEat4.play()
			_: $SEat1.play()
		var eat = eatLoad.instantiate()
		eat.start = points[get_point_count() - 1]
		eat.segment_size = segment_size
		eat.segment_length = ceil(segments/50.0)
		eat.abc = get_point_count() - 3
		add_child(eat)
	

func limit_points(point, anchor):
	return ((point - anchor).normalized() * segment_length) + anchor

func _on_area_2d_area_entered(area):
	areas.append(area)

func _on_area_2d_area_exited(area):
	areas.remove_at(areas.find(area, 0))
