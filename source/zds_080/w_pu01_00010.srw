$PBExportHeader$w_pu01_00010.srw
$PBExportComments$** 년 구매계획
forward
global type w_pu01_00010 from w_inherite
end type
type dw_1 from u_key_enter within w_pu01_00010
end type
type dw_2 from datawindow within w_pu01_00010
end type
type dw_3 from datawindow within w_pu01_00010
end type
type dw_4 from datawindow within w_pu01_00010
end type
type dw_5 from datawindow within w_pu01_00010
end type
type dw_6 from datawindow within w_pu01_00010
end type
type st_info from statictext within w_pu01_00010
end type
type st_info2 from statictext within w_pu01_00010
end type
type rr_1 from roundrectangle within w_pu01_00010
end type
type rr_2 from roundrectangle within w_pu01_00010
end type
type st_info1 from statictext within w_pu01_00010
end type
type dw_7 from datawindow within w_pu01_00010
end type
type dw_8 from datawindow within w_pu01_00010
end type
type dw_insert2 from datawindow within w_pu01_00010
end type
type dw_9 from datawindow within w_pu01_00010
end type
type cb_1 from commandbutton within w_pu01_00010
end type
type rr_3 from roundrectangle within w_pu01_00010
end type
end forward

global type w_pu01_00010 from w_inherite
integer width = 4622
integer height = 2456
string title = "년 구매 계획"
dw_1 dw_1
dw_2 dw_2
dw_3 dw_3
dw_4 dw_4
dw_5 dw_5
dw_6 dw_6
st_info st_info
st_info2 st_info2
rr_1 rr_1
rr_2 rr_2
st_info1 st_info1
dw_7 dw_7
dw_8 dw_8
dw_insert2 dw_insert2
dw_9 dw_9
cb_1 cb_1
rr_3 rr_3
end type
global w_pu01_00010 w_pu01_00010

forward prototypes
public subroutine wf_set_minqt ()
public subroutine wf_set_orgqty ()
public subroutine wf_initial ()
public subroutine wf_history (datawindow arg_dw, long arg_row)
public subroutine wf_set_monmax ()
public subroutine wf_calc_point2 (string arg_seqno)
public subroutine wf_get_plan ()
public function integer wf_calc_sagub ()
public subroutine wf_set_qtp_org ()
public subroutine wf_set_porate ()
public subroutine wf_calc_point (string arg_seqno)
end prototypes

public subroutine wf_set_minqt ();long		lrow
decimal	dminqt

dw_insert.accepttext()


////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 용기량 적용
FOR lrow = 1 TO dw_insert.rowcount()
	dminqt = dw_insert.getitemnumber(lrow,"pu01_yearplan_minqt")
	
	if dminqt > 0 then
		dw_insert.setitem(lrow,"pu01_yearplan_qty_01",ceiling(dw_insert.getitemnumber(lrow,"pu01_yearplan_qty_01")/dminqt)*dminqt)
	else
		dw_insert.setitem(lrow,"pu01_yearplan_qty_01",dw_insert.getitemnumber(lrow,"pu01_yearplan_qty_01"))
	end if
	
	if dminqt > 0 then
		dw_insert.setitem(lrow,"pu01_yearplan_qty_02",ceiling(dw_insert.getitemnumber(lrow,"pu01_yearplan_qty_02")/dminqt)*dminqt)
	else
		dw_insert.setitem(lrow,"pu01_yearplan_qty_02",dw_insert.getitemnumber(lrow,"pu01_yearplan_qty_02"))
	end if
	
	if dminqt > 0 then
		dw_insert.setitem(lrow,"pu01_yearplan_qty_03",ceiling(dw_insert.getitemnumber(lrow,"pu01_yearplan_qty_03")/dminqt)*dminqt)
	else
		dw_insert.setitem(lrow,"pu01_yearplan_qty_03",dw_insert.getitemnumber(lrow,"pu01_yearplan_qty_03"))
	end if
	
	if dminqt > 0 then
		dw_insert.setitem(lrow,"pu01_yearplan_qty_04",ceiling(dw_insert.getitemnumber(lrow,"pu01_yearplan_qty_04")/dminqt)*dminqt)
	else
		dw_insert.setitem(lrow,"pu01_yearplan_qty_04",dw_insert.getitemnumber(lrow,"pu01_yearplan_qty_04"))
	end if
	
	if dminqt > 0 then
		dw_insert.setitem(lrow,"pu01_yearplan_qty_05",ceiling(dw_insert.getitemnumber(lrow,"pu01_yearplan_qty_05")/dminqt)*dminqt)
	else
		dw_insert.setitem(lrow,"pu01_yearplan_qty_05",dw_insert.getitemnumber(lrow,"pu01_yearplan_qty_05"))
	end if
	
	if dminqt > 0 then
		dw_insert.setitem(lrow,"pu01_yearplan_qty_06",ceiling(dw_insert.getitemnumber(lrow,"pu01_yearplan_qty_06")/dminqt)*dminqt)
	else
		dw_insert.setitem(lrow,"pu01_yearplan_qty_06",dw_insert.getitemnumber(lrow,"pu01_yearplan_qty_06"))
	end if
	
	if dminqt > 0 then
		dw_insert.setitem(lrow,"pu01_yearplan_qty_07",ceiling(dw_insert.getitemnumber(lrow,"pu01_yearplan_qty_07")/dminqt)*dminqt)
	else
		dw_insert.setitem(lrow,"pu01_yearplan_qty_07",dw_insert.getitemnumber(lrow,"pu01_yearplan_qty_07"))
	end if
	
	if dminqt > 0 then
		dw_insert.setitem(lrow,"pu01_yearplan_qty_08",ceiling(dw_insert.getitemnumber(lrow,"pu01_yearplan_qty_08")/dminqt)*dminqt)
	else
		dw_insert.setitem(lrow,"pu01_yearplan_qty_08",dw_insert.getitemnumber(lrow,"pu01_yearplan_qty_08"))
	end if
	
	if dminqt > 0 then
		dw_insert.setitem(lrow,"pu01_yearplan_qty_09",ceiling(dw_insert.getitemnumber(lrow,"pu01_yearplan_qty_09")/dminqt)*dminqt)
	else
		dw_insert.setitem(lrow,"pu01_yearplan_qty_09",dw_insert.getitemnumber(lrow,"pu01_yearplan_qty_09"))
	end if
	
	if dminqt > 0 then
		dw_insert.setitem(lrow,"pu01_yearplan_qty_10",ceiling(dw_insert.getitemnumber(lrow,"pu01_yearplan_qty_10")/dminqt)*dminqt)
	else
		dw_insert.setitem(lrow,"pu01_yearplan_qty_10",dw_insert.getitemnumber(lrow,"pu01_yearplan_qty_10"))
	end if
	
	if dminqt > 0 then
		dw_insert.setitem(lrow,"pu01_yearplan_qty_11",ceiling(dw_insert.getitemnumber(lrow,"pu01_yearplan_qty_11")/dminqt)*dminqt)
	else
		dw_insert.setitem(lrow,"pu01_yearplan_qty_11",dw_insert.getitemnumber(lrow,"pu01_yearplan_qty_11"))
	end if
	
	if dminqt > 0 then
		dw_insert.setitem(lrow,"pu01_yearplan_qty_12",ceiling(dw_insert.getitemnumber(lrow,"pu01_yearplan_qty_12")/dminqt)*dminqt)
	else
		dw_insert.setitem(lrow,"pu01_yearplan_qty_12",dw_insert.getitemnumber(lrow,"pu01_yearplan_qty_12"))
	end if
NEXT


// 총량보존
FOR lrow = 1 TO dw_insert.rowcount()
	dw_insert.setitem(lrow,"sum_orgqty",dw_insert.getitemnumber(lrow,"sum_vndqty"))
NEXT
end subroutine

public subroutine wf_set_orgqty ();long		lrow

FOR lrow = 1 TO dw_insert.rowcount()
	dw_insert.setitem(lrow,'sum_orgqty',dw_insert.getitemnumber(lrow,'sum_vndqty'))
NEXT
end subroutine

public subroutine wf_initial ();dw_insert.ReSet()
dw_insert2.ReSet()
dw_3.ReSet()
dw_4.ReSet()
dw_5.ReSet()
dw_6.ReSet()
dw_8.ReSet()
dw_9.ReSet()

dw_1.InsertRow(0)
dw_3.InsertRow(0)

string	smaxyyyy

select max(yyyy) into :smaxyyyy from pu01_yearplan ;
if isnull(smaxyyyy) or smaxyyyy = '' then
	dw_1.Object.yyyy[1] = Left(f_today(),4)
else	
	dw_1.Object.yyyy[1] = smaxyyyy
end if
dw_1.postevent(itemchanged!)

dw_1.setfocus()
end subroutine

public subroutine wf_history (datawindow arg_dw, long arg_row);string	ssabu, syyyy, sitnbr, scvcod, scol, smaxcol01, smaxcol02, smaxcol03
decimal	dmaxqty01, dmaxqty02, dmaxqty03, dtmpqty, dtotqty, dorgqty, dvndqty
integer	i

if arg_row <= 0 then return

ssabu  = arg_dw.getitemstring(arg_row,'pu01_yearplan_sabu')
syyyy  = string(integer(arg_dw.getitemstring(arg_row,'pu01_yearplan_yyyy')) - 1)
sitnbr = arg_dw.getitemstring(arg_row,'pu01_yearplan_itnbr')
scvcod = arg_dw.getitemstring(arg_row,'pu01_yearplan_cvcod')
dtotqty= arg_dw.getitemnumber(arg_row,'sum_totqty')
dorgqty= arg_dw.getitemnumber(arg_row,'sum_orgqty')
dvndqty= arg_dw.getitemnumber(arg_row,'sum_vndqty')

if dw_3.retrieve(ssabu,syyyy,sitnbr,scvcod,gs_saupj) < 1 then return


////////////////////////////////////////////////////////////////////////////////////////////
FOR i = 1 TO 12
	scol = 'qty_'+string(i,'00')
	dtmpqty = dw_3.getitemnumber(1,scol)
	if dmaxqty01 <= dtmpqty then 
		smaxcol01 = scol
		dmaxqty01 = dtmpqty
	end if
	dw_3.modify(scol+".color=0")
NEXT
FOR i = 1 TO 12
	scol = 'qty_'+string(i,'00')
	dtmpqty = dw_3.getitemnumber(1,scol)
	if smaxcol01 = scol then continue
	if dmaxqty02 <= dtmpqty then
		smaxcol02 = scol
		dmaxqty02 = dtmpqty
	end if
NEXT
FOR i = 1 TO 12
	scol = 'qty_'+string(i,'00')
	dtmpqty = dw_3.getitemnumber(1,scol)
	if smaxcol01 = scol or smaxcol02 = scol then continue
	if dmaxqty03 <= dtmpqty then 
		smaxcol03 = scol
		dmaxqty03 = dtmpqty 
	end if
NEXT

dw_3.modify(smaxcol01+".color=255")
dw_3.modify(smaxcol02+".color=255")
dw_3.modify(smaxcol03+".color=255")

dw_3.setitem(1,'totqty',dtotqty)
dw_3.setitem(1,'patqty',dorgqty)
dw_3.setitem(1,'chgqty',dvndqty)
dw_3.setitem(1,'maxqty',dmaxqty01)
arg_dw.setitem(arg_row,'pu01_yearplan_monmax',dmaxqty01)
dw_3.setitem(1,'avgqty',ceiling((dmaxqty01+dmaxqty01+dmaxqty03)/3))
end subroutine

public subroutine wf_set_monmax ();long		lrow
string	syyyy, sitnbr, scvcod


dw_insert.accepttext()
syyyy = string(integer(dw_1.getitemstring(1,'yyyy')) - 1)

FOR lrow = 1 TO dw_insert.rowcount()	
	sitnbr = dw_insert.getitemstring(lrow,'pu01_yearplan_itnbr')
	scvcod = dw_insert.getitemstring(lrow,'pu01_yearplan_cvcod')
	
	if dw_8.retrieve(gs_saupj,syyyy,sitnbr,scvcod) > 0 then
		dw_insert.setitem(lrow,"pu01_yearplan_monmax",dw_8.getitemnumber(1,'monmax'))
	end if
NEXT
end subroutine

public subroutine wf_calc_point2 (string arg_seqno);long		i, lrow
long		lot, lcnt, lsum, lsetsum, lneed, lrest, lotsum
long		lqty1, lqty2, lqty3, lqty4, lqty5, lqty6, lqty7, lqty8, lqty9, lqty10, lqty11, lqty12


// 용기량이 지정되지 않은 자료만 처리 - 필요량=계획량

FOR lrow = 1 TO dw_insert.rowcount()
	if dw_insert.getitemstring(lrow,'seqno') <> arg_seqno then continue
	
	//====================================================================
	lot = dw_insert.getitemnumber(lrow,'pu01_yearplan_minqt')
	if lot > 0 then continue
	

	//====================================================================
	lqty1 = dw_insert.getitemnumber(lrow,'pu01_yearplan_qtp_01')
	dw_insert.setitem(lrow,'pu01_yearplan_qty_01',lqty1)

	lqty2 = dw_insert.getitemnumber(lrow,'pu01_yearplan_qtp_02')
	dw_insert.setitem(lrow,'pu01_yearplan_qty_02',lqty2)

	lqty3 = dw_insert.getitemnumber(lrow,'pu01_yearplan_qtp_03')
	dw_insert.setitem(lrow,'pu01_yearplan_qty_03',lqty3)

	lqty4 = dw_insert.getitemnumber(lrow,'pu01_yearplan_qtp_04')
	dw_insert.setitem(lrow,'pu01_yearplan_qty_04',lqty4)

	lqty5 = dw_insert.getitemnumber(lrow,'pu01_yearplan_qtp_05')
	dw_insert.setitem(lrow,'pu01_yearplan_qty_05',lqty5)

	lqty6 = dw_insert.getitemnumber(lrow,'pu01_yearplan_qtp_06')
	dw_insert.setitem(lrow,'pu01_yearplan_qty_06',lqty6)

	lqty7 = dw_insert.getitemnumber(lrow,'pu01_yearplan_qtp_07')
	dw_insert.setitem(lrow,'pu01_yearplan_qty_07',lqty7)

	lqty8 = dw_insert.getitemnumber(lrow,'pu01_yearplan_qtp_08')
	dw_insert.setitem(lrow,'pu01_yearplan_qty_08',lqty8)

	lqty9 = dw_insert.getitemnumber(lrow,'pu01_yearplan_qtp_09')
	dw_insert.setitem(lrow,'pu01_yearplan_qty_09',lqty9)

	lqty10 = dw_insert.getitemnumber(lrow,'pu01_yearplan_qtp_10')
	dw_insert.setitem(lrow,'pu01_yearplan_qty_10',lqty10)

	lqty11 = dw_insert.getitemnumber(lrow,'pu01_yearplan_qtp_11')
	dw_insert.setitem(lrow,'pu01_yearplan_qty_11',lqty11)

	lqty12 = dw_insert.getitemnumber(lrow,'pu01_yearplan_qtp_12')
	dw_insert.setitem(lrow,'pu01_yearplan_qty_12',lqty12)

NEXT
end subroutine

public subroutine wf_get_plan ();long		lrow1, lrow2, lrow3, lrow4, lrow5, lfrow1, lfrow2, lirow, lvlno, lprlvl, i
long		lrowcnt1, lrowcnt2, lrowcnt3, lrowcnt4, lrowcnt5
decimal	dqtypr, dunprc, dpalqty, dmonmax, dporate
decimal	dm01, dm02, dm03, dm04, dm05, dm06, dm07, dm08, dm09, dm10, dm11, dm12
string	syyyy, srinbr, srtype, scinbr, scidsc, sittyp, sitgu, scvcod, scvnas, skipnbr, sjasa
string	spinbr, swaiyn, suseyn, swaitnbr


//////////////////////////////////////////////////////////////////////////////////////////////
syyyy = dw_1.getitemstring(1,'yyyy')
lrowcnt1 = dw_4.retrieve(gs_saupj,syyyy)
if lrowcnt1 < 1 then
	messagebox("확인",syyyy+" 년 판매계획이 정의되지 않았습니다.")
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

//////////////////////////////////////////////////////////////////////////////////////////////
// 제품계획 READ
FOR lrow1 = 1 TO lrowcnt1
	srinbr = dw_4.getitemstring(lrow1,'itnbr')
	srtype = dw_4.getitemstring(lrow1,'ittyp')
	
//	// 상품인 경우 skip - 2003.11.24
//	select a.itnbr 
//	  into :scinbr 
//	  from item_rel a,
//	  		 itemas   b
//	 where a.itnbryd = :srinbr
//	   and a.itnbr = b.itnbr
//		and b.useyn = '0' ;
//	if sqlca.sqlcode = 0 then continue
	
	st_info1.text = '자재 소요량 계산 :'
	st_info2.text = srinbr

	dm01 = dw_4.getitemnumber(lrow1,'m01')
	dm02 = dw_4.getitemnumber(lrow1,'m02')
	dm03 = dw_4.getitemnumber(lrow1,'m03')
	dm04 = dw_4.getitemnumber(lrow1,'m04')
	dm05 = dw_4.getitemnumber(lrow1,'m05')
	dm06 = dw_4.getitemnumber(lrow1,'m06')
	dm07 = dw_4.getitemnumber(lrow1,'m07')
	dm08 = dw_4.getitemnumber(lrow1,'m08')
	dm09 = dw_4.getitemnumber(lrow1,'m09')
	dm10 = dw_4.getitemnumber(lrow1,'m10')
	dm11 = dw_4.getitemnumber(lrow1,'m11')
	dm12 = dw_4.getitemnumber(lrow1,'m12')
	
	lrowcnt2 = dw_5.retrieve(srinbr)
	if lrowcnt2 < 1 then
		messagebox("BOM","품번 : "+srinbr+" 은(는) BOM이 정의되지 않았습니다.")
		CONTINUE
	end if
	
	
	///////////////////////////////////////////////////////////////////////////////////////////
	FOR lrow2 = 1 TO lrowcnt2
		lvlno  = dw_5.getitemnumber(lrow2,'lvlno')
		scinbr = dw_5.getitemstring(lrow2,'cinbr')
		sittyp = dw_5.getitemstring(lrow2,'ittyp')
		dqtypr = dw_5.getitemnumber(lrow2,'qtypr')
		
		st_info2.text = srinbr + ' -> ' + scinbr

		if dw_5.getitemstring(lrow2,'is_skip') = 'Y' then continue		/* ittyp=3,4,5,6 하위레벨 skip */
		
		
		/* 품목구분이 원재료-단조품(3),가공품(4),조립품(5),철재료(6) */
		if sittyp = '3' or sittyp = '4' or sittyp = '5' or sittyp = '6' then
	
			if dw_5.getitemstring(lrow2,'useyn') <> '0' then continue		/* 사용구분이 사용중인것만 */			
			
			lrowcnt3 = lrow2 - 1
			FOR lrow3 = lrowcnt3 TO 1 STEP -1
				lprlvl = dw_5.getitemnumber(lrow3,'lvlno')
				if lprlvl < lvlno then
					dqtypr = dqtypr * dw_5.getitemnumber(lrow3,'qtypr')
					lvlno  = lprlvl
				end if
			NEXT

			/* ittyp=3,4,5,6 하위레벨 skip 지정 */
			skipnbr = scinbr
			FOR i = lrow2 TO lrowcnt2
				if i > lrowcnt2 then exit
				lfrow1 = dw_5.find("pinbr='"+skipnbr+"'",i,lrowcnt2)
				if lfrow1 > 0 then
					i = lfrow1
					dw_5.setitem(lfrow1,'is_skip','Y')
					skipnbr = dw_5.getitemstring(lfrow1,'cinbr')
				else
					exit
				end if
			NEXT

			lrowcnt4 = dw_6.retrieve(scinbr,syyyy+'0101')


//////////////////////////////////////////////////////////////////////////////////////////////
// 이원화 및 발주비율 적용 - START - 2004.01.05
			if lrowcnt4 < 1 then
				scvcod  = sjasa
				lrowcnt4= 1
			else
				scvcod  = dw_6.getitemstring(1,'cvcod')
			end if	

			FOR lrow4 = 1 TO lrowcnt4
				if scvcod = sjasa and lrowcnt4 = 1 then
					dporate = 1.0
					dunprc  = 0
				else
					scvcod  = dw_6.getitemstring(lrow4,'cvcod')
					dporate = dw_6.getitemnumber(lrow4,'porate')
					dunprc  = dw_6.getitemnumber(lrow4,'unprc')
				end if
				
				lfrow2 = dw_insert.find("pu01_yearplan_cvcod='"+scvcod+"' and pu01_yearplan_itnbr='"+scinbr+"'",1,dw_insert.rowcount())
				if lfrow2 > 0 then
					dw_insert.setitem(lfrow2,"pu01_yearplan_qtp_01",dw_insert.getitemnumber(lfrow2,"pu01_yearplan_qtp_01")+dqtypr*dm01)
					dw_insert.setitem(lfrow2,"pu01_yearplan_qtp_02",dw_insert.getitemnumber(lfrow2,"pu01_yearplan_qtp_02")+dqtypr*dm02)
					dw_insert.setitem(lfrow2,"pu01_yearplan_qtp_03",dw_insert.getitemnumber(lfrow2,"pu01_yearplan_qtp_03")+dqtypr*dm03)
					dw_insert.setitem(lfrow2,"pu01_yearplan_qtp_04",dw_insert.getitemnumber(lfrow2,"pu01_yearplan_qtp_04")+dqtypr*dm04)
					dw_insert.setitem(lfrow2,"pu01_yearplan_qtp_05",dw_insert.getitemnumber(lfrow2,"pu01_yearplan_qtp_05")+dqtypr*dm05)
					dw_insert.setitem(lfrow2,"pu01_yearplan_qtp_06",dw_insert.getitemnumber(lfrow2,"pu01_yearplan_qtp_06")+dqtypr*dm06)
					dw_insert.setitem(lfrow2,"pu01_yearplan_qtp_07",dw_insert.getitemnumber(lfrow2,"pu01_yearplan_qtp_07")+dqtypr*dm07)
					dw_insert.setitem(lfrow2,"pu01_yearplan_qtp_08",dw_insert.getitemnumber(lfrow2,"pu01_yearplan_qtp_08")+dqtypr*dm08)
					dw_insert.setitem(lfrow2,"pu01_yearplan_qtp_09",dw_insert.getitemnumber(lfrow2,"pu01_yearplan_qtp_09")+dqtypr*dm09)
					dw_insert.setitem(lfrow2,"pu01_yearplan_qtp_10",dw_insert.getitemnumber(lfrow2,"pu01_yearplan_qtp_10")+dqtypr*dm10)
					dw_insert.setitem(lfrow2,"pu01_yearplan_qtp_11",dw_insert.getitemnumber(lfrow2,"pu01_yearplan_qtp_11")+dqtypr*dm11)
					dw_insert.setitem(lfrow2,"pu01_yearplan_qtp_12",dw_insert.getitemnumber(lfrow2,"pu01_yearplan_qtp_12")+dqtypr*dm12)
				else
					
					lirow = dw_insert.insertrow(0)
					dw_insert.setitem(lirow,"pu01_yearplan_sabu",gs_saupj)
					dw_insert.setitem(lirow,"pu01_yearplan_yyyy",syyyy)
					dw_insert.setitem(lirow,"pu01_yearplan_cvcod",scvcod)
					select cvnas into :scvnas from vndmst where cvcod = :scvcod ;
					dw_insert.setitem(lirow,"vndmst_cvnas",scvnas)
					dw_insert.setitem(lirow,"pu01_yearplan_itnbr",scinbr)
					select itdsc, minqt into :scidsc, :dpalqty from itemas where itnbr = :scinbr ;
					dw_insert.setitem(lirow,"itemas_itdsc",scidsc)
					dw_insert.setitem(lirow,"pu01_yearplan_unprc",dunprc)
					dw_insert.setitem(lirow,"pu01_yearplan_minqt",dpalqty)
					dw_insert.setitem(lirow,"pu01_yearplan_porate",dporate)
					
					dw_insert.setitem(lirow,"pu01_yearplan_qtp_01",dqtypr*dm01)
					dw_insert.setitem(lirow,"pu01_yearplan_qtp_02",dqtypr*dm02)
					dw_insert.setitem(lirow,"pu01_yearplan_qtp_03",dqtypr*dm03)
					dw_insert.setitem(lirow,"pu01_yearplan_qtp_04",dqtypr*dm04)
					dw_insert.setitem(lirow,"pu01_yearplan_qtp_05",dqtypr*dm05)
					dw_insert.setitem(lirow,"pu01_yearplan_qtp_06",dqtypr*dm06)
					dw_insert.setitem(lirow,"pu01_yearplan_qtp_07",dqtypr*dm07)
					dw_insert.setitem(lirow,"pu01_yearplan_qtp_08",dqtypr*dm08)
					dw_insert.setitem(lirow,"pu01_yearplan_qtp_09",dqtypr*dm09)
					dw_insert.setitem(lirow,"pu01_yearplan_qtp_10",dqtypr*dm10)
					dw_insert.setitem(lirow,"pu01_yearplan_qtp_11",dqtypr*dm11)
					dw_insert.setitem(lirow,"pu01_yearplan_qtp_12",dqtypr*dm12)
					
					if lrowcnt4 > 1 then dw_insert.setitem(lirow,"cvdbl",'Y') // 이원화 표시
				end if
			NEXT
// 이원화 및 발주비율 적용 - END
//////////////////////////////////////////////////////////////////////////////////////////////
				
				
		end if			
	NEXT


	///////////////////////////////////////////////////////////////////////////////////////////
	// 외주계획 추가 - 2003.12.16
	FOR lrow2 = 1 TO lrowcnt2
		spinbr = dw_5.getitemstring(lrow2,'pinbr')
		swaiyn = dw_5.getitemstring(lrow2,'waiyn')
		dqtypr = dw_5.getitemnumber(lrow2,'qtypr')
		
		if swaiyn = 'N' then continue		/* 외주대상만 */
		
		lrowcnt5 = dw_9.retrieve(spinbr)
		if lrowcnt5 < 1 then continue

		st_info1.text = '외주 계획 :'

		lrowcnt3 = lrow2 - 1
		FOR lrow3 = lrowcnt3 TO 1 STEP -1
			lprlvl = dw_5.getitemnumber(lrow3,'lvlno')
			if lprlvl < lvlno then
				dqtypr = dqtypr * dw_5.getitemnumber(lrow3,'qtypr')
				lvlno  = lprlvl
			end if
		NEXT

		FOR lrow5 = 1 TO lrowcnt5
			swaitnbr = dw_9.getitemstring(lrow5,'wai_itnbr')

			st_info2.text = srinbr + ' -> ' + swaitnbr
			
			lrowcnt4 = dw_6.retrieve(swaitnbr,syyyy+'0101')



//////////////////////////////////////////////////////////////////////////////////////////////
// 이원화 및 발주비율 적용 - START - 2004.01.05
			if lrowcnt4 < 1 then
				scvcod  = sjasa
				lrowcnt4= 1
			else
				scvcod  = dw_6.getitemstring(1,'cvcod')
			end if	

			FOR lrow4 = 1 TO lrowcnt4
				if scvcod = sjasa and lrowcnt4 = 1 then
					dporate = 1.0
					dunprc  = 0
				else
					scvcod  = dw_6.getitemstring(lrow4,'cvcod')
					dporate = dw_6.getitemnumber(lrow4,'porate')
					dunprc  = dw_6.getitemnumber(lrow4,'unprc')
				end if
			
				lfrow2 = dw_insert.find("pu01_yearplan_cvcod='"+scvcod+"' and pu01_yearplan_itnbr='"+swaitnbr+"'",1,dw_insert.rowcount())
				if lfrow2 > 0 then
					dw_insert.setitem(lfrow2,"pu01_yearplan_qtp_01",dw_insert.getitemnumber(lfrow2,"pu01_yearplan_qtp_01")+dqtypr*dm01)
					dw_insert.setitem(lfrow2,"pu01_yearplan_qtp_02",dw_insert.getitemnumber(lfrow2,"pu01_yearplan_qtp_02")+dqtypr*dm02)
					dw_insert.setitem(lfrow2,"pu01_yearplan_qtp_03",dw_insert.getitemnumber(lfrow2,"pu01_yearplan_qtp_03")+dqtypr*dm03)
					dw_insert.setitem(lfrow2,"pu01_yearplan_qtp_04",dw_insert.getitemnumber(lfrow2,"pu01_yearplan_qtp_04")+dqtypr*dm04)
					dw_insert.setitem(lfrow2,"pu01_yearplan_qtp_05",dw_insert.getitemnumber(lfrow2,"pu01_yearplan_qtp_05")+dqtypr*dm05)
					dw_insert.setitem(lfrow2,"pu01_yearplan_qtp_06",dw_insert.getitemnumber(lfrow2,"pu01_yearplan_qtp_06")+dqtypr*dm06)
					dw_insert.setitem(lfrow2,"pu01_yearplan_qtp_07",dw_insert.getitemnumber(lfrow2,"pu01_yearplan_qtp_07")+dqtypr*dm07)
					dw_insert.setitem(lfrow2,"pu01_yearplan_qtp_08",dw_insert.getitemnumber(lfrow2,"pu01_yearplan_qtp_08")+dqtypr*dm08)
					dw_insert.setitem(lfrow2,"pu01_yearplan_qtp_09",dw_insert.getitemnumber(lfrow2,"pu01_yearplan_qtp_09")+dqtypr*dm09)
					dw_insert.setitem(lfrow2,"pu01_yearplan_qtp_10",dw_insert.getitemnumber(lfrow2,"pu01_yearplan_qtp_10")+dqtypr*dm10)
					dw_insert.setitem(lfrow2,"pu01_yearplan_qtp_11",dw_insert.getitemnumber(lfrow2,"pu01_yearplan_qtp_11")+dqtypr*dm11)
					dw_insert.setitem(lfrow2,"pu01_yearplan_qtp_12",dw_insert.getitemnumber(lfrow2,"pu01_yearplan_qtp_12")+dqtypr*dm12)
				else
					
					lirow = dw_insert.insertrow(0)
					dw_insert.setitem(lirow,"pu01_yearplan_sabu",gs_saupj)
					dw_insert.setitem(lirow,"pu01_yearplan_yyyy",syyyy)
					dw_insert.setitem(lirow,"pu01_yearplan_cvcod",scvcod)
					select cvnas into :scvnas from vndmst where cvcod = :scvcod ;
					dw_insert.setitem(lirow,"vndmst_cvnas",scvnas)
					dw_insert.setitem(lirow,"pu01_yearplan_itnbr",swaitnbr)
					select itdsc, minqt into :scidsc, :dpalqty from itemas where itnbr = :swaitnbr ;
					dw_insert.setitem(lirow,"itemas_itdsc",scidsc)
					dw_insert.setitem(lirow,"pu01_yearplan_unprc",dunprc)
					dw_insert.setitem(lirow,"pu01_yearplan_minqt",dpalqty)
					dw_insert.setitem(lirow,"pu01_yearplan_porate",dporate)
					
					dw_insert.setitem(lirow,"pu01_yearplan_qtp_01",dqtypr*dm01)
					dw_insert.setitem(lirow,"pu01_yearplan_qtp_02",dqtypr*dm02)
					dw_insert.setitem(lirow,"pu01_yearplan_qtp_03",dqtypr*dm03)
					dw_insert.setitem(lirow,"pu01_yearplan_qtp_04",dqtypr*dm04)
					dw_insert.setitem(lirow,"pu01_yearplan_qtp_05",dqtypr*dm05)
					dw_insert.setitem(lirow,"pu01_yearplan_qtp_06",dqtypr*dm06)
					dw_insert.setitem(lirow,"pu01_yearplan_qtp_07",dqtypr*dm07)
					dw_insert.setitem(lirow,"pu01_yearplan_qtp_08",dqtypr*dm08)
					dw_insert.setitem(lirow,"pu01_yearplan_qtp_09",dqtypr*dm09)
					dw_insert.setitem(lirow,"pu01_yearplan_qtp_10",dqtypr*dm10)
					dw_insert.setitem(lirow,"pu01_yearplan_qtp_11",dqtypr*dm11)
					dw_insert.setitem(lirow,"pu01_yearplan_qtp_12",dqtypr*dm12)
					
					if lrowcnt4 > 1 then dw_insert.setitem(lirow,"cvdbl",'Y') // 이원화 표시
				end if
			NEXT

// 이원화 및 발주비율 적용 - END
//////////////////////////////////////////////////////////////////////////////////////////////
			
			
		NEXT

	NEXT

NEXT



////////////////////////////////////////////////////////////////////////////////////////////////
//// 상품계획 READ
//FOR lrow1 = 1 TO lrowcnt1
//	srinbr = dw_4.getitemstring(lrow1,'itnbr')
//	srtype = dw_4.getitemstring(lrow1,'ittyp')
//	
//	
//	// 상품인 경우 계산 - 2003.11.24
//	select a.itnbr 
//	  into :scinbr 
//	  from item_rel a,
//	  		 itemas   b
//	 where a.itnbryd = :srinbr
//	   and a.itnbr = b.itnbr
//		and b.useyn = '0' ;
//	if sqlca.sqlcode <> 0 then continue
//
//	st_info1.text = '상품 계획 추가 :'
//	st_info2.text = srinbr + ' -> ' + scinbr
//
//	dm01 = dw_4.getitemnumber(lrow1,'m01')
//	dm02 = dw_4.getitemnumber(lrow1,'m02')
//	dm03 = dw_4.getitemnumber(lrow1,'m03')
//	dm04 = dw_4.getitemnumber(lrow1,'m04')
//	dm05 = dw_4.getitemnumber(lrow1,'m05')
//	dm06 = dw_4.getitemnumber(lrow1,'m06')
//	dm07 = dw_4.getitemnumber(lrow1,'m07')
//	dm08 = dw_4.getitemnumber(lrow1,'m08')
//	dm09 = dw_4.getitemnumber(lrow1,'m09')
//	dm10 = dw_4.getitemnumber(lrow1,'m10')
//	dm11 = dw_4.getitemnumber(lrow1,'m11')
//	dm12 = dw_4.getitemnumber(lrow1,'m12')
//	
//	lrowcnt4 = dw_6.retrieve(scinbr,syyyy+'0101')
//	
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
//			dunprc  = 0
//		else
//			scvcod  = dw_6.getitemstring(lrow4,'cvcod')
//			dporate = dw_6.getitemnumber(lrow4,'porate')
//			dunprc  = dw_6.getitemnumber(lrow4,'unprc')
//		end if
//	
//		lfrow2 = dw_insert.find("pu01_yearplan_cvcod='"+scvcod+"' and pu01_yearplan_itnbr='"+scinbr+"'",1,dw_insert.rowcount())
//		if lfrow2 > 0 then
//			dw_insert.setitem(lfrow2,"pu01_yearplan_qtp_01",dw_insert.getitemnumber(lfrow2,"pu01_yearplan_qtp_01")+dm01)
//			dw_insert.setitem(lfrow2,"pu01_yearplan_qtp_02",dw_insert.getitemnumber(lfrow2,"pu01_yearplan_qtp_02")+dm02)
//			dw_insert.setitem(lfrow2,"pu01_yearplan_qtp_03",dw_insert.getitemnumber(lfrow2,"pu01_yearplan_qtp_03")+dm03)
//			dw_insert.setitem(lfrow2,"pu01_yearplan_qtp_04",dw_insert.getitemnumber(lfrow2,"pu01_yearplan_qtp_04")+dm04)
//			dw_insert.setitem(lfrow2,"pu01_yearplan_qtp_05",dw_insert.getitemnumber(lfrow2,"pu01_yearplan_qtp_05")+dm05)
//			dw_insert.setitem(lfrow2,"pu01_yearplan_qtp_06",dw_insert.getitemnumber(lfrow2,"pu01_yearplan_qtp_06")+dm06)
//			dw_insert.setitem(lfrow2,"pu01_yearplan_qtp_07",dw_insert.getitemnumber(lfrow2,"pu01_yearplan_qtp_07")+dm07)
//			dw_insert.setitem(lfrow2,"pu01_yearplan_qtp_08",dw_insert.getitemnumber(lfrow2,"pu01_yearplan_qtp_08")+dm08)
//			dw_insert.setitem(lfrow2,"pu01_yearplan_qtp_09",dw_insert.getitemnumber(lfrow2,"pu01_yearplan_qtp_09")+dm09)
//			dw_insert.setitem(lfrow2,"pu01_yearplan_qtp_10",dw_insert.getitemnumber(lfrow2,"pu01_yearplan_qtp_10")+dm10)
//			dw_insert.setitem(lfrow2,"pu01_yearplan_qtp_11",dw_insert.getitemnumber(lfrow2,"pu01_yearplan_qtp_11")+dm11)
//			dw_insert.setitem(lfrow2,"pu01_yearplan_qtp_12",dw_insert.getitemnumber(lfrow2,"pu01_yearplan_qtp_12")+dm12)
//		else
//					
//			lirow = dw_insert.insertrow(0)
//			dw_insert.setitem(lirow,"pu01_yearplan_sabu",gs_saupj)
//			dw_insert.setitem(lirow,"pu01_yearplan_yyyy",syyyy)
//			dw_insert.setitem(lirow,"pu01_yearplan_cvcod",scvcod)
//			select cvnas into :scvnas from vndmst where cvcod = :scvcod ;
//			dw_insert.setitem(lirow,"vndmst_cvnas",scvnas)
//			dw_insert.setitem(lirow,"pu01_yearplan_itnbr",scinbr)
//			select itdsc, minqt into :scidsc, :dpalqty from itemas where itnbr = :scinbr ;
//			dw_insert.setitem(lirow,"itemas_itdsc",scidsc)
//			dw_insert.setitem(lirow,"pu01_yearplan_unprc",dunprc)
//			dw_insert.setitem(lirow,"pu01_yearplan_minqt",dpalqty)
//			dw_insert.setitem(lirow,"pu01_yearplan_porate",dporate)
//			
//			dw_insert.setitem(lirow,"pu01_yearplan_qtp_01",dm01)
//			dw_insert.setitem(lirow,"pu01_yearplan_qtp_02",dm02)
//			dw_insert.setitem(lirow,"pu01_yearplan_qtp_03",dm03)
//			dw_insert.setitem(lirow,"pu01_yearplan_qtp_04",dm04)
//			dw_insert.setitem(lirow,"pu01_yearplan_qtp_05",dm05)
//			dw_insert.setitem(lirow,"pu01_yearplan_qtp_06",dm06)
//			dw_insert.setitem(lirow,"pu01_yearplan_qtp_07",dm07)
//			dw_insert.setitem(lirow,"pu01_yearplan_qtp_08",dm08)
//			dw_insert.setitem(lirow,"pu01_yearplan_qtp_09",dm09)
//			dw_insert.setitem(lirow,"pu01_yearplan_qtp_10",dm10)
//			dw_insert.setitem(lirow,"pu01_yearplan_qtp_11",dm11)
//			dw_insert.setitem(lirow,"pu01_yearplan_qtp_12",dm12)
//		end if
//	
//		if lrowcnt4 > 1 then dw_insert.setitem(lirow,"cvdbl",'Y') // 이원화 표시
//	NEXT
//	
//// 이원화 및 발주비율 적용 - END
////////////////////////////////////////////////////////////////////////////////////////////////
//
//
//NEXT

st_info.visible = false
st_info1.visible = false
st_info2.visible = false
end subroutine

public function integer wf_calc_sagub ();long		lrow, lrow4, lirow, lfrow2, lrowcount, lrowcount2, ix
string	syyyy, srinbr, scinbr, scvcod, scvnas, scidsc, sjasa, srvcod
decimal	dporate, dunprc, dpalqty, dwdrate
datastore ds_wstruc

ds_wstruc = create datastore
ds_wstruc.dataobject = 'd_wstruc'
ds_wstruc.SetTransObject(sqlca)

dw_insert.accepttext()
syyyy = dw_1.getitemstring(1,'yyyy')

// 자사코드 가져오기
select dataname into :sjasa from syscnfg
 where sysgu = 'C' and serial = 4 and lineno = '1' ;

lrowcount2 = dw_insert.rowcount()
FOR lrow = 1 TO lrowcount2
	if dw_insert.getitemstring(lrow,'seqno') = '2' then continue
	
	srinbr = dw_insert.getitemstring(lrow,"pu01_yearplan_itnbr")
	srvcod = dw_insert.getitemstring(lrow,"pu01_yearplan_cvcod")
	
//	// 유상사급인 경우 확인- 2003.12.18
//	select a.itnbrwd, nvl(a.wdrate,0) 
//	  into :scinbr, :dwdrate
//	  from item_rel a,
//			   itemas   b
//	 where a.itnbr   = :srinbr
//	   and a.itnbrwd = b.itnbr
//		and b.useyn = '0' ;
//	if sqlca.sqlcode <> 0 then continue
//	if dwdrate <= 0 or dwdrate > 1 then dwdrate = 1.0   // 사급비율

	// 유상사급은 외주BOM에서 읽어온다
	For ix = 1 To ds_wstruc.Retrieve(srinbr, srvcod)
		scinbr = ds_wstruc.GetItemString(ix, 'cinbr')

		dwdrate = 1.0   // 사급비율
		
		st_info1.text = '유상사급 추가 :'
		st_info2.text = srinbr + ' -> ' + scinbr
	
		lrowcount = dw_6.retrieve(scinbr,syyyy+'0101')
		
		
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
				dunprc  = 0
			else
				scvcod  = dw_6.getitemstring(lrow4,'cvcod')
				dporate = dw_6.getitemnumber(lrow4,'porate')
				dunprc  = dw_6.getitemnumber(lrow4,'unprc')
			end if
	
			lfrow2 = dw_insert.find("pu01_yearplan_cvcod='"+scvcod+"' and pu01_yearplan_itnbr='"+scinbr+"'",1,dw_insert.rowcount())
			if lfrow2 > 0 then
				continue
			else
							
				lirow = dw_insert.insertrow(0)
				dw_insert.setitem(lirow,"pu01_yearplan_sabu",gs_saupj)
				dw_insert.setitem(lirow,"pu01_yearplan_yyyy",syyyy)
				dw_insert.setitem(lirow,"pu01_yearplan_cvcod",scvcod)
				select cvnas into :scvnas from vndmst where cvcod = :scvcod ;
				dw_insert.setitem(lirow,"vndmst_cvnas",scvnas)
				dw_insert.setitem(lirow,"pu01_yearplan_itnbr",scinbr)
				select itdsc, minqt into :scidsc, :dpalqty from itemas where itnbr = :scinbr ;
				dw_insert.setitem(lirow,"itemas_itdsc",scidsc)
				dw_insert.setitem(lirow,"pu01_yearplan_unprc",dunprc)
				dw_insert.setitem(lirow,"pu01_yearplan_minqt",dpalqty)
				dw_insert.setitem(lirow,"pu01_yearplan_porate",dporate)
				
				dw_insert.setitem(lirow,"pu01_yearplan_qtp_01",dw_insert.getitemnumber(lrow,"pu01_yearplan_qty_01"))
				dw_insert.setitem(lirow,"pu01_yearplan_qtp_02",dw_insert.getitemnumber(lrow,"pu01_yearplan_qty_02"))
				dw_insert.setitem(lirow,"pu01_yearplan_qtp_03",dw_insert.getitemnumber(lrow,"pu01_yearplan_qty_03"))
				dw_insert.setitem(lirow,"pu01_yearplan_qtp_04",dw_insert.getitemnumber(lrow,"pu01_yearplan_qty_04"))
				dw_insert.setitem(lirow,"pu01_yearplan_qtp_05",dw_insert.getitemnumber(lrow,"pu01_yearplan_qty_05"))
				dw_insert.setitem(lirow,"pu01_yearplan_qtp_06",dw_insert.getitemnumber(lrow,"pu01_yearplan_qty_06"))
				dw_insert.setitem(lirow,"pu01_yearplan_qtp_07",dw_insert.getitemnumber(lrow,"pu01_yearplan_qty_07"))
				dw_insert.setitem(lirow,"pu01_yearplan_qtp_08",dw_insert.getitemnumber(lrow,"pu01_yearplan_qty_08"))
				dw_insert.setitem(lirow,"pu01_yearplan_qtp_09",dw_insert.getitemnumber(lrow,"pu01_yearplan_qty_09"))
				dw_insert.setitem(lirow,"pu01_yearplan_qtp_10",dw_insert.getitemnumber(lrow,"pu01_yearplan_qty_10"))
				dw_insert.setitem(lirow,"pu01_yearplan_qtp_11",dw_insert.getitemnumber(lrow,"pu01_yearplan_qty_11"))
				dw_insert.setitem(lirow,"pu01_yearplan_qtp_12",dw_insert.getitemnumber(lrow,"pu01_yearplan_qty_12"))
				dw_insert.setitem(lirow,"seqno",'2')
				
				if lrowcount > 1 then dw_insert.setitem(lirow,"cvdbl",'Y') // 이원화 표시
			end if
		NEXT
	Next
// 이원화 및 발주비율 적용 - END
//////////////////////////////////////////////////////////////////////////////////////////////
	
	
NEXT

return 1
end function

public subroutine wf_set_qtp_org ();long		lrow
decimal	drate

dw_insert.accepttext()


////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 필요수량 원래대로
FOR lrow = 1 TO dw_insert.rowcount()
	drate = dw_insert.getitemnumber(lrow,"pu01_yearplan_porate")

	dw_insert.setitem(lrow,"pu01_yearplan_qtp_01",dw_insert.getitemnumber(lrow,"qtp_01_org"))
	dw_insert.setitem(lrow,"pu01_yearplan_qtp_02",dw_insert.getitemnumber(lrow,"qtp_02_org"))
	dw_insert.setitem(lrow,"pu01_yearplan_qtp_03",dw_insert.getitemnumber(lrow,"qtp_03_org"))
	dw_insert.setitem(lrow,"pu01_yearplan_qtp_04",dw_insert.getitemnumber(lrow,"qtp_04_org"))
	dw_insert.setitem(lrow,"pu01_yearplan_qtp_05",dw_insert.getitemnumber(lrow,"qtp_05_org"))
	dw_insert.setitem(lrow,"pu01_yearplan_qtp_06",dw_insert.getitemnumber(lrow,"qtp_06_org"))
	dw_insert.setitem(lrow,"pu01_yearplan_qtp_07",dw_insert.getitemnumber(lrow,"qtp_07_org"))
	dw_insert.setitem(lrow,"pu01_yearplan_qtp_08",dw_insert.getitemnumber(lrow,"qtp_08_org"))
	dw_insert.setitem(lrow,"pu01_yearplan_qtp_09",dw_insert.getitemnumber(lrow,"qtp_09_org"))
	dw_insert.setitem(lrow,"pu01_yearplan_qtp_10",dw_insert.getitemnumber(lrow,"qtp_10_org"))
	dw_insert.setitem(lrow,"pu01_yearplan_qtp_11",dw_insert.getitemnumber(lrow,"qtp_11_org"))
	dw_insert.setitem(lrow,"pu01_yearplan_qtp_12",dw_insert.getitemnumber(lrow,"qtp_12_org"))
NEXT
end subroutine

public subroutine wf_set_porate ();long		lrow
decimal	drate

dw_insert.accepttext()


////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 업체별 발주비율 적용
FOR lrow = 1 TO dw_insert.rowcount()
	drate = dw_insert.getitemnumber(lrow,"pu01_yearplan_porate")

	dw_insert.setitem(lrow,"qtp_01_org",dw_insert.getitemnumber(lrow,"pu01_yearplan_qtp_01"))
	dw_insert.setitem(lrow,"qtp_02_org",dw_insert.getitemnumber(lrow,"pu01_yearplan_qtp_02"))
	dw_insert.setitem(lrow,"qtp_03_org",dw_insert.getitemnumber(lrow,"pu01_yearplan_qtp_03"))
	dw_insert.setitem(lrow,"qtp_04_org",dw_insert.getitemnumber(lrow,"pu01_yearplan_qtp_04"))
	dw_insert.setitem(lrow,"qtp_05_org",dw_insert.getitemnumber(lrow,"pu01_yearplan_qtp_05"))
	dw_insert.setitem(lrow,"qtp_06_org",dw_insert.getitemnumber(lrow,"pu01_yearplan_qtp_06"))
	dw_insert.setitem(lrow,"qtp_07_org",dw_insert.getitemnumber(lrow,"pu01_yearplan_qtp_07"))
	dw_insert.setitem(lrow,"qtp_08_org",dw_insert.getitemnumber(lrow,"pu01_yearplan_qtp_08"))
	dw_insert.setitem(lrow,"qtp_09_org",dw_insert.getitemnumber(lrow,"pu01_yearplan_qtp_09"))
	dw_insert.setitem(lrow,"qtp_10_org",dw_insert.getitemnumber(lrow,"pu01_yearplan_qtp_10"))
	dw_insert.setitem(lrow,"qtp_11_org",dw_insert.getitemnumber(lrow,"pu01_yearplan_qtp_11"))
	dw_insert.setitem(lrow,"qtp_12_org",dw_insert.getitemnumber(lrow,"pu01_yearplan_qtp_12"))


	dw_insert.setitem(lrow,"pu01_yearplan_qtp_01",dw_insert.getitemnumber(lrow,"pu01_yearplan_qtp_01")*drate)
	dw_insert.setitem(lrow,"pu01_yearplan_qtp_02",dw_insert.getitemnumber(lrow,"pu01_yearplan_qtp_02")*drate)
	dw_insert.setitem(lrow,"pu01_yearplan_qtp_03",dw_insert.getitemnumber(lrow,"pu01_yearplan_qtp_03")*drate)
	dw_insert.setitem(lrow,"pu01_yearplan_qtp_04",dw_insert.getitemnumber(lrow,"pu01_yearplan_qtp_04")*drate)
	dw_insert.setitem(lrow,"pu01_yearplan_qtp_05",dw_insert.getitemnumber(lrow,"pu01_yearplan_qtp_05")*drate)
	dw_insert.setitem(lrow,"pu01_yearplan_qtp_06",dw_insert.getitemnumber(lrow,"pu01_yearplan_qtp_06")*drate)
	dw_insert.setitem(lrow,"pu01_yearplan_qtp_07",dw_insert.getitemnumber(lrow,"pu01_yearplan_qtp_07")*drate)
	dw_insert.setitem(lrow,"pu01_yearplan_qtp_08",dw_insert.getitemnumber(lrow,"pu01_yearplan_qtp_08")*drate)
	dw_insert.setitem(lrow,"pu01_yearplan_qtp_09",dw_insert.getitemnumber(lrow,"pu01_yearplan_qtp_09")*drate)
	dw_insert.setitem(lrow,"pu01_yearplan_qtp_10",dw_insert.getitemnumber(lrow,"pu01_yearplan_qtp_10")*drate)
	dw_insert.setitem(lrow,"pu01_yearplan_qtp_11",dw_insert.getitemnumber(lrow,"pu01_yearplan_qtp_11")*drate)
	dw_insert.setitem(lrow,"pu01_yearplan_qtp_12",dw_insert.getitemnumber(lrow,"pu01_yearplan_qtp_12")*drate)
NEXT
end subroutine

public subroutine wf_calc_point (string arg_seqno);long	lrow
long	lot, lcnt, lsum, lneed, lrest, lotsum
long	lqty1, lqty2, lqty3, lqty4, lqty5, lqty6, lqty7, lqty8, lqty9, lqty10, lqty11, lqty12

// 용기량이 지정된 자료만 

FOR lrow = 1 TO dw_insert.rowcount()
	if dw_insert.getitemstring(lrow,'seqno') <> arg_seqno then continue
	
	//====================================================================
	lot = dw_insert.getitemnumber(lrow,'pu01_yearplan_minqt')
	if lot <= 0 then continue

	lsum = dw_insert.getitemnumber(lrow,'sum_totqty')
	
	if lot > 0 then
		lotsum = ceiling(lsum/lot)*lot
	else
		lot = lsum
		lotsum = lsum
	end if
	
	
	
	//====================================================================
	lqty1 = dw_insert.getitemnumber(lrow,'pu01_yearplan_qtp_01')
	lneed = ceiling(lqty1/lot)*lot
	dw_insert.setitem(lrow,'pu01_yearplan_qty_01',lneed)
	lotsum = lotsum - lneed
	lrest= lneed - lqty1

	
	
	//====================================================================
	lqty2 = dw_insert.getitemnumber(lrow,'pu01_yearplan_qtp_02') - lrest
	if lqty2 > 0 then
		lneed = ceiling(lqty2/lot)*lot
	else
		lneed = 0
	end if
	
	if lotsum > 0 then
		dw_insert.setitem(lrow,'pu01_yearplan_qty_02',lneed)
		lotsum = lotsum - lneed
		lrest= lneed - lqty2
	else
		dw_insert.setitem(lrow,'pu01_yearplan_qty_02',lotsum)
		lotsum = 0
		lrest= 0
	end if


	//====================================================================
	lqty3 = dw_insert.getitemnumber(lrow,'pu01_yearplan_qtp_03') - lrest
	if lqty3 > 0 then
		lneed = ceiling(lqty3/lot)*lot
	else
		lneed = 0
	end if
	
	if lotsum > 0 then
		dw_insert.setitem(lrow,'pu01_yearplan_qty_03',lneed)
		lotsum = lotsum - lneed
		lrest= lneed - lqty3
	else
		dw_insert.setitem(lrow,'pu01_yearplan_qty_03',lotsum)
		lotsum = 0
		lrest= 0
	end if


	//====================================================================
	lqty4 = dw_insert.getitemnumber(lrow,'pu01_yearplan_qtp_04') - lrest
	if lqty4 > 0 then
		lneed = ceiling(lqty4/lot)*lot
	else
		lneed = 0
	end if
	
	if lotsum > 0 then
		dw_insert.setitem(lrow,'pu01_yearplan_qty_04',lneed)
		lotsum = lotsum - lneed
		lrest= lneed - lqty4
	else
		dw_insert.setitem(lrow,'pu01_yearplan_qty_04',lotsum)
		lotsum = 0
		lrest= 0
	end if


	//====================================================================
	lqty5 = dw_insert.getitemnumber(lrow,'pu01_yearplan_qtp_05') - lrest
	if lqty5 > 0 then
		lneed = ceiling(lqty5/lot)*lot
	else
		lneed = 0
	end if
	
	if lotsum > 0 then
		dw_insert.setitem(lrow,'pu01_yearplan_qty_05',lneed)
		lotsum = lotsum - lneed
		lrest= lneed - lqty5
	else
		dw_insert.setitem(lrow,'pu01_yearplan_qty_05',lotsum)
		lotsum = 0
		lrest= 0
	end if


	//====================================================================
	lqty6 = dw_insert.getitemnumber(lrow,'pu01_yearplan_qtp_06') - lrest
	if lqty6 > 0 then
		lneed = ceiling(lqty6/lot)*lot
	else
		lneed = 0
	end if
	
	if lotsum > 0 then
		dw_insert.setitem(lrow,'pu01_yearplan_qty_06',lneed)
		lotsum = lotsum - lneed
		lrest= lneed - lqty6
	else
		dw_insert.setitem(lrow,'pu01_yearplan_qty_06',lotsum)
		lotsum = 0
		lrest= 0
	end if


	//====================================================================
	lqty7 = dw_insert.getitemnumber(lrow,'pu01_yearplan_qtp_07') - lrest
	if lqty7 > 0 then
		lneed = ceiling(lqty7/lot)*lot
	else
		lneed = 0
	end if
	
	if lotsum > 0 then
		dw_insert.setitem(lrow,'pu01_yearplan_qty_07',lneed)
		lotsum = lotsum - lneed
		lrest= lneed - lqty7
	else
		dw_insert.setitem(lrow,'pu01_yearplan_qty_07',lotsum)
		lotsum = 0
		lrest= 0
	end if
	

	//====================================================================
	lqty8 = dw_insert.getitemnumber(lrow,'pu01_yearplan_qtp_08') - lrest
	if lqty8 > 0 then
		lneed = ceiling(lqty8/lot)*lot
	else
		lneed = 0
	end if
	
	if lotsum > 0 then
		dw_insert.setitem(lrow,'pu01_yearplan_qty_08',lneed)
		lotsum = lotsum - lneed
		lrest= lneed - lqty8
	else
		dw_insert.setitem(lrow,'pu01_yearplan_qty_08',lotsum)
		lotsum = 0
		lrest= 0
	end if
	
	
	//====================================================================
	lqty9 = dw_insert.getitemnumber(lrow,'pu01_yearplan_qtp_09') - lrest
	if lqty9 > 0 then
		lneed = ceiling(lqty9/lot)*lot
	else
		lneed = 0
	end if
	
	if lotsum > 0 then
		dw_insert.setitem(lrow,'pu01_yearplan_qty_09',lneed)
		lotsum = lotsum - lneed
		lrest= lneed - lqty9
	else
		dw_insert.setitem(lrow,'pu01_yearplan_qty_09',lotsum)
		lotsum = 0
		lrest= 0
	end if
	

	//====================================================================
	lqty10 = dw_insert.getitemnumber(lrow,'pu01_yearplan_qtp_10') - lrest
	if lqty10 > 0 then
		lneed = ceiling(lqty10/lot)*lot
	else
		lneed = 0
	end if
	
	if lotsum > 0 then
		dw_insert.setitem(lrow,'pu01_yearplan_qty_10',lneed)
		lotsum = lotsum - lneed
		lrest= lneed - lqty10
	else
		dw_insert.setitem(lrow,'pu01_yearplan_qty_10',lotsum)
		lotsum = 0
		lrest= 0
	end if
	
	
	//====================================================================
	lqty11 = dw_insert.getitemnumber(lrow,'pu01_yearplan_qtp_11') - lrest
	if lqty11 > 0 then
		lneed = ceiling(lqty11/lot)*lot
	else
		lneed = 0
	end if
	
	if lotsum > 0 then
		dw_insert.setitem(lrow,'pu01_yearplan_qty_11',lneed)
		lotsum = lotsum - lneed
		lrest= lneed - lqty11
	else
		dw_insert.setitem(lrow,'pu01_yearplan_qty_11',lotsum)
		lotsum = 0
		lrest= 0
	end if
	

	//====================================================================
	lqty12 = dw_insert.getitemnumber(lrow,'pu01_yearplan_qtp_12') - lrest
	if lqty12 > 0 then
		lneed = ceiling(lqty12/lot)*lot
	else
		lneed = 0
	end if
	
	if lotsum > 0 then
		dw_insert.setitem(lrow,'pu01_yearplan_qty_12',lneed)
		lotsum = lotsum - lneed
		lrest= lneed - lqty12
	else
		dw_insert.setitem(lrow,'pu01_yearplan_qty_12',lotsum)
		lotsum = 0
		lrest= 0
	end if
NEXT
end subroutine

on w_pu01_00010.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_2=create dw_2
this.dw_3=create dw_3
this.dw_4=create dw_4
this.dw_5=create dw_5
this.dw_6=create dw_6
this.st_info=create st_info
this.st_info2=create st_info2
this.rr_1=create rr_1
this.rr_2=create rr_2
this.st_info1=create st_info1
this.dw_7=create dw_7
this.dw_8=create dw_8
this.dw_insert2=create dw_insert2
this.dw_9=create dw_9
this.cb_1=create cb_1
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.dw_3
this.Control[iCurrent+4]=this.dw_4
this.Control[iCurrent+5]=this.dw_5
this.Control[iCurrent+6]=this.dw_6
this.Control[iCurrent+7]=this.st_info
this.Control[iCurrent+8]=this.st_info2
this.Control[iCurrent+9]=this.rr_1
this.Control[iCurrent+10]=this.rr_2
this.Control[iCurrent+11]=this.st_info1
this.Control[iCurrent+12]=this.dw_7
this.Control[iCurrent+13]=this.dw_8
this.Control[iCurrent+14]=this.dw_insert2
this.Control[iCurrent+15]=this.dw_9
this.Control[iCurrent+16]=this.cb_1
this.Control[iCurrent+17]=this.rr_3
end on

on w_pu01_00010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.dw_3)
destroy(this.dw_4)
destroy(this.dw_5)
destroy(this.dw_6)
destroy(this.st_info)
destroy(this.st_info2)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.st_info1)
destroy(this.dw_7)
destroy(this.dw_8)
destroy(this.dw_insert2)
destroy(this.dw_9)
destroy(this.cb_1)
destroy(this.rr_3)
end on

event open;call super::open;dw_insert.SetTransObject(sqlca)
dw_insert2.SetTransObject(sqlca)
dw_3.SetTransObject(sqlca)
dw_4.SetTransObject(sqlca)
dw_5.SetTransObject(sqlca)
dw_6.SetTransObject(sqlca)
dw_8.SetTransObject(sqlca)
dw_9.SetTransObject(sqlca)

wf_initial()
end event

type dw_insert from w_inherite`dw_insert within w_pu01_00010
integer x = 64
integer y = 312
integer width = 4485
integer height = 1516
integer taborder = 150
string dataobject = "d_pu01_00010_2_m"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemerror;call super::itemerror;return 1
end event

event dw_insert::rowfocuschanged;call super::rowfocuschanged;this.selectrow(0,false)
end event

event dw_insert::clicked;call super::clicked;this.selectrow(0,false)
post wf_history(this,row)
end event

event dw_insert::doubleclicked;call super::doubleclicked;//if row <= 0 then return
//
//long		lrow
//string	sitnbr, scvcod
//
//sitnbr = this.getitemstring(row,'pu01_yearplan_itnbr')
//scvcod = this.getitemstring(row,'pu01_yearplan_cvcod')
//
//lrow = dw_insert2.find("pu01_yearplan_itnbr='"+sitnbr+"' and "+&
//							 "pu01_yearplan_cvcod='"+scvcod+"'",1,dw_insert2.rowcount())
//if lrow > 0 then
//	dw_7.setitem(1,'gubun','2')
//	dw_7.triggerevent(itemchanged!)
//
//	lrow = dw_insert2.find("pu01_yearplan_itnbr='"+sitnbr+"' and "+&
//							 "pu01_yearplan_cvcod='"+scvcod+"'",1,dw_insert2.rowcount())
//							 
//	this.selectrow(0,false)	
//	dw_insert2.setrow(lrow)
//	dw_insert2.selectrow(0,false)
//	dw_insert2.selectrow(lrow,true)
//	dw_insert2.scrolltorow(lrow)	
//end if
end event

event dw_insert::itemchanged;call super::itemchanged;if row <= 0 then return

if this.getcolumnname() = 'cvdbl' then
	string	sitnbr, sitdsc, scvnas, sok
	decimal	dunprc
	
	sitnbr = this.getitemstring(row,'pu01_yearplan_itnbr')
	sitdsc = this.getitemstring(row,'itemas_itdsc')
	
	gs_code = sitnbr
	gs_codename = sitdsc
	
	open(w_cvdouble_popup)
	sok = message.stringparm
	if sok = 'OK' then
		this.rowscopy(row,row,primary!,this,row+1,primary!)
		
		select unprc into :dunprc from danmst
		 where itnbr = :sitnbr and cvcod = :gs_code and opseq = '9999' ;
		
		if sqlca.sqlcode <> 0 then dunprc = 0
		
		this.setitem(row+1,'pu01_yearplan_cvcod',gs_code)
		this.setitem(row+1,'vndmst_cvnas',gs_codename)
		this.setitem(row+1,'pu01_yearplan_unprc',gs_codename)
		this.setitem(row+1,"pu01_yearplan_qty_01",0)
		this.setitem(row+1,"pu01_yearplan_qty_02",0)
		this.setitem(row+1,"pu01_yearplan_qty_03",0)
		this.setitem(row+1,"pu01_yearplan_qty_04",0)
		this.setitem(row+1,"pu01_yearplan_qty_05",0)
		this.setitem(row+1,"pu01_yearplan_qty_06",0)
		this.setitem(row+1,"pu01_yearplan_qty_07",0)
		this.setitem(row+1,"pu01_yearplan_qty_08",0)
		this.setitem(row+1,"pu01_yearplan_qty_09",0)
		this.setitem(row+1,"pu01_yearplan_qty_10",0)
		this.setitem(row+1,"pu01_yearplan_qty_11",0)
		this.setitem(row+1,"pu01_yearplan_qty_12",0)
		
		this.setitem(row,"cvdbl",'N')
		this.setitem(row+1,"cvdbl",'N')
	end if
end if

this.selectrow(0,false)
post wf_history(this,row)
end event

type p_delrow from w_inherite`p_delrow within w_pu01_00010
boolean visible = false
integer x = 5413
integer y = 536
integer taborder = 60
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

type p_addrow from w_inherite`p_addrow within w_pu01_00010
boolean visible = false
integer x = 5230
integer y = 536
integer taborder = 50
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

type p_search from w_inherite`p_search within w_pu01_00010
integer x = 3584
integer y = 88
integer taborder = 130
boolean originalsize = true
string picturename = "C:\erpman\image\MRP_up.gif"
end type

event p_search::clicked;string	syyyy, smagam, stemp

dw_1.accepttext()
smagam = dw_1.getitemstring(1,'cnfirm')
if smagam <> '1' then
	messagebox("확인","확정 처리된 자료입니다.")
	return
end if

syyyy = trim(dw_1.getitemstring(1,'yyyy'))
if Isnull(syyyy) or syyyy = '' then
	f_message_chk(1400,'[계획년도]')
	return
end if

select yyyy into :stemp from sm01_yearplan
 where sabu = '1' and yyyy = :syyyy and saupj = :gs_saupj and cnfirm is not null and rownum = 1 ;
if sqlca.sqlcode <> 0 then
	messagebox('확인',syyyy + '년 판매계획이 없습니다')
	return
end if


select yyyy into :syyyy from pu01_yearplan
 where sabu = :gs_saupj and yyyy = :syyyy and rownum = 1 ;

if sqlca.sqlcode = 0 then
	if messagebox("자재소요량 전개",syyyy+" 년 구매계획이 존재합니다."+&
								"~n기존 계획을 삭제하시겠습니까?" ,exclamation!,oKcancel!,2) = 2 then
		return
	end if

	delete from pu01_yearplan
	 where sabu = :gs_saupj and yyyy = :syyyy ;

else
	if messagebox("자재소요량 전개","자재소요량을 전개하시겠습니까?" ,exclamation!,oKcancel!,2) = 2 then
		return
	end if
end if



///////////////////////////////////////////////////////////////////////////////////////////
dw_insert.setredraw(false)
wf_get_plan()
wf_set_porate() // 발주비율 적용
wf_calc_point('1')
wf_calc_point2('1')


///////////////////////////////////////////////////////////////////////////////
// 유상사급품 추가 - 2003.12.18
wf_calc_sagub()
wf_calc_point('2')
wf_calc_point2('2')

wf_set_qtp_org() // 필요수량 원위치
wf_set_orgqty()
//wf_set_minqt()
wf_set_monmax()

dw_insert.setsort("pu01_yearplan_sabu A, pu01_yearplan_yyyy A, pu01_yearplan_cvcod A, pu01_yearplan_itnbr A")
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

type p_ins from w_inherite`p_ins within w_pu01_00010
boolean visible = false
integer x = 3168
integer y = 92
integer taborder = 30
string picturename = "C:\erpman\image\메일전송_up.gif"
end type

event type long p_ins::ue_lbuttondown(unsignedlong flags, integer xpos, integer ypos);//PictureName = "C:\erpman\image\조정2_dn.gif"
return 0
end event

event type long p_ins::ue_lbuttonup(unsignedlong flags, integer xpos, integer ypos);//PictureName = "C:\erpman\image\조정2_up.gif"
return 0
end event

event type long p_ins::ue_mousemove(unsignedlong flags, integer xpos, integer ypos);//iF flags = 0 Then wf_onmouse(p_ins)
return 0
end event

event p_ins::clicked;call super::clicked;String 	ls_window_id , ls_window_nm, syyyy

dw_1.accepttext()

syyyy = trim(dw_1.getitemstring(1,'yyyy'))
if Isnull(syyyy) or syyyy = '' then
	f_message_chk(1400,'[계획년도]')
	return
end if

ls_window_id = 'w_pu01_00010'
ls_window_nm = '년 구매계획'

If ls_window_id = '' or isNull(ls_window_id) Then
	messagebox('','프로그램명이 없습니다.')
	return
End If

gs_code = '년 구매계획'
gs_codename = syyyy + '년 구매계획을 수립했습니다.'
OpenWithParm(w_mail_insert , ls_window_id + Space(100) + ls_window_nm)
end event

type p_exit from w_inherite`p_exit within w_pu01_00010
integer x = 4279
integer y = 88
integer taborder = 110
end type

type p_can from w_inherite`p_can within w_pu01_00010
integer x = 4105
integer y = 88
integer taborder = 90
end type

event p_can::clicked;call super::clicked;rollback ;

wf_initial()
end event

type p_print from w_inherite`p_print within w_pu01_00010
boolean visible = false
integer x = 5047
integer y = 536
integer taborder = 140
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_pu01_00010
integer x = 3758
integer y = 88
end type

event p_inq::clicked;call super::clicked;string	syyyy, sgubun

dw_1.accepttext()
syyyy = trim(dw_1.getitemstring(1,'yyyy'))
if Isnull(syyyy) or syyyy = '' then
	f_message_chk(1400,'[계획년도]')
	return
end if

sgubun = dw_1.getitemstring(1,'gubun')

select yyyy into :syyyy from pu01_yearplan
 where sabu = :gs_saupj and yyyy = :syyyy and rownum = 1 ;

if sqlca.sqlcode <> 0 then
	messagebox("확인","해당년도의 구매계획 자료가 없습니다!!!")
	return
end if

setpointer(hourglass!)
If dw_insert.Retrieve(gs_saupj,syyyy,sgubun) <= 0 Then
	f_message_chk(50,'년 구매계획')
End If
end event

type p_del from w_inherite`p_del within w_pu01_00010
boolean visible = false
integer x = 4864
integer y = 536
integer taborder = 80
end type

type p_mod from w_inherite`p_mod within w_pu01_00010
integer x = 3931
integer y = 88
integer taborder = 70
end type

event p_mod::clicked;long		lrow, lrowcnt
string	syyyy, smagam

dw_1.accepttext()
If dw_insert.AcceptText() <> 1 Then Return
If dw_insert.RowCount() <= 0 Then Return

smagam = dw_1.getitemstring(1,'cnfirm')
if smagam <> '1' then
	messagebox("확인","WEB 통보된 자료입니다.")
	return
end if

if messagebox('확인','년 구매계획을 저장합니다.',question!,yesno!,1) = 2 then Return 

FOR lrow = dw_insert.rowcount() TO 1 STEP -1
	dw_insert.setitem(lrow,"pu01_yearplan_amt_01",dw_insert.getitemnumber(lrow,"pu01_yearplan_qty_01")*dw_insert.getitemnumber(lrow,"pu01_yearplan_unprc"))
	dw_insert.setitem(lrow,"pu01_yearplan_amt_02",dw_insert.getitemnumber(lrow,"pu01_yearplan_qty_02")*dw_insert.getitemnumber(lrow,"pu01_yearplan_unprc"))
	dw_insert.setitem(lrow,"pu01_yearplan_amt_03",dw_insert.getitemnumber(lrow,"pu01_yearplan_qty_03")*dw_insert.getitemnumber(lrow,"pu01_yearplan_unprc"))
	dw_insert.setitem(lrow,"pu01_yearplan_amt_04",dw_insert.getitemnumber(lrow,"pu01_yearplan_qty_04")*dw_insert.getitemnumber(lrow,"pu01_yearplan_unprc"))
	dw_insert.setitem(lrow,"pu01_yearplan_amt_05",dw_insert.getitemnumber(lrow,"pu01_yearplan_qty_05")*dw_insert.getitemnumber(lrow,"pu01_yearplan_unprc"))
	dw_insert.setitem(lrow,"pu01_yearplan_amt_06",dw_insert.getitemnumber(lrow,"pu01_yearplan_qty_06")*dw_insert.getitemnumber(lrow,"pu01_yearplan_unprc"))
	dw_insert.setitem(lrow,"pu01_yearplan_amt_07",dw_insert.getitemnumber(lrow,"pu01_yearplan_qty_07")*dw_insert.getitemnumber(lrow,"pu01_yearplan_unprc"))
	dw_insert.setitem(lrow,"pu01_yearplan_amt_08",dw_insert.getitemnumber(lrow,"pu01_yearplan_qty_08")*dw_insert.getitemnumber(lrow,"pu01_yearplan_unprc"))
	dw_insert.setitem(lrow,"pu01_yearplan_amt_09",dw_insert.getitemnumber(lrow,"pu01_yearplan_qty_09")*dw_insert.getitemnumber(lrow,"pu01_yearplan_unprc"))
	dw_insert.setitem(lrow,"pu01_yearplan_amt_10",dw_insert.getitemnumber(lrow,"pu01_yearplan_qty_10")*dw_insert.getitemnumber(lrow,"pu01_yearplan_unprc"))
	dw_insert.setitem(lrow,"pu01_yearplan_amt_11",dw_insert.getitemnumber(lrow,"pu01_yearplan_qty_11")*dw_insert.getitemnumber(lrow,"pu01_yearplan_unprc"))
	dw_insert.setitem(lrow,"pu01_yearplan_amt_12",dw_insert.getitemnumber(lrow,"pu01_yearplan_qty_12")*dw_insert.getitemnumber(lrow,"pu01_yearplan_unprc"))
	
//	if dw_insert.getitemnumber(lrow,'sum_vndqty') > 0 then continue
//	dw_insert.deleterow(lrow)
NEXT

setpointer(hourglass!)
If dw_insert.Update() <> 1 Then
	RollBack;
	Return
End If

COMMIT;

messagebox('확인','년 구매계획을 저장하였습니다.')
end event

type cb_exit from w_inherite`cb_exit within w_pu01_00010
integer x = 3022
integer y = 2936
boolean enabled = false
end type

type cb_mod from w_inherite`cb_mod within w_pu01_00010
integer x = 709
integer y = 2936
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within w_pu01_00010
integer x = 347
integer y = 2936
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_pu01_00010
integer x = 1070
integer y = 2936
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_pu01_00010
integer x = 1431
integer y = 2936
boolean enabled = false
end type

type cb_print from w_inherite`cb_print within w_pu01_00010
integer x = 1792
integer y = 2936
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_pu01_00010
integer x = 59
integer y = 3148
end type

type cb_can from w_inherite`cb_can within w_pu01_00010
integer x = 2117
integer y = 2896
boolean enabled = false
end type

type cb_search from w_inherite`cb_search within w_pu01_00010
integer x = 2514
integer y = 2936
boolean enabled = false
end type

type dw_datetime from w_inherite`dw_datetime within w_pu01_00010
integer x = 2903
integer y = 3148
boolean enabled = false
end type

type sle_msg from w_inherite`sle_msg within w_pu01_00010
integer x = 411
integer y = 3148
boolean enabled = false
end type

type gb_10 from w_inherite`gb_10 within w_pu01_00010
integer x = 41
integer y = 3096
boolean enabled = false
end type

type gb_button1 from w_inherite`gb_button1 within w_pu01_00010
integer x = 1211
integer y = 3368
boolean enabled = false
end type

type gb_button2 from w_inherite`gb_button2 within w_pu01_00010
integer x = 1755
integer y = 3392
boolean enabled = false
end type

type dw_1 from u_key_enter within w_pu01_00010
integer x = 137
integer y = 124
integer width = 2898
integer height = 124
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_pu01_00010_0"
boolean border = false
end type

event itemchanged;call super::itemchanged;string	syyyy, scnfirm

syyyy = this.gettext()

select substr(cnftime,1,8) into :scnfirm from pu01_yearplan
 where sabu = :gs_saupj and yyyy = :syyyy and cnftime is not null and rownum = 1 ;

if sqlca.sqlcode = 0 then
	this.setitem(1,'cnfirm','3')
else
	this.setitem(1,'cnfirm','1')
end if
end event

type dw_2 from datawindow within w_pu01_00010
boolean visible = false
integer x = 4690
integer y = 704
integer width = 1408
integer height = 88
integer taborder = 100
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm01_00010_3"
boolean border = false
boolean livescroll = true
end type

type dw_3 from datawindow within w_pu01_00010
integer x = 46
integer y = 1860
integer width = 4558
integer height = 376
integer taborder = 160
boolean bringtotop = true
string title = "none"
string dataobject = "d_pu01_00010_0a_t"
boolean border = false
boolean livescroll = true
end type

type dw_4 from datawindow within w_pu01_00010
boolean visible = false
integer x = 69
integer y = 2488
integer width = 937
integer height = 244
integer taborder = 170
boolean bringtotop = true
boolean titlebar = true
string title = "년판매계획"
string dataobject = "d_pu01_00010_a"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_5 from datawindow within w_pu01_00010
boolean visible = false
integer x = 1157
integer y = 2488
integer width = 937
integer height = 244
integer taborder = 190
boolean bringtotop = true
boolean titlebar = true
string title = "BOM"
string dataobject = "d_pu01_00010_b"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_6 from datawindow within w_pu01_00010
boolean visible = false
integer x = 2245
integer y = 2500
integer width = 937
integer height = 244
integer taborder = 200
boolean bringtotop = true
boolean titlebar = true
string title = "공급업체"
string dataobject = "d_pu01_00010_c"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_info from statictext within w_pu01_00010
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

type st_info2 from statictext within w_pu01_00010
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

type rr_1 from roundrectangle within w_pu01_00010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 304
integer width = 4507
integer height = 1540
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pu01_00010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 72
integer width = 3026
integer height = 204
integer cornerheight = 40
integer cornerwidth = 55
end type

type st_info1 from statictext within w_pu01_00010
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

type dw_7 from datawindow within w_pu01_00010
boolean visible = false
integer x = 3273
integer y = 108
integer width = 297
integer height = 148
integer taborder = 40
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
//	dw_insert.setsort("pu01_yearplan_sabu A, pu01_yearplan_yyyy A, pu01_yearplan_itnbr A, pu01_yearplan_cvcod A")
//	dw_insert.sort()
//	dw_insert.groupcalc()
//else
//	dw_insert.visible = false
//	dw_insert2.visible = true
//	
//	dw_insert2.setsort("pu01_yearplan_sabu A, pu01_yearplan_yyyy A, pu01_yearplan_cvcod A, pu01_yearplan_itnbr A")
//	dw_insert2.sort()
//	dw_insert2.groupcalc()
//end if
//
//dw_insert.setredraw(true)
//dw_insert2.setredraw(true)
end event

type dw_8 from datawindow within w_pu01_00010
boolean visible = false
integer x = 3291
integer y = 2496
integer width = 937
integer height = 244
integer taborder = 180
boolean bringtotop = true
boolean titlebar = true
string title = "월 최대 납품량"
string dataobject = "d_pu01_00010_d"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean border = false
boolean livescroll = true
end type

type dw_insert2 from datawindow within w_pu01_00010
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
boolean visible = false
integer x = 3182
integer y = 32
integer width = 238
integer height = 120
integer taborder = 120
boolean bringtotop = true
string title = "none"
string dataobject = "d_pu01_00010_2_m"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event type long ue_pressenter();Send(Handle(this),256,9,0)
Return 1
end event

event clicked;this.selectrow(0,false)
post wf_history(this,row)
end event

event itemerror;return 1
end event

event doubleclicked;//if row <= 0 then return
//
//long		lrow
//string	sitnbr, scvcod
//
//sitnbr = this.getitemstring(row,'pu01_yearplan_itnbr')
//scvcod = this.getitemstring(row,'pu01_yearplan_cvcod')
//
//lrow = dw_insert.find("pu01_yearplan_itnbr='"+sitnbr+"' and "+&
//							 "pu01_yearplan_cvcod='"+scvcod+"'",1,dw_insert.rowcount())
//if lrow > 0 then
//	dw_7.setitem(1,'gubun','1')
//	dw_7.triggerevent(itemchanged!)
//
//	lrow = dw_insert.find("pu01_yearplan_itnbr='"+sitnbr+"' and "+&
//							 "pu01_yearplan_cvcod='"+scvcod+"'",1,dw_insert.rowcount())
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
post wf_history(this,row)
end event

type dw_9 from datawindow within w_pu01_00010
boolean visible = false
integer x = 3291
integer y = 2764
integer width = 937
integer height = 244
integer taborder = 190
boolean bringtotop = true
boolean titlebar = true
string title = "외주 품목"
string dataobject = "d_pu01_00010_e"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean border = false
boolean livescroll = true
end type

type cb_1 from commandbutton within w_pu01_00010
boolean visible = false
integer x = 3209
integer y = 8
integer width = 402
integer height = 84
integer taborder = 130
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "none"
end type

event clicked;dw_insert.saveas("",EXCEL!,true)
end event

type rr_3 from roundrectangle within w_pu01_00010
boolean visible = false
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 3227
integer y = 76
integer width = 297
integer height = 204
integer cornerheight = 40
integer cornerwidth = 55
end type

