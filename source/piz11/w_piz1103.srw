$PBExportHeader$w_piz1103.srw
$PBExportComments$직책별 사원조회
forward
global type w_piz1103 from w_inherite_standard
end type
type st_2 from statictext within w_piz1103
end type
type st_dept from statictext within w_piz1103
end type
type rr_2 from roundrectangle within w_piz1103
end type
type dw_1 from u_d_select_sort within w_piz1103
end type
end forward

global type w_piz1103 from w_inherite_standard
integer x = 786
integer y = 452
integer width = 2866
integer height = 1648
string title = "부서별 사원 조회 "
string menuname = ""
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_2 st_2
st_dept st_dept
rr_2 rr_2
dw_1 dw_1
end type
global w_piz1103 w_piz1103

type variables
st_codnm           ist_dept
end variables

event open;call super::open;f_window_center_response(this)
dw_1.SetTransObject(SQLCA)

ist_dept = message.powerobjectparm

st_dept.text = st_dept.text + ist_dept.name


dw_1.retrieve(gs_company, ist_dept.dd, ist_dept.code)
end event

on w_piz1103.create
int iCurrent
call super::create
this.st_2=create st_2
this.st_dept=create st_dept
this.rr_2=create rr_2
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.st_dept
this.Control[iCurrent+3]=this.rr_2
this.Control[iCurrent+4]=this.dw_1
end on

on w_piz1103.destroy
call super::destroy
destroy(this.st_2)
destroy(this.st_dept)
destroy(this.rr_2)
destroy(this.dw_1)
end on

type p_mod from w_inherite_standard`p_mod within w_piz1103
boolean visible = false
integer x = 2537
integer y = 2380
end type

type p_del from w_inherite_standard`p_del within w_piz1103
boolean visible = false
integer x = 2711
integer y = 2380
end type

type p_inq from w_inherite_standard`p_inq within w_piz1103
boolean visible = false
integer x = 1842
integer y = 2380
end type

type p_print from w_inherite_standard`p_print within w_piz1103
boolean visible = false
integer x = 1669
integer y = 2380
end type

type p_can from w_inherite_standard`p_can within w_piz1103
boolean visible = false
integer x = 2885
integer y = 2380
end type

type p_exit from w_inherite_standard`p_exit within w_piz1103
integer x = 2651
integer y = 20
end type

type p_ins from w_inherite_standard`p_ins within w_piz1103
boolean visible = false
integer x = 2016
integer y = 2380
end type

type p_search from w_inherite_standard`p_search within w_piz1103
boolean visible = false
integer x = 1490
integer y = 2380
end type

type p_addrow from w_inherite_standard`p_addrow within w_piz1103
boolean visible = false
integer x = 2190
integer y = 2380
end type

type p_delrow from w_inherite_standard`p_delrow within w_piz1103
boolean visible = false
integer x = 2363
integer y = 2380
end type

type dw_insert from w_inherite_standard`dw_insert within w_piz1103
boolean visible = false
integer x = 1230
integer y = 2376
end type

type st_window from w_inherite_standard`st_window within w_piz1103
boolean visible = false
end type

type cb_exit from w_inherite_standard`cb_exit within w_piz1103
boolean visible = false
end type

type cb_update from w_inherite_standard`cb_update within w_piz1103
boolean visible = false
end type

type cb_insert from w_inherite_standard`cb_insert within w_piz1103
boolean visible = false
end type

type cb_delete from w_inherite_standard`cb_delete within w_piz1103
boolean visible = false
end type

type cb_retrieve from w_inherite_standard`cb_retrieve within w_piz1103
boolean visible = false
end type

type st_1 from w_inherite_standard`st_1 within w_piz1103
boolean visible = false
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_piz1103
boolean visible = false
end type

type dw_datetime from w_inherite_standard`dw_datetime within w_piz1103
boolean visible = false
end type

type sle_msg from w_inherite_standard`sle_msg within w_piz1103
boolean visible = false
end type

type gb_2 from w_inherite_standard`gb_2 within w_piz1103
boolean visible = false
end type

type gb_1 from w_inherite_standard`gb_1 within w_piz1103
boolean visible = false
end type

type gb_10 from w_inherite_standard`gb_10 within w_piz1103
boolean visible = false
end type

type st_2 from statictext within w_piz1103
integer x = 1435
integer y = 96
integer width = 1221
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388736
long backcolor = 32106727
boolean enabled = false
string text = "해당사원 개인정보 조회 : double click!"
boolean focusrectangle = false
end type

type st_dept from statictext within w_piz1103
integer x = 46
integer y = 92
integer width = 987
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean enabled = false
string text = "직책 : "
boolean focusrectangle = false
end type

type rr_2 from roundrectangle within w_piz1103
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer y = 168
integer width = 2848
integer height = 1380
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_1 from u_d_select_sort within w_piz1103
integer x = 9
integer y = 172
integer width = 2825
integer height = 1360
integer taborder = 11
string dataobject = "d_piz1103"
boolean hscrollbar = false
boolean border = false
end type

event doubleclicked;call super::doubleclicked;string lk_empno
//long ll_row1

if row <= 0 Then return

this.SelectRow(0,False)
this.SelectRow(row ,True)

//ll_row1 = dw_1.getrow()

if  row > 0  then
    lk_empno = dw_1.getitemstring(row, "empno")
	  
	 Openwithparm(w_piz1105, lk_empno)
end if	 
end event

event clicked;call super::clicked;string objname, obj

this.accepttext()
obj = getobjectatpointer()
objname = f_get_token(obj, '~t')
choose case objname
			case 'empno_t'
				setsort('#3 a')
				sort()
			case 'empname_t'
				setsort('#2 a')
				sort()
			case 'deptname_t'
				setsort('#11 a')
				sort()
			case 'jobkindcode_t'
				setsort('#6 a')
				sort()		
			case 'p1_master_enterdate_t'
				setsort('#8 a')
				sort()
			case 'p1_master_birthday_t'
				setsort('#7 a')
				sort()
end choose
end event

