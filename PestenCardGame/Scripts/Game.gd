extends Node2D
# preload scenes
var card_scene = preload("res://Scenes/Card.tscn")
var bot_scene = preload("res://Scenes/Bot.tscn")
# play_vars
var bot_list = []
var deck_cards = []

var bot_turn_time = 2
var current_turn_time = 0

var active_player
var active_player_index = 0 #0 means player

var game_over = false
# graphic vars
var radius = 300
var center = OS.get_window_size()/2
# Called when the node enters the scene tree for the first time.
func _ready():
	# register yourself as game scene
	Autoload.game_scene = self
	bot_list = [$BotParent/Bot1,$BotParent/Bot2,$BotParent/Bot3]
	# create deck_cards
	create_deck(2)
	# deal cards
	for i in Autoload.n_start_cards:
		for bot in bot_list:
			deal_card_to(bot)
		deal_card_to($Player)
	# "deal" last card to DiscardPile
	$DiscardPile.card_name = deck_cards[0]
	$DiscardPile.front = true
	$DiscardPile.setup()
	deck_cards.remove(0)
	# player starts
	active_player = $Player
	

func add_bot():
	var bot_instance = bot_scene.instance()
	bot_list.append(bot_instance)
	
	$BotParent.add_child(bot_instance)
	bot_instance.look_at(center)
	bot_instance.rotate(PI/2)

func align_bots_circle():
	center = OS.get_window_size()/2
	for i in len(bot_list):
		var bot = bot_list[i]
		bot.position = center + Vector2(0,1).rotated((2*PI/(len(bot_list)+1)) *(i+1)) * radius
		bot.look_at(center)
		bot.rotate(PI/2)

func create_deck(n:int):
	for i in n:
		for card_ in Autoload.card_list:
			deck_cards.append(card_)
	deck_cards.shuffle()

func deal_card_to(target:Node2D):
	# adding card to target node
	target.add_card(deck_cards[0])
	## Animation and adding to scene is handled by target
	# remove card from deck
	deck_cards.remove(0)

func can_play_card(card_name:String) -> bool:
	var discard_pile_card = $DiscardPile.card_name
	# check if kind is same
	if card_name.split("_")[0] == discard_pile_card.split("_")[0]:
		return true
	# check if number is same
	if card_name.split("_")[1] == discard_pile_card.split("_")[1]:
		return true
	
	return false

func play_card(card:Node2D,card_owner:Node2D):
	if game_over:
		return
	# find and remove the card from owner
	card_owner.remove_card(card)
	# add card to discard Pile
	$DiscardPile.card_name = card.card_name
	$DiscardPile.setup()
	# TODO: APPLY CARD EFFEKT
	
	# End turn
	set_next_player()

func check_player_can_play():
	for card in $Player.hand_cards:
		if(can_play_card(card.card_name)):
			return true
	
	return false

func set_next_player():
	active_player_index = (active_player_index+1)%(len(bot_list)+1)
	if active_player_index==0:
		active_player = $Player
		########### Player turn starts
		if not check_player_can_play():
			deal_card_to($Player)
			# Player turn over
			active_player_index = (active_player_index+1)%(len(bot_list)+1)
			active_player = bot_list[active_player_index-1]
	else:
		active_player = bot_list[active_player_index-1]

func bot_ai(bot):
	
	for card in bot.hand_cards:
		if(can_play_card(card.card_name)):
			return card
	
	return ""

func check_win():
	if len($Player.hand_cards)==0:
		print("player won")
		game_over = true
	for bot in bot_list:
		if len(bot.hand_cards)==0:
			print("bot won")
			game_over = true

func _process(delta):
	# if game over stop
	if game_over:
		return
	# if its players turn wait
	if active_player == $Player:
		return
	# block turn for bot_turn_time
	current_turn_time+=delta
	if current_turn_time<bot_turn_time:
		return
	# reset current_turn_time
	current_turn_time = 0
	# if active player is bot
	var card2play = bot_ai(active_player)
	if card2play is String:
		# cant play a card
		deal_card_to(active_player)
		set_next_player()
	else:
		play_card(card2play,active_player)
	check_win()
