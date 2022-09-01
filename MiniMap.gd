extends MarginContainer

export (NodePath) var player
export var zoom := 1.5

onready var grid := $MarginContainer/Grid
onready var player_marker := $MarginContainer/Grid/PlayerMarker
onready var mob_marker := $MarginContainer/Grid/MobMarker
onready var alert_marker := $MarginContainer/Grid/AlertMarker

onready var icons := {"mob": mob_marker, "alert": alert_marker}

var grid_scale
var markers := {}

func _ready():
	player_marker.position = grid.rect_size / 2
	grid_scale = grid.rect_size / (get_viewport_rect().size * zoom )
	
func _process(delta):
	if !player:
		return
		
	player_marker.rotation = get_node(player).rotation + PI  # +180 degrees
