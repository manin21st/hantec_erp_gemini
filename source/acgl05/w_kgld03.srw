$PBExportHeader$w_kgld03.srw
$PBExportComments$합계잔액시산표(조회/출력)
forward
global type w_kgld03 from w_standard_print
end type
type rb_1 from radiobutton within w_kgld03
end type
type rb_2 from radiobutton within w_kgld03
end type
type rb_3 from radiobutton within w_kgld03
end type
type st_2 from statictext within w_kgld03
end type
type cbx_1 from checkbox within w_kgld03
end type
type cbx_2 from checkbox within w_kgld03
end type
type cbx_3 from checkbox within w_kgld03
end type
type cbx_4 from checkbox within w_kgld03
end type
type cbx_5 from checkbox within w_kgld03
end type
type cbx_6 from checkbox within w_kgld03
end type
type rr_1 from roundrectangle within w_kgld03
end type
type rr_2 from roundrectangle within w_kgld03
end type
type rr_3 from roundrectangle within w_kgld03
end type
end forward

global type w_kgld03 from w_standard_print
integer x = 0
integer y = 0
string title = "합계잔액시산표 조회 출력"
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
st_2 st_2
cbx_1 cbx_1
cbx_2 cbx_2
cbx_3 cbx_3
cbx_4 cbx_4
cbx_5 cbx_5
cbx_6 cbx_6
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
end type
global w_kgld03 w_kgld03

type variables
dec dr_zan_tot, dr_sum_tot, dr_mm_tot, dr_pre_mm_tot, &
    cr_pre_mm_tot, cr_mm_tot, cr_sum_tot, cr_zan_tot
end variables

forward prototypes
public function integer wf_retrieve ()
public function integer wf_retrieve_prt1 (string arg_saupj, string arg_yy, string arg_mm, string arg_saupj_nm)
public function integer wf_retrieve_prt2 (string arg_saupj, string arg_yy, string arg_mm, string arg_saupj_nm)
public function integer wf_retrieve_prt3 (string arg_saupj, string arg_yy, string arg_mm, string arg_saupj_nm)
public function integer wf_retrieve_prt4 (string arg_saupj, string arg_yy, string arg_mm)
end prototypes

public function integer wf_retrieve ();String ls_saupj, ls_acc_ym, ls_ym_text, get_code, get_name
string snull, ls_yy, ls_mm, sBefMonth

long ll_row, ll_return 
//dec dr_zan_tot, cr_zan_tot, dr_sum_tot, cr_sum_tot
//dec dr_mm_tot, cr_mm_tot

SetNull(snull)

ll_row = dw_ip.GetRow()

if  ll_row < 1 then return -1
if dw_ip.AcceptText() = -1 then return -1

// 사업장별 합계잔액 월계시산표 출력일 경우, 
// 사업장은 global 변수를 받는다.
//if rb_4.checked then
//	ls_saupj = gs_saupj
//else
   ls_saupj =dw_ip.GetItemString(ll_row,"saupj")
//end if

ls_acc_ym =dw_ip.GetItemString(ll_row,"acc_ym")

if trim(ls_saupj) = '' or isnull(ls_saupj) then 
	F_MessageChk(1, "[사업장]")
	return -1
else
	SELECT "REFFPF"."RFGUB", "REFFPF"."RFNA1"  
		INTO :get_code, :get_name
		FROM "REFFPF"  
		WHERE "REFFPF"."RFCOD" = 'AD'   AND "REFFPF"."RFGUB" = :ls_saupj ;
	if sqlca.sqlcode <> 0 then 
		MessageBox("확 인", "사업장 코드를 확인하십시오.!!")
	   dw_ip.SetItem(ll_row, 'saupj', snull)
		return -1
	end if
end if

if trim(ls_acc_ym) = "" or isnull(ls_acc_ym) then
	f_messagechk(1,"[회계년월]") 
	dw_ip.SetColumn("acc_ym")
	dw_ip.SetFocus()
	return -1
else
	IF Mid(ls_acc_ym,5,2) <> '00' THEN
		if f_datechk(ls_acc_ym+'01') = -1 then 
			F_Messagechk(21,"[회계년월]")
			dw_ip.SetColumn("acc_ym")
			dw_ip.SetFocus()
			return -1
		end if
	END IF
end if 


ls_yy = left(ls_acc_ym, 4)
ls_mm = right(ls_acc_ym,2)

IF ls_mm ='00' THEN										/*전월*/
	sBefMonth = '00'
ELSE
	sBefMonth = String(Integer(ls_mm) - 1,'00')
END IF

//합계 셀렉트
//
		select sum(nvl(decode(f.dc_gu,'1',nvl(e.dr_sum,0) - nvl(e.cr_sum,0)),0)) as dr_jan,    
			    sum(nvl(e.dr_sum,0)) as dr_sum,
				 sum(nvl(e.cr_sum,0)) as cr_sum,       
				 sum(nvl(d.dr_amt,0)) as dr_amt,   
				 sum(nvl(d.cr_amt,0)) as cr_amt,
				 sum(nvl(c.dr_bef,0)) as dr_pre_mm_tot,   
				 sum(nvl(c.cr_bef,0)) as cr_pre_mm_tot,     	 			 
				 
				 sum(nvl(decode(f.dc_gu,'2',nvl(e.cr_sum,0) - nvl(e.dr_sum,0)),0)) as cr_jan    
			INTO :dr_zan_tot, 
				  :dr_sum_tot,
				  :cr_sum_tot,				  
				  :dr_mm_tot,
				  :cr_mm_tot,				  
				  :dr_pre_mm_tot,    
			     :cr_pre_mm_tot,
				  :cr_zan_tot  
			from  (select saupj,      acc_yy, acc1_cd,          acc2_cd, 
			              sum(nvl(dr_amt,0)) as dr_bef, sum(nvl(cr_amt,0)) as cr_bef
						from kfz14ot0
						where saupj = :ls_saupj and 
						      acc_yy = :ls_yy and 
								acc_mm <= :sBefMonth
					 group by saupj, acc_yy, acc1_cd, acc2_cd ) c,
					(select saupj, acc_yy, acc_mm, acc1_cd, acc2_cd, dr_amt, cr_amt
						from kfz14ot0
						where saupj = :ls_saupj and 
						      acc_yy = :ls_yy and 
								acc_mm = :ls_mm ) d,
				  (select saupj, acc1_cd, acc2_cd, 
							 sum(nvl(dr_amt,0)) as dr_sum, sum(nvl(cr_amt,0)) as cr_sum
						from kfz14ot0
						where saupj = :ls_saupj and 
						      acc_yy = :ls_yy and 
								acc_mm >= '00' and 
								acc_mm <= :ls_mm
						group by saupj, acc1_cd, acc2_cd) e,
					(select acc1_cd, acc2_cd, dc_gu, lev_gu, bal_gu, acc1_nm, acc2_nm, tbprt_gu
						from kfz01om0) f
						where (e.saupj   = c.saupj(+))   and 
								(e.acc1_cd = c.acc1_cd(+)) and  
								(e.acc2_cd = c.acc2_cd(+)) and 
								(e.saupj   = d.saupj(+))   and 
								(e.acc1_cd = d.acc1_cd(+)) and  
								(e.acc2_cd = d.acc2_cd(+)) and 
								(e.acc1_cd = f.acc1_cd) and
								(e.acc2_cd = f.acc2_cd) ;		

// 합계잔액시산표 
if rb_1.checked = true then 
	
   ll_return = wf_retrieve_prt1(ls_saupj, ls_yy, ls_mm, get_name)
	
elseif rb_2.checked then 
// 합계잔액 월계시산표 
   ll_return = wf_retrieve_prt2(ls_saupj, ls_yy, ls_mm, get_name)
	
elseif rb_3.checked = true then 
	// 합계잔액 월계 비교시산표
	
   ll_return = wf_retrieve_prt3(ls_saupj, ls_yy, ls_mm, get_name)	
	
//elseif rb_4.checked = true then 
//	// 사업장별 합계잔액 월계시산표
//	
//   ll_return = wf_retrieve_prt4(ls_saupj, ls_yy, ls_mm)	
else 
	 dw_print.insertrow(0)
end if

if ll_return = -1 then return -1

Return 1
end function

public function integer wf_retrieve_prt1 (string arg_saupj, string arg_yy, string arg_mm, string arg_saupj_nm);string ls_saupj, ls_yy, ls_mm, ls_ym_text, ls_saupj_nm, ls_GetSqlSyntax

//dec dr_zan_tot, dr_sum_tot, dr_mm_tot, &
//    cr_mm_tot, cr_sum_tot, cr_zan_tot

long ll_GetSqlSyntax

ls_saupj = arg_saupj        // 사업장
ls_yy = arg_yy              // 회계년도
ls_mm = arg_mm              // 회계월
ls_saupj_nm = arg_saupj_nm  // 사업장명 
ls_ym_text = ls_yy + '.'+ ls_mm

// 회계년월을 setting 한다.
dw_print.modify("ym.text ='"+ls_ym_text+"'")

//사업장명을 setting 한다.
dw_print.modify("saup.text ='"+ls_saupj_nm+"'")

// sql문
ls_GetSqlSyntax = 'select nvl(decode(c.dc_gu, ' + "'" + "1" + "'," + &
					 '          nvl(b.dr_sum,0) - nvl(b.cr_sum,0)),0) as dr_jan, ' + & 
                '        nvl(b.dr_sum,0) as dr_sum, ' + &
                '        c.acc2_nm as acc2_nm, ' + &
					 '        c.acc1_cd, '  + &
					 '        c.acc2_cd, '  + &
                '        nvl(b.cr_sum,0) as cr_sum, '  + &
                '        nvl(decode(c.dc_gu, ' + "'" + "2" + "'"+ ","   + &
					 '                   nvl(b.cr_sum,0) - nvl(b.dr_sum,0)), 0) as cr_jan, ' + &
                '        0 as cha_mtot, '  + &
                '        0 as cha_sumzan, ' +  &
                '        0 as cha_sumnu, '  + &
                '        0 as dea_mtot, '  + &
                '        0 as dea_sumzan, ' +  &
                '        0 as dea_sumnu, '  + &
					 '        c.bal_gu '  + &
                'from (select saupj, acc_yy, acc_mm, acc1_cd, acc2_cd, dr_amt, cr_amt '  + &
                '      from kfz14ot0   '  + &
                '       where saupj  = '  + "'" + ls_saupj + "'" + 'and   ' + &
					 '             acc_yy = ' + "'" + ls_yy + "'"  + ' and    '  + &
                '             acc_mm = ' + "'"+ ls_mm + "'" + ' ) a,    '  + &
                '      (select saupj, acc1_cd, acc2_cd, sum(dr_amt) as dr_sum,   '  + &
                '              sum(cr_amt) as cr_sum    '  + &
                '       from kfz14ot0     '  + &
                '       where  saupj  = '  + "'" + ls_saupj + "'" + 'and   ' + &
					 '              acc_yy =  ' + "'" + ls_yy + "'" + ' and  '  + &
                '              acc_mm >= ' + "'" + "00" + "'" + ' and   '  + &
                '              acc_mm <= ' + "'" + ls_mm + "'"  + &
                '       group by saupj, acc1_cd, acc2_cd) b,   '  +  &
                '       (select acc1_cd, acc2_cd, dc_gu, lev_gu, bal_gu,   '  + &
                '                acc1_nm, acc2_nm, tbprt_gu   '  + &
                '        from kfz01om0) c    '  + &
                'where (b.saupj   = a.saupj(+))   and   '  + &
                '      (b.acc1_cd = a.acc1_cd(+)) and   '  + &
                '      (b.acc2_cd = a.acc2_cd(+)) and   '  + &
                '      (b.acc1_cd = c.acc1_cd) and   '  + &
                '      (b.acc2_cd = c.acc2_cd)  and ('  


if cbx_1.checked=false and cbx_2.checked=false and cbx_3.checked=false and &
       cbx_4.checked=false and cbx_5.checked=false and cbx_6.checked=false then
	MessageBox("확 인", "출력항목은 반드시 하나 이상 ~r~r선택되어야 합니다.")
   return -1
else
	// 대분류 과목	
	if cbx_1.checked then
		ls_GetSqlSyntax = ls_GetSqlSyntax + '(c.lev_gu = ' + "'"+"1" + "'" + ') or' 	
	end if
	
	//중분류 과목
	if cbx_2.checked then   
		ls_GetSqlSyntax = ls_GetSqlSyntax + '(c.lev_gu = ' + "'"+"2" + "'" + ') or' 	
	end if
	
	//소분류 과목
	if cbx_3.checked then
		ls_GetSqlSyntax = ls_GetSqlSyntax + '(c.lev_gu = ' + "'"+"3" + "'" + ') or' 	
	end if
	
	//계정과목
	if cbx_4.checked then
		ls_GetSqlSyntax = ls_GetSqlSyntax + '(c.lev_gu = ' + "'"+"4" + "'" + ') or' 	
	end if
	
	//세분류과목
	if cbx_5.checked then
		if cbx_6.checked then	//출력유무
			ls_GetSqlSyntax = ls_GetSqlSyntax + '((c.lev_gu = ' + "'"+"5" + "'" + ') and (c.tbprt_gu = ' + "'"+"Y" + "'" + ')) or' 	
		else
			ls_GetSqlSyntax = ls_GetSqlSyntax + '(c.lev_gu = ' + "'"+"5" + "'" + ') or'
		end if
	else
		if cbx_6.checked then	//출력유무
			ls_GetSqlSyntax = ls_GetSqlSyntax + '(c.tbprt_gu = ' + "'"+"Y" + "'" + ') or'
		end if
	end if
		 
end if

ll_GetSqlSyntax = len(ls_GetSqlSyntax)
ls_GetSqlSyntax = mid(ls_GetSqlSyntax, 1, ll_GetSqlSyntax - 2)

//  brace를 하나 더 추가한다.
ls_GetSqlSyntax = ls_GetSqlSyntax + ')'	


dw_print.SetSqlSelect(ls_GetSqlSyntax)

dw_print.SetRedraw(false)
IF dw_print.Retrieve() < 1 THEN
	F_MessageChk(14, "")
   dw_print.SetRedraw(true)	
	Return -1
else 
	dw_print.SetFilter("dr_sum <> 0 or dr_jan <> 0 or cr_sum <> 0 or cr_jan <> 0")
	dw_print.Filter()
	
	setpointer(hourglass!)
	
		select sum(nvl(decode(f.dc_gu,'1',nvl(e.dr_sum,0) - nvl(e.cr_sum,0)),0)) as dr_jan,    
			    sum(nvl(e.dr_sum,0)) as dr_sum,	sum(nvl(d.dr_amt,0)) as dr_amt,   
				 sum(nvl(d.cr_amt,0)) as cr_amt,  	sum(nvl(e.cr_sum,0)) as cr_sum,       
				  sum(nvl(decode(f.dc_gu,'2',nvl(e.cr_sum,0) - nvl(e.dr_sum,0)),0)) as cr_jan    
			INTO :dr_zan_tot, :dr_sum_tot, :dr_mm_tot,     
			     :cr_mm_tot, :cr_sum_tot, :cr_zan_tot  
			from (select saupj, acc_yy, acc_mm, acc1_cd, acc2_cd, dr_amt, cr_amt
						from kfz14ot0
						where saupj = :ls_saupj and 
						      acc_yy = :ls_yy and 
								acc_mm = :ls_mm ) d,
				  (select saupj, acc1_cd, acc2_cd, 
							 sum(dr_amt) as dr_sum, sum(cr_amt) as cr_sum
						from kfz14ot0
						where saupj = :ls_saupj and 
						      acc_yy = :ls_yy and 
								acc_mm >= '00' and 
								acc_mm <= :ls_mm
						group by saupj, acc1_cd, acc2_cd) e,						
				  (select acc1_cd, acc2_cd, dc_gu, lev_gu, bal_gu, acc1_nm, acc2_nm, tbprt_gu
						from kfz01om0
						where  bal_gu <> '4' and
								acc1_cd||acc2_cd not in (select substr(dataname,1,7)
																	from syscnfg
																	where sysgu = 'A' and serial =93 and lineno <> '00') ) f						
			where (f.acc1_cd = e.acc1_cd) and
					(f.acc2_cd = e.acc2_cd) and		
					(e.saupj   = d.saupj(+))   and 
					(e.acc1_cd = d.acc1_cd(+)) and  
					(e.acc2_cd = d.acc2_cd(+)) ;

	if dw_print.RowCount() > 0  then	  
		dw_print.SetItem(dw_print.rowcount(),"cha_sumzan", dr_zan_tot)	// 차변 잔액 합계
		dw_print.SetItem(dw_print.rowcount(),"cha_sumnu", dr_sum_tot)    // 차변 누계 
		dw_print.SetItem(dw_print.rowcount(),"dea_sumzan", cr_zan_tot)   // 대변 잔액 합계
		dw_print.SetItem(dw_print.rowcount(),"dea_sumnu", cr_sum_tot)    // 대변 누계 
	end if
	
	dw_ip.SetFocus()
	
	setpointer(arrow!)
	
end if

dw_print.SetRedraw(true)	
dw_print.ShareData(dw_list)

return 1
end function

public function integer wf_retrieve_prt2 (string arg_saupj, string arg_yy, string arg_mm, string arg_saupj_nm);string ls_saupj, ls_yy, ls_mm, ls_ym_text, ls_saupj_nm, ls_GetSqlSyntax

//dec dr_zan_tot, dr_sum_tot, dr_mm_tot, &
//    cr_mm_tot, cr_sum_tot, cr_zan_tot

long ll_GetSqlSyntax

ls_saupj = arg_saupj        // 사업장
ls_yy = arg_yy              // 회계년도
ls_mm = arg_mm              // 회계월
ls_saupj_nm = arg_saupj_nm  // 사업장명 
ls_ym_text = ls_yy + '.'+ ls_mm

// 회계년월을 setting 한다.
dw_print.modify("ym.text ='"+ls_ym_text+"'")

//사업장명을 setting 한다.
dw_print.modify("saup.text ='"+ls_saupj_nm+"'")

// sql문
ls_GetSqlSyntax = 'select nvl(decode(c.dc_gu, ' + "'" + "1" + "'," + &
					 '          nvl(b.dr_sum,0) - nvl(b.cr_sum,0)),0) as dr_jan, ' + & 
                '        nvl(b.dr_sum,0) as dr_sum, ' + &
                '        nvl(a.dr_amt,0) as dr_amt, ' + &
                '        c.acc2_nm as acc2_nm, ' + &
					 '        c.acc1_cd, '  + &
					 '        c.acc2_cd, '  + &
                '        nvl(a.cr_amt,0) as cr_amt, '  + &
                '        nvl(b.cr_sum,0) as cr_sum, '  + &
                '        nvl(decode(c.dc_gu, ' + "'" + "2" + "'"+ ","   + &
					 '                   nvl(b.cr_sum,0) - nvl(b.dr_sum,0)), 0) as cr_jan, ' + &
                '        0 as cha_mtot, '  + &
                '        0 as cha_sumzan, ' +  &
                '        0 as cha_sumnu, '  + &
                '        0 as dea_mtot, '  + &
                '        0 as dea_sumzan, ' +  &
                '        0 as dea_sumnu, '  + &
					 '        c.bal_gu '  + &
                'from (select saupj, acc_yy, acc_mm, acc1_cd, acc2_cd, dr_amt, cr_amt '  + &
                '      from kfz14ot0   '  + &
                '       where saupj  = '  + "'" + ls_saupj + "'" + 'and   ' + &
					 '             acc_yy = ' + "'" + ls_yy + "'"  + ' and    '  + &
                '             acc_mm = ' + "'"+ ls_mm + "'" + ' ) a,    '  + &
                '      (select saupj, acc1_cd, acc2_cd, sum(dr_amt) as dr_sum,   '  + &
                '              sum(cr_amt) as cr_sum    '  + &
                '       from kfz14ot0     '  + &
                '       where  saupj  = '  + "'" + ls_saupj + "'" + 'and   ' + &
					 '              acc_yy =  ' + "'" + ls_yy + "'" + ' and  '  + &
                '              acc_mm >= ' + "'" + "00" + "'" + ' and   '  + &
                '              acc_mm <= ' + "'" + ls_mm + "'"  + &
                '       group by saupj, acc1_cd, acc2_cd) b,   '  +  &
                '       (select acc1_cd, acc2_cd, dc_gu, lev_gu, bal_gu,   '  + &
                '                acc1_nm, acc2_nm, tbprt_gu   '  + &
                '        from kfz01om0) c    '  + &
                'where (b.saupj   = a.saupj(+))   and   '  + &
                '      (b.acc1_cd = a.acc1_cd(+)) and   '  + &
                '      (b.acc2_cd = a.acc2_cd(+)) and   '  + &
                '      (b.acc1_cd = c.acc1_cd) and   '  + &
                '      (b.acc2_cd = c.acc2_cd)  and ('  

if cbx_1.checked=false and cbx_2.checked=false and cbx_3.checked=false and &
       cbx_4.checked=false and cbx_5.checked=false and cbx_6.checked=false then
	MessageBox("확 인", "출력항목은 반드시 하나 이상 ~r~r선택되어야 합니다.")
   return -1
else
	// 대분류 과목
	if cbx_1.checked then
		ls_GetSqlSyntax = ls_GetSqlSyntax + '(c.lev_gu = ' + "'"+"1" + "'" + ') or' 	
	end if
	
	//중분류 과목
	if cbx_2.checked then
		ls_GetSqlSyntax = ls_GetSqlSyntax + '(c.lev_gu = ' + "'"+"2" + "'" + ') or' 	
	end if
	
	//소분류 과목
	if cbx_3.checked then
		ls_GetSqlSyntax = ls_GetSqlSyntax + '(c.lev_gu = ' + "'"+"3" + "'" + ') or' 	
	end if
	
	//계정과목
	if cbx_4.checked then
		ls_GetSqlSyntax = ls_GetSqlSyntax + '(c.lev_gu = ' + "'"+"4" + "'" + ') or' 	
	end if
	
	//세분류과목
	if cbx_5.checked then
		if cbx_6.checked then	//출력유무
			ls_GetSqlSyntax = ls_GetSqlSyntax + '((c.lev_gu = ' + "'"+"5" + "'" + ') and (c.tbprt_gu = ' + "'"+"Y" + "'" + ')) or' 	
		else
			ls_GetSqlSyntax = ls_GetSqlSyntax + '(c.lev_gu = ' + "'"+"5" + "'" + ') or'
		end if
	else
		if cbx_6.checked then	//출력유무
			ls_GetSqlSyntax = ls_GetSqlSyntax + '(c.tbprt_gu = ' + "'"+"Y" + "'" + ') or'
		end if
	end if
end if

//  brace를 하나 더 추가한다.

ll_GetSqlSyntax = len(ls_GetSqlSyntax)
ls_GetSqlSyntax = mid(ls_GetSqlSyntax, 1, ll_GetSqlSyntax - 2)

ls_GetSqlSyntax = ls_GetSqlSyntax + ')'

//ls_GetSqlSyntax = ls_GetSqlSyntax + 'order by a.acc1_cd, a.acc2_cd, a.saupj' 

dw_print.SetSqlSelect(ls_GetSqlSyntax)

dw_print.SetRedraw(false)
IF dw_print.Retrieve() < 1 THEN
	F_MessageChk(14, "")
   dw_print.SetRedraw(true)	
	Return -1
else
	dw_print.SetFilter("dr_amt <> 0 or dr_sum <> 0 or dr_jan <> 0 or cr_amt <> 0 or cr_sum <> 0 or cr_jan <> 0")
	dw_print.Filter()
	
	setpointer(hourglass!)
	
		select sum(nvl(decode(f.dc_gu,'1',nvl(e.dr_sum,0) - nvl(e.cr_sum,0)),0)) as dr_jan,    
			    sum(nvl(e.dr_sum,0)) as dr_sum,	sum(nvl(d.dr_amt,0)) as dr_amt,   
				 sum(nvl(d.cr_amt,0)) as cr_amt,  	sum(nvl(e.cr_sum,0)) as cr_sum,       
				  sum(nvl(decode(f.dc_gu,'2',nvl(e.cr_sum,0) - nvl(e.dr_sum,0)),0)) as cr_jan    
			INTO :dr_zan_tot, :dr_sum_tot, :dr_mm_tot,     
			     :cr_mm_tot, :cr_sum_tot, :cr_zan_tot  
			from (select saupj, acc_yy, acc_mm, acc1_cd, acc2_cd, dr_amt, cr_amt
						from kfz14ot0
						where saupj = :ls_saupj and 
						      acc_yy = :ls_yy and 
								acc_mm = :ls_mm ) d,
				  (select saupj, acc1_cd, acc2_cd, 
							 sum(dr_amt) as dr_sum, sum(cr_amt) as cr_sum
						from kfz14ot0
						where saupj = :ls_saupj and 
						      acc_yy = :ls_yy and 
								acc_mm >= '00' and 
								acc_mm <= :ls_mm
						group by saupj, acc1_cd, acc2_cd) e,						
				  (select acc1_cd, acc2_cd, dc_gu, lev_gu, bal_gu, acc1_nm, acc2_nm, tbprt_gu
						from kfz01om0
						where  bal_gu <> '4' and
								acc1_cd||acc2_cd not in (select substr(dataname,1,7)
																	from syscnfg
																	where sysgu = 'A' and serial =93 and lineno <> '00') ) f						
			where (f.acc1_cd = e.acc1_cd) and
					(f.acc2_cd = e.acc2_cd) and		
					(e.saupj   = d.saupj(+))   and 
					(e.acc1_cd = d.acc1_cd(+)) and  
					(e.acc2_cd = d.acc2_cd(+)) ;
		
	if dw_print.RowCount() > 0  then	  
		dw_print.SetItem(dw_print.rowcount(),"cha_sumzan", dr_zan_tot)	// 차변 잔액 합계
		dw_print.SetItem(dw_print.rowcount(),"cha_sumnu", dr_sum_tot)    // 차변 누계 
		dw_print.SetItem(dw_print.rowcount(),"cha_mtot", dr_mm_tot)      // 차변 당월계
		dw_print.SetItem(dw_print.rowcount(),"dea_sumzan", cr_zan_tot)   // 대변 잔액 합계
		dw_print.SetItem(dw_print.rowcount(),"dea_sumnu", cr_sum_tot)    // 대변 누계 
		dw_print.SetItem(dw_print.rowcount(),"dea_mtot", cr_mm_tot)      // 대변 당월계
	end if
	
	dw_ip.SetFocus()
	
	setpointer(arrow!)
end if

dw_print.SetRedraw(true)	
dw_print.ShareData(dw_list)

return 1

end function

public function integer wf_retrieve_prt3 (string arg_saupj, string arg_yy, string arg_mm, string arg_saupj_nm);string ls_saupj, ls_yy, ls_mm, sBefMonth,ls_ym_text, ls_saupj_nm, ls_GetSqlSyntax

//dec dr_zan_tot, dr_sum_tot, dr_mm_tot, dr_pre_mm_tot, &
//    cr_pre_mm_tot, cr_mm_tot, cr_sum_tot, cr_zan_tot

long ll_GetSqlSyntax

ls_saupj = arg_saupj        // 사업장
ls_yy = arg_yy              // 회계년도
ls_mm = arg_mm              // 회계월
ls_saupj_nm = arg_saupj_nm  // 사업장명 
ls_ym_text = ls_yy + '.'+ ls_mm

IF ls_mm ='00' THEN										/*전월*/
	sBefMonth = '00'
ELSE
	sBefMonth = String(Integer(ls_mm) - 1,'00')
END IF

// 회계년월을 setting 한다.
dw_print.modify("ym.text ='"+ls_ym_text+"'")

//사업장명을 setting 한다.
dw_print.modify("saup.text ='"+ls_saupj_nm+"'")

// sql문
ls_GetSqlSyntax = 'select nvl(decode(c.dc_gu, ' + "'" + "1" + "'," + &
					 '          nvl(b.dr_sum,0) - nvl(b.cr_sum,0)),0) as dr_jan, ' + & 
                '        nvl(b.dr_sum,0) as dr_sum, ' + &
                '        nvl(a.dr_amt,0) as dr_amt, ' + &
                '        c.acc2_nm as acc2_nm, ' + &
					 '        c.acc1_cd, '  + &
					 '        c.acc2_cd, '  + &
                '        nvl(a.cr_amt,0) as cr_amt, '  + &
                '        nvl(b.cr_sum,0) as cr_sum, '  + &
                '        nvl(decode(c.dc_gu, ' + "'" + "2" + "'"+ ","   + &
					 '                   nvl(b.cr_sum,0) - nvl(b.dr_sum,0)), 0) as cr_jan, ' + &
                '        0 as cha_mtot, '  + &
                '        0 as cha_sumzan, ' +  &
                '        0 as cha_sumnu, '  + &
					 '        0 as cha_pre_mm_tot, ' + &  
                '        0 as dae_pre_mm_tot,  ' + &
                '        0 as dea_mtot, '  + &
                '        0 as dea_sumzan, ' +  &
                '        0 as dea_sumnu, '  + &
					 '        c.bal_gu '  + &
                'from (select saupj, acc_yy, acc_mm, acc1_cd, acc2_cd, dr_amt, cr_amt '  + &
                '      from kfz14ot0   '  + &
                '       where saupj  = '  + "'" + ls_saupj + "'" + 'and   ' + &
					 '             acc_yy = ' + "'" + ls_yy + "'"  + ' and    '  + &
                '             acc_mm = ' + "'"+ ls_mm + "'" + ' ) a,    '  + &
                '      (select saupj, acc1_cd, acc2_cd, sum(dr_amt) as dr_sum,   '  + &
                '              sum(cr_amt) as cr_sum    '  + &
                '       from kfz14ot0     '  + &
                '       where  saupj  = '  + "'" + ls_saupj + "'" + 'and   ' + &
					 '              acc_yy =  ' + "'" + ls_yy + "'" + ' and  '  + &
                '              acc_mm >= ' + "'" + "00" + "'" + ' and   '  + &
                '              acc_mm <= ' + "'" + ls_mm + "'"  + &
                '       group by saupj, acc1_cd, acc2_cd) b,   '  +  &
                '       (select acc1_cd, acc2_cd, dc_gu, lev_gu, bal_gu,   '  + &
                '                acc1_nm, acc2_nm, tbprt_gu   '  + &
                '        from kfz01om0) c    '  + &
                'where (b.saupj   = a.saupj(+))   and   '  + &
                '      (b.acc1_cd = a.acc1_cd(+)) and   '  + &
                '      (b.acc2_cd = a.acc2_cd(+)) and   '  + &
                '      (b.acc1_cd = c.acc1_cd) and   '  + &
                '      (b.acc2_cd = c.acc2_cd)  and ('  


if cbx_1.checked=false and cbx_2.checked=false and cbx_3.checked=false and &
       cbx_4.checked=false and cbx_5.checked=false and cbx_6.checked=false then
	MessageBox("확 인", "출력항목은 반드시 하나 이상 ~r~r선택되어야 합니다.")
   return -1
else
   // 대분류 과목
	if cbx_1.checked then
		ls_GetSqlSyntax = ls_GetSqlSyntax + '(c.lev_gu = ' + "'"+"1" + "'" + ') or' 	
	end if
	
	//중분류 과목
	if cbx_2.checked then
		ls_GetSqlSyntax = ls_GetSqlSyntax + '(c.lev_gu = ' + "'"+"2" + "'" + ') or' 	
	end if
	
	//소분류 과목
	if cbx_3.checked then
		ls_GetSqlSyntax = ls_GetSqlSyntax + '(c.lev_gu = ' + "'"+"3" + "'" + ') or' 	
	end if
	
	//계정과목
	if cbx_4.checked then
		ls_GetSqlSyntax = ls_GetSqlSyntax + '(c.lev_gu = ' + "'"+"4" + "'" + ') or' 	
	end if
	
	//세분류과목
	if cbx_5.checked then
		if cbx_6.checked then	//출력유무
			ls_GetSqlSyntax = ls_GetSqlSyntax + '((c.lev_gu = ' + "'"+"5" + "'" + ') and (c.tbprt_gu = ' + "'"+"Y" + "'" + ')) or' 	
		else
			ls_GetSqlSyntax = ls_GetSqlSyntax + '(c.lev_gu = ' + "'"+"5" + "'" + ') or'
		end if
	else
		if cbx_6.checked then	//출력유무
			ls_GetSqlSyntax = ls_GetSqlSyntax + '(c.tbprt_gu = ' + "'"+"Y" + "'" + ') or'
		end if
	end if
end if

//  brace를 하나 더 추가한다.

ll_GetSqlSyntax = len(ls_GetSqlSyntax)
ls_GetSqlSyntax = mid(ls_GetSqlSyntax, 1, ll_GetSqlSyntax - 2)

ls_GetSqlSyntax = ls_GetSqlSyntax + ')'

//ls_GetSqlSyntax = ls_GetSqlSyntax + 'order by a.acc1_cd, a.acc2_cd, a.saupj' 

dw_print.SetSqlSelect(ls_GetSqlSyntax)

dw_print.SetRedraw(false)
IF dw_print.Retrieve() < 1 THEN
	F_MessageChk(14, "")
   dw_print.SetRedraw(true)	
	Return -1
else 
	dw_print.SetFilter("dr_amt <> 0 or dr_sum <> 0 or dr_jan <> 0 or cr_amt <> 0 or cr_sum <> 0 or cr_jan <> 0")
	dw_print.Filter()
	
	setpointer(hourglass!)
	
		select sum(nvl(decode(f.dc_gu,'1',nvl(e.dr_sum,0) - nvl(e.cr_sum,0)),0)) as dr_jan,    
			    sum(nvl(e.dr_sum,0)) as dr_sum,
				 sum(nvl(e.cr_sum,0)) as cr_sum,       
				 sum(nvl(d.dr_amt,0)) as dr_amt,   
				 sum(nvl(d.cr_amt,0)) as cr_amt,
				 sum(nvl(c.dr_bef,0)) as dr_pre_mm_tot,   
				 sum(nvl(c.cr_bef,0)) as cr_pre_mm_tot,     	 			 
				 
				 sum(nvl(decode(f.dc_gu,'2',nvl(e.cr_sum,0) - nvl(e.dr_sum,0)),0)) as cr_jan    
			INTO :dr_zan_tot, 
				  :dr_sum_tot,
				  :cr_sum_tot,				  
				  :dr_mm_tot,
				  :cr_mm_tot,				  
				  :dr_pre_mm_tot,    
			     :cr_pre_mm_tot,
				  :cr_zan_tot  
			from  (select saupj,      acc_yy, acc1_cd,          acc2_cd, 
			              sum(nvl(dr_amt,0)) as dr_bef, sum(nvl(cr_amt,0)) as cr_bef
						from kfz14ot0
						where saupj = :ls_saupj and 
						      acc_yy = :ls_yy and 
								acc_mm <= :sBefMonth
					 group by saupj, acc_yy, acc1_cd, acc2_cd ) c,
					(select saupj, acc_yy, acc_mm, acc1_cd, acc2_cd, dr_amt, cr_amt
						from kfz14ot0
						where saupj = :ls_saupj and 
						      acc_yy = :ls_yy and 
								acc_mm = :ls_mm ) d,
				  (select saupj, acc1_cd, acc2_cd, 
							 sum(nvl(dr_amt,0)) as dr_sum, sum(nvl(cr_amt,0)) as cr_sum
						from kfz14ot0
						where saupj = :ls_saupj and 
						      acc_yy = :ls_yy and 
								acc_mm >= '00' and 
								acc_mm <= :ls_mm
						group by saupj, acc1_cd, acc2_cd) e,						
				  (select acc1_cd, acc2_cd, dc_gu, lev_gu, bal_gu, acc1_nm, acc2_nm, tbprt_gu
						from kfz01om0
						where  bal_gu <> '4' and
								acc1_cd||acc2_cd not in (select substr(dataname,1,7)
																	from syscnfg
																	where sysgu = 'A' and serial =93 and lineno <> '00') ) f						
			where (f.acc1_cd = e.acc1_cd) and
					(f.acc2_cd = e.acc2_cd) and		
					(e.saupj   = d.saupj(+))   and 
					(e.acc1_cd = d.acc1_cd(+)) and  
					(e.acc2_cd = d.acc2_cd(+)) ;
		
	if dw_print.RowCount() > 0  then	  
		dw_print.SetItem(dw_print.rowcount(),"cha_sumzan", dr_zan_tot)	// 차변 잔액 합계
		dw_print.SetItem(dw_print.rowcount(),"cha_sumnu", dr_sum_tot)    // 차변 누계 
		dw_print.SetItem(dw_print.rowcount(),"cha_mtot", dr_mm_tot)      // 차변 당월계
		dw_print.SetItem(dw_print.rowcount(),"cha_pre_mm_tot", dr_pre_mm_tot)	// 차변 전월계	
		dw_print.SetItem(dw_print.rowcount(),"dae_pre_mm_tot", cr_pre_mm_tot)	// 대변 전월계				
		dw_print.SetItem(dw_print.rowcount(),"dea_sumzan", cr_zan_tot)   // 대변 잔액 합계
		dw_print.SetItem(dw_print.rowcount(),"dea_sumnu", cr_sum_tot)    // 대변 누계 
		dw_print.SetItem(dw_print.rowcount(),"dea_mtot", cr_mm_tot)      // 대변 당월계
	end if
	
	dw_ip.SetFocus()
	
	setpointer(arrow!)
end if

dw_print.SetRedraw(true)	
dw_print.ShareData(dw_list)

return 1
end function

public function integer wf_retrieve_prt4 (string arg_saupj, string arg_yy, string arg_mm);string ls_saupj, ls_yy, ls_mm, ls_ym_text, ls_GetSqlSyntax

//dec dr_zan_tot, dr_sum_tot, dr_mm_tot, cr_mm_tot, cr_sum_tot, cr_zan_tot

long ll_GetSqlSyntax

ls_saupj = arg_saupj
ls_yy = arg_yy
ls_mm = arg_mm

ls_ym_text = ls_yy + '.'+ ls_mm

dw_print.modify("ym.text ='"+ls_ym_text+"'")

// sql문
ls_GetSqlSyntax = ' select a.saupj, '  +  &
                '        a.acc1_cd, a.acc2_cd,  ' + &  
                '        nvl(decode(c.dc_gu, ' + "'" + "1" + "'," + &
					 '                   nvl(b.dr_sum,0) - nvl(b.cr_sum,0)),0) as dr_jan, ' + & 
                '        nvl(b.dr_sum,0) as dr_sum, ' + &
                '        nvl(a.dr_amt,0) as dr_amt, ' + &
                '        c.acc2_nm as acc2_nm, ' + &
					 '        c.acc1_cd, '  + &
					 '        c.acc2_cd, '  + &
                '        nvl(a.cr_amt,0) as cr_amt, '  + &
                '        nvl(b.cr_sum,0) as cr_sum, '  + &
                '        nvl(decode(c.dc_gu, ' + "'" + "2" + "'"+ ","   + &
					 '                   nvl(b.cr_sum,0) - nvl(b.dr_sum,0)), 0) as cr_jan, ' + &
                '        0 as cha_mtot, '  + &
                '        0 as cha_sumzan, ' +  &
                '        0 as cha_sumnu, '  + &
                '        0 as dea_mtot, '  + &
                '        0 as dea_sumzan, ' +  &
                '        0 as dea_sumnu, '  + &
					 '        c.bal_gu '  + &
                'from (select saupj, acc_yy, acc_mm, acc1_cd, acc2_cd, dr_amt, cr_amt '  + &
                '      from kfz14ot0   '  + &
                '      where  saupj  <> ' +"'" + "99" + "'" + ' and   '  + &
					 '             acc_yy = ' + "'" + ls_yy + "'"  + ' and    '  + &
                '             acc_mm = ' + "'"+ ls_mm + "'" + ' ) a,    '  + &
                '      (select saupj, acc1_cd, acc2_cd, sum(dr_amt) as dr_sum,   '  + &
                '              sum(cr_amt) as cr_sum    '  + &
                '       from kfz14ot0     '  + &
                '       where  saupj  <> ' +"'" + "99" + "'" + ' and   '  + &
					 '              acc_yy =  ' + "'" + ls_yy + "'" + ' and  '  + &
                '              acc_mm >= ' + "'" + "00" + "'" + ' and   '  + &
                '              acc_mm <= ' + "'" + ls_mm + "'"  + &
                '       group by saupj, acc1_cd, acc2_cd) b,   '  +  &
                '       (select acc1_cd, acc2_cd, dc_gu, lev_gu, bal_gu,   '  + &
                '                acc1_nm, acc2_nm, tbprt_gu   '  + &
                '        from kfz01om0) c    '  + &
                'where (b.saupj   = a.saupj(+))   and   '  + &
                '      (b.acc1_cd = a.acc1_cd(+)) and   '  + &
                '      (b.acc2_cd = a.acc2_cd(+)) and   '  + &
                '      (b.acc1_cd = c.acc1_cd) and   '  + &
                '      (b.acc2_cd = c.acc2_cd)  and ('  

if cbx_1.checked=false and cbx_2.checked=false and cbx_3.checked=false and &
       cbx_4.checked=false and cbx_5.checked=false and cbx_6.checked=false then
	MessageBox("확 인", "출력항목은 반드시 하나 이상 ~r~r선택되어야 합니다.")
   return -1
else

	// 대분류 과목
	if cbx_1.checked then
		ls_GetSqlSyntax = ls_GetSqlSyntax + '(c.lev_gu = ' + "'"+"1" + "'" + ') or' 	
	end if
	
	//중분류 과목
	if cbx_2.checked then
		ls_GetSqlSyntax = ls_GetSqlSyntax + '(c.lev_gu = ' + "'"+"2" + "'" + ') or' 	
	end if
	
	//소분류 과목
	if cbx_3.checked then
		ls_GetSqlSyntax = ls_GetSqlSyntax + '(c.lev_gu = ' + "'"+"3" + "'" + ') or' 	
	end if
	
	//계정과목
	if cbx_4.checked then
		ls_GetSqlSyntax = ls_GetSqlSyntax + '(c.lev_gu = ' + "'"+"4" + "'" + ') or' 	
	end if
	
	//세분류과목
	if cbx_5.checked then
		if cbx_6.checked then	//출력유무
			ls_GetSqlSyntax = ls_GetSqlSyntax + '((c.lev_gu = ' + "'"+"5" + "'" + ') and (c.tbprt_gu = ' + "'"+"Y" + "'" + ')) or' 	
		else
			ls_GetSqlSyntax = ls_GetSqlSyntax + '(c.lev_gu = ' + "'"+"5" + "'" + ') or'
		end if
	else
		if cbx_6.checked then	//출력유무
			ls_GetSqlSyntax = ls_GetSqlSyntax + '(c.tbprt_gu = ' + "'"+"Y" + "'" + ') or'
		end if
	end if
end if

//  brace를 하나 더 추가한다.

ll_GetSqlSyntax = len(ls_GetSqlSyntax)
ls_GetSqlSyntax = mid(ls_GetSqlSyntax, 1, ll_GetSqlSyntax - 2)

ls_GetSqlSyntax = ls_GetSqlSyntax + ')'

ls_GetSqlSyntax = ls_GetSqlSyntax + 'order by a.acc1_cd, a.acc2_cd, a.saupj' 

dw_print.SetSqlSelect(ls_GetSqlSyntax)

dw_print.SetRedraw(false)
IF dw_print.Retrieve() < 1 THEN
	F_MessageChk(14, "")
   dw_print.SetRedraw(true)	
	Return -1
else
	dw_print.SetFilter("dr_amt <> 0 or dr_sum <> 0 or dr_jan <> 0 or cr_amt <> 0 or cr_sum <> 0 or cr_jan <> 0")
	dw_print.Filter()
	
	setpointer(hourglass!)  
	
 	 select sum(nvl(decode(f.dc_gu,'1',nvl(e.dr_sum,0) - nvl(e.cr_sum,0)),0)) as dr_jan,
			  sum(nvl(e.dr_sum,0)) as dr_sum,	sum(nvl(d.dr_amt,0)) as dr_amt, 
			  sum(nvl(d.cr_amt,0)) as cr_amt,  	sum(nvl(e.cr_sum,0)) as cr_sum,
			  sum(nvl(decode(f.dc_gu,'2',nvl(e.cr_sum,0) - nvl(e.dr_sum,0)),0)) as cr_jan  
		INTO :dr_zan_tot, :dr_sum_tot, :dr_mm_tot, :cr_mm_tot, :cr_sum_tot, :cr_zan_tot
		from (select saupj, acc_yy, acc_mm, acc1_cd, acc2_cd, dr_amt, cr_amt
				from kfz14ot0
				where saupj >= '10' and
				      saupj <= '98' and
				      acc_yy = :ls_yy and 
				      acc_mm = :ls_mm ) d,
			  (select saupj, acc1_cd, acc2_cd, 
						 sum(dr_amt) as dr_sum, sum(cr_amt) as cr_sum
				from kfz14ot0
				where saupj >= '10' and
				      saupj <= '98' and
				      acc_yy = :ls_yy and 
				      acc_mm >= '00' and 
						acc_mm <= :ls_mm
				group by saupj, acc1_cd, acc2_cd) e,						
				  (select acc1_cd, acc2_cd, dc_gu, lev_gu, bal_gu, acc1_nm, acc2_nm, tbprt_gu
						from kfz01om0
						where bal_gu <> '4' and
								acc1_cd||acc2_cd not in (select substr(dataname,1,7)
																	from syscnfg
																	where sysgu = 'A' and serial =93 and lineno <> '00') ) f						
			where (f.acc1_cd = e.acc1_cd) and
					(f.acc2_cd = e.acc2_cd) and		
					(e.saupj   = d.saupj(+))   and 
					(e.acc1_cd = d.acc1_cd(+)) and  
					(e.acc2_cd = d.acc2_cd(+)) ;
		
	if dw_print.RowCount() > 0  then	  
		dw_print.SetItem(dw_print.rowcount(),"cha_sumzan", dr_zan_tot)	
		dw_print.SetItem(dw_print.rowcount(),"cha_sumnu", dr_sum_tot)
		dw_print.SetItem(dw_print.rowcount(),"cha_mtot", dr_mm_tot)
		dw_print.SetItem(dw_print.rowcount(),"dea_sumzan", cr_zan_tot)
		dw_print.SetItem(dw_print.rowcount(),"dea_sumnu", cr_sum_tot)
		dw_print.SetItem(dw_print.rowcount(),"dea_mtot", cr_mm_tot)
	end if
	
	dw_ip.SetFocus()
	
	setpointer(arrow!)
end if

dw_print.SetRedraw(true)	
dw_print.ShareData(dw_list)

return 1
end function

on w_kgld03.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.st_2=create st_2
this.cbx_1=create cbx_1
this.cbx_2=create cbx_2
this.cbx_3=create cbx_3
this.cbx_4=create cbx_4
this.cbx_5=create cbx_5
this.cbx_6=create cbx_6
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.rb_3
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.cbx_1
this.Control[iCurrent+6]=this.cbx_2
this.Control[iCurrent+7]=this.cbx_3
this.Control[iCurrent+8]=this.cbx_4
this.Control[iCurrent+9]=this.cbx_5
this.Control[iCurrent+10]=this.cbx_6
this.Control[iCurrent+11]=this.rr_1
this.Control[iCurrent+12]=this.rr_2
this.Control[iCurrent+13]=this.rr_3
end on

on w_kgld03.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.st_2)
destroy(this.cbx_1)
destroy(this.cbx_2)
destroy(this.cbx_3)
destroy(this.cbx_4)
destroy(this.cbx_5)
destroy(this.cbx_6)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
end on

event open;call super::open;String sYearMonth,sStart,sEnd,snull

sYearMonth = Left(f_today(),6)
dw_ip.SetItem(1,"acc_ym",sYearMonth)

dw_ip.SetItem(1,"saupj", gs_saupj)

rb_1.Checked =True
cbx_1.Checked = true
rb_1.TriggerEvent(Clicked!)


end event

type p_xls from w_standard_print`p_xls within w_kgld03
end type

type p_sort from w_standard_print`p_sort within w_kgld03
end type

type p_preview from w_standard_print`p_preview within w_kgld03
integer y = 12
integer taborder = 30
end type

type p_exit from w_standard_print`p_exit within w_kgld03
integer y = 12
integer taborder = 50
end type

type p_print from w_standard_print`p_print within w_kgld03
integer y = 12
integer taborder = 40
end type

type p_retrieve from w_standard_print`p_retrieve within w_kgld03
integer y = 12
end type







type st_10 from w_standard_print`st_10 within w_kgld03
end type



type dw_print from w_standard_print`dw_print within w_kgld03
integer x = 3438
string dataobject = "dw_kgld032_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kgld03
integer x = 59
integer width = 1778
integer height = 144
string dataobject = "dw_kgld031"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;
String  sSaupj,sYearMonth,sStart,sEnd,snull
Integer iCurRow

SetNull(snull)

iCurRow = this.GetRow()
IF this.GetColumnName() = "saupj" THEN
	sSaupj = this.GetText()
	IF sSaupj = "" OR IsNull(sSaupj) THEN RETURN
	
	IF IsNull(F_Get_Refferance('AD',sSaupj)) THEN
		F_MessageChk(20,'[사업장]')
		this.SetItem(iCurRow,"saupj",sNull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "acc_ym" THEN
	sYearMonth = Trim(this.GetText())
//	IF sYearMonth = "" OR IsNull(sYearMonth) THEN
//		this.SetItem(iCurRow,"k_symd",snull)
//		this.SetItem(iCurRow,"k_eymd",snull)
//		Return 
//	END IF
	
//	IF Right(sYearMonth,2) <> '00' THEN
//		SELECT "KFZ03OT0"."CALDATEF",   "KFZ03OT0"."CALDATET"  
//			INTO :sStart,   				  :sEnd  
//			FROM "KFZ03OT0"  
//			WHERE "KFZ03OT0"."CALYM" = :sYearMonth   ;
//		IF SQLCA.SQLCODE <> 0 THEN
//			F_MessageChk(54,'')
//			this.SetItem(iCurRow,"acc_ym",snull)
//			this.SetItem(iCurRow,"k_symd",snull)
//			this.SetItem(iCurRow,"k_eymd",snull)
//			Return 1
//		ELSE
//			this.SetItem(iCurRow,"k_symd",sStart)
//			this.SetItem(iCurRow,"k_eymd",sEnd)
//		END IF
//	ELSE
//		this.SetItem(iCurRow,"k_symd",snull)
//		this.SetItem(iCurRow,"k_eymd",snull)
//	END IF
END IF

end event

event dw_ip::getfocus;this.AcceptText()
end event

type dw_list from w_standard_print`dw_list within w_kgld03
integer x = 73
integer y = 324
integer width = 4517
integer height = 1876
string title = "합계잔액시산표"
string dataobject = "dw_kgld032"
boolean border = false
end type

event dw_list::retrieverow;call super::retrieverow;if rb_1.checked = true then 
	
 	if dw_print.RowCount() > 0  then	  
		dw_print.SetItem(row,"cha_sumzan", dr_zan_tot)	// 차변 잔액 합계
		dw_print.SetItem(row,"cha_sumnu", dr_sum_tot)    // 차변 누계 
		dw_print.SetItem(row,"dea_sumzan", cr_zan_tot)   // 대변 잔액 합계
		dw_print.SetItem(row,"dea_sumnu", cr_sum_tot)    // 대변 누계 
	end if
	
	dw_ip.SetFocus()

elseif rb_2.checked then 
// 합계잔액 월계시산표 
	if dw_print.RowCount() > 0  then	  
		dw_print.SetItem(row,"cha_sumzan", dr_zan_tot)	// 차변 잔액 합계
		dw_print.SetItem(row,"cha_sumnu", dr_sum_tot)    // 차변 누계 
		dw_print.SetItem(row,"cha_mtot", dr_mm_tot)      // 차변 당월계
		dw_print.SetItem(row,"dea_sumzan", cr_zan_tot)   // 대변 잔액 합계
		dw_print.SetItem(row,"dea_sumnu", cr_sum_tot)    // 대변 누계 
		dw_print.SetItem(row,"dea_mtot", cr_mm_tot)      // 대변 당월계
	end if
	
	dw_ip.SetFocus()

elseif rb_3.checked = true then 
	// 합계잔액 월계 비교시산표
	if dw_print.RowCount() > 0  then	  
		dw_print.SetItem(row,"cha_sumzan", dr_zan_tot)	// 차변 잔액 합계
		dw_print.SetItem(row,"cha_sumnu", dr_sum_tot)    // 차변 누계 
		dw_print.SetItem(row,"cha_mtot", dr_mm_tot)      // 차변 당월계
		dw_print.SetItem(row,"cha_pre_mm_tot", dr_pre_mm_tot)	// 차변 전월계	
		dw_print.SetItem(row,"dae_pre_mm_tot", cr_pre_mm_tot)	// 대변 전월계				
		dw_print.SetItem(row,"dea_sumzan", cr_zan_tot)   // 대변 잔액 합계
		dw_print.SetItem(row,"dea_sumnu", cr_sum_tot)    // 대변 누계 
		dw_print.SetItem(row,"dea_mtot", cr_mm_tot)      // 대변 당월계
	end if
	
	dw_ip.SetFocus()

//elseif rb_4.checked = true then 
//	// 사업장별 합계잔액 월계시산표
//		
//	if dw_print.RowCount() > 0  then	  
//		dw_print.SetItem(row,"cha_sumzan", dr_zan_tot)	
//		dw_print.SetItem(row,"cha_sumnu", dr_sum_tot)
//		dw_print.SetItem(row,"cha_mtot", dr_mm_tot)
//		dw_print.SetItem(row,"dea_sumzan", cr_zan_tot)
//		dw_print.SetItem(row,"dea_sumnu", cr_sum_tot)
//		dw_print.SetItem(row,"dea_mtot", cr_mm_tot)
//	end if
//	
//	dw_ip.SetFocus()

end if
end event

type rb_1 from radiobutton within w_kgld03
integer x = 2889
integer y = 196
integer width = 517
integer height = 92
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "합계잔액시산표"
boolean checked = true
end type

event clicked;
dw_list.SetRedraw(False)
IF rb_1.Checked =True THEN
	
	dw_list.dataObject='dw_kgld032'
	dw_print.dataObject='dw_kgld032_p'
	
END IF
dw_list.title ="합계잔액 시산표"
sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 세로방향"

dw_list.SetRedraw(True)

dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)


end event

type rb_2 from radiobutton within w_kgld03
integer x = 3401
integer y = 196
integer width = 626
integer height = 92
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "합계잔액월계시산표"
end type

event clicked;
dw_list.SetRedraw(False)
IF rb_2.Checked =True THEN
	
	dw_list.dataObject='dw_kgld033'
	dw_print.dataObject='dw_kgld033_p'
	
END IF
dw_list.title ="합계잔액월계 시산표"
sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 세로방향"

dw_list.SetRedraw(True)

dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

end event

type rb_3 from radiobutton within w_kgld03
integer x = 4055
integer y = 196
integer width = 544
integer height = 92
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "월계 비교시산표"
end type

event clicked;
dw_list.SetRedraw(False)
IF rb_3.Checked =True THEN
	
	dw_list.dataObject='dw_kgld034'
	dw_print.dataObject='dw_kgld034_p'

END IF
dw_list.title ="합계잔액월계 비교시산표"
sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 가로방향"

dw_list.SetRedraw(True)

dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)


end event

type st_2 from statictext within w_kgld03
integer x = 73
integer y = 204
integer width = 256
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean enabled = false
string text = "출력항목"
alignment alignment = center!
boolean focusrectangle = false
end type

type cbx_1 from checkbox within w_kgld03
integer x = 325
integer y = 196
integer width = 430
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "대분류 과목"
boolean checked = true
end type

type cbx_2 from checkbox within w_kgld03
integer x = 754
integer y = 196
integer width = 430
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "중분류 과목"
end type

type cbx_3 from checkbox within w_kgld03
integer x = 1184
integer y = 196
integer width = 430
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "소분류 과목"
end type

type cbx_4 from checkbox within w_kgld03
integer x = 1614
integer y = 196
integer width = 366
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "계정 과목"
end type

type cbx_5 from checkbox within w_kgld03
integer x = 1961
integer y = 196
integer width = 430
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "세분류 과목"
end type

type cbx_6 from checkbox within w_kgld03
integer x = 2405
integer y = 196
integer width = 320
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "출력유무"
end type

type rr_1 from roundrectangle within w_kgld03
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2843
integer y = 176
integer width = 1769
integer height = 124
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_kgld03
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 64
integer y = 316
integer width = 4539
integer height = 1900
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_kgld03
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 64
integer y = 172
integer width = 2674
integer height = 128
integer cornerheight = 40
integer cornerwidth = 55
end type

