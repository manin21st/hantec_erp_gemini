$PBExportHeader$w_pdt_02133.srw
$PBExportComments$작업실적등록(작업지시번호별)
forward
global type w_pdt_02133 from w_inherite
end type
type gb_4 from groupbox within w_pdt_02133
end type
type dw_head from datawindow within w_pdt_02133
end type
type ds_update from datawindow within w_pdt_02133
end type
type dw_hist from datawindow within w_pdt_02133
end type
type dw_hist_item from datawindow within w_pdt_02133
end type
type p_1 from uo_picture_01 within w_pdt_02133
end type
type p_nttabl from uo_picture_02 within w_pdt_02133
end type
type p_holdstock from uo_picture_03 within w_pdt_02133
end type
type rr_1 from roundrectangle within w_pdt_02133
end type
type rr_2 from roundrectangle within w_pdt_02133
end type
end forward

global type w_pdt_02133 from w_inherite
string title = "작업실적등록(작업지시 번호별)"
gb_4 gb_4
dw_head dw_head
ds_update ds_update
dw_hist dw_hist
dw_hist_item dw_hist_item
p_1 p_1
p_nttabl p_nttabl
p_holdstock p_holdstock
rr_1 rr_1
rr_2 rr_2
end type
global w_pdt_02133 w_pdt_02133

type variables
string   isjpno,  &
           is_chk    //시스템에서 작업자 필수입력 체크
string ls_format,  ls_tformat
 
// Refresh하기 위한 저장변수
string s1

end variables

forward prototypes
public function integer wf_settime ()
public function integer wf_requiredchk (ref long lcrow, ref string scolumn)
public function integer wf_save ()
public function integer wf_chango ()
public subroutine wf_reset ()
end prototypes

public function integer wf_settime ();sTring sdate, stime, edate, etime, spoint
Long   Lday, Linwon
Dec {2} dfirtime, dsectime, dtotal, desset, desman, desmch
Dec {2} dsetrate, dmanrate, dmchrate, dset, dman, dmch

sdate  = dw_insert.getitemstring(1, "sdate")
stime  = dw_insert.getitemstring(1, "stime")
edate  = dw_insert.getitemstring(1, "edate")
etime  = dw_insert.getitemstring(1, "etime")
Linwon = dw_insert.getitemdecimal(1, "toiwn")


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
desset = dw_insert.getitemdecimal(1, "morout_esset")
desman = dw_insert.getitemdecimal(1, "morout_esman")
desmch = dw_insert.getitemdecimal(1, "morout_esmch")

if (desset + desman + desmch) <= 0 then 
	dsetrate = 0
	dmanrate = 0 
	dmchrate = 0
else
	dsetrate = desset / (desset + desman + desmch) 
	dmanrate = desman / (desset + desman + desmch)
	dmchrate = desmch / (desset + desman + desmch)
end if


// 비율별로 시간계산을 한다.
dset = truncate(dtotal * dsetrate, 2)
dman = truncate(dtotal * dmanrate * Linwon, 2)

// 휴식시간은 Man H/R기준인 경우에만 가감한다.
if dw_insert.getitemstring(1, "morout_esgbn") = '1' and dman > (dfirtime + dsectime) Then
   dman = dman - (dfirtime + dsectime)	
End if
dmch = truncate(dtotal * dmchrate, 2)

if IsNull( dSet ) then dSet = 0
if IsNull( dman ) then dman = 0
if IsNull( dmch ) then dmch = 0

dw_insert.setitem(1, "toset", dset)

// Man 시간 보고가 잘못 된 경우 (예를 들어서 점심시간이 12:00~13:00 인데 11:50~12:10으로 보고하면 Minus가 나타남
if dman < 0 then
	f_message_chk(177, '완료시간')
	return -1
End if
dw_insert.setitem(1, "toman", dman)
dw_insert.setitem(1, "tomch", dmch)
dw_insert.setitem(1, "sotim", dset + dman + dmch)

return 1
end function

public function integer wf_requiredchk (ref long lcrow, ref string scolumn);Long 	  lrow, lcnt
String  sreff, sreff1, sitdsc, sispec, sitnbr, sWanlot, sBanlot, sIttyp, ls_saupj
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
 
if 	sqlca.sqlcode <> 0 or isnull(swanlot) or trim(sWanlot) = '' then
	sWanlot = 'Y'
end if


//자사거래처 코드
select  b.rfgub	into	  :ls_saupj
          from 	 syscnfg  a , reffpf b
		where  a.sysgu = 'C'     and 	 a.serial = 4   and    a.lineno = '1' 
		    and  b.rfcod = 'AD'     and     b.rfna2 = a.dataname;
// 반제품에 대한 입고LOT 필수check 여부
IF	ls_saupj = gs_saupj	then                                   
	select dataname
	  into :sBanlot
	  from syscnfg
	 where sysgu = 'Y' and serial = '25' and lineno = '2';
Else                           // [조립/장치]
	select dataname
	  into :sBanlot
	  from syscnfg
	 where sysgu = 'Y' and serial = '25' and lineno = '22';
End If	
 
if 	sqlca.sqlcode <> 0 or isnull(sBanlot) or trim(sBanlot) = '' then
	sBanlot = 'Y'
end if

lcnt = 1

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

if dw_insert.getitemdecimal(lcnt, "waqty") + dw_insert.getitemdecimal(lcnt, "buqty") &
   + dw_insert.getitemdecimal(lcnt, "ppqty") <= 0  then
	scolumn = "waqty"
	f_message_chk(1400,'[수량]') 
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
	 

return 1
end function

public function integer wf_save ();Long 	  lrow, lcnt, lirow, ljpno, lseq, lipjpno, Lsqlcode
String  sreff, sreff1, sitdsc, sispec, sitnbr, scolumn, scdate, serror, sjpno
integer ireturn

w_mdi_frame.sle_msg.text = "자료를 저장하고 있읍니다."

ds_update.dataobject = "d_pdt_02130_2"
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
		ds_update.setitem(lirow, "sigbn", dw_head.getitemstring(1, "sigbn"))
		ds_update.setitem(lirow, "purgc", dw_insert.getitemstring(lcnt, "morout_purgc"))
		ds_update.setitem(lirow, "roqty", dw_insert.getitemdecimal(lcnt, "waqty") + &
													 dw_insert.getitemdecimal(lcnt, "buqty") + &
													 dw_insert.getitemdecimal(lcnt, "ppqty"))
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
		ds_update.setitem(lirow, "silgbn", '2')
 
Next

w_mdi_frame.sle_msg.text = "실적자료를 저장 中............."
if ds_update.update() = -1 then
	LSqlcode = dec(sqlca.sqlcode)
	f_message_chk(LSqlcode,'[자료저장]') 			
	w_mdi_frame.sle_msg.text = ''
	rollback;
	return -1
end if	

w_mdi_frame.sle_msg.text = ""
return 1
end function

public function integer wf_chango ();
 // 최종공정인 경우에는 입고창고 를 move
if dw_insert.getitemstring(1, "lastc")  = '3' or &		
 	dw_insert.getitemstring(1, "lastc")  = '9' Then
	dw_insert.setitem(1, "gubun", dw_insert.getitemstring(1, "ipchango"))			
End if

dw_insert.setitem(1, "toiwn", dw_insert.getitemdecimal(1, "morout_esinw"))

return 1
end function

public subroutine wf_reset ();rollback;
string snull

setnull(snull)

dw_insert.setfilter("")
dw_insert.filter()

p_inq.enabled 	= true
p_mod.enabled 	= false
p_can.enabled 	= false
p_del.enabled 	= false
p_nttabl.enabled = false
p_holdstock.enabled = false
p_1.enabled 		= false

p_inq.PictureName 		= "c:\erpman\image\조회_up.gif"
p_mod.PictureName 	= "c:\erpman\image\저장_d.gif"
p_can.PictureName 	= "c:\erpman\image\취소_d.gif"
p_del.PictureName 		= "c:\erpman\image\삭제_d.gif"
p_nttabl.PictureName 	= "c:\erpman\image\비가동요인_d.gif"
p_holdstock.PictureName = "c:\erpman\image\사용자재_d.gif"
p_1.PictureName 		= "c:\erpman\image\불량폐기_d.gif"

dw_hist.reset()
dw_hist_item.reset()
dw_insert.reset()
dw_head.enabled = true

dw_head.setitem(1, "pordno", snull)
dw_head.setcolumn('pordno')
dw_head.setfocus()

ib_any_typing = false

end subroutine

on w_pdt_02133.create
int iCurrent
call super::create
this.gb_4=create gb_4
this.dw_head=create dw_head
this.ds_update=create ds_update
this.dw_hist=create dw_hist
this.dw_hist_item=create dw_hist_item
this.p_1=create p_1
this.p_nttabl=create p_nttabl
this.p_holdstock=create p_holdstock
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_4
this.Control[iCurrent+2]=this.dw_head
this.Control[iCurrent+3]=this.ds_update
this.Control[iCurrent+4]=this.dw_hist
this.Control[iCurrent+5]=this.dw_hist_item
this.Control[iCurrent+6]=this.p_1
this.Control[iCurrent+7]=this.p_nttabl
this.Control[iCurrent+8]=this.p_holdstock
this.Control[iCurrent+9]=this.rr_1
this.Control[iCurrent+10]=this.rr_2
end on

on w_pdt_02133.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_4)
destroy(this.dw_head)
destroy(this.ds_update)
destroy(this.dw_hist)
destroy(this.dw_hist_item)
destroy(this.p_1)
destroy(this.p_nttabl)
destroy(this.p_holdstock)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_insert.settransobject(sqlca)
dw_hist.settransobject(sqlca)
dw_hist_item.settransobject(sqlca)
dw_head.settransobject(sqlca)
dw_head.insertrow(0)

dw_head.setcolumn('pordno')
dw_head.setfocus()

  SELECT "SYSCNFG"."DATANAME"  
    INTO :is_chk  
    FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'Y' ) AND  
         ( "SYSCNFG"."SERIAL" = 25 ) AND  
         ( "SYSCNFG"."LINENO" = '1' )   ;

if is_chk = '' or isnull(is_chk) then is_chk = 'N' 
end event

type dw_insert from w_inherite`dw_insert within w_pdt_02133
integer x = 32
integer y = 1604
integer width = 4535
integer height = 712
integer taborder = 40
string dataobject = "d_pdt_02130_1"
boolean border = false
boolean livescroll = false
borderstyle borderstyle = stylelowered!
end type

event dw_insert::itemchanged;string   snull, sitnbr, sreff, sreff1, sitdsc, sispec, sjijil, sispec_code, scvcod, sopseq, sPordno
time     tchk
long     lrow
integer  ireturn
Decimal {3}  dtime, dtime1, dSaVeqty, dPrqty, dPdqty, dsilrate

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
	sispec_code = trim(GetText())
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
	 if this.getitemstring(lrow, "lastc") = '3' or &
		 this.getitemstring(lrow, "lastc") = '9' then
		 if isnull(dw_insert.getitemstring(lrow, "gubun")) then
			 f_message_chk(1400,'[입고창고]') 
		 	 RETURN  1	
		 end if
	  end if		 		
elseif this.getcolumnname() = "empno" then
   sitnbr = trim(this.gettext())
	 
  	ireturn = f_get_name2('사번', 'Y', sitnbr, sitdsc, sispec) 
	this.setitem(lrow, "empno", sitnbr)
	this.setitem(lrow, "empname", sitdsc)
	return ireturn 	  
elseif this.getcolumnname() = 'sdate' then
	if f_datechk(gettext()) = -1 then
		f_message_chk(35, "시작일자")
		setitem(1, "sdate",   snull)
		return 1
	end if
	
	if wf_settime() = -1 then
		dw_insert.setitem(lrow, 'toset', 0)
		dw_insert.setitem(lrow, 'toman', 0)
		dw_insert.setitem(lrow, 'tomch', 0)
		dw_insert.setitem(lrow, 'sotim', 0)		
	end if
	
ELSEif this.getcolumnname() = "stime"  then
	sreff = gettext()
   if not Istime(left(sreff, 2) + ':' + right(sreff, 2)) then
		f_message_chk(176, "시작시간")
		setitem(1, "stime",   snull)
		dw_insert.setitem(Lrow, 'stime', snull)
		dw_insert.setitem(lrow, 'toset', 0)
		dw_insert.setitem(lrow, 'toman', 0)
		dw_insert.setitem(lrow, 'tomch', 0)
		dw_insert.setitem(lrow, 'sotim', 0)
		return 1 
   end if 
	
	if wf_settime() = -1 then
		dw_insert.setitem(lrow, 'toset', 0)
		dw_insert.setitem(lrow, 'toman', 0)
		dw_insert.setitem(lrow, 'tomch', 0)
		dw_insert.setitem(lrow, 'sotim', 0)		
	end if
	
elseif this.getcolumnname() = 'edate' then	
	if f_datechk(gettext()) = -1 then
		f_message_chk(35, "완료일자")
		setitem(1, "edate",   snull)
		return 1
	end if
	
	if wf_settime() = -1 then
		dw_insert.setitem(lrow, 'toset', 0)
		dw_insert.setitem(lrow, 'toman', 0)
		dw_insert.setitem(lrow, 'tomch', 0)
		dw_insert.setitem(lrow, 'sotim', 0)		
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
	
	if wf_settime() = -1 then
		dw_insert.setitem(Lrow, 'stime', snull)
		dw_insert.setitem(lrow, 'toset', 0)
		dw_insert.setitem(lrow, 'toman', 0)
		dw_insert.setitem(lrow, 'tomch', 0)
		dw_insert.setitem(lrow, 'sotim', 0)		
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
elseif this.getcolumnname() = "waqty"  then	/* 불량, 폐기는 check안함 */
	dTime = dec(this.gettext())
	sreff = this.getitemstring(Lrow, "shpjpno")
	
	// 실적가중치를 적용
	dsilrate = this.getitemdecimal(Lrow, "morout_stdmn")
	if isnull(dsilrate) or dsilrate  < 1 then dsilrate = 1
	dtime = dtime * dsilrate	
	
//	Select Sum(Nvl(ipqty, 0)) into :dTime1
//	  From shpact_ipgo
//	 Where sabu = :gs_sabu and shpjpno = :sReff;
	
//	if dTime < dTime1 then
//		Messagebox("수량확인","입고예정량 보다 작으면 안됩니다", stopsign!)
//		this.setitem(lrow, "waqty", dSaveqty)
//		RETURN  1	
//	end if

	setitem(row, "waqty", dtime)
	setitem(row, "roqty", dTime + &
								 getitemdecimal(row, "buqty") + &
								 getitemdecimal(row, "ppqty"))
elseif this.getcolumnname() = "buqty"  then	
	dTime = dec(this.gettext())
	
	// 실적가중치를 적용
	dsilrate = this.getitemdecimal(Lrow, "morout_stdmn")
	if isnull(dsilrate) or dsilrate  < 1 then dsilrate = 1
	dtime = dtime * dsilrate	
	
	setitem(row, "buqty", dtime)
	setitem(row, "roqty", getitemdecimal(row, "waqty") + &
								 dTime + &
								 getitemdecimal(row, "ppqty"))
elseif this.getcolumnname() = "ppqty"  then	
	dTime = dec(this.gettext())
	
	// 실적가중치를 적용
	dsilrate = this.getitemdecimal(Lrow, "morout_stdmn")
	if isnull(dsilrate) or dsilrate  < 1 then dsilrate = 1
	dtime = dtime * dsilrate	
	
	setitem(row, "ppqty", dtime)
	setitem(row, "roqty", getitemdecimal(row, "waqty") + &
								 getitemdecimal(row, "buqty") + &
								 dTime)
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
		 gs_code = this.gettext()
		 open(w_sawon_popup)
		 if isnull(gs_code) or gs_code = "" then return
		 this.setitem(lrow, "empno", gs_code)
		 this.triggerevent(itemchanged!)		 
end if


end event

event dw_insert::doubleclicked;//IF ROW < 1  THEN RETURN 
//
//gs_code = this.getitemstring(row, 'morout_pordno')
//openwithparm(w_pdt_02135, dw_insert)
//
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

type p_delrow from w_inherite`p_delrow within w_pdt_02133
integer y = 5000
end type

type p_addrow from w_inherite`p_addrow within w_pdt_02133
integer y = 5000
end type

type p_search from w_inherite`p_search within w_pdt_02133
integer y = 5000
end type

type p_ins from w_inherite`p_ins within w_pdt_02133
integer y = 5000
end type

type p_exit from w_inherite`p_exit within w_pdt_02133
integer x = 4407
integer y = 8
end type

type p_can from w_inherite`p_can within w_pdt_02133
integer x = 4233
integer y = 8
boolean enabled = false
string picturename = "C:\erpman\image\취소_d.gif"
end type

event p_can::clicked;call super::clicked;wf_reset()
end event

type p_print from w_inherite`p_print within w_pdt_02133
integer y = 5000
end type

type p_inq from w_inherite`p_inq within w_pdt_02133
integer x = 3712
integer y = 8
end type

event p_inq::clicked;call super::clicked;string swkctr, strdate, enddate, sItnbr, sPdtgu, sigbn, swcdsc, get_data, shpsigbn, spordno
long   k, lCount

Setpointer(hourglass!)

dw_hist.setredraw(false)

IF dw_head.accepttext() = -1 THEN RETURN 

spordno = dw_head.getitemstring(1, "pordno")
s1 = spordno

if dw_hist_item.retrieve(gs_sabu, spordno) < 1 then
	f_message_chk(50, '[작업지시번호]')
	wf_reset()
	return
end if


if dw_head.getitemstring(1, "jagbn") = 'Y' then		/* 신규인 경우 */
   sigbn = dw_head.object.sigbn[1]
	
	dw_hist.dataobject = "d_pdt_02133_3"
	dw_hist.settransobject(sqlca)			
	
	IF sigbn = '1'  then /* 정상 */
		dw_insert.dataobject = "d_pdt_02130_1"
		dw_insert.settransobject(sqlca)		
		
		//시스템관리에서 이전실적 체크여부
	   SELECT DATANAME  
		  INTO :get_data
		  FROM SYSCNFG  
		 WHERE SYSGU = 'Y' AND SERIAL = 25 AND LINENO = '4' ;
		
		if sqlca.sqlcode <> 0 then get_data = 'N'
		
		if get_data = 'Y' then //이전실적수량이 없으면 필터링
		   dw_insert.SetFilter("ijun_qty > 0 and janqty > 0")
		else	
		   dw_insert.SetFilter("janqty > 0")
		end if	
		dw_insert.Filter()
	ELSE
		dw_insert.dataobject = "d_pdt_02130_11"
		dw_insert.settransobject(sqlca)		
	END IF 
		
	if dw_hist.retrieve(gs_sabu, spordno) = 0 then
		f_message_chk(56,'[작업지시내역(정상)]')
		dw_head.setfocus()
		setpointer(arrow!)
		dw_insert.setredraw(true)
		return
	end if			 			
	
else
	
	dw_hist.dataobject = "d_pdt_02133_4"
	dw_hist.settransobject(sqlca)			
	dw_insert.dataobject = "d_pdt_02130_3"
	dw_insert.settransobject(sqlca)		
	  
	if dw_hist.retrieve(gs_sabu, spordno) = 0 then
		f_message_chk(56,'[작업실적내역]')
		dw_head.setfocus()
		setpointer(arrow!)
		dw_insert.setredraw(true)
		return
	end if
	
End if

Setpointer(Arrow!)

p_inq.enabled 	= false
dw_head.enabled 	= false
p_mod.enabled 	= true
p_can.enabled 	= true

p_inq.PictureName = "c:\erpman\image\조회_d.gif"
p_mod.PictureName = "c:\erpman\image\저장_up.gif"
p_can.PictureName = "c:\erpman\image\취소_up.gif"

dw_hist.setredraw(true)
dw_hist.setfocus()

end event

type p_del from w_inherite`p_del within w_pdt_02133
integer x = 4059
integer y = 8
boolean enabled = false
string picturename = "C:\erpman\image\삭제_d.gif"
end type

event p_del::clicked;call super::clicked;Long LSqlcode

//		"규    격 : " + dw_insert.getitemstring(dw_insert.getrow(), "itemas_ispec")   + '~n' + &
if dw_insert.getrow() > 0 and dw_insert.rowcount() > 0 then
	if Messagebox("삭제확인", &
		"전표번호 : " + dw_insert.getitemstring(dw_insert.getrow(), "shpjpno") + '~n' + &
		"품    번 : " + dw_insert.getitemstring(dw_insert.getrow(), "shpact_itnbr")   + '~n' + &
		"품    명 : " + dw_insert.getitemstring(dw_insert.getrow(), "itemas_itdsc")   + '~n' + &
		"사    양 : " + dw_insert.getitemstring(dw_insert.getrow(), "shpact_pspec")   + '~n' + &
		" 를 삭제하시겠읍니까?", question!, yesno!) = 1 then
		dw_insert.deleterow(dw_insert.getrow())
	end if
end if

if dw_insert.update() = -1 then
	rollback;	
	LSqlcode = dec(sqlca.sqlcode)
	f_message_chk(LSqlcode,'[자료저장]') 	
	return
else
	commit;
end if

dw_hist.setredraw(false)
dw_hist.retrieve(gs_sabu, s1)
dw_hist.setredraw(true)
end event

type p_mod from w_inherite`p_mod within w_pdt_02133
integer x = 3886
integer y = 8
boolean enabled = false
string picturename = "C:\erpman\image\저장_d.gif"
end type

event p_mod::clicked;call super::clicked;string scolumn, sopseq, sjpno
long lrow, LsQlcode, k, Lfind

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
//		f_message_chk(LSqlcode,'[자료저장]') 			
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

sopseq = dw_insert.getitemstring(1, "morout_opseq")
sjpno	 = dw_insert.getitemstring(1, "shpjpno")

//refresh
dw_hist.setredraw(false)
dw_hist.retrieve(gs_sabu, s1)

// 수정한 내역을 검색하여 Pointer이동
if dw_head.getitemstring(1, "jagbn") = 'Y' then // 신규
	Lfind = dw_hist.find("morout_opseq = '"+ sopseq +"'", 0, dw_hist.rowcount())
else
	Lfind = dw_hist.find("shpjpno		  = '"+ sjpno  +"'", 0, dw_hist.rowcount())
End if
	
dw_hist.SelectRow(0, FALSE)

if Lfind > 0 then
	dw_hist.scrolltorow(Lfind)
	dw_hist.SelectRow(Lfind, TRUE)	
End if

dw_hist.setredraw(true)

w_mdi_frame.sle_msg.text = ''
/* 수리인 경우에만 불량원인을 입력 할 수 있도록 한다 */
//if dw_head.getitemstring(1, "sigbn") = '2' then
p_1.enabled = true
//end if			

/* 비가동, 사용자재 편집을 할 수 있도록 한다 */
p_nttabl.enabled = true
p_holdstock.enabled = true
p_nttabl.PictureName = "c:\erpman\image\비가동요인_up.gif"
p_holdstock.PictureName = "c:\erpman\image\사용자재_up.gif"
p_1.PictureName = "c:\erpman\image\불량폐기_up.gif"


this.enabled = false
p_del.enabled = false
this.PictureName = "c:\erpman\image\저장_d.gif"
p_del.PictureName = "c:\erpman\image\삭제_d.gif"

ib_any_typing = false


end event

type cb_exit from w_inherite`cb_exit within w_pdt_02133
integer x = 4229
integer y = 5000
integer taborder = 110
end type

type cb_mod from w_inherite`cb_mod within w_pdt_02133
integer x = 3186
integer y = 5000
integer taborder = 80
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within w_pdt_02133
boolean visible = false
integer x = 832
integer y = 2576
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_pdt_02133
integer x = 3534
integer y = 5000
integer taborder = 90
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_pdt_02133
integer x = 2825
integer y = 5000
integer taborder = 20
end type

type cb_print from w_inherite`cb_print within w_pdt_02133
boolean visible = false
integer x = 1253
integer y = 2556
end type

type st_1 from w_inherite`st_1 within w_pdt_02133
end type

type cb_can from w_inherite`cb_can within w_pdt_02133
integer x = 3881
integer y = 5000
integer taborder = 100
boolean enabled = false
end type

type cb_search from w_inherite`cb_search within w_pdt_02133
boolean visible = false
integer x = 1687
integer y = 2592
boolean enabled = false
end type







type gb_button1 from w_inherite`gb_button1 within w_pdt_02133
end type

type gb_button2 from w_inherite`gb_button2 within w_pdt_02133
end type

type gb_4 from groupbox within w_pdt_02133
integer x = 4009
integer y = 272
integer width = 562
integer height = 220
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "실적완료후"
end type

type dw_head from datawindow within w_pdt_02133
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer y = 32
integer width = 2747
integer height = 128
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pdt_02133_1"
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

event itemchanged;String scode, spdsts, spordno, smatchk

if this.getcolumnname() = 'jagbn' then
	wf_reset()
elseif this.getcolumnname() = 'pordno' then
	
	if getitemstring(1, "jagbn") = 'Y' then		/* 신규인 경우 */	
	
		scode = gettext()
		Select matchk, pdsts into :smatchk, :spdsts From momast 
		 where sabu = :gs_sabu And pordno = :scode;
		 
		if sqlca.sqlcode <> 0 then
			f_message_chk(33, '작업지시')
			setitem(1, "pordno", '')
			return 1
		Elseif smatchk = '1' then
			f_message_chk(175, '작업지시')
			setitem(1, "pordno", '')
			return 1						
		Elseif spdsts > '2' then
			f_message_chk(75, '작업지시')
			setitem(1, "pordno", '')
			return 1				
		End if
		
	End if

	p_inq.triggerevent(clicked!)	
end if
end event

event rbuttondown;gs_gubun = '30' 
open(w_jisi_popup)
if isnull(gs_code) or gs_code = "" then 	return
this.SetItem(1, "pordno", gs_code)
triggerevent(itemchanged!)
end event

type ds_update from datawindow within w_pdt_02133
boolean visible = false
integer x = 242
integer y = 2476
integer width = 494
integer height = 360
boolean bringtotop = true
string dataobject = "d_pdt_02130_2"
boolean livescroll = true
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

type dw_hist from datawindow within w_pdt_02133
integer x = 46
integer y = 536
integer width = 4475
integer height = 1000
integer taborder = 30
string dataobject = "d_pdt_02133_3"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event doubleclicked;string sigbn, spordno, sopseq, scdate
Long Lrow
string spdsts, smatchk, sqcgub, sget_data
decimal {3} dpdqty, dcoqty, dpeqty, dsilqty, dijunqty

Lrow = row

if Lrow > 0 then
	
	This.SelectRow(0, FALSE)
	This.SelectRow(Lrow, TRUE)	
	
	if dw_head.getitemstring(1, "jagbn") = 'Y' then		/* 신규인 경우 */
			
		spordno = dw_hist.getitemstring(Lrow, "morout_pordno")
		sopseq  = dw_hist.getitemstring(Lrow, "morout_opseq")		
		
	
		select a.pdsts, a.matchk, b.qcgub, a.pdqty, b.coqty into :spdsts, :smatchk, :sqcgub, :dpdqty, :dcoqty
		  from momast a, morout b
		 where a.sabu = :gs_sabu and a.pordno = :sPordno 
		 	and a.sabu = b.sabu    and a.pordno = b.pordno and b.opseq = :sopseq;
			 
		if spdsts > '2' then
			f_message_chk(118, '[작업지시]')
			return
		End if
		
		if dpdqty = dcoqty then
			f_message_chk(156, '[작업지시]')
			return
		End if		
		
		if smatchk = '1' then
			f_message_chk(116, '[작업공정]')
			return
		End if
		
		if sqcgub = '2' then
			f_message_chk(117, '[작업지시]')
			return
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
		
		if dw_insert.retrieve(gs_sabu, spordno, sopseq) < 1 then
			f_message_chk(33, '작업지시내역')
			return
		End if
		
		wf_chango()  // 창고, 인원, 작업자등을 기본으로 Setting
		
		scdate = f_today()
		dw_insert.setitem(1, "sdate", scdate)
		dw_insert.setitem(1, "edate", scdate)
		
		p_1.enabled = false
		p_nttabl.enabled = false
		p_holdstock.enabled = false
		p_del.enabled = false		
		p_mod.enabled = true
		p_1.PictureName = "c:\erpman\image\불량폐기_d.gif"
		p_nttabl.PictureName = "c:\erpman\image\비가동요인_d.gif"
		p_holdstock.PictureName = "c:\erpman\image\사용자재_d.gif"
		p_del.PictureName = "c:\erpman\image\삭제_d.gif"
		p_mod.PictureName = "c:\erpman\image\저장_up.gif"


		
		dw_insert.setfocus()

	Else
		
		spordno = dw_hist.getitemstring(Lrow, "shpjpno")
	
		if dw_insert.retrieve(gs_sabu, spordno) < 1 then
			f_message_chk(33, '작업실적')
			return
		End if		

		p_1.enabled = true
		p_del.enabled = true
		p_nttabl.enabled = true
		p_holdstock.enabled = true
		p_mod.enabled = false
		
		p_1.PictureName = "c:\erpman\image\불량폐기_up.gif"
		p_nttabl.PictureName = "c:\erpman\image\비가동요인_up.gif"
		p_holdstock.PictureName = "c:\erpman\image\사용자재_up.gif"
		p_del.PictureName = "c:\erpman\image\삭제_up.gif"
		p_mod.PictureName = "c:\erpman\image\저장_d.gif"
				
		dw_insert.setfocus()		
		
	End if
	
End if
end event

type dw_hist_item from datawindow within w_pdt_02133
integer x = 9
integer y = 172
integer width = 3616
integer height = 316
integer taborder = 20
string dataobject = "d_pdt_02133_2"
boolean border = false
end type

type p_1 from uo_picture_01 within w_pdt_02133
integer x = 4027
integer y = 320
integer width = 178
boolean bringtotop = true
boolean enabled = false
boolean originalsize = true
end type

event clicked;call super::clicked;datawindow dwname
dwname = dw_insert
openwithparm(w_pdt_02150, dwname)
dw_insert.setfocus()
end event

type p_nttabl from uo_picture_02 within w_pdt_02133
integer x = 4201
integer y = 320
boolean bringtotop = true
boolean enabled = false
end type

event clicked;call super::clicked;if dw_insert.getrow() > 0 then
	gs_code = dw_insert.getitemstring(dw_insert.getrow(), "shpjpno")
	open(w_pdt_02190)
end if
end event

type p_holdstock from uo_picture_03 within w_pdt_02133
integer x = 4375
integer y = 320
boolean bringtotop = true
boolean enabled = false
end type

event clicked;call super::clicked;if dw_insert.getrow() > 0 then
	gs_code = dw_insert.getitemstring(dw_insert.getrow(), "shpjpno")
	open(w_pdt_02120)
end if
end event

type rr_1 from roundrectangle within w_pdt_02133
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 516
integer width = 4571
integer height = 1036
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pdt_02133
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 18
integer y = 1584
integer width = 4571
integer height = 740
integer cornerheight = 40
integer cornerwidth = 55
end type

