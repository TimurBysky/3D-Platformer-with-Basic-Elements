class_name LevelClass
extends Node3D

var next_scene: PackedScene
var await_time: float = 3.0

func _ready() -> void:
	await YandexSDK.init_game()

func change_level():
	var timer = get_tree().create_timer(await_time)
	await timer.timeout
	YandexSDK.show_interstitial_ad()
	get_tree().change_scene_to_packed(next_scene)

func defeat():
	var timer = get_tree().create_timer(await_time)
	await timer.timeout
	get_tree().reload_current_scene()
