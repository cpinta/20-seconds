class_name TilesPlatform
extends TileMapLayer

var color: Color

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _tile_data_runtime_update(coord, tile_data):
	tile_data.modulate = color
	
#Warning: Make sure this function only return true when needed. 
#Any tile processed at runtime without a need for it will imply a significant performance penalty.
func _use_tile_data_runtime_update(coord):
	return true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_color(color: Color):
	self.color = color
	notify_runtime_tile_data_update()
