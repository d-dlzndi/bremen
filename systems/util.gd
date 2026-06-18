class_name Util
extends Node
## 글로벌하게 사용될 Util 함수. 모든 함수는 static으로 관리.


## static 함수 내에서 사용할 수 없는 get_tree() 대체.
static func get_main_tree() -> SceneTree:
	return Engine.get_main_loop() as SceneTree


## 시간을 기다린다
static func wait_time(_seconds: float) -> void:
	await get_main_tree().create_timer(_seconds).timeout


## 리스트 내의 모든 노드를 queue_free.
static func queue_free_all(_list: Array[Node] = []) -> void:
	for item in _list:
		item.queue_free()


## 특정 부모의 모든 child의 visible을 바꾼다.
static func set_visible_all_child(
		_parent: Node2D,
		_value: bool,
		_include_interval: bool = false,
) -> void:
	for child in _parent.get_children(_include_interval):
		child.visible = _value


## 화면의 중앙 백터를 리턴. (global position)
static func get_screen_center() -> Vector2:
	if get_main_tree():
		if get_main_tree().get_viewport():
			return get_main_tree().get_viewport().size * 0.5 * (Vector2.DOWN + Vector2.RIGHT)
	return Vector2.ZERO


# Get the screen position of a Node2D
static func get_screen_position_of_node(node: Node2D) -> Vector2:
	var canvas_position: Vector2 = node.get_canvas_transform().origin
	return canvas_position


## 부모(아마도 Area2D등) 밑에 있는 모든 자식 CollisionShape2D를 비/활성화.
static func set_child_collision2D_disable(parent: Node, value: bool) -> void:
	for c in parent.get_children():
		if c is CollisionShape2D:
			var col: CollisionShape2D = c as CollisionShape2D
			col.set_deferred("disabled", value)


## array의 중복값을 제거 후 리턴.
static func get_unique_array(array: Array) -> Array:
	var dict: Dictionary = { }
	for item: Object in array:
		dict[item] = null # 딕셔너리에 키로 추가 (중복 자동 제거)
	return dict.keys() # 고유한 키들만 배열로 반환


## 스크린샷 캡처 후 복사
static func take_screenshot_and_copy() -> String:
	# 1. 뷰포트에서 현재 화면 캡처
	var image: Image = get_main_tree().get_viewport().get_texture().get_image()

	# 2. 이미지를 PNG 형식으로 저장 (임시 파일 필요)
	var path := "user://"
	var time := Time.get_datetime_dict_from_system()
	var filename := "screenshot_%04d%02d%02d_%02d%02d%02d.png" % [
		time.year,
		time.month,
		time.day,
		time.hour,
		time.minute,
		time.second,
	]
	var temp_path := path + filename

	if OS.has_feature("web"):
		# 3. JavaScript를 사용하여 다운로드 실행
		var buffer := image.save_png_to_buffer()
		JavaScriptBridge.download_buffer(buffer, filename, "image/png")
	else:
		image.save_png(temp_path)
		DisplayServer.clipboard_set(ProjectSettings.globalize_path(path))

	print("화면이 캡처되어 클립보드에 경로가 복사되었습니다: " + path)
	return filename
