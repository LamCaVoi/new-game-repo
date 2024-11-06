extends State

func enter(previous_state_path: String, data := {}) -> void:
	Engine.time_scale = 0.5
	var timer : Timer = Timer.new()
	timer.one_shot = true 
	timer.autostart = false
	timer.wait_time = 0.75
	timer.timeout.connect(reload)
	add_child(timer)
	timer.start()
	super(previous_state_path,data)
	
func reload() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene()
