$PBExportHeader$w_psd1160.srw
$PBExportComments$고과항목 및 배점 확정
forward
global type w_psd1160 from w_inherite_standard
end type
type dw_dept from datawindow within w_psd1160
end type
type dw_detail from datawindow within w_psd1160
end type
type dw_list from datawindow within w_psd1160
end type
type p_1 from picture within w_psd1160
end type
type cb_1 from commandbutton within w_psd1160
end type
type cb_2 from commandbutton within w_psd1160
end type
type rr_1 from roundrectangle within w_psd1160
end type
type rr_3 from roundrectangle within w_psd1160
end type
type rr_2 from roundrectangle within w_psd1160
end type
end forward

global type w_psd1160 from w_inherite_standard
integer height = 3252
string title = "고과항목 및 배점 확정"
dw_dept dw_dept
dw_detail dw_detail
dw_list dw_list
p_1 p_1
cb_1 cb_1
cb_2 cb_2
rr_1 rr_1
rr_3 rr_3
rr_2 rr_2
end type
global w_psd1160 w_psd1160

on w_psd1160.create
int iCurrent
call super::create
this.dw_dept=create dw_dept
this.dw_detail=create dw_detail
this.dw_list=create dw_list
this.p_1=create p_1
this.cb_1=create cb_1
this.cb_2=create cb_2
this.rr_1=create rr_1
this.rr_3=create rr_3
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_dept
this.Control[iCurrent+2]=this.dw_detail
this.Control[iCurrent+3]=this.dw_list
this.Control[iCurrent+4]=this.p_1
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.cb_2
this.Control[iCurrent+7]=this.rr_1
this.Control[iCurrent+8]=this.rr_3
this.Control[iCurrent+9]=this.rr_2
end on

on w_psd1160.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_dept)
destroy(this.dw_detail)
destroy(this.dw_list)
destroy(this.p_1)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.rr_1)
destroy(this.rr_3)
destroy(this.rr_2)
end on

event open;call super::open;dw_dept.settransobject(sqlca)
dw_list.settransobject(sqlca)
dw_detail.settransobject(sqlca)

dw_dept.insertrow(0)

f_set_saupcd(dw_dept, 'saupcd', '1')
is_saupcd = gs_saupcd


end event

type p_mod from w_inherite_standard`p_mod within w_psd1160
integer x = 4032
end type

event p_mod::clicked;call super::clicked;LONG ROWCOUNT, GETROW, li_curr
string li_flag, li_mrl, li_mrm, li_mrs, li_empno

IF DW_DETAIL.ACCEPTTEXT() = -1 THEN RETURN -1
IF DW_list.ACCEPTTEXT() = -1 THEN RETURN -1

ROWCOUNT = DW_DETAIL.ROWCOUNT()
li_curr = dw_list.getrow()

li_empno = dw_list.getitemstring(li_curr,"p6_meritperson_empno")

IF ROWCOUNT <=  0 THEN RETURN -1

if messagebox('확인','저장하시겠습니까?',question!,yesno!) = 1 then
	
	setpointer(hourglass!)

	FOR GETROW = 1 TO ROWCOUNT
		
		li_flag = upper(DW_DETAIL.getitemstring(GETROW,"p6_meritperson_mrflag"))
		li_mrl= DW_DETAIL.getitemstring(GETROW,"mrlcode")
		li_mrm = DW_DETAIL.getitemstring(GETROW,"mrmcode")
		li_mrs = DW_DETAIL.getitemstring(GETROW,"mrscode")
		
		UPDATE p6_meritperson 
		SET p6_meritperson.mrflag = :li_flag 
		WHERE p6_meritperson.EMPNO = :li_empno and
				p6_meritperson.mrlcode = :li_mrl and
				p6_meritperson.mrmcode = :li_mrm and
				p6_meritperson.mrscode = :li_mrs ;
		
	NEXT

end if
	
commit ;

setpointer(arrow!)
w_mdi_frame.sle_msg.text = "저장되었습니다."
end event

type p_del from w_inherite_standard`p_del within w_psd1160
integer x = 3067
integer y = 2900
end type

type p_inq from w_inherite_standard`p_inq within w_psd1160
integer x = 3854
end type

event p_inq::clicked;call super::clicked;string li_dept, saupcd

if dw_dept.accepttext() = -1 then return -1

li_dept = dw_dept.getitemstring(1,"deptcode")
saupcd = dw_dept.GetItemString(1,"saupcd")

if li_dept = "" or isnull(li_dept) then li_dept = '%'
if saupcd = ""  or  isnull(saupcd) then	saupcd = '%'


if dw_list.retrieve(li_dept, saupcd) < 1 then
	messagebox('확인','등록된 부서원이 없습니다',stopsign!)
	dw_dept.setfocus()
	dw_detail.reset()
	return -1
end if

end event

type p_print from w_inherite_standard`p_print within w_psd1160
integer x = 2021
integer y = 2896
end type

type p_can from w_inherite_standard`p_can within w_psd1160
end type

event p_can::clicked;call super::clicked;dw_detail.reset()

end event

type p_exit from w_inherite_standard`p_exit within w_psd1160
end type

type p_ins from w_inherite_standard`p_ins within w_psd1160
integer x = 2373
integer y = 2900
end type

type p_search from w_inherite_standard`p_search within w_psd1160
integer x = 1847
integer y = 2900
end type

type p_addrow from w_inherite_standard`p_addrow within w_psd1160
integer x = 2546
integer y = 2900
end type

type p_delrow from w_inherite_standard`p_delrow within w_psd1160
integer x = 2720
integer y = 2900
end type

type dw_insert from w_inherite_standard`dw_insert within w_psd1160
integer x = 1294
integer y = 2816
end type

type st_window from w_inherite_standard`st_window within w_psd1160
end type

type cb_exit from w_inherite_standard`cb_exit within w_psd1160
end type

type cb_update from w_inherite_standard`cb_update within w_psd1160
end type

event cb_update::clicked;call super::clicked;LONG ROWCOUNT, GETROW, li_curr
string li_flag, li_mrl, li_mrm, li_mrs, li_empno

IF DW_DETAIL.ACCEPTTEXT() = -1 THEN RETURN -1
IF DW_list.ACCEPTTEXT() = -1 THEN RETURN -1

ROWCOUNT = DW_DETAIL.ROWCOUNT()
li_curr = dw_list.getrow()

li_empno = dw_list.getitemstring(li_curr,"p6_meritperson_empno")

IF ROWCOUNT <=  0 THEN RETURN -1

if messagebox('확인','저장하시겠습니까?',question!,yesno!) = 1 then
	
	setpointer(hourglass!)

	FOR GETROW = 1 TO ROWCOUNT
		
		li_flag = upper(DW_DETAIL.getitemstring(GETROW,"p6_meritperson_mrflag"))
		li_mrl= DW_DETAIL.getitemstring(GETROW,"mrlcode")
		li_mrm = DW_DETAIL.getitemstring(GETROW,"mrmcode")
		li_mrs = DW_DETAIL.getitemstring(GETROW,"mrscode")
		
		UPDATE p6_meritperson 
		SET p6_meritperson.mrflag = :li_flag 
		WHERE p6_meritperson.EMPNO = :li_empno and
				p6_meritperson.mrlcode = :li_mrl and
				p6_meritperson.mrmcode = :li_mrm and
				p6_meritperson.mrscode = :li_mrs ;
		
	NEXT

end if
	
commit ;

setpointer(arrow!)
sle_msg.text = "저장되었습니다."
end event

type cb_insert from w_inherite_standard`cb_insert within w_psd1160
end type

type cb_delete from w_inherite_standard`cb_delete within w_psd1160
end type

type cb_retrieve from w_inherite_standard`cb_retrieve within w_psd1160
end type

type st_1 from w_inherite_standard`st_1 within w_psd1160
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_psd1160
end type

event cb_cancel::clicked;call super::clicked;dw_detail.reset()

end event

type dw_datetime from w_inherite_standard`dw_datetime within w_psd1160
end type

type sle_msg from w_inherite_standard`sle_msg within w_psd1160
end type

type gb_2 from w_inherite_standard`gb_2 within w_psd1160
end type

type gb_1 from w_inherite_standard`gb_1 within w_psd1160
end type

type gb_10 from w_inherite_standard`gb_10 within w_psd1160
end type

type dw_dept from datawindow within w_psd1160
integer x = 91
integer y = 76
integer width = 2286
integer height = 164
integer taborder = 60
boolean bringtotop = true
string title = "none"
string dataobject = "d_psd1160_dept"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;if dw_dept.accepttext() = -1 then return -1

cb_retrieve.triggerevent(clicked!)
end event

type dw_detail from datawindow within w_psd1160
integer x = 1225
integer y = 380
integer width = 2967
integer height = 1444
integer taborder = 70
boolean bringtotop = true
string title = "none"
string dataobject = "d_psd1160_detail"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;this.setrowfocusindicator(hand!)
end event

type dw_list from datawindow within w_psd1160
integer x = 87
integer y = 372
integer width = 882
integer height = 1420
integer taborder = 80
boolean bringtotop = true
string title = "none"
string dataobject = "d_psd1160_list"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;string li_empno

if dw_list.accepttext() = -1 then return -1

if row <= 0 then return -1

dw_list.selectrow(0,false)
dw_list.selectrow(row,true)

li_empno = dw_list.getitemstring(row,"p6_meritperson_empno")

dw_detail.retrieve(li_empno)
dw_detail.scrolltorow(dw_detail.rowcount())
dw_detail.setcolumn("p6_meritperson_mrflag")
dw_detail.setfocus()

end event

type p_1 from picture within w_psd1160
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 3675
integer y = 24
integer width = 178
integer height = 144
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\erpman\image\확정_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;PictureName = "C:\erpman\image\확정_dn.gif"
end event

event ue_lbuttonup;PictureName = "C:\erpman\image\확정_up.gif"
end event

event clicked;LONG ROWCOUNT, GETROW

IF DW_DETAIL.ACCEPTTEXT() = -1 THEN RETURN -1

ROWCOUNT = DW_DETAIL.ROWCOUNT()
GETROW = DW_DETAIL.GETROW()
IF ROWCOUNT <=  0 THEN RETURN -1
IF GETROW <= 0 THEN RETURN -1
	
DW_DETAIL.SETITEM(GETROW,"p6_meritperson_mrflag","Y")

end event

type cb_1 from commandbutton within w_psd1160
integer x = 3739
integer y = 208
integer width = 375
integer height = 88
integer taborder = 70
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "일괄확정"
end type

event clicked;LONG ROWCOUNT, GETROW, li_curr
string li_empno

IF DW_DETAIL.ACCEPTTEXT() = -1 THEN RETURN -1
IF DW_list.ACCEPTTEXT() = -1 THEN RETURN -1

ROWCOUNT = DW_DETAIL.ROWCOUNT()
li_curr = dw_list.getrow()

li_empno = dw_list.getitemstring(li_curr,"p6_meritperson_empno")

IF ROWCOUNT <=  0 THEN RETURN -1

if messagebox('확인','일괄확정 저장 하시겠습니까?', question!, yesno!) = 1 then 

	setpointer(hourglass!)
	
	FOR GETROW = 1 TO ROWCOUNT
		
		DW_DETAIL.SETITEM(GETROW,"p6_meritperson_mrflag","Y")
		
		UPDATE p6_meritperson 
		SET p6_meritperson.mrflag = 'Y' 
		WHERE p6_meritperson.EMPNO = :li_empno ;
		
	NEXT
	
	commit ;
	
	setpointer(arrow!)

end if

dw_detail.retrieve(li_empno)

w_mdi_frame.sle_msg.text = "일괄확정 저장 되었습니다"

end event

type cb_2 from commandbutton within w_psd1160
integer x = 4142
integer y = 208
integer width = 375
integer height = 88
integer taborder = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "일괄취소"
end type

event clicked;LONG ROWCOUNT, GETROW, li_curr
string li_empno

IF DW_DETAIL.ACCEPTTEXT() = -1 THEN RETURN -1
IF DW_list.ACCEPTTEXT() = -1 THEN RETURN -1

ROWCOUNT = DW_DETAIL.ROWCOUNT()
li_curr = dw_list.getrow()

li_empno = dw_list.getitemstring(li_curr,"p6_meritperson_empno")

IF ROWCOUNT <=  0 THEN RETURN -1

if messagebox('확인','일괄취소 저장 하시겠습니까?', question!, yesno!) = 1 then 

	setpointer(hourglass!)
	
	FOR GETROW = 1 TO ROWCOUNT
		
		DW_DETAIL.SETITEM(GETROW,"p6_meritperson_mrflag","N")
		
		UPDATE p6_meritperson 
		SET p6_meritperson.mrflag = 'N' 
		WHERE p6_meritperson.EMPNO = :li_empno ;
		
	NEXT
	
	commit ;
	
	setpointer(arrow!)

end if

dw_detail.retrieve(li_empno)

w_mdi_frame.sle_msg.text = "일괄취소 저장 되었습니다"
end event

type rr_1 from roundrectangle within w_psd1160
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 37
integer y = 16
integer width = 3502
integer height = 288
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_psd1160
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 1115
integer y = 336
integer width = 3451
integer height = 1908
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_psd1160
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 41
integer y = 332
integer width = 1038
integer height = 1908
integer cornerheight = 40
integer cornerwidth = 55
end type

