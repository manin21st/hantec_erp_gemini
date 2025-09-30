$PBExportHeader$w_sm10_0070_1.srw
$PBExportComments$납품처재고 등록
forward
global type w_sm10_0070_1 from w_inherite_popup
end type
type hpb_1 from hprogressbar within w_sm10_0070_1
end type
type rb_1 from radiobutton within w_sm10_0070_1
end type
type rb_2 from radiobutton within w_sm10_0070_1
end type
end forward

global type w_sm10_0070_1 from w_inherite_popup
integer width = 1774
integer height = 924
string title = "실물재고 생성"
hpb_1 hpb_1
rb_1 rb_1
rb_2 rb_2
end type
global w_sm10_0070_1 w_sm10_0070_1

forward prototypes
public subroutine wf_conf ()
end prototypes

public subroutine wf_conf ();String ls_maxdt , ls_saupj

ls_saupj = Trim(dw_jogun.object.saupj[1])

IF rb_1.Checked Then

Select Max(crt_date) Into :ls_maxdt
  From stock_napum_jego
  where saupj = :ls_saupj
    and substr(vndcod,1,1) != 'M';

Else
	
Select Max(crt_date) Into :ls_maxdt
  From stock_napum_jego
  where saupj = :ls_saupj
    and substr(vndcod,1,1) = 'M';
	 
End iF
  
If sqlca.sqlcode <> 0 Then
	MessageBox('확인','최종 생성일자를 찾을 수 없습니다.')
	Return
End If
	
dw_jogun.object.edate[1] =ls_maxdt
end subroutine

on w_sm10_0070_1.create
int iCurrent
call super::create
this.hpb_1=create hpb_1
this.rb_1=create rb_1
this.rb_2=create rb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.hpb_1
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
end on

on w_sm10_0070_1.destroy
call super::destroy
destroy(this.hpb_1)
destroy(this.rb_1)
destroy(this.rb_2)
end on

event open;call super::open;dw_jogun.SetTransObject(SQLCA)
dw_jogun.InsertRow(0)
dw_jogun.object.sdate[1] =gs_code

setnull(gs_code)

If f_check_saupj() = 1 Then
	dw_jogun.SetItem(1, 'saupj', gs_code)
   if gs_code <> '%' then
   	dw_jogun.Modify("saupj.protect=1")
   End if
End If

wf_conf()
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_sm10_0070_1
integer width = 1733
integer height = 648
string dataobject = "d_sm10_0070_1_1"
boolean livescroll = false
end type

type p_exit from w_inherite_popup`p_exit within w_sm10_0070_1
integer x = 1554
end type

event p_exit::clicked;call super::clicked;Close(parent)
end event

type p_inq from w_inherite_popup`p_inq within w_sm10_0070_1
integer x = 1381
string picturename = "C:\erpman\image\생성_up.gif"
end type

event p_inq::ue_lbuttondown;//


end event

event p_inq::ue_lbuttonup;//
end event

event p_inq::clicked;call super::clicked;If dw_jogun.acceptText() < 1 Then return

String ls_saupj , ls_sdate ,ls_edate,ls_factory ,ls_itnbr
String ls_today , ls_totime
Long   ll_cnt , i ,ll_rcnt
Long   ll_jegoqty , ll_naqty , ll_silqty , ll_d0_qty , ll_d1_qty ,ll_d2_qty ,ll_d3_qty ,ll_ddqty

ls_saupj = Trim(dw_jogun.Object.saupj[1])
ls_sdate = Trim(dw_jogun.Object.sdate[1])
ls_edate = Trim(dw_jogun.Object.edate[1])

If ls_sdate = '' Or isNull(ls_sdate) Then
	f_message_chk(35,"[기준일자]")
	Return
End If

If ls_sdate = ls_edate Then
	MessageBox('확인','해당일자에 실물재고 생성이 이미 완료되었습니다. 재생성 불가능합니다.')
	Return
End iF

ls_today = f_today()
ls_totime = f_totime()

ll_rcnt = dw_1.Retrieve(ls_saupj , ls_edate , ls_sdate)

IF ll_rcnt > 0 Then
	IF rb_1.Checked Then
		dw_1.SetFilter("left(plant,1)<>'M'")
	Else
		dw_1.SetFilter("left(plant,1) = 'M'")
	End iF
	dw_1.Filter()
	dw_1.SetFilter("")
End IF

hpb_1.visible = True
hpb_1.maxposition =  100
hpb_1.setstep = 1
hpb_1.position = 0

ll_rcnt = dw_1.RowCount()

For i = 1 To ll_rcnt
	
	ls_factory = Trim(dw_1.Object.plant[i])
	ls_itnbr   = Trim(dw_1.Object.itnbr[i])
	ll_jegoqty = dw_1.Object.jego_qty[i]
	ll_naqty   = dw_1.Object.na_qty[i]
	ll_silqty  = dw_1.Object.sil_qty[i]
	
	
	ll_d0_qty  = dw_1.Object.d0[i]
	ll_d1_qty  = dw_1.Object.d1[i]
	ll_d2_qty  = dw_1.Object.d2[i]
	ll_d3_qty  = dw_1.Object.d3[i]
	
	ll_ddqty = ll_jegoqty
	ll_jegoqty = ll_jegoqty + ll_naqty - ll_silqty 
	ll_cnt = 0 
	
	Select Count(*) Into :ll_cnt 
	  FRom stock_napum_jego
	 where saupj = :ls_saupj
	   and vndcod = :ls_factory
		and itnbr = :ls_itnbr ;
		
   If ll_cnt < 1 Then

		
		Insert into stock_napum_jego (saupj , vndcod , itnbr ,
		                              dd_qty ,jego_qty , na_qty ,sil_qty , 
												d0_sqty ,d1_sqty   ,d2_sqty ,d3_sqty ,
												crt_date , crt_time , crt_user)
									  values(:ls_saupj ,:ls_factory , :ls_itnbr ,
									         :ll_ddqty , :ll_jegoqty , :ll_naqty ,:ll_silqty ,
												:ll_d0_qty , :ll_d1_qty , :ll_d2_qty ,:ll_d3_qty,
												:ls_today  , :ls_totime , :gs_userid) ;
		If sqlca.sqlcode <> 0 Then
			messageBox('1',sqlca.sqlerrText)
			Rollback;
			Return
		End If
	else
		Update stock_napum_jego Set dd_qty = :ll_ddqty ,
		                            jego_qty = :ll_jegoqty ,
											 na_qty = :ll_naqty ,
											 sil_qty = :ll_silqty ,
											 d0_sqty = :ll_d0_qty ,
											 d1_sqty = :ll_d1_qty ,
											 d2_sqty = :ll_d2_qty ,
											 d3_sqty = :ll_d3_qty ,
											 crt_date = :ls_today,
											 crt_time = :ls_totime,
											 crt_user = :gs_userid
									 where saupj = :ls_saupj
										and vndcod = :ls_factory
										and itnbr = :ls_itnbr ;
		If sqlca.sqlcode <> 0 Then
			messageBox('2',sqlca.sqlerrText)
			Rollback;
			Return
		End If
										
											 
	End If
	hpb_1.position = int((i/ll_rcnt)*100)
Next


Commit ;
hpb_1.visible = false
MessageBox('확인','재고 생성을 완료 하였습니다.')

p_exit.TriggerEvent(Clicked!)

												
end event

type p_choose from w_inherite_popup`p_choose within w_sm10_0070_1
boolean visible = false
integer x = 1381
end type

type dw_1 from w_inherite_popup`dw_1 within w_sm10_0070_1
boolean visible = false
integer x = 151
integer y = 32
integer width = 713
integer height = 104
string dataobject = "d_sm10_0070_1_2"
boolean resizable = true
end type

type sle_2 from w_inherite_popup`sle_2 within w_sm10_0070_1
end type

type cb_1 from w_inherite_popup`cb_1 within w_sm10_0070_1
end type

type cb_return from w_inherite_popup`cb_return within w_sm10_0070_1
end type

type cb_inq from w_inherite_popup`cb_inq within w_sm10_0070_1
end type

type sle_1 from w_inherite_popup`sle_1 within w_sm10_0070_1
end type

type st_1 from w_inherite_popup`st_1 within w_sm10_0070_1
end type

type hpb_1 from hprogressbar within w_sm10_0070_1
boolean visible = false
integer x = 142
integer y = 604
integer width = 1486
integer height = 80
boolean bringtotop = true
unsignedinteger maxposition = 100
unsignedinteger position = 50
integer setstep = 10
end type

type rb_1 from radiobutton within w_sm10_0070_1
integer x = 1065
integer y = 228
integer width = 279
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "현대"
boolean checked = true
end type

event clicked;wf_conf()
end event

type rb_2 from radiobutton within w_sm10_0070_1
integer x = 1376
integer y = 228
integer width = 279
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "모비스"
end type

event clicked;wf_conf()
end event

