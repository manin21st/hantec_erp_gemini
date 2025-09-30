$PBExportHeader$w_qct_02590.srw
$PBExportComments$** 제안결과현황
forward
global type w_qct_02590 from w_standard_print
end type
type pb_1 from u_pb_cal within w_qct_02590
end type
type pb_2 from u_pb_cal within w_qct_02590
end type
end forward

global type w_qct_02590 from w_standard_print
string title = "제안 결과 현황"
pb_1 pb_1
pb_2 pb_2
end type
global w_qct_02590 w_qct_02590

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string  sdate, edate , dept

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

dept  = trim(dw_ip.object.dept[1])
sdate = trim(dw_ip.object.sdate[1])
edate = trim(dw_ip.object.edate[1])

if (IsNull(dept) or dept = "")  then dept = '%' 
if (IsNull(sdate) or sdate = "")  then sdate = "10000101"
if (IsNull(edate) or edate = "")  then edate = "99991231"

//dw_list.object.txt_ymd.text = String(sdate, "@@@@.@@.@@") + " - " + String(edate, "@@@@.@@.@@")
//
//if dw_list.Retrieve(gs_sabu, dept, sdate, edate) <= 0 then
//   f_message_chk(50,'[제안 결과 현황]')
//   dw_ip.Setfocus()
//   return -1
//end if
	
IF dw_print.Retrieve(gs_sabu, dept, sdate, edate) <= 0 then
   f_message_chk(50,'[제안 결과 현황]')
	dw_list.Reset()
	dw_ip.SetFocus()
   dw_list.SetRedraw(true)
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.object.txt_ymd.text = String(sdate, "@@@@.@@.@@") + " - " + String(edate, "@@@@.@@.@@")

dw_print.ShareData(dw_list)

return 1
end function

on w_qct_02590.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
end on

on w_qct_02590.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
end on

type p_preview from w_standard_print`p_preview within w_qct_02590
end type

type p_exit from w_standard_print`p_exit within w_qct_02590
end type

type p_print from w_standard_print`p_print within w_qct_02590
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_02590
end type







type st_10 from w_standard_print`st_10 within w_qct_02590
end type



type dw_print from w_standard_print`dw_print within w_qct_02590
string dataobject = "d_qct_02590_02"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_02590
integer x = 37
integer y = 0
integer width = 1632
integer height = 180
string dataobject = "d_qct_02590_01"
end type

event dw_ip::itemchanged;call super::itemchanged;string s_cod

s_cod = Trim(this.gettext())

if this.GetColumnName() = "sdate" then
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35,"[시작일자]")
		this.object.sdate[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "edate" then
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35,"[끝일자]")
		this.object.edate[1] = ""
		return 1
	end if
end if

end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_qct_02590
string dataobject = "d_qct_02590_02"
end type

type pb_1 from u_pb_cal within w_qct_02590
integer x = 1038
integer y = 68
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('sdate')
IF Isnull(gs_code) THEN Return
dw_ip.SetItem(dw_ip.getrow(), 'sdate', gs_code)
end event

type pb_2 from u_pb_cal within w_qct_02590
integer x = 1477
integer y = 68
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('edate')
IF Isnull(gs_code) THEN Return
dw_ip.SetItem(dw_ip.getrow(), 'edate', gs_code)
end event

