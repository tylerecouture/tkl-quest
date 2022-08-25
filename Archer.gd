extends KinematicBody2D

var Arrow = preload("res://Archer_Arrow.tscn")

var can_rotate = true
var target = null
var can_shoot = true
var accuracy = 10
var player_in_range = false

enum States {
	ROAMING
	LOCATING_PLAYER
}

var state = States.ROAMING

signal shooting_completed

func _physics_process(delta):
	match state:
		States.ROAMING:
			# $MovementManager takes care of roaming
			pass
		States.LOCATING_PLAYER:
			if player_in_range and can_shoot:
				shoot()			
			elif can_rotate:
				$MovementManager.rotate_toward(target)

func shoot():
	can_shoot = false
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
	emit_signal("shooting_completed")

func _on_Fire_Rate_Timer_timeout():
	can_shoot = true

func _on_sense_body_entered(body):
	target = body
	state = States.LOCATING_PLAYER

func _on_sense_body_exited(body):
	state = States.ROAMING
	if can_rotate:
		$MovementManager.resume()

func _on_line_of_fire_body_entered(body):
	player_in_range = true
	
func _on_line_of_fire_body_exited(body):
	player_in_range = false

func _on_Archer_shooting_completed():
	if state == States.ROAMING:
		$MovementManager.resume()
