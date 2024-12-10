extends Sprite2D


func _ready() -> void:
	fading()

func set_property(_position: Vector2, _scale: Vector2) -> void:
	self.position = _position
	self.scale = _scale
	
func flip(boolean: bool) -> void:
	self.flip_h = boolean
	
func fading() ->void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "self_modulate", Color(1, 1, 1, 0), 0.5)
	
	await tween.finished
	
	queue_free()
