$PBExportHeader$w_sm01_00060.srw
$PBExportComments$폐기-월 판매계획 승인등록
forward
global type w_sm01_00060 from w_inherite
end type
type dw_ip from u_key_enter within w_sm01_00060
end type
type rr_2 from roundrectangle within w_sm01_00060
end type
type rr_1 from roundrectangle within w_sm01_00060
end type
end forward

global type w_sm01_00060 from w_inherite
string title = "월 판매계획 확정"
dw_ip dw_ip
rr_2 rr_2
rr_1 rr_1
end type
global w_sm01_00060 w_sm01_00060

on w_sm01_00060.create
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

on w_sm01_00060.destroy
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

SELECT MAX(YYMM) INTO :sDate FROM LW_002 WHERE SAUPJ = :gs_saupj;

dw_ip.SetItem(1, 'yymm', sDate)

If dw_insert.Retrieve(gs_saupj, sdate,'%') > 0 Then
	
	SELECT COUNT(*), MAX(MANAGEDATE) INTO :nCnt, :sMagam FROM LW_002 WHERE YYMM = :sDate;
	
	If NOT IsNull(smagam) Then
		p_search.PictureName = 'C:\erpman\image\확정_d.gif'
		p_search.Enabled = False
		p_print.PictureName = 'C:\erpman\image\확정취소_up.gif'
		p_print.Enabled = True
		Return
	Else
		p_search.PictureName = 'C:\erpman\image\확정_up.gif'
		p_search.Enabled = True
		p_print.PictureName = 'C:\erpman\image\확정취소_d.gif'
		p_print.Enabled = False
		Return				
	End If
End If
end event

type dw_insert from w_inherite`dw_insert within w_sm01_00060
integer x = 73
integer y = 256
integer width = 4453
integer height = 2004
string dataobject = "d_sm01_00060_2"
boolean vscrollbar = true
boolean border = false
end type

type p_delrow from w_inherite`p_delrow within w_sm01_00060
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

type p_addrow from w_inherite`p_addrow within w_sm01_00060
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

type p_search from w_inherite`p_search within w_sm01_00060
integer x = 3922
string picturename = "C:\erpman\image\확정_up.gif"
end type

event p_search::clicked;String syymm
Int	 lRtnValue

If dw_ip.AcceptText() <> 1 Then Return

sYymm = Trim(dw_ip.GetItemString(1, 'yymm'))
If IsNull(sYymm) Or sYymm = '' Then
	f_message_chk(1400,'')
	Return
End If

If  MessageBox("확정처리", '월 판매계획을 확정처리 합니다', Exclamation!, OKCancel!, 1) = 2 Then Return

UPDATE LW_002
   SET MANAGEDATE = TO_CHAR(SYSDATE,'YYYYMMDD'),
		 WANDATE = TO_CHAR(SYSDATE,'YYYYMMDD')
 WHERE SAUPJ = :gs_saupj AND YYMM = :syymm;
If SQLCA.SQLCODE <> 0 Then
	MessageBox(string(sqlca.sqlcode), sqlca.sqlerrtext)
	Rollback;
	Return
End If

COMMIT;

// 마감내역 작성-완제품 재고 반영
lRtnValue = SQLCA.SM01_PLAN_MAGAM(gs_saupj, syymm, '1')
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

// E-Mail 전송
p_mod.TriggerEvent(Clicked!)

p_can.TriggerEvent(Clicked!)
ib_any_typing = FALSE

end event

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\확정_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\확정_up.gif"
end event

type p_ins from w_inherite`p_ins within w_sm01_00060
integer x = 2606
integer y = 60
string picturename = "C:\erpman\image\의뢰생성_up.gif"
end type

event p_ins::ue_lbuttondown;PictureName = "C:\erpman\image\의뢰생성_dn.gif"
end event

event p_ins::ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\의뢰생성_up.gif"
end event

event p_ins::clicked;call super::clicked;String syymm
Int	 lRtnValue

If dw_ip.AcceptText() <> 1 Then Return

sYymm = Trim(dw_ip.GetItemString(1, 'yymm'))
If IsNull(sYymm) Or sYymm = '' Then
	f_message_chk(1400,'')
	Return
End If

// 마감내역 작성-완제품 재고 반영
lRtnValue = SQLCA.SM01_PLAN_MAGAM(gs_saupj, syymm, '1')
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

type p_exit from w_inherite`p_exit within w_sm01_00060
end type

type p_can from w_inherite`p_can within w_sm01_00060
end type

event p_can::clicked;call super::clicked;String sNull

SetNull(sNull)

dw_ip.SetItem(1, 'yymm', sNull)
dw_insert.Reset()
end event

type p_print from w_inherite`p_print within w_sm01_00060
integer x = 4096
string picturename = "C:\erpman\image\확정취소_up.gif"
end type

event p_print::clicked;call super::clicked;String sYymm
Long	 nCnt

If dw_ip.AcceptText() <> 1 Then Return

sYymm = dw_ip.GetItemString(1, 'yymm')
If IsNull(sYymm) Or sYymm = '' Then Return

SELECT COUNT(*) INTO :nCnt FROM PM01_MONPLAN_DTL WHERE SABU = :gs_sabu AND MONYYMM = :syymm AND JUCHA = 0;
If nCnt > 0 Then
	MessageBox('확인','이미 생산계획이 수립되어 있습니다.!!')
//	Return
End If

If  MessageBox("확정취소", '월 판매계획을 확정취소 처리 합니다', Exclamation!, OKCancel!, 2) = 2 Then Return

UPDATE LW_002
   SET MANAGEDATE = NULL,
	    WANDATE = NULL
 WHERE SAUPJ = :gs_saupj AND YYMM = :syymm;
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

type p_inq from w_inherite`p_inq within w_sm01_00060
integer x = 2423
integer y = 60
end type

event p_inq::clicked;call super::clicked;String sDate, sCust, sMagam, sGbn
Long	 nCnt

If dw_ip.AcceptText() <> 1 Then Return

sDate = dw_ip.GetItemString(1, 'yymm')

sGbn = dw_ip.GetItemString(1, 'cargbn1')

sCust = Trim(dw_ip.GetItemString(1, 'cust'))
If IsNull(sCust) Then scust = ''

// 판매계획
If sGbn = '1' Then
	If dw_insert.Retrieve(gs_saupj, sdate, sCust+'%') > 0 Then
		
		SELECT COUNT(*), MAX(MANAGEDATE) INTO :nCnt, :sMagam FROM LW_002 WHERE SAUPJ = :gs_saupj AND YYMM = :sDate;
		
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
Else
	If dw_insert.Retrieve(gs_saupj, sdate) > 0 Then
	Else
		MessageBox('확 인','조회된 자료가 없습니다.')
	End If
End If
end event

type p_del from w_inherite`p_del within w_sm01_00060
boolean visible = false
integer x = 2395
integer y = 44
boolean enabled = false
end type

type p_mod from w_inherite`p_mod within w_sm01_00060
integer x = 3744
string picturename = "C:\erpman\image\메일전송_up.gif"
end type

event p_mod::clicked;call super::clicked;String ls_window_id , ls_window_nm, syymm
Double   ll_sp = 0

ls_window_id = 'w_sm01_00060'
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

event p_mod::ue_lbuttondown;PictureName = "C:\erpman\image\메일전송_dn.gif"
end event

event p_mod::ue_lbuttonup;PictureName = "C:\erpman\image\메일전송_up.gif"
end event

type cb_exit from w_inherite`cb_exit within w_sm01_00060
end type

type cb_mod from w_inherite`cb_mod within w_sm01_00060
end type

type cb_ins from w_inherite`cb_ins within w_sm01_00060
end type

type cb_del from w_inherite`cb_del within w_sm01_00060
end type

type cb_inq from w_inherite`cb_inq within w_sm01_00060
end type

type cb_print from w_inherite`cb_print within w_sm01_00060
end type

type st_1 from w_inherite`st_1 within w_sm01_00060
end type

type cb_can from w_inherite`cb_can within w_sm01_00060
end type

type cb_search from w_inherite`cb_search within w_sm01_00060
end type







type gb_button1 from w_inherite`gb_button1 within w_sm01_00060
end type

type gb_button2 from w_inherite`gb_button2 within w_sm01_00060
end type

type dw_ip from u_key_enter within w_sm01_00060
integer x = 105
integer y = 96
integer width = 2290
integer height = 96
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_sm01_00060_1"
boolean border = false
end type

event itemchanged;String sDate, sMagam, sCust
Long	 nCnt

Choose Case GetColumnName()
	Case 'yymm'
		dw_insert.Reset()
	Case 'cargbn1'
		If GetText() = '1' Then
			dw_insert.DataObject = 'd_sm01_00060_2'
		Else
			dw_insert.DataObject = 'd_sm01_00040_3'
		End If
		dw_insert.SetTransObject(sqlca)
End Choose
end event

type rr_2 from roundrectangle within w_sm01_00060
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 59
integer y = 52
integer width = 2350
integer height = 172
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within w_sm01_00060
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 252
integer width = 4471
integer height = 2016
integer cornerheight = 40
integer cornerwidth = 55
end type

