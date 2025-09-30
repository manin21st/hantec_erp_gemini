$PBExportHeader$w_pdt_t_05020.srw
$PBExportComments$외주 재고 실사 등록
forward
global type w_pdt_t_05020 from window
end type
type p_cancel from uo_picture within w_pdt_t_05020
end type
type p_exit from uo_picture within w_pdt_t_05020
end type
type p_mod from uo_picture within w_pdt_t_05020
end type
type p_del from uo_picture within w_pdt_t_05020
end type
type p_retrieve from uo_picture within w_pdt_t_05020
end type
type rb_delete from radiobutton within w_pdt_t_05020
end type
type rb_insert from radiobutton within w_pdt_t_05020
end type
type dw_imhist from datawindow within w_pdt_t_05020
end type
type dw_detail from datawindow within w_pdt_t_05020
end type
type gb_2 from groupbox within w_pdt_t_05020
end type
type dw_list from datawindow within w_pdt_t_05020
end type
type rr_1 from roundrectangle within w_pdt_t_05020
end type
end forward

global type w_pdt_t_05020 from window
integer width = 4658
integer height = 2844
boolean titlebar = true
string title = "외주 재고 실사 등록"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 32106727
p_cancel p_cancel
p_exit p_exit
p_mod p_mod
p_del p_del
p_retrieve p_retrieve
rb_delete rb_delete
rb_insert rb_insert
dw_imhist dw_imhist
dw_detail dw_detail
gb_2 gb_2
dw_list dw_list
rr_1 rr_1
end type
global w_pdt_t_05020 w_pdt_t_05020

type variables
boolean ib_ItemError
char ic_status
string is_Last_Jpno, is_Date

String     is_today              //시작일자
String     is_totime             //시작시간
String     is_window_id      //윈도우 ID
String     is_usegub           //이력관리 여부
end variables

forward prototypes
public function integer wf_checkrequiredfield ()
public function integer wf_imhist_update ()
public function integer wf_imhist_create ()
public function integer wf_imhist_delete ()
public function integer wf_initial ()
end prototypes

public function integer wf_checkrequiredfield ();////////////////////////////////////////////////////////////////////
////
////		* 등록모드
////		1. 출고수량 = 0		-> SKIP
////		2. 출고수량 > 0 인 것만 전표처리
////		3. 기출고수량 + 출고수량 = 요청수량 -> 촐고완료('Y')
////	
////////////////////////////////////////////////////////////////////
//dec		dOutQty, dIsQty, dQty, dTemp_OutQty
//long		lRow,	lCount
//
//
//FOR	lRow = 1		TO		dw_list.RowCount()
//
//	dQty  = dw_list.GetItemDecimal(lRow, "qty")			// 출고요청수량
//	dIsQty  = dw_list.GetItemDecimal(lRow, "isqty")		// 기출고수량	
//	dOutQty = dw_list.GetItemDecimal(lRow, "outqty")	// 출고수량
//
//	IF ic_status = '1'	THEN
//		IF dOutQty > 0		THEN
//		
//			IF dIsQty + dOutQty = dQty		THEN		dw_list.SetItem(lRow, "hosts", 'Y')
//			dw_list.SetItem(lRow, "isqty", dw_list.GetItemDecimal(lRow, "isqty") + dOutQty)
//			dw_list.SetItem(lRow, "unqty", dw_list.GetItemDecimal(lRow, "unqty") - dOutQty)
//			lCount++
//
//		END IF
//	END IF
////
//	
//	/////////////////////////////////////////////////////////////////////////
//	//	1. 수정시 
//	/////////////////////////////////////////////////////////////////////////
//	IF iC_status = '2'	THEN
//
//		dTemp_OutQty = dw_list.GetItemDecimal(lRow, "temp_outqty")
//		dOutQty = dOutQty - dTemp_OutQty
//
//		IF dIsQty + dOutQty = dQty		THEN		dw_list.SetItem(lRow, "hosts", 'Y')
//		dw_list.SetItem(lRow, "isqty", dw_list.GetItemDecimal(lRow, "isqty") + dOutQty)
//		dw_list.SetItem(lRow, "unqty", dw_list.GetItemDecimal(lRow, "unqty") - dOutQty)
//		lCount++
//
//	END IF
//
//NEXT
//
//
//
//IF lCount < 1		THEN	RETURN -1





/********************************************************************************************/
/* 범한수정 비고란 필수입력체크 - 2001.11.05 - 송병호 */
dec		dQty
long		lRow
string	sBigo


FOR	lRow = 1		TO		dw_list.RowCount()

	IF ic_status = '1'	THEN
		dQty = dw_list.GetItemDecimal(lRow, "qty")		// 출고요청수량
		if dQty = 0 then Continue

		sBigo = dw_list.GetItemString(lRow, "bigo")	// 비고
		if IsNull(sBigo) or sBigo = '' then
			MessageBox("확인","비고란은 필수입력 항목입니다.")
			dw_list.SetRow(lRow)
			dw_list.SetColumn('bigo')
			dw_list.SetFocus()
			return -1
		end if
	ELSE
		dQty = dw_list.GetItemDecimal(lRow, "imhist_ioqty")		// 출고요청수량
		if dQty = 0 then Continue
		
		sBigo = dw_list.GetItemString(lRow, "imhist_bigo")	// 비고
		if IsNull(sBigo) or sBigo = '' then
			MessageBox("확인","비고란은 필수입력 항목입니다.")
			dw_list.SetRow(lRow)
			dw_list.SetColumn('imhist_bigo')
			dw_list.SetFocus()
			return -1
		end if
	END IF
NEXT


RETURN 1
end function

public function integer wf_imhist_update ();
IF dw_list.Update() > 0		THEN
	COMMIT;
ELSE
	f_Rollback()
	ROLLBACK;
	RETURN -1
END IF

RETURN 1
end function

public function integer wf_imhist_create ();//string sDate, Schk, scvcod, Sitnbr
//Long   cnt, silqty, rowcnt
//dec	 dSeq
//sdate  = dw_detail.GetItemstring(1, "Edate" )			
//scvcod = dw_detail.GetItemstring(1, "vendor")			
//
//For cnt    = 1 to dw_list.RowCount()
//	 Schk   = dw_list.GetItemString(cnt, "chk"   )
//	 Sitnbr = dw_list.GetItemString(cnt, "danmst_itnbr" )
//	 silqty = dw_list.GetItemNumber(cnt, "silqty")
//	 
//	If Schk = 'Y' then
//		 Select Count(*)
//			Into :rowcnt
//			From wsil_stock
//		  Where sabu  = '1'
//			 And itgu  = '1'
//			 And silym = :sdate
//			 And cvcod = :scvcod
//			 And itnbr = :Sitnbr
//		  Using sqlca;
//			  if sqlca.sqlcode = 0 and rowcnt = 0 then
//				  Insert into wsil_stock(sabu, itgu, silym, cvcod, itnbr, silqty, yebi1, yebi2, yebiqty1, yebiqty2)
//							Values  ('1', '1', :sdate, :scvcod, :sitnbr, :silqty, null, null, 0, 0)
//				  Using sqlca;
//					  IF sqlca.sqlcode <> 0	THEN
//						  f_message_chk(50,'[외주재고등록-INS]')
//						  RETURN
//					  END IF
//				  
//			  elseif sqlca.sqlcode = 0 and rowcnt <> 0 then
//				  Update wsil_stock
//					  set silqty = :silqty
//					Where sabu  = '1'
//					  And itgu  = '1'
//					  And silym = :sdate
//					  And cvcod = :scvcod
//					  And itnbr = :Sitnbr
//					Using sqlca;  
//						IF sqlca.sqlcode <> 0	THEN
//							f_message_chk(50,'[외주재고등록-UP]')
//							RETURN
//						END IF
//				end if
//	End if
//Next 
//
return 1
end function

public function integer wf_imhist_delete ();///////////////////////////////////////////////////////////////////////
//	현재행 삭제...
///////////////////////////////////////////////////////////////////////

long		lRow, lRowCount

lRowCount = dw_list.RowCount()

FOR  lRow = lRowCount 	TO		1		STEP  -1
   IF dw_list.getitemstring(lrow, 'CHK') = 'Y' then 
		dw_list.DeleteRow(lRow)
	END IF
NEXT


RETURN 1
end function

public function integer wf_initial ();
dw_detail.setredraw(false)
dw_detail.reset()
dw_list.reset()
dw_imhist.reset()

//cb_save.enabled = false
p_del.enabled = false

dw_detail.enabled = TRUE

dw_detail.insertrow(0)

IF ic_status = '1'	then

	// 등록시

	dw_detail.settaborder("vendor", 10)
	dw_detail.settaborder("empno",  20)
	dw_detail.settaborder("edate",  5)

	dw_detail.setcolumn("vendor")
	dw_detail.SetItem(1, "edate", is_Date)

	w_mdi_frame.sle_msg.text = "등록"
	
	dw_detail.Modify("t_req_vendor.visible = 1")
	dw_detail.Modify("t_req_empno.visible = 1")
	dw_detail.Modify("t_req_date.visible = 0")
ELSE

	dw_detail.settaborder("vendor", 10)
	dw_detail.settaborder("empno",  0)
	dw_detail.settaborder("edate",  30)

	dw_detail.setcolumn("vendor")
	dw_detail.SetItem(1, "edate", is_Date)

	w_mdi_frame.sle_msg.text = "삭제"
	
	dw_detail.Modify("t_req_vendor.visible = 0")
	dw_detail.Modify("t_req_empno.visible = 0")
	dw_detail.Modify("t_req_date.visible = 1")
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

is_window_id = this.ClassName()
is_today     = f_today()
is_totime    = f_totime()
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

dw_detail.settransobject(sqlca)
dw_list.settransobject(sqlca)
dw_imhist.settransobject(sqlca)

is_Date = Mid(f_Today(),1,6)

// commandbutton function
rb_insert.TriggerEvent("clicked")


end event

on w_pdt_t_05020.create
this.p_cancel=create p_cancel
this.p_exit=create p_exit
this.p_mod=create p_mod
this.p_del=create p_del
this.p_retrieve=create p_retrieve
this.rb_delete=create rb_delete
this.rb_insert=create rb_insert
this.dw_imhist=create dw_imhist
this.dw_detail=create dw_detail
this.gb_2=create gb_2
this.dw_list=create dw_list
this.rr_1=create rr_1
this.Control[]={this.p_cancel,&
this.p_exit,&
this.p_mod,&
this.p_del,&
this.p_retrieve,&
this.rb_delete,&
this.rb_insert,&
this.dw_imhist,&
this.dw_detail,&
this.gb_2,&
this.dw_list,&
this.rr_1}
end on

on w_pdt_t_05020.destroy
destroy(this.p_cancel)
destroy(this.p_exit)
destroy(this.p_mod)
destroy(this.p_del)
destroy(this.p_retrieve)
destroy(this.rb_delete)
destroy(this.rb_insert)
destroy(this.dw_imhist)
destroy(this.dw_detail)
destroy(this.gb_2)
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

event activate;w_mdi_frame.st_window.Text = Upper(is_window_id)
end event

type p_cancel from uo_picture within w_pdt_t_05020
integer x = 4229
integer y = 24
integer width = 178
integer taborder = 60
string pointer = "c:\ERPMAN\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

event clicked;call super::clicked;
rb_insert.checked = true

rb_insert.TriggerEvent("clicked")

//규격,재질 
If f_change_name('1') = 'Y' Then
	String sIspecText, sJijilText
	
	sIspectext = f_change_name('2')
	sJijilText = f_change_name('3')
	
	dw_list.Object.ispec_tx.text =  sIspecText 
	dw_list.Object.jijil_tx.text =  sJijilText
End If

end event

type p_exit from uo_picture within w_pdt_t_05020
integer x = 4402
integer y = 24
integer width = 178
integer taborder = 70
string pointer = "c:\ERPMAN\cur\Point.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

event clicked;call super::clicked;CLOSE(PARENT)
end event

type p_mod from uo_picture within w_pdt_t_05020
integer x = 3881
integer y = 24
integer width = 178
integer taborder = 40
string pointer = "c:\ERPMAN\cur\Point.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

event clicked;call super::clicked;SetPointer(HourGlass!)

IF dw_list.RowCount()     < 1		THEN 	RETURN 
IF dw_detail.AcceptText() = -1	THEN	RETURN
IF dw_list.AcceptText()   = -1	THEN	RETURN


string sDate, Schk, scvcod, Sitnbr
Long   cnt, silqty, rowcnt
dec	 dSeq
sdate  = dw_detail.GetItemstring(1, "Edate" )			
scvcod = dw_detail.GetItemstring(1, "vendor")			

IF ic_status = '1'		THEN
	For cnt    = 1 to dw_list.RowCount()
		 Schk   = dw_list.GetItemString(cnt, "chk"   )
		 Sitnbr = dw_list.GetItemString(cnt, "danmst_itnbr" )
		 silqty = dw_list.GetItemNumber(cnt, "silqty")
		 
		If Schk = 'Y' then
			 Select Count(*)
				Into :rowcnt
				From wsil_stock
			  Where sabu  = '1'
				 And itgu  = '1'
				 And silym = :sdate
				 And cvcod = :scvcod
				 And itnbr = :Sitnbr
			  Using sqlca;
				  if sqlca.sqlcode = 0 and rowcnt = 0 then
					  Insert into wsil_stock(sabu, itgu, silym, cvcod, itnbr, silqty, yebi1, yebi2, yebiqty1, yebiqty2)
								Values  ('1', '1', :sdate, :scvcod, :sitnbr, :silqty, null, null, 0, 0)
					  Using sqlca;
						  IF sqlca.sqlcode <> 0	THEN
							  f_message_chk(50,'[외주재고등록-INS]')
							  RETURN
						  ELSE
							  COMMIT;
						  END IF
					  
				  elseif sqlca.sqlcode = 0 and rowcnt <> 0 then
					  Update wsil_stock
						  set silqty = :silqty
						Where sabu  = '1'
						  And itgu  = '1'
						  And silym = :sdate
						  And cvcod = :scvcod
						  And itnbr = :Sitnbr
						Using sqlca;  
							IF sqlca.sqlcode <> 0	THEN
								f_message_chk(50,'[외주재고등록-UP]')
								RETURN
							ELSE
								COMMIT;
							END IF
					end if
		End if
	Next 
	
ELSE
	wf_imhist_update() 
END IF
p_cancel.TriggerEvent("clicked")	

SetPointer(Arrow!)


end event

type p_del from uo_picture within w_pdt_t_05020
integer x = 4055
integer y = 24
integer width = 178
integer taborder = 50
string pointer = "c:\ERPMAN\cur\Point.cur"
boolean enabled = false
string picturename = "C:\erpman\image\삭제_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\삭제_up.gif"
end event

event clicked;call super::clicked;//////////////////////////////////////////////////////////////////
///	* 입고내역 삭제
//////////////////////////////////////////////////////////////////

IF f_msg_delete() = -1 THEN	RETURN
	
IF wf_Imhist_Delete() = -1		THEN	RETURN


IF dw_list.Update() >= 0		THEN
	COMMIT;
ELSE
	ROLLBACK;
	f_Rollback()
END IF


end event

type p_retrieve from uo_picture within w_pdt_t_05020
integer x = 3707
integer y = 24
integer width = 178
integer taborder = 20
string pointer = "c:\ERPMAN\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조회_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조회_up.gif"
end event

event clicked;call super::clicked;	
if dw_detail.Accepttext() = -1	then 	return

string  	sVendor,		&
			sEmpno,		&
			sDate,		&
			sNull
SetNull(sNull)

sVendor	= dw_detail.getitemstring(1, "vendor")
sEmpno  	= dw_detail.getitemstring(1, "empno")
sDate    = trim(dw_detail.getitemstring(1, "edate"))


////////////////////////////////////////////////////////////////////////////

IF ic_status = '1'		THEN

	IF isnull(sVendor) or sVendor = "" 	THEN
		f_message_chk(30,'[거래처]')
		dw_detail.SetColumn("vendor")
		dw_detail.SetFocus()
		RETURN
	END IF

	IF	dw_list.Retrieve(sVendor) <	1		THEN
		f_message_chk(50, '[외주재고조정]')
		dw_detail.setcolumn("vendor")
		dw_detail.setfocus()
		return
	END IF

	dw_list.SetColumn("silqty")
	
ELSE

	IF isnull(sDate) or sDate = "" 	THEN
		f_message_chk(30,'[조정일자]')
		dw_detail.SetColumn("edate")
		dw_detail.SetFocus()
		RETURN
	END IF

	IF	dw_list.Retrieve(sDate, sVendor) <	1		THEN
		f_message_chk(50, '[외주재고조정]')
		dw_detail.setcolumn("vendor")
		dw_detail.setfocus()
		return
	END IF

	// 삭제모드에서만 삭제가능
	p_del.enabled = true	
	dw_list.SetColumn("wsil_stock_silqty")
END IF

//////////////////////////////////////////////////////////////////////////

dw_detail.enabled = false
dw_list.SetFocus()

//규격,재질 
If f_change_name('1') = 'Y' Then
	String sIspecText, sJijilText
	
	sIspectext = f_change_name('2')
	sJijilText = f_change_name('3')
	
	dw_list.Object.ispec_tx.text =  sIspecText 
	dw_list.Object.jijil_tx.text =  sJijilText
End If



end event

type rb_delete from radiobutton within w_pdt_t_05020
integer x = 3415
integer y = 68
integer width = 224
integer height = 72
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "수정"
end type

event clicked;
ic_status = '2'

dw_list.DataObject = 'd_pdt_t_05020_2'
dw_list.SetTransObject(sqlca)

//wf_Initial()

//규격,재질 
If f_change_name('1') = 'Y' Then
	String sIspecText, sJijilText
	
	sIspectext = f_change_name('2')
	sJijilText = f_change_name('3')
	
	dw_list.Object.ispec_tx.text =  sIspecText 
	dw_list.Object.jijil_tx.text =  sJijilText
End If
end event

type rb_insert from radiobutton within w_pdt_t_05020
integer x = 3141
integer y = 68
integer width = 224
integer height = 72
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "등록"
boolean checked = true
end type

event clicked;
ic_status = '1'	// 등록

dw_list.DataObject = 'd_pdt_t_05020_1'
dw_list.SetTransObject(sqlca)

wf_Initial()

//규격,재질 
If f_change_name('1') = 'Y' Then
	String sIspecText, sJijilText
	
	sIspectext = f_change_name('2')
	sJijilText = f_change_name('3')
	
	dw_list.Object.ispec_tx.text =  sIspecText 
	dw_list.Object.jijil_tx.text =  sJijilText
End If
end event

type dw_imhist from datawindow within w_pdt_t_05020
boolean visible = false
integer x = 96
integer y = 2316
integer width = 494
integer height = 212
boolean titlebar = true
string title = "입출고HISTORY"
string dataobject = "d_pdt_imhist"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
end type

type dw_detail from datawindow within w_pdt_t_05020
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 59
integer y = 36
integer width = 2939
integer height = 128
integer taborder = 10
string dataobject = "d_pdt_t_05020"
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

event itemchanged;
string	sCode, sName,	sname2,	&
			sNull, s_date
int      ireturn 
SetNull(sNull)

// 거래처
IF this.GetColumnName() = "vendor" THEN
	

	scode = this.GetText()								
	
   ireturn = f_get_name2('V1', 'Y', scode, sname, sname2)    //1이면 실패, 0이 성공	

	this.setitem(1, 'vendor', scode)
	this.setitem(1, 'vendorname', sName)
   return ireturn 

ELSEIF this.GetColumnName() = "empno" THEN

	scode = this.GetText()								
   ireturn = f_get_name2('사번', 'Y', scode, sname, sname2)    //1이면 실패, 0이 성공	

	this.setitem(1, 'empno', scode)
	this.setitem(1, 'empname', sname)
   return ireturn 
	
ELSEIF this.GetColumnName() = "edate" THEN

	s_date = Trim(this.Gettext())
	IF s_date ="" OR IsNull(s_date) THEN RETURN
	
	IF f_datechk(s_date) = -1 THEN
		f_message_chk(35,'[조정일자]')
		this.SetItem(1,"edate",snull)
		this.Setcolumn("edate")
		this.SetFocus()
		Return 1
	END IF
	
END IF
end event

event itemerror;RETURN 1
end event

event losefocus;this.accepttext()
end event

event rbuttondown;gs_code = ''
gs_codename = ''
gs_gubun = ''

// 거래처
IF this.GetColumnName() = 'vendor'	THEN
   Gs_gubun = '1' 
	
	Open(w_vndmst_popup)
	
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1,"vendor",gs_code)
	SetItem(1,"vendorname",gs_codename)

	this.TriggerEvent("itemchanged")
	
END IF


// 의뢰담당자
IF this.GetColumnName() = 'empno'	THEN

	Open(w_sawon_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1,"empno",  gs_code)
	SetItem(1,"empname",gs_codename)

END IF


end event

type gb_2 from groupbox within w_pdt_t_05020
integer x = 3090
integer width = 594
integer height = 168
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 32106727
borderstyle borderstyle = styleraised!
end type

type dw_list from datawindow within w_pdt_t_05020
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 78
integer y = 196
integer width = 4480
integer height = 2080
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_pdt_t_05020_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemchanged;string	sNull
long		lRow
dec		dQty, dStock
SetNull(sNull)

lRow  = this.GetRow()	

///////////////////////////////////////////////////////////////////////////
// 1. 조정수량 > 현재고 이면 ERROR
///////////////////////////////////////////////////////////////////////////
IF this.GetColumnName() = "silqty" THEN
	dQty    = dec(this.GetText())
	if Isnull(dqty) then 
		dqty = 0
		dw_list.SetItem(dw_list.GetRow(), "silqty", dqty)
		dw_list.SetItem(dw_list.GetRow(), "chk"   , 'N' )
	end if

	IF dQty < 0 	THEN
		MessageBox("확인", "재고수량이 0보다 작습니다.")
		this.SetItem(lRow, "silqty", 0)
		RETURN 1
	END IF
	
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

event losefocus;this.AcceptText()
end event

event rowfocuschanged;//this.setrowfocusindicator ( HAND! )
end event

event editchanged;Long silqty

dw_list.AcceptText()

//silqty = dw_list.GetItemNumber(dw_list.GetRow(), "silqty")

Choose Case dwo.name
	 	 Case "silqty"
			   silqty = Long(data)
				if silqty <> 0 then
					dw_list.SetItem(dw_list.GetRow(), "chk", 'Y')
				else
					dw_list.SetItem(dw_list.GetRow(), "chk", 'N')
				end if
				
			case else
				return
End choose
end event

type rr_1 from roundrectangle within w_pdt_t_05020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 64
integer y = 188
integer width = 4507
integer height = 2100
integer cornerheight = 40
integer cornerwidth = 55
end type

