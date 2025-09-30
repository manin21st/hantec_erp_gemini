$PBExportHeader$w_psd2201.srw
$PBExportComments$공상자 현황
forward
global type w_psd2201 from w_standard_print
end type
type rb_1 from radiobutton within w_psd2201
end type
type rb_2 from radiobutton within w_psd2201
end type
end forward

global type w_psd2201 from w_standard_print
integer height = 2848
rb_1 rb_1
rb_2 rb_2
end type
global w_psd2201 w_psd2201

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string sDate,eDAte,dept1,dept2, to_day,ls_empno,ls_saupcd
long gnsk1,gnsk2,ll_row



if rb_1.checked = true then
	dw_list.dataobject = 'd_psd2201_q_1'
	dw_print.dataobject = 'd_psd2201_r_1'
   dw_list.settransobject(sqlca)
	dw_print.settransobject(sqlca)
	dw_Print.sharedata(dw_list)
	dw_ip.AcceptText()

	ll_row = dw_ip.getrow()
	sDate = dw_ip.getitemstring(ll_row,'sdate') + '01'
	edate = dw_ip.getitemstring(ll_row,'edate') + '31'
	dept1 = dw_ip.getitemstring(ll_row,'dept1')
	dept2 = dw_ip.getitemstring(ll_row,'dept2')	
	gnsk1 = dw_ip.getitemnumber(ll_row,'geonsok1')
	gnsk2 = dw_ip.getitemnumber(ll_row,'geonsok2')
	ls_empno = dw_ip.getitemstring(ll_row,'empno')
	ls_saupcd = dw_ip.GetItemString(1,"saupcd")

	if ls_empno = '' or isNull(ls_empno) then ls_empno = '%'
	if dept1 = '' or isNull(dept1) then dept1 = '.'
	if dept2 = '' or isNull(dept2) then dept2 = 'ZZZZZZ'
	if isNull(gnsk1) then
		gnsk1 = 0
	end if
	if isNull(gnsk2) then 
		gnsk2 = 999
	end if
	
	to_day = string(today(),'yyyymmdd')
   if dw_print.retrieve(to_day,sDate,eDate,gnsk1,gnsk2,dept1,dept2, ls_empno,ls_saupcd) < 1 then
		messagebox("조회","조회할 자료가 없습니다")
		return -1
	end if
	return 1

elseif rb_2.checked = true then
	dw_list.dataobject = 'd_psd2201_q_2'
	dw_print.dataobject = 'd_psd2201_r_2'
	dw_list.settransobject(sqlca)
	dw_print.settransobject(sqlca)
	dw_print.sharedata(dw_list)
	
	string sYear
	ls_saupcd = dw_ip.GetItemString(1, "saupcd")
	sYear = dw_ip.GetItemString(1,"sdate")
	if sYear = '' or isNull(sYear) then
		messagebox('확인','기준년도를 입력하셔야 합니다.',stopsign!)
		dw_ip.setFocus()
		return -1
	end if
   if dw_list.retrieve(sYear,ls_saupcd) < 1 then
		messagebox("조회","조회할 자료가 없습니다")
		return -1
	end if
		
	return 1
end if
end function

on w_psd2201.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
end on

on w_psd2201.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
end on

event open;call super::open;
dw_list.settransobject(sqlca)
dw_ip.settransobject(sqlca)
dw_datetime.settransobject(sqlca)

dw_ip.insertrow(0)


long ll_row
ll_row = dw_ip.getrow()

dw_ip.setitem(ll_row,'sdate',string(today(),'yyyy')+'01')
dw_ip.setitem(ll_row,'edate',string(today(),'yyyymm'))

f_set_saupcd(dw_ip, 'saupcd', '1')

dw_ip.setFocus()


end event

type p_preview from w_standard_print`p_preview within w_psd2201
end type

type p_exit from w_standard_print`p_exit within w_psd2201
end type

type p_print from w_standard_print`p_print within w_psd2201
end type

type p_retrieve from w_standard_print`p_retrieve within w_psd2201
end type







type st_10 from w_standard_print`st_10 within w_psd2201
end type



type dw_print from w_standard_print`dw_print within w_psd2201
string dataobject = "d_psd2201_r_1"
end type

type dw_ip from w_standard_print`dw_ip within w_psd2201
integer x = 0
integer y = 0
integer width = 3520
integer height = 312
string dataobject = "d_psd2201_c_1"
end type

event dw_ip::itemchanged;call super::itemchanged;string ls_no,ls_name,ls_empno,ls_empname
long cnt

if this.getcolumnname() = 'dept1' then
   this.accepttext()
	ls_no = this.getitemstring(row,'dept1')
	
	if ls_no = '' or isNull(ls_no) then
		this.object.t_2.text = ''
	else
		select count(*),deptname into :cnt, :ls_name
		  from p0_dept
		 where deptcode = :ls_no
		 group by deptname;
		 
		 if cnt < 1 then
			messagebox('확인','등록된 부서 코드가 아닙니다.',exclamation!)
			this.setitem(row,'dept1','')
			this.setcolumn('dept1')
			return 1
		else
			this.object.t_2.text = ls_name
		end if
	end if
elseif this.getcolumnname() = 'dept2' then
   this.accepttext()
	ls_no = this.getitemstring(row,'dept2')
	
	if ls_no = '' or isNull(ls_no) then
		this.object.t_3.text = ''
	else
		select count(*),deptname into :cnt, :ls_name
		  from p0_dept
		 where deptcode = :ls_no
		 group by deptname;
		 
		 if cnt < 1 then
			messagebox('확인','등록된 부서 코드가 아닙니다.',exclamation!)
			this.setitem(row,'dept2','')
			this.setcolumn('dept2')
			return 1
		else
			this.object.t_3.text = ls_name
		end if
	end if
elseif this.getcolumnname() = 'empno' then
   this.accepttext()
	ls_empno = this.getitemstring(row,'empno')
	
	if ls_empno = '' or isNull(ls_empno) then
		this.setitem(1,"empname","")
	else
		select count(*),empname into :cnt, :ls_empname
		  from p1_master
		 where empno = :ls_empno
		 group by empname;
		 
		 if cnt < 1 then
			messagebox('확인','등록된 사번이 아닙니다.',exclamation!)
			this.setitem(row,'empno','')
			this.setcolumn('empno')
			return 1
		else
			this.setitem(1,"empname",ls_empname)
		end if
	end if
end if
end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

event dw_ip::rbuttondown;call super::rbuttondown;setNull(gs_code)
setNull(gs_codename)

if this.getcolumnname() = 'dept1' then
	gs_gubun = dw_ip.GetItemString(1, "saupcd")
	open(w_dept_saup_popup)
	if gs_code = '' or isNull(gs_code) then
		return
	else
		this.setitem(1,'dept1',gs_code)
		this.object.t_2.text = gs_codename
	end if
elseif this.getcolumnname() = 'dept2' then
	gs_gubun = dw_ip.GetItemString(1, "saupcd")
	open(w_dept_saup_popup)
	if gs_code = '' or isNull(gs_code) then
		return
	else
		this.setitem(1,'dept2',gs_code)
		this.object.t_3.text = gs_codename
	end if
elseif this.getcolumnname() = 'empno' then
	gs_gubun = dw_ip.GetItemString(1, "saupcd")
	open(w_employee_saup_popup)
	if gs_code = '' or isNull(gs_code) then
		return
	else
		this.setitem(1,'empno',gs_code)
		this.setitem(1,'empname',gs_codename)
	end if
end if
end event

type dw_list from w_standard_print`dw_list within w_psd2201
integer x = 0
integer y = 428
integer height = 1768
string dataobject = "d_psd2201_q_1"
end type

type rb_1 from radiobutton within w_psd2201
integer x = 78
integer y = 324
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "월별 현황"
boolean checked = true
end type

event clicked;dw_list.dataobject = 'd_psd2201_q_1'
dw_print.dataobject = 'd_psd2201_r_1'
dw_ip.dataobject = 'd_psd2201_c_1'
dw_ip.settransobject(sqlca)
dw_list.settransobject(sqlca)

dw_list.title = '월별 공상치료자 현황'

dw_ip.insertrow(0)

f_set_saupcd(dw_ip, 'saupcd', '1')
end event

type rb_2 from radiobutton within w_psd2201
integer x = 517
integer y = 324
integer width = 521
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "년간 부서별 현황"
end type

event clicked;dw_list.dataobject = 'd_psd2201_q_2'
dw_print.dataobject = 'd_psd2201_r_2'
dw_ip.dataobject = 'd_psd2201_c_2'
dw_ip.settransobject(sqlca)
dw_list.settransobject(sqlca)

dw_list.title = '년간 부서별 공상자 현황'

dw_ip.insertrow(0)

f_set_saupcd(dw_ip, 'saupcd', '1')

dw_ip.SetItem(1, "sdate", string(today(),'yyyy'))
end event

