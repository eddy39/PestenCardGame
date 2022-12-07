extends KinematicBody2D

var hand_cards = []
var distance_to_player = 0
var  distance_between_cards = 150
# preload
var card_scene = preload("res://Scenes/Card.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func add_card(card_name):
	hand_cards.append(card_name)
	var card_ = card_scene.instance()
	card_.card_name = card_name
	card_.front = true
	card_.in_players_hand = true
	card_.card_owner = self
	$CardHolder.add_child(card_)
	# align cards next to each other
	align_cards()

func remove_card(card):
	var ind_card = hand_cards.find(card.card_name)
	hand_cards.remove(ind_card)
	$CardHolder.remove_child(card)
	# align cards next to each other
	align_cards()

func align_cards():
	for i in $CardHolder.get_child_count():
		var card = $CardHolder.get_child(i)
		### FUNCTION TO THAT TELLS DISTANCE BETWEEN CARDS
		card.position = distance_to_player * Vector2.UP +  i* Vector2(distance_between_cards,0) - $CardHolder.get_child_count()/2 * Vector2(distance_between_cards,0)
		print(card.position)
#func _process(delta):
#	pass
