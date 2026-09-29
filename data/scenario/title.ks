
[cm]

@clearstack

;エンディングから[jump]でタイトルに戻った際、前景レイヤに残る全画面画像を消去
;（消さないと2周目で背景の上に前回の章クリア画像が残り「背景固定」になる）
[freeimage layer="0" time=0]
[freeimage layer="1" time=0]

@bg storage ="title.png" time=100
@wait time = 200

;タイトルBGM（爆音＝最大音量）。CG/回想/実績から戻った際に頭出しし直さないよう、
;既に同じ曲が鳴っている時は再生しない（current_bgm はエンジンが管理する再生中の曲名）。
[if exp="TYRANO.kag.stat.current_bgm !== 'Marginalia_INST.wav'"]
[playbgm storage="Marginalia_INST.wav" volume="100"]
[endif]

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
  // config/load は「開いてキャンセル→タイトルに戻る」場合があるためここでは残す。
  if (cls !== 't_config' && cls !== 't_load') {
    $('#title_menu').remove();
  }
  $('.' + cls).trigger('click');
});

// ロード画面で「実データのある」セーブスロットが選ばれた時だけタイトルHTMLメニューを除去。
//   ・t_load 押下では上記のとおり残しているため、ロード確定時にここで片付ける。
//   ・キャンセル（× menu_close）ではスロットを押さないので残り、タイトルに戻れる。
//   ・★空スロット（データ無し）はロードされずロード画面も閉じない。ここで消すと
//     ×を押した後にタイトルのボタンが消え「何も押せない」状態になるため、除去しない。
//     空スロットは日付テキストが空・サムネイル画像も無いので、それで判定する。
//   ・委譲＋名前空間つきで多重登録を防止。ゲーム中ロードでも #title_menu 不在で無害。
$(document).off('click.titleLoadClean').on('click.titleLoadClean', '.save_list_item', function () {
  var $slot = $(this);
  var hasData = $.trim($slot.find('.save_list_item_date').text()) !== '' ||
                $slot.find('.save_list_item_thumb img').length > 0;
  if (hasData) {
    $('#title_menu').remove();
  }
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
