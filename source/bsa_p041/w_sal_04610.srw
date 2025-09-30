$PBExportHeader$w_sal_04610.srw
$PBExportComments$이자지급보류 거래처 현황
forward
global type w_sal_04610 from w_standard_print
end type
end forward

global type w_sal_04610 from w_standard_print
string title = "이자지급보류 거래처 현황"
long backcolor = 79741120
end type
global w_sal_04610 w_sal_04610

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sFrom, sTeam,sArea,sCust,sTeamName,sAreaName, sCustName

If dw_ip.AcceptText() <> 1 Then Return -1

sFrom       = dw_ip.GetItemString(1,"sdatef")
sTeam       = dw_ip.GetItemString(1,"deptcode")
sArea       = dw_ip.GetItemString(1,"areacode")
sCust       = dw_ip.GetItemString(1,"custcode")
sCustName   = dw_ip.GetItemString(1,"custname")

IF sFrom = "" OR IsNull(sFrom) or f_datechk(sFrom+'01') <> 1 THEN
	f_message_chk(30,'[기준년월]')
	dw_ip.SetColumn("sdatef")
	dw_ip.SetFocus()
	Return -1
END IF

IF sTeam = "" OR IsNull(sTeam) THEN sTeam = ''
IF sArea = "" OR IsNull(sArea) THEN sArea = ''
IF sCust = "" OR IsNull(sCust) THEN sCust = ''

IF dw_list.Retrieve(sFrom, sTeam+'%',sArea+'%',sCust+'%') <=0 THEN
	f_message_chk(50,'')
   dw_ip.setcolumn('sdatef')
	dw_ip.SetFocus()
	Return -1
End If

IF sTeam ='' THEN
	sTeamName = '전 체'
Else
	sTeamName = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(deptcode) ', 1)"))
End If

IF sArea ='' THEN
	sAreaName = '전 체'
Else
	sAreaName = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(areacode) ', 1)"))
End If

dw_list.Modify("tx_steam.text = '"+sTeamName+"'")
dw_list.Modify("tx_sarea.text = '"+sAreaName+"'")

Return 1
end function

on w_sal_04610.create
call super::create
end on

on w_sal_04610.destroy
call super::destroy
end on

event open;call super::open;/* User별 관할구역 Setting */
String sarea, steam, saupj

If f_check_sarea(sarea, steam, saupj) = 1 Then
	dw_ip.Modify("areacode.protect=1")
	dw_ip.Modify("areacode.background.color = 80859087")
	dw_ip.Modify("deptcode.protect=1")
	dw_ip.Modify("deptcode.background.color = 80859087")
End If
dw_ip.SetItem(1, "deptcode", steam)
dw_ip.SetItem(1, "areacode", sarea)

dw_ip.SetItem(1,"sdatef", Left(is_today,6))

dw_ip.SetColumn("sdatef")
dw_ip.Setfocus()

end event

type p_preview from w_standard_print`p_preview within w_sal_04610
end type

type p_exit from w_standard_print`p_exit within w_sal_04610
string picturename = "c:\erpman\image\닫기_up.gif"
end type

type p_print from w_standard_print`p_print within w_sal_04610
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_04610
end type











type dw_print from w_standard_print`dw_print within w_sal_04610
end type

type dw_ip from w_standard_print`dw_ip within w_sal_04610
integer y = 124
integer width = 745
integer height = 740
string dataobject = "d_sal_04610_01"
end type

event dw_ip::itemerror;
Return 1
end event

event dw_ip::itemchanged;String  sDateFrom, sDateTo, snull, sPrtGbn, sSummary
String  sarea, steam, sCvcod, scvnas, sSaupj, sName1

SetNull(snull)

Choose Case GetColumnName() 
  Case"sdatef"
	sDateFrom = Trim(this.GetText())
	IF sDateFrom ="" OR IsNull(sDateFrom) THEN RETURN
	
	IF f_datechk(sDateFrom+'01') = -1 THEN
		f_message_chk(35,'[기준년월]')
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

	sarea = this.GetText()
	IF sarea = "" OR IsNull(sarea) THEN RETURN
	
	SELECT "areacode"."areacode" ,"areacode"."STEAMCD" 	INTO :sarea  ,:steam
	  FROM "areacode"  
	 WHERE "areacode"."areacode" = :sarea   ;
		
   SetItem(1,'deptcode',steam)
	/* 거래처 */
	Case "custcode"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"custname",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, "custcode", sNull)
			SetItem(1, "custname", snull)
			Return 1
		ELSE
			SetItem(1,"deptcode",   steam)
			SetItem(1,"areacode",   sarea)
			SetItem(1,"custname",	scvnas)
		END IF
	/* 거래처명 */
	Case "custname"
		scvnas = Trim(GetText())
		IF scvnas ="" OR IsNull(scvnas) THEN
			SetItem(1,"custcode",snull)
			Return
		END IF
		
		If f_get_cvnames('2', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, "custcode", sNull)
			SetItem(1, "custname", snull)
			Return 1
		ELSE
			SetItem(1,"deptcode",   steam)
			SetItem(1,"areacode",   sarea)
			SetItem(1,"custcode", sCvcod)
			SetItem(1,"custname", scvnas)
			Return 1
		END IF
END Choose
end event

event dw_ip::rbuttondown;SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

Choose Case this.GetColumnName() 
	/* 거래처 */
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
END Choose

end event

type dw_list from w_standard_print`dw_list within w_sal_04610
integer x = 823
integer y = 16
integer width = 2811
integer height = 2060
string dataobject = "d_sal_04610"
end type

