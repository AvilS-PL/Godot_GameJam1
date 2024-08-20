extends RigidBody2D

var destinition = Vector2.ZERO
var speed = 10

func _integrate_forces(state):
	linear_velocity = (destinition - position).normalized() * speed
