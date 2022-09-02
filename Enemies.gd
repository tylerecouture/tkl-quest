extends KinematicBody2D

export var HP = 10


var is_enemy = true
var can_attack = true


func _physics_process(delta):

	if HP <= 0:
		if rand_range(0,100) <= 50:
			pass
#			get_parent().add_child(double_fire_rate)
#			double_fire_rate.global_position = global_position
		queue_free()



func _on_Attack_Speed_Timer_timeout():
	can_attack = true
