$PBExportHeader$w_qct_01005.srw
$PBExportComments$검사항목등록
forward
global type w_qct_01005 from window
end type
type rr_1 from roundrectangle within w_qct_01005
end type
type p_exit from uo_picture within w_qct_01005
end type
type p_can from uo_picture within w_qct_01005
end type
type p_mod from uo_picture within w_qct_01005
end type
type p_auto from uo_picture within w_qct_01005
end type
type p_inq from uo_picture within w_qct_01005
end type
type dw_list from datawindow within w_qct_01005
end type
type dw_detail from datawindow within w_qct_01005
end type
type dw_imhist from datawindow within w_qct_01005
end type
type dw_1 from datawindow within w_qct_01005
end type
type rr_2 from roundrectangle within w_qct_01005
end type
end forward

global type w_qct_01005 from window
integer width = 4640
integer height = 2440
boolean titlebar = true
string title = "검사항목 등록"
string menuname = "m_shortcut"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
windowstate windowstate = maximized!
long backcolor = 32106727
rr_1 rr_1
p_exit p_exit
p_can p_can
p_mod p_mod
p_auto p_auto
p_inq p_inq
dw_list dw_list
dw_detail dw_detail
dw_imhist dw_imhist
dw_1 dw_1
rr_2 rr_2
end type
global w_qct_01005 w_qct_01005

type variables
boolean ib_ItemError, ib_any_typing
char ic_status
string is_Date
int  ii_Last_Jpno

String     is_today              //시작일자
String     is_totime             //시작시간
String     is_window_id      //윈도우 ID
String     is_usegub           //이력관리 여부

str_itnct  lstr_itnct

datawindowchild idws

end variables

forward prototypes
public subroutine wf_init ()
end prototypes

public subroutine wf_init ();
dw_detail.SetRedraw(false)
ib_any_typing = FALSE

dw_1.reset()
dw_detail.reset()
dw_list.reset()

dw_1.insertrow(0)
dw_detail.insertrow(0)

dw_1.SetColumn("gubun")
dw_1.SetFocus()

//
dw_detail.SetRedraw(true)
dw_1.enabled = true


/* User별 사업장 Setting */
f_mod_saupj(dw_1,"porgu")

end subroutine

event open;Integer  li_idx

li_idx = w_mdi_frame.dw_listbar.InsertRow(0)
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_id',Upper(This.ClassName()))
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_name',Upper(This.Title))
w_mdi_frame.Postevent("ue_barrefresh")

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


//dw_detail.SetTransObject(sqlca)
dw_1.SetTransObject(sqlca)

dw_detail.getchild("grpno1", idws)

idws.settransobject(sqlca)

if idws.retrieve('1') < 1 then 
	idws.reset()
	idws.insertrow(0)
end if	

is_Date = f_Today()

p_can.TriggerEvent("clicked")
end event

on w_qct_01005.create
if this.MenuName = "m_shortcut" then this.MenuID = create m_shortcut
this.rr_1=create rr_1
this.p_exit=create p_exit
this.p_can=create p_can
this.p_mod=create p_mod
this.p_auto=create p_auto
this.p_inq=create p_inq
this.dw_list=create dw_list
this.dw_detail=create dw_detail
this.dw_imhist=create dw_imhist
this.dw_1=create dw_1
this.rr_2=create rr_2
this.Control[]={this.rr_1,&
this.p_exit,&
this.p_can,&
this.p_mod,&
this.p_auto,&
this.p_inq,&
this.dw_list,&
this.dw_detail,&
this.dw_imhist,&
this.dw_1,&
this.rr_2}
end on

on w_qct_01005.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.p_exit)
destroy(this.p_can)
destroy(this.p_mod)
destroy(this.p_auto)
destroy(this.p_inq)
destroy(this.dw_list)
destroy(this.dw_detail)
destroy(this.dw_imhist)
destroy(this.dw_1)
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

event activate;w_mdi_frame.st_window.Text = Upper(is_window_id)
end event

event key;Choose Case key
	Case KeyQ!
		p_inq.TriggerEvent(Clicked!)
	Case KeyS!
		p_mod.TriggerEvent(Clicked!)
	Case KeyC!
		p_can.TriggerEvent(Clicked!)
	Case KeyX!
		p_exit.TriggerEvent(Clicked!)
End Choose
end event

type rr_1 from roundrectangle within w_qct_01005
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 64
integer y = 20
integer width = 3584
integer height = 204
integer cornerheight = 40
integer cornerwidth = 55
end type

type p_exit from uo_picture within w_qct_01005
integer x = 4398
integer y = 12
integer width = 178
integer taborder = 80
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;CLOSE(PARENT)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type p_can from uo_picture within w_qct_01005
integer x = 4224
integer y = 12
integer width = 178
integer taborder = 70
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

event clicked;call super::clicked;
Wf_Init()
end event

type p_mod from uo_picture within w_qct_01005
integer x = 4050
integer y = 12
integer width = 178
integer taborder = 60
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

event clicked;call super::clicked;SetPointer(HourGlass!)

if dw_list.rowcount() < 1 then return 

IF f_msg_update() = -1 		THEN	RETURN

IF dw_list.Update() > 0		THEN
	COMMIT;
ELSE
	ROLLBACK;
	f_Rollback()
END IF

p_can.TriggerEvent("clicked")	

SetPointer(Arrow!)


end event

type p_auto from uo_picture within w_qct_01005
integer x = 3877
integer y = 12
integer width = 178
integer taborder = 50
boolean originalsize = true
string picturename = "C:\erpman\image\일괄지정_up.gif"
end type

event clicked;call super::clicked;String sGrpno1

if dw_detail.Accepttext() = -1	then 	return

sGrpno1 = dw_detail.getitemstring(1, "grpno1")

//if isnull(sGrpno1) or trim(sGrpno1) = '' then
//	f_message_chk(30, '[원인 구분]')
//	dw_detail.setcolumn('grpno1')
//	dw_detail.setfocus()
//	return
//end if

Long lrow

For lrow = 1 to dw_list.rowcount()
	 dw_list.setitem(lrow, "grpno1", sgrpno1)
Next
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\일괄지정_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\일괄지정_up.gif"
end event

type p_inq from uo_picture within w_qct_01005
integer x = 3703
integer y = 12
integer width = 178
integer taborder = 30
string pointer = "C:\erpman\cur\retrieve.cur"
boolean enabled = false
string picturename = "C:\erpman\image\조회_d.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조회_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조회_up.gif"
end event

event clicked;call super::clicked;if dw_1.Accepttext() = -1	then 	return
if dw_detail.Accepttext() = -1	then 	return

string  	sGubun,		&
			sClass,		&
			sItemFrom,	&
			sItemTo,		&
			sCust,		&
			sNull, sgrpno1
string ls_porgu
SetNull(sNull)



sGubun	= dw_1.GetItemString(1, "gubun")
ls_porgu	= dw_1.GetItemString(1, "porgu")

IF isnull(ls_porgu) or trim(ls_porgu) = "" 	THEN
	f_message_chk(30,'[사업장]') 
	dw_1.setcolumn("porgu")
	dw_1.setfocus()
	RETURN
END IF

IF isnull(sgubun) or trim(sgubun) = "" 	THEN
	f_message_chk(30,'[품목구분]') 
	dw_1.setcolumn("gubun")
	dw_1.setfocus()
	RETURN
END IF


sGrpno1	= dw_detail.GetItemString(1, "Grpno1")
sClass 	= dw_detail.GetItemSTring(1, "class")
sItemFrom= dw_detail.GetItemString(1, "itemfrom")
sItemTo  = dw_detail.GetItemString(1, "itemto")
sItemTo  = dw_detail.GetItemString(1, "itemto")

IF isnull(sClass) or trim(sClass) = "" 	THEN
	sClass = '%'
END IF

IF isnull(sItemFrom) or trim(sItemFrom) = "" 	THEN	sItemFrom = '0'
IF isnull(sItemTo) 	or trim(sItemTo) = "" 		THEN	sItemTo = 'zzzzzzzzzzzzzzz'
IF isnull(sGrpno1) 	or trim(sGrpno1) = "" 		THEN	sGrpno1 = '%'
	
	
//////////////////////////////////////////////////////////////////////////

 // 상세 검사항목(불량항목) 선택
 // 상세 불량항목 참조코드는 그룹코드의 shortname에 있음
 

datawindowchild dws
dw_list.getchild("grpno1", dws)
dws.settransobject(sqlca)

if dws.retrieve(sGubun)	< 1 then 
	dws.insertrow(0)
end if	

dw_list.settransobject(sqlca)

IF dw_list.Retrieve(ls_porgu,sGubun, sClass, sItemFrom, sItemTo, sGrpno1) < 1	THEN

	f_message_chk(50, '[생산품목현황]')
	dw_1.setcolumn("gubun")
	dw_1.setfocus()
	p_can.TriggerEvent("clicked")
	RETURN

END IF

dw_1.enabled = false
dw_list.setfocus()
end event

type dw_list from datawindow within w_qct_01005
event ue_pressenter pbm_dwnprocessenter
integer x = 78
integer y = 260
integer width = 4411
integer height = 1972
integer taborder = 40
string dataobject = "d_qct_01005_1"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemerror;return 1
end event

event rowfocuschanged;if 	currentrow < 1 then return 
if 	this.rowcount() < 1 then return 

this.setredraw(false)

this.SelectRow(0,False)
this.SelectRow(currentrow,True)

this.ScrollToRow(currentrow)

this.setredraw(true)

end event

type dw_detail from datawindow within w_qct_01005
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 110
integer y = 120
integer width = 3465
integer height = 76
integer taborder = 20
string dataobject = "d_qct_01005_2"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;
IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemerror;return 1
end event

event rbuttondown;gs_code = ''
gs_codename = ''
gs_gubun = ''

string	sItem

IF this.GetColumnName() = 'class' 	THEN

	sItem = this.GetItemString(1, 'gubun')
	OpenWithParm(w_ittyp_popup, sItem)
	
   lstr_itnct = Message.PowerObjectParm	
	
	if isnull(lstr_itnct.s_ittyp) or lstr_itnct.s_ittyp = "" then return 
	
	this.SetItem(1,"gubun",	lstr_itnct.s_ittyp)
	this.SetItem(1,"class", lstr_itnct.s_sumgub)

END IF


// 품목
IF this.GetColumnName() = 'itemfrom' THEN

	open(w_itemas_popup3)
	if isnull(gs_code) or gs_code = "" then return
	this.SetItem(1,"itemfrom",gs_code)

END IF

// 품목
IF this.GetColumnName() = 'itemto' THEN

	open(w_itemas_popup3)
	if isnull(gs_code) or gs_code = "" then return
	this.SetItem(1,"itemto",gs_code)

END IF

end event

event dberror;return 1
end event

event itemchanged;
if getcolumnname() = 'gubun' then
	
	String sNull
	
	datawindowchild dws
	dw_detail.getchild("grpno1", dws)
	dws.settransobject(sqlca)
	dws.retrieve(data)	
	
	Setnull(sNull)
	setitem(1, "grpno1", sNull)
end if
end event

type dw_imhist from datawindow within w_qct_01005
boolean visible = false
integer x = 96
integer y = 2316
integer width = 494
integer height = 212
boolean titlebar = true
string title = "입출고HISTORY"
string dataobject = "d_pme3001_imhist"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
end type

type dw_1 from datawindow within w_qct_01005
integer x = 82
integer y = 36
integer width = 2491
integer height = 80
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_qct_01005_3"
boolean border = false
boolean livescroll = true
end type

event itemchanged;
if idws.retrieve(data) < 1 then 
	idws.reset()
	idws.insertrow(0)
	p_inq.PictureName = "C:\erpman\image\조회_d.gif"	
	p_inq.enabled = false
	MessageBox("검사항목", "검사그룹및 항목을 정의후 입력하세요", stopsign!)
Else
	p_inq.PictureName = "C:\erpman\image\조회_up.gif"	
	p_inq.enabled = true	
end if	

dw_detail.setitem(1, 'grpno1', '' )
end event

type rr_2 from roundrectangle within w_qct_01005
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 64
integer y = 252
integer width = 4439
integer height = 1996
integer cornerheight = 40
integer cornerwidth = 55
end type

