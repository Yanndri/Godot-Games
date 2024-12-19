extends Panel

@export var statName : RichTextLabel
@export var statIcon : TextureProgressBar
@export var information : RichTextLabel

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1 and self.visible: #whenever a left click occurs and if visible
			self.visible = false #turn invinsible

#whenever an icon is pressed using the button child of the Icon
func displayIconInformation(Icon, Name):
	if statName.text == "[center]" + Name + "[/center]": #If the same icon is pressed again
		statName.text = "" 
		return
	self.modulate.a = 0
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1, 0.3)
	self.visible = true
	statIcon.texture_over = Icon
	statName.text = "[center]" + Name + "[/center]"
	match Name:
		"Happiness": information.text = """
[center]This stat represents the emotional well-being of the player. It fluctuates based on their daily activities, choices, and responsibilities toward the kitten.
The more the player cares for the kitten the higher their own Happiness becomes. Neglecting the kitten lowers both.

It also decreases once the day has ended, so you have to prioritize yourself more than anything.
		"""
		"Love": information.text = """
The kitten’s affection toward the player, which is crucial for building a bond. This stat reflects how much the kitten trusts the player.


A well-loved kitten boosts the player’s happiness, improves interactions, and can open up new event outcomes.
A neglected kitten will trigger bad events.
		"""
		"Wealth": information.text = """
This represents the player’s financial situation, which affects their ability to care for both themselves and the kitten. It also determines how many options the player has for events and activities.


The player earns money from work and other events. It decreases when the player spends money on kitten supplies or personal needs.
		"""
		"Clock": information.text = """
This is a daily time limit that restricts the number of actions the player can take each day. 
The clock counts down as events or activities consume time.


When the clock runs out, the day automatically progresses, and any unfinished actions are carried over to the next day.
		"""
