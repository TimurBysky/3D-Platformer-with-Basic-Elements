extends Area3D


func _on_body_entered(body):
	if body.name == "Player":
		body.add_coin()  # Предполагаем, что у игрока есть такой метод
		queue_free()  # Удаляем монетку
