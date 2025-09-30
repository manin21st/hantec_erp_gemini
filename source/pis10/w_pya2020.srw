$PBExportHeader$w_pya2020.srw
$PBExportComments$해외출장대장 조회출력
forward
global type w_pya2020 from w_standard_print
end type
type rr_1 from roundrectangle within w_pya2020
end type
end forward

global type w_pya2020 from w_standard_print
integer width = 4754
string title = "해외 출장 대장 조회 출력"
rr_1 rr_1
end type
global w_pya2020 w_pya2020

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string s_sano, s_saname, s_dept, s_deptnm, s_frdate, s_todate, s_country, s_gbn

if dw_ip.accepttext() = -1 then return -1
 
s_sano = dw_ip.getitemstring(dw_ip.getrow(), "sano")
s_dept = dw_ip.getitemstring(dw_ip.getrow(), "dept")
s_frdate = dw_ip.getitemstring(dw_ip.getrow(), "frdate")
s_todate = dw_ip.getitemstring(dw_ip.getrow(), "todate")
s_country = dw_ip.getitemstring(dw_ip.getrow(), "country")
s_gbn = dw_ip.getitemstring(dw_ip.getrow(), "gbn")

//dw_list.object.t_7.text = string(s_frdate, '@@@@.@@.@@')
//dw_list.object.t_8.text = string(s_todate, '@@@@.@@.@@')
//
if s_sano = "" or isnull(s_sano) then 
	s_sano = '%'
end if

SELECT "P1_MASTER"."EMPNAME"  
		  INTO :s_saname  
		  FROM "P1_MASTER"  
	    WHERE ( "P1_MASTER"."EMPNO" = :s_sano) ;

if s_dept = "" or isnull(s_dept) then
	s_dept = '%'
end if

SELECT  "P0_DEPT"."DEPTNAME"  
			INTO :s_deptnm 
			FROM "P0_DEPT"  
			WHERE ( "P0_DEPT"."DEPTCODE" = :s_dept ); 

if s_country = "" or isnull(s_country) then
	s_country = '%'
end if

if s_gbn = "" or isnull(s_gbn) then
	s_gbn = '%'
end if

if dw_list.retrieve(s_sano,  s_dept,  s_frdate, s_todate, s_country, s_gbn) <= 0 then
	messagebox("확인", "조회된 자료가 없습니다.")
	return -1 
end if 

return 1

end function

on w_pya2020.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pya2020.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;
dw_ip.setitem(1, "frdate", left(f_today(), 6) + '01')
dw_ip.setitem(1, "todate", f_today())
end event

type p_preview from w_standard_print`p_preview within w_pya2020
integer x = 4178
end type

event p_preview::clicked;string s_sano, s_saname, s_dept, s_deptnm, s_frdate, s_todate, s_country, s_gbn

if dw_ip.accepttext() = -1 then return -1
 
s_sano = dw_ip.getitemstring(dw_ip.getrow(), "sano")
s_dept = dw_ip.getitemstring(dw_ip.getrow(), "dept")
s_frdate = dw_ip.getitemstring(dw_ip.getrow(), "frdate")
s_todate = dw_ip.getitemstring(dw_ip.getrow(), "todate")
s_country = dw_ip.getitemstring(dw_ip.getrow(), "country")
s_gbn = dw_ip.getitemstring(dw_ip.getrow(), "gbn")

dw_print.object.t_7.text = string(s_frdate, '@@@@.@@.@@')
dw_print.object.t_8.text = string(s_todate, '@@@@.@@.@@')

if s_sano = "" or isnull(s_sano) then 
	s_sano = '%'
end if

SELECT "P1_MASTER"."EMPNAME"  
		  INTO :s_saname  
		  FROM "P1_MASTER"  
	    WHERE ( "P1_MASTER"."EMPNO" = :s_sano) ;

if s_dept = "" or isnull(s_dept) then
	s_dept = '%'
end if

SELECT  "P0_DEPT"."DEPTNAME"  
			INTO :s_deptnm 
			FROM "P0_DEPT"  
			WHERE ( "P0_DEPT"."DEPTCODE" = :s_dept ); 

if s_country = "" or isnull(s_country) then
	s_country = '%'
end if

if s_gbn = "" or isnull(s_gbn) then
	s_gbn = '%'
end if

dw_print.retrieve(s_sano,  s_dept,  s_frdate, s_todate, s_country, s_gbn)

OpenWithParm(w_print_preview, dw_print)	
end event

type p_exit from w_standard_print`p_exit within w_pya2020
integer x = 4526
end type

type p_print from w_standard_print`p_print within w_pya2020
integer x = 4352
end type

event p_print::clicked;string s_sano, s_saname, s_dept, s_deptnm, s_frdate, s_todate, s_country, s_gbn

if dw_ip.accepttext() = -1 then return -1
 
s_sano = dw_ip.getitemstring(dw_ip.getrow(), "sano")
s_dept = dw_ip.getitemstring(dw_ip.getrow(), "dept")
s_frdate = dw_ip.getitemstring(dw_ip.getrow(), "frdate")
s_todate = dw_ip.getitemstring(dw_ip.getrow(), "todate")
s_country = dw_ip.getitemstring(dw_ip.getrow(), "country")
s_gbn = dw_ip.getitemstring(dw_ip.getrow(), "gbn")

dw_print.object.t_7.text = string(s_frdate, '@@@@.@@.@@')
dw_print.object.t_8.text = string(s_todate, '@@@@.@@.@@')

if s_sano = "" or isnull(s_sano) then 
	s_sano = '%'
end if

SELECT "P1_MASTER"."EMPNAME"  
		  INTO :s_saname  
		  FROM "P1_MASTER"  
	    WHERE ( "P1_MASTER"."EMPNO" = :s_sano) ;

if s_dept = "" or isnull(s_dept) then
	s_dept = '%'
end if

SELECT  "P0_DEPT"."DEPTNAME"  
			INTO :s_deptnm 
			FROM "P0_DEPT"  
			WHERE ( "P0_DEPT"."DEPTCODE" = :s_dept ); 

if s_country = "" or isnull(s_country) then
	s_country = '%'
end if

if s_gbn = "" or isnull(s_gbn) then
	s_gbn = '%'
end if

dw_print.retrieve(s_sano,  s_dept,  s_frdate, s_todate, s_country, s_gbn)

IF dw_print.rowcount() > 0 then 
	gi_page = dw_print.GetItemNumber(1,"last_page")
ELSE
	gi_page = 1
END IF
OpenWithParm(w_print_options, dw_print)
end event

type p_retrieve from w_standard_print`p_retrieve within w_pya2020
integer x = 4005
end type

type st_window from w_standard_print`st_window within w_pya2020
boolean visible = false
end type

type sle_msg from w_standard_print`sle_msg within w_pya2020
boolean visible = false
end type

type dw_datetime from w_standard_print`dw_datetime within w_pya2020
boolean visible = false
end type

type st_10 from w_standard_print`st_10 within w_pya2020
boolean visible = false
end type

type gb_10 from w_standard_print`gb_10 within w_pya2020
boolean visible = false
end type

type dw_print from w_standard_print`dw_print within w_pya2020
string dataobject = "d_pya2020_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pya2020
integer x = 238
integer y = 12
integer width = 3378
integer height = 284
string dataobject = "d_pya2020"
end type

event dw_ip::itemchanged;call super::itemchanged;string s_frdate, s_todate, s_sano, s_saname, s_dept, s_deptnm, snull

setnull(snull)

IF THIS.GetColumnName() = "sano"  THEN
		s_sano = THIS.GetText()
		
	IF s_sano = "" OR ISNULL(s_sano) THEN
	   dw_ip.SetITem(1,"sano",snull)
		dw_ip.SetITem(1,"saname",snull)
	ELSE	
		SELECT "P1_MASTER"."EMPNAME"  
		  INTO :s_saname  
		  FROM "P1_MASTER"  
	    WHERE ( "P1_MASTER"."EMPNO" = :s_sano ) ;
			
			IF SQLCA.SQLCODE<>0 THEN
				MessageBox("확 인","사원번호를 확인하세요!!") 
				dw_ip.SetITem(1,"sano",snull)
		      dw_ip.SetITem(1,"saname",snull)
				dw_ip.SetColumn("sano")
				dw_ip.SetFocus()
				RETURN 1
			ELSE
				dw_ip.SetITem(1,"saname",s_saname)
			END IF
	END IF
	
ELSEIF  THIS.GetColumnName()  = "dept" THEN
   s_dept = This.GetText()
	
	IF s_dept = "" OR IsNull(s_dept) THEN
		dw_ip.SetITem(1,"dept",snull)
		dw_ip.SetITem(1,"deptnm",snull)
	ELSE	
		SELECT  "P0_DEPT"."DEPTNAME"  
			INTO :s_deptnm  
			FROM "P0_DEPT"  
			WHERE( "P0_DEPT"."DEPTCODE" = :s_dept ); 
	
			IF sqlca.sqlcode<>0 then
				MessageBox("확 인","부서번호를 확인하세요!!") 
				dw_ip.SetITem(1,"dept",snull)
		      dw_ip.SetITem(1,"deptnm",snull)
				dw_ip.SetColumn("dept")
				dw_ip.SetFocus()
				Return 1   
			ELSE
			dw_ip.SetITem(1,"deptnm",s_deptnm)
	      END IF
	END IF
END IF

if this.getcolumnname() = "frdate" then
	s_frdate = this.gettext()
	if s_frdate = "" or isnull(s_frdate) then
		f_messagechk(1, "[출장기간]")
		dw_ip.setcolumn("frdate")
		dw_ip.setfocus()
		return
	end if
end if

if this.getcolumnname() = "todate" then
	s_todate = this.gettext()
	if s_todate = "" or isnull(s_todate) then
		f_messagechk(1, "[출장기간]")
		dw_ip.setcolumn("todate")
		dw_ip.setfocus()
		return
	end if
end if





end event

event dw_ip::rbuttondown;call super::rbuttondown;if dw_ip.AcceptText() = -1 then return

IF this.GetColumnName() = "sano" THEN	
	setnull(gs_code)
   setnull(gs_codename)
  
	gs_code = dw_ip.GetItemString( 1,"sano")  
		
	open(w_employee_popup)
	
	if isnull(gs_code) or gs_code = '' then return
	dw_ip.SetItem(1,"sano",gs_code)
	dw_ip.SetItem(1,"saname",gs_codeName)
	
ELSEIF this.GetColumnName() = "dept" THEN
	SetNull(gs_code)
   SetNull(gs_codename)
	
   gs_code = dw_ip.GetItemString( 1,"dept")
	
	Open(w_dept_popup)
		
	IF IsNull(gs_code) THEN RETURN
		
	dw_ip.SetItem(1,"dept",gs_code)
	dw_ip.SetItem(1,"deptnm",gs_codeName)
END IF
end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_pya2020
integer x = 256
integer y = 312
integer width = 4215
integer height = 1952
string dataobject = "d_pya2020_1"
boolean border = false
end type

type rr_1 from roundrectangle within w_pya2020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 233
integer y = 308
integer width = 4270
integer height = 1964
integer cornerheight = 40
integer cornerwidth = 55
end type

