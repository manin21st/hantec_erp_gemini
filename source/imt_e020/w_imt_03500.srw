$PBExportHeader$w_imt_03500.srw
$PBExportComments$외자변동현황
forward
global type w_imt_03500 from w_standard_print
end type
type rr_2 from roundrectangle within w_imt_03500
end type
end forward

global type w_imt_03500 from w_standard_print
string title = "외자변동현황"
rr_2 rr_2
end type
global w_imt_03500 w_imt_03500

forward prototypes
public function integer wf_cust ()
public function integer wf_baljuqty ()
public function integer wf_setdate ()
public function integer wf_retrieve ()
end prototypes

public function integer wf_cust ();string	sCust, sCustName,		&
			sItem, sYearMonth,	&
			sGubun, smoney
long		lRow, lCount
dec      dprice, drate 
sYearMonth = dw_ip.GetItemString(1, "yyyymm")

lCount = dw_list.RowCount()

FOR lRow = 1	TO		lCount
	
	sItem = dw_list.GetItemString(lRow, "itnbr")
	sGubun = dw_list.GetItemString(lRow, "sort")
	
	IF sGubun = '01'	THEN
		SELECT A.MTRVND, B.CVNAS
		  INTO :sCust, :sCustName
		  FROM MTRPLN_SUM A, VNDMST B
		 WHERE A.SABU = :gs_sabu	AND
				 A.MTRVND = B.CVCOD 	AND
				 A.ITNBR = :sItem		AND
				 A.MTRYYMM = :sYearMonth	AND
				 ROWNUM = 1 ;
		
		IF scust = '' or isnull(scust) then 
			dprice = 0 
			drate  = 0
			setnull(smoney) 
		ELSE
		  SELECT "DANMST"."UNPRC", "DANMST"."CUNIT", "DANMST"."STDRATE"  
			 INTO :dPrice, :sMoney, :dRate  
			 FROM "DANMST"  
			WHERE ( "DANMST"."ITNBR" = :sItem ) AND  
					( "DANMST"."CVCOD" = :sCust ) AND
					( "DANMST"."OPSEQ" = '9999' ) ;
		END IF	
	END IF
		dw_list.SetItem(lRow, "cust", 	 sCust)
		dw_list.SetItem(lRow, "custname", sCustName)
		dw_list.SetItem(lRow, "custname2", sCustName)
		dw_list.SetItem(lRow, "danamt", 	 dPRice)
		dw_list.SetItem(lRow, "drate", 	 drate)
		dw_list.SetItem(lRow, "unit",     smoney)
	
NEXT

RETURN 1
end function

public function integer wf_baljuqty ();string	sSort
long		lRow, last_row
dec		dJego_Qty

if dw_list.Accepttext() = -1	then 	return -1

last_row = 	dw_list.RowCount()

FOR lRow = 1	TO	last_row 

	sSort = dw_list.GetITemString(lRow, "sort")
	
	CHOOSE CASE sSort
	CASE '1'
	
		dJego_Qty = dw_list.GetITemDecimal(lRow, "iw_qty")	   	// 현재고대신 월재고로 
		dw_list.SetItem(lRow, "prior_jego", dJego_Qty)				// 이월재고
																					// 재고 -> 다음레코드의 이월재고
		dw_list.SetItem(lRow, "jego", dJego_Qty + 						&
							 dw_list.GetItemDecimal(lRow, "tot_notinqty") +	&				 
							 dw_list.GetItemDecimal(lRow, "notinqty") +	&				 
							 dw_list.GetItemDecimal(lRow, "balju_qty") -	&
							 dw_list.GetItemDecimal(lRow,	"yyyymm") -	&
							 dw_list.GetItemDecimal(lRow, "nextmonth"))						

	CASE '2', '3','4','5'
		dw_list.SetItem(lRow, "prior_jego", dw_list.GetItemDecimal(lRow - 1,"jego"))	// 이월재고 = 전레코드의 재고
																					// 재고 -> 다음레코드의 이월재고
		dw_list.SetItem(lRow, "jego", 											&
							 dw_list.GetItemDecimal(lRow, "prior_jego") +	&				 
							 dw_list.GetItemDecimal(lRow, "notinqty") +	&				 
							 dw_list.GetItemDecimal(lRow, "balju_qty") -	&
							 dw_list.GetItemDecimal(lRow, "nextmonth"))						

	END CHOOSE
	
NEXT

RETURN 1
end function

public function integer wf_setdate ();string	sItem, sYearMonth, sdate, sSort
long		lRow, lCount
double   get_qty, get_dqty
int      i_ldtim, icount, k, iplus

sYearMonth = dw_ip.GetItemString(1, "yyyymm")

lCount =	dw_list.RowCount() 

FOR lRow = 1	TO	 lCount
	
	sSort = dw_list.GetItemString(lRow, "sort")

	If sSort = '1' then 
		sItem = dw_list.GetItemString(lRow, "itnbr")
		
		SELECT "ITEMAS"."LDTIM"  
		  INTO :i_Ldtim  
		  FROM "ITEMAS"  
		 WHERE "ITEMAS"."ITNBR" = :sItem   ;
		//리드타임을 읽어서 없으면 계속 다음 작업
		//리드타임에 한달(30일)기준으로 나눠 정수로 만든 후 그안에 월에는 납기일자가 15 setting
		if i_ldtim = 0 or isnull(i_ldtim) then i_ldtim = 1 
		
		icount = ceiling( i_ldtim / 30 ) 
		
		if icount > 5 then icount = 5 

		iplus = 0
		FOR k = lRow TO lRow + 4
			sdate = dw_list.getitemstring(k, "month")

			dw_list.SetItem(k, "opendate", 	 sdate + '07')
			
			iplus++
			
			if icount >= iplus then  
				dw_list.SetItem(k, "indate", 	 sdate + '15')
			else
				dw_list.SetItem(k, "indate", 	 sdate + '20')
			end if					
		NEXT
	ElseIf sSort = '01' then 
		sItem = dw_list.GetItemString(lRow, "itnbr")
		//기준월 이전 미입고량(어느 시점에서나 변경되지 않은 량) 
		SELECT NVL(SUM(NVL(A.BALQTY,0)) - SUM(NVL(IOQTY,0)), 0) 
	     INTO :get_qty
		  FROM POBLKT A,
             (SELECT SABU, BALJPNO, BALSEQ, SUM(NVL(IOQTY,0)) AS IOQTY
                FROM IMHIST 
               WHERE SABU    = :gs_sabu
					  AND ITNBR   = :sitem
					  AND PSPEC   = '.'            
                 AND IO_DATE < :sYearMonth 
            GROUP BY SABU, BALJPNO, BALSEQ)B
		 WHERE A.SABU  = :gs_sabu	  AND
				 A.ITNBR = :sitem      AND 
				 A.PSPEC =  '.'        AND 
				 A.NADAT < :sYearMonth AND 
             A.SABU = B.SABU(+)    AND  
             A.BALJPNO = B.BALJPNO(+) AND 
             A.BALSEQ = B.BALSEQ(+)    ;
				 
		// 당월 입고량(입고 수량 기준)
	  SELECT SUM(IOSUQTY)  
	    INTO :get_dqty
		 FROM IMHIST  
		WHERE ( SABU = :gs_sabu    ) AND  
				( IO_DATE >= :sYearMonth||'01' ) AND  
				( IO_DATE <= :sYearMonth||'31' ) AND  
				( ITNBR = :sItem      ) AND  
				( PSPEC =  '.'        ) AND
				( POBLNO > '.' )  ;
				
		FOR k = lRow TO lRow + 9
			dw_list.SetItem(k, "tot_notinqty", 	 get_qty)
			dw_list.SetItem(k, "cur_inqty", 	    get_dqty)
		NEXT
   End if
NEXT

RETURN 1
end function

public function integer wf_retrieve ();
if dw_ip.Accepttext() = -1	then 	return -1

string  	sYearMonth,	 sItemFrom,	sItemTo,   sDepot_no, sCvcod,	 &
			sPriorMonth[0 to 9], 	sNextMonth[0 to 4]
int		iSeq[0 to 9],	iCount

sYearMonth = dw_ip.getitemstring(1, "yyyymm")
sDepot_no  = dw_ip.getitemstring(1, "depot_no")
sCvcod     = dw_ip.getitemstring(1, "cvcod")

IF isnull(sYearMonth) or sYearMonth = "" 	THEN
	f_message_chk(30,'[기준년월]')
	dw_ip.SetColumn("yyyymm")
	dw_ip.SetFocus()
	RETURN -1
END IF

IF isnull(sDepot_no) or sDepot_no = "" 	THEN
	IF Messagebox('확 인', '창고를 입력하지 않으면 현재고가 전체창고 수량입니다.' &
	                       +"~n"+ +  '계속 진행 하시겠습니까?',Question!,YesNo!,1)  = 2 THEN
		Return -1
	END IF
	sDepot_no = 'ALL'
END IF

dw_list.setredraw(false)

SetPointer(HourGlass!)

sItemFrom = dw_ip.GetITemString(1, "itnbr1")
sItemTo	 = dw_ip.GetITemString(1, "itnbr2")

IF IsNull(sItemFrom)	or	Trim(sItemFrom) = ''		THEN	sItemFrom = '.'
IF IsNull(sItemTo)	or	Trim(sItemTo) = ''		THEN	sItemTo = 'zzzzzzzzzzzzzzz'

// 9개월 전
sPriorMonth[0] = sYearMonth
FOR iCount = 1		TO		9

		sPriorMonth[iCount] = f_PriorMonth(sPriorMonth[iCount -1])
	
NEXT

// 4개월 후
sNextMonth[0] = sYearMonth
FOR iCount = 1		TO		4

		sNextMonth[iCount] = f_NextMonth(sNextMonth[iCount -1])
	
NEXT


///////////////////////////////////////////////////////////////////////////
// 9개월 전 -> 최대계획차수
///////////////////////////////////////////////////////////////////////////

FOR iCount = 0		TO		9
	
	int	iMaxSeq
	
	  SELECT Max("MRSEQ")  
	    INTO :iMaxSeq  
    	 FROM "MTRPLN_SUM"  
   	WHERE ( "SABU" = :gs_Sabu ) AND  
      	   ( "MTRYYMM" = :sPriorMonth[iCount] )   ;

	IF	IsNull(iMaxSeq)	THEN	iMaxSeq = 0
	iSeq[iCount] = iMaxSeq

NEXT

dw_list.setfilter("")
//////////////////////////////////////////////////////////////////////////////
IF dw_list.Retrieve( gs_Sabu, sItemFrom, sItemTo,	sdepot_no,  & 
            sPriorMonth[9], sPriorMonth[8], sPriorMonth[7], sPriorMonth[6], sPriorMonth[5], &
			   sPriorMonth[4], sPriorMonth[3], sPriorMonth[2], sPriorMonth[1], sYearMonth,	&
				sNextMonth[1],  sNextMonth[2],  sNextMonth[3],  sNextMonth[4],		&
				iSeq[9], iSeq[8], iSeq[7], iSeq[6], iSeq[5],  &
				iSeq[4], iSeq[3], iSeq[2], iSeq[1], iSeq[0] )  < 1		THEN
	dw_ip.SetColumn("yyyymm")
	dw_ip.SetFocus()
	RETURN -1
END IF
						
wf_Cust()

if scvcod > '.' then 
	dw_list.setfilter("cust = '"+ scvcod +" '")
end if	
dw_list.filter()

wf_setdate()

wf_BaljuQty() 

dw_list.setredraw(true)
dw_list.SetFocus()

return 1
end function

on w_imt_03500.create
int iCurrent
call super::create
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
end on

on w_imt_03500.destroy
call super::destroy
destroy(this.rr_2)
end on

event open;call super::open;dw_ip.SetItem(1, 1, left(is_today, 6))

end event

type p_preview from w_standard_print`p_preview within w_imt_03500
end type

type p_exit from w_standard_print`p_exit within w_imt_03500
end type

type p_print from w_standard_print`p_print within w_imt_03500
end type

type p_retrieve from w_standard_print`p_retrieve within w_imt_03500
end type







type st_10 from w_standard_print`st_10 within w_imt_03500
end type



type dw_print from w_standard_print`dw_print within w_imt_03500
string dataobject = "d_imt_03501_p"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_03500
integer x = 18
integer y = 40
integer width = 3589
integer height = 220
string dataobject = "d_imt_03500"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::ue_key;call super::ue_key;//IF keydown(keyF2!) THEN
//   IF	this.getcolumnname() = "cod1"	THEN		
//	   gs_code = this.GetText()
//	   open(w_itemas_popup2)
//	   if isnull(gs_code) or gs_code = "" then 
//			this.SetItem(1, "cod1", "")
//	      this.SetItem(1, "nam1", "")
//	      return
//	   else
//			this.SetItem(1, "cod1", gs_code)
//	      this.SetItem(1, "nam1", gs_codename)
//	      this.triggerevent(itemchanged!)
//	      return 1
//		end if
//   ELSEIF this.getcolumnname() = "cod2" THEN		
//	   gs_code = this.GetText()
//	   open(w_itemas_popup2)
//	   if isnull(gs_code) or gs_code = "" then 	
//			this.SetItem(1, "cod2", "")
//	      this.SetItem(1, "nam2", "")
//	      return
//	   else
//			this.SetItem(1, "cod2", gs_code)
//	      this.SetItem(1, "nam2", gs_codename)
//	      this.triggerevent(itemchanged!)
//	      return 1	
//		end if	
//   END IF
//END IF  
end event

event dw_ip::itemchanged;string	sDate, sNull, scvcod, scvnm
int      ireturn 

SetNull(sNull)

IF this.GetColumnName() = 'yyyymm' THEN

	sDate  = trim(this.gettext()) 
	if sdate = '' or isnull(sdate) then return 
	
	IF f_datechk(sDate + '01') = -1	then
      f_message_chk(35, '[기준년월]')
		this.setitem(1, "yyyymm", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() = 'cvcod'	THEN
	scvcod  = trim(this.gettext()) 
	
	ireturn = f_get_name2('V1', 'Y', scvcod, scvnm, sdate)
	
	SetItem(1,"cvcod",scvcod)
	SetItem(1,"cvnam", scvnm)
	RETURN ireturn 
ELSEIF this.GetColumnName() = 'itnbr1'	THEN
	scvcod  = trim(this.gettext()) 
	
	ireturn = f_get_name2('품번', 'Y', scvcod, scvnm, sdate)
	
	SetItem(1,"itnbr1",scvcod)
	SetItem(1,"itdsc1", scvnm)
	RETURN ireturn 	
ELSEIF this.GetColumnName() = 'itnbr2'	THEN
	scvcod  = trim(this.gettext()) 
	
	ireturn = f_get_name2('품번', 'Y', scvcod, scvnm, sdate)
	
	SetItem(1,"itnbr2",scvcod)
	SetItem(1,"itdsc2", scvnm)
	RETURN ireturn 	
ELSEIF this.GetColumnName() = 'itdsc1'	THEN
	scvnm  = trim(this.gettext()) 
	
	ireturn = f_get_name2('품명', 'Y', scvcod, scvnm, sdate)
	
	SetItem(1,"itnbr1",scvcod)
	SetItem(1,"itdsc1", scvnm)
	RETURN ireturn 		
ELSEIF this.GetColumnName() = 'itdsc2'	THEN
	scvnm  = trim(this.gettext()) 
	
	ireturn = f_get_name2('품명', 'Y', scvcod, scvnm, sdate)
	
	SetItem(1,"itnbr2",scvcod)
	SetItem(1,"itdsc2", scvnm)
	RETURN ireturn 			
END IF
end event

event dw_ip::rbuttondown;
gs_code = ''
gs_codename = ''
gs_gubun = ''

// 품번
IF this.GetColumnName() = 'itnbr1'	THEN

	open(w_itemas_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1,"itnbr1",gs_code)
	SetItem(1,"itdsc1",gs_codename)	

elseIF this.GetColumnName() = 'itnbr2'	THEN

	open(w_itemas_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1,"itnbr2",gs_code)
	SetItem(1,"itdsc2",gs_codename)	

ELSEIF this.GetColumnName() = 'cvcod'	THEN
   gs_gubun = '1' 
	
	open(w_vndmst_popup)
	
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1,"cvcod",gs_code)
	SetItem(1,"cvnam",gs_codename)

END IF
end event

type dw_list from w_standard_print`dw_list within w_imt_03500
integer y = 272
integer width = 4571
integer height = 2056
string dataobject = "d_imt_03501"
end type

type rr_2 from roundrectangle within w_imt_03500
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 23
integer y = 260
integer width = 4603
integer height = 2084
integer cornerheight = 40
integer cornerwidth = 55
end type

