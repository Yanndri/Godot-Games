extends Panel
#Used for changing Event Dialogues

@export var OptionsAndEventsPanel : Panel #Main Bus

#Sounds
@export var typewriterSFX : AudioStreamPlayer

@export var dialogue : RichTextLabel

#For graphic purpose only whenever the player goes to the next page these nodes will be duplicated and deleted
@export var event2 : Panel
@export var dialogue2 : RichTextLabel

var kitten : String

var typewriterTween : Tween = create_tween() #tween mainly used for typewriter
var typewriterSpeed : int = 1 #how fast the tween is moving, 1 is normal, 10 is ten times faster

#Can only be called from the Main Bus...
func changeEvent(event):
	typewriter()
	animateChangeEvent() #for animating next Page
	match event:
		"Prologue": 
			dialogue.text = """
Life since you dropped out of college everything had become a monotonous blur. 

Every day felt the same—gray, dull, and purposeless. You had dreams once, but now they’re buried under a heavy weight of routine and regret. Each step forward feels impossible, each day just another reminder that you're stuck.
			
[nervous][code]“Maybe it’s too late for me. Maybe no one would care if I just disappeared.”[/code]
		"""
#------------------------------------------------------------------------
		"End it all": dialogue.text = """
You stand alone in the rain, cold and drenched, watching the world move on without you. No one notices. No one cares. 
At least, that’s what you tell yourself.

[b][i]"Meow."[/i][/b]

A sound so quiet, you almost miss it. You look down, and there, in the rain, is a tiny stray kitten. She looks as lost and alone as you feel, shivering in the cold, her fur matted from the rain. 

She must have wandered away from her mother. But she'll come back for her kitten... right?
		"""
#------------------------------------------------------------------------
		"Don't mind the stray kitten": dialogue.text = """
But then, your gaze drifts. Across the street, in the middle of the highway, you see her. The kitten’s mother, motionless, lying there—gone. And in that moment, your heart sinks. She isn’t coming back.

You’re staring down at the kitten, and for the first time in what feels like forever, you care. Not about yourself, but about this small, fragile life left behind.
		"""
#------------------------------------------------------------------------
		"Adopt the stray kitten", "Take the kitten home": dialogue.text = """
You bend down, scooping the small creature into your arms. She stiffens, her tiny body shaking, uncertain of what this strange "two-legs" wants. But you hold her close, shielding her from the rain.

[i]She’s scared, and so am I, 

I can't walk away now. Not anymore.[i]
		"""
#------------------------------------------------------------------------
		"Go home": dialogue.text = """
You take her home. It’s a quiet place, just like you’ve been for a long time. She hides at first, frightened, but deep down you know—this is the beginning of something new.

For both of you.

\n\n\n\n– End of Prologue –

\n\nMake a name for the kitten: 
		"""
#------------------------------------------------------------------------
		"NameChanged": dialogue.text = """
[i]"Now that I have someone else to take care of, I need to stop running from my responsibilities."[/i]

[i]"Maybe it's time to get a job so that I can earn some money. 
I owe it to myself—and to """ + GlobalVariables.kitten + """—to make something of my life."[/i]

\n\n\n\n\n\nWhat job do you want to have?
		"""
#------------------------------------------------------------------------
		"JobChanged": dialogue.text = """
You have chosen to become a \"""" + GlobalVariables.job + """\". This job will help you earn some money.

[i]"It won't be easy but I will manage for """ + GlobalVariables.kitten + """"

\n\n\n\n\n"I should rest for now as tomorrow will be the official start of my second life"[/i]
		"""
#------------------------------------------------------------------------
		"Rest.", "Sad Kitty": 
			if typewriterSpeed != 10: #check when speed has already been changed
				changeTypewriterSpeed(3) #since for the prologue we have made the speed to 1 for dramatic text
			dialogue.text = """
[b][i]"Meow, meow, meow."[/i][/b]
You wake up to the soft cries of """ + GlobalVariables.kitten + """. She's curled up at the foot of the bed, her tiny body trembling. The memory of her mother crosses your mind. 
She looks lost, unsure, and scared.

[i]"What should I do?"[/i]
		"""
#------------------------------------------------------------------------
		"Comfort the Kitten": dialogue.text = """
[i]"It’s okay, I’m here."[/i]
You gently pick her up and cradle her in your arms. She presses her head against your chest, and slowly, her trembling stops.

[i]"It seems she likes me a little bit now"[i]
		"""
#------------------------------------------------------------------------
		"Do nothing": dialogue.text = """
[i]"Maybe she just needs time..."[/i]

You stay still, watching her. After a while, she curls up again, but her soft whimpers don’t fully go away.
		"""
#------------------------------------------------------------------------
		"Work": 
			dialogue.text = """
[i]"It’s time to spend some time for work. I need to lock in as this will be for the better future" [/i]

You feel the familiar weight of responsibility, but now, with the kitten depending on you, there’s a sense of purpose behind each hour you put in.
		"""
#------------------------------------------------------------------------
		"Work Normal Hours": dialogue.text = """
[i]"I’ll stick to my usual schedule. It’s steady and reliable. This way, I can still make time for my kitten later."[/i]
		"""
#------------------------------------------------------------------------
		"Work Overtime": dialogue.text = """
[i]"I need to push myself today. More work means more money, and I could really use the extra cash for """ + GlobalVariables.kitten + """."[/i]
		"""
#------------------------------------------------------------------------
		"Take a Rest": dialogue.text = """
As the day wears on, you feel the weight of exhaustion settling over you. Every movement feels slower, and your eyes grow heavy.

[i]"I’ve done all I can for today... I’m so tired. Maybe it’s time to rest and try again tomorrow."[/i]
		"""
#------------------------------------------------------------------------
		"Tired": dialogue.text = """
As the day wears on, you feel the weight of exhaustion settling over you. Every movement feels slower, and your eyes grow heavy.

[i]"I’ve done all I can for today... I’m so tired. Maybe it’s time to rest and try again tomorrow."[/i]
		"""
#------------------------------------------------------------------------
		"Play with Kitty": 
			if GlobalVariables.Love <= 50:
				dialogue.text = """
[i]"Come on, it'll be fun!"[/i]

You wave the toy in front of her, but she seems distant, still unsure of you. 

[i]"That's okay. We'll play when you're ready."[/i]
		"""
			else: #when the cat likes you
				dialogue.text = """
You shake the toy, and instantly, the kitten leaps forward, batting at it playfully. 

"There you go, you little rascal!" Her trust in you is growing.
		"""
#------------------------------------------------------------------------
		"Bathe Kitty": 
			if GlobalVariables.Love <= 50: #when the cat still doesnt like you
				dialogue.text = """
[i]"I know you're scared, but it's for your own good." [/i]

She meows sadly, trying to escape the bath. 

[i]"We'll take it slow next time, okay?" [/i]

You dry her gently, but she still seems wary of you.
		"""
			else: #when the cat likes you
				dialogue.text = """
You bathe her with care, and instead of running away, she snuggles into your towel.

[i]"See? That wasn't so bad, was it?" She purrs in contentment.[/i]
		"""
#------------------------------------------------------------------------
		"Feed Kitty": dialogue.text = """
[i]"It's time to feed """ + GlobalVariables.kitten + """, this should help in making her get comfortable to me"[/i]
		"""
#------------------------------------------------------------------------
		"Share food": dialogue.text = """
You place a small portion of your meal for """ + GlobalVariables.kitten + """. 

[i]"I wish I could give you more, but this is all I have right now." [/i]
She seems to appreciate the gesture, rubbing against your leg softly.
		"""
#------------------------------------------------------------------------
		"Feed Premium food": dialogue.text = """
[i]"Only the best for you." [/i]

You set down a dish filled with the kitten's favorite premium food. Her eyes light up, and she purrs loudly as she eats every bite.
		"""
#------------------------------------------------------------------------
		"Sleep": dialogue.text = """
[i]"It's time for sleep, I have done enough for today I still need to get ready for tomorrow."[/i]
		"""
		"Overslept": dialogue.text = """
You wake up groggy and stiff, It seems you have overslept. A quick glance at the clock sends a jolt of anxiety through you—it’s almost time for work, and you barely have any time left.

[i]"Great… Now I’m late, and I didn’t even feed """+ GlobalVariables.kitten + """. What should I do?"[/i]
		"""
		"Rush to work": dialogue.text = """
[i]"I can’t afford to lose this job. I’ll just have to make it up to """+ GlobalVariables.kitten + """ later."[/i]
		"""
		"Feed the kitten before going to work": dialogue.text = """
[i]"I’ll be late, but at least """+ GlobalVariables.kitten + """ won’t be starving. I’ll deal with the consequences later."[/i]
		"""
		"Take the day off": dialogue.text = """
[i]"I’m too drained to keep going today. Maybe a day off is what I need to recharge."[/i]

You feel a wave of relief wash over you as you decide to focus on resting and spending time with """+ GlobalVariables.kitten + """.
		"""
#------------------------------------------------------------------------
		"": dialogue.text = """
		
		"""
		"": dialogue.text = """
		
		"""
		"": dialogue.text = """
		
		"""
		"": dialogue.text = """
		
		"""


#Punishment when a Stat runs low
		"Low Love Event": dialogue.text = """
Your kitten has grown increasingly distant. Each attempt to engage with her is met with hesitation or fear. The bond you once shared feels broken.

[i]“She doesn't trust me anymore. I’ve failed to give her the love and care she needed...”[/i]
		"""
		"Second Chance": dialogue.text = """
You watch as the kitten hides away in the corner, refusing to come near. Just as you begin to lose hope, """+ GlobalVariables.kitten + """ came out with a toy.

[i]"Meow"[/i]

It seems she wants to play with you, is she giving you a second chance?
[i]"Thank you for this chance you gave me, I promise to take care of you better."[/i]
		"""
		"Lost Love": dialogue.text = """
The kitten no longer trusts you. Your neglect has damaged the bond irreparably. You've lost her.
		"""
		"Low Happiness Event": dialogue.text = """
Your days have become unbearable. The stress, the loneliness, the constant grind—it’s all too much. You feel empty, without any joy or motivation left.

[i]“I can't go on like this... Nothing makes sense anymore. I’ve lost my sense of purpose.”[/i]
		"""
		"Happy Thoughts": dialogue.text = """
You collapse onto your bed, staring blankly at the ceiling. But, in the darkest moment, a small spark of hope flickers within you. You remember the things that once made you happy.

[i]"Maybe I can still turn this around. If I start taking care of myself again, things might get better."[/i]
		"""
		"Lost Happiness": dialogue.text = """
[i]"You’ve lost your happiness. Life’s burdens have become too much. There’s nothing left to fight for."[/i]
		"""
		"Low Wealth Event": dialogue.text = """
Your savings are gone. The struggle to make ends meet has drained you completely. You can’t even afford to buy food for yourself or the kitten.

[i]“I can’t believe I let it get this bad. How can I take care of anything when I can't even afford to live?”[/i]

You stare at your empty wallet, the crushing realization sinking in. The weight of financial ruin leaves you feeling trapped, with no way out.
		"""
		"Seek help": dialogue.text = """
You asked for help among your peers, your friends answered your call, 
They are willing to help you as a token of friendship.

[i]"I will do my best to not make the same mistake, or else I would just disappoint my friends"[/i]
		"""
		"Lost Wealth": dialogue.text = """
You’ve hit rock bottom. With no money left, there’s no way forward. The weight of financial strain has overwhelmed you.

You don't even feel like asking your friends or anyone for help anymore, you once again feel hopeless.
		"""
		"High Love Event": dialogue.text = """
Your kitten has grown overly attached to you. Wherever you go, she follows, crying whenever you leave her sight. What started as love has now turned into dependence, making it difficult for her to adjust to moments without you.

[i]“I love her, but this is too much. She’s completely dependent on me now… I can't even step outside without her crying.”[/i]

The overwhelming attachment makes you realize that, in showering her with constant attention, you’ve created an unhealthy bond.
		"""
		"High Happiness Event": dialogue.text = """
You’ve reached a level of happiness where everything feels perfect. In fact, so perfect that you’ve become complacent. You no longer feel the need to push forward, try new things, or work toward goals because you’re too content with where you are.

[i]“Everything’s going so well… but am I stuck? I’m not moving forward anymore. It’s like I’m in a bubble of comfort.”[/i]

While happiness is great, becoming too satisfied has stunted your growth. You stop working on your projects, neglect responsibilities, and ultimately, life begins to crumble around you.
		"""
		"High Wealth Event": dialogue.text = """
You’ve been accumulating wealth, and now, it has become your sole focus. The money flows in, but so do the sacrifices—your time, relationships, and care for your kitten all suffer as you work harder and longer to maintain your riches.

[i]“I have everything I need, so why do I feel like something’s missing? I’ve let the pursuit of wealth take over my life.”[/i]

In the pursuit of more wealth, you’ve let the important things slip away. The more you chase after money, the less you value the things that truly matter.
		"""
		"": dialogue.text = """
		
		"""
		"": dialogue.text = """
		
		"""
		"": dialogue.text = """
		
		"""

#Random Events
		"Spare Time": dialogue.text = """
[i]"It looks like """+ GlobalVariables.kitten + """ needs some extra care for today. I have some spare time so might as well spend it on her."[/i]
		"""
#------------------------------------------------------------------------
		"Rainy Day": dialogue.text = """
[i]"It’s raining heavily outside. It somehow makes me feel relaxed."[/i]

[i]"I just feel like dozing off… Though it's also a good time to keep working as the noise of the rain keeps me focused.."[/i]
		"""
		"Take a short break": dialogue.text = """
You took a short break that involves you drinking a cup of tea and staring at the rain until it passes....
		"""
		"Stay productive": dialogue.text = """
[i]"Might as well take advantage of the rain and do something productive until it passes."[/i]
		"""
#------------------------------------------------------------------------
		"Take a Walk": dialogue.text = """
[i]"Maybe a change of scenery would help. It could give relaxation to """+ GlobalVariables.kitten + """.[/i]
 
Though I would have to keep on the lookout in case she gets lost."
		"""
		"Take a walk in the park": dialogue.text = """
You and """+ GlobalVariables.kitten + """ went to the park, she played with the other animals and especially other cats.

[i]"This is good for her, especially when her mother is gone"[/i]
		"""
		"Stay home and relax": dialogue.text = """
[i]"Maybe I'll stay home for now, this is for the better and I need to relax myself with all my responsibilities"[/i]
		"""
#------------------------------------------------------------------------
		"Kitten Gets Lost": dialogue.text = """
[i]"Where did """+ GlobalVariables.kitten + """ go? She's nowhere to be found."[/i]

[i]"Oh crud, I hope she did not go far…. I knew taking her on walks right now would be a bad idea."[/i]
		"""
#------------------------------------------------------------------------
		"Exercise Event": dialogue.text = """
[i]"I feel like exercise is one of the best way to maintain a healthy mental state, though it takes a lot of my time and I would get fatigued after"[/i]
		"""
		"Go for a run": dialogue.text = """
You geared yourself up and went for a long run, 
You come back home all sweat and tired but you feel content that you have achieved something for today.
		"""
		"Skip exercise": dialogue.text = """
[i]"Maybe not today I don't have the right motivation to exercise"[/i]
		"""
#------------------------------------------------------------------------
		"Shopping Event": dialogue.text = """
[i]"The pantry is running low. I should probably stock up on groceries and kitten supplies, and probably some toys for """+ GlobalVariables.kitten + """ along the way"[/i]
		"""
		"Go Shopping": dialogue.text = """
[i]"Alright! I'm gonna go shopping!, I will be back alright """+ GlobalVariables.kitten + """ this shouldn't take a while"[/i]
		"""
		"Delay the shopping trip": dialogue.text = """
[i]"No not right now I need to save up my money for other stuff, I'm sorry [/i]""" + GlobalVariables.kitten
#------------------------------------------------------------------------
		"Visit a Friend Event": dialogue.text = """
[i]"It’s been a while since I’ve seen my friends. They're probably very rich now, and have already reached their dreams. Maybe a visit won't hurt."[/i]
 
[i]"But of course nothing productive will come out of it, on the contrary we'd be hammered just like old times"[/i]
		"""
		"Go meet friends": dialogue.text = """
You've met with your old friends, they were stoked to see you after a very long time.

All of you got hammered to celebrate your reunion.
		"""
#------------------------------------------------------------------------
		"": dialogue.text = """

		"""

		"": dialogue.text = """

		"""

		"": dialogue.text = """

		"""

		"": dialogue.text = """

		"""

		
		
		

func animateChangeEvent(): #animate the nextPage transition
	dialogue2.text = dialogue.text #set the dialogue2 node to the same text of dialogue
	var event2Duplicate = event2.duplicate() #duplicate the default node so that we can copy it again next time
	add_child(event2Duplicate)
	event2Duplicate.visible = true #since it started as invinsible
	var tween = create_tween()
	tween.parallel().tween_property(event2Duplicate, "rotation_degrees", 32, 0.5)
	tween.parallel().tween_property(event2Duplicate, "modulate:a", 0, 0.5)
	await tween.finished
	event2Duplicate.queue_free() #delete once done

#graphic effect as if typing
func typewriter():
	typewriterSFX.play() #start to play typewriter SFX
	if typewriterTween.is_running():
		typewriterTween.stop() #resets the tween
		typewriterTween.play()
	else:
		typewriterTween = create_tween()
	dialogue.visible_ratio = 0 #for the typewriter so that when it's next page it resets the visible texts
	typewriterTween.tween_property(dialogue, "visible_ratio", 1, 12)
	typewriterTween.set_speed_scale(typewriterSpeed) #this divides the duration amount by typewriterSpeed
	OptionsAndEventsPanel.typewriterStart() #call this when the typewriter just started, so the main bus can call the options to not be visible
	await typewriterTween.finished #typewriter is done with the whole dialogue
	typewriterSFX.stop() #stop playing typewriter SFX
	OptionsAndEventsPanel.typewriterDone() #call when typewriter is done, meaning the options can now be shown

func _on_speed_button_toggled(toggled_on: bool) -> void:
	if toggled_on: #when the speed key is pressed
		changeTypewriterSpeed(10)
	else:
		changeTypewriterSpeed(3)

func changeTypewriterSpeed(speed : int) :
	typewriterSpeed = speed
	typewriterTween.set_speed_scale(typewriterSpeed)
