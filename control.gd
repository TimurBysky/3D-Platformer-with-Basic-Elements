extends Control  # Убедитесь, что скрипт привязан к Control-ноде

@onready var coin_label = $MarginContainer/CoinLabel # Если Label прямо в GameUI
# Или:
# @onready var coin_label = $Panel/CoinLabel  # Если Label вложен в Panel

func update_coin_count(value):
	if coin_label:
		coin_label.text = "Монеты: %d" % value
	else:
		printerr("CoinLabel не найден!")
