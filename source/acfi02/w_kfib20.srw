$PBExportHeader$w_kfib20.srw
$PBExportComments$받을어음 수불장
forward
global type w_kfib20 from w_standard_print
end type
type rr_1 from roundrectangle within w_kfib20
end type
end forward

global type w_kfib20 from w_standard_print
integer x = 0
integer y = 0
string title = "받을어음 수불장"
rr_1 rr_1
end type
global w_kfib20 w_kfib20

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String ls_fromsaupj, ls_tosaupj, ls_saupjnm, ls_fromdate, ls_todate, ls_colnm, symd_text, eymd_text, snull

dw_list.Reset()
If dw_ip.AcceptText() = -1 then return -1

ls_fromsaupj = dw_ip.Getitemstring(1, 'saupj')
ls_fromdate = dw_ip.Getitemstring(1, 'fromdate')
ls_todate = dw_ip.Getitemstring(1, 'todate')

If Isnull(ls_fromsaupj) or ls_fromsaupj = '' then
	F_MessageChk(1,'[사업장]')
	dw_ip.SetColumn("saupj")
	dw_ip.SetFocus()
	Return -1
Else
	Select rfna1 Into :ls_saupjnm
	  From reffpf
	 Where rfcod = 'AD' and rfgub = :ls_fromsaupj ;
	 
	 	If sqlca.sqlcode <> 0 Then
		MessageBox("확인", "입력하신 자료에 해당하는 사업장이 없습니다.!!")
		dw_ip.Setcolumn('saupj')
		dw_ip.Setfocus()
		return -1
	End If
	ls_tosaupj = ls_fromsaupj
End If

dw_print.modify("saupj.text ='"+ls_saupjnm+"'")

/*** 날짜를 체크한다. ******************************************/
If ls_fromdate = '' or Isnull(ls_fromdate) or f_datechk(ls_fromdate) = -1 Then
	f_messagechk(1, '[회계일자]')
	dw_ip.Setcolumn('fromdate')
	dw_ip.Setfocus()
	Return -1
End If

If ls_todate = '' or Isnull(ls_todate) or f_datechk(ls_todate) = -1 Then
	f_messagechk(1, '[회계일자]')
	dw_ip.Setcolumn('todate')
	dw_ip.Setfocus()
	Return -1
End If

If long(ls_fromdate) > long(ls_todate) Then
	f_messagechk(24, '[회계일자]')
	dw_ip.Setcolumn('fromdate')
	dw_ip.Setfocus()
	Return -1
End If

symd_text = left(ls_fromdate, 4) + '.'+ mid(ls_fromdate, 5, 2) + '.' + right(ls_fromdate, 2)
dw_print.modify("symd.text ='"+symd_text+"'")

eymd_text = left(ls_todate, 4) + '.'+ mid(ls_todate, 5, 2) + '.' + right(ls_todate, 2)
dw_print.modify("eymd.text ='"+eymd_text+"'")

	
/*** DW_LIST를 DW_IP의 조건에 맞게 조회한다. ***************************/
If dw_print.Retrieve(ls_fromsaupj, ls_tosaupj, ls_fromdate, ls_todate) <= 0 Then
	f_messagechk(14,'')
	dw_ip.Setfocus()

	Return -1 
End If
   dw_print.sharedata(dw_list)
Return 1

end function

on w_kfib20.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kfib20.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;String ls_base

ls_base = String(f_today(), '@@@@@@@@')

dw_ip.Setitem(1,'saupj',   Gs_Saupj)
dw_ip.Setitem(1,'fromdate',left(ls_base,6)+'01')
dw_ip.Setitem(1,'todate',ls_base)

IF f_Authority_Fund_Chk(Gs_Dept) = -1 THEN
	dw_ip.Modify('saupj.protect = 1')
//	dw_ip.Modify("saupj.BackGround.Color = '"+String(Rgb(192,192,192))+"'") 
Else
	dw_ip.Modify('saupj.protect = 0')
//	dw_ip.Modify("saupj.BackGround.Color = '"+String(Rgb(255,255,255))+"'")  //MINT COLOR
End if

end event

type p_preview from w_standard_print`p_preview within w_kfib20
string pointer = ""
end type

type p_exit from w_standard_print`p_exit within w_kfib20
string pointer = ""
end type

type p_print from w_standard_print`p_print within w_kfib20
string pointer = ""
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfib20
string pointer = ""
end type







type st_10 from w_standard_print`st_10 within w_kfib20
end type



type dw_print from w_standard_print`dw_print within w_kfib20
string dataobject = "dw_kfib20_2_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kfib20
integer x = 32
integer y = 20
integer width = 2414
integer height = 156
string dataobject = "dw_kfib20_1"
end type

event dw_ip::itemerror;call super::itemerror;Return 1
end event

event dw_ip::losefocus;call super::losefocus;dw_ip.AcceptText()
end event

type dw_list from w_standard_print`dw_list within w_kfib20
integer x = 46
integer y = 184
integer width = 4558
integer height = 2020
string dataobject = "dw_kfib20_2"
boolean border = false
boolean hsplitscroll = false
end type

type rr_1 from roundrectangle within w_kfib20
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 180
integer width = 4571
integer height = 2036
integer cornerheight = 40
integer cornerwidth = 55
end type

