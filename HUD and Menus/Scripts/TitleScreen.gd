extends ColorRect

onready var delay = $Timer

onready var play = $main/play
onready var options = $main/options
onready var quit = $main/quit
onready var title_menu = $main
onready var saves_menu = $saves
onready var new_save_menu = $new_save
onready var options_menu = $Options
onready var new = $saves/HBoxContainer/new
onready var create = $new_save/create
onready var load_save = $saves/HBoxContainer/load
onready var saves_list = $saves/saves_list

var locked_input = true

const yellow = Color8(242, 211, 53)
const white = Color8(255, 255, 255)

# save icon preload
onready var SAVE_ICON = preload("res://HUD and Menus/Icons/save.png")

func _ready() -> void:
	play.grab_focus()
	visible = true
	load_saves_list_items()
	
	# load settings config
	var settings_config = File.new()
	
	if settings_config.file_exists("user://settings_config"):
		var error = settings_config.open("user://settings_config", File.READ)
		
		if error == OK:
			# load works
			var new_settings = settings_config.get_var()
			if new_settings == null:
				global.var_debug_msg(self, 0, new_settings)
				return
			
			for i in global.settings.keys().size():
				var key = global.settings.keys()[i]
				if new_settings.has(key):
					global.settings[key] = new_settings[key]

		else:
			# load failed
			global.debug_msg(self, 0, "could not load settings_config")
	else:
		global.debug_msg(self, 0, "could not find settings_config")
	
	OS.window_fullscreen = global.settings["fullscreen"]

func multi_color_set(target:Control, color:Color):
	target.set_deferred("custom_colors/font_color", color)
	target.set_deferred("custom_colors/font_color_pressed", color)
	target.set_deferred("custom_colors/font_color_hover", color)

func load_saves_list_items(): # add items from the saves directory into here
	saves_list.clear()
	
	# sets saves var to all the files in the saves directory
	global.get_saves()
	
	for i in global.saves.size():
		saves_list.add_item(global.saves[i], SAVE_ICON)
		
		var tooltip = "(oops, tooltip broke. pls report)"
		var reader = File.new()
		var error = reader.open(global.SAVE_DIR + global.saves[i], File.READ)
		if error == OK:
			var data = reader.get_var()
			tooltip = "Stars: "+str(data["stars"])
		
		saves_list.set_item_tooltip(i, tooltip)

func _on_Timer_timeout() -> void:
	locked_input = false

func _on_play_pressed() -> void:
	load_saves_list_items()
	title_menu.visible = false
	saves_menu.visible = true
	new.grab_focus()

func _on_options_pressed() -> void:
	if title_menu.visible == false: return
	title_menu.visible = false
	options_menu.visible = true

func _on_quit_pressed() -> void:
	if title_menu.visible == false: return
	get_tree().quit()

func _on_Options_visibility_changed() -> void:
	if options_menu.visible == false and title_menu.visible == false:
		title_menu.visible = true

func _on_back_pressed() -> void:
	saves_menu.visible = false
	title_menu.visible = true
	play.grab_focus()

func _on_new_pressed() -> void:
	saves_menu.visible = false
	new_save_menu.visible = true
	create.grab_focus()

func _on_cancel_pressed() -> void:
	load_saves_list_items()
	new_save_menu.visible = false
	saves_menu.visible = true
	new.grab_focus()

func _on_create_pressed() -> void:
	var new_save_name = $new_save/VBoxContainer/HBoxContainer/name.text
	if new_save_name == "": 
		new_save_name = "untitled save"
	
	global.save_name = new_save_name
	
	var data = global.get_empty_save_data()
	data["save_name"] = global.save_name
	
	global.write_save(global.save_name, data)
	global.load_save(global.save_name)

func _on_load_pressed() -> void:
	if saves_list.get_selected_items().size() == 0: return
	global.load_save(saves_list.get_item_text(saves_list.get_selected_items()[0]))
	
func _on_delete_pressed() -> void:
	if saves_list.get_selected_items().size() == 0: return
	global.delete_save(saves_list.get_item_text(saves_list.get_selected_items()[0]))
	load_saves_list_items()

func _on_Options_closed() -> void:
	title_menu.visible = true
	play.grab_focus()
