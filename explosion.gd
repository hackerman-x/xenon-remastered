extends Node2D

@onready var anim = $AnimatedSprite2D

func _ready() -> void:
	var anim = $AnimatedSprite2D
	anim.play("bullet_blow_up")  # or "normal" depending on how you want it
	anim.connect("animation_finished", Callable(self, "_on_anim_finished"), CONNECT_ONE_SHOT)


func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
