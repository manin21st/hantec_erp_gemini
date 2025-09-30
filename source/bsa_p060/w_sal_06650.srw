$PBExportHeader$w_sal_06650.srw
$PBExportComments$수출 제품 이동 의뢰서=======>미사용
forward
global type w_sal_06650 from w_standard_print
end type
end forward

global type w_sal_06650 from w_standard_print
string title = "수출 제품 이동 의뢰서"
long backcolor = 80859087
end type
global w_sal_06650 w_sal_06650

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sFrom,sTo,sTeam,sArea,sCust,sTeamName,sAreaName, sCustName, sPrtGbn

If dw_ip.AcceptText() <> 1 Then Return -1

sFrom       = dw_ip.GetItemString(1,"sdatef")
sTo         = dw_ip.GetItemString(1,"sdatet")
sTeam       = dw_ip.GetItemString(1,"deptcode")
sArea       = dw_ip.GetItemString(1,"areacode")
sCust       = dw_ip.GetItemString(1,"custcode")
sCustName   = dw_ip.GetItemString(1,"custname")
sPrtGbn     = dw_ip.GetItemString(1,"prtgbn")

IF sFrom = "" OR IsNull(sFrom) THEN
	f_message_chk(30,'[할당일자]')
	dw_ip.SetColumn("sdatef")
	dw_ip.SetFocus()
	Return -1
END IF

IF sTeam = "" OR IsNull(sTeam) THEN sTeam = '%'
IF sArea = "" OR IsNull(sArea) THEN sArea = '%'
IF sCust = "" OR IsNull(sCust) THEN sCust = '%'
If sPrtGbn = '' Or IsNull(sPrtGbn) Then sPrtGbn = '0' /* 전체 */

IF dw_list.Retrieve(gs_sabu,sTeam+'%',sArea+'%',sCust+'%',sFrom) <=0 THEN
	f_message_chk(50,'')
   dw_ip.setcolumn('sdatef')
	dw_ip.SetFocus()
	Return -1
End If

dw_list.SetRedraw(False)
IF sTeam ='%' THEN
	dw_list.Modify("txt_team.text = '전 체'")
ELSE
	SELECT "STEAM"."STEAMNM"  	INTO :sTeamName  
	  FROM "STEAM"  
	 WHERE "STEAM"."STEAMCD" = :sTeam   ;

	dw_list.Modify("txt_team.text = '"+sTeamName+"'")
END IF

IF sArea ='%' THEN
	dw_list.Modify("txt_area.text = '전 체'")
ELSE
	SELECT "SAREA"."SAREANM"  	INTO :sAreaName  
	  FROM "SAREA"  
	 WHERE "SAREA"."SAREA" = :sArea   ;

	dw_list.Modify("txt_area.text = '"+sAreaName+"'")
END IF

If IsNull(sCustName) or sCustName = '' then
	dw_list.Modify("txt_cvcod.text = '전체'")
Else
	dw_list.Modify("txt_cvcod.text = '"+sCustName+"'")
End If

Choose Case sPrtGbn
		/* 전체 */
	Case '0'
		dw_list.Modify("txt_prtgbn.text = '(전체)'")
		dw_list.SetFilter('')
		/* 생산할당 */
	Case '1'
		dw_list.Modify("txt_prtgbn.text = '(생산할당)'")
		sPrtGbn = 'Y'
		dw_list.SetFilter('not isnull(auto_iojpno)')
	Case '2'
		/* 재고할당 */
		dw_list.Modify("txt_prtgbn.text = '(재고할당)'")
		sPrtGbn = 'N'
		dw_list.SetFilter('isnull(auto_iojpno)')
End Choose
dw_list.Filter()

dw_list.SetRedraw(True)
Return 1

end function

on w_sal_06650.create
call super::create
end on

on w_sal_06650.destroy
call super::destroy
end on

event open;call super::open;
dw_ip.SetItem(1,"sdatef", is_today)
dw_ip.SetColumn("deptcode")
dw_ip.Setfocus()

/* User별 관할구역 Setting */
String sarea, steam , saupj

If f_check_sarea(sarea, steam, saupj) = 1 Then
	dw_ip.SetItem(1, 'areacode', sarea)
	dw_ip.SetItem(1, 'deptcode', steam)
	dw_ip.Modify("areacode.protect=1")
	dw_ip.Modify("deptcode.protect=1")
	dw_ip.Modify("areacode.background.color = 80859087")
	dw_ip.Modify("deptcode.background.color = 80859087")
End If
end event

type p_preview from w_standard_print`p_preview within w_sal_06650
end type

type p_exit from w_standard_print`p_exit within w_sal_06650
end type

type p_print from w_standard_print`p_print within w_sal_06650
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_06650
end type











type dw_print from w_standard_print`dw_print within w_sal_06650
end type

type dw_ip from w_standard_print`dw_ip within w_sal_06650
integer y = 48
integer width = 745
integer height = 1008
string dataobject = "d_sal_06650_01"
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

event dw_ip::itemchanged;String  sIoCust, sIoCustArea, sIoCustName, sDept, sDeptname
String  sDateFrom, sDateTo, snull, sPrtGbn, sSummary , sCvcod, scvnas, sarea, steam, sSaupj, sName1

SetNull(snull)

Choose Case GetColumnName() 
  Case"sdatef"
	sDateFrom = Trim(this.GetText())
	IF sDateFrom ="" OR IsNull(sDateFrom) THEN RETURN
	
	IF f_datechk(sDateFrom) = -1 THEN
		f_message_chk(35,'[판매기간]')
		this.SetItem(1,"sdatef",snull)
		Return 1
	END IF
 Case "sdatet"
	sDateTo = Trim(this.GetText())
	IF sDateTo ="" OR IsNull(sDateTo) THEN RETURN
	
	IF f_datechk(sDateTo) = -1 THEN
		f_message_chk(35,'[판매기간]')
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
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"custname",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'custcode', sNull)
			SetItem(1, 'custname', snull)
			Return 1
		ELSE		
			SetItem(1,"deptcode",   steam)
			SetItem(1,"custname", scvnas)
			SetItem(1,"areacode",   sarea)
			
		END IF
	/* 거래처명 */
	Case "custname"
		scvnas = Trim(GetText())
		IF scvnas ="" OR IsNull(scvnas) THEN
			SetItem(1,"custcode",snull)
			Return
		END IF
		
		If f_get_cvnames('2', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'custcode', sNull)
			SetItem(1, 'custname', snull)
			Return 1
		ELSE		
			SetItem(1,"deptcode",   steam)
			SetItem(1,'custcode', sCvcod)
			SetItem(1,"custname", scvnas)
			SetItem(1,"areacode",   sarea)
			
			Return 1
		END IF
///* 거래처 */
//Case "custcode"
//	sIoCust = this.GetText()
//	IF sIoCust ="" OR IsNull(sIoCust) THEN
//		this.SetItem(1,"custname",snull)
//		Return
//	END IF
//	
//	SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
//		INTO :sIoCustName,		:sIoCustArea,			:sDept
//	   FROM "VNDMST","SAREA" 
//   	WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :sIoCust   ;
//	IF SQLCA.SQLCODE <> 0 THEN
//		this.TriggerEvent(RbuttonDown!)
//		Return 2
//	ELSE
//		this.SetItem(1,"deptcode",  sDept)
//		this.SetItem(1,"custname",  sIoCustName)
//		this.SetItem(1,"areacode",  sIoCustArea)
//	END IF
///* 거래처명 */
// Case "custname"
//	sIoCustName = Trim(GetText())
//	IF sIoCustName ="" OR IsNull(sIoCustName) THEN
//		this.SetItem(1,"custcode",snull)
//		Return
//	END IF
//	
//	SELECT "VNDMST"."CVCOD", "VNDMST"."CVNAS2","VNDMST"."SAREA","SAREA"."STEAMCD"
//  	  INTO :sIoCust, :sIoCustName, :sIoCustArea,	:sDept
//	  FROM "VNDMST","SAREA" 
//    WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVNAS2" = :sIoCustName;
//	IF SQLCA.SQLCODE <> 0 THEN
//		this.TriggerEvent(RbuttonDown!)
//		Return 2
//	ELSE
//		SetItem(1,"deptcode",  sDept)
//		SetItem(1,"custcode",  sIoCust)
//		SetItem(1,"custname",  sIoCustName)
//		SetItem(1,"areacode",  sIoCustArea)
//		Return
//	END IF
//
END Choose

end event

event dw_ip::rbuttondown;string sIoCustName,sIoCustArea,sDept

SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

Choose Case this.GetColumnName()
	Case "custcode", "custname"
		gs_gubun = '1'
		If GetColumnName() = "custname" then
			gs_codename = Trim(GetText())
		End If
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"custcode",gs_code)
		SetColumn("custcode")
		TriggerEvent(ItemChanged!)
///* 거래처 */
// Case "custcode"
//	gs_gubun = '1'
//	Open(w_agent_popup)
//	
//	IF gs_code ="" OR IsNull(gs_code) THEN RETURN
//	
//	this.SetItem(1,"custcode",gs_code)
//	
//	SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
//		INTO :sIoCustName,		:sIoCustArea,			:sDept
//	   FROM "VNDMST","SAREA" 
//   	WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :gs_code;
//	IF SQLCA.SQLCODE = 0 THEN
//	  this.SetItem(1,"deptcode",  sDept)
//	  this.SetItem(1,"custname",  sIoCustName)
//	  this.SetItem(1,"areacode",  sIoCustArea)
//	END IF
///* 거래처명 */
// Case "custname"
//	gs_gubun = '1'
//	gs_codename = Trim(GetText())
//	Open(w_agent_popup)
//	
//	IF gs_code ="" OR IsNull(gs_code) THEN RETURN
//	
//	this.SetItem(1,"custcode",gs_code)
//	
//	SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
//		INTO :sIoCustName,		:sIoCustArea,			:sDept
//	   FROM "VNDMST","SAREA" 
//   	WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :gs_code;
//	IF SQLCA.SQLCODE = 0 THEN
//	  this.SetItem(1,"deptcode",  sDept)
//	  this.SetItem(1,"custname",  sIoCustName)
//	  this.SetItem(1,"areacode",  sIoCustArea)
//	END IF
END Choose

end event

type dw_list from w_standard_print`dw_list within w_sal_06650
integer x = 823
integer y = 16
integer width = 2811
integer height = 2060
string dataobject = "d_sal_06650"
end type

