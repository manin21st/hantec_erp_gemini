$PBExportHeader$w_exppid_popup.srw
$PBExportComments$P/I NO,SEQ 선택 POPUP
forward
global type w_exppid_popup from w_inherite_popup
end type
type rr_1 from roundrectangle within w_exppid_popup
end type
end forward

global type w_exppid_popup from w_inherite_popup
integer x = 5
integer y = 240
integer width = 3589
integer height = 1760
string title = "Proforma Invoice No. 선택"
rr_1 rr_1
end type
global w_exppid_popup w_exppid_popup

type variables
boolean ib_down
long  il_sRow = 1
String   isSaupj,  isexplcno, isCvcod
end variables

on w_exppid_popup.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_exppid_popup.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;String smsg

f_window_center_response(this)

dw_jogun.InsertRow(0)

isSaupj   = Trim(gs_code)		/* 부가사업장 */
isexplcno = Trim(gs_codename) // 관련 L/C no
isCvcod   = Trim(gs_gubun)

IF IsNull(isSaupj)   Then isSaupj = "1" 
If IsNull(isExpLcno) Then isExpLcno = ''
IF IsNull(iscvcod)   Then iscvcod = "" 

dw_1.DataObject = 'd_exppid_popup'
dw_1.SetTransObject(Sqlca)
//st_1.Text = 'Proforma Invoice No.'

end event

type dw_jogun from w_inherite_popup`dw_jogun within w_exppid_popup
integer x = 0
integer y = 24
integer width = 1449
string dataobject = "d_exppid_popup1"
end type

type p_exit from w_inherite_popup`p_exit within w_exppid_popup
integer x = 3374
integer y = 16
end type

event clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_exppid_popup
integer x = 3026
integer y = 16
end type

event p_inq::clicked;call super::clicked;string spino

IF dw_jogun.AcceptText() = -1 THEN Return 

spino  = trim(dw_jogun.GetItemString(1,'pino'))

IF IsNull(spino)  Then spino = "" 
IF IsNull(iscvcod) Then iscvcod = "" 

dw_1.Retrieve(gs_sabu, spino+'%', isCvcod+'%', isExpLcno+'%', isSaupj )
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()

dw_1.SetRedraw(True)

end event

type p_choose from w_inherite_popup`p_choose within w_exppid_popup
integer x = 3200
integer y = 16
end type

event p_choose::clicked;call super::clicked;/* ---------------------------------------------------------- */
/* Multi Selection : 선택된 row를 제외한 row는 제거함         */
/* ---------------------------------------------------------- */
Long ll_row,dselected_row[]
Long ix,dRow,nCnt,sCnt,dCnt

dw_1.SetRedraw(False)

For ix = 1 To dw_1.RowCount()        /* 선택않된 row */
  If dw_1.IsSelected(ix) Then 
	  sCnt += 1
  Else
	  dCnt += 1
	  dselected_row[dCnt] = ix 
  End If
Next

IF sCnt <= 0 THEN
   f_message_chk(36,'')
   return
END IF

dCnt = 0
For ix = 1 To UpperBound(dselected_row)
	dRow = dselected_row[ix] - dCnt
	
	dw_1.RowsDiscard(dRow, dRow , Primary!)
	dCnt += 1
Next
/* ---------------------------------------------------------- */
/* Multi Selection-End                                        */
/* ---------------------------------------------------------- */
SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

gs_code = 'M'
//If rb_1.Checked = True Then
//	gs_gubun = '1'
//Else
//	gs_gubun = '2'
//End If

dw_1.SaveAs("dummy",Clipboard!,false)

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_exppid_popup
integer x = 32
integer y = 192
integer width = 3502
integer height = 1440
integer taborder = 30
string dataobject = "d_exppid_popup"
boolean hscrollbar = true
end type

event dw_1::doubleclicked;IF Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

cb_1.TriggerEvent(Clicked!)
end event

event dw_1::rowfocuschanged;int crow,fr_row,to_row,ix

If currentrow <=0 Then Return

If keydown(KeyControl!) Then
	If Keydown(KeyUpArrow!) Or Keydown(KeyDownArrow!) Then This.SelectRow(0,false)
		
	If IsSelected(currentrow) Then
	  This.SelectRow(currentrow,false)
   Else
	  This.SelectRow(currentrow,True)
   end If
ElseIf keydown(keyShift!) Then
	This.SelectRow(0,false)
   If il_sRow < currentrow Then
		fr_row  = il_sRow
		to_row  = currentrow
	Else
		fr_row = currentrow
		to_row = il_sRow
	End If

	For ix = fr_row To to_row
		This.SelectRow(ix,true)
	Next
Else
	This.SelectRow(0,false)
	This.SelectRow(currentrow,true)
	il_sRow = currentrow
End If
end event

type sle_2 from w_inherite_popup`sle_2 within w_exppid_popup
boolean visible = false
integer x = 1006
integer width = 1138
boolean enabled = false
string text = "*"
end type

event sle_2::getfocus;f_toggle_kor(Handle(this))

end event

type cb_1 from w_inherite_popup`cb_1 within w_exppid_popup
boolean visible = false
integer y = 1836
integer taborder = 40
boolean enabled = false
end type

type cb_return from w_inherite_popup`cb_return within w_exppid_popup
boolean visible = false
integer x = 1559
integer y = 1836
integer taborder = 60
boolean enabled = false
end type

type cb_inq from w_inherite_popup`cb_inq within w_exppid_popup
boolean visible = false
integer x = 1248
integer y = 1836
integer taborder = 50
boolean enabled = false
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_exppid_popup
boolean visible = false
integer x = 704
integer y = 1888
integer width = 471
long backcolor = 16777215
boolean enabled = false
integer limit = 11
end type

type st_1 from w_inherite_popup`st_1 within w_exppid_popup
boolean visible = false
integer x = 46
integer y = 1904
integer width = 672
long textcolor = 128
string text = "Proforma Invoice No."
alignment alignment = left!
end type

type rr_1 from roundrectangle within w_exppid_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 180
integer width = 3529
integer height = 1464
integer cornerheight = 40
integer cornerwidth = 55
end type

