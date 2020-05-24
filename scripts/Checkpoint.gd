extends StaticBody

onready var mi = $MeshInstance
onready var active_mat = preload('res://materials/checkpoint_on_mat.tres')

func activate():
	mi.set_surface_material(0, active_mat)
