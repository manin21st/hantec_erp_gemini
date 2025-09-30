$PBExportHeader$w_sal_04535.srw
$PBExportComments$거래처별 수금 회전일 현황
forward
global type w_sal_04535 from w_standard_print
end type
type dw_rate from datawindow within w_sal_04535
end type
type rr_1 from roundrectangle within w_sal_04535
end type
end forward

global type w_sal_04535 from w_standard_print
string title = "거래처별 수금 회전일 현황"
dw_rate dw_rate
rr_1 rr_1
end type
global w_sal_04535 w_sal_04535

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string sCvcod, sDatef, sdeptcode, sareacode, sInvControl, tx_name, sMisugu
Double dDcRate, dSugumRate, dFromRate, dDcRateSub
Long   ix, iy

If dw_ip.accepttext() <> 1 Then Return -1

sDatef = dw_ip.getitemstring(1,"sdatef")
sCvcod = dw_ip.getitemstring(1,"custcode")
sdeptcode = dw_ip.getitemstring(1,"deptcode")
sareacode = dw_ip.getitemstring(1,"areacode")

sMisuGu = Trim(dw_ip.GetItemString(1,'misugu'))

//필수입력항목 체크///////////////////////////////////
If f_datechk(sDatef+'01') <> 1  then
	f_message_chk(30,'[기준년월]')
	dw_ip.setfocus()
	return -1
end if

If IsNull(sCvcod ) Then sCvcod = ''
If IsNull(sdeptcode ) Then sdeptcode = ''
If IsNull(sareacode ) Then sareacode = ''

string ls_silgu

SELECT DATANAME
INTO   :ls_silgu
FROM   SYSCNFG
WHERE  SYSGU = 'S'   AND
       SERIAL = '8'  AND
       LINENO = '40' ;

//조회////////////////////////////////////////////////string ls_silgu
//IF dw_list.retrieve(gs_sabu, sDatef, sdeptcode+'%',sareacode+'%',sCvcod+'%', sMisugu,ls_silgu) <= 0 THEN
//   f_message_chk(50,'[거래처별 수금 회전일 현황]')
//	dw_ip.setfocus()
//	SetPointer(Arrow!)
//	Return -1
//END IF
//
//tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(deptcode) ', 1)"))
//If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_list.Modify("txt_steamcd.text = '"+tx_name+"'")
//
//tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(areacode) ', 1)"))
//If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_list.Modify("txt_sarea.text = '"+tx_name+"'")
//

IF dw_print.retrieve(gs_sabu, sDatef, sdeptcode+'%',sareacode+'%',sCvcod+'%', sMisugu,ls_silgu) <= 0 THEN
   f_message_chk(50,'[거래처별 수금 회전일 현황]')
	dw_ip.setfocus()
	SetPointer(Arrow!)
	Return -1
END IF

dw_print.ShareData(dw_list)

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(deptcode) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("txt_steamcd.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(areacode) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("txt_sarea.text = '"+tx_name+"'")

/* 수금율에 의한 적용 기준 */
select max(start_date) into :sDatef
  from dcmodify
 where start_date <= :is_today;

If IsNull(sDatef) or sqlca.sqlcode <> 0 Then Return 0

dw_rate.Retrieve(sDatef)

/* 대표품목의 기본 할인율 */
select nvl(dc_rate,0) into :dDcRate
  from itgrdc
 where salegu = '1' and  ittyp = '1' and  itcls = '01' and
       start_date = ( select max(start_date)
							  from itgrdc
							 where salegu = '1' and	 ittyp = '1' and itcls = '01' and
									 start_date <= :is_today );

If IsNull(dDcRate) or sqlca.sqlcode <> 0 Then dDcRate = 0.0

For ix = 1 To dw_list.RowCount()
	dSugumRate = dw_list.GetItemNumber(ix, 'sugum_rate')
	dSugumRate = Truncate(dSugumRate*100,1)
	
	dDcRateSub = 0
	sInvControl = 'N'
	For iy = 1 To dw_rate.RowCount()
		dFromRate = dw_rate.GetItemNumber(iy,'sugum_rate_from')

		If dFromRate <= dSugumRate Then
			dDcRateSub = dw_rate.GetItemNumber(iy,'dc_rate_sub')
			sInvControl = dw_rate.GetItemString(iy,'inv_control')
			Exit
		End If
	Next
	
	dw_list.SetItem(ix, 'rate', (dDcRate + dDcRateSub)/100 )
	dw_list.SetItem(ix, 'inv_control', sInvControl)
Next


Return 0

end function

on w_sal_04535.create
int iCurrent
call super::create
this.dw_rate=create dw_rate
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_rate
this.Control[iCurrent+2]=this.rr_1
end on

on w_sal_04535.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_rate)
destroy(this.rr_1)
end on

event open;call super::open;dw_rate.SetTransObject(sqlca)

/* User별 관할구역 Setting */
String sarea, steam, saupj

If f_check_sarea(sarea, steam, saupj) = 1 Then
	dw_ip.SetItem(1, "areacode", sarea)
	dw_ip.Modify("areacode.protect=1")
	dw_ip.Modify("areacode.background.color = 80859087")
	dw_ip.SetItem(1, "deptcode", sarea)
	dw_ip.Modify("deptcode.protect=1")
	dw_ip.Modify("deptcode.background.color = 80859087")
End If

dw_ip.SetItem(1,"sdatef", Left(is_today,6))
end event

type p_preview from w_standard_print`p_preview within w_sal_04535
integer x = 4064
end type

type p_exit from w_standard_print`p_exit within w_sal_04535
integer x = 4411
end type

type p_print from w_standard_print`p_print within w_sal_04535
integer x = 4238
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_04535
integer x = 3890
end type







type st_10 from w_standard_print`st_10 within w_sal_04535
end type



type dw_print from w_standard_print`dw_print within w_sal_04535
string dataobject = "d_sal_04535_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_04535
integer y = 32
integer width = 2501
integer height = 248
string dataobject = "d_sal_04535_01"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;String  sarea, steam, sCvcod, scvnas, sSaupj, sName1
String  sDateFrom, sDateTo, snull, sPrtGbn, sSummary

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
		
		SELECT "SAREA"."SAREA" ,"SAREA"."STEAMCD" 	INTO :sarea  ,:steam
		  FROM "SAREA"  
		 WHERE "SAREA"."SAREA" = :sarea   ;
		
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

type dw_list from w_standard_print`dw_list within w_sal_04535
integer x = 59
integer width = 4512
integer height = 1996
string dataobject = "d_sal_04535"
boolean border = false
boolean hsplitscroll = false
end type

type dw_rate from datawindow within w_sal_04535
boolean visible = false
integer x = 613
integer y = 2408
integer width = 2231
integer height = 360
integer taborder = 70
boolean bringtotop = true
string dataobject = "d_sal_02090_02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rr_1 from roundrectangle within w_sal_04535
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 292
integer width = 4544
integer height = 2016
integer cornerheight = 40
integer cornerwidth = 55
end type

