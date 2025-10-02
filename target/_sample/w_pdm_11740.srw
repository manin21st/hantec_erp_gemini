$PBExportHeader$w_pdm_11740.srw
$PBExportComments$일력현황
forward
global type w_pdm_11740 from w_standard_print
end type
type pb_1 from u_pic_cal within w_pdm_11740
end type
type pb_2 from u_pic_cal within w_pdm_11740
end type
end forward

global type w_pdm_11740 from w_standard_print
string title = "일력현황 출력"
pb_1 pb_1
pb_2 pb_2
end type
global w_pdm_11740 w_pdm_11740

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();// 변경일자
string	sStart, sEnd
sStart = dw_ip.GetItemString(1, "sdate")
sEnd   = dw_ip.GetItemString(1, "edate")

IF IsNull(sStart) or Trim(sStart) = ''		THEN	sStart = '0'
IF IsNull(sEnd) or Trim(sEnd) = ''			THEN	sEnd = '99999999'


//
if dw_print.Retrieve(sStart, sEnd) <= 0 then
	f_message_chk(50,'[일력현황]')
	dw_ip.Setfocus()
	return -1
end if

dw_print.sharedata(dw_list)

return 1

end function

on w_pdm_11740.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
end on

on w_pdm_11740.destroy
call super::destroy
destroy(this.pb_1)
destroy(this.pb_2)
end on

event open;call super::open;String scd_max,scd_min,sgu_max,sgu_min,snamef,snamet

string	sToday, sDate
sToday = f_Today()
sDate = Left(sToday,6) + '01'
dw_ip.SetItem(1,"sdate", sDate )
dw_ip.SetItem(1,"edate", sToday)

dw_ip.Setfocus()

end event

type dw_list from w_standard_print`dw_list within w_pdm_11740
integer y = 248
integer height = 1964
string dataobject = "d_pdm_11741"
boolean hsplitscroll = false
end type

type cb_print from w_standard_print`cb_print within w_pdm_11740
end type

type cb_excel from w_standard_print`cb_excel within w_pdm_11740
end type

type cb_preview from w_standard_print`cb_preview within w_pdm_11740
end type

type cb_1 from w_standard_print`cb_1 within w_pdm_11740
end type

type dw_print from w_standard_print`dw_print within w_pdm_11740
integer x = 3749
integer y = 40
string dataobject = "d_pdm_11741_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdm_11740
integer y = 56
integer height = 144
string dataobject = "d_pdm_11740"
end type

event itemchanged;String snamef,snamet, ssort_gu,scode
Int il_Count

IF this.GetColumnName() = "scvcod" OR this.GetColumnName() ="ecvcod" THEN
	scode = this.GetText()
	
	IF scode ="" OR IsNull(scode) THEN Return 
	
	SELECT "VNDMST"."CVNAS2"		INTO :snamef
		FROM "VNDMST"  
		WHERE ("VNDMST"."SABU" = '1') AND ("VNDMST"."CVCOD" =:scode) ;
	IF SQLCA.SQLCODE = 0 THEN				
		IF this.GetColumnName() ="scvcod" THEN
			dw_ip.SetItem(1,"snamef",snamef)
			dw_ip.SetColumn("ecvcod")
			dw_ip.SetFocus()
		ELSEIF this.GetColumnName() ="ecvcod" THEN
			dw_ip.SetItem(1,"snamet",snamef)
			dw_ip.SetColumn("sort_gu")
			dw_ip.SetFocus()
		END IF
	ELSE
		this.TriggerEvent(RbuttonDown!)
		Return 1
//		IF this.GetColumnName() ="scvcod" THEN
//			dw_ip.SetItem(1,"snamef",snamef)
//		ELSEIF this.GetColumnName() ="ecvcod" THEN
//			dw_ip.SetItem(1,"snamet",snamef)
//		END IF
	END IF
END IF

IF this.GetColumnName() = "sort_gu" THEN 
	
	ssort_gu = this.GetText()
	
	dw_list.SetRedraw(False)
	IF ssort_gu ="1" THEN
		dw_list.SetSort("vndmst_cvgu A,vndmst_cvcod A")
	ELSE
		dw_list.SetSort("vndmst_cvgu A,vndmst_cvnas A")
	END IF
	dw_list.Sort()
	dw_list.SetRedraw(True)
END IF
end event

event rbuttondown;
SetNull(gs_code)
SetNull(gs_codename)

IF this.GetColumnName() <> "scvcod" AND this.GetColumnName() <> "ecvcod" THEN RETURN

gs_gubun =""

IF this.GetColumnName() ="scvcod" THEN
	gs_code =dw_ip.GetItemString(1,"scvcod")
ELSE
	gs_code =dw_ip.GetItemString(1,"ecvcod")
END IF

OPEN(W_VNDMST_POPUP)

IF this.GetColumnName() ="scvcod" THEN
	dw_ip.SetItem(1,"scvcod",gs_code)
	dw_ip.SetItem(1,"snamef",gs_codename)
ELSE
	dw_ip.SetItem(1,"ecvcod",gs_code)
	dw_ip.SetItem(1,"snamet",gs_codename)
END IF

dw_ip.SetFocus()


end event

event dw_ip::ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemerror;
Return 1
end event

type r_1 from w_standard_print`r_1 within w_pdm_11740
integer y = 244
end type

type r_2 from w_standard_print`r_2 within w_pdm_11740
integer height = 152
end type

type pb_1 from u_pic_cal within w_pdm_11740
integer x = 608
integer y = 88
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('sdate')
IF Isnull(gs_code) THEN Return
dw_ip.SetItem(dw_ip.getrow(), 'sdate', gs_code)
end event

type pb_2 from u_pic_cal within w_pdm_11740
integer x = 1061
integer y = 88
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('edate')
IF Isnull(gs_code) THEN Return
dw_ip.SetItem(dw_ip.getrow(), 'edate', gs_code)
end event

