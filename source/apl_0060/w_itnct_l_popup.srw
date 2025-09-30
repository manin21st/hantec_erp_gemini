$PBExportHeader$w_itnct_l_popup.srw
$PBExportComments$** 대분류코드 조회 선택
forward
global type w_itnct_l_popup from w_inherite_popup
end type
type rr_1 from roundrectangle within w_itnct_l_popup
end type
end forward

global type w_itnct_l_popup from w_inherite_popup
integer x = 1083
integer y = 212
integer width = 2345
integer height = 1872
string title = "대분류 코드 조회 선택"
rr_1 rr_1
end type
global w_itnct_l_popup w_itnct_l_popup

on w_itnct_l_popup.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_itnct_l_popup.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;dw_jogun.SetTransObject(SQLCA)
dw_jogun.InsertRow(0)

IF IsNull(gs_gubun) THEN
	gs_gubun ="%"
ELSE   
   dw_jogun.setitem(1, 'ittyp' , gs_gubun)	
END IF

dw_1.Retrieve(gs_gubun)
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type dw_jogun from w_inherite_popup`dw_jogun within w_itnct_l_popup
integer x = 27
integer y = 24
integer width = 1024
string dataobject = "d_itemas_ittyp1"
end type

event dw_jogun::itemchanged;call super::itemchanged;string snull, s_name, s_cdchk

setnull(snull)

IF this.GetColumnName() = 'ittyp' THEN
	s_name = this.gettext()

   IF	Isnull(s_name)  or  trim(s_name) = ''	Then
		s_name = '%'
	ELSE	
		s_cdchk = f_get_reffer('05', s_name)
		if isnull(s_cdchk) or s_cdchk="" then
			f_message_chk(33,'[품목구분]')
			this.SetItem(1,'ittyp', snull)
			return 1
		end if	
	END IF

	dw_1.Retrieve(s_name)
		
	dw_1.SelectRow(0,False)
	dw_1.SelectRow(1,True)
	dw_1.ScrollToRow(1)
	dw_1.SetFocus()
END IF
end event

event dw_jogun::itemerror;call super::itemerror;Return 1
end event

type p_exit from w_inherite_popup`p_exit within w_itnct_l_popup
integer x = 2130
integer y = 12
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_itnct_l_popup
boolean visible = false
integer x = 1783
integer y = 12
boolean enabled = false
end type

type p_choose from w_inherite_popup`p_choose within w_itnct_l_popup
integer x = 1957
integer y = 12
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_gubun    = dw_1.GetItemString(ll_Row, "ittyp")

gs_code     = dw_1.GetItemString(ll_Row, "itcls")
gs_codename = dw_1.GetItemString(ll_Row, "titnm")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_itnct_l_popup
integer x = 41
integer y = 188
integer taborder = 20
string dataobject = "d_itnct_l_popup"
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

gs_gubun    = dw_1.GetItemString(Row, "ittyp")

gs_code     = dw_1.GetItemString(Row, "itcls")
gs_codename = dw_1.GetItemString(Row, "titnm")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_itnct_l_popup
boolean visible = false
end type

type cb_1 from w_inherite_popup`cb_1 within w_itnct_l_popup
integer x = 1326
integer y = 1944
end type

type cb_return from w_inherite_popup`cb_return within w_itnct_l_popup
integer x = 1646
integer y = 1944
integer taborder = 40
end type

type cb_inq from w_inherite_popup`cb_inq within w_itnct_l_popup
integer x = 1074
integer taborder = 50
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_itnct_l_popup
boolean visible = false
end type

type st_1 from w_inherite_popup`st_1 within w_itnct_l_popup
boolean visible = false
end type

type rr_1 from roundrectangle within w_itnct_l_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 184
integer width = 2277
integer height = 1592
integer cornerheight = 40
integer cornerwidth = 55
end type

