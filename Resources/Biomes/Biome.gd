extends Resource

class_name Biome

@export var name: String
@export var rows: int
@export var cols: int
@export var time: int # Seconds
@export var obstacles: bool

@export var background: Texture2D
@export var board_background: Texture2D
@export var tile_background: Texture2D
@export var hidden_cover: Texture2D
@export var board_background_color: Color
@export var rules_texture: Texture2D

# @export biome_reward: Bunny
