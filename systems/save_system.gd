# class_name SaveSystem
extends Node
## 저장 / 로드 관련 로직. 오토로드 아님.


#global_player_data.gd의 세이브 시스템은 두 가지 문제가 있습니다.
#첫째, var_to_str / str_to_var 조합으로 Dictionary를 직렬화합니다. 
# 이 방식은 타입 안전성이 없어서 세이브 구조가 게임 업데이트로 바뀌면 구 세이브 파일을 불러올 때 침묵하는 버그가 생기기 쉽습니다.
#둘째, load_game()에서 파일이 존재하지 않을 경우에 대한 오류 처리가 없어 FileAccess.open()이 null을 반환하면 곧장 크래시입니다.
#다음 프로젝트에서는 세이브 데이터 구조 자체를 Resource로 정의하고 
# ResourceSaver / ResourceLoader로 처리하거나, JSON 직렬화를 쓰더라도 버전 필드를 두고 마이그레이션 로직을 분리하는 걸 권장합니다.
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
