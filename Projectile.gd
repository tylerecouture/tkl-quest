extends KinematicBody2D

var is_moving = true

export var dagger_speed = 10



func _physics_process(delta):
	if is_moving:
		var velocity = Vector2(dagger_speed,0).rotated(rotation)
		move_and_collide(velocity)


func _on_Area2D_body_entered(body):
	is_moving = false
	$Area2D/Timer.start()


func _on_Timer_timeout():
	queue_free()
