extends CharacterBody3D

@onready var animation_player = get_node("godotman/AnimationPlayer")

# Настройки
var speed = 5.0
var jump_force = 4.5
var gravity = 9.8

# Переменные
var is_alive = true
var coins = 0
signal coin_collected(amount)

func _ready():
	animation_player.play("idle")  # Стартовая анимация

func add_coin():
	coins += 1
	emit_signal("coin_collected", coins)

func _physics_process(delta):
	if not is_alive: return
	
	# Гравитация
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force
		
		# Движение
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		# Анимация бега
		animation_player.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
		# Анимация покоя
		animation_player.play("idle")
	
	move_and_slide()

func _on_death_zone_entered():
	is_alive = false
	animation_player.play("die")  # Если есть анимация смерти
	await get_tree().create_timer(1.0).timeout  # Задержка перед респавном
	position = Vector3(0, 5, 0)
	is_alive = true
	animation_player.play("idle")  # Возврат к анимации покоя
