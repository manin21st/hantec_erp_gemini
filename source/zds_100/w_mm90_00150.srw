$PBExportHeader$w_mm90_00150.srw
$PBExportComments$SparePart 현재고 현황
forward
global type w_mm90_00150 from w_standard_print
end type
type rr_1 from roundrectangle within w_mm90_00150
end type
type rr_2 from roundrectangle within w_mm90_00150
end type
end forward

global type w_mm90_00150 from w_standard_print
string title = "SPAREPART 현재고 현황"
rr_1 rr_1
rr_2 rr_2
end type
global w_mm90_00150 w_mm90_00150

type variables
str_itnct str_sitnct
end variables

forward prototypes
public subroutine wf_move (string sitnbr, string sitdsc, string sispec)
public function integer wf_retrieve ()
end prototypes

public subroutine wf_move (string sitnbr, string sitdsc, string sispec);if sitnbr = '' or isnull(sitnbr) then return 

dw_ip.setitem(1, "to_itnbr", sitnbr)	
dw_ip.setitem(1, "to_itdsc", sitdsc)	


end subroutine

public function integer wf_retrieve ();String  s_depot, s_ittyp, s_itcls

IF dw_ip.AcceptText() = -1 THEN RETURN -1

s_depot 	 = TRIM(dw_ip.GetItemString(1,"vendor"))
s_ittyp 	 = TRIM(dw_ip.GetItemString(1,"ittyp"))
s_itcls 	 = TRIM(dw_ip.GetItemString(1,"itcls"))

if s_depot = '' or isnull(s_depot) then
	f_message_chk(1400 , '[창고]')
	dw_ip.SetFocus()
	dw_ip.SetColumn("vendor")
End If

s_ittyp = '6'
if s_itcls = '' or isnull(s_itcls) then s_itcls = '%'

IF dw_list.Retrieve(gs_sabu , s_depot, s_Ittyp,s_itcls) <= 0 then
	dw_list.Reset()
	dw_print.insertrow(0)
	Return -1
END IF


return 1

end function

on w_mm90_00150.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.rr_2
end on

on w_mm90_00150.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;String	sdeptcode, sdeptname

Select deptcode, fun_get_dptno(deptcode)
  into :sdeptcode, :sdeptname
  from p1_master
 where empno = :gs_empno ;

If SQLCA.SQLCODE <> 0 Then Return

dw_ip.Object.deptcode[1] = sdeptcode
dw_ip.Object.deptname[1] = sdeptname

string	sdepot
/* 소모품은 juprod = '5' - by shingoon 2008.01.08 */
/*
select cvcod into :sdepot from vndmst
 where cvgu = '5' and deptcode = :sdeptcode and juprod = 'Z' ;
*/
select cvcod into :sdepot from vndmst
 where cvgu = '5' and deptcode = :sdeptcode and juprod = '5' ;

if sqlca.sqlcode = 0 then
	dw_ip.setitem(1,'vendor',sdepot)
end if	
end event

type p_xls from w_standard_print`p_xls within w_mm90_00150
end type

type p_sort from w_standard_print`p_sort within w_mm90_00150
end type

type p_preview from w_standard_print`p_preview within w_mm90_00150
end type

type p_exit from w_standard_print`p_exit within w_mm90_00150
end type

type p_print from w_standard_print`p_print within w_mm90_00150
end type

type p_retrieve from w_standard_print`p_retrieve within w_mm90_00150
end type











type dw_print from w_standard_print`dw_print within w_mm90_00150
string dataobject = "d_mm90_00150_p"
end type

type dw_ip from w_standard_print`dw_ip within w_mm90_00150
integer x = 50
integer y = 48
integer width = 2958
integer height = 128
string dataobject = "d_mm90_00150_1"
end type

event dw_ip::itemerror;
Return 1
end event

event dw_ip::rbuttondown;string sIttyp
str_itnct lstr_sitnct

setnull(gs_gubun)
setnull(gs_code)
setnull(gs_codename)

if this.GetColumnName() = "deptcode" then
	gs_gubun = '1' 
	open(w_vndmst_4_popup)

	IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	this.object.deptcode[1] = gs_code
	TriggerEvent("itemchanged")
Elseif this.GetColumnName() = "itcls" then
		OpenWithParm(w_ittyp_popup, '6')
		
		str_sitnct = Message.PowerObjectParm	
		
		IF str_sitnct.s_ittyp ="" OR IsNull(str_sitnct.s_ittyp) THEN RETURN
		
		SetItem(1,"itcls",str_sitnct.s_sumgub)
		SetItem(1,"itclsnm", str_sitnct.s_titnm)
END IF
end event

event dw_ip::itemchanged;string	sDate, sNull, sname , s_cod, s_nam1, s_nam2,sItemCls,sItemClsName
integer  i_rtn

SetNull(sNull)
AcceptText()
IF this.GetColumnName() = 'deptcode' THEN
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
Elseif this.GetColumnName() = 'itcls' THEN
		SetItem(1,'itclsnm',sNull)
		sItemCls = Trim(GetText())
		IF sItemCls = "" OR IsNull(sItemCls) THEN RETURN
		
		SELECT "ITNCT"."TITNM" 
		  INTO :sItemClsName  
		  FROM "ITNCT"  
		 WHERE ( "ITNCT"."ITTYP" = '6' ) AND ( "ITNCT"."ITCLS" = :sItemCls )   ;
		
		IF SQLCA.SQLCODE <> 0 THEN
			TriggerEvent(RButtonDown!)
			Return 2
		ELSE
			SetItem(1,"itclsnm",sItemClsName)
		END IF	
end if



end event

type dw_list from w_standard_print`dw_list within w_mm90_00150
integer x = 55
integer y = 220
integer width = 4535
integer height = 2028
string dataobject = "d_mm90_00150_a"
boolean border = false
end type

type rr_1 from roundrectangle within w_mm90_00150
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 212
integer width = 4576
integer height = 2052
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_mm90_00150
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 36
integer width = 3077
integer height = 160
integer cornerheight = 40
integer cornerwidth = 55
end type

