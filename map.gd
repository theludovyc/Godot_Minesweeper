extends GridContainer
class_name Map

signal all_mines_flaged
signal mine_triggered
signal flag_number_updated(i)

var m_width:int

var array:Array

var ButtonPrefab = preload("res://buttonPrefab.tscn")

var mines:Dictionary

var flag_number := 0

func popButton(id):
	var button=ButtonPrefab.instantiate()
	button.id=id
	add_child(button)

func getTile(x, y) -> int:
	if x<0 or x>m_width-1 or y<0 or y>m_width-1:
		return -1
	return array[x+y*m_width]
	
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
	
	var button = get_child(pos.x+pos.y*m_width)
	
	if button.disabled:
		return
	
	button.see(z)
	
	if z == 9:
		mine_triggered.emit()
	
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
	var x = id%m_width
	var y = id/m_width
	
	checkTile(Vector2i(x, y))

func checkTileAndArround(pos:Vector2i):
	var button = get_child(pos.x+pos.y*m_width)
	
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
			9: continue
			0: checkTileAndArround(next_pos)
			_: get_child(next_pos.x+next_pos.y*m_width).see(z)

func createMap(width:int, mine_number:int):
	m_width = width

	columns=m_width
	
	var ww=m_width*m_width
	
	array.resize(ww)
	array.fill(0)
	
	var ww4=m_width*m_width/4
	
	for i in range(mine_number):
		array[i] = 9
		
	array.shuffle()
	
	for i in range(ww):
		popButton(i)

		if array[i] == 9:
			mines[i] = false
			continue
		else:
			var x = i%m_width
			var y = i/m_width
			
			array[i] = isMine(x, y+1) + isMine(x, y-1) + isMine(x+1,y) + isMine(x+1, y+1) + isMine(x+1, y-1) + isMine(x-1, y) + isMine(x-1, y+1) + isMine(x-1, y-1)
	
	var find_first_pos = false;
	while(not find_first_pos):
		var first_pos = Vector2(randi_range(1, m_width-2), randi_range(1, m_width-2))
		
		if (not isMine(first_pos.x, first_pos.y)):
			find_first_pos = true
			checkTileAndArround(first_pos)

func flag_mine(id:int, enabled:bool):
	if enabled:
		flag_number += 1
	else:
		flag_number -= 1
		
	flag_number_updated.emit(flag_number)
	
	if mines.has(id):
		mines[id] = enabled
		
		var is_all_mines_flaged = true
		
		for key in mines:
			if mines[key] == false:
				is_all_mines_flaged = false
				return
				
		if is_all_mines_flaged:
			all_mines_flaged.emit()
