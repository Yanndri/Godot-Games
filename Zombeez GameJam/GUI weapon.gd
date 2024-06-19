extends PanelContainer

@onready var bullet_count_label = $VBoxContainer/BulletCount
@onready var gun = $"../../Player/Hand/Gun"
@onready var gun_display = $VBoxContainer/Weapon

var bullet_count = 100

func reload_gun():
	bullet_count = gun.max_ammo
	bullet_count_label.text = str(bullet_count) + "/" + str(gun.max_ammo) 

func bullet_remaining():
	if bullet_count <= 0:
		return bullet_count
	bullet_count -= 1
	bullet_count_label.text = str(bullet_count) + "/" + str(gun.max_ammo) 
	gun.gun_shot()
	return 1

func change_gun(gun_type, gun_tres):
	gun_display.texture = gun_type
	bullet_count = gun_tres.bullet_count
	bullet_count_label.text = str(bullet_count) + "/" + str(gun.max_ammo) 
