extends MarginContainer

export var is_vertical : bool = false
export (int, 3, 20) var num_bars = 20
export var bar_height : float = 40
export var bar_width : float = 20
export (int, 0, 20) var corner_radius
export var partial_bars : bool
export var horizontal_shrink : bool
export var fade : bool
export (int, 0, 20) var h_separation = 5
export (int, 0, 20) var v_separation = 5
export var inverse_color : bool = false
export var rounded_bars : bool


var bar_value : float

var bars : Array

var current_amount = 0


func _ready():
	create_bars()
		
func create_bars():
	var gauge
	if !is_vertical:
		gauge = HBoxContainer.new()
		gauge.size_flags_vertical = 10
		gauge.size_flags_horizontal = 2
		gauge.add_constant_override("separation", h_separation)
	else:
		gauge = VBoxContainer.new()
		gauge.alignment = BoxContainer.ALIGN_END
		gauge.size_flags_vertical = 10
		gauge.size_flags_horizontal = 3	
		gauge.add_constant_override("separation", v_separation)
		gauge.rect_min_size.y = num_bars * bar_height + (num_bars - 1) * v_separation
	add_child(gauge)
	move_child(gauge, 0)
	
	var stylebox: StyleBoxFlat = StyleBoxFlat.new()
	stylebox.bg_color = Color(1,1,1)
	if rounded_bars:
		stylebox.corner_radius_bottom_left = corner_radius
		stylebox.corner_radius_bottom_right = corner_radius
		stylebox.corner_radius_top_left = corner_radius
		stylebox.corner_radius_top_right = corner_radius
	for i in num_bars:
		var bar : Panel = Panel.new()
		var color : Color
		var x
		if inverse_color and !is_vertical:
			x = 0.3 - (0.3 * (float(i) / (num_bars - 1)))
		else:
			x = 0.3 * (float(i) / (num_bars - 1))
		color = Color.from_hsv(x, 1.0, 0.95, 0.85)
		bar.modulate = color
		bar.rect_min_size.x = bar_width
		bar.rect_min_size.y = bar_height
		bar.size_flags_vertical = 10
		bar.add_stylebox_override("panel", stylebox)
		gauge.add_child(bar)
		
	bar_value = 100.0 / num_bars
	bars = gauge.get_children()

func update_display(amount): 
	current_amount = amount
	var full_bars = floor(amount / bar_value)
	var remainder = (amount - full_bars * bar_value) / bar_value
	for i in num_bars:
		var bar
		if is_vertical:
			bar = bars[bars.size() - i - 1]
		else:
			bar = bars[i]
		if i <= full_bars - 1:
			bar.rect_min_size.y = bar_height
			if horizontal_shrink:
				bar.rect_min_size.x = bar_width				
			if fade:
				bar.modulate.a = 1.0
		elif i == full_bars:
			if partial_bars:
				if horizontal_shrink:
					bar.rect_min_size.x = bar_width * remainder
				else:
					bar.rect_min_size.y = bar_height * remainder
			else:
				if horizontal_shrink:
					bar.rect_min_size.x = bar_width
				else:
					bar.rect_min_size.y = bar_height
			if fade:
				bar.modulate.a = remainder
		else:
			if horizontal_shrink:
				bar.rect_min_size.x = 0
			else:
				bar.rect_min_size.y = 0
