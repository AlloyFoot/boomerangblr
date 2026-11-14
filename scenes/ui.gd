extends CanvasLayer

@onready var hearts: Array[Node] = $Control/HBoxContainer.get_children()

func update_health(current_hp: int) -> void:
	for i in range(hearts.size()):
		# Show heart if index is less than current HP, hide otherwise
		hearts[i].visible = i < current_hp
