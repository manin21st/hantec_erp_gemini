$PBExportHeader$w_sal_01760_gon_popup.srw
$PBExportComments$견적원가 계산 POPUP(공정)
forward
global type w_sal_01760_gon_popup from window
end type
type p_2 from uo_picture within w_sal_01760_gon_popup
end type
type p_1 from uo_picture within w_sal_01760_gon_popup
end type
type p_exit from uo_picture within w_sal_01760_gon_popup
end type
type p_mod from uo_picture within w_sal_01760_gon_popup
end type
type p_del from uo_picture within w_sal_01760_gon_popup
end type
type p_ins from uo_picture within w_sal_01760_gon_popup
end type
type dw_gon from u_key_enter within w_sal_01760_gon_popup
end type
type rr_1 from roundrectangle within w_sal_01760_gon_popup
end type
end forward

global type w_sal_01760_gon_popup from window
integer x = 23
integer y = 664
integer width = 3589
integer height = 1632
boolean titlebar = true
string title = "견적원가 계산 POPUP(공정)"
windowtype windowtype = response!
long backcolor = 32106727
p_2 p_2
p_1 p_1
p_exit p_exit
p_mod p_mod
p_del p_del
p_ins p_ins
dw_gon dw_gon
rr_1 rr_1
end type
global w_sal_01760_gon_popup w_sal_01760_gon_popup

type variables
string sCstNo, sItnbr, sCstSeq, sOk
dec   dprscost
end variables

forward prototypes
public function integer wf_recalc ()
public function integer wf_req_chk ()
end prototypes

public function integer wf_recalc ();Long ix, ii
String sSerId

If dw_gon.RowCount() <= 0 Then Return 1

For ix = 1 To dw_gon.RowCount()
	/* 변경된 내역만 재계산 */
	If dw_gon.GetItemString(ix, 'chk') <> 'Y' Then Continue

	sSerId = dw_gon.GetItemString(ix, 'serid')

	ii = sqlca.fun_get_calcst(gs_sabu, sCstNo, sCstSeq, sItnbr+'%', sSerId+'%', '3')

	If ii <> 1 Then
		messagebox(string(sqlca.sqlcode),sqlca.sqlerrtext)
		rollback;
		Messagebox("재계산", "견적계산을 실패하였읍니다.", stopsign!)
		Return -1
	End if

	dw_gon.SetItem(ix,'chk','N')
Next

COMMIT;

Return 1
end function

public function integer wf_req_chk ();String sOpseq, sOpdsc, sWkctr, sMchno, sMkgub
Long 	 nRow
Dec    dManhr, dmchr, dprscst, dTbcQt

If dw_gon.AcceptText() <> 1 Then Return -1

nRow = dw_gon.GetRow()
If nRow <= 0 Then Return 1

/* 추가된 row만 검사한다 */
If dw_gon.GetItemStatus(nRow, 0, Primary!) = NotModified! Then Return 1
If dw_gon.GetItemStatus(nRow, 0, Primary!) = DataModified! Then Return 1

dw_gon.SetFocus()

sOpseq	= Trim(dw_gon.GetItemString(nRow, 'opseq'))
sOpdsc	= Trim(dw_gon.GetItemString(nRow, 'opdsc'))
sWkctr	= Trim(dw_gon.GetItemString(nRow, 'wkctr'))
sMchno	= Trim(dw_gon.GetItemString(nRow, 'mchno'))
sMkgub	= Trim(dw_gon.GetItemString(nRow, 'mkgub'))
dManhr	= dw_gon.GetItemNumber(nRow, 'manhr')
dmchr		= dw_gon.GetItemNumber(nRow, 'mchr')
dprscst	= dw_gon.GetItemNumber(nRow, 'prscost')
dTbcqt	= dw_gon.GetItemNumber(nRow, 'tbcqt')

If IsNull(sOpseq) Or sOpseq = '' Then
	f_message_chk(1400,'[공정순서]')
	dw_gon.SetColumn('opseq')
	Return -1
End If

If IsNull(sOpdsc) Or sOpdsc = '' Then
	f_message_chk(1400,'[공정명]')
	dw_gon.SetColumn('Opdsc')
	Return -1
End If

If IsNull(sWkctr) Or sWkctr = '' Then
	f_message_chk(1400,'[작업장]')
	dw_gon.SetColumn('Wkctr')
	Return -1
End If

If IsNull(sMchno) Or sMchno = '' Then
	f_message_chk(1400,'[설비번호]')
	dw_gon.SetColumn('Mchno')
	Return -1
End If

If IsNull(sMkgub) Or sMkgub = '' Then
	f_message_chk(1400,'[구분]')
	dw_gon.SetColumn('Mkgub')
	Return -1
End If

//If IsNull(dprscst) Or dprscst <= 0 Then
//	f_message_chk(1400,'[가공비]')
//	dw_gon.SetColumn('prscost')
//	Return -1
//End If

If ( IsNull(dmanhr) Or dmanhr = 0 ) and ( IsNull(dmchr) Or dmchr = 0 ) Then
	f_message_chk(1400,'[표준시간]')
	dw_gon.SetColumn('manhr')
	Return -1
End If

If IsNull(dtbcqt) Or dtbcqt <= 0 Then
	f_message_chk(1400,'[시간공정수량]')
	dw_gon.SetColumn('tbcqt')
	Return -1
End If

Return 1
end function

on w_sal_01760_gon_popup.create
this.p_2=create p_2
this.p_1=create p_1
this.p_exit=create p_exit
this.p_mod=create p_mod
this.p_del=create p_del
this.p_ins=create p_ins
this.dw_gon=create dw_gon
this.rr_1=create rr_1
this.Control[]={this.p_2,&
this.p_1,&
this.p_exit,&
this.p_mod,&
this.p_del,&
this.p_ins,&
this.dw_gon,&
this.rr_1}
end on

on w_sal_01760_gon_popup.destroy
destroy(this.p_2)
destroy(this.p_1)
destroy(this.p_exit)
destroy(this.p_mod)
destroy(this.p_del)
destroy(this.p_ins)
destroy(this.dw_gon)
destroy(this.rr_1)
end on

event open;dPrsCost = Message.DoubleParm

dw_gon.SetTransObject(sqlca)

sOk = 'N'

sCstNo = gs_code
sItnbr = gs_gubun
sCstSeq = gs_codename

If IsNull(dPrsCost) Then 	dPrsCost = 0

dw_gon.Retrieve(gs_sabu, sCstNo, sCstSeq, sItnbr)
end event

type p_2 from uo_picture within w_sal_01760_gon_popup
integer x = 2533
integer y = 36
integer width = 297
integer taborder = 20
string pointer = "C:\erpman\cur\add.cur"
string picturename = "C:\erpman\image\표준공정등록_up.gif"
end type

event ue_lbuttondown;PictureName = "C:\erpman\image\표준공정등록_dn.gif"
end event

event ue_lbuttonup;PictureName = "C:\erpman\image\표준공정등록_up.gif"
end event

event clicked;Long   ix
Dec    dOfqty, dCstQty
String sCalgb

If dw_gon.AcceptText() <> 1 Then Return

If dw_gon.RowCount() > 0 Then
	IF MessageBox("확 인","기존내역을 삭제후 표준공정을 적용합니다.!!" +"~n~n" +&
								 "계속 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN RETURN
End If

/* 해당품목 품목의 원가내역을 삭제한다 */
DELETE FROM CALCSTP
 WHERE SABU = :gs_sabu AND
       CSTNO = :sCstNo AND
		 CSTSEQ = :sCstSeq AND
		 ITNBR  = :sItnbr;
If sqlca.sqlcode <> 0 Then
	RollBack;
	f_message_chk(31,'')
	Return -1
End If

/* 해당품목의 공정내역을 삭제한다 */
DELETE FROM CALCSTU
 WHERE SABU = :gs_sabu AND
       CSTNO = :sCstNo AND
		 CSTSEQ = :sCstSeq AND
		 ITNBR  = :sItnbr;
If sqlca.sqlcode <> 0 Then
	RollBack;
	f_message_chk(31,'')
	Return -1
End If

/* 준비시간 배부여부에 따라 예상판매수로 나눈다 : 준비시간 = 표준준비시간 / 예상판매수 * 공정수량 */
/* 단, 배치작업장일 경우는 표준공정공수의 단위기준수량으로 나눈다 */
SELECT A.CALGB, DECODE(A.CALGB, '2', A.OFQTY,  1),    DECODE(A.CALGB, '2', B.CSTQTY, 1)
  INTO :sCalgb, :dOfQty, 										:dCstQty
  FROM CALCSTH A, CALCSTD B
 WHERE A.SABU = :gs_sabu AND
       A.CSTNO = :sCstNo AND
		 A.CSTSEQ = :sCstSeq AND
		 A.SABU = B.SABU AND
		 A.CSTNO = B.CSTNO AND
		 A.CSTSEQ = B.CSTSEQ AND
		 B.ITNBR = :sItnbr;

If IsNull(sCalgb) Or sCalgb = '' Then sCalgb = '1'
If IsNull(dOfQty)  Then dOfQty = 1
If IsNull(dCstQty) Then dCstQty = 1

/* 표준공정 입력 */
INSERT INTO "CALCSTU"
	 VALUE ( "SABU",   	"CSTNO",   	"CSTSEQ",   		"ITNBR",        "SERID", 	"OPSEQ",   
				"OPDSC",   	"WKCTR",		"MCHNO",
   			"STDST",
				"MANHR",   	"MCHR",   	"PRSCOST",  
				"MKGUB",   	
				"MATCOST",	"TBCQT"  )
	  SELECT :gs_sabu, :sCstNo,     :sCstSeq,         :sItnbr,        substr(to_char(rownum,'0000'),2,4), A."OPSEQ",
            A."OPDSC",  A."WKCTR",  '.',
				TRUNC(DECODE(B."WKGUB",'1', A."STDST"/ DECODE(A."UNITQ", 0, 1, DECODE(:sCalgb,'2', NVL(A."UNITQ",1),1)),
				                            A."STDST"/ :dOfQty ),4) AS STDST,
				A."MANHR",  A."MCHR",     0,
				DECODE(A."PURGC",'Y','2','1'),
				0,			   A."TBCQT"
       FROM "ROUTNG" A, "WRKCTR" B
      WHERE A."ITNBR" = :sItnbr 
		  AND A."WKCTR" = B."WKCTR"(+);
If sqlca.sqlcode <> 0 Then
	MESSAGEBOX(STRING(SQLCA.SQLCODE),SQLCA.SQLERRTEXT)
	RollBack;
	f_message_chk(32,'')
	Return -1
End If

COMMIT;

/* 공정변경 */
dw_gon.SetRedraw(False)
dw_gon.Retrieve(gs_sabu, sCstNo, sCstSeq, sItnbr)
For ix = 1 To dw_gon.RowCount()
	dw_gon.SetItem(ix, 'chk', 'Y')
Next

/* 저장후 원가변동내역을 계산 */
wf_recalc()

dw_gon.Retrieve(gs_sabu, sCstNo, sCstSeq, sItnbr)
dw_gon.SetRedraw(True)

sOk = 'A'
end event

type p_1 from uo_picture within w_sal_01760_gon_popup
integer x = 2245
integer y = 36
integer width = 297
integer taborder = 20
string pointer = "C:\erpman\cur\add.cur"
string picturename = "C:\erpman\image\원가항목조회_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\원가항목 조회_dn.gif"
end event

event ue_lbuttonup;PictureName = "C:\erpman\image\원가항목조회_up.gif"
end event

event clicked;call super::clicked;Long nRow, ii
String sSerId, sgb

nRow = dw_gon.GetRow()
If nRow <= 0 Then Return

If dw_gon.GetItemNumber(1,'chk_cnt') > 0 Then
	MessageBox('확 인','원가변동내역이 존재합니다. 저장을 먼저하세요.!!')
	Return
End If

Choose Case dw_gon.GetItemStatus(nRow,0, Primary!)
	Case New!, NewModified!
		MessageBox('확 인','저장후 원가항목 조회가 가능합니다.!!')
		Return
End Choose

gs_code 		= sCstNo
gs_codename = sCstSeq
gs_gubun 	= dw_gon.GetItemString(nRow, 'itnbr')
sSerId 		= dw_gon.GetItemString(nRow, 'serid')

OpenWithParm(w_sal_01760_code_popup, sSerId)
sGb = Message.StringParm

/* 변경된 사항이 있으면 재계산 처리 */
If sGb = 'Y' Then
	ii = sqlca.fun_get_calcst(gs_sabu, sCstNo, sCstSeq, '%', '%', '2')
	
	If ii <> 1 Then
		messagebox(string(sqlca.sqlcode),sqlca.sqlerrtext)
		rollback;
		Messagebox("재계산", "견적계산을 실패하였읍니다.", stopsign!)
	else
		commit;		
		dw_gon.Retrieve(gs_sabu, sCstNo, sCstSeq, sItnbr)
	End if
End If

end event

type p_exit from uo_picture within w_sal_01760_gon_popup
integer x = 3346
integer y = 36
integer width = 178
integer taborder = 80
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;If dw_gon.RowCount() > 0 Then
	dPrsCost = dw_gon.GetItemNumber(1, 'prscost_sum')
End If

/* sOk : N -변경사항 없음, Y:원가항목만 변경(이미계산됨),A:공정변경 */
gs_code = sOk
closeWithReturn(parent, dPrsCost)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type p_mod from uo_picture within w_sal_01760_gon_popup
integer x = 2999
integer y = 36
integer width = 178
integer taborder = 50
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event clicked;String sNull, sBasic, smkgub, sOpseq, sOpdsc
Long   ix
Dec	 dman, dmch, dtbcqt
SetNull(sNull)

/* 필수항목 체크 */
dw_gon.SetFocus()
For ix = 1 To dw_gon.RowCount()
	sOpseq = dw_gon.GetItemString(ix, 'opseq')
	sOpdsc = dw_gon.GetItemString(ix, 'opdsc')
	sBasic = dw_gon.GetItemString(ix, 'basic')
	smkgub = dw_gon.GetItemString(ix, 'mkgub')
	dman	 = dw_gon.GetItemNumber(ix, 'manhr')
	dmch	 = dw_gon.GetItemNumber(ix, 'mchr')
	dtbcqt = dw_gon.GetItemNumber(ix, 'tbcqt')
	
	If IsNull(sMkgub) Then sMkgub = ''
	If IsNull(dMan) Then dMan = 0
	If IsNull(dMch) Then dMch = 0
	If IsNull(dtbcqt) Then dtbcqt = 0
	
	If IsNull(sOpseq) Or sOpseq = '' Then
		f_message_chk(1400,'[공정순서]')
		dw_gon.ScrollToRow(ix)
		dw_gon.SetColumn('opseq')
		Return
	End If

	If IsNull(sOpdsc) Or sOpdsc = '' Then
		f_message_chk(1400,'[공정명]')
		dw_gon.ScrollToRow(ix)
		dw_gon.SetColumn('opdsc')
		Return
	End If
	
	If sBasic = '1' or sBasic = '3' Then
		If dman <= 0 Then
			f_message_chk(1400,'Man hour')
			dw_gon.ScrollToRow(ix)
			dw_gon.SetColumn('manhr')
			Return
		End If
	End If
	
	If sBasic = '2' or sBasic = '3' Then
		If dmch <= 0 Then
			f_message_chk(1400,'Macine hour')
			dw_gon.ScrollToRow(ix)
			dw_gon.SetColumn('mchr')
			Return
		End If
	End If
	
	If dtbcqt <= 0 Then
		f_message_chk(1400,'[기준수량]')
		dw_gon.ScrollToRow(ix)
		dw_gon.SetColumn('tbcqt')
		Return
	End If

	If IsNull(sMkgub) Or sMkgub = '' Then
		f_message_chk(1400,'[구분]')
		dw_gon.ScrollToRow(ix)
		dw_gon.SetColumn('mkgub')
		Return
	End If
Next

IF F_Msg_Update() = -1 THEN Return

SetPointer(HourGlass!)

If dw_gon.Update() <> 1 Then
	RollBack;
	f_message_chk(32,'')
	Return
End If

/* 저장후 원가변동내역을 계산 */
If wf_recalc() <> 1 Then 
	dw_gon.Retrieve(gs_sabu, sCstNo, sCstSeq, sItnbr)
	Return
End If

sOk = 'A'

COMMIT;

dw_gon.Retrieve(gs_sabu, sCstNo, sCstSeq, sItnbr)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

type p_del from uo_picture within w_sal_01760_gon_popup
integer x = 3173
integer y = 36
integer width = 178
integer taborder = 60
string pointer = "C:\erpman\cur\delete.cur"
string picturename = "C:\erpman\image\삭제_up.gif"
end type

event clicked;String sSerid
Integer nRow

nRow = dw_gon.GetRow()
IF nRow <=0 THEN
	f_message_chk(36,'')
	Return
END IF

IF F_Msg_Delete() = -1 THEN Return

sSerId = dw_gon.GetItemString(nRow, "serid")

dw_gon.DeleteRow(nRow)

IF dw_gon.Update() <> 1 THEN
	ROLLBACK;
	f_message_chk(31,'')
	Return
END IF

/* 해당품목 공정의 원가항목을 삭제한다 */
DELETE FROM CALCSTP
 WHERE SABU = :gs_sabu AND
       CSTNO = :sCstNo AND
		 CSTSEQ = :sCstSeq AND
		 ITNBR  = :sItnbr AND
		 SUBSTR(SERID,1,4) = :sSerId;
If sqlca.sqlcode <> 0 Then
	RollBack;
	f_message_chk(31,'')
	Return -1
End If

COMMIT;

dw_gon.SetColumn("opseq")
dw_gon.SetFocus()

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\삭제_up.gif"
end event

type p_ins from uo_picture within w_sal_01760_gon_popup
integer x = 2825
integer y = 36
integer width = 178
integer taborder = 20
string pointer = "C:\erpman\cur\add.cur"
string picturename = "C:\erpman\image\추가_up.gif"
end type

event clicked;Long   nRow
String sSerId, sMax

IF dw_gon.AcceptText() = -1 THEN RETURN

nRow = dw_gon.GetRow()
//If nRow <= 0 Then Return

If wf_req_chk() <> 1 Then Return

nRow = dw_gon.InsertRow(nRow)

sMax = dw_gon.GetItemString(1, 'max_serid')
If IsNull(sMax) Then sMax = '0000'

sSerId = String(Long(sMax) + 1,'0000')

dw_gon.SetItem(nRow, "sabu",   gs_sabu)
dw_gon.SetItem(nRow, "cstno",  sCstNo)
dw_gon.SetItem(nRow, "cstseq", sCstSeq)
dw_gon.SetItem(nRow, "itnbr",  sItnbr)
dw_gon.SetItem(nRow, "serid",  sSerId)

dw_gon.ScrollToRow(nRow)
	
dw_gon.SetFocus()
dw_gon.SetItemStatus(nRow,0, Primary!, NotModified!)
dw_gon.SetItemStatus(nRow,0, Primary!, New!)


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\추가_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\추가_up.gif"
end event

type dw_gon from u_key_enter within w_sal_01760_gon_popup
event ue_key pbm_dwnkey
integer x = 41
integer y = 216
integer width = 3479
integer height = 1304
integer taborder = 10
string dataobject = "d_sal_01760_gon_popup"
boolean vscrollbar = true
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;String sWkctr, sName, sNull, sReff, sBasic
Long   nRow
int    ireturn

SetNull(sNull)

nRow = GetRow()
If nRow <= 0 Then Return

Choose Case	GetColumnName()	
	Case "wkctr"
		sWkctr = Trim(GetText())
		If IsNull(sWkctr) Or sWkctr = '' Then
			SetItem(nRow, "wcdsc", sNull)
			Return
		End If
		
		SELECT "WCDSC", "BASIC"
		  INTO :sName, :sBasic
		  FROM "WRKCTR"  
		 WHERE ( "WKCTR" = :sWkctr );
		IF sqlca.sqlcode <> 0		THEN
			messagebox("확인", "등록된 작업장이 아닙니다." )
			SetItem(nRow, "wkctr", sNull)	
			RETURN 1
		END IF
		
		SetItem(nRow, 'chk', 'Y')
		
		SetItem(nRow, "wcdsc", sName)
		SetItem(nRow, "basic", sBasic)
	/* 설비 */
	Case "mchno"
		sreff = Trim(GetText())
		
		If sReff = '.' Or sReff = '......' Then
			setitem(nRow, "mchnam", '')
			Return
		End If
		
		If IsNull(sReff) Or sReff = '' Then
			SetItem(nRow, 'mchno', '.')
			setitem(nRow, "mchnam", '')
			Return 1
		End If
		
		select mchnam
		  into :sName
		  from mchmst
		 where sabu = :gs_sabu and mchno = :sreff;
		 
		if sqlca.sqlcode <> 0 then
			f_message_chk(92,'[설비]')
			setnull(sreff)
			setnull(sName)
			ireturn = 1
		end if
		
		setitem(nRow, "mchnam", sName)
		SetItem(nRow, 'chk', 'Y')
		
		return ireturn	
	Case 'mkgub', 'manhr', 'mchr', 'tbcqt', 'stdst'
		SetItem(nRow, 'chk', 'Y')
End Choose
end event

event rbuttondown;call super::rbuttondown;Long 	 nRow

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

nRow = GetRow()
If nRow <= 0 Then Return

Choose Case GetColumnName()
	/* 작업장 */
	Case "wkctr"
		Open(w_workplace_popup)
		If gs_code = "" or isnull(gs_code) then return
		
		SetItem(nRow, 'wkctr', gs_code)
		TriggerEvent(ItemChanged!)
//		SetItem(nRow, 'wcdsc', gs_codename)
//		SetItem(nRow, 'chk', 'Y')
		return 1
	/* 설비 */
	Case "mchno"
		gs_code 		= Trim(GetItemString(nRow, 'wkctr'))
		gs_codename = Trim(GetItemString(nRow, 'wcdsc'))
		
		If IsNull(gs_code) Or gs_code = '' Then
			MessageBox('확 인','작업장을 먼저 선택하세요')
			Return 2
		End If

		/* 원가적용년도 */
		select cstyear into :gs_gubun
		  from calcsth
		 where sabu = :gs_sabu and
				 cstno = :scstno and
				 cstseq = :scstseq;
				 
		Open(w_cost_wrkdtl_popup)
		If gs_code = "" or isnull(gs_code) then return
		
		SetItem(nRow, 'mchno', gs_code)
		SetItem(nRow, 'mchnam', gs_codename)
		SetItem(nRow, 'chk', 'Y')
		return 1	
End Choose
end event

type rr_1 from roundrectangle within w_sal_01760_gon_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 212
integer width = 3515
integer height = 1320
integer cornerheight = 40
integer cornerwidth = 55
end type

