extends Area2D

var speed :int = 35

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position.y += speed * delta

func pickup() -> void:
	$Laser.visible = false
	var player = Global.zenon_ref
	player.powerUp()
	position = player.global_position

	

func _on_end_timer_timeout() -> void:
	queue_free()


func _on_timer_timeout() -> void:
	queue_free()
