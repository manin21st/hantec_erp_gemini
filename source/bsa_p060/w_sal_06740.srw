$PBExportHeader$w_sal_06740.srw
$PBExportComments$거래처별 매출현황(수출)
forward
global type w_sal_06740 from w_standard_print
end type
type pb_1 from u_pb_cal within w_sal_06740
end type
type pb_2 from u_pb_cal within w_sal_06740
end type
type rr_1 from roundrectangle within w_sal_06740
end type
end forward

global type w_sal_06740 from w_standard_print
string title = "거래처별 매출현황(수출)"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_sal_06740 w_sal_06740

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string s_cvcod, s_datef,s_datet, sdeptcode, sareacode

If dw_ip.accepttext() <> 1 Then Return -1

s_datef = dw_ip.getitemstring(1,"sdatef")
s_datet = dw_ip.getitemstring(1,"sdatet")
s_cvcod = dw_ip.getitemstring(1,"custcode")
sdeptcode = dw_ip.getitemstring(1,"deptcode")
sareacode = dw_ip.getitemstring(1,"areacode")

//필수입력항목 체크///////////////////////////////////
if f_datechk(s_datef) <> 1 Or f_datechk(s_datet) <> 1 then
	f_message_chk(30,'[매출기간]')
	dw_ip.setfocus()
	return -1
end if

If IsNull(s_cvcod ) Then s_cvcod = ''
If IsNull(sdeptcode ) Then sdeptcode = ''
If IsNull(sareacode ) Then sareacode = ''

IF dw_print.retrieve(gs_sabu, s_datef, s_datet, s_cvcod+'%') <= 0 THEN
   f_message_chk(50,'[거래처별 매출원장]')
	dw_ip.setfocus()
	SetPointer(Arrow!)
	Return -1
END IF

dw_print.ShareData(dw_list)

Return 0

//조회////////////////////////////////////////////////
//IF dw_list.retrieve(gs_sabu, s_datef, s_datet, s_cvcod+'%') <= 0 THEN
//   f_message_chk(50,'[거래처별 매출원장]')
//	dw_ip.setfocus()
////	cb_print.Enabled =False
//	SetPointer(Arrow!)
//	Return -1
//END IF
//
//Return 0
end function

on w_sal_06740.create
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

on w_sal_06740.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetItem(1,"sdatef", Left(is_today,6)+'01')
dw_ip.SetItem(1,"sdatet", is_today)
end event

type p_preview from w_standard_print`p_preview within w_sal_06740
end type

type p_exit from w_standard_print`p_exit within w_sal_06740
end type

type p_print from w_standard_print`p_print within w_sal_06740
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_06740
end type







type st_10 from w_standard_print`st_10 within w_sal_06740
end type



type dw_print from w_standard_print`dw_print within w_sal_06740
string dataobject = "d_sal_06740_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_06740
integer x = 18
integer y = 12
integer width = 2505
integer height = 140
string dataobject = "d_sal_067401"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;String  sIoCust, sIoCustArea, sIoCustName, sDept, sDeptname
String  sDateFrom, sDateTo, snull, sPrtGbn , sCvcod, scvnas, sarea, steam, sSaupj, sName1

SetNull(snull)

Choose Case GetColumnName() 
	Case"sdatef"
		sDateFrom = Trim(this.GetText())
		IF sDateFrom ="" OR IsNull(sDateFrom) THEN RETURN
		
		IF f_datechk(sDateFrom) = -1 THEN
			f_message_chk(35,'[매출기간]')
			this.SetItem(1,"sdatef",snull)
			Return 1
		END IF
	Case "sdatet"
		sDateTo = Trim(this.GetText())
		IF sDateTo ="" OR IsNull(sDateTo) THEN RETURN
		
		IF f_datechk(sDateTo) = -1 THEN
			f_message_chk(35,'[매출기간]')
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
//	/* 거래처 */
//	Case "custcode"
//		sIoCust = this.GetText()
//		IF sIoCust ="" OR IsNull(sIoCust) THEN
//			this.SetItem(1,"custname",snull)
//			Return
//		END IF
//		
//		SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
//		  INTO :sIoCustName,		:sIoCustArea,			:sDept
//		  FROM "VNDMST","SAREA" 
//		 WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :sIoCust   ;
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
//	/* 거래처 */
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
//			this.SetItem(1,"deptcode",  sDept)
//			this.SetItem(1,"custname",  sIoCustName)
//			this.SetItem(1,"areacode",  sIoCustArea)
//		END IF
//	/* 거래처명 */
//	Case "custname"
//		gs_gubun = '1'
//		gs_codename = Trim(GetText())
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
//			this.SetItem(1,"deptcode",  sDept)
//			this.SetItem(1,"custname",  sIoCustName)
//			this.SetItem(1,"areacode",  sIoCustArea)
//		END IF
END Choose

end event

type dw_list from w_standard_print`dw_list within w_sal_06740
integer y = 192
integer width = 4571
integer height = 2140
string dataobject = "d_sal_06740"
boolean border = false
end type

type pb_1 from u_pb_cal within w_sal_06740
integer x = 672
integer y = 36
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

type pb_2 from u_pb_cal within w_sal_06740
integer x = 1152
integer y = 36
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

type rr_1 from roundrectangle within w_sal_06740
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 184
integer width = 4603
integer height = 2164
integer cornerheight = 40
integer cornerwidth = 55
end type

