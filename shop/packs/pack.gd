extends Node2D

var PackName:String
var price:int
var PackCards: Array
var ENERGY_TYPES = ["KI","PRANA","CHAKRA"]
var rng
var Name:Label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Name = get_node("Name")
	rng = RandomNumberGenerator.new()
	rng.randomize()
	
	PackName = ENERGY_TYPES[rng.randf_range(0,ENERGY_TYPES.size())]
	Name.text = PackName
	var id_cards = Sql.select_card_ids_by_tag_value([PackName])
	var tmp = []
	for i in id_cards:
		tmp.append(Sql.select_card_dy_id(i))
	for i in range(6):
		PackCards.append(tmp[rng.randf_range(0,tmp.size())])
		
	tmp.clear()	
	
	#var id_combo = Sql.select_combo_ids_by_tag('ENERGY',[PackName])
	#for i in id_combo:
		#tmp.append(Sql.select_combo_by_id(i))
	#for i in range(2):
		#PackCards.append(tmp[rng.randf_range(0,tmp.size())])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
