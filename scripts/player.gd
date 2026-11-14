extends CharacterBody2D

var speed = 300.0 

const BOOMERANG_SCENE = preload("res://scenes/boomerang.tscn")
var can_throw: bool = true

func _process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()

func _physics_process(delta: float) -> void:
	var move_dir = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))
	
	if move_dir != Vector2.ZERO:
		velocity = speed * move_dir
		
		if move_dir.x != 0:
			$playerSprite.flip_h = move_dir.x < 0
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.y = move_toward(velocity.y, 0, speed)

	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("throw_boomerang") and can_throw:
		throw_boomerang()

func throw_boomerang() -> void:
	can_throw = false # Prevent throwing multiple until caught
	
	var boomerang = BOOMERANG_SCENE.instantiate()
	
	# Determine direction based on mouse position
	var throw_dir = (get_global_mouse_position() - global_position).normalized()
	
	# Add it to the scene tree first
	get_tree().current_scene.add_child(boomerang)
	boomerang.global_position = global_position
	
	# Connect signal to reset can_throw when the boomerang returns
	boomerang.returned.connect(_on_boomerang_returned)
	
	# Initialize the throw
	boomerang.throw(throw_dir, self)

func _on_boomerang_returned() -> void:
	can_throw = true
