$PBExportHeader$w_pdt_02870.srw
$PBExportComments$** 수주 취소 현황
forward
global type w_pdt_02870 from w_standard_print
end type
type rr_2 from roundrectangle within w_pdt_02870
end type
end forward

global type w_pdt_02870 from w_standard_print
string title = "수주 취소 현황"
rr_2 rr_2
end type
global w_pdt_02870 w_pdt_02870

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String s_frdate, s_todate

dw_ip.AcceptText()

s_frdate = trim(dw_ip.GetItemString(1, "sdate"))
s_todate = trim(dw_ip.GetItemString(1, "edate"))

IF s_frdate = "" OR IsNull(s_frdate) THEN 
	s_frdate = '10000101'
END IF
IF s_todate = "" OR IsNull(s_todate) THEN 
	s_todate = '99991231'
END IF

if s_frdate > s_todate then 
	f_message_chk(34,'[취소기간]')
	dw_ip.Setcolumn('sdate')
	dw_ip.SetFocus()
	return -1
end if	

IF dw_print.Retrieve(gs_sabu, s_frdate,s_todate) < 1 THEN
	f_message_chk(50,'')
	dw_ip.Setcolumn('sdate')
	dw_ip.Setfocus()
	return -1
end if
   
	dw_print.sharedata(dw_list)
return 1

end function

on w_pdt_02870.create
int iCurrent
call super::create
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
end on

on w_pdt_02870.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_2)
end on

event open;call super::open;dw_ip.SetItem(1, "sdate", left(f_today(), 6) + '01')
dw_ip.SetItem(1, "edate", f_today())
dw_ip.SetColumn("sdate")
dw_ip.Setfocus()


end event

type p_preview from w_standard_print`p_preview within w_pdt_02870
end type

type p_exit from w_standard_print`p_exit within w_pdt_02870
end type

type p_print from w_standard_print`p_print within w_pdt_02870
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_02870
end type







type st_10 from w_standard_print`st_10 within w_pdt_02870
end type



type dw_print from w_standard_print`dw_print within w_pdt_02870
string dataobject = "d_pdt_02870_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_02870
integer x = 37
integer y = 24
integer width = 1019
integer height = 160
string dataobject = "d_pdt_02870_a"
end type

event dw_ip::itemchanged;string  snull, sdate

setnull(snull)

IF this.GetColumnName() = "sdate"	THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF f_datechk(sdate) = -1	then
      f_message_chk(35, '[취소기간 FROM]')
		this.setitem(1, "sdate", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() = "edate"	THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF f_datechk(sdate) = -1	then
      f_message_chk(35, '[취소기간 TO]')
		this.setitem(1, "edate", sNull)
		return 1
	END IF
END IF
end event

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_pdt_02870
integer y = 220
integer width = 4567
integer height = 2060
string dataobject = "d_pdt_02870_1"
boolean border = false
end type

type rr_2 from roundrectangle within w_pdt_02870
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 208
integer width = 4603
integer height = 2084
integer cornerheight = 40
integer cornerwidth = 55
end type

