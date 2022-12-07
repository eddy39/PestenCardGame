extends KinematicBody2D


var hand_cards = []
var distance_to_player = 0
var distance_between_cards = 50
# preload
var card_scene = preload("res://Scenes/Card.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func add_card(card_name):
	hand_cards.append(card_name)
	var card_ = card_scene.instance()
	card_.card_name = card_name
	card_.front = false
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
		var player_dist = distance_to_player * Vector2.UP
		var card_position = i* Vector2(distance_between_cards,0)
		var centering_dist = $CardHolder.get_child_count()/2 * Vector2(distance_between_cards,0)
		card.position = player_dist + card_position - centering_dist

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _draw():
	#draw_circle(position,5,Color(1,0,0))
	pass
