$PBExportHeader$w_sal_04515.srw
$PBExportComments$ ===> 월 수금율 현황
forward
global type w_sal_04515 from w_standard_print
end type
type rr_1 from roundrectangle within w_sal_04515
end type
end forward

global type w_sal_04515 from w_standard_print
string title = "월 수금율 현황"
rr_1 rr_1
end type
global w_sal_04515 w_sal_04515

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String ym, sIlja_start, sIlja_End, sT, sS, sCvcod, sT_Name, sS_Name, sCvcod_Name, sPrtgbn, sGubun

If dw_ip.AcceptText() <> 1 Then Return 1

ym = Trim(dw_ip.GetItemString(1,'sym'))
sPrtgbn = Trim(dw_ip.GetItemString(1,'prtgbn'))
sGubun  = Trim(dw_ip.GetItemString(1,'gubun'))
If IsNull(sGubun) Then sGubun = '1'

if	(ym='') or isNull(ym) then
	f_Message_Chk(35, '[기준년월]')
	dw_ip.setcolumn('sym')
	dw_ip.setfocus()
	Return -1
end if

sIlja_start = Left(ym,4) + '.' + Right(ym,2) + '.01'
sIlja_end = Left(ym,4) + '.' + Right(ym,2) + '.' + Right(f_last_date(ym),2)

// 영업팀 선택
sT = Trim(dw_ip.GetItemString(1,'steam'))
if isNull(sT) or (sT = '') then
	sT = ''
	sT_Name = '전  체'
else
	Select steamnm Into :sT_Name 
	From steam
	Where steamcd = :sT;
	if isNull(sT_Name) then
		sT_Name = ''
	end if
end if
sT = sT + '%'

// 관할구역 선택
sS = Trim(dw_ip.GetItemString(1,'sarea'))
if isNull(sS) or (sS = '') then
	sS = ''
	sS_Name = '전  체'
else
	Select sareanm Into :sS_Name 
	From sarea
	Where sarea = :sS;
	if isNull(sS_Name) then
		sS_Name = ''
	end if
end if
sS = sS + '%'

// 거래처 선택
sCvcod = Trim(dw_ip.GetItemString(1,'cvcod'))
if isNull(sCvcod) or (sCvcod = '') then
	sCvcod = '%'
	sCvcod_Name = '전  체'
else
	sCvcod = sCvcod + '%'
	sCvcod_Name = Trim(dw_ip.GetItemString(1,'cvnas2'))
end if

dw_print.object.r_ilja.Text = sIlja_Start + ' - ' + sIlja_End
dw_print.object.r_steam.Text = sT_Name
dw_print.object.r_sarea.Text = sS_Name

string ls_silgu

SELECT DATANAME
INTO   :ls_silgu
FROM   SYSCNFG
WHERE  SYSGU = 'S'   AND
       SERIAL = '8'  AND
       LINENO = '40' ;

if dw_print.Retrieve(gs_sabu, ym, sCvcod, sS, sT, sPrtgbn, sGubun,ls_silgu) < 1 then
   f_message_Chk(300, '[출력조건 CHECK]')
  	dw_ip.setcolumn('sym')
   dw_ip.setfocus()
  	return -1
end if

dw_print.ShareData(dw_list)

return 1

//dw_list.object.r_ilja.Text = sIlja_Start + ' - ' + sIlja_End
//dw_list.object.r_steam.Text = sT_Name
//dw_list.object.r_sarea.Text = sS_Name
//
//string ls_silgu
//
//SELECT DATANAME
//INTO   :ls_silgu
//FROM   SYSCNFG
//WHERE  SYSGU = 'S'   AND
//       SERIAL = '8'  AND
//       LINENO = '40' ;
//
//if dw_list.Retrieve(gs_sabu, ym, sCvcod, sS, sT, sPrtgbn, sGubun,ls_silgu) < 1 then
//   f_message_Chk(300, '[출력조건 CHECK]')
//  	dw_ip.setcolumn('sym')
//   dw_ip.setfocus()
//  	return -1
//end if
//
//return 1
end function

on w_sal_04515.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_sal_04515.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;/* User별 관할구역 Setting */
String sarea, steam, saupj

If f_check_sarea(sarea, steam, saupj) = 1 Then
	dw_ip.SetItem(1, 'sarea', sarea)
	dw_ip.SetItem(1, 'steam', steam)
	dw_ip.Modify("steam.protect=1")
	dw_ip.Modify("sarea.protect=1")
	dw_ip.Modify("steam.background.color = 80859087")
	dw_ip.Modify("sarea.background.color = 80859087")
End If

dw_ip.SetItem(1, 'sym', left(f_today(), 6))

dw_ip.SetColumn('steam')
dw_ip.SetFocus()

sle_msg.text = "출력조건을 입력하고 조회버턴을 누르세요"
end event

type p_preview from w_standard_print`p_preview within w_sal_04515
end type

type p_exit from w_standard_print`p_exit within w_sal_04515
end type

type p_print from w_standard_print`p_print within w_sal_04515
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_04515
end type







type st_10 from w_standard_print`st_10 within w_sal_04515
end type



type dw_print from w_standard_print`dw_print within w_sal_04515
string dataobject = "d_sal_04515_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_04515
integer x = 69
integer y = 28
integer width = 2999
integer height = 292
string dataobject = "d_sal_04515_1"
end type

event dw_ip::itemchanged;String sNull
String sarea, steam, sCvcod, scvnas, sSaupj, sName1

SetNull(sNull)

Choose Case GetColumnName()
	/* 영업팀 */
	Case "steam"
		SetItem(1,"sarea",sNull)
		SetItem(1,"cvcod",sNull)
		SetItem(1,"cvnas2",sNull)
	/* 관할구역 */
	Case "sarea"
		SetItem(1,"cvcod",sNull)
		SetItem(1,"cvnas2",sNull)
	/* 거래처 */
	Case "cvcod"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"cvnas2",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod', sNull)
			SetItem(1, 'cvnas2', snull)
			Return 1
		ELSE
			SetItem(1,"steam",   steam)
			SetItem(1,"sarea",   sarea)
			SetItem(1,"cvnas2",	scvnas)
		END IF
	/* 거래처명 */
	Case "cvnas2"
		scvnas = Trim(GetText())
		IF scvnas ="" OR IsNull(scvnas) THEN
			SetItem(1,"cvcod",snull)
			Return
		END IF
		
		If f_get_cvnames('2', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod', sNull)
			SetItem(1, 'cvnas2', snull)
			Return 1
		ELSE
			SetItem(1,"steam",   steam)
			SetItem(1,"sarea",   sarea)
			SetItem(1,'cvcod', sCvcod)
			SetItem(1,"cvnas2", scvnas)
			Return 1
		END IF
End Choose

end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case GetColumnName()
	/* 거래처 */
	Case "cvcod", "cvnas2"
		gs_gubun = '1'
		If GetColumnName() = "cvnas2" then
			gs_codename = Trim(GetText())
		End If
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cvcod",gs_code)
		SetColumn("cvcod")
		TriggerEvent(ItemChanged!)
End Choose
end event

type dw_list from w_standard_print`dw_list within w_sal_04515
integer x = 87
integer y = 348
integer width = 4512
integer height = 1944
string dataobject = "d_sal_04515"
boolean border = false
boolean hsplitscroll = false
end type

type rr_1 from roundrectangle within w_sal_04515
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 73
integer y = 340
integer width = 4544
integer height = 1968
integer cornerheight = 40
integer cornerwidth = 55
end type

