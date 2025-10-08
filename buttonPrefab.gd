extends Button

var id:int

var flag := false;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _gui_input(event:InputEvent):
		if !disabled:
			var pr = get_parent()
			if event.is_action_pressed("left_mouse"):
				pr.checkTileFromId(id)
				
				if flag:
					pr.flag_mine(id, false)
				return
				
			if event.is_action_pressed("right_mouse"):
				if flag:
					text = ""
					flag = false
					pr.flag_mine(id, flag)
					return
				else:
					text = str(9)
					flag = true
					pr.flag_mine(id, flag)
	
func see(i):
	if i == 9:
		self_modulate = Color.RED
	
	if i > 0:
		text = str(i)
		
	disabled=true



func _on_pressed() -> void:
	pass # Replace with function body.
