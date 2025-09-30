$PBExportHeader$w_qct_04028.srw
$PBExportComments$거래명세표 발행
forward
global type w_qct_04028 from w_standard_print
end type
type dw_1 from datawindow within w_qct_04028
end type
type p_1 from uo_picture within w_qct_04028
end type
type rr_1 from roundrectangle within w_qct_04028
end type
end forward

global type w_qct_04028 from w_standard_print
string title = "거래명세표 발행"
dw_1 dw_1
p_1 p_1
rr_1 rr_1
end type
global w_qct_04028 w_qct_04028

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String  sOutDate,sArea,sIoJpNo,sCust,sDept,sIoGbn,ls_salegu,ssaupj,tx_name , ls_printyn

If dw_ip.AcceptText() <> 1 Then Return -1

sOutDate = dw_ip.GetItemString(1,"sdatef")
sDept    = dw_ip.GetItemString(1,"deptcode")
sArea    = dw_ip.GetItemString(1,"areacode")
sCust    = dw_ip.GetItemString(1,"custcode")
sIoJpNo  = dw_ip.GetItemString(1,"iojpno")
sIogbn   = Trim(dw_ip.GetItemString(1,"iogbn"))
ssaupj = dw_ip.getitemstring(1,"saupj")
ls_printyn = dw_ip.getitemstring(1,'printyn')

IF sOutDate = "" OR IsNull(sOutDate) THEN
	f_message_chk(30,'[출고일자]')
	dw_ip.SetColumn("sdatef")
	dw_ip.SetFocus()
	Return -1
END IF


If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400,'[부가사업장]')
	dw_ip.SetFocus()
	Return -1
End If

IF sArea = "" OR IsNull(sArea) THEN sArea = '%'
IF sCust = "" OR IsNull(sCust) THEN sCust = '%'
IF sDept = "" OR IsNull(sDept) THEN sDept = '%'
IF sIoJpNo = "" OR IsNull(sIoJpNo) THEN sIoJpNo = '%'
if ls_printyn = 'Y' then ls_printyn = '%'

dw_list.SetRedraw(False)

If sIoJpNo = '' Then
	/* 기발행된 송장은 제외 */
	dw_list.SetFilter(" isnull(printyn ) or trim(printyn) = '' ")
	dw_list.Filter()
Else
	/* 송장번호 입력시 기발행된 송장도 출력 */
	dw_list.SetFilter("")
	dw_list.Filter()	
End If

/* 판매출고 */
If sIogbn = 'Y' Then
	ls_salegu='Y'
Else
	/* 무상출고 */
   ls_salegu='N'
End If

IF dw_list.Retrieve(gs_sabu,sOutDate,'%',sArea+'%',sCust+'%',sIoJpNo+'%','%',ssaupj , ls_printyn) <=0 THEN
	f_message_chk(50,'')
	dw_ip.setcolumn('deptcode')
	dw_ip.SetFocus()
	dw_list.SetRedraw(True)
	p_1.enabled = false
	Return -1
END IF

dw_1.Retrieve(gs_sabu,sOutDate,'%',sArea+'%',sCust+'%',sIoJpNo+'%','%',ssaupj, ls_printyn)

dw_list.SetRedraw(True)

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(saupj) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_list.Modify("tx_saupj.text = '"+tx_name+"'")

p_1.enabled = true
dw_1.object.datawindow.print.preview = "yes"

Return 1


//	String sIojpno, sTemp, sNull
//	Long   ix, nIoCnt, nMod, iy, nLastRow
//	
//	SetNull(sNull)
//	
//	dw_list.SetSort('iojpno_1, io_date_1, cvnas_1_1')
//	dw_list.Sort()
//	
//	nCnt = dw_list.RowCount()
//	
//	sTemp  = Trim(dw_list.GetItemString(1, 'iojpno_1'))
//	nIoCnt = 0
//	For ix = 1 To nCnt
//		sIojpno = Trim(dw_list.GetItemString(ix, 'iojpno_1'))
//		If sTemp = sIojpno Then
//			nIoCnt += 1
//		Else
//			/* 추가로 Insert할 row의 갯수 */
//			nMod = Mod(nIoCnt,10)
//			If nMod <> 0 Then
//				For iy = 1 To 10 - nMod
//					/* 마지막 row에 copy한후 clear한다 */
//					dw_list.RowsCopy(ix - 1, ix - 1, Primary!, dw_list, 999999, Primary!)
//					
//					nLastRow = dw_list.RowCount()
//					dw_list.SetItem(nLastRow, 'itdsc_1', '')
//					dw_list.SetItem(nLastRow, 'ispec_1', sNull)
//					dw_list.SetItem(nLastRow, 'ioqty', 0)
//					dw_list.SetItem(nLastRow, 'ioprc_1', 0)
//					dw_list.SetItem(nLastRow, 'ioamt', 0)
//				Next
//			End If
//
//			sTemp = sIojpno
//			nIoCnt = 1
//		End If
//	Next
//
//	/* 추가로 Insert할 row의 갯수 */
//	nMod = Mod(nIoCnt,10)
//	If nMod <> 0 Then
//		For iy = 1 To 10 - nMod
//			/* 마지막 row에 copy한후 clear한다 */
//			dw_list.RowsCopy(ix - 1, ix - 1, Primary!, dw_list, 999999, Primary!)
//			
//			nLastRow = dw_list.RowCount()
//			dw_list.SetItem(nLastRow, 'itdsc_1', '')
//			dw_list.SetItem(nLastRow, 'ispec_1', sNull)
//			dw_list.SetItem(nLastRow, 'ioqty', 0)
//			dw_list.SetItem(nLastRow, 'ioprc_1', 0)
//			dw_list.SetItem(nLastRow, 'ioamt', 0)
//		Next
//	End If
end function

on w_qct_04028.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.p_1=create p_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.p_1
this.Control[iCurrent+3]=this.rr_1
end on

on w_qct_04028.destroy
call super::destroy
destroy(this.dw_1)
destroy(this.p_1)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetItem(1,"sdatef", is_today)
//dw_ip.setitem(1,"sdatef",'20010409')
dw_ip.SetColumn("sdatef")
dw_ip.Setfocus()
dw_1.settransobject(sqlca)
end event

type p_preview from w_standard_print`p_preview within w_qct_04028
integer taborder = 40
end type

type p_exit from w_standard_print`p_exit within w_qct_04028
integer taborder = 70
end type

type p_print from w_standard_print`p_print within w_qct_04028
integer taborder = 50
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_04028
end type

type st_window from w_standard_print`st_window within w_qct_04028
integer x = 2523
integer y = 3876
end type

type sle_msg from w_standard_print`sle_msg within w_qct_04028
integer x = 549
integer y = 3876
end type

type dw_datetime from w_standard_print`dw_datetime within w_qct_04028
integer x = 3017
integer y = 3876
end type

type st_10 from w_standard_print`st_10 within w_qct_04028
integer x = 187
integer y = 3876
integer width = 361
end type

type gb_10 from w_standard_print`gb_10 within w_qct_04028
integer x = 174
integer y = 3840
end type

type dw_print from w_standard_print`dw_print within w_qct_04028
integer x = 3890
integer y = 224
string dataobject = "d_qct_04028_03_p"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_04028
integer x = 343
integer y = 40
integer width = 3168
integer height = 280
string dataobject = "d_qct_04028"
end type

event dw_ip::itemerror;
Return 1
end event

event dw_ip::itemfocuschanged;IF this.GetColumnName() = "custname" OR this.GetColumnName() ='deptname'THEN
	f_toggle_kor(Handle(this))
ELSE
	f_toggle_eng(Handle(this))
END IF
end event

event dw_ip::itemchanged;String  sIoCust,sIoCustArea,sIoCustName,sSuDat,sIoJpNo,snull,sDept,sIoGbn
Long    nRow

SetNull(snull)

nRow = GetRow()
If nRow <= 0 Then Return

SetPointer(HourGlass!)
sIoGbn = Trim(GetItemString(1,'iogbn'))

Choose Case GetColumnName() 
 Case "sdatef"
	sSuDat = Trim(This.GetText())
	IF sSuDat ="" OR IsNull(sSuDat) THEN RETURN
	
	IF f_datechk(sSuDat) = -1 THEN
		f_message_chk(35,'[출고일자]')
		This.SetItem(1,"sdatef",snull)
		Return 1
	END IF
/* 출고구분 */
 Case 'iogbn'
	sIogbn = Trim(GetText())
	
	dw_list.SetRedraw(False)	
	If sIogbn = 'N' Then /* 무상출고 */
		this.SetItem(1,'deptcode',sNull)
		this.SetItem(1,'areacode',sNull)
		this.Modify('deptcode.protect = 1')
		this.Modify('areacode.protect = 1')
		this.Modify("deptcode.background.color = 80859087")
		this.Modify("areacode.background.color = 80859087")
		this.Modify("custcode_t.text = '의뢰부서'")	
	Else
		this.Modify('deptcode.protect = 0')
		this.Modify('areacode.protect = 0')
		this.Modify("deptcode.background.color = '"+String(Rgb(255,255,255))+"'")
		this.Modify("areacode.background.color = '"+String(Rgb(255,255,255))+"'")
		this.Modify("custcode_t.text = '거래처'")
	END IF
	dw_list.Reset()
	dw_list.SetRedraw(True)
	
	this.SetItem(1,'custcode', sNull)
	this.SetItem(1,'custname', sNull)
	this.SetItem(1,'iojpno',   sNull)
	
/* 출고송장 번호 */
 Case "iojpno"
	sIoJpNo = Left(This.GetText(),12)
	IF sIoJpNo = "" OR IsNull(sIoJpNo) THEN RETURN
	
	If sIoGbn = 'Y' Then /* 판매출고 */
	  SELECT DISTINCT SUBSTR("IMHIST"."IOJPNO",1,12), "IMHIST"."SUDAT"
	    INTO :sIoJpNo,	 :sSuDat
	    FROM "IMHIST"  
      WHERE ( "IMHIST"."SABU" = :gs_sabu ) AND
			      ( "IMHIST"."JNPCRT" = '004' ) AND 
	          ( SUBSTR("IMHIST"."IOJPNO",1,12) = :sIoJpNo );
	Else
	  SELECT DISTINCT SUBSTR("IMHIST"."IOJPNO",1,12), "IMHIST"."SUDAT"
	    INTO :sIoJpNo,	:sSuDat
	    FROM "IMHIST"  
      WHERE ( "IMHIST"."SABU" = :gs_sabu ) AND
			      ( "IMHIST"."IOGBN" IN ( 'O18', 'O19','O17','O12' ) ) AND 
	          ( SUBSTR("IMHIST"."IOJPNO",1,12) = :sIoJpNo );
	End If
	IF SQLCA.SQLCODE <> 0 THEN
		This.TriggerEvent(RbuttonDown!)
		IF gs_code ="" OR IsNull(gs_code) THEN		This.SetItem(1,"iojpno",snull)
		Return 1
	ELSE
		This.SetItem(1,"sdatef",sSuDat)
		This.SetItem(1,"custcode",sNull)
		This.SetColumn("custname")
		
		Return 1
	END IF
/* 영업팀 */
 Case "deptcode"
   SetItem(1,'areacode',sNull)
	SetItem(1,"custcode",sNull)
	SetItem(1,"custname",sNull)
/* 관할구역 */
 Case "areacode"
	SetItem(1,"custcode",sNull)
	SetItem(1,"custname",sNull)
	
	sIoCustArea = This.GetText()
	IF sIoCustArea = "" OR IsNull(sIoCustArea) THEN RETURN
	
	SELECT "SAREA"."SAREA" ,"SAREA"."STEAMCD" 	INTO :sIoCustArea  ,:sDept
     FROM "SAREA"  
	 WHERE "SAREA"."SAREA" = :sIoCustArea   ;
		
   SetItem(1,'deptcode',sDept)
/* 거래처 or 부서*/
Case "custcode"
	sIoCust = Trim(GetText())
	IF sIoCust ="" OR IsNull(sIoCust) THEN
		this.SetItem(1,"custname",snull)
		Return
	END IF
	
   sIogbn = Trim(GetItemString(1,'iogbn'))	
	If sIogbn = 'Y' Then
	  SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
	    INTO :sIoCustName,		:sIoCustArea,			:sDept
	    FROM "VNDMST","SAREA" 
      WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :sIoCust;
	Else
	  SELECT "VNDMST"."CVNAS2"
	    INTO :sIoCustName
	    FROM "VNDMST"  
      WHERE "VNDMST"."CVCOD" = :sIoCust ;
		
		SetNull(sDept)
		SetNull(sIoCustArea)
	End If
	
	IF SQLCA.SQLCODE <> 0 THEN
//		this.TriggerEvent(RbuttonDown!)
		Return 2
	ELSE
		this.SetItem(1,"deptcode",  sDept)
		this.SetItem(1,"custname",  sIoCustName)
		this.SetItem(1,"areacode",  sIoCustArea)
	END IF
/* 거래처명 or 부서명 */
 Case "custname"
	sIoCustName = Trim(GetText())
	IF sIoCustName ="" OR IsNull(sIoCustName) THEN
		this.SetItem(1,"custcode",snull)
		Return
	END IF
	
	If sIogbn = 'Y' Then
	  SELECT "VNDMST"."CVCOD", "VNDMST"."CVNAS2","VNDMST"."SAREA","SAREA"."STEAMCD"
  	    INTO :sIoCust, :sIoCustName, :sIoCustArea,	:sDept
	    FROM "VNDMST","SAREA" 
      WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVNAS2" = :sIoCustName;
	Else
	  SELECT "VNDMST"."CVCOD"			INTO :sIoCust
	    FROM "VNDMST"  
      WHERE "VNDMST"."CVNAS2" = :sIoCustName AND "VNDMST"."CVGU" ='4'  ;
   End If

	IF SQLCA.SQLCODE <> 0 THEN
		this.TriggerEvent(RbuttonDown!)
		Return 2
	ELSE
		SetItem(1,"deptcode",  sDept)
		SetItem(1,"custcode",  sIoCust)
		SetItem(1,"custname",  sIoCustName)
		SetItem(1,"areacode",  sIoCustArea)
		Return
	END IF
End Choose
end event

event dw_ip::rbuttondown;string sIoJpNo, sIoCust, sIoCustName,sIoCustArea,sNull,sDept,sSudat,sIoGbn

SetNull(gs_gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

/* 송장번호 */
SetPointer(HourGlass!)

Choose Case GetColumnName() 
 Case "iojpno"
	sIoGbn = Trim(GetItemString(1,'iogbn'))

	If sIoGbn = 'Y' Then
 	  gs_code  = GetItemString(1,'custcode')
	  gs_gubun = '004'
	  gs_codename = 'B'  /* 판매 출고확인 전 */
  Else
	  gs_gubun = '001'
	  gs_codename = 'B'  /* 무상 출고확인 전 */
  End If
	
//	SetNull(gs_gubun)
	SetNull(Gs_Code)
//	SetNull(Gs_CodeName)
	
	Open(w_imhist_02040_popup)	
	IF gs_code ="" OR IsNull(gs_code) THEN RETURN
	  
	If sIoGbn = 'Y' Then 
	  SELECT DISTINCT SUBSTR("IMHIST"."IOJPNO",1,12),"IMHIST"."CVCOD", "IMHIST"."SUDAT"
	    INTO :sIoJpNo,  :sIoCust ,:sSudat
	    FROM "IMHIST"  
      WHERE "IMHIST"."SABU" = :gs_sabu  AND
			      "IMHIST"."IOJPNO" = :gs_code ;
	Else
	  SELECT DISTINCT SUBSTR("IMHIST"."IOJPNO",1,12),"IMHIST"."IOREDEPT", "IMHIST"."SUDAT"
	    INTO :sIoJpNo,  :sIoCust ,:sSudat
	    FROM "IMHIST"  
      WHERE "IMHIST"."SABU" = :gs_sabu AND
			      "IMHIST"."IOJPNO" = :gs_code ;
   End If
	
	this.SetItem(1,"iojpno",sIoJpNo)
	this.SetItem(1,"sdatef",sSudat)
	this.SetItem(1,"custcode",sIoCust)
  this.SetColumn("DEPTCODE")
	this.SetFocus()
	
	this.TriggerEvent(ItemChanged!)
	Return 1
/* 거래처 */
 Case "custcode","custname"
	sIoGbn = Trim(this.GetItemString(1,'iogbn'))

	If sIogbn = 'Y' Then
	  gs_gubun = '1'
	  Open(w_agent_popup)
	
	  IF gs_code ="" OR IsNull(gs_code) THEN RETURN
	
	  this.SetItem(1,"custcode",gs_code)
	
	  SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
	    INTO :sIoCustName,		:sIoCustArea,			:sDept
	    FROM "VNDMST","SAREA" 
      WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :gs_code;
		
	  IF SQLCA.SQLCODE = 0 THEN
	    this.SetItem(1,"deptcode",  sDept)
	    this.SetItem(1,"custname",  sIoCustName)
	    this.SetItem(1,"areacode",  sIoCustArea)
	  END IF
	Else
	  Open(w_dept_popup)
	  IF gs_code ="" OR IsNull(gs_code) THEN RETURN
	
  	  this.SetItem(1,"custcode",  gs_code)
	  this.SetItem(1,"custname",  gs_codeName)
	  this.SetItem(1,"deptcode",  sNull)
	  this.SetItem(1,"areacode",  sNull)
	End If
END Choose

end event

type dw_list from w_standard_print`dw_list within w_qct_04028
integer x = 375
integer y = 348
integer width = 3712
integer height = 1956
string dataobject = "d_qct_04028_03"
boolean hscrollbar = false
boolean border = false
boolean hsplitscroll = false
end type

event dw_list::printpage;call super::printpage;boolean lb_found
string  ls_iojpno
long ll_breakrow, nPageCnt=0 , ll_count , ll_frow ,ll_lrow ,i, ll_srow, ll_erow
 
lb_found = FALSE
ll_breakrow = 0

DO WHILE NOT (lb_found)
	ll_breakrow = FindGroupChange(ll_breakrow, 1)

	nPageCnt += 1
	
	IF nPageCnt = pagenumber THEN
		ll_srow	= ll_breakrow
		ll_erow  = FindGroupChange(ll_srow+1, 1) - 1
		If ll_erow <= 0 Then
			ll_erow = RowCount()
		End If
//				messagebox(string(ll_srow), string(ll_erow))	
		//프린트 한 페이지에 프린트 CHECK표시 //
		for i = ll_srow to ll_erow
			ls_iojpno = this.getitemstring(i,'iojpno')

			SELECT COUNT(*)  INTO :ll_count
			FROM IMHEAD     WHERE SABU = :gs_sabu AND IOJP = :ls_iojpno ;
			
			if ll_count > 0 then
				UPDATE IMHEAD SET PRINTYN = 'Y'
				WHERE   SABU = :gs_sabu AND IOJP = :ls_iojpno ;
			else
				INSERT INTO IMHEAD (SABU ,IOJP , PRINTYN)
				VALUES (:gs_sabu , :ls_iojpno , 'Y') ;
			end if
		next	
		lb_found = TRUE
	END IF
	
	ll_breakrow = ll_breakrow + 1
LOOP

COMMIT ; 
end event

type dw_1 from datawindow within w_qct_04028
boolean visible = false
integer x = 4041
integer y = 232
integer width = 507
integer height = 92
integer taborder = 70
boolean bringtotop = true
boolean titlebar = true
string title = "거래명세표발행용"
string dataobject = "d_qct_04028_02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event dw_1::printpage;call super::printpage;boolean lb_found
string  ls_iojpno
long ll_breakrow, nPageCnt=0 , ll_count , ll_frow ,ll_lrow ,i, ll_srow, ll_erow
 
lb_found = FALSE
ll_breakrow = 0

DO WHILE NOT (lb_found)
	ll_breakrow = FindGroupChange(ll_breakrow, 1)

	nPageCnt += 1
	
	IF nPageCnt = pagenumber THEN
		ll_srow	= ll_breakrow
		ll_erow  = FindGroupChange(ll_srow+1, 1) - 1
		If ll_erow <= 0 Then
			ll_erow = RowCount()
		End If
//				messagebox(string(ll_srow), string(ll_erow))	
		//프린트 한 페이지에 프린트 CHECK표시 //
		for i = ll_srow to ll_erow
			ls_iojpno = this.getitemstring(i,'iojpno')

			SELECT COUNT(*)  INTO :ll_count
			FROM IMHEAD     WHERE SABU = :gs_sabu AND IOJP = :ls_iojpno ;
			
			if ll_count > 0 then
				UPDATE IMHEAD SET PRINTYN = 'Y'
				WHERE  SABU = :gs_sabu AND IOJP = :ls_iojpno ;
			else
				INSERT INTO IMHEAD (SABU ,IOJP , PRINTYN)
				VALUES (:gs_sabu , :ls_iojpno , 'Y') ;
			end if
		next	
		lb_found = TRUE
	END IF
	
	ll_breakrow = ll_breakrow + 1
LOOP

COMMIT ; 
end event

type p_1 from uo_picture within w_qct_04028
integer x = 3621
integer y = 24
integer width = 306
integer taborder = 90
boolean bringtotop = true
string picturename = "C:\erpman\image\거래명세표발행_up.gif"
end type

event clicked;call super::clicked;IF dw_1.rowcount() > 0 then 
	gi_page = dw_1.GetItemNumber(1,"last_page")
ELSE
	gi_page = 1
END IF
OpenWithParm(w_print_options, dw_1)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\거래명세표발행_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\거래명세표발행_up.gif"
end event

type rr_1 from roundrectangle within w_qct_04028
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 352
integer y = 332
integer width = 3785
integer height = 1988
integer cornerheight = 40
integer cornerwidth = 55
end type

