$PBExportHeader$w_cic00060.srw
$PBExportComments$기초이월등록(재공품)
forward
global type w_cic00060 from w_inherite
end type
type dw_1 from datawindow within w_cic00060
end type
type dw_2 from datawindow within w_cic00060
end type
type dw_3 from datawindow within w_cic00060
end type
type dw_4 from datawindow within w_cic00060
end type
type dw_5 from datawindow within w_cic00060
end type
type dw_6 from datawindow within w_cic00060
end type
type dw_7 from datawindow within w_cic00060
end type
type st_2 from statictext within w_cic00060
end type
type p_1 from uo_picture within w_cic00060
end type
type r_1 from rectangle within w_cic00060
end type
type r_2 from rectangle within w_cic00060
end type
type r_3 from rectangle within w_cic00060
end type
end forward

global type w_cic00060 from w_inherite
string title = "기초이월등록(재공품)"
dw_1 dw_1
dw_2 dw_2
dw_3 dw_3
dw_4 dw_4
dw_5 dw_5
dw_6 dw_6
dw_7 dw_7
st_2 st_2
p_1 p_1
r_1 r_1
r_2 r_2
r_3 r_3
end type
global w_cic00060 w_cic00060

type variables
string is_yymm, is_saupj
end variables

forward prototypes
public function integer wf_required_chk ()
end prototypes

public function integer wf_required_chk ();
long ll_qty, ll_amt, i

For i = 1 to dw_2.Rowcount()
    ll_qty = dw_2.GetitemNumber(i, "wp_qty")
	 
	 if IsNull(ll_qty) or ll_qty = 0 then
        messagebox("확인","재공수량를 입력하세요")
		  return -1
	 end if
	
Next


For i = 1 to dw_3.Rowcount()
    ll_amt = dw_3.GetitemNumber(i, "es_amt")
	 
	 if IsNull(ll_amt) or ll_amt = 0 then
	     messagebox("확인","자재소요량 및 금액을 입력하세요")
		 return -1
	 end if
	
Next

return 1
end function

on w_cic00060.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_2=create dw_2
this.dw_3=create dw_3
this.dw_4=create dw_4
this.dw_5=create dw_5
this.dw_6=create dw_6
this.dw_7=create dw_7
this.st_2=create st_2
this.p_1=create p_1
this.r_1=create r_1
this.r_2=create r_2
this.r_3=create r_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.dw_3
this.Control[iCurrent+4]=this.dw_4
this.Control[iCurrent+5]=this.dw_5
this.Control[iCurrent+6]=this.dw_6
this.Control[iCurrent+7]=this.dw_7
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.p_1
this.Control[iCurrent+10]=this.r_1
this.Control[iCurrent+11]=this.r_2
this.Control[iCurrent+12]=this.r_3
end on

on w_cic00060.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.dw_3)
destroy(this.dw_4)
destroy(this.dw_5)
destroy(this.dw_6)
destroy(this.dw_7)
destroy(this.st_2)
destroy(this.p_1)
destroy(this.r_1)
destroy(this.r_2)
destroy(this.r_3)
end on

event open;call super::open;string vWorkym

dw_1.SettransObject(sqlca)
dw_2.SettransObject(sqlca)
dw_3.SettransObject(sqlca)
dw_4.SettransObject(sqlca)
dw_5.SettransObject(sqlca)
dw_6.SettransObject(sqlca)
dw_7.SettransObject(sqlca)


SELECT nvl(fun_get_aftermonth(max(workym), 1),substr(to_char(sysdate,'yyyymmdd'),1,6))
   INTO :vWorkym
   FROM CIC0010
 WHERE  end_yn = 'Y';

dw_1.Insertrow(0)
//dw_1.Setitem(1,"yymm", left(f_today(),6))
dw_1.SetItem(1, 'yymm', vWorkym)
dw_1.SetItem(1,"saupj",  gs_saupj)




p_inq.Triggerevent(Clicked!)
end event

type dw_insert from w_inherite`dw_insert within w_cic00060
integer y = 2340
end type

type p_delrow from w_inherite`p_delrow within w_cic00060
integer x = 3918
boolean originalsize = true
end type

event p_delrow::clicked;call super::clicked;
long   ll_seqno, lrow ,  chk, k, i

lrow   = dw_2.getrow()


ll_seqno  = dw_2.getitemNumber(lrow,'seqno')

chk   = messagebox('','선택 항목을 삭제하시겠습니까?',QUESTION!,okcancel!,2)

if chk = 1 then
	
	if dw_3.rowcount() > 0 then
		if messagebox('','자재단가 정보도 함께 삭제됩니다 지우시겠습니까?',QUESTION!,okcancel!,2) = 2 then
			return
		else
			for i = 1 to dw_3.rowcount()
				 dw_3.deleterow(i)
				 i -= 1
			next	 
			
			for i = 1 to dw_4.rowcount()
				 dw_4.deleterow(i)
				 i -= 1
			next	 
			
			
   	end if
	end if	
	
	dw_2.deleterow(lrow)
	w_mdi_frame.sle_msg.text = "완전히 삭제하시려면 저장하세요~!!"
	//p_mod.Triggerevent(Clicked!)
else
	return
end if
end event

type p_addrow from w_inherite`p_addrow within w_cic00060
integer x = 3744
boolean originalsize = true
end type

event p_addrow::clicked;call super::clicked;int li_row

if dw_2.rowcount() < 1 then
	li_row = 0
else
	li_row = dw_2.GetitemNumber( dw_2.Rowcount(), "seqno")
end if

dw_2.insertrow(0)

dw_2.Setitem(dw_2.Rowcount(), "seqno",   li_row + 1)
dw_2.Setitem(dw_2.Rowcount(), "workym",  is_yymm)
dw_2.Setitem(dw_2.Rowcount(), "saupj",  is_saupj)

end event

type p_search from w_inherite`p_search within w_cic00060
boolean visible = false
integer x = 2359
boolean enabled = false
end type

event p_search::clicked;call super::clicked;Int  li_seqno, i
String ls_itnbr, ls_nm, ls_acccd, ls_accname, ls_opseq
String ls_filter1, ls_filter2

IF dw_2.GetSelectedRow(0) <=0 THEN
	MessageBox("확 인","조회할 품목을 선택하세요!!")
	Return
ELSE
	li_seqno = dw_2.GetItemNumber(dw_2.GetSelectedRow(0),"seqno")
	ls_itnbr = dw_2.GetitemString(dw_2.GetSelectedRow(0),"wp_itnbr")
	ls_opseq = dw_2.GetitemString(dw_2.GetSelectedRow(0),"opseq")
END IF

if IsNull(ls_itnbr) or ls_itnbr = "" then
	return
end if


ls_filter1 = ""
ls_filter1 = "string(seqno) = '" + string(li_seqno) +  "'"
dw_3.Setfilter(ls_filter1)
dw_3.filter()

dw_6.retrieve(ls_itnbr, is_yymm, ls_opseq)

IF dw_3.rowcount() < 1 then
	if dw_6.retrieve(ls_itnbr, is_yymm,ls_opseq) > 0 then
		For i = 1 to dw_6.rowcount()
			 ls_itnbr = dw_6.GetItemString(i, "mitnbr") 
			 ls_nm = dw_6.GetItemString(i, "vw_itdsc") 
			 
			 dw_3.insertrow(0)
			 
			 dw_3.Setitem(i, "seqno", li_seqno)
			 dw_3.Setitem(i, "itnbr", ls_itnbr)
			 dw_3.Setitem(i, "vw_titnm", ls_nm)		
			 dw_3.Setitem(i, "workym", is_yymm)	
			 dw_3.Setitem(i, "saupj", is_saupj)
			
	   Next
   end if
	
	
ELSE
	dw_3.ScrollToRow(dw_3.RowCount())
END IF

ls_filter2 = ""
ls_filter2 = "string(seqno) = '" + string(li_seqno) +  "'"
dw_4.Setfilter(ls_filter2)
dw_4.filter()

IF dw_4.retrieve(is_yymm, is_saupj, li_seqno) <= 0 then

		For i = 1 to dw_7.rowcount()
			 ls_acccd = dw_7.GetItemString(i, "rfgub") 
			 ls_accname = dw_7.GetItemString(i, "rfna1") 
			 
			
			 dw_4.insertrow(0)
			 
			 dw_4.Setitem(i, "seqno", li_seqno)
			 dw_4.Setitem(i, "exp_cd", ls_acccd)
			 dw_4.Setitem(i, "rfnm", ls_accname)	
			 dw_4.Setitem(i, "workym", is_yymm)	
			 dw_4.Setitem(i, "saupj", is_saupj)
			
	   Next
 
	
	
ELSE
	dw_3.ScrollToRow(dw_3.RowCount())
END IF
end event

type p_ins from w_inherite`p_ins within w_cic00060
boolean visible = false
integer x = 2706
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_cic00060
end type

type p_can from w_inherite`p_can within w_cic00060
end type

event p_can::clicked;call super::clicked;Int  li_seqno, i
String ls_itnbr, ls_nm, ls_acccd, ls_accname, ls_opseq
String ls_filter1, ls_filter2
long ll_qty, ll_danga, ll_amt, ll_jqty, ll_totqty

IF dw_2.GetSelectedRow(0) <=0 THEN	
	Return
ELSE
	li_seqno = dw_2.GetItemNumber(dw_2.GetSelectedRow(0),"seqno")
	ls_itnbr = dw_2.GetitemString(dw_2.GetSelectedRow(0),"wp_itnbr")
	ls_opseq = dw_2.GetitemString(dw_2.GetSelectedRow(0),"opseq")
END IF

if IsNull(ls_itnbr) or ls_itnbr = "" then
	return
end if


ls_filter1 = ""
ls_filter1 = "string(seqno) = '" + string(li_seqno) +  "'"
dw_3.Setfilter(ls_filter1)
dw_3.filter()

dw_6.retrieve(ls_itnbr, is_yymm, ls_opseq)


if dw_6.rowcount() > 0 and dw_3.rowcount() > 0 then
	For i = 1 to dw_6.rowcount()
		 ls_itnbr = dw_6.GetItemString(i, "mitnbr") 
		 ls_nm = dw_6.GetItemString(i, "vw_titnm") 	
		  ll_jqty = dw_6.GetItemNumber(i, "un_qty") 
	    ll_danga = dw_6.GetItemNumber(i, "danga") 
		 
		 dw_3.Setitem(i, "seqno", li_seqno)
		 dw_3.Setitem(i, "itnbr", ls_itnbr)
		 dw_3.Setitem(i, "vw_titnm", ls_nm)		
		 dw_3.Setitem(i, "workym", is_yymm)	
		 dw_3.Setitem(i, "saupj", is_saupj)
		 
		 if IsNull(ll_qty) or ll_qty = 0 then
		 else
			 ll_totqty = ll_jqty * ll_qty
			 ll_amt = ll_totqty * ll_danga
			 dw_3.Setitem(i, "es_prc", ll_danga)
			 dw_3.Setitem(i, "es_qty", ll_totqty)
			 dw_3.Setitem(i, "es_amt", ll_amt)
		 end if	 
		
	Next
end if






	
	


end event

type p_print from w_inherite`p_print within w_cic00060
boolean visible = false
integer x = 2533
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_cic00060
integer x = 3566
boolean originalsize = true
end type

event p_inq::clicked;call super::clicked;string snull
SetNull(snull)

if dw_1.Accepttext() = -1 then return

is_yymm = dw_1.GetItemString(1, "yymm")
is_saupj = dw_1.GetItemString(1, "saupj")

if IsNull(is_yymm) or is_yymm = "" then 
   messagebox("확인","년월을 입력하세요!")
   dw_1.SetItem(1,"yymm", snull)
   dw_1.SetColumn("yymm")
   dw_1.Setfocus()
   return
end if

if f_datechk(is_yymm+'01') = -1 then
   messagebox("확인","년월을 확인하세요!")
   dw_1.SetItem(1,"yymm", snull)
   dw_1.SetColumn("yymm")
   dw_1.Setfocus()
   return
end if	

if dw_2.Retrieve(is_yymm, is_saupj) < 1 then
	dw_3.Retrieve(is_yymm, is_saupj)
   dw_4.Retrieve(is_yymm, is_saupj)
   w_mdi_frame.sle_msg.text = "조회할 자료가 없습니다!"
   return
end if

dw_3.Retrieve(is_yymm, is_saupj)
dw_4.Retrieve(is_yymm, is_saupj)





end event

type p_del from w_inherite`p_del within w_cic00060
boolean visible = false
integer x = 2885
integer y = 20
boolean enabled = false
end type

type p_mod from w_inherite`p_mod within w_cic00060
integer x = 4091
boolean originalsize = true
end type

event p_mod::clicked;call super::clicked;if wf_required_chk() = -1 then	
	return
end if

If dw_2.Update() = 1 Then
   ib_any_typing = False
	w_mdi_frame.sle_msg.text ="자료를 저장하였습니다!!"
	commit using sqlca;
		
Else
   messagebox("확인","마스터 자료저장시 에러!")
	Rollback;
end If

If dw_3.Update() = 1 Then
   ib_any_typing = False
	w_mdi_frame.sle_msg.text ="자료를 저장하였습니다!!"
	commit using sqlca;
		
Else
   messagebox("확인","자재단가 저장시 에러!")
	Rollback;
end If

If dw_4.Update() = 1 Then
   ib_any_typing = False
	w_mdi_frame.sle_msg.text ="자료를 저장하였습니다!!"
	commit using sqlca;
		
Else
   messagebox("확인","계정정보 저장시 에러!")
	Rollback;
end If



w_mdi_frame.sle_msg.text ="자료를 저장하였습니다!!"
end event

type cb_exit from w_inherite`cb_exit within w_cic00060
end type

type cb_mod from w_inherite`cb_mod within w_cic00060
end type

type cb_ins from w_inherite`cb_ins within w_cic00060
end type

type cb_del from w_inherite`cb_del within w_cic00060
end type

type cb_inq from w_inherite`cb_inq within w_cic00060
end type

type cb_print from w_inherite`cb_print within w_cic00060
end type

type st_1 from w_inherite`st_1 within w_cic00060
end type

type cb_can from w_inherite`cb_can within w_cic00060
end type

type cb_search from w_inherite`cb_search within w_cic00060
end type







type gb_button1 from w_inherite`gb_button1 within w_cic00060
end type

type gb_button2 from w_inherite`gb_button2 within w_cic00060
end type

type dw_1 from datawindow within w_cic00060
integer y = 28
integer width = 1733
integer height = 188
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "dw_cic00060_1"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;string snull
SetNull(snull)

if dw_1.Accepttext() = -1 then return

if This.GetColumnName() = "yymm" then
	is_yymm = This.Gettext()
	if IsNull(is_yymm) or is_yymm = "" then 
	 	 messagebox("확인","년월을 입력하세요!")
		 dw_1.SetItem(1,"yymm", snull)
		 dw_1.SetColumn("yymm")
		 dw_1.Setfocus()
		 return
	end if

	if f_datechk(is_yymm+'01') = -1 then
		messagebox("확인","년월을 확인하세요!")
		dw_1.SetItem(1,"yymm", snull)
		dw_1.SetColumn("yymm")
		dw_1.Setfocus()
		return
	end if	
end if	


if This.GetColumnName() = "saupj" then
	is_saupj = This.Gettext()
	if IsNull(is_saupj) or is_saupj = "" then is_saupj = '%'
end if


p_inq.Triggerevent(Clicked!)


end event

event itemerror;return 1
end event

type dw_2 from datawindow within w_cic00060
integer x = 14
integer y = 236
integer width = 2455
integer height = 1976
integer taborder = 60
boolean bringtotop = true
string title = "none"
string dataobject = "dw_cic00060_2"
boolean hscrollbar = true
boolean border = false
boolean livescroll = true
end type

event rbuttondown;String ls_itnbr, ls_titnm, ls_itdsc
SetNull(gs_gubun)

gs_gubun = '1'
Open(w_itemas_popup10_cic)

if gs_gubun <> 'Y' OR ISNULL(gs_Gubun)  then  REturn 

dw_5.SettransObject(sqlca)
dw_5.ReSet()
dw_5.ImportClipboard()

string ls_filter
Int  li_row, li_Trow, li_seq
ls_filter = "flag = 'Y'"
dw_5.SetFilter(ls_filter)
dw_5.filter()

li_Trow = dw_5.Rowcount()
li_seq = dw_2.GetItemNumber(dw_2.Rowcount(), "seqno")

if this.getrow() = dw_2.Rowcount() then  //추가후 다중선택이면

	li_row = 1
	For li_row = 1 to li_Trow
		 ls_itnbr = dw_5.GetitemString(li_row, "itemas_itnbr")
		 ls_titnm = dw_5.GetitemString(li_row, "itemas_itdsc")
		 ls_itdsc = dw_5.GetitemString(li_row, "itemas_ispec")
		
		 dw_2.Setitem(dw_2.rowcount(), "seqno", li_seq)
		 dw_2.Setitem(dw_2.rowcount(), "wp_itnbr", ls_itnbr)
		 dw_2.Setitem(dw_2.rowcount(), "vw_itdsc", ls_titnm)
		 dw_2.Setitem(dw_2.rowcount(), "vw_ispec", ls_itdsc)
		 dw_2.Setitem(dw_2.rowcount(), "saupj", is_saupj)
		 dw_2.Setitem(dw_2.rowcount(), "workym", is_yymm)	  
		  li_seq += 1
		 if li_row <> li_Trow then
			 dw_2.insertrow(0)
		 end if		
		
	Next
else
	ls_itnbr = dw_5.GetitemString(1, "itemas_itnbr")
   ls_titnm = dw_5.GetitemString(1, "itemas_itdsc")
	ls_itdsc = dw_5.GetitemString(1, "itemas_ispec")
	dw_2.Setitem(dw_2.getrow(), "wp_itnbr", ls_itnbr)
	dw_2.Setitem(dw_2.getrow(), "vw_itdsc", ls_titnm)
	dw_2.Setitem(dw_2.getrow(), "vw_ispec", ls_itdsc)
	
	if dw_5.rowcount() > 1 then
		li_row = 2
		For li_row = 2 to li_Trow
			 ls_itnbr = dw_5.GetitemString(li_row, "itemas_itnbr")
			 ls_titnm = dw_5.GetitemString(li_row, "itemas_itdsc")
			 ls_itdsc = dw_5.GetitemString(li_row, "itemas_ispec")
			 
			 if IsNull(dw_2.GetitemString(dw_2.rowcount(), "wp_itnbr")) or dw_2.GetitemString(dw_2.rowcount(), "wp_itnbr") = "" then
			
					 dw_2.Setitem(dw_2.rowcount(), "seqno", li_seq)
					 dw_2.Setitem(dw_2.rowcount(), "wp_itnbr", ls_itnbr)
					 dw_2.Setitem(dw_2.rowcount(), "vw_itdsc", ls_titnm)
					 dw_2.Setitem(dw_2.rowcount(), "vw_ispec", ls_itdsc)
					 dw_2.Setitem(dw_2.rowcount(), "saupj", is_saupj)
					 dw_2.Setitem(dw_2.rowcount(), "workym", is_yymm)	  
					  li_seq += 1
					 if li_row <> li_Trow then
						 dw_2.insertrow(0)
					 end if		
			 else
					
					 li_seq = dw_2.GetitemNumber(dw_2.rowcount(), "seqno")
			       dw_2.insertrow(0)
					 li_seq += 1
			       dw_2.Setitem(dw_2.rowcount(), "seqno", li_seq)
					 dw_2.Setitem(dw_2.rowcount(), "wp_itnbr", ls_itnbr)
					 dw_2.Setitem(dw_2.rowcount(), "vw_itdsc", ls_titnm)
					 dw_2.Setitem(dw_2.rowcount(), "vw_ispec", ls_itdsc)
					 dw_2.Setitem(dw_2.rowcount(), "saupj", is_saupj)
					 dw_2.Setitem(dw_2.rowcount(), "workym", is_yymm)	  
			end if		 
		Next
	end if	

end if

this.event rowfocuschanged(dw_2.rowcount())
end event

event rowfocuschanged;//If CurrentRow <= 0 then
//	this.SelectRow(0,False)
//ELSE
//	SelectRow(0, FALSE)
//	SelectRow(CurrentRow,TRUE)	
//	p_search.TriggerEvent(Clicked!)
//END IF
end event

event itemerror;return 1
end event

event clicked;//p_search.TriggerEvent(Clicked!)

If row <= 0 then
	this.SelectRow(0,False)
ELSE
	SelectRow(0, FALSE)
	SelectRow(row,TRUE)	
	dw_7.retrieve()
	p_search.TriggerEvent(Clicked!)
END IF
end event

event itemchanged;double ll_qty, ll_danga, ll_amt, ll_jqty, ll_totqty
int lrow, i
String ls_itnbr, ls_itdsc, ls_ispec

lrow = this.getrow()

this.Accepttext()

if this.GetColumnName() = "wp_qty" then
	ll_qty = this.GetItemNumber(lrow, "wp_qty")
	if IsNull(ll_qty) or ll_qty = 0 then
		messagebox("확인","재공수량을 입력하세요")
		this.SetColumn("wp_qty")
		this.Setfocus()
		return
	end if
end if

if this.GetColumnName() = "wp_itnbr" then
	ls_itnbr = this.Gettext()
	if IsNull(ls_itnbr) or ls_itnbr = "" then
		messagebox("확인","재공품번을 입력하세요")
		this.SetColumn("wp_itnbr")
		this.Setfocus()
		return
	end if
	
	select itdsc, ispec into :ls_itdsc, :ls_ispec
	from cic_itemas_vw
	where itnbr = :ls_itnbr;
	
	
	 dw_2.Setitem(lrow, "vw_itdsc", ls_itdsc)
	 dw_2.Setitem(lrow, "vw_ispec", ls_ispec) 
	
end if



if dw_3.rowcount() > 0 then
	For i = 1 to  dw_6.rowcount()
		 ll_jqty = dw_6.GetItemNumber(i, "un_qty") 
	    ll_danga = dw_6.GetItemNumber(i, "danga") 
		 
		 ll_totqty = ll_jqty * ll_qty
		 ll_amt = ll_totqty * ll_danga
   	 dw_3.Setitem(i, "es_prc", ll_danga)
		 dw_3.Setitem(i, "es_qty", ll_totqty)
		 dw_3.Setitem(i, "es_amt", ll_amt)
	 Next
	 
end if




end event

type dw_3 from datawindow within w_cic00060
integer x = 2491
integer y = 236
integer width = 2112
integer height = 1184
integer taborder = 60
boolean bringtotop = true
string title = "none"
string dataobject = "dw_cic00060_3"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event itemchanged;double ll_qty, ll_prc, ll_amt
int lrow, i

lrow = this.getrow()

this.Accepttext()
ll_qty = GetitemNumber(lrow, "es_qty")

if this.GetColumnName() = "es_prc" then
	ll_prc = this.GetItemNumber(lrow, "es_prc")
	if IsNull(ll_prc) or ll_prc = 0 then
//		messagebox("확인","단가를 입력하세요")
//		this.SetColumn("es_prc")
//		this.Setfocus()
		return
	else
		this.Setitem(lrow, "es_amt", round(ll_prc * ll_qty,0) )
	end if
end if


end event

type dw_4 from datawindow within w_cic00060
integer x = 2510
integer y = 1456
integer width = 2071
integer height = 788
integer taborder = 70
boolean bringtotop = true
string title = "none"
string dataobject = "dw_cic00060_4"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type dw_5 from datawindow within w_cic00060
boolean visible = false
integer x = 82
integer y = 868
integer width = 2208
integer height = 480
integer taborder = 80
boolean bringtotop = true
boolean enabled = false
string dataobject = "d_itemas_popup10_detail_cic"
boolean border = false
boolean livescroll = true
end type

type dw_6 from datawindow within w_cic00060
boolean visible = false
integer x = 55
integer y = 1280
integer width = 2240
integer height = 400
integer taborder = 80
boolean bringtotop = true
boolean enabled = false
string dataobject = "dw_cic00060_6"
boolean border = false
boolean livescroll = true
end type

type dw_7 from datawindow within w_cic00060
boolean visible = false
integer x = 59
integer y = 1796
integer width = 2181
integer height = 400
integer taborder = 70
boolean bringtotop = true
boolean enabled = false
string dataobject = "dw_cic00060_7"
boolean border = false
boolean livescroll = true
end type

type st_2 from statictext within w_cic00060
integer x = 1701
integer y = 148
integer width = 1659
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 32106727
string text = "※ 행삭제를 순차로 처리후 저장버튼을 눌러야 최종 삭제됩니다!"
boolean focusrectangle = false
end type

type p_1 from uo_picture within w_cic00060
integer x = 3387
integer y = 24
integer width = 178
boolean bringtotop = true
string picturename = "C:\erpman\image\생성_up.gif"
end type

event clicked;call super::clicked;String sWorkym, sImgbn

If dw_1.Accepttext() = -1 Then Return

sWorkym = Trim(dw_1.GetItemString(dw_1.GetRow(), 'workym'))
If sWorkym = "" Or IsNull(sWorkym) Then
	f_messagechk(1, '[기준년월]')
	dw_1.SetColumn('workym')
	dw_1.SetFocus()
	Return
End If

sImgbn = Trim(dw_1.GetItemString(dw_1.GetRow(), 'saupj'))
If sImgbn = "" Or IsNull(sImgbn) Then sImgbn = '%'



IF MessageBox("확 인"," 자료를 생성 하시겠습니까?",Question!,YesNo!) = 2 THEN RETURN	
SetPointer(HourGlass!)
DECLARE cic0120_iwol_sp PROCEDURE FOR cic0120_iwol_sp(:sWorkym,:sImgbn);
EXECUTE cic0120_iwol_sp;
IF TRIM(SQLCA.SQLERRTEXT) <> '' THEN
	MessageBox('DB Procedure Error',SQLCA.SQLERRTEXT)
	RETURN
END IF
p_inq.TriggerEvent(Clicked!)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\생성_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\생성_up.gif"
end event

type r_1 from rectangle within w_cic00060
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 9
integer y = 228
integer width = 2469
integer height = 2028
end type

type r_2 from rectangle within w_cic00060
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 2487
integer y = 232
integer width = 2139
integer height = 1204
end type

type r_3 from rectangle within w_cic00060
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 2501
integer y = 1448
integer width = 2126
integer height = 808
end type

