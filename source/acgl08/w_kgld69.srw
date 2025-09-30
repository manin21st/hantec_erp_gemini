$PBExportHeader$w_kgld69.srw
$PBExportComments$합계잔액시산표 상세 조회
forward
global type w_kgld69 from w_standard_print
end type
type cbx_1 from checkbox within w_kgld69
end type
type cbx_2 from checkbox within w_kgld69
end type
type cbx_3 from checkbox within w_kgld69
end type
type cbx_4 from checkbox within w_kgld69
end type
type cbx_5 from checkbox within w_kgld69
end type
type cbx_6 from checkbox within w_kgld69
end type
type st_1 from statictext within w_kgld69
end type
type rr_2 from roundrectangle within w_kgld69
end type
type rr_1 from roundrectangle within w_kgld69
end type
end forward

global type w_kgld69 from w_standard_print
integer x = 0
integer y = 0
string title = "합계잔액시산표 상세 조회"
cbx_1 cbx_1
cbx_2 cbx_2
cbx_3 cbx_3
cbx_4 cbx_4
cbx_5 cbx_5
cbx_6 cbx_6
st_1 st_1
rr_2 rr_2
rr_1 rr_1
end type
global w_kgld69 w_kgld69

forward prototypes
public function integer wf_retrieve ()
public function integer wf_retrieve_data (string arg_saupj, string arg_yy, string arg_mm)
end prototypes

public function integer wf_retrieve ();String sSaupj, sYearMonth, get_code, get_name
string snull, ls_yy, ls_mm

SetNull(snull)

if dw_ip.AcceptText() = -1 then return -1

sSaupj     = dw_ip.GetItemString(dw_ip.GetRow(),"saupj")
sYearMonth = Trim(dw_ip.GetItemString(dw_ip.GetRow(),"acc_ym"))

if sSaupj = '' or isnull(sSaupj) then 
	F_MessageChk(1, "[사업장]")
	dw_ip.SetColumn("saupj")
	dw_ip.SetFocus()
	return -1
End if

SELECT "REFFPF"."RFGUB", "REFFPF"."RFNA1"  
	INTO :get_code, :get_name
	FROM "REFFPF"  
	WHERE "REFFPF"."RFCOD" = 'AD'   AND "REFFPF"."RFGUB" = :ssaupj ;
if sqlca.sqlcode <> 0 then 
	MessageBox("확 인", "사업장 코드를 확인하십시오.!!")
	dw_ip.SetItem(dw_ip.getrow(), 'saupj', snull)
	return -1
end if

if trim(sYearMonth) = "" or isnull(sYearMonth) then
	f_messagechk(1,"[회계년월]") 
	dw_ip.SetColumn("acc_ym")
	dw_ip.SetFocus()
	return -1
else
	IF Mid(sYearMonth,5,2) <> '00' THEN
		if f_datechk(sYearMonth+'01') = -1 then 
			F_Messagechk(21,"[회계년월]")
			dw_ip.SetColumn("acc_ym")
			dw_ip.SetFocus()
			return -1
		end if
	END IF
end if 

ls_yy = left(sYearMonth, 4)
ls_mm = right(sYearMonth,2)

dw_print.object.ym.text = string(ls_yy + ls_mm, '@@@@.@@')
dw_print.object.saup.text = get_name

if wf_retrieve_data(sSaupj, ls_yy, ls_mm) = -1 then return -1

Return 1

end function

public function integer wf_retrieve_data (string arg_saupj, string arg_yy, string arg_mm);string ls_GetSqlSyntax

dec dr_zan_tot, dr_sum_tot, dr_mm_tot, &
    cr_mm_tot, cr_sum_tot, cr_zan_tot

long ll_GetSqlSyntax

ls_GetSqlSyntax = 'select nvl(decode(c.dc_gu, ' + "'" + "1" + "'," + &
					 '          nvl(b.dr_sum,0) - nvl(b.cr_sum,0)),0) as dr_jan, ' + & 
                '        nvl(b.dr_sum,0) as dr_sum, ' + &
                '        nvl(a.dr_amt,0) as dr_amt, ' + &
                '        c.acc2_nm as acc2_nm, ' + &
					 '        c.acc1_cd, '  + &
					 '        c.acc2_cd, '  + &
					 '        c.lev_gu, '   + &
					 '        c.bal_gu, '   + &
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
					 '        c.bal_gu ' + &
                'from (select saupj, acc_yy, acc_mm, acc1_cd, acc2_cd, dr_amt, cr_amt '  + &
                '      from kfz14ot0   '  + &
                '       where saupj  = '  + "'" + Arg_Saupj + "'" + 'and   ' + &
					 '             acc_yy = ' + "'" + Arg_Yy + "'"  + ' and    '  + &
                '             acc_mm = ' + "'"+ Arg_Mm + "'" + ' ) a,    '  + &
                '      (select saupj, acc1_cd, acc2_cd, sum(dr_amt) as dr_sum,   '  + &
                '              sum(cr_amt) as cr_sum    '  + &
                '       from kfz14ot0     '  + &
                '       where  saupj  = '  + "'" + Arg_Saupj + "'" + 'and   ' + &
					 '              acc_yy =  ' + "'" + Arg_Yy + "'" + ' and  '  + &
                '              acc_mm >= ' + "'" + "00" + "'" + ' and   '  + &
                '              acc_mm <= ' + "'" + Arg_Mm + "'"  + &
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

dw_list.SetSqlSelect(ls_GetSqlSyntax)

dw_list.SetRedraw(false)
IF dw_list.Retrieve() < 1 THEN
	F_MessageChk(14, "")
   dw_list.SetRedraw(true)	
	Return -1
else
	dw_list.SetFilter("dr_amt <> 0 or dr_sum <> 0 or dr_jan <> 0 or cr_amt <> 0 or cr_sum <> 0 or cr_jan <> 0")
	dw_list.Filter()
	
	dw_list.SetSort('acc1_cd a, acc2_cd a')
	dw_list.Sort()
	
	setpointer(hourglass!)
	
		select sum(nvl(decode(f.dc_gu,'1',nvl(e.dr_sum,0) - nvl(e.cr_sum,0)),0)) as dr_jan,    
			    sum(nvl(e.dr_sum,0)) as dr_sum,	sum(nvl(d.dr_amt,0)) as dr_amt,   
				 sum(nvl(d.cr_amt,0)) as cr_amt,  	sum(nvl(e.cr_sum,0)) as cr_sum,       
				  sum(nvl(decode(f.dc_gu,'2',nvl(e.cr_sum,0) - nvl(e.dr_sum,0)),0)) as cr_jan    
			INTO :dr_zan_tot, :dr_sum_tot, :dr_mm_tot,     
			     :cr_mm_tot, :cr_sum_tot, :cr_zan_tot  
			from (select saupj, acc_yy, acc_mm, acc1_cd, acc2_cd, dr_amt, cr_amt
						from kfz14ot0
						where saupj = :Arg_Saupj and 
						      acc_yy = :Arg_Yy and 
								acc_mm = :Arg_Mm ) d,
				  (select saupj, acc1_cd, acc2_cd, 
							 sum(dr_amt) as dr_sum, sum(cr_amt) as cr_sum
						from kfz14ot0
						where saupj = :Arg_Saupj and 
						      acc_yy = :Arg_Yy and 
								acc_mm >= '00' and 
								acc_mm <= :Arg_Mm
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
		
	if dw_list.RowCount() > 0  then	  
		dw_list.SetItem(dw_list.rowcount(),"cha_sumzan", dr_zan_tot)	// 차변 잔액 합계
		dw_list.SetItem(dw_list.rowcount(),"cha_sumnu", dr_sum_tot)    // 차변 누계 
		dw_list.SetItem(dw_list.rowcount(),"cha_mtot", dr_mm_tot)      // 차변 당월계
		dw_list.SetItem(dw_list.rowcount(),"dea_sumzan", cr_zan_tot)   // 대변 잔액 합계
		dw_list.SetItem(dw_list.rowcount(),"dea_sumnu", cr_sum_tot)    // 대변 누계 
		dw_list.SetItem(dw_list.rowcount(),"dea_mtot", cr_mm_tot)      // 대변 당월계
	end if
	dw_ip.SetFocus()
	
	setpointer(arrow!)
end if

dw_list.SetRedraw(true)	
dw_list.ShareData(dw_print)

return 1
end function

on w_kgld69.create
int iCurrent
call super::create
this.cbx_1=create cbx_1
this.cbx_2=create cbx_2
this.cbx_3=create cbx_3
this.cbx_4=create cbx_4
this.cbx_5=create cbx_5
this.cbx_6=create cbx_6
this.st_1=create st_1
this.rr_2=create rr_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_1
this.Control[iCurrent+2]=this.cbx_2
this.Control[iCurrent+3]=this.cbx_3
this.Control[iCurrent+4]=this.cbx_4
this.Control[iCurrent+5]=this.cbx_5
this.Control[iCurrent+6]=this.cbx_6
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.rr_2
this.Control[iCurrent+9]=this.rr_1
end on

on w_kgld69.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_1)
destroy(this.cbx_2)
destroy(this.cbx_3)
destroy(this.cbx_4)
destroy(this.cbx_5)
destroy(this.cbx_6)
destroy(this.st_1)
destroy(this.rr_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetItem(1,"acc_ym",Left(f_today(),6))
dw_ip.SetItem(1,"saupj", gs_saupj)

cbx_1.Checked = true
end event

type p_preview from w_standard_print`p_preview within w_kgld69
integer x = 4101
integer y = 28
string pointer = ""
boolean enabled = true
end type

type p_exit from w_standard_print`p_exit within w_kgld69
integer x = 4439
integer y = 28
string pointer = ""
end type

type p_print from w_standard_print`p_print within w_kgld69
integer x = 4274
integer y = 28
string pointer = ""
boolean enabled = true
end type

type p_retrieve from w_standard_print`p_retrieve within w_kgld69
integer x = 3927
integer y = 28
string pointer = ""
end type







type st_10 from w_standard_print`st_10 within w_kgld69
end type



type dw_print from w_standard_print`dw_print within w_kgld69
integer x = 3739
integer y = 40
string dataobject = "dw_kgld692_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kgld69
integer y = 8
integer width = 1833
integer height = 128
string dataobject = "dw_kgld691"
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

end event

event dw_ip::getfocus;this.AcceptText()
end event

type dw_list from w_standard_print`dw_list within w_kgld69
integer x = 59
integer y = 276
integer width = 4535
integer height = 2008
string dataobject = "dw_kgld692"
boolean hscrollbar = false
boolean border = false
boolean hsplitscroll = false
end type

event dw_list::itemerror;call super::itemerror;Return 1
end event

event dw_list::buttonclicked;String sAcc1,sAcc2,sGbn6

this.AcceptText()
sAcc1 = this.GetItemString(this.GetRow(),"acc1_cd")
sAcc2 = this.GetItemString(this.GetRow(),"acc2_cd")
	
select gbn6 into :sGbn6	from kfz01om0
	where acc1_cd = :sAcc1 and acc2_cd = :sAcc2;
if sqlca.sqlcode = 0 then
	if IsNull(sGbn6) then sGbn6 = 'N'
else
	sGbn6 = 'N'
end if

Gs_Gubun = dw_ip.GetItemString(1,"saupj")
IF dwo.name = 'dcb_remain' THEN										/*잔액 조회*/
	if sGbn6 = 'Y' then
		OpenWithParm(w_kgld69a,dw_ip.GetItemString(1,"acc_ym") + &
									  sAcc1+sAcc2)
	end if
END IF

IF dwo.name = 'dcb_report' THEN										/*장부 조회*/
	OpenWithParm(w_kgld69b,dw_ip.GetItemString(1,"acc_ym") + &
									  sAcc1+sAcc2)
END IF

end event

type cbx_1 from checkbox within w_kgld69
integer x = 361
integer y = 156
integer width = 398
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
end type

type cbx_2 from checkbox within w_kgld69
integer x = 786
integer y = 156
integer width = 398
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

type cbx_3 from checkbox within w_kgld69
integer x = 1193
integer y = 156
integer width = 407
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

type cbx_4 from checkbox within w_kgld69
integer x = 1609
integer y = 156
integer width = 398
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
boolean checked = true
end type

type cbx_5 from checkbox within w_kgld69
integer x = 2034
integer y = 156
integer width = 398
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
boolean checked = true
end type

type cbx_6 from checkbox within w_kgld69
integer x = 2441
integer y = 156
integer width = 407
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

type st_1 from statictext within w_kgld69
integer x = 96
integer y = 172
integer width = 256
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 28144969
long backcolor = 32106727
string text = "출력항목"
boolean focusrectangle = false
end type

type rr_2 from roundrectangle within w_kgld69
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 55
integer y = 268
integer width = 4567
integer height = 2020
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within w_kgld69
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 55
integer y = 140
integer width = 2839
integer height = 116
integer cornerheight = 40
integer cornerwidth = 55
end type

