extends AudioStreamPlayer

signal dialog_complete


@export var base_pitch_scale := 2.0
@export var pitch_random_offset_lower := -1.0
@export var pitch_random_offset_higher := 0.5
const space_noise_name = "Blank"
const voice_dir_path = "res://SFX/VoiceLetters"


var current_string: String
var current_string_index := 0

func _ready():
	finished.connect(play_current_letter)

func play_string(text):
	current_string = text
	current_string_index = 0
	play_current_letter()
	
func play_current_letter():
	if current_string_index >= current_string.length():
		dialog_complete.emit()
		return
	
	var current_letter = current_string[current_string_index].to_upper()
	current_string_index += 1
	
	var regex = RegEx.new()
	regex.compile("^[A-Za-z]+$")
	var result = regex.search(current_letter)
	
	if current_letter == " ":
		current_letter = space_noise_name
	elif !result || current_letter == "s": # Skip punctuation and the s sounds bad too
		play_current_letter()
		return
	
	pitch_scale = base_pitch_scale + randf_range(pitch_random_offset_lower, pitch_random_offset_higher)
	stream = load( "%s/%s.wav" % [voice_dir_path, current_letter] )
	
	play()

