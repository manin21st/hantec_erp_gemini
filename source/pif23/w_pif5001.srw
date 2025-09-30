$PBExportHeader$w_pif5001.srw
$PBExportComments$** 발령 일괄 등록
forward
global type w_pif5001 from w_inherite_multi
end type
type dw_detail from datawindow within w_pif5001
end type
type gb_5 from groupbox within w_pif5001
end type
type gb_6 from groupbox within w_pif5001
end type
type gb_3 from groupbox within w_pif5001
end type
type dw_cond from u_key_enter within w_pif5001
end type
type st_2 from statictext within w_pif5001
end type
type st_3 from statictext within w_pif5001
end type
type dw_total from u_d_select_sort within w_pif5001
end type
type dw_target from u_d_select_sort within w_pif5001
end type
type pb_1 from picturebutton within w_pif5001
end type
type pb_2 from picturebutton within w_pif5001
end type
type dw_1 from datawindow within w_pif5001
end type
type rr_1 from roundrectangle within w_pif5001
end type
type rr_2 from roundrectangle within w_pif5001
end type
end forward

global type w_pif5001 from w_inherite_multi
string title = "발령 일괄 등록"
dw_detail dw_detail
gb_5 gb_5
gb_6 gb_6
gb_3 gb_3
dw_cond dw_cond
st_2 st_2
st_3 st_3
dw_total dw_total
dw_target dw_target
pb_1 pb_1
pb_2 pb_2
dw_1 dw_1
rr_1 rr_1
rr_2 rr_2
end type
global w_pif5001 w_pif5001

type variables
String   sOrderDate,&
            sOrderCode,&
            sOrderDept,&
            sOrderDateFrom,&
            sOrderDateTo,&
            sOrderDesc

String   sChoiceGbn
Integer iChoiceRow, &
            iOrderSalary
end variables

forward prototypes
public function integer wf_requiredchk (integer il_currow)
public function string wf_getsql ()
end prototypes

public function integer wf_requiredchk (integer il_currow);String snull

SetNull(snull)

IF dw_detail.AcceptText() = -1 THEN RETURN -1

sOrderDate     = Trim(dw_detail.GetItemString(1,"orderdate"))
sOrderCode     = dw_detail.GetItemString(1,"ordercode")
sOrderDateFrom = dw_detail.GetItemString(1,"realorddatefrom")
sOrderDateTo   = dw_detail.GetItemString(1,"realorddateto")
sOrderDesc     = dw_detail.GetItemString(1,"remark")

IF sOrderDate = "" OR IsNull(sOrderDate) THEN 
	MessageBox("확 인","발령일자를 입력하십시요!!")
	dw_detail.SetColumn("orderdate")
	dw_detail.SetFocus()
	Return -1
END IF

IF sOrderCode = "" OR IsNull(sOrderCode) THEN 
	MessageBox("확 인","발령구분을 입력하십시요!!")
	dw_detail.SetColumn("ordercode")
	dw_detail.SetFocus()
	Return -1
END IF



IF dw_1.AcceptText() = -1 THEN RETURN -1

sOrderDept = dw_1.GetitemString(1,"deptcode")



Return 1
end function

public function string wf_getsql ();
Int    k,il_rowCount  
String sGetSqlSyntax,sEmpNo
Long   lSyntaxLength

il_rowCount = dw_target.RowCount()
IF il_rowCount <=0 THEN RETURN ''

sGetSqlSyntax = 'select p1_master.empno from p1_master '

sGetSqlSyntax = sGetSqlSyntax + ' WHERE ('

FOR k = 1 TO il_rowcount
	
	sEmpNo = dw_target.GetItemString(k,"empno")
	
	sGetSqlSyntax = sGetSqlSyntax + ' (p1_master.empno =' + "'"+ sEmpNo +"')"+ ' OR'
	
NEXT

lSyntaxLength = len(sGetSqlSyntax)
sGetSqlSyntax    = Mid(sGetSqlSyntax,1,lSyntaxLength - 2)

sGetSqlSyntax = sGetSqlSyntax + ")"

Return sGetSqlSynTax


end function

on w_pif5001.create
int iCurrent
call super::create
this.dw_detail=create dw_detail
this.gb_5=create gb_5
this.gb_6=create gb_6
this.gb_3=create gb_3
this.dw_cond=create dw_cond
this.st_2=create st_2
this.st_3=create st_3
this.dw_total=create dw_total
this.dw_target=create dw_target
this.pb_1=create pb_1
this.pb_2=create pb_2
this.dw_1=create dw_1
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_detail
this.Control[iCurrent+2]=this.gb_5
this.Control[iCurrent+3]=this.gb_6
this.Control[iCurrent+4]=this.gb_3
this.Control[iCurrent+5]=this.dw_cond
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.dw_total
this.Control[iCurrent+9]=this.dw_target
this.Control[iCurrent+10]=this.pb_1
this.Control[iCurrent+11]=this.pb_2
this.Control[iCurrent+12]=this.dw_1
this.Control[iCurrent+13]=this.rr_1
this.Control[iCurrent+14]=this.rr_2
end on

on w_pif5001.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_detail)
destroy(this.gb_5)
destroy(this.gb_6)
destroy(this.gb_3)
destroy(this.dw_cond)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.dw_total)
destroy(this.dw_target)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.dw_1)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;
dw_cond.SetTransObject(SQLCA)
dw_cond.Reset()
dw_cond.InsertRow(0)
dw_cond.SetFocus()

f_set_saupcd(dw_cond, 'saupcd', '1')
is_saupcd = gs_saupcd

dw_detail.SetTransObject(SQLCA)
dw_detail.Reset()
dw_detail.InsertRow(0)

dw_total.SetTransObject(SQLCA)
dw_total.Reset()

dw_target.SetTransObject(SQLCA)
dw_target.Reset()



dw_1.SetTransObject(SQLCA)
dw_1.Reset()
dw_1.InsertRow(0)

dw_cond.Setitem(1,'sdate',f_today())


end event

type p_delrow from w_inherite_multi`p_delrow within w_pif5001
boolean visible = false
integer x = 3863
integer y = 2788
end type

type p_addrow from w_inherite_multi`p_addrow within w_pif5001
boolean visible = false
integer x = 3689
integer y = 2788
end type

type p_search from w_inherite_multi`p_search within w_pif5001
boolean visible = false
integer x = 2994
integer y = 2788
end type

type p_ins from w_inherite_multi`p_ins within w_pif5001
boolean visible = false
integer x = 3515
integer y = 2788
end type

type p_exit from w_inherite_multi`p_exit within w_pif5001
end type

type p_can from w_inherite_multi`p_can within w_pif5001
boolean originalsize = true
end type

event p_can::clicked;call super::clicked;
ROLLBACK;

w_mdi_frame.sle_msg.text =""

dw_total.Reset()
dw_target.Reset()

dw_cond.SetFocus()

end event

type p_print from w_inherite_multi`p_print within w_pif5001
boolean visible = false
integer x = 3168
integer y = 2788
end type

type p_inq from w_inherite_multi`p_inq within w_pif5001
integer x = 3698
boolean originalsize = true
end type

event p_inq::clicked;
String sabu, sDept,sLevel, sdate, snull

IF dw_cond.AcceptText() = -1 THEN RETURN

sabu = dw_cond.GetItemString(1,"saupcd")
sDept = dw_cond.GetItemString(1,"deptcode")
sLevel = dw_cond.GetItemString(1,"levelcode")
sdate = dw_cond.GetItemString(1,"sdate")

if IsNull(sabu) or sabu = '' then sabu = '%'
IF sDept ="" OR IsNull(sDept) THEN
	sDept = '%'
END IF


IF sLevel ="" OR IsNull(sLevel) THEN
	sLevel = '%'
END IF

if IsNull(sdate) or sdate = '' then
	messagebox("확인","기준일자를 입력하세요")
	dw_cond.Setcolumn('sdate')
	dw_cond.Setfocus()
	return
else
	if f_datechk(sdate) = -1 then
		messagebox("확인","기준일자 오류입니다!")
		dw_cond.Setitem(1,'sdate',snull)
		dw_cond.Setcolumn('sdate')
	   dw_cond.Setfocus()
	   return
	end if
end if

IF dw_total.Retrieve(sabu,sDept,sLevel, sdate) <=0 THEN
	MessageBox("확 인","처리할 대상 사원이 없습니다!!")
	dw_cond.SetFocus()
	Return
END IF

dw_target.Reset()
end event

type p_del from w_inherite_multi`p_del within w_pif5001
boolean originalsize = true
end type

event p_del::clicked;String sMasterSql, sempno
int k

sOrderDate     = Trim(dw_detail.GetItemString(1,"orderdate"))
sOrderCode     = dw_detail.GetItemString(1,"ordercode")

IF sOrderDate = "" OR IsNull(sOrderDate) THEN 
	MessageBox("확 인","발령일자를 입력하십시요!!")
	dw_detail.SetColumn("orderdate")
	dw_detail.SetFocus()
	Return -1
END IF

IF sOrderCode = "" OR IsNull(sOrderCode) THEN 
	MessageBox("확 인","발령구분을 입력하십시요!!")
	dw_detail.SetColumn("ordercode")
	dw_detail.SetFocus()
	Return -1
END IF


if messagebox("확인",'처리대상자의 발령일자 자료를 삭제하시겠습니까?',Question!,YesNo!) = 2 then return


FOR k = 1 TO dw_target.rowcount()
	
	sEmpNo = dw_target.GetItemString(k,"empno")
	
	delete from p1_orders 
	where empno = :sempno and 
	      orderdate = :sOrderdate and 
			ordercode = :SOrdercode;	
	
NEXT

if sqlca.sqlcode = 0 then
	commit;
else
	rollback;
	messagebox("오류","발령자료 삭제를 실패했습니다!")
	return
end if



sMasterSql = Wf_GetSql()
IF sMasterSql = "" OR IsNull(sMasterSql) THEN 
	MessageBox("확 인","인사 마스타 갱신 실패!!")
	RETURN
END IF


w_mdi_frame.sle_msg.text ='인사 마스타 갱신 중......'
/*인사 마스타 갱신*/
DECLARE start_sp_batch_update_master procedure for sp_batch_update_master(:gs_company,:sMasterSql,:gs_today) ;
execute start_sp_batch_update_master ;
//

w_mdi_frame.sle_msg.text ='자료를 저장하였습니다!!'
SetPointer(Arrow!)


end event

type p_mod from w_inherite_multi`p_mod within w_pif5001
boolean originalsize = true
end type

event p_mod::clicked;call super::clicked;Integer il_LoopCnt,k,iOrderSeq, tOrderSalary
String  sEmpNo,sRtnValue

IF Wf_RequiredChk(1) = -1 THEN RETURN 

IF dw_target.AcceptText() = -1 THEN RETURN

il_LoopCnt = dw_target.RowCount()
IF il_LoopCnt <=0 THEN
	MessageBox("확 인","처리할 자료를 선택하지 않았습니다!!"+&
							 "표시된 사원 LIST에서 처리할 대상을 더블 클릭하십시요!!",StopSign!)
	Return
END IF

w_mdi_frame.sle_msg.text ='자료를 저장 중......'
SetPointer(HourGlass!)

FOR k = 1 TO il_LoopCnt
	sEmpNo = dw_target.GetItemString(k,"empno")
	
	iOrderSeq = f_get_order_Seq(gs_company,sEmpNo,sOrderDate)
//	tOrderSalary = integer(dw_target.GetItemstring(k,"oldsalary"))
//	IF IsNull(tOrderSalary) THEN
//		tOrderSalary =  iOrderSalary
//	ELSE
//		tOrderSalary = tOrderSalary + iOrderSalary
//	END IF	
	dw_target.SetItem(k,"companycode",gs_company)
	dw_target.SetItem(k,"seq",        iOrderSeq)
	dw_target.SetItem(k,"orderdate",  sOrderDate)
	dw_target.SetItem(k,"ordercode",  sOrderCode)
	IF  sOrderDept = "" OR IsNull(sOrderDept) THEN
		 
	ELSE	
		 dw_target.SetItem(k,"deptcode",   sOrderDept)
	END IF	
//	dw_target.SetItem(k,"salary",   string(tOrderSalary,'00'))
	dw_target.SetItem(k,"realorddatefrom", sOrderDate)
	dw_target.SetItem(k,"remark",          sOrderDesc)

NEXT

IF dw_target.Update() <> 1 THEN
	MessageBox("확 인","발령사항 저장 실패!!")
	ROLLBACK;
	Return
END IF

COMMIT;

String sMasterSql

sMasterSql = Wf_GetSql()
IF sMasterSql = "" OR IsNull(sMasterSql) THEN 
	MessageBox("확 인","인사 마스타 갱신 실패!!")
	RETURN
END IF

w_mdi_frame.sle_msg.text ='인사 마스타 갱신 중......'
/*인사 마스타 갱신*/
DECLARE start_sp_batch_update_master procedure for sp_batch_update_master(:gs_company,:sMasterSql,:gs_today) ;
execute start_sp_batch_update_master ;
//

w_mdi_frame.sle_msg.text ='자료를 저장하였습니다!!'
SetPointer(Arrow!)



end event

type dw_insert from w_inherite_multi`dw_insert within w_pif5001
boolean visible = false
integer y = 2456
end type

type st_window from w_inherite_multi`st_window within w_pif5001
end type

type cb_append from w_inherite_multi`cb_append within w_pif5001
integer x = 649
integer y = 3020
integer taborder = 0
end type

type cb_exit from w_inherite_multi`cb_exit within w_pif5001
integer taborder = 140
end type

type cb_update from w_inherite_multi`cb_update within w_pif5001
integer x = 2482
integer taborder = 120
end type

type cb_insert from w_inherite_multi`cb_insert within w_pif5001
integer x = 1010
integer y = 3020
integer taborder = 0
end type

type cb_delete from w_inherite_multi`cb_delete within w_pif5001
integer x = 1367
integer y = 3028
integer taborder = 0
end type

type cb_retrieve from w_inherite_multi`cb_retrieve within w_pif5001
integer taborder = 110
end type

type st_1 from w_inherite_multi`st_1 within w_pif5001
end type

type cb_cancel from w_inherite_multi`cb_cancel within w_pif5001
integer taborder = 130
end type

type dw_datetime from w_inherite_multi`dw_datetime within w_pif5001
end type

type sle_msg from w_inherite_multi`sle_msg within w_pif5001
end type

type gb_2 from w_inherite_multi`gb_2 within w_pif5001
integer x = 2437
integer width = 1152
end type

type gb_1 from w_inherite_multi`gb_1 within w_pif5001
integer width = 421
end type

type gb_10 from w_inherite_multi`gb_10 within w_pif5001
end type

type dw_detail from datawindow within w_pif5001
integer x = 105
integer y = 872
integer width = 1138
integer height = 324
integer taborder = 90
boolean bringtotop = true
string dataobject = "d_pif5001_1"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemerror;
Return 1
end event

event getfocus;
this.AcceptText()
end event

event itemfocuschanged;IF dwo.name ="educdesc" OR dwo.name ="edubook" OR dwo.name ="office" THEN
	f_toggle_kor(handle(parent))		//---> 한글 입력모드로
ELSE
	f_toggle_eng(handle(parent))		//---> 영문입력 모드로
END IF
end event

event itemchanged;String snull,sDept,sDeptName,sGrade,sLevel,sSalary,sTmpSalary,sOrdDate,sOrdCode,sJobKind,sJikMu,&
		 sRelationDateFrom,sRelationDateTo
Double dBasePay

SetNull(snull)

IF this.GetColumnName() = "orderdate" THEN									//발령일자
	sOrdDate = Trim(this.GetText())
	IF sOrdDate = "" OR IsNull(sOrdDate) THEN RETURN
	
	IF f_datechk(sOrdDate) = -1 THEN
		MessageBox("확 인","발령일자를 확인하십시요!!")
		this.SetItem(this.GetRow(),"orderdate",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "ordercode" THEN
	sOrdCode = this.GetText()
	IF sOrdCode = "" OR IsNull(sOrdCode) THEN RETURN
	
	IF IsNull(f_code_select('발령',sOrdCode)) THEN
		MessageBox("확 인","등록되지 않은 발령코드입니다!!")
		this.SetItem(this.GetRow(),"ordercode",snull)
		Return 1
	END If
END IF

IF this.GetColumnName() = "deptcode" THEN									//부서코드
	sDept = this.GetText()
	IF sDept = "" OR IsNull(sDept) THEN RETURN
	
	sDeptName = f_code_select('부서',sDept)
	IF IsNull(sDeptName) THEN
		MessageBox("확 인","등록되지 않은 부서입니다!!")
		this.SetItem(this.GetRow(),"deptcode",snull)
		this.SetItem(this.GetRow(),"p0_dept_deptname2",snull)
		Return 1
	ELSE
		this.SetItem(this.GetRow(),"p0_dept_deptname2",sDeptName)
	END IF
END IF

IF this.GetColumnName() = "gradecode" THEN
	sGrade = this.GetText()
	IF sGrade ="" OR IsNull(sGrade) THEN RETURN
	
	IF IsNull(f_code_select('직위',sGrade)) THEN
		MessageBox("확 인","등록되지 않은 직위입니다!!")
		this.SetItem(this.GetRow(),"gradecode",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "levelcode" THEN
	sLevel = this.GetText()
	IF sLevel = "" OR IsNull(sLevel) THEN RETURN
	
	IF IsNull(f_code_select('직급',sLevel)) THEN
		MessageBox("확 인","등록되지 않은 직급입니다!!")
		this.SetItem(this.GetRow(),"levelcode",snull)
		Return 1
	END IF
END IF	

IF this.GetColumnName() = "salary" THEN
	sSalary = this.GetText()
	IF sSalary = "" OR IsNull(sSalary) THEN return
	
	sLevel = this.GetItemString(1,"levelcode")
	IF sLevel ="" OR IsNull(sLevel) THEN Return 
	
	SELECT "P3_BASEPAY"."BASEPAY"  
   	INTO :dBasePay  
   	FROM "P3_BASEPAY"  
   	WHERE ( "P3_BASEPAY"."COMPANYCODE" = :gs_company ) and
				( "P3_BASEPAY"."LEVELCODE" = :sLevel ) AND  
      	   ( "P3_BASEPAY"."SALARY" = :sSalary ) ;
	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox("확 인","등록되지 않은 호봉입니다!!")
		this.SetItem(this.GetRow(),"salary",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "jobkindcode" THEN
	sJobKind = this.GetText()
	IF sJobKind ="" OR IsNull(sJobKind) THEN return
	
	IF IsNull(f_code_select('직책',sJobKind)) THEN
		MessageBox("확 인","등록되지 않은 직책입니다!!")
		this.SetItem(this.GetRow(),"jobkindcode",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "jikmugubn" THEN
	sJikMu = this.GetText()
	IF sJikMu ="" OR IsNull(sJikMu) THEN RETURN
	
	IF IsNull(f_code_select('직무',sJikMu)) THEN
		MessageBox("확 인","등록되지 않은 직무구분입니다!!")
		this.SetItem(this.GetRow(),"jikmugubn",snull)
		Return 1
	END IF
END IF
IF this.GetcolumnName() = "realorddatefrom"	 THEN
	sRelationDateFrom = Trim(this.GetText())
	IF sRelationDateFrom = "" OR IsNull(sRelationDateFrom) THEN RETURN
	
	IF f_datechk(sRelationDateFrom) = -1 THEN
		MessageBox("확 인","시행일자(from)를 확인하십시요!!")
		this.SetItem(this.GetRow(),"realorddatefrom",snull)
		Return -1
	END IF
END IF

IF this.GetcolumnName() = "realorddateto"	 THEN
	sRelationDateTo = Trim(this.GetText())
	IF sRelationDateTo = "" OR IsNull(sRelationDateTo) THEN RETURN
	
	IF f_datechk(sRelationDateTo) = -1 THEN
		MessageBox("확 인","시행일자(to)를 확인하십시요!!")
		this.SetItem(this.GetRow(),"realorddateto",snull)
		Return -1
	END IF
END IF

end event

event rbuttondown;String sCmpZip

SetNull(gs_code)
SetNull(gs_codename)

IF dwo.name ="deptcode" THEN
	
	Open(w_dept_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(),"deptcode",gs_code)
	this.SetItem(this.GetRow(),"p0_dept_deptname2",gs_codename)	
END IF

IF this.GetColumnName() = "salary" THEN
	gs_code = this.GetItemString(this.GetRow(),"levelcode")
	
	IF gs_code ="" OR IsNull(gs_code) THEN RETURN
	
	Open(w_level_salary_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(this.Getrow(),"salary",Gs_codename)
	
	this.TriggerEvent(ItemChanged!)
END IF

end event

type gb_5 from groupbox within w_pif5001
integer x = 23
integer y = 1312
integer width = 1294
integer height = 360
integer taborder = 40
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "부서발령사항"
end type

type gb_6 from groupbox within w_pif5001
integer x = 23
integer y = 812
integer width = 1294
integer height = 424
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "발령일반사항"
end type

type gb_3 from groupbox within w_pif5001
integer x = 27
integer y = 196
integer width = 1294
integer height = 572
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "처리조건"
end type

type dw_cond from u_key_enter within w_pif5001
integer x = 87
integer y = 276
integer width = 1166
integer height = 420
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pif5001_7"
boolean border = false
end type

event getfocus;this.AcceptText()
end event

event itemchanged;
String sDeptCode,sDeptName,snull , sLevelCode ,sCodeName

SetNull(snull)

this.AcceptText()

IF this.GetColumnName() = 'saupcd' THEN
	is_saupcd = this.GetText()
	
	IF is_saupcd = '' OR IsNull(is_saupcd) THEN is_saupcd = '%'
END IF


IF this.GetColumnName() = "deptcode" THEN
	sDeptCode = this.GetText()
	
	IF sDeptCode = "" OR IsNull(sDeptCode) THEN
		this.SetItem(1,"p0_dept_deptname2",snull)
		Return
	END IF
	sCodeName = f_code_select('부서',sDeptCode )
	IF IsNull(sCodeName) THEN
		MessageBox("확 인","등록되지 않은 부서입니다!!",StopSign!)
		this.SetItem(1,"deptcode",snull)
		this.SetItem(1,"p0_dept_deptname2",snull)
		Return 1
	ELSE
		this.SetItem(1,"p0_dept_deptname2",sCodeName)	
	END IF
END IF

IF this.GetColumnName() = "levelcode" THEN
	sLevelCode = this.GetText()
	
	IF sLevelCode = "" OR IsNull(sLevelCode) THEN
		Return
	END IF
	
	sCodeName = f_code_select('직급',sLevelCode)
	IF IsNull(sCodeName) THEN
		MessageBox("확 인","등록되지 않은 직급코드입니다!!",StopSign!)
		this.SetItem(1,"levelcode",snull)
		Return 1
	END IF
END IF

p_inq.Triggerevent(Clicked!)


end event

event itemerror;
Return 1
end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(Gs_gubun)

Gs_gubun = is_saupcd
IF this.GetColumnName() ="deptcode" THEN
	
	Open(w_dept_saup_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(1,"deptcode",gs_code)
	this.SetItem(1,"p0_dept_deptname2",gs_codename)	
END IF


end event

type st_2 from statictext within w_pif5001
integer x = 1385
integer y = 144
integer width = 256
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean underline = true
long textcolor = 8388608
long backcolor = 32106727
boolean enabled = false
string text = "사 원"
boolean focusrectangle = false
end type

type st_3 from statictext within w_pif5001
integer x = 2638
integer y = 144
integer width = 256
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean underline = true
long textcolor = 8388608
long backcolor = 32106727
boolean enabled = false
string text = "처리대상"
boolean focusrectangle = false
end type

type dw_total from u_d_select_sort within w_pif5001
integer x = 1353
integer y = 212
integer width = 1111
integer height = 1908
integer taborder = 100
boolean bringtotop = true
string dataobject = "d_pif5001_2"
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event clicked;If Row <= 0 then
	b_flag =True
ELSE
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

type dw_target from u_d_select_sort within w_pif5001
integer x = 2642
integer y = 212
integer width = 1934
integer height = 1904
integer taborder = 60
boolean bringtotop = true
string dataobject = "d_pif5001_3"
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event clicked;If Row <= 0 then
	b_flag =True
ELSE
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

type pb_1 from picturebutton within w_pif5001
integer x = 2510
integer y = 436
integer width = 101
integer height = 88
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean underline = true
string picturename = "C:\Erpman\image\next.gif"
alignment htextalign = left!
end type

event clicked;String sEmpNo,sEmpName,sGrade,sJobKind,sLevel,sSalary,sDept,sPrtDept,sJikMu
String sjik, sproject, skunmu, spaygubn, skmgubn,sabroad, ssaupcd
Long   totRow , sRow,rowcnt, lbasepay, hbasepay 
int i

IF Wf_RequiredChk(1) = -1 THEN RETURN

totrow =dw_total.Rowcount()

sorderdate = dw_detail.GetitemString(1,'orderdate')

FOR i = 1 TO totrow 
	sRow = dw_total.getselectedrow(0)
	
	IF sRow <=0 THEN EXIT
	
	sEmpNo   = dw_total.GetItemString(sRow, "empno")
   sEmpName = dw_total.GetItemString(sRow, "empname")
	sDept    = dw_total.GetItemString(sRow, "deptcode")
	sPrtDept = dw_total.GetItemString(sRow, "adddeptcode")
	sGrade   = dw_total.GetItemString(sRow, "gradecode")
	sJobKind = dw_total.GetItemString(sRow, "jobkindcode")
	sLevel   = dw_total.GetItemString(sRow, "levelcode")
	sSalary  = dw_total.GetItemString(sRow, "salary")
	sJikMu   = dw_total.GetItemString(sRow, "jikmugubn")
	sjik     = dw_total.GetItemString(sRow, "jikjonggubn")
	sproject = dw_total.GetItemString(sRow, "projectcode")
	lbasepay = dw_total.GetItemNumber(sRow, "basepay")
	skunmu = dw_total.GetItemString(sRow, "kunmugubn")
	spaygubn = dw_total.GetItemString(sRow, "paygubn")
	skmgubn = dw_total.GetItemString(sRow, "kmgubn")
		
	rowcnt = dw_target.RowCount() + 1
	
//	select basepay into :hbasepay
//	from p3_basepay
//	where jikjonggubn = :sjik and
//	      levelcode = :slevel and
//			salary = :sSalary;
//
//   if IsNull(hbasepay) then hbasepay = 0
//   if hbasepay = 0 then
//		hbasepay = lbasepay
//	end if
   select abroadgbn into :sabroad
	from p1_orders
	where companycode = :gs_company and
	      empno = :sEmpNo and
			orderdate||to_char(seq)  = (select max(orderdate)||max(to_char(seq)) from p1_orders
			              where companycode = :gs_company and
	                          empno = :sEmpNo and 
									  orderdate < :sorderdate ) ;
   if IsNull(sabroad) then sabroad = 'N'
	
	select saupcd into :ssaupcd
	from p0_dept
	where companycode = :gs_company and deptcode = :sDept;
	
  	if IsNull(ssaupcd) then ssaupcd = '10'								  
							         
	
	dw_target.insertrow(rowcnt)
	dw_target.setitem(rowcnt, "empno",         sEmpNo)
	dw_target.setitem(rowcnt, "empname",       sEmpName)
	
	dw_target.setitem(rowcnt, "olddeptcode",   sDept)
	dw_target.setitem(rowcnt, "oldprtdept",    sPrtDept)	
	dw_target.setitem(rowcnt, "oldgradecode",  sGrade)
	dw_target.setitem(rowcnt, "oldjobkindcode",sJobKind)
	dw_target.setitem(rowcnt, "oldlevelcode",  sLevel)
	dw_target.setitem(rowcnt, "oldsalary",     sSalary)
	dw_target.setitem(rowcnt, "oldjikmugubn",  sJikMu)
	dw_target.setitem(rowcnt, "deptcode",      sDept)
	dw_target.setitem(rowcnt, "prtdept",       sPrtDept)	
	dw_target.setitem(rowcnt, "gradecode",     sGrade)
	dw_target.setitem(rowcnt, "jobkindcode",   sJobKind)
	dw_target.setitem(rowcnt, "levelcode",     sLevel)
	dw_target.setitem(rowcnt, "salary",        sSalary)
	dw_target.setitem(rowcnt, "jikmugubn",     sJikMu)
	dw_target.setitem(rowcnt, "oldjikjonggubn", sjik)
	dw_target.setitem(rowcnt, "jikjonggubn",    sjik)
	dw_target.setitem(rowcnt, "oldbasepay",     lbasepay)
	dw_target.setitem(rowcnt, "basepay",        hbasepay)
	dw_target.setitem(rowcnt, "projectcode",    sproject)
	dw_target.setitem(rowcnt, "kunmugubn",    skunmu)
	dw_target.setitem(rowcnt, "paygubn",    spaygubn)
	dw_target.setitem(rowcnt, "kmgubn",    skmgubn)
	dw_target.setitem(rowcnt, "saupcd",    ssaupcd)
	dw_target.setitem(rowcnt, "abroadgbn",    sabroad)
	hbasepay = 0
	dw_total.deleterow(sRow)
NEXT	


end event

type pb_2 from picturebutton within w_pif5001
integer x = 2510
integer y = 556
integer width = 101
integer height = 88
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean underline = true
string picturename = "C:\Erpman\image\prior.gif"
alignment htextalign = left!
end type

event clicked;String sEmpNo,sEmpName,sDept,sGrade,sLevel,sJobKind,sSalary,sJikMu,sPrtDept
Long    rowcnt , totRow , sRow 
int     i

totRow =dw_target.Rowcount()

FOR i = 1 TO totRow 
	sRow = dw_target.getselectedrow(0)
	
	IF sRow <=0 THEN EXIT
	
	sEmpNo   = dw_target.GetItemString(sRow, "empno")
   sEmpName = dw_target.GetItemString(sRow, "empname")
	sDept    = dw_target.GetItemString(sRow, "olddeptcode")
	sPrtDept = dw_target.GetItemString(sRow, "oldprtdept")	
	sGrade   = dw_target.GetItemString(sRow, "oldgradecode")
	sJobKind = dw_target.GetItemString(sRow, "oldjobkindcode")
	sLevel   = dw_target.GetItemString(sRow, "oldlevelcode")
	sSalary  = dw_target.GetItemString(sRow, "oldsalary")
	sJikMu   = dw_target.GetItemString(sRow, "oldjikmugubn") 
	
	rowcnt = dw_total.RowCount() + 1
	
	dw_total.insertrow(rowcnt)
	dw_total.setitem(rowcnt, "empno",       sEmpNo)
	dw_total.setitem(rowcnt, "empname",     sEmpName)
	dw_total.setitem(rowcnt, "deptcode",    sDept)
	dw_total.setitem(rowcnt, "adddeptcode", sPrtDept)	
	dw_total.setitem(rowcnt, "gradecode",   sGrade)
	dw_total.setitem(rowcnt, "jobkindcode", sJobKind)
	dw_total.setitem(rowcnt, "levelcode",   sLevel)
	dw_total.setitem(rowcnt, "salary",      sSalary)
	dw_total.setitem(rowcnt, "jikmugubn",   sJikMu)
	
	dw_target.deleterow(sRow)
NEXT	

end event

type dw_1 from datawindow within w_pif5001
integer x = 128
integer y = 1396
integer width = 1106
integer height = 216
integer taborder = 80
boolean bringtotop = true
string dataobject = "d_pif5001_5"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;String sDeptCode,sDeptName,snull

SetNull(snull)

this.AcceptText()

IF this.GetColumnName() = "deptcode" THEN
	sDeptCode = this.GetText()
	
	IF sDeptCode = "" OR IsNull(sDeptCode) THEN
		this.SetItem(1,"curdptname",snull)
		Return
	END IF
	
	SELECT "P0_DEPT"."DEPTNAME"  
   	INTO :sDeptName  
   	FROM "P0_DEPT"  
   	WHERE ( "P0_DEPT"."COMPANYCODE" = :gs_company ) AND  
      	   ( "P0_DEPT"."DEPTCODE" = :sDeptCode )   ;
	IF SQLCA.SQLCODE = 0 THEN
		this.SetItem(1,"curdptname",sDeptName)
	ELSE
		MessageBox("확 인","등록되지 않은 부서입니다!!",StopSign!)
		this.SetItem(1,"deptcode",snull)
		this.SetItem(1,"curdptname",snull)
		Return 1
	END IF
END IF

end event

event itemerror;Return 1
end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(Gs_gubun)

Gs_gubun = is_saupcd
IF this.GetColumnName() ="deptcode" THEN
	
	Open(w_dept_saup_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(1,"deptcode",gs_code)
	this.SetItem(1,"curdptname",gs_codename)	
END IF
end event

type rr_1 from roundrectangle within w_pif5001
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1344
integer y = 208
integer width = 1147
integer height = 1916
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_2 from roundrectangle within w_pif5001
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2638
integer y = 208
integer width = 1957
integer height = 1916
integer cornerheight = 40
integer cornerwidth = 46
end type

