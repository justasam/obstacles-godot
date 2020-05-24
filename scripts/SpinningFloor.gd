extends StaticBody

onready var tween = get_node("/root/Level/RepeatTween")

func _ready():
	tween.interpolate_property(self, 'rotation', rotation, rotation + Vector3(0, deg2rad(360), 0), 1)
	tween.start()
