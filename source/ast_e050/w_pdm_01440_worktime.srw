$PBExportHeader$w_pdm_01440_worktime.srw
$PBExportComments$** 공정별 작업시간
forward
global type w_pdm_01440_worktime from w_inherite_popup
end type
type p_mod from uo_picture within w_pdm_01440_worktime
end type
type p_del from uo_picture within w_pdm_01440_worktime
end type
type p_1 from uo_picture within w_pdm_01440_worktime
end type
type p_ins from uo_picture within w_pdm_01440_worktime
end type
type rr_2 from roundrectangle within w_pdm_01440_worktime
end type
end forward

global type w_pdm_01440_worktime from w_inherite_popup
integer x = 1285
integer y = 148
integer width = 1669
integer height = 1028
string title = "공정별 작업시간"
p_mod p_mod
p_del p_del
p_1 p_1
p_ins p_ins
rr_2 rr_2
end type
global w_pdm_01440_worktime w_pdm_01440_worktime

type variables
int  li_use  //거래처마스타는 거래중지인 경우도 조회

String is_pdtgu, is_itnbr, is_opseq
end variables

on w_pdm_01440_worktime.create
int iCurrent
call super::create
this.p_mod=create p_mod
this.p_del=create p_del
this.p_1=create p_1
this.p_ins=create p_ins
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_mod
this.Control[iCurrent+2]=this.p_del
this.Control[iCurrent+3]=this.p_1
this.Control[iCurrent+4]=this.p_ins
this.Control[iCurrent+5]=this.rr_2
end on

on w_pdm_01440_worktime.destroy
call super::destroy
destroy(this.p_mod)
destroy(this.p_del)
destroy(this.p_1)
destroy(this.p_ins)
destroy(this.rr_2)
end on

event open;call super::open;String sWcDscr

f_window_center(this)

is_itnbr = gs_gubun
is_opseq = gs_code

IF dw_1.Retrieve(is_itnbr, is_opseq) < 1		THEN
	dw_1.InsertRow(0)
	dw_1.SetItem(1,"itnbr",is_itnbr)
	dw_1.SetItem(1,"opseq",is_opseq)
	dw_1.SetItem(1,"itemas_itdsc",gs_codename)
	dw_1.SetItem(1,"routng_opdsc",gs_codename2)
END IF

//	gs_gubun  = sItnbr
//	gs_code	 = sOpseq
//	gs_codename = Trim(GetItemString(1, 'wkctr'))
//	gs_codename2 = Trim(GetItemString(1, 'wrkctr_wcdsc'))
//
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_pdm_01440_worktime
boolean visible = false
integer x = 2574
integer y = 1008
integer width = 1467
integer height = 196
boolean enabled = false
end type

type p_exit from w_inherite_popup`p_exit within w_pdm_01440_worktime
integer x = 1435
integer y = 4
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_codename2)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_pdm_01440_worktime
boolean visible = false
integer x = 2542
integer y = 692
boolean originalsize = false
end type

event p_inq::clicked;call super::clicked;long count

dw_1.Retrieve(is_pdtgu, is_itnbr, is_opseq)
dw_1.ScrollToRow(1)

FOR count = 1 TO dw_1.RowCount()
	dw_1.SetItem(count, "rowcount", String(count))
	dw_1.SelectRow(count,False)
NEXT 


end event

type p_choose from w_inherite_popup`p_choose within w_pdm_01440_worktime
boolean visible = false
integer x = 2542
integer y = 844
boolean enabled = false
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

IF dw_1.getitemstring(ll_row, "cvstatus") = '1' and  li_use <> -1 then //거래중지
   MessageBox("확 인", "거래중지인 자료는 선택할 수 없습니다.")
   return
END IF

gs_gubun= dw_1.GetItemString(ll_Row, "cvgu")
gs_code= dw_1.GetItemString(ll_Row, "cvcod")
gs_codename= dw_1.GetItemString(ll_row,"cvnas2")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_pdm_01440_worktime
integer x = 27
integer y = 180
integer width = 1586
integer height = 724
integer taborder = 40
string dataobject = "d_pdm_01440_worktime_1"
boolean vscrollbar = false
boolean livescroll = false
end type

event dw_1::updatestart;call super::updatestart;long		lcount

select count(*) 
into :lcount
from routng_settm
where itnbr = :is_itnbr
and	opseq = :is_opseq;

If lcount = 0 Then
	dw_1.SetItem(1, "crt_date", f_today())
	dw_1.SetItem(1, "crt_time", f_totime())
	dw_1.SetItem(1, "crt_user", gs_userid)
Else
	dw_1.SetItem(1, "upd_date", f_today())
	dw_1.SetItem(1, "upd_time", f_totime())
	dw_1.SetItem(1, "upd_user", gs_userid)
End If

end event

event dw_1::itemerror;call super::itemerror;return 1
end event

event dw_1::rowfocuschanged;//
//dw_1.SelectRow(0,False)
//dw_1.SelectRow(currentrow,True)
//
//dw_1.ScrollToRow(currentrow)
end event

event dw_1::clicked;//
end event

type sle_2 from w_inherite_popup`sle_2 within w_pdm_01440_worktime
integer x = 599
integer y = 2392
integer width = 1225
integer taborder = 30
end type

type cb_1 from w_inherite_popup`cb_1 within w_pdm_01440_worktime
boolean visible = false
integer x = 718
integer y = 2344
integer taborder = 50
boolean enabled = false
end type

type cb_return from w_inherite_popup`cb_return within w_pdm_01440_worktime
boolean visible = false
integer x = 1339
integer y = 2344
integer taborder = 70
boolean enabled = false
end type

type cb_inq from w_inherite_popup`cb_inq within w_pdm_01440_worktime
boolean visible = false
integer x = 1029
integer y = 2344
integer taborder = 60
boolean enabled = false
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_pdm_01440_worktime
integer x = 398
integer y = 2392
integer width = 197
integer taborder = 20
integer limit = 6
end type

type st_1 from w_inherite_popup`st_1 within w_pdm_01440_worktime
integer x = 69
integer y = 2408
integer width = 315
string text = "거래처코드"
end type

type p_mod from uo_picture within w_pdm_01440_worktime
integer x = 1257
integer y = 4
integer width = 178
integer height = 148
integer taborder = 40
boolean bringtotop = true
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event clicked;call super::clicked;//IF MessageBox("확인", "저장하시겠습니까?", question!, yesno!) = 2	THEN	RETURN

dw_1.acceptText()

//If dw_1.ModifiedCount() < 1 Then
//	MessageBox("확인","변경된 값이 없습니다.")
//	return
//End If

if dw_1.Update() > 0 then 
  	COMMIT USING sqlca;														 
else
	ROLLBACK USING SQLCA;
	f_rollback()
	return 
end if	

gs_gubun = 'OK'
gi_page = dw_1.GetItemNumber(1, 'stdst6') + dw_1.GetItemNumber(1, 'stdst7') + dw_1.GetItemNumber(1, 'stdst8')
Close(Parent)
end event

type p_del from uo_picture within w_pdm_01440_worktime
boolean visible = false
integer x = 901
integer y = 4
integer width = 178
integer taborder = 50
boolean bringtotop = true
string pointer = "C:\erpman\cur\delete.cur"
string picturename = "C:\erpman\image\삭제_up.gif"
end type

type p_1 from uo_picture within w_pdm_01440_worktime
integer x = 4411
integer y = 8
integer width = 178
integer taborder = 130
boolean bringtotop = true
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

type p_ins from uo_picture within w_pdm_01440_worktime
boolean visible = false
integer x = 718
integer y = 4
integer width = 178
integer taborder = 30
boolean bringtotop = true
string pointer = "C:\erpman\cur\add.cur"
string picturename = "C:\erpman\image\추가_up.gif"
end type

type rr_2 from roundrectangle within w_pdm_01440_worktime
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 172
integer width = 1609
integer height = 740
integer cornerheight = 40
integer cornerwidth = 55
end type

