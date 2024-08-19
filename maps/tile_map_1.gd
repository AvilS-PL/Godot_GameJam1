extends TileMap

func _on_cloud_timer_timeout():
	var cloudLoad = load("res://maps/cloud.tscn")
	var cloud = cloudLoad.instantiate()
	cloud.position = Vector2(370, randi_range(0, 30))
	cloud.z_index = randi_range(-3, -2)
	add_child(cloud)
	$CloudTimer.wait_time = randf_range(5.0, 6.0)
	$CloudTimer.start()
