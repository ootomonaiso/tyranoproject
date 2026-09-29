;================================================================================
; 多言語UI 動作見本（テンプレート）
;   目的：「背景は共通画像・文字はHTML＋data-i18n」の仕組みを実際に動かして見る。
;   試し方：どこかで  @jump storage="_example_i18n.ks"  すると開く。
;           JP / EN ボタンで全ラベルが即切り替わる（背景画像は差し替わらない）。
;   ここで使っている L() / applyI18n() / setLang() は lang.ks で定義済み。
;
;   本番の config.ks を作るときは、この *build_ui 内のHTMLを土台に、
;   各行の control 部へ既存の音量ボタン等を差し込んでいけばよい。
;================================================================================

[cm]
[hidemenubutton]

; --- 共通背景＋文字レイヤ(HTML)を丸ごと生成して .tyrano_base に載せる ---------
[iscript]
// 既存パネルがあれば消す（多重生成防止）
$('#ui_config_example').remove();

// 背景は .ui-screen--config（CSS側で共通画像を指定）。
// 文字は data-i18n を付けるだけ。値は applyI18n() が現在言語で埋める。
var html =
  '<div id="ui_config_example" class="ui-screen ui-screen--config">' +
    '<div class="cfg-panel">' +
      '<h2 class="cfg-title" data-i18n="cfg_title"></h2>' +
      '<div class="cfg-rows">' +
        '<div class="cfg-row"><div class="cfg-row__label" data-i18n="cfg_bgm"></div><div class="cfg-row__control ui-control">［音量ボタンをここに］</div></div>' +
        '<div class="cfg-row"><div class="cfg-row__label" data-i18n="cfg_se"></div><div class="cfg-row__control ui-control">［音量ボタンをここに］</div></div>' +
        '<div class="cfg-row"><div class="cfg-row__label" data-i18n="cfg_ch"></div><div class="cfg-row__control ui-control">［速度ボタンをここに］</div></div>' +
        '<div class="cfg-row"><div class="cfg-row__label" data-i18n="cfg_auto"></div><div class="cfg-row__control ui-control">［速度ボタンをここに］</div></div>' +
        '<div class="cfg-row"><div class="cfg-row__label" data-i18n="cfg_skip"></div><div class="cfg-row__control ui-control"><span class="ui-btn" data-lang-on>ON</span><span class="ui-btn" data-lang-off>OFF</span></div></div>' +
      '</div>' +
    '</div>' +
    '<div class="ui-topright">' +
      '<span class="ui-btn" data-setlang="ja">JP</span>' +
      '<span class="ui-btn" data-setlang="en">EN</span>' +
      '<span class="ui-btn" data-back data-i18n="cfg_back"></span>' +
    '</div>' +
  '</div>';

$('.tyrano_base').append(html);

// 現在言語で文字を流し込む
window.applyI18n('#ui_config_example');

// 言語切替ボタン
$('#ui_config_example [data-setlang]').on('click', function () {
  window.setLang($(this).attr('data-setlang'));   // sf.lang変更→applyI18nまで一括
});

// 戻る：パネルを消して *close へ
$('#ui_config_example [data-back]').on('click', function () {
  $('#ui_config_example').remove();
  TYRANO.kag.ftag.startTag('jump', { target: '*close' });
});
[endscript]

; パネル操作待ち（クリックでシナリオが進まないよう停止）
[s]

*close
[cm]
; 見本なのでタイトルへ戻す。本番では [awakegame] 等に置き換える。
@jump storage="title.ks"
