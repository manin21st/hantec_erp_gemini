$PBExportHeader$w_mat_01350_imsi.srw
$PBExportComments$입고LOT라벨 팝업 - 기존재고 라벨 발행용(임시)
forward
global type w_mat_01350_imsi from w_inherite_popup
end type
type pb_1 from u_pb_cal within w_mat_01350_imsi
end type
type pb_2 from u_pb_cal within w_mat_01350_imsi
end type
type rr_1 from roundrectangle within w_mat_01350_imsi
end type
end forward

global type w_mat_01350_imsi from w_inherite_popup
integer x = 233
integer y = 188
integer width = 3506
integer height = 2076
string title = "기존재고 라벨 조회 선택 - COIL"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_mat_01350_imsi w_mat_01350_imsi

on w_mat_01350_imsi.create
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

on w_mat_01350_imsi.destroy
call super::destroy
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_jogun.SetTransObject(SQLCA)
dw_jogun.Reset()
dw_jogun.InsertRow(0)

end event

type dw_jogun from w_inherite_popup`dw_jogun within w_mat_01350_imsi
boolean visible = false
integer y = 28
integer width = 2318
integer height = 136
string dataobject = "d_mat_01350_imsi_0"
end type

event dw_jogun::itemchanged;call super::itemchanged;String snull

SetNull(snull)

IF	this.getcolumnname() = "fr_date"		THEN

	IF f_datechk(trim(this.gettext())) = -1	then
		this.setitem(1, "fr_date", sNull)
		return 1
	END IF
ELSEIF	this.getcolumnname() = "to_date"		THEN

	IF f_datechk(trim(this.gettext())) = -1	then
		this.setitem(1, "to_date", sNull)
		return 1
	END IF
END IF
end event

event dw_jogun::itemerror;call super::itemerror;RETURN 1
end event

type p_exit from w_inherite_popup`p_exit within w_mat_01350_imsi
integer x = 3241
integer y = 16
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_mat_01350_imsi
integer x = 2894
integer y = 16
end type

event p_inq::clicked;call super::clicked;String		ls_path, ls_filenm

// 네트워크 파일공유 폴더를 검색
SELECT DATANAME
   INTO :ls_path
  FROM SYSCNFG
WHERE SYSGU = 'C' AND SERIAL = 12 AND LINENO = '5';

If Not DirectoryExists(ls_path) Then
	MessageBox ("ERROR", "Directory " + ls_path + " does not exist" )
	Return -1
End If

//ls_path = "\\Gate1\DATA\TAEHUNG\DATA\2015\04\"	/* 자동화창고 공유폴더 경로	*/
//ls_filenm = ls_path + "\if_coil_in_" + Mid(ls_today, 3) + ".csv"		/* LOCAL TEST용	*/
ls_filenm = ls_path + "\2015\04\if_coil_in_150400.csv"

dw_1.ReSet()

dw_1.SetRedraw(False)
If FileExists(ls_filenm) Then
	If dw_1.ImportFile(ls_filenm) < 0 Then
		MessageBox("ERROR", "자동화창고 FILE IMPORT 오류 발생!")
		Return -1
	End If
End If
dw_1.DeleteRow(1)
dw_1.Filter()
dw_1.Sort()
dw_1.SetRedraw(True)

end event

type p_choose from w_inherite_popup`p_choose within w_mat_01350_imsi
integer x = 3067
integer y = 16
end type

event p_choose::clicked;call super::clicked;gs_code = 'Y'
SetPointer(HourGlass!)
// Copy the data to the clipboard
dw_1.SaveAs("", Clipboard!, False)
Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_mat_01350_imsi
integer x = 32
integer y = 196
integer width = 3415
integer height = 1740
string dataobject = "d_mat_01350_imsi_1"
boolean hscrollbar = true
end type

event dw_1::clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

event dw_1::doubleclicked;IF Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

gs_code= dw_1.GetItemString(Row, "imhist_iojpno")  


Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_mat_01350_imsi
boolean visible = false
integer x = 1161
integer y = 2136
integer width = 1001
end type

type cb_1 from w_inherite_popup`cb_1 within w_mat_01350_imsi
integer x = 745
integer y = 2100
end type

type cb_return from w_inherite_popup`cb_return within w_mat_01350_imsi
integer x = 1367
integer y = 2100
integer taborder = 40
end type

type cb_inq from w_inherite_popup`cb_inq within w_mat_01350_imsi
integer x = 1056
integer y = 2100
integer taborder = 20
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_mat_01350_imsi
boolean visible = false
integer x = 498
integer y = 2136
integer width = 425
integer limit = 15
end type

type st_1 from w_inherite_popup`st_1 within w_mat_01350_imsi
boolean visible = false
integer x = 229
integer y = 2156
integer width = 251
string text = "품목코드"
alignment alignment = left!
end type

type pb_1 from u_pb_cal within w_mat_01350_imsi
boolean visible = false
integer x = 1705
integer y = 56
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_jogun.Setcolumn('fr_Date')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_jogun.SetItem(1, 'fr_Date', gs_code)
end event

type pb_2 from u_pb_cal within w_mat_01350_imsi
boolean visible = false
integer x = 2158
integer y = 56
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_jogun.Setcolumn('to_Date')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_jogun.SetItem(1, 'to_Date', gs_code)
end event

type rr_1 from roundrectangle within w_mat_01350_imsi
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 188
integer width = 3438
integer height = 1756
integer cornerheight = 40
integer cornerwidth = 55
end type

