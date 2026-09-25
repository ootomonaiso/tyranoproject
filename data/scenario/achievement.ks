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
    html += "<div style='font-size:38px;color:#ffffff;font-weight:bold;margin-bottom:4px;'>実 績</div>";
    html += "<div style='font-size:22px;color:#ffe08a;margin-bottom:18px;'>解除 " + tf.ach_got + " / " + tf.ach_total + "</div>";
    html += "<div style='max-height:540px;overflow-y:auto;padding-right:8px;'>";

    for(var i=0;i<tf.ach_defs.length;i++){
        var d    = tf.ach_defs[i];
        var open = sf.ach_view[d.id] ? true : false;

        var star   = open ? "★" : "☆";
        var name   = open ? d.name : "？？？";
        var desc   = open ? d.desc : (d.secret ? "？？？" : d.desc);
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

;閉じるボタン（fixレイヤーなので [cm] で消える）
[button graphic="config/menu_button_close.png" enterimg="config/menu_button_close2.png" target="*ach_backtitle" x=1150 y=40 ]

[s]

*ach_backtitle
[cm]
;一覧のテキストとレイヤー1の画像を消してからタイトルへ戻る
[free layer=1 name="ach_board"]
[freeimage layer=1]
@jump storage="title.ks"
