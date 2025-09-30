$PBExportHeader$w_adt_00920.srw
$PBExportComments$제품 입출고 현황
forward
global type w_adt_00920 from w_standard_print
end type
type rr_1 from roundrectangle within w_adt_00920
end type
type rb_1 from radiobutton within w_adt_00920
end type
type rb_2 from radiobutton within w_adt_00920
end type
type rr_2 from roundrectangle within w_adt_00920
end type
type rr_3 from roundrectangle within w_adt_00920
end type
end forward

global type w_adt_00920 from w_standard_print
integer width = 4645
integer height = 2504
string title = "제품 입출고 현황"
rr_1 rr_1
rb_1 rb_1
rb_2 rb_2
rr_2 rr_2
rr_3 rr_3
end type
global w_adt_00920 w_adt_00920

type variables
str_itnct lstr_sitnct
dec idMeter
string is_gubun
end variables

forward prototypes
public subroutine wf_move (string sitnbr, string sitdsc, string sispec)
public function integer wf_retrieve ()
end prototypes

public subroutine wf_move (string sitnbr, string sitdsc, string sispec);if sitnbr = '' or isnull(sitnbr) then return 

dw_ip.setitem(1, "to_itnbr", sitnbr)	
dw_ip.setitem(1, "to_itdsc", sitdsc)	
dw_ip.setitem(1, "to_ispec", sispec)

end subroutine

public function integer wf_retrieve ();String  ls_sdate, ls_edate, ls_ittyp, ls_sitcls, ls_eitcls, ls_sitnbr, ls_eitnbr, ls_saupj, ls_depot, ls_mayymm
String  ls_oldsql, ls_newsql, ls_finalsql
Long    ll_pos

IF dw_ip.AcceptText() = -1 THEN RETURN -1

ls_sdate   = TRIM(dw_ip.GetItemString(1,"syymm"))
ls_edate   = TRIM(dw_ip.GetItemString(1,"eyymm"))
ls_ittyp   = TRIM(dw_ip.GetItemString(1,"itgu"))
ls_sitcls  = TRIM(dw_ip.GetItemString(1,"itcls"))
ls_eitcls  = TRIM(dw_ip.GetItemString(1,"eitcls"))
ls_sitnbr  = TRIM(dw_ip.GetItemString(1,"fr_itnbr"))
ls_eitnbr  = TRIM(dw_ip.GetItemString(1,"to_itnbr"))
ls_depot   = TRIM(dw_ip.GetItemString(1,"depot"))

IF ls_sdate = "" OR IsNull(ls_sdate) THEN
	f_message_chk(30,'[기준 시작년월]')
	dw_ip.SetColumn("syymm")
	dw_ip.SetFocus()
	Return -1
END IF

IF ls_depot = "" OR IsNull(ls_depot) THEN
	f_message_chk(30,'[창고]')
	dw_ip.SetColumn("depot")
	dw_ip.SetFocus()
	Return -1
END IF

IF ls_edate = "" OR IsNull(ls_edate) THEN
	f_message_chk(30,'[기준 종료년월]')
	dw_ip.SetColumn("eyymm")
	dw_ip.SetFocus()
	Return -1
END IF

if ls_sdate > ls_edate then
	Messagebox("년월", "시작년월이 종료년월보다 큽니다", stopsign!)
	dw_ip.SetColumn("eyymm")
	dw_ip.SetFocus()
	Return -1
End if

IF ls_depot = "" OR IsNull(ls_depot) THEN 
   ls_depot = '%'
END IF

IF ls_ittyp  = "" OR IsNull(ls_ittyp)  THEN ls_ittyp  = '%'
IF ls_sitcls = "" OR IsNull(ls_sitcls) THEN ls_sitcls = '.'
IF ls_eitcls = "" OR IsNull(ls_eitcls) THEN ls_eitcls = 'ZZZZZZZZZZZZ'
IF ls_sitnbr = "" OR IsNull(ls_sitnbr) THEN ls_sitnbr = '.'
IF ls_eitnbr = "" OR IsNull(ls_eitnbr) THEN ls_eitnbr = 'ZZZZZZZZZZZZ'

//최종마감년월
SELECT MAX(JPDAT)  
  INTO :ls_mayymm
  FROM JUNPYO_CLOSING  
 WHERE SABU = '1' AND JPGU = 'C0'    ;

if isnull(ls_mayymm) then ls_mayymm = ' '

IF dw_print.Retrieve(gs_sabu, ls_sdate, ls_edate, ls_depot, ls_ittyp, ls_sitnbr, ls_eitnbr, ls_sitcls, ls_eitcls, idMeter) < 1 THEN
	f_message_chk(300,'')
	dw_list.Reset()
	dw_ip.setfocus()
	dw_ip.setcolumn('syymm')
	return -1
end if
dw_print.ShareData(dw_list)

dw_print.Object.t_100.text = ls_sdate
dw_print.Object.t_101.text = ls_edate
dw_print.Object.t_102.text = ls_Mayymm

return 1



end function

on w_adt_00920.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rr_2=create rr_2
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.rr_2
this.Control[iCurrent+5]=this.rr_3
end on

on w_adt_00920.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rr_2)
destroy(this.rr_3)
end on

event open;call super::open;dw_ip.SetItem(1, "syymm", left(f_today(), 6))
dw_ip.SetItem(1, "eyymm", left(f_today(), 6))
dw_ip.SetColumn("syymm")
dw_ip.Setfocus()
end event

event ue_open;call super::ue_open;//사업장
f_mod_saupj(dw_ip, 'saupj' )

//입고창고 
f_child_saupj(dw_ip, 'depot', gs_saupj)

//m환산기준
SELECT TO_NUMBER(DATANAME) INTO :idMeter FROM SYSCNFG WHERE SYSGU = 'Y' AND SERIAL = 2 AND LINENO = :gs_saupj;
If IsNull(idMeter) Then idMeter = 500000

//출력구분
is_gubun = '1'
end event

type p_preview from w_standard_print`p_preview within w_adt_00920
end type

type p_exit from w_standard_print`p_exit within w_adt_00920
end type

type p_print from w_standard_print`p_print within w_adt_00920
end type

type p_retrieve from w_standard_print`p_retrieve within w_adt_00920
end type











type dw_print from w_standard_print`dw_print within w_adt_00920
integer x = 4018
integer y = 256
string dataobject = "d_adt_00920_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_adt_00920
integer x = 608
integer y = 96
integer width = 3287
integer height = 268
string dataobject = "d_adt_00920"
end type

event dw_ip::itemerror;
Return 1
end event

event dw_ip::itemchanged;string snull, sdate, sitnbr, sitdsc, sispec, sSaupj
int    ireturn 

setnull(snull)

IF this.GetColumnName() = "syymm" THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF f_datechk(sdate + '01') = -1	then
      f_message_chk(35, '[기준년월]')
		this.setitem(1, "syymm", sNull)
		return 1
	END IF
ElseIf this.GetColumnName() = "saupj" Then
	sSaupj = trim(this.GetText())
	setnull(gs_code)
	f_mod_saupj(dw_ip, 'saupj')

	f_child_saupj(dw_ip, 'depot', sSaupj) 

ElseIF this.GetColumnName() = "eyymm" THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF f_datechk(sdate + '01') = -1	then
      f_message_chk(35, '[기준년월]')
		this.setitem(1, "eyymm", sNull)
		return 1
	END IF	
ELSEIF this.GetColumnName() = "fr_itnbr"	THEN
	sItnbr = trim(this.GetText())
	ireturn = f_get_name2('품번', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "fr_itnbr", sitnbr)	
	this.setitem(1, "fr_itdsc", sitdsc)	
	this.setitem(1, "fr_ispec", sispec)
	wf_move(sitnbr, sitdsc, sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = "fr_itdsc"	THEN
	sItdsc = trim(this.GetText())
	ireturn = f_get_name2('품명', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "fr_itnbr", sitnbr)	
	this.setitem(1, "fr_itdsc", sitdsc)	
	this.setitem(1, "fr_ispec", sispec)
	wf_move(sitnbr, sitdsc, sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = "fr_ispec"	THEN
	sIspec = trim(this.GetText())
	ireturn = f_get_name2('규격', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "fr_itnbr", sitnbr)	
	this.setitem(1, "fr_itdsc", sitdsc)	
	this.setitem(1, "fr_ispec", sispec)
	wf_move(sitnbr, sitdsc, sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = "to_itnbr"	THEN
	sItnbr = trim(this.GetText())
	ireturn = f_get_name2('품번', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "to_itnbr", sitnbr)	
	this.setitem(1, "to_itdsc", sitdsc)	
	this.setitem(1, "to_ispec", sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = "to_itdsc"	THEN
	sItdsc = trim(this.GetText())
	ireturn = f_get_name2('품명', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "to_itnbr", sitnbr)	
	this.setitem(1, "to_itdsc", sitdsc)	
	this.setitem(1, "to_ispec", sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = "to_ispec"	THEN
	sIspec = trim(this.GetText())
	ireturn = f_get_name2('규격', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "to_itnbr", sitnbr)	
	this.setitem(1, "to_itdsc", sitdsc)	
	this.setitem(1, "to_ispec", sispec)
	RETURN ireturn
END IF
end event

event dw_ip::rbuttondown;string sIttyp

setnull(gs_code)
setnull(gs_gubun)
setnull(gs_codename)

if this.GetColumnName() = 'itcls' then
	sIttyp = this.GetItemString(1, 'itgu')
	OpenWithParm(w_ittyp_popup, sIttyp)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"itgu",lstr_sitnct.s_ittyp)
   
	this.SetItem(1,"itcls", lstr_sitnct.s_sumgub)
	this.SetColumn('itcls')
	this.SetFocus()

elseif this.GetColumnName() = 'eitcls' then
	sIttyp = this.GetItemString(1, 'itgu')
	OpenWithParm(w_ittyp_popup, sIttyp)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"itgu",lstr_sitnct.s_ittyp)
   
	this.SetItem(1,"eitcls", lstr_sitnct.s_sumgub)
	this.SetColumn('eitcls')
	this.SetFocus()

elseif this.GetColumnName() = 'fr_itnbr' then
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"fr_itnbr",gs_code)
	this.TriggerEvent(ItemChanged!)
elseif this.GetColumnName() = 'to_itnbr' then
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"to_itnbr",gs_code)
	this.TriggerEvent(ItemChanged!)
end if	

end event

type dw_list from w_standard_print`dw_list within w_adt_00920
integer x = 64
integer y = 460
integer width = 4526
integer height = 1816
string dataobject = "d_adt_00920_1"
boolean border = false
end type

event dw_list::clicked;call super::clicked;If Row <= 0 then
	dw_list.SelectRow(0,False)
ELSE
	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
END IF
end event

type rr_1 from roundrectangle within w_adt_00920
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 603
integer y = 40
integer width = 3305
integer height = 384
integer cornerheight = 40
integer cornerwidth = 55
end type

type rb_1 from radiobutton within w_adt_00920
integer x = 82
integer y = 148
integer width = 494
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 134217737
string text = "등급별/품목분류"
boolean checked = true
end type

event clicked;is_gubun = '1'

dw_list.reset()
dw_print.reset()
dw_list.dataobject  = 'd_adt_00920_1'
dw_print.dataobject = 'd_adt_00920_1_p'

dw_list.settransobject(sqlca)
dw_print.settransobject(sqlca)
end event

type rb_2 from radiobutton within w_adt_00920
integer x = 82
integer y = 256
integer width = 325
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 134217737
string text = "제품별"
end type

event clicked;is_gubun = '2'

dw_list.reset()
dw_print.reset()
dw_list.dataobject  = 'd_adt_00920_2'
dw_print.dataobject = 'd_adt_00920_2_p'

dw_list.settransobject(sqlca)
dw_print.settransobject(sqlca)
end event

type rr_2 from roundrectangle within w_adt_00920
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 448
integer width = 4562
integer height = 1860
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_adt_00920
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 50
integer y = 36
integer width = 539
integer height = 384
integer cornerheight = 40
integer cornerwidth = 55
end type

