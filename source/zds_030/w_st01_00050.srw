$PBExportHeader$w_st01_00050.srw
$PBExportComments$작업그룹 등록
forward
global type w_st01_00050 from w_inherite
end type
type dw_1 from u_key_enter within w_st01_00050
end type
type rb_1 from radiobutton within w_st01_00050
end type
type rb_2 from radiobutton within w_st01_00050
end type
type rb_3 from radiobutton within w_st01_00050
end type
type gb_1 from groupbox within w_st01_00050
end type
type rr_3 from roundrectangle within w_st01_00050
end type
type rr_1 from roundrectangle within w_st01_00050
end type
end forward

global type w_st01_00050 from w_inherite
integer height = 3772
string title = "작업장 정보 등록"
dw_1 dw_1
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
gb_1 gb_1
rr_3 rr_3
rr_1 rr_1
end type
global w_st01_00050 w_st01_00050

type variables
String is_grpcod
end variables

on w_st01_00050.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.gb_1=create gb_1
this.rr_3=create rr_3
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.rb_3
this.Control[iCurrent+5]=this.gb_1
this.Control[iCurrent+6]=this.rr_3
this.Control[iCurrent+7]=this.rr_1
end on

on w_st01_00050.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.gb_1)
destroy(this.rr_3)
destroy(this.rr_1)
end on

event open;call super::open;dw_insert.SetTransObject(sqlca)
dw_1.SetTransObject(sqlca)

dw_insert.SetRowFocusIndicator(Hand!)
dw_insert.Retrieve()
end event

type dw_insert from w_inherite`dw_insert within w_st01_00050
integer x = 110
integer y = 228
integer width = 2309
integer height = 1904
integer taborder = 130
string dataobject = "d_st01_00050_1"
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemchanged;call super::itemchanged;String sGrpcod
Long   nRow

Choose Case GetColumnName()
	Case 'grpcod'
		sGrpcod = Trim(GetText())

		nRow = Find("grpcod = '" + sGrpcod + "'",1, rowcount())
		If nRow > 0 And nRow <> row Then
			MessageBox('확 인','기 등록된 그룹코드입니다.!!')
			Return 1
		End If
		
		dw_1.Retrieve(sGrpCod)
		
		is_grpcod = sGrpCod
End Choose
end event

event dw_insert::rowfocuschanged;call super::rowfocuschanged;Long nRow

nRow = GetRow()
If nRow <= 0 Then
	is_grpcod = ''
	Return
End If

is_grpcod = GetItemString(nRow, 'grpcod')

dw_1.Retrieve(is_grpcod)
end event

event dw_insert::itemerror;call super::itemerror;return 1
end event

type p_delrow from w_inherite`p_delrow within w_st01_00050
integer x = 3918
integer y = 28
integer taborder = 50
end type

event p_delrow::clicked;call super::clicked;Long nRow, nCnt, ix
String sItnbr

// 불량현상일 경우 return
If rb_3.Checked Then Return

nRow = dw_1.GetRow()
If nRow > 0 then
	If f_msg_delete() <> 1 Then	REturn
	
	dw_1.DeleteRow(nRow)
	nCnt = dw_1.RowCount()
	
	If dw_1.Update() <> 1 Then
		RollBack;
		f_message_chk(31,'')
		Return
	End If
	Commit;
End If
end event

type p_addrow from w_inherite`p_addrow within w_st01_00050
integer x = 3744
integer y = 28
integer taborder = 40
end type

event p_addrow::clicked;String sGrpCode
Long   nRow, nMax

If dw_1.AcceptText() <> 1 Then Return

sGrpCode = is_grpcod

If IsNull(sGrpCode) Or sGrpCode = '' Then
	f_message_chk(1400,'')
	Return
End If

nRow = dw_1.InsertRow(0)

/* 효율분석표 */
If rb_1.Checked Then
	nMax = dw_1.GetItemNumber(nRow, 'max_seqno')
	If IsNull(nMax) Then nMax = 0
	
	nMax = nMax + 1
	
	dw_1.ScrollToRow(nRow)
	dw_1.SetItem(nRow, 'grpcod', sGrpcode)
	dw_1.SetItem(nRow, 'seqno', nMax)
	
	dw_1.SetColumn('ju_inw')
	dw_1.SetFocus()
ElseIf rb_2.Checked Then
	dw_1.ScrollToRow(nRow)
	dw_1.SetItem(nRow, 'itnbr', sGrpcode)
	
	dw_1.SetColumn('rcode')
	dw_1.SetFocus()	
End If
end event

type p_search from w_inherite`p_search within w_st01_00050
boolean visible = false
integer x = 2249
integer taborder = 110
string picturename = "C:\erpman\image\저장_up.gif"
end type

event p_search::clicked;call super::clicked;Long ix, nCnt, nFind, nRow
String sGrpCod, sRfgub

If dw_insert.AcceptText() <> 1 Then Return
If dw_insert.RowCount() <= 0 Then Return

	// 그룹코드 확인
	nCnt = dw_insert.RowCount()
	For ix = nCnt To 1 Step -1
		sGrpCod = Trim(dw_insert.GetItemString(ix, 'grpcod'))
		If IsNull(sGrpCod) Or sGrpCod = '' Then
			dw_insert.DeleteRow(ix)
		End If
	Next
	
	// 총인원 계산
	For ix = 1 To dw_insert.RowCount()
		dw_insert.SetItem(ix, 'boinw', dw_insert.GetItemNumber(ix, 'boinw1') + dw_insert.GetItemNumber(ix,'boinw2'))	
	Next
	For ix = 1 To dw_1.RowCount()
		dw_1.SetItem(ix, 'tot_inw', dw_1.GetItemNumber(ix, 'ju_inw') + dw_1.GetItemNumber(ix,'ya_inw'))	
	Next
	
	// 그룹별 효율 계산
	nFind = dw_insert.Find("grpcod = '" + is_grpcod +"'", 1, dw_insert.RowCount())
	If nFind > 0 Then
		nRow = dw_1.Find("ju_inw = " + String(dw_insert.GetItemNumber(nFind, 'boinw1')) + " and ya_inw = " + String(dw_insert.GetItemNumber(nFind, 'boinw2')), &
							  1, dw_1.RowCount())
		If nRow > 0 Then
			dw_insert.SetItem(nFind, 'tot_rate', dw_1.GetItemNumber(nRow, 'tot_rate'))
		Else
			dw_insert.SetItem(nFind, 'tot_rate', 1)
		End If
	End If
	
	// 저장
	If dw_insert.Update() <> 1 Then
		MessageBox(string(sqlca.sqlcode), sqlca.sqlerrtext)
		RollBack;
		Return
	End If

COMMIT;

MessageBox('확인','저장하였습니다')

dw_insert.ResetUpdate()

dw_insert.Retrieve()

ib_any_typing = false
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

event p_search::ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

type p_ins from w_inherite`p_ins within w_st01_00050
boolean visible = false
integer x = 1893
integer y = 28
integer taborder = 30
end type

event p_ins::clicked;String sGrpCode
Long   nRow

If dw_insert.AcceptText() <> 1 Then Return

//sGrpCode = Trim(dw_insert.GetItemString(nRow, 'grpcod'))
//
//If IsNull(sGrpCode) Or sGrpCode = '' Then
//	f_message_chk(1400,'')
//	Return
//End If

nRow = dw_insert.InsertRow(0)

dw_insert.ScrollToRow(nRow)
dw_insert.SetColumn('grpcod')
dw_insert.SetFocus()
end event

type p_exit from w_inherite`p_exit within w_st01_00050
integer taborder = 100
end type

type p_can from w_inherite`p_can within w_st01_00050
integer taborder = 90
end type

event p_can::clicked;call super::clicked;dw_insert.Retrieve()
end event

type p_print from w_inherite`p_print within w_st01_00050
boolean visible = false
integer x = 539
integer y = 28
integer taborder = 120
end type

type p_inq from w_inherite`p_inq within w_st01_00050
boolean visible = false
integer x = 891
integer y = 20
end type

type p_del from w_inherite`p_del within w_st01_00050
boolean visible = false
integer x = 2075
integer y = 28
integer taborder = 80
end type

event p_del::clicked;call super::clicked;Long nRow, nCnt, ix
String sGrpcod, sItnbr

nRow = dw_insert.GetRow()
If nRow > 0 then
	If f_msg_delete() <> 1 Then	REturn
	
	sGrpcod = Trim(dw_insert.GetItemString(nRow, 'grpcod'))
	
	dw_insert.DeleteRow(nRow)
	nCnt = dw_insert.RowCount()
	For ix = nCnt To 1 Step -1
		sItnbr = Trim(dw_insert.GetItemString(ix, 'grpcod'))
		If IsNull(sItnbr) Or sItnbr = '' Then
			dw_insert.DeleteRow(ix)
		End If
	Next
	
	dw_1.RowsMove(1, dw_1.RowCount(), Primary!, dw_1, 1, Delete!)

	If dw_1.Update(True, False) <> 1 Then
		RollBack;
		f_message_chk(31,'')
		Return
	End If
	
	If dw_insert.Update(True, False) <> 1 Then
		RollBack;
		f_message_chk(31,'')
		Return
	End If
	
	UPDATE MCHMST
	   SET WRK_GRPCOD = NULL
	 WHERE WRK_GRPCOD = :sGrpcod;
	If SQLCA.SQLCODE <> 0 Then
		RollBack;
		f_message_chk(31,'')
		Return
	End If
	
	dw_1.ResetUpdate()
	dw_insert.ResetUpdate()
	
	Commit;
End If
end event

type p_mod from w_inherite`p_mod within w_st01_00050
integer x = 4091
integer taborder = 60
end type

event p_mod::clicked;call super::clicked;Long ix, nCnt, nFind, nRow
String sGrpCod, sRfgub

If dw_insert.AcceptText() <> 1 Then Return
If dw_insert.RowCount() <= 0 Then Return

If rb_1.Checked Then
	// 그룹코드 확인
	nCnt = dw_insert.RowCount()
	For ix = nCnt To 1 Step -1
		sGrpCod = Trim(dw_insert.GetItemString(ix, 'grpcod'))
		If IsNull(sGrpCod) Or sGrpCod = '' Then
			dw_insert.DeleteRow(ix)
		End If
	Next
	
	// 총인원 계산
	For ix = 1 To dw_insert.RowCount()
		dw_insert.SetItem(ix, 'boinw', dw_insert.GetItemNumber(ix, 'boinw1') + dw_insert.GetItemNumber(ix,'boinw2'))	
	Next
	For ix = 1 To dw_1.RowCount()
		dw_1.SetItem(ix, 'tot_inw', dw_1.GetItemNumber(ix, 'ju_inw') + dw_1.GetItemNumber(ix,'ya_inw'))	
	Next
	
	// 그룹별 효율 계산
	nFind = dw_insert.Find("grpcod = '" + is_grpcod +"'", 1, dw_insert.RowCount())
	If nFind > 0 Then
		nRow = dw_1.Find("ju_inw = " + String(dw_insert.GetItemNumber(nFind, 'boinw1')) + " and ya_inw = " + String(dw_insert.GetItemNumber(nFind, 'boinw2')), &
							  1, dw_1.RowCount())
		If nRow > 0 Then
			dw_insert.SetItem(nFind, 'tot_rate', dw_1.GetItemNumber(nRow, 'tot_rate'))
		Else
			dw_insert.SetItem(nFind, 'tot_rate', 1)
		End If
	End If
	
	// 저장
	If dw_insert.Update() <> 1 Then
		MessageBox(string(sqlca.sqlcode), sqlca.sqlerrtext)
		RollBack;
		Return
	End If
ElseIf rb_2.Checked Then
	// 사원코드 확인
	nCnt = dw_1.RowCount()
	For ix = nCnt To 1 Step -1
		sGrpCod = Trim(dw_1.GetItemString(ix, 'rcode'))
		If IsNull(sGrpCod) Or sGrpCod = '' Then
			dw_1.DeleteRow(ix)
		End If
	Next
// 불량코드 확인
ElseIf rb_3.Checked Then
	
	For ix = 1 To dw_1.RowCount()
		sRfgub = dw_1.GetItemSTring(ix, 'rfgub')
		
		If dw_1.GetItemString(ix, 'chk') = 'Y' And dw_1.GetItemString(ix, 'old_chk') = 'N' Then
			INSERT INTO WRKGRP_BUL ( GRPCOD, RFGUB )
			 VALUES ( :is_grpcod, :sRfgub );
			If SQLCA.SQLCODE <> 0 Then
				MessageBox(string(sqlca.sqlcode), sqlca.sqlerrtext)
				RollBack;
				Return
			End If
		End If
		
		If dw_1.GetItemString(ix, 'chk') = 'N' And dw_1.GetItemString(ix, 'old_chk') = 'Y' Then
			DELETE WRKGRP_BUL WHERE GRPCOD = :is_grpcod AND RFGUB = :sRfgub;
			If SQLCA.SQLCODE <> 0 Then
				MessageBox(string(sqlca.sqlcode), sqlca.sqlerrtext)
				RollBack;
				Return
			End If
		End If
	Next
	
	COMMIT;
	
	MessageBox('확인','저장하였습니다')
	
	dw_insert.Retrieve()
	
	ib_any_typing = false
	
	RETURN
Else
	Return
End If

If dw_1.Update() <> 1 Then
	MessageBox(string(sqlca.sqlcode), sqlca.sqlerrtext)
	RollBack;
	Return
End If

COMMIT;

MessageBox('확인','저장하였습니다')

dw_insert.ResetUpdate()
dw_1.ResetUpdate()

dw_insert.Retrieve()

ib_any_typing = false
end event

type cb_exit from w_inherite`cb_exit within w_st01_00050
end type

type cb_mod from w_inherite`cb_mod within w_st01_00050
end type

type cb_ins from w_inherite`cb_ins within w_st01_00050
end type

type cb_del from w_inherite`cb_del within w_st01_00050
end type

type cb_inq from w_inherite`cb_inq within w_st01_00050
end type

type cb_print from w_inherite`cb_print within w_st01_00050
end type

type st_1 from w_inherite`st_1 within w_st01_00050
end type

type cb_can from w_inherite`cb_can within w_st01_00050
end type

type cb_search from w_inherite`cb_search within w_st01_00050
end type







type gb_button1 from w_inherite`gb_button1 within w_st01_00050
end type

type gb_button2 from w_inherite`gb_button2 within w_st01_00050
end type

type dw_1 from u_key_enter within w_st01_00050
integer x = 2496
integer y = 228
integer width = 1723
integer height = 1916
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_st01_00050_3"
boolean vscrollbar = true
boolean border = false
end type

event itemchanged;call super::itemchanged;String sData
Long   nRow

nRow = GetRow()
If nRow <= 0 Then Return

Choose Case GetColumnName()
	Case 'rcode'	
		  SELECT "EMPNAME" INTO :sData FROM "P1_MASTER" WHERE "EMPNO" = :data   ;

		  If Sqlca.sqlcode = 0 then
			  this.setitem(nRow, "empname", sData)
 		  Else
			  gs_code 	  = data
			  gs_codename = ''
			  this.triggerevent(rbuttondown!)
			  Return 1
		  End if
End Choose
end event

event itemerror;call super::itemerror;return 1
end event

event rbuttondown;call super::rbuttondown;Long nRow

SetNull(Gs_Gubun)
SetNull(Gs_code)
SetNull(Gs_codename)

nRow = GetRow()
If nRow <= 0 Then Return

Choose case this.getcolumnname()
	 case 'rcode'
			Open(w_sawon_popup)
			this.setitem(nRow, "rcode", gs_code)
			this.setitem(nRow, "empname", gs_codename)

			this.setitem(nRow, "deptcode", gs_gubun)
			
			string sdata
			Select deptname2 Into :sData From p0_dept where deptcode = :gs_gubun;
			this.setitem(nRow, "deptname", sdata)
End choose


end event

type rb_1 from radiobutton within w_st01_00050
boolean visible = false
integer x = 3310
integer y = 96
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "효율분석표"
end type

event clicked;
dw_1.DataObject = 'd_st01_00050_2'
dw_1.SetTransObject(Sqlca)
end event

type rb_2 from radiobutton within w_st01_00050
integer x = 2939
integer y = 100
integer width = 379
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "인원배정표"
end type

event clicked;Long nRow
String sGrpcod

dw_1.DataObject = 'd_st01_00050_3'
dw_1.SetTransObject(Sqlca)

nRow = dw_insert.GetRow()
If nRow <= 0 Then Return

dw_1.Retrieve(is_grpcod)

end event

type rb_3 from radiobutton within w_st01_00050
integer x = 2533
integer y = 100
integer width = 329
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "불량현상"
boolean checked = true
end type

event clicked;Long nRow
String sGrpcod

dw_1.DataObject = 'd_st01_00050_4'
dw_1.SetTransObject(Sqlca)

nRow = dw_insert.GetRow()
If nRow <= 0 Then Return

dw_1.Retrieve(is_grpcod)

end event

type gb_1 from groupbox within w_st01_00050
integer x = 2478
integer y = 24
integer width = 1239
integer height = 184
integer taborder = 70
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "[구분]"
end type

type rr_3 from roundrectangle within w_st01_00050
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 96
integer y = 220
integer width = 2350
integer height = 1956
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within w_st01_00050
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2478
integer y = 220
integer width = 1792
integer height = 1956
integer cornerheight = 40
integer cornerwidth = 55
end type

