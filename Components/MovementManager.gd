extends Node2D

# To use this node, drop in any number of Position2D nodes into this Movement node
# Place the Position2D "waypoints" where ever you want, and the enemy will move to them

export var speed := 100
export var rotation_speed := PI
export var looping := false  # If true, will go to the start after reaching the end

var waypoints := []
var current_waypoint_index := 0
var waypoint_direction = 1  #  1 = forward, -1 = backward
var parent : KinematicBody2D
var accuracy := 5  # how close to the waypoint before its considered reached
var has_waypoints = true
var target : Node2D
var rotate_this_frame = false


func _ready():
	# Save the enemy/object that we want to move around, should be this node's parent
	parent = get_parent()
	
	# get all the Position2D nodes that have been placed under this
	var waypoint_nodes = get_children()  
	
	# check if there are any children, if none were added, then give a helpful message
	if waypoint_nodes.empty():
		printerr(parent, ": No Position2D waypoints have been added to my MovementManager, so I don't know where to move to!")
		has_waypoints = false
	
	# but those nodes will move with the parent, so we need to save their global_positions
	for node in waypoint_nodes:
		waypoints.append(node.global_position)

	# final waypoint will be back to the start, this node's position
	waypoints.append(global_position)


func _physics_process(delta):
	if has_waypoints:
		var waypoint : Vector2 = waypoints[current_waypoint_index]
		var direction := waypoint - parent.global_position
		
		parent.move_and_slide(direction.normalized() * speed) 
		
		# check if they are close enough to the waypoint to keep going
		var distanct_to_waypoint = (waypoint - parent.global_position).length()
		if distanct_to_waypoint < accuracy:
			set_next_waypoint()
			
	if rotate_this_frame and target:
		var rot = parent.global_rotation
		var vector_to_target = target.global_position - parent.global_position
		var angle = vector_to_target.angle()
		var angle_delta = rotation_speed * delta
		angle=lerp_angle(rot, angle, 1) 
		angle = clamp(angle, rot - angle_delta, rot + angle_delta)
		parent.global_rotation = angle
		rotate_this_frame = false


func set_next_waypoint():
	# first check if there is another waypoint in the list
	if current_waypoint_index + 1 == waypoints.size():
		# We're at the end
		if looping:
			current_waypoint_index = 0  # go back to start position
			return
		else:
			# change direction to go back through waypoints in the opposite direction
			waypoint_direction = -1
	elif waypoint_direction == -1 and current_waypoint_index == 0:
		# we're back at the beginning, so change direction to forward
		waypoint_direction = 1
		
	# go to the next waypoint
	current_waypoint_index += waypoint_direction
	
func rotate_toward(target: Node2D):
	self.target = target
	rotate_this_frame = true

