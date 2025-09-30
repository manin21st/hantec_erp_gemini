$PBExportHeader$w_qct_01065.srw
$PBExportComments$입고특채요청
forward
global type w_qct_01065 from window
end type
type p_out from picture within w_qct_01065
end type
type p_exit from uo_picture within w_qct_01065
end type
type p_can from uo_picture within w_qct_01065
end type
type p_mod from uo_picture within w_qct_01065
end type
type p_inq from uo_picture within w_qct_01065
end type
type dw_imhist from datawindow within w_qct_01065
end type
type rb_delete from radiobutton within w_qct_01065
end type
type rb_insert from radiobutton within w_qct_01065
end type
type dw_detail from datawindow within w_qct_01065
end type
type rr_1 from roundrectangle within w_qct_01065
end type
type rr_2 from roundrectangle within w_qct_01065
end type
type dw_list from datawindow within w_qct_01065
end type
end forward

global type w_qct_01065 from window
integer width = 4658
integer height = 2484
boolean titlebar = true
string title = "입고특채 요청"
string menuname = "m_main"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
windowstate windowstate = maximized!
long backcolor = 32106727
p_out p_out
p_exit p_exit
p_can p_can
p_mod p_mod
p_inq p_inq
dw_imhist dw_imhist
rb_delete rb_delete
rb_insert rb_insert
dw_detail dw_detail
rr_1 rr_1
rr_2 rr_2
dw_list dw_list
end type
global w_qct_01065 w_qct_01065

type variables
boolean ib_ItemError
char ic_status
string is_Last_Jpno, is_Date

String     is_today              //시작일자
String     is_totime             //시작시간
String     is_window_id      //윈도우 ID
String     is_usegub           //이력관리 여부

str_qct_01040 str_01040
end variables

forward prototypes
public function integer wf_create ()
public function integer wf_initial ()
public function integer wf_update ()
public function integer wf_checkrequiredfield ()
end prototypes

public function integer wf_create ();Long 		lrow, Linsert, dSeq
String	sDate, sJpno, sEmpno, sDptno, smaigbn, sioyea2, sWaiju, sMaipgu 
string   siogbn, sIogbn1, sIogbn2, sIogbn3, sIogbn4, sIogbn5
               //구매특채입고, 수입특채입고, local특채입고, 외주특채입고 , 특채입고(창고이동)
Integer  ireturn
// 출력
//st_barcode stbar
String sField

sEmpno	 = dw_detail.GetItemString(1, "empno")

Select deptcode into :sDptno
  From p1_master
 where empno = :sEmpno;

// 입고특채구분 ('025')
sIogbn1 = 'I05' //구매 특채입고
sIogbn2 = 'I51' //수입 특채입고
sIogbn3 = 'I52' //local 특채입고
sIogbn4 = 'I50' //외주(가공) 특채입고
sIogbn5 = 'I06' //특채입고, 자재창고에서 가상창고로 이동시

// 전표번호 생성
//sDate  	= f_today()		// 입고의뢰일자
sDate    = dw_detail.GetItemString(1, "reqdate")
dSeq 		= SQLCA.FUN_JUNPYO(gs_Sabu, sDate, 'C0')

IF dSeq < 1		THEN	
	Rollback;
	RETURN -1
end if

COMMIT;
////////////////////////////////////////////////////////////////////////
sJpno  = sDate + string(dSeq, "0000")

dw_imhist.reset()

For Lrow = 1 to dw_list.rowcount()
	
	 If dw_list.getitemdecimal(Lrow, "imhist_tukqty") = 0 Then Continue
	 
	 Linsert = dw_imhist.insertrow(0)

	 smaigbn = dw_list.getitemstring(lrow, "iomatrix_maigbn") //1:내수/2:수입 or local  
	 sioyea2 = dw_list.getitemstring(lrow, "iomatrix_ioyea2") //1:수입/2:local
	 sWaiju  = dw_list.getitemstring(lrow, "iomatrix_waigu")  //Y:외주
    sMaipgu = dw_list.getitemstring(lrow, "maipgu")
	 
    If sMaipgu = 'N' Then
		 siogbn = siogbn5 //생산출고/생산기타출고
	 elseif sWaiju = 'Y' then 
		 siogbn = siogbn4 //외주(가공)입고
	 elseif smaigbn = '2' and sioyea2 = '1' then 
		 siogbn = siogbn2 //수입입고
	 elseif smaigbn = '2' and sioyea2 = '2' then 	 
		 siogbn = siogbn3 //local입고
	 else
		 siogbn = siogbn1 //구매입고
	 end if
	 
	 dw_imhist.setitem(Linsert, "sabu", 	dw_list.getitemstring(lrow, "imhist_sabu"))
	 dw_imhist.setitem(Linsert, "iojpno", 	sJpno + string(Linsert, "000") )
	 dw_imhist.setitem(Linsert, "iogbn",   sIogbn)
	 dw_imhist.setitem(Linsert, "sudat",   sDate)
 	 dw_imhist.setitem(Linsert, "itnbr",   dw_list.getitemstring(Lrow, "imhist_itnbr"))
 	 dw_imhist.setitem(Linsert, "pspec",   dw_list.getitemstring(Lrow, "imhist_pspec"))
	 dw_imhist.setitem(Linsert, "opseq",   dw_list.getitemstring(Lrow, "imhist_opseq"))
	 dw_imhist.setitem(Linsert, "Depot_no", dw_list.getitemstring(Lrow, "imhist_Depot_no"))
	 dw_imhist.setitem(Linsert, "cvcod",    dw_list.getitemstring(Lrow, "imhist_cvcod"))
	 dw_imhist.setitem(Linsert, "ioprc",	 dw_list.getitemDecimal(Lrow, "imhist_ioprc"))
	 dw_imhist.setitem(Linsert, "ioreqty",  dw_list.getitemDecimal(Lrow, "imhist_tukqty"))
	 
	 // 발주단위 변환계수
	 dw_imhist.setitem(Linsert, "cnvfat",  dw_list.getitemDecimal(Lrow, "imhist_cnvfat"))	 
	 dw_imhist.setitem(Linsert, "cnvart",  dw_list.getitemString(Lrow, "imhist_cnvart"))	 	 
	 
	 // 발주단위 수량변환
	 if dw_list.getitemdecimal(Lrow, "imhist_cnvfat") = 1 then
		 dw_imhist.setitem(Linsert, "cnviore",  dw_list.getitemdecimal(lrow, "imhist_tukqty"))
	 elseif dw_list.getitemstring(Lrow, "imhist_cnvart") = '*' then
		 dw_imhist.setitem(Linsert, "cnviore",  &
					round(dw_list.getitemdecimal(lrow, "imhist_cnvfat") / &
							dw_list.getitemdecimal(lrow, "imhist_tukqty"), 3))
	 else
		 dw_imhist.setitem(Linsert, "cnviore",  &
					round(dw_list.getitemdecimal(lrow, "imhist_cnvfat") * &
							dw_list.getitemdecimal(lrow, "imhist_tukqty"), 3))		
	 end if
	 
	 dw_imhist.setitem(Linsert, "insemp",	 dw_list.getitemstring(Lrow, "tempno"))
	 dw_imhist.setitem(Linsert, "qcgub",	 '4')		// 특채는 필수적으로 까다로운 검사를 한다.
	 dw_imhist.setitem(Linsert, "io_confirm", 'N') 	// 특채는 필수적으로 수동승인
	 
	 dw_imhist.setitem(Linsert, "filsk",	 'Y' )	// 특채는 필수적으로 재고관리대상
	 dw_imhist.setitem(Linsert, "baljpno",	 dw_list.getitemstring(Lrow, "imhist_baljpno"))
	 dw_imhist.setitem(Linsert, "balseq",	 dw_list.getitemDecimal(Lrow, "imhist_balseq"))
	 dw_imhist.setitem(Linsert, "bigo",	 	 dw_list.getitemString(Lrow, "imhist_bigo"))
	 dw_imhist.setitem(Linsert, "botimh",	 'N')
	 dw_imhist.setitem(Linsert, "ip_jpno",	 dw_list.getitemstring(Lrow, "imhist_iojpno"))
	 dw_imhist.setitem(Linsert, "itgu",		 dw_list.getitemstring(Lrow, "imhist_itgu"))
	 dw_imhist.setitem(Linsert, "saupj",	 dw_list.getitemstring(Lrow, "imhist_saupj"))
	 dw_imhist.setitem(Linsert, "inpcnf",	 'I')
	 dw_imhist.setitem(Linsert, "jnpcrt",	 '025')
	 dw_imhist.setitem(Linsert, "outchk", 	 'N')
	 dw_imhist.setitem(linsert, "ioredept", sdptno)
	 dw_imhist.setitem(linsert, "ioreemp",  sEmpno)
	 dw_imhist.setitem(Linsert, "gurdat",   f_afterday(sdate, 2))
	 dw_imhist.setitem(Linsert, "tukdat",	 sDate)
	 dw_imhist.setitem(Linsert, "tukemp",   sEmpno)
	 dw_imhist.setitem(Linsert, "tukqty",	 dw_list.getitemDecimal(Lrow, "imhist_tukqty"))

	 dw_imhist.setitem(Linsert, "lotsno",	 dw_list.getitemstring(Lrow, "lotsno"))
	 dw_imhist.setitem(Linsert, "loteno",	 dw_list.getitemstring(Lrow, "loteno"))

	 if smaigbn = '2'  then  //수입인 경우
		 dw_imhist.setitem(Linsert, "polcno",	 dw_list.getitemstring(Lrow, "imhist_polcno"))
		 dw_imhist.setitem(Linsert, "poblno",	 dw_list.getitemstring(Lrow, "imhist_poblno"))
		 dw_imhist.setitem(Linsert, "poblsq",	 dw_list.getitemNumber(Lrow, "imhist_poblsq"))
	 end if

	 if sWaiju = 'Y' then  //외주인 경우 ==> 작업지시번호
		 dw_imhist.setitem(Linsert, "jakjino",	 dw_list.getitemstring(Lrow, "imhist_jakjino"))
	 end if

	 dw_imhist.setitem(Linsert, "yebi2",	 dw_list.getitemstring(Lrow, "imhist_yebi2"))
	 dw_imhist.setitem(Linsert, "dyebi1",	 dw_list.getitemDecimal(Lrow, "imhist_dyebi1"))
	 dw_imhist.setitem(Linsert, "dyebi2",	 dw_list.getitemDecimal(Lrow, "imhist_dyebi2"))
	 dw_imhist.setitem(Linsert, "dyebi3",	 dw_list.getitemDecimal(Lrow, "imhist_dyebi3"))
	 
	 
	 // 출력용
//	sField = 'REQ. NO : '+ sJpno + string(Linsert, "000")
//	stbar.filed[1,Linsert] = sField
//	stbar.filen[1,Linsert] = Len(sField)
//
//	sField = 'ITEM NM : '+ dw_list.getitemstring(Lrow, "itemas_itdsc")
//	stbar.filed[2,Linsert] = sField
//	stbar.filen[2,Linsert] = Len(sField)
//
//	sField = 'SPEC   : '+ dw_list.getitemstring(Lrow, "itemas_ispec")
//	stbar.filed[3,Linsert] = sField
//	stbar.filen[3,Linsert] = Len(sField)
//	
//   sField = "QTY'   : "+ String(dw_list.GetItemNumber(Lrow, 'imhist_tukqty'))
//	stbar.filed[4,Linsert] = sField
//	stbar.filen[4,Linsert] = Len(sField)
//	
//	sField = 'DATE   : '+ String(sdate,'@@@@.@@.@@')
//	stbar.filed[3,Linsert] = sField
//	stbar.filen[3,Linsert] = Len(sField)
Next

if dw_imhist.update() < 1 then
	Rollback;
	return -1
end if

// 바코드 출력용
//stbar.docid = '2'
//stbar.count = dw_imhist.RowCount()

//OpenWithParm(w_print_barcode_intermec, stbar)

Return 1

end function

public function integer wf_initial ();dw_detail.setredraw(false)

dw_list.reset()


p_mod.enabled = false

dw_detail.enabled = TRUE

//dw_detail.insertrow(0)

////////////////////////////////////////////////////////////////////////
IF ic_status = '2' THEN 
	dw_detail.object.sdate.visible = false 
	dw_detail.object.edate.visible = false 
	dw_detail.object.sdate_t.visible = false 
	dw_detail.object.sdate2_t.visible = false 
	dw_detail.setcolumn("REQDATE")
	
	f_child_saupj(dw_list, 'imhist_insemp', gs_saupj)
ELSE
	dw_detail.object.sdate.visible = TRUE
	dw_detail.object.edate.visible = TRUE
	dw_detail.object.sdate_t.visible = TRUE
	dw_detail.object.sdate2_t.visible = TRUE
	dw_detail.setcolumn("SDATE")
	dw_detail.SetItem(1, "sdate", is_Date)
	dw_detail.SetItem(1, "edate", is_Date)
	
	f_child_saupj(dw_list, 'tempno', gs_saupj)
END IF

dw_detail.SetItem(1, "REQDATE", is_Date)

dw_detail.setfocus()

dw_detail.setredraw(true)

return  1

end function

public function integer wf_update ();dec{3}	dQty, dCnvqty
long		lRow
string	sNull, sSabu, siojpno, sPrjpno

SetNull(sNull)

FOR lRow = dw_list.RowCount() TO 1	STEP -1
	
	/* 검사완료인 경우에는 처리대상에서 제외 */
	IF dw_list.getitemstring(Lrow, "gumsa") = 'Y' then continue
	
	dQty 		= dw_list.GetItemDecimal(lRow, "imhist_tukqty")
	sSabu		= dw_list.getitemstring(Lrow, "imhist_sabu")
	sIojpno	= dw_list.getitemstring(Lrow, "imhist_iojpno")	
	sPrjpno	= dw_list.getitemstring(Lrow, "imhist_ip_jpno")

	IF dQty = 0		THEN

		// 입고특채요청자료 삭제
		dw_list.deleterow(lrow)
		Lrow = Lrow - 1
		
		// 입고특채근거자료 삭제
		Update imhist
		   Set tukqty = 0, tukemp = :snull, tukdat = :sNull, tuksudat = :sNull
		 Where sabu = :sSabu and iojpno = :sPrjpno;
		If sqlca.sqlnrows < 1 then
			rollback ;
			Messagebox("삭제근거오류", "불량자료 삭제시 오류발생", stopsign!)
			return -1
		end if		 
		
	Else
		
	  // 발주단위 수량변환
	  if dw_list.getitemdecimal(Lrow, "imhist_cnvfat") = 1 then
		  dCnvqty =  dw_list.getitemdecimal(lrow, "imhist_tukqty")
	  elseif dw_list.getitemstring(Lrow, "imhist_cnvart") = '*' then
		  dCnvqty = round(dw_list.getitemdecimal(lrow, "imhist_cnvfat") / &
							    dw_list.getitemdecimal(lrow, "imhist_tukqty"), 3)
  	  else
		  dCnvqty = round(dw_list.getitemdecimal(lrow, "imhist_cnvfat") * &
							   dw_list.getitemdecimal(lrow, "imhist_tukqty"), 3)
	  end if		

     dw_list.setitem(lrow, "imhist_ioreqty", dQty)
     dw_list.setitem(lrow, "imhist_cnviore", dCnvqty)
		
		
		Update imhist
			Set tukqty 		= :dqty, 
				 upd_user 	= :gs_userid 
		 Where sabu = :sSabu and iojpno = :sPrjpno;
		If sqlca.sqlnrows < 1 then
			rollback;
			Messagebox("변경오류", "특채근거자료 변경시 오류발생", stopsign!)
			return -1
		end if
			
	END IF

NEXT

RETURN	1

end function

public function integer wf_checkrequiredfield ();
////////////////////////////////////////////////////////////////////////////
string	sReqDate,	&
			sEmpno,		&
			sNull
long		lRow
dec{3}	dQty
SetNull(sNull)


sReqDate = dw_detail.GetItemString(1, "reqdate")
sEmpno   = dw_detail.GetItemString(1, "empno")


FOR lRow = 1	TO		dw_list.RowCount()
	
	dQty = dw_list.GetItemDecimal(lRow, "imhist_tukqty")		// 특채요청수량

	IF dQty > 0		THEN
		if isnull(dw_list.GetItemString(lRow,'tempno')) or &
			dw_list.GetItemString(lRow,'tempno') = '' then
			f_message_chk(1400,'[ '+string(lRow)+' 행  특채담당자]')
			dw_list.ScrollToRow(lRow)
			dw_list.SetColumn('tempno')
			dw_list.SetFocus()
			return -1		
		end if	
		
		dw_list.SetItem(lRow, "imhist_tukdat", sReqDate)
		dw_list.SetItem(lRow, "imhist_tukemp", sEmpno) 
	END IF

NEXT

RETURN 1


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


// datawindow initial value
dw_detail.settransobject(sqlca)
dw_list.settransobject(sqlca)
dw_imhist.settransobject(sqlca)

//dw_imhist.settransobject(sqlca)

is_Date = f_Today()

dw_detail.InsertRow(0)

// commandbutton function
p_can.TriggerEvent("clicked")

// 부가세 사업장 설정
f_mod_saupj(dw_detail, 'porgu')
f_child_saupj(dw_list, 'tempno', gs_saupj)

// Defalut 작업자
dw_detail.SetItem(1, 'empno', gs_empno)
dw_detail.SetItem(1, 'empname', gs_username)

end event

on w_qct_01065.create
if this.MenuName = "m_main" then this.MenuID = create m_main
this.p_out=create p_out
this.p_exit=create p_exit
this.p_can=create p_can
this.p_mod=create p_mod
this.p_inq=create p_inq
this.dw_imhist=create dw_imhist
this.rb_delete=create rb_delete
this.rb_insert=create rb_insert
this.dw_detail=create dw_detail
this.rr_1=create rr_1
this.rr_2=create rr_2
this.dw_list=create dw_list
this.Control[]={this.p_out,&
this.p_exit,&
this.p_can,&
this.p_mod,&
this.p_inq,&
this.dw_imhist,&
this.rb_delete,&
this.rb_insert,&
this.dw_detail,&
this.rr_1,&
this.rr_2,&
this.dw_list}
end on

on w_qct_01065.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.p_out)
destroy(this.p_exit)
destroy(this.p_can)
destroy(this.p_mod)
destroy(this.p_inq)
destroy(this.dw_imhist)
destroy(this.rb_delete)
destroy(this.rb_insert)
destroy(this.dw_detail)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.dw_list)
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

type p_out from picture within w_qct_01065
boolean visible = false
integer x = 3689
integer y = 16
integer width = 178
integer height = 144
string picturename = "C:\erpman\image\인쇄_up.gif"
boolean focusrectangle = false
end type

event clicked;//st_barcode stbar
String sField
Long ix

If rb_insert.Checked Then Return

//stbar.docid = '2'
//stbar.count = dw_list.RowCount()
For ix = 1 To dw_list.RowCount()
//	sField = 'REQ. NO : '+ dw_list.getitemstring(ix, "imhist_iojpno")
//	stbar.filed[1,ix] = sField
//	stbar.filen[1,ix] = Len(sField)
//
//	sField = 'ITEM NM : '+ dw_list.getitemstring(ix, "itemas_itdsc")
//	stbar.filed[2,ix] = sField
//	stbar.filen[2,ix] = Len(sField)
//
//	sField = 'SPEC   : '+ dw_list.getitemstring(ix, "itemas_ispec")
//	stbar.filed[3,ix] = sField
//	stbar.filen[3,ix] = Len(sField)
//	
//   sField = "QTY'   : "+ String(dw_list.GetItemNumber(ix, 'imhist_tukqty'))
//	stbar.filed[4,ix] = sField
//	stbar.filen[4,ix] = Len(sField)
//	
//	sField = 'DATE   : '+ String(dw_list.getitemstring(ix, "imhist_sudat"),'@@@@.@@.@@')
//	stbar.filed[3,ix] = sField
//	stbar.filen[3,ix] = Len(sField)
Next

//OpenWithParm(w_print_barcode_intermec, stbar)
end event

type p_exit from uo_picture within w_qct_01065
integer x = 4384
integer y = 16
integer width = 178
integer taborder = 70
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;CLOSE(PARENT)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type p_can from uo_picture within w_qct_01065
integer x = 4210
integer y = 16
integer width = 178
integer taborder = 60
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

event clicked;call super::clicked;
rb_insert.checked = true

rb_insert.TriggerEvent("clicked")
end event

type p_mod from uo_picture within w_qct_01065
integer x = 4037
integer y = 16
integer width = 178
integer taborder = 40
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

event clicked;call super::clicked;string	sNull
SetPointer(HourGlass!)

IF dw_list.RowCount() < 1		THEN	RETURN
IF dw_list.AcceptText() = -1	THEN	RETURN

IF f_msg_update() = -1 	THEN	RETURN

IF ic_status = '1'	THEN

	IF wf_CheckRequiredField() = -1	THEN	RETURN
	
	If wf_create() = -1 then
		f_rollback()
		return
	end if

ELSE
		
	If wf_update() = -1 then
		f_rollback()
		return
	end if
	
END IF


/////////////////////////////////////////////////////////////////////////////
IF dw_list.Update() > 0		THEN
	COMMIT;
ELSE
	ROLLBACK;
	f_Rollback()
END IF
	
p_can.TriggerEvent("clicked")

SetPointer(Arrow!)


end event

type p_inq from uo_picture within w_qct_01065
integer x = 3863
integer y = 16
integer width = 178
integer taborder = 20
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조회_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조회_up.gif"
end event

event clicked;
IF dw_detail.AcceptText() = -1	THEN	RETURN

string	sDateFrom,	&
			sDateTo,		&
			sCustFrom,	&
			sCustTo,		&
			sReqDate,	&
			sEmpno
string ls_porgu

ls_porgu = TRIM(dw_detail.GetItemString(1, "porgu"))
IF isnull(ls_porgu) or ls_porgu = "" 	THEN
	f_message_chk(30,'[사업장]')
	dw_detail.SetColumn("porgu")
	dw_detail.SetFocus()
	RETURN
END IF

sDateFrom = TRIM(dw_detail.GetItemString(1, "sdate"))
sDateTo   = TRIM(dw_detail.GetItemString(1, "edate"))
sCustFrom = dw_detail.GetItemString(1, "cust")
sCustTo   = dw_detail.GetItemString(1, "Cust2")
sReqDate  = TRIM(dw_detail.GetItemString(1, "reqdate"))
sEmpno	 = dw_detail.GetItemString(1, "empno")

IF isnull(sDateFrom) or trim(sDateFrom) = "" 	THEN	sDateFrom = '10000101'
IF isnull(sDateTo) 	or trim(sDateTo)   = "" 	THEN	sDateTo = '99991231'
IF isnull(sCustFrom) or trim(sCustFrom) = "" 	THEN	sCustFrom = '0'
IF isnull(sCustTo) 	or trim(sCustTo)   = "" 	THEN	sCustTo = 'zzzzzz'

IF isnull(sReqDate) or sReqDate = "" 	THEN
	f_message_chk(30,'[요청일자]')
	dw_detail.SetColumn("reqdate")
	dw_detail.SetFocus()
	RETURN
END IF

// 신규입력인 경우에만 요청자 필수
If ic_status = '1' then
	IF isnull(sEmpno) or sEmpno = "" 	THEN
		f_message_chk(30,'[요청자]')
		dw_detail.SetColumn("empno")
		dw_detail.SetFocus()
		RETURN
	END IF
Else
	IF isnull(sEmpNo) or trim(sEmpNo) = "" 	THEN	sEmpNo = '%'	
End if

//////////////////////////////////////////////////////////////////////////
IF ic_status = '1'	THEN	
	IF	dw_list.Retrieve(gs_sabu,ls_porgu,sDateFrom,sDateTo, sCustFrom, sCustTo) <	1		THEN
		f_message_chk(50, '[특채요청의뢰내역]')
		dw_detail.setcolumn("sdate")
		dw_detail.setfocus()
		RETURN
	END IF
ELSE
	IF	dw_list.Retrieve(gs_sabu,ls_porgu,sReqDate, sEmpno, sCustFrom, sCustTo) <	1		THEN
		f_message_chk(50, '[특채요청내역]')
		dw_detail.setcolumn("sdate")
		dw_detail.setfocus()
		RETURN
	END IF


END IF
//////////////////////////////////////////////////////////////////////////

dw_list.SetFocus()
dw_detail.enabled = false


p_mod.enabled = true


end event

type dw_imhist from datawindow within w_qct_01065
boolean visible = false
integer x = 1577
integer y = 2236
integer width = 1198
integer height = 116
integer taborder = 50
string dataobject = "d_pdt_imhist"
boolean border = false
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

type rb_delete from radiobutton within w_qct_01065
integer x = 4247
integer y = 200
integer width = 233
integer height = 72
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "수정"
end type

event clicked;ic_status = '2'

dw_list.DataObject = 'd_qct_01065_2'
dw_list.SetTransObject(sqlca)

wf_initial()

end event

type rb_insert from radiobutton within w_qct_01065
integer x = 3931
integer y = 200
integer width = 238
integer height = 72
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "등록"
boolean checked = true
end type

event clicked;ic_status = '1'

dw_list.DataObject = 'd_qct_01065_1'
dw_list.SetTransObject(sqlca)

wf_initial()


end event

type dw_detail from datawindow within w_qct_01065
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 50
integer y = 36
integer width = 3200
integer height = 236
integer taborder = 10
string dataobject = "d_qct_01065"
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

event itemchanged;string	sDate,		&
			sEmpno,		&
			sEmpname,	&
			sNull
SetNull(sNull)


/////////////////////////////////////////////////////////////////////////////
IF this.GetColumnName() = 'sdate' THEN

	sDate  = this.gettext()
	IF f_datechk(sDate) = -1	then
		this.setitem(1, "sdate", sNull)
		return 1
	END IF
	
END IF


IF this.GetColumnName() = 'edate' THEN

	sDate  = this.gettext()
	IF f_datechk(sDate) = -1	then
		this.setitem(1, "edate", sNull)
		return 1
	END IF

END IF

IF this.GetColumnName() = 'reqdate' THEN

	sDate  = this.gettext()
	IF f_datechk(sDate) = -1	then
		this.setitem(1, "reqdate", sNull)
		return 1
	END IF

END IF


/////////////////////////////////////////////////////////////////////////////

IF this.GetColumnName() = 'empno'		THEN

	sEmpno = this.gettext()
	SetNull(sempname)
	SELECT EMPNAME
	  INTO :sEmpname
	  FROM P1_MASTER
	 WHERE EMPNO = :sEmpno AND 
			 SERVICEKINDCODE <> '3' ;
	 
	if sqlca.sqlcode = 0 then
		this.setitem(1, "empname", sEmpName)
	Else
		this.setitem(1, "empno", sNull)		
		this.setitem(1, "empname", sNull)
	end if
	 
END IF

IF this.GetColumnName() = 'porgu'		THEN
	f_child_saupj(dw_list, 'tempno', GetText())
End If
end event

event itemerror;RETURN 1
end event

event losefocus;this.accepttext()
end event

event rbuttondown;gs_code = ''
gs_codename = ''
gs_gubun = ''



IF this.GetColumnName() = 'cust'	THEN

	Open(w_vndmst_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return
	SetItem(1, "cust",	  gs_code)
	
END IF

IF this.GetColumnName() = 'cust2'	THEN

	Open(w_vndmst_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return
	SetItem(1, "cust2",	  gs_code)
	
END IF


// 담당자
IF this.GetColumnName() = 'empno'	THEN

	Open(w_sawon_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1, "empno",   gs_code)
	SetItem(1, "empname", gs_codename)

END IF

end event

type rr_1 from roundrectangle within w_qct_01065
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 3854
integer y = 180
integer width = 704
integer height = 104
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_qct_01065
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 304
integer width = 4503
integer height = 1944
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_list from datawindow within w_qct_01065
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 78
integer y = 316
integer width = 4471
integer height = 1916
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_qct_01065_1"
boolean hscrollbar = true
boolean vscrollbar = true
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

event itemchanged;
long	lRow
lRow = this.GetRow()

this.accepttext()

IF this.GetColumnName() = 'imhist_tukqty'	THEN
	
	dec{3}	dBadQty, dQty, dReQty

	if ic_status = '1' then	// 요청시에는 불량수량을 기준으로 check
		If GetItemString(lRow, 'decisionyn') = 'Y' Then
			dBadQty = this.GetItemDecimal(lRow, "imhist_iofaqty")
			dReQty  = this.GetItemDecimal(lRow, "reqty")
			dQty    = this.GetItemDecimal(lRow, "imhist_tukqty")
			
			IF dQty > (dBadQty + dReQty) THEN
				MessageBox("확인", "잔량(불량 - 불량환입)보다 클 수 없습니다.")
				this.SetItem(lRow, "imhist_tukqty", 0)
				RETURN 1
			END IF
		Else
			//dBadQty = this.GetItemDecimal(lRow, "suqty")
			dBadQty = this.GetItemDecimal(lRow, "imhist_ioreqty")
			dReQty  = this.GetItemDecimal(lRow, "reqty")
			dQty    = this.GetItemDecimal(lRow, "imhist_tukqty")
			
			IF dQty > (dBadQty + dReQty) THEN
				MessageBox("확인", "의뢰잔량(불량 - 불량환입)수량보다 클 수 없습니다.")
				this.SetItem(lRow, "imhist_tukqty", 0)
				RETURN 1
			END IF			
		End If
	ELSE
		
		dBadQty = this.GetItemDecimal(lRow, "imhist_ioreqty")
		dQty    = this.GetItemDecimal(lRow, "imhist_tukqty") 
		
		IF dQty > dBadQty		THEN
			MessageBox("확인", "처음 의뢰수량보다 클 수 없습니다.")
			this.SetItem(lRow, "imhist_tukqty", 0)
			RETURN 1
		END IF		
	
	END IF
	
END IF
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

event buttonclicked;//
//If row <= 0 Then Return
//
//gs_Code = dw_list.GetItemString(row, "imhist_iojpno")
//	
//str_01040.sabu 	= gs_sabu
//str_01040.iojpno	= dw_list.getitemstring(row, "imhist_iojpno")
//str_01040.itnbr	= dw_list.getitemstring(row, "imhist_itnbr")
//str_01040.itdsc	= dw_list.getitemstring(row, "itemas_itdsc")
//str_01040.ispec	= dw_list.getitemstring(row, "itemas_ispec")
//str_01040.rowno	= row			
//
//str_01040.gubun   = 'N' //수입검사 조회
//Openwithparm(w_qct_01050, str_01040)
end event

