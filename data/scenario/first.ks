;一番最初に呼び出されるファイル

[title name="戦国ラブストーム（仮）"]

;キーコンフィグを有効化（Ctrl長押しスキップ・m/Space・ホイール等のキー/マウス操作を有効に）
;※以前は[stop_keyconfig]でOFFのままだったため、-aオプション以外のキー操作が全て効かなかった
[start_keyconfig]


;ティラノスクリプトが標準で用意している便利なライブラリ群
;コンフィグ、CG、回想モードを使う場合は必須
@call storage="tyrano.ks"

;ゲームで必ず必要な初期化処理はこのファイルに記述するのがオススメ

;環境光プラグイン（tsp-ambient-light）を読み込み
[plugin name="ambient_light"]

;立ち絵キャラクター定義を読み込み
@call storage="chara_def.ks"

;メッセージボックスは非表示
@layopt layer="message" visible=false

;最初は右下のメニューボタンを非表示にする
[hidemenubutton]

;タイトル画面へ移動
@jump storage="title.ks"

[s]


