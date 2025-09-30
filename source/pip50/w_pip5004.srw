$PBExportHeader$w_pip5004.srw
$PBExportComments$** 부양가족명세 등록
forward
global type w_pip5004 from w_inherite_standard
end type
type dw_main from u_d_select_sort within w_pip5004
end type
type dw_ip from u_key_enter within w_pip5004
end type
type cb_copy from commandbutton within w_pip5004
end type
type rr_1 from roundrectangle within w_pip5004
end type
end forward

global type w_pip5004 from w_inherite_standard
integer height = 2296
string title = "부양가족명세등록"
string menuname = ""
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
dw_main dw_main
dw_ip dw_ip
cb_copy cb_copy
rr_1 rr_1
end type
global w_pip5004 w_pip5004

type variables
Integer ii_row
String  exit_gubn = '1'
muiltstr	stparm
end variables

forward prototypes
public function integer wf_insert_personal ()
public subroutine wf_sum_amt ()
end prototypes

public function integer wf_insert_personal ();string ls_date, ls_empno, ls_baeuja
int baeuja, buyang20,  buyangja, res65, res70, rub, childcnt, cnt,born

IF dw_ip.AcceptText() = -1 THEN Return -1

ls_date = dw_ip.GetItemString(dw_ip.GetRow(), 'yyyy')
ls_empno = dw_ip.GetItemString(dw_ip.GetRow(), 'empno')

if dw_main.rowcount() < 1 then
	delete from p3_acnt_family where workyear = :ls_date and empno = :ls_empno;
else	


  select  sum(decode(dependent,'1',decode(gubun,'1',1,0))) as baeuaja,
			 sum(decode(dependent,'1',decode(relation_code,'4',decode(manychild,'1',1,0),0))) as buyang20,
			 sum(decode(dependent,'1',decode(gubun,'2',1,0))) as buyangja,
			 sum(decode(respect65,'1',1,0)) as res65,
			 sum(decode(respect70,'1',1,0)) as res70,
			 sum(decode(rubber,'1',1,0)) as rubber,
			  sum(decode(born,'1',1,0)) as born,
			 sum(decode(childcount,'1',1,0)) as childcnt 
	 into  :baeuja, :buyang20, :buyangja, :res65, :res70, :rub, :born, :childcnt      
	from p3_acnt_family
	where workyear = :ls_date and empno = :ls_empno;
	
	if IsNull(baeuja) or baeuja = 0 then 
		 baeuja = 0
		 ls_baeuja = '0'
   else
		 ls_baeuja = '1'
	end if
	
	if IsNull(buyang20) then buyang20 = 0
	if IsNull(buyangja) then buyangja = 0
	if IsNull(res65) then res65 = 0
	if IsNull(res70) then res70 = 0
	if IsNull(rub) then rub = 0
	if IsNull(childcnt) then childcnt = 0	
	if IsNull(born) then born = 0	
	
	select count(*)			into :cnt
	from p3_acnt_personal
	where workyear = :ls_date and empno = :ls_empno;
	
	messagebox('born',string(born))
	
	if cnt > 0 then
			update p3_acnt_personal
				set wifetag = :ls_baeuja,
				    dependent60 = :buyangja,
				    dependent20 = :buyang20,
					born = :born,
				    respect =  :res65,
				    respect1 =  :res70,
				    rubber = :rub,
				    childcount = :childcnt
				where workyear = :ls_date and empno = :ls_empno;
		
   else
			insert into p3_acnt_personal
				(workyear,			empno,	       wifetag,		  dependent20,		    dependent60,
				 respect,		respect1,	        rubber,	    	womenhouse,         childcount,born)
			values
				(:ls_date,    :ls_empno,       :ls_baeuja,          :buyang20,         :buyangja,
			      :res65,       :res70,            :rub ,	             '0',         :childcnt,  :born	) ;			
		
	end if
	
end if

if sqlca.sqlcode = 0 then
	commit;
	return 1
else
	rollback;
	return -1
end if


end function

public subroutine wf_sum_amt ();long    ll_amt1, ll_amt2
string  ls_gubn, ls_empno, ls_date
integer i

dw_ip.AcceptText()

ls_empno = dw_ip.GetItemString(dw_ip.GetRow(), "empno")
ls_date = dw_ip.GetItemString(dw_ip.GetRow(), 'yyyy')

//=====================================================================//
/*보험료 전체*/
select sum(insuranceamt1 + insuranceamt2)
into	:ll_amt1
from p3_acnt_family
where workyear = :ls_date and empno = :ls_empno;

/*장애인보험료*/
select sum(insuranceamt1 + insuranceamt2)
into	:ll_amt2
from p3_acnt_family
where workyear = :ls_date and empno = :ls_empno and
		rubber = '1';

if IsNull(ll_amt1) then ll_amt1 = 0
if IsNull(ll_amt2) then ll_amt2 = 0

stparm.dc[1] = ll_amt1 - ll_amt2		// 일반보험료
stparm.dc[2] = ll_amt2					// 장애인보험료

//=====================================================================//
/*의료비 전체*/
select sum(medicalamt1 + medicalamt2)
into	:ll_amt1
from p3_acnt_family
where workyear = :ls_date and empno = :ls_empno;

/*본인.경로.장애의료비*/
select sum(medicalamt1 + medicalamt2)
into	:ll_amt2
from p3_acnt_family
where workyear = :ls_date and empno = :ls_empno and
		( gubun = '0' or respect65 = '1' or respect70 = '1' or rubber = '1' );

if IsNull(ll_amt1) then ll_amt1 = 0
if IsNull(ll_amt2) then ll_amt2 = 0

stparm.dc[3] = ll_amt1 - ll_amt2		// 일반의료비
stparm.dc[4] = ll_amt2					// 본인.경로.장애의료비

//=====================================================================//
/*신용카드등, 현금영수증*/
select sum(creditcardamt1 + creditcardamt2),
		 sum(cashsubamt)
into	:ll_amt1, :ll_amt2
from p3_acnt_family
where workyear = :ls_date and empno = :ls_empno;

if IsNull(ll_amt1) then ll_amt1 = 0
if IsNull(ll_amt2) then ll_amt2 = 0

stparm.dc[5] = ll_amt1					// 신용카드등
stparm.dc[6] = ll_amt2					// 현금영수증
end subroutine

on w_pip5004.create
int iCurrent
call super::create
this.dw_main=create dw_main
this.dw_ip=create dw_ip
this.cb_copy=create cb_copy
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_main
this.Control[iCurrent+2]=this.dw_ip
this.Control[iCurrent+3]=this.cb_copy
this.Control[iCurrent+4]=this.rr_1
end on

on w_pip5004.destroy
call super::destroy
destroy(this.dw_main)
destroy(this.dw_ip)
destroy(this.cb_copy)
destroy(this.rr_1)
end on

event open;f_window_center(this)

stparm =  Message.PowerObjectParm

dw_ip.SetTransObject(SQLCA)
dw_main.SetTransObject(SQLCA)

dw_ip.Reset()
dw_ip.InsertRow(0)
dw_ip.setitem(1, 'empno', gs_code)
dw_ip.SetItem(1, 'empname', gs_codename)
dw_ip.setitem(1, 'yyyy', gs_gubun)

ii_row = 1

p_inq.TriggerEvent(Clicked!)
end event

event closequery;//override

end event

event close;call super::close;
if exit_gubn = '1' then
	gs_gubun = 'exit'
else
	gs_gubun = 'save'
end if

CloseWithReturn(this,stparm)
end event

type p_mod from w_inherite_standard`p_mod within w_pip5004
integer x = 3849
end type

event p_mod::clicked;call super::clicked;
Long ll_rcnt, li_cnt, li_amt, li_seq, k
String ls_vname, ls_vno, ls_med, ls_rcode, ls_resident, ls_ruv, ls_empno, ls_date

dw_ip.AcceptText()


ls_empno = dw_ip.GetItemString(dw_ip.GetRow(), "empno")
ls_date = dw_ip.GetItemString(dw_ip.GetRow(), 'yyyy')


dw_main.accepttext()

If dw_main.rowcount() = 0 then
	Messagebox("확인", "저장할 자료가 없습니다")
	Return
End if

FOR k = 1 to dw_main.Rowcount()
	 dw_main.Setitem(k, 'seq', k)
Next

SetPointer(HourGlass!)

IF dw_main.Update() > 0 THEN			
	COMMIT USING sqlca;
	ib_any_typing =False	
ELSE
	ROLLBACK USING sqlca;
	ib_any_typing = True
	Return
END IF			

if wf_insert_personal() = -1 then
	messagebox("에러","정산자료 업데이트 실패")
end if
		
ib_any_typing = false
//w_mdi_frame.sle_msg.text ="자료 저장완료!!"

p_inq.TriggerEvent(Clicked!)

messagebox("확인","저장되었습니다")

end event

type p_del from w_inherite_standard`p_del within w_pip5004
integer x = 4023
end type

event p_del::clicked;call super::clicked;
string ls_date, ls_empno, snull, ls_gubun
Integer li_seq, k, li_row
SetNull(snull)

dw_ip.accepttext()	
ls_date = dw_ip.GetItemString(dw_ip.GetRow(), "yyyy")
ls_empno = dw_ip.GetItemString(dw_ip.GetRow(), "empno")

w_mdi_frame.sle_msg.text =""

dw_main.AcceptText()

IF dw_main.GetRow() <= 0 Then Return

ls_gubun = dw_main.GetItemString(dw_main.GetRow(), "gubun")
IF ls_gubun = '0' THEN
	MessageBox('확인','본인 데이터는 삭제할 수 없습니다!')
	Return -1
END IF

li_seq = dw_main.GetItemDecimal(dw_main.GetRow(), "seq")

IF	 MessageBox("삭제 확인", "삭제하시겠습니까? ", question!, yesno!) = 2 THEN Return


SetPointer(HourGlass!)

ii_row = dw_main.Getrow()
dw_main.deleterow(ii_row)

if dw_main.RowCount() < ii_row then ii_row = dw_main.RowCount()

FOR k = 1 to dw_main.Rowcount()
	 dw_main.Setitem(k, 'seq', k)
Next

SetPointer(HourGlass!)

IF dw_main.Update() > 0 THEN			
	COMMIT USING sqlca;
	ib_any_typing =False	
ELSE
	ROLLBACK USING sqlca;
	ib_any_typing = True
	Return
END IF

if wf_insert_personal() = -1 then
	messagebox("에러","정산자료 업데이트 실패")
end if
		
ib_any_typing = false
w_mdi_frame.sle_msg.text ="자료 삭제완료!!"
p_inq.TriggerEvent(Clicked!)


end event

type p_inq from w_inherite_standard`p_inq within w_pip5004
integer x = 3502
end type

event p_inq::clicked;call super::clicked;String ls_empno, ls_date, snull
Integer li_seq, li_row, li_cnt
SetNull(snull)

IF dw_ip.AcceptText() = -1 THEN Return -1

ls_date = dw_ip.GetItemString(dw_ip.GetRow(), 'yyyy')
ls_empno = dw_ip.GetItemString(dw_ip.GetRow(), 'empno')

dw_main.SetReDraw(False)
w_mdi_frame.sle_msg.text = "조회중입니다..."

li_cnt = dw_main.Retrieve(ls_date, ls_empno)
IF li_cnt < 1 THEN
	w_mdi_frame.sle_msg.Text = "조회된 자료가 없습니다."
	li_row = dw_main.InsertRow(0)
	ii_row = 1
	dw_main.SetItem(li_Row, 'seq', 1)
	dw_main.SetItem(li_Row, 'empno', ls_empno)
	dw_main.SetItem(li_Row, 'workyear', ls_date)
	dw_main.SetItem(li_Row, 'gubun', '0')
	dw_main.SetItem(li_Row, 'dependent', '1')
	dw_main.Update()
	Commit;
	
	if wf_insert_personal() = -1 then
		messagebox("에러","정산자료 업데이트 실패")
	end if
	dw_main.SetFocus()
	ib_any_typing = false
END IF

IF li_cnt <= 1 THEN
	cb_copy.enabled = true
ELSE
	cb_copy.enabled = false
END IF

dw_main.SelectRow(0,false)
dw_main.SelectRow(ii_row,true)
dw_main.ScrollToRow(ii_row)

dw_main.SetReDraw(True)
end event

type p_print from w_inherite_standard`p_print within w_pip5004
boolean visible = false
integer x = 1024
integer y = 2516
boolean enabled = false
end type

type p_can from w_inherite_standard`p_can within w_pip5004
integer x = 4197
end type

event p_can::clicked;call super::clicked;String ls_empno, ls_date, snull
SetNull(snull)

IF dw_ip.AcceptText() = -1 THEN Return -1

ls_date = dw_ip.GetItemString(dw_ip.GetRow(), 'yyyy')
ls_empno = dw_ip.GetItemString(dw_ip.GetRow(), 'empno')

dw_main.SetReDraw(False)
w_mdi_frame.sle_msg.text = "조회중입니다..."
IF dw_main.Retrieve(ls_date, ls_empno) < 1 THEN
	dw_main.SetReDraw(True)
	Return 1
END IF
w_mdi_frame.sle_msg.text = ""
dw_main.SetReDraw(True)
end event

type p_exit from w_inherite_standard`p_exit within w_pip5004
integer x = 4370
end type

event p_exit::clicked;wf_sum_amt()

exit_gubn = '2'
CloseWithReturn(parent,stparm)
end event

type p_ins from w_inherite_standard`p_ins within w_pip5004
integer x = 3675
end type

event p_ins::clicked;Integer iCurRow, li_seq
String ls_date, ls_empno
w_mdi_frame.sle_msg.text = ''

//IF ib_any_typing = true THEN
//	IF Messagebox('확인','먼저 데이타를 저장해야 합니다. 저장하시겠습니까?',Question!,YesNo!,1) = 1 THEN
//		IF dw_main.Update() > 0 THEN			
//			COMMIT USING sqlca;
//			ib_any_typing =False	
//		ELSE
//			ROLLBACK USING sqlca;
//			ib_any_typing = True
//			MessageBox('저장 실패', '저장에 실패하였습니다.')
//			Return
//		END IF
//	ELSE
//		RETURN
//	END IF
//END IF

dw_ip.AcceptText()
ls_date = dw_ip.GetItemString(dw_ip.GetRow(), 'yyyy')
ls_empno = dw_ip.GetItemString(dw_ip.GetRow(), 'empno')

dw_main.SetReDraw(False)
iCurRow = dw_main.InsertRow(0)
dw_main.ScrollToRow(iCurRow)

SELECT max(seq)
  INTO :li_seq
  FROM p3_acnt_family
 WHERE workyear = :ls_date AND
       empno = :ls_empno;

IF string(li_seq) = '' OR IsNull(String(li_seq)) THEN li_seq = 0

//dw_main.SetItem(iCurRow, 'seq', li_seq + 1)
dw_main.SetItem(iCurRow, 'empno', ls_empno)
dw_main.SetItem(iCurRow, 'workyear', ls_date)

dw_main.SelectRow(0,false)
dw_main.SelectRow(iCurRow,true)

//IF dw_main.RowCount() <= 1 THEN
//	IF li_seq = 0 THEN
//		p_inq.TriggerEvent(Clicked!)
//		dw_main.SetReDraw(True)	
//	END IF
//ELSE
//	IF li_seq + 1 = dw_main.GetItemDecimal(iCurRow - 1, 'seq') THEN
//		p_inq.TriggerEvent(Clicked!)
//		w_mdi_frame.sle_msg.Text = "새롭게 저장된 자료가 없습니다. 새로운 자료를 저장한 후에 추가하십시오."
//		dw_main.SetReDraw(True)	
//		Return
//	END IF
//END IF
ib_any_typing = true
dw_main.SetColumn("gubun")
dw_main.SetFocus()
dw_main.SetReDraw(True)	




end event

type p_search from w_inherite_standard`p_search within w_pip5004
boolean visible = false
integer x = 846
integer y = 2516
boolean enabled = false
end type

type p_addrow from w_inherite_standard`p_addrow within w_pip5004
boolean visible = false
integer x = 1202
integer y = 2516
boolean enabled = false
end type

type p_delrow from w_inherite_standard`p_delrow within w_pip5004
boolean visible = false
integer x = 1376
integer y = 2516
boolean enabled = false
end type

type dw_insert from w_inherite_standard`dw_insert within w_pip5004
boolean visible = false
end type

type st_window from w_inherite_standard`st_window within w_pip5004
end type

type cb_exit from w_inherite_standard`cb_exit within w_pip5004
end type

type cb_update from w_inherite_standard`cb_update within w_pip5004
end type

type cb_insert from w_inherite_standard`cb_insert within w_pip5004
end type

type cb_delete from w_inherite_standard`cb_delete within w_pip5004
end type

type cb_retrieve from w_inherite_standard`cb_retrieve within w_pip5004
end type

type st_1 from w_inherite_standard`st_1 within w_pip5004
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_pip5004
end type

type dw_datetime from w_inherite_standard`dw_datetime within w_pip5004
end type

type sle_msg from w_inherite_standard`sle_msg within w_pip5004
end type

type gb_2 from w_inherite_standard`gb_2 within w_pip5004
end type

type gb_1 from w_inherite_standard`gb_1 within w_pip5004
end type

type gb_10 from w_inherite_standard`gb_10 within w_pip5004
end type

type dw_main from u_d_select_sort within w_pip5004
event ue_enter pbm_dwnprocessenter
integer x = 82
integer y = 216
integer width = 4439
integer height = 1948
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_pip5004_1"
boolean vscrollbar = false
boolean border = false
end type

event ue_enter;send(Handle(this), 256, 9, 0)
Return 1
end event

event editchanged;call super::editchanged;ib_any_typing = true
end event

event itemerror;call super::itemerror;return 1
end event

event itemchanged;call super::itemchanged;string ls_cnt, snull, ls_resino
int li_cnt

if dwo.name = 'dependent' then
	ls_cnt =	this.Gettext()
	if ls_cnt <> '1' then
		this.Setitem(dw_main.getrow(), 'respect65', snull)
		this.Setitem(dw_main.getrow(), 'respect70', snull)
		this.Setitem(dw_main.getrow(), 'rubber', snull)
		this.Setitem(dw_main.getrow(), 'childcount', snull)
	end if
		
end if
if dwo.name = 'respect65' or dwo.name = 'respect70' or dwo.name = 'rubber' or dwo.name = 'childcount' then
   ls_cnt =	this.Gettext()
	if ls_cnt = '1' then 
		this.Setitem(dw_main.getrow(), 'dependent', ls_cnt)
	end if
end if

if dwo.name = 'residentno' then
	ls_resino = this.Gettext()
	if this.GetitemString(this.getrow(), 'inout') <> '9' then
		IF f_vendcode_check(ls_resino) = False THEN
				IF MessageBox("확 인","주민등록번호가 틀렸습니다. 계속하시겠습니까?",Question!,YesNo!) = 2 then
					this.SetItem(this.GetRow(),"residentno",snull)
					this.SetColumn("residentno")
					Return 1
				END IF
		END IF
	end if	
end if
end event

type dw_ip from u_key_enter within w_pip5004
integer x = 78
integer y = 36
integer width = 1806
integer height = 132
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_pip5003_1_c"
boolean border = false
end type

type cb_copy from commandbutton within w_pip5004
integer x = 1943
integer y = 56
integer width = 411
integer height = 84
integer taborder = 21
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "가족사항 복사"
end type

event clicked;if ib_any_typing = true then
	MessageBox('확인','수정된 데이터를 먼저 저장하셔야 합니다!')
	return 1
end if

String ls_Sql
ls_Sql = 'select empno from p1_master where empno = ' + "'" + gs_code + "'"

gs_gubun = gs_gubun + '12'
DECLARE start_sp_insert_family procedure for sp_insert_family(:gs_gubun, :ls_Sql, :gs_company);

execute start_sp_insert_family ;

IF SQLCA.SQLERRTEXT <> '' THEN
	MessageBox('Procedure Error', SQLCA.SQLERRTEXT)
END IF

ii_row = 1
p_mod.TriggerEvent(Clicked!)
end event

type rr_1 from roundrectangle within w_pip5004
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 73
integer y = 208
integer width = 4462
integer height = 1960
integer cornerheight = 40
integer cornerwidth = 55
end type

