$PBExportHeader$w_psd3002.srw
$PBExportComments$파일/디스켓 등록
forward
global type w_psd3002 from w_inherite_standard
end type
type rr_1 from roundrectangle within w_psd3002
end type
type dw_sub1 from datawindow within w_psd3002
end type
type dw_sub2 from datawindow within w_psd3002
end type
type st_2 from statictext within w_psd3002
end type
type em_1 from editmask within w_psd3002
end type
type st_3 from statictext within w_psd3002
end type
type em_2 from editmask within w_psd3002
end type
type dw_list from datawindow within w_psd3002
end type
type dw_detail from datawindow within w_psd3002
end type
type dw_sub3 from datawindow within w_psd3002
end type
type rr_2 from roundrectangle within w_psd3002
end type
type rr_3 from roundrectangle within w_psd3002
end type
end forward

global type w_psd3002 from w_inherite_standard
string title = "File/Diskett 등록"
string menuname = "m_class"
boolean resizable = false
rr_1 rr_1
dw_sub1 dw_sub1
dw_sub2 dw_sub2
st_2 st_2
em_1 em_1
st_3 st_3
em_2 em_2
dw_list dw_list
dw_detail dw_detail
dw_sub3 dw_sub3
rr_2 rr_2
rr_3 rr_3
end type
global w_psd3002 w_psd3002

type variables
datawindowchild idwc_1, idwc_2
boolean ib_chk
end variables

forward prototypes
public subroutine wf_init ()
public function integer wf_required_chk ()
public function string wf_setcode (string arg_cod)
end prototypes

public subroutine wf_init ();
dw_sub2.SetRedraw(false)
//ib_any_typing = FALSE

dw_sub1.reset()
dw_sub2.reset()
dw_sub3.reset()
dw_detail.reset()

dw_sub1.insertrow(0)
dw_sub2.insertrow(0)
dw_sub3.insertrow(0)
p_ins.triggerevent(clicked!)

dw_sub1.SetColumn("dept")
dw_sub1.SetFocus()

//
dw_sub2.SetRedraw(true)
dw_sub3.SetRedraw(true)
dw_sub1.enabled = true
dw_detail.enabled = true
end subroutine

public function integer wf_required_chk ();string ls_data1, ls_data2, ls_data3
long ll_no

ls_data1 = dw_detail.GetItemString(dw_detail.GetRow(),'sdate')
ls_data2 = dw_detail.GetItemString(dw_detail.GetRow(),'deptcode')
ls_data3 = dw_sub3.GetItemString(dw_sub3.GetRow(),'gbn')
ll_no = dw_detail.GetItemNumber(dw_detail.GetRow(),'fileno')

if ls_data1 = '' or isNull(ls_data1) then
	messagebox('확인','작성일자를 입력하세요.',Exclamation!)
	dw_detail.SetColumn('sdate')
	dw_detail.SetFocus()
	return -1
end if

if ls_data2 = '' or isNull(ls_data2) then
	messagebox('확인','부서코드를 입력하세요.',Exclamation!)
	dw_detail.SetColumn('deptcode')
	dw_detail.SetFocus()
	return -1
end if

if ls_data3 = '' or isNull(ls_data3) then
	messagebox('확인','분류코드를 입력하세요.',Exclamation!)
	dw_sub3.SetColumn('gbn')
	dw_sub3.SetFocus()
	return -1
end if

if string(ll_no) = '' or isNull(string(ll_no)) then
	messagebox('확인','파일번호를 입력하세요.',Exclamation!)
	dw_detail.SetColumn('fileno')
	dw_detail.SetFocus()
	return -1
end if

return 1
end function

public function string wf_setcode (string arg_cod);if long(arg_cod) < 10 then
	return '00' + arg_cod
elseif long(arg_cod) < 100 then
	return '0' + arg_cod
else
	return arg_cod
end if
end function

event open;call super::open;ib_chk = true

dw_list.settransobject(sqlca)
dw_datetime.settransobject(sqlca)
dw_detail.settransobject(sqlca)
dw_sub1.settransobject(sqlca)

dw_sub2.getchild('gbn',idwc_1)
idwc_1.settransobject(sqlca)

dw_sub3.getchild('gbn',idwc_2)
idwc_2.settransobject(sqlca)

wf_init()

em_1.text = string(today(),'yyyy/01/01')
em_2.text = string(today())
end event

on w_psd3002.create
int iCurrent
call super::create
if IsValid(this.MenuID) then destroy(this.MenuID)
if this.MenuName = "m_class" then this.MenuID = create m_class
this.rr_1=create rr_1
this.dw_sub1=create dw_sub1
this.dw_sub2=create dw_sub2
this.st_2=create st_2
this.em_1=create em_1
this.st_3=create st_3
this.em_2=create em_2
this.dw_list=create dw_list
this.dw_detail=create dw_detail
this.dw_sub3=create dw_sub3
this.rr_2=create rr_2
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.dw_sub1
this.Control[iCurrent+3]=this.dw_sub2
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.em_1
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.em_2
this.Control[iCurrent+8]=this.dw_list
this.Control[iCurrent+9]=this.dw_detail
this.Control[iCurrent+10]=this.dw_sub3
this.Control[iCurrent+11]=this.rr_2
this.Control[iCurrent+12]=this.rr_3
end on

on w_psd3002.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.dw_sub1)
destroy(this.dw_sub2)
destroy(this.st_2)
destroy(this.em_1)
destroy(this.st_3)
destroy(this.em_2)
destroy(this.dw_list)
destroy(this.dw_detail)
destroy(this.dw_sub3)
destroy(this.rr_2)
destroy(this.rr_3)
end on

type p_mod from w_inherite_standard`p_mod within w_psd3002
end type

event p_mod::clicked;call super::clicked;if dw_detail.AcceptText() = -1 then return
if wf_required_chk() = -1 then return
string ls_filecode, ls_year, ls_gbn, ls_ndate, ls_kdate, ls_jdate, ls_kgbn, ls_jgbn
long fileno, volno, row

row = dw_detail.getrow()
ls_year = mid(dw_detail.getitemstring(row,'sdate'),3,2)
ls_gbn  = dw_sub3.getitemstring(dw_sub3.getrow(),'gbn')
fileno  = dw_detail.getitemnumber(row,'fileno')
volno   = dw_detail.getitemnumber(row,'volno')

ls_filecode = ls_gbn + wf_setcode(string(fileno)) + ls_year + wf_setcode(string(volno))
dw_detail.setitem(row,'filecode',ls_filecode)
dw_detail.setitem(row,'lmgbn', ls_gbn)

if dw_detail.update() = -1 then
	sle_msg.text = '저장 실패...!'
	return 
else
	sle_msg.text = '저장 완료...!'
end if

ls_ndate = dw_detail.GetItemString(dw_detail.GetRow(), 'sdate')
ls_kdate = dw_detail.GetItemString(dw_detail.GetRow(), 'kdate')
ls_jdate = dw_detail.GetItemString(dw_detail.GetRow(), 'jdate')
ls_kgbn  = dw_detail.GetItemString(dw_detail.GetRow(), 'kwanflag')
ls_jgbn  = dw_detail.GetItemString(dw_detail.GetRow(), 'jonflag')
string ls_dept
ls_dept = dw_detail.getitemstring(dw_detail.getrow(),'deptcode')

if ls_ndate < ls_kdate then
	Choose Case ls_kgbn
		Case '1'
			Update p8_filesysdata
			   set status = '2'
			 where deptcode = :ls_dept and
			       sdate    = :ls_ndate and
					 fileno   = :fileno  and
					 volno    = :volno   and
					 lmgbn    = :ls_gbn;
		Case '2'
			Update p8_filesysdata
			   set status = '3'
			 where deptcode = :ls_dept and
			       sdate    = :ls_ndate and
					 fileno   = :fileno  and
					 volno    = :volno   and
					 lmgbn    = :ls_gbn;
	End Choose
end if
if ls_ndate < ls_jdate then
	Choose Case ls_jgbn
		Case '1'
			Update p8_filesysdata
				set status = '2'
			 where deptcode = :ls_dept and
					 sdate    = :ls_ndate and
					 fileno   = :fileno  and
					 volno    = :volno   and
					 lmgbn    = :ls_gbn;
		Case '2'
			Update p8_filesysdata
				set status = '3'
			 where deptcode = :ls_dept and
					 sdate    = :ls_ndate and
					 fileno   = :fileno  and
					 volno    = :volno   and
					 lmgbn    = :ls_gbn;
		End Choose

end if

commit;
ib_chk = true
dw_sub1.setitem(1,'dept',ls_dept)
dw_sub2.setitem(1,'gbn',ls_gbn)

p_inq.TriggerEvent(Clicked!)
end event

type p_del from w_inherite_standard`p_del within w_psd3002
end type

event p_del::clicked;call super::clicked;if dw_list.RowCount() < 1 then return

long chk

chk = messagebox('확인','선택하신 항목을 삭제하시겠습니까?',exclamation!,okcancel!,2)

if chk = 1 then
	string ls_fcod
	ls_fcod = dw_list.getitemstring(dw_list.getrow(),'filecode')
		
	delete from p8_filesysdata
	 where filecode = :ls_fcod;
	commit;
	dw_list.deleterow(0)
	dw_detail.reset()
	dw_sub2.reset()
	dw_detail.InsertRow(0)
	ib_chk = false


else
	return
end if

p_can.TriggerEvent(Clicked!)
end event

type p_inq from w_inherite_standard`p_inq within w_psd3002
integer x = 3515
end type

event p_inq::clicked;call super::clicked;ib_chk = true

string ls_dept, ls_gbn, ls_sdate, ls_edate, snull
long row1, row2
Setnull(snull)

if em_1.text > em_2.text then
		messagebox('확인','기간 범위가 잘못입력되었습니다.',exclamation!)
		em_1.setfocus()
	   return
end if

IF f_datechk(em_1.text) = -1 THEN	
		MessageBox("확 인", "작성일자를 확인하세요.")
		em_1.setfocus()
		Return 1
END IF

IF f_datechk(em_2.text) = -1 THEN	
		MessageBox("확 인", "작성일자를 확인하세요.")
		em_2.setfocus()
		Return 1
END IF 


dw_sub1.accepttext()
dw_sub2.accepttext()

row1 = dw_sub1.getrow()
row2 = dw_sub2.getrow()

ls_dept  = dw_sub1.getitemstring(row1,'dept')
ls_gbn   = dw_sub2.getitemstring(row2,'gbn')

ls_sdate = left(em_1.text,4) + mid(em_1.text,6,2) + right(em_1.text,2)
ls_edate = left(em_2.text,4) + mid(em_2.text,6,2) + right(em_2.text,2)

if ls_dept = '' or isNull(ls_dept) then ls_dept = '%'
if ls_gbn  = '' or isNull(ls_gbn)  then ls_gbn  = '%'

if dw_list.retrieve(ls_dept,ls_gbn,ls_sdate,ls_edate) < 1 then
	messagebox("확인","조회할 자료가 없습니다!")
	dw_detail.reset()
	em_1.setfocus()
	return
end if
dw_list.setFocus()


end event

type p_print from w_inherite_standard`p_print within w_psd3002
boolean visible = false
integer x = 539
integer y = 2328
boolean enabled = false
end type

type p_can from w_inherite_standard`p_can within w_psd3002
end type

event p_can::clicked;call super::clicked;ib_chk = true
wf_init()
end event

type p_exit from w_inherite_standard`p_exit within w_psd3002
end type

type p_ins from w_inherite_standard`p_ins within w_psd3002
integer x = 3689
end type

event p_ins::clicked;call super::clicked;dw_detail.object.t_s1.text = ''
dw_detail.object.t_s2.text = ''
dw_detail.object.t_s3.text = ''

long row, dbrow

dw_sub3.Reset()
dw_sub3.InsertRow(0)
dw_detail.scrolltorow(dw_detail.insertrow(0))
dw_detail.setFocus()
dw_detail.setColumn('sdate')
row = dw_detail.getrow()

dw_detail.setitem(dw_detail.Getrow(),'sdate',string(today(),'yyyymmdd'))
dw_detail.setitem(dw_detail.Getrow(),'filejong','F')
dw_detail.setitem(dw_detail.Getrow(),'kwanyyyy', &
                  left(dw_detail.getItemString(dw_detail.GetRow(),'sdate'),4))
dw_detail.setitem(dw_detail.Getrow(),'delyyyy', &
                  left(dw_detail.getItemString(dw_detail.GetRow(),'sdate'),4))						

select count(fileno) into :dbrow from p8_filesysdata;

if dbrow < 1 then
	dw_detail.setitem(row,'fileno',1)
	dw_detail.setitem(row,'volno',1)	
end if

dw_detail.setTaborder('sdate',10)
dw_detail.setTaborder('deptcode',20)
dw_detail.setTaborder('fileno',40)
dw_sub3.setTaborder('gbn',10)
dw_detail.settaborder('kwanflag',170)
dw_detail.settaborder('kdate',180)
dw_detail.settaborder('sawon2',190)
dw_detail.settaborder('jonloc1',200)
dw_detail.settaborder(23,210)
dw_detail.settaborder('jonflag',220)
dw_detail.settaborder('jdate',230)
dw_detail.settaborder('sawon3',240)
dw_detail.setitem(dw_detail.getrow(),'status','1')
end event

type p_search from w_inherite_standard`p_search within w_psd3002
boolean visible = false
integer x = 361
integer y = 2328
boolean enabled = false
end type

type p_addrow from w_inherite_standard`p_addrow within w_psd3002
boolean visible = false
integer x = 722
integer y = 2340
boolean enabled = false
end type

type p_delrow from w_inherite_standard`p_delrow within w_psd3002
boolean visible = false
integer x = 905
integer y = 2340
boolean enabled = false
end type

type dw_insert from w_inherite_standard`dw_insert within w_psd3002
boolean visible = false
integer y = 2328
boolean enabled = false
end type

type st_window from w_inherite_standard`st_window within w_psd3002
end type

type cb_exit from w_inherite_standard`cb_exit within w_psd3002
end type

type cb_update from w_inherite_standard`cb_update within w_psd3002
end type

type cb_insert from w_inherite_standard`cb_insert within w_psd3002
end type

type cb_delete from w_inherite_standard`cb_delete within w_psd3002
end type

type cb_retrieve from w_inherite_standard`cb_retrieve within w_psd3002
end type

type st_1 from w_inherite_standard`st_1 within w_psd3002
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_psd3002
end type

type dw_datetime from w_inherite_standard`dw_datetime within w_psd3002
end type

type sle_msg from w_inherite_standard`sle_msg within w_psd3002
end type

type gb_2 from w_inherite_standard`gb_2 within w_psd3002
end type

type gb_1 from w_inherite_standard`gb_1 within w_psd3002
end type

type gb_10 from w_inherite_standard`gb_10 within w_psd3002
end type

type rr_1 from roundrectangle within w_psd3002
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 658
integer y = 24
integer width = 1344
integer height = 312
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_sub1 from datawindow within w_psd3002
integer x = 667
integer y = 44
integer width = 1317
integer height = 76
integer taborder = 90
boolean bringtotop = true
string title = "none"
string dataobject = "d_psd3002_03"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;string sgrpno

if idwc_1.retrieve(data) < 1 then 
	idwc_1.reset()
	idwc_1.insertrow(0)
end if	
dw_sub2.setitem(1, 'gbn', '' )

dw_sub1.accepttext()

sgrpno = dw_sub1.getitemstring(1,1) + '%'

datawindowchild sidws

dw_detail.getchild('gbn',sidws)
sidws.settransobject(sqlca)
sidws.retrieve(sgrpno)
end event

type dw_sub2 from datawindow within w_psd3002
integer x = 667
integer y = 128
integer width = 1285
integer height = 88
integer taborder = 120
boolean bringtotop = true
string title = "none"
string dataobject = "d_psd3002_04"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event dberror;return 1
end event

event itemchanged;if getcolumnname() = 'dept' then
	
	String sNull
	
	datawindowchild dws
	dw_detail.getchild("gbn", dws)
	dws.settransobject(sqlca)
	dws.retrieve(data)	
	
	Setnull(sNull)
	setitem(1, "gbn", sNull)
end if
end event

event itemerror;return 1
end event

type st_2 from statictext within w_psd3002
integer x = 681
integer y = 248
integer width = 256
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "작성일자"
boolean focusrectangle = false
end type

type em_1 from editmask within w_psd3002
integer x = 997
integer y = 240
integer width = 402
integer height = 64
integer taborder = 130
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "none"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "yyyy.mm.dd"
boolean autoskip = true
end type

type st_3 from statictext within w_psd3002
integer x = 1431
integer y = 252
integer width = 59
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "-"
alignment alignment = center!
boolean focusrectangle = false
end type

type em_2 from editmask within w_psd3002
event ue_enter2 pbm_keydown
integer x = 1518
integer y = 240
integer width = 398
integer height = 68
integer taborder = 140
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
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "yyyy.mm.dd"
end type

event ue_enter2;if keydown(keyenter!) then
	p_inq.TriggerEvent(clicked!)
end if
end event

type dw_list from datawindow within w_psd3002
integer x = 672
integer y = 404
integer width = 1417
integer height = 1768
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_psd3002_01"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event clicked;If Row <= 0 then
	dw_list.SelectRow(0,False)


ELSE
	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	long lfile, lvol
string ls_color, ls_dept, ls_gbn, sdept, sdate, smgbn

sdate = this.getitemString(Row,'sdate')
sdept = this.getitemString(Row,'deptcode')
smgbn = this.getitemString(Row,'lmgbn')
lfile = this.getitemnumber(Row,'fileno')
lvol  = this.getitemnumber(Row,'volno')

dw_detail.retrieve(sdate,sdept, smgbn,lfile,lvol)

//ls_dept = dw_detail.getitemstring(dw_detail.getrow(),'deptcode')
//ls_gbn  = dw_detail.getitemstring(dw_detail.getrow(),'lmgbn')
//
select color into :ls_color
  from  p8_filesyscode
 where deptcode = :sdept
   and lmgbn    = :smgbn;

dw_detail.setitem(dw_detail.getrow(),'color',ls_color)
dw_sub3.setitem(dw_sub3.getrow(),'gbn',smgbn)

dw_detail.setTaborder('sdate',0)
dw_detail.setTaborder('deptcode',0)
dw_detail.setTaborder('fileno',0)
dw_sub3.setTaborder('gbn',0)
END IF

//Long ll_row
//
//ll_row = this.RowCount()
//
//if ll_row <= 1 then return
//if this.GetRow() > this.RowCount() then return


end event

event itemerror;return 1
end event

event rowfocuschanged;//Long ll_row
//
//ll_row = this.RowCount()
//
//if ll_row <= 1 then return
//if this.GetRow() > this.RowCount() then return
//
//this.selectrow(0,false)
//this.selectrow(this.GetRow(),true)
//
//long lfile, lvol
//string ls_color, ls_dept, ls_gbn
//
//lfile = this.getitemnumber(this.GetRow(),'fileno')
//lvol  = this.getitemnumber(this.GetRow(),'volno')
//
//dw_detail.retrieve(lfile,lvol)
//
//ls_dept = dw_detail.getitemstring(dw_detail.getrow(),'deptcode')
//ls_gbn  = dw_detail.getitemstring(dw_detail.getrow(),'lmgbn')
//
//select color into :ls_color
//  from  p8_filesyscode
// where deptcode = :ls_dept
//   and lmgbn    = :ls_gbn;
//
//dw_detail.setitem(dw_detail.getrow(),'color',ls_color)
//dw_sub3.setitem(dw_sub3.getrow(),'gbn',ls_gbn)
//
//dw_detail.setTaborder('sdate',0)
//dw_detail.setTaborder('deptcode',0)
//dw_detail.setTaborder('fileno',0)
//dw_sub3.setTaborder('gbn',0)
end event

type dw_detail from datawindow within w_psd3002
event ue_enterkey pbm_dwnprocessenter
event ue_f1 pbm_dwnkey
integer x = 2240
integer y = 380
integer width = 2057
integer height = 1768
integer taborder = 70
boolean bringtotop = true
string title = "none"
string dataobject = "d_psd3002_02"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_enterkey;IF this.getcolumnname() = 'deptcode' then
	dw_sub3.setFocus()
	dw_sub3.setColumn('gbn')
else
	send(handle(this),256,9,0)
	return 1
end if
end event

event ue_f1;if keydown(keyF1!) then
	this.TriggerEvent(RbuttonDown!)
end if
end event

event dberror;//return 1
end event

event itemchanged;string ls_no,ls_name,ls_gbn,ls_code,ls_color, ls_data, ls_tmp1, ls_tmp2
long cnt,fileno, volno, year
string snull, ls_mgbn, ls_sname
setnull(snull)

this.accepttext()

choose case this.getcolumnname()
	case 'sawon1'
		this.accepttext()
		ls_no = this.getitemstring(row,'sawon1')
		select empname,count(*) into :ls_name, :cnt
		  from p1_master
		 where empno = :ls_no
		 group by empname;
		 
		if cnt < 1 then
			messagebox('확인','입력하신 사번으로 등록된 사원이 없습니다.',stopsign!)
			this.setitem(row,'sawon1','')
			this.object.t_s1.text = ''
			this.setcolumn('sawon1')
			return 1
		else
			this.object.t_s1.text = ls_name
		end if
		
	case 'sawon2'
		this.accepttext()
		ls_no = this.getitemstring(row,'sawon2')
		select empname,count(*) into :ls_name, :cnt
		  from p1_master
		 where empno = :ls_no 
		 group by empname;
		 
		if cnt < 1 then
			messagebox('확인','입력하신 사번으로 등록된 사원이 없습니다.',stopsign!)
			this.setitem(row,'sawon2','')
			this.object.t_s2.text = ''
			this.setcolumn('sawon2')
			return 1
		else
			this.object.t_s2.text = ls_name
		end if
		
	case 'sawon3'
		this.accepttext()
		ls_no = this.getitemstring(row,'sawon3')
		select empname,count(*) into :ls_name, :cnt
		  from p1_master
    	 where empno = :ls_no
		 group by empname;
		 
		if cnt < 1 then
			messagebox('확인','입력하신 사번으로 등록된 사원이 없습니다.',stopsign!)
			this.setitem(row,'sawon3','')
			this.object.t_s3.text = ''
			this.setcolumn('sawon3')
			return 1
		else
			this.object.t_s3.text = ls_name
		end if
		
	case 'deptcode'
		string sgrpno
		if idwc_2.retrieve(data) < 1 then 
			idwc_2.reset()
			idwc_2.insertrow(0)
		end if	
		dw_sub3.setitem(1, 'gbn', '' )
		dw_detail.accepttext()
      sgrpno = dw_detail.getitemstring(row,'deptcode')

      datawindowchild sidws
      dw_detail.getchild('gbn',sidws)
		sidws.settransobject(sqlca)
		sidws.retrieve(sgrpno)		
		
	case 'kwanyy'
		year = long(GetText())
		if year = 88 or year = 99 then
			this.settaborder('kwanflag',0)
			this.settaborder('kdate',0)
			this.settaborder('sawon2',0)
			this.settaborder('jonloc1',0)
			this.settaborder( 23 ,0)                // jonloc2
			this.settaborder('jonflag',0)
			this.settaborder('jdate',0)
			this.settaborder('sawon3',0)
			this.Settaborder('jonyy',0)
			sle_msg.text = '경과후 처리내역은 입력하실수 없습니다.'
			this.setItem(this.GetRow(), 'kwanflag', '')
			this.setItem(this.GetRow(), 'jonflag',  '')
			this.setItem(this.GetRow(), 'sawon2',   '')
			this.setItem(this.GetRow(), 'sawon3',   '')
			this.setItem(this.GetRow(), 'kdate',    '')
			this.setItem(this.GetRow(), 'jdate',    '')
			this.setItem(this.GetRow(), 'jonloc2',  '')
			this.SetItem(this.GetRow(), 'jonyy', 0)
			this.SetItem(this.GetRow(), 'kwanyyyy', '')
			this.SetItem(this.GetRow(), 'delyyyy', '')			
		else
			ls_tmp1 = left(this.GetItemString(this.GetRow(),'sdate'),4)
			ls_tmp2 = string(this.GetItemNumber(this.GetRow(),'jonyy'))
			if IsNull(ls_tmp2) or ls_tmp2 = '' then ls_tmp2 = '0'
			
			if ls_tmp2 <> '99' and ls_tmp2 <> '88' then
				this.settaborder('kwanflag',170)
				this.settaborder('kdate',180)
				this.settaborder('sawon2',190)
				this.settaborder(23 ,210)               // jonloc2
				this.settaborder('jonflag',220)
				this.settaborder('jdate',230)
				this.settaborder('sawon3',240)
				this.Settaborder('jonyy',90)
				sle_msg.text = ''
			end if
			
			if ls_tmp2 <> '99' and ls_tmp2 <> '88' then
				this.SetItem(this.GetRow(),'kwanyyyy', &
			             string(long(ls_tmp1) + year + 1))
    			this.SetItem(this.GetRow(),'delyyyy', &
			             string(long(ls_tmp1) + year + long(ls_tmp2) + 1))
							 
            if ls_tmp2 = '0' and year = 0 then
					this.Setitem(this.Getrow(),'kwanyyyy',snull)
				end if							 
			else
				this.SetItem(this.GetRow(),'kwanyyyy', &
			             string(long(ls_tmp1) + year + 1))
    			
			end if
         							 
		end if
	
	case 'jonyy'
		year = long(GetText())
		ls_tmp2 = string(this.GetItemNumber(this.GetRow(),'kwanyy'))
		if IsNull(ls_tmp2) or ls_tmp2 = '' then ls_tmp2 = '0'
		if year = 88 or year = 99 then			
			this.settaborder('kwanflag',0)
			this.settaborder('kdate',0)
			this.settaborder('sawon2',0)
			this.settaborder(23,0)                    // jonloc2
			this.settaborder('jonflag',0)
			this.settaborder('jdate',0)
			this.settaborder('sawon3',0)
			sle_msg.text = '경과후 처리내역은 입력하실수 없습니다.'
			this.setItem(this.GetRow(), 'kwanflag', '')
			this.setItem(this.GetRow(), 'sawon2',   '')
			this.setItem(this.GetRow(), 'kdate',    '')
   		this.setItem(this.GetRow(), 'jonloc1',  '')
			this.setItem(this.GetRow(), 'jonloc2',  '')
			this.SetItem(this.GetRow(), 'kwanyyyy', '')
			if ls_tmp2 = '88' or ls_tmp2 = '99' then 
				this.SetItem(this.GetRow(), 'delyyyy', '')
			end if

		else
			this.settaborder('kwanflag',170)
			this.settaborder('kdate',180)
			this.settaborder('sawon2',190)
			this.settaborder('jonloc2',210)    // jonloc2
			this.settaborder('jonflag',220)
			this.settaborder('jdate',230)
			this.settaborder('sawon3',240)
			sle_msg.text = ''
			ls_tmp1 = left(this.GetItemString(this.GetRow(),'sdate'),4)
			if ls_tmp2 = '99' or ls_tmp2 = '88' then
				this.SetItem(this.GetRow(),'delyyyy', &
			             string(long(ls_tmp1) + year + 1))
			else
				this.SetItem(this.GetRow(),'delyyyy', &
			             string(long(ls_tmp1) + year + long(ls_tmp2) + 1))
							 
				this.SetItem(this.GetRow(),'kwanyyyy', &
			             string(long(ls_tmp1) + long(ls_tmp2) + 1))			 
			   if ls_tmp2 = '0' and year = 0 then
					this.Setitem(this.Getrow(),'kwanyyyy',snull)
				end if
			end if
		end if
	
   case 'filename'
		fileno = this.getitemnumber(row,'fileno')
		sgrpno = this.getitemstring(row,'deptcode') 
		ls_data = this.getitemstring(row,'sdate') 
		ls_mgbn = this.getitemstring(row,'lmgbn') 
		ls_sname = this.getitemstring(row,'filename') 
		
		
		select count(volno) into :cnt from p8_filesysdata
		 where sdate = :ls_data and deptcode = :sgrpno and
		       lmgbn = :ls_mgbn and fileno = :fileno and 
				  filename = :ls_sname;
				 
		
		if sqlca.sqlcode <> 0 or cnt < 1 then
			this.setitem(row,'volno',1)
		else
			select max(volno) into :cnt from p8_filesysdata
		 where sdate = :ls_data and deptcode = :sgrpno and
		       lmgbn = :ls_mgbn and fileno = :fileno and 
  			    filename = :ls_sname;
				 
			this.setitem(row,'volno',cnt + 1)			 
		end if
		
	case 'kwanflag'
		ls_data = GetText()
		if ls_data <> '' and isnull(ls_data) = false then
			this.SetItem(this.Getrow(),'jonloc1', 'R')
		else
			this.SetItem(this.Getrow(),'jonloc1', '')
		end if
		
	case 'sdate'
		ls_data = left(this.GetText(),4)
		if this.GetItemNumber(this.GetRow(),'kwanyy') = 99 or &
		   this.GetItemNumber(this.GetRow(),'kwanyy') = 88 then
			
			this.SetItem(this.GetRow(),'kwanyyyy','')
			this.SetItem(this.GetRow(),'delyyyy','')
		else
			ls_tmp1 = string(this.GetItemNumber(this.GetRow(),'kwanyy'))
			ls_tmp2 = string(this.GetItemNumber(this.GetRow(),'jonyy'))
			this.SetItem(this.GetRow(),'kwanyyyy', string(long(ls_data) + long(ls_tmp1) + 1))
			this.SetItem(this.GetRow(),'delyyyy', &
			             string(long(ls_data) + long(ls_tmp1) + long(ls_tmp2) + 1))
		end if
			
		
end choose
end event

event itemerror;return 1
end event

event rbuttondown;if this.getcolumnname() = 'sawon1'then
	open(w_employee_popup)
	if gs_code = '' or isNull(gs_code) then 
		this.modify("t_s1.text = " )
		return 1
	end if
   this.setitem(1,'sawon1',gs_code)
	this.modify("t_s1.text = '" + gs_codename + "'" )
	
elseif this.getcolumnname() = 'sawon2'then
	open(w_employee_popup)
	if gs_code = '' or isNull(gs_code) then 
		this.object.t_s2.text = ''
		return 1
	end if		
   this.setitem(1,'sawon2',gs_code)
	this.object.t_s2.text = gs_codename

elseif this.getcolumnname() = 'sawon3'then
	open(w_employee_popup)
	if gs_code = '' or isNull(gs_code) then 
		this.object.t_s3.text = ''
		return 1
	end if
   this.setitem(1,'sawon3',gs_code)
	this.object.t_s3.text = gs_codename
end if
end event

event retrieveend;string ls_s1, ls_s2, ls_s3, ls_n1, ls_n2, ls_n3
long year1, year2 

this.accepttext()

ls_s1 = this.getitemstring(this.getrow(),'sawon1')
ls_s2 = this.getitemstring(this.getrow(),'sawon2')
ls_s3 = this.getitemstring(this.getrow(),'sawon3')

if ls_s1 = '' or isNull(ls_s1) then
	this.object.t_s1.text = ''
else
	select empname into :ls_n1
	  from p1_master
	 where empno = :ls_s1;
	this.object.t_s1.text = ls_n1
end if
	
if ls_s2 = '' or isNull(ls_s2) then
	this.object.t_s2.text = ''
else
	select empname into :ls_n2
	  from p1_master
	 where empno = :ls_s2;
	this.object.t_s2.text = ls_n2
end if

if ls_s1 = '' or isNull(ls_s1) then
	this.object.t_s3.text = ''
else
	select empname into :ls_n3
	  from p1_master
	 where empno = :ls_s3;
	this.object.t_s3.text = ls_n3
end if

year1 = this.getitemnumber(rowcount,'kwanyy')
year2 = this.getitemnumber(rowcount,'jonyy')

if year1 = 88 or year1 = 99 or year2 = 88 or year2 = 99 then
	this.settaborder('kwanflag',0)
	this.settaborder('kdate',0)
	this.settaborder('sawon2',0)
	this.settaborder('jonloc1',0)
	this.settaborder( 23 ,0)                // jonloc2
	this.settaborder('jonflag',0)
	this.settaborder('jdate',0)
	this.settaborder('sawon3',0)
	sle_msg.text = '경과후 처리내역은 입력하실수 없습니다.'
else
	this.settaborder('kwanflag',170)
	this.settaborder('kdate',180)
	this.settaborder('sawon2',190)
	this.settaborder('jonloc1',200)
	this.settaborder(23 ,210)               // jonloc2
	this.settaborder('jonflag',220)
	this.settaborder('jdate',230)
	this.settaborder('sawon3',240)
end if
	
//if year2 = 88 or year2 = 99 then
//	this.settaborder('kwanflag',0)
//	this.settaborder('kdate',0)
//	this.settaborder('sawon2',0)
//	this.settaborder('jonloc1',0)
//	this.settaborder(23,0)                    // jonloc2
//	this.settaborder('jonflag',0)
//	this.settaborder('jdate',0)
//	this.settaborder('sawon3',0)
//	sle_msg.text = '경과후 처리내역은 입력하실수 없습니다.'
//else
//	this.settaborder('kwanflag',170)
//	this.settaborder('kdate',180)
//	this.settaborder('sawon2',190)
//	this.settaborder('jonloc1',200)
//	this.settaborder(23,210)                 // jonloc2
//	this.settaborder('jonflag',220)
//	this.settaborder('jdate',230)
//	this.settaborder('sawon3',240)
//end if
end event

type dw_sub3 from datawindow within w_psd3002
event ue_enterkey2 pbm_dwnprocessenter
integer x = 2592
integer y = 512
integer width = 713
integer height = 88
integer taborder = 150
boolean bringtotop = true
string title = "none"
string dataobject = "d_psd3002_05"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_enterkey2;if this.getcolumnname() = 'gbn' then
	dw_detail.setFocus()
	dw_detail.setColumn('fileno')
else
	send(handle(this),256,9,0)	
end if
end event

event dberror;return 1
end event

event itemchanged;if getcolumnname() = 'deptcode' then
	
	String sNull
	
	datawindowchild dws
	dw_detail.getchild("gbn", dws)
	dws.settransobject(sqlca)
	dws.retrieve(data)	
	
	Setnull(sNull)
	setitem(1, "gbn", sNull)
end if

//IF THIS.GETCOLUMNNAME() = 'GBN' THEN
//	THIS.ACCEPTTEXT()
//	STRING LS_DEPT,LS_GBN,LS_COLOR
//	LS_DEPT = DW_DETAIL.GETITEMSTRING(DW_DETAIL.GETROW(),'deptcode')
//	LS_GBN  = THIS.GETTEXT()
//	
//	SELECT COLOR INTO :LS_COLOR
//	  FROM P8_FILESYSCODE
//	 WHERE DEPTCODE = :LS_DEPT
//	   AND LMGBN    = :LS_GBN;
//		
//   DW_DETAIL.SETITEM(DW_DETAIL.GETROW(),'color',LS_COLOR)
//END IF

end event

event itemerror;return 1
end event

event losefocus;	STRING LS_DEPT,LS_GBN,LS_COLOR
	LS_DEPT = dw_detail.GetItemString(dw_detail.getrow(),'deptcode')
	LS_GBN  = THIS.getitemstring(this.getrow(),'gbn')
	
	SELECT COLOR INTO :LS_COLOR
	  FROM P8_FILESYSCODE
	 WHERE DEPTCODE = :LS_DEPT
	   AND LMGBN    = :LS_GBN;
		
   DW_DETAIL.SETITEM(DW_DETAIL.GETROW(),'color',LS_COLOR)
end event

type rr_2 from roundrectangle within w_psd3002
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 658
integer y = 396
integer width = 1445
integer height = 1788
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_psd3002
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 2213
integer y = 372
integer width = 2149
integer height = 1808
integer cornerheight = 40
integer cornerwidth = 55
end type

