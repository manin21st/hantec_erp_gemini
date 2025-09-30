$PBExportHeader$w_sal_05100_han.srw
$PBExportComments$출고단가 일괄변경
forward
global type w_sal_05100_han from w_inherite
end type
type cbx_1 from checkbox within w_sal_05100_han
end type
type rr_1 from roundrectangle within w_sal_05100_han
end type
type dw_list from u_d_select_sort within w_sal_05100_han
end type
type rb_3 from radiobutton within w_sal_05100_han
end type
type rb_4 from radiobutton within w_sal_05100_han
end type
type rb_5 from radiobutton within w_sal_05100_han
end type
type pb_1 from u_pb_cal within w_sal_05100_han
end type
type pb_2 from u_pb_cal within w_sal_05100_han
end type
type p_1 from uo_picture within w_sal_05100_han
end type
type rb_cvcod from radiobutton within w_sal_05100_han
end type
type rb_danga from radiobutton within w_sal_05100_han
end type
type gb_2 from groupbox within w_sal_05100_han
end type
type rr_2 from roundrectangle within w_sal_05100_han
end type
end forward

global type w_sal_05100_han from w_inherite
integer width = 4667
integer height = 3928
string title = "거래처 매출 일괄 변경"
cbx_1 cbx_1
rr_1 rr_1
dw_list dw_list
rb_3 rb_3
rb_4 rb_4
rb_5 rb_5
pb_1 pb_1
pb_2 pb_2
p_1 p_1
rb_cvcod rb_cvcod
rb_danga rb_danga
gb_2 gb_2
rr_2 rr_2
end type
global w_sal_05100_han w_sal_05100_han

type variables
String isStdDate
end variables

forward prototypes
public function integer wf_set_iojpno (string arg_iojpno)
public subroutine wf_change_cvcod ()
public function decimal wf_get_danga (string arg_ncvcod, string arg_dandate, string sitnbr)
public subroutine wf_init ()
public function integer wf_change_danga (string arg_ocvcod, string arg_dandate, string arg_iodatfr, string arg_iodatto)
public function integer wf_change_cvcod (string sncvcod, string socvcod, string sdatef, string sdatet)
end prototypes

public function integer wf_set_iojpno (string arg_iojpno);String sIojpno, sItnbr, sItdsc, sIspec
String sCvcod, sCvnas2, sArea, sSteamCd, sIoDate
Double dIoPrc

select x.io_date, x.iojpno, x.itnbr, y.itdsc, y.ispec, x.ioprc, x.cvcod, v.cvnas2, v.sarea, a.steamcd
  into :sIoDate, :sIojpno , :sItnbr ,:sitdsc, :sispec , :dIoPrc,:sCvcod, :sCvnas2, :sArea, :sSteamCd
  from imhist x, itemas y, vndmst v, sarea a
 where x.cvcod = v.cvcod and
       v.sarea = a.sarea and
       x.itnbr = y.itnbr and
       x.sabu = :gs_sabu and
		 x.iojpno = :arg_iojpno;

If sqlca.sqlcode = 0 Then
	dw_insert.SetItem(1,'iojpno',  left(sIojpno,12))
	dw_insert.SetItem(1,'sdatef',  sIoDate)
	dw_insert.SetItem(1,'sdatet',  sIoDate)
	dw_insert.SetItem(1,'itnbr',   sItnbr)
	dw_insert.SetItem(1,'itdsc',   sItdsc)
	dw_insert.SetItem(1,'ispec',   sIspec)
	dw_insert.SetItem(1,'ioprc',   dIoPrc)
	dw_insert.SetItem(1,'steamcd', sSteamCd)
	dw_insert.SetItem(1,'sarea',   sArea)
	dw_insert.SetItem(1,'cvcod',   sCvcod)
	dw_insert.SetItem(1,'cvcodnm', sCvnas2)
End If

Return 0
end function

public subroutine wf_change_cvcod ();String sNCvcod, sStatus
Integer i

sNCvcod = Trim(dw_insert.GetItemString(1,'vcvcod'))
If IsNull(sNCvcod) = False Or Len(sNCvcod) >= 1 Then
	For i = 1 To dw_list.RowCount()
		sStatus = dw_list.GetItemString(i,'chk')
		If sStatus = 'Y' Then
			dw_list.SetItem(i,'cvcod', sNCvcod)
		End If
	Next
End If
end subroutine

public function decimal wf_get_danga (string arg_ncvcod, string arg_dandate, string sitnbr);Decimal{5} dRtnprc

SELECT A.SALES_PRICE
INTO :dRtnprc
FROM VNDDAN A, (SELECT CVCOD, MAX(START_DATE) AS MAXDATE
						FROM VNDDAN
						WHERE CVCOD = :arg_ncvcod
						AND	START_DATE <= :arg_dandate
						AND	END_DATE >= :arg_dandate
						GROUP BY CVCOD) B
WHERE 	A.CVCOD = B.CVCOD
AND		A.START_DATE <= B.MAXDATE
AND        A.END_DATE >= B.MAXDATE
AND		A.ITNBR	= :sItnbr;   	  

Return dRtnprc
end function

public subroutine wf_init ();String sDate

dw_insert.Reset()
dw_insert.InsertRow(0)

f_mod_saupj(dw_insert, 'saupj')

//dw_insert.setitem(1,'saupj','20')

sdate = f_today()
dw_insert.SetItem(1,'sdatef',Left(sdate,6)+'01')
dw_insert.SetItem(1,'sdatet',sDate)

dw_insert.Modify('saupj.protect = 0')

IF sModStatus = 'C' THEN
	dw_insert.object.t_9.visible = false
	dw_insert.object.t_12.visible = false
	dw_insert.modify('sdandate.visible = false')
	
	dw_insert.object.t_1.visible = true
	dw_insert.object.t_11.visible = true
	dw_insert.modify('vcvcod.visible = true')
	dw_insert.modify('vcvcodnm.visible = true')
	dw_insert.object.p_4.visible = true
ELSE
	dw_insert.object.t_9.visible = true
	dw_insert.object.t_12.visible = true
	dw_insert.modify('sdandate.visible = true')
	
	dw_insert.object.t_1.visible = false
	dw_insert.object.t_11.visible = false
	dw_insert.modify('vcvcod.visible = false')
	dw_insert.modify('vcvcodnm.visible = false')
	dw_insert.object.p_4.visible = false
END IF

dw_insert.SetFocus()
dw_insert.SetColumn("cvcod")
	
ib_any_typing = False
end subroutine

public function integer wf_change_danga (string arg_ocvcod, string arg_dandate, string arg_iodatfr, string arg_iodatto);String sItnbr, sIojpno
Decimal{5} dRtnprc=0.0
Decimal{2} dAmt=0.0
Integer nCnt=0
Double dQty

DECLARE CUR_GET_CHANGE CURSOR FOR
SELECT IOJPNO, ITNBR, IOQTY
FROM IMHIST 
WHERE EXISTS(SELECT * 
					FROM IOMATRIX 
					WHERE IOGBN = IMHIST.IOGBN
					AND	SALEGU = 'Y')
AND	IMHIST.IO_DATE BETWEEN :arg_iodatfr AND :arg_iodatto
AND	IMHIST.CVCOD = :arg_ocvcod
AND	IMHIST.YEBI1 IS NULL;

OPEN CUR_GET_CHANGE;

DO
	FETCH CUR_GET_CHANGE INTO :sIojpno, :sItnbr, :dQty;
	IF SQLCA.SQLCODE <> 0 THEN EXIT
	
	dRtnprc = WF_GET_DANGA(arg_ocvcod, arg_dandate, sItnbr)
	
	If Isnull(dRtnprc) Or dRtnprc <= 0 Then dRtnprc = 0.0
	
	dAmt = dQty * dRtnprc
	
	UPDATE IMHIST
	SET IOPRC = :dRtnprc, IOAMT = :dAmt
	WHERE IMHIST.IOJPNO = :sIojpno;
	
	IF SQLCA.SQLCODE = 0 THEN
		nCnt++
	End If
	
	dRtnprc = 0.0
	dAmt = 0.0
	
LOOP WHILE TRUE

IF nCnt > 0 THEN
	COMMIT;
Else
	ROLLBACK;
	MessageBox('거래처 매출 일괄변경','거래처 매출 일괄변경 작업이 실패하였습니다.')
End If

CLOSE CUR_GET_CHANGE;

RETURN nCnt

          
         
			   
	

end function

public function integer wf_change_cvcod (string sncvcod, string socvcod, string sdatef, string sdatet);UPDATE IMHIST
SET CVCOD = :sNCvcod
WHERE EXISTS(SELECT IOGBN
					FROM IOMATRIX
					WHERE IOGBN = IMHIST.IOGBN
					AND	SALEGU = 'Y')
AND IMHIST.IO_DATE BETWEEN :sDatef AND :sDatet
AND IMHIST.CVCOD = :sOCvcod
AND IMHIST.YEBI1 IS NULL; 

if sqlca.sqlcode = 0 then
	COMMIT;
	MessageBox('거래처 일괄변경','거래처 변경 작업이 완료되었습니다.')
end if
				
return 1
end function

on w_sal_05100_han.create
int iCurrent
call super::create
this.cbx_1=create cbx_1
this.rr_1=create rr_1
this.dw_list=create dw_list
this.rb_3=create rb_3
this.rb_4=create rb_4
this.rb_5=create rb_5
this.pb_1=create pb_1
this.pb_2=create pb_2
this.p_1=create p_1
this.rb_cvcod=create rb_cvcod
this.rb_danga=create rb_danga
this.gb_2=create gb_2
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_1
this.Control[iCurrent+2]=this.rr_1
this.Control[iCurrent+3]=this.dw_list
this.Control[iCurrent+4]=this.rb_3
this.Control[iCurrent+5]=this.rb_4
this.Control[iCurrent+6]=this.rb_5
this.Control[iCurrent+7]=this.pb_1
this.Control[iCurrent+8]=this.pb_2
this.Control[iCurrent+9]=this.p_1
this.Control[iCurrent+10]=this.rb_cvcod
this.Control[iCurrent+11]=this.rb_danga
this.Control[iCurrent+12]=this.gb_2
this.Control[iCurrent+13]=this.rr_2
end on

on w_sal_05100_han.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_1)
destroy(this.rr_1)
destroy(this.dw_list)
destroy(this.rb_3)
destroy(this.rb_4)
destroy(this.rb_5)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.p_1)
destroy(this.rb_cvcod)
destroy(this.rb_danga)
destroy(this.gb_2)
destroy(this.rr_2)
end on

event open;call super::open;PostEvent("ue_open")
end event

event ue_open;call super::ue_open;String sDeptName, sarea, steam, saupj
integer rtncode

dw_list.SetTransObject(sqlca)
dw_insert.SetTransObject(sqlca)

/* 부가 사업장 */
f_mod_saupj(dw_insert, 'saupj')

f_child_saupj(dw_insert, 'steamcd', gs_saupj)
f_child_saupj(dw_insert, 'sarea', gs_saupj)

//dw_insert.setitem(1,'saupj','10')

/* User별 관할구역 Setting */
//If f_check_sarea(sarea, steam, saupj) = 1 Then
//	dw_insert.Modify("sarea.protect=1")
//	dw_insert.Modify("steamcd.protect=1")
//End If
//
//dw_insert.SetItem(1, 'sarea', sarea)
//dw_insert.SetItem(1, 'steamcd', steam)

/* 영업부서 셋팅 */
//SELECT "P0_DEPT"."DEPTNAME2"
//INTO :sDeptName
//FROM "P1_MASTER","P0_DEPT"
//WHERE "P1_MASTER"."DEPTCODE" = "P0_DEPT"."DEPTCODE"
//AND		"P1_MASTER"."DEPTCODE" = :gs_dept
//AND		"P1_MASTER"."EMPNO" = :gs_empno	;	
//
//dw_insert.Object.t_deptno.text = gs_dept
//dw_insert.Object.t_deptname.text = sDeptName

If rb_cvcod.Checked = True Then
	sModStatus = 'C'
ElseIf rb_danga.Checked = True Then
	sModStatus = 'D'
End If

wf_init()


end event

type dw_insert from w_inherite`dw_insert within w_sal_05100_han
integer x = 1344
integer y = 500
integer width = 2048
integer height = 1212
integer taborder = 10
string dataobject = "d_sal_05100_han"
boolean border = false
end type

event dw_insert::itemchanged;String  sDateFrom,sDateTo,snull
String  sItnbr,sIttyp, sItcls,sItdsc, sIspec, sItemclsname, sIojpNo, sJijil, sIspeccode
String  sarea, steam, sCvcod, scvnas, sSaupj, sName1
Long    nRow, nCnt, ireturn

SetNull(snull)

nRow = GetRow()
If nRow <= 0 Then Return
Choose Case GetColumnName()
	Case  'saupj'
		sSaupj = Trim(GetText())
		
		f_child_saupj(dw_insert, 'steamcd', sSaupj)
		f_child_saupj(dw_insert, 'sarea', sSaupj)
	Case  "iojpno" 
		sIoJpNo = Mid(this.GetText(),1,12)
		IF sIoJpNo = "" OR IsNull(sIoJpNo) THEN RETURN
	
		SELECT COUNT("IMHIST"."IOJPNO")   INTO :nCnt
	  	  FROM "IMHIST"  
    	 WHERE ( "IMHIST"."SABU" = :gs_sabu ) AND 
	    	    ( SUBSTR("IMHIST"."IOJPNO",1,12) = :sIoJpNo ) AND
 		 		 ( "IMHIST"."JNPCRT" ='004') ;

		IF SQLCA.SQLCODE <> 0 THEN	  Return 2

  Case"sdatef"
	sDateFrom = Trim(this.GetText())
	IF sDateFrom ="" OR IsNull(sDateFrom) THEN RETURN
	
	IF f_datechk(sDateFrom) = -1 THEN
		f_message_chk(35,'[출고기간]')
		this.SetItem(1,"sdatef",snull)
		Return 1
	END IF
 Case "sdatet"
	sDateTo = Trim(this.GetText())
	IF sDateTo ="" OR IsNull(sDateTo) THEN RETURN
	
	IF f_datechk(sDateTo) = -1 THEN
		f_message_chk(35,'[출고기간]')
		this.SetItem(1,"sdatet",snull)
		Return 1
	END IF
/* 영업팀 */
 Case "steamcd"
	SetItem(1,'sarea',sNull)
	SetItem(1,"cvcod",sNull)
	SetItem(1,"cvcodnm",sNull)
/* 관할구역 */
 Case "sarea"
	SetItem(1,"cvcod",sNull)
	SetItem(1,"cvcodnm",sNull)

	sarea = this.GetText()
	IF sarea = "" OR IsNull(sarea) THEN RETURN
	
	SELECT "SAREA"."SAREA" ,"SAREA"."STEAMCD" 	INTO :sarea  ,:steam
		FROM "SAREA"  
		WHERE "SAREA"."SAREA" = :sarea   ;
		
   SetItem(1,'steamcd',steam)
	/* 거래처 */
	Case "cvcod"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"cvcodnm",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod', sNull)
			SetItem(1, 'cvcodnm', snull)
			Return 1
		ELSE
//			SetItem(1,"steamcd", steam)
//			SetItem(1,"sarea",   sarea)
			SetItem(1,"cvcodnm",	scvnas)
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
			SetItem(1, 'cvcodnm', snull)
			Return 1
		ELSE
//			SetItem(1,"steamcd",   steam)
//			SetItem(1,"sarea",   sarea)
			SetItem(1,'cvcod', sCvcod)
			SetItem(1,"cvcodnm", scvnas)
			Return 1
		END IF	
	/* 변경 거래처 */
	Case "vcvcod"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"vcvcodnm",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'vcvcod', sNull)
			SetItem(1, 'vcvcodnm', snull)
			Return 1
		ELSE
//			SetItem(1,"steamcd", steam)
//			SetItem(1,"sarea",   sarea)
			SetItem(1,"vcvcodnm",	scvnas)
		END IF
	/* 변경 거래처명 */
	Case "vcvcodnm"
		scvnas = Trim(GetText())
		IF scvnas ="" OR IsNull(scvnas) THEN
			SetItem(1,"vcvcod",snull)
			Return
		END IF
		
		If f_get_cvnames('2', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'vcvcod', sNull)
			SetItem(1, 'vcvcodnm', snull)
			Return 1
		ELSE
//			SetItem(1,"steamcd",   steam)
//			SetItem(1,"sarea",   sarea)
			SetItem(1,'vcvcod', sCvcod)
			SetItem(1,"vcvcodnm", scvnas)
			Return 1
		END IF		
	/* 품번 */
	Case "itnbr"
		sItnbr = trim(GetText())
	
		ireturn = f_get_name4_sale('품번', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		setitem(nRow, "itnbr", sitnbr)	
		setitem(nRow, "itdsc", sitdsc)	
		setitem(nRow, "ispec", sispec)
		setitem(nRow, "ispec_code", sispeccode)
//		setitem(nRow, "jijil", sjijil)
		RETURN ireturn
	/* 품명 */
	Case "itdsc"
		sItdsc = trim(GetText())
	
		ireturn = f_get_name4_sale('품명', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		setitem(nRow, "itnbr", sitnbr)	
		setitem(nRow, "itdsc", sitdsc)	
		setitem(nRow, "ispec", sispec)
		setitem(nRow, "ispec_code", sispeccode)
		setitem(nRow, "jijil", sjijil)
		RETURN ireturn
	/* 규격 */
	Case "ispec"
		sIspec = trim(GetText())
	
		ireturn = f_get_name4_sale('규격', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		setitem(nRow, "itnbr", sitnbr)	
		setitem(nRow, "itdsc", sitdsc)	
		setitem(nRow, "ispec", sispec)
		setitem(nRow, "ispec_code", sispeccode)
		setitem(nRow, "jijil", sjijil)
		RETURN ireturn
	/* 재질 */
//	Case "jijil"
//		sJijil = trim(GetText())
//	
//		ireturn = f_get_name4_sale('재질', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
//		setitem(nRow, "itnbr", sitnbr)	
//		setitem(nRow, "itdsc", sitdsc)	
//		setitem(nRow, "ispec", sispec)
//		setitem(nRow, "ispec_code", sispeccode)
//		setitem(nRow, "jijil", sjijil)
//		RETURN ireturn
	/* 규격코드 */
	Case "ispec_code"
		sIspecCode = trim(GetText())
	
		ireturn = f_get_name4_sale('규격코드', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		setitem(nRow, "itnbr", sitnbr)	
		setitem(nRow, "itdsc", sitdsc)	
		setitem(nRow, "ispec", sispec)
		setitem(nRow, "ispec_code", sispeccode)
		setitem(nRow, "jijil", sjijil)
		RETURN ireturn
END Choose
end event

event dw_insert::rbuttondown;string sCvcod
Long   nRow

SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

nRow = GetRow()
If nRow <= 0 Then Return

Choose Case this.GetColumnName()
	/* 거래처 */
	Case "cvcod", "cvcodnm"
		gs_gubun = '1'
		If GetColumnName() = "cvcodnm" then
			gs_codename = Trim(GetText())
		End If
		
		Open(w_vndmst_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN 2
		
		SetItem(1, 'cvcod', gs_code)
		TriggerEvent(ItemChanged!)
/* 변경 거래처 */
	Case "vcvcod", "vcvcodnm"
		gs_gubun = '1'
		If GetColumnName() = "vcvcodnm" then
			gs_codename = Trim(GetText())
		End If
		
		Open(w_vndmst_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN 2
		
		SetItem(1, 'vcvcod', gs_code)
		TriggerEvent(ItemChanged!)		
/* 품목 */
	Case "itnbr","itdsc","ispec"
		gs_gubun = '1'
		Open(w_itemas_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
		SetItem(nRow,"itnbr",gs_code)
		PostEvent(ItemChanged!)
	/* 출고승인 전표 */
	Case "iojpno" 
		sCvcod = Trim(GetItemString(nRow,'cvcod'))
		If IsNull(sCvcod) Then sCvcod = ''
		
		gs_code     = sCvcod
		gs_gubun    = '004'
		gs_codename = 'A'
		Open(w_imhist_02040_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		wf_set_iojpno(gs_code)
		SetColumn('ioprc')
END Choose
end event

event dw_insert::itemerror;return 1
end event

type p_delrow from w_inherite`p_delrow within w_sal_05100_han
integer y = 5000
integer taborder = 90
end type

type p_addrow from w_inherite`p_addrow within w_sal_05100_han
integer y = 5000
integer taborder = 80
end type

type p_search from w_inherite`p_search within w_sal_05100_han
integer y = 5000
integer taborder = 160
end type

type p_ins from w_inherite`p_ins within w_sal_05100_han
integer y = 5000
integer taborder = 50
end type

type p_exit from w_inherite`p_exit within w_sal_05100_han
integer x = 3136
integer y = 336
integer taborder = 0
end type

type p_can from w_inherite`p_can within w_sal_05100_han
boolean visible = false
integer x = 3049
integer y = 80
integer taborder = 150
end type

type p_print from w_inherite`p_print within w_sal_05100_han
integer y = 5000
integer taborder = 170
end type

type p_inq from w_inherite`p_inq within w_sal_05100_han
boolean visible = false
integer x = 3922
integer taborder = 20
end type

event p_inq::clicked;call super::clicked;//string sDatef,sDatet,sYymm,sIojpno,sItnbr,sSteamCd,sSArea,sCvcod, sPrtgbn, sToday, sSaupj, sPc
//Long   nCnt, ix
//string sOrderSpec
//double ddcrate, dItemQty
//decimal{2} ditemprice
// 
//If dw_insert.AcceptText() <> 1 then Return
//
//sDatef = Trim(dw_insert.GetItemString(1,'sdatef'))
//sDatet = Trim(dw_insert.GetItemString(1,'sdatet'))
//sPrtgbn = Trim(dw_insert.GetItemString(1,'prtgbn'))
//sSaupj = Trim(dw_insert.GetItemString(1,'saupj'))
//sPc	 = Trim(dw_insert.GetItemString(1,'spc'))
//sCvcod = Trim(dw_insert.GetItemString(1,'cvcod'))
//
//dw_insert.SetFocus()
//
//sYymm  = Left(sDatef,6)
//If IsNull(sdatef) Or sdatef = '' Or IsNull(sdatet) Or sdatet = '' Then
//   f_message_chk(1400,'[출고기간]')
//	dw_insert.SetColumn('sdatef')
//	Return 
//End If
//
//If Left(sDatef,6) <> Left(sDatet,6) Then
//	MessageBox('확 인','출고기간은 같은 년월만 가능합니다.!!')
//	Return
//End If
//
//If IsNull(sSaupj) Or sSaupj = '' Then
//   f_message_chk(1400,'[부가사업장]')
//	dw_insert.SetColumn('saupj')
//	Return 
//End If
//
//If IsNull(sCvcod) Or sCvcod = '' Then
//   f_message_chk(1400,'[거래처]')
//	dw_insert.SetColumn('cvcod')
//	Return 
//End If
//
///* 마감처리된 년월 확인 */
//  SELECT count("JUNPYO_CLOSING"."JPDAT"  )
//    INTO :nCnt
//    FROM "JUNPYO_CLOSING"  
//   WHERE ( "JUNPYO_CLOSING"."SABU" = :gs_sabu ) AND  
//         ( "JUNPYO_CLOSING"."JPGU" = 'G0' ) AND  
//         ( "JUNPYO_CLOSING"."JPDAT" >= :sYymm );
//
//If nCnt > 0 Then
//	f_message_chk(60,'')
//	Return 
//End If
//
///* 품번 */
//sItnbr = Trim(dw_insert.GetItemString(1,'itnbr'))
//If IsNull(sItnbr) Then sItnbr = ''
//
//sSteamCd = Trim(dw_insert.GetItemString(1,'steamcd'))
//sSArea   = Trim(dw_insert.GetItemString(1,'sarea'))
//
//If IsNull(sSteamCd) Then sSteamCd = ''
//If IsNull(sSArea)   Then sSarea = ''
//
//If dw_list.retrieve(gs_sabu, sdatef, sdatet, ssteamcd+'%', ssarea+'%', sCvcod, sItnbr+'%', sSaupj, spc) <= 0 Then
//	f_message_chk(300,'')
//	Return
//End If
//
//sToday = f_today()
//
//SetPointer(HourGlass!)
//
///* 할인율에 의한 할인율 */
//If sPrtGbn = '1' Then
//	For ix = 1 To dw_list.RowCount()
//		sCvcod 	  = dw_list.GetItemString(ix, "cvcod")
//		sOrderSpec = dw_list.GetItemString(ix, "order_spec")
//		sItnbr	  = dw_list.GetItemString(ix, "itnbr")
//		dItemQty	  = dw_list.GetItemNumber(ix, "ioqty")
//		
//		sqlca.Fun_Erp100000016(gs_sabu,  sToday, sCvcod, sItnbr, sOrderSpec, 'WON','1', dItemPrice, dDcRate)
//		If IsNull(dItemPrice) Then dItemPrice = 0
//		If IsNull(dDcRate) Then dDcRate = 0
//		
//		/* 단가 : 절사한다 */
//		dItemPrice = TrunCate(dItemPrice,0)
//		
//		/* 금액 계산 */	
//		dw_list.SetItem(ix,"vioprc", dItemPrice)
//		dw_list.SetItem(ix,"vioamt", TrunCate(dItemQty * dItemPrice,0))
//		dw_list.SetItem(ix,"vvatamt",TrunCate(dItemQty * dItemPrice*0.1,0))
//	Next
//End If
end event

type p_del from w_inherite`p_del within w_sal_05100_han
integer y = 5000
integer taborder = 140
end type

type p_mod from w_inherite`p_mod within w_sal_05100_han
boolean visible = false
integer x = 4096
integer taborder = 110
end type

event p_mod::clicked;call super::clicked;Long lCnt, li, lx, nCnt=0, lRow
Double dIoPrc, dIoAmt, dVatAmt
String sCvcod, sItnbr, sVcvcod

If dw_list.AcceptText() <> 1 Then Return

lCnt = dw_list.RowCount()
If lCnt <= 0 Then Return

sVcvcod = dw_insert.GetItemString(1,'vcvcod')
If IsNull(sVcvcod) = False Or Len(sVcvcod) > 1 Then
	wf_change_cvcod()
End If

IF dw_list.Modifiedcount() >= 1 THEN 
	DO WHILE lRow <= lCnt
		lRow = dw_list.GetNextModified(lRow, Primary!)
		IF lRow > 0 then
			
			For li = lRow To 1 Step -1
				sItnbr = Trim(dw_list.GetItemString(li, 'itnbr'))
				sCvcod = Trim(dw_list.GetItemString(li, 'cvcod'))
		
				If IsNull(sItnbr) Or sItnbr = '' Then
					dw_list.DeleteRow(li)
					continue
				End If
		
				If IsNull(sCvcod) Or sCvcod = '' Then
					dw_list.DeleteRow(li)
					continue
				End If	
			Next
		Else
			Exit
		END IF
		lx++
	LOOP
END IF

IF dw_list.Update() = 1 THEN
	COMMIT;
	MessageBox('확 인','총 '+string(lx)+'건 변경되었습니다.!!')
	w_mdi_frame.sle_msg.text ='자료를 저장하였습니다!!'
ELSE
	ROLLBACK;
	MessageBox('확 인',SQLCA.SQLErrText)
END IF

p_inq.Post Event Clicked()

ib_any_typing = false



end event

type cb_exit from w_inherite`cb_exit within w_sal_05100_han
integer x = 3735
integer y = 2484
integer taborder = 120
boolean enabled = false
end type

type cb_mod from w_inherite`cb_mod within w_sal_05100_han
integer x = 878
integer y = 2416
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within w_sal_05100_han
integer x = 517
integer y = 2416
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_sal_05100_han
integer x = 1239
integer y = 2416
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_sal_05100_han
integer x = 2880
integer y = 2472
boolean enabled = false
end type

type cb_print from w_inherite`cb_print within w_sal_05100_han
integer x = 1961
integer y = 2416
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_sal_05100_han
end type

type cb_can from w_inherite`cb_can within w_sal_05100_han
integer x = 3365
integer y = 2496
integer taborder = 100
boolean enabled = false
end type

type cb_search from w_inherite`cb_search within w_sal_05100_han
integer x = 3918
integer y = 2508
integer width = 334
integer taborder = 70
boolean enabled = false
string text = "저장(&P)"
end type

type dw_datetime from w_inherite`dw_datetime within w_sal_05100_han
boolean enabled = false
end type

type sle_msg from w_inherite`sle_msg within w_sal_05100_han
boolean enabled = false
end type

type gb_10 from w_inherite`gb_10 within w_sal_05100_han
boolean enabled = false
end type

type gb_button1 from w_inherite`gb_button1 within w_sal_05100_han
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_05100_han
end type

type cbx_1 from checkbox within w_sal_05100_han
boolean visible = false
integer x = 4192
integer y = 248
integer width = 389
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "전체선택"
boolean lefttext = true
end type

event clicked;long ll_count
string ls_status

if this.checked=true then
	ls_status='Y'
elseif this.checked=false then
	ls_status='N'
else
	setnull(ls_status)
end if

 for ll_count=1 to dw_list.rowcount()
	dw_list.setitem(ll_count,'chk',ls_status)
next

end event

type rr_1 from roundrectangle within w_sal_05100_han
boolean visible = false
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 5
integer y = 352
integer width = 4626
integer height = 1916
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_list from u_d_select_sort within w_sal_05100_han
boolean visible = false
integer x = 37
integer y = 64
integer height = 276
integer taborder = 30
boolean bringtotop = true
boolean enabled = false
string dataobject = "d_sal_05100_ds"
boolean hscrollbar = false
boolean vscrollbar = false
boolean border = false
boolean livescroll = false
end type

event itemchanged;call super::itemchanged;Long nRow
Dec	dIoPrc, dIoQty, dIoamt, dVatamt, ld_calvalue
String sNCvcod

nRow = GetRow()
If nRow <= 0 Then Return
this.AcceptText()

Choose Case GetColumnName()
	Case 'vioprc'
		dIoPrc = Dec(GetText())
		
		dIoQty = GetItemNumber(nRow, 'ioqty')
		ld_calvalue = GetItemNumber(nRow, 'iomatrix_calvalue')
		
		SetItem(nRow, 'ioprc', dIoPrc)
		SetItem(nRow, 'vioamt', TrunCate(dIoPrc * dIoQty * ld_calvalue,0))
		SetItem(nRow, 'vvatamt', TrunCate(dIoPrc * dIoQty *0.1 * ld_calvalue,0))
		
		dIoamt = abs(dw_list.GetItemNumber(nRow, 'vioamt')) //절대값 처리
		dVatamt = abs(dw_list.GetItemNumber(nRow, 'vvatamt'))
		
		SetItem(nRow, 'ioamt', dIoAmt)
		SetItem(nRow, 'dyebi3', dVatAmt)
	Case 'vioamt'
		dIoamt = Dec(GetText())
		dIoQty = GetItemNumber(nRow, 'ioqty')
		
		SetItem(nRow, 'ioprc', dIoamt / dIoqty)
		SetItem(nRow, 'vioprc', dIoamt / dIoqty)
		SetItem(nRow, 'vvatamt', TrunCate(dIoamt *0.1,0))
		
		dIoamt = abs(dw_list.GetItemNumber(nRow, 'vioamt')) //절대값 처리
		dVatamt = abs(dw_list.GetItemNumber(nRow, 'vvatamt'))
		
		SetItem(nRow, 'ioamt', dIoAmt)
		SetItem(nRow, 'dyebi3', dVatAmt)
	Case Else
		dVatamt = abs(dw_list.GetItemNumber(nRow, 'vvatamt'))
		
		SetItem(nRow, 'dyebi3', dVatAmt)
End Choose

sNCvcod = dw_insert.GetItemString(1,'vcvcod')
If IsNull(sNCvcod) = False Or Len(sNCvcod) >= 1 Then
	SetItem(nRow,'cvcod', sNCvcod)
End If

end event

type rb_3 from radiobutton within w_sal_05100_han
boolean visible = false
integer x = 3511
integer y = 324
integer width = 279
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "전체"
boolean checked = true
end type

event clicked;dw_list.setFilter("")
dw_list.Filter()

//dw_print.setFilter("")
//dw_print.Filter()
end event

type rb_4 from radiobutton within w_sal_05100_han
boolean visible = false
integer x = 3913
integer y = 324
integer width = 293
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "OEM"
end type

event clicked;dw_list.SetFilter( "imhist_pspec = 'OEM'")
dw_list.Filter()

//dw_print.SetFilter( "imhist_pspec = 'OEM'")
//dw_print.Filter()
end event

type rb_5 from radiobutton within w_sal_05100_han
boolean visible = false
integer x = 4306
integer y = 324
integer width = 302
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "CKD"
end type

event clicked;dw_list.SetFilter( "imhist_pspec = 'CKD'")
dw_list.Filter()

//dw_print.SetFilter( "imhist_pspec = 'CKD'")
//dw_print.Filter()
end event

type pb_1 from u_pb_cal within w_sal_05100_han
integer x = 2464
integer y = 1260
integer width = 78
integer height = 72
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_insert.SetColumn('sdatef')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_insert.SetItem(1, 'sdatef', gs_code)

end event

type pb_2 from u_pb_cal within w_sal_05100_han
integer x = 2939
integer y = 1260
integer width = 82
integer height = 72
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_insert.SetColumn('sdatet')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_insert.SetItem(1, 'sdatet', gs_code)

end event

type p_1 from uo_picture within w_sal_05100_han
integer x = 2953
integer y = 336
boolean bringtotop = true
string picturename = "C:\ERPMAN\image\일괄변경_up.gif"
end type

event clicked;call super::clicked;string sDatef, sDatet, sYymm, sIojpno, sDandate, sSaupj, sNCvcod, sOCvcod
Long   nCnt, ix
string sOrderSpec
double ditemprice,ddcrate, dItemQty, dConprc

If dw_insert.AcceptText() <> 1 then Return

sSaupj = Trim(dw_insert.GetItemString(1,'saupj'))
sOCvcod = Trim(dw_insert.GetItemString(1,'cvcod'))
sNcvcod = Trim(dw_insert.GetItemString(1,'vcvcod'))
sDandate = Trim(dw_insert.GetItemString(1,'sdandate'))
sDatef = Trim(dw_insert.GetItemString(1,'sdatef'))
sDatet = Trim(dw_insert.GetItemString(1,'sdatet'))

dw_insert.SetFocus()

If IsNull(sSaupj) Or sSaupj = '' Then
   f_message_chk(1400,'[부가사업장]')
	dw_insert.SetColumn('saupj')
	Return 
End If

If IsNull(sdatef) Or sdatef = '' Or IsNull(sdatet) Or sdatet = '' Then
   f_message_chk(1400,'[출고기간]')
	dw_insert.SetColumn('sdatef')
	Return 
End If

if sModStatus = 'C' then
	If IsNull(sOCvcod) Or sOCvcod = '' Then
		f_message_chk(1400,'[거래처]')
		dw_insert.SetColumn('cvcod')
		Return 
	End If
	
	If IsNull(sNcvcod) Or sNcvcod = '' Then
		f_message_chk(1400,'[변경후거래처]')
		dw_insert.SetColumn('vcvcod')
		Return 
	End If
else
	If IsNull(sDandate) Or sDandate = '' Then
		f_message_chk(1400,'[단가기준일자]')
		dw_insert.SetColumn('sDandate')
		Return 
	End If
end if

If Messagebox('확인','거래처 매출 일괄변경 작업을 진행하시겠습니까?', Exclamation!,Okcancel!,1) = 2 Then
	Return
Else
	if sModStatus = 'C' then
		nCnt = wf_change_cvcod(sNcvcod, sOcvcod, sDatef, sDatet)
		If nCnt > 0 Then
			MessageBox('거래처 일괄변경','거래처 변경 작업이 완료되었습니다.')
   		End If
	else
		nCnt = wf_change_danga(sOCvcod, sDandate, sDatef, sDatet)
		If nCnt > 0 Then
			MessageBox('단가 일괄변경','단가 변경 작업이 완료되었습니다.')
   		End If
	end if 	
End If

ib_any_typing = false








end event

type rb_cvcod from radiobutton within w_sal_05100_han
integer x = 1426
integer y = 384
integer width = 416
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "거래처변경"
boolean checked = true
end type

event clicked;sModStatus = 'C'

Wf_Init()

end event

type rb_danga from radiobutton within w_sal_05100_han
integer x = 1925
integer y = 384
integer width = 334
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "단가변경"
end type

event clicked;sModStatus = 'D'

Wf_Init()
end event

type gb_2 from groupbox within w_sal_05100_han
boolean visible = false
integer x = 3451
integer y = 256
integer width = 1175
integer height = 144
integer taborder = 130
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "출력 Filter"
end type

type rr_2 from roundrectangle within w_sal_05100_han
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 1367
integer y = 360
integer width = 946
integer height = 124
integer cornerheight = 40
integer cornerwidth = 55
end type

