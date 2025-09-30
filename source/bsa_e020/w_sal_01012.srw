$PBExportHeader$w_sal_01012.srw
$PBExportComments$ ===> 장기판매계획을 위한 전체 종업원수 등록
forward
global type w_sal_01012 from w_inherite
end type
type gb_3 from groupbox within w_sal_01012
end type
type gb_2 from groupbox within w_sal_01012
end type
type dw_update from u_key_enter within w_sal_01012
end type
type dw_copy from datawindow within w_sal_01012
end type
type st_gubun from statictext within w_sal_01012
end type
type dw_3 from datawindow within w_sal_01012
end type
type dw_2 from datawindow within w_sal_01012
end type
type rr_1 from roundrectangle within w_sal_01012
end type
end forward

global type w_sal_01012 from w_inherite
string title = "장기판매계획을 위한 전체 종업원수 등록"
gb_3 gb_3
gb_2 gb_2
dw_update dw_update
dw_copy dw_copy
st_gubun st_gubun
dw_3 dw_3
dw_2 dw_2
rr_1 rr_1
end type
global w_sal_01012 w_sal_01012

type variables
string is_year
end variables

on w_sal_01012.create
int iCurrent
call super::create
this.gb_3=create gb_3
this.gb_2=create gb_2
this.dw_update=create dw_update
this.dw_copy=create dw_copy
this.st_gubun=create st_gubun
this.dw_3=create dw_3
this.dw_2=create dw_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_3
this.Control[iCurrent+2]=this.gb_2
this.Control[iCurrent+3]=this.dw_update
this.Control[iCurrent+4]=this.dw_copy
this.Control[iCurrent+5]=this.st_gubun
this.Control[iCurrent+6]=this.dw_3
this.Control[iCurrent+7]=this.dw_2
this.Control[iCurrent+8]=this.rr_1
end on

on w_sal_01012.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_3)
destroy(this.gb_2)
destroy(this.dw_update)
destroy(this.dw_copy)
destroy(this.st_gubun)
destroy(this.dw_3)
destroy(this.dw_2)
destroy(this.rr_1)
end on

event open;call super::open;
PostEvent("ue_open")
end event

event ue_open;call super::ue_open;//*****************************************************************************//
//***  PGM NAME : 장기판매계획을 위한 월평균 종업원수 등록                  ***//
//***  PGM ID   : W_SAL_01012                                               ***//
//***  SUBJECT  : 장기판매계획 관련 출력물 출력시에 전체 종업원수를         ***//
//***             월평균 수로 하여 등록.                                    ***//
//*****************************************************************************//

dw_3.settransobject(sqlca)
dw_update.settransobject(sqlca)
dw_2.settransobject(sqlca)

dw_3.insertrow(0)
dw_update.insertrow(0)
dw_2.insertrow(0)
p_del.enabled= false
p_del.PictureName = 'C:\erpman\image\삭제_d.gif'
w_mdi_frame.sle_msg.text='수립년도를 입력하세요'

dw_2.setcolumn("sales_yy")
dw_2.setfocus()





end event

type dw_insert from w_inherite`dw_insert within w_sal_01012
integer x = 2149
integer y = 972
integer width = 809
integer height = 648
integer taborder = 10
string dataobject = "d_sal_01012_yuk"
end type

type p_delrow from w_inherite`p_delrow within w_sal_01012
boolean visible = false
integer x = 4114
integer y = 2680
end type

type p_addrow from w_inherite`p_addrow within w_sal_01012
boolean visible = false
integer x = 3941
integer y = 2680
end type

type p_search from w_inherite`p_search within w_sal_01012
boolean visible = false
integer x = 3246
integer y = 2680
end type

type p_ins from w_inherite`p_ins within w_sal_01012
boolean visible = false
integer x = 3767
integer y = 2680
end type

type p_exit from w_inherite`p_exit within w_sal_01012
end type

type p_can from w_inherite`p_can within w_sal_01012
end type

event p_can::clicked;call super::clicked;dw_2.reset()
dw_update.reset()
dw_3.reset()

dw_2.insertrow(0)
dw_3.insertrow(0)
dw_update.insertrow(0)

st_gubun.text=''
w_mdi_frame.sle_msg.text='수립년도를 입력하세요'
dw_2.setfocus()

p_del.enabled=false
p_del.PictureName = 'C:\erpman\image\삭제_d.gif'
end event

type p_print from w_inherite`p_print within w_sal_01012
boolean visible = false
integer x = 3419
integer y = 2680
end type

type p_inq from w_inherite`p_inq within w_sal_01012
integer x = 3749
end type

event p_inq::clicked;call super::clicked;string ls_salesyy,ls_year,ls_month,ls_jyear
integer li_cnt,li_month,li_cnt1
long la1,la2,la3,la4,la5,la6,la7,la8,la9

if dw_2.accepttext() < 1 then return

ls_salesyy=dw_2.getitemstring(1,'sales_yy')

//messagebox("", ls_salesyy)

if ls_salesyy = '' or isnull(ls_salesyy) then
	f_message_chk(35,'[수립년도]')
	dw_2.setcolumn("sales_yy")
	dw_2.setfocus()
	return 1
end if

setpointer(hourglass!)

//해당 수립년도의 종업원이 등록하는지 확인

select count(*) into :li_cnt from longplan
where sabu=:gs_sabu and setup_year = :ls_salesYY ;

ls_jyear=string(long(ls_salesyy) - 1) 

//전년도 종업원의 등록 확인
select count(*) into :li_cnt1 from longplan
where sabu=:gs_sabu and setup_year = : ls_jyear;

if li_cnt1=0 or isnull(li_cnt1) then
	if dw_update.retrieve(gs_sabu,ls_jyear) < 1 then
		dw_update.insertrow(0)
	   dw_update.setitem(1,'sabu',gs_sabu)
	   dw_update.setitem(1,'emp_cnt_1',0)
		dw_update.setitem(1,'emp_cnt_2',0)
		dw_update.setitem(1,'emp_cnt_3',0)
		dw_update.setitem(1,'emp_cnt_4',0)
		dw_update.setitem(1,'emp_cnt_5',0)
		dw_update.setitem(1,'emp_cnt_6',0)
		dw_update.setitem(1,'emp_cnt_7',0)
		dw_update.setitem(1,'emp_cnt_8',0)
		dw_update.setitem(1,'emp_cnt_9',0)
		dw_update.setitem(1,'emp_cnt_10',0)
		dw_update.object.setup_year[1]=ls_jyear
	end if
else
	dw_update.retrieve(gs_sabu,ls_jyear)
end if

if li_cnt=0 or isnull(li_cnt) then
	//존재 하지 않을 경우 신규등록
	messagebox('확인','해당 수립년도의 월 평균 종업원수 계획을 ' + ' ~r' + & 
	             '신규로 등록하세요')
	st_gubun.text='신규계획등록'
//	dw_3.setredraw(false)  //윈도우 디스플레이 화면제어
   
		if dw_3.retrieve(gs_sabu,ls_salesyy) < 1 then
			dw_3.insertrow(0)
//			messagebox("확인","전년도 종업원수 계획이 없습니다.")
      	dw_3.setitem(1,'sabu',gs_sabu)
			dw_3.setitem(1,'emp_cnt_1',0)
			dw_3.setitem(1,'emp_cnt_2',0)
			dw_3.setitem(1,'emp_cnt_3',0)
			dw_3.setitem(1,'emp_cnt_4',0)
			dw_3.setitem(1,'emp_cnt_5',0)
			dw_3.setitem(1,'emp_cnt_6',0)
			dw_3.setitem(1,'emp_cnt_7',0)
			dw_3.setitem(1,'emp_cnt_8',0)
			dw_3.setitem(1,'emp_cnt_9',0)
			dw_3.setitem(1,'emp_cnt_10',0)
			dw_3.object.setup_year[1]=ls_salesyy
	   
		end if
	
	dw_3.setcolumn('emp_cnt_5') 
	dw_3.setfocus()
	w_mdi_frame.sle_msg.text='종업원수 계획을 등록하세요'
	p_del.enabled=false
	p_del.PictureName = 'C:\erpman\image\삭제_d.gif'
	
	//dw_update 에서 값을 불러와서 dw_3 에 값을 넣는다.
	la1=dw_update.getitemnumber(1,'emp_cnt_2')
	la2=dw_update.getitemnumber(1,'emp_cnt_3')
	la3=dw_update.getitemnumber(1,'emp_cnt_4')
	la4=dw_update.getitemnumber(1,'emp_cnt_5')
	la5=dw_update.getitemnumber(1,'emp_cnt_6')
	la6=dw_update.getitemnumber(1,'emp_cnt_7')
	la7=dw_update.getitemnumber(1,'emp_cnt_8')
	la8=dw_update.getitemnumber(1,'emp_cnt_9')
	la9=dw_update.getitemnumber(1,'emp_cnt_10')

	dw_3.setitem(1,'emp_cnt_1',la1)
	dw_3.setitem(1,'emp_cnt_2',la2)
	dw_3.setitem(1,'emp_cnt_3',la3)
	dw_3.setitem(1,'emp_cnt_4',la4)
	dw_3.setitem(1,'emp_cnt_5',la5)
	dw_3.setitem(1,'emp_cnt_6',la6)
	dw_3.setitem(1,'emp_cnt_7',la7)
	dw_3.setitem(1,'emp_cnt_8',la8)
	dw_3.setitem(1,'emp_cnt_9',la9)
else
	//존재할 경우 수정
	messagebox('확인','해당 수립년도의 종업원수 계획이 ' + '~r' + &
	            '이미 수립되어 있습니다.' + '~r~r' + &
					                            '종업원수를 조정할수 있습니다.')
	st_gubun.text='수립계획조정'
	dw_3.retrieve(gs_sabu,ls_salesyy)
	w_mdi_frame.sle_msg.text='종업원수 계획을 조정하세요'
	dw_3.setcolumn('emp_cnt_5') 
	dw_3.setfocus()
	p_del.enabled=true
	p_del.PictureName = 'C:\erpman\image\삭제_up.gif'
end if





end event

type p_del from w_inherite`p_del within w_sal_01012
end type

event p_del::clicked;call super::clicked;string ls_year,ls_salesyy,lsyear
long la1
beep(1)

if messagebox("삭제확인","삭제하시겠습니까?",question!,yesno!,2) =2 then return

dw_2.accepttext()
ls_year=dw_2.getitemstring(1,'sales_yy')
la1=long(ls_year) -1
lsyear=string(la1)

//월평균 종업원 계획 해당년도 데이타 삭제
delete from longplan
where sabu=:gs_sabu  and setup_year = :ls_year;

if sqlca.sqlcode < 0 then
	f_message_chk(31,'[월평균종업원계획 삭제]');
	rollback;
	return
else
	commit ;
end if

p_inq.triggerevent(clicked!)	
end event

type p_mod from w_inherite`p_mod within w_sal_01012
end type

event p_mod::clicked;call super::clicked;dw_3.accepttext()
if dw_3.modifiedcount() > 0 then
	if dw_3.update()=1 then
		commit using sqlca;
		f_message_chk(202,'[월평균종업원계획 생성저장]')
	else
		rollback using sqlca;
		f_message_chk(32,'[월평균종업원계획 생성저장]')
	end if
end if

p_inq.triggerevent(clicked!)

end event

type cb_exit from w_inherite`cb_exit within w_sal_01012
integer x = 4069
integer y = 2536
integer taborder = 160
end type

type cb_mod from w_inherite`cb_mod within w_sal_01012
integer x = 2985
integer y = 2536
integer taborder = 90
end type

event cb_mod::clicked;call super::clicked;//dw_3.accepttext()
//if dw_3.modifiedcount() > 0 then
//	if dw_3.update()=1 then
//		commit using sqlca;
//		f_message_chk(202,'[월평균종업원계획 생성저장]')
//	else
//		rollback using sqlca;
//		f_message_chk(32,'[월평균종업원계획 생성저장]')
//	end if
//end if
//
//cb_inq.triggerevent(clicked!)
//
end event

type cb_ins from w_inherite`cb_ins within w_sal_01012
integer x = 2213
integer y = 2600
integer taborder = 70
end type

type cb_del from w_inherite`cb_del within w_sal_01012
integer x = 3346
integer y = 2536
integer taborder = 110
end type

event cb_del::clicked;call super::clicked;//string ls_year,ls_salesyy,lsyear
//long la1
//beep(1)
//
//if messagebox("삭제확인","삭제하시겠습니까?",question!,yesno!,2) =2 then return
//
//dw_2.accepttext()
//ls_year=dw_2.getitemstring(1,'sales_yy')
//la1=long(ls_year) -1
//lsyear=string(la1)
//
////월평균 종업원 계획 해당년도 데이타 삭제
//delete from longplan
//where sabu=:gs_sabu  and setup_year = :ls_year;
//
//if sqlca.sqlcode < 0 then
//	f_message_chk(31,'[월평균종업원계획 삭제]');
//	rollback;
//	return
//else
//	commit ;
//end if
//
//cb_inq.triggerevent(clicked!)	
end event

type cb_inq from w_inherite`cb_inq within w_sal_01012
integer x = 2811
integer y = 2772
integer taborder = 120
end type

event cb_inq::clicked;call super::clicked;//string ls_salesyy,ls_year,ls_month,ls_jyear
//integer li_cnt,li_month,li_cnt1
//long la1,la2,la3,la4,la5,la6,la7,la8,la9
//
//if dw_2.accepttext() < 1 then return
//
//ls_salesyy=dw_2.getitemstring(1,'sales_yy')
//
////messagebox("", ls_salesyy)
//
//if ls_salesyy = '' or isnull(ls_salesyy) then
//	f_message_chk(35,'[수립년도]')
//	dw_2.setcolumn("sales_yy")
//	dw_2.setfocus()
//	return 1
//end if
//
//setpointer(hourglass!)
//
////해당 수립년도의 종업원이 등록하는지 확인
//
//select count(*) into :li_cnt from longplan
//where sabu=:gs_sabu and setup_year = :ls_salesYY ;
//
//ls_jyear=string(long(ls_salesyy) - 1) 
//
////전년도 종업원의 등록 확인
//select count(*) into :li_cnt1 from longplan
//where sabu=:gs_sabu and setup_year = : ls_jyear;
//
//if li_cnt1=0 or isnull(li_cnt1) then
//	if dw_update.retrieve(gs_sabu,ls_jyear) < 1 then
//		dw_update.insertrow(0)
//	   dw_update.setitem(1,'sabu',gs_sabu)
//	   dw_update.setitem(1,'emp_cnt_1',0)
//		dw_update.setitem(1,'emp_cnt_2',0)
//		dw_update.setitem(1,'emp_cnt_3',0)
//		dw_update.setitem(1,'emp_cnt_4',0)
//		dw_update.setitem(1,'emp_cnt_5',0)
//		dw_update.setitem(1,'emp_cnt_6',0)
//		dw_update.setitem(1,'emp_cnt_7',0)
//		dw_update.setitem(1,'emp_cnt_8',0)
//		dw_update.setitem(1,'emp_cnt_9',0)
//		dw_update.setitem(1,'emp_cnt_10',0)
//		dw_update.object.setup_year[1]=ls_jyear
//	end if
//else
//	dw_update.retrieve(gs_sabu,ls_jyear)
//end if
//
//if li_cnt=0 or isnull(li_cnt) then
//	//존재 하지 않을 경우 신규등록
//	messagebox('확인','해당 수립년도의 월 평균 종업원수 계획을 ' + ' ~r' + & 
//	             '신규로 등록하세요')
//	st_gubun.text='신규계획등록'
////	dw_3.setredraw(false)  //윈도우 디스플레이 화면제어
//   
//		if dw_3.retrieve(gs_sabu,ls_salesyy) < 1 then
//			dw_3.insertrow(0)
////			messagebox("확인","전년도 종업원수 계획이 없습니다.")
//      	dw_3.setitem(1,'sabu',gs_sabu)
//			dw_3.setitem(1,'emp_cnt_1',0)
//			dw_3.setitem(1,'emp_cnt_2',0)
//			dw_3.setitem(1,'emp_cnt_3',0)
//			dw_3.setitem(1,'emp_cnt_4',0)
//			dw_3.setitem(1,'emp_cnt_5',0)
//			dw_3.setitem(1,'emp_cnt_6',0)
//			dw_3.setitem(1,'emp_cnt_7',0)
//			dw_3.setitem(1,'emp_cnt_8',0)
//			dw_3.setitem(1,'emp_cnt_9',0)
//			dw_3.setitem(1,'emp_cnt_10',0)
//			dw_3.object.setup_year[1]=ls_salesyy
//	   
//		end if
//	
//	dw_3.setcolumn('emp_cnt_5') 
//	dw_3.setfocus()
//	sle_msg.text='종업원수 계획을 등록하세요'
//	cb_del.enabled=false
//	
//	//dw_update 에서 값을 불러와서 dw_3 에 값을 넣는다.
//	la1=dw_update.getitemnumber(1,'emp_cnt_2')
//	la2=dw_update.getitemnumber(1,'emp_cnt_3')
//	la3=dw_update.getitemnumber(1,'emp_cnt_4')
//	la4=dw_update.getitemnumber(1,'emp_cnt_5')
//	la5=dw_update.getitemnumber(1,'emp_cnt_6')
//	la6=dw_update.getitemnumber(1,'emp_cnt_7')
//	la7=dw_update.getitemnumber(1,'emp_cnt_8')
//	la8=dw_update.getitemnumber(1,'emp_cnt_9')
//	la9=dw_update.getitemnumber(1,'emp_cnt_10')
//
//	dw_3.setitem(1,'emp_cnt_1',la1)
//	dw_3.setitem(1,'emp_cnt_2',la2)
//	dw_3.setitem(1,'emp_cnt_3',la3)
//	dw_3.setitem(1,'emp_cnt_4',la4)
//	dw_3.setitem(1,'emp_cnt_5',la5)
//	dw_3.setitem(1,'emp_cnt_6',la6)
//	dw_3.setitem(1,'emp_cnt_7',la7)
//	dw_3.setitem(1,'emp_cnt_8',la8)
//	dw_3.setitem(1,'emp_cnt_9',la9)
//else
//	//존재할 경우 수정
//	messagebox('확인','해당 수립년도의 종업원수 계획이 ' + '~r' + &
//	            '이미 수립되어 있습니다.' + '~r~r' + &
//					                            '종업원수를 조정할수 있습니다.')
//	st_gubun.text='수립계획조정'
//	dw_3.retrieve(gs_sabu,ls_salesyy)
//	sle_msg.text='종업원수 계획을 조정하세요'
//	dw_3.setcolumn('emp_cnt_5') 
//	dw_3.setfocus()
//	cb_del.enabled=true
//end if
//
//
//
//
//
end event

type cb_print from w_inherite`cb_print within w_sal_01012
integer x = 2551
integer y = 2592
integer taborder = 130
end type

type st_1 from w_inherite`st_1 within w_sal_01012
end type

type cb_can from w_inherite`cb_can within w_sal_01012
integer x = 3707
integer y = 2536
integer taborder = 140
end type

event cb_can::clicked;call super::clicked;//dw_2.reset()
//dw_update.reset()
//dw_3.reset()
//
//dw_2.insertrow(0)
//dw_3.insertrow(0)
//dw_update.insertrow(0)
//
//st_gubun.text=''
//sle_msg.text='수립년도를 입력하세요'
//dw_2.setfocus()
//
//cb_del.enabled=false
end event

type cb_search from w_inherite`cb_search within w_sal_01012
integer x = 2249
integer y = 2716
integer taborder = 150
end type







type gb_button1 from w_inherite`gb_button1 within w_sal_01012
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_01012
end type

type gb_3 from groupbox within w_sal_01012
boolean visible = false
integer x = 2779
integer y = 2708
integer width = 411
integer height = 204
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_2 from groupbox within w_sal_01012
boolean visible = false
integer x = 2944
integer y = 2472
integer width = 1490
integer height = 204
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
end type

type dw_update from u_key_enter within w_sal_01012
integer x = 654
integer y = 384
integer width = 1362
integer height = 1552
integer taborder = 40
string dataobject = "d_sal_01012_yuk2"
boolean border = false
end type

type dw_copy from datawindow within w_sal_01012
boolean visible = false
integer x = 233
integer y = 2568
integer width = 1883
integer height = 360
integer taborder = 170
boolean bringtotop = true
string dataobject = "d_sal_01012_03"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_gubun from statictext within w_sal_01012
integer x = 1518
integer y = 164
integer width = 425
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 15780518
boolean enabled = false
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type dw_3 from datawindow within w_sal_01012
event ue_keydown pbm_dwnprocessenter
integer x = 2025
integer y = 384
integer width = 1362
integer height = 1552
integer taborder = 100
boolean bringtotop = true
string dataobject = "d_sal_01012_yuk"
boolean border = false
boolean livescroll = true
end type

event ue_keydown;Send(Handle(this),256,9,0)
Return 1
end event

type dw_2 from datawindow within w_sal_01012
event ue_processenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 635
integer y = 116
integer width = 1413
integer height = 168
integer taborder = 80
string dataobject = "d_sal_01010_01"
boolean border = false
boolean livescroll = true
end type

event itemchanged;call super::itemchanged;if keydown(keyenter!) then
	p_inq.triggerevent(clicked!)
end if


end event

type rr_1 from roundrectangle within w_sal_01012
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 640
integer y = 360
integer width = 2821
integer height = 1644
integer cornerheight = 40
integer cornerwidth = 55
end type

