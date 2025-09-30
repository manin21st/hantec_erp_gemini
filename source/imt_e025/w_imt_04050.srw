$PBExportHeader$w_imt_04050.srw
$PBExportComments$인수증등록
forward
global type w_imt_04050 from window
end type
type pb_2 from u_pb_cal within w_imt_04050
end type
type pb_3 from u_pb_cal within w_imt_04050
end type
type pb_1 from u_pb_cal within w_imt_04050
end type
type p_exit from uo_picture within w_imt_04050
end type
type p_cancel from uo_picture within w_imt_04050
end type
type p_delete from uo_picture within w_imt_04050
end type
type p_save from uo_picture within w_imt_04050
end type
type p_retrieve from uo_picture within w_imt_04050
end type
type cbx_1 from checkbox within w_imt_04050
end type
type rb_2 from radiobutton within w_imt_04050
end type
type rb_1 from radiobutton within w_imt_04050
end type
type dw_detail from datawindow within w_imt_04050
end type
type dw_list from datawindow within w_imt_04050
end type
type rr_1 from roundrectangle within w_imt_04050
end type
type rr_2 from roundrectangle within w_imt_04050
end type
type rr_3 from roundrectangle within w_imt_04050
end type
end forward

global type w_imt_04050 from window
integer width = 4658
integer height = 2440
boolean titlebar = true
string title = "인수증 등록"
string menuname = "m_shortcut"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 32106727
pb_2 pb_2
pb_3 pb_3
pb_1 pb_1
p_exit p_exit
p_cancel p_cancel
p_delete p_delete
p_save p_save
p_retrieve p_retrieve
cbx_1 cbx_1
rb_2 rb_2
rb_1 rb_1
dw_detail dw_detail
dw_list dw_list
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
end type
global w_imt_04050 w_imt_04050

type variables
boolean ib_ItemError, ib_any_typing = False
char ic_status
string is_Date
int  ii_Last_Jpno

String     is_today              //시작일자
String     is_totime             //시작시간
String     is_window_id      //윈도우 ID
String     is_usegub           //이력관리 여부

string is_pspec, is_jijil
end variables

forward prototypes
public function integer wf_confirm_key ()
public function integer wf_create_bl ()
public function integer wf_delete ()
public subroutine wf_query ()
public subroutine wf_new ()
public function integer wf_checkrequiredfield ()
end prototypes

public function integer wf_confirm_key ();/*=====================================================================
		1.	등록 mode : Key 검색
		2. Argument : None
		3.	Return Value
			- ( -1 ) : 등록된 코드 
			- (  1 ) : 신  규 코드
=====================================================================*/
string	sLcno, sConfirm

sLcno = dw_detail.GetItemString(1, "poblno")

SELECT "POBLNO"
  INTO :sConfirm
  FROM "POLCBLHD"  
 WHERE ( "SABU" = :gs_sabu )		AND
 		 ( "POBLNO" = :sLcno )  ;
			
IF sqlca.sqlcode = 0 	then	
	f_message_chk(1, "인수증번호")
	dw_detail.setcolumn("poblno")
	dw_detail.SetFocus()
	RETURN  -1 
END IF
RETURN  1

end function

public function integer wf_create_bl ();string	sBlno,    sVendor, 	&
			sRcvdat,  sDesdat,	&
			sEntfoct, sEntdat,	&
			sOrigin,  sPort, sInsno, slcno, sbaljpno, ssaupj
dec{3}	dQty
dec{2}   dAmt
dec{5}   dBlrate
long		lRow, lcount, dbalseq, icount, k

damt = 0

if dw_detail.accepttext() = -1 then return -1
if dw_list.accepttext() = -1 then return -1

slcno = dw_detail.GetItemString(1, "polcno")
sBlno = dw_detail.GetItemString(1, "poblno")
sRcvdat = trim(dw_detail.GetItemString(1, "rcvdat"))
sEntfoct = trim(dw_detail.GetItemString(1, "Entfoct"))
sEntdat = trim(dw_detail.GetItemString(1, "Entfoct"))
sDesdat = trim(dw_detail.GetItemString(1, "Desdat"))
sentdat = trim(dw_detail.GetItemString(1, "entdat"))
sOrigin = dw_detail.GetItemString(1, "origin")
sPort = dw_detail.GetItemString(1, "port_dispatch")

For Lrow = 1 to dw_list.rowcount()
	 
	 if dw_list.getitemstring(Lrow, "sel") = 'N' then continue
	 
	 dw_list.setitem(lrow, "imhist_poblno", sblno)	 
	 dw_list.setitem(lrow, "imhist_poblsq", lrow)	 
	 
	 sbaljpno = dw_list.getitemstring(Lrow, "imhist_baljpno")
	 dbalseq  = dw_list.getitemdecimal(Lrow, "imhist_balseq")	 
	 dqty     = dw_list.getitemdecimal(Lrow, "imhist_iosuqty") 
	 damt     = damt + 			 dw_list.getitemdecimal(Lrow, "imhist_iosuqty") * &
							 		 	 dw_list.getitemdecimal(Lrow, "polcdt_lcprc") 

	 dBlrate  = dw_list.getitemdecimal(Lrow, "imhist_dyebi1") //적용환율
	 ssaupj   = dw_list.getitemstring(Lrow, "imhist_saupj")   //사업장
							 
	SELECT MAX(POBLSQ)
	  INTO :iCount
	  FROM POLCBL
	 WHERE SABU = :gs_sabu  	and
			 POBLNO <> :sBlno		and
			 POLCNO = :slcno ;

	IF isnull(iCount) OR iCount = 0 then
		icount = 1
	ELSE
   	iCount++
	END IF	

 
	 Insert into polcbl
	 		(sabu,			poblno,			pobseq,			rcvdat,			desdat,
			 tra_cvcod,		entfoct,			entdat,			origin,			port_dispatch,
			 polcno,			poblsq,			baljpno,			balseq,			blqty,	magyeo,
			 magdat,			biamt,			imt_license,	imt_liceno,		bigub,
			 invoice_no,   saupj,         blrate)
		values
			(:gs_sabu,		:sblno,			:lrow,			:srcvdat,		:sdesdat,
			 null,			:sentfoct,		:sentdat,		:sorigin,		:sport,
			 :slcno,			:icount,			:sbaljpno,		:dbalseq,		:dqty,	'Y',
			 To_char(sysdate,'YYYYMMDD'),			0,					null,			   0,					'2',
			 null,         :ssaupj,       :dblrate);
			 
	 if sqlca.sqlcode <> 0  then
		 Messagebox("인수증 생성", "인수증내역 생성시 오류발생", stopsign!)
		 return -1
	 end if
	
	 k ++ 
Next

if k < 1 then 
	 Messagebox("확 인", "자료를 선택하세요. 입고내역이 선택되지 않았습니다.", stopsign!)
	 return -1
end if

dw_detail.setitem(1, "blamt", damt)

return 1

end function

public function integer wf_delete ();
long	lRow, lRowCount
string snull

setnull(snull)

lRowCount = dw_list.RowCount()

FOR  lRow = lRowCount 	TO	 1		STEP -1
	
	dw_list.setitem(lrow, "imhist_poblno", snull)
	dw_list.setitem(lrow, "imhist_poblsq", 0)	
	
NEXT


RETURN 1
end function

public subroutine wf_query ();w_mdi_frame.sle_msg.Text =  "조회"
ic_Status = '2'

dw_list.SetFocus()
	

// button
p_save.enabled = true
p_delete.enabled = true
//cb_insert.enabled = false

end subroutine

public subroutine wf_new ();
ic_status = '1'
w_mdi_frame.sle_msg.Text = "등록"

///////////////////////////////////////////////
dw_detail.setredraw(false)

dw_detail.reset()
dw_detail.insertrow(0)
dw_detail.setitem(1, "sabu", gs_sabu)

dw_detail.setredraw(true)
///////////////////////////////////////////////

dw_list.dataobject = "d_imt_04050_1"
dw_list.settransobject(sqlca)

IF f_change_name('1') = 'Y' then 
	dw_list.object.ispec_t.text = is_pspec
	dw_list.object.jijil_t.text = is_jijil
END IF


dw_detail.enabled = true
dw_list.enabled = true

dw_detail.SetFocus()

p_save.enabled = true
p_delete.enabled = false
p_retrieve.enabled = true

p_save.PictureName = "C:\erpman\image\저장_up.gif"
p_delete.PictureName = "C:\erpman\image\삭제_d.gif"
p_retrieve.PictureName = "C:\erpman\image\조회_up.gif"

rb_1.checked = false
rb_2.checked = true

ib_ItemError  = true
ib_any_typing = false


end subroutine

public function integer wf_checkrequiredfield ();
string	sBlno,    sVendor, 	&
			sRcvdat,  sDesdat,	&
			sEntfoct, sEntdat,	&
			sOrigin,  sPort, sInsno, slcno
dec		dQty
long		lRow, lcount, dseq


// 인수증 번호
sBlno = dw_detail.GetItemString(1, "poblno")
IF ic_status = '1' and cbx_1.checked = true THEN  //자동채번여부
	IF IsNull(sBlno) 	or   sBlno = ''	THEN
		dSeq = SQLCA.FUN_JUNPYO(gs_Sabu, is_today, 'L0')
		if dSeq = -1 then 
			rollback;
			f_message_chk(51, '')
			return -1
		end if
		Commit;
		sInsno = is_today + String(dseq, '0000')
		dw_detail.setitem(1, 'poblno', sinsno)
		
		sBlno = sInsNo
	END IF
ELSE
	IF IsNull(sBlno) 	or   sBlno = ''	THEN
		f_message_chk(30,'[인수증 번호]')		
		dw_detail.SetColumn("poblno")
		dw_detail.SetFocus()
		RETURN -1
	END IF
END IF

// 인수일자
sentdat = trim(dw_detail.GetItemString(1, "entdat"))
IF IsNull(sentdat) 	or   sentdat = ''	THEN
	f_message_chk(30,'[인수일자]')		
	dw_detail.SetColumn("entdat")
	dw_detail.SetFocus()
	RETURN -1
END IF

// 결제예정일
sDesdat = trim(dw_detail.GetItemString(1, "Desdat"))
IF IsNull(sDesdat) 	or   sDesdat = ''	THEN
	f_message_chk(30,'[결제예정일]')		
	dw_detail.SetColumn("Desdat")
	dw_detail.SetFocus()
	RETURN -1
END IF


// S/D
sRcvdat = trim(dw_detail.GetItemString(1, "rcvdat"))
IF IsNull(sRcvdat) 	or   sRcvdat = ''	THEN
	f_message_chk(30,'[S/D]')		
	dw_detail.SetColumn("Rcvdat")
	dw_detail.SetFocus()
	RETURN -1
END IF
	
// E/D
sEntfoct = trim(dw_detail.GetItemString(1, "Entfoct"))
IF IsNull(sEntfoct) 	or   sEntfoct = ''	THEN
	f_message_chk(30,'[E/D]')
	dw_detail.SetColumn("Entfoct")
	dw_detail.SetFocus()
	RETURN -1
END IF


// L/C-NO
slcno = trim(dw_detail.GetItemString(1, "polcno"))
IF IsNull(slcno) 	or   slcno = ''	THEN
	f_message_chk(30,'[L/C-NO]')		
	dw_detail.SetColumn("polcno")
	dw_detail.SetFocus()
	RETURN -1
END IF

// 원산지명
sOrigin = dw_detail.GetItemString(1, "origin")

// 발송항
sPort = dw_detail.GetItemString(1, "port_dispatch")


rETURN 1
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


///////////////////////////////////////////////////////////////////////////////////

dw_detail.settransobject(sqlca)
dw_list.settransobject(sqlca)

is_Date = f_Today()

p_cancel.TriggerEvent("clicked")
end event

on w_imt_04050.create
if this.MenuName = "m_shortcut" then this.MenuID = create m_shortcut
this.pb_2=create pb_2
this.pb_3=create pb_3
this.pb_1=create pb_1
this.p_exit=create p_exit
this.p_cancel=create p_cancel
this.p_delete=create p_delete
this.p_save=create p_save
this.p_retrieve=create p_retrieve
this.cbx_1=create cbx_1
this.rb_2=create rb_2
this.rb_1=create rb_1
this.dw_detail=create dw_detail
this.dw_list=create dw_list
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
this.Control[]={this.pb_2,&
this.pb_3,&
this.pb_1,&
this.p_exit,&
this.p_cancel,&
this.p_delete,&
this.p_save,&
this.p_retrieve,&
this.cbx_1,&
this.rb_2,&
this.rb_1,&
this.dw_detail,&
this.dw_list,&
this.rr_1,&
this.rr_2,&
this.rr_3}
end on

on w_imt_04050.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_2)
destroy(this.pb_3)
destroy(this.pb_1)
destroy(this.p_exit)
destroy(this.p_cancel)
destroy(this.p_delete)
destroy(this.p_save)
destroy(this.p_retrieve)
destroy(this.cbx_1)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.dw_detail)
destroy(this.dw_list)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
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

event key;Choose Case key
	Case KeyQ!
		p_retrieve.TriggerEvent(Clicked!)
	Case KeyS!
		p_save.TriggerEvent(Clicked!)
	Case KeyD!
		p_delete.TriggerEvent(Clicked!)
	Case KeyC!
		p_cancel.TriggerEvent(Clicked!)
	Case KeyX!
		p_exit.TriggerEvent(Clicked!)
End Choose
end event

type pb_2 from u_pb_cal within w_imt_04050
integer x = 2043
integer y = 40
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_detail.SetColumn('entdat')
IF IsNull(gs_code) THEN Return
ll_row = dw_detail.GetRow()
If ll_row < 1 Then Return
dw_detail.SetItem(ll_row, 'entdat', gs_code)



end event

type pb_3 from u_pb_cal within w_imt_04050
integer x = 2917
integer y = 40
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_detail.SetColumn('desdat')
IF IsNull(gs_code) THEN Return
ll_row = dw_detail.GetRow()
If ll_row < 1 Then Return
dw_detail.SetItem(ll_row, 'desdat', gs_code)



end event

type pb_1 from u_pb_cal within w_imt_04050
integer x = 2043
integer y = 124
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_detail.SetColumn('entfoct')
IF IsNull(gs_code) THEN Return
ll_row = dw_detail.GetRow()
If ll_row < 1 Then Return
dw_detail.SetItem(ll_row, 'entfoct', gs_code)



end event

type p_exit from uo_picture within w_imt_04050
integer x = 4416
integer y = 28
integer width = 178
string pointer = "C:\erpman\cur\close.cur"
boolean originalsize = true
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.Text = ''

IF ib_any_typing = true THEN  				// EditChanged event(dw_detail)의 typing 상태확인

	Beep(1)
	IF MessageBox("확인 : 종료" , &
		 "저장하지 않은 값이 있습니다. ~r변경사항을 저장하시겠습니까", &
		 question!, yesno!) = 1 THEN

		RETURN 									

	END IF

END IF

close(parent)

end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\닫기_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\닫기_dn.gif'
end event

type p_cancel from uo_picture within w_imt_04050
integer x = 4242
integer y = 28
integer width = 178
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event clicked;w_mdi_frame.sle_msg.Text = ''

IF ib_any_typing = true THEN  				// EditChanged event(dw_detail)의 typing 상태확인

	Beep(1)
	IF MessageBox("확인 : 취소" , &
		 "저장하지 않은 값이 있습니다. ~r변경사항을 저장하시겠습니까", &
		 question!, yesno!) = 1 THEN

		RETURN 									

	END IF

END IF

wf_New()

dw_list.Reset()
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\취소_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\취소_dn.gif'
end event

type p_delete from uo_picture within w_imt_04050
integer x = 4069
integer y = 28
integer width = 178
string pointer = "C:\erpman\cur\delete.cur"
string picturename = "C:\erpman\image\삭제_up.gif"
end type

event clicked;//////////////////////////////////////////////////////////////////
///	* 통관일자 입력시 -> 삭제불가
//////////////////////////////////////////////////////////////////
string	sEntdat, sBlno
INT      icount


sBlno = trim(dw_detail.GetItemString(1, "poblno"))
SELECT COUNT(*)  INTO :icount
  FROM IMPEXP 
 WHERE SABU = :gs_sabu AND POBLNO = :sBlno   ;
 
IF icount > 0 then 
	MessageBox("확인", "수입비용이 등록된 인수증번호는 삭제할 수 없습니다.")
	RETURN 
END IF

//////////////////////////////////////////////////////////////////

IF f_msg_delete() = -1 THEN	RETURN

dw_detail.setredraw(False)
	
IF wf_Delete() = -1		THEN	
	dw_detail.setredraw(true)
	RETURN
END IF
/////////////////////////////////////////////////////////////////

IF dw_list.Update() > 0		THEN
	
	// HEAD삭제
	DELETE POLCBLHD
	 WHERE SABU = :gs_sabu AND POBLNO = :sBlno   ;
	IF SQLCA.SQLCODE <> 0 THEN
		rollback;
		MESSAGEBOX("인수증-HEAD", "인수증-HEAD삭제시 오류가 발생", stopsign!)
		return
	END IF
	
	// DETAIL삭제
	DELETE POLCBL 
	 WHERE SABU = :gs_sabu AND POBLNO = :sBlno   ;
	IF SQLCA.SQLCODE <> 0 THEN
		rollback;
		MESSAGEBOX("인수증-DETAIL", "인수증-DETAIL삭제시 오류가 발생", stopsign!)
		return
	END IF	
	
	COMMIT;
ELSE
	f_Rollback()
	ROLLBACK;
END IF

wf_New()

dw_list.Reset()	
	
dw_detail.setredraw(true)


end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\삭제_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\삭제_dn.gif'
end event

type p_save from uo_picture within w_imt_04050
integer x = 3895
integer y = 28
integer width = 178
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event clicked;SetPointer(HourGlass!)

if dw_list.rowcount() < 1 then return
IF dw_detail.AcceptText() = -1	THEN	RETURN
IF dw_list.AcceptText() = -1		THEN	RETURN

string	sDate

IF	wf_CheckRequiredField() = -1	THEN	RETURN

// 신규등록시 B/L번호 확인
IF ic_status = '1'	THEN

	IF wf_Confirm_Key() = -1	THEN	RETURN

END IF


/////////////////////////////////////////////////////////////////////////
IF f_msg_update() = -1 		THEN	RETURN

// 신규등록시 B/L번호 확인
IF ic_status = '1'	THEN
	if wf_create_bl() = -1 then
		ROLLBACK;		
		return
	end if
end if

IF dw_list.Update() = 1	and dw_detail.update() = 1	THEN
	COMMIT;
ELSE
	ROLLBACK;
	f_Rollback()
END IF

ib_any_typing = False

p_cancel.TriggerEvent("clicked")	

SetPointer(Arrow!)


end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\저장_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\저장_dn.gif'
end event

type p_retrieve from uo_picture within w_imt_04050
integer x = 3721
integer y = 28
integer width = 178
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event clicked;
if dw_detail.Accepttext() = -1	then 	return

string  	sBlno,		&
			sDate,		&
			sNull, slcno
int      get_count, i			
			
SetNull(sNull)

sBlno	= dw_detail.getitemstring(1, "poblno")

IF isnull(sBlno) or sBlno = "" 	THEN
	f_message_chk(30,'[인수증번호]')
	dw_detail.SetColumn("poblno")
	dw_detail.SetFocus()
	RETURN
END IF

//////////////////////////////////////////////////////////////////////////
dw_detail.SetRedraw(False)

IF dw_detail.Retrieve(gs_Sabu, sBlno) < 1	THEN
	f_message_chk(50, '[인수증번호]')
	dw_detail.setcolumn("poblno")
	dw_detail.setfocus()

	ib_any_typing = False
	p_cancel.TriggerEvent("clicked")
	RETURN
END IF

dw_detail.SetRedraw(True)

dw_list.dataobject = "d_imt_04050_2"
dw_list.settransobject(sqlca)

//IF f_change_name('1') = 'Y' then 
//	dw_list.object.ispec_t.text = is_pspec
//	dw_list.object.jijil_t.text = is_jijil
//END IF

IF dw_list.Retrieve(gs_Sabu, sBlno) < 1 THEN 
	f_message_chk(50, '[인수증번호]')
	dw_detail.setcolumn("poblno")
	dw_detail.setfocus()
	RETURN
END IF

SELECT COUNT(*) INTO :get_count
  FROM (SELECT DISTINCT INVOICE_NO FROM POLCBL 
         WHERE SABU = :gs_sabu AND POBLNO = :sblno AND INVOICE_NO IS NOT NULL) ;

dw_detail.setitem(1, 'incount', get_count)
/////////////////////////////////////////////////////////////////////////
// * 조회된 '구매L/C품목정보'의 발주번호는 수정할 수 없음
////////////////////////////////////////////////////////////////////////////

wf_Query()

//////////////////////////////////////////////////////////////////////////
//	* 통관일자가 입력된 자료는 수정할 수 없음
//////////////////////////////////////////////////////////////////////////
string	sGubun, sMagam, staxno, ls_bigub
long lmacnt

lmacnt = 0
select count(*), bigub into :lmacnt,:ls_bigub from polcbl
 where sabu = :gs_sabu and poblno = :sblno and magyeo = 'Y'
 Group by bigub;

staxno = dw_detail.GetItemString(1, "taxno")
IF lmacnt > 0 and ls_bigub = '1' THEN 
	if lmacnt > 0 then
		w_mdi_frame.sle_msg.text = '마감된 자료는 수정할 수 없습니다.'	
	elseif not isnull(ls_bigub) then
		w_mdi_frame.sle_msg.text = 'B/L 자료는 수정할 수 없읍니다.'		
		rb_2.checked = false
	end if
	
	dw_detail.enabled = false
	dw_list.enabled = false	
	p_save.enabled = false	
	p_delete.enabled = false	
	
	p_save.PictureName = "C:\erpman\image\저장_d.gif"
	p_delete.PictureName = "C:\erpman\image\삭제_d.gif"
	
	ib_any_typing = False
	RETURN 
ElseIf lmacnt > 0 and ls_bigub = '2' Then
	For i = 1 to dw_list.RowCount() 
//		dw_list.SetItem(i, 'sel', '1')
		dw_list.Object.sel.visible = True
	Next
END IF	

p_save.enabled = false
p_retrieve.enabled = false
p_delete.enabled = true

p_save.PictureName = "C:\erpman\image\저장_d.gif"
p_retrieve.PictureName = "C:\erpman\image\조회_d.gif"
p_delete.PictureName = "C:\erpman\image\삭제_up.gif"
ib_any_typing = False

end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\조회_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\조회_dn.gif'
end event

type cbx_1 from checkbox within w_imt_04050
integer x = 3785
integer y = 216
integer width = 430
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "자동 채번"
end type

type rb_2 from radiobutton within w_imt_04050
boolean visible = false
integer x = 4699
integer y = 280
integer width = 485
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
boolean enabled = false
string text = "인수증(LOCAL)"
boolean checked = true
end type

type rb_1 from radiobutton within w_imt_04050
boolean visible = false
integer x = 4699
integer y = 212
integer width = 448
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
boolean enabled = false
string text = "B/L"
end type

type dw_detail from datawindow within w_imt_04050
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 9
integer y = 24
integer width = 3086
integer height = 292
integer taborder = 10
string dataobject = "d_imt_04050"
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

event itemchanged;string	sDate, 			&
			sCode, sName,	&
			sNull, sBigub, slcno, scvcod, scvnas, smagub
int      icount			
SetNull(sNull)


// B/L NO
IF this.GetcolumnName() = 'poblno'	THEN
	
	sCode = this.GetText()								
	
	if scode = '' or isnull(scode) then return 

  SELECT COUNT("POLCBL"."POBLNO"), MAX("POLCBL"."BIGUB")
    INTO :icount, :sBigub  
    FROM "POLCBL"  
   WHERE ( "POLCBL"."SABU" = :gs_sabu ) AND  
         ( "POLCBL"."POBLNO" = :scode ) AND
			( "POLCBL"."BIGUB" = '2' )  ;

	IF icount > 0 THEN
		p_retrieve.TriggerEvent(Clicked!)
	   return 1
   END IF	
END IF
// 운송회사
IF this.GetcolumnName() = 'tra_cvcod'	THEN
	
	sCode = this.GetText()								
	
  	if scode = '' or isnull(scode) then
		this.setitem(1, 'vndmst_cvnas', snull)
		return 
   end if
	
   SELECT CVNAS
     INTO :sName
     FROM VNDMST
    WHERE CVCOD = :sCode  AND
	 		 CVSTATUS = '0' ;

	IF sqlca.sqlcode = 100 	THEN
		f_message_chk(33,'[운송회사]')
		this.setitem(1, 'tra_cvcod', sNull)
		this.setitem(1, 'vndmst_cvnas', snull)
	   return 1
   ELSE
		this.setitem(1, 'vndmst_cvnas', sName)
   END IF
	
END IF


// 접수일자
IF this.GetColumnName() = 'rcvdat' THEN

	sDate  = TRIM(this.gettext())
	if sdate = '' or isnull(sdate) then return 
	IF f_datechk(sDate) = -1	then
      f_message_chk(35, '[접수일자]')
		This.setitem(1, "rcvdat", sNull)
		return 1
	END IF
	
END IF

// 도착일자
IF this.GetColumnName() = 'desdat' THEN

	sDate  = TRIM(this.gettext())
	if sdate = '' or isnull(sdate) then return 
	IF f_datechk(sDate) = -1	then
      f_message_chk(35, '[도착일자]')
		this.setitem(1, "desdat", sNull)
		return 1
	END IF
	
END IF

// 통관예정일
IF this.GetColumnName() = 'entfoct' THEN

	sDate  = TRIM(this.gettext())
	if sdate = '' or isnull(sdate) then return 
	IF f_datechk(sDate) = -1	then
      f_message_chk(35, '[통관예정일]')
		this.setitem(1, "entfoct", sNull)
		return 1
	END IF
	
END IF

// 인수일자
IF this.GetColumnName() = 'entdat' THEN

	sDate  = TRIM(this.gettext())
	if sdate = '' or isnull(sdate) then return 
	IF f_datechk(sDate) = -1	then
      f_message_chk(35, '[인수일자]')
		this.setitem(1, "entdat", sNull)
		return 1
	END IF
	
END IF

// L/C-NO
IF this.GetColumnName() = 'polcno' THEN

	slcno  = TRIM(this.gettext())
	
	Select a.pomaga, a.localyn, a.buyer, b.cvnas
	  into :smagub, :scode, :scvcod, :scvnas 
	  from polchd a, vndmst b
	 where a.sabu = :gs_sabu and a.polcno = :slcno
	 	and a.buyer = b.cvcod (+);
	 
	if sqlca.sqlcode <> 0 then
      f_message_chk(33, '[L/C-NO]')
		this.setitem(1, "polcno", sNull)
		dw_detail.setitem(1, "buyer", snull)
		dw_detail.setitem(1, "buyname", snull)					
		return 1
	END IF
	
	if sMagub = 'Y' then 
		Messagebox("확 인", "L/C 완료처리된 자료는 선택할 수 없읍니다", stopsign!)
		this.setitem(1, "polcno", sNull)
		dw_detail.setitem(1, "buyer", snull)
		dw_detail.setitem(1, "buyname", snull)					
		return 1
	end if

	if scode = 'Y' then
	else
      Messagebox("L/C-NO", "인수증은 	LOCAL L/C만 등록가능 합니다", stopsign!)
		this.setitem(1, "polcno", sNull)
		dw_detail.setitem(1, "buyer", snull)
		dw_detail.setitem(1, "buyname", snull)					
		return 1
	END IF	
	
	IF dw_list.retrieve(gs_sabu, slcno) < 0	then
      f_message_chk(50, '[L/C-NO]')
		this.setitem(1, "polcno", sNull)
		dw_detail.setitem(1, "buyer", snull)
		dw_detail.setitem(1, "buyname", snull)			
		return 1
	END IF
	
	dw_detail.setitem(1, "buyer", scvcod)
	dw_detail.setitem(1, "buyname", scvnas)	
	
END IF


end event

event itemerror;RETURN 1
end event

event losefocus;this.accepttext()
end event

event rbuttondown;gs_gubun = ''
gs_code  = ''
gs_codename = ''


// 운송회사
IF this.GetColumnName() = 'tra_cvcod'	THEN

	Open(w_vndmst_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1,"tra_cvcod",		gs_code)
	SetItem(1,"vndmst_cvnas",  gs_codename)
	
END IF

// BL번호
IF this.GetColumnName() = 'poblno'	THEN
   
	Open(w_bl_popup2)
		
	if isNull(gs_code) or trim(gs_code) = ''	then	return
	SetItem(1, "poblno", gs_code)
	this.TriggerEvent(Itemchanged!)
	
END IF

// LC번호
IF this.GetColumnName() = 'polcno'	THEN
	
	gs_gubun = 'LOCAL'
   
	Open(w_lc_popup)
		
	if isNull(gs_code) or trim(gs_code) = ''	then	return
	SetItem(1, "polcno", gs_code)
	this.TriggerEvent(Itemchanged!)
	
END IF
end event

event editchanged;ib_any_typing =True
end event

type dw_list from datawindow within w_imt_04050
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 32
integer y = 336
integer width = 4553
integer height = 1964
integer taborder = 20
string dataobject = "d_imt_04050_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;setnull(gs_code)
choose case key
	case KeyF1! 
   	TriggerEvent(RbuttonDown!)
	case KeyF2! 
		IF This.GetColumnName() = "itnbr" Then
			open(w_itemas_popup2)
			if isnull(gs_code) or gs_code = "" then return
			
			this.SetItem(this.getrow(),"itnbr",gs_code)
			this.TriggerEvent(ItemChanged!)
		End If
end choose
	
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


w_mdi_frame.sle_msg.Text = "  필수입력항목 :  " + this.Describe(sColumnName) + "   입력하세요."

RETURN 1
	
	
end event

event losefocus;this.AcceptText()
end event

event editchanged;ib_any_typing =True


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

type rr_1 from roundrectangle within w_imt_04050
boolean visible = false
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 4681
integer y = 200
integer width = 521
integer height = 164
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_imt_04050
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 3735
integer y = 208
integer width = 521
integer height = 96
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_imt_04050
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 324
integer width = 4567
integer height = 1988
integer cornerheight = 40
integer cornerwidth = 55
end type

