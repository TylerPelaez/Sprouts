extends Node

var collected_count = 0
var collected_in_level = 0

var last_checkpoint_position
var last_checkpoint_index

func on_scene_restarted():
	collected_in_level = 0

func save_collected():
	collected_count += collected_in_level
	collected_in_level = 0
	last_checkpoint_position = null
	last_checkpoint_index = -1

func collect_one():
	collected_in_level += 1

func set_last_checkpoint_position(pos: Vector2, index: int):
	last_checkpoint_position = pos
	last_checkpoint_index = index
