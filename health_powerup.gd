extends Area2D

var speed :int = 35

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position.y += speed * delta


func _on_area_entered(area: Area2D) -> void:
	$Health.visible = false
	$AudioStreamPlayer.play()
	if area.is_in_group("Player"):
		var player = get_tree().root.get_node("Starting Screen/THE GAME/Main/Zenon")
		player.regen()
		position = player.global_position
		$Timer.start()


func _on_timer_timeout() -> void:
	queue_free()
	

func _on_end_timer_timeout() -> void:
	queue_free()
