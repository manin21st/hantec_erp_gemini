$PBExportHeader$w_budo_popup.srw
$PBExportComments$거래처 부도어음 조회 선택
forward
global type w_budo_popup from w_inherite_popup
end type
type rr_1 from roundrectangle within w_budo_popup
end type
end forward

global type w_budo_popup from w_inherite_popup
integer x = 503
integer y = 524
integer width = 2651
integer height = 1152
string title = "거래처별 부도어음 조회 선택"
rr_1 rr_1
end type
global w_budo_popup w_budo_popup

on w_budo_popup.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_budo_popup.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;string get_nm

dw_jogun.SetTransObject(SQLCA)
dw_jogun.Reset()
dw_jogun.InsertRow(0)

IF IsNull(gs_code) THEN gs_code =""

  SELECT "VNDMST"."CVNAS2"  
    INTO :get_nm  
    FROM "VNDMST"  
   WHERE "VNDMST"."CVCOD" = :gs_code   ;

dw_jogun.setitem(1, 'cvcod', gs_code)
dw_jogun.setitem(1, 'cvnm', get_nm)

dw_1.Retrieve(gs_code)
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type dw_jogun from w_inherite_popup`dw_jogun within w_budo_popup
integer x = 32
integer y = 40
integer width = 1193
integer height = 144
string dataobject = "d_budo_popup1"
end type

event dw_jogun::itemchanged;call super::itemchanged;string  svndcod, svndnm, svndnm2
int     ireturn

IF this.GetColumnName() = "cvcod"	THEN
	svndcod = trim(this.GetText())
	ireturn = f_get_name2('V1', 'Y', svndcod, svndnm, svndnm2)    //1이면 실패, 0이 성공	
	this.setitem(1, "cvcod", svndcod)	
	this.setitem(1, "cvnm", svndnm)	
	RETURN ireturn
END IF
end event

event dw_jogun::itemerror;call super::itemerror;return 1
end event

event dw_jogun::rbuttondown;call super::rbuttondown;setnull(gs_code)
setnull(gs_codename)

if this.GetColumnName() = 'cvcod' then
	gs_gubun = '1'
	gs_code = this.GetText()
	open(w_vndmst_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"cvcod",gs_code)
	this.SetItem(1,"cvnm", gs_codename)
end if	

end event

type p_exit from w_inherite_popup`p_exit within w_budo_popup
integer x = 2418
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_budo_popup
boolean visible = false
integer x = 1129
integer y = 1280
boolean enabled = false
end type

type p_choose from w_inherite_popup`p_choose within w_budo_popup
integer x = 2245
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code= dw_1.GetItemString(ll_Row, "bill_no")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_budo_popup
integer x = 46
integer y = 188
integer width = 2537
integer height = 848
integer taborder = 20
string dataobject = "d_budo_popup"
boolean hscrollbar = true
end type

event dw_1::clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	b_flag = False
END IF

CALL SUPER ::CLICKED

end event

event dw_1::doubleclicked;IF Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

gs_code= dw_1.GetItemString(Row, "bill_no")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_budo_popup
boolean visible = false
integer y = 1352
integer width = 1271
long backcolor = 79741120
end type

type cb_1 from w_inherite_popup`cb_1 within w_budo_popup
integer x = 599
integer y = 1420
end type

type cb_return from w_inherite_popup`cb_return within w_budo_popup
integer x = 910
integer y = 1420
integer taborder = 40
end type

type cb_inq from w_inherite_popup`cb_inq within w_budo_popup
integer x = 1527
integer y = 1384
boolean default = false
end type

event cb_inq::clicked;//string scvcod
//
//IF gs_Gubun <> '1' then //거래처 선택 불가능
//   scvcod = dw_2.getitemstring(1, 'cvcod')
//ELSE
//	scvcod = gs_code
//END IF
//
//dw_1.Retrieve(scvcod)
//	
//dw_1.SelectRow(0,False)
//dw_1.SelectRow(1,True)
//dw_1.ScrollToRow(1)
//dw_1.SetFocus()
//
//
end event

type sle_1 from w_inherite_popup`sle_1 within w_budo_popup
boolean visible = false
integer x = 265
integer y = 1352
integer width = 197
long backcolor = 79741120
integer limit = 6
end type

type st_1 from w_inherite_popup`st_1 within w_budo_popup
boolean visible = false
integer x = 32
integer y = 1476
integer width = 315
string text = "대리점코드"
end type

type rr_1 from roundrectangle within w_budo_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 184
integer width = 2555
integer height = 856
integer cornerheight = 40
integer cornerwidth = 55
end type

