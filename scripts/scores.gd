extends Node2D
var leaderboard

# Called when the node enters the scene tree for the first time.
func _ready():
	Score._get_leaderboards()
	$RichTextLabel.text = Score.leaderboardFormatted
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$RichTextLabel.text = Score.leaderboardFormatted
	$Label2.text = Score.pId + " - " + str(Score.score)
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_file ("res://main_menu.tscn")
	pass
