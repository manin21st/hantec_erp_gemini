$PBExportHeader$w_pm05_00170.srw
$PBExportComments$월 생산능력 일람표
forward
global type w_pm05_00170 from w_standard_print
end type
type rr_2 from roundrectangle within w_pm05_00170
end type
type rr_1 from roundrectangle within w_pm05_00170
end type
end forward

global type w_pm05_00170 from w_standard_print
string title = "월 생산능력 일람표"
rr_2 rr_2
rr_1 rr_1
end type
global w_pm05_00170 w_pm05_00170

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String syymm, sdate, edate, sPdtgu, sJocod, sCode
string sdate2, edate2, sdate3, edate3, syymm2, syymm3

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


sCode = Trim(dw_ip.GetItemString(1, 'pdtgu'))
If IsNull(sCode) Then sCode = ''

select min(week_sdate), max(week_edate) into :sdate, :edate from pdtweek where substr(week_sdate,1,6) = :syymm;

syymm2 = f_aftermonth(syymm,1)
syymm3 = f_aftermonth(syymm,2)

select min(week_sdate), max(week_edate) into :sdate2, :edate2 from pdtweek where substr(week_sdate,1,6) = :syymm2;
select min(week_sdate), max(week_edate) into :sdate3, :edate3 from pdtweek where substr(week_sdate,1,6) = :syymm3;

If dw_print.Retrieve(sDate, eDate, sPdtgu+'%', sdate2, edate2, sdate3, edate3, sJocod+'%') < 1 THEN
	f_message_chk(50,'')
	dw_ip.Setfocus()
	return -1
end if

dw_print.sharedata(dw_list)

// Argument 표시
String tx_name

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(pdtgu) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_pdtgu.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.GetItemString(1, 'jocod'))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_jocod.text = '"+tx_name+"'")


return 1
end function

on w_pm05_00170.create
int iCurrent
call super::create
this.rr_2=create rr_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
this.Control[iCurrent+2]=this.rr_1
end on

on w_pm05_00170.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_2)
destroy(this.rr_1)
end on

event open;call super::open;String sDate, stoday

stoday = f_today()

select min(week_sdate) INTO :sDate from pdtweek where week_sdate <= :stoday and week_ldate >= :stoday;

dw_ip.SetItem(1, 'yymm', LEFT(stoday,6))
end event

type p_xls from w_standard_print`p_xls within w_pm05_00170
integer x = 3543
end type

type p_sort from w_standard_print`p_sort within w_pm05_00170
integer x = 3365
end type

type p_preview from w_standard_print`p_preview within w_pm05_00170
end type

type p_exit from w_standard_print`p_exit within w_pm05_00170
end type

type p_print from w_standard_print`p_print within w_pm05_00170
end type

type p_retrieve from w_standard_print`p_retrieve within w_pm05_00170
end type







type st_10 from w_standard_print`st_10 within w_pm05_00170
end type



type dw_print from w_standard_print`dw_print within w_pm05_00170
string dataobject = "d_pm05_00170_2_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pm05_00170
integer x = 82
integer y = 96
integer width = 3218
integer height = 96
string dataobject = "d_pm05_00170_1"
end type

event dw_ip::itemchanged;String sDate, sData, sNull,sName

SetNull(sNull)

Choose Case GetColumnName()
	Case 'gubun'
		sData = this.gettext()
		if sData = '1' then
			dw_list.dataobject = 'd_pm05_00170_3_han'
			dw_print.dataobject = 'd_pm05_00170_3_han'
		else
			dw_list.dataobject = 'd_pm05_00170_2'
			dw_print.dataobject = 'd_pm05_00170_2_p'
		end if
		dw_list.settransobject(sqlca)
		dw_print.settransobject(sqlca)
		dw_print.ShareData(dw_list)

	Case 'yymm'
//		sDate = GetText()
//		If DayNumber(Date( Left(sDate,4)+'-'+Mid(sDate,5,2) +'-'+Right(sDate,2) )) <> 2 Then
//			MessageBox('확 인','주간 계획은 월요일부터 가능합니다.!!')
//			Return 1
//			Return
//		End If
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

event dw_ip::rbuttondown;call super::rbuttondown;String sData
long lrow

SetNull(gs_code)
SetNull(gs_codename)

Choose Case GetColumnName()
	 Case 'jocod'
			Open(w_jomas_popup)
			SetItem(1,'jocod',gs_code)
			SetItem(1,'jonam',gs_codename)
End Choose
end event

type dw_list from w_standard_print`dw_list within w_pm05_00170
integer x = 73
integer y = 256
integer width = 4453
integer height = 2004
string dataobject = "d_pm05_00170_2"
boolean border = false
end type

event dw_list::rowfocuschanged;call super::rowfocuschanged;if currentrow > 0 then
	selectrow(0, false)
	selectrow(currentrow, true)
else
	selectrow(0, false)
end if

end event

type rr_2 from roundrectangle within w_pm05_00170
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 59
integer y = 52
integer width = 3264
integer height = 172
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within w_pm05_00170
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

