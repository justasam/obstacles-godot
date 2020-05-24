extends Control



onready var settings = get_node("/root/SettingsSingleton")

func _ready():
	$"SettingsContainer/checkbox-3rdperson".pressed = settings.THIRD_PERSON
	$"SettingsContainer/checkbox-falling".pressed = settings.GEN_FALLING
	$"SettingsContainer/checkbox-fps".pressed = settings.SHOW_FPS
	$"SettingsContainer/checkbox-maze".pressed = settings.GEN_MAZE
	$"SettingsContainer/checkbox-obstacles".pressed = settings.GEN_OBSTACLES
	$"SettingsContainer/checkbox-sfx".pressed = settings.SFX
	$"SettingsContainer/checkbox-spinner".pressed = settings.GEN_SPINNING
	$"SettingsContainer/checkbox-walls".pressed = settings.GEN_WALLS

func _on_buttonbacktomenu_pressed():
	get_tree().change_scene("res://2D/Menu.tscn")


func _on_seededit_text_changed(new_text):
	var int_text = int(new_text)
	if int_text:
		seed(int_text)


func _on_checkbox3rdperson_toggled(button_pressed):
	settings.THIRD_PERSON = button_pressed


func _on_checkboxsfx_toggled(button_pressed):
	settings.SFX = button_pressed


func _on_checkboxfps_toggled(button_pressed):
	settings.SHOW_FPS = button_pressed


func _on_buttonback_pressed():
	get_tree().change_scene("res://2D/Menu.tscn")


func _on_checkboxmaze_toggled(button_pressed):
	settings.GEN_MAZE = button_pressed


func _on_checkboxspinner_toggled(button_pressed):
	settings.GEN_SPINNING = button_pressed


func _on_checkboxfalling_toggled(button_pressed):
	settings.GEN_FALLING = button_pressed


func _on_checkboxobstacles_toggled(button_pressed):
	settings.GEN_OBSTACLES = button_pressed


func _on_checkboxwalls_toggled(button_pressed):
	settings.GEN_WALLS = button_pressed
