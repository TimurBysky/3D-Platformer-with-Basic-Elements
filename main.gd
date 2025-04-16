extends Node3D
var next_scene = preload("res://second.tscn")
var await_time = 3.0

func _ready() -> void:
	YandexSDK.init_game()

func change_level():
	var timer = get_tree().create_timer(3.0)
	await timer.timeout
	get_tree().change_scene_to_packed(next_scene)
