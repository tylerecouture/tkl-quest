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
var target : Vector2
var has_external_target = false
var rotate_this_frame = false
var facing_target = false

enum States {
	STOPPED,
	MOVING_BETWEEN_WAYPOINTS,
	ROTATING_TO_FACE_WAYPOINT,
	ROTATING_TO_FACE_EXTERNAL_TARGET,
}

var state = States.ROTATING_TO_FACE_WAYPOINT


func _ready():
	# Save the enemy/object that we want to move around, should be this node's parent
	parent = get_parent()
	
	# get all the Position2D nodes that have been placed under this
	var waypoint_nodes = get_children()  
	
	# check if there are any children, if none were added, then give a helpful message
	if waypoint_nodes.empty():
		printerr(parent, ": No Position2D waypoints have been added to my MovementManager, so I don't know where to move to!")
	
	# but those nodes will move with the parent, so we need to save their global_positions
	for node in waypoint_nodes:
		waypoints.append(node.global_position)

	# final waypoint will be back to the start, this node's position
	# Will always have at least this one waypoint (the start position of the object)
	waypoints.append(global_position)


func _physics_process(delta):
	
	var waypoint : Vector2 = waypoints[current_waypoint_index]
	var vector_to_waypoint := waypoint - parent.global_position
	var distance_to_waypoint := vector_to_waypoint.length()
	var direction_to_waypoint := vector_to_waypoint.normalized()
	
	match state:
		States.STOPPED:
			pass
			
		States.MOVING_BETWEEN_WAYPOINTS:
			parent.move_and_slide(direction_to_waypoint * speed) 
			# after moving, check if they are close enough to switch to the next waypoint
			distance_to_waypoint = (waypoint - parent.global_position).length()
			if distance_to_waypoint < accuracy:
				set_next_waypoint()
			
		States.ROTATING_TO_FACE_WAYPOINT:
			# If facing waypoint, switch states:
#			var angle_to_waypoint =  vector_to_waypoint.angle()
#			print("parent rotation before: ", parent.global_rotation)
#			print("Angle to waypoint: ", angle_to_waypoint)
			target = waypoint
			var target_angle_reached = _rotate_toward_target(delta)
			if target_angle_reached:
				state = States.MOVING_BETWEEN_WAYPOINTS
				
		States.ROTATING_TO_FACE_EXTERNAL_TARGET:
			if target:
				_rotate_toward_target(delta)


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
		
	# go to the next waypoint and turn toward it
	current_waypoint_index += waypoint_direction
	state = States.ROTATING_TO_FACE_WAYPOINT

func _rotate_toward_target(delta):
	# Returns true when target angle is reached
	# https://www.youtube.com/watch?v=ciT_jDol9G8
	var rot = parent.global_rotation
	var vector_to_target = target - parent.global_position
	var angle_to_target = vector_to_target.angle()
	var angle_delta = rotation_speed * delta
	var angle = lerp_angle(rot, angle_to_target, 1) 
#	print("Delta angle: ", angle_delta)
	angle = clamp(angle, rot - angle_delta, rot + angle_delta)
#	print("parent rotation right before: ", parent.global_rotation)
#	print("set to this angle: ", angle)
	parent.global_rotation = angle
#	print("parent rotation should equal angle: ", parent.global_rotation)
	if abs(parent.global_rotation - angle_to_target) < angle_delta:
#		print("target angle reached")
		return true
	else:
		return false
		
func rotate_toward(target_node: Node2D):
	target = target_node.global_position
	has_external_target = true
	state = States.ROTATING_TO_FACE_EXTERNAL_TARGET
	
func resume():
	state = States.ROTATING_TO_FACE_WAYPOINT

