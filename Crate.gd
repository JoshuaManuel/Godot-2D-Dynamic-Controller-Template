extends KinematicBody2D
class_name Crate

export var GRAVITY = 20
export var FRICTION = .9
var motion = Vector2(0, 0)

const UP = Vector2(0, -1)

func _physics_process(delta):
	motion.y += GRAVITY
	
	apply_friction()
	motion = move_and_slide(motion, UP)

func push(velocity: Vector2) -> void:
	velocity.y = velocity.y * 0 #get rid of vertical movement from the player
	motion = move_and_slide(velocity, UP)
	
func apply_friction():
	if is_on_floor():
		motion.x = lerp(0, motion.x, FRICTION)