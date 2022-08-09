tool
extends EditorPlugin


func _enter_tree():
	add_custom_type(
		"RollerNumber",
		"HBoxContainer",
		preload("res://addons/roller_number/src/roller_number.gd"),
		preload("res://addons/roller_number/src/roller.png")
	)


func _exit_tree():
	remove_custom_type("RollerLabel")
