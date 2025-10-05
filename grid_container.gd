extends GridContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var ButtonPrefab = preload("res://buttonPrefab.tscn")

var width=10

var array:PackedByteArray

func popButton(id):
	var button=ButtonPrefab.instantiate()
	button.id=id
	add_child(button)

func getTile(x, y) -> int:
	if x<0 or x>width-1 or y<0 or y>width-1:
		return -1
	return array[x+y*width]
	
func getTileVec(pos:Vector2i) -> int:
	return getTile(pos.x, pos.y)
		
func isMine(x, y):
	if getTile(x, y) == 9:
		return 1
	return 0
		
func checkTile(pos:Vector2i):
	var z := getTileVec(pos)
	
	if z == -1:
		return
	
	var button = get_child(pos.x+pos.y*width)
	
	if button.disabled:
		return
	
	button.see(z)
	
	if z == 0:
		var posArray:PackedVector2Array = [
			Vector2(1, 0),
			Vector2(1, 1),
			Vector2(1, -1),
			Vector2(-1, 0),
			Vector2(-1, 1),
			Vector2(-1, -1),
			Vector2(0, 1),
			Vector2(0, -1)
		]
		
		for i_pos in posArray:
			checkTile(Vector2i(pos.x + i_pos.x, pos.y + i_pos.y))

func checkTileFromId(id:int):
	var x = id%width
	var y = id/width
	
	checkTile(Vector2i(x, y))

func checkTileAndArround(pos:Vector2i):
	var button = get_child(pos.x+pos.y*width)
	
	if button.disabled:
		return
	
	button.see(getTileVec(pos))
	
	var posArray:PackedVector2Array = [
		Vector2(1, 0),
		Vector2(1, 1),
		Vector2(1, -1),
		Vector2(-1, 0),
		Vector2(-1, 1),
		Vector2(-1, -1),
		Vector2(0, 1),
		Vector2(0, -1)
	]
	
	for i_pos in posArray:
		var next_pos = Vector2i(pos.x + i_pos.x, pos.y + i_pos.y)
		
		var z = getTileVec(next_pos)
		
		match(z):
			-1: continue
			0: checkTileAndArround(next_pos)
			_: get_child(next_pos.x+next_pos.y*width).see(z)

# Called when the node enters the scene tree for the first time.
func _ready():
	columns=width
	
	array = PackedByteArray()
	
	var ww=width*width
	
	var ww4=width*width/4
	
	for i in range(ww):
		popButton(i)
		
		if i < 10:
			array.append(9)
		else:
			array.append(0)
	
	randomize()
	
	#melange
	for i in range(ww-1, 1, -1):
		var j = randi_range(0, i)
		var k = array[i]
		array[i] = array[j]
		array[j] = k
	
	for i in range(ww):
		if array[i] == 9:
			continue
		else:
			var x = i%width
			var y = i/width
			
			array[i] = isMine(x, y+1) + isMine(x, y-1) + isMine(x+1,y) + isMine(x+1, y+1) + isMine(x+1, y-1) + isMine(x-1, y) + isMine(x-1, y+1) + isMine(x-1, y-1)
	
	var find_first_pos = false;
	while(not find_first_pos):
		var first_pos = Vector2(randi_range(1, width-2), randi_range(1, width-2))
		
		if (not isMine(first_pos.x, first_pos.y)):
			find_first_pos = true
			checkTileAndArround(first_pos)
