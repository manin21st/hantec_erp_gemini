$PBExportHeader$w_sm01_00032.srw
$PBExportComments$월 판매계획 확정
forward
global type w_sm01_00032 from w_standard_print
end type
type p_ins from picture within w_sm01_00032
end type
type p_search from picture within w_sm01_00032
end type
type p_mod from picture within w_sm01_00032
end type
type rr_2 from roundrectangle within w_sm01_00032
end type
type rr_1 from roundrectangle within w_sm01_00032
end type
end forward

global type w_sm01_00032 from w_standard_print
string title = "월 판매계획 확정"
p_ins p_ins
p_search p_search
p_mod p_mod
rr_2 rr_2
rr_1 rr_1
end type
global w_sm01_00032 w_sm01_00032

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();
return 1
end function

on w_sm01_00032.create
int iCurrent
call super::create
this.p_ins=create p_ins
this.p_search=create p_search
this.p_mod=create p_mod
this.rr_2=create rr_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_ins
this.Control[iCurrent+2]=this.p_search
this.Control[iCurrent+3]=this.p_mod
this.Control[iCurrent+4]=this.rr_2
this.Control[iCurrent+5]=this.rr_1
end on

on w_sm01_00032.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.p_ins)
destroy(this.p_search)
destroy(this.p_mod)
destroy(this.rr_2)
destroy(this.rr_1)
end on

event open;call super::open;f_mod_saupj(dw_ip, 'saupj')
end event

type p_preview from w_standard_print`p_preview within w_sm01_00032
boolean visible = false
integer y = 200
end type

type p_exit from w_standard_print`p_exit within w_sm01_00032
end type

type p_print from w_standard_print`p_print within w_sm01_00032
boolean enabled = true
string picturename = "C:\erpman\image\확정취소_up.gif"
end type

event p_print::clicked;String sYymm
Long	 nCnt
String sSaupj

If dw_ip.AcceptText() <> 1 Then Return

sYymm = dw_ip.GetItemString(1, 'yymm')
If IsNull(sYymm) Or sYymm = '' Then Return


/* 사업장 체크 */
sSaupj= Trim(dw_ip.GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_ip.SetFocus()
	dw_ip.SetColumn('saupj')
	Return -1
End If

SELECT COUNT(*) INTO :nCnt FROM PM01_MONPLAN_DTL WHERE SABU = :gs_sabu AND MONYYMM = :syymm AND JUCHA = 0;
If nCnt > 0 Then
	MessageBox('확인','이미 생산계획이 수립되어 있습니다.!!')
//	Return
End If

If  MessageBox("확정취소", '월 판매계획을 확정취소 처리 합니다', Exclamation!, OKCancel!, 2) = 2 Then Return

UPDATE LW_002
   SET MANAGEDATE = NULL,
	    WANDATE = NULL
 WHERE SAUPJ = :sSaupj AND YYMM = :syymm;
If SQLCA.SQLCODE <> 0 Then
	MessageBox(string(sqlca.sqlcode), sqlca.sqlerrtext)
	Rollback;
	Return
End If

COMMIT;

MessageBox('확인','정상적으로 취소처리되었습니다.!!')

p_search.PictureName = 'C:\erpman\image\확정_up.gif'
p_search.Enabled = True
p_print.PictureName = 'C:\erpman\image\확정취소_d.gif'
p_print.Enabled = False
p_ins.PictureName = 'C:\erpman\image\의뢰생성_up.gif'
p_ins.Enabled = True
end event

event p_print::ue_lbuttondown;PictureName = "C:\erpman\image\확정취소_dn.gif"
end event

event p_print::ue_lbuttonup;PictureName = "C:\erpman\image\확정취소_up.gif"
end event

type p_retrieve from w_standard_print`p_retrieve within w_sm01_00032
integer x = 3744
end type

event p_retrieve::clicked;String syymm, scust, stemp, sDate, eDate, sFilter, sCargbn1, sCargbn2, sItem, sCod, sMagam
String scvcod, tx_name
Long   nCnt, ix, nrow
String sSaupj, ssarea

If dw_ip.AcceptText() <> 1 Then Return -1
If dw_print.AcceptText() <> 1 Then Return -1

syymm = trim(dw_ip.getitemstring(1, 'yymm'))
scust = trim(dw_ip.getitemstring(1, 'cust'))
ssarea = trim(dw_ip.getitemstring(1, 'sarea'))
scvcod = trim(dw_ip.getitemstring(1, 'cvcod'))
sItem = trim(dw_ip.getitemstring(1, 'item'))
sCod = trim(dw_ip.getitemstring(1, 'scod'))

If IsNull(syymm) Or syymm = '' Then
	f_message_chk(1400,'[계획년월]')
	Return -1
End If
		
/* 사업장 체크 */
sSaupj= Trim(dw_ip.GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_ip.SetFocus()
	dw_ip.SetColumn('saupj')
	Return -1
End If

// 품목별 계획
If sItem = 'Z' Then
	dw_print.DataObject = 'd_sm01_00042_4_p'
	dw_list.DataObject  = 'd_sm01_00042_4'
Else
	If dw_ip.GetItemString(1, 'item') = 'N' And ( sCust = '2' Or sCust = '3' Or sCust = '4' Or sCust = '5' Or sCust = '6' Or sCust = '9' ) Then
		MessageBox('확인','차종별 계획을 조회하실 수 없습니다.!!')
		Return -1
//		dw_ip.SetItem(1, 'item', 'Y')
	End If
		
	// 차종별/업체별 계획
	If ( scust = '1' or scust = '3' or scust = '7' or scust = '8'  or scust = 'A' or scust = '%' ) And dw_ip.GetItemString(1, 'item') = 'N'  Then
		If IsNull(scust) Or scust = '%' Then
			f_message_chk(1400,'[고객구분]')
			Return -1
		End If
	
		dw_print.DataObject = 'd_sm01_00042_2_p'
		dw_list.DataObject = 'd_sm01_00042_2'
	Else
		If IsNull(scust) Or scust = '' Then sCust = ''
		
		dw_print.DataObject = 'd_sm01_00042_3_p'
		dw_list.DataObject = 'd_sm01_00042_3'
	End If
End If

dw_print.SetTransObject(sqlca)

Choose Case dw_print.DataObject
	// 품목별 계획인 경우
	Case 'd_sm01_00042_4_p'
		sCvcod = ''
		
		If dw_print.Retrieve(sSaupj, syymm, scust+'%', scvcod+'%', sCod +'%') <= 0 Then
			f_message_chk(50,'')
		End If
	// 업체별 계획인 경우
	Case 'd_sm01_00042_3_p'
		If IsNull(scvcod) Then scvcod = ''
		If IsNull(ssarea) Then ssarea = ''
		
		If dw_print.Retrieve(sSaupj, syymm, ssarea+'%', scvcod+'%') <= 0 Then
			f_message_chk(50,'')
		End If
		
		tx_name = Trim(dw_ip.GetItemString(1, 'cvnas'))
		If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
		dw_print.Modify("tx_cvcod.text = '"+tx_name+"'")
		
	// 차종/기종별 계획인 경우
	Case Else	
		sCargbn1 = dw_ip.GetItemString(1, 'cargbn1')
		sCargbn2 = dw_ip.GetItemString(1, 'cargbn2')
		
		// CKD는 2004.02월을 기준으로 현대로 통합관리함
		If syymm <= '200402' And sCargbn1 = 'C' Then	sCargbn1 = 'E'
		
		If dw_print.Retrieve(sSaupj, syymm, sCargbn1, sCargbn2, sCust) <= 0 Then
			f_message_chk(50,'')
		End If
		
		If sCargbn1 = 'E' Or sCargbn1 = 'C' Then
			If sCargbn2 = 'E' Then
				dw_print.Object.tx_1.text = '엔진명'
				dw_print.Object.tx_2.text = '엔진형식'
				dw_print.Object.tx_3.text = ''
				dw_print.Object.tx_4.text = ''
				
				dw_list.Object.tx_1.text = '엔진명'
				dw_list.Object.tx_2.text = '엔진형식'
				dw_list.Object.tx_3.text = ''
				dw_list.Object.tx_4.text = ''
			End If
			If sCargbn2 = 'T' Then
				dw_print.Object.tx_1.text = '엔진명'
				dw_print.Object.tx_2.text = '엔진형식'
				dw_print.Object.tx_3.text = '계열'
				dw_print.Object.tx_4.text = '기종'
				
				dw_list.Object.tx_1.text = '엔진명'
				dw_list.Object.tx_2.text = '엔진형식'
				dw_list.Object.tx_3.text = '계열'
				dw_list.Object.tx_4.text = '기종'
			End If
			If sCargbn2 = 'D' Then
				dw_print.Object.tx_1.text = '구분'
				dw_print.Object.tx_2.text = '형식'
				dw_print.Object.tx_3.text = 'ABS'
				dw_print.Object.tx_4.text = ''
				
				dw_list.Object.tx_1.text = '구분'
				dw_list.Object.tx_2.text = '형식'
				dw_list.Object.tx_3.text = 'ABS'
				dw_list.Object.tx_4.text = ''
			End If
		Else
			dw_print.Object.tx_1.text = ''
			dw_print.Object.tx_2.text = ''
			dw_print.Object.tx_3.text = ''
			dw_print.Object.tx_4.text = ''
			dw_list.Object.tx_1.text = ''
			dw_list.Object.tx_2.text = ''
			dw_list.Object.tx_3.text = ''
			dw_list.Object.tx_4.text = ''
		End If
		
		tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(cargbn2) ', 1)"))
		If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
		dw_print.Modify("tx_cargbn2.text = '"+tx_name+"'")
End Choose

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(cust) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_cust.text = '"+tx_name+"'")

dw_print.ShareData(dw_list)

/* 월 셋팅 */
dw_print.object.t_mm.text = String(syymm,'@@@@.@@')+'월'
dw_print.object.t_mm1.text = Right(f_aftermonth(syymm,1),2)+'월'
dw_print.object.t_mm2.text = Right(f_aftermonth(syymm,2),2)+'월'
dw_list.object.t_mm.text = String(syymm,'@@@@.@@')+'월'
dw_list.object.t_mm1.text = Right(f_aftermonth(syymm,1),2)+'월'
dw_list.object.t_mm2.text = Right(f_aftermonth(syymm,2),2)+'월'

return 1
end event







type st_10 from w_standard_print`st_10 within w_sm01_00032
end type



type dw_print from w_standard_print`dw_print within w_sm01_00032
integer x = 3598
string dataobject = "d_sm01_00042_3_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sm01_00032
integer x = 64
integer y = 60
integer width = 3648
integer height = 200
string dataobject = "d_sm01_00042_1"
end type

event dw_ip::itemchanged;String s_cvcod, snull, get_nm, sItem, sCust, syymm, sMagam
Long   nCnt
String sSaupj

/* 사업장 체크 */
sSaupj= Trim(dw_ip.GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_ip.SetFocus()
	dw_ip.SetColumn('saupj')
	Return -1
End If

SetNull(sNull)

Choose Case GetColumnName()
	Case 'yymm'
		sYymm = Trim(GetText())
		
		SELECT COUNT(*), MAX(MANAGEDATE) INTO :nCnt, :sMagam FROM LW_002 WHERE SAUPJ = :sSaupj AND YYMM = :syymm;
		
		If NOT IsNull(smagam) Then
			MessageBox('확 인','이미 확정처리 되어있습니다.')
			p_search.PictureName = 'C:\erpman\image\확정_d.gif'
			p_search.Enabled = False
			p_print.PictureName = 'C:\erpman\image\확정취소_up.gif'
			p_print.Enabled = True
			p_ins.PictureName = 'C:\erpman\image\의뢰생성_d.gif'
			p_ins.Enabled = False
		Else
			p_search.PictureName = 'C:\erpman\image\확정_up.gif'
			p_search.Enabled = True
			p_print.PictureName = 'C:\erpman\image\확정취소_d.gif'
			p_print.Enabled = False
			p_ins.PictureName = 'C:\erpman\image\의뢰생성_up.gif'
			p_ins.Enabled = True
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

dw_list.Reset()
dw_print.Reset()
end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

event dw_ip::rbuttondown;call super::rbuttondown;long lrow

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

type dw_list from w_standard_print`dw_list within w_sm01_00032
integer x = 32
integer y = 292
string dataobject = "d_sm01_00042_2"
boolean border = false
end type

event dw_list::clicked;call super::clicked;If Row <= 0 then
	SelectRow(0,False)
ELSE
	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
END IF
end event

type p_ins from picture within w_sm01_00032
event ue_buttondown pbm_lbuttondown
event ue_buttonup pbm_lbuttonup
integer x = 3922
integer y = 24
integer width = 178
integer height = 144
boolean bringtotop = true
string picturename = "C:\erpman\image\의뢰생성_up.gif"
boolean focusrectangle = false
end type

event ue_buttondown;PictureName = "C:\erpman\image\의뢰생성_dn.gif"
end event

event ue_buttonup;PictureName = "C:\erpman\image\의뢰생성_up.gif"
end event

event clicked;String syymm
Int	 lRtnValue
String sSaupj

If dw_ip.AcceptText() <> 1 Then Return

sYymm = Trim(dw_ip.GetItemString(1, 'yymm'))
If IsNull(sYymm) Or sYymm = '' Then
	f_message_chk(1400,'')
	Return
End If

/* 사업장 체크 */
sSaupj= Trim(dw_ip.GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_ip.SetFocus()
	dw_ip.SetColumn('saupj')
	Return -1
End If

// 마감내역 작성-완제품 재고 반영
lRtnValue = SQLCA.SM01_PLAN_MAGAM(sSaupj, syymm, '1')
IF lRtnValue < 0 THEN
	ROLLBACK;
	f_message_chk(41,'')
	sle_msg.text = string(lRtnValue) 
	Return
ELSE
	commit ;
	MessageBox('확 인','의뢰내역이 생성되었습니다.!!')
	sle_msg.text = string(lRtnValue) + '건에 자료가 생성처리 되었습니다!!'
END IF
end event

type p_search from picture within w_sm01_00032
event ue_buttondown pbm_lbuttondown
event ue_buttonup pbm_lbuttonup
integer x = 4096
integer y = 24
integer width = 178
integer height = 144
boolean bringtotop = true
string picturename = "C:\erpman\image\확정_up.gif"
boolean focusrectangle = false
end type

event ue_buttondown;PictureName = "C:\erpman\image\확정_dn.gif"
end event

event ue_buttonup;PictureName = "C:\erpman\image\확정_up.gif"
end event

event clicked;String syymm
Int	 lRtnValue
String sSaupj

If dw_ip.AcceptText() <> 1 Then Return

sYymm = Trim(dw_ip.GetItemString(1, 'yymm'))
If IsNull(sYymm) Or sYymm = '' Then
	f_message_chk(1400,'')
	Return
End If

/* 사업장 체크 */
sSaupj= Trim(dw_ip.GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_ip.SetFocus()
	dw_ip.SetColumn('saupj')
	Return -1
End If

If  MessageBox("확정처리", '월 판매계획을 확정처리 합니다', Exclamation!, OKCancel!, 1) = 2 Then Return

UPDATE LW_002
   SET MANAGEDATE = TO_CHAR(SYSDATE,'YYYYMMDD'),
		 WANDATE = TO_CHAR(SYSDATE,'YYYYMMDD')
 WHERE SAUPJ = :sSaupj AND YYMM = :syymm;
If SQLCA.SQLCODE <> 0 Then
	MessageBox(string(sqlca.sqlcode), sqlca.sqlerrtext)
	Rollback;
	Return
End If

COMMIT;

// 마감내역 작성-완제품 재고 반영
lRtnValue = SQLCA.SM01_PLAN_MAGAM(sSaupj, syymm, '1')
IF lRtnValue < 0 THEN
	ROLLBACK;
	f_message_chk(41,'')
	sle_msg.text = string(lRtnValue) 
	Return
ELSE
	commit ;
	sle_msg.text = string(lRtnValue) + '건에 자료가 생성처리 되었습니다!!'
END IF

MessageBox('확인','정상적으로 확정 처리되었습니다.!!')

p_search.PictureName = 'C:\erpman\image\확정_d.gif'
p_search.Enabled = False
p_print.PictureName = 'C:\erpman\image\확정취소_up.gif'
p_print.Enabled = True
p_ins.PictureName = 'C:\erpman\image\의뢰생성_d.gif'
p_ins.Enabled = False
			
// E-Mail 전송
//p_mod.TriggerEvent(Clicked!)

//p_can.TriggerEvent(Clicked!)


end event

type p_mod from picture within w_sm01_00032
event ue_buttondown pbm_lbuttondown
event ue_buttonup pbm_lbuttonup
boolean visible = false
integer x = 3909
integer y = 196
integer width = 178
integer height = 144
boolean bringtotop = true
string picturename = "C:\erpman\image\메일전송_up.gif"
boolean focusrectangle = false
end type

event ue_buttondown;PictureName = "C:\erpman\image\메일전송_dn.gif"
end event

event ue_buttonup;PictureName = "C:\erpman\image\메일전송_up.gif"
end event

event clicked;String ls_window_id , ls_window_nm, syymm
Double   ll_sp = 0

ls_window_id = 'w_sm01_00032'
ls_window_nm = '월 마감'

syymm = dw_ip.GetItemString(1, 'yymm')
If syymm = '' or isNull(syymm) Then
	messagebox('','계획년월을 입력하세요.')
	return
End If

gs_code = '월 판매계획 마감'
gs_codename = String(sYymm,'@@@@년 @@월 ') + '판매계획을 마감했습니다.'
OpenWithParm(w_mail_insert , ls_window_id + Space(100) + ls_window_nm)
end event

type rr_2 from roundrectangle within w_sm01_00032
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 59
integer y = 44
integer width = 3662
integer height = 232
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within w_sm01_00032
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 288
integer width = 4613
integer height = 1980
integer cornerheight = 40
integer cornerwidth = 55
end type

