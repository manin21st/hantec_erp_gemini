$PBExportHeader$w_sawon_popup2.srw
$PBExportComments$** 사원 조회 선택2(직종별 조회)
forward
global type w_sawon_popup2 from w_inherite_popup
end type
type rr_1 from roundrectangle within w_sawon_popup2
end type
end forward

global type w_sawon_popup2 from w_inherite_popup
integer x = 1518
integer y = 412
integer width = 1861
integer height = 1888
string title = "작업자 조회 선택"
rr_1 rr_1
end type
global w_sawon_popup2 w_sawon_popup2

type variables

end variables

on w_sawon_popup2.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_sawon_popup2.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;String snull, get_nm, s_deptcd

setnull(snull)
 
dw_jogun.SetTransObject(SQLCA)
dw_jogun.insertrow(0)

// gs_code 조코드
select a.dptno, b.deptname into :s_deptcd, :get_nm
  from jomast a, p0_dept b
 where a.jocod = :gs_code
   and a.dptno = b.deptcode(+);
	  
IF sqlca.sqlcode <> 0 Then
	dw_jogun.setitem(1, 'sdeptcd', snull)
	dw_jogun.setitem(1, 'sdeptnm', snull)
	s_deptcd = '%'
ELSE  
	dw_jogun.setitem(1, 'sdeptcd', s_deptcd)
	dw_jogun.setitem(1, 'sdeptnm', get_nm)
	s_deptcd = s_deptcd+'%'
END IF

Setnull(gs_code)
Setnull(gs_codename)

dw_1.Retrieve('%','%',s_deptcd)

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_sawon_popup2
integer x = 23
integer y = 24
integer width = 1225
integer height = 208
string dataobject = "d_sawon_popup_1"
end type

event dw_jogun::itemfocuschanged;call super::itemfocuschanged;Long wnd

wnd =Handle(this)

IF dwo.name ="semp_name" THEN
	f_toggle_kor(wnd)
ELSE
	f_toggle_eng(wnd)
END IF
end event

event dw_jogun::ue_key;call super::ue_key;If keyDown(keyEnter!) Then
	p_inq.TriggerEvent(Clicked!)
End If
end event

event dw_jogun::rbuttondown;call super::rbuttondown;Choose case GetColumnName()
	Case 'sdeptcd'
		Open(w_dept_popup)
		If IsNull(gs_code) Then Return
		
		SetItem(1, 'sdeptcd', gs_code)
		SetItem(1, 'sdeptnm', gs_codename)
End Choose
end event

type p_exit from w_inherite_popup`p_exit within w_sawon_popup2
integer x = 1655
integer y = 44
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_sawon_popup2
integer x = 1307
integer y = 44
end type

event p_inq::clicked;call super::clicked;String scode,sname,sdept

dw_jogun.accepttext()

sname = dw_jogun.getitemstring(1, 'semp_name')
sdept = dw_jogun.getitemstring(1, 'sdeptcd')

scode = sle_1.text +'%'

if isnull(sdept) or sdept = "" then 
   sdept = '%'
else
	sdept= sdept + '%'
end if	

if isnull(sname) or sname = "" then 
   sname = '%'
else
	sname = sname + '%'
end if	
	
IF dw_1.Retrieve(scode,sname,sdept) <=0 THEN
	f_message_chk(50,'')
	Return
END IF

f_mod_saupj(dw_jogun, 'saupj')

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()
end event

type p_choose from w_inherite_popup`p_choose within w_sawon_popup2
integer x = 1481
integer y = 44
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code = dw_1.GetItemString(ll_Row, "empno")
gs_codename = dw_1.GetItemString(ll_Row, "empname")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_sawon_popup2
integer x = 32
integer y = 248
integer width = 1778
integer height = 1528
integer taborder = 40
string dataobject = "d_sawon_popup2"
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

gs_code = dw_1.GetItemString(Row, "empno")
gs_codename = dw_1.GetItemString(Row, "empname")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_sawon_popup2
integer x = 434
integer width = 434
end type

type cb_1 from w_inherite_popup`cb_1 within w_sawon_popup2
integer x = 837
integer y = 2024
integer taborder = 50
end type

type cb_return from w_inherite_popup`cb_return within w_sawon_popup2
integer x = 1147
integer y = 2056
integer taborder = 70
end type

type cb_inq from w_inherite_popup`cb_inq within w_sawon_popup2
integer x = 1207
integer y = 2000
integer taborder = 60
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_sawon_popup2
integer x = 238
integer width = 197
long backcolor = 1090519039
integer limit = 6
end type

type st_1 from w_inherite_popup`st_1 within w_sawon_popup2
integer x = 50
integer width = 155
boolean enabled = true
string text = "사원"
alignment alignment = right!
end type

type rr_1 from roundrectangle within w_sawon_popup2
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 240
integer width = 1797
integer height = 1544
integer cornerheight = 40
integer cornerwidth = 55
end type

