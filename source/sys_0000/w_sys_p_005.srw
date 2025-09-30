$PBExportHeader$w_sys_p_005.srw
$PBExportComments$** 환경설정현황 출력
forward
global type w_sys_p_005 from w_standard_print
end type
type st_1 from statictext within w_sys_p_005
end type
type dw_from from datawindow within w_sys_p_005
end type
type dw_to from datawindow within w_sys_p_005
end type
type st_2 from statictext within w_sys_p_005
end type
type rr_1 from roundrectangle within w_sys_p_005
end type
type rr_2 from roundrectangle within w_sys_p_005
end type
end forward

global type w_sys_p_005 from w_standard_print
string title = "환경 설정 현황"
boolean resizable = true
st_1 st_1
dw_from dw_from
dw_to dw_to
st_2 st_2
rr_1 rr_1
rr_2 rr_2
end type
global w_sys_p_005 w_sys_p_005

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();
String  sFrom, sTo

if dw_from.accepttext() = -1	then	return -1

if dw_to.accepttext() = -1	then	return -1

sFrom = dw_from.getitemString(1,1)
sTo   = dw_to.getitemString(1,1)

if isnull(sFrom) OR sFrom ="" then	sFrom = '0' 
if isnull(sTo)	OR sTo ="" then	sTo = 'Z'

IF	( sFrom > sTo  )	  then
	MessageBox("확인","관리구분의 범위를 확인하세요!")
	dw_from.setfocus()
	Return -1
END IF

////////////////////////////////////////////////////////////////
if dw_list.retrieve(sFrom, sTo) < 1	then
	messagebox("확인", "조회 자료 가 없습니다.!", stopsign!)
	dw_from.setfocus()
	return -1
end if

Return 1

end function

on w_sys_p_005.create
int iCurrent
call super::create
this.st_1=create st_1
this.dw_from=create dw_from
this.dw_to=create dw_to
this.st_2=create st_2
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.dw_from
this.Control[iCurrent+3]=this.dw_to
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.rr_1
this.Control[iCurrent+6]=this.rr_2
end on

on w_sys_p_005.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.dw_from)
destroy(this.dw_to)
destroy(this.st_2)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;
dw_from.settransobject(sqlca)
dw_to.settransobject(sqlca)

dw_from.insertrow(0)

dw_to.insertrow(0)

sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 세로방향"
end event

type p_preview from w_standard_print`p_preview within w_sys_p_005
end type

type p_exit from w_standard_print`p_exit within w_sys_p_005
end type

type p_print from w_standard_print`p_print within w_sys_p_005
end type

type p_retrieve from w_standard_print`p_retrieve within w_sys_p_005
end type

type st_window from w_standard_print`st_window within w_sys_p_005
integer x = 2322
integer y = 3028
end type

type sle_msg from w_standard_print`sle_msg within w_sys_p_005
boolean visible = false
integer y = 3028
integer width = 1943
end type

type dw_datetime from w_standard_print`dw_datetime within w_sys_p_005
boolean visible = false
integer x = 2821
integer y = 3028
integer width = 741
integer height = 84
end type

type st_10 from w_standard_print`st_10 within w_sys_p_005
boolean visible = false
integer x = 9
integer y = 3028
integer width = 361
end type

type gb_10 from w_standard_print`gb_10 within w_sys_p_005
boolean visible = false
integer x = 23
integer y = 2992
integer width = 3602
integer height = 160
end type

type dw_print from w_standard_print`dw_print within w_sys_p_005
string dataobject = "d_sys_p_0051"
end type

type dw_ip from w_standard_print`dw_ip within w_sys_p_005
boolean visible = false
integer x = 1079
integer y = 2396
integer width = 741
integer height = 116
end type

type dw_list from w_standard_print`dw_list within w_sys_p_005
integer x = 110
integer y = 296
integer width = 4407
integer height = 1924
string dataobject = "d_sys_p_0051"
end type

type st_1 from statictext within w_sys_p_005
integer x = 165
integer y = 116
integer width = 389
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "관리구분"
boolean focusrectangle = false
end type

type dw_from from datawindow within w_sys_p_005
integer x = 421
integer y = 104
integer width = 709
integer height = 112
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_sys_p_0052"
boolean border = false
boolean livescroll = true
end type

type dw_to from datawindow within w_sys_p_005
integer x = 1152
integer y = 104
integer width = 709
integer height = 112
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_sys_p_0052"
boolean border = false
boolean livescroll = true
end type

type st_2 from statictext within w_sys_p_005
integer x = 1106
integer y = 120
integer width = 46
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
boolean enabled = false
string text = "-"
alignment alignment = center!
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_sys_p_005
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 96
integer y = 44
integer width = 1838
integer height = 212
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_sys_p_005
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 96
integer y = 276
integer width = 4443
integer height = 1964
integer cornerheight = 40
integer cornerwidth = 55
end type

