;=========================================
; 実績（アチーブメント）画面
;=========================================

@layopt layer=message0 visible=false

@clearfix
[hidemenubutton]
[cm]

[bg storage="achievement_bg.png" time=100]
[layopt layer=1 visible=true]

;=========================================
; 実績の定義は tyrano.ks の window.ACH_MASTER に一元化されている。
; 実績を追加・変更するときは tyrano.ks を編集すること。
;=========================================
[iscript]

    if(!sf.ach_view){ sf.ach_view = {}; }

    //マスター定義（tyrano.ks で定義）を取得
    tf.ach_defs = window.ACH_MASTER || [];

    //解除数をカウント
    tf.ach_total = tf.ach_defs.length;
    tf.ach_got   = 0;
    for(var i=0;i<tf.ach_defs.length;i++){
        if(sf.ach_view[tf.ach_defs[i].id]){ tf.ach_got++; }
    }

    //一覧をHTMLで組み立てる（1つのptextにまとめて描画）
    var html = "";
    html += "<div style='font-size:38px;color:#ffffff;font-weight:bold;margin-bottom:4px;'>" + window.L('ach_title') + "</div>";
    html += "<div style='font-size:22px;color:#ffe08a;margin-bottom:18px;'>" + window.L('ach_unlocked') + " " + tf.ach_got + " / " + tf.ach_total + "</div>";
    html += "<div id='ach_scroll' style='max-height:540px;overflow-y:auto;overflow-x:hidden;padding-right:8px;pointer-events:auto;-webkit-overflow-scrolling:touch;'>";

    for(var i=0;i<tf.ach_defs.length;i++){
        var d    = tf.ach_defs[i];
        var open = sf.ach_view[d.id] ? true : false;

        var star   = open ? (d.icon || "★") : "☆";
        var name   = open ? d.name : window.L('ach_locked');
        var desc   = open ? d.desc : (d.secret ? window.L('ach_locked') : d.desc);
        var accent = open ? "#ffcc33" : "#555555";
        var tcol   = open ? "#ffffff" : "#888888";
        var dcol   = open ? "#dddddd" : "#777777";

        html += "<div style='margin-bottom:12px;padding:10px 18px;background:rgba(0,0,0,0.45);border-left:6px solid " + accent + ";border-radius:6px;'>";
        html += "<div style='font-size:26px;color:" + tcol + ";'>" + star + "  " + name + "</div>";
        html += "<div style='font-size:16px;color:" + dcol + ";margin-top:4px;'>" + desc + "</div>";
        html += "</div>";
    }

    html += "</div>";

    tf.ach_html = html;

[endscript]

;一覧本体（overwrite=true なので再入場しても重複しない）
[ptext layer=1 page=fore name="ach_board" overwrite="true" x=60 y=40 width=1000 text=&tf.ach_html]

;スクロール有効化：windowのcaptureフェーズでホイールを先取りし、
;カーソルが一覧領域内なら自前でスクロール（上に重なるレイヤやバックログ横取りを無視できる）
[iscript]
if (window._ach_wheel) { window.removeEventListener('wheel', window._ach_wheel, true); }
window._ach_wheel = function(e){
    var box = document.getElementById('ach_scroll');
    if(!box){ return; }
    var r = box.getBoundingClientRect();
    if(e.clientX >= r.left && e.clientX <= r.right && e.clientY >= r.top && e.clientY <= r.bottom){
        box.scrollTop += e.deltaY;
        e.preventDefault();
        e.stopPropagation();
    }
};
window.addEventListener('wheel', window._ach_wheel, { capture:true, passive:false });
[endscript]

;閉じるボタン（CSS版・多言語対応）
[iscript]
window.uiInjectClose('*ach_backtitle');
[endscript]

[s]

*ach_backtitle
[cm]
;スクロール用のホイールリスナを解除＋閉じるボタンを除去
[iscript]
if (window._ach_wheel) { window.removeEventListener('wheel', window._ach_wheel, true); window._ach_wheel = null; }
window.uiRemoveClose();
[endscript]
;一覧のテキストとレイヤー1の画像を消してからタイトルへ戻る
[free layer=1 name="ach_board"]
[freeimage layer=1]
@jump storage="title.ks"
