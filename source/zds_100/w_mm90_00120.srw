$PBExportHeader$w_mm90_00120.srw
$PBExportComments$mro 입고 현황
forward
global type w_mm90_00120 from w_standard_print
end type
type rr_1 from roundrectangle within w_mm90_00120
end type
type rr_2 from roundrectangle within w_mm90_00120
end type
end forward

global type w_mm90_00120 from w_standard_print
string title = "소모품 입고 현황"
rr_1 rr_1
rr_2 rr_2
end type
global w_mm90_00120 w_mm90_00120

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String ls_sdate ,ls_edate ,ls_dept ,ls_vendor

IF dw_ip.AcceptText() = -1 THEN RETURN -1

ls_sdate  = Trim(dw_ip.Object.sdate[1])
ls_edate  = Trim(dw_ip.Object.edate[1])
ls_dept   = Trim(dw_ip.Object.deptcode[1])
ls_vendor  = Trim(dw_ip.Object.vendor[1])

If ls_sdate = '' Or isNull(ls_sdate) Or f_dateChk(ls_sdate) < 1 Then
	f_message_chk(35,'[입하일자]')
	dw_ip.SetFocus()
	dw_ip.SetColumn("sdate")
	Return -1
end If

If ls_edate = '' Or isNull(ls_edate) Or f_dateChk(ls_edate) < 1 Then
	f_message_chk(35,'[입하일자]')
	dw_ip.SetFocus()
	dw_ip.SetColumn("edate")
	Return -1
end If

If ls_sdate > ls_edate Then
   MessageBox('확인','날짜 범위지정에 벗어납니다.')
	dw_ip.Object.edate[1] = ''
	dw_ip.SetFocus()
	dw_ip.SetColumn("sdate")
	Return -1
end If

If ls_dept = '' Or isNull(ls_dept) Then 
	f_message_chk(1400,'[담당부서]')
	dw_ip.SetFocus()
	dw_ip.SetColumn("vendor")
	Return -1
End If


if dw_print.Retrieve(gs_sabu,ls_sdate ,ls_edate ,ls_vendor ) <= 0 then
	f_message_chk(50,'[MOR 입고 현황]')
	dw_ip.Setfocus()
	return -1
Else
	dw_print.Object.t_dept_nm.Text = Trim(dw_ip.Object.deptname[1])
	
end if

Return 1
end function

on w_mm90_00120.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.rr_2
end on

on w_mm90_00120.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_ip.Object.sdate[1] = f_afterday(is_today , -30)
dw_ip.Object.edate[1] = is_today


String	sdeptcode, sdeptname

Select deptcode, fun_get_dptno(deptcode)
  into :sdeptcode, :sdeptname
  from p1_master
 where empno = :gs_empno;

If SQLCA.SQLCODE <> 0 Then Return

dw_ip.Object.deptcode[1] = sdeptcode
dw_ip.Object.deptname[1] = sdeptname

string	sdepot
/* 소모품은 juprod = '5' - by shingoon 2008.01.08 */
/*
select cvcod into :sdepot from vndmst
 where cvgu = '5' and deptcode = :sdeptcode and juprod = 'Z' ;
*/
//select cvcod into :sdepot from vndmst
// where cvgu = '5' and deptcode = :sdeptcode and juprod = '5' ;
SELECT CVCOD
  INTO :sdepot
  FROM VNDMST
 WHERE CVGU = '5'
   AND JUMAECHUL = '9';

if sqlca.sqlcode = 0 then
	dw_ip.setitem(1,'vendor',sdepot)
end if

end event

type p_xls from w_standard_print`p_xls within w_mm90_00120
end type

type p_sort from w_standard_print`p_sort within w_mm90_00120
end type

type p_preview from w_standard_print`p_preview within w_mm90_00120
end type

type p_exit from w_standard_print`p_exit within w_mm90_00120
end type

type p_print from w_standard_print`p_print within w_mm90_00120
end type

type p_retrieve from w_standard_print`p_retrieve within w_mm90_00120
end type







type st_10 from w_standard_print`st_10 within w_mm90_00120
end type



type dw_print from w_standard_print`dw_print within w_mm90_00120
integer x = 2935
integer y = 64
integer height = 76
string dataobject = "d_mm90_00120_p"
end type

type dw_ip from w_standard_print`dw_ip within w_mm90_00120
integer x = 55
integer y = 32
integer width = 2446
integer height = 200
string dataobject = "d_mm90_00120_1"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::ue_key;call super::ue_key;//IF keydown(keyF2!) THEN
//   IF	this.getcolumnname() = "cod1"	THEN		
//	   gs_code = this.GetText()
//	   open(w_itemas_popup2)
//	   if isnull(gs_code) or gs_code = "" then 
//			this.SetItem(1, "cod1", "")
//	      this.SetItem(1, "nam1", "")
//	      return
//	   else
//			this.SetItem(1, "cod1", gs_code)
//	      this.SetItem(1, "nam1", gs_codename)
//	      this.triggerevent(itemchanged!)
//	      return 1
//		end if
//   ELSEIF this.getcolumnname() = "cod2" THEN		
//	   gs_code = this.GetText()
//	   open(w_itemas_popup2)
//	   if isnull(gs_code) or gs_code = "" then 	
//			this.SetItem(1, "cod2", "")
//	      this.SetItem(1, "nam2", "")
//	      return
//	   else
//			this.SetItem(1, "cod2", gs_code)
//	      this.SetItem(1, "nam2", gs_codename)
//	      this.triggerevent(itemchanged!)
//	      return 1	
//		end if	
//   END IF
//END IF  
end event

event dw_ip::itemchanged;string	sDate, sNull, sname , s_cod, s_nam1, s_nam2
integer  i_rtn

SetNull(sNull)

IF this.GetColumnName() = 'sdate' THEN
	sDate  = TRIM(this.gettext())
	
	IF sdate = '' or isnull(sdate) then return 
	IF f_datechk(sDate) = -1	then
		this.setitem(1, "sdate", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() = 'edate' THEN
	sDate  = TRIM(this.gettext())
	
	IF sdate = '' or isnull(sdate) then return 
	IF f_datechk(sDate) = -1	then
		this.setitem(1, "edate", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() = 'deptcode' THEN
	s_cod  = TRIM(this.gettext())
	
	If s_cod = '' Or isNull(s_cod) Then 
		This.Object.deptcode[1] = ''
		This.Object.deptname[1] = ''
		Return 1
	Else
		Select cvnas Into :s_nam1 
		  From VNDMST
		 where cvcod = :s_cod ;
			
		If SQLCA.SQLCODE <> 0 Then
			This.Object.deptcode[1] = ''
			This.Object.deptname[1] = ''
			Return 1
		Else
			This.Object.deptname[1] = s_nam1
		End If
			
		string	sdepot
			
		select cvcod into :sdepot from vndmst
		 where cvgu = '5' and deptcode = :s_cod and juprod = 'Z' ;
			
		if sqlca.sqlcode = 0 then
			This.setitem(1,'vendor',sdepot)
		Else
			This.Object.deptcode[1] = ''
			This.Object.deptname[1] = ''
			This.Object.vendor[1] = ''
			MessageBox('확인','해당 부서에는 MRO 창고가 존재 하지 않습니다.')
			Return 1
		end if	
		
	End If
end if




end event

event dw_ip::rbuttondown;call super::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

if this.GetColumnName() = "deptcode" then
	gs_gubun = '1' 
	open(w_vndmst_4_popup)
	IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	this.object.deptcode[1] = gs_code
	TriggerEvent("itemchanged")
END IF
	



end event

type dw_list from w_standard_print`dw_list within w_mm90_00120
integer x = 46
integer y = 272
integer width = 4562
integer height = 1980
string dataobject = "d_mm90_00120_a"
boolean border = false
end type

type rr_1 from roundrectangle within w_mm90_00120
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 28
integer width = 2519
integer height = 220
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_mm90_00120
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 264
integer width = 4581
integer height = 2004
integer cornerheight = 40
integer cornerwidth = 55
end type

