extends Spatial

# size of generated scenes
const genSIZE = 20
const floorSIZE = 15

# import scenes used for random generation
var maze = load("res://gen_scenes/Maze.tscn")
var checkpoint = load("res://gen_scenes/Checkpoint.tscn")
var finish = load("res://gen_scenes/Finish.tscn")
var falling = load("res://gen_scenes/Falling.tscn")
var fallinghard = load("res://gen_scenes/FallingHard.tscn")
var obstacles = load("res://gen_scenes/Obstacles.tscn")
var obstacleshard = load("res://gen_scenes/ObstaclesHard.tscn")
var walljump = load("res://gen_scenes/WallJump.tscn")
var walljumphard = load("res://gen_scenes/WallJumpHard.tscn")
var spinning = load("res://gen_scenes/Spinning.tscn")
var spinfall = load("res://gen_scenes/SpinFall.tscn")

var scenes = []
var last_translate

onready var fps_label = $ShowFPS/FPS_counter
onready var fps_el = $ShowFPS

onready var settings = get_node("/root/SettingsSingleton")

func add_instance(scene):
	var inst = scene.instance()
	inst.translation = last_translate
	add_child(inst)
	return inst

func _ready():
	last_translate = Vector3(0, 0, floorSIZE)
	
	var hardF = randi()%2
	var hardO = randi()%2
	var hardW = randi()%2
	if settings.GEN_FALLING:
		scenes.append(falling)
		scenes.append(fallinghard)
	if settings.GEN_OBSTACLES:
		scenes.append(obstacles)
		scenes.append(obstacleshard)
	if settings.GEN_SPINNING:
		scenes.append(spinning)
		scenes.append(spinfall)
	if settings.GEN_WALLS:
		scenes.append(walljump)
		scenes.append(walljumphard)
	
	
	scenes.shuffle()
	
	var inst
	# generate the scenes
	for ind in range(0, len(scenes)):
		var scene = scenes[ind]
		for i in range(0, 1+randi()%3):
			add_instance(scene)
			last_translate.z += 20
		if ind != len(scenes) - 1:
			add_instance(checkpoint)
			last_translate.z += 20
	# add maze
	if settings.GEN_MAZE:
		var maze_inst = add_instance(maze)
		var mazeScale = 10+randi()%10
		var gridMoveX = -(mazeScale+1)
		var odd = mazeScale % 2
		maze_inst.translation.z += (mazeScale * 2 + 1) - 10
		var gridMap = maze_inst.get_node("GridMap")
		gridMap.gen_maze(mazeScale, mazeScale,
			gridMoveX, 2, gridMoveX)
		last_translate.z += (mazeScale * 2 + 1) * 2
	# add finish
	add_instance(finish)
	
	
func _process(_delta):
	# game has finished
	# show finished screen with stats
	if settings.FINISHED:
		var elapsed = $Ybot.elapsed
		if !elapsed:
			elapsed = 0
		var falls = $Ybot.fallenDown
		var mins = elapsed/60
		var secs = elapsed%60
		var fpm = falls/max(0.01, mins+secs/60)
		var results_str = "STATS:\nTIME ELAPSED: %0.2dm:%0.2ds\nTOTAL FALLS: %d\nFALLS PER MINUTE: %0.2d\n" % [mins, secs, falls, fpm]
		$Finished/Stats.set_text(results_str)
		$Finished.visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		self.set_process(false)
	
	# fps toggle changed
	if settings.SHOW_FPS:
		fps_el.visible = true
		fps_label.set_text(str(Engine.get_frames_per_second()))
	else:
		fps_el.visible = false
		
func _input(event):
	# escape button was pressed
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		$SettingsInGame.visible = true


func _on_buttonbacktomenu_pressed():
	get_tree().change_scene("res://2D/Menu.tscn")
