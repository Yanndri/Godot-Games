extends Area2D

@onready var E : PanelContainer = $E
@onready var tilemap : TileMap = $"../TileMap"
@onready var collisionPlayer = $detectPlayer
@onready var AreaTileMap = $TileMapArea
@onready var animframes = $AnimatedSprite2D

var lever_pressed : bool
var can_move : bool
var can_teleport : bool
var teleport_time = 1.5

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.frame = 0

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_E && E.visible && !lever_pressed:
			animframes.frame = 0
			animframes.play("default")
			lever_pressed = true
			E.visible = false
			tilemap.set_cell(1, Vector2i(-1, -5), 0, Vector2i(3, 3))
			can_teleport = false

func movement():
	position = (Vector2(randi_range(-120, 120), randi_range(-55, 55)))
	if position.x < -30 && position.y < -5:
		movement()
	if can_teleport:
		await get_tree().create_timer(teleport_time).timeout
		movement()

func _on_body_entered(body):
	if body.is_in_group("Player"):
		if !lever_pressed:
			E.visible = true
	

func _on_tile_map_area_body_entered(body):
	if body is TileMap:
		movement()

func _on_body_exited(body):
	if body.is_in_group("Player"):
		E.visible = false

func reset():
	lever_pressed = false
	tilemap.set_cell(1, Vector2i(-1, -5), 0, Vector2i(3, 1))
	animframes.frame = 0
	can_teleport = false
	movement()

func teleport(teleport_time):
	can_teleport = true
	teleport_time = teleport_time
	
	movement()
