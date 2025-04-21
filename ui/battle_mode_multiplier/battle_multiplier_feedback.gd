extends Control
class_name BattleMultiplierFeedbackContainer

func _ready() -> void:
	hide()

func change_correct_label_text(text: String)->void:
	%CorrectLabel.text = text

func change_correct_label_font_color(color: Color)->void:
	%CorrectLabel.set("theme_override_colors/font_color", color)

func change_answer_label_text(text: String)->void:
	%AnswerLabel.text = text

func change_multiplier_applied_text(text: String)->void:
	%MultiplierAppliedLabel.text = text
