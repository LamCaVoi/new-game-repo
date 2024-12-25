extends Node2D
class_name Level

const PLAYER_HORIZONTAL_RANGE = 1
const PLAYER_VERTICAL_RANGE = 2
const TILE_SIZE = Vector2(8,8)

@export var player: Player
@export var level_layer: TileMapLayer
@export var solids: Array[Solid]
@export var camera: Camera2D

var used_cell_dict: Dictionary
var curr_collided_tile_rect: Rect2
var edge_detected : bool = false
var player_tile : Vector2i
var player_rect : Rect2 

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Reset"):
		get_tree().reload_current_scene()

func _ready() -> void:
	for i in level_layer.get_used_cells():
		used_cell_dict[i] = 1
	Global.curr_level = self
	camera.player = self.player

func update_player():
	player_tile = level_layer.local_to_map(to_local(player.global_position))
	player_rect = Rect2(player.global_position + player.rect2.position,player.rect2.size)

func check_player_intersection(offset: Vector2i = Vector2i.ZERO, edge_detection_enabled: bool = false) -> Vector2i:
	update_player()
	if (check_player_solids_intersection(offset)):
		return Vector2.ZERO
	if (not check_player_tiles_intersection(offset)):
		return offset 
	if(not edge_detection_enabled):
		return Vector2.ZERO
	return find_tile_edge_x(offset) if offset.x != 0 else find_tile_edge_y(offset)

func check_player_tiles_intersection(offset: Vector2i = Vector2i.ZERO) -> bool:
	var res: bool = false
	if (offset.x != 0):
		res = check_horizontal_collision(offset)
	if (not res and offset.y != 0):
		res = check_vertical_collision(offset)
	return res
	
		
func check_horizontal_collision(offset: Vector2i, rect: Rect2 = player_rect, tile_coord: Vector2i = player_tile, horizontal_range: int = PLAYER_HORIZONTAL_RANGE, vertical_range: int = PLAYER_VERTICAL_RANGE, is_player: bool = true) -> bool:
	var dir = sign(offset.x)
	for y in range(tile_coord.y - vertical_range, tile_coord.y + vertical_range + 1):
		for x in range (1,horizontal_range + 1):
			if (not used_cell_dict.has(Vector2i(tile_coord.x + x * dir,y))):
				continue
			var tile_rect = Rect2(level_layer.map_to_local(Vector2(tile_coord.x + x * dir,y)) + TILE_SIZE * -0.5, TILE_SIZE)
			if intersect(rect,tile_rect,offset):
				if(is_player):
					curr_collided_tile_rect = tile_rect
				return true
	if(is_player):
		curr_collided_tile_rect = Rect2(Vector2.ZERO, Vector2.ZERO)
	return false

func check_vertical_collision(offset: Vector2i, rect: Rect2 = player_rect, tile_coord: Vector2i = player_tile, horizontal_range: int = PLAYER_HORIZONTAL_RANGE, vertical_range: int = PLAYER_VERTICAL_RANGE, is_player: bool = true) -> bool:
	var dir = sign(offset.y)
	for x in range(tile_coord.x - horizontal_range, tile_coord.x + horizontal_range + 1):
		for y in range (1,vertical_range + 1):
			if (not used_cell_dict.has(Vector2i(x, tile_coord.y + y * dir))):
				continue
			var tile_rect = Rect2(level_layer.map_to_local(Vector2(x, tile_coord.y + y * dir)) + TILE_SIZE * -0.5, TILE_SIZE)
			if intersect(rect,tile_rect,offset):
				if(is_player):
					curr_collided_tile_rect = tile_rect
				return true
	if(is_player):
		curr_collided_tile_rect = Rect2(Vector2.ZERO, Vector2.ZERO)
	return false

func check_player_solids_intersection(offset: Vector2i = Vector2i.ZERO)->bool:
	for solid in solids:
		if intersect(player_rect,Rect2(solid.get_rect().position + solid.global_position, solid.get_rect().size),offset):
			return true
	return false

func find_wall(x_offset_amount) -> int:
	update_player()
	player_rect.position += Vector2(0, player_rect.size.y * 0.5)
	player_rect.size.y *= 0.5
	for direction in range(-1,2,2):
		if check_player_solids_intersection(Vector2(direction * x_offset_amount, 0)):
			return direction
		var position : Vector2 = Vector2.ZERO
		var size : Vector2 = Vector2.ZERO
		for y in range (0,2):
			if (used_cell_dict.has(Vector2i(player_tile.x + direction, y))):
				if size == Vector2.ZERO:
					position = level_layer.map_to_local(Vector2(player_tile.x + direction, player_tile.y + 1)) + TILE_SIZE * -0.5
				size.y += TILE_SIZE.y
		if size == Vector2.ZERO:
			continue
		size.x = TILE_SIZE.x
		var tile_rect = Rect2(position, size)
		if (intersect(player_rect,tile_rect,Vector2(direction * x_offset_amount, 0))):
			return direction
	return 0

func find_tile_edge_x(offset: Vector2) -> Vector2:
	if curr_collided_tile_rect == Rect2(Vector2.ZERO, Vector2.ZERO):
		return Vector2.ZERO
	var tile_coord: Vector2i = level_layer.local_to_map(curr_collided_tile_rect.position + Vector2(4,4))
	for dir in range (-1,2,2):
		if(used_cell_dict.has(tile_coord + Vector2i(0,dir * 1)) or used_cell_dict.has(tile_coord + Vector2i(0,dir * 2))):
			continue
		for i in range(1,4,1):
			if intersect(player_rect, curr_collided_tile_rect, Vector2(offset.x, dir * i)):
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
			if intersect(player_rect, curr_collided_tile_rect, Vector2(dir * i, offset.y)):
				continue
			curr_collided_tile_rect = Rect2(Vector2.ZERO, Vector2.ZERO)
			return Vector2(dir * i, offset.y)
	return Vector2.ZERO

func check_solid_intersection(solid: Solid, solid_offset: Vector2):
	update_player()
	var solid_rect = get_solid_rect(solid)
	var has_collision: bool= false
	var player_offset: Vector2 = Vector2(player.get_current_climb_direction(), 0)
	if(intersect(solid_rect, player_rect, solid_offset, player_offset)):
		if(check_player_tiles_intersection(solid_offset)):
			if(not player_rect.position.y + player.height - 1 == solid_rect.position.y):
				player.die()
			has_collision = true
		if(has_collision):
			return
		player.global_position += solid_offset

func get_solid_rect(solid: Solid)-> Rect2:
	var solid_rect = solid.get_rect()
	solid_rect.position += Vector2(-1,-1)
	solid_rect.size += Vector2(2,1)
	solid_rect.position += solid.global_position
	return solid_rect

func intersect(rect1: Rect2, rect2: Rect2, offset_rect1: Vector2i = Vector2i.ZERO, offset_rect2: Vector2i = Vector2i.ZERO) -> bool:
	return (rect1.position.x + offset_rect1.x < rect2.position.x + rect2.size.x + offset_rect2.x
	and rect1.position.x + rect1.size.x  + offset_rect1.x > rect2.position.x + offset_rect2.x
	and rect1.position.y  + offset_rect1.y < rect2.position.y + rect2.size.y + offset_rect2.y
	and rect1.position.y + rect1.size.y  + offset_rect1.y > rect2.position.y + offset_rect2.y)
