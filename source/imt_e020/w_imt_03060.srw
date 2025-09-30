$PBExportHeader$w_imt_03060.srw
$PBExportComments$L/C 마감내역 조회
forward
global type w_imt_03060 from window
end type
type pb_2 from u_pb_cal within w_imt_03060
end type
type pb_1 from u_pb_cal within w_imt_03060
end type
type p_exit from uo_picture within w_imt_03060
end type
type p_retrieve from uo_picture within w_imt_03060
end type
type dw_1 from datawindow within w_imt_03060
end type
type dw_list from datawindow within w_imt_03060
end type
type rr_1 from roundrectangle within w_imt_03060
end type
end forward

shared variables

end variables

global type w_imt_03060 from window
integer width = 4658
integer height = 2440
boolean titlebar = true
string title = "L/C 마감내역 조회"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 32106727
pb_2 pb_2
pb_1 pb_1
p_exit p_exit
p_retrieve p_retrieve
dw_1 dw_1
dw_list dw_list
rr_1 rr_1
end type
global w_imt_03060 w_imt_03060

type variables
char  ic_status

String     is_today              //시작일자
String     is_totime             //시작시간
String     is_window_id      //윈도우 ID
String     is_usegub           //이력관리 여부
end variables

forward prototypes
public subroutine wf_reset ()
end prototypes

public subroutine wf_reset ();string snull
int    inull

setnull(snull)
setnull(inull)

dw_1.setitem(1, 'polcno', snull)
dw_1.setitem(1, 'polcgu', snull)
dw_1.setitem(1, 'poopbk', snull)
dw_1.setitem(1, 'polamt', inull)
dw_1.setitem(1, 'boamt', inull)
dw_1.setitem(1, 'pocurr', snull)
dw_1.setitem(1, 'buyer', snull)
dw_1.setitem(1, 'vndmst_cvnas2', snull)
dw_1.setitem(1, 'opndat', snull)
dw_1.setitem(1, 'lcmadat', snull)
dw_1.setitem(1, 'pomaga', snull)

end subroutine

event open;Integer  li_idx

li_idx = w_mdi_frame.dw_listbar.InsertRow(0)
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_id',Upper(This.ClassName()))
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_name',Upper(This.Title))
w_mdi_frame.Postevent("ue_barrefresh")

is_today = f_today()
is_totime = f_totime()
is_window_id = this.ClassName()

w_mdi_frame.st_window.Text = Upper(is_window_id)

dw_1.SetTransObject(SQLCA)
dw_1.Reset()
dw_1.InsertRow(0)

dw_list.settransobject(sqlca)

///////////////////////////////////////////////////////////////////////////
dw_1.settransobject(sqlca)
dw_list.settransobject(sqlca)

dw_1.insertrow(0)



end event

on w_imt_03060.create
this.pb_2=create pb_2
this.pb_1=create pb_1
this.p_exit=create p_exit
this.p_retrieve=create p_retrieve
this.dw_1=create dw_1
this.dw_list=create dw_list
this.rr_1=create rr_1
this.Control[]={this.pb_2,&
this.pb_1,&
this.p_exit,&
this.p_retrieve,&
this.dw_1,&
this.dw_list,&
this.rr_1}
end on

on w_imt_03060.destroy
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.p_exit)
destroy(this.p_retrieve)
destroy(this.dw_1)
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

type pb_2 from u_pb_cal within w_imt_03060
integer x = 3767
integer y = 260
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_1.SetColumn('lcmadat')
IF IsNull(gs_code) THEN Return
ll_row = dw_1.GetRow()
If ll_row < 1 Then Return
dw_1.SetItem(ll_row, 'lcmadat', gs_code)



end event

type pb_1 from u_pb_cal within w_imt_03060
integer x = 1710
integer y = 260
integer taborder = 10
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_1.SetColumn('opndat')
IF IsNull(gs_code) THEN Return
ll_row = dw_1.GetRow()
If ll_row < 1 Then Return
dw_1.SetItem(ll_row, 'opndat', gs_code)



end event

type p_exit from uo_picture within w_imt_03060
integer x = 4375
integer y = 16
integer width = 178
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;
close(parent)


end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\닫기_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\닫기_dn.gif'
end event

type p_retrieve from uo_picture within w_imt_03060
integer x = 4201
integer y = 16
integer width = 178
string pointer = "C:\erpman\cur\retrieve.cur"
boolean originalsize = true
string picturename = "C:\erpman\image\조회_up.gif"
end type

event clicked;call super::clicked;IF dw_1.AcceptText() = -1 THEN RETURN 

string	sLcno

sLcno = dw_1.GetItemString(1, "polcno")

IF isnull(sLcno) or sLcno = "" 	THEN
	f_message_chk(30,'[L/C - NO]')
	dw_1.SetColumn("polcno")
	dw_1.SetFocus()
	RETURN
END IF

IF dw_1.Retrieve(gs_sabu, sLcno) < 1 then 
	f_message_chk(50, '[마감내역]')
	dw_1.insertrow(0)
	dw_1.SetColumn("polcno")
	dw_1.setfocus()
	return 
END IF	

/////////////////////////////////////////////////////
IF dw_list.Retrieve(gs_sabu, sLcno) < 1		THEN
	f_message_chk(50, '[마감내역]')
	dw_1.SetColumn("polcno")
	dw_1.SetFocus()
	RETURN
END IF


end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\조회_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\조회_dn.gif'
end event

type dw_1 from datawindow within w_imt_03060
event ue_downenter pbm_dwnprocessenter
event ud_downkey pbm_dwnkey
integer x = 32
integer y = 172
integer width = 4567
integer height = 204
integer taborder = 10
string dataobject = "d_imt_03060"
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

event rbuttondown;gs_code = ''
gs_codename = ''
gs_gubun = ''


// lc번호
IF this.GetColumnName() = 'polcno'	THEN

	Open(w_lc_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return
	SetItem(1,"polcno",		gs_code)
   
	p_retrieve.TriggerEvent(Clicked!)
END IF
end event

event itemerror;return 1
end event

event itemchanged;string	sCode, sName,	&
			sNull

setnull(snull)

// L/C No
IF this.GetColumnName() = 'polcno' THEN

	sCode  = trim(this.gettext())

	if scode = '' or isnull(scode) then 
		wf_reset()
      dw_list.reset()
		return 
   end if
	
	SELECT "POLCHD"."POLCNO"  
     INTO :sName  
     FROM "POLCHD"  
    WHERE ( "POLCHD"."SABU" = :gs_sabu ) AND  
          ( "POLCHD"."POLCNO" = :scode )   ;

	IF sqlca.sqlcode <> 0 THEN
      F_message_chk(33, "[L/C No]")
		wf_reset()
      dw_list.reset()
		return 1
	ELSE	
		p_retrieve.TriggerEvent(Clicked!)
	   return 1
   END IF	
	
END IF

end event

event losefocus;this.accepttext()
end event

type dw_list from datawindow within w_imt_03060
event ue_downenter pbm_dwnprocessenter
integer x = 50
integer y = 396
integer width = 4507
integer height = 1888
integer taborder = 30
string dataobject = "d_imt_03061"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_imt_03060
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 388
integer width = 4526
integer height = 1908
integer cornerheight = 40
integer cornerwidth = 55
end type

