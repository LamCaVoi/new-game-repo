extends Node2D
class_name Level

@export var player: Player
@export var level_layer: TileMapLayer

var used_cell_dict: Dictionary
var curr_collided_tile_rect: Rect2

func _ready() -> void:
	for i in level_layer.get_used_cells():
		used_cell_dict[i] = 1
	Global.curr_level = self


func get_tile_left (rect2: Rect2) -> int:
	return to_global(rect2.position).x

func get_tile_right (rect2: Rect2) -> int:
	return to_global(rect2.position).x + 8
	
func get_tile_top (rect2: Rect2) -> int:
	return to_global(rect2.position).y
	
func get_tile_bottom(rect2: Rect2) -> int:
	return to_global(rect2.position).y + 8

func find_wall() -> int:
	var player_tile : Vector2i = level_layer.local_to_map(to_local(player.global_position))
	for side in range(-1,2,2):
		var position : Vector2 
		var size : Vector2
		if (used_cell_dict.has(player_tile + Vector2i(side, 0))):
			position = level_layer.map_to_local(player_tile + Vector2i(side, 0)) + Vector2(-4,-4)
			if (used_cell_dict.has(player_tile + Vector2i(side, 1))):
				size = Vector2(8,16)
			else:
				size = Vector2(8,8)
		elif(used_cell_dict.has(player_tile + Vector2i(side, 1))):
			position = level_layer.map_to_local(player_tile + Vector2i(side, 1)) + Vector2(-4,4)
			size = Vector2(8,8)
		else:
			continue
		var tile_rect = Rect2(position, size)
		if(intersect(tile_rect,Vector2(side * 3, 0), true)):
			return side
	return 0
	
func check_intersection(offset: Vector2i = Vector2i.ZERO) -> bool:
	var player_tile : Vector2i = level_layer.local_to_map(to_local(player.global_position))
	for i in range(player_tile.x - 1,player_tile.x + 2):
		for j in range(player_tile.y - 2,player_tile.y + 3):
			if (not used_cell_dict.has(Vector2i(i,j))):
				continue
			var tile_rect = Rect2(level_layer.map_to_local(Vector2(i,j)) + Vector2(-4,-4), Vector2(8,8))
			if intersect(tile_rect,offset):
				curr_collided_tile_rect = tile_rect
				return true
	curr_collided_tile_rect = Rect2(Vector2.ZERO, Vector2.ZERO)
	return false
	
func find_edge_x(offset: Vector2) -> Vector2:
	if curr_collided_tile_rect == Rect2(Vector2.ZERO, Vector2.ZERO):
		return Vector2.ZERO
	var tile_coord: Vector2i = level_layer.local_to_map(curr_collided_tile_rect.position + Vector2(4,4))
	for dir in range (-1,2,2):
		if(used_cell_dict.has(tile_coord + Vector2i(0,dir * 1)) and used_cell_dict.has(tile_coord + Vector2i(0,dir * 2))):
			continue
		for i in range(1,4,1):
			if intersect(curr_collided_tile_rect, Vector2i(offset.x, dir * i)):
				continue
			curr_collided_tile_rect = Rect2(Vector2.ZERO, Vector2.ZERO)
			return Vector2(offset.x, dir * i)
	return Vector2.ZERO

func find_edge_y(offset: Vector2) -> Vector2:
	if curr_collided_tile_rect == Rect2(Vector2.ZERO, Vector2.ZERO):
		return Vector2.ZERO
	var tile_coord: Vector2i = level_layer.local_to_map(curr_collided_tile_rect.position + Vector2(4,4))
	for dir in range (-1,2,2):
		if(used_cell_dict.has(tile_coord + Vector2i(dir * 1, 0))):
			continue
		for i in range(1,4,1):
			if intersect(curr_collided_tile_rect, Vector2i(dir * i, offset.y)):
				continue
			curr_collided_tile_rect = Rect2(Vector2.ZERO, Vector2.ZERO)
			return Vector2(dir * i, offset.y)
	return Vector2.ZERO

func intersect(tile: Rect2, offset: Vector2i, wall_detection: bool = false) -> bool:
	#print("Player postion : " + str(player.rect2.position) + " Global postion : " + str(player.get_global_rect()))
	#print("tile postion : " + str(tile.position) + " Global postion : " + str(to_global(tile.position)))
	#print("left : " + str(player.get_left_rect()) + " right : " + str(str(player.get_right_rect())) + " top : " + str(str(player.get_top_rect())) + " bottom : " + str(player.get_bottom_rect()))
	#print("left : " + str(get_tile_left(tile)) + " right : " + str(get_tile_right(tile)) + " top : " + str(get_tile_top(tile)) + " bottom : " + str(get_tile_bottom(tile)))
	return (player.get_left_rect() + offset.x < get_tile_right(tile) and
	player.get_right_rect() + offset.x > get_tile_left(tile) and 
	player.get_top_rect() + player.height * int(wall_detection) * 0.5 + offset.y < get_tile_bottom(tile) and
	player.get_bottom_rect() + offset.y > get_tile_top(tile))
