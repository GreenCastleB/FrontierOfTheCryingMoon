extends MarginContainer

# The Main Node

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("ui_right")):
		printt("MainNode ::", "SHOW DIALOG");
		%DialogUI.show();
		%Anim.play("ShowDialog");
		await %Anim.animation_finished;
		%InventoryUI.hide();
	if (event.is_action_pressed("ui_left")):
		printt("MainNode ::", "HIDE DIALOG");
		%InventoryUI.show();
		%Anim.play("HideDialog");
		await %Anim.animation_finished;
		%DialogUI.hide();
