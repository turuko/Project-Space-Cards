extends Node

const GROUND_PLANE = Plane(Vector3.UP, 0)
const RAY_LENGTH = 1000


func get_ground_click_location() -> Variant:
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_from = get_viewport().get_camera_3d().project_ray_origin(mouse_pos)
	var ray_to = ray_from + get_viewport().get_camera_3d().project_ray_normal(mouse_pos) * RAY_LENGTH
	return GROUND_PLANE.intersects_ray(ray_from, ray_to)


func draw_line(pos1: Vector3, pos2: Vector3, color: Color = Color.YELLOW) -> MeshInstance3D:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()

	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(pos1)
	immediate_mesh.surface_add_vertex(pos2)
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = color

	#get_tree().get_root().add_child(mesh_instance)

	return mesh_instance


func draw_rect(pos1: Vector3, pos2: Vector3, color: Color = Color.YELLOW) -> Node:
	
	var mesh_instance = Node.new()

	var l1 = draw_line(pos1, Vector3(pos1.x, pos1.y, pos2.z), color)
	var l2 = draw_line(Vector3(pos1.x, pos1.y, pos2.z), pos2, color)
	var l3 = draw_line(pos2, Vector3(pos2.x, pos2.y, pos1.z), color)
	var l4 = draw_line(Vector3(pos2.x, pos2.y, pos1.z), pos1, color)

	mesh_instance.add_child(l1)
	mesh_instance.add_child(l2)
	mesh_instance.add_child(l3)
	mesh_instance.add_child(l4)


	get_tree().get_root().add_child(mesh_instance)

	return mesh_instance


func spawn_cube(pos: Vector3) -> Node:
	var cube = MeshInstance3D.new()
	var cube_mesh = BoxMesh.new()

	cube.mesh = cube_mesh

	cube.position = pos

	get_tree().get_root().add_child(cube)

	return cube




