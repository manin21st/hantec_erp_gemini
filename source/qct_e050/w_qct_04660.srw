$PBExportHeader$w_qct_04660.srw
$PBExportComments$**업체방문A/S현황
forward
global type w_qct_04660 from w_standard_print
end type
type dw_1 from u_key_enter within w_qct_04660
end type
type rr_1 from roundrectangle within w_qct_04660
end type
type rr_2 from roundrectangle within w_qct_04660
end type
end forward

global type w_qct_04660 from w_standard_print
string title = "업체방문 A/S 현황"
dw_1 dw_1
rr_1 rr_1
rr_2 rr_2
end type
global w_qct_04660 w_qct_04660

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string  sdate, edate, rcvlog

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

sdate = trim(dw_ip.object.sdate[1])
edate = trim(dw_ip.object.edate[1])
rcvlog = trim(dw_ip.object.rcvlog[1])

if (IsNull(sdate) or sdate = "")  then sdate = "10001010"
if (IsNull(edate) or edate = "")  then edate = "99991231"
if (IsNull(rcvlog) or rcvlog = "")  then 
	//dw_list.object.txt_rcvlog.text = "전체"
	rcvlog = "%"
//else
//	dw_list.object.txt_rcvlog.text = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(rcvlog) ', 1)"))
end if	

//dw_list.object.txt_ymd.text = String(sdate,"@@@@.@@.@@") + " - " + String(edate,"@@@@.@@.@@")

IF dw_print.Retrieve(gs_sabu, sdate, edate, rcvlog) <= 0 then
	if dw_1.object.gubun[1] = "1" then
   	f_message_chk(50,'[업체방문 A/S 현황]')
	else
		f_message_chk(50,'[업체방문 원인별 A/S 현황]')
	end if	
	dw_list.Reset()
	dw_ip.SetFocus()
   dw_list.SetRedraw(true)
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)

return 1
end function

on w_qct_04660.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.rr_1
this.Control[iCurrent+3]=this.rr_2
end on

on w_qct_04660.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_1.SetTransObject(SQLCA)
dw_1.ReSet()
dw_1.InsertRow(0)
end event

type p_preview from w_standard_print`p_preview within w_qct_04660
end type

type p_exit from w_standard_print`p_exit within w_qct_04660
end type

type p_print from w_standard_print`p_print within w_qct_04660
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_04660
end type







type st_10 from w_standard_print`st_10 within w_qct_04660
end type



type dw_print from w_standard_print`dw_print within w_qct_04660
string dataobject = "d_qct_04660_02_P"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_04660
integer x = 1317
integer y = 60
integer width = 1088
integer height = 176
string dataobject = "d_qct_04660_01"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;call super::itemchanged;String  s_cod

s_cod = Trim(this.GetText())

if this.GetColumnName() = "sdate" then 
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[시작일자]")
		this.object.sdate[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "edate" then 
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[끝일자]")
		this.object.edate[1] = ""
		return 1
	end if
end if

return
end event

type dw_list from w_standard_print`dw_list within w_qct_04660
integer x = 105
integer y = 276
integer width = 4439
string dataobject = "d_qct_04660_02"
boolean border = false
end type

type dw_1 from u_key_enter within w_qct_04660
integer x = 146
integer y = 64
integer width = 1147
integer height = 136
integer taborder = 5
boolean bringtotop = true
string dataobject = "d_qct_04660_00"
boolean border = false
end type

event itemchanged;String gubun

gubun = Trim(this.GetText())

dw_list.SetReDraw(False)
if gubun = "1" then //업체방문A/S현황
	dw_list.DataObject = "d_qct_04660_02"
	dw_print.DataObject = "d_qct_04660_02_p"
elseif gubun = "2" then	//업체방문원인별A/S추이현황
	dw_list.DataObject = "d_qct_04670_02"
	dw_print.DataObject = "d_qct_04670_02_p"
end if	

dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
dw_list.ReSet()
dw_list.SetReDraw(True)
end event

type rr_1 from roundrectangle within w_qct_04660
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 96
integer y = 44
integer width = 2391
integer height = 208
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_qct_04660
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 96
integer y = 268
integer width = 4462
integer height = 2036
integer cornerheight = 40
integer cornerwidth = 55
end type

