$PBExportHeader$wr_pip5027.srw
$PBExportComments$** 근로소득 원천징수부
forward
global type wr_pip5027 from w_standard_print
end type
type rr_1 from roundrectangle within wr_pip5027
end type
end forward

global type wr_pip5027 from w_standard_print
string title = "근로소득 원천징수부"
rr_1 rr_1
end type
global wr_pip5027 wr_pip5027

type variables

end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string	ls_tag, ls_empno, ls_yy, sSaup, sJikjong, sKunmu

Setpointer(hourglass!)

if dw_ip.Accepttext() = -1 then return -1

ls_yy   =  dw_ip.GetitemString(1,'yymm')
ls_empno = dw_ip.GetitemString(1,'empno')
sKunmu = trim(dw_ip.GetitemString(1,'kunmu'))
sSaup = trim(dw_ip.GetItemString(1,"saup"))
sJikjong = trim(dw_ip.GetItemString(1,"jikjong"))

IF sSaup = '' OR IsNull(sSaup) THEN sSaup = '%'
IF sJikjong = '' OR IsNull(sJikjong) THEN sJikjong = '%'
IF sKunmu = '' OR IsNull(sKunmu) THEN sKunmu = '%'
if ls_empno = '' OR IsNull(ls_empno) THEN ls_empno = '%'


if dw_list.Retrieve(ls_yy, sSaup,sJikjong, sKunmu, ls_empno, gs_today) < 1 then	
   MessageBox("확 인","조회한 자료가 없습니다!!")
	dw_list.Insertrow(0)
   return -1
end if
dw_print.Retrieve(ls_yy, sSaup,sJikjong, sKunmu, ls_empno, gs_today)
//dw_print.sharedata(dw_list)

return 1
end function

on wr_pip5027.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on wr_pip5027.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;Integer  li_idx

li_idx = w_mdi_frame.dw_listbar.InsertRow(0)
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_id',Upper(This.ClassName()))
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_name',Upper(This.Title))
w_mdi_frame.Postevent("ue_barrefresh")

is_today = f_today()
is_totime = f_totime()
is_window_id = this.ClassName()

w_mdi_frame.st_window.Text = Upper(is_window_id)

SELECT "SUB2_T"."OPEN_HISTORY", "SUB2_T"."UPMU"  
  INTO :is_usegub,  :is_upmu 
  FROM "SUB2_T"  
 WHERE "SUB2_T"."WINDOW_NAME" = :is_window_id  ;

IF is_usegub = 'Y' THEN
   INSERT INTO "PGM_HISTORY"  
	 		 ( "L_USERID",   "CDATE",       "STIME",      "WINDOW_NAME",   "EDATE",   
			   "ETIME",      "IPADD",       "USER_NAME" )  
   VALUES ( :gs_userid,   :is_today,     :is_totime,   :is_window_id,   NULL, 
	   		NULL,         :gs_ipaddress, :gs_comname )  ;

   IF SQLCA.SQLCODE = 0 THEN 
	   COMMIT;
   ELSE 	  
	   ROLLBACK;
   END IF	  
END IF	 

dw_ip.SetTransObject(SQLCA)
dw_ip.Reset()
dw_ip.InsertRow(0)

dw_list.settransobject(sqlca)
dw_print.settransobject(sqlca)

IF is_upmu = 'A' THEN //회계인 경우
   int iRtnVal 

	IF Upper(Mid(is_window_id,4,2)) = 'BG' THEN							   /*예산*/
		IF F_Valid_EmpNo(Gs_EmpNo) = 'N' THEN							/*권한 체크- 현업 여부*/
			dw_ip.SetItem(dw_ip.GetRow(),"saupj",   Gs_Saupj)
			
			dw_ip.Modify("saupj.protect = 1")
		ELSE
			dw_ip.Modify("saupj.protect = 0")
		END IF
	ELSE
		IF Upper(Mid(is_window_id,4,2)) = 'FI' THEN							/*자금*/
			iRtnVal = F_Authority_Fund_Chk(Gs_Dept)	
		ELSE
			iRtnVal = F_Authority_Chk(Gs_Dept)
		END IF
		IF iRtnVal = -1 THEN							/*권한 체크- 현업 여부*/
			dw_ip.SetItem(dw_ip.GetRow(),"saupj",   Gs_Saupj)
			
			dw_ip.Modify("saupj.protect = 1")
		ELSE
			dw_ip.Modify("saupj.protect = 0")
		END IF	
	END IF
END IF
dw_print.object.datawindow.print.preview = "yes"	

dw_list.InsertRow(0)

f_set_saupcd(dw_ip,'saup','1')
is_saupcd = gs_saupcd
IF is_saupcd = '' OR IsNull(is_saupcd) THEN is_saupcd = '%'
dw_ip.Setitem(1,'yymm', left(f_today(),4))



end event

type p_preview from w_standard_print`p_preview within wr_pip5027
end type

type p_exit from w_standard_print`p_exit within wr_pip5027
end type

type p_print from w_standard_print`p_print within wr_pip5027
end type

type p_retrieve from w_standard_print`p_retrieve within wr_pip5027
end type

type st_window from w_standard_print`st_window within wr_pip5027
boolean visible = false
integer x = 2446
integer y = 2976
end type

type sle_msg from w_standard_print`sle_msg within wr_pip5027
boolean visible = false
integer x = 471
integer y = 2976
end type

type dw_datetime from w_standard_print`dw_datetime within wr_pip5027
boolean visible = false
integer x = 2939
integer y = 2976
end type

type st_10 from w_standard_print`st_10 within wr_pip5027
boolean visible = false
integer x = 110
integer y = 2976
end type

type gb_10 from w_standard_print`gb_10 within wr_pip5027
boolean visible = false
integer x = 96
integer y = 2940
end type

type dw_print from w_standard_print`dw_print within wr_pip5027
integer x = 3721
integer y = 44
string dataobject = "dr_pip5027_4"
boolean border = false
end type

type dw_ip from w_standard_print`dw_ip within wr_pip5027
integer x = 494
integer y = 8
integer width = 2249
integer height = 256
string dataobject = "dr_pip5027_1"
end type

event dw_ip::itemerror;call super::itemerror;return 1
end event

event dw_ip::rbuttondown;call super::rbuttondown;string sempname, sempno, snull
int il_count


SetNull(Gs_codename)
SetNull(Gs_code)
SetNull(gs_gubun)

if This.GetColumnName() = 'empno' then
	gs_gubun = is_saupcd
	open(w_employee_saup_popup)
		
	IF IsNull(Gs_code) THEN RETURN
	 
   dw_ip.SetITem(1,"empno",Gs_code)
	dw_ip.SetITem(1,"empname",Gs_codename)
	
	
end if



end event

event dw_ip::itemchanged;call super::itemchanged;string sempname, sempno, snull, ls_name
int il_count
SetNull(snull)

this.AcceptText()

IF this.GetColumnName() = 'saup' THEN
	is_saupcd = this.GetText()
	
	IF is_saupcd = '' OR IsNull(is_saupcd) THEN is_saupcd = '%'
END IF

if This.GetColumnName() = 'empno' then
	sempno = this.Gettext()

   IF sempno ="" OR IsNull(sempno) THEN RETURN   

	SELECT count(*) INTO :il_count
	  FROM "P1_MASTER"
	 WHERE "P1_MASTER"."EMPNO" = :sempno;

	IF il_Count > 0 THEN
		SELECT "EMPNAME" INTO :sempname
		  FROM "P1_MASTER"
		 WHERE "P1_MASTER"."EMPNO" = :sempno;
	ELSE
		Messagebox("확 인","등록되지 않은 사번이므로 조회할 수 없습니다!!")
		dw_ip.setitem(1,'empno', snull)
		dw_ip.setitem(1,'empname', snull)
		dw_ip.SetColumn('empno')
		dw_ip.SetFocus()
		return
	END IF
	
	dw_ip.Setitem(1,'empname', sempname)
	
end if

IF GetColumnName() = "empname" then
  sEmpName = GetItemString(1,"empname")

   ls_name = wf_exiting_saup_name('empname',sEmpName, '1', is_saupcd)	 
	 if IsNull(ls_name) then 
		 Setitem(1,'empname',ls_name)
		 Setitem(1,'empno',ls_name)
		 return 1
    end if
	 Setitem(1,"empno",ls_name)
	 ls_name = wf_exiting_saup_name('empno',ls_name, '1', is_saupcd)
	 Setitem(1,"empname",ls_name)
	 return 1
END IF


end event

type dw_list from w_standard_print`dw_list within wr_pip5027
integer x = 512
integer y = 280
integer width = 3639
integer height = 1992
string dataobject = "dr_pip5027_4"
boolean border = false
end type

event dw_list::clicked;//OVERRIDE
end event

event dw_list::rowfocuschanged;//OVERRIDE
end event

type rr_1 from roundrectangle within wr_pip5027
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 16777215
integer x = 489
integer y = 268
integer width = 3685
integer height = 2016
integer cornerheight = 40
integer cornerwidth = 55
end type

