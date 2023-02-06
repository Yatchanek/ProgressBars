extends Control

var current_gauge 



func _ready():
	for gauge in get_tree().get_nodes_in_group("Gauges"):
		gauge.update_display(100)
	current_gauge = $VBoxContainer/HBoxContainer/Gauge
	$HBoxContainer/VBoxContainer/HBoxContainer2/PartialButton.pressed = current_gauge.partial_bars
	$HBoxContainer/VBoxContainer/HBoxContainer/FadeButton.pressed = current_gauge.fade
	$HBoxContainer/VBoxContainer/Slider.value = current_gauge.current_amount



	for button in get_tree().get_nodes_in_group("SelectButtons"):
		button.connect("pressed", self, "_on_Gauge_selected", [button])
		
	
func _on_Gauge_selected(button):
	current_gauge = button.get_parent().get_child(1)
	$HBoxContainer/VBoxContainer/HBoxContainer2/PartialButton.pressed = current_gauge.partial_bars
	$HBoxContainer/VBoxContainer/HBoxContainer/FadeButton.pressed = current_gauge.fade
	$HBoxContainer/VBoxContainer/Slider.value = current_gauge.current_amount

func _on_PartialButton_toggled(button_pressed):
	current_gauge.partial_bars = button_pressed


func _on_FadeButton_toggled(button_pressed):
	current_gauge.fade = button_pressed


func _on_Slider_value_changed(value):
	current_gauge.update_display(value)
