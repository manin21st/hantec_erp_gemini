$PBExportHeader$w_pdm_01621.srw
$PBExportComments$달력수정 (계열사별)
forward
global type w_pdm_01621 from window
end type
type st_fac from statictext within w_pdm_01621
end type
type dw_pdt from datawindow within w_pdm_01621
end type
type dw_fac from datawindow within w_pdm_01621
end type
type st_1 from statictext within w_pdm_01621
end type
type p_2 from uo_picture within w_pdm_01621
end type
type p_exit from uo_picture within w_pdm_01621
end type
type p_can from uo_picture within w_pdm_01621
end type
type p_mod from uo_picture within w_pdm_01621
end type
type uo_2 from u_progress_bar within w_pdm_01621
end type
type dw_detail from datawindow within w_pdm_01621
end type
type uo_1 from u_ddcal2 within w_pdm_01621
end type
type dw_1 from datawindow within w_pdm_01621
end type
type rr_3 from roundrectangle within w_pdm_01621
end type
end forward

global type w_pdm_01621 from window
integer width = 4672
integer height = 2608
boolean titlebar = true
string title = "근무일력 수정"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
long backcolor = 32106727
st_fac st_fac
dw_pdt dw_pdt
dw_fac dw_fac
st_1 st_1
p_2 p_2
p_exit p_exit
p_can p_can
p_mod p_mod
uo_2 uo_2
dw_detail dw_detail
uo_1 uo_1
dw_1 dw_1
rr_3 rr_3
end type
global w_pdm_01621 w_pdm_01621

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

event open;string   ls_pdtgu
Integer  li_idx

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

dw_pdt.settransobject(sqlca)
dw_fac.settransobject(sqlca)
dw_fac.insertrow(0)

uo_1.init_cal(today())

string 	date_format
date_format = "yyyy/mm/dd"
uo_1.set_date_format ( date_format )
uo_1.fu_init_datawindow(dw_detail)

dw_detail.retrieve(is_today)
dw_detail.SetFilter("1 = 0")
dw_detail.Filter( )


dw_1.setitem(1, 'fdate', left(is_today, 6))
dw_1.setitem(1, 'tdate', left(is_today, 4) + '12' )

select rfgub
  into :ls_pdtgu
  from reffpf 
 where rfcod = '2A'
	and substr(rfna7, 1, 1) <> 'X'
	and rfgub <> '.'  
	and rfgub <> '00'
   and rownum = 1
order by rfgub;

dw_fac.SetItem(1, 'pdtgu', ls_pdtgu)
dw_fac.trigger event ItemChanged(1, dw_fac.object.pdtgu, ls_pdtgu)
end event

on w_pdm_01621.create
this.st_fac=create st_fac
this.dw_pdt=create dw_pdt
this.dw_fac=create dw_fac
this.st_1=create st_1
this.p_2=create p_2
this.p_exit=create p_exit
this.p_can=create p_can
this.p_mod=create p_mod
this.uo_2=create uo_2
this.dw_detail=create dw_detail
this.uo_1=create uo_1
this.dw_1=create dw_1
this.rr_3=create rr_3
this.Control[]={this.st_fac,&
this.dw_pdt,&
this.dw_fac,&
this.st_1,&
this.p_2,&
this.p_exit,&
this.p_can,&
this.p_mod,&
this.uo_2,&
this.dw_detail,&
this.uo_1,&
this.dw_1,&
this.rr_3}
end on

on w_pdm_01621.destroy
destroy(this.st_fac)
destroy(this.dw_pdt)
destroy(this.dw_fac)
destroy(this.st_1)
destroy(this.p_2)
destroy(this.p_exit)
destroy(this.p_can)
destroy(this.p_mod)
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

type st_fac from statictext within w_pdm_01621
boolean visible = false
integer x = 2592
integer y = 260
integer width = 402
integer height = 48
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
boolean focusrectangle = false
end type

type dw_pdt from datawindow within w_pdm_01621
boolean visible = false
integer x = 663
integer width = 370
integer height = 212
integer taborder = 70
string title = "none"
string dataobject = "dd_reffpf_2a_fac"
boolean border = false
boolean livescroll = true
end type

type dw_fac from datawindow within w_pdm_01621
integer x = 2537
integer y = 308
integer width = 1490
integer height = 148
integer taborder = 40
string title = "none"
string dataobject = "d_pdm_01621_c"
boolean border = false
boolean livescroll = true
end type

event itemchanged;/*=======================================================
			근무일수, 휴무일수 계산
========================================================*/
string	yyyymm
int 		WorkDayCount, RedDayCount, TotalDayCount

string ls_yymm, ls_yy, ls_mm
long ll_mpos

ls_yymm = uo_1.dw_cal.object.st_month.text
ll_mpos = pos(ls_yymm, '월')
ll_mpos = ll_mpos - 1
ls_yy = Mid(Right(ls_yymm, 5), 1, 4)
ls_mm = right('00' + Mid(ls_yymm, 1, ll_mpos), 2)

yyyymm = ls_yy + ls_mm

st_fac.text = data

dw_detail.retrieve(yyyymm)
dw_detail.SetFilter("pdtgu = '" + data + "'")
dw_detail.Filter()

  SELECT Count("CLDATE")
    INTO :TotalDayCount  
    FROM "FACCAL"  
   WHERE ( SUBSTR("FACCAL"."CLDATE",1,6) = :yyyymm )
     AND ( "FACCAL"."PDTGU" = :data )   ;

  SELECT Count("CLDATE")
    INTO :WorkDayCount  
    FROM "FACCAL"  
   WHERE ( "FACCAL"."WORKGUB" != '9' )
     AND ( SUBSTR("FACCAL"."CLDATE",1,6) = :yyyymm )
     AND ( "FACCAL"."PDTGU" = :data )   ;

uo_1.st_work.text = string(WorkDayCount)
uo_1.st_red.text  = string(TotalDayCount - WorkDayCount)


end event

type st_1 from statictext within w_pdm_01621
integer x = 763
integer y = 1928
integer width = 1006
integer height = 52
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "※ 납품 공장 근무일력 재생성 처리"
boolean focusrectangle = false
end type

type p_2 from uo_picture within w_pdm_01621
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

imsg = Messagebox("납품 공장별 일력성성", "납품 공장별 일력성성 생성하시겠습니까?", question!, YesNo!) 
if imsg = 2 then
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
string 	sFetchDay, sHdaygubn, sYyyymm, sPdtgu
int	 	iTotalCount, Julian_except, julian_all
int		iCalendar
Long lrow


  SELECT Count(*)
    INTO :iCalendar  
    FROM "P4_CALENDAR"  ;


iTotalCount   = 1
julian_all    = 10000
julian_except = 10000


string sFdate, sTdate
sFdate = dw_1.getitemstring(1, "fdate")
sTdate = dw_1.getitemstring(1, "tdate")

DELETE FROM FACCAL
 WHERE YYYYMM >= :sFdate AND YYYYMM <= :sTdate;

INSERT INTO FACCAL
(CLDATE, PDTGU, YYYYMM, HDAYGUBN, WORKGUB, DAYGUBN)
SELECT 
A.CLDATE, B.RFGUB, A.YYYYMM, DECODE(A.DAYGUBN, '7', '2', A.HDAYGUBN), DECODE(A.DAYGUBN, '7', '9', '1', '9', '1'), A.DAYGUBN
FROM P4_CALENDAR A, REFFPF B
WHERE B.RFCOD = '2A' AND SUBSTR(B.RFNA7,1,1) <> 'X' AND B.RFGUB <> '00' AND B.RFGUB <> '.'
AND A.YYYYMM >= :sFdate AND A.YYYYMM <= :sTdate
ORDER BY B.RFGUB, A.CLDATE;

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

type p_exit from uo_picture within w_pdm_01621
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

type p_can from uo_picture within w_pdm_01621
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

type p_mod from uo_picture within w_pdm_01621
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
	
	/*=======================================================
				근무일수, 휴무일수 계산
	========================================================*/
	string	yyyymm
	int 		WorkDayCount, RedDayCount, TotalDayCount
	
	string ls_yymm, ls_yy, ls_mm, ls_pdtgu
	long ll_mpos
	
	ls_yymm = uo_1.dw_cal.object.st_month.text
	ll_mpos = pos(ls_yymm, '월')
	ll_mpos = ll_mpos - 1
	ls_yy = Mid(Right(ls_yymm, 5), 1, 4)
	ls_mm = right('00' + Mid(ls_yymm, 1, ll_mpos), 2)
	
	yyyymm = ls_yy + ls_mm
	
	ls_pdtgu = st_fac.text
	
	dw_detail.retrieve(yyyymm)
	dw_detail.SetFilter("pdtgu = '" + ls_pdtgu + "'")
	dw_detail.Filter()
	
	  SELECT Count("CLDATE")
		 INTO :TotalDayCount  
		 FROM "FACCAL"  
		WHERE ( SUBSTR("FACCAL"."CLDATE",1,6) = :yyyymm )
		  AND ( "FACCAL"."PDTGU" = :ls_pdtgu )   ;
	
	  SELECT Count("CLDATE")
		 INTO :WorkDayCount  
		 FROM "FACCAL"  
		WHERE ( "FACCAL"."WORKGUB" != '9' )
		  AND ( SUBSTR("FACCAL"."CLDATE",1,6) = :yyyymm )
		  AND ( "FACCAL"."PDTGU" = :ls_pdtgu )   ;
	
	uo_1.st_work.text = string(WorkDayCount)
	uo_1.st_red.text  = string(TotalDayCount - WorkDayCount)
	
ELSE

	ROLLBACK;
	f_Rollback()

END IF


end event

type uo_2 from u_progress_bar within w_pdm_01621
boolean visible = false
integer x = 2729
integer y = 180
integer width = 1083
integer height = 72
end type

on uo_2.destroy
call u_progress_bar::destroy
end on

type dw_detail from datawindow within w_pdm_01621
event ue_pressenter pbm_dwnprocessenter
integer x = 2537
integer y = 452
integer width = 1490
integer height = 916
integer taborder = 10
string dataobject = "d_pdm_01621"
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
END IF

end event

type uo_1 from u_ddcal2 within w_pdm_01621
event ue_lbuttonclk pbm_lbuttonclk
integer x = 654
integer y = 300
integer width = 1842
integer height = 1348
long backcolor = 0
long tabtextcolor = 0
string ls_dateformat = ""
end type

event ue_lbuttonclk;call super::ue_lbuttonclk;string ls_pdtgu

string	yyyymm
int 		WorkDayCount, RedDayCount, TotalDayCount

string ls_yymm, ls_yy, ls_mm
long ll_mpos

ls_pdtgu = st_fac.text

ls_yymm = this.dw_cal.object.st_month.text
ll_mpos = pos(ls_yymm, '월')
ll_mpos = ll_mpos - 1
ls_yy = Mid(Right(ls_yymm, 5), 1, 4)
ls_mm = right('00' + Mid(ls_yymm, 1, ll_mpos), 2)

yyyymm = ls_yy + ls_mm

dw_detail.retrieve(yyyymm)
dw_detail.SetFilter("pdtgu = '" + ls_pdtgu + "'")
dw_detail.Filter()

/*=======================================================
			근무일수, 휴무일수 계산
========================================================*/

  SELECT Count("CLDATE")
    INTO :TotalDayCount  
    FROM "FACCAL"  
   WHERE ( SUBSTR("FACCAL"."CLDATE",1,6) = :yyyymm )
     AND ( "FACCAL"."PDTGU" = :ls_pdtgu )   ;

  SELECT Count("CLDATE")
    INTO :WorkDayCount  
    FROM "FACCAL"  
   WHERE ( "FACCAL"."WORKGUB" != '9' )
     AND ( SUBSTR("FACCAL"."CLDATE",1,6) = :yyyymm )
     AND ( "FACCAL"."PDTGU" = :ls_pdtgu )   ;

this.st_work.text = string(WorkDayCount)
this.st_red.text  = string(TotalDayCount - WorkDayCount)


end event

on uo_1.destroy
call u_ddcal2::destroy
end on

type dw_1 from datawindow within w_pdm_01621
integer x = 1783
integer y = 1904
integer width = 1838
integer height = 96
integer taborder = 30
string dataobject = "d_pdm_01621_1_new"
boolean border = false
boolean livescroll = true
end type

type rr_3 from roundrectangle within w_pdm_01621
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

