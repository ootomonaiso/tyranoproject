;================================================================================
; 免責事項（起動時）
;   first.ks から起動ロゴの直前に @call storage="disclaimer.ks" で呼び出す。
;   ・見た目は ui_i18n.css の .ui-screen--disclaimer / .disc-card（画像なし・言語共通）
;   ・文字は data-i18n / data-i18n-html で lang.ks の LANG_TABLE から供給（JP/EN共通）
;   ・「同意する」を押すまで先へ進めない（背面クリックはカードが塞ぐ）
;   ・「同意しない」を押すと拒否メッセージに差し替え、以降は進行不可
;   ※毎起動表示。一度きりにしたい場合は first.ks 側の @call を sf フラグで囲む。
;================================================================================

;================================================================================
; 画面（HTML）を生成して .tyrano_base に載せる
;================================================================================
[iscript]

// 多重生成の防止（再入場しても1つだけ）
$('#disclaimer_screen').remove();

var html =
  '<div id="disclaimer_screen" class="ui-screen ui-screen--disclaimer">' +
    '<div class="disc-card">' +
      // 右上の言語トグル（日本語/English 即切替）。config の #cfgLang と同じ流儀。
      '<div class="disc-lang" id="discLang">' +
        '<span class="ui-btn" data-val="ja">日本語</span>' +
        '<span class="ui-btn" data-val="en">English</span>' +
      '</div>' +
      '<h2 class="disc-title" data-i18n="disc_title"></h2>' +
      '<div class="disc-body" data-i18n-html="disc_body"></div>' +
      '<p class="disc-q" data-i18n="disc_q"></p>' +
      '<div class="disc-actions">' +
        '<span class="ui-btn" id="discYes" data-i18n="disc_yes"></span>' +
        '<span class="ui-btn" id="discNo"  data-i18n="disc_no"></span>' +
      '</div>' +
    '</div>' +
  '</div>';

$('.tyrano_base').append(html);

// 現在言語で全ラベルを流し込む（本文は data-i18n-html で <br> を活かす）
window.applyI18n('#disclaimer_screen');

// 現在言語のトグルをハイライト
var discHiLang = function () {
  $('#discLang .ui-btn').removeClass('is-active');
  $('#discLang .ui-btn[data-val="' + sf.lang + '"]').addClass('is-active');
};
discHiLang();

// --- 言語切替：sf.lang を変えてこの画面のラベルを即差し替え ---
$('#discLang .ui-btn').on('click', function (e) {
  e.preventDefault();
  e.stopPropagation();
  window.setLang($(this).attr('data-val')); // sf.lang変更→applyI18n（画面全体）
  window.applyI18n('#disclaimer_screen');   // 念のためこの画面も明示的に反映
  discHiLang();
});

// --- 同意する：パネルを消して先へ進む ---
//   config の「戻る」と同様、クリックがメッセージ送りへ伝播しないよう
//   伝播を止め、復帰は次tickへ遅延させる。
//   ★ここで音声ロック(AudioContext suspended)を解除しておく。
//     TyranoScript は Howler の自動解除を切り、ユーザー操作で解除する仕様だが、
//     上の stopPropagation でこのクリックがエンジンの解除処理に届かない。
//     解除しないと起動ロゴの [playse] が再生ロック待ちでループ停止し、
//     「クリックしないとロゴから先へ進まない」不具合になる。
//   ★音声アンロックはエンジン自身の kag.readyAudio() で行う。
//     TyranoScript は信頼済みクリック時に readyAudio() を呼んで
//     kag.tmp.ready_audio=true にし、無音を1発鳴らして AudioContext を解除する。
//     ところが上の stopPropagation でこのクリックがエンジンのハンドラに届かず
//     readyAudio() が呼ばれない → ready_audio が false のままで、起動ロゴの
//     [playse] がアンロック待ちで停止＝「ロゴ表示後クリックしないと音が鳴らない／
//     先へ進まない」不具合になっていた。ここで直接呼んで確実に解除する。
$('#discYes').on('click', function (e) {
  e.preventDefault();
  e.stopPropagation();
  try {
    // 信頼済みユーザー操作内なので、ここで呼べば無音再生による解除が有効。
    if (TYRANO.kag.tmp.ready_audio !== true && typeof TYRANO.kag.readyAudio === 'function') {
      TYRANO.kag.readyAudio();
    }
  } catch (err) {}
  setTimeout(function () {
    TYRANO.kag.ftag.startTag('jump', { target: '*disc_done' });
  }, 0);
});

// --- 同意しない：拒否メッセージに差し替え、以降は進行不可 ---
$('#discNo').on('click', function (e) {
  e.preventDefault();
  e.stopPropagation();
  var $card = $('#disclaimer_screen .disc-card');
  $card.html(
    '<h2 class="disc-title" data-i18n="disc_title"></h2>' +
    '<div class="disc-body disc-deny" data-i18n="disc_deny"></div>'
  );
  window.applyI18n('#disclaimer_screen');
});

[endscript]

; 同意待ち
[s]

;================================================================================
; 「同意する」後：画面を片付けて呼び出し元へ復帰
;================================================================================
*disc_done
[cm]

[iscript]
$('#disclaimer_screen').remove();
[endscript]

[return]
