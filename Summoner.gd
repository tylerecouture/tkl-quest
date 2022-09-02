extends KinematicBody2D

export var HP = 10
#var bomber = preload()
var target = null
var can_attack = true
var is_enemy = true
var can_rotate = true
var player_in_range = false


enum States {
	ROAMING
	LOCATING_PLAYER
}

var state = States.ROAMING

signal shooting_completed

func _physics_process(delta):

	if HP <= 0:
		if rand_range(0,100) <= 50:
			pass
#			get_parent().add_child(double_fire_rate)
#			double_fire_rate.global_position = global_position
		queue_free()



	match state:
		States.ROAMING:
			pass
		States.LOCATING_PLAYER:
			if player_in_range and can_attack:
				shoot()
			elif can_rotate:
				$MovementManager.rotate_toward(target)








func shoot():
	can_attack = false
	$Sprite.play("Summon")
	yield($Sprite,"animation_finished")
	can_attack = false
	$Attack_Speed_Timer.start()
	$Sprite.play("Idle")
	emit_signal("attack_completed")
	

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

func _on_Attack_Speed_Timer_timeout():
	can_attack = true

func _on_Summoner_shooting_completed():
	if state == States.ROAMING:
		$MovementManager.resume()
