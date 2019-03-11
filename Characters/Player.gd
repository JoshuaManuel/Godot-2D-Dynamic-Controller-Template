extends RigidBody2D

const FLOOR = Vector2(0, -1)

export var JUMP_HEIGHT = 1000
export var JUMP_LIMIT = 2

var WALK_ACCEL = 75
var WALK_DEACCEL = 75
var WALK_MAX_VELOCITY = 400.0

var AIR_ACCEL = 50
var AIR_DEACCEL = 50

var TERMINAL_VELOCITY = 10000

var jumps_left = JUMP_LIMIT

func _integrate_forces(state):

	var lin_vel = state.linear_velocity
	var delta = state.step

	# Get player controls
	var move_left = Input.is_action_pressed("ui_left")
	var move_right = Input.is_action_pressed("ui_right")
	var move_up = Input.is_action_pressed("ui_up")
	var just_jumped = Input.is_action_just_pressed("ui_up")

	# Find the floor

	# 0. Make sure the player rigidbody2d in the inspector is set to monitor contacts and contacts reported is > 0. I recommend 10

	# 1. Get all bodies we're colliding with

	# 2. Get the normal of those bodies
	# if any one of those is mostly on the floor, set the flags
	# we do the dot product of the floor and colliding body, making sure we're mostly on the floor because 0.6 is greater than .5

	var is_on_floor = false
	var floor_index = -1

	for colliding_body in range(state.get_contact_count()):
		var colliding_body_normal = state.get_contact_local_normal(colliding_body)
		if colliding_body_normal.dot(FLOOR) > 0.6:
			is_on_floor = true
			floor_index = colliding_body
	
	# Handle when the player is on the floor
	if is_on_floor:
		print("on floor")
		jumps_left = JUMP_LIMIT

		if move_left && !move_right:
			if lin_vel.x > -WALK_MAX_VELOCITY:
				lin_vel.x -= WALK_ACCEL
		elif move_right && !move_left:
			if lin_vel.x < WALK_MAX_VELOCITY:
				lin_vel.x += WALK_ACCEL
#		else:
#			var x_vel = abs(lin_vel.x)
#			x_vel -= WALK_DEACCEL
#			if x_vel < 0:
#				x_vel = 0
#			lin_vel.x = sign(lin_vel.x) * x_vel

	# if we're in the air
	else:
		if move_left && !move_right:
			if lin_vel.x > -WALK_MAX_VELOCITY:
				lin_vel.x -= AIR_ACCEL
		elif move_right && !move_left:
			if lin_vel.x < WALK_MAX_VELOCITY:
				lin_vel.x += AIR_ACCEL
		else:
			var x_vel = abs(lin_vel.x)
			x_vel -= AIR_DEACCEL
			if x_vel < 0:
				x_vel = 0
			lin_vel.x = sign(lin_vel.x) * x_vel
	
	# Handle how many jumps the player has left
	if just_jumped && jumps_left > 1:
		lin_vel.y = -JUMP_HEIGHT
		jumps_left -= 1

	#Add gravity and apply the movement
	lin_vel += state.total_gravity * delta
	state.linear_velocity = lin_vel