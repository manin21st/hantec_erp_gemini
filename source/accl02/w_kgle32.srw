$PBExportHeader$w_kgle32.srw
$PBExportComments$미수수익계산서
forward
global type w_kgle32 from w_standard_print
end type
type rr_1 from roundrectangle within w_kgle32
end type
end forward

global type w_kgle32 from w_standard_print
integer x = 0
integer y = 0
string title = "미수수익 계산서 조회 출력"
rr_1 rr_1
end type
global w_kgle32 w_kgle32

type variables
String prt_gu

end variables

forward prototypes
public subroutine wf_misusuik_calc (string gijun_date, integer li_retrieve_row)
public function integer wf_retrieve ()
public function double wf_misu_income (double misu_income, long ll_tot_cnt, long ll_cnt)
private subroutine wf_suik_calc (string gijun_date, integer li_retrieve_row)
end prototypes

public subroutine wf_misusuik_calc (string gijun_date, integer li_retrieve_row);//Int i
//Double ldb_gey_amt,ldb_month_amt,ldb_misu_income,ldb_bef_amt,ldb_dang_amt,ldb_income_amt
//Long ll_total_nbr,ll_month_nbr,ll_cnt,ll_bulip_day,ll_add_month,ll_cha_year
//Long ll_bef_day,ll_dang_day
//String ls_syy,ls_gyy,ls_smm,ls_gmm,ls_gisan_date,ls_mangi_date
//
//ls_gyy =Left(gijun_date,4)
//ls_gmm =Mid(gijun_date,5,2)
//
//sle_msg.text ="미수수익 계산서를 조회 중입니다.!!!"
//
//SetPointer(HourGlass!)
//FOR i =1 TO li_retrieve_row
//	ls_gisan_date =dw_list.GetItemString(i,"ab_fst")								//계약일자
//	ls_mangi_date =dw_list.GetItemString(i,"ab_tst")								//만기일자
//	
//	ldb_gey_amt =dw_list.GetItemNumber(i,"ab_tamt")									//계약금액
//	ldb_month_amt =dw_list.GetItemNumber(i,"ab_mamt")								//월불입액
//	
//	ll_total_nbr =dw_list.GetItemNumber(i,"ab_tnbr")								//총불입횟수
//	ll_bulip_day =dw_list.GetItemNumber(i,"ab_idat")								//불입일
//	
//	ldb_bef_amt = dw_list.GetItemNumber(i,"bef_amt")								/*전기 계상액*/
//	
//	if isnull(ldb_gey_amt) then ldb_gey_amt = 0
//	if isnull(ldb_month_amt) then ldb_month_amt = 0
//	if isnull(ll_total_nbr) then  ll_total_nbr = 0
//	if isnull(ll_bulip_day) then  ll_bulip_day = 0
//	if isnull(ldb_bef_amt) then   ldb_bef_amt = 0
//	
//	ldb_income_amt =ldb_gey_amt - (ldb_month_amt * ll_total_nbr)				//총이자
//	
//	ls_syy =Left(ls_gisan_date,4)
//	ls_smm =Mid(ls_gisan_date,5,2)
////*************************************************************************************//
//// *불입횟수는																									//
////  **기준년도와 계약년도가 같으면																		//
////		**기준일자 > 불입일이면  불입횟수 =(기준년도의 월 - 계약년도의 월)+1             //		
////		**기준일자 < 불입일이면  불입횟수 =(기준년도의 월 - 계약년도의 월)		         //
////  **기준년도와 계약년도가 다르면																		//
////    **차이가 1이고 기준일자 > 불입일이면 불입회수 =((12-계약월)+1) + 기준월				//
////    **차이가 1이고 기준일자 < 불입일이면 불입회수 =((12-계약월)+1) + (기준월 - 1)    //
////  	**차이가 1이상이면																					//
////		  차이가 1인 처리에 '(차이 - 1) * 12'를 더해준다.						    				//
////*************************************************************************************//
//
//	ll_cha_year =Long(ls_gyy) - Long(ls_syy)
//	IF ll_cha_year =1 THEN
//		IF Long(Right(gijun_date,2)) >= ll_bulip_day THEN
//			ll_month_nbr =((12 - Long(ls_smm))+1) + Long(ls_gmm)
//		ELSE
//			ll_month_nbr =((12 - Long(ls_smm))+1) + (Long(ls_gmm) - 1)
//		END IF
//		ll_bef_day =(12 - Long(ls_smm))+1
//		ldb_dang_amt =wf_misu_income(ldb_income_amt,ll_total_nbr,ll_month_nbr)
//		ldb_dang_amt =ldb_dang_amt - ldb_bef_amt
//	ELSEIF ll_cha_year =0 THEN
//		IF Long(Right(gijun_date,2)) >= ll_bulip_day THEN
//			ll_month_nbr =(Long(ls_gmm) - Long(ls_smm)) + 1
//		ELSE
//			ll_month_nbr =Long(ls_gmm) - Long(ls_smm)
//		END IF
//		ldb_dang_amt =wf_misu_income(ldb_income_amt,ll_total_nbr,ll_month_nbr)	
//		ldb_dang_amt =ldb_dang_amt - ldb_bef_amt	
//	ELSE
//		ll_add_month =(ll_cha_year - 1) * 12
//		IF Long(Right(gijun_date,2)) >= ll_bulip_day THEN
//			ll_month_nbr =((12 - Long(ls_smm))+1) + Long(ls_gmm) + ll_add_month
//		ELSE
//			ll_month_nbr =((12 - Long(ls_smm))+1) + (Long(ls_gmm) - 1) + ll_add_month
//		END IF
//		
//		ll_bef_day =((12 - Long(ls_smm))+1) + ll_add_month
//		
//		ldb_dang_amt =wf_misu_income(ldb_income_amt,ll_total_nbr,ll_month_nbr)
//		ldb_dang_amt =ldb_dang_amt - ldb_bef_amt
//	END IF
//	ldb_misu_income =ldb_income_amt - (ldb_bef_amt +ldb_dang_amt)
//	
//	ldb_misu_income =Truncate(ldb_misu_income,0)
//
//	dw_list.SetItem(i,"total_com",Truncate(ldb_income_amt,0))
//	dw_list.SetItem(i,"total_misu_amt",ldb_misu_income)
////	dw_list.SetItem(i,"ab_mnbr",ll_month_nbr)
//	dw_list.SetItem(i,"dang_amt",ldb_dang_amt)
//	dw_list.SetItem(i,"gey_ymd",gijun_date)
//NEXT
//SetPointer(Arrow!)
//sle_msg.text ="미수수익 계산을 완료했습니다.!!!"
end subroutine

public function integer wf_retrieve ();String  sSaupj,sBaseDate
		  
dw_ip.AcceptText()

sle_msg.text =""

sSaupj     = dw_ip.GetItemString(1,"saupj")
sBaseDate  = Trim(dw_ip.GetItemString(1,"symd"))

IF sSaupj = "" OR IsNull(sSaupj) THEN
	F_MessageChk(1,'[사업장]')
	dw_ip.SetColumn("saupj")
	dw_ip.SetFocus()
	Return -1
END IF

IF sSaupj = "99" THEN sSaupj = '%'

IF sBaseDate = "" OR IsNull(sBaseDate) THEN
	F_MessageChk(1,'[기준일자]')
	dw_ip.SetColumn("symd")
	dw_ip.SetFocus()
	Return -1
END IF

dw_list.SetFilter("")
dw_list.Filter()
IF dw_print.Retrieve(sSaupj,sBaseDate) <=0 THEN
	f_MessageChk(14,"")
	Return -1
END IF

wf_suik_calc(sBaseDate,dw_list.RowCount())

//dw_list.SetFilter("bef_amt <> 0 or dang_amt <> 0")
//dw_list.Filter()

dw_print.ShareData(dw_list)

Return 1
end function

public function double wf_misu_income (double misu_income, long ll_tot_cnt, long ll_cnt);Double ldb_amt,ldb_rtn_amt
//Long ll_chong_cnt,ll_bulip_cnt
//
//ldb_amt =misu_income
//
//ll_chong_cnt =(ll_tot_cnt*(ll_tot_cnt+1))/2
//ll_bulip_cnt =(ll_cnt*(ll_cnt - 1))/2
//IF ll_chong_cnt = 0 THEN 
//	ldb_rtn_amt = 0
//ELSE
//   ldb_rtn_amt =Truncate((ldb_amt * ll_bulip_cnt)/ll_chong_cnt,0)
//END IF
//
return ldb_rtn_amt
end function

private subroutine wf_suik_calc (string gijun_date, integer li_retrieve_row);Int      i,iMonthCnt,iTotalCnt,iBulipDay, dDays,  dDaysi
Double   dAbTAmt,dMonthAmt,dBefAmt,dDangAmt,dTotalInCome, dAb_rat, dTotalInCome2
String   sFromDate,sToDate, sAb_jgbn, sAb_fst , sAb_tst

sle_msg.text ="미수수익 계산서를 조회 중입니다.!!!"

SetPointer(HourGlass!)
FOR i =1 TO li_retrieve_row
	sFromDate = dw_list.GetItemString(i,"ab_fst")								/*계약일자*/
	sToDate   = dw_list.GetItemString(i,"ab_tst")								/*만기일자*/

	dAbTAmt   = dw_list.GetItemNumber(i,"ab_tamt")									/*계약금액*/
	dMonthAmt = dw_list.GetItemNumber(i,"ab_mamt")									/*월불입액*/

	iTotalCnt = dw_list.GetItemNumber(i,"ab_tnbr")									/*총불입횟수*/
	iMonthCnt = dw_list.GetItemNumber(i,"bulipcnt")									/*불입횟수*/
	iBulipDay = dw_list.GetItemNumber(i,"ab_idat")									/*불입일*/
	
	dBefAmt   = dw_list.GetItemNumber(i,"bef_amt")									/*전기 계상액*/
	 sAb_jgbn = dw_list.GetItemString(i,"b_ab_jgbn")									/* 3적금, 4예금*/
	 sAb_fst = dw_list.GetItemString(i,"ab_fst")									/*계약일*/
  	 sAb_tst = dw_list.GetItemString(i,"ab_tst")									/* 종료일*/
  	 dAb_rat = dw_list.GetItemdecimal(i,"kfm04ot0_ab_rat")									/* 이율 */		
	
	
	if isnull(dAbTAmt) then dAbTAmt = 0
	if isnull(dMonthAmt) then dMonthAmt = 0
	if isnull(iTotalCnt) then  iTotalCnt = 0
	if isnull(iMonthCnt) then  iMonthCnt = 0
	if isnull(iBulipDay) then  iBulipDay = 0
	if isnull(dBefAmt) then   dBefAmt = 0
	
//	 Mid(sAb_tst,1,4) + '/' + Mid(sAb_tst,5,2) + '/' + Mid(sAb_tst,7,2)
	dDays = DaysAfter(date(Mid(sAb_fst,1,4) + '/' + Mid(sAb_fst,5,2) + '/' + Mid(sAb_fst,7,2)), date(Mid(sAb_tst,1,4) + '/' + Mid(sAb_tst,5,2) + '/' + Mid(sAb_tst,7,2)) )
	dDaysi = DaysAfter(date(Mid(sAb_fst,1,4) + '/' + Mid(sAb_fst,5,2) + '/' + Mid(sAb_fst,7,2)), date(Mid(gijun_date,1,4) + '/' + Mid(gijun_date,5,2) + '/' + Mid(gijun_date,7,2)) )
	
	if  sAb_jgbn = '3'  then  //적금시
	    dTotalInCome = dAbTAmt - (dMonthAmt * iTotalCnt)									/*총이자*/
	else  //예금시
		 dTotalInCome = Round(   dAbTAmt *  dDays  / 365 * dAb_rat / 100 , 0)  //총이자
	     dTotalInCome2 = Round(   dAbTAmt *  dDaysi  / 365 * dAb_rat / 100 , 0)   //기준일까지 누계
	end if
	
	if sFromDate > gijun_date then
		dDangAmt =  0	
	else
		if   sAb_jgbn = '3'  then  //적금시
		  if itotalcnt = 0 then
			dDangAmt = Truncate(dTotalInCome * (iMonthCnt * (iMonthCnt - 1)),0) - dBefAmt		/*당기계상액*/
		  else
			dDangAmt = Truncate(dTotalInCome * ((iMonthCnt * (iMonthCnt + 1)) / (iTotalCnt * (iTotalCnt + 1))),0) - dBefAmt		/*당기계상액*/
		  end if
		  else	  
				dDangAmt = dTotalInCome2  - dBefAmt		/*당기계상액*/
		  end  if
	end if
	
	dw_list.SetItem(i,"total_com",     Truncate(dTotalInCome,0))
	dw_list.SetItem(i,"dang_amt",      dDangAmt)
	dw_list.SetItem(i,"gey_ymd",       gijun_date)
NEXT
SetPointer(Arrow!)
sle_msg.text ="미수수익 계산을 완료했습니다.!!!"
end subroutine

on w_kgle32.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kgle32.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetItem(dw_ip.Getrow(),"saupj",    gs_saupj)
dw_ip.SetItem(dw_ip.Getrow(),"symd",     f_today())
dw_ip.SetFocus()

dw_ip.Modify("saupj.protect = 0")
//dw_ip.Modify("saupj.background.color ='"+String(RGB(255,255,255))+"'")

prt_gu ="sengup_geysanse"


end event

type p_xls from w_standard_print`p_xls within w_kgle32
end type

type p_sort from w_standard_print`p_sort within w_kgle32
end type

type p_preview from w_standard_print`p_preview within w_kgle32
integer x = 4073
integer y = 0
end type

type p_exit from w_standard_print`p_exit within w_kgle32
integer x = 4421
integer y = 0
end type

type p_print from w_standard_print`p_print within w_kgle32
integer x = 4247
integer y = 0
end type

type p_retrieve from w_standard_print`p_retrieve within w_kgle32
integer x = 3899
integer y = 0
end type

type st_window from w_standard_print`st_window within w_kgle32
integer x = 2391
end type

type sle_msg from w_standard_print`sle_msg within w_kgle32
integer x = 384
integer width = 2007
end type

type dw_datetime from w_standard_print`dw_datetime within w_kgle32
integer x = 2848
end type

type st_10 from w_standard_print`st_10 within w_kgle32
integer x = 23
end type

type gb_10 from w_standard_print`gb_10 within w_kgle32
integer x = 5
integer width = 3607
end type

type dw_print from w_standard_print`dw_print within w_kgle32
string dataobject = "d_kgle322_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kgle32
integer width = 1975
integer height = 148
string dataobject = "d_kgle321"
end type

event dw_ip::itemchanged;
IF dwo.name = "sselect_gu" THEN
	CHOOSE CASE data
		CASE '1'
			prt_gu ="sengup_geysanse"

			dw_list.title ="선급비용 계산서"
			dw_list.DataObject ="dw_ktxa042"
			dw_list.SetTransObject(SQLCA)
			dw_list.Reset()

		CASE '2'
			prt_gu ="misu_geysanse"

			dw_list.title ="미수수익 계산서"
			dw_list.DataObject ="dw_ktxa043"
			dw_list.SetTransObject(SQLCA)
			dw_list.Reset()
			
		CASE '3'
			prt_gu ="miji_geysanse"

			dw_list.title ="미지급비용 계산서"
			dw_list.DataObject ="dw_ktxa044"
			dw_list.SetTransObject(SQLCA)
			dw_list.Reset()
	
	END CHOOSE
	sle_msg.text =""
END IF

end event

type dw_list from w_standard_print`dw_list within w_kgle32
integer x = 55
integer y = 176
integer width = 4535
integer height = 2032
string title = "미수수익 계산서"
string dataobject = "d_kgle322"
boolean border = false
end type

type rr_1 from roundrectangle within w_kgle32
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 168
integer width = 4567
integer height = 2052
integer cornerheight = 40
integer cornerwidth = 55
end type

