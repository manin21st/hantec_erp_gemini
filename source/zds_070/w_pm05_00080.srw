$PBExportHeader$w_pm05_00080.srw
$PBExportComments$주간 생산계획 대비 실적현황
forward
global type w_pm05_00080 from w_standard_print
end type
type pb_1 from u_pb_cal within w_pm05_00080
end type
type rr_2 from roundrectangle within w_pm05_00080
end type
type rr_1 from roundrectangle within w_pm05_00080
end type
end forward

global type w_pm05_00080 from w_standard_print
string title = "주간 생산계획 대비 실적현황"
pb_1 pb_1
rr_2 rr_2
rr_1 rr_1
end type
global w_pm05_00080 w_pm05_00080

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sYymm, sPdtgu, sJocod

If dw_ip.AcceptText() <> 1 Then Return -1

sYymm = Trim(dw_ip.GetItemString(1, 'yymm'))
If IsNull(sYymm) Or sYymm = '' Then
	f_message_chk(1400,'')
	Return -1
End If

sPdtgu = Trim(dw_ip.GetItemString(1, 'pdtgu'))
If IsNull(sPdtgu) Or sPdtgu = '' Then
	f_message_chk(1400,'')
	Return -1
End If

sJocod = Trim(dw_ip.GetItemString(1, 'jocod'))
If IsNull(sJocod) Then sJocod = ''

IF dw_print.Retrieve(gs_sabu, syymm, sPdtgu, sJocod+'%') < 1 THEN
	f_message_chk(50,'')
	dw_ip.Setfocus()
	return -1
end if

dw_print.sharedata(dw_list)

// Argument 표시
String tx_name, tx_name1, tyymm

select to_char(to_date(:syymm,'yyyymmdd') + 6,'yyyymmdd') into :tyymm from dual;

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(pdtgu) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_pdtgu.text = '"+tx_name+"'")

tx_name1 = '( ' + Left(syymm,4)+'.'+Mid(syymm,5,2)+'.'+Right(syymm,2)+ &
           '-'+Left(tyymm,4)+'.'+Mid(tyymm,5,2)+'.'+Right(tyymm,2) + ' )'
dw_print.Modify("tx_ymd.text = '"+tx_name1+"'")

//tx_name = Trim(dw_ip.GetItemString(1, 'jonam'))
//If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_print.Modify("tx_jocod.text = '"+tx_name+"'")


return 1
end function

on w_pm05_00080.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.rr_2=create rr_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.rr_2
this.Control[iCurrent+3]=this.rr_1
end on

on w_pm05_00080.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.rr_2)
destroy(this.rr_1)
end on

event open;call super::open;String sDate, stoday

stoday = f_today()

select min(week_sdate) INTO :sDate from pdtweek where week_sdate <= :stoday and week_ldate >= :stoday;

dw_ip.SetItem(1, 'yymm', sDate)

// 반코드
f_child_saupj(dw_ip, 'jocod', '1')
end event

type p_preview from w_standard_print`p_preview within w_pm05_00080
end type

type p_exit from w_standard_print`p_exit within w_pm05_00080
end type

type p_print from w_standard_print`p_print within w_pm05_00080
end type

type p_retrieve from w_standard_print`p_retrieve within w_pm05_00080
end type







type st_10 from w_standard_print`st_10 within w_pm05_00080
end type



type dw_print from w_standard_print`dw_print within w_pm05_00080
string dataobject = "d_pm05_00080_2_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pm05_00080
integer x = 105
integer y = 96
integer width = 2336
integer height = 96
string dataobject = "d_pm05_00080_1"
end type

event dw_ip::itemchanged;String sDate, sData, sNull,sName

SetNull(sNull)

Choose Case GetColumnName()
	Case 'yymm'
		sDate = GetText()
		If DayNumber(Date( Left(sDate,4)+'-'+Mid(sDate,5,2) +'-'+Right(sDate,2) )) <> 2 Then
			MessageBox('확 인','주간 계획은 월요일부터 가능합니다.!!')
			Return 1
			Return
		End If
	Case 'jocod'
		sData = this.gettext()
		Select jonam into :sName From jomast
		Where jocod = :sData;
		if sqlca.sqlcode <> 0 then
		f_message_chk(33,'[반코드]')
			setitem(1, "jocod", sNull)
			setitem(1, "jonam", sNull)
			setcolumn("jocod")
			setfocus()
			Return 1					
		End if
		setitem(1, "jonam", sName)
End Choose
end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

event dw_ip::rbuttondown;call super::rbuttondown;//String sData
//long lrow
//
//SetNull(gs_code)
//SetNull(gs_codename)
//
//Choose Case GetColumnName()
//	 Case 'jocod'
//			Open(w_jomas_popup)
//			SetItem(1,'jocod',gs_code)
//			SetItem(1,'jonam',gs_codename)
//End Choose

String sNull, sdate

setnull(gs_code)
setnull(gs_gubun)
setnull(gs_codename)
setnull(snull)

IF this.GetColumnName() = "yymm" THEN
	sdate = trim(this.gettext())
	if f_datechk(sdate) = -1 then
		gs_code = left(f_today(),6)
	else
		gs_code = left(sdate,6)
	end if
//	Open(w_calendar_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then	return
	this.SetItem(1, "yymm", gs_Code)
END IF	

IF this.GetColumnName() = "jocod" THEN
	sdate = trim(this.GetText())
	Open(w_jomas_popup)
	
	IF isnull(gs_code) or gs_code = '' then return
	this.SetItem(1,"jocod",gs_code)
	this.SetItem(1,"jonam",gs_codename)
END IF

end event

type dw_list from w_standard_print`dw_list within w_pm05_00080
integer x = 73
integer y = 256
integer width = 4453
integer height = 2004
string dataobject = "d_pm05_00080_2"
boolean border = false
end type

event dw_list::rowfocuschanged;call super::rowfocuschanged;if currentrow > 0 then
	selectrow(0, false)
	selectrow(currentrow, true)
else
	selectrow(0, false)
end if

end event

type pb_1 from u_pb_cal within w_pm05_00080
integer x = 823
integer y = 96
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('yymm')
IF IsNull(gs_code) THEN Return
If dw_ip.Object.yymm.protect = '1' Or dw_ip.Object.yymm.TabSequence = '0' Then Return

dw_ip.SetItem(1, 'yymm', gs_code)
end event

type rr_2 from roundrectangle within w_pm05_00080
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 59
integer y = 52
integer width = 2405
integer height = 172
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within w_pm05_00080
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 252
integer width = 4471
integer height = 2016
integer cornerheight = 40
integer cornerwidth = 55
end type

