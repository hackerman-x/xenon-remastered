extends CharacterBody2D


const SPEED = 300.0
const UP_SPEED = 200.0


func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_y := Input.get_axis("Up", "Down")
	if direction_y:
		velocity.y = direction_y * UP_SPEED
	else:
		velocity.y = move_toward(velocity.x, 0, UP_SPEED)


	var direction_x := Input.get_axis("Left", "Right")
	if direction_x:
		velocity.x = direction_x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
