$PBExportHeader$w_sal_05840.srw
$PBExportComments$이벤트 행사 현황
forward
global type w_sal_05840 from w_standard_print
end type
type rr_1 from roundrectangle within w_sal_05840
end type
end forward

global type w_sal_05840 from w_standard_print
string title = "이벤트 행사 현황"
rr_1 rr_1
end type
global w_sal_05840 w_sal_05840

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sYear, sEventNo, sTeam, sArea, sCust, tx_name, sPrtGbn

If dw_ip.AcceptText() <> 1 Then Return -1

sYear  = Trim(dw_ip.GetItemString(1,"sdatef"))
sTeam  = Trim(dw_ip.GetItemString(1,"deptcode"))
sArea  = Trim(dw_ip.GetItemString(1,"areacode"))
sCust  = Trim(dw_ip.GetItemString(1,"custcode"))
sPrtgbn = Trim(dw_ip.GetItemString(1,"prtgbn"))

If IsNull(sTeam) Then sTeam = ''
If IsNull(sArea) Then sArea = ''
If IsNull(sCust) Then sCust = ''

IF sYear = "" OR IsNull(sYear) THEN
	f_message_chk(30,'[기준년도]')
	dw_ip.SetColumn("sdatef")
	dw_ip.SetFocus()
	Return -1
END IF

IF dw_print.Retrieve(gs_sabu, sYear, sEventNo+'%', sTeam+'%', sArea+'%', sCust+'%') <=0 THEN
	f_message_chk(50,'')
   dw_ip.setcolumn('sdatef')
	dw_ip.SetFocus()
	Return -1
ELSE
	dw_print.sharedata(dw_list)
End If

/* 진행여부에 따라 */
Choose Case sPrtGbn
	Case '1'                 // 완료배제
		dw_print.SetFilter("end_date < '" + is_today + "'" )
	Case '2'                 // 완료포함
		dw_print.SetFilter("" )
End Choose
dw_print.Filter()
		
tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(deptcode) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("txt_steamcd.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(areacode) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("txt_sarea.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.GetitemString(1,'custname'))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("txt_cvcod.text = '"+tx_name+"'")

Return 1

end function

on w_sal_05840.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_sal_05840.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetItem(1,"sdatef", Left(is_today,6)+'01')

dw_ip.Setfocus()

/* User별 관할구역 Setting */
String sarea, steam , saupj

If f_check_sarea(sarea, steam, saupj) = 1 Then
   dw_ip.Modify("areacode.protect=1")
	dw_ip.Modify("deptcode.protect=1")
	dw_ip.Modify("areacode.background.color = 80859087")
	dw_ip.Modify("deptcode.background.color = 80859087")
End If
dw_ip.SetItem(1, 'areacode', sarea)
dw_ip.SetItem(1, 'deptcode', steam)
end event

type p_preview from w_standard_print`p_preview within w_sal_05840
end type

type p_exit from w_standard_print`p_exit within w_sal_05840
end type

type p_print from w_standard_print`p_print within w_sal_05840
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_05840
end type











type dw_print from w_standard_print`dw_print within w_sal_05840
string dataobject = "d_sal_05840_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_05840
integer y = 24
integer width = 2610
integer height = 308
string dataobject = "d_sal_058401"
end type

event dw_ip::itemerror;
Return 1
end event

event dw_ip::itemchanged;String  sIoCust,sIoCustArea,sIoCustName,sDept,sDeptname,sDateFrom,sDateTo,sPrtGbn,snull
string  sCvcod, scvnas, sarea, steam, sSaupj, sName1

SetNull(snull)

Choose Case GetColumnName() 
	Case "sdatef"
		sDateFrom = Trim(this.GetText())
		IF sDateFrom ="" OR IsNull(sDateFrom) THEN RETURN
		
		IF f_datechk(sDateFrom) = -1 THEN
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
//	/* 거래처 or 부서*/
//	Case "custcode"
//		sIoCust = Trim(GetText())
//		IF sIoCust ="" OR IsNull(sIoCust) THEN
//			this.SetItem(1,"custname",snull)
//			Return
//		END IF
//		
//		SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
//		  INTO :sIoCustName,		:sIoCustArea,			:sDept
//		  FROM "VNDMST","SAREA" 
//		 WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :sIoCust;
//		
//		IF SQLCA.SQLCODE <> 0 THEN
//			this.TriggerEvent(RbuttonDown!)
//			Return 2
//		ELSE
//			this.SetItem(1,"deptcode",  sDept)
//			this.SetItem(1,"custname",  sIoCustName)
//			this.SetItem(1,"areacode",  sIoCustArea)
//		END IF
//	/* 거래처명 */
//	Case "custname"
//		sIoCustName = Trim(GetText())
//		IF sIoCustName ="" OR IsNull(sIoCustName) THEN
//			this.SetItem(1,"custcode",snull)
//			Return
//		END IF
//		
//		SELECT "VNDMST"."CVCOD", "VNDMST"."CVNAS2","VNDMST"."SAREA","SAREA"."STEAMCD"
//		  INTO :sIoCust, :sIoCustName, :sIoCustArea,	:sDept
//		  FROM "VNDMST","SAREA" 
//		 WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVNAS2" = :sIoCustName;
//		
//		IF SQLCA.SQLCODE <> 0 THEN
//			this.TriggerEvent(RbuttonDown!)
//			Return 2
//		ELSE
//			SetItem(1,"deptcode",  sDept)
//			SetItem(1,"custcode",  sIoCust)
//			SetItem(1,"custname",  sIoCustName)
//			SetItem(1,"areacode",  sIoCustArea)
//			Return
//		END IF
	Case 'prtgbn'
		/* 진행여부에 따라 */
		Choose Case GetText()
			Case '1'                 // 완료배제
				dw_list.SetFilter("end_date < '" + is_today + "'" )
			Case '2'                 // 완료포함
				dw_list.SetFilter("" )
		End Choose
		dw_list.Filter()
END Choose

end event

event dw_ip::rbuttondown;string sIoCustName, sIoCustArea,	sDept,sNull

SetNull(sNull)
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
// Case "custcode","custname"
//	  gs_gubun = '1'
//		If GetColumnName() = "custname" then
//			gs_codename = Trim(GetText())
//		End If
//	  Open(w_agent_popup)
//	
//	  IF gs_code ="" OR IsNull(gs_code) THEN RETURN
//	
//	  this.SetItem(1,"custcode",gs_code)
//	
//	  SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
//	    INTO :sIoCustName,		:sIoCustArea,			:sDept
//	    FROM "VNDMST","SAREA" 
//     WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :gs_code;
//		
//	  IF SQLCA.SQLCODE = 0 THEN
//	    this.SetItem(1,"deptcode",  sDept)
//	    this.SetItem(1,"custname",  sIoCustName)
//	    this.SetItem(1,"areacode",  sIoCustArea)
//	  END IF
END Choose

end event

type dw_list from w_standard_print`dw_list within w_sal_05840
integer x = 50
integer y = 360
integer width = 4544
integer height = 1944
string dataobject = "d_sal_05840"
boolean border = false
end type

type rr_1 from roundrectangle within w_sal_05840
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 352
integer width = 4567
integer height = 1960
integer cornerheight = 40
integer cornerwidth = 55
end type

