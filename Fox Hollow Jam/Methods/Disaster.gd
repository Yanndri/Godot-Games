extends PanelContainer

@onready var disaster_texture : TextureRect = $TextureRect
@onready var disaster_name : RichTextLabel = $RichTextLabel

func change_data(disaster_data):
	disaster_texture.texture = disaster_data.texture
	disaster_name.text = "[nervous][center]" + disaster_data.name

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
