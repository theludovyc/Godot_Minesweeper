extends Node

@onready var map = %Map
@onready var flagLabel = %FoundMineLabel
@onready var confirm_dialog:ConfirmationDialog = %ConfirmationDialog

const mapWidth = 10
const maxMine = 15

var flag_number := 0

func _ready() -> void:
	%MaxMineLabel.text = str(maxMine)
	
	map.createMap(mapWidth, maxMine)
	
	confirm_dialog.confirmed.connect(_on_confirm_dialog_ok_pressed)
	
	var confirm_dialog_label:Label = confirm_dialog.get_label()
	confirm_dialog_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	confirm_dialog_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

func _on_map_all_mines_flaged() -> void:
	if flag_number > maxMine:
		return

	confirm_dialog.dialog_text = "Win !\nRetry ?"
	confirm_dialog.show()

func _on_map_mine_triggered() -> void:
	confirm_dialog.dialog_text = "Game over !\nRetry ?"
	confirm_dialog.show()

func _on_map_flag_number_updated(i: Variant) -> void:
	flag_number = i
	flagLabel.text = str(i)

func _on_confirm_dialog_ok_pressed():
	get_tree().reload_current_scene()
