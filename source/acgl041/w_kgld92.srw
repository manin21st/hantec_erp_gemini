$PBExportHeader$w_kgld92.srw
$PBExportComments$월마감 처리(일괄)
forward
global type w_kgld92 from w_inherite
end type
type dw_cond from u_key_enter within w_kgld92
end type
type cbx_1 from checkbox within w_kgld92
end type
type cbx_jip_account from checkbox within w_kgld92
end type
type cbx_jip_person from checkbox within w_kgld92
end type
type cbx_jip_cost_account from checkbox within w_kgld92
end type
type cbx_jip_cost_person from checkbox within w_kgld92
end type
type gb_6 from groupbox within w_kgld92
end type
type gb_5 from groupbox within w_kgld92
end type
type gb_4 from groupbox within w_kgld92
end type
type gb_3 from groupbox within w_kgld92
end type
type gb_2 from groupbox within w_kgld92
end type
type gb_1 from groupbox within w_kgld92
end type
type cbx_6 from checkbox within w_kgld92
end type
type cbx_gagyel from checkbox within w_kgld92
end type
type cbx_12 from checkbox within w_kgld92
end type
type cbx_13 from checkbox within w_kgld92
end type
type cbx_15 from checkbox within w_kgld92
end type
type cbx_16 from checkbox within w_kgld92
end type
type cbx_17 from checkbox within w_kgld92
end type
type cbx_18 from checkbox within w_kgld92
end type
type rb_fs1 from radiobutton within w_kgld92
end type
type rb_fs2 from radiobutton within w_kgld92
end type
type rb_fs3 from radiobutton within w_kgld92
end type
type rb_fs4 from radiobutton within w_kgld92
end type
type rb_fst from radiobutton within w_kgld92
end type
type cbx_jip_ilgye from checkbox within w_kgld92
end type
type rr_1 from roundrectangle within w_kgld92
end type
end forward

global type w_kgld92 from w_inherite
string title = "월마감 처리"
dw_cond dw_cond
cbx_1 cbx_1
cbx_jip_account cbx_jip_account
cbx_jip_person cbx_jip_person
cbx_jip_cost_account cbx_jip_cost_account
cbx_jip_cost_person cbx_jip_cost_person
gb_6 gb_6
gb_5 gb_5
gb_4 gb_4
gb_3 gb_3
gb_2 gb_2
gb_1 gb_1
cbx_6 cbx_6
cbx_gagyel cbx_gagyel
cbx_12 cbx_12
cbx_13 cbx_13
cbx_15 cbx_15
cbx_16 cbx_16
cbx_17 cbx_17
cbx_18 cbx_18
rb_fs1 rb_fs1
rb_fs2 rb_fs2
rb_fs3 rb_fs3
rb_fs4 rb_fs4
rb_fst rb_fst
cbx_jip_ilgye cbx_jip_ilgye
rr_1 rr_1
end type
global w_kgld92 w_kgld92

forward prototypes
public function integer wf_create_fg (string syearmonth)
public function integer wf_create_kfz02wk (string syearmonth, string ssaupj)
end prototypes

public function integer wf_create_fg (string syearmonth);String  sD_From,sD_To
Long    iFunVal,Ld_Ses
Integer iRowCount

select d_ses		into :Ld_Ses	from kfz08om0 ;
if sqlca.sqlcode <> 0 then
	F_MessageChk(20,'[회기]')
	Return -2
end if

sD_From = sYearMonth
sD_To   = sYearMonth

if cbx_13.Checked = True then
	select Count(*)	into :iRowCount 							/*결산집계자료의 유무 체크*/
		from kfz02ot2;
	if sqlca.sqlcode = 0 and iRowCount = 0 then
		f_closing_copy(sYearMonth,sYearMonth,String(Long(Left(sYearMonth,4)) - 1)+Mid(sYearMonth,5,2),String(Long(Left(sYearMonth,4)) - 1)+Mid(sYearMonth,5,2))
	ELSE
		IF MessageBox("처리확인","결산집계자료가 이미 존재합니다. 다시 생성하시겠습니까?",Question!,YesNo!) = 1 THEN 
			DELETE FROM "KFZ02OT2";
			COMMIT;
	
			f_closing_copy(sYearMonth,sYearMonth,String(Long(Left(sYearMonth,4)) - 1)+Mid(sYearMonth,5,2),String(Long(Left(sYearMonth,4)) - 1)+Mid(sYearMonth,5,2))
		END IF
	END IF
end if

if cbx_13.Checked = True then
	w_mdi_frame.sle_msg.text ="당기마감자료 변환 중..."
	SetPointer(HourGlass!)
	iFunVal = sqlca.fun_create_kfz09dat(Ld_Ses,sD_From,sD_To)
	IF iFunVal = -1 THEN
		MessageBox('확 인','당기마감자료 변환 실패!')
		Return -1
	END IF
end if

if cbx_15.Checked = True then
	w_mdi_frame.sle_msg.text ="년별 경영분석표 작성 중..."
	SetPointer(HourGlass!)
		iFunVal = sqlca.fun_create_kfz09wk(Ld_Ses,sD_From,sD_To)
	IF iFunVal = -1 THEN
		MessageBox('확 인','년별 경영분석표 작성 실패!')
		Return -1
	END IF
end if

w_mdi_frame.sle_msg.text = '경영분석 작성 완료'
SetPointer(Arrow!)

Return iFunVal
end function

public function integer wf_create_kfz02wk (string syearmonth, string ssaupj);String  sD_From,sD_To,sJ_From,sJ_To,sFsGbn
Long    iFunVal,Ld_Ses,Lj_Ses

select d_ses,	j_ses		into :Ld_Ses,		:Lj_Ses
	from kfz08om0 ;
if sqlca.sqlcode <> 0 then
	F_MessageChk(20,'[회기]')
	Return -2
end if

sD_From = sYearMonth + '01'
sD_To   = F_Last_Date(sYearMonth)
	
sJ_From = String(Long(Left(sYearMonth,4)) - 1,'0000') + Mid(sYearMonth,5,2) + '01'
sJ_To   = F_Last_Date(String(Long(Left(sYearMonth,4)) - 1,'0000') + Mid(sYearMonth,5,2))

w_mdi_frame.sle_msg.text = '실결산 전표 집계 중...'
SetPointer(HourGlass!)
IF f_closing_copy(sD_From,sD_To,sJ_From,sJ_To) <> 1 THEN
	MessageBox("확 인","실결산집계 실패 !!")
	RETURN -3
END IF

IF cbx_gagyel.Checked = True THEN										/*가결산 포함*/	
	w_mdi_frame.sle_msg.text = '가결산 전표 집계 중...'
	
	IF f_closing_sum(Left(sD_From,6),Left(sD_To,6)) <> 1 THEN
		MessageBox("확 인","가결산집계 실패 !!")
		RETURN -4
	END IF
	w_mdi_frame.sle_msg.text = '가결산 전표 집계 완료!!'
END IF

IF rb_fs1.Checked = True THEN
	sFsGbn = '1'
ELSEIF rb_fs2.Checked = True THEN
	sFsGbn = '2'
ELSEIF rb_fs3.Checked = True THEN
	sFsGbn = '3'
ELSEIF rb_fs4.Checked = True THEN
	sFsGbn = '4'
ELSEIF rb_fst.Checked = True THEN
	sFsGbn = '%'
END IF

w_mdi_frame.sle_msg.text = '재무제표 자료 생성 중...'
iFunVal = sqlca.fun_create_fs(sSaupj,Ld_Ses,sD_From,sD_To,Lj_Ses,sJ_From,sJ_To,sFsGbn)
IF iFunVal = -1 THEN
	MessageBox('확 인','결산자료 저장 실패!')
	Rollback;
	SetPointer(Arrow!)
	Return -1
ELSEIF iFunVal = -2 THEN
	MessageBox('확 인','금액계산 실패!')
	Rollback;
	SetPointer(Arrow!)
	Return -1
ELSEIF iFunVal = -3 THEN
	MessageBox('확 인','금액(연산)계산 실패!')
	Rollback;
	SetPointer(Arrow!)
	Return -1
ELSEIF iFunVal = 0 THEN	
	F_MessageChk(59,'')
	Rollback;
	SetPointer(Arrow!)
	Return -1
ELSE
	w_mdi_frame.sle_msg.Text = '재무제표 자료 작성 완료!!'
	SetPointer(Arrow!)
	Commit;
END IF

sD_From = Left(sYearMonth,4) + '0101'
sJ_From = String(Long(Left(sYearMonth,4)) - 1,'0000') + '0101'

w_mdi_frame.sle_msg.text = '재무제표 자료 생성 중(누계)...'
SetPointer(HourGlass!)
IF f_closing_copy(sD_From,sD_To,sJ_From,sJ_To) <> 1 THEN
	MessageBox("확 인","실결산집계 실패 !!")
	RETURN -3
END IF

IF cbx_gagyel.Checked = True THEN										/*가결산 포함*/		
	IF f_closing_sum(Left(sD_From,6),Left(sD_To,6)) <> 1 THEN
		MessageBox("확 인","가결산집계 실패 !!")
		RETURN -4
	END IF
END IF

w_mdi_frame.sle_msg.text = '재무제표 자료 생성 중(누계)...'
iFunVal = sqlca.fun_create_fs(sSaupj,Ld_Ses,sD_From,sD_To,Lj_Ses,sJ_From,sJ_To,sFsGbn)
IF iFunVal = -1 THEN
	MessageBox('확 인','결산자료 저장 실패!')
ELSEIF iFunVal = -2 THEN
	MessageBox('확 인','금액계산 실패!')
ELSEIF iFunVal = -3 THEN
	MessageBox('확 인','금액(연산)계산 실패!')
ELSEIF iFunVal = 0 THEN	
	F_MessageChk(59,'')
ELSE
	w_mdi_frame.sle_msg.Text = '재무제표 자료 작성 완료!!'
	SetPointer(Arrow!)
	Return 1
END IF
Rollback;
SetPointer(Arrow!)

Return iFunVal
end function

on w_kgld92.create
int iCurrent
call super::create
this.dw_cond=create dw_cond
this.cbx_1=create cbx_1
this.cbx_jip_account=create cbx_jip_account
this.cbx_jip_person=create cbx_jip_person
this.cbx_jip_cost_account=create cbx_jip_cost_account
this.cbx_jip_cost_person=create cbx_jip_cost_person
this.gb_6=create gb_6
this.gb_5=create gb_5
this.gb_4=create gb_4
this.gb_3=create gb_3
this.gb_2=create gb_2
this.gb_1=create gb_1
this.cbx_6=create cbx_6
this.cbx_gagyel=create cbx_gagyel
this.cbx_12=create cbx_12
this.cbx_13=create cbx_13
this.cbx_15=create cbx_15
this.cbx_16=create cbx_16
this.cbx_17=create cbx_17
this.cbx_18=create cbx_18
this.rb_fs1=create rb_fs1
this.rb_fs2=create rb_fs2
this.rb_fs3=create rb_fs3
this.rb_fs4=create rb_fs4
this.rb_fst=create rb_fst
this.cbx_jip_ilgye=create cbx_jip_ilgye
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_cond
this.Control[iCurrent+2]=this.cbx_1
this.Control[iCurrent+3]=this.cbx_jip_account
this.Control[iCurrent+4]=this.cbx_jip_person
this.Control[iCurrent+5]=this.cbx_jip_cost_account
this.Control[iCurrent+6]=this.cbx_jip_cost_person
this.Control[iCurrent+7]=this.gb_6
this.Control[iCurrent+8]=this.gb_5
this.Control[iCurrent+9]=this.gb_4
this.Control[iCurrent+10]=this.gb_3
this.Control[iCurrent+11]=this.gb_2
this.Control[iCurrent+12]=this.gb_1
this.Control[iCurrent+13]=this.cbx_6
this.Control[iCurrent+14]=this.cbx_gagyel
this.Control[iCurrent+15]=this.cbx_12
this.Control[iCurrent+16]=this.cbx_13
this.Control[iCurrent+17]=this.cbx_15
this.Control[iCurrent+18]=this.cbx_16
this.Control[iCurrent+19]=this.cbx_17
this.Control[iCurrent+20]=this.cbx_18
this.Control[iCurrent+21]=this.rb_fs1
this.Control[iCurrent+22]=this.rb_fs2
this.Control[iCurrent+23]=this.rb_fs3
this.Control[iCurrent+24]=this.rb_fs4
this.Control[iCurrent+25]=this.rb_fst
this.Control[iCurrent+26]=this.cbx_jip_ilgye
this.Control[iCurrent+27]=this.rr_1
end on

on w_kgld92.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_cond)
destroy(this.cbx_1)
destroy(this.cbx_jip_account)
destroy(this.cbx_jip_person)
destroy(this.cbx_jip_cost_account)
destroy(this.cbx_jip_cost_person)
destroy(this.gb_6)
destroy(this.gb_5)
destroy(this.gb_4)
destroy(this.gb_3)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.cbx_6)
destroy(this.cbx_gagyel)
destroy(this.cbx_12)
destroy(this.cbx_13)
destroy(this.cbx_15)
destroy(this.cbx_16)
destroy(this.cbx_17)
destroy(this.cbx_18)
destroy(this.rb_fs1)
destroy(this.rb_fs2)
destroy(this.rb_fs3)
destroy(this.rb_fs4)
destroy(this.rb_fst)
destroy(this.cbx_jip_ilgye)
destroy(this.rr_1)
end on

event open;call super::open;
dw_cond.SetTransObject(Sqlca)
dw_cond.Reset()
dw_cond.InsertRow(0)

dw_cond.SetItem(1,"sym",   Left(F_Today(),6))
dw_cond.SetItem(1,"saupj", Gs_Saupj)

IF F_Authority_Chk(Gs_Dept) = -1 THEN											/*권한 체크- 현업 여부*/
	dw_cond.Modify("saupj.protect = 1")
//	dw_cond.Modify("saupj.background.color ='"+String(RGB(192,192,192))+"'")
ELSE
	dw_cond.Modify("saupj.protect = 0")
//	dw_cond.Modify("saupj.background.color ='"+String(RGB(255,255,255))+"'")
END IF	

cbx_1.Checked = False
cbx_1.TriggerEvent(Clicked!)

cbx_6.Checked = False
cbx_6.TriggerEvent(Clicked!)

dw_cond.SetFocus()
	




end event

type dw_insert from w_inherite`dw_insert within w_kgld92
boolean visible = false
integer x = 32
integer y = 2384
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kgld92
boolean visible = false
integer x = 3543
integer y = 3076
end type

type p_addrow from w_inherite`p_addrow within w_kgld92
boolean visible = false
integer x = 3369
integer y = 3076
end type

type p_search from w_inherite`p_search within w_kgld92
integer x = 4265
string picturename = "C:\Erpman\image\처리_up.gif"
end type

event p_search::ue_lbuttondown;PictureName = "C:\Erpman\image\처리_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\Erpman\image\처리_up.gif"
end event

event p_search::clicked;call super::clicked;String   sYearMonth,sSaupj,sSaupjF,sSaupjT,sNull,sStartYm
Integer  iFunVal

SetNull(sNull)

dw_cond.AcceptText()
sYearMonth = Trim(dw_cond.GetItemString(1,"sym"))
sSaupj     = dw_cond.GetItemString(1,"saupj")

IF sYearMonth = '' OR IsNull(sYearMonth) THEN
	F_MessageChk(1,'[마감년월]')
	dw_cond.SetColumn("sym")
	dw_cond.SetFocus()
	Return
END IF
IF sSaupj = '' OR IsNull(sSaupj) THEN sSaupj = '%'

select nvl(dataname,'000000') into :sStartYm from syscnfg where sysgu = 'A' and serial = 50 and lineno = '1';
if sqlca.sqlcode = 0 then
	if IsNull(sStartYm) or sStartYm = '' then sStartYm = '000000'
else
	sStartYm = '000000'
end if

if sYearMonth < sStartYm then
	MessageBox('확 인','시스템 가동년월 이전은 마감할 수 없습니다')
	Return 
end if

IF cbx_1.Checked = True THEN											/*월집계*/
	String sProcGbn,sCostAcGbn,sCostCustGbn
	
	IF cbx_jip_account.Checked =True AND cbx_jip_person.Checked =False THEN
		sProcGbn ='G'	
	ELSEIF cbx_jip_account.Checked =False AND cbx_jip_person.Checked =True THEN
		sProcGbn ='C'	
	ELSEIF cbx_jip_account.Checked =True AND cbx_jip_person.Checked =True THEN
		sProcGbn ='A'
	ELSE
		sProcGbn ='N'
	END IF

	IF cbx_jip_cost_account.Checked =True  THEN
		sCostAcGbn = 'CG'
	ELSE
		sCostAcGbn = 'N'
	END IF
	IF cbx_jip_cost_person.Checked =True  THEN
		sCostCustGbn = 'CC'
	ELSE
		sCostCustGbn = 'N'
	END IF
	w_mdi_frame.sle_msg.text ="월마감 처리 중..."
	SetPointer(HourGlass!)
	
	Sqlca.Fun_Create_JipGae(sSaupj,sYearMonth,sProcGbn,sCostAcGbn,sCostCustGbn)
	
	Declare i_acsp_100 Procedure For acsp100(:sSaupj,:sYearMonth);
   Execute i_acsp_100;
	
	SetPointer(Arrow!)
	w_mdi_frame.sle_msg.text =''
END IF

IF cbx_6.Checked = True THEN											/*결산자료*/
	iFunVal = Wf_Create_Kfz02wk(sYearMonth,sSaupj)
	IF iFunVal <> 1 THEN
		Rollback;
		w_mdi_frame.sle_msg.text = ''
		SetPointer(Arrow!)
		Return
	END IF
	Commit;
END IF

IF cbx_12.Checked = True THEN											/*예산 집계*/
	Double  li_Return
	
	IF sSaupj = '%' THEN
		sSaupjF = '10';		sSaupjT = '98';
	ELSE
		sSaupjF = sSaupj;		sSaupjT = sSaupj;		
	END IF
	w_mdi_frame.sle_msg.text =" 예산 자료 복구 처리 중......!"

	sqlca.acsp010(sSaupjF,sSaupjT,sYearMonth,sYearMonth,li_Return)
	IF li_return = 2 THEN
		MessageBox('확 인','예산 집계 실패(가집행금액)')
		Rollback;
		w_mdi_frame.sle_msg.text = ''
		SetPointer(Arrow!)
		Return
	END IF
	sqlca.acsp011(sSaupjF,sSaupjT,sYearMonth,sYearMonth,li_Return)
	IF li_return = 2 THEN
		MessageBox('확 인','예산 집계 실패(집행금액)')
		Rollback;
		w_mdi_frame.sle_msg.text = ''
		SetPointer(Arrow!)
		Return
	END IF
END IF

IF cbx_13.Checked = True OR cbx_15.Checked = True THEN		/*경영분석*/
	iFunVal = Wf_Create_Fg(sYearMonth)
	IF iFunVal <> 1 THEN
		Rollback;
		w_mdi_frame.sle_msg.text = ''
		SetPointer(Arrow!)
		Return
	END IF
	Commit;
END IF

IF cbx_17.Checked = True THEN															/*월자금계획 집계*/
	w_mdi_frame.sle_msg.text ="월자금계획자료 작성 중..."
	SetPointer(HourGlass!)
	
	iFunVal = Sqlca.fun_create_kfm12ot0(sYearMonth,'P')
	IF iFunVal <> 1 THEN
		Rollback;
		w_mdi_frame.sle_msg.text = ''
		SetPointer(Arrow!)
		Return
	END IF
	Commit;
END IF

IF cbx_16.Checked = True THEN																/*월자금실적 집계*/
	w_mdi_frame.sle_msg.text ="월자금실적자료 작성 중..."
	SetPointer(HourGlass!)

	iFunVal = Sqlca.fun_create_kfm12ot0(sYearMonth,'S')
	IF iFunVal <> 1 THEN
		Rollback;
		w_mdi_frame.sle_msg.text = ''
		SetPointer(Arrow!)
		Return
	END IF
	Commit;
END IF

IF cbx_18.Checked = True THEN																/*감가상각처리*/
	String  sYearMonthDay,sKfYear
	
	select kfyear	into :sKfYear	from kfa07om0 ;

	if Left(sYearMonth,4) <> sKfYear Then
		Messagebox("확 인","고정자산 회기년도와 같지 않습니다. !")
		dw_cond.SetFocus()
		return
	end if

	sYearMonthDay = F_Last_Date(Left(sYearMonth,4)+Mid(sYearMonth,5,2))
	
	SetPointer(HourGlass!)

	w_mdi_frame.sle_msg.Text = '월 자동 감가 상각 처리 중...'
	iFunVal = Sqlca.fun_calc_depreciation(sYearMonthDay)
	
	IF iFunVal = 0 then
		F_Messagechk(59,'')
		SetPointer(Arrow!)
		w_mdi_frame.sle_msg.Text = ''
		Rollback;
		Return
	ELSEIF iFunVal = -1 then
		F_Messagechk(13,'[감가상각 처리 내역]')
		SetPointer(Arrow!)
		w_mdi_frame.sle_msg.Text = ''
		Rollback;
		Return
	ELSEIF iFunVal = -2 then
		F_Messagechk(13,'[고정자산 잔고]')
		SetPointer(Arrow!)
		w_mdi_frame.sle_msg.Text = ''
		Rollback;
		Return
	ELSEIF iFunVal = -3 then
		F_Messagechk(13,'[변동 내역]')
		SetPointer(Arrow!)
		w_mdi_frame.sle_msg.Text = ''
		Rollback;
		Return
	ELSE
		Commit;
	END IF

	SetPointer(Arrow!)
	w_mdi_frame.sle_msg.Text = '월 자동 감가 상각 처리 완료'
END IF

w_mdi_frame.sle_msg.text = ''
SetPointer(Arrow!)







end event

type p_ins from w_inherite`p_ins within w_kgld92
boolean visible = false
integer x = 3195
integer y = 3076
end type

type p_exit from w_inherite`p_exit within w_kgld92
end type

type p_can from w_inherite`p_can within w_kgld92
boolean visible = false
integer x = 4064
integer y = 3076
end type

type p_print from w_inherite`p_print within w_kgld92
boolean visible = false
integer x = 3474
integer y = 2916
end type

type p_inq from w_inherite`p_inq within w_kgld92
boolean visible = false
integer x = 3296
integer y = 2916
end type

type p_del from w_inherite`p_del within w_kgld92
boolean visible = false
integer x = 3890
integer y = 3076
end type

type p_mod from w_inherite`p_mod within w_kgld92
boolean visible = false
integer x = 3717
integer y = 3076
end type

type cb_exit from w_inherite`cb_exit within w_kgld92
integer x = 3008
integer y = 2488
integer taborder = 30
end type

type cb_mod from w_inherite`cb_mod within w_kgld92
integer x = 2656
integer y = 2488
integer taborder = 20
string text = "처리(&S)"
end type

event cb_mod::clicked;call super::clicked;String   sYearMonth,sSaupj,sSaupjF,sSaupjT,sNull
Integer  iFunVal

SetNull(sNull)

dw_cond.AcceptText()
sYearMonth = Trim(dw_cond.GetItemString(1,"sym"))
sSaupj     = dw_cond.GetItemString(1,"saupj")

IF sYearMonth = '' OR IsNull(sYearMonth) THEN
	F_MessageChk(1,'[마감년월]')
	dw_cond.SetColumn("sym")
	dw_cond.SetFocus()
	Return
END IF
IF sSaupj = '' OR IsNull(sSaupj) THEN sSaupj = '%'

IF cbx_1.Checked = True THEN											/*월집계*/
	String sProcGbn,sCostAcGbn,sCostCustGbn
	
	IF cbx_jip_account.Checked =True AND cbx_jip_person.Checked =False THEN
		sProcGbn ='G'	
	ELSEIF cbx_jip_account.Checked =False AND cbx_jip_person.Checked =True THEN
		sProcGbn ='C'	
	ELSEIF cbx_jip_account.Checked =True AND cbx_jip_person.Checked =True THEN
		sProcGbn ='A'
	ELSE
		sProcGbn ='N'
	END IF

	IF cbx_jip_cost_account.Checked =True  THEN
		sCostAcGbn = 'CG'
	ELSE
		sCostAcGbn = 'N'
	END IF
	IF cbx_jip_cost_person.Checked =True  THEN
		sCostCustGbn = 'CC'
	ELSE
		sCostCustGbn = 'N'
	END IF
	sle_msg.text ="월마감 처리 중..."
	SetPointer(HourGlass!)
	
	Sqlca.Fun_Create_JipGae(sSaupj,sYearMonth,sProcGbn,sCostAcGbn,sCostCustGbn)
	SetPointer(Arrow!)
	sle_msg.text =''
END IF

IF cbx_6.Checked = True THEN											/*결산자료*/
	iFunVal = Wf_Create_Kfz02wk(sYearMonth,sSaupj)
	IF iFunVal <> 1 THEN
		Rollback;
		sle_msg.text = ''
		SetPointer(Arrow!)
		Return
	END IF
	Commit;
END IF

IF cbx_12.Checked = True THEN											/*예산 집계*/
	Double  li_Return
	
	IF sSaupj = '%' THEN
		sSaupjF = '10';		sSaupjT = '98';
	ELSE
		sSaupjF = sSaupj;		sSaupjT = sSaupj;		
	END IF
	sle_msg.text =" 예산 자료 복구 처리 중......!"

	sqlca.acsp010(sSaupjF,sSaupjT,sYearMonth,sYearMonth,li_Return)
	IF li_return = 2 THEN
		MessageBox('확 인','예산 집계 실패(가집행금액)')
		Rollback;
		sle_msg.text = ''
		SetPointer(Arrow!)
		Return
	END IF
	sqlca.acsp011(sSaupjF,sSaupjT,sYearMonth,sYearMonth,li_Return)
	IF li_return = 2 THEN
		MessageBox('확 인','예산 집계 실패(집행금액)')
		Rollback;
		sle_msg.text = ''
		SetPointer(Arrow!)
		Return
	END IF
END IF

IF cbx_13.Checked = True OR cbx_15.Checked = True THEN		/*경영분석*/
	iFunVal = Wf_Create_Fg(sYearMonth)
	IF iFunVal <> 1 THEN
		Rollback;
		sle_msg.text = ''
		SetPointer(Arrow!)
		Return
	END IF
	Commit;
END IF

IF cbx_17.Checked = True THEN															/*월자금계획 집계*/
	sle_msg.text ="월자금계획자료 작성 중..."
	SetPointer(HourGlass!)
	
	iFunVal = Sqlca.fun_create_kfm12ot0(sYearMonth,'P')
	IF iFunVal <> 1 THEN
		Rollback;
		sle_msg.text = ''
		SetPointer(Arrow!)
		Return
	END IF
	Commit;
END IF

IF cbx_16.Checked = True THEN																/*월자금실적 집계*/
	sle_msg.text ="월자금실적자료 작성 중..."
	SetPointer(HourGlass!)

	iFunVal = Sqlca.fun_create_kfm12ot0(sYearMonth,'S')
	IF iFunVal <> 1 THEN
		Rollback;
		sle_msg.text = ''
		SetPointer(Arrow!)
		Return
	END IF
	Commit;
END IF

IF cbx_18.Checked = True THEN																/*감가상각처리*/
	String  sYearMonthDay,sKfYear
	
	select kfyear	into :sKfYear	from kfa07om0 ;

	if Left(sYearMonth,4) <> sKfYear Then
		Messagebox("확 인","고정자산 회기년도와 같지 않습니다. !")
		dw_cond.SetFocus()
		return
	end if

	sYearMonthDay = F_Last_Date(Left(sYearMonth,4)+Mid(sYearMonth,5,2))
	
	SetPointer(HourGlass!)

	sle_msg.Text = '월 자동 감가 상각 처리 중...'
	iFunVal = Sqlca.fun_calc_depreciation(sYearMonthDay)
	
	IF iFunVal = 0 then
		F_Messagechk(59,'')
		SetPointer(Arrow!)
		sle_msg.Text = ''
		Rollback;
		Return
	ELSEIF iFunVal = -1 then
		F_Messagechk(13,'[감가상각 처리 내역]')
		SetPointer(Arrow!)
		sle_msg.Text = ''
		Rollback;
		Return
	ELSEIF iFunVal = -2 then
		F_Messagechk(13,'[고정자산 잔고]')
		SetPointer(Arrow!)
		sle_msg.Text = ''
		Rollback;
		Return
	ELSEIF iFunVal = -3 then
		F_Messagechk(13,'[변동 내역]')
		SetPointer(Arrow!)
		sle_msg.Text = ''
		Rollback;
		Return
	ELSE
		Commit;
	END IF

	SetPointer(Arrow!)
	sle_msg.Text = '월 자동 감가 상각 처리 완료'
END IF

sle_msg.text = ''
SetPointer(Arrow!)







end event

type cb_ins from w_inherite`cb_ins within w_kgld92
integer x = 1399
integer y = 3016
end type

type cb_del from w_inherite`cb_del within w_kgld92
integer x = 1810
integer y = 3020
end type

type cb_inq from w_inherite`cb_inq within w_kgld92
integer x = 1042
integer y = 3016
end type

type cb_print from w_inherite`cb_print within w_kgld92
integer x = 1893
integer y = 2864
end type

type st_1 from w_inherite`st_1 within w_kgld92
end type

type cb_can from w_inherite`cb_can within w_kgld92
integer x = 2167
integer y = 3020
end type

type cb_search from w_inherite`cb_search within w_kgld92
integer x = 2249
integer y = 2864
end type







type gb_button1 from w_inherite`gb_button1 within w_kgld92
integer x = 1006
integer y = 2960
end type

type gb_button2 from w_inherite`gb_button2 within w_kgld92
integer x = 2619
integer y = 2436
integer width = 754
end type

type dw_cond from u_key_enter within w_kgld92
integer x = 663
integer y = 44
integer width = 2912
integer height = 208
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_kgld921"
boolean border = false
end type

event itemchanged;String sNull

SetNull(sNull)

IF this.GetColumnName() = 'sym' THEN
	IF Trim(this.GetText()) = '' OR IsNull(Trim(this.GetText())) THEN Return	
	
	IF Mid(Trim(this.GetText()),5,2) = '00' THEN
		F_MessageChk(16,'[기초자료]')
		this.SetItem(1,"sym",snull)
		Return 1
	END IF
	
	IF F_DateChk(Trim(this.GetText())+'01') = -1 THEN
		F_MessageChk(21,'[마감년월]')
		this.SetItem(1,"sym",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = 'saupj' THEN
	IF Trim(this.GetText()) = '' OR IsNull(Trim(this.GetText())) THEN Return	
	
	IF IsNull(F_Get_Refferance('AD',this.GetText())) THEN
		F_MessageChk(20,'[사업장]')
		this.SetItem(1,"saupj",snull)
		Return 1
	END IF
END IF

end event

event itemerror;Return 1
end event

type cbx_1 from checkbox within w_kgld92
integer x = 818
integer y = 444
integer width = 494
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "월집계 처리"
end type

event clicked;if this.Checked = True then
	cbx_jip_account.Enabled      = True
	cbx_jip_person.Enabled       = True
	cbx_jip_cost_account.Enabled = True
	cbx_jip_cost_person.Enabled  = True
//	cbx_jip_ilgye.Enabled        = True
	
	cbx_jip_account.Checked      = True
	cbx_jip_person.Checked       = True
	cbx_jip_cost_account.Checked = True
	cbx_jip_cost_person.Checked  = True
//	cbx_jip_ilgye.Checked        = True
else
	cbx_jip_account.Enabled      = False
	cbx_jip_person.Enabled       = False
	cbx_jip_cost_account.Enabled = False
	cbx_jip_cost_person.Enabled  = False
//	cbx_jip_ilgye.Enabled        = False
	
	cbx_jip_account.Checked      = False
	cbx_jip_person.Checked       = False
	cbx_jip_cost_account.Checked = False
	cbx_jip_cost_person.Checked  = False
//	cbx_jip_ilgye.Checked        = False
end if
end event

type cbx_jip_account from checkbox within w_kgld92
integer x = 1751
integer y = 444
integer width = 942
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "계정 월집계"
boolean checked = true
end type

type cbx_jip_person from checkbox within w_kgld92
integer x = 2537
integer y = 440
integer width = 471
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "거래처 월집계"
boolean checked = true
end type

type cbx_jip_cost_account from checkbox within w_kgld92
integer x = 1751
integer y = 516
integer width = 773
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "원가부문별 계정별 월집계"
end type

type cbx_jip_cost_person from checkbox within w_kgld92
boolean visible = false
integer x = 2537
integer y = 516
integer width = 942
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "원가부문별 거래처별 월집계"
end type

type gb_6 from groupbox within w_kgld92
integer x = 745
integer y = 1960
integer width = 3077
integer height = 188
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
string text = "고정자산에 대하여 월감감상각비를 계산"
end type

type gb_5 from groupbox within w_kgld92
integer x = 745
integer y = 1640
integer width = 3077
integer height = 256
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
string text = "자금 수지 계획/실적 집계"
end type

type gb_4 from groupbox within w_kgld92
integer x = 745
integer y = 1288
integer width = 3077
integer height = 280
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
string text = "경영분석 자료를 생성(전사 대상)"
end type

type gb_3 from groupbox within w_kgld92
integer x = 745
integer y = 1016
integer width = 3077
integer height = 188
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
string text = "미승인전표와 승인전표를 읽어서 가집행금액과 집행금액을 집계(예산)"
end type

type gb_2 from groupbox within w_kgld92
integer x = 750
integer y = 700
integer width = 3077
integer height = 236
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
string text = "재무제표 자료를 생성(결산)"
end type

type gb_1 from groupbox within w_kgld92
integer x = 750
integer y = 368
integer width = 3081
integer height = 264
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
string text = "계정 잔고 및 거래처잔고를 승인전표를 기준으로 재작성(장부)"
end type

type cbx_6 from checkbox within w_kgld92
integer x = 818
integer y = 760
integer width = 489
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "재무제표 작성"
end type

event clicked;if this.Checked = True then
	rb_fs1.Enabled  = True
	rb_fs2.Enabled  = True
	rb_fs3.Enabled  = True
	rb_fs4.Enabled  = True
	rb_fst.Enabled  = True
	cbx_gagyel.Enabled  = True
	
	rb_fs1.Checked = True
	rb_fs2.Checked = True
	rb_fs3.Checked = True
	rb_fs4.Checked = True
	rb_fst.Checked = True
	cbx_gagyel.Checked  = False
else
	rb_fs1.Enabled = False
	rb_fs2.Enabled = False
	rb_fs3.Enabled = False
	rb_fs4.Enabled = False
	rb_fst.Enabled = False
	cbx_gagyel.Enabled  = False
	
	rb_fs1.Checked = False
	rb_fs2.Checked = False
	rb_fs3.Checked = False
	rb_fs4.Checked = False
	rb_fst.Checked = False
	cbx_gagyel.Checked  = False
end if
end event

type cbx_gagyel from checkbox within w_kgld92
integer x = 905
integer y = 828
integer width = 398
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388736
long backcolor = 32106727
string text = "가결산포함"
end type

type cbx_12 from checkbox within w_kgld92
integer x = 818
integer y = 1088
integer width = 1975
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "예산 실적 집계(미승인전표 -> 가집행금액, 승인전표 -> 집행금액)"
end type

type cbx_13 from checkbox within w_kgld92
integer x = 818
integer y = 1376
integer width = 1568
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "당기 마감자료 변환:결산자료를 경영분석자료로 변환"
end type

type cbx_15 from checkbox within w_kgld92
integer x = 818
integer y = 1464
integer width = 2501
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "년별 경영분석표   :경영분석자료를 경영분석비율코드에 따라 년별 경영분석표로 변환"
end type

type cbx_16 from checkbox within w_kgld92
integer x = 818
integer y = 1796
integer width = 2962
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "월자금수지실적 집계:승인된 회계전표   => 일자금실적 집계,일자금실적 집계 => 월자금수지실적 집계"
end type

type cbx_17 from checkbox within w_kgld92
integer x = 818
integer y = 1716
integer width = 2958
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "월자금수지계획 집계:부서별 월자금계획 => 일자금계획 집계,일자금계획 집계 => 월자금수지계획 집계"
end type

type cbx_18 from checkbox within w_kgld92
integer x = 818
integer y = 2036
integer width = 549
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "감가상각 처리"
end type

type rb_fs1 from radiobutton within w_kgld92
integer x = 1751
integer y = 760
integer width = 663
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "제조원가명세서"
end type

type rb_fs2 from radiobutton within w_kgld92
integer x = 2437
integer y = 764
integer width = 663
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "손익계산서"
end type

type rb_fs3 from radiobutton within w_kgld92
integer x = 3136
integer y = 764
integer width = 663
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "대차대조표"
end type

type rb_fs4 from radiobutton within w_kgld92
integer x = 1751
integer y = 828
integer width = 663
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "이익잉여금처분계산서"
end type

type rb_fst from radiobutton within w_kgld92
integer x = 2437
integer y = 832
integer width = 663
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "전체"
boolean checked = true
end type

type cbx_jip_ilgye from checkbox within w_kgld92
integer x = 3346
integer y = 440
integer width = 384
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = " 일별 집계"
end type

type rr_1 from roundrectangle within w_kgld92
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 594
integer y = 312
integer width = 3387
integer height = 1928
integer cornerheight = 40
integer cornerwidth = 46
end type

