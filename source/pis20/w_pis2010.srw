$PBExportHeader$w_pis2010.srw
$PBExportComments$대출 신청등록
forward
global type w_pis2010 from w_inherite_standard
end type
type dw_main from datawindow within w_pis2010
end type
type dw_ip from datawindow within w_pis2010
end type
type rr_1 from roundrectangle within w_pis2010
end type
type rr_2 from roundrectangle within w_pis2010
end type
type dw_list from u_d_popup_sort within w_pis2010
end type
end forward

global type w_pis2010 from w_inherite_standard
string title = "대출 신청 등록"
dw_main dw_main
dw_ip dw_ip
rr_1 rr_1
rr_2 rr_2
dw_list dw_list
end type
global w_pis2010 w_pis2010

type variables
Long il_selectrow
Boolean ib_isShift
Boolean Lb_AutoFlag = True
end variables

forward prototypes
public function integer wf_requiredchk (integer icurrow)
public function integer wf_delete_chk (integer icurrow)
public subroutine wf_init ()
public subroutine wf_setting_retrievemode (string mode)
end prototypes

public function integer wf_requiredchk (integer icurrow);decimal ld_limitamt, ld_rate, ld_lendamt, ld_lendsum, ld_sangsum, ld_yearcnt, ld_lendmamt
integer i
string ls_gubun, ls_empno, ls_lenddate, ls_retdate, ls_lendfrom, ls_lendgbn, ls_lendgbn2, snull

SetNull(snull)


	if dw_main.accepttext() = -1 then return -1 

   ls_empno = dw_main.GetItemString(icurrow, 'empno')
	ls_lendgbn = dw_main.GetItemString(icurrow, 'lendgbn')
	ls_lenddate = dw_main.getitemstring(icurrow, 'lenddate')
	ld_lendamt  = dw_main.getitemdecimal(icurrow, 'lendamt')
	ld_lendmamt = dw_main.getitemdecimal(icurrow, 'lendmamt')
	ls_lendfrom = dw_main.getitemstring(icurrow, 'lendfrom')
	ld_rate = dw_main.GetItemDecimal(icurrow, 'rate')
	
	IF ls_empno = '' OR IsNull(ls_empno) THEN
		MessageBox("확  인", "사번을 입력하세요.")
		dw_main.SetColumn('empno')
		dw_main.SetFocus()
		Return -1
	END IF
	
	IF ls_lendgbn = '' OR IsNull(ls_lendgbn) THEN
		MessageBox("확  인", "대출종류를 입력하세요.")
		dw_main.SetColumn('lendgbn')
		dw_main.SetFocus()
		Return -1
	END IF
	
	if ls_lenddate = '' or isnull(ls_lenddate) then
		messagebox("확  인", "대출일자를 입력하세요.")
		dw_main.setcolumn('lenddate')
		dw_main.setfocus()
		return -1
	end if
	
	if ld_lendamt = 0 or isnull(ld_lendamt) then
		messagebox("확  인", "대출금액을 입력하세요.")
		dw_main.setcolumn('lendamt')
		dw_main.setfocus()
		return -1
	end if
	
	if dw_main.GetColumnName() = 'lendgbn' THEN
	   ls_lendgbn2 = dw_main.GetText()
		IF ls_lendgbn2 = '1' THEN
			if ld_lendmamt = 0 or isnull(ld_lendmamt) then
				messagebox("확  인", "월상환액을 입력하세요.")
				dw_main.setcolumn('lendmamt')
				dw_main.setfocus()
				return -1
			end if
				
			if ls_lendfrom = '' or isnull(ls_lendfrom) then
				messagebox("확  인", "분할(상환)개시월을 입력하세요.")
				dw_main.setcolumn('lendfrom')
				dw_main.setfocus()
				return -1
			end if
		
			IF ld_rate = 0 OR IsNull(ld_rate) THEN
				MessageBox("확  인", "이자율을 입력하세요.")
				dw_main.SetColumn('rate')
				dw_main.SetFocus()
				Return -1
			END IF
		ELSEIF ls_lendgbn2 = '2' THEN
			if ld_lendmamt = 0 or isnull(ld_lendmamt) then
				messagebox("확  인", "월상환액을 입력하세요.")
				dw_main.setcolumn('lendmamt')
				dw_main.setfocus()
				return -1
			end if
				
			if ls_lendfrom = '' or isnull(ls_lendfrom) then
				messagebox("확  인", "분할(상환)개시월을 입력하세요.")
				dw_main.setcolumn('lendfrom')
				dw_main.setfocus()
				return -1
			end if
		
			IF ld_rate = 0 OR IsNull(ld_rate) THEN
				MessageBox("확  인", "이자율을 입력하세요.")
				dw_main.SetColumn('rate')
				dw_main.SetFocus()
				Return -1
			END IF
		END IF
	END IF	
Return 1
end function

public function integer wf_delete_chk (integer icurrow);integer iCnt,iSubCnt
string  ls_gubun, ls_empno, ls_lenddate, ls_lendgubn

	if dw_main.accepttext() = -1 then return -1

   ls_lendgubn	= dw_main.GetItemString(icurrow, 'lendgubn')
	ls_lenddate = dw_main.getitemstring(icurrow, 'lenddate')
	ls_empno    = dw_main.GetItemString(iCurRow, 'empno')
	

select Count(*) into :iCnt from p5_lendsch
	where lendgbn = :ls_lendgubn and empno = :ls_empno and lenddate = :ls_lenddate and subgbn = 'Y' and retgbn = '1' ;
if sqlca.sqlcode = 0 and iCnt > 0 then
	MessageBox('확 인','공제내역이 있으므로 삭제할 수 없습니다.')
	Return -1
else
	select Count(*) into :iSubCnt from p5_lendsch
		where lendgbn = :ls_lendgubn and empno = :ls_empno and lenddate = :ls_lenddate and subgbn = 'Y' and retgbn = '2' ;
	if sqlca.sqlcode = 0 and iSubCnt > 0 then
		MessageBox('확 인','일시상환내역이 있으므로 삭제할 수 없습니다.')
		Return -1
	else
		return 1	
	end if
end if

end function

public subroutine wf_init ();String snull
Int lnull

SetNull(snull)
SetNull(lnull)

dw_main.SetRedraw(False)

dw_main.Reset()
dw_main.InsertRow(0)

//dw_main.SetItem(dw_main.GetRow(), "lendgbn", "%")
//dw_main.SetItem(dw_main.GetRow(), "fdate", String(today(), 'yyyy') + "0101")
//dw_main.SetItem(dw_main.GetRow(), "tdate", String(today(), 'yyyymmdd'))
//dw_main.SetItem(dw_main.GetRow(), "empno", "%")
dw_main.SetItem(dw_main.GetRow(), "rate", 7)


dw_main.SetColumn("empno")
dw_main.SetFocus()

dw_main.SetRedraw(True)

p_ins.Enabled = True
p_ins.PictureName = "C:\erpman\image\추가_up.gif"

ib_any_typing =False

lb_autoflag = True

smodstatus ="I"

//wf_setting_retrievemode(smodstatus)

end subroutine

public subroutine wf_setting_retrievemode (string mode);//dw_main.SetRedraw(False)
//IF mode ="M" THEN
//	dw_main.SetTabOrder("empno",0)
//	dw_main.SetColumn("empname")
//	
//	cb_del.Enabled =True
//ELSE
//	dw_main.SetTabOrder("empno",10)
//	dw_main.SetColumn("empno")
//	cb_del.Enabled =False
//END IF
//dw_main.SetFocus()
//dw_main.SetRedraw(True)
end subroutine

on w_pis2010.create
int iCurrent
call super::create
this.dw_main=create dw_main
this.dw_ip=create dw_ip
this.rr_1=create rr_1
this.rr_2=create rr_2
this.dw_list=create dw_list
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_main
this.Control[iCurrent+2]=this.dw_ip
this.Control[iCurrent+3]=this.rr_1
this.Control[iCurrent+4]=this.rr_2
this.Control[iCurrent+5]=this.dw_list
end on

on w_pis2010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_main)
destroy(this.dw_ip)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.dw_list)
end on

event open;call super::open;dw_ip.SetTransObject(SQLCA)
dw_ip.Reset()
dw_ip.InsertRow(0)
dw_ip.SetFocus()

is_saupcd = gs_saupcd

dw_main.SetTransObject(SQLCA)
dw_main.sharedata(dw_list)

dw_ip.SetItem(1, 'fdate', left(f_today(), 4) + "0101")
dw_ip.SetItem(1, 'tdate', f_today())

wf_init()

p_inq.TriggerEvent(Clicked!)

dw_main.Modify("lendmamt.limit=3")
dw_main.Modify("lendbamt.limit=3")

//
//dw_list.retrieve('%', string(today(), 'yyyy') + "0101", string(today(), 'yyyymmdd'), '%')
//




end event

type p_mod from w_inherite_standard`p_mod within w_pis2010
end type

event p_mod::clicked;call super::clicked;
String ls_fdate, ls_tdate, ls_empno, ls_Lenddate, ls_lendgbn
Integer li_count
dwItemStatus l_status

IF dw_ip.AcceptText() = -1 then return 
IF dw_main.AcceptText() = -1 then return 
if dw_main.GetRow() <= 0 then Return

//ls_fdate = dw_ip.GetItemString(dw_ip.GetRow(),"fdate")
//ls_tdate = dw_ip.GetItemString(dw_ip.GetRow(),"tdate")
ls_empno = dw_list.GetItemString(dw_list.GetRow(),"empno")
ls_lendgbn = dw_list.GetItemString(dw_list.GetRow(), 'lendgbn')
ls_lenddate = dw_list.GetItemString(dw_list.GetRow(), 'lenddate')

IF dw_main.GetRow() <=0 THEN Return

IF Wf_RequiredChk(dw_main.GetRow()) = -1 Then Return

IF f_dbconfirm("저장") = 2 THEN RETURN

l_status =   dw_main.GetItemStatus(dw_main.GetRow(), 0, primary!) 
IF l_status = DataModified! THEN
	
	SELECT COUNT(*) INTO :li_count 
	  FROM p5_lendsch  WHERE lendgbn = :ls_LendGbn AND 
									 lendkind = '1' AND
									 empno = :ls_EmpNo AND
									 lenddate = :ls_LendDate AND
									 subgbn = 'Y' AND
									 paygubun like '%';          // 생성한 계획이 있는지 확인.													 
	
	IF li_count > 0 THEN
		MessageBox("확인", "생성된 상환계획이 있습니다!")
		ROLLBACK USING SQLCA;
		p_inq.TriggerEvent(Clicked!)
	ELSE 
		dw_main.Update()
	COMMIT USING SQLCA;
		MessageBox("저장", "자료가 저장되었습니다!")
		p_ins.Enabled = True
		p_ins.PictureName = "C:\erpman\image\추가_up.gif"		
	END IF
	//f_MessageChk(13, "")
	RETURN
ELSE
	dw_main.Update()
	COMMIT USING SQLCA;
	MessageBox("저장", "자료가 저장되었습니다!")
	p_ins.Enabled = True
   p_ins.PictureName = "C:\erpman\image\추가_up.gif"		
END IF
ib_any_typing = False
//
//IF dw_main.Update() = 1 THEN
//	COMMIT USING SQLCA;
//	MessageBox("저장", "자료가 저장되었습니다!")
//	p_ins.Enabled = True
//   p_ins.PictureName = "C:\erpman\image\추가_up.gif"		
//ELSE
//	ROLLBACK USING SQLCA;
//	f_messagechk(13,"")
//	RETURN
//END IF
//ib_any_typing = False

















//
//long ls_modicnt, ls_delcnt
//string ls_empno
//
//ls_modicnt = dw_main.modifiedCount()
//ls_delcnt = dw_main.DeletedCount()
//
//
//IF ls_modicnt + ls_delcnt < 1 THEN
//	MessageBox("저장취소", "변경 및 삭제될 자료가 없음.", Exclamation!)
//	RETURN
//END IF
//
//
//IF dw_main.Update() = 1 THEN
//	COMMIT USING SQLCA;
//	MessageBox("저장", "저장성공")
//ELSE
//	ROLLBACK USING SQLCA;
//	MessageBox("저장오류", "저장실패")
//END IF
//







////w_mdi_frame.sle_msg.text =""
//
//
//	IF dw_main.GetRow() <=0 THEN Return
//	IF dw_main.AcceptText() = -1 then return 
//	
//	IF Wf_RequiredChk(dw_main.GetRow()) = -1 THEN Return
//	
//	IF f_dbconfirm("저장") = 2 THEN RETURN
//	
//	IF dw_main.Update() > 0 THEN			
//		COMMIT;
//		//ib_any_typing =False
//		MessageBox("확인", "자료를 저장하였습니다!!")
//	ELSE
//		ROLLBACK;
//		//ib_any_typing = True
//		MessageBox("확인", "저장 실패!!")
//		Return
//	END IF
//
//p_inq.triggerevent(clicked!)
end event

type p_del from w_inherite_standard`p_del within w_pis2010
end type

event p_del::clicked;call super::clicked;String ls_empno, ls_lenddate, ls_lendgbn
int li_row, li_count, li_subgbn


dw_main.AcceptText()

if dw_main.GetRow() <=0 THEN Return


ls_empno = dw_main.GetItemString(dw_main.GetRow(), "empno")
ls_lenddate = dw_main.GetItemString(dw_main.GetRow(), "lenddate")
ls_lendgbn = dw_main.GetItemString(dw_main.GetRow(), "lendgbn")



SELECT COUNT(*) INTO :li_count FROM p5_lendsch
 WHERE empno = :ls_empno AND 
		 lendgbn = :ls_lendgbn AND
		 lendkind = '1' AND
		 lenddate = :ls_lenddate AND
		 paygubun like '%' ;

IF li_count > 0 THEN
	IF MessageBox("확인", "생성한 계획이 있습니다. 삭제하시겠습니까?", STOPSIGN!, YesNO!, 2) = 2 THEN RETURN
	
	SELECT COUNT(*) INTO :li_subgbn FROM p5_lendsch
	 WHERE subgbn = 'Y' AND
	 		 empno = :ls_empno AND 
			 lendgbn = :ls_lendgbn AND
			 lendkind = '1' AND
			 lenddate = :ls_lenddate AND
			 paygubun like '%' ;
			 
   IF li_subgbn > 0 THEN
		MessageBox("확인", "공제한 자료가 있어서 삭제할 수 없습니다.")
		Return
	ELSE
		li_row = dw_list.GetRow()
				
		IF li_row > 0 THEN
			   DELETE FROM p5_lendsch
				 WHERE empno = :ls_empno AND 
						 lendgbn = :ls_lendgbn AND
						 lendkind = '1' AND
						 lenddate = :ls_lenddate AND
						 paygubun like '%' ;
			   if sqlca.sqlcode = 0 then
					commit;
				else
					rollback;
				end if
				
				 DELETE FROM p5_lendmst
				 WHERE empno = :ls_empno AND 
						 lendgbn = :ls_lendgbn AND
						 lendkind = '1' AND
						 lenddate = :ls_lenddate ;
						 
             if sqlca.sqlcode = 0 then
					commit;
				else
					rollback;
				end if						 
			  
			   dw_main.DeleteRow(0)
				p_ins.Enabled = True
				p_ins.PictureName = "C:\erpman\image\추가_up.gif"
				w_mdi_frame.sle_msg.text ="자료가 삭제되었습니다.!!!"	
			
			if dw_list.RowCount() > 0 then
				dw_list.SelectRow(dw_list.RowCount(),True)
			else
				dw_list.insertrow(0)
			end if
		ELSE
			MessageBox("삭제오류", "삭제할 필요가 없습니다.", Exclamation!)
			Return
		END IF
		ib_any_typing = False		 
	END IF	
	
ELSE
	IF f_dbconfirm("삭제") = 2 THEN RETURN
	
	li_row = dw_list.GetRow()
	
	
	
	IF li_row > 0 THEN
		    DELETE FROM p5_lendmst
				 WHERE empno = :ls_empno AND 
						 lendgbn = :ls_lendgbn AND
						 lendkind = '1' AND
						 lenddate = :ls_lenddate ;
			   if sqlca.sqlcode = 0 then
					commit;
				else
					rollback;
				end if
				
         dw_main.DeleteRow(0) 				
			p_ins.Enabled = True
			p_ins.PictureName = "C:\erpman\image\추가_up.gif"
			w_mdi_frame.sle_msg.text ="자료가 삭제되었습니다.!!!"	
		
		if dw_list.RowCount() > 0 then
			dw_list.SelectRow(dw_list.RowCount(),True)
		else
			dw_list.insertrow(0)
		end if
	ELSE
		MessageBox("삭제오류", "삭제할 필요가 없습니다.", Exclamation!)
		Return
	END IF
	ib_any_typing = False		 
END IF




//IF f_dbconfirm("삭제") = 2 THEN RETURN
//
//li_row = dw_list.GetRow()
//dw_main.DeleteRow(0)
//
//
//IF li_row > 0 THEN
//		p_ins.Enabled = True
//   	p_ins.PictureName = "C:\erpman\image\추가_up.gif"
//		w_mdi_frame.sle_msg.text ="자료가 삭제되었습니다.!!!"	
//	
//	if dw_list.RowCount() > 0 then
//		dw_list.SelectRow(dw_list.RowCount(),True)
//	else
//		dw_list.insertrow(0)
//	end if
//ELSE
//	MessageBox("삭제오류", "삭제할 필요가 없습니다.", Exclamation!)
//	Return
//END IF
//ib_any_typing = False		 








//long ls_row, ls_insertrow
//integer ls_rtn
//
//ls_row = dw_list.GetRow()
//IF ls_row < 1 THEN
//	MessageBox("삭제오류", "삭제할 필요가 없습니다.", Exclamation!)
//	RETURN
//END IF
//
//ls_rtn = MessageBox("삭제확인", "선택하신 자료를 삭제하시겠습니까?", &
//						  Question!, YesNo!, 2)
//IF ls_rtn <> 1 THEN RETURN  
//
//
//
//dw_list.SetRedraw(false)
//
//dw_main.DeleteRow(ls_row) 
//
////ls_row = dw_list.GetRow()
//ls_insertrow = dw_list.InsertRow(0)
//
////dw_main.SetItem(ls_insertrow, 'companycode', 'KN') 
//
//dw_list.ScrollToRow(ls_insertrow)
//dw_list.SetFocus()
//dw_list.SetRedraw(true)
//
end event

type p_inq from w_inherite_standard`p_inq within w_pis2010
integer x = 3515
end type

event p_inq::clicked;call super::clicked;string ls_empno, ls_fdate, ls_tdate, ls_lendgbn

IF dw_ip.RowCount() <= 0 THEN Return
dw_ip.accepttext()

ls_lendgbn = dw_ip.GetItemString(dw_ip.GetRow(), 'lendgbn')
ls_fdate = dw_ip.GetItemString(dw_ip.GetRow(), 'fdate')
ls_tdate = dw_ip.GetItemString(dw_ip.GetRow(), 'tdate')
ls_empno = dw_ip.getitemstring(dw_ip.getrow(), 'empno')

IF ls_lendgbn = '' OR IsNull(ls_lendgbn) THEN ls_lendgbn = '%' 

IF ls_fdate = '' OR IsNull(ls_fdate) THEN
	MessageBox("확인", "대출기간을 입력하세요.")
	dw_ip.SetColumn('fdate')
	Return 1
END IF

IF ls_tdate = '' OR IsNull(ls_tdate) THEN
	MessageBox("확인", "대출기간을 입력하세요.")
	dw_ip.SetColumn('tdate')
	Return 1 
END IF

IF ls_fdate > ls_tdate THEN
	MessageBox("확인", "대출기간을 확인하세요!", information!)
	Return 
END IF

IF ls_empno = '' OR IsNull(ls_empno) THEN ls_empno = '%'


p_ins.Enabled = True
p_ins.PictureName = "C:\erpman\image\추가_up.gif"

p_search.Enabled = True
p_search.PictureName = "C:\Erpman\image\상환계획등록_up.gif"

dw_main.SetFocus()


IF dw_main.retrieve(ls_lendgbn, ls_fdate, ls_tdate, ls_empno) < 1 THEN
	MessageBox("확인", "조회된 자료가 없습니다.")
	dw_main.InsertRow(0)
	
	Return
ELSE
	dw_list.SelectRow(0, False)
	dw_list.SelectRow(1, True)
	
	dw_list.ScrollToRow(1)
	
	smodstatus="M"
	wf_setting_retrievemode(smodstatus)
END IF


end event

type p_print from w_inherite_standard`p_print within w_pis2010
boolean visible = false
integer x = 4622
integer y = 544
boolean enabled = false
end type

type p_can from w_inherite_standard`p_can within w_pis2010
end type

event p_can::clicked;call super::clicked;p_inq.TriggerEvent(Clicked!)
end event

type p_exit from w_inherite_standard`p_exit within w_pis2010
end type

type p_ins from w_inherite_standard`p_ins within w_pis2010
integer x = 3689
string picturename = "C:\erpman\image\추가_UP.gif"
end type

event p_ins::clicked;call super::clicked;Integer  iCurRow, iFunctionValue
String   ls_fdate, ls_tdate

IF dw_ip.GetRow() <=0 THEN Return

dw_ip.AcceptText()
ls_fdate = dw_ip.GetItemString(dw_ip.GetRow(), "fdate")
ls_tdate = dw_ip.GetItemString(dw_ip.GetRow(), "tdate")

IF ls_fdate = "" OR IsNull(ls_fdate) THEN
	MessageBox("확  인", "조회일자를 확인해 주십시오.")
	dw_ip.SetColumn("fdate")
	dw_ip.SetFocus()
	Return 1
END IF

IF ls_tdate = "" OR IsNull(ls_tdate) THEN
	MessageBox("확  인", "조회일자를 확인해 주십시오.")
	dw_ip.SetColumn("tdate")
	dw_ip.SetFocus()
	Return 1
END IF

IF dw_main.RowCount() > 0 THEN
	iFunctionValue = Wf_RequiredChk(dw_main.GetRow())
	IF iFunctionValue <> 1 THEN RETURN
ELSE
	iFunctionValue = 1	
END IF

IF iFunctionValue = 1 THEN
	iCurRow = dw_main.InsertRow(0)

	dw_main.ScrollToRow(iCurRow)
		
	dw_main.SetColumn("empno")
	dw_main.SetFocus()
	
	dw_list.SelectRow(0,False)
	dw_list.SelectRow(iCurRow,True)
	
	dw_list.ScrollToRow(iCurRow)
	
//	dw_1.SetItem(iCurRow,"ab_jgbn",sJGbn)
//	dw_1.SetItem(iCurRow,"saupj",  gs_saupj)
//	dw_1.Setitem(iCurRow,"use_tag",'0')
//	dw_1.SetItem(iCurRow,"ab_fst",String(today(),"yyyymmdd"))
	
	ls_fdate =dw_ip.GetItemString(dw_ip.GetRow(),"fdate")
	ls_tdate =dw_ip.GetItemString(dw_ip.GetRow(),"tdate")

	IF ls_fdate = "" OR IsNull(ls_fdate) THEN
		MessageBox("확  인", "조회일자를 확인해 주십시오.")
		dw_ip.SetColumn("fdate")
		dw_ip.SetFocus()
		Return 1
	END IF
	
	IF ls_tdate = "" OR IsNull(ls_tdate) THEN
	   MessageBox("확  인", "조회일자를 확인해 주십시오.")
	   dw_ip.SetColumn("tdate")
	   dw_ip.SetFocus()
	   Return 1
   END IF

	sModStatus = 'I'
	
	Lb_AutoFlag = False
	
END IF







//Int li_currow, li_functionvalue
//
////w_mdi_frame.sle_msg.text =""
//
//IF dw_main.RowCount() <=0 THEN 
//	li_currow = 0
//	li_functionvalue = 1 
//ELSE
//	li_functionvalue = wf_requiredchk(dw_main.GetRow())
//	li_currow = dw_main.GetRow() 
//END IF
//	
//IF li_functionvalue = 1 THEN
//	li_currow = li_currow + 1
//		
//	dw_main.InsertRow(li_currow)
//
//	dw_main.ScrollToRow(li_currow)
//	dw_main.setcolumn('empno')
//	dw_main.setfocus()	
//ELSE
//	dw_main.ScrollToRow(dw_main.GetRow())
//END IF
//
//
//
end event

type p_search from w_inherite_standard`p_search within w_pis2010
integer x = 3214
integer width = 302
string picturename = "C:\erpman\image\상환계획등록_d.gif"
end type

event p_search::ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\Erpman\image\상환계획등록_up.gif"
end event

event p_search::ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\Erpman\image\상환계획등록_dn.gif"
end event

event p_search::clicked;call super::clicked;
SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_codename2)

	IF dw_list.AcceptText() = -1 THEN RETURN
	
	IF dw_list.GetRow() < 1 THEN RETURN
	
	gs_code = dw_list.GetItemString(dw_list.GetRow(), 'empno')
	gs_codename = dw_list.GetItemString(dw_list.GetRow(), 'lenddate')
	gs_codename2 = dw_list.GetItemString(dw_list.GetRow(), 'lendgbn')
	
	OpenSheetWithParm(w_pis2020, '1', w_mdi_frame, 2, layered!)

p_inq.TriggerEvent(Clicked!)

end event

type p_addrow from w_inherite_standard`p_addrow within w_pis2010
boolean visible = false
integer x = 4626
integer y = 688
boolean enabled = false
end type

type p_delrow from w_inherite_standard`p_delrow within w_pis2010
boolean visible = false
integer x = 4631
integer y = 832
boolean enabled = false
end type

type dw_insert from w_inherite_standard`dw_insert within w_pis2010
boolean visible = false
integer x = 4489
integer y = 2212
integer width = 133
integer height = 76
boolean enabled = false
end type

type st_window from w_inherite_standard`st_window within w_pis2010
end type

type cb_exit from w_inherite_standard`cb_exit within w_pis2010
end type

type cb_update from w_inherite_standard`cb_update within w_pis2010
end type

type cb_insert from w_inherite_standard`cb_insert within w_pis2010
end type

type cb_delete from w_inherite_standard`cb_delete within w_pis2010
end type

type cb_retrieve from w_inherite_standard`cb_retrieve within w_pis2010
end type

type st_1 from w_inherite_standard`st_1 within w_pis2010
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_pis2010
end type

type dw_datetime from w_inherite_standard`dw_datetime within w_pis2010
end type

type sle_msg from w_inherite_standard`sle_msg within w_pis2010
end type

type gb_2 from w_inherite_standard`gb_2 within w_pis2010
end type

type gb_1 from w_inherite_standard`gb_1 within w_pis2010
end type

type gb_10 from w_inherite_standard`gb_10 within w_pis2010
end type

type dw_main from datawindow within w_pis2010
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 2071
integer y = 300
integer width = 2395
integer height = 1888
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_pis2010_2"
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) or keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event type long ue_pressenter();Send(Handle(this),256,9,0)
Return 1
end event

event rbuttondown;if this.GetColumnName() = 'empno' THEN

   SetNull(gs_code)
	SetNull(gs_codename)
	SetNull(Gs_gubun)
	
	Gs_gubun = is_saupcd
	open(w_employee_saup_popup)
	
	IF IsNull(gs_code) THEN Return
	
	this.SetItem(this.GetRow(), 'empno', gs_code)
	this.SetItem(this.GetRow(), 'empname', gs_codename)
	
	this.TriggerEvent(Itemchanged!)
	
END IF

end event

event itemchanged;string ls_empno, ls_deptcode, ls_jikjong, ls_enterdate, snull, ls_retgbn, ls_lendgbn
string ls_lenddate, ls_afteryear, ls_date, ls_lendeja, ls_lendm, ls_lendb,ls_name
Decimal ls_lendmamt, ld_lendamt, dnull, ls_lendbamt

setnull(snull)
SetNull(dnull)

this.Accepttext()
ls_empno = this.GetItemString(this.GetRow(), 'empno')

	
SELECT empname,deptcode, jikjonggubn, enterdate
  INTO :ls_name,:ls_deptcode, :ls_jikjong, :ls_enterdate
  FROM p1_master
 WHERE empno = :ls_empno ;
 
 this.SetItem(this.GetRow(), 'empname', ls_name)
 this.SetItem(this.GetRow(), 'deptcode', ls_deptcode)
 this.SetItem(this.GetRow(), 'jikjonggubn', ls_jikjong)
 this.SetItem(this.GetRow(), 'enterdate', ls_enterdate)
 
IF this.GetcolumnName() ="retgubun" THEN
	ls_retgbn = this.GetText()
	IF IsNull(data) OR data ="" THEN		
		MessageBox("확 인", "필수 입력 사항입니다.")
		Return 1
   END IF
	
	IF ls_retgbn = '1' THEN
		this.SetItem(This.GetRow(), 'lendmamt', 12)
		this.SetItem(This.GetRow(), 'lendbamt', 12)
		this.SetItem(This.GetRow(), 'rate', 7)
	ELSEIF ls_retgbn = '2' THEN
		this.SetItem(This.GetRow(), 'lendmamt', 10)
		this.SetItem(This.GetRow(), 'lendbamt', 10)
		this.SetItem(This.GetRow(), 'rate', 7)
	ELSEIF ls_retgbn = '3' THEN
		this.SetItem(This.GetRow(), 'lendmamt', 0)
		this.SetItem(This.GetRow(), 'lendbamt', 0)
		this.SetItem(This.GetRow(), 'rate', 7)
	ELSEIF ls_retgbn = '4' THEN
		this.SetItem(This.GetRow(), 'lendmamt', 0)
		this.SetItem(This.GetRow(), 'lendbamt', 0)
		this.SetItem(This.GetRow(), 'rate', 7)
		this.SetItem(This.GetRow(), 'lendfrom', snull)
		this.SetItem(This.GetRow(), 'lendfrom_eja', snull)
	END IF
END IF 
 
IF GetColumnName() = 'lendmamt' THEN
	lS_lendm = this.GetText()
	IF IsNull(data) OR data ="" THEN		
		MessageBox("확 인", "필수 입력 사항입니다.")
		Return 1
   END IF 
	ls_retgbn = this.GetItemString(this.GetRow(), 'retgubun')
	IF trim(ls_lendm) = '1' THEN
		MessageBox("확 인", "일시상환을 선택하세요.")
		SetItem(this.GetRow(), 'lendmamt', 0)
		SetItem(this.GetRow(), 'retgubun', '4')
		SetColumn('retgubun')
		dw_main.SetFocus()
		Return 1
	END IF
END IF 

IF GetColumnName() = 'lendbamt' THEN
	lS_lendb = this.GetText()
	IF IsNull(data) OR data ="" THEN		
		MessageBox("확 인", "필수 입력 사항입니다.")
		Return 1
   END IF 
	ls_retgbn = this.GetItemString(this.GetRow(), 'retgubun')
	IF trim(ls_lendm) = '1' THEN
		MessageBox("확 인", "일시상환을 선택하세요.")
		SetItem(this.GetRow(), 'lendbamt', 0)
		SetItem(this.GetRow(), 'retgubun', '4')
		SetColumn('retgubun')
		dw_main.SetFocus()
		Return 1
	END IF
END IF 
 
IF this.GetcolumnName() ="lenddate" THEN
	ls_date = this.GetText()
	IF IsNull(data) OR data ="" THEN
		MessageBox("확 인", "필수 입력 사항입니다.")
		Return 1
   END IF
	If f_datechk(data) = -1 THEN
		MessageBox("확 인", "대출일자가 부정확합니다.")
		SetItem(getrow(),'lenddate',snull)
		SetColumn('lenddate')
		dw_main.SetFocus()
		Return 1
	END IF
	
	
//	ls_LendGbn = this.GetItemString(this.GetRow(), 'lendgbn')
//	IF ls_LendGbn = '2' THEN
//		this.SetItem(GetRow(), 'lendfrom', F_AfterMonth(left(ls_date, 6), 12))
//	ELSE
//		Return 1
//	END IF	
// IF this.GetColumnName() = 'lendgbn' THEN
//		ls_lendgbn = this.GetText()
//		IF ls_lendgbn = '2' THEN
//			this.SetItem(GetRow(), 'lendfrom', F_AfterMonth(left(ls_date, 6), 12))
//		END IF
//	END IF
END IF

IF this.GetcolumnName() ="lendenddate" THEN
	IF IsNull(data) OR data ="" THEN		
		MessageBox("확 인", "필수 입력 사항입니다.")
		Return 1
   END IF
	If f_datechk(data) = -1 THEN
		MessageBox("확 인", "대출종료일자가 부정확합니다.")
		SetItem(getrow(),'lendenddate',snull)
		SetColumn('lendenddate')
		dw_main.SetFocus()
		Return 1
	END IF
	ls_date = this.GetItemString(This.GetRow(), 'lenddate')
	IF long(data) < long(left(ls_date, 6)) THEN
		MessageBox("확 인", "대출종료일자가 대출일자보다 작을수 없습니다.")
		SetItem(GetRow(), 'lendenddate', snull)
		SetColumn('lendenddate')
		dw_main.SetFocus()
		Return 1
	END IF
END IF

IF this.GetcolumnName() ="lendfrom_eja" THEN
	ls_lendeja = this.GetText()
	this.SetItem(this.GetRow(), 'lendfrom', ls_lendeja)
	IF IsNull(data) OR data ="" THEN				
		MessageBox("확 인", "필수 입력 사항입니다.")
		Return 1
   END IF
	If f_datechk(data+'01') = -1 THEN
		MessageBox("확 인", "최초상환월(이자)이 부정확합니다.")
		SetItem(getrow(),'lendfrom_eja',snull)
		SetColumn('lendfrom_eja')
		dw_main.SetFocus()
		Return 1
	END IF
	ls_date = this.GetItemString(This.GetRow(), 'lenddate')
	IF long(data) < long(left(ls_date, 6)) THEN
		MessageBox("확 인", "최초상환월(이자)이 대출일자보다 작을수 없습니다.")
		SetItem(GetRow(), 'lendfrom_eja', snull)
		SetColumn('lendfrom_eja')
		dw_main.SetFocus()
		Return 1
	END IF
END IF


IF this.GetcolumnName() ="lendfrom" THEN
	IF IsNull(data) OR data ="" THEN		
		MessageBox("확 인", "필수 입력 사항입니다.")
		Return 1
   END IF
	If f_datechk(data+'01') = -1 THEN
		MessageBox("확 인", "최초상환월(원금)이 부정확합니다.")
		SetItem(getrow(),'lendfrom',snull)
		SetColumn('lendfrom')
		dw_main.SetFocus()
		Return 1
	END IF
	ls_date = this.GetItemString(This.GetRow(), 'lenddate')
	IF long(data) < long(left(ls_date, 6)) THEN
		MessageBox("확 인", "최초상환월(원금)이 대출일자보다 작을수 없습니다.")
		SetItem(GetRow(), 'lendfrom', snull)
		SetColumn('lendfrom')
		dw_main.SetFocus()
		Return 1
	END IF
END IF


IF this.GetColumnName() = 'lendgbn' THEN
	ls_lendgbn = this.GetText()
	IF ls_lendgbn = '1' THEN
	   this.SetItem(GetRow(), 'retgubun', '1')
		this.SetItem(GetRow(), 'lendmamt', 12)
		this.SetItem(GetRow(), 'lendbamt', 12)
		this.SetItem(GetRow(), 'rate', 7)
	ELSEIF ls_lendgbn = '2' THEN
		this.SetItem(GetRow(), 'retgubun', '1')
		this.SetItem(GetRow(), 'lendmamt', 24)
		this.SetItem(GetRow(), 'lendbamt', 24)
		this.SetItem(GetRow(), 'rate', 7)
		
//		ls_date = this.GetItemString(GetRow(), 'lenddate') 
//		IF ls_date = '' OR IsNull(ls_date) THEN
//			Return 1
//		ELSE
//			SetItem(GetRow(), 'lendfrom', F_aftermonth(left(ls_date, 6), 12))
//		END IF
//		IF this.GetColumnName() = 'lenddate' THEN
//		ls_lenddate = this.GetText()
//		ls_afteryear = string(Integer(left(ls_lenddate, 4)) + 1) + right(ls_lenddate, 2)
//		messageBox("1", ls_afteryear)
//		this.SetItem(GetRow(), 'lendfrom', 'ls_afteryear')
//		END IF
	ELSE
		this.SetItem(GetRow(), 'retgubun', '4')
		this.SetItem(GetRow(), 'rate', 0)
		this.SetItem(GetRow(), 'lendmamt', 0)
		this.SetItem(GetRow(), 'lendbamt', 0)
	END IF
END IF

IF GetColumnName() = 'lendmamt' THEN
	ld_lendamt = This.GetItemDecimal(This.GetRow(), 'lendamt')
	IF IsNull(data) OR data ="" THEN		
		MessageBox("확 인", "필수 입력 사항입니다.")
		Return 1
   END IF
	IF long(ld_lendamt) < long(data) THEN
		MessageBox("확 인", "월상환액이 대출금액보다 클 수 없습니다.")
		SetItem(GetRow(), 'lendmamt', dnull)
		SetColumn('lendmamt')
		dw_main.SetFocus()
		Return 1
	END IF
	
	ls_retgbn = this.GetItemString(this.GetRow(), 'retgubun')
   ls_lendmamt = this.GetItemDecimal(this.GetRow(), 'lendmamt')

		
	IF ls_retgbn = '1' THEN
		IF ls_lendmamt > 100 THEN
			MessageBox("확 인", "대출횟수가 너무 큽니다.")
			SetItem(GetRow(), 'lendmamt', snull)
			SetColumn('lendmamt')
			Return 1
		END IF
		IF ld_lendamt = 1 THEN
			MessageBox("확 인", "일시상환을 선택하세요.")
			this.SetItem(GetRow(), 'lendmamt', snull)
			this.SetItem(GetRow(), 'retgubun', '1')
			SetColumn('retgubun')
			Return 1
		END IF

	ELSEIF ls_retgbn = '2' THEN
		IF ls_lendmamt > 100 THEN
			MessageBox("확 인", "대출비율이 부정확합니다.")
			SetItem(GetRow(), 'lendmamt', snull)
			SetColumn('lendmamt')
			Return 1			
		END IF
	ELSEIF ls_retgbn = '3' THEN 
		
		IF ls_lendmamt < 0 THEN
			MessageBox("확 인", "월상환액이 부정확합니다.")
			SetItem(GetRow(), 'lendmamt', snull)
			SetColumn('lendmamt')
			Return 1			
		END IF
	ELSE
		SetItem(GetRow(), 'lendmamt', snull)		
	END IF
END IF



IF GetColumnName() = 'lendbamt' THEN
	ld_lendamt = This.GetItemDecimal(This.GetRow(), 'lendamt')
	IF IsNull(data) OR data ="" THEN		
		MessageBox("확 인", "필수 입력 사항입니다.")
		Return 1
   END IF
	IF long(ld_lendamt) < long(data) THEN
		MessageBox("확 인", "월상환액이 대출금액보다 클 수 없습니다.")
		SetItem(GetRow(), 'lendbamt', dnull)
		SetColumn('lendbamt')
		dw_main.SetFocus()
		Return 1
	END IF
	
	ls_retgbn = this.GetItemString(this.GetRow(), 'retgubun')
   ls_lendbamt = this.GetItemDecimal(this.GetRow(), 'lendbamt')

		
	IF ls_retgbn = '1' THEN
		IF ls_lendbamt > 100 THEN
			MessageBox("확 인", "대출횟수가 너무 큽니다.")
			SetItem(GetRow(), 'lendbamt', snull)
			SetColumn('lendbamt')
			Return 1
		END IF
		IF ld_lendamt = 1 THEN
			MessageBox("확 인", "일시상환을 선택하세요.")
			this.SetItem(GetRow(), 'lendbamt', snull)
			this.SetItem(GetRow(), 'retgubun', '1')
			SetColumn('retgubun')
			Return 1
		END IF

	ELSEIF ls_retgbn = '2' THEN
		IF ls_lendbamt > 100 THEN
			MessageBox("확 인", "대출비율이 부정확합니다.")
			SetItem(GetRow(), 'lendbamt', snull)
			SetColumn('lendbamt')
			Return 1			
		END IF
	ELSEIF ls_retgbn = '3' THEN 
		
		IF ls_lendbamt < 0 THEN
			MessageBox("확 인", "월상환액이 부정확합니다.")
			SetItem(GetRow(), 'lendbamt', snull)
			SetColumn('lendbamt')
			Return 1			
		END IF
	ELSE
		SetItem(GetRow(), 'lendbamt', snull)		
	END IF
END IF




// IF GetColumnName() = 'retgubun' THEN
//	 ls_value = GetItemString(dw_main.GetRow(), 'retgubun')
//	 ls_value = GetItemString(dw_main.GetRow(), 'lendmamt')
//	 
//	 IF ls_value = 1 THEN
//		la_value.modify
//	 ELSEIF ls_value = 2 THEN
//		
//	 ELSE ls_value = 3 THEN 
//		
//	 END IF
end event

event editchanged;ib_any_typing =True
end event

event itemerror;Return 1
end event

type dw_ip from datawindow within w_pis2010
event ue_ley pbm_dwnkey
event ue_retrieve ( )
event ue_processenter pbm_dwnprocessenter
integer x = 46
integer y = 32
integer width = 2203
integer height = 248
integer taborder = 60
boolean bringtotop = true
string title = "none"
string dataobject = "d_pis2010_1_c"
boolean border = false
boolean livescroll = true
end type

event ue_ley;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_retrieve();//string ls_fdate, ls_tdate, ls_lendgbn, ls_empno
//
//IF AcceptText() = -1 THEN RETURN
//
//ls_lendgbn = trim(GetItemString(1, 'lendgbn'))
//ls_fdate = trim(GetItemString(1, 'fdate'))
//ls_tdate = trim(GetItemString(1, 'tdate'))
//ls_empno = trim(GetItemString(1, 'empno'))
//
//IF ls_fdate = '' OR IsNull(ls_fdate) THEN
//	MessageBox("확인", "대출일자를 확인하세요!", information!)
//	Return 
//END IF
//
//IF ls_tdate = '' OR IsNull(ls_tdate) THEN
//	MessageBox("확인", "대출일자를 확인하세요!", information!)
//	Return 
//END IF
//
//IF ls_fdate > ls_tdate THEN
//	MessageBox("확인", "대출기간을 확인하세요!", information!)
//	Return 
//END IF
//
//
//IF dw_list.retrieve(ls_lendgbn, ls_fdate, ls_tdate, ls_empno) < 1 THEN
//	MessageBox("확인","조회된 자료가 없습니다!", information!)
//	Return
//END IF


end event

event type long ue_processenter();Send(Handle(this),256,9,0)
Return 1
end event

event rbuttondown;IF this.GetColumnName() = 'empno' THEN
	
	SetNull(gs_code)
	SetNull(gs_codename)
	SetNull(Gs_gubun)
	
	Gs_gubun = is_saupcd
	
	open(w_employee_saup_popup)
	
	IF IsNull(gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(), 'empno', gs_code)
	this.SetItem(this.GetRow(), 'empname', gs_codename)
	
	this.TriggerEvent(Itemchanged!)
	
END IF
end event

event itemchanged;string ls_empno, ls_consmat, ls_empname, ls_lendgbn, ls_lend, ls_date, snull

SetNull(snull)

IF this.GetColumnName() = 'empno' THEN
	ls_empno = this.GetText()
	IF ls_empno = '' OR IsNull(ls_empno) THEN
		this.SetItem(1, "empname", snull)
		RETURN
	END IF
	
	SELECT NVL(consmatgubn, 'Y'), empname
	  INTO :ls_consmat, :ls_empname
	  FROM p1_master
	 WHERE companycode = 'KN' AND
	 		 empno = :ls_empno;

	IF sqlca.sqlcode = 0 THEN
		IF ls_consmat <> 'Y' THEN
			MessageBox("확인", "복지회에 가입되지 않은 사원입니다.")
				this.SetItem(1, 'empno', snull)
				this.SetItem(1, 'empname', snull)
				this.SetColumn('empno')
				return 1
		END IF
		this.SetItem(1, "empname", ls_empname)
	ELSE
		MessageBox("확 인", "등록되지 않은 사원입니다.")
		this.SetItem(1, 'empno', snull)
		this.SetItem(1, 'empname', snull)
		
		this.SetColumn('empno')
		RETURN 1
	END IF

p_inq.TriggerEvent(clicked!)
END IF

IF this.GetColumnName() = 'lendgbn' THEN
   ls_lendgbn = this.GetItemString(1, 'lendgbn')
   IF ls_lendgbn ='' OR IsNull(ls_lendgbn) THEN ls_lendgbn = '%'
   p_inq.TriggerEvent(clicked!)
END IF


IF this.GetcolumnName() ="fdate" THEN
	IF IsNull(data) OR data ="" THEN
		Return 1
   END IF
	If f_datechk(data) = -1 THEN
		MessageBox("확 인", "조회일자가 부정확합니다.")
		SetItem(getrow(),'fdate',snull)
		SetColumn('fdate')
		dw_ip.SetFocus()
		Return 1
	END IF
END IF

IF this.GetcolumnName() ="tdate" THEN
	IF IsNull(data) OR data ="" THEN
		Return 1
   END IF
	If f_datechk(data) = -1 THEN
		MessageBox("확 인", "조회일자가 부정확합니다.")
		SetItem(getrow(),'tdate',snull)
		SetColumn('tdate')
		dw_ip.SetFocus()
		Return 1
	END IF
	ls_date = this.GetItemString(this.GetRow(), 'fdate')
	IF long(data) < long(ls_date) THEN
		MessageBox("확 인", "조회일자 범위가 부정확합니다.")
		SetItem(getrow(),'tdate',snull)
		SetColumn('tdate')
		dw_ip.SetFocus()
		Return 1
	END IF
END IF
end event

event itemerror;RETURN 1
end event

event getfocus;this.AcceptText()
end event

type rr_1 from roundrectangle within w_pis2010
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 46
integer y = 292
integer width = 1970
integer height = 1912
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pis2010
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 2053
integer y = 292
integer width = 2427
integer height = 1912
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_list from u_d_popup_sort within w_pis2010
integer x = 59
integer y = 304
integer width = 1929
integer height = 1888
integer taborder = 11
string dataobject = "d_pis2010_1"
boolean border = false
end type

event itemerror;call super::itemerror;RETURN 1
end event

event rowfocuschanged;call super::rowfocuschanged;If currentrow <= 0 then
	dw_main.SelectRow(0,False)

ELSE

	SelectRow(0, FALSE)
	SelectRow(currentrow,TRUE)
	
	dw_main.ScrollToRow(currentrow)
END IF

//
//string ls_fdate, ls_tdate, ls_empno, ls_lendgbn
//
//If CurrentRow <= 0 then
//	dw_list.SelectRow(0,False)
//	//b_flag =True
//ELSE
//	SelectRow(0, FALSE)
//	SelectRow(CurrentRow,TRUE)	
//	
//	
////	dw_main.SetItem(1, 'empno', this.GetItemString(CurrentRow, 'empno'))
////  
////ls_lendgbn = This.GetItemString(CurrentRow,'lendgbn')
////ls_fdate = String(today(), 'yyyy') + '0101'
////ls_tdate = String(today(), 'yyyymmdd')
////ls_empno = This.GetItemString(CurrentRow,'empno')
////
////
////IF ls_fdate = '' OR IsNull(ls_fdate) THEN
////	MessageBox("확인", "대출기간을 입력하세요.")
////	dw_ip.SetColumn('fdate')
////	Return 1
////END IF
////
////IF ls_tdate = '' OR IsNull(ls_tdate) THEN
////	MessageBox("확인", "대출기간을 입력하세요.")
////	dw_ip.SetColumn('tdate')
////	Return 1 
////END IF
////
////IF ls_fdate > ls_tdate THEN
////	MessageBox("확인", "대출기간을 확인하세요!", information!)
////	Return 
////END IF
////
////IF ls_empno = '' OR IsNull(ls_empno) THEN
////	MessageBox("확인", "사번을 입력하세요.")
////	dw_ip.setcolumn('empno')
////   Return 1
////END IF
////
////p_ins.Enabled = True
////p_ins.PictureName = "C:\erpman\image\추가_up.gif"
////
////p_search.Enabled = False
////p_search.PictureName = "C:\Erpman\image\상환계획등록_d.gif"
////
////dw_main.SetFocus()
////
////
////IF dw_main.retrieve(ls_lendgbn, ls_fdate, ls_tdate, ls_empno) < 1 THEN
////	MessageBox("확인", "조회된 자료가 없습니다.")
////	dw_ip.setcolumn('empno')
////	Return 
////END IF
// 
//END IF
end event

event clicked;call super::clicked;IF dw_list.GetClickedRow() > 0 THEN
IF Row <= 0 then
	dw_main.SelectRow(0,False)
	//b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	dw_main.ScrollToRow(row)
	
	Lb_AutoFlag = False
	
	//b_flag = False
	
	smodstatus="M"
	wf_setting_retrievemode(smodstatus)
END IF

IF this.GetItemString(row, 'empno') = '' OR IsNull(this.GetItemString(row, 'empno')) THEN 
   p_search.enabled = False
	p_search.PictureName = "C:\Erpman\image\상환계획등록_d.gif"
ELSE
	p_search.enabled = True
	p_search.PictureName = "C:\Erpman\image\상환계획등록_up.gif"
END IF //상환계획등록

CALL SUPER ::CLICKED
END IF



//
////INT i
//
//IF row <= 0 THEN RETURN
//
////IF KeyDown(KeyShift!) THEN
////	IF ib_IsShift = FALSE THEN
////		ib_IsShift = TRUE
////		il_selectrow = GetRow()     // 기준이 되는 row
////	END IF
////	
////	IF il_selectrow >= row THEN
////		FOR i = il_selectrow TO row STEP -1 
////          SelectRow(i, TRUE)
////		NEXT
////	ELSEIF il_selectrow <= row THEN
////		FOR i = il_selectrow TO row
////			SelectRow(i, TRUE)
////		NEXT
////	ELSE
////		SelectRow(0, FALSE)
////		SelectRow(row, TRUE)
////		
////	END IF
////	
////
////ELSEIF KeyDown(KeyControl!) THEN
////	ib_IsShift = FALSE
////	IF IsSelected(row) THEN
////		SelectRow(row, FALSE)
////	ELSE
////		SelectRow(0, FALSE)
////	   SelectRow(row, TRUE)
////	END IF
////	
////	
////ELSE
////	ib_IsShift = FALSE
////	IF IsSelected(row) THEN
////		SelectRow(row, FALSE)
////	ELSE
////		SelectRow(0, FALSE)
////		SelectRow(row, TRUE)
////	END IF
////END IF
////



end event

