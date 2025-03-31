extends Area3D

func _on_body_entered(body):
	if body.name == "Player":
		body._on_death_zone_entered()  # Вызываем метод игрока
