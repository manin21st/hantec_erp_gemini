$PBExportHeader$w_pu01_00020.srw
$PBExportComments$** 월 구매계획
forward
global type w_pu01_00020 from w_inherite
end type
type rr_1 from roundrectangle within w_pu01_00020
end type
type rr_2 from roundrectangle within w_pu01_00020
end type
type dw_4 from datawindow within w_pu01_00020
end type
type st_info from statictext within w_pu01_00020
end type
type st_info2 from statictext within w_pu01_00020
end type
type st_info1 from statictext within w_pu01_00020
end type
type dw_6 from datawindow within w_pu01_00020
end type
type dw_3 from datawindow within w_pu01_00020
end type
type dw_1 from u_key_enter within w_pu01_00020
end type
type dw_41 from datawindow within w_pu01_00020
end type
type dw_7 from datawindow within w_pu01_00020
end type
type p_1 from picture within w_pu01_00020
end type
type dw_plan from datawindow within w_pu01_00020
end type
type rr_3 from roundrectangle within w_pu01_00020
end type
type rr_4 from roundrectangle within w_pu01_00020
end type
type dw_insert2 from datawindow within w_pu01_00020
end type
type cbx_jego from checkbox within w_pu01_00020
end type
type dw_pdt from datawindow within w_pu01_00020
end type
type cb_1 from commandbutton within w_pu01_00020
end type
type pb_1 from u_pb_cal within w_pu01_00020
end type
type p_xls from picture within w_pu01_00020
end type
end forward

global type w_pu01_00020 from w_inherite
integer width = 4649
integer height = 3432
string title = "월 구매계획"
rr_1 rr_1
rr_2 rr_2
dw_4 dw_4
st_info st_info
st_info2 st_info2
st_info1 st_info1
dw_6 dw_6
dw_3 dw_3
dw_1 dw_1
dw_41 dw_41
dw_7 dw_7
p_1 p_1
dw_plan dw_plan
rr_3 rr_3
rr_4 rr_4
dw_insert2 dw_insert2
cbx_jego cbx_jego
dw_pdt dw_pdt
cb_1 cb_1
pb_1 pb_1
p_xls p_xls
end type
global w_pu01_00020 w_pu01_00020

type variables
str_itnct str_sitnct
end variables

forward prototypes
public function decimal wf_sum_napqty (datawindow arg_dw, string arg_itnbr)
public subroutine wf_calc_shrat ()
public function integer wf_cvdouble_ ()
public subroutine wf_set_balqty ()
public subroutine wf_set_info (datawindow arg_dw, long arg_row)
public subroutine wf_set_weekqty ()
public subroutine wf_set_orgqty ()
public subroutine wf_initial ()
public subroutine wf_calc_point (string arg_seqno)
public subroutine wf_calc_point2 (string arg_seqno)
public subroutine wf_calc_needqty (string arg_seqno)
public subroutine wf_get_plan2 ()
public function integer wf_calc_sagub ()
public function integer wf_calc_mnapqty (string arg_fdate, string arg_tdate, string arg_itnbr)
public subroutine wf_set_porate ()
public subroutine wf_set_qtp_org ()
public subroutine wf_get_plan ()
public subroutine wf_excel_down (datawindow adw_excel)
end prototypes

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

public subroutine wf_calc_shrat ();long		lrow
decimal	dshrat, dqty_01, dqty_02, dqty_03, dqty_04, dqty_05, dneed


// 소재불량율 적용
FOR lrow = 1 TO dw_insert.rowcount()
	dshrat = dw_insert.getitemnumber(lrow,'shrat')
	if isnull(dshrat) then dshrat = 0
	dqty_01 = dw_insert.getitemnumber(lrow,'qty_01')
	dqty_02 = dw_insert.getitemnumber(lrow,'qty_02')
	dqty_03 = dw_insert.getitemnumber(lrow,'qty_03')
	dqty_04 = dw_insert.getitemnumber(lrow,'qty_04')
	dqty_05 = dw_insert.getitemnumber(lrow,'qty_05')
	
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
NEXT
end subroutine

public function integer wf_cvdouble_ ();return 1
end function

public subroutine wf_set_balqty ();long		lrow, i, imoncnt
decimal	djanqty, dweekqty, dtempqty, dforjego
string	sitnbr

dw_insert.accepttext()


////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 업체별 발주비율 적용
FOR lrow = 1 TO dw_insert.rowcount()
	i = 0
	sitnbr  = dw_insert.getitemstring(lrow,'itnbr')
	imoncnt = dw_insert.getitemnumber(lrow,"moncnt")
	dweekqty= dw_insert.getitemnumber(lrow,"weekqty")
	djanqty = dw_insert.getitemnumber(lrow,"janqty")
	
	dforjego = djanqty + wf_sum_napqty(dw_insert,sitnbr)
	dtempqty = 0
	if dforjego < 0 and i <= imoncnt then
		i++
		dw_insert.setitem(lrow,"qty_01",dweekqty)
		dtempqty = dweekqty
	end if
	
	dforjego = dforjego + dtempqty
	dtempqty = 0
	if dforjego < 0 and i <= imoncnt then 
		i++
		dw_insert.setitem(lrow,"qty_02",dweekqty)
		dtempqty = dweekqty
	end if
	
	dforjego = dforjego + dtempqty
	dtempqty = 0
	if dforjego < 0 and i <= imoncnt then 
		i++
		dw_insert.setitem(lrow,"qty_03",dweekqty)
		dtempqty = dweekqty
	end if

	dforjego = dforjego + dtempqty
	dtempqty = 0
	if dforjego < 0 and i <= imoncnt then 
		i++
		dw_insert.setitem(lrow,"qty_04",dweekqty)
		dtempqty = dweekqty
	end if

	dforjego = dforjego + dtempqty
	dtempqty = 0
	if dforjego < 0 and i <= imoncnt then 
		dw_insert.setitem(lrow,"qty_05",dweekqty)
	end if
	
	dw_insert.setitem(lrow,"sum_orgqty",dw_insert.getitemnumber(lrow,'sum_week'))
NEXT
end subroutine

public subroutine wf_set_info (datawindow arg_dw, long arg_row);string	sitnbr, scvcod, syymm
decimal	djego, dtotqty, dorgqty, dweekqty, dmonmax

if arg_row <= 0 then return

sitnbr = arg_dw.getitemstring(arg_row,'itnbr')
scvcod = arg_dw.getitemstring(arg_row,'cvcod')

djego   = arg_dw.getitemnumber(arg_row,'jgoqty')
dtotqty = arg_dw.getitemnumber(arg_row,'totqty')
dorgqty = arg_dw.getitemnumber(arg_row,'sum_orgqty')
dweekqty= arg_dw.getitemnumber(arg_row,'sum_week')
dmonmax = arg_dw.getitemnumber(arg_row,'monmax')

syymm = dw_1.getitemstring(1, 'yymm')

if dw_3.retrieve(sitnbr,scvcod) < 1 then return

If dw_pdt.Retrieve(gs_sabu, syymm, sitnbr) > 0 Then
	dw_3.setitem(1,'qtypr', dw_pdt.GetItemNumber(1, 'qtypr'))
End If

dw_3.setitem(1,'jegoqty',djego)
dw_3.setitem(1,'totqty',dtotqty)
dw_3.setitem(1,'patqty',dorgqty)
dw_3.setitem(1,'chgqty',dweekqty)
dw_3.setitem(1,'monmax',dmonmax)
end subroutine

public subroutine wf_set_weekqty ();long		lrow
string	sitnbr, scvcod
decimal	dtotqty, djgoqty, dnetqty, drate, dvndqty, dmoncnt, dweekqty, dshrat, dminqt

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
	
	dmoncnt = dw_insert.getitemnumber(lrow,"moncnt")	// 업체 납입횟수
	dshrat  = dw_insert.getitemnumber(lrow,"shrat")		// 소재불량율
	dminqt  = dw_insert.getitemnumber(lrow,"minqt")		// 최소발주량(용기)
	if isnull(dminqt) or dminqt <= 0 then dminqt = 1
	
	if isnull(dmoncnt) or dmoncnt <= 0 then
		dweekqty = ceiling(dvndqty/dminqt)*dminqt
	else
		dweekqty = ceiling((dvndqty/dmoncnt)/dminqt)*dminqt
	end if
	
	dw_insert.setitem(lrow,"netqty",dnetqty)
	dw_insert.setitem(lrow,"vndqty",dvndqty)
	dw_insert.setitem(lrow,"weekqty",dweekqty)
NEXT
end subroutine

public subroutine wf_set_orgqty ();long		lrow


FOR lrow = 1 TO dw_insert.rowcount()
	dw_insert.setitem(lrow,'sum_orgqty',dw_insert.getitemnumber(lrow,'sum_week'))
NEXT
end subroutine

public subroutine wf_initial ();dw_1.ReSet()
dw_3.ReSet()
dw_plan.ReSet()
dw_insert.ReSet()
dw_4.ReSet()
dw_41.ReSet()
dw_6.ReSet()

dw_1.InsertRow(0)
dw_3.InsertRow(0)

string	smaxyymm

select max(yymm) into :smaxyymm from pu02_monplan
 where waigb = '1' ;
if isnull(smaxyymm) or smaxyymm = '' then
	dw_1.Object.yymm[1] = Left(f_today(),6)
else	
	dw_1.Object.yymm[1] = smaxyymm
end if
dw_1.postevent(itemchanged!)

dw_1.setfocus()
end subroutine

public subroutine wf_calc_point (string arg_seqno);long	lrow
long	lot, lcnt, lsum, lneed, lrest, lotsum
long	lqty1, lqty2, lqty3, lqty4, lqty5

// 용기량이 지정된 자료만 처리

FOR lrow = 1 TO dw_insert.rowcount()
	if dw_insert.getitemstring(lrow,'seqno') <> arg_seqno then continue

	// 월계혹만 반영
	if dw_insert.getitemstring(lrow,'mwgbn') <> '1' then continue 
	
	//====================================================================
	lot = dw_insert.getitemnumber(lrow,'minqt')
	//if lot <= 0 then continue
	if lot <= 0 Or isnull(lot) then lot = 0
	
	lsum = dw_insert.getitemnumber(lrow,'sum_week')
	lcnt = dw_insert.getitemnumber(lrow,'moncnt')
	if isnull(lcnt) or lcnt < 1 then lcnt = 1
	
	if lot = 0 then
		lotsum = lsum
	else
		lotsum = ceiling(lsum/lot)*lot
	end if
	
	//====================================================================
	lqty1 = dw_insert.getitemnumber(lrow,'qty_01')
	
	if lot = 0 then
		lneed = lqty1
	else
		lneed = ceiling(lqty1/lot)*lot
	end if
	
	if lcnt > 1 then
		dw_insert.setitem(lrow,'qty_01',lneed)
		lotsum = lotsum - lneed
		lrest= lneed - lqty1
	else
		dw_insert.setitem(lrow,'qty_01',lotsum)
		lotsum = 0
		lrest= 0
	end if
	
	
	//====================================================================
	lqty2 = dw_insert.getitemnumber(lrow,'qty_02') - lrest
	if lqty2 > 0 then
		if lot = 0 then
			lneed = lqty2
		else
			lneed = ceiling(lqty2/lot)*lot
		end if
	else
		lneed = 0
	end if
	
	if lotsum > 0 and lcnt > 2 then
		dw_insert.setitem(lrow,'qty_02',lneed)
		lotsum = lotsum - lneed
		lrest= lneed - lqty2
	else
		dw_insert.setitem(lrow,'qty_02',lotsum)
		lotsum = 0
		lrest= 0
	end if

	//====================================================================
	lqty3 = dw_insert.getitemnumber(lrow,'qty_03') - lrest
	if lqty3 > 0 then
		if lot = 0 then
			lneed = lqty3
		else
			lneed = ceiling(lqty3/lot)*lot
		end if
	else
		lneed = 0
	end if
	
	if lotsum > 0 and lcnt > 3 then
		dw_insert.setitem(lrow,'qty_03',lneed)
		lotsum = lotsum - lneed
		lrest= lneed - lqty3
	else
		dw_insert.setitem(lrow,'qty_03',lotsum)
		lotsum = 0
		lrest= 0
	end if

	//====================================================================
	lqty4 = dw_insert.getitemnumber(lrow,'qty_04') - lrest
	if lqty4 > 0 then
		if lot = 0 then
			lneed = lqty4
		else
			lneed = ceiling(lqty4/lot)*lot
		end if
	else
		lneed = 0
	end if
	
	if lotsum > 0 and lcnt > 4 then
		dw_insert.setitem(lrow,'qty_04',lneed)
		lotsum = lotsum - lneed
		lrest= lneed - lqty4
	else
		dw_insert.setitem(lrow,'qty_04',lotsum)
		lotsum = 0
		lrest= 0
	end if

	//====================================================================
	lqty5 = dw_insert.getitemnumber(lrow,'qty_05') - lrest
	if lqty5 > 0 then
		if lot = 0 then
			lneed = lqty5
		else
			lneed = ceiling(lqty5/lot)*lot
		end if
	else
		lneed = 0
	end if
	
	if lotsum > 0 and lcnt > 5 then
		dw_insert.setitem(lrow,'qty_05',lneed)
		lotsum = lotsum - lneed
		lrest= lneed - lqty5
	else
		dw_insert.setitem(lrow,'qty_05',lotsum)
		lotsum = 0
		lrest= 0
	end if

	//====================================================================
	dw_insert.setitem(lrow,'qty_06',lotsum)
NEXT

end subroutine

public subroutine wf_calc_point2 (string arg_seqno);long		i, lrow
long		lot, lcnt, lsum, lsetsum, lneed, lrest, lotsum, ljan, dweek
long		lqty1, lqty2, lqty3, lqty4, lqty5, lqty6, lqty7
string	sd01, sd02, sd03, sd04, sd05, sd06, sd07
DEC      dporate

// 용기량이 지정되지 않은 자료만 처리 - 횟수에 의한 일괄배분

FOR lrow = 1 TO dw_insert.rowcount()
	if dw_insert.getitemstring(lrow,'seqno') <> arg_seqno then continue 

	// 월계획만 반영
	if dw_insert.getitemstring(lrow,'mwgbn') <> '1' then continue 
	
	//====================================================================
	lot = dw_insert.getitemnumber(lrow,'minqt')
	if lot <= 0 Or isnull(lot) then lot = 0
	//if lot > 0 then continue
	
	lsum = dw_insert.getitemnumber(lrow,'sum_qtp')
	lcnt = dw_insert.getitemnumber(lrow,'moncnt')
	if isnull(lcnt) or lcnt < 1 then lcnt = 1
		
	lneed = lsum/lcnt

	// lot 적용
	if lot = 0 then
	else
		lneed = ceiling(lneed/lot)*lot
	end if
		
	// 1주차
	ljan = lneed
	lcnt = lcnt -1
	dw_insert.setitem(lrow,'qty_01',lneed)
	ljan = ljan - truncate( dw_insert.GetItemNumber(lrow,'qtp_01'),0)

	// 2주차
	dweek = truncate( dw_insert.GetItemNumber(lrow,'qtp_02') ,0)
	if ljan >= dweek then
		dw_insert.setitem(lrow,'qty_02', 0)
		ljan = ljan - dweek
	else
		if lcnt > 0 then
			dw_insert.setitem(lrow,'qty_02',lneed)
			ljan = lneed - dweek
			lcnt = lcnt -1
		else
			dw_insert.setitem(lrow,'qty_02',0)
			ljan = 0
		end if
	end if
	
	// 3주차
	dweek = truncate( dw_insert.GetItemNumber(lrow,'qtp_03') ,0)
	if ljan >= dweek then
		dw_insert.setitem(lrow,'qty_03', 0)
		ljan = ljan - dweek
	else
		if lcnt > 0 then
			dw_insert.setitem(lrow,'qty_03',lneed)
			ljan = lneed - dweek
			lcnt = lcnt -1
		else
			dw_insert.setitem(lrow,'qty_03',0)
			ljan = 0
		end if
	end if

	// 4주차
	dweek = truncate( dw_insert.GetItemNumber(lrow,'qtp_04') ,0)
	if ljan >= dweek then
		dw_insert.setitem(lrow,'qty_04', 0)
		ljan = ljan - dweek
	else
		if lcnt > 0 then
			dw_insert.setitem(lrow,'qty_04',lneed)
			ljan = lneed - dweek
			lcnt = lcnt -1
		else
			dw_insert.setitem(lrow,'qty_04',0)
			ljan = 0
		end if
	end if

	// 5주차
	dweek = truncate( dw_insert.GetItemNumber(lrow,'qtp_05'),0)
	if ljan >= dweek then
		dw_insert.setitem(lrow,'qty_05', 0)
		ljan = ljan - dweek
	else
		if lcnt > 0 then
			dw_insert.setitem(lrow,'qty_05',lneed)
			ljan = lneed - dweek
			lcnt = lcnt -1
		else
			dw_insert.setitem(lrow,'qty_05',0)
			ljan = 0
		end if
	end if
	
	//====================================================================
//	i = 0
//	if i < lcnt then
//		i++
//		lsetsum = lneed
//		dw_insert.setitem(lrow,'qty_01',lneed)
//	else
//		dw_insert.setitem(lrow,'qty_01',0)
//	end if
	

//	//====================================================================
//	if i < lcnt and lsetsum < lsum then
//		i++
//		lsetsum = lsetsum + lneed
//		if lsetsum > lsum then
//			lneed = lsum - (lsetsum - lneed)
//		elseif (lsum - lsetsum) < lneed then
//			lneed = lneed + (lsum - lsetsum)			
//		end if
//		dw_insert.setitem(lrow,'qty_02',lneed)
//	else
//		dw_insert.setitem(lrow,'qty_02',0)
//	end if
//
//
//	//====================================================================
//	if i < lcnt and lsetsum < lsum then
//		i++
//		lsetsum = lsetsum + lneed
//		if lsetsum > lsum then
//			lneed = lsum - (lsetsum - lneed)
//		elseif (lsum - lsetsum) < lneed then
//			lneed = lneed + (lsum - lsetsum)			
//		end if
//		dw_insert.setitem(lrow,'qty_03',lneed)
//	else
//		dw_insert.setitem(lrow,'qty_03',0)
//	end if
//
//
//	//====================================================================
//	if i < lcnt and lsetsum < lsum then
//		i++
//		lsetsum = lsetsum + lneed
//		if lsetsum > lsum then
//			lneed = lsum - (lsetsum - lneed)
//		elseif (lsum - lsetsum) < lneed then
//			lneed = lneed + (lsum - lsetsum)			
//		end if
//		dw_insert.setitem(lrow,'qty_04',lneed)
//	else
//		dw_insert.setitem(lrow,'qty_04',0)
//	end if
//
//	
//	//====================================================================
//	if i < lcnt and lsetsum < lsum then
//		i++
//		lsetsum = lsetsum + lneed
//		if lsetsum > lsum then
//			lneed = lsum - (lsetsum - lneed)
//		elseif (lsum - lsetsum) < lneed then
//			lneed = lneed + (lsum - lsetsum)			
//		end if
//		dw_insert.setitem(lrow,'qty_05',lneed)
//	else
//		dw_insert.setitem(lrow,'qty_05',0)
//	end if
//
//
//	//====================================================================
//	if i < lcnt and lsetsum < lsum then
//		i++
//		lsetsum = lsetsum + lneed
//		if lsetsum > lsum then
//			lneed = lsum - (lsetsum - lneed)
//		elseif (lsum - lsetsum) < lneed then
//			lneed = lneed + (lsum - lsetsum)			
//		end if
//		dw_insert.setitem(lrow,'qty_06',lneed)
//	else
//		dw_insert.setitem(lrow,'qty_06',0)
//	end if
	
NEXT
end subroutine

public subroutine wf_calc_needqty (string arg_seqno);long		lrow
decimal	djego, dminsaf, dqtp_01, dqtp_02, dqtp_03, dqtp_04, dqtp_05, dqtp_06, dneed

// 필요수량 계산
FOR lrow = 1 TO dw_insert.rowcount()
	if dw_insert.getitemstring(lrow,'seqno') <> arg_seqno then continue
	
	If cbx_jego.Checked Then
		//재고가 minus일 경우 0으로 계산(T.F.T회의 내용) - by shingoon 2009.01.05
		djego 	= dw_insert.getitemnumber(lrow,'jgoqty')
		If djego < 0 Then djego = 0
	Else
		djego		= 0
	End If
	
	if isnull(djego) then djego = 0
	dminsaf	= dw_insert.getitemnumber(lrow,'minsaf')
	if isnull(dminsaf) then dminsaf = 0
	dqtp_01	= dw_insert.getitemnumber(lrow,'qtp_01')
	dqtp_02	= dw_insert.getitemnumber(lrow,'qtp_02')
	dqtp_03	= dw_insert.getitemnumber(lrow,'qtp_03')
	dqtp_04	= dw_insert.getitemnumber(lrow,'qtp_04')
	dqtp_05	= dw_insert.getitemnumber(lrow,'qtp_05')
	dqtp_06	= dw_insert.getitemnumber(lrow,'qtp_06')
	
	// 재고감안할 경우
	If cbx_jego.Checked Then
		djego = djego - dqtp_01
		dneed = dminsaf - djego
		if dneed > 0 then
			dw_insert.setitem(lrow,'qty_01',dneed)
		else
			dneed = 0
			dw_insert.setitem(lrow,'qty_01',0)
		end if
		
		djego = djego + dneed - dqtp_02
		dneed = dminsaf - djego
		if dneed > 0 then
			dw_insert.setitem(lrow,'qty_02',dneed)
		else
			dneed = 0
			dw_insert.setitem(lrow,'qty_02',0)
		end if
		
		djego = djego + dneed - dqtp_03
		dneed = dminsaf - djego
		if dneed > 0 then
			dw_insert.setitem(lrow,'qty_03',dneed)
		else
			dneed = 0
			dw_insert.setitem(lrow,'qty_03',0)
		end if
	
		djego = djego + dneed - dqtp_04
		dneed = dminsaf - djego
		if dneed > 0 then
			dw_insert.setitem(lrow,'qty_04',dneed)
		else
			dneed = 0
			dw_insert.setitem(lrow,'qty_04',0)
		end if
	
		djego = djego + dneed - dqtp_05
		dneed = dminsaf - djego
		if dneed > 0 then
			dw_insert.setitem(lrow,'qty_05',dneed)
		else
			dw_insert.setitem(lrow,'qty_05',0)
		end if
		
		djego = djego + dneed - dqtp_06
		dneed = dminsaf - djego
		if dneed > 0 then
			dw_insert.setitem(lrow,'qty_06',dneed)
		else
			dw_insert.setitem(lrow,'qty_06',0)
		end if
	Else
		// 재고 미감안시
		dw_insert.setitem(lrow,'qty_01', dqtp_01)
		dw_insert.setitem(lrow,'qty_02', dqtp_02)
		dw_insert.setitem(lrow,'qty_03', dqtp_03)
		dw_insert.setitem(lrow,'qty_04', dqtp_04)
		dw_insert.setitem(lrow,'qty_05', dqtp_05)
		dw_insert.setitem(lrow,'qty_06', dqtp_06)
	End If
NEXT
end subroutine

public subroutine wf_get_plan2 ();long		lrow1, lrow2, lrow3, lrow4, lrow5, lfrow, lirow, lvlno, lprlvl
long		lrowcnt1, lrowcnt2, lrowcnt3, lrowcnt4, lrowcnt5 ,i
decimal	dqtypr, dunprc, dpalqty, dmonmax, dporate, dmoncnt
decimal	dm01, dm02, dm03, dm04, dm05, dm06, dm07, dm08, dm09, dm10, dm11, dm12, djego, dcjego, dshrat, dldtim2
decimal  dqty_pre , dqtp_pre
string	srinbr, srtype, sittyp, sitgu, scvcod ,scvnas, syymm, sitdsc

syymm = dw_1.getitemstring(1,'yymm')

lrowcnt1 = dw_4.retrieve(gs_saupj,syymm)
if lrowcnt1 < 1 then
	messagebox("확인",syymm+" 월 생산계획[자재소요량] 이 정의되지 않았습니다.")
	return
end if

dw_plan.reset()

FOR lrow1 = 1 TO lrowcnt1
	srinbr = dw_4.getitemstring(lrow1,'itnbr')
	
	dm01 = dw_4.getitemnumber(lrow1,'qtp_01')
	dm02 = dw_4.getitemnumber(lrow1,'qtp_02')
	dm03 = dw_4.getitemnumber(lrow1,'qtp_03')
	dm04 = dw_4.getitemnumber(lrow1,'qtp_04')
	dm05 = dw_4.getitemnumber(lrow1,'qtp_05')
	dm07 = dw_4.getitemnumber(lrow1,'qtp_m1')
	dm08 = dw_4.getitemnumber(lrow1,'qtp_m2')
	
	
	//==================================================================================
	select nvl(sum(jego_qty),0) into :djego from stock
	 where itnbr = :srinbr ;
			 
	if sqlca.sqlcode <> 0 then djego = 0
			
	select itdsc, shrat, ldtim2, nvl(minqt,0)
	  into :sitdsc, :dshrat, :dldtim2, :dpalqty 
	  from itemas
	 where itnbr = :srinbr ;
			 
	if sqlca.sqlcode <> 0 then
		dshrat = 0
		dldtim2= 0
	end if
	
	
   //==================================================================================	
	lrowcnt4 = dw_6.retrieve(srinbr,syymm+'01')
	if lrowcnt4 < 1 then
		messagebox("공급업체","품번 : "+srinbr+" 은(는) 공급업체가 정의되지 않았습니다.")
		CONTINUE
	end if

//	FOR lrow4 = 1 TO lrowcnt4
		scvcod  = dw_6.getitemstring(lrow4,'cvcod')			
		dmonmax = dw_6.getitemnumber(lrow4,'monmax')        // 월최대 발주량 
//		dporate = dw_6.getitemnumber(lrow4,'porate')        // 업체 발주비율 
		dporate = 1.0
		dmoncnt = dw_6.getitemnumber(lrow4,'moncnt')        // 업체 납입횟수
		dunprc  = dw_6.getitemnumber(lrow4,'unprc')         // 단가 
				
		lfrow = dw_insert.find("itnbr = '"+srinbr+"' and " + &
												  "cvcod = '"+scvcod+"'",1,dw_insert.rowcount())
		if lfrow > 0 then
			dw_insert.setitem(lfrow,"qtp_01", dw_insert.getitemnumber(lfrow,"qtp_01") + dm01 )
			dw_insert.setitem(lfrow,"qtp_02", dw_insert.getitemnumber(lfrow,"qtp_02") + dm02 )
			dw_insert.setitem(lfrow,"qtp_03", dw_insert.getitemnumber(lfrow,"qtp_03") + dm03 )
			dw_insert.setitem(lfrow,"qtp_04", dw_insert.getitemnumber(lfrow,"qtp_04") + dm04 )
			dw_insert.setitem(lfrow,"qtp_05", dw_insert.getitemnumber(lfrow,"qtp_05") + dm05 )				
			dw_insert.setitem(lfrow,"qty_m1", dw_insert.getitemnumber(lfrow,"qty_m1") + dm07 )
			dw_insert.setitem(lfrow,"qty_m2", dw_insert.getitemnumber(lfrow,"qty_m2") + dm08 )		
			
		else
					
			lirow = dw_insert.insertrow(0)
					
			dw_insert.setitem(lirow,"sabu",gs_saupj)
			dw_insert.setitem(lirow,"yymm",syymm)
			dw_insert.setitem(lirow,"waigb",'1')
			dw_insert.setitem(lirow,"itnbr",srinbr)
			dw_insert.setitem(lirow,"itemas_itdsc",sitdsc)
			dw_insert.setitem(lirow,"cvcod",scvcod)
			select cvnas into :scvnas from vndmst where cvcod = :scvcod ;
			dw_insert.setitem(lirow,"vndmst_cvnas",scvnas)
			dw_insert.setitem(lirow,"unprc",dunprc)
			dw_insert.setitem(lirow,"minqt",dpalqty)
			dw_insert.setitem(lirow,"monmax",dmonmax)
			
			if dmoncnt > 0 then
				dw_insert.setitem(lirow,"wekmax",Round(dmonmax/dmoncnt,0))
			else
				dw_insert.setitem(lirow,"wekmax",dmonmax)
			end if
			dw_insert.setitem(lirow,"jgoqty",djego)
			dw_insert.setitem(lirow,"shrat",dshrat)
			dw_insert.setitem(lirow,"porate",dporate)
			dw_insert.setitem(lirow,"moncnt",dmoncnt)
			dw_insert.setitem(lirow,"qtp_01",dm01)
			dw_insert.setitem(lirow,"qtp_02",dm02)
			dw_insert.setitem(lirow,"qtp_03",dm03)
			dw_insert.setitem(lirow,"qtp_04",dm04)
			dw_insert.setitem(lirow,"qtp_05",dm05)
			
			dw_insert.setitem(lirow,"qty_m1",dm07)
			dw_insert.setitem(lirow,"qty_m2",dm08)					
			
		end if		
//	NEXT
NEXT


// 상품
lrowcnt5 = dw_41.retrieve(gs_saupj,syymm)
FOR lrow5 = 1 TO lrowcnt5
	srinbr = dw_41.getitemstring(lrow1,'itnbr')

	dm01 = dw_41.getitemnumber(lrow1,'w01')
	dm02 = dw_41.getitemnumber(lrow1,'w02')
	dm03 = dw_41.getitemnumber(lrow1,'w03')
	dm04 = dw_41.getitemnumber(lrow1,'w04')
	dm05 = dw_41.getitemnumber(lrow1,'w05')	
	dm07 = dw_41.getitemnumber(lrow1,'m1')
	dm08 = dw_41.getitemnumber(lrow1,'m2')
	
	//==================================================================================
	select nvl(sum(jego_qty),0) into :djego from stock
	 where itnbr = :srinbr ;
	
	if sqlca.sqlcode <> 0 then djego = 0

	select itdsc, shrat, ldtim2, nvl(minqt,0)
	  into :sitdsc, :dshrat, :dldtim2, :dpalqty 
	  from itemas
	 where itnbr = :srinbr ;
	 
	if sqlca.sqlcode <> 0 then 
		dshrat = 0
		dldtim2= 0
	end if
	
	
	lrowcnt4 = dw_6.retrieve(srinbr,syymm+'01')
	if lrowcnt4 < 1 then
		messagebox("공급업체","품번 : "+srinbr+" 은(는) 공급업체가 정의되지 않았습니다.")
		CONTINUE
	end if
	
	
//	FOR lrow4 = 1 TO lrowcnt4
		lrow4 = 1
		scvcod  = dw_6.getitemstring(lrow4,'cvcod')
//		dpalqty = dw_6.getitemnumber(lrow4,'palqty')
		dmonmax = dw_6.getitemnumber(lrow4,'monmax')
//		dporate = dw_6.getitemnumber(lrow4,'porate')
		dporate = 1.0
		dmoncnt = dw_6.getitemnumber(lrow4,'moncnt')  
		dunprc  = dw_6.getitemnumber(lrow4,'unprc')		
		
		lfrow = dw_insert.find("itnbr = '"+srinbr+"' and " + &
										  "cvcod = '"+scvcod+"'",1,dw_insert.rowcount())
		if lfrow > 0 then
			dw_insert.setitem(lfrow,"qtp_01", &
									dw_insert.getitemnumber(lfrow,"qtp_01")+(dm01))
			dw_insert.setitem(lfrow,"qtp_02", &
									dw_insert.getitemnumber(lfrow,"qtp_02")+(dm02))
			dw_insert.setitem(lfrow,"qtp_03", &
									dw_insert.getitemnumber(lfrow,"qtp_03")+(dm03))
			dw_insert.setitem(lfrow,"qtp_04", &
									dw_insert.getitemnumber(lfrow,"qtp_04")+(dm04))
			dw_insert.setitem(lfrow,"qtp_05", &
									dw_insert.getitemnumber(lfrow,"qtp_05")+(dm05))
	
			dw_insert.setitem(lfrow,"qty_m1", &
									dw_insert.getitemnumber(lfrow,"qty_m1")+(dm07))
			dw_insert.setitem(lfrow,"qty_m2", &
									dw_insert.getitemnumber(lfrow,"qty_m2")+(dm08))
		else
			lirow = dw_insert.insertrow(0)
			
			
			dw_insert.setitem(lirow,"sabu",gs_saupj)
			dw_insert.setitem(lirow,"yymm",syymm)
			dw_insert.setitem(lirow,"waigb",'1')
			dw_insert.setitem(lirow,"itnbr",srinbr)
			dw_insert.setitem(lirow,"itemas_itdsc",sitdsc)
			dw_insert.setitem(lirow,"cvcod",scvcod)
			select cvnas into :scvnas from vndmst where cvcod = :scvcod ;
			dw_insert.setitem(lirow,"vndmst_cvnas",scvnas)
			dw_insert.setitem(lirow,"unprc",dunprc)
			dw_insert.setitem(lirow,"minqt",dpalqty)
			dw_insert.setitem(lirow,"monmax",dmonmax)
			
			if dmoncnt > 0 then
				dw_insert.setitem(lirow,"wekmax",Round(dmonmax/dmoncnt,0))
			else
				dw_insert.setitem(lirow,"wekmax",dmonmax)
			end if
			dw_insert.setitem(lirow,"jgoqty",djego)
			dw_insert.setitem(lirow,"shrat",dshrat)
			dw_insert.setitem(lirow,"porate",dporate)
			dw_insert.setitem(lirow,"moncnt",dmoncnt)
			dw_insert.setitem(lirow,"qtp_01",dm01)
			dw_insert.setitem(lirow,"qtp_02",dm02)
			dw_insert.setitem(lirow,"qtp_03",dm03)
			dw_insert.setitem(lirow,"qtp_04",dm04)
			dw_insert.setitem(lirow,"qtp_05",dm05)
			dw_insert.setitem(lirow,"qty_m1",dm07)
			dw_insert.setitem(lirow,"qty_m2",dm08)
		end if				
//	NEXT
NEXT	
end subroutine

public function integer wf_calc_sagub ();long		lrow, lrow4, lirow, lfrow2, lrowcount, ix
string	syymm, sfdate, stdate, srinbr, scinbr, scvcod, scvnas, scidsc, sjasa, srvcod
decimal	dporate, dunprc, dmoncnt
decimal	djego, dshrat, dldtim2, dpalqty, dmidsaf, dmonmax, dwdrate
datastore ds_wstruc

ds_wstruc = create datastore
ds_wstruc.dataobject = 'd_wstruc'
ds_wstruc.SetTransObject(sqlca)

dw_insert.accepttext()
syymm = dw_1.getitemstring(1,'yymm')

// 자사코드 가져오기
select dataname into :sjasa from syscnfg
 where sysgu = 'C' and serial = 4 and lineno = '1' ;


// 월최대납품량을 계산을 위한 기간정보. ========================================
sfdate = f_aftermonth(left(syymm,6),-12) + '01'
stdate = f_aftermonth(left(syymm,6),-1) + '31'

FOR lrow = 1 TO dw_insert.rowcount()
	if dw_insert.getitemstring(lrow,'seqno') = '2' then continue
	
	srinbr = dw_insert.getitemstring(lrow,"itnbr")
	srvcod = dw_insert.getitemstring(lrow,"cvcod")

	// 유상사급인 경우 확인- 2003.12.18
//	select a.itnbrwd, nvl(a.wdrate,0)
//	  into :scinbr, :dwdrate
//	  from item_rel a,
//			 itemas   b
//	 where a.itnbr   = :srinbr
//	   and a.itnbrwd = b.itnbr
//		and b.useyn = '0' ;
//	if sqlca.sqlcode <> 0 then continue
//	if dwdrate <= 0 or dwdrate > 1 then dwdrate = 1.0   // 사급비율

	// 유상사급은 외주BOM에서 읽어온다
	For ix = 1 To ds_wstruc.Retrieve(srinbr, srvcod)
		scinbr = ds_wstruc.GetItemString(ix, 'cinbr')

		dwdrate = 1.0
		
		st_info1.text = '유상사급 추가 :'
		st_info2.text = srinbr + ' -> ' + scinbr
	
	
		// 월최대납품량 계산. =======================================================
		wf_calc_mnapqty(sfdate,stdate,scinbr)
		
		
		// 재고 계산 =====================================================================
		select nvl(sum(jego_qty),0) into :djego from stock
		 where itnbr = :scinbr ;
		if sqlca.sqlcode <> 0 then djego = 0
		
				
		select itdsc, shrat, ldtim2, nvl(minqt,0), nvl(midsaf,0), nvl(mnapqty,0)
		  into :scidsc, :dshrat, :dldtim2, :dpalqty, :dmidsaf, :dmonmax
		  from itemas
		 where itnbr = :scinbr ;
		 
		if sqlca.sqlcode <> 0 then 
			dshrat = 0
			dldtim2= 0
		end if
		
		lrowcount = dw_6.retrieve(scinbr,syymm+'01')
	
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
				dmoncnt = 1
				dunprc  = 0
			else
				scvcod  = dw_6.getitemstring(lrow4,'cvcod')
				dporate = dw_6.getitemnumber(lrow4,'porate')
				dmoncnt = dw_6.getitemnumber(lrow4,'moncnt')
				dunprc  = dw_6.getitemnumber(lrow4,'unprc')
			end if
	
			lfrow2 = dw_insert.find("cvcod='"+scvcod+"' and itnbr='"+scinbr+"'",1,dw_insert.rowcount())
			if lfrow2 > 0 then
				continue
			else
							
				lirow = dw_insert.insertrow(0)
				dw_insert.setitem(lirow,"sabu",gs_saupj)
				dw_insert.setitem(lirow,"yymm",syymm)
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
		
				dw_insert.setitem(lirow,"jgoqty",djego)
				dw_insert.setitem(lirow,"shrat",dshrat)
				dw_insert.setitem(lirow,"moncnt",dmoncnt)
				dw_insert.setitem(lirow,"minsaf",dmidsaf)
		
				dw_insert.setitem(lirow,"qtp_01",dwdrate*dw_insert.getitemnumber(lrow,"qty_01"))
				dw_insert.setitem(lirow,"qtp_02",dwdrate*dw_insert.getitemnumber(lrow,"qty_02"))
				dw_insert.setitem(lirow,"qtp_03",dwdrate*dw_insert.getitemnumber(lrow,"qty_03"))
				dw_insert.setitem(lirow,"qtp_04",dwdrate*dw_insert.getitemnumber(lrow,"qty_04"))
				dw_insert.setitem(lirow,"qtp_05",dwdrate*dw_insert.getitemnumber(lrow,"qty_05"))
				dw_insert.setitem(lirow,"qtp_06",dwdrate*dw_insert.getitemnumber(lrow,"qty_06"))
				dw_insert.setitem(lirow,"qty_m1",dwdrate*dw_insert.getitemnumber(lrow,"qty_m1"))
				dw_insert.setitem(lirow,"qty_m2",dwdrate*dw_insert.getitemnumber(lrow,"qty_m2"))
				dw_insert.setitem(lirow,"seqno",'2')
				
				if lrowcount > 1 then dw_insert.setitem(lirow,"cvdbl",'Y') // 이원화 표시
			end if		
		NEXT
	Next
NEXT

destroy ds_wstruc

return 1
end function

public function integer wf_calc_mnapqty (string arg_fdate, string arg_tdate, string arg_itnbr);// 월최대납품량을 계산한다. =================================================
decimal	dmaxqty

select nvl(max(a.qty),0)
  into :dmaxqty
  from ( select substr(io_date,1,6) as yymm,
					 sum(ioqty) as qty
			  from imhist
			 where sabu = '1'
				and io_date between :arg_fdate and :arg_tdate
				and saupj = :gs_saupj
				and iogbn = 'I01'
				and itnbr = :arg_itnbr
			group by substr(io_date,1,6) ) a ;

if dmaxqty > 0 then
	update itemas
		set mnapqty = :dmaxqty
	 where itnbr = :arg_itnbr ;
end if

commit ;

return 1
end function

public subroutine wf_set_porate ();long		lrow
decimal	drate

dw_insert.accepttext()


////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 업체별 발주비율 적용
FOR lrow = 1 TO dw_insert.rowcount()
	drate = dw_insert.getitemnumber(lrow,"porate")
//	drate = 1
	dw_insert.setitem(lrow,"qtp_01_org",dw_insert.getitemnumber(lrow,"qtp_01"))
	dw_insert.setitem(lrow,"qtp_02_org",dw_insert.getitemnumber(lrow,"qtp_02"))
	dw_insert.setitem(lrow,"qtp_03_org",dw_insert.getitemnumber(lrow,"qtp_03"))
	dw_insert.setitem(lrow,"qtp_04_org",dw_insert.getitemnumber(lrow,"qtp_04"))
	dw_insert.setitem(lrow,"qtp_05_org",dw_insert.getitemnumber(lrow,"qtp_05"))
	dw_insert.setitem(lrow,"qtp_06_org",dw_insert.getitemnumber(lrow,"qtp_06"))
	dw_insert.setitem(lrow,"jgoqty_org",dw_insert.getitemnumber(lrow,"jgoqty"))
	dw_insert.setitem(lrow,"minsaf_org",dw_insert.getitemnumber(lrow,"minsaf"))

	dw_insert.setitem(lrow,"qtp_01",dw_insert.getitemnumber(lrow,"qtp_01")*drate)
	dw_insert.setitem(lrow,"qtp_02",dw_insert.getitemnumber(lrow,"qtp_02")*drate)
	dw_insert.setitem(lrow,"qtp_03",dw_insert.getitemnumber(lrow,"qtp_03")*drate)
	dw_insert.setitem(lrow,"qtp_04",dw_insert.getitemnumber(lrow,"qtp_04")*drate)
	dw_insert.setitem(lrow,"qtp_05",dw_insert.getitemnumber(lrow,"qtp_05")*drate)
	dw_insert.setitem(lrow,"qtp_06",dw_insert.getitemnumber(lrow,"qtp_06")*drate)
	dw_insert.setitem(lrow,"jgoqty",dw_insert.getitemnumber(lrow,"jgoqty")*drate)
	dw_insert.setitem(lrow,"minsaf",dw_insert.getitemnumber(lrow,"minsaf")*drate)
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
	dw_insert.setitem(lrow,"jgoqty",dw_insert.getitemnumber(lrow,"jgoqty_org"))
	dw_insert.setitem(lrow,"minsaf",dw_insert.getitemnumber(lrow,"minsaf_org"))
NEXT
end subroutine

public subroutine wf_get_plan ();
long		lrow1, lrow2, lrow3, lrow4, lrow5, lfrow, lirow, lvlno, lprlvl
long		lrowcnt1, lrowcnt2, lrowcnt3, lrowcnt4, lrowcnt5 , i
decimal	dqtypr, dunprc, dpalqty, dmonmax, dporate, dmoncnt, dmidsaf
decimal	dm01, dm02, dm03, dm04, dm05, dm06, dm07, dm08, dm09, dm10, dm11, dm12, djego, dcjego, dshrat, dldtim2
decimal  dqty_pre , dqtp_pre
string	spinbr, srinbr, srtype, sittyp, sitgu, scvcod ,scvnas, syymm, sitdsc, sjasa, smwgbn, smorpm
string	sfdate, stdate

smorpm= dw_1.getitemstring(1,'smorpm')
syymm = dw_1.getitemstring(1,'yymm')

// 월최대납품량을 계산을 위한 기간정보. ========================================
sfdate = f_aftermonth(left(syymm,6),-12) + '01'
stdate = f_aftermonth(left(syymm,6),-1) + '31'

lrowcnt1 = dw_4.retrieve(gs_saupj,syymm)
if lrowcnt1 < 1 then
	messagebox("확인",syymm+" 월 생산계획[자재소요량] 이 정의되지 않았습니다.")
	return
end if

st_info.text = ''
st_info1.text = ''
st_info2.text = ''

st_info.visible = true
st_info1.visible = true
st_info2.visible = true

dw_insert.reset()

// 자사코드 가져오기
select dataname into :sjasa from syscnfg
 where sysgu = 'C' and serial = 4 and lineno = '1' ;

FOR lrow1 = 1 TO lrowcnt1	
	srinbr = dw_4.getitemstring(lrow1,'itnbr')
	
	
	// 월최대납품량 계산. =======================================================
	wf_calc_mnapqty(sfdate,stdate,srinbr)
	
	
	dm01 = dw_4.getitemnumber(lrow1,'qtp_01')
	dm02 = dw_4.getitemnumber(lrow1,'qtp_02')
	dm03 = dw_4.getitemnumber(lrow1,'qtp_03')
	dm04 = dw_4.getitemnumber(lrow1,'qtp_04')
	dm05 = dw_4.getitemnumber(lrow1,'qtp_05')
	dm06 = dw_4.getitemnumber(lrow1,'qtp_06')
	dm07 = dw_4.getitemnumber(lrow1,'qtp_m1')
	dm08 = dw_4.getitemnumber(lrow1,'qtp_m2')
	
	st_info1.text = '구매 계획량 계산 :'
	st_info2.text = srinbr
	
	// 재고 계산 =====================================================================
	select nvl(sum(jego_qty),0) into :djego from stock       //재고
	 where itnbr = :srinbr ;

	
	if sqlca.sqlcode <> 0 then djego = 0
			
	select itdsc, shrat, ldtim2, nvl(minqt,0), nvl(midsaf,0), nvl(mnapqty,0)
	  into :sitdsc, :dshrat, :dldtim2, :dpalqty, :dmidsaf, :dmonmax
	  from itemas
	 where itnbr = :srinbr ;
			 
	if sqlca.sqlcode <> 0 then 
		dshrat = 0
		dldtim2= 0
	end if
   //==================================================================================	

	lrowcnt4 = dw_6.retrieve(srinbr,syymm+'01')


//////////////////////////////////////////////////////////////////////////////////////////////
// 이원화 및 발주비율 적용 - START - 2004.01.05
	if lrowcnt4 < 1 then
		scvcod  = sjasa
		lrowcnt4= 1
		smwgbn  = '2'
	else
		scvcod  = dw_6.getitemstring(1,'cvcod')
		smwgbn  = dw_6.getitemstring(1,'mwgbn')
	end if	

	FOR lrow4 = 1 TO lrowcnt4
		if scvcod = sjasa and lrowcnt4 = 1 then
			dporate = 1.0
			dmoncnt = 1
			dunprc  = 0
			smwgbn  = '2'
		else
			scvcod  = dw_6.getitemstring(lrow4,'cvcod')
			smwgbn  = dw_6.getitemstring(lrow4,'mwgbn')
			dporate = dw_6.getitemnumber(lrow4,'porate')
			//dporate = 1.0
			dmoncnt = dw_6.getitemnumber(lrow4,'moncnt')
			dunprc  = dw_6.getitemnumber(lrow4,'unprc')
		end if
		
			
		lirow = dw_insert.insertrow(0)
				
		dw_insert.setitem(lirow,"sabu",gs_saupj)
		dw_insert.setitem(lirow,"yymm",syymm)
		dw_insert.setitem(lirow,"waigb",'1')
		dw_insert.setitem(lirow,"itnbr",srinbr)
		dw_insert.setitem(lirow,"mwgbn",smwgbn)
		
		dw_insert.setitem(lirow,"itemas_itdsc",sitdsc)
		dw_insert.setitem(lirow,"cvcod",scvcod)
		select cvnas into :scvnas from vndmst where cvcod = :scvcod ;
		dw_insert.setitem(lirow,"vndmst_cvnas",scvnas)
		dw_insert.setitem(lirow,"unprc",dunprc)
		dw_insert.setitem(lirow,"minqt",dpalqty)
		dw_insert.setitem(lirow,"monmax",dmonmax)
		
		if dmoncnt > 0 then
			dw_insert.setitem(lirow,"wekmax",Round(dmonmax/dmoncnt,0))
		else
			dw_insert.setitem(lirow,"wekmax",dmonmax)
		end if
		dw_insert.setitem(lirow,"jgoqty",djego)
		dw_insert.setitem(lirow,"shrat",dshrat)
		dw_insert.setitem(lirow,"porate",dporate)
		dw_insert.setitem(lirow,"moncnt",dmoncnt)
		dw_insert.setitem(lirow,"minsaf",dmidsaf)
		dw_insert.setitem(lirow,"smorpm",smorpm)
		dw_insert.setitem(lirow,"qtp_01",dm01)
		dw_insert.setitem(lirow,"qtp_02",dm02)
		dw_insert.setitem(lirow,"qtp_03",dm03)
		dw_insert.setitem(lirow,"qtp_04",dm04)
		dw_insert.setitem(lirow,"qtp_05",dm05)
		dw_insert.setitem(lirow,"qtp_06",dm06)
		dw_insert.setitem(lirow,"qty_m1",dm07)
		dw_insert.setitem(lirow,"qty_m2",dm08)
		
		if lrowcnt4 > 1 then dw_insert.setitem(lirow,"cvdbl",'Y') // 이원화 표시	
	NEXT
	
// 이원화 및 발주비율 적용 - END
//////////////////////////////////////////////////////////////////////////////////////////////
	
NEXT


//// 상품
//lrowcnt5 = dw_41.retrieve(gs_saupj,syymm)
//FOR lrow5 = 1 TO lrowcnt5
//	srinbr = dw_41.getitemstring(lrow5,'itnbr')
//	spinbr = dw_41.getitemstring(lrow5,'itnbryd')
//
//
//	// 월최대납품량 계산. =======================================================
//	wf_calc_mnapqty(sfdate,stdate,srinbr)
//	
//	
//	st_info1.text = '상품 계획 추가 :'
//	st_info2.text = srinbr
//
//	dm01 = dw_41.getitemnumber(lrow5,'w01')
//	dm02 = dw_41.getitemnumber(lrow5,'w02')
//	dm03 = dw_41.getitemnumber(lrow5,'w03')
//	dm04 = dw_41.getitemnumber(lrow5,'w04')
//	dm05 = dw_41.getitemnumber(lrow5,'w05')	
//	dm06 = dw_41.getitemnumber(lrow5,'w06')	
//	dm07 = dw_41.getitemnumber(lrow5,'m1')
//	dm08 = dw_41.getitemnumber(lrow5,'m2')
//	
//	
//	// 재고 계산 =====================================================================
//	select nvl(sum(jego_qty),0) into :djego from stock
//	 where itnbr = :spinbr ;
//	if sqlca.sqlcode <> 0 then djego = 0
//	
//			
//	select itdsc, shrat, ldtim2, nvl(minqt,0), nvl(midsaf,0), nvl(mnapqty,0)
//	  into :sitdsc, :dshrat, :dldtim2, :dpalqty, :dmidsaf, :dmonmax
//	  from itemas
//	 where itnbr = :srinbr ;
//	 
//	if sqlca.sqlcode <> 0 then 
//		dshrat = 0
//		dldtim2= 0
//	end if
//	
//	lrowcnt4 = dw_6.retrieve(srinbr,syymm+'01')
//
////////////////////////////////////////////////////////////////////////////////////////////////
//// 이원화 및 발주비율 적용 - START - 2004.01.05
//	if lrowcnt4 < 1 then
//		scvcod  = sjasa
//		lrowcnt4= 1
//	else
//		scvcod  = dw_6.getitemstring(1,'cvcod')
//	end if	
//
//	FOR lrow4 = 1 TO lrowcnt4
//		if scvcod = sjasa and lrowcnt4 = 1 then
//			dporate = 1.0
//			dmoncnt = 1
//			dunprc  = 0
//		else
//			scvcod  = dw_6.getitemstring(lrow4,'cvcod')
//			dporate = dw_6.getitemnumber(lrow4,'porate')
//			dmoncnt = dw_6.getitemnumber(lrow4,'moncnt')
//			dunprc  = dw_6.getitemnumber(lrow4,'unprc')
//		end if
//		
//	
//		lirow = dw_insert.insertrow(0)
//		
//		dw_insert.setitem(lirow,"sabu",gs_saupj)
//		dw_insert.setitem(lirow,"yymm",syymm)
//		dw_insert.setitem(lirow,"waigb",'1')
//		dw_insert.setitem(lirow,"itnbr",srinbr)
//		dw_insert.setitem(lirow,"itemas_itdsc",sitdsc)
//		dw_insert.setitem(lirow,"cvcod",scvcod)
//		select cvnas into :scvnas from vndmst where cvcod = :scvcod ;
//		dw_insert.setitem(lirow,"vndmst_cvnas",scvnas)
//		dw_insert.setitem(lirow,"unprc",dunprc)
//		dw_insert.setitem(lirow,"minqt",dpalqty)
//		dw_insert.setitem(lirow,"monmax",dmonmax)
//		
//		if dmoncnt > 0 then
//			dw_insert.setitem(lirow,"wekmax",Round(dmonmax/dmoncnt,0))
//		else
//			dw_insert.setitem(lirow,"wekmax",dmonmax)
//		end if
//		dw_insert.setitem(lirow,"jgoqty",djego)
//		dw_insert.setitem(lirow,"shrat",dshrat)
//		dw_insert.setitem(lirow,"porate",dporate)
//		dw_insert.setitem(lirow,"moncnt",dmoncnt)
//		dw_insert.setitem(lirow,"minsaf",dmidsaf)
//		dw_insert.setitem(lirow,"qtp_01",dm01)
//		dw_insert.setitem(lirow,"qtp_02",dm02)
//		dw_insert.setitem(lirow,"qtp_03",dm03)
//		dw_insert.setitem(lirow,"qtp_04",dm04)
//		dw_insert.setitem(lirow,"qtp_05",dm05)
//		dw_insert.setitem(lirow,"qtp_06",dm06)
//		dw_insert.setitem(lirow,"qty_m1",dm07)
//		dw_insert.setitem(lirow,"qty_m2",dm08)
//		
//		if lrowcnt4 > 1 then dw_insert.setitem(lirow,"cvdbl",'Y') // 이원화 표시
//	NEXT
	
// 이원화 및 발주비율 적용 - END
//////////////////////////////////////////////////////////////////////////////////////////////
	
	
//NEXT	


st_info.visible = false
st_info1.visible = false
st_info2.visible = false
end subroutine

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

on w_pu01_00020.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.rr_2=create rr_2
this.dw_4=create dw_4
this.st_info=create st_info
this.st_info2=create st_info2
this.st_info1=create st_info1
this.dw_6=create dw_6
this.dw_3=create dw_3
this.dw_1=create dw_1
this.dw_41=create dw_41
this.dw_7=create dw_7
this.p_1=create p_1
this.dw_plan=create dw_plan
this.rr_3=create rr_3
this.rr_4=create rr_4
this.dw_insert2=create dw_insert2
this.cbx_jego=create cbx_jego
this.dw_pdt=create dw_pdt
this.cb_1=create cb_1
this.pb_1=create pb_1
this.p_xls=create p_xls
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.rr_2
this.Control[iCurrent+3]=this.dw_4
this.Control[iCurrent+4]=this.st_info
this.Control[iCurrent+5]=this.st_info2
this.Control[iCurrent+6]=this.st_info1
this.Control[iCurrent+7]=this.dw_6
this.Control[iCurrent+8]=this.dw_3
this.Control[iCurrent+9]=this.dw_1
this.Control[iCurrent+10]=this.dw_41
this.Control[iCurrent+11]=this.dw_7
this.Control[iCurrent+12]=this.p_1
this.Control[iCurrent+13]=this.dw_plan
this.Control[iCurrent+14]=this.rr_3
this.Control[iCurrent+15]=this.rr_4
this.Control[iCurrent+16]=this.dw_insert2
this.Control[iCurrent+17]=this.cbx_jego
this.Control[iCurrent+18]=this.dw_pdt
this.Control[iCurrent+19]=this.cb_1
this.Control[iCurrent+20]=this.pb_1
this.Control[iCurrent+21]=this.p_xls
end on

on w_pu01_00020.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.dw_4)
destroy(this.st_info)
destroy(this.st_info2)
destroy(this.st_info1)
destroy(this.dw_6)
destroy(this.dw_3)
destroy(this.dw_1)
destroy(this.dw_41)
destroy(this.dw_7)
destroy(this.p_1)
destroy(this.dw_plan)
destroy(this.rr_3)
destroy(this.rr_4)
destroy(this.dw_insert2)
destroy(this.cbx_jego)
destroy(this.dw_pdt)
destroy(this.cb_1)
destroy(this.pb_1)
destroy(this.p_xls)
end on

event open;call super::open;dw_1.SetTransObject(sqlca)
dw_3.SetTransObject(sqlca)
dw_plan.SetTransObject(sqlca)
dw_insert.SetTransObject(sqlca)
dw_insert2.SetTransObject(sqlca)
dw_4.SetTransObject(sqlca)
dw_41.SetTransObject(sqlca)
dw_6.SetTransObject(sqlca)
dw_pdt.SetTransObject(sqlca)

wf_initial()
end event

type dw_insert from w_inherite`dw_insert within w_pu01_00020
integer x = 23
integer y = 228
integer width = 4558
integer height = 1664
string dataobject = "d_pu01_00020_2_m"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemerror;call super::itemerror;return 1
end event

event dw_insert::rowfocuschanged;call super::rowfocuschanged;this.selectrow(0,false)
if currentrow > 0 then
	this.selectrow(currentrow,true)
end if

post wf_set_info(this,currentrow)
end event

event dw_insert::doubleclicked;call super::doubleclicked;//if row <= 0 then return
//
//long		lrow
//string	sitnbr, scvcod
//
//sitnbr = this.getitemstring(row,'itnbr')
//scvcod = this.getitemstring(row,'cvcod')
//
//lrow = dw_insert2.find("itnbr='"+sitnbr+"' and "+&
//							 "cvcod='"+scvcod+"'",1,dw_insert2.rowcount())
//if lrow > 0 then
//	dw_7.setitem(1,'gubun','2')
//	dw_7.triggerevent(itemchanged!)
//	
//	lrow = dw_insert2.find("itnbr='"+sitnbr+"' and "+&
//							 "cvcod='"+scvcod+"'",1,dw_insert2.rowcount())
//	
//	this.selectrow(0,false)
//	dw_insert2.setrow(lrow)
//	dw_insert2.selectrow(0,false)
//	dw_insert2.selectrow(lrow,true)
//	dw_insert2.scrolltorow(lrow)	
//end if

if row <= 0 then return

if left(dwo.name,2) = 'qt' then
	gs_gubun	= trim(dw_1.getitemstring(1,'yymm'))
	gs_code  = this.getitemstring(row,'itnbr')
	gs_codename = this.getitemstring(row,'itemas_itdsc')
	gs_codename2= right(dwo.name,2)

	open(w_plancheck_popup)
	
end if
end event

event dw_insert::clicked;call super::clicked;this.selectrow(0,false)
if row > 0 then
	this.selectrow(row,true)
end if

post wf_set_info(this,row)
end event

event dw_insert::itemchanged;call super::itemchanged;if row <= 0 then return

if this.getcolumnname() = 'cvdbl' then
	string	sitnbr, sitdsc, scvnas, sok
	decimal	dunprc

	sitnbr = this.getitemstring(row,'itnbr')
	sitdsc = this.getitemstring(row,'itemas_itdsc')
	
	gs_code = sitnbr
	gs_codename = sitdsc
	
	open(w_cvdouble_popup)
	sok = message.stringparm
	if sok = 'OK' then
		this.rowscopy(row,row,primary!,this,row+1,primary!)
		
		select unprc into :dunprc from danmst
		 where itnbr = sitnbr and cvcod = :gs_code and opseq = '9999' ;
		
		if sqlca.sqlcode <> 0 then dunprc = 0
		
		this.setitem(row+1,'cvcod',gs_code)
		this.setitem(row+1,'vndmst_cvnas',gs_codename)
		this.setitem(row+1,'unprc',gs_codename)
		this.setitem(row+1,"qty_01",0)
		this.setitem(row+1,"qty_02",0)
		this.setitem(row+1,"qty_03",0)
		this.setitem(row+1,"qty_04",0)
		this.setitem(row+1,"qty_05",0)
		
		this.setitem(row,"cvdbl",'N')
		this.setitem(row+1,"cvdbl",'N')
	end if
end if

this.selectrow(0,false)
post wf_set_info(this,row)
end event

type p_delrow from w_inherite`p_delrow within w_pu01_00020
boolean visible = false
integer x = 4974
integer y = 48
end type

event p_delrow::clicked;call super::clicked;Long nRow

If f_msg_delete() <> 1 Then	REturn

nRow = dw_insert.GetRow()
If nRow > 0 then
	dw_insert.DeleteRow(nRow)
	
	If dw_insert.Update() <> 1 Then
		RollBack;
		f_message_chk(31,'')
		Return
	End If
	Commit;
End If
end event

type p_addrow from w_inherite`p_addrow within w_pu01_00020
boolean visible = false
integer x = 5230
integer y = 536
end type

event p_addrow::clicked;String sYymm, sCust
Long	 nRow, dMax

If dw_1.AcceptText() <> 1 Then Return

sYymm = Trim(dw_1.GetItemString(1, 'yymm'))
scust = Trim(dw_1.GetItemString(1, 'cust'))
If sCust < '4' Then Return

If IsNull(sYymm) Or sYymm = '' Then
	f_message_chk(1400,'')
	Return
End If

nRow = dw_insert.InsertRow(0)
dw_insert.SetItem(nRow, 'yymm', sYymm)

end event

type p_search from w_inherite`p_search within w_pu01_00020
string tag = "MRP"
integer x = 3685
integer y = 40
boolean originalsize = true
string picturename = "C:\erpman\image\MRP_up.gif"
end type

event p_search::clicked;string	syymm ,syymm_pre, stemp, smagam , steam
long     ll_confirm

dw_1.accepttext()

syymm = trim(dw_1.getitemstring(1,'yymm'))
if Isnull(syymm) or syymm = '' then
	f_message_chk(1400,'[계획년월]')
	return
end if

steam = trim(dw_1.getitemstring(1,'gubun'))
if Isnull(steam) or steam = '%' then
	f_message_chk(1400,'[생산팀]')
	return
end if

smagam = dw_1.getitemstring(1,'cnfirm')
if smagam = 'Y' then
	messagebox("확인","확정처리된 자료입니다.")
	return
end if

select monyymm into :stemp from PM01_MONPLAN_SUM
 where sabu = :gs_sabu and monyymm = :syymm and moseq = 0 and rownum = 1 ;
if sqlca.sqlcode <> 0 then
	messagebox('확인',syymm + '월 생산계획이 없습니다')
	return
end if

select yymm into :syymm 
  from pu02_monplan
 where sabu = :gs_saupj 
   and yymm = :syymm 
	and waigb = '1'
	and rownum = 1 ;

if sqlca.sqlcode = 0 then
	if messagebox("자재소요량 전개",syymm+" 월 구매계획이 존재합니다."+&
								"~n새로 자재소요량을 전개하시겠습니까?" ,exclamation!,oKcancel!,2) = 2 then
		return
	
	end if
else
	if messagebox("자재소요량 전개","자재소요량을 전개하시겠습니까?" ,exclamation!,oKcancel!,2) = 2 then
		return
	
	end if
end if

// 기존에 있던 계획은 삭제한다. =================================================
Delete From pu02_monplan 
		Where sabu = :gs_saupj 
		  and yymm = :syymm 
		  and waigb = '1' ;
If sqlca.sqlcode <> 0 Then
	Rollback;
	dw_insert.Reset()
	MessageBox('ERROR','MRP 작성 중 에러가 발생했습니다. DB 에러 ')
	Return
End If
//===========================================================================

//구매계획 전송
Int	 iMaxNo
String serror

// 실행순번의 전송구분을 검색하여 기 전송된 내역이면 전송 취소
Select max(actno) into :iMaxNo from mrpsys where mrpdata = 2;

serror = 'X'
Sqlca.erp000000050_7_leewon(gs_Saupj, iMaxNo, syymm, 1, '2', steam, 'Y', serror)
//messagebox(string(sqlca.sqlcode),sqlca.sqlerrtext)				
Commit;

IF serror <> 'N' THEN
	messagebox("확 인", "계획ORDER 확정이 실패하였습니다.!!")
	Return
else
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
wf_get_plan()				// 1.월생산계획 및 월판매계획(상품) READ
//wf_set_porate()			// 발주비율 적용 - 2004.01.06
wf_calc_needqty('1')		// 2.필요수량 계산
wf_calc_point('1')		// 4.납입요청량 및 납입시점 결정 ( 용기량 有 )
//wf_calc_point2('1')		//   납입요청량 및 납입시점 결정 ( 용기량 無 )


///////////////////////////////////////////////////////////////////////////////
// 유상사급품 추가 - 2003.12.18
wf_calc_sagub()
wf_calc_needqty('2')
wf_calc_point('2')
//wf_calc_point2('2')

//wf_set_qtp_org()			// 필요수량 원위치-2004.01.06
wf_set_orgqty()			// 5.초기 필요량 설정

dw_insert.setsort("sabu A, yymm A, waigb A, cvcod A, itnbr A")
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

type p_ins from w_inherite`p_ins within w_pu01_00020
string tag = "조정"
boolean visible = false
integer x = 4704
integer y = 392
string picturename = "C:\erpman\image\메일전송_up.gif"
end type

event p_ins::clicked;call super::clicked;String	ls_window_id , ls_window_nm, syymm

dw_1.accepttext()

syymm = trim(dw_1.getitemstring(1,'yymm'))
if Isnull(syymm) or syymm = '' then
	f_message_chk(1400,'[계획년월]')
	return
end if

ls_window_id = 'w_pu01_00020'
ls_window_nm = '월 구매계획'

If ls_window_id = '' or isNull(ls_window_id) Then
	messagebox('','프로그램명이 없습니다.')
	return
End If

gs_code = '월 구매계획'
gs_codename = String(sYymm,'@@@@년 @@월 ') + '구매계획을 수립했습니다.'
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

type p_exit from w_inherite`p_exit within w_pu01_00020
integer x = 4379
integer y = 40
end type

type p_can from w_inherite`p_can within w_pu01_00020
integer x = 4206
integer y = 40
end type

event p_can::clicked;call super::clicked;rollback ;

wf_initial()
end event

type p_print from w_inherite`p_print within w_pu01_00020
boolean visible = false
integer x = 5047
integer y = 536
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_pu01_00020
integer x = 3858
integer y = 40
end type

event p_inq::clicked;call super::clicked;string	syymm, sgubun , scvcod, sitcls, sittyp
String   ls_confirm
Long     ll_cnt

dw_1.accepttext()
syymm = trim(dw_1.getitemstring(1,'yymm'))
if Isnull(syymm) or syymm = '' then
	f_message_chk(1400,'[계획년월]')
	return
end if

sgubun = trim(dw_1.getitemstring(1,'gubun'))
scvcod = trim(dw_1.getitemstring(1,'cvcod'))
If Isnull(scvcod) Then scvcod=''

sitcls = trim(dw_1.getitemstring(1,'itcls'))
If IsNull(sItcls) Then sItcls = ''

sittyp = trim(dw_1.getitemstring(1,'ittyp'))
If IsNull(sittyp) Then sittyp = ''

SELECT COUNT(*) Into :ll_cnt 
  FROM PU02_MONPLAN
  WHERE SABU = :gs_saupj
    AND YYMM = :syymm
	 AND WAIGB = '1' ;

If SQLCA.SQLCODE <> 0 or ll_cnt < 1 Then	
	dw_insert.SetRedraw(false)
	dw_insert.Reset()
	dw_insert.SetRedraw(True)
	f_message_chk(50,'월 구매계획')
	Return
End if

setpointer(hourglass!)
If dw_insert.Retrieve(gs_saupj,syymm,sgubun, sItcls+'%', scvcod+'%', sittyp+'%') <= 0 Then
	f_message_chk(50,'월 구매계획')
End If
end event

type p_del from w_inherite`p_del within w_pu01_00020
boolean visible = false
integer x = 4864
integer y = 536
end type

type p_mod from w_inherite`p_mod within w_pu01_00020
integer x = 4032
integer y = 40
end type

event p_mod::clicked;long	 lrow
String smagam

If dw_1.AcceptText() <> 1 Then Return
If dw_insert.AcceptText() <> 1 Then Return
If dw_insert.RowCount() <= 0 Then Return

smagam = dw_1.getitemstring(1,'cnfirm')
if smagam = 'Y' then
	messagebox("확인","마감처리된 자료입니다.")
	return
end if

if messagebox('확인','월 구매계획을 저장합니다.',question!,yesno!,1) = 2 then Return 

dw_insert.SetRedraw(False)

FOR lrow = dw_insert.rowcount() TO 1 STEP -1
	dw_insert.setitem(lrow,"amt_01",dw_insert.getitemnumber(lrow,"qty_01")*dw_insert.getitemnumber(lrow,"unprc"))
	dw_insert.setitem(lrow,"amt_02",dw_insert.getitemnumber(lrow,"qty_02")*dw_insert.getitemnumber(lrow,"unprc"))
	dw_insert.setitem(lrow,"amt_03",dw_insert.getitemnumber(lrow,"qty_03")*dw_insert.getitemnumber(lrow,"unprc"))
	dw_insert.setitem(lrow,"amt_04",dw_insert.getitemnumber(lrow,"qty_04")*dw_insert.getitemnumber(lrow,"unprc"))
	dw_insert.setitem(lrow,"amt_05",dw_insert.getitemnumber(lrow,"qty_05")*dw_insert.getitemnumber(lrow,"unprc"))

//	if dw_insert.getitemnumber(lrow,'sum_week') > 0 then continue
//	dw_insert.deleterow(lrow)
NEXT

dw_insert.SetRedraw(True)
	
setpointer(hourglass!)
dw_insert.AcceptText()
If dw_insert.Update() <> 1 Then
	RollBack;
	Return
End If

COMMIT;

messagebox('확인','월 구매계획을 저장하였습니다.')
end event

type cb_exit from w_inherite`cb_exit within w_pu01_00020
integer x = 3022
integer y = 2936
boolean enabled = false
end type

type cb_mod from w_inherite`cb_mod within w_pu01_00020
integer x = 709
integer y = 2936
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within w_pu01_00020
integer x = 347
integer y = 2936
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_pu01_00020
integer x = 1070
integer y = 2936
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_pu01_00020
integer x = 1431
integer y = 2936
boolean enabled = false
end type

type cb_print from w_inherite`cb_print within w_pu01_00020
integer x = 1792
integer y = 2936
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_pu01_00020
integer x = 59
integer y = 3148
end type

type cb_can from w_inherite`cb_can within w_pu01_00020
integer x = 2117
integer y = 2896
boolean enabled = false
end type

type cb_search from w_inherite`cb_search within w_pu01_00020
integer x = 2514
integer y = 2936
boolean enabled = false
end type

type dw_datetime from w_inherite`dw_datetime within w_pu01_00020
integer x = 2903
integer y = 3148
boolean enabled = false
end type

type sle_msg from w_inherite`sle_msg within w_pu01_00020
integer x = 411
integer y = 3148
boolean enabled = false
end type

type gb_10 from w_inherite`gb_10 within w_pu01_00020
integer x = 41
integer y = 3096
boolean enabled = false
end type

type gb_button1 from w_inherite`gb_button1 within w_pu01_00020
integer x = 1211
integer y = 3368
boolean enabled = false
end type

type gb_button2 from w_inherite`gb_button2 within w_pu01_00020
integer x = 1755
integer y = 3392
boolean enabled = false
end type

type rr_1 from roundrectangle within w_pu01_00020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 220
integer width = 4581
integer height = 1680
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pu01_00020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 8
integer width = 3113
integer height = 196
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_4 from datawindow within w_pu01_00020
boolean visible = false
integer x = 18
integer y = 2320
integer width = 1687
integer height = 472
integer taborder = 130
boolean bringtotop = true
boolean titlebar = true
string title = "월생산계획"
string dataobject = "d_pu01_00020_mrp"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_info from statictext within w_pu01_00020
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

type st_info2 from statictext within w_pu01_00020
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

type st_info1 from statictext within w_pu01_00020
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

type dw_6 from datawindow within w_pu01_00020
boolean visible = false
integer x = 2711
integer y = 2308
integer width = 1033
integer height = 460
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

type dw_3 from datawindow within w_pu01_00020
integer y = 1908
integer width = 4622
integer height = 372
integer taborder = 120
string title = "none"
string dataobject = "d_pu01_00020_3_t"
boolean border = false
boolean livescroll = true
end type

type dw_1 from u_key_enter within w_pu01_00020
integer x = 41
integer y = 20
integer width = 3077
integer height = 172
integer taborder = 11
string dataobject = "d_pu01_00020_1"
boolean border = false
end type

event itemchanged;call super::itemchanged;string	syymm, scnfirm, sm, sm1, sm2, s_empno, s_name, get_nm
Integer	ireturn

IF this.GetColumnName() = "cvcod" THEN
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
	
/* 품목분류 지정 */
ElseIF this.GetColumnName() = "itcls" THEN
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

ElseIF this.GetColumnName() = "yymm" THEN	
	syymm = trim(this.gettext())
	
	select substr(cnftime,1,8) into :scnfirm from pu02_monplan
	 where sabu = :gs_saupj and yymm = :syymm and waigb = '1'
		and cnftime is not null and rownum = 1 ;
	
	if sqlca.sqlcode = 0 then 
		this.setitem(1,'cnfirm','Y')
	else
		this.setitem(1,'cnfirm','N')
	end if
End If
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
end event

event itemerror;call super::itemerror;return 1
end event

type dw_41 from datawindow within w_pu01_00020
boolean visible = false
integer x = 1755
integer y = 2316
integer width = 901
integer height = 472
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "상품판매"
string dataobject = "d_pu01_00020_b"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean border = false
boolean livescroll = true
end type

type dw_7 from datawindow within w_pu01_00020
boolean visible = false
integer x = 4869
integer y = 992
integer width = 334
integer height = 148
integer taborder = 21
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
//	dw_insert.setsort("sabu A, yymm A, waigb A, itnbr A, cvcod A")
//	dw_insert.sort()
//	dw_insert.groupcalc()
//else
//	dw_insert.visible = false
//	dw_insert2.visible = true
//	
//	dw_insert2.setsort("sabu A, yymm A, waigb A, cvcod A, itnbr A")
//	dw_insert2.sort()
//	dw_insert2.groupcalc()
//end if
//
//dw_insert.setredraw(true)
//dw_insert2.setredraw(true)
end event

type p_1 from picture within w_pu01_00020
boolean visible = false
integer x = 4974
integer y = 752
integer width = 306
integer height = 144
boolean bringtotop = true
string picturename = "C:\erpman\image\이원화처리.gif"
boolean focusrectangle = false
end type

type dw_plan from datawindow within w_pu01_00020
boolean visible = false
integer x = 3817
integer y = 2308
integer width = 1033
integer height = 460
integer taborder = 60
boolean bringtotop = true
boolean titlebar = true
string title = "임시계획테이블"
string dataobject = "d_pu01_00020_c"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type rr_3 from roundrectangle within w_pu01_00020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2423
integer y = -872
integer width = 896
integer height = 204
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_4 from roundrectangle within w_pu01_00020
boolean visible = false
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 4814
integer y = 972
integer width = 370
integer height = 184
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_insert2 from datawindow within w_pu01_00020
event ue_pressenter pbm_dwnprocessenter
boolean visible = false
integer x = 4777
integer y = 976
integer width = 142
integer height = 148
integer taborder = 40
string title = "none"
string dataobject = "d_pu01_00020_2_m"
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

type cbx_jego from checkbox within w_pu01_00020
integer x = 3163
integer y = 132
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "재고적용"
boolean checked = true
end type

type dw_pdt from datawindow within w_pu01_00020
boolean visible = false
integer x = 14
integer y = 2312
integer width = 1266
integer height = 460
integer taborder = 160
boolean bringtotop = true
string title = "none"
string dataobject = "d_pu01_00020_d"
boolean border = false
boolean livescroll = true
end type

type cb_1 from commandbutton within w_pu01_00020
boolean visible = false
integer x = 3163
integer y = 28
integer width = 270
integer height = 84
integer taborder = 10
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "재계산"
end type

event clicked;///////////////////////////////////////////////////////////////////////////////////////////
dw_insert.setredraw(false)
wf_get_plan()				// 1.월생산계획 및 월판매계획(상품) READ
//wf_set_porate()			// 발주비율 적용 - 2004.01.06
wf_calc_needqty('1')		// 2.필요수량 계산
wf_calc_point2('1')		// 4.납입요청량 및 납입시점 결정 ( 용기량 有 )

//wf_set_qtp_org()			// 필요수량 원위치-2004.01.06
wf_set_orgqty()			// 5.초기 필요량 설정

dw_insert.setsort("sabu A, yymm A, waigb A, cvcod A, itnbr A")
dw_insert.sort()
dw_insert.groupcalc()
dw_insert.setredraw(true)
end event

type pb_1 from u_pb_cal within w_pu01_00020
integer x = 581
integer y = 24
integer taborder = 51
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_1.SetColumn('yymm')
IF IsNull(gs_code) THEN Return 
dw_1.SetItem(1, 'yymm', left(gs_code,6))
dw_1.triggerevent(itemchanged!)

//post wf_set_magamyn()
end event

type p_xls from picture within w_pu01_00020
integer x = 3511
integer y = 40
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "HyperLink!"
string picturename = "C:\erpman\image\엑셀변환_up.gif"
boolean focusrectangle = false
end type

event clicked;If this.Enabled Then wf_excel_down(dw_insert)
end event

