extends KinematicBody2D

export var arrow_speed = 10
 


func _physics_process(delta):
	var velocity = Vector2(0,-arrow_speed).rotated(rotation - deg2rad(-90))
	move_and_collide(velocity)


func _ready():
	$Vanis_Timer.start()




		


func _on_Vanis_Timer_timeout():
	queue_free()
