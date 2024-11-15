extends Node2D

var walls
func _ready() -> void:
	walls = get_tree().get_nodes_in_group("Walls")

func is_colliding(player: HitBox, offset: Vector2):
	
	for wall in walls:
		if player.intersect(wall, offset):
			
			return true
	return false
