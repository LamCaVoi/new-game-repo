extends Node2D
class_name Level

@onready var player: Player = $Player
@onready var level_layer: TileMapLayer = $LevelTileMapLayer

var used_cell_dict: Dictionary

func _ready() -> void:
	for i in level_layer.get_used_cells():
		used_cell_dict[i] = 1
	Global.curr_level = self


func get_left_other (rect2: Rect2) -> int:
	return to_global(rect2.position).x

func get_right_other (rect2: Rect2) -> int:
	return to_global(rect2.position).x + 8
	
func get_top_other (rect2: Rect2) -> int:
	return to_global(rect2.position).y
	
func get_bottom_other(rect2: Rect2) -> int:
	return to_global(rect2.position).y + 8

func check_intersection(offset: Vector2i = Vector2i.ZERO):
	
	var player_tile : Vector2i = level_layer.local_to_map(to_local(player.global_position))
	for i in range(player_tile.x - 1,player_tile.x + 2):
		for j in range(player_tile.y - 2,player_tile.y + 3):
			if (not used_cell_dict.has(Vector2i(i,j))):
				continue
			var tile_rect = Rect2(level_layer.map_to_local(Vector2(i,j)) + Vector2(-4,-4), Vector2(8,8))
			if intersect(tile_rect,offset):
				return true
	return false

func intersect(other: Rect2, offset: Vector2i) -> bool:
	#print("Player postion : " + str(player.rect2.position) + " Global postion : " + str(player.get_global_rect()))
	#print("other postion : " + str(other.position) + " Global postion : " + str(to_global(other.position)))
	#print("left : " + str(player.get_left_other_rect()) + " right : " + str(str(player.get_right_other_rect())) + " top : " + str(str(player.get_top_other_rect())) + " bottom : " + str(str(player.get_bottom_other_rect())))
	#print("left : " + str(get_left_other(other)) + " right : " + str(get_right_other(other)) + " top : " + str(get_top_other(other)) + " bottom : " + str(get_bottom_other(other)))
	var res : bool = (player.get_left_rect() + offset.x < get_right_other(other) and
	player.get_right_rect() + offset.x > get_left_other(other) and 
	player.get_top_rect() + offset.y < get_bottom_other(other) and
	player.get_bottom_rect() + offset.y > get_top_other(other))
	return res
