extends Panel


func set_texture(texture: Texture2D):
	var stylebox = get_theme_stylebox("panel")
	stylebox.texture = texture
