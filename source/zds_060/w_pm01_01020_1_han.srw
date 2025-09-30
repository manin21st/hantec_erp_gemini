$PBExportHeader$w_pm01_01020_1_han.srw
$PBExportComments$부하조정-월계획(ver.17.07.10)
forward
global type w_pm01_01020_1_han from w_inherite_popup
end type
type st_3 from statictext within w_pm01_01020_1_han
end type
type st_2 from statictext within w_pm01_01020_1_han
end type
type rr_2 from roundrectangle within w_pm01_01020_1_han
end type
type rr_3 from roundrectangle within w_pm01_01020_1_han
end type
type rr_1 from roundrectangle within w_pm01_01020_1_han
end type
end forward

global type w_pm01_01020_1_han from w_inherite_popup
integer width = 2848
integer height = 1988
string title = "부하조정 (ver.17.07.10)"
st_3 st_3
st_2 st_2
rr_2 rr_2
rr_3 rr_3
rr_1 rr_1
end type
global w_pm01_01020_1_han w_pm01_01020_1_han

type variables
String is_yymm
Int    ii_jucha
String    is_calgbn
end variables

on w_pm01_01020_1_han.create
int iCurrent
call super::create
this.st_3=create st_3
this.st_2=create st_2
this.rr_2=create rr_2
this.rr_3=create rr_3
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_3
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.rr_2
this.Control[iCurrent+4]=this.rr_3
this.Control[iCurrent+5]=this.rr_1
end on

on w_pm01_01020_1_han.destroy
call super::destroy
destroy(this.st_3)
destroy(this.st_2)
destroy(this.rr_2)
destroy(this.rr_3)
destroy(this.rr_1)
end on

event open;f_window_center_response(this)

String sItnbr, sOpseq, sWkctr
string sdate, edate
String stemp
Long ix

is_Yymm = Left(gs_code,6)
ii_jucha = Dec(Right(gs_code,1))
is_calgbn = gs_gubun // 1:작업장, 2:설비

dw_jogun.SetTransObject(sqlca)
dw_1.SetTransObject(sqlca)

sItnbr = gs_codename
sWkctr = gs_codename2
sOpseq = gs_codename3

If dw_jogun.Retrieve(is_yymm,  sItnbr, sWkctr) <= 0 Then
	Close(this)
	Return
End If
	
/* 대체작업장 조회 */
dw_1.Retrieve(is_yymm, sItnbr, sOpseq)

For ix = 1 To dw_1.RowCount()
	dw_1.SetItem(ix, 'mchr', dw_jogun.GetItemNumber(1, 'mchr'))
Next
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_pm01_01020_1_han
integer x = 64
integer y = 200
integer width = 2715
integer height = 744
integer taborder = 30
string dataobject = "d_pm01_01020_1_11_han"
end type

type p_exit from w_inherite_popup`p_exit within w_pm01_01020_1_han
integer x = 2619
integer taborder = 20
end type

event p_exit::clicked;call super::clicked;gs_code = 'OK'
//SetNull(gs_code)
Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_pm01_01020_1_han
integer x = 2446
integer taborder = 10
string picturename = "C:\erpman\image\조정_up.gif"
end type

event p_inq::clicked;Dec {2} dSqty,dJqty, nCnt, dQty, dMchr
Dec {2} dJqty1, dJqty2, dJqty3, dJqty4, dJqty5, dJqty6, dJqty7 
String sItnbr, sMchno, sWkctr, spWkctr, sDate, sOpseq
Long ix, iy, nRow, nJucha

If dw_1.AcceptText() <> 1 Then Return
If dw_jogun.AcceptText() <> 1 Then Return

//dSqty = dw_jogun.GetItemNumber(1, 'sum_gapqty')
//If dSqty = 0 Then
//	MessageBox('확 인','조정할 사항이 없습니다.!!')
//	Return
//End If

If MessageBox("확 인", "조정하시겠습니까?",	Exclamation!, OKCancel!, 2) = 2 Then Return

SetPointer(HourGlass!)

sItnbr = dw_jogun.GetItemString(1, 'itnbr')
dJqty1 = dw_jogun.GetItemNumber(1, 'jqty')
dJqty2 = dw_jogun.GetItemNumber(2, 'jqty')
dJqty3 = dw_jogun.GetItemNumber(3, 'jqty')
dJqty4 = dw_jogun.GetItemNumber(4, 'jqty')
if dw_jogun.RowCount() > 4 then dJqty5 = dw_jogun.GetItemNumber(5, 'jqty')
if dw_jogun.RowCount() > 5 then dJqty6 = dw_jogun.GetItemNumber(6, 'jqty')
//dJqty7 = dw_jogun.GetItemNumber(7, 'jqty')

/* 변경전 설비에 대한 조정 */
sWkctr = dw_jogun.GetItemString(1, 'wkctr')
dMchr = dw_jogun.GetItemNumber(1, 'mchr')

/* 작업장 */
UPDATE PM01_CAPA_DTL
   SET LOTQTY1 = :djQty1,
		 LOTQTY2 = :djQty2,
		 LOTQTY3 = :djQty3,
		 LOTQTY4 = :djQty4,
		 LOTQTY5 = :djQty5,
		 LOTQTY6 = :djQty6
 WHERE YYMM = :is_yymm
   AND ITNBR = :sItnbr
	AND WKCTR = :sWkctr;
If sqlca.sqlcode <> 0 Then
	MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext + ' #1')
	Rollback;
	Return
End If

// 대체 작업장/설비로 조정
spWkctr = ' '
For ix = 1 To dw_1.RowCount()
	sWkctr = dw_1.GetItemString(ix, 'wkctr')
	if spWkctr = sWkctr then continue	
	
	dJqty1 = 0
	dJqty2 = 0
	dJqty3 = 0
	dJqty4 = 0
	dJqty5 = 0
	dJqty6 = 0
	dJqty7 = 0
	
	For iy = 1 To dw_jogun.RowCount()
		nJucha = dw_jogun.GetItemNumber(iy, 'mon_jucha')
		sOpseq = dw_jogun.GetItemString(iy, 'opseq')
		nRow = dw_1.Find("wkctr='"+sWkctr+"' and mon_jucha="+String(nJucha)+" and opt='Y'",1,dw_1.RowCount())
		if nRow > 0 then
			if iy = 1 then dJqty1 = dw_1.GetItemNumber(nRow, 'qty')
			if iy = 2 then dJqty2 = dw_1.GetItemNumber(nRow, 'qty')
			if iy = 3 then dJqty3 = dw_1.GetItemNumber(nRow, 'qty')
			if iy = 4 then dJqty4 = dw_1.GetItemNumber(nRow, 'qty')
			if iy = 5 then dJqty5 = dw_1.GetItemNumber(nRow, 'qty')
			if iy = 6 then dJqty6 = dw_1.GetItemNumber(nRow, 'qty')
//			if iy = 7 then dJqty7 = dw_1.GetItemNumber(nRow, 'qty')
		end if
	Next

	/* 작업장 */
	SELECT COUNT(*) INTO :nCnt 
	  FROM PM01_CAPA_DTL
	 WHERE YYMM = :is_yymm
      AND ITNBR = :sItnbr
		AND WKCTR = :sWkctr;
		
	If nCnt > 0 Then
		UPDATE PM01_CAPA_DTL
			SET LOTQTY1 = LOTQTY1 + :dJqty1,
				 LOTQTY2 = LOTQTY2 + :dJqty2,
				 LOTQTY3 = LOTQTY3 + :dJqty3,
				 LOTQTY4 = LOTQTY4 + :dJqty4,
				 LOTQTY5 = LOTQTY5 + :dJqty5,
				 LOTQTY6 = LOTQTY6 + :dJqty6
		 WHERE YYMM = :is_yymm
			AND ITNBR = :sItnbr
			AND WKCTR = :sWkctr;
	Else
		INSERT INTO PM01_CAPA_DTL
			( YYMM, ITNBR, WKCTR, MCHR, S1QTY, S2QTY, S3QTY, S4QTY, S5QTY, S6QTY, 
			                            LOTQTY1, LOTQTY2, LOTQTY3, LOTQTY4, LOTQTY5, LOTQTY6, OPSEQ)
		VALUES ( :is_yymm, :sItnbr, :sWkctr, :dMchr,
		         :dJqty1,	:dJqty2, :dJqty3, :dJqty4, :dJqty5, :dJqty6,
		         :dJqty1,	:dJqty2, :dJqty3, :dJqty4, :dJqty5, :dJqty6, :sOpseq);
	End If
	If sqlca.sqlcode <> 0 Then
		MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext + ' #3')
		Rollback;
		Return
	End If

	spWkctr = sWkctr
Next

COMMIT;

// 작업장 부하계산(사용공수만 재계산)
sqlca.PM01_CAPA_LOD_MONTH(gs_sabu, is_yymm, '3');
If sqlca.sqlcode <> 0 Then
	MessageBox(string(sqlca.sqlcode), SQLCA.SQLERRTEXT)
	RETURN
END iF

gs_code = 'OK'
Close(Parent)

end event

event p_inq::ue_lbuttondown;PictureName = 'C:\erpman\image\조정_dn.gif'
end event

event p_inq::ue_lbuttonup;PictureName = 'C:\erpman\image\조정_up.gif'
end event

type p_choose from w_inherite_popup`p_choose within w_pm01_01020_1_han
boolean visible = false
integer x = 1879
integer y = 12
integer taborder = 50
end type

type dw_1 from w_inherite_popup`dw_1 within w_pm01_01020_1_han
integer x = 55
integer y = 1084
integer width = 2747
integer height = 744
integer taborder = 40
string dataobject = "d_pm01_01020_1_21_han"
end type

event dw_1::rowfocuschanged;//
end event

event dw_1::itemchanged;call super::itemchanged;Dec dQty, dJqty

Choose Case GetColumnName()
	Case 'opt'
		If GetText() = 'N' Then
			SetItem(row, 'qty', 0)
		End If
	Case 'qty'
		dQty = Dec(GetText())
		If IsNull(dQty) Then dQty = 0
		
//		dJqty = dw_jogun.GetItemNumber(1, 'jqty')
//		If IsNull(dJqty) Then dJqty = 0
//		If dJqty - dQty < 0 Then
//			MessageBox('확 인','계획수량이 (-)됩니다.!!')
//			Return 2
//		End If
//		
//		dw_jogun.SetItem(1, 'jqty', dJqty - dQty)
//		
//		If dJqty - dQty > 0 Then
//			SetItem(row, 'opt','Y')
//		End If

		If dQty > 0 Then
			SetItem(row, 'opt','Y')
		End If
End Choose
end event

type sle_2 from w_inherite_popup`sle_2 within w_pm01_01020_1_han
boolean visible = false
integer x = 576
integer y = 2580
end type

type cb_1 from w_inherite_popup`cb_1 within w_pm01_01020_1_han
boolean visible = false
integer x = 1051
integer y = 2328
end type

type cb_return from w_inherite_popup`cb_return within w_pm01_01020_1_han
boolean visible = false
integer x = 1687
integer y = 2328
end type

type cb_inq from w_inherite_popup`cb_inq within w_pm01_01020_1_han
boolean visible = false
integer x = 1371
integer y = 2328
end type

type sle_1 from w_inherite_popup`sle_1 within w_pm01_01020_1_han
boolean visible = false
integer x = 411
integer y = 2464
end type

type st_1 from w_inherite_popup`st_1 within w_pm01_01020_1_han
boolean visible = false
integer x = 133
integer y = 2476
end type

type st_3 from statictext within w_pm01_01020_1_han
integer x = 2377
integer y = 1020
integer width = 402
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "공수단위:분"
boolean focusrectangle = false
end type

type st_2 from statictext within w_pm01_01020_1_han
integer x = 96
integer y = 996
integer width = 590
integer height = 44
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33027312
long backcolor = 28144969
string text = "표준공정 대체 작업장"
boolean focusrectangle = false
end type

type rr_2 from roundrectangle within w_pm01_01020_1_han
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 55
integer y = 192
integer width = 2747
integer height = 764
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_pm01_01020_1_han
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 1076
integer width = 2757
integer height = 768
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within w_pm01_01020_1_han
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 28144969
integer x = 59
integer y = 980
integer width = 649
integer height = 80
integer cornerheight = 40
integer cornerwidth = 55
end type

