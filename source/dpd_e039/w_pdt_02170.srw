$PBExportHeader$w_pdt_02170.srw
$PBExportComments$** 지원이력 등록
forward
global type w_pdt_02170 from w_inherite
end type
type gb_1 from groupbox within w_pdt_02170
end type
type dw_1 from datawindow within w_pdt_02170
end type
type pb_1 from u_pb_cal within w_pdt_02170
end type
type rr_1 from roundrectangle within w_pdt_02170
end type
end forward

global type w_pdt_02170 from w_inherite
integer height = 2512
string title = "지원이력 등록"
gb_1 gb_1
dw_1 dw_1
pb_1 pb_1
rr_1 rr_1
end type
global w_pdt_02170 w_pdt_02170

type variables
string ls_format,  ls_tformat
end variables

forward prototypes
public function integer wf_settime (integer lrow, string gub)
public function integer wf_required_chk (integer i)
end prototypes

public function integer wf_settime (integer lrow, string gub);string s_frtime, s_frhour, s_frmin, s_totime, s_tohour, s_tomin, snull, sftime, sttime
time   t_frtime, t_totime
double d_jitime, d_husik
int    i_inwon
Dec	 dtime

setnull(ls_format) 
setnull(ls_tformat) 
setnull(snull)
s_frtime  = trim(dw_insert.getitemstring(lrow, 'ji_from'))
s_totime  = trim(dw_insert.getitemstring(lrow, 'ji_to'))
i_inwon  =  dw_insert.getitemNumber(lrow, 'ji_inwon')

s_frhour  = left(s_frtime, 2)
s_frmin   = mid(s_frtime, 3, 2)
s_tohour  = left(s_totime, 2)
s_tomin   = mid(s_totime, 3, 2)
t_frtime  = time(s_frhour + ':' + s_frmin )
t_totime  = time(s_tohour + ':' + s_tomin )

sftime    = string(time(s_frhour + ':' + s_frmin + ':' + '01'), "hhmm")
sttime    = string(time(s_tohour + ':' + s_tomin + ':' + '01'), "hhmm")

// 휴식시간 검색(From ~ to)
SELECT SUM(NVL(TO_NUMBER(DATANAME),0))
  INTO :d_husik
  FROM SYSCNFG
 WHERE SYSGU = 'Y' and SERIAL = 28 AND LINENO <> '00'
	and TITLENAME >= :sftime AND TITLENAME < :sttime;
	
if isnull(d_husik) then 
	d_husik = 0
else
	d_husik = d_husik * i_inwon
end if

If gub = 'FROM' AND t_frtime = 00:00:00.000000 Then
	f_message_chk(63,'[지원시간 FROM]') 
	dw_insert.setitem(lRow, "ji_from", snull)	
	RETURN  -1
ELSEIf gub = 'TO' AND t_totime = 00:00:00.000000 Then
	f_message_chk(63,'[지원시간 TO]') 
	dw_insert.setitem(lRow, "ji_to", snull)	
	RETURN  -1
ELSE
	IF gub = 'FROM' THEN
      ls_format = string(t_frtime, 'hhmm')
   	d_jitime = SecondsAfter(t_frtime, t_totime)
		dtime = (Truncate(d_jitime/60,0) * i_inwon)
		if dtime > d_husik then
			dtime = dtime - d_husik
		end if
		dw_insert.setitem(lrow, 'ji_time', dtime)
		RETURN  1
	ELSEIF gub = 'TO' then
      ls_tformat = string(t_totime, 'hhmm')
   	d_jitime = SecondsAfter(t_frtime, t_totime)
		if d_jitime <= 0 then
			f_message_chk(34,'[지원시간 TO]') 
			dw_insert.setitem(lRow, "ji_to", snull)	
			RETURN  -1
		else
			dtime = (Truncate(d_jitime/60,0) * i_inwon)			
			if dtime > d_husik then
				dtime = dtime - d_husik
			end if
			dw_insert.setitem(lrow, 'ji_time', dtime)
			RETURN  1
		end if	
   ELSE
   	d_jitime = SecondsAfter(t_frtime, t_totime)
		dtime = (Truncate(d_jitime/60,0) * i_inwon)		
		if dtime > d_husik then
			dtime = dtime - d_husik
		end if
		dw_insert.setitem(lrow, 'ji_time', dtime)
		RETURN  1
   END IF
END IF

end function

public function integer wf_required_chk (integer i);String sEmpno

if dw_insert.AcceptText() = -1 then return -1

if isnull(dw_insert.GetItemString(i,'jocod')) or &
	dw_insert.GetItemString(i,'jocod') = "" then
	f_message_chk(1400,'[ '+string(i)+' 행 조코드]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('jocod')
	dw_insert.SetFocus()
	return -1		
end if	

if isnull(dw_insert.GetItemString(i,'ji_wkctr')) or &
	dw_insert.GetItemString(i,'ji_wkctr') = "" then
	f_message_chk(1400,'[ '+string(i)+' 행 작업장코드]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('ji_wkctr')
	dw_insert.SetFocus()
	return -1		
end if	

if isnull(dw_insert.GetItemString(i,'ji_jocod')) or &
	dw_insert.GetItemString(i,'ji_jocod') = "" then
	f_message_chk(1400,'[ '+string(i)+' 행 조코드]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('ji_jocod')
	dw_insert.SetFocus()
	return -1		
end if	

if isnull(dw_insert.GetItemNumber(i,'ji_inwon')) or &
	dw_insert.GetItemNumber(i,'ji_inwon') = 0 then
	f_message_chk(1400,'[ '+string(i)+' 행 지원인원]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('ji_inwon')
	dw_insert.SetFocus()
	return -1		
end if	

if isnull(trim(dw_insert.GetItemString(i,'ji_from'))) or &
	trim(dw_insert.GetItemString(i,'ji_from')) = "" then
	f_message_chk(1400,'[ '+string(i)+' 행 지원시간 FROM]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('ji_from')
	dw_insert.SetFocus()
	return -1		
end if	

if isnull(trim(dw_insert.GetItemString(i,'ji_to'))) or &
	trim(dw_insert.GetItemString(i,'ji_to')) = "" then
	f_message_chk(1400,'[ '+string(i)+' 행 지원시간 TO]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('ji_to')
	dw_insert.SetFocus()
	return -1		
end if	

if trim(dw_insert.GetItemString(i,'ji_from')) >= &
   trim(dw_insert.GetItemString(i,'ji_to'))  then
	f_message_chk(34,'[ '+string(i)+' 행 지원시간]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('ji_from')
	dw_insert.SetFocus()
	return -1		
end if	

if isnull(dw_insert.GetItemNumber(i,'ji_time')) or &
	dw_insert.GetItemNumber(i,'ji_time') = 0 then
	f_message_chk(1400,'[ '+string(i)+' 행 지원총시간]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('ji_time')
	dw_insert.SetFocus()
	return -1		
end if	

sEmpNo = Trim(dw_insert.GetItemString(i,'empno'))
If IsNull(sEmpNo) Or sEmpno = '' Then
	f_message_chk(1400,'[ '+string(i)+' 행 지원자]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('empno')
	dw_insert.SetFocus()
	return -1		
end if	

return 1
end function

on w_pdt_02170.create
int iCurrent
call super::create
this.gb_1=create gb_1
this.dw_1=create dw_1
this.pb_1=create pb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_1
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.rr_1
end on

on w_pdt_02170.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_1)
destroy(this.dw_1)
destroy(this.pb_1)
destroy(this.rr_1)
end on

event open;call super::open;dw_insert.SetTransObject(sqlca)

dw_1.SetTransObject(sqlca)
dw_1.insertrow(0)

dw_1.setitem(1, 'sdate', is_today)

if dw_insert.Retrieve(gs_sabu, Is_today) <= 0 then 
	dw_1.Setfocus()
	return
else
	dw_insert.SetFocus()
   dw_insert.SetColumn('jocod')
end if	

end event

event key;call super::key;// Page Up & Page Down & Home & End Key 사용 정의
choose case key
	case keypageup!
		dw_insert.scrollpriorpage()
	case keypagedown!
		dw_insert.scrollnextpage()
	case keyhome!
		dw_insert.scrolltorow(1)
	case keyend!
		dw_insert.scrolltorow(dw_insert.rowcount())
	case KeyupArrow!
		dw_insert.scrollpriorrow()
	case KeyDownArrow!
		dw_insert.scrollnextrow()		
end choose


end event

type dw_insert from w_inherite`dw_insert within w_pdt_02170
integer x = 41
integer y = 220
integer width = 4553
integer height = 2040
integer taborder = 20
string dataobject = "d_pdt_02170"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
borderstyle borderstyle = stylelowered!
end type

event dw_insert::ue_key;call super::ue_key;// Page Up & Page Down & Home & End Key 사용 정의
choose case key
	case KeyEnter! 
		if this.getcolumnname() = "wkctr" then
			if this.rowcount() = this.getrow() then
				p_ins.postevent(clicked!)
				return 1
			end if
		end if
end choose


end event

event dw_insert::itemchanged;Int lRow,lReturnRow, ireturn, i_time, i_inwon, ixreturn
String snull, sjocod, sjonm, sname, swkctr, swknm, s_fjocod, s_fwkctr, s_fjijo, stemp
String sbunam, scvcod
String sEmpno, sempnm, sname2

this.accepttext()
SetNull(snull)
lRow  = this.GetRow()	

IF this.GetColumnName() = "wkctr"	THEN
	sjocod = trim(this.gettext())

	ireturn = f_get_name2('작업장', 'Y', sjocod, sjonm, sname)    //lRow이면 실패, 0이 성공	

   s_fjocod = string(trim(this.getitemstring(lrow, 'wkctr')), '@@@@@@')
	s_fwkctr = string(trim(this.getitemstring(lrow, 'ji_wkctr')), '@@@@@@')
   s_fjijo  = string(trim(this.getitemstring(lrow, 'ji_jocod')), '@@@@@@')
   s_fjocod = s_fjocod + s_fwkctr + s_fjijo
	
	if isnull(sjocod) then
		this.setitem(lRow, "wkctr", snull)			
		this.setitem(lRow, "jocod", snull)	
		this.setitem(lRow, "wrkctr_wa_wcdsc", snull)	
		this.setitem(lRow, "jomast_a_jonam", snull)
		this.setitem(lrow, "abunam", snull)
		RETURN ireturn
	else
		lReturnRow = This.Find("sfind = '"+s_fjocod+"' ", 1, This.RowCount())
		IF (lRow <> lReturnRow) and (lReturnRow <> 0)		THEN
			f_message_chk(37,'[조코드]') 
			this.setitem(lRow, "wkctr", snull)			
			this.setitem(lRow, "jocod", snull)	
			this.setitem(lRow, "wrkctr_wa_wcdsc", snull)	
			this.setitem(lRow, "jomast_a_jonam", snull)
			this.setitem(lrow, "abunam", snull)
			RETURN  1
		END IF
			this.setitem(lRow, "jocod", sname)	
			this.setitem(lRow, "wrkctr_wa_wcdsc", sjonm)	
			stemp = sname
			ixreturn = f_get_name2('조', 'N', stemp, sjonm, sname)    //lRow이면 실패, 0이 성공	
			this.setitem(lRow, "jomast_a_jonam", sjonm)

			select dptno into :scvcod
			  from jomast
			 where jocod = :sname;
			select cvnas into :sbunam
			  from vndmst
			 where cvcod = :sCvcod;
			this.setitem(lRow, "abunam", sBunam)
			
		RETURN ireturn
   end if
ELSEIF this.GetColumnName() = "ji_wkctr"	THEN
	swkctr = trim(this.gettext())
	ireturn = f_get_name2('작업장', 'Y', swkctr, swknm, sjocod)

	this.setitem(lRow, "ji_wkctr", swkctr)	
	this.setitem(lRow, "wrkctr_wb_wcdsc", swknm)	
	this.setitem(lRow, "ji_jocod", sjocod)	
	
	if isnull(swkctr) then
			this.setitem(lRow, "ji_wkctr", snull)	
			this.setitem(lRow, "wrkctr_wb_wcdsc", snull)	
			this.setitem(lRow, "jomast_b_jonam", snull)			
			this.setitem(lRow, "ji_jocod", snull)	
			this.setitem(lrow, "bbunam", snull)		
   	RETURN ireturn
	else
		s_fjocod = string(trim(this.getitemstring(lrow, 'jocod')), '@@@@@@')
   	s_fwkctr = string(trim(this.getitemstring(lrow, 'ji_wkctr')), '@@@@@@')
		s_fjijo  = string(trim(this.getitemstring(lrow, 'ji_jocod')), '@@@@@@')
		s_fjocod = s_fjocod + s_fwkctr + s_fjijo

		lReturnRow = This.Find("sfind = '"+s_fjocod+"' ", 1, This.RowCount())
		IF (lRow <> lReturnRow) and (lReturnRow <> 0)		THEN
			f_message_chk(37,'[작업장코드]') 
			this.setitem(lRow, "ji_wkctr", snull)	
			this.setitem(lRow, "wrkctr_wb_wcdsc", snull)	
			this.setitem(lRow, "jomast_b_jonam", snull)			
			this.setitem(lRow, "ji_jocod", snull)	
			this.setitem(lrow, "bbunam", snull)
			RETURN  1
		END IF
	   
		SELECT "JOMAST"."JONAM"  
		  INTO :sjonm  
		  FROM "JOMAST"  
		 WHERE "JOMAST"."JOCOD" = :sjocod   ;

		this.setitem(lRow, "jomast_b_jonam", sjonm)		
			select dptno into :scvcod
			  from jomast
			 where jocod = :sjocod;
			select cvnas into :sbunam
			  from vndmst
			 where cvcod = :sCvcod;
			this.setitem(lRow, "bbunam", sBunam)
	end if	
ELSEIF this.GetColumnName() = "ji_inwon"	THEN
	i_inwon = integer(this.gettext())
   if isnull(i_inwon) or i_inwon = 0 then 
		dw_insert.setitem(lrow, 'ji_time', 0)
		return 
   end if 
 	if wf_settime(lrow, '') = -1 then return 1
ELSEIF this.GetColumnName() = "ji_from"	THEN
   if isnull(trim(this.gettext())) or trim(this.gettext()) = "" or &
	   integer(trim(this.gettext())) = 0 then 
		dw_insert.setitem(lrow, 'ji_time', 0)
		return 
   end if 
 	if wf_settime(lrow, 'FROM') = -1 then return 1
    p_print.PostEvent(Clicked!)
ELSEIF this.GetColumnName() = "ji_to"	THEN
   if isnull(trim(this.gettext())) or trim(this.gettext()) = "" or &
	   integer(trim(this.gettext())) = 0 then 
		dw_insert.setitem(lrow, 'ji_time', 0)
		return 
	end if	
 	if wf_settime(lrow, 'TO') = -1 then	return 1
   p_print.PostEvent(Clicked!)
//ELSEIF this.GetColumnName() = "ji_time"	THEN
//	i_time = integer(this.gettext())
//	
//   if isnull(i_time) or i_time = 0 then return 
//	IF i_time < 0 or i_time > 1440 then 
//  		f_message_chk(63,'[지원총시간]') 
// 	   if wf_settime(lrow, '') = -1 then return 1
//		RETURN  1
//	END IF
ELSEIF this.GetColumnName() = 'empno' THEN

	sEmpno = this.gettext()
	
   ireturn = f_get_name2('사번', 'Y', sEmpno, sEmpnm, sname2)	 
	this.setitem(lrow, "empno",   sEmpno)
	this.setitem(lrow, "empname", sEmpnm)
   return ireturn 	 

END IF

end event

event dw_insert::itemerror;return 1
end event

event dw_insert::rbuttondown;int    lrow

setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)

lRow = this.getrow()

IF this.GetColumnName() = "ji_wkctr"	THEN
	open(w_workplace_popup)
	if isnull(gs_code) or gs_code = "" then return
	this.SetItem(lRow, "ji_wkctr", 	 gs_Code)
   this.TriggerEvent(ItemChanged!)
elseIF this.GetColumnName() = "wkctr"	THEN
	open(w_workplace_popup)
	if isnull(gs_code) or gs_code = "" then return
	this.SetItem(lRow, "wkctr", 	 gs_Code)
   this.TriggerEvent(ItemChanged!)
elseIF this.GetColumnName() = 'empno'	THEN
	
	this.accepttext()

	Open(w_sawon_popup)

	IF gs_code = '' or isnull(gs_code) then return 

	SetItem(lrow, "empno", gs_code)
	SetItem(lrow, "empname", gs_codename)
END IF
end event

type p_delrow from w_inherite`p_delrow within w_pdt_02170
integer y = 5000
end type

type p_addrow from w_inherite`p_addrow within w_pdt_02170
integer y = 5000
end type

type p_search from w_inherite`p_search within w_pdt_02170
integer y = 5000
end type

type p_ins from w_inherite`p_ins within w_pdt_02170
integer x = 3749
end type

event p_ins::clicked;call super::clicked;int  i, il_currow, il_rowcount
string sdate

if dw_1.AcceptText() = -1 then return 

sdate = trim(dw_1.GetItemString(1,'sdate'))

if isnull(sdate) or sdate = "" then
	f_message_chk(30,'[지원일자]')
	dw_1.SetFocus()
	return
end if	

FOR i = 1 TO dw_insert.RowCount()
	IF wf_required_chk(i) = -1 THEN RETURN
NEXT

IF dw_insert.RowCount() <=0 THEN
	il_currow = 0
	il_rowCount = 0
ELSE
	il_currow = dw_insert.GetRow()
	il_RowCount = dw_insert.RowCount()
	
	IF il_currow <=0 THEN
		il_currow = il_RowCount
	END IF
END IF

il_currow = il_currow + 1
dw_insert.InsertRow(il_currow)

dw_insert.setitem(il_currow, 'sabu', gs_sabu )
dw_insert.setitem(il_currow, 'jidat', sdate )

dw_insert.ScrollToRow(il_currow)
dw_insert.SetColumn('jocod')
dw_insert.SetFocus()
	


end event

type p_exit from w_inherite`p_exit within w_pdt_02170
end type

type p_can from w_inherite`p_can within w_pdt_02170
end type

event p_can::clicked;call super::clicked;dw_insert.SetReDraw(false)
dw_1.SetReDraw(false)
dw_insert.ReSet()
dw_1.reset()
dw_1.insertrow(0)
dw_1.SetFocus()
dw_1.SetRedraw(true)
dw_insert.SetRedraw(true)

ib_any_typing = FALSE



end event

type p_print from w_inherite`p_print within w_pdt_02170
boolean visible = false
integer x = 2487
integer y = 16
end type

event p_print::clicked;call super::clicked;if  isnull(ls_format) then
    dw_insert.setitem(dw_insert.getrow(), "ji_to", ls_tformat)	
elseIF isnull(ls_tformat) then
    dw_insert.setitem(dw_insert.getrow(), "ji_from", ls_format)	
end if
end event

type p_inq from w_inherite`p_inq within w_pdt_02170
integer x = 3575
end type

event p_inq::clicked;call super::clicked;string s_date

if dw_1.AcceptText() = -1 then return 

s_date = trim(dw_1.GetItemString(1,'sdate'))

if isnull(s_date) or s_date = "" then
	f_message_chk(30,'[지원일자]')
	dw_1.SetFocus()
	return
end if	

ib_any_typing = FALSE

if dw_insert.Retrieve(gs_sabu, s_date) <= 0 then 
	p_ins.Setfocus()
	return
else
	dw_insert.SetFocus()
   dw_insert.SetColumn('jocod')
end if	


end event

type p_del from w_inherite`p_del within w_pdt_02170
end type

event p_del::clicked;call super::clicked;Integer i, irow, irow2

dw_insert.AcceptText()

if dw_insert.rowcount() <= 0 then return 

irow = dw_insert.getrow() - 1
irow2 = dw_insert.getrow() + 1
if irow > 0 then   
	FOR i = 1 TO irow
		IF wf_required_chk(i) = -1 THEN RETURN
	NEXT
end if	

FOR i = irow2 TO dw_insert.RowCount()
	IF wf_required_chk(i) = -1 THEN RETURN
NEXT

if f_msg_delete() = -1 then return

dw_insert.SetRedraw(FALSE)

dw_insert.DeleteRow(0)

if dw_insert.Update() = 1 then
	w_mdi_frame.sle_msg.text =	"자료를 삭제하였습니다!!"	
	ib_any_typing = false
	commit ;
else
	rollback ;
end if	
dw_insert.SetRedraw(TRUE)


end event

type p_mod from w_inherite`p_mod within w_pdt_02170
end type

event p_mod::clicked;call super::clicked;long i

if dw_insert.AcceptText() = -1 then return 

if dw_insert.rowcount() <= 0 then
	return 
end if	

FOR i = 1 TO dw_insert.RowCount()
	IF wf_required_chk(i) = -1 THEN RETURN
NEXT

if f_msg_update() = -1 then return
	
if dw_insert.update() = 1 then
	w_mdi_frame.sle_msg.text = "자료가 저장되었습니다!!"
	ib_any_typing= FALSE
	commit ;
else
	rollback ;
	return 
end if	
		

end event

type cb_exit from w_inherite`cb_exit within w_pdt_02170
integer x = 2336
integer y = 5000
end type

type cb_mod from w_inherite`cb_mod within w_pdt_02170
integer x = 2693
integer y = 5000
integer taborder = 60
end type

type cb_ins from w_inherite`cb_ins within w_pdt_02170
integer x = 3031
integer y = 5000
integer taborder = 40
string text = "추가(&A)"
end type

type cb_del from w_inherite`cb_del within w_pdt_02170
integer x = 3054
integer y = 5000
integer taborder = 70
end type

type cb_inq from w_inherite`cb_inq within w_pdt_02170
integer x = 2674
integer y = 5000
integer taborder = 30
end type

type cb_print from w_inherite`cb_print within w_pdt_02170
integer x = 1984
integer y = 24
end type

type st_1 from w_inherite`st_1 within w_pdt_02170
end type

type cb_can from w_inherite`cb_can within w_pdt_02170
integer x = 1993
integer y = 5000
integer taborder = 80
end type

type cb_search from w_inherite`cb_search within w_pdt_02170
integer x = 1221
integer y = 2468
integer width = 549
integer taborder = 50
boolean enabled = false
string text = "지원이력 현황"
end type





type gb_10 from w_inherite`gb_10 within w_pdt_02170
integer y = 5000
integer height = 144
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

type gb_button1 from w_inherite`gb_button1 within w_pdt_02170
end type

type gb_button2 from w_inherite`gb_button2 within w_pdt_02170
end type

type gb_1 from groupbox within w_pdt_02170
boolean visible = false
integer x = 1202
integer y = 2416
integer width = 649
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

type dw_1 from datawindow within w_pdt_02170
event ue_pressenter pbm_dwnprocessenter
integer x = 32
integer y = 32
integer width = 837
integer height = 164
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pdt_02170_a"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemchanged;string sdate, snull

setnull(snull)

IF THIS.AcceptText() = -1 THEN RETURN
	
sdate = trim(this.GetText())

if sdate = "" or isnull(sdate) then
   dw_insert.SetReDraw(false)
	dw_insert.reset()
   dw_insert.SetReDraw(true)
	return 
end if

IF f_datechk(sdate) = -1	then
	f_message_chk(35, '[지원일자]')
	this.setitem(1, "sdate", sNull)
   dw_insert.SetReDraw(false)
	dw_insert.reset()
   dw_insert.SetReDraw(true)
	return 1
END IF

if dw_insert.Retrieve(gs_sabu, sdate) <= 0 then
	p_ins.SetFocus()
else
	dw_insert.SetFocus()	
end if	
	
	
	
end event

event itemerror;return 1
end event

type pb_1 from u_pb_cal within w_pdt_02170
integer x = 699
integer y = 76
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_1.Setcolumn('sdate')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_1.SetItem(1, 'sdate', gs_code)
end event

type rr_1 from roundrectangle within w_pdt_02170
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 208
integer width = 4585
integer height = 2076
integer cornerheight = 40
integer cornerwidth = 55
end type

