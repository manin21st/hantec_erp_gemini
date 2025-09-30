$PBExportHeader$w_pdt_06545.srw
$PBExportComments$**정기점검 계획서(년간)
forward
global type w_pdt_06545 from w_standard_print
end type
type rr_1 from roundrectangle within w_pdt_06545
end type
end forward

global type w_pdt_06545 from w_standard_print
string title = "설비 정기 점검 계획서(년간)"
rr_1 rr_1
end type
global w_pdt_06545 w_pdt_06545

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String yyyy  , s_mchno , e_mchno ,ls_gubun
Long   i, j

if dw_ip.accepttext() = -1 then return -1

yyyy    = Trim(dw_ip.object.yyyy[1])
s_mchno = trim(dw_ip.object.s_mchno[1] )
e_mchno = trim(dw_ip.object.e_mchno[1] )
ls_gubun = dw_ip.getitemstring(1,'gubun')

if IsNull(yyyy) or yyyy = "" then
	f_message_chk(30,"[기준년도]")
	dw_ip.SetColumn('yyyy')
	dw_ip.Setfocus()
	return -1
end if

if Isnull(s_mchno) or s_mchno = "" then
	s_mchno = '.'
end if	

if isnull(e_mchno) or e_mchno = "" then
	e_mchno = 'zzzzzz'
end if

//dw_list.object.txt_title.text = String(yyyy,"@@@@년 설비 정기 점검 계획서")
dw_print.object.txt_title.text = String(yyyy,"@@@@년 설비 정기 점검 계획서")

//if dw_print.Retrieve(gs_sabu,  yyyy , s_mchno, e_mchno,ls_gubun ) <= 0 then
if dw_print.Retrieve(yyyy  ) <= 0 then
	dw_list.setredraw(true)
	f_message_chk(50,"[정기 점검 계획서(년간)]")
	//return -1
	dw_list.insertrow(0)
end if	

dw_print.shareData(dw_print)

return 1

end function

on w_pdt_06545.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pdt_06545.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.setitem(1, 'yyyy', left(is_today, 4))
end event

type p_preview from w_standard_print`p_preview within w_pdt_06545
end type

type p_exit from w_standard_print`p_exit within w_pdt_06545
end type

type p_print from w_standard_print`p_print within w_pdt_06545
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_06545
end type







type st_10 from w_standard_print`st_10 within w_pdt_06545
end type



type dw_print from w_standard_print`dw_print within w_pdt_06545
string dataobject = "d_pdt_06540_03_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_06545
integer x = 14
integer y = 20
integer width = 1765
integer height = 244
string dataobject = "d_pdt_06540_04"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;//String  s_cod
//
//s_cod = Trim(this.GetText())
//
//if this.GetColumnName() = "yyyy" then 
//	if IsNull(s_cod) or s_cod = "" or f_datechk(s_cod + '0101') = -1 then
//		f_message_chk(35,"[기준년도]")
//		this.object.yyyy[1] = ""
//		return 1
//	end if	
//end if
//
//
end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

if this.GetColumnName() = "s_mchno" then
	gs_gubun = 'ALL'
	open(w_mchno_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.object.s_mchno[1] = gs_code
elseif this.GetColumnName() = "e_mchno" then
	gs_gubun = 'ALL'
   open(w_mchno_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.object.e_mchno[1] = gs_code
end if	
end event

type dw_list from w_standard_print`dw_list within w_pdt_06545
integer x = 32
integer y = 288
integer width = 4571
integer height = 1960
string dataobject = "d_pdt_06540_03"
boolean border = false
end type

type rr_1 from roundrectangle within w_pdt_06545
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 272
integer width = 4608
integer height = 1992
integer cornerheight = 40
integer cornerwidth = 55
end type

