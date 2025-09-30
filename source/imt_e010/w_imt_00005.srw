$PBExportHeader$w_imt_00005.srw
$PBExportComments$년간 소요량 조정
forward
global type w_imt_00005 from w_inherite
end type
type gb_3 from groupbox within w_imt_00005
end type
type dw_1 from datawindow within w_imt_00005
end type
type gb_2 from groupbox within w_imt_00005
end type
type rr_2 from roundrectangle within w_imt_00005
end type
end forward

global type w_imt_00005 from w_inherite
integer height = 2492
string title = "년간 소요량 조정"
gb_3 gb_3
dw_1 dw_1
gb_2 gb_2
rr_2 rr_2
end type
global w_imt_00005 w_imt_00005

type variables
string    is_cnvart , is_cnvgu

end variables

forward prototypes
public subroutine wf_reset (long lrow)
public function integer wf_required_chk (integer i)
public function integer wf_danga_setting (long crow, string arg_itnbr, string arg_pspec)
end prototypes

public subroutine wf_reset (long lrow);string snull

setnull(snull)

dw_insert.setitem(lrow, "itnbr", snull)	
dw_insert.setitem(lrow, "itdsc", snull)	
dw_insert.setitem(lrow, "ispec", snull)
dw_insert.setitem(lrow, "jijil", snull)	
dw_insert.setitem(lrow, "ispec_code", snull)	
dw_insert.SetItem(lRow, "ypdprc",0)
dw_insert.setitem(lrow, "cvcod", snull)	
dw_insert.SetItem(lRow, "vndmst_cvnas2",snull)

end subroutine

public function integer wf_required_chk (integer i);if isnull(dw_insert.GetItemString(i,'itnbr')) or &
	dw_insert.GetItemString(i,'itnbr') = "" then
	f_message_chk(1400,'[ '+string(i)+' 행 품번]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('itnbr')
	dw_insert.SetFocus()
	return -1		
end if	

if isnull(dw_insert.GetItemString(i,'cvcod')) or &
	dw_insert.GetItemString(i,'cvcod') = "" then
	f_message_chk(1400,'[ '+string(i)+' 행 우선거래처]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('cvcod')
	dw_insert.SetFocus()
	return -1		
end if	

if isnull(dw_insert.GetItemString(i,'itgu')) or &
	dw_insert.GetItemString(i,'itgu') = "" then
	f_message_chk(1400,'[ '+string(i)+' 행 구입형태]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('itgu')
	dw_insert.SetFocus()
	return -1		
end if	

if isnull(dw_insert.GetItemDecimal(i,'ypdprc')) or &
	dw_insert.GetItemDecimal(i,'ypdprc') <= 0 then
	f_message_chk(1400,'[ '+string(i)+' 행 단가]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('ypdprc')
	dw_insert.SetFocus()
	return -1		
end if	

Return 1
end function

public function integer wf_danga_setting (long crow, string arg_itnbr, string arg_pspec);String sCvcod, sCvnas, sTuncu, sname, sRategu, sYYmm
Decimal {2} dUnprc, dWonprc

f_buy_unprc(arg_itnbr, arg_pspec, '9999', sCvcod, sCvnas, dUnprc, sTuncu)

if isnull(dUnprc) then dUnprc = 0 

IF sTuncu <> 'WON' THEN 
	dWonprc = sqlca.erp000000090_1(dw_1.GetItemString(1,"syear")+'01',arg_itnbr,sTuncu,dUnprc,'2') ;
ELSE	
	dWonprc = dUnprc
END IF

dw_insert.object.cvcod[crow]  = sCvcod  
dw_insert.object.vndmst_cvnas2[crow] = sCvnas
dw_insert.object.ypdprc[crow] = dWonprc

return 1



end function

on w_imt_00005.create
int iCurrent
call super::create
this.gb_3=create gb_3
this.dw_1=create dw_1
this.gb_2=create gb_2
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_3
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.gb_2
this.Control[iCurrent+4]=this.rr_2
end on

on w_imt_00005.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_3)
destroy(this.dw_1)
destroy(this.gb_2)
destroy(this.rr_2)
end on

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

event ue_open;call super::ue_open;// 구매담당자
f_child_saupj(dw_1,'empno',gs_saupj)

dw_insert.SetTransObject(sqlca)
dw_1.SetTransObject(sqlca)
dw_1.insertrow(0)

string s_nextyear,  sCnvgu, scnvart
int    get_yeacha  

/* 발주단위 사용여부를 환경설정에서 검색함. */
select dataname
into :sCnvgu
from syscnfg
where sysgu = 'Y' and serial = '12' and lineno = '3' ;

if isNull(sCnvgu) or Trim(sCnvgu) = '' then
	sCnvgu = 'N'
end if
if sCnvgu = 'Y' then // 발주단위 사용시
	is_cnvgu = 'Y' 
else
	is_cnvgu = 'N'
end if

/* 구매의뢰  - > 발주확정 연산자를 환경설정에서검색함 */
select dataname
into :sCnvart
from syscnfg
where sysgu ='Y' and serial = '12' and lineno = '4' ;

if isNull(sCnvart) or Trim(sCnvart) = '' then
	sCnvart = '*'
end if

is_cnvart = sCnvart

s_nextyear = string(long(left(f_today(), 4)) + 1)

dw_1.setitem(1, 'syear', s_nextyear)

SELECT MAX("YEAPLN_MEIP"."YEACHA")  
  INTO :get_yeacha  
  FROM "YEAPLN_MEIP"  
 WHERE ( "YEAPLN_MEIP"."SABU" = :gs_sabu ) AND  
		 ( "YEAPLN_MEIP"."YEAYYMM" like :s_nextyear||'%' )   ;
		 
/* 부가 사업장 */
f_mod_saupj(dw_1,"saupj")

dw_1.setitem(1, "cha", get_yeacha)
dw_1.SetColumn('syear')
dw_1.SetFocus()

end event

event open;call super::open;PostEvent('ue_open')
end event

type dw_insert from w_inherite`dw_insert within w_imt_00005
integer x = 55
integer y = 300
integer width = 4549
integer height = 1988
integer taborder = 30
string dataobject = "d_imt_00005_01"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event dw_insert::itemchanged;string  snull, sitnbr, sitdsc, sispec, sjijil, sispec_code, syear, syear2, sTuncu, sitem
integer ireturn, get_count, iseq
long    lrow, lreturnrow
dec{2}  dItemPrice, dWonprc
String		ls_pspec

setnull(snull)

lrow    	= this.getrow()
syear   	= dw_1.getitemstring(1, 'syear')
iseq    	= dw_1.getitemnumber(1, 'cha')
syear2  	= syear + '%'
ls_pspec	= '.'

IF 	this.GetColumnName() = "itnbr"	THEN
	sItnbr = trim(this.GetText())

   	if 	sitnbr = "" or isnull(sitnbr) then
		wf_reset(lrow)
		return 
   	end if	

	ireturn = f_get_name4('품번', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)
	
	this.setitem(lrow, "itnbr", sitnbr)	
	this.setitem(lrow, "itdsc", sitdsc)	
	this.setitem(lrow, "ispec", sispec)
	this.setitem(lrow, "jijil", sjijil)	
	this.setitem(lrow, "ispec_code", sispec_code)	
	IF ireturn = 0 then
		//자체 데이타 원도우에서 같은 품번 + 구분 을 체크
		lReturnRow = This.Find("itnbr = '"+sitnbr+"' ", 1, This.RowCount())
		IF (lRow <> lReturnRow) and (lReturnRow <> 0)		THEN
			f_message_chk(37,'[품번]') 
			wf_reset(lrow)
			RETURN  1
		END IF

	   //저장된 품번인지 체크
		SELECT COUNT("ITNBR")  
		  INTO :get_count
		  FROM "YEAPLN_MEIP"  
		 WHERE "SABU"    = :gs_sabu 
		   AND "ITNBR"   = :sitnbr 
		   AND "YEAYYMM" like :syear2 
			AND "YEACHA"  = :iseq ;  

		if get_count > 0 then 
			f_message_chk(37,'[품번]') 
			wf_reset(lrow)
			RETURN 1
		end if	
		wf_danga_setting(Lrow, sItnbr, ls_pspec)
	ELSE
		RETURN ireturn
	end if
	
ELSEIF this.GetColumnName() = "itdsc"	THEN
	sitdsc = trim(this.GetText())

	ireturn = f_get_name4('품명', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)	
	this.setitem(lrow, "itnbr", sitnbr)	
	this.setitem(lrow, "itdsc", sitdsc)	
	this.setitem(lrow, "ispec", sispec)
	this.setitem(lrow, "ispec_code", sispec_code)
	this.setitem(lrow, "jijil", sjijil)

	IF sitnbr > '.' then
		//자체 데이타 원도우에서 같은 품번 + 구분 을 체크
		lReturnRow = This.Find("itnbr = '"+sitnbr+"' ", 1, This.RowCount())
		IF (lRow <> lReturnRow) and (lReturnRow <> 0)		THEN
			f_message_chk(37,'[품번]') 
			wf_reset(lrow)
			RETURN  1
		END IF
	
		//저장된 품번인지 체크
		SELECT COUNT("ITNBR")  
		  INTO :get_count
		  FROM "YEAPLN_MEIP"  
		 WHERE "SABU"    = :gs_sabu 
			AND "ITNBR"   = :sitnbr 
			AND "YEAYYMM" like :syear2 
			AND "YEACHA"  = :iseq ;  
	
		if get_count > 0 then 
			f_message_chk(37,'[품번]') 
			wf_reset(lrow)
			RETURN 1
		end if	
		wf_danga_setting(Lrow, sItnbr, ls_pspec)
	ELSE
		RETURN ireturn
	end if

	RETURN ireturn
ELSEIF this.GetColumnName() = "ispec"	THEN
	sispec = trim(this.GetText())

	ireturn = f_get_name4('규격', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)	
	this.setitem(lrow, "itnbr", sitnbr)	
	this.setitem(lrow, "itdsc", sitdsc)	
	this.setitem(lrow, "ispec", sispec)
	this.setitem(lrow, "ispec_code", sispec_code)
	this.setitem(lrow, "jijil", sjijil)
	
	IF sitnbr > '.' then
		//자체 데이타 원도우에서 같은 품번 + 구분 을 체크
		lReturnRow = This.Find("itnbr = '"+sitnbr+"' ", 1, This.RowCount())
		IF (lRow <> lReturnRow) and (lReturnRow <> 0)		THEN
			f_message_chk(37,'[품번]') 
			wf_reset(lrow)
			RETURN  1
		END IF
	
		//저장된 품번인지 체크
		SELECT COUNT("ITNBR")  
		  INTO :get_count
		  FROM "YEAPLN_MEIP"  
		 WHERE "SABU"    = :gs_sabu 
			AND "ITNBR"   = :sitnbr 
			AND "YEAYYMM" like :syear2 
			AND "YEACHA"  = :iseq ;  
	
		if get_count > 0 then 
			f_message_chk(37,'[품번]') 
			wf_reset(lrow)
			RETURN 1
		end if	
		wf_danga_setting(Lrow, sItnbr, ls_pspec)
	ELSE
		RETURN ireturn
	end if
	RETURN ireturn
	
ELSEIF this.GetColumnName() = "jijil"	THEN
	sjijil = trim(this.GetText())

	ireturn = f_get_name4('재질', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)	
	this.setitem(lrow, "itnbr", sitnbr)	
	this.setitem(lrow, "itdsc", sitdsc)	
	this.setitem(lrow, "ispec", sispec)
	this.setitem(lrow, "ispec_code", sispec_code)
	this.setitem(lrow, "jijil", sjijil)
	
	IF sitnbr > '.' then
		//자체 데이타 원도우에서 같은 품번 + 구분 을 체크
		lReturnRow = This.Find("itnbr = '"+sitnbr+"' ", 1, This.RowCount())
		IF (lRow <> lReturnRow) and (lReturnRow <> 0)		THEN
			f_message_chk(37,'[품번]') 
			wf_reset(lrow)
			RETURN  1
		END IF
	
		//저장된 품번인지 체크
		SELECT COUNT("ITNBR")  
		  INTO :get_count
		  FROM "YEAPLN_MEIP"  
		 WHERE "SABU"    = :gs_sabu 
			AND "ITNBR"   = :sitnbr 
			AND "YEAYYMM" like :syear2 
			AND "YEACHA"  = :iseq ;  
	
		if get_count > 0 then 
			f_message_chk(37,'[품번]') 
			wf_reset(lrow)
			RETURN 1
		end if	
		wf_danga_setting(Lrow, sItnbr, ls_pspec)
	ELSE
		RETURN ireturn
	end if
	RETURN ireturn
	
ELSEIF this.GetColumnName() = "ispec_code"	THEN
	sispec_code = trim(this.GetText())

	ireturn = f_get_name4('규격코드', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)	
	this.setitem(lrow, "itnbr", sitnbr)	
	this.setitem(lrow, "itdsc", sitdsc)	
	this.setitem(lrow, "ispec", sispec)
	this.setitem(lrow, "ispec_code", sispec_code)
	this.setitem(lrow, "jijil", sjijil)
	
	IF sitnbr > '.' then
		//자체 데이타 원도우에서 같은 품번 + 구분 을 체크
		lReturnRow = This.Find("itnbr = '"+sitnbr+"' ", 1, This.RowCount())
		IF (lRow <> lReturnRow) and (lReturnRow <> 0)		THEN
			f_message_chk(37,'[품번]') 
			wf_reset(lrow)
			RETURN  1
		END IF
	
		//저장된 품번인지 체크
		SELECT COUNT("ITNBR")  
		  INTO :get_count
		  FROM "YEAPLN_MEIP"  
		 WHERE "SABU"    = :gs_sabu 
			AND "ITNBR"   = :sitnbr 
			AND "YEAYYMM" like :syear2 
			AND "YEACHA"  = :iseq ;  
	
		if get_count > 0 then 
			f_message_chk(37,'[품번]') 
			wf_reset(lrow)
			RETURN 1
		end if	
		wf_danga_setting(Lrow, sItnbr, ls_pspec)
	ELSE
		RETURN ireturn
	end if
	RETURN ireturn
ELSEIF this.GetColumnName() = "cvcod"	THEN
	sItnbr = trim(this.GetText())
	
   if sitnbr = "" or isnull(sitnbr) then
		dw_insert.SetItem(lRow, "ypdprc",0)
		dw_insert.setitem(lrow, "cvcod", snull)	
		dw_insert.SetItem(lRow, "vndmst_cvnas2",snull)
		return 
   end if	

	ireturn = f_get_name2('V1', 'Y', sitnbr, sitdsc, sispec)
	dw_insert.object.cvcod[Lrow] = sItnbr
	dw_insert.object.vndmst_cvnas2[Lrow] = sitdsc	

	IF ireturn = 0 then
		sitem = this.getitemstring(lrow, 'itnbr')
		
		/* 단가내역 확인 */
		SELECT NVL(B.UNPRC, 0), cunit
		  INTO :dItemPrice, :sTuncu
		  FROM DANMST B 
		 WHERE B.ITNBR	   = :sItem 
			AND B.OPSEQ    = '9999'
			AND B.CVCOD 	= :sitnbr ; 
			
		IF isnull(sTuncu) or stuncu = '' THEN 
			sTuncu = 'WON'
			dItemPrice = 0
		END IF
		
		if stuncu <> 'WON' then 
			dWonprc = sqlca.erp000000090_1(syear +'01', sitem, sTuncu, dItemPrice, '2') ;
		else
			dWonprc = dItemPrice
		end if
		dw_insert.SetItem(lRow, "ypdprc", dWonprc)
	ELSE
		dw_insert.SetItem(lRow, "ypdprc",0)
	END IF
	return ireturn 
END IF

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
ELSEIF this.GetColumnName() = "cvcod" then
	w_mdi_frame.sle_msg.text = '일반 거래처 조회는 F2 KEY 를 누르세요!'
	gs_code     = this.object.itnbr[iCurRow]
	gs_codename = '9999'
	open(w_danmst_popup)
	if gs_code = '' or isnull(gs_code) then return
	this.object.cvcod[iCurRow] = gs_code
	this.TriggerEvent(ItemCHanged!)
END IF

end event

event dw_insert::itemerror;RETURN 1
end event

event dw_insert::ue_key;setnull(gs_code)
setnull(gs_codename)

IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
	IF this.GetColumnName() = 'cvcod'	THEN
		
		gs_gubun = '1'
		
		Open(w_vndmst_popup)
	
      if gs_code = '' or isnull(gs_code) then return 		
	
		SetItem(this.getrow(),"cvcod",gs_code)

		this.TriggerEvent("itemchanged")
		
	END IF
END IF
end event

event dw_insert::clicked;call super::clicked;if row <=0 then return

this.SelectRow(0,False)
this.SelectRow(row,True)
end event

event dw_insert::rowfocuschanged;call super::rowfocuschanged;if currentrow <=0 then return

this.SelectRow(0,False)
this.SelectRow(currentrow,True)
end event

type p_delrow from w_inherite`p_delrow within w_imt_00005
boolean visible = false
integer x = 3451
integer y = 3368
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_imt_00005
boolean visible = false
integer x = 3278
integer y = 3368
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_imt_00005
boolean visible = false
integer x = 3273
integer y = 3520
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_imt_00005
integer x = 3739
integer y = 12
integer taborder = 40
boolean enabled = false
string picturename = "C:\erpman\image\추가_d.gif"
end type

event p_ins::clicked;call super::clicked;string s_year
Int    i_seq
long   i, il_currow, il_rowcount

if dw_1.AcceptText() = -1 then return 

s_year = trim(dw_1.GetItemString(1,'syear'))
i_seq  = dw_1.GetItemNumber(1,'cha')

if isnull(s_year) or s_year = "" then
	f_message_chk(30,'[계획년도]')
	dw_1.Setcolumn('syear')
	dw_1.SetFocus()
	return
end if	
if isnull(i_seq) or i_seq = 0 then
	f_message_chk(30,'[차수]')
	dw_1.Setcolumn('cha')
	dw_1.SetFocus()
	return
end if	

il_rowcount = dw_insert.RowCount()
FOR i = 1 TO il_rowcount
	IF wf_required_chk(i) = -1 THEN RETURN
NEXT

il_currow = dw_insert.InsertRow(0)

dw_insert.ScrollToRow(il_currow)
dw_insert.SetColumn('itnbr')
dw_insert.SetFocus()

dw_1.enabled = false
//cb_search.enabled = false
ib_any_typing =True

end event

type p_exit from w_inherite`p_exit within w_imt_00005
integer x = 4434
integer y = 12
end type

type p_can from w_inherite`p_can within w_imt_00005
integer x = 4261
integer y = 12
end type

event p_can::clicked;call super::clicked;
dw_insert.reset()

dw_1.enabled = true
//cb_search.enabled = true
p_ins.enabled = false
p_ins.pictureName = "C:\erpman\image\조회_d.gif"
p_del.enabled = false
p_del.pictureName = "C:\erpman\image\삭제_d.gif"

ib_any_typing = FALSE



dw_1.setfocus()

end event

type p_print from w_inherite`p_print within w_imt_00005
boolean visible = false
integer x = 3451
integer y = 3544
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_imt_00005
integer x = 3566
integer y = 12
integer taborder = 20
end type

event p_inq::clicked;call super::clicked;string s_year, s_ittyp, s_fritcls, s_toitcls, s_fritnbr, s_toitnbr, s_empno, ssaupj
Int    i_seq

if dw_1.AcceptText() = -1 then return 

s_year  = trim(dw_1.GetItemString(1,'syear'))
i_seq   = dw_1.GetItemNumber(1,'cha')

if isnull(s_year) or s_year = "" then
	f_message_chk(30,'[계획년도]')
	dw_1.Setcolumn('syear')
	dw_1.SetFocus()
	return
end if

if isnull(i_seq) or i_seq = 0 then
	f_message_chk(30,'[조정차수]')
	dw_1.Setcolumn('cha')
	dw_1.SetFocus()
	return
end if	

s_empno   = trim(dw_1.GetItemString(1,'empno'))
s_ittyp   = trim(dw_1.GetItemString(1,'sittyp'))
s_fritcls = trim(dw_1.GetItemString(1,'fr_itcls'))
s_toitcls = trim(dw_1.GetItemString(1,'to_itcls'))
s_fritnbr = trim(dw_1.GetItemString(1,'fr_itnbr1'))
s_toitnbr = trim(dw_1.GetItemString(1,'to_itnbr2'))
ssaupj    = trim(dw_1.GetItemString(1,'saupj'))

if IsNull(s_empno)   or s_empno   = "" then  s_empno = '%'
if IsNull(s_ittyp)   or s_ittyp   = "" then  s_ittyp = '%'
if isnull(s_fritcls) or s_fritcls = "" then	s_fritcls = '.'
if isnull(s_toitcls) or s_toitcls = "" then	s_toitcls = 'zzzzzzz'
if isnull(s_fritnbr) or s_fritnbr = "" then  s_fritnbr = '.'
if isnull(s_toitnbr) or s_toitnbr = "" then  s_toitnbr = 'zzzzzzzzzzzzzzz'
	
w_mdi_frame.sle_msg.text = "자료를 조회중입니다. "

if dw_insert.Retrieve(gs_sabu, s_year, i_seq, s_empno, s_fritnbr, s_toitnbr, &
                      s_ittyp,  s_fritcls, s_toitcls, ssaupj) <= 0 then 
	w_mdi_frame.sle_msg.text = ""
	f_message_chk(50,'')
	dw_1.SetFocus()
	p_ins.enabled = true
	p_ins.pictureName = "C:\erpman\image\추가_up.gif"
	p_del.enabled = true
	p_del.pictureName = "C:\erpman\image\삭제_up.gif"
	ib_any_typing = FALSE
	return
end if	

w_mdi_frame.sle_msg.text = " " 
	
p_ins.enabled = true
p_ins.pictureName = "C:\erpman\image\추가_up.gif"
p_del.enabled = true
p_del.pictureName = "C:\erpman\image\삭제_up.gif"
ib_any_typing = FALSE

end event

type p_del from w_inherite`p_del within w_imt_00005
integer x = 4087
integer y = 12
end type

event p_del::clicked;call super::clicked;string s_itnbr, s_year
int    i_seq
long   lRow

if dw_1.AcceptText() = -1 then return 
if dw_insert.AcceptText() = -1 then return 
if dw_insert.rowcount() <= 0 then return 

lRow = dw_insert.getrow()
if lRow <= 0 then 
	messagebox('확 인', '삭제할 자료를 선택하세요!')
	return 
end if

if f_msg_delete() = -1 then return

s_year  = dw_1.GetItemString(1,'syear')
s_year  = s_year + '%'
i_seq   = dw_1.GetItemNumber(1,'cha')
s_itnbr = dw_insert.GetItemString(lRow,'itnbr')

dw_insert.SetRedraw(FALSE)
dw_insert.DeleteRow(0)

DELETE FROM "YEAPLN_MEIP"  
 WHERE ( "YEAPLN_MEIP"."SABU" = :gs_sabu ) AND  
		 ( "YEAPLN_MEIP"."ITNBR" = :s_itnbr ) AND  
		 ( "YEAPLN_MEIP"."YEAYYMM" like :s_year ) AND  
		 ( "YEAPLN_MEIP"."YEACHA" = :i_seq )   ;

if sqlca.sqlcode = 0 then
	w_mdi_frame.sle_msg.text =	"자료를 삭제하였습니다!!"	
	ib_any_typing = FALSE
	commit ;
else
	rollback ;
   messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
end if	
dw_insert.SetRedraw(TRUE)



end event

type p_mod from w_inherite`p_mod within w_imt_00005
integer x = 3913
integer y = 12
end type

event p_mod::clicked;call super::clicked;Long   k, i, iseq, lRow  
double d_yprc, d_qty, gu_qty
string sflag, sitnbr, syear, s_yymm, s_cvcod, s_itgu, s_column
String sMonth[12] = {'01','02','03','04','05','06','07','08','09','10','11','12'}

if dw_1.AcceptText()      = -1 then return 
if dw_insert.AcceptText() = -1 then return 

lRow = dw_insert.rowcount()
if lRow  <= 0  then return 

FOR k = 1 TO lRow
	IF wf_required_chk(k) = -1 THEN RETURN
NEXT

if f_msg_update() = -1 then return

SetPointer(HourGlass!)
w_mdi_frame.sle_msg.text = "저장 중.........."
syear  = dw_1.getitemstring(1, 'syear') 	
iseq   = dw_1.getitemnumber(1, 'cha')

FOR k = 1 TO dw_insert.RowCount()
   sflag  = dw_insert.getitemstring(k, 'flag')
   sitnbr = dw_insert.getitemstring(k, 'itnbr')
   d_yprc = dw_insert.getitemnumber(k, 'ypdprc') // 단가 
   
   if sflag = 'N' then   //UPDATE
		FOR i = 1 TO 12
         s_column = "guqty" + sMonth[i]
			s_yymm   = syear + sMonth[i]
         d_qty    = dw_insert.getitemnumber(k, s_column)
			s_cvcod  = dw_insert.getitemstring(k, "cvcod" )
			s_itgu   = dw_insert.getitemstring(k, "itgu" )

			IF isnull(d_qty) then d_qty = 0

			UPDATE "YEAPLN_MEIP"  
			   SET "GUPLANQTY" = :d_qty,
				    "CVCOD"     = :s_cvcod,
				    "ITGU"      = :s_itgu,
					 "YPDPRC"    = :d_yprc,
					 "YPDAMT"    = "YPDQTY" * :d_yprc
			 WHERE ( "YEAPLN_MEIP"."SABU"    = :gs_sabu ) 
			   AND ( "YEAPLN_MEIP"."ITNBR"   = :sitnbr ) 
				AND ( "YEAPLN_MEIP"."YEAYYMM" = :s_yymm )
				AND ( "YEAPLN_MEIP"."YEACHA"  = :iseq ) ;

			  if sqlca.sqlcode <> 0 then			
				  rollback ;
				  messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
				  return 
			  end if		
		 NEXT
	else                 //INSERT
		FOR i = 1 TO 12

			s_column = "guqty" + sMonth[i]
			s_yymm   = syear + sMonth[i]
			gu_qty   = dw_insert.getitemnumber(k, s_column)
			s_cvcod  = dw_insert.getitemstring(k, "cvcod" )
			s_itgu   = dw_insert.getitemstring(k, "itgu" ) //수입구분 (구매, 외자)
			
			IF isnull(gu_qty) then gu_qty = 0
			
		   INSERT INTO "YEAPLN_MEIP"  
					 ( "SABU",  "ITNBR", "YEAYYMM",   "YEACHA", "YPDQTY",   
						"YPDPRC","YPDAMT","CURR_DATE", "CVCOD",  "ITGU",  "GUPLANQTY" )  
			VALUES (:gs_sabu,:sitnbr, :s_yymm,     :iseq ,   0,
					  :d_yprc,  0,       :is_today,   :s_cvcod, :s_itgu, :gu_qty ) ;  

        if sqlca.sqlcode <> 0 then			
	   	  rollback ;
			  messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
			  return 
	     end if		
			
		NEXT
   end if		
NEXT

if sqlca.sqlcode = 0 then
	commit ;
	w_mdi_frame.sle_msg.text = "자료가 저장되었습니다!!"
else
	rollback ;
	messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
	return 
end if	
		
p_inq.TriggerEvent(clicked!)

end event

type cb_exit from w_inherite`cb_exit within w_imt_00005
integer x = 4137
integer y = 2532
integer height = 104
end type

type cb_mod from w_inherite`cb_mod within w_imt_00005
integer x = 3095
integer y = 2532
integer height = 104
end type

type cb_ins from w_inherite`cb_ins within w_imt_00005
integer x = 2610
integer y = 2520
integer height = 104
end type

type cb_del from w_inherite`cb_del within w_imt_00005
integer x = 3447
integer y = 2532
integer height = 104
end type

type cb_inq from w_inherite`cb_inq within w_imt_00005
integer x = 2263
integer y = 2520
integer height = 104
end type

type cb_print from w_inherite`cb_print within w_imt_00005
integer x = 2697
integer y = 2672
end type

type st_1 from w_inherite`st_1 within w_imt_00005
end type

type cb_can from w_inherite`cb_can within w_imt_00005
integer x = 3790
integer y = 2532
integer height = 104
end type

type cb_search from w_inherite`cb_search within w_imt_00005
integer x = 2171
integer y = 2620
end type







type gb_button1 from w_inherite`gb_button1 within w_imt_00005
integer x = 1440
integer y = 2468
end type

type gb_button2 from w_inherite`gb_button2 within w_imt_00005
integer x = 2158
integer y = 2520
end type

type gb_3 from groupbox within w_imt_00005
boolean visible = false
integer x = 3054
integer y = 2480
integer width = 1458
integer height = 180
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
end type

type dw_1 from datawindow within w_imt_00005
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 37
integer y = 16
integer width = 3323
integer height = 264
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_imt_00005"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;//str_itnct str_sitnct
//string snull
//
//setnull(gs_code)
//setnull(snull)
//
IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
//ELSEIF keydown(keyF2!) THEN
//		IF This.GetColumnName() = "fr_itnbr" Then
//			open(w_itemas_popup2)
//			if isnull(gs_code) or gs_code = "" then return
//			
//			this.SetItem(1,"fr_itnbr",gs_code)
//			RETURN 1
//		ELSEIF This.GetColumnName() = "to_itnbr" Then
//			open(w_itemas_popup2)
//			if isnull(gs_code) or gs_code = "" then return
//			
//			this.SetItem(1,"to_itnbr",gs_code)
//			RETURN 1
//		ELSEIF This.GetColumnName() = "fr_itcls" Then
//   		this.accepttext()
//			gs_code = this.getitemstring(1, 'sittyp')
//			
//			open(w_ittyp_popup3)
//			
//			str_sitnct = Message.PowerObjectParm	
//			
//			if isnull(str_sitnct.s_ittyp) or str_sitnct.s_ittyp = "" then 
//				return 
//			elseif str_sitnct.s_ittyp = '1' or str_sitnct.s_ittyp = '2' or &
//					 str_sitnct.s_ittyp = '7' THEN //1완제품, 2반제품, 7상품  
//				this.SetItem(1,"sittyp", str_sitnct.s_ittyp)
//				this.SetItem(1,"fr_itcls", str_sitnct.s_sumgub)
//				RETURN 1
// 			else
//				f_message_chk(61,'[품목구분]')
//				return 1
//			end if	
//		ELSEIF This.GetColumnName() = "to_itcls" Then
//   		this.accepttext()
//			gs_code = this.getitemstring(1, 'sittyp')
//			
//			open(w_ittyp_popup3)
//			
//			str_sitnct = Message.PowerObjectParm	
//			
//			if isnull(str_sitnct.s_ittyp) or str_sitnct.s_ittyp = "" then 
//				return 
//			elseif str_sitnct.s_ittyp = '1' or str_sitnct.s_ittyp = '2' or &
//					 str_sitnct.s_ittyp = '7' THEN //1완제품, 2반제품, 7상품  
//				this.SetItem(1,"sittyp", str_sitnct.s_ittyp)
//				this.SetItem(1,"to_itcls", str_sitnct.s_sumgub)
//	   		RETURN 1
// 			else
//				f_message_chk(61,'[품목구분]')
//				return 1
//			end if	
//      End If
//END IF
//
end event

event itemchanged;string snull, syear, s_name, s_itt, s_nextyear, s_gub, steam, steamnm, stitnm, stextnm
int    iseq, inull, get_yeacha, i

setnull(snull)
setnull(inull)

IF this.GetColumnName() ="syear" THEN
	syear = trim(this.GetText())
	
	if syear = "" or isnull(syear) then
  		this.setitem(1, 'cha', inull)
		return 
	end if	

	SELECT MAX("YEAPLN_MEIP"."YEACHA")  
	  INTO :get_yeacha  
	  FROM "YEAPLN_MEIP"  
	 WHERE ( "YEAPLN_MEIP"."SABU" = :gs_sabu ) AND  
			 ( "YEAPLN_MEIP"."YEAYYMM" like :syear||'%' )   ;
	
	this.setitem(1, 'cha', get_yeacha)

ELSEIF this.GetColumnName() ="cha" THEN
	this.accepttext()
	iseq = integer(this.GetText())
   syear = this.getitemstring(1, 'syear')
	
	if iseq = 0  or isnull(iseq)  then return 
	
	if syear = "" or isnull(syear) then 
		messagebox("확인", "계획년도를 먼저 입력 하십시요!!")
		this.setcolumn('syear')
		this.setfocus()
		return 1
	end if		
		
	SELECT MAX("YEAPLN_MEIP"."YEACHA")  
	  INTO :get_yeacha  
	  FROM "YEAPLN_MEIP"  
	 WHERE ( "YEAPLN_MEIP"."SABU" = :gs_sabu ) AND  
			 ( "YEAPLN_MEIP"."YEAYYMM" like :syear||'%' )  ;
			 
	if isnull(get_yeacha) or get_yeacha = 0  then
		IF iseq <> 1 then
   		messagebox("확인", syear + "년에 최종 조정차수가 없으니 " &
			                   + "1차만 입력가능합니다!!")
	  		this.setitem(1, 'cha', 1)
       	this.setcolumn('cha')
         this.setfocus()
 			return 1
      end if		
	else
		if iseq > get_yeacha + 1 then
   		messagebox("확인", syear + "년에 최종 조정차수가 " + &
			                   string(get_yeacha) + "차 입니다!!")
			this.setitem(1, 'cha', get_yeacha)
       	this.setcolumn('cha')
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
		ELSEIF s_itt = '1' or s_itt = '2' or s_itt = '7'  or s_itt = '3' or s_itt = '5' or s_itt = '8' or s_itt= '9' THEN //1완제품, 2반제품, 7상품  
		ELSE 	
			f_message_chk(61,'[품목구분]')
			this.SetItem(1,'sittyp', snull)
			this.SetItem(1,'fr_itcls', snull)
			this.SetItem(1,'to_itcls', snull)
			return 1
		END IF	
ELSEIF this.GetColumnName() = 'saupj' THEN
	s_itt = this.gettext()
	
	f_child_saupj(dw_1,'empno',s_itt)
END IF

end event

event itemerror;RETURN 1
end event

event losefocus;THIS.accepttext()
end event

event rbuttondown;string  sname
str_itnct lstr_sitnct

setnull(gs_code)
setnull(gs_codename)
SetNull(gs_gubun)

if this.GetColumnName() = 'fr_itcls' then
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
elseif this.getcolumnname() = "fr_itnbr1" then //품번1
   gs_gubun = '3'
	open(w_itemas_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.object.fr_itnbr1[1] = gs_code
elseif this.getcolumnname() = "to_itnbr2" then //품번2
   gs_gubun = '3'
	open(w_itemas_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.object.to_itnbr2[1] = gs_code
end if	

end event

type gb_2 from groupbox within w_imt_00005
boolean visible = false
integer x = 2226
integer y = 2468
integer width = 754
integer height = 184
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
end type

type rr_2 from roundrectangle within w_imt_00005
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 284
integer width = 4567
integer height = 2024
integer cornerheight = 40
integer cornerwidth = 46
end type

