#Requires AutoHotkey v2.0

; _/ろ キーを右シフト
vkC1::RShift

; 変換キーをスペースに
sc079::Space

; カタカナひらがなローマ字キーを F14 に → Google 日本語入力の「無変換キーでIMEをオンにする」設定と合わせるため
sc070::Send("{F14}")

; 無変換キーを F15 に→ Google 日本語入力の「変換キーでIMEをオフにする」設定と合わせるため
sc07B::Send("{F15}")

; ￥| を\|_に
sc07D::vkDC

; ]}む キーをエンターに
vkDC::Enter

; CapsLock 単体は利用しない
SetCapsLockState("AlwaysOff")

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
sc07B & a::Send "^a"   ; 全選択
sc07B & c::Send "^c"   ; コピー
sc07B & v::Send "^v"   ; ペースト
sc07B & x::Send "^x"   ; カット
sc07B & z::Send "^z"   ; Undo
sc07B & s::Send "^s"   ; 保存
sc07B & f::Send "^f"   ; 検
sc07B & w::Send "^w"   ; タブ/ウィンドウを閉じる
; +sc07B & z::Send("^y")  ; Redo（Windows系）

; -------------------------
; 6. ブラウザ/タブ操作
;    Alt+T: 新規タブ
;    Alt+R: 再読み込み
;    Alt+Shift+[: 前のタブ
;    Alt+Shift+]: 次のタブ
; -------------------------
!t::Send "^t"
!r:: Send "^r"

; -------------------------
; 7. CapsLock を修飾キーとして活用
;   CapsLock + a: 行頭
;   CapsLock + e: 行末
;   CapsLock + k: 行削除
; -------------------------
CapsLock & a::Send "{Home}"
CapsLock & e::Send "{End}"
CapsLock & k::Send "+{End}{Backspace}"
