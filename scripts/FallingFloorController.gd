extends StaticBody

onready var tween: Tween = get_node("/root/Level/Tween")

func _reset_falling():
	add_to_group('falling')

func fall():
	remove_from_group('falling')
	tween.interpolate_property(self, 'translation', translation,
		translation - Vector3(0, 10, 0), 0.9, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.1)
	tween.interpolate_property(self, 'translation', translation - Vector3(0, 10, 0),
		translation, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 1.1)
	tween.interpolate_callback(self, 1.4, '_reset_falling')
	tween.start()
