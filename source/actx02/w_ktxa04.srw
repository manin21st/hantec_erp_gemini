$PBExportHeader$w_ktxa04.srw
$PBExportComments$세무계산서 조회 출력
forward
global type w_ktxa04 from w_standard_print
end type
type rr_1 from roundrectangle within w_ktxa04
end type
end forward

global type w_ktxa04 from w_standard_print
integer x = 0
integer y = 0
integer height = 2528
string title = "세무계산서 조회 출력"
rr_1 rr_1
end type
global w_ktxa04 w_ktxa04

type variables
String prt_gu

end variables

forward prototypes
public function string wf_last_date (string sdate)
public function double wf_misu_income (double misu_income, long ll_tot_cnt, long ll_cnt)
public function long wf_total_days (string sdate, string edate)
public subroutine wf_sengup_calc (string gijun_date, integer li_retrieve_row)
public subroutine wf_misusuik_calc (string gijun_date, integer li_retrieve_row)
public function long wf_day (string sdate, string edate)
public function integer wf_retrieve ()
end prototypes

public function string wf_last_date (string sdate);Int inc_val =31
Boolean cmp_val =False
Boolean bdate_chk
String save_date,ls_last_date

DO UNTIL cmp_val =true										// 마지막날
	save_date =Left(sdate,4) + "/" +Mid(sdate,5,2) + "/" + String(inc_val)
	bdate_chk =IsDate(save_date)
	IF bdate_chk =True THEN	
		return save_date
		cmp_val =true
	ELSE
		inc_val =inc_val - 1
		cmp_val =False
	END IF
LOOP
end function

public function double wf_misu_income (double misu_income, long ll_tot_cnt, long ll_cnt);Double ldb_amt,ldb_rtn_amt
Long ll_chong_cnt,ll_bulip_cnt

ldb_amt =misu_income

ll_chong_cnt =(ll_tot_cnt*(ll_tot_cnt+1))/2
ll_bulip_cnt =(ll_cnt*(ll_cnt - 1))/2
IF ll_chong_cnt = 0 THEN 
	ldb_rtn_amt = 0
ELSE
   ldb_rtn_amt =Truncate((ldb_amt * ll_bulip_cnt)/ll_chong_cnt,0)
END IF

return ldb_rtn_amt
end function

public function long wf_total_days (string sdate, string edate);//**** 시작일자와 만기일자를 인수로 받아 일수를 계산한다 ****//
// 1. 시작년도 = 만기년도 이면(만기년도 - 시작년도 = 0)
//    1-1. 시작월 부터 만기월 까지 loop
//        1-1-1. 마지막일자 구하기(년월)
//        1-1-2. 일수 계산하기
//               if '시작월' 이면 '시작일자와 1-1-1의 일자'로 일수 계산
//               elseif '만기월' 이면 '시작년도+ loop월'+'01'과 만기일자'로 일수 계산
//               else '만기월' 이면 '시작년도+ loop월'+'01'과 1-1-1의 일자'로 일수 계산
//                     일수 += 1
//               end if
//			 1-1-3. 최종일수 += 일수
//              
// 2. 시작년도 <> 만기년도 이면
//		2-1. 시작년월 부터 만기년월 까지 loop
//        2-1-1. 월이 '13'보다 크거나 같으면 '년도 + 1'+'01'
//        2-1-2. 마지막일자 구하기(2-1-1의 년월)
//        2-1-3. 일수 계산하기
//               if '시작월' 이면 '시작일자와 1-1-1의 일자'로 일수 계산
//               elseif '만기월' 이면 '시작년도+ loop월'+'01'과 만기일자'로 일수 계산
//               else   '시작년도+ loop월'+'01'과 1-1-1의 일자'로 일수 계산
//                      일수 += 1
//               end if
//			 2-1-4. 최종일수 += 일수
//*******************************************************************//

String ls_syear,ls_eyear,ls_smonth,ls_emonth,ls_last_date,ls_geysan_year,ls_geysan_month
String ls_geysan_sday,ls_geysan_eday,ls_gi_date,ls_man_date,ls_cmp_month
Int ll_loop_year,ll_loop_month,i,j,ll_smonth,ll_emonth,ll_cmp_month
Long ll_month_day,ll_total_day,ll_days_remain,ll_start_ym,ll_end_ym,r
Date chk,chk1

ls_gi_date =Left(sdate,4)+"/"+Mid(sdate,5,2)+"/"+Right(sdate,2)
ls_man_date =Left(edate,4)+"/"+Mid(edate,5,2)+"/"+Right(edate,2)

ls_syear =Left(sdate,4)
ls_smonth =Mid(sdate,5,2)

ls_eyear =Left(edate,4)
ls_emonth =Mid(edate,5,2)

ll_loop_year =Integer(ls_eyear) - Integer(ls_syear)

ls_geysan_sday =Right(sdate,2)							//DD일
ls_geysan_eday =Right(edate,2)

ls_geysan_year =ls_syear

IF ll_loop_year =0 THEN
	ll_smonth =Integer(ls_smonth)
	ll_emonth =Integer(ls_emonth)
	FOR r =ll_smonth TO ll_emonth
		ll_cmp_month =r
		IF ll_cmp_month < 10 THEN
			ls_geysan_month ="0"+String(ll_cmp_month)
		ELSE
			ls_geysan_month =String(ll_cmp_month)
		END IF	
		ls_last_date =wf_last_date(ls_geysan_year+ls_geysan_month)

		IF r =ll_smonth THEN
			ll_days_remain =DaysAfter(Date(ls_gi_date),Date(ls_last_date))
			ll_days_remain +=1
		ELSEIF r =ll_emonth THEN
			ll_days_remain =DaysAfter(Date(ls_geysan_year+"/"+ls_geysan_month+"/"+"01"),Date(ls_man_date))
			ll_days_remain +=1
		ELSE
			ll_days_remain =DaysAfter(Date(ls_geysan_year+"/"+ls_geysan_month+"/"+"01"),Date(ls_last_date))
			ll_days_remain +=1
		END IF
		ll_total_day +=ll_days_remain
	NEXT
ELSE
	ll_smonth =Integer(ls_smonth)
	ll_emonth =Integer(ls_emonth)

	ll_start_ym =Long(ls_syear+ls_smonth)
	ll_end_ym =Long(ls_eyear+ls_emonth)

	FOR r =ll_start_ym TO ll_end_ym								//MM월	
		ls_cmp_month =Right(String(r),2)
		ll_cmp_month =Integer(ls_cmp_month)

		IF ll_cmp_month < 10 THEN
			ls_geysan_month ="0"+String(ll_cmp_month)
		ELSEIF ll_cmp_month =13 THEN
			ll_cmp_month =1
			ls_geysan_year =String((Long(ls_geysan_year)+1))
			ls_geysan_month ="0"+String(ll_cmp_month)
			r =Long(ls_geysan_year+ls_geysan_month)
		ELSE
			ls_geysan_month =String(ll_cmp_month)
		END IF
		ls_last_date =wf_last_date(ls_geysan_year+ls_geysan_month)

		IF r =ll_start_ym THEN
			ll_days_remain =DaysAfter(Date(ls_gi_date),Date(ls_last_date))
			ll_days_remain +=1
		ELSEIF r =ll_end_ym THEN
			ll_days_remain =DaysAfter(Date(ls_geysan_year+"/"+ls_geysan_month+"/"+"01"),Date(ls_man_date))
			ll_days_remain +=1
		ELSE
			ll_days_remain =DaysAfter(Date(ls_geysan_year+"/"+ls_geysan_month+"/"+"01"),Date(ls_last_date))
			ll_days_remain +=1
		END IF
		ll_total_day +=ll_days_remain
	NEXT
END IF
return ll_total_day

end function

public subroutine wf_sengup_calc (string gijun_date, integer li_retrieve_row);Int i
Long ll_total_day,ll_day
String ls_gisan_date,ls_mangi_date
string chk
Double ldb_jun_amt,ldb_sengup_amt

sle_msg.text ="선급 비용을 계산 중입니다.!!!"

SetPointer(HourGlass!)

FOR i =1 TO li_retrieve_row
	ls_gisan_date =dw_list.GetItemString(i,"kfz12ot0_k_symd")
	ls_mangi_date =dw_list.GetItemString(i,"kfz12ot0_k_eymd")
	
	ldb_jun_amt =dw_list.GetItemNumber(i,"kfz12ot0_amt")
	ll_total_day = wf_total_days(ls_gisan_date,ls_mangi_date)
	IF ll_total_day =0 THEN
		ll_total_day =0
	ELSE
		dw_list.SetItem(i,"total_day",ll_total_day)
	END IF
	
//	ll_day =wf_day(ls_gisan_date,gijun_date)
	ll_day =wf_day(gijun_date,ls_mangi_date)
	IF ll_day =0 THEN
		ll_day =0
	ELSE
		dw_list.SetItem(i,"day",ll_day)
	END IF
	
	IF ll_total_day =0 OR ll_day =0 THEN
		ldb_sengup_amt =0
	ELSE
		ldb_sengup_amt =(ldb_jun_amt * ll_day)/ll_total_day
	END IF
	dw_list.SetItem(i,"tot_amt",ldb_sengup_amt)	
	dw_list.SetItem(i,"gey_ymd",gijun_date)
NEXT
SetPointer(Arrow!)
sle_msg.text ="선급 비용을 계산 완료했습니다.!!!"
end subroutine

public subroutine wf_misusuik_calc (string gijun_date, integer li_retrieve_row);Int i
Double ldb_gey_amt,ldb_month_amt,ldb_misu_income,ldb_bef_amt,ldb_dang_amt,ldb_income_amt
Long ll_total_nbr,ll_month_nbr,ll_cnt,ll_bulip_day,ll_add_month,ll_cha_year
Long ll_bef_day,ll_dang_day
String ls_syy,ls_gyy,ls_smm,ls_gmm,ls_gisan_date,ls_mangi_date

ls_gyy =Left(gijun_date,4)
ls_gmm =Mid(gijun_date,5,2)

sle_msg.text ="미수수익 계산서를 조회 중입니다.!!!"

SetPointer(HourGlass!)
FOR i =1 TO li_retrieve_row
	ls_gisan_date =dw_list.GetItemString(i,"ab_fst")								//계약일자
	ls_mangi_date =dw_list.GetItemString(i,"ab_tst")								//만기일자
	
	ldb_gey_amt =dw_list.GetItemNumber(i,"ab_tamt")									//계약금액
	ldb_month_amt =dw_list.GetItemNumber(i,"ab_mamt")								//월불입액
	
	ll_total_nbr =dw_list.GetItemNumber(i,"ab_tnbr")								//총불입횟수
	ll_bulip_day =dw_list.GetItemNumber(i,"ab_idat")								//불입일
	
	if isnull(ldb_gey_amt) then ldb_gey_amt = 0
	if isnull(ldb_month_amt) then ldb_month_amt = 0
	if isnull(ll_total_nbr) then ll_total_nbr = 0
	if isnull(ll_bulip_day) then ll_bulip_day = 0
	
	ldb_income_amt =ldb_gey_amt - (ldb_month_amt * ll_total_nbr)				//총이자
	
	ls_syy =Left(ls_gisan_date,4)
	ls_smm =Mid(ls_gisan_date,5,2)
//*************************************************************************************//
// *불입횟수는																									//
//  **기준년도와 계약년도가 같으면																		//
//		**기준일자 > 불입일이면  불입횟수 =(기준년도의 월 - 계약년도의 월)+1             //		
//		**기준일자 < 불입일이면  불입횟수 =(기준년도의 월 - 계약년도의 월)		         //
//  **기준년도와 계약년도가 다르면																		//
//    **차이가 1이고 기준일자 > 불입일이면 불입회수 =((12-계약월)+1) + 기준월				//
//    **차이가 1이고 기준일자 < 불입일이면 불입회수 =((12-계약월)+1) + (기준월 - 1)    //
//  	**차이가 1이상이면																					//
//		  차이가 1인 처리에 '(차이 - 1) * 12'를 더해준다.						    				//
//*************************************************************************************//

	ll_cha_year =Long(ls_gyy) - Long(ls_syy)
	IF ll_cha_year =1 THEN
		IF Long(Right(gijun_date,2)) >= ll_bulip_day THEN
			ll_month_nbr =((12 - Long(ls_smm))+1) + Long(ls_gmm)
		ELSE
			ll_month_nbr =((12 - Long(ls_smm))+1) + (Long(ls_gmm) - 1)
		END IF
		ll_bef_day =(12 - Long(ls_smm))+1
		ldb_bef_amt =wf_misu_income(ldb_income_amt,ll_total_nbr,ll_bef_day)
		ldb_dang_amt =wf_misu_income(ldb_income_amt,ll_total_nbr,ll_month_nbr)
		ldb_dang_amt =ldb_dang_amt - ldb_bef_amt
	ELSEIF ll_cha_year =0 THEN
		IF Long(Right(gijun_date,2)) >= ll_bulip_day THEN
			ll_month_nbr =(Long(ls_gmm) - Long(ls_smm)) + 1
		ELSE
			ll_month_nbr =Long(ls_gmm) - Long(ls_smm)
		END IF
		ldb_bef_amt =0
		ldb_dang_amt =wf_misu_income(ldb_income_amt,ll_total_nbr,ll_month_nbr)	
		ldb_dang_amt =ldb_dang_amt - ldb_bef_amt	
	ELSE
		ll_add_month =(ll_cha_year - 1) * 12
		IF Long(Right(gijun_date,2)) >= ll_bulip_day THEN
			ll_month_nbr =((12 - Long(ls_smm))+1) + Long(ls_gmm) + ll_add_month
		ELSE
			ll_month_nbr =((12 - Long(ls_smm))+1) + (Long(ls_gmm) - 1) + ll_add_month
		END IF
		
		ll_bef_day =((12 - Long(ls_smm))+1) + ll_add_month
		ldb_bef_amt =wf_misu_income(ldb_income_amt,ll_total_nbr,ll_bef_day)
		ldb_dang_amt =wf_misu_income(ldb_income_amt,ll_total_nbr,ll_month_nbr)
		ldb_dang_amt =ldb_dang_amt - ldb_bef_amt
	END IF
	ldb_misu_income =ldb_income_amt - (ldb_bef_amt +ldb_dang_amt)
	
	ldb_misu_income =Truncate(ldb_misu_income,0)

	dw_list.SetItem(i,"total_com",Truncate(ldb_income_amt,0))
	dw_list.SetItem(i,"total_misu_amt",ldb_misu_income)
	dw_list.SetItem(i,"ab_mnbr",ll_month_nbr)
	dw_list.SetItem(i,"bef_amt",ldb_bef_amt)
	dw_list.SetItem(i,"dang_amt",ldb_dang_amt)
	dw_list.SetItem(i,"gey_ymd",gijun_date)
NEXT
SetPointer(Arrow!)
sle_msg.text ="미수수익 계산을 완료했습니다.!!!"
end subroutine

public function long wf_day (string sdate, string edate);//**** 시작일자와 기준일자를 인수로 받아 일수를 계산한다 ****//
// 1. 시작년도 = 기준년도 이면(기준년도 - 시작년도 = 0)
//    1-1. 시작월 부터 기준월 까지 loop
//        1-1-1. 마지막일자 구하기(년월)
//        1-1-2. 일수 계산하기
//               if '시작월' 이면 '시작일자와 1-1-1의 일자'로 일수 계산
//               elseif '기준월' 이면 '시작년도+ loop월'+'01'과 기준일자'로 일수 계산
//               else '기준월' 이면 '시작년도+ loop월'+'01'과 1-1-1의 일자'로 일수 계산
//                     일수 += 1
//               end if
//			 1-1-3. 최종일수 += 일수
//              
// 2. 시작년도 <> 기준년도 이면
//		2-1. 시작년월 부터 기준년월 까지 loop
//        2-1-1. 월이 '13'보다 크거나 같으면 '년도 + 1'+'01'
//        2-1-2. 마지막일자 구하기(2-1-1의 년월)
//        2-1-3. 일수 계산하기
//               if '시작월' 이면 '시작일자와 1-1-1의 일자'로 일수 계산
//               elseif '기준월' 이면 '시작년도+ loop월'+'01'과 기준일자'로 일수 계산
//               else   '시작년도+ loop월'+'01'과 1-1-1의 일자'로 일수 계산
//                      일수 += 1
//               end if
//			 2-1-4. 최종일수 += 일수
//*******************************************************************//

String ls_syear,ls_eyear,ls_smonth,ls_emonth,ls_last_date,ls_geysan_year,ls_geysan_month
String ls_geysan_sday,ls_geysan_eday,ls_gisan_date2,ls_gijun_date,ls_cmp_month
Int ll_loop_year,ll_loop_month,i,j,ll_smonth,ll_emonth,ll_cmp_month
Long ll_month_day,ll_total_day,ll_days_remain,ll_start_ym,ll_end_ym,r
Date chk,chk1

ls_gisan_date2 =Left(sdate,4)+"/"+Mid(sdate,5,2)+"/"+Right(sdate,2)    //계약일자/시작일자
ls_gijun_date =Left(edate,4)+"/"+Mid(edate,5,2)+"/"+Right(edate,2)	 //계산일자/기준일자

ls_syear =Left(sdate,4)
ls_smonth =Mid(sdate,5,2)

ls_eyear =Left(edate,4)
ls_emonth =Mid(edate,5,2)

ll_loop_year =Integer(ls_eyear) - Integer(ls_syear)

ls_geysan_sday =Right(sdate,2)							//DD일
ls_geysan_eday =Right(edate,2)

ls_geysan_year =ls_syear

IF ll_loop_year =0 THEN
	ll_smonth =Integer(ls_smonth)
	ll_emonth =Integer(ls_emonth)
	FOR r =ll_smonth TO ll_emonth
		ll_cmp_month =r
		IF ll_cmp_month < 10 THEN
			ls_geysan_month ="0"+String(ll_cmp_month)
		ELSE
			ls_geysan_month =String(ll_cmp_month)
		END IF	
		ls_last_date =wf_last_date(ls_geysan_year+ls_geysan_month)

		IF r =ll_smonth THEN
			ll_days_remain =DaysAfter(Date(ls_gisan_date2),Date(ls_last_date))
			ll_days_remain +=1
		ELSEIF r =ll_emonth THEN
			ll_days_remain =DaysAfter(Date(ls_geysan_year+"/"+ls_geysan_month+"/"+"01"),Date(ls_gijun_date))
			ll_days_remain +=1
		ELSE
			ll_days_remain =DaysAfter(Date(ls_geysan_year+"/"+ls_geysan_month+"/"+"01"),Date(ls_last_date))
			ll_days_remain +=1
		END IF
		ll_total_day +=ll_days_remain
	NEXT
ELSE
	ll_smonth =Integer(ls_smonth)
	ll_emonth =Integer(ls_emonth)

	ll_start_ym =Long(ls_syear+ls_smonth)
	ll_end_ym =Long(ls_eyear+ls_emonth)

	FOR r =ll_start_ym TO ll_end_ym								//MM월	
		ls_cmp_month =Right(String(r),2)
		ll_cmp_month =Integer(ls_cmp_month)

		IF ll_cmp_month < 10 THEN
			ls_geysan_month ="0"+String(ll_cmp_month)
		ELSEIF ll_cmp_month =13 THEN
			ll_cmp_month =1
			ls_geysan_year =String((Long(ls_geysan_year)+1))
			ls_geysan_month ="0"+String(ll_cmp_month)
			r =Long(ls_geysan_year+ls_geysan_month)
		ELSE
			ls_geysan_month =String(ll_cmp_month)
		END IF
		ls_last_date =wf_last_date(ls_geysan_year+ls_geysan_month)

		IF r =ll_start_ym THEN
			ll_days_remain =DaysAfter(Date(ls_gisan_date2),Date(ls_last_date))
			ll_days_remain +=1
		ELSEIF r =ll_end_ym THEN
			ll_days_remain =DaysAfter(Date(ls_geysan_year+"/"+ls_geysan_month+"/"+"01"),Date(ls_gijun_date))
			ll_days_remain +=1
		ELSE
			ll_days_remain =DaysAfter(Date(ls_geysan_year+"/"+ls_geysan_month+"/"+"01"),Date(ls_last_date))
			ll_days_remain +=1
		END IF
		ll_total_day +=ll_days_remain
	NEXT
END IF
return ll_total_day

end function

public function integer wf_retrieve ();//************************************************************************************//
String  sdate
Int     il_rowCount, i
		  
dw_ip.AcceptText()

sle_msg.text =""

sdate  = dw_ip.GetItemString(1,"sdate")
IF sDate = "" OR IsNull(sDate) THEN
	F_MessageChk(1,'[기준일자]')
	dw_ip.SetColumn("sdate")
	dw_ip.SetFocus()
	Return -1
END IF

IF IsDate(Left(sdate,4)+"/"+Mid(sdate,5,2)+"/"+Right(sdate,2)) THEN
ELSE
	f_MessageChk(21,"")
   RETURN  -1
END IF

CHOOSE CASE prt_gu
	CASE "sengup_geysanse"
		IF dw_print.Retrieve(sabu_f,sabu_t,sdate,sabu_nm) <=0 THEN
			f_MessageChk(14,"")
			//Return -1
			dw_list.insertrow(0)
		END IF
		wf_sengup_calc(sdate,dw_list.RowCount())
		
	CASE "misu_geysanse"
		IF dw_print.Retrieve(sabu_f,sabu_t,sdate,sabu_nm) <=0 THEN
			f_MessageChk(14,"")
			//Return -1
			dw_list.insertrow(0)
	   END IF
		wf_misusuik_calc(sdate,dw_list.RowCount())
	CASE "miji_geysanse"
		IF dw_print.Retrieve(sabu_f,sabu_t,sdate,sabu_nm) <=0 THEN
			f_MessageChk(14,"")
			//Return -1
			dw_list.insertrow(0)
		END IF
END CHOOSE
dw_print.sharedata(dw_list)
Return 1
end function

on w_ktxa04.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_ktxa04.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetItem(dw_ip.Getrow(),"saupj",gs_saupj)
dw_ip.SetItem(dw_ip.Getrow(),"sdate",String(today(),"yyyymm01"))
dw_ip.SetItem(dw_ip.Getrow(),"edate",String(today(),"yyyymmdd"))
dw_ip.SetItem(dw_ip.Getrow(),"sselect_gu",'1')
dw_ip.SetFocus()

dw_ip.Modify("saupj.protect = 0")
dw_ip.Modify("saupj.background.color ='"+String(RGB(255,255,255))+"'")


prt_gu ="sengup_geysanse"


end event

type p_xls from w_standard_print`p_xls within w_ktxa04
end type

type p_sort from w_standard_print`p_sort within w_ktxa04
end type

type p_preview from w_standard_print`p_preview within w_ktxa04
integer x = 4087
integer y = 16
integer taborder = 30
string pointer = ""
end type

type p_exit from w_standard_print`p_exit within w_ktxa04
integer x = 4434
integer y = 16
integer taborder = 50
string pointer = ""
end type

type p_print from w_standard_print`p_print within w_ktxa04
integer x = 4261
integer y = 16
integer taborder = 40
string pointer = ""
end type

type p_retrieve from w_standard_print`p_retrieve within w_ktxa04
integer x = 3913
integer y = 16
string pointer = ""
end type

type st_window from w_standard_print`st_window within w_ktxa04
integer x = 2359
integer width = 462
end type

type sle_msg from w_standard_print`sle_msg within w_ktxa04
integer x = 384
end type

type dw_datetime from w_standard_print`dw_datetime within w_ktxa04
integer x = 2821
end type

type st_10 from w_standard_print`st_10 within w_ktxa04
integer x = 23
end type

type gb_10 from w_standard_print`gb_10 within w_ktxa04
integer x = 5
end type

type dw_print from w_standard_print`dw_print within w_ktxa04
string dataobject = "dw_ktxa042_p"
end type

type dw_ip from w_standard_print`dw_ip within w_ktxa04
integer y = 24
integer width = 3433
integer height = 164
string dataobject = "dw_ktxa041"
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
			dw_print.DataObject ="dw_ktxa042_p"
			dw_print.SetTransObject(SQLCA)
			dw_print.Reset()

		CASE '2'
			prt_gu ="misu_geysanse"

			dw_list.title ="미수수익 계산서"
			dw_list.DataObject ="dw_ktxa043"
			dw_list.SetTransObject(SQLCA)
			dw_list.Reset()
			dw_print.DataObject ="dw_ktxa043_p"
			dw_print.SetTransObject(SQLCA)
			dw_print.Reset()
			
		CASE '3'
			prt_gu ="miji_geysanse"

			dw_list.title ="미지급비용 계산서"
			dw_list.DataObject ="dw_ktxa044"
			dw_list.SetTransObject(SQLCA)
			dw_list.Reset()
			dw_print.DataObject ="dw_ktxa044_p"
			dw_print.SetTransObject(SQLCA)
			dw_print.Reset()
	
	END CHOOSE
	sle_msg.text =""
END IF

end event

type dw_list from w_standard_print`dw_list within w_ktxa04
integer x = 69
integer y = 204
integer width = 4521
integer height = 2092
string title = "선급비용 계산서"
string dataobject = "dw_ktxa042"
boolean hscrollbar = false
boolean border = false
boolean hsplitscroll = false
end type

type rr_1 from roundrectangle within w_ktxa04
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 192
integer width = 4562
integer height = 2120
integer cornerheight = 40
integer cornerwidth = 55
end type

