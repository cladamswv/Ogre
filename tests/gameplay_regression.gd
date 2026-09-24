extends SceneTree

var failures := 0

func _initialize() -> void:
	call_deferred("run_checks")

func check(condition: bool, message: String) -> void:
	if not condition:
		failures += 1
		printerr("FAIL: " + message)

func run_checks() -> void:
	var game := MarchMatch.new()
	root.add_child(game)
	game.set_physics_process(false)
	game.set_process(false)

	# Desktop touch emulation can deliver both touch and mouse movement. A
	# single swipe should move the camera once, regardless of event order.
	var mouse_down := InputEventMouseButton.new()
	mouse_down.button_index = MOUSE_BUTTON_LEFT
	mouse_down.pressed = true
	game._unhandled_input(mouse_down)
	var touch_down := InputEventScreenTouch.new()
	touch_down.index = 0
	touch_down.pressed = true
	game._unhandled_input(touch_down)
	var touch_drag := InputEventScreenDrag.new()
	touch_drag.index = 0
	touch_drag.relative = Vector2(120, 0)
	game._unhandled_input(touch_drag)
	var after_touch := game.camera_target_x
	var mouse_move := InputEventMouseMotion.new()
	mouse_move.relative = Vector2(120, 0)
	game._unhandled_input(mouse_move)
	check(is_equal_approx(game.camera_target_x, after_touch), "A synthesized mouse move must not pan twice during touch")
	var touch_up := InputEventScreenTouch.new()
	touch_up.index = 0
	game._input(touch_up)
	var mouse_up := InputEventMouseButton.new()
	mouse_up.button_index = MOUSE_BUTTON_LEFT
	game._input(mouse_up)

	game.phase = "won"
	game._unhandled_input(mouse_down)
	var after_result := game.camera_target_x
	mouse_move.relative = Vector2(-100, 0)
	game._unhandled_input(mouse_move)
	check(is_equal_approx(game.camera_target_x, after_result), "Result screen should not pan the battlefield")
	game._input(mouse_up)
	game.phase = "playing"
	game.toggle_pause()
	check(paused and game.hud.pause_panel.visible, "Pause menu opens while the match stops")
	game.toggle_pause()
	check(not paused and not game.hud.pause_panel.visible, "Resume returns to active battle")
	game.hud.show_result(true, 110.0, 2, 4, 1800)
	check(game.hud.result_panel.visible and not game.hud.pause_panel.visible, "Win result is visible and closes pause")

	game.free()
	await create_timer(1.0).timeout
	if failures == 0:
		print("Ogre War touch, mouse, result and pause regression checks passed.")
	call_deferred("quit", 1 if failures > 0 else 0)
