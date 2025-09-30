$PBExportHeader$w_imt_04040.srw
$PBExportComments$LOCAL매입마감
forward
global type w_imt_04040 from window
end type
type pb_3 from u_pb_cal within w_imt_04040
end type
type pb_2 from u_pb_cal within w_imt_04040
end type
type pb_1 from u_pb_cal within w_imt_04040
end type
type st_1 from statictext within w_imt_04040
end type
type p_exit from uo_picture within w_imt_04040
end type
type p_cancel from uo_picture within w_imt_04040
end type
type p_delete from uo_picture within w_imt_04040
end type
type p_save from uo_picture within w_imt_04040
end type
type p_retrieve from uo_picture within w_imt_04040
end type
type dw_1 from datawindow within w_imt_04040
end type
type rb_3 from radiobutton within w_imt_04040
end type
type dw_hist from datawindow within w_imt_04040
end type
type dw_detail from datawindow within w_imt_04040
end type
type rb_1 from radiobutton within w_imt_04040
end type
type rr_1 from roundrectangle within w_imt_04040
end type
type rr_2 from roundrectangle within w_imt_04040
end type
end forward

shared variables

end variables

global type w_imt_04040 from window
integer width = 4658
integer height = 2440
boolean titlebar = true
string title = "LOCAL입고 마감 - 거래처"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 32106727
pb_3 pb_3
pb_2 pb_2
pb_1 pb_1
st_1 st_1
p_exit p_exit
p_cancel p_cancel
p_delete p_delete
p_save p_save
p_retrieve p_retrieve
dw_1 dw_1
rb_3 rb_3
dw_hist dw_hist
dw_detail dw_detail
rb_1 rb_1
rr_1 rr_1
rr_2 rr_2
end type
global w_imt_04040 w_imt_04040

type variables
char  ic_status
string is_Date

String     is_today              //시작일자
String     is_totime             //시작시간
String     is_window_id      //윈도우 ID
String     is_usegub           //이력관리 여부
end variables

forward prototypes
public function integer wf_initial ()
end prototypes

public function integer wf_initial ();string snull, syymm

setnull(snull)

dw_detail.setredraw(false)
dw_detail.reset()
dw_hist.reset()

p_delete.enabled = false
p_delete.PictureName = "C:\erpman\image\삭제_d.gif"
dw_detail.enabled = TRUE
dw_detail.insertrow(0)

////////////////////////////////////////////////////////////////////////

f_mod_saupj(dw_detail,'saupj')

IF ic_status = '1'	then

	// 등록시	
	dw_detail.setcolumn("mayymm")
	dw_detail.SetItem(1, "mayymm", left(is_date,6))
	dw_detail.SetItem(1, "mayysq",    0)
	dw_detail.SetItem(1, "mastdat",  left(is_date,6) + '01')
	dw_detail.SetItem(1, "maeddat",  is_Date)
	dw_detail.SetItem(1, "crtdat",   is_Date)	
	dw_detail.setitem(1, "gbn", 'N')
	dw_detail.setitem(1, "sabu", gs_sabu)
ELSE

	dw_detail.setcolumn("mayymm")
	
	syymm = left(is_date, 6) 
	
	dw_detail.SetItem(1, "mayymm", syymm)
	dw_detail.setitem(1, "gbn", 'Y')	
END IF

dw_detail.setfocus()

dw_detail.setredraw(true)

return  1

end function

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


/////////////////////////////////////////////////////////////////////////////
dw_detail.settransobject(sqlca)
dw_hist.settransobject(sqlca)

dw_1.settransobject(sqlca)
dw_1.retrieve(gs_sabu)

is_Date = f_Today()

p_cancel.TriggerEvent("clicked")


end event

on w_imt_04040.create
this.pb_3=create pb_3
this.pb_2=create pb_2
this.pb_1=create pb_1
this.st_1=create st_1
this.p_exit=create p_exit
this.p_cancel=create p_cancel
this.p_delete=create p_delete
this.p_save=create p_save
this.p_retrieve=create p_retrieve
this.dw_1=create dw_1
this.rb_3=create rb_3
this.dw_hist=create dw_hist
this.dw_detail=create dw_detail
this.rb_1=create rb_1
this.rr_1=create rr_1
this.rr_2=create rr_2
this.Control[]={this.pb_3,&
this.pb_2,&
this.pb_1,&
this.st_1,&
this.p_exit,&
this.p_cancel,&
this.p_delete,&
this.p_save,&
this.p_retrieve,&
this.dw_1,&
this.rb_3,&
this.dw_hist,&
this.dw_detail,&
this.rb_1,&
this.rr_1,&
this.rr_2}
end on

on w_imt_04040.destroy
destroy(this.pb_3)
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.st_1)
destroy(this.p_exit)
destroy(this.p_cancel)
destroy(this.p_delete)
destroy(this.p_save)
destroy(this.p_retrieve)
destroy(this.dw_1)
destroy(this.rb_3)
destroy(this.dw_hist)
destroy(this.dw_detail)
destroy(this.rb_1)
destroy(this.rr_1)
destroy(this.rr_2)
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

type pb_3 from u_pb_cal within w_imt_04040
integer x = 2034
integer y = 348
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_detail.SetColumn('maeddat')
IF IsNull(gs_code) THEN Return
ll_row = dw_detail.GetRow()
If ll_row < 1 Then Return
dw_detail.SetItem(ll_row, 'maeddat', gs_code)



end event

type pb_2 from u_pb_cal within w_imt_04040
integer x = 2830
integer y = 268
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_detail.SetColumn('crtdat')
IF IsNull(gs_code) THEN Return
ll_row = dw_detail.GetRow()
If ll_row < 1 Then Return
dw_detail.SetItem(ll_row, 'crtdat', gs_code)



end event

type pb_1 from u_pb_cal within w_imt_04040
integer x = 1559
integer y = 348
integer taborder = 10
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_detail.SetColumn('mastdat')
IF IsNull(gs_code) THEN Return
ll_row = dw_detail.GetRow()
If ll_row < 1 Then Return
dw_detail.SetItem(ll_row, 'mastdat', gs_code)



end event

type st_1 from statictext within w_imt_04040
integer x = 2240
integer y = 36
integer width = 818
integer height = 108
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33554431
string text = "※ L/C-No를 입력하면 마감대상     내역이 조회됩니다."
boolean focusrectangle = false
end type

type p_exit from uo_picture within w_imt_04040
integer x = 4407
integer y = 20
integer width = 178
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;close(parent)
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\닫기_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\닫기_dn.gif'
end event

type p_cancel from uo_picture within w_imt_04040
integer x = 4233
integer y = 20
integer width = 178
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event clicked;call super::clicked;Rollback;
rb_1.checked = true

rb_1.TriggerEvent("clicked")
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\취소_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\취소_dn.gif'
end event

type p_delete from uo_picture within w_imt_04040
integer x = 4059
integer y = 20
integer width = 178
string pointer = "C:\erpman\cur\delete.cur"
boolean enabled = false
string picturename = "C:\erpman\image\삭제_d.gif"
end type

event clicked;call super::clicked;Long lrow, lcnt
String sMayymm, sCvcod, sDelgu, snull
Integer iseq

SetPointer(HourGlass!)

IF dw_detail.AcceptText() = -1		THEN	RETURN
IF dw_hist.AcceptText() = -1		THEN	RETURN

If Messagebox("삭제확인", "선택한 마감내역을 삭제 하시겠읍니까?", question!, yesno!, 2) = 2 then
	return
end if

setnull(snull)

// 입고이력을 기준으로 공급가액을 생성
For lrow = 1 to dw_hist.rowcount() 
	 dw_hist.setitem(lrow, "imhist_mayymm", snull)
	 dw_hist.setitem(lrow, "imhist_mayysq", 0)
	 dw_hist.setitem(lrow, "imhist_chaamt", 0)  //차이금액 (끝전)
next

dw_detail.setredraw(False)
dw_detail.deleterow(0)
if dw_detail.update() = 1 and dw_hist.update() = 1 then
	commit;
	Messagebox("삭제완료", "삭제되었읍니다", information!)
	p_cancel.TriggerEvent("clicked")	
else
	rollback;
	f_rollback()
	p_cancel.TriggerEvent("clicked")
end if


end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\삭제_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\삭제_dn.gif'
end event

type p_save from uo_picture within w_imt_04040
integer x = 3886
integer y = 20
integer width = 178
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event clicked;SetPointer(HourGlass!)

IF dw_hist.AcceptText() = -1		THEN	RETURN
IF dw_detail.AcceptText() = -1		THEN	RETURN

//유효값 check
long gseq, lrow, i, lcount
string syymm, schk, scvcod, spolcno, ssdat, sedat, scurr, ssaupj
decimal {2} dprate, dwaiamt, damt, dmaamt, dMamt, dchamt   
decimal {5} dprice

lcount = dw_hist.rowcount()
if lcount < 1 then return -1 

syymm 	= dw_detail.getitemstring(1, "mayymm")
scvcod 	= dw_detail.getitemstring(1, "cvcod")
spolcno 	= dw_detail.getitemstring(1, "polcno")
ssdat 	= dw_detail.getitemstring(1, "mastdat")
sedat 	= dw_detail.getitemstring(1, "maeddat")
scurr 	= dw_detail.getitemstring(1, "pocurr")
ssaupj 	= dw_detail.getitemstring(1, "saupj")

dprate 	= dw_detail.getitemdecimal(1, "prate")
dMamt 	= dw_detail.getitemdecimal(1, "maamt")

IF f_msg_update() = -1 	THEN
   Rollback;
	RETURN
END IF

if isnull(Syymm) or trim(syymm) = '' then
	f_message_chk(30,'[마감년월]')		
	dw_detail.setcolumn("mayymm")
	dw_detail.setfocus()
	return
end if

if isnull(Spolcno) or trim(spolcno) = '' then
	f_message_chk(30,'[L/C-NO]')		
	dw_detail.setcolumn("polcno")
	dw_detail.setfocus()
	return
end if

if isnull(Scvcod) or trim(scvcod) = '' then
	f_message_chk(30,'[거래처]')		
	dw_detail.setcolumn("cvcod")
	dw_detail.setfocus()
	return
end if

if isnull(Ssdat) or trim(ssdat) = '' then
	f_message_chk(30,'[입고기간 FROM]')		
	dw_detail.setcolumn("mastdat")
	dw_detail.setfocus()
	return
end if

if isnull(Sedat) or trim(sedat) = '' then
	f_message_chk(30,'[입고기간 TO]')		
	dw_detail.setcolumn("maeddat")
	dw_detail.setfocus()
	return
end if

if scurr <> 'WON' and  (isnull(dprate) or dprate = 0) then
	f_message_chk(30,'[적용환율]')		
	dw_detail.setcolumn("prate")
	dw_detail.setfocus()
	return
end if

if isnull(dmamt) or dmamt = 0 then
	f_message_chk(30,'[공급가액]')		
	dw_detail.setcolumn("maamt")
	dw_detail.setfocus()
	return
else
	dmaamt  = dw_hist.getitemdecimal(1, "tot_maamt") 
   dchamt  = dMamt - dmaamt
	
	if dchamt <> 0 then 
		if messagebox('확 인', '차이금액 ' + string(dchamt, '###,###,###,##0.00') + &
            ' 발생하였습니다. 끝전 처리를 하시겠습니까?', Exclamation!, YesNo!, 1) = 2 then 
			return
		end if
	end if
end if

if scurr = 'WON' then  // 원화인 경우에는 적용환율을 0으로 한다
	dw_detail.setitem(1, "prate", 0)
end if

/* 마감차수 생성 */
gseq = sqlca.fun_junpyo(gs_sabu, syymm, 'M0'); 

IF gseq <= 0 THEN 
	Rollback;
	f_message_chk(51,'[마감순번]')		
	Return;
END IF;  

dw_detail.setitem(1, "mayysq", gseq)

dwaiamt = 0

// 입고이력을 기준으로 공급가액을 생성
For lrow = 1 to lcount
	 if dw_hist.getitemstring(Lrow, "sel") = 'N' then continue
	 
	 i ++
	 
 	 if dw_hist.getitemstring(lrow, 'imhist_saupj') <> sSaupj then 
	 	 Rollback;
		 messagebox('확 인', '마감 사업장과 입고 사업장이 다릅니다. 사업장을 확인하세요!')
		 dw_hist.ScrollToRow(lrow)
		 dw_hist.setfocus()
		 return 
	 END IF
	 
	 dw_hist.setitem(lrow, "imhist_yebi2", scurr)
	 dw_hist.setitem(lrow, "imhist_mayymm", syymm)
	 dw_hist.setitem(lrow, "imhist_mayysq", gseq)

	 dprice = dw_hist.getitemdecimal(lrow, "imhist_dyebi2") 
	 
	 //외화금액 누적
	 dwaiamt = dwaiamt + (dprice * dw_hist.getitemdecimal(Lrow, "imhist_iosuqty"))
	 
	 //끝전 처리 -> 승인시에는 끝전과 금액에 모두 더하고 
	 //             미승인시에는 끝전에만 금액을 더한다.
	 if dchamt <> 0 and i = 1 then 
		 if dw_hist.getitemstring(lrow, 'imhist_io_date') = '' or &
			 isnull(dw_hist.getitemstring(lrow, 'imhist_io_date')) then 
			 dw_hist.setitem(lrow, "imhist_chaamt", dchamt)
		 else
          damt = dw_hist.getitemdecimal(Lrow, "imhist_ioamt")			
			 dw_hist.setitem(lrow, "imhist_ioamt", damt + dchamt)
			 dw_hist.setitem(lrow, "imhist_chaamt", dchamt)
		 end if
	 elseif dchamt = 0 and i = 1 then 
			 dw_hist.setitem(lrow, "imhist_chaamt", 0)
	 end if	 
	
next

if i < 1 then 
   Rollback;
	messagebox('확 인', '입고자료를 선택하세요!')
	dw_hist.setfocus()
	return 
end if

dw_detail.setitem(1, "pwaiamt", dwaiamt)

if dw_detail.update() = 1 and dw_hist.update() = 1 then
	commit;
	Messagebox("저장", "저장이 완료되었읍니다", information!)
	p_cancel.TriggerEvent("clicked")	
else
	rollback;
	f_rollback()
	p_cancel.TriggerEvent("clicked")
end if


end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\저장_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\저장_dn.gif'
end event

type p_retrieve from uo_picture within w_imt_04040
integer x = 3712
integer y = 20
integer width = 178
string pointer = "C:\erpman\cur\retrieve.cur"
boolean enabled = false
string picturename = "C:\erpman\image\조회_d.gif"
end type

event clicked;string	sYearMonth, 	&
			sTitle,	sNull, sError, smagam, smove_yn
Double	diseq, dcnt
long		lRow, lRowCount
int		iSeq

if dw_detail.AcceptText() = -1 then return 

////////////////////////////////////////////////////////////////////////////

sYearMonth = trim(dw_detail.GetItemString(1, "mayymm"))
iSeq		  = dw_detail.GetItemNumber(1, "mayysq")
//scvcod 	  = trim(dw_detail.GetItemString(1, "cvcod"))
smove_yn   = trim(dw_detail.GetItemString(1, "move_yn"))

IF isnull(sYearMonth) or sYearMonth = "" 	THEN
	f_message_chk(30,'[마감년월]')
	dw_detail.SetColumn("mayymm")
	dw_detail.SetFocus()
	RETURN
END IF

IF isnull(iSeq) or iSeq = 0 	THEN
	f_message_chk(30,'[마감순번]')
	dw_detail.SetColumn("mayysq")
	dw_detail.SetFocus()
	RETURN
END IF

//IF isnull(scvcod) or scvcod = "" 	THEN
//	f_message_chk(30,'[거래처]')
//	dw_detail.SetColumn("cvcod")
//	dw_detail.SetFocus()
//	RETURN
//END IF
//	

// 수불마감여부 확인
SELECT MAX(JPDAT) into :smagam
  FROM JUNPYO_CLOSING 
 WHERE SABU = :gs_sabu AND JPGU = 'C0';
 
if smagam >= left(syearmonth, 6) then
	Messagebox("수불마감", "해당일자는 수불마감되어 있는 월입니다", stopsign!)
	dw_detail.setitem(1, "mayymm", sNull)
	return 1		
end if			 

// 전송여부 확인
if smove_yn = 'Y' then
	Messagebox("전송마감", "회계로 전송된 내역입니다", stopsign!)
	dw_detail.setitem(1, "mayymm", sNull)
	return 1		
end if			 

// 인수증이 발행된 계산서 내역은 수정할 수 없음
dcnt = 0
Select count(*) into :dcnt
  From imhist 
 where sabu 	= :gs_sabu And mayymm = :syearmonth And mayysq = :iseq
 	and poblno  is not null;
	 
if dcnt > 0 then
	Messagebox("인수증", "해당계산서는 인수증이 발행되었읍니다", stopsign!)
	dw_detail.setitem(1, "mayymm", sNull)
	return 1		
end if			 	 

dw_detail.setredraw(false)

if dw_detail.retrieve(gs_sabu, sYearmonth, iseq) < 1 then
	f_message_chk(50, '[ LOCAL마감 ]')
	p_cancel.triggerevent(clicked!)
	return
end if

if dw_detail.getitemstring(1, "magubn") <> '3' then
	Messagebox("LOCAL마감", "LOCAL마감내역이 아닙니다.", stopsign!)
	p_cancel.triggerevent(clicked!)
	return
end if			 

// 입고내역 조회
dw_hist.retrieve(gs_sabu, syearmonth, iseq)

dw_detail.enabled = false

p_retrieve.enabled = false
p_delete.enabled = true
p_retrieve.PictureName = "C:\erpman\image\조회_d.gif"
p_delete.PictureName = "C:\erpman\image\삭제_up.gif"

dw_detail.setredraw(true)
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\조회_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\조회_dn.gif'
end event

type dw_1 from datawindow within w_imt_04040
integer x = 859
integer y = 76
integer width = 1138
integer height = 80
string dataobject = "d_imt_04040_3"
boolean border = false
boolean livescroll = true
end type

type rb_3 from radiobutton within w_imt_04040
integer x = 457
integer y = 52
integer width = 347
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "마감취소"
end type

event clicked;
ic_status = '2'

p_retrieve.enabled = true
p_save.enabled = false

p_retrieve.PictureName = "C:\erpman\image\조회_up.gif"
p_save.PictureName = "C:\erpman\image\저장_d.gif"

dw_hist.dataobject = "d_imt_04040_2"
dw_hist.settransobject(sqlca)

wf_initial()

end event

type dw_hist from datawindow within w_imt_04040
event ue_pressenter pbm_dwnprocessenter
integer x = 55
integer y = 472
integer width = 4517
integer height = 1820
integer taborder = 30
string dataobject = "d_imt_04040_1"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemerror;return 1
end event

event itemchanged;dec{4}  dRate
dec{3}  dQty
dec{2}  damt, dMamt
dec{5}  dPrice, dFprc, dcnvfat 
long    lRow
string  sIodate, sOpt, scnvart, sCurr, sSaupj 

lRow = this.GetRow()

IF this.getcolumnname() = "sel"		THEN
   sOpt = this.gettext()	
	
	if sOpt = 'Y' then 
   	dw_detail.AcceptText()
   	dRate  = dw_detail.GetItemDecimal(1, "prate") //적용환율
   	dMamt  = dw_detail.GetItemDecimal(1, "maamt") //공급가액
      scurr  = dw_detail.Getitemstring(1, "pocurr")
      sSaupj = dw_detail.Getitemstring(1, "saupj")
		if sSaupj = '' or isnull(sSaupj) then 
			messagebox('확 인', '사업장을 먼저 입력하세요!')
			dw_detail.setcolumn('saupj')
			dw_detail.setfocus()
			return 1
		else
			if this.getitemstring(lrow, 'imhist_saupj') <> sSaupj then 
				messagebox('확 인', '마감 사업장과 입고 사업장이 다릅니다. 사업장을 확인하세요!')
				return 1
			END IF
      end if	  
		IF scurr <> 'WON' and  (isnull(drate) or drate = 0) then
			messagebox('확 인', '적용환율을 먼저 입력하세요!')
			dw_detail.setcolumn('prate')
			dw_detail.setfocus()
			return 1
		END IF
		IF isnull(dMamt) or dMamt = 0 then
			messagebox('확 인', '공급가액을 먼저 입력하세요')
			dw_detail.setcolumn('maamt')
			dw_detail.setfocus()
			return 1
		END IF
		
		this.setitem(lrow, 'imhist_dyebi1', drate) 
		
		 // 변환계수 적용
		 scnvart = dw_hist.getitemstring(Lrow, "imhist_cnvart")
		 dcnvfat = dw_hist.getitemdecimal(Lrow, "imhist_cnvfat")
		 
		 if dcnvfat = 1 then
			 dfprc = dw_hist.getitemdecimal(lrow, "polcdt_lcprc") 
		 elseif scnvart = '*' then
			 dfprc = truncate(dw_hist.getitemdecimal(lrow, "polcdt_lcprc") / dcnvfat, 5)
		 else
			 dfprc = truncate(dw_hist.getitemdecimal(lrow, "polcdt_lcprc") * dcnvfat, 5)		
		 end if

		 if scurr = 'WON' then
			 dw_hist.setitem(lrow, "imhist_dyebi2", 0)
			 
	 		 dPrice = dfprc
			 dw_hist.setitem(lrow, "imhist_ioprc",  dPrice)
		 else
			 dw_hist.setitem(lrow, "imhist_dyebi2", dfprc)
			 
	 		 dPrice = Round(dfprc * drate, 5)  //단가는 반올림
			 dw_hist.setitem(lrow, "imhist_ioprc",  dPrice)		
		 end if

      sIodate = trim(THIS.getitemstring(Lrow, "imhist_io_date"))
		IF not (isnull(siodate) or siodate = '' ) then 
					
			dqty  = this.getitemdecimal(lrow, 'imhist_ioqty') //입고수량
			dAmt  = Truncate(dPrice * dqty, 0)  //금액은 절사
			this.setitem(lrow, 'imhist_ioamt', damt)
		
		End if
	else
		this.setitem(lrow, 'imhist_dyebi1', this.getitemdecimal(lrow, 'old_rate')) 
		this.setitem(lrow, 'imhist_ioprc', this.getitemdecimal(lrow, 'old_ioprc')) 
		this.setitem(lrow, 'imhist_ioamt', this.getitemdecimal(lrow, 'old_ioamt')) 
	end if
		
ELSEIF this.getcolumnname() = "imhist_dyebi1"	THEN
	drate = dec(this.gettext())

	dw_detail.AcceptText()
	scurr = dw_detail.Getitemstring(1, "pocurr")
  
	 // 변환계수 적용
	 scnvart = dw_hist.getitemstring(Lrow, "imhist_cnvart")
	 dcnvfat = dw_hist.getitemdecimal(Lrow, "imhist_cnvfat")
	 
	 if dcnvfat = 1 then
		 dfprc = dw_hist.getitemdecimal(lrow, "polcdt_lcprc") 
	 elseif scnvart = '*' then
		 dfprc = truncate(dw_hist.getitemdecimal(lrow, "polcdt_lcprc") / dcnvfat, 5)
	 else
		 dfprc = truncate(dw_hist.getitemdecimal(lrow, "polcdt_lcprc") * dcnvfat, 5)		
	 end if

	 if scurr = 'WON' then
		 dw_hist.setitem(lrow, "imhist_dyebi2", 0)
		 dPrice = dfprc
		 dw_hist.setitem(lrow, "imhist_ioprc",  dPrice)
	 else
		 dw_hist.setitem(lrow, "imhist_dyebi2", dfprc)
		 
		 dPrice = Round(dfprc * drate, 5)  //단가는 반올림
		 dw_hist.setitem(lrow, "imhist_ioprc",  dPrice)		
	 end if

	sIodate = trim(THIS.getitemstring(Lrow, "imhist_io_date"))
	IF not (isnull(siodate) or siodate = '' ) then 
				
		dqty  = this.getitemdecimal(lrow, 'imhist_ioqty') //입고수량
		dAmt  = Truncate(dPrice * dqty, 0)  //금액은 절사
		this.setitem(lrow, 'imhist_ioamt', damt)
	
	End if
ELSEIF this.getcolumnname() = "imhist_ioprc"		THEN
	dPrice = dec(this.gettext())

	this.setitem(lrow, 'imhist_ioprc', dPrice)

	sIodate = trim(THIS.getitemstring(Lrow, "imhist_io_date"))
	IF not (isnull(siodate) or siodate = '' ) then 
				
		dqty  = this.getitemdecimal(lrow, 'imhist_ioqty') //입고수량
		dAmt  = Truncate(dPrice * dqty, 0)  //금액은 절사
		this.setitem(lrow, 'imhist_ioamt', damt)
	
	End if
END IF

end event

event losefocus;this.accepttext()
end event

type dw_detail from datawindow within w_imt_04040
event ue_downenter pbm_dwnprocessenter
event ud_downkey pbm_dwnkey
integer x = 32
integer y = 172
integer width = 4567
integer height = 280
integer taborder = 10
string dataobject = "d_imt_04040"
boolean border = false
boolean livescroll = true
end type

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ud_downkey;
IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event rbuttondown;// 거래처
setnull(gs_code)
setnull(gs_codename)

IF this.GetColumnName() = 'cvcod'	THEN
   gs_gubun = '1'
	Open(w_vndmst_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1,"cvcod",  gs_code)
	this.triggerevent(itemchanged!)
	
	setnull(gs_code)	
ELSEIF this.GetColumnName() = 'mayysq'	THEN	
	gi_page = 0
	gs_code = '3'  // LOCAL
	
	open(w_imt_05000_1)
	
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	setitem(1, "mayymm", gs_code)
	setitem(1, "mayysq", gi_page)
	setitem(1, "cvcod", gs_codename)	
	setnull(gs_code)
	setnull(gs_codename)	
	gi_page = 0	
ELSEIF this.GetColumnName() = 'polcno'	THEN	
	gi_page = 0
	Gs_gubun = 'LOCAL'
	
	open(w_lc_popup)
	
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	setitem(1, "polcno", gs_code)
	
	this.triggerevent(itemchanged!)
	
	setnull(gs_code)
	gi_page = 0		
END IF

end event

event itemerror;return 1
end event

event itemchanged;string	sNull, sDate, sYYMM, sYm, SMAGAM, slocalyn, spolcno, scurr, scode, sname1, sname2
long     get_seq

SetNull(sNull)

smagam = dw_1.getitemstring(1, 'last_mayymm')
if smagam = '' or isnull(smagam) then smagam = '.'

// 마감년월
IF this.GetColumnName() = 'mayymm' THEN

	sYm   = trim(this.gettext())
	sYYMM = sYm + '01'
	IF f_datechk(sYYMM) = -1	then
		Messagebox("마감년월", "년월이 부정확합니다.", stopsign!)		
		this.setitem(1, "mayymm", left(is_today, 6))
		return 1
	END IF
	
 	if smagam >= left(syymm, 6) then
		Messagebox("수불마감", "해당일자는 수불마감되어 있는 월입니다", stopsign!)
		this.setitem(1, "mayymm", left(is_today, 6))
		return 1		
	end if			
	
END IF

// 마감일자
IF this.GetColumnName() = 'crtdat' THEN

	sYm   = trim(this.gettext())
	sYYMM = sYm 
	IF f_datechk(sYYMM) = -1	then
		Messagebox("마감일자", "일자가 부정확합니다.", stopsign!)		
		this.setitem(1, "crtdat", snull)
		return 1
	END IF
	
 	if smagam >= left(syymm, 6) then
		Messagebox("수불마감", "해당일자는 수불마감되어 있는 월입니다", stopsign!)
		this.setitem(1, "crtdat", snull)
		return 1		
	end if			
	
END IF

// 수입L/C-NO
IF this.getcolumnname() = 'polcno' then
	spolcno = this.gettext()
	
	Select a.localyn, a.pocurr, a.buyer, b.cvnas2 
	  into :slocalyn, :scurr, :scode, :sname1
	  from polchd a, vndmst b
	 where a.sabu = :gs_sabu and a.polcno = :spolcno
	   and a.buyer = b.cvcod;
		
	if sqlca.sqlcode <> 0 then
		Messagebox("L/C-NO", "L/C-NO가 부정확합니다", stopsign!)
		this.setitem(1, "polcno", snull)
		this.setitem(1, "pocurr", snull)		
		this.setitem(1, "cvcod", snull)
		this.setitem(1, "cvnas2", snull)		
		return 1
	end if
	
	if slocalyn = 'Y' then
	else
		Messagebox("L/C-NO", "LOCAL L/C만 등록이 가능합니다", stopsign!)
		this.setitem(1, "polcno", snull)
		this.setitem(1, "pocurr", snull)		
		this.setitem(1, "cvcod", snull)
		this.setitem(1, "cvnas2", snull)
		return 1
	end if
	
	if dw_hist.retrieve(gs_sabu, spolcno, smagam) < 1 then
		Messagebox("L/C-NO", "해당L/C에 대한 입고내역이 없읍니다", stopsign!)
		this.setitem(1, "polcno", snull)
		this.setitem(1, "pocurr", snull)		
		this.setitem(1, "cvcod", snull)
		this.setitem(1, "cvnas2", snull)
		return 1
	end if		
		
	this.setitem(1, "pocurr", scurr)
	this.setitem(1, "cvcod", scode)
	this.setitem(1, "cvnas2", sname1)			
end if

// 거래처
IF this.getcolumnname() = 'cvcod' then
	scode   = this.gettext()	
	get_seq = f_get_name2('V1','Y',scode,sname1,sname2)
	this.setitem(1, "cvcod", scode)
	this.setitem(1, "cvnas2", sname1)
	return get_seq
end if

// 마감시작일
IF this.GetColumnName() = 'mastdat' THEN

	sDate = trim(this.gettext())
	IF f_datechk(sDate) = -1	then
		Messagebox("입고일자", "입고일자가 부정확합니다.", stopsign!)		
		this.setitem(1, "mastdat", sNull)
		return 1
	END IF
	
	if smagam >= left(sdate, 6) then
		Messagebox("수불마감", "해당일자는 수불마감되어 있는 월입니다", stopsign!)
		this.setitem(1, "mastdat", sNull)
		return 1		
	end if		
	
END IF

// 마감종료일
IF this.GetColumnName() = 'maeddat' THEN

	sDate = trim(this.gettext())
	
	IF f_datechk(sDate) = -1	then
		Messagebox("입고일자", "입고일자가 부정확합니다.", stopsign!)		
		this.setitem(1, "maeddat", sNull)
		return 1
	END IF
	
	if smagam >= left(sdate, 6) then
		Messagebox("수불마감", "해당일자는 수불마감되어 있는 월입니다", stopsign!)
		this.setitem(1, "maeddat", sNull)
		return 1		
	end if			
END IF


end event

type rb_1 from radiobutton within w_imt_04040
integer x = 87
integer y = 52
integer width = 347
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "마감처리"
boolean checked = true
end type

event clicked;ic_status = '1'

p_retrieve.enabled = false
p_save.enabled = true

p_retrieve.PictureName = "C:\erpman\image\조회_d.gif"
p_save.PictureName = "C:\erpman\image\저장_up.gif"

dw_hist.dataobject = "d_imt_04040_1"
dw_hist.settransobject(sqlca)

wf_initial()

end event

type rr_1 from roundrectangle within w_imt_04040
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 46
integer y = 20
integer width = 791
integer height = 144
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_imt_04040
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 464
integer width = 4535
integer height = 1836
integer cornerheight = 40
integer cornerwidth = 55
end type

