extends Sprite


func _ready():
#	$Vanish_Timer.start()
	pass

func _on_double_fire_rate_body_entered(body):
	queue_free()



func _on_Vanish_Timer_timeout():
	queue_free()
