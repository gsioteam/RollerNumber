tool
extends EditorPlugin


func _enter_tree():
	add_custom_type(
		"RollerLabel",
		"HBoxContainer",
		preload("res://addons/roller_label/src/roller_label.gd"),
		preload("res://addons/roller_label/src/roller.png")
	)


func _exit_tree():
	remove_custom_type("RollerLabel")
