$PBExportHeader$w_standard_dw_graph.srw
$PBExportComments$그래프 화면 기본(data window)
forward
global type w_standard_dw_graph from window
end type
type p_exit from picture within w_standard_dw_graph
end type
type p_print from picture within w_standard_dw_graph
end type
type p_retrieve from picture within w_standard_dw_graph
end type
type st_window from statictext within w_standard_dw_graph
end type
type st_popup from statictext within w_standard_dw_graph
end type
type pb_title from picturebutton within w_standard_dw_graph
end type
type pb_space from picturebutton within w_standard_dw_graph
end type
type pb_color from picturebutton within w_standard_dw_graph
end type
type pb_graph from picturebutton within w_standard_dw_graph
end type
type dw_ip from u_key_enter within w_standard_dw_graph
end type
type sle_msg from singlelineedit within w_standard_dw_graph
end type
type dw_datetime from datawindow within w_standard_dw_graph
end type
type st_10 from statictext within w_standard_dw_graph
end type
type gb_3 from groupbox within w_standard_dw_graph
end type
type dw_list from datawindow within w_standard_dw_graph
end type
type gb_10 from groupbox within w_standard_dw_graph
end type
type rr_1 from roundrectangle within w_standard_dw_graph
end type
end forward

global type w_standard_dw_graph from window
integer x = 5
integer y = 4
integer width = 4658
integer height = 2440
boolean titlebar = true
boolean controlmenu = true
boolean minbox = true
long backcolor = 32106727
event ue_rbuttonup pbm_rbuttonup
p_exit p_exit
p_print p_print
p_retrieve p_retrieve
st_window st_window
st_popup st_popup
pb_title pb_title
pb_space pb_space
pb_color pb_color
pb_graph pb_graph
dw_ip dw_ip
sle_msg sle_msg
dw_datetime dw_datetime
st_10 st_10
gb_3 gb_3
dw_list dw_list
gb_10 gb_10
rr_1 rr_1
end type
global w_standard_dw_graph w_standard_dw_graph

type variables
String print_gu                 //window가 조회인지 인쇄인지  

String     is_today            //시작일자
String     is_totime           //시작시간
String     is_window_id    //윈도우 ID
String     is_usegub, is_upmu         //이력관리 여부

String    is_preview
Integer   ii_factor = 100           // 프린트 확대축소
boolean   iv_b_down = false
end variables

forward prototypes
public function integer wf_retrieve ()
public function integer wf_print ()
end prototypes

public function integer wf_retrieve ();Return 1
end function

public function integer wf_print ();
Return 1
end function

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
 

dw_ip.SetTransObject(SQLCA)
dw_ip.Reset()
dw_ip.InsertRow(0)

dw_list.settransobject(sqlca)
IF is_upmu = 'A' THEN //회계인 경우
   int iRtnVal 

	IF Upper(Mid(is_window_id,4,2)) = 'BG' THEN							   /*예산*/
		IF F_Valid_EmpNo(Gs_EmpNo) = 'N' THEN							/*권한 체크- 현업 여부*/
			dw_ip.SetItem(dw_ip.GetRow(),"saupj",   Gs_Saupj)
			
			dw_ip.Modify("saupj.protect = 1")
		ELSE
			dw_ip.Modify("saupj.protect = 0")
		END IF
	ELSE
		IF Upper(Mid(is_window_id,4,2)) = 'FI' THEN							/*자금*/
			iRtnVal = F_Authority_Fund_Chk(Gs_Dept)	
		ELSE
			iRtnVal = F_Authority_Chk(Gs_Dept)
		END IF
		IF iRtnVal = -1 THEN							/*권한 체크- 현업 여부*/
			dw_ip.SetItem(dw_ip.GetRow(),"saupj",   Gs_Saupj)
			
			dw_ip.Modify("saupj.protect = 1")
		ELSE
			dw_ip.Modify("saupj.protect = 0")
		END IF	
	END IF
END IF
dw_list.object.datawindow.print.preview = "yes"	







end event

on w_standard_dw_graph.create
this.p_exit=create p_exit
this.p_print=create p_print
this.p_retrieve=create p_retrieve
this.st_window=create st_window
this.st_popup=create st_popup
this.pb_title=create pb_title
this.pb_space=create pb_space
this.pb_color=create pb_color
this.pb_graph=create pb_graph
this.dw_ip=create dw_ip
this.sle_msg=create sle_msg
this.dw_datetime=create dw_datetime
this.st_10=create st_10
this.gb_3=create gb_3
this.dw_list=create dw_list
this.gb_10=create gb_10
this.rr_1=create rr_1
this.Control[]={this.p_exit,&
this.p_print,&
this.p_retrieve,&
this.st_window,&
this.st_popup,&
this.pb_title,&
this.pb_space,&
this.pb_color,&
this.pb_graph,&
this.dw_ip,&
this.sle_msg,&
this.dw_datetime,&
this.st_10,&
this.gb_3,&
this.dw_list,&
this.gb_10,&
this.rr_1}
end on

on w_standard_dw_graph.destroy
destroy(this.p_exit)
destroy(this.p_print)
destroy(this.p_retrieve)
destroy(this.st_window)
destroy(this.st_popup)
destroy(this.pb_title)
destroy(this.pb_space)
destroy(this.pb_color)
destroy(this.pb_graph)
destroy(this.dw_ip)
destroy(this.sle_msg)
destroy(this.dw_datetime)
destroy(this.st_10)
destroy(this.gb_3)
destroy(this.dw_list)
destroy(this.gb_10)
destroy(this.rr_1)
end on

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
	/* 단축키 */
	Case KeyQ!
		p_retrieve.TriggerEvent(Clicked!)
	Case KeyW!
		p_print.TriggerEvent(Clicked!)
	Case KeyX!
		p_exit.TriggerEvent(Clicked!)
end choose
end event

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

event mousemove;w_mdi_frame.st_bubble.visible = False
end event

type p_exit from picture within w_standard_dw_graph
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
event ue_mousemove pbm_mousemove
integer x = 4416
integer y = 28
integer width = 178
integer height = 144
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;PictureName = 'C:\erpman\image\닫기_dn.gif'
end event

event ue_lbuttonup;PictureName = 'C:\erpman\image\닫기_up.gif'
end event

event clicked;close(parent)
end event

type p_print from picture within w_standard_dw_graph
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
event ue_mousemove pbm_mousemove
integer x = 4238
integer y = 28
integer width = 178
integer height = 144
string pointer = "C:\erpman\cur\print.cur"
boolean enabled = false
string picturename = "C:\erpman\image\인쇄_d.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;IF p_print.Enabled = True THEN
	PictureName = 'C:\erpman\image\인쇄_dn.gif'
END IF
end event

event ue_lbuttonup;IF p_print.Enabled = True THEN
	p_print.PictureName =  'C:\erpman\image\인쇄_up.gif'
END IF
end event

event clicked;IF dw_list.rowcount() > 0 then 
	gi_page = dw_list.GetItemNumber(1,"last_page")
ELSE
	gi_page = 1
END IF
OpenWithParm(w_print_options, dw_list)


end event

type p_retrieve from picture within w_standard_dw_graph
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
event ue_mousemove pbm_mousemove
integer x = 4059
integer y = 28
integer width = 178
integer height = 144
string pointer = "C:\erpman\cur\retrieve.cur"
boolean originalsize = true
string picturename = "C:\erpman\image\조회_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;iv_b_down = true
p_retrieve.PictureName = 'C:\erpman\image\조회_dn.gif'

end event

event ue_lbuttonup;iv_b_down = false

p_retrieve.PictureName = 'C:\erpman\image\조회_up.gif'
end event

event clicked;SetPointer(HourGlass!)
IF wf_retrieve() = -1 THEN
//	pb_color.Enabled =False
//	pb_graph.Enabled =False
//	pb_space.Enabled =False
//	pb_title.Enabled =False
	
	p_print.Enabled =False
	p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'
	
	SetPointer(Arrow!)
	Return
ELSE
	if dw_list.object.datawindow.print.preview <> 'yes' then 
//		pb_color.Enabled =True
//		pb_graph.Enabled =True
//		pb_space.Enabled =True
//		pb_title.Enabled =True
	end if	
	
	p_print.Enabled =True
	p_print.PictureName = 'C:\erpman\image\인쇄_up.gif'
	
END IF
dw_list.scrolltorow(1)
SetPointer(Arrow!)
end event

type st_window from statictext within w_standard_dw_graph
boolean visible = false
integer x = 2368
integer y = 2596
integer width = 498
integer height = 84
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 12632256
boolean enabled = false
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_popup from statictext within w_standard_dw_graph
boolean visible = false
integer x = 1669
integer y = 2612
integer width = 453
integer height = 68
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
boolean enabled = false
string text = "Popup"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type pb_title from picturebutton within w_standard_dw_graph
boolean visible = false
integer x = 3625
integer y = 56
integer width = 174
integer height = 160
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "돋움체"
boolean enabled = false
boolean originalsize = true
string picturename = "C:\erpman\image\title.bmp"
string disabledname = "C:\erpman\image\falsetitle.bmp"
alignment htextalign = left!
end type

event clicked;SetPointer(HourGlass!)

// Open the response window to set the graph type. Pass it the graph
// object and it will do the rest.
OpenWithParm (w_graph_title, dw_list)

end event

type pb_space from picturebutton within w_standard_dw_graph
boolean visible = false
integer x = 3447
integer y = 56
integer width = 174
integer height = 160
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "돋움체"
boolean enabled = false
boolean originalsize = true
string picturename = "C:\erpman\image\space.bmp"
string disabledname = "C:\erpman\image\falsespace.bmp"
alignment htextalign = left!
end type

event clicked;SetPointer(HourGlass!)

// Open the response window to set the graph type. Pass it the graph
// object and it will do the rest.
OpenWithParm (w_graph_spacing, dw_list)

end event

type pb_color from picturebutton within w_standard_dw_graph
boolean visible = false
integer x = 3269
integer y = 56
integer width = 174
integer height = 160
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "돋움체"
boolean enabled = false
boolean originalsize = true
string picturename = "C:\erpman\image\color.bmp"
string disabledname = "C:\erpman\image\falsecolor.bmp"
alignment htextalign = left!
end type

event clicked;SetPointer(HourGlass!)

// Open the response window to set the graph type. Pass it the graph
// object and it will do the rest.
OpenWithParm (w_graph_color, dw_list)

end event

type pb_graph from picturebutton within w_standard_dw_graph
boolean visible = false
integer x = 3090
integer y = 56
integer width = 174
integer height = 160
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "돋움체"
boolean enabled = false
boolean originalsize = true
string picturename = "C:\erpman\image\graph.bmp"
string disabledname = "C:\erpman\image\falseGRAPH.bmp"
alignment htextalign = left!
end type

event clicked;SetPointer(HourGlass!)

// Open the response window to set the graph type. Pass it the graph
// object and it will do the rest.

OpenWithParm (w_graph_type, dw_list)

end event

type dw_ip from u_key_enter within w_standard_dw_graph
event ue_key pbm_dwnkey
integer x = 55
integer y = 16
integer width = 713
integer height = 216
integer taborder = 10
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

type sle_msg from singlelineedit within w_standard_dw_graph
boolean visible = false
integer x = 389
integer y = 2596
integer width = 1979
integer height = 84
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12632256
boolean enabled = false
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type dw_datetime from datawindow within w_standard_dw_graph
boolean visible = false
integer x = 2862
integer y = 2596
integer width = 750
integer height = 88
boolean enabled = false
string dataobject = "d_datetime"
boolean border = false
boolean livescroll = true
end type

type st_10 from statictext within w_standard_dw_graph
boolean visible = false
integer x = 32
integer y = 2596
integer width = 357
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

type gb_3 from groupbox within w_standard_dw_graph
boolean visible = false
integer x = 3058
integer width = 773
integer height = 244
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 79741120
boolean enabled = false
end type

type dw_list from datawindow within w_standard_dw_graph
event u_key pbm_dwnkey
event ue_rbuttonup pbm_rbuttonup
integer x = 41
integer y = 244
integer width = 4571
integer height = 2068
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
end type

event u_key;// Page Up & Page Down & Home & End Key 사용 정의
choose case key
	case keypageup!
		dw_list.scrollpriorpage()
	case keypagedown!
		dw_list.scrollnextpage()
	case keyhome!
		dw_list.scrolltorow(1)
	case keyend!
		dw_list.scrolltorow(dw_list.rowcount())
end choose
end event

event ue_rbuttonup;st_popup.visible = false
end event

event doubleclicked;int 	li_series, li_datapoint
grobjecttype lgro_clickedtype
string ls_graphtype, objnm, objtype
int   li_graphtype
str_graphobjectatpoint lstr_graph
graphicobject aaa

objnm = dwo.name
lstr_graph.objnm = objnm
objtype = dwo.name + '.graphtype'

if dwo.Type <> 'graph' then return

ls_graphtype = dw_list.Describe(objtype)

li_graphtype  = Integer(ls_graphtype)
If (li_graphtype <> 13) and (li_graphtype <> 17) Then Return

lgro_clickedtype = dw_list.ObjectAtPointer(objnm,li_series,li_datapoint)
If (li_series > 0 and li_datapoint>0) and &
	lgro_clickedtype = TypeData! Then
	lstr_graph.graphicobject = dw_list
	lstr_graph.series = li_series
	lstr_graph.datapoint = li_datapoint	
	OpenWithParm(w_graph_pie_explode,lstr_graph)
End If

end event

event rbuttondown;// Clicked script for dw_headcount
// This will cause a static text box to appear next to the pointer where the user
// is using right mouse button down. The acutal value for the data item will
// be displayed in the text box.

grObjectType	ClickedObject
string			ls_grgraphname 
int				li_series, li_category


ls_grgraphname = dwo.name
/************************************************************
	Find out where the user clicked in the graph
 ***********************************************************/
ClickedObject = this.ObjectAtPointer (ls_grgraphname, li_series, &
						li_category)

/************************************************************
	If user clicked on data or category, find out which one
 ***********************************************************/
If ClickedObject = TypeData! Then
	st_popup.text = string(this.GetData(ls_grgraphname, li_series, li_category)) 
	st_popup.x = parent.PointerX()
	st_popup.y = parent.PointerY() - 65
	st_popup.visible = true
End If

end event

type gb_10 from groupbox within w_standard_dw_graph
boolean visible = false
integer x = 14
integer y = 2544
integer width = 3611
integer height = 152
integer textsize = -12
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean enabled = false
end type

type rr_1 from roundrectangle within w_standard_dw_graph
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 232
integer width = 4603
integer height = 2100
integer cornerheight = 40
integer cornerwidth = 55
end type

