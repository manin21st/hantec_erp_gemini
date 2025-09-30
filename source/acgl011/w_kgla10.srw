$PBExportHeader$w_kgla10.srw
$PBExportComments$반제 기초자료 등록
forward
global type w_kgla10 from w_inherite
end type
type dw_ip from datawindow within w_kgla10
end type
type tab_banje from tab within w_kgla10
end type
type tabpage_sor from userobject within tab_banje
end type
type rr_1 from roundrectangle within tabpage_sor
end type
type dw_sor from u_key_enter within tabpage_sor
end type
type tabpage_sor from userobject within tab_banje
rr_1 rr_1
dw_sor dw_sor
end type
type tabpage_des from userobject within tab_banje
end type
type rr_2 from roundrectangle within tabpage_des
end type
type dw_des from u_key_enter within tabpage_des
end type
type tabpage_des from userobject within tab_banje
rr_2 rr_2
dw_des dw_des
end type
type tab_banje from tab within w_kgla10
tabpage_sor tabpage_sor
tabpage_des tabpage_des
end type
end forward

shared variables
string ls_saupj, ls_acc_date, ls_upmu_gu
long  ll_jun_no, ll_lin_no
end variables

global type w_kgla10 from w_inherite
string title = "반제 기초자료 등록"
dw_ip dw_ip
tab_banje tab_banje
end type
global w_kgla10 w_kgla10

type variables
string into_gbn, into_cus_gu
Integer li_CurPage
end variables

forward prototypes
public function integer wf_requiredchk (integer il_currow)
public function integer wf_retrieve (string saupj, string accdate, string upmugu, long junno, integer linno, string baldate, long bjunno)
public function integer wf_dup_chk (integer ll_row, string saupj, string saccdate, string supmugu, string sjunno, string slinno, string sbaldate, string sbjunno)
end prototypes

public function integer wf_requiredchk (integer il_currow);String  sacc_date, sbal_date,s_saupj, into_acc1_cd,s_saupno,sDeptCode		     
long    l_junno, l_linno

tab_banje.tabpage_sor.dw_sor.AcceptText()

s_saupj   = tab_banje.tabpage_sor.dw_sor.GetItemString(il_currow,"saupj") 
sbal_date = Trim(tab_banje.tabpage_sor.dw_sor.GetItemString(il_currow,"bal_date"))
sacc_date = Trim(tab_banje.tabpage_sor.dw_sor.GetItemString(il_currow,"acc_date"))
l_junno   = tab_banje.tabpage_sor.dw_sor.GetItemnumber(il_currow,"jun_no")
l_linno   = tab_banje.tabpage_sor.dw_sor.GetItemnumber(il_currow,"lin_no") 
s_saupno  = tab_banje.tabpage_sor.dw_sor.GetItemString(il_currow,"saup_no") 
sDeptCode = tab_banje.tabpage_sor.dw_sor.GetItemString(il_currow,"sdept_cd")  

IF s_saupj = "" OR IsNull(s_saupj) THEN
	F_MessageChk(1,'[사업장]')
	tab_banje.tabpage_sor.dw_sor.SetColumn("saupj")
	tab_banje.tabpage_sor.dw_sor.ScrollToRow(il_currow)
	tab_banje.tabpage_sor.dw_sor.SetFocus()
	Return -1
END IF 

IF sbal_date = "" OR IsNull(sbal_date) THEN
	F_MessageChk(1,'[작성일자]')
	tab_banje.tabpage_sor.dw_sor.SetColumn("bal_date")
	tab_banje.tabpage_sor.dw_sor.ScrollToRow(il_currow)
	tab_banje.tabpage_sor.dw_sor.SetFocus()
	Return -1
END IF 

IF sacc_date = "" OR IsNull(sacc_date) THEN
	F_MessageChk(1,'[회계일자]')
	tab_banje.tabpage_sor.dw_sor.SetColumn("acc_date")
	tab_banje.tabpage_sor.dw_sor.ScrollToRow(il_currow)
	tab_banje.tabpage_sor.dw_sor.SetFocus()
	Return -1
END IF 

IF l_junno = 0 OR IsNull(l_junno) THEN
	F_MessageChk(1,'[전표번호]')
	tab_banje.tabpage_sor.dw_sor.SetColumn("jun_no")
	tab_banje.tabpage_sor.dw_sor.ScrollToRow(il_currow)
	tab_banje.tabpage_sor.dw_sor.SetFocus()
	Return -1
ELSE
	tab_banje.tabpage_sor.dw_sor.SetItem(il_currow,"bjun_no",l_junno)
END IF 

IF l_linno = 0 OR IsNull(l_linno) THEN
	F_MessageChk(1,'[라인번호]')
	tab_banje.tabpage_sor.dw_sor.SetColumn("lin_no")
	tab_banje.tabpage_sor.dw_sor.ScrollToRow(il_currow)
	tab_banje.tabpage_sor.dw_sor.SetFocus()
	Return -1
END IF 

if (into_cus_gu = 'Y') and (s_saupno = "" or isnull(s_saupno)) then
	F_MessageChk(1,'[거래처코드]')
  	tab_banje.tabpage_sor.dw_sor.setcolumn("saup_no")
	tab_banje.tabpage_sor.dw_sor.setfocus()
	Return -1
END IF

//IF sDeptCode = "" OR IsNull(sDeptCode) THEN
//	F_MessageChk(1,'[원가부문]')
//	tab_banje.tabpage_sor.dw_sor.SetColumn("sdept_cd")
//	tab_banje.tabpage_sor.dw_sor.ScrollToRow(il_currow)
//	tab_banje.tabpage_sor.dw_sor.SetFocus()
//	Return -1
//END IF 

Return 1
end function

public function integer wf_retrieve (string saupj, string accdate, string upmugu, long junno, integer linno, string baldate, long bjunno);
IF tab_banje.tabpage_des.dw_des.Retrieve(saupj,accdate,upmugu,junno,linno,baldate,bjunno) <=0 THEN
	Return -1
ELSE
	Return 1
END IF
end function

public function integer wf_dup_chk (integer ll_row, string saupj, string saccdate, string supmugu, string sjunno, string slinno, string sbaldate, string sbjunno);String  s_date, s_jun_no, s_lin_no, s_saupj
Integer iReturnRow, l_row

IF Saupj   = "" OR IsNull(Saupj)   THEN RETURN 1
IF sAccDate = "" OR IsNull(sAccDate) THEN RETURN 1
IF sUpmuGu = "" OR IsNull(sUpmuGu) THEN RETURN 1
IF sJunNo  = "" OR IsNull(sJunNo)  THEN RETURN 1
IF sLinNo  = "" OR IsNull(sLinNo)  THEN RETURN 1

iReturnRow = tab_banje.tabpage_sor.dw_sor.find("saupj = '" + Saupj + &
															  "' and acc_date = '" + sAccDate + &
															  "' and upmu_gu  = '" + sUpmuGu + &
															  "' and str_junno = '" + sJunNo + &
															  "' and str_linno = '" + sLinNo + &															  
														     "' and bal_date = '" + sBalDate + &	
															  "' and str_bjunno = '" + sbJunNo + &															  
															  "'", 1, tab_banje.tabpage_sor.dw_sor.RowCount())

IF (ll_row <> iReturnRow) and (iReturnRow <> 0) THEN
	RETURN  -1
END IF
                              
Return 1
end function

on w_kgla10.create
int iCurrent
call super::create
this.dw_ip=create dw_ip
this.tab_banje=create tab_banje
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_ip
this.Control[iCurrent+2]=this.tab_banje
end on

on w_kgla10.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_ip)
destroy(this.tab_banje)
end on

event open;call super::open;
dw_ip.settransobject(sqlca)

tab_banje.tabpage_sor.dw_sor.settransobject(sqlca)
tab_banje.tabpage_des.dw_des.settransobject(sqlca)

dw_ip.Reset()
dw_ip.insertrow(0)

dw_ip.SetItem(1,"sfrom", Left(f_today(),6)+'01')
dw_ip.SetItem(1,"sto",   f_today())
dw_ip.SetItem(1,"saupj", Gs_Saupj)

IF F_Authority_Chk(Gs_Dept) = -1 THEN							/*권한 체크- 현업 여부*/
	dw_ip.Modify("saupj.protect = 1")
//	dw_ip.Modify("saupj.background.color ='"+String(RGB(192,192,192))+"'")
ELSE
	dw_ip.Modify("saupj.protect = 0")
//	dw_ip.Modify("saupj.background.color ='"+String(RGB(190,225,184))+"'")
END IF	

dw_ip.SetColumn("sfrom")
dw_ip.SetFocus()

end event

type dw_insert from w_inherite`dw_insert within w_kgla10
boolean visible = false
integer x = 59
integer y = 2384
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kgla10
boolean visible = false
integer x = 3639
integer y = 2748
end type

type p_addrow from w_inherite`p_addrow within w_kgla10
boolean visible = false
integer x = 3465
integer y = 2748
end type

type p_search from w_inherite`p_search within w_kgla10
boolean visible = false
integer x = 3479
integer y = 2552
end type

type p_ins from w_inherite`p_ins within w_kgla10
integer x = 3922
end type

event p_ins::clicked;call super::clicked;string s_date, s_saupj, snull
int    il_currow, iRtnValue, l_jun_no, l_lin_no,ll_findrow
long   k, sRow

setnull(snull)

if tab_banje.tabpage_sor.dw_sor.rowcount() > 0 then
	iRtnValue = wf_requiredchk(tab_banje.tabpage_sor.dw_sor.getrow())
	IF iRtnValue = -1 THEN Return
else
	iRtnValue = 1
end if

if iRtnValue = 1 then
	il_currow = tab_banje.tabpage_sor.dw_sor.insertrow(0)
	
	tab_banje.tabpage_sor.dw_sor.SetItem(il_currow, "saupj",    dw_ip.GetItemString(dw_ip.GetRow(),"saupj"))	
	tab_banje.tabpage_sor.dw_sor.SetItem(il_currow, "acc_date", f_today())
	tab_banje.tabpage_sor.dw_sor.SetItem(il_currow, "bal_date", f_today())
	
	tab_banje.tabpage_sor.dw_sor.scrolltorow(il_currow)
end if

tab_banje.tabpage_sor.dw_sor.setcolumn("bal_date")
tab_banje.tabpage_sor.dw_sor.setfocus()

ib_any_typing = true

tab_banje.tabpage_sor.dw_sor.Modify("DataWindow.HorizontalScrollPosition = '0'")
end event

type p_exit from w_inherite`p_exit within w_kgla10
end type

type p_can from w_inherite`p_can within w_kgla10
boolean visible = false
integer x = 3909
integer y = 2716
end type

type p_print from w_inherite`p_print within w_kgla10
boolean visible = false
integer x = 3653
integer y = 2552
end type

type p_inq from w_inherite`p_inq within w_kgla10
integer x = 3749
end type

event p_inq::clicked;call super::clicked;string sSaupj,sFrom,sTo, s_acc1,s_acc2, sAcc, s_saup, s_saupnm,sCrossGu

dw_ip.accepttext()
sSaupj   = dw_ip.getitemstring(1,"saupj")
sFrom    = Trim(dw_ip.getitemstring(1,"sfrom"))
sTo      = Trim(dw_ip.getitemstring(1,"sto"))
s_acc1   = dw_ip.getitemstring(1,"acc1_cd")
s_acc2   = dw_ip.getitemstring(1,"acc2_cd")
s_saup   = dw_ip.getitemstring(1,"saup_no")
s_saupnm = dw_ip.getitemstring(1,"person_nm")

sCrossGu = dw_ip.getitemstring(1,"crossgbn")

IF sSaupj = "" OR IsNull(sSaupj) THEN
	F_MessageChk(1,'[사업장]')
	dw_ip.SetColumn("saupj")
	dw_ip.SetFocus()
	Return
END IF

IF sFrom = "" OR IsNull(sFrom) THEN
	F_MessageChk(1,'[회계일자]')
	dw_ip.SetColumn("sfrom")
	dw_ip.SetFocus()
	Return
END IF
IF sTo = "" OR IsNull(sTo) THEN
	F_MessageChk(1,'[회계일자]')
	dw_ip.SetColumn("sto")
	dw_ip.SetFocus()
	Return
END IF

if s_acc1 = "" or isnull(s_acc1) or s_acc2 = ""  or isnull(s_acc2) then 
	sAcc = '%'
else
	sAcc = s_acc1 + s_acc2
end if

if s_saup = "" or isnull(s_saup) then s_saup = '%'

IF tab_banje.tabpage_sor.dw_sor.retrieve(sSaupj,sFrom,sTo,sAcc,s_saup,sCrossGu) <= 0 THEN
	F_MessageChk(14,'[반제대상]')
	dw_ip.setfocus()
	Return
END IF
tab_banje.SelectedTab = 1
li_curpage = 1

tab_banje.tabpage_sor.dw_sor.setfocus()

end event

type p_del from w_inherite`p_del within w_kgla10
integer x = 4270
end type

event p_del::clicked;call super::clicked;int row ,iCurRow

dw_ip.AcceptText()

IF li_curpage = 1 THEN													/*반제대상*/
	iCurRow = tab_banje.tabpage_sor.dw_sor.GetRow()

	IF iCurRow <=0 THEN Return
	
	IF Messagebox("삭 제 ","삭제하시겠습니까?", question!, yesno!) = 2 then Return
	
	tab_banje.tabpage_sor.dw_sor.DeleteRow(row)
	If tab_banje.tabpage_sor.dw_sor.Update() = 1 Then
		Commit;
		ib_any_typing = false
		w_mdi_frame.sle_msg.text ="자료를 삭제하였습니다!!"
		
	Else
		F_MessageChk(12,'')
		rollback;
		ib_any_typing = true
		return
	End If

ELSE																		/*반제결과*/
	iCurRow = tab_banje.tabpage_des.dw_des.GetRow()
	IF iCurRow <=0 THEN Return
	
	IF Messagebox("삭 제 ","삭제하시겠습니까?", question!, yesno!) = 2 then Return
	
	tab_banje.tabpage_des.dw_des.DeleteRow(row)
	If tab_banje.tabpage_des.dw_des.Update() = 1 Then
		Commit;
		ib_any_typing = false
		w_mdi_frame.sle_msg.text ="자료를 삭제하였습니다!!"
	Else
		F_MessageChk(12,'')
		rollback;
		ib_any_typing = true
		return
	End If
END IF


end event

type p_mod from w_inherite`p_mod within w_kgla10
integer x = 4096
end type

event p_mod::clicked;call super::clicked;Int    k

dw_ip.AcceptText()

IF li_curpage = 1 THEN															/*반제대상*/
	if tab_banje.tabpage_sor.dw_sor.accepttext() = -1 then return

	if tab_banje.tabpage_sor.dw_sor.rowcount() > 0 then
		for k = 1 to tab_banje.tabpage_sor.dw_sor.rowcount()
			if wf_requiredchk(tab_banje.tabpage_sor.dw_sor.getrow()) = -1 then return
		next
	else
		return
	end if
	  
	if f_dbConFirm('저장') = 2 then return
	
	if tab_banje.tabpage_sor.dw_sor.update() > 0 then
		commit;
		ib_any_typing = false
		w_mdi_frame.sle_msg.text = '자료를 저장하였습니다!!'
	else
		F_MessageChk(13,'')
		rollback;
		ib_any_typing = true
		return
	end if
	
	tab_banje.tabpage_sor.dw_sor.scrolltorow(tab_banje.tabpage_sor.dw_sor.getrow())
	
ELSE
	if tab_banje.tabpage_des.dw_des.accepttext() = -1 then return
	if tab_banje.tabpage_des.dw_des.rowcount() <= 0 then Return
	  
	if f_dbConFirm('저장') = 2 then return
	
	if tab_banje.tabpage_des.dw_des.update() > 0 then
		commit;
		ib_any_typing = false
		w_mdi_frame.sle_msg.text = '자료를 저장하였습니다!!'
	else
		F_MessageChk(13,'')
		rollback;
		ib_any_typing = true
		return
	end if
	
	tab_banje.tabpage_des.dw_des.scrolltorow(tab_banje.tabpage_des.dw_des.getrow())
	
END IF

end event

type cb_exit from w_inherite`cb_exit within w_kgla10
boolean visible = false
integer x = 3269
integer y = 2900
integer taborder = 70
end type

type cb_mod from w_inherite`cb_mod within w_kgla10
boolean visible = false
integer x = 2555
integer y = 2900
integer taborder = 50
end type

event cb_mod::clicked;call super::clicked;Int    k

dw_ip.AcceptText()

IF li_curpage = 1 THEN															/*반제대상*/
	if tab_banje.tabpage_sor.dw_sor.accepttext() = -1 then return

	if tab_banje.tabpage_sor.dw_sor.rowcount() > 0 then
		for k = 1 to tab_banje.tabpage_sor.dw_sor.rowcount()
			if wf_requiredchk(tab_banje.tabpage_sor.dw_sor.getrow()) = -1 then return
		next
	else
		return
	end if
	  
	if f_dbConFirm('저장') = 2 then return
	
	if tab_banje.tabpage_sor.dw_sor.update() > 0 then
		commit;
		ib_any_typing = false
		sle_msg.text = '자료를 저장하였습니다!!'
	else
		F_MessageChk(13,'')
		rollback;
		ib_any_typing = true
		return
	end if
	
	tab_banje.tabpage_sor.dw_sor.scrolltorow(tab_banje.tabpage_sor.dw_sor.getrow())
	
ELSE
	if tab_banje.tabpage_des.dw_des.accepttext() = -1 then return
	if tab_banje.tabpage_des.dw_des.rowcount() <= 0 then Return
	  
	if f_dbConFirm('저장') = 2 then return
	
	if tab_banje.tabpage_des.dw_des.update() > 0 then
		commit;
		ib_any_typing = false
		sle_msg.text = '자료를 저장하였습니다!!'
	else
		F_MessageChk(13,'')
		rollback;
		ib_any_typing = true
		return
	end if
	
	tab_banje.tabpage_des.dw_des.scrolltorow(tab_banje.tabpage_des.dw_des.getrow())
	
END IF

end event

type cb_ins from w_inherite`cb_ins within w_kgla10
boolean visible = false
integer x = 466
integer y = 2900
integer taborder = 40
string text = "추가(&A)"
end type

event cb_ins::clicked;call super::clicked;string s_date, s_saupj, snull
int    il_currow, iRtnValue, l_jun_no, l_lin_no,ll_findrow
long   k, sRow

setnull(snull)

if tab_banje.tabpage_sor.dw_sor.rowcount() > 0 then
	iRtnValue = wf_requiredchk(tab_banje.tabpage_sor.dw_sor.getrow())
	IF iRtnValue = -1 THEN Return
else
	iRtnValue = 1
end if

if iRtnValue = 1 then
	il_currow = tab_banje.tabpage_sor.dw_sor.insertrow(0)
	
	tab_banje.tabpage_sor.dw_sor.SetItem(il_currow, "saupj",    dw_ip.GetItemString(dw_ip.GetRow(),"saupj"))	
	tab_banje.tabpage_sor.dw_sor.SetItem(il_currow, "acc_date", f_today())
	tab_banje.tabpage_sor.dw_sor.SetItem(il_currow, "bal_date", f_today())
	
	tab_banje.tabpage_sor.dw_sor.scrolltorow(il_currow)
end if

tab_banje.tabpage_sor.dw_sor.setcolumn("saupj")
tab_banje.tabpage_sor.dw_sor.setfocus()	
ib_any_typing = true
end event

type cb_del from w_inherite`cb_del within w_kgla10
boolean visible = false
integer x = 2912
integer y = 2900
integer taborder = 60
end type

event cb_del::clicked;call super::clicked;int row ,iCurRow

dw_ip.AcceptText()

IF li_curpage = 1 THEN													/*반제대상*/
	iCurRow = tab_banje.tabpage_sor.dw_sor.GetRow()

	IF iCurRow <=0 THEN Return
	
	IF Messagebox("삭 제 ","삭제하시겠습니까?", question!, yesno!) = 2 then Return
	
	tab_banje.tabpage_sor.dw_sor.DeleteRow(row)
	If tab_banje.tabpage_sor.dw_sor.Update() = 1 Then
		Commit;
		ib_any_typing = false
		sle_msg.text ="자료를 삭제하였습니다!!"
		
	Else
		F_MessageChk(12,'')
		rollback;
		ib_any_typing = true
		return
	End If

ELSE																		/*반제결과*/
	iCurRow = tab_banje.tabpage_des.dw_des.GetRow()
	IF iCurRow <=0 THEN Return
	
	IF Messagebox("삭 제 ","삭제하시겠습니까?", question!, yesno!) = 2 then Return
	
	tab_banje.tabpage_des.dw_des.DeleteRow(row)
	If tab_banje.tabpage_des.dw_des.Update() = 1 Then
		Commit;
		ib_any_typing = false
		sle_msg.text ="자료를 삭제하였습니다!!"
	Else
		F_MessageChk(12,'')
		rollback;
		ib_any_typing = true
		return
	End If
END IF


end event

type cb_inq from w_inherite`cb_inq within w_kgla10
boolean visible = false
integer x = 110
integer y = 2900
integer taborder = 30
end type

event cb_inq::clicked;call super::clicked;string sSaupj,sFrom,sTo, s_acc1,s_acc2, sAcc, s_saup, s_saupnm,sCrossGu

dw_ip.accepttext()
sSaupj   = dw_ip.getitemstring(1,"saupj")
sFrom    = Trim(dw_ip.getitemstring(1,"sfrom"))
sTo      = Trim(dw_ip.getitemstring(1,"sto"))
s_acc1   = dw_ip.getitemstring(1,"acc1_cd")
s_acc2   = dw_ip.getitemstring(1,"acc2_cd")
s_saup   = dw_ip.getitemstring(1,"saup_no")
s_saupnm = dw_ip.getitemstring(1,"person_nm")

sCrossGu = dw_ip.getitemstring(1,"crossgbn")

IF sSaupj = "" OR IsNull(sSaupj) THEN
	F_MessageChk(1,'[사업장]')
	dw_ip.SetColumn("saupj")
	dw_ip.SetFocus()
	Return
END IF

IF sFrom = "" OR IsNull(sFrom) THEN
	F_MessageChk(1,'[회계일자]')
	dw_ip.SetColumn("sfrom")
	dw_ip.SetFocus()
	Return
END IF
IF sTo = "" OR IsNull(sTo) THEN
	F_MessageChk(1,'[회계일자]')
	dw_ip.SetColumn("sto")
	dw_ip.SetFocus()
	Return
END IF

if s_acc1 = "" or isnull(s_acc1) or s_acc2 = ""  or isnull(s_acc2) then 
	sAcc = '%'
else
	sAcc = s_acc1 + s_acc2
end if

if s_saup = "" or isnull(s_saup) then s_saup = '%'

IF tab_banje.tabpage_sor.dw_sor.retrieve(sSaupj,sFrom,sTo,sAcc,s_saup,sCrossGu) <= 0 THEN
	F_MessageChk(14,'[반제대상]')
	dw_ip.setfocus()
	Return
END IF
tab_banje.SelectedTab = 1
li_curpage = 1

tab_banje.tabpage_sor.dw_sor.setfocus()

end event

type cb_print from w_inherite`cb_print within w_kgla10
integer x = 1093
integer y = 2384
end type

type st_1 from w_inherite`st_1 within w_kgla10
end type

type cb_can from w_inherite`cb_can within w_kgla10
boolean visible = false
integer x = 2866
integer y = 2528
end type

event cb_can::clicked;call super::clicked;//dw_1.reset()
////dw_1.insertrow(0)
////dw_1.SetItem(1, "date", f_today())
////dw_1.setfocus()
//
//dw_ip.reset()
//dw_ip.insertrow(0)
//
//dw_2.reset()
//
//cb_ins.Enabled = True
//
//ib_any_typing = False
//
end event

type cb_search from w_inherite`cb_search within w_kgla10
integer x = 613
integer y = 2384
end type







type gb_button1 from w_inherite`gb_button1 within w_kgla10
boolean visible = false
integer x = 73
integer y = 2856
integer width = 759
integer height = 172
end type

type gb_button2 from w_inherite`gb_button2 within w_kgla10
boolean visible = false
integer x = 2528
integer y = 2856
integer width = 1102
integer height = 172
end type

type dw_ip from datawindow within w_kgla10
event ue_key pbm_dwnkey
event ue_enterkey pbm_dwnprocessenter
integer x = 41
integer width = 3538
integer height = 288
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_kgla101"
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) or keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_enterkey;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;string  into_code, sCustCode,sCustName, sCustNm, snull, sacc1_cd, sacc2_cd,sDate

SetNull(snull)

this.AcceptText()

IF this.GetColumnName() = "sfrom" THEN
	sDate = Trim(this.GetText())
	IF sDate = "" OR IsNull(sDate) THEN Return
	
	IF F_DateChk(sDate) = -1 THEN
		F_MessageChk(21,'[일자]')
		this.setitem(1, "sfrom", sNull)
		this.setfocus()
		return 1
	END IF
END IF

IF this.GetColumnName() = "sto" THEN
	sDate = Trim(this.GetText())
	IF sDate = "" OR IsNull(sDate) THEN Return
	
	IF F_DateChk(sDate) = -1 THEN
		F_MessageChk(21,'[일자]')
		this.setitem(1, "sto", sNull)
		this.setfocus()
		return 1
	END IF
END IF

IF this.GetColumnName() = "acc1_cd" THEN
	sAcc1_Cd = this.GetText()
 	sAcc2_Cd = this.getitemstring(1,"acc2_cd")
	 
	IF sAcc1_Cd = "" OR IsNull(sAcc1_Cd) THEN
		this.SetItem(1,"acc2_cd",snull)
		this.SetItem(1,"acc2_nm",snull)
		SetNull(lstr_account.Gbn1)
		Return 
	END IF

   if sAcc2_Cd = "" OR IsNull(sAcc2_Cd) THEN 
		return 
   else
		SELECT "KFZ01OM0"."ACC2_NM" , "KFZ01OM0"."GBN1"
			INTO :into_code, 				:lstr_account.Gbn1 
		  	FROM "KFZ01OM0"
		 	WHERE "KFZ01OM0"."ACC1_CD" = :sAcc1_Cd and "KFZ01OM0"."ACC2_CD" = :sAcc2_Cd ;
		IF SQLCA.SQLCODE = 0 THEN
			this.setitem(1,"acc2_nm",into_code)
		ELSE
//			F_MessageChk(16,'[계정과목]')
			this.SetItem(1,"acc1_cd",snull)
			this.SetItem(1,"acc2_cd",snull)
			this.setitem(1,"acc2_nm",snull)
			SetNull(lstr_account.Gbn1)
			RETURN 
		END IF
	end if
END IF

IF this.GetColumnName() = "acc2_cd" THEN
	sAcc2_Cd = this.GetText()
 	sAcc1_Cd = this.getitemstring(1,"acc1_cd")
	
	IF sAcc2_Cd = "" OR IsNull(sAcc2_Cd) THEN
		this.SetItem(1,"acc1_cd",snull)
		this.SetItem(1,"acc2_nm",snull)
		SetNull(lstr_account.Gbn1)
		Return
	END IF
	
	IF sAcc1_Cd = "" OR IsNull(sAcc1_Cd) THEN
		return
	else
		SELECT "KFZ01OM0"."ACC2_NM",  "KFZ01OM0"."GBN1"
			INTO :into_code, 				:lstr_account.Gbn1
		  	FROM "KFZ01OM0"
		 	WHERE "KFZ01OM0"."ACC1_CD" = :sAcc1_Cd and "KFZ01OM0"."ACC2_CD" = :sAcc2_Cd ;
		IF SQLCA.SQLCODE = 0 THEN
			this.setitem(1,"acc2_nm",into_code)
		ELSE
//			F_MessageChk(16,'[계정과목]')
			this.SetItem(1,"acc1_cd",snull)
			this.SetItem(1,"acc2_cd",snull)
			this.setitem(1,"acc2_nm",snull)
			SetNull(lstr_account.Gbn1)
			RETURN 
		END IF
	end if
END IF

IF this.GetColumnName() = "saup_no" THEN
	sCustCode = this.GetText()
	IF sCustCode = "" OR IsNull(sCustCode) THEN 
		this.SetItem(1,"person_nm",snull)
		Return
	END IF
	
	IF lstr_account.Gbn1 = "" OR IsNull(lstr_account.Gbn1) THEN lstr_account.Gbn1 = '%'
	
	SELECT "KFZ04OM0"."PERSON_NM"		INTO :sCustNm  
	   FROM "KFZ04OM0"  
   	WHERE "KFZ04OM0"."PERSON_CD" = :sCustCode and "KFZ04OM0"."PERSON_GU" like :lstr_account.Gbn1 ;
	IF SQLCA.SQLCODE <> 0  THEN
//		F_MessageChk(20,'[거래처코드]')
		this.SetItem(1,"saup_no",snull)
		this.SetItem(1,"person_nm",snull)
		Return 
	ELSE
		this.SetItem(1,"person_nm",sCustNm)
	END IF
END IF

//IF this.GetColumnName() = "person_nm" THEN
//	sCustName = this.GetText()
//	IF sCustName = "" OR IsNull(sCustName) THEN 
//		this.SetItem(1,"saup_no",snull)
//		Return
//	END IF
//	
//	IF lstr_account.Gbn1 = "" OR IsNull(lstr_account.Gbn1) THEN lstr_account.Gbn1 = '%'
//	
//	SELECT "KFZ04OM0"."PERSON_CD"	  INTO :sCustCode  
//	   FROM "KFZ04OM0"  
//   	WHERE "KFZ04OM0"."PERSON_NM" = :sCustName  AND "KFZ04OM0"."PERSON_GU" like :lstr_account.Gbn1 ;
//
//	IF SQLCA.SQLCODE <> 0  THEN
//		F_MessageChk(20,'[거래처명]')
//		this.SetItem(1,"saup_no",snull)
//		this.SetItem(1,"person_nm",snull)
//      this.setcolumn("person_nm")
//		this.setfocus()
//		Return 1
//	ELSE
//		this.SetItem(1,"saup_no",sCustCode)
//	END IF
//END IF



end event

event itemerror;return 1
end event

event rbuttondown;String sDcGbn, snull

SetNull(snull)

this.AcceptText()

//++ 계정과목 +++++++++++++++++++++++++++++++++++++++++++++++++++
IF this.GetColumnName() = "acc1_cd" THEN
	
	SetNull(lstr_account.acc1_cd)
	SetNull(lstr_account.acc2_cd)

	lstr_account.acc1_cd = this.GetItemString(this.GetRow(),"acc1_cd")
	lstr_account.acc2_cd = this.GetItemString(this.GetRow(),"acc2_cd")
	
	IF IsNull(lstr_account.acc1_cd) THEN lstr_account.acc1_cd = ''
	IF IsNull(lstr_account.acc2_cd) THEN lstr_account.acc2_cd = ''
	
	Open(W_Kfz01om0_PopUp)
	
	IF IsNull(lstr_account.acc1_cd) THEN Return
	
	this.SetItem(this.GetRow(),"acc1_cd",lstr_account.acc1_cd)
	this.SetItem(this.GetRow(),"acc2_cd",lstr_account.acc2_cd)
	this.SetItem(this.GetRow(),"acc2_nm",lstr_account.acc2_nm)
	
//	this.TriggerEvent(ItemChanged!)
ELSEIF this.GetColumnName() = "saup_no" THEN
	SetNull(lstr_custom.code)
	SetNull(lstr_custom.name)

	lstr_custom.code = Trim(this.GetItemString(this.GetRow(),"saup_no"))
	
	IF IsNull(lstr_custom.code) THEN
		lstr_custom.code = ""
	END IF

	IF IsNull(lstr_custom.name) THEN
		lstr_custom.name = ""
	END IF
	
	IF lstr_account.gbn1 = '' OR IsNull(lstr_account.gbn1) THEN
		lstr_account.gbn1 = '%'
	end if
	
	OpenWithParm(W_KFZ04OM0_POPUP,lstr_account.Gbn1)
	
	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
	
	this.SetItem(this.GetRow(),"saup_no",lstr_custom.code)
	this.SetItem(this.GetRow(),"person_nm",lstr_custom.name)
//	this.TriggerEvent(ItemChanged!)
END IF

ib_any_typing = True
end event

event getfocus;this.AcceptText()
end event

type tab_banje from tab within w_kgla10
integer x = 37
integer y = 296
integer width = 4567
integer height = 1936
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean raggedright = true
boolean boldselectedtext = true
integer selectedtab = 1
tabpage_sor tabpage_sor
tabpage_des tabpage_des
end type

on tab_banje.create
this.tabpage_sor=create tabpage_sor
this.tabpage_des=create tabpage_des
this.Control[]={this.tabpage_sor,&
this.tabpage_des}
end on

on tab_banje.destroy
destroy(this.tabpage_sor)
destroy(this.tabpage_des)
end on

event selectionchanging;Integer iCurRow
String  sSaupj,sFrom,sTo,sAcc,sCrossGu,s_Saup

IF oldindex = 1 AND newindex = 2  THEN
	iCurRow = tab_banje.tabpage_sor.dw_sor.GetRow()
	IF iCurRow <=0 THEN Return 1
	
	IF Wf_Retrieve(tab_banje.tabpage_sor.dw_sor.GetItemString(iCurRow,"saupj"),&
						tab_banje.tabpage_sor.dw_sor.GetItemString(iCurRow,"acc_date"),&
						tab_banje.tabpage_sor.dw_sor.GetItemString(iCurRow,"upmu_gu"),&
						tab_banje.tabpage_sor.dw_sor.GetItemNumber(iCurRow,"jun_no"),&
						tab_banje.tabpage_sor.dw_sor.GetItemNumber(iCurRow,"lin_no"),&
						tab_banje.tabpage_sor.dw_sor.GetItemString(iCurRow,"bal_date"),&
						tab_banje.tabpage_sor.dw_sor.GetItemNumber(iCurRow,"bjun_no")) = -1 THEN Return 1
						
	cb_ins.Enabled = False
	cb_inq.Enabled = False
END IF

IF oldindex = 2 AND newindex = 1  THEN
	cb_ins.Enabled = True
	cb_inq.Enabled = True
	
	sSaupj = dw_ip.getitemstring(1,"saupj")
	sFrom  = Trim(dw_ip.getitemstring(1,"sfrom"))
	sTo    = Trim(dw_ip.getitemstring(1,"sto"))
	
	sCrossGu = dw_ip.getitemstring(1,"crossgbn")

	if dw_ip.getitemstring(1,"acc1_cd") = "" or isnull(dw_ip.getitemstring(1,"acc1_cd")) or &
		dw_ip.getitemstring(1,"acc2_cd") = ""  or isnull(dw_ip.getitemstring(1,"acc2_cd")) then 
		sAcc = '%'
	else
		sAcc = dw_ip.getitemstring(1,"acc1_cd") + dw_ip.getitemstring(1,"acc2_cd")
	end if
	
	if dw_ip.getitemstring(1,"saup_no") = "" or isnull(dw_ip.getitemstring(1,"saup_no")) then s_saup = '%'

	tab_banje.tabpage_sor.dw_sor.retrieve(sSaupj,sFrom,sTo,sAcc,s_saup,sCrossGu)
END IF

li_curpage = newindex

end event

type tabpage_sor from userobject within tab_banje
event create ( )
event destroy ( )
integer x = 18
integer y = 96
integer width = 4530
integer height = 1824
long backcolor = 32106727
string text = "반제대상"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_1 rr_1
dw_sor dw_sor
end type

on tabpage_sor.create
this.rr_1=create rr_1
this.dw_sor=create dw_sor
this.Control[]={this.rr_1,&
this.dw_sor}
end on

on tabpage_sor.destroy
destroy(this.rr_1)
destroy(this.dw_sor)
end on

type rr_1 from roundrectangle within tabpage_sor
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 5
integer y = 12
integer width = 4521
integer height = 1920
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_sor from u_key_enter within tabpage_sor
event ue_key pbm_dwnkey
integer x = 14
integer y = 20
integer width = 4498
integer height = 1796
integer taborder = 30
boolean bringtotop = true
string dataobject = "dw_kgla102"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event ue_key;IF keydown(keyF1!) or keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event getfocus;this.AcceptText()
end event

event itemchanged;String  snull, sCustCode, sSaupj, sAcc1_Cd, sAcc2_Cd, into_acc1_cd, sCustName,ssDeptCode
string  into_name, into_bal_gu
Integer iCurRow,lnull

SetNull(snull)
SetNull(lNull)

iCurRow = this.GetRow()

this.AcceptText()

IF this.GetColumnName() = "saupj" THEN
	sSaupj = this.GetText()
	IF sSaupj = "" OR IsNull(sSaupj) THEN RETURN
	
	IF IsNull(F_Get_Refferance('AD',sSaupj)) THEN
		F_MessageChk(20,'[사업장]')
		this.SetItem(iCurRow,"saupj",sNull)
		Return 1
	ELSE
		IF Wf_Dup_Chk(iCurRow,&
						  sSaupj, &
						  this.GetItemString(iCurRow,"acc_date"),&
						  this.GetItemString(iCurRow,"upmu_gu"), &
						  String(this.GetItemNumber(iCurRow,"jun_no")),  &
						  String(this.GetItemNumber(iCurRow,"lin_no")),  &
						  this.GetItemString(iCurRow,"bal_date"),&
						  String(this.GetItemNumber(iCurRow,"bjun_no"))) = -1 THEN 
			F_MessageChk(10,'')
			this.SetItem(iCurRow,"saupj",sNull)
			Return 1
		END IF		  
	END IF
END IF

IF	this.getcolumnname() = "bal_date" THEN
	IF f_datechk(trim(this.gettext())) = -1 then
		F_MessageChk(21,'[작성일자]')
		this.setitem(iCurRow, "bal_date", sNull)
		this.setfocus()
		return 1
	ELSE
		IF Wf_Dup_Chk(iCurRow,&
						  this.GetItemString(iCurRow,"saupj"),   &
						  this.GetItemString(iCurRow,"acc_date"),&
						  this.GetItemString(iCurRow,"upmu_gu"), &
						  String(this.GetItemNumber(iCurRow,"jun_no")),  &
						  String(this.GetItemNumber(iCurRow,"lin_no")),  &
						  Trim(this.GetText()),                  &
						  String(this.GetItemNumber(iCurRow,"bjun_no"))) = -1 THEN 
			F_MessageChk(10,'')
			this.SetItem(iCurRow,"bal_date",sNull)
			Return 1
		END IF		  
	END IF
end if

IF	this.getcolumnname() = "acc_date" THEN
	IF f_datechk(trim(this.gettext())) = -1 then
		F_MessageChk(21,'[회계일자]')
		this.setitem(iCurRow, "acc_date", sNull)
		this.setfocus()
		return 1
	ELSE
		IF Wf_Dup_Chk(iCurRow,&
						  this.GetItemString(iCurRow,"saupj"),   &
						  Trim(this.GetText()),                  &
						  this.GetItemString(iCurRow,"upmu_gu"), &
						  String(this.GetItemNumber(iCurRow,"jun_no")),  &
						  String(this.GetItemNumber(iCurRow,"lin_no")),  &
						  this.GetItemString(iCurRow,"bal_date"),&
						  String(this.GetItemNumber(iCurRow,"bjun_no"))) = -1 THEN 
			F_MessageChk(10,'')
			this.SetItem(iCurRow,"acc_date",sNull)
			Return 1
		END IF		  
	END IF
end if

IF	this.getcolumnname() = "jun_no" THEN
	IF this.GetText() = "" OR IsNull(this.GetText()) THEN Return
	
	this.SetItem(iCurRow,"bjun_no",Long(this.GetText()))
	
	IF Wf_Dup_Chk(iCurRow,&
					  this.GetItemString(iCurRow,"saupj"),   &
					  this.GetItemString(iCurRow,"acc_date"),&
					  this.GetItemString(iCurRow,"upmu_gu"), &
					  this.GetText(),				   			  &
					  String(this.GetItemNumber(iCurRow,"lin_no")),  &
					  this.GetItemString(iCurRow,"bal_date"),&
					  String(this.GetItemNumber(iCurRow,"bjun_no"))) = -1 THEN 
		F_MessageChk(10,'')
		this.SetItem(iCurRow,"jun_no",lNull)
		Return 1
	END IF		  
end if

IF	this.getcolumnname() = "lin_no" THEN
	IF this.GetText() = "" OR IsNull(this.GetText()) THEN Return
	
	IF Wf_Dup_Chk(iCurRow,&
					  this.GetItemString(iCurRow,"saupj"),   &
					  this.GetItemString(iCurRow,"acc_date"),&
					  this.GetItemString(iCurRow,"upmu_gu"), &
					  String(this.GetItemNumber(iCurRow,"jun_no")),  &
					  this.GetText(),								  &
					  this.GetItemString(iCurRow,"bal_date"),&
					  String(this.GetItemNumber(iCurRow,"bjun_no"))) = -1 THEN 
		F_MessageChk(10,'')
		this.SetItem(iCurRow,"lin_no",lNull)
		Return 1
	END IF		  
end if

IF this.GetColumnName() = "acc1_cd" THEN
	sAcc1_Cd = this.GetText()
 	sAcc2_Cd = this.getitemstring(iCurRow,"acc2_cd")
	 
	IF sAcc1_Cd = "" OR IsNull(sAcc1_Cd) THEN	Return 
	IF sAcc2_Cd = "" OR IsNull(sAcc2_Cd) THEN	Return 
  	
  SELECT "KFZ01OM0"."ACC2_NM",     //계정과목명
         "KFZ01OM0"."CUS_GU",      //거래처구분
         "KFZ01OM0"."GBN1",        //인명거래처구분
         "KFZ01OM0"."BAL_GU"       //전표발행구분
    INTO :into_name,   
         :into_cus_gu,   
         :lstr_account.gbn1,   
         :into_bal_gu  
    FROM "KFZ01OM0"  
   WHERE "KFZ01OM0"."ACC1_CD" = :sAcc1_Cd AND
    	   "KFZ01OM0"."ACC2_CD" = :sAcc2_Cd ;

	if sqlca.sqlcode = 0 then
		if into_bal_gu = '4' then      //전표발행구분이 '4'이면..
			F_MessageChk(16,'[전표발행 불가]')
	      this.setitem(iCurRow,"acc1_cd",snull)
	      this.setitem(iCurRow,"acc2_cd",snull)	
	      this.setitem(iCurRow,"acc2_nm",snull)
         this.setcolumn("acc1_cd")
			this.setfocus()
			return 1
		end if
		this.setitem(iCurRow,"acc2_nm",into_name)
	else
//     F_MessageChk(28,'[계정과목]')
	  this.setitem(iCurRow,"acc1_cd",snull)
	  this.setitem(iCurRow,"acc2_cd",snull)	
	  this.setitem(iCurRow,"acc2_nm",snull)
	  return 
   end if
end if	

IF this.GetColumnName() = "acc2_cd" THEN
  	sAcc1_Cd = this.getitemstring(iCurRow,"acc1_cd")
	sAcc2_Cd = this.GetText()
	 
	IF sAcc1_Cd = "" OR IsNull(sAcc1_Cd) THEN	return
	IF sAcc2_Cd = "" OR IsNull(sAcc2_Cd) THEN	Return 
		
  SELECT "KFZ01OM0"."ACC2_NM",   
         "KFZ01OM0"."CUS_GU",   
         "KFZ01OM0"."GBN1",   
         "KFZ01OM0"."BAL_GU"  
    INTO :into_name,   
         :into_cus_gu,   
         :lstr_account.gbn1,   
         :into_bal_gu  
    FROM "KFZ01OM0"  
   WHERE "KFZ01OM0"."ACC1_CD" = :sAcc1_Cd AND
    	   "KFZ01OM0"."ACC2_CD" = :sAcc2_Cd ;

	if sqlca.sqlcode = 0 then
		if into_bal_gu = '4' then
			F_MessageChk(16,'[전표발행 불가]')
	      this.setitem(iCurRow,"acc1_cd",snull)
	      this.setitem(iCurRow,"acc2_cd",snull)	
	      this.setitem(iCurRow,"acc2_nm",snull)
         this.setcolumn("acc1_cd")
			this.setfocus()
			return 1
		end if
		this.setitem(iCurRow,"acc2_nm",into_name)
	else
//     F_MessageChk(28,'[계정과목]')
	  this.setitem(iCurRow,"acc1_cd",snull)
	  this.setitem(iCurRow,"acc2_cd",snull)	
	  this.setitem(iCurRow,"acc2_nm",snull)
	  return 
   end if
end if	

IF this.GetColumnName() = "saup_no" THEN
	sCustCode = this.GetText()
	IF sCustCode = "" OR IsNull(sCustCode) THEN 
		this.SetItem(iCurRow,"person_nm",snull)
		Return 1
	END IF
	
//   if lstr_account.gbn1 = "" or isnull(lstr_account.gbn1) then
//		messagebox("확 인","[계정과목]을 입력한 후에 거래처를 선택하세요!!")
//		this.setitem(iCurRow,"saup_no",snull)
//		this.setcolumn("acc1_cd")
//		this.setfocus()
//	   return 1
//	else
		IF lstr_account.gbn1 = '' OR IsNull(lstr_account.gbn1) THEN lstr_account.gbn1 = '%'
		
		//인명구분코드(GBN1) = 인명구분(PERSON_GU)이면 입력가능하게
		SELECT "KFZ04OM0"."PERSON_NM"  
			INTO :into_acc1_cd
			FROM "KFZ04OM0"  
		  	WHERE "KFZ04OM0"."PERSON_GU" like :lstr_account.gbn1 and "KFZ04OM0"."PERSON_CD" = :sCustCode   ;   
	
		IF SQLCA.SQLCODE = 0 THEN
			this.SetItem(iCurRow,"person_nm",into_acc1_cd)
		ELSE
//			F_MessageChk(20,'[거래처코드]') 
			this.SetItem(iCurRow,"saup_no",snull)
			this.SetItem(iCurRow,"person_nm",snull)
			return
		END IF
//	end if
END IF

//IF this.GetColumnName() = "person_nm" THEN
//	sCustName = this.GetText()
//	IF sCustName = "" OR IsNull(sCustName) THEN 
//		this.SetItem(iCurRow,"saup_no",snull)
//		Return
//	END IF
//	
//	if lstr_account.gbn1 = "" or isnull(lstr_account.gbn1) then 
//		messagebox("확 인","[계정과목]을 입력한 후에 거래처를 선택하세요!!")
//		this.setitem(iCurRow,"person_nm",snull)
//		this.setcolumn("acc1_cd")
//		this.setfocus()
//		return 1    
//	else
//		IF lstr_account.gbn1 = '' OR IsNull(lstr_account.gbn1) THEN lstr_account.gbn1 = '%'
//		//거래처명을 직접입력시	
//		SELECT "KFZ04OM0"."PERSON_CD",				 "KFZ04OM0"."PERSON_NM"  
//		  INTO :sCustCode,								 :into_acc1_cd
//		  FROM "KFZ04OM0"  
//		 WHERE "KFZ04OM0"."PERSON_NM" = :sCustName and
//				 "KFZ04OM0"."PERSON_GU" like :lstr_account.gbn1 ;
//	
//		IF SQLCA.SQLCODE <> 0  THEN
//			F_MessageChk(20,'[거래처명]')
//			this.SetItem(iCurRow,"saup_no",snull)
//			this.SetItem(iCurRow,"person_nm",snull)
//			this.setcolumn("person_nm")
//			this.setfocus()
//			Return 1
//		ELSE
//			this.SetItem(iCurRow,"saup_no",sCustCode)
//			this.setcolumn("amt")
//			this.setfocus()
//		END IF
//	end if
//END IF

IF this.GetColumnName() = "sdept_cd" THEN
	sSdeptCode = this.GetText()	
	IF sSdeptCode = "" OR IsNull(sSdeptCode) THEN RETURN
	
	SELECT "VW_CDEPT_CODE"."COST_CD"  INTO :sSdeptCode  
		FROM "VW_CDEPT_CODE"  
		WHERE "VW_CDEPT_CODE"."COST_CD" = :sSdeptCode   ;
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[원가부문]')
		this.SetItem(iCurRow,"sdept_cd",snull)
		Return 1
	END IF
END IF

ib_any_typing = True
end event

event itemerror;Return 1
end event

event rbuttondown;String sDcGbn, snull

SetNull(snull)

this.AcceptText()

IF this.GetColumnName() = "acc1_cd" THEN
	
	SetNull(lstr_account.acc1_cd)
	SetNull(lstr_account.acc2_cd)

	lstr_account.acc1_cd = this.GetItemString(this.GetRow(),"acc1_cd")
	lstr_account.acc2_cd = this.GetItemString(this.GetRow(),"acc2_cd")
	
	IF IsNull(lstr_account.acc1_cd) THEN lstr_account.acc1_cd = ''
	IF IsNull(lstr_account.acc2_cd) THEN lstr_account.acc2_cd = ''
	
	Open(W_Kfz01om0_PopUp)
	
	IF IsNull(lstr_account.acc1_cd) THEN Return
	
	this.SetItem(this.GetRow(),"acc1_cd",lstr_account.acc1_cd)
	this.SetItem(this.GetRow(),"acc2_cd",lstr_account.acc2_cd)
	this.setcolumn("acc2_cd")
	this.TriggerEvent(ItemChanged!)

ELSEIF this.GetColumnName() = "saup_no" THEN
	SetNull(lstr_custom.code)
	SetNull(lstr_custom.name)

	lstr_custom.code = Trim(this.GetItemString(this.GetRow(),"saup_no"))
	
	IF IsNull(lstr_custom.code) THEN
		lstr_custom.code = ""
	END IF

	IF IsNull(lstr_custom.name) THEN
		lstr_custom.name = ""
	END IF
	
	IF lstr_account.gbn1 = '' OR IsNull(lstr_account.gbn1) THEN lstr_account.gbn1 = '%'
	
	OpenWithParm(W_KFZ04OM0_POPUP,lstr_account.Gbn1)
	
	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
	
	this.SetItem(this.GetRow(),"saup_no",lstr_custom.code)
	this.SetItem(this.GetRow(),"person_nm",lstr_custom.name)
	this.TriggerEvent(ItemChanged!)
END IF

ib_any_typing = True
end event

type tabpage_des from userobject within tab_banje
event create ( )
event destroy ( )
integer x = 18
integer y = 96
integer width = 4530
integer height = 1824
long backcolor = 32106727
string text = "반제결과"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_2 rr_2
dw_des dw_des
end type

on tabpage_des.create
this.rr_2=create rr_2
this.dw_des=create dw_des
this.Control[]={this.rr_2,&
this.dw_des}
end on

on tabpage_des.destroy
destroy(this.rr_2)
destroy(this.dw_des)
end on

type rr_2 from roundrectangle within tabpage_des
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 5
integer y = 12
integer width = 4521
integer height = 1800
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_des from u_key_enter within tabpage_des
integer x = 411
integer y = 40
integer width = 3520
integer height = 1768
integer taborder = 11
string dataobject = "dw_kgla103"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylelowered!
end type

