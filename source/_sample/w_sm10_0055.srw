$PBExportHeader$w_sm10_0055.srw
$PBExportComments$VAN 접수 - (파워텍)
forward
global type w_sm10_0055 from w_inherite
end type
type dw_1 from datawindow within w_sm10_0055
end type
type pb_1 from u_pb_cal within w_sm10_0055
end type
type rb_in from radiobutton within w_sm10_0055
end type
type rb_mod from radiobutton within w_sm10_0055
end type
type pb_2 from u_pb_cal within w_sm10_0055
end type
type p_1 from uo_picture within w_sm10_0055
end type
type rr_1 from roundrectangle within w_sm10_0055
end type
type rr_2 from roundrectangle within w_sm10_0055
end type
end forward

global type w_sm10_0055 from w_inherite
boolean visible = false
integer width = 4667
integer height = 2596
string title = "PARTNER VAN등록"
dw_1 dw_1
pb_1 pb_1
rb_in rb_in
rb_mod rb_mod
pb_2 pb_2
p_1 p_1
rr_1 rr_1
rr_2 rr_2
end type
global w_sm10_0055 w_sm10_0055

forward prototypes
public subroutine wf_ini ()
public function integer wf_dupl ()
end prototypes

public subroutine wf_ini ();If rb_in.Checked = True Then
	dw_1.DataObject = 'd_sm10_0055_1'
	dw_insert.DataObject = 'd_sm10_0055_3'
	pb_2.Visible = False
	p_inq.Enabled = False
	p_delrow.Enabled = False
	p_inq.Picturename = 'C:\erpman\image\조회_d.gif'
	p_delrow.Picturename = 'C:\erpman\image\행삭제_d.gif'
	
	dw_1.SetTransObject(SQLCA)
	dw_1.InsertRow(0)
	
	dw_insert.SetTransObject(SQLCA)
	
	dw_1.SetItem(1, 'd_st', String(TODAY(), 'yyyymmdd'))
	dw_1.SetItem(1, 'factory', '%')
ElseIf rb_mod.Checked = True Then
	dw_1.DataObject = 'd_sm10_0055_2'
	dw_insert.DataObject = 'd_sm10_0055_4'
	pb_2.Visible = True
	p_inq.Enabled = True
	p_delrow.Enabled = True
	p_inq.Picturename = 'C:\erpman\image\조회_up.gif'
	p_delrow.Picturename = 'C:\erpman\image\행삭제_up.gif'
	
	dw_1.SetTransObject(SQLCA)
	dw_1.InsertRow(0)
	
	dw_insert.SetTransObject(SQLCA)
	
	dw_1.SetItem(1, 'd_st', String(TODAY(), 'yyyymm') + '01')
	dw_1.SetItem(1, 'd_ed', String(TODAY(), 'yyyymmdd'))
	dw_1.SetItem(1, 'factory', '%')
End If

f_mod_saupj(dw_1, 'saupj')
end subroutine

public function integer wf_dupl ();Long   ll_rowcnt

ll_rowcnt = dw_insert.RowCount()
If ll_rowcnt < 1 Then Return 0

Long   i
Long   ll_find
Long   ll_chk
String ls_get[]

ll_chk = 0

For i = 1 To ll_rowcnt
	ls_get[1]  = dw_insert.GetItemString(i, 'sabu')
	ls_get[2]  = dw_insert.GetItemString(i, 'doccode')
	ls_get[3]  = dw_insert.GetItemString(i, 'custcd')
	ls_get[4]  = dw_insert.GetItemString(i, 'factory')
	ls_get[5]  = dw_insert.GetItemString(i, 'itnbr')
	ls_get[6]  = dw_insert.GetItemString(i, 'ipno')
	ls_get[7]  = dw_insert.GetItemString(i, 'ipsource')
	ls_get[8]  = dw_insert.GetItemString(i, 'orderno')
	
	ls_get[99] = "sabu = '" + ls_get[1] + "' and doccode = '" + ls_get[2] + "' and custcd = '" + ls_get[3] + &
	             "' and factory = '" + ls_get[4] + "' and itnbr = '" + ls_get[5] + "' and ipno = '" + ls_get[6] + &
					 "' and ipsource = '" + ls_get[7] + "' and orderno = '" + ls_get[8] + "'"
	
	If i = 1 Then Continue
	ll_find = dw_insert.FIND(ls_get[99], 1, i - 1)
	If ll_find > 0 Then
		MessageBox('중복 발생', String(ll_find) + '행과 ' + String(i) + '행이 중복입니다.')
		ll_chk++
	End If
Next

If ll_chk > 0 Then
	Return -1
Else
	Return 1
End If
end function

on w_sm10_0055.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.pb_1=create pb_1
this.rb_in=create rb_in
this.rb_mod=create rb_mod
this.pb_2=create pb_2
this.p_1=create p_1
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.rb_in
this.Control[iCurrent+4]=this.rb_mod
this.Control[iCurrent+5]=this.pb_2
this.Control[iCurrent+6]=this.p_1
this.Control[iCurrent+7]=this.rr_1
this.Control[iCurrent+8]=this.rr_2
end on

on w_sm10_0055.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.pb_1)
destroy(this.rb_in)
destroy(this.rb_mod)
destroy(this.pb_2)
destroy(this.p_1)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event ue_open;call super::ue_open;//wf_ini()
end event

type dw_insert from w_inherite`dw_insert within w_sm10_0055
integer x = 50
integer y = 332
integer width = 4539
integer height = 1932
string dataobject = "d_sm10_0055_3"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event dw_insert::constructor;call super::constructor;This.SetTransObject(SQLCA)
end event

type p_delrow from w_inherite`p_delrow within w_sm10_0055
integer x = 3922
end type

event p_delrow::clicked;call super::clicked;dw_insert.AcceptText()

If dw_insert.RowCount() < 1 Then Return

If f_msg_delete() <> 1 Then Return

Long   i
String ls_chk

For i = 1 To dw_insert.RowCount()
	ls_chk = dw_insert.GetItemString(i, 'chk')
	If ls_chk = 'Y' Then
		dw_insert.DeleteRow(i)
		
		i = i - 1
	End If
	
Next

If dw_insert.UPDATE() = 1 Then
	COMMIT USING SQLCA;
Else
	ROLLBACK USING SQLCA;
	MessageBox('삭제실패', '자료 삭제 중 오류가 발생 했습니다.')
	Return
End If

end event

type p_addrow from w_inherite`p_addrow within w_sm10_0055
boolean visible = false
integer x = 3744
integer y = 172
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_sm10_0055
boolean visible = false
integer x = 4265
integer y = 172
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_sm10_0055
boolean visible = false
integer x = 4091
integer y = 172
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_sm10_0055
end type

type p_can from w_inherite`p_can within w_sm10_0055
end type

event p_can::clicked;call super::clicked;dw_1.ReSet()
dw_1.InsertRow(0)

dw_insert.ReSet()

wf_ini()
end event

type p_print from w_inherite`p_print within w_sm10_0055
boolean visible = false
integer x = 4439
integer y = 172
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_sm10_0055
integer x = 3749
end type

event p_inq::clicked;call super::clicked;dw_1.AcceptText()

Long   row

row = dw_1.GetRow()
If row < 1 Then Return

String ls_fac

ls_fac = dw_1.GetItemString(row, 'factory')
If Trim(ls_fac) = '' OR IsNull(ls_fac) Then 
	ls_fac = '%'
//ElseIf ls_fac = '%' Then
//	ls_fac = '%'
End If

String ls_st
String ls_ed

ls_st = dw_1.GetItemString(row, 'd_st')
If Trim(ls_st) = '' OR IsNull(ls_st) Then
	ls_st = '19000101'
Else
	If IsDate(LEFT(ls_st, 4) + '.' + MID(ls_st, 5, 2) + '.' + RIGHT(ls_st, 2)) = False Then
		MessageBox('일자형식 확인', '일자 형식을 확인 하십시오.')
		dw_1.SetColumn('d_st')
		dw_1.SetFocus()
		Return
	End If
End If

ls_ed = dw_1.GetItemString(row, 'd_ed')
If Trim(ls_ed) = '' OR IsNull(ls_ed) Then
	ls_st = '29991231'
Else
	If IsDate(LEFT(ls_ed, 4) + '.' + MID(ls_ed, 5, 2) + '.' + RIGHT(ls_ed, 2)) = False Then
		MessageBox('일자형식 확인', '일자 형식을 확인 하십시오.')
		dw_1.SetColumn('d_ed')
		dw_1.SetFocus()
		Return
	End If
End If

If ls_st > ls_ed Then
	MessageBox('일자확인', '시작일이 종료일 보다 큽니다.')
	dw_1.SetColumn('d_st')
	dw_1.SetFocus()
	Return
End If

String ls_itnbrs
String ls_itnbre

ls_itnbrs = dw_1.GetItemString(row, 'itnbr_st')
If Trim(ls_itnbrs) = '' OR IsNull(ls_itnbrs) Then ls_itnbrs = '.'

ls_itnbre = dw_1.GetItemString(row, 'itnbr_ed')
If Trim(ls_itnbre) = '' OR IsNull(ls_itnbre) Then ls_itnbre = 'ZZZZZZZZZZZZZZZZZZZZ'

dw_insert.SetRedraw(False)
dw_insert.Retrieve(gs_sabu, ls_fac, ls_st, ls_ed, ls_itnbrs, ls_itnbre)
dw_insert.SetRedraw(True)

end event

type p_del from w_inherite`p_del within w_sm10_0055
boolean visible = false
integer x = 3918
integer y = 172
boolean enabled = false
end type

type p_mod from w_inherite`p_mod within w_sm10_0055
integer x = 4096
end type

event p_mod::clicked;call super::clicked;dw_insert.AcceptText()

If f_msg_update() <> 1 Then Return

If dw_insert.UPDATE() = 1 Then
	COMMIT USING SQLCA;
Else
	ROLLBACK USING SQLCA;
	MessageBox('저장실패', '자료 저장 중 오류가 발생 했습니다.')
	Return
End If
end event

type cb_exit from w_inherite`cb_exit within w_sm10_0055
end type

type cb_mod from w_inherite`cb_mod within w_sm10_0055
end type

type cb_ins from w_inherite`cb_ins within w_sm10_0055
end type

type cb_del from w_inherite`cb_del within w_sm10_0055
end type

type cb_inq from w_inherite`cb_inq within w_sm10_0055
end type

type cb_print from w_inherite`cb_print within w_sm10_0055
end type

type st_1 from w_inherite`st_1 within w_sm10_0055
end type

type cb_can from w_inherite`cb_can within w_sm10_0055
end type

type cb_search from w_inherite`cb_search within w_sm10_0055
end type







type gb_button1 from w_inherite`gb_button1 within w_sm10_0055
end type

type gb_button2 from w_inherite`gb_button2 within w_sm10_0055
end type

type dw_1 from datawindow within w_sm10_0055
integer x = 37
integer y = 32
integer width = 3013
integer height = 268
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm10_0055_1"
boolean border = false
boolean livescroll = true
end type

event constructor;This.SetTransObject(SQLCA)
This.InsertRow(0)

This.SetItem(1, 'd_st', String(TODAY(), 'yyyymmdd'))
This.SetItem(1, 'factory', '%')

f_mod_saupj(This, 'saupj')
end event

event itemchanged;If row < 1 Then Return

Choose Case dwo.name
	Case 'filetype'
		If rb_in.Checked = True Then
			If data = 'PT' Then
				This.SetItem(row, 'path', 'C:\PARTNER\발주현황.XLS')
			ElseIf data = 'D1' Then
				This.SetItem(row, 'path', 'C:\PARTNER\일검수.XLS')
			End If
		End If
End Choose
end event

event rbuttondown;If row < 1 Then Return

SetNull(gs_code)
SetNull(gs_gubun)
SetNull(gs_codename)

Choose Case dwo.name
	Case 'itnbr_st'
		gs_gubun = '1'
		
		Open(w_itemas_popup)
		
		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
		
		This.SetItem(row, 'itnbr_st', gs_code)
		This.SetItem(row, 'itnbr_ed', gs_code)
		
	Case 'itnbr_ed'
		gs_gubun = '1'
		
		Open(w_itemas_popup)
		
		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
		
		This.SetItem(row, 'itnbr_ed', gs_code)
		
End Choose
end event

type pb_1 from u_pb_cal within w_sm10_0055
integer x = 631
integer y = 184
integer height = 76
integer taborder = 80
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_1.SetColumn('d_st')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_1.SetItem(1, 'd_st', gs_code)

end event

type rb_in from radiobutton within w_sm10_0055
integer x = 3104
integer y = 80
integer width = 219
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
string text = "등록"
boolean checked = true
end type

event clicked;wf_ini()
end event

type rb_mod from radiobutton within w_sm10_0055
integer x = 3104
integer y = 196
integer width = 219
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
string text = "수정"
end type

event clicked;wf_ini()
end event

type pb_2 from u_pb_cal within w_sm10_0055
boolean visible = false
integer x = 1129
integer y = 184
integer height = 76
integer taborder = 90
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_1.SetColumn('d_ed')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_1.SetItem(1, 'd_ed', gs_code)

end event

type p_1 from uo_picture within w_sm10_0055
integer x = 3575
integer y = 24
integer width = 178
integer taborder = 90
boolean bringtotop = true
string pointer = "C:\erpman\cur\create2.cur"
string picturename = "C:\erpman\image\생성_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\생성_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\생성_up.gif"
end event

event clicked;call super::clicked;/* Excel File 선택 */
String ls_path
String ls_file

ls_path = 'C:\PARTNER\'
ls_file = 'C:\PARTNER\일검수.XLS'

OleObject lo_obj

lo_obj = Create OleObject

Long   ll_rtn

ll_rtn = lo_obj.ConnectToNewObject('excel.application')
If ll_rtn <> 0 Then
	Messagebox('엑셀연결 실패', 'Excel Connecting Error')
	lo_obj.Disconnectobject()
	Destroy lo_obj
	Return
End If

lo_obj.WorkBooks.Open(ls_file)

lo_obj.windowstate = 3					       // Excel 창 => 1 : Normal, 2 : Minimize, 3 : Maximize
lo_obj.Application.Visible = False         // EXCEL 안보이도록 한다
lo_obj.Application.displayalerts = False
lo_obj.Application.WorkBooks(1).Activate   // WorkBook 활성화.
lo_obj.Application.WorkBooks(1).WorkSheets(1).Activate 

//Excel Sheet Open
OleObject lo_sheetobj
lo_sheetobj = lo_obj.Application.ActiveWorkbook.Worksheets[1]

Long   ll_xlsrow
Long   ll_chk

ll_xlsrow =  7  //엑셀 sheet의 일곱 번째 행 부터 시작

Long   ll_ins
Long   ll_find
Long   ll_cnt

String ls_day

ls_day = dw_1.GetItemString(1, 'd_st')
If Trim(ls_day) = '' OR IsNull(ls_day) Then
	MessageBox('등록일 확인', '등록일을 확인 하십시오.')
	dw_1.SetColumn('d_st')
	dw_1.SetFocus()
	Return
End If

String ls_null
String ls_cust
String ls_date
String ls_order
String ls_fac
String ls_cvcod
String ls_itnbr
Double ldb_dan
Double ldb_iqty
Double ldb_iamt

SetNull(ls_null)

Do While(True)
	ll_chk  = 0 //사용일이 Null일 경우 또는 없을 경우 Loop종료하기 위함.
	
	ls_cust  = Trim(String(lo_sheetobj.Cells[ll_xlsrow, 1].Value))           //업체코드
	ls_itnbr = Trim(String(lo_sheetobj.Cells[ll_xlsrow, 2].Value))           //품번
	ldb_dan  = Double(Trim(String(lo_sheetobj.Cells[ll_xlsrow, 7].Value)))   //단가
	ldb_iqty = Double(Trim(String(lo_sheetobj.Cells[ll_xlsrow, 8].Value)))   //입고수량
	ldb_iamt = Double(Trim(String(lo_sheetobj.Cells[ll_xlsrow, 12].Value)))  //입고금액
	ls_date  = Trim(String(lo_sheetobj.Cells[ll_xlsrow, 14].Value))          //입고일자
	ls_order = Trim(String(lo_sheetobj.Cells[ll_xlsrow, 15].Value))          //발주번호
	ls_fac   = Trim(String(lo_sheetobj.Cells[ll_xlsrow, 17].Value))          //공장
	
	If POS(ls_itnbr, '-') < 1 Then
		SELECT ITNBR
		  INTO :ls_itnbr
		  FROM ITEMAS
		 WHERE REPLACE(ITNBR, '-', '') = :ls_itnbr ;
	End If
	
	If Trim(ls_itnbr) <> '' OR IsNull(ls_itnbr) = False Then
		ll_chk++
		ll_ins = dw_insert.InsertRow(0)
		
		//공장코드로 거래처 가져오기
		  SELECT RFNA2
			 INTO :ls_cvcod
			 FROM REFFPF
			WHERE RFCOD = '2A'
			  AND RFGUB = :ls_fac ;
			  
		//중복자료 확인
		SELECT COUNT('X')
		  INTO :ll_cnt
		  FROM VAN_HKCD1
		 WHERE SABU     = '1'
		   AND DOCCODE  = 'D1' || :ls_day || :ls_fac
			AND CUSTCD   = :ls_cust
			AND FACTORY  = :ls_fac
			AND ITNBR    = :ls_itnbr
			AND IPNO     = SUBSTR(:ls_order, -4, 4)
			AND IPSOURCE = 'V'
			AND ORDERNO  = SUBSTR(:ls_order, 1, 10)
			AND IPSEQ    = 0
			AND SUBSEQ   = 0 ;
		If ll_cnt > 0 Then
			MessageBox('중복확인', '엑셀자료의 ' + String(ll_xlsrow) + '행의 자료는 이미 등록된 자료입니다.' + &
			                       '~r~n~r~n품번 : ' + ls_itnbr + '~r~n발주번호 : ' + ls_order)
			Exit
		End If
		dw_insert.SetItem(ll_ins, 'sabu'      , '1'                        )  //회계법인
		dw_insert.SetItem(ll_ins, 'doccode'   , 'D1' + ls_day + ls_fac     )  //문서코드
		dw_insert.SetItem(ll_ins, 'custcd'    , ls_cust                    )  //자사거래처코드
		dw_insert.SetItem(ll_ins, 'factory'   , ls_fac                     )  //공장
		dw_insert.SetItem(ll_ins, 'itnbr'     , ls_itnbr                   )  //품번
		dw_insert.SetItem(ll_ins, 'iphdate'   , ls_date                    )  //입하일자
		dw_insert.SetItem(ll_ins, 'ipno'      , RIGHT(ls_order, 4)         )  //발주순번
		dw_insert.SetItem(ll_ins, 'ipsource'  , 'V'                        )  //입고소스
		dw_insert.SetItem(ll_ins, 'ipgubun'   , 'A'                        )  //입고구분(해당 코드의 구분에 따라 매출발생)
		dw_insert.SetItem(ll_ins, 'iphqty'    , 0                          )  //입하수량
		dw_insert.SetItem(ll_ins, 'ipqty'     , ldb_iqty                   )  //입고수량
		dw_insert.SetItem(ll_ins, 'ipamt'     , ldb_iamt                   )  //입고금액
		dw_insert.SetItem(ll_ins, 'ipbad_cd'  , '00'                       )  //불량코드
		dw_insert.SetItem(ll_ins, 'confirm_no', ls_null                    )  //
		dw_insert.SetItem(ll_ins, 'ipdan'     , ldb_dan                    )  //입고단가
		dw_insert.SetItem(ll_ins, 'ipdate'    , ls_date                    )  //입고일자
		dw_insert.SetItem(ll_ins, 'orderno'   , LEFT(ls_order, 10)         )  //발주번호
		dw_insert.SetItem(ll_ins, 'lc_cha'    , ls_null                    )  //
		dw_insert.SetItem(ll_ins, 'lc_chaqty' , 0                          )  //
		dw_insert.SetItem(ll_ins, 'lc_chasum' , 0                          )  //
		dw_insert.SetItem(ll_ins, 'lc_no'     , ls_null                    )  //
		dw_insert.SetItem(ll_ins, 'packdan'   , 0                          )  //포장단가
		dw_insert.SetItem(ll_ins, 'packqty'   , 0                          )  //포장단위수량
		dw_insert.SetItem(ll_ins, 'shopcode'  , ls_null                    )  //
		dw_insert.SetItem(ll_ins, 'ipseq'     , 0                          )  //
		dw_insert.SetItem(ll_ins, 'subseq'    , 0                          )  //
		dw_insert.SetItem(ll_ins, 'fil'       , ls_null                    )  //
		dw_insert.SetItem(ll_ins, 'citnbr'    , 'N'                        )  //검수확인여부
		dw_insert.SetItem(ll_ins, 'mitnbr'    , ls_itnbr                   )  //품번(한텍)
		dw_insert.SetItem(ll_ins, 'mcvcod'    , ls_cvcod                   )  //납품거래처
		dw_insert.SetItem(ll_ins, 'mdcvcod'   , 'K'                        )  //
		dw_insert.SetItem(ll_ins, 'crt_date'  , String(TODAY(), 'yyyymmdd'))  //생성일자
		dw_insert.SetItem(ll_ins, 'crt_time'  , String(TODAY(), 'hhmmss')  )  //생성시간
		dw_insert.SetItem(ll_ins, 'crt_user'  , gs_empno                   )  //생성자
		dw_insert.SetItem(ll_ins, 'citnbr_mon', ls_null                    )  //
		dw_insert.SetItem(ll_ins, 'iojpno'    , ls_null                    )  //전표번호
		
	End If
	
	//SetItem되지 않으면 loop종료
	// 해당 행의 어떤 열에도 값이 지정되지 않았다면 파일 끝으로 인식해서 임포트 종료
	If ll_chk < 1 Then Exit 
	
	ll_xlsrow++
Loop

lo_obj.WorkBooks.Close()

lo_obj.DisConnectObject()
lo_sheetobj.DisConnectObject()

DESTROY lo_obj
DESTROY lo_sheetobj

If wf_dupl() < 0 Then
	MessageBox('오류', '중복 자료 정리 후 다시 Upload 하십시오.')
	Return
End If

If dw_insert.UPDATE() <> 1 Then
	ROLLBACK USING SQLCA;
	MessageBox('저장실패', '자료 저장에 실패 했습니다.')
Else
	COMMIT USING SQLCA;
End If
end event

type rr_1 from roundrectangle within w_sm10_0055
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33554431
integer x = 37
integer y = 320
integer width = 4567
integer height = 1956
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_sm10_0055
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 3067
integer y = 32
integer width = 283
integer height = 268
integer cornerheight = 40
integer cornerwidth = 55
end type

