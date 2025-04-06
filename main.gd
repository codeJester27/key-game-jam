class_name Main
extends Node

@onready var player: Player = $Player
@onready var restart_screen = $RestartScreen
var game_active: bool = true

func _ready():
	restart_screen.hide()
	connect_player_signals()
	print("Game initialized - Player and Sword ready")

func spawn_locklet():
	var locklet_scene = preload("res://locklets/standard_locklet.tscn")
	var new_locklet = locklet_scene.instantiate()
	
	new_locklet.player_node = get_node("Player").get_path()
	
	add_child(new_locklet)
	new_locklet.global_position = Vector2(200, 200)

func connect_player_signals():
	if player.has_signal("player_attacked"):
		player.connect("player_attacked", _on_player_attack)
	if player.has_signal("died"):
		player.connect("died", _died)
		print("Connected")
	else:
		push_warning("Player node is missing 'died' signal")

func _on_player_attack():
	print("Player attacked with sword!")

func _died():
	var viewport := get_viewport()
	var viewport_rect := viewport.get_visible_rect()
	var camera := viewport.get_camera_2d()
	
	var screen_center: Vector2
	if camera:
		screen_center = camera.get_screen_center_position()
	else:
		screen_center = viewport_rect.size / 2

	restart_screen.position = screen_center - (restart_screen.size / 2)
	restart_screen.show()

func pause_game():
	game_active = false
	print("Game paused")

func resume_game():
	game_active = true
	print("Game resumed")

func _process(delta):
	if !game_active:
		return

	_check_game_conditions()

func _check_game_conditions():
	pass
	
