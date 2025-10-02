$PBExportHeader$w_imt_02510.srw
$PBExportComments$** 제품 재료비 현황
forward
global type w_imt_02510 from w_standard_print
end type
type dw_hidden from datawindow within w_imt_02510
end type
type dw_hidden5 from datawindow within w_imt_02510
end type
type dw_process from datawindow within w_imt_02510
end type
type pb_1 from u_pic_cal within w_imt_02510
end type
end forward

global type w_imt_02510 from w_standard_print
string title = "제품 재료비 현황"
dw_hidden dw_hidden
dw_hidden5 dw_hidden5
dw_process dw_process
pb_1 pb_1
end type
global w_imt_02510 w_imt_02510

type variables
long ilrow
str_itnct str_sitnct
end variables

forward prototypes
public function integer wf_setitem (string arg_item, string arg_today, string susedate, string sdangagb, string sgbn, string sopt)
public function integer wf_retrieve ()
end prototypes

public function integer wf_setitem (string arg_item, string arg_today, string susedate, string sdangagb, string sgbn, string sopt);dw_hidden5.reset()
dw_hidden.reset()
dw_process.reset()

IF sdangagb = '5' THEN
	if sopt = 'Y' then 
		dw_hidden5.dataobject = 'd_imt_02510_31'
	else
		dw_hidden5.dataobject = 'd_imt_02510_3'
	end if
	dw_hidden5.settransobject(sqlca)
	If dw_hidden5.retrieve(arg_item, LEFT(arg_today, 6)) < 1 Then
		RETURN -1
	End if
	if sopt = 'Y' then 
		dw_process.dataobject = 'd_imt_02510_31'
	else
		dw_process.dataobject = 'd_imt_02510_3'
	end if
	dw_process.Object.Data = dw_hidden5.Object.Data
ELSE
	if sopt = 'Y' then 
		dw_hidden.dataobject = 'd_imt_02510_21'
	else
		dw_hidden.dataobject = 'd_imt_02510_2'
	end if
	dw_hidden.settransobject(sqlca)
	If dw_hidden.retrieve(arg_item, susedate, sdangagb) < 1 Then
		RETURN -1
	End if
	if sopt = 'Y' then 
		dw_process.dataobject = 'd_imt_02510_21'
	else
		dw_process.dataobject = 'd_imt_02510_2'
	end if
	dw_process.Object.Data = dw_hidden.Object.Data
END IF	

long lrow, lvlno
/* 유효일자 적용 */
for lrow = 1 to dw_process.rowcount()
	 if susedate < dw_process.getitemstring(lrow, "startdate")  or &
		 susedate > dw_process.getitemstring(lrow, "enddate")  Then
		 lvlno = dw_process.getitemdecimal(lrow, "lvlno")
		 dw_process.deleterow(lrow)
		 Do while true	
			 if lrow  > dw_process.rowcount() then exit
			 if lvlno < dw_process.getitemdecimal(lrow, "lvlno") then
				 dw_process.deleterow(lrow)				 
			 Else
				 Exit
			 End if
		 Loop
		 lrow = lrow - 1
	end if
Next

/* 구성수량 재계산 */
Decimal dsaveqty[10], dtempqty, drstqty, xx, yy

w_mdi_frame.sle_msg.text = '구성수량을 재계산중입니다.'
For lrow = 1 to dw_process.rowcount()
	 If dw_process.getitemdecimal(lrow, "lvlno") = 1 Then
		 dsaveqty[1] = dw_process.getitemdecimal(lrow, "qtypr")
		 dw_process.setitem(lrow, "qtypr", dsaveqty[1])
		 continue
	 end if
	 
	 xx = dw_process.getitemdecimal(lrow, "lvlno") - 1
	 yy = dw_process.getitemdecimal(lrow, "lvlno")
	 dtempqty = dsaveqty[xx]
	 drstqty  = dtempqty * dw_process.getitemdecimal(lrow, "qtypr")
	 dsaveqty[yy] = drstqty
	 dw_process.setitem(lrow, "qtypr", drstqty)
Next

//dw_process.setsort("cinbr A")
//dw_process.sort()

/* 품번별 집계 */
Lrow = 0
Do while True
	Lrow++
	If Lrow >= dw_process.rowcount() Then
		Exit
	End if
	If dw_process.getitemstring(Lrow,     "cinbr") = &
		dw_process.getitemstring(Lrow + 1, "cinbr")   Then
		dw_process.setitem(Lrow + 1, "qtypr", dw_process.getitemdecimal(Lrow + 1, "qtypr") + &
														 dw_process.getitemdecimal(Lrow, "qtypr"))
		dw_process.deleterow(Lrow)
		Lrow = Lrow - 1
	End if
Loop

long lins
Dec {2} yuprice //외주처 단가금액

if sgbn = '1' then
	For lrow = 1 to dw_process.rowcount()
		
		 if dw_process.getitemstring(lrow, "ittyp") = '8' then //가상부품인 경우에는 제외
			 continue	
		 end if

		 if dw_process.getitemstring(lrow, "ittyp") = '2' then //반제품인 경우에는 제외
			 continue	
		 end if
		 
		 lins = dw_print.insertrow(0)
		 if lrow = 1 and sopt = 'Y' then 
			 yuprice =  SQLCA.FUN_DANMST_DANGA3(arg_today, arg_item, '.')
			 dw_print.setitem(1, "yamt", yuprice)
		 end if
		 
		 dw_print.setitem(lins, "lvlno", dw_process.getitemdecimal(lrow, "lvlno"))
		 dw_print.setitem(lins, "pinbr", dw_process.getitemstring(lrow, "pinbr"))
		 dw_print.setitem(lins, "cinbr", dw_process.getitemstring(lrow, "cinbr"))
		 dw_print.setitem(lins, "itdsc", dw_process.getitemstring(lrow, "itdsc"))
		 dw_print.setitem(lins, "ispec", dw_process.getitemstring(lrow, "ispec"))
		 dw_print.setitem(lins, "jijil", dw_process.getitemstring(lrow, "jijil"))
		 dw_print.setitem(lins, "qtypr", dw_process.getitemdecimal(lrow, "qtypr"))
		 dw_print.setitem(lins, "abcgb", dw_process.getitemstring(lrow, "abcgb"))
		 dw_print.setitem(lins, "jejos", dw_process.getitemstring(lrow, "cvnas"))	// 제조처는 공급처로 변경
		 dw_print.setitem(lins, "itgu",  dw_process.getitemstring(lrow, "itgu"))
		 dw_print.setitem(lins, "cunit", dw_process.getitemstring(lrow, "cunit"))
		 dw_print.setitem(lins, "ydate", dw_process.getitemstring(lrow, "ydate"))
		 dw_print.setitem(lins, "uprice",  dw_process.getitemdecimal(lrow, "uprice"))
		 dw_print.setitem(lins, "tuprice", dw_process.getitemdecimal(lrow, "tuprice"))
	Next
else
	string sitgu, sitnbr
	
   lins = dw_print.insertrow(0)	
   ilrow = lins
	For lrow = 1 to dw_process.rowcount()	
		 sitnbr = dw_process.getitemstring(lrow, "cinbr")
		 sitgu  = dw_process.getitemstring(lrow, "itgu")
		 
		 //select itgu into :sitgu from itemas where itnbr = :sitnbr;
		
		 if sitgu = '1' or sitgu = '6' then //외주
			 dw_print.setitem(lins, "tamt1",  dw_print.getitemdecimal(lins, "tamt1") + &
										 Round(dw_process.getitemdecimal(lrow, "qtypr") &													 
												  * dw_process.getitemdecimal(lrow, "tuprice"), 2))
		 elseif sitgu = '3' or sitgu = '4' then // 외자
			 dw_print.setitem(lins, "tam3",  dw_print.getitemdecimal(lins, "tam3") + &
										 Round(dw_process.getitemdecimal(lrow, "qtypr") &													 
												  * dw_process.getitemdecimal(lrow, "tuprice"), 2))
		 elseif sitgu = '2' then					// 구매
			 dw_print.setitem(lins, "tam2",  dw_print.getitemdecimal(lins, "tam2") + &
										 Round(dw_process.getitemdecimal(lrow, "qtypr") &													 
												  * dw_process.getitemdecimal(lrow, "tuprice"), 2))
												  
		 else                                 // 기타
			 dw_print.setitem(lins, "tamt6",  dw_print.getitemdecimal(lins, "tamt6") + &
										 Round(dw_process.getitemdecimal(lrow, "qtypr") &													 
												  * dw_process.getitemdecimal(lrow, "tuprice"), 2))
		 end if
	Next	
end if

w_mdi_frame.sle_msg.text = ''
RETURN 1
end function

public function integer wf_retrieve ();String  s_itnbr, s_ispec, s_itdsc, susedate, sdangagb, sgubun, s_titnbr, &
        chkitnbr, sYymm, sopt, s_jijil, sItcls
long lcnt, lchk
integer ireturn
Decimal {2} dprice, dAmt

if dw_ip.AcceptText() = -1 then return -1

s_itnbr 	 = dw_ip.GetItemString(1,"fr_itnbr")
sdangagb  = dw_ip.GetItemString(1,"gubun2")
sgubun    = dw_ip.GetItemString(1,"gubun")
s_titnbr  = dw_ip.GetItemString(1,"to_itnbr")
susedate  = trim(dw_ip.GetItemString(1,"susedate"))
sYymm     = trim(dw_ip.GetItemString(1,"yymm"))
sOpt      = dw_ip.GetItemString(1,"opt")
sItcls    = dw_ip.GetItemString(1,"itcls")

IF sgubun = '2' THEN 
	IF s_itnbr = "" OR IsNull(s_itnbr) THEN 	s_itnbr = '.'
	IF s_titnbr = "" OR IsNull(s_titnbr) THEN 	s_titnbr = 'zzzzzzzzzz'
Else
	IF s_itnbr = "" OR IsNull(s_itnbr) THEN 
		f_message_chk(30,'[품번]')
		dw_ip.Setcolumn('fr_itnbr')
		dw_ip.SetFocus()
		return -1
	ELSE
		SELECT ITDSC, DECODE(ISPEC_CODE, NULL, ISPEC, ISPEC||'-'||ISPEC_CODE), JIJIL
		  INTO :s_itdsc, :s_ispec, :s_jijil
		  FROM ITEMAS
		 WHERE ITNBR = :s_itnbr ;
	END IF
End If

IF s_itdsc = "" OR IsNull(s_itdsc) THEN  s_itdsc = ' '
IF s_ispec = "" OR IsNull(s_ispec) THEN  s_ispec = ' '
IF s_jijil = "" OR IsNull(s_jijil) THEN  s_jijil = ' '
IF sItcls = "" OR IsNull(sItcls) THEN  sItcls = ''

IF sdangagb = '1' THEN 
	if isnull(susedate) or trim(susedate) = '' then
		f_message_chk(30,'[기준일자]')
		dw_ip.Setcolumn('susedate')
		dw_ip.SetFocus()
		return -1
	end if
ELSEIF sdangagb = '5' THEN 
	if isnull(syymm) or trim(syymm) = '' then
		f_message_chk(30,'[마감년월]')
		dw_ip.Setcolumn('yymm')
		dw_ip.SetFocus()
		return -1
	end if
END IF

SetPointer(HourGlass!)
dw_print.reset()
dw_hidden.reset()
dw_hidden5.reset()

if sgubun = '1' then // 제품건별 상세내역
   if sopt = 'Y' then 
		dw_list.dataobject = 'd_imt_02510_11'
		dw_print.dataobject = 'd_imt_02510_11_p'
	else
		dw_list.dataobject = 'd_imt_02510_1'
		dw_print.dataobject = 'd_imt_02510_1_p'
	end if
	dw_list.settransobject(sqlca)
	dw_print.settransobject(sqlca)
	dw_print.setredraw(false)

	IF wf_setitem(s_itnbr, sYymm, susedate, sdangagb, sgubun, sopt) = -1 THEN
		f_message_chk(50,'')
		dw_ip.Setfocus()
		dw_print.setredraw(true)
		return -1
	end if

	dw_print.Object.t_itnbr.text = s_itnbr
	dw_print.Object.t_itdsc.text = s_itdsc
	dw_print.Object.t_ispec.text = s_ispec
//	dw_print.Object.t_jijil.text = s_jijil

	
elseif sgubun = '2' then	// 제품별 내역

	dw_list.dataobject = 'd_imt_02510_6'
	dw_print.dataobject = 'd_imt_02510_6_p'
	dw_list.settransobject(sqlca)
	dw_print.settransobject(sqlca)
	dw_print.setredraw(false)

	IF dw_print.Retrieve(susedate, sdangagb, s_itnbr, s_titnbr, sItcls+'%') = -1 THEN
		f_message_chk(50,'')
		dw_ip.Setfocus()
		dw_print.setredraw(true)
		return -1
	end if
//						if sopt = 'Y' then 
//							dw_list.dataobject = 'd_imt_02510_41'
//							dw_print.dataobject = 'd_imt_02510_41_p'
//						else
//							dw_list.dataobject = 'd_imt_02510_4'
//							dw_print.dataobject = 'd_imt_02510_4_p'
//						end if
//						dw_list.settransobject(sqlca)
//						dw_print.settransobject(sqlca)
//						
//						lcnt = 0
//						lchk = 0
//						
//						dw_print.setredraw(false)
//					
//						select count(*) into :lcnt from itemas where itnbr between :s_itnbr and :s_titnbr;
//						
//						if lcnt < 1 then
//							Messagebox("제품별", "검색대상이 없읍니다", stopsign!)
//							dw_print.setredraw(true)
//					//		dw_print.InsertRow(0)
//							return -1
//						end if
//						
//						select min(itnbr) into :chkitnbr from itemas where itnbr >= :s_itnbr;
//						
//						do while chkitnbr <= s_titnbr
//							
//							ireturn = wf_setitem(chkitnbr, syymm, susedate, sdangagb, sgubun, sopt)
//							
//							lchk = lchk + 1;		
//							sle_msg.text = '검색대상건수 -> ' + string(lcnt) + ' 현재검색건수 -> ' + string(lchk)
//							
//							select itdsc, decode(ispec, null, ispec, ispec||'-'||ispec_code), jijil 
//							  into :s_itdsc, :s_ispec , :s_jijil 
//							  from itemas 
//							 where itnbr = :chkitnbr;
//							
//							dw_print.setitem(ilrow, "cinbr", chkitnbr)
//							dw_print.setitem(ilrow, "itdsc", s_itdsc)
//							dw_print.setitem(ilrow, "ispec", s_ispec)
//							dw_print.setitem(ilrow, "jijil", s_jijil)
//					
//							 if sopt = 'Y' then 
//								 dprice =  SQLCA.FUN_DANMST_DANGA3(susedate, chkitnbr, '.')
//								 dw_print.setitem(ilrow, "tamt5", dprice)		
//								 dprice = 0
//							 end if
//							
//							dprice = sqlca.fun_erp100000012(susedate, chkitnbr, '.');		
//							
//							dw_print.setitem(ilrow, "tamt4", dprice)		
//							
//							select min(itnbr) into :chkitnbr from itemas where itnbr > :chkitnbr;
//							
//						Loop
//						
//						if lchk < 1 then
//							Messagebox("제품별", "검색대상이 없읍니다", stopsign!)
//							sle_msg.text = ''		
//							dw_print.setredraw(true)
//							dw_print.insertrow(0)
//					//		return -1
//						end if
else	// BOM별
	dw_list.dataobject = 'd_imt_02510_5_p'
	dw_print.dataobject = 'd_imt_02510_5_p'

	dw_list.settransobject(sqlca)
	dw_print.settransobject(sqlca)
	dw_print.setredraw(false)

	// 재료비 내역을 계산하기 위한 funtion 실행
	DECLARE proc1 procedure FOR ERP_CALC_PSTRUC2 (:s_itnbr, 1, :susedate, :sdangagb) USING SQLCA;
	EXECUTE proc1;
	FETCH proc1 INTO :dAmt;
	CLOSE proc1;

	IF dw_print.Retrieve(s_itnbr) = -1 THEN
		f_message_chk(50,'')
		dw_ip.Setfocus()
		dw_print.setredraw(true)
		return -1
	end if

	dw_print.Object.t_itnbr.text = s_itnbr
	dw_print.Object.t_itdsc.text = s_itdsc
	dw_print.Object.t_ispec.text = s_ispec
end if

w_mdi_frame.sle_msg.text = ''

if sdangagb = '1' then
	dw_print.Object.t_dangagubn.text  = '계약단가'
	dw_print.Object.t_date.text       = '기준일자 : ' + string(susedate,'@@@@.@@.@@')
	if sgubun = '1' then 
		dw_print.Object.mdate_t.text      = ''
	end if
end if
if sdangagb = '2' then
	dw_print.Object.t_dangagubn.text  = '최저단가'
	dw_print.Object.t_date.text       = ''
	if sgubun = '1' then 
		dw_print.Object.mdate_t.text   = '최저입고일'
	end if
end if
if sdangagb = '3' then 
	dw_print.Object.t_dangagubn.text  = '최고단가'
	dw_print.Object.t_date.text       = ''
	if sgubun = '1' then 
		dw_print.Object.mdate_t.text   = '최고입고일'
	end if
end if
if sdangagb = '4' then
	dw_print.Object.t_dangagubn.text  = '최종단가'
	dw_print.Object.t_date.text       = ''
	if sgubun = '1' then 
		dw_print.Object.mdate_t.text   = '최종입고일'
	end if
end if
if sdangagb = '5' then
	dw_print.Object.t_dangagubn.text  = '재고단가'
	dw_print.Object.t_date.text       = '마감년월 : ' + string(sYymm,'@@@@.@@')
	if sgubun = '1' then 
		dw_print.Object.mdate_t.text   = ''
	end if
end if

dw_print.setredraw(true)

if dw_print.rowcount() = 0 then 
//	dw_print.InsertRow(0)
	return -1
end if

dw_print.sharedata(dw_list)
return 1

end function

on w_imt_02510.create
int iCurrent
call super::create
this.dw_hidden=create dw_hidden
this.dw_hidden5=create dw_hidden5
this.dw_process=create dw_process
this.pb_1=create pb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_hidden
this.Control[iCurrent+2]=this.dw_hidden5
this.Control[iCurrent+3]=this.dw_process
this.Control[iCurrent+4]=this.pb_1
end on

on w_imt_02510.destroy
call super::destroy
destroy(this.dw_hidden)
destroy(this.dw_hidden5)
destroy(this.dw_process)
destroy(this.pb_1)
end on

event open;call super::open;string sYYmm

SELECT MAX(JPDAT)  
  INTO :sYYmm
  FROM JUNPYO_CLOSING  
 WHERE SABU = :gs_sabu AND JPGU = 'C0'   ;

dw_ip.setitem(1, 'yymm', syymm)  
dw_ip.setitem(1, 'susedate', f_today())
dw_ip.Setfocus()


end event

type dw_list from w_standard_print`dw_list within w_imt_02510
integer y = 528
integer width = 3489
integer height = 1964
string dataobject = "d_imt_02510_5_p"
end type

type cb_print from w_standard_print`cb_print within w_imt_02510
end type

type cb_excel from w_standard_print`cb_excel within w_imt_02510
end type

type cb_preview from w_standard_print`cb_preview within w_imt_02510
end type

type cb_1 from w_standard_print`cb_1 within w_imt_02510
end type

type dw_print from w_standard_print`dw_print within w_imt_02510
string dataobject = "d_imt_02510_5_p"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_02510
integer y = 56
integer width = 3489
integer height = 432
string dataobject = "d_imt_02510_a"
end type

event dw_ip::itemerror;
Return 1
end event

event dw_ip::rbuttondown;setnull(gs_gubun)
setnull(gs_code)
setnull(gs_codename)

if this.GetColumnName() = 'fr_itnbr' then
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"fr_itnbr",gs_code)
	this.TriggerEvent(ItemChanged!)
elseif this.GetColumnName() = 'to_itnbr' then
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"to_itnbr",gs_code)
	this.TriggerEvent(ItemChanged!)	
elseif this.GetColumnName() = "itcls" Then
	gs_gubun = '1'
	Open(w_itnct_l_popup)	
	IF gs_code ="" OR IsNull(gs_code) THEN RETURN
	
	SetItem(1,"itcls",gs_code)
	SetItem(1,"titnm",gs_codename)
end if	



end event

event dw_ip::ue_key;setnull(gs_code)

IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
	IF This.GetColumnName() = "fr_itnbr" Then
		open(w_itemas_popup2)
		if isnull(gs_code) or gs_code = "" then return
		
		this.SetItem(this.getrow(),"fr_itnbr",gs_code)
		this.TriggerEvent(ItemChanged!)
	End If
END IF

end event

event dw_ip::itemchanged;string  sitnbr, sitdsc, sispec, sdate
int     ireturn

IF this.GetColumnName() = "fr_itnbr"	THEN
	sItnbr = trim(this.GetText())
	ireturn = f_get_name2('품번', 'Y', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "fr_itnbr", sitnbr)	
	this.setitem(1, "fr_itdsc", sitdsc)	
	this.setitem(1, "fr_ispec", sispec)
	
	this.setitem(1, "to_itnbr", sitnbr)	
	this.setitem(1, "to_itdsc", sitdsc)	
	this.setitem(1, "to_ispec", sispec)
	
	RETURN ireturn
ELSEIF this.GetColumnName() = "fr_itdsc"	THEN
	sItdsc = trim(this.GetText())
	ireturn = f_get_name2('품명', 'Y', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "fr_itnbr", sitnbr)	
	this.setitem(1, "fr_itdsc", sitdsc)	
	this.setitem(1, "fr_ispec", sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = "fr_ispec"	THEN
	sIspec = trim(this.GetText())
	ireturn = f_get_name2('규격', 'Y', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "fr_itnbr", sitnbr)	
	this.setitem(1, "fr_itdsc", sitdsc)	
	this.setitem(1, "fr_ispec", sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = "to_itnbr"	THEN
	sItnbr = trim(this.GetText())
	ireturn = f_get_name2('품번', 'Y', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "to_itnbr", sitnbr)	
	this.setitem(1, "to_itdsc", sitdsc)	
	this.setitem(1, "to_ispec", sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = "to_itdsc"	THEN
	sItdsc = trim(this.GetText())
	ireturn = f_get_name2('품명', 'Y', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "to_itnbr", sitnbr)	
	this.setitem(1, "to_itdsc", sitdsc)	
	this.setitem(1, "to_ispec", sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = "to_ispec"	THEN
	sIspec = trim(this.GetText())
	ireturn = f_get_name2('규격', 'Y', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "to_itnbr", sitnbr)	
	this.setitem(1, "to_itdsc", sitdsc)	
	this.setitem(1, "to_ispec", sispec)
	RETURN ireturn	

ELSEIF this.GetColumnName() = "susedate"	THEN
	sDate = trim(this.GetText())

   IF sDate = '' or isnull(sdate) then return 

	if f_datechk(sDate) = -1 then
		f_message_chk(35, "[기준일자]")
		this.object.susedate[1] = ""
		return 1
	end if
ELSEIF this.GetColumnName() = "yymm"	THEN
	sDate = trim(this.GetText())

   IF sDate = '' or isnull(sdate) then return 

	if f_datechk(sDate + "01") = -1 then
		f_message_chk(35, "[마감년월]")
		this.object.yymm[1] = ""
		return 1
	end if
ELSEIF this.GetColumnName() = "gubun2" Then
	If data = '1' Then
		pb_1.Visible = True
	Else
		pb_1.Visible = False
	End IF
END IF

end event

type r_1 from w_standard_print`r_1 within w_imt_02510
integer y = 524
end type

type r_2 from w_standard_print`r_2 within w_imt_02510
integer height = 440
end type

type dw_hidden from datawindow within w_imt_02510
boolean visible = false
integer x = 3726
integer y = 200
integer width = 581
integer height = 244
boolean bringtotop = true
boolean titlebar = true
string title = "제품재료비(HIDDEN) - 1~~4"
string dataobject = "d_imt_02510_2"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean hsplitscroll = true
boolean livescroll = true
end type

type dw_hidden5 from datawindow within w_imt_02510
boolean visible = false
integer x = 1934
integer y = 2332
integer width = 1275
integer height = 360
boolean bringtotop = true
boolean titlebar = true
string title = "제품재료비(HIDDEN)-재고단가"
string dataobject = "d_imt_02510_3"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_process from datawindow within w_imt_02510
boolean visible = false
integer x = 69
integer y = 2332
integer width = 494
integer height = 360
boolean bringtotop = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type pb_1 from u_pic_cal within w_imt_02510
integer x = 2656
integer y = 240
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('susedate')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'susedate', gs_code)



end event

