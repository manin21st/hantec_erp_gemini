$PBExportHeader$wp_pik1110.srw
$PBExportComments$**일일근태 현황
forward
global type wp_pik1110 from w_standard_print
end type
type rr_2 from roundrectangle within wp_pik1110
end type
end forward

global type wp_pik1110 from w_standard_print
integer x = 0
integer y = 0
string title = "일일 근태 현황"
rr_2 rr_2
end type
global wp_pik1110 wp_pik1110

type variables
string is_timegbn
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sYearMonthDay,sDayName, sabu
String sJikjong0, sJikjong1, sJikjong2 ,sJikjong3, sKunmu0, sKunmu1, sKunmu2, sKunmu3

if dw_ip.Accepttext() = -1 then return -1

sYearMonthDay = trim(dw_ip.GetItemString(1,"printday"))

IF sYearMonthDay = "" OR IsNull(sYearMonthDay) THEN
	MessageBox("확 인","출력일자를 입력하세요!!")
	dw_ip.SetColumn('printday')
	dw_ip.SetFocus()
	Return -1
ELSE
	SELECT "P0_DAY"."DAYNAME"  
   	INTO :sDayName  
    	FROM "P4_CALENDAR",   "P0_DAY"  
	   WHERE ( "P4_CALENDAR"."DAYGUBN" = "P0_DAY"."DAYGUBN" ) and  
   	      ( ( "P4_CALENDAR"."COMPANYCODE" = :gs_company ) AND  
      	   ( "P4_CALENDAR"."CLDATE" = :sYearMonthDay ) )   ;
END IF

sabu = dw_ip.Getitemstring(1,'sabu')
if IsNull(sabu) or sabu = '' then sabu = '%'

sJikjong0  = dw_ip.GetItemString(1,"jikjong0")		// 임원 : 0
sJikjong1  = dw_ip.GetItemString(1,"jikjong1")		// 관리직 : 1
sJikjong2  = dw_ip.GetItemString(1,"jikjong2")		// 생산직 : 2
sJikjong3  = dw_ip.GetItemString(1,"jikjong3")		// 용역 : 3
sKunmu0  = dw_ip.GetItemString(1,"kunmu0")		// 정직원 : 10		
sKunmu1  = dw_ip.GetItemString(1,"kunmu1")		// 파견직 : 20
sKunmu2  = dw_ip.GetItemString(1,"kunmu2")		// 계약직 : 30
sKunmu3  = dw_ip.GetItemString(1,"kunmu3")		// 용역 : 40


IF dw_print.Retrieve(gs_company,sYearMonthDay,sDayName, sabu, is_timegbn, sJikjong0, sJikjong1, sJikjong2 ,sJikjong3, sKunmu0, sKunmu1, sKunmu2, sKunmu3) <=0 THEN
	MessageBox("확 인","조회한 자료가 없습니다!!")
	dw_ip.SetColumn('printday')
	dw_ip.SetFocus()
	Return -1
END IF
   dw_print.sharedata(dw_list)
Return 1
end function

on wp_pik1110.create
int iCurrent
call super::create
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
end on

on wp_pik1110.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_2)
end on

event open;call super::open;dw_list.settransobject(sqlca)
dw_ip.settransobject(sqlca)
dw_ip.SetItem(1,"printday",String(gs_today))
dw_ip.SetColumn('printday')
dw_ip.SetItem(1,"jikjong0", "0")
dw_ip.SetItem(1,"jikjong1", "1")
dw_ip.SetItem(1,"jikjong2", "2")
dw_ip.SetItem(1,"kunmu0", "10")
dw_ip.SetFocus()
f_set_saupcd(dw_ip, 'sabu', '1')
is_saupcd = gs_saupcd

is_timegbn = f_get_p0_syscnfg(8,'1')


end event

type p_xls from w_standard_print`p_xls within wp_pik1110
end type

type p_sort from w_standard_print`p_sort within wp_pik1110
end type

type p_preview from w_standard_print`p_preview within wp_pik1110
end type

type p_exit from w_standard_print`p_exit within wp_pik1110
end type

type p_print from w_standard_print`p_print within wp_pik1110
end type

type p_retrieve from w_standard_print`p_retrieve within wp_pik1110
end type

type st_window from w_standard_print`st_window within wp_pik1110
boolean visible = false
integer x = 2501
integer y = 2580
end type

type sle_msg from w_standard_print`sle_msg within wp_pik1110
boolean visible = false
integer x = 526
integer y = 2580
end type

type dw_datetime from w_standard_print`dw_datetime within wp_pik1110
boolean visible = false
integer x = 2994
integer y = 2580
end type

type st_10 from w_standard_print`st_10 within wp_pik1110
boolean visible = false
integer x = 165
integer y = 2580
end type

type gb_10 from w_standard_print`gb_10 within wp_pik1110
boolean visible = false
integer x = 151
integer y = 2528
end type

type dw_print from w_standard_print`dw_print within wp_pik1110
string dataobject = "dp_pik1110_p"
end type

type dw_ip from w_standard_print`dw_ip within wp_pik1110
integer x = 64
integer y = 52
integer width = 3259
integer height = 240
integer taborder = 50
string dataobject = "dp_pik1110_1"
end type

event dw_ip::itemchanged;call super::itemchanged;String SetNull


IF GetColumnName() = "sabu" THEN
	is_saupcd = this.GetText()
END IF

IF this.GetcolumnName() ="printday" THEN
	IF IsNull(data) OR data ="" THEN
		Return 1
   END IF
	If f_datechk(data) = -1 THEN
		MessageBox("확 인", "출력일자가 부정확합니다.")
		SetItem(getrow(),'printday',SetNull)
		SetColumn('printday')
		dw_ip.SetFocus()
		Return 1
	END IF
END IF
end event

type dw_list from w_standard_print`dw_list within wp_pik1110
integer x = 78
integer y = 316
integer width = 4498
integer height = 1992
string dataobject = "dp_pik1110"
boolean border = false
boolean hsplitscroll = false
end type

type rr_2 from roundrectangle within wp_pik1110
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 73
integer y = 312
integer width = 4521
integer height = 2024
integer cornerheight = 40
integer cornerwidth = 55
end type

