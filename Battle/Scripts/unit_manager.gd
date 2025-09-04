extends Node
@onready var unit_array
const CHARGE_TIME_MAX = 100
@onready var active_unit
signal send_unit_node
var turn_count = 0

func calculate_next_active_unit():
	var done = false
	if self.unit_array != null:
		while not done:
			for unit in self.unit_array:
				if unit.charge_time < CHARGE_TIME_MAX:
					unit.charge_time += unit.charge_speed
					if unit.charge_time >= CHARGE_TIME_MAX:
						unit.charge_time = 0
						active_unit = unit
						done = true
						turn_count += 1
						print(str("active unit is: ", active_unit, " turn count: ", turn_count))
						break
						
func _ready() -> void:
	unit_array = get_children()
	calculate_next_active_unit()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _input(event: InputEvent) -> void:
	pass#if event.is_action_pressed("jump_debug"):
		#calculate_next_active_unit()
