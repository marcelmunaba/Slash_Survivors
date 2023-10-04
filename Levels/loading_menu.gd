extends Control
var tips = ["Tip : It costs 5 energy to attack. Use and time your attacks wisely!", 
			"Tip : Killing an enemy grants you a small amount of energy.",
			"Tip : It may be wise to stack powerups at the right time.",
			"Tip : You can attack while moving by using mouse left click.",
			"Tip : The commander has high attack damage but long windup time.",
			"Tip : Don't overspam your attacks.",
			"Tip : The damage powerup not only gives you bonus attack damage, but also increases your attack range!"]
var done = false
var index

func _ready():
	randomize()
	index = randi_range(0,tips.size()-1)
	$bg.play("default")
	$tip.text = tips[index]
	
func _process(_delta):
	$ProgressBar.value += 0.35
	if $Timer.time_left == 0 and $ProgressBar.value == 100:
		$loading.text = "Space / Left Click to Start"
		$loading.add_theme_font_size_override("font_size", 40)
		if !done:
			$flashing_timer.start()
			done = true
		
		if Input.is_action_pressed("attack"):
			get_tree().change_scene_to_file("res://Levels/level.tscn")


func _on_flashing_timer_timeout():
	if $loading.visible:
		$loading.visible = false
	else:
		$loading.visible = true
