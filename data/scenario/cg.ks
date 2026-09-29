;=========================================
; CG モード　画面作成
;=========================================

@layopt layer=message0 visible=false

@clearfix
[hidemenubutton]
[cm]

[bg storage="../../tyrano/images/system/bg_base.png" time=100]
[layopt layer=1 visible=true]

[image layer=1 left=0 top=0 storage="config/label_cg.png" folder="image" ]

[iscript]
    
    tf.page = 0;
    tf.selected_cg_image = ""; //選択されたCGを一時的に保管
    
[endscript]



*cgpage
[layopt layer=1 visible=true]

[cm]
;閉じるボタン（CSS版・多言語対応。ページ再入場のたび1つだけ再生成される）
[iscript]
window.uiInjectClose('*backtitle');
[endscript]

[iscript]
    tf.tmp_index = 0;
    tf.cg_index = 12 * tf.page;
    tf.top = 100;
    tf.left = 60;
    
[endscript]

[iscript]
	tf.target_page = "page_"+tf.page;
[endscript]

*cgview
@jump target=&tf.target_page

*page_0
[cg_image_button graphic="rouka.jpg,room.jpg,title.png" no_graphic="../../tyrano/images/system/noimage.png" x=60 y=130 width=160 height=140 folder="bgimage" ]
[cg_image_button graphic="room.jpg" no_graphic="../../tyrano/images/system/noimage.png" x=250 y=130 width=160 height=140 folder="bgimage" ]

@jump target="*common"

*common


*endpage



[s]

*backtitle
[cm]
[iscript]
window.uiRemoveClose();
[endscript]
[freeimage layer=1]
@jump storage=title.ks

*nextpage
[emb exp="tf.page++;"]
@jump target="*cgpage"


*backpage
[emb exp="tf.page--;"]
@jump target="*cgpage"

*clickcg
[cm]

;CGフルスクリーン表示中は閉じるボタンを隠す（元は[cm]でfixボタンが消えていた挙動に合わせる）
[iscript]
window.uiRemoveClose();
[endscript]

[layopt layer=1 visible=false]

[eval exp="tf.cg_index=0"]

*cg_next_image

[image storage=&tf.selected_cg_image[tf.cg_index] folder="bgimage"  ]
[l]
[bg storage="../../tyrano/images/system/bg_base.png" time=10]

[eval exp="tf.cg_index++"]

@jump target="cg_next_image" cond="tf.selected_cg_image.length > tf.cg_index"


@jump  target=*cgpage
[s]

*no_image

@jump  target=*cgpage



