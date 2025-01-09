extends Node
class_name ScreenshotGrabber

@onready var camera = get_parent() as Camera3D

var ssCount : int = 1

func _ready():
	if not camera: return

	var dir = DirAccess.open("user://")
	dir.make_dir("screenshots")

func _input(event):
	if event.is_action("screenshot"):
		screenshot()

func screenshot():
	await RenderingServer.frame_post_draw

	var viewport = camera.get_viewport()
	var img = viewport.get_texture().get_image()
	img.save_png("user://screenshots/ss" + str(ssCount) + ".png")
	ssCount += 1