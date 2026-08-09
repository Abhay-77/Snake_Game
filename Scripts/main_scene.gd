extends Node

@onready var tile_map: TileMap = $TileMap
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer
@onready var game_over_label: Label = $CanvasLayer/Label
@onready var game_manager: Node = $GameManager

const SNAKE_LAYER = 2
const PICKUP_LAYER = 1
const APPLE_ID = 2
const APPLE_ATLAS_COORD = Vector2i(0, 0)
const SNAKE_ID = 1
const SNAKE_HEAD_ATLAS_COORD = {
	Vector2i.UP: Vector2i(2, 1),
	Vector2i.DOWN: Vector2i(3, 0),
	Vector2i.LEFT: Vector2i(3, 1),
	Vector2i.RIGHT: Vector2i(2, 0),
	Vector2i.ZERO: Vector2i(2, 0)
}
const SNAKE_TAIL_ATLAS_COORD = {
	Vector2i.RIGHT: Vector2i(0,0),
	Vector2i.LEFT: Vector2i(1,0),
	Vector2i.UP: Vector2i(1,1),
	Vector2i.DOWN: Vector2i(0,1),
	Vector2i.ZERO: Vector2i(0, 0)
}
const SNAKE_BODY_ATLAS_COORD = {
	Vector2i.RIGHT: Vector2i(4,0),
	Vector2i.LEFT: Vector2i(4,0),
	Vector2i.UP: Vector2i(4,1),
	Vector2i.DOWN: Vector2i(4,1),
	Vector2i.ZERO: Vector2i(4, 0)
}
const SNAKE_CORNER_BODY_ATLAS_COORD = {
	Vector2i(1,-1): Vector2i(5,1),
	Vector2i(-1,-1): Vector2i(6,1),
	Vector2i(1,1): Vector2i(5,0),
	Vector2i(-1,1): Vector2i(6,0)
}
const MOVE_DELAY = .2
const bounds = Rect2i(0, 0, 20, 20)

var snake_body = [Vector2i(5,10), Vector2i(4,10), Vector2i(3,10)]
var direction = Vector2i.ZERO
var curr_dir = direction
var time_passed = 0.0
var apple_pos
var game_over = false

func _ready() -> void:
	draw_snake()
	place_apple()

func _process(delta: float) -> void:
	if game_over:
		return
	time_passed += delta
	update_direction()
	if time_passed >= MOVE_DELAY:
		time_passed = 0.0
		move_snake()
		draw_snake()

func move_snake():
	if direction == Vector2i.ZERO:
		return
	var new_head = snake_body[0] + direction
	curr_dir = direction
	var will_grow = new_head == apple_pos
	snake_body.push_front(new_head)
	if will_grow:
		handle_apple_hit()
	else:
		snake_body.pop_back()
	handle_game_loss()

func handle_apple_hit():
	tile_map.erase_cell(PICKUP_LAYER, apple_pos)
	audio_player.play()
	game_manager.update_score()
	place_apple()

func handle_game_loss():
	var head = snake_body[0]
	if snake_body.count(head) > 1 or not bounds.has_point(head):
		timer.start()
		game_over = true
		game_over_label.visible = true
		animation_player.play("gameOver")
		return true
	return false

func draw_snake():
	if game_over:
		return
	tile_map.clear_layer(SNAKE_LAYER)
	var n = snake_body.size()
	for i in n:
		if i == 0:
			tile_map.set_cell(SNAKE_LAYER,snake_body[i],SNAKE_ID,SNAKE_HEAD_ATLAS_COORD[direction])
			continue
		var to = snake_body[i-1] - snake_body[i]
		if i == n - 1:
			tile_map.set_cell(SNAKE_LAYER,snake_body[i],SNAKE_ID,SNAKE_TAIL_ATLAS_COORD[to])
			continue
		var from = snake_body[i] - snake_body[i + 1]
		if to == from:
			tile_map.set_cell(SNAKE_LAYER,snake_body[i],SNAKE_ID,SNAKE_BODY_ATLAS_COORD[to])
		else:
			tile_map.set_cell(SNAKE_LAYER,snake_body[i],SNAKE_ID,SNAKE_CORNER_BODY_ATLAS_COORD[to - from])

func place_apple():
	while true:
		var x = randi() % 20
		var y = randi() % 20
		apple_pos = Vector2i(x, y)
		if apple_pos not in snake_body:
			break
	tile_map.set_cell(PICKUP_LAYER,apple_pos,APPLE_ID,APPLE_ATLAS_COORD)

func update_direction():
	var new_dir
	if Input.is_action_just_pressed("move_down"):
		new_dir = Vector2i.DOWN
	elif Input.is_action_just_pressed("move_up"):
		new_dir = Vector2i.UP
	elif Input.is_action_just_pressed("move_left") and direction != Vector2i.ZERO:
		new_dir = Vector2i.LEFT
	elif Input.is_action_just_pressed("move_right"):
		new_dir = Vector2i.RIGHT
	else:
		return
	if new_dir + curr_dir != Vector2i.ZERO:
		direction = new_dir

func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
