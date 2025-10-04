$PBExportHeader$w_pdm_11700.srw
$PBExportComments$** 표준공정현황 - [공정설명]
forward
global type w_pdm_11700 from w_standard_print
end type
type rr_1 from roundrectangle within w_pdm_11700
end type
end forward

global type w_pdm_11700 from w_standard_print
integer height = 3772
string title = "표준공정현황 - [공정설명]"
rr_1 rr_1
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
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pdm_11700.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;//f_mod_saupj(dw_ip, 'porgu')

end event

type p_xls from w_standard_print`p_xls within w_pdm_11700
end type

type p_sort from w_standard_print`p_sort within w_pdm_11700
end type

type p_preview from w_standard_print`p_preview within w_pdm_11700
end type

type p_exit from w_standard_print`p_exit within w_pdm_11700
end type

type p_print from w_standard_print`p_print within w_pdm_11700
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdm_11700
end type







type st_10 from w_standard_print`st_10 within w_pdm_11700
end type



type dw_print from w_standard_print`dw_print within w_pdm_11700
string dataobject = "d_pdm_11700_01_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdm_11700
integer x = 27
integer y = 56
integer width = 2798
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

type dw_list from w_standard_print`dw_list within w_pdm_11700
integer y = 304
integer width = 4562
integer height = 2000
string dataobject = "d_pdm_11700_01"
boolean border = false
boolean hsplitscroll = false
end type

type rr_1 from roundrectangle within w_pdm_11700
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 292
integer width = 4585
integer height = 2032
integer cornerheight = 40
integer cornerwidth = 55
end type

