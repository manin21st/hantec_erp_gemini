$PBExportHeader$w_pip2109.srw
$PBExportComments$** 급여계산
forward
global type w_pip2109 from w_inherite_standard
end type
type st_13 from statictext within w_pip2109
end type
type st_12 from statictext within w_pip2109
end type
type st_10 from statictext within w_pip2109
end type
type pb_2 from picturebutton within w_pip2109
end type
type pb_1 from picturebutton within w_pip2109
end type
type dw_err from datawindow within w_pip2109
end type
type dw_total from u_d_select_sort within w_pip2109
end type
type dw_personal from u_d_select_sort within w_pip2109
end type
type p_compute from picture within w_pip2109
end type
type uo_progress from u_progress_bar within w_pip2109
end type
type rr_2 from roundrectangle within w_pip2109
end type
type rr_6 from roundrectangle within w_pip2109
end type
type rr_7 from roundrectangle within w_pip2109
end type
type rr_8 from roundrectangle within w_pip2109
end type
type dw_ip from u_key_enter within w_pip2109
end type
end forward

global type w_pip2109 from w_inherite_standard
string title = "급여계산"
boolean resizable = false
event ue_process pbm_custom04
st_13 st_13
st_12 st_12
st_10 st_10
pb_2 pb_2
pb_1 pb_1
dw_err dw_err
dw_total dw_total
dw_personal dw_personal
p_compute p_compute
uo_progress uo_progress
rr_2 rr_2
rr_6 rr_6
rr_7 rr_7
rr_8 rr_8
dw_ip dw_ip
end type
global w_pip2109 w_pip2109

type variables
DataWindow dw_Process

Integer           il_RowCount,iAry_EditChild =0
String             Is_PbTag = 'P',ls_gubn
Double          Id_NoTax_Sub = 0                     //비과세공제

String print_gu                 //window가 조회인지 인쇄인지  

String     is_preview        // dw상태가 preview인지
Integer   ii_factor = 100           // 프린트 확대축소
boolean   iv_b_down = false
end variables

forward prototypes
public subroutine wf_magamcheck ()
public function string wf_proceduresql ()
end prototypes

event ue_process;//String sbef_worktag
//Int i,rt,il_rowCount,il_meterPosition
//
//sle_start.text = string(now())
//
//mm = integer(mid(em_date.text,6,2))
//
//swork_ym = Left(em_date.text,4)+Right(em_date.text,2)
//startdate = Left(em_date.text,4)+Right(em_date.text,2) + "01"
//enddate = Left(em_date.text,4)+Right(em_date.text,2)  + STRING(idd_dd[mm])
//
//// 입력받은 년월의 급여편집자료가 있는지 확인
//SELECT DISTINCT workym 
//	INTO :sbef_worktag
//   FROM p3_editdata
//   WHERE (companycode = :gs_company) and  workym = :swork_ym AND pbtag = :iv_pbtag ;
//
//If (sqlca.sqlcode = 0) then              //작업년월의 자료가 이미 존재한다는 의미
//	IF messagebox ("자료존재", "재작업을 하시겠읍니까?",exclamation!,yesno!,2) = 1 THEN
//   ELSE
//      em_date.setfocus()
//      return
//   END IF
//END IF
//
//string ls_job
//
//setpointer(hourglass!)
//
//SELECT worktag
//    INTO :ls_job  
//    FROM "P3_JOBTAG"  
//   WHERE ( "P3_JOBTAG"."COMPANYCODE" = :gs_company ) AND  
//         ( "P3_JOBTAG"."WORKYM" = :swork_ym ) AND  
//         ( "P3_JOBTAG"."PBTAG" = 'P' )   ;
//if ls_job  = 'Y' then
//	messagebox ( "주의", "작업이 완료되었습니다.!")
//	return
//end if
//
//i = 0
//wrtcnt = 0
//
//uo_progress.Show()
//
//if rb_all.checked then     //작업대상(전체)
//	dw_1.setredraw(false)
//   if wf_editdata_delete_f() = false then return      //해당년월의 자료를 모두 삭제한다
//
//	il_rowCount = dw_1.RowCount()
//	
//	for i = 1 to il_rowCount
//		
//		il_meterPosition = (i/ il_rowCount) * 100
//		uo_progress.uf_set_position (il_meterPosition)
//	
//		iv_empno = dw_1.getitemstring(i, "empno")
//      iv_empname = dw_1.getitemstring(i, "empname")
//		
//      PN = PN1
//      ED = ED1
//
//		dw_saving.reset()
//		dw_pension.reset()
//
//      wf_except_data()            //급여예외자료 check
//
//      if (iv_userec = "N") then  CONTINUE              //강제제외자면 skip
//
//      //개인별 급여자료 처리 
//      IF wf_personal_read() = -1 THEN CONTINUE
//			
//		//지급부분 계산 
//		wf_monthchg_data('1')
//		
//      //공제부분 계산 : 세금계산 포함
//		wf_sub_calculation()
// 		// 급여편집 자료에 계산된 자료를 WRITE 한다
//		if wf_editdata_insert() = 1 then
//			commit;
//     	else
//        	rollback;
//	   end if
//	next	
//	dw_1.setredraw(true)
//else                      //작업대상(일부)
//	
//	il_rowCount = dw_2.RowCount()
//	for i = 1 to il_rowCount
//		
//		il_meterPosition = (i/ il_rowCount) * 100
//		uo_progress.uf_set_position (il_meterPosition)
//		
//		iv_empno = dw_2.getitemstring(i, "empno")
//      iv_empname = dw_2.getitemstring(i, "empname")
//
//		dw_saving.reset()
//		dw_pension.reset()
//
//		//급여대상자를 삭제한다
//      if wf_editdata_delete_p() = false then CONTINUE
//    
//      PN = PN1
//      ED = ED1
//   
//   	wf_except_data()           //급여예외자료 check
//
//      if (iv_userec = "N") then CONTINUE  //강제제외자면 skip 
//
//      //개인별 급여자료 처리 
//      wf_personal_read()           	  
//		
//		//지급부분 계산 
//		wf_monthchg_data('1')
//		
//      //공제부분 계산 : 세금계산 포함
//		wf_sub_calculation()
// 		// 급여편집 자료에 계산된 자료를 WRITE 한다
//		 
//		if wf_editdata_insert() = 1 then
//			commit;
//     	else
//        	rollback;
//	   end if
//   next	
//end if
//
//f_insa_static(gs_company,swork_ym) 
//
//uo_progress.Hide()
//
//setpointer(arrow!)
//sle_end.text = string(now())
//messagebox("작업완료 !!", "작업이 완료되었습니다.(" + string(wrtcnt, "####") + "건)")
//
//
end event

public subroutine wf_magamcheck ();String sPayMagamGbn, sworkym, sSaup

dw_ip.Accepttext()

sworkym = dw_ip.GetitemString(1,'workym')
sSaup = dw_ip.GetItemString(1,'saup')
IF ISNULL(sSaup) OR sSaup = '' THEN sSaup = '10'

SELECT "P8_PAYFLAG"."CLYN"  		INTO :sPayMagamGbn  
	FROM "P8_PAYFLAG"
   WHERE ( "P8_PAYFLAG"."COMPANYCODE" = :Gs_Company ) AND  
         ( "P8_PAYFLAG"."CLYEARMM" = :sworkym) AND
			( "P8_PAYFLAG"."CLGUBN" = :is_Pbtag ) AND
			( "P8_PAYFLAG"."SAUPCD" = :sSaup );
			
IF SQLCA.SQLCODE <> 0 THEN
	sPayMagamGbn = 'N'
ELSE
	IF IsNull(sPayMaGamGbn) THEN sPayMagamGbn = 'N'
END IF

IF sPayMagamGbn = 'Y' THEN
	MessageBox("확 인","이미 마감 처리되었습니다. 마감 취소 후 작업하세요!!")
	p_compute.Enabled = False
	p_compute.PictureName = "C:\erpman\image\계산_d.gif"

ELSE
   p_compute.Enabled = True
	p_compute.PictureName = "C:\erpman\image\계산_up.gif"
END IF



end subroutine

public function string wf_proceduresql ();
Int    k 
String sGetSqlSyntax,sEmpNo
Long   lSyntaxLength

sGetSqlSyntax = 'select empno,jikjonggubn,enterdate,retiredate,jhgubn,paygubn,consmatgubn,kmgubn,engineergubn from p1_master'

dw_Process.AcceptText()

sGetSqlSyntax = sGetSqlSyntax + ' where ('

FOR k = 1 TO il_rowcount
	
	sEmpNo = dw_Process.GetItemString(k,"empno")
	
	sGetSqlSyntax = sGetSqlSyntax + ' (empno =' + "'"+ sEmpNo +"')"+ ' or'
	
NEXT

lSyntaxLength = len(sGetSqlSyntax)
sGetSqlSyntax    = Mid(sGetSqlSyntax,1,lSyntaxLength - 2)

sGetSqlSyntax = sGetSqlSyntax + ")"

Return sGetSqlSynTax


end function

on w_pip2109.create
int iCurrent
call super::create
this.st_13=create st_13
this.st_12=create st_12
this.st_10=create st_10
this.pb_2=create pb_2
this.pb_1=create pb_1
this.dw_err=create dw_err
this.dw_total=create dw_total
this.dw_personal=create dw_personal
this.p_compute=create p_compute
this.uo_progress=create uo_progress
this.rr_2=create rr_2
this.rr_6=create rr_6
this.rr_7=create rr_7
this.rr_8=create rr_8
this.dw_ip=create dw_ip
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_13
this.Control[iCurrent+2]=this.st_12
this.Control[iCurrent+3]=this.st_10
this.Control[iCurrent+4]=this.pb_2
this.Control[iCurrent+5]=this.pb_1
this.Control[iCurrent+6]=this.dw_err
this.Control[iCurrent+7]=this.dw_total
this.Control[iCurrent+8]=this.dw_personal
this.Control[iCurrent+9]=this.p_compute
this.Control[iCurrent+10]=this.uo_progress
this.Control[iCurrent+11]=this.rr_2
this.Control[iCurrent+12]=this.rr_6
this.Control[iCurrent+13]=this.rr_7
this.Control[iCurrent+14]=this.rr_8
this.Control[iCurrent+15]=this.dw_ip
end on

on w_pip2109.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_13)
destroy(this.st_12)
destroy(this.st_10)
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.dw_err)
destroy(this.dw_total)
destroy(this.dw_personal)
destroy(this.p_compute)
destroy(this.uo_progress)
destroy(this.rr_2)
destroy(this.rr_6)
destroy(this.rr_7)
destroy(this.rr_8)
destroy(this.dw_ip)
end on

event open;call super::open;
w_mdi_frame.sle_msg.text =""

ib_any_typing=False

dw_datetime.SetTransObject(SQLCA)
dw_datetime.Reset()
dw_datetime.InsertRow(0)

dw_total.settransobject(SQLCA)
dw_personal.settransobject(SQLCA)
dw_err.settransobject(SQLCA)

uo_progress.Hide()

dw_ip.SetTransObject(SQLCA)
dw_ip.InsertRow(0)

f_set_saupcd(dw_ip, 'saup', '1')
is_saupcd = gs_saupcd

dw_ip.object.workym[1] = f_aftermonth(left(f_today(),6),-1)
dw_ip.object.target[1] = '1'
dw_ip.object.payday[1] = f_today()
dw_ip.object.payrate[1] = '100'

dw_err.reset()

pb_1.picturename = "C:\erpman\Image\next.gif"
pb_2.picturename = "C:\erpman\Image\prior.gif"

//pb_1.picturename = "C:\erpman\Image\next_1.bmp"
//pb_2.picturename = "C:\erpman\Image\prior_1.bmp"

dw_ip.SetColumn("workym")
dw_ip.SetFocus()

p_inq.Triggerevent(Clicked!)
end event

event key;call super::key;Choose Case key
	Case KeyB!
		p_search.TriggerEvent(Clicked!)
	
End Choose
end event

type p_mod from w_inherite_standard`p_mod within w_pip2109
boolean visible = false
integer x = 2039
integer y = 2400
end type

type p_del from w_inherite_standard`p_del within w_pip2109
boolean visible = false
integer x = 2213
integer y = 2400
end type

type p_inq from w_inherite_standard`p_inq within w_pip2109
integer x = 3945
integer y = 28
end type

event p_inq::clicked;call super::clicked;String sStartDate,sEndDate,sFromDate,sToDate, sSaup, sJikjong, sKunmu

dw_total.Reset()
dw_personal.Reset()
dw_err.Reset()

/* 급여지급 대상기간 */
string sdata1, sdata2,sprocdate

sprocdate	= trim(dw_ip.GetItemString(1,"workym"))
sSaup			= trim(dw_ip.GetItemString(1,"saup"))
sJikjong		= trim(dw_ip.GetItemString(1,"jikjong"))
sKunmu		= trim(dw_ip.GetItemString(1,"kunmu"))

IF sSaup = '' OR IsNull(sSaup) THEN	sSaup = '%' 
IF sJikjong = '' or isnull(sJikjong) THEN	sJikjong = '%'
IF sKunmu = '' OR IsNull(sKunmu) THEN sKunmu = '%'

SELECT "P0_REF"."CODENM",     "P0_REF"."CODENM1"  
  INTO :sdata1,      :sdata2  
  FROM "P0_REF"  
 WHERE ( "P0_REF"."CODEGBN" = 'CP' ) AND  
       ( "P0_REF"."CODE" = substr(:sprocdate,5,2) )   ;
		                                            
																  /* 직종구분 '1' = 관리직 */																  
sStartDate = left(sprocdate,4)+ mid(sdata1,5,4)   

if mid(sprocdate,5,2) = '01' and left(sdata1,4) < mid(sdata1,10,4) then
	sStartdate = string(long(left(sStartdate,4)) - 1) + right(sStartdate,4)
end if

sEndDate   = left(sprocdate,4)+ mid(sdata1,14,4)
                                                 /* 직종구분 '2' = 생산직 */
sFromDate = left(sprocdate,4)+ mid(sdata2,5,4)  
if mid(sprocdate,5,2) = '01' and left(sdata2,4) < mid(sdata2,10,4) then
	sFromDate = string(long(left(sFromDate,4)) - 1) + right(sFromDate,4)
end if

sToDate   = left(sprocdate,4)+ mid(sdata2,14,4)

IF dw_total.Retrieve(Gs_Company,sStartDate,sEndDate,sFromDate,sToDate, sSaup, sJikjong, sKunmu) <=0 THEN
	MessageBox("확 인","처리할 자료가 없습니다!!",StopSign!)
	dw_ip.SetColumn("workym")
	dw_ip.SetFocus()
	Return
END IF

wf_magamcheck()

w_mdi_frame.sle_msg.text =""


end event

type p_print from w_inherite_standard`p_print within w_pip2109
boolean visible = false
integer x = 1344
integer y = 2400
end type

type p_can from w_inherite_standard`p_can within w_pip2109
boolean visible = false
integer x = 2386
integer y = 2400
end type

type p_exit from w_inherite_standard`p_exit within w_pip2109
integer x = 4471
end type

type p_ins from w_inherite_standard`p_ins within w_pip2109
boolean visible = false
integer x = 1518
integer y = 2400
end type

type p_search from w_inherite_standard`p_search within w_pip2109
integer x = 4297
integer y = 28
boolean originalsize = true
string picturename = "C:\erpman\image\복사_up.gif"
end type

event p_search::clicked;call super::clicked;string ls_kyymm, ls_pyymm
int i


if dw_ip.Accepttext() = -1 then return

ls_kyymm = dw_ip.GetitemString(1,'kyymm')
ls_pyymm = dw_ip.GetitemString(1,'pyymm')

if IsNull(ls_kyymm) or ls_kyymm = '' then
	messagebox("확인", "전월 복사년월을 입력하세요!!")
	dw_ip.Setcolumn('kyymm')
	dw_ip.Setfocus()
	return
end if

select count(*) into :i
from p3_editdata
where workym = :ls_kyymm and pbtag = 'P';
  

if IsNull(i) then i = 0

if i = 0 then
	messagebox("확인", "복사년월의 급여 데이타가 없습니다!!")
	dw_ip.Setcolumn('kyymm')
	dw_ip.Setfocus()
	return
end if


if IsNull(ls_pyymm) or ls_pyymm = '' then
	messagebox("확인", "복사할 년월을 입력하세요!!")
	dw_ip.Setcolumn('pyymm')
	dw_ip.Setfocus()
	return
else
	if f_datechk(ls_pyymm+'01') = -1 then
		messagebox("확인","복사할 년월을 확인하세요!!")
		dw_ip.Setcolumn('pyymm')
	   dw_ip.Setfocus()
	   return
	end if	
end if

if messagebox("복사",left(ls_kyymm,4)+'년 '+right(ls_kyymm,2)+'월 급여데이타를 '+ &
               left(ls_pyymm,4)+'년 '+right(ls_pyymm,2)+'월로 복사하시겠습니까?', Question!,YesNo!) = 2 then return
					
if messagebox("확인","사업장별로 복사할 월에 자료가 있으면 삭제하고 복사합니다!", Exclamation!,YesNo!) = 2 then return					
					
Setpointer(HourGlass!)

delete from p3_editdata where workym = :ls_pyymm and pbtag = 'P' and fun_get_saupcd(empno) like :is_saupcd;

INSERT INTO "P3_EDITDATA"  
         ( "WORKYM",                   "PBTAG",                    "EMPNO",                    "JIKJONGGUBN",              "DEPTCODE",   
           "ORGDEPTCODE",              "PROJECTCODE",              "GRADECODE",                "LEVELCODE",                "SALARY",   
           "BASEPAY",                  "FIXEDPAY",                 "TONGPAY",                  "YJTAXFREE",                "ETCTAXFREE",   
           "MSTPAY",                   "TAXTOTPAY",                "WORKINCOMEAMT",            "TAXSTANDARDAMT",           "WORKINCOMETAXSUB",   
           "TOTPAYAMT",                "TOTSUBAMT",                "NETPAYAMT",                "WORKDATE",                 "PAYRATE",   
           "ALLOWAMT101",              "ALLOWAMT102",              "ALLOWAMT103",              "ALLOWAMT104",              "ALLOWAMT105",   
           "ALLOWAMT106",              "ALLOWAMT107",              "ALLOWAMT108",              "ALLOWAMT109",              "ALLOWAMT110",   
           "ALLOWAMT111",              "ALLOWAMT112",              "ALLOWAMT113",              "ALLOWAMT114",              "ALLOWAMT115",   
           "ALLOWAMT116",              "ALLOWAMT117",              "ALLOWAMT118",              "ALLOWAMT119",              "ALLOWAMT120",   
           "ALLOWAMT121",              "ALLOWAMT122",              "ALLOWAMT123",              "ALLOWAMT124",              "ALLOWAMT125",   
           "ALLOWAMT126",              "ALLOWAMT127",              "ALLOWAMT128",              "ALLOWAMT129",              "ALLOWAMT130",   
           "ALLOWAMT201",              "ALLOWAMT202",              "ALLOWAMT203",              "ALLOWAMT204",              "ALLOWAMT205",   
           "ALLOWAMT206",              "ALLOWAMT207",              "ALLOWAMT208",              "ALLOWAMT209",              "ALLOWAMT210",   
           "ALLOWAMT211",              "ALLOWAMT212",              "ALLOWAMT213",              "ALLOWAMT214",              "ALLOWAMT215",   
           "ALLOWAMT216",              "ALLOWAMT217",              "ALLOWAMT218",              "ALLOWAMT219",              "ALLOWAMT220",   
           "ALLOWAMT221",              "ALLOWAMT222",              "ALLOWAMT223",              "ALLOWAMT224",              "ALLOWAMT225",   
           "JETCTAXFREE",              "JYJTAXFREE",               "JTAXTOTPAY",               "ABROADGBN",                "ABROADAMT" )  
SELECT      :ls_pyymm,                 "PBTAG",                    "EMPNO",                    "JIKJONGGUBN",              "DEPTCODE",   
           "ORGDEPTCODE",              "PROJECTCODE",              "GRADECODE",                "LEVELCODE",                "SALARY",   
           "BASEPAY",                  "FIXEDPAY",                 "TONGPAY",                  "YJTAXFREE",                "ETCTAXFREE",   
           "MSTPAY",                   "TAXTOTPAY",                "WORKINCOMEAMT",            "TAXSTANDARDAMT",           "WORKINCOMETAXSUB",   
           "TOTPAYAMT",                "TOTSUBAMT",                "NETPAYAMT",                "WORKDATE",                 "PAYRATE",   
           "ALLOWAMT101",              "ALLOWAMT102",              "ALLOWAMT103",              "ALLOWAMT104",              "ALLOWAMT105",   
           "ALLOWAMT106",              "ALLOWAMT107",              "ALLOWAMT108",              "ALLOWAMT109",              "ALLOWAMT110",   
           "ALLOWAMT111",              "ALLOWAMT112",              "ALLOWAMT113",              "ALLOWAMT114",              "ALLOWAMT115",   
           "ALLOWAMT116",              "ALLOWAMT117",              "ALLOWAMT118",              "ALLOWAMT119",              "ALLOWAMT120",   
           "ALLOWAMT121",              "ALLOWAMT122",              "ALLOWAMT123",              "ALLOWAMT124",              "ALLOWAMT125",   
           "ALLOWAMT126",              "ALLOWAMT127",              "ALLOWAMT128",              "ALLOWAMT129",              "ALLOWAMT130",   
           "ALLOWAMT201",              "ALLOWAMT202",              "ALLOWAMT203",              "ALLOWAMT204",              "ALLOWAMT205",   
           "ALLOWAMT206",              "ALLOWAMT207",              "ALLOWAMT208",              "ALLOWAMT209",              "ALLOWAMT210",   
           "ALLOWAMT211",              "ALLOWAMT212",              "ALLOWAMT213",              "ALLOWAMT214",              "ALLOWAMT215",   
           "ALLOWAMT216",              "ALLOWAMT217",              "ALLOWAMT218",              "ALLOWAMT219",              "ALLOWAMT220",   
           "ALLOWAMT221",              "ALLOWAMT222",              "ALLOWAMT223",              "ALLOWAMT224",              "ALLOWAMT225",   
           "JETCTAXFREE",              "JYJTAXFREE",               "JTAXTOTPAY",               "ABROADGBN",                "ABROADAMT"  
FROM P3_EDITDATA
WHERE WORKYM = :ls_kyymm and PBTAG = 'P' AND fun_get_saupcd(empno) like :is_saupcd;

commit;

delete from p3_editdatachild where workym = :ls_pyymm and pbtag = 'P' and fun_get_saupcd(empno) like :is_saupcd;

  INSERT INTO "P3_EDITDATACHILD"  
         ( "COMPANYCODE",           "WORKYM",              "PBTAG",              "ALLOWCODE",             "EMPNO",   
           "ALLOWAMT",              "DAYRATE",             "GUBUN",              "MSTGUBUN",              "NOTAXGUBUN",   
           "NOTAXKIND",             "TONGUBUN",            "FIXGUBUN",           "PRINTSEQ",              "PAYRATE",   
           "PAYDAY" )  
  SELECT "COMPANYCODE",            :ls_pyymm,              "PBTAG",              "ALLOWCODE",             "EMPNO",   
           "ALLOWAMT",              "DAYRATE",             "GUBUN",              "MSTGUBUN",              "NOTAXGUBUN",   
           "NOTAXKIND",             "TONGUBUN",            "FIXGUBUN",           "PRINTSEQ",              "PAYRATE",   
           "PAYDAY"
 FROM P3_EDITDATACHILD
 WHERE WORKYM = :ls_kyymm and PBTAG = 'P' AND fun_get_saupcd(empno) like :is_saupcd;
 
 commit;

Setpointer(Arrow!)

messagebox("확인","복사완료!!")





					


end event

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\복사_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\복사_up.gif"
end event

type p_addrow from w_inherite_standard`p_addrow within w_pip2109
boolean visible = false
integer x = 1691
integer y = 2400
end type

type p_delrow from w_inherite_standard`p_delrow within w_pip2109
boolean visible = false
integer x = 1865
integer y = 2400
end type

type dw_insert from w_inherite_standard`dw_insert within w_pip2109
boolean visible = false
integer x = 905
integer y = 2404
end type

type st_window from w_inherite_standard`st_window within w_pip2109
boolean visible = false
end type

type cb_exit from w_inherite_standard`cb_exit within w_pip2109
boolean visible = false
end type

type cb_update from w_inherite_standard`cb_update within w_pip2109
boolean visible = false
end type

type cb_insert from w_inherite_standard`cb_insert within w_pip2109
boolean visible = false
end type

type cb_delete from w_inherite_standard`cb_delete within w_pip2109
boolean visible = false
end type

type cb_retrieve from w_inherite_standard`cb_retrieve within w_pip2109
boolean visible = false
end type

type st_1 from w_inherite_standard`st_1 within w_pip2109
boolean visible = false
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_pip2109
boolean visible = false
end type

type dw_datetime from w_inherite_standard`dw_datetime within w_pip2109
boolean visible = false
end type

type sle_msg from w_inherite_standard`sle_msg within w_pip2109
boolean visible = false
end type

type gb_2 from w_inherite_standard`gb_2 within w_pip2109
boolean visible = false
end type

type gb_1 from w_inherite_standard`gb_1 within w_pip2109
boolean visible = false
end type

type gb_10 from w_inherite_standard`gb_10 within w_pip2109
boolean visible = false
end type

type st_13 from statictext within w_pip2109
integer x = 2821
integer y = 412
integer width = 224
integer height = 48
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
string text = "오류자"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_12 from statictext within w_pip2109
integer x = 1778
integer y = 416
integer width = 155
integer height = 48
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "개인"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_10 from statictext within w_pip2109
integer x = 631
integer y = 416
integer width = 146
integer height = 56
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "전체"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_2 from picturebutton within w_pip2109
integer x = 1559
integer y = 836
integer width = 101
integer height = 88
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "C:\erpman\Image\prior.gif"
alignment htextalign = left!
end type

event clicked;String sEmpNo,sEmpName,sLevel, sSalary,sEnterDate,sGrade,sProjectDept,sDeptCode,&
		 sJhGbn,sConsGbn,sPayGbn,sJhtGbn,sJikGbn,sRetireDate
Long   totRow , sRow,rowcnt
int i

totrow =dw_personal.Rowcount()

FOR i = 1 TO totrow 
	sRow = dw_personal.getselectedrow(0)
	
	IF sRow <=0 THEN EXIT
	
	sEmpNo       = dw_personal.GetItemString(sRow, "empno")
   sEmpName     = dw_personal.GetItemString(sRow, "empname")
	sEnterDate   = dw_personal.GetItemString(sRow, "enterdate")
	sRetireDate  = dw_personal.GetItemString(sRow, "retiredate")
	sProjectDept = dw_personal.GetItemString(sRow, "projectcode")
	sConsGbn     = dw_personal.GetItemString(sRow, "consmatgubn")
	sJhtGbn      = dw_personal.GetItemString(sRow, "jhtgubn")
	sJhGbn       = dw_personal.GetItemString(sRow, "jhgubn")
	sPayGbn      = dw_personal.GetItemString(sRow, "paygubn")
	sJikGbn      = dw_personal.GetItemString(sRow, "jikjonggubn")
	
	rowcnt = dw_total.RowCount() + 1
	
	dw_total.insertrow(rowcnt)
	dw_total.setitem(rowcnt, "empname",     sEmpName)
	dw_total.setitem(rowcnt, "empno",       sEmpNo)
	dw_total.setitem(rowcnt, "enterdate",   sEnterDate)
	dw_total.setitem(rowcnt, "retiredate",  sRetireDate)
	dw_total.setitem(rowcnt, "projectcode", sProjectDept)
	dw_total.setitem(rowcnt, "consmatgubn", sConsGbn)
	dw_total.setitem(rowcnt, "jhtgubn",     sJhtGbn)
	dw_total.setitem(rowcnt, "jhgubn",      sJhGbn)
	dw_total.setitem(rowcnt, "paygubn",     sPayGbn)
	dw_total.setitem(rowcnt, "jikjonggubn", sJikGbn)
	
	dw_personal.deleterow(sRow)
NEXT	

IF dw_personal.RowCount() > 0 THEN
	dw_ip.object.target[1] = '2'
ELSE
	dw_ip.object.target[1] = '1'
END IF	
end event

type pb_1 from picturebutton within w_pip2109
integer x = 1559
integer y = 724
integer width = 101
integer height = 88
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "C:\erpman\Image\next.gif"
alignment htextalign = left!
end type

event clicked;String sEmpNo,sEmpName,sLevel, sSalary,sEnterDate,sGrade,sProjectDept,sDeptCode,&
       sJhGbn,sConsGbn,sPayGbn,sJhtGbn,sJikGbn,sRetireDate
Long   totRow , sRow,rowcnt
int i

totrow =dw_total.Rowcount()

FOR i = 1 TO totrow 
	sRow = dw_total.getselectedrow(0)
	
	IF sRow <=0 THEN EXIT
	
	sEmpNo       = dw_total.GetItemString(sRow, "empno")
   sEmpName     = dw_total.GetItemString(sRow, "empname")
	sEnterDate   = dw_total.GetItemString(sRow, "enterdate")
	sRetireDate  = dw_total.GetItemString(sRow, "retiredate")
	sProjectDept = dw_total.GetItemString(sRow, "projectcode")
	sConsGbn     = dw_total.GetItemString(sRow, "consmatgubn")
	sJhtGbn      = dw_total.GetItemString(sRow, "jhtgubn")
	sJhGbn       = dw_total.GetItemString(sRow, "jhgubn")
	sPayGbn      = dw_total.GetItemString(sRow, "paygubn")
	sJikGbn      = dw_total.GetItemString(sRow, "jikjonggubn")
	
	rowcnt = dw_personal.RowCount() + 1
	
	dw_personal.insertrow(rowcnt)
	dw_personal.setitem(rowcnt, "empname",     sEmpName)
	dw_personal.setitem(rowcnt, "empno",       sEmpNo)
	dw_personal.setitem(rowcnt, "enterdate",   sEnterDate)
	dw_personal.setitem(rowcnt, "retiredate",  sRetireDate)
	dw_personal.setitem(rowcnt, "projectcode", sProjectDept)
	dw_personal.setitem(rowcnt, "consmatgubn", sConsGbn)
	dw_personal.setitem(rowcnt, "jhtgubn",     sJhtGbn)
	dw_personal.setitem(rowcnt, "jhgubn",      sJhGbn)
	dw_personal.setitem(rowcnt, "paygubn",     sPayGbn)
	dw_personal.setitem(rowcnt, "jikjonggubn", sJikGbn)
	
	dw_total.deleterow(sRow)
NEXT	

IF dw_personal.RowCount() > 0 THEN
	dw_ip.object.target[1] = '2'
ELSE
	dw_ip.object.target[1] = '1'
END IF	
end event

type dw_err from datawindow within w_pip2109
integer x = 2775
integer y = 468
integer width = 1129
integer height = 1788
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_pip2109_2"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;string objname, obj

obj = getobjectatpointer()
objname = f_get_token(obj, '~t')
choose case objname
	case 'p1_master_empno_t'
		setsort('#1 a')
		sort()
	case 'p1_master_empname_t'
		setsort('#2 a')
		sort()
end choose
end event

type dw_total from u_d_select_sort within w_pip2109
integer x = 567
integer y = 468
integer width = 914
integer height = 1788
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_pip2109_1"
boolean border = false
end type

event clicked;If Row <= 0 then
	b_flag =True
ELSE
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

type dw_personal from u_d_select_sort within w_pip2109
integer x = 1728
integer y = 468
integer width = 891
integer height = 1788
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_pip2109_1"
boolean border = false
end type

event clicked;If Row <= 0 then
	b_flag =True
ELSE
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

type p_compute from picture within w_pip2109
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 4123
integer y = 28
integer width = 178
integer height = 144
boolean bringtotop = true
string picturename = "C:\erpman\Image\계산_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;PictureName = "C:\erpman\image\계산_dn.gif"
end event

event ue_lbuttonup;PictureName = "C:\erpman\image\계산_up.gif"
end event

event clicked;String  sYearMonth,sYearMonthDay,sMasterSql
Integer iPayRate,il_RetrieveRow,il_meterPosition,il_currow,il_SearchRow,il_BefCount =0,k,iRtnValue

/*인사 마스타 자료*/
String  Master_EmpNo,   Master_EmpName

/*급여 계산 flag*/
String  Except_sUseGbn


sYearMonth    = dw_ip.object.workym[1]
sYearMonthDay = dw_ip.object.payday[1]
IF sYearMonthDay ="" OR IsNull(sYearMonthDay) THEN
	MessageBox("확 인","급여지급일자를 입력하세요!!")
	dw_ip.SetColumn("workym")
	dw_ip.SetFocus()
	Return
END IF

iPayRate   = Integer(Trim(dw_ip.object.payrate[1]))
IF iPayRate = 0 OR IsNull(iPayRate) THEN iPayRate = 0

IF dw_ip.object.target[1] = '1' THEN
	dw_Process = dw_Total
	il_RowCount = dw_Total.RowCount()
ELSE
	dw_Process = dw_personal
	il_RowCount = dw_personal.RowCount()
END IF

IF il_RowCount <=0 THEN
	MessageBox("확 인","처리 선택한 자료가 없습니다!!")
	Return
END IF
/* 처리년월의 급여자료가 있는지 확인*/

SELECT Count("WORKYM")
	INTO :il_BefCount
	FROM "P3_EDITDATA"
	WHERE "WORKYM" = :sYearMonth AND "PBTAG" = :Is_PbTag;

IF SQLCA.SQLCODE = 0 AND il_BefCount <> 0 AND Not IsNull(il_BefCount) THEN
	IF Messagebox ("작업 확인", "이전 급여 계산 자료가 존재합니다. 다시 작업하시겠습니까?",&
																Question!,YesNo!) = 2 THEN Return
END IF
w_mdi_frame.sle_msg.text = '급여 계산 중......'
SetPointer(HourGlass!)

dw_ip.object.starttime[1] = String(Now(),'hh:mm:ss AM/PM')

sMasterSql = wf_ProcedureSql()

iRtnValue = sqlca.sp_calculation_payamount(sYearMonth,sYearMonthDay,is_pbtag,iPayRate,sMasterSql,gs_company);

IF iRtnValue <> 1 then
	MessageBox("확 인","급여 계산 실패!!")
	Rollback;
	SetPointer(Arrow!)
	w_mdi_frame.sle_msg.text =''
	Return
END IF
commit;

dw_err.retrieve()
w_mdi_frame.sle_msg.text = '급여 계산 완료!!'
SetPointer(Arrow!)

dw_ip.object.endtime[1] = String(Now(),'hh:mm:ss AM/PM')
end event

type uo_progress from u_progress_bar within w_pip2109
boolean visible = false
integer x = 242
integer y = 2540
integer width = 1083
integer height = 72
integer taborder = 20
boolean bringtotop = true
end type

on uo_progress.destroy
call u_progress_bar::destroy
end on

type rr_2 from roundrectangle within w_pip2109
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 448
integer y = 392
integer width = 3593
integer height = 1896
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_6 from roundrectangle within w_pip2109
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 558
integer y = 436
integer width = 928
integer height = 1836
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_7 from roundrectangle within w_pip2109
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1714
integer y = 436
integer width = 928
integer height = 1836
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_8 from roundrectangle within w_pip2109
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2761
integer y = 436
integer width = 1161
integer height = 1836
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_ip from u_key_enter within w_pip2109
event ue_key pbm_dwnkey
integer x = 439
integer y = 28
integer width = 3424
integer height = 340
integer taborder = 60
string dataobject = "d_pip2109_3"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;call super::itemchanged;if AcceptText() = -1 then return -1

IF this.GetColumnName() = 'saup' THEN
	is_saupcd = this.GetText()
	
	IF is_saupcd = '' OR IsNull(is_saupcd) THEN is_saupcd = '%'
END IF

if dwo.Name = 'workym' or dwo.Name = 'saup' or dwo.Name = 'jikjong' or dwo.Name = 'kunmu' then
	p_inq.TriggerEvent(Clicked!)
end if

end event

