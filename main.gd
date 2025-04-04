class_name Main
extends Node

@onready var player: Player = $Player
@onready var sword: KeySword = $Player/key_sword

var game_active: bool = true

func _ready():
	connect_player_signals()
	print("Game initialized - Player and Sword ready")

func spawn_locklet():
	var locklet_scene = preload("res://standard_locket.tscn")
	var new_locklet = locklet_scene.instantiate()
	
	new_locklet.player_node = get_node("Player").get_path()
	
	add_child(new_locklet)
	new_locklet.global_position = Vector2(200, 200)

func connect_player_signals():
	if player.has_signal("player_attacked"):
		player.connect("player_attacked", _on_player_attack)

func _on_player_attack():
	print("Player attacked with sword!")

func pause_game():
	game_active = false
	Engine.time_scale = 0.0
	print("Game paused")

func resume_game():
	game_active = true
	Engine.time_scale = 1.0
	print("Game resumed")

func _process(delta):
	if !game_active:
		return

	_check_game_conditions()

func _check_game_conditions():
	pass
