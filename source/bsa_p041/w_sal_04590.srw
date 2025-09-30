$PBExportHeader$w_sal_04590.srw
$PBExportComments$월 수금이자분 정산 내역서
forward
global type w_sal_04590 from w_standard_print
end type
type rr_1 from roundrectangle within w_sal_04590
end type
end forward

global type w_sal_04590 from w_standard_print
string title = "월 수금이자분 정산 내역서"
rr_1 rr_1
end type
global w_sal_04590 w_sal_04590

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String  sYear, sMonth, sArea, sCvCod, sYm, sYyMm
String  sym1, sym2, sym3, sym4, sym5, sym6, sym7, sym8, sym9
Integer iMonth

dw_ip.AcceptText()

sYear = Trim(dw_ip.GetItemString(1,'syy'))
sMonth = Trim(dw_ip.GetItemString(1,'smm'))
sArea = Trim(dw_ip.GetItemString(1,'areacode'))
sCvCod = Trim(dw_ip.GetItemString(1,'custcode'))

if	(sYear='') or isNull(sYear) then
	f_Message_Chk(35, '[기준년도]')
	dw_ip.setcolumn('syy')
	dw_ip.setfocus()
	Return -1
END IF

if	(sMonth='') or isNull(sMonth) then
	f_Message_Chk(35, '[기준월]')
	dw_ip.setcolumn('smm')
	dw_ip.setfocus()
	Return -1
END IF

If isNull(sArea) or sArea = '00' Then sArea = ''
If isNull(sCvCod) or sCvCod = '' Then sCvCod = ''

sYyMm = sYear + '년 ' + sMonth + '월'
dw_list.object.r_ym.Text = sYyMm

// 기준월
sym = sYear + sMonth

If dw_list.Retrieve(gs_sabu,sYm,sarea+'%',sCvCod+'%') < 1 then
	f_message_Chk(300, '[출력조건 CHECK]')
	dw_ip.setcolumn('syy')
	dw_ip.setfocus()
	return -1
End If

Return 1

/* 야금사용안함 */
//// 기준월 - 1
//iMonth = Integer(sMonth) - 1
//if iMonth = 0 then
//	iMonth = 12
//	sYear = String(Integer(sYear) - 1)
//end if
//sMonth = Mid('0' + String(iMonth), Len(String(iMonth)), 2)
//sym1 = sYear + sMonth
//// 기준월 - 2
//iMonth = Integer(sMonth) - 1
//if iMonth = 0 then
//	iMonth = 12
//	sYear = String(Integer(sYear) - 1)
//end if
//sMonth = Mid('0' + String(iMonth), Len(String(iMonth)), 2)
//sym2 = sYear + sMonth
//// 기준월 - 3
//iMonth = Integer(sMonth) - 1
//if iMonth = 0 then
//	iMonth = 12
//	sYear = String(Integer(sYear) - 1)
//end if
//sMonth = Mid('0' + String(iMonth), Len(String(iMonth)), 2)
//sym3 = sYear + sMonth
//// 기준월 - 4
//iMonth = Integer(sMonth) - 1
//if iMonth = 0 then
//	iMonth = 12
//	sYear = String(Integer(sYear) - 1)
//end if
//sMonth = Mid('0' + String(iMonth), Len(String(iMonth)), 2)
//sym4 = sYear + sMonth
//// 기준월 - 5
//iMonth = Integer(sMonth) - 1
//if iMonth = 0 then
//	iMonth = 12
//	sYear = String(Integer(sYear) - 1)
//end if
//sMonth = Mid('0' + String(iMonth), Len(String(iMonth)), 2)
//sym5 = sYear + sMonth
//// 기준월 - 6
//iMonth = Integer(sMonth) - 1
//if iMonth = 0 then
//	iMonth = 12
//	sYear = String(Integer(sYear) - 1)
//end if
//sMonth = Mid('0' + String(iMonth), Len(String(iMonth)), 2)
//sym6 = sYear + sMonth
//// 기준월 - 7
//iMonth = Integer(sMonth) - 1
//if iMonth = 0 then
//	iMonth = 12
//	sYear = String(Integer(sYear) - 1)
//end if
//sMonth = Mid('0' + String(iMonth), Len(String(iMonth)), 2)
//sym7 = sYear + sMonth
//// 기준월 - 8
//iMonth = Integer(sMonth) - 1
//if iMonth = 0 then
//	iMonth = 12
//	sYear = String(Integer(sYear) - 1)
//end if
//sMonth = Mid('0' + String(iMonth), Len(String(iMonth)), 2)
//sym8 = sYear + sMonth
//// 기준월 - 9
//iMonth = Integer(sMonth) - 1
//if iMonth = 0 then
//	iMonth = 12
//	sYear = String(Integer(sYear) - 1)
//end if
//sMonth = Mid('0' + String(iMonth), Len(String(iMonth)), 2)
//sym9 = sYear + sMonth
//
end function

on w_sal_04590.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_sal_04590.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;sle_msg.text = "출력조건을 입력하고 조회버턴을 누르세요"

/* User별 관할구역 Setting */
String sarea, steam, saupj

If f_check_sarea(sarea, steam, saupj) = 1 Then
	dw_ip.Modify("areacode.protect=1")
	dw_ip.Modify("areacode.background.color = 80859087")
End If
dw_ip.SetItem(1, "areacode", sarea)
	
dw_ip.setitem(1,'syy',left(f_today(),4))
dw_ip.setitem(1,'smm',mid(f_today(),5,2))
dw_Ip.SetFocus()
end event

type p_preview from w_standard_print`p_preview within w_sal_04590
end type

type p_exit from w_standard_print`p_exit within w_sal_04590
string picturename = "c:\erpman\image\닫기_up.gif"
end type

type p_print from w_standard_print`p_print within w_sal_04590
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_04590
end type







type st_10 from w_standard_print`st_10 within w_sal_04590
end type



type dw_print from w_standard_print`dw_print within w_sal_04590
string dataobject = "d_sal_04590_04_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_04590
integer x = 73
integer y = 32
integer width = 3447
integer height = 96
string dataobject = "d_sal_04590_01"
end type

event dw_ip::itemchanged;String sCol_Name, sNull, mm_chk, sEmpId
String sarea, steam, sCvcod, scvnas, sSaupj, sName1

sCol_Name = This.GetColumnName()
SetNull(sNull)
SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)
Choose Case sCol_Name
   // 기준년도 유효성 Check
	Case "syy"  
		if (Not(isNumber(Trim(this.getText())))) or (Len(Trim(this.getText())) <> 4) then
			f_Message_Chk(35, '[기준년도]')
			this.SetItem(1, "syy", sNull)
			return 1
		end if
		
	// 기준월 유효성 Check
   Case "smm"
		if Not(isNumber(Trim(this.getText()))) then
			f_Message_Chk(35, '[기준월]')
			this.SetItem(1, "smm", sNull)
			return 1
		end if
		mm_chk = Mid('0'+Trim(this.getText()), Len(Trim(this.getText())), 2)

      this.SetItem(1, "smm", mm_chk )
		return 2		
		
	/* 관할구역 */
	Case "areacode"
		SetItem(1,"custcode",sNull)
		SetItem(1,"custname",sNull)
		
		sarea = this.GetText()
		IF sarea = "" OR IsNull(sarea) THEN RETURN
		
		SELECT "SAREA"."SAREA" ,"SAREA"."STEAMCD" 	INTO :sarea  ,:steam
		  FROM "SAREA"  
		 WHERE "SAREA"."SAREA" = :sarea   ;		
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
End Choose
end event

event dw_ip::itemerror;return 1
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

type dw_list from w_standard_print`dw_list within w_sal_04590
integer x = 82
integer y = 204
integer width = 4521
integer height = 1996
string dataobject = "d_sal_04590_04"
boolean border = false
end type

type rr_1 from roundrectangle within w_sal_04590
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 73
integer y = 196
integer width = 4544
integer height = 2016
integer cornerheight = 40
integer cornerwidth = 55
end type

