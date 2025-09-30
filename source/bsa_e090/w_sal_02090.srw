$PBExportHeader$w_sal_02090.srw
$PBExportComments$월 출하율 기준 등록
forward
global type w_sal_02090 from w_inherite
end type
type dw_1 from datawindow within w_sal_02090
end type
type cb_1 from commandbutton within w_sal_02090
end type
type dw_2 from datawindow within w_sal_02090
end type
type st_2 from statictext within w_sal_02090
end type
type st_3 from statictext within w_sal_02090
end type
type st_4 from statictext within w_sal_02090
end type
type st_5 from statictext within w_sal_02090
end type
type st_6 from statictext within w_sal_02090
end type
type st_7 from statictext within w_sal_02090
end type
type st_9 from statictext within w_sal_02090
end type
type st_10 from statictext within w_sal_02090
end type
type st_11 from statictext within w_sal_02090
end type
type st_12 from statictext within w_sal_02090
end type
type st_13 from statictext within w_sal_02090
end type
type st_14 from statictext within w_sal_02090
end type
type st_15 from statictext within w_sal_02090
end type
type st_16 from statictext within w_sal_02090
end type
type st_17 from statictext within w_sal_02090
end type
type st_18 from statictext within w_sal_02090
end type
type st_19 from statictext within w_sal_02090
end type
type pb_1 from u_pb_cal within w_sal_02090
end type
type rr_1 from roundrectangle within w_sal_02090
end type
type rr_2 from roundrectangle within w_sal_02090
end type
type rr_3 from roundrectangle within w_sal_02090
end type
end forward

global type w_sal_02090 from w_inherite
string title = "월 출하율 기준 등록"
dw_1 dw_1
cb_1 cb_1
dw_2 dw_2
st_2 st_2
st_3 st_3
st_4 st_4
st_5 st_5
st_6 st_6
st_7 st_7
st_9 st_9
st_10 st_10
st_11 st_11
st_12 st_12
st_13 st_13
st_14 st_14
st_15 st_15
st_16 st_16
st_17 st_17
st_18 st_18
st_19 st_19
pb_1 pb_1
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
end type
global w_sal_02090 w_sal_02090

forward prototypes
public function integer wf_requiredchk (integer il_currow)
public subroutine wf_changed_flag (datawindow dw_object)
end prototypes

public function integer wf_requiredchk (integer il_currow);dec l_from

dw_insert.AcceptText()

l_from = dw_insert.GetItemNumber(il_currow,"sugum_rate_from")

IF IsNull(l_from) THEN
	f_message_chk(30,'[수금율 FROM]')
	dw_insert.SetColumn("sugum_rate_from")
	dw_insert.ScrollToRow(il_currow)
	dw_insert.SetFocus()
	Return -1
END IF 

Return 1
end function

public subroutine wf_changed_flag (datawindow dw_object);Integer k

FOR k = 1 TO dw_Object.RowCount()
	dw_Object.SetItem(k,"flag",'1')
NEXT
end subroutine

on w_sal_02090.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.cb_1=create cb_1
this.dw_2=create dw_2
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.st_5=create st_5
this.st_6=create st_6
this.st_7=create st_7
this.st_9=create st_9
this.st_10=create st_10
this.st_11=create st_11
this.st_12=create st_12
this.st_13=create st_13
this.st_14=create st_14
this.st_15=create st_15
this.st_16=create st_16
this.st_17=create st_17
this.st_18=create st_18
this.st_19=create st_19
this.pb_1=create pb_1
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.dw_2
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.st_4
this.Control[iCurrent+7]=this.st_5
this.Control[iCurrent+8]=this.st_6
this.Control[iCurrent+9]=this.st_7
this.Control[iCurrent+10]=this.st_9
this.Control[iCurrent+11]=this.st_10
this.Control[iCurrent+12]=this.st_11
this.Control[iCurrent+13]=this.st_12
this.Control[iCurrent+14]=this.st_13
this.Control[iCurrent+15]=this.st_14
this.Control[iCurrent+16]=this.st_15
this.Control[iCurrent+17]=this.st_16
this.Control[iCurrent+18]=this.st_17
this.Control[iCurrent+19]=this.st_18
this.Control[iCurrent+20]=this.st_19
this.Control[iCurrent+21]=this.pb_1
this.Control[iCurrent+22]=this.rr_1
this.Control[iCurrent+23]=this.rr_2
this.Control[iCurrent+24]=this.rr_3
end on

on w_sal_02090.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.cb_1)
destroy(this.dw_2)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.st_6)
destroy(this.st_7)
destroy(this.st_9)
destroy(this.st_10)
destroy(this.st_11)
destroy(this.st_12)
destroy(this.st_13)
destroy(this.st_14)
destroy(this.st_15)
destroy(this.st_16)
destroy(this.st_17)
destroy(this.st_18)
destroy(this.st_19)
destroy(this.pb_1)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
end on

event open;call super::open;string s_date

dw_1.settransobject(sqlca)
dw_2.settransobject(sqlca)
dw_insert.settransobject(sqlca)
dw_insert.Reset()

dw_1.insertrow(0)
dw_1.setcolumn("start_date")
dw_1.setfocus()
dw_2.Retrieve()
ib_any_typing = false


end event

type dw_insert from w_inherite`dw_insert within w_sal_02090
integer x = 791
integer y = 352
integer width = 2857
integer height = 1960
integer taborder = 20
string dataobject = "d_sal_02090_02"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event dw_insert::itemchanged;long   nRow,l_day,l_fnd,l_data,ix
string s_date
Double l_from, l_to

nRow  = this.GetRow()
If nRow <= 0 Then Return

Choose Case GetColumnName()
	Case "sugum_rate_from"
      l_from = Double(GetText())
      l_to   = this.getitemnumber(nRow,"sugum_rate_to")
		If IsNull(l_to) Then l_to = 100.0
		
		If Double(gettext()) > 100 then
		  messagebox("확 인","수금율은 100%를 초과할 수 없습니다!!")
		  return 2
		End If

		If l_from > l_to then
		  f_message_chk(34,'[수금율 FROM ~ TO]')
		  Return 2
		End if

		l_data = Double(GetText())
		For ix = 1 To RowCount()
		  If nRow = ix Then continue
		  
		  l_from = this.getitemnumber(ix,"sugum_rate_from")
		  l_to   = this.getitemnumber(ix,"sugum_rate_to")
		  If l_from <= l_data and l_data <= l_to then
			  f_message_chk(204,'')
			  return 2
			End If
		Next
	Case "sugum_rate_to"
      l_to     = Double(GetText())
      l_from   = this.getitemnumber(nRow,"sugum_rate_from")
		If IsNull(l_from) Then l_from = 0
		
		If Double(gettext()) > 100 then
		  messagebox("확 인","수금율은 100%를 초과할 수 없습니다!!")
		  return 2
		End If

		If l_from > l_to then
		  f_message_chk(34,'[수금율 FROM ~ TO]')
		  Return 2
		End if

		l_data = Double(GetText())
		For ix = 1 To RowCount()
		  If nRow = ix Then continue
		  
		  l_from = this.getitemnumber(ix,"sugum_rate_from")
		  l_to   = this.getitemnumber(ix,"sugum_rate_to")
		  If l_from <= l_data and l_data <= l_to then
			  f_message_chk(204,'')
			  this.setcolumn(GetColumnName())
			  return 2
			End If
		Next
Case "inv_control"
   If Trim(GetText()) = 'N' Then
		SetItem(nRow,'inv_control_day',0)
	Else
		Post SetRow(nRow)
		Post SetColumn('inv_control_day')
	End If
Case "inv_control_day" 
	l_day = long(this.gettext())
	
   if l_day > 31 then
      messagebox("확 인","입력하신 [출하통제시기]의 날짜는 31일을 초과할 수 없습니다!!")  
		return 1
	end if
End Choose

///////////////////////////////////////////////////////////////////////////////////////
ib_any_typing =True
end event

event dw_insert::itemerror;return 1
end event

event dw_insert::rowfocuschanged;this.SetRowFocusIndicator(Hand!)
end event

type p_delrow from w_inherite`p_delrow within w_sal_02090
boolean visible = false
integer x = 2587
integer y = 64
end type

type p_addrow from w_inherite`p_addrow within w_sal_02090
boolean visible = false
integer x = 2414
integer y = 64
end type

type p_search from w_inherite`p_search within w_sal_02090
boolean visible = false
integer x = 1719
integer y = 64
end type

type p_ins from w_inherite`p_ins within w_sal_02090
integer x = 3735
end type

event p_ins::clicked;call super::clicked;Int il_currow, iRtnValue, i
string s_date

If dw_1.AcceptText() <> 1 Then Return 

s_date = dw_1.getitemstring(1, "start_date")

// 적용시작일을 입력하지 않고 [tab]을 click한 경우
if s_date = "" or isnull(s_date) then 
	f_message_chk(30,'[적용시작일]')
	dw_1.setcolumn("start_date")
	dw_1.setfocus()
   return 
end if	

FOR i= 1 TO dw_insert.rowcount()
    if Wf_RequiredChk(i) = -1 then return 
NEXT

il_CurRow = dw_insert.InsertRow(0)
If il_CurRow = 1 Then
  dw_1.Modify('start_date.protect = 1')       // key protect
//dw_1.Modify("start_date.background.color = 80859087") 	
End If

dw_insert.Setitem(il_CurRow, "start_date", s_date) 
dw_insert.ScrollToRow(il_currow)
dw_insert.setcolumn("sugum_rate_from")
dw_insert.SetFocus()
w_mdi_frame.sle_msg.text = "새로운 자료를 입력하십시요!!"

end event

type p_exit from w_inherite`p_exit within w_sal_02090
integer x = 4430
end type

type p_can from w_inherite`p_can within w_sal_02090
integer x = 4256
end type

event p_can::clicked;call super::clicked;string snull

setnull(snull)
dw_insert.Reset()

dw_1.setfocus()
dw_1.Modify('start_date.protect = 0')
//dw_1.Modify("start_date.background.color = '"+String(Rgb(190,225,184))+"'")
dw_1.setitem(1, "start_date", snull)
dw_1.setcolumn("start_date")

ib_any_typing = false
end event

type p_print from w_inherite`p_print within w_sal_02090
boolean visible = false
integer x = 1893
integer y = 64
end type

type p_inq from w_inherite`p_inq within w_sal_02090
integer x = 3561
end type

event p_inq::clicked;call super::clicked;string s_date
int    nRow

If dw_1.AcceptText() <> 1 Then Return 

nRow = dw_1.Rowcount()
If nRow <= 0 Then Return

s_date = dw_1.getitemstring(nRow, "start_date")

// 적용시작일을 입력하지 않고 [조회]를 click한 경우
if s_date = "" or isnull(s_date) then 
	f_message_chk(30,'[적용시작일]')
	dw_1.setcolumn("start_date")
	dw_1.setfocus()
   return 
end if	

If dw_insert.retrieve(s_date) <= 0 then
	dw_1.setfocus()
	dw_1.setcolumn("start_date")
   Return
End if

dw_1.Modify('start_date.protect = 1')       // key protect

dw_insert.SetColumn("sugum_rate_from")
dw_insert.SetFocus()
ib_any_typing = false
end event

type p_del from w_inherite`p_del within w_sal_02090
integer x = 4082
end type

event p_del::clicked;call super::clicked;sle_msg.text = ''

If dw_insert.AcceptText() <> 1 Then Return 

IF dw_insert.GetRow() <=0 THEN
	messagebox("확 인","삭제할 행이 없습니다. ~n~n삭제할 행을 선택하고 [삭제]하세요!!")
	Return
END IF

IF f_msg_delete() = -1 THEN RETURN

dw_insert.DeleteRow(dw_insert.getrow())

IF dw_insert.Update() = 1  THEN
	COMMIT USING SQLCA;
  	w_mdi_frame.sle_msg.text = '삭제되었습니다!!'
ELSE
	ROLLBACK USING SQLCA;

END IF 
dw_insert.ScrollToRow(dw_insert.RowCount())
dw_insert.setcolumn("sugum_rate_from")
dw_insert.SetFocus()
end event

type p_mod from w_inherite`p_mod within w_sal_02090
integer x = 3909
end type

event p_mod::clicked;call super::clicked;Integer k, l_row, l_from, inull, l_to,ix
String  s_date

setnull(inull)

If dw_1.AcceptText() <> 1 Then Return 
IF dw_insert.Accepttext() = -1 THEN RETURN

l_row = dw_insert.getrow()
s_date = dw_1.GetItemString(1, "start_date")  

////필수입력 항목 체크/////////////////////////////////////////////////
IF IsNull(s_date) or trim(s_date) = '' THEN
	f_message_chk(30,'[적용시작일]')
	dw_1.SetColumn("start_date")
	dw_1.SetFocus()
	RETURN 
END IF

IF dw_insert.RowCount() > 0 THEN
	FOR k = 1 TO dw_insert.RowCount()
		IF Wf_RequiredChk(dw_insert.GetRow()) = -1 THEN RETURN
	NEXT
ELSE
	Return
END IF

////////////////////////////////////////////////////////////////////////////
if MessageBox("확 인", "저장하시겠습니까?", question!, yesno!) = 2 THEN	RETURN

/* 일련번호 재부여 */
For ix = 1 To dw_insert.RowCount()
	dw_insert.SetItem(ix,'seqno',ix)
Next

IF dw_insert.Update() > 0 THEN			
	COMMIT;
	ib_any_typing =False

	Wf_Changed_Flag(dw_insert)
	
	w_mdi_frame.sle_msg.text ="자료를 저장하였습니다!!"
ELSE
	ROLLBACK;
	ib_any_typing = True
	Return
END IF

// 저장하고 나서 지정된 행으로 커서를 이동시킨다.
dw_insert.ScrollToRow(dw_insert.RowCount())
dw_insert.SetColumn("sugum_rate_from")
dw_insert.Setfocus()

end event

type cb_exit from w_inherite`cb_exit within w_sal_02090
boolean visible = false
integer x = 2523
integer y = 16
integer taborder = 90
end type

type cb_mod from w_inherite`cb_mod within w_sal_02090
boolean visible = false
integer x = 1426
integer y = 16
integer taborder = 60
end type

event cb_mod::clicked;call super::clicked;Integer k, l_row, l_from, inull, l_to,ix
String  s_date

setnull(inull)

If dw_1.AcceptText() <> 1 Then Return 
IF dw_insert.Accepttext() = -1 THEN RETURN

l_row = dw_insert.getrow()
s_date = dw_1.GetItemString(1, "start_date")  

////필수입력 항목 체크/////////////////////////////////////////////////
IF IsNull(s_date) or trim(s_date) = '' THEN
	f_message_chk(30,'[적용시작일]')
	dw_1.SetColumn("start_date")
	dw_1.SetFocus()
	RETURN 
END IF

IF dw_insert.RowCount() > 0 THEN
	FOR k = 1 TO dw_insert.RowCount()
		IF Wf_RequiredChk(dw_insert.GetRow()) = -1 THEN RETURN
	NEXT
ELSE
	Return
END IF

////////////////////////////////////////////////////////////////////////////
if MessageBox("확 인", "저장하시겠습니까?", question!, yesno!) = 2 THEN	RETURN

/* 일련번호 재부여 */
For ix = 1 To dw_insert.RowCount()
	dw_insert.SetItem(ix,'seqno',ix)
Next

IF dw_insert.Update() > 0 THEN			
	COMMIT;
	ib_any_typing =False

	Wf_Changed_Flag(dw_insert)
	
	w_mdi_frame.sle_msg.text ="자료를 저장하였습니다!!"
ELSE
	ROLLBACK;
	ib_any_typing = True
	Return
END IF

// 저장하고 나서 지정된 행으로 커서를 이동시킨다.
dw_insert.ScrollToRow(dw_insert.RowCount())
dw_insert.SetColumn("sugum_rate_from")
dw_insert.Setfocus()

end event

type cb_ins from w_inherite`cb_ins within w_sal_02090
boolean visible = false
integer x = 119
integer y = 2380
end type

type cb_del from w_inherite`cb_del within w_sal_02090
boolean visible = false
integer x = 1792
integer y = 16
integer taborder = 70
end type

event cb_del::clicked;call super::clicked;sle_msg.text = ''

If dw_insert.AcceptText() <> 1 Then Return 

IF dw_insert.GetRow() <=0 THEN
	messagebox("확 인","삭제할 행이 없습니다. ~n~n삭제할 행을 선택하고 [삭제]하세요!!")
	Return
END IF

IF f_msg_delete() = -1 THEN RETURN

dw_insert.DeleteRow(dw_insert.getrow())

IF dw_insert.Update() = 1  THEN
	COMMIT USING SQLCA;
  	w_mdi_frame.sle_msg.text = '삭제되었습니다!!'
ELSE
	ROLLBACK USING SQLCA;

END IF 
dw_insert.ScrollToRow(dw_insert.RowCount())
dw_insert.setcolumn("sugum_rate_from")
dw_insert.SetFocus()
end event

type cb_inq from w_inherite`cb_inq within w_sal_02090
boolean visible = false
integer x = 1426
integer y = 128
integer taborder = 50
end type

event cb_inq::clicked;call super::clicked;string s_date
int    nRow

If dw_1.AcceptText() <> 1 Then Return 

nRow = dw_1.Rowcount()
If nRow <= 0 Then Return

s_date = dw_1.getitemstring(nRow, "start_date")

// 적용시작일을 입력하지 않고 [조회]를 click한 경우
if s_date = "" or isnull(s_date) then 
	f_message_chk(30,'[적용시작일]')
	dw_1.setcolumn("start_date")
	dw_1.setfocus()
   return 
end if	

If dw_insert.retrieve(s_date) <= 0 then
	dw_1.setfocus()
	dw_1.setcolumn("start_date")
   Return
End if

dw_1.Modify('start_date.protect = 1')       // key protect

dw_insert.SetColumn("sugum_rate_from")
dw_insert.SetFocus()
ib_any_typing = false

end event

type cb_print from w_inherite`cb_print within w_sal_02090
boolean visible = false
integer x = 453
integer y = 2380
end type

type st_1 from w_inherite`st_1 within w_sal_02090
end type

type cb_can from w_inherite`cb_can within w_sal_02090
boolean visible = false
integer x = 2158
integer y = 16
integer taborder = 80
end type

event cb_can::clicked;call super::clicked;string snull

setnull(snull)
dw_insert.Reset()

dw_1.setfocus()
dw_1.Modify('start_date.protect = 0')
//dw_1.Modify("start_date.background.color = '"+String(Rgb(190,225,184))+"'")
dw_1.setitem(1, "start_date", snull)
dw_1.setcolumn("start_date")

ib_any_typing = false

end event

type cb_search from w_inherite`cb_search within w_sal_02090
boolean visible = false
integer x = 786
integer y = 2380
end type







type gb_button1 from w_inherite`gb_button1 within w_sal_02090
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_02090
end type

type dw_1 from datawindow within w_sal_02090
integer x = 27
integer y = 44
integer width = 850
integer height = 136
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_sal_02090_01"
boolean border = false
boolean livescroll = true
end type

event itemchanged;Choose Case GetColumnName()
	Case "start_date" 
		IF f_datechk(trim(Gettext())) = -1	then    //날짜 유효성 체크 /////////////////
         f_message_chk(35,'[적용시작일]')
		   return 2
	   END IF
		cb_inq.PostEvent(Clicked!) // 조회
End Choose


end event

event itemerror;return 1
end event

type cb_1 from commandbutton within w_sal_02090
boolean visible = false
integer x = 1792
integer y = 128
integer width = 334
integer height = 108
integer taborder = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "추가(&A)"
end type

event clicked;Int il_currow, iRtnValue, i
string s_date

If dw_1.AcceptText() <> 1 Then Return 

s_date = dw_1.getitemstring(1, "start_date")

// 적용시작일을 입력하지 않고 [tab]을 click한 경우
if s_date = "" or isnull(s_date) then 
	f_message_chk(30,'[적용시작일]')
	dw_1.setcolumn("start_date")
	dw_1.setfocus()
   return 
end if	

FOR i= 1 TO dw_insert.rowcount()
    if Wf_RequiredChk(i) = -1 then return 
NEXT

il_CurRow = dw_insert.InsertRow(0)
If il_CurRow = 1 Then
  dw_1.Modify('start_date.protect = 1')       // key protect
  dw_1.Modify("start_date.background.color = 80859087") 	
End If

dw_insert.Setitem(il_CurRow, "start_date", s_date) 
dw_insert.ScrollToRow(il_currow)
dw_insert.setcolumn("sugum_rate_from")
dw_insert.SetFocus()
w_mdi_frame.sle_msg.text = "새로운 자료를 입력하십시요!!"

end event

type dw_2 from datawindow within w_sal_02090
integer x = 41
integer y = 352
integer width = 631
integer height = 1960
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_sal_02090_03"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;If row <= 0 Then Return

dw_1.SetItem(1,'start_date',dw_2.GetItemString(row,'start_date'))

cb_inq.PostEvent(Clicked!) // 조회
end event

type st_2 from statictext within w_sal_02090
integer x = 791
integer y = 260
integer width = 2857
integer height = 84
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16777215
long backcolor = 28144969
boolean enabled = false
string text = "할인율 변경 등록"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_3 from statictext within w_sal_02090
integer x = 37
integer y = 260
integer width = 631
integer height = 84
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16777215
long backcolor = 28144969
boolean enabled = false
string text = "적용시작일 선택"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_4 from statictext within w_sal_02090
integer x = 3735
integer y = 288
integer width = 247
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
boolean enabled = false
string text = "수금율"
boolean focusrectangle = false
end type

type st_5 from statictext within w_sal_02090
integer x = 3758
integer y = 360
integer width = 754
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "(당월미수금/당월수금*100)로"
boolean focusrectangle = false
end type

type st_6 from statictext within w_sal_02090
integer x = 3758
integer y = 436
integer width = 754
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "적용수금율의 범위를 입력"
boolean focusrectangle = false
end type

type st_7 from statictext within w_sal_02090
integer x = 3735
integer y = 544
integer width = 315
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
boolean enabled = false
string text = "할인율증감"
boolean focusrectangle = false
end type

type st_9 from statictext within w_sal_02090
integer x = 3758
integer y = 608
integer width = 754
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "거래처의 수금율에 따라 기본"
boolean focusrectangle = false
end type

type st_10 from statictext within w_sal_02090
integer x = 3758
integer y = 680
integer width = 795
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "할인율에 더해질 추가할인율을"
boolean focusrectangle = false
end type

type st_11 from statictext within w_sal_02090
integer x = 3758
integer y = 752
integer width = 795
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "입력 Ex) 5%추가할 경우 5입력"
boolean focusrectangle = false
end type

type st_12 from statictext within w_sal_02090
integer x = 3735
integer y = 872
integer width = 375
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
boolean enabled = false
string text = "출하통제여부"
boolean focusrectangle = false
end type

type st_13 from statictext within w_sal_02090
integer x = 3758
integer y = 940
integer width = 795
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "통제란에 체크시 해당수금율의"
boolean focusrectangle = false
end type

type st_14 from statictext within w_sal_02090
integer x = 3758
integer y = 1016
integer width = 795
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "거래처는 수주입력시 미승인됨"
boolean focusrectangle = false
end type

type st_15 from statictext within w_sal_02090
integer x = 3735
integer y = 1116
integer width = 375
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
boolean enabled = false
string text = "출하통제시기"
boolean focusrectangle = false
end type

type st_16 from statictext within w_sal_02090
integer x = 3758
integer y = 1188
integer width = 832
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "출하통제시 수금마감일 이후"
boolean focusrectangle = false
end type

type st_17 from statictext within w_sal_02090
integer x = 3758
integer y = 1256
integer width = 832
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "몇일이후에 적용될것인가를 입력"
boolean focusrectangle = false
end type

type st_18 from statictext within w_sal_02090
integer x = 3735
integer y = 1360
integer width = 375
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
boolean enabled = false
string text = "적용시작일"
boolean focusrectangle = false
end type

type st_19 from statictext within w_sal_02090
integer x = 3758
integer y = 1428
integer width = 832
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "할인율을 적용할 일자를 입력"
boolean focusrectangle = false
end type

type pb_1 from u_pb_cal within w_sal_02090
integer x = 736
integer y = 64
integer width = 78
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_1.SetColumn('start_date')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_1.SetItem(1, 'start_date', gs_code)

end event

type rr_1 from roundrectangle within w_sal_02090
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 9
integer y = 244
integer width = 695
integer height = 2096
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_sal_02090
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 768
integer y = 244
integer width = 2907
integer height = 2096
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_sal_02090
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 3707
integer y = 244
integer width = 905
integer height = 2096
integer cornerheight = 40
integer cornerwidth = 55
end type

