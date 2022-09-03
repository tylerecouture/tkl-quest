extends MarginContainer

export (NodePath) var player
export (NodePath) var tile_map
export var zoom := 1.5

onready var tilemap: TileMap = get_node(tile_map)
var tilemap_bounds: Rect2

onready var grid := $MarginContainer/Grid
onready var player_marker := $MarginContainer/Grid/PlayerMarker
onready var mob_marker := $MarginContainer/Grid/MobMarker
onready var alert_marker := $MarginContainer/Grid/AlertMarker

onready var texture = $MarginContainer/Grid.texture

onready var icons := {"mob": mob_marker, "alert": alert_marker}

var grid_scale
var markers := {}

func _ready():
	player_marker.position = grid.rect_size / 2
	grid_scale = grid.rect_size / (get_viewport_rect().size * zoom )
	
	# initialize an image for this texture so we can update later
	# https://docs.godotengine.org/en/stable/classes/class_imagetexture.html#class-imagetexture-method-set-data
	
	var image = Image.new()
	image.create(200, 200, true, Image.FORMAT_RGBA8)
	image.fill(Color.red)
	texture.create_from_image(image)
	
	# find the bounds of the tilemap
	if tilemap:
		# https://godotengine.org/qa/118274/how-to-get-max-min-coordinates-from-an-array-of-vector2
		tilemap_bounds = Rect2(0,0,1,1)
		for cell in tilemap.get_used_cells():
			tilemap_bounds = tilemap_bounds.expand(cell)
			
	print(tilemap_bounds)
	
func _process(delta):
	if player:
		player_marker.rotation = get_node(player).rotation + PI  # +180 degrees
	
	if tilemap:
		
		# https://docs.godotengine.org/en/stable/classes/class_image.html#class-image-method-set-pixelv
		var image := Image.new()

		# https://github.com/godotengine/godot/issues/15374#issuecomment-355681002
		image.create(
			tilemap_bounds.end.x - tilemap_bounds.position.x + 1, 
			tilemap_bounds.end.y - tilemap_bounds.position.y + 1, 
			true, Image.FORMAT_RGBA8
		)

		for cell in tilemap.get_used_cells():
			image.lock()
			image.set_pixelv(cell - tilemap_bounds.position, Color.blue)
			image.unlock()
#
		texture.set_data(image)
