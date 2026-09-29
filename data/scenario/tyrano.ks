
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
	; icon   … 一覧・トーストに出す絵文字アイコン（省略時は ★）
	; secret … true なら未解除時に説明も「？？？」で隠す（省略可）
	window.ACH_MASTER = [
		;--- 進行（本筋を進めると自然に解除）---------------------------------
		{id:"start_game",      name:"金成屋、開店",          desc:"物語を始めた",                         icon:"🏮"},
		{id:"prologue_done",   name:"戦国に立つ",            desc:"プロローグを読み終えた",               icon:"🌙"},
		{id:"mikan_idea",      name:"すっぱいみかん一杯",    desc:"みかん水の商いを思いついた",           icon:"🍊"},
		{id:"know_bet",        name:"五百倍の賭け",          desc:"桶狭間をめぐる賭けの噂を知った",       icon:"🎲"},
		{id:"decision_day",    name:"決戦前夜",              desc:"運命の賭けの日を迎えた",               icon:"🌅"},
		;--- 一日目：誰について町へ出たか ------------------------------------
		{id:"day1_koyuki",     name:"帳面は嘘をつかない",    desc:"小雪と蔵の棚卸しをした",               icon:"📒"},
		{id:"day1_maki",       name:"堺の歩き方",            desc:"真姫と堺の市場を見て回った",           icon:"🏙️"},
		{id:"day1_tsubasa",    name:"同じ穴のムジナ",        desc:"椿紗と町を歩き、甘味に目をつけた",     icon:"🍡"},
		;--- 二日目：仕入れの相棒 -------------------------------------------
		{id:"day2_koyuki",     name:"目利きの買い出し",      desc:"小雪とみかんを仕入れた",               icon:"🛒"},
		{id:"day2_maki",       name:"砂糖の甘い罠",          desc:"真姫と砂糖を仕入れた",                 icon:"🍬"},
		;--- 三日目：はじめての商い -----------------------------------------
		{id:"day3_koyuki",     name:"みかん水、はじめました",desc:"店先でみかん水を売り出した",           icon:"🥤"},
		;--- 五日目：決戦前の一日 -------------------------------------------
		{id:"day5_koyuki",     name:"番台の若旦那",          desc:"小雪と店番をした",                     icon:"🧮"},
		{id:"day5_maki",       name:"地獄耳",                desc:"真姫と町の噂を集めて回った",           icon:"👂"},
		{id:"day5_tsubasa",    name:"看板息子",              desc:"椿紗と客引きに出た",                   icon:"📣"},
		;--- 賭けの選択（隠し）----------------------------------------------
		{id:"bet_oda",         name:"賽は投げられた",        desc:"織田に有り金すべてを賭けた",           icon:"🎯", secret:true},
		{id:"bet_hanhan",      name:"二兎を追う者",          desc:"半々に分けて賭けた",                   icon:"⚖️", secret:true},
		{id:"ikkawa_stubborn", name:"往生際の悪い若旦那",    desc:"今川に賭けようとして何度も止められた", icon:"😅", secret:true},
		{id:"hidden_end",      name:"歴史に逆らいし者",      desc:"今川に全額を賭け、すべてを失った",     icon:"💀", secret:true},
		;--- 隠し要素 -------------------------------------------------------
		{id:"tanuki_friend",   name:"相棒はタヌキ",          desc:"タヌキの誘いに乗ろうとした",           icon:"🦝", secret:true},
		{id:"reason_kame",     name:"亀の甲羅のお告げ",      desc:"元締めに「甲羅が割れて織田と出た」と嘯いた", icon:"🐢", secret:true},
		{id:"reason_tanuki",   name:"タヌキの恩返し",        desc:"元締めに「タヌキの虫の知らせ」と嘯いた",     icon:"🐾", secret:true},
		{id:"reason_kan",      name:"五百倍の勘",            desc:"元締めに「勘だ」と言い切った",         icon:"✨", secret:true},
		;--- 完走・コンプリート（隠し）-------------------------------------
		{id:"chapter1_clear",  name:"第一章 完",             desc:"桶狭間を越え、金成屋の物語を見届けた", icon:"🏆", secret:true},
		{id:"all_complete",    name:"金成屋、大繁盛",        desc:"すべての実績を解き明かした",           icon:"👑", secret:true}
	];

	;===== 実績の解除ロジック（トースト表示・メタ実績判定を一元化）=========
	; どこからでも window.uiAchUnlock("id") 一発で「解除フラグ＋通知トースト」。
	; [ach id="..."] マクロもこれを呼ぶだけ。
	window.uiAchUnlock = function(id){
		try{
			if(!sf.ach_view){ sf.ach_view = {}; }
			if(sf.ach_view[id]){ return; }          // 既に解除済みなら何もしない

			// マスターから定義を引く（未定義IDはタイプミスとみなし無視）
			var master = window.ACH_MASTER || [];
			var def = null;
			for(var i=0;i<master.length;i++){ if(master[i].id === id){ def = master[i]; break; } }
			if(!def){ return; }

			sf.ach_view[id] = true;                  // 解除
			window.uiAchToast(def.name, def.icon);   // 通知トースト（非同期・進行はブロックしない）

			// メタ実績：自分以外の全実績が解除済みなら「大繁盛」も解除
			if(id !== "all_complete"){
				var everyElse = true;
				for(var j=0;j<master.length;j++){
					if(master[j].id === "all_complete"){ continue; }
					if(!sf.ach_view[master[j].id]){ everyElse = false; break; }
				}
				if(everyElse){ window.uiAchUnlock("all_complete"); }
			}
		}catch(e){}
	};

	;===== 通知トースト（見た目は ui_i18n.css の .ach-toast に集約）=========
	; name … 実績名（コンテンツ扱い＝非国際化。textで安全に差し込む）
	; icon … 絵文字アイコン。ラベル「実績を解除」だけは L('ach_toast') で多言語化。
	window.uiAchToast = function(name, icon){
		try{
			if(!window.jQuery){ return; }
			icon = icon || "🏆";
			var idx = $(".ach-toast").length;       // 既存トースト数＝スタック段目
			var $t = $(
				'<div class="ach-toast" role="status" aria-live="polite">' +
					'<span class="ach-toast__icon"></span>' +
					'<span class="ach-toast__body">' +
						'<span class="ach-toast__label"></span>' +
						'<span class="ach-toast__name"></span>' +
					'</span>' +
				'</div>'
			);
			$t.find(".ach-toast__icon").text(icon);
			$t.find(".ach-toast__label").text((window.L ? window.L('ach_toast') : '実績を解除'));
			$t.find(".ach-toast__name").text(name);
			$t.css("top", (24 + idx * 84) + "px");
			$("body").append($t);
			// 次フレームで表示クラス付与 → CSSトランジションでスライドイン
			requestAnimationFrame(function(){ $t.addClass("is-show"); });
			// 表示 → 退場 → DOM除去
			setTimeout(function(){
				$t.removeClass("is-show");
				setTimeout(function(){ $t.remove(); }, 500);
			}, 3200);
		}catch(e){}
	};

[endscript]


;実績を解除するマクロ。シナリオ中どこでも [ach id="実績ID"] の1行で解除できる
;例) [ach id="bet_oda"]
;解除した瞬間、画面上部に通知トーストが一瞬表示される（シナリオ進行は止めない）
;解除フラグ・トースト・メタ実績判定は window.uiAchUnlock に一元化してある。
[macro name="ach"]
    [iscript]
        window.uiAchUnlock(mp.id);
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


