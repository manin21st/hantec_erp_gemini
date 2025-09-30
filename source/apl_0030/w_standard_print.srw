$PBExportHeader$w_standard_print.srw
$PBExportComments$출력 화면 기본
forward
global type w_standard_print from window
end type
type p_xls from picture within w_standard_print
end type
type p_sort from picture within w_standard_print
end type
type p_preview from picture within w_standard_print
end type
type p_exit from picture within w_standard_print
end type
type p_print from picture within w_standard_print
end type
type p_retrieve from picture within w_standard_print
end type
type st_window from statictext within w_standard_print
end type
type sle_msg from singlelineedit within w_standard_print
end type
type dw_datetime from datawindow within w_standard_print
end type
type st_10 from statictext within w_standard_print
end type
type gb_10 from groupbox within w_standard_print
end type
type dw_print from datawindow within w_standard_print
end type
type dw_ip from u_key_enter within w_standard_print
end type
type dw_list from datawindow within w_standard_print
end type
end forward

global type w_standard_print from window
integer x = 5
integer y = 4
integer width = 4658
integer height = 2440
boolean titlebar = true
string menuname = "m_shortcut"
boolean controlmenu = true
boolean minbox = true
long backcolor = 32106727
event ue_seek pbm_custom01
event ue_open ( )
p_xls p_xls
p_sort p_sort
p_preview p_preview
p_exit p_exit
p_print p_print
p_retrieve p_retrieve
st_window st_window
sle_msg sle_msg
dw_datetime dw_datetime
st_10 st_10
gb_10 gb_10
dw_print dw_print
dw_ip dw_ip
dw_list dw_list
end type
global w_standard_print w_standard_print

type variables
String print_gu                 //window가 조회인지 인쇄인지  

String     is_today            //시작일자
String     is_totime           //시작시간
String     is_window_id    //윈도우 ID
String     is_usegub         //이력관리 여부
String     is_upmu           //업무구분(A:회계, P:인사, M:물류, C:공통')
String     sabu_t, sabu_f, sabu_nm    //회계용
String is_saupcd  //사업장코드
String     is_preview        // dw상태가 preview인지
Integer   ii_factor = 100           // 프린트 확대축소
boolean   iv_b_down = false
end variables

forward prototypes
public function integer wf_print ()
public function integer wf_retrieve ()
public function integer wf_objectcheck ()
public subroutine wf_excel_down (datawindow adw_excel)
end prototypes

event ue_seek;//integer ipoint

//ipoint = Dec(em_split.text)

if is_preview = 'no' then

	if dw_list.object.datawindow.print.preview = "yes" then
		dw_list.object.datawindow.print.preview = "no"
	end if	
	dw_list.object.datawindow.horizontalscrollsplit			=	0
	dw_list.object.datawindow.horizontalscrollposition2	= 	0
	openwithparm(w_seek, dw_list)
//	dw_list.object.datawindow.horizontalscrollsplit			=	ipoint
//	dw_list.object.datawindow.horizontalscrollposition2	= 	ipoint
else
	Messagebox("검색", "검색할 수 있는 프로그램이 아닙니다", stopsign!)
end if
end event

event ue_open();dw_ip.SetFocus()
end event

public function integer wf_print ();
Return 1
end function

public function integer wf_retrieve ();/////////////////////////////////////////////
//  조회
/////////////////////////////////////////////

Return 1
end function

public function integer wf_objectcheck ();//현재 출력물의 상태(preview = yes이면 검색대상기능을 제한한다)
is_preview = 'yes'

String sobject

Setnull(sObject)

sObject = dw_list.dataobject

if isnull(sObject) or trim(sObject) = '' or not dw_list.visible then
	return -1
else
	is_preview = dw_list.object.datawindow.print.preview
end if

if is_preview = 'yes' then return -1

// menu의 window를 check하여 0이면 skip하고 0보다 크면 horizontalscroll을 사용
integer ipoint
String sWindow, sFindyn
sWindow = string(this)

Setnull(sfindyn)
ipoint = 0

ipoint = 0
select hpoint, findyn into :ipoint, :sfindyn from sub2_t
 where window_name = :sWindow;
 
if isnull(sfindyn) Or trim(sfindyn) = '' Or sfindyn = 'N' then
	if is_preview = 'yes' then
		return -1
	end if
end if
 
//em_split.text = string(ipoint)
//
//if ipoint > 0 then
//	dw_list.object.datawindow.horizontalscrollsplit			=	ipoint
//	dw_list.object.datawindow.horizontalscrollposition2	= 	ipoint
//end if
//
String this_class[]
windowobject the_object[]

integer i, cnt

For i = 1 to upperbound(control[])
	the_object[i]	=	control[i]
	this_class[i]	=	the_object[i].classname()
Next

// 출력window에 tabl이 있는지 검색하여 있으면 -1을 return
// 다음의 내역은 검색대상에서 제외한다.
// window내에 object을 생성시 필히 nameing rule을 지킬 것
// ln_(Line), r_(Rectangle), rr_(RoundRectangle), oval_(Oval)

dragobject temp

cnt = upperbound(this.control)
for i = cnt to 1 step -1
	if Left(this_class[i], 3) = 'ln_' 	or &
		Left(this_class[i], 2) = 'r_' 		or &	
		Left(this_class[i], 3) = 'rr_' 	or &	
		Left(this_class[i], 5) = 'oval_' 	Then	Continue
		
	Temp	=	this.control[i]
	
	Choose Case TypeOf(temp)
			 Case tab!
					is_preview = 'yes'
					return -1
	End choose
Next

//em_split.enabled = true

return 1
end function

public subroutine wf_excel_down (datawindow adw_excel);String	ls_quota_no
integer	li_rc
string	ls_filepath, ls_filename
boolean	lb_fileexist

li_rc = GetFileSaveName("저장할 파일명을 선택하세요." , ls_filepath , &
											  ls_filename , "XLS" , "Excel Files (*.xls),*.xls")												
IF li_rc = 1 THEN
	IF lb_fileexist THEN
		li_rc = MessageBox("파일저장" , ls_filepath + " 파일이 이미 존재합니다.~r~n" + &
												 "기존의 파일을 덮어쓰시겠습니까?" , Question! , YesNo! , 1)
		IF li_rc = 2 THEN 
			w_mdi_frame.sle_msg.text = "자료다운취소!!!"			
			RETURN
		END IF
	END IF
	
	Setpointer(HourGlass!)
	
 	If uf_save_dw_as_excel(adw_excel,ls_filepath) <> 1 Then
		w_mdi_frame.sle_msg.text = "자료다운실패!!!"
		return
	End If

END IF

w_mdi_frame.sle_msg.text = "자료다운완료!!!"
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

SELECT "SUB2_T"."OPEN_HISTORY", "SUB2_T"."UPMU"  
  INTO :is_usegub,  :is_upmu 
  FROM "SUB2_T"  
 WHERE "SUB2_T"."WINDOW_NAME" = :is_window_id  ;

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
dw_print.settransobject(sqlca)

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
dw_print.object.datawindow.print.preview = "yes"	

dw_print.ShareData(dw_list)

PostEvent('ue_open')
end event

on w_standard_print.create
if this.MenuName = "m_shortcut" then this.MenuID = create m_shortcut
this.p_xls=create p_xls
this.p_sort=create p_sort
this.p_preview=create p_preview
this.p_exit=create p_exit
this.p_print=create p_print
this.p_retrieve=create p_retrieve
this.st_window=create st_window
this.sle_msg=create sle_msg
this.dw_datetime=create dw_datetime
this.st_10=create st_10
this.gb_10=create gb_10
this.dw_print=create dw_print
this.dw_ip=create dw_ip
this.dw_list=create dw_list
this.Control[]={this.p_xls,&
this.p_sort,&
this.p_preview,&
this.p_exit,&
this.p_print,&
this.p_retrieve,&
this.st_window,&
this.sle_msg,&
this.dw_datetime,&
this.st_10,&
this.gb_10,&
this.dw_print,&
this.dw_ip,&
this.dw_list}
end on

on w_standard_print.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.p_xls)
destroy(this.p_sort)
destroy(this.p_preview)
destroy(this.p_exit)
destroy(this.p_print)
destroy(this.p_retrieve)
destroy(this.st_window)
destroy(this.sle_msg)
destroy(this.dw_datetime)
destroy(this.st_10)
destroy(this.gb_10)
destroy(this.dw_print)
destroy(this.dw_ip)
destroy(this.dw_list)
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
	Case KeyV!
		IF p_preview.Enabled THEN 
			p_preview.TriggerEvent(Clicked!)
		END IF
	Case KeyW!
		IF p_preview.Enabled THEN 
			p_print.TriggerEvent(Clicked!)
		END IF		
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

type p_xls from picture within w_standard_print
boolean visible = false
integer x = 3415
integer y = 40
integer width = 178
integer height = 144
string pointer = "HyperLink!"
string picturename = "C:\erpman\image\엑셀변환_up.gif"
boolean focusrectangle = false
end type

event clicked;If this.Enabled Then wf_excel_down(dw_list)
end event

type p_sort from picture within w_standard_print
boolean visible = false
integer x = 3237
integer y = 40
integer width = 178
integer height = 144
string pointer = "HyperLink!"
boolean originalsize = true
string picturename = "C:\erpman\image\정렬_up.gif"
boolean focusrectangle = false
end type

event clicked;Openwithparm(w_sort, dw_list)
end event

type p_preview from picture within w_standard_print
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
event ue_mousemove pbm_mousemove
integer x = 4096
integer y = 24
integer width = 178
integer height = 144
integer taborder = 40
string pointer = "C:\erpman\cur\preview.cur"
boolean enabled = false
string picturename = "C:\erpman\image\미리보기_d.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;IF This.Enabled = True THEN
	PictureName = 'C:\erpman\image\미리보기_dn.gif'
END IF

end event

event ue_lbuttonup;IF This.Enabled = True THEN
	PictureName =  'C:\erpman\image\미리보기_up.gif'
END IF
end event

event clicked;OpenWithParm(w_print_preview, dw_print)	

end event

type p_exit from picture within w_standard_print
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
event ue_mousemove pbm_mousemove
integer x = 4443
integer y = 24
integer width = 178
integer height = 144
integer taborder = 60
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

type p_print from picture within w_standard_print
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
event ue_mousemove pbm_mousemove
integer x = 4270
integer y = 24
integer width = 178
integer height = 144
integer taborder = 50
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

event clicked;iF dw_print.rowcount() > 0 then 
	gi_page = long(dw_print.Describe("evaluate('pagecount()', 1)" ))
ELSE
	gi_page = 1
END IF
OpenWithParm(w_print_options, dw_print)


end event

type p_retrieve from picture within w_standard_print
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
event ue_mousemove pbm_mousemove
integer x = 3922
integer y = 24
integer width = 178
integer height = 144
integer taborder = 20
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;PictureName = 'C:\erpman\image\조회_dn.gif'

end event

event ue_lbuttonup;PictureName = 'C:\erpman\image\조회_up.gif'

end event

event clicked;if is_Upmu = 'A' then
	
	if dw_ip.AcceptText() = -1 then return  

	w_mdi_frame.sle_msg.text =""
	
	sabu_f =Trim(dw_ip.GetItemString(1,"saupj"))
	
	SetPointer(HourGlass!)
	IF sabu_f ="" OR IsNull(sabu_f) OR sabu_f ="99" THEN	//사업장이 전사이거나 없으면 모든 사업장//
		sabu_f ="10"
		sabu_t ="98"
		SELECT "REFFPF"."RFNA1"  
		 INTO :sabu_nm  
		 FROM "REFFPF"  
		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND  
				( "REFFPF"."RFGUB" = '99' )   ;
	ELSE
		sabu_t =sabu_f
		SELECT "REFFPF"."RFNA1"  
		 INTO :sabu_nm  
		 FROM "REFFPF"  
		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND  
				( "REFFPF"."RFGUB" = :sabu_f )   ;
	END IF
end if

IF wf_retrieve() = -1 THEN
	p_print.Enabled =False
	p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

	p_preview.enabled = False
	p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
	SetPointer(Arrow!)
	Return
Else
	p_print.Enabled =True
	p_print.PictureName =  'C:\erpman\image\인쇄_up.gif'
	p_preview.enabled = true
	p_preview.PictureName = 'C:\erpman\image\미리보기_up.gif'
END IF
dw_list.scrolltorow(1)
dw_list.SetFocus()
SetPointer(Arrow!)	

w_mdi_frame.sle_msg.text =""

///-----------------------------------------------------------------------------------------
// by 2006.09.30 font채 변경 - 신
String ls_gbn
SELECT DATANAME
  INTO :ls_gbn
  FROM SYSCNFG
 WHERE SYSGU  = 'C'
   AND SERIAL = '81'
   AND LINENO = '1' ;
If ls_gbn = 'Y' Then
	//wf_setfont()
	WindowObject l_object[]
	Long i
	gstr_object_chg lstr_object		
	For i = 1 To UpperBound(Control[])
		lstr_object.lu_object[i] = Control[i]  //Window Object
		lstr_object.li_obj = i						//Window Object 갯수
	Next
	f_change_font(lstr_object)
End If

///-----------------------------------------------------------------------------------------


end event

type st_window from statictext within w_standard_print
integer x = 2350
integer y = 2648
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

type sle_msg from singlelineedit within w_standard_print
integer x = 375
integer y = 2648
integer width = 1975
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

type dw_datetime from datawindow within w_standard_print
integer x = 2843
integer y = 2648
integer width = 750
integer height = 88
string dataobject = "d_datetime"
boolean border = false
boolean livescroll = true
end type

type st_10 from statictext within w_standard_print
integer x = 14
integer y = 2648
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

type gb_10 from groupbox within w_standard_print
integer y = 2612
integer width = 3611
integer height = 136
integer textsize = -8
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12632256
end type

type dw_print from datawindow within w_standard_print
boolean visible = false
integer x = 3730
integer y = 36
integer width = 128
integer height = 112
end type

type dw_ip from u_key_enter within w_standard_print
event ue_key pbm_dwnkey
integer x = 41
integer y = 16
integer width = 1166
integer height = 264
integer taborder = 10
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

type dw_list from datawindow within w_standard_print
event u_key pbm_dwnkey
integer x = 37
integer y = 340
integer width = 4590
integer height = 1912
integer taborder = 30
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
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

event constructor;if wf_objectcheck() = -1 then
	is_preview = 'yes'
end if
end event

event printstart;string sleft, smid, sright, sleft_tx, smid_tx, sright_tx 
  
SELECT "LEFT_TX", "MID_TX",  "RIGHT_TX"  
  INTO :sleft_tx, :smid_tx,  :sright_tx   
  FROM "SUB2_T"  
 WHERE "WINDOW_NAME" = :is_window_id  AND ROWNUM = 1 ;

if sqlca.sqlcode = 0 then 
	sleft  = this.Describe("left_tx.Name")
	smid   = this.Describe("mid_tx.Name")
	sright = this.Describe("right_tx.Name")
	
	if sleft = 'left_tx' and not (sleft_tx = '' or isnull(sleft_tx)) then 
		this.object.left_tx.text = sleft_tx
	end if
	
	if smid = 'mid_tx' and not (smid_tx = '' or isnull(smid_tx))  then 
		this.object.mid_tx.text = smid_tx
	end if
	
	if sright = 'right_tx' and not (sright_tx = '' or isnull(sright_tx))  then 
		this.object.right_tx.text = sright_tx
	end if
end if 

end event

event clicked;if row <=0 then return

this.SelectRow(0,False)
this.SelectRow(row,True)
end event

event rowfocuschanged;if currentrow <=0 then return

this.SelectRow(0,False)
this.SelectRow(currentrow,True)
end event

