$PBExportHeader$w_sal_02512.srw
$PBExportComments$제품별 매출현황
forward
global type w_sal_02512 from w_standard_print
end type
type pb_1 from u_pb_cal within w_sal_02512
end type
type pb_2 from u_pb_cal within w_sal_02512
end type
type cb_1 from commandbutton within w_sal_02512
end type
type dw_prt from datawindow within w_sal_02512
end type
type cb_2 from commandbutton within w_sal_02512
end type
type cb_3 from commandbutton within w_sal_02512
end type
type dw_prt1 from datawindow within w_sal_02512
end type
type rr_1 from roundrectangle within w_sal_02512
end type
end forward

global type w_sal_02512 from w_standard_print
integer height = 2500
string title = "제품별 매출현황"
pb_1 pb_1
pb_2 pb_2
cb_1 cb_1
dw_prt dw_prt
cb_2 cb_2
cb_3 cb_3
dw_prt1 dw_prt1
rr_1 rr_1
end type
global w_sal_02512 w_sal_02512

type variables
str_itnct str_sitnct
end variables

forward prototypes
public function integer wf_retrieve ()
public function integer wf_dwchg ()
end prototypes

public function integer wf_retrieve ();String sDatef, sDatet,ssaupj, sionam
String sIttyp, sItcls, sItnbr, tx_name, sPspec,sPrtgbn , sGubun ,ls_emp_id

String ls_depot , ls_factory , ls_cvcod , ls_yebi1

If dw_ip.AcceptText() <> 1 Then Return -1

wf_dwchg()

ssaupj      = dw_ip.getitemstring(1,"saupj")
sDatef      = Trim(dw_ip.GetItemString(1,"sdatef"))
sDatet      = Trim(dw_ip.GetItemString(1,"sdatet"))
ls_emp_id   = dw_ip.getitemstring(1,'emp_id')
sIttyp      = Trim(dw_ip.GetItemString(1,"ittyp"))

sItnbr      = Trim(dw_ip.GetItemString(1,"itnbr"))
sPrtgbn     = Trim(dw_ip.GetItemString(1,"prtgbn"))

ls_depot   = Trim(dw_ip.object.depot_no[1])
ls_factory = Trim(dw_ip.object.factory[1])
ls_cvcod   = Trim(dw_ip.object.cvcod[1])

sPrtgbn   = Trim(dw_ip.object.prtgbn[1])
ls_yebi1  = Trim(dw_ip.object.yebi1[1])
sgubun  = Trim(dw_ip.object.gubun[1])

IF sDatef = "" OR IsNull(sDatef) or sDatet = "" OR IsNull(sDatet) THEN
	f_message_chk(30,'[기간]')
	dw_ip.SetColumn("sdatef")
	dw_ip.SetFocus()
	Return -1
END IF

If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400,'[사업장]')
	dw_ip.SetFocus()
	Return -1
End If

If Isnull(sIttyp) or sIttyp = '' Then sIttyp = '%'
If Isnull(sItnbr) or sItnbr = '' Then 
	sItnbr = '%'
else
	sItnbr = sItnbr + '%'
end If

if isnull(ls_emp_id) or isnull(ls_emp_id) then ls_emp_id ='%'

if isnull(ls_depot) or isnull(ls_depot) then ls_depot ='%'
if isnull(ls_factory) or isnull(ls_factory) or ls_factory = '.' then ls_factory ='%'
if isnull(ls_cvcod) or isnull(ls_cvcod) then ls_cvcod ='%'


IF dw_print.Retrieve(ssaupj ,sdatef, sdatet, ls_emp_id, sIttyp ,sItnbr , ls_depot , ls_factory , ls_cvcod ) <= 0 THEN
	f_message_chk(50, '')
	dw_list.Reset()
	dw_ip.setcolumn('sdatef')
	dw_ip.SetFocus()
	Return -1
END IF

If sPrtgbn = '1' Or sPrtgbn = '2' Then			// 출하, 매출
	dw_print.SetFilter("")
	dw_print.Filter()
ElseIf sPrtgbn = '3' Then							// 판매
//		O02	판매출고
//		O16	기타매출
//		O41	판매반품(불량)
//		O47	유상사급판매반품
//		O4A	판매반품(정상)
//		OY2	유상사급출고
//		OY3	판매소급
//		OY6	단가소급(판매-)
//		OY5	단가소급(판매+)
	//단가소급분 추가(T.F.T) - by shingoon 2009.06.10
	//dw_print.SetFilter("ionam='판매출고' or ionam='판매반품(불량)' or ionam='판매반품(정상)'")
	dw_print.SetFilter("ionam='판매출고' or ionam='판매반품(불량)' or ionam='판매반품(정상)' or ionam='단가소급(판매-)' or ionam='단가소급(판매+)' or ionam='판매소급'")
	dw_print.Filter()
End If

//If sPrtgbn = '1' Then			// 출하
//	dw_print.SetFilter("")
//	dw_print.Filter()
//ElseIf sPrtgbn = '2' Then		// 매출
//	if ls_yebi1 = 'Y' then
//		dw_print.SetFilter("Not isNull(yebi1)")
//		dw_print.Filter()
//	else
//		dw_print.SetFilter("")
//		dw_print.Filter()
//	end if
//ElseIf sPrtgbn = '3' and ( sgubun = '1' or sgubun = '2' or sgubun = '3' )Then		// 판매
//	select ionam into :sionam from iomatrix where iogbn = 'O02' ;
//	if ls_yebi1 = 'Y' then
//		dw_print.SetFilter("ionam = '"+sionam+"' AND Not isNull(yebi1)")
//		dw_print.Filter()
//	else
//		dw_print.SetFilter("ionam = '"+sionam+"'")
//		dw_print.Filter()
//	end if
//End If

//tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(ittyp) ', 1)"))
//If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_print.Modify("tx_ittyp.text = '"+tx_name+"'")
//
//tx_name = Trim(dw_ip.GetitemString(1,'itclsnm'))
//If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_print.Modify("tx_itcls.text = '"+tx_name+"'")
//
//tx_name = Trim(dw_ip.GetitemString(1,'itdsc'))
//If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_print.Modify("tx_itnbr.text = '"+tx_name+"'")
//
//tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(prtgbn) ', 1)"))
//If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_print.Modify("tx_gubun.text = '"+tx_name+"'")
//
//tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(saupj) ', 1)"))
//If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_print.Modify("tx_saupj.text = '"+tx_name+"'")
//
//tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(emp_id) ', 1)"))
//If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_print.Modify("tx_emp_id.text = '"+tx_name+"'")

Return 1
end function

public function integer wf_dwchg ();//

String ls_gubun , ls_prtgbn

ls_prtgbn = Trim(dw_ip.object.prtgbn[1])
ls_gubun  = Trim(dw_ip.object.gubun[1])

//prtgbn : 1 -> 출하
//         2 -> 매출
//         3 -> 판매
//gubun  : 1 -> 품목별
//         2 -> 거래처별
//			  3 -> 공장별
//         4 -> 품목집계
If ls_prtgbn = '1' Then
	
	If ls_gubun = '1' Then
		dw_list.Dataobject = 'd_sal_025122_1'
		dw_print.Dataobject = 'd_sal_025122_1p'
	elseif ls_gubun = '2' Then
		dw_list.Dataobject = 'd_sal_025122_2'
		dw_print.Dataobject = 'd_sal_025122_2p'
	elseif ls_gubun = '3' Then
		dw_list.Dataobject = 'd_sal_025124_1'
		dw_print.Dataobject = 'd_sal_025124_1p'
	else
		dw_list.Dataobject = 'd_sal_025125_1'
		dw_print.Dataobject = 'd_sal_025125_1p'
	end if
	
else
	If ls_gubun = '1' Then
		dw_list.Dataobject = 'd_sal_025123_1'
		dw_print.Dataobject = 'd_sal_025123_1p'
	elseif ls_gubun = '2' Then
		dw_list.Dataobject = 'd_sal_025123_2'
		dw_print.Dataobject = 'd_sal_025123_2p'
	elseif ls_gubun = '3' Then
		dw_list.Dataobject = 'd_sal_025124_2'
		dw_print.Dataobject = 'd_sal_025124_2p'
	else
		dw_list.Dataobject = 'd_sal_025125_2'
		dw_print.Dataobject = 'd_sal_025125_2p'
	end if
	
end if

dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

dw_print.ShareData(dw_list)

Return 1
end function

on w_sal_02512.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.cb_1=create cb_1
this.dw_prt=create dw_prt
this.cb_2=create cb_2
this.cb_3=create cb_3
this.dw_prt1=create dw_prt1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.dw_prt
this.Control[iCurrent+5]=this.cb_2
this.Control[iCurrent+6]=this.cb_3
this.Control[iCurrent+7]=this.dw_prt1
this.Control[iCurrent+8]=this.rr_1
end on

on w_sal_02512.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.cb_1)
destroy(this.dw_prt)
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.dw_prt1)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;
dw_ip.reset() 
dw_ip.insertrow(0) 

dw_ip.SetItem(1,"sdatef", is_today )
dw_ip.SetItem(1,"sdatet", is_today )
dw_ip.Setfocus()

///* User별 사업장 Setting Start */
//setnull(gs_code)
//If f_check_saupj() = 1 Then
	dw_ip.SetItem(1, 'saupj', gs_saupj)
//   if gs_code <> '%' then
//   	dw_ip.Modify("saupj.protect=1")
//		dw_ip.Modify("saupj.background.color = 80859087")
//   End if
//End If
///* ---------------------- End  */

sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 가로방향"
end event

type p_xls from w_standard_print`p_xls within w_sal_02512
boolean visible = true
integer x = 4256
integer y = 24
boolean enabled = false
string picturename = "C:\erpman\image\엑셀변환_d.gif"
end type

type p_sort from w_standard_print`p_sort within w_sal_02512
boolean visible = true
integer x = 3653
integer y = 16
end type

type p_preview from w_standard_print`p_preview within w_sal_02512
integer x = 4082
end type

type p_exit from w_standard_print`p_exit within w_sal_02512
integer x = 4430
end type

type p_print from w_standard_print`p_print within w_sal_02512
boolean visible = false
integer x = 983
integer y = 16
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_02512
integer x = 3909
end type

event p_retrieve::clicked;//

if is_Upmu = 'A' then
	
	if dw_ip.AcceptText() = -1 then return  

	w_mdi_frame.sle_msg.text =""
	
	sabu_f =Trim(dw_ip.GetItemString(1,"saupj"))
	
	SetPointer(HourGlass!)
	IF sabu_f ="" OR IsNull(sabu_f) OR sabu_f ="99" THEN	//사업장이 전사이거나 없으면 모든 사업장//
		sabu_f ="10"
		sabu_t ="98"
		SELECT "REFFPF"."RFNA1"  
		 INTO :sabu_nm  
		 FROM "REFFPF"  
		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND  
				( "REFFPF"."RFGUB" = '99' )   ;
	ELSE
		sabu_t =sabu_f
		SELECT "REFFPF"."RFNA1"  
		 INTO :sabu_nm  
		 FROM "REFFPF"  
		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND  
				( "REFFPF"."RFGUB" = :sabu_f )   ;
	END IF
end if

IF wf_retrieve() = -1 THEN
	p_xls.Enabled = False
	p_xls.PictureName = 'C:\erpman\image\엑셀변환_d.gif'
	
	cb_1.Enabled = False
	cb_3.Enabled = False

	p_preview.enabled = False
	p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
	SetPointer(Arrow!)
	Return
Else
	p_xls.Enabled = True
	p_xls.PictureName = 'C:\erpman\image\엑셀변환_up.gif'
	
	If dw_ip.GetItemString(1, 'prtgbn') = '1' Then
		cb_1.Enabled = True
		cb_2.Enabled = True
		cb_3.Enabled = True
	Else
		cb_1.Enabled = False
		cb_2.Enabled = False
		cb_3.Enabled = False
	End If
	
	p_preview.enabled = true
	p_preview.PictureName = 'C:\erpman\image\미리보기_up.gif'
END IF
dw_list.scrolltorow(1)
dw_list.SetFocus()
SetPointer(Arrow!)	

w_mdi_frame.sle_msg.text =""

///-----------------------------------------------------------------------------------------
// by 2006.09.30 font채 변경 - 신
String ls_gbn
SELECT DATANAME
  INTO :ls_gbn
  FROM SYSCNFG
 WHERE SYSGU  = 'C'
   AND SERIAL = '81'
   AND LINENO = '1' ;
If ls_gbn = 'Y' Then
	//wf_setfont()
	WindowObject l_object[]
	Long i
	gstr_object_chg lstr_object		
	For i = 1 To UpperBound(Control[])
		lstr_object.lu_object[i] = Control[i]  //Window Object
		lstr_object.li_obj = i						//Window Object 갯수
	Next
	f_change_font(lstr_object)
End If

///-----------------------------------------------------------------------------------------


end event











type dw_print from w_standard_print`dw_print within w_sal_02512
integer x = 887
integer y = 16
string dataobject = "d_sal_025125_2p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_02512
integer x = 14
integer y = 180
integer width = 4594
integer height = 316
string dataobject = "d_sal_025121"
end type

event dw_ip::itemerror;
Return 1
end event

event dw_ip::itemchanged;
String  sDateFrom, sDateTo, snull, sPrtGbn
Long    nRow
String ls_cvcod , ls_cvnas

SetNull(snull)

nRow = GetRow()
If nRow <= 0 Then Return

Choose Case GetColumnName() 
	Case"sdatef"
		sDateFrom = Trim(this.GetText())
		IF sDateFrom ="" OR IsNull(sDateFrom) THEN RETURN
		
		IF f_datechk(sDateFrom) = -1 THEN
			f_message_chk(35,'[수불기간]')
			this.SetItem(1,"sdatef",snull)
			Return 1
		END IF
	Case "sdatet"
		sDateTo = Trim(this.GetText())
		IF sDateTo ="" OR IsNull(sDateTo) THEN RETURN
		
		IF f_datechk(sDateTo) = -1 THEN
			f_message_chk(35,'[수불기간]')
			this.SetItem(1,"sdatet",snull)
			Return 1
		END IF
	Case 'cvcod'
		ls_cvcod = this.GetText()								
		 
		if ls_cvcod = "" or isnull(ls_cvcod) then 
			this.setitem(1, 'cvnas', snull)
			return 
		end if
		
		SELECT "VNDMST"."CVNAS"  
		  INTO :ls_cvnas  
		  FROM "VNDMST"  
		 WHERE "VNDMST"."CVCOD" = :ls_cvcod  ;
	
		if sqlca.sqlcode = 0 then 
			this.setitem(1, 'cvnas', ls_cvnas)
		else
			this.setitem(1, 'cvcod', snull)
			this.triggerevent(RbuttonDown!)
			return 1
		end if
	Case 'prtgbn'
		If data = '1' Then
			cb_1.Enabled = True
			cb_2.Enabled = True
		Else
			cb_1.Enabled = False
			cb_2.Enabled = False
		End If		
END Choose
end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Long lrow

lrow = Getrow()

If lrow < 1 Then Return

Choose Case GetcolumnName() 
	Case 'cvcod'
		gs_code = GetText()
		Open(w_vndmst_popup)
		If IsNull(gs_code) Or gs_code = '' Then Return
		
		SetItem(lrow, "cvcod", gs_Code)
		SetItem(lrow, "cvnas", gs_Codename)

END Choose
end event

type dw_list from w_standard_print`dw_list within w_sal_02512
integer y = 508
integer width = 4539
integer height = 1796
string dataobject = "d_sal_025122_1"
boolean border = false
boolean hsplitscroll = false
end type

event dw_list::rowfocuschanged;call super::rowfocuschanged;If dw_ip.GetItemString(1, 'gubun') = '4' Then Return

If currentrow < 1 Then Return

String ls_jpno

ls_jpno = This.GetItemString(currentrow, 'iojpno')

dw_prt.SetRedraw(False)
dw_prt.Retrieve(LEFT(ls_jpno, 12))
dw_prt.SetRedraw(True)

dw_prt1.SetRedraw(False)
dw_prt1.Retrieve(LEFT(ls_jpno, 12))
dw_prt1.SetRedraw(True)
end event

event dw_list::retrieveend;call super::retrieveend;If dw_ip.GetItemString(1, 'gubun') = '4' Then Return

If rowcount < 1 Then Return

String ls_jpno

ls_jpno = This.GetItemString(1, 'iojpno')

dw_prt.SetRedraw(False)
dw_prt.Retrieve(LEFT(ls_jpno, 12))
dw_prt.SetRedraw(True)

dw_prt1.SetRedraw(False)
dw_prt1.Retrieve(LEFT(ls_jpno, 12))
dw_prt1.SetRedraw(True)
end event

event dw_list::clicked;call super::clicked;If dw_ip.GetItemString(1, 'gubun') = '4' Then Return

If row < 1 Then Return

String ls_jpno

ls_jpno = This.GetItemString(row, 'iojpno')

dw_prt.SetRedraw(False)
dw_prt.Retrieve(LEFT(ls_jpno, 12))
dw_prt.SetRedraw(True)

dw_prt1.SetRedraw(False)
dw_prt1.Retrieve(LEFT(ls_jpno, 12))
dw_prt1.SetRedraw(True)
end event

type pb_1 from u_pb_cal within w_sal_02512
integer x = 2053
integer y = 204
integer width = 91
integer height = 88
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('sdatef')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'sdatef', gs_code)

end event

type pb_2 from u_pb_cal within w_sal_02512
integer x = 2523
integer y = 204
integer width = 91
integer height = 88
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('sdatet')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'sdatet', gs_code)

end event

type cb_1 from commandbutton within w_sal_02512
integer x = 3063
integer y = 36
integer width = 521
integer height = 112
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "출고전표 출력"
end type

event clicked;If dw_ip.GetItemString(1, 'gubun') = '4' Then
	MessageBox('출력 확인', '구분이 품번집계일 경우 출고전표는 출력 할 수 없습니다.')
	Return
End If

String ls_name
ls_name = f_get_name5('02', gs_empno, '')

dw_prt.Modify("t_name.Text = '" + ls_name + "'")

/* 프린터 미리보기 또는 프린터 설정 창이 뜬 후 종료(닫기)버튼을 누르면 출력되지 말아야 함. - 2006.12.13 by shingoon */
OpenWithParm(w_print_preview, dw_prt)
Long   ll_rtn
ll_rtn = Message.DoubleParm

If ll_rtn < 1 Then Return

//dw_prt.Modify("t_text.Text = '- 업 체 용 -'")
//dw_prt.Print()
//dw_prt.Modify("t_text.text='- 고객지원팀 용 -'")
//dw_prt.Print()
end event

type dw_prt from datawindow within w_sal_02512
boolean visible = false
integer x = 622
integer y = 12
integer width = 151
integer height = 132
integer taborder = 60
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm40_0010_chul_p_new"
boolean border = false
boolean livescroll = true
end type

event constructor;This.SetTransObject(SQLCA)
end event

type cb_2 from commandbutton within w_sal_02512
integer x = 37
integer y = 36
integer width = 507
integer height = 112
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "용기 사용 현황"
end type

event clicked;dw_ip.AcceptText()

Long   row

row = dw_ip.GetRow()
If row < 1 Then Return

gstr_array lstr_array

lstr_array.as_str[1] = dw_ip.GetItemString(row, 'saupj'   )  //사업장
lstr_array.as_str[2] = dw_ip.GetItemString(row, 'sdatef'  )  //수불기간(시작)
lstr_array.as_str[3] = dw_ip.GetItemString(row, 'sdatet'  )  //수불기간(종료)
lstr_array.as_str[4] = dw_ip.GetItemString(row, 'emp_id'  )  //담당자
lstr_array.as_str[5] = dw_ip.GetItemString(row, 'ittyp'   )  //품목구분
lstr_array.as_str[6] = dw_ip.GetItemString(row, 'itnbr'   )  //품번
lstr_array.as_str[7] = dw_ip.GetItemString(row, 'depot_no')  //출고처(출고창고)
lstr_array.as_str[8] = dw_ip.GetItemString(row, 'factory' )  //공장
lstr_array.as_str[9] = dw_ip.GetItemString(row, 'cvcod'   )  //납품처(거래처)

If Trim(lstr_array.as_str[1]) = '' OR IsNull(lstr_array.as_str[1]) Then
	MessageBox('사업장확인', '사업장은 필수 선택 사항 입니다.')
	Return
End If

If Trim(lstr_array.as_str[2]) = '' OR IsNull(lstr_array.as_str[2]) Then
	lstr_array.as_str[2] = '19000101'
Else
	If IsDate(LEFT(lstr_array.as_str[2], 4) + '.' + MID(lstr_array.as_str[2], 5, 2) + '.' + RIGHT(lstr_array.as_str[2], 2)) = False Then
		MessageBox('일자형식 확인', '잘못된 일자 형식입니다.')
		Return
	End If
End If

If Trim(lstr_array.as_str[3]) = '' OR IsNull(lstr_array.as_str[3]) Then
	lstr_array.as_str[3] = '29991231'
Else
	If IsDate(LEFT(lstr_array.as_str[3], 4) + '.' + MID(lstr_array.as_str[3], 5, 2) + '.' + RIGHT(lstr_array.as_str[3], 2)) = False Then
		MessageBox('일자형식 확인', '잘못된 일자 형식입니다.')
		Return
	End If
End If

If lstr_array.as_str[2] > lstr_array.as_str[3] Then
	MessageBox('기간 설정 확인', '시작일 보다 종료일이 빠릅니다.')
	Return
End If

If Trim(lstr_array.as_str[4]) = '' OR IsNull(lstr_array.as_str[4]) Then lstr_array.as_str[4] = '%'
If Trim(lstr_array.as_str[5]) = '' OR IsNull(lstr_array.as_str[5]) Then lstr_array.as_str[5] = '%'
If Trim(lstr_array.as_str[6]) = '' OR IsNull(lstr_array.as_str[6]) Then lstr_array.as_str[6] = '%'
If Trim(lstr_array.as_str[7]) = '' OR IsNull(lstr_array.as_str[7]) Then lstr_array.as_str[7] = '%'
If Trim(lstr_array.as_str[8]) = '' OR IsNull(lstr_array.as_str[8]) Then lstr_array.as_str[8] = '%'
If Trim(lstr_array.as_str[9]) = '' OR IsNull(lstr_array.as_str[9]) Then lstr_array.as_str[9] = '%'

OpenWithParm(w_han_yongki, lstr_array)
end event

type cb_3 from commandbutton within w_sal_02512
integer x = 2537
integer y = 36
integer width = 521
integer height = 112
integer taborder = 10
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "PLT 첨부용"
end type

event clicked;If dw_ip.GetItemString(1, 'gubun') = '4' Then
	MessageBox('출력 확인', '구분이 품번집계일 경우 출고전표는 출력 할 수 없습니다.')
	Return
End If

String ls_name
ls_name = f_get_name5('02', gs_empno, '')

dw_prt1.Modify("t_name.Text = '" + ls_name + "'")

/* 프린터 미리보기 또는 프린터 설정 창이 뜬 후 종료(닫기)버튼을 누르면 출력되지 말아야 함. - 2006.12.13 by shingoon */
OpenWithParm(w_print_preview, dw_prt1)
Long   ll_rtn
ll_rtn = Message.DoubleParm

If ll_rtn < 1 Then Return

//dw_prt.Modify("t_text.Text = '- 업 체 용 -'")
//dw_prt.Print()
//dw_prt.Modify("t_text.text='- 고객지원팀 용 -'")
//dw_prt.Print()
end event

type dw_prt1 from datawindow within w_sal_02512
boolean visible = false
integer x = 1403
integer y = 28
integer width = 151
integer height = 124
integer taborder = 60
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_sm40_0010_chul_p_new1"
boolean border = false
end type

event constructor;This.SetTransObject(SQLCA)
end event

type rr_1 from roundrectangle within w_sal_02512
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 500
integer width = 4567
integer height = 1816
integer cornerheight = 40
integer cornerwidth = 55
end type

