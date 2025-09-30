$PBExportHeader$w_itemas_popup9.srw
$PBExportComments$** 품목코드 조회 선택(특정 품목구분과 시리즈로 조회)
forward
global type w_itemas_popup9 from w_inherite_popup
end type
type rr_1 from roundrectangle within w_itemas_popup9
end type
end forward

global type w_itemas_popup9 from w_inherite_popup
integer x = 741
integer y = 248
integer width = 2523
integer height = 1864
string title = "품목코드 조회(완료품번)"
rr_1 rr_1
end type
global w_itemas_popup9 w_itemas_popup9

type variables
string is_itcls
end variables

on w_itemas_popup9.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_itemas_popup9.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;dw_jogun.SetTransObject(SQLCA)
dw_jogun.insertrow(0)

if gs_gubun = '' or isnull(gs_gubun) then gs_gubun = '1'

dw_jogun.setitem(1, 'ittyp', gs_gubun)
dw_jogun.setitem(1, 'itcls', gs_code)

if isnull(gs_code)  then gs_code = '%'
dw_1.Retrieve(gs_gubun, gs_code + '%')
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type dw_jogun from w_inherite_popup`dw_jogun within w_itemas_popup9
integer x = 32
integer y = 52
integer width = 1833
integer height = 144
string dataobject = "d_itemas_ittyp9"
end type

event dw_jogun::itemchanged;call super::itemchanged;string snull, s_name

setnull(snull)

IF this.GetColumnName() = 'ittyp' THEN
	s_name = this.gettext()
 
   IF s_name = "" OR IsNull(s_name) THEN 
		RETURN
   END IF
	
	s_name = f_get_reffer('05', s_name)
	if isnull(s_name) or s_name="" then
		f_message_chk(33,'[품목구분]')
		this.SetItem(1,'ittyp', snull)
		return 1
   end if	
END IF
end event

event dw_jogun::itemerror;call super::itemerror;return 1
end event

type p_exit from w_inherite_popup`p_exit within w_itemas_popup9
integer x = 2299
integer y = 36
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_itemas_popup9
integer x = 1952
integer y = 36
end type

event p_inq::clicked;call super::clicked;String sittyp, sitcls

dw_jogun.AcceptText()
sittyp = dw_jogun.GetItemString(1,'ittyp')
sitcls = dw_jogun.GetItemString(1,'itcls')

IF IsNull(sittyp) or sittyp = '' THEN 
	MessageBox('알림','품목구분을 선택하세요')
	dw_jogun.SetColumn('ittyp')
	dw_jogun.SetFocus()
	return
END IF	

if isnull(sitcls)  then sitcls = '%'
dw_1.Retrieve(sittyp, sitcls + '%')
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type p_choose from w_inherite_popup`p_choose within w_itemas_popup9
integer x = 2126
integer y = 36
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

//IF dw_1.GetItemString(ll_Row, "itemas_useyn") = '1' then
//	f_message_chk(53, "[품번]")
//	Return 
IF dw_1.GetItemString(ll_Row, "itemas_useyn") = '2' then
	f_message_chk(54, "[품번]")
	Return 
END IF

gs_code= dw_1.GetItemString(ll_Row, "itemas_itnbr")
gs_codename= dw_1.GetItemString(ll_row,"itemas_itdsc")
gs_gubun= dw_1.GetItemString(ll_row,"itemas_ispec")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_itemas_popup9
integer x = 41
integer y = 220
integer width = 2423
integer height = 1540
integer taborder = 10
string dataobject = "d_itemas_popup9"
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

//IF dw_1.GetItemString(Row, "itemas_useyn") = '1' then
//	f_message_chk(53, "[품번]")
//	Return 
IF dw_1.GetItemString(Row, "itemas_useyn") = '2' then
	f_message_chk(54, "[품번]")
	Return 
END IF

gs_code= dw_1.GetItemString(Row, "itemas_itnbr")
gs_codename= dw_1.GetItemString(row,"itemas_itdsc")
gs_gubun= dw_1.GetItemString(row,"itemas_ispec")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_itemas_popup9
boolean visible = false
integer x = 722
integer y = 1916
integer width = 1001
end type

event sle_2::getfocus;f_toggle_eng(Handle(this))
end event

type cb_1 from w_inherite_popup`cb_1 within w_itemas_popup9
integer x = 233
integer y = 1896
integer taborder = 20
end type

type cb_return from w_inherite_popup`cb_return within w_itemas_popup9
integer x = 873
integer y = 1896
integer taborder = 40
end type

type cb_inq from w_inherite_popup`cb_inq within w_itemas_popup9
integer x = 553
integer y = 1896
integer taborder = 30
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_itemas_popup9
boolean visible = false
integer x = 297
integer y = 1916
integer width = 425
integer limit = 15
end type

type st_1 from w_inherite_popup`st_1 within w_itemas_popup9
boolean visible = false
integer y = 1928
integer width = 251
string text = "품목코드"
alignment alignment = left!
end type

type rr_1 from roundrectangle within w_itemas_popup9
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 216
integer width = 2441
integer height = 1548
integer cornerheight = 40
integer cornerwidth = 55
end type

