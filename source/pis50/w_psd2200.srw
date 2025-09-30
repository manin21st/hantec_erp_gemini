$PBExportHeader$w_psd2200.srw
$PBExportComments$공상치료자 등록
forward
global type w_psd2200 from w_inherite
end type
type rr_3 from roundrectangle within w_psd2200
end type
type dw_list from datawindow within w_psd2200
end type
type st_2 from statictext within w_psd2200
end type
type em_1 from editmask within w_psd2200
end type
type em_2 from editmask within w_psd2200
end type
type st_3 from statictext within w_psd2200
end type
type gb_1 from groupbox within w_psd2200
end type
type gb_2 from groupbox within w_psd2200
end type
type st_4 from statictext within w_psd2200
end type
type rr_1 from roundrectangle within w_psd2200
end type
type rr_2 from roundrectangle within w_psd2200
end type
type ln_1 from line within w_psd2200
end type
type dw_detail from datawindow within w_psd2200
end type
type dw_1 from datawindow within w_psd2200
end type
end forward

global type w_psd2200 from w_inherite
integer height = 2360
string title = "공상치료자등록"
rr_3 rr_3
dw_list dw_list
st_2 st_2
em_1 em_1
em_2 em_2
st_3 st_3
gb_1 gb_1
gb_2 gb_2
st_4 st_4
rr_1 rr_1
rr_2 rr_2
ln_1 ln_1
dw_detail dw_detail
dw_1 dw_1
end type
global w_psd2200 w_psd2200

type variables

end variables

on w_psd2200.create
int iCurrent
call super::create
this.rr_3=create rr_3
this.dw_list=create dw_list
this.st_2=create st_2
this.em_1=create em_1
this.em_2=create em_2
this.st_3=create st_3
this.gb_1=create gb_1
this.gb_2=create gb_2
this.st_4=create st_4
this.rr_1=create rr_1
this.rr_2=create rr_2
this.ln_1=create ln_1
this.dw_detail=create dw_detail
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_3
this.Control[iCurrent+2]=this.dw_list
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.em_1
this.Control[iCurrent+5]=this.em_2
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.gb_1
this.Control[iCurrent+8]=this.gb_2
this.Control[iCurrent+9]=this.st_4
this.Control[iCurrent+10]=this.rr_1
this.Control[iCurrent+11]=this.rr_2
this.Control[iCurrent+12]=this.ln_1
this.Control[iCurrent+13]=this.dw_detail
this.Control[iCurrent+14]=this.dw_1
end on

on w_psd2200.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_3)
destroy(this.dw_list)
destroy(this.st_2)
destroy(this.em_1)
destroy(this.em_2)
destroy(this.st_3)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.st_4)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.ln_1)
destroy(this.dw_detail)
destroy(this.dw_1)
end on

event open;call super::open;dw_list.settransobject(sqlca)
dw_detail.settransobject(sqlca)
dw_datetime.settransobject(sqlca)
dw_1.settransobject(sqlca)


em_1.text = string(today(),'yyyy/01/01')
em_2.text = string(today())

dw_1.insertrow(0)

f_set_saupcd(dw_1, 'saupcd', '1')


cb_inq.TriggerEvent(Clicked!)

//string ls_sdate, ls_edate
//ls_sdate = left(em_1.text,4) + mid(em_1.text,6,2) + right(em_1.text,2)
//ls_edate = left(em_2.text,4) + mid(em_2.text,6,2) + right(em_2.text,2)
//
//dw_list.retrieve(ls_sdate,ls_edate)

dw_detail.insertrow(0)
//dw_detail.setitem(dw_detail.getrow(),'p8_sanjae_sadate',string(today(),'yyyymmdd'))
end event

type dw_insert from w_inherite`dw_insert within w_psd2200
boolean visible = false
integer x = 146
integer y = 2368
integer taborder = 130
end type

type p_delrow from w_inherite`p_delrow within w_psd2200
boolean visible = false
integer x = 2903
integer y = 128
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_psd2200
boolean visible = false
integer x = 2880
integer y = 132
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_psd2200
boolean visible = false
integer x = 2894
integer y = 128
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_psd2200
integer x = 3365
integer y = 120
end type

event p_ins::clicked;call super::clicked;
dw_detail.scrolltorow(dw_detail.insertrow(0))
string ls_sdate, ls_edate

ls_sdate = left(em_1.text,4) + mid(em_1.text,6,2) + right(em_1.text,2)
ls_edate = left(em_2.text,4) + mid(em_2.text,6,2) + right(em_2.text,2)

dw_detail.setitem(dw_detail.getrow(),'p8_sanjae_sadate',string(today(),'yyyymmdd'))
end event

type p_exit from w_inherite`p_exit within w_psd2200
integer x = 4059
integer y = 120
end type

type p_can from w_inherite`p_can within w_psd2200
integer x = 3886
integer y = 120
end type

event p_can::clicked;call super::clicked;
dw_detail.reset()

cb_ins.TriggerEvent(Clicked!)
end event

type p_print from w_inherite`p_print within w_psd2200
boolean visible = false
integer x = 2885
integer y = 132
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_psd2200
integer x = 3191
integer y = 120
end type

event p_inq::clicked;call super::clicked;

string ls_sdate, ls_edate,ls_saupcd

ls_sdate = left(em_1.text,4) + mid(em_1.text,6,2) + right(em_1.text,2)
ls_edate = left(em_2.text,4) + mid(em_2.text,6,2) + right(em_2.text,2)
ls_saupcd = dw_1.GetItemString(1,"saupcd")

if ls_sdate = '00000000' then ls_sdate = '00000000'
if ls_edate = '00000000' then ls_edate = '99999999'

dw_list.retrieve(ls_sdate,ls_edate,ls_saupcd)
end event

type p_del from w_inherite`p_del within w_psd2200
integer x = 3712
integer y = 120
end type

event p_del::clicked;call super::clicked;

string ls_date,ls_no
long ll_chk

ls_no   = dw_list.getitemstring(dw_list.getrow(),4)
ls_date = dw_list.getitemstring(dw_list.getrow(),1)

ll_chk = messagebox('확인','선택하신 내역을 삭제 하시겠습니까?',exclamation!,okcancel!,2)

if ll_chk = 1 then
	dw_list.deleterow(0)
	
	delete from p8_sanjae
	 where empno  = :ls_no
	 and sadate = :ls_date;
	
	commit;
	
	sle_msg.text = '자료가 삭제 되었습니다.'
	cb_inq.TriggerEvent(Clicked!)
	
else
	return
end if
end event

type p_mod from w_inherite`p_mod within w_psd2200
integer x = 3538
integer y = 120
end type

event p_mod::clicked;call super::clicked;
string ls_len

ls_len = dw_detail.GetItemString(1, "p8_sanjae_sabigo")

if len(ls_len) > 200 then
	messagebox('확인','입력범위를 초과했습니다.',exclamation!)
	return
end if

IF dw_detail.Update() > 0 THEN			
	COMMIT USING sqlca;
	ib_any_typing =False
	
ELSE
	ROLLBACK USING sqlca;
	f_rollback()
	ib_any_typing = True
	Return
END IF
	
commit;
sle_msg.text = '저장 완료...!'
dw_detail.reset()
dw_detail.insertrow(0)
cb_inq.TriggerEvent(Clicked!)
end event

type cb_exit from w_inherite`cb_exit within w_psd2200
boolean visible = false
integer x = 1280
integer y = 2480
integer taborder = 110
boolean enabled = false
end type

type cb_mod from w_inherite`cb_mod within w_psd2200
boolean visible = false
integer x = 1051
integer y = 2520
integer taborder = 80
boolean enabled = false
end type

event cb_mod::clicked;call super::clicked;string ls_len

ls_len = dw_detail.GetItemString(1, "p8_sanjae_sabigo")

if len(ls_len) > 200 then
	messagebox('확인','입력범위를 초과했습니다.',exclamation!)
	return
end if

IF dw_detail.Update() > 0 THEN			
	COMMIT USING sqlca;
	ib_any_typing =False
	
ELSE
	ROLLBACK USING sqlca;
	f_rollback()
	ib_any_typing = True
	Return
END IF

string ls_no, ls_date, ls_bigo, stest
ls_no   = dw_detail.getitemstring(dw_detail.getrow(),'p8_sanjae_empno')
ls_date = dw_detail.getitemstring(dw_detail.getrow(),'p8_sanjae_sadate')
ls_bigo = ls_len
stest = mid(ls_bigo,3,1)


update p8_sanjae
   set sabigo = :ls_bigo
 where empno  = :ls_no
   and sadate = :ls_date;
	
commit;
sle_msg.text = '저장 완료...!'
dw_detail.reset()
dw_detail.insertrow(0)
cb_inq.TriggerEvent(Clicked!)
end event

type cb_ins from w_inherite`cb_ins within w_psd2200
integer x = 1705
integer y = 2436
integer taborder = 70
string text = "추가(&I)"
end type

event cb_ins::clicked;call super::clicked;

dw_detail.scrolltorow(dw_detail.insertrow(0))
string ls_sdate, ls_edate

ls_sdate = left(em_1.text,4) + mid(em_1.text,6,2) + right(em_1.text,2)
ls_edate = left(em_2.text,4) + mid(em_2.text,6,2) + right(em_2.text,2)

dw_detail.setitem(dw_detail.getrow(),'p8_sanjae_sadate',string(today(),'yyyymmdd'))
end event

type cb_del from w_inherite`cb_del within w_psd2200
boolean visible = false
integer x = 1074
integer y = 2504
integer taborder = 90
boolean enabled = false
end type

event cb_del::clicked;call super::clicked;

string ls_date,ls_no
long ll_chk

ls_no   = dw_list.getitemstring(dw_list.getrow(),4)
ls_date = dw_list.getitemstring(dw_list.getrow(),1)

ll_chk = messagebox('확인','선택하신 내역을 삭제 하시겠습니까?',exclamation!,okcancel!,2)

if ll_chk = 1 then
	dw_list.deleterow(0)
	
	delete from p8_sanjae
	 where empno  = :ls_no
	 and sadate = :ls_date;
	
	commit;
	
	sle_msg.text = '자료가 삭제 되었습니다.'
	cb_inq.TriggerEvent(Clicked!)
	
else
	return
end if
end event

type cb_inq from w_inherite`cb_inq within w_psd2200
integer x = 658
integer y = 2416
integer taborder = 60
end type

event cb_inq::clicked;call super::clicked;

string ls_sdate, ls_edate,ls_saupcd
ls_sdate = left(em_1.text,4) + mid(em_1.text,6,2) + right(em_1.text,2)
ls_edate = left(em_2.text,4) + mid(em_2.text,6,2) + right(em_2.text,2)
ls_saupcd = dw_1.GetItemString(1, "saupcd")


if ls_sdate = '00000000' then ls_sdate = '00000000'
if ls_edate = '00000000' then ls_edate = '99999999'


dw_list.retrieve(ls_sdate,ls_edate,ls_saupcd)
end event

type cb_print from w_inherite`cb_print within w_psd2200
integer y = 3000
integer taborder = 140
end type

type st_1 from w_inherite`st_1 within w_psd2200
end type

type cb_can from w_inherite`cb_can within w_psd2200
boolean visible = false
integer x = 1170
integer y = 2528
integer taborder = 100
boolean enabled = false
end type

event cb_can::clicked;call super::clicked;
dw_detail.reset()

cb_ins.TriggerEvent(Clicked!)
end event

type cb_search from w_inherite`cb_search within w_psd2200
integer y = 3000
integer taborder = 150
end type







type gb_button1 from w_inherite`gb_button1 within w_psd2200
end type

type gb_button2 from w_inherite`gb_button2 within w_psd2200
end type

type rr_3 from roundrectangle within w_psd2200
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 1915
integer y = 356
integer width = 2423
integer height = 1768
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_list from datawindow within w_psd2200
integer x = 539
integer y = 372
integer width = 1207
integer height = 1716
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_psd2200_01"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;if this.rowcount() < 1 then return
if currentrow > this.rowcount() or currentrow < 1 then return

this.selectrow(0,false)
this.selectrow(currentrow,true)

string ls_code, ls_text, ls_date
ls_code = this.getitemstring(currentrow,4)
ls_date = this.getitemstring(currentrow,1)

dw_detail.retrieve(ls_code, ls_date)


end event

event clicked;
If Row <= 0 then
	dw_list.SelectRow(0,False)

ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	dw_detail.retrieve(dw_list.GetItemString(row,"empno"),dw_list.GetItemString(row,"p8_sanjae_sadate"))
	
	string ls_code, ls_text, ls_date
	ls_code = this.getitemstring(row,4)
	ls_date = this.getitemstring(row,1)
	

	

	
END IF

CALL SUPER ::CLICKED
end event

type st_2 from statictext within w_psd2200
integer x = 626
integer y = 164
integer width = 279
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "발생일자"
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type em_1 from editmask within w_psd2200
event ue_enter_next pbm_keydown
integer x = 905
integer y = 160
integer width = 325
integer height = 72
integer taborder = 10
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
string text = "none"
boolean border = false
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "yyyy.mm.dd"
end type

event ue_enter_next;if keydown(keyenter!) then
	em_2.setfocus()
end if
end event

type em_2 from editmask within w_psd2200
event ue_retrieve pbm_keydown
integer x = 1285
integer y = 160
integer width = 325
integer height = 72
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
string text = "none"
boolean border = false
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datetimemask!
string mask = "yyyy.mm.dd"
end type

event ue_retrieve;if keydown(keyenter!) then
	cb_inq.TriggerEvent(Clicked!)
end if
end event

type st_3 from statictext within w_psd2200
integer x = 1230
integer y = 172
integer width = 55
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "-"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_psd2200
boolean visible = false
integer x = 1705
integer y = 2444
integer width = 2011
integer height = 184
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 79741120
end type

type gb_2 from groupbox within w_psd2200
boolean visible = false
integer x = 210
integer y = 2428
integer width = 389
integer height = 184
integer taborder = 120
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 79741120
end type

type st_4 from statictext within w_psd2200
integer x = 549
integer y = 160
integer width = 64
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 33027312
string text = "*"
alignment alignment = center!
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_psd2200
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 503
integer y = 120
integer width = 1947
integer height = 144
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_psd2200
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 503
integer y = 356
integer width = 1303
integer height = 1764
integer cornerheight = 40
integer cornerwidth = 55
end type

type ln_1 from line within w_psd2200
integer linethickness = 4
integer beginx = 2322
integer beginy = 2056
integer endx = 4201
integer endy = 2056
end type

type dw_detail from datawindow within w_psd2200
event ue_enterkey pbm_dwnprocessenter
event ue_f1 pbm_dwnkey
integer x = 1934
integer y = 372
integer width = 2350
integer height = 1724
integer taborder = 40
string title = "none"
string dataobject = "d_psd2200_02"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_enterkey;send(handle(this),256,9,0)
return 1
end event

event ue_f1;if keydown(keyF1!) then
	this.triggerevent(rbuttondown!)
end if
end event

event itemchanged;string ls_no, ls_name, ls_dept, ls_temp
long l_row
this.accepttext()

if this.getcolumnname() = 'p8_sanjae_empno' then
	ls_no = this.getitemstring(row,'p8_sanjae_empno')
	
	if ls_no = '' or isNull(ls_no) then
		this.setitem(row,'p1_master_empname','')
		this.setitem(row,'p8_sanjae_sadept','')
		return -1
	else
		select count(*), empname, deptcode
		  into :l_row, :ls_name, :ls_dept
		  from p1_master
		 where empno = :ls_no
		 group by empname,deptcode;
		 
		 if l_row < 1 then
			messagebox('확인',ls_no + '는(은) 등록된 사번이 아닙니다.',exclamation!)
			this.setitem(row,'p8_sanjae_empno','')
			this.setcolumn('p8_sanjae_empno')
			return 1
		else
			this.setitem(row,'p1_master_empname',ls_name)
			this.setitem(row,'p8_sanjae_sadept',ls_dept)
		end if
	end if
end if

int sday, shday
double ld_damagepay
if this.getcolumnname() = 'p8_sanjae_saday' then
	ls_no = this.getitemstring(row,'p8_sanjae_empno')
	sday = this.GetitemNumber(row,'p8_sanjae_saday')
	shday = this.GetitemNumber(row,'p8_sanjae_sahday')
	if IsNull(sday) then sday = 0
	if IsNull(shday) then shday = 0
//	ld_damagepay = sqlca.fun_get_hueupamt(ls_no, shday, sday)
	if ld_damagepay > 0 then
   	this.Setitem(row,'damagepay', ld_damagepay)	
	end if
end if
if this.getcolumnname() = 'p8_sanjae_sahday' then
	ls_no = this.getitemstring(row,'p8_sanjae_empno')
	sday = this.GetitemNumber(row,'p8_sanjae_saday')
	shday = this.GetitemNumber(row,'p8_sanjae_sahday')
	if IsNull(sday) then sday = 0
	if IsNull(shday) then shday = 0
//	ld_damagepay = sqlca.fun_get_hueupamt(ls_no, shday, sday)
	if ld_damagepay > 0 then
   	this.Setitem(row,'damagepay', ld_damagepay)	
	end if
end if


end event

event itemerror;return 1
end event

event rbuttondown;string ls_saupcd

setNull(gs_code)
setNull(gs_codename)

ls_saupcd = dw_1.GetItemString(1,"saupcd")

if this.getcolumnname() = 'p8_sanjae_empno' then
	gs_gubun = dw_1.GetItemString(1, "saupcd")
	open(w_employee_saup_popup)
	this.setItem(row,'p8_sanjae_empno',gs_code)
   this.setItem(row,'p1_master_empname',gs_codename)
	string ls_dept
	select deptcode into :ls_dept from p1_master
    where empno = :gs_code;
	this.setItem(row,'p8_sanjae_sadept',ls_dept)
end if
end event

type dw_1 from datawindow within w_psd2200
integer x = 1591
integer y = 128
integer width = 841
integer height = 116
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_psd2200_03"
boolean border = false
boolean livescroll = true
end type

