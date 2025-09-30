$PBExportHeader$w_kbgb02.srw
$PBExportComments$예산이월처리
forward
global type w_kbgb02 from w_inherite
end type
type dw_from from datawindow within w_kbgb02
end type
type dw_ret1 from datawindow within w_kbgb02
end type
type dw_to from datawindow within w_kbgb02
end type
type em_2 from editmask within w_kbgb02
end type
type em_1 from editmask within w_kbgb02
end type
type rb_2 from radiobutton within w_kbgb02
end type
type rb_1 from radiobutton within w_kbgb02
end type
type gb_5 from groupbox within w_kbgb02
end type
type gb_2 from groupbox within w_kbgb02
end type
type gb_1 from groupbox within w_kbgb02
end type
type dw_ip from datawindow within w_kbgb02
end type
type rr_1 from roundrectangle within w_kbgb02
end type
type rr_2 from roundrectangle within w_kbgb02
end type
type dw_ret2 from datawindow within w_kbgb02
end type
end forward

global type w_kbgb02 from w_inherite
integer height = 3124
string title = "예산 자동 이월 처리"
boolean resizable = true
event keyup pbm_keyup
dw_from dw_from
dw_ret1 dw_ret1
dw_to dw_to
em_2 em_2
em_1 em_1
rb_2 rb_2
rb_1 rb_1
gb_5 gb_5
gb_2 gb_2
gb_1 gb_1
dw_ip dw_ip
rr_1 rr_1
rr_2 rr_2
dw_ret2 dw_ret2
end type
global w_kbgb02 w_kbgb02

type variables
string flag, ls_nacc_mm, ls_pacc_mm
Integer il_lastClickedRow 
long arg_row

end variables

forward prototypes
public function integer wf_warndataloss (string as_titletext)
public function integer wf_shift_light (datawindow dwnm, long rowcn)
public function integer wf_iwol (string saupj, string sfromyy, string sfrommm, string stoyy, string stomm)
public function integer wf_cancel_iwol (string saupj, string sfromyy, string sfrommm, string stoyy, string stomm)
end prototypes

public function integer wf_warndataloss (string as_titletext);/*=============================================================================================
		 1. window-level user function : 종료, 등록시 호출됨
		    dw_detail 의 typing(datawindow) 변경사항 검사

		 2. 계속진행할 경우 변경사항이 저장되지 않음을 경고                                                               

		 3. Argument:  as_titletext (warning messagebox)                                                                          
		    Return values:                                                   
                                                                  
      	*  1 : 변경사항을 저장하지 않고 계속 진행할 경우.
			* -1 : 진행을 중단할 경우.                      
=============================================================================================*/

IF ib_any_typing = true THEN  				// EditChanged event(dw_detail)의 typing 상태확인

	Beep(1)
	IF MessageBox("확인 : " + as_titletext , &
		 "저장하지 않은 값이 있습니다. ~r변경사항을 저장하시겠습니까", &
		 question!, yesno!) = 1 THEN

		RETURN -1									

	END IF

END IF
																
RETURN 1												// (dw_detail) 에 변경사항이 없거나 no일 경우
														// 변경사항을 저장하지 않고 계속진행 

end function

public function integer wf_shift_light (datawindow dwnm, long rowcn);Integer lIdx

If il_lastClickedRow = 0 then
	dw_ret1.SelectRow(arg_row, True)
	dw_ret2.SelectRow(arg_row, True)
	Return 1
End If

If il_lastClickedRow > arg_row then
	For lIdx = il_lastClickedRow to arg_row Step -1
		dw_ret1.SelectRow(lIdx, True)
		dw_ret2.SelectRow(lIdx, True)
	End For
Else
	For lIdx = il_lastClickedRow to arg_row
		dw_ret1.SelectRow(lIdx, True)
		dw_ret2.SelectRow(lIdx, True)
	Next
End If

Return 1
end function

public function integer wf_iwol (string saupj, string sfromyy, string sfrommm, string stoyy, string stomm);
Integer iSelectedRow,iCurRow,iFindRow
Double  dAmount,dIwolAmt,dBgkAmt2
String  sDept,sAcc1,sAcc2,sAccName,sYesanGbn

DO WHILE true
	iSelectedRow = 	dw_ret1.GetSelectedRow(0)
	If iSelectedRow = 0 then EXIT
	
	sYesanGbn= dw_ret1.Getitemstring(iSelectedRow,"ye_gu")
	sDept    = dw_ret1.Getitemstring(iSelectedRow,"dept_cd")
	sAcc1    = dw_ret1.Getitemstring(iSelectedRow,"acc1_cd")
	sAcc2    = dw_ret1.Getitemstring(iSelectedRow,"acc2_cd")
	dIwolAmt = dw_ret1.GetitemNumber(iSelectedRow,"jan_amt")
	
	IF IsNull(dIwolAmt) THEN dIwolAmt = 0
	
	SELECT "KFZ01OM0"."YACC2_NM"	  INTO :sAccName
		FROM "KFZ01OM0"  
		WHERE ( "KFZ01OM0"."ACC1_CD" = :sAcc1) AND ( "KFZ01OM0"."ACC2_CD" = :sAcc2) ;

	iCurRow = dw_ret2.Insertrow(0)
	dw_ret2.Setitem(iCurRow,"ye_gu",   			  sYesanGbn)
	dw_ret2.Setitem(iCurRow,"dept_cd",          sDept)
	dw_ret2.Setitem(iCurRow,"kfz01om0_yacc2_nm",sAccName)
	dw_ret2.Setitem(iCurRow,"acc1_cd",          sAcc1)
	dw_ret2.Setitem(iCurRow,"acc2_cd",          sAcc2)
	dw_ret2.Setitem(iCurRow,"bgk_amt3",         dIwolAmt)

	/*from의 자료는 차월이월에 (+)한다*/
	iFindRow = dw_from.Find("saupj = '"+saupj+"' and acc_yy = '"+sFromYy+"' and acc_mm = '"+sFromMm+"' and dept_cd = '"+sDept+"' and acc1_cd = '"+sAcc1+"' and acc2_cd = '"+sAcc2+"'",1,dw_from.RowCount())
	IF iFindRow > 0 THEN
		dAmount  = dw_from.GetitemNumber(iFindRow,"bgk_amt3")				/*차월이월(-)*/
		IF IsNull(dAmount) THEN dAmount = 0
	
		dw_from.SetItem(iFindRow,"bgk_amt3",    dAmount + dIwolAmt)
	END IF
	
	/*to의 자료는 전월이월에 (+)한다*/
	iFindRow = dw_to.Find("saupj = '"+saupj+"' and acc_yy = '"+sToYy+"' and acc_mm = '"+sToMm+"' and dept_cd = '"+sDept+"' and acc1_cd = '"+sAcc1+"' and acc2_cd = '"+sAcc2+"'",1,dw_to.RowCount())
	IF iFindRow > 0 THEN								/*자료가 있으면*/
		dBgkAmt2 = dw_to.GetItemNumber(iFindRow,"bgk_amt2")
		IF IsNull(dBgkAmt2) THEN dBgkAmt2 = 0
		
		dw_to.SetItem(iFindRow,"bgk_amt2", dBgkAmt2 + dIwolAmt)
	END IF
	
	dw_ret1.DeleteRow(iSelectedRow)
LOOP

IF dw_from.Update() = 1 THEN
	IF dw_to.Update() = 1 THEN
		Commit;
	ELSE
		Rollback;
		F_MessageChk(13,'[예산이월(TO)]')
		Return -1
	END IF
ELSE
	Rollback;
	F_MessageChk(13,'[예산이월(FROM)]')
	Return -1
END IF

Return 1

end function

public function integer wf_cancel_iwol (string saupj, string sfromyy, string sfrommm, string stoyy, string stomm);
Integer iSelectedRow,iCurRow,iFindRow
Double  dAmount,dIwolAmt,dBgkAmt3
String  sDept,sAcc1,sAcc2,sAccName,sYesanGbn

DO WHILE true
	iSelectedRow = 	dw_ret2.GetSelectedRow(0)
	If iSelectedRow = 0 then EXIT
	
	sYesanGbn= dw_ret2.Getitemstring(iSelectedRow,"ye_gu")
	sDept    = dw_ret2.Getitemstring(iSelectedRow,"dept_cd")
	sAcc1    = dw_ret2.Getitemstring(iSelectedRow,"acc1_cd")
	sAcc2    = dw_ret2.Getitemstring(iSelectedRow,"acc2_cd")
	dIwolAmt = dw_ret2.GetitemNumber(iSelectedRow,"bgk_amt3")
	
	IF IsNull(dIwolAmt) THEN dIwolAmt = 0
	
	SELECT "KFZ01OM0"."YACC2_NM"	  INTO :sAccName
		FROM "KFZ01OM0"  
		WHERE ( "KFZ01OM0"."ACC1_CD" = :sAcc1) AND ( "KFZ01OM0"."ACC2_CD" = :sAcc2) ;

	iCurRow = dw_ret1.Insertrow(0)
	dw_ret1.Setitem(iCurRow,"ye_gu",   			  sYesanGbn)
	dw_ret1.Setitem(iCurRow,"dept_cd",          sDept)
	dw_ret1.Setitem(iCurRow,"kfz01om0_yacc2_nm",sAccName)
	dw_ret1.Setitem(iCurRow,"acc1_cd",          sAcc1)
	dw_ret1.Setitem(iCurRow,"acc2_cd",          sAcc2)
	dw_ret1.Setitem(iCurRow,"jan_amt",          dIwolAmt)

	/*from의 자료는 전월이월에 (-)한다*/
	iFindRow = dw_from.Find("saupj = '"+saupj+"' and acc_yy = '"+sFromYy+"' and acc_mm = '"+sFromMm+"' and dept_cd = '"+sDept+"' and acc1_cd = '"+sAcc1+"' and acc2_cd = '"+sAcc2+"'",1,dw_from.RowCount())
	IF iFindRow > 0 THEN
		dAmount  = dw_from.GetitemNumber(iFindRow,"bgk_amt3")				
		IF IsNull(dAmount) THEN dAmount = 0
	
		dw_from.SetItem(iFindRow,"bgk_amt3",    dAmount - dIwolAmt)
	END IF
	
	/*to의 자료는 차월이월에 (-)한다*/
	iFindRow = dw_to.Find("saupj = '"+saupj+"' and acc_yy = '"+sToYy+"' and acc_mm = '"+sToMm+"' and dept_cd = '"+sDept+"' and acc1_cd = '"+sAcc1+"' and acc2_cd = '"+sAcc2+"'",1,dw_to.RowCount())
	IF iFindRow > 0 THEN								/*자료가 있으면*/
		dBgkAmt3 = dw_to.GetItemNumber(iFindRow,"bgk_amt2")
		IF IsNull(dBgkAmt3) THEN dBgkAmt3 = 0
		
		dw_to.SetItem(iFindRow,"bgk_amt2", dBgkAmt3 - dIwolAmt)
	END IF
	
	dw_ret2.DeleteRow(iSelectedRow)
LOOP

IF dw_from.Update() = 1 THEN
	IF dw_to.Update() = 1 THEN
		Commit;
	ELSE
		Rollback;
		F_MessageChk(13,'[예산이월(TO)]')
		Return -1
	END IF
ELSE
	Rollback;
	F_MessageChk(13,'[예산이월(FROM)]')
	Return -1
END IF

Return 1
end function

event open;call super::open;String sNextYm

dw_ip.SetTransObject(SQLCA)
dw_ret1.SetTransObject(SQLCA)
dw_ret2.SetTransObject(SQLCA)
dw_from.SetTransObject(SQLCA)
dw_to.SetTransObject(SQLCA)

dw_ip.Reset()
dw_ip.InsertRow(0)

dw_ret1.Reset()
dw_ret2.Reset()

dw_ip.SetItem(dw_ip.Getrow(),"saupj",  gs_saupj)
dw_ip.SetItem(dw_ip.Getrow(),"acc_yy", Left(F_Today(),4))
//dw_ip.SetItem(dw_ip.Getrow(),"acc_mm", Mid(F_Today(),5,2))
dw_ip.SetItem(dw_ip.Getrow(),"dept_cd",Gs_Dept)

dw_ip.SetColumn("acc_yy")
dw_ip.SetFocus()

IF F_Valid_EmpNo(Gs_EmpNo) = 'Y' THEN
	dw_ip.Modify("saupj.protect = 0")	
ELSE
	dw_ip.Modify("saupj.protect = 1")			
END IF

flag = "1"


end event

on w_kbgb02.create
int iCurrent
call super::create
this.dw_from=create dw_from
this.dw_ret1=create dw_ret1
this.dw_to=create dw_to
this.em_2=create em_2
this.em_1=create em_1
this.rb_2=create rb_2
this.rb_1=create rb_1
this.gb_5=create gb_5
this.gb_2=create gb_2
this.gb_1=create gb_1
this.dw_ip=create dw_ip
this.rr_1=create rr_1
this.rr_2=create rr_2
this.dw_ret2=create dw_ret2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_from
this.Control[iCurrent+2]=this.dw_ret1
this.Control[iCurrent+3]=this.dw_to
this.Control[iCurrent+4]=this.em_2
this.Control[iCurrent+5]=this.em_1
this.Control[iCurrent+6]=this.rb_2
this.Control[iCurrent+7]=this.rb_1
this.Control[iCurrent+8]=this.gb_5
this.Control[iCurrent+9]=this.gb_2
this.Control[iCurrent+10]=this.gb_1
this.Control[iCurrent+11]=this.dw_ip
this.Control[iCurrent+12]=this.rr_1
this.Control[iCurrent+13]=this.rr_2
this.Control[iCurrent+14]=this.dw_ret2
end on

on w_kbgb02.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_from)
destroy(this.dw_ret1)
destroy(this.dw_to)
destroy(this.em_2)
destroy(this.em_1)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.gb_5)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.dw_ip)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.dw_ret2)
end on

type dw_insert from w_inherite`dw_insert within w_kbgb02
boolean visible = false
integer taborder = 140
end type

type p_delrow from w_inherite`p_delrow within w_kbgb02
boolean visible = false
integer x = 3424
integer y = 604
integer taborder = 60
end type

type p_addrow from w_inherite`p_addrow within w_kbgb02
boolean visible = false
integer x = 2971
integer y = 508
integer taborder = 40
end type

type p_search from w_inherite`p_search within w_kbgb02
boolean visible = false
integer x = 3017
integer y = 360
integer taborder = 120
end type

type p_ins from w_inherite`p_ins within w_kbgb02
boolean visible = false
integer x = 3122
integer y = 596
end type

type p_exit from w_inherite`p_exit within w_kbgb02
integer x = 4425
integer y = 12
integer taborder = 90
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type p_can from w_inherite`p_can within w_kbgb02
boolean visible = false
integer x = 3438
integer y = 440
integer taborder = 110
end type

type p_print from w_inherite`p_print within w_kbgb02
boolean visible = false
integer x = 3259
integer y = 388
integer taborder = 130
end type

type p_inq from w_inherite`p_inq within w_kbgb02
integer x = 4078
integer y = 12
integer taborder = 70
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조회_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조회_up.gif"
end event

event clicked;call super::clicked;string   sSaupj,sYearF,sMonthF,sYearT,sMonthT,sDept,sYesanGbn,sAcc1,sAcc2,snull
Integer  rowno

SetNull(snull)

dw_ret1.reset()
dw_ret2.reset()

dw_from.Reset()
dw_to.Reset()

if dw_ip.AcceptText() = -1 then return 

sSaupj    = dw_ip.Getitemstring(dw_ip.Getrow(),"saupj")
sYearF    = dw_ip.Getitemstring(dw_ip.Getrow(),"acc_yy")
sMonthF   = dw_ip.Getitemstring(dw_ip.Getrow(),"acc_mm")

sYearT    = dw_ip.Getitemstring(dw_ip.Getrow(),"acc_yyt")
sMonthT   = dw_ip.Getitemstring(dw_ip.Getrow(),"acc_mmt")

sYesanGbn = dw_ip.Getitemstring(dw_ip.Getrow(),"ye_gu")
sDept     = dw_ip.Getitemstring(dw_ip.Getrow(),"dept_cd")
sAcc1     = dw_ip.Getitemstring(dw_ip.Getrow(),"acc1_cd")
sAcc2     = dw_ip.Getitemstring(dw_ip.Getrow(),"acc2_cd")

if sSaupj = "" or Isnull(sSaupj) then
   F_MessageChk(1,'[사업장]')
	dw_ip.SetColumn("saupj")
	dw_ip.SetFocus()
   return
else
	IF IsNull(F_Get_Refferance('AD',sSaupj)) THEN
      F_MessageChk(20,'[사업장]')
		dw_ip.SetColumn("saupj")
		dw_ip.SetFocus()
      return		
   end if
end if

IF sYearF = "" OR IsNull(sYearF) THEN
	F_MessageChk(1,'[회계년도(FROM)]')
	dw_ip.SetColumn("acc_yy")
	dw_ip.SetFocus()
   return
END IF
IF sMonthF = "" OR IsNull(sMonthF) THEN
	F_MessageChk(1,'[회계월(FROM)]')
	dw_ip.SetColumn("acc_mm")
	dw_ip.SetFocus()
   return
END IF

IF F_DateChk(sYearF+sMonthF+'01') = -1 THEN
	F_MessageChk(21,'[회계년월(FROM)]')
	dw_ip.SetColumn("acc_mm")
	dw_ip.SetFocus()
   return
end if

IF sYearT = "" OR IsNull(sYearT) THEN
	F_MessageChk(1,'[회계년도(TO)]')
	dw_ip.SetColumn("acc_yyt")
	dw_ip.SetFocus()
   return
END IF
IF sMonthT = "" OR IsNull(sMonthT) THEN
	F_MessageChk(1,'[회계월(TO)]')
	dw_ip.SetColumn("acc_mmt")
	dw_ip.SetFocus()
   return
END IF

IF F_DateChk(sYearT+sMonthT+'01') = -1 THEN
	F_MessageChk(21,'[회계년월(TO)]')
	dw_ip.SetColumn("acc_mmt")
	dw_ip.SetFocus()
   return
end if

IF sYearF+sMonthF = sYearT+sMonthT THEN
	F_MessageChk(16,'[FROM년월 = TO년월]')
	dw_ip.SetColumn("acc_mm")
	dw_ip.SetFocus()
	Return
END IF

if flag = "1" and Integer(sMonthF) = 12  then
   messagebox("확인","12월은 이월처리할 수 없습니다")
   dw_ip.Setfocus()
   return	
end if

//if flag = "2" and Integer(sMonthF) = 1  then
//   messagebox("확인","1월은 취소처리할 수 없습니다")
//   dw_ip.Setfocus()
//   return	
//end if

if flag = "1" then													/*이월처리*/
   em_1.Text = sYearF + '.' + sMonthF
   em_2.Text = sYearT + '.' + sMonthT
else							
   em_1.Text = sYearT + '.' + sMonthT
   em_2.Text = sYearF + '.' + sMonthF
end if

if trim(sYesanGbn) = "" or Isnull(sYesanGbn) then 
   sYesanGbn = '%'     
else
	IF IsNull(F_Get_Refferance('AB',sYesanGbn)) THEN
      F_MessageChk(20,'[예산구분]')
		dw_ip.SetColumn("ye_gu")
		dw_ip.SetFocus()
      return		
   end if
end if

if trim(sDept) = "" or Isnull(sDept) then
   sDept = '%'  
else
	IF IsNull(F_Get_Personlst('3',sDept,'%')) THEN
      F_MessageChk(20,'[배정부서]')
		dw_ip.SetColumn("dept_cd")
		dw_ip.SetFocus()
      return		
   end if
end if

if sAcc1 = "" OR Isnull(sAcc1) OR sAcc2 = "" OR IsNull(sAcc2) then
   sAcc1 = '%'
   sAcc2 = '%'
end if

if flag = "1" then  //자동이월처리//
   dw_ret1.SetRedraw(false)
   rowno = dw_ret1.Retrieve(sSaupj, sYearF, sMonthF, sYesanGbn, & 
	                         sDept, sAcc1, sAcc2)
   if rowno < 1 then
      messagebox("확인","이월처리할 자료가 없습니다!")
      dw_ret1.SetRedraw(true)		
      return
   end if
   dw_ret1.SetRedraw(true)	
	
	dw_from.Retrieve(sSaupj, sYearF, sMonthF, sDept, sAcc1, sAcc2,sYesanGbn)
	dw_to.Retrieve(sSaupj, sYearT, sMonthT, sDept, sAcc1, sAcc2,sYesanGbn)
else                //이월취소처리//
   dw_ret2.SetRedraw(false)			
   rowno = dw_ret2.Retrieve(sSaupj,sYearF,sMonthF,sYesanGbn, &
	                         sDept,sAcc1,sAcc2)
   if rowno < 1 then
      messagebox("확인","이월취소할 자료가 없습니다!")
      dw_ret2.SetRedraw(true)				
      return
   end if
   dw_ret2.SetRedraw(true)
	
	dw_from.Retrieve(sSaupj, sYearF, sMonthF, sDept, sAcc1, sAcc2,sYesanGbn)
	dw_to.Retrieve(sSaupj, sYearT, sMonthT, sDept, sAcc1, sAcc2,sYesanGbn)
end if

p_mod.Enabled = True

end event

type p_del from w_inherite`p_del within w_kbgb02
boolean visible = false
integer x = 3685
integer y = 376
integer taborder = 100
end type

type p_mod from w_inherite`p_mod within w_kbgb02
integer x = 4251
integer y = 12
integer taborder = 80
string pointer = "C:\erpman\cur\create.cur"
string picturename = "C:\erpman\image\처리_up.gif"
end type

event ue_lbuttondown;PictureName = "C:\erpman\image\처리_dn.gif"
end event

event ue_lbuttonup;PictureName = "C:\erpman\image\처리_up.gif"
end event

event clicked;call super::clicked;String sSaupj,sYearF,sMonthF,sYearT,sMonthT

if dw_ip.AcceptText() = -1 then return 

sSaupj    = dw_ip.Getitemstring(dw_ip.Getrow(),"saupj")
sYearF    = dw_ip.Getitemstring(dw_ip.Getrow(),"acc_yy")
sMonthF   = dw_ip.Getitemstring(dw_ip.Getrow(),"acc_mm")

sYearT    = dw_ip.Getitemstring(dw_ip.Getrow(),"acc_yyt")
sMonthT   = dw_ip.Getitemstring(dw_ip.Getrow(),"acc_mmt")

IF Flag = '1' THEN								/*이월 처리*/
	IF dw_ret1.RowCount() <=0 THEN Return
	
	IF Wf_Iwol(sSaupj,sYearF,sMonthF,sYearT,sMonthT) = -1 THEN 
		Rollback;
		Return
	END IF
ELSE													/*이월 취소*/
	IF dw_ret2.RowCount() <=0 THEN Return
	
	IF Wf_CanCel_Iwol(sSaupj,sYearF,sMonthF,sYearT,sMonthT) = -1 THEN 
		Rollback;
		Return
	END IF
END IF

w_mdi_frame.sle_msg.text = '처리 완료!!'
end event

type cb_exit from w_inherite`cb_exit within w_kbgb02
end type

type cb_mod from w_inherite`cb_mod within w_kbgb02
end type

type cb_ins from w_inherite`cb_ins within w_kbgb02
end type

type cb_del from w_inherite`cb_del within w_kbgb02
end type

type cb_inq from w_inherite`cb_inq within w_kbgb02
end type

type cb_print from w_inherite`cb_print within w_kbgb02
end type

type st_1 from w_inherite`st_1 within w_kbgb02
end type

type cb_can from w_inherite`cb_can within w_kbgb02
end type

type cb_search from w_inherite`cb_search within w_kbgb02
end type







type gb_button1 from w_inherite`gb_button1 within w_kbgb02
end type

type gb_button2 from w_inherite`gb_button2 within w_kbgb02
end type

type dw_from from datawindow within w_kbgb02
boolean visible = false
integer x = 2373
integer y = 2444
integer width = 1271
integer height = 96
boolean titlebar = true
string title = "예산배정갱신(FROM의 차월이월 ADD)"
string dataobject = "dw_kbgb02_5"
boolean livescroll = true
end type

type dw_ret1 from datawindow within w_kbgb02
integer x = 55
integer y = 288
integer width = 2199
integer height = 1916
integer taborder = 30
string dataobject = "dw_kbgb02_2"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;Long ll_rowcnt
Integer lClickedRow
String lKeydownType

lClickedRow = Row
If lClickedRow = 0 then Return

If KeyDown(keyshift!) then
	wf_Shift_light(this, lClickedRow)
ElseIf KeyDown(keycontrol!) then
	If this.GetSelectedRow(lClickedRow -1) = lClickedRow then
		this.SelectRow(lClickedRow, False)
	Else
		this.SelectRow(lClickedRow, True)
	End If
Else 
	this.SelectRow(0,False)
	this.SelectRow(lClickedRow, True)
End If

il_lastClickedRow = lClickedRow

this.SetRow(row)
this.ScrolltoRow(row)
end event

type dw_to from datawindow within w_kbgb02
boolean visible = false
integer x = 2373
integer y = 2344
integer width = 1271
integer height = 96
boolean titlebar = true
string title = "예산배정갱신(TO의 전월이월 ADD)"
string dataobject = "dw_kbgb02_4"
boolean livescroll = true
end type

type em_2 from editmask within w_kbgb02
integer x = 2377
integer y = 244
integer width = 274
integer height = 52
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
boolean border = false
alignment alignment = center!
maskdatatype maskdatatype = datetimemask!
string mask = "yyyy.mm"
end type

type em_1 from editmask within w_kbgb02
integer x = 101
integer y = 244
integer width = 288
integer height = 56
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
boolean border = false
alignment alignment = center!
maskdatatype maskdatatype = datemask!
string mask = "yyyy.mm"
end type

type rb_2 from radiobutton within w_kbgb02
integer x = 3593
integer y = 132
integer width = 443
integer height = 72
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "이월취소처리"
borderstyle borderstyle = stylelowered!
end type

event clicked;flag = "2"

dw_ret1.Reset()
dw_ret2.Reset()

em_1.Text = '0000.00'
em_2.Text = '0000.00'

gb_2.Text = '[         ] TO'
gb_5.Text = '[        ] FROM'
end event

type rb_1 from radiobutton within w_kbgb02
integer x = 3593
integer y = 48
integer width = 402
integer height = 72
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "이월처리"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;flag = "1"

dw_ret1.Reset()
dw_ret2.Reset()

em_1.Text = '0000.00'
em_2.Text = '0000.00'

gb_2.Text = '[         ] FROM'
gb_5.Text = '[        ] TO'

end event

type gb_5 from groupbox within w_kbgb02
integer x = 2318
integer y = 240
integer width = 2235
integer height = 1980
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "[        ] TO"
borderstyle borderstyle = stylelowered!
end type

type gb_2 from groupbox within w_kbgb02
integer x = 37
integer y = 240
integer width = 2235
integer height = 1980
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
string text = "[         ] FROM"
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_kbgb02
integer x = 3538
integer width = 526
integer height = 216
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
borderstyle borderstyle = styleraised!
end type

type dw_ip from datawindow within w_kbgb02
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 14
integer y = 16
integer width = 3534
integer height = 208
integer taborder = 10
string dataobject = "dw_kbgb02_1"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)

Return 1
end event

event ue_key;IF keydown(keyF1!) or keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event editchanged;p_mod.Enabled = False
end event

event rbuttondown;String ls_gj1, ls_gj2

SetNull(gs_code)
SetNull(gs_codename)

IF this.GetColumnName() = "acc1_cd" THEN 
	dw_ip.AcceptText()
	gs_code = Trim(dw_ip.GetItemString(dw_ip.GetRow(), "acc1_cd"))
	IF IsNull(gs_code) then
		gs_code =""
	end if
	
	Open(W_KFE01OM0_POPUP)
	if gs_code <> "" and Not IsNull(gs_code) then
		dw_ip.SetItem(dw_ip.GetRow(), "acc1_cd", Left(gs_code,5))
		dw_ip.SetItem(dw_ip.GetRow(), "acc2_cd", Mid(gs_code,6,2))
		dw_ip.SetItem(dw_ip.GetRow(), "accname", gs_codename)
	end if
END IF

dw_ip.Setfocus()
end event

event itemchanged;string ls_acc1_cd, ls_acc2_cd, sqlfd3, sqlfd4, ls_dept_cd, snull, &
       get_code, get_name,sYear,sMonth,sNextYm
Int rowno

SetNull(snull)

if this.GetColumnName() = 'dept_cd' then 
	ls_dept_cd = this.GetText()
	
   if isnull(ls_dept_cd) or trim(ls_dept_cd) = '' then return 
	
	SELECT "KFE03OM0"."DEPTCODE"  	INTO :get_code
			FROM "KFE03OM0"  
			WHERE "KFE03OM0"."DEPTCODE" = :ls_dept_cd   ;

	if sqlca.sqlcode <> 0 then 
		F_MessageChk(20,'[예산부서]')						
		this.SetItem(dw_ip.GetRow(), 'dept_cd', snull)
		return 1
	end if 
end if

if this.GetcolumnName() = 'acc1_cd' then 
	ls_acc1_cd = this.GetText()
	ls_acc2_cd = dw_ip.Getitemstring(row,"acc2_cd")

//계정과목명 표시//
  SELECT "KFZ01OM0"."ACC1_NM","KFZ01OM0"."YACC2_NM"
    INTO :sqlfd3, :sqlfd4
    FROM "KFZ01OM0"  
   WHERE "KFZ01OM0"."ACC1_CD" = :ls_acc1_cd and
         "KFZ01OM0"."ACC2_CD" = :ls_acc2_cd ;
  if sqlca.sqlcode = 0 then
//     dw_ip.Setitem(dw_ip.Getrow(),"accname",sqlfd3 + " - " + sqlfd4)
		  dw_ip.Setitem(dw_ip.Getrow(),"accname", sqlfd4)

  else
     dw_ip.Setitem(dw_ip.Getrow(),"accname"," ")
  end if
end if  

if this.GetcolumnName() = 'acc2_cd' then 
	ls_acc1_cd = dw_ip.Getitemstring(row,"acc1_cd")
	ls_acc2_cd = this.GetText()


//계정과목명 표시//
  SELECT "KFZ01OM0"."ACC1_NM","KFZ01OM0"."YACC2_NM"
    INTO :sqlfd3, :sqlfd4
    FROM "KFZ01OM0"  
   WHERE "KFZ01OM0"."ACC1_CD" = :ls_acc1_cd and
         "KFZ01OM0"."ACC2_CD" = :ls_acc2_cd ;
  if sqlca.sqlcode = 0 then
//     dw_ip.Setitem(dw_ip.Getrow(),"accname",sqlfd3 + " - " + sqlfd4)
		  dw_ip.Setitem(dw_ip.Getrow(),"accname", sqlfd4)

  else
     dw_ip.Setitem(dw_ip.Getrow(),"accname"," ")
  end if
end if 

if this.GetColumnName() = 'acc_yy' then
	sYear  = this.GetText()
	if sYear = '' or IsNull(sYear) then
		this.SetItem(1,"acc_yyt", sNull)
		Return
	end if
	
	sMonth = this.GetItemString(1,"acc_mm") 
	if sMonth = '' or IsNull(sMonth) then
		this.SetItem(1,"acc_mmt", sNull)
		Return
	end if
	
	if sMonth = '12' then
		messagebox("확인","12월은 이월처리할 수 없습니다")
		this.SetItem(1,"acc_mm", sNull)		
		this.SetItem(1,"acc_mmt", sNull)
		Return 1
	end if
	
	sNextYm = sYear + String(Integer(sMonth) + 1,'00')
	
	this.SetItem(1,"acc_yyt", Left(sNextYm,4))
	this.SetItem(1,"acc_mmt", Right(sNextYm,2))
end if

if this.GetColumnName() = 'acc_mm' then
	sMonth = this.GetText()
	if sMonth = '' or IsNull(sMonth) then
		this.SetItem(1,"acc_mmt", sNull)
		Return
	end if
	
	sYear  = this.GetItemString(1,"acc_yy")
	if sYear = '' or IsNull(sYear) then
		this.SetItem(1,"acc_yyt", sNull)
		Return
	end if
	
	if sMonth = '12' then
		messagebox("확인","12월은 이월처리할 수 없습니다")
		this.SetItem(1,"acc_mm", sNull)		
		this.SetItem(1,"acc_mmt", sNull)
		Return 1
	end if
	
	sNextYm = sYear + String(Integer(sMonth) + 1,'00')
	
	this.SetItem(1,"acc_yyt", Left(sNextYm,4))
	this.SetItem(1,"acc_mmt", Right(sNextYm,2))
end if

end event

event itemerror;return 1
end event

event getfocus;this.AcceptText()
end event

type rr_1 from roundrectangle within w_kbgb02
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 224
integer width = 2272
integer height = 2020
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_kbgb02
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2304
integer y = 224
integer width = 2272
integer height = 2020
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_ret2 from datawindow within w_kbgb02
integer x = 2331
integer y = 288
integer width = 2199
integer height = 1916
integer taborder = 50
boolean bringtotop = true
string dataobject = "dw_kbgb02_3"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;Long ll_rowcnt
Integer lClickedRow
String lKeydownType

lClickedRow = Row
If lClickedRow = 0 then Return

If KeyDown(keyshift!) then
	wf_Shift_light(this, lClickedRow)
ElseIf KeyDown(keycontrol!) then
	If this.GetSelectedRow(lClickedRow -1) = lClickedRow then
		this.SelectRow(lClickedRow, False)
	Else
		this.SelectRow(lClickedRow, True)
	End If
Else 
	this.SelectRow(0,False)
	this.SelectRow(lClickedRow, True)
End If

il_lastClickedRow = lClickedRow

this.SetRow(row)
this.ScrolltoRow(row)
end event

