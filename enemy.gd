extends Area2D

var Explosion = preload("res://enemy_explosion.tscn")
@export var speed := 200


func _physics_process(delta: float) -> void:
	var direction = Vector2.DOWN.rotated(rotation)
	position += direction * speed * delta

func explode():
	# Spawn the explosion
	var explosion = Explosion.instantiate()
	explosion.global_position = global_position
	get_tree().root.add_child(explosion)

	# Remove the enemy itself
	queue_free()
	

func _on_area_entered(_area: Area2D) -> void:
	pass
