$PBExportHeader$w_sawon_popup.srw
$PBExportComments$** 사원 조회 선택
forward
global type w_sawon_popup from w_inherite_popup
end type
type rr_1 from roundrectangle within w_sawon_popup
end type
end forward

global type w_sawon_popup from w_inherite_popup
integer x = 1518
integer y = 412
integer width = 1819
integer height = 1856
string title = "사원 조회 선택"
rr_1 rr_1
end type
global w_sawon_popup w_sawon_popup

on w_sawon_popup.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_sawon_popup.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;String scode,sname, snull, get_nm, s_deptcd

setnull(snull)

dw_jogun.SetTransObject(SQLCA)
dw_jogun.insertrow(0)

DataWindowChild state_child
integer rtncode

rtncode 	= dw_jogun.GetChild('saupj', state_child)
IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 사업장")
state_child.SetTransObject(SQLCA)
state_child.Retrieve(gs_saupj)

// 부가세 사업장 설정
f_mod_saupj(dw_jogun, 'saupj')

IF IsNull(gs_code) THEN gs_code =""
IF IsNull(gs_codename) THEN gs_codename =""

SELECT "VNDMST"."CVNAS2"  
  INTO :get_nm  
  FROM "VNDMST"  
 WHERE ( "VNDMST"."CVCOD" = :gs_gubun ) AND  
       ( "VNDMST"."CVGU" = '4' ) AND  ( "VNDMST"."CVSTATUS" = '0' )   ;

IF sqlca.sqlcode <> 0 Then
	dw_jogun.setitem(1, 'sdeptcd', snull)
	dw_jogun.setitem(1, 'sdeptnm', snull)
	s_deptcd = '%'
ELSE  
	dw_jogun.setitem(1, 'sdeptcd', gs_gubun)
	dw_jogun.setitem(1, 'sdeptnm', get_nm)
	s_deptcd = gs_gubun
END IF

sle_1.text = gs_code
sle_2.text = gs_codename

scode = sle_1.text +'%'
sname = '%'

dw_1.Retrieve(scode,sname,s_deptcd, gs_saupj+'%')

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()

dw_jogun.SetColumn("semp_name")
dw_jogun.SetFocus()
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_sawon_popup
integer x = 32
integer y = 20
integer width = 1207
integer height = 200
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

event dw_jogun::itemerror;call super::itemerror;return 1
end event

event dw_jogun::rbuttondown;call super::rbuttondown;

Choose case GetColumnName()
	Case 'sdeptcd'
		Open(w_dept_popup)
		If IsNull(gs_code) Then Return
		
		SetItem(1, 'sdeptcd', gs_code)
		SetItem(1, 'sdeptnm', gs_codename)
End Choose
end event

type p_exit from w_inherite_popup`p_exit within w_sawon_popup
integer x = 1595
integer y = 40
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_sawon_popup
integer x = 1248
integer y = 40
end type

event p_inq::clicked;call super::clicked;String scode,sname,sdept, sSaupj

dw_jogun.accepttext()

sname = dw_jogun.getitemstring(1, 'semp_name')
sdept = dw_jogun.getitemstring(1, 'sdeptcd')
sSaupj = dw_jogun.getitemstring(1, 'saupj')

scode   = '%'
//scode = sle_1.text +'%'
//sname = '%' + sle_2.text + '%'

If IsNull(sSaupj) Or Trim(sSaupj) = '' Then sSaupj = ''

if isnull(sname) or sname = "" then 
   sname = '%'
else
	sname = sname + '%'
end if	

if isnull(sdept) or sdept = "" then 
   sdept = '%'
else
	sdept= sdept + '%'
end if	
	
IF dw_1.Retrieve(scode,sname,sdept, sSaupj+'%') <=0 THEN
	f_message_chk(50,'')
	Return
END IF

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()
end event

type p_choose from w_inherite_popup`p_choose within w_sawon_popup
integer x = 1422
integer y = 40
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_gubun = dw_1.GetItemString(ll_Row, "deptcode")
gs_code = dw_1.GetItemString(ll_Row, "empno")
gs_codename = dw_1.GetItemString(ll_Row, "empname")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_sawon_popup
integer x = 37
integer y = 240
integer width = 1733
integer height = 1468
integer taborder = 50
string dataobject = "d_sawon_popup"
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

gs_gubun    = dw_1.GetItemString(Row, "deptcode")
gs_code     = dw_1.GetItemString(Row, "empno")
gs_codename = dw_1.GetItemString(Row, "empname")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_sawon_popup
integer x = 434
integer width = 434
end type

type cb_1 from w_inherite_popup`cb_1 within w_sawon_popup
integer x = 439
integer y = 1808
integer taborder = 60
end type

type cb_return from w_inherite_popup`cb_return within w_sawon_popup
integer x = 1147
integer y = 1812
integer taborder = 80
end type

type cb_inq from w_inherite_popup`cb_inq within w_sawon_popup
integer x = 786
integer y = 1812
integer taborder = 70
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_sawon_popup
integer x = 238
integer width = 197
long backcolor = 1090519039
integer limit = 6
end type

type st_1 from w_inherite_popup`st_1 within w_sawon_popup
integer x = 50
integer width = 155
boolean enabled = true
string text = "사원"
alignment alignment = right!
end type

type rr_1 from roundrectangle within w_sawon_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 236
integer width = 1755
integer height = 1488
integer cornerheight = 40
integer cornerwidth = 55
end type

