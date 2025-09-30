$PBExportHeader$w_sal_03010.srw
$PBExportComments$납품 검수 확인 등록
forward
global type w_sal_03010 from w_inherite
end type
type rb_1 from radiobutton within w_sal_03010
end type
type rb_mod from radiobutton within w_sal_03010
end type
type dw_ip from datawindow within w_sal_03010
end type
type cbx_1 from checkbox within w_sal_03010
end type
type dw_imhist from datawindow within w_sal_03010
end type
type dw_imsi from datawindow within w_sal_03010
end type
type pb_1 from u_pb_cal within w_sal_03010
end type
type pb_2 from u_pb_cal within w_sal_03010
end type
type dw_rate from u_key_enter within w_sal_03010
end type
type cbx_po from checkbox within w_sal_03010
end type
type cbx_rate from checkbox within w_sal_03010
end type
type rb_upd from radiobutton within w_sal_03010
end type
type rr_1 from roundrectangle within w_sal_03010
end type
type rr_2 from roundrectangle within w_sal_03010
end type
type rr_3 from roundrectangle within w_sal_03010
end type
end forward

global type w_sal_03010 from w_inherite
integer width = 4645
integer height = 2552
string title = "납품 검수 확인 등록"
rb_1 rb_1
rb_mod rb_mod
dw_ip dw_ip
cbx_1 cbx_1
dw_imhist dw_imhist
dw_imsi dw_imsi
pb_1 pb_1
pb_2 pb_2
dw_rate dw_rate
cbx_po cbx_po
cbx_rate cbx_rate
rb_upd rb_upd
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
end type
global w_sal_03010 w_sal_03010

forward prototypes
public function integer wf_create_imhist (long nrow, string siojpno, decimal dioqty, string gdate, string chdate, decimal dvatamt)
public function integer wf_geomsu_create (string arg_cvcod)
public function integer wf_calc_amt (long arg_row)
end prototypes

public function integer wf_create_imhist (long nrow, string siojpno, decimal dioqty, string gdate, string chdate, decimal dvatamt);String soldiojpno, snull
Long 	 iCurRow

setnull(sNull)

soldiojpno = dw_insert.GetItemString(nRow, 'iojpno')

If IsNull(sOldIojpNo) Then Return -1

iCurRow = dw_imhist.InsertRow(0)

dw_imhist.SetItem(iCurRow, "SABU", 		dw_insert.GetItemString(nRow, "SABU"))
dw_imhist.SetItem(iCurRow, "IOGBN", 	dw_insert.GetItemString(nRow, "IOGBN"))
dw_imhist.SetItem(iCurRow, "SUDAT", 	dw_insert.GetItemString(nRow, "SUDAT"))
dw_imhist.SetItem(iCurRow, "ITNBR", 	dw_insert.GetItemString(nRow, "ITNBR"))
dw_imhist.SetItem(iCurRow, "PSPEC", 	dw_insert.GetItemString(nRow, "PSPEC"))
dw_imhist.SetItem(iCurRow, "OPSEQ", 	dw_insert.GetItemString(nRow, "OPSEQ"))
dw_imhist.SetItem(iCurRow, "DEPOT_NO", dw_insert.GetItemString(nRow, "DEPOT_NO"))
dw_imhist.SetItem(iCurRow, "CVCOD", 	dw_insert.GetItemString(nRow, "CVCOD"))
dw_imhist.SetItem(iCurRow, "SAREA", 	dw_insert.GetItemString(nRow, "SAREA"))
dw_imhist.SetItem(iCurRow, "PDTGU", 	dw_insert.GetItemString(nRow, "PDTGU"))
dw_imhist.SetItem(iCurRow, "CUST_NO",  dw_insert.GetItemString(nRow, "CUST_NO"))
dw_imhist.SetItem(iCurRow, "IOPRC"	,  dw_insert.GetItemNumber(nRow, "IOPRC"))
dw_imhist.SetItem(iCurRow, "INSDAT"	,  dw_insert.GetItemString(nRow, "INSDAT"))
dw_imhist.SetItem(iCurRow, "INSEMP"	,  dw_insert.GetItemString(nRow, "INSEMP"))
dw_imhist.SetItem(iCurRow, "QCGUB"	,  dw_insert.GetItemString(nRow, "QCGUB"))
dw_imhist.SetItem(iCurRow, "IOFAQTY",  dw_insert.GetItemNumber(nRow, "IOFAQTY"))
dw_imhist.SetItem(iCurRow, "IOPEQTY",  dw_insert.GetItemNumber(nRow, "IOPEQTY"))
dw_imhist.SetItem(iCurRow, "IOSPQTY",  dw_insert.GetItemNumber(nRow, "IOSPQTY"))
dw_imhist.SetItem(iCurRow, "IOCDQTY",  dw_insert.GetItemNumber(nRow, "IOCDQTY"))
dw_imhist.SetItem(iCurRow, "IO_CONFIRM", dw_insert.GetItemString(nRow, "IO_CONFIRM"))
dw_imhist.SetItem(iCurRow, "IO_DATE", 	  gdate)	
dw_imhist.SetItem(iCurRow, "IO_EMPNO",   dw_insert.GetItemString(nRow, "IO_EMPNO"))
dw_imhist.SetItem(iCurRow, "LOTSNO"	, 	  dw_insert.GetItemString(nRow, "LOTSNO"))
dw_imhist.SetItem(iCurRow, "LOTENO"	, 	  dw_insert.GetItemString(nRow, "LOTENO"))
dw_imhist.SetItem(iCurRow, "HOLD_NO", 	  dw_insert.GetItemString(nRow, "HOLD_NO"))
dw_imhist.SetItem(iCurRow, "ORDER_NO",   dw_insert.GetItemString(nRow, "ORDER_NO"))
dw_imhist.SetItem(iCurRow, "INV_NO",	  dw_insert.GetItemString(nRow, "INV_NO"))   
dw_imhist.SetItem(iCurRow, "INV_SEQ", 	  dw_insert.GetItemNumber(nRow, "INV_SEQ"))
dw_imhist.SetItem(iCurRow, "FILSK", 	  dw_insert.GetItemString(nRow, "FILSK"))
dw_imhist.SetItem(iCurRow, "BIGO", 		  dw_insert.GetItemString(nRow, "BIGO"))
dw_imhist.SetItem(iCurRow, "BOTIMH",	  dw_insert.GetItemString(nRow, "BOTIMH"))
dw_imhist.SetItem(iCurRow, "IP_JPNO",	  dw_insert.GetItemString(nRow, "IP_JPNO"))
dw_imhist.SetItem(iCurRow, "ITGU",		  dw_insert.GetItemString(nRow, "ITGU"))
dw_imhist.SetItem(iCurRow, "INPCNF",	  dw_insert.GetItemString(nRow, "INPCNF"))
dw_imhist.SetItem(iCurRow, "JNPCRT",	  dw_insert.GetItemString(nRow, "JNPCRT"))
dw_imhist.SetItem(iCurRow, "OUTCHK",	  dw_insert.GetItemString(nRow, "OUTCHK"))
dw_imhist.SetItem(iCurRow, "MAYYSQ",	  dw_insert.GetItemNumber(nRow, "MAYYSQ"))
dw_imhist.SetItem(iCurRow, "IOREDEPT",   dw_insert.GetItemString(nRow, "IOREDEPT"))
dw_imhist.SetItem(iCurRow, "IOREEMP",	  dw_insert.GetItemString(nRow, "IOREEMP"))
dw_imhist.SetItem(iCurRow, "DCRATE",	  dw_insert.GetItemNumber(nRow, "DCRATE"))
dw_imhist.SetItem(iCurRow, "CHECKNO", 	  dw_insert.GetItemString(nRow, "CHECKNO"))   
dw_imhist.SetItem(iCurRow, "PJT_CD", 	  dw_insert.GetItemString(nRow, "PJT_CD"))
dw_imhist.SetItem(iCurRow, "SAUPJ", 	  dw_insert.GetItemString(nRow, "SAUPJ" ))

dw_imhist.SetItem(iCurRow, "BALSEQ", 	  dw_insert.GetItemnumber(nRow, "BALSEQ" ))
dw_imhist.SetItem(iCurRow, "POBLSQ", 	  dw_insert.GetItemnumber(nRow, "POBLSQ" ))

dw_imhist.SetItem(iCurRow, "YEBI2", 	  dw_insert.GetItemString(nRow, "YEBI2" )) 	//통화단위
dw_imhist.SetItem(iCurRow, "DYEBI1", 	  dw_insert.GetItemnumber(nRow, "DYEBI1" ))	//적용환율
dw_imhist.SetItem(iCurRow, "DYEBI2", 	  dw_insert.GetItemnumber(nRow, "DYEBI2" ))	//외화단가
dw_imhist.SetItem(iCurRow, "LCLGBN", 	  dw_insert.GetItemString(nRow, "LCLGBN" )) 	//내수/수출구분
dw_imhist.SetItem(iCurRow, "IP_JPNO", 	  dw_insert.GetItemString(nRow, "IOJPNO" )) 	//분할전 출고번호

/* 분할내용 */
Decimal{3}  dTemp, dForAmt

dw_imhist.SetItem(iCurRow, "IOJPNO",	sIojpno)	/* 전표번호 */
dw_imhist.SetItem(iCurRow, "IOQTY"	,  dioqty)	/* 분할수량 */

/* 외화금액 */
dForAmt = Truncate(dw_insert.GetItemNumber(nRow, "DYEBI2") * dIoQty, 2)
dw_imhist.SetItem(iCurRow, "FORAMT", 	dForAmt)

/* 원화금액 */
dTemp = Truncate(dw_insert.GetItemNumber(nRow, "IOPRC") * dIoQty, 0)
dw_imhist.SetItem(iCurRow, "IOAMT"	,  dTemp)

dw_imhist.SetItem(iCurRow, "IOREQTY",  dioqty)
dw_imhist.SetItem(iCurRow, "IOSUQTY" , dIoQty)
dw_imhist.SetItem(iCurRow, "CRT_USER", gs_userid) 
dw_imhist.SetItem(iCurRow, "YEBI1", 	snull)	/* 검수일자 */

/* 부가세 */
If dw_imhist.GetItemString(iCurRow, "LCLGBN" ) = 'V' Then
	dw_imhist.setitem(iCurRow,'dyebi3',truncate(dTemp * 0.1,0))
Else
	dw_imhist.setitem(iCurRow,'dyebi3',0)
End If

Return 1
end function

public function integer wf_geomsu_create (string arg_cvcod);//2003.10.1 문규복 추가(1 LINE ~ END LINE)

string ls_GUBUN,ls_DOCCODE,ls_CUSTCD,ls_FACTORY,ls_VAN_ITNBR,ls_IPNO,ls_IPCHKNO,ls_IPDATE,ls_ORDERNO,ls_MITNBR,ls_MCVCOD
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
string ls_imsi_mcvcod,ls_imsi_mitnbr,ls_imsi_ipdate,ls_geomsu_date
double ld_IMSI_IPDAN,ld_pacprc,ld_imsi_packdan
//string ls_imsi_gubun,ls_imsi_doccode,ls_imsi_custcd,ls_imsi_factory,ls_imsi_van_itnbr,ls_imsi_ipno,ls_imsi_ipchkno

pointer oldpointer
oldpointer = SetPointer(HourGlass!)


//CURSOR DELARE
DECLARE SAL_03010 CURSOR FOR
	SELECT A.GUBUN,A.DOCCODE,A.CUSTCD,A.FACTORY,A.ITNBR,A.IPNO,A.IPCHKNO,A.IPDATE,A.IPQTY,A.IPDAN,A.ORDERNO,A.PACKDAN,A.MITNBR,B.ITDSC,B.ISPEC,A.MCVCOD,A.IPSOURCE,A.IPSEQ,A.SUBSEQ
	FROM (
		SELECT 'H' GUBUN,DOCCODE,CUSTCD,FACTORY,ITNBR,IPNO,'' IPCHKNO,IPDATE,IPQTY,IPDAN,ORDERNO,PACKDAN,MITNBR,MCVCOD,IPSOURCE,IPSEQ,SUBSEQ
		FROM VAN_HKCD1
		WHERE SABU = :gs_sabu AND
				MCVCOD like :arg_cvcod
		UNION ALL
		SELECT 'F' GUBUN,DOCCODE,CUSTCD,FACTORY,ITNBR,IPNO,'' IPCHKNO,IPDATE,IPQTY,IPDAN,ORDERNO,PACKDAN,MITNBR,MCVCOD,IPSOURCE,IPSEQ,SUBSEQ
		FROM VAN_MOBISF
		WHERE SABU = :gs_sabu AND
				MCVCOD like :arg_cvcod
		UNION ALL
		SELECT 'C' GUBUN,'' DOCCODE,CUSTCD,FACTORY,ITNBR,'' IPNO,IPCHKNO,IP_DATE IPDATE,IPQTY,0 IPDAN,'' ORDERNO,0 PACKDAN,MITNBR,MCVCOD,'' IPSOURCE,0 IPSEQ,0 SUBSEQ
		FROM VAN_MOBISC
		WHERE SABU = :gs_sabu AND
				MCVCOD like :arg_cvcod) A,ITEMAS B
	WHERE B.ITNBR = A.MITNBR
	ORDER BY A.MCVCOD,A.MITNBR,A.ORDERNO,A.IPDATE;

/* 서열 검수용 */
DECLARE SAL_03010_SUB CURSOR FOR
	SELECT a.sabu,a.iojpno,a.iogbn,a.sudat,a.itnbr,a.pspec,a.opseq,a.depot_no,fun_get_cvnas(a.cvcod) cvnas2 ,a.sarea,a.pdtgu,a.cust_no,a.ioqty,a.ioprc,a.ioamt,a.ioreqty,a.insdat,
			 a.insemp,a.qcgub,a.iofaqty,a.iopeqty,a.iospqty,a.iocdqty,a.iosuqty,a.io_confirm,a.io_date,a.io_empno,a.lotsno,a.loteno,a.hold_no,
			 a.order_no,a.inv_no,a.inv_seq,a.filsk,a.baljpno,a.balseq,a.polcno,a.poblno,a.poblsq,a.bigo,a.botimh,a.ip_jpno,a.itgu,a.sicdat,a.mayymm,
			 a.inpcnf,a.jakjino,a.jaksino,a.jnpcrt,a.outchk,a.mayysq,a.ioredept,a.ioreemp,a.dcrate,a.juksdat,a.jukedat,a.prvprc,a.aftprc,a.silqty,
			 a.silamt,a.gurdat,a.tukdat,a.tukemp,a.tukqty,a.tuksudat,a.crt_date,a.crt_time,a.crt_user,a.upd_date,a.upd_time,a.upd_user,a.checkno,
			 a.pjt_cd,a.field_cd,a.area_cd,a.yebi1,a.yebi2,a.yebi3,a.yebi4,a.dyebi1,a.dyebi2,a.dyebi3,a.cnvfat,a.cnvart,a.cnviore,a.cnviofa,a.cnviope,
			 a.cnviosp,a.cnviocd,a.cnviosu,a.gongqty,a.gongprc,a.saupj,a.pacprc
	FROM (
		SELECT imhist.sabu sabu,iojpno,iogbn,sudat,IMHIST.itnbr itnbr,pspec,opseq,IMHIST.depot_no depot_no,IMHIST.cvcod cvcod,sarea,pdtgu,IMHIST.cust_no cust_no,ioqty,ioprc,ioamt,ioreqty,insdat,
				 insemp,qcgub,iofaqty,iopeqty,iospqty,iocdqty,iosuqty,io_confirm,io_date,io_empno,lotsno,loteno,hold_no,
				 IMHIST.order_no order_no,inv_no,inv_seq,filsk,baljpno,balseq,polcno,poblno,poblsq,bigo,botimh,ip_jpno,itgu,sicdat,mayymm,
				 inpcnf,jakjino,jaksino,jnpcrt,outchk,mayysq,ioredept,ioreemp,dcrate,juksdat,jukedat,prvprc,aftprc,silqty,
				 silamt,gurdat,tukdat,tukemp,tukqty,tuksudat,IMHIST.crt_date,IMHIST.crt_time crt_time,IMHIST.crt_user crt_user,IMHIST.upd_date upd_date,IMHIST.upd_time upd_time,IMHIST.upd_user upd_user,checkno,
				 pjt_cd,field_cd,area_cd,yebi1,yebi2,yebi3,yebi4,dyebi1,dyebi2,dyebi3,cnvfat,cnvart,cnviore,cnviofa,cnviope,
				 cnviosp,cnviocd,cnviosu,gongqty,gongprc,IMHIST.saupj saupj,pacprc
		FROM IMHIST,SORDER
		WHERE IMHIST.SABU = :gs_sabu AND
				SORDER.SABU = :gs_sabu AND
				SORDER.ORDER_NO = IMHIST.ORDER_NO AND
				SORDER.CV_ORDER_NO IS NULL AND
				IMHIST.IO_DATE IS NOT NULL AND 
				IMHIST.CVCOD = :ls_imsi_mcvcod AND
				IMHIST.ITNBR = :ls_imsi_MITNBR AND
				NVL(YEBI1,' ') = ' ' AND
				NVL(CHECKNO,' ') = ' ' 
		UNION ALL
		SELECT imhist.sabu,iojpno,iogbn,sudat,itnbr,pspec,opseq,depot_no,cvcod,sarea,pdtgu,cust_no,ioqty,ioprc,ioamt,ioreqty,insdat,
				 insemp,qcgub,iofaqty,iopeqty,iospqty,iocdqty,iosuqty,io_confirm,io_date,io_empno,lotsno,loteno,hold_no,
				 IMHIST.order_no,inv_no,inv_seq,filsk,baljpno,balseq,polcno,poblno,poblsq,bigo,botimh,ip_jpno,itgu,sicdat,mayymm,
				 inpcnf,jakjino,jaksino,jnpcrt,outchk,mayysq,ioredept,ioreemp,dcrate,juksdat,jukedat,prvprc,aftprc,silqty,
				 silamt,gurdat,tukdat,tukemp,tukqty,tuksudat,IMHIST.crt_date,crt_time,crt_user,upd_date,upd_time,upd_user,checkno,
				 pjt_cd,field_cd,area_cd,yebi1,yebi2,yebi3,yebi4,dyebi1,dyebi2,dyebi3,cnvfat,cnvart,cnviore,cnviofa,cnviope,
				 cnviosp,cnviocd,cnviosu,gongqty,gongprc,saupj,pacprc
		FROM IMHIST
		WHERE IMHIST.SABU = :gs_sabu AND
				IMHIST.ORDER_NO IS NULL AND
				IMHIST.IO_DATE IS NOT NULL AND 
				IMHIST.CVCOD = :ls_imsi_mcvcod AND
				IMHIST.ITNBR = :ls_imsi_MITNBR AND
				NVL(YEBI1,' ') = ' ' AND
				NVL(CHECKNO,' ') = ' ' ) a
	ORDER BY a.CVCOD,a.ITNBR,a.io_date,a.IOQTY DESC ;
		
OPEN SAL_03010;

FETCH SAL_03010 INTO :ls_GUBUN,:ls_DOCCODE,:ls_CUSTCD,:ls_FACTORY,:ls_VAN_ITNBR,:ls_IPNO,:ls_IPCHKNO,:ls_IPDATE,:ld_IPQTY,:ld_IPDAN,:ls_ORDERNO,:ld_PACKDAN,:ls_MITNBR,:ls_ITDSC,:ls_ISPEC,:ls_mcvcod,:ls_ipsource,:ll_ipseq,:ll_subseq;

boolean lb_exit_chk_depth,lb_con_chk
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
	IF not isnull(ls_orderno) and trim(ls_orderno) <> '' then
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
		FROM IMHIST,SORDER
		WHERE IMHIST.SABU = :gs_sabu AND
				SORDER.SABU = :gs_sabu 	AND
				SORDER.ORDER_NO = IMHIST.ORDER_NO AND
				SORDER.CV_ORDER_NO = :ls_orderno AND
				IMHIST.CVCOD = :ls_mcvcod AND
				IMHIST.ITNBR = :ls_MITNBR AND
				NVL(YEBI1,' ') = ' ' AND
				NVL(CHECKNO,' ') = ' ' AND
				IMHIST.IO_DATE IS NOT NULL 
		ORDER BY CVNAS2,IMHIST.ITNBR,io_date;
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
			dw_insert.setitem(li_rowcnt,'ipdate',ls_IPDATE)
			
			//현재값을 임시 dw에 저장
			li_rowcnt_imsi = dw_imsi.insertrow(0)
			dw_imsi.setitem(li_rowcnt_imsi,'imsi_gubun',ls_gubun)
			dw_imsi.setitem(li_rowcnt_imsi,'imsi_doccode',ls_doccode)
			dw_imsi.setitem(li_rowcnt_imsi,'imsi_custcd',ls_custcd)
			dw_imsi.setitem(li_rowcnt_imsi,'imsi_factory',ls_factory)
			dw_imsi.setitem(li_rowcnt_imsi,'imsi_van_itnbr',ls_van_itnbr)
			dw_imsi.setitem(li_rowcnt_imsi,'imsi_ipno',ls_ipno)
			dw_imsi.setitem(li_rowcnt_imsi,'imsi_ipsource',ls_ipsource)
			dw_imsi.setitem(li_rowcnt_imsi,'imsi_ipchkno',ls_ipchkno)
			dw_imsi.setitem(li_rowcnt_imsi,'imsi_orderno',ls_orderno)
			dw_imsi.setitem(li_rowcnt_imsi,'imsi_ipseq',ll_ipseq)
			dw_imsi.setitem(li_rowcnt_imsi,'imsi_subseq',ll_subseq)

			//입고단가
			IF not isnull(ld_IPDAN) and ld_IPDAN > 0 then
				dw_insert.setitem(li_rowcnt,'ioprc'       ,ld_IPDAN)
			ELSE
				dw_insert.setitem(li_rowcnt,'ioprc'       ,ld_ioprc)
			END IF
			//포장단가 
			IF not isnull(ld_packdan) and ld_packdan > 0 then
				dw_insert.setitem(li_rowcnt,'imhist_pacprc',ld_PACKDAN)
			ELSE
				dw_insert.setitem(li_rowcnt,'imhist_pacprc',ld_pacprc)
			END IF
			//납품수량 체크
			if ld_ioqty < ld_IPQTY then
				//납품수량
				dw_insert.setitem(li_rowcnt,'choiceqty',ld_IPQTY - ld_ioqty)
				//합격수량
				dw_insert.setitem(li_rowcnt,'iosuqty',ld_IPQTY - ld_ioqty)
				//수불금액
				dw_insert.setitem(li_rowcnt,'ioamt',(ld_IPQTY - ld_ioqty) * dw_insert.getitemnumber(li_rowcnt,'ioprc'))
				//오버되는 검수수량 값을 van_hkcd1에 저장하기 위해 저장한다.
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
			dw_insert.setitem(li_rowcnt,'gdate',ls_ipdate)
			//van 발주번호 표시
			dw_insert.setitem(li_rowcnt,'van_orderno',ls_ORDERNO)
			//van 체크자료 
//			dw_insert.setitem(li_rowcnt,'gubun',ls_gubun)		
//			dw_insert.setitem(li_rowcnt,'doccode',ls_doccode)
//			dw_insert.setitem(li_rowcnt,'custcd',ls_custcd)
//			dw_insert.setitem(li_rowcnt,'factory',ls_factory)
//			dw_insert.setitem(li_rowcnt,'van_itnbr',ls_van_itnbr)
//			dw_insert.setitem(li_rowcnt,'ipno',ls_ipno)
//			dw_insert.setitem(li_rowcnt,'ipchkno',ls_ipchkno)
			
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
			dw_insert.setitem(li_rowcnt,'lotsno'      ,ls_lotsno)
			dw_insert.setitem(li_rowcnt,'loteno'      ,ls_loteno)
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
			if ls_ipsource = 'D' then
				ls_ipsource = 'L'
			end if
			dw_insert.setitem(li_rowcnt,'lclgbn'       ,ls_ipsource)	
		
			//상태값 변경
			dw_insert.SetItemStatus(li_rowcnt, 0,Primary!,DataModified!)

			dw_insert.scrolltorow(li_rowcnt)
			
			li_write_cnt += 1
		END IF
	END IF

	//서열납품에 대한 처리
	IF isnull(ls_orderno) or trim(ls_orderno) = '' or lb_check_gubun THEN
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
			FROM IMHIST,SORDER
			WHERE IMHIST.SABU = :gs_sabu AND
					SORDER.SABU = :gs_sabu AND
					SORDER.ORDER_NO = IMHIST.ORDER_NO AND
					SORDER.CV_ORDER_NO IS NULL AND
					IMHIST.IO_DATE IS NOT NULL AND 
					IMHIST.CVCOD = :ls_mcvcod AND
					IMHIST.ITNBR = :ls_MITNBR AND
					NVL(YEBI1,' ') = ' ' AND
					NVL(CHECKNO,' ') = ' ' 
			union			
			select itnbr
			FROM IMHIST
			WHERE IMHIST.SABU = :gs_sabu AND
					IMHIST.ORDER_NO IS NULL AND
					IMHIST.IO_DATE IS NOT NULL AND 
					IMHIST.CVCOD = :ls_mcvcod AND
					IMHIST.ITNBR = :ls_MITNBR AND
					NVL(YEBI1,' ') = ' ' AND
					NVL(CHECKNO,' ') = ' ' ) a;
				
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
				dw_imsi.setitem(li_rowcnt_imsi,'imsi_doccode',ls_doccode)
				dw_imsi.setitem(li_rowcnt_imsi,'imsi_custcd',ls_custcd)
				dw_imsi.setitem(li_rowcnt_imsi,'imsi_factory',ls_factory)
				dw_imsi.setitem(li_rowcnt_imsi,'imsi_van_itnbr',ls_van_itnbr)
				dw_imsi.setitem(li_rowcnt_imsi,'imsi_ipno',ls_ipno)
				dw_imsi.setitem(li_rowcnt_imsi,'imsi_ipsource',ls_ipsource)
				dw_imsi.setitem(li_rowcnt_imsi,'imsi_ipchkno',ls_ipchkno)
				dw_imsi.setitem(li_rowcnt_imsi,'imsi_orderno',ls_orderno)
				dw_imsi.setitem(li_rowcnt_imsi,'imsi_ipseq',ll_ipseq)
				dw_imsi.setitem(li_rowcnt_imsi,'imsi_subseq',ll_subseq)
			
				//입고단가
				if not isnull(ld_IPDAN) and   ld_IPDAN <> 0 then
					ld_IMSI_IPDAN = ld_IPDAN
				end IF
				//납품일자,검수일자
				if not isnull(ls_ipdate) and trim(ls_ipdate) <> '' then
					ls_imsi_ipdate = ls_IPDATE
				else
					//납품일자가 없을 경우
					ls_imsi_ipdate = mid(ls_DOCCODE,3,8)
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
			else
				OPEN SAL_03010_SUB;
				FETCH SAL_03010_SUB INTO :ls_sabu,:ls_iojpno,:ls_iogbn,:ls_sudat,:ls_itnbr,:ls_pspec,:ls_opseq,:ls_depot_no,:ls_cvnas2,:ls_sarea,:ls_pdtgu,:ls_cust_no,:ld_ioqty,:ld_ioprc,:ld_ioamt,:ld_ioreqty,:ls_insdat,
						 :ls_insemp,:ls_qcgub,:ld_iofaqty,:ld_iopeqty,:ld_iospqty,:ld_iocdqty,:ld_iosuqty,:ls_io_confirm,:ls_io_date,:ls_io_empno,:ls_lotsno,:ls_loteno,:ls_hold_no,
						 :ls_order_no,:ls_inv_no,:li_inv_seq,:ls_filsk,:ls_baljpno,:li_balseq,:ls_polcno,:ls_poblno,:li_poblsq,:ls_bigo,:ls_botimh,:ls_ip_jpno,:ls_itgu,:ls_sicdat,:ls_mayymm,
						 :ls_inpcnf,:ls_jakjino,:ls_jaksino,:ls_jnpcrt,:ls_outchk,:ll_mayysq,:ls_ioredept,:ls_ioreemp,:ld_dcrate,:ls_juksdat,:ls_jukedat,:ld_prvprc,:ld_aftprc,:ld_silqty,
						 :ld_silamt,:ls_gurdat,:ls_tukdat,:ls_tukemp,:ld_tukqty,:ls_tuksudat,:ls_crt_date,:ls_crt_time,:ls_crt_user,:ls_upd_date,:ls_upd_time,:ls_upd_user,:ls_checkno,
						 :ls_pjt_cd,:ls_field_cd,:ls_area_cd,:ls_yebi1,:ls_yebi2,:ls_yebi3,:ls_yebi4,:ld_dyebi1,:ld_dyebi2,:ld_dyebi3,:ld_cnvfat,:ls_cnvart,:ld_cnviore,:ld_cnviofa,:ld_cnviope,
						 :ld_cnviosp,:ld_cnviocd,:ld_cnviosu,:ld_gongqty,:ld_gongprc,:ls_saupj,:ld_pacprc;

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
					dw_insert.setitem(li_rowcnt,'ipdate',ls_imsi_IPDATE)
					//검수일자
					dw_insert.setitem(li_rowcnt,'gdate',ls_imsi_IPDATE)
					//포장단가 
					dw_insert.setitem(li_rowcnt,'imhist_pacprc',ld_IMSI_PACKDAN)
					
					//van 발주번호 표시
					dw_insert.setitem(li_rowcnt,'van_orderno',ls_ORDERNO)
					//van 체크자료 
//					dw_insert.setitem(li_rowcnt,'gubun',ls_gubun)		
//					dw_insert.setitem(li_rowcnt,'doccode',ls_doccode)
//					dw_insert.setitem(li_rowcnt,'custcd',ls_custcd)
//					dw_insert.setitem(li_rowcnt,'factory',ls_factory)
//					dw_insert.setitem(li_rowcnt,'van_itnbr',ls_van_itnbr)
//					dw_insert.setitem(li_rowcnt,'ipno',ls_ipno)
//					dw_insert.setitem(li_rowcnt,'ipchkno',ls_ipchkno)
					//현재값을 임시 dw에 저장
					li_rowcnt_imsi = dw_imsi.insertrow(0)
					dw_imsi.setitem(li_rowcnt_imsi,'imsi_gubun',ls_gubun)
					dw_imsi.setitem(li_rowcnt_imsi,'imsi_doccode',ls_doccode)
					dw_imsi.setitem(li_rowcnt_imsi,'imsi_custcd',ls_custcd)
					dw_imsi.setitem(li_rowcnt_imsi,'imsi_factory',ls_factory)
					dw_imsi.setitem(li_rowcnt_imsi,'imsi_van_itnbr',ls_van_itnbr)
					dw_imsi.setitem(li_rowcnt_imsi,'imsi_ipno',ls_ipno)
					dw_imsi.setitem(li_rowcnt_imsi,'imsi_ipsource',ls_ipsource)
					dw_imsi.setitem(li_rowcnt_imsi,'imsi_ipchkno',ls_ipchkno)
					dw_imsi.setitem(li_rowcnt_imsi,'imsi_orderno',ls_orderno)
					dw_imsi.setitem(li_rowcnt_imsi,'imsi_ipseq',ll_ipseq)
					dw_imsi.setitem(li_rowcnt_imsi,'imsi_subseq',ll_subseq)

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
					dw_insert.setitem(li_rowcnt,'lotsno'      ,ls_lotsno)
					dw_insert.setitem(li_rowcnt,'loteno'      ,ls_loteno)
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
					if ls_ipsource = 'D' then
						ls_ipsource = 'L'
					end if
					dw_insert.setitem(li_rowcnt,'lclgbn'       ,ls_ipsource)	
					
					dw_insert.scrolltorow(li_rowcnt)
					
					FETCH SAL_03010_SUB INTO :ls_sabu,:ls_iojpno,:ls_iogbn,:ls_sudat,:ls_itnbr,:ls_pspec,:ls_opseq,:ls_depot_no,:ls_cvnas2,:ls_sarea,:ls_pdtgu,:ls_cust_no,:ld_ioqty,:ld_ioprc,:ld_ioamt,:ld_ioreqty,:ls_insdat, 
						 :ls_insemp,:ls_qcgub,:ld_iofaqty,:ld_iopeqty,:ld_iospqty,:ld_iocdqty,:ld_iosuqty,:ls_io_confirm,:ls_io_date,:ls_io_empno,:ls_lotsno,:ls_loteno,:ls_hold_no, 
						 :ls_order_no,:ls_inv_no,:li_inv_seq,:ls_filsk,:ls_baljpno,:li_balseq,:ls_polcno,:ls_poblno,:li_poblsq,:ls_bigo,:ls_botimh,:ls_ip_jpno,:ls_itgu,:ls_sicdat,:ls_mayymm, 
						 :ls_inpcnf,:ls_jakjino,:ls_jaksino,:ls_jnpcrt,:ls_outchk,:ll_mayysq,:ls_ioredept,:ls_ioreemp,:ld_dcrate,:ls_juksdat,:ls_jukedat,:ld_prvprc,:ld_aftprc,:ld_silqty, 
						 :ld_silamt,:ls_gurdat,:ls_tukdat,:ls_tukemp,:ld_tukqty,:ls_tuksudat,:ls_crt_date,:ls_crt_time,:ls_crt_user,:ls_upd_date,:ls_upd_time,:ls_upd_user,:ls_checkno, 
						 :ls_pjt_cd,:ls_field_cd,:ls_area_cd,:ls_yebi1,:ls_yebi2,:ls_yebi3,:ls_yebi4,:ld_dyebi1,:ld_dyebi2,:ld_dyebi3,:ld_cnvfat,:ls_cnvart,:ld_cnviore,:ld_cnviofa,:ld_cnviope, 
						 :ld_cnviosp,:ld_cnviocd,:ld_cnviosu,:ld_gongqty,:ld_gongprc,:ls_saupj,:ld_pacprc;
						 
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
				CLOSE SAL_03010_SUB;

				if li_rowcnt = 0 then
					//현재값을 임시 dw에 저장
					li_rowcnt_imsi = dw_imsi.insertrow(0)
					dw_imsi.setitem(li_rowcnt_imsi,'imsi_gubun',ls_gubun)
					dw_imsi.setitem(li_rowcnt_imsi,'imsi_doccode',ls_doccode)
					dw_imsi.setitem(li_rowcnt_imsi,'imsi_custcd',ls_custcd)
					dw_imsi.setitem(li_rowcnt_imsi,'imsi_factory',ls_factory)
					dw_imsi.setitem(li_rowcnt_imsi,'imsi_van_itnbr',ls_van_itnbr)
					dw_imsi.setitem(li_rowcnt_imsi,'imsi_ipno',ls_ipno)
					dw_imsi.setitem(li_rowcnt_imsi,'imsi_ipsource',ls_ipsource)
					dw_imsi.setitem(li_rowcnt_imsi,'imsi_ipchkno',ls_ipchkno)
					dw_imsi.setitem(li_rowcnt_imsi,'imsi_orderno',ls_orderno)
					dw_imsi.setitem(li_rowcnt_imsi,'imsi_ipseq',ll_ipseq)
					dw_imsi.setitem(li_rowcnt_imsi,'imsi_subseq',ll_subseq)
				end if
				//현재값 셋팅
				ld_tot_ipqty = ld_ipqty
				//입고단가
				if not isnull(ld_IPDAN) and   ld_IPDAN <> 0 then
					ld_IMSI_IPDAN = ld_IPDAN
				end IF
				//납품일자,검수일
				if not isnull(ls_ipdate) and trim(ls_ipdate) <> '' then
					ls_imsi_ipdate = ls_IPDATE
				else
					//납품일자가 없을 경우
					ls_imsi_ipdate = mid(ls_DOCCODE,3,8)
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

	FETCH SAL_03010 INTO :ls_GUBUN,:ls_DOCCODE,:ls_CUSTCD,:ls_FACTORY,:ls_VAN_ITNBR,:ls_IPNO,:ls_IPCHKNO,:ls_IPDATE,:ld_IPQTY,:ld_IPDAN,:ls_ORDERNO,:ld_PACKDAN,:ls_MITNBR,:ls_ITDSC,:ls_ISPEC,:ls_mcvcod,:ls_ipsource,:ll_ipseq,:ll_subseq;
LOOP		
CLOSE SAL_03010;

//마지막 값을 insert_row
if ld_tot_ipqty <> 0  then
	OPEN SAL_03010_SUB;
	FETCH SAL_03010_SUB INTO :ls_sabu,:ls_iojpno,:ls_iogbn,:ls_sudat,:ls_itnbr,:ls_pspec,:ls_opseq,:ls_depot_no,:ls_cvnas2,:ls_sarea,:ls_pdtgu,:ls_cust_no,:ld_ioqty,:ld_ioprc,:ld_ioamt,:ld_ioreqty,:ls_insdat,
			 :ls_insemp,:ls_qcgub,:ld_iofaqty,:ld_iopeqty,:ld_iospqty,:ld_iocdqty,:ld_iosuqty,:ls_io_confirm,:ls_io_date,:ls_io_empno,:ls_lotsno,:ls_loteno,:ls_hold_no,
			 :ls_order_no,:ls_inv_no,:li_inv_seq,:ls_filsk,:ls_baljpno,:li_balseq,:ls_polcno,:ls_poblno,:li_poblsq,:ls_bigo,:ls_botimh,:ls_ip_jpno,:ls_itgu,:ls_sicdat,:ls_mayymm,
			 :ls_inpcnf,:ls_jakjino,:ls_jaksino,:ls_jnpcrt,:ls_outchk,:ll_mayysq,:ls_ioredept,:ls_ioreemp,:ld_dcrate,:ls_juksdat,:ls_jukedat,:ld_prvprc,:ld_aftprc,:ld_silqty,
			 :ld_silamt,:ls_gurdat,:ls_tukdat,:ls_tukemp,:ld_tukqty,:ls_tuksudat,:ls_crt_date,:ls_crt_time,:ls_crt_user,:ls_upd_date,:ls_upd_time,:ls_upd_user,:ls_checkno,
			 :ls_pjt_cd,:ls_field_cd,:ls_area_cd,:ls_yebi1,:ls_yebi2,:ls_yebi3,:ls_yebi4,:ld_dyebi1,:ld_dyebi2,:ld_dyebi3,:ld_cnvfat,:ls_cnvart,:ld_cnviore,:ld_cnviofa,:ld_cnviope,
			 :ld_cnviosp,:ld_cnviocd,:ld_cnviosu,:ld_gongqty,:ld_gongprc,:ls_saupj,:ld_pacprc;

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
		dw_insert.setitem(li_rowcnt,'ipdate',ls_imsi_IPDATE)
		//검수일자
		dw_insert.setitem(li_rowcnt,'gdate',ls_imsi_IPDATE)
		//포장단가 
		dw_insert.setitem(li_rowcnt,'imhist_pacprc',ld_imsi_PACKDAN)
//		//van 발주번호 표시
//		dw_insert.setitem(li_rowcnt,'van_orderno',ls_ORDERNO)
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
		dw_insert.setitem(li_rowcnt,'lotsno'      ,ls_lotsno)
		dw_insert.setitem(li_rowcnt,'loteno'      ,ls_loteno)
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
		if ls_ipsource = 'D' then
			ls_ipsource = 'L'
		end if
		dw_insert.setitem(li_rowcnt,'lclgbn'       ,ls_ipsource)	
		
		dw_insert.scrolltorow(li_rowcnt)
		
		FETCH SAL_03010_SUB INTO :ls_sabu,:ls_iojpno,:ls_iogbn,:ls_sudat,:ls_itnbr,:ls_pspec,:ls_opseq,:ls_depot_no,:ls_cvnas2,:ls_sarea,:ls_pdtgu,:ls_cust_no,:ld_ioqty,:ld_ioprc,:ld_ioamt,:ld_ioreqty,:ls_insdat, 
			 :ls_insemp,:ls_qcgub,:ld_iofaqty,:ld_iopeqty,:ld_iospqty,:ld_iocdqty,:ld_iosuqty,:ls_io_confirm,:ls_io_date,:ls_io_empno,:ls_lotsno,:ls_loteno,:ls_hold_no, 
			 :ls_order_no,:ls_inv_no,:li_inv_seq,:ls_filsk,:ls_baljpno,:li_balseq,:ls_polcno,:ls_poblno,:li_poblsq,:ls_bigo,:ls_botimh,:ls_ip_jpno,:ls_itgu,:ls_sicdat,:ls_mayymm, 
			 :ls_inpcnf,:ls_jakjino,:ls_jaksino,:ls_jnpcrt,:ls_outchk,:ll_mayysq,:ls_ioredept,:ls_ioreemp,:ld_dcrate,:ls_juksdat,:ls_jukedat,:ld_prvprc,:ld_aftprc,:ld_silqty, 
			 :ld_silamt,:ls_gurdat,:ls_tukdat,:ls_tukemp,:ld_tukqty,:ls_tuksudat,:ls_crt_date,:ls_crt_time,:ls_crt_user,:ls_upd_date,:ls_upd_time,:ls_upd_user,:ls_checkno, 
			 :ls_pjt_cd,:ls_field_cd,:ls_area_cd,:ls_yebi1,:ls_yebi2,:ls_yebi3,:ls_yebi4,:ld_dyebi1,:ld_dyebi2,:ld_dyebi3,:ld_cnvfat,:ls_cnvart,:ld_cnviore,:ld_cnviofa,:ld_cnviope, 
			 :ld_cnviosp,:ld_cnviocd,:ld_cnviosu,:ld_gongqty,:ld_gongprc,:ls_saupj,:ld_pacprc;
			 
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
	CLOSE SAL_03010_SUB;
end if
dw_insert.scrolltorow(1)
dw_insert.setcolumn('choiceqty')

SetPointer(oldpointer)

messagebox('확인','자료가 정상적으로 처리되었습니다. ' + '~n' + &
                  '읽은자료['+string(li_read_cnt)+'] 저장자료['+string(li_write_cnt)+']')
RETURN 1
end function

public function integer wf_calc_amt (long arg_row);Dec 	 dIoQty, dChoiceQty, dIoAmt, dyebi2, drate, dforprc, dweight
String sCvcod, sgdate, scurr, sNull

If dw_insert.AcceptText() <> 1 Then Return -1

SetNull(sNull)

If dw_insert.GetItemString(arg_row, 'chk') = 'Y' Then
	// 검수내역 수정인 경우 부가세만 계산
	If rb_upd.Checked Then
		If dw_insert.GetItemString(arg_row, 'lclgbn') = 'V' Then
			dIoAmt = dw_insert.GetItemNumber(arg_row, 'ioamt')
			dw_insert.setitem(arg_row,'dyebi3',truncate(dIoAmt * 0.1,0))
		Else
			dw_insert.setitem(arg_row,'dyebi3',0)
		End If		
	Else
		dIoQty 	  = dw_insert.GetItemNumber(arg_row, 'ioqty')
		dChoiceQty = dw_insert.GetItemNumber(arg_row, 'choiceqty')
		
		sCvcod = dw_insert.GetItemString(arg_row, 'cvcod')
		sGdate = dw_insert.GetItemString(arg_row, 'gdate')		// 검수일자
		drate  = dw_insert.GetItemNumber(arg_row, 'dyebi1')	// 외화환율
		dforprc= dw_insert.GetItemNumber(arg_row, 'dyebi2')	// 외화단가
		sCurr  = dw_insert.GetItemString(arg_row, 'yebi2')		// 통화단위
	
		// 가중치
		If sCurr = 'JPY' Then
			dweight = 100
		Else
			dweight = 1
		End If
			
		// 업체별 환율 적용인 경우
		If cbx_rate.Checked Then
			dRate = 0
			
			// 환율
			If sCurr = 'WON' Then
				dRate = 1
			Else
				SELECT RSTAN INTO :drate FROM CUST_RATEMT WHERE CVCOD = :scvcod AND RDATE = :sgdate AND RCURR = :scurr;
				If IsNull(drate) Or drate = 0 Then
					MessageBox('확인','환율이 등록되지 않았습니다.!!')
					dw_insert.SetItem(arg_row, 'chk' , 'N')
					dw_insert.SetItem(arg_row, 'choiceqty' , 0)
					dw_insert.SetItem(arg_row, 'gdate' , sNull)
					dw_insert.SetItem(arg_row, 'vioamt' , 0)
					dw_insert.SetItem(arg_row, 'vvatamt', 0)
					Return -1
				End If
			End If
		End If
		
		// 원화공급가액
		If IsNull(dRate) Or dRate = 0 Then dRate = 1
		dIoAmt = Round(dforprc * dChoiceQty * dRate/dweight,0)
		dw_insert.SetItem(arg_row, 'vioamt' , dIoAmt)
		
		If dw_insert.GetItemString(arg_row, 'lclgbn') = 'V' Then
			dw_insert.setitem(arg_row,'vvatamt',truncate(dIoAmt * 0.1,0))
		Else
			dw_insert.setitem(arg_row,'vvatamt',0)
		End If
		
		// 적용환율
		dw_insert.setitem(arg_row,'vrate', drate)
	End If
Else
	// 검수수정인 경우에는 해당안됨
	If rb_upd.Checked = False Then
		dw_insert.SetItem(arg_row, 'vioamt' , 0)
		dw_insert.SetItem(arg_row, 'vvatamt', 0)
	End If
End If

return 1
end function

on w_sal_03010.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_mod=create rb_mod
this.dw_ip=create dw_ip
this.cbx_1=create cbx_1
this.dw_imhist=create dw_imhist
this.dw_imsi=create dw_imsi
this.pb_1=create pb_1
this.pb_2=create pb_2
this.dw_rate=create dw_rate
this.cbx_po=create cbx_po
this.cbx_rate=create cbx_rate
this.rb_upd=create rb_upd
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_mod
this.Control[iCurrent+3]=this.dw_ip
this.Control[iCurrent+4]=this.cbx_1
this.Control[iCurrent+5]=this.dw_imhist
this.Control[iCurrent+6]=this.dw_imsi
this.Control[iCurrent+7]=this.pb_1
this.Control[iCurrent+8]=this.pb_2
this.Control[iCurrent+9]=this.dw_rate
this.Control[iCurrent+10]=this.cbx_po
this.Control[iCurrent+11]=this.cbx_rate
this.Control[iCurrent+12]=this.rb_upd
this.Control[iCurrent+13]=this.rr_1
this.Control[iCurrent+14]=this.rr_2
this.Control[iCurrent+15]=this.rr_3
end on

on w_sal_03010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_mod)
destroy(this.dw_ip)
destroy(this.cbx_1)
destroy(this.dw_imhist)
destroy(this.dw_imsi)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.dw_rate)
destroy(this.cbx_po)
destroy(this.cbx_rate)
destroy(this.rb_upd)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
end on

event open;call super::open;PostEvent("ue_open")
end event

event ue_open;call super::ue_open;dw_insert.SetTransObject(sqlca)

dw_ip.SetTransObject(sqlca)
dw_ip.InsertRow(0)
dw_imhist.SetTransObject(sqlca)
dw_rate.SetTransObject(sqlca)

/* User별 관할구역 Setting */
String sarea, steam, saupj

If f_check_sarea(sarea, steam, saupj) = 1 Then
	dw_ip.Modify("areacode.protect=1")
	dw_ip.Modify("deptcode.protect=1")
	dw_ip.Modify("areacode.background.color = 80859087")
	dw_ip.Modify("deptcode.background.color = 80859087")
End If

dw_ip.SetItem(1, 'areacode', sarea)
dw_ip.SetItem(1, 'deptcode', steam)
	
rb_1.TriggerEvent(Clicked!)


// 부가세 사업장 설정
f_mod_saupj(dw_ip, 'saupj')

DataWindowChild state_child
integer rtncode

// 영업팀 설정
f_child_saupj(dw_ip, 'deptcode', gs_saupj)

// 관할구역 설정
f_child_saupj(dw_ip, 'areacode', gs_saupj)

dw_ip.SetItem(1, 'sdatef', left(is_today,6)+'01')
dw_ip.SetItem(1, 'sdatet',is_today)
end event

type dw_insert from w_inherite`dw_insert within w_sal_03010
integer x = 41
integer y = 520
integer width = 4558
integer height = 1800
integer taborder = 30
string dataobject = "d_sal_030101"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event dw_insert::itemchanged;long ix, nRow
String sStatus, sDate, sNull
Double	dQty, dOldQty

SetNull(sNull)

nRow = GetRow()
If nRow <= 0 Then Return

Choose Case GetColumnName()
	Case 'chk'
		// 검수수정인 경우에는 내수/lc구분만 변경가능하다
		If rb_upd.Checked Then
		Else
			If Trim(GetText()) = 'Y' Then		
				sDate =  GetItemString(nRow, 'io_date')
				Setitem(nRow, 'choiceqty', GetItemNumber(nRow,'ioqty'))
			ELSE
				SetNull(sDate )
				SetItem(nRow, "bigo",snull)
				Setitem(nRow, 'choiceqty', 0)
			END IF
			
			If rb_1.Checked = True Then
				SetItem(row,'gdate',sDate)
				SetItem(row,'chdate', GetItemString(row,'io_date'))
				
				Post wf_calc_amt(row)
			ElseIf rb_mod.Checked = True Then
				SetItem(row,'yebi1',sDate)
			End If
		End If
	/* 검수일자 */
	Case 'gdate'
		IF f_datechk(GetText()) = -1 THEN
			f_message_chk(35,'[검수일자]')
			SetItem(nRow, GetColumnName(),sNull)
			Return 1
		End If
		
		If rb_1.checked And cbx_rate.Checked Then
			Post wf_calc_amt(row)
		End If
	/* 출고수량 분할*/
	Case 'choiceqty'
		dQty = Double(GetText())
		If dQty <= 0 Then
			MessageBox('확 인','[검수수량은 0이하로 할 수 없습니다]')
			Return 1
		End If
		
		dOldQty = GetItemNumber(nRow, 'ioqty', Primary!, True)
	
		If dQty > dOldQty Then
			MessageBox('확 인','[검수수량은 출고잔량 이상으로 할 수 없습니다]')
			Return 1
		End If
		
		Post wf_calc_amt(row)
	/* 출고일자 변경 */
	Case 'chdate'
		sDate = Trim(GetText())
		If f_datechk(sDate) <> 1 Then
			f_message_chk(35,'')
			Return 2
		End If
		
		If sDate < GetItemString(nrow, 'sudat') Then
			MessageBox('확인','출고의뢰일자보다 커야합니다')
			Return 2
		End If
	/* 내수/수출 변경 */
	Case 'lclgbn'
		Post wf_calc_amt(row)
End Choose

end event

event dw_insert::updatestart;Long ix

For ix = 1 To This.RowCount()
	Choose Case GetItemStatus(ix,0,Primary!)
		Case NewModified!
			This.SetItem(ix,'crt_user',gs_userid)
		Case DataModified!
			This.SetItem(ix,'upd_user',gs_userid)
	End Choose
Next
end event

event dw_insert::itemerror;call super::itemerror;Return 1
end event

event dw_insert::clicked;call super::clicked;If row > 0 Then
	this.SelectRow(0,false)
	this.SelectRow(row,true)
Else
	this.SelectRow(0,false)
End If
end event

type p_delrow from w_inherite`p_delrow within w_sal_03010
boolean visible = false
integer x = 1294
integer y = 2864
integer taborder = 70
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_sal_03010
boolean visible = false
integer x = 1120
integer y = 2864
integer taborder = 50
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_sal_03010
boolean visible = false
integer x = 3749
integer y = 28
integer taborder = 160
string picturename = "C:\erpman\image\생성_up.gif"
end type

event p_search::ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\생성_dn.gif"
end event

event p_search::ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\생성_up.gif"
end event

event p_search::clicked;call super::clicked;//필수항목 입력자료 체크
If dw_ip.AcceptText() <> 1 Then Return

IF wf_warndataloss("종료") = -1 THEN  
	IF MessageBox("확인","생성작업을 하시겠습니까?",question!, yesno!) = 2 THEN
		return
	END IF
END IF

If parent.rb_1.checked = false Then 
	messagebox('확인','생성 작업은 [등록]에 체크가 되어야 작업이 됩니다.')
	Return
End If

dw_insert.reset()
dw_imsi.reset()

string ls_cvcod
ls_cvcod = dw_ip.GetItemString(1,"custcode")
IF trim(ls_cvcod) ="" OR IsNull(ls_cvcod) THEN
	ls_cvcod = '%'
END IF

//tab order를 변경
//integer li_old_chk,li_old_choiceqty

dw_insert.SetTabOrder('chk', 0)
dw_insert.SetTabOrder('choiceqty', 0)
dw_insert.SetTabOrder('gdate', 0)

//자료를 읽어서 row insert
wf_geomsu_create(ls_cvcod)

p_inq.Enabled = True
p_mod.Enabled = True


p_inq.PictureName = "C:\erpman\image\조회_up.gif"
p_mod.PictureName = "C:\erpman\image\저장_up.gif"
end event

type p_ins from w_inherite`p_ins within w_sal_03010
boolean visible = false
integer x = 946
integer y = 2864
integer taborder = 40
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_sal_03010
integer y = 28
integer taborder = 140
end type

type p_can from w_inherite`p_can within w_sal_03010
integer y = 28
integer taborder = 120
end type

event p_can::clicked;call super::clicked;cbx_1.Checked = False

dw_ip.Setitem(1,"itnbr", '')
dw_ip.Setitem(1,"desc" , '')

dw_rate.Reset()

rb_1.Checked = True
rb_1.TriggerEvent(Clicked!)
end event

type p_print from w_inherite`p_print within w_sal_03010
boolean visible = false
integer x = 782
integer y = 2864
integer taborder = 170
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_sal_03010
integer x = 3922
integer y = 28
end type

event p_inq::clicked;call super::clicked;String sDatef,sDatet, steamcd, sarea, scvcod, sSaupj, sitnbr, ls_ittyp
Long   nRcnt

If dw_ip.AcceptText() <> 1 Then Return
If dw_ip.RowCount() <= 0 Then Return

sDatef   = dw_ip.GetItemString(1,'sdatef')
sDatet   = dw_ip.GetItemString(1,'sdatet')
sSaupj   = dw_ip.GetItemString(1,'saupj')
sitnbr   = dw_ip.GetItemString(1,'itnbr')
ls_ittyp = dw_ip.GetItemString(1,'ittyp')

dw_ip.SetFocus()

IF IsNull(sSaupj) Or sSaupj = '' then
	f_message_chk(30,'[부가사업장]')
	dw_ip.SetColumn("saupj")
	Return
END IF

IF f_datechk(sDatef) <> 1 THEN
	f_message_chk(30,'[출고일자]')
	dw_ip.SetColumn("sdatef")
	Return
END IF

IF f_datechk(sDatet) <> 1 THEN
	f_message_chk(30,'[출고일자]')
	dw_ip.SetColumn("sdatet")
	Return
END IF

If Isnull(sitnbr) or sitnbr = '' then
	sitnbr = '%'
else
	sitnbr = sitnbr + '%'
end if

If Isnull(ls_ittyp) or ls_ittyp = '' then ls_ittyp ='%'

steamcd = Trim(dw_ip.GetItemString(1,'deptcode'))
sarea = Trim(dw_ip.GetItemString(1,'areacode'))
scvcod = Trim(dw_ip.GetItemString(1,'custcode'))
If IsNull(sTeamCd) Then sTeamCd = ''
If IsNull(sArea) Then sArea = ''
If IsNull(sCvcod) Then sCvcod = ''

If cbx_po.Checked = False Then
	If rb_1.Checked = True Then
		nRcnt = dw_insert.Retrieve(gs_sabu,sDatef,sDatet, steamcd+'%', sarea+'%', scvcod+'%', sSaupj, sitnbr,ls_ittyp)
	ElseIf rb_mod.Checked = True Then
		nRcnt = dw_insert.Retrieve(gs_sabu,sDatef,sDatet, steamcd+'%', sarea+'%', scvcod+'%', sSaupj, sitnbr,ls_ittyp)
	ElseIf rb_upd.Checked = True Then
		nRcnt = dw_insert.Retrieve(gs_sabu,sDatef,sDatet, steamcd+'%', sarea+'%', scvcod+'%', sSaupj, sitnbr,ls_ittyp)
	End If
	
	If nRcnt <= 0 Then
		f_message_chk(50,'[납품 검수 확인 등록]')
		dw_ip.Setfocus()
		return
	End If
	
	dw_insert.SetTabOrder('chk', 10)
	If rb_1.Checked = True Then
		dw_insert.SetTabOrder('choiceqty', 20)
		dw_insert.SetTabOrder('gdate', 30)
	End If
Else
	dw_rate.Retrieve(gs_sabu,sDatef,sDatet, scvcod+'%', sSaupj)
End If
end event

type p_del from w_inherite`p_del within w_sal_03010
boolean visible = false
integer x = 1463
integer y = 2852
integer taborder = 110
boolean enabled = false
end type

type p_mod from w_inherite`p_mod within w_sal_03010
integer x = 4096
integer y = 28
integer taborder = 90
end type

event p_mod::clicked;call super::clicked;Long nCnt, ix
String sDate, sNull, LsIoJpNo, sChdate, LS_MITNBR, ls_lclgbn, sOrderNo

Dec	dIoqty, dChoiceQty, dVatAmt, dNewVatAmt=0, dWrate, dWeight, dIoamt
Int 	iMaxIojp, iMaxIoNo, iCurRow=0
SetNull(sNull)

If dw_insert.AcceptText() <> 1 Then Return
If dw_rate.AcceptText() <> 1 Then Return

If f_msg_update() <> 1 Then Return

SetPointer(HourGlass!)

//PO별 환율 변경이 아닌경우
If cbx_po.Checked = False Then
	If dw_insert.RowCount() <= 0 Then Return
	
	/* 검수지정시 */
	If rb_1.Checked = True Then
		dw_imhist.Reset()
		
		nCnt = dw_insert.RowCount()
		
		iMaxIoNo = sqlca.fun_junpyo(gs_sabu, is_today, 'C0')		/*송장번호 채번*/
		IF iMaxIoNo <= 0 THEN
			f_message_chk(51,'')
			ROLLBACK;
			Return -1
		END IF
		commit;
			
		LsIoJpNo = is_today + String(iMaxIoNo,'0000')
	
		For ix = 1 To nCnt
	
			sDate = Trim(dw_insert.GetItemString(ix,'gdate'))
			If IsNull(sDate) Or sDate = '' Then Continue
			/* 출고일자 변경 */
			sChDate = Trim(dw_insert.GetItemString(ix,'chdate'))
			If IsNull(sChDate) Or sChDate = '' Then Continue
	
			dIoQty 	  = dw_insert.GetItemNumber(ix, 'ioqty')
			dChoiceQty = dw_insert.GetItemNumber(ix, 'choiceqty')
			
			If IsNull(dChoiceQty ) Or dChoiceQty = 0 Then Continue
			
			If dChoiceQty > dIoQty Then Continue
			
			//van 자료에 의해 생성된 자료를 삭제 한다.
			string ls_gubun,ls_doccode,ls_custcd,ls_factory,ls_van_itnbr,ls_ipno,ls_ipchkno
	
			Choose Case ( dIoQty - dChoiceQty )
				/* 전체 검수 */
				Case 0
					// 생성에서 입력된 자료가 있으면 작업을 하지 않음
					IF isnull(dw_insert.GetItemString(ix, 'gdate')) or trim(dw_insert.GetItemString(ix, 'gdate')) = '' then
						dw_insert.SetItem(ix, 'yebi1',   sDate)
					else
						dw_insert.SetItem(ix, 'yebi1',   sDate)
					END IF

					// 단가
					dw_insert.setitem(ix,'ioprc', dw_insert.getitemnumber(ix,'vioamt') / dChoiceQty)
					
					// 공급가액
					dw_insert.setitem(ix,'ioamt', dw_insert.getitemnumber(ix,'vioamt'))
					
					//부가세 계산
					dVatAmt = dw_insert.getitemnumber(ix,'vvatamt')
					If IsNull(dVatAmt) Then dVatAmt = 0
					dw_insert.setitem(ix,'dyebi3', dVatAmt)
					
					// 적용환율
					dw_insert.setitem(ix,'dyebi1', dw_insert.getitemnumber(ix,'vrate'))
					
//					if dw_insert.getitemstring(ix,'chk') = 'Y' then
//						If dw_insert.GetItemString(ix, 'lclgbn') = 'V' Then
//							dw_insert.setitem(ix,'dyebi3',truncate(dw_insert.getitemnumber(ix,'ioamt') * 0.1,0))
//						Else
//							dw_insert.setitem(ix,'dyebi3',0)
//						End If
//					End If
				/* 분할검수 */
				Case is > 0
					dw_insert.SetItem(ix, 'yebi1',   sDate)
					dw_insert.SetItem(ix, 'ioqty', 	dChoiceQty)
					dw_insert.SetItem(ix, 'ioreqty', dChoiceQty)
					dw_insert.SetItem(ix, 'iosuqty', 0)
	
					// 단가
					dw_insert.setitem(ix,'ioprc', dw_insert.getitemnumber(ix,'vioamt') / dChoiceQty)
					
					// 공급가액
					dw_insert.setitem(ix,'ioamt', dw_insert.getitemnumber(ix,'vioamt'))
					
					dVatAmt = dw_insert.getitemnumber(ix,'vvatamt')
					If IsNull(dVatAmt) Then dVatAmt = 0
					dw_insert.setitem(ix,'dyebi3', dVatAmt)

					// 적용환율
					dw_insert.setitem(ix,'dyebi1', dw_insert.getitemnumber(ix,'vrate'))
					
					iCurRow += 1
	
					If wf_create_imhist(ix, LsIoJpNo+String(iCurRow,'000'), dIoqty - dChoiceQty, sDate, sChdate, 0) <> 1 Then
						RollBack;
						f_message_chk(32,'[분할중 오류]')
						Return
					End If
	//			Case is < 0
			End Choose
		Next
	ELSEIf rb_mod.Checked = True Then	        // --- 검수일자 삭제시
		For ix = 1 To nCnt
			dw_insert.setitem(ix,'ioamt',0)
			dw_insert.setitem(ix,'ioprc',0)
			dw_insert.SetItem(ix,'yebi1',   " ")
		Next
	End If
	
	
	//dw_imsi에 저장된 van자료 삭제
//	double ld_imsi_chuga_su,ld_imsi_ipdan,ld_imsi_packdan
//	long ll_ipseq,ll_subseq
//	string ls_orderno,ls_ipsource
//	nCnt = dw_imsi.rowcount()
//	For ix = 1 To nCnt
//		ls_gubun 		= dw_imsi.getitemstring(ix,'imsi_gubun')		
//		ls_doccode 	= dw_imsi.getitemstring(ix,'imsi_doccode')
//		ls_custcd	 	= dw_imsi.getitemstring(ix,'imsi_custcd')
//		ls_factory 	= dw_imsi.getitemstring(ix,'imsi_factory')
//		ls_van_itnbr 	= dw_imsi.getitemstring(ix,'imsi_van_itnbr')
//		ls_ipno 		= dw_imsi.getitemstring(ix,'imsi_ipno')
//		ls_ipsource 	= dw_imsi.getitemstring(ix,'imsi_ipsource')
//		ls_orderno 	= dw_imsi.getitemstring(ix,'imsi_orderno')
//		ls_ipchkno 	= dw_imsi.getitemstring(ix,'imsi_ipchkno')
//		ld_imsi_chuga_su = dw_imsi.getitemnumber(ix,'imsi_chuga_su')
//		ld_imsi_ipdan = dw_imsi.getitemnumber(ix,'imsi_ipdan')
//		ld_imsi_packdan = dw_imsi.getitemnumber(ix,'imsi_packdan')
//		ll_ipseq 		= dw_imsi.getitemnumber(ix,'imsi_ipseq')
//		ll_subseq 	= dw_imsi.getitemnumber(ix,'imsi_subseq')
//		//미납수량이 있을 경우 van_hkcd1에 update
//		IF ld_imsi_chuga_su > 0 then
//			IF ls_gubun = 'H' Then
//				UPDATE VAN_HKCD1
//				SET IPDAN = :ld_imsi_ipdan,
//					 PACKDAN =  :ld_imsi_packdan,
//					 IPQTY = :ld_imsi_chuga_su,
//					 FIL = 'Y'
//				WHERE SABU = :gs_sabu AND
//						DOCCODE = :ls_doccode AND
//						CUSTCD = :ls_custcd AND
//						FACTORY = :ls_factory AND
//						ITNBR = :ls_van_itnbr AND
//						IPNO = :ls_ipno AND
//						IPSOURCE = :ls_ipsource AND
//						ORDERNO = :ls_orderno AND
//						IPSEQ = :ll_ipseq AND
//						SUBSEQ = :ll_subseq;
//				IF sqlca.sqlcode <> 0 THEN
//					f_message_chk(32,'[VAN(HKCD1) 변경에러]')
//				END IF
//			ElseIF ls_gubun = 'F' THEN
//				UPDATE VAN_MOBISF
//				SET IPDAN = :ld_imsi_ipdan,
//					 PACKDAN =  :ld_imsi_packdan,
//					 IPQTY = :ld_imsi_chuga_su,
//					 FIL = 'Y'
//				WHERE SABU = :gs_sabu AND
//						DOCCODE = :ls_doccode AND
//						CUSTCD = :ls_custcd AND
//						FACTORY = :ls_factory AND
//						ITNBR = :ls_van_itnbr AND
//						IPNO = :ls_ipno AND
//						IPSEQ = :ll_ipseq AND
//						SUBSEQ = :ll_subseq;
//				IF sqlca.sqlcode <> 0 THEN
//					f_message_chk(32,'[VAN(MOBISF) 삭제에러]')
//				END IF
//			ELSEIF ls_gubun = 'C' THEN
//				UPDATE VAN_MOBISC
//				SET IPQTY = :ld_imsi_chuga_su,
//					 FILLER = 'Y'
//				WHERE SABU = :gs_sabu AND
//						CUSTCD = :ls_custcd AND
//						IPCHKNO = :ls_ipchkno;
//				IF sqlca.sqlcode <> 0 THEN
//					f_message_chk(32,'[VAN(MOBISC) 삭제에러]')
//				END IF
//			END IF
//		ELSE
//			IF ls_gubun = 'H' Then
//				DELETE 
//				FROM VAN_HKCD1
//				WHERE SABU = :gs_sabu AND
//						DOCCODE = :ls_doccode AND
//						CUSTCD = :ls_custcd AND
//						FACTORY = :ls_factory AND
//						ITNBR = :ls_van_itnbr AND
//						IPNO = :ls_ipno AND
//						IPSOURCE = :ls_ipsource AND
//						ORDERNO = :ls_orderno AND
//						IPSEQ = :ll_ipseq AND
//						SUBSEQ = :ll_subseq;
//				IF sqlca.sqlcode <> 0 THEN
//					f_message_chk(32,'[VAN(HKCD1) 삭제에러]')
//				END IF
//			ElseIF ls_gubun = 'F' THEN
//				DELETE 
//				FROM VAN_MOBISF
//				WHERE SABU = :gs_sabu AND
//						DOCCODE = :ls_doccode AND
//						CUSTCD = :ls_custcd AND
//						FACTORY = :ls_factory AND
//						ITNBR = :ls_van_itnbr AND
//						IPNO = :ls_ipno AND
//						IPSEQ = :ll_ipseq AND
//						SUBSEQ = :ll_subseq;
//				IF sqlca.sqlcode <> 0 THEN
//					f_message_chk(32,'[VAN(MOBISF) 삭제에러]')
//				END IF
//			ELSEIF ls_gubun = 'C' THEN
//				DELETE 
//				FROM VAN_MOBISC
//				WHERE SABU = :gs_sabu AND
//						CUSTCD = :ls_custcd AND
//						IPCHKNO = :ls_ipchkno;
//				IF sqlca.sqlcode <> 0 THEN
//					f_message_chk(32,'[VAN(MOBISC) 삭제에러]')
//				END IF
//			End If
//		END IF
//	Next
//	
//	//남아있는 van자료에 체크값 설정
//	UPDATE VAN_HKCD1
//	SET FIL = 'C'
//	WHERE NVL(FIL,0) <> 'Y';
//	
//	UPDATE VAN_MOBISF
//	SET FIL = 'C'
//	WHERE NVL(FIL,0) <> 'Y';
//	
//	UPDATE VAN_MOBISC
//	SET FILLER = 'C'
//	WHERE NVL(FILLER,0) <> 'Y';
	
	If dw_insert.Update() <> 1 Then
		RollBack;
		f_message_chk(32,'header')
		Return
	End If
	
	If dw_imhist.RowCount() > 0 Then
		If dw_imhist.Update() <> 1 Then
			RollBack;
			f_message_chk(32,'[분할저장중 오류]')
			Return
		End If
	End If
	
	commit;
Else
//PO별 환율 변경인 경우
	If dw_rate.RowCount() <= 0 Then Return
	
	// 환율이 변경되 내역만 반영한다
	For ix = 1 To dw_rate.RowCount()
		If dw_rate.GEtItemString(ix, 'chk') = 'N' then continue
		
//		If dw_rate.GetItemNumber(ix, 'wrate') = dw_rate.GetItemNumber(ix, 'old_wrate') Then Continue
		
		sOrderNo = dw_rate.GetItemString(ix, 'order_no')
		dWrate	= dw_rate.GetItemNumber(ix, 'wrate')
		If IsNull(dWrate) Or dWrate <= 0 Then Continue
		
		dWeight	= dw_rate.GetItemNumber(ix, 'weight')
		If IsNull(dWeight) Or dWeight <= 0 Then dWeight = 1
		
		// header 정보 저장
		UPDATE SORDER_HEAD SET WRATE = :dWrate WHERE SABU = :gs_sabu AND ORDER_NO = :sOrderNo;
		If SQLCA.SQLCODE <> 0 Then
			MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
			RollBack;
			dw_rate.Reset()
			Return
		End If

		// 수주 정보 저장
		UPDATE SORDER 
		   SET ORDER_PRC = ROUND(ROUND(ITMAMT * :dwrate / :dWeight,0) / ORDER_QTY,3),
			    CHNG_PRC  = ROUND(ROUND(ITMAMT * :dwrate / :dWeight,0) / ORDER_QTY,3),
			    ORDER_AMT = ROUND(ITMAMT * :dwrate / :dWeight,0)
		 WHERE SABU = :gs_sabu 
		   AND ORDER_NO LIKE :sOrderNo||'%'
			AND SUJU_STS <> '8';
		 
		If SQLCA.SQLCODE <> 0 Then
			MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
			RollBack;
			dw_rate.Reset()
			Return
		End If

		// 출고 정보 저장(미검수대상만)
		UPDATE IMHIST
		   SET DYEBI1 = :dwrate,
			    IOPRC  = ROUND(ROUND(FORAMT * :dwrate / :dWeight,0)/ IOQTY,3),
				 IOAMT  = ROUND(FORAMT * :dwrate / :dWeight,0),
				 DYEBI3 = DECODE(LCLGBN,'L',0,TRUNC(ROUND(FORAMT * :dwrate / :dWeight,0) * 0.1,0) )
		 WHERE SABU = :gs_sabu 
		   AND ORDER_NO LIKE :sOrderNo||'%'
			AND IO_DATE IS NOT NULL
			AND YEBI1 IS NULL;
		 
		If SQLCA.SQLCODE <> 0 Then
			MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
			RollBack;
			dw_rate.Reset()
			Return
		End If
		
		COMMIT;
	Next
End If

MESSAGEBOX('Message','자료가 정상적으로 처리되었습니다.')

sle_msg.Text = '자료를 저장하였습니다.!!'

dw_insert.REset()
dw_imhist.Reset()
end event

type cb_exit from w_inherite`cb_exit within w_sal_03010
integer x = 2373
integer y = 2872
integer taborder = 130
boolean enabled = false
end type

type cb_mod from w_inherite`cb_mod within w_sal_03010
integer x = 1659
integer y = 2876
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within w_sal_03010
integer x = 320
integer y = 2808
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_sal_03010
integer x = 1266
integer y = 2864
integer width = 498
integer taborder = 100
boolean enabled = false
string text = "이월취소(&D)"
end type

type cb_inq from w_inherite`cb_inq within w_sal_03010
integer x = 183
integer y = 2888
integer taborder = 60
boolean enabled = false
end type

type cb_print from w_inherite`cb_print within w_sal_03010
integer x = 1033
integer y = 2808
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_sal_03010
end type

type cb_can from w_inherite`cb_can within w_sal_03010
integer x = 2016
integer y = 2872
boolean enabled = false
end type

type cb_search from w_inherite`cb_search within w_sal_03010
integer x = 754
integer y = 2764
integer width = 498
integer taborder = 80
boolean enabled = false
string text = "이월처리(&W)"
end type







type gb_button1 from w_inherite`gb_button1 within w_sal_03010
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_03010
end type

type rb_1 from radiobutton within w_sal_03010
integer x = 73
integer y = 60
integer width = 334
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "검수확인"
boolean checked = true
end type

event clicked;dw_insert.SetRedraw(False)
dw_insert.DataObject = 'd_sal_030101'
dw_insert.SetTransObject(SQLCA)

dw_insert.SetRedraw(True)

cb_search.Enabled = True
cb_del.Enabled = False

dw_insert.SetFocus()

cbx_1.Checked = False
dw_ip.Modify("sdate_t.text='출고기간'")
dw_ip.SetFocus()
dw_ip.SetColumn('sdatef')
end event

type rb_mod from radiobutton within w_sal_03010
integer x = 453
integer y = 60
integer width = 334
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "검수취소"
end type

event clicked;dw_insert.SetRedraw(False)
dw_insert.DataObject = 'd_sal_030102'
dw_insert.SetTransObject(SQLCA)
dw_insert.SetRedraw(True)

cb_search.Enabled = True
cb_del.Enabled = False

dw_insert.SetFocus()

cbx_1.Checked = False

dw_ip.SetFocus()
dw_ip.SetColumn('sdatef')

cb_search.Enabled = False
cb_del.Enabled = True

cbx_1.Checked = False
dw_ip.Modify("sdate_t.text='검수기간'")
dw_ip.SetFocus()
dw_ip.SetColumn('sdatef')
end event

type dw_ip from datawindow within w_sal_03010
event ue_processenter pbm_dwnprocessenter
integer x = 27
integer y = 172
integer width = 3694
integer height = 312
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_sal_030103"
boolean border = false
boolean livescroll = true
end type

event ue_processenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;String  sDateFrom, sDateTo, snull, sPrtGbn, sitnbr, sdesc
String sarea, steam, sCvcod, scvnas, sSaupj, sName1

SetNull(snull)

Choose Case GetColumnName()
	Case 'saupj'
		sSaupj = Trim(GetText())

		// 영업팀/관할구역 설정
		f_child_saupj(dw_ip, 'deptcode', sSaupj)
		f_child_saupj(dw_ip, 'areacode', sSaupj)
	Case"sdatef"
		sDateFrom = Trim(this.GetText())
		IF sDateFrom ="" OR IsNull(sDateFrom) THEN RETURN
		
		IF f_datechk(sDateFrom) = -1 THEN
			f_message_chk(35,'[출고기간]')
			this.SetItem(1,"sdatef",snull)
			Return 1
		END IF
	Case "sdatet"
		sDateTo = Trim(this.GetText())
		IF sDateTo ="" OR IsNull(sDateTo) THEN RETURN
		
		IF f_datechk(sDateTo) = -1 THEN
			f_message_chk(35,'[출고기간]')
			this.SetItem(1,"sdatet",snull)
			Return 1
		END IF
	/* 영업팀 */
	Case "deptcode"
		SetItem(1,'areacode',sNull)
		SetItem(1,"custcode",sNull)
		SetItem(1,"custname",sNull)
	/* 관할구역 */
	Case "areacode"
		SetItem(1,"custcode",sNull)
		SetItem(1,"custname",sNull)
		
		sArea = Trim(GetText())
		IF sArea = "" OR IsNull(sArea) THEN RETURN
		
		SELECT "SAREA"."SAREA" ,"SAREA"."STEAMCD" 	INTO :sArea  ,:steam
		  FROM "SAREA"  
		 WHERE "SAREA"."SAREA" = :sArea   ;
		
		SetItem(1,'deptcode',steam)
	/* 거래처 */
	Case "custcode"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"custname",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'custcode', sNull)
			SetItem(1, 'custname', snull)
			Return 1
		ELSE		
			SetItem(1,"saupj",   	ssaupj)
			// 영업팀/관할구역 설정
//			f_child_saupj(dw_ip, 'deptcode', sSaupj)
//			f_child_saupj(dw_ip, 'areacode', sSaupj)
//			
//			SetItem(1,"deptcode",   steam)
//			SetItem(1,"areacode",   sarea)
			SetItem(1,"custname",	scvnas)
		END IF
	/* 거래처명 */
	Case "custname"
		scvnas = Trim(GetText())
		IF scvnas ="" OR IsNull(scvnas) THEN
			SetItem(1,"custcode",snull)
			Return
		END IF
		
		If f_get_cvnames('2', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'custcode', sNull)
			SetItem(1, 'custname', snull)
			Return 1
		ELSE
			SetItem(1,"saupj",    ssaupj)
			
			// 영업팀/관할구역 설정
			f_child_saupj(dw_ip, 'deptcode', sSaupj)
			f_child_saupj(dw_ip, 'areacode', sSaupj)
			
			SetItem(1,"deptcode", steam)
			SetItem(1,"areacode", sarea)
			SetItem(1,'custcode', sCvcod)
			SetItem(1,"custname", scvnas)
			Return 1
		END IF
		
	Case "itnbr"
		sitnbr = Trim(GetText())
		IF sitnbr ="" OR IsNull(sitnbr) THEN
			SetItem(1,"itnbr",snull)
			SetItem(1,"desc" ,snull)
			Return
		END IF
		
		select Nvl(itdsc, null)
		  into :sdesc
		 From itemas
		 Where itnbr = :sitnbr; 
		    if sqlca.sqlcode = 0 then
				 SetItem(1, "desc" , sdesc)
			else
				 SetItem(1, "itnbr", snull)
				 SetItem(1, "desc" , snull)
			end if
END Choose
end event

event itemerror;return 1
end event

event rbuttondown;SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

Choose Case this.GetColumnName() 
	/* 거래처 */
	Case "custcode", "custname"
		gs_gubun = '1'
		If GetColumnName() = "custname" then
			gs_codename = Trim(GetText())
		End If
		Open(w_vndmst_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"custcode",gs_code)
		SetColumn("custcode")
		TriggerEvent(ItemChanged!)
		
	Case "itnbr"
		gs_gubun = '1'
		If GetColumnName() = "desc" then
			gs_codename = Trim(GetText())
		End If
		Open(w_itemas_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"itnbr", gs_code)
		SetItem(1,"desc" , gs_codename)
		SetColumn("itnbr")
		
END Choose

end event

type cbx_1 from checkbox within w_sal_03010
integer x = 4242
integer y = 396
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
long backcolor = 33027312
string text = "전체선택"
end type

event clicked;long ix
String sStatus, sDate

IF This.Checked = True THEN
	sDate = is_today
	sStatus = 'Y'
ELSE
	sStatus = 'N'
	SetNull(sDate )
END IF

For ix = 1 To dw_insert.RowCount()
	dw_insert.SetItem(ix,'chk',sStatus)
	
	If rb_1.Checked = True Then
		dw_insert.SetItem(ix,'gdate',  dw_insert.GetItemString(ix,'io_date'))
		dw_insert.SetItem(ix,'chdate', dw_insert.GetItemString(ix,'io_date'))
		
		If sStatus = 'Y' Then
			dw_insert.SetItem(ix,'choiceqty', dw_insert.GetItemNumber(ix,'ioqty'))
		Else
			dw_insert.SetItem(ix,'choiceqty', 0)
		End If
		
		wf_calc_amt(ix)
	ElseIf rb_mod.Checked = True Then
		dw_insert.SetItem(ix,'yebi1',sDate)
	End If
Next


end event

type dw_imhist from datawindow within w_sal_03010
boolean visible = false
integer x = 78
integer y = 1600
integer width = 4384
integer height = 240
integer taborder = 150
boolean bringtotop = true
boolean enabled = false
string dataobject = "d_sal_020402"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_imsi from datawindow within w_sal_03010
boolean visible = false
integer x = 91
integer y = 948
integer width = 3410
integer height = 172
integer taborder = 180
boolean bringtotop = true
string title = "none"
string dataobject = "d_sal_030104"
boolean border = false
end type

type pb_1 from u_pb_cal within w_sal_03010
integer x = 718
integer y = 304
integer width = 82
integer height = 76
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('sdatef')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'sdatef', gs_code)

end event

type pb_2 from u_pb_cal within w_sal_03010
integer x = 1152
integer y = 304
integer width = 82
integer height = 76
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('sdatet')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'sdatet', gs_code)

end event

type dw_rate from u_key_enter within w_sal_03010
boolean visible = false
integer x = 37
integer y = 520
integer width = 4558
integer height = 1800
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_sal_03010_1"
boolean vscrollbar = true
boolean border = false
end type

type cbx_po from checkbox within w_sal_03010
integer x = 3145
integer y = 108
integer width = 494
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "PO별 환율 변경"
end type

event clicked;If Checked Then
	dw_rate.visible = True
Else
	dw_rate.visible = False
	dw_rate.Reset()
End If
end event

type cbx_rate from checkbox within w_sal_03010
integer x = 2469
integer y = 400
integer width = 576
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "업체별 환율 적용"
end type

event clicked;If This.Checked Then
	cbx_1.Enabled = False
Else
	cbx_1.Enabled = True
End If
end event

type rb_upd from radiobutton within w_sal_03010
integer x = 832
integer y = 68
integer width = 457
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "검수수정"
end type

event clicked;dw_insert.SetRedraw(False)
dw_insert.DataObject = 'd_sal_030105'
dw_insert.SetTransObject(SQLCA)
dw_insert.SetRedraw(True)

cb_search.Enabled = True
cb_del.Enabled = False

dw_insert.SetFocus()

cbx_1.Checked = False

dw_ip.SetFocus()
dw_ip.SetColumn('sdatef')

cb_search.Enabled = False
cb_del.Enabled = True

cbx_1.Checked = False
dw_ip.Modify("sdate_t.text='검수기간'")
dw_ip.SetFocus()
dw_ip.SetColumn('sdatef')
end event

type rr_1 from roundrectangle within w_sal_03010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 512
integer width = 4585
integer height = 1824
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_sal_03010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 32
integer y = 24
integer width = 1344
integer height = 144
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_sal_03010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 4206
integer y = 380
integer width = 393
integer height = 108
integer cornerheight = 40
integer cornerwidth = 55
end type

