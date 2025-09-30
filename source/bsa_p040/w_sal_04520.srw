$PBExportHeader$w_sal_04520.srw
$PBExportComments$ ===> 월 미수금 현황
forward
global type w_sal_04520 from w_standard_print
end type
type rr_1 from roundrectangle within w_sal_04520
end type
end forward

global type w_sal_04520 from w_standard_print
string title = "월 미수금 현황"
rr_1 rr_1
end type
global w_sal_04520 w_sal_04520

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String  sTeamCd, sSarea, sCvcod, sYear, sMonth, sMagam, sMisugu, sGubun
String  sym, sym1, sym2, sym3, sym4, sym5, sym6, sym7, sym8, sym9
Integer iMonth

If dw_ip.AcceptText() <> 1 Then Return -1

sYear = Trim(dw_ip.GetItemString(1,'syy'))
sMonth = Trim(dw_ip.GetItemString(1,'smm'))
sTeamCd = Trim(dw_ip.GetItemString(1,'deptcode'))
sSarea  = Trim(dw_ip.GetItemString(1,'areacode'))
sCvcod  = Trim(dw_ip.GetItemString(1,'custcode'))

sMisuGu = Trim(dw_ip.GetItemString(1,'misugu'))

sGubun = Trim(dw_ip.GetItemString(1,'gubun'))
If IsNull(sGubun) Or sGubun = '' Then sGubun = '1'

If IsNull(sTeamCd) Then  sTeamCd = ''
If IsNull(sSarea)  Then  sSarea = ''
If IsNull(sCvcod)  Then  sCvcod = ''

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

dw_list.object.sYear.Text = sYear
dw_list.object.sMonth.Text = sMonth
dw_list.object.sMonth_title.Text = sMonth+'월 미 수 금 현 황'

// 기준월
sym = sYear + sMonth

// 기준월 - 1
iMonth = Integer(sMonth) - 1
if iMonth = 0 then
	iMonth = 12
	sYear = String(Integer(sYear) - 1)
end if
sMonth = Mid('0' + String(iMonth), Len(String(iMonth)), 2)
sym1 = sYear + sMonth
// 기준월 - 2
iMonth = Integer(sMonth) - 1
if iMonth = 0 then
	iMonth = 12
	sYear = String(Integer(sYear) - 1)
end if
sMonth = Mid('0' + String(iMonth), Len(String(iMonth)), 2)
sym2 = sYear + sMonth
// 기준월 - 3
iMonth = Integer(sMonth) - 1
if iMonth = 0 then
	iMonth = 12
	sYear = String(Integer(sYear) - 1)
end if
sMonth = Mid('0' + String(iMonth), Len(String(iMonth)), 2)
sym3 = sYear + sMonth
// 기준월 - 4
iMonth = Integer(sMonth) - 1
if iMonth = 0 then
	iMonth = 12
	sYear = String(Integer(sYear) - 1)
end if
sMonth = Mid('0' + String(iMonth), Len(String(iMonth)), 2)
sym4 = sYear + sMonth
// 기준월 - 5
iMonth = Integer(sMonth) - 1
if iMonth = 0 then
	iMonth = 12
	sYear = String(Integer(sYear) - 1)
end if
sMonth = Mid('0' + String(iMonth), Len(String(iMonth)), 2)
sym5 = sYear + sMonth
// 기준월 - 6
iMonth = Integer(sMonth) - 1
if iMonth = 0 then
	iMonth = 12
	sYear = String(Integer(sYear) - 1)
end if
sMonth = Mid('0' + String(iMonth), Len(String(iMonth)), 2)
sym6 = sYear + sMonth
// 기준월 - 7
iMonth = Integer(sMonth) - 1
if iMonth = 0 then
	iMonth = 12
	sYear = String(Integer(sYear) - 1)
end if
sMonth = Mid('0' + String(iMonth), Len(String(iMonth)), 2)
sym7 = sYear + sMonth
// 기준월 - 8
iMonth = Integer(sMonth) - 1
if iMonth = 0 then
	iMonth = 12
	sYear = String(Integer(sYear) - 1)
end if
sMonth = Mid('0' + String(iMonth), Len(String(iMonth)), 2)
sym8 = sYear + sMonth
// 기준월 - 9
iMonth = Integer(sMonth) - 1
if iMonth = 0 then
	iMonth = 12
	sYear = String(Integer(sYear) - 1)
end if
sMonth = Mid('0' + String(iMonth), Len(String(iMonth)), 2)
sym9 = sYear + sMonth

sSarea = sSarea+'%'

string ls_silgu

SELECT DATANAME
INTO   :ls_silgu
FROM   SYSCNFG
WHERE  SYSGU = 'S'   AND
       SERIAL = '8'  AND
       LINENO = '40' ;

if dw_print.Retrieve(gs_sabu, sTeamCd+'%', sSarea+'%',sCvcod+'%', sym9, sym8, sym7, sym6, sym5, sym4, sym3, sym2, sym1,sym, sMisugu, sGubun,ls_silgu) < 1 then
	f_message_Chk(300, '[출력조건 CHECK]')
	dw_ip.setcolumn('syy')
	dw_ip.setfocus()
	return -1
end if

dw_print.ShareData(dw_list)

select max(jpdat) into :sMagam
  from junpyo_closing 
 where jpgu = 'G0' ;
 
If sqlca.sqlcode <> 0 Then
	sMagam = ''
	dw_print.object.txt_magam.Text = '매출 미마감'
Else
	dw_print.object.txt_magam.Text = Left(sMagam,4)+'.'+Right(sMagam,2)
End If

return 1

//if dw_list.Retrieve(gs_sabu, sTeamCd+'%', sSarea+'%',sCvcod+'%', sym9, sym8, sym7, sym6, sym5, sym4, sym3, sym2, sym1,sym, sMisugu, sGubun,ls_silgu) < 1 then
//	f_message_Chk(300, '[출력조건 CHECK]')
//	dw_ip.setcolumn('syy')
//	dw_ip.setfocus()
//	return -1
//end if
//
//select max(jpdat) into :sMagam
//  from junpyo_closing 
// where jpgu = 'G0' ;
// 
//If sqlca.sqlcode <> 0 Then
//	sMagam = ''
//	dw_list.object.txt_magam.Text = '매출 미마감'
//Else
//	dw_list.object.txt_magam.Text = Left(sMagam,4)+'.'+Right(sMagam,2)
//End If
//
//return 1
end function

on w_sal_04520.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_sal_04520.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;String sToday

sToday = f_today()
dw_ip.SetItem(1, 'syy', Left(sToday,4))
dw_ip.SetItem(1, 'smm', Mid(sToday,5,2))

/* User별 관할구역 Setting */
String sarea, steam, saupj

If f_check_sarea(sarea, steam, saupj) = 1 Then
	dw_ip.SetItem(1, 'deptcode', steam)
	dw_ip.SetItem(1, 'areacode', sarea)
	dw_ip.Modify("deptcode.protect=1")
	dw_ip.Modify("deptcode.background.color = 80859087")
	dw_ip.Modify("areacode.protect=1")
	dw_ip.Modify("areacode.background.color = 80859087")
End If

dw_ip.SetColumn('smm')
dw_Ip.SetFocus()

sle_msg.text = "출력조건을 입력하고 조회버턴을 누르세요"
end event

type p_preview from w_standard_print`p_preview within w_sal_04520
end type

type p_exit from w_standard_print`p_exit within w_sal_04520
end type

type p_print from w_standard_print`p_print within w_sal_04520
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_04520
end type







type st_10 from w_standard_print`st_10 within w_sal_04520
end type



type dw_print from w_standard_print`dw_print within w_sal_04520
boolean visible = true
integer x = 69
integer y = 308
integer width = 4512
integer height = 2000
string dataobject = "d_sal_04520_p"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type dw_ip from w_standard_print`dw_ip within w_sal_04520
integer x = 50
integer y = 28
integer width = 3813
integer height = 248
string dataobject = "d_sal_04520_01"
end type

event dw_ip::itemchanged;String sCol_Name, sNull, mm_chk
String sarea, steam, sCvcod, scvnas, sSaupj, sName1
String sCurr

sCol_Name = This.GetColumnName()
SetNull(sNull)

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
	/* 발행구분 */
	Case "prtgbn"
		
		dw_list.SetRedraw(False)
		If GetText() = '1' Then
			dw_list.DataObject = 'd_sal_04520'
		Else
			If GetItemString(1,'curr') = 'USD' Then
				dw_list.DataObject = 'd_sal_04520_1'
			Else
				dw_list.DataObject = 'd_sal_04520_2'				
			End If
		End If
      dw_list.SetTransObject(sqlca)
 		dw_list.SetRedraw(True)

//		SetItem(1,'deptcode',sNull)
//		SetItem(1,'areacode',sNull)
		SetItem(1,"custcode",sNull)
		SetItem(1,"custname",sNull)
	Case "curr"
		
		dw_list.SetRedraw(False)

		If GetText() = 'USD' Then
			dw_list.DataObject = 'd_sal_04520_1'
		Else
			dw_list.DataObject = 'd_sal_04520_2'				
		End If

      dw_list.SetTransObject(sqlca)
 		dw_list.SetRedraw(True)

		SetItem(1,'deptcode',sNull)
		SetItem(1,'areacode',sNull)
		SetItem(1,"custcode",sNull)
		SetItem(1,"custname",sNull)
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
			SetItem(1,"deptcode", steam)
			SetItem(1,"areacode", sarea)
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

type dw_list from w_standard_print`dw_list within w_sal_04520
boolean visible = false
integer x = 69
integer y = 308
integer width = 4512
integer height = 2000
string dataobject = "d_sal_04520"
boolean border = false
boolean hsplitscroll = false
end type

type rr_1 from roundrectangle within w_sal_04520
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 55
integer y = 300
integer width = 4539
integer height = 2020
integer cornerheight = 40
integer cornerwidth = 55
end type

