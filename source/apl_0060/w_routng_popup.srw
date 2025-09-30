$PBExportHeader$w_routng_popup.srw
$PBExportComments$** 공정코드 조회 선택
forward
global type w_routng_popup from w_inherite_popup
end type
type rr_1 from roundrectangle within w_routng_popup
end type
end forward

global type w_routng_popup from w_inherite_popup
integer width = 1486
integer height = 1764
string title = "공정코드 조회 선택"
rr_1 rr_1
end type
global w_routng_popup w_routng_popup

type variables
string ispdtgu
end variables

on w_routng_popup.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_routng_popup.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;String scode,sname

scode = Message.StringParm

// 생산팀
ispdtgu = gs_gubun

dw_jogun.SetTransObject(SQLCA)
dw_jogun.Retrieve(scode)

dw_1.settransobject(sqlca)
dw_1.Retrieve(scode,ispdtgu)


end event

type dw_jogun from w_inherite_popup`dw_jogun within w_routng_popup
integer x = 14
integer y = 172
integer width = 1440
integer height = 148
string dataobject = "d_routng_popup1"
end type

type p_exit from w_inherite_popup`p_exit within w_routng_popup
integer x = 1266
integer y = 12
end type

event p_exit::clicked;call super::clicked;SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_routng_popup
integer x = 919
integer y = 12
end type

event p_inq::clicked;call super::clicked;IF dw_1.retrieve(dw_jogun.getitemstring(1, 'itnbr'),ispdtgu) <= 0 THEN
	f_message_chk(50,'')
	sle_1.SetFocus()
	Return
END IF

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()
end event

type p_choose from w_inherite_popup`p_choose within w_routng_popup
integer x = 1093
integer y = 12
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_Code = dw_1.getitemstring(ll_Row, "opseq")
gs_CodeName= dw_1.getitemstring(ll_Row, "opdsc")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_routng_popup
integer x = 37
integer y = 324
integer width = 1385
integer height = 1304
integer taborder = 10
string dataobject = "d_routng_popup"
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

gs_Code = this.getitemstring(ROW, "opseq")
gs_CodeName= this.getitemstring(ROW, "opdsc")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_routng_popup
boolean visible = false
integer x = 439
integer y = 1952
integer width = 960
integer limit = 30
end type

type cb_1 from w_inherite_popup`cb_1 within w_routng_popup
integer x = 270
integer y = 2072
integer taborder = 20
end type

type cb_return from w_inherite_popup`cb_return within w_routng_popup
integer x = 891
integer y = 2072
integer taborder = 40
end type

type cb_inq from w_inherite_popup`cb_inq within w_routng_popup
integer x = 581
integer y = 2072
integer taborder = 30
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_routng_popup
boolean visible = false
integer x = 247
integer y = 1952
integer width = 187
integer limit = 4
end type

type st_1 from w_inherite_popup`st_1 within w_routng_popup
boolean visible = false
integer y = 1964
integer width = 256
string text = "공정코드"
alignment alignment = left!
end type

type rr_1 from roundrectangle within w_routng_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 320
integer width = 1417
integer height = 1312
integer cornerheight = 40
integer cornerwidth = 55
end type

