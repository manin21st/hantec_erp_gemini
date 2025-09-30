$PBExportHeader$w_pdt_01010.srw
$PBExportComments$** 연동 생산계획
forward
global type w_pdt_01010 from w_inherite
end type
type dw_hidden from datawindow within w_pdt_01010
end type
type cb_2 from commandbutton within w_pdt_01010
end type
type dw_1 from datawindow within w_pdt_01010
end type
type rr_4 from roundrectangle within w_pdt_01010
end type
end forward

global type w_pdt_01010 from w_inherite
integer height = 2612
string title = "월 판매계획 접수(생산)"
dw_hidden dw_hidden
cb_2 cb_2
dw_1 dw_1
rr_4 rr_4
end type
global w_pdt_01010 w_pdt_01010

type variables
string ls_text, is_pspec, is_jijil
Long   ilby
end variables

forward prototypes
public subroutine wf_reset ()
public subroutine wf_modify (string s_gub)
public subroutine wf_jego (string arg_itnbr)
public subroutine wf_plan_janqty (string arg_itnbr, string arg_yymm)
public function integer wf_required_chk (integer i)
public subroutine wf_avg_saleqty (string arg_itnbr, string arg_yymm)
public subroutine wf_setnull ()
end prototypes

public subroutine wf_reset ();string syymm
int    get_yeacha

dw_1.setredraw(false)
dw_insert.setredraw(false)

dw_1.reset()
dw_insert.reset()

dw_1.insertrow(0)

syymm = left(is_today,6)

dw_1.setitem(1, 'syymm', syymm )

//현재월에 맞는 조정차수를 가져온다. 확정계획이 없으면 조정계획을 가져오지 못하고 
//   											 조정계획이 있으면 확정계획을 가죠오지 못한다.	
SELECT MAX("MONPLN_SUM"."MOSEQ")  
  INTO :get_yeacha  
  FROM "MONPLN_SUM"  
 WHERE ( "MONPLN_SUM"."SABU" = :gs_sabu ) AND ( "MONPLN_SUM"."MONYYMM" = :syymm ) ;

if get_yeacha = 0 or isnull(get_yeacha) then get_yeacha = 1

dw_1.setitem(1, 'jjcha', get_yeacha )
dw_1.setfocus()

dw_1.setredraw(true)
dw_insert.setredraw(true)

f_mod_saupj(dw_1, 'saupj')
f_child_saupj(dw_1, 'steam', gs_saupj)
end subroutine

public subroutine wf_modify (string s_gub);//BackGround.Color ==> 12639424:Mint, 65535:노란색, 16777215:횐색, 12632256:회색	
//                     79741120 :Button face
string snull

setnull(snull)

IF s_gub = '0' THEN
   dw_insert.DataObject ="d_pdt_01010_2" 
   dw_insert.SetTransObject(SQLCA)
ELSE
   dw_insert.DataObject ="d_pdt_01010_1" 
   dw_insert.SetTransObject(SQLCA)
END IF

IF f_change_name('1') = 'Y' then 
	dw_insert.object.ispec_t.text = is_pspec
	dw_insert.object.jijil_t.text = is_jijil
END IF


end subroutine

public subroutine wf_jego (string arg_itnbr);////////////////////////////////////////////
/* 품목별로 재고관련 사항을 가져온다.     */
/* 안전재고(MAX), 재고, 할당미처리, 재공재고   */  
////////////////////////////////////////////
String get_itnbr
Dec{3} get_maxsaf, sum_jego_qty, sum_order_qty, sum_jisi_qty, sum_valid_qty
long   lrow

SELECT "ITEMAS"."ITNBR",    "ITEMAS"."MAXSAF",  SUM(NVL("STOCK"."JEGO_QTY" , 0)), 
		 SUM(NVL("STOCK"."ORDER_QTY", 0)),	   	SUM(NVL("STOCK"."JISI_QTY" , 0)), 
		 SUM(NVL("STOCK"."VALID_QTY" , 0))   
  INTO :get_itnbr,          :get_maxsaf,     	:sum_jego_qty, 
		 :sum_order_qty,      :sum_jisi_qty,      :sum_valid_qty  
  FROM "ITEMAS", "STOCK"  
 WHERE ( "ITEMAS"."ITNBR" = "STOCK"."ITNBR" ) and  
		 ( "ITEMAS"."ITNBR" = :arg_itnbr )  
GROUP BY	"ITEMAS"."ITNBR",    "ITEMAS"."MAXSAF"	;
		
if isnull(get_itnbr) then get_itnbr = ''
		
lrow = dw_insert.getrow()

IF arg_itnbr = get_itnbr then 
	if isnull(get_maxsaf) then get_maxsaf = 0
	if isnull(sum_jego_qty) then sum_jego_qty = 0
	if isnull(sum_order_qty) then sum_order_qty = 0
	if isnull(sum_jisi_qty) then sum_jisi_qty = 0
	dw_insert.setitem(lrow, 'safmid',    get_maxsaf)    //안전재고
	dw_insert.setitem(lrow, 'jaego' ,    sum_jego_qty)  //재고
	dw_insert.setitem(lrow, 'haldangmi', sum_order_qty) //할당미처리
	dw_insert.setitem(lrow, 'jaegong',   sum_jisi_qty)  //재공재고
	dw_insert.setitem(lrow, 'valid_qty', sum_valid_qty)  //가용재고
	dw_insert.setitem(lrow, 'xsafmid',    get_maxsaf)    //안전재고
	dw_insert.setitem(lrow, 'xjaego' ,    sum_jego_qty)  //재고
	dw_insert.setitem(lrow, 'xhaldangmi', sum_order_qty) //할당미처리
	dw_insert.setitem(lrow, 'xjaegong',   sum_jisi_qty)  //재공재고
	dw_insert.setitem(lrow, 'xvalid_qty', sum_valid_qty)  //가용재고
ELSE
	dw_insert.setitem(lrow, 'safmid',    0)  //안전재고
	dw_insert.setitem(lrow, 'jaego' ,    0)  //재고
	dw_insert.setitem(lrow, 'haldangmi', 0)  //할당미처리
	dw_insert.setitem(lrow, 'jaegong',   0)  //재공재고
	dw_insert.setitem(lrow, 'valid_qty', 0)  //가용재고
	dw_insert.setitem(lrow, 'xsafmid',    0)  //안전재고
	dw_insert.setitem(lrow, 'xjaego' ,    0)  //재고
	dw_insert.setitem(lrow, 'xhaldangmi', 0)  //할당미처리
	dw_insert.setitem(lrow, 'xjaegong',   0)  //재공재고
	dw_insert.setitem(lrow, 'xvalid_qty', 0)  //가용재고
END IF	

end subroutine

public subroutine wf_plan_janqty (string arg_itnbr, string arg_yymm);/* 계획잔량을 가지고 온다.        */
String s_before_1ym
Dec{3} njqty, nyqty, sub_qty

//s_before_2ym = f_aftermonth(arg_yymm, -2)
s_before_1ym = f_aftermonth(arg_yymm, -1)

SELECT MONQTY1
  INTO :njqty
  FROM MONPLN_SUM 
 WHERE SABU = :gs_sabu AND
		 MONYYMM = :s_before_1ym AND
		 ITNBR = :arg_itnbr AND 
		 MOSEQ = (SELECT MAX(MOSEQ) FROM MONPLN_SUM
					  WHERE SABU =  :gs_sabu AND MONYYMM = :s_before_1ym AND
							  ITNBR = :arg_itnbr ) ;

SELECT YPDQTY
  INTO :nyqty
  FROM YEAPLN 
 WHERE ( SABU = :gs_sabu ) AND ( ITNBR = :arg_itnbr ) AND  
		 ( YEAYYMM = :s_before_1ym ) AND ( YEACHA = 0 )   ;

IF isnull(njqty) THEN
	njqty = 0 
END IF
IF isnull(nyqty) THEN
	nyqty = 0 
END IF

sub_qty = njqty - nyqty

dw_insert.setitem(dw_insert.getrow(), 'plnjan', sub_qty)  //계획잔량
dw_insert.setitem(dw_insert.getrow(), 'xplnjan', sub_qty)  //계획잔량



end subroutine

public function integer wf_required_chk (integer i);if dw_insert.AcceptText() = -1 then return -1

if isnull(dw_insert.GetItemString(i,'itnbr')) or &
	dw_insert.GetItemString(i,'itnbr') = "" then
	f_message_chk(1400,'[ '+string(i)+' 행 품번]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('itnbr')
	dw_insert.SetFocus()
	return -1		
end if	

if isnull(dw_insert.GetItemNumber(i,'monqty1')) or &
	dw_insert.GetItemNumber(i,'monqty1') < 0 then
   f_message_chk(1400,'[ '+string(i)+' 행  M 월]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('monqty1')
	dw_insert.SetFocus()
	return -1		
end if	
if isnull(dw_insert.GetItemNumber(i,'monqty2')) or &  
	dw_insert.GetItemNumber(i,'monqty2') < 0 then
   f_message_chk(1400,'[ '+string(i)+' 행  M+1 월]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('monqty2')
	dw_insert.SetFocus()
	return -1		
end if	
if isnull(dw_insert.GetItemNumber(i,'monqty3')) or &  
	dw_insert.GetItemNumber(i,'monqty3') < 0 then
   f_message_chk(1400,'[ '+string(i)+' 행  M+2 월]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('monqty3')
	dw_insert.SetFocus()
	return -1		
end if	
if isnull(dw_insert.GetItemNumber(i,'monqty4')) or &  
	dw_insert.GetItemNumber(i,'monqty4') < 0 then
   f_message_chk(1400,'[ '+string(i)+' 행  M+3 월]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('monqty4')
	dw_insert.SetFocus()
	return -1		
end if	
if isnull(dw_insert.GetItemNumber(i,'monqty5')) or &  
	dw_insert.GetItemNumber(i,'monqty5') < 0 then
   f_message_chk(1400,'[ '+string(i)+' 행  M+4 월]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('monqty5')
	dw_insert.SetFocus()
	return -1		
end if	
Return 1
end function

public subroutine wf_avg_saleqty (string arg_itnbr, string arg_yymm);/* 평균 판매량을 가지고 온다.        */
String s_before_3ym, s_before_1ym
Dec{3} sum_qty
Long   lrow

s_before_3ym = f_aftermonth(arg_yymm, -3)
s_before_1ym = f_aftermonth(arg_yymm, -1)

  SELECT SUM(NVL("SALESUM"."SALES_QTY",0))  
    INTO :sum_qty          
    FROM "SALESUM"  
   WHERE ( "SALESUM"."SABU"  = :gs_sabu ) AND  
         ( "SALESUM"."SALES_YYMM" between :s_before_3ym and :s_before_1ym ) AND
         ( "SALESUM"."ITNBR" = :arg_itnbr ) ; 

lrow = dw_insert.getrow()

if isnull(sum_qty) or sum_qty = 0 then 
	sum_qty = 0
else
	sum_qty = Round(sum_qty / 3 , 0) 
end if

dw_insert.setitem(lrow, 'avgpan', sum_qty)    //평균판매량
dw_insert.setitem(lrow, 'xavgpan', sum_qty)    //평균판매량

end subroutine

public subroutine wf_setnull ();string snull
int    inull
long   lrow

setnull(snull)
setnull(inull)

lrow   = dw_insert.getrow()

dw_insert.setitem(lrow, "itnbr", snull)	
dw_insert.setitem(lrow, "itdsc", snull)	
dw_insert.setitem(lrow, "ispec", snull)
dw_insert.setitem(lrow, "mchdan", inull)
dw_insert.setitem(lrow, "jaego", inull)
dw_insert.setitem(lrow, "jaegong", inull)
dw_insert.setitem(lrow, "haldangmi", inull)
dw_insert.setitem(lrow, "avgpan", inull)
dw_insert.setitem(lrow, "safmid", inull)
dw_insert.setitem(lrow, "plnjan", inull)
dw_insert.setitem(lrow, 'valid_qty', inull)  //가용재고

dw_insert.setitem(lrow, "xmchdan", inull)
dw_insert.setitem(lrow, "xjaego", inull)
dw_insert.setitem(lrow, "xjaegong", inull)
dw_insert.setitem(lrow, "xhaldangmi", inull)
dw_insert.setitem(lrow, "xavgpan", inull)
dw_insert.setitem(lrow, "xsafmid", inull)
dw_insert.setitem(lrow, "xplnjan", inull)
dw_insert.setitem(lrow, 'xvalid_qty', inull)  //가용재고

end subroutine

on w_pdt_01010.create
int iCurrent
call super::create
this.dw_hidden=create dw_hidden
this.cb_2=create cb_2
this.dw_1=create dw_1
this.rr_4=create rr_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_hidden
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.rr_4
end on

on w_pdt_01010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_hidden)
destroy(this.cb_2)
destroy(this.dw_1)
destroy(this.rr_4)
end on

event open;call super::open;dw_insert.SetTransObject(sqlca)
dw_1.SetTransObject(sqlca)
dw_hidden.SetTransObject(sqlca)
dw_1.insertrow(0)

// M환산기준
select to_number(dataname) INTO :ilby from syscnfg where sysgu = 'Y' and serial = 2 and lineno = :gs_saupj;
If IsNull(ilby) Or ilby <= 0 Then ilby = 500000

wf_reset()
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

type dw_insert from w_inherite`dw_insert within w_pdt_01010
integer x = 32
integer y = 448
integer width = 4558
integer height = 1856
integer taborder = 20
string dataobject = "d_pdt_01010_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::ue_pressenter;Send(Handle(this),256,9,0)
Return 1

end event

event dw_insert::itemchanged;string   snull, sitnbr, sitdsc, sispec, syymm, get_itnbr, steam, sjijil, sispeccode
integer  ireturn, iseq
long     lrow, lreturnrow
decimal  dItemPrice    //출하단가

if dw_1.accepttext() = -1 then return 

setnull(snull)

lrow   = this.getrow()
syymm  = dw_1.getitemstring(1, 'syymm')
steam   = dw_1.getitemstring(1, 'steam')
iseq   = dw_1.getitemnumber(1, 'jjcha')

IF this.GetColumnName() = "itnbr"	THEN
	sItnbr = trim(this.GetText())

   if sitnbr = "" or isnull(sitnbr) then
		wf_setnull()
		return 
   end if	
   //자체 데이타 원도우에서 같은 품번을 체크
	lReturnRow = This.Find("itnbr = '"+sitnbr+"' ", 1, This.RowCount())
	IF (lRow <> lReturnRow) and (lReturnRow <> 0)		THEN
		f_message_chk(37,'[품번]') 
		wf_setnull()
		RETURN  1
	END IF
	//등록된 자료에서 체크
  SELECT "MONPLN_SUM"."ITNBR"  
    INTO :get_itnbr  
    FROM "MONPLN_SUM"  
   WHERE ( "MONPLN_SUM"."SABU" = :gs_sabu ) AND  
         ( "MONPLN_SUM"."MONYYMM" = :syymm ) AND  
         ( "MONPLN_SUM"."ITNBR" = :sitnbr ) AND  
         ( "MONPLN_SUM"."MOSEQ" = :iseq )   ;

   if sqlca.sqlcode <> 0 then 
		ireturn = f_get_name4_sale('품번', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	//1이면 성공, 0이 실패		
		if ireturn = 1 then ireturn = 0 else ireturn = 1		
		this.setitem(lrow, "itnbr", sitnbr)	
		this.setitem(lrow, "itdsc", sitdsc)	
		this.setitem(lrow, "ispec", sispec)
		IF ireturn = 0 then
			//생산팀이 등록되였는지 체크
 		   SELECT "ITEMAS"."ITNBR"  
			  INTO :get_itnbr  
			  FROM "ITEMAS", "ITNCT"  
			 WHERE ( "ITEMAS"."ITTYP" = "ITNCT"."ITTYP" ) and  
					 ( "ITEMAS"."ITCLS" = "ITNCT"."ITCLS" ) and  
					 ( ( "ITEMAS"."ITNBR" = :sitnbr ) AND  
					 ( "ITNCT"."PDTGU" = :steam ) )   ;

			IF SQLCA.SQLCODE <> 0 THEN 
				messagebox('확인', ls_text ) 
   			wf_setnull()
				RETURN 1
			END IF
			
         wf_jego(sitnbr)                //재고내역을 셋팅
			wf_avg_saleqty(sitnbr, syymm)  //평균판매량을 셋팅
			wf_plan_janqty(sitnbr, syymm)  //계획잔량을 셋팅

			dItemPrice = sqlca.Fun_Erp100000012(syymm, sItnbr, '.')   //판매단가를 가져옴
			if IsNull( ditemprice ) then dItemPrice = 0
			this.SetItem(lRow,"mchdan", dItemPrice)
			this.SetItem(lRow,"xmchdan", dItemPrice)
			this.Setfocus()
      END IF
		RETURN ireturn
	else
		f_message_chk(37,'[품번]') 
		wf_setnull()
		RETURN 1
	end if	
ELSEIF this.GetColumnName() = "itdsc"	THEN
	sItdsc = trim(this.GetText())
   if sitdsc = "" or isnull(sitdsc) then
		wf_setnull()
		return 
   end if	

	ireturn = f_get_name4_sale('품명', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	//1이면 성공, 0이 실패		
	if ireturn = 1 then ireturn = 0 else ireturn = 1		
	this.setitem(lrow, "itnbr", sitnbr)	
	this.setitem(lrow, "itdsc", sitdsc)	
	this.setitem(lrow, "ispec", sispec)
   if ireturn = 0 then 
	   //자체 데이타 원도우에서 같은 품번을 체크
		lReturnRow = This.Find("itnbr = '"+sitnbr+"' ", 1, This.RowCount())
		IF (lRow <> lReturnRow) and (lReturnRow <> 0)		THEN
			f_message_chk(37,'[품번]') 
			wf_setnull()
			RETURN  1
		END IF
		
	   SELECT "MONPLN_SUM"."ITNBR"  
		  INTO :get_itnbr  
		  FROM "MONPLN_SUM"  
		 WHERE ( "MONPLN_SUM"."SABU" = :gs_sabu ) AND  
				 ( "MONPLN_SUM"."MONYYMM" = :syymm ) AND  
				 ( "MONPLN_SUM"."ITNBR" = :sitnbr ) AND  
				 ( "MONPLN_SUM"."MOSEQ" = :iseq )   ;
	
 		if sqlca.sqlcode = 0 then 
			f_message_chk(37,'[품번]') 
			wf_setnull()
			RETURN 1
      else
			//생산팀이 등록되였는지 체크
 		   SELECT "ITEMAS"."ITNBR"  
			  INTO :get_itnbr  
			  FROM "ITEMAS", "ITNCT"  
			 WHERE ( "ITEMAS"."ITTYP" = "ITNCT"."ITTYP" ) and  
					 ( "ITEMAS"."ITCLS" = "ITNCT"."ITCLS" ) and  
					 ( ( "ITEMAS"."ITNBR" = :sitnbr ) AND  
					 ( "ITNCT"."PDTGU" = :steam ) )   ;

			IF SQLCA.SQLCODE <> 0 THEN 
				messagebox('확인', ls_text ) 
   			wf_setnull()
				RETURN 1
			END IF

         wf_jego(sitnbr)                //재고내역을 셋팅
			wf_avg_saleqty(sitnbr, syymm)  //평균판매량을 셋팅
			wf_plan_janqty(sitnbr, syymm)  //계획잔량을 셋팅

			dItemPrice = sqlca.Fun_Erp100000012(syymm, sItnbr, '.')   //판매단가를 가져옴
			this.SetItem(lRow,"mchdan", dItemPrice)
			this.SetItem(lRow,"xmchdan", dItemPrice)
			this.Setfocus()
      end if	
   end if		
	RETURN ireturn
ELSEIF this.GetColumnName() = "ispec"	THEN
	sIspec = trim(this.GetText())
   if sispec = "" or isnull(sispec) then
		wf_setnull()
		return 
   end if	

	ireturn = f_get_name4_sale('규격', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	//1이면 성공, 0이 실패		
	if ireturn = 1 then ireturn = 0 else ireturn = 1		
	this.setitem(lrow, "itnbr", sitnbr)	
	this.setitem(lrow, "itdsc", sitdsc)	
	this.setitem(lrow, "ispec", sispec)
   if ireturn = 0 then 
		//자체 데이타 원도우에서 같은 품번을 체크
		lReturnRow = This.Find("itnbr = '"+sitnbr+"' ", 1, This.RowCount())
		IF (lRow <> lReturnRow) and (lReturnRow <> 0)		THEN
			f_message_chk(37,'[품번]') 
			wf_setnull()
			RETURN  1
		END IF

	   SELECT "MONPLN_SUM"."ITNBR"  
		  INTO :get_itnbr  
		  FROM "MONPLN_SUM"  
		 WHERE ( "MONPLN_SUM"."SABU" = :gs_sabu ) AND  
				 ( "MONPLN_SUM"."MONYYMM" = :syymm ) AND  
				 ( "MONPLN_SUM"."ITNBR" = :sitnbr ) AND  
				 ( "MONPLN_SUM"."MOSEQ" = :iseq )   ;
	
 		if sqlca.sqlcode = 0 then 
			f_message_chk(37,'[품번]') 
			wf_setnull()
			RETURN 1
      else
			//생산팀이 등록되였는지 체크
 		   SELECT "ITEMAS"."ITNBR"  
			  INTO :get_itnbr  
			  FROM "ITEMAS", "ITNCT"  
			 WHERE ( "ITEMAS"."ITTYP" = "ITNCT"."ITTYP" ) and  
					 ( "ITEMAS"."ITCLS" = "ITNCT"."ITCLS" ) and  
					 ( ( "ITEMAS"."ITNBR" = :sitnbr ) AND  
					 ( "ITNCT"."PDTGU" = :steam ) )   ;

			IF SQLCA.SQLCODE <> 0 THEN 
				messagebox('확인', ls_text ) 
   			wf_setnull()
				RETURN 1
			END IF

         wf_jego(sitnbr)                //재고내역을 셋팅
			wf_avg_saleqty(sitnbr, syymm)  //평균판매량을 셋팅
			wf_plan_janqty(sitnbr, syymm)  //계획잔량을 셋팅

			dItemPrice = sqlca.Fun_Erp100000012(syymm, sItnbr, '.')   //판매단가를 가져옴
			this.SetItem(lRow,"mchdan", dItemPrice)
			this.SetItem(lRow,"xmchdan", dItemPrice)
			this.Setfocus()
      end if	
   end if		
	RETURN ireturn
END IF
end event

event dw_insert::itemerror;return 1
end event

event dw_insert::rbuttondown;Integer iCurRow

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

END IF
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

event dw_insert::editchanged;call super::editchanged;String scol_name
Dec {2} dData

sCol_name = dwo.name
Choose Case scol_Name
		 Case 'monqty101'
				dData = Dec(gettext())
			   setitem(row, "monqty1", dData + getitemdecimal(row, "monqty201"))
		 Case 'monqty201'
				dData = Dec(gettext())
			   setitem(row, "monqty1", dData + getitemdecimal(row, "monqty101"))
		 Case 'monqty102'
				dData = Dec(gettext())
			   setitem(row, "monqty2", dData + getitemdecimal(row, "monqty202"))
		 Case 'monqty202'
				dData = Dec(gettext())
			   setitem(row, "monqty2", dData + getitemdecimal(row, "monqty102"))
		 Case 'monqty103'
				dData = Dec(gettext())
			   setitem(row, "monqty3", dData + getitemdecimal(row, "monqty203"))
		 Case 'monqty203'
				dData = Dec(gettext())
			   setitem(row, "monqty3", dData + getitemdecimal(row, "monqty103"))				
		 Case 'monqty104'
				dData = Dec(gettext())
			   setitem(row, "monqty4", dData + getitemdecimal(row, "monqty204"))
		 Case 'monqty204'
				dData = Dec(gettext())
			   setitem(row, "monqty4", dData + getitemdecimal(row, "monqty104"))
		 Case 'monqty105'
				dData = Dec(gettext())
			   setitem(row, "monqty5", dData + getitemdecimal(row, "monqty205"))
		 Case 'monqty205'
				dData = Dec(gettext())
			   setitem(row, "monqty5", dData + getitemdecimal(row, "monqty105"))
End choose


end event

type p_delrow from w_inherite`p_delrow within w_pdt_01010
boolean visible = false
integer x = 3122
integer y = 32
boolean enabled = false
end type

event p_delrow::clicked;call super::clicked;Integer i, irow, irow2
string s_yymm, s_toym

if dw_1.AcceptText() = -1 then return 

IF dw_insert.AcceptText() = -1 THEN RETURN 

if dw_insert.rowcount() <= 0 then return 	


s_yymm = trim(dw_1.GetItemString(1,'syymm'))

if isnull(s_yymm) or s_yymm = "" then
	f_message_chk(30,'[기준년월]')
	dw_1.Setcolumn('syymm')
	dw_1.SetFocus()
	return
end if	

s_toym = left(f_today(), 6) 
if s_yymm < s_toym then
	messagebox("확인", "현재 이전 년월 자료는 삭제할 수 없습니다!!")
	dw_1.setcolumn('syymm')
	dw_1.setfocus()
	return 
end if		

irow = dw_insert.getrow() - 1
irow2 = dw_insert.getrow() + 1
if irow > 0 then   
	FOR i = 1 TO irow
		IF wf_required_chk(i) = -1 THEN RETURN
	NEXT
end if	

FOR i = irow2 TO dw_insert.RowCount()
	IF wf_required_chk(i) = -1 THEN RETURN
NEXT

if f_msg_delete() = -1 then return

dw_insert.SetRedraw(FALSE)

dw_insert.DeleteRow(0)

if dw_insert.Update() = 1 then
	sle_msg.text =	"자료를 삭제하였습니다!!"	
	ib_any_typing = false
	commit ;
else
	rollback ;
   messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
end if	
dw_insert.SetRedraw(TRUE)


end event

type p_addrow from w_inherite`p_addrow within w_pdt_01010
boolean visible = false
integer x = 2949
integer y = 32
boolean enabled = false
end type

event p_addrow::clicked;call super::clicked;string s_team, s_yymm, s_toym
Int    i_seq
long   i, il_currow, il_rowcount

if dw_1.AcceptText() = -1 then return 

s_team = dw_1.GetItemString(1,'steam')
s_yymm = trim(dw_1.GetItemString(1,'syymm'))
i_seq  = dw_1.GetItemNumber(1,'jjcha')

if isnull(s_team) or s_team = "" then
	f_message_chk(30,'[생산팀]')
	dw_1.Setcolumn('steam')
	dw_1.SetFocus()
	return
end if	
if isnull(s_yymm) or s_yymm = "" then
	f_message_chk(30,'[기준년월]')
	dw_1.Setcolumn('syymm')
	dw_1.SetFocus()
	return
end if	

s_toym = left(f_today(), 6) 
if s_yymm < s_toym then
	messagebox("확인", "현재 이전 년월 자료는 추가할 수 없습니다!!")
	dw_1.setcolumn('syymm')
	dw_1.setfocus()
	return 
end if		

if isnull(i_seq) or i_seq = 0 then
	f_message_chk(30,'[조정구분]')
	dw_1.Setcolumn('jjcha')
	dw_1.SetFocus()
	return
end if	

FOR i = 1 TO dw_insert.RowCount()
	IF wf_required_chk(i) = -1 THEN RETURN
NEXT

IF dw_insert.RowCount() <=0 THEN
	il_currow = 0
	il_rowCount = 0
ELSE
	il_currow = dw_insert.GetRow()
	il_RowCount = dw_insert.RowCount()
	
	IF il_currow <=0 THEN
		il_currow = il_RowCount
	END IF
END IF

il_currow = il_currow + 1
dw_insert.InsertRow(il_currow)

dw_insert.setitem(il_currow, 'sabu', gs_sabu )
dw_insert.setitem(il_currow, 'monyymm', s_yymm )
dw_insert.setitem(il_currow, 'moseq', i_seq )

dw_insert.ScrollToRow(il_currow)
dw_insert.SetColumn('itnbr')
dw_insert.SetFocus()

dw_1.enabled = false
p_search.picturename = 'C:\erpman\image\생성_d.gif'
p_search.enabled = false

ib_any_typing =True

end event

type p_search from w_inherite`p_search within w_pdt_01010
integer x = 27
string pointer = "C:\erpman\cur\create2.cur"
string picturename = "C:\erpman\image\생성_up.gif"
end type

event p_search::clicked;call super::clicked;string s_yymm, s_toym
int    i_seq

if dw_1.AcceptText() = -1 then return 
s_yymm = trim(dw_1.GetItemString(1,'syymm'))
i_seq  = dw_1.GetItemNumber(1,'jjcha')

if isnull(s_yymm) or s_yymm = "" then
	f_message_chk(30,'[계획년월]')
	dw_1.Setcolumn('syymm')
	dw_1.SetFocus()
	return
end if

s_toym = left(f_today(), 6) 
if s_yymm < s_toym then

	messagebox("확인", "현재 이전 년월은 처리할 수 없습니다!!")

	dw_1.setcolumn('syymm')
	dw_1.setfocus()
	return 
end if		

if isnull(i_seq) or i_seq = 0 then
	f_message_chk(30,'[확정/조정 구분]')
	dw_1.Setcolumn('jjcha')
	dw_1.SetFocus()
	return
end if	

gs_code = s_yymm
gs_codename = string(i_seq) 
		
Open(w_pdt_01011)


end event

event p_search::ue_lbuttonup;call super::ue_lbuttonup;p_search.picturename = 'C:\erpman\image\생성_up.gif'
end event

event p_search::ue_lbuttondown;call super::ue_lbuttondown;p_search.picturename = 'C:\erpman\image\생성_dn.gif'
end event

type p_ins from w_inherite`p_ins within w_pdt_01010
boolean visible = false
integer x = 2619
integer y = 16
end type

type p_exit from w_inherite`p_exit within w_pdt_01010
end type

type p_can from w_inherite`p_can within w_pdt_01010
end type

event p_can::clicked;call super::clicked;wf_reset()

dw_1.enabled = true

p_search.picturename = 'C:\erpman\image\생성_up.gif'
p_addrow.picturename = 'C:\erpman\image\행추가_up.gif'
p_delrow.picturename = 'C:\erpman\image\행삭제_up.gif'
p_mod.picturename = 'C:\erpman\image\저장_up.gif'

p_search.enabled = true
p_addrow.enabled = false
p_delrow.enabled = false
p_mod.enabled = false

dw_insert.DataObject ="d_pdt_01010_1" 
dw_insert.SetTransObject(SQLCA)

ib_any_typing = FALSE

dw_1.setfocus()
end event

type p_print from w_inherite`p_print within w_pdt_01010
boolean visible = false
integer x = 2409
integer y = 16
string pointer = "C:\erpman\cur\point.cur"
boolean enabled = false
string picturename = "C:\erpman\image\발주_up.gif"
end type

event p_print::ue_lbuttonup;call super::ue_lbuttonup;this.picturename = 'C:\erpman\image\발주_up.gif'
end event

event p_print::ue_lbuttondown;call super::ue_lbuttondown;this.picturename = 'C:\erpman\image\발주_dn.gif'
end event

type p_inq from w_inherite`p_inq within w_pdt_01010
integer x = 3749
end type

event p_inq::clicked;call super::clicked;string s_gub, s_team, s_yymm, s_ittyp, s_fritcls, s_toitcls, s_fritnbr, s_toitnbr, &
       s_gub2, ssaupj
Int    i_seq
long   lcount

if dw_1.AcceptText() = -1 then return 
SetPointer(HourGlass!)

ssaupj  = dw_1.GetItemString(1,'saupj')
s_gub  = dw_1.GetItemString(1,'sgub')
s_team = dw_1.GetItemString(1,'steam')
s_yymm = trim(dw_1.GetItemString(1,'syymm'))
i_seq  = dw_1.GetItemNumber(1,'jjcha')
s_gub2 = dw_1.GetItemString(1,'gubun')

if isnull(s_team) or s_team = "" then
	f_message_chk(30,'[생산팀]')
	dw_1.Setcolumn('steam')
	dw_1.SetFocus()
	return
end if	
if isnull(s_yymm) or s_yymm = "" then
	f_message_chk(30,'[기준년월]')
	dw_1.Setcolumn('syymm')
	dw_1.SetFocus()
	return
end if	
if isnull(i_seq) or i_seq = 0 then
	f_message_chk(30,'[조정구분]')
	dw_1.Setcolumn('jjcha')
	dw_1.SetFocus()
	return
end if	

If s_gub = '0' then //품목분류로 조회
   s_ittyp   = dw_1.GetItemString(1,'sittyp')
	if isnull(s_ittyp) or s_ittyp = "" then
		f_message_chk(30,'[품목구분]')
		dw_1.Setcolumn('sittyp')
		dw_1.SetFocus()
		return
	end if	
   s_fritcls = trim(dw_1.GetItemString(1,'fr_itcls'))
	if isnull(s_fritcls) or s_fritcls = "" then
      s_fritcls = '.'
   end if	
   s_toitcls = trim(dw_1.GetItemString(1,'to_itcls'))
	if isnull(s_toitcls) or s_toitcls = "" then
      s_toitcls = 'zzzzzzz'
   end if	
   if s_fritcls > s_toitcls then 
		f_message_chk(34,'[품목분류]')
		dw_1.Setcolumn('fr_itcls')
		dw_1.SetFocus()
		return
	end if	
	
	IF s_gub2 = '1' THEN
		dw_insert.DataObject ="d_pdt_01010_2" 
	ELSE
		dw_insert.DataObject ="d_pdt_01010_4" 
	END IF
	dw_insert.SetTransObject(SQLCA)

	dw_insert.object.m_t.text = string(s_yymm, '@@@@.@@')
	dw_insert.object.m1_t.text = string(f_aftermonth(s_yymm, 1), '@@@@.@@')
	dw_insert.object.m2_t.text = string(f_aftermonth(s_yymm, 2), '@@@@.@@')
	dw_insert.object.m3_t.text = string(f_aftermonth(s_yymm, 3), '@@@@.@@')
	dw_insert.object.m4_t.text = string(f_aftermonth(s_yymm, 4), '@@@@.@@')
	
	if dw_insert.Retrieve(gs_sabu,s_team,s_yymm,i_seq,s_ittyp,s_fritcls,s_toitcls,ssaupj, ilby) <= 0 then 
		f_message_chk(50,'')
		dw_1.Setcolumn('steam')
		dw_1.SetFocus()
		p_addrow.picturename = 'C:\erpman\image\행추가_up.gif'
		p_delrow.picturename = 'C:\erpman\image\행삭제_up.gif'
		p_mod.picturename = 'C:\erpman\image\저장_up.gif'
		p_addrow.enabled = true
		p_delrow.enabled = true
		p_mod.enabled = true
      return
	end if	
Else   //품번으로 조회
   s_fritnbr = trim(dw_1.GetItemString(1,'fr_itnbr'))
	if isnull(s_fritnbr) or s_fritnbr = "" then
      s_fritnbr = '.'
   end if	
   s_toitnbr = trim(dw_1.GetItemString(1,'to_itnbr'))
	if isnull(s_toitnbr) or s_toitnbr = "" then
      s_toitnbr = 'zzzzzzzzzzzzzzz'
   end if	
   if s_fritnbr > s_toitnbr then 
		f_message_chk(34,'[품번]')
		dw_1.Setcolumn('fr_itnbr')
		dw_1.SetFocus()
		return
	end if	

	IF s_gub2 = '1' THEN
		dw_insert.DataObject ="d_pdt_01010_1" 
	ELSE
		dw_insert.DataObject ="d_pdt_01010_3" 
	END IF
	dw_insert.SetTransObject(SQLCA)
	
	dw_insert.object.m_t.text = string(s_yymm, '@@@@.@@')
	dw_insert.object.m1_t.text = string(f_aftermonth(s_yymm, 1), '@@@@.@@')
	dw_insert.object.m2_t.text = string(f_aftermonth(s_yymm, 2), '@@@@.@@')
	dw_insert.object.m3_t.text = string(f_aftermonth(s_yymm, 3), '@@@@.@@')
	dw_insert.object.m4_t.text = string(f_aftermonth(s_yymm, 4), '@@@@.@@')
	
	if dw_insert.Retrieve(gs_sabu,s_team,s_yymm,i_seq,s_fritnbr,s_toitnbr,ssaupj, ilby) <= 0 then 
		f_message_chk(50,'')
		dw_1.Setcolumn('steam')
		dw_1.SetFocus()
		p_addrow.picturename = 'C:\erpman\image\행추가_up.gif'
		p_delrow.picturename = 'C:\erpman\image\행삭제_up.gif'
		p_mod.picturename = 'C:\erpman\image\저장_up.gif'		
		p_addrow.enabled = true
		p_delrow.enabled = true
		p_mod.enabled = true
      return
   end if	
End if	

  SELECT COUNT(*) INTO :lcount
    FROM ITEMAS B, MONPLN_DTL A, ITNCT C
   WHERE ( B.ITNBR = A.ITNBR ) AND  
         ( B.ITTYP = C.ITTYP ) AND  
         ( B.ITCLS = C.ITCLS ) AND  
         ( A.SABU = :gs_sabu AND A.MONYYMM = :s_yymm AND A.MOSEQ = :i_seq ) AND    
         ( C.PDTGU = :s_team )  ;

if lcount > 0 then 
   messagebox("확 인", "월 생산계획이 등록되어 있으므로 수정 및 삭제 할 수 없습니다.")
	dw_1.enabled = false
	p_addrow.picturename = 'C:\erpman\image\행추가_d.gif'
	p_delrow.picturename = 'C:\erpman\image\행삭제_d.gif'
	p_mod.picturename = 'C:\erpman\image\저장_d.gif'
	p_delrow.enabled = false
	p_addrow.enabled = false
	p_mod.enabled = false
else
	dw_insert.SetFocus()
	dw_1.enabled = false
	p_search.picturename = 'C:\erpman\image\생성_d.gif'
	p_search.enabled = false
	ib_any_typing = FALSE
	p_addrow.picturename = 'C:\erpman\image\행추가_up.gif'
	p_delrow.picturename = 'C:\erpman\image\행삭제_up.gif'
	p_mod.picturename = 'C:\erpman\image\저장_up.gif'
	p_addrow.enabled = true
	p_delrow.enabled = true
	p_mod.enabled = true
end if	


end event

type p_del from w_inherite`p_del within w_pdt_01010
end type

event p_del::clicked;call super::clicked;string s_yymm, smsgtxt, stext, s_team, get_nm, s_toym
int    i_seq
long   lcount

if dw_1.AcceptText() = -1 then return 

s_team = dw_1.GetItemString(1,'steam')
s_yymm = trim(dw_1.GetItemString(1,'syymm'))
i_seq  = dw_1.GetItemNumber(1,'jjcha')

SetPointer(HourGlass!)

if isnull(s_team) or s_team = "" then
	f_message_chk(30,'[생산팀]')
	dw_1.Setcolumn('steam')
	dw_1.SetFocus()
	return
else
  SELECT "REFFPF"."RFNA1"  
    INTO :get_nm  
    FROM "REFFPF"  
   WHERE ( "REFFPF"."SABU" = '1' ) AND  
         ( "REFFPF"."RFCOD" = '03' ) AND  
         ( "REFFPF"."RFGUB" = :s_team )   ;
end if	

if isnull(s_yymm) or s_yymm = "" then
	f_message_chk(30,'[계획년월]')
	dw_1.Setcolumn('syymm')
	dw_1.SetFocus()
	return
end if

s_toym = left(f_today(), 6) 
if s_yymm < s_toym then
	messagebox("확인", "현재 이전 년월 자료는 삭제할 수 없습니다!!")
	dw_1.setcolumn('syymm')
	dw_1.setfocus()
	return 
end if		

if isnull(i_seq) or i_seq = 0 then
	f_message_chk(30,'[확정/조정 구분]')
	dw_1.Setcolumn('jjcha')
	dw_1.SetFocus()
	return
else
	if i_seq = 1 then 
		stext = '확정분'
	else
		stext = '조정분'
	end if	
end if	

  SELECT COUNT(*) INTO :lcount
    FROM ITEMAS B, MONPLN_DTL A
   WHERE ( B.ITNBR = A.ITNBR ) AND  
         ( A.SABU = :gs_sabu AND A.MONYYMM = :s_yymm AND A.MOSEQ = :i_seq ) AND    
         ( B.PDTGU = :s_team )  ;

if lcount > 0 then 
   messagebox("확 인", "월 생산계획이 등록되어 있으므로 삭제 할 수 없습니다.")
	dw_1.SetFocus()
	return 
end if
		
smsgtxt = get_nm + '에 ' + left(s_yymm, 4) + '년 ' + mid(s_yymm, 5, 2) + '월 ' &
          + stext + ' 연동 생산계획을 삭제 하시겠습니까?'
if messagebox("확 인", smsgtxt, Question!, YesNo!, 2) = 2 then return   

  DELETE FROM MONPLN_SUM  
   WHERE SABU = :gs_sabu AND MONYYMM = :s_yymm AND MOSEQ = :i_seq AND  
         ITNBR IN ( SELECT B.ITNBR  FROM  ITEMAS B
						  WHERE B.PDTGU = :s_team );

if SQLCA.SQLCODE = 0 then
	commit ;
	sle_msg.text = "자료가 삭제되었습니다!!"
	ib_any_typing= FALSE
else
	rollback ;
   messagebox("삭제실패", "생산팀별 삭제가 실패하였읍니다")
	return 
end if	
		
p_can.TriggerEvent(clicked!)

end event

type p_mod from w_inherite`p_mod within w_pdt_01010
end type

event p_mod::clicked;call super::clicked;string s_yymm, s_toym
long   i

if dw_1.AcceptText() = -1 then return 

if dw_insert.AcceptText() = -1 then return 

if dw_insert.rowcount() <= 0 then return 

s_yymm = trim(dw_1.GetItemString(1,'syymm'))

if isnull(s_yymm) or s_yymm = "" then
	f_message_chk(30,'[기준년월]')
	dw_1.Setcolumn('syymm')
	dw_1.SetFocus()
	return
end if	

s_toym = left(f_today(), 6) 
if s_yymm < s_toym then
	messagebox("확인", "현재 이전 년월 자료는 저장할 수 없습니다!!")
	dw_1.setcolumn('syymm')
	dw_1.setfocus()
	return 
end if		

FOR i = 1 TO dw_insert.RowCount()
	IF wf_required_chk(i) = -1 THEN RETURN
NEXT

if f_msg_update() = -1 then return
	
if dw_insert.update() = 1 then
	commit ;
	sle_msg.text = "자료가 저장되었습니다!!"
	ib_any_typing= FALSE
else
	rollback ;
   messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
	return 
end if	
		
p_inq.TriggerEvent(clicked!)

end event

type cb_exit from w_inherite`cb_exit within w_pdt_01010
integer x = 3246
integer y = 2612
integer width = 325
integer height = 104
integer taborder = 110
integer textsize = -9
end type

type cb_mod from w_inherite`cb_mod within w_pdt_01010
integer x = 2231
integer y = 2612
integer width = 325
integer height = 104
integer taborder = 80
integer textsize = -9
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within w_pdt_01010
integer x = 416
integer y = 2612
integer width = 325
integer height = 104
integer taborder = 70
integer textsize = -9
boolean enabled = false
string text = "추가(&A)"
end type

type cb_del from w_inherite`cb_del within w_pdt_01010
integer x = 2569
integer y = 2612
integer width = 325
integer height = 104
integer taborder = 90
integer textsize = -9
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_pdt_01010
integer x = 78
integer y = 2612
integer width = 325
integer height = 104
integer taborder = 60
integer textsize = -9
end type

type cb_print from w_inherite`cb_print within w_pdt_01010
integer x = 1326
integer y = 2612
integer width = 407
integer height = 104
integer taborder = 40
integer textsize = -9
string text = "생산팀 삭제"
end type

type st_1 from w_inherite`st_1 within w_pdt_01010
end type

type cb_can from w_inherite`cb_can within w_pdt_01010
integer x = 2907
integer y = 2612
integer width = 325
integer height = 104
integer taborder = 100
integer textsize = -9
end type

event cb_can::clicked;call super::clicked;wf_reset()

dw_1.enabled = true
cb_search.enabled = true
cb_ins.enabled = false
cb_del.enabled = false
cb_mod.enabled = false

dw_insert.DataObject ="d_pdt_01010_1" 
dw_insert.SetTransObject(SQLCA)

ib_any_typing = FALSE

dw_1.setfocus()


end event

type cb_search from w_inherite`cb_search within w_pdt_01010
integer x = 818
integer y = 2612
integer width = 489
integer height = 104
integer taborder = 30
integer textsize = -9
string text = "연동계획 생성"
end type







type gb_button1 from w_inherite`gb_button1 within w_pdt_01010
end type

type gb_button2 from w_inherite`gb_button2 within w_pdt_01010
end type

type dw_hidden from datawindow within w_pdt_01010
boolean visible = false
integer x = 1472
integer y = 2432
integer width = 494
integer height = 360
boolean bringtotop = true
string dataobject = "d_pdt_01000_9"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_2 from commandbutton within w_pdt_01010
boolean visible = false
integer x = 1778
integer y = 2620
integer width = 407
integer height = 104
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "외주발주"
end type

type dw_1 from datawindow within w_pdt_01010
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 27
integer y = 192
integer width = 4594
integer height = 224
integer taborder = 10
string dataobject = "d_pdt_01010_a"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;IF this.GetColumnName() ="sgub" THEN RETURN

Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;str_itnct str_sitnct
string snull

setnull(gs_code)
setnull(snull)

IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
		IF This.GetColumnName() = "fr_itnbr" Then
			open(w_itemas_popup2)
			if isnull(gs_code) or gs_code = "" then return
			
			this.SetItem(1,"fr_itnbr",gs_code)
			RETURN 1
		ELSEIF This.GetColumnName() = "to_itnbr" Then
			open(w_itemas_popup2)
			if isnull(gs_code) or gs_code = "" then return
			
			this.SetItem(1,"to_itnbr",gs_code)
			RETURN 1
		ELSEIF This.GetColumnName() = "fr_itcls" Then
   		this.accepttext()
			gs_code = this.getitemstring(1, 'sittyp')
			
			open(w_ittyp_popup3)
			
			str_sitnct = Message.PowerObjectParm	
			
			if isnull(str_sitnct.s_ittyp) or str_sitnct.s_ittyp = "" then 
				return 
			elseif str_sitnct.s_ittyp = '1' or str_sitnct.s_ittyp = '2' or &
					 str_sitnct.s_ittyp = '7' THEN //1완제품, 2반제품, 7상품  
				this.SetItem(1,"sittyp", str_sitnct.s_ittyp)
				this.SetItem(1,"fr_itcls", str_sitnct.s_sumgub)
				RETURN 1
 			else
				f_message_chk(61,'[품목구분]')
				return 1
			end if	
		ELSEIF This.GetColumnName() = "to_itcls" Then
   		this.accepttext()
			gs_code = this.getitemstring(1, 'sittyp')
			
			open(w_ittyp_popup3)
			
			str_sitnct = Message.PowerObjectParm	
			
			if isnull(str_sitnct.s_ittyp) or str_sitnct.s_ittyp = "" then 
				return 
			elseif str_sitnct.s_ittyp = '1' or str_sitnct.s_ittyp = '2' or &
					 str_sitnct.s_ittyp = '7' THEN //1완제품, 2반제품, 7상품  
				this.SetItem(1,"sittyp", str_sitnct.s_ittyp)
				this.SetItem(1,"to_itcls", str_sitnct.s_sumgub)
	   		RETURN 1
 			else
				f_message_chk(61,'[품목구분]')
				return 1
			end if	
      End If
END IF

end event

event itemchanged;string snull, syymm, s_name, s_itt, s_curym, s_gub, steam, steamnm, stitnm, stextnm
int    iseq, inull, get_yeacha, i

setnull(snull)
setnull(inull)

IF this.GetColumnName() ="steam" THEN
	steam = trim(this.GetText())
	setnull(ls_text)
	
	if dw_hidden.retrieve(steam) < 1 then
		messagebox("확인", '생산팀에 품목이 존재하지 않습니다. 생산팀을 확인하세요!')
		this.setitem(1, 'steam', snull)
		return 1 
	else
		steamnm = dw_hidden.getitemstring(1, 'teamnm')
	   FOR i=1 TO dw_hidden.rowcount()
			 stitnm  = dw_hidden.getitemstring(i, 'titnm')
          if i = 1 then
   			 stextnm = stitnm
			 else
				 stextnm = stextnm + ',' + '~n' + stitnm
 	 		 end if	 
		NEXT
      ls_text =  '생산팀 ' + steamnm + ' 는(은) ' + '대분류가 ' + '~n' &
		           + stextnm + ' 인' + '~n' + '품목만 입력가능합니다.'
   end if
ELSEIF this.GetColumnName() ="syymm" THEN
	syymm = trim(this.GetText())
	
	if syymm = "" or isnull(syymm) then
  		this.setitem(1, 'jjcha', 1)
		return 
	end if	

  	IF f_datechk(syymm + '01') = -1	then
      f_message_chk(35, '[기준년월]')
		this.setitem(1, "syymm", sNull)
  		this.setitem(1, 'jjcha', 1)
		return 1
	END IF
	
	SELECT MAX("MONPLN_SUM"."MOSEQ")  
	  INTO :get_yeacha  
	  FROM "MONPLN_SUM"  
	 WHERE ( "MONPLN_SUM"."SABU" = :gs_sabu ) AND ( "MONPLN_SUM"."MONYYMM" = :syymm ) ;

	if get_yeacha = 0 or isnull(get_yeacha) then get_yeacha = 1

	dw_1.setitem(1, 'jjcha', get_yeacha )
ELSEIF this.GetColumnName() ="jjcha" THEN
	this.accepttext()
	iseq  = integer(this.gettext())
   syymm = trim(this.getitemstring(1, 'syymm'))
	
	if iseq = 0  or isnull(iseq)  then return 
	
	if syymm = "" or isnull(syymm) then 
		messagebox("확인", "기준년월을 먼저 입력 하십시요!!")
  		this.setitem(1, 'jjcha', inull)
		this.setcolumn('syymm')
		this.setfocus()
		return 1
	end if		
   SELECT MAX("MONPLN_SUM"."MOSEQ")  
	  INTO :get_yeacha  
     FROM "MONPLN_SUM"  
    WHERE ( "MONPLN_SUM"."SABU" = :gs_sabu ) AND ( "MONPLN_SUM"."MONYYMM" = :syymm ) ;
   
	//확정계획이 없는 경우 조정계획을 입력할 수 없고
	if isnull(get_yeacha) or get_yeacha = 0  then
		IF iseq <> 1 then
   		messagebox("확인", left(syymm,4)+"년 "+mid(syymm,5,2)+"월에 확정/조정계획이 없으니 " &
			                   + "확정만 입력가능합니다!!")
	  		this.setitem(1, 'jjcha', 1)
       	this.setcolumn('jjcha')
         this.setfocus()
 			return 1
      end if		
	//조정계획이 있는 경우 확정계획을 입력할 수 없다.	
	elseif get_yeacha = 2 then
		if iseq = 1 then
   		messagebox("확인", left(syymm,4)+"년 "+mid(syymm,5,2)+"월에 조정계획이 있으니 " &
			                   + "확정은 입력할 수 없습니다!!")
	  		this.setitem(1, 'jjcha', 2)
       	this.setcolumn('jjcha')
         this.setfocus()
 			return 1
		end if		
   end if		
ELSEIF this.GetColumnName() = 'sittyp' THEN
	s_itt = this.gettext()
 
   IF s_itt = "" OR IsNull(s_itt) THEN 
		this.SetItem(1,'fr_itcls', snull)
		this.SetItem(1,'to_itcls', snull)
		RETURN
   END IF
	
	s_name = f_get_reffer('05', s_itt)
	IF	isnull(s_name) or s_name="" THEN
		f_message_chk(33,'[품목구분]')
		this.SetItem(1,'sittyp', snull)
		this.SetItem(1,'fr_itcls', snull)
		this.SetItem(1,'to_itcls', snull)
		return 1
   ELSEIF s_itt = '1' or s_itt = '2' or s_itt = '7' THEN //1완제품, 2반제품, 7상품  
   ELSE 	
		f_message_chk(61,'[품목구분]')
		this.SetItem(1,'sittyp', snull)
		this.SetItem(1,'fr_itcls', snull)
		this.SetItem(1,'to_itcls', snull)
		return 1
   END IF	
ELSEIF this.GetColumnName() = 'sgub' THEN
	s_gub = this.gettext()
    	
	wf_modify(s_gub)
ElseIf GetColumnName() = 'saupj' Then
	s_gub = this.gettext()
	f_child_saupj(dw_1, 'steam', s_gub)
END IF

end event

event itemerror;return 1
end event

event rbuttondown;string snull, sname
str_itnct lstr_sitnct

setnull(snull)
setnull(gs_code)
setnull(gs_codename)

if this.GetColumnName() = 'fr_itnbr' then
   gs_code = this.GetText()
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"fr_itnbr",gs_code)
elseif this.GetColumnName() = 'to_itnbr' then
   gs_code = this.GetText()
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"to_itnbr",gs_code)
elseif this.GetColumnName() = 'fr_itcls' then
   this.accepttext()
	sname = this.GetItemString(1, 'sittyp')
	OpenWithParm(w_ittyp_popup, sname)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then 
		return 
	elseif lstr_sitnct.s_ittyp = '1' or lstr_sitnct.s_ittyp = '2' or &
		    lstr_sitnct.s_ittyp = '7' THEN //1완제품, 2반제품, 7상품  
		this.SetItem(1,"sittyp",lstr_sitnct.s_ittyp)
		this.SetItem(1,"fr_itcls", lstr_sitnct.s_sumgub)
	else
		f_message_chk(61,'[품목구분]')
		return 1
 	end if	
elseif this.GetColumnName() = 'to_itcls' then
   this.accepttext()
	sname = this.GetItemString(1, 'sittyp')

	OpenWithParm(w_ittyp_popup, sname)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then 
		return 
	elseif lstr_sitnct.s_ittyp = '1' or lstr_sitnct.s_ittyp = '2' or &
		    lstr_sitnct.s_ittyp = '7' THEN //1완제품, 2반제품, 7상품  
		this.SetItem(1,"sittyp",lstr_sitnct.s_ittyp)
		this.SetItem(1,"to_itcls", lstr_sitnct.s_sumgub)
	else
		f_message_chk(61,'[품목구분]')
		return 1
 	end if	
end if	

end event

event losefocus;//this.accepttext()
end event

type rr_4 from roundrectangle within w_pdt_01010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 436
integer width = 4590
integer height = 1880
integer cornerheight = 40
integer cornerwidth = 55
end type

