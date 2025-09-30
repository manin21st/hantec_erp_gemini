$PBExportHeader$w_sal_04300.srw
$PBExportComments$수주 이력
forward
global type w_sal_04300 from w_inherite
end type
type pb_3 from picturebutton within w_sal_04300
end type
type pb_4 from picturebutton within w_sal_04300
end type
type pb_2 from picturebutton within w_sal_04300
end type
type pb_1 from picturebutton within w_sal_04300
end type
type dw_1 from datawindow within w_sal_04300
end type
type dw_2 from datawindow within w_sal_04300
end type
type tv_1 from uo_sorder_history_tree within w_sal_04300
end type
type gb_3 from groupbox within w_sal_04300
end type
type rr_1 from roundrectangle within w_sal_04300
end type
type rr_2 from roundrectangle within w_sal_04300
end type
end forward

global type w_sal_04300 from w_inherite
integer height = 2392
string title = "수주 진행 History"
pb_3 pb_3
pb_4 pb_4
pb_2 pb_2
pb_1 pb_1
dw_1 dw_1
dw_2 dw_2
tv_1 tv_1
gb_3 gb_3
rr_1 rr_1
rr_2 rr_2
end type
global w_sal_04300 w_sal_04300

forward prototypes
public subroutine wf_scroll (integer ar_scroll)
end prototypes

public subroutine wf_scroll (integer ar_scroll);// ar_sCroll [ 1:First, 2:Next, 3:Prior, 4:Last ]

dw_1.accepttext()
String ar_order, sordno

ar_order = dw_1.getitemstring(1, "order_no")
if isnull(ar_order) or trim(ar_order) = '' then
	ar_order = '.'
End if

SetNull(sOrdno)

w_mdi_frame.sle_msg.text = '수주자료를 Scroll중 입니다'

String soversea_gu, scvcod, sdamdang

if dw_1.accepttext() = -1 then return

soversea_gu = dw_1.getitemstring(1, "oversea_gu")
scvcod      = dw_1.getitemstring(1, "cvcod")
sdamdang    = dw_1.getitemstring(1, "damdang")

Choose Case ar_scroll
		 Case 1
				Select Min(Substr(a.order_no, 1, length(a.order_no)-3))
				  into :sordno
				  From sorder a, exppih b
				 Where a.sabu 		= b.sabu (+)
				 	and a.pino	 	= b.pino (+)
				 	and nvl(a.cvcod, '.') Like :scvcod||'%'
				   and nvl(a.cvpln, '.') Like :sdamdang||'%'
					and decode(a.oversea_gu, '1', '1', decode(nvl(b.localyn, 'N'), 'Y', '3', '2')) Like :soversea_gu;
				if ar_order = sordno then
					w_mdi_frame.sle_msg.text = ''
					MessageBox("수주검색", "자료의 시작입니다", information!)
					return
				End if
		 Case 3
				Select Min(Substr(a.order_no, 1, length(a.order_no)-3))
				  into :sordno
				  From sorder a, exppih b
				 where a.sabu 	 = :gs_sabu
				   And a.order_no > :ar_order||'999'
					and a.sabu 		= b.sabu (+)
				 	and a.pino	 	= b.pino (+)
				 	and nvl(a.cvcod, '.') Like :scvcod||'%'
				   and nvl(a.cvpln, '.') Like :sdamdang||'%'
					and decode(a.oversea_gu, '1', '1', decode(nvl(b.localyn, 'N'), 'Y', '3', '2')) Like :soversea_gu;					
		 Case 2
				Select Max(Substr(a.order_no, 1, length(a.order_no)-3))
				  into :sordno
				  From sorder a, exppih b
				 where a.sabu 	 = :gs_sabu
				   And a.order_no < :ar_order
					and a.sabu 		= b.sabu (+)
				 	and a.pino	 	= b.pino (+)					
				 	and nvl(a.cvcod, '.') Like :scvcod||'%'
				   and nvl(a.cvpln, '.') Like :sdamdang||'%'
					and decode(a.oversea_gu, '1', '1', decode(nvl(b.localyn, 'N'), 'Y', '3', '2')) Like :soversea_gu;					
		 Case 4
				Select Max(Substr(a.order_no, 1, length(a.order_no)-3))
				  into :sordno
				  From sorder a, exppih b
	  			 where a.sabu 		= b.sabu (+)
				 	and a.pino	 	= b.pino (+)
				   and nvl(a.cvcod, '.') Like :scvcod||'%'
				   and nvl(a.cvpln, '.') Like :sdamdang||'%'
					and decode(a.oversea_gu, '1', '1', decode(nvl(b.localyn, 'N'), 'Y', '3', '2')) Like :soversea_gu;				  
				if ar_order = sordno then
					w_mdi_frame.sle_msg.text = ''					
					MessageBox("수주검색", "자료의 끝 입니다", information!)
					return
				End if				  
End Choose;

if sqlca.sqlcode <> 0 then
	MessageBox("Scroll", "Scroll검색이 실패하였읍니다", stopsign!)
	w_mdi_frame.sle_msg.text = ''	
	return
End if	 

if isnull(sOrdno) or trim(sOrdno) = '' then
	MessageBox("수주검색", "더 이상 검색할 자료가 없읍니다", information!)
	return
End if

w_mdi_frame.sle_msg.text = ''
dw_1.setitem(1, "order_no",sordno)
p_inq.triggerevent(clicked!)
end subroutine

event open;call super::open;PostEvent("ue_open")
end event

on w_sal_04300.create
int iCurrent
call super::create
this.pb_3=create pb_3
this.pb_4=create pb_4
this.pb_2=create pb_2
this.pb_1=create pb_1
this.dw_1=create dw_1
this.dw_2=create dw_2
this.tv_1=create tv_1
this.gb_3=create gb_3
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_3
this.Control[iCurrent+2]=this.pb_4
this.Control[iCurrent+3]=this.pb_2
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.dw_1
this.Control[iCurrent+6]=this.dw_2
this.Control[iCurrent+7]=this.tv_1
this.Control[iCurrent+8]=this.gb_3
this.Control[iCurrent+9]=this.rr_1
this.Control[iCurrent+10]=this.rr_2
end on

on w_sal_04300.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_3)
destroy(this.pb_4)
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.tv_1)
destroy(this.gb_3)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event ue_open;call super::ue_open;dw_1.settransobject(sqlca)
dw_2.settransobject(sqlca)

dw_insert.settransobject(sqlca)
dw_datetime.insertrow(0)
dw_1.insertrow(0)

DataWindowChild state_child
integer rtncode
  
//영업 담당자
rtncode 	= dw_1.GetChild('damdang', state_child)
IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 영업 담당자")
state_child.SetTransObject(SQLCA)
state_child.Retrieve('47',gs_saupj)
end event

type dw_insert from w_inherite`dw_insert within w_sal_04300
boolean visible = false
integer x = 2619
integer y = 0
integer width = 119
integer height = 84
end type

type p_delrow from w_inherite`p_delrow within w_sal_04300
integer x = 2075
integer y = 5000
end type

type p_addrow from w_inherite`p_addrow within w_sal_04300
integer x = 1902
integer y = 5000
end type

type p_search from w_inherite`p_search within w_sal_04300
integer x = 1207
integer y = 5000
end type

type p_ins from w_inherite`p_ins within w_sal_04300
integer x = 1728
integer y = 5000
end type

type p_exit from w_inherite`p_exit within w_sal_04300
integer x = 4439
integer y = 4
end type

type p_can from w_inherite`p_can within w_sal_04300
integer y = 5000
end type

type p_print from w_inherite`p_print within w_sal_04300
integer x = 1381
integer y = 5000
end type

type p_inq from w_inherite`p_inq within w_sal_04300
integer x = 4265
integer y = 4
end type

event p_inq::clicked;call super::clicked;string sorder_no, sordgbn

dw_1.accepttext()

sorder_no = dw_1.getitemstring(1, "order_no")

if isnull(sorder_no) or trim(sorder_no) = '' then
	MessageBox("수주", "수주번호를 등록하십시요", stopsign!)
	return
end if

if dw_2.retrieve(gs_sabu, sorder_no) < 1 then
	MessageBox("수주", "조회할 자료가 없읍니다", stopsign!)
	return
end if

sordgbn = dw_2.getitemstring(1, "sorder_oversea_gu")

if isnull(sorder_no) or trim(sorder_no) = '' then
	MessageBox("수주", "수주번호가 없읍니다.", stopsign!)	
	return
end if

w_mdi_frame.sle_msg.text = '자료를 조회중 [잠시 기다려 주십시요....!!]'
Setpointer(hourglass!)
tv_1.setredraw(False)
tv_1.of_tree_item(sorder_no, sordgbn)
tv_1.setredraw(True)
Setpointer(arrow!)
w_mdi_frame.sle_msg.text = ''
end event

type p_del from w_inherite`p_del within w_sal_04300
integer x = 2423
integer y = 5000
end type

type p_mod from w_inherite`p_mod within w_sal_04300
integer x = 2249
integer y = 5000
end type

type cb_exit from w_inherite`cb_exit within w_sal_04300
integer x = 4210
integer y = 5000
end type

type cb_mod from w_inherite`cb_mod within w_sal_04300
integer x = 997
integer y = 2364
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within w_sal_04300
integer x = 2917
integer y = 2360
boolean enabled = false
string text = "요약(&Q)"
end type

type cb_del from w_inherite`cb_del within w_sal_04300
integer x = 1353
integer y = 2364
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_sal_04300
integer x = 3863
integer y = 5000
end type

type cb_print from w_inherite`cb_print within w_sal_04300
integer x = 1710
integer y = 2364
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_sal_04300
end type

type cb_can from w_inherite`cb_can within w_sal_04300
integer x = 2569
integer y = 2364
boolean enabled = false
end type

type cb_search from w_inherite`cb_search within w_sal_04300
integer x = 2066
integer y = 2364
boolean enabled = false
end type







type gb_button1 from w_inherite`gb_button1 within w_sal_04300
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_04300
end type

type pb_3 from picturebutton within w_sal_04300
integer x = 3369
integer y = 44
integer width = 82
integer height = 72
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string pointer = "C:\erpman\cur\point.cur"
string picturename = "C:\erpman\image\last.gif"
end type

event clicked;wf_scroll(4)
end event

type pb_4 from picturebutton within w_sal_04300
integer x = 3273
integer y = 44
integer width = 82
integer height = 72
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string pointer = "C:\erpman\cur\point.cur"
string picturename = "C:\erpman\image\next.gif"
end type

event clicked;wf_scroll(3)
end event

type pb_2 from picturebutton within w_sal_04300
integer x = 3177
integer y = 44
integer width = 82
integer height = 72
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string pointer = "C:\erpman\cur\point.cur"
boolean originalsize = true
string picturename = "C:\erpman\image\prior.gif"
end type

event clicked;wf_scroll(2)
end event

type pb_1 from picturebutton within w_sal_04300
integer x = 3081
integer y = 44
integer width = 82
integer height = 72
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string pointer = "C:\erpman\cur\point.cur"
boolean originalsize = true
string picturename = "C:\erpman\image\first.gif"
alignment htextalign = left!
end type

event clicked;wf_scroll(1)
end event

type dw_1 from datawindow within w_sal_04300
event ue_key pbm_dwnkey
event ue_processenter pbm_dwnprocessenter
integer y = 12
integer width = 3031
integer height = 148
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_sal_04300_1"
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_processenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemerror;return 1
end event

event rbuttondown;String sEmpId, sSaupj

SetNull(Gs_Code)
SetNull(Gs_gubun)
SetNull(Gs_CodeName)

Choose Case GetColumnName()
	/* 수주번호 */
	Case "order_no"
			OpenWithParm(w_sorder_popup,'1')
			IF gs_code ="" OR IsNull(gs_code) THEN RETURN
			
			SetItem(1,"order_no", Left(gs_code,len(gs_code)-3))
			p_inq.TriggerEvent(Clicked!)
	/* 거래처코드 */
	Case "cvcod"
			Open(w_vndmst_popup)
			setitem(1, "cvcod", gs_code)
			setitem(1, "cvnas", gs_codename)
END Choose

end event

event itemchanged;string snull, scode, sname

SetNull( sNull )

If getcolumnname() = "cvcod" then
	scode = gettext()
	select cvnas into :sname
	  from vndmst
	 where cvcod = :scode;
   if sqlca.sqlcode <> 0 then
		MessageBox("거래처코드", "거래처코드가 부정확 합니다", stopsign!)
		setitem(1, "cvcod", snull)
		setitem(1, "cvnas", snull)
		return 1
	End if
	
	setitem(1, "cvnas", sname)
	
elseif getcolumnname() = "damdang" then
	scode = gettext()
	if isnull(scode) or trim(scode) = '' then
		setitem(1, "damdang", sNull)
		return
	end if
	select rfna1 into :sname
	  from reffpf
	 where rfcod = '47' and rfgub = :scode;
   if sqlca.sqlcode <> 0 then
		MessageBox("영업담당", "담당자코드가 부정확 합니다", stopsign!)
		setitem(1, "damdang", snull)
		return 1
	End if
End if
end event

type dw_2 from datawindow within w_sal_04300
integer x = 18
integer y = 180
integer width = 4567
integer height = 324
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_sal_04300_2"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type tv_1 from uo_sorder_history_tree within w_sal_04300
integer x = 23
integer y = 556
integer width = 4562
integer height = 1692
integer taborder = 30
boolean bringtotop = true
boolean border = false
borderstyle borderstyle = stylebox!
end type

type gb_3 from groupbox within w_sal_04300
integer x = 3049
integer width = 453
integer height = 144
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
end type

type rr_1 from roundrectangle within w_sal_04300
long linecolor = 29455689
integer linethickness = 1
long fillcolor = 32106727
integer x = 5
integer y = 164
integer width = 4599
integer height = 356
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_sal_04300
long linecolor = 29455689
integer linethickness = 1
long fillcolor = 32106727
integer x = 5
integer y = 544
integer width = 4599
integer height = 1728
integer cornerheight = 40
integer cornerwidth = 55
end type

