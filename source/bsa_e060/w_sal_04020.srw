$PBExportHeader$w_sal_04020.srw
$PBExportComments$ ===> 장기미수금 관리
forward
global type w_sal_04020 from w_inherite
end type
type dw_select from datawindow within w_sal_04020
end type
type dw_insert1 from datawindow within w_sal_04020
end type
type cb_del1 from commandbutton within w_sal_04020
end type
type cb_ins2 from commandbutton within w_sal_04020
end type
type cb_1 from commandbutton within w_sal_04020
end type
type st_2 from statictext within w_sal_04020
end type
type st_3 from statictext within w_sal_04020
end type
type st_4 from statictext within w_sal_04020
end type
type p_1 from uo_picture within w_sal_04020
end type
type p_ins2 from uo_picture within w_sal_04020
end type
type p_del1 from uo_picture within w_sal_04020
end type
type pb_1 from u_pb_cal within w_sal_04020
end type
type rr_1 from roundrectangle within w_sal_04020
end type
type rr_2 from roundrectangle within w_sal_04020
end type
type rr_3 from roundrectangle within w_sal_04020
end type
type rr_4 from roundrectangle within w_sal_04020
end type
end forward

global type w_sal_04020 from w_inherite
string title = "장기미수금 관리"
dw_select dw_select
dw_insert1 dw_insert1
cb_del1 cb_del1
cb_ins2 cb_ins2
cb_1 cb_1
st_2 st_2
st_3 st_3
st_4 st_4
p_1 p_1
p_ins2 p_ins2
p_del1 p_del1
pb_1 pb_1
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
rr_4 rr_4
end type
global w_sal_04020 w_sal_04020

type variables
Integer ii_chk
String isarea, isteam, isaupj
end variables

forward prototypes
public subroutine wf_buttoncontrol (string button_mode)
end prototypes

public subroutine wf_buttoncontrol (string button_mode);// Subject  : Button Enable, Disable
// Argument : Button_Mode(String) => 0 : Button Enabled, 1 : ButtonEnabled
// Return   : None

if Button_Mode = '0' then
	cb_mod.Enabled = True
	cb_del.Enabled = True
	cb_ins.Enabled = True
	cb_del1.Enabled = True
else
	cb_mod.Enabled = False
	cb_del.Enabled = False
	cb_ins.Enabled = False
	cb_del1.Enabled = False
end if
end subroutine

on w_sal_04020.create
int iCurrent
call super::create
this.dw_select=create dw_select
this.dw_insert1=create dw_insert1
this.cb_del1=create cb_del1
this.cb_ins2=create cb_ins2
this.cb_1=create cb_1
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.p_1=create p_1
this.p_ins2=create p_ins2
this.p_del1=create p_del1
this.pb_1=create pb_1
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
this.rr_4=create rr_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_select
this.Control[iCurrent+2]=this.dw_insert1
this.Control[iCurrent+3]=this.cb_del1
this.Control[iCurrent+4]=this.cb_ins2
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.st_4
this.Control[iCurrent+9]=this.p_1
this.Control[iCurrent+10]=this.p_ins2
this.Control[iCurrent+11]=this.p_del1
this.Control[iCurrent+12]=this.pb_1
this.Control[iCurrent+13]=this.rr_1
this.Control[iCurrent+14]=this.rr_2
this.Control[iCurrent+15]=this.rr_3
this.Control[iCurrent+16]=this.rr_4
end on

on w_sal_04020.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_select)
destroy(this.dw_insert1)
destroy(this.cb_del1)
destroy(this.cb_ins2)
destroy(this.cb_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.p_1)
destroy(this.p_ins2)
destroy(this.p_del1)
destroy(this.pb_1)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
destroy(this.rr_4)
end on

event open;call super::open;dw_Select.Settransobject(sqlca)
dw_Insert.Settransobject(sqlca)
dw_Insert1.Settransobject(sqlca)

/* User별 관할구역 Setting */
If f_check_sarea(isarea, isteam, isaupj) = 1 Then
Else
	isarea = ''
End If

p_can.TriggerEvent(Clicked!)
end event

type dw_insert from w_inherite`dw_insert within w_sal_04020
integer x = 105
integer y = 1060
integer width = 1659
integer height = 1012
integer taborder = 10
string dataobject = "d_sal_04020_01"
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case GetColumnName()
	/* 거래처 */
	Case "cvcod", "vndmst_cvnas2"
		gs_gubun = '1'
		If GetColumnName() = "vndmst_cvnas2" then
			gs_codename = Trim(GetText())
		End If
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cvcod",gs_code)
		SetColumn("cvcod")
		TriggerEvent(ItemChanged!)
end Choose
end event

event dw_insert::itemchanged;String sNull, sMisudate
String sarea, steam, sCvcod, scvnas, sSaupj, sName1

SetNull(sNull)

Choose Case GetColumnName()
	/* 거래처 */
	Case "cvcod"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"vndmst_cvnas2",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			this.SetItem(1, "long_misu_date", sNull)
			this.SetItem(1, "long_misu_amt", sNull)
			this.SetItem(1, "ija_rate", sNull)
			this.SetItem(1, "ija_amt", sNull)			
			this.SetItem(1, "sugum_plan", sNull)
			this.SetItem(1, "last_sugum_date", sNull)	
			
			dw_insert1.Reset()
			dw_Insert1.Enabled = False
			wf_buttoncontrol('1')
			SetItem(1, 'cvcod', sNull)
			SetItem(1, 'vndmst_cvnas2', snull)
			Return 1
		ELSE		
			this.SetItem(1, "long_misu_date", sNull)
			this.SetItem(1, "long_misu_amt", 0)
			this.SetItem(1, "ija_rate", 0)
			this.SetItem(1, "ija_amt", 0)			
			this.SetItem(1, "sugum_plan", sNull)
			this.SetItem(1, "last_sugum_date", sNull)
			
			SetItem(1,"vndmst_cvnas2",	scvnas)
			dw_Insert1.Enabled = False			
			wf_buttoncontrol('1')
			dw_insert1.Reset()
		END IF
   // 책정일자 유효성 Check
	Case "long_misu_date"  
		sCvCod = this.GetItemString(1,'cvcod')
		scvnas = this.GetItemString(1,'vndmst_cvnas2')
		sMisuDate = this.GetText()		
		if f_DateChk(Trim(sMisuDate)) = -1 then
			f_Message_Chk(35, '[책정일자]')
			this.SetItem(1, "long_misu_date", sNull)
			dw_insert1.Reset()			
			return 1
		end if

		dw_insert.SetRedraw(False)
      if dw_Insert.retrieve(sCvCod, sMisuDate) < 1 then
			dw_Insert.Reset()
   		dw_Insert.InsertRow(0)	
			this.SetItem(1, "cvcod", sCvCod)
			this.SetItem(1, "vndmst_cvnas2", scvnas)
			this.SetItem(1, "long_misu_date", sMisuDate)
			this.SetItem(1, "long_misu_amt", sNull)
			this.SetItem(1, "ija_rate", sNull)
			this.SetItem(1, "sugum_plan", sNull)
			this.SetItem(1, "last_sugum_date", sNull)
		end if
		dw_insert.SetRedraw(True)
		
		dw_insert1.SetRedraw(False)
		if dw_Insert1.Retrieve(sCvCod, sMisuDate) < 1 then
			dw_Insert1.Reset()
			dw_Insert1.InsertRow(0)
			dw_Insert1.SetItem(1, "cvcod", sCvCod)
			dw_Insert1.SetItem(1, "long_misu_date", sMisuDate)			
		end if
		dw_insert1.SetRedraw(True)
		
		dw_Insert1.Enabled = True
		wf_buttoncontrol('0')

	// 최종수금예정일자 유효성 Check
   Case "last_sugum_date"
		if f_DateChk(Trim(this.getText())) = -1 then
			this.SetItem(1, "last_sugum_date", sNull)
			f_Message_Chk(35, '[최종수금예정일자]')
			return 1
		end if
end Choose
end event

event dw_insert::itemerror;return 1
end event

event dw_insert::itemfocuschanged;if this.GetColumnName() = "sugum_plan" then
	f_toggle_kor(handle(parent))		//---> 한글 입력모드로
else
	f_toggle_eng(handle(parent))		//---> 영문입력 모드로
end if

end event

type p_delrow from w_inherite`p_delrow within w_sal_04020
integer x = 4041
integer y = 5000
end type

type p_addrow from w_inherite`p_addrow within w_sal_04020
integer x = 4229
integer y = 5000
end type

type p_search from w_inherite`p_search within w_sal_04020
integer x = 3881
integer y = 5000
end type

type p_ins from w_inherite`p_ins within w_sal_04020
integer x = 4416
integer y = 176
end type

event p_ins::clicked;call super::clicked;String sCvCod, sLongMisuDate
Long   cur_row

dw_Insert.AcceptText()
sCvCod = dw_Insert.GetItemString(1, 'cvcod')
sLongMisuDate = dw_Insert.GetItemString(1, 'long_misu_date')

cur_row = dw_insert1.InsertRow(0)
	
dw_insert1.SetItem(cur_row, 'cvcod', sCvCod)
dw_insert1.SetItem(cur_row, 'long_misu_date', sLongMisuDate)
dw_insert1.SetItem(cur_row, 'rep_amt', 0)
dw_insert1.SetItem(cur_row, 'ija_amt', 0)
dw_insert1.SetItem(cur_row, 'gbn', '0')



dw_insert1.ScrollToRow(cur_row)
	
dw_insert1.setcolumn('rep_date')
dw_insert1.SetFocus()
	
w_mdi_frame.sle_msg.text = "상환계획을 입력하세요!!!"
end event

type p_exit from w_inherite`p_exit within w_sal_04020
integer x = 4416
integer y = 16
end type

type p_can from w_inherite`p_can within w_sal_04020
integer x = 4069
integer y = 16
end type

event p_can::clicked;call super::clicked;
Parent.SetRedraw(False)

dw_Select.Retrieve(isarea+'%')

dw_Insert.Reset()
dw_Insert.InsertRow(0)

dw_Insert1.Reset()
dw_Insert1.Enabled = False

wf_buttoncontrol('1')

w_mdi_frame.sle_msg.text = '장기미수금 신규등록 또는 수정할 거래처를 선택하세요'

ib_any_typing = False

Parent.SetRedraw(True)

dw_Insert.SetFocus()
end event

type p_print from w_inherite`p_print within w_sal_04020
integer x = 4425
integer y = 5000
end type

type p_inq from w_inherite`p_inq within w_sal_04020
integer x = 4119
integer y = 5000
end type

type p_del from w_inherite`p_del within w_sal_04020
integer x = 3767
integer y = 16
integer width = 306
string picturename = "C:\erpman\image\장기미수삭제_up.gif"
end type

event p_del::clicked;call super::clicked;String sCvCod, sCvNas, sMisuDate

If dw_insert.accepttext() <> 1 then Return

sCvCod = dw_Insert.GetItemString(1,'cvcod')
sCvNas = dw_Insert.GetItemString(1,'vndmst_cvnas2')
sMisuDate = dw_Insert.GetItemString(1,'long_misu_date')

if MessageBox("삭제 확인", sCvNas + '의 ' + Left(sMisuDate,4) + '.' + Mid(sMisuDate,5,2) + &
                           '.' + Right(sMisuDate,2) + '일자 장기미수를 삭제합니다.' + '~r~r' + &
									'삭제시는 장기미수 및 해당 상환계획도 일괄 삭제됩니다.' + '~r~r' + &
									'삭제 하시겠습니까?' &
									,question!,yesno!, 2) = 2 THEN Return

dw_insert.DeleteRow(0)

if dw_insert.Update() = -1 THEN
	f_Message_Chk(31, '[삭제확인]')
	Rollback;
end if

// 장기미수 상환계획 삭제
Delete From longmisu_sch
Where cvcod = :sCvCod and long_misu_date = :sMisuDate;

if SQLCA.SQLCODE <> 0 then
   messagebox("확인","삭제실패!")
	Rollback;
	return
end if

Commit;		

messagebox("확인","삭제가 완료되었습니다!")

p_can.TriggerEvent(Clicked!)
end event

event p_del::ue_lbuttonup;PictureName = "C:\erpman\image\장기미수삭제_up.gif"
end event

event p_del::ue_lbuttondown;PictureName = "C:\erpman\image\장기미수삭제_dn.gif"
end event

type p_mod from w_inherite`p_mod within w_sal_04020
integer x = 4242
integer y = 16
end type

event p_mod::clicked;call super::clicked;string  sCvCod, sMisuDate, sRepDate
Integer i

dw_Insert.AcceptText()

// 장기미수 History Table 저장
if dw_Insert.Update() = -1 then  
   f_message_Chk(32,'[장기미수 저장]')
	Rollback;
	return
end if

if dw_insert1.Accepttext() = -1 then return

for i = 1 to dw_insert1.RowCount()
	sRepDate = dw_insert1.GetItemString(i, "rep_date")
	if isNull(sRepDate) or sRepDate = '' then
		dw_insert1.DeleteRow(i)
	end if
next

// 장기미수 상환계획 저장
if dw_Insert1.Update() = -1 then  
   f_message_Chk(32,'[장기미수 상환계획]')
	Rollback;
	return
end if

Commit;		
f_message_Chk(202,'[장기미수, 상환계획]')

p_can.TriggerEvent(Clicked!)
end event

type cb_exit from w_inherite`cb_exit within w_sal_04020
integer x = 4325
integer y = 5000
integer width = 325
integer taborder = 160
end type

type cb_mod from w_inherite`cb_mod within w_sal_04020
integer x = 3547
integer y = 5000
integer width = 325
integer taborder = 90
end type

type cb_ins from w_inherite`cb_ins within w_sal_04020
integer x = 3735
integer y = 5000
integer width = 325
integer taborder = 80
string text = "추가(&I)"
end type

type cb_del from w_inherite`cb_del within w_sal_04020
boolean visible = false
integer x = 3744
integer y = 340
integer width = 549
integer taborder = 100
string text = "장기미수삭제(&D)"
end type

type cb_inq from w_inherite`cb_inq within w_sal_04020
boolean visible = false
integer x = 1408
integer y = 5000
integer taborder = 110
end type

type cb_print from w_inherite`cb_print within w_sal_04020
boolean visible = false
integer x = 2245
integer y = 5000
integer taborder = 120
end type

type st_1 from w_inherite`st_1 within w_sal_04020
end type

type cb_can from w_inherite`cb_can within w_sal_04020
integer x = 2619
integer y = 5000
integer width = 325
integer taborder = 130
end type

type cb_search from w_inherite`cb_search within w_sal_04020
boolean visible = false
integer x = 2702
integer y = 5000
integer taborder = 150
end type







type gb_button1 from w_inherite`gb_button1 within w_sal_04020
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_04020
end type

type dw_select from datawindow within w_sal_04020
integer x = 27
integer y = 72
integer width = 3639
integer height = 636
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_sal_04020"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;// Row 선택시 파란색으로 선택표시
if row > 0 then
   dw_select.SelectRow(0, False)
   dw_select.SelectRow(row, true)
else
	return
end if

String sCvCod, sMisuDate
//long lrow

//lrow = dw_Select.GetRow()

sCvCod = dw_select.GetItemString(row, "cvcod")
sMisuDate = dw_select.GetItemString(row, "long_misu_date")

IF dw_Insert.retrieve(sCvCod, sMisuDate) = -1 THEN
	f_Message_Chk(33, '[자료 확인]')
	dw_Insert.Reset()
   dw_Insert.InsertRow(0)
	dw_Insert1.Reset()
	dw_Select.Setfocus()
   return
END IF

IF dw_Insert1.retrieve(sCvCod, sMisuDate) = -1 THEN
	f_Message_Chk(33, '[자료 확인]')
	dw_Insert1.Reset()
   return
END IF

dw_Insert1.Enabled = True
wf_buttoncontrol('0')
w_mdi_frame.sle_msg.text = '장기미수금 수정 및 상환계획을 추가 및 수정하세요'
dw_Insert.SetColumn('long_misu_amt')
dw_Insert.SetFocus()
end event

event doubleclicked;//String sCvCod, sMisuDate
//long lrow
//
//lrow = dw_Select_sub.GetRow()
//
//sCvCod = dw_select_sub.GetItemString(lrow,"cvcod")
//sMisuDate = dw_select_sub.GetItemString(lrow,"long_misu_date")
//
//IF dw_Insert.retrieve(sCvCod, sMisuDate) < 1 THEN
//	f_Message_Chk(33, '[자료 확인]')
//	dw_Insert.Reset()
//   dw_Insert.InsertRow(0)
//	dw_Select_sub.Setfocus()
//   return
//END IF
//
//w_mdi_frame.sle_msg.text = '장기미수금 등록 또는 수정하세요'
////dw_Insert.SetColumn('long_misu_date')
//dw_Insert.SetFocus()
end event

type dw_insert1 from datawindow within w_sal_04020
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 2409
integer y = 1064
integer width = 1719
integer height = 1048
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_sal_04020_02"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_key;Long CurRow

choose case key
	case KeyDownArrow! 
		CurRow = this.GetRow()
		this.triggerEvent(itemchanged!)
		if ii_chk = 1 then return 1
		
      this.AcceptText()
		if this.GetItemString(CurRow, 'rep_date') = '' or &
		   isNull(this.GetItemString(CurRow, 'rep_date')) then
			f_message_chk(30, '[상환예정일]')
			this.SetColumn('rep_date')
			return 1
		end if
		
		if this.rowcount() = CurRow then
			cb_ins.postevent(clicked!)
		end if
end choose
end event

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;String sNull, sCol_Name, sRepDate, sMisuDate, sRepDate1, sRepDate2
Long   CurRow, PreRow, RtnRow
Double lMisuAmt, lGigan, lWongum, lIjagum
Dec    dIjaRate

dw_Insert.AcceptText()
sMisuDate = dw_Insert.GetItemString(1, 'long_misu_date')
lMisuAmt = dw_Insert.GetItemNumber(1, 'long_misu_amt')
dIjaRate = dw_Insert.GetItemNumber(1, 'ija_rate')

sCol_Name = This.GetColumnName()
SetNull(sNull)

CurRow = this.GetRow()

ii_chk = 0
Choose Case sCol_Name
   // 상환예정일자 유효성 Check
	Case "rep_date"  
		sRepDate = this.GetText()		
		if f_DateChk(Trim(sRepDate)) = -1 then
			f_Message_Chk(35, '[상환예정일자]')
			this.SetItem(CurRow, "rep_date", sNull)
			ii_chk = 1
			return 1
		end if
		
   	RtnRow = this.find("rep_date ='" + sRepDate +"'", 1, this.RowCount())
   	if (CurRow <> RtnRow) and (RtnRow <> 0) then
	   	f_message_chk(1,'[상환예정일자]')
		   this.SetItem(CurRow, "rep_date", sNull)
		   this.SetItem(CurRow, "rep_amt", 0)
		   this.SetItem(CurRow, "ija_amt", 0)			
			ii_chk = 1
   		return 1	
		end if
		
      if CurRow = 1 then
			lGigan = f_dayterm(sMisuDate, sRepDate)
			lWonGum = lMisuAmt
		else
   		PreRow = CurRow - 1
			sRepDate1 = this.GetItemString(PreRow, 'rep_date')
			lGigan = f_dayterm(sRepDate1, sRepDate) - 1
			lWonGum = lMisuAmt - this.getItemNumber(PreRow, 'ipgum_nu')
		end if
		
		lIjaGum = round(lWonGum * lGigan / 365 * dIjaRate * 0.01, 0)
		this.SetItem(CurRow, 'ija_amt', lIjaGum)
//		this.GetItemNumber(1, 'sum_ijaamt')
		dw_Insert.SetItem(1, 'ija_amt', this.GetItemNumber(1, 'sum_ijaamt'))
		
   // 상환예정금액 입력시
	Case "rep_amt"
		if Not(isNumber(this.GetText())) then
			f_Message_Chk(201, '[상환예정금액]')
			this.SetItem(CurRow, "rep_amt", 0)
			ii_chk = 1
			return 1
		end if		
		
      if CurRow = 1 then
   		sRepDate2 = this.GetItemString(CurRow, 'rep_date')			
			lGigan = f_dayterm(sMisuDate, sRepDate2)
			lWonGum = lMisuAmt
		else
   		PreRow = CurRow - 1
   		sRepDate1 = this.GetItemString(PreRow, 'rep_date')
   		sRepDate2 = this.GetItemString(CurRow, 'rep_date')			
			lGigan = f_dayterm(sRepDate1, sRepDate2) - 1
			lWonGum = lMisuAmt - this.getItemNumber(PreRow, 'ipgum_nu')
		end if
		
		lIjaGum = round(lWonGum * lGigan / 365 * dIjaRate * 0.01, 0)
		this.SetItem(CurRow, 'ija_amt', lIjaGum)
		dw_Insert.SetItem(1, 'ija_amt', this.GetItemNumber(1, 'sum_ijaamt'))		
end Choose
end event

event itemerror;return 1
end event

event rowfocuschanged;this.SetRowFocusIndicator(Hand!, 50, -15)
end event

event dberror;String  sMsg, sErrorcode, sErrorsyntax, sReturn, sNewline
Integer iPos, iCount

iCount			= 0
sNewline			= '~r'
sReturn			= '~n'
sErrorcode 		= Left(sqlerrtext, 9)
iPos 		  		= Len(sqlerrtext) - Pos(sqlerrtext, "No changes made to database.", 1)
sErrorSyntax	= tRIM(Mid(sqlerrtext, 11, Len(sqlerrtext) - iPos - 11))

For iPos = Len(sErrorSyntax) to 1 STEP -1
	 sMsg = Mid(sErrorSyntax, ipos, 1)
	 If sMsg   = sReturn or sMsg = sNewline Then
		 iCount++
	 End if
Next

sErrorSynTax  	= Left(sErrorSyntax, Len(sErrorsyntax) - iCount)


str_db_error db_error_msg
db_error_msg.rowno 	 				= row
db_error_msg.errorcode 				= sErrorCode
db_error_msg.errorsyntax_system	= sErrorSyntax
db_error_msg.errorsyntax_user		= sErrorSyntax
db_error_msg.errorsqlsyntax			= sqlsyntax
OpenWithParm(w_error, db_error_msg)


/*sMsg = "Row No       -> " + String(row) 			 + '~n' + &
		 "Error Code   -> " + sErrorcode			    + '~n' + &
		 "Error Syntax -> " + sErrorSyntax			 + '~n' + &
		 "SqlSyntax    -> " + Sqlsyntax
	MESSAGEBOX("자료처리중 오류발생", sMsg) */

RETURN 1
end event

type cb_del1 from commandbutton within w_sal_04020
boolean visible = false
integer x = 3753
integer y = 456
integer width = 571
integer height = 108
integer taborder = 140
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "상환계획ROW삭제"
end type

type cb_ins2 from commandbutton within w_sal_04020
boolean visible = false
integer x = 4055
integer y = 672
integer width = 325
integer height = 108
integer taborder = 170
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "삽입(&t)"
end type

type cb_1 from commandbutton within w_sal_04020
boolean visible = false
integer x = 3730
integer y = 560
integer width = 439
integer height = 108
integer taborder = 170
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "이자계산(&A)"
end type

type st_2 from statictext within w_sal_04020
integer x = 5
integer y = 4
integer width = 466
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
string text = "[장기미수 조회]"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_3 from statictext within w_sal_04020
integer x = 91
integer y = 800
integer width = 585
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
string text = "[장기미수 신규등록]"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_4 from statictext within w_sal_04020
integer x = 2080
integer y = 800
integer width = 736
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
string text = "[장기미수 상환계획 등록]"
alignment alignment = center!
boolean focusrectangle = false
end type

type p_1 from uo_picture within w_sal_04020
integer x = 4069
integer y = 176
integer width = 178
boolean bringtotop = true
string picturename = "C:\erpman\image\이자계산_up.gif"
end type

event clicked;call super::clicked;Integer i
String  sRepDate, sMisuDate, sRepDate1, sRepDate2
Long    CurRow, PreRow
Double  lMisuAmt, lGigan, lWongum, lIjagum
Dec     dIjaRate

If dw_Insert.AcceptText() <> 1 Then Return
If dw_Insert1.AcceptText() <> 1 Then Return

If dw_insert1.RowCount() <= 0 Then Return

// 상환예정일자 Column Sort
dw_Insert1.SetRedraw(false)
dw_Insert1.SetSort("rep_date A")
dw_Insert1.Sort( )
dw_Insert1.SetRedraw(true)


sMisuDate = dw_Insert.GetItemString(1, 'long_misu_date')
lMisuAmt  = dw_Insert.GetItemNumber(1, 'long_misu_amt')
dIjaRate  = dw_Insert.GetItemNumber(1, 'ija_rate')

// 상환예상일자가 Null인경우 삭제
for i = 1 to dw_Insert1.RowCount()
	sRepdate = dw_Insert1.GetItemString(i, 'rep_date')
	if sRepdate = '' or isNull(sRepdate) then
      dw_Insert1.DeleteRow(i)
	end if
next

//*************************************************************************//
//***   상환이자 산출                                                   ***//
//***   이자금액 = 상환잔액 * 상환일자기간 / 365 * 이율 / 100           ***//
//*************************************************************************//
for CurRow = 1 to dw_Insert1.RowCount()
	sRepDate = dw_Insert1.GetItemString(CurRow, 'rep_date')
   if CurRow = 1 then
		lGigan = f_dayterm(sMisuDate, sRepDate)
		lWonGum = lMisuAmt
	else
  		PreRow = CurRow - 1
		sRepDate1 = dw_Insert1.GetItemString(PreRow, 'rep_date')
		lGigan = f_dayterm(sRepDate1, sRepDate) - 1
		lWonGum = lMisuAmt - dw_Insert1.getItemNumber(PreRow, 'ipgum_nu')
	end if
		
	lIjaGum = round(lWonGum * lGigan / 365 * dIjaRate * 0.01, 0)
	dw_Insert1.SetItem(CurRow, 'ija_amt', lIjaGum)
next

dw_Insert.SetItem(1, 'ija_amt', dw_Insert1.GetItemNumber(1, 'sum_ijaamt'))
end event

event ue_lbuttonup;call super::ue_lbuttonup;pictureName = "C:\erpman\image\이자계산_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;pictureName = "C:\erpman\image\이자계산_dn.gif"
end event

type p_ins2 from uo_picture within w_sal_04020
integer x = 4242
integer y = 176
integer width = 178
boolean bringtotop = true
string picturename = "C:\erpman\image\삽입_up.gif"
end type

event clicked;call super::clicked;String sCvCod, sLongMisuDate
Long   CurRow

dw_Insert.AcceptText()
sCvCod = dw_Insert.GetItemString(1, 'cvcod')
sLongMisuDate = dw_Insert.GetItemString(1, 'long_misu_date')

CurRow = dw_insert1.GetRow()

dw_insert1.InsertRow(CurRow)
	
dw_insert1.SetItem(CurRow, 'cvcod', sCvCod)
dw_insert1.SetItem(CurRow, 'long_misu_date', sLongMisuDate)
dw_insert1.SetItem(CurRow, 'rep_amt', 0)
dw_insert1.SetItem(CurRow, 'ija_amt', 0)
dw_insert1.SetItem(CurRow, 'gbn', '0')

dw_insert1.ScrollToRow(CurRow)
	
dw_insert1.setcolumn('rep_date')
dw_insert1.SetFocus()
	
w_mdi_frame.sle_msg.text = "상환계획을 입력하세요!!!"
end event

event ue_lbuttonup;call super::ue_lbuttonup;pictureName = "C:\erpman\image\삽입_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;pictureName = "C:\erpman\image\삽입_dn.gif"
end event

type p_del1 from uo_picture within w_sal_04020
integer x = 3767
integer y = 176
integer width = 306
boolean bringtotop = true
string picturename = "C:\erpman\image\상환계획ROW삭제_up.gif"
end type

event clicked;call super::clicked;Long   CurRow
String sRepDate

dw_insert1.AcceptText()
CurRow = dw_insert1.GetRow()

if CurRow <= 0 then Return

sRepDate = dw_insert1.GetItemString(CurRow, 'rep_date')

Beep (1)
if MessageBox('삭제 확인', '상환예정일 ' + Left(sRepDate,4) + '.' + Mid(sRepDate,5,2) + '.' + &
                           Right(sRepDate,2) + '의 상환계획을 삭제하시겠습니까? ' &
                           ,Exclamation!,yesno!, 2) = 2 then Return
	
dw_insert1.DeleteRow(CurRow)

if dw_insert1.Update() > 0 then
	Commit;
	if CurRow = 1 or CurRow <= dw_insert1.RowCount() then
	else
		dw_insert1.ScrollToRow(CurRow - 1)
		dw_insert1.SetFocus()
	end if
	
	ib_any_typing =False
	
	w_mdi_frame.sle_msg.text ="자료를 삭제하였습니다!!"
else
   f_Message_Chk(31, '[상환계획 삭제]')	
	RollBack;
	ib_any_typing =True
	Return
end if

end event

event ue_lbuttonup;call super::ue_lbuttonup;pictureName = "C:\erpman\image\상환계획ROW삭제_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;pictureName = "C:\erpman\image\상환계획ROW삭제_dn.gif"
end event

type pb_1 from u_pb_cal within w_sal_04020
integer x = 955
integer y = 1232
integer width = 82
integer height = 80
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_insert.SetColumn('long_misu_date')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_insert.SetItem(1, 'long_misu_date', gs_code)

end event

type rr_1 from roundrectangle within w_sal_04020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 60
integer width = 3675
integer height = 660
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_sal_04020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 820
integer width = 1906
integer height = 1468
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_sal_04020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1989
integer y = 816
integer width = 2551
integer height = 1468
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_4 from roundrectangle within w_sal_04020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2377
integer y = 1040
integer width = 1783
integer height = 1088
integer cornerheight = 40
integer cornerwidth = 55
end type

