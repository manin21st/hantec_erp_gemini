$PBExportHeader$w_sg_10010.srw
$PBExportComments$개인별 컴퓨터 관리표
forward
global type w_sg_10010 from w_inherite
end type
type dw_2 from datawindow within w_sg_10010
end type
type tab_1 from tab within w_sg_10010
end type
type tabpage_1 from userobject within tab_1
end type
type rr_1 from roundrectangle within tabpage_1
end type
type r_1 from rectangle within tabpage_1
end type
type r_2 from rectangle within tabpage_1
end type
type st_10 from statictext within tabpage_1
end type
type st_9 from statictext within tabpage_1
end type
type st_7 from statictext within tabpage_1
end type
type st_8 from statictext within tabpage_1
end type
type st_4 from statictext within tabpage_1
end type
type st_3 from statictext within tabpage_1
end type
type st_2 from statictext within tabpage_1
end type
type dw_6 from datawindow within tabpage_1
end type
type dw_5 from datawindow within tabpage_1
end type
type dw_1 from datawindow within tabpage_1
end type
type tabpage_1 from userobject within tab_1
rr_1 rr_1
r_1 r_1
r_2 r_2
st_10 st_10
st_9 st_9
st_7 st_7
st_8 st_8
st_4 st_4
st_3 st_3
st_2 st_2
dw_6 dw_6
dw_5 dw_5
dw_1 dw_1
end type
type tabpage_2 from userobject within tab_1
end type
type rr_2 from roundrectangle within tabpage_2
end type
type dw_7 from datawindow within tabpage_2
end type
type dw_3 from datawindow within tabpage_2
end type
type tabpage_2 from userobject within tab_1
rr_2 rr_2
dw_7 dw_7
dw_3 dw_3
end type
type tabpage_3 from userobject within tab_1
end type
type rr_3 from roundrectangle within tabpage_3
end type
type dw_4 from datawindow within tabpage_3
end type
type tabpage_3 from userobject within tab_1
rr_3 rr_3
dw_4 dw_4
end type
type tab_1 from tab within w_sg_10010
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type
type cb_1 from commandbutton within w_sg_10010
end type
end forward

global type w_sg_10010 from w_inherite
integer height = 2824
string title = "개인별 컴퓨터 정보관리"
dw_2 dw_2
tab_1 tab_1
cb_1 cb_1
end type
global w_sg_10010 w_sg_10010

on w_sg_10010.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.tab_1=create tab_1
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.tab_1
this.Control[iCurrent+3]=this.cb_1
end on

on w_sg_10010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_2)
destroy(this.tab_1)
destroy(this.cb_1)
end on

type dw_insert from w_inherite`dw_insert within w_sg_10010
boolean visible = false
integer x = 2958
integer y = 44
integer width = 128
integer height = 116
boolean enabled = false
end type

type p_delrow from w_inherite`p_delrow within w_sg_10010
boolean visible = false
integer x = 2770
integer y = 32
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_sg_10010
boolean visible = false
integer x = 2597
integer y = 32
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_sg_10010
boolean visible = false
integer x = 2414
integer y = 32
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_sg_10010
integer x = 3698
end type

event p_ins::clicked;call super::clicked;tab_1.tabpage_1.dw_1.ReSet()
tab_1.tabpage_1.dw_5.ReSet()
tab_1.tabpage_1.dw_6.ReSet()

tab_1.tabpage_1.dw_1.SetTransObject(SQLCA)
tab_1.tabpage_1.dw_5.SetTransObject(SQLCA)
tab_1.tabpage_1.dw_6.SetTransObject(SQLCA)
tab_1.tabpage_1.dw_1.InsertRow(0)
tab_1.tabpage_1.dw_5.InsertRow(0)
tab_1.tabpage_1.dw_6.InsertRow(0)
end event

type p_exit from w_inherite`p_exit within w_sg_10010
integer x = 4393
end type

type p_can from w_inherite`p_can within w_sg_10010
integer x = 4219
end type

event p_can::clicked;call super::clicked;tab_1.tabpage_1.dw_1.ReSet()
tab_1.tabpage_1.dw_1.ReSet()
tab_1.tabpage_1.dw_1.ReSet()

tab_1.tabpage_1.dw_1.SetTransObject(SQLCA)
tab_1.tabpage_1.dw_1.InsertRow(0)
tab_1.tabpage_1.dw_5.SetTransObject(SQLCA)
tab_1.tabpage_1.dw_6.SetTransObject(SQLCA)

end event

type p_print from w_inherite`p_print within w_sg_10010
integer x = 3264
boolean enabled = false
string picturename = "C:\erpman\image\미리보기_d.gif"
end type

event p_print::clicked;//
//OpenWithParm(w_print_options, tab_1.tabpage_3.dw_4)
OpenWithParm(w_print_preview, tab_1.tabpage_3.dw_4)

end event

event p_print::ue_lbuttondown;//
PictureName = "C:\erpman\image\미리보기_dn.gif"
end event

event p_print::ue_lbuttonup;//
PictureName = "C:\erpman\image\미리보기_up.gif"
end event

type p_inq from w_inherite`p_inq within w_sg_10010
integer x = 3525
end type

event p_inq::clicked;call super::clicked;tab_1.tabpage_1.dw_1.AcceptText()
dw_2.AcceptText()

String ls_dept
String ls_emp

If tab_1.SelectedTab = 1 Then	
	Long   row

	row = tab_1.tabpage_1.dw_1.GetRow()
	If row < 1 Then Return
	
	ls_emp = tab_1.tabpage_1.dw_1.GetItemString(row, 'empno')
	If Trim(ls_emp) = '' OR IsNull(ls_emp) Then
		MessageBox('사용자 확인', '사용자를 입력하십시오.')
		tab_1.tabpage_1.dw_1.SetColumn('empno')
		tab_1.tabpage_1.dw_1.SetFocus()
		Return
	End If
	tab_1.tabpage_1.dw_1.Retrieve(ls_emp)
	
	tab_1.tabpage_1.dw_5.SetRedraw(False)
	tab_1.tabpage_1.dw_6.SetRedraw(False)
	
	tab_1.tabpage_1.dw_5.Retrieve(ls_emp)
	tab_1.tabpage_1.dw_6.Retrieve(ls_emp)
	
	tab_1.tabpage_1.dw_5.SetRedraw(True)
	tab_1.tabpage_1.dw_6.SetRedraw(True)
	
	If tab_1.tabpage_1.dw_1.RowCount() < 1 Then
		tab_1.tabpage_1.dw_1.InsertRow(0)
	End If
ElseIf tab_1.SelectedTab = 2 Then
	ls_dept = dw_2.GetItemString(dw_2.GetRow(), 'dept')
	If Trim(ls_dept) = '' OR IsNull(ls_dept) Then ls_dept = '%'
	
	tab_1.tabpage_2.dw_3.SetRedraw(False)
	tab_1.tabpage_2.dw_3.Retrieve(ls_dept)
	tab_1.tabpage_2.dw_3.SetRedraw(True)
ElseIf tab_1.SelectedTab = 3 Then
	ls_dept = dw_2.GetItemString(1, 'dept')
	If Trim(ls_dept) = '' OR IsNull(ls_dept) Then ls_dept = '%'
	
	ls_emp = dw_2.GetItemString(1, 'empno')
	If Trim(ls_emp) = '' OR IsNull(ls_emp) Then ls_emp = '%'
	
	tab_1.tabpage_3.dw_4.SetRedraw(False)
	tab_1.tabpage_3.dw_4.Retrieve(ls_dept, ls_emp)
	tab_1.tabpage_3.dw_4.SetRedraw(True)
End If
end event

type p_del from w_inherite`p_del within w_sg_10010
integer x = 4046
end type

event p_del::clicked;call super::clicked;tab_1.tabpage_1.dw_1.AcceptText()

Long   row

row = tab_1.tabpage_1.dw_1.GetRow()
If row < 1 Then Return

String ls_emp

ls_emp = tab_1.tabpage_1.dw_1.GetItemString(row, 'empno')
If Trim(ls_emp) = '' OR IsNull(ls_emp) Then
	MessageBox('삭제자료 없음', '삭제할 자료가 없습니다.')
	Return
End If

If MessageBox('자료 삭제 확인', '개인정보, PC정보, Hard/SoftWare 자료 전체가 삭제 됩니다.~r~r~n~n계속 하시겠습니까?') <> 1 Then Return

DELETE FROM SG_SW
 WHERE EMPNO = :ls_emp ;
If SQLCA.SQLCODE <> 0 Then
	ROLLBACK USING SQLCA;
	MessageBox('삭제 실패', 'SoftWare 자료 삭제 중 오류가 발생했습니다.')
	Return
End If

DELETE FROM SG_HW
 WHERE EMPNO = :ls_emp ;
If SQLCA.SQLCODE <> 0 Then
	ROLLBACK USING SQLCA;
	MessageBox('삭제 실패', 'HardWare 자료 삭제 중 오류가 발생했습니다.')
	Return
End If

DELETE FROM SG_EMPPC
 WHERE EMPNO = :ls_emp ;
If SQLCA.SQLCODE = 0 Then
	COMMIT USING SQLCA;
	MessageBox('삭제 성공', '자료가 정상적으로 삭제 되었습니다.')
Else
	ROLLBACK USING SQLCA;
	MessageBox('삭제 실패', '자료 삭제 중 오류가 발생했습니다.')
	Return
End If

end event

type p_mod from w_inherite`p_mod within w_sg_10010
integer x = 3872
end type

event p_mod::clicked;call super::clicked;tab_1.tabpage_1.dw_1.AcceptText()
tab_1.tabpage_1.dw_5.AcceptText()
tab_1.tabpage_1.dw_6.AcceptText()

String ls_emp

ls_emp = tab_1.tabpage_1.dw_1.GetItemString(1, 'empno')
If Trim(ls_emp) = '' OR IsNull(ls_emp) Then
	MessageBox('사용자 확인', '사용자를 확인하십시오.')
	tab_1.tabpage_1.dw_1.SetColumn('empno')
	tab_1.tabpage_1.dw_1.SetFocus()
	Return
End If

Long   ll_cnt
Long   i

ll_cnt = tab_1.tabpage_1.dw_5.RowCount()

Long   ll_max

SELECT MAX(SEQ)
  INTO :ll_max
  FROM SG_SW
 WHERE EMPNO = :ls_emp ;
If IsNull(ll_max) OR ll_max = 0 Then
	ll_max = 1
Else
	ll_max = ll_max + 1
End If

For i = 1 To ll_cnt
	String ls_swseq
	ls_swseq = tab_1.tabpage_1.dw_5.GetItemString(i, 'seq')
	If Trim(ls_swseq) = '' OR IsNull(ls_swseq) Then
		tab_1.tabpage_1.dw_5.SetItem(i, 'seq', String(ll_max, '000'))
		ll_max = ll_max + i
	End If
Next

SetNull(ll_cnt)
SetNull(i)

ll_cnt = tab_1.tabpage_1.dw_6.RowCount()

SetNull(ll_max)

SELECT MAX(SEQ)
  INTO :ll_max
  FROM SG_HW
 WHERE EMPNO = :ls_emp ;
If IsNull(ll_max) OR ll_max = 0 Then
	ll_max = 1
Else
	ll_max = ll_max + 1
End If

For i = 1 To ll_cnt
	String ls_hwseq
	ls_hwseq = tab_1.tabpage_1.dw_6.GetItemString(i, 'seq')
	If Trim(ls_hwseq) = '' OR IsNull(ls_hwseq) Then
		tab_1.tabpage_1.dw_6.SetItem(i, 'seq', String(ll_max, '000'))
		ll_max = ll_max + i
	End If
Next

If tab_1.tabpage_1.dw_5.UPDATE() <> 1 Then
	ROLLBACK USING SQLCA;
	MessageBox('SoftWare List UPDATE Fail', 'SoftWare 목록 저장 중 오류가 발생했습니다.')
	Return
End If

If tab_1.tabpage_1.dw_6.UPDATE() <> 1 Then
	ROLLBACK USING SQLCA;
	MessageBox('HardWare List UPDATE Fail', 'HardWare 목록 저장 중 오류가 발생했습니다.')
	Return
End If

If tab_1.tabpage_1.dw_1.UPDATE() = 1 Then
	COMMIT USING SQLCA;
	MessageBox('저장 확인', '자료가 성공적으로 저장 되었습니다.')
Else
	ROLLBACK USING SQLCA;
	MessageBox('저장 실패', '자료 저장 중 오류가 발생했습니다.')
	Return
End If

end event

type cb_exit from w_inherite`cb_exit within w_sg_10010
end type

type cb_mod from w_inherite`cb_mod within w_sg_10010
end type

type cb_ins from w_inherite`cb_ins within w_sg_10010
end type

type cb_del from w_inherite`cb_del within w_sg_10010
end type

type cb_inq from w_inherite`cb_inq within w_sg_10010
end type

type cb_print from w_inherite`cb_print within w_sg_10010
end type

type st_1 from w_inherite`st_1 within w_sg_10010
end type

type cb_can from w_inherite`cb_can within w_sg_10010
end type

type cb_search from w_inherite`cb_search within w_sg_10010
end type







type gb_button1 from w_inherite`gb_button1 within w_sg_10010
end type

type gb_button2 from w_inherite`gb_button2 within w_sg_10010
end type

type dw_2 from datawindow within w_sg_10010
integer x = 37
integer y = 32
integer width = 2085
integer height = 164
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_sg_10010_999"
boolean border = false
boolean livescroll = true
end type

event itemchanged;If row < 1 Then Return

String ls_data
String ls_code

Choose Case dwo.name
	Case 'dept'
		SELECT FUN_GET_CVNAS(:data)
		  INTO :ls_data
		  FROM DUAL ;
		
		This.SetItem(row, 'deptnm', ls_data)		
	
	Case 'empno'
		SELECT EMPNAME, DEPTCODE
		  INTO :ls_data, :ls_code
		  FROM P1_MASTER
		 WHERE EMPNO = :data ;
		If Trim(ls_data) = '' OR IsNull(ls_data) Then
			MessageBox('사번확인', '등록된 사번이 아닙니다.')
			Return
		End If
		
		This.SetItem(row, 'empnm' , ls_data)
		This.SetItem(row, 'dept'  , ls_code)
		This.SetItem(row, 'deptnm', f_get_name5('11', ls_code, ''))
		
End Choose
end event

event rbuttondown;If row < 1 Then Return

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

String ls_data

Choose Case dwo.name		
	Case 'dept'
		gs_gubun = '4'
		Open(w_vndmst_popup)
		
		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
		
		This.SetItem(row, 'dept'  , gs_code    )
		This.SetItem(row, 'deptnm', gs_codename)
	
	
	Case 'empno'
		Open(w_sawon_popup)
		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
		
		SELECT DEPTCODE
		  INTO :ls_data
		  FROM P1_MASTER
		 WHERE EMPNO = :gs_code ;
				
		This.SetItem(row, 'empno', gs_code    )
		This.SetItem(row, 'empnm', gs_codename)
		
		This.SetItem(row, 'dept'  , ls_data    )
		This.SetItem(row, 'deptnm', f_get_name5('11', ls_data, ''))
End Choose
end event

event constructor;This.SetTransObject(SQLCA)
This.InsertRow(0)
end event

type tab_1 from tab within w_sg_10010
integer x = 37
integer y = 212
integer width = 4558
integer height = 2120
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
end on

event selectionchanged;Choose Case newindex
	Case 1
		dw_2.Enabled = False
		dw_2.Modify("empno.Visible = False")
		dw_2.Modify("t_1.Visible   = False")
		dw_2.Modify("empnm.Visible = False")
		dw_2.Modify("p_2.Visible   = False")
		
		p_print.Enabled = False
		p_print.PictureName = 'C:\erpman\image\미리보기_d.gif'
	Case 2
		dw_2.Enabled = True
		dw_2.Modify("empno.Visible = False")
		dw_2.Modify("t_1.Visible   = False")
		dw_2.Modify("empnm.Visible = False")
		dw_2.Modify("p_2.Visible   = False")
		
		p_print.Enabled = False
		p_print.PictureName = 'C:\erpman\image\미리보기_d.gif'
	Case 3
		dw_2.Enabled = True
		dw_2.Modify("empno.Visible = True")
		dw_2.Modify("t_1.Visible   = True")
		dw_2.Modify("empnm.Visible = True")
		dw_2.Modify("p_2.Visible   = True")
		
		p_print.Enabled = True
		p_print.PictureName = 'C:\erpman\image\미리보기_up.gif'
End Choose
end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 4521
integer height = 1992
long backcolor = 33027312
string text = "등록 및 수정"
long tabtextcolor = 33554432
long tabbackcolor = 33027312
string picturename = "C:\ERPMAN\image\files_edit.ico"
long picturemaskcolor = 536870912
string powertiptext = "신규 입사자 또는 PC 재 사용일 경우 자료를 등록 및 수정하는 곳입니다."
rr_1 rr_1
r_1 r_1
r_2 r_2
st_10 st_10
st_9 st_9
st_7 st_7
st_8 st_8
st_4 st_4
st_3 st_3
st_2 st_2
dw_6 dw_6
dw_5 dw_5
dw_1 dw_1
end type

on tabpage_1.create
this.rr_1=create rr_1
this.r_1=create r_1
this.r_2=create r_2
this.st_10=create st_10
this.st_9=create st_9
this.st_7=create st_7
this.st_8=create st_8
this.st_4=create st_4
this.st_3=create st_3
this.st_2=create st_2
this.dw_6=create dw_6
this.dw_5=create dw_5
this.dw_1=create dw_1
this.Control[]={this.rr_1,&
this.r_1,&
this.r_2,&
this.st_10,&
this.st_9,&
this.st_7,&
this.st_8,&
this.st_4,&
this.st_3,&
this.st_2,&
this.dw_6,&
this.dw_5,&
this.dw_1}
end on

on tabpage_1.destroy
destroy(this.rr_1)
destroy(this.r_1)
destroy(this.r_2)
destroy(this.st_10)
destroy(this.st_9)
destroy(this.st_7)
destroy(this.st_8)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.dw_6)
destroy(this.dw_5)
destroy(this.dw_1)
end on

type rr_1 from roundrectangle within tabpage_1
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 23
integer y = 24
integer width = 4480
integer height = 1960
integer cornerheight = 40
integer cornerwidth = 55
end type

type r_1 from rectangle within tabpage_1
long linecolor = 8388608
integer linethickness = 6
long fillcolor = 33027312
integer x = 46
integer y = 1068
integer width = 2199
integer height = 896
end type

type r_2 from rectangle within tabpage_1
long linecolor = 8388608
integer linethickness = 6
long fillcolor = 33027312
integer x = 2277
integer y = 1068
integer width = 2199
integer height = 896
end type

type st_10 from statictext within tabpage_1
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 1929
integer y = 952
integer width = 238
integer height = 84
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 16777215
long backcolor = 8421504
string text = "삭제"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event ue_lbuttondown;This.BorderStyle = StyleLowered!
end event

event ue_lbuttonup;This.BorderStyle = StyleRaised!
end event

event clicked;Long   row

row = tab_1.tabpage_1.dw_5.GetRow()
If row < 1 Then Return

If f_msg_delete() <> 1 Then Return

tab_1.tabpage_1.dw_5.DeleteRow(row)

If tab_1.tabpage_1.dw_5.UPDATE() = 1 Then
	COMMIT USING SQLCA;
Else
	ROLLBACK USING SQLCA;
	MessageBox('삭제 실패', '삭제 중 오류가 발생했습니다.')
	Return
End If

end event

type st_9 from statictext within tabpage_1
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 1673
integer y = 952
integer width = 238
integer height = 84
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 16777215
long backcolor = 8421504
string text = "추가"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event ue_lbuttondown;This.BorderStyle = StyleLowered!
end event

event ue_lbuttonup;This.BorderStyle = StyleRaised!
end event

event clicked;String ls_emp

ls_emp = tab_1.tabpage_1.dw_1.GetItemString(1, 'empno')
If Trim(ls_emp) = '' OR IsNull(ls_emp) Then
	MessageBox('사용자 확인', '사용자를 입력 하십시오.')
	tab_1.tabpage_1.dw_1.SetColumn('empno')
	tab_1.tabpage_1.dw_1.SetFocus()
	Return
End If

Long   ll_row

ll_row = tab_1.tabpage_1.dw_5.InsertRow(0)


tab_1.tabpage_1.dw_5.SetItem(ll_row, 'empno', ls_emp)

end event

type st_7 from statictext within tabpage_1
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 4165
integer y = 952
integer width = 238
integer height = 84
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 16777215
long backcolor = 8421504
string text = "삭제"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event ue_lbuttondown;This.BorderStyle = StyleLowered!
end event

event ue_lbuttonup;This.BorderStyle = StyleRaised!
end event

event clicked;Long   row

row = tab_1.tabpage_1.dw_6.GetRow()
If row < 1 Then Return

If f_msg_delete() <> 1 Then Return

tab_1.tabpage_1.dw_6.DeleteRow(row)

If tab_1.tabpage_1.dw_6.UPDATE() = 1 Then
	COMMIT USING SQLCA;
Else
	ROLLBACK USING SQLCA;
	MessageBox('삭제 실패', '삭제 중 오류가 발생했습니다.')
	Return
End If

end event

type st_8 from statictext within tabpage_1
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 3909
integer y = 952
integer width = 238
integer height = 84
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 16777215
long backcolor = 8421504
string text = "추가"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event ue_lbuttondown;This.BorderStyle = StyleLowered!
end event

event ue_lbuttonup;This.BorderStyle = StyleRaised!
end event

event clicked;String ls_emp

ls_emp = tab_1.tabpage_1.dw_1.GetItemString(1, 'empno')
If Trim(ls_emp) = '' OR IsNull(ls_emp) Then
	MessageBox('사용자 확인', '사용자를 입력 하십시오.')
	tab_1.tabpage_1.dw_1.SetColumn('empno')
	tab_1.tabpage_1.dw_1.SetFocus()
	Return
End If

Long   ll_row

ll_row = tab_1.tabpage_1.dw_6.InsertRow(0)

tab_1.tabpage_1.dw_6.SetItem(ll_row, 'empno', ls_emp)

end event

type st_4 from statictext within tabpage_1
integer x = 2281
integer y = 952
integer width = 695
integer height = 84
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 16777215
long backcolor = 8421504
string text = "  HARDWARE 정보      "
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type st_3 from statictext within tabpage_1
integer x = 59
integer y = 52
integer width = 631
integer height = 84
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 16777215
long backcolor = 8421504
string text = "  개인 ＆ PC정보       "
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type st_2 from statictext within tabpage_1
integer x = 59
integer y = 952
integer width = 649
integer height = 84
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 16777215
long backcolor = 8421504
string text = "  SOFTWARE 정보      "
boolean border = true
long bordercolor = 8421504
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type dw_6 from datawindow within tabpage_1
integer x = 2286
integer y = 1076
integer width = 2181
integer height = 880
integer taborder = 70
string title = "none"
string dataobject = "d_sg_10010_003"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event clicked;This.SelectRow(0, False)
This.SelectRow(row, True)
end event

event rowfocuschanged;This.SelectRow(0, False)
This.SelectRow(currentrow, True)
end event

event constructor;This.SetTransObject(SQLCA)
end event

type dw_5 from datawindow within tabpage_1
integer x = 55
integer y = 1076
integer width = 2181
integer height = 880
integer taborder = 60
string title = "none"
string dataobject = "d_sg_10010_002"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event constructor;This.SetTransObject(SQLCA)
end event

event rowfocuschanged;This.SelectRow(0, False)
This.SelectRow(currentrow, True)
end event

event clicked;This.SelectRow(0, False)
This.SelectRow(row, True)
end event

type dw_1 from datawindow within tabpage_1
event ue_enter pbm_dwnprocessenter
integer x = 55
integer y = 164
integer width = 4421
integer height = 752
integer taborder = 60
string title = "none"
string dataobject = "d_sg_10010_001"
boolean border = false
boolean livescroll = true
end type

event ue_enter;Send(Handle(This), 256, 9, 0)
Return 1
end event

event constructor;This.SetTransObject(SQLCA)
This.InsertRow(0)
end event

event itemchanged;If row < 1 Then Return

String ls_data
String ls_code
Long   ll_data

Choose Case dwo.name
	Case 'empno'
		SELECT EMPNAME, DEPTCODE
		  INTO :ls_data, :ls_code
		  FROM P1_MASTER
		 WHERE EMPNO = :data ;
		If Trim(ls_data) = '' OR IsNull(ls_data) Then
			MessageBox('사번확인', '등록된 사번이 아닙니다.')
			p_can.TriggerEvent(Clicked!)
			Return
		End If
		
		This.SetItem(row, 'empnam' , ls_data)
		This.SetItem(row, 'dept'   , ls_code)
		This.SetItem(row, 'deptnam', f_get_name5('11', ls_code, ''))
				
		SELECT COUNT('X')
		  INTO :ll_data
		  FROM SG_EMPPC
		 WHERE EMPNO = :data ;
		If ll_data > 0 Then
			p_inq.TriggerEvent(Clicked!)
		End If
		
	Case 'dept'
		SELECT FUN_GET_CVNAS(:data)
		  INTO :ls_data
		  FROM DUAL ;
		If Trim(ls_data) = '' OR IsNull(ls_data) Then
			MessageBox('부서확인', '등록된 부서코드가 아닙니다.')
			Return
		End If
		
		This.SetItem(row, 'deptnam', ls_data)
		
End Choose
end event

event rbuttondown;If row < 1 Then Return

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

String ls_data
Long   ll_data

Choose Case dwo.name		
	Case 'dept'
		gs_gubun = '4'
		Open(w_vndmst_popup)
		
		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
		
		This.SetItem(row, 'dept'   , gs_code    )
		This.SetItem(row, 'deptnam', gs_codename)
		
	Case 'empno'
		Open(w_sawon_popup)
		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
		
		SELECT DEPTCODE
		  INTO :ls_data
		  FROM P1_MASTER
		 WHERE EMPNO = :gs_code ;
				
		This.SetItem(row, 'empno' , gs_code    )
		This.SetItem(row, 'empnam', gs_codename)
		
		This.SetItem(row, 'dept'   , ls_data    )
		This.SetItem(row, 'deptnam', f_get_name5('11', ls_data, ''))
		
		SELECT COUNT('X')
		  INTO :ll_data
		  FROM SG_EMPPC
		 WHERE EMPNO = :gs_code ;
		If ll_data > 0 Then
			p_inq.TriggerEvent(Clicked!)
		End If
		
End Choose
end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 4521
integer height = 1992
long backcolor = 33027312
string text = "자료조회"
long tabtextcolor = 33554432
long tabbackcolor = 33027312
string picturename = "C:\ERPMAN\image\filefind.ico"
long picturemaskcolor = 536870912
string powertiptext = "등록된 정보를 조회합니다."
rr_2 rr_2
dw_7 dw_7
dw_3 dw_3
end type

on tabpage_2.create
this.rr_2=create rr_2
this.dw_7=create dw_7
this.dw_3=create dw_3
this.Control[]={this.rr_2,&
this.dw_7,&
this.dw_3}
end on

on tabpage_2.destroy
destroy(this.rr_2)
destroy(this.dw_7)
destroy(this.dw_3)
end on

type rr_2 from roundrectangle within tabpage_2
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 23
integer y = 24
integer width = 4480
integer height = 1960
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_7 from datawindow within tabpage_2
boolean visible = false
integer x = 800
integer y = 276
integer width = 2907
integer height = 1188
integer taborder = 60
string dragicon = "C:\ERPMAN\image\control_panel.ico"
boolean bringtotop = true
boolean titlebar = true
string title = "SoftWare List"
string dataobject = "d_sg_10010_005"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
string icon = "C:\ERPMAN\image\control_panel.ico"
boolean hsplitscroll = true
boolean livescroll = true
end type

type dw_3 from datawindow within tabpage_2
integer x = 37
integer y = 36
integer width = 4453
integer height = 1936
integer taborder = 70
string title = "none"
string dataobject = "d_sg_10010_004"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event constructor;This.SetTransObject(SQLCA)
end event

event clicked;If row < 1 Then Return

String ls_emp

ls_emp = This.GetItemString(row, 'empno')

Choose Case dwo.name
	Case 'swcnt'
		tab_1.tabpage_2.dw_7.Title = 'SoftWare List'
		tab_1.tabpage_2.dw_7.DataObject = 'd_sg_10010_005'
		tab_1.tabpage_2.dw_7.SetTransObject(SQLCA)
		
		tab_1.tabpage_2.dw_7.SetRedraw(False)
		tab_1.tabpage_2.dw_7.Retrieve(ls_emp)
		tab_1.tabpage_2.dw_7.SetRedraw(True)

		tab_1.tabpage_2.dw_7.Visible = True
	Case 'hwcnt'
		tab_1.tabpage_2.dw_7.Title = 'HardWare List'
		tab_1.tabpage_2.dw_7.DataObject = 'd_sg_10010_006'
		tab_1.tabpage_2.dw_7.SetTransObject(SQLCA)
		
		tab_1.tabpage_2.dw_7.SetRedraw(False)
		tab_1.tabpage_2.dw_7.Retrieve(ls_emp)
		tab_1.tabpage_2.dw_7.SetRedraw(True)

		tab_1.tabpage_2.dw_7.Visible = True
End Choose
end event

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 4521
integer height = 1992
long backcolor = 33027312
string text = "인쇄"
long tabtextcolor = 33554432
long tabbackcolor = 33027312
string picturename = "C:\ERPMAN\image\files_text.ico"
long picturemaskcolor = 536870912
string powertiptext = "자료를 양식에 맞게 인쇄합니다."
rr_3 rr_3
dw_4 dw_4
end type

on tabpage_3.create
this.rr_3=create rr_3
this.dw_4=create dw_4
this.Control[]={this.rr_3,&
this.dw_4}
end on

on tabpage_3.destroy
destroy(this.rr_3)
destroy(this.dw_4)
end on

type rr_3 from roundrectangle within tabpage_3
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 23
integer y = 24
integer width = 4480
integer height = 1960
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_4 from datawindow within tabpage_3
integer x = 37
integer y = 36
integer width = 4453
integer height = 1936
integer taborder = 70
string title = "none"
string dataobject = "d_sg_10010_007"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event constructor;This.SetTransObject(SQLCA)
This.InsertRow(0)
end event

type cb_1 from commandbutton within w_sg_10010
integer x = 2153
integer y = 48
integer width = 402
integer height = 116
integer taborder = 120
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string pointer = "HyperLink!"
string text = "사용자 변경"
end type

event clicked;Open(w_sg_10010_popup)
end event

