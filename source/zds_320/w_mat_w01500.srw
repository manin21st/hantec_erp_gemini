$PBExportHeader$w_mat_w01500.srw
$PBExportComments$세트품 조립처리
forward
global type w_mat_w01500 from window
end type
type rb_1 from radiobutton within w_mat_w01500
end type
type p_3 from uo_picture within w_mat_w01500
end type
type p_exit from uo_picture within w_mat_w01500
end type
type p_cancel from uo_picture within w_mat_w01500
end type
type p_delete from uo_picture within w_mat_w01500
end type
type p_save from uo_picture within w_mat_w01500
end type
type p_inq from uo_picture within w_mat_w01500
end type
type p_delrow from uo_picture within w_mat_w01500
end type
type p_addrow from uo_picture within w_mat_w01500
end type
type rb_delete from radiobutton within w_mat_w01500
end type
type dw_detail from datawindow within w_mat_w01500
end type
type gb_2 from groupbox within w_mat_w01500
end type
type rr_1 from roundrectangle within w_mat_w01500
end type
type dw_list from datawindow within w_mat_w01500
end type
end forward

global type w_mat_w01500 from window
integer width = 4695
integer height = 2664
boolean titlebar = true
string title = "품목 조립 입출고"
string menuname = "m_shortcut"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 32106727
rb_1 rb_1
p_3 p_3
p_exit p_exit
p_cancel p_cancel
p_delete p_delete
p_save p_save
p_inq p_inq
p_delrow p_delrow
p_addrow p_addrow
rb_delete rb_delete
dw_detail dw_detail
gb_2 gb_2
rr_1 rr_1
dw_list dw_list
end type
global w_mat_w01500 w_mat_w01500

type variables
boolean ib_ItemError, ib_changed
char ic_status
string is_Last_Jpno, is_Date, is_itnbr

String     is_today           //시작일자
String     is_totime          //시작시간
String     is_window_id       //윈도우 ID
String     is_usegub          //이력관리 여부
String     is_qccheck         //검사수정여부
String     is_gubun
String     is_cnvart
String	  is_jpno				//전표 번호
end variables

forward prototypes
public function integer wf_update_gubun ()
public function integer wf_initial ()
public function integer wf_checkrequiredfield ()
public function integer wf_dan (long lrow, string sitnbr, string arg_pspec, string sopseq)
public function integer wf_danmst ()
end prototypes

public function integer wf_update_gubun ();long		lRow, lCount
string	sQcgubun, sQcdate, sIoConfirm, sIoDate, sMagub, sBlno

string   sittyp, sitcls, scvcod, sitnbr, sPspec

SetPointer(HourGlass!)

lCount = dw_list.RowCount()

if ic_status <> '1' then
		
	FOR  lRow = 1	TO	lCount
		// 검사구분, 검사일자입력시 수정불가
		sQcgubun = dw_list.GetItemString(lRow, "qcgubun")
		sQcdate  = dw_list.GetItemString(lRow, "imhist_insdat")
		
		dw_list.SetItem(lRow, "updategubun", 'Y')

	   if sMagub = 'Y' then 
			dw_list.SetItem(lRow, "blmagub", 'Y')
	   end if
		
		IF sQcgubun > '1'	THEN
			IF Not IsNull(sQcdate)	THEN	dw_list.SetItem(lRow, "updategubun", 'N')
		END IF
		
		// 수불승인여부, 수불일자입력시 수정불가
		sIoConfirm = dw_list.GetItemString(lRow, "imhist_io_confirm")
		sIoDate    = dw_list.GetItemString(lRow, "imhist_io_date")
		IF sIoConfirm = 'N'	THEN
			IF Not IsNull(sIoDate)	THEN	dw_list.SetItem(lRow, "updategubun", 'N')
		END IF
		
		// 외주인 경우 생산입고CHECK
		IF dw_list.getitemstring(LRow, "shpgu") = 'N' then
			dw_list.SetItem(lRow, "updategubun", 'N')			
		end if
	
		dw_list.setitem(lRow, "qcsugbn", is_qccheck)		// 검사구분 수정여부
	NEXT
END IF

RETURN 1


end function

public function integer wf_initial ();String sIogbn, sMaigbn, sNull, sLocal, ssaupj

Setnull(sNull)

dw_detail.setredraw(false)
dw_detail.reset()
dw_detail.insertrow(0)

dw_list.reset()
p_save.enabled = false
p_delete.enabled = false
dw_detail.enabled = TRUE
p_addrow.enabled = True
p_addrow.Picturename = "C:\erpman\image\행추가_up.gif"

dw_detail.setItem(1, 'in_house','Z01')
dw_detail.setItem(1, 'out_house','Z01')
dw_detail.setItem(1, 'gubun','O86')		// 조립출고

IF ic_status = '1'	then
	// 등록시
	dw_detail.settaborder("jpno",      0)
	//dw_detail.settaborder("in_house", 10)
	dw_detail.settaborder("sdate",    20)
	dw_detail.settaborder("empno",    30)
	dw_detail.settaborder("itnbr",    50)
	dw_detail.settaborder("reqty",    60)
	dw_detail.SetItem(1, "sdate", is_Date)
	w_mdi_frame.sle_msg.text = "등록"
ELSE
	dw_detail.settaborder("jpno",		10)
	dw_detail.settaborder("sdate",	0)
	dw_detail.settaborder("empno",	0)
	//dw_detail.settaborder("in_house",0)
	dw_detail.settaborder("itnbr",   0)
	dw_detail.settaborder("reqty",   0)
	dw_detail.setcolumn("JPNO")
	w_mdi_frame.sle_msg.text = "삭제"
END IF

///* 부가 사업장 */
dw_detail.SetItem(1, 'saupj', gs_saupj)
//setnull(gs_code)
//If f_check_saupj() = 1 Then
//	dw_detail.SetItem(1, 'saupj', gs_code)
//	if gs_code <> '%' then
//		dw_detail.Modify("saupj.protect=1")
//		dw_detail.Modify("saupj.background.color = 80859087")
//	Else
//		String ls_saupj
//		select min(rfgub) into :ls_saupj
//		from reffpf
//		where rfcod ='AD'
//		and rfgub <> '00';
//		dw_detail.SetItem(1, 'saupj', ls_saupj)
//	End if
//End If

dw_detail.setfocus()
dw_detail.setredraw(true)

//DataWindowChild state_child
//integer rtncode

//창고
//rtncode 	= dw_detail.GetChild('in_house', state_child)
//IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 창고")
//state_child.SetTransObject(SQLCA)
//state_child.Retrieve(gs_saupj)

return  1
end function

public function integer wf_checkrequiredfield ();//////////////////////////////////////////////////////////////////
//
//		1. 입고수량 = 0		-> RETURN
//	
//////////////////////////////////////////////////////////////////
string	sCode, sQcgub, get_nm, spordno, get_pdsts
dec{3}	dQty 
dec{5}   dPrice
long		lRow, lcount

if dw_list.accepttext() = -1 then return -1

FOR	lRow = 1		TO		dw_list.RowCount()

		sCode = dw_list.GetitemString(lRow, "itnbr")
		IF IsNull(sCode)	or   trim(sCode) = ''	THEN
			MessageBox("품번", "품번등록은 필수입니다", stopsign!)
			dw_list.ScrollToRow(lrow)
			dw_list.Setcolumn("itnbr")
			dw_list.setfocus()
			RETURN -1
		END IF		
			
		sCode = dw_list.GetitemString(lRow, "imhist_pspec")
		IF IsNull(sCode)	or   trim(sCode) = ''	THEN
			dw_list.Setitem(lRow, "imhist_pspec", '.')
		END IF		

		dQty = dw_list.getitemdecimal(lrow, "imhist_ioreqty")
		IF IsNull(dQty)  or  dQty = 0		THEN
			f_message_chk(30,'[입고수량]')
			dw_list.ScrollToRow(lrow)
			dw_list.Setcolumn("imhist_ioreqty")
			dw_list.setfocus()
			RETURN -1
		END IF
		
//		dPrice = dw_list.GetitemDecimal(lRow, "imhist_ioprc")
//		IF IsNull(dPrice)	or dPrice <= 0	THEN
//			f_message_chk(30,'[입고단가]')
//			dw_list.ScrollToRow(lrow)
//			dw_list.Setcolumn("imhist_ioprc")
//			dw_list.setfocus()
//			RETURN -1
//		END IF		

		/* 검사품목인 경우에만 check */
		if dw_list.getitemstring(lrow, "qcgubun") > '1' then
			sCode = dw_list.GetitemString(lRow, "empno")
			IF IsNull(scode)	or   trim(sCode) = ''	THEN
				f_message_chk(30,'[검사담당자]')
				dw_list.ScrollToRow(lrow)
				dw_list.Setcolumn("empno")
				dw_list.setfocus()
				RETURN -1
			END IF

			sCode = dw_list.GetitemString(lRow, "imhist_gurdat")
			IF IsNull(sCode)	or   trim(sCode) = ''	THEN
				dw_list.setitem(Lrow, "imhist_gurdat", f_today())
			END IF
		End if	
		
NEXT

RETURN 1

end function

public function integer wf_dan (long lrow, string sitnbr, string arg_pspec, string sopseq);// 구매단가 구하기

string scvcod, scvnas, stuncu
decimal {3} dunprc

if isnull( sopseq ) or trim( sopseq ) = '' then 
	sopseq = '9999'
End if
f_buy_unprc(sitnbr, arg_pspec,  sopseq, scvcod, scvnas, dunprc, stuncu)


dw_list.setitem(Lrow, "imhist_ioprc", dunprc)

return 1
end function

public function integer wf_danmst ();string	sItem, 		&
			sCust,		&
			sCustName,	&
			sIndate,		&
			sRedate,		&
			sCustom,		&	
			sNull
long		lRow
int		iCount

SetPointer(HourGlass!)
/* 단가마스터에 검사담당자가 없는 경우 환경설정에 있는 기본 검사담당자를 이용한다 */
Setnull(sNull)
select dataname
  into :scustom
  from syscnfg
 where sysgu = 'Y' and serial = '13' and lineno = '1';

if sqlca.sqlcode <> 0 then
	f_message_chk(207,'[검사담당자]') 	
end if

SELECT 	to_char(SYSDATE, 'hh24')
  INTO	:sIndate
  FROM 	DUAL;

IF sIndate < '12'	THEN
	iCount = 1
ELSE
	iCount = 2
END IF

sRedate = f_afterday(f_today(), iCount)

FOR  lRow = 1	TO		dw_list.RowCount()

	string	sEmpno, sGubun, sStock, sOpseq
	sItem  = dw_list.GetItemString(lRow, "itnbr")
	sCust  = dw_list.GetItemString(lRow, "cvcod")
	sStock = dw_list.GetItemString(lRow, "itemas_filsk")
	sOpseq = dw_list.GetItemString(lRow, "opseq")
	
  SELECT "DANMST"."QCEMP",   
         "DANMST"."QCGUB"  
    INTO :sEmpno,   
         :sGubun  
    FROM "DANMST"  
   WHERE ( "DANMST"."ITNBR" = :sItem ) AND  
         ( "DANMST"."CVCOD" = :sCust ) AND ("DANMST"."OPSEQ" = :sOpseq )  ;
			
	IF SQLCA.SQLCODE <> 0	THEN
		SELECT "ITEMAS"."QCGUB", "ITEMAS"."QCEMP"  
        INTO :sgubun,  :sempno    
        FROM "ITEMAS"  
       WHERE "ITEMAS"."ITNBR" = :sitem ;
		
		if sgubun = '' or isnull(sgubun) then 
			dw_list.SetItem(lRow, "qcgubun", '4')		// 까다로운 검사
		else
			dw_list.SetItem(lRow, "qcgubun", sgubun)		// 까다로운 검사
		end if
		if sgubun = '1' then //무검사인 경우
			dw_list.SetItem(lRow, "empno", sNull) 
		else
			if sempno = '' or isnull(sempno) then 
				dw_list.SetItem(lRow, "empno", scustom) // 기본검사 담당자		
			else
				dw_list.SetItem(lRow, "empno", sempno)	
			end if
		end if		
	ELSE
		IF Isnull(sGubun)		THEN	sGubun = '4'
		dw_list.SetItem(lRow, "qcgubun", sGubun)
		
		If sGubun = '1' then
			dw_list.SetItem(lRow, "empno", 	sNull)		
		Else
			If Isnull(sEmpno) or Trim(sEmpno) = '' then
				dw_list.SetItem(lRow, "empno", 	sCustom)
			else
				dw_list.SetItem(lRow, "empno", 	sEmpno)				
			end if
		End if
	END IF

	// 재고관리 하지 않을 경우 : 무검사, 검사담당자 없음
	if isnull(sstock) or trim(sStock) = '' or (sStock <> 'N' and sStock <> 'Y') then
		sStock = 'Y'
	end if
	dw_list.setitem(lRow, "itemas_filsk", sStock)
	IF sStock = 'N'	THEN	
		dw_list.SetItem(lRow, "qcgubun", '1')
		dw_list.Setitem(lrow, "empno", snull)
	End if
		
	// 검사요구일자는 무검사 이면 null 
	IF sStock = 'N' or sgubun = '1'	THEN	
		dw_list.SetItem(lRow, "qcdate", sNull)
	ELSE
		dw_list.SetItem(lRow, "qcdate", sRedate)
   END IF		
	dw_list.setitem(lrow, "qcsugbn", is_qccheck)		// 검사구분 수정여부
	
NEXT

RETURN 1


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


// 환경설정에서 검사구분수정여부를 검색
//select dataname
//  into :is_qccheck
//  from syscnfg
// where sysgu = 'Y' and serial = '24' and lineno = '1';
// 
//if sqlca.sqlcode <> 0 then
//	is_qccheck = 'N'
//end if

//DataWindowChild state_child
//integer rtncode

//창고
//rtncode 	= dw_detail.GetChild('in_house', state_child)
//IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 창고")

//state_child.SetTransObject(SQLCA)
//state_child.Retrieve(gs_saupj)

///////////////////////////////////////////////////////////////////////////////////
// datawindow initial value
// 전표생선구분은 '007'(단 발주번호가 없음)
///////////////////////////////////////////////////////////////////////////////////

dw_detail.settransobject(sqlca)
dw_list.settransobject(sqlca)
dw_detail.InsertRow(0)
is_Date = f_Today()

rb_1.PostEvent(Clicked!)
end event

on w_mat_w01500.create
if this.MenuName = "m_shortcut" then this.MenuID = create m_shortcut
this.rb_1=create rb_1
this.p_3=create p_3
this.p_exit=create p_exit
this.p_cancel=create p_cancel
this.p_delete=create p_delete
this.p_save=create p_save
this.p_inq=create p_inq
this.p_delrow=create p_delrow
this.p_addrow=create p_addrow
this.rb_delete=create rb_delete
this.dw_detail=create dw_detail
this.gb_2=create gb_2
this.rr_1=create rr_1
this.dw_list=create dw_list
this.Control[]={this.rb_1,&
this.p_3,&
this.p_exit,&
this.p_cancel,&
this.p_delete,&
this.p_save,&
this.p_inq,&
this.p_delrow,&
this.p_addrow,&
this.rb_delete,&
this.dw_detail,&
this.gb_2,&
this.rr_1,&
this.dw_list}
end on

on w_mat_w01500.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.p_3)
destroy(this.p_exit)
destroy(this.p_cancel)
destroy(this.p_delete)
destroy(this.p_save)
destroy(this.p_inq)
destroy(this.p_delrow)
destroy(this.p_addrow)
destroy(this.rb_delete)
destroy(this.dw_detail)
destroy(this.gb_2)
destroy(this.rr_1)
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

//w_mdi_frame.st_window.Text = ''
//
//long li_index
//
//li_index = w_mdi_frame.dw_listbar.Find("window_id = '" + Upper(This.ClassName()) + "'", 1, w_mdi_frame.dw_listbar.RowCount())
//
//w_mdi_frame.dw_listbar.DeleteRow(li_index)
//w_mdi_frame.Postevent("ue_barrefresh")
end event

event activate;w_mdi_frame.st_window.Text = Upper(is_window_id)
end event

event key;Choose Case key
	Case KeyQ!
		p_inq.TriggerEvent(Clicked!)
	Case KeyA!
		p_addrow.TriggerEvent(Clicked!)
	Case KeyE!
		p_delrow.TriggerEvent(Clicked!)
	Case KeyX!
		p_exit.TriggerEvent(Clicked!)
End Choose
end event

type rb_1 from radiobutton within w_mat_w01500
integer x = 87
integer y = 84
integer width = 219
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
dw_list.setredraw(False)

p_3.enabled	= True
p_3.Picturename = "C:\erpman\image\계산_up.gif"

p_delrow.enabled	= True
p_delrow.Picturename = "C:\erpman\image\행삭제_up.gif"

wf_Initial()

p_inq.enabled = False
p_addrow.enabled   = True
p_delrow.enabled   = True
dw_list.setredraw(true)
end event

type p_3 from uo_picture within w_mat_w01500
integer x = 3707
integer y = 164
integer width = 178
string picturename = "C:\erpman\image\계산_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\계산_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\계산_up.gif'
end event

event clicked;call super::clicked;//	* 등록모드
//	1. 입출고HISTORY 생성
//	2. 전표채번구분 = 'C0'
//  3. 전표생성구분 = '050,051'

string	sJpno, sin_house,	ssaupj, sDate, sVendor,		&
			sSaleYn,		&
			sGubun,		&
			sQcGubun,	&
			sQcEmpno,	&
			sStockGubun,	&
			sNull, sMaigbn, sIogbn, sDeptcode, sIojpno, sOpseq, sempno, ls_opseq1, sout_house
long		lRow, lRowOut
long 		dSeq, dOutSeq, i
String	ls_itnbr, ls_cinbr, ls_opseq, ls_cvcod, ls_itdsc, ls_ispec, ls_jijil,ls_lastc
String	ls_cvnas, ls_opdsc, ls_ipjpno
Decimal  ld_qtypr, ld_unprc,rDseq, ld_reqty, ld_jegoqty

SetNull(sNull)

dw_list.reset()
dw_detail.AcceptText()

If dw_detail.RowCount() < 1 Then
	MessageBox("확인","입력된 자료가 없습니다.")
	return
End If
///////
sEmpno 		 = dw_detail.GetItemstring(1, "empno")
sSaupj 		 = dw_detail.getitemstring(1, "saupj")
sGubun 		 = dw_detail.getitemstring(1, "gubun")
sin_house	 = dw_detail.getitemstring(1, "in_house")
sDate =   trim(dw_detail.GetItemString(1, "sdate"))


//////////////////////////////////////////////////////////////////////////
IF isnull(sDate) or sDate = "" 	THEN
	dw_list.setredraw(true)
	f_message_chk(30,'[입출일자]')
	dw_detail.SetColumn("sdate")
	dw_detail.SetFocus()
	This.Enabled = True
	RETURN
END IF

// 사업장
IF IsNull(ssaupj)	or   trim(ssaupj) = ''	THEN
	dw_list.setredraw(true)
	f_message_chk(30,'[사업장]')
	dw_detail.Setcolumn("saupj")
	dw_detail.setfocus()
	This.Enabled = True
	RETURN 
END IF		

// 입고담당자
IF IsNull(sEmpno)	or   trim(sEmpno) = ''	THEN
	dw_list.setredraw(true)
	f_message_chk(30,'[담당자]')
	dw_detail.Setcolumn("empno")
	dw_detail.setfocus()
	This.Enabled = True
	RETURN 
END IF

// 입고구분
//IF IsNull(sgubun)	or   trim(sgubun) = ''	THEN
//	dw_list.setredraw(true)
//	f_message_chk(30,'[입고구분]')
//	dw_detail.Setcolumn("gubun")
//	dw_detail.setfocus()
//	This.Enabled = True
//	RETURN 
//END IF	

// 입고창고
//IF IsNull(sin_house)	or   trim(sin_house) = ''	THEN
//	dw_list.setredraw(true)
//	f_message_chk(30,'[출고창고]')
//	dw_detail.Setcolumn("in_house")
//	dw_detail.setfocus()
//	This.Enabled = True
//	RETURN 
//END IF

dSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'C0')
IF dSeq < 1		THEN
	ROLLBACK;
	f_message_chk(51,'[입고번호]')
	RETURN -1
END IF

sJpno  	 = sDate + string(dSeq, "0000")
is_jpno	 = sJpno
dw_detail.SetItem(1, "jpno", 	sJpno)

sEmpno 	 = dw_detail.GetItemString(1, "empno")
sGubun 	 = dw_detail.GetItemString(1, "gubun")
ssaupj 	 = dw_detail.GetItemString(1, "saupj")
svendor 	 = dw_detail.GetItemString(1, "vendor")
sin_house = dw_detail.GetItemString(1, "in_house")
sout_house = dw_detail.GetItemString(1, "out_house")

If	wf_CheckRequiredField() = -1 Then Return

dw_list.AcceptText()

ls_itnbr = dw_detail.GetItemString(1, 'itnbr')
ld_reqty = dw_detail.GetItemDecimal(1,'reqty')

// 품번
IF IsNull(ls_itnbr)	or   trim(ls_itnbr) = ''	THEN
	dw_list.setredraw(true)
	f_message_chk(30,'[품번]')
	dw_detail.Setcolumn("itnbr")
	dw_detail.setfocus()
	This.Enabled = True
	RETURN 
END IF

// 의뢰수량
IF IsNull(ld_reqty)	or   ld_reqty = 0	THEN
	dw_list.setredraw(true)
	f_message_chk(30,'[조립수량]')
	dw_detail.Setcolumn("reqty")
	dw_detail.setfocus()
	This.Enabled = True
	RETURN 
END IF

//Imhist 조립입고 등록
lrow = lrow + 1
dw_list.InsertRow(0)

ls_ipjpno = sJpno + string(lrow, "000")

dw_list.SetItem(lrow, "sabu",					gs_sabu)		//사업부
dw_list.SetItem(lrow, "imhist_iojpno",		ls_ipjpno)	//입고번호
dw_list.SetItem(lrow, "imhist_iogbn",    	'I86')		//수불구분 - 조립입고(I86)
dw_list.SetItem(lrow, "sudat",				sDate)		//수불일자=현재일자
dw_list.SetItem(lrow, "itnbr",				ls_itnbr)	//공정입고 품번 생성	
select fun_get_itdsc(:ls_itnbr) into :ls_itdsc from dual; //품명 조회
dw_list.SetItem(lrow, "itdsc",				ls_itdsc)	//품명
dw_list.SetItem(lrow, "pspec",				'.')			//스펙
dw_list.SetItem(lrow, "opseq",				'9999')		//공정순서
dw_list.SetItem(lrow, "depot_no",			sout_house) 	//기준창고=입고처
dw_list.SetItem(lrow, "cvcod",				sout_house) 	//기준창고=입고처
select fun_get_cvnas(:sout_house) into :ls_cvnas from dual;//거래처 
dw_list.SetItem(lrow, "cvnas",				ls_cvnas) 	//거래처창고
dw_list.SetItem(lrow, "ioqty",				ld_reqty) 	//수불수량=입고수량 
dw_list.SetItem(lrow, "ioprc",	   		0)				//공정단가
dw_list.SetItem(lrow, "ioamt", 				0)				//수불금액
dw_list.SetItem(lrow, "ioreqty",				ld_reqty)	//공정수량
dw_list.SetItem(lrow, "insdat",				sDate)		//검사일자=입고의뢰일자
dw_list.SetItem(lrow, "qcgub",				'1')			//검사구분-무검사
dw_list.SetItem(lrow, "iosuqty",				ld_reqty )	//합격수량=입고수량(관리단위)
dw_list.SetItem(lrow, "io_confirm",			'Y')			//수불승인여부	
dw_list.SetItem(lrow, "io_date",				sDate)		//수불승인일자=입고의뢰일자
dw_list.SetItem(lrow, "io_empno",			gs_userid)	//수불승인자=NULL
dw_list.SetItem(lrow, "filsk",				'Y')			//재고관리 구분
dw_list.SetItem(lrow, "botimh",				'N')			//동시출고 여부
dw_list.SetItem(lrow, "ip_jpno",				ls_ipjpno)	//상대전표 번호=입고전표 번호 입력(다른거와는 특이함)
dw_list.SetItem(lrow, "itgu",					'1' )			//입고 구분 
dw_list.SetItem(lrow, "inpcnf",				'I')			//입출고구분
dw_list.SetItem(lrow, "jnpcrt",				'051')		//전표생성구분
dw_list.SetItem(lrow, "yebi2",				'WON') 	   //통화단위
dw_list.SetItem(lrow, "ioreemp",				sEmpno)		//수불의뢰담당자-입고의뢰자
dw_list.SetItem(lrow, "bigo",					'완제품 조립입고')
dw_list.SetItem(lrow, "crt_user",					gs_userid)

select pu12_mro_jegoqty(:sout_house, :ls_itnbr, '2') into :ld_jegoqty from dual;
dw_list.SetItem(lrow, "jegoqty", ld_jegoqty)		// 현재고

//BOM 조회 - 단단계
DECLARE w_mat_w01400 CURSOR FOR 
	select cinbr, fun_get_itdsc(cinbr), qtypr
	From  pstruc, itemas 
	where pinbr = :ls_itnbr
	and   pstruc.pinbr = itemas.itnbr
	and   bomend = 'Y' 
	and 	gubun = '1'
	and   efrdt <= to_char(sysdate, 'yyyymmdd')
	and   eftdt >= to_char(sysdate, 'yyyymmdd');

OPEN w_mat_w01400;

//구매 
FETCH w_mat_w01400 INTO :ls_cinbr,:ls_itdsc, :ld_qtypr;

DO WHILE sqlca.sqlcode = 0
	
	//Imhist 조립출고 등록
	lrow = lrow + 1
	dw_list.InsertRow(0)
	
	dw_list.SetItem(lrow, "sabu",					gs_sabu)		//사업부
	sIojpno = sJpno + string(lrow, "000")
	dw_list.SetItem(lrow, "imhist_iojpno",		sIojpno)		//출고번호
	dw_list.SetItem(lrow, "imhist_iogbn",    	'O86')				//수불구분 - 조립출고(O86)
	dw_list.SetItem(lrow, "sudat",				sDate)			//수불일자=현재일자
	dw_list.SetItem(lrow, "itnbr",				ls_cinbr)			//공정입고 품번 생성	
	dw_list.SetItem(lrow, "itdsc",				ls_itdsc)			//품명
	dw_list.SetItem(lrow, "pspec",				'.')					//스펙
	dw_list.SetItem(lrow, "opseq",				'9999')		//공정순서
	dw_list.SetItem(lrow, "depot_no",			sin_house) 	//기준창고=출고처
	dw_list.SetItem(lrow, "cvcod",				sin_house) 	//기준창고=입고처
	select fun_get_cvnas(:sin_house) into :ls_cvnas from dual;//거래처 
	dw_list.SetItem(lrow, "cvnas",				ls_cvnas) 	//거래처창고-제품창고
	dw_list.SetItem(lrow, "ioqty",				ld_reqty * ld_qtypr) //수불수량=입고수량 * 구성수
	dw_list.SetItem(lrow, "ioprc",	   		0)				//공정단가
	dw_list.SetItem(lrow, "ioamt", 				0)				//수불금액
	dw_list.SetItem(lrow, "ioreqty",				ld_reqty * ld_qtypr)	//공정수량 = 입고수랭 * 구성수
	dw_list.SetItem(lrow, "insdat",				sDate)		//검사일자=입고의뢰일자
	//dw_list.SetItem(lrow, "qcgub",				'1')			//검사구분-무검사
	dw_list.SetItem(lrow, "iosuqty",				ld_reqty * ld_qtypr)	//합격수량=입고수량(관리단위)
	dw_list.SetItem(lrow, "io_confirm",			'Y')			//수불승인여부	
	dw_list.SetItem(lrow, "io_date",				sDate)		//수불승인일자=입고의뢰일자
	dw_list.SetItem(lrow, "io_empno",			gs_userid)	//수불승인자=NULL
	dw_list.SetItem(lrow, "filsk",				'Y')			//재고관리 구분
	dw_list.SetItem(lrow, "botimh",				'N')			//동시출고 여부
	dw_list.SetItem(lrow, "ip_jpno",				ls_ipjpno)	//상대전표 번호=입고전표 번호 입력(다른거와는 특이함)
	dw_list.SetItem(lrow, "itgu",					'1' )			//입고 구분 
	dw_list.SetItem(lrow, "inpcnf",				'O')			//입출고구분
	dw_list.SetItem(lrow, "jnpcrt",				'050')			//전표생성구분
	dw_list.SetItem(lrow, "yebi2",				'WON') 	   //통화단위
	dw_list.SetItem(lrow, "ioreemp",				sEmpno)		//수불의뢰담당자-입고의뢰자
	dw_list.SetItem(lrow, "bigo",					'완제품 조립출고')
	dw_list.SetItem(lrow, "crt_user",					gs_userid)
	
     select pu12_mro_jegoqty(:sin_house, :ls_cinbr, '2') into :ld_jegoqty from dual;
	dw_list.SetItem(lrow, "jegoqty", ld_jegoqty)		// 현재고
	
	FETCH w_mat_w01400 INTO :ls_cinbr,:ls_itdsc, :ld_qtypr;
	
LOOP

CLOSE w_mat_w01400;

p_save.Enabled = True
end event

type p_exit from uo_picture within w_mat_w01500
integer x = 4402
integer y = 4
integer width = 178
integer taborder = 90
string pointer = "c:\ERPMAN\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

event clicked;call super::clicked;CLOSE(PARENT)
end event

type p_cancel from uo_picture within w_mat_w01500
integer x = 4229
integer y = 4
integer width = 178
integer taborder = 80
string pointer = "c:\ERPMAN\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

event clicked;call super::clicked;//wf_initial()


rb_1.checked = true
rb_1.triggerevent(clicked!)
end event

type p_delete from uo_picture within w_mat_w01500
integer x = 4055
integer y = 4
integer width = 178
integer taborder = 70
string pointer = "c:\ERPMAN\cur\delete.cur"
string picturename = "C:\erpman\image\삭제_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\삭제_up.gif"
end event

event clicked;call super::clicked;//////////////////////////////////////////////////////////////////
///	* 입고내역 삭제
//////////////////////////////////////////////////////////////////
String sError, sGubun, sIojpno, sWigbn
int    ireturn, i

IF Messagebox('확인',"완제품 조립 입출고를 모두 삭제 하시겠습니까?", Question!,YesNo!,2) = 2 THEN RETURN 
SetPointer(HourGlass!)

IF dw_list.RowCount() < 1			THEN 	RETURN 
IF dw_detail.AcceptText() = -1	THEN	RETURN
IF dw_list.AcceptText() = -1		THEN	RETURN

//IF f_msg_delete() = -1 THEN	RETURN

For i = 1 to dw_list.RowCount()
	
	//If dw_list.GetItemString(i, 'opt') = 'Y' Then
		sIojpno = dw_list.GetItemString(i,'imhist_iojpno')
		
		delete imhist
		where  sabu = :gs_sabu
		and    iojpno like :sIojpno||'%';
	
		If sqlca.sqlcode = 0 Then
			Commit;
		Else
			Rollback;
			MessageBox("삭제실패","자료삭제를 실패하였습니다.~r~r전산실에 문의하세요")
			return -1
		End If
	//End If
Next

rb_1.checked = true
rb_1.triggerevent(clicked!)
//p_cancel.triggerevent(clicked!)

w_mdi_frame.sle_msg.text =	string(dw_list.RowCount()) + "건의 자료를 삭제하였습니다!!"	

p_delete.enabled = True
end event

type p_save from uo_picture within w_mat_w01500
integer x = 3881
integer y = 4
integer width = 178
integer taborder = 60
string pointer = "c:\ERPMAN\cur\update.cur"
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

string sdate, sWigbn, sError, sIojpno, sGubun, ls_iojpno
long	 lRow, i
dec	 dSeq

/////////////////////////////////////////////////////////////////////////
//	1. 등록시 전표번호 생성
/////////////////////////////////////////////////////////////////////////
IF ic_status = '1'	THEN
	If rb_1.Checked = True Then
		
		For i = 1 to dw_list.RowCount()
			
			If dw_list.GetItemString(i,'inpcnf') = 'O' Then
				IF dw_list.GetItemDecimal(i,'ioqty') > dw_list.GetItemDecimal(i,'jegoqty')	 Then
					
					MessageBox("저장체크","현재고 수량보다 출고 수량이 더 큽니다.~r~r대상 품번("+dw_list.GetItemString(i,'itnbr')+")을 창고이동으로 재고수량을 늘려 주세요.")
					return -1
					
				End If			
			End If
			
		Next

		IF dw_list.Update() <> 1		THEN
			ROLLBACK;
			f_Rollback()
			RETURN
		END IF
	Else
		IF	wf_CheckRequiredField() = -1		THEN	RETURN 

		IF f_msg_update() = -1 	THEN	RETURN

		IF dw_list.Update() <> 1		THEN
			ROLLBACK;
			f_Rollback()
			RETURN
		END IF
	End If
	
	ls_iojpno = dw_detail.GetItemString(1,'jpno')

	MessageBox("전표번호 확인", "전표번호 : " +left(ls_iojpno,8) + &
					"-" + mid(ls_iojpno,9,4) + "~r~r생성되었습니다.")
	commit;

ELSE
	IF dw_list.Update() <> 1		THEN
		ROLLBACK;
		f_Rollback()
		return 
	END IF
	
	Commit;
END IF 

////////////////////////////////////////////////////////////////////////

rb_delete.checked = true
rb_delete.triggerevent(clicked!)
//p_cancel.TriggerEvent("clicked")	

SetPointer(Arrow!)


dw_detail.setItem(1, "jpno",left(ls_iojpno,12))
p_inq.triggerevent(clicked!)


//SetPointer(HourGlass!)
//
//IF dw_list.RowCount() < 1			THEN 	RETURN 
//IF dw_detail.AcceptText() = -1	THEN	RETURN
//IF dw_list.AcceptText() = -1		THEN	RETURN
//
//string sdate, sWigbn, sError, sIojpno, sGubun, ls_iojpno
//long	 lRow, i
//dec	 dSeq
//
///////////////////////////////////////////////////////////////////////////
////	1. 등록시 전표번호 생성
///////////////////////////////////////////////////////////////////////////
//IF ic_status = '1'	THEN
//
//	If rb_1.Checked = True Then
//		IF wf_imhist_create(sdate, dseq) < 0 THEN RETURN 
//		IF dw_imhist.Update() <> 1		THEN
//			ROLLBACK;
//			f_Rollback()
//			RETURN
//		END IF
//		IF dw_imhist_out.Update() <> 1	THEN
//			ROLLBACK;
//			f_Rollback()
//			RETURN		
//		END IF
//	Else
//		IF	wf_CheckRequiredField() = -1		THEN	RETURN 
//
//		IF f_msg_update() = -1 	THEN	RETURN
//
//		IF dw_list.Update() <> 1		THEN
//			ROLLBACK;
//			f_Rollback()
//			RETURN
//		END IF
//	End If
//	
//	/* 외주가공 또는 외주입고인 경우에는 외주출고 자동불출자료 생성 
//		-. 단 검사일자가 있는 경우에 한 함*/
//	if cbx_1.Checked Then
//		sError 	= 'X';
//		dw_detail.accepttext()
//		sIojpno = dw_detail.GetItemString(1, "jpno")
//		sqlca.erp000000360(gs_sabu, sIoJpno+'001', 'I', sError);
//		if sError = 'X' or sError = 'Y' then
//			f_message_chk(41, '[외주자동출고]')
//			Rollback;
//			return 
//		end if;
//	end if;	
//	
//	ls_iojpno = dw_detail.GetItemString(1,'jpno')
//
//	MessageBox("전표번호 확인", "전표번호 : " +left(ls_iojpno,8) + &
//					"-" + mid(ls_iojpno,9,4) + "~r~r생성되었습니다.")
//	commit;
//
//ELSE
//	IF dw_list.Update() <> 1		THEN
//		ROLLBACK;
//		f_Rollback()
//		return 
//	END IF
//	
//	// 외주가공 또는 외주입고인 경우에는 외주출고 자동불출자료 삭제및생성 
//	if cbx_1.Checked Then 
//		sError 	= 'X';
//		dw_detail.accepttext()
//		sIojpno = dw_detail.GetItemString(1, "jpno")
//		sqlca.erp000000360(gs_sabu, sIoJpno+'001', 'D', sError);	/* 삭제 */
//		if sError = 'X' or sError = 'Y' then
//			f_message_chk(41, '[외주자동출고]')
//			Rollback;
//			return -1
//		end if;
//		sqlca.erp000000360(gs_sabu, sIoJpno+'001', 'I', sError);	/* 생성 */
//		if sError = 'X' or sError = 'Y' then
//			f_message_chk(41, '[외주자동출고]')
//			Rollback;
//			return -1
//		end if;		
//	end if;
//
//	Commit;
//
//END IF
//
//////////////////////////////////////////////////////////////////////////
//p_cancel.TriggerEvent("clicked")	
//
//SetPointer(Arrow!)
end event

type p_inq from uo_picture within w_mat_w01500
integer x = 3707
integer y = 4
integer width = 178
integer taborder = 20
string pointer = "c:\ERPMAN\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조회_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조회_up.gif"
end event

event clicked;call super::clicked;string  sJpno
long		lRow 

This.Enabled = False
if dw_detail.Accepttext() = -1	then 	return

SetPointer(HourGlass!)  
dw_list.setredraw(false)

sJpno = dw_detail.getitemstring(1, "jpno")
IF isnull(sJpno) or sJpno = "" 	THEN
	dw_list.setredraw(true)
	f_message_chk(30,'[전표번호]')
	dw_detail.SetColumn("jpno")
	dw_detail.SetFocus()
	This.Enabled = True
	RETURN
END IF

sJpno = sJpno + '%'
IF	dw_list.Retrieve(gs_sabu, sjpno) <	1		THEN
	dw_list.setredraw(true)
	f_message_chk(50, '[입출고내역]')
	dw_detail.setcolumn("jpno")
	dw_detail.setfocus()
	This.Enabled = True
	RETURN
END IF

dw_list.setredraw(true)
dw_list.SetFocus()
p_save.enabled = true
This.Enabled = True

SetPointer(Arrow!)
end event

type p_delrow from uo_picture within w_mat_w01500
integer x = 4402
integer y = 164
integer width = 178
integer taborder = 40
string pointer = "c:\ERPMAN\cur\delrow.cur"
string picturename = "C:\erpman\image\행삭제_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\행삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\행삭제_up.gif"
end event

event clicked;call super::clicked;Long Lrow

Lrow = dw_list.getrow()
if Lrow < 1 then return

if Messagebox("행삭제", "삭제하시겠읍니까?", question!, yesno!) = 1 then
	dw_list.deleterow(Lrow)
End if
end event

type p_addrow from uo_picture within w_mat_w01500
boolean visible = false
integer x = 4229
integer y = 164
integer width = 178
integer taborder = 30
string pointer = "c:\ERPMAN\cur\addrow.cur"
boolean enabled = false
string picturename = "C:\erpman\image\행추가_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\행추가_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\행추가_up.gif"
end event

event clicked;call super::clicked;Long lrow
//최초에만 Check함
//if dw_list.rowcount() > 0 then 
//	Lrow = dw_list.insertrow(0)	
//	dw_list.scrolltorow(Lrow)
//	dw_list.setrow(Lrow)
//	dw_list.setcolumn("itnbr")
//	dw_list.setfocus()
//	return
//End if

if dw_detail.Accepttext() = -1	then 	return

string  	sGubun,		&
			ssaupj,		&
			sDate,		&
			sEmpno,		&
			sNull,	smaigbn, sin_house, swaigu

SetNull(sNull)

sEmpno 		 = dw_detail.GetItemstring(1, "empno")
sSaupj 		 = dw_detail.getitemstring(1, "saupj")
sGubun 		 = dw_detail.getitemstring(1, "gubun")
sin_house	 = dw_detail.getitemstring(1, "in_house")
sDate =  trim(dw_detail.GetItemString(1, "sdate"))

//////////////////////////////////////////////////////////////////////////
IF isnull(sDate) or sDate = "" 	THEN
	dw_list.setredraw(true)
	f_message_chk(30,'[입고의뢰일자]')
	dw_detail.SetColumn("sdate")
	dw_detail.SetFocus()
	This.Enabled = True
	RETURN
END IF

// 사업장
IF IsNull(ssaupj)	or   trim(ssaupj) = ''	THEN
	dw_list.setredraw(true)
	f_message_chk(30,'[사업장]')
	dw_detail.Setcolumn("saupj")
	dw_detail.setfocus()
	This.Enabled = True
	RETURN 
END IF		

// 입고담당자
IF IsNull(sEmpno)	or   trim(sEmpno) = ''	THEN
	dw_list.setredraw(true)
	f_message_chk(30,'[입고담당자]')
	dw_detail.Setcolumn("empno")
	dw_detail.setfocus()
	This.Enabled = True
	RETURN 
END IF

// 입고구분
IF IsNull(sgubun)	or   trim(sgubun) = ''	THEN
	dw_list.setredraw(true)
	f_message_chk(30,'[입고구분]')
	dw_detail.Setcolumn("gubun")
	dw_detail.setfocus()
	This.Enabled = True
	RETURN 
END IF	

// 입고창고
IF IsNull(sin_house)	or   trim(sin_house) = ''	THEN
	dw_list.setredraw(true)
	f_message_chk(30,'[출고창고]')
	dw_detail.Setcolumn("in_house")
	dw_detail.setfocus()
	This.Enabled = True
	RETURN 
END IF

//////////////////////////////////////////////////////////////////////////
dw_detail.enabled = false

Lrow = dw_list.insertrow(0)
dw_list.SetFocus()
p_save.enabled = true

p_3.enabled	= True
p_3.Picturename = "C:\erpman\image\계산_up.gif"

If IsNull(is_jpno ) or is_jpno = '' Then
	MessageBox('확인','계산을 먼저 실행하셔야 합니다.')
	wf_initial()
	return
End If

dw_list.SetItem(Lrow, 'imhist_iojpno' ,	is_jpno + string(lrow, "000"))//입고번호
dw_list.SetItem(lrow, "imhist_iogbn",    	'I' + Right(dw_detail.GetItemString(1, 'gubun'), 2))		//수불구분 - 분해입고
dw_list.SetItem(lrow, "sudat",				sDate)		//수불일자=현재일자
dw_list.SetItem(lrow, "insdat",				sDate)		//검사일자=입고의뢰일자
dw_list.SetItem(lrow, "qcgub",				'1')			//검사구분-무검사
dw_list.SetItem(lrow, "io_confirm",			'Y')			//수불승인여부	
dw_list.SetItem(lrow, "io_date",				sDate)		//수불승인일자=입고의뢰일자
dw_list.SetItem(lrow, "io_empno",			gs_userid)	//수불승인자=NULL
dw_list.SetItem(lrow, "inpcnf",				'I')			//입출고구분
dw_list.SetItem(lrow, "jnpcrt",				'011')		//전표생성구분
dw_list.SetItem(lrow, "ioreemp",				sEmpno)		//수불의뢰담당자-입고의뢰자
dw_list.SetItem(lrow, "bigo",					'세트품분해입고')
dw_list.SetItem(lrow, "ip_jpno",				dw_list.GetItemString(1, "imhist_iojpno"))	//상대전표 번호


end event

type rb_delete from radiobutton within w_mat_w01500
integer x = 87
integer y = 168
integer width = 219
integer height = 72
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "삭제"
end type

event clicked;ic_status = '2'

p_3.enabled	= False
p_3.Picturename = "C:\erpman\image\계산_d.gif"

p_delrow.enabled	= False
p_delrow.Picturename = "C:\erpman\image\행삭제_d.gif"

//dw_list.Object.opt.Visible = True
//dw_list.Object.opt_t.Visible = True

wf_Initial()

p_inq.enabled = True
p_delete.enabled = True
end event

type dw_detail from datawindow within w_mat_w01500
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 347
integer y = 24
integer width = 3182
integer height = 280
integer taborder = 10
string dataobject = "d_mat_w01500"
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

event rbuttondown;gs_code = ''
gs_codename = ''
gs_gubun = ''

// 입고승인담당자
IF this.GetColumnName() = 'empno'	THEN
   gs_gubun = '2'
   gs_code  = 'Z01'

	Open(w_depot_emp_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1,"empno",gs_code)
	SetItem(1,"empname",gs_codename)
	
ELSEIF this.GetColumnName() = 'jpno'	THEN

	//gs_gubun = '001'
    Open(w_ipgo_i86_popup)
	if isnull(gs_code)  or  gs_code = ''	then	return
	this.setitem(1, "jpno", Left(gs_code,12))
	this.triggerevent("itemchanged")

// 거래처
ELSEIF this.GetColumnName() = 'vendor'	THEN

	string	sCheck, sIogbn
	sIogbn = THIS.getitemstring(1, "gubun")

	if sIogbn = "" or isnull(sIogbn) then 
		messagebox('확 인', '입고구분을 먼저 입력하세요!')
		this.setitem(1, 'vendor', siogbn)
		this.setitem(1, 'vendorname', siogbn)
		return 1
	end if

	/* 관련처 기준 검색 */
	SELECT RELCOD INTO :SCHECK FROM IOMATRIX
	 WHERE SABU = :gs_sabu AND IOGBN = :sIogbn;
	    
	/* 관련처코드 구분에 따른 거래처구분을 setting */
	Choose case scheck  //관련처코드(1:창고, 2:부서, 3:거래처, 4:창고+부서, 5:ALL)
			 case '1'
					open(w_vndmst_46_popup)
			 case '2'
					open(w_vndmst_4_popup)
			 case '3'
				   gs_gubun = '1' 
					open(w_vndmst_popup)
			 case '4'
					open(w_vndmst_45_popup)
			 case '5'
				   gs_gubun = '1' 
					open(w_vndmst_popup)
			 case else
					f_message_chk(208,'[거래처]')
					this.setitem(1, 'vendor', "")
					this.setitem(1, 'vendorname', "")
				   return 1
	End choose

	if Isnull(gs_code) or Trim(gs_code) = "" then return		
	
	this.SetItem(1, "vendor", gs_code)
	this.SetItem(1, "vendorname", gs_codename)
	this.TriggerEvent("itemchanged")
// 품번
ElseIF this.GetColumnName() = 'itnbr'	THEN
	open(w_itemas_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	this.SetItem(1,"itnbr",gs_code)
	this.TriggerEvent(ItemChanged!)
END IF


end event

event itemchanged;string	scode, sName1,	sname2, sNull, sjpno, sdate, scust, sempno, sgubun,ls_bigo,  &
         scustname, sempname, s_today, soldcode, sBalgu, sWaigu, ssaupj, sin_store, sbalno, sblno, slcno
int      ireturn, get_count 
String   ls_estno

SetNull(sNull)

//사업장 - 사업장 통합으로 인해 선택된 사업장에 따른 창고 지정
//영업창고 중 사업장에 따른 제품창고(울산)/제품장고(장안) 중 선택
String  ls_cvcod
If This.GetColumnName() = 'saupj' Then
	SELECT CVCOD INTO :ls_cvcod FROM VNDMST
	 WHERE CVGU = '5' AND SOGUAN = '1' AND JUMAECHUL = '2' AND JUHANDLE = '1' AND IPJOGUN = :data ;
	If SQLCA.SQLCODE <> 0 OR Trim(ls_cvcod) = '' OR IsNull(ls_cvcod) Then ls_cvcod = 'Z01'
	This.SetItem(row, 'out_house', ls_cvcod)
	This.SetItem(row, 'in_house' , ls_cvcod)
End If

// 입고의뢰일자
IF this.GetColumnName() = 'sdate' THEN

	sDate = trim(this.gettext())
	
	if sdate = '' or isnull(sdate) then return 
	
	IF f_datechk(sDate) = -1	then
		f_message_chk(35,'[입고의뢰일자]')
		this.setitem(1, "sdate", sNull)
		return 1
	END IF
	
//////////////////////////////////////////////////////////////////////////
// 담당자
//////////////////////////////////////////////////////////////////////////
ELSEIF this.GetColumnName() = "empno" THEN
	scode = this.GetText()								
   if scode = '' 	or isnull(scode) then 
		this.setitem(1, 'empname', snull)
      return 
   end if
	/*sname2 = 'Z01'*/
	sname2 = This.GetItemString(row, 'out_house') //출고창고
   ireturn = f_get_name2('출고승인자', 'Y', scode, sname1, sname2)    //1이면 실패, 0이 성공	
	this.setitem(1, 'empno', scode)
	this.setitem(1, 'empname', sname1)
   return ireturn 
	
//////////////////////////////////////////////////////////////////////////
// 거래처
//////////////////////////////////////////////////////////////////////////
ELSEIF this.GetColumnName() = "vendor" THEN
	scode = this.GetText()								
   if scode = '' 	or isnull(scode) then 
		this.setitem(1, 'vendorname', snull)
      return 
   end if
   ireturn = f_get_name2('V1', 'Y', scode, sname1, sname2)    //1이면 실패, 0이 성공	
	this.setitem(1, 'vendor', scode)
	this.setitem(1, 'vendorname', sname1)
   return ireturn 	
	
//////////////////////////////////////////////////////////////////////////
// 전표번호
//////////////////////////////////////////////////////////////////////////
ELSEIF this.GetColumnName() = 'jpno'	THEN

	sJpno = TRIM(this.GetText())

	IF sJPno = '' or isnull(sJpno) then 
		this.SetItem(1, "sdate",   sNull)
		this.SetItem(1, "empno",	sNull)
		this.SetItem(1, "empname", sNull)
		this.setitem(1, "gubun",   sNull)		
		this.SetItem(1, "vendor",  sNull)
		this.SetItem(1, "vendorname", sNull)
		return 
	END IF
	
	SELECT A.SUDAT,  A.CVCOD,   A.IOREEMP,
			 A.IOGBN,  A.BALJPNO, A.POBLNO, A.POLCNO, 
			 B.CVNAS2, D.EMPNAME, A.SAUPJ, A.DEPOT_NO,A.BIGO
	  INTO :sDate, :sCust, :sEmpno, 
			 :sGubun, :sBalno, :sBlno, :sLcno,  
			 :sCustName, :sEmpName, :sSaupj, :sin_store,:ls_bigo
	  FROM IMHIST A, VNDMST B, P1_MASTER D
	 WHERE A.CVCOD    = B.CVCOD(+)	AND
			 A.IOREEMP  = D.EMPNO(+)	AND
			 A.SABU = :gs_sabu			AND
			 A.IOJPNO like :sJpno||'%'	AND
			 rownum = 1;
	 
	IF SQLCA.SQLCODE <> 0	THEN
		f_message_chk(33,'[전표번호]')
		this.setitem(1, "jpno", sNull)
		RETURN 1
	END IF
	
	If ls_bigo <> '완제품 조립출고' and ls_bigo <> '완제품 조립입고' then
		MessageBox("완제품 조립처리", "완제품 조립처리 관련 자료가 아닙니다.", information!)
		this.setitem(1, "jpno", sNull)
		RETURN 1
	End If

	this.SetItem(1, "sdate",   sDate)
	this.SetItem(1, "empno",	sEmpno)
	this.SetItem(1, "empname", sEmpname)
	this.SetItem(1, "vendor",  sCust)
	this.setitem(1, "gubun",   sgubun)
	this.setitem(1, "saupj",   ssaupj)
	this.setitem(1, "in_house",   sin_store)	
	this.SetItem(1, "vendorname", sCustName)	

ELSEIF this.GetColumnName() = 'itnbr'	THEN
	scode = trim(this.gettext())
	
	SELECT	ITTYP
	INTO		:sgubun
	FROM		ITEMAS
	WHERE		ITNBR = :scode
	USING	SQLCA;
	
	If IsNull(scode) Or scode = '' Then
		This.SetItem(1, 'gubun', '')
	Else
		If sgubun <> '1' Then			
			MessageBox("조립품번", "완제품 품번을 입력 하여야 합니다.", information!)
			this.setitem(1, "itnbr", sNull)
			RETURN 1
		End If
	End If
END IF



end event

type gb_2 from groupbox within w_mat_w01500
integer x = 59
integer width = 270
integer height = 296
integer textsize = -8
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "굴림"
long backcolor = 32106727
borderstyle borderstyle = styleraised!
end type

type rr_1 from roundrectangle within w_mat_w01500
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 64
integer y = 324
integer width = 4503
integer height = 1956
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_list from datawindow within w_mat_w01500
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 78
integer y = 336
integer width = 4475
integer height = 1932
integer taborder = 20
string dataobject = "d_mat_w01503_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;long	iRow

iRow = this.GetRow()

IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF

setnull(gs_code)

IF keydown(keyF3!) THEN
	IF This.GetColumnName() = "itnbr" Then
		gs_codename = dw_detail.GetItemString(1,"vendor")
		open(w_itmbuy2_popup)
		if 	isnull(gs_code) or gs_code = "" then return
		
		this.SetItem(iRow,"itnbr",gs_code)
		this.TriggerEvent(ItemChanged!)
	End If
END IF
end event

event itemchanged;long		lRow, ireturn
string	sItem, sspec, sjijil, sname, sspec_code
decimal	ld_ioqty

lRow  = this.GetRow()	
this.accepttext()

IF this.GetColumnName() = 'itnbr'	THEN
	sItem = trim(THIS.GETTEXT())								
	ireturn = f_get_name4_sale('품번', 'Y', sItem, sname, sspec, sJijil, sspec_code) 

 	ib_changed = true
	is_itnbr   = sitem

	this.SetItem(lRow, "itdsc", sName)
	RETURN ireturn
ElseIf this.GetColumnName() = 'depot_no' THEN
	sItem = trim(THIS.GETTEXT())			

	select cvnas into :sname from vndmst where cvcod = :sItem;

	If sqlca.sqlcode = 0 then
		this.SetItem(lRow, "depot_no", sItem)
		this.SetItem(lRow, "cvnas", sName)
		this.SetItem(lRow, "cvcod", sItem)
	Else
		Return
	End If
ElseIf this.GetColumnName() = 'ioqty' THEN
	ld_ioqty = THIS.GetItemDecimal(row,'ioqty' )
	
	this.SetItem(lRow,"ioreqty", ld_ioqty)
	this.SetItem(lRow,"iosuqty", ld_ioqty)
ElseIf this.GetColumnName() = 'inpcnf' THEN
	sItem = trim(THIS.GETTEXT())			
	
	If sItem = 'I' Then
		this.SetItem(lRow,"jnpcrt", '011')
		this.SetItem(lRow,"imhist_iogbn", 'I' + Right(dw_detail.GetItemString(1, 'gubun'), 2))
	Else
		this.SetItem(lRow,"jnpcrt", '001')
		this.SetItem(lRow,"imhist_iogbn", dw_detail.GetItemString(1, 'gubun'))
	End If	
End If

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

event rbuttondown;long	lRow
lRow  = this.GetRow()	

String sitnbr

gs_code = ''
gs_codename = ''
gs_gubun = ''

// 품번
IF this.GetColumnName() = 'itnbr'	THEN
	open(w_itemas_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return
	this.SetItem(lRow,"itnbr",gs_code)
	this.TriggerEvent("itemchanged")
//작업지시번호	
ELSEIF this.getcolumnname() = "depot_no"	THEN		
	gs_gubun = '5'
	Open(w_vndmst_popup)
	IF gs_code ="" OR IsNull(gs_code) THEN RETURN
	SetItem(lRow,"depot_no",gs_code)
	SetColumn("depot_no")
	this.TriggerEvent("itemchanged")
END IF



end event

event editchanged;dec{3} dQty
dec{5} dPrice
long	lRow
lRow = this.GetRow()

// 입고수량
IF this.getcolumnname() = "inqty"		THEN

	this.AcceptText()
	dQty   = this.getitemdecimal(lRow, "inqty") 
	dPrice = this.getitemdecimal(lRow, "unprc")
	
   this.SetItem(lRow, "inamt", Truncate(dQty * dPrice, 0))		

ELSEIF this.getcolumnname() = "imhist_ioreqty"		THEN

	this.AcceptText()
	dQty   = this.getitemdecimal(lRow, "imhist_ioreqty") 
	dPrice = this.getitemdecimal(lRow, "imhist_ioprc")
	
   this.SetItem(lRow, "inamt", Truncate(dQty * dPrice, 0))		

ELSEIF this.getcolumnname() = "unprc"		THEN
	this.AcceptText()
	dQty   = this.getitemdecimal(lRow, "inqty") 
	dPrice = this.getitemdecimal(lRow, "unprc")
	
   this.SetItem(lRow, "inamt", Truncate(dQty * dPrice, 0))		
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

event itemfocuschanged;If ib_changed = True Then
	this.setItem( row, 'itnbr', is_itnbr)
	ib_changed = False
	return
End If
end event

