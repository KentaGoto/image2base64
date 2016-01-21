#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

Gui, Add, Text, x30, 対象ファイル:
Gui, Add, Edit, x100 yp+0 vTarget w400,
Gui, Add, Button, gExec x465 yp+25, &実行
Gui, Add, Button, gButton終了 x420 yp+0, &終了
Gui, Show, , image2base64
return

;Main******************************************************************************************
Exec:
Gui, Submit, NoHide
SplitPath, Target, file, dir, ext, name_no_ext, drive

;フォルダ指定が空だったら警告を出す
if Target =
{
	MsgBox, 0x30, 警告, 画像ファイルを指定してください。
	return
}
;ドライブ直下だったら警告を出す
Else if (RegExMatch(Target, "i)^[a-zA-Z]:?\\?$"))
{
	MsgBox, 0x10, エラー！, ドライブ直下です。安全のため処理できません。
	return
}

Clipboard =
ClipWait,1
Clipboard = %Target%
;MsgBox, %Clipboard%
Sleep, 30

cmd = wperl image2base64.pl
Run, %cmd%

Sleep, 30

Clipboard_after = %Clipboard%

;処理後のメッセージ
MsgBox, 64, 完了, 処理が完了しました!`n画像ファイルを base64 にした文字列がクリップボードにコピーされています。

return
;**********************************************************************************************

;ウィンドウにフォルダがドロップされたときの処理
GuiDropFiles:
StringSplit, fn, A_GuiEvent, `n    ;フォルダを一つにする	
GuiControl, , Target, %fn1%        ;エディットボックスに一つめのフォルダ名を設定
return

;[終了]と[x]ボタン
Button終了:
GuiClose:
ExitApp