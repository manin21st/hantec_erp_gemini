$PBExportHeader$w_pil1004.srw
$PBExportComments$상환계획자료월일괄변경
forward
global type w_pil1004 from w_inherite_standard
end type
type dw_mst from datawindow within w_pil1004
end type
type dw_list from u_d_select_sort within w_pil1004
end type
type rr_1 from roundrectangle within w_pil1004
end type
end forward

global type w_pil1004 from w_inherite_standard
string title = "월상환내역수정"
dw_mst dw_mst
dw_list dw_list
rr_1 rr_1
end type
global w_pil1004 w_pil1004

forward prototypes
public subroutine wf_change_flag ()
end prototypes

public subroutine wf_change_flag ();Integer k,iCount

iCount = dw_list.RowCount()

FOR k = 1 TO iCount
	dw_list.SetItem(k,"flag",'0')
NEXT
end subroutine

on w_pil1004.create
int iCurrent
call super::create
this.dw_mst=create dw_mst
this.dw_list=create dw_list
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_mst
this.Control[iCurrent+2]=this.dw_list
this.Control[iCurrent+3]=this.rr_1
end on

on w_pil1004.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_mst)
destroy(this.dw_list)
destroy(this.rr_1)
end on

event open;call super::open;dw_mst.SetTransObject(sqlca)
dw_list.SetTransObject(sqlca)

dw_mst.reset()
dw_list.reset()

dw_mst.insertrow(0)
dw_mst.setItem(1, 'yymm', string(today(), 'YYYYMM'))
dw_mst.setItem(1, 'pbtag', "B")
dw_mst.setItem(1, 'toyymm', string(today(), 'YYYYMMDD'))

dw_mst.setcolumn('yymm')

dw_mst.setfocus()



end event

type p_mod from w_inherite_standard`p_mod within w_pil1004
boolean visible = false
integer x = 4160
integer y = 2512
end type

type p_del from w_inherite_standard`p_del within w_pil1004
integer x = 4069
end type

event p_del::clicked;call super::clicked;Int il_currow

il_currow = dw_list.GetRow()
IF il_currow <=0 Then Return

IF	 MessageBox("삭제 확인", "삭제하시겠습니까? ", question!, yesno!) = 2	THEN return
	
dw_list.DeleteRow(il_currow)

IF dw_list.Update() > 0 THEN
	commit;
	IF il_currow = 1 OR il_currow <= dw_list.RowCount() THEN
		dw_list.ScrollToRow(il_currow - 1)
		dw_list.SetColumn('expamt')				
		dw_list.SetFocus()		
	END IF
	ib_any_typing =False
	w_mdi_frame.sle_msg.text ="자료를 삭제하였습니다!!"
ELSE
	rollback;
	ib_any_typing =True
	Return
END IF

end event

type p_inq from w_inherite_standard`p_inq within w_pil1004
integer x = 3547
end type

event p_inq::clicked;call super::clicked;string syymm
long aa

if dw_mst.AcceptText() = -1 then return

syymm = dw_mst.GetItemString(1, 'yymm')

if syymm="" or isnull(syymm) then
  MessageBox("확 인", "[년월]은 필수입력항목입니다.!!")
  return
end if

dw_list.setredraw(false)
if dw_list.retrieve(syymm) <= 0 then
	MessageBox("확 인", "검색된 자료가 존재하지 않습니다.!!")
	dw_mst.setfocus()
	dw_mst.setcolumn('syymm')
   dw_list.setredraw(true)	
	return 
end if

dw_list.setredraw(true)	

ib_any_typing = false

end event

type p_print from w_inherite_standard`p_print within w_pil1004
boolean visible = false
integer x = 3639
integer y = 2512
end type

type p_can from w_inherite_standard`p_can within w_pil1004
integer x = 4242
end type

event p_can::clicked;call super::clicked;dw_list.reset()

//dw_mst.insertrow(0)
//dw_mst.setItem(1, 'yymm', string(today(), 'YYYYMM'))
//dw_mst.setItem(1, 'pbtag', "B")
//dw_mst.setItem(1, 'toyymm', string(today(), 'YYYYMMDD'))
//
dw_mst.setfocus()
dw_mst.setcolumn('yymm')
end event

type p_exit from w_inherite_standard`p_exit within w_pil1004
integer x = 4416
end type

type p_ins from w_inherite_standard`p_ins within w_pil1004
integer x = 3895
end type

event p_ins::clicked;call super::clicked;string ls_lenddate, ls_paygbn, ls_restdate

Int il_currow,  il_functionvalue

IF dw_mst.AcceptText() = -1 then return

ls_lenddate = dw_mst.GetItemString(1, 'lenddate')
ls_paygbn = dw_mst.GetItemString(1, 'paygbn')
ls_restdate = dw_mst.GetItemString(1, 'restdate')

if ls_lenddate="" or isnull(ls_lenddate) then
  MessageBox("확 인", "[년월]은 필수입력항목입니다.!!")
  return
elseif ls_paygbn="" or isnull(ls_paygbn) then
  MessageBox("확 인", "[공제구분]은 필수입력항목입니다.!!")	
  return	  
elseif ls_restdate="" or isnull(ls_restdate) then
  MessageBox("확 인", "[상환일자]은 필수입력항목입니다.!!")		
  return	
end if

IF dw_list.RowCount() <=0 THEN
	il_currow = 0
//	il_functionvalue =1
ELSE
//	il_functionvalue = wf_requiredchk(ddlb_1.text,dw_list.GetRow())
	
	il_currow = dw_list.GetRow() 
END IF

//IF il_functionvalue = 1 THEN
	il_currow = il_currow + 1
	
	dw_list.InsertRow(il_currow)
	dw_list.Setitem(il_currow, "lenddate", ls_lenddate) 	
	dw_list.Setitem(il_currow, "paygbn", ls_paygbn) 
	dw_list.Setitem(il_currow, "restdate", ls_restdate)
	dw_list.Setitem(il_currow, "to_exp", ls_restdate)
	dw_list.Setitem(il_currow, "flag", "1")
	dw_list.ScrollToRow(il_currow)	
	dw_list.selectrow(0, false)
	
	dw_list.setcolumn('empno')
	dw_list.SetFocus()
//END IF
w_mdi_frame.sle_msg.text = "새로운 자료를 입력하십시요!!"

end event

type p_search from w_inherite_standard`p_search within w_pil1004
integer x = 3721
string picturename = "C:\erpman\Image\일괄적용_up.gif"
end type

event p_search::clicked;call super::clicked;string sdate,tdate,pbtag,sempno,sempname
long lrow
double payamt, bonus

if dw_mst.AcceptText() = -1 then return
IF dw_list.Accepttext() = -1 THEN 	RETURN

lrow = dw_list.GetRow()

if lrow <= 0 then  return 

//필수 입력사항 check
sdate = dw_mst.GetItemString(1, 'yymm')
tdate = dw_mst.GetItemString(1, 'toyymm')
pbtag = dw_mst.GetItemString(1, 'pbtag')

if sdate ="" or isnull(sdate) then
  MessageBox("확 인", "[년월]은 필수입력항목입니다.!!")
  return
elseif tdate ="" or isnull(tdate) then
  MessageBox("확 인", "[변경년월]은 필수입력항목입니다.!!")	
  return	  
elseif pbtag ="" or isnull(pbtag) then
  MessageBox("확 인", "[급/상여구분]은 필수입력항목입니다.!!")		
  return	
end if

if  f_datechk(sdate+'01') = -1 Then
       MessageBox("확 인", "유효한 년월이 아닙니다.!!")
       dw_mst.Setcolumn('yymm')  			 
       dw_mst.setfocus()
		 Return 
end if

if  f_datechk(tdate+'01') = -1 Then
       MessageBox("확 인", "유효한 년월이 아닙니다.!!")
       dw_mst.Setcolumn('toyymm')  			 
       dw_mst.setfocus()
		 Return 
end if

if tdate < sdate then
	MessageBox("확 인", "원년월이 적용년월보다 ~n클 수 없습니다.!!")
   dw_mst.setcolumn('toyymm')
	dw_mst.setfocus()
	return
end if

///////////////////////////////////////////////////////////////////////////////////
IF MessageBox("확인", "일괄적용 하시겠습니까?", question!, yesno!) = 2	THEN	RETURN

FOR lrow = 1 to dw_list.rowcount()
	sempno = dw_list.GetItemString(lrow,"empno")
	sempname = dw_list.GetItemString(lrow,"empname")
IF pbtag = 'P' then
	
  SELECT NVL("P3_LENDSCH"."PAYRESTAMT",0) INTO :payamt
  FROM "P3_LENDSCH"
  WHERE "P3_LENDSCH"."SKEDUALDATE" = :tdate and
         "P3_LENDSCH"."EMPNO" = :sempno;
			
	if payamt <> 0 then
		messagebox("확인",sempname +"의"+right(tdate,2)+"월달의 급여상환액이 있습니다!") 
		return
	end if
	  INSERT INTO "P3_LENDSCH"  
         ( "EMPNO",   
           "SKEDUALDATE",   
           "PAYRESTAMT",   
           "LENDGBN",   
           "LENDGUBN" )  
   SELECT  "EMPNO",   
           :tdate,   
           "PAYRESTAMT",   
           "LENDGBN",   
           "LENDGUBN"  
    FROM  "P3_LENDSCH"
	 WHERE "P3_LENDSCH"."SKEDUALDATE" = :sdate and
          "P3_LENDSCH"."EMPNO" = :sempno;

	UPDATE "P3_LENDSCH"
	SET "P3_LENDSCH"."PAYRESTAMT" = 0
	WHERE "P3_LENDSCH"."SKEDUALDATE" = :sdate and
          "P3_LENDSCH"."EMPNO" = :sempno;
  
ELSE
	
  SELECT NVL("P3_LENDSCH"."MEEDRESTAMT",0) INTO :bonus
  FROM "P3_LENDSCH"
  WHERE "P3_LENDSCH"."SKEDUALDATE" = :tdate and
        "P3_LENDSCH"."EMPNO" = :sempno;
		  
	if bonus <> 0 then
		messagebox("확인",sempname +"의"+right(tdate,2)+"월달의 상여상환액이 있습니다!") 
		return
	end if
	 INSERT INTO "P3_LENDSCH"  
         ( "EMPNO",   
           "SKEDUALDATE",   
           "MEEDRESTAMT",    
           "LENDGBN",   
           "LENDGUBN" )  
   SELECT  "EMPNO",   
           :tdate,   
           "MEEDRESTAMT",   
           "LENDGBN",   
           "LENDGUBN"  
	 FROM  "P3_LENDSCH"
	 WHERE "P3_LENDSCH"."SKEDUALDATE" = :sdate and
          "P3_LENDSCH"."EMPNO" = :sempno;
			 
	UPDATE "P3_LENDSCH"
	SET "P3_LENDSCH"."MEEDRESTAMT" = 0
	WHERE "P3_LENDSCH"."SKEDUALDATE" = :sdate and
          "P3_LENDSCH"."EMPNO" = :sempno;
  
	
END IF

NEXT
COMMIT;
dw_list.setRedraw(false)
dw_list.retrieve(sdate)
dw_list.setRedraw(true)
end event

type p_addrow from w_inherite_standard`p_addrow within w_pil1004
boolean visible = false
integer x = 3813
integer y = 2512
end type

type p_delrow from w_inherite_standard`p_delrow within w_pil1004
boolean visible = false
integer x = 3986
integer y = 2512
end type

type dw_insert from w_inherite_standard`dw_insert within w_pil1004
boolean visible = false
integer x = 530
integer y = 2668
end type

type st_window from w_inherite_standard`st_window within w_pil1004
boolean visible = false
end type

type cb_exit from w_inherite_standard`cb_exit within w_pil1004
boolean visible = false
integer x = 3241
integer taborder = 90
end type

type cb_update from w_inherite_standard`cb_update within w_pil1004
boolean visible = false
integer x = 2418
integer width = 416
integer taborder = 60
string text = "일괄변경(&S)"
end type

event cb_update::clicked;call super::clicked;string sdate,tdate,pbtag,sempno,sempname
long lrow
double payamt, bonus

if dw_mst.AcceptText() = -1 then return
IF dw_list.Accepttext() = -1 THEN 	RETURN

lrow = dw_list.GetRow()

if lrow <= 0 then  return 

//필수 입력사항 check
sdate = dw_mst.GetItemString(1, 'yymm')
tdate = dw_mst.GetItemString(1, 'toyymm')
pbtag = dw_mst.GetItemString(1, 'pbtag')

if sdate ="" or isnull(sdate) then
  MessageBox("확 인", "[년월]은 필수입력항목입니다.!!")
  return
elseif tdate ="" or isnull(tdate) then
  MessageBox("확 인", "[변경년월]은 필수입력항목입니다.!!")	
  return	  
elseif pbtag ="" or isnull(pbtag) then
  MessageBox("확 인", "[급/상여구분]은 필수입력항목입니다.!!")		
  return	
end if

if  f_datechk(sdate+'01') = -1 Then
       MessageBox("확 인", "유효한 년월이 아닙니다.!!")
       dw_mst.Setcolumn('yymm')  			 
       dw_mst.setfocus()
		 Return 
end if

if  f_datechk(tdate+'01') = -1 Then
       MessageBox("확 인", "유효한 년월이 아닙니다.!!")
       dw_mst.Setcolumn('toyymm')  			 
       dw_mst.setfocus()
		 Return 
end if

if tdate < sdate then
	MessageBox("확 인", "원년월이 적용년월보다 ~n클 수 없습니다.!!")
   dw_mst.setcolumn('toyymm')
	dw_mst.setfocus()
	return
end if

///////////////////////////////////////////////////////////////////////////////////
IF MessageBox("확인", "일괄적용 하시겠습니까?", question!, yesno!) = 2	THEN	RETURN

FOR lrow = 1 to dw_list.rowcount()
	sempno = dw_list.GetItemString(lrow,"empno")
	sempname = dw_list.GetItemString(lrow,"empname")
IF pbtag = 'P' then
	
  SELECT NVL("P3_LENDSCH"."PAYRESTAMT",0) INTO :payamt
  FROM "P3_LENDSCH"
  WHERE "P3_LENDSCH"."SKEDUALDATE" = :tdate and
         "P3_LENDSCH"."EMPNO" = :sempno;
			
	if payamt <> 0 then
		messagebox("확인",sempname +"의"+right(tdate,2)+"월달의 급여상환액이 있습니다!") 
		return
	end if
	  INSERT INTO "P3_LENDSCH"  
         ( "EMPNO",   
           "SKEDUALDATE",   
           "PAYRESTAMT",   
           "LENDGBN",   
           "LENDGUBN" )  
   SELECT  "EMPNO",   
           :tdate,   
           "PAYRESTAMT",   
           "LENDGBN",   
           "LENDGUBN"  
    FROM  "P3_LENDSCH"
	 WHERE "P3_LENDSCH"."SKEDUALDATE" = :sdate and
          "P3_LENDSCH"."EMPNO" = :sempno;

	UPDATE "P3_LENDSCH"
	SET "P3_LENDSCH"."PAYRESTAMT" = 0
	WHERE "P3_LENDSCH"."SKEDUALDATE" = :sdate and
          "P3_LENDSCH"."EMPNO" = :sempno;
  
ELSE
	
  SELECT NVL("P3_LENDSCH"."MEEDRESTAMT",0) INTO :bonus
  FROM "P3_LENDSCH"
  WHERE "P3_LENDSCH"."SKEDUALDATE" = :tdate and
        "P3_LENDSCH"."EMPNO" = :sempno;
		  
	if bonus <> 0 then
		messagebox("확인",sempname +"의"+right(tdate,2)+"월달의 상여상환액이 있습니다!") 
		return
	end if
	 INSERT INTO "P3_LENDSCH"  
         ( "EMPNO",   
           "SKEDUALDATE",   
           "MEEDRESTAMT",    
           "LENDGBN",   
           "LENDGUBN" )  
   SELECT  "EMPNO",   
           :tdate,   
           "MEEDRESTAMT",   
           "LENDGBN",   
           "LENDGUBN"  
	 FROM  "P3_LENDSCH"
	 WHERE "P3_LENDSCH"."SKEDUALDATE" = :sdate and
          "P3_LENDSCH"."EMPNO" = :sempno;
			 
	UPDATE "P3_LENDSCH"
	SET "P3_LENDSCH"."MEEDRESTAMT" = 0
	WHERE "P3_LENDSCH"."SKEDUALDATE" = :sdate and
          "P3_LENDSCH"."EMPNO" = :sempno;
  
	
END IF

NEXT
COMMIT;
dw_list.setRedraw(false)
dw_list.retrieve(sdate)
dw_list.setRedraw(true)
end event

type cb_insert from w_inherite_standard`cb_insert within w_pil1004
boolean visible = false
integer x = 1467
integer y = 2568
integer width = 361
integer taborder = 50
string text = "추가(&I)"
end type

event cb_insert::clicked;call super::clicked;string ls_lenddate, ls_paygbn, ls_restdate

Int il_currow,  il_functionvalue

IF dw_mst.AcceptText() = -1 then return

ls_lenddate = dw_mst.GetItemString(1, 'lenddate')
ls_paygbn = dw_mst.GetItemString(1, 'paygbn')
ls_restdate = dw_mst.GetItemString(1, 'restdate')

if ls_lenddate="" or isnull(ls_lenddate) then
  MessageBox("확 인", "[년월]은 필수입력항목입니다.!!")
  return
elseif ls_paygbn="" or isnull(ls_paygbn) then
  MessageBox("확 인", "[공제구분]은 필수입력항목입니다.!!")	
  return	  
elseif ls_restdate="" or isnull(ls_restdate) then
  MessageBox("확 인", "[상환일자]은 필수입력항목입니다.!!")		
  return	
end if

IF dw_list.RowCount() <=0 THEN
	il_currow = 0
//	il_functionvalue =1
ELSE
//	il_functionvalue = wf_requiredchk(ddlb_1.text,dw_list.GetRow())
	
	il_currow = dw_list.GetRow() 
END IF

//IF il_functionvalue = 1 THEN
	il_currow = il_currow + 1
	
	dw_list.InsertRow(il_currow)
	dw_list.Setitem(il_currow, "lenddate", ls_lenddate) 	
	dw_list.Setitem(il_currow, "paygbn", ls_paygbn) 
	dw_list.Setitem(il_currow, "restdate", ls_restdate)
	dw_list.Setitem(il_currow, "to_exp", ls_restdate)
	dw_list.Setitem(il_currow, "flag", "1")
	dw_list.ScrollToRow(il_currow)	
	dw_list.selectrow(0, false)
	
	dw_list.setcolumn('empno')
	dw_list.SetFocus()
//END IF
sle_msg.text = "새로운 자료를 입력하십시요!!"

end event

type cb_delete from w_inherite_standard`cb_delete within w_pil1004
boolean visible = false
integer x = 1893
integer y = 2576
integer taborder = 70
end type

event cb_delete::clicked;call super::clicked;Int il_currow

il_currow = dw_list.GetRow()
IF il_currow <=0 Then Return

IF	 MessageBox("삭제 확인", "삭제하시겠습니까? ", question!, yesno!) = 2	THEN return
	
dw_list.DeleteRow(il_currow)

IF dw_list.Update() > 0 THEN
	commit;
	IF il_currow = 1 OR il_currow <= dw_list.RowCount() THEN
		dw_list.ScrollToRow(il_currow - 1)
		dw_list.SetColumn('expamt')				
		dw_list.SetFocus()		
	END IF
	ib_any_typing =False
	sle_msg.text ="자료를 삭제하였습니다!!"
ELSE
	rollback;
	ib_any_typing =True
	Return
END IF

end event

type cb_retrieve from w_inherite_standard`cb_retrieve within w_pil1004
boolean visible = false
integer taborder = 40
end type

event cb_retrieve::clicked;call super::clicked;string syymm
long aa

if dw_mst.AcceptText() = -1 then return

syymm = dw_mst.GetItemString(1, 'yymm')

if syymm="" or isnull(syymm) then
  MessageBox("확 인", "[년월]은 필수입력항목입니다.!!")
  return
end if

dw_list.setredraw(false)
if dw_list.retrieve(syymm) <= 0 then
	MessageBox("확 인", "검색된 자료가 존재하지 않습니다.!!")
	dw_mst.setfocus()
	dw_mst.setcolumn('syymm')
   dw_list.setredraw(true)	
	return 
end if

dw_list.setredraw(true)	

ib_any_typing = false

end event

type st_1 from w_inherite_standard`st_1 within w_pil1004
boolean visible = false
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_pil1004
boolean visible = false
integer x = 2871
integer taborder = 80
end type

event cb_cancel::clicked;call super::clicked;dw_list.reset()

//dw_mst.insertrow(0)
//dw_mst.setItem(1, 'yymm', string(today(), 'YYYYMM'))
//dw_mst.setItem(1, 'pbtag', "B")
//dw_mst.setItem(1, 'toyymm', string(today(), 'YYYYMMDD'))
//
dw_mst.setfocus()
dw_mst.setcolumn('yymm')

end event

type dw_datetime from w_inherite_standard`dw_datetime within w_pil1004
boolean visible = false
end type

type sle_msg from w_inherite_standard`sle_msg within w_pil1004
boolean visible = false
end type

type gb_2 from w_inherite_standard`gb_2 within w_pil1004
boolean visible = false
integer x = 2373
integer width = 1243
end type

type gb_1 from w_inherite_standard`gb_1 within w_pil1004
boolean visible = false
integer width = 411
end type

type gb_10 from w_inherite_standard`gb_10 within w_pil1004
boolean visible = false
end type

type dw_mst from datawindow within w_pil1004
event ue_enterkey pbm_dwnprocessenter
integer x = 768
integer y = 40
integer width = 2574
integer height = 196
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pil1004_1"
boolean border = false
boolean livescroll = true
end type

event ue_enterkey;if dw_mst.GetColumnName() = 'restdate' then
	p_inq.TriggerEvent(Clicked!)

end if
Send(Handle(this),256,9,0)

Return 1
end event

event itemchanged;string ls_lenddate, ls_restdate

if this.GetColumnName() = 'yymm'  then
	ls_lenddate = this.GetText()
	if isnull(ls_lenddate) or ls_lenddate = "" then return
	If f_datechk(ls_lenddate + "01") = -1 Then
		MessageBox("확 인", "유효한 년월이 아닙니다.")
		Return 1
	end if
p_inq.TriggerEvent(clicked!)	
end if

if this.GetColumnName() = 'toyymm'  then
	ls_restdate = this.GetText()
	if isnull(ls_restdate) or ls_restdate = "" then return
	
	If f_datechk(ls_restdate+'01') = -1 Then
		MessageBox("확 인", "유효한 년월이 아닙니다.")
		Return 1
	end if
end if


end event

event itemerror;return 1

end event

type dw_list from u_d_select_sort within w_pil1004
event ue_enterkey pbm_dwnprocessenter
integer x = 805
integer y = 252
integer width = 3063
integer height = 1948
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_pil1004_2"
boolean hscrollbar = false
boolean border = false
end type

event ue_enterkey;Send(Handle(this),256,9,0)

return 1
end event

event itemchanged;string ls_fr_exp, ls_to_exp, ls_date1, ls_date2, &
       ls_empno, ls_lenddate, ls_paygbn, ls_restdate,ls_gubn
string sNull, sFindCol, temp_empno, temp_name 
long ll_date1, ll_cnt, lRow, lReturnRow, ll_emp

SetNull(sNull)

//if this.GetColumnName() = 'empno' then 
//   ls_empno = this.GetText()
//	
////	ls_lenddate = dw_mst.GetItemString(1, 'lenddate')
////	ls_paygbn = dw_mst.GetItemString(1, 'paygbn')
////	ls_restdate = dw_mst.GetItemString(1, 'restdate')
////	
////	if ls_lenddate="" or isnull(ls_lenddate) then
////	  MessageBox("확 인", "[년월]은 필수입력항목입니다.!!")
////	  return
////	elseif ls_paygbn="" or isnull(ls_paygbn) then
////	  MessageBox("확 인", "[공제구분]은 필수입력항목입니다.!!")	
////	  return	  
////	elseif ls_restdate="" or isnull(ls_restdate) then
////	  MessageBox("확 인", "[상환일자]은 필수입력항목입니다.!!")		
////	  return	
////	end if
//
//   if isnull(ls_empno) or ls_empno = "" then return 1
//
//	SELECT "P3_LENDMST"."EMPNO",  
//	       "P1_MASTER"."EMPNAME"  
//     INTO :temp_empno,   
//	       :temp_name   
//   FROM "P3_LENDMST",      
//	     "P1_MASTER"   
//  WHERE ( "P3_LENDMST"."EMPNO" = "P1_MASTER"."EMPNO" (+))  AND      
//        ( "P3_LENDMST"."EMPNO" = :ls_empno ) and
//		  ( "P3_LENDMST"."LENDGUBN" = :ls_gubn );  
//
//	if sqlca.sqlcode = 0  then
//   	this.SetItem(row, 'p1_master_empname', temp_name) 										  		
//	elseif  sqlca.sqlcode = 100  then 
//		MessageBox("확 인", "대여금 자료에 존재하지 않는" + "~n" + &
//		                    "사번입니다.!!")
//   	this.SetItem(row, 'empno', snull) 
//   	this.SetItem(row, 'p1_master_empname', snull) 										  
//		return 1
//	else
//		MessageBox("확 인", "사번 조회중 오류발생")
//		return 1
//	end if
//
//  SELECT count(*)
//  INTO :ll_emp
//    FROM "P3_LENDREST"
//    WHERE ( "P3_LENDREST"."EMPNO" = :ls_empno  ) and   
//	       ( "P3_LENDREST"."LENDDATE" = :ls_lenddate ) and      
//          ( "P3_LENDREST"."PAYGBN" = :ls_paygbn ) and   
//          ( "P3_LENDREST"."RESTDATE" = :ls_restdate ) and
//			 ( "P3_LENDREST"."LENDGUBN" = :ls_gubn ) ;
//  if sqlca.sqlcode = 0 and ll_emp <> 0	then  
//		MessageBox("확 인", "이미 등록되어 있는" + "~n" + &  
//		                    "사번입니다.!!")  
//   	this.SetItem(this.getrow(), 'empno', snull) 
//   	this.SetItem(this.getrow(), 'p1_master_empname', snull) 		
//		return 1
//	end if
//
//end if
	
if this.GetColumnName() = 'fr_exp' then
	ls_fr_exp = data
	ls_to_exp = this.GetItemString(row, 'to_exp')

 	if isnull(ls_fr_exp) or trim(ls_fr_exp) = "" then return			

	If f_datechk(ls_fr_exp) = -1 Then
		MessageBox("확 인", "유효한 일자가 아닙니다.")
		Return 1
	else
		ls_restdate = dw_mst.GetItemString(1, 'restdate')

		if ls_fr_exp > ls_to_exp then
			MessageBox("확 인", "시작일자가 종료일자보다 ~r클 수 없습니다.!!")
			return 1
		end if

		if ls_to_exp > ls_restdate then
			MessageBox("확 인", "이자적용 종료일자가 상환일자보다 ~n클 수 없습니다.!!")
			return 1
		end if
		
      if isnull(ls_to_exp) or trim(ls_to_exp) = "" then 
			ls_to_exp = ls_fr_exp
		end if
		
		ls_date1 = string(left(ls_fr_exp, 4) + "/" + mid(ls_fr_exp, 5, 2) + "/" + &
						right(ls_fr_exp, 2))
		ls_date2 = string(left(ls_to_exp, 4) + "/" + mid(ls_to_exp, 5, 2) + "/" + & 
						right(ls_to_exp, 2))
		ll_date1 = daysafter(date(ls_date1), date(ls_date2)) + 1
		
		this.SetItem(row, 'ilsu', ll_date1)
		
    end if
	
end if
	
if this.GetColumnName() = 'to_exp' then
   ls_to_exp = data
	ls_fr_exp = this.GetItemString(row, 'fr_exp')
	
	if isnull(ls_to_exp) or trim(ls_to_exp) = "" then 	return
	
	If f_datechk(ls_to_exp) = -1 Then
		MessageBox("확 인", "유효한 일자가 아닙니다.")
		Return 1
	else
		ls_restdate = dw_mst.GetItemString(1, 'restdate')

		if ls_fr_exp > ls_to_exp then
			MessageBox("확 인", "시작일자가 종료일자보다 ~r클 수 없습니다.!!")
			return 1
		end if

		if ls_to_exp > ls_restdate then
			MessageBox("확 인", "이자적용종료일자가 상환일자보다 ~n클 수 없습니다.!!")
			return 1
		end if
		
   	if isnull(ls_fr_exp) or trim(ls_fr_exp) = "" then
			ls_fr_exp = ls_to_exp
		end if
		
		ls_date1 = string(left(ls_fr_exp, 4) + "/" + mid(ls_fr_exp, 5, 2) + "/" + &
						right(ls_fr_exp, 2))
		ls_date2 = string(left(ls_to_exp, 4) + "/" + mid(ls_to_exp, 5, 2) + "/" + & 
						right(ls_to_exp, 2))
		ll_date1 = daysafter(date(ls_date1), date(ls_date2)) + 1
		
		this.SetItem(row, 'ilsu', ll_date1)
		
   end if
end if 

end event

event rbuttondown;
if dwo.name = 'empno' then

   setNull(gs_code)	
   setNull(gs_codename)
	
	open(w_pil1001_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(), "empno", Gs_code)
	this.SetItem(this.GetRow(), "p1_master_empname", Gs_codename)	
	
	this.TriggerEvent(ItemChanged!)
end if
end event

event editchanged;ib_any_typing = true
end event

event itemerror;return 1
end event

event clicked;if row > 0 then 
	this.SelectRow(0, FALSE)
	this.SelectRow(row, TRUE)
	this.ScrollToRow(row)
end if

end event

type rr_1 from roundrectangle within w_pil1004
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 782
integer y = 240
integer width = 3104
integer height = 1980
integer cornerheight = 40
integer cornerwidth = 55
end type

