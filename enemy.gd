extends Area2D

@export var speed := 200


func _physics_process(delta: float) -> void:
	var direction = Vector2.DOWN.rotated(rotation)
	position += direction * speed * delta



func _on_area_entered(area: Area2D) -> void:
	$Enemy_animated.play("blow_up")
	queue_free()
