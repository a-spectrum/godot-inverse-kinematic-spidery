extends Position3D

onready var follow_raycast : RayCast = null

var position_on_curve := 0.0
var position_start := Vector3.ZERO
var position_end := Vector3.ZERO

var move_position := false

func _ready():
	set_as_toplevel(true)

func _process(delta):
	position_on_curve += 0.05
	
	if position_on_curve >= 1:
		move_position = false
		position_on_curve = 0.0
	
	if move_position:
		_calculate_bezier_curve(position_start, position_end)
	
func _move_position(start: Vector3, end: Vector3) -> void:
	position_start = start
	position_end = end
	move_position = true

func _register_raycast(ray: RayCast) -> void:
	follow_raycast = ray

func _calculate_bezier_curve(start: Vector3, end: Vector3):	
	var generate_third_point := Vector3.ZERO;
	generate_third_point.y += start.y + 1
	generate_third_point.x += (end.x - start.x) / 3
	generate_third_point.z += (end.x - start.x) / 3
	
	var calc_point_0 = start.linear_interpolate(generate_third_point, position_on_curve)
	var calc_point_1 = generate_third_point.linear_interpolate(end, position_on_curve)
	var current_position = calc_point_0.linear_interpolate(calc_point_1, position_on_curve)
	transform.origin = current_position
