extends Node2D

export var target: int = 0 # for attacking the actual player or for attacking an innocent

var slasher := preload('res://objects/slasher.tscn')
var hp : int = 10
var dir := Vector2(1,-1)
export var speed: float = 0.0

signal dies
signal hits


func _ready():
	randomize()
	var proxscale = clamp(get_position().y / 100,1,3)
	#set_scale(Vector2(proxscale,proxscale)+Vector2(.25,.25))


func _physics_process(delta):
#	if $Sprite/AnimationPlayer.get_current_animation()=="bat":
#		print(position)
	#move 75 500
	if position.x < 76 or position.x > 499 or position.y < 75 or position.y > 250:
		_change_dir()
	move_local_x(speed*dir.x,false)
	move_local_y(speed*dir.y*.25,false)
#new
func _change_dir():
	if position.x <260:
		dir.x = 1
	elif position.x > 260:
		dir.x = -1
	if position.y < 100:
		dir.y = 1
	elif position.x > 100:
		dir.y = -1
		


func _on_headshot_pressed():
	if !Manager.available_bullets > 0:
		return
	else:
		hp -= 1
		if hp > 0:
			$Sprite/AnimationPlayer.play("bat")
		else:
			if $Sprite/AnimationPlayer.get_current_animation() != "death":
				$Sprite/AnimationPlayer.play("death")

func _hit():#do i need this?
	Soundplayer.play_sound(Soundplayer.REAPER)
	emit_signal("hits")
	#print(str(target)+ " got hit")

func _die():
	emit_signal("dies")
	queue_free()

#new
func _spawn():
	var spawn = 1+randi()%3
	for i in spawn:
		var enemy = slasher.instance()
		#enemy.connect("dies",self,"_one_less_enemy")
		###########FUCKINSTUPID
		enemy.connect("hits",get_parent().get_parent().get_parent(),"_play_the_red")# this is the damage
		#if encounter_dictionary[encounter_num][i-1][2] != null:
		enemy.get_node("Sprite/AnimationPlayer").set_autoplay("spawn")
		#enemy.set_position($Camera2D.get_position()+encounter_dictionary[encounter_num][i-1][0])
		enemy.set_position(Vector2(75+(i*150)+rand_range(25,100),325))
		#enemy.add_to_group("current_enemies")
		get_parent().add_child(enemy)
