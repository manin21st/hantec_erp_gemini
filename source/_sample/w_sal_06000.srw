$PBExportHeader$w_sal_06000.srw
$PBExportComments$환율등록
forward
global type w_sal_06000 from w_inherite
end type
type dw_jogun from datawindow within w_sal_06000
end type
type pb_1 from u_pb_cal within w_sal_06000
end type
type rr_1 from roundrectangle within w_sal_06000
end type
end forward

global type w_sal_06000 from w_inherite
string title = "환율 등록"
dw_jogun dw_jogun
pb_1 pb_1
rr_1 rr_1
end type
global w_sal_06000 w_sal_06000

on w_sal_06000.create
int iCurrent
call super::create
this.dw_jogun=create dw_jogun
this.pb_1=create pb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_jogun
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.rr_1
end on

on w_sal_06000.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_jogun)
destroy(this.pb_1)
destroy(this.rr_1)
end on

event open;call super::open;dw_insert.SetTransObject(sqlca)
dw_jogun.InsertRow(0)
TriggerEvent('ue_open')


end event

event ue_open;call super::ue_open;ib_any_typing =False
dw_jogun.SetItem(1,'date', f_today())
cb_inq.Post PostEvent(Clicked!)
end event

type dw_insert from w_inherite`dw_insert within w_sal_06000
integer x = 50
integer y = 216
integer width = 4549
integer height = 2096
integer taborder = 20
string dataobject = "d_sal_06000"
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemchanged;String sCurr
Long   nRow, cRow , ll_count ,i , ll_rstan 
Double dRstan, dUsd

nRow = GetRow()
If nRow <= 0 Then Return

sCurr = GetItemString(nRow, 'rcurr')

Choose Case GetColumnName()
	/* 기준환율 */
	Case 'rstan'
		dRstan = Double(GetText())
		
		/* 대미환산율 계산 */
		If sCurr = 'USD' Then
			ll_count = this.rowcount()
			
			for i = 1 to ll_count
				ll_rstan = this.getitemnumber(i,'rstan')
				this.setitem(i,'usdrat',round(ll_rstan/drstan,4))
			next
			SetItem(nRow, 'usdrat',1)
		Else
			cRow = Find("rcurr = 'USD'",1, RowCount())
			If cRow > 0 Then
				dUsd = GetItemNumber(cRow, 'rstan')
				If IsNull(dUsd) Then dUsd = 0
				
				If dUsd > 0 Then SetItem(nRow, 'usdrat', Round(dRstan/dUsd,4))
			End If
		End If
End Choose
end event

event dw_insert::itemerror;Return 1
end event

type p_delrow from w_inherite`p_delrow within w_sal_06000
boolean visible = false
integer x = 1531
integer y = 2588
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_sal_06000
boolean visible = false
integer x = 1358
integer y = 2588
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_sal_06000
boolean visible = false
integer x = 1001
integer y = 2604
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_sal_06000
integer x = 3749
end type

event p_ins::clicked;call super::clicked;string sdate
int    rcnt,row

IF dw_jogun.AcceptText() = -1 THEN Return

sdate = Trim(dw_jogun.GetItemString(1, 'date'))
If f_datechk(sdate) = -1 Then
   f_message_chk(40,'[일자 오류]')
	Return
End If

// 일자 setting후 New! 상태로...
row = dw_insert.InsertRow(0)
dw_insert.SetItem(row,'rdate',sdate)
dw_insert.SetItemStatus(row, 0,Primary!, NotModified!)
dw_insert.SetItemStatus(row, 0,Primary!, New!)
dw_insert.SetFocus()
dw_insert.SetRow(row)
dw_insert.SetColumn('rcurr')

dw_jogun.Enabled = False   // 추가중 일자변경 불가
end event

type p_exit from w_inherite`p_exit within w_sal_06000
end type

type p_can from w_inherite`p_can within w_sal_06000
end type

event p_can::clicked;call super::clicked;dw_jogun.Enabled = True
dw_jogun.SetFocus()

dw_insert.Reset()

end event

type p_print from w_inherite`p_print within w_sal_06000
boolean visible = false
integer x = 1175
integer y = 2604
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_sal_06000
integer x = 3575
end type

event p_inq::clicked;call super::clicked;string sdate

IF dw_jogun.AcceptText() = -1 THEN Return

sdate = Trim(dw_jogun.GetItemString(1, 'date'))

If sdate = '' Or IsNull(sdate) Then Return

If f_datechk(sdate) = -1 Then
   f_message_chk(40,'[일자/ 오류]')
	dw_jogun.SetFocus()
	Return
End If

If dw_insert.Retrieve(sdate) > 0 Then	
	dw_jogun.Enabled = False
Else
	sle_msg.Text = '조회된 건수가 없습니다.!!'
End If



end event

type p_del from w_inherite`p_del within w_sal_06000
end type

event p_del::clicked;call super::clicked;/*-------------------------*/
/* 통화 개별 단위 삭제     */
/*-------------------------*/

string sdate,scurr
int    row

IF dw_jogun.AcceptText() = -1 THEN Return

sdate = Trim(dw_jogun.GetItemString(1, 'date'))

If dw_insert.RowCount() > 0 Then
	row   = dw_insert.GetRow()
	scurr = dw_insert.GetItemSTring(row,'rcurr')
   IF MessageBox("삭 제",String(sdate, '@@@@.@@.@@') + "의 " + scurr +"가 삭제됩니다." +"~n~n" +&
                     	 "삭제 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN RETURN
     
	If dw_insert.DeleteRow(row)  = 1 Then
		If dw_insert.Update() = 1 Then
		   commit;
		   sle_msg.text =	"자료를 삭제하였습니다!!"	
	   Else
		   Rollback ;
	   End If		
	End If	
   cb_inq.PostEvent(Clicked!)
End If

end event

type p_mod from w_inherite`p_mod within w_sal_06000
end type

event p_mod::clicked;call super::clicked;if dw_insert.AcceptText() = -1 then return 

if dw_insert.update() = 1 then
	sle_msg.text =	"자료를 저장하였습니다!!"			
	ib_any_typing = false
	commit ;
else
	rollback ;
	return 
end if

end event

type cb_exit from w_inherite`cb_exit within w_sal_06000
integer x = 2569
integer y = 2612
boolean enabled = false
end type

type cb_mod from w_inherite`cb_mod within w_sal_06000
integer x = 1513
integer y = 2612
integer taborder = 50
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within w_sal_06000
integer x = 887
integer y = 2612
integer taborder = 30
boolean enabled = false
string text = "추가(&I)"
end type

type cb_del from w_inherite`cb_del within w_sal_06000
integer x = 1865
integer y = 2612
integer taborder = 60
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_sal_06000
integer x = 526
integer y = 2612
boolean enabled = false
end type

type cb_print from w_inherite`cb_print within w_sal_06000
integer x = 1765
integer y = 2748
integer taborder = 100
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_sal_06000
end type

type cb_can from w_inherite`cb_can within w_sal_06000
integer x = 2217
integer y = 2612
integer taborder = 70
boolean enabled = false
end type

type cb_search from w_inherite`cb_search within w_sal_06000
integer x = 2487
integer y = 2748
integer taborder = 110
boolean enabled = false
end type







type gb_button1 from w_inherite`gb_button1 within w_sal_06000
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_06000
end type

type dw_jogun from datawindow within w_sal_06000
integer x = 18
integer y = 44
integer width = 1120
integer height = 148
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_sal_06000_1"
boolean border = false
boolean livescroll = true
end type

type pb_1 from u_pb_cal within w_sal_06000
integer x = 599
integer y = 76
integer width = 78
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_jogun.SetColumn('date')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_jogun.SetItem(1, 'date', gs_code)

end event

type rr_1 from roundrectangle within w_sal_06000
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 204
integer width = 4576
integer height = 2116
integer cornerheight = 40
integer cornerwidth = 55
end type

