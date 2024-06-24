extends Node2D
var transp = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_file ("res://name_select.tscn")
	pass


func _on_timer_timeout():
	transp = !transp
	if transp:
		$Label2.modulate.a = 0
	else:
		$Label2.modulate.a = 1
	pass # Replace with function body.


func _on_audio_stream_player_finished():
	$AudioStreamPlayer.play()
	pass # Replace with function body.
