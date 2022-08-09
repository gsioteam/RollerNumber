tool
extends Control

export (PoolStringArray) var char_set setget set_char_set, get_char_set
export (float) var index setget set_index, get_index
export (bool) var zero_blank = false

var _char_set: PoolStringArray
func set_char_set(v):
	if _char_set != v:
		_char_set = v

func get_char_set():
	return _char_set

var _index = 0
func set_index(v):
	if _index != v:
		_index = v
		update()

func get_index():
	return _index

func _draw():
	if self.char_set.empty():
		return
	var fn:Font = get_font("font", "Label")
	
	var total = self.char_set.size()
	var index = self.index - int(self.index / total) * total
	var lower = int(index)
	var higher = (lower + 1) % total
	
	var line_height = fn.get_height()
	var offset = index - lower
	var lower_str = self.char_set[lower]
	if int(self.index) != 0 or !zero_blank:
		fn.draw(get_canvas_item(), Vector2(0, fn.get_ascent() + line_height * offset), lower_str)
	if offset != 0:
		var higher_str = self.char_set[higher]
		fn.draw(get_canvas_item(), Vector2(0, fn.get_ascent() + line_height * (-1 + offset)), higher_str)
