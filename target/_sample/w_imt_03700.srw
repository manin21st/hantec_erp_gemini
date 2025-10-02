$PBExportHeader$w_imt_03700.srw
$PBExportComments$L/C������Ȳ
forward
global type w_imt_03700 from w_standard_print
end type
type pb_1 from u_pic_cal within w_imt_03700
end type
type pb_2 from u_pic_cal within w_imt_03700
end type
end forward

global type w_imt_03700 from w_standard_print
string title = "L/C������Ȳ"
pb_1 pb_1
pb_2 pb_2
end type
global w_imt_03700 w_imt_03700

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string sdate, edate, slcno, elcno

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

sdate = trim(dw_ip.object.sdate[1])
edate = trim(dw_ip.object.edate[1])
slcno = trim(dw_ip.object.flcno[1])
elcno = trim(dw_ip.object.tlcno[1])

if (IsNull(sdate) or sdate = "") then sdate = "11110101"
if (IsNull(edate) or edate = "") then edate = "99991231"

if (IsNull(slcno) or slcno = "") then slcno = "."
if (IsNull(elcno) or elcno = "") then elcno = "zzzzzzzzzzzzzzzzzzzz"

//if dw_list.Retrieve(gs_sabu, sdate, edate, slcno, elcno) <= 0 then
//	f_message_chk(50,'[L/C ���� ��Ȳ]')
//	dw_ip.Setfocus()
//	return -1
//end if

IF dw_print.Retrieve(gs_sabu, sdate, edate, slcno, elcno) <= 0 then
	f_message_chk(50,'[L/C ���� ��Ȳ]')
	dw_ip.Setfocus()
	dw_list.Reset()
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)

return 1
end function

on w_imt_03700.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
end on

on w_imt_03700.destroy
call super::destroy
destroy(this.pb_1)
destroy(this.pb_2)
end on

type dw_list from w_standard_print`dw_list within w_imt_03700
integer y = 282
integer width = 3489
integer height = 1964
string dataobject = "d_imt_03700_2"
end type

type cb_print from w_standard_print`cb_print within w_imt_03700
end type

type cb_excel from w_standard_print`cb_excel within w_imt_03700
end type

type cb_preview from w_standard_print`cb_preview within w_imt_03700
end type

type cb_1 from w_standard_print`cb_1 within w_imt_03700
end type

type dw_print from w_standard_print`dw_print within w_imt_03700
string dataobject = "d_imt_03700_2_p"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_03700
integer y = 56
integer width = 3489
integer height = 188
string dataobject = "d_imt_03700_1"
end type

event dw_ip::itemchanged;string s_cod, s_nam1, s_nam2
integer i_rtn

s_cod = Trim(this.gettext())

if this.GetColumnName() = "sdate" then
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35,"[��������]")
		this.object.sdate[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "edate" then
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35,"[������]")
		this.object.edate[1] = ""
		return 1
	end if
end if

end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;setNull(gs_code)
setNull(gs_codename)
setNull(gs_gubun)

IF this.GetColumnName() = 'flcno'	THEN
	
	Open(w_lc_popup)
		
	if isNull(gs_code) or trim(gs_code) = ''	then	return
	SetItem(1, "flcno", gs_code)
ELSEIF this.GetColumnName() = 'tlcno'	THEN
	
	Open(w_lc_popup)
		
	if isNull(gs_code) or trim(gs_code) = ''	then	return
	SetItem(1, "tlcno", gs_code)
END IF




end event

type r_1 from w_standard_print`r_1 within w_imt_03700
end type

type r_2 from w_standard_print`r_2 within w_imt_03700
end type

type pb_1 from u_pic_cal within w_imt_03700
integer x = 704
integer y = 112
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('sdate')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'sdate', gs_code)



end event

type pb_2 from u_pic_cal within w_imt_03700
integer x = 1138
integer y = 112
integer taborder = 70
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('edate')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'edate', gs_code)



end event

