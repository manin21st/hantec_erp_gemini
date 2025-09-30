$PBExportHeader$w_sm01_00050.srw
$PBExportComments$주간 판매계획 확정
forward
global type w_sm01_00050 from w_inherite
end type
type dw_list from datawindow within w_sm01_00050
end type
type rr_2 from roundrectangle within w_sm01_00050
end type
type rr_1 from roundrectangle within w_sm01_00050
end type
end forward

global type w_sm01_00050 from w_inherite
string title = "주간 판매계획 확정"
dw_list dw_list
rr_2 rr_2
rr_1 rr_1
end type
global w_sm01_00050 w_sm01_00050

forward prototypes
public function integer wf_nagam (string arg_date)
end prototypes

public function integer wf_nagam (string arg_date);Long nCnt
String sSaupj

/* 사업장 체크 */
sSaupj= Trim(dw_insert.GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_insert.SetFocus()
	dw_insert.SetColumn('saupj')
	Return -1
End If

SELECT COUNT(*) INTO :nCnt 
  FROM SM03_WEEKPLAN_ITEM
 WHERE SAUPJ = :sSaupj
   AND YYMMDD = :arg_date
	AND CNFIRM IS NOT NULL;

If nCnt > 0 Then
	MessageBox('확 인','주간 판매계획이 마감되었습니다.!!')
	
	p_ins.Enabled = False
	p_mod.Enabled = False
	p_search.Enabled = True
	p_ins.PictureName = 'C:\erpman\image\의뢰생성_d.gif'
	p_mod.PictureName = 'C:\erpman\image\확정_d.gif'
	p_search.PictureName = 'C:\erpman\image\확정취소_up.gif'
Else
	p_ins.Enabled = True
	p_mod.Enabled = True
	p_search.Enabled = False
	p_ins.PictureName = 'C:\erpman\image\의뢰생성_up.gif'
	p_mod.PictureName = 'C:\erpman\image\확정_up.gif'
	p_search.PictureName = 'C:\erpman\image\확정취소_d.gif'
End If

Return 0


end function

on w_sm01_00050.create
int iCurrent
call super::create
this.dw_list=create dw_list
this.rr_2=create rr_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list
this.Control[iCurrent+2]=this.rr_2
this.Control[iCurrent+3]=this.rr_1
end on

on w_sm01_00050.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_list)
destroy(this.rr_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_list.SetTransObject(sqlca)
dw_insert.SetTransObject(sqlca)

dw_insert.InsertRow(0)

/* 최종계획년월을 셋팅 */
String sDate
select MAX(YYMMDD) INTO :sDate from SM03_WEEKPLAN_ITEM;

dw_insert.SetItem(1, 'yymm', sDate)

f_mod_saupj(dw_insert, 'saupj')

wf_nagam(sdate)
end event

type dw_insert from w_inherite`dw_insert within w_sm01_00050
integer x = 73
integer y = 84
integer width = 2985
integer height = 104
string dataobject = "d_sm01_00050_1"
boolean border = false
end type

event dw_insert::itemchanged;String sDate

Choose Case GetColumnName()
	Case 'yymm'
		sDate = Trim(GetText())
				
		If DayNumber(Date( Left(sDate,4)+'-'+Mid(sDate,5,2) +'-'+Right(sDate,2) )) <> 2 Then
			MessageBox('확 인','주간 계획은 월요일로 지정해야 합니다.!!')
			Return 1
			Return
		End If
		
		wf_nagam(sdate)
	Case 'cargbn1'
		If GetText() = '1' Then
			dw_list.DataObject = 'd_sm01_03040_2'
		Else
			dw_list.DataObject = 'd_sm01_03040_3'
		End If
		dw_list.SetTransObject(sqlca)
End Choose
end event

event dw_insert::itemerror;call super::itemerror;return 1
end event

type p_delrow from w_inherite`p_delrow within w_sm01_00050
boolean visible = false
integer x = 3762
integer y = 304
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_sm01_00050
boolean visible = false
integer x = 3589
integer y = 304
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_sm01_00050
integer x = 4247
integer y = 56
boolean originalsize = true
string picturename = "C:\erpman\image\확정취소_up.gif"
end type

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\확정취소_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\확정취소_UP.gif"
end event

event p_search::clicked;String sYymm
String sSaupj

If dw_insert.AcceptText() <> 1 Then Return

sYymm = dw_insert.GetItemString(1, 'yymm')
If IsNull(sYymm) Or sYymm = '' Then Return

/* 사업장 체크 */
sSaupj= Trim(dw_insert.GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_insert.SetFocus()
	dw_insert.SetColumn('saupj')
	Return -1
End If

If  MessageBox("마감", '주간 판매계획을 확정취소 처리 합니다', Exclamation!, OKCancel!, 2) = 2 Then Return

UPDATE sm03_weekplan_item
   SET CNFIRM = NULL, SANGYN = NULL
 WHERE SAUPJ = :sSaupj AND YYMMDD = :syymm;
If SQLCA.SQLCODE <> 0 Then
	MessageBox(string(sqlca.sqlcode), sqlca.sqlerrtext)
	Rollback;
	Return
End If

COMMIT;

MessageBox('확인','정상적으로 취소처리되었습니다.!!')

ib_any_typing = FALSE
end event

type p_ins from w_inherite`p_ins within w_sm01_00050
boolean visible = false
integer x = 3429
integer y = 56
string picturename = "C:\erpman\image\의뢰생성_up.gif"
end type

event p_ins::clicked;String syymm
Int	 lRtnValue
String sSaupj

If dw_insert.AcceptText() <> 1 Then Return

sYymm = Trim(dw_insert.GetItemString(1, 'yymm'))
If IsNull(sYymm) Or sYymm = '' Then
	f_message_chk(1400,'')
	Return
End If

/* 사업장 체크 */
sSaupj= Trim(dw_insert.GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_insert.SetFocus()
	dw_insert.SetColumn('saupj')
	Return -1
End If

// 마감내역 작성-완제품 재고 반영
lRtnValue = SQLCA.SM01_PLAN_MAGAM(sSaupj, syymm, '2')
IF lRtnValue < 0 THEN
	ROLLBACK;
	f_message_chk(41,'')
	sle_msg.text = string(lRtnValue) 
	Return
ELSE
	commit ;
	sle_msg.text = string(lRtnValue) + '건에 자료가 생성처리 되었습니다!!'
END IF

MessageBox('확인','생성되었습니다')

p_can.TriggerEvent(Clicked!)
end event

event p_ins::ue_lbuttondown;PictureName = "C:\erpman\image\의뢰생성_dn.gif"
end event

event p_ins::ue_lbuttonup;PictureName = "C:\erpman\image\의뢰생성_up.gif"
end event

type p_exit from w_inherite`p_exit within w_sm01_00050
integer x = 4421
integer y = 56
end type

type p_can from w_inherite`p_can within w_sm01_00050
boolean visible = false
integer x = 4283
integer y = 304
boolean enabled = false
end type

type p_print from w_inherite`p_print within w_sm01_00050
boolean visible = false
integer x = 3067
integer y = 304
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_sm01_00050
integer x = 3250
integer y = 56
end type

event p_inq::clicked;String sDate, sCust, sMagam, sGbn
Long	 nCnt
String sSaupj

sDate = dw_insert.GetItemString(1, 'yymm')

/* 사업장 체크 */
sSaupj= Trim(dw_insert.GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_insert.SetFocus()
	dw_insert.SetColumn('saupj')
	Return -1
End If

sGbn = dw_insert.GetItemString(1, 'cargbn1')

sCust = Trim(dw_insert.GetItemString(1, 'cust'))
If IsNull(sCust) Then scust = ''

If sGbn = '1' Then
	If dw_list.Retrieve(sSaupj, sdate, sCust+'%') > 0 Then
	Else
		MessageBox('확 인','조회된 자료가 없습니다.')
	End If
Else
	If dw_list.Retrieve(sSaupj, sdate) > 0 Then
	Else
		MessageBox('확 인','조회된 자료가 없습니다.')
	End If
End If

wf_nagam(sdate)
end event

type p_del from w_inherite`p_del within w_sm01_00050
boolean visible = false
integer x = 4110
integer y = 304
boolean enabled = false
end type

type p_mod from w_inherite`p_mod within w_sm01_00050
integer x = 4073
integer y = 56
boolean originalsize = true
string picturename = "C:\erpman\image\확정_up.gif"
end type

event p_mod::ue_lbuttondown;PictureName = "C:\erpman\image\확정_dn.gif"
end event

event p_mod::ue_lbuttonup;PictureName = "C:\erpman\image\확정_UP.gif"
end event

event p_mod::clicked;call super::clicked;String sYymm, sSaupj
Int	 lRtnValue

If dw_insert.AcceptText() <> 1 Then Return

sYymm = dw_insert.GetItemString(1, 'yymm')
If IsNull(sYymm) Or sYymm = '' Then Return

/* 사업장 체크 */
sSaupj= Trim(dw_insert.GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_insert.SetFocus()
	dw_insert.SetColumn('saupj')
	Return -1
End If

If  MessageBox("마감", '주간 판매계획을 확정 합니다', Exclamation!, OKCancel!, 1) = 2 Then Return

UPDATE sm03_weekplan_item
   SET CNFIRM = TO_CHAR(SYSDATE,'YYYYMMDD'), SANGYN = TO_CHAR(SYSDATE,'YYYYMMDD')
 WHERE SAUPJ = :sSaupj AND YYMMDD = :syymm;
If SQLCA.SQLCODE <> 0 Then
	MessageBox(string(sqlca.sqlcode), sqlca.sqlerrtext)
	Rollback;
	Return
End If

COMMIT;

// 마감내역 작성-완제품 재고 반영
lRtnValue = SQLCA.SM01_PLAN_MAGAM(sSaupj, syymm, '2')
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

wf_nagam(syymm)


ib_any_typing = FALSE
end event

type cb_exit from w_inherite`cb_exit within w_sm01_00050
end type

type cb_mod from w_inherite`cb_mod within w_sm01_00050
end type

type cb_ins from w_inherite`cb_ins within w_sm01_00050
integer x = 3611
integer y = 56
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_sm01_00050
end type

type cb_inq from w_inherite`cb_inq within w_sm01_00050
end type

type cb_print from w_inherite`cb_print within w_sm01_00050
end type

type st_1 from w_inherite`st_1 within w_sm01_00050
end type

type cb_can from w_inherite`cb_can within w_sm01_00050
end type

type cb_search from w_inherite`cb_search within w_sm01_00050
end type







type gb_button1 from w_inherite`gb_button1 within w_sm01_00050
end type

type gb_button2 from w_inherite`gb_button2 within w_sm01_00050
end type

type dw_list from datawindow within w_sm01_00050
integer x = 73
integer y = 256
integer width = 4512
integer height = 2004
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm01_03040_2"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;if row <= 0 then
	selectrow(0,false)
else
	selectrow(0,false)
	selectrow(row, true)
end if
end event

type rr_2 from roundrectangle within w_sm01_00050
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 59
integer y = 52
integer width = 3077
integer height = 172
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within w_sm01_00050
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 252
integer width = 4553
integer height = 2016
integer cornerheight = 40
integer cornerwidth = 55
end type

