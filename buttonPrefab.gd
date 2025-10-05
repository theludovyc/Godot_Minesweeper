extends Button

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var id:int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _gui_input(event):
	if event is InputEventMouseButton:
		if !disabled:
			if event.button_index == 1:
				var pr = get_parent()
				pr.checkTileFromId(id)
			if event.button_index == 2:
				text = str(9)
	
func see(i):
	if i == 9:
		self_modulate = Color.RED
	
	if i > 0:
		text = str(i)
		
	disabled=true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
