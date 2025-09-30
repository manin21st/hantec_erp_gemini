$PBExportHeader$w_kfab06.srw
$PBExportComments$유형고정자산 조회 출력
forward
global type w_kfab06 from w_standard_print
end type
type rr_2 from roundrectangle within w_kfab06
end type
end forward

global type w_kfab06 from w_standard_print
integer x = 0
integer y = 0
string title = "유형고정자산명세서 조회 출력"
rr_2 rr_2
end type
global w_kfab06 w_kfab06

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String   sDate

sDate = Trim(dw_ip.GetItemString(1,"kfacdat"))

IF sDate = "" OR IsNull(sDate) THEN
	F_MessageChk(1,'[기준일자]')
	dw_ip.SetColumn("kfacdat")
	dw_ip.SetFocus()
	Return -1
END IF

IF dw_print.Retrieve(sDate) <= 0 THEN
	F_MessageChk(14,'')
	dw_ip.setfocus()
   Return -1
END IF

dw_print.sharedata(dw_list)

Return 1
end function

on w_kfab06.create
int iCurrent
call super::create
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
end on

on w_kfab06.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_2)
end on

event open;call super::open;dw_ip.SetItem(1,"kfacdat",f_today())
end event

type p_preview from w_standard_print`p_preview within w_kfab06
integer x = 4073
integer y = 8
integer taborder = 50
end type

type p_exit from w_standard_print`p_exit within w_kfab06
integer x = 4430
integer y = 8
integer taborder = 70
end type

type p_print from w_standard_print`p_print within w_kfab06
integer x = 4251
integer y = 8
integer taborder = 60
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfab06
integer x = 3895
integer y = 8
integer taborder = 30
end type







type st_10 from w_standard_print`st_10 within w_kfab06
end type



type dw_print from w_standard_print`dw_print within w_kfab06
integer x = 3104
string dataobject = "dw_kfab062_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kfab06
integer x = 27
integer y = 24
integer width = 1467
integer height = 152
integer taborder = 20
string dataobject = "dw_kfab061"
boolean livescroll = false
end type

event dw_ip::getfocus;call super::getfocus;dw_ip.Accepttext()
end event

event dw_ip::itemchanged;call super::itemchanged;String sNull

SetNull(sNull)

IF dwo.name = "kfacdat" THEN
	
	IF Trim(data) ="" OR IsNull(Trim(data)) THEN Return
	
	IF F_DateChk(Trim(data)) = -1 THEN 
		F_MessageChk(20,"기준일자") 
		This.SetItem(row,"kfacdat",sNull)
		Return 1
	END IF
END IF

IF dwo.name = "gb" THEN
	IF data = "1" THEN
		dw_list.Title ="유형고정자산명세서(요약)"
		dw_list.DataObject ="dw_kfab062"
		dw_print.DataObject ="dw_kfab062_p"
	ELSEIF data = "2" THEN
		dw_list.Title ="유형고정자산명세서(상세)"
		dw_list.DataObject ="dw_kfab063"
		dw_print.DataObject ="dw_kfab063_p"
	END IF
	dw_list.SetTransObject(SQLCA)
	dw_print.SetTransObject(SQLCA)
	dw_print.object.datawindow.print.preview = "yes"
END IF
end event

event dw_ip::itemerror;call super::itemerror;Return 1
end event

type dw_list from w_standard_print`dw_list within w_kfab06
integer x = 50
integer y = 196
integer width = 4544
integer height = 2032
integer taborder = 40
string dataobject = "dw_kfab062"
boolean hscrollbar = false
boolean border = false
boolean hsplitscroll = false
end type

type rr_2 from roundrectangle within w_kfab06
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 184
integer width = 4567
integer height = 2092
integer cornerheight = 40
integer cornerwidth = 55
end type

