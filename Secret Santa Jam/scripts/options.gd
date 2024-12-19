extends Panel
#Used for changing options, and send signals to MainBus(Options&EventPanel)

#Childrens
@export var option1 : Button
@export var option2 : Button
@export var option3 : Button
@export var nameEdit : LineEdit
@export var event_cooldown : Timer #cooldown until the player can change event
@export var tutorialMouse : TextureRect #to give player advice when there are no options available

#Important Panels
@export var OptionsAndEventPanel : Panel
@export var stats : Panel
@export var eventPanel : Panel

#tutorial texts
@export var tutorialIconPressing : RichTextLabel #this is a text that tells the player to click an icon to get their information

#Events
var randomEvents : Array
var defaultRandomEvents = ["Shopping Event", "Visit a Friend Event", "Rainy Day", "Exercise Event", "Take a Walk", "Spare Time"]
#var randomEvents : Dictionary
#var defaultRandomEvents = { #since we're going to be deleting random events we need an original copy
	#1: # When Clock has >= 4
		#["Rainy Day", "Rainy Day", "Rainy Day"],
	#2: # When Clock is 3
		#["Exercise Event", "Take a Walk", "Spare Time"],
	#3:  # When Clock is 2 or 1
		#["Shopping Event", "Visit a Friend Event", "Visit a Friend Event", "Visit a Friend Event","Visit a Friend Event","Visit a Friend Event"]
#}

var mouseEntered : bool = false #to check if the mouse is inside the Panel
var previousEvent : String #to check what was the previous event
var work : bool = false #check if player already worked for the day
var next : bool = false #check if player can go to the next page
var inputEvent : bool = false #check if the event is an input event where the player needs to input something

#checks if the player still has a chance to redeem themselves(One time only for each stat). Once set to false it will be gameover next time (check GameOverEvents)
var lowLoveSecondChance : bool = true 
var lowHappinessSecondChance : bool = true
var lowWealthSecondChance : bool = true

func _input(event: InputEvent) -> void:
	#check if player wants to go to next page either by pressing space or left clicking on the event panel
	if event is InputEventMouseButton:
		#check if player wants to go to next page when there is no options available
		if event.button_index == 1 and next and self.visible and mouseEntered and event_cooldown.is_stopped(): #the cooldown is used so that you don't double click skip
			print("Next Page")
			randomEvent() #Choose a random event based on how much time is left
	elif event is InputEventKey:
		if Input.is_action_just_pressed("ui_accept") and next and self.visible and event_cooldown.is_stopped():
			print("Next Page")
			randomEvent() #Choose a random event based on how much time is left

func _ready() -> void:
	randomEvents = defaultRandomEvents.duplicate(true) #instantiate the random events by copying what's on defaultRandomEvents, include all it's nested array too by setting parameters to true
	option1.text = "End it all"
	option2.text = "End it all"
	option3.visible = false
	event_cooldown.connect("timeout", _toggle_buttons) #whenever the cooldown timer runs out, it will enable the buttons again

#Can only be called from the Main Bus...
func changeOptions(event):
#start cooldown countdown to when the player can go to next event (to stop the player from spamming next)
	event_cooldown.start() 
	_toggle_buttons() #sets buttons to disabled

	#self.visible = true
	option1.visible = true
	option2.visible = true
	option3.visible = false #since a third option is quite rare

	match event:
		"Prologue":
			option1.text = "End it all"
			option2.text = "End it all"
			option3.text = "End it all"
			option3.visible = true
		"End it all": 
			option1.text = "Don't mind the stray kitten"
			option2.visible = false
		"Don't mind the stray kitten":
			option1.text = "Adopt the stray kitten"
			option2.text = "Take the kitten home"
		"Adopt the stray kitten", "Take the kitten home": 
			option1.text = "Go home"
			option2.visible = false
		"Go home": #End of Prologue
			nameEdit.placeholder_text = "Poopshitter2000"
			nameEdit.visible = true
			inputEvent = true
			option1.visible = false
			option2.visible = false
		"NameChanged": #After the name has been changed
			nameEdit.placeholder_text = "Software Developer"
			nameEdit.visible = true
			inputEvent = true
			option1.visible = false
			option2.visible = false
		"JobChanged":
			inputEvent = false
			option1.text = "Rest."
			option2.visible = false
		"Rest.":
			tutorialIconPressing.visible = true #this is a text that tells the player to click an icon to get their information
			option1.text = "Comfort the Kitten"
			option2.text = "Feed Kitty"
			option3.text = "Do nothing"
			option3.visible = true
		"Sad Kitty":
			option1.text = "Comfort the Kitten"
			option2.text = "Feed Kitty"
			option3.text = "Do nothing"
			option3.visible = true
		"Feed Kitty":
			option1.text = "Share food"
			option2.text = "Feed Premium food"
		"Work":
			work = true #meaning the work event had run for the day
			option1.text = "Work Normal Hours"
			option2.text = "Work Overtime"
			option3.text = "Take the day off"
			option3.visible = true
		"Overslept":
			work = true
			option1.text = "Rush to work"
			option2.text = "Feed the kitten before going to work"
			option3.text = "Take the day off"
			option3.visible = true

#Random Events
		"Spare Time":
			option1.text = "Play with Kitty"
			option2.text = "Feed Kitty"
			option3.text = "Bathe Kitty"
			option3.visible = true
		"Rainy Day":
			option1.text = "Take a short break"
			option2.text = "Stay productive"
		"Take a Walk":
			option1.text = "Take a walk in the park"
			option2.text = "Stay home and relax"
		"Exercise Event":
			option1.text = "Go for a run"
			option2.text = "Skip exercise"
		"Shopping Event":
			option1.text = "Go Shopping"
			option2.text = "Delay the shopping trip"
		"Visit a Friend Event":
			option1.text = "Go meet friends"
			option2.text = "Stay home and relax"
		"":
			option1.text = ""
			option2.text = ""
		"":
			option1.text = ""
			option2.text = ""

		_: #this will set the condition for "Next" event, see the _input() function
			self.visible = false
			option1.visible = false
			option2.visible = false
			option3.visible = false
			next = true #if true meaning that there are no options available and you can proceed to next page
		
	tutorialMouse.visible = false
	previousEvent = event #once the event is done assign it to previous event

#When the player presses the next page
func randomEvent():
	next = false
	if _accordingEvent(): return #check if the next page is the continuation of an event, if true return
	
	if _GameOverEvents(): return #check if it is already game over(when a lose condition is triggered
	#Event must only run once it is instantiated in the day
	if GlobalVariables.Clock >= 8 and !work: #Daily Work
		_changeOptionsAndEvent("Work")
	else: #pick a random event when there are no options available and the player goes to the next page
		if GlobalVariables.Clock <= 0: #Runs when clock is Zero
			_changeOptionsAndEvent("Sleep")
		else:
			var randomRoll = randi_range(0, randomEvents.size() - 1)
			print(randomEvents)
			print("Random Event: ", randomEvents[randomRoll])
			_changeOptionsAndEvent(randomEvents.pop_at(randomRoll))
		#var randomRoll = randi_range(1, GlobalVariables.Clock/10) #get a random roll based on how much time is left
		#print("randomRoll: ", randomRoll)
		#print(randomEvents)
		#match randomRoll:
			#12,11,10,9,8,7,6,5,4:
				#var randomEventRoll = randi_range(0, randomEvents[1].size() - 1) #random roll based on how many events is in dictionary 1 array
				#print("Random Event Roll: ", randomEventRoll)
				#var selectedEvent = randomEvents[1][randomEventRoll]
				#_changeOptionsAndEvent(selectedEvent) #get a random Event from dictionary 1 array
				#randomEvents[1].erase(selectedEvent) #delete it after so that it doesn't run multiple times
			#3:
				#var randomEventRoll = randi_range(0, randomEvents[2].size() - 1)
				#print("Random Event Roll: ", randomEventRoll)
				#var selectedEvent = randomEvents[2][randomEventRoll]
				#_changeOptionsAndEvent(selectedEvent) 
				#randomEvents[2].erase(selectedEvent) 
			#2, 1:
				#var randomEventRoll = randi_range(0, randomEvents[3].size() - 1)
				#print("Random Event Roll: ", randomEventRoll)
				#var selectedEvent = randomEvents[3][randomEventRoll]
				#_changeOptionsAndEvent(selectedEvent) 
				#randomEvents[3].erase(selectedEvent) 
			#_: #Runs when clock is Zero
				#_changeOptionsAndEvent("Sleep")

#Events that are the continuation of a certain event
func _accordingEvent():
	match previousEvent:
		"Low Love Event": 
			if lowLoveSecondChance: #when the player still has a chance to redeem themselves(One time only for each stat)
				lowLoveSecondChance = false 
				_changeOptionsAndEvent("Second Chance")
			else: #if the player fails a second time it will be instant game over
				_changeOptionsAndEvent("Lost Love")
		"Low Happiness Event": 
			if lowHappinessSecondChance:
				lowHappinessSecondChance = false 
				_changeOptionsAndEvent("Happy Thoughts")
			else:
				_changeOptionsAndEvent("Lost Happiness")
		"Low Wealth Event": 
			if lowWealthSecondChance:
				lowWealthSecondChance = false 
				_changeOptionsAndEvent("Seek help")
			else:
				_changeOptionsAndEvent("Lost Wealth")
		"Sleep": 
			var randomEventRoll = randi_range(1, 2)
			match randomEventRoll:
				1: _changeOptionsAndEvent("Overslept")
				2: _changeOptionsAndEvent("Sad Kitty")
			_newDay()
		_: 
			return false #returns false if the event is not a continuation
	return true

func _GameOverEvents():
	if GlobalVariables.Love <= 0: #check if the Love stat is already 0
		_changeOptionsAndEvent("Low Love Event")
		return true
	if GlobalVariables.Love >= 100: #check if the Love stat is at 100
		_changeOptionsAndEvent("High Love Event")
		return true
	if GlobalVariables.Happiness <= 0:
		_changeOptionsAndEvent("Low Happiness Event")
		return true
	if GlobalVariables.Happiness >= 100:
		_changeOptionsAndEvent("High Happiness Event")
		return true
	if GlobalVariables.Wealth <= 0:
		_changeOptionsAndEvent("Low Wealth Event")
		return true
	if GlobalVariables.Wealth >= 100:
		_changeOptionsAndEvent("High Wealth Event")
		return true
	return false

#Start a new Day
func _newDay():
	print("New Day")
	randomEvents = defaultRandomEvents.duplicate(true) #instantiate the random events
	stats.changeStats("New Day") #reduce the Happiness once the day starts a new
	work = false

#to call the Main Bus, just cause writing "OptionsAndEventPanel.changeOptionsAndEvent()" everytime is a hassle, this is much shorter
func _changeOptionsAndEvent(event : String): 
	OptionsAndEventPanel.changeOptionsAndEvent(event)

func typewriterStart():
	self.visible = false

func typewriterDone():
	self.visible = true #some cases where even if this is visible and you see no options, that means the options were invisible
	if !option1.visible and !option2.visible and !option3.visible and !inputEvent: #if it no options and it's not an inputEvent
		tutorialMouse.visible = true

func _on_option_1_pressed() -> void:
	_changeOptionsAndEvent(option1.text)

func _on_option_2_pressed() -> void:
	_changeOptionsAndEvent(option2.text)

func _on_option_3_pressed() -> void:
	_changeOptionsAndEvent(option3.text)

func _toggle_buttons():
	#print("Buttons disable: ", !option1.disabled)
	option1.disabled = !option1.disabled
	option2.disabled = !option2.disabled
	option3.disabled = !option3.disabled

#To check when the mouse is inside the Event Panel indicating that they want to page next
func _on_event_mouse_entered() -> void:
	mouseEntered = true
func _on_event_mouse_exited() -> void:
	mouseEntered = false

#To check when the mouse is hovering on an option. Used to send signal to main bus to show hints to what stats is gonna be affected on that option choice
func _on_option_1_mouse_entered() -> void:
	OptionsAndEventPanel.optionsHoveredHints(option1.text, true)

func _on_option_1_mouse_exited() -> void:
	OptionsAndEventPanel.optionsHoveredHints(option1.text, false)

func _on_option_2_mouse_entered() -> void:
	OptionsAndEventPanel.optionsHoveredHints(option2.text, true)

func _on_option_2_mouse_exited() -> void:
	OptionsAndEventPanel.optionsHoveredHints(option2.text, false)

func _on_option_3_mouse_entered() -> void:
	OptionsAndEventPanel.optionsHoveredHints(option3.text, true)

func _on_option_3_mouse_exited() -> void:
	OptionsAndEventPanel.optionsHoveredHints(option3.text, false)
