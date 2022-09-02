extends KinematicBody2D


export var speed = 100
export var HP = 5

var Player = preload("res://Player.tscn")
var player = Player.instance()


func _ready():
	$Sprite.play("running")
	
func _physics_process(delta):

	if HP <= 0:
		if rand_range(0,100) <= 50:
			pass
#			get_parent().add_child(double_fire_rate)
#			double_fire_rate.global_position = global_position
		queue_free()
	
	look_at(player.global_position)
	
	
	
	
	move_and_slide(Vector2(speed,0).rotated(rotation))
	$Sprite.play("running")
