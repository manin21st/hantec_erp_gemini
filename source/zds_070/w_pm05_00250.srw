$PBExportHeader$w_pm05_00250.srw
$PBExportComments$월간 생산계획 대 실적
forward
global type w_pm05_00250 from w_standard_print
end type
type rr_2 from roundrectangle within w_pm05_00250
end type
type rr_1 from roundrectangle within w_pm05_00250
end type
end forward

global type w_pm05_00250 from w_standard_print
string title = "월간 생산계획 대 실적"
rr_2 rr_2
rr_1 rr_1
end type
global w_pm05_00250 w_pm05_00250

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String syymm, sjyymm, sgb

If dw_ip.AcceptText() <> 1 Then Return -1

sYymm = Trim(dw_ip.GetItemString(1, 'yymm'))

if	f_datechk(syymm) = -1 then
	f_message_chk(35,'[기준일자]')
	dw_ip.SetColumn("jidat")
	dw_ip.SetFocus()
	return -1
end if 

If dw_print.Retrieve(gs_sabu, syymm) < 1 THEN
	f_message_chk(50,'')
	dw_ip.Setfocus()
	return -1
end if

String tx_name

tx_name = Left(syymm,4) + '.' + Mid(syymm,5,2) + '.' + Right(syymm,2)
dw_print.Modify("t_ymd.text = '"+tx_name+"'")

return 1
end function

on w_pm05_00250.create
int iCurrent
call super::create
this.rr_2=create rr_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
this.Control[iCurrent+2]=this.rr_1
end on

on w_pm05_00250.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_2)
destroy(this.rr_1)
end on

event open;call super::open;String sDate, stoday

stoday = f_today()

select min(week_sdate) INTO :sDate from pdtweek where week_sdate <= :stoday and week_ldate >= :stoday;

dw_ip.SetItem(1, 'yymm', stoday)
end event

type p_preview from w_standard_print`p_preview within w_pm05_00250
end type

type p_exit from w_standard_print`p_exit within w_pm05_00250
end type

type p_print from w_standard_print`p_print within w_pm05_00250
end type

type p_retrieve from w_standard_print`p_retrieve within w_pm05_00250
end type







type st_10 from w_standard_print`st_10 within w_pm05_00250
end type



type dw_print from w_standard_print`dw_print within w_pm05_00250
string dataobject = "d_pm05_00250_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pm05_00250
integer x = 128
integer y = 92
integer width = 2235
integer height = 96
string dataobject = "d_pm05_00250"
end type

event dw_ip::itemchanged;String sDate, sData, sNull,sName

SetNull(sNull)


end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

event dw_ip::rbuttondown;call super::rbuttondown;String sData
long lrow

SetNull(gs_code)
SetNull(gs_codename)

//Choose Case GetColumnName()
//	 Case 'jocod'
//			Open(w_jomas_popup)
//			SetItem(1,'jocod',gs_code)
//			SetItem(1,'jonam',gs_codename)
//End Choose
end event

type dw_list from w_standard_print`dw_list within w_pm05_00250
integer x = 73
integer y = 264
integer width = 4439
integer height = 2004
string dataobject = "d_pm05_00250_1"
boolean border = false
end type

event dw_list::rowfocuschanged;call super::rowfocuschanged;if currentrow > 0 then
	selectrow(0, false)
	selectrow(currentrow, true)
else
	selectrow(0, false)
end if

end event

type rr_2 from roundrectangle within w_pm05_00250
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 59
integer y = 52
integer width = 2405
integer height = 172
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within w_pm05_00250
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 252
integer width = 4471
integer height = 2016
integer cornerheight = 40
integer cornerwidth = 55
end type

