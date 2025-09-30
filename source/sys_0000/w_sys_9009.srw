$PBExportHeader$w_sys_9009.srw
$PBExportComments$재고실사 조정 (한텍)
forward
global type w_sys_9009 from w_inherite
end type
type dw_1 from datawindow within w_sys_9009
end type
type dw_2 from u_d_select_sort within w_sys_9009
end type
type dw_3 from u_d_select_sort within w_sys_9009
end type
type dw_4 from u_d_select_sort within w_sys_9009
end type
type cb_step1 from commandbutton within w_sys_9009
end type
type cb_step2 from commandbutton within w_sys_9009
end type
end forward

global type w_sys_9009 from w_inherite
integer width = 5198
integer height = 2776
string title = "재고실사 정리"
dw_1 dw_1
dw_2 dw_2
dw_3 dw_3
dw_4 dw_4
cb_step1 cb_step1
cb_step2 cb_step2
end type
global w_sys_9009 w_sys_9009

forward prototypes
public subroutine wf_dw_2_click (long arg_row)
end prototypes

public subroutine wf_dw_2_click (long arg_row);if arg_row <= 0 then
	dw_3.ReSet()
	dw_4.ReSet()
	return
end if

string	syymm, sdepot, sitnbr, sgubun

syymm  = TRIM(dw_insert.GetItemString(1, "syymm"))
if syymm > '.' then syymm = syymm + '%'
	
sgubun = dw_insert.GetItemString(1, "gubun")
sdepot = dw_2.GetItemString(arg_row, "cvcod")
sitnbr = dw_2.GetItemString(arg_row, "itnbr")

SetPointer(HourGlass!)
if sgubun = '%' then
	dw_3.SetFilter("depot_no='"+sdepot+"' and itnbr='"+sitnbr+"'")
else
	dw_3.SetFilter("depot_no='"+sdepot+"' and itnbr='"+sitnbr+"' and iogbn='"+sgubun+"'")
end if
dw_3.Filter()
//dw_3.Retrieve(gs_sabu, syymm)

dw_4.Retrieve(sdepot, sitnbr)
end subroutine

on w_sys_9009.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_2=create dw_2
this.dw_3=create dw_3
this.dw_4=create dw_4
this.cb_step1=create cb_step1
this.cb_step2=create cb_step2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.dw_3
this.Control[iCurrent+4]=this.dw_4
this.Control[iCurrent+5]=this.cb_step1
this.Control[iCurrent+6]=this.cb_step2
end on

on w_sys_9009.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.dw_3)
destroy(this.dw_4)
destroy(this.cb_step1)
destroy(this.cb_step2)
end on

event open;call super::open;dw_Insert.Settransobject(sqlca)
dw_Insert.Insertrow(0)

dw_1.Settransobject(sqlca)
dw_2.Settransobject(sqlca)
dw_3.Settransobject(sqlca)
dw_4.Settransobject(sqlca)

dw_insert.SetItem(1, "syymm", f_aftermonth(left(f_today(), 6), -1))
dw_insert.SetColumn("syymm")
dw_insert.SetFocus()

PostEvent("ue_open")
end event

event ue_open;call super::ue_open;SetPointer(HourGlass!)
dw_2.Retrieve()

string syymm

syymm  = TRIM(dw_insert.GetItemString(1, "syymm"))
if syymm > '.' then syymm = syymm + '%'
	
dw_3.Retrieve(gs_sabu, syymm)

end event

type dw_insert from w_inherite`dw_insert within w_sys_9009
integer x = 2437
integer y = 4
integer width = 1545
integer height = 172
string dataobject = "d_sys_9009_2"
boolean border = false
end type

event dw_insert::itemchanged;long		Xrow
STRING 	s_date, snull
string	syymm, sdepot, sitnbr, sgubun

//syymm  = TRIM(dw_insert.GetItemString(1, "syymm"))
//if syymm > '.' then syymm = syymm + '%'
//	
//sgubun = dw_insert.GetItemString(1, "gubun")
//


setnull(snull)

IF this.GetColumnName() ="syymm" THEN
	s_date = trim(this.GetText())
	
	if s_date = "" or isnull(s_date) then return 

  	IF f_datechk(s_date + '01') = -1	then
      f_message_chk(35, '[기준년월]')
		this.setitem(1, "syymm", snull)
		return 1
	END IF
	
	dw_2.SelectRow(0, FALSE)
	dw_3.ReSet()
	dw_4.ReSet()

ELSEIF this.GetColumnName() ="gubun" THEN
	sgubun = trim(this.GetText())

	Xrow = dw_2.GetSelectedRow(0)
	if Xrow <= 0 then	return

	sdepot = dw_2.GetItemString(Xrow, "cvcod")
	sitnbr = dw_2.GetItemString(Xrow, "itnbr")

	if sgubun = '%' then
		dw_3.SetFilter("depot_no='"+sdepot+"' and itnbr='"+sitnbr+"'")
	else
		dw_3.SetFilter("depot_no='"+sdepot+"' and itnbr='"+sitnbr+"' and iogbn='"+sgubun+"'")
	end if
	dw_3.Filter()

END IF
end event

event dw_insert::itemerror;return 1
end event

type p_delrow from w_inherite`p_delrow within w_sys_9009
integer x = 4018
integer y = 8
end type

event p_delrow::clicked;call super::clicked;long	lrow

lrow = dw_3.GetSelectedRow(0)
if lrow <= 0 then
	messagebox('x','xx')
	return
end if

long		i
for i = 1 to dw_3.RowCount()
	if dw_3.IsSelected(i) then
		dw_3.DeleteRow(i)
		i = i -1
	end if	
next
end event

type p_addrow from w_inherite`p_addrow within w_sys_9009
boolean visible = false
integer x = 2638
integer y = 2352
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_sys_9009
boolean visible = false
integer x = 1650
integer y = 2248
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_sys_9009
integer x = 4672
integer y = 0
string picturename = "C:\erpman\image\처리_up.gif"
end type

event p_ins::clicked;call super::clicked;String  s_yymm, sDepot, sValid_yn, sJego_yn
long    get_count
int     iReturn, k 

IF dw_insert.AcceptText() = -1 THEN RETURN 

s_yymm 	= trim(dw_insert.GetItemString(1, 'syymm'))

if isnull(s_yymm) or s_yymm = "" then
	f_message_chk(30,'[기준년월]')
	dw_insert.SetColumn('syymm')
	dw_insert.SetFocus()
	return
end if	

if s_yymm < '200701' then
	Messagebox('확인',"2007년 이전 수불복구 작업은 불가합니다!!!")
	dw_insert.SetColumn('syymm')
	dw_insert.SetFocus()
	return
end if	


SELECT COUNT(*)
  INTO :get_count
  FROM STOCKMONTH  
 WHERE STOCK_YYMM = :s_yymm
   AND IOGBN      IN ( SELECT IOGBN FROM IOMATRIX 
							   WHERE SABU = :gs_sabu AND TRANSGUB = 'Y' )  ;

if get_count < 1 then
	MessageBox('확 인', '기준년월에 이월재고가 존재하지 않습니다. 기준년월을 확인하세요!')
	dw_insert.SetColumn('syymm')
	dw_insert.SetFocus()
	return
end if	

IF Messagebox('자료복구',"자료복구처리 하시겠습니까?", Question!,YesNo!,2) = 2 THEN RETURN 

//dw_1.retrieve()

sle_msg.text = "수불자료 복구 中 ............"

SetPointer(HourGlass!)

iReturn = sqlca.FUN_RECOVERY(gs_sabu, s_yymm);
If ireturn < 0  then
	sle_msg.text = ''
	rollback;	
	f_message_chk(89,'[수불 자료 복구] [ ' + string(ireturn) + ' ]') 
	return
end if

//FOR k=1 TO dw_1.RowCount()
// 
//   sDepot    = dw_1.GetItemString(k, 'cvcod')
//   sValid_yn = dw_1.GetItemString(k, 'rewapunish')  //가용재고 마이너스 허용 여부
//   sJego_yn  = dw_1.GetItemString(k, 'kyungy')      //현재고 마이너스 허용 여부
//	
//   UPDATE "VNDMST"  
//      SET "REWAPUNISH" = :sValid_yn,  "KYUNGY" = :sJego_yn  
//    WHERE "VNDMST"."CVCOD" = :sDepot   ;
//	 
//	IF SQLCA.SQLCODE <> 0 THEN  
//		Rollback;	
//		f_message_chk(89,'[창고 자료 복구]') 
//		Return
//	END IF
//NEXT
//	
Commit;
sle_msg.text = "수불자료가 복구 되었습니다.!!"


end event

event p_ins::ue_lbuttondown;PictureName = "C:\erpman\image\처리_dn.gif"
end event

event p_ins::ue_lbuttonup;PictureName = "C:\erpman\image\처리_up.gif"
end event

type p_exit from w_inherite`p_exit within w_sys_9009
integer x = 4375
integer y = 8
end type

type p_can from w_inherite`p_can within w_sys_9009
boolean visible = false
integer x = 3040
integer y = 2248
boolean enabled = false
end type

type p_print from w_inherite`p_print within w_sys_9009
boolean visible = false
integer x = 1824
integer y = 2248
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_sys_9009
boolean visible = false
integer x = 3291
integer y = 2260
boolean enabled = false
end type

type p_del from w_inherite`p_del within w_sys_9009
boolean visible = false
integer x = 2866
integer y = 2248
boolean enabled = false
end type

type p_mod from w_inherite`p_mod within w_sys_9009
integer x = 4197
integer y = 8
end type

event p_mod::clicked;call super::clicked;long		lrow
string	sdepot, sitnbr
decimal	djego

If f_msg_update() < 1 Then Return

for lrow = 1 to dw_3.rowcount()
	dw_3.setitem(lrow, 'iosuqty', dw_3.getitemnumber(lrow, 'ioqty'))
next
if dw_3.AcceptText() = -1 then return

SetPointer(HourGlass!)
If dw_3.Update() <> 1  then
	messagebox('ERROR', sqlca.sqlerrtext)
	Rollback;
	return
end if

Commit;

lrow = dw_2.GetSelectedRow(0)
if lrow <= 0 then
	return
end if

sdepot = dw_2.GetItemString(lrow, "cvcod")
sitnbr = dw_2.GetItemString(lrow, "itnbr")

SetPointer(HourGlass!)
dw_4.Retrieve(sdepot, sitnbr)

SELECT JEGO_QTY INTO :djego FROM STOCK
 WHERE DEPOT_NO = :sdepot AND ITNBR = :sitnbr AND PSPEC = '.' ;

dw_2.Setitem(lrow, 'jego_qty', djego)
end event

type cb_exit from w_inherite`cb_exit within w_sys_9009
end type

type cb_mod from w_inherite`cb_mod within w_sys_9009
integer x = 649
integer y = 2612
end type

type cb_ins from w_inherite`cb_ins within w_sys_9009
end type

type cb_del from w_inherite`cb_del within w_sys_9009
integer x = 1294
integer y = 2360
integer width = 581
integer height = 120
integer textsize = -9
boolean enabled = false
string text = "마감이력삭제(&D)"
end type

type cb_inq from w_inherite`cb_inq within w_sys_9009
integer x = 1376
integer y = 2612
end type

type cb_print from w_inherite`cb_print within w_sys_9009
integer y = 2612
end type

type st_1 from w_inherite`st_1 within w_sys_9009
end type

type cb_can from w_inherite`cb_can within w_sys_9009
integer x = 2112
integer y = 2612
end type

type cb_search from w_inherite`cb_search within w_sys_9009
integer x = 2459
integer y = 2612
end type





type gb_10 from w_inherite`gb_10 within w_sys_9009
integer x = 18
end type

type gb_button1 from w_inherite`gb_button1 within w_sys_9009
end type

type gb_button2 from w_inherite`gb_button2 within w_sys_9009
end type

type dw_1 from datawindow within w_sys_9009
boolean visible = false
integer x = 37
integer y = 2172
integer width = 160
integer height = 36
boolean bringtotop = true
string dataobject = "d_sys_900_1"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_2 from u_d_select_sort within w_sys_9009
integer y = 8
integer width = 2414
integer height = 2236
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_sys_9009_1"
boolean hsplitscroll = true
end type

event clicked;call super::clicked;wf_dw_2_click(row)

//if row <= 0 then
//	dw_3.ReSet()
//	dw_4.ReSet()
//	return
//end if
//
//string	syymm, sdepot, sitnbr, sgubun
//
//syymm  = TRIM(dw_insert.GetItemString(1, "syymm"))
//if syymm > '.' then syymm = syymm + '%'
//	
//sgubun = dw_insert.GetItemString(1, "gubun")
//
//sdepot = GetItemString(row, "cvcod")
//sitnbr = GetItemString(row, "itnbr")
//
//SetPointer(HourGlass!)
//dw_3.SetFilter("iogbn='"+sgubun+"'")
//dw_3.Filter()
//dw_3.Retrieve(gs_sabu, syymm, sdepot, sitnbr)
//
//dw_4.Retrieve(sdepot, sitnbr)
end event

type dw_3 from u_d_select_sort within w_sys_9009
integer x = 2437
integer y = 292
integer width = 2144
integer height = 1308
integer taborder = 21
boolean bringtotop = true
string dataobject = "d_sys_9009_3"
boolean hsplitscroll = true
end type

event clicked;long		i
decimal	ld_sumqty=0

if row <= 0 then
	this.Object.t_sumqty.text = String(ld_sumqty,'#,##0')
end if

f_multi_select(this)

for i = 1 to dw_3.RowCount()
	if this.IsSelected (i) then
		ld_sumqty = ld_sumqty + this.Object.ioqty[i]
	end if	
next	

this.Object.t_sumqty.text = String(ld_sumqty,'#,##0')

end event

type dw_4 from u_d_select_sort within w_sys_9009
integer x = 2437
integer y = 1620
integer width = 2144
integer height = 628
integer taborder = 31
boolean bringtotop = true
string dataobject = "d_sys_9009_4"
boolean hsplitscroll = true
end type

type cb_step1 from commandbutton within w_sys_9009
integer x = 2459
integer y = 176
integer width = 197
integer height = 100
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "1."
end type

event clicked;long	lrow

lrow = dw_2.GetSelectedRow(0)
if lrow <= 0 then 
	lrow = 1
else
	lrow++
end if

dw_2.SelectRow(0, false)
if lrow > dw_2.rowcount() then return
dw_2.SelectRow(lrow, true)
dw_2.ScrollToRow(lrow)


end event

type cb_step2 from commandbutton within w_sys_9009
integer x = 2688
integer y = 176
integer width = 197
integer height = 100
integer taborder = 31
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "2."
end type

event clicked;long	lrow

lrow = dw_2.GetSelectedRow(0)
if lrow <= 0 then return

dw_insert.setitem(1, 'gubun', '%')
wf_dw_2_click(lrow)
end event

