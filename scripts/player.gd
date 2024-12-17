extends CharacterBody2D

var speed = 300.0
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:

	
	var input_dir = Vector2.ZERO

	# Check for directional inputs
	if Input.is_action_pressed("move_up"):
		input_dir.y -= 1
		sprite.play("walk_up")
	if Input.is_action_pressed("move_down"):
		input_dir.y += 1
		sprite.play("walk_down")
	if Input.is_action_pressed("move_left"):
		input_dir.x -= 1
		sprite.play("walk_left")
	if Input.is_action_pressed("move_right"):
		input_dir.x += 1
		sprite.play("walk_right")
	else:
		sprite.play("default")

	# Normalize to prevent faster diagonal movement
	if input_dir != Vector2.ZERO:
		input_dir = input_dir.normalized()

	# Update the velocity and move
	velocity = input_dir * speed
	move_and_slide()
