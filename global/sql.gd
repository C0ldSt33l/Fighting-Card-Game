extends Node

var database : SQLite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	database = SQLite.new()
	database.path = "res://DB/_Config.db"
	database.open_db()
	pass # Replace with function body.

func select_Smth(query:String)-> Array:
	database.query(query)
	
	return database.query_result

func select_tag_cards(CardID: int,type:String) -> Array: #type: UPGRADE,BUTTLE,CONSUMABLE
	database.query("
	select t.*
	from TAGS t
	join CARD_TAGS ct on ct.id_tag = t.id
	where ct.id_card = " + str(CardID)+
	" AND ct.type_card = '"+ type + "'")
	return database.query_result

func select_card_ids_by_tag_name(tag_name:Array)->Array:
	var value = "'" + "', '".join(tag_name) + "'"
	
	var query ="
	SELECT ct.id_card
	FROM card_tag ct 
	JOIN TAGS t ON ct.id_tag = t.id 
	WHERE t.Name IN( "+value+")" 
	
	database.query(query)
	var result = []
	for row in database.query_result:
		result.append(row["id_card"])
	return result
	
func select_card_ids_by_tag_type(tag_type:String)->Array:
	var query = "
	SELECT ct.id_card, ct.Type_card
	FROM card_tags ct
	JOIN tags t on ct.id_tag = t.id
	WHERE t.Type = '"+tag_type+"'" 
	
	database.query(query)
	var result = []
	for row in database.query_result:
		result.append(row["id_card"])
	return result
	
func select_all_type_cards_with_tags(type:String) -> Array:
	var tmp = []
	var cards_with_tags = []
	match type:
		'BATTLE':
			tmp = select_battle_cards()
		'UPGRADE':
			tmp = select_upgrade_cards()
		'CONSUMABLE':
			tmp = select_consumable_cards()
			
	for card in tmp:
		card['TypeCard'] = type
		var tags = select_tag_cards(card.id,type)
		
		cards_with_tags.append({
			"card":card,
			"tags":tags
		})
	return cards_with_tags
	
func select_battle_cards()->Array:
	database.query("select * from BATTLE_CARDS")
	return database.query_result

func select_battle_card_dy_id(id:int)->Array:
	database.query("select c.* from BATTLE_CARDS c where c.id = "+str(id))
	return database.query_result

func select_upgrade_cards()->Array:
	database.query("select * from UPGRADE_CARDS")
	return database.query_result

func select_upgrade_card_dy_id(id:int)->Array:
	database.query("select c.* from UPGRADE_CARDS c where c.id = "+str(id))
	return database.query_result

func select_consumable_cards()->Array:
	database.query("select * from CONSUMABLE_CARDS")
	return database.query_result

func select_consumable_card_dy_id(id:int)->Array:
	database.query("select c.* from CONSUMABLE_CARDS c where c.id = "+str(id))
	return database.query_result

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
