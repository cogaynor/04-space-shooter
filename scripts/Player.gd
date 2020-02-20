extends KinematicBody2D

export var health = 150
export var score = 0
export var margin = 5
export var y_range = 250
export var acceleration = 0.2

var velocity = Vector2(0,0)

onready var VP = get_viewport_rect().size

onready var laserline = load("res://Scenes/LaserLine.tscn")


signal health_changed
signal score_changed


func _ready():
	emit_signal("health_changed")
	emit_signal("score_changed")

func change_health(h):
	health += h
	emit_signal("health_changed")
	if health <= 0:
		die()

func  change_score(s):
	score += s
	emit_signal("score_changed")
	victory()

func health_changed(h):
	health += h
	emit_signal("health_changed")
	if health <= 0:
		die()

func score_changed(s):
	score += s
	emit_signal("score_changed")

func victory():
	if score >= 500:
		get_tree().change_scene("res://Scenes/Victory.tscn")

func die():
	queue_free()
	get_tree().change_scene("res://Scenes/GameOver.tscn")

func _physics_process(delta):
	if Input.is_action_pressed("Fire"):
		var b = laserline.instance()
		b.position = position
		b.position.y -= 25
		get_node("/root/Game/Laser").fire(b)

	if Input.is_action_pressed("Left"):
		velocity.x -= acceleration
	if Input.is_action_pressed("Right"):
		velocity.x += acceleration
	if Input.is_action_pressed("Up"):
		velocity.y -= acceleration
	if Input.is_action_pressed("Down"):
		velocity.y += acceleration
	
	if position.x < margin:
		velocity.x = 0
		position.x = margin
	if position.x > VP.x - margin:
		velocity.x = 0
		position.x = VP.x - margin
	if position.y < VP.y - y_range:
		velocity.y = 0
		position.y = VP.y - y_range
	if position.y > VP.y - margin:
		velocity.y = 0
		position.y = VP.y - margin
	
	var collision = move_and_collide(velocity)
