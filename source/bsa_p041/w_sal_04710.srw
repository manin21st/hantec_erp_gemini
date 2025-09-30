$PBExportHeader$w_sal_04710.srw
$PBExportComments$장기미수금 회수 현황
forward
global type w_sal_04710 from w_standard_print
end type
type rr_1 from roundrectangle within w_sal_04710
end type
end forward

global type w_sal_04710 from w_standard_print
string title = "장기 미수금 회수 현황"
rr_1 rr_1
end type
global w_sal_04710 w_sal_04710

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sSarea, sGubun, sFlt_Cls, sNull

SetNull(sNull)

dw_ip.AcceptText()
sGubun = dw_ip.GetItemString(1,'gubun')

Choose Case sGubun
	Case '1'
      sFlt_Cls = ""
   Case '2'
      sFlt_Cls = "sugum_sum >= long_misu_amt"
   Case '3'
      sFlt_Cls = "sugum_sum < long_misu_amt"
end Choose

dw_list.SetFilter(sFlt_Cls)
dw_list.Filter()

sSarea = Trim(dw_ip.GetItemString(1,'sarea'))
if isnull(sSarea) or trim(sSarea) = ''  then
	sSarea = '%'
end if

if dw_list.Retrieve(sSarea) < 1 then
	f_message_Chk(300, '[출력조건 CHECK]')
	dw_ip.setcolumn('sarea')
	dw_ip.setfocus()
	return -1
else
	dw_print.SetFilter(sFlt_Cls)
	dw_print.Filter()
	dw_print.Retrieve(sSarea)
end if

return 1

//String sSarea, sGubun, sFlt_Cls, sNull
//
//SetNull(sNull)
//
//dw_ip.AcceptText()
//sGubun = dw_ip.GetItemString(1,'gubun')
//
//Choose Case sGubun
//	Case '1'
//      sFlt_Cls = ""
//   Case '2'
//      sFlt_Cls = "sugum_sum >= long_misu_amt"
//   Case '3'
//      sFlt_Cls = "sugum_sum < long_misu_amt"
//end Choose
//
//dw_list.SetFilter(sFlt_Cls)
//dw_list.Filter()
//
//sSarea = Trim(dw_ip.GetItemString(1,'sarea'))
//if isnull(sSarea) or trim(sSarea) = ''  then
//	sSarea = '%'
//end if
//
//if dw_list.Retrieve(sSarea) < 1 then
//	f_message_Chk(300, '[출력조건 CHECK]')
//	dw_ip.setcolumn('sarea')
//	dw_ip.setfocus()
//	return -1
//end if
//
//return 1
end function

on w_sal_04710.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_sal_04710.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;String sToday

sle_msg.text = "출력조건을 입력하고 조회버턴을 누르세요"

/* User별 관할구역 Setting */
String sarea, steam, saupj

If f_check_sarea(sarea, steam, saupj) = 1 Then
	dw_ip.Modify("sarea.protect=1")
	dw_ip.Modify("sarea.background.color = 80859087")
End If
dw_ip.SetItem(1, "sarea", sarea)

dw_ip.SetColumn('gubun')

dw_Ip.SetFocus()
end event

type p_preview from w_standard_print`p_preview within w_sal_04710
end type

type p_exit from w_standard_print`p_exit within w_sal_04710
end type

type p_print from w_standard_print`p_print within w_sal_04710
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_04710
boolean originalsize = true
end type







type st_10 from w_standard_print`st_10 within w_sal_04710
end type



type dw_print from w_standard_print`dw_print within w_sal_04710
string dataobject = "d_sal_04710_01_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_04710
integer y = 44
integer width = 2880
integer height = 156
string dataobject = "d_sal_04710"
end type

event dw_ip::itemchanged;Choose Case GetColumnName()
	// 구분 라디오버턴 클릭시
   Case "gubun"  
		dw_list.Reset()
End Choose
end event

type dw_list from w_standard_print`dw_list within w_sal_04710
integer x = 366
integer y = 228
integer width = 3707
integer height = 2092
string dataobject = "d_sal_04710_01"
boolean border = false
end type

type rr_1 from roundrectangle within w_sal_04710
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 357
integer y = 216
integer width = 3730
integer height = 2112
integer cornerheight = 40
integer cornerwidth = 55
end type

