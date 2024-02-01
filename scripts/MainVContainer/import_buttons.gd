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

func filedialog_popup(mode := "", filter = PackedStringArray(), extension := "", filetitle := ""):
	if filter:
		filedialog.set_filters(filter)
	if mode == "save":
		var savetitle = parent.get_node("TitleLine").get_title()
		filedialog.set_file_mode(4) # save
		filedialog.set_ok_button_text("Save")
		filedialog.set_current_file("%s.%s" % [savetitle, extension])
	elif mode == "open":
		filedialog.set_file_mode(0) # open one file
		filedialog.set_ok_button_text("Import")
		
	filedialog.show()

func check_filled_title(filter : PackedStringArray, extension : String):
	var savetitle = parent.get_node("TitleLine").get_title()
	if savetitle:
		filedialog_popup("save", filter, extension)
	else:
		alert.show()

func _on_file_chosen(path):
	if waitfor == "jsonimport":
		var file_path : String = path
		var file: FileAccess = FileAccess.open(file_path, FileAccess.READ)

		if file != null:
			var json_string = file.get_as_text()
			var json_cutscene_dict : Dictionary = JSON.parse_string(json_string).get("Cutscene")
			parent.get_node("TitleLine").set_title(json_cutscene_dict["Title"])

			var new_names : Array[String] = []
			for sentence_dict : Dictionary in json_cutscene_dict["Sentences"]:
				if not new_names.has(sentence_dict["character"]):
					new_names.append(sentence_dict["character"])
					
			if !new_names.is_empty():
				$"../CharacterScroll/CharacterList".update_all_name_list(new_names)
			
			for sentence_dict : Dictionary in json_cutscene_dict["Sentences"]:
				parent.append_line_container(	sentence_dict["character"], 
												sentence_dict["dialog"],)

			#for value in json_dict.values():
				#print(value)
			
			#print(json_var)
			file.close()

			printx("Formatted JSON imported successfully.")
		else:
			printx("Error opening the file for reading")
		
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

func _on_import_textbtn_pressed():
	waitfor = "txtimport"
	var filter = PackedStringArray(["*.txt ; Text Files"])
	filedialog_popup("open", filter, "txt")

func _on_import_jsonbtn_pressed():
	waitfor = "jsonimport"
	var filter = PackedStringArray(["*.json ; JSON Files"])
	filedialog_popup("open", filter, "json")
