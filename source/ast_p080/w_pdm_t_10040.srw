$PBExportHeader$w_pdm_t_10040.srw
$PBExportComments$설계원가 계산서 현황
forward
global type w_pdm_t_10040 from w_standard_print
end type
type rr_1 from roundrectangle within w_pdm_t_10040
end type
type rr_2 from roundrectangle within w_pdm_t_10040
end type
end forward

global type w_pdm_t_10040 from w_standard_print
string title = "설계원가 계산서 현황"
rr_1 rr_1
rr_2 rr_2
end type
global w_pdm_t_10040 w_pdm_t_10040

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();Decimal n

String ls_econo, ls_start_date, ls_end_date, ls_for_date

dw_ip.AcceptText()

ls_econo = dw_ip.GetItemString(1,'econo')
//ls_cvcod_to = dw_ip.GetItemString(1,'cvcod_to')

IF ls_econo = '' OR IsNull(ls_econo) THEN 
	f_message_chk(30, 'Eco No')
	dw_ip.setFocus()
	return -1
//	ls_econo = '.'
End If
//IF ls_cvcod_to = '' OR IsNull(ls_cvcod_to) THEN ls_cvcod_to = 'zzzzzz'

// dw_list 를 조회 하는 것이 아니라. dw_print를 조회하여 
// dw_print.ShareData(dw_list)로 처리
// IF dw_print.retrieve(ls_econo) = 0 THEN
IF dw_print.retrieve(ls_econo) = 0 THEN
	f_message_chk(50, '설계원가 계산서 현황')
	return -1
END IF

dw_print.Object.t_7.text = dw_ip.GetItemString(1,'econo')

dw_print.ShareData(dw_list)

return 1
end function

on w_pdm_t_10040.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.rr_2
end on

on w_pdm_t_10040.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.rr_2)
end on

type p_preview from w_standard_print`p_preview within w_pdm_t_10040
end type

type p_exit from w_standard_print`p_exit within w_pdm_t_10040
end type

type p_print from w_standard_print`p_print within w_pdm_t_10040
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdm_t_10040
end type







type st_10 from w_standard_print`st_10 within w_pdm_t_10040
end type



type dw_print from w_standard_print`dw_print within w_pdm_t_10040
string dataobject = "d_pdm_t_10040_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdm_t_10040
integer x = 32
integer y = 100
integer width = 2615
integer height = 124
string dataobject = "d_pdm_t_10040_h"
end type

event dw_ip::itemchanged;call super::itemchanged;String ls_data, ls_cvnas2, ls_itnbr, ls_
long ll_count


if getColumnName() = 'econo' Then
	ls_data = GetText()

	Select eco_no
	into :ls_cvnas2
	From ECOMST 
	WHERE ECO_NO = :ls_data;

	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox("확인","ECO No가 존재하지 않습니다.",Exclamation!)
		this.SetItem(1,'econo', '')
		this.SetItem(1,'itnbr', '')
		this.SetItem(1,'rfna1', '')
		Return 1
	End If

	this.SetItem(1,'econo', ls_cvnas2)
	
End If
end event

event dw_ip::itemerror;call super::itemerror;Return 1
end event

event dw_ip::rbuttondown;call super::rbuttondown;If GetColumnName() = 'econo' Then
	Open(w_ecomst_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	dw_ip.SetItem(1,'econo', gs_code)
	dw_ip.SetItem(1,'itnbr', gs_codename) //품번
	dw_ip.SetItem(1,'rfna1', gs_gubun) //차종

	p_retrieve.TriggerEvent(Clicked!)

End If
end event

type dw_list from w_standard_print`dw_list within w_pdm_t_10040
integer x = 32
integer y = 276
integer width = 4558
integer height = 2032
string dataobject = "d_pdm_t_10040_d"
boolean border = false
end type

type rr_1 from roundrectangle within w_pdm_t_10040
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 14
integer y = 72
integer width = 2665
integer height = 168
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pdm_t_10040
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 268
integer width = 4590
integer height = 2056
integer cornerheight = 40
integer cornerwidth = 55
end type

