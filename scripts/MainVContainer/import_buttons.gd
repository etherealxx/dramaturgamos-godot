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
				parent.update_charalist(new_names)
				parent.charalistline_updateall()
			
			var last_linecont : HBoxContainer
			for sentence_dict : Dictionary in json_cutscene_dict["Sentences"]:
				last_linecont = parent.append_line_container(sentence_dict["character"], 
															sentence_dict["dialog"],)
			last_linecont.update_all_name_list(parent.get_charalist())
			
			
			#for value in json_dict.values():
				#print(value)
			
			#print(json_var)
			file.close()

			printx("Formatted JSON imported successfully.")
		else:
			printx("Error opening the file for reading")
		
		waitfor = String()
		
	elif waitfor == "txtimport":
		var file_path : String = path
		var file: FileAccess = FileAccess.open(file_path, FileAccess.READ)
		
		var title = file_path.get_file().get_slice("." + file_path.get_extension(), 0)
		parent.get_node("TitleLine").set_title(title)
		
		if file != null:
			var txt_string : String = file.get_as_text()
			var string_lines = txt_string.split("\n", false)

			var new_names : Array[String] = []
			for line in string_lines:
				var chara_name = line.get_slice(" : ", 0)
				if not new_names.has(chara_name):
					new_names.append(chara_name)
					
			if !new_names.is_empty():
				parent.update_charalist(new_names)
				parent.charalistline_updateall()
			
			var last_linecont : HBoxContainer
			for line in string_lines:
				var chara_name = line.get_slice(" : ", 0)
				var chara_dialog = line.get_slice(" : ", 1)
				last_linecont = parent.append_line_container(chara_name, 
															chara_dialog)
			last_linecont.update_all_name_list(parent.get_charalist())
			
			
			#for value in json_dict.values():
				#print(value)
			
			#print(json_var)
			file.close()

			printx("Formatted Txt imported successfully.")
		else:
			printx("Error opening the file for reading")
		
		waitfor = String()

func _on_import_textbtn_pressed():
	waitfor = "txtimport"
	var filter = PackedStringArray(["*.txt ; Text Files"])
	filedialog_popup("open", filter, "txt")

func _on_import_jsonbtn_pressed():
	waitfor = "jsonimport"
	var filter = PackedStringArray(["*.json ; JSON Files"])
	filedialog_popup("open", filter, "json")
