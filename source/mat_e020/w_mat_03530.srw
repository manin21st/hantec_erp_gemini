$PBExportHeader$w_mat_03530.srw
$PBExportComments$** 수불장
forward
global type w_mat_03530 from w_standard_print
end type
type rr_1 from roundrectangle within w_mat_03530
end type
type rr_2 from roundrectangle within w_mat_03530
end type
end forward

global type w_mat_03530 from w_standard_print
string title = "수불장"
rr_1 rr_1
rr_2 rr_2
end type
global w_mat_03530 w_mat_03530

type variables
str_itnct lstr_sitnct
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

public function integer wf_retrieve ();String  s_depot, s_date, sittyp, sitcls, eitcls, sitnbr, eitnbr, sMayymm, s_gub, sedate, ls_saupj
String  ls_oldsql, ls_newsql, ls_finalsql
Long ll_pos

IF dw_ip.AcceptText() = -1 THEN RETURN -1

s_gub   = dw_ip.GetItemString(1,"gub")
s_date  = TRIM(dw_ip.GetItemString(1,"syymm"))
sedate  = TRIM(dw_ip.GetItemString(1,"eyymm"))
sittyp  = TRIM(dw_ip.GetItemString(1,"itgu"))
sitcls  = TRIM(dw_ip.GetItemString(1,"itcls"))
eitcls  = TRIM(dw_ip.GetItemString(1,"eitcls"))
sitnbr  = TRIM(dw_ip.GetItemString(1,"fr_itnbr"))
eitnbr  = TRIM(dw_ip.GetItemString(1,"to_itnbr"))
ls_saupj  = TRIM(dw_ip.GetItemString(1,"saupj"))

s_depot = dw_ip.GetItemString(1,"depot")

IF s_date = "" OR IsNull(s_date) THEN
	f_message_chk(30,'[기준년월]')
	dw_ip.SetColumn("syymm")
	dw_ip.SetFocus()
	Return -1
END IF

IF sedate = "" OR IsNull(sedate) THEN
	f_message_chk(30,'[기준년월]')
	dw_ip.SetColumn("eyymm")
	dw_ip.SetFocus()
	Return -1
END IF

if s_date > sedate then
	Messagebox("년월", "시작년월이 종료년월보다 큽니다", stopsign!)
	dw_ip.SetColumn("eyymm")
	dw_ip.SetFocus()
	Return -1
End if

IF s_depot = "" OR IsNull(s_depot) THEN 
   s_depot = '%'
END IF

IF sittyp  = "" OR IsNull(sittyp)  THEN sittyp  = '%'
IF sitcls = "" OR IsNull(sitcls) THEN sitcls = '.'
IF eitcls = "" OR IsNull(eitcls) THEN eitcls = 'ZZZZZZZZZZZZ'
IF sitnbr = "" OR IsNull(sitnbr) THEN sitnbr = '.'
IF eitnbr = "" OR IsNull(eitnbr) THEN eitnbr = 'ZZZZZZZZZZZZ'
IF ls_saupj = "" OR IsNull(ls_saupj) THEN ls_saupj = '%'

//최종마감년월
SELECT MAX(JPDAT)  
  INTO :sMayymm
  FROM JUNPYO_CLOSING  
 WHERE SABU = '1' AND JPGU = 'C0'    ;

if isnull(sMayymm) then sMayymm = ' '

if s_gub = '1' then 
	dw_list.DataObject = "d_mat_03530_2"
   dw_print.DataObject = "d_mat_03530_2_p_lsh"
	dw_list.SetTransObject(SQLCA)
	dw_print.SetTransObject(SQLCA)
elseif s_gub = '2' then 
	dw_list.DataObject = "d_mat_03530_1"
   dw_print.DataObject = "d_mat_03530_1_p"
	dw_list.SetTransObject(SQLCA)
	dw_print.SetTransObject(SQLCA)
else
	dw_list.DataObject = "d_mat_03530_3"
   dw_print.DataObject = "d_mat_03530_3_p"
	dw_list.SetTransObject(SQLCA)
	dw_print.SetTransObject(SQLCA)
end if

IF dw_print.Retrieve(gs_sabu, s_date, sedate, s_depot, sitnbr, eitnbr, sittyp, sitcls, eitcls, ls_saupj) < 1 THEN
	dw_list.Reset()
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)


//if s_gub = '1' then 
//	dw_list.DataObject = "d_mat_03530_2"
//   dw_print.DataObject = "d_mat_03530_2_p"
//	dw_list.SetTransObject(SQLCA)
//	dw_print.SetTransObject(SQLCA)
//
//	//Argument 치환 Logic
//	ls_oldsql = dw_print.getsqlselect()
//
//	Do 
//		ll_pos  = Pos(ls_oldsql, "0000")
//		If ll_pos <> 0 Then
//			ls_newsql = Replace ( ls_oldsql, ll_pos, 4, gs_saupj )
//			ls_oldsql = ls_newsql
//		End If
//	Loop while ll_pos <> 0
//	
//	Do 
//		ll_pos  = Pos(ls_oldsql, "1111")
//		If ll_pos <> 0 Then
//			ls_newsql = Replace ( ls_oldsql, ll_pos, 4, gs_sabu )
//			ls_oldsql = ls_newsql
//		End If
//	Loop while ll_pos <> 0
//	
//	Do 
//		ll_pos  = Pos(ls_oldsql, "2222")
//		If ll_pos <> 0 Then
//			ls_newsql = Replace ( ls_oldsql, ll_pos, 4, s_date )
//			ls_oldsql = ls_newsql
//		End If
//	Loop while ll_pos <> 0
//	
//	Do 
//		ll_pos  = Pos(ls_oldsql, "3333")
//		If ll_pos <> 0 Then
//			ls_newsql = Replace ( ls_oldsql, ll_pos, 4, sedate )
//			ls_oldsql = ls_newsql
//		End If
//	Loop while ll_pos <> 0
//	
//	Do 
//		ll_pos  = Pos(ls_oldsql, "4444")
//		If ll_pos <> 0 Then
//			ls_newsql = Replace ( ls_oldsql, ll_pos, 4, s_depot )
//			ls_oldsql = ls_newsql
//		End If
//	Loop while ll_pos <> 0
//	
//	Do 
//		ll_pos  = Pos(ls_oldsql, "5555")
//		If ll_pos <> 0 Then
//			ls_newsql = Replace ( ls_oldsql, ll_pos, 4, sittyp )
//			ls_oldsql = ls_newsql
//		End If
//	Loop while ll_pos <> 0
//	
//	Do 
//		ll_pos  = Pos(ls_oldsql, "6666")
//		If ll_pos <> 0 Then
//			ls_newsql = Replace ( ls_oldsql, ll_pos, 4, sitcls )
//			ls_oldsql = ls_newsql
//		End If
//	Loop while ll_pos <> 0
//	
//	Do 
//		ll_pos  = Pos(ls_oldsql, "7777")
//		If ll_pos <> 0 Then
//			ls_newsql = Replace ( ls_oldsql, ll_pos, 4, eitcls )
//			ls_oldsql = ls_newsql
//		End If
//	Loop while ll_pos <> 0
//	
//	Do
//		ll_pos  = Pos(ls_oldsql, "8888")
//		If ll_pos <> 0 Then
//			ls_newsql = Replace ( ls_oldsql, ll_pos, 4, sitnbr )
//			ls_oldsql = ls_newsql
//		End If
//	Loop while ll_pos <> 0
//	
//	Do
//		ll_pos  = Pos(ls_oldsql, "9999")
//		If ll_pos <> 0 Then
//			ls_newsql = Replace ( ls_oldsql, ll_pos, 4, eitnbr )
//			ls_oldsql = ls_newsql
//		End If
//	Loop while ll_pos <> 0
//	
//	Do
//		ll_pos  = Pos(ls_oldsql, "0000")
//		If ll_pos <> 0 Then
//			ls_newsql = Replace ( ls_oldsql, ll_pos, 4, sMayymm )
//			ls_oldsql = ls_newsql
//		End If
//	Loop while ll_pos <> 0
//	
////	Do
////		ll_pos  = Pos(ls_oldsql, "1010")
////		If ll_pos <> 0 Then
////			ls_newsql = Replace ( ls_oldsql, ll_pos, 4, ls_saupj )
////			ls_oldsql = ls_newsql
////		End If
////	Loop while ll_pos <> 0
//   
//	mle_1.TEXT = ls_newsql
//	dw_print.setSqlSelect(ls_newsql)
//	dw_list.setSqlSelect(ls_newsql)
//
//	IF dw_print.Retrieve() < 1 THEN
//		dw_list.Reset()
//		dw_print.insertrow(0)
//	//	Return -1
//	END IF
//
//	dw_print.ShareData(dw_list)
//
//elseif s_gub = '2' then
//   dw_list.DataObject = "d_mat_03530_1"
//	dw_print.DataObject = "d_mat_03530_1_p"
//	dw_list.SetTransObject(SQLCA)
//	dw_print.SetTransObject(SQLCA)
//
//	ls_oldsql = dw_print.getsqlselect()
//
//	Do 
//		ll_pos  = Pos(ls_oldsql, "0000")
//		If ll_pos <> 0 Then
//			ls_newsql = Replace ( ls_oldsql, ll_pos, 4, gs_saupj )
//			ls_oldsql = ls_newsql
//		End If
//	Loop while ll_pos <> 0
//	
//	Do 
//		ll_pos  = Pos(ls_oldsql, "1111")
//		If ll_pos <> 0 Then
//			ls_newsql = Replace ( ls_oldsql, ll_pos, 4, gs_sabu )
//			ls_oldsql = ls_newsql
//		End If
//	Loop while ll_pos <> 0
//	
//	Do 
//		ll_pos  = Pos(ls_oldsql, "2222")
//		If ll_pos <> 0 Then
//			ls_newsql = Replace ( ls_oldsql, ll_pos, 4, s_date )
//			ls_oldsql = ls_newsql
//		End If
//	Loop while ll_pos <> 0
//	
//	Do 
//		ll_pos  = Pos(ls_oldsql, "3333")
//		If ll_pos <> 0 Then
//			ls_newsql = Replace ( ls_oldsql, ll_pos, 4, sedate )
//			ls_oldsql = ls_newsql
//		End If
//	Loop while ll_pos <> 0
//	
//	Do 
//		ll_pos  = Pos(ls_oldsql, "4444")
//		If ll_pos <> 0 Then
//			ls_newsql = Replace ( ls_oldsql, ll_pos, 4, s_depot )
//			ls_oldsql = ls_newsql
//		End If
//	Loop while ll_pos <> 0
//	
//	Do 
//		ll_pos  = Pos(ls_oldsql, "5555")
//		If ll_pos <> 0 Then
//			ls_newsql = Replace ( ls_oldsql, ll_pos, 4, sittyp )
//			ls_oldsql = ls_newsql
//		End If
//	Loop while ll_pos <> 0
//	
//	Do 
//		ll_pos  = Pos(ls_oldsql, "6666")
//		If ll_pos <> 0 Then
//			ls_newsql = Replace ( ls_oldsql, ll_pos, 4, sitcls )
//			ls_oldsql = ls_newsql
//		End If
//	Loop while ll_pos <> 0
//	
//	Do 
//		ll_pos  = Pos(ls_oldsql, "7777")
//		If ll_pos <> 0 Then
//			ls_newsql = Replace ( ls_oldsql, ll_pos, 4, eitcls )
//			ls_oldsql = ls_newsql
//		End If
//	Loop while ll_pos <> 0
//	
//	Do
//		ll_pos  = Pos(ls_oldsql, "8888")
//		If ll_pos <> 0 Then
//			ls_newsql = Replace ( ls_oldsql, ll_pos, 9, sitnbr )
//			ls_oldsql = ls_newsql
//		End If
//	Loop while ll_pos <> 0
//	
//	Do
//		ll_pos  = Pos(ls_oldsql, "9999")
//		If ll_pos <> 0 Then
//			ls_newsql = Replace ( ls_oldsql, ll_pos, 9, eitnbr )
//			ls_oldsql = ls_newsql
//		End If
//	Loop while ll_pos <> 0
//	
//	Do
//		ll_pos  = Pos(ls_oldsql, "0000")
//		If ll_pos <> 0 Then
//			ls_newsql = Replace ( ls_oldsql, ll_pos, 4, sMayymm )
//			ls_oldsql = ls_newsql
//		End If
//	Loop while ll_pos <> 0
//	
////	Do
////		ll_pos  = Pos(ls_oldsql, "1010")
////		If ll_pos <> 0 Then
////			ls_newsql = Replace ( ls_oldsql, ll_pos, 4, ls_saupj )
////			ls_oldsql = ls_newsql
////		End If
////	Loop while ll_pos <> 0
//
//	dw_print.setSqlSelect(ls_newsql)
//	dw_list.setSqlSelect(ls_newsql)
//
////	IF dw_print.Retrieve(gs_sabu, s_date, sedate, s_depot, sittyp, sitcls, eitcls, sitnbr, eitnbr, sMayymm,ls_saupj) < 1 THEN
//	IF dw_print.Retrieve() < 1 THEN
//		dw_list.Reset()
//		dw_print.insertrow(0)
//	//	Return -1
//	END IF
//
//	dw_print.ShareData(dw_list)
//
//else
//   dw_list.DataObject = "d_mat_03530_3"
//	dw_print.DataObject = "d_mat_03530_3_p"
//	dw_list.SetTransObject(SQLCA)
//	dw_print.SetTransObject(SQLCA)
//
//	//Argument 치환 Logic
//	ls_oldsql = dw_print.getsqlselect()
//
//	Do 
//		ll_pos  = Pos(ls_oldsql, "0000")
//		If ll_pos <> 0 Then
//			ls_newsql = Replace ( ls_oldsql, ll_pos, 4, gs_saupj )
//			ls_oldsql = ls_newsql
//		End If
//	Loop while ll_pos <> 0
//	
//	Do 
//		ll_pos  = Pos(ls_oldsql, "1111")
//		If ll_pos <> 0 Then
//			ls_newsql = Replace ( ls_oldsql, ll_pos, 4, gs_sabu )
//			ls_oldsql = ls_newsql
//		End If
//	Loop while ll_pos <> 0
//	
//	Do 
//		ll_pos  = Pos(ls_oldsql, "2222")
//		If ll_pos <> 0 Then
//			ls_newsql = Replace ( ls_oldsql, ll_pos, 4, s_date )
//			ls_oldsql = ls_newsql
//		End If
//	Loop while ll_pos <> 0
//	
//	Do 
//		ll_pos  = Pos(ls_oldsql, "3333")
//		If ll_pos <> 0 Then
//			ls_newsql = Replace ( ls_oldsql, ll_pos, 4, sedate )
//			ls_oldsql = ls_newsql
//		End If
//	Loop while ll_pos <> 0
//	
//	Do 
//		ll_pos  = Pos(ls_oldsql, "4444")
//		If ll_pos <> 0 Then
//			ls_newsql = Replace ( ls_oldsql, ll_pos, 4, s_depot )
//			ls_oldsql = ls_newsql
//		End If
//	Loop while ll_pos <> 0
//	
//	Do 
//		ll_pos  = Pos(ls_oldsql, "5555")
//		If ll_pos <> 0 Then
//			ls_newsql = Replace ( ls_oldsql, ll_pos, 4, sittyp )
//			ls_oldsql = ls_newsql
//		End If
//	Loop while ll_pos <> 0
//	
//	Do 
//		ll_pos  = Pos(ls_oldsql, "6666")
//		If ll_pos <> 0 Then
//			ls_newsql = Replace ( ls_oldsql, ll_pos, 4, sitcls )
//			ls_oldsql = ls_newsql
//		End If
//	Loop while ll_pos <> 0
//	
//	Do 
//		ll_pos  = Pos(ls_oldsql, "7777")
//		If ll_pos <> 0 Then
//			ls_newsql = Replace ( ls_oldsql, ll_pos, 4, eitcls )
//			ls_oldsql = ls_newsql
//		End If
//	Loop while ll_pos <> 0
//	
//	Do
//		ll_pos  = Pos(ls_oldsql, "8888")
//		If ll_pos <> 0 Then
//			ls_newsql = Replace ( ls_oldsql, ll_pos, 4, sitnbr )
//			ls_oldsql = ls_newsql
//		End If
//	Loop while ll_pos <> 0
//	
//	Do
//		ll_pos  = Pos(ls_oldsql, "9999")
//		If ll_pos <> 0 Then
//			ls_newsql = Replace ( ls_oldsql, ll_pos, 4, eitnbr )
//			ls_oldsql = ls_newsql
//		End If
//	Loop while ll_pos <> 0
//	
//	Do
//		ll_pos  = Pos(ls_oldsql, "0000")
//		If ll_pos <> 0 Then
//			ls_newsql = Replace ( ls_oldsql, ll_pos, 4, sMayymm )
//			ls_oldsql = ls_newsql
//		End If
//	Loop while ll_pos <> 0
//	
////	Do
////		ll_pos  = Pos(ls_oldsql, "1010")
////		If ll_pos <> 0 Then
////			ls_newsql = Replace ( ls_oldsql, ll_pos, 4, ls_saupj )
////			ls_oldsql = ls_newsql
////		End If
////	Loop while ll_pos <> 0
//
//	dw_print.setSqlSelect(ls_newsql)
//	dw_list.setSqlSelect(ls_newsql)
//
//	IF dw_print.Retrieve() < 1 THEN
//		dw_list.Reset()
//		dw_print.insertrow(0)
//	//	Return -1
//	END IF
//
////	IF dw_print.Retrieve(gs_sabu, s_date, sedate, sittyp, sitcls, eitcls, sitnbr, eitnbr, sMayymm,ls_saupj) < 1 THEN
//	IF dw_print.Retrieve() < 1 THEN
//		dw_list.Reset()
//		dw_print.insertrow(0)
//	//	Return -1
//	END IF
//
//	dw_print.ShareData(dw_list)
//
//end if

dw_print.Object.t_100.text = s_date
dw_print.Object.t_101.text = sedate
dw_print.Object.t_102.text = sMayymm

return 1



end function

on w_mat_03530.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.rr_2
end on

on w_mat_03530.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_ip.SetItem(1, "syymm", left(f_today(), 6))
dw_ip.SetItem(1, "eyymm", left(f_today(), 6))
dw_ip.SetColumn("syymm")
dw_ip.Setfocus()
end event

event ue_open;call super::ue_open;////사업장
//f_mod_saupj(dw_ip, 'saupj' )

dw_ip.SetItem(1, 'saupj', gs_saupj)

//입고창고 
f_child_saupj(dw_ip, 'depot', gs_saupj)
end event

type p_xls from w_standard_print`p_xls within w_mat_03530
end type

type p_sort from w_standard_print`p_sort within w_mat_03530
end type

type p_preview from w_standard_print`p_preview within w_mat_03530
integer taborder = 50
end type

type p_exit from w_standard_print`p_exit within w_mat_03530
integer taborder = 70
end type

type p_print from w_standard_print`p_print within w_mat_03530
integer taborder = 60
end type

type p_retrieve from w_standard_print`p_retrieve within w_mat_03530
end type











type dw_print from w_standard_print`dw_print within w_mat_03530
integer x = 3726
string dataobject = "d_mat_03530_2_p_lsh"
end type

type dw_ip from w_standard_print`dw_ip within w_mat_03530
integer x = 59
integer y = 52
integer width = 3520
integer height = 360
string dataobject = "d_mat_03530_a"
end type

event dw_ip::itemerror;
Return 1
end event

event dw_ip::itemchanged;string snull, sdate, sitnbr, sitdsc, sispec, ssaupj
int    ireturn 

setnull(snull)

IF this.GetColumnName() ="syymm" THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF f_datechk(sdate + '01') = -1	then
      f_message_chk(35, '[기준년월]')
		this.setitem(1, "syymm", sNull)
		return 1
	END IF
ElseIF this.GetColumnName() ="eyymm" THEN
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
ElseIf This.GetColumnName() = 'saupj' Then
	sSaupj = Trim(This.GetText())
	//입고창고 
	f_child_saupj(dw_ip, 'depot', sSaupj)
	
	This.SetItem(1, 'depot', snull)
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

type dw_list from w_standard_print`dw_list within w_mat_03530
integer x = 64
integer y = 460
integer width = 4526
integer height = 1816
integer taborder = 40
string dataobject = "d_mat_03530_2"
boolean border = false
end type

event dw_list::clicked;call super::clicked;If Row <= 0 then
	dw_list.SelectRow(0,False)
ELSE
	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
END IF
end event

type rr_1 from roundrectangle within w_mat_03530
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 41
integer y = 40
integer width = 3598
integer height = 384
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_mat_03530
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

