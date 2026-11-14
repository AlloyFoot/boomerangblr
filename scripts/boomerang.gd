extends Sprite2D

var player: Node2D
var speed: float = 400.0
var returning: bool = false
var flight_timer: float = 0.0
var max_flight_time: float = 0.4 # How long it flies out before returning

func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	
	# Spin the boomerang
	rotation += 15 * delta

	if not returning:
		# Fly outward to the right (or based on rotation)
		position += transform.x * speed * delta
		flight_timer += delta
		if flight_timer >= max_flight_time:
			returning = true
	else:
		# Fly back toward the player
		if is_instance_valid(player):
			var direction = (player.global_position - global_position).normalized()
			global_position += direction * speed * delta

			# If close enough to the player, pick it up and delete boomerang
			if global_position.distance_to(player.global_position) < 25:
				queue_free()
		else:
			queue_free()
	
	
