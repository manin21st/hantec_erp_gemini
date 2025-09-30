$PBExportHeader$w_sal_01700.srw
$PBExportComments$견적의뢰 등록
forward
global type w_sal_01700 from w_inherite
end type
type gb_3 from groupbox within w_sal_01700
end type
type rb_new from radiobutton within w_sal_01700
end type
type rb_mod from radiobutton within w_sal_01700
end type
type dw_ip from datawindow within w_sal_01700
end type
type rr_1 from roundrectangle within w_sal_01700
end type
type rr_2 from roundrectangle within w_sal_01700
end type
end forward

global type w_sal_01700 from w_inherite
string title = "견적의뢰 등록"
gb_3 gb_3
rb_new rb_new
rb_mod rb_mod
dw_ip dw_ip
rr_1 rr_1
rr_2 rr_2
end type
global w_sal_01700 w_sal_01700

forward prototypes
public function integer wf_std_offer (string arg_ofno, string arg_ofdate)
public function integer wf_init ()
public function integer wf_check_itnbr (integer nrow)
public function integer wf_check_esti ()
end prototypes

public function integer wf_std_offer (string arg_ofno, string arg_ofdate);String sMaxOfNo, sNull
Long   ix

SetNull(sNull)

If IsNull(arg_ofno) Or arg_ofno = '' Then Return 1

SELECT MAX(OFNO) INTO :sMaxOfNo
  FROM OFHEAD
 WHERE STDOFNO = :arg_ofno AND
       OFSTS IN ( '1','2','3' );

If IsNull(sMaxOfNo) Or Trim(sMaxOfNo) = '' Then
	MessageBox('확 인','해당하는 견적번호가 없습니다.!!')
	dw_ip.SetItem(1, 'stdofno', sNull)
	Return -1
End If

/* 조회 */
If dw_ip.Retrieve(gs_sabu, sMaxOfNo) <= 0 Then
	dw_ip.SetColumn("ofno")
	dw_ip.SetFocus()
	wf_init()
	Return -1
Else
	dw_insert.Retrieve(gs_sabu, sMaxOfNo)
End If

dw_ip.SetItem(1, 'ofno', sNull)
dw_ip.SetItem(1, 'ofdate', arg_ofdate)
dw_ip.SetItem(1, 'pjtno', sNull)
dw_ip.SetItem(1, 'reqdate', sNull)
dw_ip.SetItem(1, 'vtdate', sNull)
dw_ip.SetItem(1, 'ofsts', '1')
dw_ip.SetItem(1, 'ofmemo', sNull)
dw_ip.SetItem(1, 'wrate', 0)

dw_ip.SetItemStatus(1, 0, Primary!, NewModified!)

For ix = 1 To dw_insert.RowCount()
	dw_insert.SetItem(ix, 'ofno', sNull)
//	dw_insert.SetItem(ix, 'dlidate', sNull)
//	dw_insert.SetItem(ix, 'cfmdate', sNull)
//	dw_insert.SetItem(ix, 'cfmempno', sNull)
	dw_insert.SetItem(ix, 'frcdate', sNull)
	dw_insert.SetItem(ix, 'reqdate', sNull)
	
	dw_insert.SetItemStatus(ix, 0, Primary!, NewModified!)
Next

Return 1
end function

public function integer wf_init ();dw_insert.Reset()

dw_ip.SetRedraw(False)
dw_ip.Reset()
dw_ip.InsertRow(0)

dw_ip.SetFocus()
If rb_new.Checked = True Then
	dw_ip.Modify('ofno.protect = 1')
	//dw_ip.Modify('ofno.background.color = 80859087')
	dw_ip.Modify('ofdate.protect = 0')
	//dw_ip.Modify("ofdate.background.color = '"+String(Rgb(190,225,184))+"'")	
	
	dw_ip.SetColumn('ofdate')
Else
	dw_ip.Modify('ofno.protect = 0')
	//dw_ip.Modify("ofno.background.color = '"+String(Rgb(255,255,0))+"'")
	dw_ip.Modify('ofdate.protect = 1')
	//dw_ip.Modify('ofdate.background.color = 80859087')
	
	dw_ip.SetColumn('ofno')
End If

dw_ip.SetRedraw(True)

p_search.Enabled = False
p_search.PictureName = 'C:\erpman\image\견적이력조회_d.gif'
ib_any_typing= FALSE

Return 1
end function

public function integer wf_check_itnbr (integer nrow);String sItdsc, sIspec, sOfEmpno, sPdept
Double dofqty, dOfprc

If nRow > dw_insert.RowCount() Or nRow <= 0 Then Return 0
If dw_insert.AcceptText() <> 1 Then Return -1

dw_insert.SetFocus()
dw_insert.ScrollToRow(nRow)

sItdsc	= Trim(dw_insert.GetItemString(nRow, 'itdsc'))
If IsNull(sItdsc) Or sItdsc = '' Then
	f_message_chk(1400,'[품명]')
	dw_insert.SetColumn('itdsc')
	Return -1
End If

//sIspec	= Trim(dw_insert.GetItemString(nRow, 'ispec'))
//If IsNull(sIspec) Or sIspec = '' Then
//	f_message_chk(1400,'[규격]')
//	dw_insert.SetColumn('ispec')
//	Return -1
//End If

sOfEmpno	= Trim(dw_insert.GetItemString(nRow, 'ofempno'))
If IsNull(sOfEmpno) Or sOfEmpno = '' Then
	f_message_chk(1400,'[처리담당자]')
	dw_insert.SetColumn('ofempno')
	Return -1
End If

sPdept	= Trim(dw_insert.GetItemString(nRow, 'pdept'))
If IsNull(sPdept) Or sPdept = '' Then
	f_message_chk(1400,'[원가부서]')
	dw_insert.SetColumn('pdept')
	Return -1
End If

dofqty	= dw_insert.GetItemNumber(nRow, 'ofqty')
If IsNull(dofqty) Or dofqty = 0 Then
	f_message_chk(1400,'[예상판매수량]')
	dw_insert.SetColumn('ofqty')
	Return -1
End If

dOfprc	= dw_insert.GetItemNumber(nRow, 'ofprc')
If IsNull(dofprc) Or dofprc = 0 Then
	f_message_chk(1400,'[견적예상가]')
	dw_insert.SetColumn('ofprc')
	Return -1
End If

Return 0
end function

public function integer wf_check_esti ();String sOfdate, sdeptno, sempno, sreqdate, sofgb, svtdate, sOfsts, sClsgb, sClsCause

If dw_ip.AcceptText() <> 1 Then Return -1

dw_ip.SetFocus()

sOfdate	= Trim(dw_ip.GetItemString(1, 'ofdate'))
If IsNull(sOfdate) Or sOfdate = '' Then
	f_message_chk(1400,'[견적의뢰일]')
	dw_ip.SetColumn('ofdate')
	Return -1
End If

sDeptNo	= Trim(dw_ip.GetItemString(1, 'deptno'))
If IsNull(sDeptNo) Or sDeptNo = '' Then
	f_message_chk(1400,'[접수부서]')
	dw_ip.SetColumn('deptno')
	Return -1
End If

sEmpno	= Trim(dw_ip.GetItemString(1, 'empno'))
If IsNull(sEmpno) Or sEmpno = '' Then
	f_message_chk(1400,'[견적담당자]')
	dw_ip.SetColumn('empno')
	Return -1
End If

sReqDate	= Trim(dw_ip.GetItemString(1, 'reqdate'))
If IsNull(sReqDate) Or sReqDate = '' Then
	f_message_chk(1400,'[처리요구일]')
	dw_ip.SetColumn('reqdate')
	Return -1
End If

sOfgb	= Trim(dw_ip.GetItemString(1, 'ofgb'))
If IsNull(sOfgb) Or sOfgb = '' Then
	f_message_chk(1400,'[견적구분]')
	dw_ip.SetColumn('ofgb')
	Return -1
End If

svtDate	= Trim(dw_ip.GetItemString(1, 'vtdate'))
If IsNull(svtDate) Or svtDate = '' Then
	f_message_chk(1400,'[견적유효일]')
	dw_ip.SetColumn('vtdate')
	Return -1
End If

sOfsts	= Trim(dw_ip.GetItemString(1, 'ofsts'))
If sOfsts = '8' Then
	sClsgb	 = Trim(dw_ip.GetItemString(1, 'clsgb'))
	If IsNull(sClsgb) Or sClsgb = '' Then
		f_message_chk(1400,'[취소구분]')
		dw_ip.SetColumn('clsgb')
		Return -1
	End If

	sClsCause = Trim(dw_ip.GetItemString(1, 'clscause'))
	If IsNull(sClsCause) Or sClsCause = '' Then
		f_message_chk(1400,'[취소사유]')
		dw_ip.SetColumn('clscause')
		Return -1
	End If
End If

Return 0
end function

on w_sal_01700.create
int iCurrent
call super::create
this.gb_3=create gb_3
this.rb_new=create rb_new
this.rb_mod=create rb_mod
this.dw_ip=create dw_ip
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_3
this.Control[iCurrent+2]=this.rb_new
this.Control[iCurrent+3]=this.rb_mod
this.Control[iCurrent+4]=this.dw_ip
this.Control[iCurrent+5]=this.rr_1
this.Control[iCurrent+6]=this.rr_2
end on

on w_sal_01700.destroy
call super::destroy
destroy(this.gb_3)
destroy(this.rb_new)
destroy(this.rb_mod)
destroy(this.dw_ip)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event w_sal_01700::open;call super::open;dw_ip.SetTransObject(sqlca)
dw_insert.SetTransObject(sqlca)

/* 규격,재질 Text 변경 */
//If f_change_name('1') = 'Y' Then
//	String sIspecText, sJijilText
//	
//	sIspecText = f_change_name('2')
//	sJijilText = f_change_name('3')
//	
//	dw_insert.Object.ispec_t.text =  sIspecText 
//	dw_insert.Object.jijil_t.text =  sJijilText
//End If

p_can.TriggerEvent(Clicked!)
end event

type dw_insert from w_inherite`dw_insert within w_sal_01700
integer x = 73
integer y = 912
integer width = 4489
integer height = 1360
integer taborder = 10
string dataobject = "d_sal_017001"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event dw_insert::itemchanged;String sNull, sGet_name, sItnbr, sItdsc, sIspec, sJijil, sPcode, sOfDate, sOrderSpec, sIttyp, sItcls, sTitnm
Long 	 nRow
dec 	 dIrate, dTtamt, dOfPrc
Int    ireturn

SetNull(sNull)
nRow = GetRow()
If nRow <= 0 Then Return

Choose Case GetColumnName()
	/* 품번 */
	Case	"itnbr" 
		sItnbr = Trim(GetText())
		IF sItnbr ="" OR IsNull(sItnbr) THEN
			SetItem(nRow,'itdsc',sNull)
			SetItem(nRow,'ispec',sNull)
			SetItem(nRow,'jijil',sNull)
			SetItem(nRow,'ittyp',sNull)
			SetItem(nRow,'itcls',sNull)
			SetItem(nRow,'titnm',sNull)
			Return
		END IF
		
		SELECT "ITEMAS"."ITDSC", "ITEMAS"."ISPEC", "ITEMAS"."JIJIL", "ITEMAS"."ITTYP", "ITEMAS"."ITCLS", "ITNCT"."TITNM"
		  INTO :sItdsc, :sIspec, :sJijil, :sIttyp, :sItcls, :sTitnm
		  FROM "ITEMAS", "ITNCT"
		 WHERE "ITEMAS"."ITNBR" = :sItnbr 
		   AND "ITEMAS"."ITTYP" = "ITNCT"."ITTYP"
			AND "ITEMAS"."ITCLS" = "ITNCT"."ITCLS";
		
		IF SQLCA.SQLCODE <> 0 THEN
			PostEvent(RbuttonDown!)
			Return 2
		END IF
		
		/* 기본판매단가 */
		dOfPrc = sqlca.fun_erp100000012(is_today, sItnbr, '.');
		If IsNull(dOfprc) Then dOfprc = 0
			
		SetItem(nRow,"itdsc", sItdsc)
		SetItem(nRow,"ispec", sIspec)
		SetItem(nRow,"jijil", sJijil)
		SetItem(nRow,'ittyp', sIttyp)
		SetItem(nRow,'itcls', sItcls)
		SetItem(nRow,'titnm', sTitnm)
		SetItem(nRow,'ofprc', dOfprc)
	Case 'itcls'
		sItnbr = GetText()
		sispec = getitemstring(1, 'ittyp')
		
		if sitnbr = '' or isnull(sitnbr) then 
			setitem(nRow, "ittyp", sNull)	
			setitem(nRow, "titnm", sNull)	
			return
		end if	
		
		ireturn = f_get_name2('품목분류', 'Y', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
		setitem(nRow, "itcls", sitnbr)
		setitem(nRow, "titnm", sitdsc)
		
		RETURN ireturn	
	/* 원가부서 */
   Case 'pdept'
		String sdptno
		
		sdptno = Trim(GetText())
		
		IF sdptno ="" OR IsNull(sdptno) THEN 
			SetItem(nRow,"pdeptnm",sNull)
			RETURN
		END IF
		
		SELECT "VNDMST"."CVNAS2"  INTO :sget_name  
		  FROM "VNDMST"  
		 WHERE "VNDMST"."CVCOD" = :sdptno  AND "VNDMST"."CVGU" = '4' ;
		
		IF SQLCA.SQLCODE = 0 THEN
			SetItem(nRow,"pdeptnm",sget_name)
		ELSE
			TriggerEvent(RbuttonDown!)
			IF gs_code ="" OR IsNull(gs_code) THEN 
				SetItem(nRow,"pdept",snull)
				SetItem(nRow,"pdeptnm",snull)
			END IF
			
			Return 1	
		END IF
	/* 일자 */
	Case "frcdate", "reqdate"
		sOfDate = Trim(GetText())
		IF sOfDate ="" OR IsNull(sOfDate) THEN RETURN
		
		IF f_datechk(sOfDate) = -1 THEN
			f_message_chk(35,'[일자]')
			SetItem(nRow, GetColumnName(), sNull)
			Return 1
		End If
	/* 이윤 */
	Case 'irate'
		dIrate = Dec(GetText())
		If IsNull(dIrate ) Then dIrate = 0
		
		dTtAmt = GetItemNumber(nRow, 'ttamt')
		If IsNull(dTtAmt) Then dTtAmt = 0
		
		SetItem(nRow, 'ofamt', truncate( dttamt + (dttamt * dirate/100),0))
	/* 사양 */
	Case 'order_spec'
		sOrderSpec = Trim(GetText())
			
		IF sOrderSpec = "" OR IsNull(sOrderSpec) THEN	
			SetItem(nRow,"order_spec",'.')
			Return 2
		End If
End Choose
end event

event dw_insert::rbuttondown;String sIttyp
str_itnct lstr_sitnct

Long nRow


SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

nRow = GetRow()
If nRow <= 0 Then Return

Choose Case GetColumnName()
	/* 원가부서 */
   Case "pdept"
		Open(w_vndmst_4_popup)
		IF isnull(gs_Code)  or  gs_Code = ''	then  return
		
		SetItem(nRow, "pdept", gs_Code)
		SetItem(nRow, "pdeptnm", gs_Codename)
	/* 품번 */
	Case "itnbr"
		Open(w_itemas_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
		SetItem(nRow,GetColumnName(),gs_code)
		SetFocus()
		SetColumn(GetColumnName())
		PostEvent(ItemChanged!)
	Case 'itcls'
		sIttyp = GetItemString(nRow, 'ittyp')
		OpenWithParm(w_ittyp_popup, sIttyp)
		
		lstr_sitnct = Message.PowerObjectParm	
		
		if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
		
		SetItem(nRow, "ittyp", lstr_sitnct.s_ittyp)
		SetItem(nRow, "itcls", lstr_sitnct.s_sumgub)
		SetItem(nRow, "titnm", lstr_sitnct.s_titnm)	
End Choose
end event

event dw_insert::itemerror;call super::itemerror;return 1
end event

event dw_insert::rowfocuschanged;String sOfsts

If currentrow <= 0 Then Return

/* 접수이상이면 수정불가 */
sOfsts = GetItemString(currentrow, 'ofsts')
If sOfsts >= '1' Then
	p_del.Enabled = False
	p_del.PictureName = 'C:\erpman\image\삭제_d.gif'
Else
	p_del.Enabled = True
	p_del.PictureName = 'C:\erpman\image\삭제_up.gif'
End If
end event

type p_delrow from w_inherite`p_delrow within w_sal_01700
boolean visible = false
integer x = 4142
integer y = 3340
end type

type p_addrow from w_inherite`p_addrow within w_sal_01700
boolean visible = false
integer x = 3968
integer y = 3340
end type

type p_search from w_inherite`p_search within w_sal_01700
integer x = 3127
integer width = 274
string picturename = "C:\erpman\image\견적이력조회_up.gif"
end type

event p_search::clicked;call super::clicked;Open(w_sal_01710)
end event

event p_search::ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\견적이력조회_dn.gif"
end event

event p_search::ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\견적이력조회_up.gif"
end event

type p_ins from w_inherite`p_ins within w_sal_01700
integer x = 3744
end type

event p_ins::clicked;call super::clicked;String sOfno
Long	 nRow

If dw_ip.AcceptText() <> 1 Then Return

If rb_mod.Checked = True Then
	sOfNo = Trim(dw_ip.GetItemString(1,"ofno"))

  IF sOfno = "" OR IsNull(sOfno) THEN
	  f_message_chk(1400,'[견적번호]')
	  Return
  End If
Else
	sOfno = ''
END IF

/* Data Check */
nRow = dw_insert.RowCount()
If nRow > 0 Then
	If wf_check_itnbr(nRow) <> 0 Then
		Return
	End If
End If

nRow += 1
nRow = dw_insert.InsertRow(nRow)
dw_insert.ScrollToRow(nRow)
dw_insert.SetFocus()
end event

type p_exit from w_inherite`p_exit within w_sal_01700
end type

type p_can from w_inherite`p_can within w_sal_01700
end type

event p_can::clicked;call super::clicked;wf_init()
end event

type p_print from w_inherite`p_print within w_sal_01700
integer x = 3397
string picturename = "C:\erpman\image\견적삭제_up.gif"
end type

event p_print::clicked;call super::clicked;String sOfNo

If dw_ip.AcceptText() <> 1 Then Return
If dw_insert.AcceptText() <> 1 Then Return

IF	 MessageBox("삭제 확인", "견적 전체를 삭제하시겠습니까? ",question!, yesNo!)  = 2 THEN return  

/* 등록일 경우 */
If rb_new.Checked = True Then
Else
	sOfNo = Trim(dw_ip.GetItemString(1,'ofno'))
	
	IF IsNull(sOfNo) Or sOfNo = '' THEN
		f_message_chk(1400,'[견적번호]')
		Return
	End If	
End If

dw_ip.DeleteRow(0)
If dw_ip.Update() <> 1 Then
	RollBack;
	MessageBox('확 인','자료 삭제에 실패하였습니다!!')
	Return
End If

dw_insert.RowsMove(1, dw_insert.RowCount(), Primary!, dw_insert, 1, Delete!)
If dw_insert.Update() <> 1 Then
	RollBack;
	MessageBox('확 인','자료 삭제에 실패하였습니다!!')
	Return
End If

commit;

wf_init()

w_mdi_frame.sle_msg.Text = '자료를 삭제하였습니다.!!'
end event

event p_print::ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\견적삭제_dn.gif"
end event

event p_print::ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\견적삭제_up.gif"
end event

type p_inq from w_inherite`p_inq within w_sal_01700
integer x = 3570
end type

event p_inq::clicked;call super::clicked;String sofno
Long   nCnt

If rb_new.Checked = True Then Return

If dw_ip.AcceptText() <> 1 Then Return

sofno = Trim(dw_ip.GetItemString(1,'ofno'))

If IsNull(sofno) Or sofno = '' Then
	f_message_chk(30,'[견적번호]')
	Return
End If

/* 조회 */
If dw_ip.Retrieve(gs_sabu, sofno) <= 0 Then
	f_message_chk(50,'')
	dw_ip.SetColumn("ofno")
	dw_ip.SetFocus()
	wf_init()
	Return
Else
	dw_insert.Retrieve(gs_sabu, sofno)
	
	dw_ip.Modify('ofno.protect = 1')
	//dw_ip.Modify('ofno.background.color = 80859087')
	dw_ip.Modify('ofdate.protect = 1')
	//dw_ip.Modify('ofdate.background.color = 80859087')
		
	/* 접수이상이면 수정불가 */
	If dw_insert.RowCount() > 0 Then
		nCnt = dw_insert.GetItemNumber(1, 'cnt_ofsts')
		If nCnt >= 1 Then
			p_print.Enabled = False
			p_print.PictureName = 'C:\erpman\image\견적삭제_d.gif'
		Else
			p_print.Enabled = True
			p_print.PictureName = 'C:\erpman\image\견적삭제_up.gif'
		End If
	Else
		p_print.Enabled = True
		p_print.PictureName = 'C:\erpman\image\견적삭제_up.gif'
	End If

	p_search.Enabled = True
	p_search.PictureName = 'C:\erpman\image\견적이력조회_up.gif'
	
END IF

dw_ip.SetFocus()
end event

type p_del from w_inherite`p_del within w_sal_01700
end type

event p_del::clicked;call super::clicked;String sOfNo

If dw_ip.AcceptText() <> 1 Then Return
If dw_insert.AcceptText() <> 1 Then Return

IF	 MessageBox("삭제 확인", "삭제하시겠습니까? ",question!, yesNo!)  = 2 THEN return  

/* 등록일 경우 */
If rb_new.Checked = True Then
	dw_insert.DeleteRow(0)
	
	w_mdi_frame.sle_msg.Text = '자료를 삭제하였습니다.!!'
	
	Return
Else
	sOfNo = Trim(dw_ip.GetItemString(1,'ofno'))
	
	IF IsNull(sOfNo) Or sOfNo = '' THEN
		f_message_chk(1400,'[견적번호]')
		Return
	End If	
End If

dw_insert.SetRedraw(False)
dw_insert.DeleteRow(0)
If dw_insert.Update() <> 1 Then
	RollBack;
	MessageBox('확 인','자료 삭제에 실패하였습니다!!')
	dw_insert.SetRedraw(True)
	Return
End If

commit;

dw_insert.SetRedraw(True)
w_mdi_frame.sle_msg.Text = '자료를 삭제하였습니다.!!'
end event

type p_mod from w_inherite`p_mod within w_sal_01700
end type

event p_mod::clicked;call super::clicked;String sNull, sOfNo, sOfDate
Int	iOfseq, nseq, nrcnt, k
dwItemStatus  dwSts
		
SetNull(sNull)

If wf_check_esti() <> 0 then Return

nRcnt = dw_insert.RowCount()
If nRCnt > 0 Then
	If wf_check_itnbr(nRcnt)   <> 0 then 
		Return
	End If
End If

IF F_Msg_Update() = -1 THEN Return

/* 견적번호 채번 */
IF rb_new.Checked = True THEN	
	sOfDate = Trim(dw_ip.GetItemString(1, 'ofdate'))
	
	iOfSeq = sqlca.fun_junpyo(gs_sabu,sOfDate,'S1')
	IF iOfSeq <= 0 THEN
		ROLLBACK;
		f_message_chk(51,'')
		Return
	END IF
	
	sOfNo = sOfDate + String(iOfseq,'0000')
	Commit;

	dw_ip.SetItem(1,"sabu", gs_sabu)
	dw_ip.SetItem(1,"ofno", sOfNo)
	MessageBox("확 인","채번된 견적번호는 "+sOfNo+" 번 입니다!!")
ELSE
	sOfNo = Trim(dw_ip.GetItemString(1,"ofno"))
END IF

IF sOfNo = "" OR IsNull(sOfNo) THEN
	rollback;
	f_message_chk(51,'[견적번호]')
	Return
End If

/* 수주번호 최대값 */
If dw_insert.Rowcount() > 0 Then
	nSeq = dw_insert.GetItemNumber(1,'maxseq')
	If IsNull(nSeq) or nSeq < 0 Then nSeq = 0 
End If

SetPointer(HourGlass!)

nRCnt = 0
FOR k = 1 To dw_insert.Rowcount()
	/* 기존 보류등 견적상태를 유지하기위해 신규만 상태를 반영한다 */
	dwSts = dw_insert.GetItemStatus(k,0,Primary!)
	If dwSts = NewModified! Then
		nSeq += 1
		If nSeq > 999 Then
			MessageBox('오류','견적번호 순번이 999번을 초과했습니다')
			RollBack;
			Return
		End If
	
		dw_insert.SetItem(k,"sabu",       gs_sabu)
		dw_insert.SetItem(k,"ofno",		 sOfNo)
		dw_insert.SetItem(k,"ofseq",   	 nSeq)
	End If
		
	nRCnt += 1
NEXT

If dw_ip.Update() <> 1 Then
	RollBack;
	f_message_chk(32,'')
Else
	If dw_insert.Update() <> 1 Then
		RollBack;
		f_message_chk(32,'')
		Return
	End If
	
	COMMIT;
	
	Wf_Init()
End If

w_mdi_frame.sle_msg.text ='자료를 저장하였습니다!!'
end event

type cb_exit from w_inherite`cb_exit within w_sal_01700
boolean visible = false
integer taborder = 120
end type

type cb_mod from w_inherite`cb_mod within w_sal_01700
boolean visible = false
integer x = 2149
integer taborder = 60
end type

event cb_mod::clicked;call super::clicked;//String sNull, sOfNo, sOfDate
//Int	iOfseq, nseq, nrcnt, k
//dwItemStatus  dwSts
//		
//SetNull(sNull)
//
//If wf_check_esti() <> 0 then Return
//
//nRcnt = dw_insert.RowCount()
//If nRCnt > 0 Then
//	If wf_check_itnbr(nRcnt)   <> 0 then 
//		Return
//	End If
//End If
//
//IF F_Msg_Update() = -1 THEN Return
//
///* 견적번호 채번 */
//IF rb_new.Checked = True THEN	
//	sOfDate = Trim(dw_ip.GetItemString(1, 'ofdate'))
//	
//	iOfSeq = sqlca.fun_junpyo(gs_sabu,sOfDate,'S1')
//	IF iOfSeq <= 0 THEN
//		ROLLBACK;
//		f_message_chk(51,'')
//		Return
//	END IF
//	
//	sOfNo = sOfDate + String(iOfseq,'0000')
//	Commit;
//
//	dw_ip.SetItem(1,"sabu", gs_sabu)
//	dw_ip.SetItem(1,"ofno", sOfNo)
//	MessageBox("확 인","채번된 견적번호는 "+sOfNo+" 번 입니다!!")
//ELSE
//	sOfNo = Trim(dw_ip.GetItemString(1,"ofno"))
//END IF
//
//IF sOfNo = "" OR IsNull(sOfNo) THEN
//	rollback;
//	f_message_chk(51,'[견적번호]')
//	Return
//End If
//
///* 수주번호 최대값 */
//If dw_insert.Rowcount() > 0 Then
//	nSeq = dw_insert.GetItemNumber(1,'maxseq')
//	If IsNull(nSeq) or nSeq < 0 Then nSeq = 0 
//End If
//
//SetPointer(HourGlass!)
//
//nRCnt = 0
//FOR k = 1 To dw_insert.Rowcount()
//	/* 기존 보류등 견적상태를 유지하기위해 신규만 상태를 반영한다 */
//	dwSts = dw_insert.GetItemStatus(k,0,Primary!)
//	If dwSts = NewModified! Then
//		nSeq += 1
//		If nSeq > 999 Then
//			MessageBox('오류','견적번호 순번이 999번을 초과했습니다')
//			RollBack;
//			Return
//		End If
//	
//		dw_insert.SetItem(k,"sabu",       gs_sabu)
//		dw_insert.SetItem(k,"ofno",		 sOfNo)
//		dw_insert.SetItem(k,"ofseq",   	 nSeq)
//	End If
//		
//	nRCnt += 1
//NEXT
//
//If dw_ip.Update() <> 1 Then
//	RollBack;
//	f_message_chk(32,'')
//Else
//	If dw_insert.Update() <> 1 Then
//		RollBack;
//		f_message_chk(32,'')
//		Return
//	End If
//	
//	COMMIT;
//	
//	Wf_Init()
//End If
//
//sle_msg.text ='자료를 저장하였습니다!!'
end event

type cb_ins from w_inherite`cb_ins within w_sal_01700
boolean visible = false
integer x = 421
integer taborder = 50
string text = "추가(&I)"
end type

event cb_ins::clicked;call super::clicked;//String sOfno
//Long	 nRow
//
//If dw_ip.AcceptText() <> 1 Then Return
//
//If rb_mod.Checked = True Then
//	sOfNo = Trim(dw_ip.GetItemString(1,"ofno"))
//
//  IF sOfno = "" OR IsNull(sOfno) THEN
//	  f_message_chk(1400,'[견적번호]')
//	  Return
//  End If
//Else
//	sOfno = ''
//END IF
//
///* Data Check */
//nRow = dw_insert.RowCount()
//If nRow > 0 Then
//	If wf_check_itnbr(nRow) <> 0 Then
//		Return
//	End If
//End If
//
//nRow += 1
//nRow = dw_insert.InsertRow(nRow)
//dw_insert.ScrollToRow(nRow)
//dw_insert.SetFocus()
end event

type cb_del from w_inherite`cb_del within w_sal_01700
boolean visible = false
integer x = 2505
integer taborder = 70
end type

event cb_del::clicked;call super::clicked;//String sOfNo
//
//If dw_ip.AcceptText() <> 1 Then Return
//If dw_insert.AcceptText() <> 1 Then Return
//
//IF	 MessageBox("삭제 확인", "삭제하시겠습니까? ",question!, yesNo!)  = 2 THEN return  
//
///* 등록일 경우 */
//If rb_new.Checked = True Then
//	dw_insert.DeleteRow(0)
//	
//	sle_msg.Text = '자료를 삭제하였습니다.!!'
//	
//	Return
//Else
//	sOfNo = Trim(dw_ip.GetItemString(1,'ofno'))
//	
//	IF IsNull(sOfNo) Or sOfNo = '' THEN
//		f_message_chk(1400,'[견적번호]')
//		Return
//	End If	
//End If
//
//dw_insert.SetRedraw(False)
//dw_insert.DeleteRow(0)
//If dw_insert.Update() <> 1 Then
//	RollBack;
//	MessageBox('확 인','자료 삭제에 실패하였습니다!!')
//	dw_insert.SetRedraw(True)
//	Return
//End If
//
//commit;
//
//dw_insert.SetRedraw(True)
//sle_msg.Text = '자료를 삭제하였습니다.!!'
end event

type cb_inq from w_inherite`cb_inq within w_sal_01700
boolean visible = false
integer x = 73
integer taborder = 80
end type

event cb_inq::clicked;call super::clicked;//String sofno
//Long   nCnt
//
//If rb_new.Checked = True Then Return
//
//If dw_ip.AcceptText() <> 1 Then Return
//
//sofno = Trim(dw_ip.GetItemString(1,'ofno'))
//
//If IsNull(sofno) Or sofno = '' Then
//	f_message_chk(30,'[견적번호]')
//	Return
//End If
//
///* 조회 */
//If dw_ip.Retrieve(gs_sabu, sofno) <= 0 Then
//	f_message_chk(50,'')
//	dw_ip.SetColumn("ofno")
//	dw_ip.SetFocus()
//	wf_init()
//	Return
//Else
//	dw_insert.Retrieve(gs_sabu, sofno)
//	
//	dw_ip.Modify('ofno.protect = 1')
//	dw_ip.Modify('ofno.background.color = 80859087')
//	dw_ip.Modify('ofdate.protect = 1')
//	dw_ip.Modify('ofdate.background.color = 80859087')
//		
//	/* 접수이상이면 수정불가 */
//	If dw_insert.RowCount() > 0 Then
//		nCnt = dw_insert.GetItemNumber(1, 'cnt_ofsts')
//		If nCnt >= 1 Then
//			cb_print.Enabled = False
//		Else
//			cb_print.Enabled = True
//		End If
//	Else
//		cb_print.Enabled = True
//	End If
//
//	cb_search.Enabled = True
//END IF
//
//dw_ip.SetFocus()
end event

type cb_print from w_inherite`cb_print within w_sal_01700
boolean visible = false
integer x = 3968
integer y = 2792
integer width = 439
integer taborder = 90
string text = "견적삭제(&P)"
end type

event cb_print::clicked;call super::clicked;//String sOfNo
//
//If dw_ip.AcceptText() <> 1 Then Return
//If dw_insert.AcceptText() <> 1 Then Return
//
//IF	 MessageBox("삭제 확인", "견적 전체를 삭제하시겠습니까? ",question!, yesNo!)  = 2 THEN return  
//
///* 등록일 경우 */
//If rb_new.Checked = True Then
//Else
//	sOfNo = Trim(dw_ip.GetItemString(1,'ofno'))
//	
//	IF IsNull(sOfNo) Or sOfNo = '' THEN
//		f_message_chk(1400,'[견적번호]')
//		Return
//	End If	
//End If
//
//dw_ip.DeleteRow(0)
//If dw_ip.Update() <> 1 Then
//	RollBack;
//	MessageBox('확 인','자료 삭제에 실패하였습니다!!')
//	Return
//End If
//
//dw_insert.RowsMove(1, dw_insert.RowCount(), Primary!, dw_insert, 1, Delete!)
//If dw_insert.Update() <> 1 Then
//	RollBack;
//	MessageBox('확 인','자료 삭제에 실패하였습니다!!')
//	Return
//End If
//
//commit;
//
//wf_init()
//
//w_mdi_frame.sle_msg.Text = '자료를 삭제하였습니다.!!'
end event

type st_1 from w_inherite`st_1 within w_sal_01700
end type

type cb_can from w_inherite`cb_can within w_sal_01700
boolean visible = false
integer x = 2862
integer taborder = 100
end type

event cb_can::clicked;call super::clicked;
//wf_init()

end event

type cb_search from w_inherite`cb_search within w_sal_01700
boolean visible = false
integer x = 3387
integer y = 2792
integer width = 567
integer taborder = 110
string text = "견적이력조회(&W)"
end type

event cb_search::clicked;call super::clicked;//Open(w_sal_01710)
end event







type gb_button1 from w_inherite`gb_button1 within w_sal_01700
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_01700
end type

type gb_3 from groupbox within w_sal_01700
integer x = 3131
integer y = 204
integer width = 393
integer height = 296
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "[작업 조건]"
borderstyle borderstyle = stylelowered!
end type

type rb_new from radiobutton within w_sal_01700
integer x = 3209
integer y = 292
integer width = 247
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "등록"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;wf_init()
end event

type rb_mod from radiobutton within w_sal_01700
integer x = 3209
integer y = 384
integer width = 247
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "수정"
borderstyle borderstyle = stylelowered!
end type

event clicked;wf_init()
end event

type dw_ip from datawindow within w_sal_01700
event ue_key pbm_dwnkey
event ue_enter pbm_dwnprocessenter
integer x = 78
integer y = 180
integer width = 3054
integer height = 700
integer taborder = 30
string dataobject = "d_sal_01700"
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_enter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;String sOfDate, sNull, sName, sGet_Name, sPrjno, sprjnm, sOfno, sOfSts
Long   nCnt

SetNull(sNull)

Choose Case GetColumnName()
	/* 견적번호 */
	Case "ofno"
		sOfNo = Trim(GetText())
		IF sOfNo = "" OR IsNull(sOfNo) THEN RETURN
		
		SELECT "OFNO"  INTO :sOfNo  
		  FROM "OFHEAD"  
		 WHERE ( "SABU" = :gs_sabu ) AND
				 ( "OFNO" = :sOfNo);
	
		/* 등록일때 */
		If rb_new.Checked = True Then
			IF SQLCA.SQLCODE = 0 OR sqlca.sqlnrows >= 1 THEN
				f_message_chk(33,'[견적번호]')
				SetItem(1,'ofno',sNull)
				Return 1
			END IF
		Else
			IF SQLCA.SQLCODE <> 0 OR sqlca.sqlnrows > 1 THEN
				f_message_chk(33,'[견적번호]')
				SetItem(1,'ofno',sNull)
				Return 1
			ELSE
				p_inq.TriggerEvent(Clicked!)
				rb_mod.Checked = True
			END IF
		End If
	/* 일자 */
	Case "ofdate", "reqdate","vtdate"
		sOfDate = Trim(GetText())
		IF sOfDate ="" OR IsNull(sOfDate) THEN RETURN
		
		IF f_datechk(sOfDate) = -1 THEN
			f_message_chk(35,'[일자]')
			SetItem(1,GetColumnName(),snull)
			Return 1
		End If
	/* 고객 번호 */
	Case "cust_no"
		sName = Trim(GetText())
		IF sName ="" OR IsNull(sName) THEN
			setitem(1, 'cust_nm', sNull)
			setitem(1, 'cust_no', sNull)
			Return 1
		End If
		
		SELECT "CUST_NAME"  INTO :sGet_Name
		  FROM "CUSTOMER"
		 WHERE "CUST_NO" = :sName;
		
		IF SQLCA.SQLCODE = 0 THEN
			setitem(1, 'cust_nm', left(sGet_Name, 20))
		Else
			setitem(1, 'cust_nm', sNull)
			setitem(1, 'cust_no', sNull)
			Return 1
		End If
	/* 프로젝트 번호 */
	Case "pjtno"
		sPrjNo = Trim(GetText())
		IF sPrjNo ="" OR IsNull(sPrjNo) THEN	 Return
		
		SELECT "PRJNM"  INTO :sPrjNm  
		  FROM "PROJECT"
		 WHERE "PRJNO" = :sPrjNo;
		
		IF SQLCA.SQLCODE <> 0 THEN	 
			SetItem(1, 'pjtno', sNull)
		End If
	/* 접수부서 */
   Case 'deptno'
 	  String sdptno
	
	  sdptno = Trim(GetText())
	
	  IF sdptno ="" OR IsNull(sdptno) THEN 
		 SetItem(1,"deptnm",snull)
		 RETURN
	  END IF
	
	  SELECT "VNDMST"."CVNAS2"  INTO :sget_name  
       FROM "VNDMST"  
      WHERE "VNDMST"."CVCOD" = :sdptno  AND "VNDMST"."CVGU" = '4' ;
	  
		IF SQLCA.SQLCODE = 0 THEN
			SetItem(1,"deptnm",sget_name)
		ELSE
			TriggerEvent(RbuttonDown!)
			IF gs_code ="" OR IsNull(gs_code) THEN 
				SetItem(1,"deptno",snull)
				SetItem(1,"deptnm",snull)
			END IF
		
			Return 1	
		END IF
	/* 취소일자 */
	Case 'clsdate'
		sOfDate = Trim(GetText())
		IF sOfDate ="" OR IsNull(sOfDate) THEN 
			SetItem(1, 'clsgb', 	  sNull)
			SetItem(1, 'clscause', sNull)
			SetItem(1, 'clsdate',  sNull)
			SetItem(1, 'clsgb', 	  sNull)
			SetItem(1, 'clscause', sNull)
			SetItem(1, 'ofsts',    '1')
			RETURN 1
		End If
		
		IF f_datechk(sOfDate) = -1 THEN
			f_message_chk(35,'[일자]')
			SetItem(1,GetColumnName(),snull)
			Return 1
		End If

		nCnt = 0
		If dw_insert.RowCount() > 0 Then
			/* 승인된 건이 한건이라도 있으면 취소불가 */
			nCnt = dw_insert.GetItemNumber(1, 'cnt_cfmdate')
		End If
		
		sOfSts = GetItemString(1,'ofsts')
		If sOfSts = '2' Or sOfSts = '3' Or nCnt > 0 Then	
			MessageBox('확 인','완료된 자료는 취소하실 수 없습니다.!!')
			Return 2
		End If
		
		/* 견적상태 -> 취소 */
		SetItem(1, 'ofsts',    '8')
	/* 견적 대표번호 */
	Case 'stdofno'
		If rb_new.Checked = True Then
			Post wf_std_offer(Trim(GetText()), GetItemString(1, 'ofdate'))
		Else
			Return 2
		End If
//	/* 견적상태 */
//	Case 'ofsts'
//		sOfSts = Trim(GetText())
//		
//		If GetItemString(1,'ofsts') = '2' Or GetItemString(1,'ofsts') = '3' Then	
//			MessageBox('확 인','완료된 자료는 변경하실 수 없습니다.!!')
//			Return 2
//		End If
//		
//		If sOfsts = '1' Then
//			SetItem(1, 'clsdate',  sNull)
//			SetItem(1, 'clsgb', 	  sNull)
//			SetItem(1, 'clscause', sNull)
//		End If
End Choose
end event

event rbuttondown;SetNull(Gs_code)
SetNull(Gs_gubun)
SetNull(Gs_codename)

Choose Case GetColumnName()
	/* 견적번호 */
	Case "ofno"
		If rb_mod.Checked = True Then
			Open(w_sal_01700_popup)
			IF gs_code ="" OR IsNull(gs_code) THEN RETURN
			
			SetItem(1,"ofno",gs_code)
			p_inq.TriggerEvent(Clicked!)
		End If
	/* 프로젝트번호 */
	Case "pjtno"
		Open(w_project_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"pjtno",  gs_code)
//		SetItem(1,"prjnm",gs_codename)
//		cb_inq.TriggerEvent(Clicked!)
	/* 고객번호 */
	Case "cust_no"
		Open(w_cust_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cust_no",  gs_code)
		SetItem(1,"cust_nm",gs_codename)
	/* 부서 */
   Case "deptno"
	  Open(w_vndmst_4_popup)
	  IF gs_code ="" OR IsNull(gs_code) THEN RETURN
	
	  SetItem(1,"deptno",  gs_code)
	  SetItem(1,"deptnm",  gs_codename)
END Choose

end event

event itemerror;Return 1
end event

type rr_1 from roundrectangle within w_sal_01700
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 64
integer y = 168
integer width = 3488
integer height = 720
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_sal_01700
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 900
integer width = 4526
integer height = 1384
integer cornerheight = 40
integer cornerwidth = 55
end type

