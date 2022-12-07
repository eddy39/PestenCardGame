extends Node


var n_start_cards = 9

var card_kinds = ["heart", "diamand", "spades", "cross"]
var card_names = ["2","3","4","5","6","7","8","9","10"
					,"jack", "queen" , "king", "ace"]
var card_list = []

# so cards can call the game scene when played
var game_scene 
# Called when the node enters the scene tree for the first time.
func _ready():
	create_card_list()


func create_card_list():
	card_list = []
	for kind in card_kinds:
		for name_ in card_names:
			var card_name = kind + "_" + name_
			card_list.append(card_name)
 

