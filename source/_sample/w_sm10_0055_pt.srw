$PBExportHeader$w_sm10_0055_pt.srw
$PBExportComments$VAN접수 파트너VAN(파워텍생산코드)
forward
global type w_sm10_0055_pt from w_inherite
end type
type dw_2 from datawindow within w_sm10_0055_pt
end type
type cb_1 from commandbutton within w_sm10_0055_pt
end type
type rb_1 from radiobutton within w_sm10_0055_pt
end type
type rb_2 from radiobutton within w_sm10_0055_pt
end type
type dw_1 from datawindow within w_sm10_0055_pt
end type
type pb_1 from u_pb_cal within w_sm10_0055_pt
end type
type rr_2 from roundrectangle within w_sm10_0055_pt
end type
type rr_1 from roundrectangle within w_sm10_0055_pt
end type
end forward

global type w_sm10_0055_pt from w_inherite
string title = "파워텍 VAN 접수(생산코드)"
dw_2 dw_2
cb_1 cb_1
rb_1 rb_1
rb_2 rb_2
dw_1 dw_1
pb_1 pb_1
rr_2 rr_2
rr_1 rr_1
end type
global w_sm10_0055_pt w_sm10_0055_pt

forward prototypes
public subroutine wf_day ()
public subroutine wf_week ()
end prototypes

public subroutine wf_day ();String ls_docname
String ls_named[]
Long   ll_value

//Excel IMPORT ***************************************************************

ll_value = GetFileOpenName("일일 납품계획 Data 가져오기", ls_docname, ls_named[], & 
             "XLS", "XLS Files (*.XLS),*.XLS,")

If ll_value <> 1 Then Return

dw_insert.Reset()
w_mdi_frame.sle_msg.text =''

Setpointer(Hourglass!)

If FileExists('c:\erpman\bin\date_conv.xls') = False Then
	MessageBox('확인','date_conv.xls'+' 파일이 존재하지 않습니다.')
	Return
End If

uo_xlobject uo_xl
uo_xlobject uo_xltemp

uo_xltemp = Create uo_xlobject
uo_xltemp.uf_excel_connect('c:\erpman\bin\date_conv.xls', False, 3)
uo_xltemp.uf_selectsheet(1)
uo_xltemp.uf_set_format(1, 1, '@' + Space(30))

Long   ix
Long   ll_xl_row
Long   ll_r
Long   ll_cnt
Long   i
Long   ll_dqty, ll_dqtyold
Long   ll_find
String ls_file
String ls_gubun
String ls_name
String ls_dqty
String ls_bigo
String ls_ymd

ls_ymd = dw_2.GetItemString(1, 'd_st')
If Trim(ls_ymd) = '' OR IsNull(ls_ymd) Then
	MessageBox('기준일 확인', '기준일은 필수 항목 입니다.~r~n기준일을 입력 하십시오.')
	Return
End If

For ix = 1 To UpperBound(ls_named)
	
	If UpperBound(ls_named) = 1 Then
		ls_file = ls_docname
	else
		ls_file = ls_docname +'\'+ ls_named[ix]
	end if
	
	If  FileExists(ls_file) = False Then
		MessageBox('확인',ls_file+' 파일이 존재하지 않습니다.')
		Return
	End If 
	
	uo_xl = create uo_xlobject
			
	//엑셀과 연결
	uo_xl.uf_excel_connect(ls_file, false , 3)
	
	uo_xl.uf_selectsheet(1)
	
	//Data 시작 Row Setting////
	ll_xl_row = 2
	///////////////////////////
	
	Do While(True)
		
		//Data가 없을경우엔 Return...........
		If IsNull(uo_xl.uf_gettext(ll_xl_row, 2)) OR Trim(uo_xl.uf_gettext(ll_xl_row, 2)) = '' Then Exit
		 
		ll_cnt++
		
		dw_insert.ScrollToRow(ll_r)
		
		//Excel 셀-Format 지정
		For i = 1 To 10
			uo_xl.uf_set_format(ll_xl_row, i, '@' + Space(30))
		Next
		
		//////////////////////////////////////////////////////////////////////
		ls_gubun = Trim(uo_xl.uf_gettext(ll_xl_row, 2)) //생산코드
		ls_dqty  = Trim(uo_xl.uf_gettext(ll_xl_row, 3)) //수량
		
		ll_dqty  = Long(ls_dqty)
		//////////////////////////////////////////////////////////////////////
		w_mdi_frame.sle_msg.text = ls_gubun + ' / ' + String(ll_cnt) + '행'
		
		If IsNull(ls_gubun) OR Trim(ls_gubun) = '' Then
			uo_xl.uf_excel_Disconnect()
			uo_xltemp.uf_excel_Disconnect()
			Exit
		End If
		
		ll_find = dw_insert.FIND("cdate = '" + ls_ymd + "' and gubun = '" + ls_gubun + "'", 1, ll_cnt)
		
		If ll_find > 0 Then
			ll_dqtyold = dw_insert.GetItemNumber(ll_find, 'dqty')
			dw_insert.SetItem(ll_find, 'dqty', ll_dqty + ll_dqtyold)
		Else
			ll_r = dw_insert.InsertRow(0)
			
			dw_insert.SetItem(ll_r, 'cdate' , ls_ymd  )
			dw_insert.SetItem(ll_r, 'gubun' , ls_gubun)
			dw_insert.SetItem(ll_r, 'dqty'  , ll_dqty )
		End If
		
		ll_xl_row++
		
		w_mdi_frame.sle_msg.text = ls_named[ix] + ' 파일의 ' + String(ll_xl_row) + '행을 읽고 있습니다.'
		
	Loop
	
	uo_xl.uf_excel_Disconnect()
	//엑셀 IMPORT END ***************************************************************

Next

uo_xltemp.uf_excel_Disconnect()

w_mdi_frame.sle_msg.text = '정상적으로 ' + String(ll_cnt) + '행이 Import 되었습니다.'

If dw_insert.UPDATE() = 1 Then
	COMMIT USING SQLCA;
	MessageBox('Import Success!', '자료가 저장 되었습니다.')
Else
	ROLLBACK USING SQLCA;
	MessageBox('Import Failure!', '자료 저장 중 오류가 발생했습니다.')
	Return
End If
end subroutine

public subroutine wf_week ();String ls_docname
String ls_named[]
Long   ll_value

//Excel IMPORT ***************************************************************

ll_value = GetFileOpenName("일일 납품계획 Data 가져오기", ls_docname, ls_named[], & 
             "XLS", "XLS Files (*.XLS),*.XLS,")

If ll_value <> 1 Then Return

dw_insert.Reset()
w_mdi_frame.sle_msg.text =''

Setpointer(Hourglass!)

If FileExists('c:\erpman\bin\date_conv.xls') = False Then
	MessageBox('확인','date_conv.xls'+' 파일이 존재하지 않습니다.')
	Return
End If

uo_xlobject uo_xl
uo_xlobject uo_xltemp

uo_xltemp = Create uo_xlobject
uo_xltemp.uf_excel_connect('c:\erpman\bin\date_conv.xls', False, 3)
uo_xltemp.uf_selectsheet(1)
uo_xltemp.uf_set_format(1, 1, '@' + Space(30))

Long   ix
Long   ll_xl_row
Long   ll_r
Long   ll_cnt
Long   i
Long   ll_d0, ll_d1, ll_d2, ll_d3, ll_d4, ll_d5, ll_d6, ll_d7, ll_d8, ll_d9, ll_d10, ll_d11
Long   ll_find
String ls_file
String ls_gubun
String ls_d0, ls_d1, ls_d2, ls_d3, ls_d4, ls_d5, ls_d6, ls_d7, ls_d8, ls_d9, ls_d10, ls_d11
String ls_ymd

ls_ymd = dw_2.GetItemString(1, 'd_st')
If Trim(ls_ymd) = '' OR IsNull(ls_ymd) Then
	MessageBox('기준일 확인', '기준일은 필수 항목 입니다.~r~n기준일을 입력 하십시오.')
	Return
End If

For ix = 1 To UpperBound(ls_named)
	
	If UpperBound(ls_named) = 1 Then
		ls_file = ls_docname
	else
		ls_file = ls_docname +'\'+ ls_named[ix]
	end if
	
	If  FileExists(ls_file) = False Then
		MessageBox('확인',ls_file+' 파일이 존재하지 않습니다.')
		Return
	End If 
	
	uo_xl = create uo_xlobject
			
	//엑셀과 연결
	uo_xl.uf_excel_connect(ls_file, false , 3)
	
	uo_xl.uf_selectsheet(1)
	
	//Data 시작 Row Setting////
	ll_xl_row = 2
	///////////////////////////
	
	Do While(True)
		
		//Data가 없을경우엔 Return...........
		If IsNull(uo_xl.uf_gettext(ll_xl_row, 2)) OR Trim(uo_xl.uf_gettext(ll_xl_row, 2)) = '' Then Exit
		
		ll_cnt++
		
		//Excel 셀-Format 지정
		For i = 1 To 10
			uo_xl.uf_set_format(ll_xl_row, i, '@' + Space(30))
		Next
		
		//////////////////////////////////////////////////////////////////////
		ls_gubun = Trim(uo_xl.uf_gettext(ll_xl_row, 2) ) //생산코드
		ls_d0    = Trim(uo_xl.uf_gettext(ll_xl_row, 3) ) //D0수량
		ls_d1    = Trim(uo_xl.uf_gettext(ll_xl_row, 4) ) //D1수량
		ls_d2    = Trim(uo_xl.uf_gettext(ll_xl_row, 5) ) //D2수량
		ls_d3    = Trim(uo_xl.uf_gettext(ll_xl_row, 6) ) //D3수량
		ls_d4    = Trim(uo_xl.uf_gettext(ll_xl_row, 7) ) //D4수량
		ls_d5    = Trim(uo_xl.uf_gettext(ll_xl_row, 8) ) //D5수량
		ls_d6    = Trim(uo_xl.uf_gettext(ll_xl_row, 9) ) //D6수량
		ls_d7    = Trim(uo_xl.uf_gettext(ll_xl_row, 10)) //D7수량
		ls_d8    = Trim(uo_xl.uf_gettext(ll_xl_row, 11)) //D8수량
		ls_d9    = Trim(uo_xl.uf_gettext(ll_xl_row, 12)) //D9수량
		ls_d10   = Trim(uo_xl.uf_gettext(ll_xl_row, 13)) //D10수량
		ls_d11   = Trim(uo_xl.uf_gettext(ll_xl_row, 14)) //D11수량
				
		ll_d0   = Long(ls_d0)
		ll_d1   = Long(ls_d1)
		ll_d2   = Long(ls_d2)
		ll_d3   = Long(ls_d3)
		ll_d4   = Long(ls_d4)
		ll_d5   = Long(ls_d5)
		ll_d6   = Long(ls_d6)
		ll_d7   = Long(ls_d7)
		ll_d8   = Long(ls_d8)
		ll_d9   = Long(ls_d9)
		ll_d10  = Long(ls_d10)
		ll_d11  = Long(ls_d11)
		//////////////////////////////////////////////////////////////////////
		w_mdi_frame.sle_msg.text = ls_gubun + ' / ' + String(ll_cnt) + '행'
		
		If IsNull(ls_gubun) OR Trim(ls_gubun) = '' Then
			uo_xl.uf_excel_Disconnect()
			uo_xltemp.uf_excel_Disconnect()
			Exit
		End If
		
		ll_find = dw_insert.FIND("cdate = '" + ls_ymd + "' and gubun = '" + ls_gubun + "'", 1, ll_cnt)
		
		If ll_find > 0 Then			
			dw_insert.SetItem(ll_find, 'd0' , dw_insert.GetItemNumber(ll_find, 'd0' ) + ll_d0 )
			dw_insert.SetItem(ll_find, 'd1' , dw_insert.GetItemNumber(ll_find, 'd1' ) + ll_d1 )
			dw_insert.SetItem(ll_find, 'd2' , dw_insert.GetItemNumber(ll_find, 'd2' ) + ll_d2 )
			dw_insert.SetItem(ll_find, 'd3' , dw_insert.GetItemNumber(ll_find, 'd3' ) + ll_d3 )
			dw_insert.SetItem(ll_find, 'd4' , dw_insert.GetItemNumber(ll_find, 'd4' ) + ll_d4 )
			dw_insert.SetItem(ll_find, 'd5' , dw_insert.GetItemNumber(ll_find, 'd5' ) + ll_d5 )
			dw_insert.SetItem(ll_find, 'd6' , dw_insert.GetItemNumber(ll_find, 'd6' ) + ll_d6 )
			dw_insert.SetItem(ll_find, 'd7' , dw_insert.GetItemNumber(ll_find, 'd7' ) + ll_d7 )
			dw_insert.SetItem(ll_find, 'd8' , dw_insert.GetItemNumber(ll_find, 'd8' ) + ll_d8 )
			dw_insert.SetItem(ll_find, 'd9' , dw_insert.GetItemNumber(ll_find, 'd9' ) + ll_d9 )
			dw_insert.SetItem(ll_find, 'd10', dw_insert.GetItemNumber(ll_find, 'd10') + ll_d10)
			dw_insert.SetItem(ll_find, 'd11', dw_insert.GetItemNumber(ll_find, 'd11') + ll_d11)
		Else
			ll_r = dw_insert.InsertRow(0)
			
			dw_insert.SetItem(ll_r, 'cdate', ls_ymd  )
			dw_insert.SetItem(ll_r, 'gubun', ls_gubun)
			dw_insert.SetItem(ll_r, 'd0'   , ll_d0   )
			dw_insert.SetItem(ll_r, 'd1'   , ll_d1   )
			dw_insert.SetItem(ll_r, 'd2'   , ll_d2   )
			dw_insert.SetItem(ll_r, 'd3'   , ll_d3   )
			dw_insert.SetItem(ll_r, 'd4'   , ll_d4   )
			dw_insert.SetItem(ll_r, 'd5'   , ll_d5   )
			dw_insert.SetItem(ll_r, 'd6'   , ll_d6   )
			dw_insert.SetItem(ll_r, 'd7'   , ll_d7   )
			dw_insert.SetItem(ll_r, 'd8'   , ll_d8   )
			dw_insert.SetItem(ll_r, 'd9'   , ll_d9   )
			dw_insert.SetItem(ll_r, 'd10'  , ll_d10  )
			dw_insert.SetItem(ll_r, 'd11'  , ll_d11  )
		End If
		
		dw_insert.ScrollToRow(ll_r)
		
		ll_xl_row++
		
		w_mdi_frame.sle_msg.text = ls_named[ix] + ' 파일의 ' + String(ll_xl_row) + '행을 읽고 있습니다.'
		
	Loop
	
	uo_xl.uf_excel_Disconnect()
	//엑셀 IMPORT END ***************************************************************

Next

uo_xltemp.uf_excel_Disconnect()

w_mdi_frame.sle_msg.text = '정상적으로 ' + String(ll_cnt) + '행이 Import 되었습니다.'

If dw_insert.UPDATE() = 1 Then
	COMMIT USING SQLCA;
	MessageBox('Import Success!', '자료가 저장 되었습니다.')
Else
	ROLLBACK USING SQLCA;
	MessageBox('Import Failure!', '자료 저장 중 오류가 발생했습니다.')
	Return
End If
end subroutine

on w_sm10_0055_pt.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.cb_1=create cb_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_1=create dw_1
this.pb_1=create pb_1
this.rr_2=create rr_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.rb_1
this.Control[iCurrent+4]=this.rb_2
this.Control[iCurrent+5]=this.dw_1
this.Control[iCurrent+6]=this.pb_1
this.Control[iCurrent+7]=this.rr_2
this.Control[iCurrent+8]=this.rr_1
end on

on w_sm10_0055_pt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_2)
destroy(this.cb_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_1)
destroy(this.pb_1)
destroy(this.rr_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_2.SetItem(1, 'd_st', String(TODAY(), 'yyyymmdd'))
end event

type dw_insert from w_inherite`dw_insert within w_sm10_0055_pt
integer x = 50
integer y = 256
integer width = 4512
integer height = 1976
string dataobject = "d_sm10_0055_pt_002"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event dw_insert::constructor;call super::constructor;This.SetTransObject(SQLCA)
end event

type p_delrow from w_inherite`p_delrow within w_sm10_0055_pt
boolean visible = false
integer x = 3662
integer y = 204
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_sm10_0055_pt
boolean visible = false
integer x = 3488
integer y = 204
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_sm10_0055_pt
boolean visible = false
integer x = 2793
integer y = 204
boolean enabled = false
string picturename = "C:\ERPMAN\image\button_up.gif"
end type

type p_ins from w_inherite`p_ins within w_sm10_0055_pt
boolean visible = false
integer x = 3314
integer y = 204
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_sm10_0055_pt
integer x = 4357
integer y = 44
end type

type p_can from w_inherite`p_can within w_sm10_0055_pt
integer x = 4183
integer y = 44
end type

event p_can::clicked;call super::clicked;dw_insert.ReSet()
dw_2.ReSet()

dw_2.InsertRow(0)
end event

type p_print from w_inherite`p_print within w_sm10_0055_pt
boolean visible = false
integer x = 2967
integer y = 204
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_sm10_0055_pt
boolean visible = false
integer x = 3662
integer y = 44
end type

event p_inq::clicked;call super::clicked;dw_2.AcceptText()

Long   row

row = dw_2.GetRow()
If row < 1 Then Return

String ls_ymd

ls_ymd = dw_2.GetItemString(row, 'd_st')
If Trim(ls_ymd) = '' OR IsNull(ls_ymd) Then
	MessageBox('일자 확인', '일자는 필수 항목입니다.')
	Return
End If

String ls_gbn

ls_gbn = dw_2.GetItemString(row, 'd_ed')
If Trim(ls_gbn) = '' OR IsNull(ls_gbn) Then ls_gbn = '%'

dw_insert.SetRedraw(False)
dw_insert.Retrieve(ls_ymd, ls_gbn)
dw_insert.SetRedraw(True)
end event

type p_del from w_inherite`p_del within w_sm10_0055_pt
boolean visible = false
integer x = 4009
integer y = 44
end type

event p_del::clicked;call super::clicked;dw_2.AcceptText()

String ls_ymd

ls_ymd = dw_2.GetItemString(1, 'd_st')
If Trim(ls_ymd) = '' OR IsNull(ls_ymd) Then
	MessageBox('기준일 확인', '기준일을 확인 하십시오.')
	Return
End If

If MessageBox('삭제여부 확인', LEFT(ls_ymd, 4) + '.' + MID(ls_ymd, 5, 2) + '.' + RIGHT(ls_ymd, 2) + &
										 '일자 자료를 삭제 하시겠습니까?', Question!, YesNo!, 2) <> 1 Then Return


If rb_1.Checked = True Then
	//일간자료 삭제
	DELETE FROM VAN_PTDAY
	 WHERE CDATE = :ls_ymd ;
	If SQLCA.SQLCODE <> 0 Then
		MessageBox(String(SQLCA.SQLCODE), SQLCA.SQLERRTEXT)
		ROLLBACK USING SQLCA;
		MessageBox('삭제오류 발생', '자료 삭제 중 오류가 발생했습니다.')
		Return
	End If
ElseIf rb_2.Checked = True Then
	//주간자료 삭제
	DELETE FROM VAN_PTWEEK
	 WHERE CDATE = :ls_ymd ;
	If SQLCA.SQLCODE <> 0 Then
		MessageBox(String(SQLCA.SQLCODE), SQLCA.SQLERRTEXT)
		ROLLBACK USING SQLCA;
		MessageBox('삭제오류 발생', '자료 삭제 중 오류가 발생했습니다.')
		Return
	End If
End If

If SQLCA.SQLCODE = 0 Then
	COMMIT USING SQLCA;
	MessageBox('삭제 완료', '자료가 삭제 되었습니다.')
	dw_insert.ReSet()
End If
end event

type p_mod from w_inherite`p_mod within w_sm10_0055_pt
boolean visible = false
integer x = 3835
integer y = 208
boolean enabled = false
end type

type cb_exit from w_inherite`cb_exit within w_sm10_0055_pt
end type

type cb_mod from w_inherite`cb_mod within w_sm10_0055_pt
end type

type cb_ins from w_inherite`cb_ins within w_sm10_0055_pt
end type

type cb_del from w_inherite`cb_del within w_sm10_0055_pt
end type

type cb_inq from w_inherite`cb_inq within w_sm10_0055_pt
end type

type cb_print from w_inherite`cb_print within w_sm10_0055_pt
end type

type st_1 from w_inherite`st_1 within w_sm10_0055_pt
end type

type cb_can from w_inherite`cb_can within w_sm10_0055_pt
end type

type cb_search from w_inherite`cb_search within w_sm10_0055_pt
end type







type gb_button1 from w_inherite`gb_button1 within w_sm10_0055_pt
end type

type gb_button2 from w_inherite`gb_button2 within w_sm10_0055_pt
end type

type dw_2 from datawindow within w_sm10_0055_pt
integer x = 37
integer y = 32
integer width = 2080
integer height = 184
integer taborder = 60
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm10_0055_pt_001-1"
boolean border = false
boolean livescroll = true
end type

event constructor;This.SetTransObject(SQLCA)
This.InsertRow(0)
end event

event itemchanged;If row < 1 Then Return

Choose Case dwo.name
	Case 'gbn'
		If data = 'I' Then
			cb_1.Enabled = True
			This.DataObject = 'd_sm10_0055_pt_001-1'
			
			p_inq.Visible = False
			p_del.Visible = False
		Else
			cb_1.Enabled = False
			This.DataObject = 'd_sm10_0055_pt_001-2'
			
			p_inq.Visible = True
			p_del.Visible = True
		End If
		
		This.SetTransObject(SQLCA)
		This.InsertRow(0)
End Choose
end event

type cb_1 from commandbutton within w_sm10_0055_pt
integer x = 3063
integer y = 52
integer width = 402
integer height = 132
integer taborder = 70
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "자료등록"
end type

event clicked;If rb_1.Checked = True Then
	wf_day()
Else
	wf_week()
End If
end event

type rb_1 from radiobutton within w_sm10_0055_pt
integer x = 2766
integer y = 52
integer width = 215
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "일간"
boolean checked = true
end type

event clicked;If rb_1.Checked = True Then
	dw_insert.DataObject = 'd_sm10_0055_pt_002'
	dw_insert.SetTransObject(SQLCA)
End If
end event

type rb_2 from radiobutton within w_sm10_0055_pt
integer x = 2766
integer y = 124
integer width = 215
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "주간"
end type

event clicked;If rb_2.Checked = True Then
	dw_insert.DataObject = 'd_sm10_0055_pt_003'
	dw_insert.SetTransObject(SQLCA)
End If
end event

type dw_1 from datawindow within w_sm10_0055_pt
boolean visible = false
integer x = 3547
integer y = 1552
integer width = 983
integer height = 664
integer taborder = 80
boolean bringtotop = true
boolean enabled = false
boolean titlebar = true
string title = "주간"
string dataobject = "d_sm10_0055_pt_003"
boolean border = false
end type

type pb_1 from u_pb_cal within w_sm10_0055_pt
integer x = 603
integer y = 84
integer height = 76
integer taborder = 150
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_2.SetColumn('d_st')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_2.SetItem(1, 'd_st', gs_code)

If Trim(gs_code) = '' OR IsNull(gs_code) Then Return

end event

type rr_2 from roundrectangle within w_sm10_0055_pt
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 37
integer y = 244
integer width = 4539
integer height = 2000
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within w_sm10_0055_pt
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 2711
integer y = 32
integer width = 306
integer height = 176
integer cornerheight = 40
integer cornerwidth = 55
end type

