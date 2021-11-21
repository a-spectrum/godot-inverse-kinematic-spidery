extends Position3D

onready var follow_raycast : RayCast = null

func _ready():
	set_as_toplevel(true)

func _register_raycast(ray: RayCast) -> void:
	follow_raycast = ray
