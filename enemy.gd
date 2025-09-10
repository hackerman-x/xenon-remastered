extends Area2D

var Explosion = preload("res://explosion.tscn")
@export var speed := 200


func _physics_process(delta: float) -> void:
	var direction = Vector2.DOWN.rotated(rotation)
	position += direction * speed * delta

func _make_big_explosion():
	var explosion = Explosion.instantiate()
	add_child(explosion)
	explosion.position = Vector2(400, 200)

	# tell it to play the "normal" explosion
	explosion.play_explosion("blow_up")

func _on_area_entered(area: Area2D) -> void:
	#var explosion = Explosion.instantiate()
	#explosion.animation_name = "enemy"
	#get_tree().root.add_child(explosion)
	queue_free()
