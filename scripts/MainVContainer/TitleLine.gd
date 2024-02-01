extends HBoxContainer

@onready var titletextbox = $TitleText

func get_title():
	return titletextbox.get_text()
