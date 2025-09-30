$PBExportHeader$w_qct_01000.srw
$PBExportComments$검사기준등록
forward
global type w_qct_01000 from window
end type
type dw_ins from datawindow within w_qct_01000
end type
type p_auto from uo_picture within w_qct_01000
end type
type p_exit from uo_picture within w_qct_01000
end type
type p_can from uo_picture within w_qct_01000
end type
type p_mod from uo_picture within w_qct_01000
end type
type p_inq from uo_picture within w_qct_01000
end type
type tab_1 from tab within w_qct_01000
end type
type tabpage_1 from userobject within tab_1
end type
type dw_list1 from datawindow within tabpage_1
end type
type dw_1 from datawindow within tabpage_1
end type
type rr_1 from roundrectangle within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_list1 dw_list1
dw_1 dw_1
rr_1 rr_1
end type
type tabpage_2 from userobject within tab_1
end type
type dw_2 from datawindow within tabpage_2
end type
type dw_list2 from datawindow within tabpage_2
end type
type rr_2 from roundrectangle within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_2 dw_2
dw_list2 dw_list2
rr_2 rr_2
end type
type tab_1 from tab within w_qct_01000
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
type dw_imhist from datawindow within w_qct_01000
end type
end forward

global type w_qct_01000 from window
integer width = 4640
integer height = 2440
boolean titlebar = true
string title = "검사기준 등록"
string menuname = "m_shortcut"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 32106727
dw_ins dw_ins
p_auto p_auto
p_exit p_exit
p_can p_can
p_mod p_mod
p_inq p_inq
tab_1 tab_1
dw_imhist dw_imhist
end type
global w_qct_01000 w_qct_01000

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
end variables

forward prototypes
public subroutine wf_init ()
end prototypes

public subroutine wf_init ();
ib_any_typing = FALSE

tab_1.tabpage_1.dw_1.SetRedraw(false)
tab_1.tabpage_1.dw_1.Reset()
tab_1.tabpage_1.dw_1.InsertRow(0)
tab_1.tabpage_1.dw_list1.Reset()
tab_1.tabpage_1.dw_1.SetRedraw(true)

tab_1.tabpage_2.dw_2.SetRedraw(false)
tab_1.tabpage_2.dw_2.Reset()
tab_1.tabpage_2.dw_2.InsertRow(0)
tab_1.tabpage_2.dw_list2.Reset()
tab_1.tabpage_2.dw_2.SetRedraw(True)

tab_1.tabpage_1.dw_1.SetColumn("gubun")
tab_1.tabpage_1.dw_1.SetFocus()


// 초기화
tab_1.SelectedTab = 1

/* User별 사업장 Setting */
f_mod_saupj(tab_1.tabpage_1.dw_1,"porgu")
f_mod_saupj(tab_1.tabpage_2.dw_2,"porgu")

f_child_saupj(tab_1.tabpage_1.dw_list1, 'chgbn', gs_saupj)

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

tab_1.tabpage_1.dw_1.SetTransObject(sqlca)
tab_1.tabpage_1.dw_list1.SetTransObject(sqlca)

tab_1.tabpage_2.dw_2.SetTransObject(sqlca)
tab_1.tabpage_2.dw_list2.SetTransObject(sqlca)
dw_ins.SetTransObject(sqlca)

tab_1.tabpage_1.dw_1.InsertRow(0)
tab_1.tabpage_2.dw_2.InsertRow(0)
tab_1.tabpage_1.dw_1.setfocus()

is_Date = f_Today()


p_can.TriggerEvent("clicked")

end event

on w_qct_01000.create
if this.MenuName = "m_shortcut" then this.MenuID = create m_shortcut
this.dw_ins=create dw_ins
this.p_auto=create p_auto
this.p_exit=create p_exit
this.p_can=create p_can
this.p_mod=create p_mod
this.p_inq=create p_inq
this.tab_1=create tab_1
this.dw_imhist=create dw_imhist
this.Control[]={this.dw_ins,&
this.p_auto,&
this.p_exit,&
this.p_can,&
this.p_mod,&
this.p_inq,&
this.tab_1,&
this.dw_imhist}
end on

on w_qct_01000.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_ins)
destroy(this.p_auto)
destroy(this.p_exit)
destroy(this.p_can)
destroy(this.p_mod)
destroy(this.p_inq)
destroy(this.tab_1)
destroy(this.dw_imhist)
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

type dw_ins from datawindow within w_qct_01000
boolean visible = false
integer y = 916
integer width = 3945
integer height = 412
integer taborder = 40
string title = "none"
string dataobject = "d_qct_01005_1"
boolean border = false
boolean livescroll = true
end type

type p_auto from uo_picture within w_qct_01000
integer x = 3854
integer y = 12
integer width = 183
integer taborder = 30
boolean originalsize = true
string picturename = "C:\erpman\image\일괄지정_up.gif"
end type

event clicked;call super::clicked;long	lRow

IF tab_1.SelectedTab = 1	THEN
	gs_gubun = '1' 
	open(w_qct_01001)
	IF IsNull(gs_code) and IsNull(gs_codename) and IsNull(gs_gubun)	THEN	RETURN

	SetPointer(HourGlass!)
	FOR lRow = 1	TO		tab_1.tabpage_1.dw_list1.RowCount()
		tab_1.tabpage_1.dw_list1.SetItem(lRow, "qcgub" , gs_code)
		tab_1.tabpage_1.dw_list1.SetItem(lRow, "qcemp" , gs_codename)
		tab_1.tabpage_1.dw_list1.SetItem(lRow, "chgbn" , gs_gubun)
		tab_1.tabpage_1.dw_list1.SetItem(lRow, "grpno2", gs_codename2)
	NEXT

	FOR lRow = 1	TO		dw_ins.RowCount()
		dw_ins.SetItem(lRow, "grpno2", gs_codename2)
	NEXT
ELSE
	gs_gubun = '2' 
	open(w_qct_01001)
	IF IsNull(gs_code) and IsNull(gs_codename) and IsNull(gs_gubun)	THEN	RETURN
	
	SetPointer(HourGlass!)
	FOR lRow = 1	TO		tab_1.tabpage_2.dw_list2.RowCount()
		tab_1.tabpage_2.dw_list2.SetItem(lRow, "qcgub", gs_code)
		tab_1.tabpage_2.dw_list2.SetItem(lRow, "qcemp", gs_codename)
	NEXT
	
END IF

SetPointer(Arrow!)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\일괄지정_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\일괄지정_up.gif"
end event

type p_exit from uo_picture within w_qct_01000
integer x = 4379
integer y = 12
integer width = 178
integer taborder = 60
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;CLOSE(PARENT)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type p_can from uo_picture within w_qct_01000
integer x = 4206
integer y = 12
integer width = 178
integer taborder = 50
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""


wf_init()


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

type p_mod from uo_picture within w_qct_01000
integer x = 4032
integer y = 12
integer width = 178
integer taborder = 40
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

SetPointer(HourGlass!)

IF f_msg_update() = -1 		THEN	RETURN

// 생산품
IF tab_1.tabpage_1.dw_list1.Update() > 0		THEN
	COMMIT;
ELSE
	ROLLBACK;
	f_Rollback()
END IF

// 구매품
IF tab_1.tabpage_2.dw_list2.Update() > 0		THEN
	COMMIT;
ELSE
	ROLLBACK;
	f_Rollback()
END IF

// 입고후 검사품
IF dw_ins.Update() > 0		THEN
	COMMIT;
ELSE
	ROLLBACK;
	f_Rollback()
END IF

p_inq.TriggerEvent("clicked")	

SetPointer(Arrow!)


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

type p_inq from uo_picture within w_qct_01000
integer x = 3680
integer y = 12
integer width = 178
integer taborder = 20
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event clicked;w_mdi_frame.sle_msg.text =""

string  	sGubun,		&
			sClass,		&
			sItemFrom,	&
			sItemTo,		&
			sCust,		&
			sNull
string ls_porgu
STRING ls_ittyp,ls_itcls, sGubun2

SetNull(sNull)

if tab_1.SelectedTab = 1 then
	if tab_1.tabpage_1.dw_1.Accepttext() = -1	then 	return
	if tab_1.tabpage_1.dw_list1.Accepttext() = -1	then 	return
   
	ls_porgu	= tab_1.tabpage_1.dw_1.GetItemString(1, "porgu")
	IF isnull(ls_porgu) or trim(ls_porgu) = "" 	THEN
		f_message_chk(30,'[사업장]') 
		tab_1.tabpage_1.dw_1.setcolumn("porgu")
		tab_1.tabpage_1.dw_1.setfocus()
		p_can.TriggerEvent("clicked")
		RETURN
	END IF
	
	sGubun	= tab_1.tabpage_1.dw_1.GetItemString(1, "gubun")
	sGubun2	= tab_1.tabpage_1.dw_1.GetItemString(1, "gubun2")
	sClass 	= tab_1.tabpage_1.dw_1.GetItemSTring(1, "class")
	sItemFrom= tab_1.tabpage_1.dw_1.GetItemString(1, "itemfrom")
	sItemTo  = tab_1.tabpage_1.dw_1.GetItemString(1, "itemto")
   
	IF isnull(sClass) or trim(sClass) = "" 	THEN
		sClass = '%'
	ELSE
		sClass = sClass + '%'
	END IF
	
	IF isnull(sItemFrom) or trim(sItemFrom) = "" 	THEN	sItemFrom = '0'
	IF isnull(sItemTo) 	or trim(sItemTo) = "" 		THEN	sItemTo = 'zzzzzzzzzzzzzzz'
	
	if sGubun2 = '1' then //검사방법 미지정
		tab_1.tabpage_1.dw_list1.SetFilter("isnull(qcgub) or qcgub = '' ")
		dw_ins.SetFilter("isnull(qcgub) or qcgub = '' ")
	elseif sGubun2 = '2' then 
		tab_1.tabpage_1.dw_list1.SetFilter("qcgub > '.' ")
		dw_ins.SetFilter("qcgub > '.' ")
	else
		tab_1.tabpage_1.dw_list1.SetFilter("")
		dw_ins.SetFilter("")
	end if
	tab_1.tabpage_1.dw_list1.Filter()
	dw_ins.Filter()
	
   IF tab_1.tabpage_1.dw_list1.Retrieve(ls_porgu,sGubun, sClass, sItemFrom, sItemTo) < 1	THEN
		f_message_chk(50, '[생산품목현황]')
		tab_1.tabpage_1.dw_1.setcolumn("gubun")
		tab_1.tabpage_1.dw_1.setfocus()
		RETURN
  END IF
  
  // 입고후 검사품 유무 조회
  dw_ins.Retrieve(ls_porgu,sGubun, sClass, sItemFrom, sItemTo, '%')
else
	if tab_1.tabpage_2.dw_2.Accepttext() = -1	then 	return

	ls_porgu	= tab_1.tabpage_2.dw_2.GetItemString(1, "porgu")
	IF isnull(ls_porgu) or trim(ls_porgu) = "" 	THEN
		f_message_chk(30,'[사업장]') 
		tab_1.tabpage_2.dw_2.setcolumn("porgu")
		tab_1.tabpage_2.dw_2.setfocus()
		RETURN
	END IF

	sCust		= trim(tab_1.tabpage_2.dw_2.GetItemString(1, "cvcod"))
	ls_ittyp = tab_1.tabpage_2.dw_2.GetItemString(1, "ittyp")
	ls_itcls = tab_1.tabpage_2.dw_2.GetItemString(1, "itcls")  
	sGubun2	= tab_1.tabpage_2.dw_2.GetItemString(1, "gubun2")

	if isnull(ls_ittyp) or ls_ittyp = "" then ls_ittyp = '%'
	if scust="" or isnull(scust) then scust = '%' 
	
	if ls_itcls = "" or isnull(ls_itcls) then 
		ls_itcls = '%'
	else
		ls_itcls = ls_itcls + '%'
	end if

	if sGubun2 = '1' then //검사방법 미지정
		tab_1.tabpage_2.dw_list2.SetFilter("isnull(qcgub) or qcgub = '' ")
	elseif sGubun2 = '2' then 
		tab_1.tabpage_2.dw_list2.SetFilter("qcgub > '.' ")
	else
		tab_1.tabpage_2.dw_list2.SetFilter("")
	end if
	tab_1.tabpage_2.dw_list2.Filter()
	
	IF	tab_1.tabpage_2.dw_list2.Retrieve(ls_porgu,sCust, ls_ittyp, ls_itcls) <	1		THEN
		f_message_chk(50, '[구매품목현황]')
		tab_1.tabpage_2.dw_2.setcolumn("ittyp")
		tab_1.tabpage_2.dw_2.setfocus()
		RETURN
	
	END IF

end if

//////////////////////////////////////////////////////////////////////////

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조회_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조회_up.gif"
end event

type tab_1 from tab within w_qct_01000
event create ( )
event destroy ( )
integer x = 73
integer y = 160
integer width = 4485
integer height = 2084
integer taborder = 10
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean raggedright = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.Control[]={this.tabpage_1,&
this.tabpage_2}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
end on

event selectionchanged;/* 규격,재질 Text 변경 */

If f_change_name('1') = 'Y' Then
	String sIspecText, sJijilText
	
	sIspectext = f_change_name('2')
	sJijilText = f_change_name('3')
	
	tab_1.tabpage_1.dw_list1.Object.ispec_tx.text =  sIspecText 
	tab_1.tabpage_1.dw_list1.object.jijil_tx.text =  sJijilText
	
	tab_1.tabpage_2.dw_list2.Object.ispec_tx.text =  sIspecText 
	tab_1.tabpage_2.dw_list2.object.jijil_tx.text =  sJijilText
End If
end event

type tabpage_1 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 96
integer width = 4448
integer height = 1972
long backcolor = 32106727
string text = "품목별"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
dw_list1 dw_list1
dw_1 dw_1
rr_1 rr_1
end type

on tabpage_1.create
this.dw_list1=create dw_list1
this.dw_1=create dw_1
this.rr_1=create rr_1
this.Control[]={this.dw_list1,&
this.dw_1,&
this.rr_1}
end on

on tabpage_1.destroy
destroy(this.dw_list1)
destroy(this.dw_1)
destroy(this.rr_1)
end on

type dw_list1 from datawindow within tabpage_1
event ue_pressenter pbm_dwnprocessenter
integer x = 27
integer y = 256
integer width = 4398
integer height = 1692
integer taborder = 30
string dataobject = "d_qct_01001"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;
IF this.GetColumnName() = 'qcrmks'	THEN	RETURN 1
Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemchanged;string	sCode, sName, sNull, sGrpno2
long		lRow, nFind

lRow = this.GetRow()
SetNull(sNull)

// 검사담당자
IF this.GetColumnName() = 'qcemp' THEN

	sCode = this.gettext()
	
	if scode = '' or isnull(scode) then return 
  SELECT "REFFPF"."RFNA1"  
    INTO :sName  
    FROM "REFFPF"  
   WHERE ( "REFFPF"."RFCOD" = '45' ) AND  
         ( "REFFPF"."RFGUB" = :sCode ) AND 
         ( "REFFPF"."RFGUB" <> '00' ) ;
	 
	if sqlca.sqlcode <> 0 	then
		f_message_chk(33,'[검사담당자]')
		this.setitem(lrow, "qcemp", sNull)
		return 1
	end if
	 
ELSEIF this.GetColumnName() = 'chgbn' THEN

	sCode = this.gettext()
	if scode = '' or isnull(scode) then return 
	
  SELECT "REFFPF"."RFNA1"  
    INTO :sName  
    FROM "REFFPF"  
   WHERE ( "REFFPF"."RFCOD" = '45' ) AND  
         ( "REFFPF"."RFGUB" = :sCode ) AND 
         ( "REFFPF"."RFGUB" <> '00' ) ;
	 
	if sqlca.sqlcode <> 0 	then
		f_message_chk(33,'[특채담당자]')
		this.setitem(lrow, "chgbn", sNull)
		return 1
	end if
// 선입고 여부 조정시
ELSEIF this.GetColumnName() = 'grpno2' THEN
	sGrpno2 = Trim(GetText())
	sCode = GetItemSTring(lRow, 'itnbr')
	
	nFind = dw_ins.Find("itnbr = '"+sCode +"'", 1, dw_ins.RowCount()) 
	If nFind > 0 Then
		dw_ins.SetItem(nFind, 'grpno2', sGrpno2)
	End If
END IF

end event

event itemerror;return 1
end event

event updatestart;/* Update() function 호출시 user 설정 */
long k, lRowCount

lRowCount = this.RowCount()

FOR k = 1 TO lRowCount
   IF NewModified! = this.GetItemStatus(k, 0, Primary!) THEN
 	   This.SetItem(k,'crt_user',gs_userid)
   ELSEIF DataModified! = this.GetItemStatus(k, 0, Primary!) THEN 		
	   This.SetItem(k,'upd_user',gs_userid)
   END IF	  
NEXT


end event

event rowfocuschanged;if 	currentrow < 1 then return 
if 	this.rowcount() < 1 then return 

this.setredraw(false)

this.SelectRow(0,False)
this.SelectRow(currentrow,True)

this.ScrollToRow(currentrow)

this.setredraw(true)

end event

type dw_1 from datawindow within tabpage_1
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 5
integer y = 8
integer width = 4434
integer height = 232
integer taborder = 20
string dataobject = "d_qct_01001_1"
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

type rr_1 from roundrectangle within tabpage_1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 248
integer width = 4425
integer height = 1712
integer cornerheight = 40
integer cornerwidth = 55
end type

type tabpage_2 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 96
integer width = 4448
integer height = 1972
long backcolor = 32106727
string text = "업체/품목별"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
dw_2 dw_2
dw_list2 dw_list2
rr_2 rr_2
end type

on tabpage_2.create
this.dw_2=create dw_2
this.dw_list2=create dw_list2
this.rr_2=create rr_2
this.Control[]={this.dw_2,&
this.dw_list2,&
this.rr_2}
end on

on tabpage_2.destroy
destroy(this.dw_2)
destroy(this.dw_list2)
destroy(this.rr_2)
end on

type dw_2 from datawindow within tabpage_2
event ue_keyenter pbm_dwnprocessenter
integer x = 14
integer y = 8
integer width = 4192
integer height = 216
integer taborder = 20
string dataobject = "d_qct_01002_1"
boolean border = false
boolean livescroll = true
end type

event ue_keyenter;Send(Handle(this),256,9,0)
Return 1
end event

event rbuttondown;
string	sItem,sNull

setnull(snull)
setnull(gs_code)
setnull(gs_codename)

IF	this.Getcolumnname() = "cvcod"	THEN		
	gs_code = this.GetText()
	IF IsNull(gs_code) THEN 
		this.SetItem(1, "cvcod", snull)
		this.setitem(1, "cvnas", snull)		
	end if
		
	gs_gubun = '1'
	Open(w_vndmst_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then  return

	this.SetItem(1, "cvcod", gs_Code)
	this.setitem(1, "cvnas", gs_CodeName)
END IF

if this.GetColumnName() = 'itcls' then
	sItem = this.GetItemString(1, 'ittyp')
	
	OpenWithParm(w_ittyp_popup, sItem)
	
	lstr_itnct = Message.PowerObjectParm	
	
	if isnull(lstr_itnct.s_ittyp) or lstr_itnct.s_ittyp = "" then return 
	
	this.SetItem(1,"ittyp",	lstr_itnct.s_ittyp)
	this.SetItem(1,"itcls", lstr_itnct.s_sumgub)
end if
end event

event itemchanged;String sCod,sNam,sNam1

scod = this.gettext()
IF	this.Getcolumnname() = "cvcod"	THEN		
	f_get_name2("V1", 'Y', scod, snam, snam1)

	this.SetItem(1, "cvcod", scod)
	this.setitem(1, "cvnas", snam)
end if
end event

event itemerror;Return 1
end event

type dw_list2 from datawindow within tabpage_2
event ue_pressenter pbm_dwnprocessenter
integer x = 41
integer y = 240
integer width = 4352
integer height = 1708
integer taborder = 30
string dataobject = "d_qct_01002"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemchanged;
string	sCode, sName, sNull
long		lRow
lRow = this.GetRow()
SetNull(sNull)

// 검사담당자
IF this.GetColumnName() = 'qcemp' THEN

	sCode = this.gettext()
  SELECT "REFFPF"."RFNA1"  
    INTO :sName  
    FROM "REFFPF"  
   WHERE ( "REFFPF"."RFCOD" = '45' ) AND  
         ( "REFFPF"."RFGUB" = :sCode ) AND  
         ( "REFFPF"."RFGUB" <> '00' ) ;
	 
	if sqlca.sqlcode <> 0 	then
		f_message_chk(33,'[검사담당자]')
		this.setitem(lrow, "qcemp", sNull)
		return 1
	end if
	 
END IF


string sDate
// 일자
IF this.GetColumnName() = 'danmst_handochdat' THEN
	sDate  = this.gettext()
	IF f_datechk(sDate) = -1	then
		this.setitem(lRow, "danmst_handochdat", sNull)
		return 1
	END IF
END IF


IF this.GetColumnName() = 'danmst_handojidat' THEN
	sDate  = this.gettext()
	IF f_datechk(sDate) = -1	then
		this.setitem(lRow, "danmst_handojidat", sNull)
		return 1
	END IF
END IF

end event

event itemerror;return 1
end event

event updatestart;/* Update() function 호출시 user 설정 */
long k, lRowCount

lRowCount = this.RowCount()

FOR k = 1 TO lRowCount
   IF NewModified! = this.GetItemStatus(k, 0, Primary!) THEN
 	   This.SetItem(k,'crt_user',gs_userid)
   ELSEIF DataModified! = this.GetItemStatus(k, 0, Primary!) THEN 		
	   This.SetItem(k,'upd_user',gs_userid)
   END IF	  
NEXT


end event

event rowfocuschanged;if 	currentrow < 1 then return 
if 	this.rowcount() < 1 then return 

this.setredraw(false)

this.SelectRow(0,False)
this.SelectRow(currentrow,True)

this.ScrollToRow(currentrow)

this.setredraw(true)

end event

type rr_2 from roundrectangle within tabpage_2
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 228
integer width = 4379
integer height = 1732
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_imhist from datawindow within w_qct_01000
boolean visible = false
integer x = 946
integer y = 36
integer width = 974
integer height = 92
boolean titlebar = true
string title = "입출고HISTORY"
string dataobject = "d_pme3001_imhist"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
end type

