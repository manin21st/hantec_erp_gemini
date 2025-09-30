$PBExportHeader$w_pm05_00180.srw
$PBExportComments$주간 생산능력 일람표
forward
global type w_pm05_00180 from w_standard_print
end type
type pb_3 from u_pb_cal within w_pm05_00180
end type
type rr_2 from roundrectangle within w_pm05_00180
end type
type rr_1 from roundrectangle within w_pm05_00180
end type
end forward

global type w_pm05_00180 from w_standard_print
string title = "주간 생산능력 일람표"
pb_3 pb_3
rr_2 rr_2
rr_1 rr_1
end type
global w_pm05_00180 w_pm05_00180

forward prototypes
public function integer wf_retrieve ()
public function integer wf_afterday ()
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

eDate = f_afterday(syymm, 6)

If dw_print.Retrieve(syymm, eDate, sPdtgu+'%', sJocod+'%') < 1 THEN
	f_message_chk(50,'')
	dw_ip.Setfocus()
	return -1
end if

wf_afterday()

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

public function integer wf_afterday ();string sdate
string s_d0,s_d1,s_d2,s_d3,s_d4,s_d5,s_d6,s_d7,s_d8,s_d9
dw_ip.accepttext()
sdate =  Trim(dw_ip.GetItemString(1, 'yymm'))

s_d0 = mid(f_afterday(sdate,0),5,4)
s_d1 = mid(f_afterday(sdate,1),5,4)
s_d2 = mid(f_afterday(sdate,2),5,4)
s_d3 = mid(f_afterday(sdate,3),5,4)
s_d4= mid(f_afterday(sdate,4),5,4)
s_d5 = mid(f_afterday(sdate,5),5,4)
s_d6= mid(f_afterday(sdate,6),5,4)
s_d7 = mid(f_afterday(sdate,7),5,4)
s_d8 = mid(f_afterday(sdate,8),5,4)
s_d9 = mid(f_afterday(sdate,9),5,4)

//datawindow 안에 text 로 날짜를 입력
dW_list.object.td_0.text = mid(s_d0,1,2) + " / " + mid(s_d0,3,2)
dW_list.object.td_1.text = mid(s_d1,1,2) + " / " + mid(s_d1,3,2)
dW_list.object.td_2.text = mid(s_d2,1,2) + " / " + mid(s_d2,3,2)
dW_list.object.td_3.text = mid(s_d3,1,2) + " / " + mid(s_d3,3,2)
dW_list.object.td_4.text = mid(s_d4,1,2) + " / " + mid(s_d4,3,2)
dW_list.object.td_5.text = mid(s_d5,1,2) + " / " + mid(s_d5,3,2)
dW_list.object.td_6.text = mid(s_d6,1,2) + " / " + mid(s_d6,3,2)
dW_list.object.td_7.text = mid(s_d7,1,2) + " / " + mid(s_d7,3,2)
dW_list.object.td_8.text = mid(s_d8,1,2) + " / " + mid(s_d8,3,2)
dW_list.object.td_9.text = mid(s_d9,1,2) + " / " + mid(s_d9,3,2)






return -1
end function

on w_pm05_00180.create
int iCurrent
call super::create
this.pb_3=create pb_3
this.rr_2=create rr_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_3
this.Control[iCurrent+2]=this.rr_2
this.Control[iCurrent+3]=this.rr_1
end on

on w_pm05_00180.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_3)
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

type p_xls from w_standard_print`p_xls within w_pm05_00180
end type

type p_sort from w_standard_print`p_sort within w_pm05_00180
end type

type p_preview from w_standard_print`p_preview within w_pm05_00180
end type

type p_exit from w_standard_print`p_exit within w_pm05_00180
end type

type p_print from w_standard_print`p_print within w_pm05_00180
end type

type p_retrieve from w_standard_print`p_retrieve within w_pm05_00180
end type







type st_10 from w_standard_print`st_10 within w_pm05_00180
end type



type dw_print from w_standard_print`dw_print within w_pm05_00180
string dataobject = "d_pm05_00180_4_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pm05_00180
integer x = 105
integer y = 96
integer width = 2455
integer height = 96
string dataobject = "d_pm05_00180_1"
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
	Case 'gub'
		If gettext() = '1' Then
			dw_print.DataObject = 'd_pm05_00180_3_p'	// 작업장
			dw_list.DataObject = 'd_pm05_00180_3'
		Else
			dw_print.DataObject = 'd_pm05_00180_2_p'	// 설비별
			dw_list.DataObject = 'd_pm05_00180_2'
		End If
		dw_print.SetTransObject(sqlca)
		dw_list.SetTransObject(sqlca)
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

type dw_list from w_standard_print`dw_list within w_pm05_00180
integer x = 73
integer y = 256
integer width = 4453
integer height = 2004
string dataobject = "d_pm05_00180_4"
boolean border = false
end type

event dw_list::rowfocuschanged;call super::rowfocuschanged;if currentrow > 0 then
	selectrow(0, false)
	selectrow(currentrow, true)
else
	selectrow(0, false)
end if

end event

type pb_3 from u_pb_cal within w_pm05_00180
integer x = 773
integer y = 96
integer height = 76
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('yymm')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'yymm', gs_code)

end event

type rr_2 from roundrectangle within w_pm05_00180
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 59
integer y = 52
integer width = 2542
integer height = 172
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within w_pm05_00180
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

