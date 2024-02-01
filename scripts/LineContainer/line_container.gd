extends HBoxContainer

signal plus_pressed

@onready var parent = get_parent()
@onready var plus = $PlusButton
@onready var xbtn = $XButton
@onready var up = $UpButton
@onready var down = $DownButton
@onready var character = $CharacterSelect
@onready var dialogtext = $DialogTextbox
@onready var charaoption = $CharacterSelect

var islinecontainer = true
var isready := false

#func _init():
	#plus.pressed.connect(_on_plus_pressed)
	#xbtn.pressed.connect(_on_xbtn_pressed)
	
func _ready():
	plus.pressed.connect(_on_plus_pressed)
	xbtn.pressed.connect(_on_xbtn_pressed)
	up.pressed.connect(_on_up_pressed)
	down.pressed.connect(_on_down_pressed)
	isready = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !isready:
		_ready()

func update_character(namelist : Array[String]):
	var option_itemlist : Array[String]
	var addedname_list : Array[String]
	for i in charaoption.get_item_count():
		option_itemlist.append(charaoption.get_item_text(i))
	for name in namelist:
		if name not in option_itemlist:
			addedname_list.append(name)
	for name in addedname_list:
		charaoption.add_item(name)

func check_index():
	for iternumber : int in parent.get_child_count():
		if parent.get_child(iternumber) == self:
			return iternumber
			
func get_character():
	return character.get_item_text(character.selected)
	
func get_dialog():
	return dialogtext.get_text()
	
func _on_plus_pressed():
	var new_linecont = load("res://scenes/line_container.tscn").instantiate()
	self.add_sibling(new_linecont)
	#print(self.get_script())
	#print(new_linecont.get_script())
	new_linecont.set_script(self.get_script())
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

func _on_down_pressed():
	if check_index() < parent.get_child_count():
		if "islinecontainer" in parent.get_child(check_index() + 1):
			parent.move_child(self, check_index() + 1)
			Input.warp_mouse(get_middle_pos(down))
