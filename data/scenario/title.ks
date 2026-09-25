
[cm]

@clearstack
@bg storage ="mori_yoru.png" time=100
@wait time = 200

*start

[image layer="1" page="fore" visible=true left=0 top=0 storage="title_text.png"]

[button x=135 y=320 graphic="title/button_start.png" enterimg="title/button_start2.png"  target="gamestart" keyfocus="1"]
[button x=135 y=400 graphic="title/button_load.png" enterimg="title/button_load2.png" role="load" keyfocus="2"]
[button x=135 y=480 graphic="title/button_cg.png" enterimg="title/button_cg2.png" storage="cg.ks" keyfocus="3"]
[button x=135 y=560 graphic="title/button_replay.png" enterimg="title/button_replay2.png" storage="replay.ks" keyfocus="4"]
[button x=135 y=640 graphic="title/button_config.png" enterimg="title/button_config2.png" role="sleepgame" storage="config.ks" keyfocus="5"]

;実績画面への入口
[button x=870 y=628 graphic="title/button_achievement.png" enterimg="title/button_achievement2.png" storage="achievement.ks" keyfocus="6"]

[s]

*gamestart
;一番最初のシナリオファイルへジャンプする
@jump storage="scene1.ks"



