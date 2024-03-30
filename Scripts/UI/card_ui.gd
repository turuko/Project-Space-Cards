class_name CardUI extends Control

signal reparent_requested(card_ui: CardUI)

@onready var art: TextureRect = $MarginContainer/Content/Art
@onready var name_label: Label = $MarginContainer/Panel/Name
@onready var effects_label: Label = $MarginContainer/Content/Effects
@onready var attack_label: Label = $MarginContainer/Content/Stats/Attack
@onready var count_label: Label = $MarginContainer/Content/Stats/UnitCount
@onready var health_label: Label = $MarginContainer/Content/Stats/Health
@onready var cost_label: Label = $CostRect/Cost
@onready var state_machine: CardStateMachine = $CardStateMachine as CardStateMachine

var card: Card

func initialize(c: Card) -> void:
	card = c

func _ready() -> void:
	art.texture = card.art
	name_label.text = card.name
	cost_label.text = str(card.cost)

	
	if card is CommanderCard:
		var c = card as CommanderCard
		attack_label.text = str(c.damage)
		count_label.set_visible(false)
		health_label.text = str(c.health)
	if card is CreatureCard:
		var c = card as CreatureCard
		attack_label.text = str(c.damage_per_unit)
		count_label.text = str(c.amount)
		health_label.text = str(c.health_per_unit)
	if card is SpellCard:
		var bottom_separator = $MarginContainer/Content/HSeparator
		bottom_separator.set_visible(false)
		attack_label.set_visible(false)
		count_label.set_visible(false)
		health_label.set_visible(false)

	var effects_strings: PackedStringArray = []
	for e in card.effects:
		effects_strings.append(e.description)
	effects_label.text = ".".join(effects_strings)
	
	state_machine.init(self)
	
	
func _input(event: InputEvent) -> void:
	state_machine.on_input(event)
	
	
func _on_gui_input(event: InputEvent) -> void:
	state_machine.on_gui_input(event)
	
	
func _on_mouse_entered() -> void:
	state_machine.on_mouse_entered()


func _on_mouse_exited() -> void:
	state_machine.on_mouse_exited()
