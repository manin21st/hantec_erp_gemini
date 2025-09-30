$PBExportHeader$w_kfc01.srw
$PBExportComments$발행전표이력조회출력
forward
global type w_kfc01 from w_standard_print
end type
type rr_3 from roundrectangle within w_kfc01
end type
end forward

global type w_kfc01 from w_standard_print
integer x = 0
integer y = 0
string title = "발행전표이력"
rr_3 rr_3
end type
global w_kfc01 w_kfc01

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ssaupj, sbaldatef, sbaldatet,  sdeptcd, ssawon, suserid, snull
integer ijunnof, ijunnot
String sidatef, sidatet

setnull(snull)

IF dw_ip.AcceptText() = -1 THEN Return -1

ssaupj    = dw_ip.getitemstring(1, "saupj")
sbaldatef = dw_ip.getitemstring(1, "baldatef")
sbaldatet = dw_ip.getitemstring(1, "baldatet")
ijunnof   = dw_ip.getitemnumber(1, "bjunnof")
ijunnot   = dw_ip.getitemnumber(1, "bjunnot")
sdeptcd   = dw_ip.getitemstring(1, "deptcd")
ssawon    = dw_ip.getitemstring(1, "sawon")
suserid   = dw_ip.GetItemString(1, "iuserid")
sidatef   = dw_ip.GetItemstring(1, "idatef")
sidatet   = dw_ip.GetItemstring(1, "idatet")

IF ssaupj = "" OR IsNull(ssaupj) THEN ssaupj = '%'

IF sbaldatef = "" OR IsNull(sbaldatef) THEN
	F_MessageChk(1,'[발행일자]')
	dw_ip.SetColumn("baldatef")
	dw_ip.SetFocus()
	Return -1
END IF

IF sbaldatet = "" OR IsNull(sbaldatet) THEN
	F_MessageChk(1,'[발행일자]')
	dw_ip.SetColumn("baldatet")
	dw_ip.SetFocus()
	Return -1
END IF

IF ijunnof = 0 OR  isnull(ijunnof) THEN
	f_messagechk(1, '[발행번호]')
	dw_ip.setcolumn("bjunnof")
	dw_ip.setfocus()
	Return -1
END IF

IF ijunnot = 0 OR isnull(ijunnot) THEN
	f_messagechk(1, '[발행번호]')
	dw_ip.setcolumn("bjunnot")
	dw_ip.setfocus()
	Return -1
END IF

IF sdeptcd = "" OR isnull(sdeptcd) THEN sdeptcd = '%'
	
IF ssawon = "" OR isnull(ssawon) THEN ssawon = '%'

IF suserid = "" OR IsNull(suserid) THEN suserid = '%'

IF sidatef = "" OR isnull(sidatef) THEN 
	f_messagechk(1, '[입력일자]')
	dw_ip.setcolumn("idatef")
	dw_ip.setfocus()
	Return -1
END IF

IF sidatet = "" OR isnull(sidatet) THEN 	
	f_messagechk(1, '[입력일자]')
	dw_ip.setcolumn("idatet")
	dw_ip.setfocus()
	Return -1
END IF

IF dw_print.retrieve(ssaupj, sbaldatef, sbaldatet, ijunnof, ijunnot, &
                    sdeptcd, ssawon, suserid, sidatef, sidatet) <= 0 THEN
	F_MessageChk(14,'')
	Return -1
END IF

dw_print.sharedata(dw_list)

dw_ip.SetFocus()

Return 1
end function

on w_kfc01.create
int iCurrent
call super::create
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_3
end on

on w_kfc01.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_3)
end on

event open;call super::open;string sdate, edate

sdate = left(f_today(), 6) + '01'
edate = f_today()

dw_ip.setitem(1, "baldatef", sdate)
dw_ip.setitem(1, "baldatet", edate)
dw_ip.setitem(1, "idatef", sdate)
dw_ip.setitem(1, "idatet", edate)

dw_ip.setfocus()
end event

type p_preview from w_standard_print`p_preview within w_kfc01
end type

type p_exit from w_standard_print`p_exit within w_kfc01
end type

type p_print from w_standard_print`p_print within w_kfc01
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfc01
end type







type st_10 from w_standard_print`st_10 within w_kfc01
end type



type dw_print from w_standard_print`dw_print within w_kfc01
integer y = 32
string dataobject = "d_kfc01_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kfc01
integer x = 46
integer width = 3360
integer height = 292
string dataobject = "d_kfc01_01"
end type

event dw_ip::getfocus;this.accepttext()
end event

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;string ssaupj, sbaldate, sdeptcd, ssawon, suserid,  snull
integer ijunno
string sidate

setnull(snull)

//if this.getcolumnname() = "baldatef" then
//	sbaldate = this.gettext()
//	if trim(sbaldate) = "" or isnull(sbaldate) then return
//	
//	if f_datechk(sbaldate) = -1 then
//		f_messagechk(21, '[발행일자]')
//		this.setitem(this.getrow(), "baldatef", snull)
//		return 1
//	end if
//end if
//
//if this.getcolumnname() = "baldatet" then
//	sbaldate = this.gettext()
//	if trim(sbaldate) = "" or isnull(sbaldate) then return
//	
//	if f_datechk(sbaldate) = -1 then
//		f_messagechk(21, '[발행일자]')
//		this.setitem(this.getrow(), "baldatet", snull)
//		return 1
//	end if
//end if
//
////if this.getcolumnname() = "bjunnof" then
////	ijunno = this.gettext()
////	if isnull(ijunno) then 
////		MessageBox("확인", "발행번호를 입력하십시오")
////		this.setitem(1, "bjunnof", snull)
////		return 
////	end if
////end if
////
////if this.getcolumnname() = "bjunnot" then
////	ijunno = this.getitemnumber(row, "bjunnot")
////	if isnull(ijunno) then 
////		MessageBox("확인", "발행번호를 입력하십시오")
////		this.setitem(row, "bjunnot", snull)
////		return 
////	end if
////end if
//
//if this.getcolumnname() = "idatef" then
//	sidate = this.GetItemString(1, "idatef")
//	if sidate ="" or isnull(sidate) then return 
//	
//	if f_datechk(sidate) = -1 then
//		f_messagechk(21, '[입력일자]')
//	   this.setitem(this.getrow(), "idatef", snull)
//		return 1
//	end if
//end if
//
//if this.getcolumnname() = "idatet" then
//	sidate = this.GetItemString(1, "idatet")
//	if sidate ="" or isnull(sidate) then return 
//	
//	if f_datechk(sidate) = -1 then
//		f_messagechk(21, '[입력일자]')
//	   this.setitem(this.getrow(), "idatet", snull)
//		return 1
//	end if
//end if
end event

type dw_list from w_standard_print`dw_list within w_kfc01
integer x = 73
integer y = 328
integer width = 4521
integer height = 1880
string dataobject = "d_kfc01_02"
boolean border = false
end type

type rr_3 from roundrectangle within w_kfc01
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 55
integer y = 312
integer width = 4562
integer height = 1912
integer cornerheight = 40
integer cornerwidth = 55
end type

