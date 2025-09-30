$PBExportHeader$wp_pip74.srw
$PBExportComments$** 소득자료제출집계표(연말정산용)
forward
global type wp_pip74 from w_standard_print
end type
type rr_1 from roundrectangle within wp_pip74
end type
end forward

global type wp_pip74 from w_standard_print
string title = "소득자료제출집계표"
rr_1 rr_1
end type
global wp_pip74 wp_pip74

forward prototypes
public function integer wf_retrieve ()
public function integer wf_dataset1 (string syymm, string ssaupcd, string skunmu, string ls_jikjong, string sdate)
public function integer wf_dataset2 (string syymm, string ssaupcd, string skunmu, string ls_jikjong, string sdate)
public function integer wf_dataset3 (string syymm, string ssaupcd, string skunmu, string ls_jikjong, string sdate)
public function integer wf_dataset4 (string syymm, string ssaupcd, string skunmu, string ls_jikjong, string sdate)
end prototypes

public function integer wf_retrieve ();string ls_saupno , ls_bubno, ls_bubinname, ls_comname, ls_location, ls_tel,ssogu
string syymm, ssaupcd,sdate, snull, sname, sKunmu, ls_jikjong

dw_list.ReSet()
dw_list.InsertRow(0)

dw_ip.AcceptText()
syymm  = dw_ip.Getitemstring(1,"syymm")
ssaupcd  = dw_ip.Getitemstring(1,"saupcd")
sdate  = dw_ip.Getitemstring(1,"sdate")
sKunmu = trim(dw_ip.GetitemString(1,'kunmu'))
ls_jikjong = trim(dw_ip.GetItemString(1, 'Jikjong'))
ssogu = dw_ip.getitemstring(1,"sogu")

IF ssaupcd = '' or isnull(ssaupcd) then ssaupcd = '%'
IF sKunmu = '' OR IsNull(sKunmu) THEN sKunmu = '%'
IF ls_jikjong = '' or isnull(ls_jikjong) then ls_jikjong = '%'

IF sYymm = '' OR ISNULL(sYymm) OR sYymm = '000000' THEN
   MessageBox("확인","출력년월을 입력하세요")
	dw_ip.setcolumn("syymm")
	dw_ip.SetFocus()
	Return -1
END IF

IF sdate = '' OR ISNULL(sdate) OR sdate = '00000000' THEN
   MessageBox("확인","제출일자를 입력하세요")
	dw_ip.setcolumn("sdate")
	dw_ip.SetFocus()
	Return -1
END IF


choose case  ssogu
	case '1' 
		wf_dataset1(syymm,ssaupcd,skunmu,ls_jikjong,sdate)
	case '2' 
		wf_dataset2(syymm,ssaupcd,skunmu,ls_jikjong,sdate)
	case '3' 
   	wf_dataset3(syymm,ssaupcd,skunmu,ls_jikjong,sdate)
	case '4'
   	wf_dataset4(syymm,ssaupcd,skunmu,ls_jikjong,sdate)		
end choose

Return 1
end function

public function integer wf_dataset1 (string syymm, string ssaupcd, string skunmu, string ls_jikjong, string sdate);double damt1, damt2, damt3, damt4, damt5, damt6, damt7, damt8, damt9, damt10
	int dcount1, dcount2, dcount3, dcount4
	string ls_saupno,ls_bubinname,ls_comname,ls_bubno,ls_location,ls_tel,saccdate

//saccdate = mid(sdate,1,4) + '년' + mid(sdate,5,2) +'월' +mid(sdate,7,2) +'일'
saccdate = sdate

 	SELECT  SUM("P3_ACNT_TAXCAL_DATA"."WORKINCOMEGROSS")+
	        SUM("P3_ACNT_TAXCAL_DATA"."NIGHTWORKPAY")+
  	        SUM("P3_ACNT_TAXCAL_DATA"."ETCTAXFREE"),
         count("P3_ACNT_TAXCAL_DATA"."EMPNO"),
         SUM("P3_ACNT_TAXCAL_DATA"."MEDSUB"),
         SUM(DECODE("P3_ACNT_TAXCAL_DATA"."MEDSUB",0,0,1)),
         SUM("P3_ACNT_TAXCAL_DATA"."RESULTINCOMETAX"),
         SUM("P3_ACNT_TAXCAL_DATA"."PREVINCOMETAX"),
         SUM("P3_ACNT_TAXCAL_DATA"."CURRINCOMETAX"),
			SUM("P3_ACNT_TAXCAL_DATA"."ETCTAXFREE"),
			SUM("P3_ACNT_TAXCAL_DATA"."PURSESUB"),
			SUM(DECODE("P3_ACNT_TAXCAL_DATA"."ETCTAXFREE",0,0,1)),
			SUM(DECODE("P3_ACNT_TAXCAL_DATA"."PURSESUB",0,0,1))
   INTO :damt1,:dcount1,:damt2,:dcount2,:damt3,:damt4,:damt5, :damt8, :damt9, :dcount3,:dcount4
   FROM  "P3_ACNT_TAXCAL_DATA", p1_master, P0_DEPT, P0_SAUPCD
 	WHERE ( "P3_ACNT_TAXCAL_DATA"."WORKYEAR" = :syymm ) AND  
       ( "P3_ACNT_TAXCAL_DATA"."TAG" = '1' ) AND  
       ( "P3_ACNT_TAXCAL_DATA"."WORKINCOMEGROSS" >= 0 )  and
		 "P3_ACNT_TAXCAL_DATA"."EMPNO" = p1_master.empno and
		 p1_master.deptcode = p0_dept.deptcode and  
       P0_DEPT.COMPANYCODE = P0_SAUPCD.COMPANYCODE AND   
       P0_DEPT.SAUPCD = P0_SAUPCD.SAUPCODE AND
		 P0_DEPT.SAUPCD LIKE :ssaupcd AND
		 p1_master.kunmugubn LIKE :sKunmu AND
		 p1_master.jikjonggubn LIKE :ls_jikjong;
		 
	IF isnull(damt1) then damt1 =  0
	IF isnull(damt2) then damt2 =  0
	IF isnull(damt3) then damt3 =  0
	IF isnull(damt4) then damt4 =  0
	IF isnull(damt5) then damt5 =  0
	IF isnull(damt8) then damt8 =  0
	IF isnull(damt9) then damt9 =  0
	IF isnull(dcount1) then dcount1 =  0
	IF isnull(dcount2) then dcount2 =  0
	IF isnull(dcount3) then dcount1 =  0
	IF isnull(dcount4) then dcount2 =  0
	
	IF sqlca.sqlcode <> 0 THEN
		damt1 = 0
		damt2 = 0
		damt3 = 0
	   damt4 = 0 
	   damt5 = 0 	
		damt8 = 0
		damt9 = 0
		dcount1 = 0  
		dcount2 = 0  	
		dcount3 = 0  
		dcount4 = 0  	
	END IF	
		 
		SELECT sum("P3_ACNT_TAXCAL_DATA"."RESULTINCOMETAX"),
               sum("P3_ACNT_TAXCAL_DATA"."RESULTSPECIALTAX"),
               sum("P3_ACNT_TAXCAL_DATA"."RESULTRESIDENTTAX")
 	 INTO :damt6,
              :damt7,
              :damt8
	  FROM "P3_ACNT_TAXCAL_DATA", p1_master, P0_DEPT, P0_SAUPCD
	 WHERE ( "P3_ACNT_TAXCAL_DATA"."WORKYEAR" = :syymm ) AND  
       ( "P3_ACNT_TAXCAL_DATA"."TAG" = '1' ) AND  
		 "P3_ACNT_TAXCAL_DATA"."EMPNO" = p1_master.empno and
		 p1_master.deptcode = p0_dept.deptcode and  
       P0_DEPT.COMPANYCODE = P0_SAUPCD.COMPANYCODE AND   
       P0_DEPT.SAUPCD = P0_SAUPCD.SAUPCODE AND
		 P0_DEPT.SAUPCD LIKE :ssaupcd AND
		 p1_master.kunmugubn LIKE :sKunmu AND
		 p1_master.jikjonggubn LIKE :ls_jikjong;
		 
	IF isnull(damt6) then damt6 =  0
	
	IF sqlca.sqlcode <> 0 THEN
		damt6 = 0
	END IF

IF dcount1 = 0 then 
	Messagebox("확인","출력할 자료가 없습니다")
	dw_list.ReSet()
	dw_list.InsertRow(0)
	dw_ip.setfocus()
	return -1
END IF

dw_list.SetItem(1,"f7",saccdate)
dw_list.SetItem(1,"f16",syymm)
dw_list.SetItem(1,"f10",1)
dw_list.SetItem(1,"f11",dcount1)
dw_list.SetItem(1,"f12",damt1)
dw_list.SetItem(1,"f13",damt6)
dw_list.SetItem(1,"f14",damt7)
dw_list.SetItem(1,"f15",damt8)

/*원천징수의무자*/
  SELECT SAUPNO, JURNAME, CHAIRMAN, JURNO, ADDR, PHONE
    INTO :ls_saupno,			//사업자등록번호
	 		:ls_bubinname,		//법인명
			:ls_comname,		//대표자명
			:ls_bubno,			//법인등록번호
			:ls_location,		//주소
			:ls_tel				//전화번호
    FROM "P0_SAUPCD"
   WHERE COMPANYCODE = 'KN' AND
			SAUPCODE = DECODE(:sSaupcd,'%','10',:sSaupcd);

IF SQLCA.SQLcode <> 0 THEN
	MessageBox('','원천징수의무자의 정보를 찾을 수 없습니다.')
	RETURN -1
END IF

dw_list.SetItem(1,"f1",ls_saupno)
dw_list.SetItem(1,"f8",ls_bubno)
dw_list.SetItem(1,"f3",ls_bubinname)
dw_list.SetItem(1,"f4",ls_comname)
dw_list.SetItem(1,"f5",ls_location)
dw_list.SetItem(1,"f6",ls_tel)
//dw_list.modify("t_4.text='(연말정산자료용)'")
dw_list.modify("t_12.text='연말소득'")
return 1


end function

public function integer wf_dataset2 (string syymm, string ssaupcd, string skunmu, string ls_jikjong, string sdate);double damt1, damt2, damt3, damt4, damt5, damt6, damt7, damt8, damt9, damt10
	int dcount1, dcount2, dcount3, dcount4
	string ls_saupno,ls_bubinname,ls_comname,ls_bubno,ls_location,ls_tel,saccdate

//saccdate = mid(sdate,1,4) + '년' + mid(sdate,5,2) +'월' +mid(sdate,7,2) +'일'
saccdate = sdate

 	SELECT  SUM("P3_ACNT_TAXCAL_DATA"."WORKINCOMEGROSS")+
	        SUM("P3_ACNT_TAXCAL_DATA"."NIGHTWORKPAY")+
  	        SUM("P3_ACNT_TAXCAL_DATA"."ETCTAXFREE"),
         count("P3_ACNT_TAXCAL_DATA"."EMPNO"),
         SUM("P3_ACNT_TAXCAL_DATA"."MEDSUB"),
         SUM(DECODE("P3_ACNT_TAXCAL_DATA"."MEDSUB",0,0,1)),
         SUM("P3_ACNT_TAXCAL_DATA"."RESULTINCOMETAX"),
         SUM("P3_ACNT_TAXCAL_DATA"."PREVINCOMETAX"),
         SUM("P3_ACNT_TAXCAL_DATA"."CURRINCOMETAX"),
			SUM("P3_ACNT_TAXCAL_DATA"."ETCTAXFREE"),
			SUM("P3_ACNT_TAXCAL_DATA"."PURSESUB"),
			SUM(DECODE("P3_ACNT_TAXCAL_DATA"."ETCTAXFREE",0,0,1)),
			SUM(DECODE("P3_ACNT_TAXCAL_DATA"."PURSESUB",0,0,1))
   INTO :damt1,:dcount1,:damt2,:dcount2,:damt3,:damt4,:damt5, :damt8, :damt9, :dcount3,:dcount4
   FROM  "P3_ACNT_TAXCAL_DATA", p1_master, P0_DEPT, P0_SAUPCD
 	WHERE ( "P3_ACNT_TAXCAL_DATA"."WORKYEAR" = :syymm ) AND  
       ( "P3_ACNT_TAXCAL_DATA"."TAG" = '2' ) AND  
       ( "P3_ACNT_TAXCAL_DATA"."WORKINCOMEGROSS" >= 0 )  and
		 "P3_ACNT_TAXCAL_DATA"."EMPNO" = p1_master.empno and
		 p1_master.deptcode = p0_dept.deptcode and  
       P0_DEPT.COMPANYCODE = P0_SAUPCD.COMPANYCODE AND   
       P0_DEPT.SAUPCD = P0_SAUPCD.SAUPCODE AND
		 P0_DEPT.SAUPCD LIKE :ssaupcd AND
		 p1_master.kunmugubn LIKE :sKunmu AND
		 p1_master.jikjonggubn LIKE :ls_jikjong;
		 
	IF isnull(damt1) then damt1 =  0
	IF isnull(damt2) then damt2 =  0
	IF isnull(damt3) then damt3 =  0
	IF isnull(damt4) then damt4 =  0
	IF isnull(damt5) then damt5 =  0
	IF isnull(damt8) then damt8 =  0
	IF isnull(damt9) then damt9 =  0
	IF isnull(dcount1) then dcount1 =  0
	IF isnull(dcount2) then dcount2 =  0
	IF isnull(dcount3) then dcount1 =  0
	IF isnull(dcount4) then dcount2 =  0
	
	IF sqlca.sqlcode <> 0 THEN
		damt1 = 0
		damt2 = 0
		damt3 = 0
	   damt4 = 0 
	   damt5 = 0 	
		damt8 = 0
		damt9 = 0
		dcount1 = 0  
		dcount2 = 0  	
		dcount3 = 0  
		dcount4 = 0  	
	END IF	
		 
		SELECT sum("P3_ACNT_TAXCAL_DATA"."RESULTINCOMETAX"),
               sum("P3_ACNT_TAXCAL_DATA"."RESULTSPECIALTAX"),
               sum("P3_ACNT_TAXCAL_DATA"."RESULTRESIDENTTAX")
 	 INTO :damt6,
              :damt7,
              :damt8
	  FROM "P3_ACNT_TAXCAL_DATA", p1_master, P0_DEPT, P0_SAUPCD
	 WHERE ( "P3_ACNT_TAXCAL_DATA"."WORKYEAR" = :syymm ) AND  
       ( "P3_ACNT_TAXCAL_DATA"."TAG" = '2' ) AND 
		 "P3_ACNT_TAXCAL_DATA"."EMPNO" = p1_master.empno and
		 p1_master.deptcode = p0_dept.deptcode and  
       P0_DEPT.COMPANYCODE = P0_SAUPCD.COMPANYCODE AND   
       P0_DEPT.SAUPCD = P0_SAUPCD.SAUPCODE AND
		 P0_DEPT.SAUPCD LIKE :ssaupcd AND
		 p1_master.kunmugubn LIKE :sKunmu AND
		 p1_master.jikjonggubn LIKE :ls_jikjong;
		 
	IF isnull(damt6) then damt6 =  0
	
	IF sqlca.sqlcode <> 0 THEN
		damt6 = 0
	END IF

IF dcount1 = 0 then 
	Messagebox("확인","출력할 자료가 없습니다")
	dw_list.ReSet()
	dw_list.InsertRow(0)
	dw_ip.setfocus()
	return -1
END IF

dw_list.SetItem(1,"f7",saccdate)
dw_list.SetItem(1,"f16",syymm)
dw_list.SetItem(1,"f10",1)
dw_list.SetItem(1,"f11",dcount1)
dw_list.SetItem(1,"f12",damt1)
dw_list.SetItem(1,"f13",damt6)
dw_list.SetItem(1,"f14",damt7)
dw_list.SetItem(1,"f15",damt8)


/*원천징수의무자*/
  SELECT SAUPNO, JURNAME, CHAIRMAN, JURNO, ADDR, PHONE
    INTO :ls_saupno,			//사업자등록번호
	 		:ls_bubinname,		//법인명
			:ls_comname,		//대표자명
			:ls_bubno,			//법인등록번호
			:ls_location,		//주소
			:ls_tel				//전화번호
    FROM "P0_SAUPCD"
   WHERE COMPANYCODE = 'KN' AND
			SAUPCODE = DECODE(:sSaupcd,'%','10',:sSaupcd);

IF SQLCA.SQLcode <> 0 THEN
	MessageBox('','원천징수의무자의 정보를 찾을 수 없습니다.')
	RETURN -1
END IF

dw_list.SetItem(1,"f1",ls_saupno)
dw_list.SetItem(1,"f8",ls_bubno)
dw_list.SetItem(1,"f3",ls_bubinname)
dw_list.SetItem(1,"f4",ls_comname)
dw_list.SetItem(1,"f5",ls_location)
dw_list.SetItem(1,"f6",ls_tel)
//dw_list.modify("t_4.text='(중도정산자료용)'")
dw_list.modify("t_12.text='중도소득'")

return 1


end function

public function integer wf_dataset3 (string syymm, string ssaupcd, string skunmu, string ls_jikjong, string sdate);string ls_saupno,ls_bubno,ls_comname,ls_bubinname,ls_location,ls_tel,saccdate
double dcount1,damt1,damt2,damt3,damt4,damt5

//saccdate = mid(sdate,1,4) + '년' + mid(sdate,5,2) +'월' +mid(sdate,7,2) +'일'
saccdate = sdate

select saupno,         
       jurno,
		 chairman,
		 jurname,
		 addr,
		 phone
INTO :ls_saupno,			//사업자등록번호
	  :ls_bubno,			//법인등록번호
	  :ls_comname,		//대표자명
	  :ls_bubinname,		//법인명
	  :ls_location,		//주소
	  :ls_tel				//전화번호
 FROM P0_SAUPCD
 WHERE COMPANYCODE = 'KN' AND
			SAUPCODE = DECODE(:sSaupcd,'%','10',:sSaupcd);
			
IF SQLCA.SQLcode <> 0 THEN
	MessageBox('','원천징수의무자의 정보를 찾을 수 없습니다.')
	RETURN -1
END IF

select count(a.empno),
       sum(a.retireincomeearnamt),
       SUM(a.balanceincometax),
       sum(a.balanceresidenttax)
 into :dcount1,
      :damt1,
      :damt2,
      :damt3
from p3_retirementpay a, p1_master, P0_DEPT, P0_SAUPCD
where substr(a.todate,1,4) = :syymm  and 
      a.empno= p1_master.empno and
		p1_master.deptcode = p0_dept.deptcode and
		P0_DEPT.COMPANYCODE = P0_SAUPCD.COMPANYCODE AND
		P0_DEPT.SAUPCD = P0_SAUPCD.SAUPCODE AND
		P0_DEPT.SAUPCD LIKE :ssaupcd AND
		p1_master.kunmugubn LIKE :sKunmu AND
		p1_master.jikjonggubn LIKE :ls_jikjong;
      
IF dcount1 = 0 then 
	Messagebox("확인","출력할 자료가 없습니다")
	dw_list.ReSet()
	dw_list.InsertRow(0)
	dw_ip.setfocus()
	return -1
END IF

dw_list.SetItem(1,"f1",ls_saupno)
dw_list.SetItem(1,"f8",ls_bubno)
dw_list.SetItem(1,"f3",ls_bubinname)
dw_list.SetItem(1,"f4",ls_comname)
dw_list.SetItem(1,"f5",ls_location)
dw_list.SetItem(1,"f6",ls_tel)
dw_list.SetItem(1,"f10",1)
dw_list.SetItem(1,"f10",1)
dw_list.SetItem(1,"f11",dcount1)
dw_list.SetItem(1,"f12",damt1)
dw_list.SetItem(1,"f13",damt2)
dw_list.SetItem(1,"f15",damt3)
dw_list.SetItem(1,"f7",saccdate)
dw_list.SetItem(1,"f16",syymm)
//dw_list.modify("t_4.text='(퇴직정산자료용)'")
dw_list.modify("t_12.text='퇴직소득'")

return 0

end function

public function integer wf_dataset4 (string syymm, string ssaupcd, string skunmu, string ls_jikjong, string sdate);string ls_saupno,ls_bubno,ls_comname,ls_bubinname,ls_location,ls_tel,saccdate
double dcount1,damt1,damt2,damt3,damt4,damt5

//saccdate = mid(sdate,1,4) + '년' + mid(sdate,5,2) +'월' +mid(sdate,7,2) +'일'
saccdate = sdate

select saupno,         
       jurno,
		 chairman,
		 jurname,
		 addr,
		 phone
INTO :ls_saupno,			//사업자등록번호
	  :ls_bubno,			//법인등록번호
	  :ls_comname,		//대표자명
	  :ls_bubinname,		//법인명
	  :ls_location,		//주소
	  :ls_tel				//전화번호
 FROM P0_SAUPCD
 WHERE COMPANYCODE = 'KN' AND
			SAUPCODE = DECODE(:sSaupcd,'%','10',:sSaupcd);
			
IF SQLCA.SQLcode <> 0 THEN
	MessageBox('','원천징수의무자의 정보를 찾을 수 없습니다.')
	RETURN -1
END IF

select count(a.empno),
       sum(a.payamt),
       SUM(a.incometaxamt),
       sum(a.residenttaxamt)
 into :dcount1,
      :damt1,
      :damt2,
      :damt3
from p3_saupamt a, p3_saupmaster b
where substr(a.workym,1,4) = :syymm  and 
      a.empno= b.empno and
		b.saupcd LIKE :ssaupcd;
      
IF dcount1 = 0 then 
	Messagebox("확인","출력할 자료가 없습니다")
	dw_list.ReSet()
	dw_list.InsertRow(0)
	dw_ip.setfocus()
	return -1
END IF

dw_list.SetItem(1,"f1",ls_saupno)
dw_list.SetItem(1,"f8",ls_bubno)
dw_list.SetItem(1,"f3",ls_bubinname)
dw_list.SetItem(1,"f4",ls_comname)
dw_list.SetItem(1,"f5",ls_location)
dw_list.SetItem(1,"f6",ls_tel)
dw_list.SetItem(1,"f10",1)
dw_list.SetItem(1,"f10",1)
dw_list.SetItem(1,"f11",dcount1)
dw_list.SetItem(1,"f12",damt1)
dw_list.SetItem(1,"f13",damt2)
dw_list.SetItem(1,"f15",damt3)
dw_list.SetItem(1,"f7",saccdate)
dw_list.SetItem(1,"f16",syymm)
//dw_list.modify("t_4.text='(사업소득자료용)'")
dw_list.modify("t_12.text='사업소득'")

return 0

end function

on wp_pip74.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on wp_pip74.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_list.InsertRow(0)
dw_ip.accepttext()
dw_ip.setitem(1,"syymm",left(f_today(),4))
dw_ip.setitem(1,"sdate",f_last_date(dw_ip.getitemstring(1, "syymm") + '01'))

f_set_saupcd(dw_ip, 'saupcd', '1')
is_saupcd = gs_saupcd

end event

type p_preview from w_standard_print`p_preview within wp_pip74
integer x = 4078
end type

event p_preview::clicked;OpenWithParm(w_print_preview, dw_list)	
end event

type p_exit from w_standard_print`p_exit within wp_pip74
integer x = 4425
end type

type p_print from w_standard_print`p_print within wp_pip74
integer x = 4251
end type

event p_print::clicked;call super::clicked;IF dw_list.rowcount() > 0 then 
	gi_page = dw_list.GetItemNumber(1,"last_page")
ELSE
	gi_page = 1
END IF
OpenWithParm(w_print_options, dw_list)
end event

type p_retrieve from w_standard_print`p_retrieve within wp_pip74
integer x = 3904
end type

type st_window from w_standard_print`st_window within wp_pip74
boolean visible = false
end type

type sle_msg from w_standard_print`sle_msg within wp_pip74
boolean visible = false
end type

type dw_datetime from w_standard_print`dw_datetime within wp_pip74
boolean visible = false
end type

type st_10 from w_standard_print`st_10 within wp_pip74
boolean visible = false
end type

type gb_10 from w_standard_print`gb_10 within wp_pip74
boolean visible = false
end type

type dw_print from w_standard_print`dw_print within wp_pip74
string dataobject = "dp_pip74_2"
end type

type dw_ip from w_standard_print`dw_ip within wp_pip74
integer y = 12
integer width = 3502
integer height = 280
string dataobject = "dp_pip74_1"
end type

event dw_ip::itemchanged;string syymm, ssaupcd, sdatagubn, sdate, snull,sname

setnull(snull)

dw_ip.AcceptText()

IF this.GetColumnName() = 'saupcd' THEN
	is_saupcd = this.GetText()
	
	IF is_saupcd = '' OR IsNull(is_saupcd) THEN is_saupcd = '%'
END IF

IF this.getcolumnname() = "syymm" THEN
	syymm = this.gettext()
	IF syymm = '' or isnull(syymm) THEN
		Messagebox("확인","출력년월을 입력하십시오")
		this.setcolumn("syymm")
		this.setfocus()
		return 1
	END IF		
end if
	
if dwo.Name = 'syymm' then
	dw_ip.setitem(1,"sdate",f_last_date(dw_ip.getitemstring(1, "syymm") + '01'))
   dw_ip.settransobject(sqlca)
end if

IF dwo.name = 'sogu' THEN
	p_retrieve.TriggerEvent(Clicked!)
END IF
	
//IF this.getcolumnname() = "syymm" THEN
//	sdate = f_last_date(dw_ip.getitemstring(1, "syymm") + '01')
//	IF syymm = '' or isnull(syymm) THEN	return 
//	
//	IF f_datechk(sdate) = -1 THEN
//		MessageBox("확인","제출일자를 확인하세요")
//		dw_ip.SetColumn("sdate")
//		dw_ip.setitem(1,"sdate",snull)	
//	   dw_ip.SetFocus()
//		Return 1
////	END IF
//	
//END IF
//
end event

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within wp_pip74
integer x = 64
integer y = 324
integer width = 3456
integer height = 2008
string dataobject = "dp_pip74_2"
boolean border = false
end type

event dw_list::rowfocuschanged;//Override Script
if currentrow <=0 then return


end event

event dw_list::clicked;//Override Script
if row <= 0 then return


end event

type rr_1 from roundrectangle within wp_pip74
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 16777215
integer x = 55
integer y = 316
integer width = 3479
integer height = 2028
integer cornerheight = 40
integer cornerwidth = 55
end type

