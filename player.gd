extends CharacterBody3D

@onready var animation_player = get_node("godotman/AnimationPlayer")
@onready var model = get_node("godotman/godot_rig/Skeleton3D/godot_mesh")  # Предполагая, что модель - это дочерний узел

# Настройки
var speed = 5.0
var jump_force = 4.5
var gravity = 9.8
var rotation_speed = 10.0  # Скорость поворота

# Переменные
var is_alive = true
var coins = 0
signal coin_collected(amount)

func _ready():
	animation_player.play("idle")

func add_coin():
	coins += 1
	emit_signal("coin_collected", coins)

func _physics_process(delta):
	if not is_alive: return
	
	# Гравитация
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	# Прыжок
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force
		
	# Движение
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		
		# Плавный поворот в сторону движения
		var target_angle = atan2(direction.x, direction.z)
		model.rotation.y = lerp_angle(model.rotation.y, target_angle, delta * rotation_speed)
		
		animation_player.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
		animation_player.play("idle")
	
	move_and_slide()

func _on_death_zone_entered():
	is_alive = false
	animation_player.play("die")
	await get_tree().create_timer(1.0).timeout
	position = Vector3(0, 5, 0)
	is_alive = true
	animation_player.play("idle")
