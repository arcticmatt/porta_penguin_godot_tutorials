extends RigidBody2D

const UP_IMPULSE: float = -55.0

func _ready() -> void:
	collision_layer = 0
	set_collision_layer_bit(CollisionLayers.Layers.PENGUIN, true)
	collision_mask = 0
	set_collision_mask_bit(CollisionLayers.Layers.WALL, true)

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_action_pressed("ui_select"):
			_penguin_jump()
			
func _penguin_jump() -> void:
	set_linear_velocity(Vector2(0, 0))
	apply_central_impulse(Vector2(0, UP_IMPULSE))
	$FlapAnimationPlayer.stop()
	$FlapAnimationPlayer.play("Flap")
