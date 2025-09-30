$PBExportHeader$w_qa90_00110.srw
$PBExportComments$계측기기 그룹 일람표
forward
global type w_qa90_00110 from w_standard_print
end type
type rr_1 from roundrectangle within w_qa90_00110
end type
end forward

global type w_qa90_00110 from w_standard_print
string title = "계측기기 그룹 일람표"
rr_1 rr_1
end type
global w_qa90_00110 w_qa90_00110

type variables
boolean lb_src_down, lb_dsc_down
String s_row
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String ls_grpcd , ls_grpnm ,ls_grpsite

if dw_ip.AcceptText() = -1 then 
	dw_ip.SetFocus()
	return -1
end if	

ls_grpcd   = trim(dw_ip.object.code[1])
ls_grpnm   = trim(dw_ip.object.name[1])
ls_grpsite = trim(dw_ip.object.site[1])

if IsNull(ls_grpcd) or ls_grpcd = ""  then ls_grpcd = '%%'
if IsNull(ls_grpnm) or ls_grpnm = ""  then ls_grpnm = '%%'
if IsNull(ls_grpsite) or ls_grpsite = ""  then ls_grpsite = '%%'

if dw_list.Retrieve(gs_sabu, ls_grpcd , ls_grpnm ,ls_grpsite ) <= 0 then
	f_message_chk(50,"[품질 이력 현황]")
	dw_ip.Setfocus()
	return -1

end if

Return 1
	
end function

on w_qa90_00110.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_qa90_00110.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

type p_preview from w_standard_print`p_preview within w_qa90_00110
integer x = 4046
integer y = 32
end type

type p_exit from w_standard_print`p_exit within w_qa90_00110
integer x = 4389
integer y = 32
integer taborder = 110
end type

type p_print from w_standard_print`p_print within w_qa90_00110
integer x = 4219
integer y = 32
integer taborder = 70
end type

type p_retrieve from w_standard_print`p_retrieve within w_qa90_00110
integer x = 3877
integer y = 32
end type



type sle_msg from w_standard_print`sle_msg within w_qa90_00110
boolean displayonly = true
end type



type st_10 from w_standard_print`st_10 within w_qa90_00110
end type



type dw_print from w_standard_print`dw_print within w_qa90_00110
string dataobject = "d_qa90_00110_p"
end type

type dw_ip from w_standard_print`dw_ip within w_qa90_00110
integer x = 37
integer y = 32
integer width = 1678
integer height = 184
string dataobject = "d_qa90_00110_1"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;call super::itemchanged;String  s_cod, s_nam1, s_nam2
integer i_rtn

s_cod = Trim(this.GetText())

if this.GetColumnName() = "site" then 
	if IsNull(s_cod) or s_cod = "" then return 1
	
	Select cvnas Into :s_nam1 
	  From VNDMST
	 Where cvcod = :s_cod ;
	
	If SQLCA.SQLCODE <> 0 then
		This.Object.site[1]  = ''
		This.Object.cvnas[1]  = ''
		f_message_chk(33, "[거래처 - From]")
		Return 1
	Else
		This.Object.cvnas[1]  = s_nam1
	End If	
end if


end event

event dw_ip::rbuttondown;call super::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

if	 this.getcolumnname() = "site" then

	open(w_vndmst_popup)
	If IsNull(gs_code) Or gs_code = '' Then ReTurn
	
	this.SetItem(1, "site", gs_code)
	this.Trigger Event itemchanged(GetRow(),dwo,gs_code)
End If
end event

type dw_list from w_standard_print`dw_list within w_qa90_00110
integer x = 55
integer y = 228
integer width = 4498
integer height = 2044
string dataobject = "d_qa90_00110_a"
boolean border = false
end type

event dw_list::clicked;call super::clicked;If Row <= 0 then
	SelectRow(0,False)
ELSE
	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
END IF
end event

type rr_1 from roundrectangle within w_qa90_00110
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 220
integer width = 4521
integer height = 2064
integer cornerheight = 40
integer cornerwidth = 55
end type

