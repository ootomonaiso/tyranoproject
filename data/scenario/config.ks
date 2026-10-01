;=========================================
; コンフィグ モード（和風HTML＋多言語UI版）
;   ・背景と枠は ui_i18n.css の .ui-screen--config / .cfg-panel（画像なし・言語共通）
;   ・文字は data-i18n で lang.ks の LANG_TABLE から供給（JP/EN即切替）
;   ・操作は HTML でUIを更新＆値を tf/sf に保存し、実際の適用は「戻る」で
;     *backtitle のTyranoタグ側でまとめて行う（元configと同じ「適用はTyrano側」原則）
;=========================================

;	メッセージレイヤ0を不可視に
	[layopt layer="message0" visible="false"]

;	fixボタンをクリア
	[clearfix]

;	キーコンフィグの無効化
	[stop_keyconfig]

;	レイヤーモードの解放
	[free_layermode time="100" wait="true"]

;	カメラのリセット
	[reset_camera time="100" wait="true"]

;	前景レイヤの中身をすべて空に
	[iscript]
	$(".layer_camera").empty();
	$("#bgmovie").remove();
	[endscript]

;	メニューボタン非表示
	[hidemenubutton]

;	現在の設定値を読み込み（tf に集約）
	[iscript]

	TG.config.autoRecordLabel = "true"; // ラベル通過記録を有効に

	tf.current_bgm_vol   = parseInt(TG.config.defaultBgmVolume); // BGM音量
	tf.current_se_vol    = parseInt(TG.config.defaultSeVolume);  // SE音量
	tf.current_ch_speed  = parseInt(TG.config.chSpeed);          // テキスト表示速度
	tf.current_auto_speed= parseInt(TG.config.autoSpeed);        // オート時の表示速度

	tf.text_skip = "ON"; // 未読スキップ
	if (TG.config.unReadTextSkip != "true") { tf.text_skip = "OFF"; }

	// 既読テキスト色を一時的に変更しない（元configと同じ退避）
	tf.user_setting = TG.config.alreadyReadTextColor;
	if (tf.user_setting != 'default') { TG.config.alreadyReadTextColor = 'default'; }

	[endscript]

[cm]

;================================================================================
; 画面（HTML）を生成して .tyrano_base に載せる
;================================================================================
	[iscript]

	// 多重生成の防止
	$('#config_screen').remove();

	// テキスト速度・オート速度の段階（index が大きいほど速い）
	tf.ch_speeds   = [100, 80, 50, 40, 30, 25, 20, 11, 8, 5];
	tf.auto_speeds = [5000, 4500, 4000, 3500, 3000, 2500, 2000, 1300, 800, 500];

	var chIdx   = tf.ch_speeds.indexOf(tf.current_ch_speed);     if (chIdx   < 0) chIdx   = 4;
	var autoIdx = tf.auto_speeds.indexOf(tf.current_auto_speed); if (autoIdx < 0) autoIdx = 4;

	// スキップ・ルビ・言語の現在状態
	var skipOn = (tf.text_skip == 'ON');
	var rubyOn = !!sf.rubymode;

	// --- 画面HTML（文字は data-i18n。値は下の applyI18n で流し込む） ---
	var html =
	  '<div id="config_screen" class="ui-screen ui-screen--config">' +
	    '<div class="cfg-panel">' +
	      '<div class="cfg-mon" aria-hidden="true"></div>' +
	      '<h2 class="cfg-title" data-i18n="cfg_title"></h2>' +
	      '<div class="cfg-rows">' +

	        // BGM音量
	        '<div class="cfg-row">' +
	          '<div class="cfg-row__label" data-i18n="cfg_bgm"></div>' +
	          '<div class="cfg-row__control">' +
	            '<input type="range" class="cfg-range" id="cfgBgm" min="0" max="100" step="10" value="' + tf.current_bgm_vol + '">' +
	            '<span class="cfg-val" id="cfgBgmVal"></span>' +
	          '</div>' +
	        '</div>' +

	        // SE音量
	        '<div class="cfg-row">' +
	          '<div class="cfg-row__label" data-i18n="cfg_se"></div>' +
	          '<div class="cfg-row__control">' +
	            '<input type="range" class="cfg-range" id="cfgSe" min="0" max="100" step="10" value="' + tf.current_se_vol + '">' +
	            '<span class="cfg-val" id="cfgSeVal"></span>' +
	          '</div>' +
	        '</div>' +

	        // テキスト速度
	        '<div class="cfg-row">' +
	          '<div class="cfg-row__label" data-i18n="cfg_ch"></div>' +
	          '<div class="cfg-row__control">' +
	            '<input type="range" class="cfg-range" id="cfgCh" min="0" max="9" step="1" value="' + chIdx + '">' +
	            '<span class="cfg-val" id="cfgChVal"></span>' +
	          '</div>' +
	        '</div>' +

	        // オート速度
	        '<div class="cfg-row">' +
	          '<div class="cfg-row__label" data-i18n="cfg_auto"></div>' +
	          '<div class="cfg-row__control">' +
	            '<input type="range" class="cfg-range" id="cfgAuto" min="0" max="9" step="1" value="' + autoIdx + '">' +
	            '<span class="cfg-val" id="cfgAutoVal"></span>' +
	          '</div>' +
	        '</div>' +

	        // 未読スキップ
	        '<div class="cfg-row">' +
	          '<div class="cfg-row__label" data-i18n="cfg_skip"></div>' +
	          '<div class="cfg-row__control cfg-toggle" id="cfgSkip">' +
	            '<span class="ui-btn' + (skipOn ? ' is-active' : '') + '" data-val="on"  data-i18n="cfg_on"></span>' +
	            '<span class="ui-btn' + (skipOn ? '' : ' is-active') + '" data-val="off" data-i18n="cfg_off"></span>' +
	          '</div>' +
	        '</div>' +

	        // ふりがな
	        '<div class="cfg-row">' +
	          '<div class="cfg-row__label" data-i18n="cfg_ruby"></div>' +
	          '<div class="cfg-row__control cfg-toggle" id="cfgRuby">' +
	            '<span class="ui-btn' + (rubyOn ? ' is-active' : '') + '" data-val="on"  data-i18n="cfg_on"></span>' +
	            '<span class="ui-btn' + (rubyOn ? '' : ' is-active') + '" data-val="off" data-i18n="cfg_off"></span>' +
	          '</div>' +
	        '</div>' +

	        // 言語
	        '<div class="cfg-row">' +
	          '<div class="cfg-row__label" data-i18n="cfg_lang"></div>' +
	          '<div class="cfg-row__control cfg-toggle" id="cfgLang">' +
	            '<span class="ui-btn" data-val="ja">日本語</span>' +
	            '<span class="ui-btn" data-val="en">English</span>' +
	          '</div>' +
	        '</div>' +

	      '</div>' + // .cfg-rows
	      '<div class="cfg-seal" aria-hidden="true">金</div>' +
	    '</div>' +   // .cfg-panel
	    '<div class="ui-topright">' +
	      '<span class="ui-btn" id="cfgBack" data-i18n="cfg_back"></span>' +
	    '</div>' +
	  '</div>';

	$('.tyrano_base').append(html);

	// 現在言語で全ラベルを流し込む
	window.applyI18n('#config_screen');

	// --- 読み出し表示の更新関数 ---
	var refresh = function () {
	  $('#cfgBgmVal').text(tf.current_bgm_vol + '%');
	  $('#cfgSeVal').text(tf.current_se_vol + '%');
	  $('#cfgChVal').text((tf.ch_speeds.indexOf(tf.current_ch_speed) + 1) + ' / 10');
	  $('#cfgAutoVal').text((tf.auto_speeds.indexOf(tf.current_auto_speed) + 1) + ' / 10');
	  // 現在言語のハイライト
	  $('#cfgLang .ui-btn').removeClass('is-active');
	  $('#cfgLang .ui-btn[data-val="' + sf.lang + '"]').addClass('is-active');
	};
	refresh();

	// --- スライダー ---
	//   ★BGM/SEはドラッグ中に即時反映する（next:"false"で音量だけ変更しシナリオは進めない）。
	//     以前は *backtitle の [bgmopt] でしか適用されず「戻るまで変わらない＝つまみが死んでる」
	//     ように感じたため、input で逐次 bgmopt/seopt を呼んでリアルタイムに反映する。
	$('#cfgBgm').on('input', function () {
	  tf.current_bgm_vol = parseInt(this.value);
	  TYRANO.kag.ftag.startTag('bgmopt', { volume: String(tf.current_bgm_vol), next: 'false' });
	  refresh();
	});
	$('#cfgSe').on('input',  function () {
	  tf.current_se_vol  = parseInt(this.value);
	  TYRANO.kag.ftag.startTag('seopt', { volume: String(tf.current_se_vol), next: 'false' });
	  refresh();
	});
	$('#cfgCh').on('input',  function () { tf.current_ch_speed   = tf.ch_speeds[parseInt(this.value)];   refresh(); });
	$('#cfgAuto').on('input',function () { tf.current_auto_speed = tf.auto_speeds[parseInt(this.value)]; refresh(); });

	// --- スキップ トグル ---
	$('#cfgSkip .ui-btn').on('click', function () {
	  tf.text_skip = ($(this).attr('data-val') == 'on') ? 'ON' : 'OFF';
	  $('#cfgSkip .ui-btn').removeClass('is-active');
	  $(this).addClass('is-active');
	});

	// --- ふりがな トグル ---
	$('#cfgRuby .ui-btn').on('click', function () {
	  sf.rubymode = ($(this).attr('data-val') == 'on');
	  $('#cfgRuby .ui-btn').removeClass('is-active');
	  $(this).addClass('is-active');
	});

	// --- 言語 切替（全ラベル即差し替え） ---
	$('#cfgLang .ui-btn').on('click', function () {
	  window.setLang($(this).attr('data-val')); // sf.lang変更→applyI18n
	  refresh();
	});

	// --- 戻る：パネルを消して *backtitle へ（適用はそちらで） ---
	//   このクリックが復帰(awakegame)後のメッセージ送りへ伝播すると
	//   「セリフが1つ進む」不具合になる。→ 伝播を止め、復帰は次tickへ遅延。
	$('#cfgBack').on('click', function (e) {
	  e.preventDefault();
	  e.stopPropagation();
	  // ★二重発火防止＋storage明示（disc_doneと同種のフリーズ対策）。
	  //   連打や別コンテキストで再発火すると、target だけでは現在シナリオの
	  //   map_label に *backtitle が無く「ラベルが見つかりません」→全走査でフリーズ。
	  if ($('#config_screen').data('done')) return;
	  $('#config_screen').data('done', true);
	  $('#cfgBack').off('click');
	  setTimeout(function () {
	    TYRANO.kag.ftag.startTag('jump', { storage: 'config.ks', target: '*backtitle' });
	  }, 0);
	});

	[endscript]

; パネル操作待ち
[s]

;================================================================================
; コンフィグ終了：選んだ値を実際に適用し、ゲームへ復帰
;================================================================================
*backtitle
[cm]

;	HTML画面を除去
	[iscript]
	$('#config_screen').remove();
	// 既読テキスト色を復帰
	TG.config.alreadyReadTextColor = tf.user_setting;
	// スキップ永続化用の文字列
	tf.skip_flag = (tf.text_skip == 'ON') ? 'true' : 'false';
	[endscript]

;	音量・速度・スキップを適用（＝Tyranoタグで実行）
	[bgmopt volume="&tf.current_bgm_vol"]
	[seopt  volume="&tf.current_se_vol"]
	[configdelay speed="&tf.current_ch_speed"]
	[autoconfig  speed="&tf.current_auto_speed"]
	[config_record_label skip="&tf.skip_flag"]

;	fixボタンをクリア
	[clearfix]

;	キーコンフィグの有効化
	[start_keyconfig]

;	コールスタックのクリア
	[clearstack]

;	ゲーム復帰
	[awakegame]
