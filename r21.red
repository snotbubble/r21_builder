Red [ needs 'view ]

;; TODO
;; [ ] fix parameter field text-selection lockout (known GTK bug)


makemeatimestamp: function [] [
	tstampdate: now/date
	tstamptime: now/time
	o: rejoin [ tstampdate/2 "-" (reduce pad/with/left tstampdate/3 2 #"0") "-" (reduce pad/with/left tstampdate/4 2 #"0") "_" (reduce pad/with/left tstamptime/1 2 #"0") "-" (reduce pad/with/left tstamptime/2 2 #"0") "-" (reduce pad/with/left (to-string to-integer tstamptime/3) 2 #"0") ]
	o
]

fittopane: function [ii ps] [
	g: ii/image
	either (ps/x / ps/y) > (g/size/x / g/size/y) [
		ii/size/y: to-integer (ps/y - 20)
		ii/size/x: to-integer ((ps/y - 20) * (g/size/x / g/size/y))
	] [
		ii/size/x: to-integer (ps/x - 20)
		ii/size/y: to-integer ((ps/x - 20) * (g/size/y / g/size/x))
	]
	ii/offset/x: (to-integer ((ps/x - ii/size/x) * 0.5))
]

clear-reactions
txtitem: context [
	name: "textitemname"
	index: 1
	poster: %./imagefile.png
	video: %./video.mp4
	cardtext: "short description goes here"
	cardlink: "a url goes here"
	downloadlinks: [ ["link1" "a list of download links goes here"] ["link2" "another url" ]]
	pokeme: 0
]

inkitem: context [
	name: "inkitemname"
	index: 1
	poster: %./imagefile.gif
]

picitem: context [
	name: "picitemname"
	index: 1
	poster: %./imagefile.png
	video: %./video.mp4
	cardtext: "short description goes here"
	credits: {credits^/* goes^/* here^/in a list} ;*/
	pokeme: 0
]
arcitem: context [
	name: "arcitemname"
	index: 1
	poster: %./imagefile.jpg
	video: %./video.mp4
	cardtext: "short description goes here"
	credits: {credits^/* goes^/* here^/in a list} ;*/
	pokeme: 0
]

txtlistpane: compose/deep [
	txtlist: text-list 35.35.35 300x300 font-name "consolas" font-size 16 font-color 180.180.180 bold [ 
		unless noupdate [ txtselect ]
	]
]
inklistpane: compose/deep [
	inklist: text-list 35.35.35 300x300 font-name "consolas" font-size 16 font-color 180.180.180 bold [ 
		unless noupdate [ inkselect ]
	]
]
piclistpane: compose/deep [
	piclist: text-list 35.35.35 300x300 font-name "consolas" font-size 16 font-color 180.180.180 bold [ 
		unless noupdate [ picselect ]
	]
]
arclistpane: compose/deep [
	arclist: text-list 35.35.35 300x300 font-name "consolas" font-size 16 font-color 180.180.180 bold [ 
		unless noupdate [ arcselect ]
	]
]

txtformpane: compose/deep [
	txtform: panel loose [
		below
		text "title" font-name "consolas" font-size 10 font-color 180.180.180 bold
		tname: field 300x30 40.40.40 font-name "consolas" font-size 10 font-color 180.180.180 bold on-change [ 
			unless noupdate [
				noupdate: true
				replace face/text " " "_"
				txtnodes/:sidx/name: copy face/text
			   	txtlist/data/:sidx: rejoin [ pad/left/with to-string sidx 3 #"0" "^-" face/text ]
				txtspew
				noupdate: false
			]
		]
	    tidx: text 60x30 font-name "consolas" font-size 16 font-color 80.80.80 bold  with [ text: (quote (to-string sidx)) ]
		text 120x30 "poster" font-name "consolas" font-size 10 font-color 180.180.180 bold
		tiposter: image 300x300 on-up [
			timgfile: request-file/filter ["pics" "*.png"]
			if exists? timgfile [
				txtnodes/:sidx/poster: timgfile
				face/image: load timgfile
				unless none? face/image [
					tposter/text: to-string timgfile
					nudgevv
				]
			]
		]
		tposterpane: panel 45.45.45 [
			below
			tposter: text 300x30 "no poster" font-name "consolas" font-size 10 font-color 180.180.180 bold
			tpubposter: button 300x30 "save poster to pub" font-name "consolas" font-size 10 font-color 180.180.180 bold [
				tposterfile: txtnodes/:sidx/poster
				unless none? tposterfile [
					if exists? tposterfile [
						make-dir %./pub
						clog: copy ""
						tsrc: to-string tposterfile
						tdst: to-file rejoin [ "./pub/txt_" sidx "_" txtnodes/:sidx/name ".png" ]
						call/wait/output rejoin [ "cp " tsrc " " tdst ] clog
						probe clog
					]
				]
			]
		]
		tvideopane: panel 45.45.45 [
	    	text 120x30 "video" font-name "consolas" font-size 10 font-color 180.180.180 bold
			return
			tvideo: text 40.40.40 200x30 "no video" font-name "consolas" font-size 10 font-color 180.180.180 bold
			tpickvideo: button 80x30 "pick" font-name "consolas" font-size 10 font-color 180.180.180 bold [
				tvidfile: request-file/filter ["mp4" "*.mp4"]
				unless none? tvidfile [
					if exists? tvidfile [
	   					txtnodes/:sidx/video: tvidfile
						tvideo/text: to-string tvidfile
					]
				]
			]
			return
			tpubvideo: button 300x30 "copy video to pub" font-name "consolas" font-size 10 font-color 180.180.180 bold [
				tvidfile: txtnodes/:sidx/video
				unless none? tvidfile [
					if exists? tvidfile [
						make-dir %./pub
						clog: copy ""
						tsrc: to-string tvidfile
						tdst: rejoin [ "./pub/txt_" sidx "_" txtnodes/:sidx/name ".mp4" ]
						call/wait/output rejoin [ "cp " tsrc " " tdst ] clog
						probe clog
					]
				]
			]
		]
		tcardpane: panel 45.45.45 [
			below
			text 120x30 "card text" font-name "consolas" font-size 10 font-color 180.180.180 bold
			tcardtxt: area 40.40.40 300x90 font-name "consolas" font-size 10 font-color 180.180.180 bold on-change [
				unless noupdate [
					txtnodes/:sidx/cardtext: copy face/text
					txtspew
				]
			]
			text 120x30 "card link" font-name "consolas" font-size 10 font-color 180.180.180 bold
			tcardlink: field 300x30 40.40.40 font-name "consolas" font-size 10 font-color 180.180.180 bold on-change [
				unless noupdate [
					txtnodes/:sidx/cardlink: copy face/text
					txtspew
				]
			]
		]
	] on-drag [
	    face/offset/x: 0
		bbo: face/parent/size/y - face/size/y
		bbo: bbo - 55
		bbo: min bbo 0
	    face/offset/y: max bbo min face/offset/y 0
	] on-wheel [
		either event/picked > 0 [
			face/offset/y: face/offset/y + 40
		] [
			face/offset/y: face/offset/y - 40
		]
	    face/offset/x: 0
		bbo: face/parent/size/y - face/size/y
		bbo: bbo - 55
		bbo: min bbo 0
	    face/offset/y: max bbo min face/offset/y 0
	]
]

inkformpane: compose/deep [
	inkform: panel loose [
		below
		text "title" font-name "consolas" font-size 10 font-color 180.180.180 bold
		iname: field 40.40.40 300x30 font-name "consolas" font-size 10 font-color 180.180.180 bold on-change [ 
			unless noupdate [
				noupdate: true
				replace face/text " " "_"
				inknodes/:sidx/name: copy face/text
			   	inklist/data/:sidx: rejoin [ pad/left/with to-string sidx 3 #"0" "^-" face/text ]
				inkspew
				noupdate: false
			]
		]
	    iidx: text 60x30 font-name "consolas" font-size 16 font-color 80.80.80 bold with [ text: (quote (to-string sidx)) ]
		text 120x30 "poster" font-name "consolas" font-size 10 font-color 180.180.180 bold
		iiposter: image 300x300 on-up [
			iposterimg: request-file/filter ["pics" "*.png"]
			unless none? iposterimg [
				if exists? iposterimg [
					inknodes/:sidx/poster: iposterimg
					iiposter/image: load iposterimg
					iposter/text: to-string iposterimg
					nudgevv
				]
			]
		]
		iposterpane: panel 45.45.45 [
			below
			iposter: text 300x30 "no poster" font-name "consolas" font-size 10 font-color 180.180.180 bold
			ipubposter: button 300x30 "save poster to pub" font-name "consolas" font-size 10 font-color 180.180.180 bold [
				unless none? iposterfile [
					if exists? iposterfile [
						iposterfile: inknodes/:sidx/poster
						make-dir %./pub
						clog: copy ""
						isrc: to-string iposterfile
						idst: to-file rejoin [ "./pub/ink_" sidx "_" inknodes/:sidx/name ".png" ]
						call/wait/output rejoin [ "cp " isrc " " idst ] clog
						probe clog
					]
				]
			]
		]
	] on-drag [
	    face/offset/x: 0
		ibbo: face/parent/size/y - face/size/y
		ibbo: ibbo - 55
		ibbo: min ibbo 0
	    face/offset/y: max ibbo min face/offset/y 0
	] on-wheel [
		either event/picked > 0 [
			face/offset/y: face/offset/y + 40
		] [
			face/offset/y: face/offset/y - 40
		]
	    face/offset/x: 0
		ibbo: face/parent/size/y - face/size/y
		ibbo: ibbo - 55
		ibbo: min ibbo 0
	    face/offset/y: max ibbo min face/offset/y 0
	]
]

picformpane: compose/deep [
	picform: panel loose [
		below
		text "title"
		pname: field 300x30 40.40.40 font-name "consolas" font-size 10 font-color 180.180.180 bold on-change [ 
			unless noupdate [
				noupdate: true
				replace face/text " " "_"
				picnodes/:sidx/name: copy face/text
			   	piclist/data/:sidx: rejoin [ pad/left/with to-string sidx 3 #"0" "^-" face/text ]
				noupdate: false
				picspew
			]
		]
		pidx: text 60x30 font-name "consolas" font-size 16 font-color 80.80.80 bold with [ text: (quote (to-string sidx)) ]
		text 120x30 "poster" font-name "consolas" font-size 10 font-color 180.180.180 bold
		piposter: image 300x300 on-up [
			pimgfile: request-file/filter ["pics" "*.png"]
			unless none? pimgfile [
				if exists? pimgfile [
					picnodes/:sidx/poster: pimgfile
					face/image: load pimgfile
					unless none? face/image [
						pposter/text: to-string pimgfile
						nudgevv
					]
				]
			]
		]
		pposterpane: panel 45.45.45 [
			below
			pposter: text 300x30 "no poster" font-name "consolas" font-size 10 font-color 180.180.180 bold
			ppubposter: button 300x30 "save poster to pub" font-name "consolas" font-size 10 font-color 180.180.180 bold [
				pposterfile: picnodes/:sidx/poster
				unless none? pposterfile [
					if exists? pposterfile [
						make-dir %./pub
						clog: copy ""
						psrc: to-string pposterfile
						pdst: to-file rejoin [ "./pub/pic_" sidx "_" picnodes/:sidx/name ".png" ]
						call/wait/output rejoin [ "cp " psrc " " pdst ] clog
						probe clog
					]
				]
			]
		]
		pvideopane: panel 45.45.45 [
	    	text 120x30 "video" font-name "consolas" font-size 10 font-color 180.180.180 bold
			return
			pvideo: text 40.40.40 200x30 "no video" font-name "consolas" font-size 10 font-color 180.180.180 bold
			ppickvideo: button 80x30 "pick" font-name "consolas" font-size 10 font-color 180.180.180 bold [
				pvidfile: request-file/filter ["mp4" "*.mp4"]
				unless none? pvidfile [
					if exists? pvidfile [
						picnodes/:sidx/video: pvidfile
						pvideo/text: to-string pvidfile
					]
				]
			]
			return
			ppubvideo: button 300x30 "copy video to pub" font-name "consolas" font-size 10 font-color 180.180.180 bold [
				pvidfile: picnodes/:sidx/video
				unless none? pvidfile [
					if exists? pvidfile [
						make-dir %./pub
						clog: copy ""
						psrc: to-string pvidfile
						pdst: rejoin [ "./pub/pic_" sidx "_" picnodes/:sidx/name ".mp4" ]
						call/wait/output rejoin [ "cp " psrc " " pdst ] clog
						probe clog
					]
				]
			]
		]
		pcardpane: panel 45.45.45 [
			below
			text 120x30 "card text" font-name "consolas" font-size 10 font-color 180.180.180 bold
			pcardtxt: area 40.40.40 300x90 font-name "consolas" font-size 10 font-color 180.180.180 bold on-change  [
				unless noupdate [
					picnodes/:sidx/cardtext: copy face/text
					picspew
				]
			]
			text 120x30 "credits" font-name "consolas" font-size 10 font-color 180.180.180 bold
			pcredits: area 40.40.40 300x300 font-name "consolas" font-size 10 font-color 180.180.180 bold on-change [
				unless noupdate [
					picnodes/:sidx/credits: copy face/text
					picspew
				]
			]
		]
	] on-drag [
	    face/offset/x: 0
		pbbo: face/parent/size/y - face/size/y
		pbbo: pbbo - 55
		pbbo: min pbbo 0
	    face/offset/y: max pbbo min face/offset/y 0
	] on-wheel [
		either event/picked > 0 [
			face/offset/y: face/offset/y + 40
		] [
			face/offset/y: face/offset/y - 40
		]
	    face/offset/x: 0
		pbbo: face/parent/size/y - face/size/y
		pbbo: pbbo - 55
		pbbo: min pbbo 0
	    face/offset/y: max pbbo min face/offset/y 0
	]
]

arcformpane: compose/deep [
	arcform: panel loose [
		below
		text "title"
		aname: field 300x30 40.40.40 font-name "consolas" font-size 10 font-color 180.180.180 bold on-change [ 
			unless noupdate [
				noupdate: true
				replace face/text " " "_"
				arcnodes/:sidx/name: copy face/text
			   	arclist/data/:sidx: rejoin [ pad/left/with to-string sidx 3 #"0" "^-" face/text ]
				noupdate: false
				arcspew
			]
		]
		aidx: text 60x30 font-name "consolas" font-size 16 font-color 80.80.80 bold with [ text: (quote (to-string sidx)) ]
		text 120x30 "poster" font-name "consolas" font-size 10 font-color 180.180.180 bold
		aiposter: image 300x300 on-up [
			aimgfile: request-file/filter ["pics" "*.jpg"]
			unless none? aimgfile [
				if exists? aimgfile [
					arcnodes/:sidx/poster: aimgfile
					face/image: load aimgfile
					unless none? face/image [
						aposter/text: to-string aimgfile
						nudgevv
					]
				]
			]
		]
		aposterpane: panel 45.45.45 [
			below
			aposter: text 300x30 "no poster" font-name "consolas" font-size 10 font-color 180.180.180 bold
			apubposter: button 300x30 font-name "consolas" font-size 10 font-color 180.180.180 bold "save poster to pub" [
				aposterfile: arcnodes/:sidx/poster
				unless none? aposterfile [
					if exists? aposterfile [
						make-dir %./pub
						clog: copy ""
						asrc: to-string aposterfile
						adst: to-file rejoin [ "./pub/arc_" sidx "_" arcnodes/:sidx/name ".jpg" ]
						call/wait/output rejoin [ "cp " asrc " " adst ] clog
						probe clog
					]
				]
			]
		]
		avideopane: panel 45.45.45 [
	    	text 120x30 "video" font-name "consolas" font-size 10 font-color 180.180.180 bold
			return
			avideo: text 40.40.40 200x30 "no video" font-name "consolas" font-size 10 font-color 180.180.180 bold
			apickvideo: button 80x30 "pick" font-name "consolas" font-size 10 font-color 180.180.180 bold [
				avidfile: request-file/filter ["mp4" "*.mp4"]
				unless none? avidfile [
					if exists? avidfile [
						arcnodes/:sidx/video: avidfile
						avideo/text: to-string avidfile
					]
				]
			]
			return
			apubvideo: button 300x30 "copy video to pub" font-name "consolas" font-size 10 font-color 180.180.180 bold [
				avidfile: arcnodes/:sidx/video
				unless none? avidfile [
					if exists? avidfile [
						make-dir %./pub
						clog: copy ""
						asrc: to-string avidfile
						adst: rejoin [ "./pub/arc_" sidx "_" arcnodes/:sidx/name ".mp4" ]
						call/wait/output rejoin [ "cp " asrc " " adst ] clog
						probe clog
					]
				]
			]
		]
		acardpane: panel 45.45.45 [
			below
			text 120x30 "card text" font-name "consolas" font-size 10 font-color 180.180.180 bold
			acardtxt: area 40.40.40 font-name "consolas" font-size 10 font-color 180.180.180 bold 300x90 on-change [
				unless noupdate [
					arcnodes/:sidx/cardtext: copy face/text
					arcspew
				]
			]
			text 120x30 "credits" font-name "consolas" font-size 10 font-color 180.180.180 bold
			acredits: area 40.40.40 300x300 font-name "consolas" font-size 10 font-color 180.180.180 bold on-change [
				unless noupdate [
					arcnodes/:sidx/credits: copy face/text
					arcspew
				]
			]
		]
	] on-drag [
	    face/offset/x: 0
		abbo: face/parent/size/y - face/size/y
		abbo: abbo - 55
		abbo: min abbo 0
	    face/offset/y: max abbo min face/offset/y 0
	] on-wheel [
		either event/picked > 0 [
			face/offset/y: face/offset/y + 40
		] [
			face/offset/y: face/offset/y - 40
		]
	    face/offset/x: 0
		abbo: face/parent/size/y - face/size/y
		abbo: abbo - 55
		abbo: min abbo 0
	    face/offset/y: max abbo min face/offset/y 0
	]
]

listnodes: function [ r nodes ] [
	o: copy[] 
	either r [
		sort/compare nodes func [a b] [
			case [
				a/index < b/index [-1] 
				a/index > b/index [1]
				a/index = b/index [0]
			]
		]
	] [
		sort/compare nodes func [a b] [
			case [
				a/index < b/index [1] 
				a/index > b/index [-1]
				a/index = b/index [0]
			]
		]
	]
	repeat i (length? nodes) [ nodes/(i)/index: i ]
	foreach n nodes [ append o rejoin [ pad/left/with to-string n/index 3 #"0" "^-" n/name ] ]
	o
]


txtnodes: copy []
if exists? %./txt_data.dat [
	txtnodes: do [ reduce  load %./txt_data.dat ]
	print [ "loaded txt_data into memory." ]
	probe txtnodes
]
inknodes: copy []
if exists? %./ink_data.dat [
	inknodes: do [ reduce  load %./ink_data.dat ]
	print [ "loaded ink_data into memory." ]
	probe inknodes
]
picnodes: copy []
if exists? %./pic_data.dat [
	picnodes: do [ reduce  load %./pic_data.dat ]
	print [ "loaded pic_data into memory." ]
	probe picnodes
]
arcnodes: copy []
if exists? %./arc_data.dat [
	arcnodes: do [ reduce  load %./arc_data.dat ]
	print [ "loaded arc_data into memory." ]
	probe arcnodes
]

sidx: 0
noupdate: true

nudgevv: func [] [
	vv/offset/y: 0
	vv/offset/x: min (max 500 vv/offset/x) 900
	swp/offset: 0x0
	uip/offset/x: 0
	uip/offset/y: swp/size/y
	aa/offset/x: 0
	bb/offset/x: 0
	cc/offset/x: vv/offset/x + 10 
	aa/size/x: vv/offset/x
	bb/size/x: vv/offset/x
	cc/size/x: cc/parent/size/x - cc/offset/x 
	hh/size/x: vv/offset/x
	aah/offset/x: 0
	bbh/offset/x: 0
	cch/offset/x: 0
	aah/size/x: aa/size/x
	bbh/size/x: bb/size/x
	cch/size/x: cc/size/x
	aap/offset/x: 0
	bbp/offset/x: 0
	ccp/offset/x: 0
	aap/size/x: aa/size/x
	bbp/size/x: bb/size/x
	ccp/size/x: cc/size/x
    attempt [ 
		txtlist/offset: 0x0 
		txtlist/size/x: aap/size/x 
		txtform/offset/x: 0 
		txtform/size/x: ccp/size/x 
		tname/size/x: txtform/size/x - 20 
		tposterpane/size/x: tname/size/x 
		tvideopane/size/x: tname/size/x
		tcardpane/size/x: tname/size/x
		tcardtxt/size/x: tname/size/x - 20
		tcardlink/size/x: tname/size/x - 20
		tposter/size/x: tname/size/x - 20 
		tpubposter/size/x: tposter/size/x
		tvideo/size/x: tposter/size/x - 85
		tpickvideo/offset/x: tvideo/offset/x + tvideo/size/x
		tpubvideo/size/x: tposter/size/x 
		fittopane tiposter to-pair compose [(ccp/size/x) (ccp/size/x) ] 
		tposterpane/offset/y: (tiposter/offset/y + tiposter/size/y) + 10
		tvideopane/offset/y: tposterpane/offset/y + tposterpane/size/y + 10
		tcardpane/offset/y: tvideopane/offset/y + tvideopane/size/y + 10
		txtform/size/y: (tcardpane/offset/y + tcardpane/size/y) + 40
	    txtform/offset/y: max (min ((ccp/size/y - txtform/size/y) - 55) 0 ) min txtform/offset/y 0
	]
    attempt [
		inklist/offset: 0x0 
	   	inklist/size/x: aap/size/x 
		inkform/offset/x: 0 
		inkform/size/x: ccp/size/x 
		iname/size/x: (inkform/size/x - 20) 
		iposterpane/size/x: iname/size/x 
		iposter/size/x: iposterpane/size/x - 20 
		ipubposter/size/x: iposter/size/x 
		fittopane iiposter to-pair compose [(ccp/size/x) (ccp/size/x) ] 
		iposterpane/offset/y: (iiposter/offset/y + iiposter/size/y) + 10 
		inkform/size/y: (iposterpane/offset/y + iposterpane/size/y) + 40
	    inkform/offset/y: max (min ((ccp/size/y - inkform/size/y) - 55) 0 ) min inkform/offset/y 0
	]
    attempt [ 
		piclist/offset: 0x0 
		piclist/size/x: aap/size/x 
		picform/offset/x: 0 
		picform/size/x: ccp/size/x 
		pname/size/x: picform/size/x - 20 
		pposterpane/size/x: pname/size/x 
		pvideopane/size/x: pname/size/x
		pcardpane/size/x: pname/size/x
		pcardtxt/size/x: pname/size/x - 20
		pcredits/size/x: pname/size/x - 20
		pposter/size/x: pname/size/x - 20 
		ppubposter/size/x: pposter/size/x
		pvideo/size/x: pposter/size/x - 85
		ppickvideo/offset/x: pvideo/offset/x + pvideo/size/x
		ppubvideo/size/x: pposter/size/x 
		fittopane piposter to-pair compose [(ccp/size/x) (ccp/size/x) ] 
		pposterpane/offset/y: (piposter/offset/y + piposter/size/y) + 10
		pvideopane/offset/y: pposterpane/offset/y + pposterpane/size/y + 10
		pcardpane/offset/y: pvideopane/offset/y + pvideopane/size/y + 10
		picform/size/y: (pcardpane/offset/y + pcardpane/size/y) + 40
	    picform/offset/y: max (min ((ccp/size/y - picform/size/y) - 55) 0 ) min picform/offset/y 0
	]
    attempt [ 
		arclist/offset: 0x0 
		arclist/size/x: aap/size/x 
		arcform/offset/x: 0 
		arcform/size/x: ccp/size/x 
		aname/size/x: arcform/size/x - 20 
		aposterpane/size/x: aname/size/x 
		avideopane/size/x: aname/size/x
		acardpane/size/x: aname/size/x
		acardtxt/size/x: aname/size/x - 20
		acredits/size/x: aname/size/x - 20
		aposter/size/x: aname/size/x - 20 
		apubposter/size/x: aposter/size/x
		avideo/size/x: aposter/size/x - 85
		apickvideo/offset/x: avideo/offset/x + avideo/size/x
		apubvideo/size/x: aposter/size/x 
		fittopane aiposter to-pair compose [(ccp/size/x) (ccp/size/x) ] 
		aposterpane/offset/y: (aiposter/offset/y + aiposter/size/y) + 10
		avideopane/offset/y: aposterpane/offset/y + aposterpane/size/y + 10
		acardpane/offset/y: avideopane/offset/y + avideopane/size/y + 10
		arcform/size/y: (acardpane/offset/y + acardpane/size/y) + 40
	    arcform/offset/y: max (min ((ccp/size/y - arcform/size/y) - 55) 0 ) min arcform/offset/y 0
	]
	attempt [ arclist/offset: 0x0 arclist/size/x: aap/size/x ]
	attempt [ haytie/offset: 0x0 haytie/size/x: bbp/size/x hsauce/offset: 0x0 hsauce/size: haytie/size houtput/offset: 0x0 houtput/size: haytie/size nrawdata/offset: 0x0 nrawdata/size: haytie/size ]
	vv/draw: compose/deep [ 
		pen off 
		fill-pen 100.100.100
		circle (to-pair compose/deep [5 (to-integer (vv/size/y * 0.5) - 10)]) 3 3 
		circle (to-pair compose/deep [5 (to-integer (vv/size/y * 0.5))]) 3 3
		circle (to-pair compose/deep [5 (to-integer (vv/size/y * 0.5) + 10)]) 3 3 
	]
]

nudgehh: func [] [
	hh/offset/x: 0
	hh/offset/y: min (max 200 hh/offset/y) 600
	swp/offset: 0x0
	uip/offset/x: 0
	uip/offset/y: swp/size/y
	aa/offset/y: 0
	bb/offset/y: hh/offset/y + 10
	cc/offset/y: 0
	aa/size/y: hh/offset/y
	bb/size/y: vv/size/y - hh/offset/y - 10
	cc/size/y: vv/size/y
	aah/offset/y: 0
	bbh/offset/y: 0
	cch/offset/y: 0
	aap/offset/y: 55
	bbp/offset/y: 55
	ccp/offset/y: 55
	aap/size/y: aa/size/y - 55
	bbp/size/y: bb/size/y - 55
	ccp/size/y: cc/size/y - 55
	attempt [ txtlist/offset: 0x0 txtlist/size/y: aap/size/y ]
	attempt [ inklist/offset: 0x0 inklist/size/y: aap/size/y ]
	attempt [ piclist/offset: 0x0 piclist/size/y: aap/size/y ]
	attempt [ arclist/offset: 0x0 arclist/size/y: aap/size/y ]
	attempt [ haytie/offset: 0x0 haytie/size/y: bbp/size/y hsauce/offset: 0x0 hsauce/size: haytie/size houtput/offset: 0x0 houtput/size: haytie/size nrawdata/offset: 0x0 nrawdata/size: haytie/size ]
	hh/draw: compose/deep [
		pen off
		fill-pen 100.100.100
		circle (to-pair compose/deep [(to-integer (hh/size/x * 0.5) - 10) 5]) 3 3 
		circle (to-pair compose/deep [(to-integer (hh/size/x * 0.5)) 5]) 3 3
		circle (to-pair compose/deep [(to-integer (hh/size/x * 0.5) + 10) 5]) 3 3 
	]
]

txtselect: func [] [
	sidx: to-integer txtlist/selected
	noupdate: true
	tname/text: copy txtnodes/(sidx)/name
	tidx/text: to-string txtnodes/(sidx)/index
	either exists? txtnodes/:sidx/poster [
		tposter/text: to-string txtnodes/:sidx/poster
		tiposter/image: load txtnodes/:sidx/poster
	] [ tposter/text: "no poster" tiposter/image: none ]
	either exists? txtnodes/:sidx/video [ 
		tvideo/text: to-string txtnodes/:sidx/video
	] [ tvideo/text: "no video" ]
	tcardtxt/text: copy txtnodes/:sidx/cardtext
	tcardlink/text: copy txtnodes/:sidx/cardlink
	txtspew
	noupdate: false
	nudgevv
]
inkselect: func [] [
	sidx: to-integer inklist/selected
	noupdate: true
	iname/text: copy inknodes/:sidx/name
	iidx/text: to-string inknodes/:sidx/index
	either exists? inknodes/:sidx/poster [
		iposterparts: split-path inknodes/:sidx/poster
		iposter/text: to-string inknodes/:sidx/poster
		iiposter/image: load inknodes/:sidx/poster
	] [ iposter/text: "no poster" iiposter/image: none ]
	inkspew
	noupdate: false
	nudgevv
]
picselect: func [] [
	sidx: to-integer piclist/selected
	noupdate: true
	pname/text: copy picnodes/:sidx/name
	pidx/text: to-string picnodes/:sidx/index
	either exists? picnodes/:sidx/poster [
		pposter/text: to-string picnodes/:sidx/poster
		piposter/image: load picnodes/:sidx/poster
	] [ pposter/text: "no poster" piposter/image: none ]
	either exists? picnodes/:sidx/video [ 
		pvideo/text: to-string picnodes/:sidx/video
	] [ pvideo/text: "no video" ]
	pcardtxt/text: copy picnodes/:sidx/cardtext
	pcredits/text: copy picnodes/:sidx/credits
	noupdate: false
	picspew
	nudgevv
]
arcselect: func [] [
	sidx: to-integer arclist/selected
	noupdate: true
	aname/text: copy arcnodes/:sidx/name
	aidx/text: to-string arcnodes/:sidx/index
	either exists? arcnodes/:sidx/poster [
		aposter/text: to-string arcnodes/:sidx/poster
		aiposter/image: load arcnodes/:sidx/poster
	] [ aposter/text: "no poster" aiposter/image: none ]
	either exists? arcnodes/:sidx/video [ 
		avideo/text: to-string arcnodes/:sidx/video
	] [ avideo/text: "no video" ]
	acardtxt/text: copy arcnodes/:sidx/cardtext
	acredits/text: copy arcnodes/:sidx/credits
	noupdate: false
	arcspew
	nudgevv
]
initui: func [] [
	noupdate false
	ccp/pane: layout/only txtformpane
	aap/pane: layout/only txtlistpane
	if (length? txtnodes) > 0 [
		txtlist/data: listnodes false txtnodes
	    sidx: 1
		txtlist/selected: sidx
		txtselect
   		hsauce/text: read %./txt_template.html
		txtspew
	]
	noupdate true
	nudgehh
	nudgevv
]

inkinit: func [] [
	noupdate false
	ccp/pane: layout/only inkformpane
	aap/pane: layout/only inklistpane
	if (length? inknodes) > 0 [
		inklist/data: listnodes false inknodes
	    sidx: 1
		inklist/selected: sidx
		inkselect
		hsauce/text: read %./ink_template.html
		inkspew
	]
	noupdate true
	nudgehh
	nudgevv
]

picinit: func [] [
	noupdate false
	ccp/pane: layout/only picformpane
	aap/pane: layout/only piclistpane
	if (length? picnodes) > 0 [
		piclist/data: listnodes false picnodes
	    sidx: 1
		piclist/selected: sidx
		picselect
		hsauce/text: read %./pic_template.html
		picspew
	]
	noupdate true
	nudgehh
	nudgevv
]
arcinit: func [] [
	noupdate false
	ccp/pane: layout/only arcformpane
	aap/pane: layout/only arclistpane
   	print [ "arcnode count =" length? arcnodes ]
	if (length? arcnodes) > 0 [
		arclist/data: listnodes false arcnodes
	    sidx: 1
		arclist/selected: sidx
		arcselect
		hsauce/text: read %./arc_template.html
		arcspew
	]
	noupdate true
	nudgehh
	nudgevv
]

txtspew: func [] [
	unless none? hsauce/text [
		unless hsauce/text = "" [
			txto: copy hsauce/text
			tnn: txtnodes/:sidx/name
			replace txto "[name]" tnn
			replace txto "[poster]" rejoin [ "./pub/txt_" sidx "_" tnn ".png" ]
		    replace txto "[video]" rejoin [ "./pub/txt_" sidx "_" tnn ".mp4" ]
			tbroke: replace copy txtnodes/:sidx/cardtext "^/" "<BR>"
		    replace txto "[cardlink]" txtnodes/:sidx/cardlink
		    replace txto "[cardtext]" tbroke
			nrawdata/text: mold copy txtnodes/:sidx
			houtput/text: copy txto
			clear txto
		]
	]
]
inkspew: func [] [
	unless none? hsauce/text [
		unless hsauce/text = "" [
			inko: copy hsauce/text
			inn: inknodes/:sidx/name
			replace inko "[name]" inn
			replace inko "[poster]" rejoin [ "./pub/ink_" sidx "_" inn ".png" ]
			houtput/text: copy inko
			nrawdata/text: mold copy inknodes/:sidx
			clear inko
		]
	]
]
picspew: func [] [
	unless none? hsauce/text [
		unless hsauce/text = "" [
			pxto: copy hsauce/text
			pnn: copy picnodes/:sidx/name
			replace/all pxto "[name]" pnn
			replace pxto "[poster]" rejoin [ "./pub/pic_" sidx "_" pnn ".png" ]
		    replace pxto "[video]" rejoin [ "./pub/pic_" sidx "_" pnn ".mp4" ]
			pbroke: copy picnodes/:sidx/credits
			parse pbroke [ any [ to "^/* " change "^/* " "^/<li>" pre: [ to "^/" change "^/" "</li>^/" | to end change end "</li>" end ] :pre ] ]
			parse pbroke [ any [ to "^/<li>" change "^/<li>" "<ul>^/<li>" ] ]
			parse pbroke [ any [ to "</li><ul>^/" change "</li><ul>^/"  "</li>^/" ] ]
			parse pbroke [ any [ to "</li>^/" change "</li>^/" "</li></ul>^/" ] ]
			parse pbroke [ any [ to "</li></ul>^/<li>" change "</li></ul>^/<li>"  "</li>^/<li>" ] ]
			;probe pbroke
			replace/all pbroke "^/" "<BR>"
		    replace pxto "[credits]" pbroke
			pbroke: replace copy picnodes/:sidx/cardtext "^/" "<BR>"
		    replace pxto "[cardtext]" pbroke
			nrawdata/text: mold copy picnodes/:sidx
			houtput/text: copy pxto
			clear pxto
		]
	]
]
arcspew: func [] [
	unless none? hsauce/text [
		unless hsauce/text = "" [
			axto: copy hsauce/text
			ann: copy arcnodes/:sidx/name
			replace/all axto "[name]" ann
			replace axto "[poster]" rejoin [ "./pub/pic_" sidx "_" ann ".jpg" ]
		    replace axto "[video]" rejoin [ "./pub/pic_" sidx "_" ann ".mp4" ]
			abroke: copy arcnodes/:sidx/credits
			parse abroke [ any [ to "^/* " change "^/* " "^/<li>" pre: [ to "^/" change "^/" "</li>^/" | to end change end "</li>" end ] :pre ] ]
			parse abroke [ any [ to "^/<li>" change "^/<li>" "<ul>^/<li>" ] ]
			parse abroke [ any [ to "</li><ul>^/" change "</li><ul>^/"  "</li>^/" ] ]
			parse abroke [ any [ to "</li>^/" change "</li>^/" "</li></ul>^/" ] ]
			parse abroke [ any [ to "</li></ul>^/<li>" change "</li></ul>^/<li>"  "</li>^/<li>" ] ]
			replace/all abroke "^/" "<BR>"
		    replace axto "[credits]" abroke
			abroke: replace copy arcnodes/:sidx/cardtext "^/" "<BR>"
		    replace axto "[cardtext]" abroke
			nrawdata/text: mold copy arcnodes/:sidx
			houtput/text: copy axto
			clear axto
			abroke: ""
		]
	]
]
view/tight [
	title "r21"
	below
	tp: tab-panel 1200x800 50.50.50 font-name "consolas" font-size 10 font-color 180.180.180 bold [
		"content" [
			below
			swp: panel 1200x55 35.35.35 [
				text 170x30 "page" font-name "consolas" font-size 24 font-color 60.60.60 bold
				seclist: drop-list 120x30 select 1 data [ "TXT" "INK" "PIC" "ARC" ] font-name "consolas" font-size 10 font-color 180.180.180 bold [
					switch face/selected [
						1 [ initui ]
						2 [ inkinit ]
						3 [ picinit ]
						4 [ arcinit ]
					]
				]
				button 200x33 "publish page" font-name "consolas" font-size 10 font-color 180.180.180 bold [
					headhtml: copy read %./site_header.html
					foothtml: copy read %./site_footer.html
					bodyhtml: copy { }
					sec: lowercase copy seclist/data/(seclist/selected)
					switch sec [
						"txt" [
							if (length? txtnodes) > 0 [
								make-dir %./pub
								call/wait "rm ./pub/txt_*.*"
								foreach n txtnodes [
									print [ "looking for poster : " n/poster ]
									if exists? n/poster [
										print [ "^-found poster : " n/poster ]
										tsrc: to-string n/poster
										tdst: to-file rejoin [ "./pub/txt_" pad/left/with to-string n/index 3 #"0" "_" n/name ".png" ]
										call/wait rejoin [ "cp " tsrc " " tdst ]
										print [ "^-copied poster to : " tdst ]
									]
								    print [ "looking for video : " n/video ]
									if exists? n/video [
								    	print [ "^-found video : " n/video ]
										tsrc: to-string n/video
										tdst: to-file rejoin [ "./pub/txt_" pad/left/with to-string n/index 3 #"0" "_" n/name ".mp4" ]
										call/wait rejoin [ "cp " tsrc " " tdst ]
										print [ "^-copied video to : " tdst ]
									]
									ths: copy read %./txt_template.html
									replace ths "[name]" n/name
								    vidf: rejoin [ "txt_" pad/left/with to-string n/index 3 #"0" "_" n/name ".mp4" ]
									posf: rejoin [ "txt_" pad/left/with to-string n/index 3 #"0" "_" n/name ".png" ]
									print [ "looking for published video : " rejoin [ "./pub/" vidf ] ]
									either exists? to-file rejoin [ "./pub/" vidf ] [
										print [ "^-found published video : " rejoin [ "./pub/" vidf ] ]
										replace ths "[VIDEO]" rejoin [ "<video class=^"vids^" preload=^"none^" poster=^"" posf "^" onclick=^"this.paused ? this.play() : this.pause();^">^/^-^-^-<source src=^"" vidf "^" type=^"video/mp4^">^/^-^-</video>" ]
									] [ 
										replace ths "[VIDEO]" rejoin [ "<img class=^"novids^" src=^"" posf "^">" ]
									]
									replace ths "[cardlink]" n/cardlink
									tcrd: copy n/cardtext
									replace/all tcrd "^/" "<BR>"
									replace ths "[cardtext]" tcrd
									bodyhtml: rejoin [ bodyhtml ths ]
								]
								replace headhtml "[IAMTXT]" "<td class=^"ts^" width=^"100px^">TXT</td>"
								replace headhtml "[IAMINK]" "<td class=^"tx^" width=^"100px^"><a href=^"ink.html^">INK</a></td>"
								replace headhtml "[IAMPIC]" "<td class=^"tx^" width=^"100px^"><a href=^"pic.html^">PIC</a></td>"
								replace headhtml "[IAMARC]" "<td class=^"tx^" width=^"100px^"><a href=^"arc.html^">ARC</a></td>"
								replace headhtml "[SECTIONTXT]" ""
								pubfile: rejoin [ headhtml bodyhtml foothtml ]
								write %./pub/txt.html pubfile
							]
						]
						"ink" [
							if (length? inknodes) > 0 [
								make-dir %./pub
								call/wait "rm ./pub/ink_*.*"
								foreach n inknodes [
									ihs: copy read %./ink_template.html
									replace ihs "[name]" n/name
									replace ihs "[poster]" rejoin [ "ink_" pad/left/with to-string n/index 3 #"0" "_" n/name ".png" ]
									bodyhtml: rejoin [ bodyhtml ihs ]
									if exists? n/poster [
										isrc: to-string n/poster
										idst: to-file rejoin [ "./pub/ink_" pad/left/with to-string n/index 3 #"0" "_" n/name ".png" ]
										call/wait rejoin [ "cp " isrc " " idst ]
									]
								]
								replace headhtml "[IAMTXT]" "<td class=^"tx^" width=^"100px^"><a href=^"txt.html^">TXT</a></td>"
								replace headhtml "[IAMINK]" "<td class=^"ts^" width=^"100px^">INK</td>"
								replace headhtml "[IAMPIC]" "<td class=^"tx^" width=^"100px^"><a href=^"pic.html^">PIC</a></td>"
								replace headhtml "[IAMARC]" "<td class=^"tx^" width=^"100px^"><a href=^"arc.html^">ARC</a></td>"
								replace headhtml "[SECTIONTXT]" ""
								pubfile: rejoin [ headhtml bodyhtml foothtml ]
								write %./pub/ink.html pubfile
							]
						]
						"pic" [
							if (length? picnodes) > 0 [
								make-dir %./pub
								call/wait rejoin [ "rm ./pub/pic_*.*" ]
								foreach n picnodes [
									phs: copy read %./pic_template.html
									replace/all phs "[name]" n/name
									replace phs "[poster]" rejoin [ "pic_" pad/left/with to-string n/index 3 #"0" "_" n/name ".png" ]
									replace phs "[video]" rejoin [ "pic_" pad/left/with to-string n/index 3 #"0" "_" n/name ".mp4" ]
									pcrd: copy n/cardtext
									replace/all pcrd "^/" "<BR>"
									replace phs "[cardtext]" pcrd
									pbroke: copy n/credits
									parse pbroke [ any [ to "^/* " change "^/* " "^/<li>" pre: [ to "^/" change "^/" "</li>^/" | to end change end "</li>" end ] :pre ] ]
									parse pbroke [ any [ to "^/<li>" change "^/<li>" "<ul>^/<li>" ] ]
									parse pbroke [ any [ to "</li><ul>^/" change "</li><ul>^/"  "</li>^/" ] ]
									parse pbroke [ any [ to "</li>^/" change "</li>^/" "</li></ul>^/" ] ]
									parse pbroke [ any [ to "</li></ul>^/<li>" change "</li></ul>^/<li>"  "</li>^/<li>" ] ]
									replace pbroke "^/" "<BR>"
									replace phs "[credits]" pbroke
									bodyhtml: rejoin [ bodyhtml phs ]
									if exists? n/poster [
										psrc: to-string n/poster
										pdst: to-file rejoin [ "./pub/pic_" pad/left/with to-string n/index 3 #"0" "_" n/name ".png" ]
										call/wait rejoin [ "cp " psrc " " pdst ]
									]
									if exists? n/video [
										psrc: to-string n/video
										pdst: to-file rejoin [ "./pub/pic_" pad/left/with to-string n/index 3 #"0" "_" n/name ".mp4" ]
										call/wait rejoin [ "cp " psrc " " pdst ]
									]
								]
								replace headhtml "[IAMTXT]" "<td class=^"tx^" width=^"100px^"><a href=^"txt.html^">TXT</a></td>"
								replace headhtml "[IAMINK]" "<td class=^"tx^" width=^"100px^"><a href=^"ink.html^">INK</a></td>"
								replace headhtml "[IAMPIC]" "<td class=^"ts^" width=^"100px^">PIC</td>"
								replace headhtml "[IAMARC]" "<td class=^"tx^" width=^"100px^"><a href=^"arc.html^">ARC</a></td>"
								replace headhtml "[SECTIONTXT]" ""
								pubfile: rejoin [ headhtml bodyhtml foothtml ]
								write %./pub/pic.html pubfile
							]
						]
						"arc" [
							if (length? arcnodes) > 0 [
								make-dir %./pub
								call/wait rejoin [ "rm ./pub/arc_*.*" ]
								foreach n arcnodes [
									if exists? n/poster [
										asrc: to-string n/poster
										adst: to-file rejoin [ "./pub/arc_" pad/left/with to-string n/index 3 #"0" "_" n/name ".jpg" ]
										call/wait rejoin [ "cp " asrc " " adst ]
									]
									if exists? n/video [
										asrc: to-string n/video
										adst: to-file rejoin [ "./pub/arc_" pad/left/with to-string n/index 3 #"0" "_" n/name ".mp4" ]
										call/wait rejoin [ "cp " asrc " " adst ]
									]
									ahs: copy read %./arc_template.html
									replace/all ahs "[name]" n/name
								    vidf: rejoin [ "arc_" pad/left/with to-string n/index 3 #"0" "_" n/name ".mp4" ]
									posf: rejoin [ "arc_" pad/left/with to-string n/index 3 #"0" "_" n/name ".jpg" ]
									either exists? to-file rejoin [ "./pub/" vidf ] [
										replace ahs "[VIDEO]" rejoin [ "<video class=^"vids^" preload=^"none^" poster=^"" posf "^" onclick=^"this.paused ? this.play() : this.pause();^">^/^-^-^-<source src=^"" vidf "^" type=^"video/mp4^">^/^-^-</video>" ]
									] [ 
										replace ahs "[VIDEO]" rejoin [ "<img class=^"novids^" src=^"" posf "^">" ]
									]
									acrd: copy n/cardtext
									replace/all acrd "^/" "<BR>"
									replace ahs "[cardtext]" acrd
									abroke: copy n/credits
									parse abroke [ any [ to "^/* " change "^/* " "^/<li>" pre: [ to "^/" change "^/" "</li>^/" | to end change end "</li>" end ] :pre ] ]
									parse abroke [ any [ to "^/<li>" change "^/<li>" "<ul>^/<li>" ] ]
									parse abroke [ any [ to "</li><ul>^/" change "</li><ul>^/"  "</li>^/" ] ]
									parse abroke [ any [ to "</li>^/" change "</li>^/" "</li></ul>^/" ] ]
									parse abroke [ any [ to "</li></ul>^/<li>" change "</li></ul>^/<li>"  "</li>^/<li>" ] ]
									replace/all abroke "^/" "<BR>"
									replace ahs "[credits]" abroke
									bodyhtml: rejoin [ bodyhtml ahs ]
								]
								replace headhtml "[IAMTXT]" "<td class=^"tx^" width=^"100px^"><a href=^"txt.html^">TXT</a></td>"
								replace headhtml "[IAMINK]" "<td class=^"tx^" width=^"100px^"><a href=^"ink.html^">INK</a></td>"
								replace headhtml "[IAMPIC]" "<td class=^"tx^" width=^"100px^"><a href=^"pic.html^">PIC</a></td>"
								replace headhtml "[IAMARC]" "<td class=^"ts^" width=^"100px^">ARC</td>"
								replace headhtml "[SECTIONTXT]" ""
								pubfile: rejoin [ headhtml bodyhtml foothtml ]
								write %./pub/arc.html pubfile
							]
						]
					]		
				]
				stts: text 500x30 "" font-name "consolas" font-size 8 font-color 40.128.40 
			]
			uip: panel 1200x750 45.45.45 [
				below
				aa: panel 800x300 [
					below
					aah: panel 45.45.45 800x55 [
						text 170x30 "articles" font-name "consolas" font-size 24 font-color 80.80.80 bold
						button 30x33 "+" font-name "consolas" font-size 10 font-color 180.180.180 bold [
							sec: lowercase copy seclist/data/(seclist/selected)
							switch sec [
								"txt" [ 
									foreach n txtnodes [ if n/index >= sidx [ n/index: (n/index + 1) ] ]
									append txtnodes copy txtitem 
									txtnodes/(length? txtnodes)/index: sidx
									noupdate true clear txtlist/data noupdate: false
									txtlist/data: listnodes false txtnodes
									txtlist/selected: sidx
									hsauce/text: read %./txt_template.html
									txtselect
								]
								"ink" [ 
									foreach n inknodes [ if n/index >= sidx [ n/index: (n/index + 1) ] ]
									append inknodes copy txtitem 
									inknodes/(length? inknodes)/index: sidx
									noupdate: true clear inklist/data noupdate: false
									inklist/data: listnodes false inknodes
									inklist/selected: sidx
									hsauce/text: read %./ink_template.html
									inkselect
								]
								"pic" [ 
									foreach n picnodes [ if n/index >= sidx [ n/index: (n/index + 1) ] ]
									append picnodes copy txtitem 
									picnodes/(length? picnodes)/index: sidx
									noupdate true clear piclist/data noupdate: false
									piclist/data: listnodes false picnodes
									piclist/selected: sidx
									hsauce/text: read %./pic_template.html
									picselect
								]
								"arc" [ 
									foreach n arcnodes [ if n/index >= sidx [ n/index: (n/index + 1) ] ]
									append arcnodes copy txtitem 
									arcnodes/(length? arcnodes)/index: sidx
									noupdate true clear arclist/data noupdate: false
									arclist/data: listnodes false arcnodes
									arclist/selected: sidx
									hsauce/text: read %./arc_template.html
									arcselect
								]
							]
						]
						pad 5x0
						button 30x33 "-" font-name "consolas" font-size 10 font-color 180.180.180 bold [
							if sidx > 0 [
								sec: lowercase copy seclist/data/(seclist/selected)
								switch sec [
									"txt" [ 
									    remove-each n txtnodes [ n/index = sidx ]
										either (length? txtnodes) > 0 [
										    unless sidx = 1 [ sidx: sidx - 1 ]
											clear txtlist/data
											txtlist/data: listnodes false txtnodes
											txtlist/selected: sidx
											txtselect txtspew 
										] [
											houtput/text: copy hsauce/text
											noupdate: true
											tname/text: none
											tidx/text: none
											timage/image: none
											tposter/text: "no poster"
											tvideo/text: "no video"
											tcardtxt/text: none
											tcardlink/text: none
											noupdate: false
										]
									]
									"ink" [ 
									    remove-each n inknodes [ n/index = sidx ]
										either (length? inknodes) > 0 [
										    unless sidx = 1 [ sidx: sidx - 1 ]
											clear inklist/data
											inklist/data: listnodes false inknodes
											inklist/selected: sidx
											inkselect inkspew 
										] [
											houtput/text: copy hsauce/text
											noupdate: true
											iname/text: none
											iidx/text: none
											iimage/image: none
											iposter/text: "no poster"
											noupdate: false
										]
									]
									"pic" [ 
									    remove-each n picnodes [ n/index = sidx ]
										either (length? picnodes) > 0 [
										    unless sidx = 1 [ sidx: sidx - 1 ]
											clear piclist/data
											piclist/data: listnodes false picnodes
											piclist/selected: sidx
											picselect
										] [
											houtput/text: copy hsauce/text
											noupdate: true
											pname/text: none
											pidx/text: none
											pimage/image: none
											pposter/text: "no poster"
											pvideo/text: "no video"
											pcardtxt/text: none
											pcredits/text: none
											noupdate: false
										]
									]
									"arc" [ 
									    remove-each n arcnodes [ n/index = sidx ]
										either (length? arcnodes) > 0 [
										    unless sidx = 1 [ sidx: sidx - 1 ]
											clear arclist/data
											arclist/data: listnodes false arcnodes
											arclist/selected: sidx
											arcselect
										] [
											houtput/text: copy hsauce/text
											noupdate: true
											aname/text: none
											aidx/text: none
											aimage/image: none
											aposter/text: "no poster"
											avideo/text: "no video"
											acardtxt/text: none
											acredits/text: none
											noupdate: false
										]
									]
						 		]
							]  	
						]
						pad 5x0
					    button 30x33 "▼" font-name "consolas" font-size 10 font-color 180.180.180 bold [ 
							sec: lowercase copy seclist/data/(seclist/selected)
							unless sidx < 1 [
								switch sec [
									"txt" [
										if sidx < (length? txtnodes) [
											nidx: sidx + 1
											txtnodes/:sidx/index: nidx
											txtnodes/:nidx/index: sidx
											sidx: nidx
											clear txtlist/data
											txtlist/data: listnodes false txtnodes
											txtlist/selected: sidx
											txtselect
										]
 									]
									"ink" [ 
										if sidx < (length? inknodes) [
											nidx: sidx + 1
											inknodes/:sidx/index: nidx
											inknodes/:nidx/index: sidx
											sidx: nidx
											clear inklist/data
											inklist/data: listnodes false inknodes
											inklist/selected: sidx
											inkselect
										]
									]
									"pic" [
										if sidx < (length? picnodes) [
											nidx: sidx + 1
											picnodes/:sidx/index: nidx
											picnodes/:nidx/index: sidx
											sidx: nidx
											clear piclist/data
											piclist/data: listnodes false picnodes
											piclist/selected: sidx
											picselect
										]
 									]
									"arc" [
										if sidx < (length? arcnodes) [
											nidx: sidx + 1
											arcnodes/:sidx/index: nidx
											arcnodes/:nidx/index: sidx
											sidx: nidx
											clear arclist/data
											arclist/data: listnodes false arcnodes
											arclist/selected: sidx
											arcselect
										]
 									]
								]
							]
						]
						pad 5x0
					    button 30x33 "▲" font-name "consolas" font-size 10 font-color 180.180.180 bold [ 
							sec: lowercase copy seclist/data/(seclist/selected)
							unless sidx < 1 [
								switch sec [
									"txt" [
										if sidx > 1 [
											nidx: sidx - 1
											txtnodes/:sidx/index: nidx
											txtnodes/:nidx/index: sidx
											sidx: nidx
											clear txtlist/data
											txtlist/data: listnodes false txtnodes
											txtlist/selected: sidx
											txtselect
										]
 									]
									"ink" [ 
										if sidx > 1 [
											nidx: sidx - 1
											inknodes/:sidx/index: nidx
											inknodes/:nidx/index: sidx
											sidx: nidx
											clear inklist/data
											inklist/data: listnodes false inknodes
											inklist/selected: sidx
											inkselect
										]
									]
									"pic" [
										if sidx > 1 [
											nidx: sidx - 1
											picnodes/:sidx/index: nidx
											picnodes/:nidx/index: sidx
											sidx: nidx
											clear piclist/data
											piclist/data: listnodes false picnodes
											piclist/selected: sidx
											picselect
										]
 									]
									"arc" [
										if sidx > 1 [
											nidx: sidx - 1
											arcnodes/:sidx/index: nidx
											arcnodes/:nidx/index: sidx
											sidx: nidx
											clear arclist/data
											arclist/data: listnodes false arcnodes
											arclist/selected: sidx
											arcselect
										]
 									]
								]
							]
						]
						pad 5x0
					    button 120x33 "reverse" font-name "consolas" font-size 10 font-color 180.180.180 bold [
							sec: lowercase copy seclist/data/(seclist/selected)
							switch sec [
								"txt" [
									nc: (length? txtnodes) 
									;foreach n txtnodes [ n/index: ((nc + 1) - n/index) ] 
									clear txtlist/data
									sidx: txtnodes/:sidx/index
									txtlist/data: listnodes true txtnodes
									txtlist/selected: sidx
								    txtselect 
								]
								"ink" [
									nc: (length? inknodes) 
									;foreach n inknodes [ n/index: ((nc + 1) - n/index) ] 
									clear inklist/data
									sidx: inknodes/:sidx/index
									inklist/data: listnodes true inknodes
									inklist/selected: sidx
								    inkselect 
								]
								"pic" [  
									nc: (length? picnodes) 
									;foreach n picnodes [ n/index: ((nc + 1) - n/index) ] 
									clear piclist/data
									sidx: picnodes/:sidx/index
									piclist/data: listnodes true picnodes
									piclist/selected: sidx
								    picselect 
								]
								"arc" [ 
									nc: (length? arcnodes) 
									;foreach n arcnodes [ n/index: ((nc + 1) - n/index) ] 
									clear arclist/data
									sidx: arcnodes/:sidx/index
									arclist/data: listnodes true arcnodes
									arclist/selected: sidx
								    arcselect 
								]
							]
						]
						pad 10x0 button 120x32 "save list" font-name "consolas" font-size 10 font-color 180.180.180 bold [
							sec: lowercase copy seclist/data/(seclist/selected)
						    od:  to-file rejoin [ "./" sec "_data.dat" ]
							switch sec [
								"txt" [ write od txtnodes stts/text: rejoin [ "wrote: txtnodes to " od ] ]
								"ink" [ write od inknodes stts/text: rejoin [ "wrote: inknodes to " od ] ]
								"pic" [ write od picnodes stts/text: rejoin [ "wrote: picnodes to " od ] ]
								"arc" [ write od arcnodes stts/text: rejoin [ "wrote: arcnodes to " od ] ]
							]
						]
						
					]
					aap: panel 800x245 []
				]
				hh: panel 800x10 35.35.35 loose draw [ ] on-drag [ nudgehh ]
				bb: panel 800x440 [
					below
					bbh: panel 45.45.45 800x55 [
						text 120x30 "html" font-name "consolas" font-size 24 font-color 80.80.80 bold
						button 200x33 "reload template" font-name "consolas" font-size 10 font-color 180.180.180 bold [ 
							sec: lowercase copy seclist/data/(seclist/selected)
							hsauce/text: read to-file rejoin [ "./" sec "_template.html" ] 
						] 
						button 200x33 "save template"  font-name "consolas" font-size 10 font-color 180.180.180 bold [
							sec: lowercase copy seclist/data/(seclist/selected)
							unless none? hsauce/text [
								unless hsauce/text = "" [
									make-dir %./backup
									tstamp: makemeatimestamp
								    write to-file rejoin ["./backup/" sec "_template_" tstamp ".html"] read to-file rejoin [ "./" sec "_template.html" ] 
									write to-file rejoin [ "./" sec "_template.html" ] hsauce/text
								]
							]
						]
					]
					bbp: panel 800x385 [ 
						haytie: tab-panel 800x385 font-name "consolas" font-size 10 font-color 180.180.180 bold [
							"source" [
								hsauce: area 800x385 40.40.40 font-name "consolas" font-size 10 font-color 128.255.128
							]
							"output" [
								houtput: area 800x385 40.40.40 font-name "consolas" font-size 10 font-color 255.128.128
							]
							"raw data" [
								nrawdata: area 800x385 40.40.40 font-name "consolas" font-size 10 font-color 128.128.255
							]
						]
					]
				]
				return
				vv: panel 10x750 35.35.35 loose draw [ ] on-drag [ nudgevv ]
				return
				cc: panel 300x750  [
					below
					cch: panel 45.45.45 800x55 [ text "param" font-name "consolas" font-size 24 font-color 80.80.80 bold ]
					ccp: panel 50.50.50 800x695 []
				]
			]
		]
		"setup" [
			below
			utl: panel 1200x55 35.35.35 [
				text 170x30 "section" font-name "consolas" font-size 24 font-color 80.80.80 bold
				srcseclist: drop-list font-name "consolas" font-size 10 font-color 180.180.180 bold data [ "header" "footer" ] [
					switch srcseclist/selected [
						1 [	src/text: read %./site_header.html ]
						2 [ src/text: read %./site_footer.html ]
					]
				]
				button 120x33 "reload" font-name "consolas" font-size 10 font-color 180.180.180 bold  [
					switch srcseclist/selected [
						1 [	src/text: read %./site_header.html ]
						2 [ src/text: read %./site_footer.html ]
					]
				]
				button 120x33 "save" font-name "consolas" font-size 10 font-color 180.180.180 bold [
					switch srcseclist/selected [
						1 [	
							unless none? src/text [
								unless src/text = "" [
									make-dir %./backup
									tstamp: makemeatimestamp
								    write to-file rejoin ["./backup/site_header_" tstamp ".html"] read %./site_header.html
									write %./site_header.html src/text
								]
							]
						]
						2 [ 
							unless none? src/text [
								unless src/text = "" [
									make-dir %./backup
									tstamp: makemeatimestamp
									write to-file rejoin ["./backup/site_footer_" tstamp ".html"] read %./site_footer.html
									write %./site_footer.html src/text
								]
							]
						]
					]
				]
			]
			srcpane: panel 1200x745 [
				src: area 1200x745 40.40.40 font-name "consolas" font-size 10 font-color 80.255.180
			]
		]
	]
	do [
		seclist/selected: 1
		initui
		utl/offset: 0x0
		srcpane/offset/x: 0
		srcpane/offset/y: utl/size/y
		src/offset: 0x0
	]
]
			
	 
