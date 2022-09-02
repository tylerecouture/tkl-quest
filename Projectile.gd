extends KinematicBody2D

var is_moving = true

export var projectile_speed = 10

export var projectile_damage = 1.2

func _physics_process(delta):
	if is_moving:
		var velocity = Vector2(projectile_speed,0).rotated(rotation)
		move_and_collide(velocity)


func _on_Area2D_body_entered(body):
	is_moving = false
	if "HP" in body:
		body.HP = body.HP - projectile_damage
		queue_free()
	$Area2D/Timer.start()
	


func _on_Timer_timeout():
	queue_free()
