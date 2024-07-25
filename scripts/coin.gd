extends Area2D

func _on_body_entered(body):
	print("Coin Collected!")
	queue_free()
