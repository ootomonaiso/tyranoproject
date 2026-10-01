;================================================================================
; 多言語UI 基盤（言語テーブル＋ヘルパ）
;   first.ks から @call storage="lang.ks" で最初に一度だけ読み込む。
;
; 使い方は2通り。どちらも同じ LANG_TABLE を参照する。
;   (A) Tyranoタグ内で1文字列を引く：  [glink text="&L('cfg_back')" ...]
;   (B) HTML/CSSで組んだUIに一括流し込む： <span data-i18n="cfg_bgm"></span>
;                                          → applyI18n() で全部埋まる
;
; 言語を足すとき      … LANG_TABLE に 'zh': {...} のように1ブロック足すだけ
; 文字列を足すとき    … 各言語ブロックに同じキーを足すだけ（キーは画面横断で一意）
; 現在言語            … sf.lang（sf=システム変数。セーブに依存せず永続）
;================================================================================
[iscript]

// 現在言語（未設定なら日本語）
if (typeof sf.lang === 'undefined') { sf.lang = 'ja'; }

// --- UI文字列テーブル --------------------------------------------------------
//   キーは「画面_項目」で一意に。日本語(ja)を正とし、他言語は同じキーを揃える。
//   ここに無い言語・キーは自動で ja にフォールバックする（下の L() 参照）。
window.LANG_TABLE = {
  ja: {
    // --- タイトル ---
    title_start:  'はじめから',
    title_load:   'つづきから',
    title_cg:     'CG',
    title_replay: '回想',
    title_config: '設定',
    title_achievement: '実績',
    // --- コンフィグ ---
    cfg_title:    '設定',
    cfg_bgm:      'BGM音量',
    cfg_se:       '効果音',
    cfg_ch:       'テキスト速度',
    cfg_auto:     'オート速度',
    cfg_skip:     '未読スキップ',
    cfg_on:       'ON',
    cfg_off:      'OFF',
    cfg_ruby:     'ふりがな表示',
    cfg_lang:     '言語',
    cfg_back:     '戻る',
    // --- 共通 ---
    common_close: '閉じる',
    // --- ゲーム中メニュー（☰）---
    menu_title:   'メニュー',
    menu_save:    'セーブ',
    menu_load:    'ロード',
    menu_hide:    'メッセージを隠す',
    menu_skip:    'スキップ',
    menu_totitle: 'タイトルへ',
    // --- セーブ/ロード/バックログ画面 ---
    scr_save:     'セーブ',
    scr_load:     'ロード',
    scr_backlog:  '既読ログ',
    scr_nodata:   'データなし',
    // --- 実績 ---
    ach_title:    '実績',
    ach_unlocked: '解除',
    ach_locked:   '？？？',
    ach_toast:    '実績を解除',
    // --- 免責事項（起動時）---
    disc_title:   '免責事項',
    // ↓成人向け（18禁）の文言はいったん省略。復活させる場合は本文の先頭に戻す：
    //   '本作には成人向け（18禁）の表現が含まれます。<br>また' を disc_body の頭に付ける
    disc_body:    '本作はフィクションであり、登場する人物・団体・名称・出来事はすべて架空のものです。本作のご利用によって生じたいかなる損害についても、制作者は一切の責任を負いかねます。',
    disc_q:       '上記の内容に同意しますか？',
    disc_yes:     '同意する',
    disc_no:      '同意しない',
    disc_deny:    '内容にご同意いただけない場合、本作はご利用いただけません。ブラウザ（またはアプリ）を閉じてください。'
  },
  en: {
    // --- Title ---
    title_start:  'New Game',
    title_load:   'Continue',
    title_cg:     'CG Gallery',
    title_replay: 'Replay',
    title_config: 'Config',
    title_achievement: 'Achievements',
    // --- Config ---
    cfg_title:    'Config',
    cfg_bgm:      'BGM Volume',
    cfg_se:       'Sound Effects',
    cfg_ch:       'Text Speed',
    cfg_auto:     'Auto Speed',
    cfg_skip:     'Skip Unread',
    cfg_on:       'ON',
    cfg_off:      'OFF',
    cfg_ruby:     'Furigana',
    cfg_lang:     'Language',
    cfg_back:     'Back',
    // --- Common ---
    common_close: 'Close',
    // --- In-game menu (☰) ---
    menu_title:   'Menu',
    menu_save:    'Save',
    menu_load:    'Load',
    menu_hide:    'Hide Text',
    menu_skip:    'Skip',
    menu_totitle: 'To Title',
    // --- Save/Load/Backlog screens ---
    scr_save:     'Save',
    scr_load:     'Load',
    scr_backlog:  'Backlog',
    scr_nodata:   'No Data',
    // --- Achievements ---
    ach_title:    'Achievements',
    ach_unlocked: 'Unlocked',
    ach_locked:   '???',
    ach_toast:    'Achievement Unlocked',
    // --- Disclaimer (at startup) ---
    disc_title:   'Disclaimer',
    // Adult (18+) wording omitted for now. To restore, prepend to disc_body:
    //   'This game contains adult (18+) content.<br>' + change 'This game is' -> 'This game is also'
    disc_body:    'This game is a work of fiction; all characters, organizations, names, and events are fictional. The creators assume no responsibility whatsoever for any damages arising from the use of this software.',
    disc_q:       'Do you agree to the above?',
    disc_yes:     'I Agree',
    disc_no:      'I Do Not Agree',
    disc_deny:    'If you do not agree, you may not use this game. Please close this browser (or app).'
  }
};

// --- 1文字列を引く。Tyranoタグ内で &L('cfg_bgm') と書ける ---------------------
window.L = function (key) {
  var t = window.LANG_TABLE[sf.lang] || window.LANG_TABLE.ja;
  if (t && t[key] != null) return t[key];                       // 現在言語にある
  if (window.LANG_TABLE.ja[key] != null) return window.LANG_TABLE.ja[key]; // ja補完
  return key;                                                   // それも無ければキー名
};

// --- DOMへ一括反映：data-i18n を持つ要素を現在言語で埋める --------------------
//   <span data-i18n="cfg_bgm"></span>        → textContent を差し替え
//   <span data-i18n-html="cfg_bgm"></span>   → innerHTML を差し替え（改行等を含める場合）
//   root(セレクタ/要素)を渡すとその配下だけ、省略で画面全体を対象にする。
window.applyI18n = function (root) {
  var $root = root ? $(root) : $('body');
  $root.find('[data-i18n]').each(function () {
    $(this).text(window.L($(this).attr('data-i18n')));
  });
  $root.find('[data-i18n-html]').each(function () {
    $(this).html(window.L($(this).attr('data-i18n-html')));
  });
};

// --- 言語切替：sf.lang を変えて画面全体へ即反映 ------------------------------
window.setLang = function (lang) {
  if (window.LANG_TABLE[lang]) { sf.lang = lang; }
  window.applyI18n();
};

// --- 共通「閉じる」ボタンをHTMLで生成して重ねる ------------------------------
//   画像ボタン(menu_button_close.png)の置き換え。CG/回想/実績で共用。
//   backTarget … 押下時に @jump するラベル（例 '*backtitle'）。
//   見た目は ui_i18n.css の .ui-btn--close（円形×ボタン・言語非依存）。
//   ラベルは title 属性に common_close を入れておく（読み上げ・ホバー用）。
window.uiInjectClose = function (backTarget) {
  // ★注入時点の現在シナリオを記録して jump の storage に渡す。
  //   target だけだと「現在シナリオの map_label」からしか backTarget を探せず、
  //   状態がずれると「ラベルが見つかりません」→全走査でフリーズ（disc_done型）。
  //   uiInjectClose は各ビュー(cg/replay/achievement)を開いた直後に呼ばれるため、
  //   ここで拾う current_scenario が飛び先ラベルの在るファイルになる。
  var backStorage = TYRANO.kag.stat.current_scenario;
  $('#ui_close').remove(); // 多重生成の防止（各画面で再入場しても1つだけ）
  var html =
    '<div id="ui_close" class="ui-screen ui-screen--overlay">' +
      '<span class="ui-btn ui-btn--close" role="button">×</span>' +
    '</div>';
  $('.tyrano_base').append(html);
  $('#ui_close .ui-btn--close').attr('title', window.L('common_close'));
  $('#ui_close .ui-btn--close').on('click', function () {
    if ($('#ui_close').data('done')) return; // 二重発火防止
    $('#ui_close').data('done', true);
    $('#ui_close').remove(); // オーバーレイを片付けてから遷移（残留防止）
    TYRANO.kag.ftag.startTag('jump', { storage: backStorage, target: backTarget });
  });
};

// --- 共通「閉じる」ボタンを除去（別storageへ抜ける前などに呼ぶ） --------------
window.uiRemoveClose = function () {
  $('#ui_close').remove();
};

[endscript]
[return]
