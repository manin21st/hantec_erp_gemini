$PBExportHeader$w_pdm_11700.srw
$PBExportComments$** 표준공정현황 - [공정설명]
forward
global type w_pdm_11700 from w_standard_print
end type
end forward

global type w_pdm_11700 from w_standard_print
integer height = 2500
string title = "표준공정현황 - [공정설명]"
end type
global w_pdm_11700 w_pdm_11700

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string cod1, cod2, ls_porgu, ls_rfna1, ls_rfna2

if dw_ip.AcceptText() = -1 then return -1

//조회 조건에서 사업장 추가 시작
ls_porgu = dw_ip.getItemString(1, "porgu")

SELECT "REFFPF"."RFNA1"  ,
       "REFFPF"."RFGUB"
Into :ls_rfna1, :ls_rfna2
FROM "REFFPF"  
WHERE ( "REFFPF"."SABU" = '1' ) AND  
      ( "REFFPF"."RFCOD" = 'AD' ) AND  
     ( "REFFPF"."RFGUB" NOT IN ('00','99') )
AND "REFFPF"."RFGUB" = :ls_porgu;

if ls_porgu ='%' Then
	dw_print.object.t_100.text = '전체'
ElseIf ls_porgu = ls_rfna2 Then
	dw_print.object.t_100.text = ls_rfna1
End If
//조회 조건에서 사업장 추가 끝

cod1 = trim(dw_ip.object.cod1[1])
cod2 = trim(dw_ip.object.cod2[1])

if (IsNull(cod1) or cod1 = "")  then cod1 = "."
if (IsNull(cod2) or cod2 = "")  then cod2 = "ZZZZZZ"

if dw_print.Retrieve(cod1, cod2, ls_porgu) <= 0 then
	f_message_chk(50,'[표준공정현황-공정설명]')
	dw_ip.Setfocus()
	return -1
end if

dw_print.sharedata(dw_list)

return 1
end function

on w_pdm_11700.create
call super::create
end on

on w_pdm_11700.destroy
call super::destroy
end on

event open;call super::open;//f_mod_saupj(dw_ip, 'porgu')

end event

type dw_list from w_standard_print`dw_list within w_pdm_11700
integer y = 328
integer width = 3489
integer height = 1964
string dataobject = "d_pdm_11700_01"
boolean hsplitscroll = false
end type

type cb_print from w_standard_print`cb_print within w_pdm_11700
end type

type cb_excel from w_standard_print`cb_excel within w_pdm_11700
end type

type cb_preview from w_standard_print`cb_preview within w_pdm_11700
end type

type cb_1 from w_standard_print`cb_1 within w_pdm_11700
end type

type dw_print from w_standard_print`dw_print within w_pdm_11700
string dataobject = "d_pdm_11700_01_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdm_11700
integer y = 56
integer width = 3489
integer height = 228
string dataobject = "d_pdm_11700_02"
end type

event dw_ip::itemchanged;string s_cod, s_nam1, s_nam2
integer i_rtn

s_cod = Trim(this.GetText())

if this.getcolumnname() = 'cod1' then   
	i_rtn = f_get_name2("품번", "N", s_cod, s_nam1, s_nam2)
	this.setitem(1,"cod1",s_cod)
	this.setitem(1,"nam1",s_nam1)		
	return i_rtn
elseif this.getcolumnname() = 'cod2' then   
	i_rtn = f_get_name2("품번", "N", s_cod, s_nam1, s_nam2)
	this.setitem(1,"cod2",s_cod)
	this.setitem(1,"nam2",s_nam1)		
	return i_rtn
end if
end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_Gubun)
IF	this.getcolumnname() = "cod1"	THEN		
	open(w_itemas_popup)
	this.SetItem(1, "cod1", gs_code)
	this.SetItem(1, "nam1", gs_codename)
	return 
ELSEIF this.getcolumnname() = "cod2" THEN		
	open(w_itemas_popup)
	this.SetItem(1, "cod2", gs_code)
	this.SetItem(1, "nam2", gs_codename)
	return 
END IF
end event

event dw_ip::itemerror;return 1
end event

event dw_ip::ue_key;call super::ue_key;SetNull(gs_code)
SetNull(gs_codename)

IF keydown(keyF2!) THEN
   IF	this.getcolumnname() = "cod1"	THEN		
	   open(w_itemas_popup2)
	   this.SetItem(1, "cod1", gs_code)
	   this.SetItem(1, "nam1", gs_codename)
	   return 
   ELSEIF this.getcolumnname() = "cod2" THEN		
	   open(w_itemas_popup2)
	   this.SetItem(1, "cod2", gs_code)
	   this.SetItem(1, "nam2", gs_codename)
   END IF
END IF  
end event

type r_1 from w_standard_print`r_1 within w_pdm_11700
integer y = 324
end type

type r_2 from w_standard_print`r_2 within w_pdm_11700
integer height = 236
end type

