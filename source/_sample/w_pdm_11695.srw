$PBExportHeader$w_pdm_11695.srw
$PBExportComments$공정별 사용품목현황
forward
global type w_pdm_11695 from w_standard_print
end type
type rr_1 from roundrectangle within w_pdm_11695
end type
end forward

global type w_pdm_11695 from w_standard_print
string title = "공정별 사용품목 현황"
rr_1 rr_1
end type
global w_pdm_11695 w_pdm_11695

type variables
str_itnct lstr_sitnct
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String ssroslt, seroslt, sspdtgu, sepdtgu, sittyp, ssitcls, seitcls
String ls_porgu, ls_rfna1, ls_rfna2

dw_ip.accepttext()
ssroslt = dw_ip.getitemstring(1, "sroslt")
seroslt = dw_ip.getitemstring(1, "eroslt")
sspdtgu = dw_ip.getitemstring(1, "spdtgu")
sepdtgu = dw_ip.getitemstring(1, "epdtgu")
sittyp  = dw_ip.getitemstring(1, "ittyp")
ssitcls = dw_ip.getitemstring(1, "sitcls")
seitcls = dw_ip.getitemstring(1, "eitcls")

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

if isnull(ssroslt) or trim(ssroslt) = '' then ssroslt = '.'
if isnull(seroslt) or trim(seroslt) = '' then seroslt = 'ZZZZZZ'
if isnull(sspdtgu) or trim(sspdtgu) = '' then sspdtgu = '.'
if isnull(sepdtgu) or trim(sepdtgu) = '' then sepdtgu = 'ZZZZZZ'
if isnull(ssitcls) or trim(ssitcls) = '' then ssitcls = '.'
if isnull(seitcls) or trim(seitcls) = '' then seitcls = 'ZZZZZZ'  

IF dw_print.Retrieve(ssroslt, seroslt, sspdtgu, sepdtgu, sittyp, ssitcls, seitcls, ls_porgu) <=0 THEN
	IF f_message_chk(50,'') = -1 THEN RETURN -1
	dw_ip.SetFocus()
	Return -1
END IF

dw_print.sharedata(dw_list)

Return 1

end function

on w_pdm_11695.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pdm_11695.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;String sittyp

Select MIN(RFGUB) into :sittyp
  from reffpf where rfcod = '05' AND RFGUB <> '00';
  
dw_ip.setitem(1, "ittyp", sittyp)
 
f_mod_saupj(dw_ip, 'porgu')

f_child_saupj(dw_ip, 'spdtgu', gs_saupj)
f_child_saupj(dw_ip, 'epdtgu', gs_saupj)


end event

type p_preview from w_standard_print`p_preview within w_pdm_11695
end type

type p_exit from w_standard_print`p_exit within w_pdm_11695
end type

type p_print from w_standard_print`p_print within w_pdm_11695
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdm_11695
end type











type dw_print from w_standard_print`dw_print within w_pdm_11695
string dataobject = "d_pdm_11695_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdm_11695
integer x = 73
integer y = 52
integer width = 3762
integer height = 244
string dataobject = "d_pdm_11695_a"
end type

event dw_ip::rbuttondown;String sIttyp
long nRow

setnull(gs_code)
setnull(gs_gubun)
setnull(gs_codename)

this.accepttext()
nRow = GetRow()

if this.GetColumnName() = 'sitcls' then
	sIttyp = this.getitemstring(1, "ittyp")
	OpenWithParm(w_ittyp_popup, sIttyp)
	
   lstr_sitnct = Message.PowerObjectParm
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"sitcls", lstr_sitnct.s_sumgub)
	this.SetColumn('sitcls')
	this.SetFocus()
end if

if this.GetColumnName() = 'eitcls' then
	sIttyp = this.getitemstring(1, "ittyp")
	OpenWithParm(w_ittyp_popup, sIttyp)
	
   lstr_sitnct = Message.PowerObjectParm
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"eitcls", lstr_sitnct.s_sumgub)
	this.SetColumn('eitcls')
	this.SetFocus()
end if



end event

type dw_list from w_standard_print`dw_list within w_pdm_11695
integer x = 82
integer y = 304
integer width = 4480
integer height = 1992
string dataobject = "d_pdm_11695"
boolean border = false
end type

type rr_1 from roundrectangle within w_pdm_11695
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 73
integer y = 296
integer width = 4507
integer height = 2012
integer cornerheight = 40
integer cornerwidth = 55
end type

