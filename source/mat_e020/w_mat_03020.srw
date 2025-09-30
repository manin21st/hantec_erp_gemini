$PBExportHeader$w_mat_03020.srw
$PBExportComments$** 저장위치 등록
forward
global type w_mat_03020 from w_inherite
end type
type gb_1 from groupbox within w_mat_03020
end type
type dw_1 from datawindow within w_mat_03020
end type
type rb_1 from radiobutton within w_mat_03020
end type
type rb_2 from radiobutton within w_mat_03020
end type
type rb_3 from radiobutton within w_mat_03020
end type
type pb_1 from u_pb_cal within w_mat_03020
end type
type p_bar from uo_picture within w_mat_03020
end type
type cbx_1 from checkbox within w_mat_03020
end type
type dw_print from datawindow within w_mat_03020
end type
type rr_1 from roundrectangle within w_mat_03020
end type
end forward

global type w_mat_03020 from w_inherite
string title = "저장위치 등록"
gb_1 gb_1
dw_1 dw_1
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
pb_1 pb_1
p_bar p_bar
cbx_1 cbx_1
dw_print dw_print
rr_1 rr_1
end type
global w_mat_03020 w_mat_03020

type variables

end variables

forward prototypes
public function integer wf_required_chk (integer i)
public subroutine wf_reset ()
end prototypes

public function integer wf_required_chk (integer i);//if dw_insert.AcceptText() = -1 then return -1
//
//if isnull(dw_insert.GetItemNumber(i,'vnqty')) or &
//	dw_insert.GetItemNumber(i,'vnqty') = 0 then
//	f_message_chk(1400,'[ '+string(i)+' 행 발주예정량]')
//	dw_insert.ScrollToRow(i)
//	dw_insert.SetColumn('vnqty')
//	dw_insert.SetFocus()
//	return -1		
//end if	
//
//if isnull(dw_insert.GetItemString(i,'locfr')) or &
//   isnull(dw_insert.GetItemString(i,'locto')) then return 1
//
//if dw_insert.GetItemString(i,'locfr') > dw_insert.GetItemString(i,'locto')	 then
//	f_message_chk(34,'')
//	dw_insert.ScrollToRow(i)
//	dw_insert.SetColumn('locfr')
//	dw_insert.SetFocus()
//	return -1		
//end if	
//
return 1
end function

public subroutine wf_reset ();string snull

setnull(snull)

dw_insert.setredraw(false)
dw_1.setredraw(false)

dw_insert.reset()
dw_1.reset()

dw_1.insertrow(0)

dw_1.setredraw(true)
dw_insert.setredraw(true)


end subroutine

on w_mat_03020.create
int iCurrent
call super::create
this.gb_1=create gb_1
this.dw_1=create dw_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.pb_1=create pb_1
this.p_bar=create p_bar
this.cbx_1=create cbx_1
this.dw_print=create dw_print
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_1
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.rb_1
this.Control[iCurrent+4]=this.rb_2
this.Control[iCurrent+5]=this.rb_3
this.Control[iCurrent+6]=this.pb_1
this.Control[iCurrent+7]=this.p_bar
this.Control[iCurrent+8]=this.cbx_1
this.Control[iCurrent+9]=this.dw_print
this.Control[iCurrent+10]=this.rr_1
end on

on w_mat_03020.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_1)
destroy(this.dw_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.pb_1)
destroy(this.p_bar)
destroy(this.cbx_1)
destroy(this.dw_print)
destroy(this.rr_1)
end on

event open;call super::open;dw_insert.SetTransObject(sqlca)
dw_print.SetTransObject(sqlca)
dw_1.SetTransObject(sqlca)
dw_1.insertrow(0)
dw_1.SetFocus()

String is_ispec, is_jijil
IF f_change_name('1') = 'Y' then 
	is_ispec = f_change_name('2')
	is_jijil = f_change_name('3')
	dw_insert.object.ispec_t.text = is_ispec
	dw_insert.object.jijil_t.text = is_jijil
END IF

//입고창고 
f_child_saupj(dw_1, 'sdepot', gs_saupj)
end event

event key;// Page Up & Page Down & Home & End Key 사용 정의
choose case key
	case keypageup!
		dw_insert.scrollpriorpage()
	case keypagedown!
		dw_insert.scrollnextpage()
	case keyhome!
		dw_insert.scrolltorow(1)
	case keyend!
		dw_insert.scrolltorow(dw_insert.rowcount())
	case KeyupArrow!
		dw_insert.scrollpriorrow()
	case KeyDownArrow!
		dw_insert.scrollnextrow()		
end choose


end event

type dw_insert from w_inherite`dw_insert within w_mat_03020
integer x = 50
integer y = 288
integer width = 4539
integer height = 2012
integer taborder = 30
string dataobject = "d_mat_03020_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

type p_delrow from w_inherite`p_delrow within w_mat_03020
boolean visible = false
integer x = 4123
integer y = 3252
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_mat_03020
boolean visible = false
integer x = 3950
integer y = 3252
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_mat_03020
boolean visible = false
integer x = 3255
integer y = 3252
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_mat_03020
boolean visible = false
integer x = 3776
integer y = 3252
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_mat_03020
integer x = 4430
integer taborder = 60
end type

type p_can from w_inherite`p_can within w_mat_03020
integer x = 4256
integer taborder = 50
end type

event p_can::clicked;call super::clicked;wf_reset()
ib_any_typing = FALSE



end event

type p_print from w_inherite`p_print within w_mat_03020
boolean visible = false
integer x = 3429
integer y = 3252
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_mat_03020
integer x = 3909
integer taborder = 20
end type

event p_inq::clicked;call super::clicked;string s_depot, s_fritnbr, s_date, sittyp, sitcls, s_fritdsc, s_frispec
String ls_filter

if dw_1.AcceptText() = -1 then return 

s_depot = trim(dw_1.GetItemString(1,'sdepot'))
s_fritnbr = trim(dw_1.GetItemString(1,'fr_itnbr'))
s_fritdsc = trim(dw_1.GetItemString(1,'fr_itdsc'))
s_frispec = trim(dw_1.GetItemString(1,'fr_ispec'))
sittyp    = dw_1.GetItemString(1,'ittyp')
sitcls    = dw_1.GetItemString(1,'itcls')
s_date    = trim(dw_1.GetItemString(1,'sdate'))

if isnull(s_depot) or s_depot = "" then
	f_message_chk(30,'[창고]')
	dw_1.SetColumn('sdepot')
	dw_1.SetFocus()
	return
end if	

if isnull(sittyp) or sittyp = "" then	
	MESSAGEBOX('알림','품목구분을 선택하세요')
	dw_1.SetColumn('ittyp')
	dw_1.SetFocus()
	RETURN
END IF	

if isnull(sitcls) or sitcls = "" then
	sitcls = '%'
else
	sitcls = sitcls + '%'
end if

if isnull(s_fritnbr) or s_fritnbr = "" then
	s_fritnbr = '%'
else
	s_fritnbr = s_fritnbr + '%'
end if

if isnull(s_fritdsc) or s_fritdsc = "" then
	s_fritdsc = '%'
else
	s_fritdsc = s_fritdsc + '%'
end if
if isnull(s_frispec) or s_frispec = "" then
	s_frispec = '%'
else
	s_frispec = s_frispec + '%'
end if

ls_filter = ''
if s_date = '' or isnull(s_date)  then 
else
	ls_filter = "(last_in_date = '"+s_date+"')"
end if
dw_insert.SetFilter(ls_filter)  	
dw_insert.Filter( )

IF rb_1.checked then  //품번순
   dw_insert.SetSort("itnbr A, LOTNO A")
ELSEIF rb_2.checked then  //품명순
   dw_insert.SetSort("itdsc A, itnbr A")
ELSE  //LOCATION 순
   dw_insert.SetSort("locfr A, locto A, itnbr A")
END IF
dw_insert.Sort()

if dw_insert.Retrieve(s_depot, s_fritnbr, sittyp, sitcls, gs_saupj) <= 0 then 
	dw_1.Setfocus()
	return
else
   dw_insert.SetColumn('locfr')
	dw_insert.SetFocus()
end if	

ib_any_typing = FALSE


end event

type p_del from w_inherite`p_del within w_mat_03020
boolean visible = false
integer x = 4370
integer y = 3252
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_mat_03020
integer x = 4082
integer taborder = 40
end type

event p_mod::clicked;call super::clicked;long i

if dw_insert.AcceptText() = -1 then return 

if dw_insert.rowcount() <= 0 then return 	

//FOR i = 1 TO dw_insert.RowCount()
//	IF wf_required_chk(i) = -1 THEN RETURN
//NEXT

if f_msg_update() = -1 then return
	
if dw_insert.update() = 1 then
	sle_msg.text = "자료가 저장되었습니다!!"
	ib_any_typing= FALSE
	commit ;
else
	rollback ;
	messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
	return 
end if	
		

end event

type cb_exit from w_inherite`cb_exit within w_mat_03020
integer x = 2793
integer y = 3292
end type

type cb_mod from w_inherite`cb_mod within w_mat_03020
integer x = 2089
integer y = 3292
end type

type cb_ins from w_inherite`cb_ins within w_mat_03020
integer x = 105
integer y = 3516
string text = "추가(&A)"
end type

type cb_del from w_inherite`cb_del within w_mat_03020
integer x = 443
integer y = 3512
end type

type cb_inq from w_inherite`cb_inq within w_mat_03020
integer x = 1742
integer y = 3296
end type

type cb_print from w_inherite`cb_print within w_mat_03020
integer x = 777
integer y = 3504
end type

type st_1 from w_inherite`st_1 within w_mat_03020
end type

type cb_can from w_inherite`cb_can within w_mat_03020
integer x = 2441
integer y = 3292
end type

type cb_search from w_inherite`cb_search within w_mat_03020
integer x = 1120
integer y = 3504
end type





type gb_10 from w_inherite`gb_10 within w_mat_03020
integer x = 5
integer y = 2960
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

type gb_button1 from w_inherite`gb_button1 within w_mat_03020
end type

type gb_button2 from w_inherite`gb_button2 within w_mat_03020
end type

type gb_1 from groupbox within w_mat_03020
integer x = 3090
integer width = 507
integer height = 264
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
string text = "조회 순서"
end type

type dw_1 from datawindow within w_mat_03020
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 27
integer y = 20
integer width = 3063
integer height = 256
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_mat_03020_a"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;setnull(gs_code)

IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
		IF This.GetColumnName() = "fr_itnbr" Then
			open(w_itemas_popup2)
			if isnull(gs_code) or gs_code = "" then return
			
			this.SetItem(1,"fr_itnbr",gs_code)
			RETURN 1
      End If
END IF

end event

event itemerror;return 1
end event

event rbuttondown;setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)

string sittyp
str_itnct lstr_sitnct

this.accepttext()
if this.GetColumnName() = 'itcls' then

	sIttyp = this.GetItemString(1, 'ittyp')
	OpenWithParm(w_ittyp_popup4, sIttyp)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"ittyp",  lstr_sitnct.s_ittyp)
	this.SetItem(1,"itcls",  lstr_sitnct.s_sumgub)
	this.SetItem(1,"clsnm",  lstr_sitnct.s_titnm)
elseif this.GetColumnName() = 'fr_itnbr' then
   gs_code = this.GetText()
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"fr_itnbr",gs_code)
	this.TriggerEvent(ItemChanged!)
end if	


end event

event itemchanged;string  sitnbr, sitdsc, sispec, sdate, sNull, s_itt, s_name
int     ireturn

setnull(sNull)

IF this.GetColumnName() = "fr_itnbr"	THEN
	sItnbr = trim(this.GetText())
	ireturn = f_get_name2('품번', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "fr_itnbr", sitnbr)	
	this.setitem(1, "fr_itdsc", sitdsc)	
	this.setitem(1, "fr_ispec", sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = "fr_itdsc"	THEN
	sItdsc = trim(this.GetText())
	ireturn = f_get_name2('품명', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "fr_itnbr", sitnbr)	
	this.setitem(1, "fr_itdsc", sitdsc)	
	this.setitem(1, "fr_ispec", sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = "fr_ispec"	THEN
	sIspec = trim(this.GetText())
	ireturn = f_get_name2('규격', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "fr_itnbr", sitnbr)	
	this.setitem(1, "fr_itdsc", sitdsc)	
	this.setitem(1, "fr_ispec", sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = 'ittyp' then
	s_itt = this.gettext()
 
   IF s_itt = "" OR IsNull(s_itt) THEN 
		this.SetItem(1,'itcls', snull)
		this.SetItem(1,'clsnm', snull)
		RETURN
   END IF
	
	s_name = f_get_reffer('05', s_itt)
	if isnull(s_name) or s_name="" then
		f_message_chk(33,'[품목구분]')
		this.SetItem(1,'ittyp', snull)
		this.SetItem(1,'itcls', snull)
		this.SetItem(1,'clsnm', snull)
		return 1
	else	
		this.SetItem(1,'itcls', snull)
		this.SetItem(1,'clsnm', snull)
   end if
ELSEIF this.GetColumnName() = 'itcls' then
	sItnbr = this.GetText()
   this.accepttext()	
	sispec = this.getitemstring(1, 'ittyp')
	
	ireturn = f_get_name2('품목분류', 'Y', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "itcls", sitnbr)	
	this.setitem(1, "clsnm", sitdsc)	
	RETURN ireturn
ELSEIF this.GetColumnName() = 'clsnm' then
//	sItnbr = this.GetText()
//
//	sIttyp = this.GetItemString(1, 'ittyp')
//	OpenWithParm(w_ittyp_popup4, sIttyp)
//	
//   lstr_sitnct = Message.PowerObjectParm	
//	
//	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
//	
//	this.setitem(1, "itcls", sitnbr)	
//	this.setitem(1, "clsnm", sitdsc)	
//	RETURN ireturn
ELSEIF this.GetColumnName() = "sdate"	THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF f_datechk(sdate) = -1	then
      f_message_chk(35, '[최종입고일]')
		this.setitem(1, "sdate", sNull)
		return 1
	END IF
END IF
end event

type rb_1 from radiobutton within w_mat_03020
integer x = 3118
integer y = 56
integer width = 448
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "품 번 순"
boolean checked = true
end type

event clicked;dw_insert.SetSort("itnbr A, LOTNO A")
dw_insert.Sort()

end event

type rb_2 from radiobutton within w_mat_03020
integer x = 3118
integer y = 116
integer width = 448
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "품 명 순"
end type

event clicked;dw_insert.SetSort("itdsc A, itnbr A")
dw_insert.Sort()

end event

type rb_3 from radiobutton within w_mat_03020
integer x = 3118
integer y = 176
integer width = 448
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "LOCATION 순"
end type

event clicked;dw_insert.SetSort("locfr A, locto A, itnbr A")
dw_insert.Sort()

end event

type pb_1 from u_pb_cal within w_mat_03020
integer x = 2921
integer y = 60
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_1.SetColumn('sdate')
IF IsNull(gs_code) THEN Return
ll_row = dw_1.GetRow()
If ll_row < 1 Then Return
dw_1.SetItem(ll_row, 'sdate', gs_code)



end event

type p_bar from uo_picture within w_mat_03020
boolean visible = false
integer x = 3607
integer y = 24
integer width = 178
integer taborder = 90
boolean bringtotop = true
string picturename = "C:\erpman\image\barcode.gif"
end type

event clicked;call super::clicked;string ls_chk, ls_itnbr, ls_lotno, ls_pspec, ls_ittyp
long   ll_rowcnt, ll_cnt, ll_copies, ll_mod, ll_count
int    i, j, h, k
dec    ld_jego, ld_cutqty, ld_pqty

if dw_insert.accepttext() = -1 then return -1
if dw_1.accepttext() = -1 then return -1

ll_rowcnt = dw_insert.rowcount()
if ll_rowcnt < 1 then
	MessageBox('확인','인쇄할 자료가 존재하지 않습니다!')
	return
end if

ll_cnt = 0
for i = 1 to dw_insert.rowcount()
	 ls_chk = dw_insert.GetItemString(i,'chk')
	 if ls_chk = 'Y' then
		 ll_cnt++
	 end if	
next	

if ll_cnt = 0 then
	MessageBox('확인','인쇄할 자료를 선택 후 작업하세요!')
	return
end if

//용지 SIZE 지정
dw_print.object.datawindow.print.paper.size = '11.43cm * 11.43cm'

//프린터 옵션 Open
if printsetup() = -1 then
	messagebox("프린트 선택 에러!", "프린트를 선택할 수 없습니다.")
end if

ls_ittyp = dw_1.GetItemString(1,'ittyp')

if ls_ittyp = '1' or  ls_ittyp = '2' then //완제품, 반제품
   dw_print.dataobject = 'd_mat_03020_bar_p1'
	dw_print.settransobject(sqlca)
else
	dw_print.dataobject = 'd_mat_03020_bar_p'
	dw_print.settransobject(sqlca)
end if	
//바코드 발행
for j = 1 to dw_insert.rowcount()
	 ls_chk    = dw_insert.GetItemString(j,'chk')
	 if ls_chk = 'Y' then
 		 ls_itnbr  = dw_insert.GetItemString(j,'itnbr')
		 ls_lotno  = dw_insert.GetItemString(j,'lotno')
		 ls_pspec  = dw_insert.GetItemString(j,'pspec')
		 ll_copies = dw_insert.GetItemNumber(j,'copies')
		 ld_pqty   = dw_insert.GetItemNumber(j,'jego_qty')  //재고수량
   	 ld_cutqty = dw_insert.GetItemNumber(j,'print_qty') //분할수량		 
		 
		 if ld_cutqty > 0 then			 			 
			 if ld_pqty <= ld_cutqty then
				 if dw_print.retrieve(gs_saupj, ls_itnbr, ls_lotno, ls_pspec) = 1 then
					 for k = 1 to ll_copies
						  dw_print.print()
					 next	
				 end if				 
			 else
				 // ll_cutqty : 분할 수량
				 // ll_qty    : 조회 수량
				 // ll_mod    : 나머지 수량
				 // ll_count  : 출력 장수
				 ll_count = Int(ld_pqty / ld_cutqty)  
				 ll_mod   = MOD(ld_pqty, ld_cutqty)   

				 if dw_print.retrieve(gs_saupj, ls_itnbr, ls_lotno, ls_pspec) = 1 then
					 //분할수량을 조회수량에 입력하여 출력 장수만큼 출력
					 dw_print.setitem(1,'ioqty', ld_cutqty )
					 for h = 1 to ll_count				     	  						  
						  for k = 1 to ll_copies
							   dw_print.print()
						  next	
					 next					 
					 //나머지 수량이 존재할 경우 나머지 수량 입력 후 한번 더 출력
					 if ll_mod <> 0 then
						 dw_print.setitem(1,'ioqty', ll_mod)
						 for k = 1 to ll_copies
							  dw_print.print()
						 next	
					 end if	 
				 end if				 			 			 
			 end if	 
		else
			if dw_print.retrieve(gs_saupj, ls_itnbr, ls_lotno, ls_pspec) = 1 then
				for k = 1 to ll_copies
			       dw_print.print()
 			   next	
			end if	 
		end if	
	end if
next	

end event

event ue_lbuttondown;call super::ue_lbuttondown;//PictureName = "C:\erpman\image\재고조회_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;//PictureName = "C:\erpman\image\재고조회_up.gif"
end event

type cbx_1 from checkbox within w_mat_03020
integer x = 4187
integer y = 196
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 134217750
string text = "전체선택"
end type

event clicked;long ll_count, lCount
string ls_status

if this.checked = true then
	ls_status='Y'
	this.text = '전체해제'
else
	ls_status='N'
	this.text = '전체선택'
end if

SetPointer(HourGlass!)

lCount = dw_insert.rowcount() 

for ll_count=1 to lCount
	dw_insert.setitem(ll_count, 'chk', ls_status)
next


end event

type dw_print from datawindow within w_mat_03020
boolean visible = false
integer x = 3712
integer y = 156
integer width = 187
integer height = 112
integer taborder = 70
boolean bringtotop = true
boolean titlebar = true
string title = "none"
string dataobject = "d_mat_03020_bar_p"
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_mat_03020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 280
integer width = 4567
integer height = 2032
integer cornerheight = 40
integer cornerwidth = 55
end type

