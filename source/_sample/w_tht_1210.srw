$PBExportHeader$w_tht_1210.srw
$PBExportComments$파텍스 VAN 등록
forward
global type w_tht_1210 from w_inherite
end type
type rr_1 from roundrectangle within w_tht_1210
end type
type dw_1 from datawindow within w_tht_1210
end type
type cb_5 from commandbutton within w_tht_1210
end type
type cb_6 from commandbutton within w_tht_1210
end type
type dw_list from datawindow within w_tht_1210
end type
type st_state from statictext within w_tht_1210
end type
type cbx_1 from checkbox within w_tht_1210
end type
end forward

global type w_tht_1210 from w_inherite
integer width = 4686
integer height = 2908
string title = "위아/모비스/파워텍 VAN 등록"
rr_1 rr_1
dw_1 dw_1
cb_5 cb_5
cb_6 cb_6
dw_list dw_list
st_state st_state
cbx_1 cbx_1
end type
global w_tht_1210 w_tht_1210

type variables
String is_custid
Long il_err , il_succeed

end variables

forward prototypes
public function long wf_error (string as_gubun, long al_line, string as_doccode, string as_factory, string as_itnbr, string as_errtext)
end prototypes

public function long wf_error (string as_gubun, long al_line, string as_doccode, string as_factory, string as_itnbr, string as_errtext);If dw_list.Visible = False Then
	dw_list.Visible = True
End If

Long ll_r

ll_r = dw_list.InsertRow(0)

dw_list.Object.saupj[ll_r] = gs_saupj
dw_list.Object.err_date[ll_r] = Trim(dw_1.Object.d_crt[1])
dw_list.Object.err_time[ll_r] = f_totime()
dw_list.Object.doctxt[ll_r] = as_gubun
dw_list.Object.err_line[ll_r] = al_line
dw_list.Object.doccode[ll_r] = as_doccode
dw_list.Object.factory[ll_r] = as_factory
dw_list.Object.itnbr[ll_r] = as_itnbr
dw_list.Object.err_txt[ll_r] = as_errtext

dw_list.scrolltorow(ll_r)

Return ll_r
end function

on w_tht_1210.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.dw_1=create dw_1
this.cb_5=create cb_5
this.cb_6=create cb_6
this.dw_list=create dw_list
this.st_state=create st_state
this.cbx_1=create cbx_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.cb_5
this.Control[iCurrent+4]=this.cb_6
this.Control[iCurrent+5]=this.dw_list
this.Control[iCurrent+6]=this.st_state
this.Control[iCurrent+7]=this.cbx_1
end on

on w_tht_1210.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.dw_1)
destroy(this.cb_5)
destroy(this.cb_6)
destroy(this.dw_list)
destroy(this.st_state)
destroy(this.cbx_1)
end on

event open;call super::open;This.PostEvent('ue_open')
end event

event ue_open;call super::ue_open;dw_1.SetTransObject(SQLCA)
dw_insert.SetTransObject(SQLCA)

dw_1.InsertRow(0)

dw_1.SetItem(1, 'd_st', String(RelativeDate(TODAY(), -30), 'yyyymmdd'))
dw_1.SetItem(1, 'd_ed', String(TODAY(), 'yyyymmdd'))
end event

type dw_insert from w_inherite`dw_insert within w_tht_1210
integer x = 41
integer y = 236
integer width = 4558
integer height = 2012
string dataobject = "d_tht_1210_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event dw_insert::clicked;call super::clicked;This.SelectRow(0, False)
if row > 0 then
	This.SelectRow(row, True)
end if

end event

type p_delrow from w_inherite`p_delrow within w_tht_1210
boolean visible = false
integer y = 180
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_tht_1210
boolean visible = false
integer y = 180
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_tht_1210
boolean visible = false
integer y = 180
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_tht_1210
boolean visible = false
integer y = 180
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_tht_1210
end type

type p_can from w_inherite`p_can within w_tht_1210
end type

event p_can::clicked;call super::clicked;dw_insert.ReSet()
cbx_1.checked = false
end event

type p_print from w_inherite`p_print within w_tht_1210
boolean visible = false
integer y = 180
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_tht_1210
integer x = 3922
end type

event p_inq::clicked;call super::clicked;dw_1.AcceptText()

Integer row
row = dw_1.GetRow()
If row < 1 Then Return

String  ls_st
ls_st = dw_1.GetItemString(row, 'd_st')

String  ls_ed
ls_ed = dw_1.GetItemString(row, 'd_ed')

String  ls_fac
ls_fac = dw_1.GetItemString(row, 'factory')

String  ls_sitn
ls_sitn = dw_1.GetItemString(row, 'stit')

String  ls_eitn
ls_eitn = dw_1.GetItemString(row, 'edit')

If Trim(ls_st) = '' OR IsNull(ls_st) Then ls_st = '19000101'
If Trim(ls_ed) = '' OR IsNull(ls_ed) Then ls_ed = '21001231'
If Trim(ls_sitn) = '' OR IsNull(ls_sitn) Then ls_sitn = '.'
If Trim(ls_eitn) = '' OR IsNull(ls_eitn) Then ls_eitn = 'ZZZZZZZZZZZZZZ'

If Trim(ls_fac) = '' OR IsNull(ls_fac) Then ls_fac = '%'

If dw_1.GetItemString(row, 'ckdgbn') = 'M' Then
	ls_fac = 'M1'
ElseIf dw_1.GetItemString(row, 'ckdgbn') = 'W' Then
	ls_fac = 'WP'
End If

dw_insert.SetRedraw(False)
dw_insert.Retrieve(ls_st, ls_ed, ls_fac, ls_sitn, ls_eitn)
dw_insert.SetRedraw(True)

cbx_1.checked = false
end event

type p_del from w_inherite`p_del within w_tht_1210
end type

event p_del::clicked;call super::clicked;dw_insert.AcceptText()

If dw_insert.Find("chk='Y'", 1, dw_insert.RowCount()) < 1 Then
	MessageBox('확인', '삭제할 자료를 먼저 선택하십시오!')
	Return
End If

If f_msg_delete() <> 1 Then Return

String ls_chk
Long   i

For i = 1 To dw_insert.RowCount()
	ls_chk = dw_insert.GetItemString(i, 'chk')
	If ls_chk = 'Y' Then
		dw_insert.DeleteRow(i)	
		i = i - 1
	End If
Next

If dw_insert.UPDATE() = 1 Then
	COMMIT USING SQLCA;
	MessageBox('삭제', '삭제 되었습니다.')
Else
	ROLLBACK USING SQLCA;
	MessageBox('실패', '삭제 중 오류가 발생 했습니다.')
	Return
End If
end event

type p_mod from w_inherite`p_mod within w_tht_1210
boolean visible = false
integer x = 4032
integer y = 184
boolean enabled = false
end type

type cb_exit from w_inherite`cb_exit within w_tht_1210
end type

type cb_mod from w_inherite`cb_mod within w_tht_1210
end type

type cb_ins from w_inherite`cb_ins within w_tht_1210
end type

type cb_del from w_inherite`cb_del within w_tht_1210
end type

type cb_inq from w_inherite`cb_inq within w_tht_1210
end type

type cb_print from w_inherite`cb_print within w_tht_1210
end type

type st_1 from w_inherite`st_1 within w_tht_1210
end type

type cb_can from w_inherite`cb_can within w_tht_1210
end type

type cb_search from w_inherite`cb_search within w_tht_1210
end type







type gb_button1 from w_inherite`gb_button1 within w_tht_1210
end type

type gb_button2 from w_inherite`gb_button2 within w_tht_1210
end type

type rr_1 from roundrectangle within w_tht_1210
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 32
integer y = 224
integer width = 4576
integer height = 2032
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_1 from datawindow within w_tht_1210
integer x = 32
integer y = 28
integer width = 2633
integer height = 176
integer taborder = 50
string title = "none"
string dataobject = "d_tht_1210_1"
boolean border = false
boolean livescroll = true
end type

event itemchanged;If row < 1 Then Return

Choose Case dwo.name
	Case 'stit'
		If Trim(This.GetItemString(row, 'edit')) = '' OR IsNull(This.GetItemString(row, 'edit')) Then
			This.SetItem(row, 'edit', data)
		End If
		
	Case 'd_st'
		If Trim(This.GetItemString(row, 'd_ed')) = '' OR IsNull(This.GetItemString(row, 'd_ed')) Then
			This.SetItem(row, 'd_ed', data)
		End If
		
	Case 'ckdgbn'
		Choose Case data
			Case 'H' //현대기아
				dw_insert.DataObject = 'd_sm10_0030_ckd_hkmc'
			Case 'M' //모비스
				dw_insert.DataObject = 'd_sm10_0030_ckd_mobis'
			Case 'G' //글로비스
				dw_insert.DataObject = 'd_sm10_0030_ckd_globis'
			Case 'W' //위아
				dw_insert.DataObject = 'd_sm10_0030_ckd_wia'
			Case 'P' //파워텍
				dw_insert.DataObject = 'd_sm10_0030_ckd_ptc'
		End Choose
		
		dw_insert.SetTransObject(SQLCA)

End Choose
end event

type cb_5 from commandbutton within w_tht_1210
integer x = 3438
integer y = 32
integer width = 425
integer height = 132
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "File Upload"
end type

event clicked;dw_1.AcceptText()

Integer row
row = dw_1.GetRow()
If row < 1 Then Return

String  ls_gbn
ls_gbn = dw_1.GetItemString(row, 'ckdgbn')

dw_insert.ReSet()

Choose Case ls_gbn
//	Case 'H' //현대기아
//		cb_1.TriggerEvent('Clicked')
//	Case 'M' //모비스
//		cb_2.TriggerEvent('Clicked')
//	Case 'W' //위아
//		cb_3.TriggerEvent('Clicked')
//	Case 'G' //글로비스
//		cb_4.TriggerEvent('Clicked')
	Case 'P' //파텍스
		cb_6.TriggerEvent('Clicked')
End Choose

end event

type cb_6 from commandbutton within w_tht_1210
boolean visible = false
integer x = 4155
integer y = 856
integer width = 402
integer height = 116
integer taborder = 100
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "PARTECS"
end type

event clicked;Integer li_value
String  ls_path
String  ls_file
li_value = GetFileOpenName("EXCEL 가져오기", ls_path, ls_file, "XLS", "XLS Files (*.XLS),*.XLS,")
Choose Case li_value
	Case 0
		Return
	Case -1
		MessageBox('확인', '파일 선택에 실패 했습니다.')
		Return
	Case 1
		If FileExists(ls_path) = False Then
			MessageBox('확인', ls_path + ' 파일이 존재하지 않습니다.')
			Return
		End If
End Choose

//If FileExists('c:\erpman\bin\date_conv.xls') = False Then
//	MessageBox('확인','c:\erpman\bin\date_conv.xls'+' 파일이 존재하지 않습니다.')
//	Return
//End If

dw_list.ReSet()

uo_xlobject uo_xl
uo_xl = Create uo_xlobject
uo_xl.uf_excel_connect(ls_path, False, 3)
uo_xl.uf_selectsheet(1)
uo_xl.uf_set_format(1, 1, '@' + space(30))

///* Data Format 변환용 */
//uo_xlobject uo_xltemp
//uo_xltemp = Create uo_xlobject
//uo_xltemp.uf_excel_connect('c:\erpman\bin\date_conv.xls', False, 3)
//uo_xltemp.uf_selectsheet(1)
//uo_xltemp.uf_set_format(1, 1, '@' + space(30))

//Data 시작 Row Setting
Integer li_xlrow
li_xlrow = 2

Integer li_ins
Integer li_cnt  ; li_cnt  = 0
Integer li_jpno ; li_jpno = 0
Integer i
Integer li_dup
String  ls_order_no
String  ls_itnbr
String  ls_itdsc
String  ls_custcd
String  ls_custnm
String  ls_vndcd
String  ls_carcd
String  ls_napgi
String  ls_orddat
String  ls_ordtim
String  ls_pum
String  ls_ordqty
String  ls_bigo

st_state.Text    = '데이타를 읽는 중입니다...'
st_state.Visible = True

Do While(True)
	//Data가 없을경우엔 Return...........
	If IsNull(uo_xl.uf_gettext(li_xlrow, 1)) Or Trim(uo_xl.uf_gettext(li_xlrow, 1)) = '' Then Exit //고객사
	
//	li_ins = dw_insert.InsertRow(0)
	li_cnt++
	li_jpno++
	
	For i = 1 To 11
		uo_xl.uf_set_format(li_xlrow, i, '@' + space(30))
	Next
	
	ls_vndcd    = Trim(uo_xl.uf_GetText(li_xlrow, 1))  //고객사
	ls_itnbr    = Trim(uo_xl.uf_GetText(li_xlrow, 2))  //품번
	//ls_itdsc    = Trim(uo_xl.uf_GetText(li_xlrow, 3))  //품명
	ls_order_no = Trim(uo_xl.uf_GetText(li_xlrow, 3))  //오더번호
	ls_napgi    = Trim(uo_xl.uf_GetText(li_xlrow, 4))  //오더번호
	ls_ordqty   = Trim(uo_xl.uf_GetText(li_xlrow, 6))  //발주수량
	ls_orddat   = Trim(uo_xl.uf_GetText(li_xlrow, 5)) //발주일자
	ls_bigo     = Trim(uo_xl.uf_GetText(li_xlrow, 7)) //비고
	
//	ls_vndcd    = Trim(uo_xl.uf_GetText(li_xlrow, 1))  //고객사 
//	ls_itnbr    = Trim(uo_xl.uf_GetText(li_xlrow, 2))  //품번  check
//	//ls_itdsc    = Trim(uo_xl.uf_GetText(li_xlrow, 3))  //품명  check
//	ls_order_no = Trim(uo_xl.uf_GetText(li_xlrow, 3))  //오더번호 check
//	ls_napgi    = Trim(uo_xl.uf_GetText(li_xlrow, 4))  //납기일자 check
//	ls_orddat   = Trim(uo_xl.uf_GetText(li_xlrow, 5)) //발주일자   check
//	ls_ordqty   = Trim(uo_xl.uf_GetText(li_xlrow, 6))  //발주수량 check
//     ls_bigo     = Trim(uo_xl.uf_GetText(li_xlrow, 7)) //비고
	
	
	
//	ls_vndcd    = Trim(uo_xl.uf_GetText(li_xlrow, 1))  //고객사
//	ls_itnbr    = Trim(uo_xl.uf_GetText(li_xlrow, 2))  //품번
//	ls_itdsc    = Trim(uo_xl.uf_GetText(li_xlrow, 3))  //품명
//	ls_order_no = Trim(uo_xl.uf_GetText(li_xlrow, 5))  //오더번호
//	ls_napgi    = Trim(uo_xl.uf_GetText(li_xlrow, 6))  //오더번호
//	ls_ordqty   = Trim(uo_xl.uf_GetText(li_xlrow, 9))  //발주수량
//	ls_orddat   = Trim(uo_xl.uf_GetText(li_xlrow, 17)) //발주일자
//	ls_bigo     = Trim(uo_xl.uf_GetText(li_xlrow, 18)) //비고
	st_state.Text = String(li_xlrow) + '행 [' + ls_order_no + ' / ' + ls_itnbr + ']'
	
//		/* 엑셀의 날짜 포멧을 문자열로 변경 */
//		uo_xltemp.uf_setvalue(1, 1, ls_orddat)
//			
//		ls_orddat = String(Long(uo_xltemp.uf_gettext(1, 2)), '0000') + String(Long(uo_xltemp.uf_gettext(1, 3)), '00') + String(Long(uo_xltemp.uf_gettext(1, 4)), '00')
//		If IsDate(LEFT(ls_orddat, 4) + '/' + MID(ls_orddat, 5, 2) + '/' + RIGHT(ls_orddat, 2)) = False Then
//			wf_error('PTC', li_xlrow, ls_order_no, ls_vndcd, ls_itnbr, " 날자형식에 맞지 않습니다.(계속진행..) " + ls_orddat + ' [열위치:' + String(li_xlrow) + ']')
//		End If
		
//		SELECT REPLACE(:ls_orddat, '-', ''), 	REPLACE(:ls_napgi, '-', '')
//		  INTO :ls_orddat,							:ls_napgi
//		  FROM DUAL ;
		
		SELECT ITDSC
		    INTO :ls_itdsc
		   FROM ITEMAS 
		WHERE  ITNBR = :ls_itnbr;

		/* 중복확인 */
		SELECT COUNT('X')
		  INTO :li_dup
		  FROM VAN_PARTECS_TH
		 WHERE CUSTOMER = :ls_vndcd AND ITNBR = :ls_itnbr AND BALNO = :ls_order_no;
		If li_dup < 1 Then	
			INSERT INTO VAN_PARTECS_TH (
			CUSTOMER, ITNBR, ITDSC, BALNO, YODATE, BALQTY, BALDATE, BALMEMO )
			VALUES (
			:ls_vndcd, :ls_itnbr, :ls_itdsc, :ls_order_no, :ls_napgi, :ls_ordqty, :ls_orddat, :ls_bigo ) ;
			
			If SQLCA.SQLCODE <> 0 Then
				ROLLBACK USING SQLCA;
		//		uo_xl.Application.Quit
//				uo_xltemp.uf_excel_Disconnect()
				uo_xl.uf_excel_Disconnect()
				Destroy uo_xl
//				Destroy uo_xltemp
				MessageBox('확인', '자료 입력 중 오류가 발생 했습니다.')
				Return
			End If
			
		Else
//			wf_error('PTC', li_xlrow, ls_order_no, ls_vndcd, ls_itnbr, " 이미 입력된 데이타입니다.(계속진행..)" + ' [열위치:' + String(li_xlrow) + ']')
		End If
	
	li_xlrow++
Loop

st_state.Visible = False

COMMIT USING SQLCA;
MessageBox('확인', '저장 되었습니다.')

//uo_xl.Application.Quit
//uo_xltemp.uf_excel_Disconnect()
uo_xl.uf_excel_Disconnect()
Destroy uo_xl
//Destroy uo_xltemp

p_inq.TriggerEvent('Clicked')
end event

type dw_list from datawindow within w_tht_1210
boolean visible = false
integer x = 187
integer y = 676
integer width = 2144
integer height = 1564
integer taborder = 100
boolean bringtotop = true
boolean titlebar = true
string title = "VAN 오류내역"
string dataobject = "d_sm10_0030_a"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_state from statictext within w_tht_1210
boolean visible = false
integer x = 1637
integer y = 472
integer width = 1440
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 32106727
string text = "데이타를 읽는 중입니다..."
alignment alignment = center!
boolean focusrectangle = false
end type

type cbx_1 from checkbox within w_tht_1210
integer x = 187
integer y = 272
integer width = 82
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 28144969
end type

event clicked;long 		lrow, lcnt
string	schk

if checked then
	schk = 'Y'
else
	schk = 'N'
end if

lcnt = dw_insert.rowcount()
if lcnt < 1 then return

dw_insert.setredraw(false)
for lrow = 1 to lcnt
	dw_insert.setitem(lrow, 'chk', schk)
next
dw_insert.setredraw(true)

end event

