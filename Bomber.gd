extends KinematicBody2D


export var speed : int
export var HP = 5
export(NodePath) var player_path
onready var player = null



func _ready():
	$Sprite.play("running")








func _physics_process(delta):
	if HP <= 0:
		if rand_range(0,100) <= 50:
			pass
		queue_free()
	
	if player_path != null:
		look_at(player.global_position)
		move_and_slide(Vector2((speed * 60),0).rotated(rotation))










