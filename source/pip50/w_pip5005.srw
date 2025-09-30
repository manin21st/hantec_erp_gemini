$PBExportHeader$w_pip5005.srw
$PBExportComments$** 전근무지 생성
forward
global type w_pip5005 from w_inherite_standard
end type
type dw_list from u_d_select_sort within w_pip5005
end type
type dw_main from u_d_select_sort within w_pip5005
end type
type p_compute from uo_picture within w_pip5005
end type
type dw_ip from u_key_enter within w_pip5005
end type
type rr_1 from roundrectangle within w_pip5005
end type
type rr_2 from roundrectangle within w_pip5005
end type
end forward

global type w_pip5005 from w_inherite_standard
string title = "전근무지 생성"
dw_list dw_list
dw_main dw_main
p_compute p_compute
dw_ip dw_ip
rr_1 rr_1
rr_2 rr_2
end type
global w_pip5005 w_pip5005

forward prototypes
public function integer wf_update_company ()
public function string wf_proceduresql (string ar_empno, string ar_saup)
end prototypes

public function integer wf_update_company ();STRING ls_chk, ls_empno, snull, ls_Date
String ls_enterdate, ls_retiredate, ls_saupno, ls_saupname
INT k

dw_ip.AcceptText()
ls_date = dw_Ip.GetItemString(dw_ip.GetRow(), 'workym')

dw_list.AcceptText()
FOR k = 1 to Dw_list.RowCount()
	 ls_chk = dw_list.GetItemString(k, 'chk')
	 ls_empno = dw_list.GetItemString(k, 'empno')
	 IF ls_chk = '' OR IsNull(ls_chk) THEN ls_Chk = '0'
	 
	 IF ls_chk = "1" THEN
		 
		 SELECT enterdate, retiredate
		   INTO :ls_enterdate, :ls_retiredate
			FROM p1_master
		  WHERE companycode = :gs_company AND
				  empno = :ls_empno;	
				  
       SELECT 	saupno, saupname			  
		 INTO :ls_saupno, :ls_saupname
		 FROM p0_saupcd
		 WHERE saupcode = :is_saupcd;
      				  
		 
       INSERT INTO "P3_ACNT_PREV_COMPANY"
	         ( "COMPANYCODE",          "WORKYEAR",          "EMPNO",                 "SEQ",                  "COMPANYNAME",
	           "COMPANYNO",            "ENTERDATE",         "RETIREDATE",            "PAYTOTAL",             "BONUSTOTAL",
	           "FOREIGNWORKINCOME",    "NIGHTWORKPAY",      "ETCTAXFREE",            "MEDINSURANCE",         "ETCINSURANCE",
	           "HOUSEREFUNDAMT",       "MEDSELFFINE",       "MEDRESPECTFINE",        "EDUCATIONAMT",         "ALLPURSE",
	           "LIMITPURSE",           "PRIVATEPURSE",      "PENSIONSAVINGAMT",      "FOREIGNPAIDTAX",       "WORKINCOMETAX",
	           "WELTHSAVINGAMT",       "WELTHSAVINGFUNDAMT","INCOMETAX",             "RESIDENTTAX",          "SPECIALTAX",
	           "INJUNGBONUSAMT")
	       SELECT "COMPANYCODE",     "WORKYEAR",        "EMPNO",                1,                   :ls_saupname,
	           :ls_saupno,           :ls_enterdate,     :ls_retiredate,         "PAYTOTAL",          "BONUSTOTAL",
	           "FOREIGNWORKINCOME",  "NIGHTWORKPAY",    "ETCTAXFREE",           "INSURANCESUB",      0,
	           0,                    0,                 0,                      0,                   0,
	           0,                    0,                 "PENSIONINSURANCESUB",  "FOREIGNPAIDTAXSUB", 0,
	           0,                    0,                 "RESULTINCOMETAX",      "RESULTRESIDENTTAX", "RESULTSPECIALTAX",
	           "INJUNGBONUSAMT"
	        FROM p3_ACNT_TAXCAL_DATA 
	        WHERE companycode = :gs_company and
	              workyear = :ls_date and
	              tag = '2' and
					  empno = :ls_empno;					 
		 
		   IF SQLCA.SQLCODE = 0 THEN 
				COMMIT;
			ELSE 	  
				ROLLBACK;
			END IF	
//       INSERT INTO "P3_ACNT_PREV_COMPANY"
//	         ( "COMPANYCODE",          "WORKYEAR",          "EMPNO",                 "SEQ",                  "COMPANYNAME",
//	           "COMPANYNO",            "ENTERDATE",         "RETIREDATE",            "PAYTOTAL",             "BONUSTOTAL",
//	           "FOREIGNWORKINCOME",    "NIGHTWORKPAY",      "ETCTAXFREE",            "MEDINSURANCE",         "ETCINSURANCE",
//	           "HOUSEREFUNDAMT",       "MEDSELFFINE",       "MEDRESPECTFINE",        "EDUCATIONAMT",         "ALLPURSE",
//	           "LIMITPURSE",           "PRIVATEPURSE",      "PENSIONSAVINGAMT",      "FOREIGNPAIDTAX",       "WORKINCOMETAX",
//	           "WELTHSAVINGAMT",       "WELTHSAVINGFUNDAMT","INCOMETAX",             "RESIDENTTAX",          "SPECIALTAX",
//	           "INJUNGBONUSAMT")
//	       SELECT A."COMPANYCODE",     A."WORKYEAR",        A."EMPNO",                '1',                   S."SAUPNAME",
//	           S."SAUPNO",             M."ENTERDATE",       M."RETIREDATE",           A."PAYTOTAL",          A."BONUSTOTAL",
//	           A."FOREIGNWORKINCOME",  A."NIGHTWORKPAY",    A."ETCTAXFREE",           A."INSURANCESUB",      0,
//	           0,                      0,                   0,                        0,                     0,
//	           0,                      0,                   A."PENSIONINSURANCESUB",  A."FOREIGNPAIDTAXSUB", 0,
//	           0,                      0,                   A."RESULTINCOMETAX",      A."RESULTRESIDENTTAX", A."RESULTSPECIALTAX",
//	           "INJUNGBONUSAMT"
//	        FROM p3_ACNT_TAXCAL_DATA A,
//			       p1_master M,
//					 p0_saupcd S
//	        WHERE M.companycode = A.companycode AND
//			        M.empno = A.empno AND
//					  S.companycode = A.companycode AND
//					  S.saupcode = A.saupcd AND
//			        A.companycode = :gs_company and
//	              A.workyear = substr(:ls_date, 1, 4) and
//	              A.tag = '2' and
//					  A.empno = :ls_empno;					 
//		 
		
	 END IF	 
	 	 
NEXT

Return 1
end function

public function string wf_proceduresql (string ar_empno, string ar_saup);
String sGetSqlSyntax
Long   lSyntaxLength

sGetSqlSyntax = 'select empno,jikjonggubn,enterdate,retiredate,jhgubn,paygubn,consmatgubn,kmgubn,engineergubn,' +&
					 "'" + ar_saup + "'" + ' from p1_master'

sGetSqlSyntax = sGetSqlSyntax + ' where '
sGetSqlSyntax = sGetSqlSyntax + ' (empno =' + "'"+ ar_EmpNo +"')"

Return sGetSqlSynTax
end function

on w_pip5005.create
int iCurrent
call super::create
this.dw_list=create dw_list
this.dw_main=create dw_main
this.p_compute=create p_compute
this.dw_ip=create dw_ip
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list
this.Control[iCurrent+2]=this.dw_main
this.Control[iCurrent+3]=this.p_compute
this.Control[iCurrent+4]=this.dw_ip
this.Control[iCurrent+5]=this.rr_1
this.Control[iCurrent+6]=this.rr_2
end on

on w_pip5005.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_list)
destroy(this.dw_main)
destroy(this.p_compute)
destroy(this.dw_ip)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;w_mdi_frame.sle_msg.text =""

ib_any_typing=False


dw_ip.Reset()
dw_list.Reset()
dw_main.Reset()

dw_ip.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)
dw_main.SetTransObject(SQLCA)

dw_ip.InsertRow(0)
dw_list.InsertRow(0)
dw_main.InsertRow(0)

dw_ip.SetColumn('workym')
dw_Ip.SetFocus()

dw_ip.SetItem(dw_ip.GetRow(), 'workym', left(f_today(), 4))
f_set_saupcd(dw_ip, 'saupcd','1')
is_saupcd = gs_saupcd

p_inq.TriggerEvent(Clicked!)
end event

type p_mod from w_inherite_standard`p_mod within w_pip5005
integer x = 4037
end type

event p_mod::clicked;call super::clicked;Int k

IF dw_main.Accepttext() = -1 THEN RETURN

IF MessageBox("확인", "저장하시겠습니까?", question!, yesno!) = 2	THEN	RETURN

IF dw_main.Update() <> 1 THEN
	ROLLBACK USING sqlca;
	w_mdi_frame.sle_msg.text = "저장 실패!!"
	ib_any_typing = True
	Return
END IF

COMMIT;

w_mdi_frame.sle_msg.text ="자료를 저장하였습니다!!"
ib_any_typing = False

dw_main.SetColumn('paytotal')
dw_main.Setfocus()

end event

type p_del from w_inherite_standard`p_del within w_pip5005
boolean visible = false
integer x = 549
integer y = 2280
boolean enabled = false
end type

type p_inq from w_inherite_standard`p_inq within w_pip5005
integer x = 3689
end type

event p_inq::clicked;call super::clicked;String ls_date, ls_saupcd, ls_Deptcode, ls_empno, snull
SetNull(snull)

IF dw_ip.AcceptText() = -1 THEN Return -1

ls_date = dw_ip.GetItemString(dw_ip.GetRow(), 'workym')
ls_saupcd = dw_ip.GetItemString(dw_ip.GetRow(), 'saupcd')
ls_deptcode = dw_ip.GetItemString(dw_ip.GetRow(), 'deptcode')
ls_empno = dw_ip.GetItemString(dw_ip.GetRow(), 'empno')

IF ls_saupcd = '' OR Isnull(ls_saupcd) THEN ls_saupcd = '%'
IF ls_deptcode = '' OR Isnull(ls_deptcode) THEN ls_deptcode = '%'
IF ls_empno = '' OR Isnull(ls_empno) THEN ls_empno = '%'

IF ls_date = '' OR IsNull(ls_date) THEN
	MessageBox("확인", "정산기준년도를 입력하십시오!")
	dw_ip.SetItem(dw_ip.GetRow(), 'workym', snull)
	dw_ip.SetColumn('workym')
	dw_ip.SetFocus()
	Return 1
END IF

IF f_datechk(ls_Date + '0101') = -1 THEN
	MessageBox("확인", "정산기준년도를 확인하십시오!")
	dw_ip.SetItem(dw_ip.GetRow(), 'workym', snull)
	dw_ip.SetColumn('workym')
	dw_ip.SetFocus()
	Return 1
END IF

w_mdi_frame.sle_msg.text = '조회중입니다..'
SetPointer(HourGlass!)
dw_list.SetReDraw(False)
IF dw_list.Retrieve(ls_saupcd, ls_deptcode, ls_empno, ls_date) <= 0 THEN
	w_mdi_frame.sle_msg.text = '조회된 자료가 없습니다.'
	SetPointer(Arrow!)
	dw_list.SetReDraw(True)
	dw_main.reset()
	Return 1
END IF

dw_main.SetReDraw(False)
IF dw_main.Retrieve(ls_date, ls_saupcd, ls_empno) <= 0 THEN
	dw_list.SetReDraw(True)
	dw_main.SetReDraw(True)
	w_mdi_frame.sle_msg.text = '조회완료'
	SetPointer(Arrow!)
	Return 1
END IF

w_mdi_frame.sle_msg.text = '조회완료'
SetPointer(Arrow!)
dw_list.SetReDraw(True)
dw_main.SetReDraw(True)
Return 1
end event

type p_print from w_inherite_standard`p_print within w_pip5005
boolean visible = false
integer x = 1280
integer y = 2280
boolean enabled = false
end type

type p_can from w_inherite_standard`p_can within w_pip5005
end type

event p_can::clicked;call super::clicked;p_inq.TriggerEvent(Clicked!)
end event

type p_exit from w_inherite_standard`p_exit within w_pip5005
end type

type p_ins from w_inherite_standard`p_ins within w_pip5005
boolean visible = false
integer x = 1097
integer y = 2280
boolean enabled = false
end type

type p_search from w_inherite_standard`p_search within w_pip5005
boolean visible = false
integer x = 1106
integer y = 2280
boolean enabled = false
end type

type p_addrow from w_inherite_standard`p_addrow within w_pip5005
boolean visible = false
integer x = 914
integer y = 2280
boolean enabled = false
end type

type p_delrow from w_inherite_standard`p_delrow within w_pip5005
boolean visible = false
integer x = 731
integer y = 2280
boolean enabled = false
end type

type dw_insert from w_inherite_standard`dw_insert within w_pip5005
boolean visible = false
integer y = 2272
boolean enabled = false
end type

type st_window from w_inherite_standard`st_window within w_pip5005
end type

type cb_exit from w_inherite_standard`cb_exit within w_pip5005
end type

type cb_update from w_inherite_standard`cb_update within w_pip5005
end type

type cb_insert from w_inherite_standard`cb_insert within w_pip5005
end type

type cb_delete from w_inherite_standard`cb_delete within w_pip5005
end type

type cb_retrieve from w_inherite_standard`cb_retrieve within w_pip5005
end type

type st_1 from w_inherite_standard`st_1 within w_pip5005
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_pip5005
end type

type dw_datetime from w_inherite_standard`dw_datetime within w_pip5005
end type

type sle_msg from w_inherite_standard`sle_msg within w_pip5005
end type

type gb_2 from w_inherite_standard`gb_2 within w_pip5005
end type

type gb_1 from w_inherite_standard`gb_1 within w_pip5005
end type

type gb_10 from w_inherite_standard`gb_10 within w_pip5005
end type

type dw_list from u_d_select_sort within w_pip5005
integer x = 37
integer y = 356
integer width = 1783
integer height = 1892
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_pip5005_1"
boolean hscrollbar = false
boolean border = false
end type

type dw_main from u_d_select_sort within w_pip5005
event ue_enter pbm_dwnprocessenter
integer x = 1851
integer y = 356
integer width = 2706
integer height = 1892
integer taborder = 21
boolean bringtotop = true
string dataobject = "d_pip5005_2"
boolean border = false
boolean hsplitscroll = true
end type

event ue_enter;Send(Handle(this),256,9,0)
Return 1
end event

event editchanged;call super::editchanged;ib_any_typing = True
end event

type p_compute from uo_picture within w_pip5005
integer x = 3863
integer y = 24
integer width = 178
integer height = 140
boolean bringtotop = true
string picturename = "C:\erpman\image\생성_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\생성_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\생성_up.gif"
end event

event clicked;call super::clicked;long il_rowcount,findrow 
integer wrtcnt,iRtnValue, k, i
string snull, sqltext, ls_Date, ls_chk, ls_empno, ls_empname, ls_saupcd, ls_gubun

dw_ip.accepttext()

setnull(snull)

ls_date = trim(dw_ip.getitemstring(1, 'workym'))

IF ls_date = "" or isnull(ls_date) then 
	messagebox("확 인", "정산기준년도를  입력하세요!!")
	dw_ip.SetItem(1,"workym",snull)
	dw_ip.SetColumn("workym")
	dw_ip.setfocus()
	return 1
END IF	

IF f_datechk(ls_date+"0101") = -1 THEN
	messagebox('확 인','정산기준년도를 확인하세요!!')
	dw_ip.SetItem(1,"workym",snull)
	dw_ip.SetColumn("workym")
	dw_ip.Setfocus()
	Return 1
END IF

IF messagebox("확 인", "생성작업을 하면 해당 사원의 이전 데이터는 사라집니다.  ~r~r생성작업을 하시겠습니까?",&
                     exclamation!,yesno!,2) = 2 then
	dw_ip.setfocus()
   return 
END IF

setpointer(hourglass!)

DECLARE start_sp_create_prev_company procedure for sp_create_prev_company(:gs_company,:ls_Date,:sqltext) ;

dw_list.accepttext()
il_RowCount = 0

FOR k = 1 to Dw_list.RowCount()
	ls_chk = dw_list.GetItemString(k, 'chk')
	ls_empno = dw_list.GetItemString(k, 'empno')
	ls_empname = dw_list.GetItemString(k, 'empname')
	ls_saupcd  = dw_list.GetItemString(k, 'saupcd')
	IF ls_chk = '' OR IsNull(ls_chk) THEN ls_Chk = '0'
	ls_gubun  = dw_list.GetItemString(k, 'gubun')
	 
	IF ls_chk = "1" THEN
		il_RowCount = il_RowCount + 1
		 		
		w_mdi_frame.sle_msg.text = ls_empno+ ' '+ ls_empname +'의 자료 생성중.........!!'
		sqltext = wf_proceduresql(ls_empno,ls_saupcd)

		IF ls_gubun = '1' THEN
			iRtnValue = sqlca.sp_calc_endtaxadjustment(gs_company,ls_Date+'12','1',sqltext);
			
			IF iRtnValue <> 1 then
				MessageBox("확 인",ls_empno+ ' '+ ls_empname +'의 중간정산에 실패하였습니다!')
				Rollback;
				continue
			ELSE
				commit;
			END IF
		END IF

		execute start_sp_create_prev_company ;
		IF TRIM(SQLCA.SQLERRTEXT) <> '' THEN
			MessageBox('DB Procedure Error:'+ls_empno+ ' '+ ls_empname,SQLCA.SQLERRTEXT)
			rollback;
		END IF
	END IF	 
NEXT

IF il_RowCount <=0 THEN
	MessageBox("확 인","처리 선택한 자료가 없습니다!!")
	setpointer(arrow!)
	Return
END IF

//sqltext = wf_proceduresql()
//
//iRtnValue = sqlca.sp_calc_endtaxadjustment(gs_company,ls_Date+'12','1',sqltext);
//
//IF iRtnValue <> 1 then
//	MessageBox("확 인","전근무지 자료 생성 실패!!")
//	Rollback;
//	SetPointer(Arrow!)
//	w_mdi_frame.sle_msg.text =''
//	Return
//END IF
//
//commit;
//
//DECLARE start_sp_create_prev_company procedure for sp_create_prev_company(:gs_company,:ls_Date,:sqltext) ;
//execute start_sp_create_prev_company ;
//IF TRIM(SQLCA.SQLERRTEXT) <> '' THEN
//	MessageBox('DB Procedure Error',SQLCA.SQLERRTEXT)
//END IF

//wf_update_company()

W_mdi_frame.sle_msg.text = '전근무지 자료 생성 완료!!'

p_inq.TriggerEvent(Clicked!)
SetPointer(Arrow!)
end event

type dw_ip from u_key_enter within w_pip5005
integer x = 41
integer y = 48
integer width = 2322
integer height = 256
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_pip5005_c"
boolean border = false
end type

event itemerror;call super::itemerror;Return -1
end event

event itemchanged;call super::itemchanged;String ls_date, ls_saupcd, ls_Deptcode, ls_empno, ls_deptname, ls_empname, snull
SetNull(snull)

IF dw_ip.AcceptText() = -1 THEN Return -1

IF dw_ip.GetColumnName() = 'saupcd' THEN
	is_saupcd = dw_ip.GetText()
	
	IF ls_date = '' OR IsNull(ls_date) THEN is_saupcd = '%'

END IF


IF dw_ip.GetColumnName() = 'workym' THEN
	ls_date = dw_ip.GetText()
	
	IF ls_date = '' OR IsNull(ls_date) THEN
		MessageBox("확인", "정산기준년을 입력하십시오!")
		dw_ip.SetItem(dw_ip.GetRow(), 'workym', snull)
		dw_ip.SetColumn('workym')
		dw_ip.SetFocus()
		Return 1
	END IF
	
	IF f_datechk(ls_Date + '0101') = -1 THEN
		MessageBox("확인", "정산기준년을 확인하십시오!")
		dw_ip.SetItem(dw_ip.GetRow(), 'workym', snull)
		dw_ip.SetColumn('workym')
		dw_ip.SetFocus()
		Return 1
	END IF
END IF

IF this.GetColumnName() = 'deptcode' THEN
	ls_deptcode = this.GetText()
	
	IF ls_deptCode = "" OR IsNull(ls_deptCode) THEN 
		ls_deptcode = '%'		
		this.SetItem(this.GetROW(),"deptname",snull)
	END IF
	
	IF ls_deptcode <> '%' THEN
		//부서코드 검사
		SELECT "P0_DEPT"."DEPTNAME"  
			 INTO :ls_deptname  
			 FROM "P0_DEPT"  
			WHERE ( "P0_DEPT"."COMPANYCODE" = :gs_company ) AND  
					( "P0_DEPT"."DEPTCODE" = :ls_deptcode )   ;
		if sqlca.sqlcode <> 0 then
			messagebox("확인","부서코드를 확인하세요", StopSign!)
			this.SetItem(this.GetROW(),"deptcode",snull)
			this.SetItem(this.GetROW(),"deptname",snull)
			this.setcolumn("deptcode")
			this.SetFocus()
			return 1
		else
			this.SetItem(this.GetROW(),"deptname",ls_DeptName)
		end if
	END IF
END IF

IF this.GetColumnName() = "empno" Then
	ls_empno = this.GetText()
	
	IF ls_empno ="" OR IsNull(ls_empno) THEN 
		ls_empno = '%'
		THIS.SetItem(this.GetROW(), 'empname', snull)
	END IF
	
	IF ls_empno <> '%' THEN		
		IF IsNull(wf_exiting_data("empno",ls_empno,"1")) THEN
			Messagebox("확 인","사원번호를 확인하세요")
			THIS.SetItem(this.GetROW(), 'empno', snull)
			THIS.SetItem(this.GetROW(), 'empname', snull)
			this.SetColumn("empno")
			this.SetFocus()
			Return 1
		END IF	
	END IF
END IF

p_inq.TriggerEvent(Clicked!)
end event

event rbuttondown;call super::rbuttondown;SetNull(Gs_code)
SetNull(Gs_codename)

this.AcceptText()
IF This.GetColumnName() = "deptcode" THEN
	Gs_Codename = this.GetItemString(this.GetRow(),"deptcode")
	gs_gubun = is_saupcd
	open(w_dept_saup_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(),"deptcode",Gs_code)
	this.SetItem(this.GetRow(),"deptname",Gs_codename)
	this.TriggerEvent(ItemChanged!)
END IF



IF This.GetColumnName() = "empno" THEN
	Gs_Code = this.GetItemString(this.GetRow(),"empno")
	gs_gubun = is_saupcd
	open(w_employee_saup_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(),"empno",Gs_code)
	this.SetItem(this.GetROW(),"empname",Gs_Codename)
	this.TriggerEvent(ItemChanged!)
END IF


end event

type rr_1 from roundrectangle within w_pip5005
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 32
integer y = 348
integer width = 1797
integer height = 1924
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pip5005
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 1847
integer y = 348
integer width = 2720
integer height = 1924
integer cornerheight = 40
integer cornerwidth = 55
end type

