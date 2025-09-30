$PBExportHeader$w_imt_04080.srw
$PBExportComments$선급금 정리
forward
global type w_imt_04080 from window
end type
type pb_2 from u_pb_cal within w_imt_04080
end type
type pb_1 from u_pb_cal within w_imt_04080
end type
type p_exit from uo_picture within w_imt_04080
end type
type p_cancel from uo_picture within w_imt_04080
end type
type p_inq from uo_picture within w_imt_04080
end type
type dw_1 from datawindow within w_imt_04080
end type
type dw_imhist from datawindow within w_imt_04080
end type
type dw_list from datawindow within w_imt_04080
end type
type rr_1 from roundrectangle within w_imt_04080
end type
end forward

global type w_imt_04080 from window
integer width = 4658
integer height = 2440
boolean titlebar = true
string title = "선급금 정리"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 32106727
pb_2 pb_2
pb_1 pb_1
p_exit p_exit
p_cancel p_cancel
p_inq p_inq
dw_1 dw_1
dw_imhist dw_imhist
dw_list dw_list
rr_1 rr_1
end type
global w_imt_04080 w_imt_04080

type variables
boolean ib_ItemError, ib_any_typing
char ic_status

String     is_today              //시작일자
String     is_totime             //시작시간
String     is_window_id      //윈도우 ID
String     is_usegub           //이력관리 여부

String     is_expgub          //수입비용 적용구분
string     is_useyn      //외자인터페이스 생성 적용구분
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

dw_list.settransobject(sqlca)

if gs_gubun = 'w_imt_04060' then 
	dw_1.insertrow(0)
	dw_1.setitem(1, 'fr_date', '10000101')
	dw_1.setitem(1, 'to_date', is_today)
	dw_1.setitem(1, 'lcno', gs_code)
else
	p_cancel.TriggerEvent(Clicked!)
end if


end event

on w_imt_04080.create
this.pb_2=create pb_2
this.pb_1=create pb_1
this.p_exit=create p_exit
this.p_cancel=create p_cancel
this.p_inq=create p_inq
this.dw_1=create dw_1
this.dw_imhist=create dw_imhist
this.dw_list=create dw_list
this.rr_1=create rr_1
this.Control[]={this.pb_2,&
this.pb_1,&
this.p_exit,&
this.p_cancel,&
this.p_inq,&
this.dw_1,&
this.dw_imhist,&
this.dw_list,&
this.rr_1}
end on

on w_imt_04080.destroy
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.p_exit)
destroy(this.p_cancel)
destroy(this.p_inq)
destroy(this.dw_1)
destroy(this.dw_imhist)
destroy(this.dw_list)
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

w_mdi_frame.st_window.Text = ''

long li_index

li_index = w_mdi_frame.dw_listbar.Find("window_id = '" + Upper(This.ClassName()) + "'", 1, w_mdi_frame.dw_listbar.RowCount())

w_mdi_frame.dw_listbar.DeleteRow(li_index)
w_mdi_frame.Postevent("ue_barrefresh")
end event

event key;// Page Up & Page Down & Home & End Key 사용 정의
choose case key
	case keypageup!
		dw_list.scrollpriorpage()
	case keypagedown!
		dw_list.scrollnextpage()
	case keyhome!
		dw_list.scrolltorow(1)
	case keyend!
		dw_list.scrolltorow(dw_list.rowcount())
	case KeyupArrow!
		dw_list.scrollpriorrow()
	case KeyDownArrow!
		dw_list.scrollnextrow()		
end choose


end event

type pb_2 from u_pb_cal within w_imt_04080
integer x = 1147
integer y = 52
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_1.SetColumn('to_date')
IF IsNull(gs_code) THEN Return
ll_row = dw_1.GetRow()
If ll_row < 1 Then Return
dw_1.SetItem(ll_row, 'to_date', gs_code)



end event

type pb_1 from u_pb_cal within w_imt_04080
integer x = 718
integer y = 52
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_1.SetColumn('fr_date')
IF IsNull(gs_code) THEN Return
ll_row = dw_1.GetRow()
If ll_row < 1 Then Return
dw_1.SetItem(ll_row, 'fr_date', gs_code)



end event

type p_exit from uo_picture within w_imt_04080
integer x = 4384
integer y = 12
integer width = 178
integer taborder = 70
string pointer = "c:\ERPMAN\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

event clicked;call super::clicked;CLOSE(PARENT)
end event

type p_cancel from uo_picture within w_imt_04080
integer x = 4210
integer y = 12
integer width = 178
integer taborder = 60
string pointer = "c:\ERPMAN\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

event clicked;call super::clicked;dw_1.reset()
dw_1.insertrow(0)
dw_1.setitem(1, 'fr_date', left(is_today, 6) + '01')
dw_1.setitem(1, 'to_date', is_today)

dw_list.Reset()



end event

type p_inq from uo_picture within w_imt_04080
integer x = 4037
integer y = 12
integer width = 178
integer taborder = 20
string pointer = "c:\ERPMAN\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조회_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조회_up.gif"
end event

event clicked;call super::clicked;IF dw_1.accepttext() = -1			THEN 	RETURN 

string	sf_Date, st_date, slcno, scvcod

sf_Date =  trim(dw_1.getitemstring(1, 'fr_date'))
st_Date =  trim(dw_1.getitemstring(1, 'to_date'))
slcno   =  trim(dw_1.getitemstring(1, 'lcno'))
scvcod  =  trim(dw_1.getitemstring(1, 'cvcod'))

IF isnull(sf_Date) or sf_Date = "" 	THEN
	f_message_chk(30,'[결제일자 FROM]')
	dw_1.SetColumn("fr_date")
	dw_1.SetFocus()
	RETURN
END IF
IF isnull(st_Date) or st_Date = "" 	THEN
	f_message_chk(30,'[결제일자 TO]')
	dw_1.SetColumn("to_date")
	dw_1.SetFocus()
	RETURN
END IF

IF isnull(slcno)  or slcno  = "" THEN slcno = '%'
IF isnull(scvcod) or scvcod = ""	THEN scvcod = '%'

IF	dw_list.Retrieve(gs_sabu, sf_Date, st_date, slcno, scvcod) <	1		THEN
	f_message_chk(50, '')
	dw_1.SetColumn('fr_date')
	dw_1.SetFocus()
	RETURN
END IF



end event

type dw_1 from datawindow within w_imt_04080
event ue_presenter pbm_dwnprocessenter
integer x = 69
integer y = 16
integer width = 3479
integer height = 164
integer taborder = 10
string dataobject = "d_imt_04080_1"
boolean border = false
boolean livescroll = true
end type

event ue_presenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemchanged;string  snull, sdate, sname, sname2
int     i_rtn

setnull(snull)

IF this.GetColumnName() = "fr_date"	THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF f_datechk(sdate) = -1	then
      f_message_chk(35, '[결제일자]')
		this.setitem(1, "fr_date", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() = "to_date"	THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF f_datechk(sdate) = -1	then
      f_message_chk(35, '[결제일자]')
		this.setitem(1, "to_date", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() = 'lcno' THEN

	sDate  = TRIM(this.gettext())

	if sdate = "" or isnull(sdate) then	return 
	
	Select sabu
	  into :sname
	  from polchd 
	 where sabu = :gs_sabu and polcno = :sdate ;
	 
	if sqlca.sqlcode <> 0 then
      f_message_chk(33, '[L/C-NO]')
		this.setitem(1, "lcno", sNull)
		return 1
	END IF
ELSEIF this.getcolumnname() = 'cvcod' then 
	sdate = trim(this.GetText())
	
	i_rtn = f_get_name2("V1", "Y", sdate, sname, sname2)
	this.setitem(1,"cvcod", sdate)		
	this.setitem(1,"cvnas", sname)
	return i_rtn
	
END IF
end event

event itemerror;return 1
end event

event rbuttondown;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)
IF this.getcolumnname() = "cvcod"	THEN 
	gs_gubun = '1'
	open(w_vndmst_popup)
	if gs_code = '' or isnull(gs_code) then return 
	
   this.SetItem(1, "cvcod", gs_code)
	this.SetItem(1, "cvnas", gs_codename)
ELSEIF this.GetColumnName() = 'lcno'	THEN
	
	gs_gubun = 'LOCAL'
   
	Open(w_lc_popup)
		
	if isNull(gs_code) or trim(gs_code) = ''	then	return
	SetItem(1, "lcno", gs_code)
	
END IF

end event

type dw_imhist from datawindow within w_imt_04080
boolean visible = false
integer x = 2130
integer y = 2364
integer width = 494
integer height = 212
boolean titlebar = true
string title = "입출고HISTORY"
string dataobject = "d_pme3001_imhist"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
end type

type dw_list from datawindow within w_imt_04080
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 87
integer y = 192
integer width = 4466
integer height = 2100
integer taborder = 20
string dataobject = "d_imt_04080_2"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event buttonclicked;If row <= 0 Then Return 

gs_gubun = Trim(GetItemString(row,'polcno'))
gs_code  = Trim(GetItemString(row,'setno'))

OpenSheet(w_imt_04081,w_mdi_frame,2,original!)

if gs_code = 'YES' then 
   p_inq.TriggerEvent(Clicked!)
end if
end event

type rr_1 from roundrectangle within w_imt_04080
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 73
integer y = 184
integer width = 4489
integer height = 2120
integer cornerheight = 40
integer cornerwidth = 55
end type

