$PBExportHeader$w_sal_02685.srw
$PBExportComments$특출 거래처 등록 현황
forward
global type w_sal_02685 from w_standard_print
end type
type rr_1 from roundrectangle within w_sal_02685
end type
end forward

global type w_sal_02685 from w_standard_print
string title = "특출 거래처 등록 현황"
rr_1 rr_1
end type
global w_sal_02685 w_sal_02685

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string sSarea, sCvcod, sStatus, sPrtgbn, tx_name

If dw_ip.accepttext() <> 1 Then Return -1

sSarea  = dw_ip.getitemstring(1,"areacode")
sCvcod  = dw_ip.getitemstring(1,"custcode")
sStatus = dw_ip.getitemstring(1,"status")
sPrtgbn = dw_ip.getitemstring(1,"prtgbn")

If IsNull(sCvcod) then sCvcod = ''

If IsNull(sSarea) Then sSarea = '' 


dw_print.SetFilter('')
dw_print.Filter()

IF dw_print.retrieve(gs_sabu, sSarea+'%', sCvcod+'%') <= 0 THEN
  f_message_chk(50,'[특출 거래처 등록 현황]')
	Return -1
else
	dw_print.sharedata(dw_list)
END IF

/* 진행여부에 따라 */
Choose Case sStatus
	Case '0'
		dw_print.SetFilter("spcvndd_end_date >= '" + is_today + "'" )
	Case '1'
		dw_print.SetFilter("spcvndd_end_date < '" + is_today + "'" )
	Case '2'
		dw_print.SetFilter("")
End Choose
dw_print.Filter()

If sPrtGbn = '2' Then
	tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(areacode) ', 1)"))
	If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
	dw_print.Modify("txt_sarea.text = '"+tx_name+"'")
	
	tx_name = Trim(dw_ip.GetItemString(1,'custname'))
	If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
	dw_print.Modify("txt_cvcod.text = '"+tx_name+"'")
End If

return 1

end function

on w_sal_02685.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_sal_02685.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.setfocus()

/* User별 관할구역 Setting */
String sarea, steam , saupj

If f_check_sarea(sarea, steam, saupj) = 1 Then
   dw_ip.Modify("areacode.protect=1")
	dw_ip.Modify("areacode.background.color = 80859087")
End If
dw_ip.SetItem(1, 'areacode', sarea)
end event

type p_preview from w_standard_print`p_preview within w_sal_02685
integer x = 4078
end type

type p_exit from w_standard_print`p_exit within w_sal_02685
integer x = 4425
end type

type p_print from w_standard_print`p_print within w_sal_02685
integer x = 4251
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_02685
integer x = 3904
end type







type st_10 from w_standard_print`st_10 within w_sal_02685
end type



type dw_print from w_standard_print`dw_print within w_sal_02685
string dataobject = "d_sal_026851_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_02685
integer y = 24
integer width = 3511
integer height = 212
string dataobject = "d_sal_026851_01"
end type

event dw_ip::itemchanged;String  sIoCust,sIoCustArea,sIoCustName,sDept,snull,sIoJpno,sIoconfirm,sIoDate,sInsDat
String sPrtGbn , sCvcod, scvnas, sarea, steam, sSaupj, sName1

SetNull(snull)

Choose Case GetColumnName() 
	/* 관할구역 */
	Case "areacode"
		SetItem(1,"custcode",sNull)
		SetItem(1,"custname",sNull)
		
		sIoCustArea = this.GetText()
		IF sIoCustArea = "" OR IsNull(sIoCustArea) THEN RETURN
		
		SELECT "SAREA"."SAREA" ,"SAREA"."STEAMCD" 	INTO :sIoCustArea  ,:sDept
			FROM "SAREA"  
			WHERE "SAREA"."SAREA" = :sIoCustArea   ;
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
			SetItem(1,'custcode', sCvcod)
			SetItem(1,"custname", scvnas)
			SetItem(1,"areacode",   sarea)
			Return 1
		END IF
//	/* 거래처 */
//	Case "custcode"
//		sIoCust = this.GetText()
//		IF sIoCust ="" OR IsNull(sIoCust) THEN
//			this.SetItem(1,"custname",snull)
//			Return
//		END IF
//		
//		SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
//			INTO :sIoCustName,		:sIoCustArea,			:sDept
//			FROM "VNDMST","SAREA" 
//			WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :sIoCust   ;
//		IF SQLCA.SQLCODE <> 0 THEN
//			this.TriggerEvent(RbuttonDown!)
//			Return 2
//		ELSE
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
//		IF SQLCA.SQLCODE <> 0 THEN
//			this.TriggerEvent(RbuttonDown!)
//			Return 2
//		ELSE
//			SetItem(1,"custcode",  sIoCust)
//			SetItem(1,"custname",  sIoCustName)
//			SetItem(1,"areacode",  sIoCustArea)
//			Return
//		END IF
	/* 자료구분 */
	Case 'prtgbn'
		sPrtGbn = GetText()
		
//		dw_list.SetRedraw(False)
		IF sPrtGbn = '1' THEN
			dw_list.DataObject = 'd_sal_026851'
			dw_print.DataObject = 'd_sal_026851_p'
		ELSEIF sPrtGbn = '2' THEN
			dw_list.DataObject = 'd_sal_026852'
			dw_print.DataObject = 'd_sal_026852_p'
		END IF
		dw_print.SetTransObject(SQLCA)
		dw_list.SetTransObject(SQLCA)
//		dw_list.SetRedraw(True)
END Choose

end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;string sIoCustName,sIoCustArea,sDept,siojpno,siocust,sIoDate,sInsDat
Long nRow

SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

nRow = GetRow()
If nRow <= 0 Then Return

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

//Case "custcode"
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
//	  this.SetItem(1,"custname",  sIoCustName)
//	  this.SetItem(1,"areacode",  sIoCustArea)
//	END IF
//Case "custname"
//	gs_codename = Trim(GetText())
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
//	  this.SetItem(1,"custname",  sIoCustName)
//	  this.SetItem(1,"areacode",  sIoCustArea)
//	END IF
END Choose

end event

type dw_list from w_standard_print`dw_list within w_sal_02685
integer x = 50
integer y = 252
integer width = 4526
integer height = 2064
string dataobject = "d_sal_026851"
boolean border = false
end type

type rr_1 from roundrectangle within w_sal_02685
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 248
integer width = 4558
integer height = 2080
integer cornerheight = 40
integer cornerwidth = 55
end type

