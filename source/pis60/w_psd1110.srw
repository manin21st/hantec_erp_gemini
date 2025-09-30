$PBExportHeader$w_psd1110.srw
$PBExportComments$고과항목코드등록
forward
global type w_psd1110 from w_inherite_standard
end type
type dw_1 from datawindow within w_psd1110
end type
type rr_2 from roundrectangle within w_psd1110
end type
end forward

global type w_psd1110 from w_inherite_standard
integer height = 2468
string title = "고과항목코드등록"
dw_1 dw_1
rr_2 rr_2
end type
global w_psd1110 w_psd1110

on w_psd1110.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.rr_2
end on

on w_psd1110.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.rr_2)
end on

event open;call super::open;DW_1.SETTRANSOBJECT(SQLCA)
DW_1.RETRIEVE()
dw_1.scrolltorow(dw_1.rowcount())
dw_1.setfocus()

end event

type p_mod from w_inherite_standard`p_mod within w_psd1110
end type

event p_mod::clicked;call super::clicked;string mrlcode, mrlname, mrmcode, mrmname, mrscode, mrsname
long getrow

ib_any_typing = false

if dw_1.accepttext() = -1 then return

getrow = dw_1.getrow()

mrlcode = dw_1.getitemstring(getrow,"mrlcode")
mrlname = dw_1.getitemstring(getrow,"mrlname")
mrmcode = dw_1.getitemstring(getrow,"mrmcode")
mrmname = dw_1.getitemstring(getrow,"mrmname")
mrscode = dw_1.getitemstring(getrow,"mrscode")
mrsname = dw_1.getitemstring(getrow,"mrsname")

if mrlcode = "" or isnull(mrlcode) then 
	messagebox('확인','대분류코드를 확인하세요',stopsign!)
	dw_1.setcolumn("mrlcode")
	dw_1.setfocus()
	return
end if


if not (mrlcode = '1' or mrlcode = '2' or mrlcode = '3') then 
	messagebox('확인',' 1 = 업적 ~r~n 2 = 태도 ~r~n 3 = 능력 ~r~n 외에는 입력할수없습니다')
	dw_1.setcolumn("mrlcode")
	dw_1.setfocus()
	return
end if


if mrlname = "" or isnull(mrlname) then 
	messagebox('확인','대분류명칭을 확인하세요',stopsign!)
	dw_1.setcolumn("mrlname")
	dw_1.setfocus()
	return
end if

if mrmcode = "" or isnull(mrmcode) then 
	messagebox('확인','중분류코드를 확인하세요',stopsign!)
	dw_1.setcolumn("mrmcode")
	dw_1.setfocus()
	return
end if

if mrmname = "" or isnull(mrmname) then 
	messagebox('확인','중분류명칭을 확인하세요',stopsign!)
	dw_1.setcolumn("mrmname")
	dw_1.setfocus()
	return
end if

if mrscode = "" or isnull(mrscode) then 
	messagebox('확인','항목코드를 확인하세요',stopsign!)
	dw_1.setcolumn("mrscode")
	dw_1.setfocus()
	return
end if

if mrsname = "" or isnull(mrsname) then 
	messagebox('확인','항목명칭을 확인하세요',stopsign!)
	dw_1.setcolumn("mrsname")
	dw_1.setfocus()
	return
end if



if messagebox('확인','저장하시겠습니까?',question!,yesno!) = 1 then
	if dw_1.update(true,false) = 1 then
		commit;
		cb_cancel.triggerevent(clicked!)
		w_mdi_frame.sle_msg.text = "저장되었습니다"
	else
		rollback;
		w_mdi_frame.sle_msg.text = "저장에 실패하였습니다"
	end if
end if


end event

type p_del from w_inherite_standard`p_del within w_psd1110
end type

event p_del::clicked;call super::clicked;string mrscode
long getrow

dw_1.accepttext()

getrow = dw_1.getrow()

mrscode = dw_1.getitemstring(getrow,"mrscode")

//if mrscode = '' or isnull(mrscode) then return 

if messagebox('삭제','항목코드 ' + mrscode + &
					' 을 ~r~n삭제하시겠습니까?', question!, yesno!) = 1 then
	
	setpointer(hourglass!)

	delete from p6_meritview 
	where mrscode = :mrscode ;
	
	commit;
	
	sle_msg.text = "삭제되었습니다"
	
end if

setpointer(arrow!)
cb_cancel.triggerevent(clicked!)


end event

type p_inq from w_inherite_standard`p_inq within w_psd1110
integer x = 3639
integer y = 2600
end type

type p_print from w_inherite_standard`p_print within w_psd1110
integer x = 2839
integer y = 2796
end type

type p_can from w_inherite_standard`p_can within w_psd1110
end type

event p_can::clicked;call super::clicked;dw_1.reset()
dw_1.retrieve()
dw_1.scrolltorow(dw_1.rowcount())
dw_1.setfocus()
end event

type p_exit from w_inherite_standard`p_exit within w_psd1110
end type

type p_ins from w_inherite_standard`p_ins within w_psd1110
integer x = 3685
integer y = 28
end type

event p_ins::clicked;call super::clicked;if dw_1.accepttext() = -1 then return -1

long rowcount

dw_1.insertrow(0)
rowcount = dw_1.rowcount()

dw_1.setcolumn("mrlcode")
dw_1.scrolltorow(rowcount)
dw_1.setfocus()

end event

type p_search from w_inherite_standard`p_search within w_psd1110
integer x = 2661
integer y = 2796
end type

type p_addrow from w_inherite_standard`p_addrow within w_psd1110
integer x = 3360
integer y = 2796
end type

type p_delrow from w_inherite_standard`p_delrow within w_psd1110
integer x = 3534
integer y = 2796
end type

type dw_insert from w_inherite_standard`dw_insert within w_psd1110
integer x = 315
integer y = 2832
end type

type st_window from w_inherite_standard`st_window within w_psd1110
integer x = 1522
integer y = 2540
long backcolor = 80269524
end type

type cb_exit from w_inherite_standard`cb_exit within w_psd1110
integer x = 791
integer y = 3004
end type

type cb_update from w_inherite_standard`cb_update within w_psd1110
integer x = 1810
integer y = 2832
end type

event cb_update::clicked;call super::clicked;string mrlcode, mrlname, mrmcode, mrmname, mrscode, mrsname
long getrow

ib_any_typing = false

if dw_1.accepttext() = -1 then return

getrow = dw_1.getrow()

mrlcode = dw_1.getitemstring(getrow,"mrlcode")
mrlname = dw_1.getitemstring(getrow,"mrlname")
mrmcode = dw_1.getitemstring(getrow,"mrmcode")
mrmname = dw_1.getitemstring(getrow,"mrmname")
mrscode = dw_1.getitemstring(getrow,"mrscode")
mrsname = dw_1.getitemstring(getrow,"mrsname")

if mrlcode = "" or isnull(mrlcode) then 
	messagebox('확인','대분류코드를 확인하세요',stopsign!)
	dw_1.setcolumn("mrlcode")
	dw_1.setfocus()
	return
end if


if not (mrlcode = '1' or mrlcode = '2' or mrlcode = '3') then 
	messagebox('확인',' 1 = 업적 ~r~n 2 = 태도 ~r~n 3 = 능력 ~r~n 외에는 입력할수없습니다')
	dw_1.setcolumn("mrlcode")
	dw_1.setfocus()
	return
end if


if mrlname = "" or isnull(mrlname) then 
	messagebox('확인','대분류명칭을 확인하세요',stopsign!)
	dw_1.setcolumn("mrlname")
	dw_1.setfocus()
	return
end if

if mrmcode = "" or isnull(mrmcode) then 
	messagebox('확인','중분류코드를 확인하세요',stopsign!)
	dw_1.setcolumn("mrmcode")
	dw_1.setfocus()
	return
end if

if mrmname = "" or isnull(mrmname) then 
	messagebox('확인','중분류명칭을 확인하세요',stopsign!)
	dw_1.setcolumn("mrmname")
	dw_1.setfocus()
	return
end if

if mrscode = "" or isnull(mrscode) then 
	messagebox('확인','항목코드를 확인하세요',stopsign!)
	dw_1.setcolumn("mrscode")
	dw_1.setfocus()
	return
end if

if mrsname = "" or isnull(mrsname) then 
	messagebox('확인','항목명칭을 확인하세요',stopsign!)
	dw_1.setcolumn("mrsname")
	dw_1.setfocus()
	return
end if



if messagebox('확인','저장하시겠습니까?',question!,yesno!) = 1 then
	if dw_1.update(true,false) = 1 then
		commit;
		cb_cancel.triggerevent(clicked!)
		sle_msg.text = "저장되었습니다"
	else
		rollback;
		sle_msg.text = "저장에 실패하였습니다"
	end if
end if


end event

type cb_insert from w_inherite_standard`cb_insert within w_psd1110
integer x = 1312
integer y = 2820
integer width = 361
string text = "추가(&A)"
end type

event cb_insert::clicked;call super::clicked;if dw_1.accepttext() = -1 then return -1

long rowcount

dw_1.insertrow(0)
rowcount = dw_1.rowcount()

dw_1.setcolumn("mrlcode")
dw_1.scrolltorow(rowcount)
dw_1.setfocus()

end event

type cb_delete from w_inherite_standard`cb_delete within w_psd1110
integer x = 1952
integer y = 2988
end type

event cb_delete::clicked;call super::clicked;string mrscode
long getrow

dw_1.accepttext()

getrow = dw_1.getrow()

mrscode = dw_1.getitemstring(getrow,"mrscode")

//if mrscode = '' or isnull(mrscode) then return 

if messagebox('삭제','항목코드 ' + mrscode + &
					' 을 ~r~n삭제하시겠습니까?', question!, yesno!) = 1 then
	
	setpointer(hourglass!)

	delete from p6_meritview 
	where mrscode = :mrscode ;
	
	commit;
	
	sle_msg.text = "삭제되었습니다"
	
end if

setpointer(arrow!)
cb_cancel.triggerevent(clicked!)


end event

type cb_retrieve from w_inherite_standard`cb_retrieve within w_psd1110
integer x = 827
integer y = 2620
end type

type st_1 from w_inherite_standard`st_1 within w_psd1110
integer x = 96
integer y = 2540
long backcolor = 80269524
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_psd1110
integer x = 2418
integer y = 2892
end type

event cb_cancel::clicked;call super::clicked;dw_1.reset()
dw_1.retrieve()
dw_1.scrolltorow(dw_1.rowcount())
dw_1.setfocus()
end event

type dw_datetime from w_inherite_standard`dw_datetime within w_psd1110
integer x = 2318
integer y = 2528
end type

type sle_msg from w_inherite_standard`sle_msg within w_psd1110
integer x = 507
integer y = 2540
long backcolor = 80269524
end type

type gb_2 from w_inherite_standard`gb_2 within w_psd1110
integer x = 1659
integer y = 2496
integer width = 1947
long backcolor = 80269524
end type

type gb_1 from w_inherite_standard`gb_1 within w_psd1110
integer x = 791
integer y = 2560
end type

type gb_10 from w_inherite_standard`gb_10 within w_psd1110
integer x = 3552
integer y = 2496
long backcolor = 80269524
end type

type dw_1 from datawindow within w_psd1110
event ue_enter pbm_dwnprocessenter
integer x = 78
integer y = 284
integer width = 3378
integer height = 1764
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_psd1110"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_enter;if dw_1.GetColumnName() = "mrsname" then
	if ib_any_typing = true then
		cb_update.triggerevent(clicked!)	
		return
	end if
	
	if dw_1.rowcount() = dw_1.getrow() then
		cb_insert.triggerevent(clicked!)
		return 
	end if
	


end if


Send(Handle(this),256,9,0)
Return 1	

end event

event rowfocuschanged;this.SetRowFocusIndicator(hand!)
end event

event itemerror;return 1
end event

event itemchanged;string icode, iname, icode1, iname1, icode2, iname2, icode2_tmp
long getrow, i

if this.accepttext() = -1 then return -1

getrow = this.getrow()

if dw_1.GetColumnName() = "mrlcode" then
	icode = this.gettext()
	if icode = "" or isnull(icode) then return -1 
	
	if not (icode = '1' or icode = '2' or icode = '3') then 
		messagebox('확인',' 1 = 업적 ~r~n 2 = 태도 ~r~n 3 = 능력 ~r~n 외에는 입력할수없습니다')
		this.setcolumn("mrlcode")
		this.scrolltorow(getrow)
		this.setitem(getrow,"mrlcode","")
		this.setfocus()
		return 1
	end if
	
	select distinct mrlname into :iname
	from p6_meritview
	where mrlcode = :icode ;
	
	if sqlca.sqlcode = 0 then 
	
		this.setitem(getrow,"mrlcode",icode)
		this.setitem(getrow,"mrlname",iname)
		this.setcolumn("mrmcode")
		this.setfocus()
		return 1		
	end if
	
end if

if dw_1.GetColumnName() = "mrmcode" then
	
	icode1 = this.gettext()
	icode = this.getitemstring(getrow,"mrlcode")
	
	if icode = left(icode1,1) then
		
		if icode1 = "" or isnull(icode1) then return -1
		
		select distinct mrmname into :iname1 
		from p6_meritview 
		where mrmcode = :icode1;
	
		if sqlca.sqlcode = 0 then
			
			this.setitem(getrow,"mrmcode",icode1)
			this.setitem(getrow,"mrmname",iname1)
			this.setcolumn("mrscode")
			this.setfocus()
			return 1
			
		end if
	else
		messagebox('확인','코드의 첫째자리는 ~r~n대분류코드를 사용합니다.', stopsign!)
		dw_1.setitem(getrow,"mrmcode","")
		dw_1.scrolltorow(getrow)
		dw_1.setcolumn("mrmcode")
		dw_1.setfocus()
		return 1
	end if

end if

if dw_1.GetColumnName() = "mrscode" then
	
	icode2 = this.gettext()
	icode1 = this.getitemstring(getrow,"mrmcode")
	if icode1 = left(icode2,2) then
		
		if icode2 = "" or isnull(icode2) then return -1
		
		select mrsname into :iname2 
		from p6_meritview 
		where mrscode = :icode2 ;
		
		if sqlca.sqlcode = 0 then
			messagebox('확인','등록된 항목입니다',stopsign!)
			dw_1.setitem(getrow,"mrscode","")
			dw_1.scrolltorow(getrow)
			dw_1.setcolumn("mrscode")
			dw_1.setfocus()
			return 1
			
		else
			
			for i = 1 to dw_1.rowcount() - 1
				icode2_tmp = dw_1.getitemstring(i,"mrscode")
				if icode2_tmp = icode2 then
					messagebox('확인','입력된 항목입니다',stopsign!)
					dw_1.setitem(getrow,"mrscode","")
					dw_1.scrolltorow(getrow)
					dw_1.setcolumn("mrscode")
					dw_1.setfocus()
					return 1
				end if
			next
			
		end if
	else
		messagebox('확인','코드의 둘째자리는 ~r~n중분류코드를 사용합니다.', stopsign!)
		dw_1.scrolltorow(getrow)
		dw_1.setitem(getrow,"mrscode","")
		dw_1.setcolumn("mrscode")
		dw_1.selecttextall()
		dw_1.setfocus()
		return 1
	end if

end if	
	
	
end event

event editchanged;ib_any_typing = true
end event

type rr_2 from roundrectangle within w_psd1110
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 41
integer y = 252
integer width = 4553
integer height = 1992
integer cornerheight = 40
integer cornerwidth = 55
end type

