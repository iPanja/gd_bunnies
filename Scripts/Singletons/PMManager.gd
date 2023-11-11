extends Node
class_name PMManager

var pms: Array[PieceManager]
var biome: Biome = preload("res://Resources/Biomes/Sand.tres")

func get_collision_pm(global_mouse_pos: Vector2) -> PieceManager:
	for pm in pms:
		if pm.is_inside_grid_container(global_mouse_pos):
			# Collision with this pm
			return pm
	return null

func register(pm: PieceManager) -> int:
	pms.append(pm)
	return pms.size()
