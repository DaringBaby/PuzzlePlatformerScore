extends Node2D
var fullscreen = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("fullscreen"):
		fullscreen = !fullscreen
		if fullscreen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	$GUI/Score.text = "Score:  " + str($Player.score)
	$GUI/Deaths.text = "Deaths: " + str($Player.deaths)
	$GUI/Lives.text = "Lives: " + str($Player.lives)
	pass


func _on_audio_stream_player_finished():
	$AudioStreamPlayer.play()
	pass # Replace with function body.
