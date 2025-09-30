$PBExportHeader$w_sys_jobpf.srw
$PBExportComments$프로그램 관리
forward
global type w_sys_jobpf from w_inherite
end type
type dw_ip from datawindow within w_sys_jobpf
end type
type cb_1 from commandbutton within w_sys_jobpf
end type
type sle_1 from singlelineedit within w_sys_jobpf
end type
type cb_3 from commandbutton within w_sys_jobpf
end type
type cb_4 from commandbutton within w_sys_jobpf
end type
type cb_2 from commandbutton within w_sys_jobpf
end type
end forward

global type w_sys_jobpf from w_inherite
string title = "프로그램 관리"
dw_ip dw_ip
cb_1 cb_1
sle_1 sle_1
cb_3 cb_3
cb_4 cb_4
cb_2 cb_2
end type
global w_sys_jobpf w_sys_jobpf

type variables
DataWindowChild dw_child
String is_sql
end variables

forward prototypes
public function integer wf_settransaction ()
public function integer wf_getdata (string as_value)
end prototypes

public function integer wf_settransaction ();// Set Transaction

dw_ip.GetChild("subs_id", dw_child)

dw_child.SetTransObject(SQLCA)

Return 1
end function

public function integer wf_getdata (string as_value);// 중분류 항목을 분류하여 Display
String ls_idx
String ls_rsql
String ls_where
String ls_null

// 분류 범의를 산정
Choose Case as_value
	Case '10'
		ls_idx = '19'
	Case '20'
		ls_idx = '49'
	Case '50'
		ls_idx = '91' //89
	Case '99'
		ls_idx = '99'
End Choose		

wf_settransaction()

SetNull(ls_null)
dw_ip.SetItem(1, 'subs_id', ls_null)

ls_where = " And main_id between '" + as_value + "' And '" + ls_idx + "'"	
ls_rsql = is_sql + ls_where

dw_child.SetSQLSelect(ls_rsql)

dw_child.Retrieve()

Return 1
end function

on w_sys_jobpf.create
int iCurrent
call super::create
this.dw_ip=create dw_ip
this.cb_1=create cb_1
this.sle_1=create sle_1
this.cb_3=create cb_3
this.cb_4=create cb_4
this.cb_2=create cb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_ip
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.sle_1
this.Control[iCurrent+4]=this.cb_3
this.Control[iCurrent+5]=this.cb_4
this.Control[iCurrent+6]=this.cb_2
end on

on w_sys_jobpf.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_ip)
destroy(this.cb_1)
destroy(this.sle_1)
destroy(this.cb_3)
destroy(this.cb_4)
destroy(this.cb_2)
end on

event open;call super::open;// Crate Transaction
dw_insert.SetTransObject(SQLCA)
dw_ip.SetTransObject(SQLCA)

// Control dw_ip
dw_ip.InsertRow(0)
dw_ip.SetFocus()

wf_settransaction()
is_sql = dw_child.GetSQLSelect()
end event

type dw_insert from w_inherite`dw_insert within w_sys_jobpf
integer x = 37
integer y = 288
integer width = 4603
integer height = 1992
string dataobject = "d_sys_jobpf_ctl"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event dw_insert::itemchanged;Choose Case dwo.name	
	Case 'emp_id'
		String ls_duty_name
		String ls_null
		
		If Len(Trim(data)) > 0 Then			
			ls_duty_name = f_get_employee(data)
			If isNull(ls_duty_name) Then
				MessageBox('알림', '등록되어 있지 않은 사번입니다.')
				SetNull(ls_null)
				This.SetItem(row, 'duty_name', ls_null)
				Return 1
			Else
				This.SetItem(row, 'duty_name', ls_duty_name)
			End If
		End If
End Choose
end event

event dw_insert::itemerror;return 1
end event

event dw_insert::rbuttondown;call super::rbuttondown;WINDOW LW_WINDOW
string ls_window_id

ls_window_id = GetItemString(row, 'window_name')

OpenSheet(lw_window, ls_window_id, w_mdi_frame, 0, Layered!)
end event

event dw_insert::clicked;call super::clicked;IF ROW > 0 THEN
	SELECTROW(0,FALSE)
	SELECTROW(ROW,TRUE)
ELSE
	SELECTROW(0,FALSE)
END IF
end event

type p_delrow from w_inherite`p_delrow within w_sys_jobpf
integer x = 3497
integer y = 20
end type

event p_delrow::clicked;call super::clicked;If messagebox('','삭제 ok?', information!, yesno!, 2) = 2 then return
dw_insert.DeleteRow(0)

//If dw_insert.Update() = 1 then
//	COMMIT;
//	sle_msg.text = "저장 되었습니다!"	
//	ib_any_typing = False
//	p_inq.TriggerEvent(Clicked!)
//Else
//	f_message_chk(32,'[자료저장 실패]') 
//	ROLLBACK;
//   sle_msg.text = "저장작업 실패 하였습니다!"
//	Return 
//End If
end event

type p_addrow from w_inherite`p_addrow within w_sys_jobpf
boolean visible = false
integer y = 180
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_sys_jobpf
boolean visible = false
integer y = 176
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_sys_jobpf
boolean visible = false
integer y = 180
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_sys_jobpf
end type

type p_can from w_inherite`p_can within w_sys_jobpf
end type

event p_can::clicked;call super::clicked;dw_insert.ReSet()

dw_ip.ReSet()
dw_ip.InsertRow(0)
dw_ip.SetFocus()

sle_msg.Text = "작업을 취소 하였습니다!"
ib_any_typing = False
end event

type p_print from w_inherite`p_print within w_sys_jobpf
boolean visible = false
integer y = 176
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_sys_jobpf
integer x = 3922
end type

event p_inq::clicked;call super::clicked;string	ls_MainID, ls_SubsID, ls_fidx, ls_tidx, ls_duty_id, ls_duty_name
Integer 	li_i

// Get Data
dw_ip.AcceptText()

ls_MainID = dw_ip.GetItemString(1,'main_id')
ls_SubsID = dw_ip.GetItemString(1,'subs_id')

// 조건검색
If IsNull(ls_MainID) Then	
	MessageBox("확인", "대분류 코드를 입력하세요!")
	dw_ip.SetColumn('main_id')
	dw_ip.SetFocus()
	Return
End if

// 조건검색
//If IsNull(ls_SubsID) then
//	MessageBox("확인","중분류 코드를 입력하세요!")
//	dw_ip.SetColumn('subs_id')
//	dw_ip.SetFocus()
//	return
//end if
//
SetPointer(HourGlass!)

If IsNull(ls_SubsID) Then
	ls_fidx = ls_MainID
	Choose Case ls_fidx
		Case '10'
			ls_tidx = '19'
		Case '20'
			ls_tidx = '49'
		Case '50'
			ls_tidx = '89'
		Case '90'
			ls_tidx = '99'
	End Choose
Else
	ls_fidx = ls_SubsID
	ls_tidx = ls_SubsID
End If

// Retrieve & Data Set
if dw_insert.Retrieve(ls_fidx,ls_tidx) < 1 then
	MessageBox("확인","등록된 자료가 없습니다!")
	Return
Else
	For li_i = 1 To dw_insert.RowCount()
		ls_duty_id = dw_insert.GetItemString(li_i, 'emp_id')
		ls_duty_name = f_get_employee(ls_duty_id)			
		dw_insert.SEtItem(li_i, 'duty_name', ls_duty_name)
	Next
end if

dw_insert.SetRow(1)
dw_insert.SetFocus()
end event

type p_del from w_inherite`p_del within w_sys_jobpf
boolean visible = false
integer y = 180
boolean enabled = false
end type

type p_mod from w_inherite`p_mod within w_sys_jobpf
integer x = 4096
end type

event p_mod::clicked;call super::clicked;If dw_insert.Update() = 1 then
	COMMIT;
	sle_msg.text = "저장 되었습니다!"	
	ib_any_typing = False
	p_inq.TriggerEvent(Clicked!)
Else
	f_message_chk(32,'[자료저장 실패]') 
	ROLLBACK;
   sle_msg.text = "저장작업 실패 하였습니다!"
	Return 
End If
end event

type cb_exit from w_inherite`cb_exit within w_sys_jobpf
end type

type cb_mod from w_inherite`cb_mod within w_sys_jobpf
end type

type cb_ins from w_inherite`cb_ins within w_sys_jobpf
end type

type cb_del from w_inherite`cb_del within w_sys_jobpf
end type

type cb_inq from w_inherite`cb_inq within w_sys_jobpf
end type

type cb_print from w_inherite`cb_print within w_sys_jobpf
end type

type st_1 from w_inherite`st_1 within w_sys_jobpf
end type

type cb_can from w_inherite`cb_can within w_sys_jobpf
end type

type cb_search from w_inherite`cb_search within w_sys_jobpf
end type







type gb_button1 from w_inherite`gb_button1 within w_sys_jobpf
end type

type gb_button2 from w_inherite`gb_button2 within w_sys_jobpf
end type

type dw_ip from datawindow within w_sys_jobpf
integer x = 37
integer y = 52
integer width = 1984
integer height = 208
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_sys_jobpf"
boolean border = false
boolean livescroll = true
end type

event itemchanged;String ls_id

If dwo.name = 'main_id' Then
	dw_ip.Accepttext( )	
	ls_id = this.GetItemString(1, 'main_id')
	wf_getdata(ls_id)
End If
end event

type cb_1 from commandbutton within w_sys_jobpf
integer x = 2057
integer y = 44
integer width = 402
integer height = 84
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "Filter"
end type

event clicked;string snull

setnull(snull)

dw_insert.SetFilter(snull)
dw_insert.Filter()
end event

type sle_1 from singlelineedit within w_sys_jobpf
integer x = 2478
integer y = 44
integer width = 928
integer height = 80
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
string text = "sujeong_gb  JJ-기존,CC-수정,CN-신규,DD-제외, OH-진행중"
borderstyle borderstyle = stylelowered!
end type

type cb_3 from commandbutton within w_sys_jobpf
boolean visible = false
integer x = 2496
integer y = 168
integer width = 402
integer height = 84
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "sort"
end type

event clicked;string snull

setnull(snull)

dw_insert.SetSort(snull)
dw_insert.Sort()
end event

type cb_4 from commandbutton within w_sys_jobpf
boolean visible = false
integer x = 2089
integer y = 168
integer width = 402
integer height = 84
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "미완료pgm"
end type

event clicked;string snull

setnull(snull)

dw_insert.SetFilter("sujeong_gb in ( 'CC', 'CN') AND isnull(ok_date) ")
dw_insert.Filter()
end event

type cb_2 from commandbutton within w_sys_jobpf
boolean visible = false
integer x = 2898
integer y = 168
integer width = 402
integer height = 84
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "none"
end type

event clicked;dw_insert.SaveAsAscii("d:\TS.TXT","&","'")
end event

