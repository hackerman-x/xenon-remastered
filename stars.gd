extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# pick one random delay between 1–5 seconds
	var delay = randf_range(1.0, 5.0)
	
	# start the repeating loop
	run_animation_loop(delay)

func run_animation_loop(delay: float) -> void:
	await get_tree().create_timer(delay).timeout
	$AnimatedSprite2D.play("default")
	
	# call again to repeat (with the same delay each time)
	run_animation_loop(delay)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
