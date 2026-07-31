extends Node

@onready var tile_map: TileMap = $TileMap

const APPLE_ID = 2
const APPLE_ATLAS_COORD = Vector2i(0, 0)
const SNAKE_ID = 1
const SNAKE_BODY_ATLAS_COORD = Vector2i(7, 0)
const MOVE_DELAY = .4

var snake_body = [Vector2i(5,10), Vector2i(4,10), Vector2i(3,10)]
var direction = Vector2i(1, 0)
var time_passed = 0.0

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	time_passed += delta
	if time_passed >= MOVE_DELAY:
		time_passed = 0.0
		draw_snake()
		move_snake()

func move_snake():
	var new_head = snake_body[0] + direction
	snake_body.push_front(new_head)
	snake_body.pop_back()

func draw_snake():
	tile_map.clear()
	for pos in snake_body:
		tile_map.set_cell(0,pos,SNAKE_ID,SNAKE_BODY_ATLAS_COORD)

func place_apple():
	var x = randi() % 20
	var y = randi() % 20
	tile_map.set_cell(0,Vector2i(x, y),APPLE_ID,APPLE_ATLAS_COORD)
