extends Panel
@export var texture: Texture2D

var offset: Vector2 = Vector2.ZERO
var dragging: bool = false

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	
	if texture != null:
		var cardImage = $ImageCard as TextureRect
		cardImage.texture = texture

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		dragging = true
		offset = get_global_mouse_position() - global_position
		
		var main = get_tree().current_scene
		get_parent().remove_child(self)
		main.add_child(self)

func _process(_delta: float) -> void:
	if dragging:
		global_position = get_global_mouse_position() - offset

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and not event.pressed and dragging:
		dragging = false
		tentar_soltar()

func tentar_soltar() -> void:
	var slots = get_tree().get_nodes_in_group("slots")
	for slot in slots:
		if slot.get_global_rect().has_point(get_global_mouse_position()):
			colocar_no_slot(slot)
			return
	voltar_para_mao()

func colocar_no_slot(slot) -> void:
	limpar_slot_anterior()
	
	if "card" in slot:
		if slot.card != null:
			slot.card.voltar_para_mao()
		slot.card = self
	
	reparent(slot)
	position = Vector2.ZERO

func limpar_slot_anterior() -> void:
	var slots = get_tree().get_nodes_in_group("slots")
	for slot in slots:
		if "card" in slot and slot.card == self:
			slot.card = null

func voltar_para_mao() -> void:
	var hand = get_tree().current_scene.get_node("VBoxContainer/Hand")
	if hand:
		if get_parent():
			get_parent().remove_child(self)
		hand.add_child(self)
