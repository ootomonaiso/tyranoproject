;一番最初に呼び出されるファイル

[title name="戦国ラブストーム（仮）"]

;キーコンフィグを有効化（Ctrl長押しスキップ・m/Space・ホイール等のキー/マウス操作を有効に）
;※以前は[stop_keyconfig]でOFFのままだったため、-aオプション以外のキー操作が全て効かなかった
[start_keyconfig]


;ティラノスクリプトが標準で用意している便利なライブラリ群
;コンフィグ、CG、回想モードを使う場合は必須
@call storage="tyrano.ks"

;多言語UI基盤（言語テーブル L() / applyI18n() / setLang() を定義）
;※UIの文字はここの LANG_TABLE から供給する。詳細は lang.ks 冒頭のコメント参照。
@call storage="lang.ks"

;ゲームで必ず必要な初期化処理はこのファイルに記述するのがオススメ

;環境光プラグイン（tsp-ambient-light）を読み込み
[plugin name="ambient_light"]

;立ち絵キャラクター定義を読み込み
@call storage="chara_def.ks"

;ふりがな（ルビ）表示モードの初期化。未設定なら OFF。
;sf はシステム変数（セーブに依存せず全体で永続）。config画面でON/OFF切替。
;※キャラ名・屋号の初出ルビはこのモードとは無関係に常時表示（生[ruby]で記述）。
[if exp="typeof sf.rubymode === 'undefined'"]
[eval exp="sf.rubymode = false"]
[endif]

;メッセージボックスは非表示
@layopt layer="message" visible=false

;最初は右下のメニューボタンを非表示にする
[hidemenubutton]

;================================================================================
; 起動ロゴ（だおソフト）を縮小表示 → フェードイン→数秒保持→フェードアウト
;   見た目は ui_i18n.css の .boot-logo。サイズ調整は .boot-logo img の width。
;================================================================================
[iscript]
$('#boot_logo').remove(); // 多重生成の防止
$('.tyrano_base').append(
  '<div id="boot_logo" class="boot-logo"><img src="./data/image/logo.png" alt="DAO SOFT"></div>'
);
// 次フレームで表示クラス付与→CSSトランジションでフェードイン
requestAnimationFrame(function(){ $('#boot_logo').addClass('is-show'); });
[endscript]

;表示を保持（フェードイン0.6s＋余韻）
[wait time=2000]

;フェードアウトして除去
[iscript]
$('#boot_logo').removeClass('is-show');
setTimeout(function(){ $('#boot_logo').remove(); }, 650);
[endscript]
[wait time=650]

;タイトル画面へ移動
@jump storage="title.ks"

[s]


