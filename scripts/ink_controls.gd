## warning-ignore-all:return_value_discarded

extends Node

# ############################################################################ #
# Imports
# ############################################################################ #

var InkPlayer = load("res://addons/inkgd/ink_player.gd")
@onready var choice_btn = load("res://scenes/dialog_button.tscn")
#@onready var f_happy_icon = load("res://ex_assets/fm01/fm01-mouth-smile01.png")
#@onready var f_body_icon = load("res://ex_assets/fm02/fm02-body.png")

# ############################################################################ #
# Public Nodes
# ############################################################################ #

@onready var _ink_player = InkPlayer.new()
@onready var _btn = []

# ############################################################################ #
# Lifecycle
# ############################################################################ #

func _ready():
	# Adds the InkPlayer instance to the current scene.
	add_child(_ink_player)
	
	# Replace the example path with the actual path to your Ink JSON file.
	# Remove this line if you set 'ink_file' in the inspector instead.
	_ink_player.ink_file = load("res://assets/SFH_Draft_2.ink.json")
	
	# On platforms that support it, this will load the story in a background thread.
	_ink_player.loads_in_background = true
	
	# Connect the "loaded" signal to the _story_loaded function.
	_ink_player.connect("loaded", Callable(self, "_story_loaded"))
	
	# Create the story. The "loaded" signal will be emitted once the Ink story is ready.
	_ink_player.create_story()


# ############################################################################ #
# Signal Receivers
# ############################################################################ #

func _story_loaded(successfully: bool):
	if !successfully:
		return

	# You can call helper functions here, for example:
	_observe_variables()
	# _bind_externals()

	_continue_story()


# ############################################################################ #
# Private Methods
# ############################################################################ #

func _continue_story():
	while _ink_player.can_continue:
		var text = _ink_player.continue_story()
		# 'text' is a line from the Ink story. Display it in your game's UI as needed.
		#print(text)
		
		var dialog_text = get_node("ColorRect/Label")
		var prior_text = get_node("ColorRect/PriorLabel")
		prior_text.text = dialog_text.text
		dialog_text.text = text
		if prior_text.text[0] == 'A':
			$ColorRect/PriorLabel.add_theme_color_override("font_color", Color(0, 1, 0))
		elif prior_text.text[0] == 'U' or prior_text.text[0] == 'T':
			$ColorRect/PriorLabel.add_theme_color_override("font_color", Color(1, 0, 0))
		else:
			$ColorRect/PriorLabel.add_theme_color_override("font_color", Color.WHITE)
			
		if dialog_text.text[0] == 'A':
			$ColorRect/Label.add_theme_color_override("font_color", Color(0, 1, 0))
		elif dialog_text.text[0] == 'U' or prior_text.text[0] == 'T':
			$ColorRect/Label.add_theme_color_override("font_color", Color(1, 0, 0))
		else:
			$ColorRect/Label.add_theme_color_override("font_color", Color.WHITE)
		
	if _ink_player.has_choices:
		# 'current_choices' is an array of choices, each containing text and tags.
		for choice in _ink_player.current_choices:
			#print(choice.text)
			#print(choice.tags)
			var button = choice_btn.instantiate()
			button.text = choice.text
			
			#button.connect("pressed", self, "_index_choose", [button]) GODOT v3
			button.connect("pressed", Callable(self, "_index_choice").bind(button))
			
			_btn.append(button)
			$ColorRect/Choice_Container.add_child(button)
		# Select a choice by its index. This example always selects the first choice.
		#_select_choice(0)
	else:
		# Once the story can no longer continue and there are no choices, it's reached its end.
		$ColorRect/Close.visible = true
		$ColorRect/Close.connect("pressed", Callable(self, "_close_btn"))
		print("The End")

func _index_choice(button):
	var index = _btn.find(button)
	if index != -1:
		_select_choice(index)

func _select_choice(index):
	for button in $ColorRect/Choice_Container.get_children():
		$ColorRect/Choice_Container.remove_child(button)
		_btn.erase(button)
	_ink_player.choose_choice_index(index)
	_continue_story()

func _close_btn():
	$ColorRect.visible = false
	$ColorRect2.visible = false
	#$Male.visible = false
	#$Female.visible = false
	$ColorRect/Close.visible = false

# If you need to bind external functions from your Ink story to Godot:
# func _bind_externals():
#     _ink_player.bind_external_function("function_name_in_ink", self, "_external_function")

# func _external_function(arg1, arg2):
#     # Do something with the arguments
#     pass

# If you want to observe certain variables in your Ink story:
func _observe_variables():
	_ink_player.observe_variables(["chapterTwo"], self, "_variable_changed")

func _variable_changed(variable_name, new_value):

	if variable_name == "chapterTwo" and new_value == true:
		$Camera2D.zoom = Vector2(.5, .76)
	#if variable_name == "f_happy" and new_value == true:
		#$Female.texture = f_happy_icon
	#if variable_name == "f_happy" and new_value == false:
		#$Female.texture = f_body_icon
	print("Variable '%s' changed to: %s" % [variable_name, new_value])
