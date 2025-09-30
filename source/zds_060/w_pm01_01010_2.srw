$PBExportHeader$w_pm01_01010_2.srw
$PBExportComments$생산계획 추가
forward
global type w_pm01_01010_2 from w_inherite_popup
end type
type rr_2 from roundrectangle within w_pm01_01010_2
end type
type rr_3 from roundrectangle within w_pm01_01010_2
end type
end forward

global type w_pm01_01010_2 from w_inherite_popup
integer width = 2446
integer height = 1428
string title = "생산계획 추가"
rr_2 rr_2
rr_3 rr_3
end type
global w_pm01_01010_2 w_pm01_01010_2

type variables
String is_Napgi[8]
Boolean ib_ok=TRUE, ib_change=false, ib_new
end variables

on w_pm01_01010_2.create
int iCurrent
call super::create
this.rr_2=create rr_2
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
this.Control[iCurrent+2]=this.rr_3
end on

on w_pm01_01010_2.destroy
call super::destroy
destroy(this.rr_2)
destroy(this.rr_3)
end on

event open;Long ix, nCnt
String sYymm, sItdsc

If Message.StringParm = 'NEW' Then
	ib_new = True
Else
	ib_new = False
End If

sYymm = gs_codename

f_window_center_response(this)

// Sub item에 대한 계획 수립되어있을 경우 end-item 조정 불가
//SELECT COUNT(*) INTO :nCnt FROM PM01_MONPLAN_DTL 
// WHERE SABU = :gs_sabu AND MONYYMM = :sYymm AND MOGUB = '2' AND JUCHA = 0;
//If nCnt > 0 Then
//	ib_ok = False
//	MessageBox('확 인','SUB ITEM에 대한 소요량 전개가 되어있습니다.!!')
//	Close(This)
//	Return
//Else
//	ib_ok = True
//End If

ib_ok = True

// 생산일자 선정
For ix = 1 To 6
	select min(week_sdate) into :is_Napgi[ix] from pdtweek where substr(week_sdate,1,6) = :sYymm and mon_jucha = :ix;
Next
For ix = 1 To 2
	select min(week_sdate) into :is_Napgi[ix+6] from pdtweek where substr(week_sdate,1,6) = to_char(add_months(to_date(:sYymm,'yyyymm'), :ix),'yyyymm');
Next

dw_jogun.SetTransObject(sqlca)
dw_1.SetTransObject(sqlca)

If IsNull(gs_code) Then		// 신규계획자료인 경우
	dw_jogun.InsertRow(0)
		
	dw_1.InsertRow(0)
Else
	dw_jogun.InsertRow(0)
	dw_jogun.SetItem(1, 'itnbr', gs_code)
	
	select itdsc into :sItdsc from itemas where itnbr = :gs_code;
	dw_jogun.SetItem(1, 'itdsc', sItdsc)
	
	p_choose.PostEvent(Clicked!)
End If

dw_jogun.SetItem(1, 'mogub', gs_gubun)
dw_jogun.SetItem(1, 'YYMM',  sYymm)		// 계획년월
end event

event key;//
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_pm01_01010_2
integer x = 64
integer y = 48
integer width = 1783
integer height = 92
integer taborder = 30
string dataobject = "d_pm01_01010_2_1"
end type

event dw_jogun::itemchanged;call super::itemchanged;String sItnbr, sNull, sYymm, sitdsc, sispec, sjijil, sispeccode, get_itnbr
Int    ireturn, nCnt

SetNull(sNull)

sYymm = GetItemString(1, 'yymm')

Choose Case GetColumnName()
	Case "itnbr"
		sItnbr = trim(this.GetText())
	
		if sitnbr = "" or isnull(sitnbr) then
			this.setitem(1, "itdsc", sNull)	
			return 
		end if

		//등록된 자료에서 체크
	  SELECT COUNT(*)  
		 INTO :nCnt
		 FROM "PM01_MONPLAN_DTL"  
		WHERE ( "PM01_MONPLAN_DTL"."SABU" = :gs_sabu ) AND  
				( "PM01_MONPLAN_DTL"."MONYYMM" = SUBSTR(:syymm,1,6) ) AND  
				( "PM01_MONPLAN_DTL"."ITNBR" = :sitnbr ) AND
				( "PM01_MONPLAN_DTL"."JUCHA" = 0 ) AND
				( "PM01_MONPLAN_DTL"."PLANSTS" <> 'C' );
	
		if nCnt = 0 then 
			ireturn = f_get_name4_sale('품번', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	//1이면 성공, 0이 실패		
			this.setitem(1, "itnbr", sitnbr)	
			this.setitem(1, "itdsc", sitdsc)	
	
			RETURN ireturn
		else
			f_message_chk(37,'[품번]') 
			this.setitem(1, "itdsc", sNull)
			RETURN 1
		end if
End Choose
end event

event dw_jogun::itemerror;call super::itemerror;return 1
end event

event dw_jogun::rbuttondown;call super::rbuttondown;Integer iCurRow

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

iCurRow = this.GetRow()
IF this.GetcolumnName() ="itnbr" THEN
	Open(w_itemas_popup)
	IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	
	this.SetItem(iCurRow,"itnbr",gs_code)
	TriggerEvent(ItemChanged!)
	Return 1
END IF
end event

type p_exit from w_inherite_popup`p_exit within w_pm01_01010_2
integer x = 2144
integer y = 16
integer taborder = 20
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event p_exit::clicked;call super::clicked;SetNull(gs_code)

If ib_change Then
//	MessageBox('확 인','계획자료가 변경되었습니다.~r~n~r~n부하계산을 다시 하세요.!!')
End If

Close(Parent)
end event

event p_exit::ue_lbuttondown;PictureName = 'C:\erpman\image\닫기_dn.gif'
end event

event p_exit::ue_lbuttonup;PictureName = 'C:\erpman\image\닫기_up.gif'
end event

type p_inq from w_inherite_popup`p_inq within w_pm01_01010_2
integer x = 1970
integer y = 16
integer taborder = 10
string picturename = "C:\erpman\image\저장_up.gif"
end type

event p_inq::clicked;Long ix, iy, iChng, iNo
Dec  dQty1, dQty2,dQty3,dQty4,dQty5,dQty6,dQty7,dQty8, dQty[8], dOld[8]
String sOrderNo, syymm, sCvcod, sItnbr, sCustGbn, sCustNapgi, sPordno, sMogub
String sjocod

syymm = dw_jogun.GetItemString(1, 'yymm')

If dw_1.AcceptText() <> 1 Then Return

If MessageBox("확 인", "변경된 일정을 조정하시겠습니까?",	Exclamation!, OKCancel!, 2) = 2 Then Return

/* 신규생성인 경우 */
If ib_new Then
	// 자사거래처 코드
	select dataname into :sCvcod from syscnfg where sysgu = 'C' AND serial = '4' and lineno = 1;

	sItnbr 		= dw_jogun.GetItemString(1, 'itnbr')
	sMogub	 	= dw_jogun.GetItemString(1, 'mogub')
	
	// 조코드 선택
	SELECT PDTGU INTO :sjocod FROM ITEMAS WHERE ITNBR = :sItnbr;
	
	For ix = 1 To dw_1.RowCount()
		sCustGbn 	= 'Z'	// 고객구분은 초도품으로 ...
				
		SELECT NVL(MAX(MONSEQ),0) INTO :iNo
		  FROM PM01_MONPLAN_DTL
		 WHERE SABU = :gs_sabu AND MONYYMM = :syymm AND JUCHA = 0;
		
		sOrderNo 	= syymm + string(iNo + 1,'00000')
		For iy = 1 To 8
			dQty[iy] = dw_1.GetItemNumber(ix, 'w'+string(iy))
			If dQty[iy] > 0 Then
				iNo = iNo + 1
				
				sPordno 		= syymm + string(iNo,'00000')
				
				INSERT INTO PM01_MONPLAN_DTL 
						 ( SABU,        MONYYMM,     MONSEQ, CVCOD,   ITNBR,      PLAN_QTY,  ORDER_NO,  CUST_NAPGI,  CUSTGBN, 
							ESDATE,      EEDATE,      MOGUB,  PLANSTS, PLDATE,     JUCHA,     PORDNO,    JOCOD )
				 values( :gs_sabu,    :syymm,      :iNo,   :sCvcod, :sItnbr,    :dQty[iy], :sOrderNo, :is_Napgi[iy], :sCustGbn,
							:is_Napgi[iy], :is_Napgi[iy], :sMogub,    'N',     :is_Napgi[iy], 0,		   :sPordno, :sjocod  );
				If sqlca.sqlcode <> 0 Then
					MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext + ' #3')
					Rollback;
					Return
				End If
			End If
		Next
	Next
Else
	sMogub	 	= dw_jogun.GetItemString(1, 'mogub')
	
	// 판매계획인 경우만 수량 체크한다
	If sMogub = '0' Then
		For ix = 1 To dw_1.RowCount()
			dQty1	= dw_1.GetItemNumber(ix, 'w1')
			dQty2	= dw_1.GetItemNumber(ix, 'w2')
			dQty3	= dw_1.GetItemNumber(ix, 'w3')
			dQty4	= dw_1.GetItemNumber(ix, 'w4')
			dQty5	= dw_1.GetItemNumber(ix, 'w5')
			dQty6	= dw_1.GetItemNumber(ix, 'w6')
			dQty7	= dw_1.GetItemNumber(ix, 'w7')
			dQty8	= dw_1.GetItemNumber(ix, 'w8')
			If dw_1.GetItemNumber(ix, 'plan_qty') <> (dQty1+dQty2+dQty3+dQty4+dQty5+dQty6+dQty7+dQty8) Then
				MessageBox('확 인','계획수량에 차이가 있습니다.!!')
				return
			End If
		Next
	End If
	
	For ix = 1 To dw_1.RowCount()
		sOrderNo = dw_1.GetItemString(ix, 'order_no')
		iChng		= 0
		
		For iy = 1 To 8
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
//			sCustNapgi 	= dw_1.GetItemString(ix, 'cust_napgi')
			
			UPDATE PM01_MONPLAN_DTL
				SET PLANSTS = 'C'
			 WHERE SABU = :gs_sabu
				AND MONYYMM = :syymm
				AND ITNBR = :sItnbr
				AND ORDER_NO = :sOrderNo
				AND JUCHA = 0;
			If sqlca.sqlcode <> 0 Then
				MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext + ' #2')
				Rollback;
				Return
			End If
			
			SELECT NVL(MAX(MONSEQ),0) INTO :iNo
			  FROM PM01_MONPLAN_DTL
			 WHERE SABU = :gs_sabu AND MONYYMM = :syymm AND JUCHA = 0;

			// 조코드 선택
			SELECT PDTGU INTO :sjocod FROM ITEMAS WHERE ITNBR = :sItnbr;
	
			For iy = 1 To 8
				If dQty[iy] > 0 Then
					iNo = iNo + 1
					
					sPordno = syymm + string(iNo,'00000')
					
					INSERT INTO PM01_MONPLAN_DTL 
							 ( SABU,        MONYYMM,     MONSEQ, CVCOD,   ITNBR,      PLAN_QTY,  ORDER_NO,  CUST_NAPGI,  CUSTGBN, 
								ESDATE,      EEDATE,      MOGUB,  PLANSTS, PLDATE,     JUCHA,     PORDNO, JOCOD )
					 values( :gs_sabu,    :syymm,      :iNo,   :sCvcod, :sItnbr,    :dQty[iy], :sOrderNo, :is_Napgi[iy], :sCustGbn,
								:is_Napgi[iy], :is_Napgi[iy], :sMogub,    'N',     :is_Napgi[iy], 0,		   :sPordno, :sjocod  );
					If sqlca.sqlcode <> 0 Then
						MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext + ' #3')
						Rollback;
						Return
					End If
				End If
			Next
		End If
	Next
End If

ib_change = true

COMMIT;

p_choose.TriggerEvent(Clicked!)
end event

event p_inq::ue_lbuttondown;PictureName = 'C:\erpman\image\저장_dn.gif'
end event

event p_inq::ue_lbuttonup;PictureName = 'C:\erpman\image\저장_up.gif'
end event

type p_choose from w_inherite_popup`p_choose within w_pm01_01010_2
boolean visible = false
integer x = 2496
integer y = 148
integer taborder = 50
end type

event p_choose::clicked;call super::clicked;String syymm, sitnbr, s1, e1, s2,e2, s3, e3


syymm = dw_jogun.GetItemString(1,'yymm')
sItnbr = dw_jogun.GetItemString(1,'itnbr')

select min(week_sdate), max(week_edate) into :s1, :e1 from pdtweek where substr(week_sdate,1,6) = :syymm;
select min(week_sdate), max(week_edate) into :s2, :e2 from pdtweek where substr(week_sdate,1,6) = to_char(add_months(to_date(:syymm,'yyyymm'),1),'yyyymm');
select min(week_sdate), max(week_edate) into :s3, :e3 from pdtweek where substr(week_sdate,1,6) = to_char(add_months(to_date(:syymm,'yyyymm'),2),'yyyymm');

dw_1.Retrieve(gs_sabu, syymm, sitnbr, s1, e1, s2,e2, s3, e3)

dw_1.object.t_mm1.text = string(f_aftermonth(syymm, 1), '@@@@.@@')
dw_1.object.t_mm2.text = string(f_aftermonth(syymm, 2), '@@@@.@@')
end event

type dw_1 from w_inherite_popup`dw_1 within w_pm01_01010_2
integer x = 55
integer y = 192
integer width = 2309
integer height = 1112
integer taborder = 40
string dataobject = "d_pm01_01010_2_2"
end type

event dw_1::itemchanged;call super::itemchanged;String sCustNapgi, sMogub
Int    iy

Choose Case GetColumnName()
	Case 'w1', 'w2', 'w3', 'w4', 'w5', 'w6', 'w7', 'w8'
		sMogub	  = GetItemString(row, 'mogub')
//		sCustNapgi = GetItemString(row, 'cust_napgi')
		
		If ib_ok = False And sMogub = '0' Then
			MessageBox('확인','소요량계산 이후에는 END-ITEM에 대해서 조정이 불가능합니다.!!')
			Return 2
		End If
		
		iy = Integer(Right(GetColumnName(),1))
		
		If IsNull(is_napgi[iy]) Or is_napgi[iy] = '' Then
			MessageBox('확인','주차를 확인하십시요.!!')
			Return 2
		End If			
			
//		If sCustNapgi < is_napgi[iy] Then
//			MessageBox('확인','납기요구일보다 이후일자로 지정하실 수 없습니다.!!')
//			Return 2
//		End If
End Choose
end event

event dw_1::rowfocuschanged;//
end event

event dw_1::ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

type sle_2 from w_inherite_popup`sle_2 within w_pm01_01010_2
end type

type cb_1 from w_inherite_popup`cb_1 within w_pm01_01010_2
end type

type cb_return from w_inherite_popup`cb_return within w_pm01_01010_2
end type

type cb_inq from w_inherite_popup`cb_inq within w_pm01_01010_2
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_pm01_01010_2
end type

type st_1 from w_inherite_popup`st_1 within w_pm01_01010_2
end type

type rr_2 from roundrectangle within w_pm01_01010_2
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 16777215
integer x = 55
integer y = 32
integer width = 1806
integer height = 132
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_pm01_01010_2
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 180
integer width = 2331
integer height = 1136
integer cornerheight = 40
integer cornerwidth = 55
end type

