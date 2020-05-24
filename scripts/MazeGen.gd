extends Node

func _ready():
	pass

static func between(item, left, right):
	return item >= left and item <= right

# Maze generation using Recursive Backtracking algorithm
# Ported to GDScript from 
# http://weblog.jamisbuck.org/2010/12/27/maze-generation-recursive-backtracking
const N = 1
const S = 2
const E = 4
const W = 8
const DX = {E: 1, W: -1, N: 0, S: 0}
const DY = {E: 0, W: 0, N: -1, S: 1}
const OPPOSITE = {E: W, W: E, N: S, S: N}

# Recursive-backtracking algorithm
static func carve_passages_from(cx, cy, grid):
	var directions = [N, S, E, W]
	directions.shuffle()
	
	for dir in directions:
		var nx = cx + DX[dir]
		var ny = cy + DY[dir]
		
		if (between(ny, 0, len(grid)-1) and 
			between(nx, 0, len(grid[ny])-1) and grid[ny][nx] == 0):
			grid[cy][cx] |= dir
			grid[ny][nx] |= OPPOSITE[dir]
			carve_passages_from(nx, ny, grid)

static func gen_maze(width, height):
	var grid = []
	for i in height:
		var wArr = []
		for w in width:
			wArr.append(0)
		grid.append(wArr)
	
	carve_passages_from(0, 0, grid)
	
	return grid
	
