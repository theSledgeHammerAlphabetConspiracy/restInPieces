extends Node2D

export var target: int = 0 # for attacking the actual player or for attacking an innocent

#both of these are connected when the enemy is spawned in the level_controller script under the _encounter function
signal dies
signal hits

func _ready():
	var proxscale = clamp(get_position().y / 100,1,3)
	set_scale(Vector2(proxscale,proxscale)+Vector2(.25,.25))



func _on_headshot_pressed():
	if !Manager.available_bullets > 0:
		return
	else:
		if $Sprite/AnimationPlayer.get_current_animation() != "death":
			$Sprite/AnimationPlayer.play("death")

func _hit():
	Soundplayer.play_sound(Soundplayer.REAPER)
	emit_signal("hits")


func _die():
	emit_signal("dies")
	queue_free()
