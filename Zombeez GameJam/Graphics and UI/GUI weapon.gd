extends PanelContainer

@onready var bullet_count_label = $VBoxContainer/BulletCount
@onready var gun_scene = $"../../Player/Hand/Gun"
@onready var gun_display = $VBoxContainer/Weapon

var bullet_count = 100
var gun_data 

func instantiated(gun_tres):
	gun_data = gun_tres
	reload_gun()

func reload_gun():
	if gun_data == null:
		return
	gun_scene.can_shoot = false
	await get_tree().create_timer(gun_data.rate_of_fire * 2).timeout
	gun_scene.can_shoot = true
	gun_data.bullets = gun_data.max_ammo
	bullet_count = gun_data.bullets
	update_text_label()

func bullet_remaining():
	if bullet_count <= 0:
		return bullet_count
	bullet_count -= 1
	update_text_label()
	gun_scene.gun_shot()
	return 1

func change_gun(gun_tres):
	gun_data = gun_tres
	gun_display.texture = gun_data.texture
	bullet_count = gun_data.bullets
	update_text_label()

func update_text_label():
	bullet_count_label.text = "[center][heart]"
	bullet_count_label.text += str(bullet_count)
	bullet_count_label.text += "[/heart]/" + str(gun_data.max_ammo) 
