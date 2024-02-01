extends HBoxContainer

@onready var titletextbox = $TitleText

func get_title():
	return titletextbox.get_text()

func set_title(title):
	titletextbox.set_text(title)
