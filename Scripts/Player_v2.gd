extends RigidBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _integrate_forces(state):
	#print("Hello" + String(state.step))
	var lv = state.linear_velocity
	
	#gather movement
	var move_left = Input.is_action_pressed("ui_left")
	var move_left_released = Input.is_action_just_released("ui_left")
	var move_right = Input.is_action_pressed("ui_right")
	var move_right_released = Input.is_action_just_released("ui_right")
	var move_up = Input.is_action_pressed("ui_up")
	var move_up_just_pressed = Input.is_action_just_pressed("ui_up")
	var move_up_just_released = Input.is_action_just_released("ui_up")
	
	if move_left:
		lv.x = -500
	if move_right:
		lv.x = 500
	if move_left_released || move_right_released:
		#print("Just released")
		lv.x = 0
	if move_up_just_pressed:
		lv.y = -900
	if !move_up && !$RayCast2D.is_colliding():
		lv.y += 15
	#deal with wall collisions

	if $RayCast2D.is_colliding() && !move_up:
		#print("on the ground!")
		physics_material_override.friction = .1
		lv.y = 0
	else:
		physics_material_override.friction = 0
	
	state.linear_velocity = lv

func negate_friction():
	physics_material_override.friction = 0


func _on_Right_Side_body_entered(body):
	print("right")
	negate_friction()


func _on_Left_Side_body_entered(body):
	print("Left")
	negate_friction()

