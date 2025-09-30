$PBExportHeader$w_pdt_02540.srw
$PBExportComments$** 작업지시서(제품별,작업장별,품목별)
forward
global type w_pdt_02540 from w_standard_print
end type
type rb_1 from radiobutton within w_pdt_02540
end type
type rb_2 from radiobutton within w_pdt_02540
end type
type st_1 from statictext within w_pdt_02540
end type
type rr_1 from roundrectangle within w_pdt_02540
end type
type rr_2 from roundrectangle within w_pdt_02540
end type
type rb_3 from radiobutton within w_pdt_02540
end type
type rb_4 from radiobutton within w_pdt_02540
end type
type dw_saupj from datawindow within w_pdt_02540
end type
type st_2 from statictext within w_pdt_02540
end type
type pb_1 from u_pb_cal within w_pdt_02540
end type
type rb_5 from radiobutton within w_pdt_02540
end type
type rb_6 from radiobutton within w_pdt_02540
end type
type mle_msg from multilineedit within w_pdt_02540
end type
type st_3 from statictext within w_pdt_02540
end type
end forward

global type w_pdt_02540 from w_standard_print
integer height = 2540
string title = "작업지시서"
rb_1 rb_1
rb_2 rb_2
st_1 st_1
rr_1 rr_1
rr_2 rr_2
rb_3 rb_3
rb_4 rb_4
dw_saupj dw_saupj
st_2 st_2
pb_1 pb_1
rb_5 rb_5
rb_6 rb_6
mle_msg mle_msg
st_3 st_3
end type
global w_pdt_02540 w_pdt_02540

type variables
str_itnct lstr_sitnct
end variables

forward prototypes
public function integer wf_retrieve1 ()
public function integer wf_retrieve2 ()
public function integer wf_retrieve3 ()
public function integer wf_retrieve4 ()
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve1 ();String  sGubn,sDate1,sDate2,sJakup1,sJakup2,ChkDate,ChkDate2, sgub, spdtgu, ssdat, stdat
dw_saupj.accepttext()
String 	ssaupj, ls_visible, ls_dategub
ssaupj = dw_saupj.getitemstring(1, "saupj")

IF 	dw_ip.AcceptText() = -1 THEN RETURN -1

sDate1  	= TRIM(dw_ip.GetItemString(1,"jidat"))   //지시일자
sDate2  	= TRIM(dw_ip.GetItemString(1,"jidat1"))  //지시일자
spdtgu  	= dw_ip.GetItemString(1,"pdtgu") 
sJakup1 	= dw_ip.GetItemString(1,"itnbr")   //품번
sJakup2 	= dw_ip.GetItemString(1,"itnbr1")  //품번
//ssdat    = dw_ip.GetItemString(1,"esdat")  // 작업 예정일자
//stdat    	= dw_ip.GetItemString(1,"tsdat")   // 작업 종료일자
ls_dategub = dw_ip.GetItemString(1, "dategub")

sgub   	= dw_ip.GetItemString(1,"gubun")  

if	f_datechk(sDate1) = -1 then
	f_message_chk(35,'[지시일자]')
	dw_ip.SetColumn("jidat")
	dw_ip.SetFocus()
	return -1
end if 

if	f_datechk(sDate2) = -1 then
	f_message_chk(35,'[지시일자]')
	dw_ip.SetColumn("jidat1")
	dw_ip.SetFocus()
	return -1
end if 

IF 	sDate1 > sDate2 THEN
  	MessageBox("확인","지시일자범위를 확인하세요")
  	dw_ip.SetColumn("jidat1")
  	dw_ip.SetFocus()
  	return -1
END IF	

if 	sJakup1 = "" or isnull(sJakup1) then	
	SELECT MIN("ITEMAS"."ITNBR")
  	  INTO :sJakup1  
	  FROM "ITEMAS"  ;
END IF

IF 	sJakup2 = ""	or isnull(sJakup2) then	
  	SELECT MAX("ITEMAS"."ITNBR")
  	INTO :sJakup2  
 	FROM "ITEMAS"   ;
END IF

IF	( sJakup1 > sJakup2  )	  then
  	MessageBox("확인","품목코드의 범위를 확인하세요!")
  	dw_ip.setcolumn('itnbr')
  	dw_ip.setfocus()
  	Return -1
END IF

SELECT DATANAME
INTO :ls_visible
FROM SYSCNFG
WHERE SYSGU ='Y'
AND   SERIAL = 15
AND   LINENO = '30';

dw_print.setfilter('') 
if 	spdtgu = ""	or isnull(spdtgu) then	
	if 	ls_dategub = '1'  then    // 작업지시일
  		dw_print.setfilter("momast_jidat  between  '"+ sDate1 +"' and  '" +  sDate2  + "'" ) 
	elseif 	ls_dategub  = '2'    then  // 생산시작일
  		dw_print.setfilter("morout_esdat  between  '"+ sDate1 +"' and  '" +  sDate2  + "'" ) 
	Else                                    // 연동시작일
  		dw_print.setfilter("morout_fsdat  between  '"+ sDate1 +"' and  '" +  sDate2  + "'" ) 
	End if
else	  
	if 	ls_dategub = '1'  then    // 작업지시일
  		dw_print.setfilter("momast_jidat  between  '"+ sDate1 +"' and  '" +  sDate2  + "' and "  + &
		                           "pdtgu = '"+ spdtgu +"'" ) 
	elseif 	ls_dategub  = '2'     then    // 생산시작일
  		dw_print.setfilter("morout_esdat  between  '"+ sDate1 +"' and  '" +  sDate2  + "' and " + & 
		                           "pdtgu = '"+ spdtgu +"'" ) 
	Else                                    // 연동시작일
  		dw_print.setfilter("morout_fsdat  between  '"+ sDate1 +"' and  '" +  sDate2  +  "' and " + & 
		                           "pdtgu = '"+ spdtgu +"'" ) 
	End if
end if

dw_print.filter()

IF 	dw_print.Retrieve(gs_sabu, sJakup1,sJakup2, f_today(), sgub, ssaupj,  ls_visible) < 1 THEN
  	f_message_chk(50,'')
  	return -1
END IF
           
return 1
end function

public function integer wf_retrieve2 ();String  sGubn1,sgubn2,sDate1,sDate2,sJakup1,sJakup2,ChkDate,ChkDate2, spdtgu, sopt, sfilter, ssdat, stdat
String  ls_dategub

dw_saupj.accepttext()

if 	dw_ip.AcceptText() = -1 then return -1

sDate1  	= trim(dw_ip.GetItemString(1,"jidat"))  //검사일자
sDate2  	= trim(dw_ip.GetItemString(1,"jidat1"))  //검사일자
spdtgu  	= trim(dw_ip.GetItemString(1,"pdtgu"))  
sJakup1 	= dw_ip.GetItemString(1,"jakup1")   //작업장
sJakup2 	= dw_ip.GetItemString(1,"jakup2")   //작업장
sGubn1  	= dw_ip.GetItemString(1,"sgub")    //구분(신규,기존)
ls_dategub = dw_ip.GetItemString(1,"dategub")    //1,2,3 작업시작일, 생산시작일, 연동종료일

sopt   		= dw_ip.GetItemString(1,"sopt")

if	f_datechk(sDate1) = -1 then
	f_message_chk(35,'[지시일자]')
	dw_ip.SetColumn("jidat")
	dw_ip.SetFocus()
	return -1
end if 

if	f_datechk(sDate2) = -1 then
	f_message_chk(35,'[지시일자]')
	dw_ip.SetColumn("jidat1")
	dw_ip.SetFocus()
	return -1
end if 

IF 	sDate1 > sDate2 THEN
  	MessageBox("확인","지시일자범위를 확인하세요")
  	dw_ip.SetColumn("jidat1")
  	dw_ip.SetFocus()
  	return -1
END IF	

IF 	sJakup1 = "" or isnull(sJakup1) then	
   	SELECT MIN("WRKCTR"."WKCTR")
	  	INTO :sJakup1   
	  	FROM "WRKCTR"  ;
END IF

IF 	sJakup2   = ""	or isnull(sJakup2) then	
   	SELECT MAX("WRKCTR"."WKCTR")
	  	INTO :sJakup2  
	  	FROM "WRKCTR"  ;
END IF

IF	( sJakup1 > sJakup2  )	  then
	MessageBox("확인","작업장코드의 범위를 확인하세요!")
	dw_ip.setcolumn('jakup1')
	dw_ip.setfocus()
	Return -1
END IF  
  

dw_print.setfilter('') 
sfilter  = ""
if 	spdtgu = ""	or isnull(spdtgu) then	
	if 	ls_dategub = '1'  then    // 작업지시일
		sfilter = "( momast_jidat  between  '"+ sDate1 +"' and  '" +  sDate2  +"' ) " 
	elseif 	ls_dategub  = '2'    then  // 생산시작일
		sfilter = "( morout_esdat  between  '"+ sDate1 +"' and  '" +  sDate2 + "' ) "
	Else                                    // 연동시작일
		sfilter = "( morout_fsdat  between  '"+ sDate1 +"' and  '" +  sDate2   + "' ) "
	End if
	if 	sopt = 'Y' then 
		sfilter = sfilter + "( and momast_gisisu <> silqty ) "
	end if
else	  
	if 	ls_dategub = '1'  then    // 작업지시일
  		sfilter 	= " ( momast_jidat  between  '"+ sDate1 +"' and  '" +  sDate2  + "' and "  + &
		                           "pdtgu = '"+ spdtgu  + "' ) "
	elseif 	ls_dategub  = '2'     then    // 생산시작일
		sfilter 	= "( morout_esdat  between  '"+ sDate1 +"' and  '" +  sDate2  + "' and " + & 
		                           "pdtgu = '"+ spdtgu  + "' ) "
	Else                                    // 연동시작일
		sfilter	= "( morout_fsdat  between  '"+ sDate1 +"' and  '" +  sDate2  +  "' and " + & 
		                           "pdtgu = '"+ spdtgu  + "' ) "
	End if
	if 	sopt = 'Y' then 
		sfilter = sfilter + "and momast_gisisu <> silqty"
	end if
end if

dw_print.setfilter(sfilter)  
dw_print.filter()

String ssaupj
ssaupj = dw_saupj.getitemstring(1, "saupj")

IF 	dw_print.Retrieve(gs_sabu,sJakup1,sJakup2,sGubn1,ssaupj) < 1 THEN
   	f_message_chk(50,'')
   	return -1
END IF
dw_print.object.t_sdate1.text = left(sDate1,4) + '.' + mid(sDate1,5,2) + '.' + mid(sDate1,7,2) 
dw_print.object.t_sdate2.text = left(sDate2,4) + '.' + mid(sDate2,5,2) + '.' + mid(sDate2,7,2) 

CHOOSE  Case ls_dategub
	Case '1'
		dw_print.object.t_date.text = '(작업지시일:'
	Case '2'
		dw_print.object.t_date.text = '(생산시작일:'
	Case '3'
		dw_print.object.t_date.text = '(연동시작일:'
End Choose		


return 1
end function

public function integer wf_retrieve3 ();String  sGubn1,sgubn2,sDate1,sDate2,ChkDate,ChkDate2, spdtgu, sitnbr1, sitnbr2, ssdat, stdat
dw_saupj.accepttext()
String ls_dategub

if 	dw_ip.AcceptText() = -1 then return -1

sDate1  	= dw_ip.GetItemString(1,"jidat")  //작업지시일자
sDate2  	= dw_ip.GetItemString(1,"jidat1")  //작업지시일자
spdtgu  	= dw_ip.GetItemString(1,"pdtgu") 
sGubn1   = dw_ip.GetItemString(1,"gubun")   //구분(신규,기존)->작업지시의 생산지시상태
sitnbr1  	= dw_ip.GetItemString(1,"itnbr")  //시작품번
sitnbr2  	= dw_ip.GetItemString(1,"itnbr1")  //종료품번
ls_dategub	= dw_ip.GetItemString(1,"dategub")  //1,2,3 작업지시일, 생산시작일, 연동시작일
 
if	f_datechk(sDate1) = -1 then
	f_message_chk(35,'[지시일자]')
	dw_ip.SetColumn("jidat")
	dw_ip.SetFocus()
	return -1
end if 

if	f_datechk(sDate2) = -1 then
	f_message_chk(35,'[지시일자]')
	dw_ip.SetColumn("jidat1")
	dw_ip.SetFocus()
	return -1
end if 

IF 	sDate1 > sDate2 THEN
  	MessageBox("확인","지시일자범위를 확인하세요")
  	dw_ip.SetColumn("jidat1")
  	dw_ip.SetFocus()
  	return -1
END IF	

dw_print.setfilter('') 

if 	spdtgu = ""	or isnull(spdtgu) then	
	if 	ls_dategub = '1'  then    // 작업지시일
  		dw_print.setfilter("momast_jidat  between  '"+ sDate1 +"' and  '" +  sDate2  + "'" ) 
	elseif 	ls_dategub  = '2'    then  // 생산시작일
  		dw_print.setfilter("morout_esdat  between  '"+ sDate1 +"' and  '" +  sDate2  + "'" ) 
	Else                                    // 연동시작일
  		dw_print.setfilter("morout_fsdat  between  '"+ sDate1 +"' and  '" +  sDate2  + "'" ) 
	End if
else	  
	if 	ls_dategub = '1'  then    // 작업지시일
  		dw_print.setfilter("momast_jidat  between  '"+ sDate1 +"' and  '" +  sDate2  + "' and "  + &
		                           "pdtgu = '"+ spdtgu +"'" ) 
	elseif 	ls_dategub  = '2'     then    // 생산시작일
  		dw_print.setfilter("morout_esdat  between  '"+ sDate1 +"' and  '" +  sDate2  + "' and " + & 
		                           "pdtgu = '"+ spdtgu +"'" ) 
	Else                                    // 연동시작일
  		dw_print.setfilter("morout_fsdat  between  '"+ sDate1 +"' and  '" +  sDate2  +  "' and " + & 
		                           "pdtgu = '"+ spdtgu +"'" ) 
	End if
end if

dw_print.filter()

if 	isnull(sitnbr1) or trim(sitnbr1) = '' then sitnbr1 = '.'
if 	isnull(sitnbr2) or trim(sitnbr2) = '' then sitnbr2 = 'ZZZZZZZZZZZZZZz'

String ssaupj
ssaupj = dw_saupj.getitemstring(1, "saupj")

IF 	dw_print.Retrieve(gs_sabu,sgubn1, sitnbr1, sitnbr2, ssaupj) < 1 THEN
  	f_message_chk(50,'')
  	return -1
END IF

CHOOSE  Case ls_dategub
	Case '1'
		dw_print.object.t_date.text = '작업지시일'
	Case '2'
		dw_print.object.t_date.text = '생산시작일'
	Case '3'
		dw_print.object.t_date.text = '연동시작일'
End Choose		

dw_print.object.t_sdate1.text = left(sDate1,4) + '.' + mid(sDate1,5,2) + '.' + mid(sDate1,7,2) 
dw_print.object.t_sdate2.text = left(sDate2,4) + '.' + mid(sDate2,5,2) + '.' + mid(sDate2,7,2) 


return 1
end function

public function integer wf_retrieve4 ();String pordno, sgub, ssugub, sDate1, sDate2, sPdtgu, ePdtgu, sittyp, sfitcls, stitcls, sempno, ssdat, ls_visible
dw_saupj.accepttext()
String ls_dategub

if 	dw_ip.AcceptText() = -1 then return -1

pordno    	= trim(dw_ip.GetItemString(1,"pordno"))
sgub      	= dw_ip.GetItemString(1,"gub")

sDate1    	= trim(dw_ip.GetItemString(1,"jidat"))
sDate2    	= trim(dw_ip.GetItemString(1,"jidat1"))
sPdtgu    	= trim(dw_ip.GetItemString(1,"spdtgu"))
ePdtgu    	= trim(dw_ip.GetItemString(1,"epdtgu"))

sittyp    	= trim(dw_ip.getitemstring(1, 'ittyp')) 
sfitcls   	= trim(dw_ip.getitemstring(1, 'fitcls')) 
stitcls   	= trim(dw_ip.getitemstring(1, 'titcls')) 
sempno   = trim(dw_ip.getitemstring(1, 'empno')) 
ls_dategub = trim(dw_ip.getitemstring(1, 'dategub')) 

IF 	sDate1 = '' OR ISNULL(sDate1) THEN  sDate1 = '10000101'
IF 	sDate2 = '' OR ISNULL(sDate2) THEN  sDate2 = '99991231'

if	f_datechk(sDate1) = -1 then
	f_message_chk(35,'[지시일자]')
	dw_ip.SetColumn("jidat")
	dw_ip.SetFocus()
	return -1
end if 

if	f_datechk(sDate2) = -1 then
	f_message_chk(35,'[지시일자]')
	dw_ip.SetColumn("jidat1")
	dw_ip.SetFocus()
	return -1
end if 

IF 	sDate1 > sDate2 THEN
  	MessageBox("확인","지시일자범위를 확인하세요")
  	dw_ip.SetColumn("jidat1")
  	dw_ip.SetFocus()
  	return -1
END IF	


IF 	sPdtgu = '' OR ISNULL(sPdtgu) THEN  sPdtgu = '.'
IF 	ePdtgu = '' OR ISNULL(ePdtgu) THEN  ePdtgu = 'zzzzzz'
IF 	pordno = '' OR ISNULL(pordno) THEN  pordno = '%'

if 	sfitcls = '' or isnull(sfitcls) then sfitcls = '.'
if 	stitcls = '' or isnull(stitcls) then 
	stitcls = 'zzzzzzz'
else
	stitcls = stitcls + 'zzzzzz'
end if

if 	sempno = '' or isnull(sempno) then sempno = '%'
if 	sittyp = '' or isnull(sittyp) then sittyp = '%'

if 	ssdat = '' or isnull(ssdat) then ssdat = '%'

String ssaupj
ssaupj = dw_saupj.getitemstring(1, "saupj")

SELECT DATANAME
INTO :ls_visible
FROM SYSCNFG
WHERE SYSGU ='Y'
AND   SERIAL = 15
AND   LINENO = '30';


IF 	dw_print.Retrieve(gs_sabu,  pordno, sPdtgu, ePdtgu, sgub, sittyp, sfitcls, stitcls, sempno, ssaupj,  ls_visible) < 1 THEN
	f_message_chk(50,'')
	dw_ip.setfocus()
	return -1
END IF	

dw_print.setfilter('') 

	if 	ls_dategub = '1'  then    // 작업지시일
  		dw_print.setfilter("momast_jidat  between  '"+ sDate1 +"' and  '" +  sDate2  + "'" ) 
	elseif 	ls_dategub  = '2'    then  // 생산시작일
  		dw_print.setfilter("momast_esdat  between  '"+ sDate1 +"' and  '" +  sDate2  + "'" ) 
	Else                                    // 연동시작일
  		dw_print.setfilter("momast_fsdat  between  '"+ sDate1 +"' and  '" +  sDate2  + "'" ) 
	End if

dw_print.filter()

Long Lrow
For Lrow = 1 to dw_print.rowcount()
	 dw_print.setitem(Lrow, "momast_print_print_yn", 'Y')	
Next
dw_print.update()
commit;

//dw_LIST.Retrieve(gs_sabu, sDate, eDate, pordno, sPdtgu, ePdtgu, sgub, sittyp, sfitcls, stitcls, sempno, ssaupj, ssdat)

dw_print.ShareData (dw_list)

Return 1
end function

public function integer wf_retrieve ();//  원본
//if 	rb_1.checked then     				// = 품 목 별 =
//	IF 	wf_retrieve1() = -1 THEN
//		return -1
//	END IF
//	dw_print.sharedata(dw_list)	
//elseif rb_2.checked then				// = 작 업 장 =
//	IF 	wf_retrieve2() = -1 THEN
//		return -1
//	END IF
//	dw_print.sharedata(dw_list)	
//elseif rb_3.checked then				// = 상 세 =
//	IF 	wf_retrieve3() = -1 THEN
//		return -1
//	END IF
//	dw_print.sharedata(dw_list)	
//elseif rb_4.checked then				// = 제조전표 =
//	IF 	wf_retrieve4() = -1 THEN
//		return -1
//	END IF	
//END IF
// 
//return 1
//  원본 여기까지


String  sDate,spdtgu, sitnbr1, sitnbr2, sSaupj, sPlandat
String ls_dategub

if 	dw_ip.AcceptText() = -1 then return -1

sDate  	= dw_ip.GetItemString(1,"jidat")  //작업지시일자
spdtgu  	= dw_ip.GetItemString(1,"pdtgu") 
sitnbr1 	= dw_ip.GetItemString(1,"itnbr")  //시작품번
sitnbr2 	= dw_ip.GetItemString(1,"itnbr1")  //종료품번
ssaupj  	= dw_ip.GetItemString(1,"saupj")
 
if	f_datechk(sDate) = -1 then
	f_message_chk(35,'[지시일자]')
	dw_ip.SetColumn("jidat")
	dw_ip.SetFocus()
	return -1
end if 

if isnull(sitnbr1) or trim(sitnbr1) = '' then sitnbr1 = '.'
if isnull(sitnbr2) or trim(sitnbr2) = '' then sitnbr2 = 'ZZZZZZZZZZZZZZz'

SELECT MIN(CLDATE) into :sPlandat FROM P4_CALENDAR WHERE CLDATE > :sdate AND WORKGUB IN ( '1','2');

IF dw_print.Retrieve(gs_sabu, sDate, sPlandat, ssaupj) < 1 THEN
  	f_message_chk(50,'')
  	return -1
END IF

dw_print.sharedata(dw_list)	

If dw_list.DataObject = 'dw_pdt_02540_ds' Then	
	
	dw_print.SetSort('jomast_jocod, max_wkctr, a_gub, a_inwon_nm, moseq, a_wkctr')
	dw_print.Sort()
	dw_print.GroupCalc()
	dw_print.object.t_sdate.text = left(sDate,4) + '.' + mid(sDate,5,2) + '.' + mid(sDate,7,2) 
	dw_print.object.t_plandat.text = left(sPlandat,4) + '.' + mid(sPlandat,5,2) + '.' + mid(sPlandat,7,2) 
	dw_list.object.t_plandat.text = left(sPlandat,4) + '.' + mid(sPlandat,5,2) + '.' + mid(sPlandat,7,2) 
Else	
	// LOT번호 채번
	String smon, slots
	
	select chr(64 + to_number(substr(:sDate,5,2))) into :sMon from dual;
	sLots  = Mid(sDate,4,1) + sMon + Mid(sDate,7,2)
	
	dw_print.Object.tx_msg.text = mle_msg.text
	dw_print.Object.tx_lot.text = sLots
End If

return 1
end function

on w_pdt_02540.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.st_1=create st_1
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rb_3=create rb_3
this.rb_4=create rb_4
this.dw_saupj=create dw_saupj
this.st_2=create st_2
this.pb_1=create pb_1
this.rb_5=create rb_5
this.rb_6=create rb_6
this.mle_msg=create mle_msg
this.st_3=create st_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.rr_1
this.Control[iCurrent+5]=this.rr_2
this.Control[iCurrent+6]=this.rb_3
this.Control[iCurrent+7]=this.rb_4
this.Control[iCurrent+8]=this.dw_saupj
this.Control[iCurrent+9]=this.st_2
this.Control[iCurrent+10]=this.pb_1
this.Control[iCurrent+11]=this.rb_5
this.Control[iCurrent+12]=this.rb_6
this.Control[iCurrent+13]=this.mle_msg
this.Control[iCurrent+14]=this.st_3
end on

on w_pdt_02540.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.st_1)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rb_3)
destroy(this.rb_4)
destroy(this.dw_saupj)
destroy(this.st_2)
destroy(this.pb_1)
destroy(this.rb_5)
destroy(this.rb_6)
destroy(this.mle_msg)
destroy(this.st_3)
end on

event open;call super::open;dw_saupj.settransobject(sqlca)
dw_ip.SetTransObject(SQLCA)
dw_saupj.insertrow(0)

/* User별 사업장 Setting */
setnull(gs_code)
//If 	f_check_saupj() = 1 Then
//	dw_saupj.SetItem(1, 'saupj', gs_code)
//	if 	gs_code <> '%' then
//		dw_saupj.setItem(1, 'saupj', gs_code)
//        	dw_saupj.Modify("saupj.protect=1")
//		dw_saupj.Modify("saupj.background.color = 80859087")
//	End if
//End If
//f_mod_saupj(dw_saupj, 'saupj')

dw_ip.SetItem(1,"jidat",F_today())

//rb_1.triggerevent(Clicked!)


end event

type p_xls from w_standard_print`p_xls within w_pdt_02540
end type

type p_sort from w_standard_print`p_sort within w_pdt_02540
end type

type p_preview from w_standard_print`p_preview within w_pdt_02540
end type

type p_exit from w_standard_print`p_exit within w_pdt_02540
end type

type p_print from w_standard_print`p_print within w_pdt_02540
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_02540
end type







type st_10 from w_standard_print`st_10 within w_pdt_02540
end type

type gb_10 from w_standard_print`gb_10 within w_pdt_02540
boolean visible = false
integer x = 155
integer y = 2764
integer height = 152
integer textsize = -12
fontcharset fontcharset = defaultcharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
end type

type dw_print from w_standard_print`dw_print within w_pdt_02540
integer x = 4471
integer y = 220
string dataobject = "dw_pdt_02540_ds_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_02540
integer x = 55
integer y = 64
integer width = 1646
string dataobject = "d_pdt_02540_ret_ds"
end type

event dw_ip::rbuttondown;string sName

setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)

Choose  Case	this.GetColumnName()
	Case	"itnbr" 
		Open(w_itemas_popup3)
		
		IF 	gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		this.SetItem(dw_ip.GetRow(),"itnbr",gs_code)
		Return
	Case	"itnbr1" 
		Open(w_itemas_popup3)
		
		IF 	gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		this.SetItem(dw_ip.GetRow(),"itnbr1",gs_code)
		Return
	Case 	"jakup1"
		gs_code = this.GetText()
		open(w_workplace_popup)
		
		if 	isnull(gs_code) or gs_code = "" then return
		
		this.SetItem(1, "jakup1", 	 gs_Code)
		this.setitem(1, 'sjakname1',  gs_codename)
	Case 	"jakup2"	
		gs_code = this.GetText()
		open(w_workplace_popup)
		
		if 	isnull(gs_code) or gs_code = "" then return
		
		this.SetItem(1, "jakup2", 	 gs_Code)
		this.setitem(1, 'sjakname2',  gs_codename)
	Case 	"pordno"	// 지시번호 
		gs_gubun = '30' 
		open(w_jisi_popup)
		if 	isnull(gs_code) or gs_code = "" then return
		this.SetItem(1, "pordno", gs_Code)
		return 
	Case 	"fitcls"	// 품목분류 from.
		sname = this.GetItemString(1, 'ittyp')
		OpenWithParm(w_ittyp_popup, sname)
		
		lstr_sitnct = Message.PowerObjectParm	
		if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
		
		this.SetItem(1,"ittyp",lstr_sitnct.s_ittyp)
		this.SetItem(1,"fitcls", lstr_sitnct.s_sumgub)
		
		this.SetColumn('fitcls')
		this.SetFocus()
		RETURN 1
	Case 	"titcls"	// 품목분류 to.
		sname = this.GetItemString(1, 'ittyp')
		OpenWithParm(w_ittyp_popup, sname)
		
		lstr_sitnct = Message.PowerObjectParm	
		if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 

		this.SetItem(1,"ittyp",lstr_sitnct.s_ittyp)
		this.SetItem(1,"titcls", lstr_sitnct.s_sumgub)

		this.SetColumn('titcls')
		this.SetFocus()
		RETURN 1
		
END Choose
end event

event dw_ip::itemchanged;string swkctr, swknm, swknm2 , ls_date, sCode, sName, sOther, smatchk, spdsts
int    ireturn 

Choose  Case	this.GetColumnName()
	Case	"itnbr" 
		sCode = this.GetText()
		ireturn = f_get_name2('품번', 'Y', sCode, sName, sOther)    //1이면 실패, 0이 성공	
		
		this.SetItem(dw_ip.GetRow(),"itnbr",sCode)
		Return ireturn
	Case	"itnbr1" 
		sCode = this.GetText()
		ireturn = f_get_name2('품번', 'Y', sCode, sName, sOther)    //1이면 실패, 0이 성공	
		
		this.SetItem(dw_ip.GetRow(),"itnbr1",sCode)
		Return ireturn
	Case 	"jakup1"
		sCode = trim(this.gettext())
		ireturn = f_get_name2('작업장', 'N', sCode, swknm, swknm2)
		this.setitem(1, 'jakup1', sCode)
		this.setitem(1, 'sjakname1',  swknm)
		return ireturn
	Case 	"jakup2"	
		sCode = trim(this.gettext())
		ireturn = f_get_name2('작업장', 'N', sCode, swknm, swknm2)
		this.setitem(1, 'jakup2', sCode)
		this.setitem(1, 'sjakname2',  swknm)
		return ireturn
	Case 	"pordno"	// 지시번호 
		sCode = gettext()
		
		Select matchk, pdsts into :smatchk, :spdsts From momast 
		 where sabu = :gs_sabu And pordno = :scode;
		 
		if sqlca.sqlcode <> 0 then
			f_message_chk(33, '작업지시')
			setitem(1, "pordno", '')
			return 1
		Elseif smatchk = '1' then
			f_message_chk(175, '작업지시')
			setitem(1, "pordno", '')
			return 1						
		Elseif spdsts > '2' then
			f_message_chk(75, '작업지시')
			setitem(1, "pordno", '')
			return 1				
		End if	
	Case 	"fitcls"	// 품목분류 from.
		sname = this.GetItemString(1, 'ittyp')
		OpenWithParm(w_ittyp_popup, sname)
		
		lstr_sitnct = Message.PowerObjectParm	
		if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
		
		this.SetItem(1,"ittyp",lstr_sitnct.s_ittyp)
		this.SetItem(1,"fitcls", lstr_sitnct.s_sumgub)
		
		this.SetColumn('fitcls')
		this.SetFocus()
	Case 	"titcls"	// 품목분류 to.
		sname = this.GetItemString(1, 'ittyp')
		OpenWithParm(w_ittyp_popup, sname)
		
		lstr_sitnct = Message.PowerObjectParm	
		if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 

		this.SetItem(1,"ittyp",lstr_sitnct.s_ittyp)
		this.SetItem(1,"titcls", lstr_sitnct.s_sumgub)

		this.SetColumn('titcls')
		this.SetFocus()
	Case 	"jidat" , "jidat1"                  	//.
		  ls_date = this.gettext()
		  if 		f_datechk(ls_date) = -1 then
				f_message_chk(35,'[지시일자]')
				return 1
		  end if 
	Case "prgbn"
		  ls_date = this.gettext()
		  if ls_date = '2' then
			  dw_list.dataobject 	= "dw_pdt_02545_02_two"
			  dw_print.dataobject 	= "dw_pdt_02545_02_two"	
		  Else
			  dw_list.dataobject 	= "dw_pdt_02545_02"
			  dw_print.dataobject 	= "dw_pdt_02545_02"
		  End if
		  dw_list.settransobject(sqlca)
		  dw_print.settransobject(sqlca)		  
END Choose

RETURN 

end event

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_pdt_02540
integer y = 384
integer width = 4567
integer height = 1944
string dataobject = "dw_pdt_02540_ds"
boolean controlmenu = true
end type

type rb_1 from radiobutton within w_pdt_02540
boolean visible = false
integer x = 3058
integer y = 72
integer width = 325
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "품목별"
end type

event clicked;dw_ip.dataobject 		= "d_pdt_02540_ret"
dw_ip.settransobject(sqlca)
dw_ip.insertrow(0)
dw_ip.SetItem(1,"jidat",left(F_today(),6)+ '01')
dw_ip.SetItem(1,"jidat1",F_today())

dw_list.dataobject 		= "dw_pdt_02540"
dw_list.settransobject(sqlca)

dw_print.dataobject 		= "dw_pdt_02540_p"
dw_print.settransobject(sqlca)

if p_print.Enabled = true then
	p_print.Enabled 			=False
	p_print.PictureName 	= 'C:\erpman\image\인쇄_d.gif'
End If
end event

type rb_2 from radiobutton within w_pdt_02540
boolean visible = false
integer x = 3058
integer y = 144
integer width = 325
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "작업장"
end type

event clicked;dw_ip.dataobject 	= "d_pdt_02550ret"
dw_list.dataobject 	= "dw_pdt_02550"
dw_print.dataobject 	= "dw_pdt_02550_p"
dw_ip.settransobject(sqlca)
dw_list.settransobject(sqlca)
dw_print.settransobject(sqlca)
dw_ip.insertrow(0)
dw_ip.SetItem(1,"jidat",left(F_today(),6)+'01')
dw_ip.SetItem(1,"jidat1",F_today())

if 	p_print.Enabled = true then
	p_print.Enabled 			=False
	p_print.PictureName 	= 'C:\erpman\image\인쇄_d.gif'
End If

end event

type st_1 from statictext within w_pdt_02540
integer x = 969
integer y = 128
integer width = 256
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
boolean enabled = false
string text = "출력구분"
alignment alignment = right!
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_pdt_02540
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 23
integer y = 48
integer width = 1714
integer height = 296
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pdt_02540
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 23
integer y = 372
integer width = 4603
integer height = 1972
integer cornerheight = 40
integer cornerwidth = 55
end type

type rb_3 from radiobutton within w_pdt_02540
boolean visible = false
integer x = 3383
integer y = 72
integer width = 370
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "상세"
end type

event clicked;dw_ip.dataobject 		= "d_pdt_02560ret"
dw_list.dataobject 		= "dw_pdt_02560"
dw_print.dataobject 		= "dw_pdt_02560"
dw_ip.settransobject(sqlca)
dw_list.settransobject(sqlca)
dw_print.settransobject(sqlca)
dw_ip.insertrow(0)
dw_ip.SetItem(1,"jidat",left(F_today(),6)+'01')
dw_ip.SetItem(1,"jidat1",F_today())

//dw_ip.object.print_t.visible 	= true
//dw_ip.object.sopt.visible 	= true
p_print.Enabled 				= False
p_print.PictureName 		= 'C:\erpman\image\인쇄_d.gif'


end event

type rb_4 from radiobutton within w_pdt_02540
boolean visible = false
integer x = 3383
integer y = 144
integer width = 485
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "제조전표"
end type

event clicked;String ls_cvcod, ls2_saupj, ls_saupj

dw_ip.dataobject 	= "d_pdt_02545_01"


dw_list.dataobject 	= "dw_pdt_02545_02"
dw_print.dataobject 	= "dw_pdt_02545_02"

dw_ip.settransobject(sqlca)
dw_list.settransobject(sqlca)
dw_print.settransobject(sqlca)
dw_ip.insertrow(0)
dw_ip.SetItem(1,"jidat",left(F_today(),6)+'01')
dw_ip.SetItem(1,"jidat1",F_today())
//dw_ip.SetItem(1,"esdat", F_today())

f_child_saupj(dw_ip, 'empno', gs_saupj)

if 	p_print.Enabled = true then
	p_print.Enabled 			=False
	p_print.PictureName 	= 'C:\erpman\image\인쇄_d.gif'
End If


end event

type dw_saupj from datawindow within w_pdt_02540
boolean visible = false
integer x = 3008
integer y = 244
integer width = 686
integer height = 84
integer taborder = 70
boolean bringtotop = true
string title = "none"
string dataobject = "D_PDT_02030_44"
boolean border = false
boolean livescroll = true
end type

event itemchanged;if rb_4.checked then
	f_child_saupj(dw_ip, 'empno', gettext())
end if
end event

type st_2 from statictext within w_pdt_02540
boolean visible = false
integer x = 2761
integer y = 256
integer width = 256
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
boolean enabled = false
string text = "사업장"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_1 from u_pb_cal within w_pdt_02540
integer x = 773
integer y = 112
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('jidat')
IF IsNull(gs_code) THEN Return
If dw_ip.Object.jidat.protect = '1' Or dw_ip.Object.jidat.TabSequence = '0' Then Return

dw_ip.SetItem(1, 'jidat', gs_code)
end event

type rb_5 from radiobutton within w_pdt_02540
integer x = 1285
integer y = 120
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "생산계획서"
boolean checked = true
end type

event clicked;dw_list.dataobject 		= "dw_pdt_02540_ds"
dw_list.settransobject(sqlca)

dw_print.dataobject 		= "dw_pdt_02540_ds_p"
dw_print.settransobject(sqlca)

if p_print.Enabled = true then
	p_print.Enabled 			=False
	p_print.PictureName 	= 'C:\erpman\image\인쇄_d.gif'
End If
end event

type rb_6 from radiobutton within w_pdt_02540
integer x = 1285
integer y = 208
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "작업일보"
end type

event clicked;dw_list.dataobject 		= "d_pdt_02540_2_p"
dw_list.settransobject(sqlca)

dw_print.dataobject 		= "d_pdt_02540_2_p"
dw_print.settransobject(sqlca)

if p_print.Enabled = true then
	p_print.Enabled 			=False
	p_print.PictureName 	= 'C:\erpman\image\인쇄_d.gif'
End If
end event

type mle_msg from multilineedit within w_pdt_02540
integer x = 1769
integer y = 128
integer width = 1385
integer height = 216
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_pdt_02540
integer x = 1765
integer y = 52
integer width = 777
integer height = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "* 반장 작업 전달사항"
boolean focusrectangle = false
end type

