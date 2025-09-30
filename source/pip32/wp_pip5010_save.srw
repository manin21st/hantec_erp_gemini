$PBExportHeader$wp_pip5010_save.srw
$PBExportComments$** 원천징수이행상황신고서(2)
forward
global type wp_pip5010_save from w_standard_print
end type
type p_mod from picture within wp_pip5010_save
end type
type tab_won from tab within wp_pip5010_save
end type
type tabpage_won1 from userobject within tab_won
end type
type rr_2 from roundrectangle within tabpage_won1
end type
type dw_won1 from datawindow within tabpage_won1
end type
type tabpage_won1 from userobject within tab_won
rr_2 rr_2
dw_won1 dw_won1
end type
type tabpage_won2 from userobject within tab_won
end type
type rr_3 from roundrectangle within tabpage_won2
end type
type dw_won2 from datawindow within tabpage_won2
end type
type tabpage_won2 from userobject within tab_won
rr_3 rr_3
dw_won2 dw_won2
end type
type tabpage_saup1 from userobject within tab_won
end type
type rr_6 from roundrectangle within tabpage_saup1
end type
type dw_saup1 from datawindow within tabpage_saup1
end type
type tabpage_saup1 from userobject within tab_won
rr_6 rr_6
dw_saup1 dw_saup1
end type
type tabpage_saup2 from userobject within tab_won
end type
type rr_7 from roundrectangle within tabpage_saup2
end type
type dw_saup2 from datawindow within tabpage_saup2
end type
type tabpage_saup2 from userobject within tab_won
rr_7 rr_7
dw_saup2 dw_saup2
end type
type tabpage_gita1 from userobject within tab_won
end type
type dw_gita1 from datawindow within tabpage_gita1
end type
type rr_4 from roundrectangle within tabpage_gita1
end type
type tabpage_gita1 from userobject within tab_won
dw_gita1 dw_gita1
rr_4 rr_4
end type
type tabpage_gita2 from userobject within tab_won
end type
type dw_gita2 from datawindow within tabpage_gita2
end type
type rr_5 from roundrectangle within tabpage_gita2
end type
type tabpage_gita2 from userobject within tab_won
dw_gita2 dw_gita2
rr_5 rr_5
end type
type tabpage_ija from userobject within tab_won
end type
type dw_ija from datawindow within tabpage_ija
end type
type rr_8 from roundrectangle within tabpage_ija
end type
type tabpage_ija from userobject within tab_won
dw_ija dw_ija
rr_8 rr_8
end type
type tab_won from tab within wp_pip5010_save
tabpage_won1 tabpage_won1
tabpage_won2 tabpage_won2
tabpage_saup1 tabpage_saup1
tabpage_saup2 tabpage_saup2
tabpage_gita1 tabpage_gita1
tabpage_gita2 tabpage_gita2
tabpage_ija tabpage_ija
end type
type p_make from picture within wp_pip5010_save
end type
type dw_won from datawindow within wp_pip5010_save
end type
type dw_gita from datawindow within wp_pip5010_save
end type
type dw_saup from datawindow within wp_pip5010_save
end type
type dw_ijabd from datawindow within wp_pip5010_save
end type
type p_del from uo_picture within wp_pip5010_save
end type
type st_1 from statictext within wp_pip5010_save
end type
end forward

global type wp_pip5010_save from w_standard_print
integer x = 0
integer y = 0
integer width = 4681
integer height = 2536
string title = "원천징수이행상황신고서"
p_mod p_mod
tab_won tab_won
p_make p_make
dw_won dw_won
dw_gita dw_gita
dw_saup dw_saup
dw_ijabd dw_ijabd
p_del p_del
st_1 st_1
end type
global wp_pip5010_save wp_pip5010_save

forward prototypes
public function integer wf_update ()
public function integer wf_retrieve ()
public function long wf_plusamt (long amt)
public subroutine wf_setitem (string sabu)
public function integer wf_set_saupamt (ref datawindow dwobject, string ar_workym, string ar_saupcd)
end prototypes

public function integer wf_update ();Return 1
end function

public function integer wf_retrieve ();String S_SAUPNO,S_SANAME,S_PRESIDENT,S_ADDR,S_ZIP,S_Jongmok,S_Uptae,S_TEL, s_yeargubn, sIlGwal, s_email
String StartYear1,StartYear2,StartYear3,sPbTag,sSaupcd,sDate, sdayworkgubn,tym,sabu,sKunmu, sid
int    inwon11, inwon12 ,inwon13,inwon21,inwon22, inwon31, inwon41, inwon42
double totamt11,totamt12,totamt13,totamt21,totamt22,totamt23,totamt24,totamt31, totamt41, totamt42, totamt43, totamt44 
int inwon61, inwon401, inwon201
double totamt62, totamt63, totamt402, totamt403, totamt202,totamt203
string spym, sSemu, ls_jj
Datawindow Dw_Object

if dw_ip.AcceptText() = -1 then return -1

StartYear1 = dw_ip.GetITemString(1,"sym")   /*근로소득귀속년월*/
tym = dw_ip.GetITemString(1,"sym1")   /*원천징수년월*/
s_yeargubn = dw_ip.GetITemString(1,"yeargubn") /*정산년월 반영*/
StartYear3 = dw_ip.GetITemString(1,"yearyymm")   /*연말정산년월*/
sdayworkgubn = dw_ip.GetITemString(1,"dayworkgubn")   /*일용직신고여부*/
sPbTag = dw_ip.getitemstring(1,"gubn") /*급여,상여 구분*/
sSaupcd = dw_ip.getitemstring(1,"saupcd") /*사업장구분*/
sDate = dw_ip.getitemstring(1,"sdate") /*제출일자*/
sKunmu = trim(dw_ip.GetitemString(1,'kunmu')) /*근무구분*/
sSemu = trim(dw_ip.GetitemString(1,'semu')) /*세무서명*/
ls_jj = trim(dw_ip.GetItemString(1, 'jj')) /* 작성여부 */
sIlGwal = dw_ip.getitemstring(dw_ip.getrow(),"ilgwalgb")		//일괄납부여부
sid = dw_ip.getitemstring(dw_ip.getrow(),"sid")
s_email = dw_ip.getitemstring(dw_ip.getrow(),"email")

if StartYear1 = '' or isnull(StartYear1) then
	messagebox("확인","근로소득귀속년월을 입력하십시오")
	dw_ip.setcolumn("sym")
	dw_ip.setfocus()
	return -1
end if	

if StartYear3 = '' or isnull(StartYear3) then StartYear3 = ''
if sPbtag = '' or isnull(sPbtag) then sPbtag = '%'
if sSaupcd = '' or isnull(sSaupcd) then sSaupcd = '%'
IF sKunmu = '' OR IsNull(sKunmu) THEN sKunmu = '%'
if sDate = '' or isnull(sDate) then sDate = gs_today

if s_yeargubn = 'N' then
	 StartYear3 = ''
end if

if tab_won.SelectedTab = 1 THEN								/*원천징수이행상황신고서*/
	Dw_Object = tab_won.tabpage_won1.dw_won1
elseif tab_won.SelectedTab = 3 THEN							/*사업소득지급조서*/
	Dw_Object = tab_won.tabpage_saup1.dw_saup1
end if

dw_print.reset()
Dw_Object.reset()

SetPointer(HourGlass!)
Dw_Object.SetRedraw(False)

Dw_Object.Reset()
//dw_1.reset()
Dw_Object.insertrow(0)
//dw_1.insertrow(0)

/*원천징수의무자*/
  SELECT SAUPNO, JURNAME, CHAIRMAN, ADDR, PHONE
    INTO :S_SAUPNO,			//사업자번호
	 		:S_SANAME,			//법인명
			:S_PRESIDENT,		//대표자명
			:S_ADDR,				//사업장주소
			:S_TEL				//사업장전화번호
    FROM "P0_SAUPCD"
   WHERE COMPANYCODE = 'KN' AND
			SAUPCODE = DECODE(:sSaupcd,'%','10',:sSaupcd);


if IsNull(spym) or spym = '' then
	spym = StartYear1
end if

IF tab_won.SelectedTab = 1 THEN											/*원천징수이행상황신고서*/
	SELECT sum(decode(a.pbtag,'P',1,0)) as inwon1, 
			 sum(decode(a.pbtag,'P',1,1)) as inwon3, 	
			 sum(a.totpayamt) as totamt1,
			 sum(a.allowamt201)
	  into :inwon11, :inwon13 , :totamt11,  :totamt13  		 
	  FROM "P3_EDITDATA" a,"P1_MASTER" b, "P0_DEPT" c
		WHERE  a.EMPNO = b.EMPNO AND
				 b.kunmugubn LIKE :sKunmu and
				 b.DEPTCODE = c.DEPTCODE AND
				 b.COMPANYCODE = c.COMPANYCODE AND
				 c.SAUPCD LIKE :sSaupcd AND
				 a.workym  = :StartYear1 AND
				 a.PBTAG like :sPbTag;

	if isnull(inwon11) then inwon11 = 0 
	if isnull(inwon12) then inwon12 = 0 
	if isnull(inwon13) then inwon13 = 0 
	if isnull(totamt11) then totamt11 = 0 
	if isnull(totamt12) then totamt12 = 0 
	if isnull(totamt13) then totamt13 = 0 
	
	if sqlca.sqlcode <> 0 then	
		messagebox("확인","출력할 자료가 없습니다")
		Dw_Object.setredraw(TRUE)
		return -1
	end if

	Dw_Object.setitem(1,"gi_ym",spym)           // 귀속년월
	Dw_Object.setitem(1,"ji_ym",tym)            // 지급년월
	Dw_Object.setitem(1,"sname",S_SANAME)       // 법인명
	Dw_Object.setitem(1,"spname",S_PRESIDENT)   // 대표자성명
	Dw_Object.setitem(1,"ssno",S_SAUPNO)       // 사업자번호
	if sSaupcd = '%' then
		Dw_Object.setitem(1,"saupj",'99')       // 사업장
	else
		Dw_Object.setitem(1,"saupj",sSaupcd)
	end if
	Dw_Object.setitem(1,"saddr",S_ADDR)         // 사업장소재지
	Dw_Object.setitem(1,"stel",S_TEL)           // 전화번호
	Dw_Object.setitem(1,"je_ymd",sDate)         // 제출일자 
	Dw_Object.setitem(1,"semus",sSemu)          // 세무서
	Dw_Object.setitem(1,"email",s_email)         // email
	
	if spbtag = '%' then
		Dw_Object.setitem(1,"a011",inwon11)      // 근로소득(인원)
	else
		Dw_Object.setitem(1,"a011",inwon13)
	end if	
	Dw_Object.setitem(1,"a012",totamt11)        // 근로소득(총지급액)
	Dw_Object.setitem(1,"a013",totamt13)        // 근로소득(소득세등)
	
	/*일용직*/
	select count(empno),sum(nvl(totpayamt,0))
	  into :inwon11, :totamt11
	  from p2_editdata
	 where workym = :StartYear1 and
			 pbtag like :sPbTag;
	
	IF IsNull(inwon11) THEN inwon11 = 0
	IF IsNull(totamt11) THEN totamt11 = 0
	
	IF SQLCA.SQLCODE <> 0 THEN
		inwon11 = 0
		totamt31 = 0
	END IF
	
	Dw_Object.setitem(1,"a031",inwon11)         // 중도퇴사(인원)
	Dw_Object.setitem(1,"a032",totamt11)        // 중도퇴사(총지급액)
	
	
	
	///*중도정산분*/
	IF sPbtag = '%' or sPbtag = 'P' THEN 
		SELECT count(*) as inwon1,   
				 sum(( a.foreignworkincome +  a.nightworkpay +  a.etctaxfree +  a.workincomegross )) as totamt1,  
				 sum(a.netincometax),
				 sum(a.netspecialtax) 
		 INTO  :inwon21, :totamt21, :totamt23,  :totamt24		 
		 FROM "P3_ACNT_TAXCAL_DATA" a,"P1_MASTER" b, "P0_DEPT" c, "P0_SAUPCD" d
			WHERE  a.WORKYEAR = substr(:StartYear1,1,4) AND  
					 a.WORKMM = substr(:StartYear1 ,5,2) AND  
					 a.companycode = b.companycode and
					 a.empno = b.empno and
					 b.kunmugubn LIKE :sKunmu and			
					 a.companycode = c.companycode and
					 b.deptcode = c.deptcode and
					 c.COMPANYCODE = d.COMPANYCODE AND   
					 c.SAUPCD = d.SAUPCODE AND
					 c.SAUPCD LIKE :sSaupcd AND			
					 a.TAG = '2' ;
	
		if isnull(inwon21) then inwon21 = 0 
		if isnull(totamt21) then totamt21 = 0 
		if isnull(totamt23) then totamt23 = 0 
		if isnull(totamt24) then totamt24 = 0 
		
		if sqlca.sqlcode <> 0 then	
			inwon21 = 0
			totamt21 = 0
			totamt23 = 0
			totamt24 = 0		
		end if
		
		Dw_Object.setitem(1,"a021",inwon21)                 // 중도정산(인원)
		Dw_Object.setitem(1,"a022",totamt21)                // 중도정산(총지급액)
		Dw_Object.setitem(1,"a023",totamt23)                // 중도정산(소득세등)
		Dw_Object.setitem(1,"a024",totamt24)                // 중도정산(농특세)
	END IF
		
	
	/*연말정산분*/
	SELECT count(*) as inwon1,   
			 sum(( a.foreignworkincome +  a.nightworkpay +  a.etctaxfree +  a.workincomegross )) as totamt1,  
			 sum(a.netincometax),
			 sum(a.netspecialtax) 
	 INTO  :inwon41, :totamt41, :totamt43, :totamt44		 
	 FROM "P3_ACNT_TAXCAL_DATA" a,"P1_MASTER" b, "P0_DEPT" c, "P0_SAUPCD" d
		WHERE  a.WORKYEAR = substr(:StartYear3,1,4) AND  
				 a.WORKMM = substr(:StartYear3,5,2) AND 
				 a.companycode = b.companycode and
				 a.empno = b.empno and
				 b.kunmugubn LIKE :sKunmu and			
				 a.companycode = c.companycode and
				 b.deptcode = c.deptcode and
				 c.COMPANYCODE = d.COMPANYCODE AND   
				 c.SAUPCD = d.SAUPCODE AND
				 c.SAUPCD LIKE :sSaupcd AND
				 a.TAG = '1'   ;   
	
	if isnull(inwon41) then inwon41 = 0 
	if isnull(totamt41) then totamt41 = 0 
	if isnull(totamt43) then totamt43 = 0 
	if isnull(totamt44) then totamt44 = 0 
	
	if sqlca.sqlcode <> 0 then	
		inwon41 = 0
		totamt41 = 0
		totamt43 = 0
		totamt44 = 0	
	end if
	
	Dw_Object.setitem(1,"a041",inwon41)                 // 연말정산(인원)
	Dw_Object.setitem(1,"a042",totamt41)                // 연말정산(총지급액)
	Dw_Object.setitem(1,"a043",totamt43)                // 연말정산(소득세등)
	Dw_Object.setitem(1,"a044",totamt44)                // 중도정산(농특세)
	
	
	/*퇴직소득*/
	select count(a.empno),
			 sum(a.retirementpay1),
			 sum(a.balanceincometax)       
	into  :inwon201, :totamt202, :totamt203		 
	from p3_retirementpay a,"P1_MASTER" b, "P0_DEPT" c
	where ( a.companycode = b.companycode ) and
			( a.empno = b.empno ) and
			( a.companycode = c.companycode ) and
			( b.deptcode = c.deptcode ) and
			( c.saupcd LIKE :sSaupcd ) and
			( b.kunmugubn like :sKunmu ) and
			( substr(a.todate,1,6) = :StartYear1 );
	
	if sqlca.sqlcode <> 0 then	
		inwon201 = 0
		totamt202 = 0
		totamt203 = 0	
	end if
	Dw_Object.setitem(1,"a201",inwon201)       // 퇴직소득(인원)
	Dw_Object.setitem(1,"a202",totamt202)      // 퇴직소득(총지급액)
	Dw_Object.setitem(1,"a203",totamt203)      // 퇴직소득(소득세등)
	Dw_Object.setitem(1,"a207",totamt203)
	
	//select count(cvcod) as inwon1,
	//       sum(totpayamt) as totamt,
	//       sum(incometax) as incometax
	//into   :inwon61, :totamt62, :totamt63	 
	//from p7_saup
	//where saupcd = :Ssaupcd and
	//      substr(wdate,1,6) = :StartYear1 ;
	//		
	//if sqlca.sqlcode <> 0 then
	//	inwon61 = 0
	//	totamt62 = 0
	//	totamt63 = 0
	//end if
	//
	//select count(cvcod) as inwon1,
	//       sum(interest) as totamt,
	//       sum(incometax) as incometax
	//into   :inwon401, :totamt402, :totamt403	 
	//from p7_etc
	//from saupcd = :Ssaupcd and
	//     substr(wdate,1,6) = :StartYear1 ;
	//	  
	//if sqlca.sqlcode <> 0 then	  
	//	inwon401 = 0
	//	totamt402 = 0
	//	totamt403 = 0 
	//end if
	//
	//Dw_Object.setitem(1,"a261", inwon61)
	//Dw_Object.setitem(1,"a262", totamt62)
	//Dw_Object.setitem(1,"a263", totamt63)
	//Dw_Object.setitem(1,"a401", inwon401)
	//Dw_Object.setitem(1,"a402", totamt402)
	//Dw_Object.setitem(1,"a403", totamt403)
	//
	//
	///*계*/
	//
	//Dw_Object.setitem(1,"a991",inwon11  + inwon21 +  inwon41 + inwon61 + inwon401)
	//Dw_Object.setitem(1,"a992",totamt11 + totamt21 + totamt41 + totamt62 + totamt402)
	//Dw_Object.setitem(1,"a993",totamt13 + totamt23 + totamt43 + totamt63 + totamt403)
	//Dw_Object.setitem(1,"a996",totamt24)
	//Dw_Object.setitem(1,"a997",totamt13 + totamt23)
	//
	
	
	//신고구분(연말)
	if s_yeargubn = 'Y' then
	  Dw_Object.setitem(1,"singogb",'Y')
	else
	  Dw_Object.setitem(1,"singogb",'N')	
	end if  
	
	//일괄납부여부
	IF sIlGwal = "Y" THEN
		Dw_Object.setitem(1,"ilgwalgb","Y")
	ELSE
		Dw_Object.setitem(1,"ilgwalgb","N")
	END IF
	
	//신고서(뒤쪽)작성여부
	IF ls_jj = "Y" THEN
		Dw_Object.setitem(1,"backgb","Y")
	ELSE
		Dw_Object.setitem(1,"backgb","N")
	END IF
	
	//홈택스 id	
	Dw_Object.setitem(1,"id",sid)			
		
		
	
	Dw_Object.object.jj_1.visible = false
	Dw_Object.object.jj_2.visible = false
	Dw_Object.object.jj_3.visible = false
	Dw_Object.object.jj_4.visible = false
	
	dw_print.object.jj_1.visible = false
	dw_print.object.jj_2.visible = false
	dw_print.object.jj_3.visible = false
	dw_print.object.jj_4.visible = false
	
	
	choose case ls_jj
		case '1'
			Dw_Object.object.jj_1.visible = true
			dw_print.object.jj_1.visible = true
			Dw_Object.object.jj_2.visible = true
			dw_print.object.jj_2.visible = true
		case '2'
			Dw_Object.object.jj_3.visible = true
			dw_print.object.jj_3.visible = true
			Dw_Object.object.jj_4.visible = true
			dw_print.object.jj_4.visible = true
	end choose
ELSEIF tab_won.SelectedTab = 3 THEN										/*사업소득지급조서*/
	Dw_Object.setitem(1,"gi_ym",left(spym,4)+'12') // 귀속년월
	Dw_Object.setitem(1,"sname",S_SANAME)       // 법인명
	Dw_Object.setitem(1,"ssno",S_SAUPNO)        // 사업자번호
	Dw_Object.setitem(1,"saddr",S_ADDR)         // 사업장소재지
	if sSaupcd = '%' then
		Dw_Object.setitem(1,"saupj",'99')       // 사업장
	else
		Dw_Object.setitem(1,"saupj",sSaupcd)
	end if
	
	IF WF_SET_SAUPAMT(Dw_Object,spym,sSaupcd) = -1 THEN RETURN -1
END IF

Dw_Object.SetRedraw(True)
Dw_Object.Triggerevent(ItemChanged!)

SetPointer(Arrow!)

Return 1
end function

public function long wf_plusamt (long amt);long retamt

if IsNull(amt) then amt = 0

if amt < 0 then 
	retamt = 0
else
	retamt = amt
end if

	

return retamt


end function

public subroutine wf_setitem (string sabu);string ls_id, ls_email, snull

if sabu = '%' then sabu = '99'

select id, email into :ls_id, :ls_email
from won_won1
where saupj = :sabu and
      gi_ym = (select max(gi_ym) from won_won1
		         where saupj = :sabu );
					
if IsNull(ls_id) or ls_id = '' then
	dw_ip.Setitem(1,'sid', snull)
else
	dw_ip.Setitem(1,'sid', ls_id)
end if

if IsNull(ls_email) or ls_email = '' then
	dw_ip.Setitem(1,'email', snull)
else
	dw_ip.Setitem(1,'email', ls_email)
end if
		     
end subroutine

public function integer wf_set_saupamt (ref datawindow dwobject, string ar_workym, string ar_saupcd);String ls_year, ls_name, ls_residentno, ls_gubun, ls_zipcode, ls_address, ls_inout
Int i, j, ii, li_page, li_inwon, li_cnt, li_tcnt, li_rate, li_totrate
Decimal ld_totpayamt, ld_totincome, ld_totresident
Decimal ld_payamt, ld_incometax, ld_residenttax

ls_year = left(ar_workym,4)

DECLARE cur_saupamt CURSOR FOR
  SELECT "P3_SAUPMASTER"."EMPNAME",
         "P3_SAUPMASTER"."RESIDENTNO",
         "P3_SAUPMASTER"."GUBUNCODE",
			"P3_SAUPMASTER"."ZIPCODE1",
         "P3_SAUPMASTER"."ADDRESS1",   
         "P3_SAUPMASTER"."INOUT",
			COUNT("P3_SAUPAMT"."WORKYM"),
         MAX("P3_SAUPAMT"."INCOMERATE"), 			
         SUM("P3_SAUPAMT"."PAYAMT"),   
         SUM("P3_SAUPAMT"."INCOMETAXAMT"),   
         SUM("P3_SAUPAMT"."RESIDENTTAXAMT")
    FROM "P3_SAUPAMT",   
         "P3_SAUPMASTER"  
   WHERE ( "P3_SAUPAMT"."EMPNO" = "P3_SAUPMASTER"."EMPNO" ) AND
			( "P3_SAUPMASTER"."SAUPCD" LIKE :ar_saupcd ) AND
			( "P3_SAUPAMT"."WORKYM" LIKE :ls_year||'%' )
GROUP BY "P3_SAUPMASTER"."EMPNO",   
         "P3_SAUPMASTER"."EMPNAME",   
         "P3_SAUPMASTER"."RESIDENTNO",   
         "P3_SAUPMASTER"."GUBUNCODE",
			"P3_SAUPMASTER"."ZIPCODE1", 
         "P3_SAUPMASTER"."ADDRESS1",   
         "P3_SAUPMASTER"."INOUT"
			;

  SELECT COUNT(DISTINCT("P3_SAUPMASTER"."EMPNO")),
         COUNT("P3_SAUPAMT"."WORKYM"),
         SUM("P3_SAUPAMT"."PAYAMT"),
			MAX("P3_SAUPAMT"."INCOMERATE"),
         SUM("P3_SAUPAMT"."INCOMETAXAMT"),
         SUM("P3_SAUPAMT"."RESIDENTTAXAMT")
	 INTO :li_inwon, :li_tcnt, :ld_totpayamt,
	 		:li_totrate, :ld_totincome, :ld_totresident
    FROM "P3_SAUPAMT",   
         "P3_SAUPMASTER"  
   WHERE ( "P3_SAUPAMT"."EMPNO" = "P3_SAUPMASTER"."EMPNO" ) AND
			( "P3_SAUPMASTER"."SAUPCD" LIKE :ar_saupcd ) AND
			( "P3_SAUPAMT"."WORKYM" LIKE :ls_year||'%' )
			;

if li_inwon <= 0 then return -1
	
DwObject.SetItem(1,'a004',li_inwon)
DwObject.SetItem(1,'a005',li_tcnt)
DwObject.SetItem(1,'a006',ld_totpayamt)
DwObject.SetItem(1,'a008',ld_totincome)
DwObject.SetItem(1,'a009',ld_totresident)
DwObject.SetItem(1,'a016',li_tcnt)
DwObject.SetItem(1,'a017',ld_totpayamt)
DwObject.SetItem(1,'a018',li_totrate)
DwObject.SetItem(1,'a019',ld_totincome)
DwObject.SetItem(1,'a020',ld_totresident)

//ii = truncate(li_inwon / 9, 0)

OPEN cur_saupamt;

//FOR i = 1 to ii

	FOR j = 1 to li_inwon
		FETCH cur_saupamt 
		INTO :ls_name, :ls_residentno, :ls_gubun, :ls_zipcode, :ls_address,
			  :ls_inout, :li_cnt, :li_rate, :ld_payamt, :ld_incometax, :ld_residenttax;
		IF ISNULL(ls_name) THEN EXIT
		
		DwObject.SetItem(1,'a'+string(j)+'11',ls_gubun)
		DwObject.SetItem(1,'a'+string(j)+'12',ls_name)
		DwObject.SetItem(1,'a'+string(j)+'13',ls_residentno)
		DwObject.SetItem(1,'a'+string(j)+'14',ls_inout)
		DwObject.SetItem(1,'a'+string(j)+'15',ls_year)
		DwObject.SetItem(1,'a'+string(j)+'16',li_cnt)
		DwObject.SetItem(1,'a'+string(j)+'17',ld_payamt)
		DwObject.SetItem(1,'a'+string(j)+'18',li_rate)
		DwObject.SetItem(1,'a'+string(j)+'19',ld_incometax)
		DwObject.SetItem(1,'a'+string(j)+'20',ld_residenttax)

	NEXT

//NEXT

CLOSE cur_saupamt;

return 1
end function

on wp_pip5010_save.create
int iCurrent
call super::create
this.p_mod=create p_mod
this.tab_won=create tab_won
this.p_make=create p_make
this.dw_won=create dw_won
this.dw_gita=create dw_gita
this.dw_saup=create dw_saup
this.dw_ijabd=create dw_ijabd
this.p_del=create p_del
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_mod
this.Control[iCurrent+2]=this.tab_won
this.Control[iCurrent+3]=this.p_make
this.Control[iCurrent+4]=this.dw_won
this.Control[iCurrent+5]=this.dw_gita
this.Control[iCurrent+6]=this.dw_saup
this.Control[iCurrent+7]=this.dw_ijabd
this.Control[iCurrent+8]=this.p_del
this.Control[iCurrent+9]=this.st_1
end on

on wp_pip5010_save.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.p_mod)
destroy(this.tab_won)
destroy(this.p_make)
destroy(this.dw_won)
destroy(this.dw_gita)
destroy(this.dw_saup)
destroy(this.dw_ijabd)
destroy(this.p_del)
destroy(this.st_1)
end on

event open;call super::open;w_mdi_frame.sle_msg.text = ''


dw_ip.SetTransObject(sqlca)

tab_won.tabpage_won1.dw_won1.SetTransObject(SQLCA)
tab_won.tabpage_won2.dw_won2.SetTransObject(SQLCA)
tab_won.tabpage_gita1.dw_gita1.SetTransObject(SQLCA)
tab_won.tabpage_gita2.dw_gita2.SetTransObject(SQLCA)
tab_won.tabpage_saup1.dw_saup1.SetTransObject(SQLCA)
tab_won.tabpage_saup2.dw_saup2.SetTransObject(SQLCA)
tab_won.tabpage_ija.dw_ija.SetTransObject(SQLCA)

dw_won.SetTransObject(SQLCA)
dw_gita.SetTransObject(SQLCA)
dw_saup.SetTransObject(SQLCA)
dw_ijabd.SetTransObject(SQLCA)


tab_won.tabpage_won1.dw_won1.insertrow(0)
dw_ip.insertrow(0)
dw_ip.SetITem(1,"sym",string(f_today(), '@@@@@@'))
dw_ip.SetITem(1,"sym1",string(f_today(), '@@@@@@'))

dw_ip.SetITem(1,"sdate",string(f_today(), '@@@@@@@@'))

dw_ip.SetItem(dw_ip.GetRow(),"ilgwalgb","N")

dw_ip.Setitem(1,'spath','C:\ERSDATA\'+f_today()+'.201')


f_set_saupcd(dw_ip, 'saupcd', '1')
is_saupcd = gs_saupcd

wf_setitem(is_saupcd)


end event

type p_preview from w_standard_print`p_preview within wp_pip5010_save
integer x = 4315
integer y = 828
boolean enabled = true
end type

event p_preview::clicked;//if is_preview = 'no' then
//	if dw_1.object.datawindow.print.preview = "yes" then
//		dw_1.object.datawindow.print.preview = "no"
//		
//	else
//		dw_1.object.datawindow.print.preview = "yes"	
//		
//	end if	
//end if
//
//OpenWithParm(w_print_preview, dw_list)	
//
end event

type p_exit from w_standard_print`p_exit within wp_pip5010_save
integer x = 4398
integer y = 160
end type

type p_print from w_standard_print`p_print within wp_pip5010_save
integer x = 4398
integer y = 16
boolean enabled = true
end type

event p_print::clicked;gi_page = 1

IF tab_won.SelectedTab = 1 THEN					//원천징수 이행상황 신고서(갑)
	OpenWithParm(w_print_options, tab_won.tabpage_won1.dw_won1)
ELSEIF tab_won.SelectedTab = 2 THEN			//원천징수 이행상황 신고서(부표)
	OpenWithParm(w_print_options, tab_won.tabpage_won2.dw_won2)
ELSEIF tab_won.SelectedTab = 3 THEN			//기타소득 지급조서(갑)
	OpenWithParm(w_print_options, tab_won.tabpage_gita1.dw_gita1)
ELSEIF tab_won.SelectedTab = 4 THEN			//기타소득 지급조서(부표)
	OpenWithParm(w_print_options, tab_won.tabpage_gita2.dw_gita2)
ELSEIF tab_won.SelectedTab = 5 THEN			//사업소득 지급조서(갑)
	OpenWithParm(w_print_options, tab_won.tabpage_saup1.dw_saup1)
ELSEIF tab_won.SelectedTab = 6 THEN			//사업소득 지급조서(부표)
	OpenWithParm(w_print_options, tab_won.tabpage_saup2.dw_saup2)
ELSEIF tab_won.SelectedTab = 7 THEN			//이자배당소득 지급조서
	OpenWithParm(w_print_options, tab_won.tabpage_ija.dw_ija)
END IF
end event

type p_retrieve from w_standard_print`p_retrieve within wp_pip5010_save
integer x = 4050
integer y = 16
end type

event p_retrieve::clicked;String ls_saupcd, ls_gym, sJeYmd, sJiYm, sid
Int    iRowCnt
Datawindow DwObject

w_mdi_frame.sle_msg.text = ""

dw_ip.accepttext()

ls_Saupcd = dw_ip.getitemstring(dw_ip.getrow(),"saupcd")		//사업장
ls_GYm = Trim(dw_ip.GetITemString(dw_ip.getrow(),"sym"))	   //귀속년월
sJeYmd = Trim(dw_ip.getitemstring(dw_ip.getrow(),"sdate"))	//제출일자
sJiYm = Trim(dw_ip.getitemstring(dw_ip.getrow(),"sym1"))	   //지급년월
sid = Trim(dw_ip.getitemstring(dw_ip.getrow(),"sid"))

IF ls_Saupcd = "" OR Isnull(ls_Saupcd) THEN ls_Saupcd = '99'
//	F_MessageChk(1,'[사업장]')
//	dw_ip.SetColumn("saupcd")
//	dw_ip.SetFocus()
//	Return
//END IF

IF ls_GYm = "" OR Isnull(ls_GYm) THEN
	F_MessageChk(1,'[귀속년월]')
	dw_ip.SetColumn("sym")
	dw_ip.SetFocus()
	Return
END IF

IF sJeYmd = "" OR Isnull(sJeYmd) THEN
	F_MessageChk(1,'[제출일자]')
	dw_ip.SetColumn("je_ymd")
	dw_ip.SetFocus()
	Return
END IF

IF sJiYm = "" OR Isnull(sJiYm) THEN
	F_MessageChk(1,'[지급년월]')
	dw_ip.SetColumn("ji_ym")
	dw_ip.SetFocus()
	Return
END IF

IF sid = "" OR Isnull(sid) THEN
	F_MessageChk(1,'[홈택스id]')
	dw_ip.SetColumn("sid")
	dw_ip.SetFocus()
	Return
END IF

if tab_won.SelectedTab = 1 THEN								/*원천징수이행상황신고서*/
	DwObject = tab_won.tabpage_won1.dw_won1
elseif tab_won.SelectedTab = 3 THEN							/*사업소득지급조서*/
	DwObject = tab_won.tabpage_saup1.dw_saup1
	ls_GYm = left(ls_GYm,4) + '12'
end if

SetPointer(HourGlass!)

iRowCnt = DwObject.retrieve(ls_Saupcd,ls_GYm)

IF iRowCnt > 0 THEN
	p_mod.Enabled = True
	p_mod.PictureName = "C:\erpman\image\저장_up.gif"
	p_del.Enabled = True
	p_del.PictureName = "C:\erpman\image\삭제_up.gif"
	p_print.Enabled =True
	p_print.PictureName =  'C:\erpman\image\인쇄_up.gif'
	p_preview.enabled = true
	p_preview.PictureName = 'C:\erpman\image\미리보기_up.gif'
	p_make.Enabled = True
	p_make.PictureName = "C:\erpman\image\자료생성_up.gif"
	
ELSE
	
	IF Wf_retrieve() = -1 THEN 
		
		p_mod.Enabled = false
		p_mod.PictureName = "C:\erpman\image\저장_d.gif"
		p_del.Enabled = False
	   p_del.PictureName = "C:\erpman\image\삭제_d.gif"
		p_print.Enabled =False
		p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'
		p_preview.enabled = False
		p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
		p_make.Enabled = False 
	   p_make.PictureName = "C:\erpman\image\자료생성_d.gif"
		
		SetPointer(Arrow!)
		Return
	END IF

   tab_won.tabpage_won1.dw_won1.InsertRow(0)
	p_mod.Enabled = True
	p_mod.PictureName = "C:\erpman\image\저장_up.gif"
	p_print.Enabled =True
	p_print.PictureName =  'C:\erpman\image\인쇄_up.gif'
	p_preview.enabled = true
	p_preview.PictureName = 'C:\erpman\image\미리보기_up.gif'
	p_make.Enabled = False 
	p_make.PictureName = "C:\erpman\image\자료생성_d.gif"
END IF

/* Last page 구하는 routine */
long Li_row = 1, Ll_prev_row

DwObject.setredraw(false)
//dw_list.object.datawindow.print.preview="yes"

gi_page = 1

do while true
	ll_prev_row = Li_row
	Li_row = dw_list.ScrollNextPage()
	If Li_row = ll_prev_row or Li_row <= 0 then
		exit
	Else
		gi_page++
	End if
loop

DwObject.scrolltorow(1)
DwObject.setredraw(true)
SetPointer(Arrow!)



end event

type st_window from w_standard_print`st_window within wp_pip5010_save
integer x = 2487
integer y = 3632
integer height = 72
end type

type sle_msg from w_standard_print`sle_msg within wp_pip5010_save
integer x = 517
integer y = 3624
end type

type dw_datetime from w_standard_print`dw_datetime within wp_pip5010_save
integer x = 2985
integer y = 3624
end type

type st_10 from w_standard_print`st_10 within wp_pip5010_save
integer x = 155
integer y = 3624
end type

type gb_10 from w_standard_print`gb_10 within wp_pip5010_save
integer x = 142
integer y = 3572
end type

type dw_print from w_standard_print`dw_print within wp_pip5010_save
integer x = 4306
integer y = 692
string dataobject = "dp_pip5010_save"
end type

type dw_ip from w_standard_print`dw_ip within wp_pip5010_save
integer x = 50
integer y = 8
integer width = 3954
integer height = 340
integer taborder = 70
string dataobject = "dp_pip5010_10_save"
end type

event dw_ip::itemchanged;call super::itemchanged;string ls_date, stext
int a

this.AcceptText()

IF this.GetColumnName() = 'saupcd' THEN
   is_saupcd = this.GetText()
	
	IF is_saupcd = '' OR IsNull(is_saupcd) THEN is_saupcd = '%'
	
   wf_setitem(is_saupcd)
END IF

If this.GetColumnName() = 'sdate' then
	ls_date = this.Gettext()
	
	stext = this.GetItemString(1,'spath')
   a = pos(stext,'.')
   stext = left(stext,a - 9)
	stext = stext+ls_date+'.201'
   this.Setitem(1,'spath', stext)
	
End if
end event

event dw_ip::itemfocuschanged;call super::itemfocuschanged;if dwo.name = 'semu' then
	gu_extapi.f_toggle_kor(handle(parent))
end if
end event

event dw_ip::itemerror;call super::itemerror;Return 1
end event

event dw_ip::rbuttondown;call super::rbuttondown;IF dw_ip.GetColumnName() = "empno" THEN 
	setnull(gs_code)
	setnull(gs_codename)
	SetNull(Gs_Gubun)
	
   Gs_Gubun = is_saupcd		
	open(w_employee_saup_popup)
		
	if isnull(gs_code) or gs_code = '' then return
		
	dw_ip.SetITem(1,"empno",gs_code)
	dw_ip.SetITem(1,"empname",gs_codename)
END IF		
end event

type dw_list from w_standard_print`dw_list within wp_pip5010_save
event ue_enter pbm_dwnprocessenter
boolean visible = false
integer x = 3927
integer y = 3556
integer width = 320
integer height = 116
string dataobject = "dp_pip5010_save"
boolean border = false
end type

event dw_list::ue_enter;Send(Handle(this),256,9,0)
Return 1
end event

event dw_list::clicked;//override
end event

event dw_list::rowfocuschanged;//override
end event

event dw_list::itemerror;call super::itemerror;return 1

//long d011, d021, d031, d041, d101, d201, d251, d261, d301, d401, d451, d501, d601, d691, d801, d901, d991
//long d012, d022, d032, d042, d102, d202, d252, d262, d302, d402, d452, d502, d602, d692, d802, d902, d992
//long d013, d023, d033, d043, d103, d203, d253, d263, d303, d403, d453, d503, d603, d693, d803, d903, d993
//long d014, d024, d034, d044, d104, d204, d254, d264, d304, d404, d454, d504, d604, d694, d804, d904, d994
//long d015, d025, d035, d045, d105, d205, d255, d265, d305, d405, d455, d505, d605, d695, d805, d905, d995
//long d016, d026, d036, d046, d106, d206, d256, d266, d306, d406, d456, d506, d606, d696, d806, d906, d996
//long d017, d027, d037, d047, d107, d207, d257, d267, d307, d407, d457, d507, d607, d697, d807, d907, d997
//long d018, d028, d038, d048, d108, d208, d258, d268, d308, d408, d458, d508, d608, d698, d808, d908, d998
end event

event dw_list::itemchanged;call super::itemchanged;long d01[8], d02[8], d03[8], d04[8], d10[8], d20[8], d25[8], d26[8], d30[8]
long d40[8], d45[8], d50[8], d60[8], d69[8], d70[8], d80[8], d90[8], d99[8]
long p99[9], d107,   d207
int i


if dw_list.Accepttext() = -1 then return

d207 = wf_plusamt( dw_list.GetitemNumber(1, 'a203'))+wf_plusamt( dw_list.GetitemNumber(1, 'a205'))

For i = 1 to 8
    d01[i] = dw_list.GetitemNumber(1, 'a01'+string(i))
	 d02[i] = dw_list.GetitemNumber(1, 'a02'+string(i))
    d03[i] = dw_list.GetitemNumber(1, 'a03'+string(i))	 
	 d04[i] = dw_list.GetitemNumber(1, 'a04'+string(i))
	 d10[i] = dw_list.GetitemNumber(1, 'a10'+string(i))
	 d20[i] = dw_list.GetitemNumber(1, 'a20'+string(i))
	 d25[i] = dw_list.GetitemNumber(1, 'a25'+string(i))
	 d26[i] = dw_list.GetitemNumber(1, 'a26'+string(i))
    d40[i] = dw_list.GetitemNumber(1, 'a40'+string(i)) 
	 d45[i] = dw_list.GetitemNumber(1, 'a45'+string(i)) 
	 d50[i] = dw_list.GetitemNumber(1, 'a50'+string(i)) 
	 d60[i] = dw_list.GetitemNumber(1, 'a60'+string(i)) 
	 d69[i] = dw_list.GetitemNumber(1, 'a69'+string(i)) 
	 d70[i] = dw_list.GetitemNumber(1, 'a70'+string(i)) 
	 d80[i] = dw_list.GetitemNumber(1, 'a80'+string(i)) 
	 d90[i] = dw_list.GetitemNumber(1, 'a90'+string(i)) 
	 
	 

if IsNull(d01[i]) then d01[i] = 0
if IsNull(d02[i]) then d02[i] = 0
if IsNull(d03[i]) then d03[i] = 0
if IsNull(d04[i]) then d04[i] = 0
if IsNull(d10[i]) then d10[i] = 0
if IsNull(d20[i]) then d20[i] = 0
if IsNull(d25[i]) then d25[i] = 0
if IsNull(d26[i]) then d26[i] = 0
if IsNull(d40[i]) then d40[i] = 0
if IsNull(d45[i]) then d45[i] = 0
if IsNull(d50[i]) then d50[i] = 0
if IsNull(d60[i]) then d60[i] = 0
if IsNull(d69[i]) then d69[i] = 0
if IsNull(d70[i]) then d70[i] = 0
if IsNull(d80[i]) then d80[i] = 0
if IsNull(d90[i]) then d90[i] = 0


if i = 6 then  /*당월조정 환급세액일경우*/
   if d10[6] > 0 then           
		if d10[3] > 0 then
			d10[7] = d10[6] - (d10[3] + d10[5])
			if d10[7] > 0 then
				if d10[4] > 0 then    /*농어촌세가 있을 경우*/
					d10[8] = d10[7] - d10[4]
					if d10[8] > 0 then
						d10[8] = 0
					else
						d10[8] = d10[4] - d10[7]
					end if
					d10[7] = 0
			   end if
			else
				d10[7] = d10[3] + d10[5] - d10[6]
				d10[8] = d10[4]
			end if
			
		elseif d10[3] <= 0 and d10[5] > 0 then	
			d10[7] = d10[6] - d10[5] 
			if d10[7] > 0 then
				if d10[4] > 0 then   /*농어촌세가 있을 경우*/
					d10[8] = d10[7] - d10[4]
					if d10[8] > 0 then
						d10[8] = 0
					else
						d10[8] = d10[4] - d10[7]
					end if
					d10[7] = 0
			   end if
			else
				d10[7] = d10[5] - d10[6]
				d10[8] = d10[4]
			end if		
		end if
		
	end if	
   if d20[6] > 0 then           
		if d20[3] > 0 then
			d20[7] = d20[6] - (d20[3] + d20[5])
			if d20[7] > 0 then
				if d20[4] > 0 then    /*농어촌세가 있을 경우*/
					d20[8] = d20[7] - d20[4]
					if d20[8] > 0 then
						d20[8] = 0
					else
						d20[8] = d20[4] - d20[7]
					end if
					d20[7] = 0
			   end if
			else
				d20[7] = d20[3] + d20[5] - d20[6]
				d20[8] = d20[4]
			end if
			
		elseif d20[3] <= 0 and d20[5] > 0 then	
			d20[7] = d20[6] - d20[5] 
			if d20[7] > 0 then
				if d20[4] > 0 then   /*농어촌세가 있을 경우*/
					d20[8] = d20[7] - d20[4]
					if d20[8] > 0 then
						d20[8] = 0
					else
						d20[8] = d20[4] - d20[7]
					end if
					d20[7] = 0
			   end if
			else
				d20[7] = d20[5] - d20[6]
				d20[8] = d20[4]
			end if		
		end if
		
	end if	
	
if d10[7] > 0 then 
  dw_list.Setitem(1,'a107', d10[7] )
else
  dw_list.Setitem(1,'a107', d107 )
end if

dw_list.Setitem(1,'a108', d10[8])
if d20[7] > 0 then 
  dw_list.Setitem(1,'a207', d20[7] )
else
  dw_list.Setitem(1,'a207', d207 )
end if	


end if


if i = 6 or i = 7 or i = 8 then
	d10[i]  = d10[i]
else
   d10[i] = d01[i] + d02[i] + d03[i] + d04[i]
end if
d30[i] = d25[i] + d26[i]
d99[i] = wf_plusamt(d10[i]) + wf_plusamt(d20[i]) + & 
         wf_plusamt(d25[i]) + wf_plusamt(d26[i]) + wf_plusamt(d40[i]) + wf_plusamt(d45[i]) + wf_plusamt(d50[i]) + &
			wf_plusamt(d60[i]) + wf_plusamt(d69[i]) + wf_plusamt(d70[i]) + wf_plusamt(d80[i]) + wf_plusamt(d90[i])

dw_list.Setitem(1,'a10'+string(i), d10[i])
dw_list.Setitem(1,'a30'+string(i), d30[i])
dw_list.Setitem(1,'a99'+string(i), d99[i])


Next

d107 = wf_plusamt( dw_list.GetitemNumber(1, 'a103'))+wf_plusamt( dw_list.GetitemNumber(1, 'a105'))

if d10[7] > 0 then 
  dw_list.Setitem(1,'a107', d10[7] )
else
  dw_list.Setitem(1,'a107', d107 )
end if

dw_list.Setitem(1,'a108', d10[8])
if d20[7] > 0 then 
  dw_list.Setitem(1,'a207', d20[7] )
else
  dw_list.Setitem(1,'a207', d207 )
end if

dw_list.Setitem(1,'a307', d30[3] + d30[5])
dw_list.Setitem(1,'a407', d40[3] + d40[5])
dw_list.Setitem(1,'a457', d45[3] + d45[5])
dw_list.Setitem(1,'a507', d50[3] + d50[5])
dw_list.Setitem(1,'a607', d60[3] + d60[5])
dw_list.Setitem(1,'a697', d69[3] + d69[5])
dw_list.Setitem(1,'a707', d70[3] + d70[5])
dw_list.Setitem(1,'a807', d80[3] + d80[5])
dw_list.Setitem(1,'a907', d90[3] + d90[5])


for i = 1 to 9
	p99[i] = dw_list.GetitemNumber(1, 'd99'+string(i))
	if IsNull(p99[i]) then p99[i] = 0
next



p99[4] = d10[3] + d10[4] + d10[5]
if p99[4] < 0 then           /*당월발생 환급세액(일반환급)*/
	p99[4] = p99[4] * -1
else
	p99[4] = 0
end if	

p99[3] = p99[1] - p99[2]    /*차감잔액*/

p99[7] = p99[3] + p99[4] + p99[5] + p99[6]  /*조정대상 환급세액*/
p99[8] = d99[6]                             /*당월조정 환급세액계*/
p99[9] = p99[7] - p99[8]                    /*차월이월 환급세액*/

dw_list.Setitem(1, 'd993', p99[3])
dw_list.Setitem(1, 'd994', p99[4]) 
dw_list.Setitem(1, 'd997', p99[7]) 
dw_list.Setitem(1, 'd998', p99[8]) 
dw_list.Setitem(1, 'd999', p99[9]) 


return 



end event

type p_mod from picture within wp_pip5010_save
integer x = 4224
integer y = 16
integer width = 178
integer height = 144
boolean bringtotop = true
string picturename = "C:\erpman\image\저장_d.gif"
boolean focusrectangle = false
end type

event clicked;Int iRow

tab_won.tabpage_won1.dw_won1.accepttext()
tab_won.tabpage_won2.dw_won2.accepttext()
tab_won.tabpage_gita1.dw_gita1.accepttext()
tab_won.tabpage_gita2.dw_gita2.accepttext()
tab_won.tabpage_saup1.dw_saup1.accepttext()
tab_won.tabpage_saup2.dw_saup2.accepttext()
tab_won.tabpage_ija.dw_ija.accepttext()

iRow = tab_won.tabpage_won1.dw_won1.getrow()

w_mdi_frame.sle_msg.text = ""

Setpointer(Hourglass!)

IF tab_won.tabpage_won1.dw_won1.Update() < 0 THEN
	Rollback;
	Messagebox("오류", "원천징수 이행상황 신고서(갑) 저장 오류입니다")
	Setpointer(Arrow!)
	Return
END IF

IF tab_won.tabpage_won2.dw_won2.Update() < 0 THEN
	Rollback;
	Messagebox("오류", "원천징수 이행상황 신고서(부표) 저장 오류입니다")
	Setpointer(Arrow!)
	Return
END IF

//IF tab_won.tabpage_gita1.dw_gita1.Update() < 0 THEN
//	Rollback;
//	Messagebox("오류", "기타소득 지급조서(갑) 저장 오류입니다")
//	Setpointer(Arrow!)
//	Return
//END IF
//
//IF tab_won.tabpage_gita2.dw_gita2.Update() < 0 THEN
//	Rollback;
//	Messagebox("오류", "기타소득 지급조서(부표) 저장 오류입니다")
//	Setpointer(Arrow!)
//	Return
//END IF

IF tab_won.tabpage_saup1.dw_saup1.Update() < 0 THEN
	Rollback;
	Messagebox("오류", "사업소득 지급조서(갑) 저장 오류입니다")
	Setpointer(Arrow!)
	Return
END IF

IF tab_won.tabpage_saup2.dw_saup2.Update() < 0 THEN
	Rollback;
	Messagebox("오류", "사업소득 지급조서(부표) 저장 오류입니다")
	Setpointer(Arrow!)
	Return
END IF

//IF tab_won.tabpage_ija.dw_ija.Update() < 0 THEN
//	Rollback;
//	Messagebox("오류", "이자배당소득 지급조서 저장 오류입니다")
//	Setpointer(Arrow!)
//	Return
//END IF
//
Commit;

Setpointer(Arrow!)

p_make.Enabled = True 
p_make.PictureName = "C:\erpman\image\자료생성_up.gif"

p_retrieve.Triggerevent(Clicked!)

w_mdi_frame.sle_msg.text = "저장되었습니다"
end event

type tab_won from tab within wp_pip5010_save
integer x = 59
integer y = 376
integer width = 4521
integer height = 1936
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean raggedright = true
boolean boldselectedtext = true
alignment alignment = center!
integer selectedtab = 1
tabpage_won1 tabpage_won1
tabpage_won2 tabpage_won2
tabpage_saup1 tabpage_saup1
tabpage_saup2 tabpage_saup2
tabpage_gita1 tabpage_gita1
tabpage_gita2 tabpage_gita2
tabpage_ija tabpage_ija
end type

on tab_won.create
this.tabpage_won1=create tabpage_won1
this.tabpage_won2=create tabpage_won2
this.tabpage_saup1=create tabpage_saup1
this.tabpage_saup2=create tabpage_saup2
this.tabpage_gita1=create tabpage_gita1
this.tabpage_gita2=create tabpage_gita2
this.tabpage_ija=create tabpage_ija
this.Control[]={this.tabpage_won1,&
this.tabpage_won2,&
this.tabpage_saup1,&
this.tabpage_saup2,&
this.tabpage_gita1,&
this.tabpage_gita2,&
this.tabpage_ija}
end on

on tab_won.destroy
destroy(this.tabpage_won1)
destroy(this.tabpage_won2)
destroy(this.tabpage_saup1)
destroy(this.tabpage_saup2)
destroy(this.tabpage_gita1)
destroy(this.tabpage_gita2)
destroy(this.tabpage_ija)
end on

event selectionchanged;IF tab_won.SelectedTab = 1 THEN
   if tab_won.tabpage_won1.dw_won1.rowcount() > 0 then		
	else
		tab_won.tabpage_won1.dw_won1.insertrow(0)
	end if
elseif  tab_won.SelectedTab = 2 THEN
	if tab_won.tabpage_won2.dw_won2.rowcount() > 0 then		
	else
		tab_won.tabpage_won2.dw_won2.insertrow(0)
	end if
elseif  tab_won.SelectedTab = 3 THEN
	if tab_won.tabpage_saup1.dw_saup1.rowcount() > 0 then		
	else
		tab_won.tabpage_saup1.dw_saup1.insertrow(0)
	end if
elseif  tab_won.SelectedTab = 4 THEN
	if tab_won.tabpage_saup2.dw_saup2.rowcount() > 0 then		
	else
		tab_won.tabpage_saup2.dw_saup2.insertrow(0)
	end if
end if
end event

type tabpage_won1 from userobject within tab_won
integer x = 18
integer y = 96
integer width = 4485
integer height = 1824
long backcolor = 32106727
string text = "원천징수 이행상황 신고서(갑)"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_2 rr_2
dw_won1 dw_won1
end type

on tabpage_won1.create
this.rr_2=create rr_2
this.dw_won1=create dw_won1
this.Control[]={this.rr_2,&
this.dw_won1}
end on

on tabpage_won1.destroy
destroy(this.rr_2)
destroy(this.dw_won1)
end on

type rr_2 from roundrectangle within tabpage_won1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 24
integer width = 4434
integer height = 1776
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_won1 from datawindow within tabpage_won1
event ue_pressenter pbm_dwnprocessenter
integer x = 41
integer y = 28
integer width = 4407
integer height = 1760
integer taborder = 30
boolean bringtotop = true
string dataobject = "dp_pip5010_save"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemerror;Return 1
end event

event itemchanged;long d01[8], d02[8], d03[8], d04[8], d10[8], d20[8], d25[8], d26[8], d30[8]
long d40[8], d45[8], d50[8], d60[8], d69[8], d70[8], d80[8], d90[8], d99[8]
long p99[9], d107,   d207,  d997
int i


if tab_won.tabpage_won1.dw_won1.Accepttext() = -1 then return

d207 = wf_plusamt( tab_won.tabpage_won1.dw_won1.GetitemNumber(1, 'a203'))+wf_plusamt( tab_won.tabpage_won1.dw_won1.GetitemNumber(1, 'a205'))

For i = 1 to 8
    d01[i] = tab_won.tabpage_won1.dw_won1.GetitemNumber(1, 'a01'+string(i))
	 d02[i] = tab_won.tabpage_won1.dw_won1.GetitemNumber(1, 'a02'+string(i))
    d03[i] = tab_won.tabpage_won1.dw_won1.GetitemNumber(1, 'a03'+string(i))	 
	 d04[i] = tab_won.tabpage_won1.dw_won1.GetitemNumber(1, 'a04'+string(i))
	 d10[i] = tab_won.tabpage_won1.dw_won1.GetitemNumber(1, 'a10'+string(i))
	 d20[i] = tab_won.tabpage_won1.dw_won1.GetitemNumber(1, 'a20'+string(i))
	 d25[i] = tab_won.tabpage_won1.dw_won1.GetitemNumber(1, 'a25'+string(i))
	 d26[i] = tab_won.tabpage_won1.dw_won1.GetitemNumber(1, 'a26'+string(i))
    d40[i] = tab_won.tabpage_won1.dw_won1.GetitemNumber(1, 'a40'+string(i)) 
	 d45[i] = tab_won.tabpage_won1.dw_won1.GetitemNumber(1, 'a45'+string(i)) 
	 d50[i] = tab_won.tabpage_won1.dw_won1.GetitemNumber(1, 'a50'+string(i)) 
	 d60[i] = tab_won.tabpage_won1.dw_won1.GetitemNumber(1, 'a60'+string(i)) 
	 d69[i] = tab_won.tabpage_won1.dw_won1.GetitemNumber(1, 'a69'+string(i)) 
	 d70[i] = tab_won.tabpage_won1.dw_won1.GetitemNumber(1, 'a70'+string(i)) 
	 d80[i] = tab_won.tabpage_won1.dw_won1.GetitemNumber(1, 'a80'+string(i)) 
	 d90[i] = tab_won.tabpage_won1.dw_won1.GetitemNumber(1, 'a90'+string(i)) 
	 
	 

if IsNull(d01[i]) then d01[i] = 0
if IsNull(d02[i]) then d02[i] = 0
if IsNull(d03[i]) then d03[i] = 0
if IsNull(d04[i]) then d04[i] = 0
if IsNull(d10[i]) then d10[i] = 0
if IsNull(d20[i]) then d20[i] = 0
if IsNull(d25[i]) then d25[i] = 0
if IsNull(d26[i]) then d26[i] = 0
if IsNull(d40[i]) then d40[i] = 0
if IsNull(d45[i]) then d45[i] = 0
if IsNull(d50[i]) then d50[i] = 0
if IsNull(d60[i]) then d60[i] = 0
if IsNull(d69[i]) then d69[i] = 0
if IsNull(d70[i]) then d70[i] = 0
if IsNull(d80[i]) then d80[i] = 0
if IsNull(d90[i]) then d90[i] = 0


if i = 6 then  /*당월조정 환급세액일경우*/
   if d10[6] > 0 then           
		if d10[3] > 0 then
			d10[7] = d10[6] - (d10[3] + d10[5])
			if d10[7] > 0 then
				if d10[4] > 0 then    /*농어촌세가 있을 경우*/
					d10[8] = d10[7] - d10[4]
					if d10[8] > 0 then
						d10[8] = 0
					else
						d10[8] = d10[4] - d10[7]
					end if
					d10[7] = 0
			   end if
			else
				d10[7] = d10[3] + d10[5] - d10[6]
				d10[8] = d10[4]
			end if
			
		elseif d10[3] <= 0 and d10[5] > 0 then	
			d10[7] = d10[6] - d10[5] 
			if d10[7] > 0 then
				if d10[4] > 0 then   /*농어촌세가 있을 경우*/
					d10[8] = d10[7] - d10[4]
					if d10[8] > 0 then
						d10[8] = 0
					else
						d10[8] = d10[4] - d10[7]
					end if
					d10[7] = 0
			   end if
			else
				d10[7] = d10[5] - d10[6]
				d10[8] = d10[4]
			end if		
		end if
		
	end if	
   if d20[6] > 0 then           
		if d20[3] > 0 then
			d20[7] = d20[6] - (d20[3] + d20[5])
			if d20[7] > 0 then
				if d20[4] > 0 then    /*농어촌세가 있을 경우*/
					d20[8] = d20[7] - d20[4]
					if d20[8] > 0 then
						d20[8] = 0
					else
						d20[8] = d20[4] - d20[7]
					end if
					d20[7] = 0
			   end if
			else
				d20[7] = d20[3] + d20[5] - d20[6]
				d20[8] = d20[4]
			end if
			
		elseif d20[3] <= 0 and d20[5] > 0 then	
			d20[7] = d20[6] - d20[5] 
			if d20[7] > 0 then
				if d20[4] > 0 then   /*농어촌세가 있을 경우*/
					d20[8] = d20[7] - d20[4]
					if d20[8] > 0 then
						d20[8] = 0
					else
						d20[8] = d20[4] - d20[7]
					end if
					d20[7] = 0
			   end if
			else
				d20[7] = d20[5] - d20[6]
				d20[8] = d20[4]
			end if		
		end if
		
	end if	
	
if d10[7] > 0 then 
  tab_won.tabpage_won1.dw_won1.Setitem(1,'a107', d10[7] )
else
  tab_won.tabpage_won1.dw_won1.Setitem(1,'a107', d107 )
end if

tab_won.tabpage_won1.dw_won1.Setitem(1,'a108', d10[8])
if d20[7] > 0 then 
  tab_won.tabpage_won1.dw_won1.Setitem(1,'a207', d20[7] )
else
  tab_won.tabpage_won1.dw_won1.Setitem(1,'a207', d207 )
end if	


end if


if i = 6 or i = 7 or i = 8 then
	d10[i]  = d10[i]
else
   d10[i] = d01[i] + d02[i] + d03[i] + d04[i]
end if
d30[i] = d25[i] + d26[i]
d99[i] = wf_plusamt(d10[i]) + wf_plusamt(d20[i]) + & 
         wf_plusamt(d25[i]) + wf_plusamt(d26[i]) + wf_plusamt(d40[i]) + wf_plusamt(d45[i]) + wf_plusamt(d50[i]) + &
			wf_plusamt(d60[i]) + wf_plusamt(d69[i]) + wf_plusamt(d70[i]) + wf_plusamt(d80[i]) + wf_plusamt(d90[i])

tab_won.tabpage_won1.dw_won1.Setitem(1,'a10'+string(i), d10[i])
tab_won.tabpage_won1.dw_won1.Setitem(1,'a30'+string(i), d30[i])
tab_won.tabpage_won1.dw_won1.Setitem(1,'a99'+string(i), d99[i])


Next


d107 = wf_plusamt( tab_won.tabpage_won1.dw_won1.GetitemNumber(1, 'a103'))+wf_plusamt( tab_won.tabpage_won1.dw_won1.GetitemNumber(1, 'a105'))

if d10[7] > 0 then 
  tab_won.tabpage_won1.dw_won1.Setitem(1,'a107', d10[7] )
else
  tab_won.tabpage_won1.dw_won1.Setitem(1,'a107', d107 )
end if

tab_won.tabpage_won1.dw_won1.Setitem(1,'a108', d10[8])
if d20[7] > 0 then 
  tab_won.tabpage_won1.dw_won1.Setitem(1,'a207', d20[7] )
else
  tab_won.tabpage_won1.dw_won1.Setitem(1,'a207', d207 )
end if

tab_won.tabpage_won1.dw_won1.Setitem(1,'a307', d30[3] + d30[5])
tab_won.tabpage_won1.dw_won1.Setitem(1,'a407', d40[3] + d40[5])
tab_won.tabpage_won1.dw_won1.Setitem(1,'a457', d45[3] + d45[5])
tab_won.tabpage_won1.dw_won1.Setitem(1,'a507', d50[3] + d50[5])
tab_won.tabpage_won1.dw_won1.Setitem(1,'a607', d60[3] + d60[5])
tab_won.tabpage_won1.dw_won1.Setitem(1,'a697', d69[3] + d69[5])
tab_won.tabpage_won1.dw_won1.Setitem(1,'a707', d70[3] + d70[5])
tab_won.tabpage_won1.dw_won1.Setitem(1,'a807', d80[3] + d80[5])
tab_won.tabpage_won1.dw_won1.Setitem(1,'a907', d90[3] + d90[5])


d997 = wf_plusamt(tab_won.tabpage_won1.dw_won1.GetitemNumber(1, 'a107'))  + &
		 wf_plusamt(tab_won.tabpage_won1.dw_won1.GetitemNumber(1, 'a207'))  + &
		 wf_plusamt(tab_won.tabpage_won1.dw_won1.GetitemNumber(1, 'a307'))  + &
		 wf_plusamt(tab_won.tabpage_won1.dw_won1.GetitemNumber(1, 'a407'))  + &
		 wf_plusamt(tab_won.tabpage_won1.dw_won1.GetitemNumber(1, 'a457'))  + &
		 wf_plusamt(tab_won.tabpage_won1.dw_won1.GetitemNumber(1, 'a507'))  + &
		 wf_plusamt(tab_won.tabpage_won1.dw_won1.GetitemNumber(1, 'a607'))  + &
		 wf_plusamt(tab_won.tabpage_won1.dw_won1.GetitemNumber(1, 'a697'))  + &
		 wf_plusamt(tab_won.tabpage_won1.dw_won1.GetitemNumber(1, 'a707'))  + &
		 wf_plusamt(tab_won.tabpage_won1.dw_won1.GetitemNumber(1, 'a807'))  + &
		 wf_plusamt(tab_won.tabpage_won1.dw_won1.GetitemNumber(1, 'a907'))  
tab_won.tabpage_won1.dw_won1.Setitem(1,'a997', d997)		 


for i = 1 to 9
	p99[i] = tab_won.tabpage_won1.dw_won1.GetitemNumber(1, 'd99'+string(i))
	if IsNull(p99[i]) then p99[i] = 0
next



p99[4] = d10[3] + d10[4] + d10[5]
if p99[4] < 0 then           /*당월발생 환급세액(일반환급)*/
	p99[4] = p99[4] * -1
else
	p99[4] = 0
end if	

p99[3] = p99[1] - p99[2]    /*차감잔액*/



p99[7] = p99[3] + p99[4] + p99[5] + p99[6]  /*조정대상 환급세액*/
p99[8] = d99[6]                             /*당월조정 환급세액계*/
p99[9] = p99[7] - p99[8]                    /*차월이월 환급세액*/

tab_won.tabpage_won1.dw_won1.Setitem(1, 'd993', p99[3])
tab_won.tabpage_won1.dw_won1.Setitem(1, 'd994', p99[4]) 
tab_won.tabpage_won1.dw_won1.Setitem(1, 'd997', p99[7]) 
tab_won.tabpage_won1.dw_won1.Setitem(1, 'd998', p99[8]) 
tab_won.tabpage_won1.dw_won1.Setitem(1, 'd999', p99[9]) 


return 



end event

type tabpage_won2 from userobject within tab_won
integer x = 18
integer y = 96
integer width = 4485
integer height = 1824
long backcolor = 32106727
string text = "부표"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_3 rr_3
dw_won2 dw_won2
end type

on tabpage_won2.create
this.rr_3=create rr_3
this.dw_won2=create dw_won2
this.Control[]={this.rr_3,&
this.dw_won2}
end on

on tabpage_won2.destroy
destroy(this.rr_3)
destroy(this.dw_won2)
end on

type rr_3 from roundrectangle within tabpage_won2
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 24
integer width = 4434
integer height = 1776
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_won2 from datawindow within tabpage_won2
event ue_pressenter pbm_dwnprocessenter
integer x = 41
integer y = 36
integer width = 4407
integer height = 1748
integer taborder = 40
boolean bringtotop = true
string dataobject = "dw_ktxa501p1"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemerror;Return 1
end event

type tabpage_saup1 from userobject within tab_won
integer x = 18
integer y = 96
integer width = 4485
integer height = 1824
long backcolor = 32106727
string text = "사업소득 지급조서"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_6 rr_6
dw_saup1 dw_saup1
end type

on tabpage_saup1.create
this.rr_6=create rr_6
this.dw_saup1=create dw_saup1
this.Control[]={this.rr_6,&
this.dw_saup1}
end on

on tabpage_saup1.destroy
destroy(this.rr_6)
destroy(this.dw_saup1)
end on

type rr_6 from roundrectangle within tabpage_saup1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 24
integer width = 4421
integer height = 1772
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_saup1 from datawindow within tabpage_saup1
event ue_pressenter pbm_dwnprocessenter
integer x = 41
integer y = 36
integer width = 4393
integer height = 1748
integer taborder = 40
string title = "none"
string dataobject = "dw_ktxa503p"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemerror;Return 1
end event

type tabpage_saup2 from userobject within tab_won
integer x = 18
integer y = 96
integer width = 4485
integer height = 1824
long backcolor = 32106727
string text = "부표"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_7 rr_7
dw_saup2 dw_saup2
end type

on tabpage_saup2.create
this.rr_7=create rr_7
this.dw_saup2=create dw_saup2
this.Control[]={this.rr_7,&
this.dw_saup2}
end on

on tabpage_saup2.destroy
destroy(this.rr_7)
destroy(this.dw_saup2)
end on

type rr_7 from roundrectangle within tabpage_saup2
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 24
integer width = 4421
integer height = 1772
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_saup2 from datawindow within tabpage_saup2
event ue_pressenter pbm_dwnprocessenter
integer x = 41
integer y = 36
integer width = 4393
integer height = 1748
integer taborder = 40
string title = "none"
string dataobject = "dw_ktxa503p1"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemerror;Return 1
end event

type tabpage_gita1 from userobject within tab_won
boolean visible = false
integer x = 18
integer y = 96
integer width = 4485
integer height = 1824
boolean enabled = false
long backcolor = 32106727
string text = "기타소득 지급조서"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
dw_gita1 dw_gita1
rr_4 rr_4
end type

on tabpage_gita1.create
this.dw_gita1=create dw_gita1
this.rr_4=create rr_4
this.Control[]={this.dw_gita1,&
this.rr_4}
end on

on tabpage_gita1.destroy
destroy(this.dw_gita1)
destroy(this.rr_4)
end on

type dw_gita1 from datawindow within tabpage_gita1
event ue_pressenter pbm_dwnprocessenter
integer x = 41
integer y = 36
integer width = 4393
integer height = 1748
integer taborder = 40
string title = "none"
string dataobject = "dw_ktxa502p"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemerror;Return 1
end event

type rr_4 from roundrectangle within tabpage_gita1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 24
integer width = 4421
integer height = 1776
integer cornerheight = 40
integer cornerwidth = 55
end type

type tabpage_gita2 from userobject within tab_won
boolean visible = false
integer x = 18
integer y = 96
integer width = 4485
integer height = 1824
boolean enabled = false
long backcolor = 32106727
string text = "부표"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
dw_gita2 dw_gita2
rr_5 rr_5
end type

on tabpage_gita2.create
this.dw_gita2=create dw_gita2
this.rr_5=create rr_5
this.Control[]={this.dw_gita2,&
this.rr_5}
end on

on tabpage_gita2.destroy
destroy(this.dw_gita2)
destroy(this.rr_5)
end on

type dw_gita2 from datawindow within tabpage_gita2
event ue_pressenter pbm_dwnprocessenter
integer x = 41
integer y = 36
integer width = 4393
integer height = 1748
integer taborder = 40
string title = "none"
string dataobject = "dw_ktxa502p1"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemerror;Return 1
end event

type rr_5 from roundrectangle within tabpage_gita2
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 24
integer width = 4421
integer height = 1772
integer cornerheight = 40
integer cornerwidth = 55
end type

type tabpage_ija from userobject within tab_won
boolean visible = false
integer x = 18
integer y = 96
integer width = 4485
integer height = 1824
boolean enabled = false
long backcolor = 32106727
string text = "이자배당소득 지급조서"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
dw_ija dw_ija
rr_8 rr_8
end type

on tabpage_ija.create
this.dw_ija=create dw_ija
this.rr_8=create rr_8
this.Control[]={this.dw_ija,&
this.rr_8}
end on

on tabpage_ija.destroy
destroy(this.dw_ija)
destroy(this.rr_8)
end on

type dw_ija from datawindow within tabpage_ija
event ue_pressenter pbm_dwnprocessenter
integer x = 41
integer y = 36
integer width = 4393
integer height = 1748
integer taborder = 40
string title = "none"
string dataobject = "dw_ktxa504p"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;String sNull

SetNull(sNull)

IF dwo.name = "neguk" Or dwo.name = "woiguk" THEN
	IF data = "" OR IsNull(data) THEN Return
	
	IF data <> "V" THEN
		Messagebox("확인","내,외국인 구분은 'V'로 표시하십시오")
		this.SetItem(row,"gi_ym",sNull)
		Return 1
	END IF
END IF
end event

event itemerror;Return 1
end event

type rr_8 from roundrectangle within tabpage_ija
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 24
integer width = 4421
integer height = 1772
integer cornerheight = 40
integer cornerwidth = 55
end type

type p_make from picture within wp_pip5010_save
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 4224
integer y = 156
integer width = 178
integer height = 144
boolean bringtotop = true
boolean enabled = false
string picturename = "C:\erpman\image\자료생성_d.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;PictureName = 'C:\erpman\image\자료생성_dn.gif'
end event

event ue_lbuttonup;PictureName = 'C:\erpman\image\자료생성_up.gif'
end event

event clicked;Int    iCount,iRc
String sPath,sFileNm,sSaveFile,sSaupj,sGiYm,sJeYmd,sSaNo,sFile
datawindow ldw_1

dw_ip.accepttext()

sSaupj = dw_ip.getitemstring(dw_ip.getrow(),"saupcd")			//사업장
sGiYm = Trim(dw_ip.GetITemString(dw_ip.getrow(),"sym"))	//귀속년월
sJeYmd = Trim(dw_ip.GetITemString(dw_ip.getrow(),"sdate"))	//제출일자
sFileNm = Trim(dw_ip.GetITemString(dw_ip.getrow(),"spath"))


Choose Case tab_won.selectedtab
		
	Case 1,2
		
		IF Messagebox("전자신고파일생성","원천징수 이행상황신고서의 전자신고파일을 생성 하시겠습니까?",question!,yesno!,1) = 2 THEN Return

		iCount = dw_won.retrieve(sSaupj,sGiym)

		IF iCount = 0 THEN
			Messagebox("자료없음","원천징수 이행상황신고서의 대상자료가 존재하지 않습니다.",information!)
			Return
		END IF	

//		sFileNm = sJeYmd+".201"
		
		ldw_1 = dw_won
	
	Case 5,6
		
      IF Messagebox("전자신고파일생성","기타소득 지급조서의 전자신고파일을 생성 하시겠습니까?",Question!,YesNo!,1) = 2 then Return 		
	
		iCount = dw_gita.retrieve(sSaupj,sGiym)

		IF iCount = 0 THEN
			Messagebox("자료없음","기타소득 지급조서의 대상자료가 존재하지 않습니다.",Information!)
			Return
		END IF
		
		sFileNm = "G"+Mid(sSaNo,1,7)+"."+Mid(sSaNo,8,3)
		
		ldw_1 = dw_gita
		
	Case 3,4
		
      IF Messagebox("전자신고파일생성","사업소득 지급조서의 전자신고파일을 생성 하시겠습니까?",Question!,YesNo!,1) = 2 THEN Return
		
		iCount = dw_saup.retrieve(sSaupj,sGiYm)
		
     	IF iCount = 0 THEN
			Messagebox("자료없음","사업소득 지급조서의 대상자료가 존재하지 않습니다.",Information!)
			Return
		END IF
		
		sFileNm = "F"+Mid(sSaNo,1,7)+"."+Mid(sSaNo,8,3)
		
		ldw_1 = dw_saup
		
	Case 7
		
      IF Messagebox("전자신고파일생성","이자배당소득 지급조서의 전자신고파일을 생성 하시겠습니까?",Question!,YesNo!,1) = 2 THEN Return
		
		iCount = dw_ijabd.retrieve(sSaupj,sGiYm)
		
     	IF iCount = 0 THEN
			Messagebox("자료없음","이자배당소득 지급조서의 대상자료가 존재하지 않습니다.",Information!)
			Return
		END IF
		
		sFileNm = "B"+Mid(sSaNo,1,7)+"."+Mid(sSaNo,8,3)
		
		ldw_1 = dw_ijabd
		
	Case Else
		
		Return
		
End Choose
	
sSaveFile = sFileNm

ldw_1.SaveAs(sSaveFile,Text!,False)

w_mdi_frame.sle_msg.text = "자료가 생성되었습니다!"
end event

type dw_won from datawindow within wp_pip5010_save
boolean visible = false
integer x = 82
integer y = 2652
integer width = 1394
integer height = 96
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "원천징수 이행상황 신고서 파일 저장"
string dataobject = "dw_ktxa501s"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
boolean livescroll = true
end type

type dw_gita from datawindow within wp_pip5010_save
boolean visible = false
integer x = 82
integer y = 2748
integer width = 1394
integer height = 96
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "기타소득 지급조서 파일 저장"
string dataobject = "dw_ktxa502s"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
boolean livescroll = true
end type

type dw_saup from datawindow within wp_pip5010_save
boolean visible = false
integer x = 82
integer y = 2848
integer width = 1394
integer height = 100
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "사업소득 지급조서 파일저장"
string dataobject = "dw_ktxa503s"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
boolean livescroll = true
end type

type dw_ijabd from datawindow within wp_pip5010_save
boolean visible = false
integer x = 82
integer y = 2952
integer width = 1394
integer height = 96
integer taborder = 60
boolean bringtotop = true
boolean titlebar = true
string title = "이자배당소득 지급조서 파일 저장"
string dataobject = "dw_ktxa504s"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
boolean livescroll = true
end type

type p_del from uo_picture within wp_pip5010_save
integer x = 4050
integer y = 156
integer width = 178
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\erpman\image\삭제_d.gif"
end type

event clicked;call super::clicked;IF F_Dbconfirm("삭제") = 2 THEN Return

Setpointer(Hourglass!)

tab_won.tabpage_won1.dw_won1.deleterow(0)
tab_won.tabpage_won2.dw_won2.deleterow(0)
//tab_won.tabpage_gita1.dw_gita1.deleterow(0)
//tab_won.tabpage_gita2.dw_gita2.deleterow(0)
//tab_won.tabpage_saup1.dw_saup1.deleterow(0)
//tab_won.tabpage_saup2.dw_saup2.deleterow(0)
//tab_won.tabpage_ija.dw_ija.deleterow(0)

IF tab_won.tabpage_won1.dw_won1.Update() < 0 THEN
	Rollback;
	Messagebox("오류", "원천징수 이행상황 신고서(갑) 삭제 오류입니다")
	Setpointer(Arrow!)
	Return
END IF

IF tab_won.tabpage_won2.dw_won2.Update() < 0 THEN
	Rollback;
	Messagebox("오류", "원천징수 이행상황 신고서(부표) 삭제 오류입니다")
	Setpointer(Arrow!)
	Return
END IF

//IF tab_won.tabpage_gita1.dw_gita1.Update() < 0 THEN
//	Rollback;
//	Messagebox("오류", "기타소득 지급조서(갑) 삭제 오류입니다")
//	Setpointer(Arrow!)
//	Return
//END IF
//
//IF tab_won.tabpage_gita2.dw_gita2.Update() < 0 THEN
//	Rollback;
//	Messagebox("오류", "기타소득 지급조서(부표) 삭제 오류입니다")
//	Setpointer(Arrow!)
//	Return
//END IF
//
//IF tab_won.tabpage_saup1.dw_saup1.Update() < 0 THEN
//	Rollback;
//	Messagebox("오류", "사업소득 지급조서(갑) 삭제 오류입니다")
//	Setpointer(Arrow!)
//	Return
//END IF
//
//IF tab_won.tabpage_saup2.dw_saup2.Update() < 0 THEN
//	Rollback;
//	Messagebox("오류", "사업소득 지급조서(부표) 삭제 오류입니다")
//	Setpointer(Arrow!)
//	Return
//END IF
//
//IF tab_won.tabpage_ija.dw_ija.Update() < 0 THEN
//	Rollback;
//	Messagebox("오류", "이자배당소득 지급조서 삭제 오류입니다")
//	Setpointer(Arrow!)
//	Return
//END IF
//
Commit;

Setpointer(Arrow!)

p_mod.Enabled = False
p_mod.PictureName = "C:\erpman\image\저장_d.gif"
p_del.Enabled = False
p_del.PictureName = "C:\erpman\image\삭제_d.gif"
p_print.Enabled = False
p_print.PictureName = "C:\erpman\image\인쇄_d.gif"
p_make.Enabled = False
p_make.PictureName = "C:\erpman\image\자료생성_d.gif"

w_mdi_frame.sle_msg.text = "삭제되었습니다"


IF tab_won.SelectedTab = 1 THEN
   if tab_won.tabpage_won1.dw_won1.rowcount() > 0 then		
	else
		tab_won.tabpage_won1.dw_won1.insertrow(0)
	end if
elseif  tab_won.SelectedTab = 2 THEN
	if tab_won.tabpage_won2.dw_won2.rowcount() > 0 then		
	else
		tab_won.tabpage_won2.dw_won2.insertrow(0)
	end if
end if
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\삭제_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\삭제_dn.gif"
end event

type st_1 from statictext within wp_pip5010_save
integer x = 1906
integer y = 400
integer width = 1723
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
string text = "재 생성시 삭제하시고 다시 조회,저장하셔서 생성하세요!!"
alignment alignment = center!
boolean focusrectangle = false
end type

