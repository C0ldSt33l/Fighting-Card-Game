extends Node

var database : SQLite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	database = SQLite.new()
	database.path = "res://DB/Config.db"
	database.open_db()
	pass # Replace with function body.

func select_Smth(query:String)-> Array:
	database.query(query)
	
	return database.query_result

func select_tag_cards(CardID: int) -> Array: #return all tags card by id 
	database.query("
	SELECT t.name,t.value 
	from tags t
	join CARD_TAG ct on ct.id_tag = t.id
	WHERE ct.id_card = " + str(CardID))
	
	return database.query_result

func select_cards_with_tags() -> Array:
	var tmp = []
	var cards_with_tags = []
	database.query("SELECT * FROM CARDS")
	tmp = database.query_result
	for card in tmp:
		var tags = select_tag_cards(card.id)
		
		cards_with_tags.append({
			"card":card,
			"tags":tags
		})
	return cards_with_tags

func select_card_dy_id(id:int)->Array:
	database.query("select * from CARDS where CARDS.id = "+str(id))
	if !database.query_result.is_empty():
		return database.query_result
	database.query("
	SELECT c.* 
	from CARDS c
	join PLAYERS_CARD pl on pl.old_id_card = c.id
	where new_id_card ="+str(id))
	return database.query_result

func select_players_cards()->Array:
	var cards_with_tags = []
	database.query("SELECT * FROM PLAYERS_CARD")
	var tmp = database.query_result
	for i in tmp:
		var card = select_card_dy_id(i.old_id_card)
		var oldTag = select_tag_cards(i.old_id_card)
		var newTag = select_tag_cards(i.new_id_card)
		cards_with_tags.append({
			"card":card,
			"tags":oldTag + newTag
		})
	return cards_with_tags

func select_combo_by_id(id:int)->Array:
	database.query("select * from COMBO where COMBO.id = "+str(id))
	return database.query_result

func select_combos_tag(ComboID:int)->Array:
	database.query("
	SELECT t.name,t.value 
	from tags t
	join COMBO_TAG ct on ct.id_tag = t.id
	WHERE ct.id_card = " + str(ComboID))
	return database.query_result

func select_players_combo()->Array:
	var result = []
	database.query("select * from PLAYERS_COMBO")
	var tmp = database.query_result
	for i in tmp:
		var combo = select_combo_by_id(i.old_id_combo)
		var oldTag = select_combos_tag(i.old_id_combo)
		var newTag = select_combos_tag(i.new_id_combo)
		result.append({
			"combo":combo,
			"tags":oldTag + newTag
		})
	return result

func insert_new_card(NameCard:String,Point:int,Factor:int,Price:int)->void:
	var data ={
		"Name":NameCard,
		"Point":Point,
		"Factor":Factor,
		"Price":Price
	}
	database.insert_row("CARDS",data)

func insert_new_combo(NameCard:String,Point:int,Factor:int,Description:String,Price:int)->void:
	var data ={
		"Name":NameCard,
		"Point":Point,
		"Factor":Factor,
		"Description":Description,
		"Price":Price
	}
	database.insert_row("COMBOS",data)

func insert_new_tag(Name:String,Value:String)->void:
	var data={
		"Name":Name,
		"Value":Value
	}
	database.insert_row("TAGS",data)

func insert_tag_to_card(idCard:int,idTag:int)->void:
	var data={
		"id_card":idCard,
		"id_tag":idTag
	}
	database.insert_row("CARD_TAG",data)

func insert_tag_to_combo(idCombo:int,idTag:int)->void:
	var data={
		"id_combo":idCombo,
		"id_tag":idTag
	}
	database.insert_row("COMBO_TAG",data)

func insert_card_to_playerCollection(newIDCard:int,oldCardID:int)->void:
	var data={
		"new_id_card":newIDCard,
		"old_id_card":oldCardID
	}
	database.insert_row("PLAYERS_CARD",data)
	pass

func insert_combo_to_playerCollection(newIDCOmbo:int,oldIDcombo:int)->void:
	var data={
		"new_id_combo":newIDCOmbo,
		"old_id_combo":oldIDcombo
	}
	database.insert_row("PLAYER_COMBO",data)
