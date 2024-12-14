## warning-ignore-all:return_value_discarded

extends Node

# ############################################################################ #
# Imports
# ############################################################################ #

var InkPlayer = load("res://addons/inkgd/ink_player.gd")

# ############################################################################ #
# Public Nodes
# ############################################################################ #

@onready var _ink_player = InkPlayer.new()

# ############################################################################ #
# Lifecycle
# ############################################################################ #

func _ready():
	# Adds the InkPlayer instance to the current scene.
	add_child(_ink_player)
	
	# Replace the example path with the actual path to your Ink JSON file.
	# Remove this line if you set 'ink_file' in the inspector instead.
	_ink_player.ink_file = load("res://path/to/file.ink.json")
	
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
	# _observe_variables()
	# _bind_externals()

	_continue_story()


# ############################################################################ #
# Private Methods
# ############################################################################ #

func _continue_story():
	while _ink_player.can_continue:
		var text = _ink_player.continue_story()
		# 'text' is a line from the Ink story. Display it in your game's UI as needed.
		print(text)
		
	if _ink_player.has_choices:
		# 'current_choices' is an array of choices, each containing text and tags.
		for choice in _ink_player.current_choices:
			print(choice.text)
			print(choice.tags)
		
		# Select a choice by its index. This example always selects the first choice.
		_select_choice(0)
	else:
		# Once the story can no longer continue and there are no choices, it's reached its end.
		print("The End")


func _select_choice(index):
	_ink_player.choose_choice_index(index)
	_continue_story()


# If you need to bind external functions from your Ink story to Godot:
# func _bind_externals():
#     _ink_player.bind_external_function("function_name_in_ink", self, "_external_function")

# func _external_function(arg1, arg2):
#     # Do something with the arguments
#     pass

# If you want to observe certain variables in your Ink story:
# func _observe_variables():
#     _ink_player.observe_variables(["var1", "var2"], self, "_variable_changed")

# func _variable_changed(variable_name, new_value):
#     print("Variable '%s' changed to: %s" % [variable_name, new_value])
