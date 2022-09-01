extends KinematicBody2D

export var HP = 10
var Arrow = preload("res://Archer_Arrow.tscn")
var Double_Fire_Rate = preload("res://x2_fire_rate.tscn")
var double_fire_rate = Double_Fire_Rate.instance()
var can_rotate = true
var target = null
var can_shoot = true
var accuracy = 10
var player_in_range = false
var is_enemy = true

enum States {
	ROAMING
	LOCATING_PLAYER
	DEAD
}

var state = States.ROAMING

signal shooting_completed

func _physics_process(delta):

	if HP <= 0:
		if rand_range(0,100) <= 50:
			get_parent().add_child(double_fire_rate)
			double_fire_rate.global_position = global_position
		queue_free()


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
	arrow.position = $Arrow_Spawn.global_position
	get_parent().add_child(arrow)
	$Attack_Speed_Timer.start()
	$Sprite.play("Idle")
	can_rotate = true
	emit_signal("shooting_completed")

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

func _on_Area2D_body_entered(body):
	HP = HP - body.projectile_damage
	print(HP)

func _on_Attack_Speed_Timer_timeout():
	can_shoot = true
