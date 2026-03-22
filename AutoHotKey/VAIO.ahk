#Requires AutoHotkey v2.0

; _/ろ キーを右シフト
vkC1::RShift

; 変換キーをスペースに
sc079::Space

; \|_ をバックスペースに
SC07D::Backspace

; -------------------------
; 2. Mac風のカーソル移動
;    Alt + Left/Right  -> 単語移動
;    Alt + Backspace   -> 前の単語削除
; -------------------------
!Left::Send "^{Left}"
!Right::Send "^{Right}"
!Backspace::Send "^+{Left}{Backspace}"

; Shift付き
!+Left::Send "^+{Left}"
!+Right::Send "^+{Right}"

; -------------------------
; 3. Cmdっぽい操作を Alt ベースで再現
;    Macの Command 相当を Alt に寄せる
; -------------------------
!a::Send "^a"   ; 全選択
!c::Send "^c"   ; コピー
!v::Send "^v"   ; ペースト
!x::Send "^x"   ; カット
!z::Send "^z"   ; Undo
!+z::Send "^y"  ; Redo（Windows系）
!s::Send "^s"   ; 保存
!f::Send "^f"   ; 検索
!w::Send "^w"   ; タブ/ウィンドウを閉じる

; -------------------------
; 6. ブラウザ/タブ操作
;    Alt+T: 新規タブ
;    Alt+R: 再読み込み
;    Alt+Shift+[: 前のタブ
;    Alt+Shift+]: 次のタブ
; -------------------------
!t::Send "^t"
!r::Send "^r"
