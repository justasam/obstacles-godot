extends Spatial

var lookSensitivity : float = 10.0
var minLookAngle : float = -45.0
var maxLookAngle : float = 90.0

# each frame mouse direction & speed
var mouseDelta : Vector2 = Vector2()

onready var player = get_parent()

func _ready():
	# hide mouse cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


# process mouse input
func _input(event):
	
	if event is InputEventMouseMotion:
		mouseDelta = event.relative
		
func _process(delta):
	
	# rotation vector
	var rot = Vector3(mouseDelta.y, mouseDelta.x, 0) * lookSensitivity * delta
	
	# apply vertical rotation
	rotation_degrees.x += rot.x
	rotation_degrees.x = clamp(rotation_degrees.x, minLookAngle, maxLookAngle)
	
	# rotate player as well
	player.rotation_degrees.y -= rot.y
	
	# reset mouseDelta so it doesnt spin infinitely
	mouseDelta = Vector2()
