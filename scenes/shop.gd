extends Control

var current_item_id_selected: String
var discounted_percentage: float

func _ready() -> void:
	
	%CtrlInventoryGrid.inventory = GameStatus.current_inventory
	GameStatus.current_timeline = "in_shop"
	for item_id in GameStatus.items_to_sell[GameStatus.current_act]:
		print(item_id)
		if not GameStatus.items_data.has(item_id):
			continue
		var item = GameStatus.items_data[item_id]
		var btn  = DataButton.new()
		
		#btn.ignore_texture_size = true
		#btn.texture_normal  = tex
		#btn.texture_pressed = tex
		
		btn.size = Vector2(50, 75)
		
		btn.text = item["name"]
		btn.data = item_id
		btn.data_sended.connect(_on_data_sended)
		%ItemsContainer.add_child(btn)
		
func _on_data_sended(data)->void:
	current_item_id_selected = data
	
func _on_buy_btn_pressed() -> void:
	if current_item_id_selected && GameStatus.items_data.has(current_item_id_selected):
		var item = GameStatus.items_data[current_item_id_selected]
		var total_item_price = float(item["price"]) - (float(item["price"]) * discounted_percentage)
		if total_item_price <= GameStatus.current_gold:
			GameStatus.current_inventory.create_and_add_item(current_item_id_selected)
	else:
		print("Not enough gold!")

func _on_sell_btn_pressed() -> void:
	pass

func _on_haggle_btn_pressed() -> void:
	pass
