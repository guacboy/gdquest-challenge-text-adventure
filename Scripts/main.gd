extends Control

# storyline interface
@onready var dialogue = $Dialogue
@onready var story = $Dialogue/Story
@onready var choices = $Dialogue/Choices

# stats interface
@onready var health = $Status/HBoxContainer/Health
var current_health: int = 3
@onready var energy = $Status/HBoxContainer/Energy
var current_energy: int = 5
@onready var currency = $Status/HBoxContainer/Currency
var current_currency: int = 10

func _ready() -> void:
	display_text(0, 0) # start

@export var scene_list: Array[DialoguePrompt] = []
var is_scene_randomize: bool = false
var is_last_scene_accessible: bool = false
var scene_count: int = 0

func display_text(current_scene_idx: int, current_dialogue_idx: int) -> void:
	var current_scene := scene_list[current_scene_idx].scene
	story.text = current_scene[current_dialogue_idx].dialogue
	create_button(current_scene_idx, current_dialogue_idx)

func create_button(current_scene_idx: int, current_dialogue_idx: int) -> void:
	# deletes any existing buttons
	for button: Button in choices.get_children():
		button.queue_free()
	
	# creates a new button with its respective text
	# reads the first array
	var current_scene := scene_list[current_scene_idx].scene
	# reads the second array
	var current_dialogue := current_scene[current_dialogue_idx].dialogue_choice
	# reads the third array
	for choice_button in current_dialogue:
		var button_instance := Button.new()
		button_instance.text = choice_button.dialogue_choice
		choices.add_child(button_instance)
		
		# if the button is associated with a specific functionality,
		# the functionality will connect to the button
		if choice_button.is_take_damage:
			button_instance.pressed.connect(take_damage)
		if choice_button.is_give_health:
			button_instance.pressed.connect(give_health)
		if choice_button.is_give_energy:
			button_instance.pressed.connect(give_energy)
		if choice_button.is_give_money or choice_button.is_gain_money:
			button_instance.pressed.connect(give_or_gain_money.bind(choice_button.amount_given_or_gain))
		if choice_button.is_quit:
			button_instance.pressed.connect(get_tree().quit)
		if choice_button.is_next_scene:
			current_scene_idx = choice_button.target_scene_idx
			scene_count += 1
		
		button_instance.pressed.connect(continue_dialogue.bind(current_scene_idx, choice_button.target_dialogue_idx))

func continue_dialogue(current_scene_idx: int, next_dialogue_idx: int) -> void:
	# enables/disables randomized scenes
	if scene_count == 1:
		is_scene_randomize = true
	if scene_count == 6:
		is_scene_randomize = false
		is_last_scene_accessible = true
		
	# plays scene at a random order (EXCLUDING the ending)
	if is_scene_randomize:
		current_scene_idx = randi_range(1, 3)
	# plays scene at a random order (INCLUDING the ending)
	if is_last_scene_accessible:
		current_scene_idx = randi_range(1, 4)
		
	display_text(current_scene_idx, next_dialogue_idx)

func take_damage() -> void:
	health.text = str(current_health - 1)
	
func give_health() -> void:
	health.text = str(current_health + 1)
	
func give_energy() -> void:
	energy.text = str(current_energy + 1)

func give_or_gain_money(amount: int) -> void:
	currency.text = str(current_currency + amount)
