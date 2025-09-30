$PBExportHeader$w_pdt_02461.srw
$PBExportComments$출하검사대기현황
forward
global type w_pdt_02461 from w_standard_print
end type
type pb_1 from u_pb_cal within w_pdt_02461
end type
type pb_2 from u_pb_cal within w_pdt_02461
end type
type rr_1 from roundrectangle within w_pdt_02461
end type
end forward

global type w_pdt_02461 from w_standard_print
string title = "출하검사 대기현황"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_pdt_02461 w_pdt_02461

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string sdate, edate, pdtgu1, pdtgu2, gbn, pgbn, sfilter
String ls_saupj

dw_ip.AcceptText()
sdate 		= Trim(dw_ip.object.sdate[1])
edate 		= Trim(dw_ip.object.edate[1])
pdtgu1 	= Trim(dw_ip.object.pdtgu1[1])
pdtgu2 	= Trim(dw_ip.object.pdtgu2[1])
gbn    		= Trim(dw_ip.object.gubun[1])
pgbn    	= Trim(dw_ip.object.pgbn[1])

ls_saupj	= dw_ip.GetItemString(1,"saupj")

if 	IsNull(sdate) or sdate = "" then sdate = "10000101"
if 	IsNull(edate) or edate = "" then edate = "99991231"
if 	IsNull(pdtgu1) or pdtgu1 = "" then pdtgu1 = "."
if 	IsNull(pdtgu2) or pdtgu2 = "" then pdtgu2 = "ZZZZZZ"

if 	gbn = '1' then
	dw_list.dataobject 	= "d_pdt_02461_2"	
	dw_print.dataobject = "d_pdt_02461_2_p"	
Elseif gbn = '2' then
	dw_list.dataobject 	= "d_pdt_02461_3"		
	dw_print.dataobject = "d_pdt_02461_3_p"		
End if
dw_list.settransobject(sqlca)
dw_print.settransobject(sqlca)

IF 	dw_print.Retrieve(gs_sabu, ls_saupj, sdate, edate, pdtgu1, pdtgu2, pgbn) <= 0 THEN
	f_message_chk(50,'[공정 검사 의뢰 현황]')
	dw_list.Reset()
	dw_ip.SetFocus()
   dw_list.SetRedraw(true)
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)

integer ii

sfilter = ''
if pgbn = 'N' then
	sfilter = "shpact_coqty > yebid1"
elseif pgbn = 'Y' then
	sfilter = "shpact_coqty = yebid1" 
end if
ii = dw_print.setfilter(sfilter)
ii = dw_print.filter()

//ii = dw_list.setfilter(sfilter)
//ii = dw_list.filter()
//
//IF dw_list.retrieve(gs_sabu, sdate, edate, pdtgu1, pdtgu2, pgbn) <= 0 THEN
//	f_message_chk(50,'[공정 검사 의뢰 현황]')
//	dw_ip.setfocus()
//	Return -1
//END IF

return 1
end function

on w_pdt_02461.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.rr_1
end on

on w_pdt_02461.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.setitem(1, "sdate", f_afterday(f_today(), -10))
dw_ip.setitem(1, "edate", f_today())

f_mod_saupj(dw_ip, 'saupj')

f_child_saupj(dw_ip, 'pdtgu1', gs_saupj)
f_child_saupj(dw_ip, 'pdtgu2', gs_saupj)


end event

type p_preview from w_standard_print`p_preview within w_pdt_02461
integer x = 4078
end type

type p_exit from w_standard_print`p_exit within w_pdt_02461
integer x = 4425
end type

type p_print from w_standard_print`p_print within w_pdt_02461
integer x = 4251
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_02461
integer x = 3904
end type







type st_10 from w_standard_print`st_10 within w_pdt_02461
end type



type dw_print from w_standard_print`dw_print within w_pdt_02461
integer x = 3712
string dataobject = "d_pdt_02461_2_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_02461
integer x = 27
integer y = 36
integer width = 2912
integer height = 288
string dataobject = "d_pdt_02461_1"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;call super::itemchanged;String s_cod

if this.getcolumnname() = 'saupj' then 
	s_cod = this.gettext()
	f_child_saupj(this, 'pdtgu1', s_cod)
	f_child_saupj(this, 'pdtgu2', s_cod)
end if

end event

type dw_list from w_standard_print`dw_list within w_pdt_02461
integer x = 50
integer y = 344
integer width = 4544
integer height = 1972
string dataobject = "d_pdt_02461_2"
boolean border = false
end type

type pb_1 from u_pb_cal within w_pdt_02461
integer x = 686
integer y = 140
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.Setcolumn('sdate')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_ip.SetItem(1, 'sdate', gs_code)
end event

type pb_2 from u_pb_cal within w_pdt_02461
integer x = 1138
integer y = 140
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.Setcolumn('edate')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_ip.SetItem(1, 'edate', gs_code)
end event

type rr_1 from roundrectangle within w_pdt_02461
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 332
integer width = 4567
integer height = 1996
integer cornerheight = 40
integer cornerwidth = 55
end type

