extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


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
