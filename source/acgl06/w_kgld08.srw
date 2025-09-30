$PBExportHeader$w_kgld08.srw
$PBExportComments$거래처별 채권채무 조회 출력
forward
global type w_kgld08 from w_standard_print
end type
type tab_list from tab within w_kgld08
end type
type tabpage_list from userobject within tab_list
end type
type dw_mst_print from datawindow within tabpage_list
end type
type tabpage_list from userobject within tab_list
dw_mst_print dw_mst_print
end type
type tabpage_list2 from userobject within tab_list
end type
type dw_mst_print2 from datawindow within tabpage_list2
end type
type tabpage_list2 from userobject within tab_list
dw_mst_print2 dw_mst_print2
end type
type tab_list from tab within w_kgld08
tabpage_list tabpage_list
tabpage_list2 tabpage_list2
end type
type rb_1 from radiobutton within w_kgld08
end type
type rb_2 from radiobutton within w_kgld08
end type
type gb_1 from groupbox within w_kgld08
end type
end forward

global type w_kgld08 from w_standard_print
integer x = 0
integer y = 0
integer width = 4681
string title = "거래처별 채권채무 조회 출력"
tab_list tab_list
rb_1 rb_1
rb_2 rb_2
gb_1 gb_1
end type
global w_kgld08 w_kgld08

type variables
String     LsCustFlag = 'N',  &         
              LsTotalTag ='Y'   /*인명처리여부,전체조회여부*/
DataWindow  Idw_mst_print
end variables

forward prototypes
public function integer wf_retrieve ()
public function integer wf_preview (integer irow)
public function integer wf_print ()
end prototypes

public function integer wf_retrieve ();
String sSaupj,sAcc_Ym,sRef_SaupjName,Incd_f,Incd_T,sRcode,sCode1,sCode2,sCode3,sCode4,sCode5,&
		 sCode6,sCode7,sCode8,eCode1,eCode2,eCode3,eCode4,eCode5,eCode6,eCode7,eCode8
String sFromYm ,sToYm 

dw_ip.AcceptText()
sSaupj = dw_ip.GetItemString(1,"saupj")
IF IsNull(sSaupj) OR sSaupj = '' THEN
	F_MessageChk(1,'[사업장]')
	dw_ip.SetColumn("saupj")
	dw_ip.SetFocus()
	Return -1
END IF

sacc_ym = Trim(dw_ip.GetItemString(1,"acc_ym")) 
IF f_datechk(sacc_ym + '01') = -1 THEN
	f_messagechk(23, "") 
	dw_ip.SetColumn("acc_ym")
	dw_ip.SetFocus()
	Return -1
END IF

SELECT "REFFPF"."RFNA1"      INTO :sRef_SaupjName
    FROM "REFFPF"  
	WHERE "REFFPF"."RFCOD" = 'AD' AND "REFFPF"."RFGUB" = :sSaupj ;
//tab_list.tabpage_list.dw_mst_print.modify("saup.text ='"+sRef_SaupjName+"'") 
dw_print.modify("saup.text ='"+sRef_SaupjName+"'") 

incd_f = Trim(dw_ip.GetItemString(1,"fr_incd"))
incd_t = Trim(dw_ip.GetItemString(1,"to_incd"))
IF incd_f ="" OR IsNull(incd_f)  THEN	
   incd_f = '0'
END IF
IF incd_t ="" OR IsNull(incd_t)  THEN	
   incd_t = 'zzzzzzzzzzzzzzzzzzzzz'
END IF

setpointer(hourglass!)

SELECT "SYSCNFG"."DATANAME"  										/*채권계정*/
	INTO :srcode
   FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND  ( "SYSCNFG"."SERIAL" = 1 ) AND  
     		( "SYSCNFG"."LINENO" = '9' )   ;
scode1 = mid( srcode, 1, 7)
scode2 = mid( srcode, 8, 7)
scode3 = mid( srcode, 15, 7)
scode4 = mid( srcode, 22, 7)
scode5 = mid( srcode, 29, 7)
scode6 = mid( srcode, 36, 7)
scode7 = mid( srcode, 43, 7)
scode8 = mid( srcode, 50, 7)

SELECT "SYSCNFG"."DATANAME"  										/*채무 계정*/
	INTO :srcode
   FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND  ( "SYSCNFG"."SERIAL" = 1 ) AND  
     		( "SYSCNFG"."LINENO" = '10' )   ;
ecode1 = mid( srcode, 1, 7)
ecode2 = mid( srcode, 8, 7)
ecode3 = mid( srcode, 15, 7)
ecode4 = mid( srcode, 22, 7)
ecode5 = mid( srcode, 29, 7)
ecode6 = mid( srcode, 36, 7)
ecode7 = mid( srcode, 43, 7)
ecode8 = mid( srcode, 50, 7)

tab_list.tabpage_list.dw_mst_print.setredraw(false)
if dw_print.retrieve(sSaupj, incd_f, incd_t,	Left(sAcc_Ym,4), Right(sAcc_Ym,2),&
														 scode1, scode2, scode3, scode4, &
														 scode5, scode6, scode7, scode8, &
														 ecode1, ecode2, ecode3, ecode4, &
														 ecode5, ecode6, ecode7, ecode8) <= 0 then
	F_MessageChk(14,'')
	tab_list.tabpage_list.dw_mst_print.setredraw(true)
	dw_ip.SetFocus()
	setpointer(arrow!)
	return -1	
end if
	    
if rb_1.Checked =True then
  rb_1.TriggerEvent(Clicked!)
elseif rb_2.checked = true then
  rb_2.triggerevent(clicked!)
end if
 dw_print.sharedata(tab_list.tabpage_list.dw_mst_print)

Return 1
end function

public function integer wf_preview (integer irow);String  sSaupj,sAcc_Ym,InCd_F,InCd_T,sRCode,sCode1,sCode2,sCode3,sCode4,sCode5,sCode6,sCode7,sCode8,&
		  eCode1,eCode2,eCode3,eCode4,eCode5,eCode6,eCode7,eCode8,&
		  sSysNm,sCustCd,sCustNm,sPrintGbn,sTel
Double  dInsAmt1,dInsAmt2,dInsAmt3,dInsAmt4,dOutAmt1,dOutAmt2,dOutAmt3,dOutAmt4,dInsTot,dOutTot
Integer lRow

tab_list.tabpage_list2.dw_mst_print2.Reset()

dw_ip.AcceptText()
sSaupj    = Trim(dw_ip.GetItemString(1,"saupj"))
sacc_ym   = Trim(dw_ip.GetItemString(1,"acc_ym"))
sPrintGbn = Trim(dw_ip.GetItemString(1,"printgbn"))

IF sAcc_Ym = "" OR IsNull(sAcc_Ym) THEN Return -1

tab_list.tabpage_list2.dw_mst_print2.modify("end_ymd.text = '"+String(f_last_date(sacc_ym),'@@@@.@@.@@')+"'")

IF sPrintGbn = 'N' THEN									/*채권채무조회서-개별*/
	incd_f = tab_list.tabpage_list.dw_mst_print.GetItemString(irow,"p_cd")
	incd_t = tab_list.tabpage_list.dw_mst_print.GetItemString(irow,"p_cd")
ELSE
	incd_f = dw_ip.GetItemSTring(1,"fr_incd")
	incd_t = dw_ip.GetItemSTring(1,"to_incd")
	IF incd_f = "" OR IsNull(incd_f) THEN incd_f = '0'
	IF incd_t = "" OR IsNull(incd_t) THEN incd_t = 'zzzzzzzzzzzzzzzzzzzz'	
END IF

setpointer(hourglass!)

SELECT "SYSCNFG"."DATANAME"  										/*채권 계정*/
	INTO :srcode
   FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND  ( "SYSCNFG"."SERIAL" = 1 ) AND  
     		( "SYSCNFG"."LINENO" = '9' )   ;
scode1 = mid( srcode, 1, 7)
scode2 = mid( srcode, 8, 7)
scode3 = mid( srcode, 15, 7)
scode4 = mid( srcode, 22, 7)
scode5 = mid( srcode, 29, 7)
scode6 = mid( srcode, 36, 7)
scode7 = mid( srcode, 43, 7)
scode8 = mid( srcode, 50, 7)

SELECT "SYSCNFG"."DATANAME"  										/*채무 계정*/
	INTO :srcode
   FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND  ( "SYSCNFG"."SERIAL" = 1 ) AND  
     		( "SYSCNFG"."LINENO" = '10' )   ;
ecode1 = mid( srcode, 1, 7)
ecode2 = mid( srcode, 8, 7)
ecode3 = mid( srcode, 15, 7)
ecode4 = mid( srcode, 22, 7)
ecode5 = mid( srcode, 29, 7)
ecode6 = mid( srcode, 36, 7)
ecode7 = mid( srcode, 43, 7)
ecode8 = mid( srcode, 50, 7)

SELECT "SYSCNFG"."DATANAME"  											/*회계법인명*/
	INTO :sSysNm
   FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND  ( "SYSCNFG"."SERIAL" = 1 ) AND  
     		( "SYSCNFG"."LINENO" = '11' )   ;

tab_list.tabpage_list2.dw_mst_print2.modify("s_nm1.text = '"+sSysnm+"'")
tab_list.tabpage_list2.dw_mst_print2.modify("s_nm2.text = '"+sSysnm+"'")
tab_list.tabpage_list2.dw_mst_print2.modify("s_nm3.text = '"+sSysnm+"'")

select rfna2  into :sTel from reffpf where rfcod ='SF' and rfgub <>'00';

tab_list.tabpage_list2.dw_mst_print2.modify("s_tel.text = '"+sTel+"'")


DECLARE YS_LIST CURSOR FOR
   select a.person_cd as p_cd, a.person_nm as p_nm,  
          nvl(jan1,0) as a1, nvl(jan2,0) as a2, nvl(jan3,0) as a3, nvl(jan4,0) as a4, 
          nvl(jan5,0) as b1, nvl(jan6,0) as b2, nvl(jan7,0) as b3, nvl(jan8,0) as b4, 
          (nvl(jan1,0)+ nvl(jan2,0)+ nvl(jan3,0)+ nvl(jan4,0)) as asum, 
          (nvl(jan5,0)+ nvl(jan6,0)+ nvl(jan7,0)+ nvl(jan8,0)) as bsum 
     from (select person_cd, person_nm  
             from kfz04om0) a, 
 
          (select saup_no,sum(dr_amt - cr_amt) as jan1 
             from kfz13ot0 
            where saupj = :sSaupj and 
                  (saup_no >= :incd_f and saup_no <= :incd_t) and
						acc1_cd || acc2_cd >= :scode1 and 
                  acc1_cd || acc2_cd <= :scode2 and 
                  acc_yy  = substr(:sAcc_ym,1,4) and 
                  acc_mm >= '00' and 
                  acc_mm <= substr(:sAcc_ym,5,2)
         group by saupj, saup_no ) b, 
 
          (select saup_no,sum(dr_amt - cr_amt) as jan2 
             from kfz13ot0 
            where saupj = :sSaupj and 
                  (saup_no >= :incd_f and saup_no <= :incd_t) and
						acc1_cd || acc2_cd >= :scode3 and 
                  acc1_cd || acc2_cd <= :scode4 and 
                  acc_yy  = substr(:sAcc_ym,1,4) and 
                  acc_mm >= '00' and 
                  acc_mm <= substr(:sAcc_ym,5,2)
         group by saup_no ) c, 
 
          (select saup_no,sum(dr_amt - cr_amt) as jan3 
             from kfz13ot0 
            where saupj = :sSaupj and 
                  (saup_no >= :incd_f and saup_no <= :incd_t) and
						acc1_cd || acc2_cd >= :scode5 and 
                  acc1_cd || acc2_cd <= :scode6 and 
                  acc_yy  = substr(:sAcc_ym,1,4) and 
                  acc_mm >= '00' and 
                  acc_mm <= substr(:sAcc_ym,5,2)
         group by saup_no) d, 
 
          (select saup_no,sum(dr_amt - cr_amt) as jan4 
             from kfz13ot0 
            where saupj = :sSaupj and 
                  (saup_no >= :incd_f and saup_no <= :incd_t) and
						acc1_cd || acc2_cd >= :scode7 and 
                  acc1_cd || acc2_cd <= :scode8 and 
                  acc_yy  = substr(:sAcc_ym,1,4) and 
                  acc_mm >= '00' and 
                  acc_mm <= substr(:sAcc_ym,5,2)
         group by saup_no) e, 
 
          (select saup_no,sum(cr_amt - dr_amt) as jan5 
             from kfz13ot0 
            where saupj = :sSaupj and 
                  (saup_no >= :incd_f and saup_no <= :incd_t) and
						acc1_cd || acc2_cd >= :ecode1 and 
                  acc1_cd || acc2_cd <= :ecode2 and 
                  acc_yy  = substr(:sAcc_ym,1,4) and 
                  acc_mm >= '00' and 
                  acc_mm <= substr(:sAcc_ym,5,2)
         group by saup_no) f, 
 
          (select saup_no,sum(cr_amt - dr_amt) as jan6 
             from kfz13ot0 
            where saupj = :sSaupj and 
                  (saup_no >= :incd_f and saup_no <= :incd_t) and
						acc1_cd || acc2_cd >= :ecode3 and 
                  acc1_cd || acc2_cd <= :ecode4 and 
                  acc_yy  = substr(:sAcc_ym,1,4) and 
                  acc_mm >= '00' and 
                  acc_mm <= substr(:sAcc_ym,5,2)
         group by saup_no) g, 
 
          (     select com.saup_no, sum(com.jan7) as jan7
from
(select saup_no,sum(cr_amt - dr_amt) as jan7
             from kfz13ot0
            where saupj = :sSaupj and
                  (saup_no >= :incd_f and saup_no <= :incd_t) and
						acc1_cd || acc2_cd >= :ecode5 and
                  acc1_cd || acc2_cd <= :ecode6 and
                  acc_yy  = substr(:sAcc_ym,1,4) and
                  acc_mm >= '00' and
                  acc_mm <= substr(:sAcc_ym,5,2)
         group by saup_no
			union all
		select saup_no,sum(cr_amt - dr_amt) as jan7
			 from kfz13ot0
			where saupj = :sSaupj and
					(saup_no >= :incd_f and saup_no <= :incd_t) and
					acc1_cd || acc2_cd = '2106006' and
					acc_yy  = substr(:sAcc_ym,1,4) and
					acc_mm >= '00' and
					acc_mm <= substr(:sAcc_ym,5,2)
		group by saup_no 	) com
group by com.saup_no
) h, 
 
          (select saup_no,sum(cr_amt - dr_amt) as jan8 
             from kfz13ot0 
            where saupj = :sSaupj and 
                  (saup_no >= :incd_f and saup_no <= :incd_t) and
						acc1_cd || acc2_cd >= :ecode7 and 
                  acc1_cd || acc2_cd <= :ecode8 and 
                  acc_yy  = substr(:sAcc_ym,1,4) and 
                  acc_mm >= '00' and 
                  acc_mm <= substr(:sAcc_ym,5,2)
         group by saup_no) i  
  
     where (a.person_cd = b.saup_no(+)) and 
           (a.person_cd = c.saup_no(+)) and 
           (a.person_cd = d.saup_no(+)) and 
           (a.person_cd = e.saup_no(+)) and 
           (a.person_cd = f.saup_no(+)) and 
           (a.person_cd = g.saup_no(+)) and 
           (a.person_cd = h.saup_no(+)) and 
           (a.person_cd = i.saup_no(+)) and 
           ((nvl(jan1,0) <> 0)  or   
            (nvl(jan2,0) <> 0)  or  
            (nvl(jan3,0) <> 0)  or  
            (nvl(jan4,0) <> 0)  or  
            (nvl(jan5,0) <> 0)  or  
            (nvl(jan6,0) <> 0)  or  
            (nvl(jan7,0) <> 0)  or  
            (nvl(jan8,0) <> 0))  
  order by p_cd ; 		
  
OPEN YS_LIST ; 

DO
	FETCH YS_LIST
	
	 INTO :sCustCd,         //거래처코드 
			:sCustNm,         //거래처명 
			:dInsAmt1,       //외상매출금
			:dInsAmt2,       //받을어음  
         :dInsAmt3,       //미수금			
         :dInsAmt4,       //선급금
         :dOutAmt1,      //외상매입금
			:dOutAmt2,      //지급어음  
         :dOutAmt3,      //미지급금			
         :dOutAmt4,      //선수금
			:dInsTot,        //채권합계
			:dOutTot ;      //채무합계
	IF SQLCA.SQLCODE <> 0 THEN EXIT

	lrow = tab_list.tabpage_list2.dw_mst_print2.InsertRow(0)
	
   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "vnd_nm", sCustNm)           //거래처명	
   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_tot", dInsTot)          //채권합계	
   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_tot", dOutTot)        //채무합계	
	// 채권에서의 15가지 경우의 수 
	IF dInsAmt1 <> 0 and dInsAmt2 <> 0 and dInsAmt3 <> 0 and dInsAmt4 <> 0 THEN //1
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_nm1", "외상매출금")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_amt1", dInsAmt1)        	
		tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_nm2", "받을어음")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_amt2", dInsAmt2)        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_nm3", "미수금")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_amt3", dInsAmt3)        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_nm4", "선급금")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_amt4", dInsAmt4)        	 
    END IF   
	IF dInsAmt1 <> 0 and dInsAmt2 <> 0 and dInsAmt3 <> 0 and dInsAmt4 = 0 THEN //2
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_nm1", "외상매출금")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_amt1", dInsAmt1)        	
		tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_nm2", "받을어음")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_amt2", dInsAmt2)        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_nm3", "미수금")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_amt3", dInsAmt3)        	
    END IF   
	IF dInsAmt1 <> 0 and dInsAmt2 <> 0 and dInsAmt3 = 0 and dInsAmt4 <> 0 THEN //3
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_nm1", "외상매출금")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_amt1", dInsAmt1)        	
		tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_nm2", "받을어음")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_amt2", dInsAmt2)        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_nm3", "선급금")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_amt3", dInsAmt4)        	 
    END IF   
	IF dInsAmt1 <> 0 and dInsAmt2 = 0 and dInsAmt3 <> 0 and dInsAmt4 <> 0 THEN //4
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_nm1", "외상매출금")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_amt1", dInsAmt1)        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_nm2", "미수금")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_amt2", dInsAmt3)        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_nm3", "선급금")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_amt3", dInsAmt4)        	 
    END IF   
	IF dInsAmt1 <> 0 and dInsAmt2 <> 0 and dInsAmt3 = 0 and dInsAmt4 = 0 THEN  //5
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_nm1", "외상매출금")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_amt1", dInsAmt1)        	
		tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_nm2", "받을어음")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_amt2", dInsAmt2)        	
    END IF   
	IF dInsAmt1 <> 0 and dInsAmt2 = 0 and dInsAmt3 <> 0 and dInsAmt4 = 0 THEN  //6
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_nm1", "외상매출금")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_amt1", dInsAmt1)        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_nm2", "미수금")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_amt2", dInsAmt3)        	
    END IF   
	IF dInsAmt1 <> 0 and dInsAmt2 = 0 and dInsAmt3 = 0 and dInsAmt4 <> 0 THEN  //7
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_nm1", "외상매출금")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_amt1", dInsAmt1)        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_nm2", "선급금")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_amt2", dInsAmt4)        	 
    END IF   
	IF dInsAmt1 <> 0 and dInsAmt2 = 0 and dInsAmt3 = 0 and dInsAmt4 = 0 THEN   //8
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_nm1", "외상매출금")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_amt1", dInsAmt1)        	
    END IF   
	IF dInsAmt1 = 0 and dInsAmt2 <> 0 and dInsAmt3 <> 0 and dInsAmt4 <> 0 THEN //9
		tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_nm1", "받을어음")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_amt1", dInsAmt2)        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_nm2", "미수금")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_amt2", dInsAmt3)        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_nm3", "선급금")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_amt3", dInsAmt4)        	 
    END IF   
	IF dInsAmt1 = 0 and dInsAmt2 <> 0 and dInsAmt3 <> 0 and dInsAmt4 = 0 THEN //10
		tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_nm1", "받을어음")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_amt1", dInsAmt2)        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_nm2", "미수금")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_amt2", dInsAmt3)        	
    END IF   
	IF dInsAmt1 = 0 and dInsAmt2 <> 0 and dInsAmt3 = 0 and dInsAmt4 <> 0 THEN //11
		tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_nm1", "받을어음")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_amt1", dInsAmt2)        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_nm2", "선급금")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_amt2", dInsAmt4)        	 
   END IF   
	IF dInsAmt1 = 0 and dInsAmt2 <> 0 and dInsAmt3 = 0 and dInsAmt4 = 0 THEN  //12
		tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_nm1", "받을어음")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_amt1", dInsAmt2)        	
   END IF   
	IF dInsAmt1 = 0 and dInsAmt2 = 0 and dInsAmt3 <> 0 and dInsAmt4 <> 0 THEN //13
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_nm1", "미수금")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_amt1", dInsAmt3)        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_nm2", "선급금")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_amt2", dInsAmt4)        	 
   END IF   
	IF dInsAmt1 = 0 and dInsAmt2 = 0 and dInsAmt3 <> 0 and dInsAmt4 = 0 THEN  //14
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_nm1", "미수금")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_amt1", dInsAmt3)        	
   END IF   
	IF dInsAmt1 = 0 and dInsAmt2 = 0 and dInsAmt3 = 0 and dInsAmt4 <> 0 THEN  //15
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_nm1", "선급금")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "in_amt1", dInsAmt4)        	 
   END IF
	// 채권에서의 15가지 경우의 수 
	IF dOutAmt1 <> 0 and dOutAmt2 <> 0 and dOutAmt3 <> 0 and dOutAmt4 <> 0 THEN //1
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_nm1", "외상매입금")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_amt1", dOutAmt1)        	
		tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_nm2", "지급어음")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_amt2", dOutAmt2)        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_nm3", "미지급금")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_amt3", dOutAmt3)        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_nm4", "선수금")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_amt4", dOutAmt4)        	 
    END IF   
	IF dOutAmt1 <> 0 and dOutAmt2 <> 0 and dOutAmt3 <> 0 and dOutAmt4 = 0 THEN //2
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_nm1", "외상매입금")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_amt1", dOutAmt1)        	
		tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_nm2", "지급어음")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_amt2", dOutAmt2)        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_nm3", "미지급금")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_amt3", dOutAmt3)        	
    END IF   
	IF dOutAmt1 <> 0 and dOutAmt2 <> 0 and dOutAmt3 = 0 and dOutAmt4 <> 0 THEN //3
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_nm1", "외상매입금")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_amt1", dOutAmt1)        	
		tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_nm2", "지급어음")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_amt2", dOutAmt2)        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_nm3", "선수금")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_amt3", dOutAmt4)        	 
    END IF   
	IF dOutAmt1 <> 0 and dOutAmt2 = 0 and dOutAmt3 <> 0 and dOutAmt4 <> 0 THEN //4
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_nm1", "외상매입금")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_amt1", dOutAmt1)        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_nm2", "미지급금")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_amt2", dOutAmt3)        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_nm3", "선수금")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_amt3", dOutAmt4)        	 
    END IF   
	IF dOutAmt1 <> 0 and dOutAmt2 <> 0 and dOutAmt3 = 0 and dOutAmt4 = 0 THEN  //5
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_nm1", "외상매입금")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_amt1", dOutAmt1)        	
		tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_nm2", "지급어음")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_amt2", dOutAmt2)        	
    END IF   
	IF dOutAmt1 <> 0 and dOutAmt2 = 0 and dOutAmt3 <> 0 and dOutAmt4 = 0 THEN  //6
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_nm1", "외상매입금")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_amt1", dOutAmt1)        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_nm2", "미지급금")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_amt2", dOutAmt3)        	
    END IF   
	IF dOutAmt1 <> 0 and dOutAmt2 = 0 and dOutAmt3 = 0 and dOutAmt4 <> 0 THEN  //7
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_nm1", "외상매입금")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_amt1", dOutAmt1)        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_nm2", "선수금")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_amt2", dOutAmt4)        	 
    END IF   
	IF dOutAmt1 <> 0 and dOutAmt2 = 0 and dOutAmt3 = 0 and dOutAmt4 = 0 THEN   //8
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_nm1", "외상매입금")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_amt1", dOutAmt1)        	
    END IF   
	IF dOutAmt1 = 0 and dOutAmt2 <> 0 and dOutAmt3 <> 0 and dOutAmt4 <> 0 THEN //9
		tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_nm1", "지급어음")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_amt1", dOutAmt2)        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_nm2", "미지급금")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_amt2", dOutAmt3)        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_nm3", "선수금")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_amt3", dOutAmt4)        	 
    END IF   
	IF dOutAmt1 = 0 and dOutAmt2 <> 0 and dOutAmt3 <> 0 and dOutAmt4 = 0 THEN //10
		tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_nm1", "지급어음")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_amt1", dOutAmt2)        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_nm2", "미지급금")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_amt2", dOutAmt3)        	
    END IF   
	IF dOutAmt1 = 0 and dOutAmt2 <> 0 and dOutAmt3 = 0 and dOutAmt4 <> 0 THEN //11
		tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_nm1", "지급어음")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_amt1", dOutAmt2)        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_nm2", "선수금")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_amt2", dOutAmt4)        	 
   END IF   
	IF dOutAmt1 = 0 and dOutAmt2 <> 0 and dOutAmt3 = 0 and dOutAmt4 = 0 THEN  //12
		tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_nm1", "지급어음")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_amt1", dOutAmt2)        	
   END IF   
	IF dOutAmt1 = 0 and dOutAmt2 = 0 and dOutAmt3 <> 0 and dOutAmt4 <> 0 THEN //13
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_nm1", "미지급금")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_amt1", dOutAmt3)        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_nm2", "선수금")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_amt2", dOutAmt4)        	 
   END IF   
	IF dOutAmt1 = 0 and dOutAmt2 = 0 and dOutAmt3 <> 0 and dOutAmt4 = 0 THEN  //14
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_nm1", "미지급금")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_amt1", dOutAmt3)        	
   END IF   
	IF dOutAmt1 = 0 and dOutAmt2 = 0 and dOutAmt3 = 0 and dOutAmt4 <> 0 THEN  //15
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_nm1", "선수금")        	
	   tab_list.tabpage_list2.dw_mst_print2.SetItem(lrow, "out_amt1", dOutAmt4)        	 
   END IF

LOOP WHILE TRUE

CLOSE YS_LIST ;

SETPOINTER(ARROW!)

if lrow < 1 then
	f_messagechk(11,"") 
   dw_ip.SetFocus()
	return -1
end if	

tab_list.tabpage_list2.dw_mst_print2.object.datawindow.print.preview = "yes"	
Return 1
end function

public function integer wf_print ();IF Idw_mst_print.RowCount() <=0 THEN
	gi_page = Idw_mst_print.GetItemNumber(1,"last_page")
ELSE
	gi_page = 1
END IF

OpenWithParm(w_print_options,Idw_mst_print)

Return -1
end function

on w_kgld08.create
int iCurrent
call super::create
this.tab_list=create tab_list
this.rb_1=create rb_1
this.rb_2=create rb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_list
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.gb_1
end on

on w_kgld08.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_list)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.gb_1)
end on

event open;call super::open;
dw_ip.SetItem(1,"acc_ym", left(f_today(), 6))
dw_ip.SetItem(1,"saupj", gs_saupj)

tab_list.tabpage_list.dw_mst_print.SetTransObject(SQLCA)
tab_list.tabpage_list2.dw_mst_print2.SetTransObject(SQLCA)

tab_list.SelectedTab = 1

idw_mst_print = tab_list.tabpage_list.dw_mst_print

rb_1.Checked =True
rb_1.TriggerEvent(Clicked!)

dw_ip.SetColumn("acc_ym")
dw_ip.SetFocus()

sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 가로방향"
end event

type p_xls from w_standard_print`p_xls within w_kgld08
end type

type p_sort from w_standard_print`p_sort within w_kgld08
end type

type p_preview from w_standard_print`p_preview within w_kgld08
integer y = 0
end type

type p_exit from w_standard_print`p_exit within w_kgld08
integer y = 0
end type

type p_print from w_standard_print`p_print within w_kgld08
integer y = 0
end type

event p_print::clicked;if wf_print() = -1 then return
end event

type p_retrieve from w_standard_print`p_retrieve within w_kgld08
integer y = 0
end type







type st_10 from w_standard_print`st_10 within w_kgld08
end type



type dw_print from w_standard_print`dw_print within w_kgld08
string dataobject = "dw_kgld082_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kgld08
integer x = 37
integer width = 3840
integer height = 284
string dataobject = "dw_kgld081"
end type

event dw_ip::itemchanged;string   saup_fr, saup_to,snull, ls_code, ls_name

SetNull(snull)

dw_ip.AcceptText()

if dwo.name <>"fr_incd" AND dwo.name<>"to_incd"  THEN RETURN

IF dwo.name = "fr_incd"  THEN
	ls_code = data
//   ls_name = dw_ip.GetItemString(dw_ip.GetRow(), "fr_innm")
  
   IF IsNull(ls_code) then
      ls_code = ""
   end if
   ls_code = Trim(ls_code)
  
  	SELECT "KFZ04OM0"."PERSON_NM"  
   	INTO :saup_fr  
    	FROM "KFZ04OM0"  
    	WHERE "KFZ04OM0"."PERSON_CD" = :ls_code ;
  	IF SQLCA.SQLCODE = 0 THEN 
		dw_ip.setitem(dw_ip.getrow(), "fr_innm", saup_fr) 
   ELSE
		dw_ip.setitem(dw_ip.getrow(), "fr_incd", snull) 
		dw_ip.setitem(dw_ip.getrow(), "fr_innm", snull) 
	END IF
	
ELSEIF dwo.name = "to_incd" THEN 
	ls_code = data
//	ls_name = dw_ip.GetItemString(dw_ip.GetRow(), "to_innm")

   IF IsNull(ls_code) then
      ls_code = ""
   end if
   ls_code = Trim(ls_code)
	
  	SELECT "KFZ04OM0"."PERSON_NM"  
   	INTO :saup_to  
    	FROM "KFZ04OM0"  
   	WHERE "KFZ04OM0"."PERSON_CD" = :ls_code ;

	IF SQLCA.SQLCODE = 0 THEN 
		dw_ip.setitem(dw_ip.getrow(), "to_innm", saup_to) 
   ELSE
		dw_ip.setitem(dw_ip.getrow(), "to_incd", snull) 
		dw_ip.setitem(dw_ip.getrow(), "to_innm", snull) 
	END IF
END IF

dw_ip.SetFocus()
end event

event dw_ip::itemerror;call super::itemerror;Return 1
end event

event dw_ip::getfocus;this.AcceptText()
end event

event dw_ip::rbuttondown;
IF this.GetColumnName() <>"fr_incd" AND this.GetColumnName() <>"to_incd"  THEN RETURN

SetNull(gs_code)
SetNull(gs_codename)
SetNull(lstr_custom.code)
SetNull(lstr_custom.name)

dw_ip.AcceptText()

IF this.GetColumnName() = "fr_incd"  THEN
	lstr_custom.code = dw_ip.GetItemString(dw_ip.GetRow(), "fr_incd")
//	lstr_custom.name = dw_ip.GetItemString(dw_ip.GetRow(), "fr_innm")
	
	IF IsNull(lstr_custom.code) then
		lstr_custom.code = ""
	end if
	lstr_custom.code = Trim(lstr_custom.code)
	
	lstr_account.gbn1 = '1'
	
	OpenWithParm(W_KFZ04OM0_POPUP1,lstr_account.gbn1)
	
	dw_ip.SetItem(dw_ip.GetRow(), "fr_incd", lstr_custom.code)
	dw_ip.SetItem(dw_ip.Getrow(), "fr_innm", lstr_custom.name)

ELSEIF this.GetColumnName() = "to_incd" THEN 
	lstr_custom.code = dw_ip.GetItemString(dw_ip.GetRow(), "to_incd")
//	lstr_custom.name = dw_ip.GetItemString(dw_ip.GetRow(), "to_innm")
	
	IF IsNull(lstr_custom.code) then
		lstr_custom.code = ""
	end if
	lstr_custom.code = Trim(lstr_custom.code)
	
	lstr_account.gbn1 = '1'
	
	OpenWithParm(W_KFZ04OM0_POPUP1,lstr_account.gbn1)

	dw_ip.SetItem(dw_ip.GetRow(), "to_incd", lstr_custom.code)
	dw_ip.SetItem(dw_ip.Getrow(), "to_innm", lstr_custom.name)

END IF
dw_ip.SetFocus()
end event

event dw_ip::ue_key;IF key = keytab! or key = keyf1! THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

type dw_list from w_standard_print`dw_list within w_kgld08
integer x = 2272
integer y = 2660
integer width = 681
integer height = 104
boolean controlmenu = true
end type

type tab_list from tab within w_kgld08
integer x = 41
integer y = 304
integer width = 4581
integer height = 1964
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
integer selectedtab = 1
tabpage_list tabpage_list
tabpage_list2 tabpage_list2
end type

on tab_list.create
this.tabpage_list=create tabpage_list
this.tabpage_list2=create tabpage_list2
this.Control[]={this.tabpage_list,&
this.tabpage_list2}
end on

on tab_list.destroy
destroy(this.tabpage_list)
destroy(this.tabpage_list2)
end on

event selectionchanging;
IF oldindex = 1 AND newindex = 2 THEN 
	IF tab_list.tabpage_list.dw_mst_print.GetRow() <=0 THEN Return 1
	
	IF Wf_Preview(tab_list.tabpage_list.dw_mst_print.GetRow()) <= 0 THEN Return 1
END IF

end event

event selectionchanged;
IF newindex = 1 THEN
	Idw_mst_print = tab_list.tabpage_list.dw_mst_print
ELSEIF newindex = 2 THEN
	Idw_mst_print = tab_list.tabpage_list2.dw_mst_print2
END IF
end event

type tabpage_list from userobject within tab_list
integer x = 18
integer y = 96
integer width = 4544
integer height = 1852
long backcolor = 32106727
string text = "채권채무"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
dw_mst_print dw_mst_print
end type

on tabpage_list.create
this.dw_mst_print=create dw_mst_print
this.Control[]={this.dw_mst_print}
end on

on tabpage_list.destroy
destroy(this.dw_mst_print)
end on

type dw_mst_print from datawindow within tabpage_list
integer width = 4544
integer height = 1844
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_kgld082"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type tabpage_list2 from userobject within tab_list
integer x = 18
integer y = 96
integer width = 4544
integer height = 1852
long backcolor = 32106727
string text = "채권채무조회서"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
dw_mst_print2 dw_mst_print2
end type

on tabpage_list2.create
this.dw_mst_print2=create dw_mst_print2
this.Control[]={this.dw_mst_print2}
end on

on tabpage_list2.destroy
destroy(this.dw_mst_print2)
end on

type dw_mst_print2 from datawindow within tabpage_list2
integer y = 8
integer width = 4544
integer height = 1840
integer taborder = 20
boolean bringtotop = true
string dataobject = "dw_kgld083"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rb_1 from radiobutton within w_kgld08
integer x = 3945
integer y = 204
integer width = 256
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "코드순"
end type

event clicked;tab_list.tabpage_list.dw_mst_print.SetRedraw(False)

IF rb_1.Checked =True THEN
	dw_print.setsort("#1 a")
   dw_print.sort()
END IF

tab_list.tabpage_list.dw_mst_print.SetRedraw(True)


end event

type rb_2 from radiobutton within w_kgld08
integer x = 4293
integer y = 204
integer width = 256
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "명칭순"
end type

event clicked;tab_list.tabpage_list.dw_mst_print.SetRedraw(False)

IF rb_2.Checked =True THEN
	dw_print.setsort("#2 a")
   dw_print.sort()
END IF

tab_list.tabpage_list.dw_mst_print.SetRedraw(True)


end event

type gb_1 from groupbox within w_kgld08
integer x = 3895
integer y = 164
integer width = 718
integer height = 128
integer taborder = 50
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "정렬"
end type

