extends HBoxContainer

@onready var parent = get_parent().get_parent()
@onready var plus = $PlusButton
@onready var xbtn = $XButton
@onready var ok = $OKButton
@onready var textbox = $NewCharacterText

func _ready():
	textbox.text_submitted.connect(_on_text_submitted)

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

func init_charalist():
	parent.update_charalist(check_available_name())
	return parent.get_charalist()

func update_all_name_list(namelist : Array[String] = init_charalist()):
	for iternumber : int in parent.get_child_count():
		var child = parent.get_child(iternumber)
		if "islinecontainer" in child:
			child.update_character(namelist)

func check_new_names_from_parent():
	for charaname in parent.get_charalist():
		if charaname not in check_available_name():
			add_new_name_to_charalist(charaname)

func add_new_name_to_charalist(new_chara_name):
	var last_chara
	for iternumber : int in self.get_child_count():
		if "ischaracterline" in self.get_child(iternumber):
			last_chara = self.get_child(iternumber)
			
	var new_chara_inst = load("res://scenes/character_line.tscn").instantiate()
	last_chara.add_sibling(new_chara_inst)
	new_chara_inst.set_text(new_chara_name)
	parent.update_charalist([new_chara_name])

func update_parent_charalist():
	parent.update_charalist(check_available_name())

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

func _on_ok_button_pressed(text = ""):
	var new_chara_name : String = textbox.get_text()
	if text:
		new_chara_name = text
	if !new_chara_name.is_empty() and (new_chara_name not in parent.get_charalist()):
		add_new_name_to_charalist(new_chara_name)
		print(parent.get_charalist())
		update_all_name_list(parent.get_charalist())
		
	plus.show()
	ok.hide()
	xbtn.hide()
	textbox.hide()

func _on_text_submitted(text):
	_on_ok_button_pressed(text)

func _on_x_button_pressed():
	plus.show()
	ok.hide()
	xbtn.hide()
	textbox.hide()
