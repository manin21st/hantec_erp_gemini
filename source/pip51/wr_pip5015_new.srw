$PBExportHeader$wr_pip5015_new.srw
$PBExportComments$** 퇴직금 추계액 명세서(사용)
forward
global type wr_pip5015_new from w_standard_print
end type
type rr_3 from roundrectangle within wr_pip5015_new
end type
end forward

global type wr_pip5015_new from w_standard_print
integer x = 0
integer y = 0
integer height = 2448
string title = "퇴직금 추계액 명세서"
rr_3 rr_3
end type
global wr_pip5015_new wr_pip5015_new

type variables
long ll_year, ll_month, ll_day
end variables

forward prototypes
public function integer wf_insert_retireamt ()
public subroutine wf_calc_year (string ar_date, string ar_yymm)
public function integer wf_excel_save (ref datawindow adw_sheet, string as_filename)
public function integer wf_retrieve ()
end prototypes

public function integer wf_insert_retireamt ();string syymm,ayymm, sempno
double pay1,pay2,pay3,bonus,yamt,chamt,schuamt,sjikamt,schungamt,jiamt,jayear, kayear
int lrow, cnt,i

syymm = dw_ip.GetItemString(1,'yymm')
ayymm = f_aftermonth(syymm,-1)

i = 1
 
For lrow = 1 to dw_list.rowcount()
	
	sle_msg.text = string(i)+'건 업로드중.....!'
		 i = i + 1                                   
	sempno = dw_list.Getitemstring(lrow,"empno")
	pay1 = dw_list.GetitemNumber(lrow, "pay1")
	pay2 = dw_list.GetitemNumber(lrow, "pay2")
	pay3 = dw_list.GetitemNumber(lrow, "pay3")
	bonus = dw_list.GetitemNumber(lrow, "tbonus")
	yamt  = dw_list.GetitemNumber(lrow, "yearpay")
	chamt = dw_list.GetitemNumber(lrow, "chuamt")
	jiamt = dw_list.GetitemNumber(lrow, "jikumamt")
	jayear = dw_list.GetitemNumber(lrow, "jajikyear")
	kayear = dw_list.GetitemNumber(lrow, "kayear")
	
			
	select nvl(chugaeamt,0) into :schuamt                            //전달의 추계액
	from p1_retireamt
	where companycode = :gs_company and yymm = :ayymm and empno = :sempno;
	
	if sqlca.sqlcode <> 0 then schuamt = 0
	
	select nvl(sum(jikumamt),0) into :sjikamt                        //당월까지의 퇴직금지급액
	from p1_retireamt
	where companycode = :gs_company and yymm <= :syymm and empno = :sempno;
	
	if sqlca.sqlcode <> 0 then sjikamt = 0
			
	select nvl(sum(chungamt),0) into :schungamt                      //전월까지의 퇴직금충당금액
	from p1_retireamt
	where companycode = :gs_company and yymm <= :ayymm and empno = :sempno;		
	
	if sqlca.sqlcode <> 0 then schungamt = 0
	
  schungamt =	((((chamt - schuamt) + sjikamt ) / 12 ) * long(right(syymm,2)) ) - schungamt
  
  schungamt = round(schungamt,0)
  
  
        select count(*) 	into :cnt		 
			from p1_retireamt
			where companycode = :gs_company and yymm = :syymm and empno = :sempno;
			
		IF cnt > 0 then	
		  UPDATE P1_RETIREAMT
        SET PAMT1 = :pay1,
		      PAMT2 = :pay2,
				PAMT3 = :pay3,
				TOTBONUS = :bonus,
				YEARAMT = :yamt,
				CHUGAEAMT = :chamt,
				CHUNGAMT = :schungamt,
				CHAAMT = :schuamt - :chamt 
		  where companycode = :gs_company and
					yymm = :syymm and
					empno = :sempno;
			
		ELSE
				
			INSERT INTO "P1_RETIREAMT"
						("COMPANYCODE",    "YYMM",   "EMPNO",     "PAMT1",    "PAMT2",   "PAMT3", "TOTBONUS",
						   "JAJIKYEAR",  "KAYEAR", "YEARAMT", "CHUGAEAMT", "JIKUMAMT", "CHUNGAMT","CHAAMT" )
			VALUES  (  :gs_company,     :syymm,   :sempno,       :pay1,      :pay2,     :pay3,	   :bonus,	 
						      :jayear,    :kayear,     :yamt,      :chamt,     :jiamt, :schungamt,:schuamt - :chamt );
		END IF
		
		
		if sqlca.sqlcode <> 0 then
			return -1
		end if
	

Next	
commit;
return 1
end function

public subroutine wf_calc_year (string ar_date, string ar_yymm);////////////////////////////////////////////////////////////////////////////////////
//           근무일수 Return....                                                  //  
//           Error 시   -1  Return...........................                     //
////////////////////////////////////////////////////////////////////////////////////

String  s_empno , s_entdate, gubun, won_date
dec syear, syear2
INTEGER   CNT, iyear, iyear2,i,imrtn,smonth
datetime arg_enterDate,arg_retireDate

//DELETE FROM "P3_RETIREYEAR_TEMP"  
//WHERE "P3_RETIREYEAR_TEMP"."COMPANYCODE" = :gs_company   ;
//commit ;

i = 1 
DECLARE cur_master CURSOR FOR  
 SELECT "P1_MASTER"."EMPNO",   
        DECODE(FUN_GET_RETCALCDATE( "P1_MASTER"."COMPANYCODE","P1_MASTER"."EMPNO",:ar_date),'00000000', 
				   "P1_MASTER"."ENTERDATE",
					to_char(to_date(FUN_GET_RETCALCDATE("P1_MASTER"."COMPANYCODE","P1_MASTER"."EMPNO",:ar_date),'YYYYMMDD' ) +1 ,'YYYYMMDD')) AS STRDATE ,
			"P0_LEVEL"."GUBUN"		
   FROM "P1_MASTER" ,"P0_LEVEL"
	where ( "P1_MASTER"."COMPANYCODE" = :gs_company )and
         ( "P1_MASTER"."LEVELCODE" = "P0_LEVEL"."LEVELCODE" )and
	      ( "P1_MASTER"."ENTERDATE" <= :ar_date) and
         ( "P1_MASTER"."SERVICEKINDCODE" <> '3' ) 	;


OPEN cur_master;
	DO WHILE TRUE
		FETCH cur_master INTO :s_empno, :s_entdate ,:gubun;
		IF SQLCA.SQLCODE <> 0 THEN EXIT
		
		sle_msg.text = string(i)+'명 계산중.....!'
		 i = i + 1                                                 
//		select p0_level.gubun into :gubun                    //임원구분('0':임원, '1':직원)
//		from p1_master, p0_level
//		where p1_master.companycode = :gs_company and
//		      p1_master.levelcode = p0_level.levelcode and
//				p1_master.empno = :s_empno;
//				
//		if sqlca.sqlcode <> 0 then		
//		   gubun = '1'
//		end if
//		
	
		
if gubun = '0' then                     //임원인 사람은 임원발령일부터
//imrtn = sqlca.fun_create_retirekunyear(gs_company,s_empno, s_entdate, ar_date);
//			select p1_orders.orderdate into :s_entdate
//			from p1_orders, p0_level
//			where p1_orders.companycode = :gs_company and
//			      p1_orders.levelcode = p0_level.levelcode and
//					p0_level.gubun = '0';
//	  	end if
//       
//		iyear = f_calc_year_cnt(s_entdate, ar_date, 'Y') 
//		syear = DaysAfter(Date(Left(s_entdate,4)+"/"+Mid(s_entdate,5,2)+"/"+Right(s_entdate,2)),&
//					Date(Left(ar_date,4)+"/"+Mid(ar_date,5,2)+"/"+Right(ar_date,2))) +1
//					
//		syear = round( syear / 365, 2)			
//    			
//		if gubun = '0' and ar_date > '19991231' then 
//			won_date = ar_date
//			ar_date = '19991231'		
end if		
		syear = f_calc_year_cnt(s_entdate, ar_date, 'Y')	
		smonth = f_calc_year_cnt(s_entdate, ar_date, 'M')	
//		syear2 = DaysAfter(Date(Left(s_entdate,4)+"/"+Mid(s_entdate,5,2)+"/"+Right(s_entdate,2)),&
//					Date(Left(ar_date,4)+"/"+Mid(ar_date,5,2)+"/"+Right(ar_date,2))) +1
//					
//		syear2 = round( syear2 / 365, 2)		
//		  ar_date = won_date		
//		end if
		
				//자사기준 근속년수
				long retireyear,addyear
				
			
				
					SELECT "P3_RETIRERATE"."RETIREYEAR",   
							 "P3_RETIRERATE"."ADDYEAR"  
					 INTO  :retireyear , :addyear 		 
					 FROM "P3_RETIRERATE"  
					WHERE ( "P3_RETIRERATE"."COMPANYCODE" = :gs_company ) AND  
							( "P3_RETIRERATE"."YEAR" = :syear )   ;
							
				
				
				IF sqlca.sqlcode <> 0 then
					addyear = 0
				else
					retireyear = syear + retireyear
				end if		
				

						 
			select count(*) 	into :cnt		 
			from p1_retireamt
			where companycode = :gs_company and yymm = :ar_yymm and empno = :s_empno;
			
			IF cnt > 0 then
				  UPDATE "P1_RETIREAMT"  
                SET "JAJIKYEAR" = :smonth,   
                     "KAYEAR" = :retireyear
					WHERE "COMPANYCODE" = :gs_company and "YYMM" = :ar_yymm and "EMPNO" = :s_empno;
					
			ELSE
				
				INSERT INTO "P1_RETIREAMT"
								("COMPANYCODE", "YYMM",   "EMPNO",    "PAMT1",    "PAMT2",   "PAMT3", "TOTBONUS",
								 "JAJIKYEAR", "KAYEAR", "YEARAMT","CHUGAEAMT", "JIKUMAMT", "CHUNGAMT" )
				VALUES  (  :gs_company,   :ar_yymm,  :s_empno,          0,          0,          0,			0,	 
							  :smonth,       :retireyear,         0,          0,          0,          0);
			END IF

LOOP
CLOSE cur_master;
commit;
end subroutine

public function integer wf_excel_save (ref datawindow adw_sheet, string as_filename);/*****************************************************************************/
/* DESC     : DATA WINDOW EXCEL SAVE                                         */
/* 작성일자 : 2002.05.21(jhj)                                                */ 
/* 처리내역 : DATAWINDOW를  excel 로 save 처리 한다                          */
/*****************************************************************************/

STRING     ls_key,ls_get_pos, ls_pos, ls_today, ls_file_name, spath
Integer    value

ls_today = String(Today(),'yyyymmddhhmmss')


// text type file save

IF adw_sheet.SaveAsAscii(as_filename) <> 1 Then
 Messagebox('확인','자료 저장중 오류가 발생 하였습니다')
 Return -1
END IF


//// ole object make and connect
//OleObject myOleObject
//myOleObject = Create OleObject
//value = myOleObject.ConnectToNewObject( "excel.application" )
//IF value <> 0 Then
// Messagebox("excel.application error", value)
// myOleObject.Close()
// Destroy myoleobject
// Return -1
//End IF
//
//// ole object open and save excel format
//myOleObject.WorkBooks.Open("c:\erpman\" + as_filename+"_" + ls_today + ".txt")
//myoleobject.application.workbooks(1).saveas("c:\erpman\" + as_filename+"_" + ls_today + ".xls",-4143)
//myOleObject.Application.Quit
//myoleobject.DisConnectObject()
//Destroy myoleobject



Return 1
end function

public function integer wf_retrieve ();string syymm, sdate, sm1,sm2, sm3, frdate, todate, ymonth, sjik, ssaup
int ibase, imper,iRtnValue

if dw_ip.Accepttext() = -1 then return -1

syymm = dw_ip.getitemstring(1,'yymm')
sdate = dw_ip.getitemstring(1,'gijunday')
sm1 = dw_ip.getitemstring(1,'m1')
sm2 = dw_ip.getitemstring(1,'m2')
sm3 = dw_ip.getitemstring(1,'m3')
todate = dw_ip.getitemstring(1,'yymm')
sjik = dw_ip.getitemstring(1,'jik')
ssaup = dw_ip.getitemstring(1,'saup')

if IsNull(syymm) or syymm = '' then
	messagebox("확인","계산년월을 입력하십시요!")
	return -1 
else
	if f_datechk(syymm + '01')  = -1 then
		messagebox("확인","계산년월을 확인하십시요!")
		return -1 
	end if
end if
if IsNull(sdate) or sdate = '' then
	messagebox("확인","근속기준일을 입력하십시요!")
	return -1 
else
	if f_datechk(sdate)  = -1 then
		messagebox("확인","근속기준일을 확인하십시요!")
		return -1 
	end if
end if
if IsNull(sm1) or sm1 = '' then
	messagebox("확인","기준년월을 입력하십시요!")
	return -1 
else
	if f_datechk(sm1 + '01')  = -1 then
		messagebox("확인","기준년월을 확인하십시요!")
		return -1 
	end if
end if
if IsNull(sm2) or sm2 = '' then
	messagebox("확인","기준년월을 입력하십시요!")
	return -1 
else
	if f_datechk(sm2 + '01')  = -1 then
		messagebox("확인","기준년월을 확인하십시요!")
		return -1 
	end if
end if
if IsNull(sm3) or sm3 = '' then
	messagebox("확인","기준년월을 입력하십시요!")
	return -1 
else
	if f_datechk(sm3 + '01')  = -1 then
		messagebox("확인","기준년월을 확인하십시요!")
		return -1 
	end if
end if

if IsNull(todate) or todate = '' then	
else
	frdate = f_aftermonth(todate,-11)
end if

if IsNull(sjik) or sjik = '' then sjik = '%'
if IsNull(ssaup) or ssaup = '' then ssaup = '%'                                                       

setpointer(HourGlass!)
w_mdi_frame.sle_msg.text = '근속년수 계산중...............!!'

iRtnValue = sqlca.fun_retirechu_year(gs_company,syymm,sdate);
if iRtnValue = -1 then
	w_mdi_frame.sle_msg.text = '근속년수 계산 실패!'
	return -1 
end if


w_mdi_frame.sle_msg.text = '조회중...............!!'

DECLARE start_sp_retire_insertamt procedure for sp_retire_insertamt(:syymm,:frdate,:todate, &
                  'P',:sm1,:sm2,:sm3,:sdate);

execute start_sp_retire_insertamt ;
	
if dw_print.retrieve(ssaup,sjik,syymm) < 1 then
	messagebox("확 인", "조회자료가 없습니다.!!", stopsign!)
	w_mdi_frame.sle_msg.text = ''
	dw_ip.setcolumn('yymm')
	dw_ip.setfocus()
	return -1
end if

dw_print.object.chuldate.text = '처리년월 : '+left(syymm,4)+'년 '+right(syymm,2)+'월'
setpointer(arrow!)
w_mdi_frame.sle_msg.text = '작업완료!!'
return 1
end function

on wr_pip5015_new.create
int iCurrent
call super::create
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_3
end on

on wr_pip5015_new.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_3)
end on

event open;call super::open;string sdate
sdate = f_today()

dw_ip.setitem(1,'yymm',left(sdate,6))
dw_ip.setitem(1,'gijunday',f_last_date(left(sdate,6)))
dw_ip.setitem(1,'m1',f_aftermonth(left(sdate,6),-2))
dw_ip.setitem(1,'m2',f_aftermonth(left(sdate,6),-1))
dw_ip.setitem(1,'m3',left(sdate,6))


/*사업장 정보 셋팅*/
f_set_saupcd(dw_ip,'saup','1')
is_saupcd = gs_saupcd
end event

type p_preview from w_standard_print`p_preview within wr_pip5015_new
integer x = 4110
boolean originalsize = true
end type

type p_exit from w_standard_print`p_exit within wr_pip5015_new
integer x = 4457
boolean originalsize = true
end type

type p_print from w_standard_print`p_print within wr_pip5015_new
integer x = 4283
boolean originalsize = true
end type

event p_print::clicked;sle_msg.text = ''
int rvalue
string ls_file_name, ls_file
if messagebox("확인","text 로 저장하시겠습니까?",Question!, YesNo!) = 2 then
	openwithparm(w_print_options, dw_list)
else
 
	getfilesavename("FILE 저장 선택", ls_file_name, ls_file, "TXT", " TEXT Files (*.TXT), *.TXT," )

  rvalue = 	wf_excel_save(dw_list, ls_file) 
  if rvalue = 1 then
	  sle_msg.text = '저장성공!!'
	  return rvalue
  else
	  return -1
  end if
	  
end if

end event

type p_retrieve from w_standard_print`p_retrieve within wr_pip5015_new
integer x = 3936
boolean originalsize = true
end type

type st_window from w_standard_print`st_window within wr_pip5015_new
integer x = 2368
integer y = 3492
end type

type sle_msg from w_standard_print`sle_msg within wr_pip5015_new
boolean visible = false
integer y = 3492
end type

type dw_datetime from w_standard_print`dw_datetime within wr_pip5015_new
integer y = 3492
end type

type st_10 from w_standard_print`st_10 within wr_pip5015_new
boolean visible = false
integer y = 3492
end type

type gb_10 from w_standard_print`gb_10 within wr_pip5015_new
boolean visible = false
integer y = 3456
end type

type dw_print from w_standard_print`dw_print within wr_pip5015_new
integer x = 3785
string dataobject = "d_pip5015_2_new_p"
end type

type dw_ip from w_standard_print`dw_ip within wr_pip5015_new
integer x = 18
integer y = 4
integer width = 2569
integer height = 284
integer taborder = 20
string dataobject = "d_pip5015_1_new"
end type

event dw_ip::itemchanged;call super::itemchanged;string syymm

this.AcceptText()

IF this.GetColumnName() = 'saup' THEN
	is_saupcd = this.GetText()
	
	IF is_saupcd = '' OR IsNull(is_saupcd) THEN is_saupcd = '%'
END IF

if this.GetColumnName() = 'yymm' then
	syymm = this.Gettext()
	
	if f_datechk(syymm+'01') = -1 then
		messagebox("에러","처리년월의 년월을 확인하십시요")
		this.Setcolumn('yymm')
		this.Setfocus()
		return
	end if
	
	this.Setitem(1,'m1', f_aftermonth(syymm,-2))
	this.Setitem(1,'m2', f_aftermonth(syymm,-1))
	this.Setitem(1,'m3', syymm)
	this.Setitem(1,'gijunday', f_last_date(syymm+'01'))
end if	
end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within wr_pip5015_new
integer x = 46
integer y = 304
integer width = 4571
integer height = 1904
string dataobject = "d_pip5015_2_new"
boolean border = false
end type

type rr_3 from roundrectangle within wr_pip5015_new
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 296
integer width = 4594
integer height = 1928
integer cornerheight = 40
integer cornerwidth = 55
end type

