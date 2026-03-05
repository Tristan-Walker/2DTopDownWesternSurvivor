extends Node3D

# Chacne for the loot to drop from enemy 
# Should vary by enemy  v test use v
@export var LOOT_DROP_CHANCE = 100
#@export var LOOT_DROP_CHANCE = 0

#Individual item chance relative to others
# For now it'll affect loot bag rarity
@export var LOOT_DROP_WEIGHT = [0.6,0.39,0.01]
# temp rarity implentattion 
# for later: determine loot first then determing bag colour
# Dictionary  "bag_Colour" : key in LOOT_DROP_WEIGHT
var bagRarityDict = {"brown":0, "cyan":1, "white":2}

func _test()->void:
	for key in bagRarityDict:
		print(bagRarityDict[key]["position"])
