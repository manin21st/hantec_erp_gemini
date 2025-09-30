$PBExportHeader$w_cic00070.srw
$PBExportComments$기초이월등록(부산물)
forward
global type w_cic00070 from w_inherite
end type
type dw_2 from datawindow within w_cic00070
end type
type gb_4 from groupbox within w_cic00070
end type
type dw_1 from datawindow within w_cic00070
end type
type dw_choose from datawindow within w_cic00070
end type
type rr_1 from roundrectangle within w_cic00070
end type
end forward

global type w_cic00070 from w_inherite
integer width = 4635
string title = "기초이월등록(부산물)"
dw_2 dw_2
gb_4 gb_4
dw_1 dw_1
dw_choose dw_choose
rr_1 rr_1
end type
global w_cic00070 w_cic00070

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
//	f_messagechk(1, '[기준년월]')
//	dw_1.SetColumn('workym')
//	dw_1.SetFocus()
//	Return -1
//End If
//
//If sItnbr = "" Or IsNull(sItnbr) Then
//	f_messagechk(1, '[제품명]')
//	dw_2.SetColumn('wp_qty')
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

public function integer wf_procedure (string as_workym, string as_itemclass, string as_prcid);
Return 1
end function

on w_cic00070.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.gb_4=create gb_4
this.dw_1=create dw_1
this.dw_choose=create dw_choose
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.gb_4
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.dw_choose
this.Control[iCurrent+5]=this.rr_1
end on

on w_cic00070.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_2)
destroy(this.gb_4)
destroy(this.dw_1)
destroy(this.dw_choose)
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

dw_1.SetItem(1, 'saupj','10')
dw_1.SetFocus()

dw_2.SetTransObject(SQLCA)
dw_2.Reset()

wf_button_chk('C', 0)
end event

type dw_insert from w_inherite`dw_insert within w_cic00070
boolean visible = false
integer x = 41
integer y = 2404
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_cic00070
integer x = 3877
integer taborder = 0
end type

event p_delrow::clicked;call super::clicked;String sItnbr, sTitnm
sItnbr = dw_2.Object.cic0125_itnbr[dw_2.GetRow()]
sTitnm = dw_2.Object.cic_itemas_vw_titnm[dw_2.GetRow()]
IF MessageBox("확 인","[제품코드:"+ sItnbr + ", 제품명:" + sTitnm + "]을 삭제하시겠습니까?",Question!,YesNo!) = 2 THEN RETURN

dw_2.deleterow(dw_2.getRow())
IF dw_2.Update() <>  1 THEN
	MessageBox("확 인","자료 삭제를 실패하였습니다!!")
	Rollback;
	Return
END IF
//COMMIT;
end event

type p_addrow from w_inherite`p_addrow within w_cic00070
integer x = 3694
integer taborder = 0
end type

event p_addrow::clicked;call super::clicked;dw_2.Insertrow(0)
dw_2.ScrollToRow(dw_2.Rowcount())
dw_2.SetFocus()

string syymm, saup

syymm   = dw_1.GetItemString(dw_1.GetRow(), 'workym')
saup = dw_1.GetItemString(dw_1.GetRow(),'saupj')

dw_2.SetItem(dw_2.Rowcount(),'cic0125_workym',syymm)
dw_2.SetItem(dw_2.Rowcount(),'cic0125_saupj',saup)


end event

type p_search from w_inherite`p_search within w_cic00070
boolean visible = false
integer x = 5010
integer y = 184
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
	f_messagechk(1,'[기준년월]')
	dw_1.SetColumn('workym')
	dw_1.SetFocus()
	Return
End If

sImgbn = Trim(dw_1.GetItemString(dw_1.GetRow(), 'imgbn'))
If sImgbn = "" Or IsNull(sImgbn) Then
	sImgbn = '%'
Else	
	MessageBox("알림", "기준년월에 대한 전체만 생성가능 합니다.!!!")
	dw_1.SetItem(dw_1.GetRow(), 'imgbn', snull)
	dw_1.SetColumn('imgbn')
	dw_1.SetFocus()
	Return
End If

////제품수불 집계
//SELECT count(*)
//  INTO :lRecCnt
//  FROM CIC0130
// WHERE WORKYM > :sWorkym;
//
//If lRecCnt > 0 Then
//	Messagebox('알림', '차월의 제품수불이 존재하여 기초기말재고를 생성할 수 없습니다.')
//	Return 
//End If

// 기초기말재고제품 생성(제품수불 집계(CIC0130) (당월))
If wf_procedure(sWorkym, sImgbn, 'CIC01013') = -1 Then
	Rollback;
	f_messagechk(13, '')
	Return
End If

p_inq.TriggerEvent(Clicked!)

end event

type p_ins from w_inherite`p_ins within w_cic00070
boolean visible = false
integer x = 5193
integer y = 184
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
	f_messagechk(1, '[기준년월]')
	dw_1.SetColumn('workym')
	dw_1.SetFocus()
	Return
End If

sImgbn = Trim(dw_1.GetItemString(dw_1.GetRow(), 'imgbn'))
If Not (sImgbn = "" Or IsNull(sImgbn)) Then
	MessageBox("알림", "기준년월에 대한 전체만 삭제가능 합니다.!!!")
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

////제품수불 집계
//SELECT count(*)
//  INTO :lRecCnt
//  FROM CIC0130
// WHERE WORKYM > :sWorkym;
//
//If lRecCnt > 0 Then
//	Messagebox('알림', '차월의 제품수불이 존재하여 당월의 기초기말재고를 삭제할 수 없습니다.')
//	Return 
//End If

w_mdi_frame.sle_msg.text = ""
If f_msg_delete() = -1 Then Return

//제품수불 집계
DELETE FROM CIC0130 WHERE WORKYM = :sWorkym;

If sqlca.sqlcode <> 0 then 
	Rollback;
	Messagebox("삭제실패", "자료에 대한 삭제에 실패하였읍니다.")
	w_mdi_frame.sle_msg.text = ""
	Return
End if

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

type p_exit from w_inherite`p_exit within w_cic00070
integer x = 4425
integer taborder = 70
end type

type p_can from w_inherite`p_can within w_cic00070
integer x = 4242
integer taborder = 60
end type

event p_can::clicked;call super::clicked;dw_1.Reset()
dw_1.InsertRow(0)

dw_1.SetItem(1, 'workym', f_aftermonth( Left(f_today(),6), -2))
dw_1.SetFocus()

dw_2.Reset()
wf_button_chk('C', 0)

ib_any_typing = False

end event

type p_print from w_inherite`p_print within w_cic00070
integer x = 5376
integer y = 184
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_cic00070
integer x = 3511
integer taborder = 30
end type

event p_inq::clicked;call super::clicked;String sWorkym, sImgbn,sittyp
Long	 lRowcnt

If dw_1.Accepttext() = -1 Then Return

sWorkym = Trim(dw_1.GetItemString(dw_1.GetRow(), 'workym'))
If sWorkym = "" Or IsNull(sWorkym) Then
	f_messagechk(1, '[기준년월]')
	dw_1.SetColumn('workym')
	dw_1.SetFocus()
	Return
End If

sImgbn = Trim(dw_1.GetItemString(dw_1.GetRow(), 'saupj'))
If sImgbn = "" Or IsNull(sImgbn) Then sImgbn = '%'

w_mdi_frame.sle_msg.Text = "조회 중입니다.!!!"
SetPointer(HourGlass!)
//dw_2.SetRedraw(False)

lRowcnt = dw_2.Retrieve(sWorkym, sImgbn)
/*If lRowcnt <=0 Then
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
End If*/

dw_2.SetRedraw(True)
w_mdi_frame.sle_msg.text = "조회가 완료되었습니다.!!!"
ib_any_typing = False
wf_button_chk('Q', lRowcnt)
SetPointer(Arrow!)
end event

type p_del from w_inherite`p_del within w_cic00070
integer x = 4827
integer y = 192
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

type p_mod from w_inherite`p_mod within w_cic00070
integer x = 4059
integer taborder = 40
end type

event p_mod::clicked;call super::clicked;String sWorkym, sImgbn
long ll_rowcount, ll_row,sqty

dw_2.Accepttext()

sWorkym   = Trim(dw_1.GetItemString(dw_1.GetRow(), 'workym'))
If sWorkym = "" Or IsNull(sWorkym) Then
	f_messagechk(1, '[기준년월]')
	dw_1.SetColumn('workym')
	dw_1.SetFocus()
	Return
End If

ll_rowcount = dw_2.rowcount()
if ll_rowcount < 1 then return

	for ll_row =  1 to ll_rowcount
		sqty   = dw_2.GetItemnumber(ll_row, 'cic0125_wp_qty')
		
		If IsNull(sqty) Or sqty = 0 Then
			f_messagechk(1, '[기말/기초수량]')
			dw_2.SetColumn('cic0125_wp_qty')
			dw_2.SetFocus()
			Return
		End If
		
		if ll_row = ll_rowcount then continue
	next

If ib_any_typing = False Then
	MessageBox("알림", "변경된 자료가 없습니다.!!!")
	Return 
End If	

If dw_2.Update() = 1 Then
	Commit;	
	w_mdi_frame.sle_msg.text = "자료가 저장되었습니다.!!!"
	ib_any_typing = False
Else
	Rollback;
	f_messagechk(13, '')
End If

end event

type cb_exit from w_inherite`cb_exit within w_cic00070
integer x = 3026
integer y = 2752
end type

type cb_mod from w_inherite`cb_mod within w_cic00070
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

type cb_ins from w_inherite`cb_ins within w_cic00070
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

type cb_del from w_inherite`cb_del within w_cic00070
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

type cb_inq from w_inherite`cb_inq within w_cic00070
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

type cb_print from w_inherite`cb_print within w_cic00070
integer x = 1650
integer y = 2424
end type

type st_1 from w_inherite`st_1 within w_cic00070
integer width = 293
end type

type cb_can from w_inherite`cb_can within w_cic00070
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

type cb_search from w_inherite`cb_search within w_cic00070
integer x = 2053
integer y = 2432
end type

type dw_datetime from w_inherite`dw_datetime within w_cic00070
integer height = 88
end type

type sle_msg from w_inherite`sle_msg within w_cic00070
integer x = 329
integer width = 2533
end type

type gb_10 from w_inherite`gb_10 within w_cic00070
integer width = 3607
end type

type gb_button1 from w_inherite`gb_button1 within w_cic00070
integer x = 110
integer y = 2696
end type

type gb_button2 from w_inherite`gb_button2 within w_cic00070
integer x = 2153
integer y = 2696
end type

type dw_2 from datawindow within w_cic00070
event ue_key pbm_dwnkey
event ue_enterkey pbm_dwnprocessenter
integer x = 50
integer y = 200
integer width = 4549
integer height = 2040
integer taborder = 80
string title = "기초이월등록(부산물)"
string dataobject = "dw_cic00070_20"
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

event itemchanged;
w_mdi_frame.sle_msg.text = ""
ib_any_typing = True

dw_2.AcceptText()

long  samt, sqty, sdan
string sitnbr, syymm, ls_titnm, ls_ispec,  saup, ls_ittyp, count

IF this.GetColumnName() ="cic0125_itnbr" THEN
	
	sitnbr = dw_2.GetItemString(dw_2.GetRow(),'cic0125_itnbr')

			
			select titnm, ispec, ittyp, count(itnbr)
			into :ls_titnm, :ls_ispec, :ls_ittyp, :count
			from cic_itemas_vw
			where itnbr = :sitnbr
			  
			group by titnm, ispec, ittyp;

			if count = '0' or isnull(count) or count = '' then
				messagebox("확인","존재하지않는 제품코드 입니다.!I!")
				dw_2.deleterow( dw_2.GetRow())
				dw_2.insertrow(0)	
				dw_2.SetColumn('cic0125_itnbr')
				dw_2.SetFocus()
				return
			elseif ls_ittyp ='3' then
				
				This.SetItem( dw_2.GetRow(), 'cic_itemas_vw_titnm', ls_titnm )
				This.SetItem( dw_2.GetRow(), 'cic_itemas_vw_ispec', ls_ispec )
				
				//syymm   = dw_1.GetItemString(dw_1.GetRow(), 'workym')
				//saup = dw_1.GetItemString(dw_1.GetRow(),'saupj')
	
				//dw_2.SetItem(dw_2.GetRow() ,'cic0125_workym',syymm)
				//dw_2.SetItem(dw_2.GetRow() ,'cic0125_saupj',saup)
			else
				messagebox("확인","제품구분이 올바르지 않습니다.!!!")
				dw_2.deleterow( dw_2.GetRow())
				dw_2.insertrow(0)		
				dw_2.SetColumn('cic0125_itnbr')
				dw_2.SetFocus()
				return
			end if
END IF

IF this.GetColumnName() ="cic0125_wp_qty" THEN
      if long(data) < 1 or isNull(data) then
			messagebox("확인", "기말/기초수량은 0이상 이여야 합니다.")
			return 1
		end if
		sitnbr = dw_2.GetItemString(Getrow(),'cic0125_itnbr')
		syymm = dw_1.GetItemString(dw_1.Getrow(),'workym')
		
		select fun_cic_danga(:sitnbr, :syymm) 
		into :sdan
		from dual;
		
		sqty = dw_2.GetItemnumber(Getrow(),'cic0125_wp_qty')
		samt = round(sqty * sdan,2)
		dw_2.Setitem(Getrow(),'dan',sdan)
		dw_2.Setitem(Getrow(),'cic0125_wp_amt',samt)
		
END IF

IF this.GetColumnName() ="cic0125_wp_amt" THEN
	
		samt = dw_2.GetItemnumber(Getrow(),'cic0125_wp_amt')
		sqty = dw_2.GetItemnumber(Getrow(),'cic0125_wp_qty')
		sdan = round(samt / sqty,2)
		
		dw_2.Setitem(Getrow(),'dan',sdan)
		
END IF
end event

event retrieverow;//If row > 0 Then
//	This.SetItem(row, 'sflag', 'M')
//End If
end event

event rowfocuschanged;//This.SetRowFocusIndicator(Hand!)
end event

event retrieveend;//Long lRowCnt
//
//For lRowCnt = 1 To rowcount
//	This.SetItem(lRowCnt, 'sflag', 'M')
//Next
end event

event itemerror;Return 1
end event

event getfocus;This.AcceptText()
end event

event rbuttondown;

SetNull(gs_code)
SetNull(gs_codename)
SetNull(Gs_gubun)

int ll_lstrow, ll_row, ll_rowcount
string ls_itnbr, ls_titnm, ls_ispec, syymm, saup, ls_filter

IF this.GetColumnName() ="cic0125_itnbr" THEN
	Open(w_itemas_popup10_cic)
	
	dw_choose.Reset()
	ll_lstrow = dw_choose.ImportClipboard()
	
	ls_filter = "flag = 'Y'"
	dw_choose.SetFilter(ls_filter)
	dw_choose.filter()
	
	ll_lstrow = dw_choose.Rowcount()

if ll_lstrow < 1 then Return
	
	ll_rowcount = dw_2.GetRow() 

		For ll_row = 1 to ll_lstrow
			
			ls_itnbr = dw_choose.GetItemString(ll_row,'itemas_itnbr')
			
			select titnm, ispec
			into :ls_titnm, :ls_ispec
			from cic_itemas_vw
			where itnbr = :ls_itnbr
			;
			
			This.SetItem(( ll_rowcount ), 'cic0125_itnbr', ls_itnbr )
			This.SetItem(( ll_rowcount ), 'cic_itemas_vw_titnm', ls_titnm )
			This.SetItem(( ll_rowcount ), 'cic_itemas_vw_ispec', ls_ispec )
         ib_any_typing = True
			
			syymm   = dw_1.GetItemString(dw_1.GetRow(), 'workym')
			saup = dw_1.GetItemString(dw_1.GetRow(),'saupj')

			dw_2.SetItem(ll_rowcount,'cic0125_workym',syymm)
			dw_2.SetItem(ll_rowcount,'cic0125_saupj',saup)
			
			if ll_row = ll_lstrow then Continue
			This.InsertRow(ll_rowcount + 1)
			ll_rowcount = ll_rowcount  + 1 
		Next
		
END IF

IF this.GetColumnName() ="cic_itemas_vw_titnm" THEN
	Open(w_itemas_popup10_cic)
	
	dw_choose.Reset()
	ll_lstrow = dw_choose.ImportClipboard()
	
	ls_filter = "flag = 'Y'"
	dw_choose.SetFilter(ls_filter)
	dw_choose.filter()
	
	ll_lstrow = dw_choose.Rowcount()

if ll_lstrow < 1 then Return
	
	ll_rowcount = dw_2.GetRow() 

		For ll_row = 1 to ll_lstrow
			
			ls_itnbr = dw_choose.GetItemString(ll_row,'itemas_itnbr')
			
			select titnm, ispec
			into :ls_titnm, :ls_ispec
			from cic_itemas_vw
			where itnbr = :ls_itnbr
			;
			
			This.SetItem(( ll_rowcount ), 'cic0125_itnbr', ls_itnbr )
			This.SetItem(( ll_rowcount ), 'cic_itemas_vw_titnm', ls_titnm )
			This.SetItem(( ll_rowcount ), 'cic_itemas_vw_ispec', ls_ispec )
         ib_any_typing = True
			
			syymm   = dw_1.GetItemString(dw_1.GetRow(), 'workym')
			saup = dw_1.GetItemString(dw_1.GetRow(),'saupj')

			dw_2.SetItem(ll_rowcount,'cic0125_workym',syymm)
			dw_2.SetItem(ll_rowcount,'cic0125_saupj',saup)
			
			if ll_row = ll_lstrow then Continue
			This.InsertRow(ll_rowcount + 1)
			ll_rowcount = ll_rowcount  + 1 
		Next
		
END IF

IF this.GetColumnName() ="cic_itemas_vw_ispec" THEN
	Open(w_itemas_popup10_cic)
	
	dw_choose.Reset()
	ll_lstrow = dw_choose.ImportClipboard()
	
	ls_filter = "flag = 'Y'"
	dw_choose.SetFilter(ls_filter)
	dw_choose.filter()
	
	ll_lstrow = dw_choose.Rowcount()

if ll_lstrow < 1 then Return
	
	ll_rowcount = dw_2.GetRow() 

		For ll_row = 1 to ll_lstrow
			
			ls_itnbr = dw_choose.GetItemString(ll_row,'itemas_itnbr')
			
			select titnm, ispec
			into :ls_titnm, :ls_ispec
			from cic_itemas_vw
			where itnbr = :ls_itnbr
			;
			
			This.SetItem(( ll_rowcount ), 'cic0125_itnbr', ls_itnbr )
			This.SetItem(( ll_rowcount ), 'cic_itemas_vw_titnm', ls_titnm )
			This.SetItem(( ll_rowcount ), 'cic_itemas_vw_ispec', ls_ispec )
         ib_any_typing = True
			
			syymm   = dw_1.GetItemString(dw_1.GetRow(), 'workym')
			saup = dw_1.GetItemString(dw_1.GetRow(),'saupj')

			dw_2.SetItem(ll_rowcount,'cic0125_workym',syymm)
			dw_2.SetItem(ll_rowcount,'cic0125_saupj',saup)
			
			if ll_row = ll_lstrow then Continue
			This.InsertRow(ll_rowcount + 1)
			ll_rowcount = ll_rowcount  + 1 
		Next
		
END IF
























end event

type gb_4 from groupbox within w_cic00070
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

type dw_1 from datawindow within w_cic00070
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 37
integer width = 1755
integer height = 160
integer taborder = 10
string dataobject = "dw_cic00070_10"
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
			f_messagechk(21, '[기준년월]')
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

type dw_choose from datawindow within w_cic00070
boolean visible = false
integer x = 3109
integer y = 32
integer width = 206
integer height = 120
integer taborder = 70
boolean bringtotop = true
string title = "none"
string dataobject = "d_itemas_popup10_detail_cic"
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_cic00070
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

