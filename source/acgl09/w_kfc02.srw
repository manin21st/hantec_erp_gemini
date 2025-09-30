$PBExportHeader$w_kfc02.srw
$PBExportComments$승인전표이력조회출력
forward
global type w_kfc02 from w_standard_print
end type
type rr_3 from roundrectangle within w_kfc02
end type
end forward

global type w_kfc02 from w_standard_print
integer x = 0
integer y = 0
string title = "승인전표이력"
rr_3 rr_3
end type
global w_kfc02 w_kfc02

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string suserid, saccdatef, saccdatet, dd, snull
string sadatef, sadatet

setnull(snull)

IF dw_ip.AcceptText() = -1 then return -1

suserid   = dw_ip.GetItemString(1,"auserid")
saccdatef = Trim(dw_ip.getitemstring(1,"acc_datef"))
saccdatet = Trim(dw_ip.getitemstring(1,"acc_datet"))

IF suserid = "" OR IsNull(suserid) THEN suserid = '%'

IF saccdatef = "" OR IsNull(saccdatef) THEN
	F_MessageChk(1,'[승인일자]')
	dw_ip.SetColumn("acc_datef")
	dw_ip.SetFocus()
	Return -1
END IF

IF saccdatet = "" OR IsNull(saccdatet) THEN
	F_MessageChk(1,'[승인일자]')
	dw_ip.SetColumn("acc_datet")
	dw_ip.SetFocus()
	Return -1
END IF

IF dw_print.retrieve(suserid, saccdatef, saccdatet) <= 0 THEN
	F_MessageChk(14,'')
	Return -1
END IF

dw_print.sharedata(dw_list)

dw_ip.SetFocus()

Return 1
end function

on w_kfc02.create
int iCurrent
call super::create
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_3
end on

on w_kfc02.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_3)
end on

event open;call super::open;string sdate, edate

sdate = left(f_today(), 6) + '01'
edate = f_today()

dw_ip.setitem(1, "adatef", sdate)
dw_ip.setitem(1, "adatet", edate)
dw_ip.setitem(1, "acc_datef", sdate)
dw_ip.setitem(1, "acc_datet", edate)

dw_ip.setfocus()
end event

type p_preview from w_standard_print`p_preview within w_kfc02
end type

type p_exit from w_standard_print`p_exit within w_kfc02
end type

type p_print from w_standard_print`p_print within w_kfc02
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfc02
end type







type st_10 from w_standard_print`st_10 within w_kfc02
end type



type dw_print from w_standard_print`dw_print within w_kfc02
string dataobject = "d_kfc02_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kfc02
integer x = 46
integer y = 20
integer width = 2130
integer height = 152
string dataobject = "d_kfc02_01"
end type

event dw_ip::getfocus;this.accepttext()
end event

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;//string suserid, saccdate, snull, dd
//datetime dtadate
//
//setnull(snull)
//
//if this.getcolumnname() = "auserid" then
//	suserid = this.gettext()
//	if suserid = "" or isnull(suserid) then
//		suserid = '%'
//	end if
//end if
//
//if dw_ip.getcolumnname() = "adatef" then
//	dtadate = dw_ip.getitemdatetime(1, "adatef")
//	dd = string(dtadate, "@@@@@@@@")
//	if isnull(dd) then 
//	   messagebox("확인", "승인입력일자를 입력하세요")
//		dw_ip.SetColumn('adatef')
//		dw_ip.SetFocus()
//		return 
//	end If
//	
//	if f_datechk(dd) = -1 then
//		f_messagechk(21, '[승인입력일자]')
//	   dw_ip.setitem(dw_ip.getrow(), "adatef", snull)
//		return 1
//	end if
//end if
//
//if dw_ip.getcolumnname() = "adatet" then
//	dtadate = dw_ip.getitemdatetime(1, "adatet")
//	dd = string(dtadate, "@@@@@@@@")
//	if isnull(dd) then 
//	   messagebox("확인", "승인입력일자를 입력하세요")
//		dw_ip.SetColumn('adatet')
//		dw_ip.SetFocus()
//		return 
//	end If
//	
//	if f_datechk(dd) = -1 then
//		f_messagechk(21, '[승인입력일자]')
//	   dw_ip.setitem(dw_ip.getrow(), "adatet", snull)
//		return 1
//	end if
//end if
//
//if this.getcolumnname() = "acc_datef" then
//	saccdate = trim(this.gettext())
//	if saccdate = "" or isnull(saccdate) then return
//	
//	if f_datechk(saccdate) = -1 then
//		f_messagechk(21, '[승인일자]')
//		this.setitem(this.getrow(), "acc_datef", snull)
//		return 1
//	end if
//end if
//
//if this.getcolumnname() = "acc_datet" then
//	saccdate = trim(this.gettext())
//	if saccdate = "" or isnull(saccdate) then return
//	
//	if f_datechk(saccdate) = -1 then
//		f_messagechk(21, '[승인일자]')
//		this.setitem(this.getrow(), "acc_datet", snull)
//		return 1
//	end if
//end if
//	
//		
//
//
end event

type dw_list from w_standard_print`dw_list within w_kfc02
integer x = 78
integer y = 192
integer width = 4521
integer height = 2012
string dataobject = "d_kfc02_02"
boolean border = false
end type

type rr_3 from roundrectangle within w_kfc02
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 55
integer y = 176
integer width = 4562
integer height = 2048
integer cornerheight = 40
integer cornerwidth = 55
end type

