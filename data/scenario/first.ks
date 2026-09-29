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

;================================================================================
; 「タイトルへ」(role="title") の遷移先を修正
;   TyranoScript標準の kag.backTitle() は location.href="./index.html" で
;   ページ全体を再読込する＝first.ks が最初から再実行され、免責事項と起動ロゴまで
;   戻ってしまう。確認ダイアログは残したまま、遷移先を title.ks への[jump]に差し替える。
;   （エンディングの「タイトルへ戻る」は元々[jump storage="title.ks"]なので影響なし）
;================================================================================
[iscript]
if (typeof TYRANO !== 'undefined' && TYRANO.kag) {
  TYRANO.kag.backTitle = function () {
    $.confirm($.lang('go_title'), function () {
      TYRANO.kag.ftag.startTag('jump', { storage: 'title.ks', target: '' });
    });
  };
}
[endscript]

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
; 音声の先読み（起動時）— ロゴSE／タイトルBGMを裏でダウンロードしておく。
;   ・目的：初回のタイトルBGMが読み込み待ちで途切れる／頭が欠けるのを防ぐ。
;   ・wait="false"（非ブロッキング）なので、この間も免責事項はすぐ表示される。
;     免責の閲覧時間＋起動ロゴ表示中に26MBのBGMを読み込み切る狙い。
;   ・パスは [playbgm]/[playse] が実際に使う src（./data/bgm・./data/sound）と一致
;     させること。一致すれば preload_audio_map が再利用され、再取得なしで即再生される。
;================================================================================
[preload storage="data/bgm/Marginalia_INST.wav" wait="false"]
[preload storage="data/sound/daosoft-top001.wav" wait="false"]

;================================================================================
; 免責事項（起動時）— 起動ロゴより前に表示し、同意するまで進めない
;   見た目・文言は disclaimer.ks / ui_i18n.css / lang.ks を参照。
;================================================================================
@call storage="disclaimer.ks"

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

;ロゴ表示に合わせてブランドSEを一度だけ鳴らす（爆音＝最大音量）
[playse storage="daosoft-top001.wav" volume="100"]

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


