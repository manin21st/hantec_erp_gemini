$PBExportHeader$w_sal_06570.srw
$PBExportComments$ ===> Commercial Invoice
forward
global type w_sal_06570 from w_standard_print
end type
type dw_excel from datawindow within w_sal_06570
end type
type dw_1 from datawindow within w_sal_06570
end type
type dw_2 from datawindow within w_sal_06570
end type
type p_excel from uo_picture within w_sal_06570
end type
type p_co from uo_picture within w_sal_06570
end type
type p_1 from uo_picture within w_sal_06570
end type
type p_2 from picture within w_sal_06570
end type
type rr_1 from roundrectangle within w_sal_06570
end type
end forward

global type w_sal_06570 from w_standard_print
string title = "Commercial Invoice"
string menuname = ""
dw_excel dw_excel
dw_1 dw_1
dw_2 dw_2
p_excel p_excel
p_co p_co
p_1 p_1
p_2 p_2
rr_1 rr_1
end type
global w_sal_06570 w_sal_06570

type prototypes
FUNCTION Uint GetModuleHandleA ( String ModuleName )   LIBRARY "KERNEL32.DLL" alias for "GetModuleHandleA;Ansi" 
FUNCTION boolean CopyFileA(ref string cfrom, ref string cto, boolean flag) LIBRARY   "Kernel32.dll" alias for "CopyFileA;Ansi"
FUNCTION boolean DeleteFileA(ref string filename) LIBRARY "Kernel32.dll" alias for "DeleteFileA;Ansi"
FUNCTION UInt FindWindowA( Ulong className, string winName )  LIBRARY "user32.dll" alias for "FindWindowA;Ansi"
FUNCTION UInt SetFocus( int winHand )  LIBRARY "user32.dll"

end prototypes

forward prototypes
public function integer wf_sep (ref string source, ref string target)
public function integer wf_retrieve ()
end prototypes

public function integer wf_sep (ref string source, ref string target);int Pos

Pos = Pos(source,'~r~n')
If Pos > 0 Then
	target = Left(source,Pos -1)
	source = Mid(source,Pos + 2)
Else
	target = source
	source = ''
End If

Return 0
end function

public function integer wf_retrieve ();String  s_cino, sCINO, sShipMark, sCurr ,ls_gubun, sGbn1, sGbn2, sGbn3
long    lrow, lctqty, ladd_row, i

If dw_ip.AcceptText() <> 1 Then Return -1

ls_gubun = dw_ip.getitemstring(1,'gubun')

sCINO  = Trim(dw_ip.GetItemString(1,'cino'))
sGbn1	 = Trim(dw_ip.GetItemString(1,'gbn1'))
sGbn2  = Trim(dw_ip.GetItemString(1,'gbn2'))
sGbn3  = Trim(dw_ip.GetItemString(1,'gbn3'))

if	(sCINO = '') or isNull(sCINO) then
	f_message_Chk(30, '[C/I No 입력확인]')
	dw_ip.setcolumn('cino')
	dw_ip.setfocus()
	Return -1
end if

// Shipping Mark 추출하여 argument로 넘김
Select cino, shipmark, ctqty, fun_get_reffpf('10', curr)
Into   :s_cino, :sShipMark, :lctqty, :sCurr
From   expcih  
Where  sabu = :gs_sabu and cino = :sCINO;

if isNull(s_cino) or s_cino = '' then
	f_message_Chk(300, '[출력조건 CHECK]')
  	dw_ip.setcolumn('cino')
	dw_ip.setfocus()
  	return -1
end if

if isNull(sShipMark) then
	sShipMark = ''
end if

if isNull(lctqty) then
	lctqty = 0
end if

if dw_print.Retrieve(gs_sabu, scino, sshipmark, lctqty,ls_gubun,sCurr, sGbn2, sGbn3) < 1 then
	f_message_Chk(300, '[출력조건 CHECK]')
	dw_ip.setcolumn('d_from')
	dw_ip.setfocus()
	return -1
end if
//dw_print.Retrieve(gs_sabu, scino, sshipmark, lctqty,ls_gubun,sCurr, sGbn2)

/* 원산지증명서 발행 */
//lrow = dw_2.Retrieve(gs_sabu, sCINO, sShipMark, lctqty, sCurr)
//dw_1.retrieve(gs_sabu, sCINO, lctqty, sCurr, sShipMark)

//p_co.enabled= true
//p_co.PictureName = 'c:\erpman\image\co출력_up.gif'
//p_1.enabled = true
//p_1.PictureName = 'c:\erpman\image\gsp출력_up.gif'

return 1
end function

on w_sal_06570.create
int iCurrent
call super::create
this.dw_excel=create dw_excel
this.dw_1=create dw_1
this.dw_2=create dw_2
this.p_excel=create p_excel
this.p_co=create p_co
this.p_1=create p_1
this.p_2=create p_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_excel
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.dw_2
this.Control[iCurrent+4]=this.p_excel
this.Control[iCurrent+5]=this.p_co
this.Control[iCurrent+6]=this.p_1
this.Control[iCurrent+7]=this.p_2
this.Control[iCurrent+8]=this.rr_1
end on

on w_sal_06570.destroy
call super::destroy
destroy(this.dw_excel)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.p_excel)
destroy(this.p_co)
destroy(this.p_1)
destroy(this.p_2)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;w_mdi_frame.sle_msg.text = "출력조건을 입력하고 조회버턴을 누르세요"

dw_list.DataObject='d_sal_06570_a04'
dw_list.Object.report_detail.DataObject='d_sal_06570_a05'
dw_list.object.dw_2.dataobject='d_sal_06570_a08'
dw_list.settransobject(sqlca)

dw_1.settransobject(sqlca)
dw_2.settransobject(sqlca)
dw_excel.settransobject(sqlca)
end event

type p_preview from w_standard_print`p_preview within w_sal_06570
integer x = 4091
end type

type p_exit from w_standard_print`p_exit within w_sal_06570
integer taborder = 90
end type

type p_print from w_standard_print`p_print within w_sal_06570
integer x = 4265
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_06570
integer x = 3918
end type







type st_10 from w_standard_print`st_10 within w_sal_06570
end type



type dw_print from w_standard_print`dw_print within w_sal_06570
boolean visible = true
integer x = 59
integer y = 212
integer width = 4507
integer height = 2072
string dataobject = "d_sal_06570_a04"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

type dw_ip from w_standard_print`dw_ip within w_sal_06570
integer x = 37
integer y = 28
integer width = 3547
integer height = 160
string dataobject = "d_sal_06570_01"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case GetColumnName()
	Case "cino"
		gs_code = 'A'
		gs_gubun ='A'
		Open(w_expci_popup)
		If IsNull(gs_code) Or gs_code = '' Then Return
		
		SetItem(1, 'cino', gs_code)
End Choose

end event

event dw_ip::itemchanged;String sRtn

Choose Case GetColumnName()
	Case 'prtgb'

	// Ci/Packing 구분
	Case 'gubun'
		dw_print.Reset()
		
		dw_print.SetRedraw(False)
		If GetText() = '1' Then		// CI
			dw_print.DataObject='d_sal_06570_a04'
			If GetItemString(1, 'gbn1') = 'N' Then
				dw_print.Object.report_detail.DataObject='d_sal_06570_a05'
			Else
				dw_print.Object.report_detail.DataObject='d_sal_06570_a06'
			End If
			dw_print.object.dw_2.dataobject='d_sal_06570_a08'
	   ElseIf GetText() = '2' Then // PACKING
			dw_print.DataObject='d_sal_06570_a04'
			If GetItemString(1, 'gbn1') = 'N' Then
				dw_print.Object.report_detail.DataObject='d_sal_06570_a02'
			Else
				dw_print.Object.report_detail.DataObject='d_sal_06570_a07'
			End If
			dw_print.object.dw_2.dataobject='d_sal_06570_a03'
	   end if
		dw_print.SetTransObject(sqlca)
		dw_print.SetRedraw(True)
	// Ci/Packing 구분
	Case 'gbn1'
		dw_print.Reset()
		
		dw_print.SetRedraw(False)
		If GetItemString(1, 'gubun') = '1' Then		// CI
			dw_print.DataObject='d_sal_06570_a04'
			If GetTExt() = 'N' Then
				dw_print.Object.report_detail.DataObject='d_sal_06570_a05'
			Else
				dw_print.Object.report_detail.DataObject='d_sal_06570_a06'
			End If
			dw_print.object.dw_2.dataobject='d_sal_06570_a08'
	   ElseIf GetItemString(1, 'gubun') = '2' Then // PACKING
			dw_print.DataObject='d_sal_06570_a04'
			If GetTExt() = 'N' Then
				dw_print.Object.report_detail.DataObject='d_sal_06570_a02'
			Else
				dw_print.Object.report_detail.DataObject='d_sal_06570_a07'
			End If
			dw_print.object.dw_2.dataobject='d_sal_06570_a03'
	   end if
		dw_print.SetTransObject(sqlca)
		dw_print.SetRedraw(True)
End Choose
end event

type dw_list from w_standard_print`dw_list within w_sal_06570
boolean visible = false
integer x = 3168
integer y = 8
integer width = 128
integer height = 116
string dataobject = "d_sal_06570_a04"
boolean border = false
end type

type dw_excel from datawindow within w_sal_06570
boolean visible = false
integer x = 128
integer y = 2436
integer width = 3406
integer height = 360
integer taborder = 110
boolean bringtotop = true
string dataobject = "d_sal_06570_09"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_1 from datawindow within w_sal_06570
boolean visible = false
integer x = 2994
integer y = 92
integer width = 206
integer height = 108
integer taborder = 70
boolean bringtotop = true
string title = "GSP"
string dataobject = "d_sal_06570_b3"
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_2 from datawindow within w_sal_06570
boolean visible = false
integer x = 2985
integer y = 56
integer width = 201
integer height = 108
integer taborder = 80
boolean bringtotop = true
string title = "C/O"
string dataobject = "d_sal_06570_03"
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type p_excel from uo_picture within w_sal_06570
boolean visible = false
integer x = 3365
integer y = 24
integer width = 178
boolean bringtotop = true
boolean enabled = false
string picturename = "C:\erpman\image\excel_d.gif"
end type

event clicked;Long numcols, numrows, ctqty
integer value, row, ix
string source_file, target_file, source_name, target_name
String sTemp, excel_title
Double excel_status

OLEObject exl_app

SetPointer(HourGlass!)

value = GetFileOpenName("송장 원본을 선택하십시요", + source_file, source_name, "XLS", "Excel Files (*.XLS),*.XLS")
If value <> 1 Then Return

value = GetFileSaveName("저장할 파일을 지정하세요", + target_file, target_name, "XLS", "Excel Files (*.XLS),*.XLS")
If value <> 1 Then Return

If source_file = target_file Then
	MessageBox('확 인','원본과 동일합니다')
	Return
End If

/* 저장할 Invoice 를 생성한다 */
w_mdi_frame.sle_msg.text = target_file + ' 생성중...'
CopyFileA(source_file, target_file, False)

/* Header Select */
String arg_cino, seller,   consignee,  shipdat,  vf_from,  vf_to,  cino,	 cidate, &
		 explcno,  opndat,	  buyer, other_ref, term_deli_pay, vf, banklcno, shipmark , &
		 cinotes
		 
arg_cino = dw_ip.GetItemString(1,'cino')
If IsNull(arg_cino) Then Return 

Select A.seller,  A.consignee, to_char(to_date(A.shipdat,'yyyymmdd'),'Month DD, YYYY') as shipdat,
       A.vf_from, A.vf_to,     A.cino, 
		 to_char(to_date(A.cidate,'yyyymmdd'), 'Month DD, YYYY') as cidate, 
       A.explcno, to_char(to_date(B.opndat,'yyyymmdd'), 'Month DD, YYYY') as opndat, 
       A.buyer,   A.other_ref, A.term_deli_pay, A.vf, b.banklcno,
		 A.shipmark, A.cinotes, A.ctqty
  into :seller,   :consignee,  :shipdat,
       :vf_from,  :vf_to,      :cino,
		 :cidate,
		 :explcno, :opndat,
		 :buyer, :other_ref, :term_deli_pay, :vf, :banklcno, :shipmark, :cinotes, :ctqty
From   expcih A, explc B
Where  A.sabu = :gs_sabu and A.cino = :arg_cino and
       A.sabu = B.sabu(+) and A.explcno = B.explcno(+);
If sqlca.sqlcode <> 0 Then
	w_mdi_frame.sle_msg.Text = '저장할 Invoice가 없습니다'
	Return 0
End If

If dw_excel.Retrieve(gs_sabu, arg_cino) <= 0 Then
	w_mdi_frame.sle_msg.Text = '저장할 Invoice가 없습니다'
	Return 0
End If

w_mdi_frame.sle_msg.text ='Excel connecting...'
exl_app = Create OLEObject

excel_status = GetModuleHandleA ( 'excel.exe' )
If excel_status = 0 Then
	value = exl_app.ConnectToNewObject( "excel.application" )
Else
	value = exl_app.ConnectToObject("","excel.application" )
End If

If value <> 0 Then
	MessageBox("OLE Error", "Connect to Excel Failed !")
	w_mdi_frame.sle_msg.text = ''
	Return
End if
	

exl_app.workbooks.open(target_file)

excel_title = exl_app.Application.Caption

//exl_app.workbooks.add()
exl_app.application.Visible = true

exl_app.Application.windowstate = 3 //Excel창(1:Normal, 2:Minimize, 3:Maximize)

row = 3
Do While Len(seller) > 0
	wf_sep(seller,sTemp)
	exl_app.cells[ row, 1] = sTemp
	row += 1
Loop

row = 9
Do While Len(consignee) > 0
	wf_sep(consignee,sTemp)
	exl_app.cells[ row, 1] = sTemp
	row += 1
Loop

row = 22
Do While Len(shipmark) > 0
	wf_sep(shipmark,sTemp)
	exl_app.cells[ row, 1] = sTemp
	row += 1
Loop

row = 18
Do While Len(term_deli_pay) > 0
	wf_sep(term_deli_pay,sTemp)
	exl_app.cells[ row, 5] = sTemp
	row += 1
Loop

row = 22
Do While Len(cinotes) > 0
	wf_sep(cinotes,sTemp)
	exl_app.cells[ row, 3] = sTemp
	row += 1
Loop

exl_app.cells[16, 1] = shipdat
exl_app.cells[18, 3] = vf_from
exl_app.cells[19, 3] = vf_to
exl_app.cells[ 3, 5] = cino
exl_app.cells[ 3, 8] = cidate
exl_app.cells[ 6, 8] = opndat
exl_app.cells[ 9, 5] = buyer
exl_app.cells[13, 5] = other_ref
exl_app.cells[17, 3] = vf
exl_app.cells[ 6, 5] = banklcno

row = 25
For ix = 1 To dw_excel.RowCount()
	exl_app.cells[ row, 3] = dw_excel.GetItemString(ix,'itdsc')
	exl_app.cells[ row, 5] = dw_excel.GetItemString(ix,'ispec')
	exl_app.cells[ row, 6] = dw_excel.GetItemString(ix,'titnm')
	exl_app.cells[ row, 7] = dw_excel.GetItemNumber(ix,'ciqty')
	exl_app.cells[ row, 8] = dw_excel.GetItemNumber(ix,'ciprc')
	exl_app.cells[ row, 9] = dw_excel.GetItemNumber(ix,'ciamt')
	
	row += 1
Next

/* Carton qty */
exl_app.cells[ row, 3] = 'TOTAL : '+string(ctqty) +'CTNS'

row += 2
exl_app.cells[ row, 3] = 'Handling Charge'
exl_app.cells[ row, 9] = dw_excel.GetItemNumber(dw_excel.RowCount(),'handling')

row += 1
exl_app.cells[ row, 3] = 'Freight Charge'
exl_app.cells[ row, 9] = dw_excel.GetItemNumber(dw_excel.RowCount(),'freight')

row += 1
exl_app.cells[ row, 3] = 'Insurance Charge'
exl_app.cells[ row, 9] = dw_excel.GetItemNumber(dw_excel.RowCount(),'Insurance')

exl_app.Application.workSheets(1).Columns(1).ColumnWidth = 8
exl_app.Application.workSheets(1).Columns(2).ColumnWidth = 8

exl_app.Application.quit()

exl_app.DisConnectObject()

Destroy exl_app 

w_mdi_frame.sle_msg.text ='Completed!'
//exl_app.Application.workSheets(1).Range("C1:AZ1").ColumnWidth = 30
//exl_app.Application.workSheets(1).Rows(1).Font.Size = 14
//exl_app.Application.workSheets(1).Rows(1).Font.Bold = True

end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\excel_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\excel_dn.gif'
end event

type p_co from uo_picture within w_sal_06570
boolean visible = false
integer x = 2487
integer y = 36
integer width = 178
boolean bringtotop = true
boolean enabled = false
string picturename = "C:\erpman\image\co출력_d.gif"
end type

event clicked;gi_page = dw_2.GetItemNumber(1,"last_page")
OpenWithParm(w_print_options, dw_2)


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\co출력_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\co출력_up.gif'
end event

type p_1 from uo_picture within w_sal_06570
boolean visible = false
integer x = 2661
integer y = 36
integer width = 178
boolean bringtotop = true
boolean enabled = false
string picturename = "C:\erpman\image\gsp출력_d.gif"
end type

event clicked;call super::clicked;gi_page = dw_1.GetItemNumber(1,"last_page")
OpenWithParm(w_print_options, dw_1)

end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\gsp출력_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\gsp출력_dn.gif'
end event

type p_2 from picture within w_sal_06570
event ue_buttondn pbm_lbuttondown
event ue_buttonup pbm_lbuttonup
boolean visible = false
integer x = 3689
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

String ls_expcih_seller,			ls_expcih_cino,		ls_expcih_cidate	
String ls_explc_banklcno,			ls_explc_opndat	
String ls_expcih_consignee, 		ls_expcih_buyer			
String ls_expcih_shipdat, 			ls_expcih_other_ref			
String ls_expcih_vf, 				ls_expcih_vf_from,	ls_expcih_term_deli_pay,	ls_expcih_vf_to			
String ls_mark	
string ls_shipment		
String ls_hs_number				
String ls_jijil	
String ls_ispec	
String ls_expcipl_plqty	
String ls_ciprc	
String ls_ciamt


dw_list.GetChild( 'dw_1', idwc_header )
dw_list.GetChild( 'report_detail', idwc_body )
dw_list.GetChild( 'dw_2', idwc_footer )

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

myOleObject.WorkBooks.Open("c:\erpman\doc\ci.xls")
// c:\mmm.xls 을 불러온다.
myOleObject.WindowState = 2 
// 엑셀윈도우의 상태 지정 1-normal, 2-min, 3-max


//==[header]
ls_expcih_seller		= idwc_header.getitemstring(1, 'expcih_seller')
ls_expcih_cino		= idwc_header.getitemstring(1, 'expcih_cino')
ls_expcih_cidate		= idwc_header.getitemstring(1, 'expcih_cidate')
ls_explc_banklcno		= idwc_header.getitemstring(1, 'explc_banklcno')
ls_explc_opndat		= idwc_header.getitemstring(1, 'explc_opndat')
ls_expcih_consignee		= idwc_header.getitemstring(1, 'expcih_consignee')
ls_expcih_buyer		= idwc_header.getitemstring(1, 'expcih_buyer')
ls_expcih_shipdat		= idwc_header.getitemstring(1, 'expcih_shipdat')
ls_expcih_other_ref		= idwc_header.getitemstring(1, 'expcih_other_ref')
ls_expcih_vf		= idwc_header.getitemstring(1, 'expcih_vf')
ls_expcih_vf_from		= idwc_header.getitemstring(1, 'expcih_vf_from')
ls_expcih_term_deli_pay		= idwc_header.getitemstring(1, 'expcih_term_deli_pay')
ls_expcih_vf_to				= idwc_header.getitemstring(1, 'expcih_vf_to')

//-----------------------------------------------------------------------------

myOleobject.application.workbooks(1).worksheets(1).Range( "A3" ).Value = ls_expcih_seller			
myOleobject.application.workbooks(1).worksheets(1).Range( "D3" ).Value = ls_expcih_cino			
myOleobject.application.workbooks(1).worksheets(1).Range( "F3" ).Value = ls_expcih_cidate			
myOleobject.application.workbooks(1).worksheets(1).Range( "D6" ).Value = ls_explc_banklcno
myOleobject.application.workbooks(1).worksheets(1).Range( "F6" ).Value = ls_explc_opndat
myOleobject.application.workbooks(1).worksheets(1).Range( "A8" ).Value = ls_expcih_consignee												
myOleobject.application.workbooks(1).worksheets(1).Range( "D8" ).Value = ls_expcih_buyer
myOleobject.application.workbooks(1).worksheets(1).Range( "A13" ).Value = ls_expcih_shipdat
myOleobject.application.workbooks(1).worksheets(1).Range( "D13" ).Value = ls_expcih_other_ref
myOleobject.application.workbooks(1).worksheets(1).Range( "A15" ).Value = ls_expcih_vf
myOleobject.application.workbooks(1).worksheets(1).Range( "C15" ).Value = ls_expcih_vf_from
myOleobject.application.workbooks(1).worksheets(1).Range( "D15" ).Value = ls_expcih_term_deli_pay
myOleobject.application.workbooks(1).worksheets(1).Range( "B16" ).Value = ls_expcih_vf_to




//==[body]
String ls_a, ls_c1,ls_c2 , ls_c3, ls_E, ls_F, ls_g
For ll_i = 1 to idwc_body.rowcount() 
	ls_mark		= dw_list.object.compute_2[1] 
	ls_shipment	= idwc_body.getitemstring ( 1, 'Shipment') 	
	ls_hs_number = idwc_body.getitemstring ( ll_i, 'hs_number') 	
	ls_jijil		= idwc_body.getitemstring ( ll_i, 'jijil') 	
	ls_ispec		= idwc_body.getitemstring ( ll_i, 'ispec') 	
	ls_expcipl_plqty		= string(idwc_body.getitemnumber ( ll_i, 'expcipl_plqty') 	)
	ls_ciprc		= string(idwc_body.getitemnumber ( ll_i, 'ciprc') 	)
	ls_ciamt		= string(idwc_body.getitemnumber ( ll_i, 'ciamt') 	)
	
	//셀위치정보
	ls_a	= "A" + string(ll_i * 3  + 16) 
	ls_c1  = "C" + string(ll_i * 3  + 16) 
	ls_C2  = "C" + string(ll_i * 3  + 17) 
	ls_C3  = "C" + string(ll_i * 3  + 18) 
	ls_E  = "E" + string(ll_i * 3  + 17) 
	ls_F  = "F" + string(ll_i * 3 + 17) 
	ls_G  = "G" + string(ll_i * 3 + 17) 

	myOleobject.application.workbooks(1).worksheets(1).Range( 'E18').Value = ls_shipment
	myOleobject.application.workbooks(1).worksheets(1).Range( ls_a ).Value = ls_mark			
	myOleobject.application.workbooks(1).worksheets(1).Range( ls_c1 ).Value = ls_hs_number			
	myOleobject.application.workbooks(1).worksheets(1).Range( ls_c2 ).Value = ls_jijil
	myOleobject.application.workbooks(1).worksheets(1).Range( ls_C3 ).Value = ls_ispec
	myOleobject.application.workbooks(1).worksheets(1).Range( ls_E ).Value = ls_expcipl_plqty + 'PCS'
	myOleobject.application.workbooks(1).worksheets(1).Range( ls_F ).Value = ls_ciprc
	myOleobject.application.workbooks(1).worksheets(1).Range( ls_G ).Value = ls_ciamt												

Next 

//
//==[Footer]
String ls_chargu, ls_exppich_charamt
For ll_i = 1 to idwc_body.rowcount() 
	if ll_i = 1 then 
		ls_chargu		= idwc_footer.getitemstring ( ll_i, 'rfna2') 
		ls_exppich_charamt		= string(idwc_footer.getitemnumber ( ll_i, 'chramt') ) 
	else 
		ls_chargu = ls_chargu + ' / ' + idwc_footer.getitemstring ( ll_i, 'rfna2')
		ls_exppich_charamt		= ls_exppich_charamt + ' / ' + string(idwc_footer.getitemnumber ( ll_i, 'chramt') )
 	End if 

Next 

myOleobject.application.workbooks(1).worksheets(1).Range( 'C28' ).Value = ls_chargu
myOleobject.application.workbooks(1).worksheets(1).Range( 'G28' ).Value = ls_exppich_charamt			
myOleobject.application.workbooks(1).worksheets(1).Range( 'E29' ).Value =  string(idwc_footer.getitemnumber (1, 'plqty') )	+ 'PCS'
myOleobject.application.workbooks(1).worksheets(1).Range(' G29' ).Value =  string(idwc_footer.getitemnumber (1, 'expamt'))

//myoleobject.application.workbooks(1).Save() //엑셀저장
myoleobject.application.workbooks(1).SaveAs("c:\erpman\doc\ci"+ ls_expcih_cino +".xls")
//mmm3.xls로 새이름으로 저장하는 방법

myOleObject.Application.Visible = True

//다른 엑셀명령도 위처럼 사용가능하지 않을까 싶네요 (여러가지 해보지를 못해서..)

myoleobject.DisConnectObject() //연결종료
Destroy myoleobject //오브젝트 제거

end event

type rr_1 from roundrectangle within w_sal_06570
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 204
integer width = 4562
integer height = 2120
integer cornerheight = 40
integer cornerwidth = 55
end type

