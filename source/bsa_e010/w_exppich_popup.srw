$PBExportHeader$w_exppich_popup.srw
$PBExportComments$P/I Charge 선택 POPUP
forward
global type w_exppich_popup from w_inherite_popup
end type
type rr_1 from roundrectangle within w_exppich_popup
end type
type ln_1 from line within w_exppich_popup
end type
end forward

global type w_exppich_popup from w_inherite_popup
integer x = 704
integer y = 248
integer width = 2025
integer height = 1812
string title = "Proforma Invoice Charge. 선택"
rr_1 rr_1
ln_1 ln_1
end type
global w_exppich_popup w_exppich_popup

type variables
boolean ib_down
long  il_sRow = 1
String isSaupj
end variables

on w_exppich_popup.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.ln_1=create ln_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.ln_1
end on

on w_exppich_popup.destroy
call super::destroy
destroy(this.rr_1)
destroy(this.ln_1)
end on

event open;call super::open;string spino,scvcod


sle_1.text = gs_code

spino  = trim(gs_code)
scvcod = trim(gs_gubun)
isSaupj = gs_codename

IF IsNull(spino)  Then spino = "" 
IF IsNull(scvcod) Then scvcod = "" 

dw_1.Retrieve(gs_sabu,spino+'%',scvcod+'%', isSaupj)	
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_exppich_popup
boolean visible = false
integer x = 1819
integer y = 1792
integer width = 219
integer height = 140
end type

type p_exit from w_inherite_popup`p_exit within w_exppich_popup
integer x = 1829
integer y = 16
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_exppich_popup
integer x = 1481
integer y = 16
end type

event p_inq::clicked;call super::clicked;string spino,scvcod

spino  = trim(sle_1.Text)
scvcod = trim(gs_gubun)

IF IsNull(spino)  Then spino = "" 
IF IsNull(scvcod) Then scvcod = "" 

dw_1.Retrieve(gs_sabu,spino+'%',scvcod+'%',isSaupj)	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()

dw_1.SetRedraw(True)

end event

type p_choose from w_inherite_popup`p_choose within w_exppich_popup
integer x = 1655
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

//If sCnt =  1 Then     // return 갯수가 1개이면
//  gs_code  = dw_1.GetItemString(1, "pino")
//  gs_gubun = String(dw_1.GetItemNumber(1, "piseq"))
//ElseIf sCnt > 1 Then   // 선택된 갯수가 여러개이면 'M'ulti
  gs_gubun = 'M'
  dw_1.SaveAs("dummy",Clipboard!,false) 
//End If

Close(Parent)
end event

type dw_1 from w_inherite_popup`dw_1 within w_exppich_popup
integer x = 55
integer y = 188
integer width = 1929
integer height = 1500
integer taborder = 20
string dataobject = "d_exppich_popup"
boolean hscrollbar = true
end type

event dw_1::doubleclicked;IF Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

cb_1.PostEvent(Clicked!)

//gs_code  = dw_1.GetItemString(Row, "pino")
//gs_gubun = String(dw_1.GetItemNumber(Row, "piseq"))

//Close(Parent)
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

type sle_2 from w_inherite_popup`sle_2 within w_exppich_popup
boolean visible = false
integer x = 1006
integer width = 1138
integer taborder = 0
boolean enabled = false
string text = "*"
end type

event sle_2::getfocus;f_toggle_kor(Handle(this))

end event

type cb_1 from w_inherite_popup`cb_1 within w_exppich_popup
boolean visible = false
integer x = 832
integer y = 1872
boolean enabled = false
end type

type cb_return from w_inherite_popup`cb_return within w_exppich_popup
boolean visible = false
integer x = 1454
integer y = 1872
boolean enabled = false
end type

type cb_inq from w_inherite_popup`cb_inq within w_exppich_popup
boolean visible = false
integer x = 1143
integer y = 1872
boolean enabled = false
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_exppich_popup
integer x = 754
integer y = 92
integer width = 471
integer height = 56
long backcolor = 32106727
integer limit = 11
end type

type st_1 from w_inherite_popup`st_1 within w_exppich_popup
integer x = 32
integer y = 92
integer width = 722
string text = "Proforma Invoice No."
end type

type rr_1 from roundrectangle within w_exppich_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 176
integer width = 1957
integer height = 1520
integer cornerheight = 40
integer cornerwidth = 55
end type

type ln_1 from line within w_exppich_popup
long linecolor = 28144969
integer linethickness = 1
integer beginx = 1211
integer beginy = 152
integer endx = 759
integer endy = 152
end type

