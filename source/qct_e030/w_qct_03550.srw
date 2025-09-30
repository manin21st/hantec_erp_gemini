$PBExportHeader$w_qct_03550.srw
$PBExportComments$VOC 처리/미처리 현황
forward
global type w_qct_03550 from w_standard_print
end type
type pb_2 from u_pb_cal within w_qct_03550
end type
type pb_1 from u_pb_cal within w_qct_03550
end type
type rr_1 from roundrectangle within w_qct_03550
end type
end forward

global type w_qct_03550 from w_standard_print
integer width = 4640
string title = "VOC 처리/미처리 현황"
pb_2 pb_2
pb_1 pb_1
rr_1 rr_1
end type
global w_qct_03550 w_qct_03550

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string sdate, edate, t_name, grp, wongu

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

sdate  = trim(dw_ip.object.sdate[1])
edate  = trim(dw_ip.object.edate[1])
wongu  = trim(dw_ip.object.wongu[1])
grp    = trim(dw_ip.object.grp[1])

if (IsNull(sdate) or sdate = "")  then sdate = "10000101"
if (IsNull(edate) or edate = "")  then edate = "99991231"
if (IsNull(wongu) or wongu = "") then 
	wongu = "%"
end if	

if (IsNull(grp) or grp = "") then 
	grp = "%"
end if

IF dw_print.Retrieve(gs_sabu, sdate, edate, grp,wongu) <= 0 then
	f_message_chk(50,'[VOC 접수처리 현황]')
	dw_list.Reset()
	dw_ip.SetFocus()
   dw_list.SetRedraw(true)
	dw_print.Reset()
	Return -1
END IF

t_name = String(sdate,'@@@@.@@.@@') + "-" + String(edate,'@@@@.@@.@@')
If IsNull(t_name) Or t_name = '' Then t_name = '전체'
dw_print.Modify("txt_ymd.text = '"+t_name+"'")

dw_print.ShareData(dw_list)

return 1


end function

on w_qct_03550.create
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

on w_qct_03550.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;dw_ip.SetItem(1,'grp','10')
f_child_wongu(dw_ip, 'wongu', '10')
end event

type p_preview from w_standard_print`p_preview within w_qct_03550
end type

type p_exit from w_standard_print`p_exit within w_qct_03550
end type

type p_print from w_standard_print`p_print within w_qct_03550
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_03550
end type







type st_10 from w_standard_print`st_10 within w_qct_03550
end type



type dw_print from w_standard_print`dw_print within w_qct_03550
string dataobject = "d_qct_03550_02_P"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_03550
integer x = 46
integer y = 44
integer width = 3163
integer height = 244
string dataobject = "d_qct_03550_01"
end type

event dw_ip::itemchanged;String s_cod

s_cod = Trim(this.gettext())

if this.GetColumnName() = "gubun"  then //구분
   if s_cod = "1" then
		dw_list.DataObject = "d_qct_03550_02"
		dw_print.DataObject = "d_qct_03550_02_p"
	else
		dw_list.DataObject = "d_qct_03550_03"
		dw_print.DataObject = "d_qct_03550_03_p"
	end if
	dw_list.SetTransObject(SQLCA)
	dw_print.SetTransObject(SQLCA)
	
	
elseif this.GetColumnName() = "sdate"  then //접수일자
   if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[시작일자]")
		this.object.sdate[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "edate"  then //접수일자
   if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[끝일자]")
		this.object.edate[1] = ""
		return 1
	end if
elseif (this.GetColumnName() = "grp") Then //원인 그룹
	if IsNull(s_cod) or s_cod = "" then return

   f_child_wongu(this, 'wongu', s_cod)		
end if

end event

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_qct_03550
integer x = 59
integer y = 296
integer width = 4521
integer height = 1964
string dataobject = "d_qct_03550_02"
boolean border = false
end type

type pb_2 from u_pb_cal within w_qct_03550
integer x = 1248
integer y = 156
integer taborder = 70
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('edate')
IF Isnull(gs_code) THEN Return
dw_ip.SetItem(dw_ip.getrow(), 'edate', gs_code)
end event

type pb_1 from u_pb_cal within w_qct_03550
integer x = 782
integer y = 156
integer taborder = 80
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('sdate')
IF Isnull(gs_code) THEN Return
dw_ip.SetItem(dw_ip.getrow(), 'sdate', gs_code)
end event

type rr_1 from roundrectangle within w_qct_03550
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 288
integer width = 4553
integer height = 1984
integer cornerheight = 40
integer cornerwidth = 55
end type

