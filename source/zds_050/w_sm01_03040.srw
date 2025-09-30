$PBExportHeader$w_sm01_03040.srw
$PBExportComments$주간 판매계획 일람표
forward
global type w_sm01_03040 from w_standard_print
end type
type rr_2 from roundrectangle within w_sm01_03040
end type
type rr_1 from roundrectangle within w_sm01_03040
end type
end forward

global type w_sm01_03040 from w_standard_print
string title = "주간 판매계획 일람표"
rr_2 rr_2
rr_1 rr_1
end type
global w_sm01_03040 w_sm01_03040

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sYymm, sdate, edate
String sSaupj, tx_name

If dw_ip.AcceptText() <> 1 Then Return -1

sYymm = Trim(dw_ip.GetItemString(1, 'yymm'))
If IsNull(sYymm) Or sYymm = '' Then
	f_message_chk(1400,'')
	Return -1
End If

/* 사업장 체크 */
sSaupj= Trim(dw_ip.GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_ip.SetFocus()
	dw_ip.SetColumn('saupj')
	Return -1
End If

If dw_ip.GetItemString(1, 'cust') = '1' Then
	IF dw_print.Retrieve(sSaupj, syymm) < 1 THEN
		f_message_chk(50,'')
		dw_ip.Setfocus()
		return -1
	end if
	
	SELECT WEEK_SDATE, WEEK_LDATE INTO :sdate, :edate FROM PDTWEEK WHERE WEEK_SDATE = :syymm;
	
	dw_print.Object.t_sdate.text = String(sdate,'@@@@.@@.@@')
	dw_print.Object.t_tdate.text = String(edate,'@@@@.@@.@@')
Else
	IF dw_print.Retrieve(sSaupj, syymm) < 1 THEN
		f_message_chk(50,'')
		dw_ip.Setfocus()
		return -1
	end if	
end If

dw_print.sharedata(dw_list)

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(saupj) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_saupj.text = '"+tx_name+"'")

return 1
end function

on w_sm01_03040.create
int iCurrent
call super::create
this.rr_2=create rr_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
this.Control[iCurrent+2]=this.rr_1
end on

on w_sm01_03040.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_2)
destroy(this.rr_1)
end on

event open;call super::open;f_mod_saupj(dw_ip, 'saupj')

/* 최종계획년월을 셋팅 */
String sDate
select MAX(YYMMDD) INTO :sDate from SM03_WEEKPLAN_ITEM WHERE SAUPJ = :gs_saupj;

dw_IP.SetItem(1, 'yymm', sDate)
end event

type p_preview from w_standard_print`p_preview within w_sm01_03040
end type

type p_exit from w_standard_print`p_exit within w_sm01_03040
end type

type p_print from w_standard_print`p_print within w_sm01_03040
end type

type p_retrieve from w_standard_print`p_retrieve within w_sm01_03040
end type







type st_10 from w_standard_print`st_10 within w_sm01_03040
end type



type dw_print from w_standard_print`dw_print within w_sm01_03040
string dataobject = "d_sm01_03040_2_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sm01_03040
integer x = 105
integer y = 96
integer width = 2473
integer height = 96
string dataobject = "d_sm01_03040_1"
end type

event dw_ip::itemchanged;String sDate

Choose Case GetColumnName()
	Case 'yymm'
		sDate = GetText()
		
		If DayNumber(Date( Left(sDate,4)+'-'+Mid(sDate,5,2) +'-'+Right(sDate,2) )) <> 2 Then
			MessageBox('확 인','주간 판매계획은 월요일부터 가능합니다.!!')
			Return 1
			Return
		End If
	Case 'cust'
		If GetText() = '1' Then
			dw_list.DataObject = 'd_sm01_03040_2'
			dw_print.DataObject = 'd_sm01_03040_2_p'
		Else
			dw_list.DataObject = 'd_sm01_03040_3'
			dw_print.DataObject = 'd_sm01_03040_3_p'
		End If
		dw_list.SetTransObject(sqlca)
		dw_print.SetTransObject(sqlca)
End Choose
end event

type dw_list from w_standard_print`dw_list within w_sm01_03040
integer x = 73
integer y = 256
integer width = 4512
integer height = 2004
string dataobject = "d_sm01_03040_2"
boolean border = false
end type

event dw_list::clicked;call super::clicked;If Row <= 0 then
	SelectRow(0,False)
ELSE
	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
END IF
end event

type rr_2 from roundrectangle within w_sm01_03040
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 16777215
integer x = 59
integer y = 52
integer width = 2569
integer height = 172
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within w_sm01_03040
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 252
integer width = 4553
integer height = 2016
integer cornerheight = 40
integer cornerwidth = 55
end type

