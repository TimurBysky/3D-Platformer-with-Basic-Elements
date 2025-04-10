extends Control  # Убедитесь, что скрипт привязан к Control-ноде

@onready var coin_label = $MarginContainer/CoinLabel 

func update_coin_count(value):
	if coin_label:
		coin_label.text = "Монеты: %d" % value
	else:
		printerr("CoinLabel не найден!")
