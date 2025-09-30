$PBExportHeader$w_pdt_02210.srw
$PBExportComments$** 할당변경신청등록
forward
global type w_pdt_02210 from w_inherite
end type
type dw_1 from datawindow within w_pdt_02210
end type
type pb_1 from u_pb_cal within w_pdt_02210
end type
type rr_1 from roundrectangle within w_pdt_02210
end type
end forward

global type w_pdt_02210 from w_inherite
string title = "할당 변경 신청 등록"
dw_1 dw_1
pb_1 pb_1
rr_1 rr_1
end type
global w_pdt_02210 w_pdt_02210

type variables
string  is_purgc    = 'N' //작업지시에 외주 구분(Y:외주)
string  is_purgc2  = 'N' //작업지시공정에 외주 구분(Y:외주)
string  is_wiogbn //외주인 경우 할당구분(출고구분) -외주사급출고 
string  is_iogbn  //생산 할당구분(출고구분) - 생산자동출고
string  is_holdgu //작지시 할당구분(1:자재소진,2:출고요청)


end variables

forward prototypes
public subroutine wf_reset ()
public function integer wf_check (long ll_row, integer gub)
public function integer wf_required_chk (integer i, string s_deptno)
public function integer wf_holdstock_exchange (string sdept, string sempno, string sdate)
end prototypes

public subroutine wf_reset ();dw_1.setredraw(false)
dw_insert.setredraw(false)

dw_1.reset()
dw_insert.reset()

dw_1.insertrow(0)
dw_1.SetFocus()

dw_1.setredraw(true)
dw_insert.setredraw(true)

end subroutine

public function integer wf_check (long ll_row, integer gub);decimal {3} d_qty, d_addqty, d_isqty

dw_insert.accepttext()

d_qty = dw_insert.GetItemDecimal(ll_row, 'hold_qty')
d_addqty = dw_insert.GetItemDecimal(ll_row, 'addqty')
d_isqty = dw_insert.GetItemDecimal(ll_row, 'isqty')

if isnull(d_qty) or d_qty = 0 then return 1
if isnull(d_addqty) or d_addqty = 0 then return 1

if isnull(d_isqty) then d_isqty = 0 

if d_qty + d_addqty  < d_isqty then 
	if gub = 1 then 
   	f_message_chk(65,'[소요수량]')
	   dw_insert.SetItem(ll_row,"hold_qty",0)
		dw_insert.Setcolumn("hold_qty")
		dw_insert.SetFocus()
		return -1
	else  
   	f_message_chk(65,'[추가소요량]')
      dw_insert.SetItem(ll_row,"addqty",0)
		dw_insert.Setcolumn("addqty")
		dw_insert.SetFocus()
		return -1
   end if
end if

return 1
end function

public function integer wf_required_chk (integer i, string s_deptno);decimal {3} d_addqty, d_oldqty

if dw_insert.GetItemString(i,'opt') <> 'Y' then return 1

d_oldqty =  dw_insert.GetItemDecimal(i,'old_addqty')
d_addqty =  dw_insert.GetItemDecimal(i,'addqty')

if isnull(d_oldqty) then d_oldqty = 0
if isnull(d_addqty) then d_addqty = 0

if dw_insert.GetItemString(i, 'Flag') = 'N' then //변경시
	if d_oldqty = d_addqty then
		messagebox("확 인", "추가소요량이 변경되지 않았으니 수량을 확인하세요!")
		dw_insert.ScrollToRow(i)
		dw_insert.Setcolumn("addqty")
		dw_insert.SetFocus()
		return -1
	end if
	
	/* 2000.09.30 손영우 수정
		원가계산서 상의 Loss계산하려고 수정
		동일한 할당을 기준으로 하면 할당+추가가 되므로 출력물 작성시 출고자료를 기준으로
		추가분 소요량인지 구분을 못함 */
	
	if d_addqty > 0 then
		Messagebox("할당", "작업지시시 할당된 내역은 Minus만 가능합니다")
		return 1
	end if
	
	/*	---- */
	
	dw_insert.SetItem(i, 'upd_user', gs_userid)
else   //추가시 
	if isnull(dw_insert.GetItemString(i,'itnbr')) or &
		trim(dw_insert.GetItemString(i,'itnbr')) = "" then
		f_message_chk(1400,'[ '+string(i)+' 행 품번]')
		dw_insert.ScrollToRow(i)
		dw_insert.SetColumn('itnbr')
		dw_insert.SetFocus()
		return -1		
	end if	
	
	if isnull(dw_insert.GetItemString(i,'pspec')) or &
		trim(dw_insert.GetItemString(i,'pspec')) = "" then
		dw_insert.SetItem(i, 'pspec', '.')
	else
		dw_insert.SetItem(i, 'pspec', trim(dw_insert.GetItemString(i,'pspec')))
	end if	
	
	if isnull(dw_insert.GetItemString(i,'opseq')) or &
		dw_insert.GetItemString(i,'opseq') = "" then
		f_message_chk(1400,'[ '+string(i)+' 행 사용공정]')
		dw_insert.ScrollToRow(i)
		dw_insert.SetColumn('opseq')
		dw_insert.SetFocus()
		return -1		
	end if	
	
	if is_holdgu = '1' and ( isnull(dw_insert.GetItemString(i,'hold_store')) or &
		dw_insert.GetItemString(i,'hold_store') = ""  )then
		f_message_chk(1400,'[ '+string(i)+' 행 출고창고]')
		dw_insert.ScrollToRow(i)
		dw_insert.SetColumn('hold_store')
		dw_insert.SetFocus()
		return -1		
	end if	

	if is_holdgu = '1' and (isnull(dw_insert.GetItemString(i,'out_store')) or &
		dw_insert.GetItemString(i,'out_store') = ""  ) then
		f_message_chk(1400,'[ '+string(i)+' 행 입고창고]')
		dw_insert.ScrollToRow(i)
		dw_insert.SetColumn('out_store')
		dw_insert.SetFocus()
		return -1		
	end if

	if is_holdgu = '2' and (isnull(dw_insert.GetItemString(i,'in_store')) or &
		dw_insert.GetItemString(i,'in_store') = ""  ) then
		f_message_chk(1400,'[ '+string(i)+' 행 입고창고]')
		dw_insert.ScrollToRow(i)
		dw_insert.SetColumn('in_store')
		dw_insert.SetFocus()
		return -1		
	end if
	
	/* 2000.09.30 손영우 수정
	원가계산서 상의 Loss계산하려고 수정
	동일한 할당을 기준으로 하면 할당+추가가 되므로 출력물 작성시 출고자료를 기준으로
	추가분 소요량인지 구분을 못함 (추가되는 소요량은 추가소요량에만 입력되고 Minus는 허용
	안함 */
	
	if d_addqty < 0 or d_addqty = 0 then
		messagebox("확 인", "추가소요량을 입력하세요")
		dw_insert.ScrollToRow(i)
		dw_insert.Setcolumn("addqty")
		dw_insert.SetFocus()
		return -1
	end if
	
	/* ---------------- */

	if isnull(dw_insert.GetItemString(i,'rqdat')) or &
		dw_insert.GetItemString(i,'rqdat') = "" then
		f_message_chk(1400,'[ '+string(i)+' 행 출고요구일]')
		dw_insert.ScrollToRow(i)
		dw_insert.SetColumn('rqdat')
		dw_insert.SetFocus()
		return -1		
	end if	

	dw_insert.SetItem(i, 'req_dept', s_deptno)
	dw_insert.SetItem(i, 'crt_user', gs_userid)
end if

if isnull(dw_insert.GetItemString(i,'chcod')) or &
	dw_insert.GetItemString(i,'chcod') = "" then
	f_message_chk(1400,'[ '+string(i)+' 행 변경원인]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('chcod')
	dw_insert.SetFocus()
	return -1		
end if	

Return 1
end function

public function integer wf_holdstock_exchange (string sdept, string sempno, string sdate);long   lcount, i, lcnt
string sholdno, schcod, srmks
dec{3} add_qty, old_qty, dqty

lcount = dw_insert.rowcount()

FOR i = 1 TO lcount
	if dw_insert.GetItemString(i,'opt') = 'Y' then 
		sholdno = trim(dw_insert.GetItemString(i,'hold_no'))
		schcod  = trim(dw_insert.GetItemString(i,'chcod'))
		srmks   = trim(dw_insert.GetItemString(i,'rmks'))
		dqty = dw_insert.GetItemDecimal(i,'addqty')

		// 동일한 할당번호에 대한 변경이력이 있는 경우에는 이전이력은 삭제하고
		// 최종이력만 작성한다.
		Lcnt = 0
		Select count(*) into :Lcnt
		  from holdstock_exchange
		 where sabu = :gs_sabu and hold_no = :sholdno;
		 
		if Lcnt > 0 then
		  Delete from holdstock_exchange
		 where sabu = :gs_sabu and hold_no = :sholdno;			
		End if
		
		
	   INSERT INTO "HOLDSTOCK_EXCHANGE"  
					( "SABU",         "YODAT",        "HOLD_NO",        "CHQTY",   
					  "CHCOD",        "RMKS",         "DPTNO",          "EMPNO" )  
		  VALUES ( :gs_sabu,      :sdate,         :sholdno,         :dqty,
		           :schcod,        :srmks,         :sdept,           :sempno)  ;

	   IF SQLCA.SQLNROWS <= 0 OR SQLCA.SQLCODE <> 0	THEN	
			RETURN -1
		END IF
		
	end if
NEXT

Return 1
end function

on w_pdt_02210.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.pb_1=create pb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.rr_1
end on

on w_pdt_02210.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.pb_1)
destroy(this.rr_1)
end on

event open;call super::open;dw_1.SetTransObject(sqlca)
dw_1.insertrow(0)
dw_1.setitem(1, 'sdate', is_today )
dw_1.SetFocus()

//작지시 할당구분(1:자재소진,2:출고요청), 자재소진인 경우 입고창고는 out_store, 출고요청은 in_store임
select dataname into :is_holdgu from syscnfg where sysgu = 'Y' and serial = 15 and lineno = 8;
If IsNull(is_holdgu) Then is_holdgu = '1'
If is_holdgu = '1' Then
	dw_insert.DataObject = 'd_pdt_02210_02'
Else
	dw_insert.DataObject = 'd_pdt_02210_03'
End If
dw_insert.SetTransObject(sqlca)

IF f_change_name('1') = 'Y' then 
	dw_insert.object.ispec_t.text = f_change_name('2')
	dw_insert.object.jijil_t.text = f_change_name('3')
END IF

/* 외주출고 에 대한 출고구분을 검색 (외주사급출고는 1개이어야 한다). */
Select iogbn into :is_wiogbn from iomatrix 
 where sabu = :gs_sabu and autvnd = 'Y';	
 
if sqlca.sqlcode <> 0  then
   Messagebox("사급구분", "외주사급구분 출고구분 검색시 오류발생", stopsign!)
end if			 

/* 생산출고 에 대한 출고구분을 검색 (생산자동출고는 1개이어야 한다). */
Select iogbn into :is_iogbn from iomatrix 
 where sabu = :gs_sabu and autpdt = 'Y';		
 
if sqlca.sqlcode <> 0  then
	Messagebox("생산출고", "생산자동출고 출고구분 검색시 오류발생", stopsign!)
end if

end event

event key;// Page Up & Page Down & Home & End Key 사용 정의
choose case key
	case keypageup!
		dw_insert.scrollpriorpage()
	case keypagedown!
		dw_insert.scrollnextpage()
	case keyhome!
		dw_insert.scrolltorow(1)
	case keyend!
		dw_insert.scrolltorow(dw_insert.rowcount())
	case KeyupArrow!
		dw_insert.scrollpriorrow()
	case KeyDownArrow!
		dw_insert.scrollnextrow()		
end choose


end event

type dw_insert from w_inherite`dw_insert within w_pdt_02210
integer x = 46
integer y = 284
integer width = 4553
integer height = 2036
integer taborder = 20
string dataobject = "d_pdt_02210_03"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
borderstyle borderstyle = stylelowered!
end type

event dw_insert::ue_pressenter;Send(Handle(this),256,9,0)
Return 1

end event

event dw_insert::itemchanged;string  snull, sitnbr, sitdsc, sispec, s_date, s_depot, spitnbr, s_opseq, get_dept, &
        spurgc, scvcod, spordno, scvnm, sjijil, sispec_code
integer ireturn 
long    lrow
decimal {3} d_qty, d_jego, d_usejego

//if dw_1.accepttext() = -1 then return 
//if this.accepttext() = -1 then return 

SetNull(snull)
lrow = this.getrow()

IF this.GetColumnName() = "itnbr"	THEN
   sItnbr = trim(this.GetText())
	if 	sitnbr = "" or isnull(sitnbr) then 
		this.setitem(lrow, "itdsc", snull)	
		this.setitem(lrow, "ispec", snull)
		this.setitem(lrow, "jijil", snull)	
		this.setitem(lrow, "ispec_code", snull)
		this.setitem(lrow, "jego", 0)
		this.setitem(lrow, "usejego", 0)
      	return 
	end if	
	ireturn = f_get_name4('품번', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)
	this.setitem(lrow, "itnbr", sitnbr)	
	this.setitem(lrow, "itdsc", sitdsc)	
	this.setitem(lrow, "ispec", sispec)
	this.setitem(lrow, "jijil", sjijil)	
	this.setitem(lrow, "ispec_code", sispec_code)
   IF 	ireturn = 0 THEN 
		If is_holdgu = '1' Then 
			s_depot = this.getitemstring(lrow, 'hold_store')
		Else
			s_depot = this.getitemstring(lrow, 'out_store')
		End If
      if 	trim(s_depot) = '' or isnull(s_depot) then 
			this.setitem(lrow, "jego", 0)
			this.setitem(lrow, "usejego", 0)
		else	
			d_jego    = SQLCA.ERP000000110(s_depot, sitnbr, '.', '1') 
			d_usejego = SQLCA.ERP000000110(s_depot, sitnbr, '.', '2') 
			this.setitem(lrow, "jego",    d_jego)
			this.setitem(lrow, "usejego", d_usejego)
      end if
   ELSE
		this.setitem(lrow, "jego", 0)
		this.setitem(lrow, "usejego", 0)
	END IF	
	RETURN ireturn
ELSEIF this.GetColumnName() = "itdsc"	THEN
	sItdsc = trim(this.GetText())
	if 	sitdsc = "" or isnull(sitdsc) then 
		this.setitem(lrow, "itnbr", snull)	
		this.setitem(lrow, "ispec", snull)
		this.setitem(lrow, "jijil", snull)	
		this.setitem(lrow, "ispec_code", snull)
		this.setitem(lrow, "jego", 0)
		this.setitem(lrow, "usejego", 0)
      return 
	end if	
	ireturn = f_get_name4('품명', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)
	this.setitem(lrow, "itnbr", sitnbr)	
	this.setitem(lrow, "itdsc", sitdsc)	
	this.setitem(lrow, "ispec", sispec)
	this.setitem(lrow, "jijil", sjijil)	
	this.setitem(lrow, "ispec_code", sispec_code)
   	IF 	ireturn = 0 THEN 
			If is_holdgu = '1' Then 
				s_depot = this.getitemstring(lrow, 'hold_store')
			Else
				s_depot = this.getitemstring(lrow, 'out_store')
			End If
		
			if 	trim(s_depot) = '' or isnull(s_depot) then 
			this.setitem(lrow, "jego", 0)
			this.setitem(lrow, "usejego", 0)
		else	
			d_jego    = SQLCA.ERP000000110(s_depot, sitnbr, '.', '1') 
			d_usejego = SQLCA.ERP000000110(s_depot, sitnbr, '.', '2') 
			this.setitem(lrow, "jego",    d_jego)
			this.setitem(lrow, "usejego", d_usejego)
		  end if
	ELSE
		this.setitem(lrow, "jego", 0)
		this.setitem(lrow, "usejego", 0)
	END IF	
	RETURN ireturn
ELSEIF this.GetColumnName() = "ispec"	THEN
	sIspec = trim(this.GetText())
	if sispec = "" or isnull(sispec) then 
		this.setitem(lrow, "itnbr", snull)
		this.setitem(lrow, "itdsc", snull)	
		this.setitem(lrow, "jijil", snull)	
		this.setitem(lrow, "ispec_code", snull)
		this.setitem(lrow, "jego", 0)
		this.setitem(lrow, "usejego", 0)
      return 
	end if	
	ireturn = f_get_name4('규격', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)
	this.setitem(lrow, "itnbr", sitnbr)	
	this.setitem(lrow, "itdsc", sitdsc)	
	this.setitem(lrow, "ispec", sispec)
	this.setitem(lrow, "jijil", sjijil)	
	this.setitem(lrow, "ispec_code", sispec_code)
   IF ireturn = 0 THEN 
		If is_holdgu = '1' Then 
			s_depot = this.getitemstring(lrow, 'hold_store')
		Else
			s_depot = this.getitemstring(lrow, 'out_store')
		End If
      if trim(s_depot) = '' or isnull(s_depot) then 
			this.setitem(lrow, "jego", 0)
			this.setitem(lrow, "usejego", 0)
		else	
			d_jego    		= SQLCA.ERP000000110(s_depot, sitnbr, '.', '1') 
			d_usejego 	= SQLCA.ERP000000110(s_depot, sitnbr, '.', '2') 
			this.setitem(lrow, "jego",    d_jego)
			this.setitem(lrow, "usejego", d_usejego)
      end if
	ELSE
		this.setitem(lrow, "jego", 0)
		this.setitem(lrow, "usejego", 0)
	END IF	
	RETURN ireturn
ELSEIF this.GetColumnName() = "jijil"	THEN
	sjijil = trim(this.GetText())
	if 	sjijil = "" or isnull(sjijil) then 
		this.setitem(lrow, "itnbr", snull)
		this.setitem(lrow, "itdsc", snull)	
		this.setitem(lrow, "ispec", snull)	
		this.setitem(lrow, "ispec_code", snull)
		this.setitem(lrow, "jego", 0)
		this.setitem(lrow, "usejego", 0)
      	return 
	end if	
	ireturn = f_get_name4('재질', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)
	this.setitem(lrow, "itnbr", sitnbr)	
	this.setitem(lrow, "itdsc", sitdsc)	
	this.setitem(lrow, "ispec", sispec)
	this.setitem(lrow, "jijil", sjijil)	
	this.setitem(lrow, "ispec_code", sispec_code)
   IF 	ireturn = 0 THEN 
		If is_holdgu = '1' Then 
			s_depot = this.getitemstring(lrow, 'hold_store')
		Else
			s_depot = this.getitemstring(lrow, 'out_store')
		End If
      if 	trim(s_depot) = '' or isnull(s_depot) then 
			this.setitem(lrow, "jego", 0)
			this.setitem(lrow, "usejego", 0)
		else	
			d_jego    = SQLCA.ERP000000110(s_depot, sitnbr, '.', '1') 
			d_usejego = SQLCA.ERP000000110(s_depot, sitnbr, '.', '2') 
			this.setitem(lrow, "jego",    d_jego)
			this.setitem(lrow, "usejego", d_usejego)
      end if
	ELSE
		this.setitem(lrow, "jego", 0)
		this.setitem(lrow, "usejego", 0)
	END IF	
	RETURN ireturn
ELSEIF this.GetColumnName() = "ispec_code"	THEN
	sispec_code = trim(this.GetText())
	if 	sispec_code = "" or isnull(sispec_code) then 
		this.setitem(lrow, "itnbr", snull)
		this.setitem(lrow, "itdsc", snull)	
		this.setitem(lrow, "ispec", snull)	
		this.setitem(lrow, "jijil", snull)
		this.setitem(lrow, "jego", 0)
		this.setitem(lrow, "usejego", 0)
      return 
	end if	
	ireturn = f_get_name4('규격코드', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)
	this.setitem(lrow, "itnbr", sitnbr)	
	this.setitem(lrow, "itdsc", sitdsc)	
	this.setitem(lrow, "ispec", sispec)
	this.setitem(lrow, "jijil", sjijil)	
	this.setitem(lrow, "ispec_code", sispec_code)
   IF 	ireturn = 0 THEN 
		If is_holdgu = '1' Then 
			s_depot = this.getitemstring(lrow, 'hold_store')
		Else
			s_depot = this.getitemstring(lrow, 'out_store')
		End If
      if 	trim(s_depot) = '' or isnull(s_depot) then 
			this.setitem(lrow, "jego", 0)
			this.setitem(lrow, "usejego", 0)
		else	
			d_jego    = SQLCA.ERP000000110(s_depot, sitnbr, '.', '1') 
			d_usejego = SQLCA.ERP000000110(s_depot, sitnbr, '.', '2') 
			this.setitem(lrow, "jego",    d_jego)
			this.setitem(lrow, "usejego", d_usejego)
      end if
	ELSE
		this.setitem(lrow, "jego", 0)
		this.setitem(lrow, "usejego", 0)
	END IF	
	RETURN ireturn
ELSEIF this.GetColumnName() ="opseq" THEN  //사용공정
   s_opseq = this.Gettext()
	
	if s_opseq = '' or isnull(s_opseq) then 
		this.setitem(lrow, 'opdsc', snull)
		return 
	end if	
	
	spordno = dw_1.getitemstring(1, 'pordno')

	if is_purgc <> 'Y' then //작업지시에 외주 구분(Y:외주)==> 전체외주
		spitnbr = dw_1.getitemstring(1, 'itnbr')
		
		sitdsc = f_get_routng(spitnbr, s_opseq)

		if isnull(sitdsc) then 
			this.setitem(lrow, 'opseq', snull)
			this.setitem(lrow, 'opdsc', snull)
			return 1
		else
			this.setitem(lrow, 'opdsc', sitdsc)
		end if	
		
		//출고 창고 가져오기 
	   SELECT PURGC, WICVCOD, FUN_GET_CVNAS(WICVCOD)
        INTO :spurgc, :scvcod, :scvnm  
		  FROM MOROUT  
 		 WHERE SABU   = :gs_sabu AND  
				 PORDNO = :sPordno  AND  
				 OPSEQ  = :s_opseq  ;

      IF 	spurgc = 'Y' then 
			is_purgc2 = 'Y'  //작업지시에 공정 외주 구분(Y:외주) ==> 공정외주
			
			this.setitem(lrow, 'out_store', scvcod)
			this.setitem(lrow, 'cvnas', scvnm)
			this.setitem(lrow, 'hold_gu', is_wiogbn) //출고구분 -> 외주사급출고
      ELSE
			is_purgc2 = 'N' 
			
		  SELECT B.CVCOD, B.CVNAS2  
  	       INTO :scvcod, :scvnm  
			 FROM MOMAST A, VNDMST B  
			WHERE A.PDTGU  = B.JUMAEIP 
			  AND A.SABU   = :gs_sabu
			  AND A.PORDNO = :sPordno 
			  AND B.CVGU   = '5' 
			  AND ROWNUM   = 1 ;
			
			If is_holdgu = '1' Then
				this.setitem(lrow, 'out_store', scvcod)
			Else
				this.setitem(lrow, 'in_store', scvcod)
			End If
			this.setitem(lrow, 'cvnas', scvnm)
			this.setitem(lrow, 'hold_gu', is_iogbn) //출고구분 -> 생산자동출고
		END IF
		
	else
		IF s_opseq <> '9999' then 
			f_message_chk(86,'[공정]')
			this.setitem(lrow, 'opseq', snull)
			this.setitem(lrow, 'opdsc', snull)
			return 1
		END IF
		this.setitem(lrow, 'hold_gu', is_wiogbn)  //출고구분 -> 외주사급출고
	end if
	
ELSEIF this.GetColumnName() = "hold_store" or this.GetColumnName() = "out_store" THEN
   s_depot = trim(this.GetText())
	
	//출고요청창고
	If ( is_holdgu = '1' and GetColumnName() = "hold_store" ) Or ( is_holdgu = '2' and GetColumnName() = "out_store" ) Then
		if 	s_depot = "" or isnull(s_depot) then 
			this.setitem(lrow, "req_dept", snull)
			this.setitem(lrow, "jego", 0)
			this.setitem(lrow, "usejego", 0)
			return 
		end if	
		ireturn = f_get_name2('창고', 'Y', s_depot, sitdsc, sispec)    //1이면 실패, 0이 성공	
		this.setitem(lrow, GetColumnName(), s_depot)	
		IF 	ireturn = 0 THEN 
			sitnbr = this.getitemstring(lrow, 'itnbr')
			if 	trim(sitnbr) = '' or isnull(sitnbr) then 
				this.setitem(lrow, "jego",    0)
				this.setitem(lrow, "usejego", 0)
			else	
				d_jego    = SQLCA.ERP000000110(s_depot, sitnbr, '.', '1') 
				d_usejego = SQLCA.ERP000000110(s_depot, sitnbr, '.', '2') 
				this.setitem(lrow, "jego",    d_jego)
				this.setitem(lrow, "usejego", d_usejego)
			end if
			SELECT "VNDMST"."DEPTCODE"  
			  INTO :get_dept  
			  FROM "VNDMST"  
			 WHERE "VNDMST"."CVCOD" = :s_depot   ;
			
			this.setitem(lrow, "req_dept", get_dept)
		ELSE
			this.setitem(lrow, "req_dept", snull)
			this.setitem(lrow, "jego",    0)
			this.setitem(lrow, "usejego", 0)
		END IF	
		RETURN ireturn
	End If
	
	// 소진창고
	If ( is_holdgu = '1' and GetColumnName() = "out_store" ) Or ( is_holdgu = '2' and GetColumnName() = "hold_store" ) Then
		if 	s_depot = "" or isnull(s_depot) then 
			this.setitem(lrow, "cvnas", snull)
			return 
		end if	
		
		IF 	is_purgc = 'Y' or is_purgc2 = 'Y' THEN 
			ireturn = f_get_name2('V0', 'Y', s_depot, sitdsc, sispec)
		ELSE
			ireturn = f_get_name2('창고', 'Y', s_depot, sitdsc, sispec)
		END IF
		
		this.setitem(lrow, GetColumnName(), s_depot)	
		this.setitem(lrow, "cvnas", sitdsc)	
		RETURN ireturn		
	End If
ELSEIF this.GetColumnName() = "in_store" THEN  //소진창고:할당이 출고요청인 경우 사용
  	s_depot = trim(this.GetText())
	if 	s_depot = "" or isnull(s_depot) then 
		this.setitem(lrow, "cvnas", snull)
      return 
	end if	
	
	IF 	is_purgc = 'Y' or is_purgc2 = 'Y' THEN 
		ireturn = f_get_name2('V0', 'Y', s_depot, sitdsc, sispec)
	ELSE
		ireturn = f_get_name2('창고', 'Y', s_depot, sitdsc, sispec)
	END IF
	
	this.setitem(lrow, "out_store", s_depot)	
	this.setitem(lrow, "cvnas", sitdsc)	
	RETURN ireturn
ELSEIF this.GetColumnName() ="addqty" THEN  //추가소요량
   d_qty = dec(this.Gettext())

	/* 2000.09.30 손영우 수정
		원가계산서 상의 Loss계산하려고 수정
		동일한 할당을 기준으로 하면 할당+추가가 되므로 출력물 작성시 출고자료를 기준으로
		추가분 소요량인지 구분을 못함 */
	
	if getitemdecimal(lrow, "hold_qty") > 0 then
//		if d_qty > 0 then
//			Messagebox("할당", "작업지시시 할당된 내역은 Minus만 가능합니다")             // 최영진.2003.10.23
//			this.setitem(Lrow, "addqty", 0)
//			return 1
//		end if
	else 
		if 	d_qty < 0 then
			Messagebox("할당", "작업지시시 추가된 내역은 Plus만 가능합니다")
			this.setitem(Lrow, "addqty", 0)
			return 1
		end if		
	end if
	if 	d_qty = 0 or isnull(d_qty) then return 
   if 	wf_check(lrow, 2) = -1 then return 1
ELSEIF this.GetColumnName() ="rqdat" THEN  //출고요구일
	s_date = Trim(this.Gettext())
	IF 	s_date ="" OR IsNull(s_date) THEN RETURN
	
	IF 	f_datechk(s_date) = -1 THEN
		f_message_chk(35,'[출고요구일]')
		this.SetItem(lrow,"rqdat",snull)
		this.Setcolumn("rqdat")
		this.SetFocus()
		Return 1
	ELSE
		IF 	s_date < f_today() then 
			f_message_chk(64,'[출고요구일]')
			this.SetItem(lrow,"rqdat",snull)
			this.Setcolumn("rqdat")
			this.SetFocus()
			Return 1
		END IF
	END IF
END IF	


end event

event dw_insert::itemerror;RETURN 1
end event

event dw_insert::ue_key;str_itnct str_sitnct
string snull

setnull(gs_code)
setnull(snull)

IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
	IF This.GetColumnName() = "itnbr" Then
		open(w_itemas_popup2)
		if isnull(gs_code) or gs_code = "" then return
		
		this.SetItem(this.getrow(),"itnbr",gs_code)
		this.TriggerEvent(ItemChanged!)
	End If
END IF

end event

event dw_insert::rbuttondown;Integer iCurRow
string  sitnbr

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

iCurRow = this.GetRow()
IF this.GetcolumnName() ="itnbr" THEN
	Open(w_itemas_popup)
	IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	
	this.SetItem(iCurRow,"itnbr",gs_code)
	this.TriggerEvent(ItemChanged!)
	Return 1
ELSEIF this.GetColumnName() = "itdsc"	THEN
	gs_codename = this.GetText()
	
	open(w_itemas_popup)
	IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	
	this.SetItem(iCurRow,"itnbr",gs_code)
	this.SetColumn("itnbr")
	this.SetFocus()
	
	this.TriggerEvent(ItemChanged!)
	Return 1
ELSEIF this.GetColumnName() = "ispec"	THEN
	gs_gubun = this.GetText()
	
	open(w_itemas_popup)
	IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	
	this.SetItem(iCurRow,"itnbr",gs_code)
	this.SetColumn("itnbr")
	this.SetFocus()
	
	this.TriggerEvent(ItemChanged!)
	Return 1
ELSEIF this.GetColumnName() = "opseq"	THEN
   if dw_1.accepttext() = -1 then return 
	sitnbr = dw_1.GetItemString(1,"itnbr")
	IF sitnbr = "" OR IsNull(sitnbr) THEN
		MessageBox("확 인","작업지시번호에 표준 품번이 등록되지않았습니다!!")
		Return
	ELSE
		OpenWithParm(w_routng_popup, sitnbr)
		IF IsNull(Gs_Code) or gs_code = '' THEN RETURN
		this.SetItem(icurrow,"opseq",Gs_Code)
		this.triggerevent(itemchanged!)
	End If	
ELSEIF this.GetColumnName() = 'out_store'	Or this.GetColumnName() = 'in_store' THEN
	    
	/* 관련처코드 구분에 따른 거래처구분을 setting */
	IF is_purgc = 'Y' or is_purgc2 = 'Y' THEN 
		open(w_vndmst_popup)
	ELSE
		open(w_vndmst_46_popup)
	END IF

	if Isnull(gs_code) or Trim(gs_code) = "" then return		
	
	this.SetItem(iCurRow, GetColumnName(), gs_code)
	
	this.TriggerEvent("itemchanged")
END IF
end event

type p_delrow from w_inherite`p_delrow within w_pdt_02210
integer y = 5000
end type

type p_addrow from w_inherite`p_addrow within w_pdt_02210
integer y = 5000
end type

type p_search from w_inherite`p_search within w_pdt_02210
integer y = 5000
end type

type p_ins from w_inherite`p_ins within w_pdt_02210
integer x = 3909
end type

event p_ins::clicked;call super::clicked;string s_pordno, s_today, shold_no, left_hold, shold_gu, sgub, scvcod, scvnm 
int i, il_currow, il_RowCount, i_hold 
long lhold_no

if dw_1.AcceptText() = -1 then return 
if dw_insert.AcceptText() = -1 then return 

SetPointer(HourGlass!)

s_pordno = trim(dw_1.GetItemString(1,'pordno'))

if isnull(s_pordno) or s_pordno = "" then
	f_message_chk(30,'[작업지시번호]')
	dw_1.Setcolumn('pordno')
	dw_1.SetFocus()
	return
end if	

is_purgc = 'N'
is_purgc2 = 'N'

SELECT PURGC, CVCOD, FUN_GET_CVNAS(CVCOD)
  INTO :is_purgc, :scvcod, :scvnm
  FROM MOMAST A
 WHERE A.SABU = :gs_sabu AND A.PORDNO = :s_pordno  ;

if sqlca.sqlcode <> 0 then 
	messagebox("확 인", "작업지시번호를 확인하세요!")
	dw_1.Setcolumn('pordno')
	dw_1.SetFocus()
	return
end if	

il_currow = dw_insert.RowCount() 

if il_currow <= 0 then
	s_today = f_today()
	lHold_no = sqlca.fun_junpyo(gs_sabu, s_today, 'B0')
   shold_no = s_today + string(lHold_no, '0000') + '001'

	SELECT "IOMATRIX"."IOGBN", "IOMATRIX"."NAOUGU"   
     INTO :shold_gu, :sgub  
     FROM "IOMATRIX"  
    WHERE ( "IOMATRIX"."SABU" = :gs_sabu ) AND ( "IOMATRIX"."AUTPDT" = 'Y' )   ;

	if sqlca.sqlcode <> 0 then 
		f_message_chk(41, '')
		return 
	end if	
else
	s_today = f_today()
	left_hold = left(dw_insert.getitemstring(il_currow, 'hold_no'), 12)
	i_hold    = integer(mid(dw_insert.getitemstring(il_currow, 'hold_no'), 13, 3)) + 1
	shold_no  = left_hold + string(i_hold, '000') 
	
	shold_gu = dw_insert.getitemstring(il_currow, 'hold_gu')
	sgub     = dw_insert.getitemstring(il_currow, 'naougu')
end if	

il_currow = il_currow + 1
dw_insert.InsertRow(il_currow)

dw_insert.setitem(il_currow, 'sabu', gs_sabu )
dw_insert.setitem(il_currow, 'pordno', s_pordno )
dw_insert.setitem(il_currow, 'hold_no', shold_no )
dw_insert.setitem(il_currow, 'hold_gu', shold_gu )
dw_insert.setitem(il_currow, 'hold_date', s_today)
dw_insert.setitem(il_currow, 'naougu', sgub )
dw_insert.setitem(il_currow, 'opt', 'Y' )

//작업지시가 외주거래처인 경우
IF is_purgc = 'Y' THEN  
	dw_insert.setitem(il_currow, 'opseq', '9999' )
	dw_insert.setitem(il_currow, 'out_store', scvcod )
	dw_insert.setitem(il_currow, 'cvnas', scvnm )
END IF

ib_any_typing =True

dw_insert.ScrollToRow(il_currow)
dw_insert.SetRow(il_currow)
dw_insert.SetColumn('itnbr')
dw_insert.SetFocus()

SetPointer(Arrow!)

end event

type p_exit from w_inherite`p_exit within w_pdt_02210
integer x = 4430
end type

type p_can from w_inherite`p_can within w_pdt_02210
integer x = 4256
end type

event p_can::clicked;call super::clicked;wf_reset()
ib_any_typing = FALSE
is_purgc = 'N'
is_purgc2 = 'N'


end event

type p_print from w_inherite`p_print within w_pdt_02210
integer y = 5000
end type

type p_inq from w_inherite`p_inq within w_pdt_02210
integer x = 3735
end type

event p_inq::clicked;call super::clicked;string s_pordno

if dw_1.AcceptText() = -1 then return 

SetPointer(HourGlass!)

s_pordno = trim(dw_1.GetItemString(1,'pordno'))

if isnull(s_pordno) or s_pordno = "" then
	f_message_chk(30,'[작업지시번호]')
	dw_1.Setcolumn('pordno')
	dw_1.SetFocus()
	return
end if	

if dw_insert.Retrieve(gs_sabu, s_pordno) <= 0 then 
	f_message_chk(50,'')
	dw_1.Setcolumn('pordno')
	dw_1.SetFocus()
end if	
	
ib_any_typing = FALSE
SetPointer(Arrow!)
end event

type p_del from w_inherite`p_del within w_pdt_02210
integer y = 5000
end type

type p_mod from w_inherite`p_mod within w_pdt_02210
integer x = 4082
end type

event p_mod::clicked;call super::clicked;STRING s_Pordno, s_deptno, s_empno, s_date
Long   i, lcount

if dw_insert.AcceptText() = -1 then return 
if dw_1.AcceptText() = -1 then return 

lcount = dw_insert.rowcount()

if lcount <= 0 then	return 

s_pordno = trim(dw_1.GetItemString(1,'pordno'))
s_deptno = trim(dw_1.GetItemString(1,'deptno'))
s_empno  = trim(dw_1.GetItemString(1,'empno'))
s_date   = trim(dw_1.GetItemString(1,'sdate'))

if isnull(s_pordno) or s_pordno = "" then
	f_message_chk(30,'[작업지시번호]')
	dw_1.Setcolumn('pordno')
	dw_1.SetFocus()
	return
end if	
if isnull(s_deptno) or s_deptno = "" then
	f_message_chk(30,'[요청부서]')
	dw_1.Setcolumn('deptno')
	dw_1.SetFocus()
	return
end if	
if isnull(s_empno) or s_empno = "" then
	f_message_chk(30,'[요청자]')
	dw_1.Setcolumn('empno')
	dw_1.SetFocus()
	return
end if	
if isnull(s_date) or s_date = "" then
	f_message_chk(30,'[요청일]')
	dw_1.Setcolumn('sdate')
	dw_1.SetFocus()
	return
end if	

FOR i = 1 TO lcount
	IF wf_required_chk(i, s_deptno) = -1 THEN RETURN
NEXT

if f_msg_update() = -1 then return

if dw_insert.update() = 1 then
	if wf_holdstock_exchange(s_deptno, s_empno, s_date) = -1 then 
		rollback ;
		messagebox("저장실패", "할당변경 신청내역에서 저장을 실패하였습니다.")
		return 
	end if	
	
	w_mdi_frame.sle_msg.text = "자료가 저장되었습니다!!"
	ib_any_typing= FALSE
	commit ;
else
	rollback ;
	messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
end if	

p_inq.TriggerEvent(Clicked!)

end event

type cb_exit from w_inherite`cb_exit within w_pdt_02210
integer x = 4302
integer y = 5000
integer taborder = 70
end type

type cb_mod from w_inherite`cb_mod within w_pdt_02210
integer x = 3598
integer y = 5000
integer taborder = 50
end type

type cb_ins from w_inherite`cb_ins within w_pdt_02210
integer x = 3255
integer y = 5000
integer taborder = 40
string text = "추가(&A)"
end type

type cb_del from w_inherite`cb_del within w_pdt_02210
integer x = 1312
integer y = 5000
boolean enabled = false
end type

event cb_del::clicked;call super::clicked;//long i, irow, irow2
//
//if dw_1.AcceptText() = -1 then return 
//if dw_insert.AcceptText() = -1 then return 
//
//if dw_insert.rowcount() <= 0 then
//	f_Message_chk(31,'[삭제 행]')
//	return 
//end if	
//
//irow = dw_insert.getrow() - 1
//irow2 = dw_insert.getrow() + 1
//if irow > 0 then   
//	FOR i = 1 TO irow
//		IF wf_required_chk(i) = -1 THEN RETURN
//	NEXT
//end if	
//
//FOR i = irow2 TO dw_insert.RowCount()
//	IF wf_required_chk(i) = -1 THEN RETURN
//NEXT
//
//if f_msg_delete() = -1 then return
//
//dw_insert.DeleteRow(0)
//
//if dw_insert.update() = 1 then
//	w_mdi_frame.sle_msg.text =	"자료를 삭제하였습니다!!"	
//	ib_any_typing = false
//	commit ;
//else
//	rollback ;
//   messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
//	return 
//end if	
//
//cb_inq.TriggerEvent(Clicked!)
//
end event

type cb_inq from w_inherite`cb_inq within w_pdt_02210
integer x = 2903
integer y = 5000
integer taborder = 30
end type

type cb_print from w_inherite`cb_print within w_pdt_02210
integer x = 1961
integer y = 2492
end type

type st_1 from w_inherite`st_1 within w_pdt_02210
end type

type cb_can from w_inherite`cb_can within w_pdt_02210
integer x = 3950
integer y = 5000
end type

type cb_search from w_inherite`cb_search within w_pdt_02210
integer x = 1326
integer y = 2520
integer width = 434
string text = ""
end type

event cb_search::clicked;call super::clicked;if dw_1.AcceptText() = -1 then return 

gs_code = trim(dw_1.GetItemString(1,'baljpno'))

if isnull(gs_code) or gs_code = "" then
	f_message_chk(30,'[발주번호]')
	dw_1.Setcolumn('baljpno')
	dw_1.SetFocus()
	return
end if	

open(w_imt_02041)
end event





type gb_10 from w_inherite`gb_10 within w_pdt_02210
integer x = 41
integer y = 5000
integer height = 144
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

type gb_button1 from w_inherite`gb_button1 within w_pdt_02210
end type

type gb_button2 from w_inherite`gb_button2 within w_pdt_02210
end type

type dw_1 from datawindow within w_pdt_02210
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 27
integer y = 16
integer width = 3698
integer height = 232
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pdt_02210_01"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event rbuttondown;///////////////////////////////////////////////////////////////////////////
setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)

IF this.GetColumnName() = "pordno"	THEN
	
   gs_code = this.GetText()
	open(w_jisi_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1, "pordno", 	 gs_Code)
   this.TriggerEvent(ItemChanged!)
   return 1
elseif this.getcolumnname() = "deptno" then //부서
	open(w_vndmst_4_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.object.deptno[1] = gs_code
	this.object.deptnm[1] = gs_codename
elseif this.getcolumnname() = "empno" then //사원	
	open(w_sawon_popup)

	if isnull(gs_code) or gs_code = "" then return
	
	this.object.empno[1] = gs_code
   this.TriggerEvent(ItemChanged!)
END IF	
end event

event itemerror;RETURN 1
end event

event itemchanged;string snull, sporno, s_cod, s_nam1, s_nam2, sitnbr, sPdsts, sMatchk, get_dept, get_deptnm  
int    i_rtn

IF this.GetColumnName() = "pordno"	THEN
	sporno = trim(this.gettext())
	
	if sporno = "" or isnull(sporno) then 
   	This.setitem(1, 'itnbr', snull)
		dw_insert.reset()
 		return 
   end if

	is_purgc = 'N'
	is_purgc2 = 'N'
	
   SELECT STDITNBR, PDSTS,  PURGC, MATCHK
     INTO :sitnbr,  :sPdsts, :is_purgc, :sMatchk
     FROM MOMAST A
    WHERE ( A.SABU = :gs_sabu ) AND ( A.PORDNO = :sporno )   ;

   if SQLCA.SQLCODE = 0 then 
		if smatchk <> '2' then 
			messagebox("확 인", "할당변경신청은 작업지시 승인된 자료만 처리할 수 있습니다.")
			This.setitem(1, 'pordno', snull)
			This.setitem(1, 'itnbr', snull)
			dw_insert.reset()
			return 1
		end if	
			
		if not (sPdsts = '1' or sPdsts = '2')  then 
			messagebox("확 인", "할당변경신청은 지시상태가 지시/재생산지시인 자료만 처리할 수 있습니다.")
			This.setitem(1, 'pordno', snull)
			This.setitem(1, 'itnbr', snull)
			dw_insert.reset()
			return 1
		end if	
   	This.setitem(1, 'itnbr', sitnbr)  //표준품번
      p_inq.TriggerEvent(Clicked!)
		return 1
	else
   	f_message_chk(33,'[작업지시번호]')
   	This.setitem(1, 'pordno', snull)
   	This.setitem(1, 'itnbr', snull)
		dw_insert.reset()
		return 1
	end if
ELSEIF this.GetColumnName() = "deptno" Then	
	s_cod = trim(this.gettext())
	i_rtn = f_get_name2("부서", "Y", s_cod, s_nam1, s_nam2)
	this.object.deptno[1] = s_cod
	this.object.deptnm[1] = s_nam1
	return i_rtn
ELSEIF this.GetColumnName() = "empno" Then	
	s_cod = trim(this.gettext())
	i_rtn = f_get_name2("사번", "Y", s_cod, s_nam1, s_nam2)
	this.object.empno[1] = s_cod
	this.object.empnm[1] = s_nam1
	IF i_rtn <> 1 then 
		SELECT "P0_DEPT"."DEPTCODE", "P0_DEPT"."DEPTNAME"  
		  INTO :get_dept, :get_deptnm  
		  FROM "P1_MASTER", "P0_DEPT"  
		 WHERE ( "P1_MASTER"."COMPANYCODE" = "P0_DEPT"."COMPANYCODE"(+) ) and  
				 ( "P1_MASTER"."DEPTCODE"    = "P0_DEPT"."DEPTCODE"(+) ) and  
				 ( ( "P1_MASTER"."EMPNO"     = :s_cod ) )   ;
   
		this.object.deptno[1] = get_dept
		this.object.deptnm[1] = get_deptnm 
	END IF	
	return i_rtn
ELSEIF this.GetColumnName() = "sdate" Then	
	s_cod = trim(this.gettext())
	if IsNull(s_cod) or s_cod = "" then return 
   if f_datechk(s_cod) = -1 then
	   f_message_chk(35,"[요청일자]")
		this.object.sdate[1] = ""
	   return 1
	END IF
END IF	
end event

type pb_1 from u_pb_cal within w_pdt_02210
integer x = 3529
integer y = 104
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_1.Setcolumn('sdate')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_1.SetItem(1, 'sdate', gs_code)
end event

type rr_1 from roundrectangle within w_pdt_02210
long linecolor = 29455689
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 272
integer width = 4576
integer height = 2060
integer cornerheight = 40
integer cornerwidth = 55
end type

