tool
extends TileMap


export var WallScene: PackedScene
export var map_width := 50 setget set_width
export var map_height := 40 setget set_height
#export var density := 0.2
export var steps := 2000 setget set_steps
export var rooms := 3 setget set_rooms

export var regenerate := false setget set_regenerate

var rng := RandomNumberGenerator.new()

var tile_size : Vector2

var wall : Node2D
var keep_building := true
var current_cell := Vector2(0, 0)
var steps_taken := 0

enum direction {
	NORTH,
	NORTHEAST,
	EAST,
	SOUTHEAST,
	SOUTH,
	SOUTHWEST,
	WEST,
	NORTHWEST,
	NORTH,
}

enum State {
	HALL,
	ROOM,
	RANDOM_WALK,
}
var state = State.ROOM

var vectors := {
	direction.NORTH : Vector2(0, -1),
	direction.EAST : Vector2(1, 0),
	direction.SOUTH : Vector2(0, 1),
	direction.WEST : Vector2(-1, 0),
}

var vectors_eight := {
	direction.NORTH : Vector2(0, -1),
	direction.NORTHEAST : Vector2(1, -1),
	direction.EAST : Vector2(1, 0),
	direction.SOUTHEAST : Vector2(1, 1),
	direction.SOUTH : Vector2(0, 1),
	direction.SOUTHWEST : Vector2(-1, 1),
	direction.WEST : Vector2(-1, 1),
	direction.NORTHEAST : Vector2(-1, -1)
}


func _ready():
#	wall = WallScene.instance()
#	tile_size = Vector2(wall.texture.get_width(), wall.texture.get_height())
#	print("Tile Size: ", tile_size)
#	generate_map()
	pass

func set_width(var new_val):
	map_width = new_val
	generate_map()

func set_height(var new_val):
	map_height = new_val
	generate_map()
	
func set_steps(var new_val):
	steps = new_val
	generate_map()	
		
func set_regenerate(var new_val):
	generate_map()
	
func set_rooms(var new_val):
	rooms = new_val
	generate_map()


func generate_map():
	# _ready() doesn't work because it's called when the "tool" is opened, not necessarily everytime the tool is played
	self.clear()
	rng.randomize()
	print("Bleep bloop generating map...")
	
	# Set 0,0 to a tile cus the player will start there.
	self.set_cell(0, 0, 0)
	current_cell = Vector2.ZERO
	
	# random walk:
	
#	keep_building = true
	for step in range(steps):
		var v := get_random_direction_vector()
		var next_cell := current_cell + v
		# make sure we aren't going out of bounds
		if next_cell.x >= -map_width/2 and next_cell.x < map_width/2 and next_cell.y >= -map_height/2 and next_cell.y < map_height/2:
			self.set_cell(next_cell.x, next_cell.y, 0)
			current_cell = next_cell
			steps_taken += 1
#			print(steps_taken, ": ", current_cell)
		
		if steps_taken == steps:
			keep_building = false
	
#	for x in range(map_width):
#		for y in range(map_height):
#			if randf() > density:			
#				self.set_cell(x, y, 0)
#			else:
#				self.set_cell(x, y, 1)

	self.update_bitmask_region()
	
	
func get_random_direction_vector() -> Vector2:
	var v := vectors.values()  # all possible direction vectors
	v.shuffle()
	return v.front()  # return the first one after randomizing them
		

