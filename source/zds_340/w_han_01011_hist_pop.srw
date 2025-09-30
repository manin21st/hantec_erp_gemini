$PBExportHeader$w_han_01011_hist_pop.srw
$PBExportComments$자재소진내역 조정
forward
global type w_han_01011_hist_pop from w_inherite_popup
end type
type dw_hist from datawindow within w_han_01011_hist_pop
end type
type rr_2 from roundrectangle within w_han_01011_hist_pop
end type
end forward

global type w_han_01011_hist_pop from w_inherite_popup
integer width = 4165
integer height = 1536
string title = "원자재 소진 추가"
boolean controlmenu = true
dw_hist dw_hist
rr_2 rr_2
end type
global w_han_01011_hist_pop w_han_01011_hist_pop

type variables
String is_sidate , is_shpjpno
end variables

on w_han_01011_hist_pop.create
int iCurrent
call super::create
this.dw_hist=create dw_hist
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_hist
this.Control[iCurrent+2]=this.rr_2
end on

on w_han_01011_hist_pop.destroy
call super::destroy
destroy(this.dw_hist)
destroy(this.rr_2)
end on

event open;call super::open;dw_jogun.SetTransObject(SQLCA)
dw_jogun.InsertRow(0)
dw_hist.SetTransObject(SQLCA)

String ls_sdate, ls_edate, ls_itnbr

str_code lstr_code
lstr_code = Message.PowerObjectParm

is_sidate = lstr_code.code[4]
is_shpjpno= lstr_code.code[5]

//dw_jogun.SetItem(1, 'lotsno', lstr_code.code[3])
dw_jogun.SetItem(1, 'itnbr', lstr_code.code[2])

ls_sdate = f_afterday(lstr_code.code[4] , -30)
ls_edate = lstr_code.code[4]

dw_jogun.SetItem(1, 'd_st', ls_sdate)
dw_jogun.SetItem(1, 'd_ed', ls_edate)

gs_code = '0'


end event

type dw_jogun from w_inherite_popup`dw_jogun within w_han_01011_hist_pop
integer x = 27
integer y = 32
integer width = 3191
integer height = 164
string dataobject = "d_han_01011_hist_002_pop_1"
end type

type p_exit from w_inherite_popup`p_exit within w_han_01011_hist_pop
integer x = 3886
integer y = 28
end type

event p_exit::clicked;call super::clicked;Close(Parent)

end event

type p_inq from w_inherite_popup`p_inq within w_han_01011_hist_pop
integer x = 3529
integer y = 28
boolean originalsize = false
end type

event p_inq::clicked;call super::clicked;String ls_st, ls_ed, ls_lotsno, ls_itnbr

ls_st = dw_jogun.object.d_st[1]
ls_ed = dw_jogun.object.d_ed[1]
ls_lotsno= dw_jogun.object.lotsno[1]
ls_itnbr = dw_jogun.object.itnbr[1]

If isNull(ls_lotsno) or ls_lotsno ='.' then ls_lotsno = '%'

dw_1.SetRedraw(False)
dw_1.Retrieve(ls_lotsno, ls_itnbr, ls_st, ls_ed)
dw_1.SetRedraw(True)

end event

type p_choose from w_inherite_popup`p_choose within w_han_01011_hist_pop
integer x = 3707
integer y = 28
string picturename = "C:\erpman\image\추가_up.gif"
end type

event p_choose::clicked;call super::clicked;Long	ll_rcnt , i , ll_cnt , ll_row , ll_count

If dw_jogun.AcceptText() < 1 then Return
If dw_1.AcceptText() < 1 then Return

dw_1.AcceptText()
dw_hist.Reset()

ll_rcnt = dw_1.RowCount()
If ll_rcnt <= 0 then Return
If dw_1.Find("chk='Y'", 1, ll_rcnt) <= 0 Then Return
If f_msg_update() = -1 Then Return  //저장 Yes/No ?

For i=1 To ll_rcnt
	
	If dw_1.object.chk[i] = 'Y' then
		//잔량이 존재하는 것만
		If dw_1.object.janqty[i] > 0 Then
			ll_row = dw_hist.InsertRow(0)
			ll_cnt += 1
			
			dw_hist.object.sabu[ll_row]      = gs_sabu
			dw_hist.object.shpjpno[ll_row]   = is_shpjpno
			dw_hist.object.itnbr[ll_row]     = dw_1.object.itnbr[i]
			dw_hist.object.pspec[ll_row]     = '.'
			dw_hist.object.lotsno[ll_row]    = dw_1.object.lotsno[i]
			//dw_hist.object.tuipqty[ll_row]   = dw_1.object.ioqty[i] 입고량을 투입량으로 하지않고 잔량으로 투입량을 지정 - by shingoon 2016.02.17
			dw_hist.object.tuipqty[ll_row]   = dw_1.object.janqty[i]
			dw_hist.object.loss_gubun[ll_row]= 'A'
			dw_hist.object.lossqty[ll_row]   = 0        
			dw_hist.object.lossqty1[ll_row]  = 0        
			dw_hist.object.lossqty2[ll_row]  = 0
		End If
	End If
	
Next

dw_hist.AcceptText()
If dw_hist.Update() < 1 then
	MessageBox("DB Update Error!",SQLCA.SQLErrText)
	Rollback ;
	Return
else
	Commit ;
	gs_code = 'OK'
//	MessageBox("성공","저장성공 하였습니다.")
End If 

Close(Parent)




end event

event p_choose::ue_lbuttondown;PictureName = 'C:\erpman\image\추가_dn.gif'
end event

event p_choose::ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\추가_up.gif'
end event

type dw_1 from w_inherite_popup`dw_1 within w_han_01011_hist_pop
integer x = 46
integer y = 220
integer width = 4041
integer height = 1200
string dataobject = "d_han_01011_hist_002_pop"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_1::itemchanged;call super::itemchanged;If row < 1 Then Return

Dec ld_inqty , ld_qty
String ls_null

SetNull(ls_null)

Choose Case dwo.name
		
	Case 'out_date' , 'so_date'
		
		if f_datechk(data) < 1 then
			Messagebox('확인','정확한 일자를 입력하세요.')
			This.SetItem(row, dwo.name, ls_null)
			return 1
		end if
			
	Case 'outqty'
		ld_inqty = This.object.inqty[row]
		ld_qty = Dec(data)
		
		If ld_inqty < ld_qty then
			Messagebox('확인','입고수량보다 투입수량이 많을 수 없습니다.')
			Return 1
		End If
		
	Case 'soqty'
		ld_inqty = This.object.inqty[row]
		ld_qty = Dec(data)
		
		If ld_inqty < ld_qty then
			Messagebox('확인','입고수량보다 소진수량이 많을 수 없습니다.')
			Return 1
		End If
	
End Choose
end event

event dw_1::itemerror;call super::itemerror;return 1
end event

event dw_1::clicked;call super::clicked;dw_1.SelectRow(0,False)
if row > 0 then dw_1.SelectRow(row,True)

end event

type sle_2 from w_inherite_popup`sle_2 within w_han_01011_hist_pop
boolean visible = false
integer x = 544
integer y = 2472
boolean enabled = false
end type

type cb_1 from w_inherite_popup`cb_1 within w_han_01011_hist_pop
boolean visible = false
integer x = 672
integer y = 2356
boolean enabled = false
end type

type cb_return from w_inherite_popup`cb_return within w_han_01011_hist_pop
boolean visible = false
integer x = 1307
integer y = 2356
boolean enabled = false
end type

type cb_inq from w_inherite_popup`cb_inq within w_han_01011_hist_pop
boolean visible = false
integer x = 992
integer y = 2356
boolean enabled = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_han_01011_hist_pop
boolean visible = false
integer x = 361
integer y = 2472
boolean enabled = false
end type

type st_1 from w_inherite_popup`st_1 within w_han_01011_hist_pop
boolean visible = false
integer x = 82
integer y = 2484
end type

type dw_hist from datawindow within w_han_01011_hist_pop
boolean visible = false
integer x = 110
integer y = 872
integer width = 3717
integer height = 400
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "none"
string dataobject = "d_shpact_jaje_lot"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type rr_2 from roundrectangle within w_han_01011_hist_pop
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 208
integer width = 4078
integer height = 1224
integer cornerheight = 40
integer cornerwidth = 55
end type

