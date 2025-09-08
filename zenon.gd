extends CharacterBody2D


var newLaser = preload("res://Laser.tscn")
@export var UP_SPEED = 250.0
@export var ACCELERATION = 700   # how fast we reach top speed
@export var FRICTION = 900      # how fast we slow down
@export var MAX_SPEED = 300      # top speed
var can_shoot := true



func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_y := Input.get_axis("Up", "Down")
	if direction_y:
		velocity.y = move_toward(velocity.y, direction_y * UP_SPEED, ACCELERATION * delta)
		if Input.is_action_pressed("Boost"):
			UP_SPEED = 600
			FRICTION = 700
			$Thrusters/Left.play("boost")
			$Thrusters/Right.play("boost")
		elif Input.is_action_just_released("Boost"):
			UP_SPEED = 250.0
			FRICTION = 900
			$Thrusters/Left.play("forward")
			$Thrusters/Right.play("forward")
	else:
		velocity.y = move_toward(velocity.y, 0, FRICTION * delta)
		$Thrusters/Left.play("idle")
		$Thrusters/Right.play("idle")
	if Input.is_action_just_pressed("Up"):
		$Thrusters/Left.play("forward")
		$Thrusters/Right.play("forward")
	elif Input.is_action_just_pressed("Down"):
		$Thrusters/Left.play("back")
		$Thrusters/Right.play("back")


	var direction_x := Input.get_axis("Left", "Right")
	#print ("I'm getting warm! ", direction_x)
	if direction_x < 0: # Moving left now. 
		velocity.x = move_toward(velocity.x, direction_x * MAX_SPEED, ACCELERATION * delta)
	elif direction_x == 0: 
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
	if Input.is_action_just_pressed("Left"):
		$Zenon_animated.flip_h = false
		$Zenon_animated.play("turn")
	if Input.is_action_just_released("Left"):
		$Zenon_animated.play_backwards("turn")


	if direction_x > 0:
		velocity.x = move_toward(velocity.x, direction_x * MAX_SPEED, ACCELERATION * delta)
	elif direction_x == 0:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
		
		
	if Input.is_action_just_pressed("Right"):
		$Zenon_animated.flip_h = true
		$Zenon_animated.play("turn")
	if Input.is_action_just_released("Right"):
		$Zenon_animated.play_backwards("turn")


	if Input.is_action_pressed("Shoot") and can_shoot:
		var laser = newLaser.instantiate()
		laser.position = position
		get_tree().root.add_child(laser)
		
		can_shoot = false
		$ShootTimer.start()
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

	move_and_slide()
	

func _input(event: InputEvent) -> void:
	pass
	
		
func _ready() -> void:
	pass


func _on_shoot_timer_timeout() -> void:
	can_shoot = true
