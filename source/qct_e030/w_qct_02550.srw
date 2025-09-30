$PBExportHeader$w_qct_02550.srw
$PBExportComments$** 제안실적 BEST 현황
forward
global type w_qct_02550 from w_standard_dw_graph
end type
type pb_1 from u_pb_cal within w_qct_02550
end type
type pb_2 from u_pb_cal within w_qct_02550
end type
end forward

global type w_qct_02550 from w_standard_dw_graph
string title = "제안실적 BEST 현황"
pb_1 pb_1
pb_2 pb_2
end type
global w_qct_02550 w_qct_02550

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();Long i, j
string  sql, sdate, edate, gu, dpt, jipdpt, jipdptnm, snull, simdpt

SetNull(snull)
if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

sdate  = trim(dw_ip.object.sdate[1])
edate  = trim(dw_ip.object.edate[1])
gu     = trim(dw_ip.object.gu[1])
dpt    = trim(dw_ip.object.dpt[1])
jipdpt = trim(dw_ip.object.jipdpt[1])
jipdptnm = trim(dw_ip.object.jipdptnm[1])
simdpt = trim(dw_ip.object.simdpt[1])

if (IsNull(sdate) or sdate = "")  then sdate = "10000101"
if (IsNull(edate) or edate = "")  then edate = "99991231"
if (IsNull(simdpt) or simdpt = "")  then simdpt = "%"

dw_list.object.txt_ymd.text = String(sdate, "@@@@.@@.@@") + " - " + String(edate, "@@@@.@@.@@")

if dpt = "1" then //제안부서별 집계
   dw_list.object.dpt_txt1.text = "부서(과/팀)"
	dw_list.object.dpt_txt2.text = "부서(과/팀)"
	if IsNull(jipdptnm) or jipdptnm = "" then jipdptnm = " "
	dw_list.object.txt_gu.text = jipdptnm
	if IsNull(jipdpt) or jipdpt = "" then jipdpt = '%'
//		f_message_chk(1400, "[부서코드]")
//		dw_ip.SetColumn("jipdpt")
//		dw_ip.SetFocus()
//		return -1		
//	end if	
	CHOOSE CASE gu
			
		CASE "1" //제출건수별
			dw_list.object.txt_title.text = "제출건수별 제안실적 BEST 현황" 
			dw_list.object.txt_hd1.text = "제출건수"
			dw_list.object.txt_hd2.text = "제출건수"
			sql = "select distinct(p.prodpt) as cod, 0 as rank1, 0 rank2, '1' as gubun, v.cvnas2 as nam, " &
   	       + "       '' as enam, '' as dnam, count(p.prop_jpno) as acnt, 0 as bcnt " &
      	    + "  from propms p, vndmst v " & 
         	 + " where p.sabu   = '"+ gs_sabu +"'" &
         	 + "   and p.prodat between '"+ sdate +"'" &
				 + "                    and '"+ edate +"'" &
         	 + "   and p.simdpt like '"+ simdpt +"'" &
	          + "   and p.prodpt = v.cvcod (+) " & 
   	       + "   and p.jests >= '1' " &
				 + "   and p.jipdpt like '" + jipdpt +"'" & 
         	 + " group by p.prodpt, v.cvnas2 " & 
	          + " union " &
   	       + " select distinct(p.empno) as cod, 0 as rank1, 0 rank2, '2' as gubun, '' as nam, " &
      	    + "        s.empname as enam, p.prodpt as dnam, 0 as acnt, count(p.prop_jpno) as bcnt " &
         	 + "   from propms p, p1_master s " &
         	 + "  where p.sabu   = '" + gs_sabu +"'" &
         	 + "    and p.prodat between '"+ sdate +"'" &
				 + "                     and '"+ edate +"'" &
         	 + "    and p.simdpt like '" + simdpt +"'" &
   	       + "    and p.empno = s.empno (+) " &
      	    + "    and p.jests >= '1' " &
				 + "    and p.jipdpt like '" + jipdpt +"'" & 
   	       + " group by p.empno, s.empname, p.prodpt " &
      	    + " order by gubun asc, acnt desc, bcnt desc, cod " 
		CASE "2" //채택건수별
			dw_list.object.txt_title.text = "채택건수별 제안실적 BEST 현황" 
			dw_list.object.txt_hd1.text = "채택건수"
			dw_list.object.txt_hd2.text = "채택건수"
			sql = "select distinct(p.prodpt) as cod, 0 as rank1, 0 rank2, '1' as gubun, v.cvnas2 as nam, " &
   	       + "       '' as enam, '' as dnam, count(p.prop_jpno) as acnt, 0 as bcnt " &
      	    + "  from propms p, vndmst v, reffpf f" & 
         	 + " where p.sabu   = '" + gs_sabu +"'" &
         	 + "   and p.prodat between '"+ sdate +"'" &
				 + "                    and '"+ edate +"'" &
         	 + "   and p.simdpt like '" + simdpt +"'"  &
	          + "   and p.prodpt = v.cvcod (+) " & 
   	       + "   and p.jests >= '2' " & 
				 + "   and '23'     = f.rfcod " &
				 + "   and p.prolvl = f.rfgub " &
				 + "   and 'Y'      = f.rfna3 " &
				 + "   and p.jipdpt like '" + jipdpt +"'" & 
      	    + " group by p.prodpt, v.cvnas2 " & 
         	 + " union " &
	          + " select distinct(p.empno) as cod, 0 as rank1, 0 rank2, '2' as gubun, '' as nam, " &
   	       + "        s.empname as enam, p.prodpt as dnam, 0 as acnt, count(p.prop_jpno) as bcnt " &
      	    + "   from propms p, p1_master s, reffpf f " &
         	 + "  where p.sabu   = '" + gs_sabu +"'" &
         	 + "    and p.prodat between '"+ sdate +"'" &
				 + "                     and '"+ edate +"'" &
         	 + "    and p.simdpt like '" + simdpt +"'" &
	          + "    and p.empno = s.empno (+) " &
   	       + "    and p.jests >= '2' " &
				 + "   and '23'     = f.rfcod " &
				 + "   and p.prolvl = f.rfgub " &
				 + "   and 'Y'      = f.rfna3 " &
				 + "    and p.jipdpt like '" + jipdpt +"'" & 
      	    + " group by p.empno, s.empname, p.prodpt " &
         	 + " order by gubun asc, acnt desc, bcnt desc, cod " 
		CASE "3" //절감금액별
			dw_list.object.txt_title.text = "절감금액별 제안실적 BEST 현황" 
			dw_list.object.txt_hd1.text = "절감금액"
			dw_list.object.txt_hd2.text = "절감금액"
			sql = "select distinct(p.prodpt) as cod, 0 as rank1, 0 rank2, '1' as gubun, v.cvnas2 as nam, " &
   	       + "       '' as enam, '' as dnam, sum(nvl(p.julamt, 0)) as acnt, 0 as bcnt " &
      	    + "  from propms p, vndmst v " & 
         	 + " where p.sabu   = '" + gs_sabu +"'" &
         	 + "   and p.prodat between '"+ sdate +"'" &
				 + "                    and '"+ edate +"'" &
         	 + "   and p.simdpt like '" + simdpt +"'" &
	          + "   and p.prodpt = v.cvcod (+) " & 
   	       + "   and p.jests = '3' " & 
				 + "   and p.jipdpt like '" + jipdpt +"'" & 
      	    + " group by p.prodpt, v.cvnas2 " & 
         	 + " union " &
	          + " select distinct(p.empno) as cod, 0 as rank1, 0 rank2, '2' as gubun, '' as nam, " &
   	       + "        s.empname as enam, p.prodpt as dnam, 0 as acnt, sum(nvl(p.julamt, 0)) as bcnt " &
      	    + "   from propms p, p1_master s " &
         	 + "  where p.sabu   = '" + gs_sabu +"'" &
         	 + "   and p.prodat between '"+ sdate +"'" &
				 + "                    and '"+ edate +"'" &
         	 + "    and p.simdpt like '" + simdpt +"'" &
	          + "    and p.empno = s.empno (+) " &
   	       + "    and p.jests = '3' " &
				 + "   and p.jipdpt like '" + jipdpt +"'" & 
      	    + " group by p.empno, s.empname, p.prodpt " &
         	 + " order by gubun asc, acnt desc, bcnt desc, cod " 
		CASE "4" //실시건수별
			dw_list.object.txt_title.text = "실시건수별 제안실적 BEST 현황" 
			dw_list.object.txt_hd1.text = "실시건수"
			dw_list.object.txt_hd2.text = "실시건수"
			sql = "select distinct(p.prodpt) as cod, 0 as rank1, 0 rank2, '1' as gubun, v.cvnas2 as nam, " &
   	       + "       '' as enam, '' as dnam, count(p.prop_jpno) as acnt, 0 as bcnt " &
      	    + "  from propms p, vndmst v " & 
         	 + " where p.sabu   = '" + gs_sabu +"'" &
         	 + "   and p.prodat between '"+ sdate +"'" &
				 + "                    and '"+ edate +"'" &
         	 + "   and p.simdpt like '" + simdpt +"'" &
	          + "   and p.prodpt = v.cvcod (+) " & 
	          + "   and p.jests = '3' " & 
				 + "   and p.wandat is not null " & 
				 + "   and p.jipdpt like '" + jipdpt +"'" & 
      	    + " group by p.prodpt, v.cvnas2 " & 
         	 + " union " &
	          + " select distinct(p.empno) as cod, 0 as rank1, 0 rank2, '2' as gubun, '' as nam, " &
   	       + "        s.empname as enam, p.prodpt as dnam, 0 as acnt, count(p.prop_jpno) as bcnt " &
      	    + "   from propms p, p1_master s " &
         	 + "  where p.sabu   = '" + gs_sabu +"'" &
         	 + "   and p.prodat between '"+ sdate +"'" &
				 + "                    and '"+ edate +"'" &
         	 + "    and p.simdpt like '" + simdpt +"'" &
	          + "    and p.empno = s.empno (+) " &
   	       + "    and p.jests = '3' " &
      	    + "    and p.wandat is not null " &
				 + "    and p.jipdpt like '" + jipdpt +"'" & 
         	 + " group by p.empno, s.empname, p.prodpt " &
	          + " order by gubun asc, acnt desc, bcnt desc, cod " 
		CASE "5" //점수별
			dw_list.object.txt_title.text = "심사점수별 제안실적 BEST 현황" 
			dw_list.object.txt_hd1.text = "심사점수"
			dw_list.object.txt_hd2.text = "심사점수"
			sql = "select x.cod, 0 as rank1, 0 rank2, x.gubun, x.nam, x.enam, x.dnam, x.acnt, x.bcnt " &
			    + "  from ( " &
			    + "select distinct(p.prodpt) as cod, '1' as gubun, v.cvnas2 as nam, " &
         	 + "       '' as enam, '' as dnam, " &
	          + "       sum(decode(p.jests, '1', 0.5, '2', 1, '3', 2, '4', 1, 0)) + sum(nvl(p.projum, 0)) as acnt, 0 as bcnt " &
   	       + "  from propms p, vndmst v " &
         	 + " where p.sabu   = '" + gs_sabu +"'" &
         	 + "   and p.prodat between '"+ sdate +"'" &
				 + "                    and '"+ edate +"'" &
         	 + "   and p.simdpt like '" + simdpt +"'" &
         	 + "   and p.prodpt = v.cvcod (+) " & 
	          + "   and p.jests >= '1' " &
				 + "   and p.jipdpt like '" + jipdpt +"'" & 
   	       + " group by p.prodpt, v.cvnas2 " &
      	    + "union " & 
         	 + "select distinct(p.empno) as cod, '2' as gubun, '' as nam, " &
	          + "       s.empname as enam, p.prodpt as dnam, 0 as acnt, " &
				 + "       sum(decode(p.jests, '1', 0.5, '2', 1, '3', 2, '4', 1, 0)) + sum(nvl(p.projum, 0)) as bcnt " &
	          + "  from propms p, p1_master s " &
         	 + " where p.sabu   = '" + gs_sabu +"'" &
         	 + "   and p.prodat between '"+ sdate +"'" &
				 + "                    and '"+ edate +"'" &
         	 + "   and p.simdpt like '" + simdpt +"'" &
      	    + "   and p.empno = s.empno (+) " &
         	 + "   and p.jests >= '1' " &
				 + "   and p.jipdpt like '" + jipdpt +"'" & 
	          + " group by p.empno, s.empname, p.prodpt " &
				 + " ) x " &
   	       + " order by x.gubun asc, x.acnt desc, x.bcnt desc, x.cod " 
	END CHOOSE
else
   dw_list.object.dpt_txt1.text = "부서"
	dw_list.object.dpt_txt2.text = "부서"
	dw_list.object.txt_gu.text = "부서별"
	CHOOSE CASE gu
		CASE "1" //제출건수별
			dw_list.object.txt_title.text = "제출건수별 제안실적 BEST 현황" 
			dw_list.object.txt_hd1.text = "제출건수"
			dw_list.object.txt_hd2.text = "제출건수"
			sql = "select distinct(p.jipdpt) as cod, 0 as rank1, 0 rank2, '1' as gubun, v.cvnas2 as nam, " &
   	       + "       '' as enam, '' as dnam, count(p.prop_jpno) as acnt, 0 as bcnt " &
      	    + "  from propms p, vndmst v " & 
         	 + " where p.sabu   = '" + gs_sabu +"'" &
         	 + "   and p.prodat between '"+ sdate +"'" &
				 + "                    and '"+ edate +"'" &
         	 + "   and p.simdpt like '" + simdpt +"'" &
	          + "   and p.jipdpt = v.cvcod (+) " & 
   	       + "   and p.jests >= '1' " & 
         	 + " group by p.jipdpt, v.cvnas2 " & 
	          + " union " &
   	       + " select distinct(p.empno) as cod, 0 as rank1, 0 rank2, '2' as gubun, '' as nam, " &
      	    + "        s.empname as enam, p.jipdpt as dnam, 0 as acnt, count(p.prop_jpno) as bcnt " &
         	 + "   from propms p, p1_master s " &
         	 + "  where p.sabu   = '" + gs_sabu +"'" &
         	 + "   and p.prodat between '"+ sdate +"'" &
				 + "                    and '"+ edate +"'" &
         	 + "    and p.simdpt like '" + simdpt +"'" &
   	       + "    and p.empno = s.empno (+) " &
      	    + "    and p.jests >= '1' " &
   	       + " group by p.empno, s.empname, p.jipdpt " &
      	    + " order by gubun asc, acnt desc, bcnt desc, cod " 
		CASE "2" //채택건수별
			dw_list.object.txt_title.text = "채택건수별 제안실적 BEST 현황" 
			dw_list.object.txt_hd1.text = "채택건수"
			dw_list.object.txt_hd2.text = "채택건수"
			sql = "select distinct(p.jipdpt) as cod, 0 as rank1, 0 rank2, '1' as gubun, v.cvnas2 as nam, " &
   	       + "       '' as enam, '' as dnam, count(p.prop_jpno) as acnt, 0 as bcnt " &
      	    + "  from propms p, vndmst v, reffpf f " & 
         	 + " where p.sabu   = '" + gs_sabu +"'" &
         	 + "   and p.prodat between '"+ sdate +"'" &
				 + "                    and '"+ edate +"'" &
         	 + "   and p.simdpt like '" + simdpt +"'" &
	          + "   and p.jipdpt = v.cvcod (+) " & 
   	       + "   and p.jests >= '2' " & 
				 + "   and '23'     = f.rfcod " &
				 + "   and p.prolvl = f.rfgub " &
				 + "   and 'Y'      = f.rfna3 " &
				 + " group by p.jipdpt, v.cvnas2 " & 
         	 + " union " &
	          + " select distinct(p.empno) as cod, 0 as rank1, 0 rank2, '2' as gubun, '' as nam, " &
   	       + "        s.empname as enam, p.jipdpt as dnam, 0 as acnt, count(p.prop_jpno) as bcnt " &
      	    + "   from propms p, p1_master s, reffpf f " &
         	 + "  where p.sabu   = '" + gs_sabu +"'" &
         	 + "   and p.prodat between '"+ sdate +"'" &
				 + "                    and '"+ edate +"'" &
         	 + "    and p.simdpt like '" + simdpt +"'" &
	          + "    and p.empno = s.empno (+) " &
   	       + "    and p.jests >= '2' " &
				 + "    and '23'     = f.rfcod " &
				 + "    and p.prolvl = f.rfgub " &
				 + "    and 'Y'      = f.rfna3 " &
				 + " group by p.empno, s.empname, p.jipdpt " &
         	 + " order by gubun asc, acnt desc, bcnt desc, cod " 
		CASE "3" //절감금액별
			dw_list.object.txt_title.text = "절감금액별 제안실적 BEST 현황" 
			dw_list.object.txt_hd1.text = "절감금액"
			dw_list.object.txt_hd2.text = "절감금액"
			sql = "select distinct(p.jipdpt) as cod, 0 as rank1, 0 rank2, '1' as gubun, v.cvnas2 as nam, " &
   	       + "       '' as enam, '' as dnam, sum(nvl(p.julamt, 0)) as acnt, 0 as bcnt " &
      	    + "  from propms p, vndmst v " & 
         	 + " where p.sabu   = '" + gs_sabu +"'" &
         	 + "   and p.prodat between '"+ sdate +"'" &
				 + "                    and '"+ edate +"'" &
         	 + "   and p.simdpt like '" + simdpt +"'" &
	          + "   and p.jipdpt = v.cvcod (+) " & 
   	       + "   and p.jests = '3' " & 
      	    + " group by p.jipdpt, v.cvnas2 " & 
         	 + " union " &
	          + " select distinct(p.empno) as cod, 0 as rank1, 0 rank2, '2' as gubun, '' as nam, " &
   	       + "        s.empname as enam, p.jipdpt as dnam, 0 as acnt, sum(nvl(p.julamt, 0)) as bcnt " &
      	    + "   from propms p, p1_master s " &
         	 + "  where p.sabu   = '" + gs_sabu +"'" &
         	 + "   and p.prodat between '"+ sdate +"'" &
				 + "                    and '"+ edate +"'" &
         	 + "    and p.simdpt like '" + simdpt +"'" &
	          + "    and p.empno = s.empno (+) " &
   	       + "    and p.jests = '3' " &
      	    + " group by p.empno, s.empname, p.jipdpt " &
         	 + " order by gubun asc, acnt desc, bcnt desc, cod " 
		CASE "4" //실시건수별
			dw_list.object.txt_title.text = "실시건수별 제안실적 BEST 현황" 
			dw_list.object.txt_hd1.text = "실시건수"
			dw_list.object.txt_hd2.text = "실시건수"
			sql = "select distinct(p.jipdpt) as cod, 0 as rank1, 0 rank2, '1' as gubun, v.cvnas2 as nam, " &
   	       + "       '' as enam, '' as dnam, count(p.prop_jpno) as acnt, 0 as bcnt " &
      	    + "  from propms p, vndmst v " & 
         	 + " where p.sabu   = '" + gs_sabu +"'" &
         	 + "   and p.prodat between '"+ sdate +"'" &
				 + "                    and '"+ edate +"'" &
         	 + "   and p.simdpt like '" + simdpt +"'" &
	          + "   and p.jipdpt = v.cvcod (+) " & 
	          + "   and p.jests = '3' " & 
				 + "   and p.wandat is not null " & 
      	    + " group by p.jipdpt, v.cvnas2 " & 
         	 + " union " &
	          + " select distinct(p.empno) as cod, 0 as rank1, 0 rank2, '2' as gubun, '' as nam, " &
   	       + "        s.empname as enam, p.jipdpt as dnam, 0 as acnt, count(p.prop_jpno) as bcnt " &
      	    + "   from propms p, p1_master s " &
         	 + "  where p.sabu   = '" + gs_sabu +"'" &
         	 + "   and p.prodat between '"+ sdate +"'" &
				 + "                    and '"+ edate +"'" &
         	 + "    and p.simdpt like '" + simdpt +"'" &
	          + "    and p.empno = s.empno (+) " &
   	       + "    and p.jests = '3' " &
      	    + "   and p.wandat is not null " &
         	 + " group by p.empno, s.empname, p.jipdpt " &
	          + " order by gubun asc, acnt desc, bcnt desc, cod " 
		CASE "5" //점수별
			dw_list.object.txt_title.text = "심사점수별 제안실적 BEST 현황" 
			dw_list.object.txt_hd1.text = "심사점수"
			dw_list.object.txt_hd2.text = "심사점수"
			sql = "select x.cod, 0 as rank1, 0 rank2, x.gubun, x.nam, x.enam, x.dnam, x.acnt, x.bcnt " &
			    + "  from ( " &
				 + "select distinct(p.jipdpt) as cod, '1' as gubun, v.cvnas2 as nam, " &
         	 + "       '' as enam, '' as dnam, " &
	          + "       sum(decode(p.jests, '1', 0.5, '2', 1, '3', 2, '4', 1, 0)) + sum(nvl(p.projum, 0)) as acnt, 0 as bcnt " &
   	       + "  from propms p, vndmst v " &
         	 + " where p.sabu   = '" + gs_sabu +"'" &
         	 + "   and p.prodat between '"+ sdate +"'" &
				 + "                    and '"+ edate +"'" &
         	 + "   and p.simdpt like '" + simdpt +"'" &
         	 + "   and p.jipdpt = v.cvcod (+) " & 
	          + "   and p.jests >= '1' " &
   	       + " group by p.jipdpt, v.cvnas2 " &
      	    + "union " & 
         	 + "select distinct(p.empno) as cod, '2' as gubun, '' as nam, " &
	          + "       s.empname as enam, p.jipdpt as dnam, 0 as acnt, " &
				 + "       sum(decode(p.jests, '1', 0.5, '2', 1, '3', 2, '4', 1, 0)) + sum(nvl(p.projum, 0)) as bcnt " &
	          + "  from propms p, p1_master s " &
         	 + " where p.sabu   = '" + gs_sabu +"'" &
         	 + "   and p.prodat between '"+ sdate +"'" &
				 + "                    and '"+ edate +"'" &
         	 + "   and p.simdpt like '" + simdpt +"'" &
      	    + "   and p.empno = s.empno (+) " &
         	 + "   and p.jests >= '1' " &
	          + " group by p.empno, s.empname, p.jipdpt " &
   	       + " ) x " &
   	       + " order by x.gubun asc, x.acnt desc, x.bcnt desc, x.cod " 
	END CHOOSE
end if

dw_list.SetSQLSelect(sql)
dw_list.ReSet()
if dw_list.Retrieve() <= 0 then
   f_message_chk(50,'[제안실적 BEST 현황]')
   dw_ip.Setfocus()
   return -1
end if

dw_list.SetReDraw(False)
	
j = 0	
for i = 1 to dw_list.RowCount()
	if dw_list.object.gubun[i] = "2" then
		j = j + 1
		dw_list.object.enam[j] = dw_list.object.enam[i]
		dw_list.object.dnam[j] = dw_list.object.dnam[i]
		dw_list.object.bcnt[j] = dw_list.object.bcnt[i]
		if i <> j then
			dw_list.object.enam[i] = snull
		   dw_list.object.dnam[i] = snull
		   dw_list.object.bcnt[i] = 0
		end if
	end if	
next

//부서와 개인 모두가 Null
//그래프를 위해서 하위 Row 삭제
for i = dw_list.RowCount() to 1 step -1
	if (IsNull(dw_list.object.nam[i]) or dw_list.object.nam[i] = "") and &
	   (IsNull(dw_list.object.enam[i]) or dw_list.object.enam[i] = "") then
		dw_list.DeleteRow(i)
	end if	
next

dw_list.object.rank1[1] = 1
dw_list.object.rank2[1] = 1
for i = 2 to dw_list.RowCount() 
	j = i - 1
	if dw_list.object.acnt[j] > dw_list.object.acnt[i] then
		dw_list.object.rank1[i] = i
	else
		dw_list.object.rank1[i] = dw_list.object.rank1[j]
	end if
	if dw_list.object.bcnt[j] > dw_list.object.bcnt[i] then
		dw_list.object.rank2[i] = i
	else
		dw_list.object.rank2[i] = dw_list.object.rank2[j]
	end if
next

//상위 10위 까지만 표현
for i = 1 to dw_list.RowCount() 
	if dw_list.object.rank1[i] > 10 or &
	   IsNull(Trim(dw_list.object.nam[i])) or Trim(dw_list.object.nam[i]) = "" then 
		dw_list.object.rank1[i] = 0
	end if	
	if dw_list.object.rank2[i] > 10 or &
	   IsNull(Trim(dw_list.object.dnam[i])) or Trim(dw_list.object.dnam[i]) = "" then 
		dw_list.object.rank2[i] = 0
	end if	
next	

for i = dw_list.RowCount() to 1 step -1
	if dw_list.object.rank1[i] = 0 and dw_list.object.rank2[i] = 0 then
		dw_list.DeleteRow(i)
   end if
next	

dw_list.SetReDraw(True)

return 1

end function

on w_qct_02550.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
end on

on w_qct_02550.destroy
call super::destroy
destroy(this.pb_1)
destroy(this.pb_2)
end on

type p_exit from w_standard_dw_graph`p_exit within w_qct_02550
end type

type p_print from w_standard_dw_graph`p_print within w_qct_02550
end type

type p_retrieve from w_standard_dw_graph`p_retrieve within w_qct_02550
end type

type st_window from w_standard_dw_graph`st_window within w_qct_02550
end type

type st_popup from w_standard_dw_graph`st_popup within w_qct_02550
end type

type pb_title from w_standard_dw_graph`pb_title within w_qct_02550
integer x = 3840
end type

type pb_space from w_standard_dw_graph`pb_space within w_qct_02550
integer x = 3662
end type

type pb_color from w_standard_dw_graph`pb_color within w_qct_02550
integer x = 3483
end type

type pb_graph from w_standard_dw_graph`pb_graph within w_qct_02550
integer x = 3305
end type

type dw_ip from w_standard_dw_graph`dw_ip within w_qct_02550
integer x = 41
integer y = 0
integer width = 3739
integer height = 272
string dataobject = "d_qct_02550_01"
end type

event dw_ip::itemchanged;string s_cod, s_nam1, s_nam2
integer i_rtn

s_cod = Trim(this.GetText())

if this.GetColumnName() = "sdate" then
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35,"[시작일자]")
		this.object.sdate[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "edate" then
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35,"[끝일자]")
		this.object.edate[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "jipdpt" Then
	i_rtn = f_get_name2("부서", "N", s_cod, s_nam1, s_nam2)
	this.object.jipdpt[1] = s_cod
	this.object.jipdptnm[1] = s_nam1
	return i_rtn
end if

end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

IF	this.getcolumnname() = "jipdpt"	THEN		
	open(w_vndmst_4_popup)
	IF gs_code = '' or isnull(gs_code) then return 
	
	this.SetItem(1, "jipdpt", gs_code)
	this.SetItem(1, "jipdptnm", gs_codename)
	return 
END IF
end event

type sle_msg from w_standard_dw_graph`sle_msg within w_qct_02550
end type

type dw_datetime from w_standard_dw_graph`dw_datetime within w_qct_02550
end type

type st_10 from w_standard_dw_graph`st_10 within w_qct_02550
end type

type gb_3 from w_standard_dw_graph`gb_3 within w_qct_02550
integer x = 3273
end type

type dw_list from w_standard_dw_graph`dw_list within w_qct_02550
integer y = 304
integer height = 2012
string dataobject = "d_qct_02550_03"
end type

type gb_10 from w_standard_dw_graph`gb_10 within w_qct_02550
end type

type rr_1 from w_standard_dw_graph`rr_1 within w_qct_02550
integer y = 292
integer height = 2044
end type

type pb_1 from u_pb_cal within w_qct_02550
integer x = 357
integer y = 64
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('sdate')
IF Isnull(gs_code) THEN Return
dw_ip.SetItem(dw_ip.getrow(), 'sdate', gs_code)
end event

type pb_2 from u_pb_cal within w_qct_02550
integer x = 795
integer y = 64
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('edate')
IF Isnull(gs_code) THEN Return
dw_ip.SetItem(dw_ip.getrow(), 'edate', gs_code)
end event

