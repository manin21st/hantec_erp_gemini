$PBExportHeader$w_kglc29.srw
$PBExportComments$업체별 결재현황 조회 출력
forward
global type w_kglc29 from w_standard_print
end type
type rr_1 from roundrectangle within w_kglc29
end type
end forward

global type w_kglc29 from w_standard_print
string title = "업체별 결재현황 조회 출력"
rr_1 rr_1
end type
global w_kglc29 w_kglc29

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();Int    i
String sBaseDate,sYm0,sYm1,sYm2,sYm3,sYm4,sYm5,sYm6

dw_ip.AcceptText()

sBaseDate = Trim(dw_ip.GetItemString(1,"k_symd"))

IF sBaseDate = "" OR IsNull(sBaseDate) THEN
	F_MessageChk( 23,"")
	dw_ip.SetColumn("k_symd")
	dw_ip.SetFocus()
	Return 1
END IF

Select to_char(add_months(:sBaseDate,-1),'yyyymm'),
       to_char(add_months(:sBaseDate,1),'yyyymm'),
		 to_char(add_months(:sBaseDate,2),'yyyymm'),
		 to_char(add_months(:sBaseDate,3),'yyyymm'),
		 to_char(add_months(:sBaseDate,4),'yyyymm'),
		 to_char(add_months(:sBaseDate,5),'yyyymm'),
		 to_char(add_months(:sBaseDate,6),'yyyymm')
  Into :sYm0,:sYm1,:sYm2,:sYm3,:sYm4,:sYm5,:sYm6
  From dual;

dw_print.object.t_date.text = Mid(sBaseDate,1,4)+"."+Mid(sBaseDate,5,2)+"."+Mid(sBaseDate,7,2)

IF dw_print.Retrieve(sYm0,Mid(sBaseDate,1,6),sYm1,sYm2,sYm3,sYm4,sYm5,sYm6) <= 0 THEN
	F_MessageChk(14,'')
	Return -1
END IF

dw_list.SetRedraw(False)

dw_list.Retrieve(sYm0,Mid(sBaseDate,1,6),sYm1,sYm2,sYm3,sYm4,sYm5,sYm6)

For i = 1 To 6
	Choose Case i
		Case 1
			dw_print.SetItem(i,"ym",sYm1)
			dw_list.SetItem(i,"ym",sYm1)
		Case 2
			dw_print.SetItem(i,"ym",sYm2)
			dw_list.SetItem(i,"ym",sYm2)
		Case 3
			dw_print.SetItem(i,"ym",sYm3)
			dw_list.SetItem(i,"ym",sYm3)
		Case 4
			dw_print.SetItem(i,"ym",sYm4)
			dw_list.SetItem(i,"ym",sYm4)
		Case 5
			dw_print.SetItem(i,"ym",sYm5)
			dw_list.SetItem(i,"ym",sYm5)
		Case 6
			dw_print.SetItem(i,"ym",sYm6)
			dw_list.SetItem(i,"ym",sYm6)
		Case Else
	End Choose
Next

dw_list.SetRedraw(True)

dw_ip.SetFocus()

Return 1
end function

on w_kglc29.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kglc29.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetItem(1,"k_symd",  F_ToDay())

dw_ip.SetFocus()

dw_list.SetTransObject(Sqlca)
dw_list.Reset()
dw_print.SetTransObject(Sqlca)
	
dw_list.ShareDataOff()
end event

type p_preview from w_standard_print`p_preview within w_kglc29
integer y = 0
string pointer = ""
end type

type p_exit from w_standard_print`p_exit within w_kglc29
integer y = 0
string pointer = ""
end type

type p_print from w_standard_print`p_print within w_kglc29
integer y = 0
string pointer = ""
end type

type p_retrieve from w_standard_print`p_retrieve within w_kglc29
integer y = 0
string pointer = ""
end type







type st_10 from w_standard_print`st_10 within w_kglc29
end type



type dw_print from w_standard_print`dw_print within w_kglc29
integer x = 3671
integer y = 20
string dataobject = "dw_kglc291_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kglc29
integer x = 37
integer y = 20
integer width = 818
integer height = 148
string dataobject = "dw_kglc29"
end type

event dw_ip::itemerror;call super::itemerror;Return 1
end event

event dw_ip::getfocus;call super::getfocus;this.AcceptText()
end event

event dw_ip::itemchanged;call super::itemchanged;String sNull,sYearMonthDay
 
SetNull(sNull)

IF this.GetColumnName() = "k_symd" THEN
	sYearMonthDay = Trim(this.GetText())
	IF sYearMonthDay = "" OR IsNull(sYearMonthDay) THEN Return
	
	IF F_DateChk(sYearMonthDay) = -1 THEN
		F_MessageChk(21,'[기준일자]')
		this.SetItem(this.GetRow(),"k_symd",sNull)
		Return 1
	END IF
END IF
end event

event dw_ip::losefocus;call super::losefocus;This.AcceptText()
end event

type dw_list from w_standard_print`dw_list within w_kglc29
integer x = 55
integer y = 180
integer width = 4544
integer height = 2036
string dataobject = "dw_kglc291"
boolean border = false
boolean hsplitscroll = false
end type

type rr_1 from roundrectangle within w_kglc29
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 172
integer width = 4571
integer height = 2052
integer cornerheight = 40
integer cornerwidth = 55
end type

