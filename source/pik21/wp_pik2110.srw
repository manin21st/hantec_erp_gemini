$PBExportHeader$wp_pik2110.srw
$PBExportComments$**개인별년간근태현황
forward
global type wp_pik2110 from w_standard_print
end type
type rr_2 from roundrectangle within wp_pik2110
end type
end forward

shared variables
int flag
end variables

global type wp_pik2110 from w_standard_print
string title = "개인별 년간 근태현황"
rr_2 rr_2
end type
global wp_pik2110 wp_pik2110

type variables
string is_timegbn
end variables

forward prototypes
public subroutine wf_janmonthcha ()
public function integer wf_fromtodate (string startdate, string enddate)
public function integer wf_retrieve ()
end prototypes

public subroutine wf_janmonthcha ();int RowCount
string GetDate,sYYMM
string sEmpno,SEndDate
int cDay,bDay,silsu
int janMothcha
string GetEmpno,Maxyymm
string Usekdate
long Usdcday
long CountDay
long sjanYear 
string ToDate

dw_list.setredraw(false)


SEndDate =trim(dw_ip.GetItemString(1,'ymto'))
////p4_monthlist.cday 를 읽어오는데 마지막 달(from -to 에서 to에해당하는 년월) 인
//// 경우에는 (적치일수+발생일수)-월차사용일수(p4_dkentae.ktcode='05')
//// 그 일수가 2보다 큰 경우 "2"로 셋팅
//// 아니면 계산된 일수를 셋팅한다 

FOR RowCount=1 TO dw_list.rowcount()
    GetDate = dw_list.getitemstring(RowCount,"cldate") 
    sEmpno = dw_list.getitemstring(RowCount,"empno") 

			SELECT "P4_MONTHLIST"."CDAY",   
					 "P4_MONTHLIST"."BDAY"   
			INTO :cDay, :bDay 
			FROM "P4_MONTHLIST"  
			WHERE( "P4_MONTHLIST"."COMPANYCODE" = :gs_company ) AND
			     ( "P4_MONTHLIST"."YYMM" = :GetDate ) AND 
			     ( "P4_MONTHLIST"."EMPNO" = :sEmpno )  ;    
			
			IF SQLCA.SQLCODE <> 0 THEN
				   cDay = 0 
				   bDay = 0
			END IF
			
			IF GetDate=SEndDate THEN
		   	
				SELECT count("P4_DKENTAE"."KTCODE") as ilsu  
				INTO :silsu
				FROM "P4_DKENTAE"  
				WHERE ("P4_DKENTAE"."COMPANYCODE" = :gs_company ) AND
						("P4_DKENTAE"."EMPNO" = :sEmpno ) and
						("P4_DKENTAE"."KTCODE"='05') AND
				      (substr("P4_DKENTAE"."KDATE",1,6) = :GetDate )  ;			   
				IF SQLCA.SQLCODE <> 0 THEN
				   silsu = 0
				END IF
   
    	   janMothcha=cDay + bDay - silsu
					IF janMothcha >2 THEN
						dw_list.setitem(RowCount,"janmoncha",'2') 
					ELSE
						dw_list.setitem(RowCount,"janmoncha",string(janMothcha))  
					END IF
			
		   ELSE
					 
					 dw_list.setitem(RowCount,"janmoncha",string(cDay))  
			END IF
	
	///////////////잔여년차  구하기 ///////////
			/// p4_yearlist에서 입력된 from 일자 보다 작거나 같은 년월의 최대값을 구하고 
			///  그해당 월의 사용기간from 필드의 값과 적치일수를 구한다.
			///  사용기간from 날짜와 Report에 나오는 각 Rowd의  년월+'31' (마지막 일짜) 의 범위를 
			///  받아서 count 한후 적치일수에서 빼준다                    
     
	    GetEmpno = dw_list.getitemstring(RowCount,"empno")     
          
			  SELECT max(p4_yearlist.yymm)
            INTO : Maxyymm
				FROM  p4_yearlist
           WHERE  p4_yearlist.companycode =:gs_company AND
			         p4_yearlist.yymm <= : GetDate AND
                              empno = : GetEmpno  ;
           
			  IF SQLCA.SQLCODE <> 0 THEN
				   Maxyymm = string(0) 
			  END IF
			  
			  SELECT p4_yearlist.kdate , p4_yearlist.cday     // 사용기간from 과 적치일수 구하기// 
			   INTO :Usekdate , :Usdcday
				FROM  p4_yearlist
				WHERE p4_yearlist.COMPANYCODE =: gs_company AND
				      p4_yearlist.yymm =: Maxyymm AND 
				                 EMPNO =: GetEmpno ;
			   
		     IF SQLCA.SQLCODE <> 0 THEN
				  Usekdate = string(0)
				  Usdcday = 0
		     END IF
			  
			  		  
			  ToDate = GetDate+'31'
			 
			 SELECT  count(*)
            INTO :CountDay 
				FROM  p4_dkentae
           WHERE  p4_dkentae.COMPANYCODE =: gs_company AND
			         p4_dkentae.empno  =:GetEmpno and
						p4_dkentae.ktcode ='07' and 			      // '년차코드 ='07' 
						p4_dkentae.kdate >=:Usekdate and
                  p4_dkentae.kdate <=:ToDate      ;	  
            
				IF SQLCA.SQLCODE <> 0 THEN
				   CountDay  = 0
		      END IF
			
				
         sjanYear =  Usdcday - CountDay             // count한 값 - 적치일수 = 잔녀년차 
         dw_list.setitem(RowCount,"janYear",string(sjanYear))  

NEXT	
dw_list.setredraw(true)
end subroutine

public function integer wf_fromtodate (string startdate, string enddate);IF StartDate > EndDate then
   MessageBox("확인","시작년월이 종료년월보다 먼저 이어야 합니다")
	Return -1
END IF	
   Return 1
end function

public function integer wf_retrieve ();SetPointer(HourGlass!)

String sStartYear,sEndYear
string sEmpNo, ls_saup

if dw_ip.Accepttext() = -1 then return -1

sStartYear = trim(dw_ip.GetItemString(1,"ymfrom"))
sEndYear   = trim(dw_ip.GetItemString(1,"ymto"))
ls_saup = trim(dw_ip.GetItemString(1, "sabu"))
sEmpno    = trim(dw_ip.GetItemString(1,"empno"))

IF sStartYear = '' or isnull(sStartYear) THEN
	MessageBox("확 인","시작년월을 입력하세요!!")
	dw_ip.SetColumn('ymfrom')
	dw_ip.SetFocus()
	Return -1
END IF

IF sEndYear = '' or isnull(sEndYear) THEN
	MessageBox("확 인","종료년월을 입력하세요!!")
	dw_ip.SetColumn('ymto')
	dw_ip.SetFocus()
	Return -1
END IF

IF sStartYear > sEndYear THEN
	MessageBox("확 인","년월범위를 확인하세요!!")
	dw_ip.SetColumn('ymfrom')
	dw_ip.SetFocus()
	Return -1
END IF 

IF ls_saup = '' OR IsNull(ls_saup) THEN
	ls_saup = '%'
END IF

IF sEmpNo = "" OR IsNull(sEmpNo) THEN
	sEmpNo='%' 
END IF	

IF dw_print.Retrieve(gs_company,sStartYear,sEndYear, ls_saup, sEmpNo, is_timegbn ) <=0 THEN	
	MessageBox("확 인","조회한 자료가 없습니다!!")
	Return -1
//else
   //wf_janmonthcha() 
END IF
   dw_list.Retrieve(gs_company,sStartYear,sEndYear, ls_saup, sEmpNo, is_timegbn )
Return 1


end function

on wp_pik2110.create
int iCurrent
call super::create
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
end on

on wp_pik2110.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_2)
end on

event open;call super::open;dw_print.SharedataOff()
dw_ip.SetItem(1,"ymfrom",left(f_today(),6))
dw_ip.SetItem(1,"ymto",left(f_today(),6))
dw_ip.SetColumn('ymfrom')
dw_ip.SetFocus()

f_set_saupcd(dw_ip, 'sabu', '1')
is_saupcd = gs_saupcd
is_timegbn = f_get_p0_syscnfg(8,'1')
end event

type p_xls from w_standard_print`p_xls within wp_pik2110
end type

type p_sort from w_standard_print`p_sort within wp_pik2110
end type

type p_preview from w_standard_print`p_preview within wp_pik2110
end type

type p_exit from w_standard_print`p_exit within wp_pik2110
end type

type p_print from w_standard_print`p_print within wp_pik2110
end type

type p_retrieve from w_standard_print`p_retrieve within wp_pik2110
end type

type st_window from w_standard_print`st_window within wp_pik2110
boolean visible = false
end type

type sle_msg from w_standard_print`sle_msg within wp_pik2110
boolean visible = false
end type

type dw_datetime from w_standard_print`dw_datetime within wp_pik2110
boolean visible = false
end type

type st_10 from w_standard_print`st_10 within wp_pik2110
boolean visible = false
end type

type gb_10 from w_standard_print`gb_10 within wp_pik2110
boolean visible = false
end type

type dw_print from w_standard_print`dw_print within wp_pik2110
string dataobject = "dp_pik2110_1_p"
end type

type dw_ip from w_standard_print`dw_ip within wp_pik2110
integer x = 73
integer y = 52
integer width = 2793
integer height = 164
string dataobject = "dp_pik2110_2"
end type

event dw_ip::itemchanged;call super::itemchanged;String  sEmpNo,SetNull,sEmpName, ls_Date, ls_name
AcceptText()

IF GetColumnName() = "empno" then
  sEmpNo = GetItemString(1,"empno")

	  IF sEmpNo = '' or isnull(sEmpNo) THEN
		  SetITem(1,"empno",SetNull)
		  SetITem(1,"empname",SetNull)
	  ELSE	
		  IF f_chk_saupemp(sEmpNo, '1', is_saupcd) = False THEN
			  SetItem(getrow(),'empno',SetNull)
			  SetColumn('empno')
			  dw_ip.SetFocus()
			  Return 1
		  END IF			
		
			SELECT "P1_MASTER"."EMPNAME"  
				INTO :sEmpName  
				FROM "P1_MASTER"  
				WHERE ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
						( "P1_MASTER"."EMPNO" = :sEmpNo ) ;
			 
//			 IF SQLCA.SQLCODE<>0 THEN
//				 MessageBox("확 인","사원번호를 확인하세요!!") 
//				 SetITem(1,"empno",SetNull)
//				 SetITem(1,"empname",SetNull)
//				 RETURN 1 
//			 END IF
				SetITem(1,"empname",sEmpName  )
				
	 END IF
END IF
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



IF GetColumnName() = "sabu" THEN
	is_saupcd = this.GetText()
	if IsNull(is_saupcd) or is_saupcd = '' then is_saupcd = '%'
END IF


IF this.GetcolumnName() ="ymfrom" THEN
	IF IsNull(data) OR data ="" THEN
		Return 1
   END IF
	If f_datechk(data+'01') = -1 THEN
		MessageBox("확 인", "출력일자가 부정확합니다.")
		SetItem(getrow(),'ymfrom',SetNull)
		SetColumn('ymfrom')
		dw_ip.SetFocus()
		Return 1
	END IF
END IF


IF this.GetcolumnName() ="ymto" THEN
	IF IsNull(data) OR data ="" THEN
		Return 1
   END IF
	If f_datechk(data+'01') = -1 THEN
		MessageBox("확 인", "출력일자가 부정확합니다.")
		SetItem(getrow(),'ymto',SetNull)
		SetColumn('ymto')
		dw_ip.SetFocus()
		Return 1
	END IF
	ls_date = this.GetItemString(this.GetRow(), 'ymfrom')
	IF long(data) < long(ls_date) THEN
		MessageBox("확 인", "출력일자 범위가 부정확합니다.")
		SetItem(getrow(),'ymto',SetNull)
		SetColumn('ymto')
		dw_ip.SetFocus()
		Return 1
	END IF
END IF
end event

event dw_ip::printstart;call super::printstart;SetNull(Gs_code)
SetNull(Gs_codename)

AcceptText()
IF GetColumnName() = "empno" THEN
	Gs_Codename = this.GetItemString(this.GetRow(),"empno")
	
	open(w_employee_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	SetItem(this.GetRow(),"empno",Gs_code)
	SetItem(this.GetRow(),"empname",Gs_codeName)
	
END IF
end event

event dw_ip::rbuttondown;call super::rbuttondown;SetNull(Gs_code)
SetNull(Gs_codename)
SetNull(Gs_gubun)

AcceptText()
IF GetColumnName() = "empno" THEN
	Gs_Codename = this.GetItemString(this.GetRow(),"empno")
	
	Gs_gubun = is_saupcd
	open(w_employee_saup_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	SetItem(this.GetRow(),"empno",Gs_code)
	SetItem(this.GetRow(),"empname",Gs_codeName)
	
END IF
end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within wp_pik2110
integer x = 105
integer y = 232
integer width = 4393
integer height = 1980
string dataobject = "dp_pik2110_1"
boolean border = false
boolean hsplitscroll = false
end type

type rr_2 from roundrectangle within wp_pik2110
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 82
integer y = 228
integer width = 4434
integer height = 2024
integer cornerheight = 40
integer cornerwidth = 55
end type

