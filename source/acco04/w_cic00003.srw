$PBExportHeader$w_cic00003.srw
$PBExportComments$원가수불코드 등록
forward
global type w_cic00003 from w_inherite
end type
type dw_list from datawindow within w_cic00003
end type
type shl_1 from statichyperlink within w_cic00003
end type
type dw_print from datawindow within w_cic00003
end type
type rr_1 from roundrectangle within w_cic00003
end type
type rr_2 from roundrectangle within w_cic00003
end type
end forward

global type w_cic00003 from w_inherite
string title = "원가수불코드 등록"
dw_list dw_list
shl_1 shl_1
dw_print dw_print
rr_1 rr_1
rr_2 rr_2
end type
global w_cic00003 w_cic00003

on w_cic00003.create
int iCurrent
call super::create
this.dw_list=create dw_list
this.shl_1=create shl_1
this.dw_print=create dw_print
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list
this.Control[iCurrent+2]=this.shl_1
this.Control[iCurrent+3]=this.dw_print
this.Control[iCurrent+4]=this.rr_1
this.Control[iCurrent+5]=this.rr_2
end on

on w_cic00003.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_list)
destroy(this.shl_1)
destroy(this.dw_print)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;ib_any_typing = false

dw_list.SetTransObject(sqlca)
dw_insert.SetTransObject(sqlca)

dw_list.retrieve()
dw_list.ShareData(dw_insert)

end event

type dw_insert from w_inherite`dw_insert within w_cic00003
integer x = 1339
integer y = 212
integer width = 2414
integer height = 2048
integer taborder = 80
string dataobject = "d_cic00003_02"
boolean border = false
end type

event dw_insert::rowfocuschanged;call super::rowfocuschanged;if dw_insert.getrow() <> dw_list.getrow() then dw_list.scrolltorow(dw_insert.getrow())

end event

type p_delrow from w_inherite`p_delrow within w_cic00003
boolean visible = false
integer x = 3794
integer y = 2364
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_cic00003
boolean visible = false
integer x = 3621
integer y = 2364
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_cic00003
boolean visible = false
integer x = 3680
integer y = 2836
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_cic00003
integer x = 3735
integer y = 16
end type

event p_ins::clicked;call super::clicked;Long	ll_row

If dw_list.RowCount() < 1 Then
	ll_row = dw_list.Insertrow(1)
Else
	ll_row = dw_list.Insertrow(dw_list.GetRow())
End If

dw_list.ScrollToRow(ll_row)
dw_list.SetRow(ll_row)

end event

type p_exit from w_inherite`p_exit within w_cic00003
integer x = 4430
integer y = 16
integer taborder = 60
end type

type p_can from w_inherite`p_can within w_cic00003
boolean visible = false
integer x = 4375
integer y = 2836
integer taborder = 0
end type

type p_print from w_inherite`p_print within w_cic00003
integer x = 4256
integer y = 16
integer taborder = 50
end type

event p_print::clicked;call super::clicked;dw_print.Retrieve()

OpenWithParm(w_print_preview, dw_print)	

end event

type p_inq from w_inherite`p_inq within w_cic00003
integer x = 3561
integer y = 16
end type

event p_inq::clicked;call super::clicked;dw_list.retrieve()

end event

type p_del from w_inherite`p_del within w_cic00003
integer x = 3909
integer y = 16
integer taborder = 30
end type

event p_del::clicked;call super::clicked;Long	ll_row

ll_row = dw_list.GetRow()
dw_list.Deleterow(0)

if dw_list.RowCount() <> 0 Then
	if ll_row <= dw_list.RowCount() then
		dw_list.ScrollToRow(ll_row)
	else
		ll_row = dw_list.RowCount()
		dw_list.ScrollToRow(ll_row)
	end if

	dw_list.SelectRow(0, FALSE)
	dw_list.SelectRow(dw_insert.getrow(), TRUE)

end if

end event

type p_mod from w_inherite`p_mod within w_cic00003
integer x = 4082
integer y = 16
integer taborder = 40
end type

event p_mod::clicked;call super::clicked;IF dw_insert.Accepttext() = -1 THEN RETURN

if dw_insert.ModifiedCount() + dw_insert.DeletedCount() = 0 then Return
// 무결성 체크 - 정상,타계정 모두 Y 체크를 방지함
STRING lmg,lhg,lfg,lgg,leg,lmt,lht,lft,lgt,let
lmg = dw_insert.GetitemString(dw_insert.getrow(), 'mgubun')
lhg = dw_insert.GetitemString(dw_insert.getrow(), 'hgubun')
lfg = dw_insert.GetitemString(dw_insert.getrow(), 'fgubun')
lgg = dw_insert.GetitemString(dw_insert.getrow(), 'ggubun')
leg = dw_insert.GetitemString(dw_insert.getrow(), 'egubun')
lmt = dw_insert.GetitemString(dw_insert.getrow(), 'mta')
lht = dw_insert.GetitemString(dw_insert.getrow(), 'hta')
lft = dw_insert.GetitemString(dw_insert.getrow(), 'fta')
lgt = dw_insert.GetitemString(dw_insert.getrow(), 'gta')
let = dw_insert.GetitemString(dw_insert.getrow(), 'eta')

if lmg = 'Y' and lmt ='Y' then
	messagebox('오류','정상과 타계정 모두 Y로 설정할 수 없습니다!')
	dw_insert.Setfocus()
	dw_insert.SetColumn('mgubun')
end if
if lhg = 'Y' and lht ='Y' then
	messagebox('오류','정상과 타계정 모두 Y로 설정할 수 없습니다!')
	dw_insert.Setfocus()
	dw_insert.SetColumn('hgubun')
end if
if lfg = 'Y' and lft ='Y' then
	messagebox('오류','정상과 타계정 모두 Y로 설정할 수 없습니다!')
	dw_insert.Setfocus()
	dw_insert.SetColumn('fgubun')
end if
if lgg = 'Y' and lgt ='Y' then
	messagebox('오류','정상과 타계정 모두 Y로 설정할 수 없습니다!')
	dw_insert.Setfocus()
	dw_insert.SetColumn('ggubun')
end if
if leg = 'Y' and let ='Y' then
	messagebox('오류','정상과 타계정 모두 Y로 설정할 수 없습니다!')
	dw_insert.Setfocus()
	dw_insert.SetColumn('egubun')
end if


// 저장메세지 function
IF f_msg_update() = -1 THEN RETURN

IF dw_insert.Update() > 0 THEN			
	COMMIT;
	ib_any_typing =False
	w_mdi_frame.sle_msg.text ="자료를 저장하였습니다!!"
ELSE
	ROLLBACK;
	ib_any_typing = True
//	Return
END IF

end event

type cb_exit from w_inherite`cb_exit within w_cic00003
boolean visible = false
end type

type cb_mod from w_inherite`cb_mod within w_cic00003
boolean visible = false
end type

type cb_ins from w_inherite`cb_ins within w_cic00003
boolean visible = false
end type

type cb_del from w_inherite`cb_del within w_cic00003
boolean visible = false
end type

type cb_inq from w_inherite`cb_inq within w_cic00003
boolean visible = false
end type

type cb_print from w_inherite`cb_print within w_cic00003
boolean visible = false
end type

type st_1 from w_inherite`st_1 within w_cic00003
end type

type cb_can from w_inherite`cb_can within w_cic00003
boolean visible = false
end type

type cb_search from w_inherite`cb_search within w_cic00003
boolean visible = false
end type







type gb_button1 from w_inherite`gb_button1 within w_cic00003
end type

type gb_button2 from w_inherite`gb_button2 within w_cic00003
end type

type dw_list from datawindow within w_cic00003
integer x = 46
integer y = 204
integer width = 1198
integer height = 2056
integer taborder = 70
boolean bringtotop = true
string title = "none"
string dataobject = "d_cic00003_01"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event rowfocuschanged;This.Post SelectRow(0, FALSE)
This.Post SelectRow(currentrow, TRUE)

if dw_list.getrow() <> dw_insert.getrow() then dw_insert.scrolltorow(currentrow)

end event

event retrieveend;if rowcount > 0 then This.Event rowfocuschanged(1)
end event

event doubleclicked;// Datawindow 정렬하기.
f_sort(This)

end event

type shl_1 from statichyperlink within w_cic00003
integer x = 2766
integer y = 64
integer width = 800
integer height = 64
boolean bringtotop = true
integer textsize = -11
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 134217856
long backcolor = 32106727
string text = "수불구분 자료복사"
alignment alignment = center!
boolean focusrectangle = false
end type

event clicked;String	ls_msg


ls_msg = "물류의 IO MATRIX로부터 추가된 자료를 받으시겠습니까?"
If MessageBox("작업 확인", ls_msg, question!, yesno!, 2) = 2 Then Return


// 
INSERT INTO CIAIOGBN
(
	IOGBN
	, IONAM
	, IOSP
	, CALVALUE
	, STKVALUE
	, MAIPGU
	, SALEGU
	, MGUBUN
	, HGUBUN
	, FGUBUN
	, GGUBUN
	, EGUBUN
	, MTA
	, HTA
	, FTA
	, GTA
	, ETA
	, MPAC
	, HPAC
	, FPAC
	, GPAC
	, EPAC
	, MMAC
	, HMAC
	, FMAC
	, GMAC
	, EMAC
	, ETC1
	, ETC2
	, ETC3
)  
SELECT
	IOGBN
	, IONAM
	, IOSP
	, CALVALUE
	, STKVALUE
	, MAIPGU
	, SALEGU
	, 'N'
	, 'N'
	, 'N'
	, 'N'
	, 'N'
	, 'N'
	, 'N'
	, 'N'
	, 'N'
	, 'N'
	, NULL
	, NULL
	, NULL
	, NULL
	, NULL
	, NULL
	, NULL
	, NULL
	, NULL
	, NULL
	, NULL
	, NULL
	, NULL
FROM
	IOMATRIX
WHERE
	NOT EXISTS (SELECT * FROM CIAIOGBN WHERE IOGBN = IOMATRIX.IOGBN)
;

commit ;


MessageBox("확인", "물류의 IO MATRIX로부터 추가된 자료생성 작업이 정상처리 되었습니다.")


p_inq.Post Event Clicked()

end event

type dw_print from datawindow within w_cic00003
boolean visible = false
integer x = 2171
integer width = 178
integer height = 144
boolean bringtotop = true
string title = "none"
string dataobject = "d_cic00003_02p"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;This.SetTransObject(sqlca)

end event

type rr_1 from roundrectangle within w_cic00003
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 192
integer width = 1221
integer height = 2084
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_cic00003
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1321
integer y = 192
integer width = 3282
integer height = 2084
integer cornerheight = 40
integer cornerwidth = 55
end type

