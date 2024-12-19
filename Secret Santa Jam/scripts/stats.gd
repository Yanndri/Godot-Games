extends Panel
#Manipulate the values of stats based on events

@export var OptionsAndEventsPanel : Panel #Main bus

#Stats
@export var Love : TextureProgressBar
@export var Happiness : TextureProgressBar
@export var Wealth : TextureProgressBar
@export var Clock : TextureProgressBar

#Colors for indicating increase/decrease in stat(change in texture progress bar), or to indicate hints (change in texture under)
var textureProgressGradient2D : GradientTexture2D = preload("res://Resources/textureProgressCircle.tres")  #the texture for progress bar
var defaultProgressColor : Color = Color(120/255.0, 86/255.0, 87/255.0) #default color which is brownish
var decreaseColor : Color = Color(170/255.0, 86/255.0, 87/255.0) #color Red to indicate negative
var increaseColor : Color = Color(120/255.0, 150/255.0, 87/255.0) #color Green to indicate positive

var mouseHoveredButton : bool = false

func _ready() -> void:
	Love.visible = false #make them invinsible
	Wealth.visible = false 
	Clock.visible = false
	_hintOff() #make the hints invinsible
	
func changeLove(amount : int = 0):
	if _hintOn(Love, amount): #When the player is just hovering over the option and didnt click it
		return

	if amount < 0: #if decrease
		Love.texture_progress.gradient.colors[0] = decreaseColor #change color to red
	elif amount > 0: #if increase
		Love.texture_progress.gradient.colors[0] = increaseColor #change color to red

	GlobalVariables.Love += amount #change the global variable stat
	if (GlobalVariables.Love < 0): 
		GlobalVariables.Love = 0 #to make sure that it doesn't go to negative value

	if GlobalVariables.Love >= Love.max_value/2: #Change texture of the stat when at a certain value
		Love.texture_over = preload("res://Art/cathappy.png")
	else:
		Love.texture_over = preload("res://Art/catsad.png")

	var tween = create_tween() #for animating increase/decrease of value
	tween.tween_property(Love, "value", GlobalVariables.Love, 0.8)
	await tween.finished
	Love.texture_progress.gradient.colors[0] = defaultProgressColor

func changeHappiness(amount : int):
	if _hintOn(Happiness, amount):
		return

	if amount < 0:
		Happiness.texture_progress.gradient.colors[0] = decreaseColor
	elif amount > 0:
		Happiness.texture_progress.gradient.colors[0] = increaseColor

	GlobalVariables.Happiness += amount
	if (GlobalVariables.Happiness < 0): 
		GlobalVariables.Happiness = 0

	if GlobalVariables.Happiness >= Happiness.max_value/5:
		Happiness.texture_over = preload("res://Art/Happy.png")
	else:
		Happiness.texture_over = preload("res://Art/Sad.png")

	var tween = create_tween()
	tween.tween_property(Happiness, "value", GlobalVariables.Happiness, 0.8)
	await tween.finished
	Happiness.texture_progress.gradient.colors[0] = defaultProgressColor

func changeWealth(amount : int):
	if _hintOn(Wealth, amount):
		return

	if amount < 0:
		Wealth.texture_progress.gradient.colors[0] = decreaseColor
	elif amount > 0:
		Wealth.texture_progress.gradient.colors[0] = increaseColor

	GlobalVariables.Wealth += amount
	if (GlobalVariables.Wealth < 0): 
		GlobalVariables.Wealth = 0
	
	var tween = create_tween()
	tween.tween_property(Wealth, "value", GlobalVariables.Wealth, 0.8)
	await tween.finished
	Wealth.texture_progress.gradient.colors[0] = defaultProgressColor

func changeClock(amount : int):
	amount *= 10
	if mouseHoveredButton: #not calling hintOn() since this is not a 
		return

	GlobalVariables.Clock += amount
	var tween = create_tween()
	tween.tween_property(Clock, "value", GlobalVariables.Clock, 1)
	await tween.finished

func resetClock(): #to indicate a new day
	GlobalVariables.Clock = Clock.max_value
	changeClock(0)

#check wether the player is hovering on the options. passed from the main bus
func mouseHovered(event, hovered):
	mouseHoveredButton = hovered
	if !mouseHoveredButton:
		_hintOff()
	else:
		changeStats(event)

#used to when the player hovers to an option a hint is given to which stat is going to change. 
func _hintOn(stat : TextureProgressBar, amount : int):
	if !mouseHoveredButton:
		return false #hint is off / player isn't hovering on the button option
	stat.get_child(0).visible = true
	stat.get_child(0).modulate.a = 0
	var tween = create_tween()
	tween.tween_property(stat.get_child(0), "modulate:a", 1, 0.3)
	stat.get_child(0).texture.gradient.offsets[0] = clampf(floorf(amount) / 30.0, 0.2, 0.4) + 0.01
	stat.get_child(0).texture.gradient.offsets[1] = clampf(floorf(amount) / 30.0, 0.2, 0.4) + 0.01
	return true

#This is when the player stops hovering on an option so the hint is gone
func _hintOff():
	Love.get_child(0).visible = false
	Happiness.get_child(0).visible = false
	Wealth.get_child(0).visible = false

func changeStats(event):
	#ruleset: highest amount stat increase/decrease : 15
	match event:
		"Prologue":
			changeLove(0)#starting values
			changeWealth(5)
			changeHappiness(-85)
			changeClock(9)
		"End it all":
			changeHappiness(-10)
		"Adopt the stray kitten", "Take the kitten home": 
			if !mouseHoveredButton: #check if the player is just hovering from the button or not
				Love.visible = true
			changeHappiness(30)
		"NameChanged": 
			changeLove(20)
		"JobChanged": 
			if !mouseHoveredButton:
				Wealth.visible = true
			changeWealth(20)
		"Rest.":
			if !mouseHoveredButton: 
				Clock.visible = true
			resetClock()
		"New Day": #Whenever a new day starts
			changeHappiness(-10)
			resetClock()
		"Comfort the Kitten": 
			changeClock(-1)
			changeLove(5)
		"Work Normal Hours": 
			changeClock(-5)
			changeWealth(10)
		"Work Overtime": 
			changeClock(-7)
			changeWealth(15)
			changeHappiness(-5)
		"Take the day off":
			changeClock(-1)
			changeWealth(-10)
		"Overslept":
			changeClock(-2)
		"Rush to work":
			changeClock(-5)
			changeLove(-5)
			changeHappiness(-10)
			changeWealth(10)
		"Feed Kitty":
			changeLove(0) #mainly to let the player know that this option has another options that affects the love stat
		"Feed the kitten before going to work":
			changeClock(-4)
			changeLove(5)
			changeHappiness(-5)
			changeWealth(5)
		"Share food":
			changeClock(-1)
			changeLove(5)
		"Feed Premium food":
			changeClock(-1)
			changeLove(15)
			changeWealth(-5)
		"Bathe Kitty":
			changeClock(-1)
			if GlobalVariables.Love <= 50:
				changeLove(-10)
			else:
				changeLove(5)
		"Play with Kitty":
			changeClock(-1)
			if GlobalVariables.Love <= 50:
				changeHappiness(-10)
			else:
				changeHappiness(5)
		"Take a short break":
			changeClock(-3)
			changeHappiness(10)
		"Stay productive":
			changeClock(-3)
			changeWealth(5)
		"Take a walk in the park":
			changeClock(-2)
			changeLove(10)
		"Stay home and relax":
			changeClock(-1)
			changeHappiness(10)
		"Go for a run":
			changeClock(-4)
			changeHappiness(15)
		"Skip exercise":
			changeClock(-1)
			changeHappiness(-5)
		"Go Shopping":
			changeClock(-3)
			changeLove(10)
			changeWealth(-10)
		"Delay the shopping trip":
			changeClock(-1)
			changeLove(-5)
		"Go meet friends":
			changeClock(-2)
			changeLove(-10)
			changeHappiness(15)
		"":
			changeClock(-2)
		"":
			changeClock(-2)

	# Second Chances (When it's game over but you get a second chance)
		"Second Chance": #low love
			changeClock(-2)
			changeLove(20)
		"Happy Thoughts": #low Happiness
			changeClock(-2)
			changeHappiness(20)
		"Seek help": #low Wealth
			changeClock(-2)
			changeWealth(20)
#
#
#
		#_: 
			#if Clock.modulate.a == 1: 
				#changeClock(-1)
