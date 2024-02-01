extends HBoxContainer

@onready var parent = get_parent().get_parent()
@onready var plus = $PlusButton
@onready var xbtn = $XButton
@onready var ok = $OKButton
@onready var textbox = $NewCharacterText

func _on_plus_button_pressed():
	plus.hide()
	ok.show()
	xbtn.show()
	textbox.set_text("")
	textbox.show()
	
func check_available_name():
	var name_array : Array[String] = []
	for iternumber : int in self.get_child_count():
		var child = self.get_child(iternumber)
		if "ischaracterline" in child:
			name_array.append(child.get_text())
	return name_array

func update_all_name_list(namelist : Array[String] = check_available_name()):
	for iternumber : int in parent.get_child_count():
		var child = parent.get_child(iternumber)
		if "islinecontainer" in parent.get_child(iternumber):
			child.update_character(namelist)

func add_names_from_list(list):
	for new_name in list:
		if new_name not in check_available_name():
			var last_chara
			for iternumber : int in self.get_child_count():
				if "ischaracterline" in self.get_child(iternumber):
					last_chara = self.get_child(iternumber)
					
			var new_chara_inst = load("res://scenes/character_line.tscn").instantiate()
			last_chara.add_sibling(new_chara_inst)
			new_chara_inst.set_text(new_name)
			update_all_name_list()

func _on_ok_button_pressed():
	var new_chara_name = textbox.get_text()
	if new_chara_name and new_chara_name not in check_available_name():
		var last_chara
		for iternumber : int in self.get_child_count():
			if "ischaracterline" in self.get_child(iternumber):
				last_chara = self.get_child(iternumber)
				
		var new_chara_inst = load("res://scenes/character_line.tscn").instantiate()
		last_chara.add_sibling(new_chara_inst)
		new_chara_inst.set_text(new_chara_name)
		update_all_name_list()
		
	plus.show()
	ok.hide()
	xbtn.hide()
	textbox.hide()

func _on_x_button_pressed():
	plus.show()
	ok.hide()
	xbtn.hide()
	textbox.hide()
