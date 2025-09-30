$PBExportHeader$w_pdt_02115.srw
$PBExportComments$작업공정 조회
forward
global type w_pdt_02115 from w_inherite
end type
type dw_1 from datawindow within w_pdt_02115
end type
type dw_2 from u_key_enter within w_pdt_02115
end type
type shl_1 from statichyperlink within w_pdt_02115
end type
type shl_2 from statichyperlink within w_pdt_02115
end type
type gb_1 from groupbox within w_pdt_02115
end type
type gb_2 from groupbox within w_pdt_02115
end type
type rr_1 from roundrectangle within w_pdt_02115
end type
type rr_2 from roundrectangle within w_pdt_02115
end type
end forward

global type w_pdt_02115 from w_inherite
integer height = 2408
string title = "작업공정조회"
dw_1 dw_1
dw_2 dw_2
shl_1 shl_1
shl_2 shl_2
gb_1 gb_1
gb_2 gb_2
rr_1 rr_1
rr_2 rr_2
end type
global w_pdt_02115 w_pdt_02115

on w_pdt_02115.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_2=create dw_2
this.shl_1=create shl_1
this.shl_2=create shl_2
this.gb_1=create gb_1
this.gb_2=create gb_2
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.shl_1
this.Control[iCurrent+4]=this.shl_2
this.Control[iCurrent+5]=this.gb_1
this.Control[iCurrent+6]=this.gb_2
this.Control[iCurrent+7]=this.rr_1
this.Control[iCurrent+8]=this.rr_2
end on

on w_pdt_02115.destroy
call super::destroy
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.shl_1)
destroy(this.shl_2)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_1.insertrow(0)
dw_2.settransobject(sqlca)
dw_insert.settransobject(sqlca)
dw_1.setfocus()

end event

type dw_insert from w_inherite`dw_insert within w_pdt_02115
integer x = 105
integer y = 720
integer width = 4434
integer height = 1576
string title = "공정상세조회"
string dataobject = "d_pdt_02115_03"
boolean vscrollbar = true
boolean border = false
end type

type p_delrow from w_inherite`p_delrow within w_pdt_02115
boolean visible = false
end type

type p_addrow from w_inherite`p_addrow within w_pdt_02115
boolean visible = false
end type

type p_search from w_inherite`p_search within w_pdt_02115
boolean visible = false
integer x = 3227
end type

type p_ins from w_inherite`p_ins within w_pdt_02115
boolean visible = false
integer x = 3749
end type

type p_exit from w_inherite`p_exit within w_pdt_02115
end type

type p_can from w_inherite`p_can within w_pdt_02115
end type

event p_can::clicked;call super::clicked;dw_insert.reset()
dw_2.reset()
dw_1.reset()
dw_1.insertrow(0)
dw_1.setfocus()


end event

type p_print from w_inherite`p_print within w_pdt_02115
boolean visible = false
integer x = 3401
end type

type p_inq from w_inherite`p_inq within w_pdt_02115
integer x = 4096
end type

event p_inq::clicked;call super::clicked;string ls_order_no, sgub

if dw_1.accepttext() <> 1 then return -1

sgub        = dw_1.getitemstring(1,'gub')
ls_order_no = Trim(dw_1.getitemstring(1,'order_no'))

if sgub = '1' then 
	if ls_order_no = "" or isnull(ls_order_no) then
		f_message_chk(30,'[수주번호]')
		dw_1.setfocus()
		return 1
	end if
else
	if ls_order_no = "" or isnull(ls_order_no) then
		f_message_chk(30,'[가공작지번호]')
		dw_1.setfocus()
		return 1
	end if
end if

dw_2.reset()
dw_insert.reset()

if sgub = '1' then 
	if dw_2.retrieve(gs_sabu,ls_order_no) < 1 then
		f_message_chk(300,'')
		dw_1.setfocus()
		return 1
	end if
else
	dw_2.insertrow(0)
	dw_2.setitem(1, 'pordno', ls_order_no)
end if
end event

type p_del from w_inherite`p_del within w_pdt_02115
boolean visible = false
end type

type p_mod from w_inherite`p_mod within w_pdt_02115
boolean visible = false
end type

type cb_exit from w_inherite`cb_exit within w_pdt_02115
boolean visible = false
integer x = 3461
integer y = 320
end type

type cb_mod from w_inherite`cb_mod within w_pdt_02115
boolean visible = false
integer x = 882
integer y = 2284
end type

type cb_ins from w_inherite`cb_ins within w_pdt_02115
boolean visible = false
integer x = 480
integer y = 2280
end type

type cb_del from w_inherite`cb_del within w_pdt_02115
boolean visible = false
integer x = 1294
integer y = 2288
end type

type cb_inq from w_inherite`cb_inq within w_pdt_02115
boolean visible = false
integer x = 2629
integer y = 304
end type

type cb_print from w_inherite`cb_print within w_pdt_02115
boolean visible = false
integer x = 2048
integer y = 2284
end type

type st_1 from w_inherite`st_1 within w_pdt_02115
end type

type cb_can from w_inherite`cb_can within w_pdt_02115
boolean visible = false
integer x = 3081
integer y = 320
end type

type cb_search from w_inherite`cb_search within w_pdt_02115
boolean visible = false
integer y = 2288
end type







type gb_button1 from w_inherite`gb_button1 within w_pdt_02115
end type

type gb_button2 from w_inherite`gb_button2 within w_pdt_02115
end type

type dw_1 from datawindow within w_pdt_02115
event ue_key pbm_dwnkey
integer x = 96
integer y = 12
integer width = 2523
integer height = 200
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_pdt_02115"
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;string ls_order_no, snull, sempno,  scvnas,  sareanm
long   ll_count

setnull(snull)

Choose Case this.getcolumnname()
 Case "gub"
	   dw_2.reset()
	   dw_insert.reset()
		this.setitem(1, 'order_no', snull)
		this.setitem(1, 'cvnas', snull)
		this.setitem(1, 'area', snull)
		this.setitem(1, 'empno', snull)
 Case "order_no"
		ls_order_no = Trim(this.GetText())
		
		IF ls_order_no = '' or isnull(ls_order_no) then 
			this.setitem(1, 'cvnas', snull)
			this.setitem(1, 'area', snull)
			this.setitem(1, 'empno', snull)
			return 
		end if

      if this.getitemstring(1, 'gub') = '1' then // 수주번호
			SELECT A.EMP_ID, B.CVNAS2, C.SAREANM
			  INTO :sempno,  :scvnas,  :sareanm
			  FROM SORDER A, VNDMST B, SAREA C  
			 WHERE A.SABU     = :gs_sabu 
				AND A.ORDER_NO = :ls_order_no
				AND A.CVCOD    = B.CVCOD(+)
				AND B.SAREA    = C.SAREA(+)  ;
				
			IF sqlca.sqlcode <> 0 THEN 
				MessageBox('확 인', '수주번호를 확인하세요!')
				this.setitem(1, 'order_no', snull)
				this.setitem(1, 'cvnas', snull)
				this.setitem(1, 'area', snull)
				this.setitem(1, 'empno', snull)
				Return 1
			END IF
			
			this.setitem(1, 'cvnas', scvnas)
			this.setitem(1, 'area',  sareanm)
			this.setitem(1, 'empno', sempno)
		else   //가공작지번호
		  SELECT A.ITNBR
			 INTO :sempno
			 FROM MOMAST A
			WHERE A.SABU   = :gs_sabu
			  AND A.PORDNO = :ls_order_no;
		
			if sqlca.sqlcode <> 0 then 
				messagebox('확 인', '등록된 작지번호가 아닙니다. 자료를 확인하세요!')
				this.setitem(1, 'order_no', snull)
				return 1
			end if
		end if
		cb_inq.triggerevent(clicked!)
End Choose

end event

event rbuttondown;setnull( gs_code) 
setnull( gs_codename )
setnull( gs_gubun ) 

IF this.GetColumnName() = 'order_no'	THEN
   if this.getitemstring(1, 'gub') = '1' then // 수주번호
		Open(w_suju_popup)
	else
		gs_gubun = '30' 
		open(w_jisi_popup)
	end if
	IF gs_code = '' or isnull(gs_code) then return 
	SetItem(1, "order_no", gs_code)
	this.triggerevent(itemchanged!)
END IF
end event

event itemerror;RETURN 1
end event

type dw_2 from u_key_enter within w_pdt_02115
integer x = 114
integer y = 304
integer width = 1499
integer height = 276
integer taborder = 11
boolean bringtotop = true
string title = "상위공정"
string dataobject = "d_pdt_02115_01"
boolean vscrollbar = true
boolean border = false
end type

event clicked;string ls_pordno

if row > 0 then
	This.SelectRow(0, FALSE)
	This.SelectRow(row, TRUE)
	
	ls_pordno = Trim(this.getitemstring(row,'pordno'))
	
	dw_insert.retrieve(gs_sabu,ls_pordno)
	dw_insert.title = '상위공정 상세 조회'
end if
end event

type shl_1 from statichyperlink within w_pdt_02115
integer x = 114
integer y = 244
integer width = 517
integer height = 52
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string pointer = "HyperLink!"
long textcolor = 8388608
long backcolor = 32106727
string text = "상위공정"
boolean focusrectangle = false
end type

type shl_2 from statichyperlink within w_pdt_02115
integer x = 114
integer y = 660
integer width = 517
integer height = 52
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string pointer = "HyperLink!"
long textcolor = 8388608
long backcolor = 32106727
string text = "공정상세조회"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_pdt_02115
boolean visible = false
integer x = 3045
integer y = 272
integer width = 786
integer height = 180
integer taborder = 11
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = styleraised!
end type

type gb_2 from groupbox within w_pdt_02115
boolean visible = false
integer x = 2592
integer y = 256
integer width = 411
integer height = 180
integer taborder = 21
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = styleraised!
end type

type rr_1 from roundrectangle within w_pdt_02115
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 96
integer y = 296
integer width = 1550
integer height = 296
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pdt_02115
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 96
integer y = 712
integer width = 4498
integer height = 1596
integer cornerheight = 40
integer cornerwidth = 55
end type

