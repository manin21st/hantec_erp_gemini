$PBExportHeader$w_cia30330.srw
$PBExportComments$타계정 출고 명세서
forward
global type w_cia30330 from w_standard_print
end type
type rr_1 from roundrectangle within w_cia30330
end type
end forward

global type w_cia30330 from w_standard_print
string title = "타계정 출고 명세서"
boolean maxbox = true
rr_1 rr_1
end type
global w_cia30330 w_cia30330

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string s_fyymm, s_tyymm, sittyp,scost_sabu,scost_nm

if dw_ip.AcceptText() = -1 then
   dw_ip.SetFocus()
	return -1
end if	

sittyp  = trim(dw_ip.object.ittyp[1])
s_fyymm = trim(dw_ip.object.fr_yymm[1])
s_tyymm = trim(dw_ip.object.to_yymm[1])

scost_sabu = dw_ip.GetITemString(1,"cost_sabu") 

IF scost_sabu = '99' or scost_sabu = '' or isnull(scost_sabu) THEN
   scost_sabu = '%'
END IF

select rfna1		
into :scost_nm	
from reffpf 
where rfgub  = :scost_sabu and		rfcod = 'C0';

if (IsNull(sittyp) or sittyp = "")  then 
   sittyp = '%'
end if
if (IsNull(s_fyymm) or s_fyymm = "")  then 
	f_message_chk(30, "[출고기간 FROM]")
	dw_ip.SetColumn("fr_yymm")
	dw_ip.Setfocus()
	return -1
end if
if (IsNull(s_Tyymm) or s_Tyymm = "")  then 
	f_message_chk(30, "[출고기간 TO]")
	dw_ip.SetColumn("to_yymm")
	dw_ip.Setfocus()
	return -1
end if

if dw_print.Retrieve(scost_sabu,scost_nm,s_fyymm, s_tyymm, sittyp) <= 0 then
   f_message_chk(50,'[타계정 명세서]')
	dw_ip.Setfocus()
	return -1
end if
dw_print.sharedata(dw_list)

return 1
end function

on w_cia30330.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_cia30330.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.setitem(1, "fr_yymm", left(f_today(), 6))
dw_ip.setitem(1, "to_yymm", left(f_today(), 6))

dw_ip.SetColumn("fr_yymm")
dw_ip.SetFocus()
end event

type p_preview from w_standard_print`p_preview within w_cia30330
integer x = 4069
integer y = 8
end type

type p_exit from w_standard_print`p_exit within w_cia30330
integer x = 4425
integer y = 8
end type

type p_print from w_standard_print`p_print within w_cia30330
integer x = 4247
integer y = 8
end type

type p_retrieve from w_standard_print`p_retrieve within w_cia30330
integer x = 3890
integer y = 8
end type







type st_10 from w_standard_print`st_10 within w_cia30330
end type



type dw_print from w_standard_print`dw_print within w_cia30330
integer x = 4046
integer y = 172
string dataobject = "dw_cia30330_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_cia30330
integer x = 37
integer y = 0
integer width = 3639
integer height = 156
string dataobject = "dw_cia30330"
end type

event dw_ip::itemchanged;call super::itemchanged;IF dwo.name = "sgbn" THEN
	CHOOSE CASE data
		CASE '1'
			dw_list.DataObject ="dw_cia30330_1"
			dw_list.SetTransObject(SQLCA)
			
			dw_print.DataObject ="dw_cia30330_1_p"
			dw_print.SetTransObject(SQLCA)

		CASE '2'
			dw_list.DataObject ="dw_cia30330_2"
			dw_list.SetTransObject(SQLCA)
			
			dw_print.DataObject ="dw_cia30330_2_p"
			dw_print.SetTransObject(SQLCA)	
	END CHOOSE
	w_mdi_frame.sle_msg.text =""
END IF
end event

type dw_list from w_standard_print`dw_list within w_cia30330
integer x = 50
integer y = 172
integer width = 4539
integer height = 2056
string dataobject = "dw_cia30330_2"
boolean border = false
end type

type rr_1 from roundrectangle within w_cia30330
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 164
integer width = 4562
integer height = 2072
integer cornerheight = 40
integer cornerwidth = 55
end type

