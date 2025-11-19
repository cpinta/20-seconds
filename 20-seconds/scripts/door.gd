class_name Door
extends Node2D

var area: Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	area = $area
	
	area.connect("body_entered", body_entered)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func body_entered(body: Node2D):
	if body is Player:
		#Game.next_level()
		#Game.play_sound(Game.acDoor)
		
		self.queue_free()
	pass
