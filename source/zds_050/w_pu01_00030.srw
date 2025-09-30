$PBExportHeader$w_pu01_00030.srw
$PBExportComments$** 주간 구매계획
forward
global type w_pu01_00030 from w_inherite
end type
type rr_2 from roundrectangle within w_pu01_00030
end type
type dw_4 from datawindow within w_pu01_00030
end type
type st_info from statictext within w_pu01_00030
end type
type st_info2 from statictext within w_pu01_00030
end type
type rr_1 from roundrectangle within w_pu01_00030
end type
type st_info1 from statictext within w_pu01_00030
end type
type dw_6 from datawindow within w_pu01_00030
end type
type dw_3 from datawindow within w_pu01_00030
end type
type dw_1 from u_key_enter within w_pu01_00030
end type
type dw_41 from datawindow within w_pu01_00030
end type
type dw_insert2 from datawindow within w_pu01_00030
end type
type dw_7 from datawindow within w_pu01_00030
end type
type p_1 from picture within w_pu01_00030
end type
type dw_chart from datawindow within w_pu01_00030
end type
type pb_1 from u_pb_cal within w_pu01_00030
end type
type dw_hidden from datawindow within w_pu01_00030
end type
type p_2 from picture within w_pu01_00030
end type
type dw_2 from datawindow within w_pu01_00030
end type
type st_2 from statictext within w_pu01_00030
end type
type cb_1 from commandbutton within w_pu01_00030
end type
type rr_4 from roundrectangle within w_pu01_00030
end type
end forward

global type w_pu01_00030 from w_inherite
integer width = 5280
integer height = 3516
string title = "주간 구매계획"
rr_2 rr_2
dw_4 dw_4
st_info st_info
st_info2 st_info2
rr_1 rr_1
st_info1 st_info1
dw_6 dw_6
dw_3 dw_3
dw_1 dw_1
dw_41 dw_41
dw_insert2 dw_insert2
dw_7 dw_7
p_1 p_1
dw_chart dw_chart
pb_1 pb_1
dw_hidden dw_hidden
p_2 p_2
dw_2 dw_2
st_2 st_2
cb_1 cb_1
rr_4 rr_4
end type
global w_pu01_00030 w_pu01_00030

type variables
str_itnct str_sitnct
end variables

forward prototypes
public subroutine wf_set_dayqty ()
public function decimal wf_sum_napqty (datawindow arg_dw, string arg_itnbr)
public subroutine wf_set_balqty ()
public subroutine wf_set_orgqty ()
public subroutine wf_calc_shrat ()
public subroutine wf_set_info (datawindow arg_dw, long arg_row)
public subroutine wf_initial ()
public subroutine wf_calc_point2 (string arg_seqno)
public subroutine wf_calc_point (string arg_seqno)
public subroutine wf_set_qtp_org ()
public subroutine wf_set_porate ()
public function integer wf_delete_pu_plan ()
public function integer wf_trans_ps_plan ()
public function integer wf_check_pm_plan ()
public function integer wf_calc_sagub ()
public function integer wf_calc_sagub2 ()
public subroutine wf_calc_needqty (string arg_seqno)
public subroutine wf_set_magamyn ()
public subroutine wf_get_plan (string syymmdd)
public function integer wf_check_ps_plan ()
public function integer wf_chart (long ar_row)
public subroutine wf_excel_down (datawindow adw_excel)
public subroutine wf_set_ckd_qty ()
public function integer wf_qty (long row)
end prototypes

public subroutine wf_set_dayqty ();long		lrow
string	sitnbr, scvcod
decimal	dtotqty, djgoqty, dnetqty, drate, dvndqty, dweekcnt, ddayqty, dshrat, dminqt

dw_insert.accepttext()


////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 주 분할량
FOR lrow = 1 TO dw_insert.rowcount()
	sitnbr  = dw_insert.getitemstring(lrow,"itnbr")
	scvcod  = dw_insert.getitemstring(lrow,"cvcod")
	
	dtotqty = dw_insert.getitemnumber(lrow,"totqty")	// 총소요량
	djgoqty = dw_insert.getitemnumber(lrow,"jgoqty")	// 현재고량
	dnetqty = dtotqty - djgoqty 								// 순소요량
	if dnetqty <= 0  then dnetqty = 0
	
	
	drate   = dw_insert.getitemnumber(lrow,"porate")	// 업체 발주비율
	dvndqty = round(dnetqty*drate,0)							// 업체 할당량
	
	dweekcnt= dw_insert.getitemnumber(lrow,"weekcnt")	// 업체 납입횟수
	dshrat  = dw_insert.getitemnumber(lrow,"shrat")		// 소재불량율
	dminqt  = dw_insert.getitemnumber(lrow,"minqt")		// 최소발주량(용기)
	if isnull(dminqt) or dminqt <= 0 then dminqt = 1
	
	if isnull(dweekcnt) or dweekcnt <= 0 then
		ddayqty = ceiling(dvndqty/dminqt)*dminqt
	else
		ddayqty = ceiling((dvndqty/dweekcnt)/dminqt)*dminqt
	end if
	
	dw_insert.setitem(lrow,"netqty",dnetqty)
	dw_insert.setitem(lrow,"vndqty",dvndqty)
	dw_insert.setitem(lrow,"dayqty",ddayqty)
NEXT
end subroutine

public function decimal wf_sum_napqty (datawindow arg_dw, string arg_itnbr);long		lrow, lfrow
decimal	dsumqty=0

FOR lrow = 1 TO arg_dw.rowcount()
	lfrow = arg_dw.find("itnbr = '"+arg_itnbr+"'",lrow,arg_dw.rowcount())
	if lfrow > 0 then
		dsumqty = dsumqty + arg_dw.getitemnumber(lrow,'sum_week')
	else
		exit
	end if
NEXT

return dsumqty
end function

public subroutine wf_set_balqty ();long		lrow, i, iweekcnt
decimal	djanqty, dforjego, ddayqty, dminsaf, dmidsaf, dtempqty, dsum_week
string	sitnbr, smwgbn, swdate01, swdate02, swdate03, swdate04, swdate05, swdate06, swdate07

dw_insert.accepttext()


////////////////////////////////////////////////////////////////////////////////////////////////////////////
FOR lrow = 1 TO dw_insert.rowcount()
	i = 0
	iweekcnt= dw_insert.getitemnumber(lrow,"weekcnt")
	
	sitnbr  = dw_insert.getitemstring(lrow,'itnbr')
	
	djanqty = dw_insert.getitemnumber(lrow,"janqty")
	ddayqty = dw_insert.getitemnumber(lrow,"dayqty")
	dminsaf = dw_insert.getitemnumber(lrow,"minsaf")
	dmidsaf = dw_insert.getitemnumber(lrow,"midsaf")
	
	smwgbn  = dw_insert.getitemstring(lrow,'mwgbn')
	swdate01= dw_insert.getitemstring(lrow,'wdate01')
	swdate02= dw_insert.getitemstring(lrow,'wdate02')
	swdate03= dw_insert.getitemstring(lrow,'wdate03')
	swdate04= dw_insert.getitemstring(lrow,'wdate04')
	swdate05= dw_insert.getitemstring(lrow,'wdate05')
	swdate06= dw_insert.getitemstring(lrow,'wdate06')
	swdate07= dw_insert.getitemstring(lrow,'wdate07')
	
	dforjego = djanqty + wf_sum_napqty(dw_insert,sitnbr)	
	dtempqty = 0
	if smwgbn = '1' then
		if dforjego < dmidsaf and i <= iweekcnt then 
			i++
			dw_insert.setitem(lrow,"qty_01",ddayqty)
			dtempqty = ddayqty
		end if
	else
		if swdate01 = 'Y' and dforjego < dmidsaf then	
			dw_insert.setitem(lrow,"qty_01",ddayqty)
			dtempqty = ddayqty
		end if
	end if
		
	dforjego = dforjego + dtempqty
	dtempqty = 0
	if smwgbn = '1' then
		if dforjego < dmidsaf and i <= iweekcnt then 
			i++
			dw_insert.setitem(lrow,"qty_02",ddayqty)
			dtempqty = ddayqty
		end if
	else
		if swdate02 = 'Y' and dforjego < dmidsaf then	
			dw_insert.setitem(lrow,"qty_02",ddayqty)
			dtempqty = ddayqty
		end if
	end if
	
	dforjego = dforjego + dtempqty
	dtempqty = 0
	if smwgbn = '1' then
		if dforjego < dmidsaf and i <= iweekcnt then 
			i++
			dw_insert.setitem(lrow,"qty_03",ddayqty)
			dtempqty = ddayqty
		end if
	else
		if swdate03 = 'Y' and dforjego < dmidsaf then	
			dw_insert.setitem(lrow,"qty_03",ddayqty)
			dtempqty = ddayqty
		end if
	end if

	dforjego = dforjego + dtempqty
	dtempqty = 0
	if smwgbn = '1' then
		if dforjego < dmidsaf and i <= iweekcnt then 
			i++
			dw_insert.setitem(lrow,"qty_04",ddayqty)
			dtempqty = ddayqty
		end if
	else
		if swdate04 = 'Y' and dforjego < dmidsaf then	
			dw_insert.setitem(lrow,"qty_04",ddayqty)
			dtempqty = ddayqty
		end if
	end if

	dforjego = dforjego + dtempqty
	dtempqty = 0
	if smwgbn = '1' then
		if dforjego < dmidsaf and i <= iweekcnt then 
			i++
			dw_insert.setitem(lrow,"qty_05",ddayqty)
			dtempqty = ddayqty
		end if
	else
		if swdate05 = 'Y' and dforjego < dmidsaf then	
			dw_insert.setitem(lrow,"qty_05",ddayqty)
			dtempqty = ddayqty
		end if
	end if

	dforjego = dforjego + dtempqty
	dtempqty = 0
	if smwgbn = '1' then
		if dforjego < dmidsaf and i <= iweekcnt then 
			i++
			dw_insert.setitem(lrow,"qty_06",ddayqty)
			dtempqty = ddayqty
		end if
	else
		if swdate06 = 'Y' and dforjego < dmidsaf then	
			dw_insert.setitem(lrow,"qty_06",ddayqty)
			dtempqty = ddayqty
		end if
	end if

	dforjego = dforjego + dtempqty
	dtempqty = 0
	if smwgbn = '1' then
		if dforjego < dmidsaf and i <= iweekcnt then 
			i++
			dw_insert.setitem(lrow,"qty_07",ddayqty)
			dtempqty = ddayqty
		end if
	else
		if swdate07 = 'Y' and dforjego < dmidsaf then	
			dw_insert.setitem(lrow,"qty_07",ddayqty)
			dtempqty = ddayqty
		end if
	end if
	
	dw_insert.setitem(lrow,"vndqty",dw_insert.getitemnumber(lrow,'sum_week'))
NEXT
end subroutine

public subroutine wf_set_orgqty ();long		lrow


FOR lrow = 1 TO dw_insert.rowcount()
	dw_insert.setitem(lrow,'sum_orgqty',dw_insert.getitemnumber(lrow,'sum_week'))
NEXT
end subroutine

public subroutine wf_calc_shrat ();long		lrow
decimal	dshrat, dqty_01, dqty_02, dqty_03, dqty_04, dqty_05, dqty_06, dqty_07, dneed


// 소재불량율 적용
FOR lrow = 1 TO dw_insert.rowcount()
	dshrat = dw_insert.getitemnumber(lrow,'shrat')
	if isnull(dshrat) then dshrat = 0
	dqty_01 = dw_insert.getitemnumber(lrow,'qty_01')
	dqty_02 = dw_insert.getitemnumber(lrow,'qty_02')
	dqty_03 = dw_insert.getitemnumber(lrow,'qty_03')
	dqty_04 = dw_insert.getitemnumber(lrow,'qty_04')
	dqty_05 = dw_insert.getitemnumber(lrow,'qty_05')
	dqty_06 = dw_insert.getitemnumber(lrow,'qty_06')
	dqty_07 = dw_insert.getitemnumber(lrow,'qty_07')
	
	dneed = dqty_01 + round(dqty_01*dshrat,0)
	dw_insert.setitem(lrow,'qty_01',dneed)
	
	dneed = dqty_02 + round(dqty_02*dshrat,0)
	dw_insert.setitem(lrow,'qty_02',dneed)
	
	dneed = dqty_03 + round(dqty_03*dshrat,0)
	dw_insert.setitem(lrow,'qty_03',dneed)

	dneed = dqty_04 + round(dqty_04*dshrat,0)
	dw_insert.setitem(lrow,'qty_04',dneed)

	dneed = dqty_05 + round(dqty_05*dshrat,0)
	dw_insert.setitem(lrow,'qty_05',dneed)
	
	dneed = dqty_06 + round(dqty_06*dshrat,0)
	dw_insert.setitem(lrow,'qty_06',dneed)
	
	dneed = dqty_07 + round(dqty_07*dshrat,0)
	dw_insert.setitem(lrow,'qty_07',dneed)
NEXT
end subroutine

public subroutine wf_set_info (datawindow arg_dw, long arg_row);string	sitnbr, scvcod
decimal	djego, dtotqty, dorgqty, dweekqty

if arg_row <= 0 then return

sitnbr = arg_dw.getitemstring(arg_row,'itnbr')
scvcod = arg_dw.getitemstring(arg_row,'cvcod')

djego   = arg_dw.getitemnumber(arg_row,'jgoqty')
dtotqty = arg_dw.getitemnumber(arg_row,'totqty')
dorgqty = arg_dw.getitemnumber(arg_row,'sum_orgqty')
dweekqty= arg_dw.getitemnumber(arg_row,'sum_week')

if dw_3.retrieve(sitnbr,scvcod) < 1 then return

dw_3.setitem(1,'jegoqty',djego)
dw_3.setitem(1,'totqty',dtotqty)
dw_3.setitem(1,'patqty',dorgqty)
dw_3.setitem(1,'chgqty',dweekqty)



end subroutine

public subroutine wf_initial ();dw_1.ReSet()
dw_3.ReSet()
dw_insert.ReSet()
dw_insert2.ReSet()
dw_4.ReSet()
dw_41.ReSet()
dw_6.ReSet()

dw_1.InsertRow(0)
dw_3.InsertRow(0)

string	smaxdate

select max(yymmdd) into :smaxdate from pu03_weekplan
 where waigb = '1' ;
if isnull(smaxdate) or smaxdate = '' then
	smaxdate = f_nearday(f_today(),2)  /* 가장 가까운 월요일 */
	dw_1.Object.sdate[1] = smaxdate
else
	dw_1.Object.sdate[1] = smaxdate
end if
dw_1.postevent(itemchanged!)

dw_1.setfocus()

//f_mod_saupj(dw_1, 'saupj')
end subroutine

public subroutine wf_calc_point2 (string arg_seqno);long		i, lrow
long		lot, lcnt, lsum, lsetsum, lneed, lrest, lotsum
long		lqty1, lqty2, lqty3, lqty4, lqty5, lqty6, lqty7
string	sd01, sd02, sd03, sd04, sd05, sd06, sd07


// 용기량이 지정되지 않은 자료만 처리 - 횟수에 의한 일괄배분 - 2003.11.26 [권철순 부장]

FOR lrow = 1 TO dw_insert.rowcount()
	if dw_insert.getitemstring(lrow,'seqno') <> arg_seqno then continue
	
	//====================================================================
	lot = dw_insert.getitemnumber(lrow,'minqt')
	if lot > 0 then continue
	
	lsum = dw_insert.getitemnumber(lrow,'sum_week')
	lcnt = dw_insert.getitemnumber(lrow,'weekcnt')
	
	if dw_insert.getitemstring(lrow,'mwgbn') = '1' then
		dw_insert.setitem(lrow,'qty_01',lsum)
		dw_insert.setitem(lrow,'qty_02',0)
		dw_insert.setitem(lrow,'qty_03',0)
		dw_insert.setitem(lrow,'qty_04',0)
		dw_insert.setitem(lrow,'qty_05',0)
		dw_insert.setitem(lrow,'qty_06',0)
		dw_insert.setitem(lrow,'qty_07',0)
		continue
	end if

	if isnull(lcnt) or lcnt < 1 then 
		lcnt = 1
		sd01 = 'Y'
	end if
	
	lneed = lsum/lcnt
	
	sd01 = dw_insert.getitemstring(lrow,'wdate01')
	sd02 = dw_insert.getitemstring(lrow,'wdate02')
	sd03 = dw_insert.getitemstring(lrow,'wdate03')
	sd04 = dw_insert.getitemstring(lrow,'wdate04')
	sd05 = dw_insert.getitemstring(lrow,'wdate05')
	sd06 = dw_insert.getitemstring(lrow,'wdate06')
	sd07 = dw_insert.getitemstring(lrow,'wdate07')

	//====================================================================
	if sd01 = 'Y' then
		lsetsum = lneed
		dw_insert.setitem(lrow,'qty_01',lneed)
	else
		dw_insert.setitem(lrow,'qty_01',0)
	end if
	

	//====================================================================
	if sd02 = 'Y' and lsetsum < lsum then
		lsetsum = lsetsum + lneed
		if lsetsum > lsum then
			lneed = lsum - (lsetsum - lneed)
		elseif (lsum - lsetsum) < lneed then
			lneed = lneed + (lsum - lsetsum)			
		end if
		dw_insert.setitem(lrow,'qty_02',lneed)
	else
		dw_insert.setitem(lrow,'qty_02',0)
	end if


	//====================================================================
	if sd03 = 'Y' and lsetsum < lsum then
		lsetsum = lsetsum + lneed
		if lsetsum > lsum then
			lneed = lsum - (lsetsum - lneed)
		elseif (lsum - lsetsum) < lneed then
			lneed = lneed + (lsum - lsetsum)			
		end if
		dw_insert.setitem(lrow,'qty_03',lneed)
	else
		dw_insert.setitem(lrow,'qty_03',0)
	end if


	//====================================================================
	if sd04 = 'Y' and lsetsum < lsum then
		lsetsum = lsetsum + lneed
		if lsetsum > lsum then
			lneed = lsum - (lsetsum - lneed)
		elseif (lsum - lsetsum) < lneed then
			lneed = lneed + (lsum - lsetsum)			
		end if
		dw_insert.setitem(lrow,'qty_04',lneed)
	else
		dw_insert.setitem(lrow,'qty_04',0)
	end if

	
	//====================================================================
	if sd05 = 'Y' and lsetsum < lsum then
		lsetsum = lsetsum + lneed
		if lsetsum > lsum then
			lneed = lsum - (lsetsum - lneed)
		elseif (lsum - lsetsum) < lneed then
			lneed = lneed + (lsum - lsetsum)			
		end if
		dw_insert.setitem(lrow,'qty_05',lneed)
	else
		dw_insert.setitem(lrow,'qty_05',0)
	end if


	//====================================================================
	if sd06 = 'Y' and lsetsum < lsum then
		lsetsum = lsetsum + lneed
		if lsetsum > lsum then
			lneed = lsum - (lsetsum - lneed)
		elseif (lsum - lsetsum) < lneed then
			lneed = lneed + (lsum - lsetsum)			
		end if
		dw_insert.setitem(lrow,'qty_06',lneed)
	else
		dw_insert.setitem(lrow,'qty_06',0)
	end if


	//====================================================================
	if sd07 = 'Y' and lsetsum < lsum then
		lsetsum = lsetsum + lneed
		if lsetsum > lsum then
			lneed = lsum - (lsetsum - lneed)
		elseif (lsum - lsetsum) < lneed then
			lneed = lneed + (lsum - lsetsum)			
		end if
		dw_insert.setitem(lrow,'qty_07',lneed)
	else
		dw_insert.setitem(lrow,'qty_07',0)
	end if
NEXT
end subroutine

public subroutine wf_calc_point (string arg_seqno);long		i, lrow
long		lot, lcnt, lsum, lneed, lrest, lotsum
long		lqty1, lqty2, lqty3, lqty4, lqty5, lqty6, lqty7
string	sd01, sd02, sd03, sd04, sd05, sd06, sd07, smwgbn


// 용기량이 지정된 자료만 처리

FOR lrow = 1 TO dw_insert.rowcount()
	if dw_insert.getitemstring(lrow,'seqno') <> arg_seqno then continue
	
	//====================================================================
	lot = dw_insert.getitemnumber(lrow,'minqt')
	if isnull(lot) or lot <=0 then lot = 1
//	if lot <= 0 then continue

	lsum = dw_insert.getitemnumber(lrow,'sum_week')
	lcnt = dw_insert.getitemnumber(lrow,'weekcnt')

	i = 0
	lrest = 0
	
	lotsum = ceiling(lsum/lot)*lot

	if dw_insert.getitemstring(lrow,'mwgbn') = '1' then
		dw_insert.setitem(lrow,'qty_01',lotsum)
		dw_insert.setitem(lrow,'qty_02',0)
		dw_insert.setitem(lrow,'qty_03',0)
		dw_insert.setitem(lrow,'qty_04',0)
		dw_insert.setitem(lrow,'qty_05',0)
		dw_insert.setitem(lrow,'qty_06',0)
		dw_insert.setitem(lrow,'qty_07',0)
		continue
	end if

	sd01 = dw_insert.getitemstring(lrow,'wdate01')
	sd02 = dw_insert.getitemstring(lrow,'wdate02')
	sd03 = dw_insert.getitemstring(lrow,'wdate03')
	sd04 = dw_insert.getitemstring(lrow,'wdate04')
	sd05 = dw_insert.getitemstring(lrow,'wdate05')
	sd06 = dw_insert.getitemstring(lrow,'wdate06')
	sd07 = dw_insert.getitemstring(lrow,'wdate07')
	
	//====================================================================
	lqty1 = dw_insert.getitemnumber(lrow,'qty_01')
	lneed = ceiling(lqty1/lot)*lot
	if sd01 = 'Y' then
		i++
		if i < lcnt then
			dw_insert.setitem(lrow,'qty_01',lneed)
			lotsum = lotsum - lneed
			lrest= lneed - lqty1
		else
			dw_insert.setitem(lrow,'qty_01',lotsum)
			lotsum = 0
			lrest= 0
		end if
	else
		dw_insert.setitem(lrow,'qty_01',0)
	end if
	
	
	//====================================================================
	lqty2 = dw_insert.getitemnumber(lrow,'qty_02') - lrest
	if lqty2 > 0 then
		lneed = ceiling(lqty2/lot)*lot
	else
		lneed = 0
	end if

	if sd02 = 'Y' then
		i++
		if lotsum > 0 and i < lcnt then
			dw_insert.setitem(lrow,'qty_02',lneed)
			lotsum = lotsum - lneed
			lrest= lneed - lqty2
		else
			dw_insert.setitem(lrow,'qty_02',lotsum)
			lotsum = 0
			lrest= 0
		end if
	else
		dw_insert.setitem(lrow,'qty_02',0)
	end if


	//====================================================================
	lqty3 = dw_insert.getitemnumber(lrow,'qty_03') - lrest
	if lqty3 > 0 then
		lneed = ceiling(lqty3/lot)*lot
	else
		lneed = 0
	end if
	
	if sd03 = 'Y' then
		i++
		if lotsum > 0 and i < lcnt then
			dw_insert.setitem(lrow,'qty_03',lneed)
			lotsum = lotsum - lneed
			lrest= lneed - lqty3
		else
			dw_insert.setitem(lrow,'qty_03',lotsum)
			lotsum = 0
			lrest= 0
		end if
	else
		dw_insert.setitem(lrow,'qty_03',0)	
	end if


	//====================================================================
	lqty4 = dw_insert.getitemnumber(lrow,'qty_04') - lrest
	if lqty4 > 0 then
		lneed = ceiling(lqty4/lot)*lot
	else
		lneed = 0
	end if
	
	if sd04 = 'Y' then
		i++
		if lotsum > 0 and i < lcnt then
			dw_insert.setitem(lrow,'qty_04',lneed)
			lotsum = lotsum - lneed
			lrest= lneed - lqty4
		else
			dw_insert.setitem(lrow,'qty_04',lotsum)
			lotsum = 0
			lrest= 0
		end if
	else
		dw_insert.setitem(lrow,'qty_04',0)
	end if
	
	
	//====================================================================
	lqty5 = dw_insert.getitemnumber(lrow,'qty_05') - lrest
	if lqty5 > 0 then
		lneed = ceiling(lqty5/lot)*lot
	else
		lneed = 0
	end if
	
	if sd05 = 'Y' then
		i++
		if lotsum > 0 and i < lcnt then
			dw_insert.setitem(lrow,'qty_05',lneed)
			lotsum = lotsum - lneed
			lrest= lneed - lqty5
		else
			dw_insert.setitem(lrow,'qty_05',lotsum)
			lotsum = 0
			lrest= 0
		end if
	else
		dw_insert.setitem(lrow,'qty_05',0)
	end if
	

	//====================================================================
	lqty6 = dw_insert.getitemnumber(lrow,'qty_06') - lrest
	if lqty6 > 0 then
		lneed = ceiling(lqty6/lot)*lot
	else
		lneed = 0
	end if
	
	if sd06 = 'Y' then
		i++
		if lotsum > 0 and i < lcnt then
			dw_insert.setitem(lrow,'qty_06',lneed)
			lotsum = lotsum - lneed
			lrest= lneed - lqty6
		else
			dw_insert.setitem(lrow,'qty_06',lotsum)
			lotsum = 0
			lrest= 0
		end if
	else
		dw_insert.setitem(lrow,'qty_06',0)
	end if


	//====================================================================
	lqty7 = dw_insert.getitemnumber(lrow,'qty_07') - lrest
	if lqty7 > 0 then
		lneed = ceiling(lqty7/lot)*lot
	else
		lneed = 0
	end if
	
	if sd07 = 'Y' then
		i++
		if lotsum > 0 and i < lcnt then
			dw_insert.setitem(lrow,'qty_07',lneed)
			lotsum = lotsum - lneed
			lrest= lneed - lqty7
		else
			dw_insert.setitem(lrow,'qty_07',lotsum)
			lotsum = 0
			lrest= 0
		end if
	else
		dw_insert.setitem(lrow,'qty_07',0)
	end if


	//====================================================================
	if i = 0 then
		dw_insert.setitem(lrow,'qty_06',lotsum)
	end if
NEXT
end subroutine

public subroutine wf_set_qtp_org ();long		lrow
decimal	drate

dw_insert.accepttext()


////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 필요수량 원래대로
FOR lrow = 1 TO dw_insert.rowcount()
	drate = dw_insert.getitemnumber(lrow,"porate")

	dw_insert.setitem(lrow,"qtp_01",dw_insert.getitemnumber(lrow,"qtp_01_org"))
	dw_insert.setitem(lrow,"qtp_02",dw_insert.getitemnumber(lrow,"qtp_02_org"))
	dw_insert.setitem(lrow,"qtp_03",dw_insert.getitemnumber(lrow,"qtp_03_org"))
	dw_insert.setitem(lrow,"qtp_04",dw_insert.getitemnumber(lrow,"qtp_04_org"))
	dw_insert.setitem(lrow,"qtp_05",dw_insert.getitemnumber(lrow,"qtp_05_org"))
	dw_insert.setitem(lrow,"qtp_06",dw_insert.getitemnumber(lrow,"qtp_06_org"))
	dw_insert.setitem(lrow,"qtp_07",dw_insert.getitemnumber(lrow,"qtp_07_org"))
	dw_insert.setitem(lrow,"midsaf",dw_insert.getitemnumber(lrow,"midsaf_org"))
	dw_insert.setitem(lrow,"jgoqty",dw_insert.getitemnumber(lrow,"jgoqty_org"))
NEXT
end subroutine

public subroutine wf_set_porate ();long		lrow
decimal	drate

dw_insert.accepttext()


////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 업체별 발주비율 적용
FOR lrow = 1 TO dw_insert.rowcount()
	drate = dw_insert.getitemnumber(lrow,"porate")

	dw_insert.setitem(lrow,"qtp_01_org",dw_insert.getitemnumber(lrow,"qtp_01"))
	dw_insert.setitem(lrow,"qtp_02_org",dw_insert.getitemnumber(lrow,"qtp_02"))
	dw_insert.setitem(lrow,"qtp_03_org",dw_insert.getitemnumber(lrow,"qtp_03"))
	dw_insert.setitem(lrow,"qtp_04_org",dw_insert.getitemnumber(lrow,"qtp_04"))
	dw_insert.setitem(lrow,"qtp_05_org",dw_insert.getitemnumber(lrow,"qtp_05"))
	dw_insert.setitem(lrow,"qtp_06_org",dw_insert.getitemnumber(lrow,"qtp_06"))
	dw_insert.setitem(lrow,"qtp_07_org",dw_insert.getitemnumber(lrow,"qtp_07"))
	dw_insert.setitem(lrow,"midsaf_org",dw_insert.getitemnumber(lrow,"midsaf"))
	dw_insert.setitem(lrow,"jgoqty_org",dw_insert.getitemnumber(lrow,"jgoqty"))


	dw_insert.setitem(lrow,"qtp_01",dw_insert.getitemnumber(lrow,"qtp_01")*drate)
	dw_insert.setitem(lrow,"qtp_02",dw_insert.getitemnumber(lrow,"qtp_02")*drate)
	dw_insert.setitem(lrow,"qtp_03",dw_insert.getitemnumber(lrow,"qtp_03")*drate)
	dw_insert.setitem(lrow,"qtp_04",dw_insert.getitemnumber(lrow,"qtp_04")*drate)
	dw_insert.setitem(lrow,"qtp_05",dw_insert.getitemnumber(lrow,"qtp_05")*drate)
	dw_insert.setitem(lrow,"qtp_06",dw_insert.getitemnumber(lrow,"qtp_06")*drate)
	dw_insert.setitem(lrow,"qtp_07",dw_insert.getitemnumber(lrow,"qtp_07")*drate)
	dw_insert.setitem(lrow,"midsaf",dw_insert.getitemnumber(lrow,"midsaf")*drate)
	dw_insert.setitem(lrow,"jgoqty",dw_insert.getitemnumber(lrow,"jgoqty")*drate)
NEXT
end subroutine

public function integer wf_delete_pu_plan ();long		i
string	syymmdd

syymmdd = trim(dw_1.getitemstring(1,'sdate'))

/*
select count(*) into :i from pu03_weekplan
 where sabu = :gs_saupj and yymmdd = :syymmdd and waigb = '1' ;
*/
select count('x') into :i from pu03_weekplan
 where yymmdd = :syymmdd and waigb = '1' ;

if i > 0 then
	if messagebox("자재소요량 전개",syymmdd+" 주간 구매계획이 존재합니다."+&
								"~n새로 자재소요량을 전개하시겠습니까?" ,exclamation!,oKcancel!,2) = 2 then
		return -1	
	end if
else
	if messagebox("자재소요량 전개","자재소요량을 전개하시겠습니까?" ,exclamation!,oKcancel!,2) = 2 then
		return -1	
	end if
end if


// 기존에 있던 계획은 삭제한다. =================================================
/*delete from pu03_weekplan
 where sabu = :gs_saupj and yymmdd = :syymmdd and waigb = '1' ; */
delete from pu03_weekplan
 where yymmdd = :syymmdd and waigb = '1' ;
if sqlca.sqlcode <> 0 then
	rollback;
	messagebox('ERROR','MRP 작성 중 에러가 발생했습니다. DB 에러 ')
	return -1
end if

return 1
end function

public function integer wf_trans_ps_plan ();string	syymmdd, smorpm, serror
integer	iMaxNo

if dw_1.accepttext() = -1 then return -1

syymmdd = trim(dw_1.getitemstring(1,'sdate'))
smorpm  = dw_1.getitemstring(1,'smorpm')

setpointer(hourglass!)
if smorpm = 'P' then	
//	Select max(actno) into :iMaxNo from mrpsys where mrpdata = 3 ;
//
//	serror = 'X'
//	sqlca.erp000000050_7_leewon(gs_saupj, iMaxNo, syymmdd, 1, '3', '1', 'Y', serror) ;
//	commit ;
//	if serror <> 'N' then
//		messagebox("확 인", "주간 생산계획 전송이 실패하였습니다.!!")
//		return -1
//	end if
	
	dw_4.dataobject = 'd_pu01_00030_mrp'
else	
//	serror = 'X'
//	sqlca.LEEWON_MRP_SALES(gs_saupj,syymmdd,0,'3',serror) ;
//	commit ;
//	if serror <> 'N' then
//		messagebox("확 인", "주간 판매계획 전송이 실패하였습니다.!!")
//		return -1
//	end if
	dw_4.dataobject = 'd_pu01_00030_mrp2'
end if
dw_4.settransobject(sqlca)

return 1
end function

public function integer wf_check_pm_plan ();string	syymmdd, spdtgu, stemp, smorpm

if dw_1.accepttext() = -1 then return -1

syymmdd = trim(dw_1.getitemstring(1,'sdate'))
smorpm= dw_1.getitemstring(1,'smorpm')

if smorpm = 'P' then
//	select yymmdd into :stemp from pu03_weekplan_sum
//	 where sabu = :gs_saupj and yymmdd = :syymmdd and waigb = '1' and jocod = '311' and rownum = 1 ;
//	if sqlca.sqlcode <> 0 then
//		messagebox('확인',syymmdd + ' 생산1팀1반 생산계획이 확정되지 않았습니다.')
//		return -1
//	end if
//
//	select yymmdd into :stemp from pu03_weekplan_sum
//	 where sabu = :gs_saupj and yymmdd = :syymmdd and waigb = '1' and jocod = '312' and rownum = 1 ;
//	if sqlca.sqlcode <> 0 then
//		messagebox('확인',syymmdd + ' 생산1팀2반의 생산계획이 확정되지 않았습니다.')
//		return -1
//	end if
//
//	select yymmdd into :stemp from pu03_weekplan_sum
//	 where sabu = :gs_saupj and yymmdd = :syymmdd and waigb = '1' and jocod = '313' and rownum = 1 ;
//	if sqlca.sqlcode <> 0 then
//		messagebox('확인',syymmdd + ' 생산1팀3반의 생산계획이 확정되지 않았습니다.')
//		return -1
//	end if
//
//	select yymmdd into :stemp from pu03_weekplan_sum
//	 where sabu = :gs_saupj and yymmdd = :syymmdd and waigb = '1' and jocod = '321' and rownum = 1 ;
//	if sqlca.sqlcode <> 0 then
//		messagebox('확인',syymmdd + ' 생산2팀1반의 생산계획이 확정되지 않았습니다.')
//		return -1
//	end if
//
//	select yymmdd into :stemp from pu03_weekplan_sum
//	 where sabu = :gs_saupj and yymmdd = :syymmdd and waigb = '1' and jocod = '322' and rownum = 1 ;
//	if sqlca.sqlcode <> 0 then
//		messagebox('확인',syymmdd + ' 생산2팀2반의 생산계획이 확정되지 않았습니다.')
//		return -1
//	end if
//
//	select yymmdd into :stemp from pu03_weekplan_sum
//	 where sabu = :gs_saupj and yymmdd = :syymmdd and waigb = '1' and jocod = '323' and rownum = 1 ;
//	if sqlca.sqlcode <> 0 then
//		messagebox('확인',syymmdd + ' 생산2팀3반의 생산계획이 확정되지 않았습니다.')
//		return -1
//	end if
//
//	select yymmdd into :stemp from sm03_weekplan_item
//	 where saupj = :gs_saupj and yymmdd = :syymmdd and cnfirm is not null and rownum = 1 ;
//	if sqlca.sqlcode <> 0 then
//		messagebox('확인',syymmdd + ' 상품 전개를 위한 주간 판매계획이 확정되지 않았습니다.')
//		return -1
//	end if

	select yymmdd into :stemp from pu03_weekplan_sum
	 where sabu = :gs_saupj and yymmdd = :syymmdd and waigb = '1' and rownum = 1 ;
	if sqlca.sqlcode <> 0 then
		messagebox('확인',syymmdd + ' 생산팀의 생산계획이 확정되지 않았습니다.')
		return -1
	end if

else
	select yymmdd into :stemp from sm03_weekplan_item
	 where saupj = :gs_saupj and yymmdd = :syymmdd and cnfirm is not null and rownum = 1 ;
	if sqlca.sqlcode <> 0 then
		messagebox('확인',syymmdd + ' 주간 판매계획이 확정되지 않았습니다.')
		return -1
	end if
end if

return 1
end function

public function integer wf_calc_sagub ();long		lrow, lrow4, lirow, lfrow2, lrowcount
string	syymmdd, syymmdd_pre, sfdate, stdate, srinbr, scinbr, scvcod
string	scvnas, scidsc, sjasa, smorpm, sjegoyn
string	smwgbn, swdate01, swdate02, swdate03, swdate04, swdate05, swdate06, swdate07
decimal	dporate, dunprc, dqtp_pre, dqty_pre, dweekcnt
decimal	djego, dshrat, dldtim2, dpalqty, dmonmax
decimal	dminsaf, dmidsaf, dmaxsaf, dwdrate

dw_insert.accepttext()
smorpm= dw_1.getitemstring(1,'smorpm')
syymmdd= trim(dw_1.getitemstring(1,'sdate'))
sjegoyn= dw_1.getitemstring(1,'jegoyn')

// 자사코드 가져오기
select dataname into :sjasa from syscnfg
 where sysgu = 'C' and serial = 4 and lineno = '1' ;
 
FOR lrow = 1 TO dw_insert.rowcount()
	if dw_insert.getitemnumber(lrow,'fstno') > 1 then continue		// 최초 전개된 자료만 대상
	
	srinbr = dw_insert.getitemstring(lrow,"itnbr")

	// 유상사급인 경우 확인- 2003.12.18
	select a.itnbrwd, nvl(a.wdrate,0) 
	  into :scinbr, :dwdrate
	  from item_rel a,
			 itemas   b
	 where a.itnbr   = :srinbr
	   and a.itnbrwd = b.itnbr
		and b.useyn = '0' ;
	if sqlca.sqlcode <> 0 then continue
	
//	if dwdrate <= 0 or dwdrate > 1 then dwdrate = 1.0   // 사급비율
	dwdrate = 1.0
	
	st_info1.text = '유상사급 추가 :'
	st_info2.text = srinbr + ' -> ' + scinbr


	// 재고 계산 =======================================================
   select nvl(sum(jego_qty),0) into :djego from stock       //재고
	 where itnbr = :scinbr ;
			 
	if sqlca.sqlcode <> 0 then djego = 0

	syymmdd_pre = f_afterday(syymmdd,-7)
			
	Select NVL(Sum(qtp_06),0) + NVL(Sum(qtp_07),0)  ,        // 해당계획년월의 해당주차의 예상재고를 구한다
	       NVL(Sum(qty_06),0) + NVL(Sum(qtp_07),0)           // 예상 재고 = 현시점의 재고( 해당주 금요일시점) 
	 Into :dqtp_pre , :dqty_pre                             //             - 전주의 토,일요일 생산에 필요한 수량 +  전주의 토,일요일구매계획 수량 
	  from pu03_weekplan 
	 where sabu = :gs_saupj
	   and yymmdd = :syymmdd_pre
	   and itnbr = :scinbr ;
			  
	if sqlca.sqlcode <> 0 then 
		dqtp_pre = 0 
		dqty_pre = 0 
	End If
			
	djego = djego - dqtp_pre + dqty_pre              
			
	select itdsc, shrat, ldtim2, nvl(minqt,0), nvl(minsaf,0), nvl(midsaf,0), nvl(maxsaf,0), nvl(mnapqty,0)
	  into :scidsc, :dshrat, :dldtim2, :dpalqty, :dminsaf, :dmidsaf, :dmaxsaf, :dmonmax
	  from itemas
	 where itnbr = :scinbr ;
			 
	if sqlca.sqlcode <> 0 then 
		dshrat = 0
		dldtim2= 0
		dminsaf= 0
		dmidsaf= 0
		dmaxsaf= 0
	end if
	//==============================================================================

	
	lrowcount = dw_6.retrieve(scinbr,syymmdd)


//////////////////////////////////////////////////////////////////////////////////////////////
// 이원화 및 발주비율 적용 - START - 2004.01.05
	if lrowcount < 1 then
		scvcod  = sjasa
		lrowcount= 1
	else
		scvcod  = dw_6.getitemstring(1,'cvcod')
	end if	

	FOR lrow4 = 1 TO lrowcount
		if scvcod = sjasa and lrowcount = 1 then
			dporate = 1.0
			dweekcnt = 1
			dunprc  = 0
		else
			scvcod  = dw_6.getitemstring(lrow4,'cvcod')
			dporate = dw_6.getitemnumber(lrow4,'porate')
			dweekcnt = dw_6.getitemnumber(lrow4,'weekcnt')
			dunprc  = dw_6.getitemnumber(lrow4,'unprc')
		end if

		lfrow2 = dw_insert.find("cvcod='"+scvcod+"' and itnbr='"+scinbr+"'",1,dw_insert.rowcount())
		if lfrow2 > 0 then
			dw_insert.setitem(lfrow2,"qtp_01",dw_insert.getitemnumber(lfrow2,"qtp_01")+dw_insert.getitemnumber(lrow,"qty_01"))
			dw_insert.setitem(lfrow2,"qtp_02",dw_insert.getitemnumber(lfrow2,"qtp_02")+dw_insert.getitemnumber(lrow,"qty_02"))
			dw_insert.setitem(lfrow2,"qtp_03",dw_insert.getitemnumber(lfrow2,"qtp_03")+dw_insert.getitemnumber(lrow,"qty_03"))
			dw_insert.setitem(lfrow2,"qtp_04",dw_insert.getitemnumber(lfrow2,"qtp_04")+dw_insert.getitemnumber(lrow,"qty_04"))
			dw_insert.setitem(lfrow2,"qtp_05",dw_insert.getitemnumber(lfrow2,"qtp_05")+dw_insert.getitemnumber(lrow,"qty_05"))
			dw_insert.setitem(lfrow2,"qtp_06",dw_insert.getitemnumber(lfrow2,"qtp_06")+dw_insert.getitemnumber(lrow,"qty_06"))
			dw_insert.setitem(lfrow2,"qtp_07",dw_insert.getitemnumber(lfrow2,"qtp_07")+dw_insert.getitemnumber(lrow,"qty_07"))
			dw_insert.setitem(lfrow2,"seqno",'2')
		else
	
			smwgbn  = dw_6.getitemstring(lrow4,'mwgbn')
			swdate01= dw_6.getitemstring(lrow4,'wdate01')
			swdate02= dw_6.getitemstring(lrow4,'wdate02')
			swdate03= dw_6.getitemstring(lrow4,'wdate03')
			swdate04= dw_6.getitemstring(lrow4,'wdate04')
			swdate05= dw_6.getitemstring(lrow4,'wdate05')
			swdate06= dw_6.getitemstring(lrow4,'wdate06')
			swdate07= dw_6.getitemstring(lrow4,'wdate07')
		
			lirow = dw_insert.insertrow(0)
			dw_insert.setitem(lirow,"sabu",gs_saupj)
			dw_insert.setitem(lirow,"yymmdd",syymmdd)
			dw_insert.setitem(lirow,"waigb",'1')
			dw_insert.setitem(lirow,"cvcod",scvcod)
			select cvnas into :scvnas from vndmst where cvcod = :scvcod ;
			dw_insert.setitem(lirow,"vndmst_cvnas",scvnas)
			dw_insert.setitem(lirow,"itnbr",scinbr)
			dw_insert.setitem(lirow,"itemas_itdsc",scidsc)
			dw_insert.setitem(lirow,"unprc",dunprc)
			dw_insert.setitem(lirow,"minqt",dpalqty)
			dw_insert.setitem(lirow,"porate",dwdrate)
			dw_insert.setitem(lirow,"monmax",dmonmax)
	
			dw_insert.setitem(lirow,"minsaf",dminsaf)
			dw_insert.setitem(lirow,"midsaf",dmidsaf)
			dw_insert.setitem(lirow,"maxsaf",dmaxsaf)			
			
			dw_insert.setitem(lirow,"itemas_minsaf",dminsaf)
			dw_insert.setitem(lirow,"itemas_midsaf",dmidsaf)
			dw_insert.setitem(lirow,"itemas_maxsaf",dmaxsaf)		
			
			dw_insert.setitem(lirow,"weekcnt",dweekcnt)
			dw_insert.setitem(lirow,"jgoqty",djego)
			dw_insert.setitem(lirow,"shrat",dshrat)
	
			dw_insert.setitem(lirow,"qtp_01",dwdrate*dw_insert.getitemnumber(lrow,"qty_01"))
			dw_insert.setitem(lirow,"qtp_02",dwdrate*dw_insert.getitemnumber(lrow,"qty_02"))
			dw_insert.setitem(lirow,"qtp_03",dwdrate*dw_insert.getitemnumber(lrow,"qty_03"))
			dw_insert.setitem(lirow,"qtp_04",dwdrate*dw_insert.getitemnumber(lrow,"qty_04"))
			dw_insert.setitem(lirow,"qtp_05",dwdrate*dw_insert.getitemnumber(lrow,"qty_05"))
			dw_insert.setitem(lirow,"qtp_06",dwdrate*dw_insert.getitemnumber(lrow,"qty_06"))
			dw_insert.setitem(lirow,"qtp_07",dwdrate*dw_insert.getitemnumber(lrow,"qty_07"))
			dw_insert.setitem(lirow,"smorpm",smorpm)
			dw_insert.setitem(lirow,"jegoyn",sjegoyn)
			dw_insert.setitem(lirow,"mwgbn",smwgbn)
			dw_insert.setitem(lirow,"wdate01",swdate01)
			dw_insert.setitem(lirow,"wdate02",swdate02)
			dw_insert.setitem(lirow,"wdate03",swdate03)
			dw_insert.setitem(lirow,"wdate04",swdate04)
			dw_insert.setitem(lirow,"wdate05",swdate05)
			dw_insert.setitem(lirow,"wdate06",swdate06)
			dw_insert.setitem(lirow,"wdate07",swdate07)
			
			dw_insert.setitem(lirow,"seqno",'2')
			dw_insert.setitem(lirow,"fstno",2)
	
			if lrowcount > 1 then dw_insert.setitem(lirow,"cvdbl",'Y') // 이원화 표시
		end if		
	NEXT

NEXT

return 1
end function

public function integer wf_calc_sagub2 ();long		lrow, lrow4, lirow, lfrow2, lrowcount, ix
string	syymmdd, syymmdd_pre, sfdate, stdate, srinbr, scinbr, scvcod, srvcod
string	scvnas, scidsc, sjasa, smorpm, sjegoyn
string	smwgbn, swdate01, swdate02, swdate03, swdate04, swdate05, swdate06, swdate07
decimal	dporate, dunprc, dqtp_pre, dqty_pre, dweekcnt
decimal	djego, dshrat, dldtim2, dpalqty, dmonmax
decimal	dminsaf, dmidsaf, dmaxsaf, dwdrate
datastore ds_wstruc

ds_wstruc = create datastore
ds_wstruc.dataobject = 'd_wstruc'
ds_wstruc.SetTransObject(sqlca)

dw_insert.accepttext()
smorpm= dw_1.getitemstring(1,'smorpm')
syymmdd= trim(dw_1.getitemstring(1,'sdate'))
sjegoyn= dw_1.getitemstring(1,'jegoyn')

// 자사코드 가져오기
select dataname into :sjasa from syscnfg
 where sysgu = 'C' and serial = 4 and lineno = '1' ;
 
FOR lrow = 1 TO dw_insert.rowcount()
	if dw_insert.getitemnumber(lrow,'fstno') > 1 then continue		// 최초 전개된 자료만 대상
	
	srinbr = dw_insert.getitemstring(lrow,"itnbr")
	srvcod = dw_insert.getitemstring(lrow,"cvcod")
	
	// 유상사급인 경우 확인- 2003.12.18
//	select a.itnbrwd2, nvl(a.wdrate,0) 
//	  into :scinbr, :dwdrate
//	  from item_rel a,
//			 itemas   b
//	 where a.itnbr   = :srinbr
//	   and a.itnbrwd2 = b.itnbr
//		and b.useyn = '0' ;
//	if sqlca.sqlcode <> 0 then continue
	
//	if dwdrate <= 0 or dwdrate > 1 then dwdrate = 1.0   // 사급비율

	// 유상사급은 외주BOM에서 읽어온다
	For ix = 1 To ds_wstruc.Retrieve(srinbr, srvcod)
		scinbr = ds_wstruc.GetItemString(ix, 'cinbr')
		dwdrate = 1.0
		
		st_info1.text = '유상사급 추가 :'
		st_info2.text = srinbr + ' -> ' + scinbr
	
	
		// 재고 계산 =======================================================
		select nvl(sum(jego_qty),0) into :djego from stock       //재고
		 where itnbr = :scinbr ;
				 
		if sqlca.sqlcode <> 0 then djego = 0
	
		syymmdd_pre = f_afterday(syymmdd,-7)
				
		Select NVL(Sum(qtp_06),0) + NVL(Sum(qtp_07),0)  ,        // 해당계획년월의 해당주차의 예상재고를 구한다
				 NVL(Sum(qty_06),0) + NVL(Sum(qtp_07),0)           // 예상 재고 = 현시점의 재고( 해당주 금요일시점) 
		 Into :dqtp_pre , :dqty_pre                             //             - 전주의 토,일요일 생산에 필요한 수량 +  전주의 토,일요일구매계획 수량 
		  from pu03_weekplan 
		 where sabu = :gs_saupj
			and yymmdd = :syymmdd_pre
			and itnbr = :scinbr ;
				  
		if sqlca.sqlcode <> 0 then 
			dqtp_pre = 0 
			dqty_pre = 0 
		End If
				
		djego = djego - dqtp_pre + dqty_pre              
				
		select itdsc, shrat, ldtim2, nvl(minqt,0), nvl(minsaf,0), nvl(midsaf,0), nvl(maxsaf,0), nvl(mnapqty,0)
		  into :scidsc, :dshrat, :dldtim2, :dpalqty, :dminsaf, :dmidsaf, :dmaxsaf, :dmonmax
		  from itemas
		 where itnbr = :scinbr ;
				 
		if sqlca.sqlcode <> 0 then 
			dshrat = 0
			dldtim2= 0
			dminsaf= 0
			dmidsaf= 0
			dmaxsaf= 0
		end if
		//==============================================================================
	
		
		lrowcount = dw_6.retrieve(scinbr,syymmdd)
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////
	// 이원화 및 발주비율 적용 - START - 2004.01.05
		if lrowcount < 1 then
			scvcod  = sjasa
			lrowcount= 0
		else
			scvcod  = dw_6.getitemstring(1,'cvcod')
		end if	
	
		FOR lrow4 = 1 TO lrowcount
			if scvcod = sjasa and lrowcount = 1 then
				dporate = 1.0
				dweekcnt = 1
				dunprc  = 0
			else
				scvcod  = dw_6.getitemstring(lrow4,'cvcod')
				dporate = dw_6.getitemnumber(lrow4,'porate')
				dweekcnt = dw_6.getitemnumber(lrow4,'weekcnt')
				dunprc  = dw_6.getitemnumber(lrow4,'unprc')
			end if
	
			lfrow2 = dw_insert.find("cvcod='"+scvcod+"' and itnbr='"+scinbr+"'",1,dw_insert.rowcount())
			if lfrow2 > 0 then
				dw_insert.setitem(lfrow2,"qtp_01",dw_insert.getitemnumber(lfrow2,"qtp_01")+dw_insert.getitemnumber(lrow,"qty_01"))
				dw_insert.setitem(lfrow2,"qtp_02",dw_insert.getitemnumber(lfrow2,"qtp_02")+dw_insert.getitemnumber(lrow,"qty_02"))
				dw_insert.setitem(lfrow2,"qtp_03",dw_insert.getitemnumber(lfrow2,"qtp_03")+dw_insert.getitemnumber(lrow,"qty_03"))
				dw_insert.setitem(lfrow2,"qtp_04",dw_insert.getitemnumber(lfrow2,"qtp_04")+dw_insert.getitemnumber(lrow,"qty_04"))
				dw_insert.setitem(lfrow2,"qtp_05",dw_insert.getitemnumber(lfrow2,"qtp_05")+dw_insert.getitemnumber(lrow,"qty_05"))
				dw_insert.setitem(lfrow2,"qtp_06",dw_insert.getitemnumber(lfrow2,"qtp_06")+dw_insert.getitemnumber(lrow,"qty_06"))
				dw_insert.setitem(lfrow2,"qtp_07",dw_insert.getitemnumber(lfrow2,"qtp_07")+dw_insert.getitemnumber(lrow,"qty_07"))
				dw_insert.setitem(lfrow2,"seqno",'2')
			else
		
				smwgbn  = dw_6.getitemstring(lrow4,'mwgbn')
				swdate01= dw_6.getitemstring(lrow4,'wdate01')
				swdate02= dw_6.getitemstring(lrow4,'wdate02')
				swdate03= dw_6.getitemstring(lrow4,'wdate03')
				swdate04= dw_6.getitemstring(lrow4,'wdate04')
				swdate05= dw_6.getitemstring(lrow4,'wdate05')
				swdate06= dw_6.getitemstring(lrow4,'wdate06')
				swdate07= dw_6.getitemstring(lrow4,'wdate07')
			
				lirow = dw_insert.insertrow(0)
				dw_insert.setitem(lirow,"sabu",gs_saupj)
				dw_insert.setitem(lirow,"yymmdd",syymmdd)
				dw_insert.setitem(lirow,"waigb",'1')
				dw_insert.setitem(lirow,"cvcod",scvcod)
				select cvnas into :scvnas from vndmst where cvcod = :scvcod ;
				dw_insert.setitem(lirow,"vndmst_cvnas",scvnas)
				dw_insert.setitem(lirow,"itnbr",scinbr)
				dw_insert.setitem(lirow,"itemas_itdsc",scidsc)
				dw_insert.setitem(lirow,"unprc",dunprc)
				dw_insert.setitem(lirow,"minqt",dpalqty)
				dw_insert.setitem(lirow,"porate",dwdrate)
				dw_insert.setitem(lirow,"monmax",dmonmax)
		
				dw_insert.setitem(lirow,"minsaf",dminsaf)
				dw_insert.setitem(lirow,"midsaf",dmidsaf)
				dw_insert.setitem(lirow,"maxsaf",dmaxsaf)			
				
				dw_insert.setitem(lirow,"itemas_minsaf",dminsaf)
				dw_insert.setitem(lirow,"itemas_midsaf",dmidsaf)
				dw_insert.setitem(lirow,"itemas_maxsaf",dmaxsaf)		
				
				dw_insert.setitem(lirow,"weekcnt",dweekcnt)
				dw_insert.setitem(lirow,"jgoqty",djego)
				dw_insert.setitem(lirow,"shrat",dshrat)
		
				dw_insert.setitem(lirow,"qtp_01",dwdrate*dw_insert.getitemnumber(lrow,"qty_01"))
				dw_insert.setitem(lirow,"qtp_02",dwdrate*dw_insert.getitemnumber(lrow,"qty_02"))
				dw_insert.setitem(lirow,"qtp_03",dwdrate*dw_insert.getitemnumber(lrow,"qty_03"))
				dw_insert.setitem(lirow,"qtp_04",dwdrate*dw_insert.getitemnumber(lrow,"qty_04"))
				dw_insert.setitem(lirow,"qtp_05",dwdrate*dw_insert.getitemnumber(lrow,"qty_05"))
				dw_insert.setitem(lirow,"qtp_06",dwdrate*dw_insert.getitemnumber(lrow,"qty_06"))
				dw_insert.setitem(lirow,"qtp_07",dwdrate*dw_insert.getitemnumber(lrow,"qty_07"))
				dw_insert.setitem(lirow,"smorpm",smorpm)
				dw_insert.setitem(lirow,"jegoyn",sjegoyn)
				dw_insert.setitem(lirow,"mwgbn",smwgbn)
				dw_insert.setitem(lirow,"wdate01",swdate01)
				dw_insert.setitem(lirow,"wdate02",swdate02)
				dw_insert.setitem(lirow,"wdate03",swdate03)
				dw_insert.setitem(lirow,"wdate04",swdate04)
				dw_insert.setitem(lirow,"wdate05",swdate05)
				dw_insert.setitem(lirow,"wdate06",swdate06)
				dw_insert.setitem(lirow,"wdate07",swdate07)
				
				dw_insert.setitem(lirow,"seqno",'3')
				dw_insert.setitem(lirow,"fstno",3)
		
				if lrowcount > 1 then dw_insert.setitem(lirow,"cvdbl",'Y') // 이원화 표시
			end if		
		NEXT
	Next
NEXT

return 1
end function

public subroutine wf_calc_needqty (string arg_seqno);long		lrow
decimal	djego, dmidsaf, dqtp_01, dqtp_02, dqtp_03, dqtp_04, dqtp_05, dqtp_06, dqtp_07, dneed
string	sjegoyn

// 필요수량 계산
sjegoyn = dw_1.getitemstring(1,'jegoyn')	// 재고감안 여부

FOR lrow = 1 TO dw_insert.rowcount()
	if dw_insert.getitemstring(lrow,'seqno') <> arg_seqno then continue
	
	if sjegoyn = 'Y' then
		djego = dw_insert.getitemnumber(lrow,'jgoqty')
		dmidsaf	= dw_insert.getitemnumber(lrow,'midsaf')
	else
		djego = 0
		dmidsaf = 0
	end if
	
	/* 현 재고 < 0 일 경우 현 재고 = 0으로 계산 - 안병국과장 by shingoon 2008.12.30 */
	/* 구매 / 외주 계획 동일 */
	If djego < 0 Then djego = 0
	/********************************************************************************/
	
	if dw_insert.getItemstring(lrow, 'itnbr') = 'C331-020185' then
		String ls_s
		ls_s = '1'
	End if
	
	dqtp_01	= dw_insert.getitemnumber(lrow,'qtp_01')
	dqtp_02	= dw_insert.getitemnumber(lrow,'qtp_02')
	dqtp_03	= dw_insert.getitemnumber(lrow,'qtp_03')
	dqtp_04	= dw_insert.getitemnumber(lrow,'qtp_04')
	dqtp_05	= dw_insert.getitemnumber(lrow,'qtp_05')
	dqtp_06	= dw_insert.getitemnumber(lrow,'qtp_06')
	dqtp_07	= dw_insert.getitemnumber(lrow,'qtp_07')
	
	djego = djego - dqtp_01
	dneed = dmidsaf - djego
	if dneed > 0 then
		dw_insert.setitem(lrow,'qty_01',dneed)
	else
		dneed = 0
		dw_insert.setitem(lrow,'qty_01',0)
	end if
	
	djego = djego + dneed - dqtp_02
	dneed = dmidsaf - djego
	if dneed > 0 then
		dw_insert.setitem(lrow,'qty_02',dneed)
	else
		dneed = 0
		dw_insert.setitem(lrow,'qty_02',0)
	end if
	
	djego = djego + dneed - dqtp_03
	dneed = dmidsaf - djego
	if dneed > 0 then
		dw_insert.setitem(lrow,'qty_03',dneed)
	else
		dneed = 0
		dw_insert.setitem(lrow,'qty_03',0)
	end if

	djego = djego + dneed - dqtp_04
	dneed = dmidsaf - djego
	if dneed > 0 then
		dw_insert.setitem(lrow,'qty_04',dneed)
	else
		dneed = 0
		dw_insert.setitem(lrow,'qty_04',0)
	end if

	djego = djego + dneed - dqtp_05
	dneed = dmidsaf - djego
	if dneed > 0 then
		dw_insert.setitem(lrow,'qty_05',dneed)
	else
		dneed = 0
		dw_insert.setitem(lrow,'qty_05',0)
	end if
	
	djego = djego + dneed - dqtp_06
	dneed = dmidsaf - djego
	if dneed > 0 then
		dw_insert.setitem(lrow,'qty_06',dneed)
	else
		dneed = 0
		dw_insert.setitem(lrow,'qty_06',0)
	end if
	
	djego = djego + dneed - dqtp_07
	dneed = dmidsaf - djego
	if dneed > 0 then
		dw_insert.setitem(lrow,'qty_07',dneed)
	else
		dw_insert.setitem(lrow,'qty_07',0)
	end if

NEXT
end subroutine

public subroutine wf_set_magamyn ();string	syymmdd, smagam, smorpm, sjegoyn

syymmdd = trim(dw_1.getitemstring(1,'sdate'))

select cnftime, smorpm,	jegoyn 
  into :smagam, :smorpm, :sjegoyn 
  from pu03_weekplan
 where sabu = :gs_saupj 
   and yymmdd = :syymmdd 
	and waigb = '1' 
	and rownum = 1 ;
	
if isnull(smagam) or smagam = '' then 
	dw_1.setitem(1,'cnfirm','N')
	dw_1.setitem(1,'smorpm',smorpm)
	dw_1.setitem(1,'jegoyn',sjegoyn)
else
	dw_1.setitem(1,'cnfirm','Y')
	dw_1.setitem(1,'smorpm',smorpm)
	dw_1.setitem(1,'jegoyn',sjegoyn)
end if
end subroutine

public subroutine wf_get_plan (string syymmdd);long		lrow1, lrow2, lrow3, lrow4, lrow5, lfrow, lirow, lvlno, lprlvl
long		lrowcnt1, lrowcnt2, lrowcnt3, lrowcnt4, lrowcnt5 ,i
decimal	dqtypr, dunprc, dpalqty, dmonmax, dporate, dweekcnt
decimal	dm01, dm02, dm03, dm04, dm05, dm06, dm07, dm08, dm09, dm10, dm11, dm12, djego, dcjego, dshrat, dldtim2
decimal  dqty_pre , dqtp_pre, dminsaf, dmidsaf, dmaxsaf
string	spinbr, srinbr, sitdsc, srtype,  sittyp, sitgu, scvcod ,scvnas, syymm, syymmdd_pre, sjasa, sjegoyn, sSaupj
string	smwgbn, swdate01, swdate02, swdate03, swdate04, swdate05, swdate06, swdate07, spdtgu, smorpm, splnt

smorpm= dw_1.getitemstring(1,'smorpm')
syymmdd= trim(dw_1.getitemstring(1,'sdate'))
sjegoyn= dw_1.getitemstring(1,'jegoyn')
sSaupj = '%'
lrowcnt1 = dw_4.retrieve(sSaupj, syymmdd) /* 사업장, 기준년월일 */

if lrowcnt1 < 1 then
	messagebox("확인",syymm+" 월 주간생산계획 자재소요량이 정의되지 않았습니다.")
	return
end if

st_info.text = ''
st_info1.text = ''
st_info2.text = ''

st_info.visible = true
st_info1.visible = true
st_info2.visible = true

dw_insert.reset()
dw_insert.setredraw(false)

// 자사코드 가져오기
select dataname into :sjasa from syscnfg
 where sysgu = 'C' and serial = 4 and lineno = '1' ;

Long   ll_qty1, ll_qty2, ll_qty3, ll_qty4, ll_qty5, ll_qty6, ll_qty7
String  ls_saupj

FOR lrow1 = 1 TO lrowcnt1
	
	srinbr = dw_4.getitemstring(lrow1,'itnbr')
	splnt  = dw_4.GetItemString(lrow1,'plnt' )
	
	st_info1.text = '구매 계획량 계산 :'
	st_info2.text = srinbr

	dm01 = dw_4.getitemnumber(lrow1,'qtp_01')
	dm02 = dw_4.getitemnumber(lrow1,'qtp_02')
	dm03 = dw_4.getitemnumber(lrow1,'qtp_03')
	dm04 = dw_4.getitemnumber(lrow1,'qtp_04')
	dm05 = dw_4.getitemnumber(lrow1,'qtp_05')
	dm06 = dw_4.getitemnumber(lrow1,'qtp_06')
	dm07 = dw_4.getitemnumber(lrow1,'qtp_07')
	
	/* CKD수량 제외 - 2009.02.26 BY SHINGOON *************************************************************************************/
	/* 외주 계획에서만 제외 - 2009.02.06 by shingoon */
//	  SELECT SUM(A.ITM_QTY1), SUM(A.ITM_QTY2), SUM(A.ITM_QTY3), SUM(A.ITM_QTY4), SUM(A.ITM_QTY5), SUM(A.ITM_QTY6), SUM(A.ITM_QTY7)
//	    INTO :ll_qty1       , :ll_qty2       , :ll_qty3       , :ll_qty4       , :ll_qty5       , :ll_qty6       , :ll_qty7
//		 FROM SM03_WEEKPLAN_ITEM A,
//		 		ITEMAS             I
//		WHERE A.SAUPJ  =  :gs_saupj
//		  AND A.YYMMDD =  :syymmdd
//		  AND A.ITNBR  =  :srinbr
//		  AND A.GUBUN  =  'CKD'
//		  AND I.ITGU   <> '5'
//		  AND I.GBWAN  =  'Y'
//		  AND I.GBGUB  =  '1'
//		  AND I.USEYN  =  '0'
//		  AND A.ITNBR  =  I.ITNBR
//	GROUP BY A.ITNBR, I.ITGU ;
//	
//	If SQLCA.SQLCODE <> 0 Then
//		ll_qty1 = 0
//		ll_qty2 = 0
//		ll_qty3 = 0
//		ll_qty4 = 0
//		ll_qty5 = 0
//		ll_qty6 = 0
//		ll_qty7 = 0
//	Else
//		If IsNull(ll_qty1) Then ll_qty1 = 0
//		If IsNull(ll_qty2) Then ll_qty2 = 0
//		If IsNull(ll_qty3) Then ll_qty3 = 0
//		If IsNull(ll_qty4) Then ll_qty4 = 0
//		If IsNull(ll_qty5) Then ll_qty5 = 0
//		If IsNull(ll_qty6) Then ll_qty6 = 0
//		If IsNull(ll_qty7) Then ll_qty7 = 0
//	End If
//	
//	dm01 = dm01 - ll_qty1
//	dm02 = dm02 - ll_qty2
//	dm03 = dm03 - ll_qty3
//	dm04 = dm04 - ll_qty4
//	dm05 = dm05 - ll_qty5
//	dm06 = dm06 - ll_qty6
//	dm07 = dm07 - ll_qty7
	
	/****************************************************************************************************************************/	
	
	// 재고 계산 =======================================================
	select itdsc, shrat, ldtim2, nvl(minqt,0), nvl(minsaf,0), nvl(midsaf,0), nvl(maxsaf,0), nvl(mnapqty,0), nvl(pdtgu,'2'),  nvl(pdtgu,'2')
	  into :sitdsc, :dshrat, :dldtim2, :dpalqty, :dminsaf, :dmidsaf, :dmaxsaf, :dmonmax, :spdtgu, :ls_saupj
	  from itemas
	 where itnbr = :srinbr ;
			 
	if sqlca.sqlcode <> 0 then 
		dshrat = 0
		dldtim2= 0
		dminsaf= 0
		dmidsaf= 0
		dmaxsaf= 0
	end if

	/* 현 재고 < 0 일 경우 0으로 계산 */
	select nvl(sum(case when a.jego_qty < 0 then 0 else a.jego_qty end), 0)
	       /*nvl(sum(a.jego_qty),0) */
	  into :djego 
	  from stock a
	 where a.itnbr = :srinbr
		and exists ( select 'x' from vndmst
						  where cvcod = a.depot_no	and soguan < '4' and jumaechul < '3' ) ;

	if sqlca.sqlcode <> 0 then djego = 0
	/* 현재고 < 0일 경우 현재고 = 0으로 정의 - by shingoon 2009.01.05 */
	If djego < 0 Then djego = 0

	syymmdd_pre =f_afterday(syymmdd,-7)
			
//	Select NVL(Sum(qtp_06),0) + NVL(Sum(qtp_07),0)  ,        // 해당계획년월의 해당주차의 예상재고를 구한다
//	       NVL(Sum(qty_06),0) + NVL(Sum(qtp_07),0)           // 예상 재고 = 현시점의 재고( 해당주 금요일시점) 
//	 Into :dqtp_pre , :dqty_pre                             //             - 전주의 토,일요일 생산에 필요한 수량 +  전주의 토,일요일구매계획 수량 
//	  from pu03_weekplan 
//	 where sabu = :gs_saupj
//	   and yymmdd = :syymmdd_pre
//	   and itnbr = :srinbr ;
//			  
//	if sqlca.sqlcode <> 0 then 
//		dqtp_pre = 0 
//		dqty_pre = 0 
//	End If
			
//	djego = djego - dqtp_pre + dqty_pre              
			
	//==============================================================================
	
	lrowcnt4 = dw_6.retrieve(srinbr,syymmdd) 


//////////////////////////////////////////////////////////////////////////////////////////////
// 이원화 및 발주비율 적용 - START - 2004.01.05
	if lrowcnt4 = 0 then
		scvcod  = sjasa
		lrowcnt4= 1
	elseIf lrowcnt4 >= 1 then
		scvcod  = dw_6.getitemstring(1,'cvcod')
	end if	

	FOR lrow4 = 1 TO lrowcnt4
		if scvcod = sjasa and lrowcnt4 = 1 then
			dporate = 1.0
			dweekcnt = 1
			dunprc  = 0
			
			smwgbn  = '1'
			swdate01= 'Y'
			swdate02= 'N'
			swdate03= 'N'
			swdate04= 'N'
			swdate05= 'N'
			swdate06= 'N'
			swdate07= 'N'
		else
			scvcod  = dw_6.getitemstring(lrow4,'cvcod')
			dporate = dw_6.getitemnumber(lrow4,'porate')
			dweekcnt = dw_6.getitemnumber(lrow4,'weekcnt')
			dunprc  = dw_6.getitemnumber(lrow4,'unprc')
			
			smwgbn  = dw_6.getitemstring(lrow4,'mwgbn')
			swdate01= dw_6.getitemstring(lrow4,'wdate01')
			swdate02= dw_6.getitemstring(lrow4,'wdate02')
			swdate03= dw_6.getitemstring(lrow4,'wdate03')
			swdate04= dw_6.getitemstring(lrow4,'wdate04')
			swdate05= dw_6.getitemstring(lrow4,'wdate05')
			swdate06= dw_6.getitemstring(lrow4,'wdate06')
			swdate07= dw_6.getitemstring(lrow4,'wdate07')
		end if
					
		lirow = dw_insert.insertrow(0)
		
		/* 품목마스터의 생산팀으로 사업장 정보 가져오기 */
		SELECT RFNA2 INTO :ls_saupj FROM REFFPF WHERE SABU = :gs_sabu AND RFCOD = '03' AND RFGUB = :ls_saupj ;
				
		dw_insert.setitem(lirow,"sabu",ls_saupj)
		dw_insert.setitem(lirow,"yymmdd",syymmdd)
		dw_insert.setitem(lirow,"waigb",'1')
		dw_insert.setitem(lirow,"cvcod",scvcod)
		dw_insert.SetItem(lirow,"plnt",splnt)
		select cvnas into :scvnas from vndmst where cvcod = :scvcod ;
		dw_insert.setitem(lirow,"vndmst_cvnas",scvnas)
		dw_insert.setitem(lirow,"itnbr",srinbr)
		dw_insert.setitem(lirow,"itemas_itdsc",sitdsc)
		dw_insert.setitem(lirow,"unprc",dunprc)
		dw_insert.setitem(lirow,"minqt",dpalqty)
		
		dw_insert.setitem(lirow,"minsaf",dminsaf)
		dw_insert.setitem(lirow,"midsaf",dmidsaf)
		dw_insert.setitem(lirow,"maxsaf",dmaxsaf)			
		
		dw_insert.setitem(lirow,"itemas_minsaf",dminsaf)
		dw_insert.setitem(lirow,"itemas_midsaf",dmidsaf)
		dw_insert.setitem(lirow,"itemas_maxsaf",dmaxsaf)		
		
		dw_insert.setitem(lirow,"monmax",dmonmax)
		dw_insert.setitem(lirow,"weekcnt",dweekcnt)
		dw_insert.setitem(lirow,"daymax",Round(dmonmax/Long(right(f_last_date(syymmdd),2)),0))
		dw_insert.setitem(lirow,"jgoqty",djego)
		dw_insert.setitem(lirow,"shrat",dshrat)
		dw_insert.setitem(lirow,"porate",dporate)
		dw_insert.setitem(lirow,"qtp_01",dm01)
		dw_insert.setitem(lirow,"qtp_02",dm02)
		dw_insert.setitem(lirow,"qtp_03",dm03)
		dw_insert.setitem(lirow,"qtp_04",dm04)
		dw_insert.setitem(lirow,"qtp_05",dm05)
		dw_insert.setitem(lirow,"qtp_06",dm06)
		dw_insert.setitem(lirow,"qtp_07",dm07)
		dw_insert.setitem(lirow,"smorpm",smorpm)
		dw_insert.setitem(lirow,"jegoyn",sjegoyn)
		dw_insert.setitem(lirow,"mwgbn",smwgbn)
		dw_insert.setitem(lirow,"wdate01",swdate01)
		dw_insert.setitem(lirow,"wdate02",swdate02)
		dw_insert.setitem(lirow,"wdate03",swdate03)
		dw_insert.setitem(lirow,"wdate04",swdate04)
		dw_insert.setitem(lirow,"wdate05",swdate05)
		dw_insert.setitem(lirow,"wdate06",swdate06)
		dw_insert.setitem(lirow,"wdate07",swdate07)		
		
		if lrowcnt4 > 1 then dw_insert.setitem(lirow,"cvdbl",'Y') // 이원화 표시
	NEXT


NEXT

// 상품
//lrowcnt5 = dw_41.retrieve(gs_saupj,syymmdd)
//
//FOR lrow5 = 1 TO lrowcnt5
//	srinbr = dw_41.getitemstring(lrow5,'itnbr')
//	spinbr = dw_41.getitemstring(lrow5,'itnbryd')
//	
//	st_info1.text = '상품 계획 추가 :'
//	st_info2.text = srinbr
//
//	dm01 = dw_41.getitemnumber(lrow5,'d01')
//	dm02 = dw_41.getitemnumber(lrow5,'d02')
//	dm03 = dw_41.getitemnumber(lrow5,'d03')
//	dm04 = dw_41.getitemnumber(lrow5,'d04')
//	dm05 = dw_41.getitemnumber(lrow5,'d05')
//	dm06 = dw_41.getitemnumber(lrow5,'d06')
//	dm07 = dw_41.getitemnumber(lrow5,'d07')
//
//
//	// 재고 계산 =======================================================
//   select nvl(sum(jego_qty),0) into :djego from stock       //재고
//	 where depot_no = 'Z01' and itnbr = :spinbr ;
//
//
//	syymmdd_pre =f_afterday(syymmdd,-7)
//			
//	Select NVL(Sum(qtp_06),0) + NVL(Sum(qtp_07),0)  ,        // 해당계획년월의 해당주차릥 예상재고를 구한다
//	       NVL(Sum(qty_06),0) + NVL(Sum(qtp_07),0)           // 예상 재고 = 현시점의 재고( 해당주 금요일시점) 
//	  Into :dqtp_pre , :dqty_pre                             //             - 전주의 토,일요일 생산에 필요한 수량 +  전주의 토,일요일구매계획 수량 
//	  from pu03_weekplan 
//	 where sabu = :gs_saupj
//	   and yymmdd = :syymmdd_pre
//	   and itnbr = :srinbr ;
//			  
//	if sqlca.sqlcode <> 0 then 
//		dqtp_pre = 0 
//		dqty_pre = 0 
//	End If
//			
//	djego = djego - dqtp_pre + dqty_pre          
//	
//	select itdsc, shrat, ldtim2, nvl(minqt,0), nvl(minsaf,0), nvl(midsaf,0), nvl(maxsaf,0), nvl(mnapqty,0)
//	  into :sitdsc, :dshrat, :dldtim2, :dpalqty, :dminsaf, :dmidsaf, :dmaxsaf, :dmonmax
//	  from itemas
//	 where itnbr = :srinbr ;
//	 
//	if sqlca.sqlcode <> 0 then 
//		dshrat = 0
//		dldtim2= 0
//		dminsaf= 0
//		dmidsaf= 0
//		dmaxsaf= 0
//	end if
//
//	lrowcnt4 = dw_6.retrieve(srinbr,syymmdd)
//
////////////////////////////////////////////////////////////////////////////////////////////////
//// 이원화 및 발주비율 적용 - START - 2004.01.05
//	if lrowcnt4 = 1 then
//		scvcod  = sjasa
//		lrowcnt4= 1
//	elseIf lrowcnt4 > 1 Then
//		scvcod  = dw_6.getitemstring(1,'cvcod')
//	end if	
//
//	FOR lrow4 = 1 TO lrowcnt4
//		if scvcod = sjasa and lrowcnt4 = 1 then
//			dporate = 1.0
//			dweekcnt = 1
//			dunprc  = 0
//		else
//			scvcod  = dw_6.getitemstring(lrow4,'cvcod')
//			dporate = dw_6.getitemnumber(lrow4,'porate')
//			dweekcnt = dw_6.getitemnumber(lrow4,'weekcnt')
//			dunprc  = dw_6.getitemnumber(lrow4,'unprc')
//		end if
//	
//		smwgbn  = dw_6.getitemstring(lrow4,'mwgbn')
//		swdate01= dw_6.getitemstring(lrow4,'wdate01')
//		swdate02= dw_6.getitemstring(lrow4,'wdate02')
//		swdate03= dw_6.getitemstring(lrow4,'wdate03')
//		swdate04= dw_6.getitemstring(lrow4,'wdate04')
//		swdate05= dw_6.getitemstring(lrow4,'wdate05')
//		swdate06= dw_6.getitemstring(lrow4,'wdate06')
//		swdate07= dw_6.getitemstring(lrow4,'wdate07')
//		
//		lirow = dw_insert.insertrow(0)
//		
//		dw_insert.setitem(lirow,"sabu",gs_saupj)
//		dw_insert.setitem(lirow,"yymmdd",syymmdd)
//		dw_insert.setitem(lirow,"waigb",'1')
//		dw_insert.setitem(lirow,"cvcod",scvcod)
//		select cvnas into :scvnas from vndmst where cvcod = :scvcod ;
//		dw_insert.setitem(lirow,"vndmst_cvnas",scvnas)
//		dw_insert.setitem(lirow,"itnbr",srinbr)
//		dw_insert.setitem(lirow,"itemas_itdsc",sitdsc)
//		dw_insert.setitem(lirow,"unprc",dunprc)
//		dw_insert.setitem(lirow,"minqt",dpalqty)
//		
//		dw_insert.setitem(lirow,"minsaf",dminsaf)
//		dw_insert.setitem(lirow,"midsaf",dmidsaf)
//		dw_insert.setitem(lirow,"maxsaf",dmaxsaf)	
//		
//		dw_insert.setitem(lirow,"itemas_minsaf",dminsaf)
//		dw_insert.setitem(lirow,"itemas_midsaf",dmidsaf)
//		dw_insert.setitem(lirow,"itemas_maxsaf",dmaxsaf)
//		
//		dw_insert.setitem(lirow,"monmax",dmonmax)
//		dw_insert.setitem(lirow,"weekcnt",dweekcnt)
//		dw_insert.setitem(lirow,"daymax",Round(dmonmax/Long(f_last_date(syymmdd)),0))
//		dw_insert.setitem(lirow,"jgoqty",djego)
//		dw_insert.setitem(lirow,"porate",dporate)
//		dw_insert.setitem(lirow,"shrat",dshrat)
//		dw_insert.setitem(lirow,"qtp_01",dm01)
//		dw_insert.setitem(lirow,"qtp_02",dm02)
//		dw_insert.setitem(lirow,"qtp_03",dm03)
//		dw_insert.setitem(lirow,"qtp_04",dm04)
//		dw_insert.setitem(lirow,"qtp_05",dm05)
//		dw_insert.setitem(lirow,"qtp_06",dm06)
//		dw_insert.setitem(lirow,"qtp_07",dm07)
//		dw_insert.setitem(lirow,"smorpm",smorpm)
//		dw_insert.setitem(lirow,"jegoyn",sjegoyn)
//		dw_insert.setitem(lirow,"mwgbn",smwgbn)
//		dw_insert.setitem(lirow,"wdate01",swdate01)
//		dw_insert.setitem(lirow,"wdate02",swdate02)
//		dw_insert.setitem(lirow,"wdate03",swdate03)
//		dw_insert.setitem(lirow,"wdate04",swdate04)
//		dw_insert.setitem(lirow,"wdate05",swdate05)
//		dw_insert.setitem(lirow,"wdate06",swdate06)
//		dw_insert.setitem(lirow,"wdate07",swdate07)
//		
//		if lrowcnt4 > 1 then dw_insert.setitem(lirow,"cvdbl",'Y') // 이원화 표시
//	NEXT
//NEXT	

st_info.visible = false
st_info1.visible = false
st_info2.visible = false
end subroutine

public function integer wf_check_ps_plan ();string	syymmdd, spdtgu, stemp, smorpm, smessage
integer	irtn

if dw_1.accepttext() = -1 then return -1

syymmdd = trim(dw_1.getitemstring(1,'sdate'))
smorpm= dw_1.getitemstring(1,'smorpm')

smessage = syymmdd+'주간 생산 계획 확정 현황				~n'
smessage = smessage+'----------------------------------~n'

if smorpm = 'P' then
//	select a.yymmdd into :stemp from pm02_weekplan_sum a, itemas b
//	 where a.sabu = '1' and a.yymmdd = :syymmdd and a.moseq = 0 
//	   and a.itnbr = b.itnbr and b.jocod = '311' and rownum = 1 ;
//	if sqlca.sqlcode = 0 then
//		smessage = smessage+'생산1팀1반		확정~n'
//	else
//		smessage = smessage+'생산1팀1반		미확정~n'
//		irtn = -1
//	end if
//
//	select a.yymmdd into :stemp from pm02_weekplan_sum a, itemas b
//	 where a.sabu = '1' and a.yymmdd = :syymmdd and a.moseq = 0 
//	   and a.itnbr = b.itnbr and b.jocod = '312' and rownum = 1 ;
//	if sqlca.sqlcode = 0 then
//		smessage = smessage+'생산1팀2반		확정~n'
//	else
//		smessage = smessage+'생산1팀2반		미확정~n'
//		irtn = -1
//	end if
//
//	select a.yymmdd into :stemp from pm02_weekplan_sum a, itemas b
//	 where a.sabu = '1' and a.yymmdd = :syymmdd and a.moseq = 0 
//	   and a.itnbr = b.itnbr and b.jocod = '313' and rownum = 1 ;
//	if sqlca.sqlcode = 0 then
//		smessage = smessage+'생산1팀3반		확정~n'
//	else
//		smessage = smessage+'생산1팀3반		미확정~n'
//		irtn = -1
//	end if
//
//	select a.yymmdd into :stemp from pm02_weekplan_sum a, itemas b
//	 where a.sabu = '1' and a.yymmdd = :syymmdd and a.moseq = 0 
//	   and a.itnbr = b.itnbr and b.jocod = '321' and rownum = 1 ;
//	if sqlca.sqlcode = 0 then
//		smessage = smessage+'생산2팀1반		확정~n'
//	else
//		smessage = smessage+'생산2팀1반		미확정~n'
//		irtn = -1
//	end if
//
//	select a.yymmdd into :stemp from pm02_weekplan_sum a, itemas b
//	 where a.sabu = '1' and a.yymmdd = :syymmdd and a.moseq = 0 
//	   and a.itnbr = b.itnbr and b.jocod = '322' and rownum = 1 ;
//	if sqlca.sqlcode = 0 then
//		smessage = smessage+'생산2팀2반		확정~n'
//	else
//		smessage = smessage+'생산2팀2반		미확정~n'
//		irtn = -1
//	end if
//
//	select a.yymmdd into :stemp from pm02_weekplan_sum a, itemas b
//	 where a.sabu = '1' and a.yymmdd = :syymmdd and a.moseq = 0 
//	   and a.itnbr = b.itnbr and b.jocod = '323' and rownum = 1 ;
//	if sqlca.sqlcode = 0 then
//		smessage = smessage+'생산2팀3반		확정~n'
//	else
//		smessage = smessage+'생산2팀3반		미확정~n'
//		irtn = -1
//	end if

	select a.yymmdd into :stemp from pm02_weekplan_sum a, itemas b
	 where a.sabu = '1' and a.yymmdd = :syymmdd and a.moseq = 0 
	   and a.itnbr = b.itnbr and rownum = 1 ;
	if sqlca.sqlcode = 0 then
		smessage = smessage+'생산팀		확정~n'
	else
		smessage = smessage+'생산팀		미확정~n'
		irtn = -1
	end if
	
	if irtn = -1 then
		messagebox('확인',smessage)
		return -1
	end if

//	select yymmdd into :stemp from sm03_weekplan_item
//	 where saupj = :gs_saupj and yymmdd = :syymmdd and cnfirm is not null and rownum = 1 ;
//	if sqlca.sqlcode <> 0 then
//		messagebox('확인',syymmdd + ' 상품 전개를 위한 주간 판매계획이 확정되지 않았습니다.')
//		return -1
//	end if

else
	select yymmdd into :stemp from sm03_weekplan_item
	 where saupj = :gs_saupj and yymmdd = :syymmdd and cnfirm is not null and rownum = 1 ;
	if sqlca.sqlcode <> 0 then
		messagebox('확인',syymmdd + ' 주간 판매계획이 확정되지 않았습니다.')
		return -1
	end if
end if

return 1
end function

public function integer wf_chart (long ar_row);int				i, j, li_colno = 0, li_rowcnt = 12
st_chartdata	lst_chartdata
String			syymm, sYear, sCvcod, sItnbr

if dw_insert.rowcount() <= 0 then return -1

syymm  = dw_insert.GetItemString(ar_row, 'yymmdd')
sCvcod = dw_insert.GetItemString(ar_row, 'cvcod')
sItnbr = dw_insert.GetItemString(ar_row, 'itnbr')

dw_chart.retrieve(gs_saupj, left(syymm, 4), sCvcod, sItnbr)

lst_chartdata.toptitle  = '월 최대납품량 / 구매계획'
lst_chartdata.rowcnt    = li_rowcnt

// Series 숫자
lst_chartdata.colcnt = 2
//lst_chartdata.colcnt    = dw_list.rowcount() -2

for i = 1 to 12
	lst_chartdata.rowname[i] = string(i) + '월'
next

/* 월최대납품량 */
//lst_chartdata.colname[1] = '최대납품량'
////lst_chartdata.pointlabels[1] = true
//lst_chartdata.gallery[1] = ole_chart.uc_bar
//
//for j = 1 to 12
//	lst_chartdata.value[j,1] = dw_chart.getitemdecimal(1, 'monmax' + string(j, '00'))
//next

///* 월구매계획 */
//lst_chartdata.colname[2] = '구매계획'
////lst_chartdata.pointlabels[2] = true
//lst_chartdata.gallery[2] = ole_chart.uc_bar
//
//for j = 1 to 12
//	lst_chartdata.value[j,2] = dw_chart.getitemdecimal(1, 'plan_qty' + string(j, '00'))
//next
//
//ole_chart.setdata(lst_chartdata)

return 1

end function

public subroutine wf_excel_down (datawindow adw_excel);String	ls_quota_no
integer	li_rc
string	ls_filepath, ls_filename
boolean	lb_fileexist

li_rc = GetFileSaveName("저장할 파일명을 선택하세요." , ls_filepath , &
											  ls_filename , "XLS" , "Excel Files (*.xls),*.xls")												
IF li_rc = 1 THEN
	IF lb_fileexist THEN
		li_rc = MessageBox("파일저장" , ls_filepath + " 파일이 이미 존재합니다.~r~n" + &
												 "기존의 파일을 덮어쓰시겠습니까?" , Question! , YesNo! , 1)
		IF li_rc = 2 THEN 
			w_mdi_frame.sle_msg.text = "자료다운취소!!!"			
			RETURN
		END IF
	END IF
	
	Setpointer(HourGlass!)
	
 	If uf_save_dw_as_excel(adw_excel,ls_filepath) <> 1 Then
		w_mdi_frame.sle_msg.text = "자료다운실패!!!"
		return
	End If

END IF

w_mdi_frame.sle_msg.text = "자료다운완료!!!"
end subroutine

public subroutine wf_set_ckd_qty ();String ls_yymm

ls_yymm = dw_1.GetItemString(1, 'sdate')
If Trim(ls_yymm) = '' OR IsNull(ls_yymm) Then Return

DECLARE sm_pln CURSOR FOR
	  SELECT A.ITNBR        ,
	  			I.ITGU         ,
	  			SUM(A.ITM_QTY1),
				SUM(A.ITM_QTY2),
				SUM(A.ITM_QTY3),
				SUM(A.ITM_QTY4),
				SUM(A.ITM_QTY5),
				SUM(A.ITM_QTY6),
				SUM(A.ITM_QTY7)
		 FROM SM03_WEEKPLAN_ITEM A,
		 		ITEMAS             I
		WHERE A.SAUPJ  =  :gs_saupj
		  AND A.YYMMDD =  :ls_yymm
		  AND A.GUBUN  =  'CKD'
		  AND I.ITGU   <> '5'
		  AND I.GBWAN  =  'Y'
		  AND I.GBGUB  =  '1'
		  AND I.USEYN  =  '0'
		  AND A.ITNBR  =  I.ITNBR
	GROUP BY A.ITNBR, I.ITGU ;
	
OPEN sm_pln;

String ls_itnbr
String ls_itgu
String ls_gubun
Long   ll_qty1, ll_pu01
Long   ll_qty2, ll_pu02
Long   ll_qty3, ll_pu03
Long   ll_qty4, ll_pu04
Long   ll_qty5, ll_pu05
Long   ll_qty6, ll_pu06
Long   ll_qty7, ll_pu07

//Long   ll_ins
DO WHILE TRUE
	FETCH sm_pln INTO :ls_itnbr, :ls_itgu, :ll_qty1, :ll_qty2, :ll_qty3, :ll_qty4, :ll_qty5, :ll_qty6, :ll_qty7 ;
	If SQLCA.SQLCODE <> 0 Then Exit
	
	If ls_itgu = '2' Then
		ls_gubun = '1'
	ElseIf ls_itgu = '6' Then
		ls_gubun = '2'
	End If	
	
	UPDATE PU03_WEEKPLAN
	   SET QTP_01 = QTP_01 - :ll_qty1,
		    QTP_01 = QTP_02 - :ll_qty2,
			 QTP_01 = QTP_03 - :ll_qty3,
			 QTP_01 = QTP_04 - :ll_qty4,
			 QTP_01 = QTP_05 - :ll_qty5,
			 QTP_01 = QTP_06 - :ll_qty6,
			 QTP_01 = QTP_07 - :ll_qty7
	 WHERE YYMMDD =  :ls_yymm
	   AND ITNBR  =  :ls_itnbr
		AND WAIGB  =  :ls_gubun
		AND CVCOD  <> '100000' ;
	If SQLCA.SQLCODE <> 0 Then
		ROLLBACK USING SQLCA;
		MessageBox('CKD 제외 처리', 'CKD용 완제품 수량을 제외 중 오류가 발생했습니다.')
		Return
	End If
	
	/* TEST용
	  SELECT SUM(QTP_01), SUM(QTP_02), SUM(QTP_03), SUM(QTP_04), SUM(QTP_05), SUM(QTP_06), SUM(QTP_07)
	    INTO :ll_pu01   , :ll_pu02   , :ll_pu03   , :ll_pu04   , :ll_pu05   , :ll_pu06   , :ll_pu07
		 FROM PU03_WEEKPLAN
		WHERE YYMMDD =  :ls_yymm
		  AND ITNBR  =  :ls_itnbr
		  AND WAIGB  =  :ls_gubun
		  AND CVCOD  <> '100000' ;
	If SQLCA.SQLCODE <> 0 Then Continue
	
	ll_ins = dw_5.InsertRow(0)
	
	dw_5.SetItem(ll_ins, 'itnbr' , ls_itnbr)
	dw_5.SetItem(ll_ins, 'qty1'  , ll_qty1 )
	dw_5.SetItem(ll_ins, 'qty2'  , ll_qty2 )
	dw_5.SetItem(ll_ins, 'qty3'  , ll_qty3 )
	dw_5.SetItem(ll_ins, 'qty4'  , ll_qty4 )
	dw_5.SetItem(ll_ins, 'qty5'  , ll_qty5 )
	dw_5.SetItem(ll_ins, 'qty6'  , ll_qty6 )
	dw_5.SetItem(ll_ins, 'qty7'  , ll_qty7 )
	dw_5.SetItem(ll_ins, 'qty8'  , ll_pu01 )
	dw_5.SetItem(ll_ins, 'qty9'  , ll_pu02 )
	dw_5.SetItem(ll_ins, 'qty10' , ll_pu03 )
	dw_5.SetItem(ll_ins, 'qty11' , ll_pu04 )
	dw_5.SetItem(ll_ins, 'qty12' , ll_pu05 )
	dw_5.SetItem(ll_ins, 'qty13' , ll_pu06 )
	dw_5.SetItem(ll_ins, 'qty14' , ll_pu07 ) */
	
LOOP

If SQLCA.SQLCODE = 0 Then
	COMMIT USING SQLCA;
Else
	ROLLBACK USING SQLCA;
	MessageBox('CKD 제외 처리', 'CKD용 완제품 수량 제외 중 오류가 발생했습니다.')
	Return
End If

end subroutine

public function integer wf_qty (long row);return 1
end function

on w_pu01_00030.create
int iCurrent
call super::create
this.rr_2=create rr_2
this.dw_4=create dw_4
this.st_info=create st_info
this.st_info2=create st_info2
this.rr_1=create rr_1
this.st_info1=create st_info1
this.dw_6=create dw_6
this.dw_3=create dw_3
this.dw_1=create dw_1
this.dw_41=create dw_41
this.dw_insert2=create dw_insert2
this.dw_7=create dw_7
this.p_1=create p_1
this.dw_chart=create dw_chart
this.pb_1=create pb_1
this.dw_hidden=create dw_hidden
this.p_2=create p_2
this.dw_2=create dw_2
this.st_2=create st_2
this.cb_1=create cb_1
this.rr_4=create rr_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
this.Control[iCurrent+2]=this.dw_4
this.Control[iCurrent+3]=this.st_info
this.Control[iCurrent+4]=this.st_info2
this.Control[iCurrent+5]=this.rr_1
this.Control[iCurrent+6]=this.st_info1
this.Control[iCurrent+7]=this.dw_6
this.Control[iCurrent+8]=this.dw_3
this.Control[iCurrent+9]=this.dw_1
this.Control[iCurrent+10]=this.dw_41
this.Control[iCurrent+11]=this.dw_insert2
this.Control[iCurrent+12]=this.dw_7
this.Control[iCurrent+13]=this.p_1
this.Control[iCurrent+14]=this.dw_chart
this.Control[iCurrent+15]=this.pb_1
this.Control[iCurrent+16]=this.dw_hidden
this.Control[iCurrent+17]=this.p_2
this.Control[iCurrent+18]=this.dw_2
this.Control[iCurrent+19]=this.st_2
this.Control[iCurrent+20]=this.cb_1
this.Control[iCurrent+21]=this.rr_4
end on

on w_pu01_00030.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_2)
destroy(this.dw_4)
destroy(this.st_info)
destroy(this.st_info2)
destroy(this.rr_1)
destroy(this.st_info1)
destroy(this.dw_6)
destroy(this.dw_3)
destroy(this.dw_1)
destroy(this.dw_41)
destroy(this.dw_insert2)
destroy(this.dw_7)
destroy(this.p_1)
destroy(this.dw_chart)
destroy(this.pb_1)
destroy(this.dw_hidden)
destroy(this.p_2)
destroy(this.dw_2)
destroy(this.st_2)
destroy(this.cb_1)
destroy(this.rr_4)
end on

event open;call super::open;dw_1.SetTransObject(sqlca)
dw_3.SetTransObject(sqlca)
dw_insert.SetTransObject(sqlca)
dw_insert2.SetTransObject(sqlca)
dw_4.SetTransObject(sqlca)
dw_41.SetTransObject(sqlca)
dw_6.SetTransObject(sqlca)
dw_chart.SetTransObject(sqlca)

wf_initial()
end event

type dw_insert from w_inherite`dw_insert within w_pu01_00030
integer x = 23
integer y = 292
integer width = 4553
integer height = 1544
string dataobject = "d_pu01_00030_2_m"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemerror;call super::itemerror;return 1
end event

event dw_insert::rowfocuschanged;call super::rowfocuschanged;this.selectrow(0,false)
if currentrow <= 0 then return
this.selectrow(currentrow,true)
post wf_set_info(this,currentrow)

//wf_chart(currentrow)
end event

event dw_insert::doubleclicked;call super::doubleclicked;if row <= 0 then return

if left(dwo.name,2) = 'qt' then
	gs_gubun	= trim(dw_1.getitemstring(1,'sdate'))
	gs_code  = this.getitemstring(row,'itnbr')
	gs_codename = this.getitemstring(row,'itemas_itdsc')
	gs_codename2= right(dwo.name,2)

	open(w_plancheck_popup)
	
elseif dwo.name = 'itnbr' then
//	String ls_itnbr
//	ls_itnbr = This.GetItemString(row, 'itnbr')
//	dw_2.Retrieve(ls_itnbr)
//	dw_2.Visible = True
end if
end event

event dw_insert::clicked;call super::clicked;this.setrow(row)
this.trigger event rowfocuschanged(row)
end event

event dw_insert::itemchanged;call super::itemchanged;if row <= 0 then return

if this.getcolumnname() = 'cvdbl' then
	string	sitnbr, sitdsc, scvnas, sok 
	decimal	dunprc 
	long Tpackqty , TTqty , sSal 
	
	string Tqty1 , Tqty2 , Tqty3 , Tqty4 , Tqty5 , Tqty6 , Tqty7
	
	sitnbr = this.getitemstring(row,'itnbr')
	sitdsc = this.getitemstring(row,'itemas_itdsc')
	
	gs_code = sitnbr
	gs_codename = sitdsc
	
	open(w_cvdouble_popup)
	sok = message.stringparm
	if sok = 'OK' then
		this.rowscopy(row,row,primary!,this,row+1,primary!)
		
		select unprc 
		into :dunprc 
		from danmst
		 where itnbr = sitnbr 
		 and cvcod = :gs_code 
		 and opseq = '9999';
		
		if sqlca.sqlcode <> 0 then dunprc = 0
		
		this.setitem(row+1,'cvcod',gs_code)
		this.setitem(row+1,'vndmst_cvnas',gs_codename)
		this.setitem(row+1,'unprc',gs_codename)
		this.setitem(row+1,"qty_01",0)
		this.setitem(row+1,"qty_02",0)
		this.setitem(row+1,"qty_03",0)
		this.setitem(row+1,"qty_04",0)
		this.setitem(row+1,"qty_05",0)
		this.setitem(row+1,"qty_06",0)
		this.setitem(row+1,"qty_07",0)
		
		this.setitem(row,"cvdbl",'N')
		this.setitem(row+1,"cvdbl",'N')
	end if
end if

if this.getcolumnname() = 'qty_01' then
    
    Tqty1 = this.getText()
    Tpackqty = dw_3.getitemnumber(1,'itemas_packqty')

    if Tpackqty = 0 or long(Tqty1) = 0  then
    
    else
            if  long(Tqty1) < Tpackqty then
                
              	  Messagebox('확인', '용기당수량 ( ' + string(Tpackqty) +' ) 의 배수만 입력 가능합니다.')      
				  this.setitem(row ,"qty_01",0)
                    dw_insert.SetColumn('qty_01')
                    dw_insert.SetFocus()
                    return 1
            else
                select mod( :Tqty1,:Tpackqty ) as sal
                into :sSal
                from dual;
                    
                    if sSal <> 0 then
							
                    	       Messagebox('확인', '용기당수량 ( ' + string(Tpackqty) +' ) 의 배수만 입력 가능합니다.')
						   this.setitem(row ,"qty_01",0)
						  dw_insert.SetColumn('qty_01')
						  dw_insert.SetFocus()
               		return 1
							
                    else
                    end if
            end if
        end if
        
elseif this.getcolumnname() = 'qty_02' then
    
    Tqty2 = this.getText()
    Tpackqty = dw_3.getitemnumber(1,'itemas_packqty')
    if Tpackqty = 0 or long(Tqty2) = 0  then
    else
            if  long(Tqty2) < Tpackqty then
                
				  Messagebox('확인', '용기당수량 ( ' + string(Tpackqty) +' ) 의 배수만 입력 가능합니다.')
                    this.setitem(row ,"qty_02",0)
                    dw_insert.SetColumn('qty_02')
                    dw_insert.SetFocus()
                    return 1
            else
                select mod( :Tqty2,:Tpackqty ) as sal
                into :sSal
                from dual;
                
                    if sSal <> 0 then
                    
					   Messagebox('확인', '용기당수량 ( ' + string(Tpackqty) +' ) 의 배수만 입력 가능합니다.')  
                        this.setitem(row ,"qty_02",0)
                        dw_insert.SetColumn('qty_02')
                 	      dw_insert.SetFocus()
                        return 1
                    else
                    end if
            end if
        end if
        
elseif this.getcolumnname() = 'qty_03' then
    
    Tqty3 = this.getText()
    Tpackqty = dw_3.getitemnumber(1,'itemas_packqty')

    if Tpackqty = 0 or long(Tqty3) = 0  then
    
    else
            if  long(Tqty3) < Tpackqty then
                
               	   Messagebox('확인', '용기당수량 ( ' + string(Tpackqty) +' ) 의 배수만 입력 가능합니다.')     
				   this.setitem(row ,"qty_03",0)
                    dw_insert.SetColumn('qty_03')
                    dw_insert.SetFocus()
                    return 1
            else
                select mod( :Tqty3,:Tpackqty ) as sal
                into :sSal
                from dual;
                
                    if sSal <> 0 then
                        
					 Messagebox('확인', '용기당수량 ( ' + string(Tpackqty) +' ) 의 배수만 입력 가능합니다.')
                        this.setitem(row ,"qty_03",0)
                        dw_insert.SetColumn('qty_03')
                        dw_insert.SetFocus()
                        return 1
                    else
                    end if
            end if
        end if
        
elseif this.getcolumnname() = 'qty_04' then
    
    Tqty4 = this.getText()
    Tpackqty = dw_3.getitemnumber(1,'itemas_packqty')
    if Tpackqty = 0 or long(Tqty4) = 0  then
    else
            if  long(Tqty4) < Tpackqty then
					
					  Messagebox('확인', '용기당수량 ( ' + string(Tpackqty) +' ) 의 배수만 입력 가능합니다.')
                        this.setitem(row ,"qty_04",0)
                       dw_insert.SetColumn('qty_04')
                      dw_insert.SetFocus()
            			return 1
            else
                select mod( :Tqty4,:Tpackqty ) as sal
                into :sSal
                from dual;
                
                    if sSal <> 0 then
								Messagebox('확인', '용기당수량 ( ' + string(Tpackqty) +' ) 의 배수만 입력 가능합니다.')
								this.setitem(row ,"qty_04",0)
								dw_insert.SetColumn('qty_04')
								dw_insert.SetFocus()
								return 1
                    else
                    end if
            end if
        end if
        
elseif this.getcolumnname() = 'qty_05' then
    
    Tqty5 = this.getText()
    Tpackqty = dw_3.getitemnumber(1,'itemas_packqty')
    if Tpackqty = 0 or long(Tqty5) = 0  then
    else
            if  long(Tqty5) < Tpackqty then
              	  Messagebox('확인', '용기당수량 ( ' + string(Tpackqty) +' ) 의 배수만 입력 가능합니다.')    
				  this.setitem(row ,"qty_05",0)
                    dw_insert.SetColumn('qty_05')
                    dw_insert.SetFocus()
                    return 1
            else
                select mod( :Tqty5,:Tpackqty ) as sal
                into :sSal
                from dual;
                    
                    if sSal <> 0 then
							  Messagebox('확인', '용기당수량 ( ' + string(Tpackqty) +' ) 의 배수만 입력 가능합니다.')
								this.setitem(row ,"qty_05",0)
							  dw_insert.SetColumn('qty_05')
							  dw_insert.SetFocus()
								return 1
                    else
                    end if
            end if
        end if
        
elseif this.getcolumnname() = 'qty_06' then
    
    Tqty6 = this.getText()
    Tpackqty = dw_3.getitemnumber(1,'itemas_packqty')
    if Tpackqty = 0 or long(Tqty6) = 0  then
    else
            if  long(Tqty6) < Tpackqty then
            		Messagebox('확인', '용기당수량 ( ' + string(Tpackqty) +' ) 의 배수만 입력 가능합니다.')  		          
				this.setitem(row ,"qty_06",0)
                    dw_insert.SetColumn('qty_06')
                    dw_insert.SetFocus()
                    return 1
            else
                select mod( :Tqty6,:Tpackqty ) as sal
                into :sSal
                from dual;
                    if sSal <> 0 then
						Messagebox('확인', '용기당수량 ( ' + string(Tpackqty) +' ) 의 배수만 입력 가능합니다.')      
						 dw_insert.SetColumn('qty_06')
						 dw_insert.SetFocus()
						return 1
                    else
                    end if
            end if
        end if
elseif this.getcolumnname() = 'qty_07' then
    
    Tqty7 = this.getText()
    Tpackqty = dw_3.getitemnumber(1,'itemas_packqty')
    if Tpackqty = 0 or long(Tqty7) = 0  then
    else
            if  long(Tqty7) < Tpackqty then
                    Messagebox('확인', '용기당수량 ( ' + string(Tpackqty) +' ) 의 배수만 입력 가능합니다.')
				   this.setitem(row ,"qty_07",0)
                    dw_insert.SetColumn('qty_07')
                    dw_insert.SetFocus()
                    return 1
            else
                select mod( :Tqty7,:Tpackqty ) as sal
                into :sSal
                from dual;
                    if sSal <> 0 then
						 Messagebox('확인', '용기당수량 ( ' + string(Tpackqty) +' ) 의 배수만 입력 가능합니다.')
						  this.setitem(row ,"qty_07",0)
							dw_insert.SetColumn('qty_07')
						  dw_insert.SetFocus()
							return 1
                    else
                    end if
            end if
        end if
end if

this.selectrow(0,false)
post wf_set_info(this,row)

end event

type p_delrow from w_inherite`p_delrow within w_pu01_00030
integer x = 3451
integer y = 36
end type

event p_delrow::clicked;call super::clicked;Long 		nRow
string	smagam

if dw_1.accepttext() = -1 then return
If dw_insert.rowcount() < 1 Then Return

smagam = dw_1.getitemstring(1,'cnfirm')
if smagam = 'Y' then
	messagebox("확인","확정처리된 자료입니다.")
	return
end if

nRow = dw_insert.GetRow()
if nrow < 1 then return
if dw_insert.getitemstring(nrow,'save_yn') <> 'M' then
	messagebox('확인','행추가한 자료만 삭제 가능합니다.')
	return
end if

If f_msg_delete() <> 1 Then	REturn
dw_insert.DeleteRow(nRow)
end event

type p_addrow from w_inherite`p_addrow within w_pu01_00030
integer x = 3278
integer y = 36
end type

event p_addrow::clicked;call super::clicked;String 	syymmdd, scvcod, scvnas, sitnbr, sitdsc, smagam, spdtgu, smorpm, sopt
Long	 	k, lrow, lins, lfrow
decimal	dshrat, dldtim2, dpalqty, dmidsaf, dmonmax, djego, dunprc, dporate, dmoncnt

If dw_1.AcceptText() = -1 Then Return
//If dw_insert.rowcount() < 1 Then Return

syymmdd = Trim(dw_1.GetItemString(1, 'sdate'))
If f_datechk(syymmdd) = -1 Then
	f_message_chk(1400,'')
	Return
End If

smagam = dw_1.getitemstring(1,'cnfirm')
if smagam = 'Y' then
	messagebox("확인","확정처리된 자료입니다.")
	return
end if

smorpm = dw_1.getitemstring(1,'smorpm')

setnull(gs_gubun)
setnull(gs_code)
setnull(gs_codename)

lrow = dw_insert.GetRow()
if lrow > 0 then 
	gs_code = dw_insert.getitemstring(lrow,'cvcod')
	gs_codename = dw_insert.getitemstring(lrow,'vndmst_cvnas')
end if

//gs_gubun = 'X' // 외주품은 제외
open(w_vnditem_popup4)
if Isnull(gs_code) or Trim(gs_code) = "" then return

scvcod = gs_code

SetPointer(HourGlass!)

dw_hidden.reset()
dw_hidden.ImportClipboard()

dw_insert.setredraw(false)

FOR k=1 TO dw_hidden.rowcount()
	sopt = dw_hidden.getitemstring(k, 'opt')
	
	if sopt = 'Y' then 
		sitnbr = dw_hidden.getitemstring(k, 'poblkt_itnbr')
		lfrow = dw_insert.find("cvcod='"+scvcod+"' and itnbr='"+sitnbr+"'",1,dw_insert.rowcount())
		if lfrow > 0 then
			messagebox('확인','추가하려는 품목 '+sitnbr+' 은 이미 존재합니다.')
		else
			lins = dw_insert.InsertRow(0)
	
			dw_insert.SetItem(lins,'sabu',gs_saupj)
			dw_insert.SetItem(lins,'yymmdd',syymmdd)
			dw_insert.setitem(lins,"waigb",'1')
			
			////////////////////////////////////////////////////////////////////////////////////////
			/* 추가품목의 단가는 거래처별 단가 지정. - BY SHINGOON 2007.09.28
			select cvnas, fun_danmst_danga10(:syymmdd||'01',cvcod,:sitnbr,'.')
			  into :scvnas, :dunprc
			  from vndmst
			 where cvcod = :scvcod ; */
			//fun_danmst_danga6(품번, 거래처, 공정코드, 일자, 구매/외주구분('1'구매, '2'외주))
			SELECT CVNAS, FUN_DANMST_DANGA6(:sitnbr, CVCOD, '9999', :syymmdd||'01', '1')
			  INTO :scvnas, :dunprc
			  FROM VNDMST
			 WHERE CVCOD = :scvcod ;
			 
			dw_insert.SetItem(lins,'cvcod',scvcod)
			dw_insert.SetItem(lins,'vndmst_cvnas',scvnas)		
			
	
			
			// 재고 계산 =====================================================================
			select itdsc, shrat, ldtim2, nvl(minqt,0), nvl(midsaf,0), nvl(mnapqty,0), nvl(pdtgu,'1')
			  into :sitdsc, :dshrat, :dldtim2, :dpalqty, :dmidsaf, :dmonmax, :spdtgu
			  from itemas
			 where itnbr = :sitnbr ;
					 
			if sqlca.sqlcode = 0 then 
			end if
		
			select nvl(sum(a.jego_qty),0) 
			  into :djego 
			  from stock a
			 where a.itnbr = :sitnbr
				and exists ( select 'x' from vndmst
								  where cvcod = a.depot_no	and soguan < '4' and jumaechul < '3' ) ;
					 
			if sqlca.sqlcode <> 0 then djego = 0
	
			dw_insert.SetItem(lins,'itnbr',sitnbr)
			dw_insert.SetItem(lins,'itemas_itdsc',sitdsc)
			dw_insert.setitem(lins,"unprc",dunprc)
			dw_insert.setitem(lins,"minqt",dpalqty)
			dw_insert.setitem(lins,"monmax",dmonmax)
			dw_insert.setitem(lins,"jgoqty",djego)
			dw_insert.setitem(lins,"shrat",dshrat)
			dw_insert.setitem(lins,"porate",dporate)
			dw_insert.setitem(lins,"moncnt",dmoncnt)
			dw_insert.setitem(lins,"minsaf",dmidsaf)
			dw_insert.setitem(lins,"smorpm",smorpm)
			dw_insert.SetItem(lins,'save_yn','M')		// MANAUL
		end if
	end if	
NEXT

dw_insert.groupcalc()
dw_insert.sort()

dw_hidden.reset()
dw_insert.ScrollToRow(lins)
dw_insert.setrow(lins)
dw_insert.SetFocus()

dw_insert.setredraw(true)

ib_any_typing = true
end event

type p_search from w_inherite`p_search within w_pu01_00030
string tag = "MRP"
integer x = 3666
integer y = 36
string picturename = "C:\erpman\image\MRP_up.gif"
end type

event p_search::clicked;string	syymm  ,sjucha ,syymmdd ,syymmdd_pre, stemp, smagam, smorpm, serror, steam
Long     ll_jucha , ll_confirm

if dw_1.accepttext() = -1 then return

smagam = dw_1.getitemstring(1,'cnfirm')
if smagam = 'Y' then
	messagebox("확인","확정처리된 자료입니다.")
	return
end if

steam = trim(dw_1.getitemstring(1,'gubun'))
if Isnull(steam) or steam = '%' then
	f_message_chk(1400,'[생산팀]')
	return
end if

syymmdd = trim(dw_1.getitemstring(1,'sdate'))
If syymmdd = '' or isNull(syymmdd) or f_datechk(syymmdd) < 0 Then
	f_message_chk(35,'[계획일자')
	Return
End if

If DayNumber(Date( Left(syymmdd,4)+'-'+Mid(syymmdd,5,2) +'-'+Right(syymmdd,2) )) <> 2 Then
	MessageBox('확 인','주간 구매계획은 월요일부터 가능합니다.!!')
	dw_1.setcolumn('sdate')
	dw_1.setfocus()
	Return
End If

smorpm= dw_1.getitemstring(1,'smorpm')

//////////////////////////////////////////////////////////////////////////////////////////////
//open(w_smorpm_popup)
//if isnull(gs_code) or gs_code = '' then return
//dw_1.setitem(1,'smorpm',gs_code)
//dw_1.setitem(1,'jegoyn',gs_gubun)

dw_1.setitem(1,'smorpm','P')
dw_1.setitem(1,'jegoyn','Y')

if wf_check_ps_plan() = -1 then 		// [1] 생산-판매계획 유무확인
	dw_1.setitem(1,'smorpm',smorpm)
//	return
end if

if wf_trans_ps_plan() = -1 then 		// [2] 생산-판매계획 전송
	dw_1.setitem(1,'smorpm',smorpm)
	return
end if

if wf_delete_pu_plan() = -1 then		// [3] 구매계획 삭제 
	dw_1.setitem(1,'smorpm',smorpm)
	return
end if

///////////////////////////////////////////////////////////////////////////////////////////
//구매계획 전송
// 실행순번의 전송구분을 검색하여 기 전송된 내역이면 전송 취소
Int	 iMaxno

Select max(actno) into :iMaxNo from mrpsys where mrpdata = 3;

serror = 'X'
/* 사업장 통합관련 프로시져 수정 - by shingoon 2015.08.24 */
//Sqlca.erp000000050_7_leewon('20', iMaxNo, syymmdd, 1, '3', steam, 'Y', serror);
Sqlca.erp000000050_7_leewon_allsaupj(gs_saupj, iMaxNo, syymmdd, 1, '3', steam, 'Y', serror);
IF serror <> 'N' THEN
	messagebox(string(sqlca.sqlcode),sqlca.sqlerrtext)
	ROLLBACK;
	messagebox("확 인", "계획ORDER 확정이 실패하였습니다.!!")
	Return
else
	Commit;
//	messagebox("확 인", "계획ORDER 확정이 되었읍니다.!!")
	
	// 구매계획 전송(총소요량 전송)인 경우 참조코드(99-3)에 실행순번을 저장
	Update reffpf
		Set rfna2 = to_char(:iMaxNo)
	 Where sabu = '1' and rfcod = '1A' and rfgub = '3';
	if sqlca.sqlcode <> 0 then		 
		Messagebox("참조코드오류", sqlca.sqlerrtext)
	end if		 
	
	Commit;
END IF
///////////////////////////////////////////////////////////////////////////////////////////

dw_insert.setredraw(false)

//wf_set_ckd_qty()        // ckd 수량 공제(구매/외주) - by shingoon 2009.02.12

wf_get_plan(syymmdd)		// 1.주간생산계획 및 상품구매의뢰 READ
//wf_set_porate()			// 발주비율적용-2004.01.06
//
wf_calc_needqty('1')		// 2.필요수량 계산
wf_calc_point('1')		// 4.납입요청량 및 납입시점 결정 ( 용기량 有 )
//wf_calc_point2('1')		//   납입요청량 및 납입시점 결정 ( 용기량 無 )

///////////////////////////////////////////////////////////////////////////////
// 유상사급품 추가 - 2003.12.18
//wf_calc_sagub()
wf_calc_sagub2()
//
wf_calc_needqty('2')
wf_calc_point('2')
//wf_calc_point2('2')
//
//wf_calc_needqty('3')
//wf_calc_point('3')
//wf_calc_point2('3')

//wf_set_qtp_org()		// 필요수량 원위치
wf_set_orgqty()		// 5.초기 필요량 설정

//wf_set_dayqty()
//wf_set_balqty()

dw_insert.setsort("sabu A, yymmdd A, waigb A, cvcod A, itnbr A")
dw_insert.sort()
dw_insert.groupcalc()
dw_insert.setredraw(true)
end event

event type long p_search::ue_lbuttondown(unsignedlong flags, integer xpos, integer ypos);call super::ue_lbuttondown;PictureName = "C:\erpman\image\MRP_dn.gif"
return 0
end event

event type long p_search::ue_lbuttonup(unsignedlong flags, integer xpos, integer ypos);call super::ue_lbuttonup;PictureName = "C:\erpman\image\MRP_up.gif"
return 0
end event

event type long p_search::ue_mousemove(unsignedlong flags, integer xpos, integer ypos);call super::ue_mousemove;//iF flags = 0 Then wf_onmouse(p_search)
return 0
end event

type p_ins from w_inherite`p_ins within w_pu01_00030
string tag = "조정"
boolean visible = false
integer x = 4800
integer y = 364
boolean originalsize = true
string picturename = "C:\erpman\image\메일전송_up.gif"
end type

event p_ins::clicked;call super::clicked;String	ls_window_id , ls_window_nm, syymm
long		ll_jucha

dw_1.accepttext()

syymm = trim(dw_1.getitemstring(1,'yymm'))
if Isnull(syymm) or syymm = '' then
	f_message_chk(1400,'[계획년월]')
	return
end if

ll_jucha = dw_1.Object.jucha[1]

ls_window_id = 'w_pu01_00030'
ls_window_nm = '주간 구매계획'

If ls_window_id = '' or isNull(ls_window_id) Then
	messagebox('','프로그램명이 없습니다.')
	return
End If

gs_code = '주간 구매계획'
gs_codename = String(sYymm,'@@@@년 @@월 ') + string(ll_jucha) + '주차 구매계획을 수립했습니다.'
OpenWithParm(w_mail_insert , ls_window_id + Space(100) + ls_window_nm)
end event

event type long p_ins::ue_lbuttondown(unsignedlong flags, integer xpos, integer ypos);//PictureName = "C:\erpman\image\조정2_dn.gif"
return 0
end event

event type long p_ins::ue_lbuttonup(unsignedlong flags, integer xpos, integer ypos);//PictureName = "C:\erpman\image\조정2_up.gif"
return 0
end event

event type long p_ins::ue_mousemove(unsignedlong flags, integer xpos, integer ypos);//iF flags = 0 Then wf_onmouse(p_ins)
return 0
end event

type p_exit from w_inherite`p_exit within w_pu01_00030
integer x = 4361
integer y = 36
end type

type p_can from w_inherite`p_can within w_pu01_00030
integer x = 4187
integer y = 36
end type

event p_can::clicked;call super::clicked;rollback ;

wf_initial()
end event

type p_print from w_inherite`p_print within w_pu01_00030
boolean visible = false
integer x = 5047
integer y = 536
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_pu01_00030
integer x = 3840
integer y = 36
end type

event p_inq::clicked;call super::clicked;string	syymm  ,sjucha ,syymmdd ,ls_confirm, sgubun, sitcls, scvcod, sittyp, sitnbr
Long     ll_jucha ,ll_cnt

if dw_1.accepttext() = -1 then return

syymmdd = trim(dw_1.getitemstring(1,'sdate'))
If syymmdd = '' or isNull(syymmdd) or f_datechk(syymmdd) < 0 Then
	f_message_chk(35,'[계획년월')
	Return
End if

If DayNumber(Date( Left(syymmdd,4)+'-'+Mid(syymmdd,5,2) +'-'+Right(syymmdd,2) )) <> 2 Then
	MessageBox('확 인','주간 구매계획은 월요일부터 가능합니다.!!')
	dw_1.setcolumn('sdate')
	dw_1.setfocus()
	Return
End If

sitcls = trim(dw_1.getitemstring(1,'itcls'))
If IsNull(sItcls) Then sItcls = ''

sittyp = trim(dw_1.getitemstring(1,'ittyp'))
If IsNull(sittyp) Then sittyp = ''

scvcod = trim(dw_1.getitemstring(1,'cvcod'))
If IsNull(scvcod) Then scvcod = ''

sitnbr = trim(dw_1.getitemstring(1,'itnbr'))
If IsNull(sitnbr) or sitnbr = '' Then sitnbr = '%'

//sgubun = trim(dw_1.getitemstring(1,'gubun'))

String  ls_saupj
ls_saupj = dw_1.GetItemString(1, 'saupj')
If IsNull(ls_saupj) OR Trim(ls_saupj) = '' Then
	f_message_chk(50,'사업장')
	Return
End If
//사업장의 생산팀
SELECT RFGUB INTO :sgubun FROM REFFPF WHERE SABU = :gs_sabu AND RFCOD = '03' AND RFNA2 = :ls_saupj AND ROWNUM = 1 ;


SELECT COUNT('X') Into :ll_cnt
  FROM PU03_WEEKPLAN
 WHERE SABU = :ls_saupj
   AND YYMMDD = :syymmdd
	AND WAIGB = '1' ;

If SQLCA.SQLCODE <> 0 or ll_cnt < 1 Then
	dw_insert.SetRedraw(false)
	dw_insert.Reset()
	dw_insert.SetRedraw(True)
	f_message_chk(50,'주간 구매계획')
	Return
End If

setpointer(hourglass!)
If dw_insert.Retrieve(ls_saupj,syymmdd,sgubun, sItcls+'%', scvcod+'%', sittyp+'%', sitnbr) <= 0 Then
	f_message_chk(50,'주간 구매계획')
End If

dw_7.setitem(1,'gubun','2')
dw_7.postevent(itemchanged!)
end event

type p_del from w_inherite`p_del within w_pu01_00030
boolean visible = false
integer x = 4864
integer y = 536
end type

type p_mod from w_inherite`p_mod within w_pu01_00030
integer x = 4014
integer y = 36
end type

event p_mod::clicked;long	 lrow
String smagam

If dw_1.AcceptText() <> 1 Then Return
If dw_insert.AcceptText() <> 1 Then Return
//If dw_insert.RowCount() <= 0 Then Return

smagam = dw_1.getitemstring(1,'cnfirm')
if smagam = 'Y' then
	messagebox("확인","마감처리된 자료입니다.")
	return
end if

if messagebox('확인',' 주간 구매계획을 저장합니다.',question!,yesno!,1) = 2 then Return 

String  ls_saupj
String  ls_itnbr

dw_insert.setredraw(false)
FOR lrow = dw_insert.rowcount() TO 1 STEP -1
	/* 품목마스터의 생산팀으로 사업장 구분 */
	/*if dw_insert.getitemstring(lrow,'crt_flag') = 'Y' then dw_insert.setitem(lrow,"sabu",gs_saupj)*/
	ls_itnbr = dw_insert.GetItemString(lrow, 'itnbr')
	SELECT PDTGU INTO :ls_saupj FROM ITEMAS WHERE ITNBR = :ls_itnbr ;
	If Trim(ls_saupj) = '' Or IsNull(ls_saupj) Then ls_saupj = '2' /* 기본생산팀은 장안생산팀으로 지정 */
	SELECT RFNA2 INTO :ls_saupj FROM REFFPF WHERE SABU = :gs_sabu AND RFCOD = '03' AND RFGUB = :ls_saupj ;
	If Trim(ls_saupj) = '' Or IsNull(ls_saupj) Then ls_saupj = '20' /* 기본사업장은 장안사업장으로 지정 */
	If dw_insert.GetItemString(lrow, 'crt_flag') = 'Y' Then dw_insert.SetItem(lrow, 'sabu', ls_saupj)
	
	dw_insert.setitem(lrow,"amt_01",Truncate(dw_insert.getitemnumber(lrow,"qty_01")*dw_insert.getitemnumber(lrow,"unprc"),0))
	dw_insert.setitem(lrow,"amt_02",Truncate(dw_insert.getitemnumber(lrow,"qty_02")*dw_insert.getitemnumber(lrow,"unprc"),0))
	dw_insert.setitem(lrow,"amt_03",Truncate(dw_insert.getitemnumber(lrow,"qty_03")*dw_insert.getitemnumber(lrow,"unprc"),0))
	dw_insert.setitem(lrow,"amt_04",Truncate(dw_insert.getitemnumber(lrow,"qty_04")*dw_insert.getitemnumber(lrow,"unprc"),0))
	dw_insert.setitem(lrow,"amt_05",Truncate(dw_insert.getitemnumber(lrow,"qty_05")*dw_insert.getitemnumber(lrow,"unprc"),0))
	dw_insert.setitem(lrow,"amt_06",Truncate(dw_insert.getitemnumber(lrow,"qty_06")*dw_insert.getitemnumber(lrow,"unprc"),0))
	dw_insert.setitem(lrow,"amt_07",Truncate(dw_insert.getitemnumber(lrow,"qty_07")*dw_insert.getitemnumber(lrow,"unprc"),0))

//	if dw_insert.getitemnumber(lrow,'sum_week') > 0 then continue
//	dw_insert.deleterow(lrow)
NEXT

setpointer(hourglass!)
dw_insert.AcceptText()

dw_insert.setredraw(true)
If dw_insert.Update() <> 1 Then
	RollBack;
	Return
End If

COMMIT;

messagebox('확인','주간 구매계획을 저장하였습니다.')
end event

type cb_exit from w_inherite`cb_exit within w_pu01_00030
integer x = 3022
integer y = 2936
boolean enabled = false
end type

type cb_mod from w_inherite`cb_mod within w_pu01_00030
integer x = 709
integer y = 2936
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within w_pu01_00030
integer x = 347
integer y = 2936
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_pu01_00030
integer x = 1070
integer y = 2936
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_pu01_00030
integer x = 1431
integer y = 2936
boolean enabled = false
end type

type cb_print from w_inherite`cb_print within w_pu01_00030
integer x = 1792
integer y = 2936
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_pu01_00030
integer x = 59
integer y = 3148
end type

type cb_can from w_inherite`cb_can within w_pu01_00030
integer x = 2117
integer y = 2896
boolean enabled = false
end type

type cb_search from w_inherite`cb_search within w_pu01_00030
integer x = 2514
integer y = 2936
boolean enabled = false
end type

type dw_datetime from w_inherite`dw_datetime within w_pu01_00030
integer x = 2903
integer y = 3148
boolean enabled = false
end type

type sle_msg from w_inherite`sle_msg within w_pu01_00030
integer x = 411
integer y = 3148
boolean enabled = false
end type

type gb_10 from w_inherite`gb_10 within w_pu01_00030
integer x = 41
integer y = 3096
boolean enabled = false
end type

type gb_button1 from w_inherite`gb_button1 within w_pu01_00030
integer x = 1211
integer y = 3368
boolean enabled = false
end type

type gb_button2 from w_inherite`gb_button2 within w_pu01_00030
integer x = 1755
integer y = 3392
boolean enabled = false
end type

type rr_2 from roundrectangle within w_pu01_00030
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 16
integer width = 2885
integer height = 264
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_4 from datawindow within w_pu01_00030
boolean visible = false
integer x = 142
integer y = 2392
integer width = 763
integer height = 464
integer taborder = 130
boolean bringtotop = true
boolean titlebar = true
string title = "주간생산계획"
string dataobject = "d_pu01_00030_mrp"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_info from statictext within w_pu01_00030
boolean visible = false
integer x = 1445
integer y = 948
integer width = 1792
integer height = 220
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33551600
boolean border = true
boolean focusrectangle = false
end type

type st_info2 from statictext within w_pu01_00030
boolean visible = false
integer x = 2075
integer y = 1032
integer width = 1047
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33551600
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_pu01_00030
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 284
integer width = 4581
integer height = 1564
integer cornerheight = 40
integer cornerwidth = 55
end type

type st_info1 from statictext within w_pu01_00030
boolean visible = false
integer x = 1536
integer y = 1032
integer width = 530
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33551600
string text = "자재 소요량 계산 :"
boolean focusrectangle = false
end type

type dw_6 from datawindow within w_pu01_00030
boolean visible = false
integer x = 2542
integer y = 2364
integer width = 590
integer height = 436
integer taborder = 150
boolean bringtotop = true
boolean titlebar = true
string title = "공급업체"
string dataobject = "d_pu01_00010_c"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_3 from datawindow within w_pu01_00030
integer x = 9
integer y = 1848
integer width = 4567
integer height = 436
integer taborder = 120
string title = "none"
string dataobject = "d_pu01_00030_3_t"
boolean border = false
boolean livescroll = true
end type

type dw_1 from u_key_enter within w_pu01_00030
integer x = 55
integer y = 28
integer width = 2830
integer height = 236
integer taborder = 11
string dataobject = "d_pu01_00030_1"
boolean border = false
end type

event itemchanged;call super::itemchanged;string	scolnm , sdate, scnfirm,s_empno, s_name, get_nm,sitnbr,sitdsc
string snull
Int      ireturn

setnull(snull)

scolnm = Lower(GetColumnName())

Choose Case scolnm
	Case "cvcod"
		s_empno = this.GetText()
		s_name  = this.getitemstring(1,"cvcod")
		
		ireturn = f_get_name2('V1', 'Y', s_empno, get_nm, s_name)
		this.setitem(1, "cvcod", s_empno)	
		this.setitem(1, "cvnas", get_nm)
		
		if isnull(s_name) or s_name = '' then
			this.setitem(1, "cvcod", s_empno)	
			this.setitem(1, "cvnas", get_nm)
		end if
		RETURN ireturn
	Case 'sdate'
		sdate = this.gettext()
		If DayNumber(Date( Left(sdate,4)+'-'+Mid(sdate,5,2) +'-'+Right(sdate,2) )) <> 2 Then
			MessageBox('확 인','주간 구매계획은 월요일부터 가능합니다.!!')
			Return 1
		End If
	/* 품목분류 지정 */
	Case 'itcls'
		string	s_ittyp, s_itcls, s_titnm
		s_ittyp = trim(this.getitemstring(1,'ittyp'))
		if isnull(s_ittyp) or s_ittyp = '' then
			messagebox('확인','품목구분을 지정하세요!!!')
			this.setitem(1,'itcls','')
			this.setitem(1,'titnm','')
			return 1
		end if
		s_itcls = trim(this.gettext())
		if isnull(s_itcls) or s_itcls = '' then
			messagebox('확인','품목분류를 지정하세요!!!')
			this.setitem(1,'itcls','')
			this.setitem(1,'titnm','')
			return 1
		end if
		select titnm into :s_titnm from itnct where ittyp = :s_ittyp and itcls = :s_itcls ;
		if sqlca.sqlcode <> 0 then
			messagebox('확인','품목분류를 확인하세요!!!')
			this.setitem(1,'itcls','')
			this.setitem(1,'titnm','')
			return 1
		end if
		this.setitem(1,'titnm',s_titnm)
	Case "itnbr"
		sItnbr = trim(GetText())
	
		Select itnbr , itdsc 
		  Into :sitnbr, :sitdsc
		  From itemas 
		 where itnbr = :sItnbr ;
		 
		If sqlca.sqlcode = 0 Then
			setitem(1, "itnbr", sitnbr)	
			setitem(1, "itdsc", sitdsc)	
		Else
			setitem(1, "itnbr", snull)	
			setitem(1, "itdsc", snull)	
		End IF	
End Choose

post wf_set_magamyn()
end event

event rbuttondown;call super::rbuttondown;String sNull, sdate

setnull(gs_code)
setnull(gs_gubun)
setnull(gs_codename)
setnull(snull)


IF this.GetColumnName() = "cvcod" THEN
	gs_gubun ='1'
	Open(w_vndmst_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then	return
	this.SetItem(1, "cvcod", gs_Code)
	this.triggerevent(itemchanged!)
End If

IF this.GetColumnName() = "itcls" Then
	 OpenWithParm(w_ittyp_popup, this.getitemstring(1,'ittyp'))
    str_sitnct = Message.PowerObjectParm	
	 IF str_sitnct.s_ittyp ="" OR IsNull(str_sitnct.s_ittyp) THEN RETURN
	
	 this.SetItem(1,"ittyp",str_sitnct.s_ittyp)
	 this.SetItem(1,"itcls",str_sitnct.s_sumgub)
	 this.SetItem(1,"titnm", str_sitnct.s_titnm)
End if

IF this.GetColumnName() =  'itnbr' Then
		gs_code = Trim(this.GetText())
		gs_gubun = '3'
		open(w_itemas_popup)
		if gs_code = "" or isnull(gs_code) then return 
		this.setitem(1, 'itnbr', gs_code)
		this.setitem(1, 'itdsc', gs_codename)
End If
end event

event itemerror;call super::itemerror;return 1
end event

type dw_41 from datawindow within w_pu01_00030
boolean visible = false
integer x = 1006
integer y = 2396
integer width = 1422
integer height = 432
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "상품"
string dataobject = "d_pu01_00030_b"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean border = false
boolean livescroll = true
end type

type dw_insert2 from datawindow within w_pu01_00030
event ue_pressenter pbm_dwnprocessenter
boolean visible = false
integer x = 4864
integer y = 112
integer width = 247
integer height = 120
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_pu01_00030_2_m"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemerror;return 1
end event

event clicked;this.selectrow(0,false)
post wf_set_info(this,row)
end event

event doubleclicked;//if row <= 0 then return
//
//long		lrow
//string	sitnbr, scvcod
//
//sitnbr = this.getitemstring(row,'itnbr')
//scvcod = this.getitemstring(row,'cvcod')
//
//lrow = dw_insert.find("itnbr='"+sitnbr+"' and "+&
//							 "cvcod='"+scvcod+"'",1,dw_insert.rowcount())
//if lrow > 0 then
//	dw_7.setitem(1,'gubun','1')
//	dw_7.triggerevent(itemchanged!)
//	
//	lrow = dw_insert.find("itnbr='"+sitnbr+"' and "+&
//							 "cvcod='"+scvcod+"'",1,dw_insert.rowcount())
//	
//	this.selectrow(0,false)
//	dw_insert.setrow(lrow)
//	dw_insert.selectrow(0,false)
//	dw_insert.selectrow(lrow,true)
//	dw_insert.scrolltorow(lrow)	
//end if
end event

event rowfocuschanged;this.selectrow(0,false)
end event

event itemchanged;if row <= 0 then return

//if this.getcolumnname() = 'cvdbl' then
//	string	sitnbr, sitdsc, scvnas, sok
//	decimal	dunprc
//
//	sitnbr = this.getitemstring(row,'itnbr')
//	sitdsc = this.getitemstring(row,'itemas_itdsc')
//	
//	gs_code = sitnbr
//	gs_codename = sitdsc
//	
//	open(w_cvdouble_popup)
//	sok = message.stringparm
//	if sok = 'OK' then
//		this.rowscopy(row,row,primary!,this,row+1,primary!)
//		
//		select unprc into :dunprc from danmst
//		 where itnbr = sitnbr and cvcod = :gs_code and opseq = '9999' ;
//		
//		if sqlca.sqlcode <> 0 then dunprc = 0
//		
//		this.setitem(row+1,'cvcod',gs_code)
//		this.setitem(row+1,'vndmst_cvnas',gs_codename)
//		this.setitem(row+1,'unprc',gs_codename)
//		this.setitem(row+1,"qty_01",0)
//		this.setitem(row+1,"qty_02",0)
//		this.setitem(row+1,"qty_03",0)
//		this.setitem(row+1,"qty_04",0)
//		this.setitem(row+1,"qty_05",0)
//		
//		this.setitem(row,"cvdbl",'N')
//		this.setitem(row+1,"cvdbl",'N')
//	end if
//end if

this.selectrow(0,false)
post wf_set_info(this,row)
end event

type dw_7 from datawindow within w_pu01_00030
boolean visible = false
integer x = 4974
integer y = 128
integer width = 155
integer height = 148
integer taborder = 100
boolean bringtotop = true
string title = "none"
string dataobject = "d_pu01_00010_1"
boolean border = false
boolean livescroll = true
end type

event itemchanged;//dw_insert.setredraw(false)
//dw_insert2.setredraw(false)
//
//if this.gettext() = '1' then
//	dw_insert.visible = true
//	dw_insert2.visible = false
//	
//	dw_insert.setsort("sabu A, yymmdd A, waigb A, itnbr A, cvcod A")
//	dw_insert.sort()
//	dw_insert.groupcalc()
//else
//	dw_insert.visible = false
//	dw_insert2.visible = true
//	
//	dw_insert2.setsort("sabu A, yymmdd A, waigb A, cvcod A, itnbr A")
//	dw_insert2.sort()
//	dw_insert2.groupcalc()
//end if
//
//dw_insert.setredraw(true)
//dw_insert2.setredraw(true)
end event

type p_1 from picture within w_pu01_00030
boolean visible = false
integer x = 4942
integer y = 756
integer width = 306
integer height = 144
boolean bringtotop = true
string picturename = "C:\erpman\image\이원화처리.gif"
boolean focusrectangle = false
end type

type dw_chart from datawindow within w_pu01_00030
boolean visible = false
integer x = 375
integer y = 2648
integer width = 686
integer height = 400
integer taborder = 160
boolean bringtotop = true
boolean titlebar = true
string title = "월 최대 납품량 & 구매계획 대비 챠트용"
string dataobject = "d_pu01_00020_y"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type pb_1 from u_pb_cal within w_pu01_00030
integer x = 713
integer y = 36
integer taborder = 21
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_1.SetColumn('sdate')
IF IsNull(gs_code) THEN Return 

If DayNumber(Date( Left(gs_code,4)+'-'+Mid(gs_code,5,2) +'-'+Right(gs_code,2) )) <> 2 Then
	MessageBox('확 인','주간 구매계획은 월요일부터 가능합니다.!!')
	Return 1
End If

dw_1.SetItem(1, 'sdate', gs_code)

post wf_set_magamyn()
end event

type dw_hidden from datawindow within w_pu01_00030
boolean visible = false
integer x = 3461
integer y = 2408
integer width = 1957
integer height = 168
integer taborder = 170
boolean bringtotop = true
string dataobject = "d_vnditem_popup2"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type p_2 from picture within w_pu01_00030
event ue_lbuttonup ( )
event ue_lbuttondown pbm_lbuttondown
integer x = 2944
integer y = 36
integer width = 178
integer height = 144
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\erpman\image\엑셀변환_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttonup();This.PictureName = 'C:\erpman\image\엑셀변환_up.gif'
end event

event ue_lbuttondown;This.PictureName = 'C:\erpman\image\엑셀변환_dn.gif'
end event

event clicked;If this.Enabled Then wf_excel_down(dw_insert)
end event

type dw_2 from datawindow within w_pu01_00030
boolean visible = false
integer x = 3406
integer y = 2640
integer width = 293
integer height = 192
integer taborder = 30
boolean bringtotop = true
boolean titlebar = true
string title = "BOM 역전개"
string dataobject = "d_pu01_00030_2_m_list"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
string icon = "Menu5!"
boolean hsplitscroll = true
boolean livescroll = true
end type

event clicked;This.ReSet()
This.Visible = False
end event

event constructor;This.SetTransObject(SQLCA)
end event

type st_2 from statictext within w_pu01_00030
integer x = 2926
integer y = 212
integer width = 1934
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
string text = "* 계획수량을 더블클릭 하시면 BOM 구성을 볼 수 있습니다."
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_pu01_00030
boolean visible = false
integer x = 2510
integer y = 220
integer width = 402
integer height = 84
integer taborder = 110
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "none"
end type

event clicked;Long    ll_cnt, i
String  ls_sabu, ls_yymmdd, ls_waigb, ls_cvcod, ls_plnt, ls_itnbr

ll_cnt = dw_insert.RowCount()

String  ls_find
Long    ll_find

For i = 1 To ll_cnt
	ls_sabu = dw_insert.GetItemString(i, 'sabu')
	ls_yymmdd = dw_insert.GetItemString(i, 'yymmdd')
	ls_waigb = dw_insert.GetItemString(i, 'waigb')
	ls_cvcod = dw_insert.GetItemString(i, 'cvcod')
	ls_plnt = dw_insert.GetItemString(i, 'plnt')
	ls_itnbr = dw_insert.GetItemString(i, 'itnbr')
	
	ls_find = "sabu = '" + ls_sabu + "' and yymmdd = '" + ls_yymmdd + "' and waigb = '" + ls_waigb + "' and cvcod = '" + ls_cvcod + "' and plnt = '" + &
	          ls_plnt + "' and itnbr = '" + ls_itnbr + "'"
	
	If i + 1 > ll_cnt Then Continue
	ll_find = dw_insert.Find(ls_find, i+1, ll_cnt)
	If ll_find > 0 Then
		dw_insert.ScrollToRow(ll_cnt)
		MessageBox('Duplicate!!', String(i) + '행과 ' + String(ll_find) + '행은 빠가났다!!')
		Return
	End If
Next
end event

type rr_4 from roundrectangle within w_pu01_00030
boolean visible = false
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 4914
integer y = 108
integer width = 270
integer height = 184
integer cornerheight = 40
integer cornerwidth = 55
end type

