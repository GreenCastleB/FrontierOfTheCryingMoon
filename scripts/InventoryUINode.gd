extends Control

# The Inventory UI Node

## 0.0 is hidden, 1.0 is shown.
@export_range(0.0,1.0) var progress:float = 1.0:
	set(newVal):
		progress = newVal;
		#%MainContainer.visible = (progress == 1.0);
		%Background.set_deferred("custom_minimum_size", Vector2(roundi(102 * progress), 0));
		self.set_deferred("custom_minimum_size", Vector2(roundi(102 * progress), 0));
