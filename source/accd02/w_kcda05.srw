$PBExportHeader$w_kcda05.srw
$PBExportComments$결산기준코드등록
forward
global type w_kcda05 from window
end type
type p_exit from uo_picture within w_kcda05
end type
type p_can from uo_picture within w_kcda05
end type
type p_del from uo_picture within w_kcda05
end type
type p_mod from uo_picture within w_kcda05
end type
type p_ins from uo_picture within w_kcda05
end type
type p_inq from uo_picture within w_kcda05
end type
type cbx_1 from checkbox within w_kcda05
end type
type cb_1 from commandbutton within w_kcda05
end type
type dw_ret from datawindow within w_kcda05
end type
type cb_mod from commandbutton within w_kcda05
end type
type cb_ins from commandbutton within w_kcda05
end type
type cb_del from commandbutton within w_kcda05
end type
type cb_inq from commandbutton within w_kcda05
end type
type st_1 from statictext within w_kcda05
end type
type cb_can from commandbutton within w_kcda05
end type
type dw_datetime from datawindow within w_kcda05
end type
type sle_msg from singlelineedit within w_kcda05
end type
type dw_ip from datawindow within w_kcda05
end type
type gb_1 from groupbox within w_kcda05
end type
type gb_2 from groupbox within w_kcda05
end type
type rr_1 from roundrectangle within w_kcda05
end type
end forward

global type w_kcda05 from window
integer width = 4658
integer height = 2440
boolean titlebar = true
string title = "결산 기준자료 등록"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 32106727
p_exit p_exit
p_can p_can
p_del p_del
p_mod p_mod
p_ins p_ins
p_inq p_inq
cbx_1 cbx_1
cb_1 cb_1
dw_ret dw_ret
cb_mod cb_mod
cb_ins cb_ins
cb_del cb_del
cb_inq cb_inq
st_1 st_1
cb_can cb_can
dw_datetime dw_datetime
sle_msg sle_msg
dw_ip dw_ip
gb_1 gb_1
gb_2 gb_2
rr_1 rr_1
end type
global w_kcda05 w_kcda05

type variables
string        Is_fsGbn
Boolean    ib_any_typing

w_preview  iw_preview


String	is_window_id
String     is_today              //시작일자
String     is_totime             //시작시간
String     sModStatus
String     is_usegub           //이력관리 여부
end variables

forward prototypes
public function integer wf_warndataloss (string as_titletext)
public function integer wf_requiredchk (integer irow)
end prototypes

public function integer wf_warndataloss (string as_titletext);/*=============================================================================================
		 1. window-level user function : 종료, 등록시 호출됨
		    dw_detail 의 typing(datawindow) 변경사항 검사

		 2. 계속진행할 경우 변경사항이 저장되지 않음을 경고                                                               

		 3. Argument:  as_titletext (warning messagebox)                                                                          
		    Return values:                                                   
                                                                  
      	*  1 : 변경사항을 저장하지 않고 계속 진행할 경우.
			* -1 : 진행을 중단할 경우.                      
=============================================================================================*/

IF ib_any_typing = true THEN  				// EditChanged event(dw_detail)의 typing 상태확인

	Beep(1)
	IF MessageBox("확인 : " + as_titletext , &
		 "저장하지 않은 값이 있습니다. ~r변경사항을 저장하시겠습니까", &
		 question!, yesno!) = 1 THEN

		RETURN -1									
	else
		rollback;
	END IF

END IF

RETURN 1												// (dw_detail) 에 변경사항이 없거나 no일 경우
														// 변경사항을 저장하지 않고 계속진행 

end function

public function integer wf_requiredchk (integer irow);String sFsGbn,sName,sAcc1,sAcc2,sFsNo,sAmtGbn
Long   lFsSeq

dw_ret.AcceptText()

sFsGbn  = dw_ret.Getitemstring(iRow,"fs_gu")
lFsSeq  = dw_ret.Getitemnumber(iRow,"fs_seq")
sFsNo   = dw_ret.Getitemstring(iRow,"fs_no")
sAcc1   = dw_ret.Getitemstring(iRow,"acc1_cd")
sAcc2   = dw_ret.Getitemstring(iRow,"acc2_cd")
sName   = dw_ret.Getitemstring(iRow,"kname")
sAmtGbn = dw_ret.Getitemstring(iRow,"amt_gu")

IF sFsGbn = '' OR IsNull(sFsGbn) THEN
	F_messagechk(1,"결산서구분코드")
   dw_ret.SetColumn("fs_gu")
   dw_ret.SetFocus()
   return -1
END IF

if lFsSeq <= 0 OR IsNull(lFsSeq) then
   f_messagechk(1,"결산서순번")
   dw_ret.SetColumn("fs_seq")
   dw_ret.SetFocus()
   return -1
end if

if IsNull(sName) or sName = '' then
   f_messagechk(1,"과목명")
   dw_ret.SetColumn("kname")
   dw_ret.SetFocus()
   return -1
end if

//IF sFsNo = '' OR IsNull(sFsNo) THEN
//	F_messagechk(1,"레벨")
//   dw_ret.SetColumn("fs_no")
//   dw_ret.SetFocus()
//   return -1
//END IF
IF sAmtGbn = '' OR IsNull(sAmtGbn) THEN
	F_messagechk(1,"금액구분")
   dw_ret.SetColumn("amt_gu")
   dw_ret.SetFocus()
   return -1
ELSE
	IF sAmtGbn = '1' or sAmtGbn = '2' or sAmtGbn = '3' or sAmtGbn = '4' THEN
		IF sAcc1 = '' OR IsNull(sAcc1) THEN
			F_messagechk(1,"계정과목")
			dw_ret.SetColumn("acc1_cd")
			dw_ret.SetFocus()
			return -1
		END IF
		IF sAcc2 = '' OR IsNull(sAcc2) THEN
			F_messagechk(1,"계정과목")
			dw_ret.SetColumn("acc2_cd")
			dw_ret.SetFocus()
			return -1
		END IF
				
	END IF
END IF

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
dw_ret.SetTransObject(SQLCA)

dw_ip.Reset()
dw_ip.InsertRow(0)
dw_ip.SetFocus()

dw_ret.Reset()
ib_any_typing =False

open( iw_preview, this)

end event

on w_kcda05.create
this.p_exit=create p_exit
this.p_can=create p_can
this.p_del=create p_del
this.p_mod=create p_mod
this.p_ins=create p_ins
this.p_inq=create p_inq
this.cbx_1=create cbx_1
this.cb_1=create cb_1
this.dw_ret=create dw_ret
this.cb_mod=create cb_mod
this.cb_ins=create cb_ins
this.cb_del=create cb_del
this.cb_inq=create cb_inq
this.st_1=create st_1
this.cb_can=create cb_can
this.dw_datetime=create dw_datetime
this.sle_msg=create sle_msg
this.dw_ip=create dw_ip
this.gb_1=create gb_1
this.gb_2=create gb_2
this.rr_1=create rr_1
this.Control[]={this.p_exit,&
this.p_can,&
this.p_del,&
this.p_mod,&
this.p_ins,&
this.p_inq,&
this.cbx_1,&
this.cb_1,&
this.dw_ret,&
this.cb_mod,&
this.cb_ins,&
this.cb_del,&
this.cb_inq,&
this.st_1,&
this.cb_can,&
this.dw_datetime,&
this.sle_msg,&
this.dw_ip,&
this.gb_1,&
this.gb_2,&
this.rr_1}
end on

on w_kcda05.destroy
destroy(this.p_exit)
destroy(this.p_can)
destroy(this.p_del)
destroy(this.p_mod)
destroy(this.p_ins)
destroy(this.p_inq)
destroy(this.cbx_1)
destroy(this.cb_1)
destroy(this.dw_ret)
destroy(this.cb_mod)
destroy(this.cb_ins)
destroy(this.cb_del)
destroy(this.cb_inq)
destroy(this.st_1)
destroy(this.cb_can)
destroy(this.dw_datetime)
destroy(this.sle_msg)
destroy(this.dw_ip)
destroy(this.gb_1)
destroy(this.gb_2)
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

type p_exit from uo_picture within w_kcda05
integer x = 4393
integer width = 178
integer taborder = 80
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
IF wf_warndataloss("종료") = -1 THEN  	RETURN

close(parent)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type p_can from uo_picture within w_kcda05
integer x = 4219
integer width = 178
integer taborder = 70
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

dw_ip.SetFocus()

dw_ret.Reset()

p_ins.Enabled = False
p_ins.picturename = "C:\erpman\image\추가_d.gif"

ib_any_typing = False
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

type p_del from uo_picture within w_kcda05
integer x = 4046
integer width = 178
integer taborder = 60
string pointer = "C:\erpman\cur\delete.cur"
string picturename = "C:\erpman\image\삭제_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

Integer k
Long    lSeqNo

IF dw_ret.GetRow() <= 0 THEN
	f_messagechk(11,'')
	Return
ELSE
	lSeqNo = dw_ret.GetItemNumber(dw_ret.GetRow(),"fs_seq")
END IF

IF F_DbConFirm('삭제') = 2 THEN RETURN

dw_ret.DeleteRow(dw_ret.GetRow())
IF dw_ret.Update() = 1 THEN
	
	delete from kfz02ot0 where fs_gu = :Is_FsGbn and fs_seq = :lSeqNo;
	commit;
	
	FOR k = 1 TO dw_ret.RowCount()
		dw_ret.SetItem(k,'sflag','M')
	NEXT
	
	dw_ret.SetColumn("kname")
	dw_ret.SetFocus()
	
	ib_any_typing = False
	w_mdi_frame.sle_msg.text ="자료가 삭제되었습니다.!!!"
ELSE
	ROLLBACK;
	f_messagechk(12,'')
END IF

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\삭제_up.gif"
end event

type p_mod from uo_picture within w_kcda05
integer x = 3872
integer width = 178
integer taborder = 50
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

Integer k,iRtnValue
Long    lSeqNo
String  sFsGu

IF dw_ret.AcceptText() = -1 THEN Return

IF dw_ret.RowCount() > 0 THEN
	FOR k = 1 TO dw_ret.RowCount()
		iRtnValue = Wf_RequiredChk(k)
		IF iRtnValue = -1 THEN RETURN
	NEXT
ELSE
	Return
END IF

IF f_dbConFirm('저장') = 2 THEN RETURN

IF dw_ret.Update() = 1 THEN
	
	FOR k = 1 TO dw_ret.RowCount()
		dw_ret.SetItem(k,'sflag','M')
		
		if dw_ret.GetItemString(k,"amt_gu") <> '9' then
			sFsGu  = dw_ret.GetItemString(k,"fs_gu")
			lSeqNo = dw_ret.GetItemNumber(k,"fs_seq")
			
			delete from kfz02ot0 where fs_gu = :sFsGu and fs_seq = :lSeqNo;
		end if
	NEXT
	commit;

	dw_ret.SetColumn("kname")
	dw_ret.SetFocus()
	
	ib_any_typing = False
	w_mdi_frame.sle_msg.text ="자료가 저장되었습니다.!!!"
ELSE
	ROLLBACK;
	f_messagechk(13,'')
END IF

IF dw_ret.RowCount() <=0 THEN
	p_ins.Enabled = False
	p_ins.picturename = "C:\erpman\image\추가_d.gif"
ELSE
	p_ins.Enabled = True
	p_ins.picturename = "C:\erpman\image\추가_up.gif"
END IF
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

type p_ins from uo_picture within w_kcda05
integer x = 3698
integer y = 4
integer width = 178
integer taborder = 30
string pointer = "C:\erpman\cur\new.cur"
string picturename = "C:\erpman\image\추가_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

Integer  iCurRow,iFunctionValue,iRowCount

w_mdi_frame.sle_msg.text =""

iRowCount = dw_ret.GetRow()

IF iRowCount > 0 THEN
	iFunctionValue = Wf_RequiredChk(dw_ret.GetRow())
	IF iFunctionValue <> 1 THEN RETURN
ELSE
	iFunctionValue = 1	
	
	iRowCount = 0
END IF

IF iFunctionValue = 1 THEN
	iCurRow = iRowCount + 1
	
	dw_ret.InsertRow(iCurRow)

	dw_ret.ScrollToRow(iCurRow)
	
	dw_ret.SetItem(iCurRow,'sflag',    'I')
	dw_ret.SetItem(iCurRow,"fs_gu",    Is_FsGbn)
	dw_ret.SetColumn("fs_seq")
	
	dw_ret.SetFocus()
	
	ib_any_typing =False

END IF

IF dw_ret.RowCount() <=0 THEN
	p_ins.Enabled = False
	p_ins.picturename = "C:\erpman\image\추가_d.gif"
ELSE
	p_ins.Enabled = True
	p_ins.picturename = "C:\erpman\image\추가_up.gif"
END IF


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\추가_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\추가_up.gif"
end event

type p_inq from uo_picture within w_kcda05
integer x = 3525
integer y = 4
integer width = 178
integer taborder = 20
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

String sNull

dw_ip.AcceptText()
Is_FsGbn = dw_ip.Getitemstring(dw_ip.getrow(),"fs_gu")
IF Is_FsGbn = '' OR IsNull(Is_FsGbn) THEN
	F_MessageChk(1,'[결산서구분]')
	dw_ip.SetColumn("fs_gu")
	dw_ip.SetFocus()
	Return
END IF

w_mdi_frame.sle_msg.text =""

p_ins.Enabled = True
p_ins.PictureName = "C:\erpman\image\추가_up.gif"

IF dw_ret.Retrieve(Is_FsGbn) <=0 THEN
	F_MessageChk(14,'')
	dw_ip.SetColumn("fs_gu")
	dw_ip.SetFocus()
	Return
ELSE
	dw_ret.Setcolumn("kname")
	dw_ret.SetFocus()
END IF

ib_any_typing  = False



end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조회_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조회_up.gif"
end event

type cbx_1 from checkbox within w_kcda05
integer x = 2688
integer y = 48
integer width = 709
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "결산기준자료 미리보기"
borderstyle borderstyle = stylelowered!
end type

event clicked;cbx_1.Checked = False

IF Is_FsGbn = '' OR IsNull(Is_FsGbn) THEN 
	F_MessageChk(1,'[결산서구분]')
	dw_ip.SetColumn("fs_gu")
	dw_ip.SetFocus()
	Return
END IF

iw_preview.title = '결산기준자료 미리보기'
iw_preview.dw_preview.dataobject = 'dw_kcda053'
iw_preview.dw_preview.settransobject(sqlca)
iw_preview.dw_preview.modify( 'datawindow.print.preview=yes &
					datawindow.print.preview.zoom=100 datawindow.print.orientation=1 &
					datawindow.print.margin.left=280 datawindow.zoom=100' )

iw_preview.dw_preview.reset()	
IF iw_preview.dw_preview.retrieve(Is_FsGbn) <=0 THEN
	f_messagechk(14,'')
	iw_preview.Visible = False
	Return	
END IF
iw_preview.Visible =True
end event

type cb_1 from commandbutton within w_kcda05
integer x = 3246
integer y = 2572
integer width = 293
integer height = 108
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "종료(&X)"
end type

event clicked;sle_msg.text =""

IF wf_warndataloss("종료") = -1 THEN  	RETURN

close(parent)

end event

type dw_ret from datawindow within w_kcda05
event ue_key pbm_dwnkey
event ue_enter pbm_dwnprocessenter
integer x = 46
integer y = 160
integer width = 4517
integer height = 2108
integer taborder = 40
string dataobject = "dw_kcda052"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_enter;Send(Handle(this),256,9,0)
Return 1
end event

event editchanged;ib_any_typing = True
end event

event retrieveend;Integer k

FOR k = 1 TO rowcount
	this.SetItem(k,'sflag','M')
NEXT
end event

event itemchanged;String    sacc1,sacc2,sAcc1Name,sAcc2Name,sAmtGbn,sNull
Integer   iReturnRow,lNull

SetNull(sNull)
SetNull(lNull)

IF this.GetColumnName() = 'fs_seq' THEN
	IF this.GetText() = '' OR IsNull(this.GetText()) THEN Return
	
	iReturnRow = this.find("fs_gu ='" + Is_FsGbn + "' and str_fsseq = '" + this.GetText()+"'", 1, this.RowCount())

	IF (this.GetRow() <> iReturnRow) and (iReturnRow <> 0) THEN
		f_MessageChk(10,'[순번]')
		this.Setitem(this.getrow(),"fs_seq",lNull)
		Return 1 
	END IF

END IF
IF this.GetColumnName() = "acc1_cd" THEN
	sAcc1 = this.GetText()
	IF sAcc1 = "" OR IsNull(sAcc1) THEN RETURN
	
	sAcc2 = this.GetItemString(this.GetRow(),"acc2_cd")
	IF sAcc2 = "" OR IsNull(sAcc2) THEN RETURN
	
	SELECT "KFZ01OM0"."ACC1_NM",   	 "KFZ01OM0"."ACC2_NM"  
	  INTO :sAcc1Name,					 :sAcc2Name
	  FROM "KFZ01OM0"  
	  WHERE ( "KFZ01OM0"."ACC1_CD" = :sAcc1 ) AND ( "KFZ01OM0"."ACC2_CD" = :sAcc2 ) ;
	If Sqlca.Sqlcode = 0 then
		this.Setitem(this.getrow(),"accname",sAcc2Name)
	else
		f_messageChk(20,'[계정과목]')
		this.Setitem(this.getrow(),"accname",sNull)
		Return 1
	end if
END IF

IF this.GetColumnName() = 'acc2_cd' THEN
	sAcc2 = this.GetText()
	IF sAcc2 = "" OR IsNull(sAcc2) THEN RETURN
	
	sAcc1 = this.GetItemString(this.GetRow(),"acc1_cd")
	IF sAcc1 = "" OR IsNull(sAcc1) THEN RETURN
	
	SELECT "KFZ01OM0"."ACC1_NM",   	 "KFZ01OM0"."ACC2_NM"  
	  INTO :sAcc1Name,					 :sAcc2Name
	  FROM "KFZ01OM0"  
	  WHERE ( "KFZ01OM0"."ACC1_CD" = :sAcc1 ) AND ( "KFZ01OM0"."ACC2_CD" = :sAcc2 ) ;
	If Sqlca.Sqlcode = 0 then
		this.Setitem(this.getrow(),"accname",sAcc2Name)
	else
		f_messageChk(20,'[계정과목]')
		this.Setitem(this.getrow(),"accname",sNull)
		Return 1
	end if	
END IF

IF this.GetColumnName() = "amt_gu" THEN
	sAmtGbn = this.GetText()
	IF sAmtGbn = "" OR IsNull(sAmtGbn) THEN RETURN
	
	IF Integer(sAmtGbn) <> 0 AND Integer(sAmtGbn) <> 1 AND Integer(sAmtGbn) <> 2 AND &
		Integer(sAmtGbn) <> 3 AND Integer(sAmtGbn) <> 4 AND Integer(sAmtGbn) <> 9 THEN
		f_messagechk(20,'[금액구분]')
		this.SetItem(this.GetRow(),"amt_gu",snull)
		Return 1
	END IF
END IF

end event

event itemfocuschanged;Long wnd

wnd =Handle(this)

IF dwo.name ="kname" THEN
	f_toggle_kor(wnd)
ELSE
	f_toggle_eng(wnd)
END IF
end event

event rbuttondown;SetNull(lstr_account.acc1_cd)
SetNull(lstr_account.acc2_cd)

dw_ip.AcceptText()

IF this.GetColumnName() ="acc1_cd" OR this.GetColumnName() ="acc2_cd" THEN

	lstr_account.acc1_cd = Left(this.GetItemString(this.GetRow(),"acc1_cd"),1)

	IF IsNull(lstr_account.acc1_cd) then
   	lstr_account.acc1_cd = ""
	end if
	
	Open(W_KFZ01OM0_POPUP1)

	IF gs_code ="" AND IsNull(gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(),"acc1_cd",lstr_account.acc1_cd)
	this.SetItem(this.GetRow(),"acc2_cd",lstr_account.acc2_cd)

	this.SetItem(this.GetRow(),"accname",lstr_account.acc2_nm)
END IF
end event

event itemerror;Return 1
end event

event buttonclicked;String sAmtGbn,sName,sSeqNo,sRtnMsg

if dwo.name = 'bcb_detail' then
	
	this.ScrollToRow(Row)
	this.SetFocus()
	
	sAmtGbn = this.Getitemstring(row,"amt_gu")
	sName   = this.Getitemstring(row,"kname")
	
	if sAmtGbn = "9" then	  
		sSeqno = String(this.Getitemnumber(row,"fs_seq"),'00000')
	  
		OpenWithParm(w_kcda05a,Is_FsGbn+sSeqno+sName)
  
		sRtnMsg = Message.StringParm
	  
		IF sRtnMsg = 'ok' THEN
			ib_any_typing = True
		END IF
	end if
end if
end event

type cb_mod from commandbutton within w_kcda05
integer x = 2286
integer y = 2572
integer width = 293
integer height = 108
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "저장(&S)"
end type

event clicked;Integer k,iRtnValue
Long    lSeqNo
String  sFsGu

IF dw_ret.AcceptText() = -1 THEN Return

IF dw_ret.RowCount() > 0 THEN
	FOR k = 1 TO dw_ret.RowCount()
		iRtnValue = Wf_RequiredChk(k)
		IF iRtnValue = -1 THEN RETURN
	NEXT
ELSE
	Return
END IF

IF f_dbConFirm('저장') = 2 THEN RETURN

IF dw_ret.Update() = 1 THEN
	
	FOR k = 1 TO dw_ret.RowCount()
		dw_ret.SetItem(k,'sflag','M')
		
		if dw_ret.GetItemString(k,"amt_gu") <> '9' then
			sFsGu  = dw_ret.GetItemString(k,"fs_gu")
			lSeqNo = dw_ret.GetItemNumber(k,"fs_seq")
			
			delete from kfz02ot0 where fs_gu = :sFsGu and fs_seq = :lSeqNo;
		end if
	NEXT
	commit;

	dw_ret.SetColumn("kname")
	dw_ret.SetFocus()
	
	ib_any_typing = False
	sle_msg.text ="자료가 저장되었습니다.!!!"
ELSE
	ROLLBACK;
	f_messagechk(13,'')
END IF

IF dw_ret.RowCount() <=0 THEN
	cb_ins.Enabled = False
ELSE
	cb_ins.Enabled = True
END IF

end event

type cb_ins from commandbutton within w_kcda05
integer x = 379
integer y = 2572
integer width = 293
integer height = 108
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "추가(&A)"
end type

event clicked;Integer  iCurRow,iFunctionValue,iRowCount

sle_msg.text =""

iRowCount = dw_ret.RowCount()

IF iRowCount > 0 THEN
	iFunctionValue = Wf_RequiredChk(dw_ret.GetRow())
	IF iFunctionValue <> 1 THEN RETURN
ELSE
	iFunctionValue = 1	
	
	iRowCount = 0
END IF

IF iFunctionValue = 1 THEN
	iCurRow = iRowCount + 1
	
	dw_ret.InsertRow(iCurRow)

	dw_ret.ScrollToRow(iCurRow)
	
	dw_ret.SetItem(iCurRow,'sflag',    'I')
	dw_ret.SetItem(iCurRow,"fs_gu",    Is_FsGbn)
	dw_ret.SetColumn("fs_seq")
	
	dw_ret.SetFocus()
	
	ib_any_typing =False

END IF

IF dw_ret.RowCount() <=0 THEN
	cb_ins.Enabled = False
ELSE
	cb_ins.Enabled = True
END IF


end event

type cb_del from commandbutton within w_kcda05
integer x = 2606
integer y = 2572
integer width = 293
integer height = 108
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "삭제(&D)"
end type

event clicked;Integer k
Long    lSeqNo

IF dw_ret.GetRow() <= 0 THEN
	f_messagechk(11,'')
	Return
ELSE
	lSeqNo = dw_ret.GetItemNumber(dw_ret.GetRow(),"fs_seq")
END IF

IF F_DbConFirm('삭제') = 2 THEN RETURN

dw_ret.DeleteRow(dw_ret.GetRow())
IF dw_ret.Update() = 1 THEN
	
	delete from kfz02ot0 where fs_gu = :Is_FsGbn and fs_seq = :lSeqNo;
	commit;
	
	FOR k = 1 TO dw_ret.RowCount()
		dw_ret.SetItem(k,'sflag','M')
	NEXT
	
	dw_ret.SetColumn("kname")
	dw_ret.SetFocus()
	
	ib_any_typing = False
	sle_msg.text ="자료가 삭제되었습니다.!!!"
ELSE
	ROLLBACK;
	f_messagechk(12,'')
END IF

end event

type cb_inq from commandbutton within w_kcda05
integer x = 59
integer y = 2572
integer width = 293
integer height = 108
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "조회(&R)"
end type

event clicked;String sNull

dw_ip.AcceptText()
Is_FsGbn = dw_ip.Getitemstring(dw_ip.getrow(),"fs_gu")
IF Is_FsGbn = '' OR IsNull(Is_FsGbn) THEN
	F_MessageChk(1,'[결산서구분]')
	dw_ip.SetColumn("fs_gu")
	dw_ip.SetFocus()
	Return
END IF

sle_msg.text =""

IF dw_ret.Retrieve(Is_FsGbn) <=0 THEN
	F_MessageChk(14,'')
	dw_ip.SetColumn("fs_gu")
	dw_ip.SetFocus()
	Return
ELSE
	dw_ret.Setcolumn("kname")
	dw_ret.SetFocus()
END IF

ib_any_typing  = False
cb_ins.Enabled = True


end event

type st_1 from statictext within w_kcda05
integer x = 32
integer y = 2760
integer width = 288
integer height = 84
integer textsize = -10
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

type cb_can from commandbutton within w_kcda05
integer x = 2926
integer y = 2576
integer width = 293
integer height = 108
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "취소(&C)"
boolean cancel = true
end type

event clicked;dw_ip.SetFocus()

dw_ret.Reset()

cb_ins.Enabled = False

ib_any_typing = False
end event

type dw_datetime from datawindow within w_kcda05
integer x = 2848
integer y = 2760
integer width = 745
integer height = 92
string dataobject = "d_datetime"
boolean border = false
boolean livescroll = true
end type

type sle_msg from singlelineedit within w_kcda05
integer x = 325
integer y = 2760
integer width = 2523
integer height = 84
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12632256
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type dw_ip from datawindow within w_kcda05
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 14
integer y = 12
integer width = 1431
integer height = 140
integer taborder = 10
string dataobject = "dw_kcda051"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;
IF this.GetColumnName() = 'fs_gu' THEN
	Is_FsGbn = this.GetText()
	IF Is_FsGbn = '' OR IsNull(Is_FsGbn) THEN Return
	
	dw_ret.Reset()
	p_ins.Enabled = False
	p_ins.picturename = "C:\erpman\image\추가_d.gif"
END IF
end event

type gb_1 from groupbox within w_kcda05
integer x = 14
integer y = 2720
integer width = 3598
integer height = 140
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12632256
end type

type gb_2 from groupbox within w_kcda05
integer x = 2661
integer y = 8
integer width = 782
integer height = 128
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
borderstyle borderstyle = stylelowered!
end type

type rr_1 from roundrectangle within w_kcda05
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 156
integer width = 4535
integer height = 2120
integer cornerheight = 40
integer cornerwidth = 46
end type

