extends Button

@export var displayInformationPanel : Panel
@export var tutorialIconPressing : RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	displayInformationPanel.displayIconInformation(get_parent().texture_over, get_parent().name)
	var tween = create_tween()
	tween.tween_property(tutorialIconPressing, "modulate:a", 0, 1)
	await tween.finished
	tutorialIconPressing.visible = false
