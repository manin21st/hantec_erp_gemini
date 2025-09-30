$PBExportHeader$w_kfab99.srw
$PBExportComments$월 자동감가상각처리
forward
global type w_kfab99 from window
end type
type st_6 from statictext within w_kfab99
end type
type st_5 from statictext within w_kfab99
end type
type p_exit from uo_picture within w_kfab99
end type
type p_search from uo_picture within w_kfab99
end type
type cb_exit from commandbutton within w_kfab99
end type
type sle_1 from singlelineedit within w_kfab99
end type
type st_2 from statictext within w_kfab99
end type
type dw_datetime from datawindow within w_kfab99
end type
type em_ymd from editmask within w_kfab99
end type
type st_1 from statictext within w_kfab99
end type
type cb_inq from commandbutton within w_kfab99
end type
type gb_2 from groupbox within w_kfab99
end type
type gb_1 from groupbox within w_kfab99
end type
type gb_3 from groupbox within w_kfab99
end type
type rr_1 from roundrectangle within w_kfab99
end type
end forward

global type w_kfab99 from window
integer width = 4658
integer height = 3584
boolean titlebar = true
string title = "월자동감가상각 처리"
string menuname = "m_shortcut"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 32106727
st_6 st_6
st_5 st_5
p_exit p_exit
p_search p_search
cb_exit cb_exit
sle_1 sle_1
st_2 st_2
dw_datetime dw_datetime
em_ymd em_ymd
st_1 st_1
cb_inq cb_inq
gb_2 gb_2
gb_1 gb_1
gb_3 gb_3
rr_1 rr_1
end type
global w_kfab99 w_kfab99

type variables
Boolean ib_any_typing     
String	is_window_id
String     is_today              //시작일자
String     is_totime             //시작시간
String     sModStatus
String     is_usegub           //이력관리 여부
end variables

event open;ListviewItem		lvi_Current
lvi_Current.Data = Upper(This.ClassName())
lvi_Current.Label = Trim(This.Title)
lvi_Current.PictureIndex = 1

w_mdi_frame.lv_open_menu.additem(lvi_Current)

is_window_id = this.ClassName()
is_today = f_today()
is_totime = f_totime()
w_mdi_frame.st_window.Text = Upper(is_window_id)

SELECT "SUB2_T"."OPEN_HISTORY"  
  INTO :is_usegub 
  FROM "SUB2_T"  
 WHERE "SUB2_T"."WINDOW_NAME" = :is_window_id   ;

IF is_usegub = 'Y' THEN
   INSERT INTO "PGM_HISTORY"  
	 		 ( "L_USERID",   "CDATE",       "STIME",      "WINDOW_NAME",   "EDATE",   
			   "ETIME",      "IPADD",       "USER_NAME" )  
   VALUES ( :gs_userid,   :is_today,     :is_totime,   :is_window_id,   NULL, 
	   		NULL,         :gs_ipaddress, :gs_comname )  ;

   IF SQLCA.SQLCODE = 0 THEN 
	   COMMIT;
   ELSE 	  
	   ROLLBACK;
   END IF	  
END IF

dw_datetime.settransobject(sqlca)
dw_datetime.InsertRow(0)

em_ymd.text = String(Today(),"yyyymmdd")




end event

on w_kfab99.create
if this.MenuName = "m_shortcut" then this.MenuID = create m_shortcut
this.st_6=create st_6
this.st_5=create st_5
this.p_exit=create p_exit
this.p_search=create p_search
this.cb_exit=create cb_exit
this.sle_1=create sle_1
this.st_2=create st_2
this.dw_datetime=create dw_datetime
this.em_ymd=create em_ymd
this.st_1=create st_1
this.cb_inq=create cb_inq
this.gb_2=create gb_2
this.gb_1=create gb_1
this.gb_3=create gb_3
this.rr_1=create rr_1
this.Control[]={this.st_6,&
this.st_5,&
this.p_exit,&
this.p_search,&
this.cb_exit,&
this.sle_1,&
this.st_2,&
this.dw_datetime,&
this.em_ymd,&
this.st_1,&
this.cb_inq,&
this.gb_2,&
this.gb_1,&
this.gb_3,&
this.rr_1}
end on

on w_kfab99.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_6)
destroy(this.st_5)
destroy(this.p_exit)
destroy(this.p_search)
destroy(this.cb_exit)
destroy(this.sle_1)
destroy(this.st_2)
destroy(this.dw_datetime)
destroy(this.em_ymd)
destroy(this.st_1)
destroy(this.cb_inq)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.gb_3)
destroy(this.rr_1)
end on

event closequery;string s_frday, s_frtime

IF is_usegub = 'Y' THEN
	s_frday = f_today()
	
	s_frtime = f_totime()

   UPDATE "PGM_HISTORY"  
      SET "EDATE" = :s_frday,   
          "ETIME" = :s_frtime  
    WHERE ( "PGM_HISTORY"."L_USERID" = :gs_userid ) AND  
          ( "PGM_HISTORY"."CDATE" = :is_today ) AND  
          ( "PGM_HISTORY"."STIME" = :is_totime ) AND  
          ( "PGM_HISTORY"."WINDOW_NAME" = :is_window_id )   ;

	IF SQLCA.SQLCODE = 0 THEN 
	   COMMIT;
   ELSE 	  
	   ROLLBACK;
   END IF	  
END IF	  

long li_index

li_index = w_mdi_frame.lv_open_menu.FindItem(0,This.Title, TRUE,TRUE)

w_mdi_frame.lv_open_menu.DeleteItem(li_index)
w_mdi_frame.st_window.Text = ""
end event

event key;Choose Case key
	Case KeyR!
		p_search.TriggerEvent(Clicked!)
	Case KeyX!
		p_exit.TriggerEvent(Clicked!)
End Choose
end event

event mousemove;if p_search.PictureName = 'C:\erpman\image\처리_over.gif' then
	p_search.PictureName = 'C:\erpman\image\처리_up.gif'
end If

if p_exit.PictureName = 'C:\erpman\image\닫기_over.gif' then
	p_exit.PictureName = 'C:\erpman\image\닫기_up.gif'
end If


end event

type st_6 from statictext within w_kfab99
integer x = 791
integer y = 1344
integer width = 3269
integer height = 48
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 28144969
long backcolor = 32106727
string text = "2. 회기말 년월로 상각처리시 1년 상각비의 차액만을 말월로 계산한다"
boolean focusrectangle = false
end type

type st_5 from statictext within w_kfab99
integer x = 791
integer y = 1276
integer width = 3269
integer height = 48
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 28144969
long backcolor = 32106727
string text = "1. 월 추정상각 및 12월 실제 상각계산을 수행하여 월,년 감가상각액을 고정자산 잔고파일로 갱신 처리한다."
boolean focusrectangle = false
end type

type p_exit from uo_picture within w_kfab99
integer x = 4402
integer y = 24
integer width = 178
integer taborder = 50
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;w_mdi_frame.sle_msg.text =""
//IF wf_warndataloss("종료") = -1 THEN  	RETURN

close(parent)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type p_search from uo_picture within w_kfab99
integer x = 4224
integer y = 24
integer width = 178
integer taborder = 60
string picturename = "C:\Erpman\image\처리_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

Integer iRtnValue
String  sYearMonthDay,sKfYear

sYearMonthDay = Left(Trim(Em_ymd.text),4)+Mid(Trim(Em_ymd.text),6,2)

SELECT "KFA07OM0"."KFYEAR"    INTO :sKfYear
  FROM "KFA07OM0"  ;

if Left(sYearMonthDay,4) <> sKfYear Then
   Messagebox("확 인","고정자산 회기년도와 같지 않습니다. !")
   em_ymd.SetFocus()
   return
end if

sYearMonthDay = F_Last_Date(Left(Trim(Em_ymd.text),4)+Mid(Trim(Em_ymd.text),6,2))
if f_DateChk(sYearMonthDay) =-1 Then
   Messagebox("확 인","자동감가상각년월이 유효하지 않습니다...")
   em_ymd.SetFocus()
   return
end if

SetPointer(HourGlass!)

w_mdi_frame.sle_msg.Text = '월 자동 감가 상각 처리 중...'
iRtnValue = Sqlca.fun_calc_depreciation(sYearMonthDay)

IF iRtnValue = 0 then
	F_Messagechk(59,'')
	SetPointer(Arrow!)
	w_mdi_frame.sle_msg.Text = ''
	Rollback;
	Return
ELSEIF iRtnValue = -1 then
	F_Messagechk(13,'[감가상각 처리 내역]')
	SetPointer(Arrow!)
	w_mdi_frame.sle_msg.Text = ''
	Rollback;
	Return
ELSEIF iRtnValue = -2 then
	F_Messagechk(13,'[고정자산 잔고]')
	SetPointer(Arrow!)
	w_mdi_frame.sle_msg.Text = ''
	Rollback;
	Return
ELSEIF iRtnValue = -3 then
	F_Messagechk(13,'[변동 내역]')
	SetPointer(Arrow!)
	w_mdi_frame.sle_msg.Text = ''
	Rollback;
	Return
ELSE
	Commit;
END IF

SetPointer(Arrow!)
w_mdi_frame.sle_msg.Text = '월 자동 감가 상각 처리 완료'
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\Erpman\image\처리_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\Erpman\image\처리_up.gif"
end event

type cb_exit from commandbutton within w_kfab99
boolean visible = false
integer x = 3986
integer y = 2788
integer width = 329
integer height = 108
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "종료(&X)"
end type

event clicked;close(parent)
end event

type sle_1 from singlelineedit within w_kfab99
boolean visible = false
integer x = 325
integer y = 2796
integer width = 2523
integer height = 84
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12632256
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_kfab99
boolean visible = false
integer x = 32
integer y = 2796
integer width = 288
integer height = 84
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 12632256
boolean enabled = false
string text = "메세지"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type dw_datetime from datawindow within w_kfab99
boolean visible = false
integer x = 2848
integer y = 2796
integer width = 745
integer height = 88
string dataobject = "d_datetime"
boolean border = false
boolean livescroll = true
end type

type em_ymd from editmask within w_kfab99
integer x = 2341
integer y = 656
integer width = 434
integer height = 92
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
alignment alignment = center!
maskdatatype maskdatatype = stringmask!
string mask = "####.##"
boolean autoskip = true
end type

type st_1 from statictext within w_kfab99
integer x = 1696
integer y = 672
integer width = 631
integer height = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
boolean enabled = false
string text = "자동감가상각년월"
alignment alignment = center!
long bordercolor = 16711935
boolean focusrectangle = false
end type

type cb_inq from commandbutton within w_kfab99
boolean visible = false
integer x = 3625
integer y = 2788
integer width = 329
integer height = 108
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "처리(&P)"
boolean default = true
end type

event clicked;Integer iRtnValue
String  sYearMonthDay,sKfYear

sYearMonthDay = Left(Trim(Em_ymd.text),4)+Mid(Trim(Em_ymd.text),6,2)

SELECT "KFA07OM0"."KFYEAR"    INTO :sKfYear
  FROM "KFA07OM0"  ;

if Left(sYearMonthDay,4) <> sKfYear Then
   Messagebox("확 인","고정자산 회기년도와 같지 않습니다. !")
   em_ymd.SetFocus()
   return
end if

sYearMonthDay = F_Last_Date(Left(Trim(Em_ymd.text),4)+Mid(Trim(Em_ymd.text),6,2))
if f_DateChk(sYearMonthDay) =-1 Then
   Messagebox("확 인","자동감가상각년월이 유효하지 않습니다...")
   em_ymd.SetFocus()
   return
end if

SetPointer(HourGlass!)

sle_1.Text = '월 자동 감가 상각 처리 중...'
iRtnValue = Sqlca.fun_calc_depreciation(sYearMonthDay)

IF iRtnValue = 0 then
	F_Messagechk(59,'')
	SetPointer(Arrow!)
	sle_1.Text = ''
	Rollback;
	Return
ELSEIF iRtnValue = -1 then
	F_Messagechk(13,'[감가상각 처리 내역]')
	SetPointer(Arrow!)
	sle_1.Text = ''
	Rollback;
	Return
ELSEIF iRtnValue = -2 then
	F_Messagechk(13,'[고정자산 잔고]')
	SetPointer(Arrow!)
	sle_1.Text = ''
	Rollback;
	Return
ELSEIF iRtnValue = -3 then
	F_Messagechk(13,'[변동 내역]')
	SetPointer(Arrow!)
	sle_1.Text = ''
	Rollback;
	Return
ELSE
	Commit;
END IF

SetPointer(Arrow!)
sle_1.Text = '월 자동 감가 상각 처리 완료'
end event

type gb_2 from groupbox within w_kfab99
boolean visible = false
integer x = 3584
integer y = 2740
integer width = 768
integer height = 180
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_kfab99
boolean visible = false
integer x = 14
integer y = 2752
integer width = 3593
integer height = 140
integer taborder = 40
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12632256
end type

type gb_3 from groupbox within w_kfab99
integer x = 677
integer y = 1184
integer width = 3465
integer height = 296
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
end type

type rr_1 from roundrectangle within w_kfab99
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 581
integer y = 384
integer width = 3671
integer height = 1512
integer cornerheight = 40
integer cornerwidth = 55
end type

