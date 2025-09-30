$PBExportHeader$wp_pip3203.srw
$PBExportComments$** 월별 비과세, 소득세리스트
forward
global type wp_pip3203 from w_standard_print
end type
type dw_1 from datawindow within wp_pip3203
end type
type dw_2 from datawindow within wp_pip3203
end type
type rr_1 from roundrectangle within wp_pip3203
end type
end forward

global type wp_pip3203 from w_standard_print
integer x = 0
integer y = 0
string title = "비과세/소득세 리스트"
dw_1 dw_1
dw_2 dw_2
rr_1 rr_1
end type
global wp_pip3203 wp_pip3203

type variables

end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sYm,sSaup,ls_gubun,ls_Empno,sDeptcode,sJikjong,sKunmu,ArgBuf
integer iRtnValue
dw_ip.AcceptText()

sYm      = dw_ip.GetITemString(1,"l_ym")
sSaup    = dw_ip.GetITemString(1,"l_saup")
ls_gubun = dw_ip.GetITemString(1,"l_gubn")     /*급여,상여구분*/
ls_Empno = dw_ip.GetITemString(1,"l_empno")
sJikjong = trim(dw_ip.GetItemString(1,"jikjong"))
sKunmu = trim(dw_ip.GetItemString(1,"kunmu"))

		 
IF sYm = "      " OR IsNull(sYm) THEN
	MessageBox("확 인","년월을 입력하세요!!")
	dw_ip.SetColumn("l_ym")
	dw_ip.SetFocus()
	Return -1
ELSE
  IF f_datechk(sYm + '01') = -1 THEN
   MessageBox("확인","년월을 확인하세요")
	dw_ip.SetColumn("l_ym")
	dw_ip.SetFocus()
	Return -1
  END IF	
END IF 


IF sJikjong = '' or isnull(sJikjong) THEN
	sJikjong = '%'
	dw_print.modify("t_jikjong.text = '"+'전체'+"'")
ELSE
	SELECT "CODENM"
     INTO :ArgBuf
     FROM "P0_REF"
    WHERE ( "CODEGBN" = 'JJ') AND
          ( "CODE" <> '00' ) AND
			 ( "CODE" = :sJikjong);
	IF SQLCA.SQLCode = 0 THEN dw_print.modify("t_jikjong.text = '" + ArgBuf + "'")
END IF

IF sSaup = '' OR IsNull(sSaup) THEN
	sSaup = '%'
	dw_print.modify("t_saup.text = '"+'전체'+"'")
ELSE
	SELECT "SAUPNAME"
     INTO :ArgBuf
     FROM "P0_SAUPCD"
    WHERE ( "SAUPCODE" = :sSaup);
	IF SQLCA.SQLCode = 0 THEN dw_print.modify("t_saup.text = '" + ArgBuf + "'")
END IF

IF sKunmu = '' OR IsNull(sKunmu) THEN
	sKunmu = '%'
	dw_print.modify("t_kunmu.text = '"+'전체'+"'")
ELSE
	SELECT "KUNMUNAME"
     INTO :ArgBuf
     FROM "P0_KUNMU"
    WHERE ( "KUNMUGUBN" = :sKunmu);
	IF SQLCA.SQLCode = 0 THEN dw_print.modify("t_kunmu.text = '" + ArgBuf + "'")
END IF


IF ls_gubun = '' OR IsNull(ls_gubun) THEN ls_gubun = '%'
IF ls_Empno = '' OR ISNULL(ls_Empno) THEN	ls_Empno = '%'




dw_list.SetRedraw(FALSE)
dw_list.reset()

IF dw_print.Retrieve( sYm, sYm, sSaup, ls_gubun, sJikjong, sKunmu, ls_Empno) <=0 THEN
	MessageBox("확 인","조회한 자료가 없습니다!!")
	dw_list.insertrow(0)
END IF

dw_list.SetRedraw(TRUE)
SetPointer(Arrow!)
Return 1
end function

on wp_pip3203.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_2=create dw_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.rr_1
end on

on wp_pip3203.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_1.SetTransObject(sqlca)
dw_2.SetTransObject(sqlca)

dw_ip.SetITem(1,"l_ym",left(f_today(),6))
dw_ip.SetITem(1,"l_gubn",'P')

/*사업장 정보 셋팅*/
f_set_saupcd(dw_ip,'l_saup', '1')
is_saupcd = gs_saupcd

dw_list.insertrow(0)
//dw_list.object.datawindow.print.preview = "yes"
end event

type p_preview from w_standard_print`p_preview within wp_pip3203
integer x = 4027
end type

type p_exit from w_standard_print`p_exit within wp_pip3203
integer x = 4375
end type

type p_print from w_standard_print`p_print within wp_pip3203
integer x = 4201
end type

type p_retrieve from w_standard_print`p_retrieve within wp_pip3203
integer x = 3854
end type

type st_window from w_standard_print`st_window within wp_pip3203
integer x = 2336
integer y = 2584
end type

type sle_msg from w_standard_print`sle_msg within wp_pip3203
integer x = 361
integer y = 2584
end type

type dw_datetime from w_standard_print`dw_datetime within wp_pip3203
integer x = 2830
integer y = 2584
end type

type st_10 from w_standard_print`st_10 within wp_pip3203
integer x = 0
integer y = 2584
end type



type dw_print from w_standard_print`dw_print within wp_pip3203
integer x = 3717
integer y = 60
string dataobject = "dp_pip3203_2_p"
end type

type dw_ip from w_standard_print`dw_ip within wp_pip3203
integer x = 425
integer y = 8
integer width = 3355
integer height = 272
string dataobject = "dp_pip3203_1"
end type

event dw_ip::itemchanged;String sDeptno,sName,snull,sEmpNo,sEmpName, ls_name

SetNull(snull)

This.AcceptText()

IF dw_ip.GetColumnName() = "l_saup" THEN
	is_saupcd = dw_ip.GetText()
	IF is_saupcd = '' OR ISNULL(is_saupcd) THEN is_saupcd = '%'		
END IF	


IF dw_ip.GetColumnName() ="l_dept" THEN 
   sDeptno = dw_ip.GetText()
	IF sDeptno = '' OR ISNULL(sDeptno) THEN
		dw_ip.SetITem(1,"l_dept",snull)
		dw_ip.SetITem(1,"l_deptname",snull)
		Return 
	END IF	
	
	  SELECT  "P0_DEPT"."DEPTNAME"  
		INTO :sName  
		FROM "P0_DEPT"  
		WHERE ( "P0_DEPT"."COMPANYCODE" = :gs_company ) AND  
				( "P0_DEPT"."DEPTCODE" = :sDeptno ); 
	
	IF sName = '' OR ISNULL(sName) THEN
   	MessageBox("확 인","부서번호를 확인하세요!!") 
		dw_ip.SetITem(1,"l_dept",snull)
	   dw_ip.SetITem(1,"l_deptname",snull) 
		dw_ip.SetColumn("l_dept")
      Return 1
	END IF	
	   dw_ip.SetITem(1,"l_deptname",sName) 
END IF
IF dw_ip.GetColumnName() = "l_empno" then
   sEmpNo = dw_ip.GetItemString(1,"l_empno")

	IF sEmpNo = '' or isnull(sEmpNo) THEN
	   dw_ip.SetITem(1,"l_empno",snull)
		dw_ip.SetITem(1,"l_empname",snull)
	ELSE	
			SELECT "P1_MASTER"."EMPNAME"  
				INTO :sEmpName  
				FROM "P1_MASTER"  
				WHERE ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
						( "P1_MASTER"."EMPNO" = :sEmpNo ) ;
			 
			 IF SQLCA.SQLCODE<>0 THEN
				 MessageBox("확 인","사원번호를 확인하세요!!") 
				 dw_ip.SetITem(1,"l_empno",snull)
				 dw_ip.SetITem(1,"l_empname",snull)
				 RETURN 1 
			 END IF
				dw_ip.SetITem(1,"l_empname",sEmpName  )
				
	 END IF
END IF

IF GetColumnName() = "l_empname" then
  sEmpName = GetItemString(1,"l_empname")

   ls_name = wf_exiting_saup_name('empname',sEmpName, '1', is_saupcd)	 
	 if IsNull(ls_name) then 
		 Setitem(1,'l_empname',ls_name)
		 Setitem(1,'l_empno',ls_name)
		 return 1
    end if
	 Setitem(1,"l_empno",ls_name)
	 ls_name = wf_exiting_saup_name('empno',ls_name, '1', is_saupcd)
	 Setitem(1,"l_empname",ls_name)
	 return 1
END IF



end event

event dw_ip::itemerror;Return 1
end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

IF dw_ip.GetColumnName() = "l_dept" THEN
	gs_gubun = is_saupcd
	
	Open(w_dept_saup_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	dw_ip.SetITem(1,"l_dept",gs_code)
	dw_ip.SetITem(1,"l_deptname",gs_codename)
END IF	

IF dw_ip.GetColumnName() = "l_empno" THEN
	gs_gubun = is_saupcd
	
   Open(w_employee_saup_popup)

   if isnull(gs_code) or gs_code = '' then return
   dw_ip.SetITem(1,"l_empno",gs_code)
	dw_ip.SetITem(1,"l_empname",gs_codename)
  
END IF	
end event

type dw_list from w_standard_print`dw_list within wp_pip3203
integer x = 453
integer y = 316
integer width = 3259
integer height = 1952
string dataobject = "dp_pip3203_2"
boolean border = false
boolean hsplitscroll = false
end type

event dw_list::rowfocuschanged;return
end event

event dw_list::clicked;return
end event

type dw_1 from datawindow within wp_pip3203
boolean visible = false
integer x = 553
integer y = 2360
integer width = 914
integer height = 92
boolean bringtotop = true
boolean titlebar = true
string title = "TEXT 찍기용 데이타윈도우(지급)"
string dataobject = "dp_pip3130_30"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_2 from datawindow within wp_pip3203
boolean visible = false
integer x = 1504
integer y = 2360
integer width = 914
integer height = 92
boolean bringtotop = true
boolean titlebar = true
string title = "TEXT 찍기용 데이타윈도우(공제)"
string dataobject = "dp_pip3130_40"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rr_1 from roundrectangle within wp_pip3203
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 448
integer y = 308
integer width = 3273
integer height = 1972
integer cornerheight = 40
integer cornerwidth = 55
end type

