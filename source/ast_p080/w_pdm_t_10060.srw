$PBExportHeader$w_pdm_t_10060.srw
$PBExportComments$원가 계산서(을지 - 재료비 내역)
forward
global type w_pdm_t_10060 from w_standard_print
end type
type rr_1 from roundrectangle within w_pdm_t_10060
end type
type rr_2 from roundrectangle within w_pdm_t_10060
end type
end forward

global type w_pdm_t_10060 from w_standard_print
string title = "원가 계산서(을지-재료비 내역)"
rr_1 rr_1
rr_2 rr_2
end type
global w_pdm_t_10060 w_pdm_t_10060

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();Decimal n

String ls_econo, ls_itnbr, ls_start_date, ls_end_date, ls_for_date

dw_ip.AcceptText()

ls_econo = dw_ip.GetItemString(1, 'econo')
ls_itnbr = dw_ip.GetItemString(1, 'itnbr')

IF ls_econo = '' OR IsNull(ls_econo) THEN 
	f_message_chk(30, 'Eco No')
	dw_ip.setColumn("econo")
	dw_ip.setFocus()
	return -1
	
ELSEIF ls_itnbr = '' OR IsNull(ls_itnbr) THEN 
	f_message_chk(30, '제품 번호')
	dw_ip.setColumn("itnbr")
	dw_ip.setFocus()
	return -1
End If

IF dw_print.retrieve(gs_sabu, ls_econo, ls_itnbr) = 0 THEN
	f_message_chk(50, '원가 계산서[을지-재료비내역]')
	return -1
END IF

dw_print.ShareData(dw_list)

return 1
end function

on w_pdm_t_10060.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.rr_2
end on

on w_pdm_t_10060.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.rr_2)
end on

type p_preview from w_standard_print`p_preview within w_pdm_t_10060
end type

type p_exit from w_standard_print`p_exit within w_pdm_t_10060
end type

type p_print from w_standard_print`p_print within w_pdm_t_10060
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdm_t_10060
end type







type st_10 from w_standard_print`st_10 within w_pdm_t_10060
end type



type dw_print from w_standard_print`dw_print within w_pdm_t_10060
string dataobject = "d_pdm_t_10060_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdm_t_10060
integer x = 64
integer y = 100
integer width = 1787
integer height = 240
string dataobject = "d_pdm_t_10060_h"
end type

event dw_ip::itemchanged;call super::itemchanged;String ls_data, ls_cvnas2, ls_itdsc
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
		Return 1
	End If

	this.SetItem(1,'econo', ls_cvnas2)
	
ELSEIf getColumnName() = 'itnbr'  Then
	ls_data = GetText()

	Select itdsc
	  into :ls_itdsc
	  From itemas 
	 WHERE itnbr = :ls_data;
	
	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox("확인","제품번호가 존재하지 않습니다.", Exclamation!)
		Return 1
	END IF
	this.SetItem(1,'rfna1', ls_itdsc)
	
	p_retrieve.PostEvent(clicked!)
End If
end event

event dw_ip::itemerror;call super::itemerror;Return 1
end event

event dw_ip::rbuttondown;call super::rbuttondown;String ls_name

If GetColumnName() = 'econo' Then
	Open(w_ecomst_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
   /* 제 품 명 */ 
	Select NVL(itdsc, '')
	  into :ls_name
	  From itemas
	 Where itnbr   = :gs_codename
	 Using sqlca;
 
	SetItem(1,'econo', gs_code)
	SetItem(1,'itnbr', gs_codename) //품 번
	SetItem(1,'rfna1', ls_name)     //품 명

ElseIf GetColumnName() = 'itnbr' Then

	Open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	SetItem(1, 'itnbr', gs_code)
	SetItem(1, 'rfna1', gs_codename)

End If
end event

type dw_list from w_standard_print`dw_list within w_pdm_t_10060
integer x = 23
integer y = 408
integer height = 1856
string dataobject = "d_pdm_t_10060_d"
boolean border = false
end type

type rr_1 from roundrectangle within w_pdm_t_10060
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 46
integer y = 80
integer width = 1856
integer height = 288
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pdm_t_10060
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 404
integer width = 4622
integer height = 1876
integer cornerheight = 40
integer cornerwidth = 55
end type

