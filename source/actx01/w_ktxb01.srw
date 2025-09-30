$PBExportHeader$w_ktxb01.srw
$PBExportComments$접대비 지역별 사용현황
forward
global type w_ktxb01 from w_standard_print
end type
type rr_1 from roundrectangle within w_ktxb01
end type
end forward

global type w_ktxb01 from w_standard_print
integer x = 0
integer y = 0
string title = "접대비 지역별 사용현황"
rr_1 rr_1
end type
global w_ktxb01 w_ktxb01

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String syy,smm,sdd,symd_text,styy,stmm,stdd,stymd_text
String ssdate,stdate,sSaupj

dw_ip.AcceptText()

ssdate   = Trim(dw_ip.GetItemString(1,"symd"))
stdate   = Trim(dw_ip.GetItemString(1,"tymd"))
sSaupj   = Trim(dw_ip.GetItemString(1,"saupj"))

IF ssdate = "" OR IsNull(ssdate) THEN
	F_MessageChk(1,'[사용기간]')
	dw_ip.SetColumn("symd")
	dw_ip.SetFocus()
	Return -1
ELSE
	IF f_datechk(ssdate) = -1 THEN
		f_messagechk(23, "")
		dw_ip.SetColumn("symd")
		dw_ip.SetFocus()
		Return -1
	END IF
END IF

IF stdate = "" OR IsNull(stdate) THEN
	F_MessageChk(1,'[사용기간]')
	dw_ip.SetColumn("tymd")
	dw_ip.SetFocus()
	Return -1
ELSE
	IF f_datechk(stdate) = -1 THEN
		f_messagechk(23, "")
		dw_ip.SetColumn("tymd")
		dw_ip.SetFocus()
		Return -1
	END IF
END IF

//날짜 출력물 헤드에 modify
syy = left(ssdate, 4)
smm = mid(ssdate,5,2)
sdd = right(ssdate,2)
symd_text = syy + '.'+ smm + '.' + sdd

styy = left(stdate, 4)
stmm = mid(stdate,5,2)
stdd = right(stdate,2)
stymd_text = styy + '.'+ stmm + '.' + stdd

dw_print.modify("symd.text ='"+symd_text+"'")
dw_print.modify("stymd.text ='"+stymd_text+"'")

setpointer(hourglass!)

if dw_print.retrieve(sSaupj,ssdate,stdate) <= 0 then
	messagebox("확인","조회한 자료가 없습니다.!!") 
	//return -1
	dw_list.insertrow(0)
end if 
	dw_print.sharedata(dw_list)
dw_ip.SetFocus()
setpointer(arrow!)
Return 1


end function

on w_ktxb01.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_ktxb01.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;
dw_ip.SetItem(1,"saupj", Gs_Saupj)
dw_ip.SetItem(1,"symd", Left(F_Today(),6)+'01')
dw_ip.SetItem(1,"tymd", F_Today())

dw_ip.SetFocus()

dw_ip.Modify("saupj.protect = 0")
dw_ip.Modify("saupj.background.color ='"+String(RGB(255,255,255))+"'")


end event

type p_preview from w_standard_print`p_preview within w_ktxb01
integer y = 4
integer taborder = 30
string pointer = ""
end type

type p_exit from w_standard_print`p_exit within w_ktxb01
integer y = 4
integer taborder = 50
string pointer = ""
end type

type p_print from w_standard_print`p_print within w_ktxb01
integer y = 4
integer taborder = 40
string pointer = ""
end type

type p_retrieve from w_standard_print`p_retrieve within w_ktxb01
integer y = 4
integer taborder = 20
string pointer = ""
end type

type st_window from w_standard_print`st_window within w_ktxb01
integer width = 494
end type





type st_10 from w_standard_print`st_10 within w_ktxb01
end type



type dw_print from w_standard_print`dw_print within w_ktxb01
integer y = 16
string dataobject = "dw_ktxb011_p"
end type

type dw_ip from w_standard_print`dw_ip within w_ktxb01
integer width = 2715
integer height = 140
integer taborder = 10
string dataobject = "dw_ktxb01"
end type

type dw_list from w_standard_print`dw_list within w_ktxb01
integer x = 64
integer y = 168
integer width = 4530
integer height = 2128
string dataobject = "dw_ktxb011"
boolean hscrollbar = false
boolean border = false
boolean hsplitscroll = false
end type

type rr_1 from roundrectangle within w_ktxb01
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 160
integer width = 4567
integer height = 2148
integer cornerheight = 40
integer cornerwidth = 55
end type

