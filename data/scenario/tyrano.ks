
*start

;背景変更マクロ　storage と time を指定する
[macro name="back"]

;@layopt layer=message0 visible=false
[backlay]
[image layer=base page=back storage=%storage]
[trans layer="base" method=%method|crossfade children=false time=%time|2000]
[wt]
;@layopt layer=message0 visible=true

[endmacro]


;キャラクターを表示、そして設定
[macro name="charaset"]

[backlay]
[image storage=%storage left=%left|0 top=%top|0 layer=%layer page=back visible=true  ]
[trans time=%time|1]
@wt

[endmacro]

[macro name="chararemove"]

[freeimage layer = %layer]

[endmacro]

;;;;;;;;;;;;セーブ関係

;save情報を取得、ptextを継承する

[macro name="saveinfo"]

[iscript]

tf.savetext = "";

tf.array_save = TG.menu.getSaveData().data;
tf.data = tf.array_save[mp.index];

tf.title = tf.data.title;
tf.save_date = tf.data.save_date;

tf.savetext = "<span style='font-size:10px'>"+tf.save_date+"</span><br />"+tf.title;

[endscript]

[ptext * text=&tf.savetext ]


[endmacro]

[macro name="setsave"]

    [iscript]

        TG.menu.doSave(mp.index);
        
    [endscript]

[endmacro]

[macro name="loading"]

    [iscript]

        TG.menu.loadGame(mp.index);

    [endscript]

[endmacro]


;/////////////拡張 CGモードなどを利用するための設定

[iscript]
	
	if(sf.cg_view){
    }else{
    	sf.cg_view = {};
    }
	
	if(sf.replay_view){
    }else{
    	sf.replay_view = {};
    }

	;実績（アチーブメント）の解除状況を保存するオブジェクト
	if(sf.ach_view){
    }else{
    	sf.ach_view = {};
    }

	;===== 実績マスター定義（ここが唯一の定義元。ここを編集して増減する）=====
	; id     … [ach id="..."] で解除するときの識別子（重複させないこと）
	; name   … 実績名
	; desc   … 説明
	; secret … true なら未解除時に説明も「？？？」で隠す（省略可）
	window.ACH_MASTER = [
		{id:"start_game",      name:"金成屋、開店",          desc:"物語を始めた"},
		{id:"prologue_done",   name:"戦国に立つ",            desc:"プロローグを読み終えた"},
		{id:"know_bet",        name:"五百倍の賭け",          desc:"桶狭間をめぐる賭けの噂を知った"},
		{id:"decision_day",    name:"決戦前夜",              desc:"運命の賭けの日を迎えた"},
		{id:"bet_oda",         name:"賽は投げられた",        desc:"織田に有り金すべてを賭けた",           secret:true},
		{id:"bet_hanhan",      name:"二兎を追う者",          desc:"半々に分けて賭けた",                   secret:true},
		{id:"ikkawa_stubborn", name:"往生際の悪い若旦那",    desc:"今川に賭けようとして何度も止められた", secret:true},
		{id:"hidden_end",      name:"歴史に逆らいし者",      desc:"今川に全額を賭け、すべてを失った",     secret:true},
		{id:"chapter1_clear",  name:"第一章 完",             desc:"桶狭間を越え、金成屋の物語を見届けた", secret:true}
	];

[endscript]


;実績を解除するマクロ。シナリオ中どこでも [ach id="実績ID"] の1行で解除できる
;例) [ach id="bet_oda"]
;解除した瞬間、画面上部に通知トーストが一瞬表示される（シナリオ進行は止めない）
[macro name="ach"]
    [iscript]
        if(!sf.ach_view){ sf.ach_view = {}; }
        //まだ解除していなければ解除フラグを立て、通知を出す
        if(!sf.ach_view[mp.id]){
            sf.ach_view[mp.id] = true;

            //実績名をマスターから取得
            var _name = mp.id;
            var _m = window.ACH_MASTER || [];
            for(var _i=0; _i<_m.length; _i++){
                if(_m[_i].id == mp.id){ _name = _m[_i].name; break; }
            }

            //通知トースト（jQueryアニメで非同期に表示→自動消滅。進行はブロックしない）
            try{
                if(window.jQuery){
                    var _n = $(".ach_toast").length;
                    var _t = $('<div class="ach_toast"></div>');
                    _t.html('🏆 実績を解除：' + _name);
                    _t.css({
                        position:"fixed", left:"50%", top:(20 + _n*58) + "px",
                        transform:"translateX(-50%)", "z-index":999999,
                        background:"rgba(30,18,44,0.92)", color:"#ffffff",
                        padding:"12px 28px", "border-radius":"30px",
                        border:"2px solid #ffcc33", "font-size":"20px", "font-weight":"bold",
                        "box-shadow":"0 4px 16px rgba(0,0,0,0.5)", opacity:0,
                        "white-space":"nowrap", "pointer-events":"none"
                    });
                    $("body").append(_t);
                    _t.animate({opacity:1}, 300).delay(2400).animate({opacity:0}, 500, function(){ $(this).remove(); });
                }
            }catch(e){}
        }
    [endscript]
[endmacro]


;CGモードのボタンを表示するためのマクロ
[macro name="cg_image_button"]
	
	[iscript]
		
		mp.graphic = mp.graphic.split(',');
		mp.tmp_graphic = mp.graphic.concat();
		tf.is_cg_open = false;
		if(sf.cg_view[mp.graphic[0]]){
			tf.is_cg_open = true;
		}
		
        if(typeof mp.thumb !="undefined"){
            mp.tmp_graphic[0] = mp.thumb;
        }
	
	
	[endscript]
	
	;渡された値を元に、CG状態を確認していく
	[if exp="tf.is_cg_open==true"]
		[button graphic=&mp.tmp_graphic[0] x=&mp.x y=&mp.y width=&mp.width height=&mp.height preexp="mp.graphic" exp="tf.selected_cg_image = preexp" storage="cg.ks" target="*clickcg" folder="bgimage" ]
	[else]
		[button graphic=&mp.no_graphic x=&mp.x y=&mp.y width=&mp.width height=&mp.height storage="cg.ks" target="*no_image" folder="bgimage" ]
	[endif]
[endmacro]

;CGが閲覧された場合、CGモードで表示できるようにする
[macro name="cg" ]

    [iscript]

        sf.cg_view[mp.storage] = "on";
    
    [endscript]

[endmacro]


;リプレイモード
;CGモードのボタンを表示するためのマクロ
[macro name="replay_image_button"]
	
	[iscript]
		
		tf.is_replay_open = false;
		if(sf.replay_view[mp.name]){
			tf.is_replay_open = true;
		}
	
	[endscript]
	
	;渡された値を元に、CG状態を確認していく
	[if exp="tf.is_replay_open==true"]
		[button graphic=&mp.graphic x=&mp.x y=&mp.y width=&mp.width height=&mp.height preexp="sf.replay_view[mp.name]" exp="tf.selected_replay_obj = preexp" storage="replay.ks" target="*clickcg" folder="bgimage" ]
	[else]
		[button graphic=&mp.no_graphic x=&mp.x y=&mp.y width=&mp.width height=&mp.height storage="replay.ks" target="*no_image" folder="bgimage" ]
	[endif]
	
[endmacro]

;リプレイを開放する
[macro name="setreplay" ]

    [iscript]

        sf.replay_view[mp.name] = {storage:mp.storage, target:mp.target};
    
    [endscript]

[endmacro]

[macro name="endreplay"]

    [if exp="tf.system.flag_replay == true"]
        
        @layopt page="fore" layer="message0" visible=false
        ;システムボタンを非表示にするなど
        [hidemenubutton]
        
        @jump storage="replay.ks" 
        
    [endif]

[endmacro]

[return]


