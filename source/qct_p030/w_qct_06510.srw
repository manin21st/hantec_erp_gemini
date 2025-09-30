$PBExportHeader$w_qct_06510.srw
$PBExportComments$** 업체별불량현황(수입검사)
forward
global type w_qct_06510 from w_standard_print
end type
type rr_2 from roundrectangle within w_qct_06510
end type
end forward

global type w_qct_06510 from w_standard_print
string title = " 업체별 불량현황(수입검사)"
rr_2 rr_2
end type
global w_qct_06510 w_qct_06510

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ym

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

ym = Trim(dw_ip.object.ym[1])

if (IsNull(ym) or ym = "")  then 
	f_message_chk(30, "[기준년월]")
	dw_ip.SetColumn("ym")
	dw_ip.Setfocus()
	return -1
end if

//dw_list.object.txt_title.text = String(ym,"@@@@년 @@월 업체별 불량현황(수입검사)")

//if dw_list.Retrieve(gs_sabu, ym) <= 0 then
//	f_message_chk(50,'[업체별 불량현황(수입검사)]')
//	dw_ip.Setfocus()
//	return -1
//end if

IF dw_print.Retrieve(gs_sabu, ym) <= 0 then
	f_message_chk(50,'[업체별 불량현황(수입검사)]')
	dw_list.Reset()
	dw_ip.SetFocus()
	dw_list.SetRedraw(true)
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)

return 1
end function

on w_qct_06510.create
int iCurrent
call super::create
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
end on

on w_qct_06510.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_2)
end on

event open;call super::open;dw_ip.SetItem(1,"ym", Left(F_Today(),6))
dw_ip.SetFocus()
end event

type p_preview from w_standard_print`p_preview within w_qct_06510
integer x = 4073
end type

type p_exit from w_standard_print`p_exit within w_qct_06510
integer x = 4421
end type

type p_print from w_standard_print`p_print within w_qct_06510
integer x = 4247
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_06510
integer x = 3899
end type







type st_10 from w_standard_print`st_10 within w_qct_06510
end type



type dw_print from w_standard_print`dw_print within w_qct_06510
integer x = 3296
integer width = 507
string dataobject = "d_qct_06510_02_p"
boolean border = false
end type

type dw_ip from w_standard_print`dw_ip within w_qct_06510
integer x = 270
integer y = 36
integer width = 2208
integer height = 136
string dataobject = "d_qct_06510_01"
end type

event dw_ip::itemchanged;string s_cod

s_cod = Trim(this.GetText())

if this.GetColumnName() = "ym" then
	if f_datechk(s_cod + '01') = -1 then
		f_message_chk(35, "[기준년월]")
		this.object.ym[1] = ""
		return 1
	end if
end if


If this.GetColumnName() = "gub" then
	If GetText() = '1' Then
		dw_list.DataObject = 'd_qct_06510_02'
		dw_print.DataObject = 'd_qct_06510_02_p'
	Else
		dw_list.DataObject = 'd_qct_06510_02_lot'
		dw_print.DataObject = 'd_qct_06510_02_lot_p'
	End If
	dw_list.SetTransObject(sqlca)
	dw_print.SetTransObject(sqlca)
End If
end event

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_qct_06510
integer x = 297
integer y = 196
integer width = 4160
integer height = 2000
string dataobject = "d_qct_06510_02"
boolean border = false
end type

type rr_2 from roundrectangle within w_qct_06510
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 283
integer y = 188
integer width = 4215
integer height = 2020
integer cornerheight = 40
integer cornerwidth = 55
end type

