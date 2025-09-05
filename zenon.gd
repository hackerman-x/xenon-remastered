extends CharacterBody2D



const UP_SPEED = 250.0
const ACCELERATION = 700   # how fast we reach top speed
const FRICTION = 900      # how fast we slow down
const MAX_SPEED = 300      # top speed



func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_y := Input.get_axis("Up", "Down")
	if direction_y:
		velocity.y = move_toward(velocity.y, direction_y * UP_SPEED, ACCELERATION * delta)
	else:
		velocity.y = move_toward(velocity.y, 0, FRICTION * delta)


	var direction_x := Input.get_axis("Left", "Right")
	#print ("I'm getting warm! ", direction_x)
	if direction_x < 0:
		#print("I'm in here!!!")
		velocity.x = move_toward(velocity.x, direction_x * MAX_SPEED, ACCELERATION * delta)
	else: 
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
	if Input.is_action_just_pressed("Left"):
		$Zenon_animated.flip_h = false
		$Zenon_animated.play("turn")
	if Input.is_action_just_released("Left"):
		$Zenon_animated.play_backwards("turn")


	if direction_x > 0:
		#print("I'm in here!!!")
		velocity.x = move_toward(velocity.x, direction_x * MAX_SPEED, ACCELERATION * delta)
	else:
		#velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
		pass
	if Input.is_action_just_pressed("Right"):
		$Zenon_animated.flip_h = true
		$Zenon_animated.play("turn")
	if Input.is_action_just_released("Right"):
		$Zenon_animated.play_backwards("turn")
		
	#print("I'm moving ", direction_x)
	#elif direction_x < 0:
		#velocity.x = move_toward(velocity.x, direction_x * MAX_SPEED, ACCELERATION * delta)
		#$Zenon_animated.flip_h = false
		#$Zenon_animated.play("turn")
		##$Zenon_animated.play("stay")
		#$Zenon_animated.play_backwards("turn")
	#else:
		#velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
		#if $Zenon_animated.animation != "idle":
			#$Zenon_animated.play("idle")

	move_and_slide(
		#this also adds something
	)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Shoot"):
		print("vedi vechu")
		
func _ready() -> void:
	$Zenon_animated.play("idle")
