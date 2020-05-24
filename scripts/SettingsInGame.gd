extends Control

onready var settings = get_node("/root/SettingsSingleton")

func _ready():
	$"SettingsContainer/checkbox-3rdperson".pressed = settings.THIRD_PERSON
	$"SettingsContainer/checkbox-fps".pressed = settings.SHOW_FPS
	$"SettingsContainer/checkbox-sfx".pressed = settings.SFX

func _on_buttonback_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	self.visible = false


func _on_buttontomenu_pressed():
	get_tree().change_scene("res://2D/Menu.tscn")


func _on_checkboxsfx_toggled(button_pressed):
	settings.SFX = button_pressed


func _on_checkbox3rdperson_toggled(button_pressed):
	settings.THIRD_PERSON = button_pressed


func _on_checkboxfps_toggled(button_pressed):
	settings.SHOW_FPS = button_pressed
