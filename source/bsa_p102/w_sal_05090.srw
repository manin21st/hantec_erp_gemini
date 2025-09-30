$PBExportHeader$w_sal_05090.srw
$PBExportComments$월별 거래처별 매출 및 수금 현황
forward
global type w_sal_05090 from w_standard_print
end type
type rr_1 from roundrectangle within w_sal_05090
end type
type rr_3 from roundrectangle within w_sal_05090
end type
end forward

global type w_sal_05090 from w_standard_print
string title = "월별 거래처별 매출 및 수금 현황"
rr_1 rr_1
rr_3 rr_3
end type
global w_sal_05090 w_sal_05090

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string	fr_yymm, sdept, sarea,cvcod, tx_name

//////////////////////////////////////////////////////////////////
If dw_ip.accepttext() <> 1 Then Return -1

fr_yymm  = trim(dw_ip.getitemstring(1, 'sdatef'))
sdept = trim(dw_ip.getitemstring(1, 'deptcode'))
sarea = trim(dw_ip.getitemstring(1, 'areacode'))
cvcod = trim(dw_ip.getitemstring(1, 'custcode'))

If IsNull(sdept)  Then sdept = ''
If IsNull(sarea)  Then sarea = ''
If IsNull(cvcod)  Then cvcod = ''

////////////////////////////////////////////////////// 기간 유효성 check
IF	f_datechk(fr_yymm+'0101') = -1 then
	MessageBox("확인","기준년도을 확인하세요!")
	dw_ip.setcolumn('sdatef')
	dw_ip.setfocus()
	Return -1
END IF

////////////////////////////////////////////////////////////////
SetPointer(HourGlass!)
dw_print.SetRedraw(False)

string ls_silgu

SELECT DATANAME
INTO  :ls_silgu
FROM  SYSCNFG
WHERE SYSGU = 'S' AND SERIAL = '8' AND LINENO = '40' ;

if dw_print.retrieve(gs_sabu, fr_yymm, sdept+'%', sarea+'%',cvcod+'%',ls_silgu) < 1	then
	f_message_chk(50,"")
	dw_ip.setcolumn('areacode')
	dw_ip.setfocus()
	return -1
end if
dw_print.sharedata(dw_list)

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(deptcode) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_list.Modify("txt_steamcd.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(areacode) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_list.Modify("txt_sarea.text = '"+tx_name+"'")

dw_print.SetRedraw(True)

Return 1

end function

on w_sal_05090.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.rr_3
end on

on w_sal_05090.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.rr_3)
end on

event open;call super::open;string syymm

syymm = Left(f_today(),4)
dw_ip.SetItem(1,'sdatef',syymm)

f_child_saupj(dw_ip, 'deptcode', gs_saupj)
f_child_saupj(dw_ip, 'areacode', gs_saupj)


end event

type p_preview from w_standard_print`p_preview within w_sal_05090
end type

type p_exit from w_standard_print`p_exit within w_sal_05090
end type

type p_print from w_standard_print`p_print within w_sal_05090
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_05090
end type







type st_10 from w_standard_print`st_10 within w_sal_05090
end type



type dw_print from w_standard_print`dw_print within w_sal_05090
string dataobject = "d_sal_05090_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_05090
integer x = 91
integer y = 60
integer width = 3040
integer height = 248
string dataobject = "d_sal_05090_01"
end type

event dw_ip::rbuttondown;string sIoCustName, sIoCustArea,	sDept,sNull

SetNull(sNull)
SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

Choose Case this.GetColumnName() 
 Case "custcode","custname"
	  gs_gubun = '1'
		If GetColumnName() = "custname" then
			gs_codename = Trim(GetText())
		End If
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

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;String  sIoCust,sIoCustArea,sIoCustName,sDept,sDeptname,sDateFrom,sDateTo,sPrtGbn,snull

SetNull(snull)

Choose Case GetColumnName() 
	Case "sdatef"
		sDateFrom = Trim(this.GetText())
		IF sDateFrom ="" OR IsNull(sDateFrom) THEN RETURN
		
		IF f_datechk(sDateFrom+'0101') = -1 THEN
		f_message_chk(35,'[기준년도]')
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
	sIoCust = Trim(GetText())
	IF sIoCust ="" OR IsNull(sIoCust) THEN
		this.SetItem(1,"custname",snull)
		Return
	END IF
	
   SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
	  INTO :sIoCustName,		:sIoCustArea,			:sDept
	  FROM "VNDMST","SAREA" 
    WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :sIoCust;
	
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

type dw_list from w_standard_print`dw_list within w_sal_05090
integer x = 119
integer y = 408
integer width = 4443
integer height = 1860
string dataobject = "d_sal_05090"
boolean border = false
end type

event dw_list::retrievestart;This.SetRedraw(False)
end event

event dw_list::retrieveend;This.SetRedraw(True)
end event

type rr_1 from roundrectangle within w_sal_05090
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33551600
integer x = 78
integer y = 52
integer width = 3086
integer height = 280
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_sal_05090
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 73
integer y = 368
integer width = 4526
integer height = 1944
integer cornerheight = 40
integer cornerwidth = 55
end type

