extends CharacterBody2D

var speed = 300.0 

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


@export var boomerang_scene: PackedScene

func _unhandled_input(event: InputEvent) -> void:
	# Check for left mouse click
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		throw_boomerang()

func throw_boomerang() -> void:
	if not boomerang_scene:
		return

	# Create an instance of the boomerang
	var boomerang = boomerang_scene.instantiate()
	
	# Point it toward the mouse cursor
	var mouse_pos = get_global_mouse_position()
	boomerang.global_position = global_position
	boomerang.look_at(mouse_pos)
	
	# Tell the boomerang who the player is so it knows where to return
	boomerang.player = self
	
	# Add it to the main scene tree (so it doesn't move when the player moves)
	get_tree().current_scene.add_child(boomerang)
