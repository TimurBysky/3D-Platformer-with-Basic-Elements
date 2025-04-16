# В начале скрипта каждой сцены
extends "res://level_script.gd"

func _ready():
	next_scene = preload("res://second.tscn")  # Для второй сцены
