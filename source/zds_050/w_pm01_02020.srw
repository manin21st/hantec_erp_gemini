$PBExportHeader$w_pm01_02020.srw
$PBExportComments$주간 생산능력 검토
forward
global type w_pm01_02020 from w_inherite
end type
type dw_1 from u_key_enter within w_pm01_02020
end type
type dw_3 from datawindow within w_pm01_02020
end type
type st_kun from statichyperlink within w_pm01_02020
end type
type st_hu from statichyperlink within w_pm01_02020
end type
type rr_1 from roundrectangle within w_pm01_02020
end type
type rr_2 from roundrectangle within w_pm01_02020
end type
type rr_3 from roundrectangle within w_pm01_02020
end type
type st_2 from statictext within w_pm01_02020
end type
type cb_1 from commandbutton within w_pm01_02020
end type
type dw_change from u_key_enter within w_pm01_02020
end type
type cb_2 from commandbutton within w_pm01_02020
end type
type ole_chart from uo_chartfx_ie4 within w_pm01_02020
end type
type rb_1 from radiobutton within w_pm01_02020
end type
type rb_2 from radiobutton within w_pm01_02020
end type
type pb_1 from u_pb_cal within w_pm01_02020
end type
type dw_4 from datawindow within w_pm01_02020
end type
type st_3 from statictext within w_pm01_02020
end type
type p_1 from picture within w_pm01_02020
end type
type dw_print from datawindow within w_pm01_02020
end type
type rr_4 from roundrectangle within w_pm01_02020
end type
end forward

global type w_pm01_02020 from w_inherite
integer width = 4631
integer height = 3308
string title = "주간 생산능력 검토"
dw_1 dw_1
dw_3 dw_3
st_kun st_kun
st_hu st_hu
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
st_2 st_2
cb_1 cb_1
dw_change dw_change
cb_2 cb_2
ole_chart ole_chart
rb_1 rb_1
rb_2 rb_2
pb_1 pb_1
dw_4 dw_4
st_3 st_3
p_1 p_1
dw_print dw_print
rr_4 rr_4
end type
global w_pm01_02020 w_pm01_02020

type variables
String is_gubun='11111'	// 근무계획
String is_sdate2, is_edate2, is_sdate3, is_edate3
String is_calgbn = '1'//부하계산기준

long	 	icrow
string	icnam
end variables

forward prototypes
public function integer wf_kunmu ()
public function integer wf_chart (integer arg_row)
public function integer wf_protect (string arg_date)
public subroutine wf_set_qty ()
public subroutine wf_subitem (string as_yymm)
public function integer wf_bom_retrieve (integer row)
end prototypes

public function integer wf_kunmu ();Int ikun, ihu
String sdate, edate

sDate = dw_1.GetItemString(1, 'yymm')
eDate = f_afterday(sdate,6)

SELECT COUNT(CLDATE) INTO :ikun
  FROM (SELECT CLDATE AS CLDATE FROM P4_CALENDAR
		   WHERE WORKGUB <> '9'
			  AND CLDATE BETWEEN :sdate AND :edate
		   GROUP BY CLDATE );
If IsNull(ikun) Then iKun = 0

SELECT COUNT(CLDATE) INTO :ihu
  FROM (SELECT CLDATE AS CLDATE FROM P4_CALENDAR
		   WHERE WORKGUB = '9'
			  AND CLDATE BETWEEN :sdate AND :edate
		   GROUP BY CLDATE );
If IsNull(ihu) Then ihu = 0

st_kun.Text = '근무일수 : ' + string(ikun,'#0') + '일'
st_hu.Text  = '휴무일수 : ' + string(ihu,'#0') + '일'

return ikun
end function

public function integer wf_chart (integer arg_row);int				i, j, li_colno = 0, li_rowcnt = 7, temp
st_chartdata	lst_chartdata
string			ls_colname
boolean			lb_sumtag = false

dec            ld_botime


iF dw_1.AcceptText() <> 1 Then Return -1
if dw_3.rowcount() <= 0 then return -1


if arg_row > 0 then
	If dw_3.GetItemString(arg_row, 'gubun') = '1' Then
		lst_chartdata.toptitle  = trim(dw_3.getitemstring(arg_row, 'wcdsc'))
	Else
		lst_chartdata.toptitle  = trim(dw_3.getitemstring(arg_row, 'mchnam'))
	End If
else
	
	String sPdtgu, sjocod
	
//	sPdtgu = Trim(dw_1.getItemstring(1, 'pdtgu'))
//	If IsNull(sPdtgu) Or sPdtgu = '' Then
//		lst_chartdata.toptitle  = '생산능력검토'
//	Else
//		lst_chartdata.toptitle  = Trim(dw_1.Describe("Evaluate('LookUpDisplay(pdtgu) ', 1)"))
//	End If
	
	sjocod = Trim(dw_1.getItemstring(1, 'jocod'))
	If IsNull(sjocod) Or sjocod = '' Then
		lst_chartdata.toptitle  = '생산능력검토'
	Else
		lst_chartdata.toptitle  = Trim(dw_1.Describe("Evaluate('LookUpDisplay(jocod) ', 1)"))
	End If
end if

//messagebox(string(arg_row), lst_chartdata.toptitle)

	lst_chartdata.rowcnt    = li_rowcnt

// Series 숫자
lst_chartdata.colcnt = 4

lst_chartdata.rowname[1] = '월'
lst_chartdata.rowname[2] = '화'
lst_chartdata.rowname[3] = '수'
lst_chartdata.rowname[4] = '목'
lst_chartdata.rowname[5] = '금'
lst_chartdata.rowname[6] = '토'
lst_chartdata.rowname[7] = '일'
//lst_chartdata.rowname[8] = 'W+1주'
//lst_chartdata.rowname[9] = 'W+2주'

for i = 1 to 4				
	
	li_colno++

//	/* 부하율 */
//	if i = 1 Then
//		lst_chartdata.colname[li_colno] = '부하시간'
//		lst_chartdata.pointlabels[li_colno] = true
//		lst_chartdata.gallery[li_colno] = ole_chart.uc_lines
//		
//		for j = 1 to 7
//			if arg_row > 0 then
//				if dw_3.getitemdecimal(arg_row, 'sa' + string(j)) = 0 then
//					lst_chartdata.value[j,li_colno] = 0
//				else
//					 temp= dw_3.getitemdecimal(arg_row, 'bo' + string(j))
//					if temp = 0 then
//						lst_chartdata.value[j,li_colno] = 0
//					else
//						lst_chartdata.value[j,li_colno] = dw_3.getitemdecimal(arg_row, 'sa' + string(j)) / dw_3.getitemdecimal(arg_row, 'bo' + string(j)) * 100
//					end if
//				end if
//			else
//				if dw_3.getitemdecimal(1, 'sum_sa' + string(j)) = 0 then
//					lst_chartdata.value[j,li_colno] = 0
//				else
//					lst_chartdata.value[j,li_colno] = dw_3.getitemdecimal(1, 'sum_sa' + string(j)) / dw_3.getitemdecimal(1, 'sum_bo' + string(j)) * 100
//				end if
//			end if
//		next
//	end if
//
//	/* 목표부하율 */
//	if i = 2 Then
//		lst_chartdata.colname[li_colno] = '목표부하율(80%)'
//		lst_chartdata.pointlabels[li_colno] = true
//		lst_chartdata.gallery[li_colno] = ole_chart.uc_lines
//		
//		for j = 1 to 7
//			if arg_row > 0 then
//				if dw_3.getitemdecimal(arg_row, 'sa' + string(j)) = 0 then
//					lst_chartdata.value[j,li_colno] = 0
//				else
//					temp =  dw_3.getitemdecimal(arg_row, 'bo' + string(j))
//					if temp = 0 then
//						lst_chartdata.value[j,li_colno] = 0
//					else
//						lst_chartdata.value[j,li_colno] = dw_3.getitemdecimal(arg_row, 'sa' + string(j)) / dw_3.getitemdecimal(arg_row, 'bo' + string(j)) * 100 * 0.8
//					end if
//				end if
//			else
//				if dw_3.getitemdecimal(1, 'sum_sa' + string(j)) = 0 then
//					lst_chartdata.value[j,li_colno] = 0
//				else
//					lst_chartdata.value[j,li_colno] = dw_3.getitemdecimal(1, 'sum_sa' + string(j)) / dw_3.getitemdecimal(1, 'sum_bo' + string(j)) * 100 * 0.8
//				end if
//			end if
//		next
//	end if

	/* 보유공수 */
	if i = 1 Then
		lst_chartdata.colname[li_colno] = '부하시간'
		lst_chartdata.pointlabels[li_colno] = true
		lst_chartdata.gallery[li_colno] = ole_chart.uc_bar
		
		for j = 1 to 7
			if arg_row > 0 then
				lst_chartdata.value[j,li_colno] = dw_3.getitemdecimal(arg_row, 'bo' + string(j))
			else
				lst_chartdata.value[j,li_colno] = dw_3.getitemdecimal(1, 'sum_bo' + string(j))
			end if
		next
	end if

	/* 가동시간 */
	if i = 2 Then
		lst_chartdata.colname[li_colno] = '가동시간'
		lst_chartdata.pointlabels[li_colno] = true
		lst_chartdata.gallery[li_colno] = ole_chart.uc_bar
		
		for j = 1 to 7
			if arg_row > 0 then
				lst_chartdata.value[j,li_colno] = dw_3.getitemdecimal(arg_row, 'sa' + string(j))
			else
				lst_chartdata.value[j,li_colno] = dw_3.getitemdecimal(1, 'sum_sa' + string(j))
			end if
		next
	end if

	/* 목표부하율 */
	if i = 3 Then
		lst_chartdata.colname[li_colno] = '목표부하율(80%)'
		lst_chartdata.pointlabels[li_colno] = false
		lst_chartdata.gallery[li_colno] = ole_chart.uc_lines
		lst_chartdata.SecondY[li_colno] = true
		
		for j = 1 to 7
			if arg_row > 0 then
				lst_chartdata.value[j,li_colno] = 80
			else
				lst_chartdata.value[j,li_colno] = 80
			end if
		next
	end if

	/* 부하율 */
	if i = 4 Then
		lst_chartdata.colname[li_colno] = '부하율'
		lst_chartdata.pointlabels[li_colno] = true
		lst_chartdata.gallery[li_colno] = ole_chart.uc_lines
		lst_chartdata.SecondY[li_colno] = true
		
		for j = 1 to 7
			
			if arg_row > 0 then
				ld_botime = dw_3.getitemdecimal(arg_row, 'bo' + string(j)) 
				if ld_botime = 0 then
					lst_chartdata.value[j,li_colno] = 0
				else
					lst_chartdata.value[j,li_colno] = dw_3.getitemdecimal(arg_row, 'sa' + string(j)) / ld_botime * 100
				end if
			else
				ld_botime =  dw_3.getitemdecimal(1, 'sum_bo' + string(j))
				if ld_botime = 0 then
					lst_chartdata.value[j,li_colno]  = 0
				else
					lst_chartdata.value[j,li_colno] = dw_3.getitemdecimal(1, 'sum_sa' + string(j)) / ld_botime * 100
				end if
			end if
		next
	end if
		

next

ole_chart.setdata(lst_chartdata)

return 1
end function

public function integer wf_protect (string arg_date);Long lcount
String sCode, sPdtgu, sJocod

sCode = Trim(dw_1.GetItemString(1, 'pdtgu'))
If IsNull(sCode) Then sCode = ''

If IsNull(sCode) Or sCode = '' Then
	sPdtgu = ''
	sJocod = ''
Else
	sPdtgu = Trim(Mid(sCode, 2,6))
	sJocod = Trim(Mid(sCode, 8,6))
End If

SELECT COUNT('X') INTO :lcount FROM PM02_WEEKPLAN_SUM A
 WHERE A.SABU = :gs_sabu AND A.YYMMDD = :arg_date AND A.MOSEQ = 0 AND JOCOD = :sCode ;
 
if lcount > 0 then 
	messagebox("확 인", "주간 생산계획이 확정되어 있으므로 수정 및 삭제 할 수 없습니다.")
	p_print.picturename = 'C:\erpman\image\부하계산_d.gif'
	p_search.picturename = 'C:\erpman\image\조정_d.gif'
	cb_1.Enabled = false
	p_mod.picturename = 'C:\erpman\image\저장_d.gif'
	
	p_print.enabled = false
	p_search.enabled = false
	p_mod.enabled = false
else
	p_print.picturename = 'C:\erpman\image\부하계산_up.gif'
	p_search.picturename = 'C:\erpman\image\조정_up.gif'
	cb_1.Enabled = true
	p_mod.picturename = 'C:\erpman\image\저장_up.gif'
	
	p_print.enabled = true
	p_search.enabled = true
	p_mod.enabled = true
end if	

//rb_1.checked = true
//rb_1.triggerevent(clicked!)

return 0
end function

public subroutine wf_set_qty ();String 	syymm, sitnbr, stoday
Long	 	ll_row
Dec {0}	dJqty, dJqty2, dSqty, dPqty, dPqty1, dPqty2, dPqty3, dPqty4, dPqty5, dPqty6, dPqty7

syymm	= dw_1.GetItemString(1, 'yymm')

stoday = f_today()
//stoday = '20061004'

For ll_row = 1 To dw_insert.Rowcount()
	sitnbr = dw_insert.getitemstring(ll_row,'itnbr')
	// 현재고
	select sum(case 
            when c.jego_qty < 0 then 0
            else c.jego_qty
        end) into :dJqty from stock c
	 where c.itnbr = :sitnbr
	   And exists ( select 'x' from vndmst where cvcod = c.depot_no and jumaechul not in ('3','4') and soguan <> '4' ) ;
	if IsNull(dJqty) then dJqty = 0

	// 외주처 현재고
	select sum(case 
            when c.jego_qty < 0 then 0
            else c.jego_qty
        end) into :dJqty2 from stock_vendor c
	 where c.itnbr = :sitnbr ;
	if IsNull(dJqty2) then dJqty2 = 0
	
	dJqty = dJqty + dJqty2

	// 안전재고
	select nvl(midsaf,0) into :dSqty from itemas where itnbr = :sitnbr;
	
	// 계획잔량
	select sum(lotqty1), sum(lotqty2), sum(lotqty3), sum(lotqty4), sum(lotqty5), sum(lotqty6), sum(lotqty7)
	  into :dPqty1, 		:dPqty2, 		:dPqty3, 	:dPqty4, 		:dPqty5, 		:dPqty6, 	:dPqty7
	 from pm02_capa_dtl
	where yymm = :syymm and itnbr = :sitnbr;
	if IsNull(dPqty1) then
		dPqty = 0
	else
		if stoday > f_afterday(syymm,6) then
			dPqty = 0
		elseif stoday <= syymm then
			dPqty = dPqty1 + dPqty2 + dPqty3 + dPqty4 + dPqty5 + dPqty6 + dPqty7
		else
			choose case f_dayterm(syymm,stoday)
				case 1
					dPqty = dPqty2 + dPqty3 + dPqty4 + dPqty5 + dPqty6 + dPqty7
				case 2
					dPqty = dPqty3 + dPqty4 + dPqty5 + dPqty6 + dPqty7
				case 3
					dPqty = dPqty4 + dPqty5 + dPqty6 + dPqty7
				case 4
					dPqty = dPqty5 + dPqty6 + dPqty7
				case 5
					dPqty = dPqty6 + dPqty7
				case 6
					dPqty = dPqty7
				case else
					dPqty = 0
			end choose
		end if
	end if
	
	dw_insert.setitem(ll_row,'jego_qty',dJqty)
	dw_insert.setitem(ll_row,'safe_qty',dSqty)
	dw_insert.setitem(ll_row,'plan_qty',dPqty)
Next
end subroutine

public subroutine wf_subitem (string as_yymm);DECLARE sub_cur CURSOR FOR
	SELECT ITNBR, WKCTR
	  FROM PM02_CAPA_DTL
	 WHERE YYMM = :as_yymm ;

OPEN sub_cur ;

String ls_sub
String ls_wkctr
Long   ll_cnt
Long   i
Long   ll_chk

SELECT COUNT('X')
  INTO :ll_cnt
  FROM PM02_CAPA_DTL
 WHERE YYMM = :as_yymm ;

For i = 1 To ll_cnt
	FETCH sub_cur INTO :ls_sub, :ls_wkctr ;
	
	SELECT COUNT('X')
	  INTO :ll_chk
	  FROM KUMITEM_KUM
	 WHERE USEYN = 'N'
		AND ITNBR = :ls_sub ;
	If ll_chk > 0 Then
		UPDATE PM02_CAPA_DTL
		   SET S1QTY   = 0, S2QTY   = 0, S3QTY   = 0, S4QTY   = 0, S5QTY   = 0, S6QTY   = 0, S7QTY   = 0,
			    LOTQTY1 = 0, LOTQTY2 = 0, LOTQTY3 = 0, LOTQTY4 = 0, LOTQTY5 = 0, LOTQTY6 = 0, LOTQTY7 = 0
		 WHERE YYMM  = :as_yymm
		   AND ITNBR = :ls_sub
			AND WKCTR = :ls_wkctr ;
		If SQLCA.SQLCODE <> 0 Then
			ROLLBACK USING SQLCA;
			MessageBox('동시작업 품번 For ~ Next', '동시작업 품번 중 SUB ITEM 작업 처리에 실패 했습니다.')
			Return
		End If
	End If
Next

CLOSE sub_cur ;

If SQLCA.SQLCODE = 0 Then
	COMMIT USING SQLCA;
	MessageBox('동시작업 품번', 'SUB ITEM자료 정리 성공')
Else
	ROLLBACK USING SQLCA;
	MessageBox('동시작업 품번', '동시작업 품번 중 SUB ITEM 작업 처리에 실패 했습니다.')
End If




	

end subroutine

public function integer wf_bom_retrieve (integer row);string syymm, sitnbr, sIttyp, sPdtgu, sarray[]

syymm = Trim(dw_1.GetItemString(1, 'yymm'))
sPdtgu = Trim(dw_1.GetItemString(1, 'pdtgu'))  //[BOM기준]화면에 생산팀 구분 색상표시용 - BY SHINGOON 2015.10.15

/* 선택된 품번을 부모로 가지고 있는 하위 품번 중 조회조건의 사업장(생산팀)이 다를 때 붉은 색으로 표시 - by shingoon 2015.10.15 */
/* d_pm01-02020_5_2 데이터윈도우 수정함 */

If row > 0 Then
	sitnbr = dw_insert.GetItemString(row, 'itnbr')
	sIttyp = dw_insert.GetItemString(row, 'ittyp')
	sarray[1] = sitnbr
	
	If sIttyp = '1' then
//		dw_4.Dataobject = "d_pm01-02020_5_2"
//		dw_4.SetTransObject(SQLCA)
		
		dw_4.SetRedraw(False)
		dw_4.Retrieve(syymm, sarray, sitnbr, sPdtgu)
		dw_4.SetRedraw(True)  
	else
		
//		dw_4.Dataobject = "d_pm01-02020_5_2_x"
//		dw_4.SetTransObject(SQLCA)
		
		DECLARE cbom CURSOR FOR
		
		 SELECT A.PINBR
			FROM ( SELECT LEVEL LEV, PSTRUC.* FROM PSTRUC
				   CONNECT BY PRIOR PINBR = CINBR
			       START WITH CINBR = :sitnbr ) A ,
				  ITEMAS B
		  WHERE B.ITTYP = '1'
			 AND B.USEYN = '0'
			 AND A.PINBR = B.ITNBR
		ORDER BY LEV DESC ;
		
		OPEN cbom;
		
		String  ls_itnbr[], ls_pinbr
		Integer i ; i = 0
		DO WHILE TRUE
		 FETCH cbom  INTO :ls_pinbr ;
		 IF SQLCA.SQLCODE <> 0 THEN EXIT
		 	i++
		 	ls_itnbr[i] = ls_pinbr
		
		LOOP
		CLOSE cbom;
		dw_4.SetRedraw(False)
		dw_4.Retrieve(syymm, ls_itnbr, sitnbr, sPdtgu)
		dw_4.SetRedraw(True)
//		String ls_pinbr , ls_where , ls_old_sql , ls_new_sql , ls_ymd
//		long start_pos=1
//	
//		
//		ls_where = "" 
//		
//		DECLARE cbom CURSOR FOR
//		
//		 SELECT A.PINBR 
//			FROM PSTRUC A ,
//				  ITEMAS B
//		  WHERE A.PINBR = B.ITNBR 
//			 AND B.ITTYP = '1'
//			 AND B.USEYN = '0'
//		  START WITH A.CINBR = :sitnbr
//		CONNECT BY PRIOR A.PINBR = A.CINBR
//		ORDER BY LEVEL DESC ;
//		
//		OPEN cbom;
//
//		DO WHILE TRUE
//		 FETCH cbom  INTO :ls_pinbr ;
//		 IF SQLCA.SQLCODE <> 0 THEN EXIT
//		 
//		 	ls_where =ls_where +  "'" +ls_pinbr +"',"
//		
//		LOOP
//		CLOSE cbom;
//		
//		ls_where = mid(ls_where , 1 , len(ls_where) - 1 )
//		
//		//Messagebox('' ,  ls_where)
//		
//		ls_old_sql = dw_4.GetSQLSelect()
//		ls_new_sql = ls_old_sql
//		start_pos = 1
//		start_pos = Pos(ls_new_sql, "'XXXXX'", start_pos)
//
//		DO WHILE start_pos > 0
//		
//			 ls_new_sql = Replace(ls_new_sql, start_pos, Len("'XXXXX'"), ls_where)
//		
//			 start_pos = Pos(ls_new_sql, "'XXXXX'", start_pos+Len(ls_where))
//		
//		LOOP
//		start_pos = 1
//		start_pos = Pos(ls_new_sql, "'YYMMDD'", start_pos)
//		
//		ls_ymd = "'" + syymm + "'"
//
//		DO WHILE start_pos > 0
//		
//			 ls_new_sql = Replace(ls_new_sql, start_pos, Len("'YYMMDD'"), ls_ymd)
//		
//			 start_pos = Pos(ls_new_sql, "'YYMMDD'", start_pos+Len(ls_ymd))
//		
//		LOOP
//		start_pos = 1
//		start_pos = Pos(ls_new_sql, "'CCCCC'", start_pos)
//
//		DO WHILE start_pos > 0
//		
//			 ls_new_sql = Replace(ls_new_sql, start_pos, Len("'CCCCC'"), "'" + sitnbr + "'")
//		
//			 start_pos = Pos(ls_new_sql, "'CCCCC'", start_pos+Len(sitnbr))
//		
//		LOOP
//		start_pos = 1
//		start_pos = Pos(ls_new_sql, "'PPPP'", start_pos)
//
//		DO WHILE start_pos > 0
//		
//			 ls_new_sql = Replace(ls_new_sql, start_pos, Len("'PPPP'"), "'" + sPdtgu + "'")
//		
//			 start_pos = Pos(ls_new_sql, "'PPPP'", start_pos+Len(sPdtgu))
//		
//		LOOP
//		
//		//Messagebox('' ,  ls_new_sql)
//		
//		If dw_4.SetSQLSelect(ls_new_sql) < 1 then
//			Messagebox('확인-1','SetSQLSelect 함수적용 실패') 
//			Return -1
//		end if
//		
//		dw_4.Retrieve()
//		
//		If dw_4.SetSQLSelect(ls_old_sql) < 1 then
//			Messagebox('확인-2','SetSQLSelect 함수적용 실패') 
//			Return -1
//		end if

	
//		SELECT PINBR INTO :ls_pinbr
//		  FROM (SELECT LEVEL AS LVL ,
//							LPAD(' ', 2*(LEVEL-1))||TO_CHAR(LEVEL) AS LVL_CH ,
//							A.PINBR ,
//							A.CINBR ,
//							A.QTYPR 
//					 FROM PSTRUC A 
//					START WITH A.CINBR = :sitnbr
//				  CONNECT BY PRIOR A.PINBR = A.CINBR
//				  ORDER BY LVL DESC
//				 ) A
//		  WHERE ROWNUM = 1 ;

	end if
	
else
	dw_4.Reset()
End If

Return 1

end function

on w_pm01_02020.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_3=create dw_3
this.st_kun=create st_kun
this.st_hu=create st_hu
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
this.st_2=create st_2
this.cb_1=create cb_1
this.dw_change=create dw_change
this.cb_2=create cb_2
this.ole_chart=create ole_chart
this.rb_1=create rb_1
this.rb_2=create rb_2
this.pb_1=create pb_1
this.dw_4=create dw_4
this.st_3=create st_3
this.p_1=create p_1
this.dw_print=create dw_print
this.rr_4=create rr_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_3
this.Control[iCurrent+3]=this.st_kun
this.Control[iCurrent+4]=this.st_hu
this.Control[iCurrent+5]=this.rr_1
this.Control[iCurrent+6]=this.rr_2
this.Control[iCurrent+7]=this.rr_3
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.cb_1
this.Control[iCurrent+10]=this.dw_change
this.Control[iCurrent+11]=this.cb_2
this.Control[iCurrent+12]=this.ole_chart
this.Control[iCurrent+13]=this.rb_1
this.Control[iCurrent+14]=this.rb_2
this.Control[iCurrent+15]=this.pb_1
this.Control[iCurrent+16]=this.dw_4
this.Control[iCurrent+17]=this.st_3
this.Control[iCurrent+18]=this.p_1
this.Control[iCurrent+19]=this.dw_print
this.Control[iCurrent+20]=this.rr_4
end on

on w_pm01_02020.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_3)
destroy(this.st_kun)
destroy(this.st_hu)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
destroy(this.st_2)
destroy(this.cb_1)
destroy(this.dw_change)
destroy(this.cb_2)
destroy(this.ole_chart)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.pb_1)
destroy(this.dw_4)
destroy(this.st_3)
destroy(this.p_1)
destroy(this.dw_print)
destroy(this.rr_4)
end on

event open;call super::open;dw_1.SetTransObject(sqlca)

dw_3.SetTransObject(sqlca)

dw_insert.SetTransObject(sqlca)
dw_print.SetTransObject(sqlca)
dw_change.SetTransObject(sqlca)

//dw_2.SetTransObject(sqlca)
dw_4.SetTransObject(sqlca)

dw_1.InsertRow(0)

String sDate

SELECT MAX(YYMMDD) INTO :sDate FROM PM02_WEEKPLAN_SUM;

// 부하계산 기준(1:작업장단위, 2:설비단위)
SELECT SUBSTR(DATANAME,1,1) INTO :is_calgbn FROM SYSCNFG WHERE SYSGU = 'Y' AND SERIAL = 15 AND LINENO = 90;
If IsNull(is_calgbn)  or is_calgbn <> '2' then is_calgbn = '1'

// 타설비 대체 popup은 설비단위에서만 사용가능
//If is_calgbn = '1' Then
//	p_search.Visible = False
//End If

//f_mod_saupj(dw_1, 'pdtgu')

String sPdtgu
SELECT RFGUB INTO :sPdtgu FROM REFFPF WHERE SABU = :gs_sabu AND RFCOD = '03' AND RFNA2 = :gs_saupj AND ROWNUM = 1 ;

dw_1.SetItem(1, 'pdtgu', sPdtgu)
dw_1.SetItem(1, 'yymm', sDate)

/* 블럭코드 dddw 조회용 */
f_child_saupj(dw_1, 'jocod', sPdtgu)


dw_1.TriggerEvent(ItemChanged!)

Post wf_protect(sdate)
end event

type dw_insert from w_inherite`dw_insert within w_pm01_02020
integer x = 46
integer y = 1096
integer width = 4507
integer height = 580
string dataobject = "d_pm01_02020_3_new"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemerror;call super::itemerror;Return 1
end event

event dw_insert::itemchanged;call super::itemchanged;//Dec dQty, dLotQty, dMinQty, dMulQty
//String sIdx
//
//Choose Case GetColumnName()
//	Case 'ddqty1', 'ddqty2', 'ddqty3', 'ddqty4', 'ddqty5', 'ddqty6', 'ddqty7'		
//		dQty = Dec(GetText())
//		
//		dMinQty = GetItemNumber(row, 'minqty')
//		dMulQty = GetItemNumber(row, 'minqty')
//		If IsNull(dMinqty) Or dMinqty = 0 Then dMinqty = 0
//		If IsNull(dMulQty) Or dMulQty = 0 Then dMulQty = 1
//				
//		dLotQty = dMinqty + (ceiling((dQty - dMinqty)/dMulQty) * dMulQty)
//		If IsNull(dLotQty) Or dLotQty = 0 Then dLotQty = 0
//		
//		sIdx = Mid(GetColumnName(),6,1)
//		SetItem(row, 'lotqty'+sidx, dLotQty)
//		
//		w_mdi_frame.sle_msg.text = 'LOT 적용수량은 ' + STRING(dLotQty,'#,##0') + ' 입니다'
//End Choose
end event

event dw_insert::itemfocuschanged;call super::itemfocuschanged;//String sCol
//
//sCol = dwo.name
//
//Choose Case dwo.name
//	Case 'ddqty1', 'ddqty2', 'ddqty3','ddqty4', 'ddqty5', 'ddqty6', 'ddqty7'
//		w_mdi_frame.sle_msg.text = 'LOT 적용수량은 ' + STRING(GetItemNumber(row,'lotqty'+Right(scol,1)),'#,##0') + ' 입니다'
//End Choose
end event

event dw_insert::doubleclicked;call super::doubleclicked;Long		ii
Dec 		dQty, dCumQty, dLotQty, dMinQty, dMulQty
String 	sIdx, sCol

sCol = dwo.name

Choose Case sCol
	Case 'lotqty1', 'lotqty2', 'lotqty3', 'lotqty4', 'lotqty5', 'lotqty6', 'lotqty7'
		
		dQty = GetItemNumber(row, sCol)
		dCumQty = dQty
		dLotQty = GetItemNumber(row, 'capa_qty')
		
		For ii = 1 To 7
			if dCumQty >= dLotQty then	Exit
			if sCol = 'lotqty'+string(ii) then continue
			dCumQty = dCumQty + GetItemNumber(row, 'lotqty'+string(ii))
			SetItem(row, 'lotqty'+string(ii), 0)
		Next
		SetItem(row, sCol, dCumQty)
End Choose
end event

event dw_insert::clicked;call super::clicked;this.selectrow(0,false)
if row > 0 then
	this.selectrow(row,true)
end if
end event

event dw_insert::rbuttondown;call super::rbuttondown;//cb_1.PostEvent(Clicked!)
dw_insert.accepttext()
if dw_insert.update() <> 1 then
	rollback ;
	messagebox("확인", "부하 조정 실패!!!")
	return
end if

commit;

//p_mod.PostEvent(Clicked!)
p_search.PostEvent(Clicked!)
end event

event dw_insert::rowfocuschanged;call super::rowfocuschanged;/* 품목구분에 따른 BOM조회 */
/* 선택된 품번을 부모로 가지고 있는 하위 품번 중 조회조건의 사업장(생산팀)이 다를 때 붉은 색으로 표시 - by shingoon 2015.10.15 */
wf_bom_retrieve(currentrow)

end event

event dw_insert::retrieveend;call super::retrieveend;//wf_bom_retrieve(dw_insert.GetRow())


end event

type p_delrow from w_inherite`p_delrow within w_pm01_02020
boolean visible = false
integer x = 2981
integer y = 40
boolean enabled = false
end type

event p_delrow::clicked;call super::clicked;Long nRow

If f_msg_delete() <> 1 Then	REturn

nRow = dw_insert.GetRow()
If nRow > 0 then
	dw_insert.DeleteRow(nRow)
	
	If dw_insert.Update() <> 1 Then
		RollBack;
		f_message_chk(31,'')
		Return
	End If
	Commit;
End If
end event

type p_addrow from w_inherite`p_addrow within w_pm01_02020
boolean visible = false
integer x = 3200
integer y = 48
boolean enabled = false
end type

event p_addrow::clicked;String sCarCode, sCarGbn1, sCarGbn2
Long	 nRow, dMax

If dw_1.AcceptText() <> 1 Then Return

sCarCode = Trim(dw_1.GetItemString(1, 'carcode'))
sCarGbn1 = Trim(dw_1.GetItemString(1, 'cargbn1'))
sCarGbn2 = Trim(dw_1.GetItemString(1, 'cargbn2'))
If IsNull(sCarCode) Or sCarCode = '' Then
	f_message_chk(1400,'')
	Return
End If

nRow = dw_insert.InsertRow(0)
dw_insert.SetItem(nRow, 'carcode', sCarCode)
dw_insert.SetItem(nRow, 'cargbn1', sCargbn1)
dw_insert.SetItem(nRow, 'cargbn2', sCargbn2)

dMax = dw_insert.GetItemNumber(1, 'maxseq')
If IsNull(dMax) then dMax = 0
dMax += 1
dw_insert.SetItem(nRow, 'seq', dMax)
end event

type p_search from w_inherite`p_search within w_pm01_02020
integer x = 3365
integer y = 20
string picturename = "C:\erpman\image\조정_up.gif"
end type

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\조정_dn.gif"
end event

event p_search::ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조정_up.gif"
end event

event p_search::clicked;call super::clicked;Long nRow, nRow2
String sMchno, sItnbr, sYYMM, sCol, sGubun, swkctr, sOpseq

//nRow = dw_3.GetSelectedRow(0)
nRow = dw_3.GetRow()
nRow2 = dw_insert.GetRow()

If nRow <= 0 Then 
	messagebox('확인','작업장을 선택하십시오!!!')
	Return
End If

sGubun = dw_3.GetItemString(nRow, 'gubun')
sMchno = dw_3.GetItemString(nRow, 'wkctr')

//nRow = dw_insert.GetSelectedRow(0)
If nRow2 <= 0 Then 
	messagebox('확인','품목을 선택하십시오!!!')
	Return
End If

sItnbr = dw_insert.GetItemString(nRow2, 'itnbr')
sOpseq = dw_insert.GetItemString(nRow2, 'opseq')
sYymm = dw_1.GetItemString(1, 'yymm')

gs_code = sYymm
gs_codename = sItnbr
gs_codename2 = sMchno
gs_codename3 = sOpseq
gs_gubun     = sGubun	// 1:작업장, 2:설비

Open(w_pm01_02020_1_new)
//Open(w_pm01_02020_1_han)		// 2017.07.10 표준공정 대체작업장으로 변경 - 추후 적용 예정(BY SHINGOON 20180228)

If gs_code = 'OK' Then 

	p_inq.TriggerEvent(Clicked!)
	
//	dw_3.Scroll(nRow)
	
   dw_1.GetItemString(1, 'yymm')
	swkctr = dw_3.GetItemString(nRow, 'wkctr')

	If IsNull(sMchno) then sMchno = ''

	dw_insert.Retrieve(syymm, swkctr)
	
	wf_set_qty()		// 수량-2006.10.11

	wf_chart(nRow)
	
//	dw_3.Scroll(nRow2)
	
//	If GetItemString(row, 'gubun') = '2' Then Return
	
//	ls_Object = Lower(This.GetObjectAtPointer())
	
end if

//// 포커스 잃어버리지 않게 강체로... 2009.07.02 최정휘	
//dw_3.Scroll(nRow)
//dw_3.Scroll(nRow2)

dw_3.ScrollToRow(nRow)
dw_insert.ScrollToRow(nRow2)

dw_3.SelectRow(0, False)
dw_3.SelectRow(nRow, True)

dw_insert.SelectRow(0, False)
dw_insert.SelectRow(nRow2, True)

end event

type p_ins from w_inherite`p_ins within w_pm01_02020
integer x = 3543
integer y = 20
string picturename = "C:\erpman\image\mrp_up.gif"
end type

event p_ins::ue_lbuttondown;PictureName = "C:\erpman\image\mrp_dn.gif"
end event

event p_ins::ue_lbuttonup;PictureName = "C:\erpman\image\mrp_up.gif"
end event

event p_ins::clicked;call super::clicked;String syymm, sdate, edate, sPdtgu, sJocod, sCode


/////////////////////////////////////////////////////////////////////////////////////////
// 1. MRP 계산
Openwithparm(w_pm01_02040, '3')
SetNull(gs_code)
/* mrp전개 창에서 "생성"하지 않고 전개창을 닫으면 구문 종료 */
If gs_codename2 = 'x' Then Return

/////////////////////////////////////////////////////////////////////////////////////////
// 2. 부하계산
If dw_1.AcceptText() <> 1 Then Return

syymm = Trim(dw_1.GetItemString(1, 'yymm'))
If IsNull(syymm) Or syymm = '' Then
	f_message_chk(1400, '')
	REturn
End If

sCode = Trim(dw_1.GetItemString(1, 'pdtgu'))
If IsNull(sCode) Then sCode = ''

is_gubun = gs_code

// 작업장 부하계산
sqlca.PM02_CAPA_LOD_WEEK(gs_sabu, syymm, '1');
If sqlca.sqlcode <> 0 Then
	MessageBox(string(sqlca.sqlcode), SQLCA.SQLERRTEXT)
	RETURN
END iF

//// 설비별 부하계산
//If is_calgbn = '2' Then
//	sqlca.PM02_CAPA_LOD_WEEK(gs_sabu, syymm, '2');
//	If sqlca.sqlcode <> 0 Then
//		MessageBox(string(sqlca.sqlcode), SQLCA.SQLERRTEXT)
//		RETURN
//	END iF
//End If

COMMIT;

//동시작업품번 중 sub품일 경우 계획수량을 0으로 update - 안병국과장 요청
//2008.10.10 by shingoon
wf_subitem(syymm)

p_inq.TriggerEvent(Clicked!)
end event

type p_exit from w_inherite`p_exit within w_pm01_02020
integer x = 4421
integer y = 20
end type

type p_can from w_inherite`p_can within w_pm01_02020
integer x = 4247
integer y = 20
end type

event p_can::clicked;call super::clicked;String sNull
SetNull(sNull)
dw_insert.Reset()

end event

type p_print from w_inherite`p_print within w_pm01_02020
integer x = 3721
integer y = 20
string picturename = "C:\erpman\image\부하계산_up.gif"
end type

event p_print::clicked;String syymm, sdate, edate, sPdtgu, sJocod, sCode

If dw_1.AcceptText() <> 1 Then Return

If MessageBox("확 인", "부하조정전 초기 부하로 재계산하시겠습니까?",	Exclamation!, OKCancel!, 2) = 2 Then Return

syymm = Trim(dw_1.GetItemString(1, 'yymm'))
If IsNull(syymm) Or syymm = '' Then
	f_message_chk(1400, '')
	REturn
End If

sCode = Trim(dw_1.GetItemString(1, 'pdtgu'))
If IsNull(sCode) Then sCode = ''

is_gubun = gs_code

// 작업장 부하계산
sqlca.PM02_CAPA_LOD_WEEK(gs_sabu, syymm, '1');
If sqlca.sqlcode <> 0 Then
	MessageBox(string(sqlca.sqlcode), SQLCA.SQLERRTEXT)
	RETURN
END iF

COMMIT;

p_inq.TriggerEvent(Clicked!)
end event

event p_print::ue_lbuttonup;PictureName = "C:\erpman\image\부하계산_up.gif"
end event

event p_print::ue_lbuttondown;PictureName = "C:\erpman\image\부하계산_dn.gif"
end event

type p_inq from w_inherite`p_inq within w_pm01_02020
integer x = 3899
integer y = 20
end type

event p_inq::clicked;call super::clicked;Long	 nRow
String syymm, sdate, edate, sPdtgu, sJocod, sCode, sWkctr

If dw_1.AcceptText() <> 1 Then Return

syymm = Trim(dw_1.GetItemString(1, 'yymm'))
If IsNull(syymm) Or syymm = '' Then
	f_message_chk(1400, '')
	REturn
End If

sCode = Trim(dw_1.GetItemString(1, 'pdtgu'))
If IsNull(sCode) Then scode = ''

sPdtgu = sCode

sJocod = Trim(dw_1.GetItemString(1, 'jocod'))
If IsNull(sJocod) Then sJocod = ''

sDate = syymm
eDate = f_afterday(syymm, 6)


/////////////////////////////////////////////////////////////////////////////////
//nRow = dw_3.GetSelectedRow(0)
nRow = Long(dw_3.Describe("datawindow.firstrowonpage"))
If nRow > 0 Then 
	sWkctr = dw_3.GetItemString(nRow,'wkctr')
End If
/////////////////////////////////////////////////////////////////////////////////


dw_3.Reset()
dw_insert.Reset()

dw_3.SetFilter("gubun = '1'")
dw_3.Filter()

//If IsNull(sCode) Or sCode = '' Then
//	sPdtgu = ''
//	sJocod = ''
//Else
//	sPdtgu = Trim(Mid(sCode, 2,6))
//	sJocod = Trim(Mid(sCode, 8,6))
//End If



/////////////////////////////////////////////////////////////////////////////////
dw_3.SetRedraw(False)
dw_3.Retrieve(sDate, eDate, sPdtgu+'%', sJocod+'%')
nRow = dw_3.Find("wkctr='"+sWkctr+"'",1,dw_3.RowCount())
If nRow > 0 Then 
	dw_3.ScrollToRow(nRow)
End If
dw_3.SetRedraw(True)
/////////////////////////////////////////////////////////////////////////////////

p_1.Enabled = True
p_1.PictureName = 'C:\erpman\image\인쇄_up.gif'

wf_kunmu()

WF_CHART(0)

dw_change.Visible = false
dw_insert.Visible = true

Post wf_protect(sdate)
end event

type p_del from w_inherite`p_del within w_pm01_02020
boolean visible = false
integer x = 3401
integer y = 44
end type

type p_mod from w_inherite`p_mod within w_pm01_02020
integer x = 4073
integer y = 20
end type

event p_mod::clicked;call super::clicked;Long ix, iy, iChng, iNo, iCnt=0
Dec  dReq, dQty[7], dOld[7]
String sOrderNo, sdate, syymm, sCvcod, sItnbr, sCustGbn, sCustNapgi, sPordno, sMogub, sNapgi[7]
String sPdtgu
Int    nJucha

If dw_1.AcceptText() <> 1 Then Return
If dw_insert.AcceptText() <> 1 Then Return

sdate = dw_1.GetItemString(1, 'yymm')
sPdtgu = dw_1.GetItemString(1, 'pdtgu')
syymm = Left(dw_1.GetItemString(1, 'yymm'),6)

//주차
select mon_jucha into :njucha from pdtweek where week_sdate = :sdate;

if dw_insert.update() <> 1 then
	rollback ;
	messagebox("확인", "부하 조정 실패!!!")
	return
end if

commit;

// 작업장 부하계산(사용공수만 재계산)
sqlca.PM02_CAPA_LOD_WEEK(gs_sabu, sdate, '3');
If sqlca.sqlcode <> 0 Then
	MessageBox(string(sqlca.sqlcode), SQLCA.SQLERRTEXT)
	RETURN
END iF


////////////////////////////////////////////////////////////////////////////////////////////////////
// 주간생산계획 변경
//   - 품목별로 최초공정의 조정된 작업장 생산량 합계값을 생산계획량으로 갱신
UPDATE PM02_WEEKPLAN_SUM A
   SET A.LOTQTY1	= ( SELECT SUM(X.LOTQTY1) FROM PM02_CAPA_DTL X
							  WHERE X.YYMM = A.YYMMDD AND X.ITNBR = A.ITNBR 
								 AND X.OPSEQ = ( SELECT MIN(OPSEQ) FROM ROUTNG 
														WHERE ITNBR = X.ITNBR AND UPTGU = 'Y' AND PURGC = 'N' ) ),
		 A.LOTQTY2	= ( SELECT SUM(X.LOTQTY2) FROM PM02_CAPA_DTL X
							  WHERE X.YYMM = A.YYMMDD AND X.ITNBR = A.ITNBR 
								 AND X.OPSEQ = ( SELECT MIN(OPSEQ) FROM ROUTNG 
														WHERE ITNBR = X.ITNBR AND UPTGU = 'Y' AND PURGC = 'N' ) ),
		 A.LOTQTY3	= ( SELECT SUM(X.LOTQTY3) FROM PM02_CAPA_DTL X
							  WHERE X.YYMM = A.YYMMDD AND X.ITNBR = A.ITNBR 
								 AND X.OPSEQ = ( SELECT MIN(OPSEQ) FROM ROUTNG 
														WHERE ITNBR = X.ITNBR AND UPTGU = 'Y' AND PURGC = 'N' ) ),
		 A.LOTQTY4	= ( SELECT SUM(X.LOTQTY4) FROM PM02_CAPA_DTL X
							  WHERE X.YYMM = A.YYMMDD AND X.ITNBR = A.ITNBR 
								 AND X.OPSEQ = ( SELECT MIN(OPSEQ) FROM ROUTNG 
														WHERE ITNBR = X.ITNBR AND UPTGU = 'Y' AND PURGC = 'N' ) ),
		 A.LOTQTY5	= ( SELECT SUM(X.LOTQTY5) FROM PM02_CAPA_DTL X
							  WHERE X.YYMM = A.YYMMDD AND X.ITNBR = A.ITNBR 
								 AND X.OPSEQ = ( SELECT MIN(OPSEQ) FROM ROUTNG 
														WHERE ITNBR = X.ITNBR AND UPTGU = 'Y' AND PURGC = 'N' ) ),
		 A.LOTQTY6	= ( SELECT SUM(X.LOTQTY6) FROM PM02_CAPA_DTL X
							  WHERE X.YYMM = A.YYMMDD AND X.ITNBR = A.ITNBR 
								 AND X.OPSEQ = ( SELECT MIN(OPSEQ) FROM ROUTNG 
														WHERE ITNBR = X.ITNBR AND UPTGU = 'Y' AND PURGC = 'N' ) ),
		 A.LOTQTY7	= ( SELECT SUM(X.LOTQTY7) FROM PM02_CAPA_DTL X
							  WHERE X.YYMM = A.YYMMDD AND X.ITNBR = A.ITNBR 
								 AND X.OPSEQ = ( SELECT MIN(OPSEQ) FROM ROUTNG 
														WHERE ITNBR = X.ITNBR AND UPTGU = 'Y' AND PURGC = 'N' ) )
 WHERE A.SABU = :gs_sabu AND A.YYMMDD = :sdate 
   AND EXISTS ( SELECT 'X' FROM PM02_CAPA_DTL WHERE YYMM = A.YYMMDD AND ITNBR = A.ITNBR ) ;

If sqlca.sqlcode <> 0 Then
	MessageBox(string(sqlca.sqlcode), SQLCA.SQLERRTEXT)
	rollback ;
	RETURN
END iF

COMMIT;

w_mdi_frame.sle_msg.text = "자료가 저장되었습니다!!"


//// 패키지 기준 막음 - 2006.10.10 - 송병호 
//If MessageBox("확 인", "변경된 일정을 조정하시겠습니까?",	Exclamation!, OKCancel!, 2) = 2 Then Return
//
//sOrderNo = '.'
//select dataname into :sCvcod from syscnfg where sysgu = 'C' AND serial = '4' and lineno = 1; // 자사거래처 코드
//sCustGbn 	= 'Z'	// 고객구분
//sCustNapgi 	= '99991231' // 납기
//
//// 생산일자 선정
//For ix = 1 To 7
//	select to_char(to_date(:sdate,'yyyymmdd') + :ix - 1,'yyyymmdd') into :sNapgi[ix] from dual;
//Next
//
//For ix = 1 To dw_insert.RowCount()
//	iChng		= 0
//	
//	For iy = 1 To 7
//		dQty[iy]	= dw_insert.GetItemNumber(ix, 'ddqty'+string(iy))	// New Value
//		dOld[iy]	= dw_insert.GetItemNumber(ix, 'ddold'+string(iy)) // Old Value
//		
//		If dQty[iy] <> dOld[iy] Then
//			iChng++
//		End If
//	Next
//	
//	// 변경된 자료가 있을 경우 기존 자료 cancel후 신규로 자료 작성
//	If iChng > 0 Then
//		sItnbr 		= dw_insert.GetItemString(ix, 'itnbr')
//		sMogub	 	= dw_insert.GetItemString(ix, 'mogub')
//			
//		SELECT MAX(MONSEQ) INTO :iNo
//		  FROM PM01_MONPLAN_DTL
//		 WHERE SABU = :gs_sabu AND MONYYMM = :syymm AND JUCHA = :nJucha;
//		
//		For iy = 1 To 7
//			dReq = dQty[iy] - dOld[iy]
//			
//			If dReq <> 0 Then
//				iNo = iNo + 1
//				
//				sPordno = sdate + string(iNo,'00000')
//				
//				INSERT INTO PM01_MONPLAN_DTL 
//						 ( SABU,        MONYYMM,     MONSEQ, CVCOD,   ITNBR,      PLAN_QTY,  ORDER_NO,  CUST_NAPGI,  CUSTGBN, 
//						   ESDATE,      EEDATE,      MOGUB,  PLANSTS, PLDATE,     JUCHA,     PORDNO,	  JOCOD )
//				 values( :gs_sabu,    :syymm,      :iNo,   :sCvcod, :sItnbr,    :dReq, :sOrderNo, :sCustNapgi, :sCustGbn,
//				         :sNapgi[iy], :sNapgi[iy], :sMogub,'N',     :sNapgi[iy],:nJucha,   :sPordno,  :sPdtgu);
//				If sqlca.sqlcode <> 0 Then
//					MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext + ' #3')
//					Rollback;
//					Return
//				End If
//				
//				icnt += 1
//			End If
//		Next
//	End If
//Next
//
//COMMIT;


// 수량 변경시 사용공수 재계산
//If icnt > 0 Then
//	// 작업장 부하계산(사용공수만 재계산)
//	sqlca.PM02_CAPA_LOD_WEEK(gs_sabu, sdate, '3');
//	
//	If sqlca.sqlcode <> 0 Then
//		MessageBox(string(sqlca.sqlcode), SQLCA.SQLERRTEXT)
//		ROLLBACK;
//		RETURN
//	END iF
//	COMMIT;
//	
//	p_inq.TriggerEvent(Clicked!)
//End If

//dw_insert.Reset()
end event

type cb_exit from w_inherite`cb_exit within w_pm01_02020
end type

type cb_mod from w_inherite`cb_mod within w_pm01_02020
end type

type cb_ins from w_inherite`cb_ins within w_pm01_02020
end type

type cb_del from w_inherite`cb_del within w_pm01_02020
end type

type cb_inq from w_inherite`cb_inq within w_pm01_02020
end type

type cb_print from w_inherite`cb_print within w_pm01_02020
end type

type st_1 from w_inherite`st_1 within w_pm01_02020
end type

type cb_can from w_inherite`cb_can within w_pm01_02020
end type

type cb_search from w_inherite`cb_search within w_pm01_02020
end type







type gb_button1 from w_inherite`gb_button1 within w_pm01_02020
end type

type gb_button2 from w_inherite`gb_button2 within w_pm01_02020
end type

type dw_1 from u_key_enter within w_pm01_02020
integer x = 55
integer y = 40
integer width = 2007
integer height = 152
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_pm01_02020_1"
boolean border = false
end type

event itemchanged;String sDate, edate, sjocod, spdtgu, snull

setnull(snull)
Choose Case GetColumnName()
	Case 'yymm'
		sDate = GetText()

		If DayNumber(Date( Left(sDate,4)+'-'+Mid(sDate,5,2) +'-'+Right(sDate,2) )) <> 2 Then
			MessageBox('확 인','주간 계획은 월요일부터 생성가능합니다.!!')
			Return 1
			Return
		End If
		
		is_sdate2 = f_afterday(sDate,7)
		is_edate2 = f_afterday(sDate,13)
		is_sdate3 = f_afterday(sDate,14)
		is_edate3 = f_afterday(sDate,20)
		
		dw_3.Reset()
		Post wf_protect(sdate)
	Case 'pdtgu'
		spdtgu = GetText()
		/* 블럭코드 dddw 조회용 */
		f_child_saupj(dw_1, 'jocod', sPdtgu)
		
		p_inq.TriggerEvent(Clicked!)
	Case 'jocod'
		sjocod = GetText()
		
		select pdtgu into :spdtgu from jomast where jocod = :sjocod ;
		if sqlca.sqlcode = 0 then
			this.setitem(1,'pdtgu',spdtgu)
		else
			this.setitem(1,'pdtgu',snull)
		end if
		
		p_inq.TriggerEvent(Clicked!)
End Choose
end event

event itemerror;call super::itemerror;return 1
end event

type dw_3 from datawindow within w_pm01_02020
event ue_mousemove pbm_mousemove
integer x = 46
integer y = 228
integer width = 2085
integer height = 820
integer taborder = 70
boolean bringtotop = true
string title = "none"
string dataobject = "d_pm01_02020_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;String syymm, swkctr, sFilter, ls_Object, sMchno, sMindate, sMaxDate
Long	 ll_row

this.selectrow(0,false)
if row > 0 then
	this.selectrow(row,true)
end if

dw_insert.SetRedraw(False)
dw_change.SetRedraw(False)
If row > 0 Then
	syymm	= dw_1.GetItemString(1, 'yymm')
	swkctr = GetItemString(row, 'wkctr')
	sMchno = Trim(GetItemString(row, 'mchno'))
	If IsNull(sMchno) then sMchno = ''
	
//	If sMchno = '' Then
//		dw_insert.DataObject = 'd_pm01_02020_3'
//		dw_insert.SetTransObject(sqlca)
//		dw_insert.Retrieve(gs_sabu, syymm, swkctr+'%',    '%', is_sdate2, is_edate2, is_sdate3, is_edate3, gs_saupj)
//	Else
//		dw_insert.DataObject = 'd_pm01_02020_3_1'
//		dw_insert.SetTransObject(sqlca)
//		dw_insert.Retrieve(gs_sabu, syymm, swkctr+'%', sMchno, is_sdate2, is_edate2, is_sdate3, is_edate3, gs_saupj)
//	End If
	
	dw_insert.Retrieve(syymm, swkctr)
//	dw_print.Retrieve(syymm, swkctr)
	
	wf_set_qty()		// 수량-2006.10.11

////////////////////////////////////////////////////////////////////////////////////////////////////

//	This.SelectRow(0, FALSE)
//	This.SelectRow(row, TRUE)
	
	wf_chart(row)
	
	If GetItemString(row, 'gubun') = '2' Then Return
	
	ls_Object = Lower(This.GetObjectAtPointer())
	
	/* 작업장 */
//	IF mid(ls_Object, 1, 5)  = 'wcdsc' THEN 
//		ll_Row = long(mid(ls_Object, 6, 3))
//		if ll_Row < 1 or isnull(ll_Row) then return 
//	
//		If GetItemString(row, 'sub') = '0' Then
//			SetItem(row, 'sub','1')
//			sFilter = "gubun = '1' or ( gubun = '2' and wkctr = '" + GetItemString(row, 'wkctr') + "' )"
//		Else
//			SetItem(row, 'sub','0')
//			sFilter = "gubun = '1' "
//		End If
//		SetFilter(sFilter)
//		Filter()
//		
//		dw_3.SetSort("wkctr, gubun, mchno")
//		dw_3.Sort()
//	END IF

	/* 근무형태 */
	SELECT WEEK_SDATE, WEEK_LDATE INTO :sMindate, :sMaxDate FROM PDTWEEK WHERE WEEK_SDATE = :sYymm;
	dw_change.Retrieve(sMindate, sMaxDate, sWkctr)
	
Else
//	This.SelectRow(0, FALSE)
	wf_chart(0)
End If

dw_insert.SetRedraw(True)
dw_change.SetRedraw(True)
end event

type st_kun from statichyperlink within w_pm01_02020
integer x = 2085
integer y = 60
integer width = 448
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 16711680
long backcolor = 16777215
string text = "근무일수 :"
boolean focusrectangle = false
end type

event clicked;Long   nRow
String sGubun

nRow = dw_3.GetSelectedRow(0)
If nRow > 0 Then
	sGubun = Trim(dw_3.GetItemString(nRow, 'gubun'))
	
	// 부하계산이 작업장기준이면서 설비클릭시 return
	If is_calgbn = '1' And sGubun = '2' Then Return
	
	If dw_change.Visible = False Then
		dw_change.Visible = true
		dw_insert.Visible = false
	Else
		dw_change.Visible = False
		dw_insert.Visible = true
	End If
End If
	
end event

type st_hu from statichyperlink within w_pm01_02020
integer x = 2085
integer y = 120
integer width = 448
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 16711680
long backcolor = 16777215
string text = "휴무일수 :"
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_pm01_02020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 220
integer width = 2112
integer height = 844
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pm01_02020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 16777215
integer x = 37
integer y = 24
integer width = 2519
integer height = 180
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_pm01_02020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 1088
integer width = 4535
integer height = 608
integer cornerheight = 40
integer cornerwidth = 55
end type

type st_2 from statictext within w_pm01_02020
integer x = 4256
integer y = 188
integer width = 329
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "단위 : HOUR"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_pm01_02020
boolean visible = false
integer x = 2958
integer y = 120
integer width = 201
integer height = 104
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "일정"
end type

event clicked;Long nRow
String sMchno, sItnbr, sYYMM, sCol

nRow = dw_3.GetSelectedRow(0)
If nRow <= 0 Then Return

If dw_insert.GetRow() <= 0 Then Return

//If dw_3.GetItemString(nRow, 'gubun') = '1' Then
//	MessageBox('확 인','설비에서만 변경 가능합니다.!!')
//	Return
//End If

sMchno = dw_3.GetItemString(nRow, 'mchno')

nRow = dw_insert.GetRow()
sCol = dw_insert.GetColumnName()
sItnbr = dw_insert.GetItemString(nRow, 'itnbr')


sYymm = dw_1.GetItemString(1, 'yymm')

gs_gubun = syymm
gs_code = sitnbr
gs_codename = dw_insert.GetItemString(nRow, 'itemas_itdsc')

//MessageBox(gs_code, sitnbr+smchno)
Open(w_pm01_02020_2)
//If gs_code = 'OK' Then p_inq.TriggerEvent(Clicked!)
end event

type dw_change from u_key_enter within w_pm01_02020
boolean visible = false
integer x = 4750
integer y = 1692
integer width = 539
integer height = 348
integer taborder = 11
string dataobject = "d_pm01_02020_4"
boolean border = false
end type

event itemchanged;Long 	 nRow, nFind
String sWkctr, sCldate, sRqcgu, sPdtgu, sDate, edate, sCol, sFilter, sGubun, sMchno
Dec	 dMin

nRow = dw_3.GetSelectedRow(0)
If nRow > 0 Then
	sWkctr = Trim(dw_3.GetItemString(nRow, 'wkctr'))
	sGubun = Trim(dw_3.GetItemString(nRow, 'gubun'))
	sMchno = Trim(dw_3.GetItemString(nRow, 'mchno'))
Else
	Return
End If
If IsNull(sMchno) Then sMchno = ''

sRqcgu = Trim(GetText())

// 주야로 구분하여 부하계산하는 경우(이원정공) 근무형태에 따른 근무시간
//select to_number(dataname) into :dMin from syscnfg where sysgu = 'Y' and serial = '90' and lineno = :sRqcgu;
//If IsNull(dMin) Then dMin = 0

// 작업장별 시프트로 부하계산하는 경우(패키지 기준)
SELECT DECODE(:sRqcgu, '1', SF1SA, '2', SF2SA, '3', SF3SA, '4', SF4SA,0) INTO :dMin FROM WRKCTR WHERE WKCTR = :sWkctr;
If IsNull(dMin) Then dMin = 0
						 
sCol = GetColumnName()
sCldate= Trim(GetItemString(Row, 'cldate'))

// 설비별 부하계산할 경우 저장
If is_calgbn = '2' Then
	Choose Case left(GetColumnName(),6)
		// 주간 작업
		Case 'rqcgu_'
			UPDATE PM02_CAPA_LOD_MCH
				SET BOTIME3 = (:dMin + BOTIME2) * fun_get_wrkgrp_rate(:sCldate, MCHNO,'2','.'),
					 BOTIME1 = :dMin,
					 RTYPE1 = :sRqcgu
			 WHERE WKCTR = :sWkctr
				AND CLDATE = :sCldate
				AND MCHNO LIKE :sMchno||'%';
		// 야간 작업
		Case 'rqcgu2'
			UPDATE PM02_CAPA_LOD_MCH
				SET BOTIME3 = (BOTIME1 + :dMin) * fun_get_wrkgrp_rate(:sCldate, MCHNO,'2','A'),
					 BOTIME2 = :dMin,
					 RTYPE2 = :sRqcgu
			 WHERE WKCTR = :sWkctr
				AND CLDATE = :sCldate
				AND MCHNO LIKE :sMchno||'%';
	End Choose
	If sqlca.sqlcode <> 0 Then
		MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
		RollBack;
		Return
	End If
	
	// 작업장 수정한 경우
	If sGubun = '1' Then
		UPDATE PM02_CAPA_LOD A
			SET ( A.BOTIME3, A.BOTIME1, A.BOTIME2, A.RTYPE1, A.RTYPE2 ) = ( SELECT SUM(B.BOTIME3), SUM(B.BOTIME1), SUM(BOTIME2), MAX(B.RTYPE1), MAX(B.RTYPE2)
																									FROM PM02_CAPA_LOD_MCH B
																								  WHERE B.WKCTR = A.WKCTR
																									 AND B.CLDATE = A.CLDATE )
		 WHERE A.WKCTR = :sWkctr
			AND A.CLDATE = :sCldate;
	// 설비 수정한 경우
	Else
		UPDATE PM02_CAPA_LOD A
			SET ( A.BOTIME3, A.BOTIME1, A.BOTIME2 ) = ( SELECT SUM(B.BOTIME3), SUM(B.BOTIME1), SUM(BOTIME2)
																						FROM PM02_CAPA_LOD_MCH B
																					  WHERE B.WKCTR = A.WKCTR
																						 AND B.CLDATE = A.CLDATE )
		 WHERE A.WKCTR = :sWkctr
			AND A.CLDATE = :sCldate;	
	End If
	If sqlca.sqlcode <> 0 Then
		MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
		RollBack;
		Return
	Else
		COMMIT;
	End If
Else
// 작업장별 부하계산
	Choose Case left(GetColumnName(),6)
		// 주간 작업
		Case 'rqcgu_'
			UPDATE PM02_CAPA_LOD
				SET BOTIME3 = (:dMin + BOTIME2),
					 BOTIME1 = :dMin,
					 RTYPE1 = :sRqcgu
			 WHERE WKCTR = :sWkctr
				AND CLDATE = :sCldate;
		// 야간 작업
		Case 'rqcgu2'
			UPDATE PM02_CAPA_LOD
				SET BOTIME3 = (BOTIME1 + :dMin),
					 BOTIME2 = :dMin,
					 RTYPE2 = :sRqcgu
			 WHERE WKCTR = :sWkctr
				AND CLDATE = :sCldate;
	End Choose
	If sqlca.sqlcode <> 0 Then
		MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
		RollBack;
		Return
	End If
End If

/* 작업장별 부하 재조회 */
String sCode, sJocod

nRow = dw_3.GetRow()
If nRow <= 0 Then Return

sGubun = dw_3.GetItemString(nrow, 'gubun')
sWkctr = dw_3.GetItemString(nrow, 'wkctr')
sMchno = dw_3.GetItemString(nrow, 'mchno')
sCode = dw_1.GetItemString(1, 'pdtgu')
sDate = dw_1.GetItemString(1, 'yymm')
eDate = f_afterday(sdate,6)

If IsNull(sMchno) Then sMchno = ''
If IsNull(sPdtgu) Then sPdtgu = ''

If sGubun = '2' Then
	sFilter = "gubun = '1' or ( gubun = '2' and wkctr = '" + sWkctr + "' )"
Else
	sFilter = "gubun = '1'"
End If

dw_3.SetFilter(sFilter)
dw_3.Filter()

If IsNull(sCode) Or sCode = '' Then
	sPdtgu = ''
	sJocod = ''
Else
	sPdtgu = Trim(Mid(sCode, 2,6))
	sJocod = Trim(Mid(sCode, 8,6))
End If
		
dw_3.Retrieve(sDate, eDate, sPdtgu+'%', sJocod+'%')

dw_3.SetSort("wkctr, gubun, mchno")
dw_3.Sort()
		
dw_insert.Reset()

If sGubun = '1' Then
	nFind = dw_3.Find("wkctr = '" + sWkctr + "'", 1, dw_3.RowCount())
Else
	nFind = dw_3.Find("wkctr = '" + sWkctr + "' and mchno = '" + sMchno + "'", 1, dw_3.RowCount())
End If

dw_3.SelectRow(0, FALSE)
dw_3.SelectRow(nFind, TRUE)
dw_3.ScrollToRow(nFind)

WF_CHART(nFind)
wf_kunmu()
end event

type cb_2 from commandbutton within w_pm01_02020
integer x = 2574
integer y = 56
integer width = 466
integer height = 124
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "사용공수 재계산"
end type

event clicked;String sDate

sdate = dw_1.GetItemString(1, 'yymm')

If MessageBox('확인','사용공수를 다시계산하시겠습니까?',Information!, YesNo!) = 1 Then
	// 작업장 부하계산(사용공수만 재계산)
	sqlca.PM02_CAPA_LOD_WEEK(gs_sabu, sdate, '3');
	
	If sqlca.sqlcode <> 0 Then
		MessageBox(string(sqlca.sqlcode), SQLCA.SQLERRTEXT)
		ROLLBACK;
		RETURN
	END iF
	COMMIT;
	
	p_inq.TriggerEvent(Clicked!)
End If
end event

type ole_chart from uo_chartfx_ie4 within w_pm01_02020
integer x = 2176
integer y = 224
integer width = 2405
integer height = 848
integer taborder = 90
boolean bringtotop = true
string binarykey = "w_pm01_02020.win"
end type

type rb_1 from radiobutton within w_pm01_02020
boolean visible = false
integer x = 4672
integer y = 780
integer width = 352
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "계획정보"
boolean checked = true
end type

event clicked;dw_insert.DataObject = 'd_pm01_02020_3'
dw_insert.SetTransObject(sqlca)

p_mod.picturename = 'C:\erpman\image\저장_up.gif'
p_mod.enabled = true

end event

type rb_2 from radiobutton within w_pm01_02020
boolean visible = false
integer x = 5097
integer y = 788
integer width = 352
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "부하정보"
end type

event clicked;dw_insert.DataObject = 'd_pm01_02020_3_capa'
dw_insert.SetTransObject(sqlca)

p_mod.picturename = 'C:\erpman\image\저장_d.gif'
p_mod.enabled = false

end event

type pb_1 from u_pb_cal within w_pm01_02020
integer x = 658
integer y = 36
integer taborder = 10
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_1.SetColumn('yymm')
IF IsNull(gs_code) THEN Return
dw_1.SetItem(1, 'yymm', gs_code)
dw_1.triggerevent(itemchanged!)
end event

type dw_4 from datawindow within w_pm01_02020
integer x = 46
integer y = 1772
integer width = 4507
integer height = 516
integer taborder = 31
boolean bringtotop = true
string title = "none"
string dataobject = "d_pm01-02020_5_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type st_3 from statictext within w_pm01_02020
integer x = 78
integer y = 1704
integer width = 325
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 32106727
string text = "[BOM 기준]"
boolean focusrectangle = false
end type

type p_1 from picture within w_pm01_02020
boolean visible = false
integer x = 3182
integer y = 20
integer width = 178
integer height = 144
boolean bringtotop = true
boolean enabled = false
string picturename = "C:\erpman\image\인쇄_d.gif"
boolean focusrectangle = false
end type

event clicked;string ls_yymm1,ls_yymm2, ls_kunmu, ls_wkctr
int ikun,ibotime

ls_yymm1 = dw_1.GetItemString(1, 'yymm')
If Trim(ls_yymm1) = '' OR IsNull(ls_yymm1) Then Return

ls_yymm2 = f_afterday(ls_yymm1,6)


SELECT COUNT(CLDATE) INTO :ikun
  FROM (SELECT CLDATE AS CLDATE FROM P4_CALENDAR
		   WHERE WORKGUB <> '9'
			  AND CLDATE BETWEEN :ls_yymm1 AND :ls_yymm2
		   GROUP BY CLDATE );
If IsNull(ikun) Then iKun = 0

ls_yymm2 = right(ls_yymm2,2)
dw_print.Modify("yymm.Text = '" + string(ls_yymm1 ,'@@@@.@@/@@')+'-'+ string(ls_yymm2 ,'@@')+ "'")
dw_print.Modify("kunmu.text = '" + string(ikun,'#0') + "'")

OpenWithParm(w_print_preview, dw_print)
end event

type dw_print from datawindow within w_pm01_02020
integer x = 1024
integer y = 2592
integer width = 402
integer height = 288
integer taborder = 120
boolean bringtotop = true
string title = "none"
string dataobject = "d_pm01_02020_3_print"
boolean border = false
boolean livescroll = true
end type

type rr_4 from roundrectangle within w_pm01_02020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 1768
integer width = 4530
integer height = 536
integer cornerheight = 40
integer cornerwidth = 55
end type


Start of PowerBuilder Binary Data Section : Do NOT Edit
0Ew_pm01_02020.bin 
2900001600e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000200000001fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffd00000004fffffffe00000005fffffffe00000006000000070000000800000009fffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff0000000300000000000000000000000000000000000000000000000000000000b1ea8ab001d6026c0000000300000a400000000000500003004c004200430049004e0045004500530045004b000000590000000000000000000000000000000000000000000000000000000000000000000000000002001cffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000006a0000000000500003004f0042005800430054005300450052004d0041000000000000000000000000000000000000000000000000000000000000000000000000000000000002001affffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000fffffffe0000000000000000004200500043004f00530058004f00540041005200450047000000000000000000000000000000000000000000000000000000000000000000000000000000000101001a00000002000000010000000421f498a211d2bfa910009ca8dabd624b00000000b1e9a05001d6026cb1ea8ab001d6026c00000000000000000000000000000001fffffffe000000030000000400000005000000060000000700000008000000090000000a0000000b0000000c0000000d0000000e0000000f000000100000001100000012000000130000001400000015000000160000001700000018000000190000001a0000001b0000001c0000001d0000001e0000001f000000200000002100000022000000230000002400000025000000260000002700000028fffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
2Cffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00610061006100610069006b00620063006500650061006a0069006a006d00740067006a006d00730067006700740073006c0067006d0071007100680074006d0067006a00740074006f00680073006a0066006a006d006800690067006e006a007200610074006a000000000000000000000000000000000000000000000000000003000000365d000015e948435f5f465452415f5f3458040005002ebf0f0000020000000246a8ffff00000032ff7f001e002c0000001e00000004000000000050000000000001000020840000031000020004000000000000000000000000000b002000010003000000000001005a0000000000030000000000010000008000000008007f000000000000000000000000c024000000000000c0240000000000003ff000000000000000000000000000004059000000000002000000003828000280010000000000000000000000003ff00000000000000000000180000010000000018000001000000000000000000000000000000000000000000000000000000000c024000000000000c0240000000000003ff0000000000000000000000000000040590000000000000000000038280002000100000000000200000000000000000000000000003ff000010000001000000001800000100000000080000000000000000000000000000000000000000000000000000000000000003ff0006f00430074006e006e00650073007400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020012ffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000002000009c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000bff00000000000003ff000000000000000000000000000004059000000000000000000003828000200010000000040440000000000003ff00000000000000000000180000010000000018000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003ff00000ffffffff7fefffffffffffffffefffff000000000000000038680002000100000000000200000000000000000000000000003ff000010000001000000001800000100000000080000000000000000000000000000000000000000000000800000000010000010100000f010000108000000000c40031030000ffffff00ff99990066339900ccffff00ffffcc00660066008080ff00cc660000ffcccc0080000000ff00ff0000ffff00ffff0000800080000000800080800000ff000000ffcc0000ffffcc00ccffcc0099ffff00ffcc9900ffffcc00ccffcc0099ffff00ffcc9900cc99ff00ff99cc0099ccff00ff663300cccc330000cc990000ccff000099ff000066ff00996666009696960066330000669933000033000000333300003399006633990099333300333333000000ff0000ff0000ff0000000000800100000701000002010000030100000401000005010000060100000701000008010000090100000a0100000b0100000c0100000d0100000e0100000f0100001000ffffff00ffffff00ffffff00ffffff00ffffff00ffffff00ffffff00ffffff00ffffff00ffffff00ffffff00ffffff00ffffff00ffffff00ffffff00ffffff000000000000000000000000200000080000000060000008000000000000000800000000100000080041000500690072006c00610001424400000000000001900000000000000000000000000000000000000008000000000000000800000000000000080000000000000008000000000000000800000000000a000c000000000000000800000000000000080000000000000008000000050000000200000000000000000000000500000002000000000000000000000000000000070000000000000000000000000000000000000000000000000000000000000000010008ff00000000000000000000000000000000000000000000000000030100000076030006000000000000b1000001f555c42aa111d3440450005dff6451a7010000ff0000010055c42ab111d344f550005da16451a7040000ffff00010002c42ab100d344f555005da11151a7045000ffff6401000300
222ab1000044f555c45da111d3a7045000ffff645100040000b1000001f555c42aa111d3440450005dff6451a7050000ff0000010055c42ab111d344f550005da16451a7040000ffff01000601c435000098f39f373b9c11d14d24a000ffff2029000100000000000273677300001c00680045006b73450150000002200000016e0001ffff0068001276000126000001216e41001061746f6e54206574626c6f6fffff72610126006901217601001000006f6e6e41657461746f6f54207261626c006affff76020126000001216e41001061746f6e54206574626c6f6fffff72610000ffff0007731031000001f39f37c49c11d19824a0003bff20294d2b0000ffe000003003000001100000020001c0730000010000020d000000d3000001bf000000010000020d000000d30053000d0065697265654c2073646e6567ffff0006ffffffffffffffffffffffff0008ffff0028010000280000000200000028000000280000004d000000180000ffff0000ffffffff0201ffff00024000ffff00007312ffff0001000837c43300d198f39f003b9c11294d24a000ffff2000708b0000007006000100000973120001000000d40000001d0000020100000001000000d40000001e000002070000006f6f54007261626cffff0006ffffffff01d5ffff00330000000f000001cd800001a20000fff000000028ffff0028000000190000001c0000ffff0000ffffffff0046ffff0002400001020000000100000003000000010000000300000044000000090000000000041500000601000973c431000098f39f373b9c11d14d24a000ffff202970ab0000003000000100000073150000000000090000001e000002d400000035000000010000001e000002d4000000366150000a726574747261426effff0006ffffffffffffffffffffffff000fffff0028800000280000ffff00000016ffff001600000016000000160000ffff0000ffffffff0140ffff00024000731400000001000a37c43100d198f39f003b9c11294d24a000ffff200070ab000000300000010000097314001e000000d400000035000002010000001e000000d4000000360000020a0000006c6150006574746506726142ffffff00ffffffffffffffffffffffff00000fff0000288000002800ffffff00000016ff000016000000160000001600ffffff00ffffffff000140ff000002400b730f00000001009f37c43111d198f3a0003b9c20294d240000ffff0000302b000000a00000020302d4730f001e000002d4000001bf000002d30000001e000002d4000001bf0000000600006567654c0006646effffffffffffffffffffffffffffffff0100000800000028000000280000000200000028000000280000000000000018ffffffffffffffff4000030100000002000c731333000001f39f37c49c11d19824a0003bff20294d8b0000ff1006007200000000130000010000097300001e0000028600000038000000010000001e0000028600000039004d00040006756e65ffffff00ffffffff0000e6ff0000300000000f000000de8000003d00fffff000000028ff000028000000150000001900ffffff00ffffffff000046ff0000024000010400000001000000030000000100000003000c8084000400040006000000ffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1Ew_pm01_02020.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
