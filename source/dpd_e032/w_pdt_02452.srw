$PBExportHeader$w_pdt_02452.srw
$PBExportComments$금형/치공구 제작의뢰서 발행
forward
global type w_pdt_02452 from w_standard_print
end type
end forward

global type w_pdt_02452 from w_standard_print
string title = "제작 의뢰서"
end type
global w_pdt_02452 w_pdt_02452

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string jpno, mjgbn, kestgub

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

jpno = trim(dw_ip.object.jpno[1])

// 금형/치공구구분, 의뢰구분에 따라서 변경
Select mjgbn, kestgub
  into :mjgbn, :kestgub
  From kumest
 where sabu = :gs_sabu and kestno = :jpno;
 
if sqlca.sqlcode <> 0 then
	f_message_chk(50,'[제작 의뢰서]')
	dw_ip.Setfocus()
	return -1	
end if

if mjgbn = 'M' then  // 금형
	if kestgub = '1' then
		dw_list.dataobject = 'd_pdt_02452_2'
	Else
		dw_list.dataobject = 'd_pdt_02452_3'
	End if
Else						// 치공구
	dw_list.dataobject = 'd_pdt_02452_4'
End if
dw_list.settransobject(sqlca)
	
if dw_list.Retrieve(gs_sabu, jpno) <= 0 then
	f_message_chk(50,'[제작 의뢰서]')
	dw_ip.Setfocus()
	return -1
end if

return 1
end function

on w_pdt_02452.create
call super::create
end on

on w_pdt_02452.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type p_preview from w_standard_print`p_preview within w_pdt_02452
end type

type p_exit from w_standard_print`p_exit within w_pdt_02452
end type

type p_print from w_standard_print`p_print within w_pdt_02452
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_02452
end type







type dw_ip from w_standard_print`dw_ip within w_pdt_02452
integer y = 236
integer width = 718
integer height = 388
string dataobject = "d_pdt_02452_1"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;call super::rbuttondown;open(w_pdt_02451)
this.setitem(1, "jpno", gs_code)

end event

type dw_list from w_standard_print`dw_list within w_pdt_02452
string dataobject = "d_pdt_02452_2"
end type

