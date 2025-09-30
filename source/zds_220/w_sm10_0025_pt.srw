$PBExportHeader$w_sm10_0025_pt.srw
$PBExportComments$파워텍 생산코드 품목관리
forward
global type w_sm10_0025_pt from w_inherite
end type
type dw_2 from datawindow within w_sm10_0025_pt
end type
type cb_1 from commandbutton within w_sm10_0025_pt
end type
type cb_2 from commandbutton within w_sm10_0025_pt
end type
type cb_3 from commandbutton within w_sm10_0025_pt
end type
type rr_2 from roundrectangle within w_sm10_0025_pt
end type
end forward

global type w_sm10_0025_pt from w_inherite
integer width = 4667
integer height = 2596
string title = "파워텍 생산코드 등록"
dw_2 dw_2
cb_1 cb_1
cb_2 cb_2
cb_3 cb_3
rr_2 rr_2
end type
global w_sm10_0025_pt w_sm10_0025_pt

on w_sm10_0025_pt.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.cb_1=create cb_1
this.cb_2=create cb_2
this.cb_3=create cb_3
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.cb_2
this.Control[iCurrent+4]=this.cb_3
this.Control[iCurrent+5]=this.rr_2
end on

on w_sm10_0025_pt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_2)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.rr_2)
end on

type dw_insert from w_inherite`dw_insert within w_sm10_0025_pt
integer x = 50
integer y = 304
integer width = 4512
integer height = 1948
string dataobject = "d_sm10_0025_pt_003"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event dw_insert::constructor;call super::constructor;This.SetTransObject(SQLCA)
end event

event dw_insert::rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, False)
This.SelectRow(currentrow, True)
end event

event dw_insert::clicked;call super::clicked;//This.SelectRow(0, False)
//This.SelectRow(row, True)
end event

event dw_insert::itemchanged;call super::itemchanged;If row < 1 Then Return

Long   ll_chk
String ls_dsc
String ls_spec
String ls_ji
String ls_un

Choose Case dwo.name
	Case 'ptnvan_item_itnbr'
		  SELECT ITDSC  , ISPEC   , JIJIL , UNMSR , COUNT('X')
		    INTO :ls_dsc, :ls_spec, :ls_ji, :ls_un, :ll_chk
		    FROM ITEMAS
		   WHERE ITNBR = :data
		GROUP BY ITDSC, ISPEC, JIJIL, UNMSR ;
		If ll_chk < 1 Then
			MessageBox('미 등록 품번', '등록된 품번이 아닙니다.')
			Return 2
		End If
		
		dw_insert.SetItem(row, 'itemas_itdsc', ls_dsc )
		dw_insert.SetItem(row, 'itemas_ispec', ls_spec)
		dw_insert.SetItem(row, 'itemas_jijil', ls_ji  )
		dw_insert.SetItem(row, 'itemas_unmsr', ls_un  )
End Choose
end event

type p_delrow from w_inherite`p_delrow within w_sm10_0025_pt
integer x = 3671
integer y = 60
end type

event p_delrow::clicked;call super::clicked;Long   ll_cnt

ll_cnt = dw_insert.RowCount()
If ll_cnt < 1 Then Return

Long   i
Long   l
String ls_chk
l = 0
For i = 1 To dw_insert.RowCount()
	ls_chk = dw_insert.GetItemString(i, 'chk')
	If ls_chk = 'Y' Then
		dw_insert.DeleteRow(i)
		i = i - 1
		l++
	End If
Next

If l < 1 Then
	MessageBox('Select a row Check!!', '선택된 행이 없습니다.~r~n~n삭제 자료를 선택 하신 후 처리하십시오.')
	Return
End If

If dw_insert.UPDATE() = 1 Then
	COMMIT USING SQLCA;
	MessageBox('삭제 완료', '자료가 삭제 되었습니다.')
Else
	MessageBox(String(SQLCA.SQLCODE), SQLCA.SQLERRTEXT)
	ROLLBACK USING SQLCA;
	MessageBox('삭제 오류', '자료 삭제 중 오류가 발생했습니다.')
	Return
End If
end event

type p_addrow from w_inherite`p_addrow within w_sm10_0025_pt
integer x = 3497
integer y = 60
end type

event p_addrow::clicked;call super::clicked;Long   ll_ins

If dw_insert.ModifiedCount() < 1 Then
	dw_insert.ReSet()
	ll_ins = dw_insert.InsertRow(0)
Else
	ll_ins = dw_insert.InsertRow(0)
End If

dw_insert.SetItem(ll_ins, 'ptnvan_item_sabu', '1')
end event

type p_search from w_inherite`p_search within w_sm10_0025_pt
boolean visible = false
integer x = 2802
integer y = 60
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_sm10_0025_pt
boolean visible = false
integer x = 3323
integer y = 60
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_sm10_0025_pt
integer x = 4366
integer y = 60
end type

type p_can from w_inherite`p_can within w_sm10_0025_pt
integer x = 4192
integer y = 60
end type

event p_can::clicked;call super::clicked;dw_insert.ReSet()
dw_2.ReSet()

dw_2.InsertRow(0)
end event

type p_print from w_inherite`p_print within w_sm10_0025_pt
boolean visible = false
integer x = 2976
integer y = 60
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_sm10_0025_pt
integer x = 3150
integer y = 60
end type

event p_inq::clicked;call super::clicked;dw_2.AcceptText()

Long   row

row = dw_2.GetRow()
If row < 1 Then Return

String ls_fac

ls_fac = dw_2.GetItemString(row, 'factory')
If Trim(ls_fac) = '' OR IsNull(ls_fac) Then ls_fac = '%'

String ls_gbn

ls_gbn = dw_2.GetItemString(row, 'gubun')
If Trim(ls_gbn) = '' OR IsNull(ls_gbn) Then
	ls_gbn = '%'
Else
	ls_gbn = ls_gbn + '%'
End If

dw_insert.SetRedraw(False)
dw_insert.Retrieve(ls_fac, ls_gbn)
dw_insert.SetRedraw(True)



end event

type p_del from w_inherite`p_del within w_sm10_0025_pt
boolean visible = false
integer x = 4018
integer y = 60
boolean enabled = false
end type

type p_mod from w_inherite`p_mod within w_sm10_0025_pt
integer x = 3845
integer y = 60
end type

event p_mod::clicked;call super::clicked;Long   ll_cnt

ll_cnt = dw_insert.RowCount()
If ll_cnt < 1 Then Return

Long   i
Long   ll_find
Long   ll_chk
String ls_get[]

For i = 1 To ll_cnt
	ls_get[1] = dw_insert.GetItemString(i, 'ptnvan_item_factory')
	ls_get[2] = dw_insert.GetItemString(i, 'ptnvan_item_gubun'  )
	ls_get[3] = dw_insert.GetItemString(i, 'ptnvan_item_itnbr'  )
	
	ll_find = dw_insert.Find("ptnvan_item_factory = '" + ls_get[1] + "' and ptnvan_item_gubun = '" &
									 + ls_get[2] + "' and ptnvan_item_itnbr = '" + ls_get[3] + "'", i, ll_cnt)
	If ll_find > 0 Then
		MessageBox('중복자료 확인', String(i) + '행에 중복된 자료가 있습니다.~r~n자료를 확인하십시오.')
		Return
	End If
	
	SELECT COUNT('X')
	  INTO :ll_chk
	  FROM PTNVAN_ITEM
	 WHERE FACTORY = :ls_get[1]
	   AND GUBUN   = :ls_get[2]
		AND ITNBR   = :ls_get[3] ;
	If ll_chk > 0 Then
		MessageBox('중복자료 확인', String(i) + '행에 중복된 자료가 있습니다.~r~nDB자료를 확인하십시오.')
		Return
	End If
	
Next

If dw_insert.UPDATE() = 1 Then
	COMMIT USING SQLCA;
	MessageBox('저장 확인', '저장 되었습니다.')
Else
	MessageBox(String(SQLCA.SQLCODE), SQLCA.SQLERRTEXT)
	ROLLBACK USING SQLCA;
	MessageBox('저장 오류', '자료 저장 중 오류가 발생했습니다.')
	Return
End If
end event

type cb_exit from w_inherite`cb_exit within w_sm10_0025_pt
end type

type cb_mod from w_inherite`cb_mod within w_sm10_0025_pt
end type

type cb_ins from w_inherite`cb_ins within w_sm10_0025_pt
end type

type cb_del from w_inherite`cb_del within w_sm10_0025_pt
end type

type cb_inq from w_inherite`cb_inq within w_sm10_0025_pt
end type

type cb_print from w_inherite`cb_print within w_sm10_0025_pt
end type

type st_1 from w_inherite`st_1 within w_sm10_0025_pt
end type

type cb_can from w_inherite`cb_can within w_sm10_0025_pt
end type

type cb_search from w_inherite`cb_search within w_sm10_0025_pt
end type







type gb_button1 from w_inherite`gb_button1 within w_sm10_0025_pt
end type

type gb_button2 from w_inherite`gb_button2 within w_sm10_0025_pt
end type

type dw_2 from datawindow within w_sm10_0025_pt
integer x = 37
integer y = 32
integer width = 1682
integer height = 168
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm10_0025_pt_001"
boolean border = false
boolean livescroll = true
end type

event constructor;This.SetTransObject(SQLCA)
This.InsertRow(0)
end event

type cb_1 from commandbutton within w_sm10_0025_pt
integer x = 2377
integer y = 60
integer width = 402
integer height = 144
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "Excel-UP"
end type

event clicked;String ls_docname
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
Long   ll_chk
Long   ll_usage
Long   ll_find
String ls_file
String ls_gubun
String ls_fac
String ls_itnbr
String ls_usage

For ix = 1 To UpperBound(ls_named)
	
	If UpperBound(ls_named) = 1 Then
		ls_file = ls_docname
	Else
		ls_file = ls_docname +'\'+ ls_named[ix]
	End If
	
	If FileExists(ls_file) = False Then
		MessageBox('확인',ls_file+' 파일이 존재하지 않습니다.')
		Return
	End If 
	
	uo_xl = Create uo_xlobject
			
	//엑셀과 연결
	uo_xl.uf_excel_connect(ls_file, False, 3)
	
	uo_xl.uf_selectsheet(1)
	
	//Data 시작 Row Setting////
	ll_xl_row = 2
	///////////////////////////
	
	Do While(True)
		
		//Data가 없을경우엔 Return...........
		If IsNull(uo_xl.uf_gettext(ll_xl_row, 2)) OR Trim(uo_xl.uf_gettext(ll_xl_row, 2)) = '' Then Exit
		
		ll_r = dw_insert.InsertRow(0) 
		ll_cnt++
		
		dw_insert.ScrollToRow(ll_r)
		
		//Excel 셀-Format 지정
		For i = 1 To 10
			uo_xl.uf_set_format(ll_xl_row, i, '@' + Space(30))
		Next
		
		//////////////////////////////////////////////////////////////////////
		ls_fac   = Trim(uo_xl.uf_gettext(ll_xl_row, 2)) //공장
		ls_gubun = Trim(uo_xl.uf_gettext(ll_xl_row, 3)) //생산코드
		ls_itnbr = Trim(uo_xl.uf_gettext(ll_xl_row, 4)) //품번
		ls_usage = Trim(uo_xl.uf_gettext(ll_xl_row, 5)) //Usage
		
		ll_usage = Long(ls_usage)
		//////////////////////////////////////////////////////////////////////
		w_mdi_frame.sle_msg.text = ls_itnbr + ' / ' + String(ll_cnt) + '행'
		
		SELECT COUNT('X')
		  INTO :ll_chk
		  FROM ITEMAS
		 WHERE ITNBR = :ls_itnbr ;
		If ll_chk < 1 Then
			MessageBox('미 등록 품번 확인', ls_itnbr + '은(는) 등록된 품번이 아닙니다.~r~n~n~r확인 후 다시 등록 하십시오.')
			uo_xl.uf_excel_Disconnect()
			uo_xltemp.uf_excel_Disconnect()
			Return
		End If
		
		If IsNull(ls_itnbr) OR Trim(ls_itnbr) = '' Then
			uo_xl.uf_excel_Disconnect()
			uo_xltemp.uf_excel_Disconnect()
			Exit
		End If
		
		//Duplication Check!!//////////////////////////////////////////////////////////////////////////////////////////////
		ll_find = dw_insert.Find("ptnvan_item_factory = '" + ls_fac + "' and ptnvan_item_gubun = '" + &
										 ls_gubun + "' and ptnvan_item_itnbr = '" + ls_itnbr + "'", 1, ll_r - 1)
		
		If ll_find > 0 Then
			MessageBox('중복발생', 'Excel File 자료 중 ' + String(ll_find) + '행과 ' + String(ll_r) + '행이 중복입니다.')
			uo_xl.uf_excel_Disconnect()
			uo_xltemp.uf_excel_Disconnect()
			Return
		End If
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		dw_insert.SetItem(ll_r, 'ptnvan_item_sabu'   , gs_sabu )
		dw_insert.SetItem(ll_r, 'ptnvan_item_factory', ls_fac  )
		dw_insert.SetItem(ll_r, 'ptnvan_item_gubun'  , ls_gubun)
		dw_insert.SetItem(ll_r, 'ptnvan_item_itnbr'  , ls_itnbr)
		dw_insert.SetItem(ll_r, 'ptnvan_item_useqty' , ll_usage)
		
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
end event

type cb_2 from commandbutton within w_sm10_0025_pt
integer x = 169
integer y = 200
integer width = 105
integer height = 84
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "▼"
end type

event clicked;Long   i
For i = 1 To dw_insert.RowCount()
	dw_insert.SetItem(i, 'chk', 'Y')
Next
end event

type cb_3 from commandbutton within w_sm10_0025_pt
integer x = 288
integer y = 200
integer width = 110
integer height = 84
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "▽"
end type

event clicked;Long   i
For i = 1 To dw_insert.RowCount()
	dw_insert.SetItem(i, 'chk', 'N')
Next
end event

type rr_2 from roundrectangle within w_sm10_0025_pt
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 37
integer y = 292
integer width = 4539
integer height = 1972
integer cornerheight = 40
integer cornerwidth = 55
end type

