;共通初期化（メッセージウィンドウ・変数）

*start

[cm]
[clearfix]

;実績「金成屋、開店」を解除（新規ゲーム開始時）
[ach id="start_game"]

@showmenubutton

;メッセージウィンドウの設定（見た目はdata/system/custom_skin.cssの.message_outerで指定）
[position layer="message0" left=0 top=478 width=1280 height=230 page=fore visible=true]
[position layer=message0 page=fore margint="34" marginl="70" marginr="70" marginb="30"]
@layopt layer=message0 visible=true

;ロールボタン配置（金成屋版を踏襲。メッセージ枠より後に置いてクリックを奪われないようにする）
[button name="role_button" role="quicksave" graphic="button/qsave.png" enterimg="button/qsave2.png" x="40" y="690"]
[button name="role_button" role="quickload" graphic="button/qload.png" enterimg="button/qload2.png" x="140" y="690"]
[button name="role_button" role="save" graphic="button/save.png" enterimg="button/save2.png" x="240" y="690"]
[button name="role_button" role="load" graphic="button/load.png" enterimg="button/load2.png" x="340" y="690"]
[button name="role_button" role="auto" graphic="button/auto.png" enterimg="button/auto2.png" x="440" y="690"]
[button name="role_button" role="skip" graphic="button/skip.png" enterimg="button/skip2.png" x="540" y="690"]
[button name="role_button" role="backlog" graphic="button/log.png" enterimg="button/log2.png" x="640" y="690"]
[button name="role_button" role="fullscreen" graphic="button/screen.png" enterimg="button/screen2.png" x="740" y="690"]
[button name="role_button" role="sleepgame" graphic="button/sleep.png" enterimg="button/sleep2.png" storage="config.ks" x="840" y="690"]
[button name="role_button" role="window" graphic="button/close.png" enterimg="button/close2.png" x="1040" y="690"]
[button name="role_button" role="title" graphic="button/title.png" enterimg="button/title2.png" x="1140" y="690"]

;テキスト速度・改行待ちグリフ等はデフォルトのまま

;――変数初期化――
[eval exp="f.day1 = ''"]
[eval exp="f.day2 = ''"]
[eval exp="f.day3 = ''"]
[eval exp="f.day5 = ''"]
[eval exp="f.ikkawa = 0"]

@jump storage="prologue.ks"
