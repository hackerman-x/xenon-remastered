extends Area2D

var Explosion = preload("res://Explosions/explosion.tscn")
@export var speed := 500

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Laser_animated.play("bigger")
	$AudioStreamPlayer.play()

func _physics_process(delta):
	var direction = Vector2.DOWN.rotated(rotation)
	position += direction * speed * delta

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_area_entered(area):
	if area.is_in_group("Player"):
		# spawn bullet explosion at bullet's position
		var bex = Explosion.instantiate()
		bex.global_position = global_position
		get_tree().root.add_child(bex)
		
		

		# remove the bullet
		queue_free()
	else:
		# hit something else -> just spawn bullet explosion
		var bex = Explosion.instantiate()
		bex.global_position = global_position
		get_tree().root.add_child(bex)
		queue_free()
