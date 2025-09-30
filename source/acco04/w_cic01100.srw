$PBExportHeader$w_cic01100.srw
$PBExportComments$제품 기말재고조정
forward
global type w_cic01100 from w_inherite
end type
type dw_2 from datawindow within w_cic01100
end type
type gb_4 from groupbox within w_cic01100
end type
type dw_1 from datawindow within w_cic01100
end type
type rr_1 from roundrectangle within w_cic01100
end type
end forward

global type w_cic01100 from w_inherite
string title = "제품 기말재고조정"
dw_2 dw_2
gb_4 gb_4
dw_1 dw_1
rr_1 rr_1
end type
global w_cic01100 w_cic01100

type variables
Boolean itemerr =False
String     LsIttyp
end variables

forward prototypes
public function integer wf_requiredchk (integer ll_row)
public function integer wf_dup_chk (integer ll_row)
public subroutine wf_button_chk (string as_gubun, long al_rowcnt)
public function integer wf_procedure (string as_workym, string as_itemclass, string as_prcid)
end prototypes

public function integer wf_requiredchk (integer ll_row);//String sWorkym, sItnbr
//
//dw_2.AcceptText()
//sWorkym = dw_2.GetItemString(ll_row, 'workym')
//sItnbr  = dw_2.GetItemString(ll_row, 'itnbr')
//
//If sWorkym = "" Or IsNull(sWorkym) Then
//	f_messagechk(1, '[수불년월]')
//	dw_1.SetColumn('workym')
//	dw_1.SetFocus()
//	Return -1
//End If
//
//If sItnbr = "" Or IsNull(sItnbr) Then
//	f_messagechk(1, '[제품명]')
//	dw_2.SetColumn('sale_qty')
//	dw_2.SetFocus()
//	Return -1
//End If
Return 1
end function

public function integer wf_dup_chk (integer ll_row);Return 1
end function

public subroutine wf_button_chk (string as_gubun, long al_rowcnt);Choose Case as_gubun
	//초기화	
	Case 'C'
		p_search.Enabled = False
		p_search.PictureName =  'C:\erpman\image\생성_d.gif'
		p_ins.enabled = False
		p_ins.PictureName = 'C:\erpman\image\전체삭제_d.gif'
	//조회
	Case 'Q'
		If al_Rowcnt > 0 Then
			p_search.Enabled = False
			p_search.PictureName =  'C:\erpman\image\생성_d.gif'
			p_ins.enabled = True
			p_ins.PictureName = 'C:\erpman\image\전체삭제_up.gif'
		Else	
			p_search.Enabled = True
			p_search.PictureName =  'C:\erpman\image\생성_up.gif'
			p_ins.enabled = False
			p_ins.PictureName = 'C:\erpman\image\전체삭제_d.gif'
		End If	
	//저장
	Case 'S'
			p_search.Enabled = False
			p_search.PictureName =  'C:\erpman\image\생성_d.gif'
			p_ins.enabled = True
			p_ins.PictureName = 'C:\erpman\image\전체삭제_up.gif'
	//삭제
	Case 'D'
			p_search.Enabled = True
			p_search.PictureName =  'C:\erpman\image\생성_up.gif'
			p_ins.enabled = False
			p_ins.PictureName = 'C:\erpman\image\전체삭제_d.gif'
	Case Else
End Choose
		
end subroutine

public function integer wf_procedure (string as_workym, string as_itemclass, string as_prcid);// Stored Procedure 처리변수
// 처리 변수:당월
// 처리Return 변수:처리결과
String sPrcRtn //처리결과
// 처리결과 메시지 처리변수(메시지구분, 메시지, 처리 PROCEDURE)
String sRtnGbn, sRtnMsg, sRtnPrcName

// Stored Procedure call
Choose Case as_prcid
   // 제품재고실사 집계(제품수불 집계(CIC0130) (당월:기말재고 수량))
	Case 'CIC05013' //임재주
		DECLARE SP_CREATE_CIC05013 PROCEDURE FOR CIC05013 (:as_workym) USING SQLCA;
   // 생산량집계  (제품수불 집계(CIC0130) (당월:당기출고+기말재고-기초재고 수량)
   // (당기입고)-> 제품수불 집계(CIC0130) (당월:당기입고 수량))
   //           -> 생산량내역(CIC0110) (당월:생산량))
   //           -> 생산량집계(CIC0117) (당월:생산량))
	Case 'CIC06011' //남흥모
      // 1.생산량집계(CIC0117), 생산량내역(CIC0110): 당월 삭제
      // 2.제품수불 집계(CIC0130): 당월 자료 당기입고 생산량 UPDATE
      // 3.생산량 내역(CIC0110): 당월 자료 존재시 (+) UPDATE, 미존재시 INSERT
      // 4.생산량 집계(CIC0117): 당월 자료 존재시 (+) UPDATE, 미존재시 INSERT
      //   SCR(11),JCR(12),안산(41)(품목구분의 공통코드로 처리:신선가공 제외)
      // 5.생산량 집계(CIC0117): 당월 자료 존재시 (+) UPDATE, 미존재시 INSERT
      //   품목구분: 1121(SCR 경동선), 1221(JCR 경동선) -> 22:신선(경동)
      //   품목구분: 1123(SCR 연동선), 1223(JCR 연동선) -> 23:신선(연동)
		DECLARE SP_CREATE_CIC06011 PROCEDURE FOR CIC06011 (:as_workym) USING SQLCA;
	Case Else
End Choose

Choose Case as_prcid
	Case 'CIC05013'	
		EXECUTE SP_CREATE_CIC05013;
	Case 'CIC06011'	
		EXECUTE SP_CREATE_CIC06011;
	Case Else
End Choose

If SQLCA.SQLCODE < 0 Then
	f_message_chk(57, "~r~n~r~n[EXECUTE SP_CREATE_PRCID]~r~n~r~n" + SQLCA.SQLERRTEXT)	// 자료를 처리할 수 없습니다.
	Choose Case as_prcid
		Case 'CIC05013'	
			CLOSE SP_CREATE_CIC05013;
		Case 'CIC06011'	
			CLOSE SP_CREATE_CIC06011;
		Case Else
	End Choose
	RollBack;
	Return -1
End If

Choose Case as_prcid
	Case 'CIC05013'	
		FETCH SP_CREATE_CIC05013 INTO :sPrcRtn ;
	Case 'CIC06011'	
		FETCH SP_CREATE_CIC06011 INTO :sPrcRtn ;
	Case Else
End Choose

If SQLCA.SQLCODE < 0 Then
	f_message_chk(57, "~r~n~r~n[FETCH SP_CREATE_PRCID]~r~n~r~n" + SQLCA.SQLERRTEXT)	// 자료를 처리할 수 없습니다.
	Choose Case as_prcid
		Case 'CIC05013'	
			CLOSE SP_CREATE_CIC05013;
		Case 'CIC06011'	
			CLOSE SP_CREATE_CIC06011;
		Case Else
	End Choose
	RollBack;
	Return -1
End If

sRtnGbn     = Left(Trim(sPrcRtn), 1)                          //메시지구분
sRtnMsg     = Mid(Trim(sPrcRtn), 3, Len(Trim(sPrcRtn)) - 11 ) //메시지
sRtnPrcName = Right(Trim(sPrcRtn), 8)                         //처리 Procedure
Choose Case sRtnGbn
	Case 'E' // 오류
		f_message_chk(57, "~r~n~r~n[처리결과 메시지구분 = E(오류)]~r~n~r~n" + SQLCA.SQLERRTEXT)	// 자료를 처리할 수 없습니다.
		w_mdi_frame.sle_msg.text = sRtnGbn + ": " + sRtnMsg + " 프로시즈: " + sRtnPrcName
		RollBack;
		Return -1
	Case 'F' // 강제완료
		f_message_chk(57, "~r~n~r~n[처리결과 메시지구분 = F(강제종료)]~r~n~r~n" + SQLCA.SQLERRTEXT)	// 자료를 처리할 수 없습니다.
		w_mdi_frame.sle_msg.text = sRtnGbn + ": " + sRtnMsg + " 프로시즈: " + sRtnPrcName
		RollBack;
		Return -1
	Case 'R' // 정상
		w_mdi_frame.sle_msg.text = sRtnGbn + ": " + sRtnMsg + " 프로시즈: " + sRtnPrcName
	Case Else
End Choose	

Choose Case as_prcid
	Case 'CIC05013'	
		CLOSE SP_CREATE_CIC05013;
	Case 'CIC06011'	
		CLOSE SP_CREATE_CIC06011;
	Case Else
End Choose

Return 1
end function

on w_cic01100.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.gb_4=create gb_4
this.dw_1=create dw_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.gb_4
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.rr_1
end on

on w_cic01100.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_2)
destroy(this.gb_4)
destroy(this.dw_1)
destroy(this.rr_1)
end on

event open;call super::open;string vWorkym

SELECT nvl(fun_get_aftermonth(max(workym), 1),substr(to_char(sysdate,'yyyymmdd'),1,6))
   INTO :vWorkym
   FROM CIC0010
 WHERE  end_yn = 'Y';
 
dw_1.SetTransObject(SQLCA)
dw_1.Reset()
dw_1.InsertRow(0)

//dw_1.SetItem(1, 'workym', f_aftermonth( Left(f_today(),6), -1))
dw_1.SetItem(1, 'workym', vWorkym)
dw_1.SetFocus()

dw_2.SetTransObject(SQLCA)
dw_2.Reset()

wf_button_chk('C', 0)
end event

type dw_insert from w_inherite`dw_insert within w_cic01100
boolean visible = false
integer x = 41
integer y = 2404
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_cic01100
boolean visible = false
integer x = 5202
integer y = 184
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_cic01100
boolean visible = false
integer x = 5029
integer y = 184
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_cic01100
integer x = 3566
integer taborder = 20
string picturename = "C:\erpman\image\생성_d.gif"
end type

event p_search::ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\생성_dn.gif"
end event

event p_search::ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\생성_up.gif"
end event

event p_search::clicked;call super::clicked;String sWorkym, sImgbn, snull 
Long   lRecCnt
SetNull(snull)

If dw_1.Accepttext() = -1 Then Return

sWorkym = Trim(dw_1.GetItemString(dw_1.GetRow(), 'workym'))
If sWorkym = "" Or IsNull(sWorkym) Then
	f_messagechk(1,'[수불년월]')
	dw_1.SetColumn('workym')
	dw_1.SetFocus()
	Return
End If

sImgbn = Trim(dw_1.GetItemString(dw_1.GetRow(), 'imgbn'))
If sImgbn = "" Or IsNull(sImgbn) Then
	sImgbn = '%'
Else	
	MessageBox("알림", "수불년월에 대한 전체만 생성가능 합니다.!!!")
	dw_1.SetItem(dw_1.GetRow(), 'imgbn', snull)
	dw_1.SetColumn('imgbn')
	dw_1.SetFocus()
	Return
End If

////품목별 경비배부표
//SELECT count(*)
//  INTO :lRecCnt
//  FROM CIC0310
// WHERE WORKYM = :sWorkym;
//
//If lRecCnt > 0 Then
//	Messagebox('알림', '원가계산 처리된 당월의 기말재고는 생성할 수 없습니다.')
//	Return 
//End If

// 제품재고실사 집계(제품수불 집계(CIC0130) (당월:기말재고 수량))
If wf_procedure(sWorkym, sImgbn, 'CIC05013') = -1 Then
	Rollback;
	f_messagechk(13, '')
	Return
End If

// 생산량집계  (제품수불 집계(CIC0130) (당월:당기출고+기말재고-기초재고 수량)
// (당기입고)-> 제품수불 집계(CIC0130) (당월:당기입고 수량))
//           -> 생산량내역(CIC0110) (당월:생산량))
//           -> 생산량집계(CIC0117) (당월:생산량))
If wf_procedure(sWorkym, sImgbn, 'CIC06011') = -1 Then
	Rollback;
	f_messagechk(13, '')
	Return
End If

p_inq.TriggerEvent(Clicked!)

end event

type p_ins from w_inherite`p_ins within w_cic01100
integer x = 4087
integer taborder = 50
string pointer = "C:\erpman\cur\new.cur"
string picturename = "C:\erpman\image\전체삭제_d.gif"
end type

event p_ins::clicked;call super::clicked;String sWorkym, sImgbn, snull
Long	 lRowcnt, lRecCnt
SetNull(snull)

If dw_1.Accepttext() = -1 Then Return

sWorkym = Trim(dw_1.GetItemString(dw_1.GetRow(), 'workym'))
If sWorkym = "" Or IsNull(sWorkym) Then
	f_messagechk(1, '[수불년월]')
	dw_1.SetColumn('workym')
	dw_1.SetFocus()
	Return
End If

sImgbn = Trim(dw_1.GetItemString(dw_1.GetRow(), 'imgbn'))
If Not (sImgbn = "" Or IsNull(sImgbn)) Then
	MessageBox("알림", "수불년월에 대한 전체만 삭제가능 합니다.!!!")
	dw_1.SetItem(dw_1.GetRow(), 'imgbn', snull)
	dw_1.SetColumn('imgbn')
	dw_1.SetFocus()
	Return
End If

If dw_2.AcceptText() = -1 Then Return
If dw_2.RowCount() <= 0 Then
	MessageBox("알림", "조회후 삭제하세요.!!!")
	dw_1.SetColumn('workym')
	dw_1.SetFocus()
	Return
End If

////품목별 경비배부표
//SELECT count(*)
//  INTO :lRecCnt
//  FROM CIC0310
// WHERE WORKYM = :sWorkym;
//
//If lRecCnt > 0 Then
//	Messagebox('알림', '원가계산 처리된 당월의 기말재고는 삭제할 수 없습니다.')
//	Return 
//End If

////제품수불 집계
//SELECT count(*)
//  INTO :lRecCnt
//  FROM CIC0130
// WHERE WORKYM > :sWorkym;
//
//If lRecCnt > 0 Then
//	Messagebox('알림', '차월의 기말재고 자료가 존재하여 당월의 기말재고는 삭제할 수 없습니다.')
//	Return 
//End If

w_mdi_frame.sle_msg.text = ""
If f_msg_delete() = -1 Then Return

//생산량 집계
DELETE FROM CIC0117 WHERE WORKYM = :sWorkym;

If sqlca.sqlcode <> 0 then 
	Rollback;
	Messagebox("삭제실패", "자료에 대한 삭제에 실패하였읍니다.")
	w_mdi_frame.sle_msg.text = ""
	Return
End if

//생산량 내역
DELETE FROM CIC0110 WHERE WORKYM = :sWorkym;

If sqlca.sqlcode <> 0 then 
	Rollback;
	Messagebox("삭제실패", "자료에 대한 삭제에 실패하였읍니다.")
	w_mdi_frame.sle_msg.text = ""
	Return
End if

//제품수불 집계
UPDATE CIC0130
	SET IP_QTY = 0,
	    IP_AMT = 0,
		 WP_QTY = 0,
		 WP_AMT = 0
 WHERE WORKYM = :sWorkym;
  
If SQLCA.SQLCODE <> 0 Then 	  
	Rollback;
	Messagebox("삭제실패", "자료에 대한 삭제에 실패하였읍니다.")
	w_mdi_frame.sle_msg.text = ""
	Return
End If

Commit;

ib_any_typing = False
w_mdi_frame.sle_msg.text = "자료를 삭제하였습니다."
dw_2.Reset()
wf_button_chk('D', 0)


end event

event p_ins::ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\전체삭제_dn.gif"
end event

event p_ins::ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\전체삭제_up.gif"
end event

type p_exit from w_inherite`p_exit within w_cic01100
integer x = 4434
integer taborder = 70
end type

type p_can from w_inherite`p_can within w_cic01100
integer x = 4261
integer taborder = 60
end type

event p_can::clicked;call super::clicked;dw_1.Reset()
dw_1.InsertRow(0)

dw_1.SetItem(1, 'workym', f_aftermonth( Left(f_today(),6), -1))
dw_1.SetFocus()

dw_2.Reset()
wf_button_chk('C', 0)

ib_any_typing = False

end event

type p_print from w_inherite`p_print within w_cic01100
integer x = 5376
integer y = 184
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_cic01100
integer x = 3739
integer taborder = 30
end type

event p_inq::clicked;call super::clicked;String sWorkym, sImgbn
Long	 lRowcnt

If dw_1.Accepttext() = -1 Then Return

sWorkym = Trim(dw_1.GetItemString(dw_1.GetRow(), 'workym'))
If sWorkym = "" Or IsNull(sWorkym) Then
	f_messagechk(1, '[수불년월]')
	dw_1.SetColumn('workym')
	dw_1.SetFocus()
	Return
End If

sImgbn = Trim(dw_1.GetItemString(dw_1.GetRow(), 'imgbn'))
If sImgbn = "" Or IsNull(sImgbn) Then sImgbn = '%'

w_mdi_frame.sle_msg.Text = "조회 중입니다.!!!"
SetPointer(HourGlass!)
dw_2.SetRedraw(False)

lRowcnt = dw_2.Retrieve(sWorkym, sImgbn)
If lRowcnt <=0 Then
	f_messagechk(14, '')
	dw_1.SetFocus()
	dw_2.SetRedraw(True)
	w_mdi_frame.sle_msg.text = ""
	ib_any_typing = False
	wf_button_chk('Q', lRowcnt)
	SetPointer(Arrow!)
	Return
Else
	dw_2.SetColumn('wp_qty')
	dw_2.SetFocus()
End If

dw_2.SetRedraw(True)
w_mdi_frame.sle_msg.text = "조회가 완료되었습니다.!!!"
ib_any_typing = False
wf_button_chk('Q', lRowcnt)
SetPointer(Arrow!)
end event

type p_del from w_inherite`p_del within w_cic01100
integer x = 4855
integer y = 184
integer taborder = 0
end type

event p_del::clicked;call super::clicked;Integer k

IF dw_2.GetRow() <= 0 THEN
	f_messagechk(11,'')
	Return
END IF

IF dw_2.GetItemNumber(dw_2.GetRow(),"sum_gita") = 0 OR IsNull(dw_2.GetItemNumber(dw_2.GetRow(),"sum_gita")) THEN
	IF F_DbConFirm('삭제') = 2 THEN RETURN
ELSE
	IF MessageBox("확 인","선택하신 자료에 이월 이외의 자료(입고,출고,재고)가 존재합니다.~r"+&
								 "삭제하시겠습니까?",Question!,YesNo!,2) = 2 THEN Return
END IF

dw_2.DeleteRow(0)
IF dw_2.Update() = 1 THEN
	commit;
	
	FOR k = 1 TO dw_2.RowCount()
		dw_2.SetItem(k,'sflag','M')
	NEXT
	
	dw_2.SetColumn("iwol_qty")
	dw_2.SetFocus()
	
	ib_any_typing = False
	w_mdi_frame.sle_msg.text ="자료가 삭제되었습니다.!!!"
ELSE
	ROLLBACK;
	f_messagechk(12,'')
END IF

end event

type p_mod from w_inherite`p_mod within w_cic01100
integer x = 3913
integer taborder = 40
end type

event p_mod::clicked;call super::clicked;String sWorkym, sImgbn

If dw_1.Accepttext() = -1 Then Return

sWorkym   = Trim(dw_1.GetItemString(dw_1.GetRow(), 'workym'))
If sWorkym = "" Or IsNull(sWorkym) Then
	f_messagechk(1, '[수불년월]')
	dw_1.SetColumn('workym')
	dw_1.SetFocus()
	Return
End If

sImgbn = Trim(dw_1.GetItemString(dw_1.GetRow(), 'imgbn'))
If sImgbn = "" Or IsNull(sImgbn) Then
	sImgbn = '%'
Else
	sImgbn = sImgbn + '%'
End If	

Long lRowCnt
Long lRecCnt

If dw_2.AcceptText() = -1 Then Return
If dw_2.RowCount() <= 0 Then Return

If ib_any_typing = False Then
	MessageBox("알림", "변경된 자료가 없습니다.!!!")
	Return 
End If	

////품목별 경비배부표
//SELECT count(*)
//  INTO :lRecCnt
//  FROM CIC0310
// WHERE WORKYM = :sWorkym;
//
//If lRecCnt > 0 Then
//	Messagebox('알림', '원가계산 처리된 당월의 기말재고는 수정할 수 없습니다.')
//	Return 
//End If

If dw_2.Update() = 1 Then
	Commit;
	
   // 생산량집계  (제품수불 집계(CIC0130) (당월:당기출고+기말재고-기초재고 수량)
   // (당기입고)-> 제품수불 집계(CIC0130) (당월:당기입고 수량))
   //           -> 생산량내역(CIC0110) (당월:생산량))
   //           -> 생산량집계(CIC0117) (당월:생산량))
	If wf_procedure(sWorkym, sImgbn, 'CIC06011') = -1 Then
		Rollback;
		f_messagechk(13, '')
		Return
	End If
	
	For lRowCnt = 1 To dw_2.RowCount()
		dw_2.SetItem(lRowCnt, 'sflag', 'M')
	Next

	dw_2.SetColumn('wp_qty')
	dw_2.SetFocus()
	
	w_mdi_frame.sle_msg.text = "자료가 저장되었습니다.!!!"
	ib_any_typing = False
	wf_button_chk('S', 0)
Else
	Rollback;
	f_messagechk(13, '')
End If

end event

type cb_exit from w_inherite`cb_exit within w_cic01100
integer x = 3026
integer y = 2752
end type

type cb_mod from w_inherite`cb_mod within w_cic01100
integer x = 2199
integer y = 2752
end type

event cb_mod::clicked;call super::clicked;Integer k,iRtnValue

IF dw_2.AcceptText() = -1 THEN Return

IF dw_2.RowCount() > 0 THEN
	FOR k = 1 TO dw_2.RowCount()
		iRtnValue = Wf_RequiredChk(k)
		IF iRtnValue = -1 THEN RETURN
	NEXT
ELSE
	Return
END IF

IF f_dbConFirm('저장') = 2 THEN RETURN

IF dw_2.Update() = 1 THEN
	commit;
	
	FOR k = 1 TO dw_2.RowCount()
		dw_2.SetItem(k,'sflag','M')
	NEXT

	dw_2.SetColumn("iwol_qty")
	dw_2.SetFocus()
	
	ib_any_typing = False
	sle_msg.text ="자료가 저장되었습니다.!!!"
ELSE
	ROLLBACK;
	f_messagechk(13,'')
END IF

end event

type cb_ins from w_inherite`cb_ins within w_cic01100
integer x = 503
integer y = 2752
end type

event cb_ins::clicked;call super::clicked;Integer  iCurRow,iFunctionValue
String   sYm

sle_msg.text =""

IF dw_1.AcceptText() = -1 THEN RETURN
sYm = Trim(dw_1.GetItemString(1,"io_ym"))
IF sYm = "" OR IsNull(sYm) THEN
	F_MessageChk(1,'[원가계산년월]')
	dw_1.SetColumn("io_ym")
	dw_1.SetFocus()
	Return
END IF

IF dw_2.RowCount() > 0 THEN
	iFunctionValue = Wf_RequiredChk(dw_2.GetRow())
	IF iFunctionValue <> 1 THEN RETURN
ELSE
	iFunctionValue = 1	
END IF

IF iFunctionValue = 1 THEN
	iCurRow = dw_2.InsertRow(0)

	dw_2.ScrollToRow(iCurRow)
	dw_2.SetItem(iCurRow,'io_yymm',sYm)
	dw_2.SetItem(iCurRow,'sflag','I')
	dw_2.SetColumn("itnbr")
	dw_2.SetFocus()
	
	ib_any_typing =False

END IF

end event

type cb_del from w_inherite`cb_del within w_cic01100
integer x = 2551
integer y = 2752
end type

event cb_del::clicked;call super::clicked;Integer k

IF dw_2.GetRow() <= 0 THEN
	f_messagechk(11,'')
	Return
END IF

IF dw_2.GetItemNumber(dw_2.GetRow(),"sum_gita") = 0 OR IsNull(dw_2.GetItemNumber(dw_2.GetRow(),"sum_gita")) THEN
	IF F_DbConFirm('삭제') = 2 THEN RETURN
ELSE
	IF MessageBox("확 인","선택하신 자료에 이월 이외의 자료(입고,출고,재고)가 존재합니다.~r"+&
								 "삭제하시겠습니까?",Question!,YesNo!,2) = 2 THEN Return
END IF

dw_2.DeleteRow(0)
IF dw_2.Update() = 1 THEN
	commit;
	
	FOR k = 1 TO dw_2.RowCount()
		dw_2.SetItem(k,'sflag','M')
	NEXT
	
	dw_2.SetColumn("iwol_qty")
	dw_2.SetFocus()
	
	ib_any_typing = False
	sle_msg.text ="자료가 삭제되었습니다.!!!"
ELSE
	ROLLBACK;
	f_messagechk(12,'')
END IF

end event

type cb_inq from w_inherite`cb_inq within w_cic01100
integer x = 142
integer y = 2752
end type

event cb_inq::clicked;call super::clicked;String sYm

IF dw_1.Accepttext() = -1 THEN RETURN

sYm    = Trim(dw_1.GetItemString(dw_1.GetRow(),"io_ym"))
LsIttyp = dw_1.GetItemString(dw_1.GetRow(),"ittyp")

IF sYm = "" OR IsNull(sYm) THEN
	f_MessageChk(1,'[원가계산년월]')
	dw_1.SetColumn("io_ym")
	dw_1.SetFocus()
	Return
END IF

IF LsIttyp = "" OR IsNull(LsIttyp) THEN LsIttyp = '%'

sle_msg.Text = '조회 중...'
SetPointer(HourGlass!)
dw_2.SetRedraw(False)
IF dw_2.Retrieve(sYm,LsIttyp) <=0 THEN
	F_MESSAGECHK(14,"")
	dw_1.SetFocus()
	dw_2.SetRedraw(True)
	sle_msg.text = ''
	SetPointer(Arrow!)
	Return
ELSE
	dw_2.SetColumn("iwol_qty")
	dw_2.SetFocus()
END IF
dw_2.SetRedraw(True)

sle_msg.text = '조회 완료'
SetPointer(Arrow!)
end event

type cb_print from w_inherite`cb_print within w_cic01100
integer x = 1650
integer y = 2424
end type

type st_1 from w_inherite`st_1 within w_cic01100
integer width = 293
end type

type cb_can from w_inherite`cb_can within w_cic01100
integer x = 2907
integer y = 2752
end type

event cb_can::clicked;call super::clicked;String sIttyp,sIoYm

sle_msg.text =""
sIoYm  = Trim(dw_1.GetItemString(1,"io_ym"))
sIttyp = dw_1.GetItemString(1,"ittyp")
IF sIttyp = "" OR IsNull(sIttyp) THEN sIttyp = '%'

dw_2.SetRedraw(False)
IF dw_2.Retrieve(sIoYm,sIttyp) > 0 THEN
	dw_2.ScrollToRow(1)
	dw_2.SetColumn("iwol_qty")
	dw_2.SetFocus()
ELSE
	cb_ins.SetFocus()
END IF
dw_2.SetRedraw(True)

ib_any_typing =False


end event

type cb_search from w_inherite`cb_search within w_cic01100
integer x = 2053
integer y = 2432
end type

type dw_datetime from w_inherite`dw_datetime within w_cic01100
integer height = 88
end type

type sle_msg from w_inherite`sle_msg within w_cic01100
integer x = 329
integer width = 2533
end type

type gb_10 from w_inherite`gb_10 within w_cic01100
integer width = 3607
end type

type gb_button1 from w_inherite`gb_button1 within w_cic01100
integer x = 110
integer y = 2696
end type

type gb_button2 from w_inherite`gb_button2 within w_cic01100
integer x = 2153
integer y = 2696
end type

type dw_2 from datawindow within w_cic01100
event ue_key pbm_dwnkey
event ue_enterkey pbm_dwnprocessenter
integer x = 50
integer y = 200
integer width = 4549
integer height = 2040
integer taborder = 80
string title = "제품 수불장"
string dataobject = "dw_cic01100_30"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_key;If keydown(keyF1!) Then
	TriggerEvent(RbuttonDown!)
End If
end event

event ue_enterkey;Send(Handle(This),256,9,0)
Return 1
end event

event editchanged;ib_any_typing = True
end event

event itemchanged;w_mdi_frame.sle_msg.text = ""
ib_any_typing = True
end event

event retrieverow;If row > 0 Then
	This.SetItem(row, 'sflag', 'M')
End If
end event

event rowfocuschanged;//This.SetRowFocusIndicator(Hand!)
end event

event retrieveend;Long lRowCnt

For lRowCnt = 1 To rowcount
	This.SetItem(lRowCnt, 'sflag', 'M')
Next
end event

event itemerror;Return 1
end event

event getfocus;This.AcceptText()
end event

type gb_4 from groupbox within w_cic01100
boolean visible = false
integer y = 2948
integer width = 3598
integer height = 140
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 12632256
end type

type dw_1 from datawindow within w_cic01100
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 37
integer y = 20
integer width = 1696
integer height = 156
integer taborder = 10
string dataobject = "dw_cic01100_10"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(This),256,9,0)
Return 1
end event

event ue_key;If keydown(keyF1!) Then
	TriggerEvent(RbuttonDown!)
End If
end event

event itemchanged;String snull, sWorkym

SetNull(snull)
w_mdi_frame.sle_msg.text =""

Choose Case This.GetColumnName()
	Case 'workym'
		sWorkym = Trim(This.GetText())
		If sWorkym = "" Or IsNull(sWorkym) Then Return
		
		If f_datechk(sWorkym + '01') = -1 Then 
			f_messagechk(21, '[수불년월]')
			dw_1.SetItem(1, 'workym', snull)
			Return 1
		End If
	Case Else
End Choose

end event

event itemerror;Return 1

end event

event getfocus;This.AcceptText()
end event

type rr_1 from roundrectangle within w_cic01100
string tag = "내역"
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 188
integer width = 4576
integer height = 2064
integer cornerheight = 40
integer cornerwidth = 46
end type

