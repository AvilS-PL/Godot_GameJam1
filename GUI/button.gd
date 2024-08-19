extends TextureButton

signal clicked
#$Label.add_theme_font_size_override("font_size", 8)
var down = false

func _on_button_down():
	down = true
	$Label.position.x = -2
	$Label.position.y = 0.5

func _on_button_up():
	down = false
	$Label.position.x = 0
	$Label.position.y = 0

func _on_pressed():
	clicked.emit($Label.text)

func _on_mouse_exited():
	$Label.position.x = 0
	$Label.position.y = 0

func _on_mouse_entered():
	if down:
		$Label.position.x = -2
		$Label.position.y = 0.5
