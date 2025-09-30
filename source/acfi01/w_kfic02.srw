$PBExportHeader$w_kfic02.srw
$PBExportComments$부도어음 등록
forward
global type w_kfic02 from w_inherite
end type
type dw_2 from datawindow within w_kfic02
end type
type dw_3 from datawindow within w_kfic02
end type
type st_2 from statictext within w_kfic02
end type
type st_3 from statictext within w_kfic02
end type
type dw_4 from datawindow within w_kfic02
end type
type dw_1 from datawindow within w_kfic02
end type
type dw_5 from u_d_popup_sort within w_kfic02
end type
type st_4 from statictext within w_kfic02
end type
type sle_1 from singlelineedit within w_kfic02
end type
type rr_1 from roundrectangle within w_kfic02
end type
type rr_2 from roundrectangle within w_kfic02
end type
type rr_3 from roundrectangle within w_kfic02
end type
type rr_4 from roundrectangle within w_kfic02
end type
type ln_1 from line within w_kfic02
end type
end forward

global type w_kfic02 from w_inherite
string title = "부도어음 등록"
event ue_setitem ( )
event ue_setitem2 ( )
dw_2 dw_2
dw_3 dw_3
st_2 st_2
st_3 st_3
dw_4 dw_4
dw_1 dw_1
dw_5 dw_5
st_4 st_4
sle_1 sle_1
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
rr_4 rr_4
ln_1 ln_1
end type
global w_kfic02 w_kfic02

forward prototypes
public function integer wf_calculate ()
public function integer wf_kfm02t_update ()
end prototypes

event ue_setitem;dw_1.SetItem(dw_1.getrow(), 'won_amt', dw_3.GetItemdecimal(dw_3.getrow(), 'samt'))
end event

event ue_setitem2;dw_1.SetItem(dw_1.getrow(), 'eija', dw_3.GetItemdecimal(dw_3.getrow(), 'seja'))
end event

public function integer wf_calculate ();string ls_bill_no, ls_rmandate, ls_rgubun, ls_rymd, ls_aymd, ls_bman_dat, ls_cymd
decimal ld_r_amt, ld_bill_amt, ld_eja, ld_samt, ld_seja
long ll_hymd, ll_bymd, ll_mymd, ll_ilsu

if dw_1.accepttext() = -1 then return -1
if dw_3.accepttext() = -1 then return -1

ls_bill_no = dw_1.getitemstring(dw_1.getrow(), "bill_no")
ls_aymd = dw_1.getitemstring(dw_1.getrow(), "aymd")
ls_cymd = dw_1.getitemstring(dw_1.getrow(), "cymd")
ld_bill_amt = dw_1.getitemdecimal(dw_1.getrow(), "bill_amt")
ls_bman_dat = dw_1.getitemstring(dw_1.getrow(), "kfm02ot0_bman_dat")
ls_rmandate = dw_3.getitemstring(dw_3.getrow(), "r_mandate")
ls_rgubun = dw_3.getitemstring(dw_3.getrow(), "r_gubun")
ls_rymd = dw_3.getitemstring(dw_3.getrow(), "rymd")
ld_r_amt = dw_3.getitemdecimal(dw_3.getrow(), "r_amt")
ld_eja = dw_3.getitemdecimal(dw_3.getrow(), "r_eija")
ll_ilsu = dw_3.getitemnumber(dw_3.getrow(), "ilsu")

ll_hymd = f_dayterm(ls_cymd,ls_rymd)
ll_bymd = f_dayterm(ls_bman_dat,ls_rmandate)
ll_mymd = f_dayterm(ls_bman_dat,ls_rymd)

if isnull(ld_bill_amt) or ld_bill_amt = 0 then
	ld_bill_amt = 0
End if

if ls_aymd > ls_bman_dat then
	if ls_rgubun = '1' then		
		if ll_hymd <= 7 then
			ld_eja = 0
			ll_ilsu = ll_hymd
		else 
			ld_eja = ll_hymd * 0.03 / 365 * ld_bill_amt
			ll_ilsu = ll_hymd
		end if
	else		
		ld_eja = ll_bymd * 0.03 / 365 * ld_bill_amt
		ll_ilsu = ll_bymd
	end if
else
	ld_eja = ll_bymd * 0.03 / 365 * ld_bill_amt
	ll_ilsu = ll_bymd
//	if ls_cymd < ls_rymd and ls_rymd < ls_bman_dat then
	   if ls_rgubun = '1' then	   
			ld_eja = ll_mymd * 0.03 / 365 * ld_bill_amt
			ll_ilsu = ll_mymd
		end if
//	end if	
end if

ld_samt = dw_3.getitemdecimal(dw_3.getrow(), "samt")
ld_seja = dw_3.getitemdecimal(dw_3.getrow(), "seja")

dw_1.setitem(dw_1.getrow(), "won_amt", ld_samt)
dw_1.setitem(dw_1.getrow(), "eija", ld_seja)
dw_3.setitem(dw_3.getrow(), "r_amt", ld_r_amt)
//dw_3.setitem(dw_3.getrow(), "r_eija", ld_eja)
dw_3.setitem(dw_3.getrow(), "ilsu", ll_ilsu)
		   
return 1
end function

public function integer wf_kfm02t_update ();long	ll_rowcount

ll_rowcount = dw_4.RowCount()
if ll_rowcount < 1 then
	ll_rowcount = dw_4.InsertRow(0)
	dw_4.SetItem(ll_rowcount,'bill_no',dw_1.GetItemString(dw_1.getrow(),'bill_no'))
end if

dw_4.SetItem(ll_rowcount,'bill_amt',dw_1.GetItemDecimal(dw_1.getrow(),'bill_amt'))
dw_4.SetItem(ll_rowcount,'won_amt',dw_1.GetItemDecimal(dw_1.getrow(),'won_amt'))
dw_4.SetItem(ll_rowcount,'eija',dw_1.GetItemDecimal(dw_1.getrow(),'eija'))
dw_4.SetItem(ll_rowcount,'aymd',dw_1.GetItemString(dw_1.getrow(),'aymd'))
dw_4.SetItem(ll_rowcount,'symd',dw_1.GetItemString(dw_1.getrow(),'symd'))
dw_4.SetItem(ll_rowcount,'cymd',dw_1.GetItemString(dw_1.getrow(),'cymd'))
dw_4.SetItem(ll_rowcount,'rymd',dw_1.GetItemString(dw_1.getrow(),'rymd'))

if dw_4.AcceptText() = -1 then return -1
if dw_4.Update() <> 1 then return -1

return 1

end function

on w_kfic02.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.dw_3=create dw_3
this.st_2=create st_2
this.st_3=create st_3
this.dw_4=create dw_4
this.dw_1=create dw_1
this.dw_5=create dw_5
this.st_4=create st_4
this.sle_1=create sle_1
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
this.rr_4=create rr_4
this.ln_1=create ln_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.dw_3
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.dw_4
this.Control[iCurrent+6]=this.dw_1
this.Control[iCurrent+7]=this.dw_5
this.Control[iCurrent+8]=this.st_4
this.Control[iCurrent+9]=this.sle_1
this.Control[iCurrent+10]=this.rr_1
this.Control[iCurrent+11]=this.rr_2
this.Control[iCurrent+12]=this.rr_3
this.Control[iCurrent+13]=this.rr_4
this.Control[iCurrent+14]=this.ln_1
end on

on w_kfic02.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_2)
destroy(this.dw_3)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.dw_4)
destroy(this.dw_1)
destroy(this.dw_5)
destroy(this.st_4)
destroy(this.sle_1)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
destroy(this.rr_4)
destroy(this.ln_1)
end on

event open;call super::open;dw_1.settransobject(sqlca)

dw_2.settransobject(sqlca)
dw_2.insertrow(0)

dw_3.settransobject(sqlca)
//dw_3.insertrow(0)

dw_4.settransobject(sqlca)

dw_5.settransobject(sqlca)

dw_5.sharedata(dw_1)

if dw_5.retrieve() < 1 then
	dw_1.insertrow(0)
end if

dw_1.setfocus()


end event

event key;call super::key;GraphicObject which_control
string ls_string,scode, sname
long iRow

which_control = getfocus()

if  TypeOf(which_control)=SingleLineEdit! then
   if sle_1 = which_control then
    
	  Choose Case key
		Case KeyEnter!	
	       ls_string =trim(sle_1.text)
	      if isNull(ls_string) or ls_string="" then return
	       
		   If Len(ls_string) > 0 Then
				Choose Case Asc(ls_string)
				//숫자 - 코드
				Case is < 127
          
				 scode = ls_string+"%"
							
//				//문자 - 명칭
				Case is >= 127
					scode = "%"+ls_string+"%"
				End Choose
			End If	
			
  			
        
        iRow = dw_3.Find("kfm02ot0_bill_no like '" + scode +"'",1,dw_3.RowCount())
		  
		  if iRow>0 then
		     
	     else
	        iRow = dw_3.Find("kfm02ot0_saup_no like '" + scode +"'",1,dw_3.RowCount())
			 if iRow>0 then
		
		    else	

		     iRow = dw_3.Find("kfz04om0_person_nm like '" + scode +"'",1,dw_3.RowCount())
		    if iRow>0 then
			 end if 
			  
		    end if
	     end if			 
		  
		  
		  
		  if iRow > 0 then
         	dw_5.ScrollToRow(iRow)
	         dw_5.SelectRow(iRow,True)
		  else 
		      MessageBox('어음번호선택',"선택하신 자료가 없습니다. 다시 선택하신후 작업하세요")  
	     end if	
		   
		 //dw_5.setFocus()
		 sle_1.text=""
	  End Choose
   end if

else
	
	Choose Case key
	Case KeyW!
		p_print.TriggerEvent(Clicked!)
	Case KeyQ!
		p_inq.TriggerEvent(Clicked!)
	Case KeyT!
		p_ins.TriggerEvent(Clicked!)
	Case KeyA!
		p_addrow.TriggerEvent(Clicked!)
	Case KeyE!
		p_delrow.TriggerEvent(Clicked!)
	Case KeyS!
		p_mod.TriggerEvent(Clicked!)
	Case KeyD!
		p_del.TriggerEvent(Clicked!)
	Case KeyC!
		p_can.TriggerEvent(Clicked!)
	Case KeyX!
		p_exit.TriggerEvent(Clicked!)
   End Choose



end if











end event

type dw_insert from w_inherite`dw_insert within w_kfic02
boolean visible = false
integer x = 2633
integer y = 2512
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kfic02
boolean visible = false
integer x = 3438
integer y = 2232
integer taborder = 70
end type

type p_addrow from w_inherite`p_addrow within w_kfic02
boolean visible = false
integer x = 3264
integer y = 2228
integer taborder = 50
end type

type p_search from w_inherite`p_search within w_kfic02
boolean visible = false
integer x = 2487
integer y = 3196
integer taborder = 120
end type

type p_ins from w_inherite`p_ins within w_kfic02
integer x = 3730
integer y = 8
integer taborder = 30
end type

event p_ins::clicked;call super::clicked;long cur_row
string ls_rymd

//ls_rymd = dw_3.getitemstring(dw_3.getrow(), "rymd")
//	
//if ls_rymd = "" or isnull(ls_rymd) then
//	f_messagechk(1, "[회수일]")
//	dw_3.setcolumn("rymd")
//	dw_3.setfocus()
//	return
//end if

cur_row = dw_3.insertrow(0)

dw_3.setrow(cur_row)
dw_3.scrolltorow(cur_row)
dw_3.setcolumn("r_bill_no")
dw_3.setfocus()
end event

type p_exit from w_inherite`p_exit within w_kfic02
integer x = 4425
integer y = 8
integer taborder = 110
end type

type p_can from w_inherite`p_can within w_kfic02
integer x = 4251
integer y = 8
integer taborder = 100
end type

event p_can::clicked;call super::clicked;string ls_bill_no

if dw_1.accepttext() = -1 then return

ls_bill_no = dw_1.getitemstring(dw_1.getrow(), "bill_no")

//dw_1.reset()
//dw_1.insertrow(0)
//
//dw_2.reset()
//dw_3.reset()
//
//dw_1.SetFocus()

dw_5.retrieve()

dw_2.retrieve(ls_bill_no)
dw_3.retrieve(ls_bill_no)

end event

type p_print from w_inherite`p_print within w_kfic02
boolean visible = false
integer x = 2661
integer y = 3196
integer taborder = 130
end type

type p_inq from w_inherite`p_inq within w_kfic02
integer x = 3557
integer y = 8
end type

event p_inq::clicked;call super::clicked;string ls_bill_no, ls_rmandate, ls_rgubun, ls_rymd, ls_aymd, ls_bman_dat, ls_cymd
long ll_hymd, ll_bymd, ll_mymd, ll_ilsu, ll_row
integer i

if dw_1.accepttext() = -1 then return -1
if dw_3.accepttext() = -1 then return -1

ls_bill_no = dw_1.getitemstring(dw_1.getrow(), "bill_no")

if ls_bill_no = "" or isnull(ls_bill_no) then
	f_messagechk(1, "[어음번호]")
	dw_1.setfocus()
	return
end if

if dw_1.retrieve(ls_bill_no) <= 0 then
//	f_messagechk(14, " ") 
   dw_1.insertrow(0)
	
	dw_1.setfocus()
	return
end if
dw_1.setitem(dw_1.getrow(), "bill_no", ls_bill_no)

dw_2.retrieve(ls_bill_no)

i = dw_3.getrow()
ll_row = dw_3.retrieve(ls_bill_no)

if ll_row < 1 then 
//	dw_3.insertrow(0)
else

	for i = 1 to ll_row
		
		ls_aymd = dw_1.getitemstring(dw_1.getrow(), "aymd")
		ls_cymd = dw_1.getitemstring(dw_1.getrow(), "cymd")
		ls_bman_dat = dw_1.getitemstring(dw_1.getrow(), "kfm02ot0_bman_dat")
		ls_rmandate = dw_3.getitemstring(i, "r_mandate")
		ls_rgubun = dw_3.getitemstring(i, "r_gubun")
		ls_rymd = dw_3.getitemstring(i, "rymd")
		ll_ilsu = dw_3.getitemnumber(i, "ilsu")
		
		ll_hymd = f_dayterm(ls_cymd,ls_rymd)
		ll_bymd = f_dayterm(ls_bman_dat,ls_rmandate)
		ll_mymd = f_dayterm(ls_bman_dat,ls_rymd)
		
		if ls_aymd > ls_bman_dat then
			if ls_rgubun = '1' then	
				ll_ilsu = ll_hymd		
			else					
				ll_ilsu = ll_bymd
			end if
		else
			ll_ilsu = ll_bymd
//			if ls_cymd < ls_rymd and ls_rymd < ls_bman_dat then
				if ls_rgubun = '1' then	   
					ll_ilsu = ll_mymd
				end if
//			end if	
		end if
		dw_3.setitem(i, "ilsu", ll_ilsu)
	next
end if


		   

end event

type p_del from w_inherite`p_del within w_kfic02
integer x = 4078
integer y = 8
integer taborder = 90
end type

event p_del::clicked;call super::clicked;Long curr_row
string ls_rbill_no, ls_bill_no
decimal ld_ramt, ld_wamt, ld_amt, ld_weja, ld_reja, ld_eja

if dw_1.accepttext() = -1 then return
if dw_3.accepttext() = -1 then return

ls_bill_no = dw_1.getitemstring(dw_1.getrow(), "bill_no")

curr_row = dw_3.getrow()

if curr_row > 0  then

	ls_rbill_no = dw_3.GetItemString(dw_3.getrow(),"r_bill_no")
	ld_ramt = dw_3.getitemdecimal(dw_3.getrow(), "r_amt")
	ld_wamt = dw_1.getitemdecimal(dw_1.getrow(), "won_amt")
	ld_reja = dw_3.getitemdecimal(dw_3.getrow(), "r_eija")
	ld_weja = dw_1.getitemdecimal(dw_1.getrow(), "eija")
	
	IF f_dbConFirm('삭제') = 2 THEN RETURN
	
   dw_3.deleterow(curr_row)
	
//	dw_3.triggerevent(itemchanged!)
	ld_amt = ld_wamt - ld_ramt
	ld_eja = ld_weja - ld_reja
	dw_1.setitem(dw_1.getrow(), "won_amt", ld_amt)
	dw_1.setitem(dw_1.getrow(), "eija", ld_eja)
	
	IF dw_3.Update() = 1 THEN
		commit;
		dw_3.setcolumn("r_bill_no")
		dw_3.setfocus()
		sle_msg.text ="자료가 삭제되었습니다.!!"
	ELSE
		f_messagechk(12,"")
		ROLLBACK;
	END IF
else
	delete from kfm02t where bill_no = :ls_bill_no;
	if sqlca.sqlcode <> 0 then
		rollback;
		return
	else
		commit;
		sle_msg.text = "자료가 삭제되었습니다.!!"
		if dw_1.retrieve(ls_bill_no) <= 0 then
			dw_1.insertrow(0)
		end if
	end if

end if
end event

type p_mod from w_inherite`p_mod within w_kfic02
integer x = 3904
integer y = 8
integer taborder = 80
end type

event p_mod::clicked;call super::clicked;string ls_bill_no, ls_rbill_no, ls_rmandate, ls_rgubun, ls_rymd, ls_aymd, ls_cymd
decimal ld_r_amt, ld_eja
long ll_row

if dw_1.accepttext() = -1 then return
if dw_3.accepttext() = -1 then return

IF dw_1.RowCount() <=0 THEN Return
if dw_3.RowCount() <=0 then
	if wf_kfm02t_update() = -1 then	
		f_messagechk(13,"")
		rollback ;
		return
	end if
 
	commit ;
	sle_msg.text = "자료가 저장되었습니다.!!"
	return 1
end if

ls_bill_no = dw_1.getitemstring(dw_1.getrow(), "bill_no")
ls_rbill_no = dw_3.getitemstring(dw_3.getrow(), "r_bill_no")
ls_rmandate = dw_3.getitemstring(dw_3.getrow(), "r_mandate")
ls_rgubun = dw_3.getitemstring(dw_3.getrow(), "r_gubun")
ls_aymd = dw_1.getitemstring(dw_1.getrow(), "aymd")
ls_cymd = dw_1.getitemstring(dw_1.getrow(), "cymd")
ls_rymd = dw_3.getitemstring(dw_3.getrow(), "rymd")
ld_r_amt = dw_3.getitemdecimal(dw_3.getrow(), "r_amt")
ld_eja = dw_3.getitemdecimal(dw_3.getrow(), "r_eija")
ll_row = dw_3.getrow()

if ls_aymd = "" or isnull(ls_aymd) then
	f_messagechk(1, "[부도발생일]")
	dw_1.setcolumn("aymd")
	dw_1.setfocus()
	return
end if

//if ls_cymd = "" or isnull(ls_cymd) then
//	f_messagechk(1, "[거래처인도일]")
//	dw_1.setcolumn("cymd")
//	dw_1.setfocus()
//	return
//end if

//if ls_rymd = "" or isnull(ls_rymd) then
//	f_messagechk(1, "[회수일]")
//	dw_3.setcolumn("rymd")
//	dw_3.setfocus()
//	return
//end if
//
//if ls_rymd = "" or isnull(ls_rymd) then
//	f_messagechk(1, "[회수일]")
//	dw_3.setcolumn("rymd")
//	dw_3.setfocus()
//	return
//end if
//
//if ld_r_amt = 0 or isnull(ld_r_amt) then
//	f_messagechk(1, "[회수금액]")
//	dw_3.setcolumn("r_amt")
//	dw_3.setfocus()
//	return
//end if
//
//if ls_rgubun = "" or isnull(ls_rgubun) then
//	f_messagechk(1, "[이자계산유형]")
//	dw_3.setcolumn("r_gubun")
//	dw_3.setfocus()
//	return
//end if

//if ls_rgubun = '2' then
//	if ls_rbill_no = "" or isnull(ls_rbill_no) then
//		messagebox("확인", "어음번호를 입력하십시오.!!")
//		dw_3.setcolumn("r_bill_no")
//		dw_3.setfocus()
//		return
//	end if
//	if ls_rmandate = "" or isnull(ls_rmandate) then
//		messagebox("확인", "만기일을 입력하십시오.!!")
//		dw_3.setcolumn("r_mandate")
//		dw_3.setfocus()
//		return
//	end if
//end if

if wf_calculate() = -1 then return

if f_dbconfirm("저장") = 2 then return


FOR ll_row = 1 TO dw_3.RowCount()
	dw_3.SetItem(ll_row,'bill_no',ls_bill_no)
	dw_3.SetItem(ll_row,'seq',ll_row)
NEXT

dw_3.AcceptText()

if dw_3.update() = 1  then	
	if wf_kfm02t_update() = -1 then	
		f_messagechk(13,"")
		rollback ;
		return
	end if
 
	commit ;
	
	sle_msg.text ="자료가 저장되었습니다.!!!"		
else
	f_messagechk(13,"") 
	rollback;
	return
end if


end event

type cb_exit from w_inherite`cb_exit within w_kfic02
boolean visible = false
integer x = 3291
integer y = 3408
end type

type cb_mod from w_inherite`cb_mod within w_kfic02
boolean visible = false
integer x = 2203
integer y = 3412
end type

type cb_ins from w_inherite`cb_ins within w_kfic02
boolean visible = false
integer x = 1765
integer y = 3416
end type

type cb_del from w_inherite`cb_del within w_kfic02
boolean visible = false
integer x = 2560
integer y = 3412
end type

type cb_inq from w_inherite`cb_inq within w_kfic02
boolean visible = false
integer x = 1417
integer y = 3416
end type

type cb_print from w_inherite`cb_print within w_kfic02
boolean visible = false
integer x = 2130
integer y = 2488
end type

type st_1 from w_inherite`st_1 within w_kfic02
boolean visible = false
end type

type cb_can from w_inherite`cb_can within w_kfic02
boolean visible = false
integer x = 2917
integer y = 3412
end type

type cb_search from w_inherite`cb_search within w_kfic02
boolean visible = false
integer x = 1623
integer y = 2496
end type

type dw_datetime from w_inherite`dw_datetime within w_kfic02
boolean visible = false
end type

type sle_msg from w_inherite`sle_msg within w_kfic02
boolean visible = false
end type

type gb_10 from w_inherite`gb_10 within w_kfic02
boolean visible = false
end type

type gb_button1 from w_inherite`gb_button1 within w_kfic02
boolean visible = false
integer x = 1376
integer y = 3364
end type

type gb_button2 from w_inherite`gb_button2 within w_kfic02
boolean visible = false
integer x = 2167
integer y = 3360
end type

type dw_2 from datawindow within w_kfic02
integer x = 1298
integer y = 820
integer width = 3278
integer height = 688
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_kfic02_2a"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type dw_3 from datawindow within w_kfic02
event ue_key pbm_dwnkey
event ue_enter pbm_dwnprocessenter
integer x = 1298
integer y = 1612
integer width = 3278
integer height = 592
integer taborder = 60
boolean bringtotop = true
string dataobject = "d_kfic02_3"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_enter;send(handle(this), 256, 9, 0)
return 1
end event

event itemchanged;string ls_bill_no, ls_rbill_no, ls_rmandate, ls_rgubun, ls_rymd, ls_aymd, ls_bman_dat, ls_cymd, ls_r_amt
decimal ld_r_amt, ld_bill_amt, ld_eja, ld_samt, ld_seja, ld_amt
long ll_hymd, ll_bymd, ll_mymd, ll_ilsu

if dw_1.accepttext() = -1 then return

ls_aymd = dw_1.getitemstring(dw_1.getrow(), "aymd")
ls_cymd = dw_1.getitemstring(dw_1.getrow(), "cymd")
ld_bill_amt = dw_1.getitemdecimal(dw_1.getrow(), "bill_amt")
ls_bman_dat = dw_1.getitemstring(dw_1.getrow(), "kfm02ot0_bman_dat")
ls_rmandate = dw_3.getitemstring(dw_3.getrow(), "r_mandate")
ls_rgubun = dw_3.getitemstring(dw_3.getrow(), "r_gubun")
ls_rymd = dw_3.getitemstring(dw_3.getrow(), "rymd")
ld_r_amt = dw_3.getitemdecimal(dw_3.getrow(), "r_amt")
ld_eja = dw_3.getitemdecimal(dw_3.getrow(), "r_eija")
ll_ilsu = dw_3.getitemnumber(dw_3.getrow(), "ilsu")

if dw_3.getcolumnname() = "r_bill_no" then
	ls_rbill_no = dw_3.gettext()
	if not isnull(ls_rbill_no) then
		dw_3.setitem(dw_3.getrow(), "r_gubun", '2')
	end if
end if
		
if dw_3.getcolumnname() = "r_mandate" then
	ls_rmandate = dw_3.gettext()
	
	if f_datechk(ls_rmandate) <> 1 then
		f_messagechk(21, "[만기일]")
		dw_3.setcolumn("r_mandate")
		dw_3.setfocus()
		return
	end if
	
	ll_hymd = f_dayterm(ls_cymd,ls_rymd)
   ll_bymd = f_dayterm(ls_bman_dat,ls_rmandate)
   ll_mymd = f_dayterm(ls_bman_dat,ls_rymd)

	
	if ls_aymd > ls_bman_dat then
		if ls_rgubun = '1' then		
			if ll_hymd <= 7 then
				ld_eja = 0
				ll_ilsu = ll_hymd
			else 
				ld_eja = ll_hymd * 0.03 / 365 * ld_bill_amt
				ll_ilsu = ll_hymd
			end if
		else		
			ld_eja = ll_bymd * 0.03 / 365 * ld_bill_amt
			ll_ilsu = ll_bymd
		end if
	else
		ld_eja = ll_bymd * 0.03 / 365 * ld_bill_amt
		ll_ilsu = ll_bymd
//		if ls_cymd < ls_rymd and ls_rymd < ls_bman_dat then
			if ls_rgubun = '1' then	   
				ld_eja = ll_mymd * 0.03 / 365 * ld_bill_amt
				ll_ilsu = ll_mymd
			end if
//		end if	
	end if
	
   dw_3.setitem(dw_3.getrow(), "r_eija", ld_eja)
   Parent.PostEvent("ue_setitem2")
	
   dw_3.setitem(dw_3.getrow(), "ilsu", ll_ilsu)
end if
	
if dw_3.getcolumnname() = "rymd" then
	ls_rymd = dw_3.gettext()
	
	if f_datechk(ls_rymd) <> 1 then
		f_messagechk(21, "[회수일]")
		dw_3.setcolumn("rymd")
		dw_3.setfocus()
		return
	end if
	
	ll_hymd = f_dayterm(ls_cymd,ls_rymd)
   ll_bymd = f_dayterm(ls_bman_dat,ls_rmandate)
   ll_mymd = f_dayterm(ls_bman_dat,ls_rymd)

	
	if ls_aymd > ls_bman_dat then
		if ls_rgubun = '1' then		
			if ll_hymd <= 7 then
				ld_eja = 0
				ll_ilsu = ll_hymd
			else 
				ld_eja = ll_hymd * 0.03 / 365 * ld_bill_amt
				ll_ilsu = ll_hymd
			end if
		else		
			ld_eja = ll_bymd * 0.03 / 365 * ld_bill_amt
			ll_ilsu = ll_bymd
		end if
	else
		ld_eja = ll_bymd * 0.03 / 365 * ld_bill_amt
		ll_ilsu = ll_bymd
//		if ls_cymd < ls_rymd and ls_rymd < ls_bman_dat then
			if ls_rgubun = '1' then	   
				ld_eja = ll_mymd * 0.03 / 365 * ld_bill_amt
				ll_ilsu = ll_mymd
			end if
//		end if	
	end if
	
	dw_3.setitem(dw_3.getrow(), "r_eija", ld_eja)
   Parent.PostEvent("ue_setitem2")
	
	dw_3.setitem(dw_3.getrow(), "ilsu", ll_ilsu)
end if
	
if dw_3.getcolumnname() = "r_amt" then
	Parent.PostEvent("ue_setitem")
END IF 
	
if dw_3.getcolumnname() = "r_gubun" then
	ls_rgubun = dw_3.gettext()
	
	ll_hymd = f_dayterm(ls_cymd,ls_rymd)
   ll_bymd = f_dayterm(ls_bman_dat,ls_rmandate)
   ll_mymd = f_dayterm(ls_bman_dat,ls_rymd)
 
	if ls_aymd > ls_bman_dat then
		if ls_rgubun = '1' then		
			if ll_hymd <= 7 then
				ld_eja = 0
				ll_ilsu = ll_hymd
			else 
				ld_eja = ll_hymd * 0.03 / 365 * ld_bill_amt
				ll_ilsu = ll_hymd
			end if
		else		
			ld_eja = ll_bymd * 0.03 / 365 * ld_bill_amt
			ll_ilsu = ll_bymd
		end if
	else
		ld_eja = ll_bymd * 0.03 / 365 * ld_bill_amt
		ll_ilsu = ll_bymd
//		if ls_cymd < ls_rymd and ls_rymd < ls_bman_dat then
			if ls_rgubun = '1' then	   
				ld_eja = ll_mymd * 0.03 / 365 * ld_bill_amt
				ll_ilsu = ll_mymd
			end if
//		end if	
	end if
	
   dw_3.setitem(dw_3.getrow(), "r_eija", ld_eja)
   Parent.PostEvent("ue_setitem2")

	dw_3.setitem(dw_3.getrow(), "ilsu", ll_ilsu)
end if	
	



end event

event itemerror;return 1
end event

type st_2 from statictext within w_kfic02
integer x = 1321
integer y = 1556
integer width = 613
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean underline = true
long textcolor = 8388608
long backcolor = 32106727
boolean enabled = false
string text = "예상 회수정보 입력"
boolean focusrectangle = false
end type

type st_3 from statictext within w_kfic02
integer x = 1321
integer y = 764
integer width = 686
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean underline = true
long textcolor = 8388608
long backcolor = 32106727
boolean enabled = false
string text = "부도어음 수금 정보"
boolean focusrectangle = false
end type

type dw_4 from datawindow within w_kfic02
boolean visible = false
integer x = 1074
integer y = 2508
integer width = 498
integer height = 88
boolean bringtotop = true
string dataobject = "d_kfm02t"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_1 from datawindow within w_kfic02
event ue_key pbm_dwnkey
event ue_enter pbm_dwnprocessenter
integer x = 1271
integer y = 160
integer width = 3342
integer height = 580
integer taborder = 20
string dataobject = "d_kfic02_1"
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) or keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF


end event

event ue_enter;send(handle(this), 256, 9, 0)
return 1

end event

event itemchanged;string ls_bill_no, ls_rmandate, ls_rgubun, ls_rymd, ls_aymd, ls_bman_dat, ls_cymd
long ll_hymd, ll_bymd, ll_mymd, ll_ilsu, ll_row
integer i

if this.getcolumnname() = "bill_no" then
	ls_bill_no = this.gettext()
	
	ll_row = dw_1.retrieve(ls_bill_no)
	dw_4.retrieve(ls_bill_no)
	
	if ll_row <= 0 then
		dw_1.insertRow(0)		
		return
	end if
	dw_1.setitem(this.getrow(), "bill_no", ls_bill_no)
	
	dw_2.retrieve(ls_bill_no)
		
	i = dw_3.getrow()
   ll_row = dw_3.retrieve(ls_bill_no)
	
//	if ll_row < 1 then
//		dw_3.insertrow(0)
//	end if

	for i = 1 to ll_row
		
		ls_aymd = dw_1.getitemstring(dw_1.getrow(), "aymd")
		ls_cymd = dw_1.getitemstring(dw_1.getrow(), "cymd")
		ls_bman_dat = dw_1.getitemstring(dw_1.getrow(), "kfm02ot0_bman_dat")
		ls_rmandate = dw_3.getitemstring(i, "r_mandate")
		ls_rgubun = dw_3.getitemstring(i, "r_gubun")
		ls_rymd = dw_3.getitemstring(i, "rymd")
		ll_ilsu = dw_3.getitemnumber(i, "ilsu")
		
		ll_hymd = f_dayterm(ls_cymd,ls_rymd)
		ll_bymd = f_dayterm(ls_bman_dat,ls_rmandate)
		ll_mymd = f_dayterm(ls_bman_dat,ls_rymd)
		
		if ls_aymd > ls_bman_dat then
			if ls_rgubun = '1' then	
				ll_ilsu = ll_hymd		
			else					
				ll_ilsu = ll_bymd
			end if
		else
			ll_ilsu = ll_bymd
//			if ls_cymd < ls_rymd and ls_rymd < ls_bman_dat then
				if ls_rgubun = '1' then	   
					ll_ilsu = ll_mymd
				end if
//			end if	
		end if
		dw_3.setitem(i, "ilsu", ll_ilsu)
	next

end if

dw_1.setcolumn("aymd")
dw_1.setfocus()
end event

event itemerror;return 1
end event

event rbuttondown;//this.accepttext()
//
//SetNull(gs_code)
//
//IF this.GetColumnName() = "bill_no" THEN
//	gs_code = this.object.bill_no[this.getrow()]
//	
//	IF IsNull(gs_code) THEN gs_code =""
//	
//	OPEN(W_KFM02OT0_POPUP)
//	
//	if isnull(gs_code) then return
//	
//	dw_1.setitem(dw_1.getrow(), "bill_no", gs_code)
//	
//	this.TriggerEvent(ItemChanged!)
//End if
//
//dw_1.setcolumn("aymd")
//dw_1.setfocus()
//	
//
end event

type dw_5 from u_d_popup_sort within w_kfic02
integer x = 23
integer y = 176
integer width = 1225
integer height = 2036
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_kfic02_4"
boolean vscrollbar = true
boolean border = false
end type

event clicked;call super::clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	dw_1.ScrollToRow(row)
	
//	Lb_AutoFlag = False
	
	b_flag = False
	
	dw_2.retrieve(dw_1.object.bill_no[row])
	dw_3.retrieve(dw_1.object.bill_no[row])
	
//	smodstatus="M"
//	wf_setting_retrievemode(smodstatus)
END IF

CALL SUPER ::CLICKED


end event

event rowfocuschanged;call super::rowfocuschanged;If currentrow <= 0 then
	dw_1.SelectRow(0,False)

ELSE

	SelectRow(0, FALSE)
	SelectRow(currentrow,TRUE)
	
	dw_1.ScrollToRow(currentrow)
	
	dw_2.retrieve(dw_1.object.bill_no[currentrow])
	dw_3.retrieve(dw_1.object.bill_no[currentrow])

END IF

end event

type st_4 from statictext within w_kfic02
integer x = 73
integer y = 64
integer width = 366
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "어음조회"
boolean focusrectangle = false
end type

type sle_1 from singlelineedit within w_kfic02
integer x = 347
integer y = 56
integer width = 567
integer height = 64
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
boolean border = false
textcase textcase = upper!
end type

type rr_1 from roundrectangle within w_kfic02
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1285
integer y = 748
integer width = 3310
integer height = 776
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_kfic02
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1285
integer y = 1536
integer width = 3310
integer height = 680
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_kfic02
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 164
integer width = 1248
integer height = 2060
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_4 from roundrectangle within w_kfic02
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 14
integer y = 8
integer width = 987
integer height = 148
integer cornerheight = 40
integer cornerwidth = 46
end type

type ln_1 from line within w_kfic02
integer linethickness = 1
integer beginx = 352
integer beginy = 124
integer endx = 914
integer endy = 124
end type

