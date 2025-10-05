extends CharacterBody2D


var newLaser = preload("res://Laser.tscn")
var Explosion = preload("res://Explosions/player_explosion.tscn")


@export var health := 9
@export var UP_SPEED = 250.0
@export var ACCELERATION = 700   # how fast we reach top speed
@export var FRICTION = 900      # how fast we slow down
@export var MAX_SPEED = 300      # top speed
var can_shoot := true
var rect :ColorRect
var faster := false
var fastest := false
var slow := false
var idle := true



func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_y := Input.get_axis("Up", "Down")
	if direction_y:
		idle = false
		velocity.y = move_toward(velocity.y, direction_y * UP_SPEED, ACCELERATION * delta)
		if Input.is_action_pressed("Up"):
			slow = false
			faster = true
			if Input.is_action_pressed("Boost"):
				fastest = true
				UP_SPEED = 450
				FRICTION = 600
				$Thrusters/Left.play("boost")
				$Thrusters/Right.play("boost")
			elif Input.is_action_just_released("Boost"):
				fastest = false
				UP_SPEED = 250.0
				FRICTION = 900
				$Thrusters/Left.play("forward")
				$Thrusters/Right.play("forward")
		if Input.is_action_pressed("Down"):
			slow = true
			UP_SPEED = 250.0
			FRICTION = 900
	else:
		idle = true
		slow = false
		faster = false
		velocity.y = move_toward(velocity.y, 0, FRICTION * delta)
		$Thrusters/Left.play("idle")
		$Thrusters/Right.play("idle")
	if Input.is_action_just_pressed("Up"):
		$Thrusters/Left.play("forward")
		$Thrusters/Right.play("forward")
	elif Input.is_action_just_pressed("Down"):
		$Thrusters/Left.play("back")
		$Thrusters/Right.play("back")
#
#
	var direction_x := Input.get_axis("Left", "Right")
	if direction_x < 0: # Moving left now. 
		velocity.x = move_toward(velocity.x, direction_x * MAX_SPEED, ACCELERATION * delta)
	elif direction_x == 0: 
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
	if Input.is_action_just_pressed("Left"):
		$Zenon_animated.flip_h = false
		$Zenon_animated.play("turn")
	if Input.is_action_just_released("Left"):
		$Zenon_animated.play_backwards("turn")
#
#
	if direction_x > 0:
		velocity.x = move_toward(velocity.x, direction_x * MAX_SPEED, ACCELERATION * delta)
	elif direction_x == 0:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
#
#
	if Input.is_action_just_pressed("Right"):
		$Zenon_animated.flip_h = true
		$Zenon_animated.play("turn")
	if Input.is_action_just_released("Right"):
		$Zenon_animated.play_backwards("turn")


	if Input.is_action_pressed("Shoot") and can_shoot:
		var laser = newLaser.instantiate()
		laser.position = position
		var parent_node = get_tree().root.get_node("Starting Screen/THE GAME/Main/Laser")
		parent_node.add_child(laser)
#
		can_shoot = false
		$ShootTimer.start()

	move_and_slide()
	


func _ready() -> void:
	Global.zenon_ref = self
	rect = get_parent().get_node("Health")


func _on_shoot_timer_timeout() -> void:
	can_shoot = true

func regen() -> void:
	rect.size.x = 200
	health = 9


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("EnemyBullet"):
		rect.size.x -= 20
		if health > 0:
			health -= 1
		elif health == 0:
			var explosion = Explosion.instantiate()
			var camera = get_tree().root.get_node("Starting Screen/THE GAME/Main/Camera")
			camera.start_shake(50)
			explosion.global_position = global_position
			get_tree().root.add_child(explosion)
			
			visible = false
			queue_free()
			
