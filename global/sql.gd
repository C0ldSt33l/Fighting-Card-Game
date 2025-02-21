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

func select_cards_from_db_by_tag_list(TagList:Array) -> Array: #return all cards with tag 
	var tag_list = ""
	for tag in TagList:
		tag_list +="'" + tag + "',"
		tag_list = tag_list.substr(0,tag_list.length() - 1)
	 
	database.query("
	SELECT c.*, t.name,t.value 
	FROM CARDS c 
	JOIN CARD_TAG ct ON c.id = ct.id_card
	JOIN TAGS t ON t.id = ct.id_tag 
	WHERE t.name IN ('" + tag_list + "')")
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
