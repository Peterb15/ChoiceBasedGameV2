extends Node2D

#@onready var player = $Player
#@onready var door = $Door

#func _ready():
	#var door_area = door.get_node("Area2D")
	
	# Connect 'area_entered' signal to Player's '_on_door_area_entered'
	#door_area.connect("area_entered", Callable(player, "_on_door_area_entered"))
	
	# Connect 'area_exited' signal to Player's '_on_door_area_exited'
	#door_area.connect("area_exited", Callable(player, "_on_door_area_exited"))
