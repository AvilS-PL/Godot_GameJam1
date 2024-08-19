extends CanvasLayer

func change_scene(target: String):
	$Animation.play("in")
	await $Animation.animation_finished
	get_tree().change_scene_to_file(target)
	$Animation.play_backwards("in")
