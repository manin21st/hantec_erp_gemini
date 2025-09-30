$PBExportHeader$w_qct_01070.srw
$PBExportComments$입고특채승인
forward
global type w_qct_01070 from window
end type
type p_exit from uo_picture within w_qct_01070
end type
type p_can from uo_picture within w_qct_01070
end type
type p_mod from uo_picture within w_qct_01070
end type
type p_inq from uo_picture within w_qct_01070
end type
type rb_delete from radiobutton within w_qct_01070
end type
type rb_insert from radiobutton within w_qct_01070
end type
type dw_detail from datawindow within w_qct_01070
end type
type dw_list from datawindow within w_qct_01070
end type
type rr_1 from roundrectangle within w_qct_01070
end type
type rr_2 from roundrectangle within w_qct_01070
end type
end forward

global type w_qct_01070 from window
integer width = 4658
integer height = 2440
boolean titlebar = true
string title = "입고특채 승인"
string menuname = "m_shortcut"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 32106727
p_exit p_exit
p_can p_can
p_mod p_mod
p_inq p_inq
rb_delete rb_delete
rb_insert rb_insert
dw_detail dw_detail
dw_list dw_list
rr_1 rr_1
rr_2 rr_2
end type
global w_qct_01070 w_qct_01070

type variables
boolean ib_ItemError
char ic_status
string is_Last_Jpno, is_Date

String     is_today              //시작일자
String     is_totime             //시작시간
String     is_window_id      //윈도우 ID
String     is_usegub           //이력관리 여부

String    sIspecText, sJijilText

end variables

forward prototypes
public function integer wf_waiju ()
public function integer wf_checkrequiredfield ()
public function integer wf_initial ()
public function integer wf_shpact (long lrow, long lrowhist, string sdate, decimal dshpseq, string siojpno, string sopseq, decimal dshpipgo, string sempno, string svendor, string sgubun)
public function integer wf_update ()
end prototypes

public function integer wf_waiju ();/* 입력 수정인 경우에만 사용함 */
Long   Lrow,  lRowCount
String sIogbn, sWigbn, sError, sIojpno, sGubun

lRowCount = dw_list.rowcount()

For Lrow = 1 to lRowCount
	
	/* 입고형태가 외주인지 check	*/
	siogbn = dw_list.GetItemString(Lrow, "imhist_iogbn")	
	
	Select waigu into :sWigbn from iomatrix where sabu = :gs_sabu And iOgbn = :sIogbn;
	If sqlca.sqlcode <> 0 then
		ROLLBACK;
		f_message_chk(311,'[외주여부]')
		return -1
	end if

	/* 외주가공 또는 외주입고인 경우에는 외주출고 자동불출자료 생성 
		-. 단 검사일자가 있는 경우에 한 함*/
	if sWigbn = 'Y' Then
		sError 	= 'X';
		sIojpno	= dw_list.getitemstring(Lrow, "imhist_iojpno")
		sqlca.erp000000360(gs_sabu, sIoJpno, 'D', sError);
		if sError = 'X' or sError = 'Y' then
			f_message_chk(41, '[외주자동출고1]')
			Rollback;
			return -1
		end if;		
		sError 	= 'X';
		sqlca.erp000000360(gs_sabu, sIoJpno, 'I', sError);
		if sError = 'X' or sError = 'Y' then
			f_message_chk(41, '[외주자동출고2]')
			Rollback;
			return -1
		end if;
	end if;		
Next

return 1
end function

public function integer wf_checkrequiredfield ();////////////////////////////////////////////////////////////////////////////
string	sGubun,	&
			sNull, sDate, sopseq, sQcdate, sEmpno, sVendor, siojpno, sTukNo
long		lRow 
dec {3}	dOkQty, dTukQty
dec {2}	dShpseq, dShpipgo, dTukSeq
SetNull(sNull)

sDate = f_today()

// 특채번호 채번 2004.06.08 ljj
dTukSeq = SQLCA.FUN_JUNPYO(gs_Sabu, sDate, 'TK')
IF dTukSeq < 1		THEN
	ROLLBACK;
	f_message_chk(51,'[특채번호]')
	RETURN -1
END IF
COMMIT;

sTukNo = "특" + Mid(sDate,3,6) + '-' + string(dTukSeq, '00')

FOR lRow = 1	TO		dw_list.RowCount()
	
	sGubun = dw_list.GetItemString(lRow, "gubun")
	dOkQty = dw_list.GetItemDecimal(lRow, "imhist_iospqty")

	IF sGubun = 'Y' And dokqty > 0 THEN
		dw_list.SetItem(lRow, "imhist_iosuqty", dOkqty)
		dw_list.SetItem(lRow, "imhist_tuksudat",  sDate) 
		dw_list.Setitem(Lrow, "imhist_insdat", sDate)
		dw_list.Setitem(Lrow, "decisionyn", 'Y')
		
		if dw_list.getitemdecimal(lrow, "imhist_cnvfat") =  1  then
			dw_list.setitem(Lrow, "imhist_cnviosu", dOkQty)
			dw_list.setitem(Lrow, "imhist_cnviosp", dOkQty)
		elseif dw_list.getitemstring(lrow, "imhist_cnvart") = '*' then
			dw_list.setitem(Lrow, "imhist_cnviosu", dw_list.getitemdecimal(lrow, "imhist_cnvfat") / dOkQty)		
			dw_list.setitem(Lrow, "imhist_cnviosp", dw_list.getitemdecimal(lrow, "imhist_cnvfat") / dOkQty)		
		else
			dw_list.setitem(Lrow, "imhist_cnviosu", dw_list.getitemdecimal(lrow, "imhist_cnvfat") * dOkQty)
			dw_list.setitem(Lrow, "imhist_cnviosp", dw_list.getitemdecimal(lrow, "imhist_cnvfat") * dOkQty)
		end if		
		
		dw_list.Setitem(Lrow, "imhist_field_cd", sTukNo)
	ELSE
		dw_list.SetItemStatus(Lrow, 0, Primary!, NotModified!)
	END IF

NEXT

IF dw_list.Update() > 0		THEN
ELSE
	ROLLBACK;
	f_Rollback()
	return -1
END IF	

/* 공정이 '9999'가 아니면 작업실적 전표번호를 생성 */
FOR	lRow = 1		TO	dw_list.RowCount()
	
	sGubun = dw_list.GetItemString(lRow, "gubun")
	dOkQty = dw_list.GetItemDecimal(lRow, "imhist_iospqty")	

	/* 특채승인이 있는 경우에만 처리 */			dShpSeq = SQLCA.FUN_JUNPYO(gs_Sabu, sDate, 'N1')
			IF dShpSeq < 1		THEN
				ROLLBACK;
				f_message_chk(51,'[작업실적번호]')
				RETURN -1
			END IF
	IF sGubun = 'Y' And dokqty > 0 THEN	
		if dw_list.getitemstring(lrow, "imhist_opseq") <> '9999' then
			/* 작업실적 전표번호 */

			/* 작업실적에 의한 입고번호 */
			dShpipgo = SQLCA.FUN_JUNPYO(gs_Sabu, sDate, 'C0')
			IF dShpipgo < 1	THEN
				ROLLBACK;
				f_message_chk(51,'[작업실적에 의한 입고번호]')
				RETURN -1
			END IF			
			Exit	
		End if
	End if
Next

FOR lRow = 1	TO		dw_list.RowCount()
	
	sGubun = dw_list.GetItemString(lRow, "gubun")
	dOkQty = dw_list.GetItemDecimal(lRow, "imhist_iospqty")

	IF sGubun = 'Y' And dokqty > 0 THEN	
		sQcDate = sDate
		
		// 외주가공인 경우에는 생산실적 전표를 작성한다. (공정이 '9999'가 아닌 경우에만 처리)
		// 무검사인 경우에만 한함(외주가공 입고는 생산승인을 하지 않음)
		sOpseq = dw_list.GetItemString(lRow, "imhist_opseq")
		sEmpno  = dw_list.GetItemString(lROW, "imhist_tukemp")
		sVendor = dw_list.GetItemString(lRow, "imhist_depot_no")		
		sIojpno = dw_list.GetItemString(lRow, "imhist_iojpno")				// 입고번호
		
		IF sOpseq <> '9999' Then
			dw_list.setitem(lrow, "imhist_ioamt", TRUNCATE(dOkqty * dw_list.getitemdecimal(lrow, "imhist_ioprc"), 0))
			if wf_shpact(Lrow, Lrow, sQcDate, dShpseq, sIojpno, sOpseq, dShpipgo, Sempno, sVendor, 'I') = -1 then
				rollback;
				return -1
			end if
		END IF
		
	END IF

NEXT

wf_waiju()

commit;

MessageBox('확 인', '특채번호는 ' + sTukNo + ' 입니다.!!')

RETURN 1

end function

public function integer wf_initial ();
dw_detail.setredraw(false)

dw_list.reset()

p_mod.enabled = false
dw_detail.enabled = TRUE

dw_detail.setcolumn("SDATE")
dw_detail.SetItem(1, "sdate", is_Date)
dw_detail.SetItem(1, "edate", is_Date)

dw_detail.setfocus()

dw_detail.setredraw(true)

// 부가세 사업장 설정
f_mod_saupj(dw_detail, 'porgu')
f_child_saupj(dw_detail, 'empno', gs_saupj)

return  1

end function

public function integer wf_shpact (long lrow, long lrowhist, string sdate, decimal dshpseq, string siojpno, string sopseq, decimal dshpipgo, string sempno, string svendor, string sgubun);// 기존의 작업실적 전표를 삭제한다.
// 구분 A = 신규입력, U = 삭제후 입력, D = 삭제
// 외주가공입고(공정이 9999가 아니면)인 경우에만 실적전표를 작성한다.
String sitnbr, spspec, sPordno, sLastc, sDe_lastc, sShpipno, sShpjpno, sPdtgu, sde_opseq
Decimal {3} dInqty, dGoqty

if sGubun = 'D' then
	Delete From shpact
	 Where sabu = :gs_sabu And pr_shpjpno = :sIojpno and sigbn = '4';
	if sqlca.sqlnrows <> 1 then
		ROLLBACK;
		MessageBox("작업실적삭제", "작업실적 삭제를 실패하였읍니다", stopsign!)
		return -1	
	end if
end if

dInqty	 = dw_list.getitemdecimal(lrow, "imhist_iosuqty")							      // 실적수량
dGoqty	 = dw_list.getitemdecimal(lrow, "imhist_gongqty")	+ &
				dw_list.getitemdecimal(lrow, "imhist_iopeqty")									// 공제수량 -> 폐기수량

if sGubun = 'U' then
	Update Shpact
		Set roqty 	= :dInqty + dGoqty,
			 coqty 	= :dInqty,
			 peqty 	= :dGoqty,			 
			 ipgub   = :sVendor, 
			 upd_user   = :gs_userid 
	 Where sabu 	= :Gs_sabu And Pr_shpjpno = :sIojpno and sigbn = '4';
	if sqlca.sqlnrows <> 1 then
		ROLLBACK;
		MessageBox("작업실적수정", "작업실적 수정를 실패하였읍니다", stopsign!)
		return -1	
	end if
End if

if sGubun = 'I' then
	
	sShpJpno  = sDate + string(dShpSeq, "0000") + string(LrowHist, '000')		// 작업실적번호
	sitnbr	 =	dw_list.GetItemString(lRow, "imhist_itnbr") 							      // 품번
	sPspec	 =	dw_list.GetItemString(lRow, "imhist_pspec")					      // 사양
	select fun_get_pdtgu(:sitnbr, '1') into :sPdtgu from dual;				      // 생산팀
	sPordno	 = dw_list.getitemstring(lrow, "imhist_jakjino");				      // 작업지시번호	

	Setnull(sLastc)
	Setnull(sDe_Lastc)
	Setnull(sshpipno)
	Select Lastc, De_opseq Into :sLastc, :sDe_opseq From morout
	 Where sabu = :gs_sabu And pordno = :sPordno And Opseq = :sOpseq;
	if Sqlca.sqlcode <> 0 then
		ROLLBACK;
		MessageBox("작업공정", "작업공정 검색이 실패하였읍니다", stopsign!)
		return -1
	End if
	
	Select Lastc Into :sDe_lastc From morout
	 Where sabu = :gs_sabu And pordno = :sPordno And Opseq = :sDe_Opseq;
	 
	// 최종공정이면 입고번호를 저장한다
	if sLastc = '3' or sLastc = '9' then
		sShpipno = sDate + string(dShpipgo, "0000") + string(LrowHist, '000')		// 작업실적에 의한 입고번호
	end if
	
	INSERT INTO SHPACT
		( SABU,				SHPJPNO,				ITNBR,				PSPEC,				WKCTR, 
		  PDTGU, 			MCHCOD, 				JOCOD, 				OPEMP, 				SIDAT, 
		  INWON,				TOTIM, 				STIME, 				ETIME, 				NTIME, 
		  PORDNO, 			SIGBN, 				PURGC, 				ROQTY, 				FAQTY, 
		  SUQTY, 			PEQTY, 				COQTY, 				PE_BIGO, 			JI_GU, 
		  INSGU, 			LOTSNO,	 									LOTENO,
		  IPGUB, 			PEDAT, 
		  PEDPTNO, 			OPSNO,				LASTC, 				DE_LASTC, 			DE_CONFIRM, 
		  PR_SHPJPNO, 		IPJPNO,           CRT_USER )
		VALUES
		( :gs_sabu,	   	:sShpjpno,			:sItnbr,				:sPspec,				null,
		  :sPdtgu,			null,					null,					null,					:sDate,
		  0,					0,						0,						0,						0,
		  :sPordno,			'4',					'Y',					:dinqty + :dGoqty,0,
		  0,					:dGoqty,				:dInqty,				'외주',				'N',
		  '2',				substr(:sIojpno, 3, 10),				substr(:sIojpno, 3, 10),			
		  :sVendor,			null,
		  null,				:sOpseq,				:sLastc,				:sDe_Lastc,			'N',
		  :sIojpno,			:sShpipno,        :gs_userid );
		  
	if Sqlca.sqlcode <> 0 then
		ROLLBACK;
		MessageBox("작업실적작성", "작업실적 작성을 실패하였읍니다", stopsign!)
		return -1
	End if	
	
	dw_list.SetItem(lRow, "imhist_jakjino", sPordno)		// 작업지시번호
	dw_list.SetItem(lRow, "imhist_jaksino", sShpjpno)	// 작업실적번호	
	
end if

return 1
end function

public function integer wf_update ();////////////////////////////////////////////////////////////////////////////
string	sGubun,	&
			sNull, sVendor, sIojpno, sOpseq, sWigbn, siogbn, serror
long		lRow
dec{3}	dOkQty
SetNull(sNull)

FOR lRow = 1	TO		dw_list.RowCount()
	
	sGubun = dw_list.GetItemString(lRow, "gubun")
	dOkQty = dw_list.GetItemDecimal(lRow, "imhist_iospqty")
	IF sGubun = 'N'	THEN
		dw_list.SetItem(lRow, "imhist_iospqty", 0)
		dw_list.SetItem(lRow, "imhist_iosuqty", 0)
		dw_list.SetItem(lRow, "imhist_tuksudat",  sNull) 
		dw_list.SetItem(lRow, "imhist_insdat",  sNull) 
		dw_list.setitem(Lrow, "imhist_cnviosu", 0)
		dw_list.setitem(Lrow, "imhist_cnviosp", 0)
		dw_list.Setitem(Lrow, "decisionyn", sNull)
	ELSE
		dw_list.SetItemStatus(Lrow, 0, Primary!, NotModified!)
	END IF
	
	If sGubun = 'N' then
		// 외주가공인 경우에는 생산실적 전표를 삭제한다. (공정이 '9999'가 아닌 경우에만 처리)
		// (외주가공 입고는 생산승인을 하지 않음)
		sIojpno = dw_list.GetItemString(lRow, "imhist_iojpno")				// 입고번호
		sOpseq = dw_list.GetItemString(lRow, "imhist_opseq")
		IF sOpseq <> '9999' Then
			If wf_shpact(Lrow, Lrow, snull, 0, sIojpno, sOpseq, 0, sNull, sNull, 'D') = -1 then
				return -1
			end if
		  
		END IF		
		/* 입고형태가 외주인지 check	*/
		siogbn = dw_list.GetItemString(Lrow, "imhist_iogbn")	
		Select waigu into :sWigbn from iomatrix where sabu = :gs_sabu And iOgbn = :sIogbn;
		If sqlca.sqlcode <> 0 then
			ROLLBACK;
			f_message_chk(311,'[외주여부]')
			return -1
		end if

		/* 외주가공 또는 외주입고인 경우에는 외주출고 자동불출자료 삭제
			-. 단 검사일자가 있는 경우에 한 함*/
		if sWigbn = 'Y' Then
			sError 	= 'X';
			sIojpno	= dw_list.getitemstring(Lrow, "imhist_iojpno")
			sqlca.erp000000360(gs_sabu, sIoJpno, 'D', sError);
			if sError = 'X' or sError = 'Y' then
				f_message_chk(41, '[외주자동출고]')
				Rollback;
				return -1
			end if;		
		end if;				
			
	End if

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

//dw_imhist.settransobject(sqlca)

is_Date = f_Today()

//규격,재질 
If f_change_name('1') = 'Y' Then
	sIspectext = f_change_name('2')
	sJijilText = f_change_name('3')
End If

dw_detail.InsertRow(0)

// commandbutton function
p_can.TriggerEvent("clicked")




end event

on w_qct_01070.create
if this.MenuName = "m_shortcut" then this.MenuID = create m_shortcut
this.p_exit=create p_exit
this.p_can=create p_can
this.p_mod=create p_mod
this.p_inq=create p_inq
this.rb_delete=create rb_delete
this.rb_insert=create rb_insert
this.dw_detail=create dw_detail
this.dw_list=create dw_list
this.rr_1=create rr_1
this.rr_2=create rr_2
this.Control[]={this.p_exit,&
this.p_can,&
this.p_mod,&
this.p_inq,&
this.rb_delete,&
this.rb_insert,&
this.dw_detail,&
this.dw_list,&
this.rr_1,&
this.rr_2}
end on

on w_qct_01070.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.p_exit)
destroy(this.p_can)
destroy(this.p_mod)
destroy(this.p_inq)
destroy(this.rb_delete)
destroy(this.rb_insert)
destroy(this.dw_detail)
destroy(this.dw_list)
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

type p_exit from uo_picture within w_qct_01070
integer x = 4389
integer y = 16
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

type p_can from uo_picture within w_qct_01070
integer x = 4215
integer y = 16
integer width = 178
integer taborder = 50
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

type p_mod from uo_picture within w_qct_01070
integer x = 4041
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

event clicked;call super::clicked;SetPointer(HourGlass!)

IF dw_list.RowCount() < 1		THEN	RETURN
IF dw_list.AcceptText() = -1	THEN	RETURN

IF f_msg_update() = -1 	THEN	RETURN

IF ic_status = '1'		THEN

	if wf_CheckRequiredField() = -1 then
		return
	end if

ELSE

	if wf_Update() = -1 then
		rollback;
		return
	end if
	
	IF dw_list.Update() > 0		THEN
		COMMIT;
	ELSE
		ROLLBACK;
		f_Rollback()
	END IF	

END IF

/////////////////////////////////////////////////////////////////////////////
p_can.TriggerEvent("clicked")

SetPointer(Arrow!)


end event

type p_inq from uo_picture within w_qct_01070
integer x = 3867
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

event clicked;call super::clicked;
IF dw_detail.AcceptText() = -1	THEN	RETURN

/////////////////////////////////////////////////////////////////////////
string	sDateFrom,	&
			sDateTo, sempno
string ls_porgu
long		lRow

ls_porgu = trim(dw_detail.GetItemString(1, "porgu"))
IF isnull(ls_porgu) or trim(ls_porgu) = "" 	THEN
	f_message_chk(30,'[사업장]') 
	dw_detail.setcolumn("porgu")
	dw_detail.setfocus()
	RETURN
END IF

sDateFrom = trim(dw_detail.GetItemString(1, "sdate"))
sDateTo   = trim(dw_detail.GetItemString(1, "edate"))
sempno    = trim(dw_detail.GetItemString(1, "empno"))

IF isnull(sDateFrom) or sDateFrom = "" 	THEN	sDateFrom = '10000101'
IF isnull(sDateTo) 	or sDateTo = "" 		THEN	sDateTo = '99991231'
IF isnull(sempno) 	or sempno = "" 		THEN	sempno = '%'

//////////////////////////////////////////////////////////////////////////

IF	dw_list.Retrieve(gs_sabu,ls_porgu,sDateFrom,sDateTo, sempno) <	1		THEN
	f_message_chk(50, '[특채요청내역]')
	dw_detail.setcolumn("sdate")
	dw_detail.setfocus()
	RETURN
END IF


//////////////////////////////////////////////////////////////////////////
FOR lRow = 1	TO		dw_list.RowCount()
	IF ic_status = '1'	THEN
		dw_list.SetItem(lRow, "imhist_iospqty", dw_list.getitemdecimal(Lrow, "imhist_ioreqty"))
	END IF
NEXT
//////////////////////////////////////////////////////////////////////////

dw_list.SetFocus()
dw_detail.enabled = false


p_mod.enabled = true


end event

type rb_delete from radiobutton within w_qct_01070
integer x = 2793
integer y = 64
integer width = 375
integer height = 72
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "특채취소"
end type

event clicked;
ic_status = '2'

dw_list.dataobject = 'd_qct_01072'
dw_list.settransobject(sqlca)

wf_initial()

//규격,재질 
If f_change_name('1') = 'Y' Then
	dw_list.Object.ispec_t.text =  sIspecText 
	dw_list.Object.jijil_t.text =  sJijilText
End If
end event

type rb_insert from radiobutton within w_qct_01070
integer x = 2386
integer y = 64
integer width = 398
integer height = 72
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "특채승인"
boolean checked = true
end type

event clicked;
ic_status = '1'
dw_list.dataobject = 'd_qct_01071'
dw_list.settransobject(sqlca)

wf_initial()

//규격,재질 
If f_change_name('1') = 'Y' Then
	dw_list.Object.ispec_t.text =  sIspecText 
	dw_list.Object.jijil_t.text =  sJijilText
End If
end event

type dw_detail from datawindow within w_qct_01070
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 69
integer y = 24
integer width = 2254
integer height = 216
integer taborder = 10
string dataobject = "d_qct_01070"
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
			sNull, sName  
SetNull(sNull)

/////////////////////////////////////////////////////////////////////////////
IF this.GetColumnName() = 'sdate' THEN
	sDate  = TRIM(this.gettext())
	if sdate = '' or isnull(sdate) then return 
	IF f_datechk(sDate) = -1	then
		this.setitem(1, "sdate", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() = 'edate' THEN
	sDate  = TRIM(this.gettext())
	if sdate = '' or isnull(sdate) then return 
	IF f_datechk(sDate) = -1	then
		this.setitem(1, "edate", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() = 'empno'		THEN
	sDate  = TRIM(this.gettext())
	if sdate = '' or isnull(sdate) then return 

  SELECT "REFFPF"."RFNA1"  
    INTO :sName  
    FROM "REFFPF"  
   WHERE ( "REFFPF"."RFCOD" = '45' ) AND  
         ( "REFFPF"."RFGUB" = :sDATE ) AND 
         ( "REFFPF"."RFGUB" <> '00' ) ;
			
	if sqlca.sqlcode <> 0 	then
		f_message_chk(33,'[특채담당자]')
		this.setitem(1, "empno", sNull)
		return 1
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

type dw_list from datawindow within w_qct_01070
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 91
integer y = 268
integer width = 4457
integer height = 2024
integer taborder = 30
string dataobject = "d_qct_01071"
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

event itemchanged;dec{3} dBadQty, dQty
long	 lRow

lRow = this.GetRow()

IF this.GetColumnName() = 'imhist_iospqty' and ic_status = '1'	THEN
	
	dBadQty = this.GetItemDecimal(lRow, "imhist_ioreqty")
	dQty = dec(this.GetText())
	
	IF dQty > dBadQty		THEN
		MessageBox("확인", "요청수량보다 클 수 없습니다.")
		this.SetItem(lRow, "imhist_iospqty", 0)
		RETURN 1
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

type rr_1 from roundrectangle within w_qct_01070
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 2336
integer y = 36
integer width = 882
integer height = 120
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_qct_01070
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 78
integer y = 256
integer width = 4485
integer height = 2048
integer cornerheight = 40
integer cornerwidth = 55
end type

