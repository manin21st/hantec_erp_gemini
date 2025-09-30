$PBExportHeader$w_kfia70.srw
$PBExportComments$월자금 수지계획 자동생성
forward
global type w_kfia70 from w_inherite
end type
type cbx_los from checkbox within w_kfia70
end type
type cbx_paybil from checkbox within w_kfia70
end type
type cbx_gyel from checkbox within w_kfia70
end type
type cbx_clear from checkbox within w_kfia70
end type
type gb_1 from groupbox within w_kfia70
end type
type dw_1 from datawindow within w_kfia70
end type
type dw_list from datawindow within w_kfia70
end type
type uo_progress from u_progress_bar within w_kfia70
end type
type cbx_rcvbil from checkbox within w_kfia70
end type
type cbx_jzs from checkbox within w_kfia70
end type
type cbx_ls from checkbox within w_kfia70
end type
type cbx_cb from checkbox within w_kfia70
end type
type cbx_dpt from checkbox within w_kfia70
end type
type cbx_fix from checkbox within w_kfia70
end type
type dw_ins from datawindow within w_kfia70
end type
type cbx_dpt_man from checkbox within w_kfia70
end type
type cbx_card from checkbox within w_kfia70
end type
type rr_1 from roundrectangle within w_kfia70
end type
end forward

global type w_kfia70 from w_inherite
string title = "월자금수지계획 자동 생성"
cbx_los cbx_los
cbx_paybil cbx_paybil
cbx_gyel cbx_gyel
cbx_clear cbx_clear
gb_1 gb_1
dw_1 dw_1
dw_list dw_list
uo_progress uo_progress
cbx_rcvbil cbx_rcvbil
cbx_jzs cbx_jzs
cbx_ls cbx_ls
cbx_cb cbx_cb
cbx_dpt cbx_dpt
cbx_fix cbx_fix
dw_ins dw_ins
cbx_dpt_man cbx_dpt_man
cbx_card cbx_card
rr_1 rr_1
end type
global w_kfia70 w_kfia70

type variables
String   sAutoConFirm
end variables

forward prototypes
public function integer wf_create_gyul_date (string sym)
public function integer wf_create_paybill (string sym)
public function integer wf_create_los (string sym)
public function integer wf_create_rcvbill (string sym)
public function integer wf_create_jzs (string sym)
public function integer wf_create_ls (string sym)
public function integer wf_create_cb (string sym)
public function integer wf_create_dpt (string sym)
public function integer wf_create_dpt_man (string sym)
public function integer wf_create_sugum (string sym)
public function integer wf_create_card (string sym)
public function integer wf_create_fix (string sym)
end prototypes

public function integer wf_create_gyul_date (string sym);Integer  iRowCount,i,iCurRow,il_meterPosition

dw_list.DataObject = 'dw_kfia703'
dw_list.SetTransObject(Sqlca)
dw_list.Reset()

iRowCount = dw_list.Retrieve(sYm)
IF iRowCount <=0 THEN Return 1

sle_msg.text = '예정결제일로 자금소요자료 생성 중...'
SetPointer(HourGlass!)

uo_progress.Visible = True

FOR i = 1 TO iRowCount
	il_meterPosition = (i/ iRowCount) * 100
	uo_progress.uf_set_position (il_meterPosition)
	
	iCurRow = dw_1.InsertRow(0)
	
	dw_1.SelectRow(0,False)
	dw_1.SelectRow(iCurRow,True)
	dw_1.ScrollToRow(iCurRow)
	
	dw_1.SetItem(iCurRow,"acc_ym",    sYm)
	dw_1.SetItem(iCurRow,"seq_no",    String(iCurRow,'000'))
	dw_1.SetItem(iCurRow,"plan_day",  Right(dw_list.GetItemString(i,"gyul_date"),2))
	dw_1.SetItem(iCurRow,"saup_no",   dw_list.GetItemString(i,"saup_no"))
	dw_1.SetItem(iCurRow,"saup_nm",   Left(dw_list.GetItemString(i,"in_nm"),30))
	dw_1.SetItem(iCurRow,"descr",     Left(dw_list.GetItemString(i,"descr"),50))
	dw_1.SetItem(iCurRow,"famt",      dw_list.GetItemNumber(i,"amt"))
	dw_1.SetItem(iCurRow,"finance_cd",dw_list.GetItemString(i,"finance_cd"))	
	
	dw_1.SetItem(iCurRow,"confirm",   sAutoConfirm)		
NEXT
uo_progress.Visible = False

sle_msg.text = '예정결제일로 자금소요자료 생성 완료'
SetPointer(Arrow!)

Return 1
end function

public function integer wf_create_paybill (string sym);Integer  iRowCount,i,iCurRow,il_meterPosition
String   sFinance_Cd

dw_list.DataObject = 'dw_kfia702'
dw_list.SetTransObject(Sqlca)
dw_list.Reset()

iRowCount = dw_list.Retrieve(sYm)
IF iRowCount <=0 THEN Return 1

sle_msg.text = '지급어음으로 자금소요자료 생성 중...'
SetPointer(HourGlass!)

SELECT SUBSTR("SYSCNFG"."DATANAME",1,5)      INTO :sFinance_Cd  
	FROM "SYSCNFG"
	WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 19 ) AND  
         ( "SYSCNFG"."LINENO" = '1' )    ;
IF SQLCA.SQLCODE <> 0 THEN
	SetNull(sFinance_Cd)
END IF

uo_progress.Visible = True

FOR i = 1 TO iRowCount
	il_meterPosition = (i/ iRowCount) * 100
	uo_progress.uf_set_position (il_meterPosition)
	
	iCurRow = dw_1.InsertRow(0)
	
	dw_1.SelectRow(0,False)
	dw_1.SelectRow(iCurRow,True)
	dw_1.ScrollToRow(iCurRow)
	
	dw_1.SetItem(iCurRow,"acc_ym",    sYm)
	dw_1.SetItem(iCurRow,"seq_no",     String(iCurRow,'000'))
	dw_1.SetItem(iCurRow,"plan_day",   Right(dw_list.GetItemString(i,"bman_dat"),2))
	dw_1.SetItem(iCurRow,"saup_no",    dw_list.GetItemString(i,"saup_no"))
	dw_1.SetItem(iCurRow,"saup_nm",    f_get_personlst('1',dw_list.GetItemString(i,"saup_no"),'%'))
	dw_1.SetItem(iCurRow,"descr",      '지급어음 만기결제 [' +dw_list.GetItemString(i,"bill_no")+']')
	dw_1.SetItem(iCurRow,"famt",       dw_list.GetItemNumber(i,"bill_amt"))
	dw_1.SetItem(iCurRow,"finance_cd", sFinance_Cd)		
	
	dw_1.SetItem(iCurRow,"confirm",   sAutoConfirm)	
NEXT
uo_progress.Visible = False

sle_msg.text = '지급어음으로 자금소요자료 생성 완료'
SetPointer(Arrow!)

Return 1
end function

public function integer wf_create_los (string sym);Integer  iRowCount,i,iCurRow,il_meterPosition
Double   dRate

dw_list.DataObject = 'dw_kfia704'
dw_list.SetTransObject(Sqlca)
dw_list.Reset()

OpenWithParm(w_kfia70a,'CH'+sYm)
//dRate = Message.DoubleParm
//IF dRate = 0 OR IsNull(dRate) THEN dRate = 0

iRowCount = dw_list.Retrieve(sYm)
IF iRowCount <=0 THEN Return 1

sle_msg.text = '차입금상환 계획으로 자금소요자료 생성 중...'
SetPointer(HourGlass!)

uo_progress.Visible = True

FOR i = 1 TO iRowCount
	il_meterPosition = (i/ iRowCount) * 100
	uo_progress.uf_set_position (il_meterPosition)
	
	iCurRow = dw_1.InsertRow(0)
	
	dw_1.SelectRow(0,False)
	dw_1.SelectRow(iCurRow,True)
	dw_1.ScrollToRow(iCurRow)
	
	dw_1.SetItem(iCurRow,"acc_ym",    sYm)
	dw_1.SetItem(iCurRow,"seq_no",    String(iCurRow,'000'))
	dw_1.SetItem(iCurRow,"plan_day",  Right(dw_list.GetItemString(i,"rs_date"),2))
	dw_1.SetItem(iCurRow,"saup_no",   dw_list.GetItemString(i,"lo_bnkcd"))
	dw_1.SetItem(iCurRow,"saup_nm",   f_get_personlst('2',dw_list.GetItemString(i,"lo_bnkcd"),'%'))
	
	if dw_list.GetItemString(i,"gbn") = '1' then
		dw_1.SetItem(iCurRow,"descr",     '차입금 상환 [' + dw_list.GetItemString(i,"lo_name")+']')
	else
		dw_1.SetItem(iCurRow,"descr",     '차입금 이자 [' + dw_list.GetItemString(i,"lo_name")+']')
	end if
	dw_1.SetItem(iCurRow,"famt",      dw_list.GetItemNumber(i,"amt"))
	dw_1.SetItem(iCurRow,"finance_cd",dw_list.GetItemString(i,"fin_cd"))		
	
	dw_1.SetItem(iCurRow,"confirm",   sAutoConfirm)	
NEXT
uo_progress.Visible = False

sle_msg.text = '차입금상환계획으로 자금소요자료 생성 완료'
SetPointer(Arrow!)

Return 1
end function

public function integer wf_create_rcvbill (string sym);Integer  iRowCount,i,iCurRow,il_meterPosition
String   sFinance_Cd

dw_list.DataObject = 'dw_kfia705'
dw_list.SetTransObject(Sqlca)
dw_list.Reset()

iRowCount = dw_list.Retrieve(sYm)
IF iRowCount <=0 THEN Return 1

sle_msg.text = '받을어음으로 자금소요자료 생성 중...'
SetPointer(HourGlass!)

SELECT SUBSTR("SYSCNFG"."DATANAME",1,5)      INTO :sFinance_Cd  
	FROM "SYSCNFG"
	WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 19 ) AND  
         ( "SYSCNFG"."LINENO" = '2' )    ;
IF SQLCA.SQLCODE <> 0 THEN
	SetNull(sFinance_Cd)
END IF

uo_progress.Visible = True

FOR i = 1 TO iRowCount
	il_meterPosition = (i/ iRowCount) * 100
	uo_progress.uf_set_position (il_meterPosition)
	
	iCurRow = dw_1.InsertRow(0)
	
	dw_1.SelectRow(0,False)
	dw_1.SelectRow(iCurRow,True)
	dw_1.ScrollToRow(iCurRow)
	
	dw_1.SetItem(iCurRow,"acc_ym",    sYm)
	dw_1.SetItem(iCurRow,"seq_no",     String(iCurRow,'000'))
	dw_1.SetItem(iCurRow,"plan_day",   Right(dw_list.GetItemString(i,"bman_dat"),2))
	dw_1.SetItem(iCurRow,"saup_no",    dw_list.GetItemString(i,"saup_no"))
	dw_1.SetItem(iCurRow,"saup_nm",    f_get_personlst('1',dw_list.GetItemString(i,"saup_no"),'%'))
	dw_1.SetItem(iCurRow,"descr",      '받을어음 회수 [' +dw_list.GetItemString(i,"bill_no")+']')
	dw_1.SetItem(iCurRow,"famt",       dw_list.GetItemNumber(i,"bill_amt"))
	dw_1.SetItem(iCurRow,"finance_cd", sFinance_Cd)		
	
	dw_1.SetItem(iCurRow,"confirm",   sAutoConfirm)	
NEXT
uo_progress.Visible = False

sle_msg.text = '받을어음으로 자금소요자료 생성 완료'
SetPointer(Arrow!)

Return 1
end function

public function integer wf_create_jzs (string sym);Integer  iRowCount,i,iCurRow,il_meterPosition

dw_list.DataObject = 'dw_kfia706'
dw_list.SetTransObject(Sqlca)
dw_list.Reset()

iRowCount = dw_list.Retrieve(sYm)
IF iRowCount <=0 THEN Return 1

sle_msg.text = '유가증권으로 자금소요자료 생성 중...'
SetPointer(HourGlass!)

uo_progress.Visible = True

FOR i = 1 TO iRowCount
	il_meterPosition = (i/ iRowCount) * 100
	uo_progress.uf_set_position (il_meterPosition)
	
	iCurRow = dw_1.InsertRow(0)
	
	dw_1.SelectRow(0,False)
	dw_1.SelectRow(iCurRow,True)
	dw_1.ScrollToRow(iCurRow)
	
	dw_1.SetItem(iCurRow,"acc_ym",    sYm)
	dw_1.SetItem(iCurRow,"seq_no",    String(iCurRow,'000'))
	dw_1.SetItem(iCurRow,"plan_day",  Right(dw_list.GetItemString(i,"jz_mand"),2))
//	dw_1.SetItem(iCurRow,"saup_no",   dw_list.GetItemString(i,"jz_ibal"))
	dw_1.SetItem(iCurRow,"saup_nm",   dw_list.GetItemString(i,"jz_ibal"))
	dw_1.SetItem(iCurRow,"descr",     '유가증권 처분 [' + dw_list.GetItemString(i,"jz_name")+']')
	dw_1.SetItem(iCurRow,"famt",      dw_list.GetItemNumber(i,"amount"))
	dw_1.SetItem(iCurRow,"finance_cd",dw_list.GetItemString(i,"ficode"))		
	
	dw_1.SetItem(iCurRow,"confirm",   sAutoConfirm)	
NEXT
uo_progress.Visible = False

sle_msg.text = '유가증권으로 자금소요자료 생성 완료'
SetPointer(Arrow!)

Return 1
end function

public function integer wf_create_ls (string sym);Integer  iRowCount,i,iCurRow,il_meterPosition
Double   dRate

dw_list.DataObject = 'dw_kfia707'
dw_list.SetTransObject(Sqlca)
dw_list.Reset()

OpenWithParm(w_kfia70a,'LS'+sym)
//dRate = Message.DoubleParm
//IF dRate = 0 OR IsNull(dRate) THEN dRate = 0

iRowCount = dw_list.Retrieve(sYm)
IF iRowCount <=0 THEN Return 1

sle_msg.text = '리스상환계획 생성 중...'
SetPointer(HourGlass!)

uo_progress.Visible = True

FOR i = 1 TO iRowCount
	il_meterPosition = (i/ iRowCount) * 100
	uo_progress.uf_set_position (il_meterPosition)
	
	iCurRow = dw_1.InsertRow(0)
	
	dw_1.SelectRow(0,False)
	dw_1.SelectRow(iCurRow,True)
	dw_1.ScrollToRow(iCurRow)
	
	dw_1.SetItem(iCurRow,"acc_ym",    sYm)
	dw_1.SetItem(iCurRow,"seq_no",    String(iCurRow,'000'))
	dw_1.SetItem(iCurRow,"plan_day",  Right(dw_list.GetItemString(i,"shdate"),2))
//	dw_1.SetItem(iCurRow,"saup_no",   dw_list.GetItemString(i,"jz_ibal"))
	dw_1.SetItem(iCurRow,"saup_no",   dw_list.GetItemString(i,"lsno"))
	dw_1.SetItem(iCurRow,"descr",     '리스 상환 [' + dw_list.GetItemString(i,"kfm20m_lsco")+']')
	dw_1.SetItem(iCurRow,"famt",      dw_list.GetItemNumber(i,"ls_amt"))
	dw_1.SetItem(iCurRow,"finance_cd",dw_list.GetItemString(i,"ficode"))		
	
	dw_1.SetItem(iCurRow,"confirm",   sAutoConfirm)	
NEXT
uo_progress.Visible = False

sle_msg.text = '리스상환 계획으로 자금소요자료 생성 완료'
SetPointer(Arrow!)

Return 1
end function

public function integer wf_create_cb (string sym);Integer  iRowCount,i,iCurRow,il_meterPosition

dw_list.DataObject = 'dw_kfia708'
dw_list.SetTransObject(Sqlca)
dw_list.Reset()

iRowCount = dw_list.Retrieve(sYm)
IF iRowCount <=0 THEN Return 1

sle_msg.text = '회사채 상환계획 자금소요자료 생성 중...'
SetPointer(HourGlass!)

uo_progress.Visible = True

FOR i = 1 TO iRowCount
	il_meterPosition = (i/ iRowCount) * 100
	uo_progress.uf_set_position (il_meterPosition)
	
	iCurRow = dw_1.InsertRow(0)
	
	dw_1.SelectRow(0,False)
	dw_1.SelectRow(iCurRow,True)
	dw_1.ScrollToRow(iCurRow)
	
	dw_1.SetItem(iCurRow,"acc_ym",    sYm)
	dw_1.SetItem(iCurRow,"seq_no",    String(iCurRow,'000'))
	dw_1.SetItem(iCurRow,"plan_day",  Right(dw_list.GetItemString(i,"cb_jidate"),2))
	dw_1.SetItem(iCurRow,"saup_no",   dw_list.GetItemString(i,"cb_code"))
//	dw_1.SetItem(iCurRow,"saup_nm",   dw_list.GetItemString(i,"cb_nm"))
	IF dw_list.GetItemString(i,"gbn") = '1' THEN
		dw_1.SetItem(iCurRow,"descr",     '회사채 상환 [' + dw_list.GetItemString(i,"cb_nm")+']')
	ELSE
		dw_1.SetItem(iCurRow,"descr",     '회사채 이자 [' + dw_list.GetItemString(i,"cb_nm")+']')
	END IF
	dw_1.SetItem(iCurRow,"famt",      dw_list.GetItemNumber(i,"amount"))
	dw_1.SetItem(iCurRow,"finance_cd",dw_list.GetItemString(i,"fin_cd"))	
	
	dw_1.SetItem(iCurRow,"confirm",   sAutoConfirm)	
NEXT
uo_progress.Visible = False

sle_msg.text = '회사채 상환계획 자금소요자료 생성 완료'
SetPointer(Arrow!)

Return 1
end function

public function integer wf_create_dpt (string sym);Integer  iRowCount,i,iCurRow,il_meterPosition

dw_list.DataObject = 'dw_kfia7010'
dw_list.SetTransObject(Sqlca)
dw_list.Reset()

iRowCount = dw_list.Retrieve(sYm)
IF iRowCount <=0 THEN Return 1

sle_msg.text = '적부금으로 자금소요자료 생성 중...'
SetPointer(HourGlass!)

uo_progress.Visible = True

FOR i = 1 TO iRowCount
	il_meterPosition = (i/ iRowCount) * 100
	uo_progress.uf_set_position (il_meterPosition)
	
	iCurRow = dw_1.InsertRow(0)
	
	dw_1.SelectRow(0,False)
	dw_1.SelectRow(iCurRow,True)
	dw_1.ScrollToRow(iCurRow)
	
	dw_1.SetItem(iCurRow,"acc_ym",    sYm)
	dw_1.SetItem(iCurRow,"seq_no",    String(iCurRow,'000'))
	dw_1.SetItem(iCurRow,"plan_day",  String(dw_list.GetItemNumber(i,"ab_idat"),'00'))
	dw_1.SetItem(iCurRow,"saup_no",   dw_list.GetItemString(i,"ab_dpno"))
	dw_1.SetItem(iCurRow,"saup_nm",   dw_list.GetItemString(i,"ab_name"))
	dw_1.SetItem(iCurRow,"descr",     '적부금 납입[' + dw_list.GetItemString(i,"ab_name")+'-'+dw_list.GetItemString(i,"ab_no")+']')
	dw_1.SetItem(iCurRow,"famt",      dw_list.GetItemNumber(i,"ab_mamt"))
	dw_1.SetItem(iCurRow,"finance_cd",dw_list.GetItemString(i,"fin_cd"))	
	
	dw_1.SetItem(iCurRow,"confirm",   sAutoConfirm)	
NEXT
uo_progress.Visible = False

sle_msg.text = '적부금으로 자금소요자료 생성 완료'
SetPointer(Arrow!)

Return 1
end function

public function integer wf_create_dpt_man (string sym);Integer  iRowCount,i,iCurRow,il_meterPosition

dw_list.DataObject = 'dw_kfia7011'
dw_list.SetTransObject(Sqlca)
dw_list.Reset()

iRowCount = dw_list.Retrieve(sYm)
IF iRowCount <=0 THEN Return 1

sle_msg.text = '적부금으로 자금소요자료 생성 중...'
SetPointer(HourGlass!)

uo_progress.Visible = True

FOR i = 1 TO iRowCount
	il_meterPosition = (i/ iRowCount) * 100
	uo_progress.uf_set_position (il_meterPosition)
	
	iCurRow = dw_1.InsertRow(0)
	
	dw_1.SelectRow(0,False)
	dw_1.SelectRow(iCurRow,True)
	dw_1.ScrollToRow(iCurRow)
	
	dw_1.SetItem(iCurRow,"acc_ym",    sYm)
	dw_1.SetItem(iCurRow,"seq_no",    String(iCurRow,'000'))
	dw_1.SetItem(iCurRow,"plan_day",  String(dw_list.GetItemNumber(i,"ab_idat"),'00'))
	dw_1.SetItem(iCurRow,"saup_no",   dw_list.GetItemString(i,"ab_dpno"))
	dw_1.SetItem(iCurRow,"saup_nm",   dw_list.GetItemString(i,"ab_name"))
	dw_1.SetItem(iCurRow,"descr",     '적금 만기 회수[' + dw_list.GetItemString(i,"ab_name")+'-'+dw_list.GetItemString(i,"ab_no")+']')
	dw_1.SetItem(iCurRow,"famt",      dw_list.GetItemNumber(i,"ab_tamt"))
	dw_1.SetItem(iCurRow,"finance_cd",dw_list.GetItemString(i,"fin_cd"))		
	
	dw_1.SetItem(iCurRow,"confirm",   sAutoConfirm)	
NEXT
uo_progress.Visible = False

sle_msg.text = '적부금으로 자금소요자료 생성 완료'
SetPointer(Arrow!)

Return 1
end function

public function integer wf_create_sugum (string sym);Integer  iRowCount,i,iCurRow,il_meterPosition

dw_list.DataObject = 'dw_kfia709'
dw_list.SetTransObject(Sqlca)
dw_list.Reset()

iRowCount = dw_list.Retrieve(sYm)
IF iRowCount <=0 THEN Return 1

sle_msg.text = '수금예정일 자금소요자료 생성 중...'
SetPointer(HourGlass!)

uo_progress.Visible = True

FOR i = 1 TO iRowCount
	il_meterPosition = (i/ iRowCount) * 100
	uo_progress.uf_set_position (il_meterPosition)
	
	iCurRow = dw_1.InsertRow(0)
	
	dw_1.SelectRow(0,False)
	dw_1.SelectRow(iCurRow,True)
	dw_1.ScrollToRow(iCurRow)
	
	dw_1.SetItem(iCurRow,"acc_ym",    sYm)
	dw_1.SetItem(iCurRow,"seq_no",    String(iCurRow,'000'))
	dw_1.SetItem(iCurRow,"plan_day",  Right(dw_list.GetItemString(i,"ipgum_date"),2))
	dw_1.SetItem(iCurRow,"saup_nm",   dw_list.GetItemString(i,"saupname"))
	IF dw_list.GetItemString(i,"salegu") = '1' THEN
		dw_1.SetItem(iCurRow,"descr",     '내수수금 예정 [' + dw_list.GetItemString(i,"cvcod")+']')
	ELSE
		dw_1.SetItem(iCurRow,"descr",     '수출수금 예정 [' + dw_list.GetItemString(i,"cvcod")+']')
	END IF
	dw_1.SetItem(iCurRow,"famt",      dw_list.GetItemNumber(i,"wamt"))
	dw_1.SetItem(iCurRow,"finance_cd",dw_list.GetItemString(i,"fin_cd"))		
	
	dw_1.SetItem(iCurRow,"confirm",   sAutoConfirm)	
NEXT
uo_progress.Visible = False

sle_msg.text = '유가증권으로 자금소요자료 생성 완료'
SetPointer(Arrow!)

Return 1
end function

public function integer wf_create_card (string sym);Integer  iRowCount,i,iCurRow,il_meterPosition
String   sFinance_Cd

dw_list.DataObject = 'dw_kfia710'
dw_list.SetTransObject(Sqlca)
dw_list.Reset()

iRowCount = dw_list.Retrieve(sYm)
IF iRowCount <=0 THEN Return 1

sle_msg.text = '구매카드 자금소요자료 생성 중...'
SetPointer(HourGlass!)

SELECT SUBSTR("SYSCNFG"."DATANAME",1,5)      INTO :sFinance_Cd  
	FROM "SYSCNFG"
	WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 19 ) AND  
         ( "SYSCNFG"."LINENO" = '13' )    ;
IF SQLCA.SQLCODE <> 0 THEN
	SetNull(sFinance_Cd)
END IF

uo_progress.Visible = True

FOR i = 1 TO iRowCount
	il_meterPosition = (i/ iRowCount) * 100
	uo_progress.uf_set_position (il_meterPosition)
	
	iCurRow = dw_1.InsertRow(0)
	
	dw_1.SelectRow(0,False)
	dw_1.SelectRow(iCurRow,True)
	dw_1.ScrollToRow(iCurRow)
	
	dw_1.SetItem(iCurRow,"acc_ym",     sYm)
	dw_1.SetItem(iCurRow,"seq_no",     String(iCurRow,'000'))
	dw_1.SetItem(iCurRow,"plan_day",   Right(dw_list.GetItemString(i,"man_date"),2))
	dw_1.SetItem(iCurRow,"saup_no",    dw_list.GetItemString(i,"saup_no"))
	dw_1.SetItem(iCurRow,"saup_nm",    f_get_personlst('1',dw_list.GetItemString(i,"saup_no"),'%'))
	dw_1.SetItem(iCurRow,"descr",      '구매카드 결제 [' +dw_list.GetItemString(i,"card_no")+']')
	dw_1.SetItem(iCurRow,"famt",       dw_list.GetItemNumber(i,"maip_amt"))
	dw_1.SetItem(iCurRow,"finance_cd", sFinance_Cd)		
	
	dw_1.SetItem(iCurRow,"confirm",   sAutoConfirm)	
NEXT
uo_progress.Visible = False

sle_msg.text = '구매카드 자금소요자료 생성 완료'
SetPointer(Arrow!)

Return 1
end function

public function integer wf_create_fix (string sym);Integer  iRowCount,i,iCurRow,il_meterPosition

dw_list.DataObject = 'dw_kfia7020'
dw_list.SetTransObject(Sqlca)
dw_list.Reset()

iRowCount = dw_list.Retrieve(sYm)
IF iRowCount <=0 THEN Return 1

sle_msg.text = '자금소요 고정항목으로 생성 중...'
SetPointer(HourGlass!)

uo_progress.Visible = True

FOR i = 1 TO iRowCount
	il_meterPosition = (i/ iRowCount) * 100
	uo_progress.uf_set_position (il_meterPosition)
	
	iCurRow = dw_1.InsertRow(0)
	
	dw_1.SelectRow(0,False)
	dw_1.SelectRow(iCurRow,True)
	dw_1.ScrollToRow(iCurRow)
	
	dw_1.SetItem(iCurRow,"acc_ym",    sYm)
	dw_1.SetItem(iCurRow,"seq_no",    String(iCurRow,'000'))
	dw_1.SetItem(iCurRow,"plan_day",  dw_list.GetItemString(i,"finamce_day"))
//	dw_1.SetItem(iCurRow,"saup_no",   dw_list.GetItemString(i,"jz_ibal"))
//	dw_1.SetItem(iCurRow,"saup_nm",   dw_list.GetItemString(i,"jz_ibal"))
	dw_1.SetItem(iCurRow,"descr",     dw_list.GetItemString(i,"finance_desc"))
	dw_1.SetItem(iCurRow,"famt",      dw_list.GetItemNumber(i,"plan_amt"))
	dw_1.SetItem(iCurRow,"finance_cd",dw_list.GetItemString(i,"finance_cd"))	
	
	dw_1.SetItem(iCurRow,"confirm",   sAutoConfirm)		
NEXT
uo_progress.Visible = False

sle_msg.text = '자금소요 고정항목으로 생성 완료'
SetPointer(Arrow!)

Return 1
end function

on w_kfia70.create
int iCurrent
call super::create
this.cbx_los=create cbx_los
this.cbx_paybil=create cbx_paybil
this.cbx_gyel=create cbx_gyel
this.cbx_clear=create cbx_clear
this.gb_1=create gb_1
this.dw_1=create dw_1
this.dw_list=create dw_list
this.uo_progress=create uo_progress
this.cbx_rcvbil=create cbx_rcvbil
this.cbx_jzs=create cbx_jzs
this.cbx_ls=create cbx_ls
this.cbx_cb=create cbx_cb
this.cbx_dpt=create cbx_dpt
this.cbx_fix=create cbx_fix
this.dw_ins=create dw_ins
this.cbx_dpt_man=create cbx_dpt_man
this.cbx_card=create cbx_card
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_los
this.Control[iCurrent+2]=this.cbx_paybil
this.Control[iCurrent+3]=this.cbx_gyel
this.Control[iCurrent+4]=this.cbx_clear
this.Control[iCurrent+5]=this.gb_1
this.Control[iCurrent+6]=this.dw_1
this.Control[iCurrent+7]=this.dw_list
this.Control[iCurrent+8]=this.uo_progress
this.Control[iCurrent+9]=this.cbx_rcvbil
this.Control[iCurrent+10]=this.cbx_jzs
this.Control[iCurrent+11]=this.cbx_ls
this.Control[iCurrent+12]=this.cbx_cb
this.Control[iCurrent+13]=this.cbx_dpt
this.Control[iCurrent+14]=this.cbx_fix
this.Control[iCurrent+15]=this.dw_ins
this.Control[iCurrent+16]=this.cbx_dpt_man
this.Control[iCurrent+17]=this.cbx_card
this.Control[iCurrent+18]=this.rr_1
end on

on w_kfia70.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_los)
destroy(this.cbx_paybil)
destroy(this.cbx_gyel)
destroy(this.cbx_clear)
destroy(this.gb_1)
destroy(this.dw_1)
destroy(this.dw_list)
destroy(this.uo_progress)
destroy(this.cbx_rcvbil)
destroy(this.cbx_jzs)
destroy(this.cbx_ls)
destroy(this.cbx_cb)
destroy(this.cbx_dpt)
destroy(this.cbx_fix)
destroy(this.dw_ins)
destroy(this.cbx_dpt_man)
destroy(this.cbx_card)
destroy(this.rr_1)
end on

event open;call super::open;
dw_ins.SetTransObject(Sqlca)
dw_ins.Reset()
dw_ins.InsertRow(0)

dw_ins.SetItem(1,"saupj",			Gs_Saupj)
dw_ins.SetItem(1,"syearmonth",	Left(F_Today(),6))
dw_ins.SetItem(1,"deptcode",		Gs_Dept)
dw_ins.SetItem(1,"deptnm",		   F_Get_PersonLst('3',Gs_Dept,'%'))

dw_1.SetTransObject(Sqlca)
dw_1.Reset()

uo_progress.Visible = False

IF F_Authority_Fund_Chk(Gs_Dept) = -1 THEN
	dw_ins.Modify('saupj.protect = 1')
	dw_ins.Modify('deptcode.protect = 1') 
Else
	dw_ins.Modify('saupj.protect = 0')
	dw_ins.Modify('deptcode.protect = 0')
End if

dw_1.Retrieve(Gs_Saupj,Left(F_Today(),6),Gs_Dept)

dw_ins.SetFocus()

/*자동확정 여부*/
select substr(dataname,1,1) into :sAutoConfirm	from syscnfg where sysgu = 'A' and serial = 19 and lineno = '20';
if sqlca.sqlcode = 0 then
	if IsNull(sAutoConFirm) or sAutoConFirm = '' then sAutoConFirm = 'N'
else
	sAutoConFirm = 'N'
end if
end event

type dw_insert from w_inherite`dw_insert within w_kfia70
boolean visible = false
integer x = 87
integer y = 2716
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kfia70
boolean visible = false
integer x = 3502
integer y = 3236
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kfia70
boolean visible = false
integer x = 3328
integer y = 3236
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kfia70
integer x = 3922
integer taborder = 120
string picturename = "C:\erpman\image\생성_up.gif"
end type

event p_search::clicked;call super::clicked;String  sSaupj,sDept,sYearMonth
Integer iBefCnt,i

dw_ins.AcceptText()
sSaupj     = dw_ins.GetItemString(1,"saupj")
sYearMonth = Trim(dw_ins.GetItemString(1,"syearmonth"))
sDept      = dw_ins.GetItemString(1,"deptcode")

IF sSaupj = "" OR IsNull(sSaupj) THEN 
	F_MessageChk(1,'[사업장]')
	dw_ins.SetColumn("saupj")
	dw_ins.SetFocus()
	Return
END IF

IF sYearMonth = "" OR IsNull(sYearMonth) THEN 
	F_MessageChk(1,'[처리대상년월]')
	dw_ins.SetColumn("syearmonth")
	dw_ins.SetFocus()
	Return
END IF

IF sDept = "" OR IsNull(sDept) THEN 
	F_MessageChk(1,'[작성부서]')
	dw_ins.SetColumn("deptcode")
	dw_ins.SetFocus()
	Return
END IF

IF cbx_clear.Checked = False AND cbx_gyel.Checked = False AND &
	cbx_paybil.Checked = False AND cbx_los.Checked = False AND &
	cbx_rcvbil.Checked = False AND cbx_jzs.Checked = False AND &
	cbx_ls.Checked = False AND cbx_cb.Checked = False AND &
	cbx_dpt.Checked = False AND cbx_fix.Checked = False AND &
	cbx_dpt_man.Checked = False AND cbx_card.Checked = False THEN
	F_MessageChk(11,'')
	Return
END IF

IF cbx_clear.Checked = True THEN										/*초기화 후 처리*/
	iBefCnt = dw_1.Retrieve(sSaupj,sYearMonth,sDept)
	IF iBefCnt > 0 THEN
		w_mdi_frame.sle_msg.text = '처리대상년월의 자료 삭제 중...'
		SetPointer(HourGlass!)
		FOR i = iBefCnt TO 1 STEP -1
			dw_1.DeleteRow(i)
		NEXT
		IF dw_1.Update() <> 1 THEN
			F_MessageChk(12,'')
			Rollback;
			Return
		END IF
		Commit;
		w_mdi_frame.sle_msg.text = '처리대상년월의 자료 삭제 완료'
		SetPointer(Arrow!)
	END IF
ELSE
	dw_1.Retrieve(sSaupj,sYearMonth,sDept)
END IF

IF cbx_gyel.Checked = True THEN											/*예정결제일 기준 생성*/
	IF Wf_Create_Gyul_Date(sYearMonth) = -1 THEN
		F_MessageChk(13,'')
		Rollback;
		Return
	END IF
END IF

IF cbx_paybil.Checked = True THEN											/*지급어음 기준 생성*/
	IF Wf_Create_PayBill(sYearMonth) = -1 THEN
		F_MessageChk(13,'')
		Rollback;
		Return
	END IF
END IF

IF cbx_rcvbil.Checked = True THEN											/*받을어음 기준 생성*/
	IF Wf_Create_RcvBill(sYearMonth) = -1 THEN
		F_MessageChk(13,'')
		Rollback;
		Return
	END IF
END IF

IF cbx_los.Checked = True THEN											/*차입금상환계획 기준 생성*/
	IF Wf_Create_Los(sYearMonth) = -1 THEN
		F_MessageChk(13,'')
		Rollback;
		Return
	END IF
END IF

IF cbx_jzs.Checked = True THEN											/*유가증권 기준 생성*/
	IF Wf_Create_Jzs(sYearMonth) = -1 THEN
		F_MessageChk(13,'')
		Rollback;
		Return
	END IF
END IF

IF cbx_ls.Checked = True THEN											/*리스상환계획 기준 생성*/
	IF Wf_Create_Ls(sYearMonth) = -1 THEN
		F_MessageChk(13,'')
		Rollback;
		Return
	END IF
END IF

IF cbx_cb.Checked = True THEN											/*회사채 상환 계획 기준 생성*/
	IF Wf_Create_Cb(sYearMonth) = -1 THEN
		F_MessageChk(13,'')
		Rollback;
		Return
	END IF
END IF

IF cbx_dpt.Checked = True THEN											/*적부금 월불입액 기준 생성*/
	IF Wf_Create_Dpt(sYearMonth) = -1 THEN
		F_MessageChk(13,'')
		Rollback;
		Return
	END IF
END IF
IF cbx_fix.Checked = True THEN											/*자금수지고정항목 기준 생성*/
	IF Wf_Create_Fix(sYearMonth) = -1 THEN
		F_MessageChk(13,'')
		Rollback;
		Return
	END IF
END IF
IF cbx_dpt_man.Checked = True THEN									/*적부금 만기입금 기준 생성*/
	IF Wf_Create_Dpt_Man(sYearMonth) = -1 THEN
		F_MessageChk(13,'')
		Rollback;
		Return
	END IF
END IF
IF cbx_card.Checked = True THEN										/*구매카드 생성*/
	IF Wf_Create_Card(sYearMonth) = -1 THEN
		F_MessageChk(13,'')
		Rollback;
		Return
	END IF
END IF
p_mod.Enabled = True
end event

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\생성_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\생성_up.gif"
end event

type p_ins from w_inherite`p_ins within w_kfia70
boolean visible = false
integer x = 3154
integer y = 3236
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_kfia70
integer taborder = 150
end type

type p_can from w_inherite`p_can within w_kfia70
integer taborder = 140
end type

event p_can::clicked;call super::clicked;String  sSaupj,sDept,sYearMonth

dw_ins.AcceptText()
sSaupj     = dw_ins.GetItemString(1,"saupj")
sYearMonth = Trim(dw_ins.GetItemString(1,"syearmonth"))
sDept      = dw_ins.GetItemString(1,"deptcode")

dw_1.Retrieve(sSaupj,sYearMonth,sDept)
p_mod.Enabled = False

end event

type p_print from w_inherite`p_print within w_kfia70
boolean visible = false
integer x = 2807
integer y = 3236
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kfia70
boolean visible = false
integer x = 2981
integer y = 3236
integer taborder = 0
end type

type p_del from w_inherite`p_del within w_kfia70
boolean visible = false
integer x = 3849
integer y = 3236
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_kfia70
integer x = 4096
integer taborder = 130
boolean enabled = false
end type

event p_mod::clicked;call super::clicked;Integer k
String  sSaupj,sDept,sYearMonth

dw_ins.AcceptText()
sSaupj     = dw_ins.GetItemString(1,"saupj")
sYearMonth = Trim(dw_ins.GetItemString(1,"syearmonth"))
sDept      = dw_ins.GetItemString(1,"deptcode")

sle_msg.text = ''

dw_1.AcceptText()
IF dw_1.RowCount() <=0 THEN Return

IF F_DbConFirm('저장') = 2 THEN Return

SetPointer(HourGlass!)

dw_1.SetSort("plan_day A")
dw_1.Sort()

FOR k = 1 TO dw_1.RowCount()
	dw_1.SetItem(k,"seq_no",  String(k,'000'))	
	dw_1.SetItem(k,"saupj",   sSaupj)	
	dw_1.SetItem(k,"Dept_cd", sDept)	
NEXT

IF dw_1.Update() <> 1 THEN
	F_MessageChk(13,'')
	Rollback;
	Return
END IF
Commit;

SetPointer(Arrow!)

p_mod.Enabled = False

w_mdi_frame.sle_msg.text = '자료를 저장하였습니다!!'
end event

type cb_exit from w_inherite`cb_exit within w_kfia70
boolean visible = false
integer x = 3671
integer y = 3124
end type

type cb_mod from w_inherite`cb_mod within w_kfia70
boolean visible = false
integer x = 2967
integer y = 3124
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within w_kfia70
boolean visible = false
integer x = 1746
integer y = 3132
end type

type cb_del from w_inherite`cb_del within w_kfia70
boolean visible = false
integer x = 1650
integer y = 2784
end type

type cb_inq from w_inherite`cb_inq within w_kfia70
boolean visible = false
integer x = 1399
integer y = 3132
end type

type cb_print from w_inherite`cb_print within w_kfia70
boolean visible = false
integer x = 2094
integer y = 3128
end type

type st_1 from w_inherite`st_1 within w_kfia70
boolean visible = false
end type

type cb_can from w_inherite`cb_can within w_kfia70
boolean visible = false
integer x = 3323
integer y = 3124
end type

type cb_search from w_inherite`cb_search within w_kfia70
boolean visible = false
integer x = 2446
integer y = 3124
integer width = 498
string text = "자료생성(&W)"
end type

type dw_datetime from w_inherite`dw_datetime within w_kfia70
boolean visible = false
integer x = 2871
end type

type sle_msg from w_inherite`sle_msg within w_kfia70
boolean visible = false
integer width = 2487
end type

type gb_10 from w_inherite`gb_10 within w_kfia70
boolean visible = false
end type

type gb_button1 from w_inherite`gb_button1 within w_kfia70
boolean visible = false
integer x = 859
integer y = 2732
end type

type gb_button2 from w_inherite`gb_button2 within w_kfia70
boolean visible = false
integer x = 1966
integer y = 2868
integer width = 1641
end type

type cbx_los from checkbox within w_kfia70
integer x = 2821
integer y = 208
integer width = 974
integer height = 76
integer taborder = 50
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "차입금 상환계획 기준(이자포함)"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

type cbx_paybil from checkbox within w_kfia70
integer x = 1115
integer y = 208
integer width = 745
integer height = 76
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "지급어음 만기결제일 기준"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

type cbx_gyel from checkbox within w_kfia70
boolean visible = false
integer x = 1906
integer y = 3284
integer width = 521
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "예정결제일 기준"
boolean automatic = false
borderstyle borderstyle = stylelowered!
end type

type cbx_clear from checkbox within w_kfia70
integer x = 101
integer y = 208
integer width = 974
integer height = 76
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "대상년월의 기존자료 삭제 후 처리"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_kfia70
integer x = 73
integer y = 160
integer width = 4539
integer height = 204
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "처리 대상"
borderstyle borderstyle = stylelowered!
end type

type dw_1 from datawindow within w_kfia70
integer x = 82
integer y = 384
integer width = 4517
integer height = 1844
boolean bringtotop = true
string dataobject = "dw_kfia701"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type dw_list from datawindow within w_kfia70
boolean visible = false
integer x = 896
integer y = 2784
integer width = 695
integer height = 104
boolean bringtotop = true
boolean titlebar = true
string title = "처리대상"
string dataobject = "dw_kfia706"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type uo_progress from u_progress_bar within w_kfia70
integer x = 73
integer y = 2256
integer width = 827
integer height = 76
end type

on uo_progress.destroy
call u_progress_bar::destroy
end on

type cbx_rcvbil from checkbox within w_kfia70
integer x = 1915
integer y = 208
integer width = 814
integer height = 76
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "받을어음 만기결제일 기준"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

type cbx_jzs from checkbox within w_kfia70
integer x = 3895
integer y = 208
integer width = 654
integer height = 76
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "유가증권  만기 기준"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

type cbx_ls from checkbox within w_kfia70
integer x = 101
integer y = 272
integer width = 974
integer height = 76
integer taborder = 70
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "리스상환계획 기준"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

type cbx_cb from checkbox within w_kfia70
integer x = 1115
integer y = 272
integer width = 745
integer height = 76
integer taborder = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "회사채 상환계획 기준"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

type cbx_dpt from checkbox within w_kfia70
integer x = 1915
integer y = 272
integer width = 731
integer height = 76
integer taborder = 90
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "적부금 월불입액 기준"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

type cbx_fix from checkbox within w_kfia70
integer x = 2821
integer y = 272
integer width = 974
integer height = 76
integer taborder = 100
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "자금수지계획 고정항목"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

type dw_ins from datawindow within w_kfia70
event ue_enter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 69
integer width = 3077
integer height = 140
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_kfia70"
boolean border = false
boolean livescroll = true
end type

event ue_enter;send(handle(this), 256, 9, 0)

return 1
end event

event ue_key;if keydown(keyF1!) or keydown(keytab!) then
	triggerevent(rbuttondown!)
end if
end event

event itemchanged;string sYearMonth, sSaupj, sDept,sDeptName,snull

SetNull(snull)

If this.GetColumnName() = 'saupj' then
	sSaupj = this.GetText()
	IF sSaupj = '' OR IsNull(sSaupj) THEN Return
	
	sYearMonth = Trim(this.GetItemString(1, "syearmonth"))
	If sSaupj = '' or IsNull(sSaupj) then Return
	
	sDept  = this.GetItemString(1,"deptcode")
	IF sDept = '' OR IsNull(sDept) THEN Return
	
	dw_1.Retrieve(sSaupj, sYearMonth,sDept)
	
End If

if this.GetColumnName() = 'syearmonth' then
	sYearMonth = Trim(this.GetText())
	if sYearMonth = '' or isnull(sYearMonth) then return 
	
	sSaupj = this.GetItemString(1,"saupj")
	IF sSaupj = '' OR IsNull(sSaupj) THEN Return
	
	sDept  = this.GetItemString(1,"deptcode")
	IF sDept = '' OR IsNull(sDept) THEN Return
	
	if F_dateChk(sYearMonth +'01') = -1 then 
		MessageBox("확 인", "유효한 회계년월이 아닙니다.!!")
		this.SetItem(1,"acc_yymm",snull)
		return 1
	end if
	
	dw_1.Retrieve(sSaupj,sYearMonth, sDept)
end if

If this.GetColumnName() = 'deptcode' then
	sDept = this.GetText()
	If Trim(sDept) = '' or IsNull(sDept) Then
		this.SetItem(1,"deptnm",snull)
		Return
	end if
	
	sSaupj = this.GetItemString(1,"saupj")
	IF sSaupj = '' OR IsNull(sSaupj) THEN Return
	
	sYearMonth  = Trim(this.GetItemString(1,"syearmonth"))
	IF sYearMonth = '' OR IsNull(sYearMonth) THEN Return
	
	sDeptName = F_Get_PersonLst('3',sDept,'%')
	IF IsNull(sDeptName) THEN
//		F_MessageChk(20,'[작성부서]')
//		this.SetItem(1,"deptcode",snull)
//		this.SetItem(1,"deptnm",snull)
//		return 1
	ELSE
		this.SetItem(1,"deptnm",sDeptName)
	END IF
	
//	dw_1.Retrieve(sSaupj,sYearMonth, sDept)
End If
end event

event itemerror;Return 1
end event

event getfocus;this.AcceptText()
end event

event rbuttondown;this.accepttext()

IF this.GetColumnName() ="deptcode" THEN
	
	SetNull(lstr_custom.code)
	SetNull(lstr_custom.name)

	IF IsNull(lstr_custom.code) THEN
		lstr_custom.code = ""
	END IF
	
	lstr_custom.code = this.object.deptcode[1]
	
	OpenWithParm(W_KFZ04OM0_POPUP,'3')
	
	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
	
	this.SetItem(this.GetRow(),"deptcode", lstr_custom.code)
	this.SetItem(this.GetRow(),"deptnm",   lstr_custom.name)
END IF
end event

type cbx_dpt_man from checkbox within w_kfia70
integer x = 3895
integer y = 272
integer width = 654
integer height = 76
integer taborder = 110
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "적부금 만기일 기준"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

type cbx_card from checkbox within w_kfia70
boolean visible = false
integer x = 2423
integer y = 3284
integer width = 302
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "구매카드"
boolean automatic = false
borderstyle borderstyle = stylelowered!
end type

type rr_1 from roundrectangle within w_kfia70
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 69
integer y = 380
integer width = 4539
integer height = 1860
integer cornerheight = 40
integer cornerwidth = 55
end type

