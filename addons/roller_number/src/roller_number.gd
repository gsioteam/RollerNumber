tool
extends HBoxContainer

const CharWidget = preload("res://addons/roller_number/src/Char.tscn")

export (int) var number setget set_number, get_number
export (float) var duration = 0.6

export (Color) var font_color = Color.transparent setget set_font_color, get_font_color

var _block_size: Vector2
var _num_blocks = []
var _tween: Tween

func _ready():
	if not has_constant_override("separation"):
		add_constant_override("separation", 0)
	if not _tween:
		_tween = Tween.new()
		_tween.connect("tween_completed", self, "_on_tween_completed")
		add_child(_tween)
	_reload()

func make_bits(bit_count):
	if _block_size == Vector2.ZERO:
		var font = get_font("font", "Label")
		_block_size = font.get_string_size("0")
	while _num_blocks.size() < bit_count:
		var ch = CharWidget.instance()
		ch.rect_min_size = _block_size
		ch.theme = theme
		ch.font_color = self.font_color
		ch.zero_blank = !_num_blocks.empty()
		_num_blocks.append(ch)
		add_child(ch)
		move_child(ch, 0)

func _reload():
	if _number < 0:
		_number = abs(_number)
	var arr = bits(_number)
	make_bits(arr.size())
	for idx in range(arr.size(), _num_blocks.size()):
		var ch = _num_blocks[idx]
		ch.visible = false
	var size = arr.size()
	for idx in range(size):
		var ch = _num_blocks[idx]
		ch.index = arr[idx]
		ch.rect_min_size = _block_size
		ch.visible = true
		

func bits(number: int) -> PoolIntArray:
	var arr = PoolIntArray()
	var tmp = number
	while tmp != 0:
		arr.append(tmp)
		tmp = int(tmp / 10)
	if arr.empty():
		arr.append(0)
	return arr

var _number = 0
func set_number(v):
	if _number != v:
		_number = v
		_reload()

func get_number():
	return _number

func animate_to(number: int):
	if _tween == null:
		return
	_number = number
	var arr = bits(number)
	make_bits(arr.size())
	_tween.remove_all()
	var count = 0
	for ch in _num_blocks:
		if ch.visible:
			count += 1
	if count < arr.size():
		count = arr.size()
	for idx in range(count):
		var to_index = 0
		if idx < arr.size():
			to_index = arr[idx]
		var ch = _num_blocks[idx]
		ch.visible = true
		_tween.interpolate_property(ch, "index", ch.index, to_index, duration * (count - idx) / count)
	_tween.start()

func _on_tween(value: float):
	print(value)

var _animate_number
func set_animate_number(v):
	if _animate_number != v:
		_animate_number = v
		animate_to(v)

func get_animate_number():
	return _animate_number

func _on_tween_completed(object, path):
	if object.index == 0:
		object.visible = false

var _font_color = Color.transparent
func set_font_color(v):
	if _font_color != v:
		_font_color = v
		for ch in _num_blocks:
			ch.font_color = v

func get_font_color():
	return _font_color
