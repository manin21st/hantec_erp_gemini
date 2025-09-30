$PBExportHeader$w_qa02_00051.srw
$PBExportComments$** 수정불합격처리-임의등록
forward
global type w_qa02_00051 from window
end type
type st_4 from statictext within w_qa02_00051
end type
type st_3 from statictext within w_qa02_00051
end type
type dw_hidden_2 from datawindow within w_qa02_00051
end type
type cb_5 from commandbutton within w_qa02_00051
end type
type cb_4 from commandbutton within w_qa02_00051
end type
type cb_3 from commandbutton within w_qa02_00051
end type
type cb_2 from commandbutton within w_qa02_00051
end type
type dw_soje from u_key_enter within w_qa02_00051
end type
type dw_hidden from datawindow within w_qa02_00051
end type
type p_1 from uo_picture within w_qa02_00051
end type
type cb_1 from commandbutton within w_qa02_00051
end type
type pb_1 from u_pb_cal within w_qa02_00051
end type
type p_ins from picture within w_qa02_00051
end type
type p_exit from uo_picture within w_qa02_00051
end type
type p_can from uo_picture within w_qa02_00051
end type
type p_del from uo_picture within w_qa02_00051
end type
type p_mod from uo_picture within w_qa02_00051
end type
type p_inq from uo_picture within w_qa02_00051
end type
type st_2 from statictext within w_qa02_00051
end type
type st_1 from statictext within w_qa02_00051
end type
type rb_2 from radiobutton within w_qa02_00051
end type
type rb_1 from radiobutton within w_qa02_00051
end type
type cb_delete from commandbutton within w_qa02_00051
end type
type cb_cancel from commandbutton within w_qa02_00051
end type
type rb_delete from radiobutton within w_qa02_00051
end type
type rb_insert from radiobutton within w_qa02_00051
end type
type dw_imhist from datawindow within w_qa02_00051
end type
type dw_detail from datawindow within w_qa02_00051
end type
type cb_save from commandbutton within w_qa02_00051
end type
type cb_exit from commandbutton within w_qa02_00051
end type
type cb_retrieve from commandbutton within w_qa02_00051
end type
type dw_list from datawindow within w_qa02_00051
end type
type gb_1 from groupbox within w_qa02_00051
end type
type rr_1 from roundrectangle within w_qa02_00051
end type
type rr_3 from roundrectangle within w_qa02_00051
end type
type rr_4 from roundrectangle within w_qa02_00051
end type
type rr_5 from roundrectangle within w_qa02_00051
end type
end forward

global type w_qa02_00051 from window
integer width = 4672
integer height = 2840
boolean titlebar = true
string title = "수정 불합격 처리 [임의등록]"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 32106727
st_4 st_4
st_3 st_3
dw_hidden_2 dw_hidden_2
cb_5 cb_5
cb_4 cb_4
cb_3 cb_3
cb_2 cb_2
dw_soje dw_soje
dw_hidden dw_hidden
p_1 p_1
cb_1 cb_1
pb_1 pb_1
p_ins p_ins
p_exit p_exit
p_can p_can
p_del p_del
p_mod p_mod
p_inq p_inq
st_2 st_2
st_1 st_1
rb_2 rb_2
rb_1 rb_1
cb_delete cb_delete
cb_cancel cb_cancel
rb_delete rb_delete
rb_insert rb_insert
dw_imhist dw_imhist
dw_detail dw_detail
cb_save cb_save
cb_exit cb_exit
cb_retrieve cb_retrieve
dw_list dw_list
gb_1 gb_1
rr_1 rr_1
rr_3 rr_3
rr_4 rr_4
rr_5 rr_5
end type
global w_qa02_00051 w_qa02_00051

type variables
boolean ib_ItemError
char ic_status
string is_Last_Jpno, is_Date

String     is_today              //시작일자
String     is_totime             //시작시간
String     is_window_id      //윈도우 ID
String     is_usegub           //이력관리 여부

string is_pspec, is_jijil  
end variables

forward prototypes
public function integer wf_initial ()
public function integer wf_checkrequiredfield ()
public function integer wf_create_shpfat_qa_sum ()
public subroutine wf_depot_protect (long arg_row)
public function integer wf_jepum_yn (long arg_row)
public function integer wf_set_soje (integer ar_row, string ar_gub)
public function integer wf_set_filter (integer ar_row)
end prototypes

public function integer wf_initial ();dw_detail.setredraw( false)
dw_list.setredraw( false)

IF ic_status = '1'	then
	dw_detail.DataObject = 'd_qa02_00051_0'
	dw_list.DataObject = 'd_qa02_00051_a'

	dw_detail.insertrow(0)
//	dw_detail.SetItem(1, "idate", is_Date)
	dw_detail.setcolumn("vendor")
	w_mdi_frame.sle_msg.text = "등록"
	
//	p_inq.ENabled = FALSE
//	p_del.ENabled = FALSE
//	
//	p_ins.ENabled = TRUE
//	p_mod.ENabled = TRUE
//	
//	
//	p_inq.picturename = "C:\erpman\image\조회_d.gif"
//	p_del.picturename = "C:\erpman\image\삭제_d.gif"
//	p_ins.picturename = "C:\erpman\image\추가_up.gif"
//	p_mod.picturename = "C:\erpman\image\저장_up.gif"
	
	
ELSE
	dw_detail.DataObject = 'd_qa02_00051_1'
	dw_list.DataObject = 'd_qa02_00051_b'

	dw_detail.insertrow(0)
	dw_detail.setcolumn("jpno")
	w_mdi_frame.sle_msg.text = "삭제"
	
	p_inq.ENabled = true
	p_del.ENabled = true
	
	p_ins.ENabled = false
	p_mod.ENabled = false

	p_inq.picturename = "C:\erpman\image\조회_up.gif"
	p_del.picturename = "C:\erpman\image\삭제_up.gif"
	p_ins.picturename = "C:\erpman\image\추가_d.gif"
	p_mod.picturename = "C:\erpman\image\저장_d.gif"	
	
END IF
dw_detail.Enabled = true
dw_list.SetTransObject(sqlca)
dw_detail.setfocus()

dw_detail.setredraw( true)
dw_list.setredraw( true)

dw_soje.Reset()

return  1
end function

public function integer wf_checkrequiredfield ();Long 		i
String  	sitem, ls_bigo, scvcod, sidate, shcode, sdepot, sbgbn, spinbr
Decimal 	dQty

//scvcod = dw_detail.getitemstring(1,'vendor')
//if isnull(scvcod) or scvcod = '' then
//	messagebox('확인','거래처를 확인하세요')
//	dw_detail.setcolumn('vendor')
//	dw_detail.setfocus()
//	return -1
//end if

sidate = dw_detail.getitemstring(1,'idate')
if f_datechk(sidate) = -1 then
	messagebox('확인','처리일자를 확인하세요')
	dw_detail.setcolumn('idate')
	dw_detail.setfocus()
	return -1
end if

For i = 1 To dw_list.rowcount()
	sItem    = Trim(dw_list.GetItemString(i,"itnbr"))
	dQty     = dw_list.GetItemNumber(i,"faqty")
	shcode	= dw_list.GetItemString(i,"hcode")
	sdepot	= dw_list.GetItemString(i,"depot_no")
	scvcod	= dw_list.GetItemString(i,"cvcod")
	sbgbn		= dw_list.GetItemString(i,"bgbn")
	spinbr	= dw_list.GetItemString(i,"pinbr")
	
	IF sItem = "" OR IsNull(sItem) THEN
		f_message_chk(30,'[품번]')
		dw_list.SetColumn("itnbr")
		dw_list.scrolltorow(i)
		dw_list.setfocus()
		Return -1
	END IF
//
//	IF sbgbn = '2' And (spinbr = "" OR IsNull(spinbr) ) THEN
//		f_message_chk(30,'[생산품번]')
//		dw_list.SetColumn("pinbr")
//		dw_list.scrolltorow(i)
//		dw_list.setfocus()
//		Return -1
//	END IF
	
	IF dQty <= 0 OR IsNull(dQty) THEN
		f_message_chk(30,'[수량]')
		dw_list.SetColumn("faqty")
		dw_list.scrolltorow(i)
		dw_list.setfocus()
		Return -1
	END IF

	IF shcode = "" OR IsNull(shcode) THEN
		f_message_chk(30,'[불량현상]')
		dw_list.SetColumn("hcode")
		dw_list.scrolltorow(i)
		dw_list.setfocus()
		Return -1
	END IF

	IF sdepot = "" OR IsNull(sdepot) THEN
		f_message_chk(30,'[발생창고]')
		dw_list.SetColumn("depot_no")
		dw_list.scrolltorow(i)
		dw_list.setfocus()
		Return -1
	END IF
	
//	IF scvcod = "" OR IsNull(scvcod) THEN
//		f_message_chk(30,'[공급업체]')
//		dw_list.SetColumn("cvcod")
//		dw_list.scrolltorow(i)
//		dw_list.setfocus()
//		Return -1
//	END IF
Next

Return 1

end function

public function integer wf_create_shpfat_qa_sum ();long		lseq, lrow, ii, ix
string	scrjpno, sdate, scvcod, sitnbr, sKey
Dec      dPrc, dAmt

sdate = trim(dw_detail.getitemstring(1,'idate'))
scvcod = trim(dw_detail.getitemstring(1,'vendor'))

//////////////////////////////////////////////////////////////////////////////////
//lseq = sqlca.fun_junpyo(gs_sabu,sdate,'Q2')
//if lseq = -1 then 
//	rollback;
//	f_message_chk(51, '')
//	return -1
//end if
//commit;
//scrjpno = 'CR' + mid(sdate,3) + string(lseq,'0000')


FOR lrow = 1 TO dw_list.rowcount()
//	If dw_list.GetItemSTring(lrow, 'crjpno') > '' Then Continue
	
	ii++
//	dw_list.setitem(lrow,'sabu',gs_saupj)
//	dw_list.setitem(lrow,'crsjpno',scrjpno+string(ii,'000'))
//	dw_list.setitem(lrow,'cvcod',scvcod)
	dw_list.setitem(lrow,'cdate',sdate)
	dw_list.setitem(lrow,'bjukhap','2')	// 수정불합격처리-임의등록 ('2')
//	dw_list.setitem(lrow,'crjpno',scrjpno)
	
	sCvcod = Trim(dw_list.GetItemString(lrow, 'cvcod'))
	sItnbr = Trim(dw_list.GetItemString(lrow, 'itnbr'))
//	SELECT fun_danmst_danga10(:sdate,:scvcod,:sItnbr,'.') into :dprc from dual;
//	If IsNull(dPrc) Then dPrc = 0
//	
//	dw_list.setitem(lrow,'ioprc',dPrc)
//	dw_list.setitem(lrow,'ioamt',round(dPrc * dw_list.GetItemNumber(lrow, 'faqty'),0))
	
	dw_list.setitem(lrow,'empno',gs_empno)
	dw_list.setitem(lrow,'deptcode',gs_dept)
	sCrjpno = Trim(dw_list.GetItemString(lrow, 'crsjpno'))
	dAmt = 0
	For ix = 1 To dw_soje.RowCount()

		sKey = dw_soje.GetItemString(ix, 'crsjpno')
      if sKey = sCrjpno then
		   damt = dAmt + dw_soje.GetItemNumber(ix, 'ioamt')
		End if
	Next
	dw_list.setitem(lrow,'ioamt',dAmt)

NEXT

return 1
end function

public subroutine wf_depot_protect (long arg_row);string	syn='N', sitnbr, spinbr, sdepot

sitnbr = dw_list.getitemstring(arg_row,'itnbr')

///* 제품창고 */
//select min(cvcod) into :sdepot from vndmst
// where cvgu = '5' and soguan = '1' and ipjogun = :gs_saupj ;
// 
//select a.itnbryd 
//  into :spinbr 
//  from item_rel a, itemas b
// where a.itnbr = :sitnbr 
//	and a.itnbryd = b.itnbr ;
//
//if sqlca.sqlcode = 0 then 
//	dw_list.setitem(arg_row,'depot_no',sdepot)
//	dw_list.setitem(arg_row,'protect','Y')
//	return
//end if
//
//select a.itnbrmd 
//  into :spinbr 
//  from item_rel a, itemas b
// where a.itnbr = :sitnbr 
//	and a.itnbrmd = b.itnbr ;
//
//if sqlca.sqlcode = 0 then 
//	dw_list.setitem(arg_row,'depot_no',sdepot)
//	dw_list.setitem(arg_row,'protect','Y')
//	return
//end if

// 소재불량 창고는 생산창고
dw_list.setitem(arg_row,'depot_no','Z30')
dw_list.setitem(arg_row,'protect','N')
end subroutine

public function integer wf_jepum_yn (long arg_row);string	sitnbr, spinbr

sitnbr = dw_list.getitemstring(arg_row,'itnbr')

/* 제품창고 */
select a.itnbryd 
  into :spinbr 
  from item_rel a, itemas b
 where a.itnbr = :sitnbr 
	and a.itnbryd = b.itnbr ;

if sqlca.sqlcode = 0 then
	return 1
end if

select a.itnbrmd 
  into :spinbr 
  from item_rel a, itemas b
 where a.itnbr = :sitnbr 
	and a.itnbrmd = b.itnbr ;

if sqlca.sqlcode = 0 then 
	return 1
end if

return -1
end function

public function integer wf_set_soje (integer ar_row, string ar_gub);string	sitnbr, sCrsjpno, sDate, sCinbr, sIttyp
Dec      dQty
Long     ix, nrow
String sCvcod, sTuncu ,sCvnas
Decimal {5} dUnprc,dWunprc

If dw_detail.AcceptText() <> 1 Then Return 0
If dw_list.AcceptText() <> 1 Then Return 0

sDate		= dw_detail.GetItemString(1, 'idate')
sittyp   = dw_list.getitemstring(ar_row,'ittyp')
sitnbr   = dw_list.getitemstring(ar_row,'itnbr')
sCrsjpno = dw_list.getitemstring(ar_row,'crsjpno')
dQty     = dw_list.getitemnumber(ar_row,'faqty')

// 소재내역 생성
If ar_gub = 'Y' Then
	DECLARE erp_create_pstruc_to_soje PROCEDURE FOR erp_create_pstruc_to_soje(:sitnbr);
	EXECUTE erp_create_pstruc_to_soje;
	
	dw_hidden.Retrieve(sItnbr)
	
	dw_soje.SetFilter("crsjpno = '"+sCrsjpno+"'")
	dw_soje.filter()
	dw_soje.RowsMove(1, dw_soje.RowCount(), Primary!,dw_soje, 9999, Delete!)

	// Bom 내역이 존재할 경우
	If sIttyp = '1' Or sIttyp = '2' Or sIttyp = '8' Then
		For ix = 1 To dw_hidden.RowCount()
			nRow = dw_soje.InsertRow(0)
			dw_soje.SetItem(nRow, 'sabu', gs_saupj)
			dw_soje.SetItem(nRow, 'crsjpno', sCrsjpno)
			dw_soje.SetItem(nRow, 'cdate', sdate)
			dw_soje.SetItem(nRow, 'pinbr', sitnbr)
			dw_soje.SetItem(nRow, 'cinbr', dw_hidden.GetItemString(ix, 'itnbr'))
			dw_soje.SetItem(nRow, 'itemas_itdsc', dw_hidden.GetItemString(ix, 'itemas_itdsc'))
			dw_soje.SetItem(nRow, 'itemas_ispec', dw_hidden.GetItemString(ix, 'itemas_ispec'))
			dw_soje.SetItem(nRow, 'faqty', dQty * dw_hidden.GetItemNumber(ix, 'qtypr'))
			dw_soje.SetItem(nRow, 'ioprc', 0)
			dw_soje.SetItem(nRow, 'ioamt', 0)
			dw_soje.SetItem(nRow, 'qtypr', dw_hidden.GetItemNumber(ix, 'qtypr'))
		Next	
	Else
		nRow = dw_soje.InsertRow(0)
		dw_soje.SetItem(nRow, 'sabu', gs_saupj)
		dw_soje.SetItem(nRow, 'crsjpno', sCrsjpno)
		dw_soje.SetItem(nRow, 'cdate', sdate)
		dw_soje.SetItem(nRow, 'pinbr', sitnbr)
		dw_soje.SetItem(nRow, 'cinbr', sitnbr)
		dw_soje.SetItem(nRow, 'itemas_itdsc', dw_list.GetItemString(ar_row, 'itemas_itdsc'))
		dw_soje.SetItem(nRow, 'itemas_ispec', dw_list.GetItemString(ar_row, 'itemas_ispec'))
		dw_soje.SetItem(nRow, 'faqty', dQty )
		dw_soje.SetItem(nRow, 'ioprc', 0)
		dw_soje.SetItem(nRow, 'ioamt', 0)
		dw_soje.SetItem(nRow, 'qtypr', 1)	
		
	End If
	
	For ix = 1 To dw_soje.RowCount()
		// 우선거래처 및 단가 셋팅

		sCinbr = dw_soje.GetItemString(ix, 'cinbr')
		sTuncu = 'WON'
		f_buy_unprc(sCinbr, '.', '9999', sCvcod, sCvnas, dUnprc, sTuncu)
		If IsNull(dUnprc) Then dunprc = 0
		
		select ittyp into :sittyp from itemas where itnbr = :scinbr;
		
		if sIttyp = 'A' then
			select ERP_CALC_PSTRUC(:sCinbr,1,:sDate,'1','Y') into :dWunprc
			  from dual;
			If IsNull(dWunprc) Then dWunprc = 0
		   dUnprc = dUnprc + dWunprc
		End if
			  
		
		dw_soje.SetItem(ix, 'cvcod', sCvcod)
		dw_soje.SetItem(ix, 'ioprc', dUnprc)
		dw_soje.SetItem(ix, 'ioamt', dUnprc * dw_soje.GetItemNumber(ix, 'faqty'))
	Next
End If

// 수량조정
If ar_gub = 'N' Then
	dw_soje.SetFilter("crsjpno = '"+sCrsjpno+"'")
	dw_soje.filter()
	
	For ix = 1 To dw_soje.RowCount()
		dw_soje.SetItem(ix, 'faqty', dQty * dw_soje.GetItemNumber(ix, 'qtypr'))
		dw_soje.SetItem(ix, 'ioamt', dw_soje.GetItemNumber(ix, 'ioprc') * dw_soje.GetItemNumber(ix, 'faqty'))
	Next
End If

return 1
end function

public function integer wf_set_filter (integer ar_row);String sCrsjpno, sBgbn

If dw_list.AcceptText() <> 1 Then Return 0
If ar_row <= 0 then return 0
If ar_row > dw_list.RowCount() then return 0

sCrsjpno = dw_list.GetItemString(ar_row, 'crsjpno')
sBgbn    = dw_list.GetItemString(ar_row, 'bgbn')

dw_soje.SetFilter("crsjpno = '"+sCrsjpno+"'")
dw_soje.filter()

if sBgbn = '2' then
	dw_soje.Modify("faqty.Protect=1")
	dw_soje.Modify("chk.Protect=1")
else
	dw_soje.Modify("faqty.Protect=0")
	dw_soje.Modify("chk.Protect=0")
End if
Return 1

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


///////////////////////////////////////////////////////////////////////////////////
// datawindow initial value
dw_hidden_2.settransobject(sqlca)
dw_hidden.settransobject(sqlca)
dw_detail.settransobject(sqlca)
dw_soje.settransobject(sqlca)
dw_detail.insertrow(0)

is_Date = f_Today()
if gs_dept <> '51' then
	cb_3.Enabled = False
	cb_4.Enabled = False
End if
// commandbutton function
rb_insert.checked = true
rb_insert.TriggerEvent(clicked!)
end event

on w_qa02_00051.create
this.st_4=create st_4
this.st_3=create st_3
this.dw_hidden_2=create dw_hidden_2
this.cb_5=create cb_5
this.cb_4=create cb_4
this.cb_3=create cb_3
this.cb_2=create cb_2
this.dw_soje=create dw_soje
this.dw_hidden=create dw_hidden
this.p_1=create p_1
this.cb_1=create cb_1
this.pb_1=create pb_1
this.p_ins=create p_ins
this.p_exit=create p_exit
this.p_can=create p_can
this.p_del=create p_del
this.p_mod=create p_mod
this.p_inq=create p_inq
this.st_2=create st_2
this.st_1=create st_1
this.rb_2=create rb_2
this.rb_1=create rb_1
this.cb_delete=create cb_delete
this.cb_cancel=create cb_cancel
this.rb_delete=create rb_delete
this.rb_insert=create rb_insert
this.dw_imhist=create dw_imhist
this.dw_detail=create dw_detail
this.cb_save=create cb_save
this.cb_exit=create cb_exit
this.cb_retrieve=create cb_retrieve
this.dw_list=create dw_list
this.gb_1=create gb_1
this.rr_1=create rr_1
this.rr_3=create rr_3
this.rr_4=create rr_4
this.rr_5=create rr_5
this.Control[]={this.st_4,&
this.st_3,&
this.dw_hidden_2,&
this.cb_5,&
this.cb_4,&
this.cb_3,&
this.cb_2,&
this.dw_soje,&
this.dw_hidden,&
this.p_1,&
this.cb_1,&
this.pb_1,&
this.p_ins,&
this.p_exit,&
this.p_can,&
this.p_del,&
this.p_mod,&
this.p_inq,&
this.st_2,&
this.st_1,&
this.rb_2,&
this.rb_1,&
this.cb_delete,&
this.cb_cancel,&
this.rb_delete,&
this.rb_insert,&
this.dw_imhist,&
this.dw_detail,&
this.cb_save,&
this.cb_exit,&
this.cb_retrieve,&
this.dw_list,&
this.gb_1,&
this.rr_1,&
this.rr_3,&
this.rr_4,&
this.rr_5}
end on

on w_qa02_00051.destroy
destroy(this.st_4)
destroy(this.st_3)
destroy(this.dw_hidden_2)
destroy(this.cb_5)
destroy(this.cb_4)
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.dw_soje)
destroy(this.dw_hidden)
destroy(this.p_1)
destroy(this.cb_1)
destroy(this.pb_1)
destroy(this.p_ins)
destroy(this.p_exit)
destroy(this.p_can)
destroy(this.p_del)
destroy(this.p_mod)
destroy(this.p_inq)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.cb_delete)
destroy(this.cb_cancel)
destroy(this.rb_delete)
destroy(this.rb_insert)
destroy(this.dw_imhist)
destroy(this.dw_detail)
destroy(this.cb_save)
destroy(this.cb_exit)
destroy(this.cb_retrieve)
destroy(this.dw_list)
destroy(this.gb_1)
destroy(this.rr_1)
destroy(this.rr_3)
destroy(this.rr_4)
destroy(this.rr_5)
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

type st_4 from statictext within w_qa02_00051
integer x = 1874
integer y = 136
integer width = 677
integer height = 48
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 32106727
string text = "필히 발생 하세요]"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within w_qa02_00051
integer x = 1833
integer y = 76
integer width = 704
integer height = 48
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 32106727
string text = "[완료 후에는 폐기전표를"
boolean focusrectangle = false
end type

type dw_hidden_2 from datawindow within w_qa02_00051
boolean visible = false
integer x = 2953
integer y = 2328
integer width = 686
integer height = 400
integer taborder = 100
string title = "none"
string dataobject = "d_qa02_00050_popup01_2"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_5 from commandbutton within w_qa02_00051
integer x = 1056
integer y = 40
integer width = 489
integer height = 136
integer taborder = 40
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "BOM 조회(단품)"
end type

event clicked;string sopt, scvcod, sitem, stuncu, scvnas, saccod, ls_saupj, sdepot
int    k, iRow
Decimal {5} ddata, djego
Long		ll_row, lseq
string ls_vnd, scrjpno, sdate

IF dw_detail.AcceptText() = -1	THEN	RETURN

sDate = trim(dw_detail.GetItemString(1,"idate"))
IF sDate ="" OR IsNull(sDate) THEN
	f_message_chk(30,'[처리일자]')
	dw_detail.SetColumn("idate")
	dw_detail.SetFocus()
	Return 
END IF

ls_Saupj 	= gs_saupj
sdepot      = 'Z30'

SetNull(gs_gubun)
Open(w_qa02_00050_popup01)
if Isnull(gs_code) or Trim(gs_code) = "" then return

SetPointer(HourGlass!)

dw_hidden_2.reset()
dw_hidden_2.ImportClipboard()

if dw_hidden_2.rowcount() >0 then
	lseq = sqlca.fun_junpyo(gs_sabu,sdate,'Q2')
	if lseq = -1 then 
		rollback;
		f_message_chk(51, '')
		return -1
	end if
	commit;
	scrjpno = 'CR' + mid(sdate,3) + string(lseq,'0000')
End if


FOR k=1 TO dw_hidden_2.rowcount()
	sopt = dw_hidden_2.getitemstring(k, 'opt')
	if sopt = 'Y' then 

		iRow = dw_list.insertrow(0)
		
		// key Setting
		dw_list.setitem(irow,'sabu',gs_saupj)
		dw_list.setitem(irow,'crsjpno',scrjpno+string(irow,'000'))
			
		sitem = 	dw_hidden_2.getitemstring(k, 'itnbr' )
		dw_list.setitem(irow, 'itnbr', sitem)
		
		post wf_depot_protect(irow)
		
		post wf_set_soje(irow, 'Y')
		
		dw_list.setitem(irow, 'itemas_itdsc', dw_hidden_2.getitemstring(k, 'itemas_itdsc' ))
		dw_list.SetItem(iRow, "faqty", 0)
		
		dw_list.SetItem(iRow, "chk_flag", 'N')
	end if
NEXT
dw_hidden_2.reset()

dw_list.ScrollToRow(iRow)
dw_list.setrow(iRow)
dw_list.SetColumn("faqty")
dw_list.SetFocus()
end event

type cb_4 from commandbutton within w_qa02_00051
integer x = 3099
integer y = 40
integer width = 325
integer height = 116
integer taborder = 30
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "전표삭제"
end type

event clicked;string	sJpno,sBalno,sBlno,	sNull,sDate
long		lRow, lRowHist, lRowOut, nrowcnt
long 		dSeq, dOutSeq, ix, iy
String 	sBalJpno
Dec		dBalseq

SetNull(sNull)

if gs_dept <> '51' then return

dw_detail.AcceptText()
dw_list.AcceptText()

sDate  = trim(dw_detail.GetItemString(1, "idate"))				// 처리일자
IF IsNull(sdate)	or   trim(sdate) = ''	THEN
	f_message_chk(30,'[처리일자]')
   return -1
END IF	

if dw_list.GetRow() < 1 then return
iy = 0
FOR	lRow = 1	TO	dw_list.RowCount()
		if dw_list.getitemstring(lrow, "bgbn") = '2' and Not isNull(dw_list.getitemstring(lrow, "jpno")) then
			dw_list.SetItem(lRow, "jpno",	sNull)
			iy = iy + 1
      end if
Next

if iy > 0 then
	IF dw_list.Update(True, False) <> 1 THEN
		ROLLBACK;
		messagebox('확인','수불 자료 삭제 실패!!!')
		Return
	END IF
   commit;	
	messagebox('확인','수불 자료 삭제 완료!!!')
	p_can.triggerevent(clicked!)
Else
	messagebox('확인','삭제할 자료가 없습니다!!!')
End if


end event

type cb_3 from commandbutton within w_qa02_00051
integer x = 2752
integer y = 40
integer width = 325
integer height = 116
integer taborder = 30
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "폐기전표"
end type

event clicked;string	sJpno,sBalno,sBlno,	sNull,sDate
long		lRow, lRowHist, lRowOut, nrowcnt
long 		dSeq, dOutSeq, ix, iy
String 	sBalJpno
Dec		dBalseq

SetNull(sNull)

if gs_dept <> '51' then return

dw_detail.AcceptText()
dw_list.AcceptText()

sDate  = trim(dw_detail.GetItemString(1, "idate"))				// 처리일자
IF IsNull(sdate)	or   trim(sdate) = ''	THEN
	f_message_chk(30,'[처리일자]')
   return -1
END IF	
if dw_list.GetRow() < 1 then return

dSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'C0')

IF dSeq < 1		THEN
	ROLLBACK;
	f_message_chk(51,'[처리번호]')
	RETURN -1
END IF
sJpno  = sDate + string(dSeq, "0000")
iy = 0
FOR	lRow = 1	TO	dw_list.RowCount()
		if dw_list.getitemstring(lrow, "bgbn") = '2' and isNull(dw_list.getitemstring(lrow, "jpno")) then
			dw_list.SetItem(lRow, "jpno",	sJpno)	
			iy = iy + 1
      end if
Next

if iy > 0 then
	IF dw_list.Update(True, False) <> 1 THEN
		ROLLBACK;
		messagebox('확인','수불 자료 저장 실패!!!')
		Return
	END IF
	COMMIT;
	messagebox('확인','수불 자료 저장 완료!!!')
	
	p_can.triggerevent(clicked!)
Else
	messagebox('확인','처리할 자료가 없습니다!!!')
	
End if
end event

type cb_2 from commandbutton within w_qa02_00051
integer x = 4018
integer y = 1688
integer width = 416
integer height = 144
integer taborder = 40
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "단품 삭제"
end type

event clicked;Long ix , nRow

nrow = dw_soje.RowCount()

For ix = nRow To 1 Step -1
	If dw_soje.getitemstring(ix, 'chk') = 'Y' Then
		dw_soje.DeleteRow(ix)
	End If
Next
end event

type dw_soje from u_key_enter within w_qa02_00051
integer x = 37
integer y = 1484
integer width = 3895
integer height = 788
integer taborder = 30
boolean titlebar = true
string title = "불량 단품 내역"
string dataobject = "d_qa02_00051_c"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event itemchanged;call super::itemchanged;Long nrow

nrow = getrow()
If nrow <= 0 then return

Choose case getcolumnName()
	Case 'faqty'
		dw_soje.SetItem(nrow, 'ioamt', dw_soje.GetItemNumber(nrow, 'ioprc') * Dec(GetText()))
End Choose
end event

type dw_hidden from datawindow within w_qa02_00051
boolean visible = false
integer x = 1019
integer y = 2380
integer width = 1047
integer height = 280
integer taborder = 90
string title = "none"
string dataobject = "d_pstruc_popup_1_1"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type p_1 from uo_picture within w_qa02_00051
boolean visible = false
integer x = 901
integer y = 24
integer width = 306
boolean originalsize = true
string picturename = "C:\erpman\image\발주처품목선택_up.gif"
end type

event clicked;call super::clicked;//발주처 품목선택	-버턴명
string sopt, scvcod, sitem, stuncu, scvnas, saccod, ls_saupj, sdepot
int    k, iRow
Decimal {5} ddata, djego

IF dw_detail.AcceptText() = -1	THEN	RETURN

ls_Saupj 	= gs_saupj
sCvcod 	   = dw_detail.getitemstring(1, "vendor")
//gs_gubun    = dw_1.getitemstring(1, "bal_empno")
sdepot      = 'Z30'

IF isnull(sCvcod) or sCvcod = "" 	THEN
	f_message_chk(30,'[발주처]')
	dw_detail.SetColumn("vendor")
	dw_detail.SetFocus()
	RETURN
END IF

  SELECT "VNDMST"."CVNAS2"  
    INTO :gs_codename 
    FROM "VNDMST"  
   WHERE "VNDMST"."CVCOD" = :scvcod   ;

gs_code = sCvcod
open(w_vnditem_popup2)
if Isnull(gs_code) or Trim(gs_code) = "" then return

SetPointer(HourGlass!)

dw_hidden.reset()
dw_hidden.ImportClipboard()

FOR k=1 TO dw_hidden.rowcount()
	sopt = dw_hidden.getitemstring(k, 'opt')
	if 	sopt = 'Y' then 
		iRow = dw_list.insertrow(0)

//		dw_list.setitem(iRow, "sabu", gs_sabu)
//		dw_list.setitem(iRow, "saupj", ls_saupj)  //-- 사업장.

     	sitem = 	dw_hidden.getitemstring(k, 'poblkt_itnbr' )
		dw_list.setitem(irow, 'itnbr', sitem)
		dw_list.setitem(irow, 'itemas_itdsc', dw_hidden.getitemstring(k, 'itemas_itdsc' ))
//		dw_insert.setitem(irow, 'itemas_ispec', dw_hidden.getitemstring(k, 'itemas_ispec' ))
		

		dw_list.SetItem(iRow, "depot_no", sdepot)
	end if	
NEXT
dw_hidden.reset()

dw_list.ScrollToRow(iRow)
dw_list.setrow(iRow)
dw_list.SetColumn("faqty")
dw_list.SetFocus()
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\발주처품목선택_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\발주처품목선택_up.gif"
end event

type cb_1 from commandbutton within w_qa02_00051
integer x = 4018
integer y = 1492
integer width = 416
integer height = 144
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "BOM 조회"
end type

event clicked;//발주처 품목선택	-버턴명
string sopt, scvcod, sitem, stuncu, scvnas, saccod, ls_saupj, sdepot
int    k, iRow
Decimal {5} ddata, djego, dqty
Long ix, nrow
string scrsjpno, sdate, sitnbr, sCinbr
dec dUnprc

IF dw_detail.AcceptText() = -1	THEN	RETURN

iRow = dw_list.GetSelectedRow(0)
IF iRow <= 0	THEN	RETURN

ls_Saupj 	= gs_saupj
sdepot      = 'Z30'
sDate			= dw_detail.GetItemString(1, 'idate')
sCrsjpno    = dw_list.GetItemString(iRow, 'crsjpno')
dQty	      = dw_list.GetItemNumber(iRow, 'faqty')
sitnbr		= dw_list.GetItemString(iRow, 'itnbr')

gs_gubun    = dw_list.GetItemString(iRow, 'itnbr')
If IsNull(gs_gubun) Or gs_gubun = '' Then Return

Open(w_pstruc_popup_1)
if Isnull(gs_code) or Trim(gs_code) = "" then return

SetPointer(HourGlass!)

dw_hidden.reset()
dw_hidden.ImportClipboard()

FOR ix =1 TO dw_hidden.rowcount()
	sopt = dw_hidden.getitemstring(ix, 'opt')
	if sopt = 'Y' then 
		nRow = dw_soje.InsertRow(0)
		dw_soje.SetItem(nRow, 'sabu',    gs_saupj)
		dw_soje.SetItem(nRow, 'crsjpno', sCrsjpno)
		dw_soje.SetItem(nRow, 'cdate',   sdate)
		dw_soje.SetItem(nRow, 'pinbr',   sitnbr)
		dw_soje.SetItem(nRow, 'cinbr',   dw_hidden.GetItemString(ix, 'itnbr'))
		dw_soje.SetItem(nRow, 'itemas_itdsc', dw_hidden.GetItemString(ix, 'itemas_itdsc'))
		dw_soje.SetItem(nRow, 'itemas_ispec', dw_hidden.GetItemString(ix, 'itemas_ispec'))
		dw_soje.SetItem(nRow, 'faqty', dQty * dw_hidden.GetItemNumber(ix, 'qtypr'))
		dw_soje.SetItem(nRow, 'qtypr', dw_hidden.GetItemNumber(ix, 'qtypr'))
		
		// 우선거래처 및 단가 셋팅

		sCinbr = dw_hidden.GetItemString(ix, 'itnbr')
		sTuncu = 'WON'
		f_buy_unprc(sCinbr, '.', '9999', sCvcod, sCvnas, dUnprc, sTuncu)
		if isNull(dUnprc) then dunprc = 0
		dw_soje.SetItem(ix, 'cvcod', sCvcod)
		dw_soje.SetItem(ix, 'ioprc', dUnprc)
		dw_soje.SetItem(ix, 'ioamt', dUnprc * dw_soje.GetItemNumber(ix, 'faqty'))
	end if
NEXT

dw_hidden.reset()

dw_list.ScrollToRow(iRow)
dw_list.setrow(iRow)
dw_list.SetColumn("faqty")
dw_list.SetFocus()
end event

type pb_1 from u_pb_cal within w_qa02_00051
integer x = 649
integer y = 64
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;
//해당 컬럼 지정
dw_detail.SetColumn('idate')
//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 
//Gs Code에 지정된 날짜 값 지정
dw_detail.SetItem(1, 'idate', gs_code)	

p_inq.TriggerEvent(Clicked!)

end event

type p_ins from picture within w_qa02_00051
integer x = 3863
integer y = 28
integer width = 178
integer height = 144
string pointer = "HyperLink!"
string picturename = "C:\erpman\image\추가_up.gif"
boolean focusrectangle = false
end type

event clicked;Long		ll_row, lseq
string ls_vnd, scrjpno, sdate

If ic_status = '2' Then 
	MessageBox('확인','등록상태일때 추가 가능합니다.')
	Return
End If

sDate = trim(dw_detail.GetItemString(1,"idate"))
IF sDate ="" OR IsNull(sDate) THEN
	f_message_chk(30,'[처리일자]')
	dw_detail.SetColumn("idate")
	dw_detail.SetFocus()
	Return 
END IF

lseq = sqlca.fun_junpyo(gs_sabu,sdate,'Q2')
if lseq = -1 then 
	rollback;
	f_message_chk(51, '')
	return -1
end if
commit;
scrjpno = 'CR' + mid(sdate,3) + string(lseq,'0000')

ll_row = dw_list.InsertRow(0)	

// key Setting
dw_list.setitem(ll_row,'sabu',gs_saupj)
dw_list.setitem(ll_row,'crsjpno',scrjpno+string(ll_row,'000'))
dw_list.setitem(ll_row,'crjpno',scrjpno)
	
dw_list.ScrollToRow(ll_row)
dw_list.SetColumn(1)
dw_list.SetFocus()
if gs_dept = '51' then
//	dw_list.Modify("bgbn.Protect=0")
else
	dw_list.Modify("bgbn.Protect=1")
End if
end event

type p_exit from uo_picture within w_qa02_00051
integer x = 4384
integer y = 28
integer width = 178
integer taborder = 80
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
//IF wf_warndataloss("종료") = -1 THEN  	RETURN

close(parent)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type p_can from uo_picture within w_qa02_00051
integer x = 4210
integer y = 28
integer width = 178
integer taborder = 70
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event clicked;call super::clicked;rb_insert.checked = true
rb_insert.TriggerEvent(clicked!)


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

type p_del from uo_picture within w_qa02_00051
integer x = 4037
integer y = 28
integer width = 178
integer taborder = 60
string pointer = "C:\erpman\cur\delete.cur"
string picturename = "C:\erpman\image\삭제_up.gif"
end type

event clicked;Integer 	lrow, iCurRow
Long     lcnt
string	soutjpno, scrjpno, sCrsjpno
dwItemStatus l_status

		  
If dw_list.Accepttext() <> 1 Then Return
if dw_list.rowcount() < 1 then return

if dw_list.find("chk_flag='Y'",1,dw_list.rowcount()) < 1 then
	messagebox('확인','삭제할 자료를 선택하세요!!!')
	return
end if
	
if f_msg_delete() = -1 then return

lcnt = dw_list.rowcount()
FOR lrow = lcnt TO 1 STEP -1
	if dw_list.getitemstring(lrow,'chk_flag') = 'N' then continue
	
	soutjpno = dw_list.getitemstring(lrow,'outjpno')
	if isnull(soutjpno) or soutjpno = '' then
	else
		messagebox('확인','반품처리된 자료는 삭제불가!!!')
		dw_list.setitem(lrow,'chk_flag','N')
		return
	end if

	sCrsjpno = dw_list.getitemstring(lrow,'crsjpno')
	dw_soje.SetFilter("crsjpno = '"+sCrsjpno+"'")
	dw_soje.filter()
	
	l_status = dw_list.GetItemStatus(lrow, 0, Primary!)
	If l_status = New! Or l_status = NewModified! Then
		dw_list.RowsDiscard(lrow, lrow, Primary!)
		dw_soje.RowsDiscard(1, dw_soje.RowCount(), Primary!)
	Else
		dw_list.DeleteRow(lrow)
		dw_soje.RowsMove(1, dw_soje.RowCount(), Primary!,dw_soje, 9999, Delete!)
	End If
NEXT

/* 단품 불량 내역(상세내역) 삭제는 trigger에서 */
IF dw_list.Update(True, False) <> 1 THEN
	ROLLBACK;
	messagebox('확인','자료 삭제 실패!!!')
	Return
END IF

dw_soje.SetFilter("")
dw_soje.filter()
IF dw_soje.Update(True, False) <> 1 THEN
	ROLLBACK;
	messagebox('확인','자료 삭제 실패!!!')
	Return
END IF

COMMIT;

dw_list.ResetUpdate()
dw_soje.ResetUpdate()

dw_soje.SetFilter("crsjpno = ''")
dw_soje.filter()

If dw_list.rowcount() < 1 Then
	p_can.TriggerEvent(Clicked!)	
End If

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\삭제_up.gif"
end event

type p_mod from uo_picture within w_qa02_00051
integer x = 3689
integer y = 28
integer width = 178
integer taborder = 50
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event clicked;call super::clicked;If dw_list.RowCount() < 1 Then Return
if dw_list.accepttext() = -1 then return
if dw_soje.accepttext() = -1 then return
if dw_detail.accepttext() = -1 then return
if wf_checkrequiredfield() = -1 then return
If f_msg_update() < 1 Then Return

setpointer(hourglass!)
dw_soje.SetFilter("")
dw_soje.Filter()
if wf_create_shpfat_qa_sum() = -1 then return

IF dw_list.Update(True, False) <> 1 THEN
	ROLLBACK;
	messagebox('확인','자료 저장 실패!!!')
	Return
END IF

IF dw_soje.Update(True, False) <> 1 THEN
	ROLLBACK;
	messagebox('확인','자료 저장 실패!!!')
	Return
END IF

COMMIT;

dw_list.ResetUpdate()
dw_soje.ResetUpdate()
dw_soje.Reset()
dw_soje.SetFilter("crsjpno = ''")
dw_soje.filter()

messagebox('확인','자료를 저장하였습니다.')

p_inq.TriggerEvent(Clicked!)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

type p_inq from uo_picture within w_qa02_00051
integer x = 3515
integer y = 28
integer width = 178
integer taborder = 10
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event clicked;call super::clicked;String  sIoJpNo, sDate

If dw_detail.AcceptText() <> 1 Then	Return

//If ic_status = '1' Then 
//	MessageBox('확인','등록 상태에서는 조회 불가능 합니다.')
//	Return
//End If

//sIoJpNo  = trim(dw_detail.GetItemString(1,"jpno"))
//IF sIoJpNo ="" OR IsNull(sIoJpNo) THEN
//	f_message_chk(30,'[전표번호]')
//	dw_detail.SetColumn("jpno")
//	dw_detail.SetFocus()
//	Return 
//END IF

sDate = trim(dw_detail.GetItemString(1,"idate"))
IF sDate ="" OR IsNull(sDate) THEN
	f_message_chk(30,'[처리일자]')
	dw_detail.SetColumn("idate")
	dw_detail.SetFocus()
	Return 
END IF

dw_soje.Reset()
If dw_list.Retrieve(gs_saupj, sDate) > 0 THEN
   dw_list.SetFocus()
	dw_detail.Enabled = False
	dw_soje.Retrieve(gs_saupj, sDate) 
ELSE
//	f_message_chk(50,'')
	dw_detail.SetColumn("idate")
	dw_detail.SetFocus()
	Return
END IF

if gs_dept = '51' then
//	dw_list.Modify("bgbn.Protect=0")
else
	dw_list.Modify("bgbn.Protect=1")
End if
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조회_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조회_up.gif"
end event

type st_2 from statictext within w_qa02_00051
boolean visible = false
integer x = 1883
integer y = 2648
integer width = 942
integer height = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
boolean enabled = false
string text = "하시면 상세입고내역이 조회됩니다."
boolean focusrectangle = false
end type

type st_1 from statictext within w_qa02_00051
boolean visible = false
integer x = 850
integer y = 2648
integer width = 1001
integer height = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
boolean enabled = false
string text = "◈ 아래에 조회된 내역을 DOUBLE CLICK"
boolean focusrectangle = false
end type

type rb_2 from radiobutton within w_qa02_00051
boolean visible = false
integer x = 434
integer y = 2640
integer width = 238
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "합계"
end type

event clicked;
ic_status = '1'	// 등록

dw_list.DataObject = 'd_imt_04001'
dw_list.SetTransObject(sqlca)

//IF f_change_name('1') = 'Y' then 
//	dw_list.object.ispec_t.text = is_pspec
//	dw_list.object.jijil_t.text = is_jijil
//END IF

wf_Initial()
end event

type rb_1 from radiobutton within w_qa02_00051
boolean visible = false
integer x = 155
integer y = 2640
integer width = 238
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "개별"
boolean checked = true
end type

event clicked;ic_status = '1'	// 등록

dw_list.DataObject = 'd_imt_04003'
dw_list.SetTransObject(sqlca)

//IF f_change_name('1') = 'Y' then 
//	dw_list.object.ispec_t.text = is_pspec
//	dw_list.object.jijil_t.text = is_jijil
//END IF

wf_Initial()
end event

type cb_delete from commandbutton within w_qa02_00051
boolean visible = false
integer x = 1490
integer y = 2452
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

type cb_cancel from commandbutton within w_qa02_00051
boolean visible = false
integer x = 1902
integer y = 2448
integer width = 347
integer height = 108
integer taborder = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "취소(&C)"
end type

event clicked;
rb_insert.checked = true
rb_1.checked = true

rb_insert.TriggerEvent("clicked")


end event

type rb_delete from radiobutton within w_qa02_00051
boolean visible = false
integer x = 1125
integer y = 108
integer width = 219
integer height = 68
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

wf_Initial()
end event

type rb_insert from radiobutton within w_qa02_00051
boolean visible = false
integer x = 1125
integer y = 40
integer width = 219
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

event clicked;ic_status = '1'	// 등록

wf_Initial()
end event

type dw_imhist from datawindow within w_qa02_00051
boolean visible = false
integer x = 96
integer y = 2364
integer width = 494
integer height = 212
boolean titlebar = true
string title = "입출고HISTORY"
string dataobject = "d_pdt_imhist"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
end type

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

type dw_detail from datawindow within w_qa02_00051
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 27
integer y = 56
integer width = 750
integer height = 108
integer taborder = 10
string dataobject = "d_qa02_00051_0"
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

event rbuttondown;gs_gubun = ''
gs_code  = ''
gs_codename = ''

// 전표번호
IF this.GetColumnName() = 'jpno'	THEN

	Open(w_qa02_00051_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1, "jpno",gs_code)
	this.TriggerEvent("itemchanged")
	
ELSEIF this.GetColumnName() = 'vendor'	THEN
   gs_gubun = '1' 
	Open(w_vndmst_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1, "vendor",		gs_code)
	SetItem(1, "vendorname",gs_codename)
	
END IF


end event

event itemchanged;string	sVendor, sVendorname,	&
			sDept, 	sDeptName,		&
			sEmpno,  sEmpname,		&
			sFromDate, sToDate,		&
			sDate,	sJpno,			&
			sNull, 	siogbn
long		lRow

SetNull(sNull)

// 거래처
IF this.GetColumnName() = 'vendor'		THEN

	sVendor = this.gettext()
	SELECT CVNAS2
	  INTO :sVendorName
	  FROM VNDMST
	 WHERE CVCOD = :sVendor 	AND
	 		 CVSTATUS = '0' ;
	 
	if sqlca.sqlcode <> 0 	then
		f_message_chk(33,'[거래처]')
		this.setitem(1, "vendor", sNull)
		this.setitem(1, "vendorname", sNull)
		return 1
	end if

	this.setitem(1, "vendorname", sVendorName)
	 
	
ELSEIF this.GetColumnName() = 'idate' THEN

	sDate = trim(this.gettext())
	if isnull(sdate) or sdate = '' then return
	
	IF f_datechk(sDate) = -1	then
		this.setitem(1, "idate", is_date)
		return 1
	END IF
	
	p_inq.PostEvent(Clicked!)
END IF



//////////////////////////////////////////////////////////////////////////
// 전표번호
//////////////////////////////////////////////////////////////////////////
IF this.GetColumnName() = 'jpno'	THEN

	sJpno = this.GetText()
	if len(sjpno) <> 12 then return
	
	SELECT A.CDATE,  A.CVCOD, B.CVNAS
	  INTO :sDate, :sVendor, :sVendorName
	  FROM SHPFAT_QA_SUM A, VNDMST B
	 WHERE A.SABU = :gs_saupj
	 	AND A.CRJPNO LIKE :sjpno
	 	AND A.CVCOD = B.CVCOD
		AND A.BJUKHAP = '2'
		AND ROWNUM = 1 ;
	 
	IF SQLCA.SQLCODE <> 0	THEN
		f_message_chk(33,'[전표번호]')
		this.setitem(row, "jpno", sNull)
		RETURN 1
	END IF

	this.SetItem(1, "idate",   sDate)
	this.SetItem(1, "vendor",  sVendor)
	this.SetItem(1, "vendorname", sVendorName)
	
	p_inq.triggerevent(clicked!)

END IF
end event

type cb_save from commandbutton within w_qa02_00051
boolean visible = false
integer x = 1129
integer y = 2452
integer width = 347
integer height = 108
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "저장(&S)"
end type

type cb_exit from commandbutton within w_qa02_00051
event key_in pbm_keydown
boolean visible = false
integer x = 2267
integer y = 2448
integer width = 347
integer height = 108
integer taborder = 70
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "종료(&X)"
end type

on clicked;CLOSE(PARENT)
end on

type cb_retrieve from commandbutton within w_qa02_00051
boolean visible = false
integer x = 768
integer y = 2452
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

event clicked;if dw_detail.Accepttext() = -1	then 	return

string  	sJpno,		&
			sVendor,		&
			sDept,		&
			sEmpno,		&
			sFrom, sTo,	&
			sNull, siogbn, sgubun, smadat, ssaupj
long		lRow
SetNull(sNull)

//////////////////////////////////////////////////////////////////////////
sJpno   = dw_detail.GetItemString(1, "jpno")
sVendor = dw_detail.GetItemString(1, "vendor")
sDept	  = dw_detail.GetItemString(1, "dept")
sEmpno  = dw_detail.GetItemString(1, "empno")
sFrom	  = trim(dw_detail.GetItemString(1, "sdate"))
sTo	  = trim(dw_detail.GetItemString(1, "edate"))
siogbn  = dw_detail.GetItemString(1, "iogbn")
ssaupj  = dw_detail.GetItemString(1, "saupj")
	
IF ic_status = '1'	THEN
	
	IF isnull(sVendor) or sVendor = "" 	THEN
		f_message_chk(30, '[거래처]')
		dw_detail.SetColumn("vendor")
		dw_detail.SetFocus()
		RETURN
	END IF

	IF isnull(sFrom) or sFrom = "" 	THEN
		f_message_chk(30, '[기간]')
		dw_detail.SetColumn("sdate")
		dw_detail.SetFocus()
		RETURN
	END IF

	IF isnull(sTo) or sTo = "" 	THEN
		f_message_chk(30, '[기간]')
		dw_detail.SetColumn("edate")
		dw_detail.SetFocus()
		RETURN
	END IF
	
	if sfrom > sto then
		f_message_chk(34, '[기간]')
		dw_detail.SetColumn("sdate")
		dw_detail.SetFocus()
		RETURN
	end if
	
	// 마감일자를 check하영 시작일자가 마감일자 이전인 경우 password를
	// check하여 허용(환경설정 y-23-2
	select max(jpdat)
	  into :smadat
	  from junpyo_closing
	 where sabu = '1' and jpgu = 'C0';	
	 
	if smadat+'99' > sfrom then
		open(w_imt_04000_pass)		
		String sPass
		
		sPass = message.stringparm
		
		if sPass = 'CANCEL' then
			RETURN			
		end if	
	end if
	
	
	// 수불구분을 검색하여 외주인지 구매인지 검색한다.
	select waigu into :sgubun from iomatrix where sabu = :gs_sabu and iogbn = :siogbn;

	IF	dw_list.Retrieve(gs_sabu, sVendor, sFrom, sTo, sgubun, ssaupj) <	1		THEN
		f_message_chk(50, '')
		dw_detail.setcolumn("jpno")
		dw_detail.setfocus()
		RETURN
	END IF

	FOR  lRow = 1	TO		dw_list.RowCount()
		dw_list.SetItem(lRow, "sdate", sFrom)
		dw_list.SetItem(lRow, "edate", sTo)
	NEXT

/////////////////////////////////////////////////////////////////////////////
ELSE
	
	IF isnull(sJpno) or sJpno = "" 	THEN
		f_message_chk(30, '[전표번호]')
		dw_detail.SetColumn("jpno")
		dw_detail.SetFocus()
		RETURN
	END IF

	sJpno = sJpno + '%'
	IF	dw_list.Retrieve(gs_sabu, sJpno) <	1		THEN
		f_message_chk(50, '[전표번호]')
		dw_detail.setcolumn("jpno")
		dw_detail.setfocus()
		RETURN
	END IF
	
	// 임시로 소급적용 입고수량을 입고수량에 move
	FOR  lRow = 1	TO		dw_list.RowCount()
		dw_list.SetItem(lRow, "ioqty", dw_list.getitemdecimal(lrow, "silqty"))
	NEXT	
	
	cb_delete.enabled = true

END IF

//////////////////////////////////////////////////////////////////////////

dw_list.SetColumn("ioqty")
dw_list.SetFocus()
cb_save.enabled = true


end event

type dw_list from datawindow within w_qa02_00051
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 32
integer y = 212
integer width = 4539
integer height = 1236
integer taborder = 20
string dataobject = "d_qa02_00051_a"
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

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemerror;RETURN 1
	
	
end event

event rbuttondown;Long    nRow
String  sItnbr

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

nRow = GetRow()
If nRow <= 0 Then Return

dw_detail.AcceptText()
Choose Case GetcolumnName() 
	Case "itnbr"
//	  gs_gubun = Trim(dw_detail.Object.vendor[1])  
//	  Open(w_dan_item_popup) LJJ

	  gs_gubun = '4'
	  Open(w_itemas_popup)
	  IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
	  SetItem(nRow,"itnbr",gs_code)
	  TriggerEvent(ItemChanged!)
	Case 'cvcod'
		gs_code = Trim(GetItemString(nrow, 'itnbr'))
		If IsNull(gs_code) Or gs_code = '' then return
		
		gs_codename = '9999'
		Open(w_danmst_popup)
		If IsNull(gs_code) Or gs_code = '' then
			Open(w_vndmst_popup)
			If IsNull(gs_code) Or gs_code = '' then return
			SetItem(nRow, 'cvcod', gs_code)
			SetItem(nRow, 'cvnas2', gs_codename)
      Else         			
			SetItem(nRow, 'cvcod', gs_code)
			SetItem(nRow, 'cvnas2', gs_codename2)
		End if
	Case "pinbr"
	  gs_gubun = '2'
	  Open(w_itemas_popup)
	  IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
	  SetItem(nRow,"pinbr",gs_code)
	  TriggerEvent(ItemChanged!)
End Choose 
end event

event rowfocuschanged;If currentrow > 0 Then
	this.SelectRow(0,false)
	this.SelectRow(currentrow,true)
	
	Post wf_set_filter(currentrow)
Else
	this.SelectRow(0,false)
End If

end event

event itemchanged;Long		nRow
String  	sNull, sIttyp, sCarcode
String  	sItnbr, sItdsc, sdepot, soguan

SetNull(sNull)

nRow = GetRow()
If nRow <= 0 Then Return

dw_detail.AcceptText()

Choose Case GetColumnName() 
	Case "itnbr"
		sItnbr = Trim(GetText())
		IF sItnbr ="" OR IsNull(sItnbr) THEN
			SetItem(nRow,"itemas_itdsc",   sNull)
			Return
		END IF
		
		SELECT "ITEMAS"."ITTYP", "ITEMAS"."ITDSC",
		       decode("ITEMAS"."ITTYP",'1',fun_get_carcode(:sItnbr),fun_get_cartype(:sItnbr))
		  INTO :sIttyp, :sItdsc, :sCarcode
		  FROM "ITEMAS"
		 WHERE "ITEMAS"."ITNBR" = :sItnbr;
		
		IF SQLCA.SQLCODE = 0 THEN
			SetItem(nRow,"itemas_itdsc",   sItdsc)
			SetItem(nRow,"carcode",   sCarcode)
			SetItem(nRow,"ittyp",   sIttyp)
		else
			messagebox('확인','품번을 확인하세요!!!')
			SetItem(nRow,"itnbr",   sNull)
			SetItem(nRow,"itemas_itdsc", sNull)
			SetItem(nRow,"carcode",      sNull)
			SetItem(nRow,"protect", 'N')
			return 1
		End If
		
		post wf_depot_protect(nRow)
		
		post wf_set_soje(nRow, 'Y')
	Case "depot_no"
		sdepot = Trim(GetText())
		
		select soguan into :soguan from vndmst
		 where cvcod = :sdepot ;
		 
		if soguan = '1' then
			if wf_jepum_yn(nRow) = -1 then
				messagebox('확인','제품창고는 상품 혹은 원재료 매출과 관련된~n' + &
										'소재품목에 대해서만 지정할 수 있습니다.')
				return 1
			end if
		end if
	Case 'cvcod'
		sItnbr = this.gettext()
		SELECT CVNAS2
	  	  INTO :sItdsc
	     FROM VNDMST
	    WHERE CVCOD = :sItnbr;
	 
	if sqlca.sqlcode <> 0 	then
		f_message_chk(33,'[거래처]')
		this.setitem(nRow, "cvcod", sNull)
		this.setitem(nRow, "cvnas2", sNull)
		return 1
	end if

	this.setitem(nRow, "cvnas2", sItdsc)
	Case "pinbr"
		sItnbr = Trim(GetText())
		IF sItnbr ="" OR IsNull(sItnbr) THEN
//			SetItem(nRow,"itemas_itdsc",   sNull)
			Return
		END IF
		
		SELECT "ITEMAS"."ITDSC"
		  INTO :sItdsc
		  FROM "ITEMAS"
		 WHERE "ITEMAS"."ITNBR" = :sItnbr
		   AND "ITEMAS"."ITTYP" IN ('1','2','8','A') ;
		
		IF SQLCA.SQLCODE = 0 THEN
//			SetItem(nRow,"itemas_itdsc",   sItdsc)
		else
			messagebox('확인','품번을 확인하세요!!! ~n' + &
									'가공품목만 등록이 가능합니다.')
			SetItem(nRow,"pinbr",   	sNull)
//			SetItem(nRow,"itemas_itdsc",   sNull)
			return 1
		End If
	Case 'faqty'
		post wf_set_soje(nRow, 'N')
END Choose
end event

event clicked;If row > 0 Then
	this.SelectRow(0,false)
	this.SelectRow(row,true)
	
	Post wf_set_filter(row)
Else
	this.SelectRow(0,false)
End If
end event

type gb_1 from groupbox within w_qa02_00051
boolean visible = false
integer x = 142
integer y = 2596
integer width = 549
integer height = 136
integer taborder = 90
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
end type

type rr_1 from roundrectangle within w_qa02_00051
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 2711
integer y = 20
integer width = 759
integer height = 160
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_3 from roundrectangle within w_qa02_00051
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 23
integer y = 24
integer width = 805
integer height = 160
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_4 from roundrectangle within w_qa02_00051
boolean visible = false
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 818
integer y = 2632
integer width = 2903
integer height = 88
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_5 from roundrectangle within w_qa02_00051
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 204
integer width = 4562
integer height = 2100
integer cornerheight = 40
integer cornerwidth = 46
end type

