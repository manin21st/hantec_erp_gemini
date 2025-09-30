$PBExportHeader$w_pm01_02020_2.srw
$PBExportComments$월 생산능력 검토
forward
global type w_pm01_02020_2 from w_inherite_popup
end type
type rr_2 from roundrectangle within w_pm01_02020_2
end type
type rr_3 from roundrectangle within w_pm01_02020_2
end type
end forward

global type w_pm01_02020_2 from w_inherite_popup
integer width = 3717
integer height = 1428
string title = "일정 조정"
rr_2 rr_2
rr_3 rr_3
end type
global w_pm01_02020_2 w_pm01_02020_2

type variables
String is_Napgi[7]
Boolean ib_ok=TRUE, ib_change=false
end variables

on w_pm01_02020_2.create
int iCurrent
call super::create
this.rr_2=create rr_2
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
this.Control[iCurrent+2]=this.rr_3
end on

on w_pm01_02020_2.destroy
call super::destroy
destroy(this.rr_2)
destroy(this.rr_3)
end on

event open;Int nJucha
String sYymm

f_window_center_response(this)

dw_jogun.SetTransObject(sqlca)
dw_1.SetTransObject(sqlca)

dw_jogun.InsertRow(0)
dw_jogun.SetItem(1, 'itnbr', gs_code)
dw_jogun.SetItem(1, 'itdsc', gs_codename)
dw_jogun.SetItem(1, 'YYMM',  gs_gubun)

// 주차
sYymm = Left(gs_gubun,6)
SELECT MON_JUCHA INTO :nJucha FROM PDTWEEK WHERE WEEK_SDATE = :gs_gubun;
dw_jogun.SetItem(1, 'jucha',  nJucha)

// 생산일자 선정
Long ix, nCnt

For ix = 1 To 7
	select to_char(to_date(:gs_gubun,'yyyymmdd') + :ix - 1,'yyyymmdd') into :is_Napgi[ix] from dual;
Next

// Sub item에 대한 계획 수립되어있을 경우 end-item 조정 불가

SELECT COUNT(*) INTO :nCnt FROM PM01_MONPLAN_DTL WHERE SABU = :gs_sabu AND MONYYMM = :sYymm AND JUCHA = :nJucha AND MOGUB <> '0';
If nCnt > 0 Then
	ib_ok = False
Else
	ib_ok = True
End If

p_choose.TriggerEvent(Clicked!)
end event

event key;//
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_pm01_02020_2
integer x = 64
integer y = 48
integer width = 2080
integer height = 92
integer taborder = 30
string dataobject = "d_pm01_02020_2_1"
end type

type p_exit from w_inherite_popup`p_exit within w_pm01_02020_2
integer x = 3415
integer taborder = 20
end type

event p_exit::clicked;call super::clicked;SetNull(gs_code)

If ib_change Then
	MessageBox('확 인','계획자료가 변경되었습니다.~r~n~r~n부하계산을 다시 하세요.!!')
End If

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_pm01_02020_2
integer x = 3241
integer taborder = 10
string picturename = "C:\erpman\image\조정_up.gif"
end type

event p_inq::clicked;Long ix, iy, iChng, iNo
Dec  dQty1, dQty2,dQty3,dQty4,dQty5,dQty6,dQty7, dQty[7], dOld[7]
String sOrderNo, sdate, syymm, sCvcod, sItnbr, sCustGbn, sCustNapgi, sPordno, sMogub
Int    nJucha
String sjocod

sdate = dw_jogun.GetItemString(1, 'yymm')
syymm = Left(dw_jogun.GetItemString(1, 'yymm'),6)
nJucha = dw_jogun.GetItemNumber(1, 'jucha')

If dw_1.AcceptText() <> 1 Then Return

If MessageBox("확 인", "변경된 일정을 조정하시겠습니까?",	Exclamation!, OKCancel!, 2) = 2 Then Return

For ix = 1 To dw_1.RowCount()
	dQty1	= dw_1.GetItemNumber(ix, 'w1')
	dQty2	= dw_1.GetItemNumber(ix, 'w2')
	dQty3	= dw_1.GetItemNumber(ix, 'w3')
	dQty4	= dw_1.GetItemNumber(ix, 'w4')
	dQty5	= dw_1.GetItemNumber(ix, 'w5')
	dQty6	= dw_1.GetItemNumber(ix, 'w6')
	dQty7	= dw_1.GetItemNumber(ix, 'w7')
	If dw_1.GetItemNumber(ix, 'plan_qty') <> (dQty1+dQty2+dQty3+dQty4+dQty5+dQty6+dQty7) Then
		MessageBox('확 인','계획수량에 차이가 있습니다.!!')
		return
	End If
Next

For ix = 1 To dw_1.RowCount()
	sOrderNo = dw_1.GetItemString(ix, 'order_no')
	iChng		= 0
	
	For iy = 1 To 7
		dQty[iy]	= dw_1.GetItemNumber(ix, 'w'+string(iy))		// New Value
		dOld[iy]	= dw_1.GetItemNumber(ix, 'old_w'+string(iy)) // Old Value
		
		If dQty[iy] <> dOld[iy] Then
			iChng++
		End If
	Next
	
	// 변경된 자료가 있을 경우 기존 자료 cancel후 신규로 자료 작성
	If iChng > 0 Then
		sCvcod 		= dw_1.GetItemString(ix, 'cvcod')
		sItnbr 		= dw_1.GetItemString(ix, 'itnbr')
		sCustGbn 	= dw_1.GetItemString(ix, 'custgbn')
		sMogub	 	= dw_1.GetItemString(ix, 'mogub')
		sCustNapgi 	= dw_1.GetItemString(ix, 'cust_napgi')
		
		UPDATE PM01_MONPLAN_DTL
		   SET PLANSTS = 'C'
		 WHERE SABU = :gs_sabu
		 	AND MONYYMM = :syymm
			AND JUCHA = :nJucha
			AND ITNBR = :sItnbr
			AND ORDER_NO = :sOrderNo;
		If sqlca.sqlcode <> 0 Then
			MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext + ' #2')
			Rollback;
			Return
		End If
		
		SELECT MAX(MONSEQ) INTO :iNo
		  FROM PM01_MONPLAN_DTL
		 WHERE SABU = :gs_sabu AND MONYYMM = :syymm AND JUCHA = :nJucha;
		
		select jocod into :sjocod from itemas where itnbr = :sitnbr;
		
		For iy = 1 To 7
			If dQty[iy] > 0 Then
				iNo = iNo + 1
				
				sPordno = sdate + string(iNo,'00000')
				
				INSERT INTO PM01_MONPLAN_DTL 
						 ( SABU,        MONYYMM,     MONSEQ, CVCOD,   ITNBR,      PLAN_QTY,  ORDER_NO,  CUST_NAPGI,  CUSTGBN, 
						   ESDATE,      EEDATE,      MOGUB,  PLANSTS, PLDATE,     JUCHA,     PORDNO, JOCOD )
				 values( :gs_sabu,    :syymm,      :iNo,   :sCvcod, :sItnbr,    :dQty[iy], :sOrderNo, :sCustNapgi, :sCustGbn,
				         :is_Napgi[iy], :is_Napgi[iy], :sMogub,    'N',     :is_Napgi[iy], :nJucha,   :sPordno, :sjocod  );
				If sqlca.sqlcode <> 0 Then
					MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext + ' #3')
					Rollback;
					Return
				End If
			End If
		Next
	End If
Next

ib_change = true

COMMIT;

p_choose.TriggerEvent(Clicked!)
end event

event p_inq::ue_lbuttondown;PictureName = 'C:\erpman\image\조정_dn.gif'
end event

event p_inq::ue_lbuttonup;PictureName = 'C:\erpman\image\조정_up.gif'
end event

type p_choose from w_inherite_popup`p_choose within w_pm01_02020_2
boolean visible = false
integer x = 2286
integer y = 24
integer taborder = 50
end type

event p_choose::clicked;call super::clicked;String sdate, sitnbr, s1, e1
Int    nJucha

sdate  = dw_jogun.GetItemString(1,'yymm')
nJucha = dw_jogun.GetItemNumber(1,'jucha')
sItnbr = dw_jogun.GetItemString(1,'itnbr')

select min(week_sdate), max(week_edate) into :s1, :e1 from pdtweek where week_sdate = :sdate;

dw_1.Retrieve(gs_sabu, left(sdate,6), sitnbr, s1, e1, nJucha)
end event

type dw_1 from w_inherite_popup`dw_1 within w_pm01_02020_2
integer x = 55
integer y = 184
integer width = 3625
integer height = 1132
integer taborder = 40
string dataobject = "d_pm01_02020_2_2"
end type

event dw_1::itemchanged;call super::itemchanged;String sCustNapgi, sMogub, sCustGbn

Choose Case GetColumnName()
	Case 'w1', 'w2', 'w3', 'w4', 'w5', 'w6', 'w7'
		sMogub	  = GetItemString(row, 'mogub')
		sCustNapgi = GetItemString(row, 'cust_napgi')
		
		If ib_ok = False And sMogub = '0' Then
			MessageBox('확인','소요량계산 이후에는 END-ITEM에 대해서 조정이 불가능합니다.!!')
			Return 2
		End If
		
		/* 수출/시판인 경우만 납기요구일을 체크 2003.09.27 */
		sCustGbn = GetItemString(row, 'custgbn')
		If sCustGbn = '5' Or sCustGbn = '6' Then
			If sCustNapgi < is_napgi[Integer(Right(GetColumnName(),1))] Then
				MessageBox('확인','납기요구일보다 이후일자로 지정하실 수 없습니다.!!')
				Return 2
			End If
		End If
End Choose
end event

event dw_1::rowfocuschanged;//
end event

event dw_1::ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

type sle_2 from w_inherite_popup`sle_2 within w_pm01_02020_2
end type

type cb_1 from w_inherite_popup`cb_1 within w_pm01_02020_2
end type

type cb_return from w_inherite_popup`cb_return within w_pm01_02020_2
end type

type cb_inq from w_inherite_popup`cb_inq within w_pm01_02020_2
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_pm01_02020_2
end type

type st_1 from w_inherite_popup`st_1 within w_pm01_02020_2
end type

type rr_2 from roundrectangle within w_pm01_02020_2
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 16777215
integer x = 55
integer y = 32
integer width = 2162
integer height = 132
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_pm01_02020_2
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 180
integer width = 3648
integer height = 1144
integer cornerheight = 40
integer cornerwidth = 55
end type

