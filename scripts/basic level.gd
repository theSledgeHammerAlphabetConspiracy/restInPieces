extends VideoPlayer


export var stoppoints: Array = [9.0, 22.107, 25.307, 35.64, 45.27]

#9.274 22.107 25.307 35.64 46.27=boss

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	$Label.set_text(str(stream_position))
	#print(stream_position)
	if stoppoints.size() > 0:
		if stream_position >= stoppoints[0]:
			_level_pauser(true)
			
	
		
		
func _level_pauser(onoff:bool):
	if onoff == true:
		print("h")
		get_node("AnimationPlayer").play("sway")
	if onoff == false:
		get_node("AnimationPlayer").play("still")
	#if onoff == true:
	set_paused(onoff)
		
func _enemies_cleared():#signal called might do a check here for # of enemies
	stoppoints.remove(0)
	_level_pauser(false)
	print(stoppoints)

func _on_TouchScreenButton_pressed():
	_enemies_cleared()
	#print(stream_position)


func _on_VideoPlayer_finished():
	print(" FINSIHED " + str(stream_position))
