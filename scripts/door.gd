# Door.gd
extends Node2D

@export var open_animation: String = "Open"
@export var close_animation: String = "Close"  # Optional if implementing closing

var is_open: bool = false
var player_in_range: bool = false

func _ready():
	# Connect the signals for Area2D using Godot 4's syntax
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)
	
	# Ensure the AnimationPlayer is stopped initially
	$AnimationPlayer.stop()

func _process(delta):
	if player_in_range and Input.is_action_just_pressed("interact"):
		toggle_door()

func toggle_door():
	print("Toggle Door Called")
	var anim_player = $AnimationPlayer
	if is_open:
		if anim_player.has_animation(close_animation):
			anim_player.play(close_animation)
			is_open = false
	else:
		if anim_player.has_animation(open_animation):
			anim_player.play(open_animation)
			is_open = true
	# Optionally, adjust collision based on door state
	get_node("StaticBody2D/CollisionShape2D").disabled = true

func _on_body_entered(body):

	if body.name == "Player":  # Adjust based on your player node's name
		player_in_range = true
		print("Player Entered Interaction ")

func _on_body_exited(body):
	if body.name == "Player":
		player_in_range = false
		print("Player Exited Interaction ")
