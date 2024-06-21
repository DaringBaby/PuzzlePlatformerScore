extends CharacterBody2D


const SPEED =200.0
var DASH_SPEED = 320
const JUMP_VELOCITY = -300.0

var last_checkpoint = Vector2()

var score  = 0
var deaths = 0
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
	last_checkpoint = Vector2(32, 250)
	pass


func _physics_process(delta):
	print($DashTimer.time_left)
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
			velocity.x += SPEED
	# DOUBLE JUMP
	if Input.is_action_just_pressed("ui_accept") and dj and (not is_on_floor() and not wall_hugging):
		dj = false
		velocity.y = JUMP_VELOCITY

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
	if body.name == "Spikes":
		print("die")
		var part = particles.instantiate()
		part.position = position
		part.emitting = true
		get_tree().get_root().add_child(part)
		deaths += 1
		position = last_checkpoint
	pass # Replace with function body.


func _on_wall_hug_body_entered(body):
	print(body.name)
	if body.name == "Terrain":
		max_falling_speed = 50
		wall_hugging = true
	pass # Replace with function body.


func _on_wall_hug_body_exited(body):
	if body.name == "Terrain":
		max_falling_speed = 450
		wall_hugging = false
	pass # Replace with function body.


func _on_timer_timeout():
	wj = false
	pass # Replace with function body.


func _on_dash_timer_timeout():
	dashing = false
	pass # Replace with function body.
