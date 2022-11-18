extends Node2D

#enemy preloads
var jackbat := preload('res://objects/jackbat.tscn')
var reaper := preload('res://objects/reaper.tscn')
var slasher := preload('res://objects/slasher.tscn')
var danger := preload('res://objects/danger.tscn')
var tutorial := preload('res://objects/tutorialslasher.tscn')
var boss := preload('res://objects/boss.tscn')

var current_enemies: int = 0
var wait_time: float = 0.0

var health_size: int = 50#48
var bullet_size: int = 30


#below is very messy the first [ is the dic, 
#the next is the encounter number or spawn, 
#the third is the individual spawns in side the individual encounter

#this is the actual spawn the first vector2 is the position of the spawn, the second is the object spawned,
#last is the animation that the sapwn will play first... the delay animations were created for a quick way to 
#stagger incoming enmies
#[Vector2(200,325),slasher,"spawnjump"]

var encounter_dictionary: Array = [
#tutorial  0
[[Vector2(200,325),tutorial,"spawn"]],
#real  1
[[Vector2(200,325),slasher,"spawn"]],
#reapers left side 2
[[Vector2(200,100),reaper,"spawndelay2"],[Vector2(300,350),reaper,"spawn"],[Vector2(350,100),reaper,"spawndelay2"]],
#three
[[Vector2(125,325),slasher,"spawndelay2"],[Vector2(275,325),slasher,"spawn"],[Vector2(450,325),slasher,"spawndelay5"]],
#[[Vector2(200,100),slasher,"spawnjump"]], #4
[[Vector2(125,325),slasher,"spawndelay2"],[Vector2(275,325),slasher,"spawn"],[Vector2(400,325),slasher,"spawndelay5"],
[Vector2(475,325),slasher,"spawndelay7"],[Vector2(350,325),slasher,"spawndelay10"]],
#5
[[Vector2(200,100),reaper,"spawndelay2"],[Vector2(300,200),reaper,"spawn"],[Vector2(350,100),reaper,"spawndelay2"],
[Vector2(225,325),slasher,"spawn"],[Vector2(300,325),slasher,"spawndelay5"],[Vector2(475,325),slasher,"spawndelay7"]],
#6 placeholder for next level event
[[Vector2(270,125),danger,null]],
#7 miniboss
[[Vector2(500,125),jackbat,null]],
#8 green man boss
[[Vector2(250,145),boss,null]]

]

func _ready():
	_bullets_change(6)
	_health_change(5)


func _physics_process(delta):
	if $thewalk.is_playing() == false:
		if get_tree().get_nodes_in_group("current_enemies").size()<= 0:
			#if theres more wait time add it here
			_level_UNpauser()
			
func _level_pauser():
	$thewalk.stop(false)
func _level_UNpauser():
	$thewalk.play("level 1")
func _enemies_cleared():#signal called might do a check here for # of enemies
	_level_UNpauser()


func _one_less_enemy():
	current_enemies -= 1
	
func _encounter(encounter_num:int):
	_level_pauser()
	var count = encounter_dictionary[encounter_num].size()
	for i in count:
		var enemy = encounter_dictionary[encounter_num][i-1][1].instance()
		enemy.connect("dies",self,"_one_less_enemy")
		enemy.connect("hits",self,"_play_the_red")# this is the damage
		if encounter_dictionary[encounter_num][i-1][2] != null:
			enemy.get_node("Sprite/AnimationPlayer").set_autoplay(encounter_dictionary[encounter_num][i-1][2])
		#enemy.set_position($Camera2D.get_position()+encounter_dictionary[encounter_num][i-1][0])
		enemy.set_position(encounter_dictionary[encounter_num][i-1][0])
		enemy.add_to_group("current_enemies")
		$Camera2D/YSort.add_child(enemy)
		
	#add to current enemies
	#additional time before calling UNpauser
func _play_the_red():
	if Manager.current_health > 0:
		Manager.current_health -= 1
		if Manager.current_health <= 0:
			$death/Label.rect_position += $Camera2D.position
			$thered.stop()
			$thered.play("theEnd")
			Manager.available_bullets = 0
			_bullets_change(Manager.available_bullets)
		else:
			_health_change(Manager.current_health)
			$thered.stop()
			$thered.play("thered")

func _on_bullett_catcher_pressed():
	if Manager.available_bullets > 0:
		Soundplayer.play_sound(Soundplayer.SHOOT)
		Manager.available_bullets -= 1
		_bullets_change(Manager.available_bullets)
	else:
		Soundplayer.play_sound(Soundplayer.EMPTY)
	
func _on_reload_pressed():
	Soundplayer.play_sound(Soundplayer.RELOAD)
	#might add an animation or a press and hold function...
	Manager.available_bullets = 7#cause the screen catches the first one
	_bullets_change(Manager.available_bullets)
	randomize()
	var randX: float = rand_range(260,435)
	$Camera2D/hud/reload.set_position(Vector2(randX,-360))

#https://www.youtube.com/watch?v=Mo9ZbHyl9TY 
func _health_change(player_hearts:int) ->void:
	$Camera2D/health.rect_size.x = player_hearts*health_size

func _bullets_change(current_bullets:int) ->void:
	$Camera2D/bullets.rect_size.y = current_bullets*bullet_size


func _on_RESTART_pressed():
	print("ok")
	get_tree().change_scene("res://levels/level_1.tscn")
	Manager.available_bullets = 7#cause the screen catches the first one
	_bullets_change(Manager.available_bullets)
