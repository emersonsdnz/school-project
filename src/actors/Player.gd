extends Actor

var direction = Vector2.ZERO

export var stomp_impulse: = 100.0

var start_x
var start_y

func _ready():
	start_x = position.x
	start_y = position.y
	pass

func _on_EnemyDedtector_area_entered(area: Area2D) -> void:
		_velocity = calculate_stomp_velocity(_velocity, stomp_impulse)
		
func _on_EnemyDedtector_body_entered(body: PhysicsBody2D) -> void:
	die()
	
func die() -> void:
	position.x = start_x
	position.y = start_y

func _physics_process(delta: float) -> void:
	var is_jump_interupted = Input.is_action_just_released("jump") and _velocity.y < 0
	var direction = get_direction()
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interupted)
	_velocity = move_and_slide(_velocity, Vector2.UP)
	if (position.y > 2000):
		die()
		
	if !(is_on_floor() or is_on_wall()):
		$Sprite.play("Jump")
	else: if direction.x < 0:
		$Sprite.flip_h = true
		$Sprite.play("Run")
		
	else: if direction.x > 0:
		$Sprite.flip_h = false
		$Sprite.play("Run")
	else:
		$Sprite.play("Idle")
	 
func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-1.0 if Input.is_action_just_pressed("jump") and (is_on_floor() or is_on_wall()) else 1.0
	)
	
func calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		speed: Vector2,
		is_jump_interupted: bool
	) -> Vector2:
	var new_velocity: = linear_velocity
	new_velocity.x = speed.x * direction.x
	new_velocity.y += gravity * get_physics_process_delta_time()
	if direction.y == -1.0:
		new_velocity.y = speed.y * direction.y
	if is_jump_interupted:
		new_velocity.y = 0.0
	return new_velocity

func calculate_stomp_velocity(linear_velocity: Vector2, impulse: float) -> Vector2:
	var out = linear_velocity
	out.y = -impulse
	return out
	


