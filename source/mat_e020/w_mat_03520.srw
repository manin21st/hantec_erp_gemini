$PBExportHeader$w_mat_03520.srw
$PBExportComments$** 주기실사 현황
forward
global type w_mat_03520 from w_standard_print
end type
type pb_1 from u_pb_cal within w_mat_03520
end type
type rr_1 from roundrectangle within w_mat_03520
end type
end forward

global type w_mat_03520 from w_standard_print
string title = "주기실사 현황"
event ue_postopen ( )
pb_1 pb_1
rr_1 rr_1
end type
global w_mat_03520 w_mat_03520

forward prototypes
public function integer wf_retrieve ()
end prototypes

event ue_postopen();string	get_date
  
SELECT max("ITMCYC"."SICDAT")
 INTO :get_date
 FROM "ITMCYC"  
WHERE "ITMCYC"."SABU" = :gs_sabu  ;

if get_date = "" or isnull(get_date) then
   dw_ip.SetItem(1, "sdate", is_today)
else
	dw_ip.SetItem(1, "sdate", get_date)
end if	
dw_ip.SetColumn("sdate")
dw_ip.Setfocus()
end event

public function integer wf_retrieve ();String  s_frdepot,s_todepot, s_date, s_gub, s_ittyp, s_itnbr1, s_itnbr2, ls_porgu

IF dw_ip.AcceptText() = -1 THEN RETURN -1

s_date = TRIM(dw_ip.GetItemString(1,"sdate"))
s_frdepot = trim(dw_ip.GetItemString(1,"fr_depot"))
s_todepot = trim(dw_ip.GetItemString(1,"to_depot"))
s_ittyp   = trim(dw_ip.GetItemString(1,"ittyp"))
s_itnbr1  = trim(dw_ip.GetItemString(1,"itnbr1"))
s_itnbr2  = trim(dw_ip.GetItemString(1,"itnbr2"))
s_gub     = dw_ip.GetItemString(1,"sgub")

ls_porgu = dw_ip.GetItemString(1,"porgu")

IF s_date = "" OR IsNull(s_date) THEN
	f_message_chk(30,'[자료생성일]')
	dw_ip.SetColumn("sdate")
	dw_ip.SetFocus()
	Return -1
END IF

IF s_frdepot = "" OR IsNull(s_frdepot) THEN s_frdepot = '.'
IF s_todepot = "" OR IsNull(s_todepot) THEN s_todepot = 'zzzzzz'
if s_frdepot > s_todepot then 
	f_message_chk(34,'[창고]')
	dw_ip.Setcolumn('fr_depot')
	dw_ip.SetFocus()
	return -1
end if
IF s_ittyp = "" OR IsNull(s_ittyp) THEN s_ittyp = '%'
IF s_itnbr1 = "" OR IsNull(s_itnbr1) THEN s_itnbr1 = '.'
IF s_itnbr2 = "" OR IsNull(s_itnbr2) THEN s_itnbr2 = 'zzzzzzzzzzzzzzz'

dw_list.setredraw(false)
if s_gub = "1" then
	dw_list.SetFilter("")
	dw_list.Filter( )
elseif s_gub = "2" then
	dw_list.SetFilter(" gapqty <> 0 ")
	dw_list.Filter( )
elseif s_gub = "3" then
	dw_list.SetFilter(" itmcyc_cujqty >= 0 ")
	dw_list.Filter( )
elseif s_gub = "4" then
	dw_list.SetFilter(" itmcyc_cujqty < 0 ")
	dw_list.Filter( )
end if	

//IF dw_list.Retrieve(gs_sabu, s_date, s_frdepot, s_todepot, s_ittyp, s_itnbr1, s_itnbr2) < 1 THEN
//	f_message_chk(50,'')
//	dw_ip.Setfocus()
//	dw_list.setredraw(true)
//	return -1
//end if

IF dw_print.Retrieve(gs_sabu, s_date, s_frdepot, s_todepot, s_ittyp, s_itnbr1, s_itnbr2) < 1 THEN
	dw_list.Reset()
	Return -1
END IF

dw_print.ShareData(dw_list)

dw_list.setredraw(true)
return 1



end function

on w_mat_03520.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.rr_1
end on

on w_mat_03520.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.rr_1)
end on

event open;call super::open;PostEvent("ue_postopen")
end event

event ue_open;call super::ue_open;//사업장
f_mod_saupj(dw_ip, 'porgu' )

//입고창고 
f_child_saupj(dw_ip, 'fr_depot', gs_saupj)
f_child_saupj(dw_ip, 'to_depot', gs_saupj)
end event

type p_preview from w_standard_print`p_preview within w_mat_03520
end type

type p_exit from w_standard_print`p_exit within w_mat_03520
end type

type p_print from w_standard_print`p_print within w_mat_03520
end type

type p_retrieve from w_standard_print`p_retrieve within w_mat_03520
end type











type dw_print from w_standard_print`dw_print within w_mat_03520
string dataobject = "d_mat_03520_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_mat_03520
integer y = 24
integer width = 3735
integer height = 284
string dataobject = "d_mat_03520_a"
end type

event dw_ip::itemerror;
Return 1
end event

event dw_ip::itemchanged;string snull, sdate

setnull(snull)

IF this.GetColumnName() ="sdate" THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF f_datechk(sdate) = -1	then
      f_message_chk(35, '[자료생성일]')
		this.setitem(1, "sdate", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() ="sgub" THEN
	sdate = trim(this.GetText())
	if sdate = "1" then
		dw_list.SetFilter("")
		dw_list.Filter( )
	elseif sdate = "2" then
		dw_list.SetFilter(" gapqty <> 0 ")
		dw_list.Filter( )
	elseif sdate = "3" then
		dw_list.SetFilter(" itmcyc_cujqty >= 0 ")
		dw_list.Filter( )
	elseif sdate = "4" then
		dw_list.SetFilter(" itmcyc_cujqty < 0 ")
		dw_list.Filter( )
	end if	
END IF

end event

event dw_ip::rbuttondown;call super::rbuttondown;string snull

setnull(snull)
setnull(gs_gubun)
setnull(gs_code)
setnull(gs_codename)

IF this.GetColumnName() ="itnbr1" THEN
	gs_gubun = trim(this.GetItemString(1,'ittyp'))
	
	open(w_itemas_popup)
	if gs_code = "" or isnull(gs_code) then	return 

	this.setitem(1, "itnbr1", gs_code)
ELSEIF this.GetColumnName() ="itnbr2" THEN
	gs_gubun = trim(this.GetItemString(1,'ittyp'))
	
	open(w_itemas_popup)
	if gs_code = "" or isnull(gs_code) then	return 

	this.setitem(1, "itnbr2", gs_code)
END IF

end event

type dw_list from w_standard_print`dw_list within w_mat_03520
integer x = 59
integer y = 328
integer width = 4517
integer height = 1984
string dataobject = "d_mat_03520_1"
boolean border = false
end type

type pb_1 from u_pb_cal within w_mat_03520
integer x = 1879
integer y = 32
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

type rr_1 from roundrectangle within w_mat_03520
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 320
integer width = 4558
integer height = 2000
integer cornerheight = 40
integer cornerwidth = 55
end type

