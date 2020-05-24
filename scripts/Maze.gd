extends GridMap

var mazeGen = load("res://scripts/MazeGen.gd")
onready var floor_obj = get_parent().get_node("Floor")

func gen_maze(mazeWidth, mazeHeight, mapX, mapY, mapZ):
	var grid = mazeGen.gen_maze(mazeWidth, mazeHeight)
	
	var totalGridWidth = mazeWidth * 2 + 1
	var totalGridHeight = mazeHeight * 2 + 1
	
	var centerOpening = int(totalGridWidth / 2 - (1-totalGridWidth%2))
	var wall = mesh_library.get_item_mesh(0)
	
	var addX = 0
	var addY = 0

	# draw grid onto gridmap
	for y in mazeHeight:
		addY += 1
		addX = 0
		for x in mazeWidth:
			addX += 1
			# diagonal
			set_cell_item(mapX + x+addX - 1, mapY, mapZ + y + addY - 1, 0)
			set_cell_item(mapX + x+addX + 1, mapY, mapZ + y + addY - 1, 0)
			set_cell_item(mapX + x+addX - 1, mapY, mapZ + y + addY + 1, 0)
			set_cell_item(mapX + x+addX + 1, mapY, mapZ + y + addY + 1, 0)
			# maze
			if grid[y][x] & mazeGen.S == 0:
				set_cell_item(mapX + x+addX, mapY, mapZ + y+addY+1, 0)
			if grid[y][x] & mazeGen.N == 0:
				set_cell_item(mapX + x+addX, mapY, mapZ + y+addY-1, 0)
			if grid[y][x] & mazeGen.E == 0:
				set_cell_item(mapX + x+addX+1, mapY, mapZ + y+addY, 0)
			if grid[y][x] & mazeGen.W == 0:
				set_cell_item(mapX + x+addX-1, mapY, mapZ + y+addY, 0)
	# add openings
	set_cell_item(mapX + centerOpening, mapY, mapZ, -1)
	set_cell_item(mapX + centerOpening, mapY, mapZ+1, -1)
	set_cell_item(mapX + centerOpening, mapY, mapZ+totalGridHeight-1, -1)
	
	floor_obj.translation.x -= 1
	floor_obj.set_scale(Vector3(totalGridWidth, 1, totalGridHeight))
	translation.z += 1
	
