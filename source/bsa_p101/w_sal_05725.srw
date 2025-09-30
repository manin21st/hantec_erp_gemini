$PBExportHeader$w_sal_05725.srw
$PBExportComments$제품별 지역별 판매순위 현황
forward
global type w_sal_05725 from w_standard_print
end type
type tab_1 from tab within w_sal_05725
end type
type tabpage_1 from userobject within tab_1
end type
type dw_list_tab1 from datawindow within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_list_tab1 dw_list_tab1
end type
type tabpage_2 from userobject within tab_1
end type
type dw_list_tab2 from datawindow within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_list_tab2 dw_list_tab2
end type
type tabpage_4 from userobject within tab_1
end type
type dw_list_tab4 from datawindow within tabpage_4
end type
type tabpage_4 from userobject within tab_1
dw_list_tab4 dw_list_tab4
end type
type tabpage_3 from userobject within tab_1
end type
type dw_list_tab3 from datawindow within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_list_tab3 dw_list_tab3
end type
type tab_1 from tab within w_sal_05725
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_4 tabpage_4
tabpage_3 tabpage_3
end type
type rb_1 from radiobutton within w_sal_05725
end type
type rb_2 from radiobutton within w_sal_05725
end type
end forward

global type w_sal_05725 from w_standard_print
string title = "제품별 지역별 판매순위 현황"
tab_1 tab_1
rb_1 rb_1
rb_2 rb_2
end type
global w_sal_05725 w_sal_05725

type variables
datawindow dw_select
str_itnct lstr_sitnct
end variables

forward prototypes
public function string wf_set_sqlsyntax (string itclsgu, string areagu, string arg_steamcd, string arg_sarea, string arg_scust, string arg_sdatef, string arg_sdatet, string arg_pdtgu, string arg_silgu)
public function integer wf_retrieve ()
end prototypes

public function string wf_set_sqlsyntax (string itclsgu, string areagu, string arg_steamcd, string arg_sarea, string arg_scust, string arg_sdatef, string arg_sdatet, string arg_pdtgu, string arg_silgu);String sModString

if rb_2.checked = true then
/* sql 작성 */
Choose Case itclsgu
	/* 대분류 일경우 */
	Case '1'
		Choose Case areagu
			/* 영업팀 */
			Case '1' 
				sModString =	"select 0 as rank,	" + &
									"		 y.ittyp as ittyp ,	" + &
									"		 substr(y.itcls,1,2) as itcls,	" + &
									"		 w.titnm as itdsc,	" + &
									"		 t.steamnm as cvcod,	" + &
									"		 sum(x.sales_qty) as qty,	" + &
									"		 sum(x.sales_amt) as amt	" + &
									"  from salesum x, itemas y,itnct w, vndmst v, sarea a, steam t " + &
									" where x.sabu = y.sabu and	" + &
									"		 x.itnbr = y.itnbr and	" + &
									"		 y.ittyp = w.ittyp and	" + &
									"		 substr(y.itcls,1,2) = w.itcls and	" + &
									"      w.lmsgu = 'L' and " + &
									"		 x.cvcod = v.cvcod and	" + &
									"		 v.sarea = a.sarea and	" + &
									"		 a.steamcd = t.steamcd and	" + &
									"		 x.sabu = '" + gs_sabu + "' and	" + &
									"		 x.silgu = '" + arg_silgu + "' and	" + &
									"		 x.sales_yymm >= '" + arg_sdatef + "' and	" + &
									"		 x.sales_yymm <= '" + arg_sdatet + "' and	" + &
									"		 a.steamcd like '" + arg_steamcd + "' and	" + &
									"		 v.sarea like '" + arg_sarea + "' and	" + &
									"		 x.cvcod like '" + arg_scust + "' and	" + &
									"		 w.pdtgu like '" + arg_pdtgu + "'	" + &
									" group by y.ittyp,substr(y.itcls,1,2), w.titnm, t.steamnm	" + &
									" having y.ittyp <> '9' and	" + &
									"		  sum(x.sales_amt) <> 0	" 
			/* 관할구역 */
			Case '2' 
				sModString =	"select 0 as rank,	" + &
									"		 y.ittyp as ittyp ,	" + &
									"		 substr(y.itcls,1,2) as itcls,	" + &
									"		 w.titnm as itdsc,	" + &
									"		 a.sareanm as cvcod,	" + &
									"		 sum(x.sales_qty) as qty,	" + &
									"		 sum(x.sales_amt) as amt	" + &
									"  from salesum x, itemas y,itnct w, vndmst v, sarea a	" + &
									" where x.sabu = y.sabu and	" + &
									"		 x.itnbr = y.itnbr and	" + &
									"		 y.ittyp = w.ittyp and	" + &
									"		 substr(y.itcls,1,2) = w.itcls and	" + &
									"      w.lmsgu = 'L' and " + &
									"		 x.cvcod = v.cvcod and	" + &
									"		 v.sarea = a.sarea and	" + &
									"		 x.sabu = '" + gs_sabu + "' and	" + &
									"		 x.silgu = '" + arg_silgu + "' and	" + & 
									"		 x.sales_yymm >= '" + arg_sdatef + "' and	" + &
									"		 x.sales_yymm <= '" + arg_sdatet + "' and	" + &
									"		 a.steamcd like '" + arg_steamcd + "' and	" + &
									"		 v.sarea like '" + arg_sarea + "' and	" + &
									"		 x.cvcod like '" + arg_scust + "' and	" + &
									"		 w.pdtgu like '" + arg_pdtgu + "'	" + &
									" group by y.ittyp, substr(y.itcls,1,2), w.titnm, a.sareanm	" + &
									" having y.ittyp <> '9' and	" + &
									"		  sum(x.sales_amt) <> 0	" 
			/* 거래처 */
			Case '3' 
				sModString =	"select 0 as rank,	" + &
									"		 y.ittyp as ittyp ,	" + &
									"		 substr(y.itcls,1,2) as itcls,	" + &
									"		 w.titnm as itdsc,	" + &
									"		 v.cvnas as cvcod,	" + &
									"		 sum(x.sales_qty) as qty,	" + &
									"		 sum(x.sales_amt) as amt	" + &
									"  from salesum x, itemas y,itnct w, vndmst v, sarea a	" + &
									" where x.sabu = y.sabu and	" + &
									"		 x.itnbr = y.itnbr and	" + &
									"		 y.ittyp = w.ittyp and	" + &
									"		 substr(y.itcls,1,2) = w.itcls and	" + &
									"      w.lmsgu = 'L' and " + &
									"		 x.cvcod = v.cvcod and	" + &
									"		 v.sarea = a.sarea and	" + &
									"		 x.sabu = '" + gs_sabu + "' and	" + &
									"		 x.silgu = '" + arg_silgu + "' and	" + & 
									"		 x.sales_yymm >= '" + arg_sdatef + "' and	" + &
									"		 x.sales_yymm <= '" + arg_sdatet + "' and	" + &
									"		 a.steamcd like '" + arg_steamcd + "' and	" + &
									"		 v.sarea like '" + arg_sarea + "' and	" + &
									"		 x.cvcod like '" + arg_scust + "' and	" + &
									"		 w.pdtgu like '" + arg_pdtgu + "'	" + &
									" group by y.ittyp, substr(y.itcls,1,2), w.titnm, v.cvnas	" + &
									" having y.ittyp <> '9' and	" + &
									"		  sum(x.sales_amt) <> 0	" 
			End Choose
		
/* --------------------------------- */
	/* 중분류 일경우 */
	Case '2'
		Choose Case areagu
			/* 영업팀 */
			Case '1' 
				sModString =	"select 0 as rank,	" + &
									"		 y.ittyp as ittyp ,	" + &
									"		 substr(y.itcls,1,4) as itcls,	" + &
									"		 w.titnm as itdsc,	" + &
									"		 t.steamnm as cvcod,	" + &
									"		 sum(x.sales_qty) as qty,	" + &
									"		 sum(x.sales_amt) as amt	" + &
									"  from salesum x, itemas y,itnct w, vndmst v, sarea a, steam t " + &
									" where x.sabu = y.sabu and	" + &
									"		 x.itnbr = y.itnbr and	" + &
									"		 y.ittyp = w.ittyp and	" + &
									"		 substr(y.itcls,1,4) = w.itcls and	" + &
									"      w.lmsgu = 'M' and " + &
									"		 x.cvcod = v.cvcod and	" + &
									"		 v.sarea = a.sarea and	" + &
									"		 a.steamcd = t.steamcd and	" + &
									"		 x.sabu = '" + gs_sabu + "' and	" + &
									"		 x.silgu = '" + arg_silgu + "' and	" + &
									"		 x.sales_yymm >= '" + arg_sdatef + "' and	" + &
									"		 x.sales_yymm <= '" + arg_sdatet + "' and	" + &
									"		 a.steamcd like '" + arg_steamcd + "' and	" + &
									"		 v.sarea like '" + arg_sarea + "' and	" + &
									"		 x.cvcod like '" + arg_scust + "' and	" + &
									"		 w.pdtgu like '" + arg_pdtgu + "'	" + &
									" group by y.ittyp,substr(y.itcls,1,4), w.titnm, t.steamnm	" + &
									" having y.ittyp <> '9' and	" + &
									"		  sum(x.sales_amt) <> 0	" 
			/* 관할구역 */
			Case '2' 
				sModString =	"select 0 as rank,	" + &
									"		 y.ittyp as ittyp ,	" + &
									"		 substr(y.itcls,1,4) as itcls,	" + &
									"		 w.titnm as itdsc,	" + &
									"		 a.sareanm as cvcod,	" + &
									"		 sum(x.sales_qty) as qty,	" + &
									"		 sum(x.sales_amt) as amt	" + &
									"  from salesum x, itemas y,itnct w, vndmst v, sarea a	" + &
									" where x.sabu = y.sabu and	" + &
									"		 x.itnbr = y.itnbr and	" + &
									"		 y.ittyp = w.ittyp and	" + &
									"		 substr(y.itcls,1,4) = w.itcls and	" + &
									"      w.lmsgu = 'M' and " + &
									"		 x.cvcod = v.cvcod and	" + &
									"		 v.sarea = a.sarea and	" + &
									"		 x.sabu = '" + gs_sabu + "' and	" + &
									"		 x.silgu = '" + arg_silgu + "' and	" + &
									"		 x.sales_yymm >= '" + arg_sdatef + "' and	" + &
									"		 x.sales_yymm <= '" + arg_sdatet + "' and	" + &
									"		 a.steamcd like '" + arg_steamcd + "' and	" + &
									"		 v.sarea like '" + arg_sarea + "' and	" + &
									"		 x.cvcod like '" + arg_scust + "' and	" + &
									"		 w.pdtgu like '" + arg_pdtgu + "'	" + &
									" group by y.ittyp, substr(y.itcls,1,4), w.titnm, a.sareanm	" + &
									" having y.ittyp <> '9' and	" + &
									"		  sum(x.sales_amt) <> 0	" 
			/* 거래처 */
			Case '3' 
				sModString =	"select 0 as rank,	" + &
									"		 y.ittyp as ittyp ,	" + &
									"		 substr(y.itcls,1,4) as itcls,	" + &
									"		 w.titnm as itdsc,	" + &
									"		 v.cvnas as cvcod,	" + &
									"		 sum(x.sales_qty) as qty,	" + &
									"		 sum(x.sales_amt) as amt	" + &
									"  from salesum x, itemas y,itnct w, vndmst v, sarea a	" + &
									" where x.sabu = y.sabu and	" + &
									"		 x.itnbr = y.itnbr and	" + &
									"		 y.ittyp = w.ittyp and	" + &
									"		 substr(y.itcls,1,4) = w.itcls and	" + &
									"      w.lmsgu = 'M' and " + &
									"		 x.cvcod = v.cvcod and	" + &
									"		 v.sarea = a.sarea and	" + &
									"		 x.sabu = '" + gs_sabu + "' and	" + &
									"		 x.silgu = '" + arg_silgu + "' and	" + &
									"		 x.sales_yymm >= '" + arg_sdatef + "' and	" + &
									"		 x.sales_yymm <= '" + arg_sdatet + "' and	" + &
									"		 a.steamcd like '" + arg_steamcd + "' and	" + &
									"		 v.sarea like '" + arg_sarea + "' and	" + &
									"		 x.cvcod like '" + arg_scust + "' and	" + &
									"		 w.pdtgu like '" + arg_pdtgu + "'	" + &
									" group by y.ittyp, substr(y.itcls,1,4), w.titnm, v.cvnas	" + &
									" having y.ittyp <> '9' and	" + &
									"		  sum(x.sales_amt) <> 0	" 
			End Choose
		
/* --------------------------------- */
	/* 제품별 일경우 */
	Case '3'
		Choose Case areagu
			/* 영업팀 */
			Case '1' 
				sModString =	"select 0 as rank,	" + &
									"		 y.ittyp as ittyp ,	" + &
									"		 y.itcls as itcls,	" + &
									"		 x.itnbr as itnbr,	" + &
									"		 y.itdsc as itdsc,	" + &
									"      decode(y.ispec_code,null,y.jijil, y.jijil||'-'||y.ispec_code)   as jijil, " + &
									"      y.ispec as ispec	,	" + &
									"		 t.steamnm as cvcod,	" + &
									"		 sum(x.sales_qty) as qty,	" + &
									"		 sum(x.sales_amt) as amt	" + &
									"  from salesum x, itemas y,itnct w, vndmst v, sarea a, steam t " + &
									" where x.sabu = y.sabu and	" + &
									"		 x.itnbr = y.itnbr and	" + &
									"		 y.ittyp = w.ittyp and	" + &
									"		 y.itcls = w.itcls and	" + &
									"		 x.cvcod = v.cvcod and	" + &
									"		 v.sarea = a.sarea and	" + &
									"		 a.steamcd = t.steamcd and	" + &
									"		 x.sabu = '" + gs_sabu + "' and	" + &
									"		 x.silgu = '" + arg_silgu + "' and	" + &
									"		 x.sales_yymm >= '" + arg_sdatef + "' and	" + &
									"		 x.sales_yymm <= '" + arg_sdatet + "' and	" + &
									"		 a.steamcd like '" + arg_steamcd + "' and	" + &
									"		 v.sarea like '" + arg_sarea + "' and	" + &
									"		 x.cvcod like '" + arg_scust + "' and	" + &
									"		 w.pdtgu like '" + arg_pdtgu + "'	" + &
									" group by y.ittyp,y.itcls, x.itnbr, y.itdsc, y.ispec,y.ispec_code,y.jijil, t.steamnm	" + &
									" having y.ittyp <> '9' and	" + &
									"		  sum(x.sales_amt) <> 0	" 
			/* 관할구역 */
			Case '2' 
				sModString =	"select 0 as rank,	" + &
									"		 y.ittyp as ittyp ,	" + &
									"		 y.itcls as itcls,	" + &
									"		 x.itnbr as itnbr,	" + &
									"		 y.itdsc as itdsc,	" + &
									"      decode(y.ispec_code,null,y.jijil, y.jijil||'-'||y.ispec_code)   as jijil, " + &
									"      y.ispec as ispec	,	" + &
									"		 a.sareanm as cvcod,	" + &
									"		 sum(x.sales_qty) as qty,	" + &
									"		 sum(x.sales_amt) as amt	" + &
									"  from salesum x, itemas y,itnct w, vndmst v, sarea a	" + &
									" where x.sabu = y.sabu and	" + &
									"		 x.itnbr = y.itnbr and	" + &
									"		 y.ittyp = w.ittyp and	" + &
									"		 y.itcls = w.itcls and	" + &
									"		 x.cvcod = v.cvcod and	" + &
									"		 v.sarea = a.sarea and	" + &
									"		 x.sabu = '" + gs_sabu + "' and	" + &
									"		 x.silgu = '" + arg_silgu + "' and	" + &
									"		 x.sales_yymm >= '" + arg_sdatef + "' and	" + &
									"		 x.sales_yymm <= '" + arg_sdatet + "' and	" + &
									"		 a.steamcd like '" + arg_steamcd + "' and	" + &
									"		 v.sarea like '" + arg_sarea + "' and	" + &
									"		 x.cvcod like '" + arg_scust + "' and	" + &
									"		 w.pdtgu like '" + arg_pdtgu + "'	" + &
									" group by y.ittyp,y.itcls, x.itnbr, y.itdsc, y.ispec,y.ispec_code,y.jijil, a.sareanm	" + &
									" having y.ittyp <> '9' and	" + &
									"		  sum(x.sales_amt) <> 0	" 
			/* 거래처 */
			Case '3' 
				sModString =	"select 0 as rank,	" + &
									"		 y.ittyp as ittyp ,	" + &
									"		 y.itcls as itcls,	" + &
									"		 x.itnbr as itnbr,	" + &
									"		 y.itdsc as itdsc,	" + &
									"      decode(y.ispec_code,null,y.jijil, y.jijil||'-'||y.ispec_code)   as jijil, " + &
									"      y.ispec as ispec	,	" + &
									"		 v.cvnas as cvcod,	" + &
									"		 sum(x.sales_qty) as qty,	" + &
									"		 sum(x.sales_amt) as amt	" + &
									"  from salesum x, itemas y,itnct w, vndmst v, sarea a	" + &
									" where x.sabu = y.sabu and	" + &
									"		 x.itnbr = y.itnbr and	" + &
									"		 y.ittyp = w.ittyp and	" + &
									"		 y.itcls = w.itcls and	" + &
									"		 x.cvcod = v.cvcod and	" + &
									"		 v.sarea = a.sarea and	" + &
									"		 x.sabu = '" + gs_sabu + "' and	" + &
									"		 x.silgu = '" + arg_silgu + "' and	" + &
									"		 x.sales_yymm >= '" + arg_sdatef + "' and	" + &
									"		 x.sales_yymm <= '" + arg_sdatet + "' and	" + &
									"		 a.steamcd like '" + arg_steamcd + "' and	" + &
									"		 v.sarea like '" + arg_sarea + "' and	" + &
									"		 x.cvcod like '" + arg_scust + "' and	" + &
									"		 w.pdtgu like '" + arg_pdtgu + "'	" + &
									" group by y.ittyp,y.itcls, x.itnbr, y.itdsc, y.ispec,y.ispec_code,y.jijil, v.cvnas	" + &
									" having y.ittyp <> '9' and	" + &
									"		  sum(x.sales_amt) <> 0	" 
							end choose
/* 소분류 일경우 */
	Case '4'
		Choose Case areagu
			/* 영업팀 */
			Case '1' 
				sModString =	"select 0 as rank,	" + &
									"		 y.ittyp as ittyp ,	" + &
									"		 substr(y.itcls,1,7) as itcls,	" + &
									"		 w.titnm as itdsc,	" + &
									"		 t.steamnm as cvcod,	" + &
									"		 sum(x.sales_qty) as qty,	" + &
									"		 sum(x.sales_amt) as amt	" + &
									"  from salesum x, itemas y,itnct w, vndmst v, sarea a, steam t " + &
									" where x.sabu = y.sabu and	" + &
									"		 x.itnbr = y.itnbr and	" + &
									"		 y.ittyp = w.ittyp and	" + &
									"		 substr(y.itcls,1,7) = w.itcls and	" + &
									"      w.lmsgu = 'S' and " + &
									"		 x.cvcod = v.cvcod and	" + &
									"		 v.sarea = a.sarea and	" + &
									"		 a.steamcd = t.steamcd and	" + &
									"		 x.sabu = '" + gs_sabu + "' and	" + &
									"		 x.silgu = '" + arg_silgu + "' and	" + &
									"		 x.sales_yymm >= '" + arg_sdatef + "' and	" + &
									"		 x.sales_yymm <= '" + arg_sdatet + "' and	" + &
									"		 a.steamcd like '" + arg_steamcd + "' and	" + &
									"		 v.sarea like '" + arg_sarea + "' and	" + &
									"		 x.cvcod like '" + arg_scust + "' and	" + &
									"		 w.pdtgu like '" + arg_pdtgu + "'	" + &
									" group by y.ittyp,substr(y.itcls,1,7), w.titnm, t.steamnm	" + &
									" having y.ittyp <> '9' and	" + &
									"		  sum(x.sales_amt) <> 0	" 
			/* 관할구역 */
			Case '2' 
				sModString =	"select 0 as rank,	" + &
									"		 y.ittyp as ittyp ,	" + &
									"		 substr(y.itcls,1,7) as itcls,	" + &
									"		 w.titnm as itdsc,	" + &
									"		 a.sareanm as cvcod,	" + &
									"		 sum(x.sales_qty) as qty,	" + &
									"		 sum(x.sales_amt) as amt	" + &
									"  from salesum x, itemas y,itnct w, vndmst v, sarea a	" + &
									" where x.sabu = y.sabu and	" + &
									"		 x.itnbr = y.itnbr and	" + &
									"		 y.ittyp = w.ittyp and	" + &
									"		 substr(y.itcls,1,7) = w.itcls and	" + &
									"      w.lmsgu = 'S' and " + &
									"		 x.cvcod = v.cvcod and	" + &
									"		 v.sarea = a.sarea and	" + &
									"		 x.sabu = '" + gs_sabu + "' and	" + &
									"		 x.silgu = '" + arg_silgu + "' and	" + &
									"		 x.sales_yymm >= '" + arg_sdatef + "' and	" + &
									"		 x.sales_yymm <= '" + arg_sdatet + "' and	" + &
									"		 a.steamcd like '" + arg_steamcd + "' and	" + &
									"		 v.sarea like '" + arg_sarea + "' and	" + &
									"		 x.cvcod like '" + arg_scust + "' and	" + &
									"		 w.pdtgu like '" + arg_pdtgu + "'	" + &
									" group by y.ittyp, substr(y.itcls,1,7), w.titnm, a.sareanm	" + &
									" having y.ittyp <> '9' and	" + &
									"		  sum(x.sales_amt) <> 0	" 
			/* 거래처 */
			Case '3' 
				sModString =	"select 0 as rank,	" + &
									"		 y.ittyp as ittyp ,	" + &
									"		 substr(y.itcls,1,7) as itcls,	" + &
									"		 w.titnm as itdsc,	" + &
									"		 v.cvnas as cvcod,	" + &
									"		 sum(x.sales_qty) as qty,	" + &
									"		 sum(x.sales_amt) as amt	" + &
									"  from salesum x, itemas y,itnct w, vndmst v, sarea a	" + &
									" where x.sabu = y.sabu and	" + &
									"		 x.itnbr = y.itnbr and	" + &
									"		 y.ittyp = w.ittyp and	" + &
									"		 substr(y.itcls,1,7) = w.itcls and	" + &
									"      w.lmsgu = 'S' and " + &
									"		 x.cvcod = v.cvcod and	" + &
									"		 v.sarea = a.sarea and	" + &
									"		 x.sabu = '" + gs_sabu + "' and	" + &
									"		 x.silgu = '" + arg_silgu + "' and	" + &
									"		 x.sales_yymm >= '" + arg_sdatef + "' and	" + &
									"		 x.sales_yymm <= '" + arg_sdatet + "' and	" + &
									"		 a.steamcd like '" + arg_steamcd + "' and	" + &
									"		 v.sarea like '" + arg_sarea + "' and	" + &
									"		 x.cvcod like '" + arg_scust + "' and	" + &
									"		 w.pdtgu like '" + arg_pdtgu + "'	" + &
									" group by y.ittyp, substr(y.itcls,1,7), w.titnm, v.cvnas	" + &
									" having y.ittyp <> '9' and	" + &
									"		  sum(x.sales_amt) <> 0	" 
			End Choose
End Choose

end if
Return sModString

end function

public function integer wf_retrieve ();//제품별 , 지역별 분류
String sFrom,sTo,sTeam,sArea,sCust,sTeamName,sAreaName, sCustName, sPrtGbn, sPdtgu, sIttyp
String sModString, sAreaGu ,txt_name
Long   ix

If dw_ip.AcceptText() <> 1 Then Return -1

IF rb_1.checked = TRUE or rb_2.checked= false THEN

	sFrom       = dw_ip.GetItemString(1,"sdatef")
	sTo         = dw_ip.GetItemString(1,"sdatet")
	sTeam       = dw_ip.GetItemString(1,"deptcode")
	sArea       = dw_ip.GetItemString(1,"areacode")
	sCust       = dw_ip.GetItemString(1,"custcode")
	sCustName   = dw_ip.GetItemString(1,"custname")
	sPrtGbn     = dw_ip.GetItemString(1,"prtgbn")
	sPdtgu      = dw_ip.GetItemString(1,"pdtgu")
	sIttyp      = dw_ip.GetItemString(1,"ittyp")
	
	IF sFrom = "" OR IsNull(sFrom) THEN
		f_message_chk(30,'[수불기간]')
		dw_ip.SetColumn("sdatef")
		dw_ip.SetFocus()
		Return -1
	END IF
	
	IF sTo = "" OR IsNull(sTo) THEN
		f_message_chk(30,'[수불기간]')
		dw_ip.SetColumn("sdatet")
		dw_ip.SetFocus()
		Return -1
	END IF
	
	IF sTeam = "" OR IsNull(sTeam) THEN sTeam = ''
	IF sArea = "" OR IsNull(sArea) THEN sArea = ''
	IF sCust = "" OR IsNull(sCust) THEN sCust = ''
	IF sPdtgu = "" OR IsNull(sPdtgu) THEN sPdtgu = ''
	IF sIttyp = "" OR IsNull(sIttyp) THEN sIttyp = ''
	//////////////////////////////////// dw 선택및 트랜젝션 연결
	Choose Case tab_1.SelectedTab
		Case 1
			dw_select = tab_1.tabpage_1.dw_list_tab1
		Case 2
			dw_select = tab_1.tabpage_2.dw_list_tab2
		Case 3
			dw_select = tab_1.tabpage_4.dw_list_tab4
		Case 4
			dw_select = tab_1.tabpage_3.dw_list_tab3
	End Choose		
	dw_select.SetTransObject(sqlca)
	////////////////////////////////////////////////////////////////
	dw_select.SetRedraw(False)
	
	string ls_silgu

	SELECT DATANAME
	INTO  :ls_silgu
	FROM  SYSCNFG
	WHERE SYSGU = 'S' AND SERIAL = '8' AND LINENO = '40' ;
	
	If dw_select.retrieve(gs_sabu,steam+'%',sarea+'%',sCust+'%',sFrom,sTo, sPdtgu+'%', sIttyp+'%',ls_silgu) < 1 Then
		f_message_chk(50,"")
		dw_select.SetRedraw(True)
		return -1
	end if
	
	/* 순위 결정 */
	If sPrtGbn = '1' Then
		dw_select.SetSort('qty D')
		dw_select.Sort()
	Else
		dw_select.SetSort('amt D')
		dw_select.Sort()
	End If
	
	For ix = 1 To dw_select.RowCount()
		dw_select.SetItem(ix,'rank',ix)
	Next
	
	
	// title 년월 설정
	
	txt_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(pdtgu) ', 1)"))
	If IsNull(txt_name) or txt_name = '' Then txt_name = '전체'
//	dw_select.Object.txt_pdtgu.text = txt_name
	
	txt_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(deptcode) ', 1)"))
	If IsNull(txt_name) or txt_name = '' Then txt_name = '전체'
//	dw_select.Object.txt_steam.text = txt_name
//	
	txt_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(areacode) ', 1)"))
	If IsNull(txt_name) or txt_name = '' Then txt_name = '전체'
//	dw_select.Object.txt_sarea.text = txt_name
//	
	txt_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(ittyp) ', 1)"))
	If IsNull(txt_name) or txt_name = '' Then txt_name = '전체'
//	dw_select.Object.txt_ittyp.text = txt_name
//	
	txt_name = Trim(dw_ip.GetItemSTring(1,'custname'))
	If IsNull(txt_name) or txt_name = '' Then txt_name = '전체'
//	dw_select.Object.txt_cvcod.text = txt_name
//	
//	dw_select.SetRedraw(True)
	
ELSEIF rb_1.checked= true  or RB_2.CHECKED = TRUE THEN
	
	sFrom       = dw_ip.GetItemString(1,"sdatef")
	sTo         = dw_ip.GetItemString(1,"sdatet")
	sTeam       = dw_ip.GetItemString(1,"deptcode")
	sArea       = dw_ip.GetItemString(1,"areacode")
	sCust       = dw_ip.GetItemString(1,"custcode")
	sCustName   = dw_ip.GetItemString(1,"custname")
	sPrtGbn     = dw_ip.GetItemString(1,"prtgbn")
	sPdtgu      = dw_ip.GetItemString(1,"pdtgu")
	sAreaGu     = dw_ip.GetItemString(1,"areagu")
	
	IF sFrom = "" OR IsNull(sFrom) THEN
		f_message_chk(30,'[수불기간]')
		dw_ip.SetColumn("sdatef")
		dw_ip.SetFocus()
		Return -1
	END IF
	
	IF sTo = "" OR IsNull(sTo) THEN
		f_message_chk(30,'[수불기간]')
		dw_ip.SetColumn("sdatet")
		dw_ip.SetFocus()
		Return -1
	END IF
	
	IF sTeam = "" OR IsNull(sTeam) THEN sTeam = ''
	IF sArea = "" OR IsNull(sArea) THEN sArea = ''
	IF sCust = "" OR IsNull(sCust) THEN sCust = ''
	IF sPdtgu = "" OR IsNull(sPdtgu) THEN sPdtgu = ''
	//////////////////////////////////// dw 선택및 트랜젝션 연결
	Choose Case tab_1.SelectedTab
		Case 1
			dw_select = tab_1.tabpage_1.dw_list_tab1		
			sModString = wf_set_sqlsyntax('1',sAreaGu,steam+'%',sarea+'%',sCust+'%',sFrom,sTo,sPdtgu+'%',ls_silgu)
			dw_select.SetTransObject(sqlca)
			dw_select.SetSqlSelect(sModString)
		Case 2
			dw_select = tab_1.tabpage_2.dw_list_tab2		
			sModString = wf_set_sqlsyntax('2',sAreaGu,steam+'%',sarea+'%',sCust+'%',sFrom,sTo,sPdtgu+'%',ls_silgu)
			dw_select.SetTransObject(sqlca)
			dw_select.SetSqlSelect(sModString)
		Case 3
			dw_select = tab_1.tabpage_4.dw_list_tab4		
			sModString = wf_set_sqlsyntax('4',sAreaGu,steam+'%',sarea+'%',sCust+'%',sFrom,sTo,sPdtgu+'%',ls_silgu)
			dw_select.SetTransObject(sqlca)
			dw_select.SetSqlSelect(sModString)
		Case 4
			dw_select = tab_1.tabpage_3.dw_list_tab3		
			sModString = wf_set_sqlsyntax('3',sAreaGu,steam+'%',sarea+'%',sCust+'%',sFrom,sTo,sPdtgu+'%',ls_silgu)
			dw_select.SetTransObject(sqlca)
			dw_select.SetSqlSelect(sModString)
	End Choose
	
	
	////////////////////////////////////////////////////////////////
	dw_select.SetRedraw(False)
	
	If dw_select.retrieve() < 1 Then
		f_message_chk(50,"")
		dw_select.SetRedraw(True)
		return -1
	end if
	
	/* 순위 결정 */
	If sPrtGbn = '1' Then
		dw_select.SetSort('qty D')
		dw_select.Sort()
	Else
		dw_select.SetSort('amt D')
		dw_select.Sort()
	End If
	
	For ix = 1 To dw_select.RowCount()
		dw_select.SetItem(ix,'rank',ix)
	Next
	
	// title 년월 설정
	
	txt_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(pdtgu) ', 1)"))
	If IsNull(txt_name) or txt_name = '' Then txt_name = '전체'
	dw_select.Object.txt_pdtgu.text = txt_name
	
	txt_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(deptcode) ', 1)"))
	If IsNull(txt_name) or txt_name = '' Then txt_name = '전체'
	dw_select.Object.txt_steam.text = txt_name
	
	txt_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(areacode) ', 1)"))
	If IsNull(txt_name) or txt_name = '' Then txt_name = '전체'
	dw_select.Object.txt_sarea.text = txt_name
	
	txt_name = Trim(dw_ip.GetItemSTring(1,'custname'))
	If IsNull(txt_name) or txt_name = '' Then txt_name = '전체'
	dw_select.Object.txt_cvcod.text = txt_name
	
	Choose Case sAreaGu
		Case '1'
			dw_select.Object.cvcod_t.text = '영업팀'
		Case '2'
			dw_select.Object.cvcod_t.text = '관할구역'
		Case '3'
			dw_select.Object.cvcod_t.text = '거래처'
	End Choose
	
	dw_select.Object.txt_sdatef.text = String(sFrom,'@@@@.@@')
	dw_select.Object.txt_sdatet.text = String(sTo,'@@@@.@@')
	
	dw_select.SetRedraw(True)
	
END IF	
	
RETURN 1
end function

on w_sal_05725.create
int iCurrent
call super::create
this.tab_1=create tab_1
this.rb_1=create rb_1
this.rb_2=create rb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
end on

on w_sal_05725.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
destroy(this.rb_1)
destroy(this.rb_2)
end on

event open;call super::open;string syymm,ls_day
long   ll_day

syymm = Left(f_today(),4)
ls_day = left(f_today(),6)
ll_day = long(ls_day) - 1

dw_ip.setitem(1,'sdatef',string(ll_day) )
dw_ip.setitem(1,'sdatet', ls_day)

syymm = Left(f_today(),4)

dw_select = Create datawindow       // 조회용 



end event

type p_preview from w_standard_print`p_preview within w_sal_05725
integer taborder = 20
boolean originalsize = true
string picturename = "C:\ERPMAN\image\미리보기_up.gif"
end type

type p_exit from w_standard_print`p_exit within w_sal_05725
integer taborder = 50
boolean originalsize = true
string picturename = "C:\ERPMAN\image\닫기_up.gif"
end type

type p_print from w_standard_print`p_print within w_sal_05725
integer taborder = 30
boolean originalsize = true
string picturename = "C:\ERPMAN\image\인쇄_up.gif"
end type

event p_print::clicked;gi_page = 1
	
CHOOSE CASE tab_1.selectedtab
	CASE 1
		If tab_1.tabpage_1.dw_list_tab1.rowcount() > 0 then
			gi_page = tab_1.tabpage_1.dw_list_tab1.GetItemNumber(1,"last_page")
			OpenWithParm(w_print_options, tab_1.tabpage_1.dw_list_tab1)
		End If
	CASE 2
		IF tab_1.tabpage_2.dw_list_tab2.rowcount() > 0 then
			gi_page = tab_1.tabpage_2.dw_list_tab2.GetItemNumber(1,"last_page")
			OpenWithParm(w_print_options, tab_1.tabpage_2.dw_list_tab2)
		End If
	CASE 4
		IF tab_1.tabpage_3.dw_list_tab3.rowcount() > 0 then
			gi_page = tab_1.tabpage_3.dw_list_tab3.GetItemNumber(1,"last_page")
			OpenWithParm(w_print_options, tab_1.tabpage_3.dw_list_tab3)
		End If
	CASE 3
		IF tab_1.tabpage_4.dw_list_tab4.rowcount() > 0 then
			gi_page = tab_1.tabpage_4.dw_list_tab4.GetItemNumber(1,"last_page")
			OpenWithParm(w_print_options, tab_1.tabpage_4.dw_list_tab4)
		End If
END CHOOSE

end event

type p_retrieve from w_standard_print`p_retrieve within w_sal_05725
integer taborder = 10
boolean originalsize = true
string picturename = "C:\ERPMAN\image\조회_up.gif"
end type







type st_10 from w_standard_print`st_10 within w_sal_05725
end type



type dw_print from w_standard_print`dw_print within w_sal_05725
string dataobject = "d_sal_05725_06_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_05725
integer x = 347
integer y = 24
integer width = 3552
integer height = 340
integer taborder = 70
string dataobject = "d_sal_05725_09"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;string sIoCustName,sIoCustArea,sDept

SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

Choose Case this.GetColumnName() 
	/* 거래처 */
	Case "custcode"
		gs_gubun = '1'
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		this.SetItem(1,"custcode",gs_code)
		
		SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
		  INTO :sIoCustName,		:sIoCustArea,			:sDept
		  FROM "VNDMST","SAREA" 
		 WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :gs_code;
		IF SQLCA.SQLCODE = 0 THEN
			this.SetItem(1,"deptcode",  sDept)
			this.SetItem(1,"custname",  sIoCustName)
			this.SetItem(1,"areacode",  sIoCustArea)
		END IF
	/* 거래처명 */
	Case "custname"
		gs_gubun = '1'
		gs_codename = Trim(GetText())
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		this.SetItem(1,"custcode",gs_code)
		
		SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
		  INTO :sIoCustName,		:sIoCustArea,			:sDept
		  FROM "VNDMST","SAREA" 
		 WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :gs_code;
		IF SQLCA.SQLCODE = 0 THEN
			this.SetItem(1,"deptcode",  sDept)
			this.SetItem(1,"custname",  sIoCustName)
			this.SetItem(1,"areacode",  sIoCustArea)
		END IF
END Choose

end event

event dw_ip::itemchanged;String  sIoCust, sIoCustArea, sIoCustName, sDept, sDeptname
String  sDateFrom, sDateTo, snull, sPrtGbn
Long    ix

SetNull(snull)

Choose Case GetColumnName() 
	Case"sdatef"
		sDateFrom = Trim(this.GetText())
		IF sDateFrom ="" OR IsNull(sDateFrom) THEN RETURN
		
		IF f_datechk(sDateFrom+'01') = -1 THEN
			f_message_chk(35,'[수불기간]')
			this.SetItem(1,"sdatef",snull)
			Return 1
		END IF
	Case "sdatet"
		sDateTo = Trim(this.GetText())
		IF sDateTo ="" OR IsNull(sDateTo) THEN RETURN
		
		IF f_datechk(sDateTo+'01') = -1 THEN
			f_message_chk(35,'[수불기간]')
			this.SetItem(1,"sdatet",snull)
			Return 1
		END IF
	/* 영업팀 */
	Case "deptcode"
		SetItem(1,'areacode',sNull)
		SetItem(1,"custcode",sNull)
		SetItem(1,"custname",sNull)
	/* 관할구역 */
	Case "areacode"
		SetItem(1,"custcode",sNull)
		SetItem(1,"custname",sNull)
		
		sIoCustArea = this.GetText()
		IF sIoCustArea = "" OR IsNull(sIoCustArea) THEN RETURN
		
		SELECT "SAREA"."SAREA" ,"SAREA"."STEAMCD" 	INTO :sIoCustArea  ,:sDept
		  FROM "SAREA"  
		 WHERE "SAREA"."SAREA" = :sIoCustArea   ;
		
		SetItem(1,'deptcode',sDept)
	/* 거래처 */
	Case "custcode"
		sIoCust = this.GetText()
		IF sIoCust ="" OR IsNull(sIoCust) THEN
			this.SetItem(1,"custname",snull)
			Return
		END IF
		
		SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
		  INTO :sIoCustName,		:sIoCustArea,			:sDept
		  FROM "VNDMST","SAREA" 
		 WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :sIoCust   ;
		IF SQLCA.SQLCODE <> 0 THEN
			this.TriggerEvent(RbuttonDown!)
			Return 2
		ELSE
			this.SetItem(1,"deptcode",  sDept)
			this.SetItem(1,"custname",  sIoCustName)
			this.SetItem(1,"areacode",  sIoCustArea)
		END IF
	/* 거래처명 */
	Case "custname"
		sIoCustName = Trim(GetText())
		IF sIoCustName ="" OR IsNull(sIoCustName) THEN
			this.SetItem(1,"custcode",snull)
			Return
		END IF
		
		SELECT "VNDMST"."CVCOD", "VNDMST"."CVNAS2","VNDMST"."SAREA","SAREA"."STEAMCD"
		  INTO :sIoCust, :sIoCustName, :sIoCustArea,	:sDept
		  FROM "VNDMST","SAREA" 
		 WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVNAS2" = :sIoCustName;
		IF SQLCA.SQLCODE <> 0 THEN
			this.TriggerEvent(RbuttonDown!)
			Return 2
		ELSE
			SetItem(1,"deptcode",  sDept)
			SetItem(1,"custcode",  sIoCust)
			SetItem(1,"custname",  sIoCustName)
			SetItem(1,"areacode",  sIoCustArea)
			Return
		END IF
	Case 'prtgbn'
		sPrtGbn = Trim(GetText())
		/* 순위 결정 */
		If sPrtGbn = '1' Then
			dw_select.SetSort('qty D')
			dw_select.Sort()
		Else
			dw_select.SetSort('amt D')
			dw_select.Sort()
		End If
		
		For ix = 1 To dw_select.RowCount()
			dw_select.SetItem(ix,'rank',ix)
		Next
END Choose
end event

event dw_ip::ue_key;call super::ue_key;string sCol
str_itnct str_sitnct

SetNull(gs_code)
SetNull(gs_codename)

IF KeyDown(KeyF2!) THEN
	Choose Case GetColumnName()
	   Case  'itcls'
		    open(w_ittyp_popup3)
			 str_sitnct = Message.PowerObjectParm
			 if IsNull(str_sitnct.s_ittyp) or str_sitnct.s_ittyp = "" then return
//		    this.SetItem(1, "ittyp", str_sitnct.s_ittyp)
		    this.SetItem(1, "itcls", str_sitnct.s_sumgub)
		    this.SetItem(1, "itclsnm", str_sitnct.s_titnm)
	END Choose
End if	

end event

type dw_list from w_standard_print`dw_list within w_sal_05725
boolean visible = false
integer x = 974
integer y = 1848
integer width = 585
integer height = 344
end type

event dw_list::retrievestart;This.SetRedraw(False)
end event

event dw_list::retrieveend;This.SetRedraw(True)
end event

type tab_1 from tab within w_sal_05725
integer x = 59
integer y = 380
integer width = 4539
integer height = 1960
integer taborder = 60
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
alignment alignment = right!
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_4 tabpage_4
tabpage_3 tabpage_3
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_4=create tabpage_4
this.tabpage_3=create tabpage_3
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_4,&
this.tabpage_3}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_4)
destroy(this.tabpage_3)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4503
integer height = 1848
long backcolor = 32106727
string text = "대분류별 현황"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
dw_list_tab1 dw_list_tab1
end type

on tabpage_1.create
this.dw_list_tab1=create dw_list_tab1
this.Control[]={this.dw_list_tab1}
end on

on tabpage_1.destroy
destroy(this.dw_list_tab1)
end on

type dw_list_tab1 from datawindow within tabpage_1
event u_key pbm_dwnkey
integer width = 4503
integer height = 1848
integer taborder = 20
boolean bringtotop = true
boolean titlebar = true
string dataobject = "d_sal_05725_08"
boolean maxbox = true
boolean hscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event u_key;// Page Up & Page Down & Home & End Key 사용 정의
choose case key
	case keypageup!
		dw_list.scrollpriorpage()
	case keypagedown!
		dw_list.scrollnextpage()
	case keyhome!
		dw_list.scrolltorow(1)
	case keyend!
		dw_list.scrolltorow(dw_list.rowcount())
end choose

end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4503
integer height = 1848
long backcolor = 32106727
string text = "중분류별 현황"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
dw_list_tab2 dw_list_tab2
end type

on tabpage_2.create
this.dw_list_tab2=create dw_list_tab2
this.Control[]={this.dw_list_tab2}
end on

on tabpage_2.destroy
destroy(this.dw_list_tab2)
end on

type dw_list_tab2 from datawindow within tabpage_2
event u_key pbm_dwnkey
integer width = 4498
integer height = 1848
integer taborder = 10
boolean bringtotop = true
boolean titlebar = true
string dataobject = "d_sal_05725_07"
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event u_key;// Page Up & Page Down & Home & End Key 사용 정의
choose case key
	case keypageup!
		dw_list.scrollpriorpage()
	case keypagedown!
		dw_list.scrollnextpage()
	case keyhome!
		dw_list.scrolltorow(1)
	case keyend!
		dw_list.scrolltorow(dw_list.rowcount())
end choose

end event

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4503
integer height = 1848
long backcolor = 32106727
string text = "소분류별 현황"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
dw_list_tab4 dw_list_tab4
end type

on tabpage_4.create
this.dw_list_tab4=create dw_list_tab4
this.Control[]={this.dw_list_tab4}
end on

on tabpage_4.destroy
destroy(this.dw_list_tab4)
end on

type dw_list_tab4 from datawindow within tabpage_4
integer width = 4503
integer height = 1848
integer taborder = 70
boolean bringtotop = true
boolean titlebar = true
string dataobject = "d_sal_05725_10"
boolean maxbox = true
boolean hscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4503
integer height = 1848
long backcolor = 32106727
string text = "제품별 현황"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
dw_list_tab3 dw_list_tab3
end type

on tabpage_3.create
this.dw_list_tab3=create dw_list_tab3
this.Control[]={this.dw_list_tab3}
end on

on tabpage_3.destroy
destroy(this.dw_list_tab3)
end on

type dw_list_tab3 from datawindow within tabpage_3
event u_key pbm_dwnkey
integer width = 4503
integer height = 1848
integer taborder = 10
boolean bringtotop = true
boolean titlebar = true
string dataobject = "d_sal_05725_06"
boolean maxbox = true
boolean hscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event u_key;// Page Up & Page Down & Home & End Key 사용 정의
choose case key
	case keypageup!
		dw_list.scrollpriorpage()
	case keypagedown!
		dw_list.scrollnextpage()
	case keyhome!
		dw_list.scrolltorow(1)
	case keyend!
		dw_list.scrolltorow(dw_list.rowcount())
end choose

end event

type rb_1 from radiobutton within w_sal_05725
integer x = 64
integer y = 36
integer width = 279
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "제품별"
boolean checked = true
end type

event clicked;string syymm,ls_day
long ll_day

dw_ip.setredraw(false)
dw_ip.dataobject = 'd_sal_05725_09'
tab_1.tabpage_1.dw_list_tab1.dataobject = 'd_sal_05725_08'
tab_1.tabpage_2.dw_list_tab2.dataobject = 'd_sal_05725_07'
tab_1.tabpage_3.dw_list_tab3.dataobject = 'd_sal_05725_06'
tab_1.tabpage_4.dw_list_tab4.dataobject = 'd_sal_05725_10'
dw_ip.settransobject(sqlca)
dw_ip.insertrow(1)

syymm = Left(f_today(),4)
ls_day = left(f_today(),6)
ll_day = long(ls_day) - 1

dw_ip.setitem(1,'sdatef',string(ll_day) )
dw_ip.setitem(1,'sdatet', ls_day)

syymm = Left(f_today(),4)

//dw_ip.SetFocus()
dw_ip.setredraw(true)

dw_select = Create datawindow       // 조회용 
end event

type rb_2 from radiobutton within w_sal_05725
integer x = 64
integer y = 104
integer width = 279
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "지역별"
end type

event clicked;string syymm,ls_day
long ll_day

dw_ip.setredraw(false)
dw_ip.dataobject = 'd_sal_05725_04'
tab_1.tabpage_1.dw_list_tab1.dataobject = 'd_sal_05725_01'
tab_1.tabpage_2.dw_list_tab2.dataobject = 'd_sal_05725_02'
tab_1.tabpage_3.dw_list_tab3.dataobject = 'd_sal_05725_03'
tab_1.tabpage_4.dw_list_tab4.dataobject = 'd_sal_05725_05'
dw_ip.settransobject(sqlca)
dw_ip.insertrow(1)

syymm = Left(f_today(),4)
ls_day = left(f_today(),6)
ll_day = long(ls_day) - 1

dw_ip.setitem(1,'sdatef',string(ll_day) )
dw_ip.setitem(1,'sdatet', ls_day)

syymm = Left(f_today(),4)

//dw_ip.SetFocus()
dw_ip.setredraw(true)

dw_select = Create datawindow       // 조회용 
end event

