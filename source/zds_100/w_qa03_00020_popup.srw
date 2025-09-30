$PBExportHeader$w_qa03_00020_popup.srw
$PBExportComments$** CLAIM 이의제기
forward
global type w_qa03_00020_popup from w_inherite
end type
type rr_1 from roundrectangle within w_qa03_00020_popup
end type
type dw_1 from datawindow within w_qa03_00020_popup
end type
type p_1 from picture within w_qa03_00020_popup
end type
end forward

global type w_qa03_00020_popup from w_inherite
integer width = 3621
integer height = 1716
string title = "CLAIM 리스트"
string menuname = ""
boolean minbox = false
windowtype windowtype = response!
rr_1 rr_1
dw_1 dw_1
p_1 p_1
end type
global w_qa03_00020_popup w_qa03_00020_popup

type variables
str_code istr_car
end variables

on w_qa03_00020_popup.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.dw_1=create dw_1
this.p_1=create p_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.p_1
end on

on w_qa03_00020_popup.destroy
call super::destroy
destroy(this.rr_1)
destroy(this.dw_1)
destroy(this.p_1)
end on

event open;call super::open;f_window_center(This)

dw_insert.settransobject(sqlca)

dw_1.InsertRow(0)

end event

type dw_insert from w_inherite`dw_insert within w_qa03_00020_popup
integer x = 41
integer y = 284
integer width = 3506
integer height = 1288
integer taborder = 20
string dataobject = "d_qa03_00020_popup_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event dw_insert::doubleclicked;call super::doubleclicked;String ls_gubun ,ls_code
SetNull(gs_gubun)
SetNull(gs_code)

If row < 1 Then Return

gs_code  = Trim(dw_insert.Object.cl_jpno[row])
gs_gubun = Trim(dw_insert.Object.vnd_gb[row])

Close(parent)

end event

event dw_insert::clicked;call super::clicked;If Row <= 0 then
	SelectRow(0,False)
ELSE
	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
END IF
end event

type p_delrow from w_inherite`p_delrow within w_qa03_00020_popup
boolean visible = false
integer x = 1888
integer y = 2420
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_qa03_00020_popup
boolean visible = false
integer x = 1714
integer y = 2420
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_qa03_00020_popup
boolean visible = false
integer x = 2610
integer y = 40
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_qa03_00020_popup
boolean visible = false
integer x = 1541
integer y = 2420
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_qa03_00020_popup
integer x = 3392
integer y = 36
end type

event p_exit::clicked;SetNull(gs_gubun)
SetNull(gs_code)

Close(parent)
end event

type p_can from w_inherite`p_can within w_qa03_00020_popup
boolean visible = false
integer x = 3218
integer y = 36
end type

type p_print from w_inherite`p_print within w_qa03_00020_popup
boolean visible = false
integer x = 2610
integer y = 76
end type

event p_print::clicked;call super::clicked;//if dw_1.accepttext() = -1 then return
//
//gs_code  	 = dw_1.getitemstring(1, "sdate")
//gs_codename  = dw_1.getitemstring(1, "edate")
//
//if isnull(gs_code) or trim(gs_code) = '' then
//	gs_code = '10000101'
//end if
//
//if isnull(gs_codename) or trim(gs_codename) = '' then
//	gs_codename = '99991231'
//end if
//
//open(w_qct_01075_1)
//
//Setnull(gs_code)
//Setnull(gs_codename)
end event

type p_inq from w_inherite`p_inq within w_qa03_00020_popup
integer x = 3045
integer y = 36
end type

event p_inq::clicked;call super::clicked;String ls_vndgb , ls_balgb,ls_balgb1 ,ls_balgb2 , ls_clcod ,ls_rono

if dw_1.accepttext() = -1 then return

ls_vndgb  = Trim(dw_1.Object.gubun[1])
ls_balgb1 = Trim(dw_1.Object.bal_gb[1])   //
ls_clcod  = Trim(dw_1.Object.cl_cod[1])
ls_rono   = Trim(dw_1.Object.ro_no[1])

ls_balgb = ls_balgb1

If isNull(ls_clcod) Or ls_clcod = '' Then ls_clcod = '%'
If isNull(ls_rono) Or ls_rono = '' Then ls_rono = '%'

dw_insert.setredraw(false)

If dw_insert.Retrieve(gs_saupj,ls_vndgb , ls_balgb ,ls_clcod+'%' ,ls_rono+'%') > 0 then
else
   f_message_chk(50, '[Claim 현황]')
end if

dw_insert.setredraw(true)
end event

type p_del from w_inherite`p_del within w_qa03_00020_popup
boolean visible = false
integer x = 2235
integer y = 2420
boolean enabled = false
end type

type p_mod from w_inherite`p_mod within w_qa03_00020_popup
boolean visible = false
integer x = 2062
integer y = 2420
boolean enabled = false
end type

type cb_exit from w_inherite`cb_exit within w_qa03_00020_popup
end type

type cb_mod from w_inherite`cb_mod within w_qa03_00020_popup
integer x = 672
integer y = 2452
integer taborder = 40
end type

type cb_ins from w_inherite`cb_ins within w_qa03_00020_popup
integer x = 311
integer y = 2452
integer taborder = 30
end type

type cb_del from w_inherite`cb_del within w_qa03_00020_popup
integer x = 1033
integer y = 2452
integer taborder = 50
end type

type cb_inq from w_inherite`cb_inq within w_qa03_00020_popup
integer x = 1403
integer y = 2460
integer taborder = 60
end type

type cb_print from w_inherite`cb_print within w_qa03_00020_popup
integer x = 1755
integer y = 2452
integer taborder = 70
end type

type st_1 from w_inherite`st_1 within w_qa03_00020_popup
end type

type cb_can from w_inherite`cb_can within w_qa03_00020_popup
end type

type cb_search from w_inherite`cb_search within w_qa03_00020_popup
end type







type gb_button1 from w_inherite`gb_button1 within w_qa03_00020_popup
end type

type gb_button2 from w_inherite`gb_button2 within w_qa03_00020_popup
end type

type rr_1 from roundrectangle within w_qa03_00020_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 276
integer width = 3547
integer height = 1312
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_1 from datawindow within w_qa03_00020_popup
integer x = 5
integer y = 24
integer width = 2551
integer height = 244
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_qa03_00020_popup_1"
boolean border = false
boolean livescroll = true
end type

event itemerror;return 1
end event

type p_1 from picture within w_qa03_00020_popup
integer x = 3218
integer y = 36
integer width = 178
integer height = 144
boolean bringtotop = true
string picturename = "C:\erpman\image\선택_up.gif"
boolean focusrectangle = false
end type

event clicked;Long 	ll_row, ii

SetNull(gs_gubun)
SetNull(gs_code)

FOR ll_row = 1 TO dw_insert.rowcount()
	if dw_insert.Object.is_chk[ll_row] = 'N' then continue
	ii++
	istr_car.code[ii] = dw_insert.Object.cl_jpno[ll_row]	
NEXT

if ii = 0 then
	messagebox('확인','자료를 선택하십시오!!!')
	return
end if

gs_code = 'OK'
CloseWithReturn(Parent, istr_car)
end event

