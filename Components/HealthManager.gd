extends Node



export var HP = 10




func _on_HealthManager_body_entered(body):
	HP = HP - body.projectile_damage
	print(HP)

