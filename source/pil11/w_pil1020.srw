$PBExportHeader$w_pil1020.srw
$PBExportComments$대여금징구현황(출력)
forward
global type w_pil1020 from w_standard_print
end type
type rr_1 from roundrectangle within w_pil1020
end type
end forward

global type w_pil1020 from w_standard_print
string title = "대여금징구현황"
rr_1 rr_1
end type
global w_pil1020 w_pil1020

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string sdate, edate,sabu,sdept, sgbn, pbtag

if dw_ip.Accepttext() = -1 then return -1

sdate = dw_ip.GetitemString(1, 'frdate')
edate = dw_ip.GetitemString(1, 'todate')
sabu = dw_ip.GetitemString(1, 'sabu')
sdept = dw_ip.GetitemString(1, 'dept')
sgbn = dw_ip.GetitemString(1, 'gubn')
pbtag = dw_ip.GetitemString(1, 'pbtag')


if IsNull(sdate) or sdate = '' then
	messagebox("확인","일자를 입력하세요!")
	dw_ip.setcolumn('frdate')
	dw_ip.setfocus()
	return -1
else
	if f_datechk(sdate) = -1 then
		messagebox("확인","일자를 확인하십시요!")
		dw_ip.setitem(1,'frdate', '')
		dw_ip.setcolumn('frdate')
		dw_ip.setfocus()
		return -1
	end if
end if


if IsNull(edate) or edate = '' then
	messagebox("확인","일자를 입력하세요!")
	dw_ip.setcolumn('todate')
	dw_ip.setfocus()
	return -1
else
	if f_datechk(edate) = -1 then
		messagebox("확인","일자를 확인하십시요!")
		dw_ip.setitem(1,'todate', '')
		dw_ip.setcolumn('todate')
		dw_ip.setfocus()
		return -1
	end if
end if

if IsNull(sabu) or sabu = '' then sabu = '%'
if IsNull(sdept) or sdept = '' then sdept = '%'
if IsNull(sgbn) or sgbn = '' then sgbn = '%'

w_mdi_frame.sle_msg.text = '조회 중...............!!'
if dw_print.retrieve(sabu, sdept, sgbn,sdate, edate, pbtag) < 1 then
	messagebox("조회","조회할 내용이 없습니다!")
	dw_ip.setfocus()
	w_mdi_frame.sle_msg.text = ''
	return -1
end if
dw_print.sharedata(dw_list)

w_mdi_frame.sle_msg.text = '조회가 완료되었습니다!'

return 1


end function

on w_pil1020.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pil1020.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.setitem(1,'frdate',left(gs_today,6)+'01')
dw_ip.setitem(1,'todate',gs_today)

f_set_saupcd(dw_ip, 'sabu', '1')
is_saupcd = gs_saupcd

end event

type p_preview from w_standard_print`p_preview within w_pil1020
end type

type p_exit from w_standard_print`p_exit within w_pil1020
end type

type p_print from w_standard_print`p_print within w_pil1020
end type

type p_retrieve from w_standard_print`p_retrieve within w_pil1020
end type

type st_window from w_standard_print`st_window within w_pil1020
boolean visible = false
end type

type sle_msg from w_standard_print`sle_msg within w_pil1020
boolean visible = false
end type

type dw_datetime from w_standard_print`dw_datetime within w_pil1020
boolean visible = false
end type

type st_10 from w_standard_print`st_10 within w_pil1020
boolean visible = false
end type

type gb_10 from w_standard_print`gb_10 within w_pil1020
boolean visible = false
end type

type dw_print from w_standard_print`dw_print within w_pil1020
string dataobject = "d_pil1020_2_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pil1020
integer x = 32
integer width = 3237
integer height = 272
string dataobject = "d_pil1020_1"
end type

event dw_ip::itemchanged;call super::itemchanged;string sdate, sDeptno,SetNull,sName, sno

this.AcceptText()

IF this.GetColumnName() = 'sabu' THEN
	is_saupcd = this.GetText()
	
	IF is_saupcd = '' OR IsNull(is_saupcd) THEN is_saupcd = '%'
END IF

if this.GetColumnName() = 'frdate' then
	sdate = this.Gettext()
	
	if IsNull(sdate) or sdate = '' then
		messagebox("확인","일자를 입력하세요!")
		this.setcolumn('frdate')
		this.setfocus()
		return
	else
		if f_datechk(sdate) = -1 then
			messagebox("확인","일자를 확인하십시요!")
			this.setitem(1,'frdate', '')
			this.setcolumn('frdate')
		   this.setfocus()
			return
		end if
	end if
end if
if this.GetColumnName() = 'todate' then
	sdate = this.Gettext()
	
	if IsNull(sdate) or sdate = '' then
		messagebox("확인","일자를 입력하세요!")
		this.setcolumn('todate')
		this.setfocus()
		return
	else
		if f_datechk(sdate) = -1 then
			messagebox("확인","일자를 확인하십시요!")
			this.setitem(1,'todate', '')
			this.setcolumn('todate')
		   this.setfocus()
			return
		end if
	end if
end if

IF this.GetColumnName() ="dept" THEN 
   sDeptno = this.GetText()
	IF sDeptno = '' OR ISNULL(sDeptno) THEN
		this.SetITem(1,"dept",SetNull)
		this.SetITem(1,"deptname",SetNull)
		Return 
	END IF	
	
	  SELECT  "P0_DEPT"."DEPTNAME"  
		INTO :sName  
		FROM "P0_DEPT"  
		WHERE ( "P0_DEPT"."COMPANYCODE" = :gs_company ) AND  
				( "P0_DEPT"."DEPTCODE" = :sDeptno ); 
	
	IF sName = '' OR ISNULL(sName) THEN
   	MessageBox("확 인","부서번호를 확인하세요!!") 
		this.SetITem(1,"dept",SetNull)
	   this.SetITem(1,"deptname",SetNull) 
		this.SetColumn("dept")
      Return 1
	END IF	
	   this.SetITem(1,"deptname",sName) 
END IF	

end event

event dw_ip::rbuttondown;call super::rbuttondown;IF this.GetColumnName() = "dept" THEN
	SetNull(gs_code)
	SetNull(gs_codename)
   SetNull(Gs_gubun)

	Open(w_dept_saup_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	this.SetITem(1,"dept",gs_code)
	this.SetITem(1,"deptname",gs_codename)
	
END IF	
end event

event dw_ip::itemerror;call super::itemerror;Return 1
end event

type dw_list from w_standard_print`dw_list within w_pil1020
integer x = 55
integer y = 304
integer width = 4503
integer height = 1948
string dataobject = "d_pil1020_2"
boolean border = false
end type

type rr_1 from roundrectangle within w_pil1020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 300
integer width = 4553
integer height = 1964
integer cornerheight = 40
integer cornerwidth = 55
end type

