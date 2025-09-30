$PBExportHeader$w_kgle05.srw
$PBExportComments$가결산 조정전표 등록
forward
global type w_kgle05 from w_inherite
end type
type cb_copy1 from commandbutton within w_kgle05
end type
type cb_copy2 from commandbutton within w_kgle05
end type
type gb_button3 from groupbox within w_kgle05
end type
type dw_saupj from datawindow within w_kgle05
end type
type tab_junpoy from tab within w_kgle05
end type
type tabpage_ins from userobject within tab_junpoy
end type
type rr_1 from roundrectangle within tabpage_ins
end type
type dw_ins from u_key_enter within tabpage_ins
end type
type tabpage_ins from userobject within tab_junpoy
rr_1 rr_1
dw_ins dw_ins
end type
type tabpage_lst from userobject within tab_junpoy
end type
type rr_3 from roundrectangle within tabpage_lst
end type
type dw_junlst from datawindow within tabpage_lst
end type
type tabpage_lst from userobject within tab_junpoy
rr_3 rr_3
dw_junlst dw_junlst
end type
type tabpage_hap from userobject within tab_junpoy
end type
type rr_2 from roundrectangle within tabpage_hap
end type
type dw_hap from datawindow within tabpage_hap
end type
type tabpage_hap from userobject within tab_junpoy
rr_2 rr_2
dw_hap dw_hap
end type
type tab_junpoy from tab within w_kgle05
tabpage_ins tabpage_ins
tabpage_lst tabpage_lst
tabpage_hap tabpage_hap
end type
type dw_print from datawindow within w_kgle05
end type
type p_preview from picture within w_kgle05
end type
type p_copy from picture within w_kgle05
end type
end forward

global type w_kgle05 from w_inherite
string title = "가결산 조정전표 등록"
boolean ib_any_typing = true
cb_copy1 cb_copy1
cb_copy2 cb_copy2
gb_button3 gb_button3
dw_saupj dw_saupj
tab_junpoy tab_junpoy
dw_print dw_print
p_preview p_preview
p_copy p_copy
end type
global w_kgle05 w_kgle05

type variables
Integer  ICur_TabPage
end variables

forward prototypes
public function integer wf_requiredchk (integer il_row)
end prototypes

public function integer wf_requiredchk (integer il_row);
String  sAcc1,sAcc2,sDcGbn,sDeptCd,sRemark1
Double  dAmount

tab_junpoy.tabpage_ins.dw_ins.AcceptText()

sDcGbn  = tab_junpoy.tabpage_ins.dw_ins.GetItemString(il_row,"dcr_gu") 
sAcc1   = tab_junpoy.tabpage_ins.dw_ins.GetItemString(il_row,"acc1_cd")
sAcc2   = tab_junpoy.tabpage_ins.dw_ins.GetItemString(il_row,"acc2_cd")
dAmount = tab_junpoy.tabpage_ins.dw_ins.GetItemNumber(il_row,"amt") 
//sDeptCd = tab_junpoy.tabpage_ins.dw_ins.GetItemString(il_row,"sdept_cd")

IF sDcGbn = "" OR IsNull(sDcGbn) THEN
	F_MessageChk(1,'[차대구분]')
	tab_junpoy.tabpage_ins.dw_ins.ScrollToRow(il_row)
	tab_junpoy.tabpage_ins.dw_ins.SetColumn("dcr_gu")
	tab_junpoy.tabpage_ins.dw_ins.SetFocus()
	Return -1
END IF
IF sAcc1 = "" OR IsNull(sAcc1) THEN
	F_MessageChk(1,'[계정과목]')
	tab_junpoy.tabpage_ins.dw_ins.ScrollToRow(il_row)
	tab_junpoy.tabpage_ins.dw_ins.SetColumn("acc1_cd")
	tab_junpoy.tabpage_ins.dw_ins.SetFocus()
	Return -1
END IF
IF sAcc2 = "" OR IsNull(sAcc2) THEN
	F_MessageChk(1,'[계정과목]')
	tab_junpoy.tabpage_ins.dw_ins.ScrollToRow(il_row)
	tab_junpoy.tabpage_ins.dw_ins.SetColumn("acc2_cd")
	tab_junpoy.tabpage_ins.dw_ins.SetFocus()
	Return -1
END IF
IF dAmount = 0 OR IsNull(dAmount) THEN
	F_MessageChk(1,'[금액]')
	tab_junpoy.tabpage_ins.dw_ins.ScrollToRow(il_row)
	tab_junpoy.tabpage_ins.dw_ins.SetColumn("amt")
	tab_junpoy.tabpage_ins.dw_ins.SetFocus()
	Return -1
END IF
select nvl(remark1,'N') into :sRemark1 from kfz01om0 where acc1_cd||acc2_cd = :sAcc1||:sAcc2;

//if sRemark1 = 'Y' and (sDeptCd = '' or IsNull(sDeptCd)) then
//	F_MessageChk(1,'[원가부문]')
//	tab_junpoy.tabpage_ins.dw_ins.ScrollToRow(il_row)
//	tab_junpoy.tabpage_ins.dw_ins.SetColumn("sdept_cd")
//	tab_junpoy.tabpage_ins.dw_ins.SetFocus()
//	Return -1	
//end if

Return 1
end function

on w_kgle05.create
int iCurrent
call super::create
this.cb_copy1=create cb_copy1
this.cb_copy2=create cb_copy2
this.gb_button3=create gb_button3
this.dw_saupj=create dw_saupj
this.tab_junpoy=create tab_junpoy
this.dw_print=create dw_print
this.p_preview=create p_preview
this.p_copy=create p_copy
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_copy1
this.Control[iCurrent+2]=this.cb_copy2
this.Control[iCurrent+3]=this.gb_button3
this.Control[iCurrent+4]=this.dw_saupj
this.Control[iCurrent+5]=this.tab_junpoy
this.Control[iCurrent+6]=this.dw_print
this.Control[iCurrent+7]=this.p_preview
this.Control[iCurrent+8]=this.p_copy
end on

on w_kgle05.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_copy1)
destroy(this.cb_copy2)
destroy(this.gb_button3)
destroy(this.dw_saupj)
destroy(this.tab_junpoy)
destroy(this.dw_print)
destroy(this.p_preview)
destroy(this.p_copy)
end on

event open;call super::open;Integer          iVal
DataWindowChild  Dw_Child

dw_saupj.SetTransObject(SQLCA)
dw_saupj.Reset()
dw_saupj.InsertRow(0)

dw_saupj.SetItem(dw_saupj.GetRow(),"saupj",  gs_saupj)
dw_saupj.SetItem(dw_saupj.GetRow(),"fs_ym",  Left(F_Today(),6))

dw_saupj.SetFocus()

tab_junpoy.tabpage_ins.dw_ins.SetTransObject(SQLCA)
tab_junpoy.tabpage_lst.dw_junlst.SetTransObject(SQLCA)
tab_junpoy.tabpage_hap.dw_hap.SetTransObject(SQLCA)

iVal = tab_junpoy.tabpage_ins.dw_ins.GetChild("sdept_cd",Dw_Child)
IF iVal = 1 THEN
	dw_child.SetTransObject(Sqlca)
	
	IF dw_child.Retrieve('%') <=0 THEN
		dw_child.InsertRow(0)
	END IF		
END IF

tab_junpoy.SelectedTab = 1

p_ins.SetFocus()

ib_any_typing = False


end event

type dw_insert from w_inherite`dw_insert within w_kgle05
boolean visible = false
integer x = 82
integer y = 2428
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kgle05
boolean visible = false
integer x = 3945
integer y = 2524
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kgle05
integer x = 2985
integer y = 12
integer taborder = 50
string pointer = "C:\erpman\cur\point.cur"
string picturename = "C:\erpman\image\가결산집계_d.gif"
end type

event p_addrow::ue_lbuttondown;PictureName = "C:\erpman\image\가결산집계_dn.gif"
end event

event p_addrow::ue_lbuttonup;PictureName = "C:\erpman\image\가결산집계_up.gif"
end event

event p_addrow::clicked;call super::clicked;String sFsYm

dw_saupj.AcceptText()
sFsYm  = Trim(dw_saupj.GetItemString(dw_saupj.GetRow(),"fs_ym"))

w_mdi_frame.sle_msg.text = '가결산 전표 집계 중...'
SetPointer(HourGlass!)

IF f_closing_sum(sFsYm,sFsYm) <> 1 THEN
	MessageBox("확 인","가결산집계 실패 !!")
	ROLLBACK;
	RETURN
END IF

w_mdi_frame.sle_msg.text = '가결산 전표 집계 완료!!'
SetPointer(Arrow!)
Commit;

ib_any_typing =False

end event

type p_search from w_inherite`p_search within w_kgle05
integer x = 2807
integer y = 12
string pointer = "c:\ERPMAN\cur\Point.cur"
string picturename = "C:\erpman\image\시산표복사_d.gif"
end type

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\시산표복사_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\시산표복사_up.gif"
end event

event p_search::clicked;call super::clicked;String sFsYm

w_mdi_frame.sle_msg.text = ''

dw_saupj.AcceptText()
sFsYm  = Trim(dw_saupj.GetItemString(dw_saupj.GetRow(),"fs_ym"))


w_mdi_frame.sle_msg.text = '시산표 자료 복사 중...'
SetPointer(HourGlass!)
IF f_closing_copy(sFsYm,sFsYm,'000000','000000') <> 1 THEN
	MessageBox("확 인","시산표 복사 실패 !!")
	ROLLBACK;
	Return
END IF
w_mdi_frame.sle_msg.text = '시산표 자료 복사 완료!!'
SetPointer(Arrow!)

ib_any_typing =False
end event

type p_ins from w_inherite`p_ins within w_kgle05
integer x = 3200
integer y = 12
integer taborder = 40
string pointer = "C:\erpman\cur\new.cur"
end type

event p_ins::clicked;call super::clicked;Integer          iCurRow,iFunctionValue,iVal
DataWindowChild  Dw_Child

w_mdi_frame.sle_msg.text =""

IF tab_junpoy.tabpage_ins.dw_ins.RowCount() > 0 THEN
	iFunctionValue = Wf_RequiredChk(tab_junpoy.tabpage_ins.dw_ins.GetRow())
	IF iFunctionValue <> 1 THEN RETURN
ELSE
	iFunctionValue = 1	
END IF

IF iFunctionValue = 1 THEN
	
	iVal = tab_junpoy.tabpage_ins.dw_ins.GetChild("sdept_cd",Dw_Child)
	IF iVal = 1 THEN
		dw_child.SetTransObject(Sqlca)
		
		IF dw_child.Retrieve('%') <=0 THEN
			dw_child.InsertRow(0)
		END IF		
	END IF

	iCurRow = tab_junpoy.tabpage_ins.dw_ins.InsertRow(0)

	tab_junpoy.tabpage_ins.dw_ins.ScrollToRow(iCurRow)
	tab_junpoy.tabpage_ins.dw_ins.SetItem(iCurRow,"fs_ym",  dw_saupj.GetItemString(1,"fs_ym"))
	tab_junpoy.tabpage_ins.dw_ins.SetItem(iCurRow,"saupj",  dw_saupj.GetItemString(1,"saupj"))
	tab_junpoy.tabpage_ins.dw_ins.SetItem(iCurRow,"seq_no", iCurRow)
	
	tab_junpoy.tabpage_ins.dw_ins.SetColumn("dcr_gu")
	tab_junpoy.tabpage_ins.dw_ins.SetFocus()
	
	ib_any_typing =False
	
	p_del.Enabled   = True
	p_del.Picturename = "C:\erpman\image\삭제_up.gif"
	p_mod.Enabled   = True
	p_mod.Picturename = "C:\erpman\image\저장_up.gif"

END IF

end event

type p_exit from w_inherite`p_exit within w_kgle05
integer y = 12
end type

type p_can from w_inherite`p_can within w_kgle05
boolean visible = false
integer x = 4114
integer y = 2548
integer taborder = 0
end type

type p_print from w_inherite`p_print within w_kgle05
integer x = 4270
integer y = 12
end type

event p_print::clicked;IF dw_print.rowcount() > 0 then 
	gi_page = long(dw_print.Describe("evaluate('pagecount()', 1)" ))
ELSE
	gi_page = 1
END IF
OpenWithParm(w_print_options, dw_print)
end event

type p_inq from w_inherite`p_inq within w_kgle05
integer x = 3918
integer y = 12
integer taborder = 30
end type

event p_inq::clicked;String sSaupj, sFsYm
Int ll_row

w_mdi_frame.sle_msg.text =""

IF dw_saupj.AcceptText() = -1 THEN RETURN

sFsYm  = Trim(dw_saupj.GetItemString(dw_saupj.GetRow(),"fs_ym"))
sSaupj = dw_saupj.GetItemString(dw_saupj.GetRow(),"saupj")

IF Icur_TabPage = 1 THEN
	IF sSaupj = "" OR IsNull(sSaupj) THEN
		F_MessageChk(1,'[사업장]')
		dw_saupj.SetFocus()
		Return
	END IF

	IF tab_junpoy.tabpage_ins.dw_ins.Retrieve(sFsYm,sSaupj) <=0 THEN
		F_MessageChk(14,'')
	ELSE
		dw_print.Retrieve(sFsYm,sSaupj)
	END IF

	p_ins.Enabled   = True
	p_ins.Picturename = "C:\erpman\image\추가_up.gif"
	
	p_del.Enabled   = True
	p_del.Picturename = "C:\erpman\image\삭제_up.gif"
	
	p_mod.Enabled   = True
	p_mod.Picturename = "C:\erpman\image\저장_up.gif"
	
	p_search.Enabled = True
	p_search.Picturename = "C:\erpman\image\시산표복사_up.gif"
	
   p_addrow.Enabled = True
	p_addrow.Picturename = "C:\erpman\image\가결산집계_up.gif"
	
	p_copy.Enabled = True
	p_copy.Picturename = "C:\erpman\image\자료복사_up.gif"
	
	p_print.Enabled = True
	p_print.Picturename = "C:\erpman\image\인쇄_up.gif"
	
	
ELSE
	IF Icur_TabPage = 2 THEN
		IF sSaupj = "" OR IsNull(sSaupj) THEN sSaupj = '%'
		
		dw_print.ShareData(tab_junpoy.tabpage_lst.dw_junlst)

		IF tab_junpoy.tabpage_lst.dw_junlst.Retrieve(sFsYm, sSaupj) <=0 THEN
			F_MessageChk(14,'')	
		END IF		
	ELSE
		IF sSaupj = "" OR IsNull(sSaupj) THEN sSaupj = '%'
	
		dw_print.ShareData(tab_junpoy.tabpage_hap.dw_hap)
		
		IF tab_junpoy.tabpage_hap.dw_hap.Retrieve(sSaupj,sFsYm) <=0 THEN
			F_MessageChk(14,'')	
		END IF	
	END IF
	
	p_ins.Enabled   = False
	p_ins.Picturename = "C:\erpman\image\추가_d.gif"
	p_del.Enabled   = False
	p_del.Picturename = "C:\erpman\image\삭제_d.gif"
	p_mod.Enabled   = False
	p_mod.Picturename = "C:\erpman\image\저장_d.gif"
	

	p_search.Enabled = False
	p_search.Picturename = "C:\erpman\image\시산표복사_d.gif"
   p_addrow.Enabled = False
	p_addrow.Picturename = "C:\erpman\image\가결산집계_d.gif"
	p_copy.Enabled = False
	p_copy.Picturename = "C:\erpman\image\자료복사_d.gif"
	
	p_print.Enabled = True
	p_print.Picturename = "C:\erpman\image\인쇄_up.gif"
	
END IF

ib_any_typing =False
	



end event

type p_del from w_inherite`p_del within w_kgle05
integer x = 3547
integer y = 12
integer taborder = 70
end type

event p_del::clicked;call super::clicked;Integer k

IF tab_junpoy.tabpage_ins.dw_ins.GetRow() <= 0 THEN
	f_messagechk(11,'')
	Return
END IF

IF F_DbConFirm('삭제') = 2 THEN RETURN

tab_junpoy.tabpage_ins.dw_ins.DeleteRow(tab_junpoy.tabpage_ins.dw_ins.GetRow())
IF tab_junpoy.tabpage_ins.dw_ins.Update() = 1 THEN
	commit;
	
	FOR k = 1 TO tab_junpoy.tabpage_ins.dw_ins.RowCount()
		tab_junpoy.tabpage_ins.dw_ins.SetItem(k,'seq_no', k)
	NEXT
	
	ib_any_typing = False
	w_mdi_frame.sle_msg.text ="자료가 삭제되었습니다.!!!"
ELSE
	ROLLBACK;
	f_messagechk(12,'')
END IF

end event

type p_mod from w_inherite`p_mod within w_kgle05
integer x = 3374
integer y = 12
integer taborder = 60
end type

event p_mod::clicked;call super::clicked;Integer k,iRtnValue

IF tab_junpoy.tabpage_ins.dw_ins.AcceptText() = -1 THEN Return

IF tab_junpoy.tabpage_ins.dw_ins.RowCount() > 0 THEN
	FOR k = 1 TO tab_junpoy.tabpage_ins.dw_ins.RowCount()
		iRtnValue = Wf_RequiredChk(k)
		IF iRtnValue = -1 THEN RETURN
	NEXT
ELSE
	Return
END IF

IF f_dbConFirm('저장') = 2 THEN RETURN

IF tab_junpoy.tabpage_ins.dw_ins.Update() = 1 THEN
	commit;
	
	FOR k = 1 TO tab_junpoy.tabpage_ins.dw_ins.RowCount()
		tab_junpoy.tabpage_ins.dw_ins.SetItem(k,'seq_no', k)
	NEXT

	ib_any_typing = False
	w_mdi_frame.sle_msg.text ="자료가 저장되었습니다.!!!"
ELSE
	ROLLBACK;
	f_messagechk(13,'')
END IF

end event

type cb_exit from w_inherite`cb_exit within w_kgle05
integer x = 3186
integer y = 2748
end type

type cb_mod from w_inherite`cb_mod within w_kgle05
integer x = 1618
integer y = 2744
boolean enabled = false
end type

event cb_mod::clicked;call super::clicked;Integer k,iRtnValue

IF tab_junpoy.tabpage_ins.dw_ins.AcceptText() = -1 THEN Return

IF tab_junpoy.tabpage_ins.dw_ins.RowCount() > 0 THEN
	FOR k = 1 TO tab_junpoy.tabpage_ins.dw_ins.RowCount()
		iRtnValue = Wf_RequiredChk(k)
		IF iRtnValue = -1 THEN RETURN
	NEXT
ELSE
	Return
END IF

IF f_dbConFirm('저장') = 2 THEN RETURN

IF tab_junpoy.tabpage_ins.dw_ins.Update() = 1 THEN
	commit;
	
	FOR k = 1 TO tab_junpoy.tabpage_ins.dw_ins.RowCount()
		tab_junpoy.tabpage_ins.dw_ins.SetItem(k,'seq_no', k)
	NEXT

	ib_any_typing = False
	sle_msg.text ="자료가 저장되었습니다.!!!"
ELSE
	ROLLBACK;
	f_messagechk(13,'')
END IF

end event

type cb_ins from w_inherite`cb_ins within w_kgle05
integer x = 1266
integer y = 2744
boolean enabled = false
string text = "추가(&I)"
end type

event cb_ins::clicked;Integer  iCurRow,iFunctionValue

sle_msg.text =""

IF tab_junpoy.tabpage_ins.dw_ins.RowCount() > 0 THEN
	iFunctionValue = Wf_RequiredChk(tab_junpoy.tabpage_ins.dw_ins.GetRow())
	IF iFunctionValue <> 1 THEN RETURN
ELSE
	iFunctionValue = 1	
END IF

IF iFunctionValue = 1 THEN
	iCurRow = tab_junpoy.tabpage_ins.dw_ins.InsertRow(0)

	tab_junpoy.tabpage_ins.dw_ins.ScrollToRow(iCurRow)
	tab_junpoy.tabpage_ins.dw_ins.SetItem(iCurRow,"fs_ym",  dw_saupj.GetItemString(1,"fs_ym"))
	tab_junpoy.tabpage_ins.dw_ins.SetItem(iCurRow,"saupj",  dw_saupj.GetItemString(1,"saupj"))
	tab_junpoy.tabpage_ins.dw_ins.SetItem(iCurRow,"seq_no", iCurRow)
	
	tab_junpoy.tabpage_ins.dw_ins.SetColumn("dcr_gu")
	tab_junpoy.tabpage_ins.dw_ins.SetFocus()
	
	ib_any_typing =False
	
	cb_mod.Enabled = True
	cb_del.Enabled = True

END IF

end event

type cb_del from w_inherite`cb_del within w_kgle05
integer x = 1970
integer y = 2744
boolean enabled = false
end type

event cb_del::clicked;call super::clicked;Integer k

IF tab_junpoy.tabpage_ins.dw_ins.GetRow() <= 0 THEN
	f_messagechk(11,'')
	Return
END IF

IF F_DbConFirm('삭제') = 2 THEN RETURN

tab_junpoy.tabpage_ins.dw_ins.DeleteRow(tab_junpoy.tabpage_ins.dw_ins.GetRow())
IF tab_junpoy.tabpage_ins.dw_ins.Update() = 1 THEN
	commit;
	
	FOR k = 1 TO tab_junpoy.tabpage_ins.dw_ins.RowCount()
		tab_junpoy.tabpage_ins.dw_ins.SetItem(k,'seq_no', k)
	NEXT
	
	ib_any_typing = False
	sle_msg.text ="자료가 삭제되었습니다.!!!"
ELSE
	ROLLBACK;
	f_messagechk(12,'')
END IF

end event

type cb_inq from w_inherite`cb_inq within w_kgle05
integer x = 2482
integer y = 2748
end type

event cb_inq::clicked;call super::clicked;String sSaupj, sFsYm
Int ll_row

sle_msg.text =""

IF dw_saupj.AcceptText() = -1 THEN RETURN

sFsYm  = Trim(dw_saupj.GetItemString(dw_saupj.GetRow(),"fs_ym"))
sSaupj = dw_saupj.GetItemString(dw_saupj.GetRow(),"saupj")

IF Icur_TabPage = 1 THEN
	IF sSaupj = "" OR IsNull(sSaupj) THEN
		F_MessageChk(1,'[사업장]')
		dw_saupj.SetFocus()
		Return
	END IF

	IF tab_junpoy.tabpage_ins.dw_ins.Retrieve(sFsYm,sSaupj) <=0 THEN
		F_MessageChk(14,'')	
	END IF

	cb_ins.Enabled =True
	cb_mod.Enabled =True
	cb_del.Enabled =True
	
	cb_copy1.Enabled = True
	cb_copy2.Enabled = True
	
	cb_print.Enabled = False
ELSE
	IF Icur_TabPage = 2 THEN
		IF sSaupj = "" OR IsNull(sSaupj) THEN sSaupj = '%'

		IF tab_junpoy.tabpage_lst.dw_junlst.Retrieve(sFsYm, sSaupj) <=0 THEN
			F_MessageChk(14,'')	
		END IF		
	ELSE
		IF sSaupj = "" OR IsNull(sSaupj) THEN sSaupj = '%'
	
		IF tab_junpoy.tabpage_hap.dw_hap.Retrieve(sSaupj) <=0 THEN
			F_MessageChk(14,'')	
		END IF	
	END IF
	cb_ins.Enabled = False
	cb_mod.Enabled = False
	cb_del.Enabled = False
	
	cb_copy1.Enabled = False
	cb_copy2.Enabled = False
	
	cb_print.Enabled = True
END IF

ib_any_typing =False
	



end event

type cb_print from w_inherite`cb_print within w_kgle05
integer x = 2834
integer y = 2748
boolean enabled = false
end type

event cb_print::clicked;call super::clicked;String sSaupj,sSaupjName,sd_frymd,sd_toymd,sj_frymd,sj_toymd,sdang_msg,sbef_msg
Int ld_ses,lj_ses

sSaupj =dw_saupj.GetItemString(dw_saupj.GetRow(),"saupj")
IF Icur_TabPage = 2 THEN	
	IF tab_junpoy.tabpage_lst.dw_junlst.RowCount() <=0 THEN Return
ELSEIF Icur_TabPage = 3 THEN	
	IF tab_junpoy.tabpage_hap.dw_hap.RowCount() <=0 THEN Return
END IF

IF MessageBox("확 인","출력하시겠습니까?",Question!,YesNo!) = 2 THEN RETURN

IF Icur_TabPage = 2 THEN	
	SELECT "KFZ08OM0"."D_SES","KFZ08OM0"."D_FRYMD","KFZ08OM0"."D_TOYMD",   
			 "KFZ08OM0"."J_SES","KFZ08OM0"."J_FRYMD","KFZ08OM0"."J_TOYMD"  
		INTO :ld_ses          ,:sd_frymd           ,:sd_toymd,   
			  :lj_ses          ,:sj_frymd           ,:sj_toymd  
		FROM "KFZ08OM0"  ;
		
	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox("확 인","회기 자료를 찾을 수 없습니다.!!")
		Return 
	END IF
	
//	sdang_msg ="당기 "+String(ld_ses)+" 기 "+String(sd_frymd,"@@@@/@@/@@")+" 부터 "+&
//							String(sd_toymd,"@@@@/@@/@@")+" 까지 "
//							
//	sbef_msg ="전기 "+String(lj_ses)+" 기 "+String(sj_frymd,"@@@@/@@/@@")+" 부터 "+&
//							String(sj_toymd,"@@@@/@@/@@")+" 까지 "
//							
//	tab_junpoy.tabpage_lst.dw_junlst.Modify("dang_msg.text ='"+sdang_msg+"'")
//	tab_junpoy.tabpage_lst.dw_junlst.Modify("bef_msg.text ='"+sbef_msg+"'")
	
	OpenWithParm(w_print_options, tab_junpoy.tabpage_lst.dw_junlst)
ELSEIF Icur_TabPage = 3 THEN	
	SELECT "REFFPF"."RFNA1"    	INTO :sSaupjName
	  	FROM "REFFPF"  
  		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND  ( "REFFPF"."RFGUB" = :sSaupj )   ;
			
	tab_junpoy.tabpage_hap.dw_hap.Modify("saup.text ='"+sSaupjName+"'")
	
	OpenWithParm(w_print_options, tab_junpoy.tabpage_hap.dw_hap)
END IF

end event

type st_1 from w_inherite`st_1 within w_kgle05
end type

type cb_can from w_inherite`cb_can within w_kgle05
integer x = 2176
integer y = 2488
integer width = 558
string text = "가결산전표출력"
end type

type cb_search from w_inherite`cb_search within w_kgle05
integer x = 2757
integer y = 2488
end type







type gb_button1 from w_inherite`gb_button1 within w_kgle05
integer x = 64
integer y = 2700
integer width = 1061
integer height = 176
end type

type gb_button2 from w_inherite`gb_button2 within w_kgle05
integer x = 1234
integer y = 2700
integer width = 1106
integer height = 176
end type

type cb_copy1 from commandbutton within w_kgle05
boolean visible = false
integer x = 96
integer y = 2748
integer width = 466
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "시산표복사(&C)"
end type

event clicked;String sd_frymd,sd_toymd,sj_frymd,sj_toymd,sdang_msg,sbef_msg
Int ld_ses,lj_ses

SELECT "KFZ08OM0"."D_SES","KFZ08OM0"."D_FRYMD","KFZ08OM0"."D_TOYMD",   
       "KFZ08OM0"."J_SES","KFZ08OM0"."J_FRYMD","KFZ08OM0"."J_TOYMD"  
	INTO :ld_ses          ,:sd_frymd           ,:sd_toymd,   
        :lj_ses          ,:sj_frymd           ,:sj_toymd  
   FROM "KFZ08OM0"  ;
	
IF SQLCA.SQLCODE <> 0 THEN
	MessageBox("확 인","회기 자료를 찾을 수 없습니다.!!")
	Return 
END IF

sle_msg.text = '시산표 자료 복사 중...'
SetPointer(HourGlass!)
IF f_closing_copy(sd_frymd,sd_toymd,sj_frymd,sj_toymd) <> 1 THEN
	MessageBox("확 인","시산표 복사 실패 !!")
	ROLLBACK;
	Return
END IF
sle_msg.text = '시산표 자료 복사 완료!!'
SetPointer(Arrow!)

ib_any_typing =False
end event

type cb_copy2 from commandbutton within w_kgle05
boolean visible = false
integer x = 576
integer y = 2748
integer width = 517
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "가결산집계(&A)"
end type

event clicked;
String sFsYm

dw_saupj.AcceptText()
sFsYm  = Trim(dw_saupj.GetItemString(dw_saupj.GetRow(),"fs_ym"))

sle_msg.text = '가결산 전표 집계 중...'
SetPointer(HourGlass!)

IF f_closing_sum(Left(sFsYm,4)+'01',sFsYm) <> 1 THEN
	MessageBox("확 인","가결산집계 실패 !!")
	ROLLBACK;
	RETURN
END IF

sle_msg.text = '가결산 전표 집계 완료!!'
SetPointer(Arrow!)
Commit;

ib_any_typing =False
end event

type gb_button3 from groupbox within w_kgle05
boolean visible = false
integer x = 2446
integer y = 2700
integer width = 1111
integer height = 176
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
end type

type dw_saupj from datawindow within w_kgle05
event ue_press_enter pbm_dwnprocessenter
integer x = 73
integer y = 16
integer width = 1984
integer height = 188
integer taborder = 10
string dataobject = "dw_kgle05_1"
boolean border = false
boolean livescroll = true
end type

event ue_press_enter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;String snull,ssql_saupj

SetNull(snull)

IF dwo.name ="saupj" THEN
	
	IF data ="" OR IsNull(data) THEN RETURN 

	SELECT "REFFPF"."RFNA1"    		INTO :ssql_saupj
  		FROM "REFFPF"  
  		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND  ( "REFFPF"."RFGUB" = :data )   ;
  	if sqlca.sqlcode <> 0 then
  	  	f_messagechk(20,"사업장")
		dw_saupj.SetItem(1,"saupj",snull)
		dw_saupj.SetColumn("saupj")
		dw_saupj.SetFocus()
		Return 1
  	end if
END IF

IF dwo.name ="fs_ym" THEN
	
	IF Trim(data) ="" OR IsNull(Trim(data)) THEN RETURN 

	if F_DateChk(data+'01') = -1 then
  	  	f_messagechk(21,"[가결산년월]")
		dw_saupj.SetItem(1,"fs_ym",snull)
		dw_saupj.SetColumn("fs_ym")
		dw_saupj.SetFocus()
		Return 1
  	end if
END IF

end event

event itemerror;Return 1
end event

type tab_junpoy from tab within w_kgle05
integer x = 64
integer y = 216
integer width = 4539
integer height = 2032
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean raggedright = true
integer selectedtab = 1
tabpage_ins tabpage_ins
tabpage_lst tabpage_lst
tabpage_hap tabpage_hap
end type

on tab_junpoy.create
this.tabpage_ins=create tabpage_ins
this.tabpage_lst=create tabpage_lst
this.tabpage_hap=create tabpage_hap
this.Control[]={this.tabpage_ins,&
this.tabpage_lst,&
this.tabpage_hap}
end on

on tab_junpoy.destroy
destroy(this.tabpage_ins)
destroy(this.tabpage_lst)
destroy(this.tabpage_hap)
end on

event selectionchanged;
icur_tabpage = newindex

IF newindex = 1 THEN
	tab_junpoy.tabpage_ins.dw_ins.Reset()
	
	p_ins.Enabled   = False
	p_ins.Picturename = "C:\erpman\image\추가_d.gif"
	
	p_del.Enabled   = False
	p_del.Picturename = "C:\erpman\image\삭제_d.gif"
	
	p_mod.Enabled   = False
	p_mod.Picturename = "C:\erpman\image\저장_d.gif"
	
	p_search.Enabled = True
	p_search.Picturename = "C:\erpman\image\시산표복사_up.gif"
	
   p_addrow.Enabled = True
	p_addrow.Picturename = "C:\erpman\image\가결산집계_up.gif"
	
	p_copy.Enabled = True
	p_copy.Picturename = "C:\erpman\image\자료복사_up.gif"
	
	p_print.Enabled = True
	p_print.Picturename = "C:\erpman\image\인쇄_up.gif"
	
	
	dw_print.dataobject = "dw_kgle05_4_p"
	dw_print.settransobject(sqlca)

ELSEif newindex = 3 THEN
	
	tab_junpoy.tabpage_hap.dw_hap.Reset()
	
	p_ins.Enabled   = False
	p_ins.Picturename = "C:\erpman\image\추가_d.gif"
	
	p_del.Enabled   = False
	p_del.Picturename = "C:\erpman\image\삭제_d.gif"
	
	p_mod.Enabled   = False
	p_mod.Picturename = "C:\erpman\image\저장_d.gif"

	p_search.Enabled = False
	p_search.Picturename = "C:\erpman\image\시산표복사_d.gif"
	
   p_addrow.Enabled = False
	p_addrow.Picturename = "C:\erpman\image\가결산집계_d.gif"
	
	p_copy.Enabled = False
	p_copy.Picturename = "C:\erpman\image\자료복사_d.gif"
	
	p_print.Enabled = True
	p_print.Picturename = "C:\erpman\image\인쇄_up.gif"
	
	dw_print.dataobject = "dw_kgle05_3_p"
	dw_print.settransobject(sqlca)
END IF

end event

type tabpage_ins from userobject within tab_junpoy
integer x = 18
integer y = 96
integer width = 4503
integer height = 1920
long backcolor = 32106727
string text = "가결산전표"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_1 rr_1
dw_ins dw_ins
end type

on tabpage_ins.create
this.rr_1=create rr_1
this.dw_ins=create dw_ins
this.Control[]={this.rr_1,&
this.dw_ins}
end on

on tabpage_ins.destroy
destroy(this.rr_1)
destroy(this.dw_ins)
end on

type rr_1 from roundrectangle within tabpage_ins
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 28
integer width = 4434
integer height = 1808
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_ins from u_key_enter within tabpage_ins
integer x = 27
integer y = 32
integer width = 4407
integer height = 1792
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_kgle05_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event editchanged;ib_any_typing =True
end event

event itemchanged;
String snull,sDcrGbn,sAcc1,sAcc2,ssql_acc1name,ssql_acc2name,ssql_balgu,sGbn1

SetNull(snull)

IF this.GetColumnName() ="dcr_gu" THEN
	sDcrGbn = this.GetText()
	IF sDcrGbn = '' OR IsNull(sDcrGbn) THEN Return
	
	IF sDcrGbn <> '1' AND sDcrGbn <> '2' THEN 
		F_MessageChk(20,'[차대구분]')
		this.SetItem(this.GetRow(),"dcr_gu",snull)
		this.SetColumn("dcr_gu")
		this.SetFocus()
		RETURN 1
	END IF
END IF

IF this.GetColumnName() ="acc1_cd" THEN
	sAcc1 = this.GetText()
	IF sAcc1 = "" OR IsNull(sAcc1) THEN Return
	
	sAcc2 =this.GetItemString(this.GetRow(),"acc2_cd")	
	IF sAcc2 = "" OR IsNull(sAcc2) THEN Return
	
	SELECT "KFZ01OM0"."ACC1_NM",	"KFZ01OM0"."ACC2_NM",	"BAL_GU",			"GBN1"
   	INTO :ssql_acc1name,			:ssql_acc2name,			:ssql_balgu,		:sGbn1
   	FROM "KFZ01OM0"  
   	WHERE ( "KFZ01OM0"."ACC1_CD" = :sAcc1) AND ( "KFZ01OM0"."ACC2_CD" = :sAcc2 ) ;				
	IF SQLCA.SQLCODE = -1 OR SQLCA.SQLCODE = 100 THEN
		F_MessageChk(20,'[계정과목]')
		this.SetItem(this.GetRow(),"acc1_cd",snull)
		this.SetItem(this.GetRow(),"acc2_cd",snull)
		this.SetItem(this.GetRow(),"acc1_nm",snull)
		this.SetItem(this.GetRow(),"acc2_nm",snull)
		this.SetItem(this.GetRow(),"gbn1",   snull)
		this.SetColumn("acc1_cd")
		this.SetFocus()
		Return 1
	ELSE
		IF ssql_balgu ='4' THEN
			MessageBox("확 인","전표를 발행할 수 없는 계정입니다.!!")
		ELSEIF this.GetItemString(this.GetRow(),"dcr_gu") = '1' AND &
																			ssql_balgu ='2' THEN
			Messagebox("확 인","전표를 대변에만 발행하는 계정입니다.!!")
		ELSEIF this.GetItemString(this.GetRow(),"dcr_gu") = '2' AND &
																					ssql_balgu ='1' THEN
			Messagebox("확 인","전표를 차변에만 발행하는 계정입니다.!!")
		ELSE
			this.SetItem(this.GetRow(),"acc1_nm",ssql_acc1name)
			this.SetItem(this.GetRow(),"acc2_nm",ssql_acc2name)
			this.SetItem(this.GetRow(),"gbn1",   sGbn1)
			Return 1
		END IF
		this.SetItem(this.GetRow(),"acc1_cd",snull)
		this.SetItem(this.GetRow(),"acc2_cd",snull)
		this.SetItem(this.GetRow(),"acc1_nm",snull)
		this.SetItem(this.GetRow(),"acc2_nm",snull)
		this.SetColumn("acc1_cd")
		this.SetFocus()
		Return 1
	END IF
END IF

IF this.GetColumnName() ="acc2_cd" THEN
	sAcc2 = this.GetText()
	IF sAcc2 = "" OR IsNull(sAcc2) THEN Return
	
	sAcc1 =this.GetItemString(this.GetRow(),"acc1_cd")	
	IF sAcc1 = "" OR IsNull(sAcc1) THEN Return
	
	SELECT "KFZ01OM0"."ACC1_NM",	"KFZ01OM0"."ACC2_NM",	"BAL_GU",			"GBN1"
   	INTO :ssql_acc1name,			:ssql_acc2name,			:ssql_balgu,		:sGbn1
   	FROM "KFZ01OM0"  
   	WHERE ( "KFZ01OM0"."ACC1_CD" = :sAcc1) AND ( "KFZ01OM0"."ACC2_CD" = :sAcc2 ) ;				
	IF SQLCA.SQLCODE = -1 OR SQLCA.SQLCODE = 100 THEN
		F_MessageChk(20,'[계정과목]')
		this.SetItem(this.GetRow(),"acc1_cd",snull)
		this.SetItem(this.GetRow(),"acc2_cd",snull)
		this.SetItem(this.GetRow(),"acc1_nm",snull)
		this.SetItem(this.GetRow(),"acc2_nm",snull)
		this.SetItem(this.GetRow(),"gbn1",   snull)
		this.SetColumn("acc1_cd")
		this.SetFocus()
		Return 1
	ELSE
		IF ssql_balgu ='4' THEN
			MessageBox("확 인","전표를 발행할 수 없는 계정입니다.!!")
		ELSEIF this.GetItemString(this.GetRow(),"dcr_gu") = '1' AND &
																			ssql_balgu ='2' THEN
			Messagebox("확 인","전표를 대변에만 발행하는 계정입니다.!!")
		ELSEIF this.GetItemString(this.GetRow(),"dcr_gu") = '2' AND &
																					ssql_balgu ='1' THEN
			Messagebox("확 인","전표를 차변에만 발행하는 계정입니다.!!")
		ELSE
			this.SetItem(this.GetRow(),"acc1_nm",ssql_acc1name)
			this.SetItem(this.GetRow(),"acc2_nm",ssql_acc2name)
			this.SetItem(this.GetRow(),"gbn1",   sGbn1)
			Return 
		END IF
		this.SetItem(this.GetRow(),"acc1_cd",snull)
		this.SetItem(this.GetRow(),"acc2_cd",snull)
		this.SetItem(this.GetRow(),"acc1_nm",snull)
		this.SetItem(this.GetRow(),"acc2_nm",snull)
		this.SetColumn("acc1_cd")
		this.SetFocus()
		Return 1
	END IF
END IF

IF this.GetColumnName() = "kwan_no" THEN
	IF this.GetText() = "" OR IsNull(this.GetText()) THEN 
		this.Setitem(this.GetRow(),"kwan_name",snull)
		Return
	END IF
	
	this.SetItem(this.GetRow(),"kwan_name",f_get_personlst(this.GetItemString(this.GetRow(),"gbn1"),&
																			 this.GetText(),'%'))
END IF
end event

event itemerror;Return 1
end event

event rbuttondown;String ls_gj1,ls_gj2,snull

SetNull(snull)

this.AcceptText()
IF this.GetColumnName() ="acc1_cd" OR this.GetColumnName() ="acc2_cd" THEN

	lstr_account.acc1_cd = Left(this.GetItemString(this.GetRow(),"acc1_cd"),1)

	IF IsNull(lstr_account.acc1_cd) then lstr_account.acc1_cd = ""
	SetNull(lstr_account.acc2_cd)
	
	Open(W_KFZ01OM0_POPUP)

	IF IsNull(lstr_account.acc1_cd) AND IsNull(lstr_account.acc2_cd) THEN RETURN
	
	IF this.GetItemString(this.GetRow(),"dcr_gu") = '1' AND &
																	lstr_account.bal_gu ='2' THEN
			Messagebox("확 인","전표를 대변에만 발행하는 계정입니다.!!")
	ELSEIF this.GetItemString(this.GetRow(),"dcr_gu") = '2' AND &
																	lstr_account.bal_gu ='1' THEN
		Messagebox("확 인","전표를 차변에만 발행하는 계정입니다.!!")
	ELSE
		this.SetItem(this.GetRow(),"acc1_cd",lstr_account.acc1_cd)
		this.SetItem(this.GetRow(),"acc2_cd",lstr_account.acc2_cd)
		this.SetItem(this.GetRow(),"acc1_nm",lstr_account.acc1_nm)
		this.SetItem(this.GetRow(),"acc2_nm",lstr_account.acc2_nm)
		this.SetItem(this.GetRow(),"gbn1",   lstr_account.gbn1)
		Return
	END IF
	this.SetItem(this.GetRow(),"acc1_cd",snull)
	this.SetItem(this.GetRow(),"acc2_cd",snull)
	this.SetItem(this.GetRow(),"acc1_nm",snull)
	this.SetItem(this.GetRow(),"acc2_nm",snull)
END IF

IF this.GetColumnName() ="kwan_no" THEN
	SetNull(lstr_custom.code)
	SetNull(lstr_custom.name)

	lstr_custom.code = Trim(this.GetItemString(this.GetRow(),"kwan_no"))
	
	IF IsNull(lstr_custom.code) THEN
		lstr_custom.code = ""
	END IF

	IF IsNull(lstr_custom.name) THEN
		lstr_custom.name = ""
	END IF
	
	
	OpenWithParm(W_KFZ04OM0_POPUP,this.GetItemString(this.GetRow(),"gbn1"))
	
	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
	
	this.SetItem(this.GetRow(),"kwan_no",  lstr_custom.code)
	this.Setitem(this.GetRow(),"kwan_name",lstr_custom.name)
END IF

end event

type tabpage_lst from userobject within tab_junpoy
integer x = 18
integer y = 96
integer width = 4503
integer height = 1920
long backcolor = 32106727
string text = "가결산전표현황"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_3 rr_3
dw_junlst dw_junlst
end type

on tabpage_lst.create
this.rr_3=create rr_3
this.dw_junlst=create dw_junlst
this.Control[]={this.rr_3,&
this.dw_junlst}
end on

on tabpage_lst.destroy
destroy(this.rr_3)
destroy(this.dw_junlst)
end on

type rr_3 from roundrectangle within tabpage_lst
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 28
integer width = 4453
integer height = 1876
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_junlst from datawindow within tabpage_lst
integer x = 37
integer y = 40
integer width = 4425
integer height = 1848
integer taborder = 30
boolean bringtotop = true
string dataobject = "dw_kgle05_4"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type tabpage_hap from userobject within tab_junpoy
integer x = 18
integer y = 96
integer width = 4503
integer height = 1920
long backcolor = 32106727
string text = "결산용 합계잔액시산표"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_2 rr_2
dw_hap dw_hap
end type

on tabpage_hap.create
this.rr_2=create rr_2
this.dw_hap=create dw_hap
this.Control[]={this.rr_2,&
this.dw_hap}
end on

on tabpage_hap.destroy
destroy(this.rr_2)
destroy(this.dw_hap)
end on

type rr_2 from roundrectangle within tabpage_hap
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 28
integer width = 4434
integer height = 1800
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_hap from datawindow within tabpage_hap
integer x = 27
integer y = 36
integer width = 4416
integer height = 1780
integer taborder = 21
boolean bringtotop = true
string dataobject = "dw_kgle05_3"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_print from datawindow within w_kgle05
boolean visible = false
integer x = 2258
integer y = 48
integer width = 128
integer height = 112
boolean bringtotop = true
string dataobject = "dw_kgle05_4_p"
end type

type p_preview from picture within w_kgle05
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
event ue_mousemove pbm_mousemove
integer x = 4096
integer y = 12
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "C:\erpman\cur\preview.cur"
string picturename = "C:\erpman\image\미리보기_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;IF This.Enabled = True THEN
	PictureName = 'C:\erpman\image\미리보기_dn.gif'
END IF

end event

event ue_lbuttonup;IF This.Enabled = True THEN
	PictureName =  'C:\erpman\image\미리보기_up.gif'
END IF
end event

event clicked;OpenWithParm(w_print_preview, dw_print)	
end event

type p_copy from picture within w_kgle05
integer x = 3744
integer y = 12
integer width = 178
integer height = 144
boolean bringtotop = true
string picturename = "C:\erpman\image\자료복사_d.gif"
boolean focusrectangle = false
end type

event clicked;String   sYm,sSaupj
Integer  iCount

dw_saupj.AcceptText()
sYm    = dw_saupj.GetItemString(1,"fs_ym")
sSaupj = dw_saupj.GetItemString(1,"saupj")

if sYm = '' or IsNull(sYm) then
	F_MessageChk(1,'[가결산년월]')
	dw_saupj.SetColumn("fs_ym")
	dw_saupj.SetFocus()
	Return
end if

select Count(*)	into :iCount  from kfz02ot1 where fs_ym = :sYm ;
if sqlca.sqlcode = 0 then
	if IsNull(iCount) then iCount = 0
else
	iCount = 0
end if
if iCount > 0 then
	if MessageBox('확 인','자료가 존재합니다.삭제하시고 다시 생성하시겠습니까?',Question!,YesNo!) = 2 then Return

	delete from kfz02ot1 where fs_ym = :sYm ;
	Commit;
end if

OpenWithParm(w_kgle05a,sYm)

if Message.StringParm <> '0' then
	tab_junpoy.tabpage_ins.dw_ins.Retrieve(sYm,sSaupj)
end if
	
end event

