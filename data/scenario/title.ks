
[cm]

@clearstack

;エンディングから[jump]でタイトルに戻った際、前景レイヤに残る全画面画像を消去
;（消さないと2周目で背景の上に前回の章クリア画像が残り「背景固定」になる）
[freeimage layer="0" time=0]
[freeimage layer="1" time=0]

@bg storage ="title.png" time=100
@wait time = 200

*start

;================================================================================
; ネイティブボタン（透明化）：実際の動作はこれが担当。見た目はHTML側。
;   name の1つ目 t_native でCSS透明化、2つ目でHTMLから呼ぶ用のクラスを付与。
;================================================================================
[button name="t_native,t_start"       graphic="title/s/button_start.png"       target="*gamestart" x=40   y=649]
[button name="t_native,t_load"        graphic="title/s/button_load.png"        role="load"         x=283  y=649]
[button name="t_native,t_cg"          graphic="title/s/button_cg.png"          storage="cg.ks"     x=526  y=649]
[button name="t_native,t_replay"      graphic="title/s/button_replay.png"      storage="replay.ks" x=769  y=649]
[button name="t_native,t_config"      graphic="title/s/button_config.png"      role="sleepgame" storage="config.ks" x=1012 y=649]
[button name="t_native,t_achievement" graphic="title/s/button_achievement.png" storage="achievement.ks" x=1033 y=20]

;================================================================================
; 和風HTMLメニューを生成して重ねる（背景 title.png はそのまま見せる）
;================================================================================
[iscript]

// 多重生成の防止
$('#title_menu').remove();

var html =
  '<div id="title_menu" class="ui-screen ui-screen--title">' +
    '<div class="title-menu">' +
      '<span class="ui-btn title-btn" data-native="t_start"  data-i18n="title_start"></span>' +
      '<span class="ui-btn title-btn" data-native="t_load"   data-i18n="title_load"></span>' +
      '<span class="ui-btn title-btn" data-native="t_cg"     data-i18n="title_cg"></span>' +
      '<span class="ui-btn title-btn" data-native="t_replay" data-i18n="title_replay"></span>' +
      '<span class="ui-btn title-btn" data-native="t_config" data-i18n="title_config"></span>' +
    '</div>' +
    '<div class="title-topright">' +
      '<span class="ui-btn title-btn" data-native="t_achievement" data-i18n="title_achievement"></span>' +
      '<span class="cfg-toggle title-lang">' +
        '<span class="ui-btn" data-setlang="ja">日本語</span>' +
        '<span class="ui-btn" data-setlang="en">English</span>' +
      '</span>' +
    '</div>' +
  '</div>';

$('.tyrano_base').append(html);

// 現在言語で全ラベルを流し込む
window.applyI18n('#title_menu');

// 言語ハイライト
var hlLang = function () {
  $('#title_menu [data-setlang]').removeClass('is-active');
  $('#title_menu [data-setlang="' + sf.lang + '"]').addClass('is-active');
};
hlLang();

// メニュー押下 → 対応する透明ネイティブボタンを実クリック（挙動は従来と同一）
$('#title_menu [data-native]').on('click', function () {
  var cls = $(this).attr('data-native');
  // 画面遷移するボタン（config/load以外）はオーバーレイを先に除去して残留を防ぐ
  if (cls !== 't_config' && cls !== 't_load') {
    $('#title_menu').remove();
  }
  $('.' + cls).trigger('click');
});

// 言語切替（タイトルからでも切替可能）
$('#title_menu [data-setlang]').on('click', function () {
  window.setLang($(this).attr('data-setlang')); // sf.lang変更→applyI18n
  hlLang();
});

[endscript]

[s]

*gamestart
;オーバーレイを片付けてから最初のシナリオへ
[iscript]
$('#title_menu').remove();
[endscript]
@jump storage="scene1.ks"
