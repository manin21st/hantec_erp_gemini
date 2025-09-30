$PBExportHeader$w_adt_00180.srw
$PBExportComments$ ===> Proforma Invoice
forward
global type w_adt_00180 from w_standard_print
end type
type p_1 from picture within w_adt_00180
end type
type pb_1 from u_pb_cal within w_adt_00180
end type
type pb_2 from u_pb_cal within w_adt_00180
end type
type rr_3 from roundrectangle within w_adt_00180
end type
end forward

global type w_adt_00180 from w_standard_print
integer height = 2432
string title = "OFFER SHEET"
p_1 p_1
pb_1 pb_1
pb_2 pb_2
rr_3 rr_3
end type
global w_adt_00180 w_adt_00180

type prototypes
FUNCTION UInt FindWindowA( Ulong className, string winName )  LIBRARY "user32.dll" alias for "FindWindowA;Ansi"
FUNCTION UInt SetFocus( int winHand )  LIBRARY "user32.dll"
end prototypes

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String  ssdate, sedate, sstore, schk, scvcod, semp_id

If dw_ip.AcceptText() <> 1 Then Return -1

ssdate   = Trim(dw_ip.GetItemString(1,"fdate"))
sedate   = Trim(dw_ip.GetItemString(1,"tdate"))
sstore   = Trim(dw_ip.GetItemString(1,"depot"))
schk     = Trim(dw_ip.GetItemString(1,"outchk"))
scvcod   = Trim(dw_ip.GetItemString(1,"cvcod"))

IF scvcod = "" OR IsNull(scvcod) THEN scvcod = '%'

IF ssdate = "" OR IsNull(ssdate) THEN
	f_message_chk(30,'[의뢰일자(시작)]')
	dw_ip.SetColumn("fdate")
	dw_ip.SetFocus()
	Return -1
END IF

IF sedate = "" OR IsNull(sedate) THEN
	f_message_chk(30,'[의뢰일자(종료)]')
	dw_ip.SetColumn("tdate")
	dw_ip.SetFocus()
	Return -1
END IF

IF IsNull(sstore) Or sstore = '' THEN
	f_message_chk(30,'[창고]')
	dw_ip.SetColumn("depot")
	dw_ip.SetFocus()
	Return -1
END IF

IF schk = "" OR IsNull(schk) THEN
	f_message_chk(30,'[구분]')
	dw_ip.SetColumn("outchk")
	dw_ip.SetFocus()
	Return -1
END IF

dw_list.SetRedraw(False)

If schk = '0' Then
	dw_list.DataObject = 'd_adt_00180_1'
	dw_list.SetTransObject(SQLCA)	
else
	dw_list.DataObject = 'd_adt_00180_2'
	dw_list.SetTransObject(SQLCA)	
end if	

IF dw_list.Retrieve(gs_sabu, gs_saupj, sstore, scvcod, ssdate, sedate) < 1 THEN
	f_message_chk(300,'')
	dw_list.Reset()
	dw_ip.setfocus()
	dw_ip.setcolumn('fdate')
	return -1
end if

dw_list.SetRedraw(True)

Return 1
end function

on w_adt_00180.create
int iCurrent
call super::create
this.p_1=create p_1
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_1
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.pb_2
this.Control[iCurrent+4]=this.rr_3
end on

on w_adt_00180.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.p_1)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_3)
end on

event open;Integer  li_idx

li_idx = w_mdi_frame.dw_listbar.InsertRow(0)
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_id',Upper(This.ClassName()))
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_name',Upper(This.Title))
w_mdi_frame.Postevent("ue_barrefresh")

is_today = f_today()
is_totime = f_totime()
is_window_id = this.ClassName()

w_mdi_frame.st_window.Text = Upper(is_window_id)

SELECT "SUB2_T"."OPEN_HISTORY", "SUB2_T"."UPMU"  
  INTO :is_usegub,  :is_upmu 
  FROM "SUB2_T"  
 WHERE "SUB2_T"."WINDOW_NAME" = :is_window_id  ;

IF is_usegub = 'Y' THEN
   INSERT INTO "PGM_HISTORY"  
	 		 ( "L_USERID",   "CDATE",       "STIME",      "WINDOW_NAME",   "EDATE",   
			   "ETIME",      "IPADD",       "USER_NAME" )  
   VALUES ( :gs_userid,   :is_today,     :is_totime,   :is_window_id,   NULL, 
	   		NULL,         :gs_ipaddress, :gs_comname )  ;

   IF SQLCA.SQLCODE = 0 THEN 
	   COMMIT;
   ELSE 	  
	   ROLLBACK;
   END IF	  
END IF	  

f_child_saupj(dw_ip, 'depot', gs_saupj)

dw_ip.SetTransObject(SQLCA)
dw_ip.Reset()
dw_ip.InsertRow(0)

dw_list.settransobject(sqlca)
dw_print.settransobject(sqlca)

dw_ip.SetItem(1, 'fdate',is_today)
dw_ip.SetItem(1, 'tdate',is_today)
dw_ip.SetItem(1, 'saupj',gs_saupj)

dw_print.object.datawindow.print.preview = "yes"	

w_mdi_frame.sle_msg.text = "출력조건을 입력하고 조회버턴을 누르세요"
end event

type p_preview from w_standard_print`p_preview within w_adt_00180
boolean visible = false
integer x = 3899
end type

type p_exit from w_standard_print`p_exit within w_adt_00180
end type

type p_print from w_standard_print`p_print within w_adt_00180
end type

event p_print::clicked;String sHoldNo, sSaupj, scvcod, sgbn
Long   llRow

dw_list.AcceptText()

If dw_list.RowCount() <= 0 Then Return

llRow = dw_list.GetRow()

sSaupj = dw_ip.GetItemString(1, 'saupj')
sgbn = dw_ip.GetItemString(1, 'outchk')
scvcod = dw_list.GetItemString(llRow, 'req_dept')
sHoldNo = dw_list.GetItemString(llRow, 'hold_no')

If dw_print.Retrieve(gs_sabu, sSaupj, sHoldNo + '%', scvcod, sgbn) <= 0 Then Return

OpenWithParm(w_print_preview, dw_print)	
end event

type p_retrieve from w_standard_print`p_retrieve within w_adt_00180
integer x = 4096
end type







type st_10 from w_standard_print`st_10 within w_adt_00180
end type



type dw_print from w_standard_print`dw_print within w_adt_00180
integer x = 3557
integer y = 44
string dataobject = "d_adt_00180_3"
end type

type dw_ip from w_standard_print`dw_ip within w_adt_00180
integer x = 46
integer y = 36
integer width = 2990
integer height = 244
string dataobject = "d_adt_00180_5"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;call super::itemchanged;String sSaupj, scvcod, scvnas, snull, sarea, steam, sname1

Choose Case GetColumnName() 
	 /* 거래처 */
	Case "cvcod"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"codenm",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod', sNull)
			SetItem(1, 'codenm', snull)
			Return 1
		ELSE		
			SetItem(1,"cvcod",  		sCvcod)
			SetItem(1,"codenm",		scvnas)
		END IF
	/* 거래처명 */
	Case "cvcodnm"
		scvnas = Trim(GetText())
		IF scvnas ="" OR IsNull(scvnas) THEN
			SetItem(1,"cvcod",snull)
			Return
		END IF
		
		If f_get_cvnames('2', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod', sNull)
			SetItem(1, 'codenm', snull)
			Return 1
		ELSE		
			SetItem(1,"cvcod",  		sCvcod)
			SetItem(1,"codenm",		scvnas)
		END IF
	/* 출고의뢰/승인 */
	Case "outchk"
		dw_list.reset()
		dw_print.reset()
	/* 창고설정 */
	Case 'saupj'
		sSaupj = Trim(GetText())
		
		f_child_saupj(dw_ip,'depot', sSaupj)
END Choose

end event

event dw_ip::itemfocuschanged;call super::itemfocuschanged;IF this.GetColumnName() = "custname" THEN
	f_toggle_kor(Handle(this))
ELSE
	f_toggle_eng(Handle(this))
END IF
end event

event dw_ip::rbuttondown;call super::rbuttondown;String sIoCustName, sIocustarea, sdept

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case GetcolumnName() 
	Case "cvcod", "cvcodnm"
		gs_gubun = '1'
		If GetColumnName() = "cvcodnm" then
			gs_codename = Trim(GetText())
		End If
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cvcod",gs_code)
		SetColumn("cvcod")
		TriggerEvent(ItemChanged!)
END Choose
end event

type dw_list from w_standard_print`dw_list within w_adt_00180
integer x = 55
integer y = 292
integer width = 4544
integer height = 1964
string dataobject = "d_adt_00180_1"
boolean border = false
end type

type p_1 from picture within w_adt_00180
event ue_buttondn pbm_lbuttondown
event ue_buttonup pbm_lbuttonup
boolean visible = false
integer x = 3712
integer y = 24
integer width = 178
integer height = 144
boolean bringtotop = true
string picturename = "C:\erpman\image\엑셀변환_up.gif"
boolean focusrectangle = false
end type

event ue_buttondn;////
picturename = 'C:\erpman\image\엑셀변환_dn.gif'
end event

event ue_buttonup;//
picturename = 'C:\erpman\image\엑셀변환_up.gif'
end event

event clicked;OleObject     		myOleObject
int           		i_Result,rc, ll_i
String        		excel_title
UInt          		excel_handle
Datawindowchild 	idwc_header, 					idwc_body, 						idwc_footer
string 		 		ls_vndmst_cvnas,				ls_exppih_pidate			
string 	ls_exppih_pono,		ls_exppih_origin,	ls_exppih_packing,ls_exppih_caseinfo,	ls_exppih_deliterms,	ls_exppih_shipment
String   ls_exppih_validity,	ls_exppih_inspection,	ls_exppih_pimaker,	ls_payment
string   ls_rownum,		ls_hs_number,		ls_commodity,					ls_Quantity,		ls_unit_price,		ls_amount, 		ls_chargu, 	ls_exppich_charamt
String   ls_pino

Setpointer(HourGlass!)

dw_list.GetChild( 'dw_3', idwc_header )
dw_list.GetChild( 'dw_2', idwc_body )
dw_list.GetChild( 'dw_1', idwc_footer )

if idwc_header.rowcount() < 1 then 
	Messagebox('확인','조회 후 엑셀변환이 가능합니다')
	return 
End if 

if idwc_body.rowcount()  < 1 then 
	Messagebox('확인','내역이 존재하지 않습니다')
	return 
End if 


myOleObject = Create OleObject //ole 오브젝트 생성

i_Result = myOleObject.ConnectToNewObject( "excel.application" )
// 엑셀에 연결
excel_title = myOleObject.Application.Caption

myOleObject.Application.Visible = False

excel_handle = FindWindowA( 0, excel_title )

SetFocus( excel_handle )

myOleObject.WorkBooks.Open("c:\erpman\doc\offersheet.xls")
// c:\mmm.xls 을 불러온다.
myOleObject.WindowState = 1 
// 엑셀윈도우의 상태 지정 1-normal, 2-min, 3-max


//==[header]
ls_vndmst_cvnas		= idwc_header.getitemstring(1, 'vndmst_cvnas')
ls_exppih_pidate		= idwc_header.getitemstring(1, 'exppih_pidate')
ls_exppih_pono			= idwc_header.getitemstring(1, 'exppih_pono')
ls_exppih_origin		= idwc_header.getitemstring(1, 'exppih_origin')										
ls_exppih_packing		= idwc_header.getitemstring(1, 'exppih_packing'	)									
ls_exppih_caseinfo	= idwc_header.getitemstring(1, 'exppih_caseinfo')											
ls_exppih_deliterms	= idwc_header.getitemstring(1, 'exppih_deliterms')											
ls_exppih_shipment	= idwc_header.getitemstring(1, 'exppih_shipment')											
ls_exppih_validity	= idwc_header.getitemstring(1, 'exppih_validity')											
ls_exppih_inspection	= idwc_header.getitemstring(1, 'exppih_inspection')											
ls_exppih_pimaker		= idwc_header.getitemstring(1, 'exppih_pimaker')										
ls_payment				= idwc_header.getitemstring(1, 'payment')								

//-----------------------------------------------------------------------------

myOleobject.application.workbooks(1).worksheets(1).Range( "F10" ).Value = ls_vndmst_cvnas
myOleobject.application.workbooks(1).worksheets(1).Range( "O10" ).Value = ls_exppih_pidate			
myOleobject.application.workbooks(1).worksheets(1).Range( "O11" ).Value = ls_exppih_pono			
myOleobject.application.workbooks(1).worksheets(1).Range( "F18" ).Value = ls_exppih_origin
myOleobject.application.workbooks(1).worksheets(1).Range( "F19" ).Value = ls_exppih_packing
myOleobject.application.workbooks(1).worksheets(1).Range( "F20" ).Value = ls_exppih_caseinfo
myOleobject.application.workbooks(1).worksheets(1).Range( "F21" ).Value = ls_exppih_deliterms												
myOleobject.application.workbooks(1).worksheets(1).Range( "F22" ).Value = ls_exppih_shipment
myOleobject.application.workbooks(1).worksheets(1).Range( "F23" ).Value = ls_exppih_validity
myOleobject.application.workbooks(1).worksheets(1).Range( "F24" ).Value = ls_exppih_inspection
myOleobject.application.workbooks(1).worksheets(1).Range( "F25" ).Value = ls_exppih_pimaker
myOleobject.application.workbooks(1).worksheets(1).Range( "F26" ).Value = ls_payment


//==[body]
String ls_b, ls_d, ls_f, ls_k, ls_m, ls_o, ls_q
For ll_i = 1 to idwc_body.rowcount() 
	ls_rownum		= idwc_body.getitemstring ( ll_i, 'rownum') 
	ls_hs_number	= idwc_body.getitemstring ( ll_i, 'hs_number') 	
	
	ls_commodity	= idwc_body.getitemstring ( ll_i, 'commodity') 	
	ls_Quantity		= idwc_body.getitemstring ( ll_i, 'Quantity') 	
	ls_unit_price	= idwc_body.getitemstring ( ll_i, 'unit_price') 	
	ls_amount		= idwc_body.getitemstring ( ll_i, 'amount') 	
	ls_payment		= idwc_body.getitemstring ( ll_i, 'payment') 	
	
	//셀위치정보
	ls_b	= "B" + string(ll_i + 29) 
	ls_d  = "D" + string(ll_i + 29) 
	ls_f  = "F" + string(ll_i + 29) 
	ls_k  = "K" + string(ll_i + 29) 
	ls_m  = "M" + string(ll_i + 29) 
	ls_o  = "O" + string(ll_i + 29) 
	ls_q  = "Q" + string(ll_i + 29) 

	myOleobject.application.workbooks(1).worksheets(1).Range( ls_b ).Value = ls_ROWNUM
	myOleobject.application.workbooks(1).worksheets(1).Range( ls_D ).Value = ls_HS_NUMBER			
	myOleobject.application.workbooks(1).worksheets(1).Range( ls_F ).Value = ls_COMMODITY			
	myOleobject.application.workbooks(1).worksheets(1).Range( ls_K ).Value = ls_QUANTITY
	myOleobject.application.workbooks(1).worksheets(1).Range( ls_M ).Value = ls_UNIT_PRICE
	myOleobject.application.workbooks(1).worksheets(1).Range( ls_O ).Value = ls_AMOUNT
	myOleobject.application.workbooks(1).worksheets(1).Range( ls_Q ).Value = ls_PAYMENT												

Next 


//==[Footer]
For ll_i = 1 to idwc_body.rowcount() 
	if ll_i = 1 then 
		ls_chargu		= idwc_footer.getitemstring ( ll_i, 'chrgu') 
		ls_exppich_charamt		= string(idwc_footer.getitemnumber ( ll_i, 'exppich_chramt') ) 
	else 
		ls_chargu = ls_chargu + ' / ' + idwc_footer.getitemstring ( ll_i, 'chrgu')
		ls_exppich_charamt		= ls_exppich_charamt + ' / ' + string(idwc_footer.getitemnumber ( ll_i, 'exppich_chramt') )
 	End if 

Next 

myOleobject.application.workbooks(1).worksheets(1).Range( 'K34' ).Value = ls_chargu
myOleobject.application.workbooks(1).worksheets(1).Range( 'O34' ).Value = ls_exppich_charamt			
myOleobject.application.workbooks(1).worksheets(1).Range( 'k35' ).Value =  idwc_footer.getitemstring (1, 'tot_qty')			
myOleobject.application.workbooks(1).worksheets(1).Range(' O35' ).Value =  idwc_footer.getitemstring (1, 'tot_amt')

//myoleobject.application.workbooks(1).Save() //엑셀저장
if IsNull(ls_exppih_pono) Or Trim(ls_exppih_pono) = '' Then
	ls_pino = dw_ip.GetItemString(1, 'pino')
	myoleobject.application.workbooks(1).SaveAs("c:\erpman\doc\" + ls_pino + ".xls")
Else
	myoleobject.application.workbooks(1).SaveAs("c:\erpman\doc\" + ls_exppih_pono + ".xls")
End If
myOleObject.Application.Visible = True

//mmm3.xls로 새이름으로 저장하는 방법

//다른 엑셀명령도 위처럼 사용가능하지 않을까 싶네요 (여러가지 해보지를 못해서..)

myoleobject.DisConnectObject() //연결종료
Destroy myoleobject //오브젝트 제거

end event

type pb_1 from u_pb_cal within w_adt_00180
integer x = 699
integer y = 60
integer taborder = 140
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('fdate')
IF Isnull(gs_code) THEN Return
dw_ip.SetItem(dw_ip.getrow(), 'fdate', gs_code)
end event

type pb_2 from u_pb_cal within w_adt_00180
integer x = 1115
integer y = 60
integer taborder = 150
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('tdate')
IF Isnull(gs_code) THEN Return
dw_ip.SetItem(dw_ip.getrow(), 'tdate', gs_code)
end event

type rr_3 from roundrectangle within w_adt_00180
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 280
integer width = 4562
integer height = 1992
integer cornerheight = 40
integer cornerwidth = 46
end type

