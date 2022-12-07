extends Sprite

var card_name
var front = false
var in_players_hand = false
var card_owner

var card_front = preload("res://Assets/CardFront.png")
var card_back = preload("res://Assets/CardBack.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	setup()
	$Area2D.connect("input_event",self,"area_input")

func setup():
	if front:
		texture = card_front
		$Label.text = card_name
	else:
		texture = card_back
		$Label.text = ""

func area_input(viewport:Node,event:InputEvent,shape_idx:int):
	# ignore non mouse events
	if not event is InputEventMouse:
		return
	# play card when double clicked and in player hand
	if event.is_action_pressed("left_click") and event.doubleclick and in_players_hand:
		# check if its players turn
		if not Autoload.game_scene.active_player==card_owner:
			return
		# check if card playable
		if Autoload.game_scene.can_play_card(card_name):
			# card is playable so play card
			Autoload.game_scene.play_card(self,card_owner)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
