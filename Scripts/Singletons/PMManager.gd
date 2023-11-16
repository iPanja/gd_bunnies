extends Node
class_name PMManager

var pms: Array[WeakRef] # WeakRef[PieceManager]
var biome: Biome = preload("res://Resources/Biomes/Sand.tres")

func get_collision_pm(global_mouse_pos: Vector2) -> PieceManager:
	for wr_pm in pms:
		var pm: PieceManager = wr_pm.get_ref()
		if pm != null:
			if pm.is_inside_grid_container(global_mouse_pos):
				# Collision with this pm
				return pm
	return null

func register(pm: PieceManager) -> int:
	pms.append(weakref(pm))
	cleanup_pms()
	return pms.size()

func cleanup_pms():
	pms = pms.filter(func(wrpm): return wrpm.get_ref() != null)
