extends CharacterBody3D

@onready var animation_player = get_node("godotman/AnimationPlayer")
@onready var model = get_node("godotman/godot_rig/Skeleton3D/godot_mesh") 

enum State { IDLE, RUN, ATTACK, DEAD }


# Настройки
var speed = 3.0
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
	
func check_coins_count():
	if coins == get_tree().get_nodes_in_group("Coins").size():
		Label

func _physics_process(delta):
	if not is_alive: 
		set_state(State.DEAD)
		return
	
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
		set_state(State.RUN)
		
		# Поворот модели
		var target_angle = atan2(direction.x, direction.z)
		model.rotation.y = lerp_angle(model.rotation.y, target_angle, delta * rotation_speed)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
		set_state(State.IDLE)
	
	move_and_slide()
	
func set_state(new_state: State):
	match new_state:
		State.IDLE:
			animation_player.play("idle", 0.3)
		State.RUN:
			animation_player.play("run", 0.3)
		State.DEAD:
			animation_player.play("die", 0.3)

func _on_death_zone_entered():
	is_alive = false
	await get_tree().create_timer(1.0).timeout
	YandexSDK.show_interstitial_ad()
	position = Vector3(0, 5, 0)
	is_alive = true
	set_state(State.IDLE)
