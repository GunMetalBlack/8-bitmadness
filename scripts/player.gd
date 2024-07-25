extends CharacterBody2D


const SPEED = 50.0
const JUMP_VELOCITY = -150.0
var FALL_GRAVITY := 500 
var Coyote_Time: float = 0.2
#Yup screw normal gravity conventions
var gravity = 250
var canJump: bool = true
@onready var coyote_timer = $Coyote_Timer

@onready var animated_sprite_2d = $AnimatedSprite2D

func  _ready():
	Calculate_Movement_Variables()

func Calculate_Movement_Variables():
	FALL_GRAVITY = (2*JUMP_VELOCITY)/pow(0.65,2)
	gravity = (2*JUMP_VELOCITY)/pow(0.65,2)
	

func get_gravity(velocity: Vector2):
	if velocity.y < 0:
		return gravity
	return FALL_GRAVITY

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		if canJump:
			if coyote_timer.is_stopped():
				coyote_timer.start(Coyote_Time)
			get_tree().create_timer(Coyote_Time).timeout.connect(Coyote_Timeout)
		velocity.y -= get_gravity(velocity) * delta
	else:
		canJump = true
		coyote_timer.stop()
	#if Input.is_action_just_released("jump") and velocity.y < 0:
		#velocity.y = JUMP_VELOCITY / 4
	# Handle jump.
	if Input.is_action_pressed("jump") and canJump:
		velocity.y = JUMP_VELOCITY
		canJump = false
	# gets input direction -1 , 0 , -1
	var direction = Input.get_axis("move_left", "move_right")
	
	if is_on_floor():
		if direction == 0: 
			animated_sprite_2d.play("idle")
		else :
			animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("jump")
		
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
func Coyote_Timeout():
	canJump = false


