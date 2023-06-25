extends Node

var collected_count = 0
var collected_in_level = 0

func on_scene_restarted():
	collected_in_level = 0

func save_collected():
	collected_count += collected_in_level
	collected_in_level = 0

func collect_one():
	collected_in_level += 1
