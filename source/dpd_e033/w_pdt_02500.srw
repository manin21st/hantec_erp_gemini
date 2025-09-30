$PBExportHeader$w_pdt_02500.srw
$PBExportComments$출하검사등록
forward
global type w_pdt_02500 from w_inherite
end type
type ds_update from datawindow within w_pdt_02500
end type
type dw_hist from datawindow within w_pdt_02500
end type
type dw_setup from datawindow within w_pdt_02500
end type
type p_4 from uo_picture within w_pdt_02500
end type
type p_1 from uo_picture within w_pdt_02500
end type
type p_nttabl from uo_picture within w_pdt_02500
end type
type p_holdstock from uo_picture within w_pdt_02500
end type
type p_5 from uo_picture within w_pdt_02500
end type
type dw_head from datawindow within w_pdt_02500
end type
type pb_1 from u_pb_cal within w_pdt_02500
end type
type pb_2 from u_pb_cal within w_pdt_02500
end type
type pb_3 from u_pb_cal within w_pdt_02500
end type
type pb_4 from u_pb_cal within w_pdt_02500
end type
type rr_1 from roundrectangle within w_pdt_02500
end type
type rr_2 from roundrectangle within w_pdt_02500
end type
end forward

global type w_pdt_02500 from w_inherite
string title = "출하검사등록"
ds_update ds_update
dw_hist dw_hist
dw_setup dw_setup
p_4 p_4
p_1 p_1
p_nttabl p_nttabl
p_holdstock p_holdstock
p_5 p_5
dw_head dw_head
pb_1 pb_1
pb_2 pb_2
pb_3 pb_3
pb_4 pb_4
rr_1 rr_1
rr_2 rr_2
end type
global w_pdt_02500 w_pdt_02500

type variables
string   isjpno,  &
           is_chk    //시스템에서 작업자 필수입력 체크
string s1, s2, s3, s4
 


end variables

forward prototypes
public function integer wf_settime (long lrow)
public function string wf_setfilter ()
public function integer wf_insert ()
public function integer wf_requiredchk (ref long lcrow, ref string scolumn)
public function integer wf_chango (long lrow)
public function integer wf_save ()
public subroutine wf_reset ()
end prototypes

public function integer wf_settime (long lrow);sTring sdate, stime, edate, etime, spoint
Long   Lday, Linwon
Dec {2} dfirtime, dsectime, dtotal, desset, desman, desmch
Dec {2} dsetrate, dmanrate, dmchrate, dset, dman, dmch

sdate  = dw_insert.getitemstring(Lrow, "sdate")
stime  = dw_insert.getitemstring(Lrow, "stime")
edate  = dw_insert.getitemstring(Lrow, "edate")
etime  = dw_insert.getitemstring(Lrow, "etime")
Linwon = dw_insert.getitemdecimal(Lrow, "toiwn")


// 시작일자와 종료일자사이의 일수를 구함 ( 9999인 경우에는 Error )
Lday = f_dayterm(sdate, edate)
if Lday = 9999 then return -1

// 시작일의 시작시간 부터 종료시간 까지의 시간을 구함
// 일수가 0인      경우 (시작일 시작시간(휴식시간 제외 > ) + 종료시간(휴식시간 제외 < ))
// 일수가 1인      경우 (시작일 시작시간(휴식시간 제외 > ) + 24시까지) + (00 ~ 종료일 종료시간(휴식시간 제외 < ))
// 일수가 1이상 인 경우 (시작일 시작시간(휴식시간 제외 > ) + 24시까지) + (00 ~ 종료일 종료시간(휴식시간 제외 < ))

if Lday > 0 then
	spoint = '9999'
Else
	spoint = etime
End if

// 시작시간 이후 휴식시간 검색(From ~ to)
SELECT SUM(NVL(TO_NUMBER(DATANAME),0))
  INTO :dFirtime
  FROM SYSCNFG
 WHERE SYSGU = 'Y' and SERIAL = 28 AND LINENO <> '00'
	and TITLENAME >= :stime And TITLENAME <= :spoint;
	
if isnull(dfirtime) then 
	dfirtime = 0
end if

dfirtime = dfirtime * Linwon

// 종료시간 이전 휴식시간 검색(From ~ to)
dSectime = 0
if Lday > 0 then
	SELECT SUM(NVL(TO_NUMBER(DATANAME),0))
	  INTO :dSectime
	  FROM SYSCNFG
	 WHERE SYSGU = 'Y' and SERIAL = 28 AND LINENO <> '00'
		and TITLENAME <= :etime;
		
	if isnull(dSectime) then 
		dSectime = 0
	end if		
		
End if

dsectime = dsectime * Linwon
	
// 시간계산
dtotal = f_daytimeterm(sdate, edate, stime, etime)
if dtotal = -1 then return -1

// 배분하기 위하여 준비시간, man, m/c의 시간을 구함
// 총 시간으로 시간을 배부하고 사용자가 수정한다. 
desset = dw_insert.getitemdecimal(Lrow, "morout_esset")
desman = dw_insert.getitemdecimal(Lrow, "morout_esman")
desmch = dw_insert.getitemdecimal(Lrow, "morout_esmch")


/********************************************************************************************/
/* 0나누기 에러 - 송병호 - 2001.09.28 */
if (desset + desman + desmch) > 0 then
	dsetrate = desset / (desset + desman + desmch) 
	dmanrate = desman / (desset + desman + desmch)
	dmchrate = desmch / (desset + desman + desmch)
else
	dsetrate = 0
	dmanrate = 0
	dmchrate = 0
end if
/********************************************************************************************/


// 비율별로 시간계산을 한다.
dset = truncate(dtotal * dsetrate, 2)
dman = truncate(dtotal * dmanrate * Linwon, 2)

// 휴식시간은 Man H/R기준인 경우에만 가감한다.
if dw_insert.getitemstring(Lrow, "morout_esgbn") = '1' and dman > (dfirtime + dsectime) Then
   dman = dman - (dfirtime + dsectime)	
End if
dmch = truncate(dtotal * dmchrate, 2)

if IsNull( dSet ) then dSet = 0
if IsNull( dman ) then dman = 0
if IsNull( dmch ) then dmch = 0

dw_insert.setitem(Lrow, "toset", dset)

// Man 시간 보고가 잘못 된 경우 (예를 들어서 점심시간이 12:00~13:00 인데 11:50~12:10으로 보고하면 Minus가 나타남
if dman < 0 then
	f_message_chk(177, '완료시간')
	return -1
End if
dw_insert.setitem(Lrow, "toman", dman)
dw_insert.setitem(Lrow, "tomch", dmch)
dw_insert.setitem(Lrow, "sotim", dset + dman + dmch)

return 1
end function

public function string wf_setfilter ();/****************************************************************************************/
/* 작지번호 필터링 - 2001.11.13 - 송추가 */
String	sPordno, sFilter

dw_head.AcceptText()
sPordno = trim(dw_head.object.pordno[1])

if IsNull(sPordno) or sPordno = '' then
else
	sFilter = "( Pos ( morout_pordno,'" + sPordno + "' ) > 0 )"
	dw_hist.SetFilter(sFilter)
	dw_hist.Filter()
end if	
/****************************************************************************************/

return sFilter

end function

public function integer wf_insert ();// 선택된 자료를 기준으로 iNSERT하면서 검색

string spordno, sopseq, scdate, strdate, enddate, stime, etime, sshpjpno, ssigbn
Long Lrow, Linsert, Lcnt
Decimal  {2} dtotman, dtotset, dtotal, dremman, dremset, desset, desman, desmch, dsetrate, dmanrate, dacqty
decimal {3} dsiqty

dw_head.accepttext()
dw_hist.accepttext()
if dw_hist.rowcount() < 1 then return -1

strdate = dw_head.getitemstring(1, "strdate")
stime   = dw_head.getitemstring(1, "strtime")
enddate = dw_head.getitemstring(1, "enddate")
etime   = dw_head.getitemstring(1, "endtime")
ssigbn  = dw_head.getitemstring(1, "sigbn")

dtotal = f_daytimeterm(strdate, enddate, stime, etime)

For Lrow = 1 to dw_hist.rowcount()
	

	if dw_head.getitemstring(1, "jagbn") = 'Y' then		/* 신규 등록인 경우 */
	
		if dw_hist.getitemstring(Lrow, "sel") = 'N' then continue
			
		spordno 	= dw_hist.getitemstring(Lrow, "morout_pordno")
		sopseq  	= dw_hist.getitemstring(Lrow, "morout_opseq")		
		
		if ssigbn = '1' then //정상
		
			sshpjpno = dw_hist.getitemstring(Lrow, "shpjpno")
			dacqty  = dw_hist.getitemdecimal(Lrow, "acqty")
			dsiqty  = dw_hist.getitemdecimal(Lrow, "siqty")		
		
			if dw_setup.retrieve(gs_sabu, spordno, sopseq, dacqty, sshpjpno, dacqty) > 0 then
				dw_setup.setitem(1, "waqty", dacqty)
				dw_setup.RowsCopy(dw_setup.GetRow(), dw_setup.RowCount(), Primary!, dw_insert, 1, Primary!)
			end if;
		Elseif ssigbn = '2' then //수리
			if dw_setup.retrieve(gs_sabu, spordno, sopseq) > 0 then
				dw_setup.setitem(1, "waqty", dacqty)
				dw_setup.RowsCopy(dw_setup.GetRow(), dw_setup.RowCount(), Primary!, dw_insert, 1, Primary!)
			end if;			
		End if

	Else
		
		if dw_hist.getitemstring(Lrow, "sel") = 'N' then continue 

		spordno = dw_hist.getitemstring(Lrow, "shpjpno")
	
		if dw_setup.retrieve(gs_sabu, spordno) > 0 then
			dw_setup.RowsCopy(dw_setup.GetRow(), dw_setup.RowCount(), Primary!, dw_insert, 1, Primary!)
		end if;
		
		
	End if
	
Next

if dw_head.getitemstring(1, "jagbn") = 'Y' then		/* 신규인 경우 */
   dw_insert.setsort("morout_pordno A, morout_opseq A")
	dw_insert.sort()
End if

if dw_head.getitemstring(1, "jagbn") = 'Y' then		/* 신규 등록인 경우 */

	if dw_insert.rowcount() < 1 then
		f_message_chk(33, '작업지시내역')
		return -1
	End if
	
	For Lrow = 1 to dw_insert.rowcount()

		 wf_chango(Lrow)  // 창고, 인원, 작업자등을 기본으로 Setting
			
		 dw_insert.setitem(Lrow, "sdate", strdate)
		 dw_insert.setitem(Lrow, "edate", enddate)
		 dw_insert.setitem(Lrow, "stime", stime)
		 dw_insert.setitem(Lrow, "etime", etime)
		 
		 dw_insert.setitem(Lrow, "morout_wkctr", dw_head.getitemstring(1, "wkctr"))		 
		 dw_insert.setitem(Lrow, "wrkctr_wcdsc", dw_head.getitemstring(1, "wcdsc"))		 		 
			
		 wf_settime(Lrow)
	Next
	
	// MAN H/R에 대한 시간 재배분
	// 전체시간을 기준으로 MAN H/R만 기여한 시간만큼의 비율로 재계산한다. (1건 이상인 경우)
	dtotset = 0
	dtotman = 0
	
	if  dw_insert.rowcount() > 1 then
			For Lrow = 1 to dw_insert.rowcount()
				 dtotset =  dtotset + dw_insert.getitemdecimal(Lrow, "toset")
				 dtotman =  dtotman + dw_insert.getitemdecimal(Lrow, "toman")
			NExt	
		
			For Lrow = 1 to dw_insert.rowcount()
				
					desset = dw_insert.getitemdecimal(Lrow, "morout_esset")
					desman = dw_insert.getitemdecimal(Lrow, "morout_esman")
					desmch = dw_insert.getitemdecimal(Lrow, "morout_esmch")
					
					/********************************************************************************************/
					/* 0나누기 에러 - 송병호 - 2001.09.28 */
					if (desset + desman + desmch) > 0 then
						dsetrate = desset / (desset + desman + desmch) 
						dmanrate = desman / (desset + desman + desmch)
					else
						dsetrate = 0
						dmanrate = 0
					end if
					/********************************************************************************************/

				
					
				 if dtotman > 0 then
					 dremman = ceiling(((dw_insert.getitemdecimal(Lrow, "toman") / dtotman) * dtotal) * dmanrate)
					 dw_insert.setitem(Lrow, "toman", dremman)
				 End if
			 
				 if dtotset > 0 then		 
					 dremset = ceiling(((dw_insert.getitemdecimal(Lrow, "toset") / dtotset) * dtotal) * dsetrate)
					 dw_insert.setitem(Lrow, "toset", dremset)
				 End if
				 
				 dw_insert.setitem(Lrow, "sotim", dw_insert.getitemdecimal(Lrow, "toset") + &
															 dw_insert.getitemdecimal(Lrow, "toman") + &
															 dw_insert.getitemdecimal(Lrow, "tomch") )
															 														 
			NExt
		End if
		
	p_1.enabled = false
	p_nttabl.enabled = false
	p_holdstock.enabled = false
	p_del.enabled = false		
	p_mod.enabled = true
	
	dw_insert.setfocus()

Else
	
	if dw_insert.rowcount() < 1 then
		f_message_chk(33, '작업실적')
		return -1
	End if		
	
	For Lrow = 1 to dw_insert.rowcount()
		 dw_insert.SetItemStatus(Lrow, 0, Primary!, DataModified!)	
	Next
	
	p_1.enabled = true
	p_5.enabled = true
	p_del.enabled = true
	p_nttabl.enabled = true
	p_holdstock.enabled = true
	p_mod.enabled = false
	
	p_del.PictureName 	= 'C:\erpman\image\삭제_up.gif'
	
	dw_insert.setfocus()		
	
End if

p_1.enabled = true
p_nttabl.enabled = true
p_holdstock.enabled = true
	
p_1.PictureName 			= 'C:\erpman\image\불량폐기_up.gif'
p_nttabl.PictureName 	= 'C:\erpman\image\비가동요인_up.gif'
p_holdstock.PictureName = 'C:\erpman\image\사용자재_up.gif'



RETURN 1
end function

public function integer wf_requiredchk (ref long lcrow, ref string scolumn);Long 	  lrow, lcnt
String  sreff, sreff1, sitdsc, sispec, sitnbr, sWanlot, sBanlot, sIttyp
integer ireturn
time		tchk

w_mdi_frame.sle_msg.text = "자료를 check하고 있읍니다."

dw_insert.accepttext()
lrow = dw_insert.rowcount()


// 완제품에 대한 입고LOT 필수check 여부
select dataname
  into :swanlot
  from syscnfg
 where sysgu = 'Y' and serial = 25 and lineno = '3';
 
if sqlca.sqlcode <> 0 or isnull(swanlot) or trim(sWanlot) = '' then
	sWanlot = 'Y'
end if

// 반제품에 대한 입고LOT 필수check 여부
select dataname
  into :sBanlot
  from syscnfg
 where sysgu = 'Y' and serial = '25' and lineno = '2';
 
if sqlca.sqlcode <> 0 or isnull(sBanlot) or trim(sBanlot) = '' then
	sBanlot = 'Y'
end if

For Lcnt = 1 to dw_insert.rowcount()

	// 작업 시작 일자 check
	if f_datechk(dw_insert.getitemstring(lcnt, "sdate")) = -1 then
		f_message_chk(35, "시작일자")
		scolumn = "sdate"
		return -1
	end if
		
	// 작업 시작 시간 check
	sreff = dw_insert.getitemstring(lcnt, "stime")
	if isnull(sreff)  or trim(sreff) = '' then
		f_message_chk(1400,'[작업시작시간]') 
		scolumn = "stime"
		RETURN  -1
	end if
	if not Istime(left(sreff, 2) + ':' + right(sreff, 2)) then
		f_message_chk(1400,'[작업시작시간]') 
		dw_insert.setitem(lcnt, "toset", 0)
		dw_insert.setitem(lcnt, "toman", 0)
		dw_insert.setitem(lcnt, "tomch", 0)
		dw_insert.setitem(lcnt, "sotim", 0)
		dw_insert.setitem(lcnt, "stime", '')
		scolumn = "stime"
		RETURN  -1	
	end if
	
	// 작업 종료 일자 check
	if f_datechk(dw_insert.getitemstring(lcnt, "edate")) = -1 then
		f_message_chk(35, "종료일자")
		scolumn = "edate"
		return -1	
	end if
	
	// 작업 종료 시간
	sreff = dw_insert.getitemstring(lcnt, "etime")
	if isnull(sreff)  or trim(sreff) = '' then
		f_message_chk(1400,'[작업시작시간]') 
		scolumn = "etime"
		RETURN  -1
	end if
	if not Istime(left(sreff, 2) + ':' + right(sreff, 2)) then
		f_message_chk(1400,'[작업시작시간]') 
		dw_insert.setitem(lcnt, "toset", 0)
		dw_insert.setitem(lcnt, "toman", 0)
		dw_insert.setitem(lcnt, "tomch", 0)
		dw_insert.setitem(lcnt, "sotim", 0)
		dw_insert.setitem(lcnt, "etime", '')
		scolumn = "etime"
		RETURN  -1	
	end if
			
	if isnull(dw_insert.getitemdecimal(lcnt, "toiwn"))  or &
		dw_insert.getitemdecimal(lcnt, "toiwn") < 1  then
		scolumn = "toiwn"
		f_message_chk(1400,'[투입인원]') 
		RETURN  -1
	end if
	
	if isnull(dw_insert.getitemdecimal(lcnt, "sotim"))  or &
		dw_insert.getitemdecimal(lcnt, "sotim") < 1  then
		scolumn = "sotim"
		f_message_chk(1400,'[소요시간]') 
		RETURN  -1	
	end if
	
	if dw_head.getitemstring(1, "jagbn") = 'Y' then		/* 신규인 경우 에 만 check하고 수정에서는 품번을 수정 못 함*/
		if isnull(dw_insert.getitemstring(lcnt, "morout_itnbr"))  or &
			trim(dw_insert.getitemstring(lcnt, "morout_itnbr")) =  ""  then
			scolumn = "morout_itnbr"
			f_message_chk(1400,'[품번]') 
			RETURN  -1	
		end if
	
		if isnull(dw_insert.getitemstring(lcnt, "morout_pspec"))  or &
			trim(dw_insert.getitemstring(lcnt, "morout_pspec")) =  ""  then
			dw_insert.setitem(lcnt, "morout_pspec", '.')
		end if
	end if
	
	/* 잔량check  < Y = 완료수량 - (이전양품 + 이전불량 + 이전폐기) + 
													양품 +     불량 +     폐기 	*/
				
	IF dw_head.getitemstring(1, "jagbn") = 'Y' THEN		/* 신규인 경우 */
		if dw_insert.getitemdecimal(lcnt, "janqty") <  &
			dw_insert.getitemdecimal(lcnt, "waqty") + &
			dw_insert.getitemdecimal(lcnt, "buqty") + &
			dw_insert.getitemdecimal(lcnt, "ppqty") then
			f_message_chk(96,'[잔량]') 
			scolumn = "waqty"			
			return -1	
		end if
	ELSE
		if dw_insert.getitemdecimal(lcnt, "janqty") <  &
			dw_insert.getitemdecimal(lcnt, "waqty") + &
			dw_insert.getitemdecimal(lcnt, "buqty") + &
			dw_insert.getitemdecimal(lcnt, "ppqty") - &
			dw_insert.getitemdecimal(lcnt, "old_coqty") - &
			dw_insert.getitemdecimal(lcnt, "old_peqty") - &
			dw_insert.getitemdecimal(lcnt, "old_faqty") then
			f_message_chk(96,'[잔량]') 
			scolumn = "waqty"			
			return -1	
		end if
	END IF
			
	if dw_insert.getitemdecimal(lcnt, "waqty") < 0  then
		scolumn = "waqty"
		f_message_chk(1400,'[양품]') 
		RETURN  -1
	end if
			
	if dw_insert.getitemdecimal(lcnt, "buqty") < 0  then
		scolumn = "buqty"
		f_message_chk(1400,'[불량]') 
		RETURN  -1
	end if
	
	if dw_insert.getitemdecimal(lcnt, "ppqty") < 0  then
		scolumn = "ppqty"
		f_message_chk(1400,'[폐기]') 
		RETURN  -1
	end if
			
	ireturn = 0
	sreff = dw_insert.getitemstring(lcnt, "morout_wkctr")
	select a.wkctr, a.wcdsc, b.jocod, b.jonam
	  into :sitnbr, :sreff1, :sitdsc, :sispec
	  from wrkctr a, jomast b
	 where a.wkctr = :sreff and a.jocod = b.jocod (+);
	if sqlca.sqlcode <> 0 then
		f_message_chk(90,'[작업장]')
		setnull(sreff1)		
		setnull(sitnbr)
		setnull(sitdsc)
		setnull(sispec)
		ireturn = -1
	end if
	if not isnull(sreff1)  and isnull(sitdsc) then
		f_message_chk(91,'[조]')
		setnull(sreff1)
		setnull(sitnbr)
		setnull(sitdsc)
		setnull(sispec)
		ireturn = -1
	end if
	dw_insert.setitem(lcnt, "morout_wkctr", sitnbr)
	dw_insert.setitem(lcnt, "wrkctr_wcdsc", sreff1)
	dw_insert.setitem(lcnt, "morout_jocod", sitdsc)
	dw_insert.setitem(lcnt, "jomast_jonam", sispec)
	if ireturn  = -1 then 
		scolumn = "morout_wkctr"
		return -1
	end if
	
	ireturn = 0
	sreff = dw_insert.getitemstring(lcnt, "morout_mchcod")
	if isnull(sreff) or trim(sreff) = '' then
	else	
		select mchnam
		  into :sreff1
		  from mchmst
		 where sabu = :gs_sabu and mchno = :sreff;
		if sqlca.sqlcode <> 0 then
			f_message_chk(92,'[설비]')
			setnull(sreff)
			setnull(sreff1)
			ireturn = -1
		end if
		dw_insert.setitem(lcnt, "mchmst_mchnam", sreff1)
		if ireturn  = -1 then 
			scolumn = "morout_mchcod"
			return -1
		end if
	end if
	
	 if dw_insert.getitemstring(lcnt, "lastc")  = '3' or &
		 dw_insert.getitemstring(lcnt, "lastc")  = '9' then
		 if isnull(dw_insert.getitemstring(lcnt, "gubun")) then
			 f_message_chk(1400,'[입고창고]') 
			 scolumn = "gubun"
			 return -1	
		 end if
	  end if
	
	 sItnbr = dw_insert.getitemstring(Lcnt, "morout_itnbr")
	 Select ittyp into :sittyp from itemas 
	  where itnbr = :sItnbr;
	
	 if dw_insert.getitemstring(lcnt, "lastc")  = '3' or &
		 dw_insert.getitemstring(lcnt, "lastc")  = '9' then
		 if (sittyp = '1' and sWanlot = 'Y' )  or &
			 (sittyp = '2' and sBanlot = 'Y' )  Then 
			 if isnull(dw_insert.getitemstring(lcnt, "lots"))  or &
				 trim(dw_insert.getitemstring(lcnt, "lots")) = '' then
				 f_message_chk(1400,'[LOT번호]') 
				 scolumn = "lots"
				 return -1	
			 end if
		 end if
	 end if
	

	 IF is_chk = 'Y' then 
		 if isnull(dw_insert.getitemstring(lcnt, "empname"))  or &
			 trim(dw_insert.getitemstring(lcnt, "empname")) = '' then
			 f_message_chk(1400,'[작업자]') 
			 scolumn = "empno"
			 return -1	
		 end if		  
	 END IF
NExt
	 

return 1
end function

public function integer wf_chango (long lrow);
dec {2} dsilrate

 // 최종공정인 경우에는 입고창고 를 move
For Lrow = 1 to dw_insert.rowcount()
	if dw_insert.getitemstring(Lrow, "lastc")  = '3' or &		
		dw_insert.getitemstring(Lrow, "lastc")  = '9' Then
		dw_insert.setitem(Lrow, "gubun", dw_insert.getitemstring(Lrow, "ipchango"))
		dw_insert.setitem(Lrow, "gubunname", dw_insert.getitemstring(Lrow, "ipname"))		
	End if
	dw_insert.setitem(Lrow, "empno", dw_head.getitemstring(1, "empno"))
	dw_insert.setitem(Lrow, "empname", dw_head.getitemstring(1, "empnm"))
	dw_insert.setitem(Lrow, "toiwn", dw_insert.getitemdecimal(Lrow, "morout_esinw"))
	
	// 실적가중치를 적용
	dsilrate = dw_insert.getitemdecimal(Lrow, "morout_stdmn")
	if isnull(dsilrate) or dsilrate  < 1 then dsilrate = 1

Next

return 1
end function

public function integer wf_save ();Long 	  lrow, lcnt, lirow, ljpno, lseq, lipjpno
String  sreff, sreff1, sitdsc, sispec, sitnbr, scolumn, scdate, serror, hsjpno, hsjpjpno, smaxno, snull
integer ireturn
decimal {2} droqty 

w_mdi_frame.sle_msg.text = "자료를 저장하고 있읍니다."

SetNull( sNull )

ds_update.dataobject = "d_pdt_02500_save"
ds_update.settransobject(sqlca)

dw_insert.accepttext()
lrow = dw_insert.rowcount()
scdate = f_today()

w_mdi_frame.sle_msg.text = "실적번호를 채번 중............."
ljpno = sqlca.fun_junpyo(gs_sabu, scdate, 'N1')
if ljpno = 0 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(51,'[생산실적 전표번호]')	
	rollback;
	return -1
else
	commit;
End if
isjpno = scdate + string(ljpno, '0000')

w_mdi_frame.sle_msg.text = "실적자료를 SETTING 중............."
For lcnt = 1 to lrow
		
		lirow = ds_update.insertrow(0)
		lseq++

		ds_update.setitem(lirow, "sabu", gs_sabu)
		ds_update.setitem(lirow, "shpjpno", scdate+string(ljpno, '0000')+string(lseq, '000'))
		dw_insert.setitem(lcnt, "shpjpno", scdate+string(ljpno, '0000')+string(lseq, '000'))
		
		hsjpno = scdate+string(ljpno, '0000')+string(lseq, '000')
		
		ds_update.setitem(lirow, "itnbr", dw_insert.getitemstring(lcnt, "morout_itnbr"))
		if isnull(dw_insert.getitemstring(lcnt, "morout_pspec")) or &
		   trim(dw_insert.getitemstring(lcnt, "morout_pspec")) = '' then
			ds_update.setitem(lirow, "pspec", '.')
		else
			ds_update.setitem(lirow, "pspec", dw_insert.getitemstring(lcnt, "morout_pspec"))
		end if
		ds_update.setitem(lirow, "wkctr", dw_insert.getitemstring(lcnt, "morout_wkctr"))
		ds_update.setitem(lirow, "pdtgu", dw_insert.getitemstring(lcnt, "momast_pdtgu"))
		ds_update.setitem(lirow, "mchcod", dw_insert.getitemstring(lcnt, "morout_mchcod"))
		ds_update.setitem(lirow, "jocod", dw_insert.getitemstring(lcnt, "morout_jocod"))
		ds_update.setitem(lirow, "opemp",  dw_insert.getitemstring(lcnt, "empno"))
		ds_update.setitem(lirow, "sidat", dw_insert.getitemstring(lcnt, "edate"))
		ds_update.setitem(lirow, "inwon", dw_insert.getitemdecimal(lcnt, "toiwn"))
		ds_update.setitem(lirow, "totim", dw_insert.getitemdecimal(lcnt, "sotim"))
		ds_update.setitem(lirow, "stime", dw_insert.getitemstring(lcnt, "stime"))
		ds_update.setitem(lirow, "etime", dw_insert.getitemstring(lcnt, "etime"))
		ds_update.setitem(lirow, "pordno", dw_insert.getitemstring(lcnt, "morout_pordno"))
//		if dw_head.getitemstring(1, "sigbn") = '1' and &
//			dw_insert.getitemstring(Lcnt, "sigbn") = '3' then  // 재작업 검사인 경우 수리로 저장
//			ds_update.setitem(lirow, "sigbn", '2')
//		Else
			ds_update.setitem(lirow, "sigbn", dw_head.getitemstring(1, "sigbn"))
//		End if

		ds_update.setitem(lirow, "purgc", dw_insert.getitemstring(lcnt, "morout_purgc"))
		droqty = dw_insert.getitemdecimal(lcnt, "waqty") + &
					dw_insert.getitemdecimal(lcnt, "buqty") + &
					dw_insert.getitemdecimal(lcnt, "ppqty")
		ds_update.setitem(lirow, "roqty", droqty)
		if dw_head.getitemstring(1, "sigbn") = '2' then
			ds_update.setitem(lirow, "suqty", dw_insert.getitemdecimal(lcnt, "waqty"))
		end if
		ds_update.setitem(lirow, "faqty", dw_insert.getitemdecimal(lcnt, "buqty"))
		ds_update.setitem(lirow, "peqty", dw_insert.getitemdecimal(lcnt, "ppqty"))
		ds_update.setitem(lirow, "coqty", dw_insert.getitemdecimal(lcnt, "waqty"))

		if dw_insert.getitemdecimal(lcnt, "waqty") >= dw_insert.getitemdecimal(lcnt, "janqty") then
			ds_update.setitem(lirow, "ji_gu", 'Y')
		else
			ds_update.setitem(lirow, "ji_gu", 'N')
		end if
		
		hsjpjpno = trim(dw_insert.getitemstring(lcnt, "siljpno"))
		
		// 검사정보
		ds_update.setitem(lirow, "yebiv3", 		 hsjpjpno)
		ds_update.setitem(lirow, "decision_yn", dw_insert.getitemstring(lcnt, "decision_yn"))
		ds_update.setitem(lirow, "silyoqty", 	 dw_insert.getitemdecimal(lcnt, "silyoqty"))

 		ds_update.setitem(lirow, "insgu",  dw_insert.getitemstring(lcnt, "morout_qcgub"))
		ds_update.setitem(lirow, "lotsno", dw_insert.getitemstring(lcnt, "lots"))
		ds_update.setitem(lirow, "ipgub",  dw_insert.getitemstring(lcnt, "gubun"))
		ds_update.setitem(lirow, "opsno",  dw_insert.getitemstring(lcnt, "morout_opseq"))
		ds_update.setitem(lirow, "lastc",  dw_insert.getitemstring(lcnt, "lastc"))
		ds_update.setitem(lirow, "de_lastc",  dw_insert.getitemstring(lcnt, "rlastc"))
		/* 최종공정인 경우에만 입고번호를 삽입 */
		if dw_insert.getitemstring(lcnt, "lastc") = '3' or &
			dw_insert.getitemstring(lcnt, "lastc") = '9' then
			lipjpno = sqlca.fun_junpyo(gs_sabu, scdate, 'C0')
			if lipjpno = 0 then
				w_mdi_frame.sle_msg.text = ''
				f_message_chk(51,'[입고예정번호]')	
				rollback;
				return -1
			else
				commit;
			End if			
			ds_update.setitem(lirow, "ipjpno", scdate+string(lipjpno, '0000')+'001')
		end if
		
		// 시작일자 및 시간내역을 저장
		ds_update.setitem(lirow, "stdat",  dw_insert.getitemstring(lcnt, "sdate"))
		ds_update.setitem(lirow, "rsset",  dw_insert.getitemdecimal(lcnt, "toset"))
		ds_update.setitem(lirow, "rsman",  dw_insert.getitemdecimal(lcnt, "toman"))
		ds_update.setitem(lirow, "rsmch",  dw_insert.getitemdecimal(lcnt, "tomch"))
		ds_update.setitem(lirow, "silgbn", '3')		// 일괄 실적보고로 작성
		
		// 검사의뢰 전표에 현재전표번호를 저장(수량 실적이 있는 경우에만) / 정상
		if dw_head.getitemstring(1, "sigbn") = '1' and ds_update.getitemdecimal(lirow, "roqty") > 0 then
			SetNull( sMaxNo)
			select max(shpjpno) into :smaxno from shpact
			 where sabu = :gs_sabu And yebiv3 = :hsjpjpno;
			if IsNull( smaxno ) or trim( smaxno ) = '' then
				Update shpact set yebid1 = nvl(yebid1, 0) + :droqty, siljpno = :hsjpno
				 where sabu = :gs_sabu And shpjpno = :hsjpjpno;
			Else
				if smaxno < hsjpno then
					smaxno = hsjpno
				end if
				
				Update shpact set yebid1 = nvl(yebid1, 0) + :droqty, siljpno = :smaxno
				 where sabu = :gs_sabu And shpjpno = :hsjpjpno;				
			End if
			
			if sqlca.sqlcode <> 0  or sqlca.sqlnrows <> 1 then
				f_message_chk(32, '[의뢰전표저장]')
				rollback;
				return -1
			End if
			
		Elseif dw_head.getitemstring(1, "sigbn") = '2' and ds_update.getitemdecimal(lirow, "roqty") > 0 then
			ds_update.setitem(lirow, "siljpno", snull)
		Else
			ds_update.setitem(lirow, "siljpno", 		snull)
			ds_update.setitem(lirow, "decision_yn", 	snull)
			ds_update.setitem(lirow, "silyoqty",  0)
		End if	
	 
Next

w_mdi_frame.sle_msg.text = "실적자료를 저장 中............."
if ds_update.update() = -1 then
	f_message_chk(-20262,'[자료저장]') 
	w_mdi_frame.sle_msg.text = ''
	rollback;
	return -1
end if	

w_mdi_frame.sle_msg.text = ""
return 1
end function

public subroutine wf_reset ();rollback;
string snull

setnull(snull)

dw_insert.setfilter("")
dw_insert.filter()

p_inq.enabled = true
p_mod.enabled = false
p_can.enabled = false
p_del.enabled = false

p_nttabl.enabled = false
p_holdstock.enabled = false
p_1.enabled = false
p_4.enabled = false
p_5.enabled = false

p_inq.PictureName = 'C:\erpman\image\조회_up.gif'
p_mod.PictureName = 'C:\erpman\image\저장_d.gif'
p_can.PictureName = 'C:\erpman\image\취소_d.gif'
p_del.PictureName = 'C:\erpman\image\삭제_d.gif'
p_nttabl.PictureName = 'C:\erpman\image\비가동요인_d.gif'
p_holdstock.PictureName = 'C:\erpman\image\사용자재_d.gif'
p_1.PictureName = 'C:\erpman\image\불량폐기_d.gif'
p_4.PictureName = 'C:\erpman\image\실적보고_d.gif'
p_5.PictureName = 'C:\erpman\image\일괄삭제_d.gif'


dw_hist.reset()
dw_insert.reset()
dw_head.enabled = true
dw_head.setitem(1, "strdate", f_today())
dw_head.setitem(1, "enddate", f_today())
dw_head.setcolumn("wkctr")
dw_head.setfocus()
dw_head.setitem(1, "strtime", "0830")
dw_head.setitem(1, "endtime", "1730")

ib_any_typing = false

f_mod_saupj(dw_head, 'saupj')


end subroutine

on w_pdt_02500.create
int iCurrent
call super::create
this.ds_update=create ds_update
this.dw_hist=create dw_hist
this.dw_setup=create dw_setup
this.p_4=create p_4
this.p_1=create p_1
this.p_nttabl=create p_nttabl
this.p_holdstock=create p_holdstock
this.p_5=create p_5
this.dw_head=create dw_head
this.pb_1=create pb_1
this.pb_2=create pb_2
this.pb_3=create pb_3
this.pb_4=create pb_4
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.ds_update
this.Control[iCurrent+2]=this.dw_hist
this.Control[iCurrent+3]=this.dw_setup
this.Control[iCurrent+4]=this.p_4
this.Control[iCurrent+5]=this.p_1
this.Control[iCurrent+6]=this.p_nttabl
this.Control[iCurrent+7]=this.p_holdstock
this.Control[iCurrent+8]=this.p_5
this.Control[iCurrent+9]=this.dw_head
this.Control[iCurrent+10]=this.pb_1
this.Control[iCurrent+11]=this.pb_2
this.Control[iCurrent+12]=this.pb_3
this.Control[iCurrent+13]=this.pb_4
this.Control[iCurrent+14]=this.rr_1
this.Control[iCurrent+15]=this.rr_2
end on

on w_pdt_02500.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.ds_update)
destroy(this.dw_hist)
destroy(this.dw_setup)
destroy(this.p_4)
destroy(this.p_1)
destroy(this.p_nttabl)
destroy(this.p_holdstock)
destroy(this.p_5)
destroy(this.dw_head)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.pb_3)
destroy(this.pb_4)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_insert.settransobject(sqlca)
dw_hist.settransobject(sqlca)
dw_HEAD.settransobject(sqlca)
dw_setup.settransobject(sqlca)

dw_head.insertrow(0)
dw_head.object.sfrom[1] = Left(f_today(),6) + '01'
dw_head.object.sto[1] = f_today()
dw_head.setfocus()

  SELECT "SYSCNFG"."DATANAME"  
    INTO :is_chk  
    FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'Y' ) AND  
         ( "SYSCNFG"."SERIAL" = 25 ) AND  
         ( "SYSCNFG"."LINENO" = '1' )   ;

if is_chk = '' or isnull(is_chk) then is_chk = 'N' 

wf_reset()
end event

type dw_insert from w_inherite`dw_insert within w_pdt_02500
integer x = 87
integer y = 1328
integer width = 4471
integer height = 924
integer taborder = 40
string dataobject = "d_pdt_02500_1"
boolean vscrollbar = true
boolean border = false
boolean livescroll = false
end type

event dw_insert::itemchanged;string   snull, sitnbr, sreff, sreff1, sitdsc, sispec, sjijil, sispec_code, scvcod, sopseq, sPordno, ssigbn
time     tchk
long     lrow, wnd
integer  ireturn
Decimal  {3}  dtime, dtime1, dSaVeqty, dPrqty, dPdqty, dsilrate, dreqty, dwaqty, dchkqty 

setnull(snull)

if this.getcolumnname() = "waqty" then
	dSaveqty = this.getitemdecimal(row, "waqty")
end if

lrow   = this.getrow()

this.accepttext()

IF GetColumnName() = "morout_itnbr"	THEN
	sItnbr = trim(GetText())
	ireturn = f_get_name4('품번', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code) 
	setitem(lrow, "morout_itnbr", sitnbr)	
	setitem(lrow, "itemas_itdsc", sitdsc)	
	setitem(lrow, "itemas_ispec", sispec)
	setitem(lrow, "itemas_jijil", sjijil)	
	setitem(lrow, "itemas_ispec_code", sispec_code)
	RETURN ireturn
ELSEIF GetColumnName() = "itemas_itdsc"	THEN
	sItdsc = trim(GetText())
	ireturn = f_get_name4('품명', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code) 
	setitem(lrow, "morout_itnbr", sitnbr)	
	setitem(lrow, "itemas_itdsc", sitdsc)	
	setitem(lrow, "itemas_ispec", sispec)
	setitem(lrow, "itemas_jijil", sjijil)	
	setitem(lrow, "itemas_ispec_code", sispec_code)
	RETURN ireturn
ELSEIF GetColumnName() = "itemas_ispec"	THEN
	sIspec = trim(GetText())
	ireturn = f_get_name4('규격', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code) 
	setitem(lrow, "morout_itnbr", sitnbr)	
	setitem(lrow, "itemas_itdsc", sitdsc)	
	setitem(lrow, "itemas_ispec", sispec)
	setitem(lrow, "itemas_jijil", sjijil)	
	setitem(lrow, "itemas_ispec_code", sispec_code)
	RETURN ireturn
ELSEIF GetColumnName() = "itemas_jijil"	THEN
	sjijil = trim(GetText())
	ireturn = f_get_name4('재질', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code) 
	setitem(lrow, "morout_itnbr", sitnbr)	
	setitem(lrow, "itemas_itdsc", sitdsc)	
	setitem(lrow, "itemas_ispec", sispec)
	setitem(lrow, "itemas_jijil", sjijil)	
	setitem(lrow, "itemas_ispec_code", sispec_code)
	RETURN ireturn
ELSEIF GetColumnName() = "itemas_ispec_code"	THEN
	sIspec_code = trim(GetText())
	ireturn = f_get_name4('규격코드', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code) 
	setitem(lrow, "morout_itnbr", sitnbr)	
	setitem(lrow, "itemas_itdsc", sitdsc)	
	setitem(lrow, "itemas_ispec", sispec)
	setitem(lrow, "itemas_jijil", sjijil)	
	setitem(lrow, "itemas_ispec_code", sispec_code)
	RETURN ireturn
ELSEIF GetColumnName() = "morout_pspec"	THEN
   if isnull(trim(this.gettext())) or trim(this.gettext()) = "" then
		f_message_chk(30, '사양')
		dw_insert.setitem(lrow, 'morout_pspec', '.')
		return 1
   end if 

	RETURN 
elseif this.getcolumnname() = "gubun" then
	sitnbr = this.gettext()
	SetNull(sitdsc)
	Select cvnas into :sitdsc from vndmst where cvcod = :sitnbr;
	setitem(Lrow, "gubunname", sitdsc)
	IF ISNULL(sitdsc) or trim(sitdsc) = '' then
		setitem(Lrow, "gubun", snull)
		setitem(Lrow, "gubunname", snull)		
		return 1
	End if

	 if this.getitemstring(lrow, "lastc") = '3' or &
		 this.getitemstring(lrow, "lastc") = '9' then
		 if isnull(dw_insert.getitemstring(lrow, "gubun")) then
			 f_message_chk(1400,'[입고창고]') 
		 	 RETURN  1	
		 end if
	  end if		 		
elseif this.getcolumnname() = "empno" then
   sitnbr = trim(this.gettext())
	 
  	sitdsc = f_get_reffer('45', sitnbr) 
	if isnull(sitdsc) or Trim(sitdsc) = '' then
		this.setitem(lRow, "empno", sNull)
		this.setitem(lRow, "empname", sNull)		
		return 1
	end if
	this.setitem(1, "empname", sitdsc)
elseif this.getcolumnname() = 'sdate' then
	if f_datechk(gettext()) = -1 then
		f_message_chk(35, "시작일자")
		setitem(Lrow, "sdate",   snull)
		return 1
	end if
	
	if wf_settime(Lrow) = -1 then
		dw_insert.setitem(lrow, 'toset', 0)
		dw_insert.setitem(lrow, 'toman', 0)
		dw_insert.setitem(lrow, 'tomch', 0)
		dw_insert.setitem(lrow, 'sotim', 0)
		return 1 		
	end if
	
ELSEif this.getcolumnname() = "stime"  then
	sreff = gettext()
   if not Istime(left(sreff, 2) + ':' + right(sreff, 2)) then
		f_message_chk(176, "시작시간")
		setitem(Lrow, "stime",   snull)
		dw_insert.setitem(Lrow, 'stime', snull)
		dw_insert.setitem(lrow, 'toset', 0)
		dw_insert.setitem(lrow, 'toman', 0)
		dw_insert.setitem(lrow, 'tomch', 0)
		dw_insert.setitem(lrow, 'sotim', 0)
		return 1 
   end if 
	
	if wf_settime(Lrow) = -1 then
		dw_insert.setitem(lrow, 'toset', 0)
		dw_insert.setitem(lrow, 'toman', 0)
		dw_insert.setitem(lrow, 'tomch', 0)
		dw_insert.setitem(lrow, 'sotim', 0)		
		return 1 		
	end if
	
elseif this.getcolumnname() = 'edate' then	
	if f_datechk(gettext()) = -1 then
		f_message_chk(35, "완료일자")
		setitem(Lrow, "edate",   snull)
		return 1
	end if
	
	if wf_settime(Lrow) = -1 then
		dw_insert.setitem(lrow, 'toset', 0)
		dw_insert.setitem(lrow, 'toman', 0)
		dw_insert.setitem(lrow, 'tomch', 0)
		dw_insert.setitem(lrow, 'sotim', 0)		
		return 1 		
	end if	
	
ELSEif this.getcolumnname() = "etime"  then
	sreff = gettext()
   if not Istime(left(sreff, 2) + ':' + right(sreff, 2))  then
		f_message_chk(176, "완료시간")		
		dw_insert.setitem(Lrow, 'etime', snull)
		dw_insert.setitem(lrow, 'toset', 0)
		dw_insert.setitem(lrow, 'toman', 0)
		dw_insert.setitem(lrow, 'tomch', 0)
		dw_insert.setitem(lrow, 'sotim', 0)
		return 1 
   end if 
	
	if wf_settime(Lrow) = -1 then
		dw_insert.setitem(Lrow, 'stime', snull)
		dw_insert.setitem(lrow, 'toset', 0)
		dw_insert.setitem(lrow, 'toman', 0)
		dw_insert.setitem(lrow, 'tomch', 0)
		dw_insert.setitem(lrow, 'sotim', 0)		
		return 1 		
	end if
		
elseif this.getcolumnname() = "toiwn"  then
	dtime = dec(gettext())
   if isnull(dec(this.gettext())) then 
		dtime = 0
   end if 

	// 인원수는 MAN H/R에만 적용한다.
	dw_insert.setitem(Lrow, "toman", dw_insert.getitemdecimal(Lrow, "toman") * dtime)
	
	dw_insert.setitem(Lrow, "sotim", dw_insert.getitemdecimal(Lrow, "toset") + &
												dw_insert.getitemdecimal(Lrow, "toman") + &
												dw_insert.getitemdecimal(Lrow, "tomch"))	
elseif this.getcolumnname() = "toset"  then
	dtime = dec(gettext())
	dw_insert.setitem(Lrow, "sotim", dtime + &
												dw_insert.getitemdecimal(Lrow, "toman") + &
												dw_insert.getitemdecimal(Lrow, "tomch"))
elseif this.getcolumnname() = "toman"  then
	dtime = dec(gettext())
	dw_insert.setitem(Lrow, "sotim", dw_insert.getitemdecimal(Lrow, "toset") + &
												dtime + &
												dw_insert.getitemdecimal(Lrow, "tomch"))
elseif this.getcolumnname() = "toman"  then
	dtime = dec(gettext())
	dw_insert.setitem(Lrow, "sotim", dw_insert.getitemdecimal(Lrow, "toset") + &
												dw_insert.getitemdecimal(Lrow, "tomch") + &
												dtime)
elseif this.getcolumnname() = "waqty"  then	
	
	dTime 	= dec(this.gettext())
	ssigbn	= dw_head.getitemstring(1, "sigbn")
	if ssigbn = '2' then  // 수리일 때 만 check
		dreqty	= getitemdecimal(Lrow, "janqty")		
		dchkqty  = dreqty - (dtime + getitemdecimal(Lrow, "buqty") + getitemdecimal(Lrow, "ppqty"))				 
		if dchkqty < 0 then
			MessageBox("수량", "잔량이 Minus가 발생합니다", stopsign!)
			setitem(Lrow, "waqty", 0)
			setitem(Lrow, "buqty", 0)
			setitem(Lrow, "ppqty", 0)
			setitem(Lrow, "decision_yn", 'Y')
			setitem(Lrow, "roqty", 0)
			return 1
		end if
		setitem(Lrow, "roqty", dtime + getitemdecimal(Lrow, "buqty") + getitemdecimal(Lrow, "ppqty"))
	End if
elseif this.getcolumnname() = "buqty"  then	
	
	dTime 	= dec(this.gettext())
	ssigbn	= dw_head.getitemstring(1, "sigbn")
	if ssigbn = '1' then		// 정상일때만 check
		dreqty	= getitemdecimal(Lrow, "reqty")
		dwaqty   = dreqty - (dTime	+ getitemdecimal(Lrow, "ppqty")) 
		Setitem(Lrow, "waqty", dwaqty)
		dchkqty  = dreqty - (dwaqty + dtime + getitemdecimal(Lrow, "ppqty"))					 
		if dwaqty < 0 or dchkqty < 0 then
			MessageBox("수량", "의뢰수량이 Minus가 발생합니다", stopsign!)
			setitem(Lrow, "waqty", getitemdecimal(Lrow, "reqty"))
			setitem(Lrow, "buqty", 0)
			setitem(Lrow, "ppqty", 0)
			setitem(Lrow, "decision_yn", 'Y')
			setitem(Lrow, "roqty", getitemdecimal(Lrow, "reqty"))
			return 1
		end if
		setitem(Lrow, "roqty", dwaqty + &
									  dtime  + &
									  getitemdecimal(Lrow, "ppqty"))
	End if

elseif this.getcolumnname() = "ppqty"  then	
	dTime 	= dec(this.gettext())
	ssigbn	= dw_head.getitemstring(1, "sigbn")
	if ssigbn = '1' then  // 정상일때만 check
		dreqty	= getitemdecimal(Lrow, "reqty")
		dwaqty   = dreqty - (dTime	+ getitemdecimal(Lrow, "buqty")) 
		Setitem(Lrow, "waqty", dwaqty)
		dchkqty  = dreqty - (dwaqty + dtime + getitemdecimal(Lrow, "buqty"))
					 
		if dwaqty < 0 or dchkqty < 0 then
			MessageBox("수량", "의뢰수량이 Minus가 발생합니다", stopsign!)
			setitem(Lrow, "waqty", getitemdecimal(Lrow, "reqty"))
			setitem(Lrow, "buqty", 0)
			setitem(Lrow, "ppqty", 0)
			setitem(Lrow, "decision_yn", 'Y')
			setitem(Lrow, "roqty", getitemdecimal(Lrow, "reqty"))
			return 1
		end if
	
		setitem(Lrow, "roqty", dwaqty + &
									  dtime  + &
									  getitemdecimal(Lrow, "buqty"))
  Elseif ssigbn = '2' then  // 수리일 때 만 checki
		dreqty	= getitemdecimal(Lrow, "janqty")		
		dchkqty  = dreqty - (getitemdecimal(Lrow, "waqty") + dtime + getitemdecimal(Lrow, "buqty"))				 
		if dchkqty < 0 then
			MessageBox("수량", "잔량이 Minus가 발생합니다", stopsign!)
			setitem(Lrow, "waqty", 0)
			setitem(Lrow, "buqty", 0)
			setitem(Lrow, "ppqty", 0)
			setitem(Lrow, "decision_yn", 'Y')
			setitem(Lrow, "roqty", 0)
			return 1
		end if
		setitem(Lrow, "roqty", getitemdecimal(Lrow, "waqty") + dtime + getitemdecimal(Lrow, "buqty"))
	End if

elseif this.getcolumnname() = "morout_wkctr" then
	ireturn = 0
	sreff = this.gettext()
	
	select a.wkctr, a.wcdsc, b.jocod, b.jonam
	  into :sitnbr, :sreff1, :sitdsc, :sispec
	  from wrkctr a, jomast b
	 where a.wkctr = :sreff and a.jocod = b.jocod (+);
	if sqlca.sqlcode <> 0 then
		f_message_chk(90,'[작업장]')
		setnull(sreff1)		
		setnull(sitnbr)
		setnull(sitdsc)
		setnull(sispec)
		ireturn = 1
	end if
	if not isnull(sreff1)  and isnull(sitdsc) then
		f_message_chk(91,'[조]')
		setnull(sreff1)
		setnull(sitnbr)
		setnull(sitdsc)
		setnull(sispec)
		ireturn = 1
	end if
	this.setitem(lrow, "morout_wkctr", sitnbr)
	this.setitem(lrow, "wrkctr_wcdsc", sreff1)
	this.setitem(lrow, "morout_jocod", sitdsc)
	this.setitem(lrow, "jomast_jonam", sispec)
	return ireturn
elseif this.getcolumnname() = "morout_mchcod" then
	ireturn = 0
	sreff = this.gettext()
	
	if isnull(sreff) or trim(sreff) = '' then
		this.setitem(lrow, "mchmst_mchnam", snull)
		return
	end if
	select mchnam
	  into :sreff1
	  from mchmst
	 where sabu = :gs_sabu and mchno = :sreff;
	if sqlca.sqlcode <> 0 then
		f_message_chk(92,'[설비]')
		setnull(sreff)
		setnull(sreff1)
		ireturn = 1
	end if
	this.setitem(lrow, "morout_mchcod",  sreff)
	this.setitem(lrow, "mchmst_mchnam", sreff1)
	return ireturn	
//elseif this.getcolumnname() = "lots" then
//	wnd =Handle(this)
//	f_toggle_eng(wnd)
end if

end event

event dw_insert::itemerror;RETURN 1
end event

event dw_insert::rbuttondown;string colname, sItnbr, sitdsc, sSpec
long   lrow

gs_code = ''
gs_codename = ''
gs_gubun = ''

colname = this.getcolumnname()
lrow    = this.getrow()

if colname = "morout_itnbr" or &
	colname = "itemas_itdsc" or &
	colname = "itemas_ispec" then
   gs_code = this.getitemstring(lrow, "morout_itnbr")
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then return
	this.SetItem(lrow,"morout_itnbr",gs_code)
   this.triggerevent(itemchanged!)
elseif colname = "morout_mchcod" then
		 gs_gubun    = this.getitemstring(lrow, "morout_wkctr")
		 gs_codename = this.getitemstring(lrow, "wrkctr_wcdsc")
		 open(w_mchmst_popup)
		 if isnull(gs_code) or gs_code = "" then return
		 this.setitem(lrow, "morout_mchcod", gs_code)
		 this.triggerevent(itemchanged!)
elseif colname = "morout_wkctr" then
		 gs_code = this.gettext()
		 open(w_workplace_popup)
		 if isnull(gs_code) or gs_code = "" then return
		 this.setitem(lrow, "morout_wkctr", gs_code)
		 this.triggerevent(itemchanged!)
elseif colname = "empno" then
		 gs_code = '45'
		 open(w_reffpf_all_popup)
		 if isnull(gs_code) or gs_code = "" then return
		 this.setitem(lrow, "empno", gs_code)
		 this.triggerevent(itemchanged!)		 
end if


end event

event dw_insert::doubleclicked;//IF ROW < 1  THEN RETURN 
//
//gs_code = this.getitemstring(row, 'morout_pordno')
//openwithparm(w_pdt_02135, dw_insert)

end event

event dw_insert::clicked;//w_mdi_frame.sle_msg.text = '작업지시번호 별 할당조회 => Double Click 하세요!'
end event

event dw_insert::updatestart;///* Update() function 호출시 user 설정 */
//long k, lRowCount
//
//lRowCount = this.RowCount()
//
//FOR k = 1 TO lRowCount
//   IF NewModified! = this.GetItemStatus(k, 0, Primary!) THEN
// 	   This.SetItem(k,'crt_user',gs_userid)
//   ELSEIF DataModified! = this.GetItemStatus(k, 0, Primary!) THEN 		
//	   This.SetItem(k,'upd_user',gs_userid)
//   END IF	  
//NEXT
//
//
end event

event dw_insert::scrollvertical;call super::scrollvertical;long ll_numrows

string ls_firstrow, ls_lastrow

ll_numrows = dw_insert.RowCount()

ls_firstrow = dw_insert.Object.Datawindow.FirstRowOnPage

ls_lastrow = dw_insert.Object.Datawindow.LastRowOnPage

w_mdi_frame.sle_msg.Text = "Rows " + ls_firstrow + " through " + ls_lastrow + " of " + String(ll_numrows)

dw_insert.setrow(dec(ls_lastrow))
dw_insert.scrolltorow(dec(ls_lastrow))

RETURN 0
end event

event dw_insert::itemfocuschanged;call super::itemfocuschanged;long wnd

this.accepttext()

wnd =Handle(this)
f_toggle_eng(wnd)
end event

type p_delrow from w_inherite`p_delrow within w_pdt_02500
boolean visible = false
integer x = 695
integer y = 2300
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_pdt_02500
boolean visible = false
integer x = 521
integer y = 2300
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_pdt_02500
boolean visible = false
integer x = 0
integer y = 2292
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_pdt_02500
boolean visible = false
integer x = 347
integer y = 2300
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_pdt_02500
integer x = 4416
integer taborder = 130
end type

type p_can from w_inherite`p_can within w_pdt_02500
integer x = 4242
end type

event p_can::clicked;call super::clicked;wf_reset()
end event

type p_print from w_inherite`p_print within w_pdt_02500
boolean visible = false
integer x = 174
integer y = 2292
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_pdt_02500
integer x = 3721
integer taborder = 20
end type

event p_inq::clicked;call super::clicked;string swkctr, strdate, enddate, sPdtgu, sigbn, swcdsc, get_data, shpsigbn, sitnbr, sFilter
long   k, lCount
String ls_saupj
// 조회조건 Error check
IF dw_head.accepttext() = -1 THEN RETURN 

swkctr 	= dw_head.object.wkctr[1]
swcdsc 	= dw_head.object.wcdsc[1]
if swkctr = '' or isnull(swkctr) then 
	swkctr = '%'
end if 

ls_saupj	= dw_head.GetItemString(1,"saupj") // 사업장

if dw_head.getitemstring(1, "jagbn") = 'Y' then		/* 신규인 경우 */
	if isnull(dw_head.getitemstring(1, "strdate")) or trim(dw_head.getitemstring(1, "strdate")) = '' then
		f_message_chk(30, '[시작일자]')
		dw_head.setcolumn("strdate")
		dw_head.setfocus()	
		return
	end if
	
	if isnull(dw_head.getitemstring(1, "strtime")) or trim(dw_head.getitemstring(1, "strtime")) = '' then
		f_message_chk(30, '[시작시간]')
		dw_head.setcolumn("strtime")
		dw_head.setfocus()
		return 
	end if
	
	if isnull(dw_head.getitemstring(1, "enddate")) or trim(dw_head.getitemstring(1, "enddate")) = '' then
		f_message_chk(30, '[완료일자]')
		dw_head.setcolumn("enddate")
		dw_head.setfocus()
		return
	end if
	
	if isnull(dw_head.getitemstring(1, "endtime")) or trim(dw_head.getitemstring(1, "endtime")) = '' then
		f_message_chk(30, '[완료시간]')
		dw_head.setcolumn("endtime")
		dw_head.setfocus()
		return
	end if
	
	if f_daytimeterm(dw_head.getitemstring(1, "strdate"),dw_head.getitemstring(1, "enddate"),&
						  dw_head.getitemstring(1, "strtime"),dw_head.getitemstring(1, "endtime")) <= 0 Then
		f_message_chk(159, "작업완료시간")
		dw_head.setcolumn("enddate")
		dw_head.setfocus()
		return 	
	end if	
Else
	strdate = trim(dw_head.object.sfrom[1])
	if strdate = '' or isnull(strdate) then 
		f_message_chk(30,'[완료일자]')
		dw_head.setcolumn('sfrom')
		dw_head.SetFocus()
		setpointer(arrow!)
		dw_insert.setredraw(true)
		return	
	end if 	
end if


Setpointer(hourglass!)

dw_hist.setredraw(false)

if dw_head.getitemstring(1, "jagbn") = 'Y' then		/* 신규인 경우 */
   sigbn = dw_head.object.sigbn[1]
	
	IF sigbn = '1'  then /* 정상 */
		dw_hist.dataobject = "d_pdt_02500_2"
		dw_hist.settransobject(sqlca)		
		
		dw_insert.dataobject = "d_pdt_02500_1"
		dw_insert.settransobject(sqlca)
		
		dw_setup.dataobject = "d_pdt_02500_1"
		dw_setup.settransobject(sqlca)

		/***********************************************************/
		/* 작지번호 필터링 - 2001.11.17 - 송추가 */
		sFilter = wf_setfilter() 
		/***********************************************************/
		
		//시스템관리에서 이전실적 체크여부
	   SELECT DATANAME  
		  INTO :get_data
		  FROM SYSCNFG  
		 WHERE SYSGU = 'Y' AND SERIAL = 25 AND LINENO = '4' ;
		
		if sqlca.sqlcode <> 0 then get_data = 'N'

		if get_data = 'Y' then //이전실적수량이 없으면 필터링
			if IsNull(sFilter) or sFilter = '' then
				dw_hist.SetFilter("ijun_qty > 0 and janqty > 0")
			else
				sFilter = sFilter + " and ijun_qty > 0 and janqty > 0 "
				dw_hist.SetFilter(sFilter)
			end if
			dw_hist.Filter()
			dw_insert.SetFilter("ijun_qty > 0 and janqty > 0")
			dw_insert.Filter()
		else
			if IsNull(sFilter) or sFilter = '' then
				dw_hist.SetFilter("janqty > 0")
			else
				sFilter = sFilter + " and janqty > 0 "
				dw_hist.SetFilter(sFilter)
			end if
			dw_hist.Filter()
		   dw_insert.SetFilter("janqty > 0")
			dw_insert.Filter()
		end if

	ELSEIF sigbn = '2'  then /* 수리 */
		dw_hist.dataobject = "d_pdt_02500_22"
		dw_hist.settransobject(sqlca)	
		
		dw_insert.dataobject = "d_pdt_02500_11"
		dw_insert.settransobject(sqlca)
		
		dw_setup.dataobject = "d_pdt_02500_11"
		dw_setup.settransobject(sqlca)
		
		/***********************************************************/
		/* 작지번호 필터링 - 2001.11.17 - 송추가 */
		sFilter = wf_setfilter() 
		/***********************************************************/
		
	END IF 
		
	strdate 	=  trim(dw_head.object.sfrom[1])
	enddate 	=  trim(dw_head.object.sto[1])
	
	if 	strdate 	= '' or isnull(strdate) then strdate = '10000101'
	if 	enddate 	= '' or isnull(enddate) then enddate = '99991231'
	if 	sitnbr 		= '' or isnull(sitnbr) then sitnbr = '%'
	
	if sigbn = '2' THEN // 수리인 경우에는 작업장의 생산팀을 기준으로 조회
		SELECT PDTGU
		  into :sPdtgu
		  FROM WRKCTR A
		 WHERE A.WKCTR = :swkctr;
		if sqlca.sqlcode <> 0 then
			spdtgu = '%'
		End if
		 
		if 	dw_hist.retrieve(gs_sabu, ls_saupj, strdate, enddate, spdtgu, sitnbr) = 0 then
			f_message_chk(56,'[작업지시내역(수리)]')
			dw_head.setfocus()
			setpointer(arrow!)
			dw_insert.setredraw(true)
			return
		end if			 
	else
		if 	dw_hist.retrieve(gs_sabu, ls_saupj, strdate, enddate, swkctr, sitnbr) = 0 then
			f_message_chk(56,'[작업지시내역(정상)]')
			dw_head.setfocus()
			setpointer(arrow!)
			dw_insert.setredraw(true)
			return
		end if			 			
	END IF
	
	s1 = strdate
	s2 = enddate
	s3 = swkctr
	s4 = sitnbr
	
else                                                                                   // ---- [ 수정 ] ---  //
	dw_hist.dataobject = "d_pdt_02500_3"
	dw_hist.settransobject(sqlca)		
	
	dw_insert.dataobject = "d_pdt_02500_31"
	dw_insert.settransobject(sqlca)
	
	dw_setup.dataobject = "d_pdt_02500_31"
	dw_setup.settransobject(sqlca)
	
	dw_hist.SetFilter("")			
	dw_insert.SetFilter("")
	dw_hist.Filter()
	dw_insert.Filter()
	
	/***********************************************************/
	/* 작지번호 필터링 - 2001.11.17 - 송추가 */
	sFilter = wf_setfilter() 
	/***********************************************************/

		
	shpsigbn  = dw_head.object.sigbn[1]
	
	if sitnbr = '' or isnull(sitnbr) then sitnbr = '%'
	 
	if 	dw_hist.retrieve(gs_sabu, ls_saupj, strdate, swkctr, shpsigbn, sitnbr) = 0 then
		f_message_chk(56,'[작업실적내역]')
		dw_head.setfocus()
		setpointer(arrow!)
		dw_insert.setredraw(true)
		return
	end if
	
	s1 = strdate
	s2 = swkctr
	s3 = shpsigbn
	s4 = sitnbr	
	
//	cb_4.triggerevent(clicked!)
	
End if

Setpointer(Arrow!)

dw_head.enabled 	= false
dw_hist.setredraw(true)
dw_hist.setfocus()

p_inq.enabled 	= false
p_4.enabled 		= true
p_mod.enabled 	= true
p_can.enabled 	= true

p_inq.PictureName 		= 'C:\erpman\image\조회_d.gif'
p_4.PictureName 		= 'C:\erpman\image\실적보고_up.gif'
p_mod.PictureName 	= 'C:\erpman\image\저장_up.gif'
p_can.PictureName 	= 'C:\erpman\image\취소_up.gif'
end event

type p_del from w_inherite`p_del within w_pdt_02500
integer x = 4069
end type

event p_del::clicked;call super::clicked;Long LSqlcode
decimal {2} droqty
string smaxno, hsjpjpno, hsjpno, ssigbn, ls_msgstr

if dw_insert.rowcount() > 0 then
	
	ls_msgstr = "전표번호 : " + dw_insert.getitemstring(1, "shpjpno") + '~n' + &
		"를 삭제하시겠읍니까?"

	If MessageBox("삭제확인", ls_msgstr, Question!,YesNo! ) = 1 Then
	
		droqty 		= dw_insert.getitemdecimal(dw_insert.rowcount(), "roqty")
		hsjpjpno		= dw_insert.getitemstring(dw_insert.rowcount(),  "shpact_yebiv3")
		ssigbn		= dw_insert.getitemstring(dw_insert.rowcount(),  "shpact_sigbn")
		
		dw_insert.deleterow(dw_insert.rowcount())
	end if
end if

if dw_insert.update() = -1 then
	rollback;	
	LSqlcode = dec(sqlca.sqlcode)
	f_message_chk(32,'[자료저장]') 	
	return
else
	
	SetNull( sMaxNo)
	if ssigbn = '1' then // 정상실적만 처리
		select max(shpjpno) into :smaxno from shpact
		 where sabu = :gs_sabu And yebiv3 = :hsjpjpno;
		if IsNull( smaxno ) or trim( smaxno ) = '' then
			Update shpact set yebid1 = 0, siljpno = null
			 where sabu = :gs_sabu And shpjpno = :hsjpjpno;
		Else
			Update shpact set yebid1 = nvl(yebid1, 0) - :droqty, siljpno = :smaxno
			 where sabu = :gs_sabu And shpjpno = :hsjpjpno;				
		End if
		if sqlca.sqlcode <> 0  or sqlca.sqlnrows <> 1 then
			f_message_chk(32, '[자료저장2]')
			rollback;
			return -1
		End if	
	End if
		
	commit;
end if

dw_hist.setredraw(false)
dw_hist.retrieve(gs_sabu, s1, s2, s3, s4, gs_saupj)
dw_hist.setredraw(true)

ib_any_typing = false

end event

type p_mod from w_inherite`p_mod within w_pdt_02500
integer x = 3895
end type

event p_mod::clicked;call super::clicked;string scolumn, ls_saupj
long lrow, LsQlcode, k

if dw_insert.rowcount() < 1 then return

if wf_requiredchk(lrow, scolumn)  = -1 then 
	dw_insert.setcolumn(scolumn)
	dw_insert.scrolltorow(lrow)
	dw_insert.setfocus()
	w_mdi_frame.sle_msg.text = ''
	return
end if

w_mdi_frame.sle_msg.text = "자료를 저장하고 있읍니다."

if dw_head.getitemstring(1, "jagbn") = 'Y' then // 신규자료 입력인 경우
	if wf_save() 	 = -1 then 
	   rollback;		
		LSqlcode = dec(sqlca.sqlcode)
		f_message_chk(LSqlcode,'[자료저장]') 			
		return
	else
		commit;
	end if
else															// 수정인 경우
	if dw_head.getitemstring(1, "sigbn") = '2' then
		FOR k = 1 TO dw_insert.rowcount()
			dw_insert.setitem(k, "shpact_suqty", dw_insert.getitemdecimal(k, "waqty"))
		NEXT
	end if

	if dw_insert.update() = -1 then
	   rollback;		
		LSqlcode = dec(sqlca.sqlcode)
		f_message_chk(LSqlcode,'[자료저장]') 
		return
	else
		commit;
	end if
end if

//refresh
dw_hist.setredraw(false)
ls_saupj = dw_head.GetItemString(1, 'saupj')

If IsNull(ls_saupj) or ls_saupj ='' Then ls_saupj ='%'

dw_hist.retrieve(gs_sabu,ls_saupj, s1, s2, s3, s4)
dw_hist.setredraw(true)

w_mdi_frame.sle_msg.text = ''
/* 수리인 경우에만 불량원인을 입력 할 수 있도록 한다 */
if dw_head.getitemstring(1, "sigbn") = '2' then
	p_1.enabled = true
end if			

/* 비가동, 사용자재 편집을 할 수 있도록 한다 */
p_nttabl.enabled = true
p_holdstock.enabled = true
p_4.enabled = false
p_del.enabled = false
p_5.enabled = false
this.enabled = false

p_nttabl.PictureName		= 'C:\erpman\image\비가동요인_up.gif'
p_holdstock.PictureName = 'C:\erpman\image\사용자재_up.gif'
p_4.PictureName 			= 'C:\erpman\image\실적보고_d.gif'
p_del.PictureName 		= 'C:\erpman\image\삭제_d.gif'
p_5.PictureName 			= 'C:\erpman\image\일괄삭제_d.gif'
this.PictureName 			= 'C:\erpman\image\저장_d.gif'

ib_any_typing = false


end event

type cb_exit from w_inherite`cb_exit within w_pdt_02500
integer x = 3566
integer y = 2304
end type

type cb_mod from w_inherite`cb_mod within w_pdt_02500
integer x = 2523
integer y = 2304
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within w_pdt_02500
integer x = 832
integer y = 2576
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_pdt_02500
integer x = 2871
integer y = 2304
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_pdt_02500
integer x = 1111
integer y = 2308
end type

type cb_print from w_inherite`cb_print within w_pdt_02500
integer x = 1253
integer y = 2556
end type

type st_1 from w_inherite`st_1 within w_pdt_02500
integer x = 46
integer y = 2760
end type

type cb_can from w_inherite`cb_can within w_pdt_02500
integer x = 3218
integer y = 2300
integer height = 112
boolean enabled = false
end type

type cb_search from w_inherite`cb_search within w_pdt_02500
integer x = 1687
integer y = 2592
boolean enabled = false
end type



type sle_msg from w_inherite`sle_msg within w_pdt_02500
integer x = 398
integer y = 2760
end type

type gb_10 from w_inherite`gb_10 within w_pdt_02500
integer x = 27
integer y = 2708
end type

type gb_button1 from w_inherite`gb_button1 within w_pdt_02500
end type

type gb_button2 from w_inherite`gb_button2 within w_pdt_02500
end type

type ds_update from datawindow within w_pdt_02500
boolean visible = false
integer x = 1440
integer y = 2308
integer width = 535
integer height = 104
boolean bringtotop = true
boolean titlebar = true
string title = "저장용"
string dataobject = "d_pdt_02500_save"
boolean controlmenu = true
boolean maxbox = true
boolean resizable = true
borderstyle borderstyle = stylelowered!
end type

event updatestart;/* Update() function 호출시 user 설정 */
long k, lRowCount

lRowCount = this.RowCount()

FOR k = 1 TO lRowCount
   IF NewModified! = this.GetItemStatus(k, 0, Primary!) THEN
 	   This.SetItem(k,'crt_user',gs_userid)
   ELSEIF DataModified! = this.GetItemStatus(k, 0, Primary!) THEN 		
	   This.SetItem(k,'upd_user',gs_userid)
   END IF	  
NEXT


end event

type dw_hist from datawindow within w_pdt_02500
integer x = 91
integer y = 432
integer width = 4466
integer height = 860
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_pdt_02500_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event itemchanged;long lrow
string spdsts, smatchk, sqcgub, sget_data, spordno, sopseq
decimal {3} dpdqty, dcoqty, dpeqty, dsilqty, dijunqty, dacqty

lrow = this.getrow()

if this.getcolumnname() = 'sel' then
		
		spordno = dw_hist.getitemstring(Lrow, "morout_pordno")
		sopseq  = dw_hist.getitemstring(Lrow, "morout_opseq")
		dijunqty  = dw_hist.getitemDecimal(Lrow, "ijun_qty")		
		dw_hist.SetItem(Lrow, "acqty",dijunqty)			
	
		select a.pdsts, a.matchk, b.qcgub, a.pdqty, b.coqty into :spdsts, :smatchk, :sqcgub, :dpdqty, :dcoqty
		  from momast a, morout b
		 where a.sabu = :gs_sabu and a.pordno = :sPordno 
		 	and a.sabu = b.sabu    and a.pordno = b.pordno and b.opseq = :sopseq;
			 
		if dw_head.getitemstring(1, "jagbn") = 'Y' then		/* 신규인 경우 */			 		 
			 
			if spdsts > '2' then
				f_message_chk(118, '[작업지시]')
				setitem(lrow, "sel", 'N')
				return 1 
			End if
			
			if dpdqty = dcoqty then
				f_message_chk(156, '[작업지시]')
				setitem(lrow, "sel", 'N')			
				return 1
			End if		
			
			if smatchk = '1' then
				f_message_chk(116, '[작업공정]')
				setitem(lrow, "sel", 'N')			
				return 1
			End if
		
		End if
		
	
		//시스템관리에서 이전실적 체크여부
	   SELECT DATANAME  
		  INTO :sget_data
		  FROM SYSCNFG  
		 WHERE SYSGU = 'Y' AND SERIAL = 25 AND LINENO = '4' ;
		
		if sqlca.sqlcode <> 0 then sget_data = 'N'
		
		if dw_head.getitemstring(1, "sigbn") = '1' and dw_head.getitemstring(1, "jagbn") = 'Y' then
			if sget_data = 'N' then //이전실적check
				dpeqty 	= sqlca.erp000000220_3(gs_sabu, spordno, sopseq);
				dsilqty 	= sqlca.erp000000220_4(gs_sabu, spordno, sopseq);			
				if dpdqty - (dpeqty + dsilqty) <= 0 then
					f_message_chk(119, '[작업지시]')
					return
				End if						
			end if
		end if

elseif this.getcolumnname() = 'acqty' then
	dacqty = dec(data)
	
	if dacqty = 0 then
		setitem(Lrow, "sel",'N')
		return 
	end if
	
	if dacqty > getitemdecimal(lrow, "janqty") then
		Messagebox("실적수량", "실적수량이 잔량보다 큽니다", stopsign!)
		setitem(Lrow,"acqty",0)
		return 1
		setitem(Lrow,"sel",'N')
	Else
		setitem(Lrow,"sel",'Y')		
		
		spordno = dw_hist.getitemstring(Lrow, "morout_pordno")
		sopseq  = dw_hist.getitemstring(Lrow, "morout_opseq")			
		
		select a.pdsts, a.matchk, b.qcgub, a.pdqty, b.coqty into :spdsts, :smatchk, :sqcgub, :dpdqty, :dcoqty
		  from momast a, morout b
		 where a.sabu = :gs_sabu and a.pordno = :sPordno 
		 	and a.sabu = b.sabu    and a.pordno = b.pordno and b.opseq = :sopseq;
			 
		if dw_head.getitemstring(1, "jagbn") = 'Y' then		/* 신규인 경우 */			 
			 
			if spdsts > '2' then
				f_message_chk(118, '[작업지시]')
				setitem(lrow, "sel", 'N')
				return 1 
			End if
			
			if dpdqty = dcoqty then
				f_message_chk(156, '[작업지시]')
				setitem(lrow, "sel", 'N')			
				return 1
			End if		
			
			if smatchk = '1' then
				f_message_chk(116, '[작업공정]')
				setitem(lrow, "sel", 'N')			
				return 1
			End if
		
		End if
			
		//시스템관리에서 이전실적 체크여부
	   SELECT DATANAME  
		  INTO :sget_data
		  FROM SYSCNFG  
		 WHERE SYSGU = 'Y' AND SERIAL = 25 AND LINENO = '4' ;
		
		if sqlca.sqlcode <> 0 then sget_data = 'N'
		
		if dw_head.getitemstring(1, "sigbn") = '1' and dw_head.getitemstring(1, "jagbn") = 'Y' then
			if sget_data = 'N' then //이전실적check
				dpeqty 	= sqlca.erp000000220_3(gs_sabu, spordno, sopseq);
				dsilqty 	= sqlca.erp000000220_4(gs_sabu, spordno, sopseq);			
				if dpdqty - (dpeqty + dsilqty) <= 0 or dpdqty - (dpeqty + dsilqty) < dacqty then
					f_message_chk(119, '[작업지시]')
					return
				End if						
			end if
		end if		
		
	end if
end if
end event

event itemerror;return 1
end event

type dw_setup from datawindow within w_pdt_02500
boolean visible = false
integer x = 1989
integer y = 2312
integer width = 526
integer height = 104
boolean bringtotop = true
boolean titlebar = true
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type p_4 from uo_picture within w_pdt_02500
integer x = 2798
integer y = 24
integer width = 178
integer taborder = 80
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\erpman\image\실적보고_up.gif"
end type

event clicked;call super::clicked;dw_insert.setredraw(false)
dw_insert.ReSet()
w_mdi_frame.sle_msg.text = '자료를 조회중입니다....!!'
wf_insert()
w_mdi_frame.sle_msg.text = ''
dw_insert.setredraw(true)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\실적보고_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\실적보고_up.gif"
end event

type p_1 from uo_picture within w_pdt_02500
integer x = 2971
integer y = 24
integer width = 178
integer taborder = 90
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\erpman\image\불량폐기_up.gif"
end type

event clicked;call super::clicked;datawindow dwname
dwname = dw_insert
openwithparm(w_pdt_02150, dwname)
dw_insert.setfocus()
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\불량폐기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\불량폐기_up.gif"
end event

type p_nttabl from uo_picture within w_pdt_02500
integer x = 3145
integer y = 24
integer width = 178
integer taborder = 100
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\erpman\image\비가동요인_up.gif"
end type

event clicked;call super::clicked;if dw_insert.getrow() > 0 then
	gs_code = dw_insert.getitemstring(dw_insert.getrow(), "shpjpno")
	open(w_pdt_02190)
end if


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\비가동요인_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\비가동요인_up.gif"
end event

type p_holdstock from uo_picture within w_pdt_02500
integer x = 3319
integer y = 24
integer width = 178
integer taborder = 110
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\erpman\image\사용자재_up.gif"
end type

event clicked;call super::clicked;if dw_insert.getrow() > 0 then
	gs_code = dw_insert.getitemstring(dw_insert.getrow(), "shpjpno")
	open(w_pdt_02120)
end if


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\사용자재_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\사용자재_up.gif"
end event

type p_5 from uo_picture within w_pdt_02500
integer x = 3493
integer y = 24
integer width = 178
integer taborder = 120
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\erpman\image\일괄삭제_up.gif"
end type

event clicked;call super::clicked;Long 		LSqlcode, lRow, lFindRow
String	sShpjpno, hsjpjpno, ssigbn, smaxno
decimal {2} droqty


if dw_hist.Find("sel = 'Y'",1,dw_hist.RowCount()) <= 0 then return
if Messagebox("삭제확인", "선택된 실적자료를 삭제하시겠읍니까?", question!, yesno!) = 2 then return

dw_insert.SetRedraw(false)
DO WHILE TRUE
	lRow = dw_hist.Find("sel = 'Y'",1,dw_hist.RowCount())
	if lRow <= 0 then Exit
	
	sShpjpno    = dw_hist.GetItemString(lRow,'shpjpno')
	droqty 		= dw_hist.getitemdecimal(lRow, "shpact_roqty")
   hsjpjpno		= dw_hist.getitemstring(lRow,  "shpact_yebiv3")
	ssigbn		= dw_hist.getitemstring(lRow,  "shpact_sigbn")

	SetNull( sMaxNo)
	if ssigbn = '1' then // 정상실적만 처리
		select max(shpjpno) into :smaxno from shpact
		 where sabu = :gs_sabu And yebiv3 = :hsjpjpno AND shpjpno <> :sShpjpno ;
		 
		if IsNull( smaxno ) or trim( smaxno ) = '' then
			Update shpact set yebid1 = 0, siljpno = null
			 where sabu = :gs_sabu And shpjpno = :hsjpjpno;
		Else
			Update shpact set yebid1 = nvl(yebid1, 0) - :droqty, siljpno = :smaxno
			 where sabu = :gs_sabu And shpjpno = :hsjpjpno;				
		End if
		
		if sqlca.sqlcode <> 0  or sqlca.sqlnrows <> 1 then
			f_message_chk(32, '[자료저장]')
			rollback;
			return -1
		End if	
	End if
	
	lFindRow = dw_insert.Find("shpjpno ='" + sShpjpno + "'",1,dw_insert.RowCount())
	if lFindRow > 0 then	dw_insert.DeleteRow(lFindRow)

	dw_hist.DeleteRow(lRow)
LOOP

if dw_hist.update() = -1 then
	rollback;	
	LSqlcode = dec(sqlca.sqlcode)
	f_message_chk(32, '[자료저장]')
	return
else
	commit;
end if

dw_hist.setredraw(false)
dw_hist.retrieve(gs_sabu, s1, s2, s3, s4)
dw_hist.setredraw(true)

dw_insert.ReSetUpdate()
dw_insert.SetRedraw(true)
dw_insert.SetFocus()
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\일괄삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\일괄삭제_up.gif"
end event

type dw_head from datawindow within w_pdt_02500
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 50
integer y = 24
integer width = 4169
integer height = 400
integer taborder = 10
string dataobject = "d_pdt_02500_0"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event ue_key;
if keydown(keyf1!) then
	this.triggerevent(rbuttondown!)
end if
end event

event itemerror;return 1
end event

event itemchanged;string   sCode, sName, sName2, sNull, sitnbr, sitdsc, sispec, time1
int      ireturn 
Setnull(sNull)

if this.getcolumnname() = 'sfrom' then
   sCode = trim(this.gettext())
	
	if sCode = '' or isnull(sCode) then return 
	
	IF f_datechk(sCode) = -1	then
		f_message_chk(35, '[지시일자-From]')
		this.setitem(1, "sfrom", snull)
		return 1
	END IF
elseif this.getcolumnname() = 'sto' then
   sCode = trim(this.gettext())
	
	if sCode = '' or isnull(sCode) then return 
	
	IF f_datechk(sCode) = -1	then
		f_message_chk(35, '[지시일자-To]')
		this.setitem(1, "sto", snull)
		return 1
	END IF
elseif this.getcolumnname() = "wkctr" then
   sCode = trim(this.gettext())
	
	if isnull(scode) or scode = '' then
		this.setitem(1, "wcdsc", '')
		return 
	end if
	
	select a.wcdsc
	  into :sname
	  from wrkctr a
	 where a.wkctr = :scode;
	 
	if sqlca.sqlcode <> 0 then
		f_message_chk(90,'[작업장]')
		this.setitem(1, "wkctr", snull)
		this.setitem(1, "wcdsc", snull)
		return  1
	end if	
  	this.setitem(1, "wcdsc", sname)	
elseif this.getcolumnname() = "empno" then
   sCode = trim(this.gettext()) 
  	sName = f_get_reffer('45', scode) 
	if isnull(sName) or Trim(sName) = '' then
		this.setitem(1, "empno", sNull)
		this.setitem(1, "empnm", sNull)		
		return 1
	end if
	this.setitem(1, "empnm", sname)
elseif this.getcolumnname() = "strdate" then	
   sCode = trim(this.gettext())
	if f_datechk(scode) = -1 then
		f_message_chk(35, "시작일자")
		setitem(1, "strdate", snull)
		return 1
	end if
elseif this.getcolumnname() = "strtime" then	
   sCode = trim(this.gettext())
	time1 = Mid(scode,1,2) + ':' + Mid(scode,3,2)
	if isnull(scode) or trim(scode) = '' then
		f_message_chk(30, "작업시작시간")
		setitem(1, "strtime", snull)
		return 1
	elseif  not istime(time1) then
		f_message_chk(176, "작업시작시간")
		setitem(1, "strtime", snull)
		return 1
	end if
elseif this.getcolumnname() = "enddate" then	
   sCode = trim(this.gettext())
	if f_datechk(scode) = -1 then
		f_message_chk(35, "완료일자")
		setitem(1, "enddate", snull)
		return 1
	end if
elseif this.getcolumnname() = "endtime" then	
   sCode = trim(this.gettext())
	time1 = Mid(scode,1,2) + ':' + Mid(scode,3,2)
	if isnull(scode) or trim(scode) = '' then
		f_message_chk(30, "작업종료시간")
		setitem(1, "strtime", snull)
		return 1
	elseif  not istime(time1) then
		f_message_chk(176, "작업종료시간")
		setitem(1, "strtime", snull)
		return 1
	end if
elseif this.getcolumnname() = "jagbn" then	
   sCode = trim(this.gettext())
	if sCode = 'Y' then 
		pb_2.visible = true
	else
		pb_2.visible = false
	end if
End if

end event

event rbuttondown;string colname, sdata, sjocod
long   lrow

gs_code = ''
gs_codename = ''
gs_gubun = ''

colname = this.getcolumnname()
lrow    = this.getrow()

if colname = "wkctr" then
   gs_code = this.gettext()
	open(w_workplace_popup)
   if isnull(gs_code) or gs_code = "" then return
	this.setitem(lrow, "wkctr", gs_code)
	this.triggerevent(itemchanged!)
elseif colname = "empno" then
		 gs_code = '45'
		 open(w_reffpf_all_popup)
		 if isnull(gs_code) or gs_code = "" then return
		 this.setitem(lrow, "empno", gs_code)
		 this.triggerevent(itemchanged!)		 
elseif colname = "itnbr" or colname = "itdcs" or colname = "ispec" then
   gs_code = this.getitemstring(lrow, "itnbr")
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(lrow,"itnbr",gs_code)
	this.TriggerEvent(ItemChanged!)
		 
ELSEif colname = "pordno" then
	gs_gubun = '30' 
	open(w_jisi_popup)
	if isnull(gs_code) or gs_code = "" then 	return
	this.SetItem(1, "pordno", gs_code)
end if


end event

type pb_1 from u_pb_cal within w_pdt_02500
integer x = 709
integer y = 324
integer taborder = 140
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_head.Setcolumn('sfrom')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_head.SetItem(1, 'sfrom', gs_code)
end event

type pb_2 from u_pb_cal within w_pdt_02500
integer x = 1143
integer y = 324
integer taborder = 150
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_head.Setcolumn('sto')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_head.SetItem(1, 'sto', gs_code)
end event

type pb_3 from u_pb_cal within w_pdt_02500
integer x = 1563
integer y = 324
integer taborder = 150
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_head.Setcolumn('strdate')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_head.SetItem(1, 'strdate', gs_code)
end event

type pb_4 from u_pb_cal within w_pdt_02500
integer x = 2546
integer y = 324
integer taborder = 160
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_head.Setcolumn('enddate')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_head.SetItem(1, 'enddate', gs_code)
end event

type rr_1 from roundrectangle within w_pdt_02500
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 73
integer y = 428
integer width = 4503
integer height = 872
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pdt_02500
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 73
integer y = 1316
integer width = 4503
integer height = 976
integer cornerheight = 40
integer cornerwidth = 55
end type

