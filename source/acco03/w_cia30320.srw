$PBExportHeader$w_cia30320.srw
$PBExportComments$작지번호별 원가명세서
forward
global type w_cia30320 from w_standard_print
end type
type rr_1 from roundrectangle within w_cia30320
end type
end forward

global type w_cia30320 from w_standard_print
string title = "작업지시번호별 원가명세서"
boolean maxbox = true
rr_1 rr_1
end type
global w_cia30320 w_cia30320

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String ls_accdatef, ls_accdatet, ls_saupj, ls_jisinum, snull,scost_sabu,scost_nm

SetNull(snull)

If dw_ip.AcceptText() < 1 then Return -1

ls_accdatef	= Trim(dw_ip.GetItemString(1,'accdatef'))
ls_accdatet = Trim(dw_ip.GetItemString(1,'accdatet'))
ls_saupj    = dw_ip.GetItemString(1,'cost_saup')
ls_jisinum  = dw_ip.GetItemString(1,'jisi_num')
//---------------------------------------------------
scost_sabu = dw_ip.GetITemString(1,"cost_sabu") 

IF scost_sabu = '99' or scost_sabu = '' or isnull(scost_sabu) THEN
   scost_sabu = '%'
END IF

select rfna1		
into :scost_nm	
from reffpf 
where rfgub  = :scost_sabu and
		rfcod = 'C0';
//----------------------------------------------------
If ls_accdatef = '' or IsNull(ls_accdatef) then
	f_messagechk(1,"[원가계산년월]")
   dw_ip.SetColumn('accdatef')
	dw_ip.SetFocus()
	Return -1	
ELSEIF f_datechk(ls_accdatef + '01') = -1 THEN
		 f_messagechk(21,"[원가계산년월]")
	    dw_ip.SetColumn('accdatef')
	    dw_ip.SetFocus()
	    Return -1	 
END IF

If ls_accdatet = '' or IsNull(ls_accdatet) then
	f_messagechk(1,"[원가계산년월]")
	dw_ip.SetColumn('accdatet')
	dw_ip.SetFocus()
	Return -1
ElseIf f_datechk(ls_accdatet + '01') = -1 then
	    f_messagechk(21,"[원가계산년월]")
		 dw_ip.SetColumn('accdatet')
		 dw_ip.SetFocus()
		 Return -1
End If
	
If ls_saupj = '' or IsNull(ls_saupj) then
	ls_saupj = '%'
End If

If ls_jisinum = '' or IsNull(ls_jisinum) then
	ls_jisinum = '%'
End If

If dw_print.retrieve(scost_sabu,scost_nm,ls_accdatef, ls_accdatet, ls_saupj, ls_jisinum) < 1 then
	f_messagechk(14,'')
	dw_ip.SetColumn('accdatef')
	dw_ip.SetFocus()
   Return -1
End If
  dw_print.sharedata(dw_list)
Return 1

end function

on w_cia30320.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_cia30320.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetTransObject(SQLCA)
dw_ip.Reset()

dw_list.settransobject(sqlca)

dw_ip.InsertRow(0)
dw_ip.SetItem(1,"accdatef",Left(f_today(),4) + '01')
dw_ip.SetItem(1,"accdatet",left(f_today(),6))

dw_ip.Setcolumn("accdatef")
dw_ip.SetFocus()
end event

type p_preview from w_standard_print`p_preview within w_cia30320
integer y = 8
end type

type p_exit from w_standard_print`p_exit within w_cia30320
integer y = 8
end type

type p_print from w_standard_print`p_print within w_cia30320
integer y = 8
end type

type p_retrieve from w_standard_print`p_retrieve within w_cia30320
integer y = 8
end type







type st_10 from w_standard_print`st_10 within w_cia30320
end type



type dw_print from w_standard_print`dw_print within w_cia30320
integer x = 3968
integer y = 160
string dataobject = "dw_cia30320_p"
end type

type dw_ip from w_standard_print`dw_ip within w_cia30320
integer x = 32
integer y = 32
integer width = 3822
integer height = 128
string dataobject = "dw_cia30320_1"
end type

event dw_ip::itemchanged;String fdate, tdate, snull

SetNull(snull)

dw_ip.AcceptText()

If dw_ip.GetColumnName() = 'accdatef' then
	fdate = dw_ip.GetText()
	If f_datechk(fdate + '01') = -1 then
		f_messagechk(21,"[원가계산년월]")
		dw_ip.SetColumn('accdatef')
		dw_ip.SetFocus()
		return 1
	End If
End If 

If dw_ip.GetColumnName() = 'accdatet' then
	tdate = dw_ip.GetText()
	If f_datechk(tdate + '01') = -1 then
		f_messagechk(21, "[원가계산년월]")
		dw_ip.SetColumn('accdatet')
		dw_ip.SetFocus()
		return 1
	End If
End If
end event

event dw_ip::itemerror;return 1

end event

event dw_ip::rbuttondown;String ls_jisinum

SetNull(gs_code)

This.AcceptText()

If this.GetColumnName() = 'jisi_num' then
	ls_jisinum = this.GetItemString(this.Getrow(), "jisi_num")
	gs_code = ls_jisinum
	
	Open(w_jisi_popup)
	
	If IsNull(gs_code) then Return
	
	this.SetItem(this.Getrow(), 'jisi_num', gs_code)
	
End If

end event

event dw_ip::ue_key;call super::ue_key;IF keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

type dw_list from w_standard_print`dw_list within w_cia30320
integer x = 46
integer y = 176
integer width = 4558
integer height = 2032
string dataobject = "dw_cia30320"
boolean border = false
end type

type rr_1 from roundrectangle within w_cia30320
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 172
integer width = 4581
integer height = 2044
integer cornerheight = 40
integer cornerwidth = 55
end type

