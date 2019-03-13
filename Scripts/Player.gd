extends RigidBody2D

export var WALK_ACCEL = 800.0
export var WALK_DEACCEL = 800.0
export var WALK_MAX_VELOCITY = 200.0
export var AIR_ACCEL = 200.0
export var AIR_DEACCEL = 200.0
export var JUMP_VELOCITY = 1000
export var STOP_JUMP_FORCE = 900.0
export var JUMP_LIMIT = 2

const FLOOR = Vector2(0, -1)
var TERMINAL_VELOCITY = 10000
var jumps_left = JUMP_LIMIT
var is_falling = false
var is_jumping = false

func _integrate_forces(state):

	var lin_vel = state.linear_velocity
	var delta = state.step

	# Get player controls
	var move_left = Input.is_action_pressed("ui_left")
	var move_right = Input.is_action_pressed("ui_right")
	var move_up = Input.is_action_pressed("ui_up")
	var just_jumped = Input.is_action_just_pressed("ui_up")

	# Find the floor
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
		lin_vel.y = -JUMP_VELOCITY
		jumps_left -= 1

	#Add gravity and apply the movement
	lin_vel += state.total_gravity * delta
	state.linear_velocity = lin_vel