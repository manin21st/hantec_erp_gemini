$PBExportHeader$w_psd1170.srw
$PBExportComments$고과점수등록
forward
global type w_psd1170 from w_inherite_standard
end type
type rr_1 from roundrectangle within w_psd1170
end type
type dw_list from datawindow within w_psd1170
end type
type dw_detail from datawindow within w_psd1170
end type
type dw_ym from datawindow within w_psd1170
end type
type dw_go from datawindow within w_psd1170
end type
type st_2 from statictext within w_psd1170
end type
type rb_1 from radiobutton within w_psd1170
end type
type rb_2 from radiobutton within w_psd1170
end type
type dw_empno from datawindow within w_psd1170
end type
type st_3 from statictext within w_psd1170
end type
type rr_2 from roundrectangle within w_psd1170
end type
type rr_3 from roundrectangle within w_psd1170
end type
end forward

global type w_psd1170 from w_inherite_standard
integer height = 2464
string title = "고과점수 등록"
rr_1 rr_1
dw_list dw_list
dw_detail dw_detail
dw_ym dw_ym
dw_go dw_go
st_2 st_2
rb_1 rb_1
rb_2 rb_2
dw_empno dw_empno
st_3 st_3
rr_2 rr_2
rr_3 rr_3
end type
global w_psd1170 w_psd1170

type variables

end variables

forward prototypes
public subroutine wf_reset ()
public function integer rb_check ()
end prototypes

public subroutine wf_reset ();dw_go.insertrow(0)
dw_go.retrieve(gs_empno)
dw_empno.insertrow(0)

//rb_check()


end subroutine

public function integer rb_check ();string li_empno, saupcd

saupcd = dw_ym.GetItemString(1,'saupcd')

if saupcd = ""  or  isnull(saupcd) then	saupcd = '%'

if (rb_1.checked = true or rb_2.checked = false) then
	
	dw_list.dataobject = 'd_psd1170_list'
	dw_list.settransobject(sqlca)
	
	if dw_list.retrieve(gs_empno,saupcd) < 1 then 
		messagebox('확인','피고과자가 없습니다')
		dw_detail.reset()
		return -1
	end if
	
	dw_detail.object.grade1.visible = true
	dw_detail.object.a_grade2.visible = false
	
elseif (rb_2.checked = true or rb_1.checked = false) then
		
	dw_list.dataobject = 'd_psd1170_list_1'
	dw_list.settransobject(sqlca)
		
	if dw_list.retrieve(gs_empno,saupcd) < 1 then
		messagebox('확인','피고과자가 없습니다')
		dw_detail.reset()
		return -1
	end if
	
	dw_detail.object.a_grade2.visible = true
	dw_detail.object.grade1.visible = false

end if

dw_empno.reset()
dw_empno.insertrow(0)
dw_detail.reset()

return 1
end function

on w_psd1170.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.dw_list=create dw_list
this.dw_detail=create dw_detail
this.dw_ym=create dw_ym
this.dw_go=create dw_go
this.st_2=create st_2
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_empno=create dw_empno
this.st_3=create st_3
this.rr_2=create rr_2
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.dw_list
this.Control[iCurrent+3]=this.dw_detail
this.Control[iCurrent+4]=this.dw_ym
this.Control[iCurrent+5]=this.dw_go
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.rb_1
this.Control[iCurrent+8]=this.rb_2
this.Control[iCurrent+9]=this.dw_empno
this.Control[iCurrent+10]=this.st_3
this.Control[iCurrent+11]=this.rr_2
this.Control[iCurrent+12]=this.rr_3
end on

on w_psd1170.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.dw_list)
destroy(this.dw_detail)
destroy(this.dw_ym)
destroy(this.dw_go)
destroy(this.st_2)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_empno)
destroy(this.st_3)
destroy(this.rr_2)
destroy(this.rr_3)
end on

event open;call super::open;dw_ym.settransobject(sqlca)
dw_go.settransobject(sqlca)
dw_empno.settransobject(sqlca)
dw_list.settransobject(sqlca)
dw_detail.settransobject(sqlca)

dw_ym.insertrow(0)
dw_ym.setitem(1,"ym",left(f_today(),6))
dw_ym.setfocus()

/*사업장 정보 셋팅*/
f_set_saupcd(dw_ym,'saupcd','1')
is_saupcd = gs_saupcd

wf_reset()





end event

type p_mod from w_inherite_standard`p_mod within w_psd1170
integer x = 4087
integer y = 28
end type

event p_mod::clicked;call super::clicked;string li_ym, li_empno, li_mrl, li_mrm, li_mrs, li_grade, li_deptcd, li_levelcd,li_grade2,li_gradecd
long rowcount, li_curr, ls_cnt

if dw_ym.accepttext() = -1 then return -1
if dw_empno.accepttext() = -1 then return -1
if dw_detail.accepttext() = -1 then return -1

rowcount = dw_detail.rowcount()

li_ym = dw_ym.getitemstring(1,"ym")
li_empno = dw_empno.getitemstring(1,"p1_master_empno")
li_deptcd = dw_empno.getitemstring(1,"p0_dept_deptcode")
li_levelcd = dw_empno.getitemstring(1,"p1_master_levelcode")
li_gradecd = dw_empno.getitemstring(1,"p0_grade_gradecode")

if messagebox('확인','저장하시겠습니까?', question!, yesno!) = 1 then
	
	setpointer(hourglass!)
	for li_curr = 1 to rowcount 
		li_mrl = dw_detail.getitemstring(li_curr,"p6_meritperson_mrlcode")
		li_mrm = dw_detail.getitemstring(li_curr,"p6_meritperson_mrmcode")
		li_mrs = dw_detail.getitemstring(li_curr,"p6_meritperson_mrscode")
		li_grade = dw_detail.getitemstring(li_curr,"grade1")
		li_grade2 = dw_detail.getitemstring(li_curr,"a_grade2")
		
//		if (li_grade = "" or isnull(li_grade)) then
//			messagebox('확인','고과점수를 확인하세요')
//			dw_detail.setcolumn("grade1")
//			dw_detail.scrolltorow(li_curr)
//			dw_detail.setfocus()
//			return -1
//		end if	
					
		select count(*) into :ls_cnt 
		from p6_meritgrade
		where mryymm = :li_ym and
					empno = :li_empno and
					mrlcode = :li_mrl and
					mrmcode = :li_mrm and
					mrscode = :li_mrs ;
					
		
		if rb_1.checked = true then //1차고자
	
			if ls_cnt = 0 or isnull(ls_cnt) then
				insert into p6_meritgrade (mryymm, empno, mrlcode, mrmcode, mrscode, grade1, dept_cd, levelcode, gradecode)
				values (:li_ym, :li_empno, :li_mrl, :li_mrm, :li_mrs, :li_grade, :li_deptcd, :li_levelcd, :li_gradecd) ;
	
			else
				update p6_meritgrade 
				set grade1 = :li_grade
				where mryymm = :li_ym and
						empno = :li_empno and
						mrlcode = :li_mrl and
						mrmcode = :li_mrm and
						mrscode = :li_mrs ;
			end if
			
		elseif rb_2.checked = true then//2차고과
			
			if ls_cnt = 0 or isnull(ls_cnt) then
				insert into p6_meritgrade (mryymm, empno, mrlcode, mrmcode, mrscode, grade2, dept_cd, levelcode)
				values (:li_ym, :li_empno, :li_mrl, :li_mrm, :li_mrs, :li_grade2, :li_levelcd, :li_gradecd) ;
	
			else
				update p6_meritgrade 
				set grade2 = :li_grade2
				where mryymm = :li_ym and
						empno = :li_empno and
						mrlcode = :li_mrl and
						mrmcode = :li_mrm and
						mrscode = :li_mrs ;
			end if
		end if
	next
	
end if

commit;

setpointer(arrow!)

w_mdi_frame.sle_msg.text = "저장되었습니다"
end event

type p_del from w_inherite_standard`p_del within w_psd1170
integer x = 3877
integer y = 2628
end type

type p_inq from w_inherite_standard`p_inq within w_psd1170
integer x = 3909
integer y = 28
end type

event p_inq::clicked;call super::clicked;rb_check()
end event

type p_print from w_inherite_standard`p_print within w_psd1170
integer x = 581
integer y = 2792
end type

type p_can from w_inherite_standard`p_can within w_psd1170
integer x = 4261
integer y = 28
end type

event p_can::clicked;call super::clicked;dw_list.reset()
dw_empno.reset()
dw_detail.reset()

wf_reset()
end event

type p_exit from w_inherite_standard`p_exit within w_psd1170
integer x = 4434
integer y = 28
end type

type p_ins from w_inherite_standard`p_ins within w_psd1170
integer x = 3703
integer y = 2616
end type

type p_search from w_inherite_standard`p_search within w_psd1170
integer x = 402
integer y = 2792
end type

type p_addrow from w_inherite_standard`p_addrow within w_psd1170
integer x = 1102
integer y = 2792
end type

type p_delrow from w_inherite_standard`p_delrow within w_psd1170
integer x = 1275
integer y = 2792
end type

type dw_insert from w_inherite_standard`dw_insert within w_psd1170
integer x = 50
integer y = 2852
end type

type st_window from w_inherite_standard`st_window within w_psd1170
integer x = 2171
integer y = 2592
long backcolor = 80269524
end type

type cb_exit from w_inherite_standard`cb_exit within w_psd1170
integer x = 1938
integer y = 2952
end type

type cb_update from w_inherite_standard`cb_update within w_psd1170
integer x = 1614
integer y = 2940
string pointer = "Cross!"
end type

event cb_update::clicked;call super::clicked;string li_ym, li_empno, li_mrl, li_mrm, li_mrs, li_grade, li_deptcd, li_levelcd,li_grade2,li_gradecd
long rowcount, li_curr, ls_cnt

if dw_ym.accepttext() = -1 then return -1
if dw_empno.accepttext() = -1 then return -1
if dw_detail.accepttext() = -1 then return -1

rowcount = dw_detail.rowcount()

li_ym = dw_ym.getitemstring(1,"ym")
li_empno = dw_empno.getitemstring(1,"p1_master_empno")
li_deptcd = dw_empno.getitemstring(1,"p0_dept_deptcode")
li_levelcd = dw_empno.getitemstring(1,"p1_master_levelcode")
li_gradecd = dw_empno.getitemstring(1,"p0_grade_gradecode")

if messagebox('확인','저장하시겠습니까?', question!, yesno!) = 1 then
	
	setpointer(hourglass!)
	for li_curr = 1 to rowcount 
		li_mrl = dw_detail.getitemstring(li_curr,"p6_meritperson_mrlcode")
		li_mrm = dw_detail.getitemstring(li_curr,"p6_meritperson_mrmcode")
		li_mrs = dw_detail.getitemstring(li_curr,"p6_meritperson_mrscode")
		li_grade = dw_detail.getitemstring(li_curr,"grade1")
		li_grade2 = dw_detail.getitemstring(li_curr,"a_grade2")
		
//		if (li_grade = "" or isnull(li_grade)) then
//			messagebox('확인','고과점수를 확인하세요')
//			dw_detail.setcolumn("grade1")
//			dw_detail.scrolltorow(li_curr)
//			dw_detail.setfocus()
//			return -1
//		end if	
					
		select count(*) into :ls_cnt 
		from p6_meritgrade
		where mryymm = :li_ym and
					empno = :li_empno and
					mrlcode = :li_mrl and
					mrmcode = :li_mrm and
					mrscode = :li_mrs ;
					
		
		if rb_1.checked = true then //1차고자
	
			if ls_cnt = 0 or isnull(ls_cnt) then
				insert into p6_meritgrade (mryymm, empno, mrlcode, mrmcode, mrscode, grade1, dept_cd, levelcode, gradecode)
				values (:li_ym, :li_empno, :li_mrl, :li_mrm, :li_mrs, :li_grade, :li_deptcd, :li_levelcd, :li_gradecd) ;
	
			else
				update p6_meritgrade 
				set grade1 = :li_grade
				where mryymm = :li_ym and
						empno = :li_empno and
						mrlcode = :li_mrl and
						mrmcode = :li_mrm and
						mrscode = :li_mrs ;
			end if
			
		elseif rb_2.checked = true then//2차고과
			
			if ls_cnt = 0 or isnull(ls_cnt) then
				insert into p6_meritgrade (mryymm, empno, mrlcode, mrmcode, mrscode, grade2, dept_cd, levelcode)
				values (:li_ym, :li_empno, :li_mrl, :li_mrm, :li_mrs, :li_grade2, :li_levelcd, :li_gradecd) ;
	
			else
				update p6_meritgrade 
				set grade2 = :li_grade2
				where mryymm = :li_ym and
						empno = :li_empno and
						mrlcode = :li_mrl and
						mrmcode = :li_mrm and
						mrscode = :li_mrs ;
			end if
		end if
	next
	
end if

commit;

setpointer(arrow!)

sle_msg.text = "저장되었습니다"
end event

type cb_insert from w_inherite_standard`cb_insert within w_psd1170
integer x = 997
integer y = 3172
end type

type cb_delete from w_inherite_standard`cb_delete within w_psd1170
integer x = 1381
integer y = 3172
end type

type cb_retrieve from w_inherite_standard`cb_retrieve within w_psd1170
integer x = 1339
integer y = 2956
end type

event cb_retrieve::clicked;call super::clicked;rb_check()
end event

type st_1 from w_inherite_standard`st_1 within w_psd1170
integer y = 2592
long backcolor = 80269524
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_psd1170
integer x = 2272
integer y = 2972
end type

event cb_cancel::clicked;call super::clicked;dw_list.reset()
dw_empno.reset()
dw_detail.reset()

wf_reset()
end event

type dw_datetime from w_inherite_standard`dw_datetime within w_psd1170
integer x = 2816
integer y = 2580
end type

type sle_msg from w_inherite_standard`sle_msg within w_psd1170
integer x = 334
integer y = 2592
long backcolor = 80269524
end type

type gb_2 from w_inherite_standard`gb_2 within w_psd1170
integer x = 2391
integer y = 2548
integer width = 1175
long backcolor = 80269524
end type

type gb_1 from w_inherite_standard`gb_1 within w_psd1170
integer x = 0
integer y = 2556
integer width = 416
long backcolor = 80269524
end type

type gb_10 from w_inherite_standard`gb_10 within w_psd1170
integer x = 3474
integer y = 2548
integer width = 3543
long backcolor = 80269524
end type

type rr_1 from roundrectangle within w_psd1170
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 37
integer y = 16
integer width = 3502
integer height = 288
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_list from datawindow within w_psd1170
integer x = 251
integer y = 528
integer width = 731
integer height = 1380
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_psd1170_list"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;string li_empno, li_ym
LONG ROWCOUNT

if dw_list.accepttext() = -1 then return -1

if row <= 0 then return -1

dw_list.selectrow(0,false)
dw_list.selectrow(row,true)

li_empno = dw_list.getitemstring(row,"p6_meritlevel_empno")
li_ym = dw_ym.getitemstring(1,"ym")

if f_datechk(li_ym+'01') = -1 then
	messagebox('확인','고과실사년월을 확인하세요')
	dw_ym.setcolumn("ym")
	dw_ym.setfocus()
	return -1
end if

dw_empno.retrieve(li_empno)
dw_detail.retrieve(li_empno, li_ym)
rowcount = dw_detail.rowcount()
dw_detail.SCROLLTOROW(ROWCOUNT)
end event

event itemerror;return 1
end event

type dw_detail from datawindow within w_psd1170
integer x = 1253
integer y = 528
integer width = 2734
integer height = 1228
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_psd1170_detail"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event rowfocuschanged;this.setrowfocusindicator(hand!)
end event

type dw_ym from datawindow within w_psd1170
integer x = 87
integer y = 56
integer width = 2446
integer height = 92
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_psd1170_ym"
boolean border = false
boolean livescroll = true
end type

event itemchanged;
if this.accepttext() = -1 then return -1

wf_reset()

dw_detail.reset()

end event

type dw_go from datawindow within w_psd1170
integer x = 210
integer y = 184
integer width = 1289
integer height = 80
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_psd1170_gogaja"
boolean border = false
boolean livescroll = true
end type

type st_2 from statictext within w_psd1170
integer x = 329
integer y = 424
integer width = 402
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "대상 피고과자"
boolean focusrectangle = false
end type

type rb_1 from radiobutton within w_psd1170
integer x = 1893
integer y = 184
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "1차고과"
boolean checked = true
end type

event clicked;cb_retrieve.triggerevent(clicked!)
end event

type rb_2 from radiobutton within w_psd1170
integer x = 2281
integer y = 184
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "2차고과"
end type

event clicked;cb_retrieve.triggerevent(clicked!)
end event

type dw_empno from datawindow within w_psd1170
integer x = 1221
integer y = 404
integer width = 2368
integer height = 108
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_psd1170_empno"
boolean border = false
boolean livescroll = true
end type

type st_3 from statictext within w_psd1170
integer x = 1659
integer y = 184
integer width = 192
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "조 건"
boolean focusrectangle = false
end type

type rr_2 from roundrectangle within w_psd1170
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 41
integer y = 332
integer width = 1038
integer height = 1908
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_psd1170
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 1115
integer y = 336
integer width = 3451
integer height = 1908
integer cornerheight = 40
integer cornerwidth = 55
end type

