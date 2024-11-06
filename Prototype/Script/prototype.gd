extends Node2D

@onready var polygon_2d: Polygon2D = $StaticBody2D/CollisionPolygon2D/Polygon2D
@onready var collision_polygon_2d: CollisionPolygon2D = $StaticBody2D/CollisionPolygon2D
@onready var collision_polygon_2d_4: CollisionPolygon2D = $DisappearPlatform/Area2D/CollisionPolygon2D4
@onready var polygon_2d_2: Polygon2D = $DisappearPlatform/Area2D/CollisionPolygon2D4/Polygon2D

@onready var area_2d: Area2D = $Area2D
@onready var collision_polygon_2d_5: CollisionPolygon2D = $DisappearPlatform/CollisionPolygon2D5
@onready var polygon_2d_3: Polygon2D = $DisappearPlatform/CollisionPolygon2D5/Polygon2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	polygon_2d.polygon = collision_polygon_2d.polygon
	polygon_2d_2.polygon = collision_polygon_2d_4.polygon
	polygon_2d_3.polygon = collision_polygon_2d_5.polygon


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
