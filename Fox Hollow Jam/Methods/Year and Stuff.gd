extends RichTextLabel

@export var Year : bool
@export var Millenium : bool
@export var Disaster : bool
@export var Evolution_Points : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Year:
		self.text = "[center]Current Year: " + str(Counts.year)
	if Millenium:
		self.text = "[center]"
		match Counts.millenium:
			1 : self.text += "1st "
			2 : self.text += "2nd "
			3 : self.text += "3rd "
			_ : self.text += str(Counts.millenium) + "th "
		self.text += "Millennium"
	if Disaster:
		self.text = "[center]Disaster: " + Counts.disaster_name
		if Counts.disaster_name.length() > 10:
			add_theme_font_size_override("normal_font_size", 10)
	if Evolution_Points:
		self.text = "\n[heart]" + str(Counts.evolution_points)
