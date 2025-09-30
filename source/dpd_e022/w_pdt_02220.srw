$PBExportHeader$w_pdt_02220.srw
$PBExportComments$** 작업우선순위등록
forward
global type w_pdt_02220 from w_inherite
end type
type dw_ip from u_key_enter within w_pdt_02220
end type
type dw_update from u_d_popup_sort within w_pdt_02220
end type
type st_2 from statictext within w_pdt_02220
end type
type st_msg from statictext within w_pdt_02220
end type
type pb_1 from u_pb_cal within w_pdt_02220
end type
type pb_2 from u_pb_cal within w_pdt_02220
end type
type rr_4 from roundrectangle within w_pdt_02220
end type
end forward

global type w_pdt_02220 from w_inherite
string title = "작업우선순위 등록"
boolean resizable = true
dw_ip dw_ip
dw_update dw_update
st_2 st_2
st_msg st_msg
pb_1 pb_1
pb_2 pb_2
rr_4 rr_4
end type
global w_pdt_02220 w_pdt_02220

on w_pdt_02220.create
int iCurrent
call super::create
this.dw_ip=create dw_ip
this.dw_update=create dw_update
this.st_2=create st_2
this.st_msg=create st_msg
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_4=create rr_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_ip
this.Control[iCurrent+2]=this.dw_update
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.st_msg
this.Control[iCurrent+5]=this.pb_1
this.Control[iCurrent+6]=this.pb_2
this.Control[iCurrent+7]=this.rr_4
end on

on w_pdt_02220.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_ip)
destroy(this.dw_update)
destroy(this.st_2)
destroy(this.st_msg)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_4)
end on

event open;call super::open;dw_update.SetTransObject(SQLCA)
dw_ip.SetTransObject(SQLCA)

dw_ip.InsertRow(0)
dw_ip.Setitem(1, 'sdate', is_today)
dw_ip.Setitem(1, 'edate', is_today)
	

end event

type dw_insert from w_inherite`dw_insert within w_pdt_02220
boolean visible = false
integer x = 2290
integer y = 2328
integer width = 384
integer height = 80
integer taborder = 0
boolean enabled = false
boolean livescroll = false
borderstyle borderstyle = stylelowered!
end type

event dw_insert::itemerror;RETURN 1
end event

event dw_insert::itemchanged;String  s_cod, s_nam1, s_nam2
Integer i_rtn
Long    crow

this.AcceptText()
ib_any_typing = True //입력필드 변경여부 Yes

s_cod = Trim(this.GetText())
crow = this.GetRow()

if this.GetColumnName() = "wkctr" then	
	i_rtn = f_get_name2("작업장", "Y", s_cod, s_nam1, s_nam2)
	this.object.wkctr[crow] = s_cod
	this.object.wcdsc[crow] = s_nam1
	return i_rtn
elseif this.GetColumnName() = "op_stim" then	
   if s_cod = "" or IsNull(s_cod) then return 
	if f_timechk(s_cod) = -1 then
		f_message_chk(176, "[시작시간]")
		this.object.op_stim[crow] = ""
		return 1
	end if
elseif this.GetColumnName() = "op_etim" then	
   if s_cod = "" or IsNull(s_cod) then return 
	if f_timechk(s_cod) = -1 then
		f_message_chk(176, "[완료시간]")
		this.object.op_etim[crow] = ""
		return 1
	end if
end if	
end event

event dw_insert::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

if this.getcolumnname() = "wkctr" then
	open(w_workplace_popup)
   this.object.wkctr[1] = gs_code
	this.object.wcdsc[1] = gs_codename
end if	
return
end event

event dw_insert::rowfocuschanged;//this.SetRowFocusIndicator(HAND!)
if this.RowCount() >= 1 then
	cb_mod.Enabled = True
	cb_del.Enabled = True
else
	cb_mod.Enabled = False
	cb_del.Enabled = False
end if	
end event

event dw_insert::ue_key;Real iamt
Long i

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)
i = this.GetRow()

IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
elseIF keydown(keyF2!) THEN
   if this.getcolumnname() = "itnbr" or this.getcolumnname() = "itdsc" or &
      this.getcolumnname() = "ispec" then //품번,품명,규격
      open(w_itemas_popup2)
      this.object.itnbr[i] = gs_code
	   this.object.itdsc[i] = gs_codename
	   this.object.ispec[i] = gs_gubun
	   if IsNull(gs_code) or gs_code = "" then
		   iamt = 0
	   else	
	      select wonprc into :iamt
	        from itemas
	       where itnbr = :gs_code;
	   end if
	   this.object.wonprc[i] = iamt
	end if	
END IF

return
end event

type p_delrow from w_inherite`p_delrow within w_pdt_02220
boolean visible = false
integer x = 4640
integer y = 404
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_pdt_02220
boolean visible = false
integer x = 4640
integer y = 556
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_pdt_02220
boolean visible = false
integer x = 4640
integer y = 1028
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_pdt_02220
boolean visible = false
integer x = 4640
integer y = 712
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_pdt_02220
integer x = 4398
integer taborder = 70
end type

type p_can from w_inherite`p_can within w_pdt_02220
integer x = 4224
integer taborder = 60
end type

event p_can::clicked;call super::clicked;IF wf_warndataloss("취소") = -1 THEN RETURN //변경된 자료 체크 

st_msg.Text = ''

dw_update.SetRedraw(False)
dw_update.Reset()
dw_update.SetRedraw(True)
dw_ip.SetFocus()

w_mdi_frame.sle_msg.text  = "최종 저장 후의 작업을 취소 하였습니다!"
ib_any_typing = False //입력필드 변경여부 No

p_mod.enabled = false
p_del.enabled = false

p_mod.PictureName = "C:\erpman\image\저장_d.gif"
p_del.PictureName = "C:\erpman\image\삭제_d.gif"
end event

type p_print from w_inherite`p_print within w_pdt_02220
boolean visible = false
integer x = 4640
integer y = 868
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_pdt_02220
integer x = 3703
integer taborder = 20
end type

event p_inq::clicked;call super::clicked;String sdate, edate, wkctr, gubun, sfilter
Long crow

cb_mod.Enabled = False
	
if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return
end if	

sdate = trim(dw_ip.object.sdate[1])
edate = trim(dw_ip.object.edate[1])
wkctr = dw_ip.object.wkctr[1]

if sdate = '' or isnull(sdate) then 
	f_message_chk(30, "[작업일자-from]")
	dw_ip.setcolumn('sdate')
	dw_ip.setfocus()
	return 
end if

if edate = '' or isnull(edate) then 
	f_message_chk(30, "[작업일자-To]")
	dw_ip.setcolumn('edate')
	dw_ip.setfocus()
	return 
end if

gubun = dw_ip.object.gubun[1]

IF isnull(wkctr) or trim(wkctr) = '' then
	wkctr = '%'
end if

sfilter = ''
dw_update.setfilter(sfilter)
dw_update.filter()

dw_update.SetRedraw(False)
if dw_update.Retrieve(gs_sabu, sdate, edate, wkctr) < 1 then
	f_message_chk(50, "[작업우선순위 등록]")
	dw_update.SetRedraw(True)		
	return 
end if	

if gubun = '1' then
	sFilter = "momast_wrkctr_order_pr_doqty   = 0"
Elseif gubun = '2' then
	sFilter = "momast_wrkctr_order_pr_doqty   > 0"
else
	sFilter = ""
End if
dw_update.setfilter(sfilter)
dw_update.filter()
dw_update.SetRedraw(True)	
dw_update.setfocus()

p_del.Enabled = True
p_mod.Enabled = True

p_mod.PictureName = "C:\erpman\image\저장_up.gif"
p_del.PictureName = "C:\erpman\image\삭제_up.gif"
end event

type p_del from w_inherite`p_del within w_pdt_02220
integer x = 4050
integer taborder = 50
boolean enabled = false
string picturename = "C:\erpman\image\삭제_d.gif"
end type

event p_del::clicked;call super::clicked;Long Lrow
String sPordno

IF dw_update.accepttext() = -1 then return 

Lrow = dw_update.getrow()

If Lrow > 0 then
	sPordno = dw_update.getitemstring(Lrow, "momast_wrkctr_order_pordno")
		
	If Messagebox("삭제확인", "작업지시번호 -> " + sPordno + " 를 " + '~n' + &
									  "삭제하시겠읍니까", question!, yesno!, 2) = 1 then
		dw_update.deleterow(Lrow)
	end if
End if

dw_update.setfocus()
end event

type p_mod from w_inherite`p_mod within w_pdt_02220
integer x = 3877
integer taborder = 40
boolean enabled = false
string picturename = "C:\erpman\image\저장_d.gif"
end type

event p_mod::clicked;call super::clicked;Real   tot_amt
String jpno

if f_msg_update() = -1 then return  //저장 Yes/No ?

if dw_update.Update() <> 1 then
	ROLLBACK;
	f_message_chk(32,'[작업우선순위 등록]') 
	sle_msg.text = "저장작업 실패 하였습니다!"
	return 
end if

COMMIT;

cb_can.triggerevent(clicked!)

w_mdi_frame.sle_msg.text  = "저장 되었습니다!"
ib_any_typing = False //입력필드 변경여부 No
 
end event

type cb_exit from w_inherite`cb_exit within w_pdt_02220
integer x = 3223
integer y = 2392
end type

type cb_mod from w_inherite`cb_mod within w_pdt_02220
integer x = 2459
integer y = 2392
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within w_pdt_02220
integer x = 805
integer y = 2320
boolean enabled = false
string text = "추가(&A)"
end type

type cb_del from w_inherite`cb_del within w_pdt_02220
integer x = 402
integer y = 2392
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_pdt_02220
integer x = 55
integer y = 2392
end type

type cb_print from w_inherite`cb_print within w_pdt_02220
integer x = 1874
integer y = 2348
end type

type st_1 from w_inherite`st_1 within w_pdt_02220
end type

type cb_can from w_inherite`cb_can within w_pdt_02220
integer x = 2811
integer y = 2392
end type

type cb_search from w_inherite`cb_search within w_pdt_02220
integer x = 1371
integer y = 2348
end type





type gb_10 from w_inherite`gb_10 within w_pdt_02220
integer x = 50
integer y = 2392
integer height = 140
integer textsize = -8
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

type gb_button1 from w_inherite`gb_button1 within w_pdt_02220
end type

type gb_button2 from w_inherite`gb_button2 within w_pdt_02220
end type

type dw_ip from u_key_enter within w_pdt_02220
event ue_key pbm_dwnkey
integer x = 37
integer y = 20
integer width = 3602
integer height = 164
integer taborder = 10
string dataobject = "d_pdt_02220_01"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

if this.getcolumnname() = "wkctr" then
	open(w_workplace_popup)
	IF gs_code = '' or isnull(gs_code) then return 
   this.object.wkctr[1] = gs_code
	this.object.wcdsc[1] = gs_codename
end if	

end event

event itemerror;call super::itemerror;return 1
end event

event itemchanged;call super::itemchanged;String  s_cod, s_nam1, s_nam2
Integer i_rtn

s_cod = Trim(this.GetText())

if this.GetColumnName() = "sdate" then
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[작업일자-From]")
		this.object.sdate[1] = ""
		return 1
	end if	
Elseif this.GetColumnName() = "edate" then
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[작업일자-To]")
		this.object.edate[1] = ""
		return 1
	end if		
elseif this.GetColumnName() = "wkctr" then	
	i_rtn = f_get_name2("작업장", "Y", s_cod, s_nam1, s_nam2)
	this.object.wkctr[1] = s_cod
	this.object.wcdsc[1] = s_nam1
	return i_rtn
end if	
end event

event getfocus;call super::getfocus;cb_mod.Enabled = False
end event

type dw_update from u_d_popup_sort within w_pdt_02220
event ue_key pbm_dwnkey
event ue_processenter pbm_dwnprocessenter
integer x = 59
integer y = 280
integer width = 4503
integer height = 2016
integer taborder = 30
boolean bringtotop = true
string title = "[ F1 : 상세정보 ]"
string dataobject = "d_pdt_02220_02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event ue_key;Long Lrow

Lrow = getrow()

if key = keyf1! And Lrow > 0 then
	
	gs_code 		= getitemstring(Lrow, "momast_wrkctr_order_pordno")
	gs_codeName = getitemstring(Lrow, "momast_wrkctr_order_opseq")
	
//	gi_page			=	getitemString(Lrow, "momast_wrkctr_order_mchcod")
	gs_gubun			=	getitemString(Lrow, "momast_wrkctr_order_wrkctr")
	gs_codename2	=	getitemString(Lrow, "momast_wrkctr_order_user_stime")+getitemString(Lrow, "momast_wrkctr_order_user_etime")
	
	open(w_pdt_02220_01)
	
	If Not IsNull(gs_code) then
		setitem(Lrow, "momast_wrkctr_order_mchcod", gs_gubun)
		setitem(Lrow, "momast_wrkctr_order_wrkctr", gs_code)
		setitem(Lrow, "momast_wrkctr_order_user_stime", gs_codename)		
		setitem(Lrow, "momast_wrkctr_order_user_etime", gs_codename2)		
	End if
end if

SetNull(gs_code)
SetNull(gs_gubun)
SetNull(gs_codename)
SetNull(gs_CodeName2)
end event

event ue_processenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;call super::itemchanged;String  s_cod, sNull, sprvcd
Long	  Lrow

Lrow = getrow()
sprvcd = getitemstring(Lrow, "momast_wrkctr_order_wkdate")

s_cod = Trim(this.GetText())
Setnull(sNull)


if this.GetColumnName() = "momast_wrkctr_order_wkdate" then
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[작업일자]")
		this.setitem(Lrow, "momast_wrkctr_order_wkdate", sPrvcd)
		return 1
	end if	
end if
end event

event itemerror;call super::itemerror;return 1
end event

event itemfocuschanged;call super::itemfocuschanged;String sPordno, sopseq

// sTatic Text에 작업지시번호, 긴급도를 Display
if row > 0 then
	sPordno = getitemstring(row, "momast_wrkctr_order_pordno")
	sOpseq  = getitemstring(row, "momast_wrkctr_order_opseq")	
	
	st_msg.text = '작지번호 : ' + sPordno + '   공정순서 : ' + sopseq
else
	st_msg.text = ''
end if
end event

type st_2 from statictext within w_pdt_02220
integer x = 55
integer y = 200
integer width = 357
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "F1 상세정보"
boolean focusrectangle = false
end type

type st_msg from statictext within w_pdt_02220
integer x = 430
integer y = 200
integer width = 1687
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean focusrectangle = false
end type

type pb_1 from u_pb_cal within w_pdt_02220
integer x = 759
integer y = 60
integer taborder = 80
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.Setcolumn('sdate')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_ip.SetItem(1, 'sdate', gs_code)
end event

type pb_2 from u_pb_cal within w_pdt_02220
integer x = 1216
integer y = 60
integer taborder = 90
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.Setcolumn('edate')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_ip.SetItem(1, 'edate', gs_code)
end event

type rr_4 from roundrectangle within w_pdt_02220
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 268
integer width = 4526
integer height = 2040
integer cornerheight = 40
integer cornerwidth = 55
end type

