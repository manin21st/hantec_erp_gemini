$PBExportHeader$w_imhist_mro_popup.srw
$PBExportComments$** 불출이력
forward
global type w_imhist_mro_popup from w_inherite_popup
end type
type rr_1 from roundrectangle within w_imhist_mro_popup
end type
end forward

global type w_imhist_mro_popup from w_inherite_popup
integer x = 1083
integer y = 212
integer width = 3163
integer height = 1900
string title = "MRO 불출자료 조회 선택"
rr_1 rr_1
end type
global w_imhist_mro_popup w_imhist_mro_popup

on w_imhist_mro_popup.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_imhist_mro_popup.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;dw_jogun.SetTransObject(SQLCA)
dw_jogun.InsertRow(0)

dw_jogun.setitem(1,'fdate',left(f_today(),6)+'01')
dw_jogun.setitem(1,'tdate',f_today())
dw_jogun.setitem(1,'deptcode',gs_code)
dw_jogun.setitem(1,'deptname',f_get_name5("01",gs_code,""))
dw_jogun.setitem(1,'empno',gs_codename)
dw_jogun.setitem(1,'empname',f_get_name5("02",gs_codename,""))
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_imhist_mro_popup
integer x = 41
integer y = 16
integer width = 2144
integer height = 260
string dataobject = "d_imhist_mro_popup1"
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

event dw_jogun::itemerror;call super::itemerror;return 1
end event

type p_exit from w_inherite_popup`p_exit within w_imhist_mro_popup
integer x = 2848
integer y = 76
end type

event p_exit::clicked;call super::clicked;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

CloseWithReturn(Parent, 'NOK')
end event

type p_inq from w_inherite_popup`p_inq within w_imhist_mro_popup
integer x = 2501
integer y = 76
boolean originalsize = false
end type

event p_inq::clicked;call super::clicked;if dw_jogun.accepttext() = -1 then return

string	sfdate, stdate, sempno

sfdate = trim(dw_jogun.getitemstring(1,'fdate'))
stdate = trim(dw_jogun.getitemstring(1,'tdate'))
sempno = dw_jogun.getitemstring(1,'empno')

if isnull(sfdate) or sfdate = '' then
	f_message_chk(30,'[기간 from]')
	dw_jogun.setcolumn('fdate')
	dw_jogun.setfocus()
	return
end if

if isnull(stdate) or stdate = '' then
	f_message_chk(30,'[기간 to]')
	dw_jogun.setcolumn('tdate')
	dw_jogun.setfocus()
	return
end if

setpointer(hourglass!)
if dw_1.retrieve(gs_sabu,sfdate,stdate,sempno) < 1 then
	f_message_chk(50, '[MRO 불출내역]')
	dw_jogun.setcolumn("fdate")
	dw_jogun.setfocus()
	return
end if
end event

type p_choose from w_inherite_popup`p_choose within w_imhist_mro_popup
integer x = 2674
integer y = 76
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code = dw_1.GetItemString(ll_Row,"imhist_iojpno")
Close(Parent)
end event

type dw_1 from w_inherite_popup`dw_1 within w_imhist_mro_popup
integer x = 82
integer y = 296
integer width = 2999
integer height = 1444
integer taborder = 20
string dataobject = "d_imhist_mro_popup2"
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

gs_code = dw_1.GetItemString(Row,"imhist_iojpno")

Close(Parent)
end event

type sle_2 from w_inherite_popup`sle_2 within w_imhist_mro_popup
boolean visible = false
end type

type cb_1 from w_inherite_popup`cb_1 within w_imhist_mro_popup
boolean visible = false
integer x = 1728
integer y = 1952
boolean enabled = false
end type

type cb_return from w_inherite_popup`cb_return within w_imhist_mro_popup
boolean visible = false
integer x = 2048
integer y = 1952
integer taborder = 40
boolean enabled = false
end type

type cb_inq from w_inherite_popup`cb_inq within w_imhist_mro_popup
boolean visible = false
integer x = 1074
integer taborder = 50
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_imhist_mro_popup
boolean visible = false
end type

type st_1 from w_inherite_popup`st_1 within w_imhist_mro_popup
boolean visible = false
end type

type rr_1 from roundrectangle within w_imhist_mro_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 69
integer y = 284
integer width = 3026
integer height = 1468
integer cornerheight = 40
integer cornerwidth = 55
end type

