extends CharacterBody2D

@export var speed: float = 40.0 # Lower number = slower walk speed (try 30 to 50)

@onready var sprite: Sprite2D = $Sprite2D # Adjust if your sprite has a different name

func _physics_process(_delta: float) -> void:
	var player = get_tree().current_scene.get_node_or_null("Player")

	if player:
		# Smoothly move toward the player's position
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * speed
		move_and_slide()

		# Safely flip sprite based on walking direction
		if sprite and direction.x != 0:
			sprite.flip_h = direction.x < 0
