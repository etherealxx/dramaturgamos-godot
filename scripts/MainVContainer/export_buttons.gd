extends HBoxContainer

@onready var parent = get_parent()
@onready var infotext = parent.get_node("InfoText")
@onready var filedialog : FileDialog = get_tree().current_scene.get_node("FileDialog")
@onready var alert : AcceptDialog = get_tree().current_scene.get_node("AlertPopup")

var waitfor : String

func _ready():
	filedialog.file_selected.connect(_on_file_chosen)
	
func printx(variant):
	infotext.set_text(str(variant))
	print(variant)

func check_filled_title(filter : PackedStringArray, extension : String):
	var savetitle = parent.get_node("TitleLine").get_title()
	if savetitle:
		print(parent.get_node("TitleLine").get_title())
		filedialog.set_filters(filter)
		filedialog.set_file_mode(4) # save
		filedialog.set_ok_button_text("Save")
		filedialog.set_current_file("%s.%s" % [savetitle, extension])
		filedialog.show()

	else:
		alert.show()

func _on_file_chosen(path):
	if waitfor == "jsonexport":
		var title = parent.get_node("TitleLine").get_title()
	
		var dialogue_array : Array[Dictionary] = []
		var linecont_amount := 0
		for iternumber : int in parent.get_child_count():
			var child = parent.get_child(iternumber)
			if "islinecontainer" in child:
				if child.get_dialog() != "":
					linecont_amount += 1
					var sentence_dict : Dictionary = \
					{"order": linecont_amount, \
					"character": child.get_character(), \
					"dialog": child.get_dialog()}
					
					dialogue_array.append(sentence_dict)
					
		var json_cutscene = {"Title": title, "Sentences": dialogue_array}
		var json_main = {"Cutscene": json_cutscene}
		
		var file_path : String = path
		var file: FileAccess = FileAccess.open(file_path, FileAccess.WRITE)

		if file != null:
			file.store_string(JSON.stringify(json_main, "\t"))
			file.close()

			printx("Formatted JSON exported to JSON file successfully.\nLocated in %s" % path)
		else:
			printx("Error opening the file for writing")
		
		waitfor = String()
	elif waitfor == "txtexport":
		var title = parent.get_node("TitleLine").get_title()
		
		var dialogue_text : String = ""
		for iternumber : int in parent.get_child_count():
			var child = parent.get_child(iternumber)
			if "islinecontainer" in child:
				if child.get_dialog() != "":
					var sentence_text : String = child.get_character() + " : " + child.get_dialog()
					dialogue_text += sentence_text + "\n"
		
		var file_path : String = path
		var file: FileAccess = FileAccess.open(file_path, FileAccess.WRITE)

		if file != null:
			file.store_string(dialogue_text)

			file.close()

			printx("Formatted text exported successfully\nLocated in %s" % path)
		else:
			printx("Error opening the file for writing")
		waitfor = String()
func _on_export_textbtn_pressed():
	waitfor = "txtexport"
	var filter = PackedStringArray(["*.txt ; Text Files"])
	check_filled_title(filter, "txt")

func _on_export_jsonbtn_pressed():
	waitfor = "jsonexport"
	var filter = PackedStringArray(["*.json ; JSON Files"])
	check_filled_title(filter, "json")
