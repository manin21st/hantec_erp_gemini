$PBExportHeader$w_pdm_11660.srw
$PBExportComments$** 생산 인원 현황
forward
global type w_pdm_11660 from w_standard_print
end type
type rr_1 from roundrectangle within w_pdm_11660
end type
end forward

global type w_pdm_11660 from w_standard_print
string title = "생산 인원 현황"
rr_1 rr_1
end type
global w_pdm_11660 w_pdm_11660

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string jo1, jo2, ls_porgu, ls_rfna1, ls_rfna2

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

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
	dw_print.object.t_11.text = '전체'
ElseIf ls_porgu = ls_rfna2 Then
	dw_print.object.t_11.text = ls_rfna1
End If

jo1 = trim(dw_ip.object.jo1[1])
jo2 = trim(dw_ip.object.jo2[1])

IF trim(jo1) ="" OR IsNull(jo1) THEN
	f_message_chk(30,'[조코드]')
	dw_ip.SetColumn("jo1")
	dw_ip.SetFocus()
	Return -1
END IF

IF trim(jo2) = '' OR IsNull(jo2) THEN
	f_message_chk(30,'[조코드]')
	dw_ip.SetColumn("jo2")
	dw_ip.SetFocus()
	Return -1
END IF


//if (IsNull(jo1) or jo1 = "")  then jo1 = "1"
//if (IsNull(jo2) or jo2 = "")  then jo2 = "ZZZZZZ"

if dw_print.Retrieve(jo1, jo2, ls_porgu) < 1 then
	f_message_chk(50,'[생산 인원 현황]')
	dw_ip.Setfocus()
	return -1
end if

dw_print.sharedata(dw_list)

return 1
end function

on w_pdm_11660.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pdm_11660.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;f_mod_saupj(dw_ip, 'porgu')

end event

type p_preview from w_standard_print`p_preview within w_pdm_11660
integer x = 4073
end type

type p_exit from w_standard_print`p_exit within w_pdm_11660
integer x = 4421
end type

type p_print from w_standard_print`p_print within w_pdm_11660
integer x = 4247
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdm_11660
integer x = 3899
end type







type st_10 from w_standard_print`st_10 within w_pdm_11660
end type



type dw_print from w_standard_print`dw_print within w_pdm_11660
integer x = 3707
string dataobject = "d_pdm_11660_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdm_11660
integer x = 18
integer y = 44
integer width = 3008
integer height = 136
string dataobject = "d_pdm_11660_01"
end type

event dw_ip::itemchanged;string s_cod, s_nam1, s_nam2
integer i_rtn

s_cod = Trim(this.GetText())

if this.getcolumnname() = 'jo1' then   
	i_rtn = f_get_name2("조", "N", s_cod, s_nam1, s_nam2)
	this.setitem(1,"jo1",s_cod)
	this.setitem(1,"jonm1",s_nam1)
	return i_rtn
elseif this.getcolumnname() = 'jo2' then   
	i_rtn = f_get_name2("조", "N", s_cod, s_nam1, s_nam2)
	this.setitem(1,"jo2",s_cod)
	this.setitem(1,"jonm2",s_nam1)
	return i_rtn
end if

end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

IF	this.getcolumnname() = "jo1"	THEN		
	open(w_jomas_popup)
	this.SetItem(1, "jo1", gs_code)
	this.SetItem(1, "jonm1", gs_codename)
	return 
ELSEIF this.getcolumnname() = "jo2"	THEN		
	open(w_jomas_popup)
	this.SetItem(1, "jo2", gs_code)
	this.SetItem(1, "jonm2", gs_codename)
	return 
END IF
end event

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_pdm_11660
integer x = 46
integer y = 208
integer width = 4530
integer height = 2092
string dataobject = "d_pdm_11660_02"
boolean border = false
end type

type rr_1 from roundrectangle within w_pdm_11660
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 200
integer width = 4553
integer height = 2108
integer cornerheight = 40
integer cornerwidth = 55
end type

