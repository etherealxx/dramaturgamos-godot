extends HBoxContainer

@onready var parent = get_parent()
@onready var infotext = parent.get_node("InfoText")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func printx(variant):
	infotext.set_text(str(variant))
	print(variant)
	
func _on_export_textbtn_pressed():
	var dialogue_text : String
	for iternumber : int in parent.get_child_count():
		var child = parent.get_child(iternumber)
		if "islinecontainer" in child:
			if child.get_dialog() != "":
				var sentence_text : String = child.get_character() + " : " + child.get_dialog()
				dialogue_text += sentence_text + "\n"
	
	var file_path : String = "user://dramaturgamos_output.txt"
	var file: FileAccess = FileAccess.open(file_path, FileAccess.WRITE)

	if file != null:
		file.store_string(dialogue_text)

		file.close()

		printx("Formatted text exported successfully")
	else:
		printx("Error opening the file for writing")

func _on_export_varbtn_pressed():
	var dialogue_array : Array[Array]
	for iternumber : int in parent.get_child_count():
		var child = parent.get_child(iternumber)
		if "islinecontainer" in child:
			if child.get_dialog() != "":
				var sentence_array : Array = [child.get_character(), child.get_dialog()]
				dialogue_array.append(sentence_array)
	
	var file_path : String = "user://dramaturgamos_output.txt"
	var file: FileAccess = FileAccess.open(file_path, FileAccess.WRITE)

	if file != null:
		file.store_var(dialogue_array)

		file.close()

		printx("Array of Array exported to text file successfully")
	else:
		printx("Error opening the file for writing")


func _on_export_jsonbtn_pressed():
	var title = "title hello"
	var dialogue_array : Array[Dictionary]
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
	
	var file_path : String = "user://dramaturgamos_output.json"
	var file: FileAccess = FileAccess.open(file_path, FileAccess.WRITE)

	if file != null:
		file.store_string(JSON.stringify(json_main, "\t"))
		file.close()

		printx("Formatted JSON exported to text file successfully")
	else:
		printx("Error opening the file for writing")
