extends MarginContainer

export (NodePath) var player_path
export (NodePath) var tilemap_path
export (Color) var fog_color
export (Color) var map_color
#export var zoom := 1.5
export (int) var sight_distance = 10

onready var player: KinematicBody2D = get_node(player_path)
onready var tilemap: TileMap = get_node(tilemap_path)

var tilemap_bounds: Rect2
var tilemap_size: Vector2

onready var player_marker := $Frame/MarginContainer/TextureRect/PlayerMarker

onready var rect := $Frame/MarginContainer/TextureRect
onready var texture = rect.texture

#onready var mob_marker := $MarginContainer/TextureRect/MobMarker
#onready var alert_marker := $MarginContainer/TextureRect/AlertMarker

onready var fog_texture_rect = $Frame/MarginContainer/FogTextureRect
onready var fog_texture = fog_texture_rect.texture

#onready var icons := {"mob": mob_marker, "alert": alert_marker}

var markers := {}
var map_fog = []
var map_texture_size : Vector2 # the original texture size so we don't "print" beyond it
var map_center : Vector2
var map_offset : Vector2
var map_scale
var map_texture_rect : Rect2

func _ready():
	map_texture_size = rect.rect_size
	map_texture_rect = Rect2(Vector2(0,0), map_texture_size)
	
	# initialize an images forthe textures so we can update later
	texture.create_from_image(create_blank_minimap_image()) 
	fog_texture.create_from_image(create_blank_minimap_image())
	
	# find the bounds of the tilemap
	if tilemap:
		# https://godotengine.org/qa/118274/how-to-get-max-min-coordinates-from-an-array-of-vector2
		tilemap_bounds = Rect2(0,0,1,1)
		for cell in tilemap.get_used_cells():
			tilemap_bounds = tilemap_bounds.expand(cell)
			
	tilemap_size = tilemap_bounds.size
	
	map_scale = calc_map_scale()
	initialize_fog()
	
func _process(delta):
	if player:
		player_marker.position = get_player_minimap_position()
		player_marker.rotation = player.rotation
		clear_fog()
	
	if tilemap:
		
		# https://docs.godotengine.org/en/stable/classes/class_image.html#class-image-method-set-pixelv
		var image := create_blank_minimap_image()
		for cell in tilemap.get_used_cells():
			image.lock()
			image.set_pixelv(cell - tilemap_bounds.position, map_color)
			image.unlock()
		texture.set_data(image)
		
		# redraw the fog texture's image
		image = create_blank_minimap_image()
		for x in range(map_fog.size()):
			for y in range(map_fog[0].size()):
				if map_fog[x][y]:
					image.lock()
					image.set_pixel(x, y, fog_color) # clear the fog
					image.unlock()
		fog_texture.set_data(image)
		
		rect.rect_scale = Vector2(map_scale, map_scale)
		fog_texture_rect.rect_scale = Vector2(map_scale, map_scale)
		
func get_player_tilemap_coords():
	var local_pos = tilemap.to_local(player.global_position)
	return tilemap.world_to_map(local_pos)
	
func get_player_minimap_position():
	return get_player_tilemap_coords() - tilemap_bounds.position
	
func calc_map_scale():
	var scale_x = map_texture_size.x / tilemap_size.x
	var scale_y = map_texture_size.y / tilemap_size.y
	return min(scale_x, scale_y)
	
func create_blank_minimap_image(fill_color:=Color(0,0,0,0)) -> Image:
	# https://docs.godotengine.org/en/stable/classes/class_imagetexture.html#class-imagetexture-method-set-data
	var image = Image.new()
	image.create(map_texture_size.x, map_texture_size.y, true, Image.FORMAT_RGBA8)
	image.fill(fill_color)
	return image
	
func initialize_fog():
	# sets every location to true = not visited = foggy
	for x in range(map_texture_size.x):
		map_fog.append([])
		for y in range(map_texture_size.y):
			map_fog[x].append([true])
			
func clear_fog():
	# start by scanning a square of pixels around the player
#	print(player_marker.position)
	map_fog[player_marker.position.x][player_marker.position.y] = false
	for x in range(-sight_distance, sight_distance):
		for y in range(-sight_distance, sight_distance):
			var p = Vector2(x,y) + player_marker.position
#			if p.x >=0 and p.y >=0 and p.x < map_texture_size.x and p.y < map_texture_size.y:
			if map_texture_rect.has_point(p):
				if p.distance_to(player_marker.position) < sight_distance:
					map_fog[p.x][p.y] = false
			
#			var p := Vector2(x, y)
			# but only count if within radius
#			if p.length() < sight_distance:
#				var point = p + player_marker.position
#				if map_texture_rect.has_point(point):  # Make sure we don't go outside of the image
#					map_fog[x][y] = false
#					print(x,y)
