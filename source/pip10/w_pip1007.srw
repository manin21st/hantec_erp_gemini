$PBExportHeader$w_pip1007.srw
$PBExportComments$** 급여출력항목등록
forward
global type w_pip1007 from w_inherite_standard
end type
type dw_1 from datawindow within w_pip1007
end type
type dw_2 from datawindow within w_pip1007
end type
type rb_1 from radiobutton within w_pip1007
end type
type rb_2 from radiobutton within w_pip1007
end type
type st_2 from statictext within w_pip1007
end type
type st_3 from statictext within w_pip1007
end type
type p_1 from uo_picture within w_pip1007
end type
type cb_1 from commandbutton within w_pip1007
end type
type rr_1 from roundrectangle within w_pip1007
end type
type rr_2 from roundrectangle within w_pip1007
end type
type rr_3 from roundrectangle within w_pip1007
end type
type rr_4 from roundrectangle within w_pip1007
end type
end forward

global type w_pip1007 from w_inherite_standard
string title = "급여항목출력코드등록"
dw_1 dw_1
dw_2 dw_2
rb_1 rb_1
rb_2 rb_2
st_2 st_2
st_3 st_3
p_1 p_1
cb_1 cb_1
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
rr_4 rr_4
end type
global w_pip1007 w_pip1007

on w_pip1007.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_2=create dw_2
this.rb_1=create rb_1
this.rb_2=create rb_2
this.st_2=create st_2
this.st_3=create st_3
this.p_1=create p_1
this.cb_1=create cb_1
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
this.rr_4=create rr_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.rb_1
this.Control[iCurrent+4]=this.rb_2
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.p_1
this.Control[iCurrent+8]=this.cb_1
this.Control[iCurrent+9]=this.rr_1
this.Control[iCurrent+10]=this.rr_2
this.Control[iCurrent+11]=this.rr_3
this.Control[iCurrent+12]=this.rr_4
end on

on w_pip1007.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.p_1)
destroy(this.cb_1)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
destroy(this.rr_4)
end on

event open;call super::open;dw_1.Settransobject(sqlca)
dw_2.Settransobject(sqlca)

dw_1.retrieve()
dw_2.retrieve('1')
end event

type p_mod from w_inherite_standard`p_mod within w_pip1007
integer x = 3895
end type

event p_mod::clicked;call super::clicked;long icur, i, ls_seq
string ls_code

if dw_1.accepttext() = -1 then return
if dw_2.accepttext() = -1 then return

if messagebox('확인','저장하시겠습니까?',question!, yesno! ) = 1 then
	
	icur = dw_1.rowcount()
	for i = 1 to icur
		ls_code = dw_1.getitemstring(i,"tallowcode")
		ls_seq = dw_1.getitemdecimal(i,"printseq")
		if ls_code = "" or isnull(ls_code) then
			messagebox('확인','출력코드를 입력하세요')
			dw_1.setcolumn("tallowcode")
			dw_1.setfocus()
			return -1 
		end if
		if ls_seq = 0 or isnull(ls_seq) then
			messagebox('확인','출력순서를 입력하세요')
			dw_1.setcolumn("printseq")
			dw_1.setfocus()
			return -1
		end if		
	next
	
	if dw_1.update() = 1 then
		
		if dw_2.update() = 1 then
			commit;
			p_inq.triggerevent(clicked!)
			w_mdi_frame.sle_msg.text = "저장되었습니다"
		else
			rollback;
			w_mdi_frame.sle_msg.text = "항목코드 저장 실패"
		end if
		
	else
		rollback;
		w_mdi_frame.sle_msg.text = "출력코드 저장 실패"
	end if


end if


end event

type p_del from w_inherite_standard`p_del within w_pip1007
integer x = 4069
end type

event p_del::clicked;call super::clicked;string ls_no, ls_name, ls_gubn
long icur

if dw_1.accepttext() = -1 then return

icur = dw_1.getrow()
ls_no = dw_1.getitemstring(icur,"tallowcode")
ls_name = dw_1.getitemstring(icur,"tallowname")
ls_gubn = dw_1.getitemstring(icur,"gubun")

if ls_no = "" or isnull(ls_no) then
	
	dw_1.deleterow(icur)

else

	if messagebox('삭제확인',ls_name + "을 삭제하시겠습니까?", question!, yesno! ) = 1 then
		
		delete 
		from p3_tallowance 
		where tallowcode = :ls_no and
				gubun = :ls_gubn;
		
		if sqlca.sqlcode = 0 then 
			commit;
			p_inq.triggerevent(clicked!)
			w_mdi_frame.sle_msg.text = '삭제되었습니다'
		else
			rollback;
			w_mdi_frame.sle_msg.text = '삭제실패'
		end if
		
	end if
	
end if
	

end event

type p_inq from w_inherite_standard`p_inq within w_pip1007
integer x = 3547
end type

event p_inq::clicked;call super::clicked;dw_1.retrieve()
if rb_1.checked = true then
   dw_2.retrieve('1')
else
	dw_2.retrieve('2')
end if
end event

type p_print from w_inherite_standard`p_print within w_pip1007
boolean visible = false
integer x = 3694
integer y = 2372
end type

type p_can from w_inherite_standard`p_can within w_pip1007
integer x = 4242
end type

event p_can::clicked;call super::clicked;p_inq.triggerevent(clicked!)
w_mdi_frame.sle_msg.text = ""
end event

type p_exit from w_inherite_standard`p_exit within w_pip1007
integer x = 4416
end type

type p_ins from w_inherite_standard`p_ins within w_pip1007
boolean visible = false
integer x = 4041
integer y = 2372
end type

type p_search from w_inherite_standard`p_search within w_pip1007
boolean visible = false
integer x = 3520
integer y = 2372
end type

type p_addrow from w_inherite_standard`p_addrow within w_pip1007
boolean visible = false
integer x = 4215
integer y = 2372
end type

type p_delrow from w_inherite_standard`p_delrow within w_pip1007
boolean visible = false
integer x = 4389
integer y = 2372
end type

type dw_insert from w_inherite_standard`dw_insert within w_pip1007
boolean visible = false
integer x = 1216
integer y = 2480
end type

type st_window from w_inherite_standard`st_window within w_pip1007
boolean visible = false
long backcolor = 80269524
end type

type cb_exit from w_inherite_standard`cb_exit within w_pip1007
boolean visible = false
end type

type cb_update from w_inherite_standard`cb_update within w_pip1007
boolean visible = false
end type

type cb_insert from w_inherite_standard`cb_insert within w_pip1007
boolean visible = false
integer width = 384
end type

type cb_delete from w_inherite_standard`cb_delete within w_pip1007
boolean visible = false
end type

type cb_retrieve from w_inherite_standard`cb_retrieve within w_pip1007
boolean visible = false
end type

type st_1 from w_inherite_standard`st_1 within w_pip1007
boolean visible = false
long backcolor = 80269524
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_pip1007
boolean visible = false
end type

type dw_datetime from w_inherite_standard`dw_datetime within w_pip1007
boolean visible = false
end type

type sle_msg from w_inherite_standard`sle_msg within w_pip1007
boolean visible = false
long backcolor = 80269524
end type

type gb_2 from w_inherite_standard`gb_2 within w_pip1007
boolean visible = false
long backcolor = 80269524
end type

type gb_1 from w_inherite_standard`gb_1 within w_pip1007
boolean visible = false
integer width = 846
long backcolor = 80269524
end type

type gb_10 from w_inherite_standard`gb_10 within w_pip1007
boolean visible = false
long backcolor = 80269524
end type

type dw_1 from datawindow within w_pip1007
event ue_enter pbm_dwnprocessenter
integer x = 402
integer y = 260
integer width = 1696
integer height = 1888
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_pip1007_1"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_enter;send(handle(this),256,9,0)
return 1
end event

event itemerror;return 1
end event

event itemchanged;long icur, ls_cnt, ls_seq
string ls_code, ls_gubun, ls_txt, snull

if this.accepttext() = -1 then return -1
	
	icur = this.getrow()
	
	choose case GetColumnName()
		case "printseq"
			ls_seq = this.getitemdecimal(icur, "printseq")
			
			select nvl(count(*),0) into :ls_cnt
			from p3_tallowance
			where printseq = :ls_seq ;
			
//			if ls_cnt <> 0 then
//				messagebox('확인','등록된 출력코드입니다')
//				this.setcolumn("printseq")
//				this.setitem(icur,"printseq",0)
//				this.scrolltorow(icur)
//				this.setfocus()
//				return 1
//			end if
			
		case "tallowcode"
			ls_code = this.getitemstring(icur,"tallowcode")
			ls_gubun = this.getitemstring(icur,"gubun")
				
			if not (ls_code = "" and ls_gubun = "") or &
				not (isnull(ls_code) and isnull(ls_gubun)) then
				
				if ls_gubun = '1' then
					ls_txt = "지급구분"
				else
					ls_txt = "공제구분"
				end if
				
				select nvl(count(*),0) into :ls_cnt
				from p3_tallowance
				where tallowcode = :ls_code and
						gubun = :ls_gubun ;
				
//				if ls_cnt <> 0 then
//					messagebox('확인',ls_txt + '에 등록된 출력코드입니다')
//					this.setcolumn("tallowcode")
//					this.setitem(icur,"tallowcode","")
//					this.scrolltorow(icur)
//					this.setfocus()
//					return 1
//				end if
				
			end if
			
		case "gubun"
			ls_code = this.getitemstring(icur,"tallowcode")
			ls_gubun = this.getitemstring(icur,"gubun")
			ls_seq = this.getitemdecimal(icur, "printseq")
					
			if not (ls_code = "" and ls_gubun = "") or &
				not (isnull(ls_code) and isnull(ls_gubun)) then
				
				if ls_gubun = '1' then
					ls_txt = "지급구분"
				else
					ls_txt = "공제구분"
				end if
				
				select nvl(count(*),0) into :ls_cnt
				from p3_tallowance
				where tallowcode = :ls_code and
						gubun = :ls_gubun ;
				
				if ls_cnt <> 0 then
					messagebox('확인',ls_txt + '에 등록된 출력코드입니다')
					this.setcolumn("tallowcode")				
					this.setitem(icur,"tallowcode","")
					this.scrolltorow(icur)
					this.setfocus()					
					this.Setitem(this.getrow(),'gubun',snull)
					return 1
				end if
				
				select nvl(count(*),0) into :ls_cnt
				from p3_tallowance
				where printseq = :ls_seq and
						gubun = :ls_gubun ;
				
				if ls_cnt <> 0 then
					messagebox('확인',ls_txt + '에 등록된 출력순서코드입니다')
					this.setcolumn("printseq")				
					this.setitem(icur,"printseq","")
					this.scrolltorow(icur)
					this.setfocus()					
					this.Setitem(this.getrow(),'gubun',snull)
					return 1
				end if

			end if
		
	end choose
		
end event

type dw_2 from datawindow within w_pip1007
event ue_dddw_dropdown pbm_dwndropdown
integer x = 2194
integer y = 260
integer width = 1641
integer height = 1892
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_pip1007_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_dddw_dropdown;DataWindowChild dwc 
GetChild(GetColumnName(), dwc) 
dwc.SetTransObject(SQLCA) 

if rb_1.checked = true then
	dwc.retrieve('1')
else
	dwc.retrieve('2')
end if
end event

event retrievestart;Int rtncode

DataWindowChild state_child

rtncode = dw_2.GetChild("tallowcode", state_child)
IF rtncode = -1 THEN 
//	  MessageBox("확인","없슴")
//	  Return
END IF  

state_child.SetTransObject(SQLCA)

string sgbn

if rb_1.checked = true then
	sgbn = '1'
else
	sgbn = '2'
end if

IF state_child.Retrieve(sgbn) <= 0 THEN
	state_child.insertrow(0)
//	Return 1
END IF	
end event

event itemerror;return 1
end event

type rb_1 from radiobutton within w_pip1007
integer x = 2263
integer y = 96
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "지급항목"
boolean checked = true
end type

event clicked;string sgbn

if this.checked = true then
	
  if	dw_2.retrieve('1') < 1 then
	   messagebox("확인","지급항목이 없습니다!")
		return
  end if
  
 DataWindowChild state_child

dw_2.GetChild("tallowcode", state_child)

 state_child.SetTransObject(SQLCA)
 state_child.reset()
IF state_child.Retrieve("1") <= 0 THEN
	state_child.insertrow(0)
//	Return 1
END IF	
  
end if
end event

type rb_2 from radiobutton within w_pip1007
integer x = 2651
integer y = 96
integer width = 347
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "공제항목"
end type

event clicked;string sgbn

if this.checked = true then
	
  if	dw_2.retrieve('2') < 1 then
	   messagebox("확인","공제항목이 없습니다!")
		return
  end if
  
 DataWindowChild state_child
 dw_2.GetChild("tallowcode", state_child)

 state_child.SetTransObject(SQLCA)
 state_child.reset()
IF state_child.Retrieve("2") <= 0 THEN
	state_child.insertrow(0)
//	Return 1
END IF	
  
end if
	
end event

type st_2 from statictext within w_pip1007
integer x = 439
integer y = 68
integer width = 1376
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 25581894
long backcolor = 33027312
string text = "지급항목의 출력순서는 101,102...순서로"
boolean focusrectangle = false
end type

type st_3 from statictext within w_pip1007
integer x = 439
integer y = 124
integer width = 1691
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 25581894
long backcolor = 33027312
string text = "공제항목은 201,202...로 사이의 숫자가 빠지지 않게 유의"
boolean focusrectangle = false
end type

type p_1 from uo_picture within w_pip1007
integer x = 3721
integer y = 24
integer width = 178
integer taborder = 90
boolean bringtotop = true
string picturename = "C:\erpman\image\등록_up.gif"
end type

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\등록_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\등록_dn.gif"
end event

event clicked;call super::clicked;long icurr

if dw_1.accepttext() = -1 then return

icurr = dw_1.rowcount() + 1
dw_1.insertrow(0)
dw_1.setitem(icurr,"printyn",'Y')
dw_1.setcolumn(1)
dw_1.scrolltorow(icurr)
dw_1.setfocus()

w_mdi_frame.sle_msg.text = ""
end event

type cb_1 from commandbutton within w_pip1007
integer x = 3063
integer y = 72
integer width = 274
integer height = 84
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "초기화"
end type

event clicked;IF MessageBox('확인','초기화를 실행하면 이전의 출력코드 설정은 모두 삭제됩니다. ~r~r&
실행하시겠습니까?', Question!, YesNo!, 2) = 2 THEN
	return
END IF

delete from p3_tallowance;
if sqlca.sqlcode <> 0 then
	MessageBox('Error','출력코드 삭제에 실패하였습니다!')
	rollback;
	return
end if

insert into p3_tallowance
select allowcode, allowname, nvl(printseq,0), paysubtag, 'Y'
from p3_allowance;

if sqlca.sqlcode <> 0 then
	MessageBox('Error','출력코드 초기화에 실패하였습니다!')
	rollback;
	return
end if

update p3_allowance
set tallowcode = allowcode;

if sqlca.sqlcode <> 0 then
	MessageBox('Error','수당항목에 대한 출력코드 설정에 실패하였습니다!')
	rollback;
	return
end if

commit;
p_inq.TriggerEvent(Clicked!)
end event

type rr_1 from roundrectangle within w_pip1007
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 384
integer y = 32
integer width = 1801
integer height = 176
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pip1007
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 2194
integer y = 32
integer width = 850
integer height = 176
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_pip1007
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 389
integer y = 252
integer width = 1723
integer height = 1912
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_4 from roundrectangle within w_pip1007
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2185
integer y = 252
integer width = 1669
integer height = 1912
integer cornerheight = 40
integer cornerwidth = 55
end type

