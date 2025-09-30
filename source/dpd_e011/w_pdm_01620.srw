$PBExportHeader$w_pdm_01620.srw
$PBExportComments$달력수정
forward
global type w_pdm_01620 from window
end type
type st_4 from statictext within w_pdm_01620
end type
type st_3 from statictext within w_pdm_01620
end type
type st_2 from statictext within w_pdm_01620
end type
type st_1 from statictext within w_pdm_01620
end type
type p_2 from uo_picture within w_pdm_01620
end type
type p_1 from uo_picture within w_pdm_01620
end type
type p_exit from uo_picture within w_pdm_01620
end type
type p_can from uo_picture within w_pdm_01620
end type
type p_mod from uo_picture within w_pdm_01620
end type
type cb_wrk_process from commandbutton within w_pdm_01620
end type
type uo_2 from u_progress_bar within w_pdm_01620
end type
type dw_detail from datawindow within w_pdm_01620
end type
type uo_1 from u_ddcal within w_pdm_01620
end type
type dw_1 from datawindow within w_pdm_01620
end type
type rr_3 from roundrectangle within w_pdm_01620
end type
end forward

global type w_pdm_01620 from window
integer width = 4663
integer height = 2528
boolean titlebar = true
string title = "근무일력 수정"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
long backcolor = 32106727
st_4 st_4
st_3 st_3
st_2 st_2
st_1 st_1
p_2 p_2
p_1 p_1
p_exit p_exit
p_can p_can
p_mod p_mod
cb_wrk_process cb_wrk_process
uo_2 uo_2
dw_detail dw_detail
uo_1 uo_1
dw_1 dw_1
rr_3 rr_3
end type
global w_pdm_01620 w_pdm_01620

type variables
boolean b_check1 = false,   & 
              b_check2 = false,   &
              b_check3 = false,   & 
              b_check4 = false        

string  colname1[4] = {'overyn', 'nightyn','alnight','extra'}
string  colname2[4] = {'rate1', 'rate2','rate3','rate4'}

String     is_today              //시작일자
String     is_totime             //시작시간
String     is_window_id      //윈도우 ID
String     is_usegub           //이력관리 여부
end variables

event open;Integer  li_idx

li_idx = w_mdi_frame.dw_listbar.InsertRow(0)
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_id',Upper(This.ClassName()))
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_name',Upper(This.Title))
w_mdi_frame.Postevent("ue_barrefresh")

is_today = f_today()
is_totime = f_totime()
is_window_id = this.ClassName()

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

dw_detail.settransobject(sqlca)
dw_1.insertrow(0)

uo_1.init_cal(today())

string 	date_format
date_format = "yyyy/mm/dd"
uo_1.set_date_format ( date_format )
uo_1.fu_init_datawindow(dw_detail)

dw_detail.retrieve(is_today)

dw_1.setitem(1, 'fdate', left(is_today, 6))
dw_1.setitem(1, 'tdate', left(is_today, 4) + '12' )


end event

on w_pdm_01620.create
this.st_4=create st_4
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.p_2=create p_2
this.p_1=create p_1
this.p_exit=create p_exit
this.p_can=create p_can
this.p_mod=create p_mod
this.cb_wrk_process=create cb_wrk_process
this.uo_2=create uo_2
this.dw_detail=create dw_detail
this.uo_1=create uo_1
this.dw_1=create dw_1
this.rr_3=create rr_3
this.Control[]={this.st_4,&
this.st_3,&
this.st_2,&
this.st_1,&
this.p_2,&
this.p_1,&
this.p_exit,&
this.p_can,&
this.p_mod,&
this.cb_wrk_process,&
this.uo_2,&
this.dw_detail,&
this.uo_1,&
this.dw_1,&
this.rr_3}
end on

on w_pdm_01620.destroy
destroy(this.st_4)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.p_2)
destroy(this.p_1)
destroy(this.p_exit)
destroy(this.p_can)
destroy(this.p_mod)
destroy(this.cb_wrk_process)
destroy(this.uo_2)
destroy(this.dw_detail)
destroy(this.uo_1)
destroy(this.dw_1)
destroy(this.rr_3)
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

w_mdi_frame.st_window.Text = ''

long li_index

li_index = w_mdi_frame.dw_listbar.Find("window_id = '" + Upper(This.ClassName()) + "'", 1, w_mdi_frame.dw_listbar.RowCount())

w_mdi_frame.dw_listbar.DeleteRow(li_index)
w_mdi_frame.Postevent("ue_barrefresh")
end event

type st_4 from statictext within w_pdm_01620
integer x = 791
integer y = 2188
integer width = 2647
integer height = 52
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "- 처리가 끝난 후 개별 작업장 근무일에 대한 부하시간 정의는 <작업장등록> 프로그램을 이용하십시오."
boolean focusrectangle = false
end type

type st_3 from statictext within w_pdm_01620
integer x = 791
integer y = 2120
integer width = 2126
integer height = 52
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "- POP Work Calendar 를 먼저 정의한 후 <작업장일력재생성> 버튼을 클릭하십시오."
boolean focusrectangle = false
end type

type st_2 from statictext within w_pdm_01620
integer x = 791
integer y = 2052
integer width = 2016
integer height = 52
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "- POP Work Calendar 를 기준으로 요일별 부하시간을 생성 또는 재생성합니다."
boolean focusrectangle = false
end type

type st_1 from statictext within w_pdm_01620
integer x = 763
integer y = 1928
integer width = 946
integer height = 52
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "※ 작업장 근무일력 재생성 처리"
boolean focusrectangle = false
end type

type p_2 from uo_picture within w_pdm_01620
integer x = 3749
integer y = 20
integer width = 306
integer taborder = 60
string pointer = "C:\erpman\cur\Point.cur"
boolean originalsize = true
string picturename = "C:\erpman\image\근무일력재생성_up.gif"
end type

event clicked;call super::clicked;Int imsg

if dw_1.accepttext() = -1 then return 

imsg = Messagebox("근무일력재성성", "작업장일력도 같이 생성하시겠습니까?", question!, YesNoCancel!) 
if imsg = 1 then 
	cb_wrk_process.PostEvent(Clicked!)
elseif imsg = 3 then 
	return 
end if

SetPointer(HOURGLASS!)

this.enabled  = false
p_mod.enabled = false
p_can.enabled = false
p_exit.enabled  = false
w_mdi_frame.sle_msg.text   = '작업중입니다'
uo_2.visible     = true


char		cWork_day
string 	sFetchDay
int	 	iTotalCount, Julian_except, julian_all
int		iCalendar
Long lrow


  SELECT Count(*)
    INTO :iCalendar  
    FROM "P4_CALENDAR"  ;


iTotalCount   = 1
julian_all    = 10000
julian_except = 10000


datastore ds
ds = create datastore
ds.dataobject = "d_pdm_01620_ds"
ds.settransobject(sqlca)
ds.retrieve()


For Lrow = 1 to ds.rowcount()

    sfetchday = ds.getitemstring(Lrow, "cldate")
    cwork_day = ds.getitemstring(Lrow, "workgub")	 

   UPDATE "P4_CALENDAR"  
     SET "JDATE" = :julian_all,
         "JDATE2" = :julian_except  
	WHERE ( "P4_CALENDAR"."CLDATE" = :sFetchDay ) ;


   julian_all ++
	IF ( cWork_day = '1' ) OR ( cWork_day = '2' )	THEN		julian_except++

											

	decimal{2} 	meter_position
	meter_position = truncate( ( iTotalCount / iCalendar * 100 ) , 0 )
	uo_2.uf_set_position ( meter_position )    
	iTotalCount++	


Next

destroy ds

COMMIT;

this.enabled     = true
p_mod.enabled  = true
p_can.enabled= true
p_exit.enabled  = true
w_mdi_frame.sle_msg.text   = ''	


uo_2.visible  = false    
SetPointer(ARROW!)

b_check3 = false

	
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\근무일력재생성_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\근무일력재생성_up.gif"
end event

type p_1 from uo_picture within w_pdm_01620
integer x = 3451
integer y = 20
integer width = 306
integer taborder = 50
string pointer = "C:\erpman\cur\Point.cur"
boolean originalsize = true
string picturename = "C:\erpman\image\작업장일력재생성_up.gif"
end type

event clicked;call super::clicked;INT imsg

if dw_1.accepttext() = -1 then return 

imsg = Messagebox("작업장일력재성성", "작업장일력을 생성하시겠습니까?", question!, YesNo!) 
if imsg = 2 then 
	return 
end if

cb_wrk_process.TriggerEvent(Clicked!)

b_check4 = false

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\작업장일력재생성_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\작업장일력재생성_up.gif"
end event

type p_exit from uo_picture within w_pdm_01620
integer x = 4398
integer y = 20
integer width = 178
integer taborder = 70
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

event clicked;call super::clicked;if b_check1 = false and b_check3 = true then
   messagebox("근무일력", "근무구분이 변경되었으므로 근무일력 재생성을" + '~n' + &
                          "한 후 종료하시기 바랍니다", information!)
   return
elseif b_check2 = false and b_check4 = true then
   messagebox("근무일력", "SHIFT 와 RATE가 변경되었으므로 작업장일력 재생성을" + '~n' + &
                          "한 후 종료하시기 바랍니다", information!)
   return
end if


close(parent)
end event

type p_can from uo_picture within w_pdm_01620
integer x = 4224
integer y = 20
integer width = 178
integer taborder = 40
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

event clicked;call super::clicked;SetPointer(HourGlass!)

dw_detail.setredraw(false)

dw_detail.Reset()

uo_1.SetRedraw(FALSE)

uo_1.init_cal(today())

string 	date_format
date_format = "yyyy/mm/dd"
uo_1.set_date_format ( date_format )

uo_1.fu_init_datawindow(dw_detail)


/*====================================================
	 WINDOW  datawindow(dw_1) 에 현재일자 retrieve
=====================================================*/
string 	retrieve_format 

retrieve_format = String( today(), "yyyymmdd" )

dw_detail.retrieve( retrieve_format )

uo_1.SetRedraw(true)
dw_detail.setredraw(true)

uo_2.visible = false

if b_check1 = true then 
	b_check1 = false
	b_check3 = false
end if

if b_check2 = true then 
	b_check2 = false
	b_check4 = false
end if

w_mdi_frame.sle_msg.text = ''	
end event

type p_mod from uo_picture within w_pdm_01620
integer x = 4050
integer y = 20
integer width = 178
integer taborder = 20
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

event clicked;call super::clicked;date		date_selected
string	sWorkDay, syymm
int		iyydate, immdate, idddate


uo_2.visible = false
w_mdi_frame.sle_msg.text = ''	

IF	dw_detail.AcceptText() = -1	then
	RETURN
END IF

sWorkDay = trim(dw_detail.GetItemString(1, "cldate"))
syymm    = trim(dw_detail.GetItemString(1, "yyyymm"))

if syymm = '' or isnull(syymm) then 
	f_message_chk(30, "[적용년월]")
	dw_detail.setcolumn("yyyymm")
	dw_detail.setfocus()
	return 
end if	

iyydate  = integer( mid(sWorkDay, 1, 4) )
immdate  = integer( mid(sWorkDay, 5, 2) )
idddate  = integer( mid(sWorkDay, 7, 2) )

date_selected = date(iyydate, immdate, idddate )

IF dw_detail.Update() > 0 THEN	 

	COMMIT USING sqlca;

	uo_1.init_cal(date_selected)
	
	string 	date_format
	date_format = "yyyy/mm/dd"
	uo_1.set_date_format ( date_format )
	uo_1.fu_init_datawindow(dw_detail)

   if b_check1 = true then 
		b_check1 = false
		b_check3 = true 
   end if
	
   if b_check2 = true then 
		b_check2 = false
		b_check4 = true 
   end if
ELSE

	ROLLBACK;
	f_Rollback()

END IF


end event

type cb_wrk_process from commandbutton within w_pdm_01620
boolean visible = false
integer x = 3104
integer y = 40
integer width = 247
integer height = 108
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "처리"
end type

event clicked;String s_today, sfrdate, stodate, sGubun, sWorkgub

sFrdate  = trim(dw_1.getitemstring(1, 'fdate'))
sTodate  = trim(dw_1.getitemstring(1, 'tdate'))
sGubun   = dw_1.getitemstring(1, 'gubun')
sWorkgub = dw_1.getitemstring(1, 'workgub')

IF sFrdate = '' or isnull(sFrdate) THEN
	f_message_chk(30,'[기간 FROM]')
	dw_1.setcolumn('fdate')
	dw_1.setfocus()
	return 
END IF
IF sTodate = '' or isnull(sTodate) THEN
	f_message_chk(30,'[기간 TO]')
	dw_1.setcolumn('tdate')
	dw_1.setfocus()
	return 
END IF

SetPointer(HOURGLASS!)
p_1.enabled    = false
p_mod.enabled  = false
p_can.enabled  = false
p_exit.enabled = false

SELECT MIN("P4_CALENDAR"."CLDATE")  
  INTO :s_today  
  FROM "P4_CALENDAR"  ;

IF isnull(s_today) or s_today ='' then 
   MESSAGEBOX("재생성 실패", "인사에 근무일력자료가 없으니 확인하십시요!!")
	return 
END IF

w_mdi_frame.sle_msg.text   = '작업장일력 재생성 中... '

IF sqlca.Erp000000120(sFrdate, sTodate, sGubun, sWorkgub) = 1 THEN  //근무일력 재생성
   COMMIT;
   w_mdi_frame.sle_msg.text   = '처리 완료 되었습니다...'	
ELSE	
   ROLLBACK;
   w_mdi_frame.sle_msg.text   = ''	
   MESSAGEBOX("재생성 실패", "작업장일력 재생성 작업이 실패 하였으니 전산실에 문의하세요!!")
END IF

p_1.enabled     = true
p_mod.enabled   = true
p_can.enabled   = true
p_exit.enabled  = true

w_mdi_frame.sle_msg.text   = ''	
SetPointer(ARROW!)
b_check4 = false

end event

type uo_2 from u_progress_bar within w_pdm_01620
boolean visible = false
integer x = 2729
integer y = 180
integer width = 1083
integer height = 72
end type

on uo_2.destroy
call u_progress_bar::destroy
end on

type dw_detail from datawindow within w_pdm_01620
event ue_pressenter pbm_dwnprocessenter
integer x = 2537
integer y = 452
integer width = 1490
integer height = 916
integer taborder = 10
string dataobject = "d_pdm_01620"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemerror;return 1
end event

event itemchanged;string	sNull, sDate
DEC {2}  dRate

SetNull(sNull)

IF this.GetColumnName() = 'yyyymm' THEN

	sDate = trim(this.GetText())
	
	if sDate = '' or isnull(sDate) then return 
	
	IF f_datechk(sDate + '01') = -1 THEN
		f_message_chk(35,'[적용년월]')
		this.SetItem(1,"yyyymm",snull)
		Return 1
	END IF
ELSEIF this.GetColumnName() = 'workgub' THEN
	sDate = trim(this.GetText())
   
	IF sDATE = '1' OR sDATE = '2' THEN 
		this.setitem(1, 'overyn', 'Y')
		this.setitem(1, 'rate1', 100)
	ELSE
		this.setitem(1, 'overyn', 'N')
		this.setitem(1, 'rate1', 0)
	END IF
	this.setitem(1, 'nightyn', 'N')
	this.setitem(1, 'alnight', 'N')
	this.setitem(1, 'extra', 'N')

	this.setitem(1, 'rate2', 0)
	this.setitem(1, 'rate3', 0)
	this.setitem(1, 'rate4', 0)
	
	b_check1 = true
	b_check2 = true
ELSEIF this.GetColumnName() = 'overyn'  THEN
	sDate = trim(this.GetText())
   
	IF sDATE = 'Y' THEN 
		this.setitem(1, colname2[1], 100)
		this.setitem(1, colname1[2], 'N')
		this.setitem(1, colname1[3], 'N')
		this.setitem(1, colname1[4], 'N')		
		this.setitem(1, colname2[2], 0)
		this.setitem(1, colname2[3], 0)
		this.setitem(1, colname2[4], 0)		
	ELSE
		this.setitem(1, colname2[1], 0)
	END IF
	b_check2 = true
ELSEIF this.GetColumnName() = 'nightyn'  THEN
	sDate = trim(this.GetText())
   
	IF sDATE = 'Y' THEN 
		this.setitem(1, colname2[2], 100)
		this.setitem(1, colname1[1], 'N')
		this.setitem(1, colname1[3], 'N')
		this.setitem(1, colname1[4], 'N')		
		this.setitem(1, colname2[1], 0)
		this.setitem(1, colname2[3], 0)
		this.setitem(1, colname2[4], 0)		
	ELSE
		this.setitem(1, colname2[2], 0)
	END IF
	b_check2 = true
ELSEIF this.GetColumnName() = 'alnight'  THEN
	sDate = trim(this.GetText())
   
	IF sDATE = 'Y' THEN 
		this.setitem(1, colname2[3], 100)
		this.setitem(1, colname1[1], 'N')
		this.setitem(1, colname1[2], 'N')
		this.setitem(1, colname1[4], 'N')		
		this.setitem(1, colname2[1], 0)
		this.setitem(1, colname2[2], 0)
		this.setitem(1, colname2[4], 0)		
	ELSE
		this.setitem(1, colname2[3], 0)
	END IF
	b_check2 = true
ELSEIF this.GetColumnName() = 'extra'  THEN
	sDate = trim(this.GetText())
   
	IF sDATE = 'Y' THEN 
		this.setitem(1, colname2[4], 100)
		this.setitem(1, colname1[1], 'N')
		this.setitem(1, colname1[2], 'N')
		this.setitem(1, colname1[3], 'N')		
		this.setitem(1, colname2[1], 0)
		this.setitem(1, colname2[2], 0)
		this.setitem(1, colname2[3], 0)		
	ELSE
		this.setitem(1, colname2[4], 0)
	END IF
	b_check2 = true
ELSEIF this.GetColumnName() = 'rate1'  THEN
	dRate = dec(this.GetText())
   
	IF dRate > 100 THEN 
		messagebox('확 인', 'RATE 가 100 을 넘을 수 없습니다.')
		this.setitem(1, 'rate1', 100)
		return 1
	ELSEIF dRate <= 0 THEN 
		messagebox('확 인', 'RATE 가 0 보다 커야 합니다.')
		this.setitem(1, 'rate1', 100)
		return 1
	END IF

	b_check2 = true
ELSEIF this.GetColumnName() = 'rate2'  THEN
	dRate = dec(this.GetText())
   
	IF dRate > 100 THEN 
		messagebox('확 인', 'RATE 가 100 을 넘을 수 없습니다.')
		this.setitem(1, 'rate2', 100)
		return 1
	ELSEIF dRate <= 0 THEN 
		messagebox('확 인', 'RATE 가 0 보다 커야 합니다.')
		this.setitem(1, 'rate2', 100)
		return 1
	END IF

	b_check2 = true
ELSEIF this.GetColumnName() = 'rate3'  THEN
	dRate = dec(this.GetText())
   
	IF dRate > 100 THEN 
		messagebox('확 인', 'RATE 가 100 을 넘을 수 없습니다.')
		this.setitem(1, 'rate3', 100)
		return 1
	ELSEIF dRate <= 0 THEN 
		messagebox('확 인', 'RATE 가 0 보다 커야 합니다.')
		this.setitem(1, 'rate3', 100)
		return 1
	END IF

	b_check2 = true
ELSEIF this.GetColumnName() = 'rate4'  THEN
	dRate = dec(this.GetText())
   
	IF dRate > 100 THEN 
		messagebox('확 인', 'RATE 가 100 을 넘을 수 없습니다.')
		this.setitem(1, 'rate4', 100)
		return 1
	ELSEIF dRate <= 0 THEN 
		messagebox('확 인', 'RATE 가 0 보다 커야 합니다.')
		this.setitem(1, 'rate4', 100)
		return 1
	END IF

	b_check2 = true
END IF

end event

type uo_1 from u_ddcal within w_pdm_01620
integer x = 654
integer y = 300
integer width = 1842
integer height = 1348
long backcolor = 0
long tabtextcolor = 0
string ls_dateformat = ""
end type

on uo_1.destroy
call u_ddcal::destroy
end on

type dw_1 from datawindow within w_pdm_01620
integer x = 1783
integer y = 1904
integer width = 1838
integer height = 96
integer taborder = 30
string dataobject = "d_pdm_01620_1_new"
boolean border = false
boolean livescroll = true
end type

type rr_3 from roundrectangle within w_pdm_01620
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 608
integer y = 1864
integer width = 3397
integer height = 444
integer cornerheight = 40
integer cornerwidth = 55
end type

