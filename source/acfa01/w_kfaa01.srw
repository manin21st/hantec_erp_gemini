$PBExportHeader$w_kfaa01.srw
$PBExportComments$고정자산 상각율 등록
forward
global type w_kfaa01 from w_inherite
end type
type dw_1 from datawindow within w_kfaa01
end type
type dw_2 from datawindow within w_kfaa01
end type
type rr_1 from roundrectangle within w_kfaa01
end type
type rr_2 from roundrectangle within w_kfaa01
end type
end forward

global type w_kfaa01 from w_inherite
string title = "상각률 등록"
dw_1 dw_1
dw_2 dw_2
rr_1 rr_1
rr_2 rr_2
end type
global w_kfaa01 w_kfaa01

type variables

end variables

forward prototypes
public subroutine wf_retrieve_mode (string mode)
end prototypes

public subroutine wf_retrieve_mode (string mode);
dw_1.SetRedraw(False)
IF mode ="조회" THEN
	dw_1.SetTabOrder("kfnyr",0)
	dw_1.SetColumn("kfrrat")
ELSE
	dw_1.SetTabOrder("kfnyr",10)
	dw_1.SetColumn("kfnyr")
END IF
dw_1.SetRedraw(True)
dw_1.SetFocus()
end subroutine

on open;call w_inherite::open;dw_1.SetTransObject(SQLCA)
dw_1.Reset()
dw_1.InsertRow(0)
dw_1.SetFocus()

dw_2.SetTransObject(SQLCA)
dw_2.Retrieve()


end on

on w_kfaa01.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_2=create dw_2
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.rr_1
this.Control[iCurrent+4]=this.rr_2
end on

on w_kfaa01.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.rr_1)
destroy(this.rr_2)
end on

type dw_insert from w_inherite`dw_insert within w_kfaa01
boolean visible = false
integer x = 59
integer y = 2672
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kfaa01
boolean visible = false
integer x = 3771
integer y = 2864
end type

type p_addrow from w_inherite`p_addrow within w_kfaa01
boolean visible = false
integer x = 3598
integer y = 2864
end type

type p_search from w_inherite`p_search within w_kfaa01
boolean visible = false
integer x = 3515
integer y = 2704
end type

type p_ins from w_inherite`p_ins within w_kfaa01
integer x = 3749
end type

event p_ins::clicked;call super::clicked;dw_1.reset()
dw_1.Insertrow(0)

w_mdi_frame.sle_msg.text = ""

dw_2.SelectRow(0,False)
ib_any_typing =False
sModStatus ="I"
wf_retrieve_mode(sModStatus)

//decimal{3} dkfrrat, dkfrarat, dkfsrrat, dkfsarat
//decimal    DKFNYR, RET_NYR
//long row_num
//
//setpointer(hourglass!)
//dw_1.AcceptText()
//row_num  = dw_1.Getrow()
//DKFNYR   = dw_1.GetitemDecimal(row_num,"KFNYR")
//dkfrrat  = dw_1.GetitemDecimal(row_num,"kfrrat")
//dkfrarat = dw_1.GetitemDecimal(row_num,"kfrarat")
//dkfsrrat = dw_1.GetitemDecimal(row_num,"kfsrrat")
//dkfsarat = dw_1.GetitemDecimal(row_num,"kfsarat")
//
//  SELECT "KFA01OM0"."KFNYR"  
//    INTO :RET_NYR 
//    FROM "KFA01OM0"  
//   WHERE "KFA01OM0"."KFNYR" = :DKFNYR   ;
//
//if SQLCA.SQLCODE = 0 then
//   sle_msg.text   = "입력한 내용년수는 이미 DataBase 에 존재합니다."
//   Messagebox("확 인","이미 입력된 자료입니다. !!!")
//   dw_1.setfocus()	 
//   Return
//end if
//
//if  DKFNYR = 0 or Isnull(DKFNYR) then
//    sle_msg.text   = "내용년수는 반드시 입력 되어야 합니다. 범위 : 1 .. 99 년까지"
//    Messagebox("확 인","내용년수를 입력하시오. !!!")
//    dw_1.setfocus()
//    Return
//end if
//if  DKFNYR < 0 then
//    sle_msg.text   = "내용년수는 반드시 Zero 보다 커야 합니다. 범위 : 1 .. 99 년까지"
//    Messagebox("확 인","내용년수를 확인하시오. !!!")
//    dw_1.setfocus()
//    Return
//end if
//
//if  dkfrrat =0 or dkfrarat =0 or dkfsrrat =0 or dkfsarat =0 &
//    or Isnull(dkfrrat) or isnull(dkfrarat) or isnull(dkfsrrat) or isnull(dkfsarat) then
//    sle_msg.text   = "상각률을 입력하는 필드는 전부가 필수 입력입니다."
//    Messagebox("확 인","상각률을 입력하시오. !!!")
//    dw_1.setfocus()
//    Return
//end if
//if  dkfrrat > 1 or dkfrarat > 1 or dkfsrrat > 1 or dkfsarat > 1  then
//    sle_msg.text   = "상각률은 1 보다 클수가 없습니다."
//    Messagebox("확 인","상각률을 확인하시오. !!!")
//    dw_1.setfocus()
//    Return
//end if
//
//if dw_1.Update() =  1 then
//   dw_1.reset()
//   dw_1.Insertrow(0)
//   dw_2.Retrieve()
//   DW_2.SCROLLTOROW(DKFNYR)
//   sle_msg.text   = "자료가 저장되었습니다."
//   commit;
//else
//   sle_msg.text   = "실패원인 : " + SQLCA.SQLERRTEXT
//   Messagebox("확 인","저장 실패 !!!")
//   Rollback;
//end if
//ib_any_typing =False
//dw_1.setfocus()
end event

type p_exit from w_inherite`p_exit within w_kfaa01
end type

type p_can from w_inherite`p_can within w_kfaa01
end type

event p_can::clicked;call super::clicked;dw_1.reset()
dw_1.Insertrow(0)

p_ins.Enabled = True
p_ins.PictureName = "C:\erpman\image\추가_up.gif"

w_mdi_frame.sle_msg.text = ""

dw_2.SelectRow(0,False)
ib_any_typing =False
sModStatus ="I"
wf_retrieve_mode(sModStatus)
end event

type p_print from w_inherite`p_print within w_kfaa01
boolean visible = false
integer x = 3689
integer y = 2704
end type

type p_inq from w_inherite`p_inq within w_kfaa01
boolean visible = false
integer x = 3863
integer y = 2704
end type

type p_del from w_inherite`p_del within w_kfaa01
end type

event p_del::clicked;call super::clicked;Long dkfnyr

IF dw_2.GetSelectedRow(0) <= 0 THEN 
	MessageBox("확 인","삭제할 자료를 선택하세요.!!")
	Return
END IF

dkfnyr =dw_2.GetItemNumber(dw_2.GetSelectedRow(0),"kfnyr")

IF Messagebox("확 인","자료를 삭제하시겠습니까 ?",Question!,OKCancel!,2) = 2 THEN RETURN

dw_1.DeleteRow(0)
IF dw_1.update() = 1 THEN
//	dw_2.DeleteRow(0)
   dw_1.reset()
   dw_1.Insertrow(0)
   dw_2.Retrieve()
   DW_2.SCROLLTOROW(DKFNYR)
   w_mdi_frame.sle_msg.text   = "자료가 삭제되었습니다"
   COMMIT;
ELSE
   Messagebox("확 인","자료 삭제를 실패하였습니다.!!")
   ROLLBACK;
	RETURN
END IF

ib_any_typing =False
sModStatus ="I"
wf_retrieve_mode(sModStatus)
end event

type p_mod from w_inherite`p_mod within w_kfaa01
end type

event p_mod::clicked;call super::clicked;decimal{3} dkfsrrat, dkfsarat
decimal    DKFNYR, RET_NYR
long row_num

dw_1.AcceptText()

row_num  = dw_1.Getrow()
DKFNYR   = dw_1.GetitemDecimal(row_num,"KFNYR")
dkfsrrat = dw_1.GetitemDecimal(row_num,"kfsrrat")
dkfsarat = dw_1.GetitemDecimal(row_num,"kfsarat")

if  DKFNYR = 0 or Isnull(DKFNYR) then
    w_mdi_frame.sle_msg.text   = "내용년수는 반드시 입력 되어야 합니다. 범위 : 1 .. 99 년까지"
    Messagebox("확 인","내용년수를 입력하시오. !!!")
	 dw_1.SetColumn("kfnyr")
    dw_1.setfocus()
    Return
end if

if  DKFNYR < 0 then
    w_mdi_frame.sle_msg.text   = "내용년수는 반드시 Zero 보다 커야 합니다. 범위 : 1 .. 99 년까지" 
    Messagebox("확 인","내용년수를 확인하시오. !!!")
	 dw_1.SetColumn("kfnyr")
    dw_1.setfocus()
    Return
end if

SELECT "KFA01OM0"."KFNYR"  
    INTO :RET_NYR  
    FROM "KFA01OM0"  
   WHERE "KFA01OM0"."KFNYR" = :DKFNYR   ;

IF SQLCA.SQLCODE = 0 THEN
	IF sModStatus ="I" THEN
		f_messagechk(10,'')
		Return
	END IF
END IF

if  dkfsrrat =0 or dkfsarat =0 &
    or isnull(dkfsrrat) or isnull(dkfsarat) then
    w_mdi_frame.sle_msg.text   = "95년도 상각률은 필수 입력입니다."
    Messagebox("확 인","상각률을 입력하시오. !!!")
    dw_1.setfocus()
    Return
end if
if  dkfsrrat > 1 or dkfsarat > 1  then
    w_mdi_frame.sle_msg.text   = "상각률은 1 보다 클수가 없습니다."
    Messagebox("확 인","상각률을 확인하시오. !!!")
    dw_1.setfocus()
    Return
end if

IF dw_1.Update() = 1 THEN
   dw_1.reset()
   dw_1.Insertrow(0)
   dw_2.Retrieve()
   DW_2.SCROLLTOROW(DKFNYR)
   w_mdi_frame.sle_msg.text   = "자료가 저장되었습니다"
   COMMIT;
ELSE
   Messagebox("확 인","자료 저장을 실패했습니다. !!")
   ROLLBACK;
	Return
END IF

ib_any_typing =False
dw_1.Setfocus()
sModStatus ="I"

wf_retrieve_mode(sModStatus)

end event

type cb_exit from w_inherite`cb_exit within w_kfaa01
boolean visible = false
integer x = 3095
integer y = 2716
integer taborder = 60
end type

type cb_mod from w_inherite`cb_mod within w_kfaa01
boolean visible = false
integer x = 2011
integer y = 2716
end type

event cb_mod::clicked;call super::clicked;decimal{3} dkfsrrat, dkfsarat
decimal    DKFNYR, RET_NYR
long row_num

dw_1.AcceptText()

row_num  = dw_1.Getrow()
DKFNYR   = dw_1.GetitemDecimal(row_num,"KFNYR")
dkfsrrat = dw_1.GetitemDecimal(row_num,"kfsrrat")
dkfsarat = dw_1.GetitemDecimal(row_num,"kfsarat")

if  DKFNYR = 0 or Isnull(DKFNYR) then
    sle_msg.text   = "내용년수는 반드시 입력 되어야 합니다. 범위 : 1 .. 99 년까지"
    Messagebox("확 인","내용년수를 입력하시오. !!!")
	 dw_1.SetColumn("kfnyr")
    dw_1.setfocus()
    Return
end if

if  DKFNYR < 0 then
    sle_msg.text   = "내용년수는 반드시 Zero 보다 커야 합니다. 범위 : 1 .. 99 년까지" 
    Messagebox("확 인","내용년수를 확인하시오. !!!")
	 dw_1.SetColumn("kfnyr")
    dw_1.setfocus()
    Return
end if

SELECT "KFA01OM0"."KFNYR"  
    INTO :RET_NYR  
    FROM "KFA01OM0"  
   WHERE "KFA01OM0"."KFNYR" = :DKFNYR   ;

IF SQLCA.SQLCODE = 0 THEN
	IF sModStatus ="I" THEN
		f_messagechk(10,'')
		Return
	END IF
END IF

if  dkfsrrat =0 or dkfsarat =0 &
    or isnull(dkfsrrat) or isnull(dkfsarat) then
    sle_msg.text   = "95년도 상각률은 필수 입력입니다."
    Messagebox("확 인","상각률을 입력하시오. !!!")
    dw_1.setfocus()
    Return
end if
if  dkfsrrat > 1 or dkfsarat > 1  then
    sle_msg.text   = "상각률은 1 보다 클수가 없습니다."
    Messagebox("확 인","상각률을 확인하시오. !!!")
    dw_1.setfocus()
    Return
end if

IF dw_1.Update() = 1 THEN
   dw_1.reset()
   dw_1.Insertrow(0)
   dw_2.Retrieve()
   DW_2.SCROLLTOROW(DKFNYR)
   sle_msg.text   = "자료가 저장되었습니다"
   COMMIT;
ELSE
   Messagebox("확 인","자료 저장을 실패했습니다. !!")
   ROLLBACK;
	Return
END IF

ib_any_typing =False
dw_1.Setfocus()
sModStatus ="I"

wf_retrieve_mode(sModStatus)

end event

type cb_ins from w_inherite`cb_ins within w_kfaa01
boolean visible = false
integer x = 64
integer y = 2716
integer width = 361
string text = "추가(&I)"
end type

event cb_ins::clicked;call super::clicked;dw_1.reset()
dw_1.Insertrow(0)

sle_msg.text = ""

dw_2.SelectRow(0,False)
ib_any_typing =False
sModStatus ="I"
wf_retrieve_mode(sModStatus)

//decimal{3} dkfrrat, dkfrarat, dkfsrrat, dkfsarat
//decimal    DKFNYR, RET_NYR
//long row_num
//
//setpointer(hourglass!)
//dw_1.AcceptText()
//row_num  = dw_1.Getrow()
//DKFNYR   = dw_1.GetitemDecimal(row_num,"KFNYR")
//dkfrrat  = dw_1.GetitemDecimal(row_num,"kfrrat")
//dkfrarat = dw_1.GetitemDecimal(row_num,"kfrarat")
//dkfsrrat = dw_1.GetitemDecimal(row_num,"kfsrrat")
//dkfsarat = dw_1.GetitemDecimal(row_num,"kfsarat")
//
//  SELECT "KFA01OM0"."KFNYR"  
//    INTO :RET_NYR 
//    FROM "KFA01OM0"  
//   WHERE "KFA01OM0"."KFNYR" = :DKFNYR   ;
//
//if SQLCA.SQLCODE = 0 then
//   sle_msg.text   = "입력한 내용년수는 이미 DataBase 에 존재합니다."
//   Messagebox("확 인","이미 입력된 자료입니다. !!!")
//   dw_1.setfocus()	 
//   Return
//end if
//
//if  DKFNYR = 0 or Isnull(DKFNYR) then
//    sle_msg.text   = "내용년수는 반드시 입력 되어야 합니다. 범위 : 1 .. 99 년까지"
//    Messagebox("확 인","내용년수를 입력하시오. !!!")
//    dw_1.setfocus()
//    Return
//end if
//if  DKFNYR < 0 then
//    sle_msg.text   = "내용년수는 반드시 Zero 보다 커야 합니다. 범위 : 1 .. 99 년까지"
//    Messagebox("확 인","내용년수를 확인하시오. !!!")
//    dw_1.setfocus()
//    Return
//end if
//
//if  dkfrrat =0 or dkfrarat =0 or dkfsrrat =0 or dkfsarat =0 &
//    or Isnull(dkfrrat) or isnull(dkfrarat) or isnull(dkfsrrat) or isnull(dkfsarat) then
//    sle_msg.text   = "상각률을 입력하는 필드는 전부가 필수 입력입니다."
//    Messagebox("확 인","상각률을 입력하시오. !!!")
//    dw_1.setfocus()
//    Return
//end if
//if  dkfrrat > 1 or dkfrarat > 1 or dkfsrrat > 1 or dkfsarat > 1  then
//    sle_msg.text   = "상각률은 1 보다 클수가 없습니다."
//    Messagebox("확 인","상각률을 확인하시오. !!!")
//    dw_1.setfocus()
//    Return
//end if
//
//if dw_1.Update() =  1 then
//   dw_1.reset()
//   dw_1.Insertrow(0)
//   dw_2.Retrieve()
//   DW_2.SCROLLTOROW(DKFNYR)
//   sle_msg.text   = "자료가 저장되었습니다."
//   commit;
//else
//   sle_msg.text   = "실패원인 : " + SQLCA.SQLERRTEXT
//   Messagebox("확 인","저장 실패 !!!")
//   Rollback;
//end if
//ib_any_typing =False
//dw_1.setfocus()
end event

type cb_del from w_inherite`cb_del within w_kfaa01
boolean visible = false
integer x = 2373
integer y = 2716
end type

event cb_del::clicked;call super::clicked;Long dkfnyr

IF dw_2.GetSelectedRow(0) <= 0 THEN 
	MessageBox("확 인","삭제할 자료를 선택하세요.!!")
	Return
END IF

dkfnyr =dw_2.GetItemNumber(dw_2.GetSelectedRow(0),"kfnyr")

IF Messagebox("확 인","자료를 삭제하시겠습니까 ?",Question!,OKCancel!,2) = 2 THEN RETURN

dw_1.DeleteRow(0)
IF dw_1.update() = 1 THEN
//	dw_2.DeleteRow(0)
   dw_1.reset()
   dw_1.Insertrow(0)
   dw_2.Retrieve()
   DW_2.SCROLLTOROW(DKFNYR)
   sle_msg.text   = "자료가 삭제되었습니다"
   COMMIT;
ELSE
   Messagebox("확 인","자료 삭제를 실패하였습니다.!!")
   ROLLBACK;
	RETURN
END IF

ib_any_typing =False
sModStatus ="I"
wf_retrieve_mode(sModStatus)
end event

type cb_inq from w_inherite`cb_inq within w_kfaa01
boolean visible = false
integer x = 1792
integer y = 2672
boolean enabled = false
end type

type cb_print from w_inherite`cb_print within w_kfaa01
boolean visible = false
integer x = 2181
integer y = 2696
boolean enabled = false
end type

on cb_print::clicked;call w_inherite`cb_print::clicked;//dw_prt.reset()
//
//if dw_prt.retrieve() <= 0 then
//   messagebox("확 인","출력할 자료가 없습니다. !!!")
//   return
//end if
//
//dw_prt.print()
//
end on

type st_1 from w_inherite`st_1 within w_kfaa01
end type

type cb_can from w_inherite`cb_can within w_kfaa01
boolean visible = false
integer x = 2734
integer y = 2716
integer taborder = 50
boolean cancel = true
end type

event cb_can::clicked;call super::clicked;dw_1.reset()
dw_1.Insertrow(0)

cb_ins.Enabled = True

sle_msg.text = ""

dw_2.SelectRow(0,False)
ib_any_typing =False
sModStatus ="I"
wf_retrieve_mode(sModStatus)
end event

type cb_search from w_inherite`cb_search within w_kfaa01
boolean visible = false
integer x = 2542
integer y = 2704
boolean enabled = false
end type

type dw_datetime from w_inherite`dw_datetime within w_kfaa01
boolean visible = false
end type

type sle_msg from w_inherite`sle_msg within w_kfaa01
boolean visible = false
end type

type gb_10 from w_inherite`gb_10 within w_kfaa01
boolean visible = false
end type

type gb_button1 from w_inherite`gb_button1 within w_kfaa01
boolean visible = false
integer x = 23
integer y = 2660
integer width = 439
end type

type gb_button2 from w_inherite`gb_button2 within w_kfaa01
boolean visible = false
integer x = 1975
integer y = 2660
integer width = 1495
end type

type dw_1 from datawindow within w_kfaa01
event ue_pressenter pbm_dwnprocessenter
integer x = 649
integer y = 208
integer width = 3218
integer height = 164
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_kfaa01_1"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = styleraised!
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;decimal  DKRAT
long row_num

dw_1.AcceptText()
row_num  = dw_1.Getrow()

DKRAT = dw_1.GetitemDecimal(row_num,"kfsarat")
if DKRAT = 0 OR Isnull(DKRAT) then
   DKRAT = dw_1.GetitemDecimal(row_num,"kfrarat")
   dw_1.Setitem(row_num, "kfsarat", DKRAT)
End if
end event

event editchanged;ib_any_typing =True
end event

type dw_2 from datawindow within w_kfaa01
integer x = 631
integer y = 424
integer width = 3223
integer height = 1768
boolean bringtotop = true
string dataobject = "d_kfaa01_2"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;long row_num
dec dkfnyr

row_num = dw_2.Getclickedrow()

if row_num <= 0 then return

this.selectrow(0,False)
this.selectrow(row_num,true)
dkfnyr = dw_2.Getitemdecimal(row_num,"kfnyr")
dw_1.retrieve(dkfnyr)

ib_any_typing =False
sModStatus ="M"
wf_retrieve_mode(sModStatus)
end event

type rr_1 from roundrectangle within w_kfaa01
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 617
integer y = 180
integer width = 3287
integer height = 220
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_2 from roundrectangle within w_kfaa01
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 622
integer y = 416
integer width = 3282
integer height = 1796
integer cornerheight = 40
integer cornerwidth = 46
end type

