$PBExportHeader$w_qa02_00063.srw
$PBExportComments$** 매입클레임 확정
forward
global type w_qa02_00063 from window
end type
type dw_1 from datawindow within w_qa02_00063
end type
type st_1 from statictext within w_qa02_00063
end type
type p_delrow from uo_picture within w_qa02_00063
end type
type p_addrow from uo_picture within w_qa02_00063
end type
type p_search from uo_picture within w_qa02_00063
end type
type p_exit from uo_picture within w_qa02_00063
end type
type p_can from uo_picture within w_qa02_00063
end type
type p_del from uo_picture within w_qa02_00063
end type
type p_mod from uo_picture within w_qa02_00063
end type
type p_inq from uo_picture within w_qa02_00063
end type
type cb_1 from commandbutton within w_qa02_00063
end type
type cb_delete from commandbutton within w_qa02_00063
end type
type cb_cancel from commandbutton within w_qa02_00063
end type
type rb_delete from radiobutton within w_qa02_00063
end type
type rb_insert from radiobutton within w_qa02_00063
end type
type dw_detail from datawindow within w_qa02_00063
end type
type cb_save from commandbutton within w_qa02_00063
end type
type cb_exit from commandbutton within w_qa02_00063
end type
type cb_retrieve from commandbutton within w_qa02_00063
end type
type rr_1 from roundrectangle within w_qa02_00063
end type
type rr_2 from roundrectangle within w_qa02_00063
end type
type rr_3 from roundrectangle within w_qa02_00063
end type
type dw_list from datawindow within w_qa02_00063
end type
type rr_4 from roundrectangle within w_qa02_00063
end type
end forward

global type w_qa02_00063 from window
integer width = 5618
integer height = 4748
boolean titlebar = true
string title = "매입 클레임 확정"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 32106727
dw_1 dw_1
st_1 st_1
p_delrow p_delrow
p_addrow p_addrow
p_search p_search
p_exit p_exit
p_can p_can
p_del p_del
p_mod p_mod
p_inq p_inq
cb_1 cb_1
cb_delete cb_delete
cb_cancel cb_cancel
rb_delete rb_delete
rb_insert rb_insert
dw_detail dw_detail
cb_save cb_save
cb_exit cb_exit
cb_retrieve cb_retrieve
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
dw_list dw_list
rr_4 rr_4
end type
global w_qa02_00063 w_qa02_00063

type variables
boolean ib_ItemError
char ic_status
string is_Last_Jpno, is_Date

String     is_RateGub       //환율 사용여부(1:일일,2:예측)            

String     is_today              //시작일자
String     is_totime             //시작시간
String     is_window_id      //윈도우 ID
String     is_usegub           //이력관리 여부
String     is_qccheck         //검사수정여부
String     is_cnvart             //변환연산자
String     is_gubun             //변환계수사용여부
string      is_ispec, is_jijil  //규격, 재질명

str_mro	istmro
end variables

forward prototypes
public function integer wf_initial ()
end prototypes

public function integer wf_initial ();dw_detail.reset()
//dw_list.reset()
dw_1.reset()

dw_detail.enabled = TRUE

////////////////////////////////////////////////////////////////////////
dw_detail.setredraw(false)
if ic_status = '1' then
	w_mdi_frame.sle_msg.text = "등록"
else
	w_mdi_frame.sle_msg.text = "삭제"	
END IF

//dw_list.settransobject(sqlca)
dw_detail.insertrow(0)

dw_detail.setitem(1,'fdate',left(f_today(),6))

dw_detail.setredraw(true)

return  1
end function

event open;ListviewItem		lvi_Current
lvi_Current.Data = Upper(This.ClassName())
lvi_Current.Label = This.Title
lvi_Current.PictureIndex = 1

w_mdi_frame.lv_open_menu.additem(lvi_Current)

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

dw_1.settransobject(sqlca)
wf_initial()
end event

on w_qa02_00063.create
this.dw_1=create dw_1
this.st_1=create st_1
this.p_delrow=create p_delrow
this.p_addrow=create p_addrow
this.p_search=create p_search
this.p_exit=create p_exit
this.p_can=create p_can
this.p_del=create p_del
this.p_mod=create p_mod
this.p_inq=create p_inq
this.cb_1=create cb_1
this.cb_delete=create cb_delete
this.cb_cancel=create cb_cancel
this.rb_delete=create rb_delete
this.rb_insert=create rb_insert
this.dw_detail=create dw_detail
this.cb_save=create cb_save
this.cb_exit=create cb_exit
this.cb_retrieve=create cb_retrieve
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
this.dw_list=create dw_list
this.rr_4=create rr_4
this.Control[]={this.dw_1,&
this.st_1,&
this.p_delrow,&
this.p_addrow,&
this.p_search,&
this.p_exit,&
this.p_can,&
this.p_del,&
this.p_mod,&
this.p_inq,&
this.cb_1,&
this.cb_delete,&
this.cb_cancel,&
this.rb_delete,&
this.rb_insert,&
this.dw_detail,&
this.cb_save,&
this.cb_exit,&
this.cb_retrieve,&
this.rr_1,&
this.rr_2,&
this.rr_3,&
this.dw_list,&
this.rr_4}
end on

on w_qa02_00063.destroy
destroy(this.dw_1)
destroy(this.st_1)
destroy(this.p_delrow)
destroy(this.p_addrow)
destroy(this.p_search)
destroy(this.p_exit)
destroy(this.p_can)
destroy(this.p_del)
destroy(this.p_mod)
destroy(this.p_inq)
destroy(this.cb_1)
destroy(this.cb_delete)
destroy(this.cb_cancel)
destroy(this.rb_delete)
destroy(this.rb_insert)
destroy(this.dw_detail)
destroy(this.cb_save)
destroy(this.cb_exit)
destroy(this.cb_retrieve)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
destroy(this.dw_list)
destroy(this.rr_4)
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

long li_index

li_index = w_mdi_frame.lv_open_menu.FindItem(0,This.Title, TRUE,TRUE)

w_mdi_frame.lv_open_menu.DeleteItem(li_index)
w_mdi_frame.st_window.Text = ""
end event

type dw_1 from datawindow within w_qa02_00063
integer x = 55
integer y = 196
integer width = 4503
integer height = 2092
integer taborder = 70
string title = "none"
string dataobject = "w_qa02_00063_a"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event itemerror;return 1
end event

event itemchanged;long		lrow
string	schk, sgubun, snull

setnull(snull)
if this.getcolumnname() = "chk" then
	schk = this.gettext()
	
	sgubun = dw_detail.getitemstring(1,'okyn')
	if sgubun = 'N' then
		if schk = 'Y' then
			this.setitem(row,'okyn','3')
			this.setitem(row,'whdate',f_today())
		else
			this.setitem(row,'okyn','2')
			this.setitem(row,'whdate',snull)
		end if
	else
		if schk = 'Y' then
			this.setitem(row,'okyn','2')
			this.setitem(row,'whdate',snull)
		else
			this.setitem(row,'okyn','3')
			this.setitem(row,'whdate',f_today())
		end if
	end if
end if
end event

event clicked;If Row <= 0 then
	this.SelectRow(0,False)
ELSE
	this.SelectRow(0, FALSE)
	this.SelectRow(Row,TRUE)
END IF
end event

type st_1 from statictext within w_qa02_00063
boolean visible = false
integer x = 4786
integer y = 960
integer width = 402
integer height = 52
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean underline = true
long textcolor = 28144969
long backcolor = 32106727
string text = "상세정보"
boolean focusrectangle = false
end type

type p_delrow from uo_picture within w_qa02_00063
boolean visible = false
integer x = 4983
integer y = 540
integer width = 178
integer taborder = 70
string pointer = "c:\ERPMAN\cur\delrow.cur"
string picturename = "C:\erpman\image\행삭제_up.gif"
end type

event clicked;call super::clicked;//long	lrow
//
//lrow = dw_list.getrow()
//if lrow < 1 then return
//
//dw_list.deleterow(lrow)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\행삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\행삭제_up.gif"
end event

type p_addrow from uo_picture within w_qa02_00063
integer x = 3287
integer y = 16
integer width = 178
integer taborder = 60
string pointer = "c:\ERPMAN\cur\addrow.cur"
string picturename = "C:\erpman\image\전체선택_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\전체선택_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\전체선택_up.gif"
end event

event clicked;call super::clicked;long		lrow
string	sgubun, snull

if dw_1.rowcount() < 1 then return

setnull(snull)
sgubun = dw_detail.getitemstring(1,'okyn')

dw_1.setredraw(false)
for lrow = 1 to dw_1.rowcount()
	if dw_1.getitemstring(lrow,'okyn') > '3' then continue
	if dw_1.getitemstring(lrow,'chk') = 'Y' then continue
	dw_1.setitem(lrow,'chk','Y')
	if sgubun = 'N' then
		dw_1.setitem(lrow,'okyn','3')
		dw_1.setitem(lrow,'whdate',f_today())
	else
		dw_1.setitem(lrow,'okyn','2')
		dw_1.setitem(lrow,'whdate',snull)
	end if
next
dw_1.setredraw(true)
end event

type p_search from uo_picture within w_qa02_00063
boolean visible = false
integer x = 4686
integer y = 480
integer width = 178
integer taborder = 90
string pointer = "HyperLink!"
string picturename = "C:\erpman\image\결재상신.gif"
end type

event ue_lbuttondown;//PictureName = "C:\erpman\image\재고조회_dn.gif"
end event

event ue_lbuttonup;//PictureName = "C:\erpman\image\재고조회_up.gif"
end event

event clicked;long		lrow, lcnt
string	sjpno, sgwyn

if dw_list.rowcount() < 1 then
	messagebox('확인','상세정보를 조회한 후 처리하십시오')
	return
end if	

sgwyn = 'N'
FOR lrow = 1 TO dw_list.rowcount()
	if dw_list.getitemstring(lrow,'estima_balokyn') = 'Y' then
		sgwyn = 'Y'
		exit
	end if
NEXT

if sgwyn = 'N' then
	messagebox('확인','전자결재 대상이 아닙니다.')
	return
end if

FOR lrow = 1 TO dw_list.rowcount()
	if	dw_list.getitemstring(lrow,'estima_oferyn') = 'Y' then 
		messagebox('확인','MRO 계약 처리를 먼저 하십시오')
		return
	end if
	if	dw_list.getitemstring(lrow,'estima_chokyn') <> 'Y' then 
		messagebox('확인','청구 승인되지 않은 자료는 결재상신할 수 없습니다')
		return
	end if	
NEXT

//그룹웨어 연동구분
STRING s_gwgbn

Select dataname into :s_gwgbn
  from syscnfg
 where sysgu = 'W' and
		 serial = 1 and
		 lineno = '1';

/* 전자결제 상신 */
IF s_gwgbn = 'Y' and sgwyn = 'Y' then
//	if Wf_Insert_kfz19ot9gw(LsGyelDate) = -1 then
//		F_MessageChk(13,'[전자결재 상신 자료]')
//		Rollback;
//		Return
//	else
//		Commit;
//	end if

	sjpno = left(dw_list.getitemstring(1,'estima_estno'),12)
	
	gs_code  = "&SABU=1&ESTNO="+sjpno+"___"
	gs_gubun = '0000000071'	//그룹웨어 문서번호
	SetNull(gs_codename)
	
	WINDOW LW_WINDOW
	OpenSheetWithParm(lw_window, 'w_groupware_browser', 'w_groupware_browser', w_mdi_frame, 0, Layered!)
	SetPointer(Arrow!)
	w_mdi_frame.sle_msg.text = '자료를 저장하였습니다!!'
END IF
end event

type p_exit from uo_picture within w_qa02_00063
integer x = 4302
integer y = 16
integer width = 178
integer taborder = 80
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;w_mdi_frame.sle_msg.text =""
//IF wf_warndataloss("종료") = -1 THEN  	RETURN

close(parent)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type p_can from uo_picture within w_qa02_00063
integer x = 4128
integer y = 16
integer width = 178
integer taborder = 70
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

wf_initial()
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

type p_del from uo_picture within w_qa02_00063
integer x = 3461
integer y = 16
integer width = 178
integer taborder = 60
string pointer = "HyperLink!"
string picturename = "C:\erpman\image\전체해제_up.gif"
end type

event ue_lbuttondown;PictureName = "C:\erpman\image\전체해제_dn.gif"
end event

event ue_lbuttonup;PictureName = "C:\erpman\image\전체해제_up.gif"
end event

event clicked;call super::clicked;long		lrow
string	sgubun, snull

if dw_1.rowcount() < 1 then return

setnull(snull)
sgubun = dw_detail.getitemstring(1,'okyn')

dw_1.setredraw(false)
for lrow = 1 to dw_1.rowcount()
	if dw_1.getitemstring(lrow,'okyn') > '3' then continue
	if dw_1.getitemstring(lrow,'chk') = 'N' then continue
	dw_1.setitem(lrow,'chk','N')
	if sgubun = 'N' then 
		dw_1.setitem(lrow,'okyn','2')
		dw_1.setitem(lrow,'whdate',snull)
	else
		dw_1.setitem(lrow,'okyn','3')
		dw_1.setitem(lrow,'whdate',f_today())
	end if
next
dw_1.setredraw(true)
end event

type p_mod from uo_picture within w_qa02_00063
integer x = 3954
integer y = 16
integer width = 178
integer taborder = 50
string pointer = "HyperLink!"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event clicked;w_mdi_frame.sle_msg.text =""

if dw_1.rowcount() < 1 then return

if dw_detail.accepttext() = -1 then return

if dw_1.update() <> 1 then
	rollback ;
	messagebox('확인','매입 클레임 승인 실패!!!')
	return
end if

commit ;

p_inq.triggerevent(clicked!)
end event

event ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

type p_inq from uo_picture within w_qa02_00063
integer x = 3781
integer y = 16
integer width = 183
integer taborder = 10
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event clicked;w_mdi_frame.sle_msg.text =""

if dw_detail.accepttext() = -1 then return

string	sdate1, sdeptcode1, sokyn


sdate1 = trim(dw_detail.getitemstring(1,'fdate'))
if isnull(sdate1) or sdate1 = "" then
	f_message_chk(30,'[기준년월]')
	dw_detail.setfocus()
	return
end if

sdeptcode1 = dw_detail.getitemstring(1,'deptcode1')
if isnull(sdeptcode1) or sdeptcode1 = '' then sdeptcode1 = '%'

sokyn = dw_detail.getitemstring(1,'okyn')
if sokyn = 'N' then
	dw_1.dataobject = 'w_qa02_00063_a'
else
	dw_1.dataobject = 'w_qa02_00063_b'
end if
dw_1.settransobject(sqlca)

setpointer(hourglass!)
if dw_1.retrieve(gs_saupj,sdate1,sdeptcode1,sokyn) < 1 then
	f_message_chk(50, '[매입 클레임 확정]')
	dw_detail.setfocus()
	return
end if


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조회_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조회_up.gif"
end event

type cb_1 from commandbutton within w_qa02_00063
boolean visible = false
integer x = 3264
integer y = 2580
integer width = 421
integer height = 108
integer taborder = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "재고조회"
end type

type cb_delete from commandbutton within w_qa02_00063
boolean visible = false
integer x = 722
integer y = 2956
integer width = 347
integer height = 108
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "삭제(&D)"
end type

type cb_cancel from commandbutton within w_qa02_00063
boolean visible = false
integer x = 3314
integer y = 2736
integer width = 347
integer height = 108
integer taborder = 70
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "취소(&C)"
end type

type rb_delete from radiobutton within w_qa02_00063
boolean visible = false
integer x = 5070
integer y = 344
integer width = 242
integer height = 52
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "수정"
borderstyle borderstyle = stylelowered!
end type

event clicked;ic_status = '2'

dw_list.setredraw(false)
wf_Initial()
dw_list.setredraw(true)
end event

type rb_insert from radiobutton within w_qa02_00063
boolean visible = false
integer x = 4791
integer y = 344
integer width = 242
integer height = 52
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "등록"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;ic_status = '1'	// 등록

dw_list.setredraw(False)
wf_Initial()
dw_list.setredraw(true)
end event

type dw_detail from datawindow within w_qa02_00063
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 87
integer y = 36
integer width = 2981
integer height = 92
integer taborder = 10
string dataobject = "w_qa02_00063_1"
boolean border = false
boolean livescroll = true
end type

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;
IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemerror;RETURN 1
end event

event losefocus;this.accepttext()
end event

event itemchanged;string	sempno, sempname, sdept, sdeptname, snull
string	sestno, sempno2, sempname2, sdept2, sdeptname2, syongdo, sdepot

setnull(snull)
if this.getcolumnname() = 'deptcode1' then
	sdept = this.gettext()

	if isnull(sdept) or sdept = '' then
		this.setitem(1,'deptname1',snull)
		return
	end if

	select cvnas into :sdeptname from vndmst
	 where cvcod = :sdept ;
	 
	if sqlca.sqlcode = 0 then
		this.setitem(1,'deptname1',sdeptname)
	else
		messagebox('확인','등록되지 않은 거래처입니다')
		this.setitem(1,'deptcode1',snull)
		this.setitem(1,'deptname1',snull)
		return 1
	end if
	
elseif this.getcolumnname() = 'okyn' then
	dw_1.reset()
end if
	
		
end event

event rbuttondown;setnull(gs_gubun)
setnull(gs_code)
setnull(gs_codename)

if this.getcolumnname() = 'deptcode1' then
	open(w_vndmst_popup)
	if isnull(gs_code) or gs_code = '' then return
	
	this.setitem(1,'deptcode1',gs_code)
	this.triggerevent(itemchanged!)
end if
end event

type cb_save from commandbutton within w_qa02_00063
boolean visible = false
integer x = 361
integer y = 2956
integer width = 347
integer height = 108
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "저장(&S)"
end type

type cb_exit from commandbutton within w_qa02_00063
event key_in pbm_keydown
boolean visible = false
integer x = 3680
integer y = 2736
integer width = 347
integer height = 108
integer taborder = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "종료(&X)"
end type

type cb_retrieve from commandbutton within w_qa02_00063
boolean visible = false
integer y = 2956
integer width = 347
integer height = 108
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "조회(&R)"
end type

type rr_1 from roundrectangle within w_qa02_00063
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 46
integer y = 16
integer width = 3104
integer height = 148
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_2 from roundrectangle within w_qa02_00063
boolean visible = false
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 4699
integer y = 288
integer width = 677
integer height = 160
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_3 from roundrectangle within w_qa02_00063
boolean visible = false
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 4773
integer y = 1032
integer width = 375
integer height = 296
integer cornerheight = 40
integer cornerwidth = 46
end type

type dw_list from datawindow within w_qa02_00063
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
boolean visible = false
integer x = 4786
integer y = 1044
integer width = 302
integer height = 232
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_pu13_00030_1_a"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;
IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemerror;////////////////////////////////////////////////////////////////////////////
//		* Error Message Handling  1
////////////////////////////////////////////////////////////////////////////

//	1) ItemChanged -> Required Column 이 아닌 Column 에서 Error 발생시 

IF ib_ItemError = true	THEN	
	ib_ItemError = false		
	RETURN 1
END IF



//	2) Required Column  에서 Error 발생시 

string	sColumnName
sColumnName = dwo.name + "_t.text"


w_mdi_frame.sle_msg.text = "  필수입력항목 :  " + this.Describe(sColumnName) + "   입력하세요."

RETURN 1
end event

event type long updatestart();///* Update() function 호출시 user 설정 */
//long k, lRowCount
//
//lRowCount = this.RowCount()
//
//FOR k = 1 TO lRowCount
//   IF NewModified! = this.GetItemStatus(k, 0, Primary!) THEN
// 	   This.SetItem(k,'crt_user',gs_userid)
//   ELSEIF DataModified! = this.GetItemStatus(k, 0, Primary!) THEN 		
//	   This.SetItem(k,'upd_user',gs_userid)
//   END IF	  
//NEXT
//
//
return 0
end event

event clicked;If row <= 0 then
	this.SelectRow(0,False)
ELSE
	this.SelectRow(0, FALSE)
	this.SelectRow(row,TRUE)
END IF
end event

type rr_4 from roundrectangle within w_qa02_00063
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 188
integer width = 4530
integer height = 2112
integer cornerheight = 40
integer cornerwidth = 46
end type

