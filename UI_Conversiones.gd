extends Control

var unidades := [
	" Masa y Densidad",
	" Longitud",
	" Velocidad",
	" Volumen",
	" Fuerza",
	" Presion",
	" Energia",
	" Transferencia de Energia",
	" Calor Especifico",
	" Otros",
]

var actual_type := -1
var actual_conversion := -1

var conv_count = 0

onready var pop_up := $Fondo/VBoxContainer/Popup_unidades
onready var label_pu := $Fondo/VBoxContainer/Popup_unidades/Button/Label

onready var pop_up_conver = $Fondo/VBoxContainer2/Popup_conversiones
onready var label_puc =$Fondo/VBoxContainer2/Popup_conversiones/Button/Label

onready var line_edit = $HBoxContainer/VBoxContainer/LineEdit
onready var label_final = $HBoxContainer/VBoxContainer2/Label2
onready var label_units = $HBoxContainer/VBoxContainer/Label
onready var label_unit_final = $HBoxContainer/VBoxContainer2/ufinal

onready var cont_history = $Conv_history
onready var cont_debug = $VBoxContainer2
onready var label_history = $Conv_history/RichTextLabel
onready var label_debug = $VBoxContainer2/RichTextLabel

func _ready():
	pop_up.get_popup().connect("id_pressed", self, "on_item_id_pressed")
	pop_up_conver.get_popup().connect("id_pressed", self, "on_item_id_conver_pressed")
	debug("Sys: Programa inicializado correctamente")

func on_item_id_pressed(id):
	actual_type = id
	label_pu.set_text(unidades[id])
	
	var pu = pop_up_conver.get_popup()
	
	pu.clear()
	
	print("Tipo: " + str(actual_type))
	for c in range(0,Conversiones.conv[actual_type].size()):
		print(c)
		var text = Conversiones.dic[str(actual_type)].get(str(c)).split("_")
		pu.add_item((text[0] + " - " + text[1]), c)
	
	if actual_conversion == -1:
		actual_conversion = 0
	actualice_conv_text()

func on_item_id_conver_pressed(id):
	actual_conversion = id
	actualice_conv_text()

func actualice_conv_text():
	var text = Conversiones.dic[str(actual_type)].get(str(actual_conversion)).split("_")
	label_puc.set_text(text[0] + " - " + text[1])
	label_units.set_text("Unidades a convertir (%s)" %text[0])
	label_unit_final.set_text("Unidades resultantes (%s)" %text[1])

func convertir():
	var value = float(line_edit.text)
	var conv = Conversiones.conv[actual_type]
	var new_value = value * conv[actual_conversion]
	label_final.set_text(str(new_value))
	conv_history(value, new_value)

func _on_Button_button_down():
	if actual_type == -1:
		debug("EROR: Ningun tipo de Unidad elegido")
		return
	
	if actual_conversion == -1:
		debug("EROR: Ningun tipo de conversion elegido")
		return
	
	if !line_edit.text.is_valid_float() and !line_edit.text.is_valid_integer():
		debug("EROR: Valor no valido para convertir")
		return
	
	convertir()

func conv_history(value: int, conv: int):
	conv_count += 1
	var prev_text = label_history.text
	var conv_text = Conversiones.dic[str(actual_type)].get(str(actual_conversion)).split("_")
	var new_text = str(value) + " " + conv_text[0] + " = " + str(conv) + " " + conv_text[1]
	label_history.set_text(prev_text + "\n" + str(conv_count) + ": " + new_text)


func debug(text: String):
	var prev_text = label_debug.text
	label_debug.set_text(prev_text + "\n" + text)

func _on_CB_history_toggled(button_pressed):
	cont_history.visible = button_pressed

func _on_CB_debug_toggled(button_pressed):
	cont_debug.visible = button_pressed
