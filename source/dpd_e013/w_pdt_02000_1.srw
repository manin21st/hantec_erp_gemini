$PBExportHeader$w_pdt_02000_1.srw
$PBExportComments$생산승인등록시-작업의뢰서 출력
forward
global type w_pdt_02000_1 from window
end type
type p_print from uo_picture within w_pdt_02000_1
end type
type dw_etc from datawindow within w_pdt_02000_1
end type
type dw_stc from datawindow within w_pdt_02000_1
end type
type cb_1 from commandbutton within w_pdt_02000_1
end type
type rb_all from radiobutton within w_pdt_02000_1
end type
type rb_old from radiobutton within w_pdt_02000_1
end type
type rb_new from radiobutton within w_pdt_02000_1
end type
type rr_1 from roundrectangle within w_pdt_02000_1
end type
end forward

global type w_pdt_02000_1 from window
integer x = 699
integer y = 800
integer width = 837
integer height = 436
boolean titlebar = true
string title = "생산의뢰서"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
boolean clientedge = true
p_print p_print
dw_etc dw_etc
dw_stc dw_stc
cb_1 cb_1
rb_all rb_all
rb_old rb_old
rb_new rb_new
rr_1 rr_1
end type
global w_pdt_02000_1 w_pdt_02000_1

type variables
datawindow dwprt
end variables

on w_pdt_02000_1.create
this.p_print=create p_print
this.dw_etc=create dw_etc
this.dw_stc=create dw_stc
this.cb_1=create cb_1
this.rb_all=create rb_all
this.rb_old=create rb_old
this.rb_new=create rb_new
this.rr_1=create rr_1
this.Control[]={this.p_print,&
this.dw_etc,&
this.dw_stc,&
this.cb_1,&
this.rb_all,&
this.rb_old,&
this.rb_new,&
this.rr_1}
end on

on w_pdt_02000_1.destroy
destroy(this.p_print)
destroy(this.dw_etc)
destroy(this.dw_stc)
destroy(this.cb_1)
destroy(this.rb_all)
destroy(this.rb_old)
destroy(this.rb_new)
destroy(this.rr_1)
end on

event open;dwprt = message.powerobjectparm

dw_stc.settransobject(sqlca)
dw_etc.settransobject(sqlca)

f_window_center_response(this)
end event

type p_print from uo_picture within w_pdt_02000_1
integer x = 617
integer y = 24
integer width = 178
integer taborder = 100
string pointer = "C:\erpman\cur\print.cur"
string picturename = "C:\erpman\image\인쇄_up.gif"
end type

event clicked;call super::clicked;Long    Lrow1, lrow2, lrow3, k
int     ireturn 
string  fdate, tdate, spdtgu, epdtgu, sittyp, sfitcls, stitcls, sempno, sprtgu

setpointer(hourglass!)
if dwprt.accepttext() = -1 then return 

fdate  = trim(dwprt.object.sfrom[1])
tdate  = trim(dwprt.object.sto[1])
spdtgu = trim(dwprt.getitemstring(1, 'pdtgu')) 
epdtgu = trim(dwprt.getitemstring(1, 'epdtgu')) 
sittyp = trim(dwprt.getitemstring(1, 'ittyp')) 
sfitcls = trim(dwprt.getitemstring(1, 'fitcls')) 
stitcls = trim(dwprt.getitemstring(1, 'titcls')) 
sempno  = trim(dwprt.getitemstring(1, 'empno')) 

if fdate = ''  or isnull(fdate)  then fdate = '10000101'
if Tdate = ''  or isnull(tdate)  then tdate = '99991231'
if spdtgu = '' or isnull(spdtgu) then spdtgu = '.'
if epdtgu = '' or isnull(epdtgu) then epdtgu = 'zzzzzz'
if sittyp = '' or isnull(sittyp) then sittyp = '%'
if sfitcls = '' or isnull(sfitcls) then sfitcls = '.'
if stitcls = '' or isnull(stitcls) then 
	stitcls = 'zzzzzzz'
else
	stitcls = stitcls + 'zzzzzz'
end if	
if sempno = '' or isnull(sempno) then sempno = '%'

if rb_new.checked then
	sprtgu = 'N'
Elseif rb_old.checked then
	sprtgu = 'Y'
Else
	sprtgu = '%'
End if

Lrow2 = dw_stc.retrieve(gs_sabu, fdate, tdate, spdtgu, epdtgu, sfitcls, stitcls, sempno, sittyp, sprtgu)
Lrow3 = dw_etc.retrieve(gs_sabu, fdate, tdate, spdtgu, epdtgu, sfitcls, stitcls, sempno, sittyp, sprtgu)

If Lrow2 <= 0 and lrow3 <= 0 then
	f_message_chk(50,'[생산의뢰 내역]')
	return 0
else	
	iReturn = messagebox('출력 확인', '일반수주 : ' + STRING(Lrow2) + '건  ' + &
	                        '기타수주 : ' + STRING(Lrow3) + '건이 조회 되었습니다. ' + "~n~n" + &
							      '출력 하시겠습니까?',Question!,YesNo!,1) 
   if iReturn <> 1 then 
		dw_stc.reset()
		dw_etc.reset()
		return 0									
	end if
end if

IF Lrow2 > 0 THEN 
	IF dw_stc.PRINT() = 1 THEN 
		FOR k = 1 TO Lrow2
			dw_stc.setitem(k, 'sorder_print_print_yn', 'Y')
		NEXT
		If dw_stc.update() = -1 then
			rollback ;
		else
			commit;
		end if	
	END IF
END IF
	
IF Lrow3 > 0 THEN 
	IF dw_etc.PRINT() = 1 THEN 
		FOR k = 1 TO Lrow3
			dw_etc.setitem(k, 'sorder_print_print_yn', 'Y')
		NEXT
		If dw_etc.update() = -1 then
			rollback ;
		else
			commit;
		end if	
	END IF
END IF

dw_stc.reset()
dw_etc.reset()

end event

event ue_lbuttondown;call super::ue_lbuttondown;picturename = 'C:\erpman\image\인쇄_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;picturename = 'C:\erpman\image\인쇄_up.gif'
end event

type dw_etc from datawindow within w_pdt_02000_1
boolean visible = false
integer x = 562
integer y = 356
integer width = 411
integer height = 432
integer taborder = 30
string title = "수주내역-일반외"
string dataobject = "d_pdt_02000_6"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_stc from datawindow within w_pdt_02000_1
boolean visible = false
integer x = 110
integer y = 356
integer width = 411
integer height = 432
integer taborder = 30
string title = "수주내역-일반"
string dataobject = "d_pdt_02000_5"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_pdt_02000_1
integer x = 1417
integer y = 52
integer width = 178
integer height = 108
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "출력"
end type

type rb_all from radiobutton within w_pdt_02000_1
integer x = 73
integer y = 224
integer width = 402
integer height = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "전     체"
end type

type rb_old from radiobutton within w_pdt_02000_1
integer x = 73
integer y = 148
integer width = 402
integer height = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "기존 출력"
end type

type rb_new from radiobutton within w_pdt_02000_1
integer x = 73
integer y = 72
integer width = 402
integer height = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "신규 출력"
boolean checked = true
end type

type rr_1 from roundrectangle within w_pdt_02000_1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 23
integer y = 32
integer width = 535
integer height = 292
integer cornerheight = 40
integer cornerwidth = 55
end type

