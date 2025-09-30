$PBExportHeader$w_sys_10001.srw
$PBExportComments$재물 조사표 출력
forward
global type w_sys_10001 from w_standard_print
end type
end forward

global type w_sys_10001 from w_standard_print
boolean TitleBar=true
string Title="년말재고조사표"
end type
global w_sys_10001 w_sys_10001

type variables
str_itnct lstr_sitnct

end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string s_depot, s_ittyp, s_yn, sgub, s_cvcod
string s_get_ittyp 
string sWhere,sModString
int    nRtn, s_cnt, v_cnt = 0
       
If dw_ip.accepttext() <> 1 Then Return -1

sgub    = dw_ip.getitemstring(1,"gub")
s_ittyp = dw_ip.getitemstring(1,"ittyp")
s_depot = dw_ip.getitemstring(1,"depot")
s_cvcod = dw_ip.getitemstring(1,"out_cvcod")
s_yn    = dw_ip.getitemstring(1,"yn")
s_cnt   = dw_ip.getitemnumber(1,"cnt")

////필수입력항목 체크///////////////////////////////////////////////
if sgub = '1' then 
	if (isnull(s_depot) or s_depot = "" )  then
		f_message_chk(30,'[기준창고]')
		dw_ip.setcolumn("depot")
		dw_ip.setfocus()
		return -1
 	end if
elseif sgub = '2' then 
	if (isnull(s_cvcod) or s_cvcod = "" )  then
		f_message_chk(30,'[외주처]')
		dw_ip.setcolumn("out_cvcod")
		dw_ip.setfocus()
		return -1
 	end if
else
	if (isnull(s_cnt) or s_cnt < 1 )  then
		f_message_chk(30,'[백지수량]')
		dw_ip.setcolumn("cnt")
		dw_ip.setfocus()
		return -1
 	end if
end if

if (isnull(s_ittyp) or s_ittyp = "" ) then s_ittyp = '%' 

////// <조회> ///////////////////////////////////////////////////////////////////////////////////////////
if	sgub = '1' then
	dw_list.DataObject = "d_sys_10001_03"
   dw_list.SetTransObject(SQLCA)
	
	if    s_yn = '1' then
		   dw_list.setfilter("stock_jego_qty <> 0")
	else
		   dw_list.setfilter("")
	end if
	dw_list.filter()
   
	IF    dw_list.retrieve(s_depot, s_ittyp) <= 0 THEN
         f_message_chk(50,'[년말재고조사표]')
	      dw_ip.setfocus()
			return -1
	end if
	
elseif	sgub = '2' then
	dw_list.DataObject = "d_sys_10001_02"
   dw_list.SetTransObject(SQLCA)

	if    s_yn = '1' then
		   dw_list.setfilter("jego_qty <> 0")
	else
		   dw_list.setfilter("")
	end if
	dw_list.filter()
   
	IF    dw_list.retrieve(s_cvcod, s_ittyp) <= 0 THEN
         f_message_chk(50,'[년말재고조사표]')
	      dw_ip.setfocus()
			return -1
	end if
	
else
	dw_list.reset()
	
	FOR v_cnt = 1 TO s_cnt
		 dw_list.insertrow(0)
   NEXT
END IF

return 1

end function

on w_sys_10001.create
call super::create
end on

on w_sys_10001.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;dw_ip.setfocus()

//old_select = '  SELECT "STOCK"."LOCFR",   ' + &
//             '  "STOCK"."LOCTO",      ' + &
//             '  "STOCK"."ITNBR",      ' + &
//             '  "ITEMAS"."ITDSC",      ' + &
//             '  "ITEMAS"."ISPEC",      ' + &
//             '  "STOCK"."PSPEC",      ' + &
//             '  "STOCK"."JEGO_QTY",      ' + & 
//             '  "STOCK"."HOLD_QTY",      ' + &
//             '  "STOCK"."VALID_QTY",      ' + &
//             '  "ITEMAS"."MIDSAF",      ' + &
//             '  "STOCK"."DEPOT_NO"     ' + &
//             '  FROM "STOCK",      ' + &
//             '  "ITEMAS",      ' + &
//             '  "VNDMST"    ' + &
//             '  WHERE ( "STOCK"."ITNBR" = "ITEMAS"."ITNBR"(+) ) and     ' + &
//             '  ( "STOCK"."DEPOT_NO" = "VNDMST"."CVCOD"(+) ) '
//
end event

type dw_ip from w_standard_print`dw_ip within w_sys_10001
int X=37
int Y=64
int Width=750
int Height=1348
string DataObject="d_sys_10001_01"
end type

event dw_ip::itemerror;RETURN 1
end event

event dw_ip::rbuttondown;String sittyp

SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

if this.GetColumnName() = 'itcls' Or this.GetColumnName() = 'itclsnm' then
	sIttyp = Trim(GetItemString(GetRow(),'ittyp'))
	If sIttyp = '' Or IsNull(sIttyp) Then sIttyp = '1'
	
	OpenWithParm(w_ittyp_popup, sIttyp)
	
   lstr_sitnct = Message.PowerObjectParm
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"ittyp",lstr_sitnct.s_ittyp)
   
	this.SetItem(1,"itcls", lstr_sitnct.s_sumgub)
	this.SetItem(1,"itclsnm", lstr_sitnct.s_titnm)
	this.SetColumn('itcls')
	this.SetFocus()
end if

If this.GetColumnName() = 'itnbr' then
	Gs_gubun = Trim(GetItemString(GetRow(),'ittyp'))
	If Gs_gubun = '' Or IsNull(Gs_gubun) Then Gs_gubun = '1'
	open(w_itemas_popup)
   
	if gs_code = "" or isnull(gs_code) then return 
		
	this.setitem(1, 'itnbr', gs_code)
   TriggerEvent(ItemChanged!)
End If

end event

type dw_list from w_standard_print`dw_list within w_sys_10001
int X=823
int Y=24
string DataObject="d_sys_10001_03"
end type

event dw_list::dberror;MessageBox(sqlerrtext,sqlsyntax)
end event

