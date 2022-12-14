extends KinematicBody2D

export var HP = 10
export var Boss_Projectile_Speed = 300

var is_attacking = true
var can_attack = true
var Boss_projectile = preload("res://Level_1_Boss_Projectile.tscn")
var state = Action.IDLE
var is_enemy = true

enum Action {
	IDLE,
	CHARGING_ATTACK,
	ATTACK,
}

func _physics_process(delta):
	if HP <= 0:
		queue_free()


	if is_attacking:
		if can_attack:
			can_attack = false
			$Sprite.play("full_attack")
			state = Action.ATTACK
			yield($Sprite,"animation_finished")
			
			var direction_1 = Vector2(cos(rotation + deg2rad(-15)),sin(rotation))
			var direction_2 = Vector2(cos(rotation + deg2rad(-5)),sin(rotation))
			var direction_3 = Vector2(cos(rotation + deg2rad(5)),sin(rotation))
			var direction_4 = Vector2(cos(rotation + deg2rad(15)),sin(rotation))
			
			var boss_projectile_1 = Boss_projectile.instance()
			var boss_projectile_2 = Boss_projectile.instance()
			var boss_projectile_3 = Boss_projectile.instance()
			var boss_projectile_4 = Boss_projectile.instance()
			
			get_parent().add_child(boss_projectile_1)
			get_parent().add_child(boss_projectile_2)
			get_parent().add_child(boss_projectile_3)
			get_parent().add_child(boss_projectile_4)
			
			boss_projectile_1.apply_central_impulse(direction_1 * Boss_Projectile_Speed)
			boss_projectile_2.apply_central_impulse(direction_2 * Boss_Projectile_Speed)
			boss_projectile_3.apply_central_impulse(direction_3 * Boss_Projectile_Speed)
			boss_projectile_4.apply_central_impulse(direction_4 * Boss_Projectile_Speed)
			
			boss_projectile_1.position = $Orb_spawn_1.global_position
			boss_projectile_2.position = $Orb_spawn_2.global_position
			boss_projectile_3.position = $Orb_spawn_3.global_position
			boss_projectile_4.position = $Orb_spawn_4.global_position
			
			boss_projectile_1.rotation = rotation
			boss_projectile_2.rotation = rotation
			boss_projectile_3.rotation = rotation
			boss_projectile_4.rotation = rotation
			
			$Sprite.play("attack_finished")
			$Attack_Speed_Timer.start()


func _on_Attack_Speed_Timer_timeout():
	can_attack = true
