extends Control


func _ready():
	seed(int(OS.get_unix_time()))
	
onready var settings = $"/root/SettingsSingleton"


func _on_buttontittleplay_pressed():
	settings.FINISHED = false
	get_tree().change_scene("res://Level.tscn")


func _on_buttontitlesettings_pressed():
	get_tree().change_scene("res://2D/Settings.tscn")


func _on_buttontitlequit_pressed():
	get_tree().quit()
