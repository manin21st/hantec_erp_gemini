$PBExportHeader$w_pdt_t_10130.srw
$PBExportComments$설비별 생산실적
forward
global type w_pdt_t_10130 from w_standard_print
end type
type rr_1 from roundrectangle within w_pdt_t_10130
end type
end forward

global type w_pdt_t_10130 from w_standard_print
string title = "설비별 생산실적"
rr_1 rr_1
end type
global w_pdt_t_10130 w_pdt_t_10130

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string sdate, edate, sSaupj

if 	dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

sdate 		= trim(dw_ip.object.sdate[1])
edate 		= trim(dw_ip.object.edate[1])
sSaupj	= dw_ip.getItemString(1,'saupj')

if 	(IsNull(sdate) or sdate = "")  then sdate = "11110101"

IF dw_print.Retrieve(gs_sabu, sSaupj, sdate, edate) <= 0 then
	f_message_chk(50,"[설비별 생산실적]")
	dw_ip.Setfocus()
	dw_list.Reset()
	dw_print.insertrow(0)
END IF

dw_print.object.t_sdate.text = String(sdate, "@@@@.@@.@@")
dw_print.object.t_edate.text = String(edate, "@@@@.@@.@@")
dw_print.ShareData(dw_list)

return 1
end function

on w_pdt_t_10130.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pdt_t_10130.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;
dw_ip.setitem(1, 'sdate', left(is_today,6) + '01')
dw_ip.setitem(1, 'edate', is_today)
dw_ip.setfocus()
dw_ip.SetColumn("sdate")


/* User별 사업장 Setting */
setnull(gs_code)
//If 	f_check_saupj() = 1 Then
//	dw_ip.SetItem(1, 'saupj', gs_code)
//	if 	gs_code <> '%' then
//		dw_ip.setItem(1, 'saupj', gs_code)
//        	dw_ip.Modify("saupj.protect=1")
//		dw_ip.Modify("saupj.background.color = 80859087")
//	End if
//End If

f_mod_saupj(dw_ip, 'saupj')
end event

type p_preview from w_standard_print`p_preview within w_pdt_t_10130
end type

type p_exit from w_standard_print`p_exit within w_pdt_t_10130
end type

type p_print from w_standard_print`p_print within w_pdt_t_10130
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_t_10130
end type







type st_10 from w_standard_print`st_10 within w_pdt_t_10130
end type



type dw_print from w_standard_print`dw_print within w_pdt_t_10130
string dataobject = "d_pdt_t_10130_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_t_10130
integer x = 46
integer y = 32
integer width = 1175
integer height = 248
string dataobject = "d_pdt_t_10130_h"
end type

event dw_ip::itemchanged;String sSdate, sEdate, snull

SetNull(snull)

sSdate = Trim(this.GetItemString(1,'sdate'))
sEdate = Trim(this.GetItemString(1,'edate'))


if   	this.GetColumnName() = "sdate" then
	sSdate = Trim(this.GetText())
	if 	f_datechk(sSdate) = -1 then
		f_message_chk(35, "[시작일자]")
		this.SetItem(1,"sdate",snull)
		return 1
	end if
elseif this.GetColumnName() = "edate" then
	sEdate = Trim(this.GetText())
	if 	f_datechk(sEdate) = -1 then
		f_message_chk(35, "[끝일자]")
		this.SetItem(1,"edate",snull)
		return 1
	end if
end if

if 	sSdate > sEdate 	then
	f_message_chk(35, "[시작일자]")
	return 1
End If	
end event

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_pdt_t_10130
integer x = 46
integer y = 316
integer width = 4567
integer height = 2008
string dataobject = "d_pdt_t_10130_d"
boolean border = false
end type

type rr_1 from roundrectangle within w_pdt_t_10130
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 308
integer width = 4599
integer height = 2028
integer cornerheight = 40
integer cornerwidth = 55
end type

