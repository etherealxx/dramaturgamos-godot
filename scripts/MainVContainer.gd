extends VBoxContainer

var first_two_names := ["", ""]

@onready var charlist = $CharacterScroll/CharacterList

func _ready():
	charlist.update_all_name_list()

func fill_first_two_names(index, chara):
	first_two_names.insert(index, chara)
