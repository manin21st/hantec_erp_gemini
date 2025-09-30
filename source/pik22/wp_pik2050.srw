$PBExportHeader$wp_pik2050.srw
$PBExportComments$주차별 개인 잔업현황
forward
global type wp_pik2050 from w_standard_print
end type
type rr_2 from roundrectangle within wp_pik2050
end type
end forward

global type wp_pik2050 from w_standard_print
integer width = 4677
integer height = 2752
string title = "주차별 개인 잔업현황"
rr_2 rr_2
end type
global wp_pik2050 wp_pik2050

forward prototypes
public function integer wf_retrieve ()
public function string wf_makedate (string mdate)
end prototypes

public function integer wf_retrieve ();string  vJgubn,vSdate,vEdate, vDept, vTime, vTime1, vGubun, vEmpno
long ls_time, ls_time1 

dw_ip.AcceptText()

ls_time = dw_ip.GetItemNumber(1,'time')
vSdate = dw_ip.GetItemString(1,'sdate')
vEdate = dw_ip.GetItemString(1,'edate')
vDept = dw_ip.GetItemString(1,'deptcode')
vJgubn = dw_ip.GetItemString(1,'jgubn')
vGubun = dw_ip.GetItemString(1,'gubun')
ls_time1 = dw_ip.GetItemNumber(1,'time1')
vEmpno  = dw_ip.GetItemString(1,'empno')


if vSdate > vEdate then
	MessageBox("확인","날짜범위가 올바르지 않습니다.")
	dw_ip.SetColumn("sdate")
	dw_ip.SetFocus()
	dw_list.reset()
	return 1
end if


if isnull(ls_time) or ls_time = 0  then
	MessageBox("확인","기준시간을 확인 해주세요.")
	return 1
end if

if vGubun =  '1' then
	if isnull(ls_time1) or ls_time1 = 0 then
		ls_time1 = 0
	end if
else	
	if isnull(ls_time1) then
		MessageBox("확인","잔업시간을 확인 해주세요.")
		return 1
	end if
end if 

if isnull(vJgubn) or vJgubn = '' then
	vJgubn = '%'
end if

if isnull(vDept) or vDept = '' then
	vDept = '%'
end if 

if isnull(vSdate) or vSdate = '' then
	vSdate = '11111111'
end if

if isnull(vEdate) or vEdate = '' then
	vEdate = '29991111'
end if

if isnull(vEmpno) or vEmpno = '' then
	vEmpno = '%'
end if

if dw_Print.Retrieve(ls_time, vSdate, vEdate, vDept, vJgubn, vGubun,ls_time1,vEmpno ) < 1 then
	w_mdi_frame.sle_msg.text = "해당 자료가 없습니다!"
	return 1
end if

//dw_list.ShareData(dw_Print)
 dw_list.Retrieve(ls_time, vSdate, vEdate, vDept, vJgubn, vGubun, ls_time1,vEmpno )

//if vSaupcd = '%' then
//	vSaupcd = '전체'
//else
//	vSaupcd = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(saupcd)',1)"));
//end if
//
//if vKgubn = '%' then
//	vKgubn = '전체'
//else
//	vKgubn = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(kgubn)',1)"));
//end if
//
//if vjgubn = '%' then
//	vjgubn = '전체'
//else
//	vjgubn = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(jgubn)',1)"));
//end if
//
//if vSdate = '11111111' then
//	vSdate = '기준일자'
//else
//	vSdate = wf_Makedate(vSdate)					//사용자 지정 함수
//end if
//
//if vEdate = '29991111' then
//	vEdate = '기준일자'
//else
//	vEdate = wf_Makedate(vEdate)
//end if
//
//vDate = vSdate +"  -  "+ vEdate
//
//dw_print.Modify("saupcd.text = '"+vSaupcd+"' ")
//dw_print.Modify("kgubn.text = '"+vKgubn+"' ")
//dw_print.Modify("jgubn.text = '"+vJgubn+"' ")
//dw_print.Modify("date.text = '"+vDate+"' ")

//SetPointer(arrow!)
return 1
end function

public function string wf_makedate (string mdate);string vYY, vMM, vDD, Rdate

vYY = left(Mdate,4)
vMM = mid(Mdate,5,2)
vDD = right(Mdate,2)

Rdate = vYY + "년 "+ vMM +"월 "+ vDd +"일"

return Rdate


end function

on wp_pik2050.create
int iCurrent
call super::create
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
end on

on wp_pik2050.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_2)
end on

event open;call super::open;dw_list.Settransobject(sqlca)

dw_ip.SetItem(1, 'sdate', left(f_today(),6) + '01')
dw_ip.SetItem(1, 'edate', f_today() )

end event

type p_xls from w_standard_print`p_xls within wp_pik2050
integer x = 4448
integer y = 160
end type

type p_sort from w_standard_print`p_sort within wp_pik2050
integer x = 4270
integer y = 160
end type

type p_preview from w_standard_print`p_preview within wp_pik2050
end type

type p_exit from w_standard_print`p_exit within wp_pik2050
end type

type p_print from w_standard_print`p_print within wp_pik2050
end type

type p_retrieve from w_standard_print`p_retrieve within wp_pik2050
end type







type st_10 from w_standard_print`st_10 within wp_pik2050
end type



type dw_print from w_standard_print`dw_print within wp_pik2050
integer x = 4128
integer y = 176
string dataobject = "dp_pik2050_1_p"
end type

type dw_ip from w_standard_print`dw_ip within wp_pik2050
integer x = 18
integer y = 0
integer width = 3881
integer height = 288
string dataobject = "dp_pik2050_0"
end type

event dw_ip::itemchanged;call super::itemchanged;string vEmpno,sEmpname,vSdate,vSaupcd,vEdate

this.AcceptText()

if this.GetColumnName() = "empno" then
	vEmpno = this.GetItemString(1,"empno")
	
	if vEmpno = ''  or  isNull(vEmpno) then
		this.SetItem(1,"empname",'')
	else
		Select empname
		into :sEmpname
		From p1_master
		Where companycode = :gs_company and
				empno = :vEmpno ;
	end if
				
	if SQLCA.SQLCODE <> 0 then
		MessageBox("확인","사원코드를 확인하세요!")
		this.SetItem(1,"empname",'')
		this.SetItem(1,"empno",'')
		return 1
	end if
	
	this.SetItem(1,"empname",sEmpname)
	this.SetColumn('empno')
	this.SetFocus()
end if


if this.GetColumnName() = 'saupcd' then
	vSaupcd = this.GetText()
	
	if vSaupcd = '' or isnull(vSaupcd) then vSaupcd = '%'
end if


if this.GetColumnName() = 'sdate' then
	vSdate = this.GetText()
	
	if f_datechk(vSdate) = -1 then
		messagebox("확인","조회일자를 확인하세요.")
		this.SetItem(this.GetRow(),'sdate','')
		this.SetColumn('sdate')
		this.SetFocus()
		return 1
	end if
	
end if	


if this.GetColumnName() = 'edate' then
	vEdate = this.GetText()
	
	if f_datechk(vEdate) = -1 then
		messagebox("확인","조회일자를 확인하세요")
		this.SetItem(this.GetRow(),'edate','')
		this.SetColumn('edate')
		this.SetFocus()
		return 1
	end if
end if



	

		
end event

event dw_ip::rbuttondown;call super::rbuttondown;SetNull(Gs_code)
SetNull(Gs_codename)

AcceptText()

IF GetColumnName() = "empname" THEN
	Gs_Codename = GetItemString(this.GetRow(),"empname")
	
	open(w_employee_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	SetItem(this.GetRow(),"empno",Gs_code)
	SetItem(this.GetRow(),"empname",Gs_codeName)
	
END IF

IF GetColumnName() = "empno" THEN
	Gs_Code = this.GetItemString(this.GetRow(),"empno")
	
	open(w_employee_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	SetItem(this.GetRow(),"empno",Gs_code)
	SetItem(this.GetRow(),"empname",Gs_codeName)
END IF
end event

event dw_ip::error;call super::error;return 
end event

event dw_ip::clicked;call super::clicked;Long ls_time, ls_time1

this.Accepttext()

IF dwo.name = 'b_1' THEN
	ls_time1 = this.GetItemNumber(1, "time1")
	this.Setitem(1,'time1',ls_time1 + 1)
END IF


IF dwo.name = 'b_2' THEN
	ls_time1 = this.GetItemNumber(1, "time1")
	this.Setitem(1,'time1',ls_time1 - 1)
END IF

IF dwo.name = 'b_3' THEN
	ls_time = this.GetItemNumber(1, "time")
	this.Setitem(1,'time',ls_time + 1)
END IF


IF dwo.name = 'b_4' THEN
	ls_time = this.GetItemNumber(1, "time")
	this.Setitem(1,'time',ls_time  - 1)
END IF

end event

type dw_list from w_standard_print`dw_list within wp_pik2050
integer x = 32
integer y = 320
integer width = 4581
string dataobject = "dp_pik2050_1"
boolean border = false
end type

type rr_2 from roundrectangle within wp_pik2050
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 300
integer width = 4603
integer height = 1948
integer cornerheight = 40
integer cornerwidth = 55
end type

