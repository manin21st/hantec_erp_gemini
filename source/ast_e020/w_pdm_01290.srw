$PBExportHeader$w_pdm_01290.srw
$PBExportComments$품목마스타(구매,생산)
forward
global type w_pdm_01290 from w_inherite
end type
type tab_1 from tab within w_pdm_01290
end type
type tabpage_1 from userobject within tab_1
end type
type st_2 from statictext within tabpage_1
end type
type rr_2 from roundrectangle within tabpage_1
end type
type rr_3 from roundrectangle within tabpage_1
end type
type dw_1 from datawindow within tabpage_1
end type
type p_9 from uo_picture within tabpage_1
end type
type rr_1 from roundrectangle within tabpage_1
end type
type dw_shtnm from datawindow within tabpage_1
end type
type tabpage_1 from userobject within tab_1
st_2 st_2
rr_2 rr_2
rr_3 rr_3
dw_1 dw_1
p_9 p_9
rr_1 rr_1
dw_shtnm dw_shtnm
end type
type tabpage_common from userobject within tab_1
end type
type dw_common from datawindow within tabpage_common
end type
type rr_4 from roundrectangle within tabpage_common
end type
type tabpage_common from userobject within tab_1
dw_common dw_common
rr_4 rr_4
end type
type tabpage_mrp from userobject within tab_1
end type
type dw_mrp from datawindow within tabpage_mrp
end type
type rr_5 from roundrectangle within tabpage_mrp
end type
type tabpage_mrp from userobject within tab_1
dw_mrp dw_mrp
rr_5 rr_5
end type
type tabpage_mark from userobject within tab_1
end type
type p_2 from uo_picture within tabpage_mark
end type
type p_1 from uo_picture within tabpage_mark
end type
type dw_mark from datawindow within tabpage_mark
end type
type rr_6 from roundrectangle within tabpage_mark
end type
type rr_7 from roundrectangle within tabpage_mark
end type
type tabpage_mark from userobject within tab_1
p_2 p_2
p_1 p_1
dw_mark dw_mark
rr_6 rr_6
rr_7 rr_7
end type
type tabpage_2 from userobject within tab_1
end type
type p_4 from uo_picture within tabpage_2
end type
type p_3 from uo_picture within tabpage_2
end type
type dw_2 from datawindow within tabpage_2
end type
type rr_8 from roundrectangle within tabpage_2
end type
type rr_9 from roundrectangle within tabpage_2
end type
type rr_10 from roundrectangle within tabpage_2
end type
type tabpage_2 from userobject within tab_1
p_4 p_4
p_3 p_3
dw_2 dw_2
rr_8 rr_8
rr_9 rr_9
rr_10 rr_10
end type
type tabpage_3 from userobject within tab_1
end type
type p_6 from uo_picture within tabpage_3
end type
type p_5 from uo_picture within tabpage_3
end type
type dw_3 from datawindow within tabpage_3
end type
type rr_11 from roundrectangle within tabpage_3
end type
type rr_13 from roundrectangle within tabpage_3
end type
type rr_15 from roundrectangle within tabpage_3
end type
type tabpage_3 from userobject within tab_1
p_6 p_6
p_5 p_5
dw_3 dw_3
rr_11 rr_11
rr_13 rr_13
rr_15 rr_15
end type
type tabpage_4 from userobject within tab_1
end type
type p_8 from uo_picture within tabpage_4
end type
type p_7 from uo_picture within tabpage_4
end type
type dw_avl from datawindow within tabpage_4
end type
type rr_16 from roundrectangle within tabpage_4
end type
type rr_17 from roundrectangle within tabpage_4
end type
type rr_19 from roundrectangle within tabpage_4
end type
type tabpage_4 from userobject within tab_1
p_8 p_8
p_7 p_7
dw_avl dw_avl
rr_16 rr_16
rr_17 rr_17
rr_19 rr_19
end type
type tab_1 from tab within w_pdm_01290
tabpage_1 tabpage_1
tabpage_common tabpage_common
tabpage_mrp tabpage_mrp
tabpage_mark tabpage_mark
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
end type
type cbx_auto from checkbox within w_pdm_01290
end type
type dw_list from u_d_popup_sort within w_pdm_01290
end type
type p_do from uo_picture within w_pdm_01290
end type
type p_gi from uo_picture within w_pdm_01290
end type
type p_copy from uo_picture within w_pdm_01290
end type
type dw_saupj from datawindow within w_pdm_01290
end type
type cb_1 from commandbutton within w_pdm_01290
end type
type st_3 from statictext within w_pdm_01290
end type
end forward

global type w_pdm_01290 from w_inherite
string title = "품목마스타[구매/생산]"
tab_1 tab_1
cbx_auto cbx_auto
dw_list dw_list
p_do p_do
p_gi p_gi
p_copy p_copy
dw_saupj dw_saupj
cb_1 cb_1
st_3 st_3
end type
global w_pdm_01290 w_pdm_01290

type variables
long il_ins
string is_jejo, ls_gub ='Y'
str_itnct lstr_sitnct

string  is_version, is_Auto
string  is_Pspec, is_jijil  //규격, 재질명
end variables

forward prototypes
public function integer wf_mrp ()
public function integer wf_change ()
public subroutine wf_hsno (string s_hsno, ref decimal dcusrate, ref decimal dapprate)
public function integer wf_itnbr ()
public function integer wf_rename_yakum ()
public function integer wf_add_seqno_yakum ()
public function integer wf_common ()
public function integer wf_rename ()
public function integer wf_name_chk ()
public function integer wf_required_chk ()
public subroutine wf_init ()
public function integer wf_itnbr_check (string sitnbr)
public function integer wf_add_seqno ()
public subroutine wf_all_retrieve (string s_code)
public subroutine wf_retrieve (string arg_porgu, string s_pumgu, string s_date, string s_use)
public function integer wf_move ()
public function integer wf_update_hist ()
end prototypes

public function integer wf_mrp ();
string	sItem, sName, sSpec, sJijil, sIttyp

IF  ls_gub ='Y'	then // 등록

	sItem = dw_insert.GetItemString(1, "itnbr")
	sName = dw_insert.GetItemString(1, "itdsc")
	sSpec = dw_insert.GetItemString(1, "ispec")
	sJijil= dw_insert.GetItemString(1, "jijil")

	tab_1.Tabpage_common.dw_common.SetItem(1, "itnbr", sItem)
	tab_1.Tabpage_common.dw_common.SetItem(1, "itdsc", sName)
	tab_1.Tabpage_common.dw_common.SetItem(1, "ispec", sSpec)
	tab_1.Tabpage_common.dw_common.SetItem(1, "jijil", sJijil)

END IF

	
RETURN 1
end function

public function integer wf_change ();//string	sToday, sItem,				&
//			sIttyp, sTemp_Ittyp,		&
//			sItgu,  sTemp_Itgu,		&
//			sABC,	  sTemp_ABC
//dec		dLdtim, dTemp_Ldtim,		&
//			dLdtim2,dTemp_Ldtim2,	&
//			dMinsaf,dTemp_Minsaf,	&
//			dMidsaf,dTemp_Midsaf,	&
//			dMaxsaf,dTemp_Maxsaf,	&
//			dMinqt, dTemp_Minqt,		&
//			dMulqt, dTemp_Mulqt,		&
//			dMaxqt, dTemp_Maxqt
//
//sToday = f_Today()			
//sItem = dw_insert.GetItemString(1, "itnbr")				
//			
//			
/////////////////////////////////////////////////////////////////////////			
//// 품목구분(코드='1')
/////////////////////////////////////////////////////////////////////////
//sIttyp = dw_insert.GetItemString(1, "ittyp")					//변경후
//sTemp_Ittyp = dw_insert.GetItemString(1, "temp_ittyp")	//변경전
//
//IF sIttyp <> sTemp_Ittyp 	THEN
//
//  INSERT INTO "ITNFAT" 
//         ( "ITNBR", "FACHIS", "RPCGU", "BFDAT", "AFDAT" )
//  VALUES ( :sItem, :sToday, '1', :sTemp_Ittyp, :sIttyp );
//
//	IF SQLCA.SQLCODE <> 0	THEN
//		
//		UPDATE ITNFAT
//		   SET BFDAT = :sTemp_Ittyp, 
//				 AFDAT = :sIttyp
//		 WHERE ITNBR = :sItem	AND
//		 		 FACHIS = :sToday AND
//				 RPCGU = '1' ;
//	END IF
//	
//END IF
//			
//
/////////////////////////////////////////////////////////////////////////			
//// 구매형태(코드='2')
/////////////////////////////////////////////////////////////////////////
//sItgu = dw_insert.GetItemString(1, "itemas_itgu")		//변경후
//sTemp_Itgu = dw_insert.GetItemString(1, "temp_itgu")	//변경전
//
//IF sItgu <> sTemp_Itgu 	THEN
//
//  INSERT INTO "ITNFAT" 
//         ( "ITNBR", "FACHIS", "RPCGU", "BFDAT", "AFDAT" )
//  VALUES ( :sItem, :sToday, '2', :sTemp_Itgu, :sItgu );
//
//	IF SQLCA.SQLCODE <> 0	THEN
//		
//		UPDATE ITNFAT
//		   SET BFDAT = :sTemp_Itgu, 
//				 AFDAT = :sItgu
//		 WHERE ITNBR = :sItem	AND
//		 		 FACHIS = :sToday AND
//				 RPCGU = '2' ;
//	END IF
//	
//END IF
//			
//
/////////////////////////////////////////////////////////////////////////			
//// 리드타임-유(코드='4')
/////////////////////////////////////////////////////////////////////////
//dLdtim2 = dw_insert.GetItemDecimal(1, "itemas_ldtim2")		//변경후
//dTemp_Ldtim2 = dw_insert.GetItemDecimal(1, "temp_ldtim2")	//변경전
//
//IF ( dLdtim2 <> dTemp_Ldtim2 ) and ( dTemp_Ldtim2 <> 0 ) 	THEN
//
//  INSERT INTO "ITNFAT" 
//         ( "ITNBR", "FACHIS", "RPCGU", "BFQTY1", "AFQTY1" )
//  VALUES ( :sItem, :sToday, '4', :dTemp_Ldtim2, :dLdtim2 );
//
//	IF SQLCA.SQLCODE <> 0	THEN
//		
//		UPDATE ITNFAT
//		   SET BFQTY1 = :dTemp_Ldtim2, 
//				 AFQTY1 = :dLdtim2
//		 WHERE ITNBR = :sItem	AND
//		 		 FACHIS = :sToday AND
//				 RPCGU = '4' ;
//	END IF
//	
//END IF
//			
//
/////////////////////////////////////////////////////////////////////////			
//// 리드타임-무(코드='5')
/////////////////////////////////////////////////////////////////////////
//dLdtim = dw_insert.GetItemDecimal(1, "itemas_ldtim")		//변경후
//dTemp_Ldtim = dw_insert.GetItemDecimal(1, "temp_ldtim")	//변경전
//
//IF ( dLdtim <> dTemp_Ldtim ) and ( dTemp_Ldtim <> 0 )	THEN
//
//  INSERT INTO "ITNFAT" 
//         ( "ITNBR", "FACHIS", "RPCGU", "BFQTY1", "AFQTY1" )
//  VALUES ( :sItem, :sToday, '5', :dTemp_Ldtim, :dLdtim );
//
//	IF SQLCA.SQLCODE <> 0	THEN
//		
//		UPDATE ITNFAT
//		   SET BFQTY1 = :dTemp_Ldtim, 
//				 AFQTY1 = :dLdtim
//		 WHERE ITNBR = :sItem	AND
//		 		 FACHIS = :sToday AND
//				 RPCGU = '5' ;
//	END IF
//	
//END IF
//
//			
/////////////////////////////////////////////////////////////////////////			
//// ABC구분(코드='6')
/////////////////////////////////////////////////////////////////////////
//sABC = dw_insert.GetItemString(1, "itemas_abcgb")					//변경후
//sTemp_ABC = dw_insert.GetItemString(1, "temp_abcgb")	//변경전
//
//IF sABC <> sTemp_ABC 	THEN
//
//  INSERT INTO "ITNFAT" 
//         ( "ITNBR", "FACHIS", "RPCGU", "BFDAT", "AFDAT" )
//  VALUES ( :sItem, :sToday, '6', :sTemp_ABC, :sABC );
//
//	IF SQLCA.SQLCODE <> 0	THEN
//		
//		UPDATE ITNFAT
//		   SET BFDAT = :sTemp_ABC, 
//				 AFDAT = :sABC
//		 WHERE ITNBR = :sItem	AND
//		 		 FACHIS = :sToday AND
//				 RPCGU = '6' ;
//	END IF
//	
//END IF
//			
//
/////////////////////////////////////////////////////////////////////////			
//// 안전재고(코드='7')
/////////////////////////////////////////////////////////////////////////
//dMinsaf = dw_insert.GetItemDecimal(1, "itemas_minsaf")		//변경후
//dMidsaf = dw_insert.GetItemDecimal(1, "itemas_midsaf")		//변경후
//dMaxsaf = dw_insert.GetItemDecimal(1, "itemas_maxsaf")		//변경후
//dTemp_Minsaf = dw_insert.GetItemDecimal(1, "temp_minsaf")	//변경전
//dTemp_Midsaf = dw_insert.GetItemDecimal(1, "temp_midsaf")	//변경전
//dTemp_Maxsaf = dw_insert.GetItemDecimal(1, "temp_maxsaf")	//변경전
//
//
//IF (( dMinsaf <> dTemp_Minsaf ) and ( dTemp_Minsaf <> 0 ))		OR		&
//	(( dMidsaf <> dTemp_Midsaf ) and ( dTemp_Midsaf <> 0 ))		OR		&
//	(( dMaxsaf <> dTemp_Maxsaf ) and ( dTemp_Maxsaf <> 0 ))	  THEN
//
//		  INSERT INTO "ITNFAT" 
//   		      ( "ITNBR", "FACHIS", "RPCGU", "BFQTY1" ,"BFQTY2", "BFQTY3", 
//															"AFQTY1" ,"AFQTY2", "AFQTY3")
//		  VALUES ( :sItem, :sToday, '7', :dTemp_Minsaf, :dTemp_Midsaf, :dTemp_Maxsaf,
//  												   :dMinsaf, :dMidsaf, :dMaxsaf) ;
//
//			IF SQLCA.SQLCODE <> 0	THEN
//			
//				UPDATE ITNFAT
//			   	SET BFQTY1 = :dTemp_Minsaf, 
//						 BFQTY2 = :dTemp_Midsaf, 
//						 BFQTY3 = :dTemp_Maxsaf, 
//						 AFQTY1 = :dMinsaf, 
//						 AFQTY2 = :dMidsaf, 
//						 AFQTY3 = :dMaxsaf  
//				 WHERE ITNBR = :sItem	AND
//				 		 FACHIS = :sToday AND
//						 RPCGU = '7' ;
//			END IF
//END IF
//			
//
/////////////////////////////////////////////////////////////////////////			
//// LOT(코드='8')
/////////////////////////////////////////////////////////////////////////
//dMinqt = dw_insert.GetItemDecimal(1, "itemas_minqt")		//변경후
//dMulqt = dw_insert.GetItemDecimal(1, "itemas_mulqt")		//변경후
//dMaxqt = dw_insert.GetItemDecimal(1, "itemas_maxqt")		//변경후
//dTemp_Minqt = dw_insert.GetItemDecimal(1, "temp_minqt")	//변경전
//dTemp_Mulqt = dw_insert.GetItemDecimal(1, "temp_mulqt")	//변경전
//dTemp_Maxqt = dw_insert.GetItemDecimal(1, "temp_maxqt")	//변경전
//
//
//IF (( dMinqt <> dTemp_Minqt ) and ( dTemp_Minqt <> 0 ))  	OR		&
//	(( dMulqt <> dTemp_Mulqt ) and ( dTemp_Mulqt <> 0 ))		OR		&
//	(( dMaxqt <> dTemp_Maxqt ) and ( dTemp_Maxqt <> 0 ))	  THEN
//
//		  INSERT INTO "ITNFAT" 
//      		   ( "ITNBR", "FACHIS", "RPCGU", "BFQTY1" ,"BFQTY2", "BFQTY3", 
//															"AFQTY1" ,"AFQTY2", "AFQTY3")
//		  VALUES ( :sItem, :sToday, '8', :dTemp_Minqt, :dTemp_Mulqt, :dTemp_Maxqt,
//  												   :dMinqt, :dMulqt, :dMaxqt) ;
//
//			IF SQLCA.SQLCODE <> 0	THEN
//		
//				UPDATE ITNFAT
//				   SET BFQTY1 = :dTemp_Minqt, 
//						 BFQTY2 = :dTemp_Mulqt, 
//						 BFQTY3 = :dTemp_Maxqt, 
//						 AFQTY1 = :dMinqt, 
//						 AFQTY2 = :dMulqt, 
//						 AFQTY3 = :dMaxqt  
//				 WHERE ITNBR = :sItem	AND
//				 		 FACHIS = :sToday AND
//						 RPCGU = '8' ;
//			END IF
//END IF
//			
//			
//			
RETURN 1			
end function

public subroutine wf_hsno (string s_hsno, ref decimal dcusrate, ref decimal dapprate);SELECT "IMPRAT"."CUSRAT", "IMPRAT"."APPRAT"  
  INTO :dcusrate, :dapprate
  FROM "IMPRAT"  
 WHERE ( "IMPRAT"."HSNO" = SUBSTR(:s_hsno, 1, 2)	OR
		   "IMPRAT"."HSNO" = SUBSTR(:s_hsno, 1, 4)	OR
		   "IMPRAT"."HSNO" = SUBSTR(:s_hsno, 1, 6)	OR
		   "IMPRAT"."HSNO" = SUBSTR(:s_hsno, 1, 8)	OR
		   "IMPRAT"."HSNO" = SUBSTR(:s_hsno, 1, 10) ) AND
		 ROWNUM = 1 ;

end subroutine

public function integer wf_itnbr ();String 	sItnbr
	
sItnbr = dw_insert.GetItemString(1, "itnbr")	
IF IsNull(sItnbr) or sItnbr = ''	THEN
	dw_insert.setcolumn('itnbr')
	dw_insert.setfocus()
	f_message_chk(1400,'[품번]')
	RETURN -1
END IF

return 1
end function

public function integer wf_rename_yakum ();//////////////////////////////////////////////////////////////////////
// 야금용 채번	1. 품목구분 + 품목분류 앞 2자리 + SEQ NO(6자리) -> 품목코드 채번 
//////////////////////////////////////////////////////////////////////
String 	sItnbr,	sIttyp, sGubcode, sSeq, sAuto, get_name
long     lSeq

//품목구분
sIttyp   = dw_insert.getitemstring(1, 'ittyp')
sGubcode = dw_insert.getitemstring(1, 'itcls')

// 중분류코드
sGubcode = left(sGubcode, 2)	

sAuto = 'Y'  //무조건 채번
// 중분류코드 자동채번 CHECK
//SELECT "AUTO"
//  INTO :sAuto
//  FROM "ITNCT"  
// WHERE ( "ITNCT"."ITTYP" = :sIttyp ) AND  
//		 ( "ITNCT"."ITCLS" = :sGubcode ) AND  
//		 ( "ITNCT"."LMSGU" = 'L' )   ;
//
//if sqlca.sqlcode <> 0 then
//	f_message_chk(51,'[품목분류]')
//	return -1
//end if
//////////////////////////////////////////////////////////////////////////

IF sAuto = 'Y'		THEN

	SELECT "ITNCT"."SEQ"  
	  INTO :lSeq  
	  FROM "ITNCT"  
	 WHERE ( "ITNCT"."ITTYP" = :sIttyp ) AND  
			 ( "ITNCT"."ITCLS" = :sGubcode ) AND  
			 ( "ITNCT"."LMSGU" = 'L' ) FOR UPDATE ;

	if sqlca.sqlcode = 0 then
		if isnull(lseq) then lseq = 0 
		lSeq = lseq + 1
	else
		f_message_chk(51,'[품번]')
		return -1
	end if

	dw_insert.SetItem(1, "seqno" , lSeq )
	sSeq = string(lSeq, "000000")   //SEQ NO
	
	sItnbr = sIttyp + '-' + sGubCode + '-' + sSeq
	dw_insert.SetItem(1, "itnbr" , sItnbr )
	dw_insert.SetItem(1, "itemas_auto" , 'Y' )
//ELSE
//	MessageBox("확인", "중분류코드의 자동채번유무를 확인하십시요.~r" +  &
//							 "중분류코드 자동채번구분이 N0 로 설정되어 있습니다.")
//	RETURN -1
END IF

Return 1
end function

public function integer wf_add_seqno_yakum ();string sIttyp, sGubcode, smid
long   lSeq

sIttyp = dw_insert.getitemstring(1, 'ittyp')

sGubcode = dw_insert.getitemstring(1, 'itcls')
smid = Left(sGubcode, 2) 

lSeq = dw_insert.getitemnumber(1, 'seqno') 

UPDATE "ITNCT"  
   SET "SEQ" = :lSeq  
 WHERE ( "ITNCT"."ITTYP" = :sIttyp ) AND  
		 ( "ITNCT"."ITCLS" = :smid ) AND  
		 ( "ITNCT"."LMSGU" = 'L' )   ;

if sqlca.sqlcode = 0 then 
   return 1
else
	return -1
end if	
end function

public function integer wf_common ();
string	sItem, sName, sSpec, sJijil, sIttyp

sIttyp = dw_insert.GetItemString(1, "ittyp")
sItem = dw_insert.GetItemString(1, "itnbr")


IF IsNull(sIttyp) or sIttyp = ''		THEN
	sIttyp = '1'
END IF
tab_1.Tabpage_common.dw_common.SetItem(1, "ittyp", sIttyp)


//IF IsNull(sIttyp) or sIttyp = ''		THEN 	
//	f_message_chk(1400,'[품목구분]')
//	tab_1.SelectedTab = 1
//	RETURN -1
//END IF

	
IF  ls_gub ='Y'	then // 등록

	sName = dw_insert.GetItemString(1, "itdsc")
	sSpec = dw_insert.GetItemString(1, "ispec")
	sJijil= dw_insert.GetItemString(1, "jijil")

	tab_1.Tabpage_common.dw_common.SetItem(1, "itnbr", sItem)
	tab_1.Tabpage_common.dw_common.SetItem(1, "itdsc", sName)
	tab_1.Tabpage_common.dw_common.SetItem(1, "ispec", sSpec)
	tab_1.Tabpage_common.dw_common.SetItem(1, "jijil", sJijil)

ELSE
	
	string	sItgu
	dec		dCount

	SELECT COUNT(*)
	  INTO :dCount
	  FROM PSTRUC
	 WHERE PINBR = :sItem or
	 		 CINBR = :sItem ;

	IF dCount > 0 	THEN
		tab_1.Tabpage_common.dw_common.SetItem(1, "bom", 'Y')
	ELSE
		tab_1.Tabpage_common.dw_common.SetItem(1, "bom", 'N')
	END IF

	// 구입형태 CHECK
	sItgu = dw_insert.GetItemString(1, "itemas_itgu")

	IF IsNull(sItgu) or Trim(sItgu) = ''	THEN
		IF sIttyp = '1' or sIttyp = '2'  or sIttyp = '4' THEN
			tab_1.Tabpage_common.dw_common.SetItem(1, "gubun", '5')
		ELSE
			tab_1.Tabpage_common.dw_common.SetItem(1, "itgu", '1')
		END IF
	ELSE	
		IF sIttyp = '1' or sIttyp = '2'  or sIttyp = '4'  THEN
			tab_1.Tabpage_common.dw_common.SetItem(1, "gubun", sItgu)
		ELSE
			tab_1.Tabpage_common.dw_common.SetItem(1, "itgu", sItgu)
		END IF
	END IF

END IF

	
RETURN 1
end function

public function integer wf_rename ();//////////////////////////////////////////////////////////////////////
// 	1. 품목구분 + MODEL/품목분류 + SEQ NO + VERSION -> 품목코드 채번 
//////////////////////////////////////////////////////////////////////
String 	sItnbr,	sIttyp, sGubcode, sSeq, sVersion,	&
			sAuto, get_name
long     lSeq

//품목구분
sIttyp = dw_insert.getitemstring(1, 'ittyp')
sGubcode = dw_insert.getitemstring(1, 'itcls')

// 중분류코드
sGubcode = left(sGubcode, 4)	

// 중분류코드 자동채번 CHECK
SELECT "AUTO"
  INTO :sAuto
  FROM "ITNCT"  
 WHERE ( "ITNCT"."ITTYP" = :sIttyp ) AND  
		 ( "ITNCT"."ITCLS" = :sGubcode ) AND  
		 ( "ITNCT"."LMSGU" = 'M' )   ;

if sqlca.sqlcode <> 0 then
	f_message_chk(51,'[품목분류]')
	return -1
end if
//////////////////////////////////////////////////////////////////////////

IF sAuto = 'Y'		THEN

	SELECT "ITNCT"."SEQ"  
	  INTO :lSeq  
	  FROM "ITNCT"  
	 WHERE ( "ITNCT"."ITTYP" = :sIttyp ) AND  
			 ( "ITNCT"."ITCLS" = :sGubcode ) AND  
			 ( "ITNCT"."LMSGU" = 'M' ) FOR UPDATE ;

	if sqlca.sqlcode = 0 then
		lSeq = lseq + 1
	else
		f_message_chk(51,'[품번]')
		return -1
	end if

	dw_insert.SetItem(1, "seqno" , lSeq )
	sSeq = string(lSeq, "0000")   //SEQ NO
	sVersion = dw_insert.getitemstring(1, 'itnbr_version')
	
	sItnbr = sIttyp + sGubCode + sSeq 
	
	dw_insert.SetItem(1, "itnbr" , sItnbr )
	dw_insert.SetItem(1, "itemas_auto" , 'Y' )
ELSE
	MessageBox("확인", "중분류코드의 자동채번유무를 확인하십시요.~r" +  &
							 "중분류코드 자동채번구분이 N0 로 설정되어 있습니다.")
	RETURN -1
END IF

Return 1
end function

public function integer wf_name_chk ();string s_itnbr, s_itdsc, s_ispec, s_jijil, s_ittyp, sispec_code
long   get_count

if dw_insert.AcceptText() = -1 then return -1

/////////////////////////////////////////////////////////////////////////////
s_ittyp = trim(dw_insert.Getitemstring(1, 'ittyp'))
s_itnbr = trim(dw_insert.Getitemstring(1, 'itnbr'))
s_itdsc = trim(dw_insert.Getitemstring(1, 'itdsc'))
s_ispec = trim(dw_insert.Getitemstring(1, 'ispec'))
s_jijil = trim(dw_insert.Getitemstring(1, 'jijil'))
sispec_code = trim(dw_insert.Getitemstring(1, 'ispec_code')) 

// null 값 체크
if s_itdsc = '' or isnull(s_itdsc) then s_itdsc = '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@' 
if s_ispec = '' or isnull(s_ispec) then s_ispec = '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@' 
if s_jijil = '' or isnull(s_jijil) then s_jijil = '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@' 
if sispec_code = '' or isnull(sispec_code) then sispec_code = '@@@@@@@@@@@@@@@@@@@@' 

/* 규격만 Check (ADT) */

IF ls_gub = 'Y' THEN 
	SELECT COUNT(ITNBR)    INTO :get_count  
	  FROM ITEMAS  
	 WHERE NVL(UPPER(ITDSC), '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') = :s_itdsc
		AND NVL(UPPER(ISPEC), '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') = :s_ispec 
		AND ITTYP = :s_ittyp  ;

	IF get_count > 0 THEN 
		If MessageBox("확 인","동일한 규격으로 입력되어 있습니다.~r~n~r~n그래도 계속하시겠습니까?!", Exclamation!, YesNo! ) = 2 Then 
//		f_message_chk(49, '')
			RETURN -1
		End If
	END IF
ELSE
	SELECT COUNT(ITNBR)    INTO :get_count  
	  FROM ITEMAS  
	 WHERE ITNBR <> :s_itnbr
	   AND NVL(UPPER(ITDSC), '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') = :s_itdsc
		AND NVL(UPPER(ISPEC), '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') = :s_ispec 
		AND ITTYP = :s_ittyp  ;

	IF get_count > 0 THEN 
		If MessageBox("확 인","동일한 규격으로 입력되어 있습니다.~r~n~r~n그래도 계속하시겠습니까?!", Exclamation!, YesNo! ) = 2 Then 
//		f_message_chk(49, '')
			RETURN -1
		End If
	END IF
END IF

RETURN 1
end function

public function integer wf_required_chk ();string snull, sasc, s_ittyp, s_itcls, get_nm, s_pdtgu
int iasc

setnull(snull)

if isnull(dw_insert.GetItemString(1,'ittyp')) or &
	dw_insert.GetItemString(1,'ittyp') = "" then
	f_message_chk(1400,'[품목구분]')
	dw_insert.SetColumn('ittyp')
	dw_insert.SetFocus()
	return -1
end if	

if isnull(dw_insert.GetItemString(1,'itcls')) or &
	dw_insert.GetItemString(1,'itcls') = "" then
	f_message_chk(1400,'[품목분류]')
	dw_insert.SetColumn('itcls')
	dw_insert.SetFocus()
	return -1
else
	s_ittyp = dw_insert.getitemstring(1, 'ittyp')
   s_itcls = dw_insert.getitemstring(1, 'itcls')
	s_pdtgu = dw_insert.getitemstring(1, 'pdtgu')
	
  SELECT "ITNCT"."TITNM"  
    INTO :get_nm  
    FROM "ITNCT"  
   WHERE ( "ITNCT"."ITTYP" = :s_ittyp ) AND  
         ( "ITNCT"."ITCLS" = :s_itcls ) AND  
         ( "ITNCT"."LMSGU" <> 'L' )   ;

	IF SQLCA.SQLCODE <> 0 THEN
   	f_message_chk(33,'[품목분류]')
		dw_insert.SetColumn('itcls')
		dw_insert.SetFocus()
   	return -1
   END IF
	
//	If s_ittyp = '1' Or s_ittyp = '2' Then
//		If IsNull(s_pdtgu) Or Trim(s_pdtgu) = '' Then
//			f_message_chk(33,'[생산팀]')
//			dw_insert.SetColumn('pdtgu')
//			dw_insert.SetFocus()
//			return -1
//		END IF			
//	End If
end if			

if isnull(dw_insert.GetItemString(1,'itdsc')) or &
	dw_insert.GetItemString(1,'itdsc') = "" then
	f_message_chk(1400,'[품명]')
	dw_insert.SetColumn('itdsc')
	dw_insert.SetFocus()
	return -1
end if	

sAsc =  trim(dw_insert.GetItemString(1,'ispec')) 
 
iAsc = asc(sAsc)
if sAsc = "" or iAsc = 13 then   // ||(ctrl + enter 값) = 13(ascii code 값)   
 	dw_insert.SetItem(1, 'ispec', snull)
end if	

//if isnull(dw_insert.GetItemString(1,'itnbr_version')) or &
//	dw_insert.GetItemString(1,'itnbr_version') = "" then
//	f_message_chk(1400,'[VERSION]')
//	dw_insert.SetColumn('itnbr_version')
//	dw_insert.SetFocus()
//	return -1
//end if	
//
if isnull(dw_insert.GetItemString(1,'lotgub')) or &
	dw_insert.GetItemString(1,'lotgub') = "" then
	f_message_chk(1400,'[LOT NO 관리번호]')
	dw_insert.SetColumn('lotgub')
	dw_insert.SetFocus()
	return -1
end if	

if isnull(dw_insert.GetItemString(1,'gbwan')) or &
	dw_insert.GetItemString(1,'gbwan') = "" then
	f_message_chk(1400,'[개발완료구분]')
	dw_insert.SetColumn('gbwan')
	dw_insert.SetFocus()
	return -1
end if	

if isnull(dw_insert.GetItemString(1,'gbgub')) or &
	dw_insert.GetItemString(1,'gbgub') = "" then
	f_message_chk(1400,'[개발구분]')
	dw_insert.SetColumn('gbgub')
	dw_insert.SetFocus()
	return -1
end if	

if isnull(dw_insert.GetItemString(1,'useyn')) or &
	dw_insert.GetItemString(1,'useyn') = "" then
	f_message_chk(1400,'[사용구분]')
	dw_insert.SetColumn('useyn')
	dw_insert.SetFocus()
	return -1
end if	

///////////////////////////////////////////////////////////////////////
int k

// 인증MARK
FOR k=1 TO tab_1.tabpage_mark.dw_mark.rowcount()
	if isnull(tab_1.tabpage_mark.dw_mark.GetItemString(k,'mark')) or &
		tab_1.tabpage_mark.dw_mark.GetItemString(k,'mark') = "" then
      tab_1.SelectTab(4)
		f_message_chk(1400,'[MARK]')
		tab_1.tabpage_mark.dw_mark.SetRow(k)
		tab_1.tabpage_mark.dw_mark.SetColumn('mark')
		tab_1.tabpage_mark.dw_mark.SetFocus()
		return -1
	end if	
	if isnull(tab_1.tabpage_mark.dw_mark.GetItemString(k,'cvcod')) or &
		tab_1.tabpage_mark.dw_mark.GetItemString(k,'cvcod') = "" then
      tab_1.SelectTab(4)
		f_message_chk(1400,'[거래처]')
		tab_1.tabpage_mark.dw_mark.SetRow(k)
		tab_1.tabpage_mark.dw_mark.SetColumn('cvcod')
		tab_1.tabpage_mark.dw_mark.SetFocus()
		return -1
	end if	
	
	tab_1.tabpage_mark.dw_mark.SetItem(k, "seq", k)
	
NEXT


//관리품번
FOR k=1 TO tab_1.tabpage_2.dw_2.rowcount()
	if isnull(tab_1.tabpage_2.dw_2.GetItemString(k,'cvcod')) or &
		tab_1.tabpage_2.dw_2.GetItemString(k,'cvcod') = "" then
      tab_1.SelectTab(5)
		f_message_chk(1400,'[거래처]')
		tab_1.tabpage_2.dw_2.SetRow(k)
		tab_1.tabpage_2.dw_2.SetColumn('cvcod')
		tab_1.tabpage_2.dw_2.SetFocus()
		return -1
	end if	
NEXT

//대체품번
FOR k=1 TO tab_1.tabpage_3.dw_3.rowcount()
	if isnull(tab_1.tabpage_3.dw_3.GetItemString(k,'dtnbr')) or &
		tab_1.tabpage_3.dw_3.GetItemString(k,'dtnbr') = "" then
      tab_1.SelectTab(6)
		f_message_chk(1400,'[대체품번]')
		tab_1.tabpage_3.dw_3.SetRow(k)
		tab_1.tabpage_3.dw_3.SetColumn('dtnbr')
		tab_1.tabpage_3.dw_3.SetFocus()
		return -1
	end if	
NEXT


is_jejo = ''
// AVL 
FOR k=1 TO tab_1.tabpage_4.dw_avl.rowcount()
	if isnull(tab_1.tabpage_4.dw_avl.GetItemString(k,'maker')) or &
		tab_1.tabpage_4.dw_avl.GetItemString(k,'maker') = '' then
      tab_1.SelectTab(7)
		f_message_chk(1400,'[MAKER]')
		tab_1.tabpage_4.dw_avl.SetRow(k)
		tab_1.tabpage_4.dw_avl.SetColumn('maker')
		tab_1.tabpage_4.dw_avl.SetFocus()
		return -1
	end if	

	IF k = 1		THEN	
		is_Jejo = tab_1.tabpage_4.dw_avl.GetItemString(k, 'maker')
	ELSE
		is_Jejo = is_jejo + ',' + tab_1.tabpage_4.dw_avl.GetItemString(k, 'maker')
	END IF

	tab_1.tabpage_4.dw_avl.SetItem(k, "seqno", k)
	
NEXT

return 1
end function

public subroutine wf_init ();string ssaupj
long i

dw_insert.SetRedraw(false)

tab_1.tabpage_common.dw_common.SetRedraw(false)
tab_1.tabpage_1.dw_shtnm.SetRedraw(false)
tab_1.tabpage_mrp.dw_mrp.SetRedraw(false)
tab_1.tabpage_mark.dw_mark.SetRedraw(false)
tab_1.tabpage_2.dw_2.SetRedraw(false)
tab_1.tabpage_3.dw_3.SetRedraw(false)
tab_1.tabpage_4.dw_avl.SetRedraw(false)

ib_any_typing = FALSE

//
dw_insert.Reset()
tab_1.tabpage_common.dw_common.reset()
tab_1.tabpage_1.dw_shtnm.reset()
tab_1.tabpage_mrp.dw_mrp.reset()
tab_1.tabpage_mark.dw_mark.reset()
tab_1.tabpage_2.dw_2.reset()
tab_1.tabpage_3.dw_3.reset()
tab_1.tabpage_4.dw_avl.reset()

dw_insert.insertRow(0)
tab_1.tabpage_common.dw_common.InsertRow(0)
tab_1.tabpage_mrp.dw_mrp.InsertRow(0)

//
dw_insert.SetTaborder('itnbr',1)
//dw_insert.SetTaborder('itemas_auto',200)	
dw_insert.SetColumn('itnbr')
dw_insert.SetFocus()
dw_insert.SETItem(1, "gbdate", f_today())


//
tab_1.tabpage_common.dw_common.SetRedraw(true)
tab_1.tabpage_mrp.dw_mrp.SetRedraw(true)
tab_1.tabpage_mark.dw_mark.SetRedraw(true)
tab_1.tabpage_2.dw_2.SetRedraw(true)
tab_1.tabpage_3.dw_3.SetRedraw(true)
tab_1.tabpage_4.dw_avl.SetRedraw(true)
tab_1.tabpage_1.dw_shtnm.SetRedraw(true)
dw_insert.SetRedraw(true)

ls_gub = 'Y'    //'Y'이면 등록모드


/* 약호 등록 Datawindow 사업장 Setting */
for i = 1 to dw_saupj.RowCount()
	tab_1.tabpage_1.dw_shtnm.ScrollToRow(tab_1.tabpage_1.dw_shtnm.InsertRow(0))
	tab_1.tabpage_1.dw_shtnm.Setitem(tab_1.tabpage_1.dw_shtnm.GetRow(), 'saupj', dw_saupj.getitemstring(i,'rfgub'))
next
// 기술정보-초기화
tab_1.SelectedTab = 1

end subroutine

public function integer wf_itnbr_check (string sitnbr);Long icnt = 0

SetPointer(HourGlass!)
w_mdi_frame.sle_msg.text = '삭제 가능 여부 CHECK 중.....'

select count(*) into :icnt
  from vnddan
 where itnbr = :sitnbr;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[거래처제품단가]')
	return -1
end if

select count(*) into :icnt
  from danmst
 where itnbr = :sitnbr;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[단가마스타]')
	return -1
end if

select count(*) into :icnt
  from poblkt
 where itnbr = :sitnbr;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[발주_품목정보]')
	return -1
end if

select count(*) into :icnt
  from estima
 where itnbr = :sitnbr;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[발주예정_구매의뢰]')
	return -1
end if

select count(*) into :icnt
  from sorder
 where itnbr = :sitnbr;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[수주]')
	return -1
end if

select count(*) into :icnt
  from exppid
 where itnbr = :sitnbr;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[수출PI Detail]')
	return -1
end if

select count(*) into :icnt
  from imhist
 where itnbr = :sitnbr;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[입출고이력]')
	return -1
end if

//기술 BOM 체크  
  SELECT COUNT("ESTRUC"."USSEQ")  
    INTO :icnt  
    FROM "ESTRUC"  
   WHERE "ESTRUC"."PINBR" = :sitnbr OR "ESTRUC"."CINBR" = :sitnbr ;

if icnt > 0 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[기술BOM]')
	return -1
end if
	
//생산 BOM 체크  
  SELECT COUNT("PSTRUC"."USSEQ")  
    INTO :icnt  
    FROM "PSTRUC"  
   WHERE "PSTRUC"."PINBR" = :sitnbr OR "PSTRUC"."CINBR" = :sitnbr ;

if icnt > 0 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[생산BOM]')
	return -1
end if

//외주 BOM 체크  
  SELECT COUNT("WSTRUC"."USSEQ")  
    INTO :icnt  
    FROM "WSTRUC"  
   WHERE "WSTRUC"."PINBR" = :sitnbr OR "WSTRUC"."CINBR" = :sitnbr ;	

if icnt > 0 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[외주BOM]')
	return -1
end if

//외주단가 BOM 체크  
  SELECT SUM(1)  
    INTO :icnt  
    FROM "WSUNPR"  
   WHERE "WSUNPR"."ITNBR" = :sitnbr;

if icnt > 0 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[외주단가BOM]')
	return -1
end if

//할당 체크
select count(*) into :icnt
  from holdstock
 where itnbr = :sitnbr;
		 
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[할당]')
	return -1
end if

//월 재고
select count(*) into :icnt
  from stockmonth
 where itnbr = :sitnbr;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[기초재고]')
	return -1
end if

w_mdi_frame.sle_msg.text = ''

return 1
end function

public function integer wf_add_seqno ();string sIttyp, sGubcode, smid
long   lSeq

sIttyp = dw_insert.getitemstring(1, 'ittyp')

sGubcode = dw_insert.getitemstring(1, 'itcls')
smid = Left(sGubcode, 4) 

lSeq = dw_insert.getitemnumber(1, 'seqno') 

UPDATE "ITNCT"  
   SET "SEQ" = :lSeq  
 WHERE ( "ITNCT"."ITTYP" = :sIttyp ) AND  
		 ( "ITNCT"."ITCLS" = :smid ) AND  
		 ( "ITNCT"."LMSGU" = 'M' )   ;

if sqlca.sqlcode = 0 then 
   return 1
else
	return -1
end if	
end function

public subroutine wf_all_retrieve (string s_code);string shsno, ssaupj
decimal dcusrate, dapprate, i

dw_insert.SetTaborder('itnbr',0)
ib_any_typing = FALSE

p_gi.enabled = true
p_del.enabled = true
p_do.enabled = true
p_copy.enabled = true

p_gi.PictureName   = "C:\erpman\image\기술내역_up.gif"
p_del.PictureName  = "C:\erpman\image\삭제_up.gif"
p_do.PictureName   = "C:\erpman\image\도면조회_up.gif"
p_copy.PictureName = "C:\erpman\image\복사_up.gif"

ls_gub = 'N'    //'N'이면 수정모드
tab_1.tabpage_2.dw_2.retrieve(s_code)
tab_1.tabpage_1.dw_shtnm.retrieve(s_code)
tab_1.tabpage_3.dw_3.retrieve(s_code)
tab_1.tabpage_4.dw_avl.retrieve(s_code)
tab_1.tabpage_common.dw_common.retrieve(s_code)	
tab_1.tabpage_mrp.dw_mrp.retrieve(s_code)	
tab_1.tabpage_mark.dw_mark.retrieve(s_code)	

if tab_1.tabpage_1.dw_shtnm.RowCount() < 1 then
	for i = 1 to dw_saupj.Rowcount()		
		tab_1.tabpage_1.dw_shtnm.ScrollToRow(tab_1.tabpage_1.dw_shtnm.InsertRow(0))
		tab_1.tabpage_1.dw_shtnm.Setitem(tab_1.tabpage_1.dw_shtnm.GetRow(), 'saupj', dw_saupj.getitemstring(i,'rfgub'))
		tab_1.tabpage_1.dw_shtnm.Setitem(tab_1.tabpage_1.dw_shtnm.GetRow(), 'itnbr', s_code)
	next

end if

wf_common()		

shsno = TRIM(tab_1.tabpage_common.dw_common.GetItemString(1, 'hsno'))
if len(shsno) > 0 then 
	wf_hsno(shsno, dcusrate, dapprate) 
	tab_1.tabpage_common.dw_common.setitem(1, "hs_cusrate", dcusrate)
	tab_1.tabpage_common.dw_common.setitem(1, "hs_apprate", dapprate)
end if
end subroutine

public subroutine wf_retrieve (string arg_porgu, string s_pumgu, string s_date, string s_use);
if s_date = '' or isnull(s_date)  then 
	dw_list.SetFilter("")    //완료구분 = ALL
	dw_list.Filter( )
else
	dw_list.SetFilter(" crt_date  >= '"+s_date+"' ")
	dw_list.Filter( )
end if

if dw_list.Retrieve(arg_porgu, s_pumgu, s_use) <= 0 then
	dw_insert.setredraw(false)
	dw_insert.reset()
	dw_insert.insertrow(0)
	dw_insert.SETItem(1, "gbdate", f_today())
	dw_insert.SetTabOrder('itnbr',1)	
	dw_insert.SetColumn('itnbr')
	dw_insert.SetFocus()
	dw_insert.setredraw(true)
else
	dw_insert.setredraw(false)
	dw_insert.reset()
	dw_insert.insertrow(0)
	dw_insert.SetTabOrder('itnbr',1)	
	dw_list.SetFocus()
	dw_insert.setredraw(true)
end if	
	
ls_gub = 'Y'    //'Y'이면 등록모드
ib_any_typing = FALSE

p_gi.enabled = false
p_del.enabled = false
p_do.enabled = false
p_copy.enabled = false

p_gi.PictureName   = "C:\erpman\image\기술내역_d.gif"
p_del.PictureName  = "C:\erpman\image\삭제_d.gif"
p_do.PictureName   = "C:\erpman\image\도면조회_d.gif"
p_copy.PictureName = "C:\erpman\image\복사_d.gif"


end subroutine

public function integer wf_move ();
IF tab_1.Tabpage_common.dw_common.AcceptText() = -1	THEN RETURN -1

dw_insert.SetItem(1, "balrate",tab_1.Tabpage_common.dw_common.GetItemDecimal(1, "balrate"))

dw_insert.SetItem(1, "itemas_empno", tab_1.Tabpage_common.dw_common.GetItemString(1, "empno"))
dw_insert.SetItem(1, "itemas_unmsr", tab_1.Tabpage_common.dw_common.GetItemString(1, "unmsr"))
dw_insert.SetItem(1, "itemas_pumsr", tab_1.Tabpage_common.dw_common.GetItemString(1, "pumsr"))
dw_insert.SetItem(1, "itemas_cnvfat",tab_1.Tabpage_common.dw_common.GetItemDecimal(1, "cnvfat"))

dw_insert.SetItem(1, "itemas_holdyn", tab_1.Tabpage_common.dw_common.GetItemString(1, "itemas_holdyn"))
dw_insert.SetItem(1, "itemas_waght", tab_1.Tabpage_common.dw_common.GetItemNumber(1, "waght"))
dw_insert.SetItem(1, "itemas_filsk", tab_1.Tabpage_common.dw_common.GetItemString(1, "filsk"))
dw_insert.SetItem(1, "itemas_accod", tab_1.Tabpage_common.dw_common.GetItemString(1, "accod"))
dw_insert.SetItem(1, "itemas_locfr", tab_1.Tabpage_common.dw_common.GetItemString(1, "locfr"))
dw_insert.SetItem(1, "itemas_locto", tab_1.Tabpage_common.dw_common.GetItemString(1, "locto"))
dw_insert.SetItem(1, "itemas_hsno", tab_1.Tabpage_common.dw_common.GetItemString(1, "hsno"))
dw_insert.SetItem(1, "itemas_abcgb", tab_1.Tabpage_common.dw_common.GetItemString(1, "abcgb"))
dw_insert.SetItem(1, "itemas_silsu", tab_1.Tabpage_common.dw_common.GetItemNumber(1, "silsu"))
dw_insert.SetItem(1, "itemas_wonprc", tab_1.Tabpage_common.dw_common.GetItemNumber(1, "wonprc"))
dw_insert.SetItem(1, "itemas_forprc", tab_1.Tabpage_common.dw_common.GetItemNumber(1, "forprc"))
dw_insert.SetItem(1, "itemas_forpun", tab_1.Tabpage_common.dw_common.GetItemString(1, "forpun"))
dw_insert.SetItem(1, "itemas_wonsrc", tab_1.Tabpage_common.dw_common.GetItemNumber(1, "wonsrc"))
dw_insert.SetItem(1, "itemas_forsrc", tab_1.Tabpage_common.dw_common.GetItemNumber(1, "forsrc"))
dw_insert.SetItem(1, "itemas_forsun", tab_1.Tabpage_common.dw_common.GetItemString(1, "forsun"))
dw_insert.SetItem(1, "itemas_estdate", tab_1.Tabpage_common.dw_common.GetItemString(1, "estdate"))
//중점관리여부
dw_insert.SetItem(1, "itemas_prpgub", tab_1.Tabpage_common.dw_common.GetItemString(1, "prpgub"))
//열화성여부
dw_insert.SetItem(1, "yebi3", tab_1.Tabpage_common.dw_common.GetItemString(1, "yebi3"))
//검사항목코드
dw_insert.SetItem(1, "repreitnbr", trim(tab_1.Tabpage_common.dw_common.GetItemString(1, "repreitnbr")))
dw_insert.SetItem(1, "eng_yn"    , tab_1.Tabpage_common.dw_common.GetItemString(1, "itemas_eng_yn"))

// 구매형태
string	sIttyp
sIttyp = dw_insert.GetItemString(1, "ittyp")

//IF	sIttyp = '1' or sIttyp = '2'  THEN
//	dw_insert.SetItem(1, "itemas_itgu" , tab_1.Tabpage_common.dw_common.GetItemString(1, "gubun"))
//ElseIF	sIttyp = 'A' THEN // 외주가공품
//	dw_insert.SetItem(1, "itemas_itgu" , '6')
//ELSE
//	dw_insert.SetItem(1, "itemas_itgu" , tab_1.Tabpage_common.dw_common.GetItemString(1, "itgu"))
//END IF


///////////////////////////////////////////////////////////////////////////////////////////

IF tab_1.Tabpage_mrp.dw_mrp.AcceptText() = -1	THEN RETURN -1

dw_insert.SetItem(1, "itemas_mlicd", tab_1.Tabpage_mrp.dw_mrp.GetItemString(1, "mlicd"))
dw_insert.SetItem(1, "itemas_ldtim", tab_1.Tabpage_mrp.dw_mrp.GetItemDecimal(1, "ldtim"))
dw_insert.SetItem(1, "itemas_ldtim2", tab_1.Tabpage_mrp.dw_mrp.GetItemDecimal(1, "ldtim2"))
dw_insert.SetItem(1, "itemas_minsaf", tab_1.Tabpage_mrp.dw_mrp.GetItemDecimal(1, "minsaf"))
dw_insert.SetItem(1, "itemas_midsaf", tab_1.Tabpage_mrp.dw_mrp.GetItemDecimal(1, "midsaf"))
dw_insert.SetItem(1, "itemas_maxsaf", tab_1.Tabpage_mrp.dw_mrp.GetItemDecimal(1, "maxsaf"))
dw_insert.SetItem(1, "itemas_shrat", tab_1.Tabpage_mrp.dw_mrp.GetItemDecimal(1, "shrat"))
dw_insert.SetItem(1, "itemas_minqt", tab_1.Tabpage_mrp.dw_mrp.GetItemDecimal(1, "minqt"))
dw_insert.SetItem(1, "itemas_mulqt", tab_1.Tabpage_mrp.dw_mrp.GetItemDecimal(1, "mulqt"))
dw_insert.SetItem(1, "itemas_maxqt", tab_1.Tabpage_mrp.dw_mrp.GetItemDecimal(1, "maxqt"))

dw_insert.SetItem(1, "baseqty", tab_1.Tabpage_mrp.dw_mrp.GetItemDecimal(1, "baseqty"))
dw_insert.SetItem(1, "packqty", tab_1.Tabpage_mrp.dw_mrp.GetItemDecimal(1, "packqty"))
dw_insert.SetItem(1, "spec2", tab_1.Tabpage_mrp.dw_mrp.GetItemString(1, "spec2"))

dw_insert.SetItem(1, "lot", tab_1.Tabpage_mrp.dw_mrp.GetItemString(1, "lot"))
// 한텍-팔레트정보-2009.02.12-송병호
dw_insert.SetItem(1, "yebi3", tab_1.Tabpage_mrp.dw_mrp.GetItemString(1, "yebi3"))
dw_insert.SetItem(1, "forfac", tab_1.Tabpage_mrp.dw_mrp.GetItemNumber(1, "forfac"))

/* LJJ 추가 START */
dw_insert.SetItem(1, "rmark", tab_1.Tabpage_mrp.dw_mrp.GetItemNumber(1, "rmark"))
dw_insert.SetItem(1, "jijil2", tab_1.Tabpage_common.dw_common.GetItemString(1, "jijil2"))
dw_insert.SetItem(1, "newite", tab_1.Tabpage_common.dw_common.GetItemNumber(1, "newite"))

/* 수정 END */

RETURN 1
end function

public function integer wf_update_hist ();string s_frday, s_frtime

s_frday = f_today()
	
s_frtime = f_totime()

UPDATE "PGM_HISTORY"  
      SET "UPD_DATE" = :s_frday,   
             "UPD_TIME" = :s_frtime
 WHERE ( "PGM_HISTORY"."L_USERID" = :gs_userid ) AND  
          ( "PGM_HISTORY"."CDATE" = :is_today ) AND  
          ( "PGM_HISTORY"."STIME" = :is_totime ) AND  
          ( "PGM_HISTORY"."WINDOW_NAME" = :is_window_id )   ;

IF SQLCA.SQLCODE = 0 THEN 
   RETURN 1
ELSE 	  
   RETURN -1
END IF	  
end function

on w_pdm_01290.create
int iCurrent
call super::create
this.tab_1=create tab_1
this.cbx_auto=create cbx_auto
this.dw_list=create dw_list
this.p_do=create p_do
this.p_gi=create p_gi
this.p_copy=create p_copy
this.dw_saupj=create dw_saupj
this.cb_1=create cb_1
this.st_3=create st_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
this.Control[iCurrent+2]=this.cbx_auto
this.Control[iCurrent+3]=this.dw_list
this.Control[iCurrent+4]=this.p_do
this.Control[iCurrent+5]=this.p_gi
this.Control[iCurrent+6]=this.p_copy
this.Control[iCurrent+7]=this.dw_saupj
this.Control[iCurrent+8]=this.cb_1
this.Control[iCurrent+9]=this.st_3
end on

on w_pdm_01290.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
destroy(this.cbx_auto)
destroy(this.dw_list)
destroy(this.p_do)
destroy(this.p_gi)
destroy(this.p_copy)
destroy(this.dw_saupj)
destroy(this.cb_1)
destroy(this.st_3)
end on

event open;call super::open;dw_insert.SetTransObject(sqlca)
dw_list.SetTransObject(sqlca)
tab_1.tabpage_1.dw_1.SetTransObject(sqlca)
tab_1.tabpage_1.dw_shtnm.SetTransObject(sqlca)
tab_1.tabpage_2.dw_2.SetTransObject(sqlca)
tab_1.tabpage_3.dw_3.SetTransObject(sqlca)
tab_1.tabpage_4.dw_avl.SetTransObject(sqlca)
tab_1.tabpage_common.dw_common.SetTransObject(sqlca)
tab_1.tabpage_mrp.dw_mrp.SetTransObject(sqlca)
tab_1.tabpage_mark.dw_mark.SetTransObject(sqlca)
dw_saupj.SetTransObject(sqlca)
dw_saupj.Retrieve()

wf_init()

tab_1.tabpage_1.dw_1.InsertRow(0)


  SELECT "SYSCNFG"."DATANAME"
    INTO :is_Auto
    FROM "SYSCNFG"
   WHERE ( "SYSCNFG"."SYSGU" = 'S' ) AND  
         ( "SYSCNFG"."SERIAL" = 6 ) AND  
         ( "SYSCNFG"."LINENO" = '10' );

IF SQLCA.SQLCODE <> 0	THEN	is_Auto = 'Y'

IF is_Auto = 'N'	THEN	cbx_auto.visible = false

// 부가세 사업장 설정
f_mod_saupj(tab_1.tabpage_1.dw_1, 'dcomp')
end event

type dw_insert from w_inherite`dw_insert within w_pdm_01290
integer x = 2720
integer y = 332
integer width = 1801
integer height = 1336
integer taborder = 90
string dataobject = "d_pdm_01290"
boolean border = false
boolean livescroll = false
end type

event dw_insert::itemchanged;string s_itnbr, get_nm, s_name, s_date, snull, s_itt, s_itdsc, get_nm2, s_stdnbr, ls_gritu, ls_mdljijil, ls_data1, ls_data2
long   get_count, ireturn

setnull(snull)

this.accepttext()

IF this.GetColumnName() ="itnbr" THEN
	s_itnbr = this.GetText()
	
	IF s_itnbr = "" OR IsNull(s_itnbr) THEN RETURN
	
	SELECT "ITEMAS"."ITNBR"
	  INTO :get_nm   		
	  FROM "ITEMAS"  
	 WHERE "ITEMAS"."ITNBR" = :s_itnbr  ;
	IF SQLCA.SQLCODE = 0 THEN
		p_inq.TriggerEvent(Clicked!)
		RETURN 1
	END IF
ELSEIF this.GetColumnName() = 'ittyp' THEN
	s_itt = this.gettext()
 
   IF s_itt = "" OR IsNull(s_itt) THEN 
		this.SetItem(1,'itcls', snull)
		this.SetItem(1,'titnm1', snull)
		RETURN
   END IF

	//
	s_name = f_get_reffer('05', s_itt)
	if isnull(s_name) or s_name="" then
		f_message_chk(33,'[품목구분]')
		this.SetItem(1,'ittyp', snull)
		return 1
   end if
	this.SetItem(1,'itcls', snull)
	this.SetItem(1,'titnm1', snull)
		
	if s_itt <= '4' then
		SetItem(1, 'lotgub', 'N')
	else
		SetItem(1, 'lotgub', 'N')
	end if
	
	If s_itt = '1' Or s_itt = '2' Or s_itt = '8' Or s_itt = '9' Then
		SetItem(1, 'itemas_itgu', '5')
	ElseIf s_itt = 'A' Then
		SetItem(1, 'itemas_itgu', '6')
	Else
		SetItem(1, 'itemas_itgu', '2')
	End If
ELSEIF this.GetColumnName() = 'itcls' THEN
	s_name = this.gettext()
   s_itt  = this.getitemstring(1, 'ittyp')
   IF s_name = "" OR IsNull(s_name) THEN 	
		This.setitem(1, 'titnm1', snull)
		RETURN 
	END IF
	
  SELECT "ITNCT"."TITNM"  
    INTO :get_nm  
    FROM "ITNCT"  
   WHERE ( "ITNCT"."ITTYP" = :s_itt ) AND  
         ( "ITNCT"."ITCLS" = :s_name ) AND  
         ( "ITNCT"."LMSGU" <> 'L' )   ;

	IF SQLCA.SQLCODE <> 0 THEN
		this.TriggerEvent(rbuttondown!)
		if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then 
			This.setitem(1, 'itcls', snull)
			This.setitem(1, 'titnm1', snull)
			RETURN 1
      else
			this.SetItem(1,"ittyp",lstr_sitnct.s_ittyp)
			this.SetItem(1,"itcls", lstr_sitnct.s_sumgub)
			this.SetItem(1,"titnm1", lstr_sitnct.s_titnm)
			if ls_gub = 'Y' then 	this.SetItem(1, "itdsc", lstr_sitnct.s_titnm)
         Return 1			
      end if
   ELSE
		This.setitem(1, 'titnm1', get_nm)
		if ls_gub = 'Y' then 	this.SetItem(1, "itdsc",get_nm)
   END IF

////모델 코드 선택
//elseif this.GetColumnName() = 'itemas_gritu' then
//   
//	ls_gritu = this.GetText()
//	
//	IF ls_gritu = "" OR IsNull(ls_gritu) THEN RETURN
//	
//	Select RFGUB, RFNA1
//	INTO :ls_data1, :ls_data2
//   FROM REFFPF 
//   WHERE RFCOD = '01'
//	AND	RFGUB <> '00'
//	AND   RFGUB = :ls_gritu;
//
//	IF SQLCA.SQLCODE <> 0 THEN
//		MessageBox("확인","모델코드가 존재하지 않습니다.",Exclamation!)
//		this.SetItem(1,'itemas_gritu', '')
//		this.SetItem(1,'vhtype', '')
//		Return 1
//	End If
//	
//	this.SetItem(1,"itemas_gritu",ls_data1)
//	this.SetItem(1,"vhtype",ls_data2)
//	
////차종 코드 선택
//elseif this.GetColumnName() = 'mdl_jijil' then
//   
//	ls_mdljijil = this.GetText()
//	
//	IF ls_mdljijil = "" OR IsNull(ls_mdljijil) THEN RETURN
//	
//	Select RFGUB, RFNA1
//	INTO :ls_data1, :ls_data2
//   FROM REFFPF 
//   WHERE RFCOD = '1F'
//	AND	RFGUB <> '00'
//	AND   RFGUB = :ls_mdljijil;
//
//	IF SQLCA.SQLCODE <> 0 THEN
//		MessageBox("확인","모델코드가 존재하지 않습니다.",Exclamation!)
//		this.SetItem(1,'mdl_jijil', '')
//		this.SetItem(1,'model', '')
//		Return 1
//	End If
//	
//	this.SetItem(1,"mdl_jijil",ls_data1)
//	this.SetItem(1,"model",ls_data2)
	
ELSEIF this.GetColumnName() = 'empno2' THEN
	s_itt = this.gettext()
 
   IF s_itt = "" OR IsNull(s_itt) THEN RETURN
	
	s_name = f_get_reffer('46', s_itt)
	if isnull(s_name) or s_name="" then
		f_message_chk(33,'[개발담당자]')
		this.SetItem(1,'empno2', snull)
		return 1
   end if	
ELSEIF this.GetColumnName() = 'gbwan' THEN
	s_date = Trim(this.Gettext())
	IF s_date = 'Y' THEN
		this.SetItem(1,"gbdate", f_today())
		this.Setcolumn("gbdate")
		this.SetFocus()
   ELSE
		this.SetItem(1,"gbdate", sNull)
	END IF
ELSEIF this.GetColumnName() = 'useyn' THEN
	s_date = Trim(this.Gettext())
	IF s_date <> '0' and ls_gub = 'N' THEN
      s_itnbr = this.GetItemString(1, "itnbr")

  	   SELECT COUNT(*)
		  INTO :get_count
		  FROM "ITEMAS"  
		 WHERE "ITEMAS"."STDNBR" = :s_itnbr;
 
      if get_count > 0 then 
			messagebox("확 인", "생산대표품번으로 등록된 자료는 사용정지/단종 시킬 수 없습니다.")
			return 2
		end if	
	END IF
ELSEIF this.GetColumnName() = 'gbdate' THEN
	s_date = Trim(this.Gettext())
	IF s_date ="" OR IsNull(s_date) THEN RETURN
	
	IF f_datechk(s_date) = -1 THEN
		f_message_chk(35,'[개발완료일자]')
		this.SetItem(1,"gbdate",snull)
		this.Setcolumn("gbdate")
		this.SetFocus()
		Return 1
	END IF

ELSEIF this.GetColumnName() ="itemas_stdnbr" THEN
	s_stdnbr = this.GetText()
	
	IF s_stdnbr = "" OR IsNull(s_stdnbr) THEN
		this.SetItem(1,"itemas_itdsc",snull)
		this.SetItem(1,"itemas_ispec",snull)
		RETURN
	END IF
	
	ireturn = f_get_name2('전체품번', 'Y', s_stdnbr, get_nm, get_nm2)
	IF ireturn = 0 THEN
      s_itnbr = this.GetItemString(1, "itnbr")
		
		If s_itnbr = s_stdnbr then
    		f_message_chk(44,'[생산대표품번]')
			this.SetItem(1,"itemas_stdnbr",snull)
			this.SetItem(1,"itemas_itdsc",snull)
			this.SetItem(1,"itemas_ispec",snull)
			return 1
      Else		   
		   SELECT COUNT("PSTRUC"."PINBR")  
			  INTO :get_count  
			  FROM "PSTRUC"  
			 WHERE "PSTRUC"."PINBR" = :s_stdnbr   ;
         
			if get_count > 0 then
   			this.SetItem(1,"itemas_itdsc",get_nm)
				this.SetItem(1,"itemas_ispec",get_nm2)
				RETURN 1
			else
				f_message_chk(55,'[생산대표품번]')
				this.SetItem(1,"itemas_stdnbr",snull)
				this.SetItem(1,"itemas_itdsc",snull)
				this.SetItem(1,"itemas_ispec",snull)
				return 1
         end if
      End if
   ELSE
		this.SetItem(1,"itemas_stdnbr",snull)
		this.SetItem(1,"itemas_itdsc",snull)
		this.SetItem(1,"itemas_ispec",snull)
		return 1
   END IF
END IF	

end event

event dw_insert::itemerror;return 1
end event

event dw_insert::rbuttondown;string snull, sname

setnull(snull)
setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)

if this.GetColumnName() = 'itnbr' then
   gs_code = this.GetText()
	open(w_itemas_popup3)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"itnbr",gs_code)
	p_inq.TriggerEvent(Clicked!)
	RETURN 1
elseif this.GetColumnName() = 'itcls' then
	sname = this.GetItemString(1, 'ittyp')
	OpenWithParm(w_ittyp_popup, sname)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"ittyp",lstr_sitnct.s_ittyp)
   
	this.SetItem(1,"itcls", lstr_sitnct.s_sumgub)
	this.SetItem(1,"titnm1", lstr_sitnct.s_titnm)
	if ls_gub = 'Y' then 	this.SetItem(1, "itdsc", lstr_sitnct.s_titnm)
//	this.SetItem(1,"seqno", str_sitnct.l_seqno)
	this.SetColumn('itcls')
	this.SetFocus()
	RETURN 1
elseif this.GetColumnName() = 'itemas_stdnbr' then
   gs_code = this.GetText()
	open(w_itemas_popup3)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"itemas_stdnbr",gs_code)
	this.TriggerEvent(itemchanged!)
	RETURN 1

////모델 코드 선택
//elseif this.GetColumnName() = 'itemas_gritu' then
//   gs_code = this.GetText()
//
//	open(w_vehtype_popup)
//	
//	if isnull(gs_code) or gs_code = "" then return
//	this.SetItem(1,"itemas_gritu",gs_code)
//	this.SetItem(1,"vhtype",gs_codename)
//	
//	RETURN 1
////차종 코드 선택
//elseif this.GetColumnName() = 'mdl_jijil' then
//   gs_code = this.GetText()
//
//	open(w_model_popup)
//	
//	if isnull(gs_code) or gs_code = "" then return
//	this.SetItem(1,"mdl_jijil",gs_code)
//	this.SetItem(1,"model",gs_codename)
//	
//	RETURN 1

end if	

end event

event dw_insert::editchanged;RETURN 1
end event

event dw_insert::ue_key;call super::ue_key;//str_itnct str_sitnct
//string snull
//
//setnull(gs_code)
//setnull(snull)
//
//IF keydown(keyF1!) THEN
//	TriggerEvent(RbuttonDown!)
//ELSEIF keydown(keyF2!) THEN
//	IF This.GetColumnName() = "itnbr" Then
//		open(w_itemas_popup2)
//		if isnull(gs_code) or gs_code = "" then return
//		
//		this.SetItem(1,"itnbr",gs_code)
//		cb_inq.TriggerEvent(Clicked!)
//		RETURN 1
//	End if	
//END IF		
end event

event dw_insert::updatestart;/* Update() function 호출시 user 설정 */
long k, lRowCount

lRowCount = this.RowCount()

FOR k = 1 TO lRowCount
   IF  New! = this.GetItemStatus(k, 0, Primary!) OR NewModified! = this.GetItemStatus(k, 0, Primary!) THEN
 	   This.SetItem(k,'crt_user',gs_userid)
   ELSEIF DataModified! = this.GetItemStatus(k, 0, Primary!) THEN 		
	   This.SetItem(k,'upd_user',gs_userid)
   END IF	  
NEXT

	
end event

type p_delrow from w_inherite`p_delrow within w_pdm_01290
boolean visible = false
integer x = 4183
integer y = 2772
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_pdm_01290
boolean visible = false
integer x = 4009
integer y = 2772
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_pdm_01290
boolean visible = false
integer x = 3662
integer y = 2764
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_pdm_01290
boolean visible = false
integer x = 4357
integer y = 2784
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_pdm_01290
integer x = 4402
integer y = 12
end type

type p_can from w_inherite`p_can within w_pdm_01290
integer x = 4229
integer y = 12
end type

event p_can::clicked;call super::clicked;rollback ;

wf_init()

ib_any_typing = FALSE

p_copy.enabled = false
p_gi.enabled = false
p_del.enabled = false
p_do.enabled = false

p_gi.PictureName   = "C:\erpman\image\기술내역_d.gif"
p_del.PictureName  = "C:\erpman\image\삭제_d.gif"
p_do.PictureName   = "C:\erpman\image\도면조회_d.gif"
p_copy.PictureName = "C:\erpman\image\복사_d.gif"

tab_1.Tabpage_1.dw_1.TriggerEvent(itemchanged!)

dw_insert.SETItem(1, "gbdate", f_today())
dw_insert.SetColumn('itnbr')
dw_insert.SetFocus()



end event

type p_print from w_inherite`p_print within w_pdm_01290
boolean visible = false
integer x = 3835
integer y = 2764
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_pdm_01290
integer x = 3707
integer y = 12
integer taborder = 20
end type

event p_inq::clicked;call super::clicked;string s_code, get_gbwan, get_nm, shsno
long l_count
decimal dcusrate, dapprate
if dw_insert.AcceptText() = -1 then return

s_code = dw_insert.GetItemString(1,"itnbr")

if isnull(s_code) or s_code = "" then
	f_message_chk(30,'[품번]')
	dw_insert.SetFocus()
	return
end if	


tab_1.tabpage_1.dw_1.setredraw(False)
if dw_insert.Retrieve(s_code) <= 0 then
	f_message_chk(50,'[품목마스타]')
	wf_init()
	return
else
	wf_all_retrieve(s_code)
	dw_insert.Setfocus()
end if	

tab_1.tabpage_1.dw_1.setredraw(true)



end event

type p_del from w_inherite`p_del within w_pdm_01290
integer x = 4055
integer y = 12
boolean enabled = false
string picturename = "C:\erpman\image\삭제_d.gif"
end type

event p_del::clicked;call super::clicked;string s_itnbr
long   get_count, lrow

if dw_insert.AcceptText() = -1 then return 

s_itnbr = dw_insert.GetItemString(1,'itnbr')

if s_itnbr = '' or isnull(s_itnbr) then return 

//삭제하기전에 삭제여부 체크해야 
IF wf_itnbr_check(s_itnbr) = -1 THEN RETURN

SELECT COUNT("ITMDA"."DTNBR")  
  INTO :get_count  
  FROM "ITMDA"  
 WHERE "ITMDA"."DTNBR" = :s_itnbr   ;

IF get_count < 1 Then 
   IF f_msg_delete() = -1 THEN Return
ELSE
   IF MessageBox("삭 제","이 품번을 삭제하시면 다른 품번에 대체품번으로 등록된 "+ "~n" +&
								 "자료도 삭제됩니다." +"~n~n" +&
                      	 "삭제 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN RETURN
END IF

// FOREIGN KEY - CASCADE 사용
DELETE FROM "ITMBUY"  
   WHERE "ITMBUY"."ITNBR" = :s_itnbr   ;

DELETE FROM "ITMSHT"
   WHERE "ITMSHT"."ITNBR" = :s_itnbr   ;

If sqlca.sqlcode = 0 Then
	Commit;
Else
	Rollback;
End If

//
//DELETE FROM "ITMDA"  
//   WHERE "ITMDA"."ITNBR" = :s_itnbr OR "ITMDA"."DTNBR" = :s_itnbr ;

dw_insert.SetRedraw(FALSE)
dw_insert.DeleteROw(0)
if dw_insert.Update() = 1 then
else
	rollback ;
	F_ROLLBACK()
	return
end if

/* 저장 로그 확인 */
IF wf_update_hist() <= 0 THEN
	ROLLBACK;
	RETURN
END IF

w_mdi_frame.sle_msg.text =	"자료를 삭제하였습니다!!"	

COMMIT ;

lrow = dw_list.Find("itnbr = '" + s_itnbr + "'", 1, dw_list.RowCount())

if lrow > 0 then
   dw_list.DeleteROw(lrow)
end if

dw_insert.SetRedraw(TRUE)

ib_any_typing = FALSE

wf_init()

ib_any_typing = FALSE

p_gi.enabled = false
p_del.enabled = false
p_do.enabled = false
p_copy.enabled = false

p_gi.PictureName   = "C:\erpman\image\기술내역_d.gif"
p_del.PictureName  = "C:\erpman\image\삭제_d.gif"
p_do.PictureName   = "C:\erpman\image\도면조회_d.gif"
p_copy.PictureName = "C:\erpman\image\복사_d.gif"



end event

type p_mod from w_inherite`p_mod within w_pdm_01290
integer x = 3881
integer y = 12
integer taborder = 40
end type

event p_mod::clicked;call super::clicked;string s_code, s_itnbr, s_sh_code
Long i

if dw_insert.AcceptText() = -1 then return 
if tab_1.tabpage_1.dw_1.AcceptText() = -1 then return 
tab_1.tabpage_2.dw_2.AcceptText()
tab_1.tabpage_3.dw_3.AcceptText()
tab_1.tabpage_4.dw_avl.AcceptText()
tab_1.Tabpage_common.dw_common.AcceptText()
tab_1.Tabpage_mrp.dw_mrp.AcceptText()
tab_1.Tabpage_mark.dw_mark.AcceptText()
tab_1.Tabpage_1.dw_shtnm.AcceptText()

s_code = dw_insert.GetItemString(1,"itnbr")

// 필수입력사항 검사
if wf_required_chk() = -1 then return
/////////////////////////////////////////////////////////////////////////////

// 품명/규격명 체크
IF wf_name_chk() = -1	THEN
	dw_insert.setcolumn('itdsc')
	dw_insert.setfocus()
	RETURN 
END IF
//////////////////////////////////////////////////////////////////////////
// 등록
//////////////////////////////////////////////////////////////////////////
IF ls_gub = 'Y'		THEN
	IF is_auto = 'Y' THEN        //시스템 file에서 자동채번일때
		IF	cbx_auto.checked THEN  	
			
			// 원래 version
			// 품목번호 자동채번
			IF  wf_rename() = -1	THEN	RETURN 
		
			// 품목분류 순번증가
			if wf_add_seqno() < 0 then 
				rollback ;
				return 
			end if	
		ELSE	
			IF  wf_itnbr() = -1	THEN	RETURN 
		END IF
	ELSE	
		IF  wf_itnbr() = -1	THEN	RETURN 
	END IF

	// 일반정보 검사
	wf_Move()

	s_code = dw_insert.GetItemString(1,"itnbr")
//////////////////////////////////////////////////////////////////////////
// 조회
//////////////////////////////////////////////////////////////////////////
ELSE	
	// 일반정보 검사
	wf_Move()
   //2000/02/24 유상웅 itemas 트리거에서 업데이트 한다. 
	// 변경사항 CHECK
	//	wf_change()
END IF

IF f_msg_update() = -1 then
	rollback ;
	return
END IF

dw_insert.SetItem(1, "jejos", is_jejo)
// 기술정보 저장	
IF dw_insert.update() <= 0 	THEN
	ROLLBACK;
	RETURN
END IF


IF tab_1.tabpage_2.dw_2.update() <= 0 	THEN
	ROLLBACK;
	RETURN
END IF
		
IF tab_1.tabpage_3.dw_3.update() <= 0	THEN
	ROLLBACK;
	RETURN
END IF

IF tab_1.tabpage_4.dw_avl.update() <= 0	THEN
	ROLLBACK;
	RETURN
END IF

IF tab_1.tabpage_mark.dw_mark.update() > 0	THEN
	COMMIT;
ELSE
	ROLLBACK;
	RETURN
END IF

//messagebox(s_code,'')
/* 약호 Check */
For i = 1 to tab_1.tabpage_1.dw_shtnm.RowCount()
	s_sh_code = tab_1.tabpage_1.dw_shtnm.GetItemString(i, 'itnbr')
	
	if s_sh_code = '' or isNull(s_sh_code) or s_sh_code <> s_code then
		tab_1.tabpage_1.dw_shtnm.SetItem(i, 'itnbr', s_code)
	End If			
Next

IF tab_1.tabpage_1.dw_shtnm.update() > 0	THEN
	COMMIT;
ELSE
	ROLLBACK;
	RETURN
END IF

/* 저장 로그 확인 */
IF wf_update_hist() > 0 THEN
	COMMIT;
ELSE
	ROLLBACK;
	RETURN
END IF

p_inq.triggerevent(clicked!)	
	
//dw_insert.SetColumn('itnbr')
//dw_insert.SetFocus()
//
////////////////////////////////////////////////////////
//string	s_ittyp
//long		lReturnRow
//
//s_itnbr = dw_insert.getitemstring(1, 'itnbr')
//s_ittyp = dw_insert.getitemstring(1, 'ittyp')
//
//	
//tab_1.Tabpage_1.dw_1.setitem(1, 'ittyp', s_ittyp)
//
//String  s_use, s_date
//
//s_date = trim(tab_1.tabpage_1.dw_1.getitemstring(1, 'sildate'))
//s_use  = tab_1.tabpage_1.dw_1.getitemstring(1, 'useyn')
//
//if s_date = '' or isnull(s_date)  then 
//	dw_list.SetFilter("")    //완료구분 = ALL
//	dw_list.Filter( )
//else
//	dw_list.SetFilter(" crt_date  >= '"+s_date+"' ")
//	dw_list.Filter( )
//end if
//
//dw_list.Retrieve(s_ittyp, s_use) 
//
//lReturnRow = dw_list.Find("itnbr = '"+s_itnbr+"' ", 1, dw_list.RowCount())
//
//IF lReturnRow <> 0 THEN 
//	dw_list.selectrow(lReturnRow, true)
//	dw_list.scrolltorow(lReturnRow)
//END IF
//dw_insert.retrieve(s_itnbr) 
//	
//tab_1.tabpage_2.dw_2.retrieve(s_itnbr)
//tab_1.tabpage_3.dw_3.retrieve(s_itnbr)
//tab_1.tabpage_4.dw_avl.retrieve(s_itnbr)
//tab_1.tabpage_common.dw_common.retrieve(s_itnbr)	
//tab_1.tabpage_mrp.dw_mrp.retrieve(s_itnbr)	
//tab_1.tabpage_mark.dw_mark.retrieve(s_itnbr)	
//
//wf_common()		
//
//dw_insert.SetTaborder('itnbr',0)	
//dw_insert.setcolumn('ittyp')
//dw_insert.setfocus()
//
//ls_gub = 'N'
//cb_ins.enabled = true
//cb_del.enabled = true
//cb_search.enabled = true
//cb_print.enabled = true
//
//string shsno
//dec    dcusrate, dapprate
//
//shsno = TRIM(tab_1.tabpage_common.dw_common.GetItemString(1, 'hsno'))
//if len(shsno) > 0 then 
//	wf_hsno(shsno, dcusrate, dapprate) 
//	tab_1.tabpage_common.dw_common.setitem(1, "hs_cusrate", dcusrate)
//	tab_1.tabpage_common.dw_common.setitem(1, "hs_apprate", dapprate)
//end if
//
//
end event

type cb_exit from w_inherite`cb_exit within w_pdm_01290
integer x = 2880
integer y = 2684
end type

type cb_mod from w_inherite`cb_mod within w_pdm_01290
integer x = 1874
integer y = 2684
end type

type cb_ins from w_inherite`cb_ins within w_pdm_01290
integer x = 1019
integer y = 2688
integer width = 425
boolean enabled = false
string text = "기술내역(&T)"
end type

type cb_del from w_inherite`cb_del within w_pdm_01290
integer x = 2213
integer y = 2684
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_pdm_01290
integer x = 1531
integer y = 2684
end type

type cb_print from w_inherite`cb_print within w_pdm_01290
integer x = 3314
integer y = 2772
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_pdm_01290
long backcolor = 12632256
end type

type cb_can from w_inherite`cb_can within w_pdm_01290
integer x = 2551
integer y = 2684
end type

type cb_search from w_inherite`cb_search within w_pdm_01290
integer x = 571
integer y = 2696
integer width = 425
integer taborder = 50
boolean enabled = false
string text = "도면조회(&Q)"
end type



type sle_msg from w_inherite`sle_msg within w_pdm_01290
long backcolor = 12632256
end type

type gb_10 from w_inherite`gb_10 within w_pdm_01290
integer x = 41
integer y = 2804
integer height = 144
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12632256
end type

type gb_button1 from w_inherite`gb_button1 within w_pdm_01290
end type

type gb_button2 from w_inherite`gb_button2 within w_pdm_01290
end type

type tab_1 from tab within w_pdm_01290
event create ( )
event destroy ( )
integer x = 73
integer y = 172
integer width = 4517
integer height = 2112
integer taborder = 10
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean raggedright = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_common tabpage_common
tabpage_mrp tabpage_mrp
tabpage_mark tabpage_mark
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_common=create tabpage_common
this.tabpage_mrp=create tabpage_mrp
this.tabpage_mark=create tabpage_mark
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.Control[]={this.tabpage_1,&
this.tabpage_common,&
this.tabpage_mrp,&
this.tabpage_mark,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_common)
destroy(this.tabpage_mrp)
destroy(this.tabpage_mark)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
end on

event selectionchanged;IF dw_insert.AcceptText() = -1	THEN	RETURN -1

CHOOSE CASE newindex

	CASE 1
		dw_list.visible = true		
		dw_insert.visible = true
	CASE 2
		dw_list.visible = false
		dw_insert.visible = false
		
		wf_common()
		dw_insert.visible = false
		
	CASE 3
		dw_list.visible = false
		
		dw_insert.visible = false

		wf_mrp()
		
		dw_insert.visible = false	
	CASE 4
		dw_list.visible = false
		dw_insert.visible = false
	CASE 5
		dw_list.visible = false
		
		dw_insert.visible = true
	CASE 6
		dw_list.visible = false
		
		dw_insert.visible = true
	CASE 7
		dw_list.visible = false
		
		dw_insert.visible = true
END CHOOSE

end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4480
integer height = 2000
long backcolor = 32106727
string text = "기술 정보"
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
st_2 st_2
rr_2 rr_2
rr_3 rr_3
dw_1 dw_1
p_9 p_9
rr_1 rr_1
dw_shtnm dw_shtnm
end type

on tabpage_1.create
this.st_2=create st_2
this.rr_2=create rr_2
this.rr_3=create rr_3
this.dw_1=create dw_1
this.p_9=create p_9
this.rr_1=create rr_1
this.dw_shtnm=create dw_shtnm
this.Control[]={this.st_2,&
this.rr_2,&
this.rr_3,&
this.dw_1,&
this.p_9,&
this.rr_1,&
this.dw_shtnm}
end on

on tabpage_1.destroy
destroy(this.st_2)
destroy(this.rr_2)
destroy(this.rr_3)
destroy(this.dw_1)
destroy(this.p_9)
destroy(this.rr_1)
destroy(this.dw_shtnm)
end on

type st_2 from statictext within tabpage_1
boolean visible = false
integer x = 2674
integer y = 1460
integer width = 402
integer height = 52
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "약호등록"
boolean focusrectangle = false
end type

type rr_2 from roundrectangle within tabpage_1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 396
integer width = 2578
integer height = 1556
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within tabpage_1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2610
integer y = 20
integer width = 1833
integer height = 1920
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_1 from datawindow within tabpage_1
integer x = 18
integer y = 20
integer width = 2551
integer height = 364
integer taborder = 1
boolean bringtotop = true
string dataobject = "d_pdm_01272"
boolean border = false
end type

event itemchanged;string s_pumgu, s_name, snull, s_date, s_use, ls_Dcomp

setnull(snull)

if this.accepttext() = -1 then return 


//---------------------------------------------------------------------
ls_Dcomp   	= this.GetItemString(1,'dcomp')
s_pumgu   	= this.GetItemString(1,'ittyp')
s_Date   	= this.GetItemString(1,'sildate')
s_use   		= this.GetItemString(1,'useyn')

Choose Case this.GetColumnName()
	Case	"dcomp" 
		ls_Dcomp     = this.GetText()   // 사업장 구분 확인.
	     wf_retrieve(ls_Dcomp, s_pumgu, s_date, s_use)
	Case	"ittyp" 
		s_pumgu = this.GetText()
		IF s_pumgu = "" OR IsNull(s_pumgu) THEN 
			RETURN
		END IF
		
		s_name = f_get_reffer('05', s_pumgu)
		if isnull(s_name) or s_name="" then
			f_message_chk(33,'[품목구분]')
			this.SetItem(1,'ittyp', snull)
			return 1
		end if

	     wf_retrieve(ls_Dcomp, s_pumgu, s_date, s_use)
	Case	"sildate" 
		s_date     = trim(this.GetText())
		IF s_date ="" OR IsNull(s_date) THEN 
		   	wf_retrieve(ls_Dcomp, s_pumgu, s_date, s_use)
			Return 
		END IF
	
		IF f_datechk(s_date) = -1 THEN
			f_message_chk(35,'[생성일자]')
			this.SetItem(1,"sildate",snull)
	   		wf_retrieve(ls_Dcomp, s_pumgu, s_date, s_use)
			Return 1
		END IF

		if isnull(s_pumgu) or s_pumgu="" then
			f_message_chk(40,'[품목구분]')
			this.SetColumn('ittyp')
			this.SetFocus()
			return 1
		end if
   
   		wf_retrieve(ls_Dcomp, s_pumgu, s_date, s_use)
	Case	"useyn" 
		s_use      = this.GetText()
		if isnull(s_pumgu) or s_pumgu="" then
			f_message_chk(40,'[품목구분]')
			this.SetColumn('ittyp')
			this.SetFocus()
			return 1
		end if
           s_use = this.GetText()
   		wf_retrieve(ls_Dcomp, s_pumgu, s_date, s_use)
End Choose

//---------------------------------------------------------------------


end event

event itemerror;return 1
end event

event losefocus;if this.accepttext() = -1 then return 
end event

type p_9 from uo_picture within tabpage_1
integer x = 1851
integer y = 212
boolean bringtotop = true
string picturename = "C:\erpman\image\검색_up.gif"
end type

event clicked;call super::clicked;long lReturnRow, lrow

string sitdsc, sgub

if tab_1.tabpage_1.dw_1.accepttext() = -1 then return 

if dw_list.rowcount() < 1 then return 

sitdsc = trim(tab_1.tabpage_1.dw_1.getitemstring(1, 'itdsc'))

if sitdsc = '' or isnull(sitdsc) then 
	dw_list.selectrow(0, false)
	dw_list.selectrow(1, true)
	dw_list.scrolltorow(1)
	dw_insert.retrieve(dw_list.getitemstring(1, 'itnbr')) 
	dw_insert.SetTaborder('itnbr',0)	
else
	sitdsc = '%' + sitdsc + '%'
	
	sgub = dw_1.getitemstring(1, 'gub')
	lrow = dw_list.GetSelectedRow(0)
	
	if sgub = '1' then 
		lReturnRow = dw_list.Find("itnbr like '"+sitdsc+"' ", lrow+1, dw_list.RowCount())
	elseif sgub = '2' then 
		lReturnRow = dw_list.Find("itdsc like '"+sitdsc+"' ", lrow+1, dw_list.RowCount())
	elseif sgub = '3' then 
		lReturnRow = dw_list.Find("ispec like '"+sitdsc+"' ", lrow+1, dw_list.RowCount())
	elseif sgub = '4' then 
		lReturnRow = dw_list.Find("shtnm like '"+sitdsc+"' ", lrow+1, dw_list.RowCount())
	else
		lReturnRow = dw_list.Find("remark like '"+sitdsc+"' ", lrow+1, dw_list.RowCount())
	end if
	
	if isnull(lreturnrow) or lreturnrow < 1 then return 
	
	dw_list.selectrow(0, false)
	dw_list.selectrow(lReturnRow, true)
	dw_list.scrolltorow(lReturnRow)
	dw_insert.retrieve(dw_list.getitemstring(lReturnrow, 'itnbr')) 
	dw_insert.SetTaborder('itnbr',0)	
end if
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\검색_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\검색_dn.gif"
end event

type rr_1 from roundrectangle within tabpage_1
boolean visible = false
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 2610
integer y = 1432
integer width = 1833
integer height = 512
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_shtnm from datawindow within tabpage_1
boolean visible = false
integer x = 2670
integer y = 1524
integer width = 1733
integer height = 400
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_pdm_01290_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type tabpage_common from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4480
integer height = 2000
long backcolor = 32106727
string text = "일반 정보"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
dw_common dw_common
rr_4 rr_4
end type

on tabpage_common.create
this.dw_common=create dw_common
this.rr_4=create rr_4
this.Control[]={this.dw_common,&
this.rr_4}
end on

on tabpage_common.destroy
destroy(this.dw_common)
destroy(this.rr_4)
end on

type dw_common from datawindow within tabpage_common
event ue_pressenter pbm_dwnprocessenter
integer x = 187
integer y = 84
integer width = 3918
integer height = 1804
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_pdm_01291"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event rbuttondown;//
//IF this.GetColumnName() = 'ACCOD' 	THEN
//
//   gs_code = this.GetText()
//	open(w_gaejung_query)
//	
//	if isnull(gs_code) or gs_code = "" then return
//	
//	this.SetItem(1,"accod",gs_code)
//	this.SetItem(1,"accod",gs_codename)
//	
//END IF
end event

event itemerror;RETURN 1
end event

event itemchanged;string	sNull, sCode, sName
int      inull
decimal  d_cusrate, d_apprate

SetNull(sNull)
SetNull(iNull)

IF this.GetColumnName() = 'estdate' THEN

	IF f_datechk(this.GetText()) = -1 THEN
		f_message_chk(35,'[변경예정일]')
		this.SetItem(1,"estdate",snull)
		Return 1
	END IF
	
END IF

// 관리단위
IF this.GetColumnName() = 'unmsr' THEN

	sCode = this.gettext()
	
  SELECT "REFFPF"."RFNA1"  
    INTO :sName  
    FROM "REFFPF"  
   WHERE ( "REFFPF"."RFCOD" = '20' ) AND  
         ( "REFFPF"."RFGUB" = :sCode )   ;
	 
	if sqlca.sqlcode <> 0 	then
		f_message_chk(33,'[관리단위]')
		this.setitem(row, "unmsr", sNull)
		return 1
	end if
	 
END IF

// 계정과목
IF this.GetColumnName() = 'accod' THEN

	sCode = TRIM(this.gettext())
	
	string sleft, smid
	
	sleft = left(scode, 5)
	smid  = mid(scode, 6, 2)
	
   SELECT "KFZ01OM0"."ACC2_NM"  
	  INTO :sName
     FROM "KFZ01OM0"  
    WHERE "KFZ01OM0"."GBN3" = 'Y' and 
	       "KFZ01OM0"."ACC1_CD" = :sleft and    
	       "KFZ01OM0"."ACC2_CD" = :smid    ;
			 
	if sqlca.sqlcode <> 0 	then
		f_message_chk(33,'[계정과목]')
		this.setitem(row, "accod", sNull)
		return 1
	end if
	 
END IF

// 통화단위
IF this.GetColumnName() = 'forpun' THEN

	sCode = this.gettext()
	
  SELECT "REFFPF"."RFNA1"  
    INTO :sName  
    FROM "REFFPF"  
   WHERE ( "REFFPF"."RFCOD" = '10' ) AND  
         ( "REFFPF"."RFGUB" = :sCode )   ;
	 
	if sqlca.sqlcode <> 0 	then
		f_message_chk(33,'[통화단위]')
		this.setitem(row, "forpun", sNull)
		return 1
	end if
	 
END IF


// 통화단위
IF this.GetColumnName() = 'forsun' THEN

	sCode = this.gettext()
	
  SELECT "REFFPF"."RFNA1"  
    INTO :sName  
    FROM "REFFPF"  
   WHERE ( "REFFPF"."RFCOD" = '10' ) AND  
         ( "REFFPF"."RFGUB" = :sCode )   ;
	 
	if sqlca.sqlcode <> 0 	then
		f_message_chk(33,'[통화단위]')
		this.setitem(row, "forsun", sNull)
		return 1
	end if
	 
END IF

// hs No check
IF this.GetColumnName() = 'hsno' THEN

	sCode = trim(this.gettext())
	
	if sCode = '' or isnull(scode) then 
		this.setitem(row, "hs_cusrate", inull)
		this.setitem(row, "hs_apprate", inull)
		return 
	end if	
	
   wf_hsno(sCode, d_cusrate, d_apprate )
	this.setitem(row, "hs_cusrate", d_cusrate)
	this.setitem(row, "hs_apprate", d_apprate)

END IF


end event

type rr_4 from roundrectangle within tabpage_common
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 146
integer y = 44
integer width = 4000
integer height = 1868
integer cornerheight = 40
integer cornerwidth = 55
end type

type tabpage_mrp from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4480
integer height = 2000
long backcolor = 32106727
string text = "MRP 정보"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
dw_mrp dw_mrp
rr_5 rr_5
end type

on tabpage_mrp.create
this.dw_mrp=create dw_mrp
this.rr_5=create rr_5
this.Control[]={this.dw_mrp,&
this.rr_5}
end on

on tabpage_mrp.destroy
destroy(this.dw_mrp)
destroy(this.rr_5)
end on

type dw_mrp from datawindow within tabpage_mrp
event ue_pressenter pbm_dwnprocessenter
integer x = 347
integer y = 200
integer width = 3762
integer height = 1524
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_pdm_01295"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemerror;RETURN 1
end event

type rr_5 from roundrectangle within tabpage_mrp
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 256
integer y = 148
integer width = 3931
integer height = 1612
integer cornerheight = 40
integer cornerwidth = 55
end type

type tabpage_mark from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4480
integer height = 2000
long backcolor = 32106727
string text = "인증 정보"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
p_2 p_2
p_1 p_1
dw_mark dw_mark
rr_6 rr_6
rr_7 rr_7
end type

on tabpage_mark.create
this.p_2=create p_2
this.p_1=create p_1
this.dw_mark=create dw_mark
this.rr_6=create rr_6
this.rr_7=create rr_7
this.Control[]={this.p_2,&
this.p_1,&
this.dw_mark,&
this.rr_6,&
this.rr_7}
end on

on tabpage_mark.destroy
destroy(this.p_2)
destroy(this.p_1)
destroy(this.dw_mark)
destroy(this.rr_6)
destroy(this.rr_7)
end on

type p_2 from uo_picture within tabpage_mark
integer x = 4187
integer y = 204
integer width = 178
boolean originalsize = true
string picturename = "C:\erpman\image\행삭제2_up.gif"
end type

event clicked;call super::clicked;tab_1.tabpage_mark.dw_mark.AcceptText()

IF tab_1.tabpage_mark.dw_mark.GetRow() <=0 THEN
	f_message_chk(36,'')
	Return
END IF

tab_1.tabpage_mark.dw_mark.DeleteRow(0)

tab_1.tabpage_mark.dw_mark.ScrollToRow(tab_1.tabpage_mark.dw_mark.RowCount())
tab_1.tabpage_mark.dw_mark.Setfocus()

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\행삭제2_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\행삭제2_dn.gif'
end event

type p_1 from uo_picture within tabpage_mark
integer x = 4187
integer y = 60
integer width = 178
boolean originalsize = true
string picturename = "C:\erpman\image\행추가2_up.gif"
end type

event clicked;call super::clicked;Int    il_currow,il_RowCount, k, l_count
String s_itnbr, get_nm

//tab_1.tabpage_mark.dw_mark.AcceptText()
dw_insert.accepttext()

s_itnbr = dw_insert.GetItemString(1,"itnbr")
IF IsNull(s_itnbr) OR s_itnbr = "" THEN
	f_message_chk(30,'[품번]')
   dw_insert.SetColumn("itnbr")
	dw_insert.SetFocus()
	Return
END IF



IF tab_1.tabpage_mark.dw_mark.RowCount() <=0 THEN
	il_currow = 0
	il_rowCount = 0
ELSE
	il_currow = tab_1.tabpage_mark.dw_mark.GetRow()
	il_RowCount = tab_1.tabpage_mark.dw_mark.RowCount()
	
	IF il_currow <=0 THEN
		il_currow = il_rowCount
	END IF

//	FOR k=1 TO tab_1.tabpage_mark.dw_mark.RowCount()
//	    IF wf_requiredchk(tab_1.tabpage_mark.dw_mark.DataObject,k) = -1 THEN RETURN
//   NEXT
END IF

il_currow = il_rowCount + 1
// tab_1.SelectTab(4)

tab_1.tabpage_mark.dw_mark.InsertRow(il_currow)
tab_1.tabpage_mark.dw_mark.SetItem(il_currow,"itnbr",s_itnbr)
tab_1.tabpage_mark.dw_mark.ScrollToRow(il_currow)
tab_1.tabpage_mark.dw_mark.SetColumn("mark")
tab_1.tabpage_mark.dw_mark.SetFocus()

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\행추가2_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\행추가2_up.gif'
end event

type dw_mark from datawindow within tabpage_mark
event ue_pressenter pbm_dwnprocessenter
integer x = 46
integer y = 40
integer width = 4064
integer height = 1892
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_pdm_01296"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemchanged;Int lRow, lReturnRow
string s_cvcod, sNull, get_nm

SetNull(snull)

IF this.GetColumnName() = "cvcod" THEN
	lRow  = this.GetRow()	
	s_cvcod = this.GetText()								
    
	if s_cvcod = "" or isnull(s_cvcod) then 
		this.setitem(lrow, 'vndmst_cvnas', snull)
		return 
	end if
	
   SELECT "VNDMST"."CVNAS"  
     INTO :get_nm  
     FROM "VNDMST"  
    WHERE "VNDMST"."CVCOD" = :s_cvcod  ;

	if sqlca.sqlcode = 0 then 
		this.setitem(lrow, 'vndmst_cvnas', get_nm)
	else
		this.triggerevent(RbuttonDown!)
	   return 1
   end if	
	
END IF

string	sMark
IF this.GetColumnName() = "mark" THEN

	sMark = this.GetText()								
	sMark = sMark + '.bmp'
	this.SetItem(Row, "path", sMark)
END IF



end event

event rbuttondown;int lreturnrow, lrow
string snull

setnull(gs_code)
setnull(gs_codename)
setnull(snull)

lrow = this.getrow()

IF this.GetColumnName() = "cvcod" THEN
	gs_code = this.GetText()
	IF Gs_code ="" OR IsNull(gs_code) THEN 
		gs_code =""
	END IF

	Open(w_vndmst_popup)
	
	IF isnull(gs_Code)  or  gs_Code = ''	then  
		this.SetItem(lrow, "cvcod", snull)
		this.SetItem(lrow, "vndmst_cvnas", snull)
   	return
   END IF	

	this.SetItem(lrow, "cvcod", gs_Code)
	this.SetItem(lrow, "vndmst_cvnas", gs_Codename)
END IF

end event

event dberror;Beep(1)
IF f_message_chk(sqldbcode,'['+String(row)+'라인 ]') = -1 THEN
	Return
ELSE
	Return -1
END IF
end event

event itemerror;return 1
end event

event buttonclicked;//
//IF Row < 1		THEN	RETURN
//
//
//integer fh, ret
//blob Emp_pic
//string txtname, named
//string defext = "BMP"
//string Filter = "bitmap Files (*.bmp), *.bmp"
//
//
//	ret = GetFileOpenName("Open Bitmap", txtname, named, defext, filter)
//	
//	IF ret = 1 THEN
//      this.setitem(row, 'path', txtname)
//	END IF
//
end event

type rr_6 from roundrectangle within tabpage_mark
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 28
integer width = 4101
integer height = 1920
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_7 from roundrectangle within tabpage_mark
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 4151
integer y = 28
integer width = 242
integer height = 364
integer cornerheight = 40
integer cornerwidth = 55
end type

type tabpage_2 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 96
integer width = 4480
integer height = 2000
long backcolor = 32106727
string text = "관리품번 등록"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
p_4 p_4
p_3 p_3
dw_2 dw_2
rr_8 rr_8
rr_9 rr_9
rr_10 rr_10
end type

on tabpage_2.create
this.p_4=create p_4
this.p_3=create p_3
this.dw_2=create dw_2
this.rr_8=create rr_8
this.rr_9=create rr_9
this.rr_10=create rr_10
this.Control[]={this.p_4,&
this.p_3,&
this.dw_2,&
this.rr_8,&
this.rr_9,&
this.rr_10}
end on

on tabpage_2.destroy
destroy(this.p_4)
destroy(this.p_3)
destroy(this.dw_2)
destroy(this.rr_8)
destroy(this.rr_9)
destroy(this.rr_10)
end on

event other;dw_list.visible = false
dw_insert.visible = true
end event

type p_4 from uo_picture within tabpage_2
integer x = 229
integer y = 1784
integer width = 178
boolean originalsize = true
string picturename = "C:\erpman\image\행삭제2_up.gif"
end type

event clicked;call super::clicked;tab_1.tabpage_2.dw_2.AcceptText()

IF tab_1.tabpage_2.dw_2.GetRow() <=0 THEN
	f_message_chk(36,'')
	Return
END IF

//if f_delete_msg = -1 then return 

tab_1.tabpage_2.dw_2.DeleteRow(0)

//IF tab_1.tabpage_2.dw_2.Update() = 1 THEN
//	ib_any_typing =False
//	w_mdi_frame.sle_msg.text ="자료를 삭제하였습니다!!"
//ELSE
//	ROLLBACK;
//	Return
//END IF
//
//COMMIT;
//ib_any_typing =False

tab_1.tabpage_2.dw_2.ScrollToRow(tab_1.tabpage_2.dw_2.RowCount())
tab_1.tabpage_2.dw_2.Setfocus()

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\행삭제2_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\행삭제2_up.gif'
end event

type p_3 from uo_picture within tabpage_2
integer x = 55
integer y = 1784
integer width = 178
boolean originalsize = true
string picturename = "C:\erpman\image\행추가2_up.gif"
end type

event clicked;call super::clicked;Int    il_currow,il_RowCount, k
String s_itnbr

tab_1.tabpage_2.dw_2.AcceptText()
dw_insert.accepttext()

s_itnbr = dw_insert.GetItemString(1,"itnbr")

IF IsNull(s_itnbr) OR s_itnbr = "" THEN
	f_message_chk(30,'[품번]')
   dw_insert.SetColumn("itnbr")
	dw_insert.SetFocus()
	Return
END IF

IF tab_1.tabpage_2.dw_2.RowCount() <=0 THEN
	il_currow = 0
	il_rowCount = 0
ELSE
	il_currow = tab_1.tabpage_2.dw_2.GetRow()
	il_RowCount = tab_1.tabpage_2.dw_2.RowCount()
	
	IF il_currow <=0 THEN
		il_currow = il_rowCount
	END IF

//	FOR k=1 TO tab_1.tabpage_2.dw_2.RowCount()
//	    IF wf_requiredchk(tab_1.tabpage_2.dw_2.DataObject,k) = -1 THEN RETURN
//   NEXT
END IF

il_currow = il_rowCount + 1
//tab_1.SelectTab(5)
tab_1.tabpage_2.dw_2.InsertRow(il_currow)
tab_1.tabpage_2.dw_2.SetItem(il_currow,"itnbr",s_itnbr)
tab_1.tabpage_2.dw_2.ScrollToRow(il_currow)
tab_1.tabpage_2.dw_2.SetColumn("cvcod")
tab_1.tabpage_2.dw_2.SetFocus()

tab_1.tabpage_2.dw_2.Modify("DataWindow.HorizontalScrollPosition = '0'")

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\행추가2_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\행추가2_up.gif'
end event

type dw_2 from datawindow within tabpage_2
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 27
integer y = 60
integer width = 2482
integer height = 1664
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pdm_01292"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_key;if keydown(KeyEnter!) AND this.getcolumnname() = "buspc" then
   if this.rowcount() = this.getrow() then
      tab_1.tabpage_2.p_3.postevent(clicked!)
      return 1
   end if
end if

IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
//ELSEIF keydown(keyF2!) THEN
//	IF cb_4.Enabled = True THEN
//	   cb_4.TriggerEvent(Clicked!)
//   END IF 
END IF
end event

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event dberror;Beep(1)
IF f_message_chk(sqldbcode,'['+String(row)+'라인 ]') = -1 THEN
	Return
ELSE
	Return -1
END IF
end event

event editchanged;ib_any_typing =True
end event

event itemchanged;Int lRow, lReturnRow
string s_cvcod, sNull, get_nm

SetNull(snull)

lRow  = this.GetRow()	
IF this.GetColumnName() = "cvcod" THEN
	s_cvcod = this.GetText()								
    
	if s_cvcod = "" or isnull(s_cvcod) then 
		this.setitem(lrow, 'vndmst_cvnas', snull)
		return 
	end if
	
   SELECT "VNDMST"."CVNAS"  
     INTO :get_nm  
     FROM "VNDMST"  
    WHERE "VNDMST"."CVCOD" = :s_cvcod  ;

	if sqlca.sqlcode = 0 then 
		this.setitem(lrow, 'vndmst_cvnas', get_nm)
	else
		this.triggerevent(RbuttonDown!)
	   return 1
   end if	
	
	lReturnRow = This.Find("cvcod = '"+s_cvcod+"' ", 1, This.RowCount())
	IF (lRow <> lReturnRow) and (lReturnRow <> 0) THEN
		messagebox('확 인','등록된 거래처입니다. 순번을 증가시켜야 합니다.') 
//		RETURN  1
	END IF
END IF

IF 	this.GetColumnName() = "bunbr" THEN
	long    start_pos=1
	string  new_str, mystring

	mystring = this.GetText()		
	new_str = ""

	// Find the first occurrence of old_str.
	start_pos = Pos(mystring, '-', start_pos)

	// Only enter the loop if you find old_str.

	DO WHILE start_pos > 0

    		// Replace old_str with new_str.
    		mystring = Replace(mystring, start_pos,   Len('-'), new_str)

    		// Find the next occurrence of old_str.

    		start_pos = Pos(mystring, '-',  start_pos+Len(new_str))
	LOOP
	tab_1.Tabpage_2.dw_2.SetItem(lrow, "cunbr",mystring)
End If

end event

event itemerror;return 1
end event

event rbuttondown;int lreturnrow, lrow
string snull

setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)
setnull(snull)

lrow = this.getrow()

IF this.GetColumnName() = "cvcod" THEN
	gs_code = this.GetText()
	IF Gs_code ="" OR IsNull(gs_code) THEN 
		gs_code =""
	END IF
	
//	gs_gubun = '2'
	Open(w_vndmst_popup)
	
	IF isnull(gs_Code)  or  gs_Code = ''	then  
		this.SetItem(lrow, "cvcod", snull)
		this.SetItem(lrow, "vndmst_cvnas", snull)
   	return
   ELSE
		lReturnRow = This.Find("cvcod = '"+gs_code+"' ", 1, This.RowCount())
		IF (lRow <> lReturnRow) and (lReturnRow <> 0) THEN
			f_message_chk(37,'[거래처]') 
			this.SetItem(lRow, "cvcod", sNull)
		   this.SetItem(lRow, "vndmst_cvnas", sNull)
			RETURN  1
		END IF
   END IF	

	this.SetItem(lrow, "cvcod", gs_Code)
	this.SetItem(lrow, "vndmst_cvnas", gs_Codename)
END IF

end event

type rr_8 from roundrectangle within tabpage_2
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2583
integer y = 48
integer width = 1865
integer height = 1884
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_9 from roundrectangle within tabpage_2
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 9
integer y = 48
integer width = 2519
integer height = 1692
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_10 from roundrectangle within tabpage_2
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 9
integer y = 1764
integer width = 443
integer height = 184
integer cornerheight = 40
integer cornerwidth = 55
end type

type tabpage_3 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 96
integer width = 4480
integer height = 2000
long backcolor = 32106727
string text = "대체품번 등록"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
p_6 p_6
p_5 p_5
dw_3 dw_3
rr_11 rr_11
rr_13 rr_13
rr_15 rr_15
end type

on tabpage_3.create
this.p_6=create p_6
this.p_5=create p_5
this.dw_3=create dw_3
this.rr_11=create rr_11
this.rr_13=create rr_13
this.rr_15=create rr_15
this.Control[]={this.p_6,&
this.p_5,&
this.dw_3,&
this.rr_11,&
this.rr_13,&
this.rr_15}
end on

on tabpage_3.destroy
destroy(this.p_6)
destroy(this.p_5)
destroy(this.dw_3)
destroy(this.rr_11)
destroy(this.rr_13)
destroy(this.rr_15)
end on

event other;dw_list.visible = false
dw_insert.visible = true
end event

type p_6 from uo_picture within tabpage_3
integer x = 233
integer y = 1784
integer width = 178
string picturename = "C:\erpman\image\행삭제2_up.gif"
end type

event clicked;call super::clicked;tab_1.tabpage_3.dw_3.AcceptText()

IF tab_1.tabpage_3.dw_3.GetRow() <=0 THEN
	f_message_chk(36,'')
	Return
END IF

tab_1.tabpage_3.dw_3.DeleteRow(0)

tab_1.tabpage_3.dw_3.ScrollToRow(tab_1.tabpage_3.dw_3.RowCount())
tab_1.tabpage_3.dw_3.Setfocus()

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\행삭제2_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\행삭제2_up.gif'
end event

type p_5 from uo_picture within tabpage_3
integer x = 55
integer y = 1784
integer width = 178
string picturename = "C:\erpman\image\행추가2_up.gif"
end type

event clicked;call super::clicked;Int    il_currow,il_RowCount, k, l_count
String s_itnbr, get_nm

tab_1.tabpage_3.dw_3.AcceptText()
dw_insert.accepttext()

s_itnbr = dw_insert.GetItemString(1,"itnbr")

IF IsNull(s_itnbr) OR s_itnbr = "" THEN
	f_message_chk(30,'[품번]')
   dw_insert.SetColumn("itnbr")
	dw_insert.SetFocus()
	Return
END IF

SELECT COUNT("ITMDA"."DTNBR")
 INTO :l_count  
 FROM "ITMDA"  
WHERE "ITMDA"."DTNBR" = :s_itnbr   ;
 
IF l_count > 0 THEN
	f_message_chk(46,'[대체품번]')
   dw_insert.SetColumn("itnbr")
	dw_insert.SetFocus()
	Return
END IF

IF tab_1.tabpage_3.dw_3.RowCount() <=0 THEN
	il_currow = 0
	il_rowCount = 0
ELSE
	il_currow = tab_1.tabpage_3.dw_3.GetRow()
	il_RowCount = tab_1.tabpage_3.dw_3.RowCount()
	
	IF il_currow <=0 THEN
		il_currow = il_rowCount
	END IF

//	FOR k=1 TO tab_1.tabpage_3.dw_3.RowCount()
//	    IF wf_requiredchk(tab_1.tabpage_3.dw_3.DataObject,k) = -1 THEN RETURN
//   NEXT
END IF

il_currow = il_rowCount + 1
//tab_1.SelectTab(6)

tab_1.tabpage_3.dw_3.InsertRow(il_currow)
tab_1.tabpage_3.dw_3.SetItem(il_currow,"itnbr",s_itnbr)
tab_1.tabpage_3.dw_3.ScrollToRow(il_currow)
tab_1.tabpage_3.dw_3.SetColumn("dtnbr")
tab_1.tabpage_3.dw_3.SetFocus()

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\행추가2_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\행추가2_up.gif'
end event

type dw_3 from datawindow within tabpage_3
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 27
integer y = 60
integer width = 2487
integer height = 1672
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pdm_01293"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_key;
string snull, get_nm, s_itnbr
int lrow, lreturnrow, l_count

dw_insert.accepttext()

s_itnbr = dw_insert.GetItemString(1,"itnbr")
setnull(snull)

lrow = this.getrow()

IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
	IF This.GetColumnName() = "dtnbr" Then
		open(w_itemas_popup2)
		IF isnull(gs_Code)  or  gs_Code = ''	then  
			this.SetItem(lrow, "dtnbr", snull)
			this.SetItem(lrow, "itemas_itdsc", snull)
			return
		ELSE
			if s_itnbr = gs_code then
				f_message_chk(48,'[대체품번]') 
				this.SetItem(lRow, "dtnbr", sNull)
				this.SetItem(lRow, "itemas_itdsc", sNull)
				RETURN  1
			END IF
			
			lReturnRow = This.Find("dtnbr = '"+gs_code+"' ", 1, This.RowCount())
			IF (lRow <> lReturnRow) and (lReturnRow <> 0) THEN
				f_message_chk(37,'[대체품번]') 
				this.SetItem(lRow, "dtnbr", sNull)
				this.SetItem(lRow, "itemas_itdsc", sNull)
				RETURN  1
			END IF
	
			SELECT COUNT("ITMDA"."ITNBR")
			  INTO :l_count
			  FROM "ITMDA"  
			 WHERE "ITMDA"."ITNBR" = :gs_code   ;
	
			IF l_count > 0 THEN
				f_message_chk(47,'[대체품번]')
				this.SetItem(lRow, "dtnbr", sNull)
				this.SetItem(lRow, "itemas_itdsc", sNull)
				RETURN  1
			END IF
		END IF	
		this.SetItem(lrow,"dtnbr",gs_code)
		this.SetItem(lrow,"itemas_itdsc",gs_codename)
		RETURN 1
	End if	
END IF
end event

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event dberror;Beep(1)
IF f_message_chk(sqldbcode,'['+String(row)+'라인 ]') = -1 THEN
	Return
ELSE
	Return -1
END IF
end event

event itemerror;return 1
end event

event editchanged;ib_any_typing =True
end event

event itemchanged;Int lRow, lReturnRow, l_count
string s_dtnbr, sNull, get_nm, s_itnbr, s_ispec, s_ispec_code

SetNull(snull)
dw_insert.accepttext()

s_itnbr = dw_insert.GetItemString(1,"itnbr")

IF this.GetColumnName() = "dtnbr" THEN
	lRow  = this.GetRow()	
	s_dtnbr = this.GetText()								
    
	if s_dtnbr = "" or isnull(s_dtnbr) then 
		this.setitem(lrow, 'itemas_itdsc', snull)
		this.setitem(lrow, 'itemas_ispec', snull)
		this.setitem(lrow, 'ispec_code', snull)
		return 
	else
		if s_itnbr = s_dtnbr then
			f_message_chk(48,'[대체품번]') 
			this.SetItem(lRow, "dtnbr", sNull)
			this.SetItem(lRow, "itemas_itdsc", sNull)
			this.setitem(lrow, 'itemas_ispec', snull)
			this.setitem(lrow, 'ispec_code', snull)
			RETURN 1 
		END IF
   end if
	
  SELECT "ITEMAS"."ITDSC", "ITEMAS"."ISPEC", "ITEMAS"."ISPEC_CODE"      
    INTO :get_nm , :s_ispec, :s_ispec_code   
    FROM "ITEMAS"  
   WHERE "ITEMAS"."ITNBR" = :s_dtnbr AND "ITEMAS"."GBWAN" = 'Y'  ;

	if sqlca.sqlcode = 0 then 
		SELECT COUNT("ITMDA"."ITNBR")
		  INTO :l_count  
		  FROM "ITMDA"  
		 WHERE "ITMDA"."ITNBR" = :s_dtnbr   ;

		IF l_count > 0 THEN
			f_message_chk(47,'[대체품번]')
			this.SetItem(lRow, "dtnbr", sNull)
			this.SetItem(lRow, "itemas_itdsc", sNull)
			this.setitem(lrow, 'itemas_ispec', snull)
			this.setitem(lrow, 'ispec_code', snull)
			RETURN  1
		END IF

		this.setitem(lrow, 'itemas_itdsc', get_nm)
		this.setitem(lrow, 'itemas_ispec', s_ispec)
		this.setitem(lrow, 'ispec_code', s_ispec_code)
	else
		f_message_chk(33,'[대체품번]') 
		this.SetItem(lRow, "dtnbr", sNull)
		this.SetItem(lRow, "itemas_itdsc", sNull)
		this.setitem(lrow, 'itemas_ispec', snull)
		this.setitem(lrow, 'ispec_code', snull)
   end if	
	
	lReturnRow = This.Find("dtnbr = '"+s_dtnbr+"' ", 1, This.RowCount())
	IF (lRow <> lReturnRow) and (lReturnRow <> 0) THEN
		f_message_chk(37,'[대체품번]') 
		this.SetItem(lRow, "dtnbr", sNull)
		this.SetItem(lRow, "itemas_itdsc", sNull)
		this.setitem(lrow, 'itemas_ispec', snull)
		this.setitem(lrow, 'ispec_code', snull)
		RETURN  1
	END IF

END IF

	
end event

event rbuttondown;long lrow

setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)

lrow = this.getrow()

IF this.GetColumnName() = "dtnbr" THEN
	open(w_itemas_popup)
	
	IF isnull(gs_Code)  or  gs_Code = ''	then  return

	this.SetItem(lrow, "dtnbr", gs_Code)
	this.TriggerEvent(itemchanged!)

END IF

end event

type rr_11 from roundrectangle within tabpage_3
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2583
integer y = 48
integer width = 1865
integer height = 1884
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_13 from roundrectangle within tabpage_3
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 9
integer y = 48
integer width = 2519
integer height = 1692
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_15 from roundrectangle within tabpage_3
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 9
integer y = 1764
integer width = 443
integer height = 184
integer cornerheight = 40
integer cornerwidth = 55
end type

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4480
integer height = 2000
long backcolor = 32106727
string text = " AVL 등록 "
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
p_8 p_8
p_7 p_7
dw_avl dw_avl
rr_16 rr_16
rr_17 rr_17
rr_19 rr_19
end type

on tabpage_4.create
this.p_8=create p_8
this.p_7=create p_7
this.dw_avl=create dw_avl
this.rr_16=create rr_16
this.rr_17=create rr_17
this.rr_19=create rr_19
this.Control[]={this.p_8,&
this.p_7,&
this.dw_avl,&
this.rr_16,&
this.rr_17,&
this.rr_19}
end on

on tabpage_4.destroy
destroy(this.p_8)
destroy(this.p_7)
destroy(this.dw_avl)
destroy(this.rr_16)
destroy(this.rr_17)
destroy(this.rr_19)
end on

event other;dw_list.visible = false
dw_insert.visible = true
end event

type p_8 from uo_picture within tabpage_4
integer x = 233
integer y = 1784
integer width = 178
string picturename = "C:\erpman\image\행삭제2_up.gif"
end type

event clicked;call super::clicked;tab_1.tabpage_4.dw_avl.AcceptText()

IF tab_1.tabpage_4.dw_avl.GetRow() <=0 THEN
	f_message_chk(36,'')
	Return
END IF

tab_1.tabpage_4.dw_avl.DeleteRow(0)

tab_1.tabpage_4.dw_avl.ScrollToRow(tab_1.tabpage_4.dw_avl.RowCount())
tab_1.tabpage_4.dw_avl.Setfocus()

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\행삭제2_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\행삭제2_up.gif'
end event

type p_7 from uo_picture within tabpage_4
integer x = 55
integer y = 1784
integer width = 178
string picturename = "C:\erpman\image\행추가2_up.gif"
end type

event clicked;call super::clicked;Int    il_currow,il_RowCount, k, l_count
String s_itnbr, get_nm

//tab_1.tabpage_4.dw_avl.AcceptText()
dw_insert.accepttext()

s_itnbr = dw_insert.GetItemString(1,"itnbr")
IF IsNull(s_itnbr) OR s_itnbr = "" THEN
	f_message_chk(30,'[품번]')
   dw_insert.SetColumn("itnbr")
	dw_insert.SetFocus()
	Return
END IF



IF tab_1.tabpage_4.dw_avl.RowCount() <=0 THEN
	il_currow = 0
	il_rowCount = 0
ELSE
	il_currow = tab_1.tabpage_4.dw_avl.GetRow()
	il_RowCount = tab_1.tabpage_4.dw_avl.RowCount()
	
	IF il_currow <=0 THEN
		il_currow = il_rowCount
	END IF

//	FOR k=1 TO tab_1.tabpage_4.dw_avl.RowCount()
//	    IF wf_requiredchk(tab_1.tabpage_4.dw_avl.DataObject,k) = -1 THEN RETURN
//   NEXT
END IF

il_currow = il_rowCount + 1
// tab_1.SelectTab(7)
tab_1.tabpage_4.dw_avl.InsertRow(il_currow)
tab_1.tabpage_4.dw_avl.SetItem(il_currow,"itnbr",s_itnbr)
tab_1.tabpage_4.dw_avl.ScrollToRow(il_currow)
tab_1.tabpage_4.dw_avl.SetColumn("maker")
tab_1.tabpage_4.dw_avl.SetFocus()

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\행추가2_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\행추가2_up.gif'
end event

type dw_avl from datawindow within tabpage_4
event ue_pressenter pbm_dwnprocessenter
integer x = 23
integer y = 56
integer width = 2487
integer height = 1668
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_pdm_01294"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemerror;RETURN 1
end event

event itemchanged;Int 		lRow, lReturnRow
int		iNull, iNo

SetNull(iNull)

IF this.GetColumnName() = "seqno" THEN
	lRow  = this.GetRow()	
	iNo = Integer(this.GetText())								
    
		lReturnRow = This.Find("SEQNO = "+string(iNo)+" ", 1, This.RowCount())
		IF (lRow <> lReturnRow) and (lReturnRow <> 0) THEN
			f_message_chk(37,'[순번]') 
			this.SetItem(lRow, "seqno", iNull)
			RETURN  1
		END IF

END IF


	
end event

event dberror;Beep(1)
IF f_message_chk(sqldbcode,'['+String(row)+'라인 ]') = -1 THEN
	Return
ELSE
	Return -1
END IF
end event

type rr_16 from roundrectangle within tabpage_4
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2583
integer y = 48
integer width = 1865
integer height = 1884
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_17 from roundrectangle within tabpage_4
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 9
integer y = 48
integer width = 2519
integer height = 1692
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_19 from roundrectangle within tabpage_4
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 9
integer y = 1764
integer width = 443
integer height = 184
integer cornerheight = 40
integer cornerwidth = 55
end type

type cbx_auto from checkbox within w_pdm_01290
integer x = 4215
integer y = 184
integer width = 338
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "자동채번"
boolean checked = true
end type

type dw_list from u_d_popup_sort within w_pdm_01290
event ue_key pbm_dwnkey
boolean visible = false
integer x = 119
integer y = 676
integer width = 2555
integer height = 1532
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_pdm_01271"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event ue_key;//// Page Up & Page Down & Home & End Key 사용 정의
//choose case key
//	case keypageup!
//		dw_list.scrollpriorpage()
//	case keypagedown!
//		dw_list.scrollnextpage()
//	case keyhome!
//		dw_list.scrolltorow(1)
//	case keyend!
//		dw_list.scrolltorow(dw_list.rowcount())
//	case KeyupArrow!
//		dw_list.scrollpriorrow()
//	case KeyDownArrow!
//		dw_list.scrollnextrow()		
//end choose
//
//
end event

event clicked;call super::clicked;string s_code, ssaupj

SetPointer(HourGlass!)

this.SetRedraw(FALSE)

If Row <= 0 then
//	this.SelectRow(0,False)
	b_flag =True
ELSE

	this.SelectRow(0, FALSE)
	this.SelectRow(Row,TRUE)
	
	b_flag = False
   s_code = dw_list.GetItemString(Row,"itnbr")
	
   if dw_insert.Retrieve(s_code) <= 0 then
   	ls_gub = 'Y'    //'Y'이면 등록모드
		ib_any_typing = FALSE
		p_gi.enabled = FALSE
		p_del.enabled = FALSE
      p_gi.enabled = false
   else
		wf_all_retrieve(s_code)
		
	end if	
END IF	

CALL SUPER ::CLICKED 

long    k
boolean result

If Row <= 0 then
	FOR k=1 TO this.rowcount()
		result = this.IsSelected(k)
		IF result THEN
			dw_list.scrolltorow(k)
			dw_list.setrow(k)
			EXIT
		END IF
	NEXT
END IF

this.SetRedraw(true)
end event

event rowfocuschanged;string s_code, sitnbr, sitdsc, sorgitnbr

if currentrow < 1 then return 
if this.rowcount() < 1 then return 

this.setredraw(false)

this.SelectRow(0,False)
this.SelectRow(currentrow,True)

this.ScrollToRow(currentrow)

s_code = dw_list.GetItemString(currentrow,"itnbr")
dw_insert.Retrieve(s_code)
ls_gub = 'N'    //'N'이면 수정모드

wf_all_retrieve(s_code)

this.setredraw(true)

end event

type p_do from uo_picture within w_pdm_01290
boolean visible = false
integer x = 265
integer y = 12
integer width = 178
boolean bringtotop = true
boolean enabled = false
string picturename = "C:\erpman\image\도면조회_d.gif"
end type

event clicked;call super::clicked;STRING SITNBR

IF dw_insert.accepttext() = -1 THEN RETURN 

sItnbr = dw_insert.getitemstring(1, 'itnbr')

OpenWithParm(w_pdm_01280, sItnbr)


end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\도면조회_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\도면조회_dn.gif"
end event

type p_gi from uo_picture within w_pdm_01290
integer x = 50
integer y = 16
integer width = 178
boolean bringtotop = true
string picturename = "C:\erpman\image\기술내역_d.gif"
end type

event clicked;call super::clicked;string sItnbr
if dw_insert.accepttext() = -1 then return 

sItnbr = dw_insert.getitemstring(1, 'itnbr')

OpenWithParm(w_pdm_01285, sItnbr)


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\기술내역_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\기술내역_up.gif"
end event

type p_copy from uo_picture within w_pdm_01290
boolean visible = false
integer x = 3488
integer y = 16
integer width = 178
boolean bringtotop = true
boolean enabled = false
string picturename = "C:\erpman\image\복사_up.gif"
end type

event clicked;call super::clicked;//string sitnbr
//
//sitnbr = dw_insert.getitemstring(1, "itnbr")
//
//setnull(gs_code)
//setnull(gs_codename)
//setnull(gs_gubun)
//
//open(w_itemas_popup)
//
//if isnull(gs_code) or trim(gs_code) = '' then return
//
//if Messagebox("복사확인", gs_codename + " 에 대한 자료를 복사하시겠읍니까?", &
//								  question!, yesno!) = 2 then return
//								  
//Update Itemas a
//   Set a.empno   = (select empno      from itemas where itnbr = :gs_code),
//		 a.unmsr   = (select unmsr      from itemas where itnbr = :gs_code),
//		 a.waght   = (select waght      from itemas where itnbr = :gs_code),
//		 a.filsk   = (select filsk      from itemas where itnbr = :gs_code),
//		 a.accod   = (select accod      from itemas where itnbr = :gs_code),
//		 a.abcgb   = (select abcgb      from itemas where itnbr = :gs_code),
//		 a.itgu    = (select itgu       from itemas where itnbr = :gs_code),
//		 a.hsno    = (select hsno       from itemas where itnbr = :gs_code),
//		 a.silsu   = (select silsu      from itemas where itnbr = :gs_code),
//		 a.estdate = (select estdate    from itemas where itnbr = :gs_code),
//		 a.prpgub  = (select prpgub     from itemas where itnbr = :gs_code),
//		 a.pumsr   = (select pumsr      from itemas where itnbr = :gs_code),
//		 a.cnvfat  = (select cnvfat     from itemas where itnbr = :gs_code),
//		 a.yebi3   = (select yebi3      from itemas where itnbr = :gs_code),
//		 a.holdyn  = (select holdyn     from itemas where itnbr = :gs_code),
//		 a.wonprc  = (select wonprc     from itemas where itnbr = :gs_code),
//		 a.forprc  = (select forprc     from itemas where itnbr = :gs_code),  
// 		 a.forpun  = (select forpun     from itemas where itnbr = :gs_code),  
// 		 a.wonsrc  = (select wonsrc     from itemas where itnbr = :gs_code),  
// 		 a.forsrc  = (select forsrc     from itemas where itnbr = :gs_code),  
// 		 a.forsun  = (select forsun     from itemas where itnbr = :gs_code),  
//		 a.mlicd   = (select mlicd      from itemas where itnbr = :gs_code),  
// 		 a.ldtim2  = (select ldtim2     from itemas where itnbr = :gs_code),  
// 		 a.ldtim   = (select ldtim      from itemas where itnbr = :gs_code),  
// 		 a.baseqty = (select baseqty    from itemas where itnbr = :gs_code),  
// 		 a.shrat   = (select shrat      from itemas where itnbr = :gs_code),  
//		 a.lot     = (select lot        from itemas where itnbr = :gs_code),  
// 		 a.minqt   = (select minqt      from itemas where itnbr = :gs_code),  
// 		 a.mulqt   = (select mulqt      from itemas where itnbr = :gs_code),  
// 		 a.maxqt   = (select maxqt      from itemas where itnbr = :gs_code),  
// 		 a.packqty = (select packqty    from itemas where itnbr = :gs_code),  
//		 a.spec2   = (select spec2      from itemas where itnbr = :gs_code),  
// 		 a.jijil2  = (select jijil2     from itemas where itnbr = :gs_code)  
// Where a.itnbr   = :sItnbr;
// 
//if sqlca.sqlcode <> 0 then 
//	messagebox('확 인', '자료복사를 실패하였습니다.')
//	rollback;
//	return 
//end if
// 
//dw_insert.Retrieve(sitnbr)
//ls_gub = 'N'    //'N'이면 수정모드
//
//wf_all_retrieve(sitnbr)
//dw_insert.setfocus()
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\복사_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\복사_up.gif"
end event

type dw_saupj from datawindow within w_pdm_01290
boolean visible = false
integer x = 443
integer y = 76
integer width = 261
integer height = 84
integer taborder = 11
boolean bringtotop = true
string title = "none"
string dataobject = "d_pdm_01290_2"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_pdm_01290
integer x = 2949
integer y = 32
integer width = 535
integer height = 112
integer taborder = 11
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "제조공정도 보기"
end type

event clicked;//STRING SITNBR
//
//IF dw_insert.accepttext() = -1 THEN RETURN 
//
//sItnbr = dw_insert.getitemstring(1, 'itnbr')
//
//OpenWithParm(w_pdm_01280, sItnbr)

dw_insert.AcceptText()

String ls_itnbr

ls_itnbr = dw_insert.GetItemString(1, 'itnbr')
If Trim(ls_itnbr) = '' OR IsNull(ls_itnbr) Then
	MessageBox('품번확인', '품번을 확인 하십시오!')
	Return
End If

String ls_path

/* 파일서버 경로 가져오기 */
// 경로 지정 방식 변경 BY SHJEON 20121205
select dataname into :ls_path from syscnfg
 where sysgu = 'C' and serial = 12 and lineno = '4' ;

//ls_path = '\\10.206.21.101\public\생산팀\제조공정도(erp_up_용)\MIP생산\' + ls_itnbr + '.xls'
st_3.Text = ls_path + ls_itnbr + '.xls'

String ls_reg

Long   ll_rtn

ll_rtn = RegistryGet('HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Excel.XLL\shell\Open\command\', '', RegString!, ls_reg)
If ll_rtn < 0 Then
	MessageBox('엑셀 프로그램 확인', 'Excel Program이 정상적으로 설치 되었는지 확인 하십시오.')
	Return
End If

Run(ls_reg + 'Excel.EXE /r' + ' ' + ls_path, Maximized!)



end event

type st_3 from statictext within w_pdm_01290
integer x = 238
integer y = 44
integer width = 2702
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean focusrectangle = false
end type

