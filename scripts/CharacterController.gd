extends KinematicBody

var moveSpeedBase : float = 5.0
var jumpForce : float = 5.0
var gravity : float = 9.8
var sprintMultiplier: float = 1.3
var moveSpeed : float
var baseRotation : float = 90
var lastRotationY : float

# for third person
# experimental, godot is still not the best for animation
const ANIMATIONS = {
	SPRINT = "Runningloop",
	JUMP = 'jumpinplace',
	WALK = 'Walkingloop',
	IDLE = 'idleloop'
}
var animation : String = ""
var vel : Vector3 = Vector3()

# for time tracking
var timeStart
var timeNow
var fallenDown = 0
var elapsed

onready var animPlayer = $AnimationPlayer
onready var camera = $CameraOrbit
onready var bodyShape = $Armature
onready var lastCheckpoint = self.global_transform.origin
onready var tween = get_parent().get_node("Tween")
onready var repeatTween = get_parent().get_node("RepeatTween")
onready var settings = get_node("/root/SettingsSingleton")
onready var armature = $Armature
onready var fpc = get_node("CameraOrbit/FirstPerson")
onready var tpc = get_node("CameraOrbit/3rdPerson")
onready var fallPlayer = $FallPlayer
onready var jumpPlayer = $JumpPlayer
onready var checkPlayer = $CheckpointPlayer

var third_person = false

func _ready():
	$AnimationPlayer.play(ANIMATIONS.IDLE)

func return_to_checkpoint():
	if settings.SFX:
		fallPlayer.play(0.06)
	fallenDown += 1
	translation = lastCheckpoint
	
func toggle_cam():
	tpc.visible = !tpc.visible
	fpc.visible = !fpc.visible
	if fpc.current:
		fpc.clear_current()
		tpc.make_current()
	else:
		tpc.clear_current()
		fpc.make_current()
	armature.visible = !armature.visible

func _physics_process(delta):
	
	# check for first to third person cam changes
	if (third_person and !settings.THIRD_PERSON or !third_person and 
		settings.THIRD_PERSON):
		toggle_cam()
		third_person = !third_person
	
	# reset velocities
	vel.x = 0
	vel.z = 0
	moveSpeed = moveSpeedBase
	
	var input = Vector3()
	
	# handle movement input
	if Input.is_action_pressed("move_forward"):
		input.z += 1
	if Input.is_action_pressed("move_backward"):
		input.z -= 1
	if Input.is_action_pressed("move_left"):
		input.x += 1
	if Input.is_action_pressed("move_right"):
		input.x -= 1
	if Input.is_action_pressed("sprint") and is_on_floor():
		moveSpeed *= sprintMultiplier
	
	# prevent speed doubling when moving diagonally
	input = input.normalized()
	

	# check if moving for animations
	if input.x != 0 or input.z != 0:
		if moveSpeed > moveSpeedBase:
			animation = ANIMATIONS.SPRINT
		else:
			animation = ANIMATIONS.WALK
	else:
		animation = ANIMATIONS.IDLE
	
	# rotate on left/right move
	if input.x >= 1:
		bodyShape.rotation_degrees.y = 90
	elif input.x <= -1:
		bodyShape.rotation_degrees.y = -90
	else:
		bodyShape.rotation_degrees.y = 0
	
	# get relative direction
	var dir = (transform.basis.z * input.z + transform.basis.x * input.x)
	
	# apply direction to velocity
	vel.x = dir.x * moveSpeed
	vel.z = dir.z * moveSpeed
	
	vel.y -= gravity * delta
	
	# handle jump, is no bunny-hop replace with is_action_just_pressed
	if Input.is_action_pressed("jump") and is_on_floor():
		vel.y = jumpForce
		if settings.SFX:
			jumpPlayer.play()
#	JUMP ANIMATION IS BUGGY, play idle instead
		animation = ANIMATIONS.IDLE
	elif !is_on_floor():
		animation = ANIMATIONS.IDLE
	
	# play new animation
	if animation != animPlayer.current_animation:
		animPlayer.play(animation)
	
	# move the player
	vel = move_and_slide(vel, Vector3.UP)
	
	if translation.y <= -5:
		# reset to checkpoint
		return_to_checkpoint()
	# collision handling
	var slide_count = get_slide_count()
	for slide in slide_count:
		var k_col = get_slide_collision(slide)
		if k_col:
			var collider = k_col.collider
			if collider.is_in_group('checkpoint'):
				if settings.SFX && lastCheckpoint != k_col.collider.global_transform.origin:
					checkPlayer.play(0.81)
				lastCheckpoint = k_col.collider.global_transform.origin
				collider.activate()
				if collider.is_in_group('first') and !timeStart:
					print('start')
					timeStart = OS.get_unix_time()
				elif collider.is_in_group('finish'):
					timeNow = OS.get_unix_time()
					if !timeStart:
						timeStart = 0
					elapsed = timeNow - timeStart
					settings.FINISHED = true
					self.set_physics_process(false)
				break
			elif collider.is_in_group('obstacle'):
				return_to_checkpoint()
				break
			elif collider.is_in_group('falling'):
				collider.fall()
				break
			elif collider.is_in_group('spinning'):
				var col_rot = collider.rotation.y
				if !lastRotationY:
					lastRotationY = col_rot
				lastRotationY -= col_rot
				rotation.y = (rotation.y - lastRotationY)
				lastRotationY = col_rot
				break
		lastRotationY = 0

	
