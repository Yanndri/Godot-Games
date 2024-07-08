extends PanelContainer

@onready var creature_texture = $VBoxContainer/TextureRect
@onready var creature_name = $VBoxContainer/RichTextLabel
@onready var creature_description = $VBoxContainer/Description

func change_data(creature_data):
	creature_texture.texture = creature_data.texture
	creature_name.text = "[center][colormod]" + str(creature_data.name)
	creature_description.text = "[center]Skill: " + str(creature_data.skills) + "\nArea: " + str(creature_data.area)
	print(creature_data.name)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
