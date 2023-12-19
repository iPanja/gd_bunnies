extends Node

var playerData = PlayerData.new()
const SAVE_FILE_DEST = "user://player_save_data.res"

func saveData():
	var result = ResourceSaver.save(playerData, SAVE_FILE_DEST)
	assert(result == OK)

func loadData():
	if ResourceLoader.exists(SAVE_FILE_DEST):
		var playerData = ResourceLoader.load(SAVE_FILE_DEST)
		if playerData is PlayerData:
			return playerData

func _ready():
	# Load player data, create new one if non-existent
	var playerData = loadData()
	if !playerData:
		playerData = PlayerData.new()
