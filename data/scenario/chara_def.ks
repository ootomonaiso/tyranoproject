;=============================================================
; 立ち絵キャラクター定義（起動時に first.ks から @call される）
; 朱雀は主人公（一人称）のため立ち絵なし
;=============================================================

;--- 表示位置・サイズ（1280x720 想定 / 上半身が見えるよう頭を上寄せ） ---
; koyuki/maki : 元画像 2:3 → 表示 667x1000
; tsubasa     : 元画像 約0.51:1 → 表示 513x1000

;=============== 小雪 (koyuki) ===============
[chara_new name="koyuki" jname="小雪" storage="chara/koyuki/normal.png" width=667 height=1000]
[chara_face name="koyuki" face="normal" storage="chara/koyuki/normal.png"]
[chara_face name="koyuki" face="smile"  storage="chara/koyuki/smile.png"]
[chara_face name="koyuki" face="think"  storage="chara/koyuki/think.png"]
[chara_face name="koyuki" face="shy"    storage="chara/koyuki/shy.png"]

;=============== 真姫 (maki) ===============
[chara_new name="maki" jname="真姫" storage="chara/maki/normal.png" width=667 height=1000]
[chara_face name="maki" face="normal"    storage="chara/maki/normal.png"]
[chara_face name="maki" face="smile"     storage="chara/maki/smile.png"]
[chara_face name="maki" face="laugh"     storage="chara/maki/laugh.png"]
[chara_face name="maki" face="wink"      storage="chara/maki/wink.png"]
[chara_face name="maki" face="surprised" storage="chara/maki/surprised.png"]
[chara_face name="maki" face="serious"   storage="chara/maki/serious.png"]

;=============== 椿紗 (tsubasa) ===============
[chara_new name="tsubasa" jname="椿紗" storage="chara/tsubasa/normal.png" width=513 height=1000]
[chara_face name="tsubasa" face="normal"    storage="chara/tsubasa/normal.png"]
[chara_face name="tsubasa" face="smile"     storage="chara/tsubasa/smile.png"]
[chara_face name="tsubasa" face="laugh"     storage="chara/tsubasa/laugh.png"]
[chara_face name="tsubasa" face="angry"     storage="chara/tsubasa/angry.png"]
[chara_face name="tsubasa" face="sad"       storage="chara/tsubasa/sad.png"]
[chara_face name="tsubasa" face="shy"       storage="chara/tsubasa/shy.png"]
[chara_face name="tsubasa" face="surprised" storage="chara/tsubasa/surprised.png"]

;=============================================================
; 入場マクロ：他キャラを消して指定キャラを中央に表示（話者切替時に使用）
; %face で表情指定（省略時 normal）
;=============================================================
[macro name="koyuki_in"]
[chara_hide_all time=0]
[chara_show name="koyuki" face="%face|normal" left=307 top=80 width=667 height=1000 time=300]
[endmacro]

[macro name="maki_in"]
[chara_hide_all time=0]
[chara_show name="maki" face="%face|normal" left=307 top=80 width=667 height=1000 time=300]
[endmacro]

[macro name="tsubasa_in"]
[chara_hide_all time=0]
[chara_show name="tsubasa" face="%face|normal" left=383 top=80 width=513 height=1000 time=300]
[endmacro]

;=============================================================
; 複数立ち絵用：左/中/右に配置（他キャラを消さない）
;   真姫=左, 椿紗=右, 小雪=中央(3人時)／左(椿紗と2人時)
;   %face で表情指定（省略時 normal）
;=============================================================
[macro name="maki_l"]
[chara_show name="maki" face="%face|normal" left=20 top=80 width=667 height=1000 time=300]
[endmacro]

[macro name="tsubasa_r"]
[chara_show name="tsubasa" face="%face|normal" left=670 top=80 width=513 height=1000 time=300]
[endmacro]

[macro name="koyuki_c"]
[chara_show name="koyuki" face="%face|normal" left=307 top=80 width=667 height=1000 time=300]
[endmacro]

[macro name="koyuki_l"]
[chara_show name="koyuki" face="%face|normal" left=20 top=80 width=667 height=1000 time=300]
[endmacro]

[macro name="koyuki_r"]
[chara_show name="koyuki" face="%face|normal" left=595 top=80 width=667 height=1000 time=300]
[endmacro]

[return]
