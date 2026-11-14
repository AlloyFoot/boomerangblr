extends Area2D

signal returned

enum State { IDLE, THROWING, RETURNING }
var current_state = State.IDLE

var player: Node2D = null
var velocity: Vector2 = Vector2.ZERO
var speed: float = 600.0
var max_distance: float = 400.0
var traveled_distance: float = 0.0

func throw(throw_direction: Vector2, throwing_player: Node2D) -> void:
	player = throwing_player
	current_state = State.THROWING
	velocity = throw_direction.normalized() * speed
	traveled_distance = 0.0
	
	# Reparent to the root/world so it doesn't move with the player
	var world = get_tree().current_scene
	var current_parent = get_parent()
	if current_parent != world:
		current_parent.remove_child(self)
		world.add_child(self)
		global_position = throwing_player.global_position

func _physics_process(delta: float) -> void:
	match current_state:
		State.IDLE:
			return
			
		State.THROWING:
			position += velocity * delta
			traveled_distance += velocity.length() * delta
			rotation += 25.0 * delta # Spin effect
			
			# Switch to returning once max distance is reached
			if traveled_distance >= max_distance:
				current_state = State.RETURNING
				
		State.RETURNING:
			if not is_instance_valid(player):
				_catch_and_destroy()
				return
				
			# Continuously steer towards the player's current position
			var direction = (player.global_position - global_position).normalized()
			velocity = direction * speed
			position += velocity * delta
			rotation += 25.0 * delta # Spin effect
			
			# Catch check: if close enough to player, collect it
			if global_position.distance_to(player.global_position) < 30.0:
				_catch_and_destroy()

func _catch_and_destroy() -> void:
	returned.emit()
	queue_free()

# Optional: Handle hitting walls or enemies
func _on_body_entered(body: Node2D) -> void:
	if body == player and current_state == State.RETURNING:
		_catch_and_destroy()
	elif not body.is_in_group("Player") and current_state == State.THROWING:
		# Turn back early if it hits a wall/obstacle
		current_state = State.RETURNING
