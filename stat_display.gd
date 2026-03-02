extends VBoxContainer

@onready var coin_display = $CurrencyDisplay
@onready var score_display = $ScoreDisplay

var coins: int = 69
var score: int = 420

func _process(_delta: float) -> void:
	#coins = str(global.coins)
	#score = str(global.current_score)
	update_text()
	
func _ready():
	update_text()
	
func update_text():
	coin_display.text = "COINS: " + str(coins)
	score_display.text = "SCORE: " + str(score)
