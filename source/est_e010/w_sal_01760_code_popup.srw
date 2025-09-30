$PBExportHeader$w_sal_01760_code_popup.srw
$PBExportComments$견적원가 계산 POPUP(항목)
forward
global type w_sal_01760_code_popup from window
end type
type p_del from uo_picture within w_sal_01760_code_popup
end type
type p_mod from uo_picture within w_sal_01760_code_popup
end type
type p_ins from uo_picture within w_sal_01760_code_popup
end type
type p_exit from uo_picture within w_sal_01760_code_popup
end type
type dw_1 from datawindow within w_sal_01760_code_popup
end type
type rr_1 from roundrectangle within w_sal_01760_code_popup
end type
end forward

global type w_sal_01760_code_popup from window
integer x = 82
integer y = 788
integer width = 2117
integer height = 1104
boolean titlebar = true
string title = "원가항목별 조회"
windowtype windowtype = response!
long backcolor = 32106727
p_del p_del
p_mod p_mod
p_ins p_ins
p_exit p_exit
dw_1 dw_1
rr_1 rr_1
end type
global w_sal_01760_code_popup w_sal_01760_code_popup

type variables
string sCstNo, sItnbr, sCstSeq, sSerid
String sOpseq, swkctr, smchno, sOk

end variables

forward prototypes
public function integer wf_req_chk ()
end prototypes

public function integer wf_req_chk ();String sCostCd
Long 	 nRow


If dw_1.AcceptText() <> 1 Then Return -1

nRow = dw_1.GetRow()
If nRow <= 0 Then Return 1

/* 추가된 row만 검사한다 */
If dw_1.GetItemStatus(nRow, 0, Primary!) = NotModified! Then Return 1
If dw_1.GetItemStatus(nRow, 0, Primary!) = DataModified! Then Return 1

dw_1.SetFocus()

sCostCd	= Trim(dw_1.GetItemString(nRow, 'cost_cd'))

If IsNull(sCostCd) Or sCostCd = '' Then
	f_message_chk(1400,'[원가항목]')
	dw_1.SetColumn('cost_cd')
	Return -1
End If

Return 1
end function

on w_sal_01760_code_popup.create
this.p_del=create p_del
this.p_mod=create p_mod
this.p_ins=create p_ins
this.p_exit=create p_exit
this.dw_1=create dw_1
this.rr_1=create rr_1
this.Control[]={this.p_del,&
this.p_mod,&
this.p_ins,&
this.p_exit,&
this.dw_1,&
this.rr_1}
end on

on w_sal_01760_code_popup.destroy
destroy(this.p_del)
destroy(this.p_mod)
destroy(this.p_ins)
destroy(this.p_exit)
destroy(this.dw_1)
destroy(this.rr_1)
end on

event open;sSerId = Message.StringParm

dw_1.SetTransObject(Sqlca)

sOk = 'N'

sCstNo = gs_code
sItnbr = gs_gubun
sCstSeq = gs_codename

SELECT Opseq,   wkctr, mchno
  INTO :sOpseq, :swkctr, :smchno
  FROM CALCSTU
 WHERE SABU = :gs_sabu AND
       CSTNO = :sCstNo AND
       CSTSEQ = :sCstSeq AND
		 ITNBR  = :sItnbr AND
		 SERID = :sSerId;

dw_1.Retrieve(gs_sabu, gs_code, gs_codename, gs_gubun, sSerId+'%')

end event

type p_del from uo_picture within w_sal_01760_code_popup
integer x = 1696
integer y = 16
integer width = 178
integer taborder = 60
string pointer = "C:\erpman\cur\delete.cur"
string picturename = "C:\erpman\image\삭제_up.gif"
end type

event clicked;Integer iCurRow

iCurRow = dw_1.GetRow()
IF iCurRow <=0 THEN
	f_message_chk(36,'')
	Return
END IF

IF F_Msg_Delete() = -1 THEN Return

dw_1.DeleteRow(iCurRow)

IF dw_1.Update() <> 1 THEN
	ROLLBACK;
	Return
END IF

COMMIT;

dw_1.SetColumn("cost_cd")
dw_1.SetFocus()

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\삭제_up.gif"
end event

type p_mod from uo_picture within w_sal_01760_code_popup
integer x = 1522
integer y = 16
integer width = 178
integer taborder = 50
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event clicked;String sNull
		
SetNull(sNull)

If wf_req_chk() <> 1 Then Return

IF F_Msg_Update() = -1 THEN Return

SetPointer(HourGlass!)

If dw_1.Update() <> 1 Then
	RollBack;
	f_message_chk(32,'')
	Return
End If

sOk = 'Y'

COMMIT;
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

type p_ins from uo_picture within w_sal_01760_code_popup
integer x = 1349
integer y = 16
integer width = 178
integer taborder = 20
string pointer = "C:\erpman\cur\add.cur"
string picturename = "C:\erpman\image\추가_up.gif"
end type

event clicked;call super::clicked;Long   nRow
String lsSerId, sMax

IF dw_1.AcceptText() = -1 THEN RETURN

nRow = dw_1.GetRow()

If wf_req_chk() <> 1 Then Return

nRow = dw_1.InsertRow(nRow)

sMax = Mid(dw_1.GetItemString(1, 'max_serid'),5)
If IsNull(sMax) Then sMax = '000'

lsSerId = sSerId + String(Long(sMax) + 1,'000')

dw_1.SetItem(nRow, "sabu",   gs_sabu)
dw_1.SetItem(nRow, "cstno",  sCstNo)
dw_1.SetItem(nRow, "cstseq", sCstSeq)
dw_1.SetItem(nRow, "itnbr",  sItnbr)
dw_1.SetItem(nRow, "serid",  lsSerId)
dw_1.SetItem(nRow, "opseq",  sOpseq)
dw_1.SetItem(nRow, "wkctr",  sWkctr)
dw_1.SetItem(nRow, "mchno",  sMchno)

dw_1.ScrollToRow(nRow)
	
dw_1.SetFocus()
dw_1.SetItemStatus(nRow,0, Primary!, NotModified!)
dw_1.SetItemStatus(nRow,0, Primary!, New!)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\추가_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\추가_up.gif"
end event

type p_exit from uo_picture within w_sal_01760_code_popup
integer x = 1870
integer y = 16
integer width = 178
integer taborder = 80
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;CloseWithReturn(parent, sOk)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type dw_1 from datawindow within w_sal_01760_code_popup
integer x = 46
integer y = 184
integer width = 1984
integer height = 784
integer taborder = 10
string dataobject = "d_sal_01760_code_popup"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event itemerror;Return 1
end event

event itemchanged;Long nRow, nfind

String sCvcod, sCvnas, sCurr, sDate, sNull, sCode,sCostGb
Dec 	 dShrat, dPrice

nRow = GetRow()
If nRow <= 0 Then Return

SetNull(sNull)

Choose Case GetColumnName()
	Case 'cost_cd'
		sCode = Trim(GetText())
		If IsNull(sCode) Or sCode = '' Then		Return
		
		nFind = Find("cost_cd = '" + sCode + "'", 1, RowCount())
		If nFind > 0 And ( nFind <> nRow) Then
			f_message_chk(37,'')
			Return 2
		End If
		
		SELECT COSTGB INTO :sCostGb
		  FROM COST_CODE
		 WHERE COST_CD = :sCode;
		 
		If IsNull(sCostGb) Or sCostGb = '' Then
			f_message_chk(33,'[원가항목]')
			Return 2
		End If
		
		/* 외주가공비가 아닐경우 */
		If sCostGb <> '3' Then
			SetItem(nRow, 'cvcod', sNull)
			SetItem(nRow, 'cvnas2', sNull)
		End If
		
		SetItem(nRow, 'costgb', sCostGb)
	/* 단가 거래처 */
	Case "cvcod"
		sCvcod  = Trim(GetText())
		sItnbr  = GetItemString(nRow, "itnbr")
		 
		If sCvcod = "" or isnull(sCvcod) then 
			SetItem(nRow, "CVCOD", SNULL)
			SetItem(nRow, "CVNAS2", SNULL)
			SetItem(nRow, "cost_amt", 0)
			return 
		End If
			
		/* 거래처 확인 */
		SELECT A.CVNAS
		  INTO :sCvnas
		  FROM "VNDMST" A
		 WHERE A.CVCOD = :sCvcod
			AND A.CVGU IN ('1','2','9'); 
			 
		IF SQLCA.SQLCODE <> 0 THEN
			SetItem(nRow, "CVCOD",  SNULL)
			SetItem(nRow, "CVNAS2", SNULL)
			SetItem(nRow, "cost_amt",  0)
			F_MESSAGE_CHK(33, '[거래처]')
			RETURN 1
		END IF
		
		SetItem(nRow, "CVNAS2", sCvnas)
	
		/* 단가내역 확인 */
		SELECT NVL(B.UNPRC, 0), cunit
		  INTO :dPrice, :sCurr
		  FROM DANMST B
		 WHERE B.ITNBR	   = :sItnbr 
			AND B.OPSEQ    = :SOPSEQ
			AND B.CVCOD 	= :sCvcod; 

		If IsNull(dPrice) Then dPrice = 0
		If IsNull(sCurr)  Then sCurr = 'WON'

		If sCurr <> 'WON' Then
			sDate = Left(f_today(),6)
			dPrice = sqlca.erp000000090_1(sDate, sItnbr, sCurr, dPrice, '2')
			If IsNull(dPrice) Then dPrice = 0
		End If
		
		SetItem(nRow, "cost_amt", dPrice)
End Choose
end event

event rbuttondown;Long nRow

setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)

nRow = GetRow()
If nRow <= 0 Then Return

choose case getcolumnname()
	Case 'cvcod'		
		gs_code 		= getitemstring(nRow, "itnbr")
		gs_codename = sOpSeq
		Open(w_danmst_popup)
	
		IF gs_code = '' or isnull(gs_code) then return 
	
		SetItem(nRow,"cvcod",  gs_code)
		SetItem(nRow,"cost_amt", Dec(gs_codename))
		
		setnull(gs_code)
		setnull(gs_codename)
	
		this.TriggerEvent("itemchanged")
end choose
end event

type rr_1 from roundrectangle within w_sal_01760_code_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 176
integer width = 2007
integer height = 804
integer cornerheight = 40
integer cornerwidth = 55
end type

