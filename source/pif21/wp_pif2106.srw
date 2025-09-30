$PBExportHeader$wp_pif2106.srw
$PBExportComments$** 동호회 명단(사용)
forward
global type wp_pif2106 from w_standard_print
end type
type rr_2 from roundrectangle within wp_pif2106
end type
end forward

global type wp_pif2106 from w_standard_print
integer x = 0
integer y = 0
string title = "동호회 명단"
rr_2 rr_2
end type
global wp_pif2106 wp_pif2106

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_code1, ls_code2, ls_gubun

dw_ip.AcceptText()

ls_gubun = dw_ip.GetItemString(1,"cgubun")
CHOOSE CASE(ls_gubun)
	CASE '1'
		dw_list.Dataobject = "dp_pif2106"
		dw_print.dataobject="dp_pif2106_p"
	CASE '2'
		dw_list.Dataobject = "dp_pif2106_1"
		dw_print.dataobject="dp_pif2106_1_p"
	CASE '3'
		dw_list.Dataobject = "dp_pif2106_2"
		dw_print.dataobject="dp_pif2106_2_p"
	CASE '4'
		dw_list.Dataobject = "dp_pif2106_4"
		dw_print.dataobject="dp_pif2106_4_p"
END CHOOSE

dw_list.SetTransobject(sqlca)
dw_print.settransobject(sqlca)


ls_code1 = dw_ip.GetItemString(1,"codefrom")
ls_code2 = dw_ip.GetItemString(1,"codeto")

IF ls_code1 = ""  AND ls_code2 <> "" THEN
   messagebox("동호회", "동호회 입력 범위가 부정확합니다.!", information!)
	return -1
END IF
IF ls_code2 = ""  AND ls_code1 <> "" THEN
   messagebox("동호회", "동호회 입력 범위가 부정확합니다.!", information!)
	return -1
END IF

IF ls_code1 > ls_code2 then
	messagebox("동호회", "동호회 입력 범위가 부정확합니다.!", information!)
	return -1
END IF

if isnull(ls_code1) or ls_code1 = '' then ls_code1 = ' '
if isnull(ls_code2) or ls_code2 = '' then ls_code2 = 'ZZ'

if dw_print.retrieve(ls_code1, ls_code2) < 1 then
	messagebox("자료 확인", "해당 자료가 없습니다.!", stopsign!)
	return -1
end if
dw_print.sharedata(dw_list)
//cb_print.enabled = true
//
///* Last page 구하는 routine */
//long Li_row = 1, Ll_prev_row
//
//dw_list.setredraw(false)
//dw_list.object.datawindow.print.preview="yes"
//
//gi_page = 1
//
//do while true
//	ll_prev_row = Li_row
//	Li_row = dw_list.ScrollNextPage()
//	If Li_row = ll_prev_row or Li_row <= 0 then
//		exit
//	Else
//		gi_page++
//	End if
//loop
//
//dw_list.scrolltorow(1)
//dw_list.setredraw(true)
//
setpointer(arrow!)
return 1
end function

on wp_pif2106.create
int iCurrent
call super::create
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
end on

on wp_pif2106.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_2)
end on

event open;call super::open;dw_list.settransobject(sqlca)

dw_ip.SetItem(1,"cgubun",'1')
end event

type p_preview from w_standard_print`p_preview within wp_pif2106
integer x = 4082
integer y = 20
string pointer = ""
end type

type p_exit from w_standard_print`p_exit within wp_pif2106
integer x = 4430
integer y = 20
string pointer = ""
end type

type p_print from w_standard_print`p_print within wp_pif2106
integer x = 4256
integer y = 20
string pointer = ""
end type

type p_retrieve from w_standard_print`p_retrieve within wp_pif2106
integer x = 3909
integer y = 20
string pointer = ""
end type

type st_window from w_standard_print`st_window within wp_pif2106
integer y = 4000
end type

type sle_msg from w_standard_print`sle_msg within wp_pif2106
integer y = 4000
end type

type dw_datetime from w_standard_print`dw_datetime within wp_pif2106
integer y = 4000
end type

type st_10 from w_standard_print`st_10 within wp_pif2106
integer y = 4000
end type

type gb_10 from w_standard_print`gb_10 within wp_pif2106
integer y = 4000
end type

type dw_print from w_standard_print`dw_print within wp_pif2106
string dataobject = "dp_pif2106_p"
end type

type dw_ip from w_standard_print`dw_ip within wp_pif2106
integer x = 91
integer width = 1989
integer taborder = 70
string dataobject = "dp_pif2106_3"
end type

event dw_ip::itemchanged;String sCode, sName, SetNull, sColName1, sColName2

AcceptText()
sColName1 = GetColumnName()

IF sColName1 = "codefrom" or sColName1 = "codeto" THEN
	
	IF sColName1 = "codefrom" THEN sColName2 = "namefrom"
	IF sColName1 = "codeto" THEN sColName2 = "nameto"
	
	sCode = GetItemString(1,sColName1)

	IF sCode = "" OR ISNULL(sCode) THEN
		SetItem(1,sColName2,"")
		Return 1
	ELSE
  		SELECT "P0_CIRCLE"."CIRCLENAME"  
	    INTO :sName 
		 FROM "P0_CIRCLE"  
	   WHERE "P0_CIRCLE"."CIRCLECODE" = :sCode ;   
   	IF SQLCA.SQLCODE <> 0  THEN
			 MessageBox("확인" ,"동호회코드를 확인하세요") 
		    SetItem(1,sColName1,"")
			 SetItem(1,sColName2,"")
			 Return 1
		END IF
		    SetItem(1,sColName2,sName) 
	END IF

END IF

IF sColName1 = "namefrom" or sColName1 = "nameto" THEN
	
	IF sColName1 = "namefrom" THEN sColName2 = "codefrom"
	IF sColName1 = "nameto" THEN sColName2 = "codeto"
	
	sName = GetItemString(1,sColName1)

	IF sName = "" OR ISNULL(sName) THEN
		SetItem(1,sColName2,"")
		Return 1
	ELSE
  		SELECT "P0_CIRCLE"."CIRCLECODE"  
	    INTO :sCode
		 FROM "P0_CIRCLE"  
	   WHERE "P0_CIRCLE"."CIRCLENAME" = :sName ;   
   	IF SQLCA.SQLCODE <> 0  THEN
			 MessageBox("확인" ,"동호회명을 확인하세요") 
		    SetItem(1,sColName1,"")
			 SetItem(1,sColName2,"")
			 Return 1
		END IF
		    SetItem(1,sColName2,sCode) 
	END IF

END IF
end event

event dw_ip::rbuttondown;call super::rbuttondown;String sColName1, sColName2

SetNull(Gs_code)
SetNull(Gs_codename)

AcceptText()
sColName1 = GetColumnName()

IF sColName1 = "namefrom" or sColName1 = "nameto" THEN

	IF sColName1 = "namefrom" THEN sColName2 = "codefrom"
	IF sColName1 = "nameto" THEN sColName2 = "codeto"

	Gs_Codename = GetItemString(this.GetRow(),sColName1)
	
	open(w_circle_popup)
	
	IF IsNull(Gs_code) THEN RETURN

	SetItem(this.GetRow(),sColName1,Gs_codeName)	
	SetItem(this.GetRow(),sColName2,Gs_code)
	Return 1
END IF


IF sColName1 = "codefrom" or sColName1 = "codeto" THEN
	
	IF sColName1 = "codefrom" THEN sColName2 = "namefrom"
	IF sColName1 = "codeto" THEN sColName2 = "nameto"	

	Gs_Code = this.GetItemString(this.GetRow(),sColName1)
	
	open(w_circle_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	SetItem(this.GetRow(),sColName1,Gs_code)
	SetItem(this.GetRow(),sColName2,Gs_codeName)
	Return 1
END IF
end event

event dw_ip::itemerror;call super::itemerror;Return 1
end event

type dw_list from w_standard_print`dw_list within wp_pif2106
integer x = 119
integer width = 4393
integer height = 2020
string dataobject = "dp_pif2106"
boolean border = false
end type

type rr_2 from roundrectangle within wp_pif2106
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 96
integer y = 288
integer width = 4439
integer height = 2044
integer cornerheight = 40
integer cornerwidth = 55
end type

