extends Node

const SHOOT = preload("res://assets/sound/pistol.wav")
const RELOAD = preload("res://assets/sound/gunreload1.wav")
const EMPTY = preload("res://assets/sound/outofammo.wav")
const REAPER = preload("res://assets/sound/short wind sound.wav")
const SLASHERHIT = preload("res://assets/sound/slasherhit.wav")

const BOSSHOWL = preload("res://assets/sound/bossHowl.wav")
const BOSSHURT = preload("res://assets/sound/bossHurt.wav")
const BOSSMOVE = preload("res://assets/sound/bossMove.wav")
const BOSSROAR = preload("res://assets/sound/bossRoar.wav")




onready var audioPlayers = $audioplayers
#audioStreamPlayer: = $audioplayers/AudioStreamPlayer

func _ready():
	print(typeof(BOSSHOWL))

func play_sound(sound):
	for audioStreamPlayer in audioPlayers.get_children():
		if not audioStreamPlayer.playing:
			audioStreamPlayer.stream = sound
			audioStreamPlayer.play()
			break

