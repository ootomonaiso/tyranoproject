
[cm]

@clearstack

;エンディングから[jump]でタイトルに戻った際、前景レイヤに残る全画面画像を消去
;（消さないと2周目で背景の上に前回の章クリア画像が残り「背景固定」になる）
[freeimage layer="0" time=0]
[freeimage layer="1" time=0]

@bg storage ="title.png" time=100
@wait time = 200

*start

;メインメニュー：画面下部に横一列（ロゴ・キャラを避け、縮小ボタンを使用）
;ボタンは227x47。5個を中央寄せ（x=40,283,526,769,1012 / 間隔16px）、y=649
[button x=40 y=649 graphic="title/s/button_start.png" enterimg="title/s/button_start2.png"  target="gamestart" keyfocus="1"]
[button x=283 y=649 graphic="title/s/button_load.png" enterimg="title/s/button_load2.png" role="load" keyfocus="2"]
[button x=526 y=649 graphic="title/s/button_cg.png" enterimg="title/s/button_cg2.png" storage="cg.ks" keyfocus="3"]
[button x=769 y=649 graphic="title/s/button_replay.png" enterimg="title/s/button_replay2.png" storage="replay.ks" keyfocus="4"]
[button x=1012 y=649 graphic="title/s/button_config.png" enterimg="title/s/button_config2.png" role="sleepgame" storage="config.ks" keyfocus="5"]

;実績画面への入口（右上に小さく配置）
[button x=1033 y=20 graphic="title/s/button_achievement.png" enterimg="title/s/button_achievement2.png" storage="achievement.ks" keyfocus="6"]

[s]

*gamestart
;一番最初のシナリオファイルへジャンプする
@jump storage="scene1.ks"



