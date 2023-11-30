extends Timer



func _on_DOSChild_timeout():
	get_parent().paused = false
	get_parent().get_node("CanvasLayer/ALERT/textbcknd/Label").visible = false
