extends Node2D

@onready var bullet_type = $BulletType
@onready var bullet_timer = $Bullet_Timer

var pistol = preload("res://Art/Zombeez Assets/bullets/bullet_1_1.png")
var super_pistol = preload("res://Art/Zombeez Assets/bullets/bullet_3_3.png")

@export var bullet_lifetime = 0.3

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1:
			bullet_type.texture = pistol
		if event.button_index == 2:
			bullet_type.texture = super_pistol

func _ready():
	bullet_timer.wait_time = bullet_lifetime
	bullet_timer.start()

func _on_bullet_timer_timeout():
	queue_free()  # Remove the bullet after the specified time
