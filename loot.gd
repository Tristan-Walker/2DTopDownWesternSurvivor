extends Node3D

# Chacne for the loot to drop from enemy 
# Should vary by enemy  v test use v
@export var LOOT_DROP_CHANCE = 100
#@export var LOOT_DROP_CHANCE = 0

#Individual item chance relative to others
# For now it'll affect loot bag rarity
@export var LOOT_DROP_WEIGHT = [60,39,1]
# temp rarity implentattion 
# for later: determine loot first then determing bag colour
# Dictionary  "bag_Colour" : key in LOOT_DROP_WEIGHT
var bagRarityDict = {"brown":0, "cyan":1, "white":2}

var bagColourResourceDict = {
	"brown":"res://GameWithTristan/lootBagBrown.png", 
	"cyan" :"res://GameWithTristan/lootBagCyan.png",
	"white":"res://GameWithTristan/lootBagWhite.png" 
}

# keeps sum of dropweights below 100
func normalize_item_drop_weights():
	var sum = 0
	# force multiplier to be a float
	var multiplier = 1.0
	
	for key in LOOT_DROP_WEIGHT:
		sum += round(LOOT_DROP_WEIGHT[key])
	# if our sum is greater than 100 then we want then find the
	# multiplier that will bring it close to 100
	if sum > 100:
		multiplier = 100/sum

	for key in LOOT_DROP_WEIGHT:
		# First do the multiplier
		LOOT_DROP_WEIGHT[key] = multiplier * float(LOOT_DROP_WEIGHT[key])
		# if rounding it will make it zero (i.e. it was .4) then make it 1
		if LOOT_DROP_WEIGHT[key] > 0 && round(LOOT_DROP_WEIGHT[key]) == 0:
			LOOT_DROP_WEIGHT[key] = 1
		else:
			LOOT_DROP_WEIGHT[key] = round(LOOT_DROP_WEIGHT[key])


func enemy_drop():

	var drop = randi()%100
	
	if drop < LOOT_DROP_CHANCE:
		var lootList = []
		# putting each loot x amount of times into the loot list then randmly selceting 
		# one. X = loot's drop weight
		
		for key in bagRarityDict:
			var dictValue = bagRarityDict[key]
			
			for i in range(LOOT_DROP_WEIGHT[dictValue]):
				lootList.append(bagRarityDict[key])
		
		var lootBag = lootList[randi()%lootList.size()]
		
		#incomplete implement the get sprite of bag and drop from enemy death
