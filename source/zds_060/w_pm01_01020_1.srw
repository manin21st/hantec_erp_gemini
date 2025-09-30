$PBExportHeader$w_pm01_01020_1.srw
$PBExportComments$월 생산능력 검토
forward
global type w_pm01_01020_1 from w_inherite_popup
end type
type st_2 from statictext within w_pm01_01020_1
end type
type st_3 from statictext within w_pm01_01020_1
end type
type rr_2 from roundrectangle within w_pm01_01020_1
end type
type rr_1 from roundrectangle within w_pm01_01020_1
end type
type rr_3 from roundrectangle within w_pm01_01020_1
end type
end forward

global type w_pm01_01020_1 from w_inherite_popup
integer width = 2848
integer height = 1776
string title = "대체 작업장/설비 조정"
st_2 st_2
st_3 st_3
rr_2 rr_2
rr_1 rr_1
rr_3 rr_3
end type
global w_pm01_01020_1 w_pm01_01020_1

type variables
String is_yymm
Int    ii_jucha
String    is_calgbn
end variables

on w_pm01_01020_1.create
int iCurrent
call super::create
this.st_2=create st_2
this.st_3=create st_3
this.rr_2=create rr_2
this.rr_1=create rr_1
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.rr_2
this.Control[iCurrent+4]=this.rr_1
this.Control[iCurrent+5]=this.rr_3
end on

on w_pm01_01020_1.destroy
call super::destroy
destroy(this.st_2)
destroy(this.st_3)
destroy(this.rr_2)
destroy(this.rr_1)
destroy(this.rr_3)
end on

event open;f_window_center_response(this)

String sWkctr
string sdate, edate

is_Yymm = Left(gs_code,6)
ii_jucha = Dec(Right(gs_code,1))
is_calgbn = gs_gubun // 1:작업장, 2:설비

SELECT WEEK_SDATE, WEEK_EDATE INTO :sDate, :eDate FROM PDTWEEK 
WHERE SUBSTR(WEEK_SDATE,1,6) = :is_Yymm AND MON_JUCHA = :ii_jucha;

If is_calgbn = '1' Then
	dw_jogun.DataObject = 'd_pm01_01020_1_11'
	dw_1.DataObject = 'd_pm01_01020_1_21'
	dw_jogun.SetTransObject(sqlca)
	dw_1.SetTransObject(sqlca)
	
	sWkctr = gs_codename2
Else
	dw_jogun.DataObject = 'd_pm01_01020_1_1'
	dw_1.DataObject = 'd_pm01_01020_1_2'
	dw_jogun.SetTransObject(sqlca)
	dw_1.SetTransObject(sqlca)
	
	SELECT WKCTR INTO :sWkctr FROM MCHMST WHERE MCHNO = :gs_codename2;
End If

If dw_jogun.Retrieve(Left(gs_code,6), gs_codename, gs_codename2,sWkctr, dec(Right(gs_code,1)) ) <= 0 Then
	Close(this)
	Return
End If
	
/* 대체작업장 조회 */
dw_1.Retrieve(sDate, edate, sWkctr)
Long ix
For ix = 1 To dw_1.RowCount()
	dw_1.SetItem(ix, 'mchr', dw_jogun.GetItemNumber(1, 'mchr'))
Next
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_pm01_01020_1
integer x = 59
integer y = 200
integer width = 2720
integer height = 432
integer taborder = 30
string dataobject = "d_pm01_01020_1_11"
end type

type p_exit from w_inherite_popup`p_exit within w_pm01_01020_1
integer x = 2619
integer taborder = 20
end type

event p_exit::clicked;call super::clicked;SetNull(gs_code)
Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_pm01_01020_1
integer x = 2446
integer taborder = 10
string picturename = "C:\erpman\image\조정_up.gif"
end type

event p_inq::clicked;call super::clicked;Dec dSqty,dJqty, nCnt, dQty, dMchr
String sItnbr, sMchno, sWkctr
Long ix

If dw_1.AcceptText() <> 1 Then Return

dSqty = dw_jogun.GetItemNumber(1, 'sqty')
dJqty = dw_jogun.GetItemNumber(1, 'jqty')
sItnbr = dw_jogun.GetItemString(1, 'itnbr')
If dSqty = dJqty Then
	MessageBox('확 인','조정할 사항이 없습니다.!!')
	Return
End If

If MessageBox("확 인", "조정하시겠습니까?",	Exclamation!, OKCancel!, 2) = 2 Then Return

/* 변경전 설비에 대한 조정 */
sWkctr = dw_jogun.GetItemString(1, 'wkctr')
sMchno = dw_jogun.GetItemString(1, 'mchno')

/* 작업장 */
UPDATE PM01_CAPA_DTL
   SET S1QTY = DECODE(:ii_jucha,1,:djQty,S1QTY),
		 S2QTY = DECODE(:ii_jucha,2,:djQty,S2QTY),
		 S3QTY = DECODE(:ii_jucha,3,:djQty,S3QTY),
		 S4QTY = DECODE(:ii_jucha,4,:djQty,S4QTY),
		 S5QTY = DECODE(:ii_jucha,5,:djQty,S5QTY),
		 S6QTY = DECODE(:ii_jucha,6,:djQty,S6QTY),
		 LOTQTY1 = DECODE(:ii_jucha,1,:djQty,LOTQTY1),
		 LOTQTY2 = DECODE(:ii_jucha,2,:djQty,LOTQTY2),
		 LOTQTY3 = DECODE(:ii_jucha,3,:djQty,LOTQTY3),
		 LOTQTY4 = DECODE(:ii_jucha,4,:djQty,LOTQTY4),
		 LOTQTY5 = DECODE(:ii_jucha,5,:djQty,LOTQTY5),
		 LOTQTY6 = DECODE(:ii_jucha,6,:djQty,LOTQTY6)
 WHERE YYMM = :is_yymm
   AND ITNBR = :sItnbr
	AND WKCTR = :sWkctr;
If sqlca.sqlcode <> 0 Then
	MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext + ' #1')
	Rollback;
	Return
End If

/* 설비 */
If is_calgbn = '2' Then
	UPDATE PM01_CAPA_DTL_MCH
		SET S1QTY = DECODE(:ii_jucha,1,:djQty,S1QTY),
			 S2QTY = DECODE(:ii_jucha,2,:djQty,S2QTY),
			 S3QTY = DECODE(:ii_jucha,3,:djQty,S3QTY),
			 S4QTY = DECODE(:ii_jucha,4,:djQty,S4QTY),
			 S5QTY = DECODE(:ii_jucha,5,:djQty,S5QTY),
			 S6QTY = DECODE(:ii_jucha,6,:djQty,S6QTY),
			 LOTQTY1 = DECODE(:ii_jucha,1,:djQty,LOTQTY1),
			 LOTQTY2 = DECODE(:ii_jucha,2,:djQty,LOTQTY2),
			 LOTQTY3 = DECODE(:ii_jucha,3,:djQty,LOTQTY3),
			 LOTQTY4 = DECODE(:ii_jucha,4,:djQty,LOTQTY4),
			 LOTQTY5 = DECODE(:ii_jucha,5,:djQty,LOTQTY5),
			 LOTQTY6 = DECODE(:ii_jucha,6,:djQty,LOTQTY6)
	 WHERE YYMM = :is_yymm
		AND ITNBR = :sItnbr
		AND MCHNO = :sMchno;
	If sqlca.sqlcode <> 0 Then
		MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext + ' #2')
		Rollback;
		Return
	End If
End If

For ix = 1 To dw_1.RowCount()
	If dw_1.GetItemString(ix, 'opt') = 'N' Then Continue
	
	sWkctr = dw_1.GetItemString(ix, 'wkctr')
	sMchno = dw_1.GetItemString(ix, 'mchno')
	dQty   = dw_1.GetItemNumber(ix, 'qty')
	dMchr   = dw_1.GetItemNumber(ix, 'mchr')
	If IsNull(dQty) Or dQty <= 0 Then Continue

	/* 작업장 */
	SELECT COUNT(*) INTO :nCnt 
	  FROM PM01_CAPA_DTL
	 WHERE YYMM = :is_yymm
      AND ITNBR = :sItnbr
		AND WKCTR = :sWkctr;
		
	If nCnt > 0 Then
		UPDATE PM01_CAPA_DTL
			SET S1QTY = S1QTY + DECODE(:ii_jucha,1,:dQty,0),
			    S2QTY = S2QTY + DECODE(:ii_jucha,2,:dQty,0),
			    S3QTY = S3QTY + DECODE(:ii_jucha,3,:dQty,0),
			    S4QTY = S4QTY + DECODE(:ii_jucha,4,:dQty,0),
			    S5QTY = S5QTY + DECODE(:ii_jucha,5,:dQty,0),
				 S6QTY = S6QTY + DECODE(:ii_jucha,6,:dQty,0),
				 LOTQTY1 = LOTQTY1 + DECODE(:ii_jucha,1,:dQty,0),
				 LOTQTY2 = LOTQTY2 + DECODE(:ii_jucha,2,:dQty,0),
				 LOTQTY3 = LOTQTY3 + DECODE(:ii_jucha,3,:dQty,0),
				 LOTQTY4 = LOTQTY4 + DECODE(:ii_jucha,4,:dQty,0),
				 LOTQTY5 = LOTQTY5 + DECODE(:ii_jucha,5,:dQty,0),
				 LOTQTY6 = LOTQTY6 + DECODE(:ii_jucha,6,:dQty,0)
		 WHERE YYMM = :is_yymm
			AND ITNBR = :sItnbr
			AND WKCTR = :sWkctr;
	Else
		INSERT INTO PM01_CAPA_DTL
			( YYMM, ITNBR, WKCTR, MCHR, S1QTY, S2QTY, S3QTY, S4QTY, S5QTY, S6QTY, S7QTY, S8QTY,
			  LOTQTY1, LOTQTY2, LOTQTY3, LOTQTY4, LOTQTY5, LOTQTY6, LOTQTY7, LOTQTY8 )
		VALUES ( :is_yymm, :sItnbr, :sWkctr, :dMchr,
		         DECODE(:ii_jucha,1,:dQty,0),
					DECODE(:ii_jucha,2,:dQty,0),
					DECODE(:ii_jucha,3,:dQty,0),
					DECODE(:ii_jucha,4,:dQty,0),
					DECODE(:ii_jucha,5,:dQty,0), 
					DECODE(:ii_jucha,5,:dQty,0), 0,0,
					DECODE(:ii_jucha,1,:dQty,0),
					DECODE(:ii_jucha,2,:dQty,0),
					DECODE(:ii_jucha,3,:dQty,0),
					DECODE(:ii_jucha,4,:dQty,0),
					DECODE(:ii_jucha,5,:dQty,0), 
					DECODE(:ii_jucha,5,:dQty,0), 0,0);
	End If
	If sqlca.sqlcode <> 0 Then
		MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext + ' #3')
		Rollback;
		Return
	End If
	
	/* 설비 */
	If is_calgbn = '2' Then
		SELECT COUNT(*) INTO :nCnt 
		  FROM PM01_CAPA_DTL_MCH
		 WHERE YYMM = :is_yymm
			AND ITNBR = :sItnbr
			AND MCHNO = :sMchno;
			
		If nCnt > 0 Then
			UPDATE PM01_CAPA_DTL_MCH
				SET S1QTY = S1QTY + DECODE(:ii_jucha,1,:dQty,0),
					 S2QTY = S2QTY + DECODE(:ii_jucha,2,:dQty,0),
					 S3QTY = S3QTY + DECODE(:ii_jucha,3,:dQty,0),
					 S4QTY = S4QTY + DECODE(:ii_jucha,4,:dQty,0),
					 S5QTY = S5QTY + DECODE(:ii_jucha,5,:dQty,0),
					 S6QTY = S6QTY + DECODE(:ii_jucha,6,:dQty,0),
					 LOTQTY1 = LOTQTY1 + DECODE(:ii_jucha,1,:dQty,0),
					 LOTQTY2 = LOTQTY2 + DECODE(:ii_jucha,2,:dQty,0),
					 LOTQTY3 = LOTQTY3 + DECODE(:ii_jucha,3,:dQty,0),
					 LOTQTY4 = LOTQTY4 + DECODE(:ii_jucha,4,:dQty,0),
					 LOTQTY5 = LOTQTY5 + DECODE(:ii_jucha,5,:dQty,0),
					 LOTQTY6 = LOTQTY6 + DECODE(:ii_jucha,6,:dQty,0)
			 WHERE YYMM = :is_yymm
				AND ITNBR = :sItnbr
				AND MCHNO = :sMchno;
		Else
			INSERT INTO PM01_CAPA_DTL_MCH
				( YYMM, ITNBR, MCHNO, MCHR, S1QTY, S2QTY, S3QTY, S4QTY, S5QTY, S6QTY, S7QTY, S8QTY,
			  	  LOTQTY1, LOTQTY2, LOTQTY3, LOTQTY4, LOTQTY5, LOTQTY6, LOTQTY7, LOTQTY8  )
			VALUES ( :is_yymm, :sItnbr, :sMchno, :dMchr,
						DECODE(:ii_jucha,1,:dQty,0),
						DECODE(:ii_jucha,2,:dQty,0),
						DECODE(:ii_jucha,3,:dQty,0),
						DECODE(:ii_jucha,4,:dQty,0),
						DECODE(:ii_jucha,5,:dQty,0), 
						DECODE(:ii_jucha,6,:dQty,0), 0, 0,
						 LOTQTY1 = LOTQTY1 + DECODE(:ii_jucha,1,:dQty,0),
						 LOTQTY2 = LOTQTY2 + DECODE(:ii_jucha,2,:dQty,0),
						 LOTQTY3 = LOTQTY3 + DECODE(:ii_jucha,3,:dQty,0),
						 LOTQTY4 = LOTQTY4 + DECODE(:ii_jucha,4,:dQty,0),
						 LOTQTY5 = LOTQTY5 + DECODE(:ii_jucha,5,:dQty,0),
						 LOTQTY6 = LOTQTY6 + DECODE(:ii_jucha,6,:dQty,0) );
		End If
		If sqlca.sqlcode <> 0 Then
			MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext + ' #4')
			Rollback;
			Return
		End If
	End If
Next

COMMIT;

// 작업장 부하계산(사용공수만 재계산)
sqlca.PM01_CAPA_LOD_MONTH(gs_sabu, is_yymm, '3');
If sqlca.sqlcode <> 0 Then
	MessageBox(string(sqlca.sqlcode), SQLCA.SQLERRTEXT)
	RETURN
END iF

//// 설비 부하계산
//If is_calgbn = '2' Then
//	sqlca.PM01_CAPA_LOD_MONTH(gs_sabu, is_yymm, '4');
//	If sqlca.sqlcode <> 0 Then
//		MessageBox(string(sqlca.sqlcode), SQLCA.SQLERRTEXT)
//		RETURN
//	END iF
//End If

gs_code = 'OK'
Close(Parent)

end event

event p_inq::ue_lbuttondown;PictureName = 'C:\erpman\image\조정_dn.gif'
end event

event p_inq::ue_lbuttonup;PictureName = 'C:\erpman\image\조정_up.gif'
end event

type p_choose from w_inherite_popup`p_choose within w_pm01_01020_1
boolean visible = false
integer x = 1879
integer y = 12
integer taborder = 50
end type

type dw_1 from w_inherite_popup`dw_1 within w_pm01_01020_1
integer x = 55
integer y = 756
integer width = 2747
integer height = 916
integer taborder = 40
string dataobject = "d_pm01_01020_1_21"
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
		
		dJqty = dw_jogun.GetItemNumber(1, 'jqty')
		If IsNull(dJqty) Then dJqty = 0
		If dJqty - dQty < 0 Then
			MessageBox('확 인','계획수량이 (-)됩니다.!!')
			Return 2
		End If
		
		dw_jogun.SetItem(1, 'jqty', dJqty - dQty)
		
		If dJqty - dQty > 0 Then
			SetItem(row, 'opt','Y')
		End If
End Choose
end event

type sle_2 from w_inherite_popup`sle_2 within w_pm01_01020_1
end type

type cb_1 from w_inherite_popup`cb_1 within w_pm01_01020_1
end type

type cb_return from w_inherite_popup`cb_return within w_pm01_01020_1
end type

type cb_inq from w_inherite_popup`cb_inq within w_pm01_01020_1
end type

type sle_1 from w_inherite_popup`sle_1 within w_pm01_01020_1
end type

type st_1 from w_inherite_popup`st_1 within w_pm01_01020_1
end type

type st_2 from statictext within w_pm01_01020_1
integer x = 78
integer y = 672
integer width = 453
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
string text = "대체 작업장/설비"
boolean focusrectangle = false
end type

type st_3 from statictext within w_pm01_01020_1
integer x = 2377
integer y = 692
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
string text = "단위:분,수량"
boolean focusrectangle = false
end type

type rr_2 from roundrectangle within w_pm01_01020_1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 55
integer y = 192
integer width = 2747
integer height = 452
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within w_pm01_01020_1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 28144969
integer x = 59
integer y = 660
integer width = 526
integer height = 80
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_pm01_01020_1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 748
integer width = 2757
integer height = 928
integer cornerheight = 40
integer cornerwidth = 55
end type

