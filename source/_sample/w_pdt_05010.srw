$PBExportHeader$w_pdt_05010.srw
$PBExportComments$외주 재고조정
forward
global type w_pdt_05010 from window
end type
type pb_1 from u_pb_cal within w_pdt_05010
end type
type cbx_select from checkbox within w_pdt_05010
end type
type dw_list from u_d_popup_sort within w_pdt_05010
end type
type p_cancel from uo_picture within w_pdt_05010
end type
type p_exit from uo_picture within w_pdt_05010
end type
type p_mod from uo_picture within w_pdt_05010
end type
type p_del from uo_picture within w_pdt_05010
end type
type p_retrieve from uo_picture within w_pdt_05010
end type
type rb_delete from radiobutton within w_pdt_05010
end type
type rb_insert from radiobutton within w_pdt_05010
end type
type dw_imhist from datawindow within w_pdt_05010
end type
type dw_detail from datawindow within w_pdt_05010
end type
type rr_1 from roundrectangle within w_pdt_05010
end type
type rr_2 from roundrectangle within w_pdt_05010
end type
end forward

global type w_pdt_05010 from window
integer width = 4658
integer height = 2440
boolean titlebar = true
string title = "외주재고조정"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 32106727
pb_1 pb_1
cbx_select cbx_select
dw_list dw_list
p_cancel p_cancel
p_exit p_exit
p_mod p_mod
p_del p_del
p_retrieve p_retrieve
rb_delete rb_delete
rb_insert rb_insert
dw_imhist dw_imhist
dw_detail dw_detail
rr_1 rr_1
rr_2 rr_2
end type
global w_pdt_05010 w_pdt_05010

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
public function integer wf_imhist_create ()
public function integer wf_checkrequiredfield ()
public function integer wf_imhist_delete ()
public function integer wf_imhist_update ()
public function integer wf_initial ()
end prototypes

public function integer wf_imhist_create ();///////////////////////////////////////////////////////////////////////
//
//	* 등록모드
//	1. 입출고HISTORY 생성
//	2. 전표채번구분 = 'C0'
// 3. 전표생성구분 = '003'
//
///////////////////////////////////////////////////////////////////////
string	sJpno, 				&
			sDate, sToday,		&
			sVendor, sEmpno,	&
			sSpec
long		lRow, lRowHist
dec		dSeq, dQty

dw_detail.AcceptText()

sDate = dw_detail.GetItemString(1, "edate")				// 조정일자
dSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'C0')

IF dSeq < 0		THEN	RETURN -1

COMMIT;

////////////////////////////////////////////////////////////////////////
sJpno  = sDate + string(dSeq, "0000")
sToday = f_Today()
sVendor= dw_detail.GetItemString(1, "vendor")
sEmpno = dw_detail.GetItemString(1, "empno")


FOR	lRow = 1		TO		dw_list.RowCount()

	dQty  = dw_list.GetItemDecimal(lRow, "qty")
	sSpec = dw_list.GetItemString(lRow, "pspec")
	IF IsNull(sSpec) or sSpec = ''	THEN	sSpec = '.'


	IF dQty <> 0		THEN
	
		/////////////////////////////////////////////////////////////////////////
		//
		// ** 입출고HISTORY 생성 **
		//
		////////////////////////////////////////////////////////////////////////
		lRowHist = dw_imhist.InsertRow(0)
	
		dw_imhist.SetItem(lRowHist, "sabu",		gs_sabu)
		dw_imhist.SetItem(lRowHist, "jnpcrt",	'003')			// 전표생성구분
		dw_imhist.SetItem(lRowHist, "inpcnf",  'O')				// 입출고구분
		dw_imhist.SetItem(lRowHist, "iojpno", 	sJpno + string(lRowHist, "000") )
		dw_imhist.SetItem(lRowHist, "iogbn",   'O21') 			// 수불구분='외주재고조정'
	
		dw_imhist.SetItem(lRowHist, "sudat",	sToday)			// 수불일자=현재일자
		dw_imhist.SetItem(lRowHist, "itnbr",	dw_list.GetItemString(lRow, "itnbr")) // 품번
		dw_imhist.SetItem(lRowHist, "pspec",	sSpec) 			// 사양
		dw_imhist.SetItem(lRowHist, "opseq",	dw_list.GetItemString(lRow, "opseq")) // 공정순서
		dw_imhist.SetItem(lRowHist, "depot_no",sVendor)			// 기준창고  =거래처
		dw_imhist.SetItem(lRowHist, "cvcod",	sVendor) 		// 거래처창고=거래처
		dw_imhist.SetItem(lRowHist, "ioqty",	dw_list.GetItemDecimal(lRow, "qty")) 	// 수불수량=조정수량
		dw_imhist.SetItem(lRowHist, "ioreqty",	dw_list.GetItemDecimal(lRow, "qty")) 	// 수불의뢰수량=출고수량		
		dw_imhist.SetItem(lRowHist, "insdat",	sDate)			// 검사일자=조정일자	
		dw_imhist.SetItem(lRowHist, "iosuqty",	dw_list.GetItemDecimal(lRow, "qty")) 	// 합격수량=출고수량		
		dw_imhist.SetItem(lRowHist, "io_confirm",	'Y')			// 수불승인여부
		dw_imhist.SetItem(lRowHist, "io_date",	sDate)			// 수불승인일자=조정일자	
		dw_imhist.SetItem(lRowHist, "io_empno",sEmpno)			// 수불승인자=담당자	
		dw_imhist.SetItem(lRowHist, "bigo",    dw_list.getitemstring(lrow, "bigo"))			// 사유
		
		dw_imhist.SetItem(lRowHist, "crt_user", gs_empno)      //등록자(Login)
//		dw_imhist.SetItem(lRowHist, "hold_no", dw_list.GetItemString(lRow, "hold_no")) 	// 할당번호
//		dw_imhist.SetItem(lRowHist, "filsk",   dw_list.GetItemString(lRow, "itemas_filsk")) // 재고관리유무
//		dw_imhist.SetItem(lRowHist, "botimh",	'N')				// 동시출고여부
//		dw_imhist.SetItem(lRowHist, "itgu",    dw_list.GetItemString(lRow, "itemas_itgu")) 	// 구입형태
//		dw_imhist.SetItem(lRowHist, "outchk",  dw_list.GetItemString(lRow, "hosts")) 			// 출고의뢰완료
//		
	END IF

NEXT

MessageBox("전표번호 확인", "전표번호 : " +sDate+ '-' + string(dSeq,"0000")+		&
									 "~r~r생성되었습니다.")

RETURN 1
end function

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

public function integer wf_imhist_delete ();///////////////////////////////////////////////////////////////////////
//
//	1. 입출고HISTORY 삭제
//
///////////////////////////////////////////////////////////////////////

long		lRow, lRowCount

lRowCount = dw_list.RowCount()

FOR  lRow = lRowCount 	TO		1		STEP  -1
   IF dw_list.getitemstring(lrow, 'opt') = 'Y' then 
		dw_list.DeleteRow(lRow)
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

public function integer wf_initial ();
dw_detail.setredraw(false)
dw_detail.reset()
dw_list.reset()
dw_imhist.reset()

//cb_save.enabled = false
p_del.enabled = false

//dw_detail.enabled = TRUE

dw_detail.insertrow(0)

IF ic_status = '1'	then

	// 등록시

	dw_detail.settaborder("vendor", 10)
	dw_detail.settaborder("empno",  20)
	dw_detail.settaborder("edate",  0)

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

pb_1.Visible = True

dw_detail.setfocus()

dw_list.SetFilter("itemas_useyn='0' ")
dw_list.Filter()

dw_detail.setredraw(true)

return  1

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

dw_detail.settransobject(sqlca)
dw_list.settransobject(sqlca)
dw_imhist.settransobject(sqlca)

//dw_imhist.settransobject(sqlca)

is_Date = f_Today()


// commandbutton function
rb_insert.TriggerEvent("clicked")


end event

on w_pdt_05010.create
this.pb_1=create pb_1
this.cbx_select=create cbx_select
this.dw_list=create dw_list
this.p_cancel=create p_cancel
this.p_exit=create p_exit
this.p_mod=create p_mod
this.p_del=create p_del
this.p_retrieve=create p_retrieve
this.rb_delete=create rb_delete
this.rb_insert=create rb_insert
this.dw_imhist=create dw_imhist
this.dw_detail=create dw_detail
this.rr_1=create rr_1
this.rr_2=create rr_2
this.Control[]={this.pb_1,&
this.cbx_select,&
this.dw_list,&
this.p_cancel,&
this.p_exit,&
this.p_mod,&
this.p_del,&
this.p_retrieve,&
this.rb_delete,&
this.rb_insert,&
this.dw_imhist,&
this.dw_detail,&
this.rr_1,&
this.rr_2}
end on

on w_pdt_05010.destroy
destroy(this.pb_1)
destroy(this.cbx_select)
destroy(this.dw_list)
destroy(this.p_cancel)
destroy(this.p_exit)
destroy(this.p_mod)
destroy(this.p_del)
destroy(this.p_retrieve)
destroy(this.rb_delete)
destroy(this.rb_insert)
destroy(this.dw_imhist)
destroy(this.dw_detail)
destroy(this.rr_1)
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

type pb_1 from u_pb_cal within w_pdt_05010
integer x = 3433
integer y = 68
integer taborder = 20
end type

event clicked;call super::clicked;dw_detail.Setcolumn('edate')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_detail.SetItem(1, 'edate', gs_code)
end event

type cbx_select from checkbox within w_pdt_05010
integer x = 4206
integer y = 180
integer width = 370
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "전체 선택"
end type

event clicked;Double ld_realqty, ld_jego_qty, ld_qty
long i

IF cbx_select.Checked = True THEN
	For i = 1 to dw_list.RowCount()
		dw_list.SetItem(i, "opt", 'Y')

//		ld_realqty = Double(dw_list.GetItemNumber(i,'real_stock'))

		ld_jego_qty = dw_list.GetItemNumber(i,"jego_qty")
		ld_qty = ld_jego_qty - ld_realqty

		If	rb_insert.Checked Then
			//dw_list.SetItem(i,"qty", ld_qty)
			dw_list.SetItem(i,"real_stock", ld_jego_qty)
			dw_list.SetItem(i,"qty", 0)
		End If
	Next
Else 
	For i = 1 to dw_list.RowCount()
		dw_list.SetItem(i, "opt", 'N')
		If	rb_insert.Checked Then
			dw_list.SetItem(i,"qty", 0 )
			dw_list.SetItem(i,"real_stock", 0 )
		End If

	Next
End If
end event

type dw_list from u_d_popup_sort within w_pdt_05010
integer x = 69
integer y = 276
integer width = 4480
integer height = 2020
integer taborder = 20
string dataobject = "d_pdt_05010"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event itemchanged;call super::itemchanged;String ls_colNm
Double ld_realqty, ld_jego_qty, ld_qty

ls_colNm = GetColumnName() 
	
If ls_colNm = "real_stock" or ( ls_colNm = "opt" and data ='Y' ) Then
	ld_realqty = Double(this.GetText())
//	IF ld_realqty = 0 OR IsNull(ld_realqty) THEN Return

	ld_jego_qty = this.GetItemNumber(row,"jego_qty")
	ld_qty = ld_jego_qty - ld_realqty

	If	rb_insert.Checked Then
		SetItem(row,"qty", ld_qty)
	ElseIf rb_delete.Checked and ls_colNm = "real_stock" Then
		SetItem(row,"imhist_ioqty", ld_qty)
	End If
Elseif ls_colNm = "opt" and data ='N' Then
	If	rb_insert.Checked Then
		SetItem(row,"qty", 0 )
		SetItem(row,"real_stock", 0 )
	End If
End If

end event

type p_cancel from uo_picture within w_pdt_05010
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

type p_exit from uo_picture within w_pdt_05010
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

type p_mod from uo_picture within w_pdt_05010
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

IF dw_list.RowCount() < 1			THEN 	RETURN 
IF dw_detail.AcceptText() = -1	THEN	RETURN
IF dw_list.AcceptText() = -1		THEN	RETURN

string	sDate
sdate  = dw_detail.GetItemstring(1, "Edate")			

//////////////////////////////////////////////////////////////////////////////////
//		
//		1. 수량 = 0		-> RETURN
//		2. 입출고HISTORY : 전표채번구분('C0')
//
//////////////////////////////////////////////////////////////////////////////////
dec	dSeq

IF	wf_CheckRequiredField() = -1	THEN	RETURN 
	

IF f_msg_update() = -1 	THEN	RETURN


/////////////////////////////////////////////////////////////////////////
//	1. 등록시 전표번호 생성
/////////////////////////////////////////////////////////////////////////

IF ic_status = '1'	THEN
	
	wf_imhist_create()

	IF dw_list.Update() <= 0		THEN
		f_Rollback()
		ROLLBACK;
	END IF

	IF dw_imhist.Update() > 0		THEN
		COMMIT;
	ELSE
		f_Rollback()
		ROLLBACK;
	END IF

/////////////////////////////////////////////////////////////////////////
//	1. 수정 : 입출고HISTORY(조정수량)
/////////////////////////////////////////////////////////////////////////
ELSE

	wf_imhist_update()
	
END IF



p_retrieve.TriggerEvent("clicked")	

SetPointer(Arrow!)


end event

type p_del from uo_picture within w_pdt_05010
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


//cb_cancel.TriggerEvent("clicked")
	
	

end event

type p_retrieve from uo_picture within w_pdt_05010
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
			sNull, ls_ittyp
SetNull(sNull)

sVendor	= dw_detail.getitemstring(1, "vendor")
sEmpno  	= dw_detail.getitemstring(1, "empno")
sDate    = trim(dw_detail.getitemstring(1, "edate"))
ls_ittyp    = trim(dw_detail.getitemstring(1, "ittyp"))	// 품목구분 추가 by shjeon 20120920

if (IsNull(ls_ittyp) or ls_ittyp = "")  then ls_ittyp = "%"

////////////////////////////////////////////////////////////////////////////

IF ic_status = '1'		THEN

	IF isnull(sVendor) or sVendor = "" 	THEN
		f_message_chk(30,'[거래처]')
		dw_detail.SetColumn("vendor")
		dw_detail.SetFocus()
		RETURN
	END IF

	IF isnull(sEmpno) or sEmpno = "" 	THEN
		f_message_chk(30,'[담당자]')
		dw_detail.SetColumn("empno")
		dw_detail.SetFocus()
		RETURN
	END IF

	IF	dw_list.Retrieve(sVendor, ls_ittyp) <	1		THEN
		f_message_chk(50, '[외주재고조정]')
		dw_detail.setcolumn("vendor")
		dw_detail.setfocus()
		return
	END IF

	dw_list.SetColumn("qty")
	
ELSE

	IF isnull(sDate) or sDate = "" 	THEN
		f_message_chk(30,'[조정일자]')
		dw_detail.SetColumn("edate")
		dw_detail.SetFocus()
		RETURN
	END IF

	IF	dw_list.Retrieve(gs_sabu, sVendor, sDate, ls_ittyp) <	1		THEN
		f_message_chk(50, '[외주재고조정]')
		dw_detail.setcolumn("vendor")
		dw_detail.setfocus()
		return
	END IF

	// 삭제모드에서만 삭제가능
	p_del.enabled = true	
	dw_list.SetColumn("imhist_ioqty")
	
END IF

//////////////////////////////////////////////////////////////////////////

//dw_detail.enabled = false

dw_detail.settaborder("vendor", 0)
dw_detail.settaborder("empno",  0)
dw_detail.settaborder("edate",  0)

pb_1.Visible = False

dw_list.SetFocus()
//cb_save.enabled = true

//규격,재질 
If f_change_name('1') = 'Y' Then
	String sIspecText, sJijilText
	
	sIspectext = f_change_name('2')
	sJijilText = f_change_name('3')
	
	dw_list.Object.ispec_tx.text =  sIspecText 
	dw_list.Object.jijil_tx.text =  sJijilText
End If

end event

type rb_delete from radiobutton within w_pdt_05010
integer x = 311
integer y = 80
integer width = 224
integer height = 72
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

event clicked;
ic_status = '2'

dw_list.DataObject = 'd_pdt_05012'
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

type rb_insert from radiobutton within w_pdt_05010
integer x = 87
integer y = 80
integer width = 224
integer height = 72
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

event clicked;
ic_status = '1'	// 등록

dw_list.DataObject = 'd_pdt_05010'
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

type dw_imhist from datawindow within w_pdt_05010
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

type dw_detail from datawindow within w_pdt_05010
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 567
integer y = 28
integer width = 2990
integer height = 232
integer taborder = 10
string dataobject = "d_pdt_05011"
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
	
ELSEIF this.GetColumnName() = "useyn" THEN

	scode = Trim(this.Gettext())
	if scode = 'Y' 	then
		dw_list.SetFilter("itemas_useyn='0' ")
		dw_list.Filter()
	else
		dw_list.SetFilter("")
		dw_list.Filter()
	end if
	
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

type rr_1 from roundrectangle within w_pdt_05010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 64
integer y = 272
integer width = 4507
integer height = 2052
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pdt_05010
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 55
integer y = 40
integer width = 489
integer height = 144
integer cornerheight = 40
integer cornerwidth = 55
end type

