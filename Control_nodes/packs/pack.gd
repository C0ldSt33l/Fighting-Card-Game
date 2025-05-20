extends Control
@onready var Background : Panel = $Background
@onready var PackName : Label = $PackName

var objects : Array = []

var data := {}

var id: int:
	set(val): self.set_tag_val('id', val)
	get(): return self.get_tag_val('id')

var Name: String:
	set(val): self.set_tag_val('Name',"" if val == null else val)
	get(): return self.get_tag_val('Name') if self.get_tag_val('Name') != null else ""

var Description: String:
	set(val): self.set_tag_val('Description',"" if val == null else val)
	get():return self.get_tag_val('Description') if self.get_tag_val('Description') != null else ""
	
func set_tag_val(tag: String, val: Variant) -> void:
	self.data[tag] = val
	
func get_tag_val(tag: String) -> Variant:
	return self.data[tag] if self.has_tag(tag) else null
	
func add_tags(new_tags: Dictionary) -> void:
	self.data.merge(new_tags, true)

func has_tag(tag: String) -> bool:
	return self.data.keys().has(tag)
	
func return_all_tags()-> Dictionary:
	return data 

func add_objects()->void:
	var res = Sql.select_objects_in_pack_by_id(id)
	for i in res: 
		match i["Object_type"]:
			"BATTLE","UPGRADE","CONSUMABLE":
				for count in range(0,i["Count"]):
					objects.append(Sql.select_typed_card_by_id(i["Object_type"],i["id_object"]))
			"COMBO":
				for count in range(0,i["Count"]):
					objects.append(Sql.select_combo_by_id_with_tags(i["id_object"]))
			"TOTEM":
				print("totem")
	
