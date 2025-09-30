$PBExportHeader$w_kfia40.srw
$PBExportComments$자금 시재표 조회 출력
forward
global type w_kfia40 from w_standard_print
end type
type rr_2 from roundrectangle within w_kfia40
end type
end forward

global type w_kfia40 from w_standard_print
integer x = 0
integer y = 0
string title = "자금 시재표 조회 출력"
rr_2 rr_2
end type
global w_kfia40 w_kfia40

on w_kfia40.create
int iCurrent
call super::create
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
end on

on w_kfia40.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_2)
end on

event open;call super::open;dw_list.sharedataoff()

dw_list.object.datawindow.print.preview = "yes"

dw_ip.SetItem(1, "acc_ym",f_Today())

end event

type p_xls from w_standard_print`p_xls within w_kfia40
end type

type p_sort from w_standard_print`p_sort within w_kfia40
end type

type p_preview from w_standard_print`p_preview within w_kfia40
boolean visible = false
integer x = 4105
integer y = 20
end type

type p_exit from w_standard_print`p_exit within w_kfia40
integer x = 4453
end type

type p_print from w_standard_print`p_print within w_kfia40
integer x = 4279
integer y = 20
end type

event p_print::clicked;//Override

IF dw_list.rowcount() > 0 then 
	gi_page = dw_list.GetItemNumber(1,"last_page")
ELSE
	gi_page = 1
END IF

OpenWithParm(w_print_options, dw_list)
end event

type p_retrieve from w_standard_print`p_retrieve within w_kfia40
integer x = 4105
integer y = 20
end type

event p_retrieve::clicked;//Override

String sDate

Setpointer(Hourglass!)

dw_ip.accepttext()

sDate = Trim(dw_ip.getitemstring(dw_ip.getrow(),"acc_ym"))

IF Isnull(sDate) OR sDate = '' THEN
	F_MessageChk(20,"기준일자")
	dw_ip.setfocus()
	dw_ip.setcolumn("acc_ym")
	Setpointer(Arrow!)
	Return
END IF

IF dw_list.retrieve(sDate,Mid(sDate,1,4)) < 1 THEN
	F_MessageChk(14,'')
	dw_ip.setfocus()
	dw_ip.setcolumn("acc_ym")
	p_print.Enabled = False
	p_print.PictureName =  'C:\erpman\image\인쇄_d.gif'
	Setpointer(Arrow!)
	Return
END IF

p_print.Enabled = True
p_print.PictureName =  'C:\erpman\image\인쇄_up.gif'

Setpointer(Arrow!)
end event

type st_window from w_standard_print`st_window within w_kfia40
boolean visible = false
integer y = 2116
end type

type sle_msg from w_standard_print`sle_msg within w_kfia40
boolean visible = false
integer x = 389
integer y = 2116
end type

type dw_datetime from w_standard_print`dw_datetime within w_kfia40
boolean visible = false
integer y = 2116
end type

type st_10 from w_standard_print`st_10 within w_kfia40
boolean visible = false
integer x = 27
integer y = 2116
end type

type gb_10 from w_standard_print`gb_10 within w_kfia40
boolean visible = false
integer y = 2080
end type

type dw_print from w_standard_print`dw_print within w_kfia40
string dataobject = "d_kfia40_1"
end type

type dw_ip from w_standard_print`dw_ip within w_kfia40
integer x = 32
integer y = 28
integer width = 818
integer height = 120
string dataobject = "d_kfia40_0"
end type

event dw_ip::itemchanged;call super::itemchanged;String sNull

Setnull(sNull)

IF dwo.name = "acc_ym" THEN
	IF Trim(data) = "" OR IsNull(Trim(data)) THEN Return
	
	IF F_DateChk(Trim(data)) = -1 THEN 
		F_MessageChk(20,"기준일자")
		This.SetItem(row,"acc_ym",sNull)
		Return 1
	END IF
END IF
end event

event dw_ip::itemerror;call super::itemerror;Return 1
end event

event dw_ip::getfocus;call super::getfocus;this.AcceptText()
end event

type dw_list from w_standard_print`dw_list within w_kfia40
integer x = 407
integer y = 188
integer width = 3630
integer height = 2116
string dataobject = "d_kfia40_1"
boolean hscrollbar = false
boolean border = false
boolean hsplitscroll = false
end type

event dw_list::clicked;w_mdi_frame.sle_msg.text = ''
end event

event dw_list::rowfocuschanged;w_mdi_frame.sle_msg.text = ''
end event

type rr_2 from roundrectangle within w_kfia40
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 176
integer width = 4581
integer height = 2140
integer cornerheight = 40
integer cornerwidth = 55
end type

