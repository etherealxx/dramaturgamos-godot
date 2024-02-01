extends VBoxContainer

var first_two_names := ["", ""]
var character_list : Array[String] = []

@onready var charlist_line = $CharacterScroll/CharacterList

func _ready():
	charlist_line.update_all_name_list()

func charalistline_updateall():
	charlist_line.check_new_names_from_parent()

func update_charalist(list):
	var templist_noduplicates : Array[String] = []
	var templist : Array[String] = character_list
	templist.append_array(list)
	
	for charaname in templist:
		if not templist_noduplicates.has(charaname):
			templist_noduplicates.append(charaname)
	
	character_list = templist_noduplicates
	

func get_charalist():
	return character_list

func fill_first_two_names(index, chara):
	first_two_names.insert(index, chara)

func get_linecontainer_amount():
	var iter_linecontainer = 0
	for iternumber : int in self.get_child_count():
		var child = self.get_child(iternumber)
		if "islinecontainer" in child:
				iter_linecontainer += 1
	return iter_linecontainer

func get_linecontainer_at_index(index : int):
	var iter_linecontainer = 0
	for iternumber : int in self.get_child_count():
		var child = self.get_child(iternumber)
		if "islinecontainer" in child:
			if iter_linecontainer == index:
				return child
			else:
				iter_linecontainer += 1
	return null

func append_line_container(character, dialog):
	var new_linecont = load("res://scenes/line_container.tscn").instantiate()
	var last_linecont = get_linecontainer_at_index(get_linecontainer_amount() - 1)
	last_linecont.add_sibling(new_linecont)
	#print(self.get_script())
	#print(new_linecont.get_script())
	new_linecont.set_script(last_linecont.get_script())
	#new_linecont.set_character_names(new_linecont.character_names)
	new_linecont.update_character(get_charalist())
	new_linecont.set_character_by_name(character)
	new_linecont.set_dialog(dialog)
	return new_linecont
	#last_linecont.check_first_two()
	#
	#var new_linecont_index : int = new_linecont.check_linecontainer_index(new_linecont)
	#print("index ", new_linecont_index)
	#if new_linecont_index > 1: # 3rd and up
		#var prev_name = get_linecontainer_at_index(new_linecont_index - 1).get_character()
		#
		#if prev_name == first_two_names[0]:
			#print("yes 0")
			#new_linecont.set_character_by_name(first_two_names[1])
		#elif prev_name == first_two_names[1]:
			#print("yes 0")
			#new_linecont.set_character_by_name(first_two_names[0])
			#
