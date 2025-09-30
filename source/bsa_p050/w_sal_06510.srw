$PBExportHeader$w_sal_06510.srw
$PBExportComments$ ===> Proforma Invoice
forward
global type w_sal_06510 from w_standard_print
end type
type p_1 from picture within w_sal_06510
end type
type rr_1 from roundrectangle within w_sal_06510
end type
type rr_3 from roundrectangle within w_sal_06510
end type
end forward

global type w_sal_06510 from w_standard_print
string title = "Proforma Invoice"
p_1 p_1
rr_1 rr_1
rr_3 rr_3
end type
global w_sal_06510 w_sal_06510

type prototypes
FUNCTION UInt FindWindowA( Ulong className, string winName )  LIBRARY "user32.dll" alias for "FindWindowA;Ansi"
FUNCTION UInt SetFocus( int winHand )  LIBRARY "user32.dll"
end prototypes

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sPino

If dw_ip.AcceptText() <> 1 Then Return -1

sPINO = Trim(dw_ip.GetItemString(1,'pino'))

if	(sPINO = '') or isNull(sPINO) then
	f_message_Chk(30, '[P/I No 입력 확인]')
	dw_ip.setcolumn('pino')
	dw_ip.setfocus()
	Return -1
end if

if dw_list.Retrieve(gs_sabu, sPINO) < 1 then
   f_message_Chk(300, '[출력조건 CHECK]')
  	dw_ip.setcolumn('pino')
	dw_ip.setfocus()
  	return -1
end if

return 1
end function

on w_sal_06510.create
int iCurrent
call super::create
this.p_1=create p_1
this.rr_1=create rr_1
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_1
this.Control[iCurrent+2]=this.rr_1
this.Control[iCurrent+3]=this.rr_3
end on

on w_sal_06510.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.p_1)
destroy(this.rr_1)
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

dw_ip.SetTransObject(SQLCA)
dw_ip.Reset()
dw_ip.InsertRow(0)

dw_list.settransobject(sqlca)
dw_print.settransobject(sqlca)

IF is_upmu = 'A' THEN //회계인 경우
   int iRtnVal 

	IF Upper(Mid(is_window_id,4,2)) = 'BG' THEN							   /*예산*/
		IF F_Valid_EmpNo(Gs_EmpNo) = 'N' THEN							/*권한 체크- 현업 여부*/
			dw_ip.SetItem(dw_ip.GetRow(),"saupj",   Gs_Saupj)
			
			dw_ip.Modify("saupj.protect = 1")
		ELSE
			dw_ip.Modify("saupj.protect = 0")
		END IF
	ELSE
		IF Upper(Mid(is_window_id,4,2)) = 'FI' THEN							/*자금*/
			iRtnVal = F_Authority_Fund_Chk(Gs_Dept)	
		ELSE
			iRtnVal = F_Authority_Chk(Gs_Dept)
		END IF
		IF iRtnVal = -1 THEN							/*권한 체크- 현업 여부*/
			dw_ip.SetItem(dw_ip.GetRow(),"saupj",   Gs_Saupj)
			
			dw_ip.Modify("saupj.protect = 1")
		ELSE
			dw_ip.Modify("saupj.protect = 0")
		END IF	
	END IF
END IF
dw_print.object.datawindow.print.preview = "yes"	

//dw_print.ShareData(dw_list)

w_mdi_frame.sle_msg.text = "출력조건을 입력하고 조회버턴을 누르세요"
end event

type p_preview from w_standard_print`p_preview within w_sal_06510
boolean visible = false
integer x = 3899
end type

type p_exit from w_standard_print`p_exit within w_sal_06510
end type

type p_print from w_standard_print`p_print within w_sal_06510
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_06510
integer x = 4096
boolean originalsize = true
end type







type st_10 from w_standard_print`st_10 within w_sal_06510
end type



type dw_print from w_standard_print`dw_print within w_sal_06510
string dataobject = "d_sal_06510_11"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_06510
integer x = 82
integer y = 72
integer height = 184
string dataobject = "d_sal_06510_01"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;String sCol_Name

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

sCol_Name = GetColumnName()

Choose Case sCol_Name
	Case "pino"
//      gs_code = Trim(this.GetText())
		gs_code = 'ALL'
		Open(w_exppih_popup)
		this.SetItem(1, 'pino', gs_code)
End Choose

//cb_update.SetFocus()

end event

type dw_list from w_standard_print`dw_list within w_sal_06510
integer x = 55
integer y = 304
integer width = 4544
integer height = 1988
string dataobject = "d_sal_06510_11"
boolean border = false
end type

type p_1 from picture within w_sal_06510
event ue_buttondn pbm_lbuttondown
event ue_buttonup pbm_lbuttonup
boolean visible = false
integer x = 2030
integer y = 60
integer width = 178
integer height = 144
boolean bringtotop = true
boolean originalsize = true
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

type rr_1 from roundrectangle within w_sal_06510
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 46
integer y = 52
integer width = 1422
integer height = 228
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_3 from roundrectangle within w_sal_06510
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 300
integer width = 4562
integer height = 2028
integer cornerheight = 40
integer cornerwidth = 46
end type

