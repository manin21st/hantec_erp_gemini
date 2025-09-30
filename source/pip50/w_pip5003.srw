$PBExportHeader$w_pip5003.srw
$PBExportComments$** 의료비/기부금 등록
forward
global type w_pip5003 from w_inherite_standard
end type
type dw_main from u_d_select_sort within w_pip5003
end type
type dw_ip from u_key_enter within w_pip5003
end type
type st_note from statictext within w_pip5003
end type
type rr_1 from roundrectangle within w_pip5003
end type
end forward

global type w_pip5003 from w_inherite_standard
string title = "의료비 등록"
string menuname = ""
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
dw_main dw_main
dw_ip dw_ip
st_note st_note
rr_1 rr_1
end type
global w_pip5003 w_pip5003

type variables
muiltstr	stparm
String      is_gubun, exit_gubn = '1'
end variables

forward prototypes
public subroutine wf_sum_donation ()
public subroutine wf_sum_medical ()
end prototypes

public subroutine wf_sum_donation ();long    ll_amt1, ll_amt2, ll_amt3, ll_amt4, ll_amt5, ll_amt6
string  ls_gubn, ls_empno, ls_date
integer i
//
//for i = 1 to dw_main.RowCount()
//	ls_gubn = dw_main.GetItemString(i,'gubn_code')
//	ll_amt  = dw_main.GetItemNumber(i,'amt')
//	
//	choose case ls_gubn
//		case '10','21' 				//법정기부금, 진흥기금출연
//			stparm.dc[1] += ll_amt
//		case '20'						//정치자금
//			stparm.dc[2] += ll_amt
//		case '30'						//조특법73
//			stparm.dc[3] += ll_amt
//		case '42'						//우리사주조합기부금
//			stparm.dc[4] += ll_amt
//		case '40','41' 				//지정기부금, 종교단체기부금
//			stparm.dc[5] += ll_amt
//	end choose
//next

dw_ip.AcceptText()

ls_empno = dw_ip.GetItemString(dw_ip.GetRow(), "empno")
ls_date = dw_ip.GetItemString(dw_ip.GetRow(), 'yyyy')

select sum(decode(gubn_code, '10', amt, '21', amt, 0)),
       sum(decode(gubn_code, '20', amt, 0)),
		 sum(decode(gubn_code, '30', amt, '31', amt, 0)),
 		 sum(decode(gubn_code, '42', amt, 0)),
		 sum(decode(gubn_code, '41', amt, 0)),
 		 sum(decode(gubn_code, '40', amt, 0))	
into	:ll_amt1, :ll_amt2, :ll_amt3, :ll_amt4, :ll_amt5, :ll_amt6	 
from p3_acnt_donation
where workyear = :ls_date and empno = :ls_empno;

if IsNull(ll_amt1) then ll_amt1 = 0
if IsNull(ll_amt2) then ll_amt2 = 0
if IsNull(ll_amt3) then ll_amt3 = 0
if IsNull(ll_amt4) then ll_amt4 = 0
if IsNull(ll_amt5) then ll_amt5 = 0
if IsNull(ll_amt6) then ll_amt6 = 0

stparm.dc[1] = ll_amt1
stparm.dc[2] = ll_amt2
stparm.dc[3] = ll_amt3
stparm.dc[4] = ll_amt4
stparm.dc[5] = ll_amt5
stparm.dc[6] = ll_amt6


end subroutine

public subroutine wf_sum_medical ();long    ll_amt1, ll_amt2
string  ls_gubn, ls_empno, ls_date
integer i

//for i = 1 to dw_main.RowCount()
//	ls_gubn = dw_main.GetItemString(i,'res_rub_div')
//	ll_amt  = dw_main.GetItemNumber(i,'amt')
//	
//	choose case ls_gubn
//		case '1' 						//본인.장애.경로의료비
//			stparm.dc[1] += ll_amt
//		case '2'							//일반의료비
//			stparm.dc[2] += ll_amt
//	end choose
//next


dw_ip.AcceptText()

ls_empno = dw_ip.GetItemString(dw_ip.GetRow(), "empno")
ls_date = dw_ip.GetItemString(dw_ip.GetRow(), 'yyyy')

select sum(decode(res_rub_div, '1', amt + credit_amt, 0)),
       sum(decode(res_rub_div, '2', amt + credit_amt, 0))
into	:ll_amt1, :ll_amt2
from p3_acnt_medical
where workyear = :ls_date and empno = :ls_empno;

if IsNull(ll_amt1) then ll_amt1 = 0
if IsNull(ll_amt2) then ll_amt2 = 0


stparm.dc[1] = ll_amt1
stparm.dc[2] = ll_amt2



end subroutine

on w_pip5003.create
int iCurrent
call super::create
this.dw_main=create dw_main
this.dw_ip=create dw_ip
this.st_note=create st_note
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_main
this.Control[iCurrent+2]=this.dw_ip
this.Control[iCurrent+3]=this.st_note
this.Control[iCurrent+4]=this.rr_1
end on

on w_pip5003.destroy
call super::destroy
destroy(this.dw_main)
destroy(this.dw_ip)
destroy(this.st_note)
destroy(this.rr_1)
end on

event open;f_window_center_response(this)

stparm =  Message.PowerObjectParm
is_gubun = stparm.s[1]

IF is_gubun = '1' THEN
	dw_main.dataobject = 'd_pip5003_1'  /*의료비 등록*/
	title = '의료비 등록'
	st_note.visible = false
ELSE
	dw_main.dataobject = 'd_pip5003_2'  /*기부금 등록*/
	title = '기부금 등록'
	st_note.visible = true
END IF

dw_ip.SetTransObject(SQLCA)
dw_main.SetTransObject(SQLCA)

dw_ip.Reset()
dw_ip.InsertRow(0)
dw_ip.setitem(1, 'empno', gs_code)
dw_ip.SetItem(1, 'empname', gs_codename)
dw_ip.setitem(1, 'yyyy', gs_gubun)

p_inq.TriggerEvent(Clicked!)
end event

event close;call super::close;   
	if is_gubun = '1' then
		wf_sum_medical()
	else
		wf_sum_donation()
	end if
	
	if exit_gubn = '1' then
		gs_gubun = 'exit'
	else
		gs_gubun = 'save'
	end if
	CloseWithReturn(this,stparm)
	
	
end event

type p_mod from w_inherite_standard`p_mod within w_pip5003
end type

event p_mod::clicked;call super::clicked;
Long ll_rcnt, li_cnt, li_amt, li_seq, k
String ls_vname, ls_vno, ls_med, ls_rcode, ls_resident, ls_ruv, ls_empno, ls_date, ls_gubun

dw_ip.AcceptText()


ls_empno = dw_ip.GetItemString(dw_ip.GetRow(), "empno")
ls_date = dw_ip.GetItemString(dw_ip.GetRow(), 'yyyy')


dw_main.accepttext()

If dw_main.rowcount() = 0 then
	Messagebox("확인", "저장할 자료가 없습니다")
	Return
End if

SetPointer(HourGlass!)

FOR k = 1 to dw_main.Rowcount()
	 dw_main.Setitem(k, 'seq', k)
Next
if dw_main.dataobject = 'd_pip5003_2' then  //기부금
   FOR k = 1 to dw_main.Rowcount()
		 ls_gubun = dw_main.GetItemString(k, "gubn_code")
		 if ls_gubun = '31' then
			 dw_main.Setitem(k, 'gfromdate', ls_date+'0101')
			 dw_main.Setitem(k, 'gtodate', ls_date+'1231')
 		 end if	 
   Next
end if


IF dw_main.Update() > 0 THEN			
	COMMIT USING sqlca;
	ib_any_typing =False	
ELSE
	ROLLBACK USING sqlca;
	ib_any_typing = True
	Return
END IF			

ib_any_typing = false
w_mdi_frame.sle_msg.text ="자료 저장완료!!"
SetPointer(Arrow!)

//messagebox("확인","성공적으로 저장하였습니다")

end event

type p_del from w_inherite_standard`p_del within w_pip5003
end type

event p_del::clicked;call super::clicked;
string ls_date, ls_empno, snull
Integer li_seq, K
SetNull(snull)

dw_ip.accepttext()	
ls_date = dw_ip.GetItemString(dw_ip.GetRow(), "yyyy")
ls_empno = dw_ip.GetItemString(dw_ip.GetRow(), "empno")

w_mdi_frame.sle_msg.text =""

dw_main.AcceptText()

IF dw_main.GetRow() <= 0 Then Return

li_seq = dw_main.GetItemDecimal(dw_main.GetRow(), "seq")

IF	 MessageBox("삭제 확인", "삭제하시겠습니까? ", question!, yesno!) = 2 THEN Return


SetPointer(HourGlass!)

dw_main.deleterow(dw_main.Getrow())

FOR k = 1 to dw_main.Rowcount()
	 dw_main.Setitem(k, 'seq', k)
Next


IF dw_main.Update() > 0 THEN			
	COMMIT USING sqlca;
	ib_any_typing =False	
ELSE
	ROLLBACK USING sqlca;
	ib_any_typing = True
	Return
END IF		


SetPointer(Arrow!)
end event

type p_inq from w_inherite_standard`p_inq within w_pip5003
integer x = 3515
end type

event p_inq::clicked;call super::clicked;String ls_empno, ls_date, snull
Integer li_seq, li_row
SetNull(snull)

IF dw_ip.AcceptText() = -1 THEN Return -1

ls_date = dw_ip.GetItemString(dw_ip.GetRow(), 'yyyy')
ls_empno = dw_ip.GetItemString(dw_ip.GetRow(), 'empno')

dw_main.SetReDraw(False)
w_mdi_frame.sle_msg.text = "조회중입니다..."
IF dw_main.Retrieve(ls_date, ls_empno) < 1 THEN
	w_mdi_frame.sle_msg.Text = "조회된 자료가 없습니다."
	li_row = dw_main.InsertRow(0)
	
	SELECT count(*)
 	  INTO :li_seq
  	  FROM p3_acnt_medical
	 WHERE workyear = :ls_date AND
   	    empno = :ls_empno;
  
	dw_main.SetItem(li_Row, 'seq', li_seq + 1)
	dw_main.SetItem(li_Row, 'empno', ls_empno)
	dw_main.SetItem(li_Row, 'workyear', ls_date)
	
	dw_main.SetColumn("vendor_name")
	dw_main.SetFocus()
END IF
ib_any_typing = false
dw_main.SetReDraw(True)
end event

type p_print from w_inherite_standard`p_print within w_pip5003
boolean visible = false
integer x = 535
integer y = 2284
boolean enabled = false
end type

type p_can from w_inherite_standard`p_can within w_pip5003
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

type p_exit from w_inherite_standard`p_exit within w_pip5003
end type

event p_exit::clicked;   
	if is_gubun = '1' then
		wf_sum_medical()
	else
		wf_sum_donation()
	end if
	
	if dw_main.rowcount() < 1 then
		exit_gubn = '1' 
	else	
		if dw_main.rowcount() = 1 then
			if IsNull(dw_main.GetitemString(1,'vendor_no')) or dw_main.GetitemString(1,'vendor_no') = '' then
				exit_gubn = '1' 
			else	
   	      exit_gubn = '2'
			end if
		else
			 exit_gubn = '2'
		end if
	end if
	CloseWithReturn(parent,stparm)
	
	
end event

type p_ins from w_inherite_standard`p_ins within w_pip5003
integer x = 3689
end type

event p_ins::clicked;Integer iCurRow, li_seq
String ls_date, ls_empno
w_mdi_frame.sle_msg.text = ''

dw_ip.AcceptText()
ls_date = dw_ip.GetItemString(dw_ip.GetRow(), 'yyyy')
ls_empno = dw_ip.GetItemString(dw_ip.GetRow(), 'empno')

dw_main.SetReDraw(False)
iCurRow = dw_main.InsertRow(0)
dw_main.ScrollToRow(iCurRow)


dw_main.SetItem(iCurRow, 'empno', ls_empno)
dw_main.SetItem(iCurRow, 'workyear', ls_date)

ib_any_typing = true
dw_main.SetColumn("vendor_name")
dw_main.SetFocus()
dw_main.SetReDraw(True)	




end event

type p_search from w_inherite_standard`p_search within w_pip5003
boolean visible = false
integer x = 357
integer y = 2284
boolean enabled = false
end type

type p_addrow from w_inherite_standard`p_addrow within w_pip5003
boolean visible = false
integer x = 713
integer y = 2284
boolean enabled = false
end type

type p_delrow from w_inherite_standard`p_delrow within w_pip5003
boolean visible = false
integer x = 887
integer y = 2284
boolean enabled = false
end type

type dw_insert from w_inherite_standard`dw_insert within w_pip5003
boolean visible = false
end type

type st_window from w_inherite_standard`st_window within w_pip5003
end type

type cb_exit from w_inherite_standard`cb_exit within w_pip5003
end type

type cb_update from w_inherite_standard`cb_update within w_pip5003
end type

type cb_insert from w_inherite_standard`cb_insert within w_pip5003
end type

type cb_delete from w_inherite_standard`cb_delete within w_pip5003
end type

type cb_retrieve from w_inherite_standard`cb_retrieve within w_pip5003
end type

type st_1 from w_inherite_standard`st_1 within w_pip5003
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_pip5003
end type

type dw_datetime from w_inherite_standard`dw_datetime within w_pip5003
end type

type sle_msg from w_inherite_standard`sle_msg within w_pip5003
end type

type gb_2 from w_inherite_standard`gb_2 within w_pip5003
end type

type gb_1 from w_inherite_standard`gb_1 within w_pip5003
end type

type gb_10 from w_inherite_standard`gb_10 within w_pip5003
end type

type dw_main from u_d_select_sort within w_pip5003
event ue_enter pbm_dwnprocessenter
integer x = 453
integer y = 236
integer width = 3653
integer height = 2048
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_pip5003_1"
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

event itemchanged;call super::itemchanged;string ls_resino, snull

if dwo.name = 'residentno' then
	ls_resino = this.Gettext()
	
	IF f_vendcode_check(ls_resino) = False THEN
			IF MessageBox("확 인","주민등록번호가 틀렸습니다. 계속하시겠습니까?",Question!,YesNo!) = 2 then
				this.SetItem(this.GetRow(),"residentno",snull)
				this.SetColumn("residentno")
				Return 1
			END IF
	END IF
end if


if dwo.name = 'vendor_no' then
	ls_resino = this.Gettext()
	
	IF f_vendcode_check(ls_resino) = False THEN
			IF MessageBox("확 인","사업자(주민)번호가 틀렸습니다. 계속하시겠습니까?",Question!,YesNo!) = 2 then
				this.SetItem(this.GetRow(),"vendor_no",snull)
				this.SetColumn("vendor_no")
				Return 1
			END IF
	END IF
end if
end event

type dw_ip from u_key_enter within w_pip5003
integer x = 443
integer y = 80
integer width = 1806
integer height = 132
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_pip5003_1_c"
boolean border = false
end type

type st_note from statictext within w_pip5003
integer x = 2290
integer y = 120
integer width = 1138
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388736
long backcolor = 32106727
string text = "* 사업자(주민)번호는 ~'-~' 없이 입력하세요."
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_pip5003
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 443
integer y = 232
integer width = 3675
integer height = 2060
integer cornerheight = 40
integer cornerwidth = 55
end type

