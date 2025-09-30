$PBExportHeader$wp_pip5010.srw
$PBExportComments$** 원천징수이행상황신고서(2)
forward
global type wp_pip5010 from w_standard_print
end type
type dw_4 from datawindow within wp_pip5010
end type
type dw_1 from datawindow within wp_pip5010
end type
type cb_2 from commandbutton within wp_pip5010
end type
type rr_1 from roundrectangle within wp_pip5010
end type
end forward

global type wp_pip5010 from w_standard_print
integer x = 0
integer y = 0
string title = "원천징수이행상황신고서"
dw_4 dw_4
dw_1 dw_1
cb_2 cb_2
rr_1 rr_1
end type
global wp_pip5010 wp_pip5010

forward prototypes
public function integer wf_update ()
public function integer wf_retrieve ()
end prototypes

public function integer wf_update ();Return 1
end function

public function integer wf_retrieve ();String S_SAUPNO,S_SANAME,S_PRESIDENT,S_ADDR,S_ZIP,S_Jongmok,S_Uptae,S_TEL
String StartYear1,StartYear2,StartYear3,sPbTag,sSaupcd,sDate, sdayworkgubn,tym,sabu,sKunmu
int    inwon11, inwon12 ,inwon13,inwon21,inwon22, inwon31, inwon41, inwon42
double totamt11,totamt12,totamt13,totamt21,totamt22,totamt23,totamt24,totamt31, totamt41, totamt42, totamt43, totamt44 
int inwon61, inwon401, inwon201
double totamt62, totamt63, totamt402, totamt403, totamt202,totamt203
string spym, sSemu

if dw_4.AcceptText() = -1 then return -1

StartYear1 = dw_4.GetITemString(1,"sym")   /*근로소득귀속년월*/
tym = dw_4.GetITemString(1,"sym1")   /*원천징수년월*/
StartYear3 = dw_4.GetITemString(1,"yearyymm")   /*연말정산년월*/
sdayworkgubn = dw_4.GetITemString(1,"dayworkgubn")   /*일용직신고여부*/
sPbTag = dw_4.getitemstring(1,"gubn") /*급여,상여 구분*/
sSaupcd = dw_4.getitemstring(1,"saupcd") /*사업장구분*/
sDate = dw_4.getitemstring(1,"sdate") /*제출일자*/
sKunmu = trim(dw_4.GetitemString(1,'kunmu')) /*근무구분*/
sSemu = trim(dw_4.GetitemString(1,'semu')) /*세무서명*/

if StartYear1 = '' or isnull(StartYear1) then
	messagebox("확인","근로소득귀속년월을 입력하십시오")
	dw_4.setcolumn("sym")
	dw_4.setfocus()
	return -1
end if	

if StartYear3 = '' or isnull(StartYear3) then StartYear3 = ''
if sPbtag = '' or isnull(sPbtag) then sPbtag = '%'
if sSaupcd = '' or isnull(sSaupcd) then sSaupcd = '%'
IF sKunmu = '' OR IsNull(sKunmu) THEN sKunmu = '%'
if sDate = '' or isnull(sDate) then sDate = gs_today

SetPointer(HourGlass!)
dw_list.SetRedraw(False)

dw_list.Reset()
//dw_1.reset()
dw_list.insertrow(0)
//dw_1.insertrow(0)

/*원천징수의무자*/
  SELECT SAUPNO, JURNAME, CHAIRMAN, ADDR, PHONE
    INTO :S_SAUPNO,			//사업자번호
	 		:S_SANAME,			//사업장명
			:S_PRESIDENT,		//대표자명
			:S_ADDR,				//사업장주소
			:S_TEL				//사업장전화번호
    FROM "P0_SAUPCD"
   WHERE COMPANYCODE = 'KN' AND
			SAUPCODE = DECODE(:sSaupcd,'%','10',:sSaupcd);

if IsNull(spym) or spym = '' then
	spym = StartYear1
end if

SELECT sum(decode(a.pbtag,'P',1,0)) as inwon1, 
		  sum(decode(a.pbtag,'P',1,1)) as inwon3, 	
            sum(a.totpayamt)+sum(nvl(a.etcamt,0))  as totamt1,
		 x.inwon2 , x.totamt2 , x.tax1
  into :inwon11, :inwon13 , :totamt11, :inwon12, :totamt12, :totamt13  		 
  FROM "P3_EDITDATA" a,"P1_MASTER" b, "P0_DEPT" c,
      (SELECT count(*) as inwon2,sum(a.taxtotpay) as totamt2, sum(d.allowamt) as tax1
         FROM "P3_EDITDATA" a, "P1_MASTER" b, "P0_DEPT" c, "P3_EDITDATACHILD" d
	  WHERE ( a.EMPNO = b.EMPNO ) AND
             ( a.workym = d.workym ) and
             ( a.pbtag = d.pbtag ) and
             ( a.empno = d.empno ) and
			    ( b.DEPTCODE = c.DEPTCODE ) AND
             ( b.COMPANYCODE = c.COMPANYCODE ) AND
             ( c.saupcd LIKE :sSaupcd ) AND
				 ( b.kunmugubn like :sKunmu ) AND
			    ( ( a.workym = :StartYear1 ) AND
				 ( a.PBTAG like :sPbTag ) AND
                      ( d.gubun = '2' ) AND
                      ( d.allowcode = '01' ) ) ) x
   WHERE  a.EMPNO = b.EMPNO AND
			 b.kunmugubn LIKE :sKunmu and
          b.DEPTCODE = c.DEPTCODE AND
       	 b.COMPANYCODE = c.COMPANYCODE AND
		 	 c.SAUPCD LIKE :sSaupcd AND
          a.workym  = :StartYear1 AND
          a.PBTAG like :sPbTag 
	group by x.inwon2 , x.totamt2 , x.tax1;

	if isnull(inwon11) then inwon11 = 0 
	if isnull(inwon12) then inwon12 = 0 
	if isnull(inwon13) then inwon13 = 0 
	if isnull(totamt11) then totamt11 = 0 
	if isnull(totamt12) then totamt12 = 0 
	if isnull(totamt13) then totamt13 = 0 
	
if sqlca.sqlcode <> 0 then	
	messagebox("확인","출력할 자료가 없습니다")
	dw_list.setredraw(TRUE)
	return -1
end if

dw_list.setitem(1,"yymm1",spym)
dw_list.setitem(1,"yymm2",tym)
dw_list.setitem(1,"sname",S_SANAME)
dw_list.setitem(1,"spname",S_PRESIDENT)
dw_list.setitem(1,"ssno",S_SAUPNO)
dw_list.setitem(1,"saddr",S_ADDR)
dw_list.setitem(1,"stel",S_TEL)
dw_list.setitem(1,"sdate",sDate)
dw_list.setitem(1,"spname1",S_PRESIDENT)
dw_list.setitem(1,"semus",sSemu)

if spbtag = '%' then
	dw_list.setitem(1,"a011",inwon11)
else
	dw_list.setitem(1,"a011",inwon13)
end if	
dw_list.setitem(1,"a012",totamt11)
dw_list.setitem(1,"a013",totamt13)

/*일용직*/
select count(empno),sum(nvl(totpayamt,0))
  into :inwon11, :totamt11
  from p2_editdata
 where workym = :StartYear1 and
	    pbtag like :sPbTag;

dw_list.setitem(1,"a031",inwon11)
dw_list.setitem(1,"a032",totamt11)
//dw_list.setitem(1,"a017",totamt13)


///*중도정산분*/
IF sPbtag = '%' or sPbtag = 'P' THEN 
	SELECT count(*) as inwon1,   
			 sum(a.etcamt + a.foreignworkincome +  a.nightworkpay +  a.etctaxfree + a.WORKINCOMEGROSS) as totamt1,  
			 sum(decode(a.NETINCOMETAX,0,0,1) ) as inwon2, 
			 sum(decode(a.NETINCOMETAX,0,0,a.WORKINCOMEGROSS) ) as totamt2,  
			 x.totamt3, y.totamt4  	
	 INTO  :inwon41, :totamt41, :inwon42, :totamt42, :totamt43, :totamt44		 
	 FROM "P3_ACNT_TAXCAL_DATA" a,"P1_MASTER" b, "P0_DEPT" c, "P0_SAUPCD" d,
		  (SELECT sum(a.NETINCOMETAX ) as totamt3   	
			  FROM "P3_ACNT_TAXCAL_DATA" a ,"P1_MASTER" b, "P0_DEPT" c 
			 WHERE ( a.WORKYEAR = substr(:StartYear1,1,4) ) AND  
					 ( a.WORKMM = substr(:StartYear1 ,5,2) ) AND  
					 ( a.companycode = b.companycode ) and
					 ( a.empno = b.empno ) and
					 ( a.companycode = c.companycode ) and
					 ( b.deptcode = c.deptcode ) and
					 (c.SAUPCD LIKE :sSaupcd) AND
					 ( b.kunmugubn like :sKunmu ) AND
					 ( a.TAG = '2' )  AND
					 ( a.NETINCOMETAX > 0 )) x, 
			(SELECT sum(a.NETINCOMETAX ) as totamt4  	
				FROM "P3_ACNT_TAXCAL_DATA" a,"P1_MASTER" b, "P0_DEPT" c  
			  WHERE ( a.WORKYEAR = substr(:StartYear1,1,4) ) AND  
					 ( a.WORKMM = substr(:StartYear1 ,5,2) ) AND  
					 ( a.companycode = b.companycode ) and
					 ( a.empno = b.empno ) and
					 ( a.companycode = c.companycode ) and
					 ( b.deptcode = c.deptcode ) and
					 (c.SAUPCD LIKE :sSaupcd) AND
					 ( b.kunmugubn like :sKunmu ) AND
					 ( a.TAG = '2' )  AND
					 (a.NETINCOMETAX < 0 )) y
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
				 a.TAG = '2'  
	group by x.totamt3, y.totamt4 ;

	if isnull(inwon41) then inwon41 = 0 
	if isnull(inwon42) then inwon42 = 0 
	if isnull(totamt41) then totamt41 = 0 
	if isnull(totamt42) then totamt42 = 0 
	if isnull(totamt43) then totamt43 = 0 
	if isnull(totamt44) then totamt44 = 0 
	
	if sqlca.sqlcode <> 0 then	
		inwon41 = 0
		inwon42 = 0
		totamt41 = 0
		totamt42 = 0
		totamt43 = 0	
		totamt44 = 0		
	end if
	
	dw_list.setitem(1,"a021",inwon41)
	dw_list.setitem(1,"a022",totamt41)
	dw_list.setitem(1,"a023",totamt43 + totamt44)
	//dw_list.setitem(1,"a026",totamt44)
	//dw_list.setitem(1,"a027",totamt43)
END IF

/*연말정산분*/
SELECT count(*) as inwon1,   
       sum(a.etcamt + a.foreignworkincome +  a.nightworkpay +  a.etctaxfree + a.WORKINCOMEGROSS) as totamt1,  
		 sum(decode(a.NETINCOMETAX,0,0,1) ) as inwon2, 
	  	 sum(decode(a.NETINCOMETAX,0,0,a.WORKINCOMEGROSS) ) as totamt2,  
		 x.totamt3, y.totamt4  	
 INTO  :inwon21, :totamt21, :inwon22, :totamt22, :totamt23, :totamt24		 
 FROM "P3_ACNT_TAXCAL_DATA" a,"P1_MASTER" b, "P0_DEPT" c, "P0_SAUPCD" d,
	  (SELECT sum(a.NETINCOMETAX ) as totamt3   	
    	  FROM "P3_ACNT_TAXCAL_DATA" a ,"P1_MASTER" b, "P0_DEPT" c 
		 WHERE ( a.WORKYEAR = substr(:StartYear3,1,4) ) AND  
      	    ( a.WORKMM = substr(:StartYear3 ,5,2) ) AND  
				 ( a.companycode = b.companycode ) and
				 ( a.empno = b.empno ) and
				 ( a.companycode = c.companycode ) and
				 ( b.deptcode = c.deptcode ) and
				 (c.SAUPCD LIKE :sSaupcd) AND
				 ( b.kunmugubn like :sKunmu ) AND
		       ( a.TAG = '1' )  AND
				 ( a.NETINCOMETAX > 0 )) x, 
	   (SELECT sum(a.NETINCOMETAX ) as totamt4  	
    	   FROM "P3_ACNT_TAXCAL_DATA" a,"P1_MASTER" b, "P0_DEPT" c  
		  WHERE ( a.WORKYEAR = substr(:StartYear3,1,4) ) AND  
      	    ( a.WORKMM = substr(:StartYear3 ,5,2) ) AND  
				 ( a.companycode = b.companycode ) and
				 ( a.empno = b.empno ) and
				 ( a.companycode = c.companycode ) and
				 ( b.deptcode = c.deptcode ) and
				 (c.SAUPCD LIKE :sSaupcd) AND
				 ( b.kunmugubn like :sKunmu ) AND
		       ( a.TAG = '1' )  AND
				 (a.NETINCOMETAX < 0 )) y
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
          a.TAG = '1'  
group by x.totamt3, y.totamt4 ;   

if isnull(inwon21) then inwon21 = 0 
if isnull(inwon22) then inwon22 = 0 
if isnull(totamt21) then totamt21 = 0 
if isnull(totamt22) then totamt22 = 0 
if isnull(totamt23) then totamt23 = 0 
if isnull(totamt24) then totamt24 = 0 

if sqlca.sqlcode <> 0 then	
	inwon21 = 0
	inwon22 = 0
	totamt21 = 0
	totamt22 = 0
	totamt23 = 0	
	totamt24 = 0		
end if

dw_list.setitem(1,"a041",inwon21)
dw_list.setitem(1,"a042",totamt21)
dw_list.setitem(1,"a043",totamt23 + totamt24)
//dw_list.setitem(1,"a046",totamt24)
//dw_list.setitem(1,"a047",totamt23)

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
dw_list.setitem(1,"a201",inwon201)
dw_list.setitem(1,"a202",totamt202)
dw_list.setitem(1,"a203",totamt203)

//select count(cvcod) as inwon1,
//       sum(totpayamt) as totamt,
//       sum(incometax) as incometax
//into   :inwon61, :totamt62, :totamt63	 
//from p7_saup
//where saupcd = :Ssaupcd and
//      substr(wdate,1,6) = :StartYear1 ;
		
if sqlca.sqlcode <> 0 then
	inwon61 = 0
	totamt62 = 0
	totamt63 = 0
end if

//select count(cvcod) as inwon1,
//       sum(interest) as totamt,
//       sum(incometax) as incometax
//into   :inwon401, :totamt402, :totamt403	 
//from p7_etc
//from saupcd = :Ssaupcd and
//     substr(wdate,1,6) = :StartYear1 ;
	  
if sqlca.sqlcode <> 0 then	  
	inwon401 = 0
	totamt402 = 0
	totamt403 = 0 
end if

dw_list.setitem(1,"a261", inwon61)
dw_list.setitem(1,"a262", totamt62)
dw_list.setitem(1,"a263", totamt63)
dw_list.setitem(1,"a401", inwon401)
dw_list.setitem(1,"a402", totamt402)
dw_list.setitem(1,"a403", totamt403)


/*계*/

dw_list.setitem(1,"a991",inwon11  + inwon21 +  inwon41 + inwon61 + inwon401)
dw_list.setitem(1,"a992",totamt11 + totamt21 + totamt41 + totamt62 + totamt402)
dw_list.setitem(1,"a993",totamt13 + totamt23 + totamt43 + totamt63 + totamt403)
dw_list.setitem(1,"a996",totamt24)
dw_list.setitem(1,"a997",totamt13 + totamt23)



dw_list.SetRedraw(True)
//dw_1.setredraw(true)
SetPointer(Arrow!)

Return 1
end function

on wp_pip5010.create
int iCurrent
call super::create
this.dw_4=create dw_4
this.dw_1=create dw_1
this.cb_2=create cb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_4
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.cb_2
this.Control[iCurrent+4]=this.rr_1
end on

on wp_pip5010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_4)
destroy(this.dw_1)
destroy(this.cb_2)
destroy(this.rr_1)
end on

event open;call super::open;w_mdi_frame.sle_msg.text = ''
w_mdi_frame.sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 세로방향"

dw_4.SetTransObject(sqlca)
dw_1.settransobject(sqlca)
dw_list.insertrow(0)
dw_4.insertrow(0)

f_set_saupcd(dw_4, 'saupcd', '1')
is_saupcd = gs_saupcd

dw_4.SetITem(1,"sym",string(gs_today, '@@@@@@'))
dw_4.SetITem(1,"sym1",string(gs_today, '@@@@@@'))

dw_4.SetITem(1,"sdate",string(gs_today, '@@@@@@@@'))


end event

type p_preview from w_standard_print`p_preview within wp_pip5010
integer x = 4078
boolean enabled = true
end type

event p_preview::clicked;if is_preview = 'no' then
	if dw_1.object.datawindow.print.preview = "yes" then
		dw_1.object.datawindow.print.preview = "no"
		
	else
		dw_1.object.datawindow.print.preview = "yes"	
		
	end if	
end if

OpenWithParm(w_print_preview, dw_list)	

end event

type p_exit from w_standard_print`p_exit within wp_pip5010
integer x = 4425
end type

type p_print from w_standard_print`p_print within wp_pip5010
integer x = 4251
boolean enabled = true
end type

event p_print::clicked;IF dw_print.rowcount() > 0 then 
	gi_page = dw_print.GetItemNumber(1,"last_page")
ELSE
	gi_page = 1
END IF
OpenWithParm(w_print_options, dw_list)
end event

type p_retrieve from w_standard_print`p_retrieve within wp_pip5010
integer x = 3904
end type

event p_retrieve::clicked;
IF wf_retrieve() = -1 THEN
	p_print.Enabled =False
	p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'
	p_preview.enabled = False
	p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
	SetPointer(Arrow!)
	Return
ELSE
	p_print.Enabled =True
	p_print.PictureName =  'C:\erpman\image\인쇄_up.gif'
	p_preview.enabled = true
	p_preview.PictureName = 'C:\erpman\image\미리보기_up.gif'
END IF

/* Last page 구하는 routine */
long Li_row = 1, Ll_prev_row

dw_list.setredraw(false)
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

dw_list.scrolltorow(1)
dw_list.setredraw(true)
SetPointer(Arrow!)



end event

type st_window from w_standard_print`st_window within wp_pip5010
boolean visible = false
integer x = 2565
integer y = 2844
end type

type sle_msg from w_standard_print`sle_msg within wp_pip5010
boolean visible = false
integer x = 553
integer y = 3008
end type

type dw_datetime from w_standard_print`dw_datetime within wp_pip5010
boolean visible = false
integer x = 3022
integer y = 3008
end type

type st_10 from w_standard_print`st_10 within wp_pip5010
boolean visible = false
integer x = 192
integer y = 3008
end type

type gb_10 from w_standard_print`gb_10 within wp_pip5010
boolean visible = false
integer x = 178
integer y = 2956
end type

type dw_print from w_standard_print`dw_print within wp_pip5010
integer x = 4105
integer y = 212
string dataobject = "dp_pip5010_new"
end type

type dw_ip from w_standard_print`dw_ip within wp_pip5010
boolean visible = false
integer x = 1211
integer y = 2844
integer height = 84
integer taborder = 70
end type

type dw_list from w_standard_print`dw_list within wp_pip5010
integer x = 585
integer y = 300
integer width = 3465
integer height = 2024
string dataobject = "dp_pip5010_new"
boolean border = false
end type

event dw_list::clicked;//override
end event

event dw_list::rowfocuschanged;//override
end event

type dw_4 from datawindow within wp_pip5010
event ue_enter pbm_dwnprocessenter
integer x = 562
integer y = 16
integer width = 3314
integer height = 272
integer taborder = 10
boolean bringtotop = true
string dataobject = "dp_pip5010_10"
boolean border = false
boolean livescroll = true
end type

event ue_enter;send(handle(this), 256, 9, 0)

return 1
end event

event rbuttondown;IF dw_4.GetColumnName() = "empno" THEN 
	setnull(gs_code)
	setnull(gs_codename)
	SetNull(Gs_gubun)
		
	Gs_gubun = is_saupcd	
	open(w_employee_saup_popup)
		
	if isnull(gs_code) or gs_code = '' then return
		
	dw_4.SetITem(1,"empno",gs_code)
	dw_4.SetITem(1,"empname",gs_codename)
END IF		
end event

event itemerror;Return 1
end event

event itemfocuschanged;if dwo.name = 'semu' then
	f_toggle_kor(handle(parent))
end if
end event

event itemchanged;this.AcceptText()

IF this.GetColumnName() = 'saupcd' THEN
	is_saupcd = this.GetText()
	
	IF is_saupcd = '' OR IsNull(is_saupcd) THEN is_saupcd = '%'
END IF

end event

type dw_1 from datawindow within wp_pip5010
boolean visible = false
integer x = 279
integer y = 2692
integer width = 1042
integer height = 100
integer taborder = 30
boolean bringtotop = true
boolean titlebar = true
string title = "원천징수이행상황신고서(부표)"
string dataobject = "dp_pip5010_new1"
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_2 from commandbutton within wp_pip5010
boolean visible = false
integer x = 549
integer y = 2840
integer width = 370
integer height = 92
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "부표출력"
end type

event clicked;OpenWithParm(w_print_options, dw_1)
end event

type rr_1 from roundrectangle within wp_pip5010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 571
integer y = 292
integer width = 3488
integer height = 2044
integer cornerheight = 40
integer cornerwidth = 55
end type

