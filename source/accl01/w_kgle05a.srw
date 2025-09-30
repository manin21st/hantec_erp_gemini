$PBExportHeader$w_kgle05a.srw
$PBExportComments$가결산조정자료 복사
forward
global type w_kgle05a from window
end type
type p_can from uo_picture within w_kgle05a
end type
type p_exit from uo_picture within w_kgle05a
end type
type dw_ip from datawindow within w_kgle05a
end type
end forward

global type w_kgle05a from window
integer x = 1147
integer y = 628
integer width = 1760
integer height = 304
boolean titlebar = true
string title = "자료복사"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_can p_can
p_exit p_exit
dw_ip dw_ip
end type
global w_kgle05a w_kgle05a

type variables
string IsDescYm,Isaupj
end variables

on w_kgle05a.create
this.p_can=create p_can
this.p_exit=create p_exit
this.dw_ip=create dw_ip
this.Control[]={this.p_can,&
this.p_exit,&
this.dw_ip}
end on

on w_kgle05a.destroy
destroy(this.p_can)
destroy(this.p_exit)
destroy(this.dw_ip)
end on

event open;
f_window_center_Response(this)

IsDescYm = Left(Message.StringParm,6)
ISaupj   = Mid(Message.StringParm,7,2)

dw_ip.SetTransObject(sqlca)

dw_ip.reset()
dw_ip.insertrow(0)
dw_ip.SetItem(1, 'acc_yymm',  Left(F_Today(),6))
dw_ip.SetItem(1, 'saupj',     Isaupj)
dw_ip.SetColumn('acc_yymm')
dw_ip.SetFocus()

end event

type p_can from uo_picture within w_kgle05a
integer x = 1545
integer y = 12
integer width = 178
integer taborder = 40
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event clicked;call super::clicked;
closewithReturn(parent, '0')
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

type p_exit from uo_picture within w_kgle05a
integer x = 1371
integer y = 12
integer width = 178
integer taborder = 30
string pointer = "C:\erpman\cur\confirm.cur"
string picturename = "C:\erpman\image\확인_up.gif"
end type

event clicked;call super::clicked;
String    sYearMonth,sSaupj
Integer   iCount

dw_ip.AcceptText()
if dw_ip.GetRow() < 1 then return 
sYearMonth = Trim(dw_ip.GetItemString(1, 'acc_yymm'))
sSaupj     = Trim(dw_ip.GetItemString(1, 'saupj'))

if isnull(sYearMonth) or trim(sYearMonth) = '' then 
	F_MessageChk(1, "[대상년월]")
	dw_ip.SetColumn('acc_yymm')
	dw_ip.SetFocus()
	return
end if
if sYearMonth = IsDescYm then 
	MessageBox("확 인", "동일년월로는 자료를 복사할 수 없습니다.!!")
	return
end if

insert into kfz02ot1
	(fs_ym,		saupj,		seq_no,		dcr_gu,		acc1_cd,		acc2_cd,		amt, 		kwan_no)
select  :IsDescYm, saupj,	seq_no,		dcr_gu,		acc1_cd,		acc2_cd,		amt,		kwan_no
	from kfz02ot1
	where fs_ym = :sYearMonth and saupj = :sSaupj ;
if sqlca.sqlcode = 0 then
	Commit;
else
	F_MessageChk(13,'')
	Rollback;
	Return
end if

closewithReturn(parent, '1')
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\확인_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\확인_up.gif"
end event

type dw_ip from datawindow within w_kgle05a
event ue_enter pbm_dwnprocessenter
integer x = 23
integer y = 8
integer width = 1339
integer height = 160
integer taborder = 10
string dataobject = "dw_kgle05a1"
boolean border = false
boolean livescroll = true
end type

event ue_enter;send(handle(this), 256, 9, 0)
return 1
end event

event itemerror;return 1
end event

event itemchanged;string ls_acc_yymm

if this.GetColumnName() = 'acc_yymm' then
	ls_acc_yymm = Trim(this.GetText())
	
	if isnull(ls_acc_yymm) or trim(ls_acc_yymm) = '' then 
		F_MessageChk(1, "[복사대상년월]")
		return 1
	else
		if f_datechk(ls_acc_yymm + "01") = -1 then 
			MessageBox("확 인", "유효한 복사대상년월이 아닙니다.!!")
			return 1
		end if
	end if
end if
end event

