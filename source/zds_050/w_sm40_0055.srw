$PBExportHeader$w_sm40_0055.srw
$PBExportComments$납품검수 등록(VAN - GM/DAT)
forward
global type w_sm40_0055 from w_inherite
end type
type dw_1 from u_key_enter within w_sm40_0055
end type
type rr_1 from roundrectangle within w_sm40_0055
end type
type cbx_1 from checkbox within w_sm40_0055
end type
type pb_1 from u_pb_cal within w_sm40_0055
end type
type pb_2 from u_pb_cal within w_sm40_0055
end type
type dw_gumsu from datawindow within w_sm40_0055
end type
type dw_2 from datawindow within w_sm40_0055
end type
type st_2 from statictext within w_sm40_0055
end type
type rr_2 from roundrectangle within w_sm40_0055
end type
type p_1 from uo_picture within w_sm40_0055
end type
type p_2 from uo_picture within w_sm40_0055
end type
type dw_3 from datawindow within w_sm40_0055
end type
type st_3 from statictext within w_sm40_0055
end type
type dw_imsi from datawindow within w_sm40_0055
end type
end forward

global type w_sm40_0055 from w_inherite
integer height = 2528
string title = " 납품검수 등록(VAN - GM/DAT)"
dw_1 dw_1
rr_1 rr_1
cbx_1 cbx_1
pb_1 pb_1
pb_2 pb_2
dw_gumsu dw_gumsu
dw_2 dw_2
st_2 st_2
rr_2 rr_2
p_1 p_1
p_2 p_2
dw_3 dw_3
st_3 st_3
dw_imsi dw_imsi
end type
global w_sm40_0055 w_sm40_0055

forward prototypes
public function integer wf_danga (integer nrow)
public function integer wf_require_chk (string ar_dataobject)
public subroutine wf_filter2 ()
public subroutine wf_filter1 ()
public function string wf_itdsc (string arg_itnbr)
public function integer wf_geomsu_create (string arg_cvcod)
end prototypes

public function integer wf_danga (integer nrow);String sToday, sCvcod, sItnbr, sSpec
Double dItemPrice, dDcRate
Int    iRtnValue
String ls_curr ='WON' , ls_factory ;

sToday = f_today()

sCvcod = dw_insert.GetItemString(nRow, 'cvcod')
sItnbr = dw_insert.GetItemString(nRow, 'itnbr')
sSpec  = '.'


ls_factory = dw_insert.GetItemString(nRow, 'facgbn')
//If mid(ls_factory,1,1) = 'Y' or  mid(ls_factory,1,1) = 'Z'  Then    // 수출여부는 금액별도로 관리. 
//	dItemPrice = sqlca.FUN_ERP100000012_1_DDS(sToday ,  sItnbr , sSpec,  sCvcod , '2',  ls_curr )
//Else
//	dItemPrice = sqlca.FUN_ERP100000012_1_DDS(sToday ,  sItnbr , sSpec , sCvcod , '1',  ls_curr )
//End If
		   


iRtnValue  = sqlca.Fun_Erp100000016(gs_sabu,  sToday, sCvcod, sItnbr, sSpec, 'WON','1', dItemPrice, dDcRate)
If IsNull(dItemPrice) Then dItemPrice = 0

dw_insert.SetItem(nRow, 'itm_prc', dItemPrice)

return 1
end function

public function integer wf_require_chk (string ar_dataobject);
Return 1

	
end function

public subroutine wf_filter2 ();If dw_1.AcceptText() < 1 Then Return
If dw_3.AcceptText() < 1 Then Return

String ls_gubun1 , ls_gubun2 , ls_gubun3
String ls_str1 , ls_str2

ls_gubun3 = Trim(dw_3.Object.gubun[1])

If ls_gubun3 = '%' Then
	ls_str2 = ''
Else
	ls_str2 = "yebi1_temp = '"+ls_gubun3+"' "
End iF

If dw_insert.RowCount() > 0 Then 
	
	dw_insert.SetFilter(ls_str2)
	dw_insert.Filter()
	dw_insert.SetFilter("")

End If

end subroutine

public subroutine wf_filter1 ();If dw_1.AcceptText() < 1 Then Return
If dw_2.AcceptText() < 1 Then Return

String ls_gubun1 , ls_gubun2 , ls_gubun3
String ls_str1 , ls_str2

ls_gubun2 = Trim(dw_2.Object.gubun[1])

If ls_gubun2 = '%' Then
	ls_str1 = ""
Else
	ls_str1 = "citnbr = '"+ls_gubun2+"' "
End iF

If dw_gumsu.RowCount() > 0 Then 
	
	dw_gumsu.SetFilter(ls_str1)
	dw_gumsu.Filter()
	dw_gumsu.SetFilter("")

End If


	
end subroutine

public function string wf_itdsc (string arg_itnbr);string ls_itdsc, ls_ispec, ls_jijil, ls_null

SetNull(ls_null)
	
		SELECT A.ITDSC , 
		       A.ISPEC ,
		       A.JIJIL
		  INTO :ls_itdsc, 
		       :ls_ispec, 		     
		       :ls_jijil
		  FROM ITEMAS A 
		 WHERE A.ITNBR = :arg_itnbr
		   AND A.USEYN = 0 ;
		
		IF SQLCA.SQLCODE <> 0 THEN
			f_message_chk(33,'[품번]')
			Return ls_null
		END IF

return ls_itdsc
		

end function

public function integer wf_geomsu_create (string arg_cvcod);
string ls_GUBUN,ls_DOCCODE,ls_CUSTCD,ls_FACTORY,ls_VAN_ITNBR,ls_IPNO,ls_IPCHKNO,ls_IP_DATE,ls_BAL_NO,ls_MITNBR,ls_MCVCOD
string ls_ITDSC,ls_ISPEC
double ld_IPDAN,ld_IPQTY,ld_IPAMT,ld_PACKDAN
int 	 li_rowcnt,li_rowcnt_imsi

string ls_sabu,ls_iojpno,ls_iogbn,ls_sudat,ls_itnbr,ls_pspec,ls_opseq,ls_depot_no,ls_sarea,ls_pdtgu,ls_cust_no
double ld_ioqty,ld_ioprc,ld_ioamt,ld_ioreqty,ld_iofaqty,ld_iopeqty,ld_iospqty,ld_iocdqty,ld_iosuqty,ld_dcrate,ld_prvprc
double ld_aftprc,ld_silqty,ld_silamt,ld_tukqty,ld_dyebi1,ld_dyebi2,ld_dyebi3,ld_cnvfat,ld_cnviore,ld_cnviofa,ld_cnviope
double ld_cnviosp,ld_cnviocd,ld_cnviosu,ld_gongqty,ld_gongprc
string ls_insdat,ls_insemp,ls_qcgub,ls_io_confirm,ls_io_date,ls_io_empno,ls_lotsno,ls_loteno,ls_hold_no
int    li_inv_seq,li_balseq,li_poblsq
long   ll_mayysq,ll_ipseq,ll_subseq
string ls_order_no,ls_inv_no,ls_filsk,ls_baljpno,ls_polcno,ls_poblno,ls_bigo,ls_botimh,ls_ip_jpno,ls_itgu,ls_sicdat,ls_cvnas2
string ls_mayymm,ls_inpcnf,ls_jakjino,ls_jaksino,ls_jnpcrt,ls_outchk,ls_ioredept,ls_ioreemp,ls_juksdat,ls_jukedat,ls_gurdat
string ls_tukdat,ls_tukemp,ls_tuksudat,ls_crt_date,ls_crt_time,ls_crt_user,ls_upd_date,ls_upd_time,ls_upd_user,ls_checkno
string ls_pjt_cd,ls_field_cd,ls_area_cd,ls_yebi1,ls_yebi2,ls_yebi3,ls_yebi4,ls_cnvart,ls_saupj,ls_ipsource
int    li_read_cnt,li_write_cnt
boolean lb_check_gubun,lb_exit_chk_current
string ls_imsi_mcvcod,ls_imsi_mitnbr,ls_imsi_IP_DATE,ls_geomsu_date
double ld_IMSI_IPDAN,ld_pacprc,ld_imsi_packdan

pointer oldpointer

oldpointer = SetPointer(HourGlass!)


//CURSOR DELARE
DECLARE CUR_GUMSU CURSOR FOR
	SELECT A.GUBUN ,  A.CUSTCD, A.FACTORY, A.ITNBR, 
	       A.IPNO,    A.IP_DATE,A.IP_QTY,  A.IP_DAN,  A.BAL_NO,
			 A.MITNBR,  B.ITDSC,  B.ISPEC,   A.MCVCOD
			 
	FROM (
		SELECT 'G' GUBUN,  CUSTCD, FACTORY, ITNBR, 
		           IPNO,   IP_DATE, IP_QTY,   IP_DAN,  BAL_NO,
					  MITNBR, MCVCOD
		FROM VAN_GM19
		WHERE SABU   = 	:gs_sabu AND
				MCVCOD like :arg_cvcod
		) A, ITEMAS B
	WHERE B.ITNBR = A.MITNBR
	ORDER BY A.MCVCOD,A.MITNBR,A.BAL_NO,A.IP_DATE;

/* 서열 검수용 */
DECLARE CUR_GUMSU_SUB CURSOR FOR
	SELECT a.sabu,      a.iojpno,     a.iogbn,     a.sudat,
	       a.itnbr,     a.pspec,      a.opseq,     a.depot_no,
			 fun_get_cvnas(a.cvcod) cvnas2 ,a.sarea,a.pdtgu,a.cust_no,
			 a.ioqty,     a.ioprc,      a.ioamt,     a.ioreqty,
			 a.insdat,    a.insemp,     a.qcgub,     a.iofaqty,
			 a.iopeqty,   a.iospqty,    a.iocdqty,   a.iosuqty,
			 a.io_confirm,a.io_date,    a.io_empno,  a.lotsno,
			 a.loteno,    a.hold_no,	 a.order_no,  a.inv_no,
			 a.inv_seq,   a.filsk,      a.baljpno,   a.balseq,
			 a.polcno,    a.poblno,     a.poblsq,    a.bigo,
			 a.botimh,    a.ip_jpno,    a.itgu,      a.sicdat,
			 a.mayymm,	  a.inpcnf,     a.jakjino,   a.jaksino,
			 a.jnpcrt,    a.outchk,     a.mayysq,    a.ioredept,
			 a.ioreemp,   a.dcrate,     a.juksdat,   a.jukedat,
			 a.prvprc,    a.aftprc,     a.silqty,	  a.silamt,
			 a.gurdat,    a.tukdat,     a.tukemp,    a.tukqty,
			 a.tuksudat,  a.crt_date,   a.crt_time,  a.crt_user,
			 a.upd_date,  a.upd_time,   a.upd_user,  a.checkno,
			 a.pjt_cd,    a.field_cd,   a.area_cd,   a.yebi1,
			 a.yebi2,     a.yebi3,      a.yebi4,     a.dyebi1,
			 a.dyebi2,    a.dyebi3,     a.cnvfat,    a.cnvart,
			 a.cnviore,   a.cnviofa,    a.cnviope,   a.cnviosp,
			 a.cnviocd,   a.cnviosu,    a.gongqty,   a.gongprc,
			 a.saupj,     a.pacprc
	FROM (
		SELECT M.sabu sabu,   iojpno,     iogbn,    sudat,         
		       M.itnbr itnbr, pspec,      opseq,    M.depot_no depot_no,
				 M.cvcod cvcod, sarea,		 pdtgu,    M.cust_no cust_no,  
				 ioqty,			 ioprc,      ioamt,    ioreqty,            
				 insdat,			 insemp,     qcgub,    iofaqty,
				 iopeqty,       iospqty,    iocdqty,  iosuqty,
				 io_confirm,    io_date,    io_empno, lotsno,
				 loteno,        hold_no,	 M.order_no order_no, inv_no,
				 inv_seq,       filsk,      baljpno,  balseq,
				 polcno,        poblno,     poblsq,   bigo,
				 botimh,        ip_jpno,    itgu,     sicdat,
				 mayymm,			 inpcnf,     jakjino,  jaksino,
				 jnpcrt,        outchk,     mayysq,   ioredept,
				 ioreemp,       dcrate,     juksdat,  jukedat, 
				 prvprc,        aftprc,     silqty,	  silamt,
				 gurdat,        tukdat,     tukemp,   tukqty,
				 tuksudat,      M.crt_date, M.crt_time crt_time,
				 M.crt_user crt_user,M.upd_date upd_date,M.upd_time upd_time,
				 M.upd_user upd_user,checkno, pjt_cd,  field_cd,
				 area_cd,       yebi1,      yebi2,     yebi3,
				 yebi4,         dyebi1,     dyebi2,    dyebi3,
				 cnvfat,        cnvart,     cnviore,   cnviofa,
				 cnviope,		 cnviosp,    cnviocd,   cnviosu,
				 gongqty,       gongprc,    M.saupj saupj,pacprc
		FROM IMHIST M , SORDER S
		WHERE M.SABU = :gs_sabu AND
				S.SABU = :gs_sabu AND
				S.ORDER_NO = M.ORDER_NO AND
				M.LOTSNO  IS NULL AND
				M.IO_DATE IS NOT NULL AND 
				M.CVCOD = :ls_imsi_mcvcod AND
				M.ITNBR = :ls_imsi_MITNBR AND
				NVL(YEBI1,'.') = '.' AND
				NVL(CHECKNO,'.') = '.' 
		UNION ALL
		SELECT sabu,       iojpno,          	iogbn,          	sudat,
		       itnbr,        pspec,           	opseq,				depot_no,
				 cvcod,			sarea,				pdtgu,				cust_no,
				 ioqty,			ioprc,				ioamt,				ioreqty,
				 insdat,		 	insemp,				qcgub,				iofaqty,
				 iopeqty,		iospqty,				iocdqty,     		iosuqty,
				 io_confirm,	io_date,				io_empno,			lotsno,
				 loteno,			hold_no,				order_no,			inv_no,
				 inv_seq,		filsk,				baljpno,				balseq,
				 polcno,			poblno,				poblsq,				bigo,
				 botimh,			ip_jpno,				itgu,					sicdat,
				 mayymm,		 	inpcnf,				jakjino,				jaksino,
				 jnpcrt,			outchk,				mayysq,				ioredept,
				 ioreemp,		dcrate,				juksdat,				jukedat,
				 prvprc,			aftprc,				silqty,			 	silamt,
				 gurdat,			tukdat,				tukemp,				tukqty,
				 tuksudat,		crt_date,			crt_time,			crt_user,
				 upd_date,		upd_time,			upd_user,			checkno,
				 pjt_cd,			field_cd,			area_cd,				yebi1,
				 yebi2,			yebi3,				yebi4,				dyebi1,
				 dyebi2,			dyebi3,				cnvfat,				cnvart,
				 cnviore,		cnviofa,				cnviope,			 	cnviosp,
				 cnviocd,		cnviosu,				gongqty,				gongprc,
				 saupj,			pacprc
		FROM IMHIST
		WHERE IMHIST.SABU = :gs_sabu AND
				IMHIST.LOTSNO  IS NULL AND
				IMHIST.IO_DATE IS NOT NULL AND 
				IMHIST.CVCOD = :ls_imsi_mcvcod AND
				IMHIST.ITNBR = :ls_imsi_MITNBR AND
				NVL(YEBI1,'.') = '.' AND
				NVL(CHECKNO,'.') = '.' ) a
	ORDER BY a.CVCOD,a.ITNBR,a.io_date,a.IOQTY DESC ;

		
OPEN CUR_GUMSU;

FETCH CUR_GUMSU INTO :ls_GUBUN, 	:ls_CUSTCD,		:ls_FACTORY,	:ls_VAN_ITNBR,
							:ls_IPNO,	:ls_IP_DATE,	:ld_IPQTY,		:ld_IPDAN,	:ls_BAL_NO,
							:ls_MITNBR,	:ls_ITDSC,		:ls_ISPEC,		:ls_mcvcod;

boolean lb_exit_chk_depth, lb_con_chk
double ld_tot_ipqty

lb_exit_chk_depth = TRUE
lb_con_chk =FALSE

DO WHILE SQLCA.SQLCODE = 0 
	//read count
	li_read_cnt += 1
	//발주번호가 있지만 서열납품일 경우 체크값(ls_check_gubun := TRUE)
	lb_check_gubun = FALSE

	lb_exit_chk_depth = TRUE

	// 출하자료(서열납품이 아닌것)의 입출고이력 읽어오기
	IF not isnull(ls_BAL_NO) and trim(ls_BAL_NO) <> '' then
		SELECT imhist.sabu,iojpno,iogbn,sudat,IMHIST.itnbr,pspec,opseq,IMHIST.depot_no,fun_get_cvnas(IMHIST.cvcod) cvnas2,sarea,pdtgu,IMHIST.cust_no,ioqty,ioprc,ioamt,ioreqty,insdat,
				 insemp,qcgub,iofaqty,iopeqty,iospqty,iocdqty,iosuqty,io_confirm,io_date,io_empno,lotsno,loteno,hold_no,
             IMHIST.order_no,inv_no,inv_seq,filsk,baljpno,balseq,polcno,poblno,poblsq,bigo,botimh,ip_jpno,itgu,sicdat,mayymm,
				 inpcnf,jakjino,jaksino,jnpcrt,outchk,mayysq,ioredept,ioreemp,dcrate,juksdat,jukedat,prvprc,aftprc,silqty,
				 silamt,gurdat,tukdat,tukemp,tukqty,tuksudat,IMHIST.crt_date,IMHIST.crt_time,IMHIST.crt_user,IMHIST.upd_date,IMHIST.upd_time,IMHIST.upd_user,checkno,
				 pjt_cd,field_cd,area_cd,yebi1,yebi2,yebi3,yebi4,dyebi1,dyebi2,dyebi3,cnvfat,cnvart,cnviore,cnviofa,cnviope,
				 cnviosp,cnviocd,cnviosu,gongqty,gongprc,IMHIST.saupj,pacprc
		INTO   :ls_sabu,:ls_iojpno,:ls_iogbn,:ls_sudat,:ls_itnbr,:ls_pspec,:ls_opseq,:ls_depot_no,:ls_cvnas2,:ls_sarea,:ls_pdtgu,:ls_cust_no,:ld_ioqty,:ld_ioprc,:ld_ioamt,:ld_ioreqty,:ls_insdat,
				 :ls_insemp,:ls_qcgub,:ld_iofaqty,:ld_iopeqty,:ld_iospqty,:ld_iocdqty,:ld_iosuqty,:ls_io_confirm,:ls_io_date,:ls_io_empno,:ls_lotsno,:ls_loteno,:ls_hold_no,
             :ls_order_no,:ls_inv_no,:li_inv_seq,:ls_filsk,:ls_baljpno,:li_balseq,:ls_polcno,:ls_poblno,:li_poblsq,:ls_bigo,:ls_botimh,:ls_ip_jpno,:ls_itgu,:ls_sicdat,:ls_mayymm,
				 :ls_inpcnf,:ls_jakjino,:ls_jaksino,:ls_jnpcrt,:ls_outchk,:ll_mayysq,:ls_ioredept,:ls_ioreemp,:ld_dcrate,:ls_juksdat,:ls_jukedat,:ld_prvprc,:ld_aftprc,:ld_silqty,
				 :ld_silamt,:ls_gurdat,:ls_tukdat,:ls_tukemp,:ld_tukqty,:ls_tuksudat,:ls_crt_date,:ls_crt_time,:ls_crt_user,:ls_upd_date,:ls_upd_time,:ls_upd_user,:ls_checkno,
				 :ls_pjt_cd,:ls_field_cd,:ls_area_cd,:ls_yebi1,:ls_yebi2,:ls_yebi3,:ls_yebi4,:ld_dyebi1,:ld_dyebi2,:ld_dyebi3,:ld_cnvfat,:ls_cnvart,:ld_cnviore,:ld_cnviofa,:ld_cnviope,
				 :ld_cnviosp,:ld_cnviocd,:ld_cnviosu,:ld_gongqty,:ld_gongprc,:ls_saupj,:ld_pacprc
		FROM IMHIST
		WHERE SABU 			= :gs_sabu AND
				LOTSNO 		= :ls_BAL_NO AND
				CVCOD 		= :ls_mcvcod AND
				ITNBR 		= :ls_MITNBR AND
				NVL(YEBI1,'.') = '.' AND
				NVL(CHECKNO,'.') = '.' AND
				IO_DATE IS NOT NULL 
		ORDER BY CVNAS2,ITNBR,io_date;
		IF SQLCA.SQLCODE <> 0 THEN
			lb_check_gubun = TRUE
		ELSE
			li_rowcnt = dw_insert.insertrow(0)
			//거래처명 DISPLAY
			dw_insert.setitem(li_rowcnt,'vndmst_cvnas2',ls_cvnas2)
			//품번
//			dw_insert.setitem(li_rowcnt,'itnbr',ls_mitnbr)
			dw_insert.setitem(li_rowcnt,'itemas_itdsc',ls_itdsc)
			dw_insert.setitem(li_rowcnt,'itemas_ispec',ls_ispec)
			//출하일자
			dw_insert.setitem(li_rowcnt,'io_date',ls_io_date)
			dw_insert.setitem(li_rowcnt,'chdate',ls_io_date)
			//출하수량
			dw_insert.setitem(li_rowcnt,'ioqty',ld_ioqty)
			//납품일자
			dw_insert.setitem(li_rowcnt,'IP_DATE',ls_IP_DATE)
			
			//현재값을 임시 dw에 저장
			li_rowcnt_imsi = dw_imsi.insertrow(0)
			dw_imsi.setitem(li_rowcnt_imsi,'imsi_gubun',ls_gubun)
			dw_imsi.setitem(li_rowcnt_imsi,'imsi_doccode',ls_doccode)
			dw_imsi.setitem(li_rowcnt_imsi,'imsi_custcd',ls_custcd)
			dw_imsi.setitem(li_rowcnt_imsi,'imsi_factory',ls_factory)
			dw_imsi.setitem(li_rowcnt_imsi,'imsi_van_itnbr',ls_van_itnbr)
			dw_imsi.setitem(li_rowcnt_imsi,'imsi_ipno',ls_ipno)
			dw_imsi.setitem(li_rowcnt_imsi,'imsi_BAL_NO',ls_BAL_NO)

			//입고단가
			IF not isnull(ld_IPDAN) and ld_IPDAN > 0 then
				dw_insert.setitem(li_rowcnt,'ioprc'       ,ld_IPDAN)
			ELSE
				dw_insert.setitem(li_rowcnt,'ioprc'       ,ld_ioprc)
			END IF
			//포장단가 
			IF not isnull(ld_packdan) and ld_packdan > 0 then
				dw_insert.setitem(li_rowcnt,'pacprc',ld_PACKDAN)
			ELSE
				dw_insert.setitem(li_rowcnt,'pacprc',ld_pacprc)
			END IF
			//납품수량 체크
			if ld_ioqty < ld_IPQTY then
				//납품수량
				dw_insert.setitem(li_rowcnt,'choiceqty',ld_IPQTY - ld_ioqty)
				//합격수량
				dw_insert.setitem(li_rowcnt,'iosuqty',ld_IPQTY - ld_ioqty)
				//수불금액
				dw_insert.setitem(li_rowcnt,'ioamt',(ld_IPQTY - ld_ioqty) * dw_insert.getitemnumber(li_rowcnt,'ioprc'))
				//오버되는 검수수량 값을 van_gm19에 저장하기 위해 저장한다.
				dw_imsi.setitem(li_rowcnt_imsi,'imsi_chuga_su',ld_IPQTY - ld_ioqty)
				dw_imsi.setitem(li_rowcnt_imsi,'imsi_ipdan',ld_IPDAN)
				dw_imsi.setitem(li_rowcnt_imsi,'imsi_packdan',ld_PACKDAN)

				dw_insert.setitem(li_rowcnt,'chuga_su',ld_IPQTY - ld_ioqty)
			else
				//납품수량
				dw_insert.setitem(li_rowcnt,'choiceqty',ld_IPQTY)
				//합격수량
				dw_insert.setitem(li_rowcnt,'iosuqty',ld_IPQTY)
				//수불금액
				dw_insert.setitem(li_rowcnt,'ioamt',ld_ipqty * dw_insert.getitemnumber(li_rowcnt,'ioprc'))
			end if
			
			//검수일자
			dw_insert.setitem(li_rowcnt,'gdate',ls_IP_DATE)
			//van 발주번호 표시
			dw_insert.setitem(li_rowcnt,'LOTSNO',ls_BAL_NO)
			//van 체크자료 
			dw_insert.setitem(li_rowcnt,'LOTENO',ls_ipno)
			
			//기존자료(imhist)
			dw_insert.setitem(li_rowcnt,'sabu'        ,ls_sabu)
			dw_insert.setitem(li_rowcnt,'iojpno'      ,ls_iojpno)
			dw_insert.setitem(li_rowcnt,'iogbn'       ,ls_iogbn)
			dw_insert.setitem(li_rowcnt,'sudat'       ,ls_sudat)
			dw_insert.setitem(li_rowcnt,'itnbr'       ,ls_itnbr)
			dw_insert.setitem(li_rowcnt,'pspec'       ,ls_pspec)
			dw_insert.setitem(li_rowcnt,'opseq'       ,ls_opseq)
			dw_insert.setitem(li_rowcnt,'depot_no'    ,ls_depot_no)
			dw_insert.setitem(li_rowcnt,'cvcod'       ,ls_mcvcod)
			dw_insert.setitem(li_rowcnt,'sarea'       ,ls_sarea)
			dw_insert.setitem(li_rowcnt,'pdtgu'       ,ls_pdtgu)
			dw_insert.setitem(li_rowcnt,'cust_no'     ,ls_cust_no)
			dw_insert.setitem(li_rowcnt,'ioreqty'     ,ld_ioreqty)
			dw_insert.setitem(li_rowcnt,'insdat'      ,ls_insdat)
			dw_insert.setitem(li_rowcnt,'insemp'      ,ls_insemp)
			dw_insert.setitem(li_rowcnt,'qcgub'       ,ls_qcgub)
			dw_insert.setitem(li_rowcnt,'iofaqty'     ,ld_iofaqty)
			dw_insert.setitem(li_rowcnt,'iopeqty'     ,ld_iopeqty)
			dw_insert.setitem(li_rowcnt,'iospqty'     ,ld_iospqty)
			dw_insert.setitem(li_rowcnt,'iocdqty'     ,ld_iocdqty)
			dw_insert.setitem(li_rowcnt,'iosuqty'     ,ld_iosuqty)
			dw_insert.setitem(li_rowcnt,'io_confirm'  ,ls_io_confirm)
			dw_insert.setitem(li_rowcnt,'io_empno'    ,ls_io_empno)
//------- VAN 발주번호, 입고번호입력			
//			dw_insert.setitem(li_rowcnt,'lotsno'      ,ls_lotsno)
//			dw_insert.setitem(li_rowcnt,'loteno'      ,ls_loteno)
			dw_insert.setitem(li_rowcnt,'hold_no'     ,ls_hold_no)
			dw_insert.setitem(li_rowcnt,'order_no'    ,ls_order_no)
			dw_insert.setitem(li_rowcnt,'inv_no'      ,ls_inv_no)
			dw_insert.setitem(li_rowcnt,'inv_seq'     ,li_inv_seq)
			dw_insert.setitem(li_rowcnt,'filsk'       ,ls_filsk)
			dw_insert.setitem(li_rowcnt,'baljpno'     ,ls_baljpno)
			dw_insert.setitem(li_rowcnt,'balseq'      ,li_balseq)
			dw_insert.setitem(li_rowcnt,'polcno'      ,ls_polcno)
			dw_insert.setitem(li_rowcnt,'poblno'      ,ls_poblno)
			dw_insert.setitem(li_rowcnt,'poblsq'      ,li_poblsq)
			dw_insert.setitem(li_rowcnt,'bigo'        ,ls_bigo)
			dw_insert.setitem(li_rowcnt,'botimh'      ,ls_botimh)
			dw_insert.setitem(li_rowcnt,'ip_jpno'     ,ls_ip_jpno)
			dw_insert.setitem(li_rowcnt,'itgu'        ,ls_itgu)
			dw_insert.setitem(li_rowcnt,'sicdat'      ,ls_sicdat)
			dw_insert.setitem(li_rowcnt,'mayymm'      ,ls_mayymm)
			dw_insert.setitem(li_rowcnt,'inpcnf'      ,ls_inpcnf)
			dw_insert.setitem(li_rowcnt,'jakjino'     ,ls_jakjino)
			dw_insert.setitem(li_rowcnt,'jaksino'     ,ls_jaksino)
			dw_insert.setitem(li_rowcnt,'jnpcrt'      ,ls_jnpcrt)
			dw_insert.setitem(li_rowcnt,'outchk'      ,ls_outchk)
			dw_insert.setitem(li_rowcnt,'mayysq'      ,ll_mayysq)
			dw_insert.setitem(li_rowcnt,'ioredept'    ,ls_ioredept)
			dw_insert.setitem(li_rowcnt,'ioreemp'     ,ls_ioreemp)
			dw_insert.setitem(li_rowcnt,'dcrate'      ,ld_dcrate)
			dw_insert.setitem(li_rowcnt,'juksdat'     ,ls_juksdat)
			dw_insert.setitem(li_rowcnt,'jukedat'     ,ls_jukedat)
			dw_insert.setitem(li_rowcnt,'prvprc'      ,ld_prvprc)
			dw_insert.setitem(li_rowcnt,'aftprc'      ,ld_aftprc)
			dw_insert.setitem(li_rowcnt,'silqty'      ,ld_silqty)
			dw_insert.setitem(li_rowcnt,'silamt'      ,ld_silamt)
			dw_insert.setitem(li_rowcnt,'gurdat'      ,ls_gurdat)
			dw_insert.setitem(li_rowcnt,'tukdat'      ,ls_tukdat)
			dw_insert.setitem(li_rowcnt,'tukemp'      ,ls_tukemp)
			dw_insert.setitem(li_rowcnt,'tukqty'      ,ld_tukqty)
			dw_insert.setitem(li_rowcnt,'tuksudat'    ,ls_tuksudat)
			dw_insert.setitem(li_rowcnt,'crt_date'    ,ls_crt_date)
			dw_insert.setitem(li_rowcnt,'crt_time'    ,ls_crt_time)
			dw_insert.setitem(li_rowcnt,'crt_user'    ,ls_crt_user)
			dw_insert.setitem(li_rowcnt,'upd_date'    ,ls_upd_date)
			dw_insert.setitem(li_rowcnt,'upd_time'    ,ls_upd_time)
			dw_insert.setitem(li_rowcnt,'upd_user'    ,ls_upd_user)
			dw_insert.setitem(li_rowcnt,'checkno'     ,ls_checkno)
			dw_insert.setitem(li_rowcnt,'pjt_cd'      ,ls_pjt_cd)
			dw_insert.setitem(li_rowcnt,'field_cd'    ,ls_field_cd)
			dw_insert.setitem(li_rowcnt,'area_cd'     ,ls_area_cd)
			dw_insert.setitem(li_rowcnt,'yebi1'       ,ls_yebi1)
			dw_insert.setitem(li_rowcnt,'yebi2'       ,ls_yebi2)
			dw_insert.setitem(li_rowcnt,'yebi3'       ,ls_yebi3)
			dw_insert.setitem(li_rowcnt,'yebi4'       ,ls_yebi4)
			dw_insert.setitem(li_rowcnt,'dyebi1'      ,ld_dyebi1)
			dw_insert.setitem(li_rowcnt,'dyebi2'      ,ld_dyebi2)
//			dw_insert.setitem(li_rowcnt,'dyebi3'      ,ld_dyebi3)
			dw_insert.setitem(li_rowcnt,'cnvfat'      ,ld_cnvfat)
			dw_insert.setitem(li_rowcnt,'cnvart'      ,ls_cnvart)
			dw_insert.setitem(li_rowcnt,'cnviore'     ,ld_cnviore)
			dw_insert.setitem(li_rowcnt,'cnviofa'     ,ld_cnviofa)
			dw_insert.setitem(li_rowcnt,'cnviope'     ,ld_cnviope)
			dw_insert.setitem(li_rowcnt,'cnviosp'     ,ld_cnviosp)
			dw_insert.setitem(li_rowcnt,'cnviocd'     ,ld_cnviocd)
			dw_insert.setitem(li_rowcnt,'cnviosu'     ,ld_cnviosu)
			dw_insert.setitem(li_rowcnt,'gongqty'     ,ld_gongqty)
			dw_insert.setitem(li_rowcnt,'gongprc'     ,ld_gongprc)
			dw_insert.setitem(li_rowcnt,'saupj'       ,ls_saupj)	
			dw_insert.setitem(li_rowcnt,'facgbn'      ,ls_factory)	
			dw_insert.setitem(li_rowcnt,'lclgbn'      ,ls_ipsource)	
		
			//상태값 변경
			dw_insert.SetItemStatus(li_rowcnt, 0,Primary!,DataModified!)

			dw_insert.scrolltorow(li_rowcnt)
			
			li_write_cnt += 1
		END IF
	END IF

	//서열납품에 대한 처리
	IF isnull(ls_BAL_NO) or trim(ls_BAL_NO) = '' or lb_check_gubun THEN
		//같은 자료를 취합하여 처리
		if li_read_cnt = 1 then
			ls_imsi_mcvcod = ls_mcvcod
			ls_imsi_mitnbr = ls_mitnbr
		end if

		// 입출고이력에 자료가 있는지 체크
		int li_imhist_cnt
		li_imhist_cnt = 0

		SELECT count(*)
		INTO :li_imhist_cnt
		from (
			SELECT imhist.itnbr 
			FROM IMHIST
			WHERE IMHIST.SABU = :gs_sabu AND
					IMHIST.LOTSNO  IS NULL AND
					IMHIST.IO_DATE IS NOT NULL AND 
					IMHIST.CVCOD = :ls_mcvcod AND
					IMHIST.ITNBR = :ls_MITNBR AND
					NVL(YEBI1,'.') = '.' AND
					NVL(CHECKNO,'.') = '.' 
					 ) a;
				
		if sqlca.sqlcode = 0 AND li_imhist_cnt > 0 then
			lb_con_chk = TRUE
		else
			lb_con_chk = FALSE
		end if
				
		IF lb_con_chk then
			if ls_imsi_mcvcod = ls_mcvcod and ls_imsi_mitnbr = ls_mitnbr then
				ld_tot_ipqty += ld_ipqty
				li_rowcnt_imsi = dw_imsi.insertrow(0)
				dw_imsi.setitem(li_rowcnt_imsi,'imsi_gubun',ls_gubun)
				dw_imsi.setitem(li_rowcnt_imsi,'imsi_custcd',ls_custcd)
				dw_imsi.setitem(li_rowcnt_imsi,'imsi_factory',ls_factory)
				dw_imsi.setitem(li_rowcnt_imsi,'imsi_van_itnbr',ls_van_itnbr)
				dw_imsi.setitem(li_rowcnt_imsi,'imsi_ipno',ls_ipno)
				dw_imsi.setitem(li_rowcnt_imsi,'imsi_BAL_NO',ls_BAL_NO)
			
				//입고단가
				if not isnull(ld_IPDAN) and   ld_IPDAN <> 0 then
					ld_IMSI_IPDAN = ld_IPDAN
				end IF
				//납품일자,검수일자
				if not isnull(ls_IP_DATE) and trim(ls_IP_DATE) <> '' then
					ls_imsi_IP_DATE = ls_IP_DATE
				else
					//납품일자가 없을 경우
					ls_imsi_IP_DATE = f_Today()
				end if
				//포장단가
				IF not isnull(ld_PACKDAN) and ld_PACKDAN = 0 THEN
					ld_imsi_packdan = ld_PACKDAN
				end if
			else
				OPEN CUR_GUMSU_SUB;
				FETCH CUR_GUMSU_SUB 
				 INTO :ls_sabu,		:ls_iojpno,		:ls_iogbn,		:ls_sudat,
				 		:ls_itnbr,		:ls_pspec,		:ls_opseq,		:ls_depot_no,
						:ls_cvnas2,		:ls_sarea,		:ls_pdtgu,		:ls_cust_no,
						:ld_ioqty,		:ld_ioprc,		:ld_ioamt,		:ld_ioreqty,
						:ls_insdat, 	:ls_insemp,		:ls_qcgub,		:ld_iofaqty,
						:ld_iopeqty,	:ld_iospqty,	:ld_iocdqty,	:ld_iosuqty,
						:ls_io_confirm,:ls_io_date,	:ls_io_empno,	:ls_lotsno,
						:ls_loteno,		:ls_hold_no, 	:ls_order_no,	:ls_inv_no,
						:li_inv_seq,	:ls_filsk,		:ls_baljpno,	:li_balseq,
						:ls_polcno,		:ls_poblno,		:li_poblsq,		:ls_bigo,
						:ls_botimh,		:ls_ip_jpno,	:ls_itgu,		:ls_sicdat,
						:ls_mayymm,	 	:ls_inpcnf,		:ls_jakjino,	:ls_jaksino,
						:ls_jnpcrt,		:ls_outchk,		:ll_mayysq,		:ls_ioredept,
						:ls_ioreemp,	:ld_dcrate,		:ls_juksdat,	:ls_jukedat,
						:ld_prvprc,		:ld_aftprc,		:ld_silqty,	 	:ld_silamt,
						:ls_gurdat,		:ls_tukdat,		:ls_tukemp,		:ld_tukqty,
						:ls_tuksudat,	:ls_crt_date,	:ls_crt_time,	:ls_crt_user,
						:ls_upd_date,	:ls_upd_time,	:ls_upd_user,	:ls_checkno,
						:ls_pjt_cd,		:ls_field_cd,	:ls_area_cd,	:ls_yebi1,
						:ls_yebi2,		:ls_yebi3,		:ls_yebi4,		:ld_dyebi1,
						:ld_dyebi2,		:ld_dyebi3,		:ld_cnvfat,		:ls_cnvart,
						:ld_cnviore,	:ld_cnviofa,	:ld_cnviope, 	:ld_cnviosp,
						:ld_cnviocd,	:ld_cnviosu,	:ld_gongqty,	:ld_gongprc,
						:ls_saupj,		:ld_pacprc;

				lb_exit_chk_current = TRUE
				li_rowcnt = 0				
				DO WHILE SQLCA.SQLCODE = 0 AND lb_exit_chk_depth
					li_rowcnt = dw_insert.insertrow(0)
					//입고단가
					IF not isnull(ld_IMSI_IPDAN) and ld_IMSI_IPDAN > 0 then
						dw_insert.setitem(li_rowcnt,'ioprc',ld_IMSI_IPDAN)
					ELSE
						dw_insert.setitem(li_rowcnt,'ioprc',ld_ioprc)
					END IF
					//수불수량이 납품수량보다 작을 경우 
					IF ld_ioqty < ld_tot_ipqty THEN
						dw_insert.setitem(li_rowcnt,'choiceqty',ld_ioqty)
						//합격수량
						dw_insert.setitem(li_rowcnt,'iosuqty',ld_ioqty)			
						//수불금액
						dw_insert.setitem(li_rowcnt,'ioamt',ld_ioqty * dw_insert.getitemnumber(li_rowcnt,'ioprc'))
						ld_tot_ipqty -= ld_ioqty
						lb_exit_chk_current = FALSE
					ELSEIF ld_ioqty = ld_tot_ipqty THEN
						dw_insert.setitem(li_rowcnt,'choiceqty',ld_tot_ipqty)
						//합격수량
						dw_insert.setitem(li_rowcnt,'iosuqty',ld_tot_ipqty)			
						//수불금액
						dw_insert.setitem(li_rowcnt,'ioamt',ld_tot_ipqty * dw_insert.getitemnumber(li_rowcnt,'ioprc'))
						ld_tot_ipqty -= ld_ioqty
						lb_exit_chk_depth = FALSE
					// 수불수량이 납품수량보다 클 경우
					ELSE
						dw_insert.setitem(li_rowcnt,'choiceqty',ld_tot_ipqty)
						//합격수량
						dw_insert.setitem(li_rowcnt,'iosuqty',ld_tot_ipqty)			
						//수불금액
						dw_insert.setitem(li_rowcnt,'ioamt',ld_tot_ipqty * dw_insert.getitemnumber(li_rowcnt,'ioprc'))
						lb_exit_chk_depth = FALSE
					END IF
					// write count
					li_write_cnt += 1
					
					//거래처명 DISPLAY
					dw_insert.setitem(li_rowcnt,'vndmst_cvnas2',ls_cvnas2)
					dw_insert.setitem(li_rowcnt,'itemas_itdsc',ls_itdsc)
					dw_insert.setitem(li_rowcnt,'itemas_ispec',ls_ispec)
					//출하일자
					dw_insert.setitem(li_rowcnt,'io_date',ls_io_date)
					dw_insert.setitem(li_rowcnt,'chdate',ls_io_date)
					//출하수량
					dw_insert.setitem(li_rowcnt,'ioqty',ld_ioqty)
					//납품일자
					dw_insert.setitem(li_rowcnt,'IP_DATE',ls_imsi_IP_DATE)
					//검수일자
					dw_insert.setitem(li_rowcnt,'gdate',ls_imsi_IP_DATE)
					//포장단가 
					dw_insert.setitem(li_rowcnt,'imhist_pacprc',ld_IMSI_PACKDAN)
					
					//van 발주번호 표시
					dw_insert.setitem(li_rowcnt,'LOTSNO',ls_BAL_NO)
					//van 체크자료 
					dw_insert.setitem(li_rowcnt,'LOTENO',ls_ipno)

					//현재값을 임시 dw에 저장
					li_rowcnt_imsi = dw_imsi.insertrow(0)
					dw_imsi.setitem(li_rowcnt_imsi,'imsi_gubun',ls_gubun)
					dw_imsi.setitem(li_rowcnt_imsi,'imsi_custcd',ls_custcd)
					dw_imsi.setitem(li_rowcnt_imsi,'imsi_factory',ls_factory)
					dw_imsi.setitem(li_rowcnt_imsi,'imsi_van_itnbr',ls_van_itnbr)
					dw_imsi.setitem(li_rowcnt_imsi,'imsi_ipno',ls_ipno)
					dw_imsi.setitem(li_rowcnt_imsi,'imsi_BAL_NO',ls_BAL_NO)

					//기존자료(imhist)
					dw_insert.setitem(li_rowcnt,'sabu'        ,ls_sabu)
					dw_insert.setitem(li_rowcnt,'iojpno'      ,ls_iojpno)
					dw_insert.setitem(li_rowcnt,'iogbn'       ,ls_iogbn)
					dw_insert.setitem(li_rowcnt,'sudat'       ,ls_sudat)
					dw_insert.setitem(li_rowcnt,'itnbr'       ,ls_itnbr)
					dw_insert.setitem(li_rowcnt,'pspec'       ,ls_pspec)
					dw_insert.setitem(li_rowcnt,'opseq'       ,ls_opseq)
					dw_insert.setitem(li_rowcnt,'depot_no'    ,ls_depot_no)
					dw_insert.setitem(li_rowcnt,'cvcod'       ,ls_mcvcod)
					dw_insert.setitem(li_rowcnt,'sarea'       ,ls_sarea)
					dw_insert.setitem(li_rowcnt,'pdtgu'       ,ls_pdtgu)
					dw_insert.setitem(li_rowcnt,'cust_no'     ,ls_cust_no)
					dw_insert.setitem(li_rowcnt,'insdat'      ,ls_insdat)
					dw_insert.setitem(li_rowcnt,'insemp'      ,ls_insemp)
					dw_insert.setitem(li_rowcnt,'qcgub'       ,ls_qcgub)
					dw_insert.setitem(li_rowcnt,'iofaqty'     ,ld_iofaqty)
					dw_insert.setitem(li_rowcnt,'iopeqty'     ,ld_iopeqty)
					dw_insert.setitem(li_rowcnt,'iospqty'     ,ld_iospqty)
					dw_insert.setitem(li_rowcnt,'iocdqty'     ,ld_iocdqty)
					dw_insert.setitem(li_rowcnt,'io_confirm'  ,ls_io_confirm)
					dw_insert.setitem(li_rowcnt,'io_empno'    ,ls_io_empno)
					//------- VAN 발주번호, 입고번호입력			
	//				dw_insert.setitem(li_rowcnt,'lotsno'      ,ls_lotsno)
	//				dw_insert.setitem(li_rowcnt,'loteno'      ,ls_loteno)
					dw_insert.setitem(li_rowcnt,'hold_no'     ,ls_hold_no)
					dw_insert.setitem(li_rowcnt,'order_no'    ,ls_order_no)
					dw_insert.setitem(li_rowcnt,'inv_no'      ,ls_inv_no)
					dw_insert.setitem(li_rowcnt,'inv_seq'     ,li_inv_seq)
					dw_insert.setitem(li_rowcnt,'filsk'       ,ls_filsk)
					dw_insert.setitem(li_rowcnt,'baljpno'     ,ls_baljpno)
					dw_insert.setitem(li_rowcnt,'balseq'      ,li_balseq)
					dw_insert.setitem(li_rowcnt,'polcno'      ,ls_polcno)
					dw_insert.setitem(li_rowcnt,'poblno'      ,ls_poblno)
					dw_insert.setitem(li_rowcnt,'poblsq'      ,li_poblsq)
					dw_insert.setitem(li_rowcnt,'bigo'        ,ls_bigo)
					dw_insert.setitem(li_rowcnt,'botimh'      ,ls_botimh)
					dw_insert.setitem(li_rowcnt,'ip_jpno'     ,ls_ip_jpno)
					dw_insert.setitem(li_rowcnt,'itgu'        ,ls_itgu)
					dw_insert.setitem(li_rowcnt,'sicdat'      ,ls_sicdat)
					dw_insert.setitem(li_rowcnt,'mayymm'      ,ls_mayymm)
					dw_insert.setitem(li_rowcnt,'inpcnf'      ,ls_inpcnf)
					dw_insert.setitem(li_rowcnt,'jakjino'     ,ls_jakjino)
					dw_insert.setitem(li_rowcnt,'jaksino'     ,ls_jaksino)
					dw_insert.setitem(li_rowcnt,'jnpcrt'      ,ls_jnpcrt)
					dw_insert.setitem(li_rowcnt,'outchk'      ,ls_outchk)
					dw_insert.setitem(li_rowcnt,'mayysq'      ,ll_mayysq)
					dw_insert.setitem(li_rowcnt,'ioredept'    ,ls_ioredept)
					dw_insert.setitem(li_rowcnt,'ioreemp'     ,ls_ioreemp)
					dw_insert.setitem(li_rowcnt,'dcrate'      ,ld_dcrate)
					dw_insert.setitem(li_rowcnt,'juksdat'     ,ls_juksdat)
					dw_insert.setitem(li_rowcnt,'jukedat'     ,ls_jukedat)
					dw_insert.setitem(li_rowcnt,'prvprc'      ,ld_prvprc)
					dw_insert.setitem(li_rowcnt,'aftprc'      ,ld_aftprc)
					dw_insert.setitem(li_rowcnt,'silqty'      ,ld_silqty)
					dw_insert.setitem(li_rowcnt,'silamt'      ,ld_silamt)
					dw_insert.setitem(li_rowcnt,'gurdat'      ,ls_gurdat)
					dw_insert.setitem(li_rowcnt,'tukdat'      ,ls_tukdat)
					dw_insert.setitem(li_rowcnt,'tukemp'      ,ls_tukemp)
					dw_insert.setitem(li_rowcnt,'tukqty'      ,ld_tukqty)
					dw_insert.setitem(li_rowcnt,'tuksudat'    ,ls_tuksudat)
					dw_insert.setitem(li_rowcnt,'upd_date'    ,ls_upd_date)
					dw_insert.setitem(li_rowcnt,'upd_time'    ,ls_upd_time)
					dw_insert.setitem(li_rowcnt,'upd_user'    ,ls_upd_user)
					dw_insert.setitem(li_rowcnt,'checkno'     ,ls_checkno)
					dw_insert.setitem(li_rowcnt,'pjt_cd'      ,ls_pjt_cd)
					dw_insert.setitem(li_rowcnt,'field_cd'    ,ls_field_cd)
					dw_insert.setitem(li_rowcnt,'area_cd'     ,ls_area_cd)
					dw_insert.setitem(li_rowcnt,'yebi1'       ,ls_yebi1)
					dw_insert.setitem(li_rowcnt,'yebi2'       ,ls_yebi2)
					dw_insert.setitem(li_rowcnt,'yebi3'       ,ls_yebi3)
					dw_insert.setitem(li_rowcnt,'yebi4'       ,ls_yebi4)
					dw_insert.setitem(li_rowcnt,'dyebi1'      ,ld_dyebi1)
					dw_insert.setitem(li_rowcnt,'dyebi2'      ,ld_dyebi2)
//					dw_insert.setitem(li_rowcnt,'dyebi3'      ,ld_dyebi3)
					dw_insert.setitem(li_rowcnt,'cnvfat'      ,ld_cnvfat)
					dw_insert.setitem(li_rowcnt,'cnvart'      ,ls_cnvart)
					dw_insert.setitem(li_rowcnt,'cnviore'     ,ld_cnviore)
					dw_insert.setitem(li_rowcnt,'cnviofa'     ,ld_cnviofa)
					dw_insert.setitem(li_rowcnt,'cnviope'     ,ld_cnviope)
					dw_insert.setitem(li_rowcnt,'cnviosp'     ,ld_cnviosp)
					dw_insert.setitem(li_rowcnt,'cnviocd'     ,ld_cnviocd)
					dw_insert.setitem(li_rowcnt,'cnviosu'     ,ld_cnviosu)
					dw_insert.setitem(li_rowcnt,'gongqty'     ,ld_gongqty)
					dw_insert.setitem(li_rowcnt,'gongprc'     ,ld_gongprc)
					dw_insert.setitem(li_rowcnt,'saupj'       ,ls_saupj)	
					dw_insert.setitem(li_rowcnt,'facgbn'      ,ls_factory)	
					dw_insert.setitem(li_rowcnt,'lclgbn'       ,ls_ipsource)	
					
					dw_insert.scrolltorow(li_rowcnt)
					
					FETCH CUR_GUMSU_SUB 
					INTO 	:ls_sabu,		:ls_iojpno,		:ls_iogbn,		:ls_sudat,
							:ls_itnbr,		:ls_pspec,		:ls_opseq,		:ls_depot_no,
							:ls_cvnas2,		:ls_sarea,		:ls_pdtgu,		:ls_cust_no,
							:ld_ioqty,		:ld_ioprc,		:ld_ioamt,		:ld_ioreqty,
							:ls_insdat,  	:ls_insemp,		:ls_qcgub,		:ld_iofaqty,
							:ld_iopeqty,	:ld_iospqty,	:ld_iocdqty,	:ld_iosuqty,
							:ls_io_confirm,:ls_io_date,	:ls_io_empno,	:ls_lotsno,
							:ls_loteno,		:ls_hold_no,  	:ls_order_no,	:ls_inv_no,
							:li_inv_seq,	:ls_filsk,		:ls_baljpno,	:li_balseq,
							:ls_polcno,		:ls_poblno,		:li_poblsq,		:ls_bigo,
							:ls_botimh,		:ls_ip_jpno,	:ls_itgu,		:ls_sicdat,
							:ls_mayymm,  	:ls_inpcnf,		:ls_jakjino,	:ls_jaksino,
							:ls_jnpcrt,		:ls_outchk,		:ll_mayysq,		:ls_ioredept,
							:ls_ioreemp,	:ld_dcrate,		:ls_juksdat,	:ls_jukedat,
							:ld_prvprc,		:ld_aftprc,		:ld_silqty,  	:ld_silamt,
							:ls_gurdat,		:ls_tukdat,		:ls_tukemp,		:ld_tukqty,
							:ls_tuksudat,	:ls_crt_date,	:ls_crt_time,	:ls_crt_user,
							:ls_upd_date,	:ls_upd_time,	:ls_upd_user,	:ls_checkno, 
						 	:ls_pjt_cd,		:ls_field_cd,	:ls_area_cd,	:ls_yebi1,
							:ls_yebi2,		:ls_yebi3,		:ls_yebi4,		:ld_dyebi1,
							:ld_dyebi2,		:ld_dyebi3,		:ld_cnvfat,		:ls_cnvart,
							:ld_cnviore,	:ld_cnviofa,	:ld_cnviope,  	:ld_cnviosp,
							:ld_cnviocd,	:ld_cnviosu,	:ld_gongqty,	:ld_gongprc,
							:ls_saupj,		:ld_pacprc;
						 
					IF SQLCA.SQLCODE <> 0 AND NOT lb_exit_chk_current THEN
//						//납품수량
//						dw_insert.setitem(li_rowcnt,'choiceqty',dw_insert.getitemnumber(li_rowcnt,'choiceqty') + ld_tot_ipqty)
//						//수불금액 (단가 * 수량)
//						dw_insert.setitem(li_rowcnt,'ioamt',(ld_tot_ipqty + dw_insert.getitemnumber(li_rowcnt,'choiceqty')) * dw_insert.getitemnumber(li_rowcnt,'ioprc'))
//						//합격수량
//						dw_insert.setitem(li_rowcnt,'iosuqty'     ,ld_tot_ipqty + dw_insert.getitemnumber(li_rowcnt,'iosuqty'))
						//오버되는 검수수량 값을 van_hkcd1에 저장하기 위해 저장한다.
						dw_imsi.setitem(li_rowcnt_imsi,'imsi_chuga_su',ld_tot_ipqty)
						dw_imsi.setitem(li_rowcnt_imsi,'imsi_ipdan',ld_IMSI_IPDAN)
						dw_imsi.setitem(li_rowcnt_imsi,'imsi_packdan',ld_IMSI_PACKDAN)

						dw_insert.setitem(li_rowcnt,'chuga_su',ld_tot_ipqty)
					END IF				
					//상태값 변경
					dw_insert.SetItemStatus(li_rowcnt, 0,Primary!,DataModified!)
				LOOP		
				CLOSE CUR_GUMSU_SUB;

				if li_rowcnt = 0 then
					//현재값을 임시 dw에 저장
					li_rowcnt_imsi = dw_imsi.insertrow(0)
					dw_imsi.setitem(li_rowcnt_imsi,'imsi_gubun',ls_gubun)
					dw_imsi.setitem(li_rowcnt_imsi,'imsi_custcd',ls_custcd)
					dw_imsi.setitem(li_rowcnt_imsi,'imsi_factory',ls_factory)
					dw_imsi.setitem(li_rowcnt_imsi,'imsi_van_itnbr',ls_van_itnbr)
					dw_imsi.setitem(li_rowcnt_imsi,'imsi_ipno',ls_ipno)
					dw_imsi.setitem(li_rowcnt_imsi,'imsi_BAL_NO',ls_BAL_NO)
				end if
				//현재값 셋팅
				ld_tot_ipqty = ld_ipqty
				//입고단가
				if not isnull(ld_IPDAN) and   ld_IPDAN <> 0 then
					ld_IMSI_IPDAN = ld_IPDAN
				end IF
				//납품일자,검수일
				if not isnull(ls_IP_DATE) and trim(ls_IP_DATE) <> '' then
					ls_imsi_IP_DATE = ls_IP_DATE
				else
					//납품일자가 없을 경우
					ls_imsi_IP_DATE = f_today()
				end if
				//검수일자
//				IF ls_gubun <> 'C' THEN
//					ls_geomsu_date = mid(ls_DOCCODE,3,8)
//				ELSE
//					ls_geomsu_date = ''
//				END IF
				//포장단가
				IF not isnull(ld_PACKDAN) and ld_PACKDAN = 0 THEN
					ld_imsi_packdan = ld_PACKDAN
				end if
			END IF
			ls_imsi_mcvcod = ls_mcvcod
			ls_imsi_mitnbr = ls_mitnbr
		END IF
	END IF

	FETCH CUR_GUMSU 
	 INTO :ls_GUBUN,		:ls_CUSTCD,		:ls_FACTORY,		:ls_VAN_ITNBR,
	 		:ls_IPNO,		:ls_IP_DATE,	:ld_IPQTY,			:ld_IPDAN,
			:ls_BAL_NO,		:ls_MITNBR,		:ls_ITDSC,			:ls_ISPEC,
			:ls_mcvcod;
LOOP		
CLOSE CUR_GUMSU;

//마지막 값을 insert_row
if ld_tot_ipqty <> 0  then
	OPEN CUR_GUMSU_SUB;
	FETCH CUR_GUMSU_SUB 
	 INTO	:ls_sabu,		:ls_iojpno,		:ls_iogbn,		:ls_sudat,
	 		:ls_itnbr,		:ls_pspec,		:ls_opseq,		:ls_depot_no,
			:ls_cvnas2,		:ls_sarea,		:ls_pdtgu,		:ls_cust_no,
			:ld_ioqty,		:ld_ioprc,		:ld_ioamt,		:ld_ioreqty,
			:ls_insdat,	 	:ls_insemp,		:ls_qcgub,		:ld_iofaqty,
			:ld_iopeqty,	:ld_iospqty,	:ld_iocdqty,	:ld_iosuqty,
			:ls_io_confirm,:ls_io_date,	:ls_io_empno,	:ls_lotsno,
			:ls_loteno,		:ls_hold_no, 	:ls_order_no,	:ls_inv_no,
			:li_inv_seq,	:ls_filsk,		:ls_baljpno,	:li_balseq,
			:ls_polcno,		:ls_poblno,		:li_poblsq,		:ls_bigo,
			:ls_botimh,		:ls_ip_jpno,	:ls_itgu,		:ls_sicdat,
			:ls_mayymm,	 	:ls_inpcnf,		:ls_jakjino,	:ls_jaksino,
			:ls_jnpcrt,		:ls_outchk,		:ll_mayysq,		:ls_ioredept,
			:ls_ioreemp,	:ld_dcrate,		:ls_juksdat,	:ls_jukedat,
			:ld_prvprc,		:ld_aftprc,		:ld_silqty,	 	:ld_silamt,
			:ls_gurdat,		:ls_tukdat,		:ls_tukemp,		:ld_tukqty,
			:ls_tuksudat,	:ls_crt_date,	:ls_crt_time,	:ls_crt_user,
			:ls_upd_date,	:ls_upd_time,	:ls_upd_user,	:ls_checkno,
		 	:ls_pjt_cd,		:ls_field_cd,	:ls_area_cd,	:ls_yebi1,
			:ls_yebi2,		:ls_yebi3,		:ls_yebi4,		:ld_dyebi1,
			:ld_dyebi2,		:ld_dyebi3,		:ld_cnvfat,		:ls_cnvart,
			:ld_cnviore,	:ld_cnviofa,	:ld_cnviope, 	:ld_cnviosp,
			:ld_cnviocd,	:ld_cnviosu,	:ld_gongqty,	:ld_gongprc,
			:ls_saupj,		:ld_pacprc;

	lb_exit_chk_current = TRUE
	
	DO WHILE SQLCA.SQLCODE = 0 AND lb_exit_chk_depth
		li_rowcnt = dw_insert.insertrow(0)
		//입고단가
		IF not isnull(ld_imsi_IPDAN) and ld_imsi_IPDAN > 0 then
			dw_insert.setitem(li_rowcnt,'ioprc',ld_IMSI_IPDAN)
		ELSE
			dw_insert.setitem(li_rowcnt,'ioprc',ld_ioprc)
		END IF
		//수불수량이 납품수량보다 작을 경우 
		IF ld_ioqty < ld_tot_ipqty THEN
			dw_insert.setitem(li_rowcnt,'choiceqty',ld_ioqty)
			//합격수량
			dw_insert.setitem(li_rowcnt,'iosuqty',ld_ioqty)			
			//수불금액
			dw_insert.setitem(li_rowcnt,'ioamt',ld_ioqty * dw_insert.getitemnumber(li_rowcnt,'ioprc'))
			ld_tot_ipqty -= ld_ioqty
			lb_exit_chk_current = FALSE
		ELSEIF ld_ioqty = ld_tot_ipqty THEN
			dw_insert.setitem(li_rowcnt,'choiceqty',ld_tot_ipqty)
			//합격수량
			dw_insert.setitem(li_rowcnt,'iosuqty',ld_tot_ipqty)			
			//수불금액
			dw_insert.setitem(li_rowcnt,'ioamt',ld_tot_ipqty * dw_insert.getitemnumber(li_rowcnt,'ioprc'))
			ld_tot_ipqty -= ld_ioqty
			lb_exit_chk_depth = FALSE
		// 수불수량이 납품수량보다 클 경우
		ELSE
			dw_insert.setitem(li_rowcnt,'choiceqty',ld_tot_ipqty)
			//합격수량
			dw_insert.setitem(li_rowcnt,'iosuqty',ld_tot_ipqty)			
			//수불금액
			dw_insert.setitem(li_rowcnt,'ioamt',ld_tot_ipqty * dw_insert.getitemnumber(li_rowcnt,'ioprc'))
			lb_exit_chk_depth = FALSE
		END IF
		// write count
		li_write_cnt += 1
		
		//거래처명 DISPLAY
		dw_insert.setitem(li_rowcnt,'vndmst_cvnas2',ls_cvnas2)
		dw_insert.setitem(li_rowcnt,'itemas_itdsc',ls_itdsc)
		dw_insert.setitem(li_rowcnt,'itemas_ispec',ls_ispec)
		//출하일자
		dw_insert.setitem(li_rowcnt,'io_date',ls_io_date)
		dw_insert.setitem(li_rowcnt,'chdate',ls_io_date)
		//출하수량
		dw_insert.setitem(li_rowcnt,'ioqty',ld_ioqty)
		//납품일자
		dw_insert.setitem(li_rowcnt,'IP_DATE',ls_imsi_IP_DATE)
		//검수일자
		dw_insert.setitem(li_rowcnt,'gdate',ls_imsi_IP_DATE)
		//포장단가 
		dw_insert.setitem(li_rowcnt,'pacprc',ld_imsi_PACKDAN)
//		//van 발주번호 표시
//		dw_insert.setitem(li_rowcnt,'van_BAL_NO',ls_BAL_NO)
//		//van 체크자료 
//		dw_insert.setitem(li_rowcnt,'gubun',ls_gubun)		
//		dw_insert.setitem(li_rowcnt,'doccode',ls_doccode)
//		dw_insert.setitem(li_rowcnt,'custcd',ls_custcd)
//		dw_insert.setitem(li_rowcnt,'factory',ls_factory)
//		dw_insert.setitem(li_rowcnt,'van_itnbr',ls_van_itnbr)
//		dw_insert.setitem(li_rowcnt,'ipno',ls_ipno)
//		dw_insert.setitem(li_rowcnt,'ipchkno',ls_ipchkno)

		//기존자료(imhist)
		dw_insert.setitem(li_rowcnt,'sabu'        ,ls_sabu)
		dw_insert.setitem(li_rowcnt,'iojpno'      ,ls_iojpno)
		dw_insert.setitem(li_rowcnt,'iogbn'       ,ls_iogbn)
		dw_insert.setitem(li_rowcnt,'sudat'       ,ls_sudat)
		dw_insert.setitem(li_rowcnt,'itnbr'       ,ls_itnbr)
		dw_insert.setitem(li_rowcnt,'pspec'       ,ls_pspec)
		dw_insert.setitem(li_rowcnt,'opseq'       ,ls_opseq)
		dw_insert.setitem(li_rowcnt,'depot_no'    ,ls_depot_no)
		dw_insert.setitem(li_rowcnt,'cvcod'       ,ls_mcvcod)
		dw_insert.setitem(li_rowcnt,'sarea'       ,ls_sarea)
		dw_insert.setitem(li_rowcnt,'pdtgu'       ,ls_pdtgu)
		dw_insert.setitem(li_rowcnt,'cust_no'     ,ls_cust_no)
		dw_insert.setitem(li_rowcnt,'insdat'      ,ls_insdat)
		dw_insert.setitem(li_rowcnt,'insemp'      ,ls_insemp)
		dw_insert.setitem(li_rowcnt,'qcgub'       ,ls_qcgub)
		dw_insert.setitem(li_rowcnt,'iofaqty'     ,ld_iofaqty)
		dw_insert.setitem(li_rowcnt,'iopeqty'     ,ld_iopeqty)
		dw_insert.setitem(li_rowcnt,'iospqty'     ,ld_iospqty)
		dw_insert.setitem(li_rowcnt,'iocdqty'     ,ld_iocdqty)
		dw_insert.setitem(li_rowcnt,'io_confirm'  ,ls_io_confirm)
		dw_insert.setitem(li_rowcnt,'io_empno'    ,ls_io_empno)
//		dw_insert.setitem(li_rowcnt,'lotsno'      ,ls_lotsno)
//		dw_insert.setitem(li_rowcnt,'loteno'      ,ls_loteno)
		dw_insert.setitem(li_rowcnt,'hold_no'     ,ls_hold_no)
		dw_insert.setitem(li_rowcnt,'order_no'    ,ls_order_no)
		dw_insert.setitem(li_rowcnt,'inv_no'      ,ls_inv_no)
		dw_insert.setitem(li_rowcnt,'inv_seq'     ,li_inv_seq)
		dw_insert.setitem(li_rowcnt,'filsk'       ,ls_filsk)
		dw_insert.setitem(li_rowcnt,'baljpno'     ,ls_baljpno)
		dw_insert.setitem(li_rowcnt,'balseq'      ,li_balseq)
		dw_insert.setitem(li_rowcnt,'polcno'      ,ls_polcno)
		dw_insert.setitem(li_rowcnt,'poblno'      ,ls_poblno)
		dw_insert.setitem(li_rowcnt,'poblsq'      ,li_poblsq)
		dw_insert.setitem(li_rowcnt,'bigo'        ,ls_bigo)
		dw_insert.setitem(li_rowcnt,'botimh'      ,ls_botimh)
		dw_insert.setitem(li_rowcnt,'ip_jpno'     ,ls_ip_jpno)
		dw_insert.setitem(li_rowcnt,'itgu'        ,ls_itgu)
		dw_insert.setitem(li_rowcnt,'sicdat'      ,ls_sicdat)
		dw_insert.setitem(li_rowcnt,'mayymm'      ,ls_mayymm)
		dw_insert.setitem(li_rowcnt,'inpcnf'      ,ls_inpcnf)
		dw_insert.setitem(li_rowcnt,'jakjino'     ,ls_jakjino)
		dw_insert.setitem(li_rowcnt,'jaksino'     ,ls_jaksino)
		dw_insert.setitem(li_rowcnt,'jnpcrt'      ,ls_jnpcrt)
		dw_insert.setitem(li_rowcnt,'outchk'      ,ls_outchk)
		dw_insert.setitem(li_rowcnt,'mayysq'      ,ll_mayysq)
		dw_insert.setitem(li_rowcnt,'ioredept'    ,ls_ioredept)
		dw_insert.setitem(li_rowcnt,'ioreemp'     ,ls_ioreemp)
		dw_insert.setitem(li_rowcnt,'dcrate'      ,ld_dcrate)
		dw_insert.setitem(li_rowcnt,'juksdat'     ,ls_juksdat)
		dw_insert.setitem(li_rowcnt,'jukedat'     ,ls_jukedat)
		dw_insert.setitem(li_rowcnt,'prvprc'      ,ld_prvprc)
		dw_insert.setitem(li_rowcnt,'aftprc'      ,ld_aftprc)
		dw_insert.setitem(li_rowcnt,'silqty'      ,ld_silqty)
		dw_insert.setitem(li_rowcnt,'silamt'      ,ld_silamt)
		dw_insert.setitem(li_rowcnt,'gurdat'      ,ls_gurdat)
		dw_insert.setitem(li_rowcnt,'tukdat'      ,ls_tukdat)
		dw_insert.setitem(li_rowcnt,'tukemp'      ,ls_tukemp)
		dw_insert.setitem(li_rowcnt,'tukqty'      ,ld_tukqty)
		dw_insert.setitem(li_rowcnt,'tuksudat'    ,ls_tuksudat)
		dw_insert.setitem(li_rowcnt,'upd_date'    ,ls_upd_date)
		dw_insert.setitem(li_rowcnt,'upd_time'    ,ls_upd_time)
		dw_insert.setitem(li_rowcnt,'upd_user'    ,ls_upd_user)
		dw_insert.setitem(li_rowcnt,'checkno'     ,ls_checkno)
		dw_insert.setitem(li_rowcnt,'pjt_cd'      ,ls_pjt_cd)
		dw_insert.setitem(li_rowcnt,'field_cd'    ,ls_field_cd)
		dw_insert.setitem(li_rowcnt,'area_cd'     ,ls_area_cd)
		dw_insert.setitem(li_rowcnt,'yebi1'       ,ls_yebi1)
		dw_insert.setitem(li_rowcnt,'yebi2'       ,ls_yebi2)
		dw_insert.setitem(li_rowcnt,'yebi3'       ,ls_yebi3)
		dw_insert.setitem(li_rowcnt,'yebi4'       ,ls_yebi4)
		dw_insert.setitem(li_rowcnt,'dyebi1'      ,ld_dyebi1)
		dw_insert.setitem(li_rowcnt,'dyebi2'      ,ld_dyebi2)
//		dw_insert.setitem(li_rowcnt,'dyebi3'      ,ld_dyebi3)
		dw_insert.setitem(li_rowcnt,'cnvfat'      ,ld_cnvfat)
		dw_insert.setitem(li_rowcnt,'cnvart'      ,ls_cnvart)
		dw_insert.setitem(li_rowcnt,'cnviore'     ,ld_cnviore)
		dw_insert.setitem(li_rowcnt,'cnviofa'     ,ld_cnviofa)
		dw_insert.setitem(li_rowcnt,'cnviope'     ,ld_cnviope)
		dw_insert.setitem(li_rowcnt,'cnviosp'     ,ld_cnviosp)
		dw_insert.setitem(li_rowcnt,'cnviocd'     ,ld_cnviocd)
		dw_insert.setitem(li_rowcnt,'cnviosu'     ,ld_cnviosu)
		dw_insert.setitem(li_rowcnt,'gongqty'     ,ld_gongqty)
		dw_insert.setitem(li_rowcnt,'gongprc'     ,ld_gongprc)
		dw_insert.setitem(li_rowcnt,'saupj'       ,ls_saupj)	
		dw_insert.setitem(li_rowcnt,'facgbn'      ,ls_factory)	
		dw_insert.setitem(li_rowcnt,'lclgbn'      ,ls_ipsource)	
		
		dw_insert.scrolltorow(li_rowcnt)
		
		FETCH CUR_GUMSU_SUB 
		 INTO	:ls_sabu,		:ls_iojpno,		:ls_iogbn,		:ls_sudat,
		 		:ls_itnbr,		:ls_pspec,		:ls_opseq,		:ls_depot_no,
				:ls_cvnas2,		:ls_sarea,		:ls_pdtgu,		:ls_cust_no,
				:ld_ioqty,		:ld_ioprc,		:ld_ioamt,		:ld_ioreqty,
				:ls_insdat,  	:ls_insemp,		:ls_qcgub,		:ld_iofaqty,
				:ld_iopeqty,	:ld_iospqty,	:ld_iocdqty,	:ld_iosuqty,
				:ls_io_confirm,:ls_io_date,	:ls_io_empno,	:ls_lotsno,
				:ls_loteno,		:ls_hold_no,  	:ls_order_no,	:ls_inv_no,
				:li_inv_seq,	:ls_filsk,		:ls_baljpno,	:li_balseq,
				:ls_polcno,		:ls_poblno,		:li_poblsq,		:ls_bigo,
				:ls_botimh,		:ls_ip_jpno,	:ls_itgu,		:ls_sicdat,
				:ls_mayymm,  	:ls_inpcnf,		:ls_jakjino,	:ls_jaksino,
				:ls_jnpcrt,		:ls_outchk,		:ll_mayysq,		:ls_ioredept,
				:ls_ioreemp,	:ld_dcrate,		:ls_juksdat,	:ls_jukedat,
				:ld_prvprc,		:ld_aftprc,		:ld_silqty,  	:ld_silamt,
				:ls_gurdat,		:ls_tukdat,		:ls_tukemp,		:ld_tukqty,
				:ls_tuksudat,	:ls_crt_date,	:ls_crt_time,	:ls_crt_user,
				:ls_upd_date,	:ls_upd_time,	:ls_upd_user,	:ls_checkno, 
			 	:ls_pjt_cd,		:ls_field_cd,	:ls_area_cd,	:ls_yebi1,
				:ls_yebi2,		:ls_yebi3,		:ls_yebi4,		:ld_dyebi1,
				:ld_dyebi2,		:ld_dyebi3,		:ld_cnvfat,		:ls_cnvart,
				:ld_cnviore,	:ld_cnviofa,	:ld_cnviope,  	:ld_cnviosp,
				:ld_cnviocd,	:ld_cnviosu,	:ld_gongqty,	:ld_gongprc,
				:ls_saupj,:ld_pacprc;
			 
		IF SQLCA.SQLCODE <> 0 AND NOT lb_exit_chk_current THEN
//			//납품수량
//			dw_insert.setitem(li_rowcnt,'choiceqty',dw_insert.getitemnumber(li_rowcnt,'choiceqty') + ld_tot_ipqty)
//			//수불금액 (단가 * 수량)
//			dw_insert.setitem(li_rowcnt,'ioamt',(ld_tot_ipqty + dw_insert.getitemnumber(li_rowcnt,'choiceqty')) * dw_insert.getitemnumber(li_rowcnt,'ioprc'))
//			//합격수량
//			dw_insert.setitem(li_rowcnt,'iosuqty'     ,ld_tot_ipqty + dw_insert.getitemnumber(li_rowcnt,'iosuqty'))
			//오버되는 검수수량 값을 van_hkcd1에 저장하기 위해 저장한다.
			dw_imsi.setitem(li_rowcnt_imsi,'imsi_chuga_su',ld_tot_ipqty)
			dw_imsi.setitem(li_rowcnt_imsi,'imsi_ipdan',ld_IMSI_IPDAN)
			dw_imsi.setitem(li_rowcnt_imsi,'imsi_packdan',ld_IMSI_PACKDAN)

			dw_insert.setitem(li_rowcnt,'chuga_su',ld_tot_ipqty)
		END IF				
		//상태값 변경
		dw_insert.SetItemStatus(li_rowcnt, 0,Primary!,DataModified!)
	LOOP		
	CLOSE CUR_GUMSU_SUB;
end if
dw_insert.scrolltorow(1)
dw_insert.setcolumn('choiceqty')

SetPointer(oldpointer)

messagebox('확인','자료가 정상적으로 처리되었습니다. ' + '~n' + &
                  '읽은자료['+string(li_read_cnt)+'] 저장자료['+string(li_write_cnt)+']')

RETURN 1


end function

on w_sm40_0055.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.rr_1=create rr_1
this.cbx_1=create cbx_1
this.pb_1=create pb_1
this.pb_2=create pb_2
this.dw_gumsu=create dw_gumsu
this.dw_2=create dw_2
this.st_2=create st_2
this.rr_2=create rr_2
this.p_1=create p_1
this.p_2=create p_2
this.dw_3=create dw_3
this.st_3=create st_3
this.dw_imsi=create dw_imsi
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.rr_1
this.Control[iCurrent+3]=this.cbx_1
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.pb_2
this.Control[iCurrent+6]=this.dw_gumsu
this.Control[iCurrent+7]=this.dw_2
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.rr_2
this.Control[iCurrent+10]=this.p_1
this.Control[iCurrent+11]=this.p_2
this.Control[iCurrent+12]=this.dw_3
this.Control[iCurrent+13]=this.st_3
this.Control[iCurrent+14]=this.dw_imsi
end on

on w_sm40_0055.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.rr_1)
destroy(this.cbx_1)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.dw_gumsu)
destroy(this.dw_2)
destroy(this.st_2)
destroy(this.rr_2)
destroy(this.p_1)
destroy(this.p_2)
destroy(this.dw_3)
destroy(this.st_3)
destroy(this.dw_imsi)
end on

event open;call super::open;dw_1.SetTransObject(SQLCA)
dw_gumsu.SetTransObject(SQLCA)
dw_insert.SetTransObject(SQLCA)

dw_1.InsertRow(0)
dw_2.InsertRow(0)
dw_3.InsertRow(0)

/* User별 사업장 Setting Start */
String saupj
 
//If f_check_saupj(saupj) = 1 Then
//	dw_1.Modify("saupj.protect=1")
//End If
//dw_1.SetItem(1, 'saupj', saupj)
f_mod_saupj(dw_1, 'saupj')

dw_1.Object.sdate[1] = Left(is_today , 6) + '01' 
dw_1.Object.edate[1] = is_today


end event

type dw_insert from w_inherite`dw_insert within w_sm40_0055
integer x = 2258
integer y = 440
integer width = 2331
integer height = 1872
integer taborder = 140
string dataobject = "d_sm40_0050_B"
boolean hscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = false
end type

event dw_insert::itemchanged;Dec  dmmqty, davg
Long nJucha, ix, nRow
Int  ireturn
String sitnbr, sitdsc, sispec, sjijil, sispec_code, s_cvcod, snull, get_nm

setnull(snull)

nRow = GetRow()
If nRow <= 0 Then Return

Choose Case GetColumnName()
//	Case 'itnbr'
//		sItnbr = trim(this.GetText())
//	
//		ireturn = f_get_name4('품번', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)	
//		setitem(nrow, "itnbr", sitnbr)	
//		setitem(nrow, "itemas_itdsc", sitdsc)
//		
//		Post wf_danga(nrow)
//		
//		RETURN ireturn
//	Case 'cvcod'
//		s_cvcod = this.GetText()								
//		 
//		if s_cvcod = "" or isnull(s_cvcod) then 
//			this.setitem(nrow, 'vndmst_cvnas2', snull)
//			return 
//		end if
//		
//		SELECT "VNDMST"."CVNAS2"  
//		  INTO :get_nm  
//		  FROM "VNDMST"  
//		 WHERE "VNDMST"."CVCOD" = :s_cvcod  ;
//	
//		if sqlca.sqlcode = 0 then 
//			this.setitem(nrow, 'vndmst_cvnas2', get_nm)
//		else
//			this.triggerevent(RbuttonDown!)
//			return 1
//		end if
//		
//		Post wf_danga(nrow)
	Case "isqty_temp"
		

End Choose
end event

event dw_insert::itemerror;call super::itemerror;return 1
end event

event dw_insert::clicked;call super::clicked;//f_multi_select(this)
end event

type p_delrow from w_inherite`p_delrow within w_sm40_0055
boolean visible = false
integer x = 3922
integer y = 184
integer taborder = 70
end type

type p_addrow from w_inherite`p_addrow within w_sm40_0055
boolean visible = false
integer x = 3749
integer y = 184
integer taborder = 60
end type

type p_search from w_inherite`p_search within w_sm40_0055
boolean visible = false
integer x = 3749
integer y = 264
integer taborder = 120
string picturename = "C:\erpman\image\생성_up.gif"
end type

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\생성_dn.gif"
end event

event p_search::ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\생성_up.gif"
end event

type p_ins from w_inherite`p_ins within w_sm40_0055
boolean visible = false
integer x = 4425
integer y = 264
integer taborder = 40
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_sm40_0055
integer taborder = 110
end type

event p_exit::clicked;Close(parent)
end event

type p_can from w_inherite`p_can within w_sm40_0055
integer taborder = 100
end type

event p_can::clicked;call super::clicked;dw_gumsu.Reset()
dw_insert.Reset()
end event

type p_print from w_inherite`p_print within w_sm40_0055
boolean visible = false
integer x = 3922
integer y = 264
integer taborder = 130
end type

type p_inq from w_inherite`p_inq within w_sm40_0055
integer x = 3922
end type

event p_inq::clicked;String ls_saupj , ls_factory , ls_sdate , ls_edate , ls_itnbr ,ls_gubun ,ls_gubun2

If dw_1.AcceptText() < 1 Then Return
If dw_2.AcceptText() < 1 Then Return

ls_saupj = Trim(dw_1.Object.saupj[1])
ls_sdate = Trim(dw_1.Object.sdate[1])
ls_edate = Trim(dw_1.Object.edate[1])
ls_factory = Trim(dw_1.Object.factory[1])
ls_itnbr = Trim(dw_1.Object.itnbr[1])


If ls_factory = '' Or isNull(ls_factory) Or ls_factory = '.' Then ls_factory = '%'
If ls_itnbr = '' Or isNull(ls_itnbr)  Then ls_itnbr = '%'

If IsNull(ls_sdate) Or ls_sdate = '' Then
	f_message_chk(1400,'[기간-시작일자]')
	dw_1.SetColumn("sdate")
	dw_1.SetFocus()
	Return
End If

If IsNull(ls_edate) Or ls_edate = '' Then
	f_message_chk(1400,'[기간-종료일자]')
	dw_1.SetColumn("sdate")
	dw_1.SetFocus()
	Return
End If

/* 사업장 체크 */
ls_saupj= Trim(dw_1.GetItemString(1, 'saupj'))
If IsNull(ls_saupj) Or ls_saupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_1.SetFocus()
	dw_1.SetColumn('saupj')
	Return -1
End If

dw_gumsu.SetRedraw(False)

If dw_gumsu.Retrieve(ls_saupj, ls_factory , ls_sdate ,ls_edate , ls_itnbr+'%' ) <= 0 Then
	
	f_message_chk(50,'[ 검수자료 ]')
Else
	wf_filter1()
End If

dw_gumsu.SetRedraw(True)

dw_insert.SetRedraw(False)

If dw_insert.Retrieve(ls_saupj, ls_factory , ls_sdate ,ls_edate , ls_itnbr+'%'  ) <= 0 Then
	
	f_message_chk(50,'[ 출하자료 ]')
Else
	wf_filter2()
End If

dw_insert.SetRedraw(True)



end event

type p_del from w_inherite`p_del within w_sm40_0055
boolean visible = false
integer y = 264
integer taborder = 90
end type

type p_mod from w_inherite`p_mod within w_sm40_0055
integer x = 4096
integer taborder = 80
end type

event p_mod::clicked;call super::clicked;If dw_gumsu.AcceptText() < 1 Then Return
If dw_insert.AcceptText() < 1 Then Return

If dw_gumsu.RowCount() < 1 Then Return
If dw_insert.RowCount() < 1 Then Return

If f_msg_Update() < 1 Then Return

If dw_gumsu.Update() < 1 Then
	Rollback;
	Return
Else
	LOng i 
	For i = 1 To dw_insert.RowCount()
		If Trim(dw_insert.Object.yebi1_temp[i]) = 'Y' Then
			dw_insert.Object.yebi1[i] = is_today
		End iF
	Next
	dw_insert.AcceptText()
	If dw_insert.Update() < 1 Then
		Rollback;
		Return
	Else
		Commit;
		p_inq.TriggerEvent(Clicked!)
	End iF
End iF
//f_mdi_msg("저장 완료 하였습니다.")
end event

type cb_exit from w_inherite`cb_exit within w_sm40_0055
boolean visible = true
end type

type cb_mod from w_inherite`cb_mod within w_sm40_0055
boolean visible = true
end type

type cb_ins from w_inherite`cb_ins within w_sm40_0055
boolean visible = true
end type

type cb_del from w_inherite`cb_del within w_sm40_0055
boolean visible = true
end type

type cb_inq from w_inherite`cb_inq within w_sm40_0055
boolean visible = true
end type

type cb_print from w_inherite`cb_print within w_sm40_0055
boolean visible = true
end type

type st_1 from w_inherite`st_1 within w_sm40_0055
boolean visible = true
end type

type cb_can from w_inherite`cb_can within w_sm40_0055
boolean visible = true
end type

type cb_search from w_inherite`cb_search within w_sm40_0055
boolean visible = true
end type

type dw_datetime from w_inherite`dw_datetime within w_sm40_0055
boolean visible = true
end type

type sle_msg from w_inherite`sle_msg within w_sm40_0055
boolean visible = true
end type

type gb_10 from w_inherite`gb_10 within w_sm40_0055
boolean visible = true
end type

type gb_button1 from w_inherite`gb_button1 within w_sm40_0055
boolean visible = true
end type

type gb_button2 from w_inherite`gb_button2 within w_sm40_0055
boolean visible = true
end type

type dw_1 from u_key_enter within w_sm40_0055
integer x = 14
integer y = 24
integer width = 3223
integer height = 268
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_sm40_0055_1"
boolean border = false
end type

event itemchanged;String ls_col , ls_value , ls_null, ls_data
Int li_cnt

row = GetRow()
SetNull(ls_null)
SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

ls_col = GetColumnName() 
ls_value = GetText() 

Choose Case ls_col
	Case	"itnbr" 

		IF ls_value ="" or isNull(ls_value) THEN
			Object.itnbr[row]    	= ls_null
			Object.itdsc[row]    	= ls_null
			Return 1
		END IF
		
		ls_data = wf_itdsc(ls_value)
      if	 isNull(ls_data) or ls_data = ''	then return 1;
		Object.itdsc[row]    	= ls_data

	Case	"sdate" 
		IF f_datechk(ls_value) = -1 THEN
			f_message_chk(33,'[시작일자]')
			dw_insert.SetColumn("sdate")
			dw_1.SetFocus()
			Return 1
		END IF
	Case	"edate" 
		IF f_datechk(ls_value) = -1 THEN
			f_message_chk(33,'[종료일자]')
			dw_insert.SetColumn("edate")
			dw_1.SetFocus()
			Return 1
		END IF
	Case	"factory"
		SELECT fun_get_reffpf_value('8I', :ls_value, '2') into :ls_data From dual;
		if	isNull(ls_data) or ls_data = '' then ls_data = '00001'     // 기본매출거래처.
		Object.factory[row]    	= ls_data
		
END Choose




end event

event itemerror;call super::itemerror;RETURN 1
end event

event rbuttondown;call super::rbuttondown;int lreturnrow, lrow
string snull

setnull(gs_code)
setnull(gs_codename)
setnull(snull)

lrow = this.getrow()

Choose Case GetcolumnName() 
	Case "itnbr"
		gs_code = this.GetText()
		gs_gubun = '1'
		open(w_itemas_popup)
		if isnull(gs_code) or gs_code = "" then return
		this.SetItem(1, "itnbr", gs_code)
End Choose

//IF this.GetColumnName() = "cvcod" THEN
//	gs_code = this.GetText()
//	IF Gs_code ="" OR IsNull(gs_code) THEN 
//		gs_code =""
//	END IF
//	
////	gs_gubun = '2'
//	Open(w_vndmst_popup)
//	
//	IF isnull(gs_Code)  or  gs_Code = ''	then  
//		this.SetItem(lrow, "cvcod", snull)
//		this.SetItem(lrow, "cvnas", snull)
//   	return
//   ELSE
//		lReturnRow = This.Find("cvcod = '"+gs_code+"' ", 1, This.RowCount())
//		IF (lRow <> lReturnRow) and (lReturnRow <> 0) THEN
//			f_message_chk(37,'[거래처]') 
//			this.SetItem(lRow, "cvcod", sNull)
//		   this.SetItem(lRow, "cvnas", sNull)
//			RETURN  1
//		END IF
//   END IF	
//
//	this.SetItem(lrow, "cvcod", gs_Code)
//	this.SetItem(lrow, "cvnas", gs_Codename)
//END IF
//
end event

type rr_1 from roundrectangle within w_sm40_0055
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 348
integer width = 2194
integer height = 1976
integer cornerheight = 40
integer cornerwidth = 55
end type

type cbx_1 from checkbox within w_sm40_0055
boolean visible = false
integer x = 3703
integer y = 400
integer width = 795
integer height = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "품목별 주간계획(가전) 확인"
end type

event clicked;String syymm, sCust, sDate, eDate, sCvcod, sSaupj

syymm  = trim(dw_1.getitemstring(1, 'yymm'))
sCust  = trim(dw_1.getitemstring(1, 'cust'))
sCvcod = trim(dw_1.getitemstring(1, 'cvcod'))
If IsNull(sCvcod) Then sCvcod = ''

If IsNull(syymm) Or sYymm = '' Then
	f_message_chk(1400,'[계획시작일]')
	Return
End If

/* 사업장 체크 */
sSaupj= Trim(dw_1.GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_1.SetFocus()
	dw_1.SetColumn('saupj')
	Return -1
End If

If This.Checked = false Then
	dw_insert.DataObject = 'd_sm01_03010_3'
	dw_insert.SetTransObject(sqlca)
	
	If dw_insert.Retrieve(sSaupj, syymm, sCust, sCvcod+'%') <= 0 Then
		f_message_chk(50,'')
	End If	
Else
	dw_insert.DataObject = 'd_sm01_03010_lg_1'
	dw_insert.SetTransObject(sqlca)
	
	select week_sdate, week_ldate into :sdate, :edate from pdtweek where week_sdate = :syymm;
	
	If dw_insert.Retrieve(sSaupj, sDate, eDate) <= 0 Then
		f_message_chk(50,'')
	End If
End If
end event

type pb_1 from u_pb_cal within w_sm40_0055
integer x = 2030
integer y = 64
integer height = 76
integer taborder = 70
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_1.SetColumn('sdate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_1.SetItem(1, 'sdate', gs_code)

end event

type pb_2 from u_pb_cal within w_sm40_0055
integer x = 2601
integer y = 64
integer height = 76
integer taborder = 80
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_1.SetColumn('edate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_1.SetItem(1, 'edate', gs_code)

end event

type dw_gumsu from datawindow within w_sm40_0055
integer x = 41
integer y = 440
integer width = 2171
integer height = 1872
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm40_0055_A"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event clicked;If row <= 0 then
	this.SelectRow(0,False)
	Return
ELSE
	this.SelectRow(0, FALSE)
	this.SelectRow(row,TRUE)
END IF

String ls_saupj , ls_itnbr 
String ls_order_no ,ls_ipno ,ls_factory
Long   i,ll_f

ls_factory 	= Trim(This.Object.factory[row])
//ls_order_no = Trim(This.Object.orderno[row])
ls_itnbr 	= Trim(This.Object.mitnbr[row])

dw_insert.SelectRow(0, FALSE)
For i =1 To dw_insert.RowCount()
	
	ll_f = dw_insert.Find("facgbn = '"+ls_factory+"' and itnbr = '"+ls_itnbr+"'" &
	                      ,i,dw_insert.RowCount() )

   If ll_f > 0 Then
		dw_insert.SelectRow(ll_f,True)
		dw_insert.ScrollToRow(ll_f)
		i = ll_f+1
	End iF
Next





end event

type dw_2 from datawindow within w_sm40_0055
integer x = 41
integer y = 360
integer width = 2171
integer height = 76
integer taborder = 50
string title = "none"
string dataobject = "d_sm40_0050_2"
boolean border = false
boolean livescroll = true
end type

event itemchanged;String ls_value
Long   nCnt

String ls_gubun1 , ls_str1

AcceptText()
Choose Case GetColumnName()
	Case "gubun"
		ls_value =Trim( GetText())
		If isNUll(ls_value) = false Then

			If ls_value <> '%' then
				ls_str1 = "citnbr = '"+ls_value+"' "
			Else
				ls_str1 =""
			End if
		
			dw_gumsu.SetFilter(ls_str1)
			dw_gumsu.Filter()
			dw_gumsu.SetFilter("")
			
		End If
		
End Choose
end event

type st_2 from statictext within w_sm40_0055
integer x = 73
integer y = 324
integer width = 411
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "GM19 검수자료"
alignment alignment = center!
boolean focusrectangle = false
end type

type rr_2 from roundrectangle within w_sm40_0055
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2249
integer y = 348
integer width = 2354
integer height = 1976
integer cornerheight = 40
integer cornerwidth = 55
end type

type p_1 from uo_picture within w_sm40_0055
integer x = 3360
integer y = 24
integer width = 315
boolean bringtotop = true
string picturename = "C:\erpman\image\납품검수대사확정_up.gif"
end type

event clicked;call super::clicked;String ls_saupj , ls_sdate , ls_edate , ls_itnbr ,ls_gubun ,ls_gubun2 
String ls_order_no ,ls_ipno ,ls_factory ,ls_curr ,ls_cvcod
Long   ll_qty ,ll_out_qty 
Double ld_dan
Long   ll_cnt = 0
long   ll_qty_t , ll_out_qty_t
String scvcod  // --공장에 관련된 매출거래처코드.





If dw_1.AcceptText() < 1 Then Return
If dw_2.AcceptText() < 1 Then Return

pointer oldpointer

oldpointer 	= SetPointer(HourGlass!)

ls_saupj 	= Trim(dw_1.Object.saupj[1])
ls_sdate 	= Trim(dw_1.Object.sdate[1])
ls_edate 	= Trim(dw_1.Object.edate[1])
ls_itnbr 	= Trim(dw_1.Object.itnbr[1])
ls_factory	= Trim(dw_1.Object.factory[1])
scvcod		= Trim(dw_1.Object.scvcod[1])

ls_gubun 	= Trim(dw_2.Object.gubun[1])    // 검수자료 확정/미확정
ls_gubun2 	= Trim(dw_3.Object.gubun[1])	  // 출하자료 확정/미확정

If ls_itnbr = '' Or isNull(ls_itnbr)  Then ls_itnbr = '%'

If IsNull(ls_sdate) Or ls_sdate = '' Then
	f_message_chk(1400,'[기간-시작일자]')
	dw_1.SetColumn("sdate")
	dw_1.SetFocus()
	Return
End If

If IsNull(ls_edate) Or ls_edate = '' Then
	f_message_chk(1400,'[기간-종료일자]')
	dw_1.SetColumn("sdate")
	dw_1.SetFocus()
	Return
End If

/* 사업장 체크 */
ls_saupj= Trim(dw_1.GetItemString(1, 'saupj'))
If IsNull(ls_saupj) Or ls_saupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_1.SetFocus()
	dw_1.SetColumn('saupj')
	Return -1
End If

/* 공장 체크 */
If IsNull(ls_factory) Or ls_factory = '' Then
	f_message_chk(1400, '[공장]')
	dw_1.SetFocus()
	dw_1.SetColumn('factory')
	Return -1
End If

If ls_factory = '' Or isNull(ls_factory) Or ls_factory = '.' Then ls_factory = '%'



//============================================================================
Declare gum_su Cursor For

  SELECT A.FACTORY, 
         A.MITNBR ,
         A.BAL_NO,
         A.IPNO,   
         SUM(A.IP_QTY) 
    FROM VAN_GM19 A
   WHERE A.CUSTCD = fun_get_reffpf_value('AD',:ls_saupj , '4')
     AND (A.IP_DATE BETWEEN :ls_sdate AND :ls_edate ) 
	  AND (NVL(A.BAL_NO, '.') = '.' )
     AND ( A.CITNBR IS NULL or A.citnbr = 'N' )
	GROUP BY A.FACTORY, 
            A.MITNBR ,
            A.BAL_NO,
            A.IPNO ;
	  
Open gum_su;

Do While True
	
	Fetch gum_su Into :ls_factory , :ls_itnbr , :ls_order_no ,:ls_ipno, :ll_qty  ;
	
	If SQLCA.SQLCODE <> 0 Then Exit
	
	   If ll_qty = 0 Then
	   	Update van_GM19 Set CITNBR   = 'Y'
								Where sabu    = :gs_sabu
								  and custcd  = fun_get_reffpf_value('AD',:ls_saupj , '4')
								  and factory = :ls_factory 
								  and mitnbr  = :ls_itnbr
								  and BAL_NO  = :ls_order_no
								  and ipno    = :ls_ipno ;
			If sqlca.SQLNRows < 1 Then
			
			messageBox(string(ll_cnt),sqlca.sqlerrText)
			Rollback;
			End if
			
			Continue ;
		End If
		
		ll_cnt++
		
		SetNull(ll_out_qty)
		
		Select sum(ioqty) Into :ll_out_qty
		  From imhist
		 Where sabu   = :gs_sabu
		   and iogbn  = 'O02'
		   and saupj  = :ls_saupj
		   and facgbn = :ls_factory
		   and itnbr  = :ls_itnbr 
		   and lotsno = :ls_order_no
		   and loteno = :ls_ipno 
			;
			
		If ll_out_qty = 0 Or isNull(ll_out_qty) Then
			Continue ;
		End if
		
		If ll_qty <> ll_out_qty Then
			Continue ;
		End iF

		string sSpec = '.';
		
		Select fun_get_reffpf_value('8I',:ls_factory,'1') Into :ls_cvcod From dual ;

//		If mid(ls_factory,1,1) = 'Y' or  mid(ls_factory,1,1) = 'Z'  Then    // 수출여부는 금액별도로 관리. 
//			ld_dan = sqlca.FUN_ERP100000012_1_DDS(is_today ,  ls_itnbr , sSpec,  ls_cvcod , '2',  ls_curr )
//		Else
//			ld_dan = sqlca.FUN_ERP100000012_1_DDS(is_today ,  ls_itnbr , sSpec , ls_cvcod , '1',  ls_curr )
//		End If
		
	
		Update imhist Set yebi1 = :is_today ,
		                  ioprc = :ld_dan ,
								ioamt = trunc(:ld_dan * ioqty , 0 )
		            Where sabu = :gs_sabu
						  and iogbn = 'O02'
						  and saupj = :ls_saupj
						  and facgbn = :ls_factory
						  and itnbr = :ls_itnbr 
						  and lotsno = :ls_order_no
						  and loteno = :ls_ipno  ;
		
		If sqlca.SQLNRows > 0 Then
			
			Update van_GM19 Set CITNBR = 'Y'
								Where sabu    = :gs_sabu
								  and custcd  = fun_get_reffpf_value('AD',:ls_saupj , '4')
								  and factory = :ls_factory 
								  and mitnbr  = :ls_itnbr
								  and BAL_NO  = :ls_order_no
								  and ipno    = :ls_ipno ;
							  
			If sqlca.SQLNRows < 1 Then
				
				messageBox(string(ll_cnt),sqlca.sqlerrText)
				Rollback;
			End if
		Else
			messageBox(string(ll_cnt),sqlca.sqlerrText)
			Rollback;
		End If
							  
Loop

Commit ;

Close gum_su;

// 입고 순번제외 --> 단순히 발주번호만으로 조회

Declare gum_su2 Cursor For

  SELECT A.FACTORY, 
         A.MITNBR ,
         A.BAL_NO ,
         SUM(A.IP_QTY) 
    FROM VAN_GM19 A
   WHERE A.CUSTCD = fun_get_reffpf_value('AD',:ls_saupj , '4')
     AND (A.IP_DATE BETWEEN :ls_sdate AND :ls_edate ) 
     AND ( A.CITNBR IS NULL or A.citnbr = 'N' )
	GROUP BY A.FACTORY, 
            A.MITNBR ,
            A.BAL_NO ;
	  
Open gum_su2;

Do While True
	
	Fetch gum_su2 Into :ls_factory , :ls_itnbr , :ls_order_no , :ll_qty  ;
	
	If SQLCA.SQLCODE <> 0 Then Exit
	   
		ll_cnt++
		
		SetNull(ll_out_qty)
		
		Select sum(ioqty) Into :ll_out_qty
		  From imhist
		 Where sabu   = :gs_sabu
		   and iogbn  = 'O02'
		   and saupj  = :ls_saupj
		   and facgbn = :ls_factory
		   and itnbr  = :ls_itnbr 
		   and lotsno = :ls_order_no
			;
			
		If ll_out_qty = 0 Or isNull(ll_out_qty) Then
			Continue ;
		End if
		
		If ll_qty <> ll_out_qty Then

			Continue ;
		End iF
		
		
		Select fun_get_reffpf_value('8I',:ls_factory,'1') Into :ls_cvcod From dual ;
		
//		If mid(ls_factory,1,1) = 'Y' or  mid(ls_factory,1,1) = 'Z'  Then    // 수출여부는 금액별도로 관리. 
//			ld_dan = sqlca.FUN_ERP100000012_1_DDS(is_today ,  ls_itnbr , sSpec,  ls_cvcod , '2',  ls_curr )
//		Else
//			ld_dan = sqlca.FUN_ERP100000012_1_DDS(is_today ,  ls_itnbr , sSpec , ls_cvcod , '1',  ls_curr )
//		End If
		
	
		Update imhist Set yebi1 = :is_today ,
		                  ioprc = :ld_dan ,
								ioamt = trunc(:ld_dan * ioqty , 0 )
		            Where sabu   = :gs_sabu
						  and iogbn  = 'O02'
						  and saupj  = :ls_saupj
						  and facgbn = :ls_factory
						  and itnbr  = :ls_itnbr 
						  and lotsno = :ls_order_no  ;
		
		If sqlca.SQLNRows > 0 Then
			
			Update van_GM19  Set CITNBR = 'Y'
								Where sabu    = :gs_sabu
								  and custcd  = fun_get_reffpf_value('AD',:ls_saupj , '4')
								  and factory = :ls_factory 
								  and mitnbr  = :ls_itnbr
								  and BAL_NO  = :ls_order_no ;
							  
			If sqlca.SQLNRows < 1 Then
				
				messageBox(string(ll_cnt),sqlca.sqlerrText)
				Rollback;
			End if
		Else
			messageBox(string(ll_cnt),sqlca.sqlerrText)
			Rollback;
		End If
							  
Loop

Commit ;

Close gum_su2;

SetPointer(oldpointer)

p_inq.TriggerEvent(Clicked!)



end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\납품검수대사확정_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\납품검수대사확정_up.gif"
end event

type p_2 from uo_picture within w_sm40_0055
boolean visible = false
integer x = 3369
integer y = 180
integer width = 315
boolean bringtotop = true
string picturename = "C:\erpman\image\납품검수대사취소_up.gif"
end type

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\납품검수대사취소_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\납품검수대사취소_dn.gif"
end event

type dw_3 from datawindow within w_sm40_0055
integer x = 2441
integer y = 360
integer width = 2139
integer height = 76
integer taborder = 60
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm40_0050_2"
boolean border = false
boolean livescroll = true
end type

event itemchanged;String ls_value
Long   nCnt

String ls_gubun1 , ls_str2

Choose Case GetColumnName()
	Case "gubun"
		ls_value =Trim( GetText())
		If isNUll(ls_value) = false Then

			If ls_value = '%' Then
				ls_str2 = ""
			Else
				ls_str2 = "yebi1_temp = '"+ls_value+"' "
			End iF
			
			dw_insert.SetFilter(ls_str2)
			dw_insert.Filter()
			dw_insert.SetFilter("")
			
		End If
		
End Choose
end event

type st_3 from statictext within w_sm40_0055
integer x = 2272
integer y = 324
integer width = 334
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "출하자료"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_imsi from datawindow within w_sm40_0055
boolean visible = false
integer x = 91
integer y = 948
integer width = 3410
integer height = 172
integer taborder = 190
boolean bringtotop = true
string title = "none"
string dataobject = "d_sal_030104"
end type

