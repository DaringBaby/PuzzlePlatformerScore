extends CharacterBody2D


const SPEED =200.0
var DASH_SPEED = 320
const JUMP_VELOCITY = -300.0

var last_checkpoint = Vector2()

var score  = 0
var deaths = 0
var lives = 10

var dj = true
var max_falling_speed = 450
var wall_hugging = false
var wj = false
var dashing = false
var right = true
var can_dash = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var particles = preload("res://particles.tscn")

func _ready():
	last_checkpoint = Vector2(24, 250)
	pass

func on_got_leaderboard():
	get_tree().change_scene_to_file ("res://scores.tscn")
	pass

func animations():
	if velocity.x == 0 and is_on_floor():
		$Sprite2D.play("default")
	if right:
		$Sprite2D.flip_h = false
	else:
		$Sprite2D.flip_h = true
	if velocity.x != 0 and is_on_floor() and not $Sprite2D.animation == "walking":
		$Sprite2D.play("walking")
	if wall_hugging:
		$Sprite2D.play("wallhug")
	


func _physics_process(delta):
	animations()
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		if velocity.y > max_falling_speed:
			velocity.y = max_falling_speed
	else:
		dj = true
		can_dash = true
	
	if wall_hugging:
		dj = true
		can_dash = true


	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and (is_on_floor() or wall_hugging):
		velocity.y = JUMP_VELOCITY
		if wall_hugging:
			right = !right
			$Timer.start()
			dj = true
			wj = true
			if right:
				velocity.x += SPEED
			else:
				velocity.x -= SPEED
		$Sprite2D.play("jumping")
	# DOUBLE JUMP
	if Input.is_action_just_pressed("ui_accept") and dj and (not is_on_floor() and not wall_hugging):
		dj = false
		velocity.y = JUMP_VELOCITY
		$Sprite2D.play("jumping")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if !wj and !dashing:
		if right:
			DASH_SPEED = 320
		else:
			DASH_SPEED = -320
		var direction = Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		if Input.is_action_just_pressed("dash") and can_dash:
			$DashTimer.start()
			dashing = true
			can_dash = false
		if Input.is_action_pressed("ui_left"):
			right = false
		elif Input.is_action_pressed("ui_right"):
			right = true
	elif dashing:
		velocity.y = 0
		if right:
			DASH_SPEED = 320
		else:
			DASH_SPEED = -320
		velocity.x =DASH_SPEED

	move_and_slide()


func _on_hitbox_body_entered(body):
	var part = particles.instantiate()
	part.position = position
	part.emitting = true
	get_tree().get_root().add_child(part)
	deaths += 1
	lives -= 1
	dashing = false
	position = last_checkpoint
	velocity.x = 0
	velocity.y = 0
	if lives < 0:
		# Game Over 
		Score._upload_score(score)
		get_tree().change_scene_to_file ("res://scores.tscn")
		pass
	pass # Replace with function body.


func _on_wall_hug_body_entered(body):
	print(body.name)
	if body.name == "Terrain" or body.name == "Spikes":
		max_falling_speed = 50
		wall_hugging = true
	pass # Replace with function body.


func _on_wall_hug_body_exited(body):
	if body.name == "Terrain" or body.name == "Spikes":
		max_falling_speed = 450
		wall_hugging = false
	pass # Replace with function body.


func _on_timer_timeout():
	wj = false
	pass # Replace with function body.


func _on_dash_timer_timeout():
	dashing = false
	pass # Replace with function body.


func _on_hitbox_area_entered(area):
	lives += 5
	var camera_limit_top
	var camera_limit_bottom
	if area.is_in_group("NextZone"):
		dashing = false
		score += 1
		last_checkpoint.x = 24
	match decide_zone():
		0:
			last_checkpoint.y = 320-48
			camera_limit_top = 320*0
			camera_limit_bottom = 320*1
		1:
			last_checkpoint.y = (320*2)-48
			camera_limit_top = 320*1
			camera_limit_bottom = 320 * 2
		2:
			last_checkpoint.y = (320*3)-48
			camera_limit_top = 320*2
			camera_limit_bottom = 320 * 3
		3:
			last_checkpoint.y = (320*4)-48
			camera_limit_top = 320*3
			camera_limit_bottom = 320 * 4
		4:
			last_checkpoint.y = (320*5)-48
			camera_limit_top = 320*4
			camera_limit_bottom = 320 * 5
		5:
			last_checkpoint.y = (320*6)-48
			camera_limit_top = 320*5
			camera_limit_bottom = 320 * 6
		6:
			last_checkpoint.y = (320*7)-48
			camera_limit_top = 320*6
			camera_limit_bottom = 320 * 7
		7:
			last_checkpoint.y = (320*8)-48
			camera_limit_top = 320*7
			camera_limit_bottom = 320 * 8
		8:
			last_checkpoint.y = (320*9)-48
			camera_limit_top = 320*8
			camera_limit_bottom = 320 *9
		9:
			last_checkpoint.y = (320*10)-48
			camera_limit_top = 320*9
			camera_limit_bottom = 320 * 10
	position = last_checkpoint
	$Camera2D.limit_top = camera_limit_top
	$Camera2D.limit_bottom = camera_limit_bottom
	pass # Replace with function body.

func decide_zone():
	randomize()
	var zone = randi_range(0, 9)
	return zone
