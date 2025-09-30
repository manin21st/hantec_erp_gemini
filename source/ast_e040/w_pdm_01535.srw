$PBExportHeader$w_pdm_01535.srw
$PBExportComments$BOM 공정 등록
forward
global type w_pdm_01535 from w_inherite
end type
type dw_head from u_key_enter within w_pdm_01535
end type
type rr_1 from roundrectangle within w_pdm_01535
end type
end forward

global type w_pdm_01535 from w_inherite
string title = "BOM 공정 등록"
dw_head dw_head
rr_1 rr_1
end type
global w_pdm_01535 w_pdm_01535

on w_pdm_01535.create
int iCurrent
call super::create
this.dw_head=create dw_head
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_head
this.Control[iCurrent+2]=this.rr_1
end on

on w_pdm_01535.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_head)
destroy(this.rr_1)
end on

event open;call super::open;dw_head.settransobject(sqlca)
dw_insert.settransobject(sqlca)

dw_head.InsertRow(0)
dw_head.setcolumn("itnbr")
dw_head.setfocus()

end event

type dw_insert from w_inherite`dw_insert within w_pdm_01535
integer x = 183
integer y = 368
integer width = 3433
integer height = 1500
string dataobject = "d_pdm_01535_2"
boolean border = false
end type

event dw_insert::itemchanged;call super::itemchanged;String  sItnbr,sItDsc,sIspec,sjijil,sispeccode,snull,sopsno
Long    nRow, Lprv

SetNull(sNull)

nRow   = GetRow()
If nRow <= 0 Then Return

sItnbr = Trim(dw_head.getItemString(1, 'itnbr'))
If IsNull(sItnbr) Or sItnbr = '' Then return

Choose Case GetColumnName() 
	Case	"pstruc_opsno" 
		sopsno = gettext()
		
		SELECT opdsc
		  INTO :sItDsc
		  FROM routng
		 WHERE itnbr = :sItnbr And opseq = :sopsno;

		IF SQLCA.SQLCODE <> 0 THEN

			MessageBox("공정", "품목에 정의되지 않은 공정입니다.", stopsign!)
			SetItem(nRow,"pstruc_opsno",  '9999')
			SetItem(nRow,"routng_opdsc",   snull)
			Return 1
		END IF
	
			SetItem(nRow,"routng_opdsc",   sitdsc)		
END Choose

end event

event dw_insert::itemerror;call super::itemerror;return 1
end event

event dw_insert::rbuttondown;call super::rbuttondown;Long nRow
String sItnbr, sNull

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)
SetNull(sNull)

sle_msg.text = ''
nRow     = GetRow()
If nRow <= 0 Then Return

sItnbr = Trim(dw_head.getItemString(1, 'itnbr'))
If IsNull(sItnbr) Or sItnbr = '' Then return

Choose Case GetcolumnName() 
	 Case "pstruc_opsno"
			OpenWithParm(w_routng_popup,sItnbr)
			IF IsNull(Gs_Code) THEN RETURN
			this.SetItem(nrow,"pstruc_opsno",Gs_Code)
			this.setcolumn("pstruc_opsno")
			triggerevent(itemchanged!)
END Choose
end event

type p_delrow from w_inherite`p_delrow within w_pdm_01535
boolean visible = false
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_pdm_01535
boolean visible = false
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_pdm_01535
boolean visible = false
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_pdm_01535
boolean visible = false
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_pdm_01535
end type

type p_can from w_inherite`p_can within w_pdm_01535
end type

type p_print from w_inherite`p_print within w_pdm_01535
boolean visible = false
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_pdm_01535
boolean visible = false
boolean enabled = false
end type

type p_del from w_inherite`p_del within w_pdm_01535
boolean visible = false
integer x = 4082
integer y = 288
boolean enabled = false
end type

type p_mod from w_inherite`p_mod within w_pdm_01535
integer x = 4091
end type

event p_mod::clicked;call super::clicked;
If dw_insert.AcceptText() <> 1 Then Return

If dw_insert.RowCount() <= 0 Then Return

If dw_insert.Update() <> 1 Then
	Rollback;
	MessageBox('실패', '저장에 실패하였습니다.!!')
	Return
Else
	COMMIT;
	MessageBox('확인', '저장하였습니다.!!')
End If

ib_any_typing = False
end event

type cb_exit from w_inherite`cb_exit within w_pdm_01535
end type

type cb_mod from w_inherite`cb_mod within w_pdm_01535
end type

type cb_ins from w_inherite`cb_ins within w_pdm_01535
end type

type cb_del from w_inherite`cb_del within w_pdm_01535
end type

type cb_inq from w_inherite`cb_inq within w_pdm_01535
end type

type cb_print from w_inherite`cb_print within w_pdm_01535
end type

type st_1 from w_inherite`st_1 within w_pdm_01535
end type

type cb_can from w_inherite`cb_can within w_pdm_01535
end type

type cb_search from w_inherite`cb_search within w_pdm_01535
end type







type gb_button1 from w_inherite`gb_button1 within w_pdm_01535
end type

type gb_button2 from w_inherite`gb_button2 within w_pdm_01535
end type

type dw_head from u_key_enter within w_pdm_01535
integer x = 165
integer y = 72
integer width = 2592
integer height = 252
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_pdm_01535_1"
boolean border = false
end type

event itemchanged;call super::itemchanged;String  sItnbr,sItDsc,sIspec,sjijil,sispeccode
Decimal dnull
Long    nRow

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)
SetNull(dNull)

nRow   = GetRow()
If nRow <= 0 Then Return

Choose Case GetColumnName() 
	Case	"itnbr" 
		sitnbr = gettext()
		SELECT "ITEMAS"."ITDSC", "ITEMAS"."ISPEC", "ITEMAS"."JIJIL"
		  INTO :sItDsc,   		 :sIspec, 		:sJijil
		  FROM "ITEMAS"
		 WHERE "ITEMAS"."ITNBR" = :sItnbr AND	"ITEMAS"."USEYN" = '0' ;

		IF SQLCA.SQLCODE <> 0 THEN
			MessageBox("품번", "등록되지 않은 품번입니다", stopsign!)
         p_can.triggerevent(clicked!)
			Return 1
		END IF
	
		SetItem(nRow,"itdsc",   sItDsc)
		SetItem(nRow,"ispec",   sIspec)
		SetItem(nRow,"jijil",   sJijil)

	dw_insert.reset()
	DECLARE erp_create_pstruc_to_wstruc PROCEDURE FOR erp_create_pstruc_to_wstruc(:sItnbr);
	EXECUTE erp_create_pstruc_to_wstruc;

	dw_insert.Retrieve(sItnbr)
END Choose



end event

event itemerror;call super::itemerror;return 1
end event

event rbuttondown;call super::rbuttondown;Long nRow
String sItnbr, sNull

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)
SetNull(sNull)

sle_msg.text = ''
nRow     = GetRow()
If nRow <= 0 Then Return

Choose Case GetcolumnName() 
	Case "itnbr"
		gs_gubun = '1'
		Open(w_itemas_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
		SetItem(nRow,"itnbr",gs_code)
		PostEvent(ItemChanged!)	 
	Case "itdsc"
		gs_gubun = '1'
		gs_codename = GetText()
		open(w_itemas_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
		SetColumn("itnbr")
		SetItem(nRow,"itnbr",gs_code)
		PostEvent(ItemChanged!)
	Case "ispec", "jijil"
		gs_gubun = '1'
		open(w_itemas_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
		SetColumn("itnbr")
		SetItem(nRow,"itnbr",gs_code)
		PostEvent(ItemChanged!)
END Choose
end event

type rr_1 from roundrectangle within w_pdm_01535
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 160
integer y = 344
integer width = 3488
integer height = 1572
integer cornerheight = 40
integer cornerwidth = 55
end type

