$PBExportHeader$w_sal_t_10010.srw
$PBExportComments$년 업체별 매출 현황
forward
global type w_sal_t_10010 from w_standard_print
end type
type dw_list1 from dw_list within w_sal_t_10010
end type
type rr_1 from roundrectangle within w_sal_t_10010
end type
type rr_2 from roundrectangle within w_sal_t_10010
end type
end forward

global type w_sal_t_10010 from w_standard_print
string title = "년 거래처 매출 현황"
dw_list1 dw_list1
rr_1 rr_1
rr_2 rr_2
end type
global w_sal_t_10010 w_sal_t_10010

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
scvcod  = trim(dw_ip.getitemstring(1, 'custcode'))

If IsNull(steamcd) Then steamcd = ''
If IsNull(scvcod)  Then scvcod = ''

IF	f_datechk(syymm + '01'+'01') = -1 then
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

dw_print.SetRedraw(False)

if dw_print.retrieve(gs_sabu, syymm, scvcod+'%',ls_silgu) < 1	then
	f_message_chk(50,"")
	dw_ip.setcolumn('custcode')
	dw_ip.setfocus()
	return -1
end if

dw_list1.retrieve(gs_sabu, syymm, scvcod+'%', ls_silgu )

dw_print.SetRedraw(True)

dw_print.sharedata(dw_list)

Return 1
end function

on w_sal_t_10010.create
int iCurrent
call super::create
this.dw_list1=create dw_list1
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list1
this.Control[iCurrent+2]=this.rr_1
this.Control[iCurrent+3]=this.rr_2
end on

on w_sal_t_10010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_list1)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_ip.SetItem(1,'sdatef',Left(f_today(),4))
dw_list1.settransobject(sqlca)
end event

type p_preview from w_standard_print`p_preview within w_sal_t_10010
end type

type p_exit from w_standard_print`p_exit within w_sal_t_10010
end type

type p_print from w_standard_print`p_print within w_sal_t_10010
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_t_10010
end type







type st_10 from w_standard_print`st_10 within w_sal_t_10010
end type



type dw_print from w_standard_print`dw_print within w_sal_t_10010
string dataobject = "d_sal_t_10010_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_t_10010
integer x = 78
integer y = 32
integer width = 2816
integer height = 140
string dataobject = "d_sal_t_10010_h"
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
		
		IF f_datechk(sDateFrom+'01'+'01') = -1 THEN
			f_message_chk(35,'[매출기준년월]')
			this.SetItem(1,"sdatef",snull)
			Return 1
		END IF
	Case "custcode"
		sIoCust = this.GetText()
		IF sIoCust ="" OR IsNull(sIoCust) THEN
			this.SetItem(1,"custname",snull)
			Return
		END IF
		
		SELECT "VNDMST"."CVNAS2"
		  INTO :sIoCustName
		  FROM "VNDMST"
		 WHERE "VNDMST"."CVCOD" = :sIoCust   ;
		IF SQLCA.SQLCODE <> 0 THEN
			this.TriggerEvent(RbuttonDown!)
			Return 2
		ELSE
			this.SetItem(1,"custcode",  sDept)
			this.SetItem(1,"custname",  sIoCustName)
		END IF
	/* 거래처명 */
	Case "custname"
		sIoCustName = Trim(GetText())
		IF sIoCustName ="" OR IsNull(sIoCustName) THEN
			this.SetItem(1,"custcode",snull)
			Return
		END IF
		
		SELECT "VNDMST"."CVCOD", "VNDMST"."CVNAS2"
		  INTO :sIoCust, :sIoCustName
		  FROM "VNDMST"
		 WHERE "VNDMST"."CVNAS2" = :sIoCustName;
		IF SQLCA.SQLCODE <> 0 THEN
			this.TriggerEvent(RbuttonDown!)
			Return 2
		ELSE
			SetItem(1,"custcode",  sIoCust)
			SetItem(1,"custname",  sIoCustName)
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
		this.SetItem(1,"custname", gs_codename)
		
	/* 거래처명 */
	Case "custname"
		gs_gubun = '1'
		gs_codename = Trim(GetText())
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		this.SetItem(1,"custcode", gs_code)
		this.SetItem(1,"custname", gs_codename)
END Choose

end event

type dw_list from w_standard_print`dw_list within w_sal_t_10010
integer x = 91
integer y = 188
integer width = 4498
integer height = 1244
string dataobject = "d_sal_t_10010_d"
boolean border = false
boolean hsplitscroll = false
end type

event dw_list::retrievestart;This.SetRedraw(False)
end event

event dw_list::retrieveend;This.SetRedraw(True)
end event

type dw_list1 from dw_list within w_sal_t_10010
integer y = 1472
integer height = 808
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_sal_t_10010_d1"
end type

type rr_1 from roundrectangle within w_sal_t_10010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 78
integer y = 184
integer width = 4530
integer height = 1260
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_sal_t_10010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 78
integer y = 1464
integer width = 4530
integer height = 832
integer cornerheight = 40
integer cornerwidth = 55
end type

