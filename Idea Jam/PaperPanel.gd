extends PanelContainer

@onready var noteMom : Label = $TextfromMom
@onready var main = $"../../.."

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func change_rules(day, lever_teleports, floor_is_lava, darkness):
	noteMom.text = "Hi Honey!\n\n\t"
	var End = false
	match day:
		0: noteMom.text += "The Neighbors told me you've been blowing up infrastructures lately, they want me to talk to you about this but I'm busy, and you're probably just in puberty :)\n\nP.S. you're grounded, I locked the door to outside. There's definitely no contraptions to unlock it like a lever or something."
		1: noteMom.text += "What did I tell you.. You keep disobeying my orders and blowing up all these houses so I have to tighten up the lock to the door exit"
		2: noteMom.text += "I definitely have to teach you a lesson personally but for now I just made the house harder to leave"
		3: noteMom.text += "*sigh* how long can my patience keep up"
		4: 
			noteMom.text += "Thank you for playing!! ran out of time but there is supposedly more rules to implement in the future!!, if you like this I will keep on updating this and probably change the assets used!"
			End = true
	
	if day < 1:
		return
	noteMom.text += "\n\nP.S. "
	if End:
		noteMom.text += "- I'm tired didn't do any end polish so probably just stop here :) \n"
		return
	if lever_teleports:
		noteMom.text += "- I made the lever teleport\n"
	if floor_is_lava:
		noteMom.text += "- The floor changes to lava for certain intervals\n"
	if darkness:
		noteMom.text += "- DARKNESS UPON THEE <3\n"
