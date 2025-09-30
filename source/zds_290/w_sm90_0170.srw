$PBExportHeader$w_sm90_0170.srw
$PBExportComments$년판매계획 현황
forward
global type w_sm90_0170 from w_standard_print
end type
type rb_car from radiobutton within w_sm90_0170
end type
type rb_itnbr from radiobutton within w_sm90_0170
end type
type gb_1 from groupbox within w_sm90_0170
end type
type rr_1 from roundrectangle within w_sm90_0170
end type
end forward

global type w_sm90_0170 from w_standard_print
integer height = 2492
string title = "년 판매계획 현황"
rb_car rb_car
rb_itnbr rb_itnbr
gb_1 gb_1
rr_1 rr_1
end type
global w_sm90_0170 w_sm90_0170

forward prototypes
public function integer wf_retrieve ()
public subroutine wf_init ()
end prototypes

public function integer wf_retrieve ();String sYear, scust, stemp, sDate, eDate, sFilter, sCargbn1, sCargbn2
String scvcod
Long   nCnt, ix, nrow, nChasu
String sSaupj , ls_itnbr , ls_gubun

If dw_ip.AcceptText() <> 1 Then Return -1
If dw_list.AcceptText() <> 1 Then Return -1

sYear = trim(dw_ip.getitemstring(1, 'yymm'))
nChasu = dw_ip.getitemNumber(1, 'chasu')
scvcod = trim(dw_ip.getitemstring(1, 'cvcod'))

ls_itnbr = Trim(dw_ip.Object.itnbr[1])

/* 사업장 체크 */
sSaupj= Trim(dw_ip.GetItemString(1, 'saupj'))


If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_ip.SetFocus()
	dw_ip.SetColumn('saupj')
	Return -1
End If

If IsNull(sYear) Or sYear = '' Then
	f_message_chk(1400,'[계획년도]')
	Return -1
End If


If IsNull(nchasu) Or nChasu <= 0 Then
	f_message_chk(1400,'[계획차수]')
	Return -1
End If

If IsNull(scvcod) Or scvcod = '.' or scvcod = '' Then scvcod = '%'
	
If IsNull(ls_itnbr) Or ls_itnbr = '' Then 
	ls_itnbr = '%'
else
	ls_itnbr = ls_itnbr + '%'
end If

If rb_itnbr.checked Then
	ls_gubun = '2' 
	dw_print.Modify("t_txt.text='품번'")
else
	ls_gubun = '1'
	dw_print.Modify("t_txt.text='차종'")
end IF
	
If dw_list.Retrieve(gs_sabu, sSaupj, sYear, nChasu, scvcod+'%',  ls_itnbr , ls_gubun ) <= 0 Then
	f_message_chk(50,'')
End If

dw_print.Modify("t_year.text='"+sYear+"'")
dw_print.Modify("t_chasu.text='"+string(nChasu)+"'")

Return 1


//String sYear, scust, stemp, sDate, eDate, sFilter, sCargbn1, sCargbn2, sItem, sCod
//String scvcod, tx_name
//Long   nCnt, ix, nrow, nChasu
//String sSaupj, ssarea
//
//If dw_ip.AcceptText() <> 1 Then Return -1
//If dw_print.AcceptText() <> 1 Then Return -1
//
//sYear = trim(dw_ip.getitemstring(1, 'yymm'))
//scust = trim(dw_ip.getitemstring(1, 'cust'))
//ssarea = trim(dw_ip.getitemstring(1, 'sarea'))
//scvcod = trim(dw_ip.getitemstring(1, 'cvcod'))
//sItem = trim(dw_ip.getitemstring(1, 'item'))
//sCod = trim(dw_ip.getitemstring(1, 'scod'))
//
//If IsNull(sYear) Or sYear = '' Then
//	f_message_chk(1400,'[계획년도]')
//	Return -1
//End If
//
//nChasu = dw_ip.GetItemNumber(1, 'chasu')
//If IsNull(nChasu) Or nChasu <= 0 Then
//	f_message_chk(1400,'[계획차수]')
//	Return -1
//End If
//
///* 사업장 체크 */
//sSaupj= Trim(dw_ip.GetItemString(1, 'saupj'))
//If IsNull(sSaupj) Or sSaupj = '' Then
//	f_message_chk(1400, '[사업장]')
//	dw_ip.SetFocus()
//	dw_ip.SetColumn('saupj')
//	Return -1
//End If
//
//// 품목별 계획
//If sItem = 'Z' Then
//	dw_print.DataObject = 'd_sm00_00040_4_p'
//	dw_list.DataObject  = 'd_sm00_00040_4'
//Else
//	If dw_ip.GetItemString(1, 'item') = 'N' And ( sCust = '2' Or sCust = '3' Or sCust = '4' Or sCust = '5' Or sCust = '6' Or sCust = '9' ) Then
//		MessageBox('확인','차종별 계획을 조회하실 수 없습니다.!!')
//		Return -1
////		dw_ip.SetItem(1, 'item', 'Y')
//	End If
//	
//	// 차종별/업체별 계획
//	If ( scust = '1' or scust = '3' or scust = '7' or scust = '8' or scust = 'A' or scust = '%' ) And dw_ip.GetItemString(1, 'item') = 'N'  Then
//		If IsNull(scust) Or scust = '%' Then
//			f_message_chk(1400,'[고객구분]')
//			Return -1
//		End If
//	
//		dw_print.DataObject = 'd_sm00_00040_2_p'
//		dw_list.DataObject = 'd_sm00_00040_2'
//	Else
//		If IsNull(scust) Or scust = '' Then sCust = ''
//		
//		dw_print.DataObject = 'd_sm00_00040_3_p'
//		dw_list.DataObject = 'd_sm00_00040_3'
//	End If
//End If
//
//dw_print.SetTransObject(sqlca)
//
//Choose Case dw_print.DataObject
//	// 품목별 계획인 경우
//	Case 'd_sm00_00040_4_p'
//		sCvcod = ''
//		
//		If dw_print.Retrieve(gs_sabu, sYear, scust+'%', scvcod+'%', sCod +'%',  sSaupj, nChasu) <= 0 Then
//			f_message_chk(50,'')
//		End If
//	// 업체별 계획인 경우
//	Case 'd_sm00_00040_3_p'
//		If IsNull(scvcod) Then scvcod = ''
//		If IsNull(ssarea) Then ssarea = ''
//		
//		If dw_print.Retrieve(gs_sabu, sYear, ssarea+'%', scvcod+'%', sSaupj, nChasu) <= 0 Then
//			f_message_chk(50,'')
//		End If
//		
//		tx_name = Trim(dw_ip.GetItemString(1, 'cvnas'))
//		If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//		dw_print.Modify("tx_cvcod.text = '"+tx_name+"'")
//		
//	// 차종/기종별 계획인 경우
//	Case Else
//		sCargbn1 = dw_ip.GetItemString(1, 'cargbn1')
//		sCargbn2 = dw_ip.GetItemString(1, 'cargbn2')
//				
//		If dw_print.Retrieve(sSaupj, sYear, sCargbn1, sCargbn2, sCust, nChasu) <= 0 Then
//			f_message_chk(50,'')
//		End If
//		
//		If sCargbn1 = 'E' Or sCargbn1 = 'C' Then
//			If sCargbn2 = 'E' Then
//				dw_print.Object.tx_1.text = '엔진명'
//				dw_print.Object.tx_2.text = '엔진형식'
//				dw_print.Object.tx_3.text = ''
//				dw_print.Object.tx_4.text = ''
//				dw_list.Object.tx_1.text = '엔진명'
//				dw_list.Object.tx_2.text = '엔진형식'
//				dw_list.Object.tx_3.text = ''
//				dw_list.Object.tx_4.text = ''
//			End If
//			If sCargbn2 = 'T' oR sCargbn2 = 'M' Then
//				dw_print.Object.tx_1.text = '엔진명'
//				dw_print.Object.tx_2.text = '엔진형식'
//				dw_print.Object.tx_3.text = '계열'
//				dw_print.Object.tx_4.text = '기종'
//				dw_list.Object.tx_1.text = '엔진명'
//				dw_list.Object.tx_2.text = '엔진형식'
//				dw_list.Object.tx_3.text = '계열'
//				dw_list.Object.tx_4.text = '기종'
//			End If
//			If sCargbn2 = 'D' Then
//				dw_print.Object.tx_1.text = '구분'
//				dw_print.Object.tx_2.text = '형식'
//				dw_print.Object.tx_3.text = 'ABS'
//				dw_print.Object.tx_4.text = ''
//				dw_list.Object.tx_1.text = '구분'
//				dw_list.Object.tx_2.text = '형식'
//				dw_list.Object.tx_3.text = 'ABS'
//				dw_list.Object.tx_4.text = ''
//			End If
//		Else
//			dw_print.Object.tx_1.text = ''
//			dw_print.Object.tx_2.text = ''
//			dw_print.Object.tx_3.text = ''
//			dw_print.Object.tx_4.text = ''
//			
//			dw_list.Object.tx_1.text = ''
//			dw_list.Object.tx_2.text = ''
//			dw_list.Object.tx_3.text = ''
//			dw_list.Object.tx_4.text = ''
//		End If
//		
//		tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(cargbn2) ', 1)"))
//		If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//		dw_print.Modify("tx_cargbn2.text = '"+tx_name+"'")
//End Choose
//
//tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(cust) ', 1)"))
//If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_print.Modify("tx_cust.text = '"+tx_name+"'")
//
//dw_print.ShareData(dw_list)
//
//return 1
end function

public subroutine wf_init ();

If rb_car.Checked Then
	dw_ip.object.t_itnbr.Text = "차종"
	dw_list.DataObject = "d_sm90_0170_a"

Else
	dw_ip.object.t_itnbr.Text = "품번"
	dw_list.DataObject = "d_sm90_0170_b"
	
End iF

dw_list.SetTransObject(SQLCA)
dw_list.ShareData(dw_print)



	
end subroutine

on w_sm90_0170.create
int iCurrent
call super::create
this.rb_car=create rb_car
this.rb_itnbr=create rb_itnbr
this.gb_1=create gb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_car
this.Control[iCurrent+2]=this.rb_itnbr
this.Control[iCurrent+3]=this.gb_1
this.Control[iCurrent+4]=this.rr_1
end on

on w_sm90_0170.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_car)
destroy(this.rb_itnbr)
destroy(this.gb_1)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetTransObject(SQLCA)
dw_ip.InsertRow(0)

setnull(gs_code)
If f_check_saupj() = 1 Then
	dw_ip.SetItem(1, 'saupj', gs_code)
   if gs_code <> '%' then
   	dw_ip.Modify("saupj.protect=1")
   End if
End If

Long ll_chasu


Select Max(chasu) Into :ll_chasu 
  from SM01_YEARPLAN
Where saupj   = :gs_code
  and YYYY = trim(to_char(to_number(substr(:is_today,1,4))+1 ,'0000'))
  and gubun = '1';
  
If isNull(ll_chasu) Then ll_chasu = 1
  
dw_ip.Object.yymm[1] = String( Long ( Left(is_today,4)) + 1 ,'0000')
dw_ip.Object.chasu[1] = ll_chasu

dw_ip.SetColumn("cvcod")

rb_car.Checked = True

rb_car.PostEvent(Clicked!)

end event

type p_xls from w_standard_print`p_xls within w_sm90_0170
end type

type p_sort from w_standard_print`p_sort within w_sm90_0170
end type

type p_preview from w_standard_print`p_preview within w_sm90_0170
integer taborder = 0
end type

type p_exit from w_standard_print`p_exit within w_sm90_0170
integer taborder = 0
end type

type p_print from w_standard_print`p_print within w_sm90_0170
integer taborder = 0
end type

type p_retrieve from w_standard_print`p_retrieve within w_sm90_0170
integer taborder = 0
end type







type st_10 from w_standard_print`st_10 within w_sm90_0170
end type



type dw_print from w_standard_print`dw_print within w_sm90_0170
string dataobject = "d_sm90_0170_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sm90_0170
integer x = 18
integer y = 20
integer width = 2569
integer height = 256
integer taborder = 0
string dataobject = "d_sm90_0170_1"
end type

event dw_ip::itemchanged;String s_cvcod, snull, get_nm, sItem, sCust, sDate, sSaupj
Int    nChasu

SetNull(sNull)

/* 사업장 체크 */
sSaupj= Trim(GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	Return 2
End If

Choose Case GetColumnName()
	/* 계획년도 */
	Case 'yymm'
		sDate = Left(GetText(),6)
				
		If f_datechk(sDate+'0101') <> 1 Then
			f_message_chk(35,'')
			return 1
		Else
			dw_list.Reset()
			
			// 해당년도의 최종차수 계산
			SELECT MAX(CHASU) INTO :nChasu FROM SM01_YEARPLAN 
			 WHERE SABU = :gs_sabu 
			   AND SAUPJ = :sSaupj 
				AND YYYY = :sDate;
			If IsNull(nChasu) Then nChasu = 1
			SetItem(1, 'chasu', nChasu)
		End If
	Case 'cvcod'
		s_cvcod = this.GetText()								
		 
		if s_cvcod = "" or isnull(s_cvcod) then 
			this.setitem(1, 'cvnas', snull)
			return 
		end if
		
		SELECT "VNDMST"."CVNAS"  
		  INTO :get_nm  
		  FROM "VNDMST"  
		 WHERE "VNDMST"."CVCOD" = :s_cvcod  ;
	
		if sqlca.sqlcode = 0 then 
			this.setitem(1, 'cvnas', get_nm)
		else
			this.triggerevent(RbuttonDown!)
			return 1
		end if
	Case 'cust'
		// 차종
		If GetText() = '1' Then
			SetItem(1, 'cargbn1', 'E')
			SetItem(1, 'cargbn2', 'E')
		// 기종
		ElseIf GetText() = '2' Then
			SetItem(1, 'cargbn1', '0')
			SetItem(1, 'cargbn2', '9')
		// 기종
		ElseIf GetText() = '3' Then
			SetItem(1, 'cargbn1', '1')
			SetItem(1, 'cargbn2', '9')
		// 기아
		ElseIf GetText() = '7' Then
			SetItem(1, 'cargbn1', 'E')
			SetItem(1, 'cargbn2', 'E')
		// CKD
		ElseIf GetText() = '8' Then
			SetItem(1, 'cargbn1', 'E')
			SetItem(1, 'cargbn2', 'E')
		// 파워텍
		ElseIf GetText() = 'A' Then
			SetItem(1, 'cargbn1', 'E')
			SetItem(1, 'cargbn2', 'T')
		// 기타(품목별)
		Else
			SetItem(1, 'cargbn1', '9')
			SetItem(1, 'cargbn2', '9')
		End If
	Case 'item'
		sItem = GetText()
End Choose
end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

event dw_ip::rbuttondown;call super::rbuttondown;long lrow

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

lrow = this.GetRow()
Choose Case GetcolumnName() 
	Case 'cvcod'
		gs_code = GetText()
		Open(w_vndmst_popup)
		If IsNull(gs_code) Or gs_code = '' Then Return
		
		SetItem(lrow, "cvcod", gs_Code)
		SetItem(lrow, "cvnas", gs_Codename)
End Choose
end event

type dw_list from w_standard_print`dw_list within w_sm90_0170
integer x = 32
integer y = 280
integer width = 4558
integer height = 2000
integer taborder = 0
string dataobject = "d_sm90_0170_a"
boolean border = false
end type

event dw_list::clicked;call super::clicked;If Row <= 0 then
	SelectRow(0,False)
ELSE
	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
END IF
end event

type rb_car from radiobutton within w_sm90_0170
integer x = 2638
integer y = 64
integer width = 274
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "차종"
boolean checked = true
end type

event clicked;wf_init()
end event

type rb_itnbr from radiobutton within w_sm90_0170
integer x = 2638
integer y = 172
integer width = 274
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "품번"
end type

event clicked;wf_init()
end event

type gb_1 from groupbox within w_sm90_0170
integer x = 2597
integer y = 8
integer width = 334
integer height = 248
integer taborder = 10
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
end type

type rr_1 from roundrectangle within w_sm90_0170
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 276
integer width = 4581
integer height = 2016
integer cornerheight = 40
integer cornerwidth = 55
end type

