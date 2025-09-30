$PBExportHeader$w_ktxb06.srw
$PBExportComments$접대비 내역 조회 출력
forward
global type w_ktxb06 from w_standard_print
end type
type rr_1 from roundrectangle within w_ktxb06
end type
end forward

global type w_ktxb06 from w_standard_print
integer x = 0
integer y = 0
string title = "접대비내역 조회 출력"
rr_1 rr_1
end type
global w_ktxb06 w_ktxb06

type variables
String prt_gu

end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sSaupj,sDatef,sDatet

dw_ip.AcceptText()

w_mdi_frame.sle_msg.text = ""

sSaupj  = dw_ip.GetItemString(1,"saupj")
sDatef  = Trim(dw_ip.GetItemString(1,"sDate"))
sDatet  = Trim(dw_ip.GetItemString(1,"eDate"))

IF sSaupj = "" OR IsNull(sSaupj) THEN
	F_MessageChk(1,'[사업장]')
	dw_ip.SetColumn("sSaupj")
	dw_ip.SetFocus()
	Return -1
END IF

IF sDatef = "" OR IsNull(sDateF) THEN
	F_MessageChk(1,'[회계일자]')
	dw_ip.SetColumn("sDate")
	dw_ip.SetFocus()
	Return -1
END IF

IF sDatet = "" OR IsNull(sDatet) THEN
	F_MessageChk(1,'[회계일자]')
	dw_ip.SetColumn("eDate")
	dw_ip.SetFocus()
	Return -1
END IF

IF DaysAfter(Date(sDatef),Date(sDatet)) < 0 THEN
	f_Messagechk(24,"")
	dw_ip.SetColumn("sDate")
	dw_ip.SetFocus()
	Return -1
END IF 

Setpointer(Hourglass!)

IF dw_print.Retrieve(sSaupj,sDatef,sDatet) <=0 THEN
	f_Messagechk(14,"")
	Setpointer(Arrow!)
	Return -1
END IF

Setpointer(Arrow!)

Return 1
end function

on w_ktxb06.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_ktxb06.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetItem(dw_ip.GetRow(),"saupj", gs_saupj)
dw_ip.SetItem(dw_ip.Getrow(),"sdate", left(f_today(), 6) + "01")
dw_ip.SetItem(dw_ip.Getrow(),"edate", f_today())
dw_ip.SetFocus()
end event

type p_preview from w_standard_print`p_preview within w_ktxb06
integer x = 4082
integer y = 8
integer taborder = 30
string pointer = ""
end type

type p_exit from w_standard_print`p_exit within w_ktxb06
integer x = 4425
integer y = 8
integer taborder = 50
string pointer = ""
end type

type p_print from w_standard_print`p_print within w_ktxb06
integer x = 4256
integer y = 8
integer taborder = 40
string pointer = ""
end type

type p_retrieve from w_standard_print`p_retrieve within w_ktxb06
integer x = 3909
integer y = 8
string pointer = ""
end type







type st_10 from w_standard_print`st_10 within w_ktxb06
end type



type dw_print from w_standard_print`dw_print within w_ktxb06
string dataobject = "dw_ktxb062_p"
end type

type dw_ip from w_standard_print`dw_ip within w_ktxb06
integer x = 59
integer y = 24
integer width = 2057
integer height = 136
string dataobject = "dw_ktxb061"
end type

event dw_ip::itemchanged;String sDate,sNull

Setnull(sNull)

IF this.GetColumnName() = 'sdate' THEN
	sDate = Trim(this.GetText())
	IF sDate = "" OR IsNull(sDate) THEN RETURN
	
	IF F_DateChk(sDate) = -1 THEN
		F_MessageChk(21,'[회계일자]')
		this.SetItem(1,'sdate', snull)
		Return 1
	ELSE
		this.SetItem(1,'sdate', sDate)
	END IF
END IF

IF this.GetColumnName() = 'edate' THEN
	sDate = Trim(this.GetText())
	IF sDate = "" OR IsNull(sDate) THEN RETURN
	
	IF F_DateChk(sDate) = -1 THEN
		F_MessageChk(21,'[회계일자]')
		this.SetItem(1,'edate', snull)
		Return 1
	ELSE
		this.SetItem(1,'edate', sDate)
	END IF
END IF

end event

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_ktxb06
integer x = 78
integer y = 176
integer width = 4507
integer height = 2032
string dataobject = "dw_ktxb062"
boolean hscrollbar = false
boolean border = false
boolean hsplitscroll = false
end type

type rr_1 from roundrectangle within w_ktxb06
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 69
integer y = 168
integer width = 4530
integer height = 2060
integer cornerheight = 40
integer cornerwidth = 55
end type

