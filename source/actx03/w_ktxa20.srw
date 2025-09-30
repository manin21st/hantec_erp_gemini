$PBExportHeader$w_ktxa20.srw
$PBExportComments$수출실적증명서 처리
forward
global type w_ktxa20 from w_inherite
end type
type cb_process from commandbutton within w_ktxa20
end type
type tab_suchul from tab within w_ktxa20
end type
type tabpage_process from userobject within tab_suchul
end type
type rr_1 from roundrectangle within tabpage_process
end type
type dw_suchul from u_key_enter within tabpage_process
end type
type tabpage_process from userobject within tab_suchul
rr_1 rr_1
dw_suchul dw_suchul
end type
type tabpage_print1 from userobject within tab_suchul
end type
type rr_2 from roundrectangle within tabpage_print1
end type
type dw_print from datawindow within tabpage_print1
end type
type tabpage_print1 from userobject within tab_suchul
rr_2 rr_2
dw_print dw_print
end type
type tabpage_print2 from userobject within tab_suchul
end type
type rr_3 from roundrectangle within tabpage_print2
end type
type dw_print2 from datawindow within tabpage_print2
end type
type tabpage_print2 from userobject within tab_suchul
rr_3 rr_3
dw_print2 dw_print2
end type
type tabpage_label from userobject within tab_suchul
end type
type rr_4 from roundrectangle within tabpage_label
end type
type dw_label from datawindow within tabpage_label
end type
type tabpage_label from userobject within tab_suchul
rr_4 rr_4
dw_label dw_label
end type
type tab_suchul from tab within w_ktxa20
tabpage_process tabpage_process
tabpage_print1 tabpage_print1
tabpage_print2 tabpage_print2
tabpage_label tabpage_label
end type
type dw_file from datawindow within w_ktxa20
end type
end forward

global type w_ktxa20 from w_inherite
integer width = 4677
integer height = 2436
string title = "수출실적증명서 처리"
cb_process cb_process
tab_suchul tab_suchul
dw_file dw_file
end type
global w_ktxa20 w_ktxa20

type variables
Int ll_row
String s_jasacode,sRptPath,sApplyFlag
end variables

forward prototypes
public subroutine wf_suchul_print_amt_setting (string sdate, string edate, string sjasa)
public function integer wf_label_print ()
public function integer wf_require_chk (integer curr_row)
public function integer wf_suchul_print ()
end prototypes

public subroutine wf_suchul_print_amt_setting (string sdate, string edate, string sjasa);Integer   iTotalCnt,iLoopCnt,iCurrCnt,iYTotalCnt,iYoungCnt
Double    dForAmt,dTotalGonAmt =0,dTotalForAmt =0,dYForAmt,dYTotalAmt
String    sCurr

iTotalCnt    = tab_suchul.tabpage_print1.dw_print.getitemNumber(1, 'total_count')
dTotalGonAmt = tab_suchul.tabpage_print1.dw_print.getitemdecimal(1, 'total_gon')

/*기타영세율 금액*/
SELECT SUM(NVL(A.CNT,0)),	SUM(NVL(A.GON_AMT,0))
INTO :iYTotalCnt,				:dYTotalAmt
FROM(
		SELECT COUNT("KFZ17OT0"."EXPNO") AS CNT,		SUM("KFZ17OT0"."GON_AMT") AS GON_AMT	 
			 FROM "KFZ17OT0"
			WHERE ( "KFZ17OT0"."ALC_GU" = 'Y' ) AND  
					(( "KFZ17OT0"."TAX_NO" = '26' ) OR 
					 ("KFZ17OT0"."TAX_NO" = '99' )) AND  
					( "KFZ17OT0"."IO_GU" = '2' ) AND
					( "KFZ17OT0"."GEY_DATE" >= :sDate ) AND  
					( "KFZ17OT0"."GEY_DATE" <= :eDate ) AND  
					( "KFZ17OT0"."JASA_CD" like :sJasa )
		) A ;
		
IF SQLCA.SQLCODE <> 0 THEN
	dYTotalAmt = 0
ELSE
	IF IsNull(dYTotalAmt) THEN dYTotalAmt = 0
END IF

declare Cursor_CurrLst Cursor For
	select k.curr, sum(nvl(k.cnt,0)),  sum(nvl(k.foramt,0)),  sum(nvl(k.cnt_y,0)), sum(nvl(k.foramt_y,0))
	from(
		select curr,	 Count(*) as cnt,		 sum(nvl(for_amt,0)) as foramt, 0 as cnt_y, 0 as foramt_y
		from kfz17ot0
		where alc_gu = 'Y' and (tax_no = '23' or tax_no = '99') and
				io_gu = '2' and curr <> 'WON' and 
				gey_date >= :sDate and gey_date <= :eDate and jasa_cd like :sJasa 
		group by curr
		union all
		select curr,	 0 as cnt,		 0 as foramt, Count(*) as cnt_y, sum(nvl(for_amt,0)) as foramt_y
		from kfz17ot0
		where alc_gu = 'Y' and (tax_no = '26' or tax_no = '99') and
				io_gu = '2' and 
				gey_date >= :sDate and gey_date <= :eDate and jasa_cd like :sJasa 
		group by curr

		) k
	group by k.curr ;

Open Cursor_CurrLst;

iLoopCnt = 1

Do While True
	Fetch Cursor_CurrLst Into :sCurr,	:iCurrCnt,		:dForAmt, :iYoungCnt, :dYForAmt ;
	IF Sqlca.Sqlcode <> 0 THEN Exit
	
	sCurr = f_Get_Refferance('10',sCurr)
	
	if iLoopCnt > 8 then
		dTotalForAmt = dTotalForAmt + dForAmt	
	else
		tab_suchul.tabpage_print1.dw_print.Modify("txt_curr"+ String(iLoopCnt) + ".Text='" + sCurr + "'")	
		tab_suchul.tabpage_print1.dw_print.Modify("txt_foramt"+ String(iLoopCnt) + ".Text='" + String(dForAmt,'###,###.00') + "'")	
		
		tab_suchul.tabpage_print1.dw_print.Modify("txt_scurr"+ String(iLoopCnt) + ".Text='" + sCurr + "'")	
		tab_suchul.tabpage_print1.dw_print.Modify("txt_sforamt"+ String(iLoopCnt) + ".Text='" + String(dForAmt + dYForAmt,'###,###.00') + "'")

		tab_suchul.tabpage_print1.dw_print.Modify("txt_ycurr"+ String(iLoopCnt) + ".Text='" + sCurr + "'")	
		tab_suchul.tabpage_print1.dw_print.Modify("txt_yforamt"+ String(iLoopCnt) + ".Text='" + String(dYForAmt,'###,###.00') + "'")

		tab_suchul.tabpage_print1.dw_print.Modify("txt_hcurr"+ String(iLoopCnt) + ".Text='" + sCurr + "'")	
		tab_suchul.tabpage_print1.dw_print.Modify("txt_hforamt"+ String(iLoopCnt) + ".Text='" + String(dForAmt + dYForAmt,'###,###.00') + "'")
	end if
	iLoopCnt = iLoopCnt + 1
Loop
Close Cursor_CurrLst;

if dTotalForAmt <> 0 then
	sCurr = '기타'
	tab_suchul.tabpage_print1.dw_print.Modify("txt_curr"+ String(9) + ".Text='" + sCurr + "'")	
	tab_suchul.tabpage_print1.dw_print.Modify("txt_foramt"+ String(9) + ".Text='" + String(dTotalForAmt,'###,###.00') + "'")	
		
	tab_suchul.tabpage_print1.dw_print.Modify("txt_scurr"+ String(9) + ".Text='" + sCurr + "'")	
	tab_suchul.tabpage_print1.dw_print.Modify("txt_sforamt"+ String(9) + ".Text='" + String(dTotalForAmt,'###,###.00') + "'")

	tab_suchul.tabpage_print1.dw_print.Modify("txt_hcurr"+ String(9) + ".Text='" + sCurr + "'")	
	tab_suchul.tabpage_print1.dw_print.Modify("txt_hforamt"+ String(9) + ".Text='" + String(dTotalForAmt,'###,###.00') + "'")	
end if

tab_suchul.tabpage_print1.dw_print.Modify("total_count_t.text = '" + String(iTotalCnt + iYTotalCnt,'###,###') + "'")	
tab_suchul.tabpage_print1.dw_print.Modify("total_count1_t.text = '" + String(iTotalCnt,'###,###') + "'")	
tab_suchul.tabpage_print1.dw_print.Modify("young_count_t.text = '" + String(iYTotalCnt,'###,###') + "'")	

tab_suchul.tabpage_print1.dw_print.Modify("total_gon_t.text = '" + String(dTotalGonAmt + dYTotalAmt,'###,###') + "'")	
tab_suchul.tabpage_print1.dw_print.Modify("young_won_t.text = '" + String(dYTotalAmt,'###,###') + "'")	

tab_suchul.tabpage_print1.dw_print.Modify("total_won1_t.text = '" + String(dTotalGonAmt,'###,###') + "'")	
tab_suchul.tabpage_print1.dw_print.Modify("total_won2_t.text = '" + String(dTotalGonAmt + dYTotalAmt,'###,###') + "'")

	
end subroutine

public function integer wf_label_print ();
String sJasa, sStart, sEnd, sCrtDate

w_mdi_frame.sle_msg.text =""

if tab_suchul.tabpage_process.dw_suchul.AcceptText() = -1 then return -1
sjasa    = tab_suchul.tabpage_process.dw_suchul.GetItemString(tab_suchul.tabpage_process.dw_suchul.GetRow(),"jasacode")
sStart   = tab_suchul.tabpage_process.dw_suchul.getitemstring(tab_suchul.tabpage_process.dw_suchul.getrow(),"efromdate")
sEnd     = tab_suchul.tabpage_process.dw_suchul.getitemstring(tab_suchul.tabpage_process.dw_suchul.getrow(),"etodate")
sCrtDate = Trim(tab_suchul.tabpage_process.dw_suchul.getitemstring(tab_suchul.tabpage_process.dw_suchul.getrow(),"crtdate"))

IF sCrtDate = "" OR IsNull(sCrtDate) THEN
	sCrtDate = String(f_Today(),'@@@@.@@.@@')	
ELSE
	sCrtDate = String(sCrtDate,'@@@@.@@.@@')	
END IF

tab_suchul.tabpage_label.dw_label.setredraw(false)

if tab_suchul.tabpage_label.dw_label.Retrieve(sCrtDate,sStart,sEnd,sjasa) <=0 then
	tab_suchul.tabpage_label.dw_label.Reset()
	tab_suchul.tabpage_label.dw_label.InsertRow(0)
END IF
tab_suchul.tabpage_label.dw_label.setredraw(True)
			
w_mdi_frame.sle_msg.Text ="디스켓 표지를 조회 완료했습니다.!!!"	
SetPointer(Arrow!)

Return 1
end function

public function integer wf_require_chk (integer curr_row);String sGubun,sJasa,sSano,sOwnernm,sSangho,sUptae,sUpjong,sAddr,&
       sEyymm,sEcrtdate,sEfromdate,sEtodate,sFilename = ' '

sGubun = tab_suchul.tabpage_process.dw_suchul.GetItemString(curr_row,"gubun")		/*신고구분(1:1개월,2:2개월,3:3개월,4:6개월)*/
IF sGubun ="" OR IsNull(sGubun) THEN
	f_messagechk(1,"【신고구분】")
	tab_suchul.tabpage_process.dw_suchul.SetColumn("gubun")
	tab_suchul.tabpage_process.dw_suchul.SetFocus()
	RETURN -1
END IF   	

sEyymm = tab_suchul.tabpage_process.dw_suchul.GetItemString(curr_row,"eyymm")
IF sEyymm ="" OR IsNull(sEyymm) THEN
	f_messagechk(1,"【신고대상종료년월】")
	tab_suchul.tabpage_process.dw_suchul.SetColumn("eyymm")
	tab_suchul.tabpage_process.dw_suchul.SetFocus()
	RETURN -1
END IF   	

sEcrtdate = tab_suchul.tabpage_process.dw_suchul.GetItemString(curr_row,"crtdate")
IF sEcrtdate ="" OR IsNull(sEcrtdate) THEN
	f_messagechk(1,"【작성일자】")
	tab_suchul.tabpage_process.dw_suchul.SetColumn("crtdate")
	tab_suchul.tabpage_process.dw_suchul.SetFocus()
	RETURN -1
END IF   	

sJasa = tab_suchul.tabpage_process.dw_suchul.GetItemString(curr_row,"jasacode")
IF sJasa ="" OR IsNull(sJasa) THEN
	f_messagechk(1,"【자사코드】")
	tab_suchul.tabpage_process.dw_suchul.SetColumn("jasacode")
	tab_suchul.tabpage_process.dw_suchul.SetFocus()
	RETURN -1
END IF   	

sOwnernm = tab_suchul.tabpage_process.dw_suchul.GetItemString(curr_row,"ownernm")
IF sOwnernm ="" OR IsNull(sOwnernm) THEN
	f_messagechk(1,"【성명】")
	tab_suchul.tabpage_process.dw_suchul.SetColumn("ownernm")
	tab_suchul.tabpage_process.dw_suchul.SetFocus()
	RETURN -1
END IF   	

sSangho = tab_suchul.tabpage_process.dw_suchul.GetItemString(curr_row,"sangho")
IF sSangho ="" OR IsNull(sSangho) THEN
	f_messagechk(1,"【상호】")
	tab_suchul.tabpage_process.dw_suchul.SetColumn("sangho")
	tab_suchul.tabpage_process.dw_suchul.SetFocus()
	RETURN -1
END IF   	

sUptae = tab_suchul.tabpage_process.dw_suchul.GetItemString(curr_row,"uptae")
IF sUptae ="" OR IsNull(sUptae) THEN
	f_messagechk(1,"【업태】")
	tab_suchul.tabpage_process.dw_suchul.SetColumn("uptae")
	tab_suchul.tabpage_process.dw_suchul.SetFocus()
	RETURN -1
END IF   	

sUpjong = tab_suchul.tabpage_process.dw_suchul.GetItemString(curr_row,"upjong")
IF sUpjong ="" OR IsNull(sUpjong) THEN
	f_messagechk(1,"【업종】")
	tab_suchul.tabpage_process.dw_suchul.SetColumn("upjong")
	tab_suchul.tabpage_process.dw_suchul.SetFocus()
	RETURN -1
END IF   	

Return 1
end function

public function integer wf_suchul_print ();
String sJasa, sStart, sEnd, sCrtDate
Int il_currow , il_RetrieveRow, i, il_dvdval, i_count, itotal, i_count2, k
dec  dwon, djpy, dusd 

w_mdi_frame.sle_msg.text =""

if tab_suchul.tabpage_process.dw_suchul.AcceptText() = -1 then return -1
sjasa    = tab_suchul.tabpage_process.dw_suchul.GetItemString(tab_suchul.tabpage_process.dw_suchul.GetRow(),"jasacode")
sStart   = tab_suchul.tabpage_process.dw_suchul.getitemstring(tab_suchul.tabpage_process.dw_suchul.getrow(),"efromdate")
sEnd     = tab_suchul.tabpage_process.dw_suchul.getitemstring(tab_suchul.tabpage_process.dw_suchul.getrow(),"etodate")
sCrtDate = Trim(tab_suchul.tabpage_process.dw_suchul.getitemstring(tab_suchul.tabpage_process.dw_suchul.getrow(),"crtdate"))

IF sCrtDate = "" OR IsNull(sCrtDate) THEN
	sCrtDate = String(f_Today(),'@@@@.@@.@@')	
ELSE
	sCrtDate = String(sCrtDate,'@@@@.@@.@@')	
END IF

tab_suchul.tabpage_print1.dw_print.setredraw(false)
tab_suchul.tabpage_print2.dw_print2.setredraw(false)

tab_suchul.tabpage_print1.dw_print.setfilter("")

il_RetrieveRow = tab_suchul.tabpage_print1.dw_print.Retrieve(sCrtDate,sStart,sEnd,sjasa)

if il_RetrieveRow <=0  THEN															
	f_Messagechk(14,"") 
	tab_suchul.tabpage_print2.dw_print2.reset()
	tab_suchul.tabpage_print1.dw_print.setredraw(true)
	tab_suchul.tabpage_print2.dw_print2.setredraw(true)
	Return -1
else
	tab_suchul.tabpage_print2.dw_print2.reset()
	
	Wf_Suchul_Print_Amt_Setting(sStart,sEnd,sJasa)
	
	tab_suchul.tabpage_print1.dw_print.setfilter("ycount <= 14 ")
	tab_suchul.tabpage_print1.dw_print.Filter()

	i_count2 = tab_suchul.tabpage_print2.dw_print2.Retrieve(sCrtDate,sStart,sEnd,sjasa)
	
	if i_count2 > 14 then 
		FOR i_count = 14 TO 1 step -1 
			tab_suchul.tabpage_print2.dw_print2.deleterow(i_count) 
		NEXT
		
		i_count2 = i_count2 - 14
		
		k = mod(i_count2, 43) + 1
		
		FOR i_count = k TO 43
			tab_suchul.tabpage_print2.dw_print2.insertrow(0)
		NEXT
	else
		tab_suchul.tabpage_print2.dw_print2.reset()
	end if
END IF
tab_suchul.tabpage_print1.dw_print.setredraw(true)
tab_suchul.tabpage_print2.dw_print2.setredraw(true)

tab_suchul.tabpage_print1.dw_print.object.datawindow.print.preview = "yes"
tab_suchul.tabpage_print2.dw_print2.object.datawindow.print.preview = "yes"
			
w_mdi_frame.sle_msg.Text ="수출실적 명세서를 조회 완료했습니다.!!!"	
SetPointer(Arrow!)

Return 1

end function

on w_ktxa20.create
int iCurrent
call super::create
this.cb_process=create cb_process
this.tab_suchul=create tab_suchul
this.dw_file=create dw_file
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_process
this.Control[iCurrent+2]=this.tab_suchul
this.Control[iCurrent+3]=this.dw_file
end on

on w_ktxa20.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_process)
destroy(this.tab_suchul)
destroy(this.dw_file)
end on

event open;call super::open;String sGubun,sJasa,sSano,sOwnernm,sSangho,sUptae,sUpjong,sAddr,sFilename
Integer iEyymm,iEcrtdate,iEfromdate,iEtodate
		 
tab_suchul.tabpage_process.dw_suchul.SetTransObject(SQLCA)
tab_suchul.tabpage_print1.dw_print.SetTransObject(SQLCA)
tab_suchul.tabpage_print2.dw_print2.SetTransObject(SQLCA)
tab_suchul.tabpage_label.dw_label.SetTransObject(SQLCA)

dw_file.Settransobject(sqlca)

SELECT "VNDMST"."CVCOD",   "VNDMST"."SANO",   "VNDMST"."OWNAM",   
		 "VNDMST"."CVNAS",   "VNDMST"."UPTAE",  "VNDMST"."JONGK",
		 NVL("VNDMST"."ADDR1",' ') || NVL("VNDMST"."ADDR2",' ')  
	INTO :sJasa,   			:sSano,   			 :sOwnernm,   
        :sSangho,   	  	   :sUptae,   			 :sUpjong,   
        :sAddr  
	FROM "VNDMST","SYSCNFG"  
   WHERE "VNDMST"."CVCOD" = SUBSTR("SYSCNFG"."DATANAME",1,6) AND
			"SYSCNFG"."SYSGU" = 'C' AND
			"SYSCNFG"."SERIAL" = 4 AND "SYSCNFG"."LINENO" = '1';
			
tab_suchul.tabpage_process.dw_suchul.Reset()
tab_suchul.tabpage_process.dw_suchul.InsertRow(0)

sFilename = "A" + Left(sSano,7) + "." + Right(sSano,3)

tab_suchul.tabpage_process.dw_suchul.SetItem(tab_suchul.tabpage_process.dw_suchul.GetRow(),"gubun", '1')
tab_suchul.tabpage_process.dw_suchul.SetItem(tab_suchul.tabpage_process.dw_suchul.GetRow(),"eyymm", left(f_today(),6))
tab_suchul.tabpage_process.dw_suchul.SetItem(tab_suchul.tabpage_process.dw_suchul.GetRow(),"efromdate", left(f_today(),6)+'01')
tab_suchul.tabpage_process.dw_suchul.SetItem(tab_suchul.tabpage_process.dw_suchul.GetRow(),"etodate", left(f_today(),6)+right(f_last_date(left(f_today(),6)),2))
tab_suchul.tabpage_process.dw_suchul.SetItem(tab_suchul.tabpage_process.dw_suchul.GetRow(),"crtdate", left(f_today(),6)+right(f_last_date(left(f_today(),6)),2))

tab_suchul.tabpage_process.dw_suchul.SetItem(tab_suchul.tabpage_process.dw_suchul.GetRow(),"jasacode",sJasa)
tab_suchul.tabpage_process.dw_suchul.SetItem(tab_suchul.tabpage_process.dw_suchul.GetRow(),"sano",sSano)
tab_suchul.tabpage_process.dw_suchul.SetItem(tab_suchul.tabpage_process.dw_suchul.GetRow(),"ownernm",sOwnernm)
tab_suchul.tabpage_process.dw_suchul.SetItem(tab_suchul.tabpage_process.dw_suchul.GetRow(),"sangho",sSangho)
tab_suchul.tabpage_process.dw_suchul.SetItem(tab_suchul.tabpage_process.dw_suchul.GetRow(),"uptae",sUptae)
tab_suchul.tabpage_process.dw_suchul.SetItem(tab_suchul.tabpage_process.dw_suchul.GetRow(),"upjong",sUpjong)
tab_suchul.tabpage_process.dw_suchul.SetItem(tab_suchul.tabpage_process.dw_suchul.GetRow(),"addr",sAddr)
tab_suchul.tabpage_process.dw_suchul.SetItem(tab_suchul.tabpage_process.dw_suchul.GetRow(),"filename",sFilename)

string	sPath

/*저장위치*/
select dataname	into :sPath	
from syscnfg where sysgu = 'A' and serial = 15 and lineno = '2';

if sPath = '' or IsNull(sPath) then sPath = 'c:\'

tab_suchul.tabpage_process.dw_suchul.SetItem(1,"spath",sPath)

tab_suchul.tabpage_process.dw_suchul.SetColumn("gubun")
tab_suchul.tabpage_process.dw_suchul.SetFocus()

tab_suchul.SelectedTab = 1
end event

type dw_insert from w_inherite`dw_insert within w_ktxa20
boolean visible = false
integer x = 165
integer y = 2772
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_ktxa20
boolean visible = false
integer x = 1705
integer y = 2772
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_ktxa20
boolean visible = false
integer x = 1531
integer y = 2772
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_ktxa20
boolean visible = false
integer x = 837
integer y = 2772
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_ktxa20
boolean visible = false
integer x = 1358
integer y = 2772
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_ktxa20
integer x = 4416
integer taborder = 30
end type

type p_can from w_inherite`p_can within w_ktxa20
boolean visible = false
integer x = 2226
integer y = 2772
integer taborder = 0
end type

type p_print from w_inherite`p_print within w_ktxa20
integer x = 4242
integer y = 28
integer taborder = 40
end type

event p_print::clicked;call super::clicked;if tab_suchul.SelectedTab = 2 or tab_suchul.SelectedTab = 3 then
	if tab_suchul.tabpage_print1.dw_print.RowCount() > 0 then
		gi_page = tab_suchul.tabpage_print1.dw_print.GetItemNumber(1,"last_page")
		OpenWithParm(w_print_options,tab_suchul.tabpage_print1.dw_print)	
	end if
	if tab_suchul.tabpage_print2.dw_print2.RowCount() > 0 then
		gi_page = tab_suchul.tabpage_print2.dw_print2.GetItemNumber(1,"last_page")
		OpenWithParm(w_print_options,tab_suchul.tabpage_print2.dw_print2)	
	end if
else
	gi_page = tab_suchul.tabpage_label.dw_label.GetItemNumber(1,"last_page")
	OpenWithParm(w_print_options,tab_suchul.tabpage_label.dw_label)	
end if

end event

type p_inq from w_inherite`p_inq within w_ktxa20
boolean visible = false
integer x = 1184
integer y = 2772
integer taborder = 0
end type

type p_del from w_inherite`p_del within w_ktxa20
boolean visible = false
integer x = 2053
integer y = 2772
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_ktxa20
event ue_work pbm_custom01
integer x = 4069
integer y = 28
integer taborder = 20
string pointer = "C:\erpman\cur\create.cur"
string picturename = "C:\erpman\image\처리_up.gif"
end type

event p_mod::clicked;String sGubun,sJasa,sSano,sOwnernm,sSangho,sUptae,sUpjong,sAddr,&
       sEyymm,sEcrtdate,sEfromdate,sEtodate,sPath,sFilename = ' '
Long iCount

String  IsCommJasa, IsApplyFlag

tab_suchul.tabpage_process.dw_suchul.AcceptText()

IF wf_require_chk(tab_suchul.tabpage_process.dw_suchul.GetRow()) = -1 THEN RETURN 

sGubun 		= tab_suchul.tabpage_process.dw_suchul.GetItemString(tab_suchul.tabpage_process.dw_suchul.GetRow(),"gubun")
sEyymm 		= tab_suchul.tabpage_process.dw_suchul.GetItemString(tab_suchul.tabpage_process.dw_suchul.GetRow(),"eyymm")
sEfromdate  = tab_suchul.tabpage_process.dw_suchul.GetItemString(tab_suchul.tabpage_process.dw_suchul.GetRow(),"efromdate")
sEtodate    = tab_suchul.tabpage_process.dw_suchul.GetItemString(tab_suchul.tabpage_process.dw_suchul.GetRow(),"etodate")
sEcrtdate 	= tab_suchul.tabpage_process.dw_suchul.GetItemString(tab_suchul.tabpage_process.dw_suchul.GetRow(),"crtdate")
sJasa 		= tab_suchul.tabpage_process.dw_suchul.GetItemString(tab_suchul.tabpage_process.dw_suchul.GetRow(),"jasacode")
sSano       = tab_suchul.tabpage_process.dw_suchul.GetItemString(tab_suchul.tabpage_process.dw_suchul.GetRow(),"sano")
sOwnernm 	= tab_suchul.tabpage_process.dw_suchul.GetItemString(tab_suchul.tabpage_process.dw_suchul.GetRow(),"ownernm")
sSangho 		= tab_suchul.tabpage_process.dw_suchul.GetItemString(tab_suchul.tabpage_process.dw_suchul.GetRow(),"sangho")
sUptae 		= tab_suchul.tabpage_process.dw_suchul.GetItemString(tab_suchul.tabpage_process.dw_suchul.GetRow(),"uptae")
sUpjong 		= tab_suchul.tabpage_process.dw_suchul.GetItemString(tab_suchul.tabpage_process.dw_suchul.GetRow(),"upjong")
sAddr			= tab_suchul.tabpage_process.dw_suchul.GetItemString(tab_suchul.tabpage_process.dw_suchul.GetRow(),"addr")
sFilename   = tab_suchul.tabpage_process.dw_suchul.GetItemString(tab_suchul.tabpage_process.dw_suchul.GetRow(),"filename")
sPath       = tab_suchul.tabpage_process.dw_suchul.GetItemString(tab_suchul.tabpage_process.dw_suchul.GetRow(),"spath")

SetPointer(HourGlass!)

IsCommJasa = sJasa
IsApplyFlag = '%'
	
select Count(*) into :iCount from KFZ_EXP_WORK	where fdate = :sEfromdate and tdate = :sEtodate and saupno = :IsCommJasa ;
if sqlca.sqlcode <> 0 then
	iCount = 0
end if
if iCount > 0 then
	if MessageBox('확 인','이미 집계자료가 있습니다. 삭제 후 다시 집계하시겠습니까?',Question!,YesNo!) = 2 then return
end if

w_mdi_frame.sle_msg.text ="수출실적증명서 자료 생성 중"

String  sMsg
Integer iReturn = 1

DECLARE start_acsp_create_vatfile_export PROCEDURE FOR acsp_create_vatfile_export(:sEcrtdate, :sGubun, :sEfromdate, :sEtodate,  :IsCommJasa, :sJasa, :IsApplyFlag);
EXECUTE start_acsp_create_vatfile_export;
FETCH start_acsp_create_vatfile_export  INTO :iReturn, :sMsg ;

if iReturn = -9 then
	rollback;
	Messagebox('확인','생성할 자료가 없습니다.')
	w_mdi_frame.sle_msg.text =""
	return	
elseif iReturn <> 1 then
	rollback;
	Messagebox('확인','자료생성을 실패하였습니다.')
	w_mdi_frame.sle_msg.text =""
	return
end if	
commit;

SetPointer(Arrow!)
MessageBox('확인','수출실적증명서 집계 완료하였습니다')

w_mdi_frame.sle_msg.text = "수출실적증명서 생성 완료  "

//화일 REGEDIT읽어서 저장
string	sSavefile

sSavefile = sPath + sFileName

if dw_file.Retrieve(sEfromdate,sEtodate,sJasa) <=0 then
	MessageBox('확인','생성한 자료가 없습니다')
	
	return
else
	dw_file.SaveAs(sSavefile, Text!, FALSE)
	
	w_mdi_frame.sle_msg.text = "수출실적증명서 파일 완료  " + "【" + sSavefile + "】" 
end if



end event

event p_mod::ue_lbuttondown;PictureName = "C:\erpman\image\처리_dn.gif"
end event

event p_mod::ue_lbuttonup;PictureName = "C:\erpman\image\처리_up.gif"
end event

type cb_exit from w_inherite`cb_exit within w_ktxa20
integer x = 3209
integer y = 2792
end type

type cb_mod from w_inherite`cb_mod within w_ktxa20
integer x = 2021
integer y = 2948
end type

type cb_ins from w_inherite`cb_ins within w_ktxa20
integer x = 1664
integer y = 2948
end type

type cb_del from w_inherite`cb_del within w_ktxa20
integer x = 2377
integer y = 2948
end type

type cb_inq from w_inherite`cb_inq within w_ktxa20
integer x = 1307
integer y = 2948
end type

type cb_print from w_inherite`cb_print within w_ktxa20
integer x = 2857
integer y = 2788
end type

type st_1 from w_inherite`st_1 within w_ktxa20
end type

type cb_can from w_inherite`cb_can within w_ktxa20
integer x = 2734
integer y = 2948
end type

type cb_search from w_inherite`cb_search within w_ktxa20
integer x = 3090
integer y = 2948
end type



type sle_msg from w_inherite`sle_msg within w_ktxa20
textcase textcase = upper!
end type



type gb_button1 from w_inherite`gb_button1 within w_ktxa20
integer x = 1271
integer y = 2892
end type

type gb_button2 from w_inherite`gb_button2 within w_ktxa20
integer x = 2469
integer y = 2736
integer width = 1111
long backcolor = 12632256
end type

type cb_process from commandbutton within w_ktxa20
boolean visible = false
integer x = 2505
integer y = 2788
integer width = 334
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "처리(&S)"
end type

type tab_suchul from tab within w_ktxa20
integer x = 64
integer y = 184
integer width = 4526
integer height = 2040
integer taborder = 10
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean raggedright = true
boolean boldselectedtext = true
integer selectedtab = 1
tabpage_process tabpage_process
tabpage_print1 tabpage_print1
tabpage_print2 tabpage_print2
tabpage_label tabpage_label
end type

on tab_suchul.create
this.tabpage_process=create tabpage_process
this.tabpage_print1=create tabpage_print1
this.tabpage_print2=create tabpage_print2
this.tabpage_label=create tabpage_label
this.Control[]={this.tabpage_process,&
this.tabpage_print1,&
this.tabpage_print2,&
this.tabpage_label}
end on

on tab_suchul.destroy
destroy(this.tabpage_process)
destroy(this.tabpage_print1)
destroy(this.tabpage_print2)
destroy(this.tabpage_label)
end on

event selectionchanged;
if newindex = 1 then
	p_mod.Enabled = True
	p_print.Enabled   = False
else
	p_mod.Enabled = False
	p_print.Enabled   = True
	
	if newindex = 2 or newindex = 3 then
		if Wf_Suchul_Print() = -1 then 
			p_print.Enabled = False
		else
			p_print.Enabled = True
		end if
	else
		if Wf_Label_Print() = -1 then 
			p_print.Enabled = False
		else
			p_print.Enabled = True
		end if
	end if
end if
end event

type tabpage_process from userobject within tab_suchul
integer x = 18
integer y = 96
integer width = 4489
integer height = 1928
long backcolor = 32106727
string text = "디스켓 생성"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_1 rr_1
dw_suchul dw_suchul
end type

on tabpage_process.create
this.rr_1=create rr_1
this.dw_suchul=create dw_suchul
this.Control[]={this.rr_1,&
this.dw_suchul}
end on

on tabpage_process.destroy
destroy(this.rr_1)
destroy(this.dw_suchul)
end on

type rr_1 from roundrectangle within tabpage_process
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 24
integer width = 4448
integer height = 1892
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_suchul from u_key_enter within tabpage_process
integer x = 402
integer y = 156
integer width = 3419
integer height = 1716
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_ktxa201"
boolean border = false
end type

event itemerror;rETURN 1
end event

event itemchanged;String sGubun,sJasa,sSano,sOwnernm,sSangho,sUptae,sUpjong,sAddr1,sAddr2,&
       sEyymm,sEyymmadd,sCrtdate,sEfromdate,sEtodate,sPath,sFilename = ' ',snull,sProcGbn,sCommJasa
Long lGubun,lDate,lCrtdate,lSpace_length
Double dFromtodate
Boolean date_chk,function_chk

SetNull(snull)

IF this.GetColumnName() = "gubun" THEN
	sGubun 		= this.GetText()
	
	IF sGubun = "" OR IsNull(sGubun) THEN Return
	
	sEyymm 		= this.GetItemString(this.Getrow(),'eyymm')
	If sGubun = '4' Then
		sEyymmadd  = String(Long(sEyymm) - 5)
	ElseIf sGubun < '4' Then
		sEyymmadd   = String(Long(sEyymm) - Long(sGubun) + 1)
	ElseIf sGubun > '4' Then
		MessageBox("확 인","입력한 자료값이 잘못되었습니다.!!")
		this.Setcolumn('gubun')
		this.Setfocus()
		Return 1
	End IF
	
	If Long(Mid(sEyymmadd,5,2)) < 1 or Long(Mid(sEyymmadd,5,2)) > 12 Then
		f_messagechk(26,'【신고대상일자】')
		this.Setcolumn('gubun')
		this.Setfocus()
		Return 1
	Else	
		sEfromdate  = (sEyymmadd) + '01'
		sEtodate    = f_last_date(sEyymm)
	
	   this.SetItem(this.Getrow(),'efromdate',sEfromdate)
		this.SetItem(this.Getrow(),'etodate',sETodate)
		this.SetItem(this.Getrow(),'crtdate',sETodate)
	End If
END IF	
	
IF this.GetColumnName() = "eyymm" THEN
	sEyymm		= this.Gettext()
	sGubun 		= this.GetItemString(this.Getrow(),'gubun')
	
	If sGubun = '4' Then
		sEyymmadd  = String(Long(sEyymm) - 5)
	ElseIf sGubun < '4' Then
		sEyymmadd   = String(Long(sEyymm) - Long(sGubun) + 1)
	ElseIf sGubun > '4' Then
		MessageBox("확 인","입력한 자료값이 잘못되었습니다.!!")
		this.Setcolumn('gubun')
		this.Setfocus()
		Return 1
	End IF

	If Long(Mid(sEyymmadd,5,2)) < 1 or Long(Mid(sEyymmadd,5,2)) > 12 Then
		f_messagechk(26,'【신고대상일자】')
		this.Setcolumn('eyymm')
		this.Setfocus()
		Return 1
	Else	
		sEfromdate  = sEyymmadd + '01'
		sEtodate    = f_last_date(sEyymm)
	
	   this.SetItem(this.Getrow(),'efromdate',sEfromdate)
		this.SetItem(this.Getrow(),'etodate',sEtodate)
		this.SetItem(this.Getrow(),'crtdate',sEtodate)
	End If
END IF	

IF this.GetColumnName() = "crtdate" THEN
	sCrtdate		= this.Gettext()
	sGubun 		= this.GetItemString(this.Getrow(),'gubun')
	sEtodate	= this.GetItemString(this.Getrow(),'etodate')
	
	If sCrtdate <> sEtodate Then
		MessageBox("확 인","【신고대상종료일자】와 【작성일자】는 동일하여야 합니다.!!")
		this.Setcolumn('crtdate')
		this.Setfocus()
		Return 1
	End IF
END IF	

IF this.GetColumnName() = "procgbn" THEN
	sProcGbn = this.getText()
	IF sProcGbn = '2' THEN								/*개별*/
		this.SetItem(this.GetRow(),"jasacode",snull)
		this.SetItem(this.GetRow(),"sano",    snull)
		this.SetItem(this.GetRow(),"ownernm", snull)
		this.SetItem(this.GetRow(),"sangho",  snull)
		this.SetItem(this.GetRow(),"uptae",   snull)
		this.SetItem(this.GetRow(),"upjong",  snull)
		this.SetItem(this.GetRow(),"addr",    snull)
		this.SetItem(this.GetRow(),"filename",snull)
	ELSE
		SELECT "SYSCNFG"."DATANAME"  
	   	INTO :sCommJasa  
   	 	FROM "SYSCNFG"  
   		WHERE ( "SYSCNFG"."SYSGU" = 'C' ) AND ( "SYSCNFG"."SERIAL" = 4 ) AND  
         		( "SYSCNFG"."LINENO" = '1' )   ;
		IF SQLCA.SQLCODE <> 0 THEN
			F_MessageChk(56,'[자사코드(C-4-1)]')
			this.SetItem(this.GetRow(),"jasacode",    snull)
			this.SetItem(this.GetRow(),"sano",        snull)
			this.SetItem(this.GetRow(),"ownernm",     snull)
			this.SetItem(this.GetRow(),"sangho",      snull)
			this.SetItem(this.GetRow(),"uptae",       snull)
			this.SetItem(this.GetRow(),"upjong",      snull)
			this.SetItem(this.GetRow(),"addr",        snull)
			this.SetItem(this.GetRow(),"filename",    snull)
			Return 1
		ELSE
			IF IsNull(sCommJasa) OR sCommJasa = "" THEN
				F_MessageChk(56,'[자사코드(C-4-1)]')
				this.SetItem(this.GetRow(),"jasacode",    snull)
				this.SetItem(this.GetRow(),"sano",        snull)
				this.SetItem(this.GetRow(),"ownernm",     snull)
				this.SetItem(this.GetRow(),"sangho",      snull)
				this.SetItem(this.GetRow(),"uptae",       snull)
				this.SetItem(this.GetRow(),"upjong",      snull)
				this.SetItem(this.GetRow(),"addr",        snull)
				this.SetItem(this.GetRow(),"filename",    snull)
				Return 1
			END IF
		END IF		
		
	  	SELECT "VNDMST"."SANO" ,"VNDMST"."OWNAM","VNDMST"."CVNAS","VNDMST"."UPTAE",   
        	 "VNDMST"."JONGK","VNDMST"."ADDR1","VNDMST"."ADDR2"  
			INTO :sSano            ,:sOwnernm       ,:sSangho       ,:sUptae,   
				  :sUpjong          ,:sAddr1         ,:sAddr2
			FROM "VNDMST"  
			WHERE "VNDMST"."CVCOD" = :sCommJasa   ;
			
		IF IsNull(sAddr1) THEN
			sAddr1 =""
		END IF
		
		IF IsNull(sAddr2) THEN
			sAddr2 =""
		END IF
		this.SetItem(this.GetRow(),"jasacode",sCommJasa)
		this.SetItem(this.GetRow(),"sano",    sSano)
		this.SetItem(this.GetRow(),"ownernm", sOwnernm)
		this.SetItem(this.GetRow(),"sangho",  sSangho)
		this.SetItem(this.GetRow(),"uptae",   sUptae)
		this.SetItem(this.GetRow(),"upjong",  sUpjong)
		this.SetItem(this.GetRow(),"addr",    sAddr1+sAddr2)
		this.SetItem(this.GetRow(),"filename",sSano)
	END IF
END IF

IF this.GetColumnName() = "jasacode" THEN
	sJasa = this.GetText()
	IF sJasa = "" OR IsNull(sJasa) THEN
		this.SetItem(this.GetRow(),"sano",snull)
		this.SetItem(this.GetRow(),"ownernm", snull)
		this.SetItem(this.GetRow(),"sangho",snull)
		this.SetItem(this.GetRow(),"uptae", snull)
		this.SetItem(this.GetRow(),"upjong",snull)
		this.SetItem(this.GetRow(),"addr",  snull)
		this.SetItem(this.GetRow(),"filename", snull)
		Return
	END IF

  	SELECT "VNDMST"."SANO" ,"VNDMST"."OWNAM","VNDMST"."CVNAS","VNDMST"."UPTAE",   
        	 "VNDMST"."JONGK","VNDMST"."ADDR1","VNDMST"."ADDR2"  
   INTO :sSano            ,:sOwnernm       ,:sSangho       ,:sUptae,   
        :sUpjong          ,:sAddr1         ,:sAddr2
   FROM "VNDMST"  
  	WHERE "VNDMST"."CVCOD" = :sJasa   ;
	  
	IF sqlca.sqlcode <> 0 THEN
		this.SetItem(this.GetRow(),"sano",snull)
		this.SetItem(this.GetRow(),"ownernm", snull)
		this.SetItem(this.GetRow(),"sangho",snull)
		this.SetItem(this.GetRow(),"uptae", snull)
		this.SetItem(this.GetRow(),"upjong",snull)
		this.SetItem(this.GetRow(),"addr",  snull)
		this.SetItem(this.GetRow(),"filename", snull)
		Return
	END IF  
	  
	If Isnull(sAddr1) Then
		sAddr1 = ""
	End If
	If Isnull(sAddr2) Then
		sAddr2 = ""
	End IF
	
	this.SetItem(this.GetRow(),"sano",sSano)
	this.SetItem(this.GetRow(),"ownernm",sOwnernm)
	this.SetItem(this.GetRow(),"sangho",sSangho)
	this.SetItem(this.GetRow(),"uptae",sUptae)
	this.SetItem(this.GetRow(),"upjong",sUpjong)
	this.SetItem(this.GetRow(),"addr",sAddr1+sAddr2)
	this.SetItem(this.GetRow(),"filename",sSano)
	
END IF

IF this.GetColumnName() = "sano" THEN
	sSano 		= this.Gettext()
	
	If sSano = "" OR Isnull(sSano) then
		this.Setitem(this.Getrow(),'filename',snull)
	Else
		sFilename   = "A" + Left(sSano,7) + "." + Right(sSano,3)
		this.Setitem(this.Getrow(),'filename',sFilename)
	End If
END IF	

If this.Getcolumnname() = 'filename' Then
	sFilename = this.Gettext()
	sFilename = Mid(sFilename,2,7) + Right(sFilename,3)
	sSano     = this.Getitemstring(this.Getrow(),'sano')
	
	If sFilename <> sSano Then
		MessageBox("확 인","【사업자번호】와 【저장파일이름】이 같아야 합니다.!!")
		this.Setcolumn('filename')
		this.Setfocus()
		Return 1
	End If
End IF

end event

type tabpage_print1 from userobject within tab_suchul
integer x = 18
integer y = 96
integer width = 4489
integer height = 1928
long backcolor = 32106727
string text = "수출실적증명서(갑)"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_2 rr_2
dw_print dw_print
end type

on tabpage_print1.create
this.rr_2=create rr_2
this.dw_print=create dw_print
this.Control[]={this.rr_2,&
this.dw_print}
end on

on tabpage_print1.destroy
destroy(this.rr_2)
destroy(this.dw_print)
end on

type rr_2 from roundrectangle within tabpage_print1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 28
integer width = 4448
integer height = 1892
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_print from datawindow within tabpage_print1
integer x = 37
integer y = 40
integer width = 4421
integer height = 1860
integer taborder = 20
boolean bringtotop = true
string dataobject = "dw_ktxa206"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type tabpage_print2 from userobject within tab_suchul
integer x = 18
integer y = 96
integer width = 4489
integer height = 1928
long backcolor = 32106727
string text = "수출실적증명서(을)"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_3 rr_3
dw_print2 dw_print2
end type

on tabpage_print2.create
this.rr_3=create rr_3
this.dw_print2=create dw_print2
this.Control[]={this.rr_3,&
this.dw_print2}
end on

on tabpage_print2.destroy
destroy(this.rr_3)
destroy(this.dw_print2)
end on

type rr_3 from roundrectangle within tabpage_print2
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 24
integer width = 4448
integer height = 1900
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_print2 from datawindow within tabpage_print2
integer x = 37
integer y = 32
integer width = 4416
integer height = 1876
integer taborder = 20
boolean bringtotop = true
string dataobject = "dw_ktxa2061"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type tabpage_label from userobject within tab_suchul
integer x = 18
integer y = 96
integer width = 4489
integer height = 1928
long backcolor = 32106727
string text = "디스켓 표지"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_4 rr_4
dw_label dw_label
end type

on tabpage_label.create
this.rr_4=create rr_4
this.dw_label=create dw_label
this.Control[]={this.rr_4,&
this.dw_label}
end on

on tabpage_label.destroy
destroy(this.rr_4)
destroy(this.dw_label)
end on

type rr_4 from roundrectangle within tabpage_label
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 24
integer width = 4448
integer height = 1896
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_label from datawindow within tabpage_label
integer x = 32
integer y = 32
integer width = 4425
integer height = 1872
integer taborder = 20
boolean bringtotop = true
string dataobject = "dw_ktxa207"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type dw_file from datawindow within w_ktxa20
boolean visible = false
integer x = 1723
integer y = 2520
integer width = 571
integer height = 204
boolean bringtotop = true
boolean titlebar = true
string title = "파일저장"
string dataobject = "dw_ktxa205f"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

