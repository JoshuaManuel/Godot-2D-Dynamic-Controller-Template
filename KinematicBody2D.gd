extends KinematicBody2D

export var GRAVITY = 20
export var JUMP_HEIGHT = 600
export var SPEED = 300
export var PUSH_SPEED = 150

const JUMPS_LIMIT = 2
var jumps = 0
var sides_entered = true

const UP = Vector2(0, -1)
onready var motion = Vector2(0, 0)

func _physics_process(delta):
	print("physics loop")
	
	#handle input
	if Input.is_action_pressed("ui_left"):
		motion.x = -SPEED
		move_crates(-PUSH_SPEED)
	if Input.is_action_pressed("ui_right"):
		motion.x = SPEED
		move_crates(PUSH_SPEED)
	
	#if left and right keys are unpressed
	if !Input.is_action_pressed("ui_right") && !Input.is_action_pressed("ui_left"):
		motion.x = 0
		
	if Input.is_action_just_pressed("ui_up"):
			var jumped = jump()
	
	if is_on_floor():
		jumps = 0
	
	#handle gravity
	motion.y += GRAVITY
	print(motion)
	
	#move!
	motion = move_and_slide(motion, UP)
	

func move_crates(push_direction):
	for col in range(0, get_slide_count()-1):
		var collision_object = get_slide_collision(col).collider
		if collision_object.has_method("push") && is_on_wall():
			motion.x = push_direction
			collision_object.push(motion)
			
	
	
func jump():
	if jumps < JUMPS_LIMIT:
		jumps += 1
		motion.y = -JUMP_HEIGHT
		return true
	else:
		return false

func _on_Sides_body_entered(body):
	sides_entered = true
	print("TRUE")



func _on_Sides_body_exited(body):
	sides_entered = false
	print("F")
