$PBExportHeader$w_kfia521.srw
$PBExportComments$월자금 소요계획 등록- 자료 복사창
forward
global type w_kfia521 from window
end type
type p_can from uo_picture within w_kfia521
end type
type p_exit from uo_picture within w_kfia521
end type
type dw_dest from datawindow within w_kfia521
end type
type dw_sour from datawindow within w_kfia521
end type
type dw_ip from datawindow within w_kfia521
end type
end forward

global type w_kfia521 from window
integer x = 1147
integer y = 628
integer width = 809
integer height = 420
boolean titlebar = true
string title = "자료복사"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_can p_can
p_exit p_exit
dw_dest dw_dest
dw_sour dw_sour
dw_ip dw_ip
end type
global w_kfia521 w_kfia521

type variables
string is_date, is_return
end variables

on w_kfia521.create
this.p_can=create p_can
this.p_exit=create p_exit
this.dw_dest=create dw_dest
this.dw_sour=create dw_sour
this.dw_ip=create dw_ip
this.Control[]={this.p_can,&
this.p_exit,&
this.dw_dest,&
this.dw_sour,&
this.dw_ip}
end on

on w_kfia521.destroy
destroy(this.p_can)
destroy(this.p_exit)
destroy(this.dw_dest)
destroy(this.dw_sour)
destroy(this.dw_ip)
end on

event open;s_soyo is_soyo

f_window_center_Response(this)

is_soyo = Message.PowerObjectParm
is_date = is_soyo.lstr_yymm

dw_ip.SetTransObject(sqlca)
dw_sour.SetTransObject(sqlca)
dw_dest.SetTransObject(sqlca)

dw_ip.reset()
dw_sour.reset()
dw_dest.reset()

dw_ip.insertrow(0)
dw_ip.SetItem(dw_ip.Getrow(), 'acc_yymm', left(f_today(), 6))
is_soyo.lstr_yymm = dw_ip.GetItemstring(dw_ip.Getrow(), 'acc_yymm' )
dw_ip.SetColumn('acc_yymm')
dw_ip.SetFocus()


end event

type p_can from uo_picture within w_kfia521
integer x = 594
integer width = 178
integer taborder = 40
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;s_soyo is_soyo

is_soyo.lstr_return1 = '0'

closewithReturn(parent, is_soyo)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

type p_exit from uo_picture within w_kfia521
integer x = 421
integer width = 178
integer taborder = 30
string pointer = "C:\erpman\cur\confirm.cur"
string picturename = "C:\erpman\image\확인_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;s_soyo is_soyo
String  ls_Acc_Yymm
Integer iSourCnt,iDestCnt,i,iCurRow

dw_sour.reset()
dw_dest.reset()

dw_ip.AcceptText()
if dw_ip.GetRow() < 1 then return 

is_soyo = Message.PowerObjectParm

is_soyo.lstr_yymm = Trim(dw_ip.GetItemString(dw_ip.GetRow(), 'acc_yymm'))

if isnull(is_soyo.lstr_yymm) or trim(is_soyo.lstr_yymm) = '' then 
	F_MessageChk(1, "[복사대상년월]")
	dw_ip.SetColumn('acc_yymm')
	dw_ip.SetFocus()
	return
end if
if is_soyo.lstr_yymm = is_date then 
	MessageBox("확 인", "동일년월로는 자료를 복사할 수 없습니다.!!")
	return
end if

if dw_sour.retrieve(is_soyo.lstr_yymm, is_soyo.lstr_saupj, is_soyo.lstr_dept) <= 0 then	/* 복사대상년월의 자료 조회*/
	MessageBox("확 인", "복사대상년월에 해당 자료가 존재하지 않습니다.!!")
	dw_ip.SetColumn('acc_yymm')
	dw_ip.SetFocus()			
	return 
else
	iSourCnt = dw_sour.RowCount()	
end if	

/* 대상년월의 기존 자료를 조회한다. - 있으면 삭제*/
iDestCnt = dw_dest.retrieve(is_date, is_soyo.lstr_saupj, is_soyo.lstr_dept)
if iDestCnt > 0 then 
	for i = iDestCnt to 1 Step -1
		dw_dest.deleterow(0)
	next
   if dw_dest.update() <> 1 then 
		rollback;
		F_MessageChk(12,'[기존자료]')
		return 
	end if
	commit;
end if

for i = 1 to iSourCnt 
	iCurRow = dw_dest.insertrow(0)

	dw_dest.SetItem(iCurRow, 'acc_ym',     is_date)	
	dw_dest.SetItem(iCurRow, 'seq_no',     String(i,'000'))
	dw_dest.SetItem(iCurRow, 'plan_day',   dw_sour.GetItemString(i, 'plan_day')	)	
	dw_dest.SetItem(iCurRow, 'saup_no',    dw_sour.GetItemString(i, 'saup_no'))	
	dw_dest.SetItem(iCurRow, 'saup_nm',    dw_sour.GetItemString(i, 'saup_nm'))	
	dw_dest.SetItem(iCurRow, 'descr',      dw_sour.GetItemString(i, 'descr'))		
	dw_dest.SetItem(iCurRow, 'famt',       dw_sour.GetItemNumber(i, 'famt'))			
	dw_dest.SetItem(iCurRow, 'finance_cd', dw_sour.GetItemString(i, 'finance_cd'))				
	dw_dest.SetItem(iCurRow, 'dept_cd',    dw_sour.GetItemString(i, 'dept_cd'))
	dw_dest.SetItem(iCurRow, 'saupj',      dw_sour.GetItemString(i, 'saupj'))
	dw_dest.SetItem(iCurRow, 'crtgbn',     dw_sour.GetItemString(i, 'crtgbn'))
next

if dw_dest.update() <> 1 then 
	rollback;
	F_MessageChk(13,'')
	return 
end if
commit ;

/* return '1'을 하면 원래 화면으로 돌아갔을 경우,*/
is_soyo.lstr_return1 = '1'

closewithReturn(parent, is_soyo)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\확인_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\확인_up.gif"
end event

type dw_dest from datawindow within w_kfia521
boolean visible = false
integer x = 882
integer y = 48
integer width = 827
integer height = 112
boolean enabled = false
boolean titlebar = true
string title = "복사한 자료(저장)"
string dataobject = "dw_kfia5212"
boolean maxbox = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_sour from datawindow within w_kfia521
boolean visible = false
integer x = 878
integer y = 184
integer width = 823
integer height = 100
boolean enabled = false
boolean titlebar = true
string title = "복사대상 자료"
string dataobject = "dw_kfia5213"
boolean controlmenu = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_ip from datawindow within w_kfia521
event ue_enter pbm_dwnprocessenter
integer x = 23
integer y = 140
integer width = 763
integer height = 160
integer taborder = 10
string dataobject = "dw_kfia5211"
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

