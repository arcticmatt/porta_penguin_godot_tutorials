extends Node2D

func _ready() -> void:
	# Top wall
	_add_wall(Vector2(0, -10), Vector2(1600, 10))
	# Bottom wall, covers grass
	_add_wall(Vector2(0, 900), Vector2(1600, 50))

func _add_wall(position: Vector2, size: Vector2) -> void:
	var rect := RectangleShape2D.new()
	rect.set_extents(size)
	
	var collision_shape := CollisionShape2D.new()
	collision_shape.shape = rect
	var collision_object := StaticBody2D.new()
	collision_object.position = position
	collision_object.add_child(collision_shape)
	
	collision_object.collision_layer = 0
	collision_object.set_collision_layer_bit(CollisionLayers.Layers.WALL, true)
	collision_object.collision_mask = 0
	
	add_child(collision_object)
