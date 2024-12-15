extends Node2D
class_name Door

@export var opened: bool = false
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var door_collision = $StaticBody2D/CollisionShape2D

func open():
	if not opened:
		print("Door open called.")
		opened = true
		sprite.play("door_opening")
		door_collision.disabled = true

func close():
	if opened:
		print("Door close called.")
		opened = false
		sprite.play("default")
		door_collision.disabled = false
