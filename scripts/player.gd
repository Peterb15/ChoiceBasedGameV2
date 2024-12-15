extends CharacterBody2D

var speed = 300.0
var door_in_range: Door = null
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and door_in_range != null:
		print("Interact pressed. Attempting to open door.")
		door_in_range.open()
	
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

func _on_door_area_entered(area: Area2D):
	print("Entered door area.")
	var door = area.get_parent()
	if door is Door:
		print("Door detected.")
		door_in_range = door

func _on_door_area_exited(area: Area2D):
	print("Exited door area.")
	var door = area.get_parent()
	if door_in_range == door:
		print("Door no longer in range.")
		door_in_range = null
