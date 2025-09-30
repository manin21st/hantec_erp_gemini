$PBExportHeader$w_pu05_00020.srw
$PBExportComments$** 주간 외주계획 수립
forward
global type w_pu05_00020 from w_inherite
end type
type rr_2 from roundrectangle within w_pu05_00020
end type
type dw_4 from datawindow within w_pu05_00020
end type
type st_info from statictext within w_pu05_00020
end type
type st_info2 from statictext within w_pu05_00020
end type
type rr_1 from roundrectangle within w_pu05_00020
end type
type st_info1 from statictext within w_pu05_00020
end type
type dw_6 from datawindow within w_pu05_00020
end type
type dw_3 from datawindow within w_pu05_00020
end type
type dw_1 from u_key_enter within w_pu05_00020
end type
type dw_insert2 from datawindow within w_pu05_00020
end type
type dw_7 from datawindow within w_pu05_00020
end type
type p_1 from picture within w_pu05_00020
end type
type pb_1 from u_pb_cal within w_pu05_00020
end type
type dw_hidden from datawindow within w_pu05_00020
end type
type cb_1 from commandbutton within w_pu05_00020
end type
type cb_2 from commandbutton within w_pu05_00020
end type
type dw_upload from datawindow within w_pu05_00020
end type
type rr_4 from roundrectangle within w_pu05_00020
end type
end forward

global type w_pu05_00020 from w_inherite
integer width = 5655
integer height = 2948
string title = "주간 외주계획"
rr_2 rr_2
dw_4 dw_4
st_info st_info
st_info2 st_info2
rr_1 rr_1
st_info1 st_info1
dw_6 dw_6
dw_3 dw_3
dw_1 dw_1
dw_insert2 dw_insert2
dw_7 dw_7
p_1 p_1
pb_1 pb_1
dw_hidden dw_hidden
cb_1 cb_1
cb_2 cb_2
dw_upload dw_upload
rr_4 rr_4
end type
global w_pu05_00020 w_pu05_00020

type variables
str_itnct str_sitnct
end variables

forward prototypes
public subroutine wf_set_dayqty ()
public subroutine wf_set_balqty ()
public subroutine wf_set_orgqty ()
public subroutine wf_set_info (datawindow arg_dw, long arg_row)
public subroutine wf_calc_shrat ()
public subroutine wf_calc_point ()
public function decimal wf_sum_napqty (datawindow arg_dw, string arg_itnbr)
public subroutine wf_initial ()
public subroutine wf_calc_needqty ()
public subroutine wf_get_plan (string syymmdd)
public subroutine wf_set_magamyn ()
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

public subroutine wf_set_info (datawindow arg_dw, long arg_row);string	sitnbr, scvcod, seono, seodate
decimal	djego, dtotqty, dorgqty, dweekqty

if arg_row <= 0 then return

sitnbr = arg_dw.getitemstring(arg_row,'itnbr')
scvcod = arg_dw.getitemstring(arg_row,'cvcod')
seono = arg_dw.getitemstring(arg_row, 'eo_no')
seodate = arg_dw.getitemstring(arg_row, 'eo_date')

djego   = arg_dw.getitemnumber(arg_row,'jgoqty')
dtotqty = arg_dw.getitemnumber(arg_row,'totqty')
dorgqty = arg_dw.getitemnumber(arg_row,'sum_orgqty')
dweekqty= arg_dw.getitemnumber(arg_row,'sum_week')

if dw_3.retrieve(sitnbr,scvcod) < 1 then return

dw_3.setitem(1,'jegoqty',djego)
dw_3.setitem(1,'totqty',dtotqty)
dw_3.setitem(1,'patqty',dorgqty)
dw_3.setitem(1,'eo_no', seono)
dw_3.setitem(1,'eo_date',seodate) /*EO_NO와 EO_DATE 추가 2023.11.14 by dykim*/
//dw_3.setitem(1,'chgqty',dweekqty)
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

public subroutine wf_calc_point ();long		i, lrow
long		lot, lcnt, lsum, lneed, lrest, lotsum
long		lqty1, lqty2, lqty3, lqty4, lqty5, lqty6, lqty7
string	sd01, sd02, sd03, sd04, sd05, sd06, sd07


FOR lrow = 1 TO dw_insert.rowcount()
	//====================================================================
	lot  = dw_insert.getitemnumber(lrow,'minqt')
	lsum = dw_insert.getitemnumber(lrow,'sum_week')
	lcnt = dw_insert.getitemnumber(lrow,'weekcnt')
	
	sd01 = dw_insert.getitemstring(lrow,'wdate01')
	sd02 = dw_insert.getitemstring(lrow,'wdate02')
	sd03 = dw_insert.getitemstring(lrow,'wdate03')
	sd04 = dw_insert.getitemstring(lrow,'wdate04')
	sd05 = dw_insert.getitemstring(lrow,'wdate05')
	sd06 = dw_insert.getitemstring(lrow,'wdate06')
	sd07 = dw_insert.getitemstring(lrow,'wdate07')

	i = 0
	lrest = 0
	
	if lot > 0 then
		lotsum = ceiling(lsum/lot)*lot
	else
		lot = lsum
		lotsum = lsum
	end if
	
	
	
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
		dw_insert.setitem(lrow,'qty_01',lotsum)
	end if
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

public subroutine wf_initial ();dw_1.ReSet()
dw_3.ReSet()
dw_insert.ReSet()
dw_insert2.ReSet()

dw_1.InsertRow(0)
dw_3.InsertRow(0)

/* 최종계획년월을 셋팅 */
string	smaxdate

select max(yymmdd) into :smaxdate from pu03_weekplan
 where waigb = '2' ;
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

public subroutine wf_calc_needqty ();long		lrow
decimal	djego, dmidsaf, dqtp_01, dqtp_02, dqtp_03, dqtp_04, dqtp_05, dqtp_06, dqtp_07, dneed


// 필요수량 계산
FOR lrow = 1 TO dw_insert.rowcount()
	djego 	= dw_insert.getitemnumber(lrow,'jgoqty')
	dmidsaf	= dw_insert.getitemnumber(lrow,'midsaf')
	dqtp_01	= dw_insert.getitemnumber(lrow,'qtp_01')
	dqtp_02	= dw_insert.getitemnumber(lrow,'qtp_02')
	dqtp_03	= dw_insert.getitemnumber(lrow,'qtp_03')
	dqtp_04	= dw_insert.getitemnumber(lrow,'qtp_04')
	dqtp_05	= dw_insert.getitemnumber(lrow,'qtp_05')
	dqtp_06	= dw_insert.getitemnumber(lrow,'qtp_06')
	dqtp_07	= dw_insert.getitemnumber(lrow,'qtp_07')
	
	/* 현 재고 < 0 일 경우 현 재고 = 0으로 계산 - 안병국과장 by shingoon 2008.12.30 */
	/* 구매 / 외주 계획 동일 */
	If djego < 0 Then djego = 0
	/********************************************************************************/
	
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

public subroutine wf_get_plan (string syymmdd);long		lrow1, lrow2, lrow3, lrow4, lrow5, lfrow, lirow, lvlno, lprlvl
long		lrowcnt1, lrowcnt2, lrowcnt3, lrowcnt4, lrowcnt5 ,i
decimal	dqtypr, dunprc, dpalqty, dmonmax, dporate, dweekcnt
decimal	dm01, dm02, dm03, dm04, dm05, dm06, dm07, dm08, dm09, dm10, dm11, dm12, djego, dcjego, dshrat, dldtim2
decimal  dqty_pre , dqtp_pre, dminsaf, dmidsaf, dmaxsaf
string	srinbr, sitdsc, srtype,  sittyp, sitgu, scvcod ,scvnas, syymm, syymmdd_pre, sjasa
string	smwgbn, swdate01, swdate02, swdate03, swdate04, swdate05, swdate06, swdate07, splnt

syymmdd = trim(dw_1.getitemstring(1,'sdate'))

String  ls_saupj
ls_saupj = '%'
lrowcnt1 = dw_4.retrieve(ls_saupj,syymmdd)
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

Long  ll_qty1, ll_qty2, ll_qty3, ll_qty4, ll_qty5, ll_qty6, ll_qty7
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
/*  LP-MIP 이원화된 품번의 경우 "공장별 납품처등록" 을 기준으로 제외시킴 - 2010.04.29 껀으로*/
/* MRP 전개시 CKD 수량 제외 부분 주석처리 -2010.06.29. by won */
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

/* 자재팀 요청으로 CKD수량 제외 처리 - 2015.08.20 BY SHINGOON ***********************************************************************/
/* 위아포승(WP) 공장은 CKD이지만 CKD에서 제외처리 */
/* ckd수량 원복 요청 - by shingoon 2015.08.25 */
//	SELECT SUM(A.ITM_QTY1), SUM(A.ITM_QTY2), SUM(A.ITM_QTY3), SUM(A.ITM_QTY4), SUM(A.ITM_QTY5), SUM(A.ITM_QTY6), SUM(A.ITM_QTY7)
//	  INTO :ll_qty1       , :ll_qty2       , :ll_qty3       , :ll_qty4       , :ll_qty5       , :ll_qty6       , :ll_qty7
//	  FROM SM03_WEEKPLAN_ITEM A,
//			 ITEMAS B,
//			 ( SELECT RFGUB, DECODE(RFGUB, 'WP', 'HAN', RFCOMMENT) RFCOMMENT FROM REFFPF WHERE SABU = '1' AND RFCOD = '2A' AND RFGUB <> '00' ) C
//	 WHERE A.SAUPJ = :gs_saupj
//		AND A.YYMMDD = :syymmdd
//		AND A.ITNBR  = :srinbr
//		AND B.ITGU <> '5'
//		AND B.GBWAN = 'Y'
//		AND B.GBGUB = '1'
//		AND B.USEYN = '0'
//		AND C.RFCOMMENT = 'CKD'
//		AND A.ITNBR = B.ITNBR
//		AND A.PLNT = C.RFGUB ;
//	
//	If SQLCA.SQLCODE <> 0 Then
		ll_qty1 = 0
		ll_qty2 = 0
		ll_qty3 = 0
		ll_qty4 = 0
		ll_qty5 = 0
		ll_qty6 = 0
		ll_qty7 = 0
//	Else
//		If IsNull(ll_qty1) Then ll_qty1 = 0
//		If IsNull(ll_qty2) Then ll_qty2 = 0
//		If IsNull(ll_qty3) Then ll_qty3 = 0
//		If IsNull(ll_qty4) Then ll_qty4 = 0
//		If IsNull(ll_qty5) Then ll_qty5 = 0
//		If IsNull(ll_qty6) Then ll_qty6 = 0
//		If IsNull(ll_qty7) Then ll_qty7 = 0
//	End If
	
	dm01 = dm01 - ll_qty1
	dm02 = dm02 - ll_qty2
	dm03 = dm03 - ll_qty3
	dm04 = dm04 - ll_qty4
	dm05 = dm05 - ll_qty5
	dm06 = dm06 - ll_qty6
	dm07 = dm07 - ll_qty7
	
	/****************************************************************************************************************************/
	
	// 재고 계산 =======================================================
	/* 현재고 < 0 일 경우 0으로 계산 */
	/* 현재고 집계 시 CKD창고 제외 - BY SHINGOON 2015.08.20 */
//   select nvl(sum(case when a.jego_qty < 0 then 0 else a.jego_qty end), 0) into :djego from stock a      //재고
//	 where a.itnbr = :srinbr
//		and exists ( select 'x' from vndmst
//						  where cvcod = a.depot_no	and soguan < '4' and jumaechul < '3' ) ;
	SELECT NVL(SUM(CASE WHEN A.JEGO_QTY < 0 THEN 0 ELSE A.JEGO_QTY END), 0) INTO :djego FROM STOCK A
	 WHERE A.ITNBR = :SRINBR
  		AND EXISTS ( SELECT 'X' FROM VNDMST
		   			  WHERE CVCOD = A.DEPOT_NO	AND SOGUAN < '4' AND JUMAECHUL < '3' AND NVL(JUHANDLE, '1') <> '2' ) ;
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
//			
//	djego = djego - dqtp_pre + dqty_pre              
			
	select itdsc, shrat, ldtim2, nvl(minqt,0), nvl(minsaf,0), nvl(midsaf,0), nvl(maxsaf,0), nvl(pdtgu, '2')
	  into :sitdsc, :dshrat, :dldtim2, :dpalqty, :dminsaf, :dmidsaf, :dmaxsaf, :ls_saupj
	  from itemas
	 where itnbr = :srinbr ;
			 
	if sqlca.sqlcode <> 0 then 
		dshrat = 0
		dldtim2= 0
		dminsaf= 0
		dmidsaf= 0
		dmaxsaf= 0
	end if
	//==============================================================================
	
	lrowcnt4 = dw_6.retrieve(srinbr,syymmdd)
	if lrowcnt4 < 1 then
		scvcod  = sjasa
	//	dpalqty = dw_6.getitemnumber(1,'palqty')        // 용기 적입량 --> 사용안함 
	//	dmonmax = dw_6.getitemnumber(1,'monmax')        // 월최대 발주량 
	//	dporate = dw_6.getitemnumber(1,'porate')        // 업체 발주비율 
		dporate = 1.0
		dunprc  = 0
		dweekcnt= 1
		
		smwgbn  = '1'
		swdate01= 'Y'
		swdate02= 'N'
		swdate03= 'N'
		swdate04= 'N'
		swdate05= 'N'
		swdate06= 'N'
		swdate07= 'N'
	else
		scvcod  = dw_6.getitemstring(1,'cvcod')
	//	dpalqty = dw_6.getitemnumber(1,'palqty')        // 용기 적입량 --> 사용안함 
//		dmonmax = dw_6.getitemnumber(1,'monmax')        // 월최대 발주량 
	//	dporate = dw_6.getitemnumber(1,'porate')        // 업체 발주비율 
		dporate = 1.0
		dunprc  = dw_6.getitemnumber(1,'unprc')         // 단가 
		dweekcnt= dw_6.getitemnumber(1,'weekcnt')       // 주간 납입횟수
		
		smwgbn  = dw_6.getitemstring(1,'mwgbn')
		swdate01= dw_6.getitemstring(1,'wdate01')
		swdate02= dw_6.getitemstring(1,'wdate02')
		swdate03= dw_6.getitemstring(1,'wdate03')
		swdate04= dw_6.getitemstring(1,'wdate04')
		swdate05= dw_6.getitemstring(1,'wdate05')
		swdate06= dw_6.getitemstring(1,'wdate06')
		swdate07= dw_6.getitemstring(1,'wdate07')
	end if

				
	lirow = dw_insert.insertrow(0)
		
	/* 품목마스터의 생산팀으로 사업장 정보 가져오기 */
	SELECT RFNA2 INTO :ls_saupj FROM REFFPF WHERE SABU = :gs_sabu AND RFCOD = '03' AND RFGUB = :ls_saupj ;
			
	dw_insert.setitem(lirow,"sabu",ls_saupj)
	dw_insert.setitem(lirow,"yymmdd",syymmdd)
	dw_insert.setitem(lirow,"waigb",'2')
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
	
//	dw_insert.setitem(lirow,"monmax",dmonmax)
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
	
	// 생산계획을 그대로 가져온다.
	dw_insert.setitem(lirow,"qty_01",dm01)
	dw_insert.setitem(lirow,"qty_02",dm02)
	dw_insert.setitem(lirow,"qty_03",dm03)
	dw_insert.setitem(lirow,"qty_04",dm04)
	dw_insert.setitem(lirow,"qty_05",dm05)
	dw_insert.setitem(lirow,"qty_06",dm06)
	dw_insert.setitem(lirow,"qty_07",dm07)
	
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


st_info.visible = false
st_info1.visible = false
st_info2.visible = false
end subroutine

public subroutine wf_set_magamyn ();string	syymm  ,sjucha ,syymmdd ,syymmdd_pre, stemp, sSaupj
Long     ll_jucha , ll_confirm

syymmdd = trim(dw_1.getitemstring(1,'sdate'))
sSaupj = dw_1.getitemstring(1, 'saupj')
/* 사업장 바뀔시에 해당 사업장 기준으로 설정되도록 수정 2023.11.20 by dykim  */
if isNull(sSaupj) or sSaupj = '' then
	sSaupj = gs_saupj
end if

select yymmdd into :stemp from PU03_WEEKPLAN
 where sabu = :sSaupj and yymmdd = :syymmdd and waigb = '2' and cnftime is not null and rownum = 1 ;
if sqlca.sqlcode = 0 then
	dw_1.setitem(1,'cnfirm','Y')
else
	dw_1.setitem(1,'cnfirm','N')
end if
end subroutine

on w_pu05_00020.create
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
this.dw_insert2=create dw_insert2
this.dw_7=create dw_7
this.p_1=create p_1
this.pb_1=create pb_1
this.dw_hidden=create dw_hidden
this.cb_1=create cb_1
this.cb_2=create cb_2
this.dw_upload=create dw_upload
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
this.Control[iCurrent+10]=this.dw_insert2
this.Control[iCurrent+11]=this.dw_7
this.Control[iCurrent+12]=this.p_1
this.Control[iCurrent+13]=this.pb_1
this.Control[iCurrent+14]=this.dw_hidden
this.Control[iCurrent+15]=this.cb_1
this.Control[iCurrent+16]=this.cb_2
this.Control[iCurrent+17]=this.dw_upload
this.Control[iCurrent+18]=this.rr_4
end on

on w_pu05_00020.destroy
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
destroy(this.dw_insert2)
destroy(this.dw_7)
destroy(this.p_1)
destroy(this.pb_1)
destroy(this.dw_hidden)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.dw_upload)
destroy(this.rr_4)
end on

event open;call super::open;dw_1.SetTransObject(sqlca)
dw_3.SetTransObject(sqlca)
dw_insert.SetTransObject(sqlca)
dw_insert2.SetTransObject(sqlca)
dw_4.SetTransObject(sqlca)
dw_6.SetTransObject(sqlca)

dw_upload.SetTransObject(sqlca)

wf_initial()
end event

type dw_insert from w_inherite`dw_insert within w_pu05_00020
integer x = 27
integer y = 324
integer width = 4558
integer height = 1532
string dataobject = "d_pu05_00020_m"
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
end event

event dw_insert::doubleclicked;call super::doubleclicked;if row <= 0 then return

long		lrow
string	sitnbr, scvcod

sitnbr = this.getitemstring(row,'itnbr')
scvcod = this.getitemstring(row,'cvcod')

lrow = dw_insert2.find("itnbr='"+sitnbr+"' and "+&
							 "cvcod='"+scvcod+"'",1,dw_insert2.rowcount())
if lrow > 0 then
	dw_7.setitem(1,'gubun','2')
	dw_7.triggerevent(itemchanged!)
	
	lrow = dw_insert2.find("itnbr='"+sitnbr+"' and "+&
							 "cvcod='"+scvcod+"'",1,dw_insert2.rowcount())
	
	this.selectrow(0,false)
	dw_insert2.setrow(lrow)
	dw_insert2.selectrow(0,false)
	dw_insert2.selectrow(lrow,true)
	dw_insert2.scrolltorow(lrow)	
end if
end event

event dw_insert::clicked;call super::clicked;this.setrow(row)
this.trigger event rowfocuschanged(row)
end event

event dw_insert::itemchanged;if row <= 0 then return

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
		
		select unprc into :dunprc from danmst
		 where itnbr = sitnbr and cvcod = :gs_code 
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

type p_delrow from w_inherite`p_delrow within w_pu05_00020
integer x = 3465
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

If dw_insert.UPDATE() = 1 Then
	COMMIT USING SQLCA;
Else
	ROLLBACK USING SQLCA;
	MessageBox('삭제오류', '자료 삭제 중 오류가 발생 했습니다.')
	Return
End If

ib_any_typing = False
end event

type p_addrow from w_inherite`p_addrow within w_pu05_00020
integer x = 3291
integer y = 36
end type

event p_addrow::clicked;String 	syymmdd, scvcod, scvnas, sitnbr, sitdsc, smagam, spdtgu, smorpm, sopt
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
			dw_insert.setitem(lins,"waigb",'2')
			
			/* 추가품목의 단가는 거래처별 단가 지정. - BY SHINGOON 2007.09.28
			select cvnas, fun_danmst_danga10(:syymmdd||'01',cvcod,:sitnbr,'.')
			  into :scvnas, :dunprc
			  from vndmst
			 where cvcod = :scvcod ; */
			//fun_danmst_danga6(품번, 거래처, 공정코드, 일자, 구매/외주구분('1'구매, '2'외주))
			SELECT CVNAS, FUN_DANMST_DANGA6(:sitnbr, CVCOD, '9999', :syymmdd||'01', '2')
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

type p_search from w_inherite`p_search within w_pu05_00020
string tag = "MRP"
integer x = 3666
integer y = 36
boolean originalsize = true
string picturename = "C:\erpman\image\MRP_up.gif"
end type

event p_search::clicked;string	syymm  ,sjucha ,syymmdd ,syymmdd_pre, stemp, smagam
Long     ll_jucha , ll_confirm

if dw_1.accepttext() = -1 then return

smagam = dw_1.getitemstring(1,'cnfirm')
if smagam = 'Y' then
	messagebox("확인","확정처리된 자료입니다.")
	return
end if

syymmdd = trim(dw_1.getitemstring(1,'sdate'))

If syymmdd = '' or isNull(syymmdd) or f_datechk(syymmdd) < 0 Then
	f_message_chk(35,'[계획일자')
	Return
End if

If DayNumber(Date( Left(syymmdd,4)+'-'+Mid(syymmdd,5,2) +'-'+Right(syymmdd,2) )) <> 2 Then
	MessageBox('확 인','주간 외주계획은 월요일부터 가능합니다.!!')
	dw_1.setcolumn('sdate')
	dw_1.setfocus()
	Return
End If

select yymmdd into :stemp from PU03_WEEKPLAN_SUM
 where yymmdd = :syymmdd and waigb = '2' and rownum = 1 ;
/* where sabu = :gs_saupj and yymmdd = :syymmdd and waigb = '2' and rownum = 1 ;  전체사업장으로 확인 */

if sqlca.sqlcode <> 0 then
	messagebox('확인',syymmdd + '주간 생산계획이 없습니다')
	return
end if

/* 전체사업장으로 확인
select yymmdd into :syymmdd 
  from pu03_weekplan
 where sabu = :gs_saupj 
   and yymmdd = :syymmdd 
	and waigb = '2'
	and rownum = 1 ; */


select yymmdd into :syymmdd 
  from pu03_weekplan
 where yymmdd = :syymmdd 
	and waigb = '2'
	and rownum = 1 ;

if sqlca.sqlcode = 0 then
	if messagebox("자재소요량 전개","계획일자 "+syymmdd+" 의 주간 외주계획이 존재합니다."+&
								"~n새로 자재소요량을 전개하시겠습니까?" ,exclamation!,oKcancel!,2) = 2 then
		return
	
	end if
else
	if messagebox("자재소요량 전개","자재소요량을 전개하시겠습니까?" ,exclamation!,oKcancel!,2) = 2 then
		return
	
	end if
end if

// 기존에 있던 계획은 삭제한다. =================================================
/* 전체사업장으로 확인
Delete From pu03_weekplan
		Where sabu = :gs_saupj 
		  and yymmdd = :syymmdd 
		  and waigb = '2' ; */
Delete From pu03_weekplan
		Where yymmdd = :syymmdd 
		  and waigb = '2' ;		  
If sqlca.sqlcode <> 0 Then
	Rollback;
	dw_insert.Reset()
	MessageBox('ERROR','MRP 작성 중 에러가 발생했습니다. DB 에러 ')
	Return
Else
	COMMIT;
End If
//===========================================================================


///////////////////////////////////////////////////////////////////////////////////////////
dw_insert.setredraw(false)
wf_get_plan(syymmdd)	// 1.주간생산계획 READ

wf_calc_needqty() // 2.현재고, 안전재고 적용 - by shingoon 2008.12.22

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

type p_ins from w_inherite`p_ins within w_pu05_00020
string tag = "조정"
boolean visible = false
integer x = 4827
integer y = 356
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

ls_window_id = 'w_pu05_00020'
ls_window_nm = '주간 외주계획'

If ls_window_id = '' or isNull(ls_window_id) Then
	messagebox('','프로그램명이 없습니다.')
	return
End If

gs_code = '주간 외주계획'
gs_codename = String(sYymm,'@@@@년 @@월 ') + string(ll_jucha) + '주차 외주계획을 수립했습니다.'
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

type p_exit from w_inherite`p_exit within w_pu05_00020
integer x = 4361
integer y = 36
end type

type p_can from w_inherite`p_can within w_pu05_00020
integer x = 4187
integer y = 36
end type

event p_can::clicked;call super::clicked;rollback ;

wf_initial()
end event

type p_print from w_inherite`p_print within w_pu05_00020
boolean visible = false
integer x = 5047
integer y = 536
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_pu05_00020
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
	MessageBox('확 인','주간 외주계획은 월요일부터 가능합니다.!!')
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
ls_saupj = Trim(dw_1.GetItemString(1, 'saupj'))
If ls_saupj = '' OR IsNull(ls_saupj) Then ls_saupj = '%'

/* 사업장의 생산팀으로 변경 */
SELECT RFGUB INTO :sgubun FROM REFFPF WHERE SABU = :gs_sabu AND RFCOD = '03' AND RFNA2 = :ls_saupj ;

//SELECT COUNT(*) Into :ll_cnt
//  FROM PU03_WEEKPLAN
// WHERE SABU = :gs_saupj
//   AND YYMMDD = :syymmdd
//	AND WAIGB = '2' ;
//
//If SQLCA.SQLCODE <> 0 or ll_cnt < 1 Then
//	dw_insert.SetRedraw(false)
//	dw_insert.Reset()
//	dw_insert.SetRedraw(True)
//	f_message_chk(50,'주간 외주계획')
//	Return
//End If

setpointer(hourglass!)
/*
If dw_insert.Retrieve(gs_saupj,syymmdd,sgubun, sItcls+'%', scvcod+'%', sittyp+'%',sitnbr) <= 0 Then
	f_message_chk(50,'주간 외주계획')
End If */
If dw_insert.Retrieve(ls_saupj,syymmdd,sgubun, sItcls+'%', scvcod+'%', sittyp+'%',sitnbr) <= 0 Then
	f_message_chk(50,'주간 외주계획')
End If

dw_7.setitem(1,'gubun','2')
dw_7.postevent(itemchanged!)
end event

type p_del from w_inherite`p_del within w_pu05_00020
boolean visible = false
integer x = 4864
integer y = 536
end type

type p_mod from w_inherite`p_mod within w_pu05_00020
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
	messagebox("확인","확정처리된 자료입니다.")
	return
end if

if messagebox('확인',' 주간 외주계획을 저장합니다.',question!,yesno!,1) = 2 then Return 

dw_insert.setredraw(false)
FOR lrow = dw_insert.rowcount() TO 1 STEP -1
	dw_insert.setitem(lrow,"amt_01",dw_insert.getitemnumber(lrow,"qty_01")*dw_insert.getitemnumber(lrow,"unprc"))
	dw_insert.setitem(lrow,"amt_02",dw_insert.getitemnumber(lrow,"qty_02")*dw_insert.getitemnumber(lrow,"unprc"))
	dw_insert.setitem(lrow,"amt_03",dw_insert.getitemnumber(lrow,"qty_03")*dw_insert.getitemnumber(lrow,"unprc"))
	dw_insert.setitem(lrow,"amt_04",dw_insert.getitemnumber(lrow,"qty_04")*dw_insert.getitemnumber(lrow,"unprc"))
	dw_insert.setitem(lrow,"amt_05",dw_insert.getitemnumber(lrow,"qty_05")*dw_insert.getitemnumber(lrow,"unprc"))
	dw_insert.setitem(lrow,"amt_06",dw_insert.getitemnumber(lrow,"qty_06")*dw_insert.getitemnumber(lrow,"unprc"))
	dw_insert.setitem(lrow,"amt_07",dw_insert.getitemnumber(lrow,"qty_07")*dw_insert.getitemnumber(lrow,"unprc"))

//	if dw_insert.getitemnumber(lrow,'sum_week') > 0 then continue
//	dw_insert.deleterow(lrow)
NEXT
dw_insert.setredraw(true)
	
setpointer(hourglass!)
dw_insert.AcceptText()

If dw_insert.Update() <> 1 Then
	RollBack;
	Return
End If

COMMIT;

messagebox('확인','주간 외주계획을 저장하였습니다.')
end event

type cb_exit from w_inherite`cb_exit within w_pu05_00020
integer x = 3022
integer y = 2936
boolean enabled = false
end type

type cb_mod from w_inherite`cb_mod within w_pu05_00020
integer x = 709
integer y = 2936
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within w_pu05_00020
integer x = 347
integer y = 2936
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_pu05_00020
integer x = 1070
integer y = 2936
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_pu05_00020
integer x = 1431
integer y = 2936
boolean enabled = false
end type

type cb_print from w_inherite`cb_print within w_pu05_00020
integer x = 1792
integer y = 2936
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_pu05_00020
integer x = 59
integer y = 3148
end type

type cb_can from w_inherite`cb_can within w_pu05_00020
integer x = 2117
integer y = 2896
boolean enabled = false
end type

type cb_search from w_inherite`cb_search within w_pu05_00020
integer x = 2514
integer y = 2936
boolean enabled = false
end type

type dw_datetime from w_inherite`dw_datetime within w_pu05_00020
integer x = 2903
integer y = 3148
boolean enabled = false
end type

type sle_msg from w_inherite`sle_msg within w_pu05_00020
integer x = 411
integer y = 3148
boolean enabled = false
end type

type gb_10 from w_inherite`gb_10 within w_pu05_00020
integer x = 41
integer y = 3096
boolean enabled = false
end type

type gb_button1 from w_inherite`gb_button1 within w_pu05_00020
integer x = 1211
integer y = 3368
boolean enabled = false
end type

type gb_button2 from w_inherite`gb_button2 within w_pu05_00020
integer x = 1755
integer y = 3392
boolean enabled = false
end type

type rr_2 from roundrectangle within w_pu05_00020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 24
integer width = 2939
integer height = 276
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_4 from datawindow within w_pu05_00020
boolean visible = false
integer x = 142
integer y = 2392
integer width = 763
integer height = 464
integer taborder = 130
boolean bringtotop = true
boolean titlebar = true
string title = "주간생산계획"
string dataobject = "d_pu05_00020_mrp"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_info from statictext within w_pu05_00020
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

type st_info2 from statictext within w_pu05_00020
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

type rr_1 from roundrectangle within w_pu05_00020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 316
integer width = 4581
integer height = 1552
integer cornerheight = 40
integer cornerwidth = 55
end type

type st_info1 from statictext within w_pu05_00020
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

type dw_6 from datawindow within w_pu05_00020
boolean visible = false
integer x = 2533
integer y = 2412
integer width = 768
integer height = 392
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

type dw_3 from datawindow within w_pu05_00020
integer x = 9
integer y = 1872
integer width = 4590
integer height = 420
integer taborder = 120
string title = "none"
string dataobject = "d_pu05_00020_3"
boolean border = false
boolean livescroll = true
end type

type dw_1 from u_key_enter within w_pu05_00020
integer x = 64
integer y = 32
integer width = 2834
integer height = 256
integer taborder = 11
string dataobject = "d_pu05_00020_1"
boolean border = false
end type

event itemchanged;call super::itemchanged;string	scolnm , sdate, scnfirm,s_empno, s_name, get_nm,sitnbr,sitdsc
Int      ireturn
string snull

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
			MessageBox('확 인','주간 외주계획은 월요일부터 가능합니다.!!')
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

event itemerror;call super::itemerror;return 1
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
End If

IF this.GetColumnName() =  'itnbr' Then
		gs_code = Trim(this.GetText())
		gs_gubun = '1'
		open(w_itemas_popup)
		if gs_code = "" or isnull(gs_code) then return 
		this.setitem(1, 'itnbr', gs_code)
		this.setitem(1, 'itdsc', gs_codename)
End If
end event

type dw_insert2 from datawindow within w_pu05_00020
event ue_pressenter pbm_dwnprocessenter
boolean visible = false
integer x = 4727
integer y = 160
integer width = 306
integer height = 164
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_pu05_00020_m"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event type long ue_pressenter();Send(Handle(this),256,9,0)
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

event itemchanged;this.selectrow(0,false)
post wf_set_info(this,row)
end event

type dw_7 from datawindow within w_pu05_00020
boolean visible = false
integer x = 4763
integer y = 864
integer width = 247
integer height = 148
integer taborder = 100
boolean bringtotop = true
string title = "none"
string dataobject = "d_pu05_00020_2"
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

type p_1 from picture within w_pu05_00020
boolean visible = false
integer x = 4942
integer y = 756
integer width = 306
integer height = 144
boolean bringtotop = true
string picturename = "C:\erpman\image\이원화처리.gif"
boolean focusrectangle = false
end type

type pb_1 from u_pb_cal within w_pu05_00020
integer x = 704
integer y = 36
integer taborder = 41
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_1.SetColumn('sdate')
IF IsNull(gs_code) THEN Return 

If DayNumber(Date( Left(gs_code,4)+'-'+Mid(gs_code,5,2) +'-'+Right(gs_code,2) )) <> 2 Then
	MessageBox('확 인','주간 외주계획은 월요일부터 가능합니다.!!')
	Return 1
End If

dw_1.SetItem(1, 'sdate', gs_code)

post wf_set_magamyn()
end event

type dw_hidden from datawindow within w_pu05_00020
boolean visible = false
integer x = 2062
integer y = 2428
integer width = 1957
integer height = 168
integer taborder = 180
boolean bringtotop = true
string dataobject = "d_vnditem_popup2"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_pu05_00020
boolean visible = false
integer x = 2834
integer y = 16
integer width = 402
integer height = 84
integer taborder = 10
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "다운로드"
end type

event clicked;dw_insert.SaveAs("", TEXT!, TRUE)
end event

type cb_2 from commandbutton within w_pu05_00020
boolean visible = false
integer x = 2834
integer y = 112
integer width = 402
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "업로드"
end type

event clicked;long		lcnt, lrow
string 	sname, syymmdd, smagam, sdate, sitnbr, scvcod, swaigb

if dw_1.accepttext() = -1 then return

smagam = dw_1.getitemstring(1,'cnfirm')
if smagam = 'Y' then
	messagebox("확인","확정처리된 자료입니다.")
	return
end if

syymmdd = trim(dw_1.getitemstring(1,'sdate'))
If syymmdd = '' or isNull(syymmdd) or f_datechk(syymmdd) < 0 Then
	f_message_chk(35,'[계획일자')
	Return
End if

if messagebox('확인', '다운로드한 텍스트 파일을 업로드합니다.' + &
		'~n이때, 기존계획에 동일 업체,품번의 정보가 있으면 삭제하고 등록합니다.', Exclamation!, YesNo!, 2) = 2 then return


dw_insert.reset()
dw_upload.reset()

setnull(sname)
lcnt = dw_upload.ImportFile(sname)
if lcnt >= 0 then

	FOR lrow = lcnt TO 1 STEP -1
		swaigb = dw_upload.GetItemString(lrow, 'waigb')
		if swaigb <> '2' then 
			dw_upload.DeleteRow(lrow)
			continue
		end if
		sdate  = dw_upload.GetItemString(lrow, 'yymmdd')
		if syymmdd <> sdate then
			dw_upload.DeleteRow(lrow)
			continue
		end if
		
		scvcod = dw_upload.GetItemString(lrow, 'cvcod')
		sitnbr = dw_upload.GetItemString(lrow, 'itnbr')		
		
		// 기존에 있던 계획은 삭제한다. =================================================
		Delete From pu03_weekplan
				Where sabu = :gs_saupj 
				  and yymmdd = :syymmdd 
				  and waigb = '2' 
				  and cvcod = :scvcod
				  and itnbr = :sitnbr ;
				  
		If sqlca.sqlcode <> 0 Then
			Rollback;
			dw_insert.Reset()
			MessageBox('ERROR','UPLOAD 작성 중 에러가 발생했습니다. DB 에러 ')
			Return
		End If
		//===========================================================================

	NEXT
	
	setpointer(hourglass!)
	dw_upload.AcceptText()
	
	If dw_upload.Update() <> 1 Then
		RollBack;
		Return
	End If
	
	COMMIT;
	
	messagebox('확인','UPLOAD를 완료하였습니다.')	
	
else
	messagebox('ERROR','CODE : '+string(lrow))
	return
end if
end event

type dw_upload from datawindow within w_pu05_00020
boolean visible = false
integer x = 4544
integer y = 1304
integer width = 686
integer height = 400
integer taborder = 110
boolean bringtotop = true
string title = "none"
string dataobject = "d_pu05_00020_m"
boolean border = false
boolean livescroll = true
end type

type rr_4 from roundrectangle within w_pu05_00020
boolean visible = false
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 4677
integer y = 844
integer width = 379
integer height = 184
integer cornerheight = 40
integer cornerwidth = 55
end type

