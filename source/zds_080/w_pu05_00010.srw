$PBExportHeader$w_pu05_00010.srw
$PBExportComments$** 월 외주계획 수립
forward
global type w_pu05_00010 from w_inherite
end type
type rr_1 from roundrectangle within w_pu05_00010
end type
type rr_2 from roundrectangle within w_pu05_00010
end type
type dw_4 from datawindow within w_pu05_00010
end type
type st_info from statictext within w_pu05_00010
end type
type st_info2 from statictext within w_pu05_00010
end type
type st_info1 from statictext within w_pu05_00010
end type
type dw_6 from datawindow within w_pu05_00010
end type
type dw_3 from datawindow within w_pu05_00010
end type
type dw_1 from u_key_enter within w_pu05_00010
end type
type dw_7 from datawindow within w_pu05_00010
end type
type p_1 from picture within w_pu05_00010
end type
type dw_plan from datawindow within w_pu05_00010
end type
type rr_3 from roundrectangle within w_pu05_00010
end type
type rr_4 from roundrectangle within w_pu05_00010
end type
type dw_insert2 from datawindow within w_pu05_00010
end type
type pb_1 from u_pb_cal within w_pu05_00010
end type
type p_xls from picture within w_pu05_00010
end type
type cbx_1 from checkbox within w_pu05_00010
end type
end forward

global type w_pu05_00010 from w_inherite
integer width = 5175
integer height = 2488
string title = "월 외주계획"
rr_1 rr_1
rr_2 rr_2
dw_4 dw_4
st_info st_info
st_info2 st_info2
st_info1 st_info1
dw_6 dw_6
dw_3 dw_3
dw_1 dw_1
dw_7 dw_7
p_1 p_1
dw_plan dw_plan
rr_3 rr_3
rr_4 rr_4
dw_insert2 dw_insert2
pb_1 pb_1
p_xls p_xls
cbx_1 cbx_1
end type
global w_pu05_00010 w_pu05_00010

type variables
str_itnct str_sitnct
end variables

forward prototypes
public subroutine wf_set_balqty ()
public subroutine wf_set_info (datawindow arg_dw, long arg_row)
public subroutine wf_set_weekqty ()
public function decimal wf_sum_napqty (datawindow arg_dw, string arg_itnbr)
public subroutine wf_set_orgqty ()
public subroutine wf_calc_point ()
public subroutine wf_calc_shrat ()
public subroutine wf_calc_needqty ()
public subroutine wf_initial ()
public subroutine wf_get_plan ()
public function integer wf_calc_mnapqty (string arg_fdate, string arg_tdate, string arg_itnbr)
public subroutine wf_excel_down (datawindow adw_excel)
end prototypes

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

public subroutine wf_set_info (datawindow arg_dw, long arg_row);string	sitnbr, scvcod
decimal	djego, dtotqty, dorgqty, dweekqty, dmonmax

if arg_row <= 0 then return

sitnbr = arg_dw.getitemstring(arg_row,'itnbr')
scvcod = arg_dw.getitemstring(arg_row,'cvcod')

djego   = arg_dw.getitemnumber(arg_row,'jgoqty')
dtotqty = arg_dw.getitemnumber(arg_row,'totqty')
dorgqty = arg_dw.getitemnumber(arg_row,'sum_orgqty')
dweekqty= arg_dw.getitemnumber(arg_row,'sum_week')
dmonmax = arg_dw.getitemnumber(arg_row,'monmax')

if dw_3.retrieve(sitnbr,scvcod) < 1 then return

dw_3.setitem(1,'jegoqty',djego)
dw_3.setitem(1,'totqty',dtotqty)
dw_3.setitem(1,'patqty',dorgqty)
//dw_3.setitem(1,'chgqty',dweekqty)
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

public subroutine wf_set_orgqty ();long		lrow


FOR lrow = 1 TO dw_insert.rowcount()
	dw_insert.setitem(lrow,'sum_orgqty',dw_insert.getitemnumber(lrow,'sum_week'))
NEXT
end subroutine

public subroutine wf_calc_point ();long	lrow
long	lot, lcnt, lsum, lneed, lrest, lotsum
long	lqty1, lqty2, lqty3, lqty4, lqty5


FOR lrow = 1 TO dw_insert.rowcount()
	//====================================================================
	lot  = dw_insert.getitemnumber(lrow,'minqt')
	lsum = dw_insert.getitemnumber(lrow,'sum_week')
	lcnt = dw_insert.getitemnumber(lrow,'moncnt')
	
	if lot > 0 then
		lotsum = ceiling(lsum/lot)*lot
	else
		lot = lsum
		lotsum = lsum
	end if
	
	
	
	//====================================================================
	lqty1 = dw_insert.getitemnumber(lrow,'qty_01')
	lneed = ceiling(lqty1/lot)*lot
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
		lneed = ceiling(lqty2/lot)*lot
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
		lneed = ceiling(lqty3/lot)*lot
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
		lneed = ceiling(lqty4/lot)*lot
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
	dw_insert.setitem(lrow,'qty_05',lotsum)
NEXT
end subroutine

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

public subroutine wf_calc_needqty ();long		lrow
decimal	djego, dminsaf, dqtp_01, dqtp_02, dqtp_03, dqtp_04, dqtp_05, dneed


// 필요수량 계산
FOR lrow = 1 TO dw_insert.rowcount()
	djego 	= dw_insert.getitemnumber(lrow,'jgoqty')
	dminsaf	= dw_insert.getitemnumber(lrow,'minsaf')
	dqtp_01	= dw_insert.getitemnumber(lrow,'qtp_01')
	dqtp_02	= dw_insert.getitemnumber(lrow,'qtp_02')
	dqtp_03	= dw_insert.getitemnumber(lrow,'qtp_03')
	dqtp_04	= dw_insert.getitemnumber(lrow,'qtp_04')
	dqtp_05	= dw_insert.getitemnumber(lrow,'qtp_05')
	
	If cbx_1.Checked = True Then
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
	Else
		dw_insert.setitem(lrow,'qty_01',dqtp_01)
		dw_insert.setitem(lrow,'qty_02',dqtp_02)
		dw_insert.setitem(lrow,'qty_03',dqtp_03)
		dw_insert.setitem(lrow,'qty_04',dqtp_04)
		dw_insert.setitem(lrow,'qty_05',dqtp_05)
	End If
NEXT
end subroutine

public subroutine wf_initial ();dw_1.ReSet()
dw_3.ReSet()
dw_plan.ReSet()
dw_insert.ReSet()
dw_insert2.ReSet()

dw_1.InsertRow(0)
dw_3.InsertRow(0)

string	smaxyymm

select max(yymm) into :smaxyymm from pu02_monplan
 where waigb = '2' ;
if isnull(smaxyymm) or smaxyymm = '' then
	dw_1.Object.yymm[1] = Left(f_today(),6)
else	
	dw_1.Object.yymm[1] = smaxyymm
end if
dw_1.postevent(itemchanged!)

dw_1.setfocus()
end subroutine

public subroutine wf_get_plan ();long		lrow1, lrow2, lrow3, lrow4, lrow5, lfrow, lirow, lvlno, lprlvl
long		lrowcnt1, lrowcnt2, lrowcnt3, lrowcnt4, lrowcnt5 ,i
decimal	dqtypr, dunprc, dpalqty, dmonmax, dporate, dmoncnt, dmidsaf
decimal	dm01, dm02, dm03, dm04, dm05, dm06, dm07, dm08, dm09, dm10, dm11, dm12, djego, dcjego, dshrat, dldtim2
decimal  dqty_pre , dqtp_pre
string	srinbr, srtype, sittyp, sitgu, scvcod ,scvnas, syymm, sitdsc, sjasa
string	sfdate, stdate

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
	if lrowcnt4 < 1 then
		scvcod  = sjasa			
	//	dmonmax = dw_6.getitemnumber(1,'monmax')        // 월최대 발주량 
	//	dporate = dw_6.getitemnumber(1,'porate')        // 업체 발주비율 
		dporate = 1.0
		dmoncnt = 1       // 업체 납입횟수
		dunprc  = 0        // 단가 
	else
		scvcod  = dw_6.getitemstring(1,'cvcod')			
	//	dmonmax = dw_6.getitemnumber(1,'monmax')        // 월최대 발주량 
	//	dporate = dw_6.getitemnumber(1,'porate')        // 업체 발주비율 
		dporate = 1.0
		dmoncnt = dw_6.getitemnumber(1,'moncnt')        // 업체 납입횟수
		dunprc  = dw_6.getitemnumber(1,'unprc')         // 단가 
	end if
			
	lirow = dw_insert.insertrow(0)
			
	dw_insert.setitem(lirow,"sabu",gs_saupj)
	dw_insert.setitem(lirow,"yymm",syymm)
	dw_insert.setitem(lirow,"waigb",'2')
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
	dw_insert.setitem(lirow,"minsaf",dmidsaf)
	
	dw_insert.setitem(lirow,"qtp_01",dm01)
	dw_insert.setitem(lirow,"qtp_02",dm02)
	dw_insert.setitem(lirow,"qtp_03",dm03)
	dw_insert.setitem(lirow,"qtp_04",dm04)
	dw_insert.setitem(lirow,"qtp_05",dm05)
	dw_insert.setitem(lirow,"qtp_06",dm06)
	
	// 생산계획을 그대로 가져온다.
	dw_insert.setitem(lirow,"qty_01",dm01)
	dw_insert.setitem(lirow,"qty_02",dm02)
	dw_insert.setitem(lirow,"qty_03",dm03)
	dw_insert.setitem(lirow,"qty_04",dm04)
	dw_insert.setitem(lirow,"qty_05",dm05)
	dw_insert.setitem(lirow,"qty_06",dm06)
	
	dw_insert.setitem(lirow,"qty_m1",dm07)
	dw_insert.setitem(lirow,"qty_m2",dm08)
	
	if lrowcnt4 > 1 then dw_insert.setitem(lirow,"cvdbl",'Y') // 이원화 표시		
NEXT


st_info.visible = false
st_info1.visible = false
st_info2.visible = false
end subroutine

public function integer wf_calc_mnapqty (string arg_fdate, string arg_tdate, string arg_itnbr);// 월최대납품량을 계산한다. =================================================
decimal	dmaxqty

select nvl(max(a.qty),0)
  into :dmaxqty
  from ( select substr(io_date,1,6) as yymm,
					 sum(ioqty) as qty
			  from imhist
			 where sabu = :gs_sabu
				and io_date between :arg_fdate and :arg_tdate
				and iogbn = 'I01'
				and saupj = :gs_saupj
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

on w_pu05_00010.create
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
this.dw_7=create dw_7
this.p_1=create p_1
this.dw_plan=create dw_plan
this.rr_3=create rr_3
this.rr_4=create rr_4
this.dw_insert2=create dw_insert2
this.pb_1=create pb_1
this.p_xls=create p_xls
this.cbx_1=create cbx_1
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
this.Control[iCurrent+10]=this.dw_7
this.Control[iCurrent+11]=this.p_1
this.Control[iCurrent+12]=this.dw_plan
this.Control[iCurrent+13]=this.rr_3
this.Control[iCurrent+14]=this.rr_4
this.Control[iCurrent+15]=this.dw_insert2
this.Control[iCurrent+16]=this.pb_1
this.Control[iCurrent+17]=this.p_xls
this.Control[iCurrent+18]=this.cbx_1
end on

on w_pu05_00010.destroy
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
destroy(this.dw_7)
destroy(this.p_1)
destroy(this.dw_plan)
destroy(this.rr_3)
destroy(this.rr_4)
destroy(this.dw_insert2)
destroy(this.pb_1)
destroy(this.p_xls)
destroy(this.cbx_1)
end on

event open;call super::open;dw_1.SetTransObject(sqlca)
dw_3.SetTransObject(sqlca)
dw_4.SetTransObject(sqlca)
dw_6.SetTransObject(sqlca)
dw_plan.SetTransObject(sqlca)
dw_insert.SetTransObject(sqlca)
dw_insert2.SetTransObject(sqlca)

wf_initial()
end event

type dw_insert from w_inherite`dw_insert within w_pu05_00010
integer x = 23
integer y = 228
integer width = 4562
integer height = 1664
string dataobject = "d_pu05_00010_m"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemerror;call super::itemerror;return 1
end event

event dw_insert::rowfocuschanged;call super::rowfocuschanged;this.selectrow(0,false)
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
end event

event dw_insert::clicked;call super::clicked;this.selectrow(0,false)
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

type p_delrow from w_inherite`p_delrow within w_pu05_00010
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

type p_addrow from w_inherite`p_addrow within w_pu05_00010
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

type p_search from w_inherite`p_search within w_pu05_00010
string tag = "MRP"
integer x = 3643
integer y = 40
string picturename = "C:\erpman\image\MRP_up.gif"
end type

event p_search::clicked;string	syymm ,syymm_pre, stemp, smagam 
long     ll_confirm

dw_1.accepttext()

syymm = trim(dw_1.getitemstring(1,'yymm'))
if Isnull(syymm) or syymm = '' then
	f_message_chk(1400,'[계획년월]')
	return
end if

smagam = dw_1.getitemstring(1,'cnfirm')
if smagam = 'Y' then
	messagebox("확인","확정처리된 자료입니다.")
	return
end if

select yymm into :stemp from PU02_MONPLAN_SUM
 where sabu = :gs_saupj and yymm = :syymm and waigb = '2' and rownum = 1 ;
if sqlca.sqlcode <> 0 then
	messagebox('확인',syymm + '월 생산계획이 없습니다')
	return
end if

select yymm into :syymm 
  from pu02_monplan
 where sabu = :gs_saupj 
   and yymm = :syymm 
	and waigb = '2'
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
		  and waigb = '2' ;
If sqlca.sqlcode <> 0 Then
	Rollback;
	dw_insert.Reset()
	MessageBox('ERROR','MRP 작성 중 에러가 발생했습니다. DB 에러 ')
	Return
End If
//===========================================================================



///////////////////////////////////////////////////////////////////////////////////////////
dw_insert.setredraw(false)
wf_get_plan()			// 1.월생산계획 READ
wf_calc_needqty()		// 2.필요수량 계산

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

type p_ins from w_inherite`p_ins within w_pu05_00010
string tag = "조정"
boolean visible = false
integer x = 4622
integer y = 532
string picturename = "C:\erpman\image\메일전송_up.gif"
end type

event p_ins::clicked;call super::clicked;//String	ls_window_id , ls_window_nm, syymm
//
//dw_1.accepttext()
//
//syymm = trim(dw_1.getitemstring(1,'yymm'))
//if Isnull(syymm) or syymm = '' then
//	f_message_chk(1400,'[계획년월]')
//	return
//end if
//
//ls_window_id = 'w_pu05_00010'
//ls_window_nm = '월 외주계획'
//
//If ls_window_id = '' or isNull(ls_window_id) Then
//	messagebox('','프로그램명이 없습니다.')
//	return
//End If
//
//gs_code = '월 외주계획'
//gs_codename = String(sYymm,'@@@@년 @@월 ') + '외주계획을 수립했습니다.'
//OpenWithParm(w_mailsend_popup , ls_window_id + Space(100) + ls_window_nm)
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

type p_exit from w_inherite`p_exit within w_pu05_00010
integer x = 4338
integer y = 40
end type

type p_can from w_inherite`p_can within w_pu05_00010
integer x = 4165
integer y = 40
end type

event p_can::clicked;call super::clicked;rollback ;

wf_initial()
end event

type p_print from w_inherite`p_print within w_pu05_00010
boolean visible = false
integer x = 5047
integer y = 536
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_pu05_00010
integer x = 3817
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
	 AND WAIGB = '2' ;

If SQLCA.SQLCODE <> 0 or ll_cnt < 1 Then	
	dw_insert.SetRedraw(false)
	dw_insert.Reset()
	dw_insert.SetRedraw(True)
	f_message_chk(50,'월 외주계획')
	Return
End if

setpointer(hourglass!)
If dw_insert.Retrieve(gs_saupj,syymm,sgubun, sItcls+'%', scvcod+'%', sittyp+'%') <= 0 Then
	f_message_chk(50,'월 외주계획')
End If
end event

type p_del from w_inherite`p_del within w_pu05_00010
boolean visible = false
integer x = 4864
integer y = 536
end type

type p_mod from w_inherite`p_mod within w_pu05_00010
integer x = 3991
integer y = 40
end type

event p_mod::clicked;long	 lrow
String smagam

If dw_1.AcceptText() <> 1 Then Return
If dw_insert.AcceptText() <> 1 Then Return
If dw_insert.RowCount() <= 0 Then Return

smagam = dw_1.getitemstring(1,'cnfirm')
if smagam = 'Y' then
	messagebox("확인","확정처리된 자료입니다.")
	return
end if

if messagebox('확인','월 외주계획을 저장합니다.',question!,yesno!,1) = 2 then Return 

FOR lrow = dw_insert.rowcount() TO 1 STEP -1
	dw_insert.setitem(lrow,"amt_01",dw_insert.getitemnumber(lrow,"qty_01")*dw_insert.getitemnumber(lrow,"unprc"))
	dw_insert.setitem(lrow,"amt_02",dw_insert.getitemnumber(lrow,"qty_02")*dw_insert.getitemnumber(lrow,"unprc"))
	dw_insert.setitem(lrow,"amt_03",dw_insert.getitemnumber(lrow,"qty_03")*dw_insert.getitemnumber(lrow,"unprc"))
	dw_insert.setitem(lrow,"amt_04",dw_insert.getitemnumber(lrow,"qty_04")*dw_insert.getitemnumber(lrow,"unprc"))
	dw_insert.setitem(lrow,"amt_05",dw_insert.getitemnumber(lrow,"qty_05")*dw_insert.getitemnumber(lrow,"unprc"))
	dw_insert.setitem(lrow,"amt_06",dw_insert.getitemnumber(lrow,"qty_06")*dw_insert.getitemnumber(lrow,"unprc"))

//	if dw_insert.getitemnumber(lrow,'sum_week') > 0 then continue
//	dw_insert.deleterow(lrow)
NEXT
	
setpointer(hourglass!)
dw_insert.AcceptText()
If dw_insert.Update() <> 1 Then
	RollBack;
	Return
End If

COMMIT;

messagebox('확인','월 외주계획을 저장하였습니다.')
end event

type cb_exit from w_inherite`cb_exit within w_pu05_00010
integer x = 3022
integer y = 2936
boolean enabled = false
end type

type cb_mod from w_inherite`cb_mod within w_pu05_00010
integer x = 709
integer y = 2936
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within w_pu05_00010
integer x = 347
integer y = 2936
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_pu05_00010
integer x = 1070
integer y = 2936
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_pu05_00010
integer x = 1431
integer y = 2936
boolean enabled = false
end type

type cb_print from w_inherite`cb_print within w_pu05_00010
integer x = 1792
integer y = 2936
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_pu05_00010
integer x = 59
integer y = 3148
end type

type cb_can from w_inherite`cb_can within w_pu05_00010
integer x = 2117
integer y = 2896
boolean enabled = false
end type

type cb_search from w_inherite`cb_search within w_pu05_00010
integer x = 2514
integer y = 2936
boolean enabled = false
end type

type dw_datetime from w_inherite`dw_datetime within w_pu05_00010
integer x = 2903
integer y = 3148
boolean enabled = false
end type

type sle_msg from w_inherite`sle_msg within w_pu05_00010
integer x = 411
integer y = 3148
boolean enabled = false
end type

type gb_10 from w_inherite`gb_10 within w_pu05_00010
integer x = 41
integer y = 3096
boolean enabled = false
end type

type gb_button1 from w_inherite`gb_button1 within w_pu05_00010
integer x = 1211
integer y = 3368
boolean enabled = false
end type

type gb_button2 from w_inherite`gb_button2 within w_pu05_00010
integer x = 1755
integer y = 3392
boolean enabled = false
end type

type rr_1 from roundrectangle within w_pu05_00010
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

type rr_2 from roundrectangle within w_pu05_00010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 4
integer width = 3287
integer height = 200
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_4 from datawindow within w_pu05_00010
boolean visible = false
integer x = 32
integer y = 2340
integer width = 1687
integer height = 500
integer taborder = 130
boolean bringtotop = true
boolean titlebar = true
string title = "월생산계획"
string dataobject = "d_pu05_00010_mrp"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_info from statictext within w_pu05_00010
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

type st_info2 from statictext within w_pu05_00010
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

type st_info1 from statictext within w_pu05_00010
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

type dw_6 from datawindow within w_pu05_00010
boolean visible = false
integer x = 2711
integer y = 2340
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

type dw_3 from datawindow within w_pu05_00010
integer y = 1908
integer width = 4622
integer height = 372
integer taborder = 120
string title = "none"
string dataobject = "d_pu05_00010_3"
boolean border = false
boolean livescroll = true
end type

type dw_1 from u_key_enter within w_pu05_00010
integer x = 82
integer y = 20
integer width = 2894
integer height = 172
integer taborder = 11
string dataobject = "d_pu05_00010_1"
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
	 where sabu = :gs_saupj and yymm = :syymm and waigb = '2'
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

type dw_7 from datawindow within w_pu05_00010
boolean visible = false
integer x = 4805
integer y = 284
integer width = 187
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

type p_1 from picture within w_pu05_00010
boolean visible = false
integer x = 4974
integer y = 752
integer width = 306
integer height = 144
boolean bringtotop = true
string picturename = "C:\erpman\image\이원화처리.gif"
boolean focusrectangle = false
end type

type dw_plan from datawindow within w_pu05_00010
boolean visible = false
integer x = 3817
integer y = 2340
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

type rr_3 from roundrectangle within w_pu05_00010
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

type rr_4 from roundrectangle within w_pu05_00010
boolean visible = false
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 4718
integer y = 264
integer width = 366
integer height = 184
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_insert2 from datawindow within w_pu05_00010
event ue_pressenter pbm_dwnprocessenter
boolean visible = false
integer x = 4672
integer y = 240
integer width = 133
integer height = 148
integer taborder = 40
string title = "none"
string dataobject = "d_pu05_00010_a"
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

type pb_1 from u_pb_cal within w_pu05_00010
integer x = 626
integer y = 20
integer taborder = 61
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_1.SetColumn('yymm')
IF IsNull(gs_code) THEN Return 
dw_1.SetItem(1, 'yymm', left(gs_code,6))
dw_1.triggerevent(itemchanged!)

//post wf_set_magamyn()
end event

type p_xls from picture within w_pu05_00010
integer x = 3424
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

type cbx_1 from checkbox within w_pu05_00010
integer x = 2862
integer y = 116
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

