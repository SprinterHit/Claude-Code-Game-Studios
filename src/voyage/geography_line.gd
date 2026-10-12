class_name GeographyLine
extends PanelContainer
## The one sentence that says why this shore is here. Hidden until landing.


var _label: Label


func _ready() -> void:
	visible = false
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	var style := StyleBoxFlat.new()
	style.bg_color = ChartStyle.PAPER
	style.border_color = ChartStyle.INK
	style.set_border_width_all(2)
	style.set_corner_radius_all(18)
	style.content_margin_left = 28.0
	style.content_margin_right = 28.0
	style.content_margin_top = 16.0
	style.content_margin_bottom = 16.0
	style.shadow_color = Color(0.08, 0.16, 0.18, 0.32)
	style.shadow_size = 12
	style.shadow_offset = Vector2(0, 4)
	add_theme_stylebox_override("panel", style)
	_label = Label.new()
	_label.text = ChartStyle.GEOGRAPHY_REASON
	_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_label.add_theme_font_override("font", ChartStyle.FONT)
	_label.add_theme_font_size_override("font_size", 22)
	_label.add_theme_color_override("font_color", ChartStyle.INK)
	add_child(_label)
	set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	offset_left = -520.0
	offset_right = 520.0
	offset_top = -118.0
	offset_bottom = -42.0


func show_reason() -> void:
	visible = true


func reason_text() -> String:
	return _label.text if _label != null else ""
