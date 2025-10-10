extends Node2D

func _ready() -> void:
	$AudioStreamPlayer.play()
	$explosion.emitting = true
	
func _on_animated_sprite_2d_animation_finished() -> void:
	$explosion.emitting = false
	queue_free()
