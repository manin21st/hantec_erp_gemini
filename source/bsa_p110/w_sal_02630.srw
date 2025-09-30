$PBExportHeader$w_sal_02630.srw
$PBExportComments$월 출하율 현황
forward
global type w_sal_02630 from w_standard_print
end type
type rr_1 from roundrectangle within w_sal_02630
end type
end forward

global type w_sal_02630 from w_standard_print
string title = "월 출하율 현황"
rr_1 rr_1
end type
global w_sal_02630 w_sal_02630

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string sIoDate, s_steamcd, s_sarea, s_cvcod, sPrtGbn
string s_get_cvcod 

If dw_ip.accepttext() <> 1 Then Return -1

sIoDate  = dw_ip.getitemstring(1,"sdate")
s_steamcd = dw_ip.getitemstring(1,"deptcode")
s_sarea   = dw_ip.getitemstring(1,"areacode")
s_cvcod  = dw_ip.getitemstring(1,"custcode")
sPrtGbn  = dw_ip.getitemstring(1,"prtgbn")

If IsNull(s_steamcd) then s_steamcd = ''
If IsNull(s_sarea) then s_sarea = ''
If IsNull(s_cvcod) then s_cvcod = ''
If IsNull(sPrtgbn) Then sPrtGbn = '0'
////필수입력항목 체크///////////////////////////////////
if f_datechk(sIoDate) <> 1 then
	f_message_chk(30,'[기준일자]')
	dw_ip.setfocus()
	return -1
end if


IF dw_print.retrieve(sIoDate, s_steamcd+'%',s_sarea+'%', s_cvcod+'%', sPrtGbn+'%') <= 0 THEN
   f_message_chk(50,'[거래처할인율 현황]')
	dw_ip.setfocus()
//	cb_print.Enabled =False
	SetPointer(Arrow!)
	Return -1
else
	dw_print.sharedata(dw_list)
END IF

/* 출력조건 */
If sPrtGbn = '0' Then // 전체 
	dw_print.SetFilter('')
Else
	dw_print.SetFilter("cvstatus = '1'")
End If

dw_print.Filter()

return 1
end function

on w_sal_02630.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_sal_02630.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.setfocus()
dw_ip.setitem(1,'sdate',left(f_today(),8))

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

type p_preview from w_standard_print`p_preview within w_sal_02630
integer x = 4073
boolean originalsize = true
string picturename = "c:\erpman\image\미리보기_up.gif"
end type

type p_exit from w_standard_print`p_exit within w_sal_02630
integer x = 4421
boolean originalsize = true
string picturename = "c:\erpman\image\닫기_up.gif"
end type

type p_print from w_standard_print`p_print within w_sal_02630
integer x = 4247
boolean originalsize = true
string picturename = "c:\erpman\image\인쇄_up.gif"
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_02630
integer x = 3899
boolean originalsize = true
string picturename = "c:\erpman\image\조회_up.gif"
end type







type st_10 from w_standard_print`st_10 within w_sal_02630
end type



type dw_print from w_standard_print`dw_print within w_sal_02630
string dataobject = "d_sal_02630_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_02630
integer y = 24
integer width = 3735
integer height = 228
string dataobject = "d_sal_02630_01"
end type

event dw_ip::itemchanged;String  sIoCust,sIoCustArea,sIoCustName,sDept,snull,sIoJpno,sIoconfirm,sIoDate,sInsDat
string  sCvcod, scvnas, sarea, steam, sSaupj, sName1

SetNull(snull)

Choose Case GetColumnName() 
/* 기준일자 */
 Case "sdate"
	sIoDate = Trim(this.GetText())
	IF sIoDate ="" OR IsNull(sIoDate) THEN RETURN
	
	IF f_datechk(sIoDate) = -1 THEN
		f_message_chk(35,'[기준일자]')
		this.SetItem(1,"sdate",snull)
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
//	Case "custcode"
//		gs_gubun = '1'
//		Open(w_agent_popup)
//		
//		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
//		
//		this.SetItem(1,"custcode",gs_code)
//		
//		SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
//		  INTO :sIoCustName,		:sIoCustArea,			:sDept
//		  FROM "VNDMST","SAREA" 
//		 WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :gs_code;
//		IF SQLCA.SQLCODE = 0 THEN
//		  this.SetItem(1,"deptcode",  sDept)
//		  this.SetItem(1,"custname",  sIoCustName)
//		  this.SetItem(1,"areacode",  sIoCustArea)
//		END IF
//	Case "custname"
//		gs_codename = Trim(GetText())
//		gs_gubun = '1'
//		Open(w_agent_popup)
//		
//		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
//		
//		this.SetItem(1,"custcode",gs_code)
//		
//		SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
//			INTO :sIoCustName,		:sIoCustArea,			:sDept
//			FROM "VNDMST","SAREA" 
//			WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :gs_code;
//		IF SQLCA.SQLCODE = 0 THEN
//		  this.SetItem(1,"deptcode",  sDept)
//		  this.SetItem(1,"custname",  sIoCustName)
//		  this.SetItem(1,"areacode",  sIoCustArea)
//		END IF
END Choose

end event

type dw_list from w_standard_print`dw_list within w_sal_02630
integer x = 55
integer y = 264
integer width = 4521
integer height = 2032
string dataobject = "d_sal_02630_02"
boolean border = false
end type

type rr_1 from roundrectangle within w_sal_02630
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 256
integer width = 4549
integer height = 2052
integer cornerheight = 40
integer cornerwidth = 55
end type

