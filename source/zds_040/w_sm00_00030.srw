$PBExportHeader$w_sm00_00030.srw
$PBExportComments$년 판매계획 확정
forward
global type w_sm00_00030 from w_inherite
end type
type dw_ip from u_key_enter within w_sm00_00030
end type
type rr_2 from roundrectangle within w_sm00_00030
end type
type rr_1 from roundrectangle within w_sm00_00030
end type
end forward

global type w_sm00_00030 from w_inherite
string title = "년 판매계획 확정"
dw_ip dw_ip
rr_2 rr_2
rr_1 rr_1
end type
global w_sm00_00030 w_sm00_00030

on w_sm00_00030.create
int iCurrent
call super::create
this.dw_ip=create dw_ip
this.rr_2=create rr_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_ip
this.Control[iCurrent+2]=this.rr_2
this.Control[iCurrent+3]=this.rr_1
end on

on w_sm00_00030.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_ip)
destroy(this.rr_2)
destroy(this.rr_1)
end on

event open;call super::open;String sDate, sMagam
Long   nCnt

dw_ip.SetTransObject(sqlca)
dw_ip.InsertRow(0)

dw_insert.SetTransObject(sqlca)

//SELECT MAX(YYYY) INTO :sDate FROM SM01_YEARPLAN;

//dw_ip.SetItem(1, 'yymm', sDate)

f_mod_saupj(dw_ip, 'saupj')
end event

type dw_insert from w_inherite`dw_insert within w_sm00_00030
integer x = 73
integer y = 360
integer width = 4453
integer height = 1900
string dataobject = "d_sm00_00040_4"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

type p_delrow from w_inherite`p_delrow within w_sm00_00030
boolean visible = false
integer x = 1129
integer y = 68
integer width = 306
boolean originalsize = true
string picturename = "C:\erpman\image\마감취소_up.gif"
end type

event p_delrow::clicked;call super::clicked;String sYymm

If dw_insert.AcceptText() <> 1 Then Return

sYymm = dw_insert.GetItemString(1, 'yymm')
If IsNull(sYymm) Or sYymm = '' Then Return

If  MessageBox("마감", '월 판매계획을 마감취소 처리 합니다', Exclamation!, OKCancel!, 2) = 2 Then Return

UPDATE LW_002
   SET WANDATE = NULL
 WHERE YYMM = :syymm;
If SQLCA.SQLCODE <> 0 Then
	MessageBox(string(sqlca.sqlcode), sqlca.sqlerrtext)
	Rollback;
	Return
End If

COMMIT;

MessageBox('확인','정상적으로 취소처리되었습니다.!!')

ib_any_typing = FALSE
end event

type p_addrow from w_inherite`p_addrow within w_sm00_00030
boolean visible = false
integer x = 2894
integer y = 36
integer width = 306
boolean originalsize = true
string picturename = "C:\erpman\image\마감처리_up.gif"
end type

event p_addrow::clicked;call super::clicked;String sYymm
Long   nCnt

If dw_ip.AcceptText() <> 1 Then Return

sYymm = dw_ip.GetItemString(1, 'yymm')
If IsNull(sYymm) Or sYymm = '' Then Return

SELECT COUNT(*) INTO :nCnt FROM LW_002 WHERE YYMM = :sYymm AND MANAGEDATE IS NOT NULL;

If nCnt <= 0 Then
	MessageBox('확 인','승인처리 되지 않았거나 계획자료가 존재하지 않습니다.!!')
	Return
End If

If  MessageBox("마감", '월 판매계획을 마감처리 합니다', Exclamation!, OKCancel!, 1) = 2 Then Return


UPDATE LW_002
   SET WANDATE = TO_CHAR(SYSDATE,'YYYYMMDD')
 WHERE YYMM = :syymm;
If SQLCA.SQLCODE <> 0 Then
	MessageBox(string(sqlca.sqlcode), sqlca.sqlerrtext)
	Rollback;
	Return
End If

COMMIT;

MessageBox('확인','정상적으로 마감 처리되었습니다.!!')

ib_any_typing = FALSE
end event

type p_search from w_inherite`p_search within w_sm00_00030
integer x = 3922
string picturename = "C:\erpman\image\확정_up.gif"
end type

event p_search::clicked;String syymm
Int	 lRtnValue, nChasu
String sSaupj

If dw_ip.AcceptText() <> 1 Then Return

sYymm = Trim(dw_ip.GetItemString(1, 'yymm'))
If IsNull(sYymm) Or sYymm = '' Then
	f_message_chk(1400,'')
	Return
End If

nChasu = dw_ip.GetItemNumber(1, 'chasu')
If IsNull(nChasu) Or nChasu <= 0 Then
	f_message_chk(1400,'[계획차수]')
	Return
End If

/* 사업장 체크 */
sSaupj= Trim(dw_ip.GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_ip.SetFocus()
	dw_ip.SetColumn('saupj')
	Return
End If

If  MessageBox("확정처리", '년 판매계획을 확정처리 합니다', Exclamation!, OKCancel!, 1) = 2 Then Return

// 단가는 TRIGGER에서 일괄변경 처리한다 

UPDATE SM01_YEARPLAN
   SET CNFIRM = TO_CHAR(SYSDATE,'YYYYMMDD')
 WHERE SABU = :gs_sabu AND YYYY = :syymm AND SAUPJ = :sSaupj AND CHASU = :nChasu;
If SQLCA.SQLCODE <> 0 Then
	MessageBox(string(sqlca.sqlcode), sqlca.sqlerrtext)
	Rollback;
	Return
End If

COMMIT;

MessageBox('확인','정상적으로 확정 처리되었습니다.!!')

// E-Mail 전송
p_mod.TriggerEvent(Clicked!)

p_can.TriggerEvent(Clicked!)
ib_any_typing = FALSE

end event

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\확정_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\확정_up.gif"
end event

type p_ins from w_inherite`p_ins within w_sm00_00030
boolean visible = false
integer x = 2606
integer y = 60
boolean enabled = false
string picturename = "C:\erpman\image\의뢰생성_up.gif"
end type

event p_ins::ue_lbuttondown;PictureName = "C:\erpman\image\의뢰생성_dn.gif"
end event

event p_ins::ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\의뢰생성_up.gif"
end event

type p_exit from w_inherite`p_exit within w_sm00_00030
end type

type p_can from w_inherite`p_can within w_sm00_00030
end type

event p_can::clicked;call super::clicked;String sNull

SetNull(sNull)

dw_ip.SetItem(1, 'yymm', sNull)
dw_insert.Reset()
end event

type p_print from w_inherite`p_print within w_sm00_00030
integer x = 4096
string picturename = "C:\erpman\image\확정취소_up.gif"
end type

event p_print::clicked;String sYymm
Long	 nCnt, nChasu
String sSaupj

If dw_ip.AcceptText() <> 1 Then Return

sYymm = dw_ip.GetItemString(1, 'yymm')
If IsNull(sYymm) Or sYymm = '' Then Return

nChasu = dw_ip.GetItemNumber(1, 'chasu')
If IsNull(nChasu) Or nChasu <= 0 Then
	f_message_chk(1400,'[계획차수]')
	Return
End If

/* 사업장 체크 */
sSaupj= Trim(dw_ip.GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_ip.SetFocus()
	dw_ip.SetColumn('saupj')
	Return
End If

//SELECT COUNT(*) INTO :nCnt FROM PM01_MONPLAN_DTL WHERE SABU = :gs_sabu AND MONYYMM = :syymm;
//If nCnt > 0 Then
//	MessageBox('확인','이미 생산계획이 수립되어 있습니다.!!')
//	Return
//End If

If  MessageBox("확정취소", '년 판매계획을 확정취소 처리 합니다', Exclamation!, OKCancel!, 2) = 2 Then Return

UPDATE SM01_YEARPLAN
   SET CNFIRM = NULL
 WHERE SABU = :gs_sabu AND YYYY = :syymm AND SAUPJ = :ssaupj AND CHASU = :nChasu;
 
If SQLCA.SQLCODE <> 0 Then
	MessageBox(string(sqlca.sqlcode), sqlca.sqlerrtext)
	Rollback;
	Return
End If

COMMIT;

MessageBox('확인','정상적으로 취소처리되었습니다.!!')

ib_any_typing = FALSE

p_can.TriggerEvent(Clicked!)
end event

event p_print::ue_lbuttonup;PictureName = "C:\erpman\image\확정취소_up.gif"
end event

event p_print::ue_lbuttondown;PictureName = "C:\erpman\image\확정취소_dn.gif"
end event

type p_inq from w_inherite`p_inq within w_sm00_00030
integer x = 3566
integer y = 28
end type

event p_inq::clicked;String sYear, scust, stemp, sDate, eDate, sFilter, sCargbn1, sCargbn2, sMagam
String scvcod, tx_name, sCod
Long   nCnt, ix, nrow, nChasu
String sSaupj, sSarea

If dw_ip.AcceptText() <> 1 Then Return -1

sYear = trim(dw_ip.getitemstring(1, 'yymm'))
scust = trim(dw_ip.getitemstring(1, 'cust'))
scvcod = trim(dw_ip.getitemstring(1, 'cvcod'))
sCod = trim(dw_ip.getitemstring(1, 'scod'))
sSarea = trim(dw_ip.getitemstring(1, 'sarea'))

If IsNull(sYear) Or sYear = '' Then
	f_message_chk(1400,'[계획년도]')
	Return -1
End If

nChasu = dw_ip.GetItemNumber(1, 'chasu')
If IsNull(nChasu) Or nChasu <= 0 Then
	f_message_chk(1400,'[계획차수]')
	Return
End If

/* 사업장 체크 */
sSaupj= Trim(dw_ip.GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_ip.SetFocus()
	dw_ip.SetColumn('saupj')
	Return
End If

// 품목별 계획
If  dw_ip.GetItemString(1, 'item') = 'Z' Then
	dw_insert.DataObject  = 'd_sm00_00040_4'
Else
	If dw_ip.GetItemString(1, 'item') = 'N' And ( sCust = '2' Or sCust = '3' Or sCust = '4' Or sCust = '5' Or sCust = '6' Or sCust = '9' ) Then
		MessageBox('확인','차종별 계획을 조회하실 수 없습니다.!!')
		Return -1
//		dw_ip.SetItem(1, 'item', 'Y')
	End If
	
	// 차종
	If ( scust = '1' or scust = '3' or scust = '7' or scust = '8'  or scust = 'A') And dw_ip.GetItemString(1, 'item') = 'N'  Then
		If IsNull(scust) Or scust = '' Then
			f_message_chk(1400,'[고객구분]')
			Return -1
		End If
	
		dw_insert.DataObject = 'd_sm00_00040_2'
	Else
		If IsNull(scust) Or scust = '' Then sCust = ''
		
		dw_insert.DataObject = 'd_sm00_00040_3'
	End If
End If

dw_insert.SetTransObject(sqlca)

Choose Case dw_insert.DataObject
	// 품목별 계획인 경우
	Case 'd_sm00_00040_4'
		sCvcod = ''
		If IsNull(scust) Or scust = '' Then sCust = ''
		If dw_insert.Retrieve(gs_sabu, sYear, scust+'%', sCod +'%',  sSaupj, nChasu) <= 0 Then
			f_message_chk(50,'')
		End If
	// 업체별 계획인 경우
	Case 'd_sm00_00040_3'
		If IsNull(scvcod) Then scvcod = ''
		If IsNull(ssarea) Then ssarea = ''
		
		If dw_insert.Retrieve(gs_sabu, sYear, ssarea+'%', scvcod+'%', sSaupj, nChasu) <= 0 Then
			f_message_chk(50,'')
		End If		
	// 차종/기종별 계획인 경우
	Case Else	
		sCargbn1 = dw_ip.GetItemString(1, 'cargbn1')
		sCargbn2 = dw_ip.GetItemString(1, 'cargbn2')
				
		If dw_insert.Retrieve(sSaupj, sYear, sCargbn1, sCargbn2, sCust, nChasu) <= 0 Then
			f_message_chk(50,'')
		End If
		
		If sCargbn1 = 'E' Or sCargbn1 = 'C' Then
			If sCargbn2 = 'E' Then
				dw_insert.Object.tx_1.text = '엔진명'
				dw_insert.Object.tx_2.text = '엔진형식'
				dw_insert.Object.tx_3.text = ''
				dw_insert.Object.tx_4.text = ''
			End If
			If sCargbn2 = 'T' Or sCargbn2 = 'M' Then
				dw_insert.Object.tx_1.text = '엔진명'
				dw_insert.Object.tx_2.text = '엔진형식'
				dw_insert.Object.tx_3.text = '계열'
				dw_insert.Object.tx_4.text = '기종'
			End If
			If sCargbn2 = 'D' Then
				dw_insert.Object.tx_1.text = '구분'
				dw_insert.Object.tx_2.text = '형식'
				dw_insert.Object.tx_3.text = 'ABS'
				dw_insert.Object.tx_4.text = ''
			End If
		Else
			dw_insert.Object.tx_1.text = ''
			dw_insert.Object.tx_2.text = ''
			dw_insert.Object.tx_3.text = ''
			dw_insert.Object.tx_4.text = ''
		End If
End Choose

If dw_insert.Rowcount() > 0 Then
	
	SELECT COUNT(*), MAX(CNFIRM) INTO :nCnt, :sMagam 
	  FROM SM01_YEARPLAN 
	 WHERE SABU = :gs_sabu AND YYYY = :syear AND SAUPJ = :sSaupj AND CHASU = :nChasu;
	
	If NOT IsNull(smagam) Then
		MessageBox('확 인','이미 확정처리 되어있습니다.')
		p_search.PictureName = 'C:\erpman\image\확정_d.gif'
		p_search.Enabled = False
		p_print.PictureName = 'C:\erpman\image\확정취소_up.gif'
		p_print.Enabled = True
		p_ins.PictureName = 'C:\erpman\image\의뢰생성_d.gif'
		p_ins.Enabled = False
		Return
	Else
		p_search.PictureName = 'C:\erpman\image\확정_up.gif'
		p_search.Enabled = True
		p_print.PictureName = 'C:\erpman\image\확정취소_d.gif'
		p_print.Enabled = False
		p_ins.PictureName = 'C:\erpman\image\의뢰생성_up.gif'
		p_ins.Enabled = True
		Return				
	End If
Else
	MessageBox('확 인','조회된 자료가 없습니다.')
End If

end event

type p_del from w_inherite`p_del within w_sm00_00030
boolean visible = false
integer x = 2395
integer y = 44
boolean enabled = false
end type

type p_mod from w_inherite`p_mod within w_sm00_00030
integer x = 3744
string picturename = "C:\erpman\image\메일전송_up.gif"
end type

event p_mod::clicked;call super::clicked;String ls_window_id , ls_window_nm, syymm
Double   ll_sp = 0

ls_window_id = 'w_sm00_00030'
ls_window_nm = '년 판매계획 마감'

syymm = dw_ip.GetItemString(1, 'yymm')
If syymm = '' or isNull(syymm) Then
	messagebox('','계획년도를 입력하세요.')
	return
End If

gs_code = '년 판매계획 마감'
gs_codename = String(sYymm,'@@@@년 ') + '판매계획을 마감했습니다.'
//OpenWithParm(w_mailsend_popup , ls_window_id + Space(100) + ls_window_nm)
OpenWithParm(w_mail_insert , ls_window_id + Space(100) + ls_window_nm)
end event

event p_mod::ue_lbuttondown;PictureName = "C:\erpman\image\메일전송_dn.gif"
end event

event p_mod::ue_lbuttonup;PictureName = "C:\erpman\image\메일전송_up.gif"
end event

type cb_exit from w_inherite`cb_exit within w_sm00_00030
end type

type cb_mod from w_inherite`cb_mod within w_sm00_00030
end type

type cb_ins from w_inherite`cb_ins within w_sm00_00030
end type

type cb_del from w_inherite`cb_del within w_sm00_00030
end type

type cb_inq from w_inherite`cb_inq within w_sm00_00030
end type

type cb_print from w_inherite`cb_print within w_sm00_00030
end type

type st_1 from w_inherite`st_1 within w_sm00_00030
end type

type cb_can from w_inherite`cb_can within w_sm00_00030
end type

type cb_search from w_inherite`cb_search within w_sm00_00030
end type







type gb_button1 from w_inherite`gb_button1 within w_sm00_00030
end type

type gb_button2 from w_inherite`gb_button2 within w_sm00_00030
end type

type dw_ip from u_key_enter within w_sm00_00030
integer x = 73
integer y = 44
integer width = 3465
integer height = 276
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_sm00_00030_1"
boolean border = false
end type

event itemchanged;String s_cvcod, snull, get_nm, sItem, sCust, sDate, sSaupj
Int    nChasu

SetNull(sNull)

/* 사업장 체크 */
sSaupj= Trim(GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	Return 2
End If

Choose Case GetColumnName()
	/* 계획년도 */
	Case 'yymm'
		sDate = Left(GetText(),6)
				
		If f_datechk(sDate+'0101') <> 1 Then
			f_message_chk(35,'')
			return 1
		Else
			dw_insert.Reset()
			
			// 해당년도의 최종차수 계산
			SELECT MAX(CHASU) INTO :nChasu FROM SM01_YEARPLAN 
			 WHERE SABU = :gs_sabu 
			   AND SAUPJ = :sSaupj 
				AND YYYY = :sDate;
			If IsNull(nChasu) Then nChasu = 1
			SetItem(1, 'chasu', nChasu)
		End If
	Case 'cvcod'
		s_cvcod = this.GetText()								
		 
		if s_cvcod = "" or isnull(s_cvcod) then 
			this.setitem(1, 'cvnas', snull)
			return 
		end if
		
		SELECT "VNDMST"."CVNAS"  
		  INTO :get_nm  
		  FROM "VNDMST"  
		 WHERE "VNDMST"."CVCOD" = :s_cvcod  ;
	
		if sqlca.sqlcode = 0 then 
			this.setitem(1, 'cvnas', get_nm)
		else
			this.triggerevent(RbuttonDown!)
			return 1
		end if
	Case 'cust'
		// 차종
		If GetText() = '1' Then
			SetItem(1, 'cargbn1', 'E')
			SetItem(1, 'cargbn2', 'E')
		// 기종
		ElseIf GetText() = '2' Then
			SetItem(1, 'cargbn1', '0')
			SetItem(1, 'cargbn2', '9')
		// 기종
		ElseIf GetText() = '3' Then
			SetItem(1, 'cargbn1', '1')
			SetItem(1, 'cargbn2', '9')
		// 기아
		ElseIf GetText() = '7' Then
			SetItem(1, 'cargbn1', 'E')
			SetItem(1, 'cargbn2', 'E')
		// CKD
		ElseIf GetText() = '8' Then
			SetItem(1, 'cargbn1', 'C')
			SetItem(1, 'cargbn2', 'E')
		// 파워텍
		ElseIf GetText() = 'A' Then
			SetItem(1, 'cargbn1', 'E')
			SetItem(1, 'cargbn2', 'T')
		// 기타(품목별)
		Else
			SetItem(1, 'cargbn1', '9')
			SetItem(1, 'cargbn2', '9')
		End If
	Case 'item'
		sItem = GetText()
End Choose
end event

event rbuttondown;call super::rbuttondown;long lrow

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

lrow = this.GetRow()
Choose Case GetcolumnName() 
	Case 'cvcod'
		gs_code = GetText()
		Open(w_vndmst_popup)
		If IsNull(gs_code) Or gs_code = '' Then Return
		
		SetItem(lrow, "cvcod", gs_Code)
		SetItem(lrow, "cvnas", gs_Codename)
End Choose
end event

type rr_2 from roundrectangle within w_sm00_00030
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 59
integer y = 40
integer width = 3497
integer height = 296
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within w_sm00_00030
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 352
integer width = 4471
integer height = 1916
integer cornerheight = 40
integer cornerwidth = 55
end type

