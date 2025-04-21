extends Button
class_name MultiplierActionButton

var action: 
	set(value):
		if value is Dictionary :
			if value.has("display_name"):
				text = value.get("display_name", "")
			elif value.has("name"):
				text = value.get("name", "")
				
			action = value
	get:
		action
