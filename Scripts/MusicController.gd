extends Node

@onready var music_player = $AudioStreamPlayer
@onready var death_player = $DeathSFXPlayer
@onready var collect_player = $CollectSFXPlayer
@onready var jump_player = $JumpSFXPlayer
@onready var gravity_player = $GravitySFXPlayer
@onready var checkpoint_player = $CheckpointPlayer

@onready var collect_sounds = [preload("res://SFX/pickupCoin.wav"), preload("res://SFX/pickupCoin(1).wav"), preload("res://SFX/pickupCoin(2).wav")]


func play_death_sound():
	death_player.play()

func play_collect_sound():
	if !collect_player.playing:
#		collect_player.stream = collect_sounds.pick_random()
		collect_player.play()

func play_jump_sound():
	if !jump_player.playing:
		jump_player.play()

func play_gravity_sound():
	if !gravity_player.playing:
		gravity_player.play()

func play_checkpoint_sound():
	checkpoint_player.play()

func kill_music():
	music_player.stop()
