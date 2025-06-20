class_name EnemyData

var name: String
var image: Texture2D
var required_score: int
var constraints: Array[Effect]
#TODO: add type from Step part
var reward = null

func _init(
    name: String,
    image: Texture2D,
    required_score: int,
    constraints: Array[Effect],
    reward = null
) -> void:
    self.name = name
    self.image = image
    self.required_score = required_score
    self.constraints = constraints
    self.reward = reward