extends KinematicBody2D

export var speed : int
export var accuracy = deg2rad(5)

var powerup : String

var double_fire_rate = false

var can_throw = true

var Projectile = preload("res://Projectile.tscn")





var state = Action.IDLE

enum Action {
	IDLE,
	WALK_FORWARD,
	THROW_DAGGER,
}


func _process(delta):
	
	var direction = Vector2.ZERO
	var moving = false
	
	if can_throw:
		if Input.is_action_pressed("throw_projectile"):
			throw()
	
	look_at(get_global_mouse_position())
	
	if Input.is_action_pressed("move_right"):
		direction.x += 1
		moving = true
	
	if Input.is_action_pressed("move_left"):
		direction.x += -1
		moving = true
	
	if Input.is_action_pressed("move_up"):
		direction.y += 1
		moving = true
	
	if Input.is_action_pressed("move_down"):
		direction.y += -1
		moving = true
	
	
	if state != Action.THROW_DAGGER:
		if moving:
			$Sprite.play("Walking_forward")
			state = Action.WALK_FORWARD
	
		else:
			$Sprite.play("Idle")
			state = Action.IDLE

	move_and_slide(direction.normalized() * speed) 



func throw():
	can_throw = false
	if double_fire_rate:
		$Sprite.flip_h = not $Sprite.flip_h
		$Hand.position.y = $Hand.position.y * -1
	$Sprite.play("Dagger_throw")
	state = Action.THROW_DAGGER
	yield($Sprite,"animation_finished")
	state = Action.IDLE
	var projectile = Projectile.instance()
	projectile.position = $Hand.global_position
	projectile.rotation = rotation + rand_range(-accuracy, accuracy)
	get_parent().add_child(projectile)
	$Fire_Rate_Timer.start()


func _on_Fire_Rate_Timer_timeout():
	can_throw = true


func _on_Powerup_Sensor_area_entered(area):
	
	powerup = area.name
	if powerup == "double_fire_rate":
		double_fire_rate = true
		$Fire_Rate_Timer.wait_time = .15
		
		








