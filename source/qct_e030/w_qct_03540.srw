$PBExportHeader$w_qct_03540.srw
$PBExportComments$불만 조사 보고서
forward
global type w_qct_03540 from w_standard_print
end type
type pb_2 from u_pb_cal within w_qct_03540
end type
type pb_1 from u_pb_cal within w_qct_03540
end type
type rr_1 from roundrectangle within w_qct_03540
end type
end forward

global type w_qct_03540 from w_standard_print
integer width = 4640
integer height = 2440
string title = "불만 조사 보고서"
pb_2 pb_2
pb_1 pb_1
rr_1 rr_1
end type
global w_qct_03540 w_qct_03540

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_clrdat1, ls_clrdat2,  ls_cl_jpno1, ls_cl_jpno2

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

ls_clrdat1 = trim(dw_ip.object.clrdat1[1])
ls_clrdat2 = trim(dw_ip.object.clrdat2[1])
ls_cl_jpno1 = trim(dw_ip.object.cl_jpno1[1])
ls_cl_jpno2 = trim(dw_ip.object.cl_jpno2[1])


if (IsNull(ls_clrdat1) or ls_clrdat1 = "")  then ls_clrdat1 = "10000101"
if (IsNull(ls_clrdat2) or ls_clrdat2 = "")  then ls_clrdat2 = "99991231"
if (IsNull(ls_cl_jpno1) or ls_cl_jpno1 = "")  then ls_cl_jpno1 = "."
if (IsNull(ls_cl_jpno2) or ls_cl_jpno2 = "")  then ls_cl_jpno2 = "zzzzzzzzzzzz"

IF dw_print.Retrieve(gs_sabu, ls_cl_jpno1, ls_cl_jpno2,  ls_clrdat1, ls_clrdat2 ) <= 0 then
	f_message_chk(50,'[불만 (CLAIM) 조사 보고서]')
	dw_list.Reset()
	dw_ip.SetFocus()
   dw_list.SetRedraw(true)
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)

return 1
end function

on w_qct_03540.create
int iCurrent
call super::create
this.pb_2=create pb_2
this.pb_1=create pb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_2
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.rr_1
end on

on w_qct_03540.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.rr_1)
end on

type p_preview from w_standard_print`p_preview within w_qct_03540
end type

type p_exit from w_standard_print`p_exit within w_qct_03540
end type

type p_print from w_standard_print`p_print within w_qct_03540
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_03540
end type







type st_10 from w_standard_print`st_10 within w_qct_03540
end type



type dw_print from w_standard_print`dw_print within w_qct_03540
string dataobject = "d_qct_03540_01_p"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_03540
integer x = 411
integer y = 56
integer width = 3045
integer height = 140
string dataobject = "d_qct_03540"
end type

event dw_ip::rbuttondown;call super::rbuttondown;if this.GetColumnName() = "cl_jpno1" Then //CLIAM1 번호
	open(w_claimno_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.object.cl_jpno1[1] = gs_code
   

ELSEif this.GetColumnName() = "cl_jpno2" Then //CLIAM2 번호
	open(w_claimno_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.object.cl_jpno2[1] = gs_code
   
END IF
end event

event dw_ip::itemchanged;String  s_cod
Integer i_rtn

s_cod = Trim(this.GetText())

if this.GetColumnName() = "clrdat1" Then 
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[시작일자]")
		this.object.clrdat1[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "clrdat2" Then 
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[끝일자]")
		this.object.clrdat2[1] = ""
		return 1
	end if
END IF
	
end event

event dw_ip::itemerror;call super::itemerror;RETURN 1

end event

type dw_list from w_standard_print`dw_list within w_qct_03540
integer x = 425
integer y = 212
integer width = 3525
integer height = 2048
string dataobject = "d_qct_03540_01"
boolean border = false
end type

type pb_2 from u_pb_cal within w_qct_03540
integer x = 3337
integer y = 72
integer taborder = 70
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('edate')
IF Isnull(gs_code) THEN Return
dw_ip.SetItem(dw_ip.getrow(), 'edate', gs_code)
end event

type pb_1 from u_pb_cal within w_qct_03540
integer x = 2875
integer y = 72
integer taborder = 80
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('sdate')
IF Isnull(gs_code) THEN Return
dw_ip.SetItem(dw_ip.getrow(), 'sdate', gs_code)
end event

type rr_1 from roundrectangle within w_qct_03540
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 411
integer y = 200
integer width = 3566
integer height = 2076
integer cornerheight = 40
integer cornerwidth = 55
end type

