$PBExportHeader$w_kglc60.srw
$PBExportComments$지급결제 결제대상 명세서 조회 출력
forward
global type w_kglc60 from w_standard_print
end type
type rr_1 from roundrectangle within w_kglc60
end type
end forward

global type w_kglc60 from w_standard_print
integer x = 0
integer y = 0
string title = "지급결제 결제대상 명세서 조회 출력"
rr_1 rr_1
end type
global w_kglc60 w_kglc60

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sGdate,sGb,sAccCd,sAccNm

sGdate = dw_ip.GetItemString(dw_ip.GetRow(),"baldate")
sGb    = dw_ip.GetItemString(dw_ip.GetRow(),"acc1_cd")

IF sGdate = "" OR IsNull(sGdate) THEN
	F_MessageChk(1,'[결제일자]')
	dw_ip.Setcolumn("baldate")
	dw_ip.SetFocus()
	Return -1
END IF

IF sGb = "" OR IsNull(sGb) THEN
	F_MessageChk(1,'[계정과목]')
	dw_ip.Setcolumn("acc1_cd")
	dw_ip.SetFocus()
	Return -1
END IF

Select dataname
  Into :sAccCd
  From syscnfg
 Where sysgu = 'A'
	And serial = 80
	And lineno = to_number(:sGb);

Select acc2_nm
  Into :sAccNm
  From kfz01om0
 Where acc1_cd||acc2_cd = :sAccCd;

Setpointer(Hourglass!)

IF dw_print.Retrieve(sGdate,sAccCd) <= 0   THEN
	messagebox("확인","조회한 자료가 없습니다.!!") 
	dw_ip.setfocus()
	Return -1
END IF

dw_print.Modify("t_acc.text = '"+sAccNm+"'")

Setpointer(Arrow!)

Return 1
end function

on w_kglc60.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kglc60.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;String sToday,sLastDate

sToday = F_Today()

Select to_char(last_day(:sToday),'YYYYMMDD')
  Into :sLastDate
  From dual;

dw_ip.SetItem(dw_ip.Getrow(),"baldate",sLastDate)
dw_ip.SetItem(dw_ip.Getrow(),"acc1_cd","1")
end event

type p_preview from w_standard_print`p_preview within w_kglc60
integer y = 4
end type

type p_exit from w_standard_print`p_exit within w_kglc60
integer y = 4
end type

type p_print from w_standard_print`p_print within w_kglc60
integer y = 4
end type

type p_retrieve from w_standard_print`p_retrieve within w_kglc60
integer y = 4
end type

type st_window from w_standard_print`st_window within w_kglc60
integer width = 494
end type





type st_10 from w_standard_print`st_10 within w_kglc60
end type



type dw_print from w_standard_print`dw_print within w_kglc60
string dataobject = "dw_kglc602_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kglc60
integer x = 18
integer y = 28
integer width = 1934
integer height = 152
string dataobject = "dw_kglc601"
end type

event dw_ip::itemchanged;call super::itemchanged;String  sNull,sGb,sDate
Integer iCurRow,iCount

SetNull(sNull)

iCurRow = this.GetRow()

IF this.GetColumnName() = "baldate" THEN
	sDate = Trim(this.GetText())
	IF sDate = "" OR IsNull(sDate) THEN RETURN
	
	IF F_DateChk(sDate+'01') = -1 THEN
		F_MessageChk(21,'[결제일자]')
		this.SetItem(iCurRow,"baldate",sNull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "acc1_cd" THEN
	sGb = Trim(this.GetText())
	IF sGb = "" OR IsNull(sGb) THEN RETURN
	
	Select count(*)
	  Into :iCount
	  From syscnfg
	 Where sysgu = 'A'
	   And serial = 80
		And lineno = to_number(:sGb);
	
	IF iCount = 0 THEN
		F_MessageChk(20,'[계정과목]')
		this.SetItem(iCurRow,"acc1_cd",sNull)
		Return 1
	END IF
END IF
end event

event dw_ip::itemerror;call super::itemerror;Return 1
end event

type dw_list from w_standard_print`dw_list within w_kglc60
integer x = 32
integer y = 204
integer width = 4576
integer height = 2004
string title = "월계표"
string dataobject = "dw_kglc602"
boolean minbox = true
boolean border = false
end type

type rr_1 from roundrectangle within w_kglc60
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 196
integer width = 4603
integer height = 2024
integer cornerheight = 40
integer cornerwidth = 55
end type

