extends Node

func call_delayed(method: Callable, delay_seconds: float):
	get_tree().create_timer(delay_seconds).timeout.connect(method)
