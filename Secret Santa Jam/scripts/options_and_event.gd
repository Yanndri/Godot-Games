extends Panel 
#Parent of Event and Options Panel
#Main bus for sending signals to Options, Events and Stats

#Important Panels 
@export var optionsPanel : Panel
@export var eventPanel : Panel
@export var statsPanel : Panel

@export var nameEdit : LineEdit
@export var catName : RichTextLabel
@export var jobName : RichTextLabel
@export var tutorialMouse : TextureRect

#func _input(event: InputEvent) -> void:
	#if event is InputEventMouseButton:
		##check if player wants to go to next page when there is no options available
		#if event.button_index == 1 and !self.visible: #the cooldown is used so that you don't double click skip
			#print("Next Page")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	changeOptionsAndEvent("Prologue") #Start of game event is "Prologue"
	nameEdit.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#get the text from the NameEdit node
func _on_name_edit_text_submitted(new_text: String) -> void:
	if new_text == null || new_text == "": #returns if String is null
		return
	if (GlobalVariables.kitten == ""): #check if kitten already have name
		changeKittenName(new_text)
	elif (GlobalVariables.job == ""): #check if job already have name
		changeJobName(new_text)
	nameEdit.text = ""

func changeKittenName(new_text: String):
	nameEdit.visible = false
	GlobalVariables.kitten = "[b]" + new_text + "[/b]"
	changeOptionsAndEvent("NameChanged")
	catName.text += "\n" + GlobalVariables.kitten
	catName.modulate.a = 1

func changeJobName(new_text: String):
	nameEdit.visible = false
	GlobalVariables.job = "[b]" + new_text + "[/b]"
	changeOptionsAndEvent("JobChanged")
	jobName.text += "\n" + GlobalVariables.job
	jobName.modulate.a = 1

#passed from the options panel when an option is pressed
func changeOptionsAndEvent(event):
	print("Event: ", event)
	eventPanel.changeEvent(event) #Change the dialogue based on the event
	optionsPanel.changeOptions(event) #Change the options based on the event
	statsPanel.changeStats(event) #Change the stats based on the event
	statsCheck()

#passed from option panel where it checks if the player is hovering on the options. Used for giving hints to a player about which stat is going to change
func optionsHoveredHints(event, hovered : bool):
	statsPanel.mouseHovered(event, hovered)

#passed from event panel, used for when the dialogue is not done writing
func typewriterStart():
	optionsPanel.typewriterStart()

#passed from event panel, used for when the dialogue is done writing
func typewriterDone():
	optionsPanel.typewriterDone()

func statsCheck():
	print(" Love: ", GlobalVariables.Love, " Happiness: ", GlobalVariables.Happiness, " Wealth: ", GlobalVariables.Wealth)
