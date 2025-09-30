$PBExportHeader$w_pdt_02020.srw
$PBExportComments$수주자료 조정
forward
global type w_pdt_02020 from w_inherite
end type
type dw_list from datawindow within w_pdt_02020
end type
type dw_detail from datawindow within w_pdt_02020
end type
type dw_1 from u_d_popup_sort within w_pdt_02020
end type
type rb_1 from radiobutton within w_pdt_02020
end type
type rb_2 from radiobutton within w_pdt_02020
end type
type p_1 from picture within w_pdt_02020
end type
type rr_1 from roundrectangle within w_pdt_02020
end type
type rr_2 from roundrectangle within w_pdt_02020
end type
type rr_3 from roundrectangle within w_pdt_02020
end type
type dw_2 from datawindow within w_pdt_02020
end type
type rr_4 from roundrectangle within w_pdt_02020
end type
end forward

global type w_pdt_02020 from w_inherite
integer width = 4640
integer height = 2472
string title = "수주자료 조정"
dw_list dw_list
dw_detail dw_detail
dw_1 dw_1
rb_1 rb_1
rb_2 rb_2
p_1 p_1
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
dw_2 dw_2
rr_4 rr_4
end type
global w_pdt_02020 w_pdt_02020

forward prototypes
public function integer wf_requiredchk ()
public subroutine wf_reset ()
end prototypes

public function integer wf_requiredchk ();Long 	  lrow, lcnt
Decimal {3} miqty

sle_msg.text = "자료를 check하고 있읍니다."

if dw_insert.accepttext() = -1 then return -1
lrow = dw_insert.rowcount()

For lcnt = 1 to lrow
	 miqty 	= dw_insert.getitemdecimal(lcnt, "momord_sqty")
	  
	 if miqty = 0 or isnull(miqty) then
		 f_message_chk(30,'[연결수량]')		 
		 dw_insert.scrolltorow(lcnt)
		 dw_insert.setcolumn("miqty")		 
		 dw_insert.setfocus()
		 return -1		
	 end if	 
Next

return 1
end function

public subroutine wf_reset ();rollback;

//cb_search.enabled = false
p_search.enabled 	= false
p_search.picturename = 'C:\erpman\image\연결_d.gif'

//cb_print.enabled = false
p_print.enabled 	= false
p_print.picturename = 'C:\erpman\image\삭제_d.gif'

dw_list.reset()
dw_insert.reset()
dw_detail.reset()

ib_any_typing = false

//dw_head.setitem(1, 'pordno', '')
dw_2.setcolumn('fdate')
dw_2.setfocus()

end subroutine

on w_pdt_02020.create
int iCurrent
call super::create
this.dw_list=create dw_list
this.dw_detail=create dw_detail
this.dw_1=create dw_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.p_1=create p_1
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
this.dw_2=create dw_2
this.rr_4=create rr_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list
this.Control[iCurrent+2]=this.dw_detail
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.rb_1
this.Control[iCurrent+5]=this.rb_2
this.Control[iCurrent+6]=this.p_1
this.Control[iCurrent+7]=this.rr_1
this.Control[iCurrent+8]=this.rr_2
this.Control[iCurrent+9]=this.rr_3
this.Control[iCurrent+10]=this.dw_2
this.Control[iCurrent+11]=this.rr_4
end on

on w_pdt_02020.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_list)
destroy(this.dw_detail)
destroy(this.dw_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.p_1)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
destroy(this.dw_2)
destroy(this.rr_4)
end on

event open;call super::open;
dw_1.settransobject(sqlca)
dw_insert.settransobject(sqlca)
dw_list.settransobject(sqlca)
dw_detail.settransobject(sqlca)

dw_2.insertrow(0)
dw_2.setitem(1, 'fdate', f_today())
dw_2.setitem(1, 'tdate', f_today())
dw_2.setfocus()

if f_change_name('1') = 'Y' then 
	string sispec, sjijil
	sispec = f_change_name('2')
	sjijil = f_change_name('3')
	
	dw_1.Modify("itemas_ispec_t.text = '" + sispec + "'" )
	dw_1.Modify("itemas_jijil_t.text = '" + sjijil + "'" )
	dw_detail.Modify("itemas_ispec_t.text = '" + sispec + "'" )
	dw_detail.Modify("itemas_jijil_t.text = '" + sjijil + "'" )
	dw_insert.Modify("itemas_ispec_t.text = '" + sispec + "'" )
	dw_insert.Modify("jijil_t.text = '" + sjijil + "'" )
	dw_list.Modify("ispec_t.text = '" + sispec + "'" )
	dw_list.Modify("jijil_t.text = '" + sjijil + "'" )

end if	

end event

event close;rollback;
end event

event key;choose case key
	case keypageup!
		dw_1.scrollpriorpage()
	case keypagedown!
		dw_1.scrollnextpage()
	case keyhome!
		dw_1.scrolltorow(1)
	case keyend!
		dw_1.scrolltorow(dw_1.rowcount())
end choose
end event

type dw_insert from w_inherite`dw_insert within w_pdt_02020
integer x = 1760
integer y = 912
integer width = 2811
integer height = 692
integer taborder = 50
boolean titlebar = true
string title = "수주연결"
string dataobject = "d_pdt_02020_1"
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemchanged;call super::itemchanged;Decimal {3} dsqty, dold_qty, dpdqty, dordqty, dholdqty, get_qty, dsubqty, &
        dvaqty, dOrdhold, dold_sqty 
Long    Lrow
String  sOrderNo

Lrow = this.getrow()

/* 추가 예정 수량 check
   추가 예정수량 > 지시잔량이면 error */	
IF this.getcolumnname() = "momord_sqty" THEN
   dold_qty = this.getitemdecimal(lrow, "momord_sqty")       //이전 연결 수량
   dold_sqty = this.getitemdecimal(lrow, "momord_old_sqty")  //처음조회시 연결 수량
   dordqty  = this.getitemdecimal(lrow, "sorder_order_qty")  //수주 수량 
   dOrdhold = this.getitemdecimal(lrow, "sorder_hold_qty")   //수주에 할당수량 
   sOrderNO = this.getitemString(lrow, "momord_sordno")      //수주번호
	
	//실제 수주에 작업지시 연결 수량
   SELECT NVL(SUM("MOMORD"."SQTY"),0) - NVL(SUM("MOMORD"."HQTY"),0)  
     INTO :get_qty  
     FROM "MOMORD"  
    WHERE ( "MOMORD"."SABU" = :gs_sabu ) AND  
          ( "MOMORD"."SORDNO" = :sOrderNo )   ;

   dholdqty  = this.getitemdecimal(lrow, "momord_hqty")     //할당수량 

	this.accepttext()
   
	dvaqty    = dec(this.Object.valid_qty_t.Text)            //가능 수량
	       
	dsqty     = dec(this.gettext())     //변경된 연결 수량

	IF dsqty <= 0 THEN 
		MessageBox("확 인","연결수량은 0 보다 커야 됩니다.", StopSign! )
		this.setitem(lrow, "momord_sqty", dold_qty)
		return 1
	END IF

	IF dsqty < this.getitemdecimal(lrow, 'momord_hqty')  THEN 
		MessageBox("확 인","연결수량이 [ 할당된 수량 + 진행 수량 ] 보다 작습니다." + "~n~n" +&
								 "연결수량을 확인 하십시요!!", StopSign! )
		this.setitem(lrow, "momord_sqty", dold_qty)
		return 1
	END IF
	
   dsubqty = get_qty + dsqty - dold_sqty     
	IF dsubqty > dordqty - dordhold  THEN 
		MessageBox("확 인","연결수량 TOTAL이 수주(주문 - 할당)수량 보다 큽니다." + "~n~n" +&
								 "연결수량을 확인 하십시요!!", StopSign! )
		this.setitem(lrow, "momord_sqty", dold_qty)
		return 1
	END IF

	if dsqty - dold_qty > dvaqty then 
		MessageBox("확 인","연결가능수량을 초과하였습니다." + "~n~n" +&
								 "연결수량을 확인 하십시요!!", StopSign! )
		this.setitem(lrow, "momord_sqty", dold_qty)
		return 1
	end if	
	
	dvaqty = dvaqty - (dsqty - dold_qty)
	this.object.valid_qty_t.text = string(dvaqty, '###,###,###,##0') 
END IF

	
end event

event dw_insert::itemerror;RETURN 1
end event

event dw_insert::losefocus;this.accepttext()
end event

event dw_insert::updatestart;/* Update() function 호출시 user 설정 */
long k, lRowCount

lRowCount = this.RowCount()

FOR k = 1 TO lRowCount
   IF NewModified! = this.GetItemStatus(k, 0, Primary!) THEN
 	   This.SetItem(k,'crt_user',gs_userid)
   ELSEIF DataModified! = this.GetItemStatus(k, 0, Primary!) THEN 		
	   This.SetItem(k,'upd_user',gs_userid)
   END IF	  
NEXT


end event

type p_delrow from w_inherite`p_delrow within w_pdt_02020
boolean visible = false
integer x = 2542
integer y = 2948
end type

type p_addrow from w_inherite`p_addrow within w_pdt_02020
boolean visible = false
integer x = 2368
integer y = 2948
end type

type p_search from w_inherite`p_search within w_pdt_02020
integer x = 3886
integer y = 752
string picturename = "C:\erpman\image\연결_d.gif"
end type

event p_search::clicked;call super::clicked;string	snull, sopt, sOrderNo, sPordNo, get_nm, spdsts
long		lRow, lRowCount, ii 
dec  {3}     dvqty, dnqty, dMoveQty

SetNull(snull)

if dw_list.accepttext() = -1 then return 
if dw_insert.accepttext() = -1 then return 

lRowCount = dw_list.RowCount()

if lRowCount < 1 then return 

spdsts = dw_detail.getitemstring(1, 'momast_pdsts')   //지시상태

if  spdsts > '2' then
    messagebox("지시상태 확인", "지시상태가 지시인 자료만 이동 시킬 수 있습니다.") 
	 dw_list.setfocus()
	 return 
end if	 
	
FOR	lRow = lRowCount	TO		1		STEP  -1
      sopt = dw_list.getitemstring(lrow, 'opt')	
      if sopt = 'Y' then ii++
NEXT 

if  ii < 1 then  
    messagebox("확 인", "수주 미연결에서 연결로 이동할 자료를 먼저 선택 하세요!") 
	 dw_list.setfocus()
	 return 
end if	 

sPordNo = dw_detail.getitemstring(1, 'momast_pordno')

dvqty = dec(dw_insert.Object.valid_qty_t.Text)

dnqty   = dw_list.getitemdecimal(1, 'opt_tot')          //이동 시킬 수량

if dvqty < dnqty then 
	MessageBox("확 인","연결가능수량 보다 이동 수량이 큽니다." + "~n~n" +&
							 "이동수량을 확인 하십시요!!", StopSign! )
	dw_list.setfocus()						 
	return 
end if	

IF MessageBox("이동 확인", "수주자료 총 " + string(ii) + "건에 자료를 수주연결로 이동 하시겠습니까? ", &
						         question!, yesno!, 2)  = 2		THEN return 

SetPointer(HourGlass!)
sle_msg.text = ''

IF dw_insert.Update() <> 1 THEN			
	ROLLBACK USING sqlca;
	sle_msg.text = ''
	f_rollback()
	RETURN 
END IF

////////////////////////////////////////////////////
FOR	lRow = lRowCount	TO		1		STEP  -1
      sopt = dw_list.getitemstring(lrow, 'opt')	
      dMoveQty = dw_list.getitemDecimal(lrow, 'move_qty')	         			
	   if sopt = 'Y' and dMoveqty > 0 then 
         sOrderNO = dw_list.getitemstring(lrow, 'sorder_order_no')	         			

			SELECT "MOMORD"."SABU"  
			  INTO :get_nm  
			  FROM "MOMORD"  
			 WHERE ( "MOMORD"."SABU"   = :gs_sabu ) AND  
					 ( "MOMORD"."PORDNO" = :sPordNo  ) AND  
					 ( "MOMORD"."SORDNO" = :sOrderNo )   ;
			
			if sqlca.sqlcode = 100 then 
	         INSERT INTO "MOMORD"  
         				( "SABU",    "PORDNO", "SORDNO",  "SQTY", "HQTY" )  
			     VALUES ( :gs_sabu, :sPordNo, :sOrderNo, :dMoveQty, 0  )  ;
				
				IF SQLCA.SQLNROWS < 1 THEN 
					ROLLBACK USING sqlca;
					sle_msg.text = ''
					f_message_chk(32,'')
					return
				END IF
					
			elseif sqlca.sqlcode = 0 then 	  
				UPDATE "MOMORD"  
				   SET "SQTY" = SQTY + :dMoveQty, "UPD_USER" = :gs_userid  
				 WHERE ( "MOMORD"."SABU"   = :gs_sabu ) AND  
						 ( "MOMORD"."PORDNO" = :sPordNo  ) AND  
						 ( "MOMORD"."SORDNO" = :sOrderNo )   ;

				IF SQLCA.SQLNROWS < 1 THEN 
					ROLLBACK USING sqlca;
					sle_msg.text = ''
					f_message_chk(32,'')
					return
				END IF
				
			else
				ROLLBACK USING sqlca;
				sle_msg.text = ''
				f_message_chk(52,'')
				return
			end if

		end if	
NEXT
////////////////////////////////////////////////////
COMMIT USING sqlca;

p_inq.TriggerEvent(Clicked!)
sle_msg.text = ''
SetPointer(Arrow!)
end event

event p_search::ue_lbuttonup;this.PictureName = 'C:\erpman\image\연결_up.gif'
end event

event p_search::ue_lbuttondown;call super::ue_lbuttondown;this.PictureName = 'C:\erpman\image\연결_dn.gif'
end event

type p_ins from w_inherite`p_ins within w_pdt_02020
boolean visible = false
integer x = 2194
integer y = 2948
end type

type p_exit from w_inherite`p_exit within w_pdt_02020
integer x = 4421
end type

type p_can from w_inherite`p_can within w_pdt_02020
integer x = 4242
end type

event p_can::clicked;call super::clicked;wf_reset()
end event

type p_print from w_inherite`p_print within w_pdt_02020
integer x = 4064
integer y = 752
string pointer = "C:\erpman\cur\delete.cur"
boolean enabled = false
string picturename = "C:\erpman\image\삭제_d.gif"
end type

event p_print::ue_lbuttondown;this.PictureName = 'C:\erpman\image\삭제_dn.gif'
end event

event p_print::ue_lbuttonup;call super::ue_lbuttonup;this.PictureName = 'C:\erpman\image\삭제_up.gif'
end event

event p_print::clicked;call super::clicked;string	snull, sopt
long		lRow, lRowCount, ii

SetNull(snull)

if dw_insert.accepttext() = -1 then return 

lRowCount = dw_insert.RowCount()

if lRowCount < 1 then return 

FOR	lRow = lRowCount	TO		1		STEP  -1
      sopt = dw_insert.getitemstring(lrow, 'opt')	
      if sopt = 'Y' then ii++
NEXT

if  ii < 1 then  
    messagebox("확 인", "수주 연결에 삭제할 자료를 먼저 선택 하세요!") 
	 dw_insert.setfocus()
	 return 
end if	 

IF	 MessageBox("삭제 확인", "작업지시 연결자료 총 " + string(ii) + "건에 자료를 삭제하시겠습니까? ", &
						         question!, yesno!, 2)  = 2		THEN return 

SetPointer(HourGlass!)
sle_msg.text = '연결자료 삭제중....'

////////////////////////////////////////////////////
FOR	lRow = lRowCount	TO		1		STEP  -1
      sopt = dw_insert.getitemstring(lrow, 'opt')	
	   if sopt = 'Y' then 
			dw_insert.DeleteRow(lRow)
		end if	
NEXT
		
IF dw_insert.Update() > 0 THEN			
	COMMIT USING sqlca;
ELSE
	ROLLBACK USING sqlca;
	sle_msg.text = ''
	f_rollback()
	RETURN 
END IF

p_inq.TriggerEvent(Clicked!)
sle_msg.text = ''
SetPointer(Arrow!)
end event

type p_inq from w_inherite`p_inq within w_pdt_02020
integer x = 4421
integer y = 752
end type

event p_inq::clicked;string s_pordno, s_itnbr, s_pspec, s_stditnbr
decimal {3} dtotqty, dpdqty, dpeqty, dpaqty, dcoqty, dsqty, dhqty, dwaqty 
Long   ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

s_pordno= dw_1.GetItemString(ll_Row, "momast_pordno")  

if s_pordno = '' or isnull(s_pordno) then
	f_message_chk(30,'[작업지시번호]')
	dw_2.setfocus()
	return
end if

if dw_detail.retrieve(gs_sabu, s_pordno) = 0 then
	f_message_chk(56,'[작업지시상세]')
	dw_2.setfocus()
	return
end if

s_itnbr     = trim(dw_detail.object.momast_itnbr[1])
s_stditnbr  = trim(dw_detail.object.momast_stditnbr[1])
s_pspec     = trim(dw_detail.object.momast_pspec[1])
dpdqty      = dw_detail.GetItemDecimal(1, 'momast_pdqty')  //지시수량
dpeqty      = dw_detail.GetItemDecimal(1, 'momast_peqty')  //폐기수량
dpaqty      = dw_detail.GetItemDecimal(1, 'momast_paqty')  //분할수량
dwaqty      = dw_detail.GetItemDecimal(1, 'momast_waqty')  //생산입고수량

if dw_Insert.retrieve(gs_sabu, s_pordno) > 0 then
   dsqty = dw_Insert.GetItemDecimal(1, 'tot_sqty')   //연결수량
   dhqty = dw_Insert.GetItemDecimal(1, 'tot_hqty')   //할당수량
else
	dsqty = 0
end if

// 연결가능수량 공식 =>   (작업지시수량 - (입고수량 + 폐기수량 + 분할수량)) - (연결수량 - 할당수량)
dtotqty = (dpdqty - (dwaqty + dpeqty + dpaqty )) - (dsqty - dhqty)

dw_insert.object.valid_qty_t.text = string(dtotqty, '###,###,###,##0') 

if rb_1.checked = TRUE then 
	dw_list.SetFilter("njisi_qty  > 0")
	dw_list.Filter()
else
	dw_list.SetFilter("njisi_qty  > 0 and sorder_order_qty > sorder_jisi_qty")
	dw_list.Filter()
end if

dw_list.retrieve(gs_sabu, s_itnbr, s_stditnbr)

//cb_del.enabled 	= true
p_del.enabled 	= true
p_del.picturename = 'C:\erpman\image\조회_up.gif'

//cb_search.enabled = true
p_search.enabled 	= true
p_search.picturename = 'C:\erpman\image\연결_up.gif'

//cb_print.enabled 	= true
p_print.enabled 	= true
p_print.picturename = 'C:\erpman\image\삭제_up.gif'

ib_any_typing = false

sle_msg.text = '연결가능수량 ' + String(dtotqty) + &
                ' => (작지수량' + string(dpdqty) + ' - ' + &
					     '(입고수량' + string(dwaqty) + ' + 폐기' + string(dpeqty) + ' + 분할' + string(dpaqty) + '))' + &
					  ' - (연결수량' + string(dsqty)  + ' + 할당' + string(dhqty)  + ')'
               

end event

type p_del from w_inherite`p_del within w_pdt_02020
integer x = 3886
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event p_del::ue_lbuttondown;this.PictureName = 'C:\erpman\image\조회_dn.gif'
end event

event p_del::ue_lbuttonup;this.PictureName = 'C:\erpman\image\조회_up.gif'
end event

event p_del::clicked;call super::clicked;String sdatef,sdatet, sitnbr, sgub

if dw_2.AcceptText() =-1 then return 

sgub   = trim(dw_2.GetItemString(1,"status"))
sdatef = trim(dw_2.GetItemString(1,"fdate"))
sdatet = trim(dw_2.GetItemString(1,"tdate"))
sitnbr = trim(dw_2.GetItemString(1,"itnbr"))

IF sdatef ="" OR IsNull(sdatef) THEN
	sdatef ='10000101'
END IF

IF sdatet = "" OR IsNull(sdatet) THEN
	sdatet ='99991231'
END IF

IF sItnbr = "" OR IsNull(sItnbr) THEN
	sItnbr = '%'
END IF

IF sdatet < sdatef THEN
	f_message_chk(34,'[기간]')
	dw_2.SetColumn("fdate")
	dw_2.SetFocus()
	Return
END IF

dw_1.setfilter("")
IF sgub = '1' THEN  
	dw_1.setfilter("momast_pdsts in ('1', '2')")
END IF
dw_1.filter()

IF dw_1.Retrieve(gs_sabu, sdatef, sdatet, sitnbr) <= 0 THEN
   messagebox("확인", "조회한 자료가 없습니다!!")
	dw_2.SetColumn("fdate")
	dw_2.SetFocus()
	Return
END IF

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type p_mod from w_inherite`p_mod within w_pdt_02020
integer x = 4064
end type

event p_mod::clicked;call super::clicked;if dw_insert.rowcount() < 1 then return 

if wf_requiredchk() 	 = -1 then 
	sle_msg.text = ''
	return
end if

sle_msg.text = "자료를 저장하고 있읍니다."
if dw_insert.update() = 1 then
	commit ;
else
	rollback ;
	sle_msg.text = ""
	f_message_chk(32,'[자료저장]') 	
end if	

sle_msg.text = ''
ib_any_typing =FALSE

p_inq.TriggerEvent(Clicked!)
end event

type cb_exit from w_inherite`cb_exit within w_pdt_02020
boolean visible = false
integer x = 1152
integer y = 2776
integer taborder = 120
end type

type cb_mod from w_inherite`cb_mod within w_pdt_02020
boolean visible = false
integer x = 3397
integer y = 2836
integer taborder = 100
end type

type cb_ins from w_inherite`cb_ins within w_pdt_02020
boolean visible = false
integer x = 841
integer y = 3016
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_pdt_02020
boolean visible = false
integer x = 1678
integer y = 2836
integer width = 434
integer taborder = 20
integer textsize = -9
string text = "작업조회(&W)"
end type

type cb_inq from w_inherite`cb_inq within w_pdt_02020
boolean visible = false
integer x = 855
integer y = 2824
integer taborder = 70
end type

type cb_print from w_inherite`cb_print within w_pdt_02020
boolean visible = false
integer x = 2610
integer y = 3016
integer width = 530
integer taborder = 80
integer textsize = -9
string text = "수주연결 삭제(&D)"
end type

type st_1 from w_inherite`st_1 within w_pdt_02020
end type

type cb_can from w_inherite`cb_can within w_pdt_02020
boolean visible = false
integer x = 2866
integer y = 2784
integer taborder = 110
end type

type cb_search from w_inherite`cb_search within w_pdt_02020
boolean visible = false
integer x = 3159
integer y = 2992
integer width = 334
integer taborder = 90
integer textsize = -9
string text = "이동(&M)"
end type



type sle_msg from w_inherite`sle_msg within w_pdt_02020
boolean visible = false
integer x = 178
integer y = 2808
end type

type gb_10 from w_inherite`gb_10 within w_pdt_02020
boolean visible = false
integer y = 2692
integer height = 148
integer textsize = -8
fontcharset fontcharset = ansi!
end type

type gb_button1 from w_inherite`gb_button1 within w_pdt_02020
end type

type gb_button2 from w_inherite`gb_button2 within w_pdt_02020
end type

type dw_list from datawindow within w_pdt_02020
event ue_pressenter pbm_dwnprocessenter
integer x = 1760
integer y = 1604
integer width = 2811
integer height = 692
integer taborder = 60
boolean bringtotop = true
boolean titlebar = true
string title = "수주 미연결"
string dataobject = "d_pdt_02020_2"
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event losefocus;this.accepttext()
end event

event editchanged;ib_any_typing =True
end event

event itemerror;RETURN 1
end event

event itemchanged;Decimal  {3} dsqty, dold_qty
Long    Lrow

Lrow = this.getrow()

IF this.getcolumnname() = "move_qty" THEN
   dold_qty = this.getitemdecimal(lrow, "njisi_qty")
	dsqty = dec(this.gettext())
	
	IF dsqty <= 0 THEN 
		MessageBox("확 인","이동수량은 0 보다 커야 됩니다.", StopSign! )
		this.setitem(lrow, "move_qty", dold_qty)
		return 1
	END IF

	IF dsqty > dold_qty  THEN 
		MessageBox("확 인","이동수량이 미지시수량보다 큽니다." + "~n~n" +&
								 "이동수량을 확인 하십시요!!", StopSign! )
		this.setitem(lrow, "move_qty", dold_qty)
		return 1
	END IF
   
END IF

	
end event

type dw_detail from datawindow within w_pdt_02020
event ue_pressenter pbm_dwnprocessenter
integer x = 41
integer y = 772
integer width = 1673
integer height = 1400
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_pdt_02020"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;//Send(Handle(this),256,9,0)
//Return 1
end event

event itemchanged;//string s_date, snull
//
//setnull(snull)
//
//IF this.GetColumnName() = 'sfrom' THEN
//	s_date = Trim(this.Gettext())
//	IF s_date ="" OR IsNull(s_date) THEN RETURN
//	
//	IF f_datechk(s_date) = -1 THEN
//		f_message_chk(35,'[승인일자]')
//		this.SetItem(1,"sfrom",snull)
//		Return 1
//	END IF
//ELSEIF this.GetColumnName() = 'sto' THEN
//	s_date = Trim(this.Gettext())
//	IF s_date ="" OR IsNull(s_date) THEN RETURN
//	
//	IF f_datechk(s_date) = -1 THEN
//		f_message_chk(35,'[승인일자]')
//		this.SetItem(1,"sto",snull)
//		Return 1
//	END IF
//END IF
//
end event

event itemerror;//return 1
end event

type dw_1 from u_d_popup_sort within w_pdt_02020
integer x = 41
integer y = 228
integer width = 4535
integer height = 508
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_pdt_02020_0"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	b_flag = False
END IF

CALL SUPER ::CLICKED


end event

event rowfocuschanged;dw_1.SelectRow(0,False)
dw_1.SelectRow(currentrow,True)

dw_1.ScrollToRow(currentrow)
end event

event doubleclicked;p_inq.TriggerEvent(Clicked!)


end event

type rb_1 from radiobutton within w_pdt_02020
integer x = 1801
integer y = 792
integer width = 270
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 33027312
string text = "전 체"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;dw_list.SetFilter("njisi_qty  > 0")
dw_list.Filter()

end event

type rb_2 from radiobutton within w_pdt_02020
integer x = 2085
integer y = 804
integer width = 366
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 33027312
string text = "미 지시분"
borderstyle borderstyle = stylelowered!
end type

event clicked;dw_list.SetFilter("njisi_qty  > 0 and sorder_order_qty >  sorder_jisi_qty")
dw_list.Filter()

end event

type p_1 from picture within w_pdt_02020
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 4242
integer y = 752
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "C:\erpman\cur\point.cur"
string picturename = "C:\erpman\image\검색_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;this.PictureName = 'C:\erpman\image\검색_dn.gif'
end event

event ue_lbuttonup;this.PictureName = 'C:\erpman\image\검색_up.gif'
end event

event clicked;open(w_pdt_02020_10_1)
end event

type rr_1 from roundrectangle within w_pdt_02020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 216
integer width = 4553
integer height = 528
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pdt_02020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 32
integer y = 764
integer width = 1691
integer height = 1544
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_pdt_02020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 1746
integer y = 764
integer width = 754
integer height = 124
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_2 from datawindow within w_pdt_02020
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 23
integer y = 24
integer width = 3666
integer height = 176
integer taborder = 10
string dataobject = "d_pdt_02020_3"
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemerror;RETURN 1
end event

event itemchanged;string  sitnbr, sitdsc, sispec, s_gub, sdate, snull
int     ireturn

setnull(snull)

IF this.GetColumnName() = "itnbr"	THEN
	sItnbr = trim(this.GetText())
	ireturn = f_get_name2('품번', 'Y', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "itnbr", sitnbr)	
	this.setitem(1, "itdsc", sitdsc)	
	this.setitem(1, "ispec", sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = "itdsc"	THEN
	sItdsc = trim(this.GetText())
	ireturn = f_get_name2('품명', 'Y', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "itnbr", sitnbr)	
	this.setitem(1, "itdsc", sitdsc)	
	this.setitem(1, "ispec", sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = "ispec"	THEN
	sIspec = trim(this.GetText())
	ireturn = f_get_name2('규격', 'Y', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "itnbr", sitnbr)	
	this.setitem(1, "itdsc", sitdsc)	
	this.setitem(1, "ispec", sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = "fdate" THEN
	sDate = Trim(this.GetText())
	IF sDate ="" OR IsNull(sDate) THEN RETURN
	
	IF f_datechk(sDate) = -1 THEN
		f_message_chk(35,'[지시일자]')
		this.SetItem(1,"fdate",snull)
		Return 1
	END IF
ELSEIF this.GetColumnName() = "tdate" THEN
	sDate = Trim(this.GetText())
	IF sDate ="" OR IsNull(sDate) THEN RETURN
	
	IF f_datechk(sDate) = -1 THEN
		f_message_chk(35,'[지시일자]')
		this.SetItem(1,"tdate",snull)
		Return 1
	END IF	
END IF
end event

event rbuttondown;setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)

IF this.GetcolumnName() ="itnbr" THEN
	Open(w_itemas_popup)
	IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	
	this.SetItem(1,"itnbr",gs_code)
	this.SetItem(1,"itdsc",gs_codename)
	this.SetItem(1,"ispec",gs_gubun)
END IF	
end event

type rr_4 from roundrectangle within w_pdt_02020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 1746
integer y = 904
integer width = 2843
integer height = 1404
integer cornerheight = 40
integer cornerwidth = 55
end type

