$PBExportHeader$w_sal_05630.srw
$PBExportComments$월별 거래처 매출 현황(부가세제외)
forward
global type w_sal_05630 from w_standard_print
end type
type rr_1 from roundrectangle within w_sal_05630
end type
end forward

global type w_sal_05630 from w_standard_print
string title = "월별 거래처 매출 현황"
rr_1 rr_1
end type
global w_sal_05630 w_sal_05630

forward prototypes
public function string wf_aftermonth (string syymm, integer n)
public function integer wf_retrieve ()
end prototypes

public function string wf_aftermonth (string syymm, integer n);string stemp

stemp = f_aftermonth(syymm,n)
stemp = Mid(stemp,1,4) + '~r~n' + Right(stemp,2)

return stemp

end function

public function integer wf_retrieve ();string	syymm,steamcd, sarea, scvcod, stemp, tx_name ,ls_sale_emp

//////////////////////////////////////////////////////////////////
If dw_ip.accepttext() <> 1 Then Return -1

syymm   = trim(dw_ip.getitemstring(1, 'sdatef'))
steamcd = trim(dw_ip.getitemstring(1, 'deptcode'))
sarea   = trim(dw_ip.getitemstring(1, 'areacode'))
scvcod  = trim(dw_ip.getitemstring(1, 'custcode'))
ls_sale_emp = trim(dw_ip.getitemstring(1, 'sale_emp'))

If IsNull(steamcd) Then steamcd = ''
If IsNull(sarea)   Then sarea = ''
If IsNull(scvcod)  Then scvcod = ''
if isnull(ls_sale_emp) then ls_sale_emp = ''

IF	f_datechk(syymm+'01') = -1 then
	MessageBox("확인","기준년월을 확인하세요!")
	dw_ip.setcolumn('sdatef')
	dw_ip.setfocus()
	Return -1
END IF

string ls_silgu

SELECT DATANAME
INTO  :ls_silgu
FROM  SYSCNFG
WHERE SYSGU = 'S' AND SERIAL = '8' AND LINENO = '40' ;

////////////////////////////////////////////////////////////////
dw_print.SetRedraw(False)
if dw_print.retrieve(gs_sabu, syymm, steamcd+'%', sarea+'%', scvcod+'%',ls_sale_emp + '%',ls_silgu) < 1	then
	f_message_chk(50,"")
	dw_ip.setcolumn('areacode')
	dw_ip.setfocus()
	return -1
end if


// title 년월 설정
dw_print.Object.st_m11.text = wf_aftermonth(syymm,-11)
dw_print.Object.st_m10.text = wf_aftermonth(syymm,-10)
dw_print.Object.st_m9.text = wf_aftermonth(syymm,-9)
dw_print.Object.st_m8.text = wf_aftermonth(syymm,-8)
dw_print.Object.st_m7.text = wf_aftermonth(syymm,-7)
dw_print.Object.st_m6.text = wf_aftermonth(syymm,-6)
dw_print.Object.st_m5.text = wf_aftermonth(syymm,-5)
dw_print.Object.st_m4.text = wf_aftermonth(syymm,-4)
dw_print.Object.st_m3.text = wf_aftermonth(syymm,-3)
dw_print.Object.st_m2.text = wf_aftermonth(syymm,-2)
dw_print.Object.st_m1.text = wf_aftermonth(syymm,-1)
dw_print.Object.st_m0.text = wf_aftermonth(syymm,0)

dw_list.Object.st_m11.text = wf_aftermonth(syymm,-11)
dw_list.Object.st_m10.text = wf_aftermonth(syymm,-10)
dw_list.Object.st_m9.text = wf_aftermonth(syymm,-9)
dw_list.Object.st_m8.text = wf_aftermonth(syymm,-8)
dw_list.Object.st_m7.text = wf_aftermonth(syymm,-7)
dw_list.Object.st_m6.text = wf_aftermonth(syymm,-6)
dw_list.Object.st_m5.text = wf_aftermonth(syymm,-5)
dw_list.Object.st_m4.text = wf_aftermonth(syymm,-4)
dw_list.Object.st_m3.text = wf_aftermonth(syymm,-3)
dw_list.Object.st_m2.text = wf_aftermonth(syymm,-2)
dw_list.Object.st_m1.text = wf_aftermonth(syymm,-1)
dw_list.Object.st_m0.text = wf_aftermonth(syymm,0)

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(deptcode) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("txt_steamcd.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(areacode) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("txt_sarea.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(sale_emp) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_sale_emp.text = '"+tx_name+"'")

dw_print.sharedata(dw_print)
dw_print.SetRedraw(True)

Return 1


end function

on w_sal_05630.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_sal_05630.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetItem(1,'sdatef',Left(f_today(),6))

f_child_saupj(dw_ip, 'deptcode', gs_saupj)
f_child_saupj(dw_ip, 'areacode', gs_saupj)

//
//DataWindowChild state_child
//integer rtncode
//
////영업팀
//rtncode 	= dw_ip.GetChild('deptcode', state_child)
//IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 영업팀")
//state_child.SetTransObject(SQLCA)
//state_child.Retrieve(gs_saupj)
//
////관할 구역
//rtncode 	= dw_ip.GetChild('areacode', state_child)
//IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 관할구역")
//state_child.SetTransObject(SQLCA)
//state_child.Retrieve(gs_saupj)
//
////영업 담당자
//rtncode 	= dw_ip.GetChild('sale_emp', state_child)
//IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 영업 담당자")
//state_child.SetTransObject(SQLCA)
//state_child.Retrieve('47',gs_saupj)
//
//
end event

type p_preview from w_standard_print`p_preview within w_sal_05630
end type

type p_exit from w_standard_print`p_exit within w_sal_05630
end type

type p_print from w_standard_print`p_print within w_sal_05630
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_05630
end type







type st_10 from w_standard_print`st_10 within w_sal_05630
end type



type dw_print from w_standard_print`dw_print within w_sal_05630
string dataobject = "d_sal_05630_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_05630
integer x = 78
integer y = 32
integer width = 2816
integer height = 188
string dataobject = "d_sal_05630_01"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;String  sIoCust, sIoCustArea, sIoCustName, sDept, sDeptname
String  sDateFrom, sDateTo, snull, sPrtGbn, sSummary

SetNull(snull)

Choose Case GetColumnName() 
	Case"sdatef"
		sDateFrom = Trim(this.GetText())
		IF sDateFrom ="" OR IsNull(sDateFrom) THEN RETURN
		
		IF f_datechk(sDateFrom+'01') = -1 THEN
			f_message_chk(35,'[매출기준년월]')
			this.SetItem(1,"sdatef",snull)
			Return 1
		END IF
	/* 영업팀 */
	Case "deptcode"
		SetItem(1,'areacode',sNull)
		SetItem(1,"custcode",sNull)
		SetItem(1,"custname",sNull)
	/* 관할구역 */
	Case "areacode"
		SetItem(1,"custcode",sNull)
		SetItem(1,"custname",sNull)
		
		sIoCustArea = this.GetText()
		IF sIoCustArea = "" OR IsNull(sIoCustArea) THEN RETURN
		
		SELECT "SAREA"."SAREA" ,"SAREA"."STEAMCD" 	INTO :sIoCustArea  ,:sDept
		  FROM "SAREA"  
		 WHERE "SAREA"."SAREA" = :sIoCustArea   ;
		
		SetItem(1,'deptcode',sDept)
	/* 거래처 */
	Case "custcode"
		sIoCust = this.GetText()
		IF sIoCust ="" OR IsNull(sIoCust) THEN
			this.SetItem(1,"custname",snull)
			Return
		END IF
		
		SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
		  INTO :sIoCustName,		:sIoCustArea,			:sDept
		  FROM "VNDMST","SAREA" 
		 WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :sIoCust   ;
		IF SQLCA.SQLCODE <> 0 THEN
			this.TriggerEvent(RbuttonDown!)
			Return 2
		ELSE
			this.SetItem(1,"deptcode",  sDept)
			this.SetItem(1,"custname",  sIoCustName)
			this.SetItem(1,"areacode",  sIoCustArea)
		END IF
	/* 거래처명 */
	Case "custname"
		sIoCustName = Trim(GetText())
		IF sIoCustName ="" OR IsNull(sIoCustName) THEN
			this.SetItem(1,"custcode",snull)
			Return
		END IF
		
		SELECT "VNDMST"."CVCOD", "VNDMST"."CVNAS2","VNDMST"."SAREA","SAREA"."STEAMCD"
		  INTO :sIoCust, :sIoCustName, :sIoCustArea,	:sDept
		  FROM "VNDMST","SAREA" 
		 WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVNAS2" = :sIoCustName;
		IF SQLCA.SQLCODE <> 0 THEN
			this.TriggerEvent(RbuttonDown!)
			Return 2
		ELSE
			SetItem(1,"deptcode",  sDept)
			SetItem(1,"custcode",  sIoCust)
			SetItem(1,"custname",  sIoCustName)
			SetItem(1,"areacode",  sIoCustArea)
			Return
		END IF
END Choose
end event

event dw_ip::rbuttondown;string sIoCustName,sIoCustArea,sDept

SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

Choose Case this.GetColumnName() 
	/* 거래처 */
	Case "custcode"
		gs_gubun = '1'
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		this.SetItem(1,"custcode",gs_code)
		
		SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
		  INTO :sIoCustName,		:sIoCustArea,			:sDept
		  FROM "VNDMST","SAREA" 
		 WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :gs_code;
		IF SQLCA.SQLCODE = 0 THEN
			this.SetItem(1,"deptcode",  sDept)
			this.SetItem(1,"custname",  sIoCustName)
			this.SetItem(1,"areacode",  sIoCustArea)
		END IF
	/* 거래처명 */
	Case "custname"
		gs_gubun = '1'
		gs_codename = Trim(GetText())
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		this.SetItem(1,"custcode",gs_code)
		
		SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
		  INTO :sIoCustName,		:sIoCustArea,			:sDept
		  FROM "VNDMST","SAREA" 
		 WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :gs_code;
		IF SQLCA.SQLCODE = 0 THEN
			this.SetItem(1,"deptcode",  sDept)
			this.SetItem(1,"custname",  sIoCustName)
			this.SetItem(1,"areacode",  sIoCustArea)
		END IF
END Choose

end event

type dw_list from w_standard_print`dw_list within w_sal_05630
integer x = 91
integer y = 252
integer width = 4498
integer height = 2044
string dataobject = "d_sal_05630"
boolean border = false
boolean hsplitscroll = false
end type

event dw_list::retrievestart;This.SetRedraw(False)
end event

event dw_list::retrieveend;This.SetRedraw(True)
end event

type rr_1 from roundrectangle within w_sal_05630
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 78
integer y = 244
integer width = 4530
integer height = 2064
integer cornerheight = 40
integer cornerwidth = 55
end type

