$PBExportHeader$w_sm40_0070_p.srw
$PBExportComments$단가소급현황
forward
global type w_sm40_0070_p from w_standard_print
end type
type pb_1 from u_pb_cal within w_sm40_0070_p
end type
type pb_2 from u_pb_cal within w_sm40_0070_p
end type
type rr_1 from roundrectangle within w_sm40_0070_p
end type
end forward

global type w_sm40_0070_p from w_standard_print
integer width = 4667
string title = "단가 소급 현황"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_sm40_0070_p w_sm40_0070_p

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();dw_ip.AcceptText()

Long   row

row = dw_ip.GetRow()
If row < 1 Then Return -1

String ls_saupj

ls_saupj = dw_ip.GetItemString(row, 'saupj')
If Trim(ls_saupj) = '' OR IsNull(ls_saupj) Then ls_saupj = '10'

String ls_st

ls_st = dw_ip.GetItemString(row, 'sdatef')
If Trim(ls_st) = '' OR IsNull(ls_st) Then
	ls_st = '19000101'
Else
	If IsDate(LEFT(ls_st, 4) + '.' + MID(ls_st, 5, 2) + '.' + RIGHT(ls_st, 2)) = False Then
		MessageBox('일자형식 확인', '일자 형식이 잘못 되었습니다.')
		dw_ip.SetColumn('sdatef')
		dw_ip.SetFocus()
		Return -1
	End If
End If

String ls_ed

ls_ed = dw_ip.GetItemString(row, 'sdatet')
If Trim(ls_ed) = '' OR IsNull(ls_ed) Then
	ls_st = '29991231'
Else
	If IsDate(LEFT(ls_ed, 4) + '.' + MID(ls_ed, 5, 2) + '.' + RIGHT(ls_ed, 2)) = False Then
		MessageBox('일자형식 확인', '일자 형식이 잘못 되었습니다.')
		dw_ip.SetColumn('sdatet')
		dw_ip.SetFocus()
		Return -1
	End If
End If

String ls_fac

ls_fac = dw_ip.GetItemString(row, 'factory')
If Trim(ls_fac) = '' OR IsNull(ls_fac) Then ls_fac = '%'

String ls_ittyp

ls_ittyp = dw_ip.GetItemString(row, 'ittyp')
If Trim(ls_ittyp) = '' OR IsNull(ls_ittyp) Then ls_ittyp = '%'

String ls_itnbr

ls_itnbr = dw_ip.GetItemString(row, 'itnbr')
If Trim(ls_itnbr) = '' OR IsNull(ls_itnbr) Then ls_itnbr = '%'

String ls_cvcod

ls_cvcod = dw_ip.GetItemString(row, 'cvcod')
If Trim(ls_cvcod) = '' OR IsNull(ls_cvcod) Then ls_cvcod = '%'

dw_list.SetRedraw(False)
dw_list.Retrieve(ls_saupj, ls_st, ls_ed, ls_ittyp, ls_itnbr, ls_fac, ls_cvcod)
dw_list.SetRedraw(True)

If dw_list.RowCount() < 1 Then 
	MessageBox('조회내용 확인', '조회된 내역이 없습니다.')
	Return -1
End If

dw_list.ShareData(dw_print)

Return 1
//String sDatef, sDatet,ssaupj
//String sIttyp, sItcls, sItnbr, tx_name, sPspec,sPrtgbn , sGubun ,ls_emp_id
//
//String ls_depot , ls_factory , ls_cvcod , ls_yebi1
//
//If dw_ip.AcceptText() <> 1 Then Return -1
//
//ssaupj      = dw_ip.getitemstring(1,"saupj")
//sDatef      = Trim(dw_ip.GetItemString(1,"sdatef"))
//sDatet      = Trim(dw_ip.GetItemString(1,"sdatet"))
////ls_emp_id   = dw_ip.getitemstring(1,'emp_id')
//sIttyp      = Trim(dw_ip.GetItemString(1,"ittyp"))
//
//sItnbr      = Trim(dw_ip.GetItemString(1,"itnbr"))
////sPrtgbn     = Trim(dw_ip.GetItemString(1,"prtgbn"))
//
//ls_depot   = Trim(dw_ip.object.depot_no[1])
//ls_factory = Trim(dw_ip.object.factory[1])
//ls_cvcod   = Trim(dw_ip.object.cvcod[1])
//
//sPrtgbn   = Trim(dw_ip.object.prtgbn[1])
//ls_yebi1  = Trim(dw_ip.object.yebi1[1])
//
//IF sDatef = "" OR IsNull(sDatef) or sDatet = "" OR IsNull(sDatet) THEN
//	f_message_chk(30,'[기간]')
//	dw_ip.SetColumn("sdatef")
//	dw_ip.SetFocus()
//	Return -1
//END IF
//
//If IsNull(sSaupj) Or sSaupj = '' Then
//	f_message_chk(1400,'[사업장]')
//	dw_ip.SetFocus()
//	Return -1
//End If
//
//If Isnull(sIttyp) or sIttyp = '' Then sIttyp = '%'
//If Isnull(sItnbr) or sItnbr = '' Then 
//	sItnbr = '%'
//else
//	sItnbr = sItnbr + '%'
//end If
//
//if isnull(ls_emp_id) or ls_emp_id = '' then ls_emp_id ='%'
//
//if isnull(ls_depot) or ls_depot = '' then ls_depot ='%'
//if isnull(ls_factory) or ls_factory = '' or ls_factory = '.' then ls_factory ='%'
//if isnull(ls_cvcod) or ls_cvcod = '' then ls_cvcod ='%'
//
//
//IF dw_print.Retrieve(ssaupj ,sdatef, sdatet,ls_emp_id ,sIttyp ,sItnbr , ls_depot , ls_factory , ls_cvcod ) <= 0 THEN
//	f_message_chk(50, '')
//	dw_list.Reset()
//	dw_ip.setcolumn('sdatef')
//	dw_ip.SetFocus()
//	Return -1
//END IF
//
//
////tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(ittyp) ', 1)"))
////If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
////dw_print.Modify("tx_ittyp.text = '"+tx_name+"'")
////
////tx_name = Trim(dw_ip.GetitemString(1,'itclsnm'))
////If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
////dw_print.Modify("tx_itcls.text = '"+tx_name+"'")
////
////tx_name = Trim(dw_ip.GetitemString(1,'itdsc'))
////If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
////dw_print.Modify("tx_itnbr.text = '"+tx_name+"'")
////
////tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(prtgbn) ', 1)"))
////If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
////dw_print.Modify("tx_gubun.text = '"+tx_name+"'")
////
////tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(saupj) ', 1)"))
////If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
////dw_print.Modify("tx_saupj.text = '"+tx_name+"'")
////
////tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(emp_id) ', 1)"))
////If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
////dw_print.Modify("tx_emp_id.text = '"+tx_name+"'")
//
//Return 1
end function

on w_sm40_0070_p.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.rr_1
end on

on w_sm40_0070_p.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event open;call super::open;
dw_ip.reset() 
dw_ip.insertrow(0) 

dw_ip.SetItem(1,"sdatef", left(is_today,6)+'01' )
dw_ip.SetItem(1,"sdatet", is_today )
dw_ip.Setfocus()

/* User별 사업장 Setting Start */
setnull(gs_code)
If f_check_saupj() = 1 Then
	dw_ip.SetItem(1, 'saupj', gs_code)
   if gs_code <> '%' then
   	dw_ip.Modify("saupj.protect=1")
		dw_ip.Modify("saupj.background.color = 80859087")
   End if
End If
/* ---------------------- End  */
end event

type p_xls from w_standard_print`p_xls within w_sm40_0070_p
boolean visible = true
integer x = 4096
integer y = 24
string picturename = "C:\erpman\image\엑셀변환_d.gif"
end type

type p_sort from w_standard_print`p_sort within w_sm40_0070_p
boolean visible = true
integer x = 4270
integer y = 24
boolean originalsize = false
end type

type p_preview from w_standard_print`p_preview within w_sm40_0070_p
integer x = 3922
end type

type p_exit from w_standard_print`p_exit within w_sm40_0070_p
end type

type p_print from w_standard_print`p_print within w_sm40_0070_p
boolean visible = false
integer x = 5088
integer y = 44
end type

type p_retrieve from w_standard_print`p_retrieve within w_sm40_0070_p
integer x = 3749
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
	p_xls.Enabled =False
	p_xls.PictureName = 'C:\erpman\image\엑셀변환_d.gif'

	p_preview.enabled = False
	p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
	SetPointer(Arrow!)
	Return
Else
	p_xls.Enabled =True
	p_xls.PictureName =  'C:\erpman\image\엑셀변환_up.gif'
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







type st_10 from w_standard_print`st_10 within w_sm40_0070_p
end type



type dw_print from w_standard_print`dw_print within w_sm40_0070_p
integer x = 3721
integer y = 176
string dataobject = "d_sm40_00070_p_32"
end type

type dw_ip from w_standard_print`dw_ip within w_sm40_0070_p
integer x = 32
integer width = 3630
integer height = 228
string dataobject = "d_sm40_00070_p_1"
end type

event dw_ip::itemchanged;call super::itemchanged;
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
END Choose
end event

event dw_ip::rbuttondown;call super::rbuttondown;SetNull(gs_code)
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

event dw_ip::itemerror;call super::itemerror;
Return 1
end event

type dw_list from w_standard_print`dw_list within w_sm40_0070_p
integer y = 276
integer width = 4558
integer height = 1956
string dataobject = "d_sm40_00070_p_2"
boolean border = false
end type

type pb_1 from u_pb_cal within w_sm40_0070_p
integer x = 1801
integer y = 40
integer height = 76
integer taborder = 110
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('sdatef')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'sdatef', gs_code)

end event

type pb_2 from u_pb_cal within w_sm40_0070_p
integer x = 2277
integer y = 40
integer height = 76
integer taborder = 120
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('sdatet')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'sdatet', gs_code)

end event

type rr_1 from roundrectangle within w_sm40_0070_p
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 23
integer y = 268
integer width = 4585
integer height = 1972
integer cornerheight = 40
integer cornerwidth = 55
end type

