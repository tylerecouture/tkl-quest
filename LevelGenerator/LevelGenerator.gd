tool
extends Node2D

export var WallScene: PackedScene
export var map_width := 32 setget set_width
export var map_height := 18 setget set_height

var tile_size : Vector2

var wall : Node2D

func _ready():
	wall = WallScene.instance()
	tile_size = Vector2(wall.texture.get_width(), wall.texture.get_height())
	print("Tile Size: ", tile_size)
	generate_map()

func set_width(var new_val):
	map_width = new_val
	generate_map()

func set_height(var new_val):
	map_height = new_val
	generate_map()

func generate_map():
	print("Bleep bloop generating map...")

#	for node in get_children():
#		node.queue_free()
#
#	for x in range(map_width):
#		for y in range(map_height):
#			wall = WallScene.instance()
#			add_child(wall)
#			var wall_position = Vector2(tile_size.x * x, tile_size.y * y)
#			print(wall_position)
#			wall.set_position(wall_position)
#

