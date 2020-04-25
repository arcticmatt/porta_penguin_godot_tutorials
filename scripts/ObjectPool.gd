extends Node

### Export variables
export var g_copies_of_each: int = 2
export var g_min_y: int = 860
export var g_max_y: int = 860
export var g_min_spawn_wait_ms: int = 1000
export var g_max_spawn_wait_ms: int = 2000
export var g_object_velocity: float = 5
export var g_path: String = ""
export var g_starting_x: int = 1700

### Object pool globals
var g_last_spawn_time_ms: int = 0
var g_max_available_objects: int = 0
var g_object_pool: Array = []
var g_object_pool_available: Array = []
var g_rand_spawn_wait_ms: int = 0

### Constants
const LEFT_BOUND: int = -50

func _ready():
	var paths: Array = _get_full_paths(g_path)
	for path in paths:
		var resource = load(path)
		for _i in g_copies_of_each:
			var object: Node2D = resource.instance()
			object.global_position = _get_random_global_position(object)
			g_object_pool.append(object)
			g_object_pool_available.append(object)
			get_parent().call_deferred('add_child_below_node', self, object)
	
	g_max_available_objects = paths.size() * g_copies_of_each
			
func _process(delta: float) -> void:
	var time_diff = OS.get_system_time_msecs() - g_last_spawn_time_ms
	if time_diff > g_rand_spawn_wait_ms:
		var available_object = _find_and_remove_available_object()
		if available_object:
			available_object.global_position = _get_random_global_position(available_object)
			available_object.start(g_object_velocity)
			g_last_spawn_time_ms = OS.get_system_time_msecs()
			g_rand_spawn_wait_ms = rand_range(g_min_spawn_wait_ms, g_max_spawn_wait_ms)
		_add_to_available_objects()

func _add_to_available_objects() -> void:
	for object in g_object_pool:
		if object.is_inside_tree() and object.global_position.x < LEFT_BOUND:
			object.global_position = _get_random_global_position(object)
			object.reset()
			g_object_pool_available.append(object)
			
	assert(g_object_pool_available.size() <= g_max_available_objects)

# Returns and removes a random object from the pool of available objects,
# if one exists.
func _find_and_remove_available_object() -> Node2D:
	if g_object_pool_available.size() == 0:
		return null
	var available_index: int = randi() % g_object_pool_available.size()
	var available_object: Node2D = g_object_pool_available[available_index]
	g_object_pool_available.remove(available_index)
	return available_object
	
# Given a path to either a file or directory, returns a list of all the paths 
# for which we should instance a resource.
# @param path either a file (.tscn) or a directory of scene files.
# @return the path names for which we should instance a resource.
func _get_full_paths(path: String) -> Array:
	if path.ends_with('.tscn'):
		return [path]
	
	var files = _list_files_in_directory(path)
	var paths = []
	for file in files:
		paths.append(path + file)
	return paths
	
# Returns a random (within certain boundaries) global position to spawn the
# passed-in object at.
func _get_random_global_position(object: Node2D) -> Vector2:
	var texture_height: float = object.get_height()
	var starting_y: float = rand_range(g_min_y, g_max_y) - (texture_height / 2)
	return Vector2(g_starting_x, starting_y)
	
# Given a path to a directory, returns the names of all
# files in that directory.
# @param path the path to a directory, e.g. "res://scenes/characters"
# @return the names of all files in that directory, e.g. ["CaptainHook.tscn"]
func _list_files_in_directory(path: String) -> Array:
	var files: Array = []
	var dir := Directory.new()
	
	dir.open(path)
	
	# Initialize stream used to list all files and directories
	dir.list_dir_begin()
	
	while true:
		var file: String = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)
	
	# Close stream
	dir.list_dir_end()
	
	return files
