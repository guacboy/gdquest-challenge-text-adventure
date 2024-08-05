class_name DialogueChoice extends Resource

@export_multiline var dialogue_choice: String = ""

@export_group("Damage")
@export var is_take_damage: bool = false

@export_group("Health")
@export var is_give_health: bool = false

@export_group("Energy")
@export var is_give_energy: bool = false

@export_group("Money")
@export var is_give_money: bool = false
@export var is_gain_money: bool = false
@export var amount_given_or_gain: int = 0

@export_group("")
@export var target_dialogue_idx: int = 0

@export_group("Scene")
@export var is_next_scene: bool = false
@export var target_scene_idx: int = 0

@export_group("")
@export var is_quit: bool = false
