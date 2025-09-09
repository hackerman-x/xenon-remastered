extends Area2D

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
	$Laser_animated.play("blow_up")
	#queue_free()
