extends Node2D

export var target: int = 0 # for attacking the actual player or for attacking an innocent

var ghost := preload('res://objects/reaper.tscn')
var bat := preload('res://objects/jackbat.tscn')

var hp : int = 6
var wound : int = 5
var dir := Vector2(1,-1)
export var speed: float = 100

signal dies
signal hits

var moveto := Vector2()

func _ready():
	randomize()
	#var proxscale = clamp(get_position().y / 100,1,3)
	#set_scale(Vector2(proxscale,proxscale)+Vector2(.25,.25))


func _physics_process(delta):
	var proxscaleCharge = clamp(get_position().y /290,1.5,2)#.5,1 for the rescaled 33 sprite
	set_scale(Vector2(proxscaleCharge,proxscaleCharge))
	if $Sprite/AnimationPlayer.get_current_animation() == "charge":
		move_local_y(2.4)
		#move on the Y
	if $Sprite/AnimationPlayer.get_current_animation() == "move":
		#move_local_x((moveto.x-position.x)/30)
		#move_local_y(145-position.y/30)
		#print(position.move_toward(moveto,.5))
		position = position.move_toward(moveto,10)
		




func _on_headshot_pressed():
	if !Manager.available_bullets > 0:
		return
	else:
		#add in the wound system here
		hp -= 1
		if hp <= 0:
			$Sprite/AnimationPlayer.play("hurt")
			Soundplayer.play_sound(Soundplayer.BOSSHURT)
			wound -= 1
		if wound <= 0:
			$Sprite/AnimationPlayer.play("die")
		#if hp > 0:
			#$Sprite/AnimationPlayer.play("bat")
		#else:
			#if $Sprite/AnimationPlayer.get_current_animation() != "death":
				#$Sprite/AnimationPlayer.play("death")

func _hit():#do i need this?
	Soundplayer.play_sound(Soundplayer.SLASHERHIT)
	emit_signal("hits")
	#print(str(target)+ " got hit")

func _die():
	emit_signal("dies")
	queue_free()

##func for howl and roar to summon seperately
func _spawn():
	var spawn = 1+randi()%3
	for i in spawn:
		var enemy = ghost.instance()
		#enemy.connect("dies",self,"_one_less_enemy")
		###########FUCKINSTUPID
		enemy.connect("hits",get_parent().get_parent().get_parent(),"_play_the_red")# this is the damage
		#if encounter_dictionary[encounter_num][i-1][2] != null:
		enemy.get_node("Sprite/AnimationPlayer").set_autoplay("spawn")
		#enemy.set_position($Camera2D.get_position()+encounter_dictionary[encounter_num][i-1][0])
		enemy.set_position(Vector2(75+(i*150)+rand_range(25,100),rand_range(100,350)))
		#enemy.add_to_group("current_enemies")
		get_parent().add_child(enemy)

func _summon():
	if get_tree().get_nodes_in_group("unique").size() <= 0:
		var enemy = bat.instance()
		enemy.add_to_group("current_enemies")
	#enemy.connect("hits",get_parent().get_parent().get_parent(),"_play_the_red")# this is the damage
	#if encounter_dictionary[encounter_num][i-1][2] != null:
	#enemy.get_node("Sprite/AnimationPlayer").set_autoplay("spawn")
	#enemy.set_position($Camera2D.get_position()+encounter_dictionary[encounter_num][i-1][0])
		enemy.set_position(position)
	#enemy.add_to_group("current_enemies")
		get_parent().add_child(enemy)


func _on_AnimationPlayer_animation_finished(anim_name):
	randomize()
	var next_action = randi() % 5
	if anim_name == "spawn":
		if next_action == 0:
			$Sprite/AnimationPlayer.play("move_start")
		elif next_action == 1:
			$Sprite/AnimationPlayer.play("move_start")
		elif next_action == 2:
			$Sprite/AnimationPlayer.play("charge")
		elif next_action == 3:
			$Sprite/AnimationPlayer.play("roar")
		elif next_action == 4:
			$Sprite/AnimationPlayer.play("howl")
	elif anim_name == "move_end":
		if next_action == 0:
			$Sprite/AnimationPlayer.play("roar")
		elif next_action == 1:
			$Sprite/AnimationPlayer.play("move_start")
		elif next_action == 2:
			$Sprite/AnimationPlayer.play("charge")
		elif next_action == 3:
			$Sprite/AnimationPlayer.play("roar")
		elif next_action == 4:
			$Sprite/AnimationPlayer.play("howl")
	elif anim_name == "attack":
		$Sprite/AnimationPlayer.play("move_start")
	#elif anim_name == "charge":
		#pass
	elif anim_name == "howl":
		if next_action == 0:
			$Sprite/AnimationPlayer.play("idle")
		elif next_action == 1:
			$Sprite/AnimationPlayer.play("move_start")
		elif next_action == 2:
			$Sprite/AnimationPlayer.play("charge")
		elif next_action == 3:
			$Sprite/AnimationPlayer.play("roar")
		elif next_action == 4:
			$Sprite/AnimationPlayer.play("move_start")
	elif anim_name == "roar":
		if next_action == 0:
			$Sprite/AnimationPlayer.play("idle")
		elif next_action == 1:
			$Sprite/AnimationPlayer.play("move_start")
		elif next_action == 2:
			$Sprite/AnimationPlayer.play("charge")
		elif next_action == 3:
			$Sprite/AnimationPlayer.play("move_start")
		elif next_action == 4:
			$Sprite/AnimationPlayer.play("howl")
	elif anim_name == "idle":
		if next_action == 0:
			$Sprite/AnimationPlayer.play("move_start")
		elif next_action == 1:
			$Sprite/AnimationPlayer.play("move_start")
		elif next_action == 2:
			$Sprite/AnimationPlayer.play("charge")
		elif next_action == 3:
			$Sprite/AnimationPlayer.play("roar")
		elif next_action == 4:
			$Sprite/AnimationPlayer.play("howl")
	elif anim_name == "hurt":
		$Sprite/AnimationPlayer.play("move_start")
		hp = 6



func _on_AnimationPlayer_animation_started(anim_name):
	#print($Sprite/AnimationPlayer.get_current_animation())
	if anim_name == "move":
		randomize()
		var newx = rand_range(50,420)
		moveto = Vector2(newx,145)
		#create a spot to jump to the Y has to be consistant
		
func _play_sound(sound):
	#fuckin DUMB way
	if sound == 0:
		Soundplayer.play_sound(Soundplayer.BOSSHOWL)
	elif sound == 1:
		Soundplayer.play_sound(Soundplayer.BOSSHURT)
	if sound == 2:
		Soundplayer.play_sound(Soundplayer.BOSSMOVE)
	elif sound == 3:
		Soundplayer.play_sound(Soundplayer.BOSSROAR)
		
		
