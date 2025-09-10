extends Area2D

var Explosion = preload("res://explosion.tscn")
@export var speed := 400

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Laser_animated.play("bigger")

func _physics_process(delta):
	var direction = Vector2.UP.rotated(rotation)
	position += direction * speed * delta

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemies"):
		# Enemy explosion
		var explosion = Explosion.instantiate()
		explosion.global_position = area.global_position
		get_tree().root.add_child(explosion)

		# Remove enemy + bullet
		area.queue_free()
		queue_free()
	else:
		# Bullet explosion (wall/anything else)
		var explosion = Explosion.instantiate()
		explosion.global_position = global_position
		get_tree().root.add_child(explosion)

		# Remove only the bullet
		queue_free()
