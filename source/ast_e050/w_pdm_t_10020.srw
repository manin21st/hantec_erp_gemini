$PBExportHeader$w_pdm_t_10020.srw
$PBExportComments$태성 모델/차종별 품목현황
forward
global type w_pdm_t_10020 from w_standard_print
end type
type rr_1 from roundrectangle within w_pdm_t_10020
end type
type rr_2 from roundrectangle within w_pdm_t_10020
end type
end forward

global type w_pdm_t_10020 from w_standard_print
integer height = 2496
string title = "모델별 품목현황"
rr_1 rr_1
rr_2 rr_2
end type
global w_pdm_t_10020 w_pdm_t_10020

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String ls_cvcod_from, ls_cvcod_to, ls_saupj, ls_ittyp

dw_ip.AcceptText()

ls_cvcod_from 	= dw_ip.GetItemString(1,'cvcod_from')
ls_cvcod_to 		= dw_ip.GetItemString(1,'cvcod_to')
ls_saupj 			= dw_ip.GetItemString(1,'saupj')
ls_ittyp 			= dw_ip.GetItemString(1,'ittyp')

IF ls_cvcod_from 	= '' OR IsNull(ls_cvcod_from) THEN ls_cvcod_from = '.'
IF ls_cvcod_to 		= '' OR IsNull(ls_cvcod_to) THEN ls_cvcod_to = 'zzzzzz'
IF ls_ittyp 				= '' OR IsNull(ls_ittyp) THEN ls_ittyp = '%'

IF 	dw_print.retrieve(ls_saupj, ls_ittyp, ls_cvcod_from, ls_cvcod_to) = 0 THEN
	f_message_chk(50, '모델/차종별 품목현황')
	return -1
END IF


dw_print.Object.t_6.text = dw_ip.GetItemString(1,'cvnasf')
dw_print.Object.t_7.text = dw_ip.GetItemString(1,'cvnast')

dw_print.ShareData(dw_list)

return 1
end function

on w_pdm_t_10020.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.rr_2
end on

on w_pdm_t_10020.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;f_mod_saupj(dw_ip, 'saupj')


end event

type p_preview from w_standard_print`p_preview within w_pdm_t_10020
end type

type p_exit from w_standard_print`p_exit within w_pdm_t_10020
end type

type p_print from w_standard_print`p_print within w_pdm_t_10020
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdm_t_10020
end type







type st_10 from w_standard_print`st_10 within w_pdm_t_10020
end type



type dw_print from w_standard_print`dw_print within w_pdm_t_10020
string dataobject = "d_pdm_t_10020_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdm_t_10020
integer x = 64
integer y = 100
integer width = 2427
integer height = 184
string dataobject = "d_pdm_t_10020_h"
end type

event dw_ip::itemchanged;call super::itemchanged;String ls_data, ls_cvnas2
long ll_count


if getColumnName() = 'cvcod_from' Then
	ls_data = GetText()

	Select cvnas2
	into :ls_cvnas2
	From VNDMST 
	WHERE CVCOD = :ls_data;

	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox("확인","거래처 코드가 존재하지 않습니다.",Exclamation!)
		this.SetItem(1,'cvcod_from', '')
		Return 1
	End If

	this.SetItem(1,'cvnasf', ls_cvnas2)
	
ELSEIf getColumnName() = 'cvcod_to'  Then

	ls_data = GetText()

	Select cvnas2
	into :ls_cvnas2
	From VNDMST 
	WHERE CVCOD = :ls_data;
	
	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox("확인","거래처 코드가 존재하지 않습니다.",Exclamation!)
		Return 1
	END IF
		
	this.SetItem(1,'cvnast', ls_cvnas2)
	
	p_retrieve.PostEvent(clicked!)
End If
end event

event dw_ip::itemerror;call super::itemerror;Return 1
end event

event dw_ip::rbuttondown;call super::rbuttondown;If GetColumnName() = 'cvcod_from' Then
	Open(w_vndmst_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	SetItem(1,'cvcod_from', gs_code)
	SetItem(1,'cvnasf', gs_codename)
	
ElseIf GetColumnName() = 'cvcod_to' Then

	Open(w_vndmst_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	SetItem(1,'cvcod_to', gs_code)
	SetItem(1,'cvnast', gs_codename)

End If
end event

type dw_list from w_standard_print`dw_list within w_pdm_t_10020
integer x = 23
integer y = 328
string dataobject = "d_pdm_t_10020_d"
boolean border = false
end type

type rr_1 from roundrectangle within w_pdm_t_10020
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 50
integer y = 80
integer width = 2505
integer height = 216
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pdm_t_10020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 324
integer width = 4622
integer height = 1932
integer cornerheight = 40
integer cornerwidth = 55
end type

