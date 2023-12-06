extends CanvasLayer

const CHAR_READ_RATE = 0.05

onready var textbox_container = $TextboxContainer
onready var end_symbol = $TextboxContainer/MarginContainer/HBoxContainer/End
onready var start_symbol = $TextboxContainer/MarginContainer/HBoxContainer/Start
onready var label = $TextboxContainer/MarginContainer/HBoxContainer/Label

enum State{
	READY,
	READING,
	FINISHED
}

var current_state = State.READY
var text_queue = []

func _ready():
	print("Starting state: State.READY")
	hide_textbox()
	queue_text("NOTED: Press F for next dialogue")
	queue_text("It's been a while since father came home")
	queue_text("Perhaps father will come home tomorrow")
	queue_text("I'll waiting then")
	queue_text("I should go back to home before sun goes down")
	queue_text("Use a,w,s,d for move")
	queue_text("User space for roll or change stage and x for attack")
	queue_text("If you want to pause and unpause you can use esc")

# warning-ignore:unused_argument
func _process(delta):
	match current_state:
		State.READY:
			if !text_queue.empty():
				display_text()
		State.READING:
			if Input.is_action_just_pressed("ui_dialogue"):
				label.percent_visible = 1.0
				$Tween.stop_all()
				end_symbol.text ="V"
				change_state(State.FINISHED)
		State.FINISHED:
			if Input.is_action_just_pressed("ui_dialogue"):
				change_state(State.READY)
				hide_textbox()

func queue_text(next_text):
	text_queue.push_back(next_text)

func hide_textbox():
	start_symbol.text = ""
	label.text = ""
	textbox_container.hide()

func show_textbox():
	start_symbol.text = "*"
	textbox_container.show()
	
func display_text():
	var next_text = text_queue.pop_front()
	label.text = next_text
	label.percent_visible = 0.0
	change_state(State.READING)
	show_textbox()
	$Tween.interpolate_property(label, "percent_visible", 0.0, 1 , len(next_text) * CHAR_READ_RATE, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func _on_Tween_tween_all_completed():
	end_symbol.text = "v"
	change_state(State.FINISHED)

func change_state(next_state):
	current_state = next_state
	match current_state:
		State.READY:
			print("Changing state to: State.READY")
		State.READING:
			print("Changing state to: State.READING")
		State.FINISHED:
			print("Changing state to: State.FINISHED")
