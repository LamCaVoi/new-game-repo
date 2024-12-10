extends Node2D
class_name Level

@export var player: Player
@export var level_layer: TileMapLayer

var used_cell_dict: Dictionary
var curr_collided_tile_rect: Rect2
var edge_detected : bool = false

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Reset"):
		get_tree().reload_current_scene()
		

func _ready() -> void:
	for i in level_layer.get_used_cells():
		used_cell_dict[i] = 1
	Global.curr_level = self

func find_wall(x_offset_amount) -> int:
	var player_tile : Vector2i = level_layer.local_to_map(to_local(player.global_position))
	var player_rect : Rect2 = player.rect2
	player_rect.position += Vector2(0, player_rect.size.y/2)
	player_rect.size.y *= 0.5
	player_rect = Rect2(player.global_position + player_rect.position,player.rect2.size)
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
		if (intersect(player_rect,tile_rect,Vector2(side * x_offset_amount, 0))):
			return side
	return 0
	
func check_player_tiles_intersection(offset: Vector2i = Vector2i.ZERO) -> bool:
	var player_tile : Vector2i = level_layer.local_to_map(to_local(player.global_position))
	for i in range(player_tile.x - 1,player_tile.x + 2):
		for j in range(player_tile.y - 2,player_tile.y + 3):
			if (not used_cell_dict.has(Vector2i(i,j))):
				continue
			var tile_rect = Rect2(level_layer.map_to_local(Vector2(i,j)) + Vector2(-4,-4), Vector2(8,8))
			if intersect(Rect2(player.global_position + player.rect2.position,player.rect2.size),tile_rect,offset):
				curr_collided_tile_rect = tile_rect
				return true
	curr_collided_tile_rect = Rect2(Vector2.ZERO, Vector2.ZERO)
	return false
	
func check_player_solids_intersection(offset: Vector2i = Vector2i.ZERO)->bool:
	return false

func check_intersection(offset: Vector2i = Vector2i.ZERO, edge_detection_enabled: bool = false) -> Vector2i:
	if (check_player_solids_intersection()):
		return Vector2i.ZERO
	if (not check_player_tiles_intersection(offset)):
		return offset 
	if offset.x != 0:
		if edge_detection_enabled:
			return find_tile_edge_x(offset)
		return Vector2i.ZERO
	return find_tile_edge_y(offset) if edge_detection_enabled else Vector2.ZERO

func find_tile_edge_x(offset: Vector2) -> Vector2:
	if curr_collided_tile_rect == Rect2(Vector2.ZERO, Vector2.ZERO):
		return Vector2.ZERO
	var tile_coord: Vector2i = level_layer.local_to_map(curr_collided_tile_rect.position + Vector2(4,4))
	for dir in range (-1,2,2):
		if(used_cell_dict.has(tile_coord + Vector2i(0,dir * 1)) or used_cell_dict.has(tile_coord + Vector2i(0,dir * 2))):
			continue
		for i in range(1,3,1):
			if intersect(Rect2(player.global_position + player.rect2.position,player.rect2.size), curr_collided_tile_rect, Vector2(offset.x, dir * i)):
				continue
			curr_collided_tile_rect = Rect2(Vector2.ZERO, Vector2.ZERO)
			edge_detected = true
			return Vector2(offset.x, dir * i)
	edge_detected = false
	return Vector2.ZERO

func find_tile_edge_y(offset: Vector2) -> Vector2:
	if curr_collided_tile_rect == Rect2(Vector2.ZERO, Vector2.ZERO) or edge_detected:
		edge_detected = false
		return Vector2.ZERO
	var tile_coord: Vector2i = level_layer.local_to_map(curr_collided_tile_rect.position + Vector2(4,4))
	for dir in range (-1,2,2):
		if(used_cell_dict.has(tile_coord + Vector2i(dir * 1, 0))):
			continue
		for i in range(1,4,1):
			if intersect(Rect2(player.global_position + player.rect2.position,player.rect2.size), curr_collided_tile_rect, Vector2(dir * i, offset.y)):
				continue
			curr_collided_tile_rect = Rect2(Vector2.ZERO, Vector2.ZERO)
			return Vector2(dir * i, offset.y)
	return Vector2.ZERO

func intersect(rect1: Rect2, rect2: Rect2, offset_rect1: Vector2i = Vector2i.ZERO, offset_rect2: Vector2i = Vector2i.ZERO) -> bool:
	return (rect1.position.x + offset_rect1.x < rect2.position.x + rect2.size.x + offset_rect2.x
	and rect1.position.x + rect1.size.x  + offset_rect1.x > rect2.position.x + offset_rect2.x
	and rect1.position.y  + offset_rect1.y < rect2.position.y + rect2.size.y + offset_rect2.y
	and rect1.position.y + rect1.size.y  + offset_rect1.y > rect2.position.y + offset_rect2.y)
	
	
	
	
