extends MarginContainer

export (NodePath) var player_path
export (NodePath) var tilemap_path
#export var zoom := 1.5

onready var player: KinematicBody2D = get_node(player_path)
onready var tilemap: TileMap = get_node(tilemap_path)

var tilemap_bounds: Rect2
var tilemap_size: Vector2

onready var rect := $Frame/MarginContainer/TextureRect
onready var player_marker := $Frame/MarginContainer/TextureRect/PlayerMarker
#onready var mob_marker := $MarginContainer/TextureRect/MobMarker
#onready var alert_marker := $MarginContainer/TextureRect/AlertMarker

onready var texture = rect.texture

#onready var icons := {"mob": mob_marker, "alert": alert_marker}

var markers := {}
var map_texture_size : Vector2 # the original texture size so we don't "print" beyond it
var map_center : Vector2
var map_offset : Vector2
var map_scale

func _ready():
	map_texture_size = rect.rect_size
	map_center = map_texture_size / 2	
	
	# initialize an image for this texture so we can update later
	# https://docs.godotengine.org/en/stable/classes/class_imagetexture.html#class-imagetexture-method-set-data
	var image = Image.new()
	image.create(map_texture_size.x, map_texture_size.y, true, Image.FORMAT_RGBA8)
	image.fill(Color.red)
	texture.create_from_image(image) 
	
	# find the bounds of the tilemap
	if tilemap:
		# https://godotengine.org/qa/118274/how-to-get-max-min-coordinates-from-an-array-of-vector2
		tilemap_bounds = Rect2(0,0,1,1)
		for cell in tilemap.get_used_cells():
			tilemap_bounds = tilemap_bounds.expand(cell)
			
	tilemap_size = tilemap_bounds.size
	
	map_scale = calc_map_scale()
	
func _process(delta):
	if player:
		player_marker.position = get_player_minimap_position()
		player_marker.rotation = player.rotation
		# convert the player's position into a tilemap coord
		# https://docs.godotengine.org/en/stable/classes/class_tilemap.html#class-tilemap-method-world-to-map
		
		map_offset = get_player_tilemap_coords() - map_center
	
	if tilemap:
		
		# https://docs.godotengine.org/en/stable/classes/class_image.html#class-image-method-set-pixelv
		var image := Image.new()

		# https://github.com/godotengine/godot/issues/15374#issuecomment-355681002
#		image.create(
#			tilemap_bounds.end.x - tilemap_bounds.position.x + 1, 
#			tilemap_bounds.end.y - tilemap_bounds.position.y + 1, 
#			true, Image.FORMAT_RGBA8
#		)
		image.create(map_texture_size.x, map_texture_size.y, true, Image.FORMAT_RGBA8)

		for cell in tilemap.get_used_cells():
			image.lock()
			image.set_pixelv(cell - tilemap_bounds.position, Color.blue)
			image.unlock()
			
		# Resize the map image to match the texture
		texture.set_data(image)
		
		rect.rect_scale = Vector2(map_scale, map_scale)
		
func get_player_tilemap_coords():
	var local_pos = tilemap.to_local(player.global_position)
	return tilemap.world_to_map(local_pos)
	
func get_player_minimap_position():
	return get_player_tilemap_coords() - tilemap_bounds.position
	
func calc_map_scale():
	var scale_x = map_texture_size.x / tilemap_size.x
	var scale_y = map_texture_size.y / tilemap_size.y
	return min(scale_x, scale_y)
