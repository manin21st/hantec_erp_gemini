$PBExportHeader$w_kfia22a.srw
$PBExportComments$자금계획 고정금액 등록 - 자료복사
forward
global type w_kfia22a from window
end type
type p_can from uo_picture within w_kfia22a
end type
type p_exit from uo_picture within w_kfia22a
end type
type dw_ip from datawindow within w_kfia22a
end type
end forward

global type w_kfia22a from window
integer x = 1147
integer y = 628
integer width = 837
integer height = 440
boolean titlebar = true
string title = "자료복사"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_can p_can
p_exit p_exit
dw_ip dw_ip
end type
global w_kfia22a w_kfia22a

type variables
string IsDescYm
end variables

on w_kfia22a.create
this.p_can=create p_can
this.p_exit=create p_exit
this.dw_ip=create dw_ip
this.Control[]={this.p_can,&
this.p_exit,&
this.dw_ip}
end on

on w_kfia22a.destroy
destroy(this.p_can)
destroy(this.p_exit)
destroy(this.dw_ip)
end on

event open;
f_window_center_Response(this)

IsDescYm = Message.StringParm

dw_ip.SetTransObject(sqlca)

dw_ip.reset()
dw_ip.insertrow(0)
dw_ip.SetItem(1, 'acc_yymm',  Left(F_Today(),6))
dw_ip.SetColumn('acc_yymm')
dw_ip.SetFocus()


end event

type p_can from uo_picture within w_kfia22a
integer x = 594
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

type p_exit from uo_picture within w_kfia22a
integer x = 421
integer width = 178
integer taborder = 30
string pointer = "C:\erpman\cur\confirm.cur"
string picturename = "C:\erpman\image\확인_up.gif"
end type

event clicked;call super::clicked;
String    sYearMonth
Integer   iCount

dw_ip.AcceptText()
if dw_ip.GetRow() < 1 then return 
sYearMonth = Trim(dw_ip.GetItemString(1, 'acc_yymm'))

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

insert into kfm13ot0
	(finamce_day,		finance_cd,		finance_desc,	apply_gu,		plan_amt,		finance_ym)
select finamce_day,		finance_cd,		finance_desc,	apply_gu,		plan_amt,		:IsDescYm
	from kfm13ot0
	where finance_ym = :sYearMonth ;
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

type dw_ip from datawindow within w_kfia22a
event ue_enter pbm_dwnprocessenter
integer x = 23
integer y = 140
integer width = 763
integer height = 160
integer taborder = 10
string dataobject = "d_kfia22a1"
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

