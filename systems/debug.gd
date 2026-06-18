class_name Debug
extends Node
## 디버깅을 위해 사용되는 모든 코드 모음.
## static func만 선언.


@warning_ignore("untyped_declaration")
## 무엇이든 print로 출력.
static func log(...args):
	if OS.is_debug_build():
		print(args)
