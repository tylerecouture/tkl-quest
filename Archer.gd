extends KinematicBody2D

var Arrow = preload("res://Archer_Arrow.tscn")

var can_rotate = true

var target = null

var can_shoot = true

var accuracy = 10

var player_in_range = false

func _physics_process(delta):
	if can_shoot:
		if player_in_range:
			can_shoot = false
			shoot()
	
	if can_rotate:
		if player_in_range:
			if target != null:
				$MovementManager.rotate_toward(target)


func shoot():
	can_rotate = false
	$Sprite.play("Shooting")
	yield($Sprite,"animation_finished")
	var arrow = Arrow.instance()
	arrow.rotation = rotation 
	arrow.position = $Arrow_spawn.global_position
	get_parent().add_child(arrow)
	$Fire_Rate_Timer.start()
	$Sprite.play("Idle")
	can_rotate = true

func _on_Fire_Rate_Timer_timeout():
	can_shoot = true



func _on_sense_body_entered(body):
	player_in_range = true
	target = body



func _on_sense_body_exited(body):
	player_in_range = false
	target = null
