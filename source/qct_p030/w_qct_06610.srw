$PBExportHeader$w_qct_06610.srw
$PBExportComments$** 이상발생 통보서 현황
forward
global type w_qct_06610 from w_standard_print
end type
type rr_1 from roundrectangle within w_qct_06610
end type
end forward

global type w_qct_06610 from w_standard_print
string title = "이상발생 통보서 현황"
boolean maxbox = true
rr_1 rr_1
end type
global w_qct_06610 w_qct_06610

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ym, gubun, gbn[3] = {"부품이상발생","제품이상기록", "출하이상기록"}

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

ym    = Trim(dw_ip.object.ym[1])
gubun = Trim(dw_ip.object.gubun[1])

if (IsNull(ym) or ym = "")  then 
	f_message_chk(30, "[기준년월]")
	dw_ip.SetColumn("ym")
	dw_ip.Setfocus()
	return -1
end if

//dw_list.object.txt_gubun.text = gbn[integer(gubun)]
//dw_list.object.txt_title.text = String(ym,"@@@@년 @@월 이상발생 통보서 현황")

IF dw_print.Retrieve(gs_sabu, ym, gubun) <= 0 then
	f_message_chk(50,'[이상발생 통보서 현황]')
	dw_list.Reset()
	dw_ip.SetFocus()
END IF

dw_print.object.txt_gubun.text = gbn[integer(gubun)]
dw_print.object.txt_title.text = String(ym,"@@@@년 @@월 이상발생 통보서 현황")

dw_print.ShareData(dw_list)

return 1
end function

on w_qct_06610.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_qct_06610.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

type p_preview from w_standard_print`p_preview within w_qct_06610
integer x = 4032
end type

type p_exit from w_standard_print`p_exit within w_qct_06610
integer x = 4379
end type

type p_print from w_standard_print`p_print within w_qct_06610
integer x = 4206
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_06610
integer x = 3858
end type







type st_10 from w_standard_print`st_10 within w_qct_06610
end type



type dw_print from w_standard_print`dw_print within w_qct_06610
integer x = 3666
string dataobject = "d_qct_06610_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_06610
integer x = 37
integer width = 2400
integer height = 136
string dataobject = "d_qct_06610_01"
end type

event dw_ip::itemchanged;string s_cod

s_cod = Trim(this.GetText())

if this.GetColumnName() = "ym" then
	if f_datechk(s_cod + '01') = -1 then
		f_message_chk(35, "[기준년월]")
		this.object.ym[1] = ""
		return 1
	end if
end if
return

end event

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_qct_06610
integer x = 78
integer y = 200
integer width = 4489
integer height = 2120
string dataobject = "d_qct_06610_02"
boolean border = false
end type

type rr_1 from roundrectangle within w_qct_06610
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 188
integer width = 4521
integer height = 2140
integer cornerheight = 40
integer cornerwidth = 55
end type

