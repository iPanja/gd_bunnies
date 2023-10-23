extends Node

@export var width=8
@export var height=8
@export var biome="snow"
@export var time=60

func _init():
	pass
	
func new():
	var resource = preload("res://Models/Puzzle.gd")
	return resource.new()
