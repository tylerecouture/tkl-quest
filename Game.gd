extends Node2D

onready var player = $Player
onready var nav = $Navigation2D


func _on_Enemy_Path_Timer_timeout():
	get_tree().call_group("Enemy", "get_target_path", player.global_position)
