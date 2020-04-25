extends StaticBody2D

# Initially at 0, characters are made to move by the ObjectPool.
var g_velocity: float = 0

func _process(_delta: float) -> void:
	position.x += g_velocity

# @note: for ObjectPool.
func get_height() -> float:
	return $Sprite.texture.get_size().y * scale.y * $Sprite.scale.y
	
# @note: for ObjectPool.
func reset() -> void:
	g_velocity = 0
	
# @note: for ObjectPool.
func start(velocity: float) -> void:
	g_velocity = -velocity
	$AnimationPlayer.play('Walk')
