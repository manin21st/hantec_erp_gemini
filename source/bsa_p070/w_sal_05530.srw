$PBExportHeader$w_sal_05530.srw
$PBExportComments$거래처별 매출 현항(요약)
forward
global type w_sal_05530 from w_standard_print
end type
type pb_1 from u_pb_cal within w_sal_05530
end type
type pb_2 from u_pb_cal within w_sal_05530
end type
type rr_1 from roundrectangle within w_sal_05530
end type
end forward

global type w_sal_05530 from w_standard_print
string title = "거래처별 매출 현항(요약)"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_sal_05530 w_sal_05530

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sFrom,sTo,sTeam,sArea,sCust,sTeamName,sAreaName, sPrtgb, sSaupj, tx_name, sPacprc, tx_name1

If dw_ip.AcceptText() <> 1 Then Return -1

sFrom       = dw_ip.GetItemString(1,"sdatef")
sTo         = dw_ip.GetItemString(1,"sdatet")
sArea       = Trim(dw_ip.GetItemString(1,"areacode"))
sCust       = Trim(dw_ip.GetItemString(1,"custcode"))
sPrtgb      = Trim(dw_ip.GetItemString(1,"prtgb"))
sSaupj      = Trim(dw_ip.GetItemString(1,"saupj"))
sPacprc     = Trim(dw_ip.GetItemString(1,"pacprc"))

If IsNull(sArea) or sArea = '' then sArea = ''
If IsNull(sCust) or sCust = '' then sCust = ''
If IsNull(sPrtgb) or sPrtgb = '' then sCust = '1'
If IsNull(sPacprc) or sPacprc = '' then sPacprc = 'N'

dw_ip.SetFocus()
IF sSaupj = "" OR IsNull(sSaupj) THEN
	f_message_chk(30,'[부가사업장]')
	dw_ip.SetColumn("saupj")
	Return -1
END IF

IF sFrom = "" OR IsNull(sFrom) THEN
	f_message_chk(30,'[기간]')
	dw_ip.SetColumn("sdatef")
	Return -1
END IF

IF sTo = "" OR IsNull(sTo) THEN
	f_message_chk(30,'[기간]')
	dw_ip.SetColumn("sdatet")
	Return -1
END IF

//IF dw_list.Retrieve(gs_sabu, sFrom, sTo, sArea+'%', sCust+'%', sPrtgb, sSaupj) <=0 THEN
//	f_message_chk(50,'')
//   dw_ip.setcolumn('sdatef')
//	Return -1
//End If

IF dw_print.Retrieve(gs_sabu, sFrom, sTo, sArea+'%', sCust+'%', sPrtgb, sSaupj, spacprc) <=0 THEN
	f_message_chk(50,'')
   dw_ip.setcolumn('sdatef')
	Return -1
End If

tx_name1 = ' '
if sPacprc = 'Y' then
	tx_name1 = '[금액구분:상각비 제외]'
End if

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(saupj) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_list.Modify("tx_saupj.text = '"+tx_name+"'")
dw_print.Modify("tx_saupj.text = '"+tx_name+"'")
dw_print.Modify("tx_pacprc.text = '"+tx_name1+"'")

Return 1
end function

on w_sal_05530.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.rr_1
end on

on w_sal_05530.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetItem(1,"sdatef", Left(is_today,6)+'01')
dw_ip.SetItem(1,"sdatet", is_today)

f_mod_saupj(dw_ip, 'saupj')


end event

type p_preview from w_standard_print`p_preview within w_sal_05530
end type

type p_exit from w_standard_print`p_exit within w_sal_05530
end type

type p_print from w_standard_print`p_print within w_sal_05530
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_05530
end type











type dw_print from w_standard_print`dw_print within w_sal_05530
string dataobject = "d_sal_05530_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_05530
integer x = 23
integer y = 32
integer width = 3913
integer height = 212
string dataobject = "d_sal_05530_01"
end type

event dw_ip::itemerror;
Return 1
end event

event dw_ip::itemfocuschanged;
IF this.GetColumnName() = "custname" OR this.GetColumnName() ='deptname'THEN
	f_toggle_kor(Handle(this))
ELSE
	f_toggle_eng(Handle(this))
END IF
end event

event dw_ip::itemchanged;String  sIoCust, sIoCustArea, sIoCustName, sDept, sDeptname ,ls_gubun
String  sDateFrom, sDateTo, snull, sPrtGbn, sSummary

SetNull(snull)

Choose Case GetColumnName() 
  Case"sdatef"
	sDateFrom = Trim(this.GetText())
	IF sDateFrom ="" OR IsNull(sDateFrom) THEN RETURN
	
	IF f_datechk(sDateFrom) = -1 THEN
		f_message_chk(35,'[발행기간]')
		this.SetItem(1,"sdatef",snull)
		Return 1
	END IF
 Case "sdatet"
	sDateTo = Trim(this.GetText())
	IF sDateTo ="" OR IsNull(sDateTo) THEN RETURN
	
	IF f_datechk(sDateTo) = -1 THEN
		f_message_chk(35,'[발행기간]')
		this.SetItem(1,"sdatet",snull)
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
 Case 'gubun'
	ls_gubun = this.gettext()
	
	dw_list.setredraw(false)
	if ls_gubun = '1' then
		dw_list.dataobject = 'd_sal_05530'
		dw_print.DataObject = 'd_sal_05530_p'
	else
		dw_list.dataobject = 'd_sal_05530_02'
		dw_print.DataObject = 'd_sal_05530_02_p'
	end if
	dw_list.settransobject(sqlca)
	dw_print.settransobject(sqlca)
	dw_print.ShareData(dw_list)
	p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
	p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'
	p_preview.Enabled = False
	p_print.Enabled = False
	dw_list.setredraw(true)
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

type dw_list from w_standard_print`dw_list within w_sal_05530
integer y = 272
integer width = 4585
integer height = 2024
string dataobject = "d_sal_05530"
boolean border = false
boolean hsplitscroll = false
end type

type pb_1 from u_pb_cal within w_sal_05530
integer x = 1614
integer y = 52
integer height = 80
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('sdatef')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'sdatef', gs_code)

end event

type pb_2 from u_pb_cal within w_sal_05530
integer x = 2112
integer y = 52
integer height = 80
integer taborder = 70
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('sdatet')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'sdatet', gs_code)

end event

type rr_1 from roundrectangle within w_sal_05530
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 264
integer width = 4613
integer height = 2044
integer cornerheight = 40
integer cornerwidth = 55
end type

