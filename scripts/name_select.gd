extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !$LineEdit.text.is_empty() and Input.is_action_just_pressed("ui_accept"):
		Score.pId = $LineEdit.text
		Score._authentication_request()
		await get_tree().create_timer(0.5).timeout
		Score._change_player_name()
		get_tree().change_scene_to_file ("res://world.tscn")
	pass
