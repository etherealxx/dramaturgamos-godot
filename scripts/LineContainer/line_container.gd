extends HBoxContainer

signal plus_pressed

@onready var parent = get_parent()
@onready var plus = $PlusButton
@onready var xbtn = $XButton
@onready var up = $UpButton
@onready var down = $DownButton
#@onready var character = $CharacterSelect
@onready var dialogtext = $DialogTextbox
@onready var charaoption = $CharacterSelect

var islinecontainer = true
var isready := false
var character_names : Array[String]
#func _init():
	#plus.pressed.connect(_on_plus_pressed)
	#xbtn.pressed.connect(_on_xbtn_pressed)
	
func _ready():
	plus.pressed.connect(_on_plus_pressed)
	xbtn.pressed.connect(_on_xbtn_pressed)
	up.pressed.connect(_on_up_pressed)
	down.pressed.connect(_on_down_pressed)
	charaoption.item_selected.connect(_on_chara_change)
	isready = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !isready:
		_ready()

func set_character_names(_character_names):
	character_names = _character_names

func set_dialog(text):
	dialogtext.set_text(text)

func update_character(namelist : Array[String] = character_names):
	var option_itemlist : Array[String] = []
	var addedname_list : Array[String] = []
	for i in charaoption.get_item_count():
		var chara_name = charaoption.get_item_text(i)
		if not option_itemlist.has(chara_name):
			option_itemlist.append(chara_name)
	for new_name in namelist:
		if new_name not in option_itemlist:
			addedname_list.append(new_name)
	for new_name in addedname_list:
		charaoption.add_item(new_name)
	character_names = namelist
	
func check_index():
	for iternumber : int in parent.get_child_count():
		if parent.get_child(iternumber) == self:
			return iternumber

func check_linecontainer_index(node = self):
	var iter_linecontainer = 0
	for iternumber : int in parent.get_child_count():
		var child = parent.get_child(iternumber)
		if "islinecontainer" in child:
			if child == node:
				return iter_linecontainer
			else:
				iter_linecontainer += 1

func get_linecontainer_at_index(index : int):
	var iter_linecontainer = 0
	for iternumber : int in parent.get_child_count():
		var child = parent.get_child(iternumber)
		if "islinecontainer" in child:
			if iter_linecontainer == index:
				return child
			else:
				iter_linecontainer += 1
	return null
			
func get_character():
	var chara_name = charaoption.get_item_text(charaoption.get_selected())
	if chara_name:
		return chara_name

func set_character_by_name(chara_name : String):
	var select_index = 0
	for chara_index in charaoption.get_item_count():
		if charaoption.get_item_text(chara_index) == chara_name:
			charaoption.selected = chara_index
			break
	charaoption.add_item(chara_name)
	update_character()
	#charaoption.set_item_text(chara)
	
func get_dialog():
	return dialogtext.get_text()

func update_all_name_list(namelist = character_names):
	for iternumber : int in parent.get_child_count():
		var child = parent.get_child(iternumber)
		if "islinecontainer" in child:
			update_character(namelist)

func check_first_two():
	var first = get_linecontainer_at_index(0)
	if first:
		parent.fill_first_two_names(0, first.get_character())
		print("First: ", first.get_character())
		
	var second = get_linecontainer_at_index(1)
	if second:
		parent.fill_first_two_names(1, second.get_character())
		print("Second: ", second.get_character())
	
func _on_plus_pressed():
	update_all_name_list()
	var new_linecont = load("res://scenes/line_container.tscn").instantiate()
	self.add_sibling(new_linecont)
	#print(self.get_script())
	#print(new_linecont.get_script())
	new_linecont.set_script(self.get_script())
	new_linecont.set_character_names(character_names)
	new_linecont.update_character()
	check_first_two()
	
	var new_linecont_index : int = new_linecont.check_linecontainer_index(new_linecont)
	print("index ", new_linecont_index)
	if new_linecont_index > 1: # 3rd and up
		var prev_name = get_linecontainer_at_index(new_linecont_index - 1).get_character()
		
		if prev_name == parent.first_two_names[0]:
			print("yes 0")
			new_linecont.set_character_by_name(parent.first_two_names[1])
		elif prev_name == parent.first_two_names[1]:
			print("yes 0")
			new_linecont.set_character_by_name(parent.first_two_names[0])
			
	#if check_linecontainer_index() in [0, 1]:
		#insert
	
	#var new_linecont_index = new_linecont.check_linecontainer_index()
	#if new_linecont_index in [0, 1]:
		#new_linecont.set_character_by_name(parent.first_two_names[new_linecont_index])
	#print(new_linecont.get_script())
	#plus_pressed.emit()

func _on_xbtn_pressed():
	var line_container_count = 0
	for iternumber : int in parent.get_child_count():
		if "islinecontainer" in parent.get_child(iternumber):
			line_container_count += 1
	if line_container_count > 1:
		queue_free()

func get_middle_pos(node : Control):
	var gpos = up.global_position
	var middlepos
	if node == up:
		middlepos = Vector2(gpos.x + up.size.x / 2, gpos.y - up.size.y / 2)
	elif node == down:
		middlepos = Vector2(gpos.x + up.size.x * 1.5 , gpos.y + up.size.y * 1.5)
	return middlepos
	
func _on_up_pressed():
	if check_index() > 1:
		if "islinecontainer" in parent.get_child(check_index() - 1):
			parent.move_child(self, check_index() - 1)
			Input.warp_mouse(get_middle_pos(up))
	check_first_two()

func _on_down_pressed():
	if check_index() < parent.get_child_count():
		if "islinecontainer" in parent.get_child(check_index() + 1):
			parent.move_child(self, check_index() + 1)
			Input.warp_mouse(get_middle_pos(down))
	check_first_two()

func _on_chara_change(index):
	check_first_two()
