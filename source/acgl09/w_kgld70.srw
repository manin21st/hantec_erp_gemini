$PBExportHeader$w_kgld70.srw
$PBExportComments$정기 결재 현황
forward
global type w_kgld70 from w_standard_print
end type
type rr_1 from roundrectangle within w_kgld70
end type
end forward

global type w_kgld70 from w_standard_print
integer x = 0
integer y = 0
string title = "정기 결재 현황"
rr_1 rr_1
end type
global w_kgld70 w_kgld70

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sDate		
		
dw_ip.AcceptText()
sDate = Trim(dw_ip.GetItemString(1,"sdate"))
IF sDate = "" OR IsNull(sDate) THEN
	F_MessageChk(1,'[결제일자]')
	dw_ip.SetColumn("sdate")
	dw_ip.SetFocus()
	Return -1
ELSE
	IF f_datechk(sdate) = -1 THEN
		f_messagechk( 23, "")
		dw_ip.SetColumn("sdate")
		dw_ip.SetFocus()
		Return -1
	END IF
END IF

setpointer(hourglass!)

dw_list.SetRedraw(false)
if dw_print.retrieve(sDate) <= 0 then
	F_Messagechk(14,'')
   dw_list.SetRedraw(true)	
	return -1	  
END IF
dw_print.sharedata(dw_list)
dw_list.SetRedraw(true)	
setpointer(arrow!)

return 1
end function

on w_kgld70.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kgld70.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;
dw_ip.SetItem(1,"sdate", f_today())
dw_ip.SetItem(1,"saupj",  gs_saupj)
dw_ip.SetFocus()


IF F_Authority_Chk(Gs_Dept) = -1 THEN							/*권한 체크- 현업 여부*/
	dw_ip.SetItem(dw_ip.GetRow(),"saupj",   Gs_Saupj)
	
	dw_ip.Modify("saupj.protect = 1")
ELSE
	dw_ip.Modify("saupj.protect = 0")
END IF	
end event

type p_preview from w_standard_print`p_preview within w_kgld70
integer x = 4087
integer y = 0
end type

type p_exit from w_standard_print`p_exit within w_kgld70
integer x = 4434
integer y = 0
end type

type p_print from w_standard_print`p_print within w_kgld70
integer x = 4261
integer y = 0
end type

type p_retrieve from w_standard_print`p_retrieve within w_kgld70
integer x = 3913
integer y = 0
end type

type st_window from w_standard_print`st_window within w_kgld70
integer x = 2409
integer width = 457
end type

type sle_msg from w_standard_print`sle_msg within w_kgld70
integer width = 2016
end type

type dw_datetime from w_standard_print`dw_datetime within w_kgld70
integer x = 2866
end type

type st_10 from w_standard_print`st_10 within w_kgld70
end type

type gb_10 from w_standard_print`gb_10 within w_kgld70
integer width = 3607
end type

type dw_print from w_standard_print`dw_print within w_kgld70
string dataobject = "dw_kgld702_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kgld70
integer x = 69
integer y = 24
integer width = 786
integer height = 132
string dataobject = "dw_kgld701"
end type

type dw_list from w_standard_print`dw_list within w_kgld70
integer x = 73
integer y = 172
integer width = 4517
integer height = 2000
string dataobject = "dw_kgld702"
boolean border = false
end type

type rr_1 from roundrectangle within w_kgld70
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 69
integer y = 160
integer width = 4535
integer height = 2040
integer cornerheight = 40
integer cornerwidth = 55
end type

