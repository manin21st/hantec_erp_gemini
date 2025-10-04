$PBExportHeader$w_mat_01025.srw
$PBExportComments$반품 거래명세표 발행
forward
global type w_mat_01025 from w_standard_print
end type
type pb_1 from u_pb_cal within w_mat_01025
end type
type rr_1 from roundrectangle within w_mat_01025
end type
end forward

global type w_mat_01025 from w_standard_print
integer height = 2396
string title = "거래명세표 발행"
pb_1 pb_1
rr_1 rr_1
end type
global w_mat_01025 w_mat_01025

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String  sOutDate, sIoJpNo, sCust, ssaupj, tx_name, ls_printyn

If dw_ip.AcceptText() <> 1 Then Return -1

sOutDate = dw_ip.GetItemString(1,"sdatef")
sCust    = dw_ip.GetItemString(1,"custcode")
sIoJpNo  = dw_ip.GetItemString(1,"iojpno")
ssaupj   = dw_ip.getitemstring(1,"saupj")
ls_printyn = dw_ip.getitemstring(1,'printyn')

IF sOutDate = "" OR IsNull(sOutDate) THEN
	f_message_chk(30,'[의뢰일자]')
	dw_ip.SetColumn("sdatef")
	dw_ip.SetFocus()
	Return -1
END IF

If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400,'[부가사업장]')
	dw_ip.SetColumn("saupj")
	dw_ip.SetFocus()
	Return -1
End If

If IsNull(sIoJpNo) Or sIoJpNo = '' Then
	f_message_chk(1400,'[전표번호]')
	dw_ip.SetColumn("iojpno")
	dw_ip.SetFocus()
	Return -1
End If

IF sCust = "" OR IsNull(sCust) THEN sCust = '%'
IF sIoJpNo = "" OR IsNull(sIoJpNo) THEN sIoJpNo = '%'
if ls_printyn = 'Y' then ls_printyn = '%'

dw_list.SetRedraw(False)

//If sIoJpNo = '' Then
//	/* 기발행된 송장은 제외 */
//	dw_list.SetFilter(" isnull(printyn) or trim(printyn) = '' ")
//	dw_list.Filter()
//Else
//	/* 송장번호 입력시 기발행된 송장도 출력 */
//	dw_list.SetFilter("")
//	dw_list.Filter()	
//End If

//IF dw_list.Retrieve(gs_sabu, sOutDate, sCust+'%', sIoJpNo+'%', ssaupj, ls_printyn) <=0 THEN
//	f_message_chk(50,'')
//	dw_ip.SetFocus()
//	dw_list.SetRedraw(True)
//	Return -1
//END IF

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(saupj) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_list.Modify("tx_saupj.text = '"+tx_name+"'")

//IF dw_print.Retrieve(gs_sabu, sOutDate, sCust+'%', sIoJpNo+'%', ssaupj, ls_printyn) <=0 THEN
IF dw_print.Retrieve(gs_sabu, sIoJpNo+'%') <=0 THEN
	dw_list.Reset()
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)

dw_print.Modify("tx_saupj.text = '"+tx_name+"'")

dw_list.SetRedraw(True)

Return 1
end function

on w_mat_01025.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.rr_1
end on

on w_mat_01025.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;dw_ip.SetItem(1,"sdatef", is_today)
dw_ip.SetColumn("sdatef")
dw_ip.Setfocus()

//사업장
f_mod_saupj(dw_ip, 'saupj' )
end event

type p_xls from w_standard_print`p_xls within w_mat_01025
end type

type p_sort from w_standard_print`p_sort within w_mat_01025
end type

type p_preview from w_standard_print`p_preview within w_mat_01025
end type

type p_exit from w_standard_print`p_exit within w_mat_01025
integer taborder = 70
end type

type p_print from w_standard_print`p_print within w_mat_01025
end type

type p_retrieve from w_standard_print`p_retrieve within w_mat_01025
end type











type dw_print from w_standard_print`dw_print within w_mat_01025
string dataobject = "d_mat_01025_05_new1"
end type

type dw_ip from w_standard_print`dw_ip within w_mat_01025
integer x = 78
integer y = 32
integer width = 3186
integer height = 196
string dataobject = "d_mat_01025"
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

event dw_ip::itemchanged;String  sIoCust,sSuDat,snull, sname1, sjpno, sdate, scvcod, scvnas, SSAUPJ
int     ilen

SetNull(snull)

Choose Case GetColumnName() 
 Case "sdatef"
	sSuDat = Trim(This.GetText())
	IF sSuDat ="" OR IsNull(sSuDat) THEN RETURN
	
	IF f_datechk(sSuDat) = -1 THEN
		f_message_chk(35,'[의뢰일자]')
		This.SetItem(1,"sdatef",snull)
		Return 1
	END IF
/* 출고송장 번호 */
 Case "iojpno"
	sJpno = trim(this.GetText())
	
	if sJpno = '' or isnull(sJpno) then return 
   ilen = len(sJpno)
	
	if ilen < 12 then 
		f_message_chk(33,'[전표번호]')
		this.SetItem(1, "iojpno",	sNull)
		return 1
   end if	
	
	SELECT A.SUDAT, A.CVCOD, E.CVNAS, A.SAUPJ
	  INTO :sDate, :SCVCOD, :SCVNAS, :SSAUPJ
	  FROM IMHIST A, VNDMST E
	 WHERE A.SABU     = :gs_sabu	AND
	 		 A.IOJPNO   like :sJpno||'%'	AND
			 A.JNPCRT   = '027' AND
			 A.CVCOD		= E.CVCOD(+) AND ROWNUM = 1 ;

	IF SQLCA.SQLCODE = 100	THEN
		f_message_chk(33,'[의뢰번호]')
		this.SetItem(1, "iojpno",	sNull)
		RETURN 1
	END IF

	this.SetItem(1, "sdatef",   sdate)
	this.setitem(1, "custcode", scvcod)
	this.SetItem(1, "custname", scvnas)
	this.SetItem(1, "saupj", ssaupj)

/* 거래처 or 부서*/
Case "custcode"
	sIoCust = Trim(GetText())
	IF sIoCust ="" OR IsNull(sIoCust) THEN
		this.SetItem(1,"custname",snull)
		Return
	END IF
	
	SELECT "CVNAS2"
	  INTO :sName1
	  FROM "VNDMST" 
	 WHERE "CVCOD" = :sIoCust ;

	IF sqlca.sqlcode <> 0 	THEN
		f_message_chk(33, '[거래처]')
		this.setitem(1, "custcode", sNull)
		this.SetItem(1, "custname", snull)
	   return 1
	ELSE
		this.setitem(1, 'custname', sName1)
	END IF
	
End Choose
end event

event dw_ip::rbuttondown;gs_code = ''
gs_codename = ''
gs_gubun = ''

IF this.GetColumnName() = 'iojpno'	THEN

	gs_gubun = '027'
	Open(w_007_1_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1,"iojpno",	left(gs_code, 12))
	this.TriggerEvent("itemchanged")

// 거래처
ELSEIF this.GetColumnName() = 'custcode'	THEN
   gs_gubun = '1'
	open(w_vndmst_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return		
	
	this.SetItem(1, "custcode", gs_code)
	this.SetItem(1, "custname", gs_codename)

END IF

end event

type dw_list from w_standard_print`dw_list within w_mat_01025
integer x = 434
integer y = 296
integer width = 3698
integer height = 1980
string dataobject = "d_mat_01025_05_new1"
boolean border = false
end type

event dw_list::printpage;boolean lb_found
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
			FROM IMHEAD     WHERE SABU = :gs_saupj AND IOJP = :ls_iojpno ;
			
			if ll_count > 0 then
				UPDATE IMHEAD SET PRINTYN = 'Y'
				WHERE  IOJP = :ls_iojpno ;
			else
				INSERT INTO IMHEAD (SABU ,IOJP , PRINTYN)
				VALUES (:gs_saupj , :ls_iojpno , 'Y') ;
			end if
		next	
		lb_found = TRUE
	END IF
	
	ll_breakrow = ll_breakrow + 1
LOOP

COMMIT ; 
end event

event dw_list::rowfocuschanged;//

end event

type pb_1 from u_pb_cal within w_mat_01025
integer x = 827
integer y = 44
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('sdatef')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'sdatef', gs_code)



end event

type rr_1 from roundrectangle within w_mat_01025
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 421
integer y = 288
integer width = 3730
integer height = 2000
integer cornerheight = 40
integer cornerwidth = 55
end type

