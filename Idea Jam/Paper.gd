extends Area2D

@onready var E : PanelContainer = $E
@onready var PaperPanel : PanelContainer = $"../CanvasLayer/Control/PaperPanel"
@onready var tilemap : TileMap = $"../TileMap"

var toggle_true : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	E.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_E && E.visible:
			toggle_true = !toggle_true
			PaperPanel.visible = toggle_true
			$Sparkle.emitting = false
			tilemap.set_cell(1, Vector2i(-4, -1), 0, Vector2i(3, 3))

func _on_body_entered(body):
	if body.is_in_group("Player"):
		E.visible = true

func _on_body_exited(body):
	E.visible = false
	PaperPanel.visible = false
	toggle_true = false

func reset():
	$Sparkle.emitting = true
	tilemap.set_cell(1, Vector2i(-4, -1), 0, Vector2i(3, 1))
