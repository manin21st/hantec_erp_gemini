$PBExportHeader$w_kcda09.srw
$PBExportComments$원가부문 등록
forward
global type w_kcda09 from w_inherite
end type
type cbx_1 from checkbox within w_kcda09
end type
type dw_2 from u_d_popup_sort within w_kcda09
end type
type dw_1 from u_key_enter within w_kcda09
end type
type gb_1 from groupbox within w_kcda09
end type
type rr_1 from roundrectangle within w_kcda09
end type
end forward

global type w_kcda09 from w_inherite
string title = "원가부문 등록"
cbx_1 cbx_1
dw_2 dw_2
dw_1 dw_1
gb_1 gb_1
rr_1 rr_1
end type
global w_kcda09 w_kcda09

type variables
w_preview  iw_preview

end variables

forward prototypes
public function integer wf_dup_chk (integer ll_row)
public function integer wf_requiredchk (integer irow)
end prototypes

public function integer wf_dup_chk (integer ll_row);String  sCostCd
Integer iReturnRow

dw_2.AcceptText()
sCostCd = dw_2.GetItemString(ll_row,"cost_cd")

IF sCostCd ="" OR IsNull(sCostCd) THEN RETURN 1

iReturnRow = dw_2.find("cost_cd ='" + sCostCd + "'", 1, dw_2.RowCount())

IF (ll_row <> iReturnRow) and (iReturnRow <> 0) THEN
	f_MessageChk(10,'[원가부문]')
	RETURN  -1
END IF
	
Return 1
end function

public function integer wf_requiredchk (integer irow);String   sCode,sName,sDeptCode,sBuMun,sCoSaupj
Integer  iCostYesCnt = 0

sCode     = dw_2.GetItemString(iRow,"cost_cd")
sName     = dw_2.GetItemString(iRow,"cost_nm")
sDeptCode = dw_2.GetItemString(iRow,"dept_cd")
sBuMun    = dw_2.GetItemString(iRow,"cost_gu2")
sCoSaupj  = dw_2.GetItemString(iRow,"cia02m_cost_guc")

IF sCode = '' OR ISNULL(sCode) THEN
   f_messagechk(1,'[원가부문]')	
	dw_2.SetColumn("cost_cd")
	dw_2.SetFocus()
	Return -1
END IF	

IF sName = '' OR ISNULL(sName) THEN
   f_messagechk(1,'[원가부문명]')	
	dw_2.SetColumn("cost_nm")
	dw_2.SetFocus()
	Return -1
END IF	

IF sBuMun = '' OR ISNULL(sBuMun) THEN
   f_messagechk(1,'[부문구분]')	
	dw_2.SetColumn("cost_gu2")
	dw_2.SetFocus()
	Return -1
END IF

//IF sDeptCode = '' OR ISNULL(sDeptCode) THEN
//   f_messagechk(1,'[관련부서]')	
//	dw_2.SetColumn("dept_cd")
//	dw_2.SetFocus()
//	Return -1
//END IF

IF dw_2.GetItemString(iRow,"cost_gu3") = 'Y' THEN
	iCostYesCnt = iCostYesCnt + 1
END IF
IF dw_2.GetItemString(iRow,"cost_gu4") = 'Y' THEN
	iCostYesCnt = iCostYesCnt + 1
END IF
IF dw_2.GetItemString(iRow,"cost_gu5") = 'Y' THEN
	iCostYesCnt = iCostYesCnt + 1
END IF
IF dw_2.GetItemString(iRow,"cost_gu6") = 'Y' THEN
	iCostYesCnt = iCostYesCnt + 1
END IF

IF iCostYesCnt = 0 THEN
	f_messagechk(1,'[부문여부]')	
	dw_2.SetColumn("cost_gu3")
	dw_2.SetFocus()
	Return -1
END IF

IF iCostYesCnt > 1 THEN
	f_messagechk(16,'[부문여부 한개 이상]')	
	dw_2.SetColumn("cost_gu3")
	dw_2.SetFocus()
	Return -1
END IF

IF sCoSaupj = '' OR ISNULL(sCoSaupj) THEN
   f_messagechk(1,'[원가사업부]')	
	dw_2.SetColumn("cia02m_cost_guc")
	dw_2.SetFocus()
	Return -1
END IF	

Return 1
end function

on w_kcda09.create
int iCurrent
call super::create
this.cbx_1=create cbx_1
this.dw_2=create dw_2
this.dw_1=create dw_1
this.gb_1=create gb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_1
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.gb_1
this.Control[iCurrent+5]=this.rr_1
end on

on w_kcda09.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_1)
destroy(this.dw_2)
destroy(this.dw_1)
destroy(this.gb_1)
destroy(this.rr_1)
end on

event open;call super::open;dw_1.SetTransObJect(sqlca)
dw_1.Reset()
dw_1.InsertRow(0)
dw_1.SetItem(1,"cost_saup",Gs_Saupj)

dw_2.SetTransObJect(sqlca)
if dw_2.Retrieve(Gs_Saupj,'C','%') > 0 then
	dw_2.Setcolumn("cost_nm")
	dw_2.SetFocus()
else
	cb_ins.SetFocus()
end if

ib_any_typing =False

open( iw_preview, this)
end event

type dw_insert from w_inherite`dw_insert within w_kcda09
boolean visible = false
integer x = 73
integer y = 2408
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kcda09
boolean visible = false
integer x = 4005
integer y = 2996
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kcda09
boolean visible = false
integer x = 3813
integer y = 2976
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kcda09
integer x = 3621
integer width = 306
integer taborder = 70
boolean originalsize = true
string picturename = "C:\Erpman\image\부서가져오기_up.gif"
end type

event p_search::clicked;call super::clicked;Integer iRowCount,iFindRow,iCurRow
String  sCode, sName,sSaup,sCoGbn

dw_1.AcceptText()

sSaup  = dw_1.GetItemString(1,"cost_saup")
sCoGbn = dw_1.GetItemString(1,"cost_gbn")

iRowCount = dw_2.RowCount()

declare cur_dept cursor for
	select deptcode, deptname
		from p0_dept
		where establishmentcode = :sSaup and sitetag like decode(:sCoGbn,'C','1','M','2','%') 
				and usetag = '1' ;
		
open cur_dept;
do while true
	fetch cur_dept into :sCode, :sName;
	if sqlca.sqlcode <> 0 then exit
	
	iFindRow = dw_2.Find("cost_cd = '"+sCode+"'",1,iRowCount)
	if iFindRow <= 0 then
		iCurRow = dw_2.InsertRow(0)
		
		dw_2.SetItem(iCurRow,"cost_cd",   sCode)
		dw_2.SetItem(iCurRow,"cost_nm",   sName)
		dw_2.SetItem(iCurRow,'cia02m_cost_guc', sSaup)
		dw_2.SetItem(iCurRow,'cost_gu2',        sCoGbn)
	else
		dw_2.SetItem(iFindRow,"cost_nm",  sName)
	end if
	
	ib_any_typing = True
loop
close cur_dept;

dw_2.SetSort("cost_cd A")
dw_2.Sort()


end event

event p_search::ue_lbuttondown;PictureName = "C:\Erpman\image\부서가져오기_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\Erpman\image\부서가져오기_up.gif"
end event

type p_ins from w_inherite`p_ins within w_kcda09
integer x = 3451
end type

event p_ins::clicked;call super::clicked;Integer  iCurRow,iFunctionValue,iRowCount

w_mdi_frame.sle_msg.text =""

iRowCount = dw_2.RowCount()

IF iRowCount > 0 THEN
	iFunctionValue = Wf_RequiredChk(dw_2.GetRow())
	IF iFunctionValue <> 1 THEN RETURN
ELSE
	iFunctionValue = 1	
	
	iRowCount = 0
END IF

IF iFunctionValue = 1 THEN
	iCurRow = iRowCount + 1
	
	dw_2.InsertRow(iCurRow)

	dw_2.ScrollToRow(iCurRow)
	dw_2.SetItem(iCurRow,'sflag','I')
	dw_2.SetItem(iCurRow,'cia02m_cost_guc', dw_1.GetItemString(1,"cost_saup"))
	dw_2.SetItem(iCurRow,'cost_gu2',        dw_1.GetItemString(1,"cost_gbn"))
	dw_2.SetColumn("cost_cd")
	dw_2.SetFocus()
	
	ib_any_typing =False

END IF

IF dw_2.RowCount() <=0 THEN
	p_ins.Enabled = False
	p_ins.PictureName = "C:\erpman\image\추가_d.gif"
ELSE
	p_ins.Enabled = True
	p_ins.PictureName = "C:\erpman\image\추가_up.gif"
END IF

dw_2.Object.DataWindow.HorizontalScrollPosition = 0

end event

type p_exit from w_inherite`p_exit within w_kcda09
integer taborder = 60
end type

type p_can from w_inherite`p_can within w_kcda09
integer taborder = 50
end type

event p_can::clicked;call super::clicked;
w_mdi_frame.sle_msg.text =""

dw_2.SetRedraw(False)
IF dw_2.Retrieve(dw_1.GetItemString(1,"cost_saup"),dw_1.GetItemString(1,"cost_gbn")) > 0 THEN
	dw_2.SetColumn("cost_nm")
	dw_2.SetFocus()
ELSE
	cb_ins.SetFocus()
END IF
dw_2.SetRedraw(True)

ib_any_typing =False

end event

type p_print from w_inherite`p_print within w_kcda09
boolean visible = false
integer x = 3950
integer y = 2772
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kcda09
boolean visible = false
integer x = 4160
integer y = 2792
integer taborder = 0
end type

type p_del from w_inherite`p_del within w_kcda09
integer taborder = 40
end type

event p_del::clicked;call super::clicked;Integer k

IF dw_2.GetRow() <= 0 THEN
	f_messagechk(11,'')
	Return
END IF

IF F_DbConFirm('삭제') = 2 THEN RETURN

dw_2.DeleteRow(dw_2.GetRow())
IF dw_2.Update() = 1 THEN
	commit;
	
	FOR k = 1 TO dw_2.RowCount()
		dw_2.SetItem(k,'sflag','M')
	NEXT
	
	dw_2.SetColumn("cost_nm")
	dw_2.SetFocus()
	
	ib_any_typing = False
	w_mdi_frame.sle_msg.text ="자료가 삭제되었습니다.!!!"
ELSE
	ROLLBACK;
	f_messagechk(12,'')
END IF

end event

type p_mod from w_inherite`p_mod within w_kcda09
integer taborder = 30
end type

event p_mod::clicked;call super::clicked;Integer k,iRtnValue

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

	dw_2.SetColumn("cost_nm")
	dw_2.SetFocus()
	
	ib_any_typing = False
	w_mdi_frame.sle_msg.text ="자료가 저장되었습니다.!!!"
ELSE
	ROLLBACK;
	f_messagechk(13,'')
END IF

IF dw_2.RowCount() <=0 THEN
	p_ins.Enabled = False
	p_ins.PictureName = "C:\erpman\image\추가_d.gif"
ELSE
	p_ins.Enabled = True
	p_ins.PictureName = "C:\erpman\image\추가_up.gif"
END IF


end event

type cb_exit from w_inherite`cb_exit within w_kcda09
boolean visible = false
integer x = 3163
integer y = 2740
end type

type cb_mod from w_inherite`cb_mod within w_kcda09
boolean visible = false
integer x = 2094
integer y = 2740
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

	dw_2.SetColumn("cost_nm")
	dw_2.SetFocus()
	
	ib_any_typing = False
	sle_msg.text ="자료가 저장되었습니다.!!!"
ELSE
	ROLLBACK;
	f_messagechk(13,'')
END IF

IF dw_2.RowCount() <=0 THEN
	cb_ins.Enabled = False
ELSE
	cb_ins.Enabled = True
END IF


end event

type cb_ins from w_inherite`cb_ins within w_kcda09
boolean visible = false
integer x = 114
integer y = 2872
string text = "추가(&I)"
end type

event cb_ins::clicked;call super::clicked;Integer  iCurRow,iFunctionValue,iRowCount

sle_msg.text =""

iRowCount = dw_2.RowCount()

IF iRowCount > 0 THEN
	iFunctionValue = Wf_RequiredChk(dw_2.GetRow())
	IF iFunctionValue <> 1 THEN RETURN
ELSE
	iFunctionValue = 1	
	
	iRowCount = 0
END IF

IF iFunctionValue = 1 THEN
	iCurRow = iRowCount + 1
	
	dw_2.InsertRow(iCurRow)

	dw_2.ScrollToRow(iCurRow)
	dw_2.SetItem(iCurRow,'sflag','I')
	dw_2.SetColumn("cost_cd")
	dw_2.SetFocus()
	
	ib_any_typing =False

END IF

IF dw_2.RowCount() <=0 THEN
	cb_ins.Enabled = False
ELSE
	cb_ins.Enabled = True
END IF

dw_2.Object.DataWindow.HorizontalScrollPosition = 0

end event

type cb_del from w_inherite`cb_del within w_kcda09
boolean visible = false
integer x = 2450
integer y = 2740
end type

event cb_del::clicked;call super::clicked;Integer k

IF dw_2.GetRow() <= 0 THEN
	f_messagechk(11,'')
	Return
END IF

IF F_DbConFirm('삭제') = 2 THEN RETURN

dw_2.DeleteRow(dw_2.GetRow())
IF dw_2.Update() = 1 THEN
	commit;
	
	FOR k = 1 TO dw_2.RowCount()
		dw_2.SetItem(k,'sflag','M')
	NEXT
	
	dw_2.SetColumn("cost_nm")
	dw_2.SetFocus()
	
	ib_any_typing = False
	sle_msg.text ="자료가 삭제되었습니다.!!!"
ELSE
	ROLLBACK;
	f_messagechk(12,'')
END IF

end event

type cb_inq from w_inherite`cb_inq within w_kcda09
boolean visible = false
integer x = 1294
integer y = 2760
end type

event cb_inq::clicked;call super::clicked;String sCode
Long ll_Row

dw_2.AcceptText()

sCode  = dw_2.GetItemString(1,"cost_cd")
ll_Row = dw_2.Retrieve(sCode)
IF ll_Row = 0 THEN
	dw_2.InsertRow(0)
END IF	
end event

type cb_print from w_inherite`cb_print within w_kcda09
boolean visible = false
integer x = 2194
integer y = 2760
end type

type st_1 from w_inherite`st_1 within w_kcda09
boolean visible = false
end type

type cb_can from w_inherite`cb_can within w_kcda09
boolean visible = false
integer x = 2807
end type

event cb_can::clicked;call super::clicked;
sle_msg.text =""

dw_2.SetRedraw(False)
IF dw_2.Retrieve() > 0 THEN
	dw_2.SetColumn("cost_nm")
	dw_2.SetFocus()
ELSE
	cb_ins.SetFocus()
END IF
dw_2.SetRedraw(True)

ib_any_typing =False

end event

type cb_search from w_inherite`cb_search within w_kcda09
boolean visible = false
integer x = 3547
integer y = 2824
integer width = 526
string text = "부서 가져오기"
end type

event cb_search::clicked;call super::clicked;Integer iRowCount,iFindRow,iCurRow
String  sCode, sName

iRowCount = dw_2.RowCount()

declare cur_dept cursor for
	select person_cd,	person_nm
		from kfz04om0
		where person_gu = '3' and person_sts = '1';
		
open cur_dept;
do while true
	fetch cur_dept into :sCode, :sName;
	if sqlca.sqlcode <> 0 then exit
	
	iFindRow = dw_2.Find("cost_cd = '"+sCode+"'",1,iRowCount)
	if iFindRow <= 0 then
		iCurRow = dw_2.InsertRow(0)
		
		dw_2.SetItem(iCurRow,"cost_cd",   sCode)
		dw_2.SetItem(iCurRow,"cost_nm",   sName)
	else
		dw_2.SetItem(iFindRow,"cost_nm",  sName)
	end if
	
	ib_any_typing = True
loop
close cur_dept;

dw_2.SetSort("cost_cd A")
dw_2.Sort()


end event

type dw_datetime from w_inherite`dw_datetime within w_kcda09
boolean visible = false
integer x = 2871
end type

type sle_msg from w_inherite`sle_msg within w_kcda09
boolean visible = false
integer width = 2487
end type

type gb_10 from w_inherite`gb_10 within w_kcda09
boolean visible = false
end type

type gb_button1 from w_inherite`gb_button1 within w_kcda09
boolean visible = false
integer x = 78
integer y = 2824
integer width = 407
integer height = 180
end type

type gb_button2 from w_inherite`gb_button2 within w_kcda09
boolean visible = false
integer x = 2053
integer y = 2692
integer height = 180
end type

type cbx_1 from checkbox within w_kcda09
integer x = 2770
integer y = 72
integer width = 645
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "원가부문 미리보기"
end type

event clicked;cbx_1.Checked = False

iw_preview.title = '원가부문 미리보기'
iw_preview.dw_preview.dataobject = 'dw_kcda09_2'
iw_preview.dw_preview.settransobject(sqlca)
iw_preview.dw_preview.modify( 'datawindow.print.preview=yes &
					datawindow.print.preview.zoom=100 datawindow.print.orientation=1 &
					datawindow.print.margin.left=100 datawindow.zoom=100' )

iw_preview.dw_preview.reset()	
IF iw_preview.dw_preview.retrieve(dw_1.GetItemString(1,"cost_saup"),dw_1.GetItemSTring(1,"usegbn")) <=0 THEN
	f_messagechk(14,'')
	iw_preview.Visible = False
	Return	
END IF
iw_preview.Visible =True
end event

type dw_2 from u_d_popup_sort within w_kcda09
event type integer ue_enter ( )
integer x = 64
integer y = 200
integer width = 4526
integer height = 2024
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_kcda09_1"
boolean vscrollbar = true
boolean border = false
end type

event ue_enter;Send(Handle(This),256,9,0)
Return 1
end event

event editchanged;call super::editchanged;ib_any_typing = True
end event

event itemchanged;call super::itemchanged;String  sCost_Cd,sAcc2Name,sAcc1,sDeptName,sDeptCd,sCostGbn
String  sCode1,sCode2,snull,sName
Long    ll_Row

SetNull(snull)

IF this.GetColumnName() = "cost_cd" THEN  /*원가부문 체크*/
	sCost_Cd = this.GetText() 
	if sCost_cd = '' OR IsNull(sCost_Cd) then Return
	
	IF Wf_Dup_Chk(this.GetRow()) = -1 THEN 
		this.SetItem(this.GetRow(),"cost_cd",snull)
		RETURN 1
	END IF
	
END IF
IF this.GetColumnName() = "ucost_cd" THEN  /*상위부문 체크*/
   sCost_Cd = this.GetText() 
   if sCost_Cd = '' or isnull(sCost_Cd) then Return

	select cost_nm into :sName	from cia02m where cost_cd = :sCost_Cd;
	if sqlca.sqlcode <> 0 then
		f_messagechk(20,'[상위부문]')
		THIS.SetITem(this.GetRow(),"ucost_cd",snull)
		Return 1
	END IF	
END IF

IF this.GetColumnName() = "dept_cd" THEN
	sDeptCd = this.GetText() 
	if sDeptCd  = '' or isnull(sDeptCd) then return
	
	select person_nm	into :sDeptName	from kfz04om0_v3	where person_cd = :sDeptCd;
   If Sqlca.Sqlcode <> 0 then
		f_messagechk(20,'[관련부서]')
		this.Setitem(this.getrow(),"dept_cd",snull)
		Return 1
	END IF	
END IF	

IF this.GetColumnName() = "cost_gu2" THEN         /*부문구분 체크*/         
   sCostGbn = this.GetText()
	IF sCostGbn  = '' OR ISNULL(sCostGbn)  THEN  RETURN
	
	select rfcod		into :sCostGbn	from reffpf where rfcod = 'C9' and rfgub = :sCostGbn;
   IF sqlca.sqlcode <> 0 THEN
		f_messageChk(20,'[부문구분]')
		this.Setitem(this.getrow(),"cost_gu2",snull)
		Return 1
	END IF	
END IF
   
IF this.GetColumnName() = "accode" THEN   /*회계계정 체크*/
   sAcc1 = this.GetText()
	IF sAcc1 = "" OR IsNull(sAcc1) THEN RETURN
	
	sCode1 = Left(sAcc1,5)  
	sCode2 = Right(sAcc1,2)  
	
	select acc2_nm into :sAcc2Name from kfz01om0 where acc1_cd = :sCode1 and acc2_cd = :sCode2 and bal_gu <> '4';
	If Sqlca.Sqlcode = 0 then
		this.Setitem(this.getrow(),"kfz01om0_acc2_nm",sAcc2Name)
	else
		f_messageChk(20,'[회계계정]')
		this.Setitem(this.getrow(),"accode",snull)
		this.Setitem(this.getrow(),"kfz01om0_acc2_nm",sNull)
		Return 1
	end if
END IF

String sCode

IF This.GetColumnName() = "cia02m_cost_gua" THEN  /*생산사업부 체크*/
   sCostGbn = this.GetText()
	IF sCostGbn = '' OR ISNULL(sCostGbn) THEN RETURN
	
	select rfcod into :sCostGbn from reffpf where 
		sabu = '1' and rfcod = 'C7' and rfgub = :sCostGbn;
  IF sqlca.sqlcode <> 0 THEN
	  f_messageChk(20,'[생산사업부]')
	  this.Setitem(this.getrow(),"cia02m_cost_gua",snull)
	  Return 1
  END IF	
END IF

IF This.GetColumnName() = "cia02m_cost_gub" THEN  /*손익사업부 체크*/
	sCostGbn = this.GetText()
	IF sCostGbn = '' OR ISNULL(sCostGbn) THEN RETURN
	
	select cost_cd	into :sCost_Cd from cia02m where cost_gu2 = 'P' and cost_cd = :sCostGbn;
  IF sqlca.sqlcode <> 0 THEN
	  f_messageChk(20,'[손익사업부]')
	  this.Setitem(this.getrow(),"cia02m_cost_gub",snull)
	  Return 1
  END IF	
END IF	
end event

event itemerror;call super::itemerror;Return 1
end event

event rbuttondown;call super::rbuttondown;
IF this.GetColumnName() = "accode" THEN
	lstr_account.acc1_cd = Left(this.GetItemString(THIS.GetRow(), "accode"),1)
	
	IF IsNull(lstr_account.acc1_cd) then
		lstr_account.acc1_cd = ""
	end if
	IF IsNull(lstr_account.acc2_cd) then
		lstr_account.acc2_cd = ""
	end if
	
	Open(W_KFZ01OM0_POPUP)

	IF IsNull(lstr_account.acc1_cd) OR lstr_account.acc1_cd = "" THEN Return
	
	THIS.SetItem(THIS.GetRow(), "accode", lstr_account.acc1_cd+lstr_account.acc2_cd )
	THIS.SetItem(THIS.GetRow(), "kfz01om0_acc2_nm", lstr_account.acc2_nm)
END IF
end event

event retrieverow;call super::retrieverow;IF row > 0 THEN
	this.SetItem(row,'sflag','M')
END IF
end event

type dw_1 from u_key_enter within w_kcda09
integer x = 46
integer y = 24
integer width = 2514
integer height = 152
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_kcda09_0"
boolean border = false
end type

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;call super::itemchanged;

if dwo.name = 'cost_saup' then
	dw_2.Retrieve(data,this.GetItemString(1,"cost_gbn"),this.GetItemString(1,"usegbn"))
end if

if dwo.name = 'cost_gbn' then
	IF data = 'C' then
		dw_2.Object.cost_gua_t.text = '생산사업부'
	else
		dw_2.Object.cost_gua_t.text = '손익사업부'
	end if
	
	dw_2.Retrieve(this.GetItemString(1,"cost_saup"),data,this.GetItemString(1,"usegbn"))
end if

if dwo.name = 'usegbn' then
	dw_2.Retrieve(this.GetItemString(1,"cost_saup"),this.GetItemString(1,"cost_gbn"),data)
end if
end event

type gb_1 from groupbox within w_kcda09
integer x = 2720
integer y = 20
integer width = 709
integer height = 152
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
end type

type rr_1 from roundrectangle within w_kcda09
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 192
integer width = 4558
integer height = 2048
integer cornerheight = 40
integer cornerwidth = 46
end type

