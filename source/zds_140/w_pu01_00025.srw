$PBExportHeader$w_pu01_00025.srw
$PBExportComments$** 주간 구매 발주 취소
forward
global type w_pu01_00025 from window
end type
type cbx_del from checkbox within w_pu01_00025
end type
type pb_1 from u_pb_cal within w_pu01_00025
end type
type dw_2 from datawindow within w_pu01_00025
end type
type dw_1 from datawindow within w_pu01_00025
end type
type p_delrow from uo_picture within w_pu01_00025
end type
type p_addrow from uo_picture within w_pu01_00025
end type
type p_search from uo_picture within w_pu01_00025
end type
type p_exit from uo_picture within w_pu01_00025
end type
type p_can from uo_picture within w_pu01_00025
end type
type p_del from uo_picture within w_pu01_00025
end type
type p_mod from uo_picture within w_pu01_00025
end type
type p_inq from uo_picture within w_pu01_00025
end type
type cb_1 from commandbutton within w_pu01_00025
end type
type cb_delete from commandbutton within w_pu01_00025
end type
type cb_cancel from commandbutton within w_pu01_00025
end type
type rb_delete from radiobutton within w_pu01_00025
end type
type rb_insert from radiobutton within w_pu01_00025
end type
type dw_detail from datawindow within w_pu01_00025
end type
type cb_save from commandbutton within w_pu01_00025
end type
type cb_exit from commandbutton within w_pu01_00025
end type
type cb_retrieve from commandbutton within w_pu01_00025
end type
type rr_1 from roundrectangle within w_pu01_00025
end type
type rr_2 from roundrectangle within w_pu01_00025
end type
type rr_3 from roundrectangle within w_pu01_00025
end type
type dw_list from datawindow within w_pu01_00025
end type
type rr_4 from roundrectangle within w_pu01_00025
end type
type cbx_1 from checkbox within w_pu01_00025
end type
end forward

global type w_pu01_00025 from window
integer width = 4658
integer height = 2392
boolean titlebar = true
string title = "월 구매 발주 취소"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 32106727
cbx_del cbx_del
pb_1 pb_1
dw_2 dw_2
dw_1 dw_1
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
cbx_1 cbx_1
end type
global w_pu01_00025 w_pu01_00025

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
dw_list.reset()

dw_detail.enabled = TRUE

////////////////////////////////////////////////////////////////////////
dw_detail.setredraw(false)
if ic_status = '1' then
	w_mdi_frame.sle_msg.text = "등록"
else
	w_mdi_frame.sle_msg.text = "삭제"	
END IF

dw_list.settransobject(sqlca)
dw_detail.insertrow(0)

string	sempname, sdept, sdeptname

select empname, deptcode, fun_get_dptno(deptcode) 
  into :sempname, :sdept, :sdeptname 
  from p1_master
 where empno = :gs_empno ;

dw_detail.setitem(1,'empno1',gs_empno)
dw_detail.setitem(1,'empname1',sempname)
dw_detail.setitem(1,'deptcode1',sdept)
dw_detail.setitem(1,'deptname1',sdeptname)

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

dw_list.settransobject(sqlca)
dw_detail.insertrow(0)
dw_detail.setitem(1,'sdate',left(f_today(),6))
end event

on w_pu01_00025.create
this.cbx_del=create cbx_del
this.pb_1=create pb_1
this.dw_2=create dw_2
this.dw_1=create dw_1
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
this.cbx_1=create cbx_1
this.Control[]={this.cbx_del,&
this.pb_1,&
this.dw_2,&
this.dw_1,&
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
this.rr_4,&
this.cbx_1}
end on

on w_pu01_00025.destroy
destroy(this.cbx_del)
destroy(this.pb_1)
destroy(this.dw_2)
destroy(this.dw_1)
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
destroy(this.cbx_1)
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

type cbx_del from checkbox within w_pu01_00025
integer x = 2290
integer y = 116
integer width = 878
integer height = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "발주취소시 발주내역 삭제 여부"
end type

type pb_1 from u_pb_cal within w_pu01_00025
integer x = 859
integer y = 60
integer taborder = 20
end type

event clicked;call super::clicked;dw_detail.SetColumn('sdate')
IF IsNull(gs_code) THEN Return 
dw_detail.SetItem(1, 'sdate', left(gs_code,6))

end event

type dw_2 from datawindow within w_pu01_00025
boolean visible = false
integer x = 1285
integer y = 2332
integer width = 859
integer height = 600
integer taborder = 90
string title = "none"
string dataobject = "d_mro_popup2_a"
boolean border = false
boolean livescroll = true
end type

type dw_1 from datawindow within w_pu01_00025
boolean visible = false
integer x = 69
integer y = 2352
integer width = 4512
integer height = 200
integer taborder = 80
string title = "none"
string dataobject = "d_pu13_00030_a0"
boolean border = false
boolean livescroll = true
end type

type p_delrow from uo_picture within w_pu01_00025
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

type p_addrow from uo_picture within w_pu01_00025
boolean visible = false
integer x = 4805
integer y = 540
integer width = 178
integer taborder = 60
string pointer = "c:\ERPMAN\cur\addrow.cur"
string picturename = "C:\erpman\image\행추가_up.gif"
end type

event clicked;call super::clicked;//long	lrow
//
//lrow = dw_list.insertrow(0)
//
//dw_list.setrow(Lrow)
//dw_list.ScrollToRow(lRow)
//dw_list.SetColumn("itnbr")
//dw_list.SetFocus()
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\행추가_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\행추가_up.gif"
end event

type p_search from uo_picture within w_pu01_00025
boolean visible = false
integer x = 3776
integer y = 2444
integer width = 178
integer taborder = 90
string picturename = "C:\erpman\image\재고조회_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\재고조회_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\재고조회_up.gif"
end event

type p_exit from uo_picture within w_pu01_00025
integer x = 4302
integer y = 12
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

type p_can from uo_picture within w_pu01_00025
integer x = 4128
integer y = 12
integer width = 178
integer taborder = 70
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

dw_detail.reset()
dw_list.reset()
dw_detail.insertrow(0)
dw_detail.setitem(1,'sdate',left(f_today(),6))
dw_detail.setfocus()
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

type p_del from uo_picture within w_pu01_00025
boolean visible = false
integer x = 4837
integer y = 96
integer width = 178
integer taborder = 60
string pointer = "C:\erpman\cur\delete.cur"
string picturename = "C:\erpman\image\삭제_up.gif"
end type

event clicked;call super::clicked;//w_mdi_frame.sle_msg.text =""
//if ic_status = '1' then return
//
//long	i, lrow
//
//FOR lrow = 1 TO dw_list.rowcount()
//	if dw_list.getitemstring(1,'chk_flag') = 'N' then continue
//	i++
//NEXT
//if i < 1 then return
//
//if messagebox('확인','선택된 청구 자료를 삭제합니다.',question!,yesno!,1) = 2 then return
//
//
///* 청구 자료 삭제 */
//FOR lrow = dw_list.rowcount() TO 1 STEP -1
//	if dw_list.getitemstring(1,'chk_flag') = 'N' then continue
//	dw_list.deleterow(lrow)
//NEXT
//
//if dw_list.update() <> 1 then
//	rollback ;
//	messagebox('확인','청구 자료 삭제 실패!!!')
//	return
//end if
//
//commit ;
//messagebox('확인','자료를 삭제하였습니다.')
//cb_cancel.triggerevent(clicked!)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\삭제_up.gif"
end event

type p_mod from uo_picture within w_pu01_00025
integer x = 3954
integer y = 12
integer width = 178
integer taborder = 50
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event clicked;w_mdi_frame.sle_msg.text =""

if dw_list.rowcount() < 1 then return

if messagebox('확인','선택된 자료를 발주취소 처리합니다.',question!,yesno!,1) = 2 then return

setpointer(hourglass!)
if dw_list.update() <> 1 then
	rollback ;
	messagebox('확인','월 발주 취소 실패!!!')
	return
end if

commit ;

long		lrow, lseq, lbalseq
decimal	dqty
string	subject, scontent, sbaljpno, sitnbr, sitdsc, syymmdd, scvcod

FOR lrow = 1 TO dw_list.rowcount()
	if dw_list.getitemstring(lrow,'poblkt_balsts') = '1' then continue
	
	sbaljpno = dw_list.getitemstring(lrow,'baljpno')
	lbalseq  = dw_list.getitemnumber(lrow,'balseq')
	sitnbr	= dw_list.getitemstring(lrow,'itnbr')
	sitdsc	= dw_list.getitemstring(lrow,'itemas_itdsc')
	dqty		= dw_list.getitemnumber(lrow,'balqty')
	syymmdd	= dw_list.getitemstring(lrow,'docno')
	scvcod	= dw_list.getitemstring(lrow,'pomast_cvcod')
	
	subject = '[계획년월:' + string(syymmdd,'@@@@.@@') + '] 월 구매계획 취소 통보!!!'
	scontent= sbaljpno+'~t'+string(lbalseq)+'~t'+sitnbr+'~t'+sitdsc+'~t'+string(round(dqty,0))
	
	select nvl(max(no),0) into :lseq from et_notice ;
	
	lseq = lseq + 1
	
	insert into et_notice
	(	no,			subject,				content,				cre_id,				cre_dt,			cvcod	)
	values
	(	:lseq,		:subject,			:scontent,			:gs_userid,			sysdate,			:scvcod	) ;
	if sqlca.sqlcode <> 0 then
		Rollback;
//		MessageBox(string(sqlca.sqlcode), sqlca.sqlerrtext)
//		Return
	End If
NEXT

COMMIT;

// 발주내역 삭제
If cbx_del.Checked Then
	DELETE FROM POBLKT A WHERE A.BALSTS = '4' AND EXISTS ( SELECT * FROM POMAST B WHERE B.SABU = A.SABU AND B.BALJPNO = A.BALJPNO AND B.DOCNO = :syymmdd);
	DELETE FROM POMAST A WHERE A.DOCNO = :syymmdd AND NOT EXISTS ( SELECT * FROM POBLKT B WHERE B.SABU = A.SABU AND B.BALJPNO = A.BALJPNO );
	COMMIT;
End If

messagebox('확인','자료를 저장하였습니다.')

p_inq.triggerevent(clicked!)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

type p_inq from uo_picture within w_pu01_00025
integer x = 3781
integer y = 12
integer width = 183
integer taborder = 10
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event clicked;w_mdi_frame.sle_msg.text =""

if dw_detail.accepttext() = -1 then return

string	syymmdd, scvcod

syymmdd = trim(left(dw_detail.getitemstring(1,'sdate'),6))
if f_datechk(syymmdd+'01') = -1 then
	MessageBox('확 인','계획년월를 지정하세요.!!')
	Return
End If

scvcod = dw_detail.getitemstring(1,'cvcod')
if isnull(scvcod) or scvcod = '' then scvcod = '%'

setpointer(hourglass!)
if dw_list.retrieve(gs_sabu,syymmdd,scvcod,gs_saupj) < 1 then
	f_message_chk(50, '[월 발주 취소]')
	dw_detail.setfocus()
	return
end if
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조회_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조회_up.gif"
end event

type cb_1 from commandbutton within w_pu01_00025
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

type cb_delete from commandbutton within w_pu01_00025
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

type cb_cancel from commandbutton within w_pu01_00025
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

type rb_delete from radiobutton within w_pu01_00025
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
end type

event clicked;ic_status = '2'

dw_list.setredraw(false)
wf_Initial()
dw_list.setredraw(true)
end event

type rb_insert from radiobutton within w_pu01_00025
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
end type

event clicked;ic_status = '1'	// 등록

dw_list.setredraw(False)
wf_Initial()
dw_list.setredraw(true)
end event

type dw_detail from datawindow within w_pu01_00025
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 110
integer y = 44
integer width = 2089
integer height = 112
integer taborder = 10
string dataobject = "d_pu01_00025_1"
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

event rbuttondown;String sNull, sdate

setnull(gs_code)
setnull(gs_gubun)
setnull(gs_codename)
setnull(snull)

IF this.GetColumnName() = "sdate" THEN
	sdate = trim(this.gettext())
	if f_datechk(sdate+'01') = -1 then
		gs_code = left(f_today(),6)
	else
		gs_code = left(sdate,6)
	end if
//	Open(w_calendar_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then	return
	this.SetItem(1, "sdate", gs_Code)

ELSEIF this.GetColumnName() = "cvcod" THEN
	gs_gubun ='1'
	Open(w_vndmst_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then	return

	this.SetItem(1, "cvcod", gs_Code)
	this.triggerevent(itemchanged!)
END IF	
end event

event itemchanged;string snull, sbaljno, get_nm, s_date, s_empno, s_name, s_name2
int    ireturn 

setnull(snull)

IF this.GetColumnName() = "cvcod" THEN
	s_empno = this.GetText()
	
	ireturn = f_get_name2('V1', 'Y', s_empno, get_nm, s_name)
	this.setitem(1, "cvcod", s_empno)	
	this.setitem(1, "cvnas", get_nm)
	
	RETURN ireturn
END IF	

end event

type cb_save from commandbutton within w_pu01_00025
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

type cb_exit from commandbutton within w_pu01_00025
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

type cb_retrieve from commandbutton within w_pu01_00025
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

type rr_1 from roundrectangle within w_pu01_00025
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 16
integer width = 2203
integer height = 160
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_2 from roundrectangle within w_pu01_00025
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

type rr_3 from roundrectangle within w_pu01_00025
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 204
integer width = 4530
integer height = 2020
integer cornerheight = 40
integer cornerwidth = 46
end type

type dw_list from datawindow within w_pu01_00025
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 59
integer y = 216
integer width = 4503
integer height = 1996
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_pu01_00025_a"
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

event itemchanged;if this.gettext() = 'Y' then
	If dw_list.GetItemNumber(row, 'naqty') = 0 Then
		If dw_list.GetItemNumber(row, 'vndinqty') > 0  Then
			dw_list.setitem(row,'poblkt_balsts','3')
		Else
			dw_list.setitem(row,'poblkt_balsts','4')			
		End If
	End If
else
	this.setitem(row,'poblkt_balsts',this.getitemstring(row,'poblkt_temp'))
end if
end event

event clicked;If row > 0 Then
	this.SelectRow(0,false)
	this.SelectRow(row,true)
Else
	this.SelectRow(0,false)
End If
end event

type rr_4 from roundrectangle within w_pu01_00025
boolean visible = false
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 2340
integer width = 4530
integer height = 216
integer cornerheight = 40
integer cornerwidth = 46
end type

type cbx_1 from checkbox within w_pu01_00025
integer x = 96
integer y = 216
integer width = 73
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 28144969
string text = "전체선택"
end type

event clicked;Long ix

For ix = 1 To dw_list.RowCount()
	if This.Checked then
		If dw_list.GetItemNumber(ix, 'naqty') = 0 Then
			If dw_list.GetItemNumber(ix, 'vndinqty') > 0  Then
				dw_list.SetItem(ix, 'chk_flag', 'Y')
				dw_list.setitem(ix,'poblkt_balsts','3')
			Else
				dw_list.SetItem(ix, 'chk_flag', 'Y')
				dw_list.setitem(ix,'poblkt_balsts','4')			
			End If
		End If
	else
		dw_list.SetItem(ix, 'chk_flag', 'N')
		dw_list.setitem(ix,'poblkt_balsts', dw_list.getitemstring(ix,'poblkt_temp'))
	end if
Next
end event

