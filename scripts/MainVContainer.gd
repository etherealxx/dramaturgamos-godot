extends VBoxContainer

@onready var charlist = $CharacterScroll/CharacterList
# Called when the node enters the scene tree for the first time.
func _ready():
	charlist.update_all_name_list()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
