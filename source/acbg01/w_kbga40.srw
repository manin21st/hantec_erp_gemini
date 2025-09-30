$PBExportHeader$w_kbga40.srw
$PBExportComments$예산배정등록
forward
global type w_kbga40 from w_inherite
end type
type rr_1 from roundrectangle within w_kbga40
end type
type dw_ip from datawindow within w_kbga40
end type
type dw_ins from u_key_enter within w_kbga40
end type
end forward

global type w_kbga40 from w_inherite
integer x = 5
integer y = 4
integer width = 4640
string title = "예산 배정 등록"
boolean maxbox = true
boolean resizable = true
rr_1 rr_1
dw_ip dw_ip
dw_ins dw_ins
end type
global w_kbga40 w_kbga40

type variables
long rowno

string LsAutoSungin

end variables

forward prototypes
public function integer wf_warndataloss (string as_titletext)
public subroutine wf_dbchk (string ssaupj, string syear, string scdept, string sacc1, string sacc2)
public subroutine wf_sungin_mode (string sflag)
public subroutine wf_init ()
end prototypes

public function integer wf_warndataloss (string as_titletext);/*=============================================================================================
		 1. window-level user function : 종료, 등록시 호출됨
		    dw_detail 의 typing(datawindow) 변경사항 검사

		 2. 계속진행할 경우 변경사항이 저장되지 않음을 경고                                                               

		 3. Argument:  as_titletext (warning messagebox)                                                                          
		    Return values:                                                   
                                                                  
      	*  1 : 변경사항을 저장하지 않고 계속 진행할 경우.
			* -1 : 진행을 중단할 경우.                      
=============================================================================================*/

IF ib_any_typing = true THEN  				// EditChanged event(dw_detail)의 typing 상태확인

	Beep(1)
	IF MessageBox("확인 : " + as_titletext , &
		 "저장하지 않은 값이 있습니다. ~r변경사항을 저장하시겠습니까", &
		 question!, yesno!) = 1 THEN

		RETURN -1									

	END IF

END IF
																
RETURN 1												// (dw_detail) 에 변경사항이 없거나 no일 경우
														// 변경사항을 저장하지 않고 계속진행 

end function

public subroutine wf_dbchk (string ssaupj, string syear, string scdept, string sacc1, string sacc2);//Integer iDbCnt,i,iCurRow
//
//IF sSaupj = "" OR IsNull(sSaupj) THEN Return 
//IF sYear = "" OR IsNull(sYear) THEN Return 
//IF sCdept = "" OR IsNull(sCdept) THEN Return 
//IF sAcc1 = "" OR IsNull(sAcc1) THEN Return 
//IF sAcc2 = "" OR IsNull(sAcc2) THEN Return 
//
//select Count(*) 	into :iDbCnt
//	from kfe01om0
//	where saupj = :sSaupj and acc_yy = :sYear and acc1_cd = :sAcc1 and 
//			acc2_cd = :sAcc2 and dept_cd = :sCdept;
//if sqlca.sqlcode <> 0 then
//	iDbCnt = 0
//else
//	If IsNull(iDbCnt) THEN iDbCnt = 0
//end if
//
//if iDbCnt <=0 then
//   dw_ip2.Reset()
//   for i= 1 to 12
//		iCurRow = dw_ip2.Insertrow(0)
//		if iCurRow >= 1 and iCurRow <= 3 then 
//			dw_ip2.SetItem(iCurRow, 'quarter', '1')    /* 1/4분기  */
//		elseif iCurRow >= 4 and iCurRow <= 6 then 
//			dw_ip2.SetItem(iCurRow, 'quarter', '2')	 /*  2/4분기 */
//		elseif iCurRow >= 7 and iCurRow <= 9 then 
//			dw_ip2.SetItem(iCurRow, 'quarter', '3')    /* 1/4분기  */
//		elseif iCurRow >= 10 and iCurRow <= 12 then 
//			dw_ip2.SetItem(iCurRow, 'quarter', '4')	 /*  2/4분기 */
//		end if
//		dw_ip2.SetItem(iCurRow, 'gubun1', LsAutoSungIn) 
//   next
//	sModStatus ="I"
//else
//	dw_ip.Retrieve(sSaupj,sYear,sAcc1,sAcc2,sCdept)
//	dw_ip2.Retrieve(sSaupj,sYear,sCdept,sAcc1,sAcc2)
//	
//	Wf_SungIn_Mode(dw_ip2.GetItemString(1,"gubun1"))
//end if
//
end subroutine

public subroutine wf_sungin_mode (string sflag);//
//IF sFlag = 'Y' THEN								/*승인*/
//	w_mdi_frame.sle_msg.text ='승인된 예산은 수정,삭제할 수 없습니다...'
//	
//	p_del.Enabled = False
//	p_del.PictureName = "C:\erpman\image\삭제_d.gif"
//	p_mod.Enabled = False
//	p_mod.PictureName = "C:\erpman\image\저장_d.gif"
//	
//	dw_ip2.Enabled = False
//ELSE
//	w_mdi_frame.sle_msg.text =''
//	p_del.Enabled = True
//	p_del.PictureName = "C:\erpman\image\삭제_up.gif"
//	p_mod.Enabled = True
//	p_mod.PictureName = "C:\erpman\image\저장_up.gif"
//	
//	dw_ip2.Enabled = True
//END IF
//dw_ip.Modify("dept_cd.protect = 1")
//
//dw_ip.SetColumn("bgk_txt")
////dw_ip.Setfocus()
//
//
end subroutine

public subroutine wf_init ();Integer  i,ll_CntRow

dw_ip.SetRedraw(False)
dw_ip.Reset()
dw_ip.InsertRow(0)

dw_ip.SetItem(dw_ip.GetRow(),"saupj",  gs_saupj)
dw_ip.Setitem(dw_ip.Getrow(),"acc_yy", Left(F_Today(),4))
dw_ip.Setitem(dw_ip.Getrow(),"dept_cd",gs_dept)

IF F_Valid_EmpNo(Gs_EmpNo) = 'Y' THEN
	dw_ip.Modify("saupj.protect = 0")
	
	dw_ip.Modify("dept_cd.protect = 0")
	dw_ip.SetColumn("dept_cd")
ELSE
	dw_ip.Modify("saupj.protect = 1")
	
	dw_ip.Modify("dept_cd.protect = 1")
	dw_ip.SetColumn("acc_yy")
END IF
dw_ip.SetFocus()
dw_ip.SetRedraw(True)

sModStatus ="I"

dw_ins.Reset()

ib_any_typing  = false

p_del.Enabled = false
p_del.PictureName = "C:\erpman\image\삭제_d.gif"

p_mod.Enabled = False
p_mod.PictureName = "C:\erpman\image\저장_d.gif"




end subroutine

event open;call super::open;long i,ll_cntrow

dw_ip.settransobject(sqlca)
dw_ins.settransobject(sqlca)

SELECT "SYSCNFG"."DATANAME"      INTO :LsAutoSungin  
	FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 7 ) AND  
         ( "SYSCNFG"."LINENO" = '2' )   ;
IF SQLCA.SQLCODE <> 0 THEN
	LsAutoSungIn = 'N'
ELSE
	IF IsNull(LsAutoSungIn) OR LsAutoSungIn = '' THEN LsAutoSungIn = 'N'
END IF

Wf_Init()
end event

on w_kbga40.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.dw_ip=create dw_ip
this.dw_ins=create dw_ins
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.dw_ip
this.Control[iCurrent+3]=this.dw_ins
end on

on w_kbga40.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.dw_ip)
destroy(this.dw_ins)
end on

type dw_insert from w_inherite`dw_insert within w_kbga40
boolean visible = false
integer taborder = 80
end type

type p_delrow from w_inherite`p_delrow within w_kbga40
boolean visible = false
integer x = 3707
integer y = 2992
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kbga40
boolean visible = false
integer x = 3703
integer y = 2832
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kbga40
boolean visible = false
integer x = 3511
integer taborder = 0
string picturename = "C:\erpman\image\검색_up.gif"
end type

event p_search::clicked;call super::clicked;//w_mdi_frame.sle_msg.text =""
//
//string sSaupj, sYear, sCdept
//long   lrowno, ll_cntrow,i
//
//if dw_ip.AcceptText() = -1 then return 
//
//sSaupj = dw_ip.Getitemstring(dw_ip.GetRow(),"saupj")
//sYear  = dw_ip.Getitemstring(dw_ip.GetRow(),"acc_yy")
//sCdept = dw_ip.Getitemstring(dw_ip.GetRow(),"dept_cd")
//
//if dw_ret.Retrieve(sSaupj, sYear, sCdept) <=0 then	
//	F_MessageChk(14,'')
//   return	
//END IF
//
//
end event

event ue_lbuttondown;PictureName = "C:\erpman\image\검색_dn.gif"
end event

event ue_lbuttonup;PictureName = "C:\erpman\image\검색_up.gif"
end event

type p_ins from w_inherite`p_ins within w_kbga40
boolean visible = false
integer x = 3712
integer y = 2664
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_kbga40
integer x = 4389
integer taborder = 70
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type p_can from w_inherite`p_can within w_kbga40
integer x = 4215
integer taborder = 60
end type

event p_can::clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

dw_ins.Reset()
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

type p_print from w_inherite`p_print within w_kbga40
boolean visible = false
integer x = 3707
integer y = 3152
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kbga40
integer x = 3694
integer taborder = 30
end type

event p_inq::clicked;
string  sSaupj, sYear, sCdept, sYeGbn

IF dw_ip.Accepttext() = -1 THEN Return

w_mdi_frame.sle_msg.text =""

sSaupj = dw_ip.Getitemstring(dw_ip.GetRow(),"saupj")
sYear  = dw_ip.Getitemstring(dw_ip.GetRow(),"acc_yy")
sCdept = dw_ip.Getitemstring(dw_ip.GetRow(),"dept_cd")
sYeGbn = dw_ip.Getitemstring(dw_ip.GetRow(),"yegu")

if sSaupj = "" or Isnull(sSaupj) then
	F_MessageChk(1,'[사업장]')
   dw_ip.SetColumn("saupj")
   dw_ip.SetFocus()
   return
end if

if sYear = "" or Isnull(sYear) then
	F_MessageChk(1,'[회계년도]')
   dw_ip.SetColumn("acc_yy")
   dw_ip.SetFocus()
   return
else
	if Not Isnumber(sYear) then
		F_MessageChk(21,'[회계년도]')
   	dw_ip.SetColumn("acc_yy")
   	dw_ip.SetFocus()
   	return
	end if
end if

if sCdept = "" or Isnull(sCdept) then
	F_MessageChk(1,'[배정부서]')
   dw_ip.SetColumn("dept_cd")
   dw_ip.SetFocus()
   return
end if
if sYeGbn = '' or IsNull(sYeGbn) then sYeGbn = '%'

if dw_ins.Retrieve(sYeGbn,sSaupj,sYear,sCdept) <=0 then
	F_MessageChk(14,'')
	Return
end if

p_del.Enabled = True
p_del.PictureName = "C:\erpman\image\삭제_up.gif"

p_mod.Enabled = True
p_mod.PictureName = "C:\erpman\image\저장_up.gif"

w_mdi_frame.sle_msg.text = '자료를 조회하였습니다'
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조회_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조회_up.gif"
end event

type p_del from w_inherite`p_del within w_kbga40
integer x = 4041
integer taborder = 50
end type

event p_del::clicked;call super::clicked;String  sSaupj, sYear, sCdept,sAcc1,sAcc2,sConFirm,sAccNm
Double  dAmount

IF dw_ip.Accepttext() = -1 THEN Return

w_mdi_frame.sle_msg.text =""

sSaupj = dw_ip.Getitemstring(dw_ip.GetRow(),"saupj")
sYear  = dw_ip.Getitemstring(dw_ip.GetRow(),"acc_yy")
sCdept = dw_ip.Getitemstring(dw_ip.GetRow(),"dept_cd")

if dw_ins.GetRow() <=0 then 
	F_MessageChk(11,'')
	Return
end if

sAcc1    = Left(dw_ins.GetItemString(dw_ins.GetRow(),"acno"),5)
sAcc2    = Right(dw_ins.GetItemString(dw_ins.GetRow(),"acno"),2)
sAccNm   = dw_ins.GetItemString(dw_ins.GetRow(),"acnm")
sConFirm = dw_ins.GetItemString(dw_ins.GetRow(),"gubun1")

if sConFirm = 'Y' then
	Messagebox("확 인","승인된 자료는 삭제할 수 없습니다.")
	dw_ip.SetFocus()
   return	
end if

select sum(nvl(bgk_amt7,0) + nvl(bgk_amt8,0))	into :dAmount
	from kfe01om0
	where saupj = :sSaupj and acc_yy = :sYear and acc1_cd = :sAcc1 and 
			acc2_cd = :sAcc2 and dept_cd = :sCdept ;
IF SQLCA.SQLCODE <> 0 THEN
	dAmount = 0
ELSE
	IF IsNull(dAmount) THEN dAmount = 0
END IF

if dAmount > 0 then
	Messagebox("확 인","집행 또는 가집행실적금액이 존재하므로 삭제할 수 없습니다...")
	dw_ip.SetFocus()
   return
end if

if MessageBox('확 인','['+sAccNm+'] 계정의 배정자료를 모두 삭제하시겠습니까',Question!,YesNo!) = 2 then Return

SetPointer(HourGlass!)
w_mdi_frame.sle_msg.Text = '자료 삭제 중...'

Integer k
String  sMonth

for k = 1 to 12
	sMonth = String(k,'00')
	
	delete from kfe01om0
		where saupj = :sSaupj and acc_yy = :sYear and acc_mm = :sMonth and
				acc1_cd = :sAcc1 and acc2_cd = :sAcc2 and dept_cd = :sCdept ;
		
	if sqlca.sqlcode <> 0 then
		Rollback;
		F_MessageChk(13,'')
		SetPointer(Arrow!)	
		Return
	end if
next
Commit;

SetPointer(Arrow!)	
w_mdi_frame.sle_msg.text = "자료가 삭제되었습니다!"

p_inq.TriggerEvent(Clicked!)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\삭제_up.gif"
end event

type p_mod from w_inherite`p_mod within w_kbga40
integer x = 3867
integer taborder = 40
end type

event p_mod::clicked;string  sSaupj, sYear, sCdept, sYeGbn, sModSts

IF dw_ip.Accepttext() = -1 THEN Return

w_mdi_frame.sle_msg.text =""

sSaupj = dw_ip.Getitemstring(dw_ip.GetRow(),"saupj")
sYear  = dw_ip.Getitemstring(dw_ip.GetRow(),"acc_yy")
sCdept = dw_ip.Getitemstring(dw_ip.GetRow(),"dept_cd")
sYeGbn = dw_ip.Getitemstring(dw_ip.GetRow(),"yegu")

if sSaupj = "" or Isnull(sSaupj) then
	F_MessageChk(1,'[사업장]')
   dw_ip.SetColumn("saupj")
   dw_ip.SetFocus()
   return
end if

if sYear = "" or Isnull(sYear) then
	F_MessageChk(1,'[회계년도]')
   dw_ip.SetColumn("acc_yy")
   dw_ip.SetFocus()
   return
else
	if Not Isnumber(sYear) then
		F_MessageChk(21,'[회계년도]')
   	dw_ip.SetColumn("acc_yy")
   	dw_ip.SetFocus()
   	return
	end if
end if

if sCdept = "" or Isnull(sCdept) then
	F_MessageChk(1,'[배정부서]')
   dw_ip.SetColumn("dept_cd")
   dw_ip.SetFocus()
   return
end if

Integer iRowCount,i,k,iDbRow
String  sAcc1,sAcc2,sMonth,sConFirm,sBgkTxt,sQtr
String  sAmt_Name[]={'gicho01','gicho02','gicho03','gicho04','gicho05','gicho06',&
							'gicho07','gicho08','gicho09','gicho10','gicho11','gicho12'}
Double  dAmt

IF dw_ins.Accepttext() = -1 THEN Return
iRowCount = dw_ins.RowCount()
if iRowCount <=0 then Return

SetPointer(HourGlass!)
w_mdi_frame.sle_msg.Text = '자료 저장 중...'

FOR i = 1 TO iRowCount
	sModSts  = dw_ins.GetItemString(i,"status")
	if sModSts = 'R' then continue
	
	sAcc1    = Left(dw_ins.GetItemString(i,"acno"),5)
	sAcc2    = Right(dw_ins.GetItemString(i,"acno"),2)
	sConFirm = dw_ins.GetItemString(i,"gubun1")
	sBgkTxt  = dw_ins.GetItemString(i,"bgk_txt")
	
	if sConFirm = 'Y' then Continue
	
	for k = 1 to 12
		sMonth = String(k,'00')
		
		choose case k
			case 1 to 3	
				sQtr = '1'
			case 4 to 6	
				sQtr = '2'
			case 7 to 9	
				sQtr = '3'
			case else
				sQtr = '4'
		end choose
		
		dAmt = dw_ins.GetItemNumber(i,sAmt_Name[k])
		if IsNull(dAmt) then dAmt = 0
		
		select Count(*) into :iDbRow from kfe01om0
			where saupj = :sSaupj and acc_yy = :sYear and acc_mm = :sMonth and
					acc1_cd = :sAcc1 and acc2_cd = :sAcc2 and dept_cd = :sCdept ;
		if sqlca.sqlcode = 0 and iDbRow > 0 then
			update kfe01om0
				set bgk_amt1 = :dAmt,
					 bgk_txt  = :sBgkTxt,
					 gubun1   = :LsAutoSungIn,
					 quarter  = :sQtr
				where saupj = :sSaupj and acc_yy = :sYear and acc_mm = :sMonth and
						acc1_cd = :sAcc1 and acc2_cd = :sAcc2 and dept_cd = :sCdept ;
		else
			insert into kfe01om0
				(saupj,		acc_yy,		acc_mm,		acc1_cd,		acc2_cd,		dept_cd,
				 bgk_amt1,	bgk_amt2,	bgk_amt3,	bgk_amt4,	bgk_amt5,	bgk_amt6,
				 bgk_amt7,	bgk_amt8,	bgk_txt,		bgk_amtb,	quarter,		gubun1)
			values
				(:sSaupj,	:sYear,		:sMonth,		:sAcc1,		:sAcc2,		:sCdept,
				 :dAmt,		0,				0,				0,				0,				0,
				 0,			0,				:sBgkTxt,	:dAmt,		:sQtr,		:LsAutoSungIn);
		end if
		if sqlca.sqlcode <> 0 then
			Rollback;
			F_MessageChk(13,'')
			SetPointer(Arrow!)
			Return
		end if
	next
	Commit;
NEXT
SetPointer(Arrow!)
w_mdi_frame.sle_msg.text = "자료가 저장되었습니다!"

p_inq.TriggerEvent(Clicked!)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

type cb_exit from w_inherite`cb_exit within w_kbga40
end type

type cb_mod from w_inherite`cb_mod within w_kbga40
end type

type cb_ins from w_inherite`cb_ins within w_kbga40
end type

type cb_del from w_inherite`cb_del within w_kbga40
end type

type cb_inq from w_inherite`cb_inq within w_kbga40
end type

type cb_print from w_inherite`cb_print within w_kbga40
end type

type st_1 from w_inherite`st_1 within w_kbga40
end type

type cb_can from w_inherite`cb_can within w_kbga40
end type

type cb_search from w_inherite`cb_search within w_kbga40
end type







type gb_button1 from w_inherite`gb_button1 within w_kbga40
end type

type gb_button2 from w_inherite`gb_button2 within w_kbga40
end type

type rr_1 from roundrectangle within w_kbga40
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 184
integer width = 4503
integer height = 2008
integer cornerheight = 40
integer cornerwidth = 46
end type

type dw_ip from datawindow within w_kbga40
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 55
integer y = 28
integer width = 3557
integer height = 132
integer taborder = 10
string dataobject = "dw_kbga40_1"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)

Return 1
end event

event ue_key;IF keydown(keyF1!) or keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;String sSaupj, sCdept, sAcc1, sAcc2, sAccName,snull

SetNull(snull)

if this.GetColumnName() = 'saupj' then 
   sSaupj   = this.GetText()
	if isnull(sSaupj) or trim(sSaupj) = '' then Return
	
	IF IsNull(F_Get_Refferance('AD',sSaupj)) THEN
		F_MessageChk(20,'[사업장]')
		this.SetItem(this.GetRow(),"saupj",sNull)
		Return 1
	END IF
	
	Wf_DbChk(sSaupj,	this.GetItemString(this.GetRow(),"acc_yy"),&
							this.GetItemString(this.GetRow(),"dept_cd"),&
							this.GetItemString(this.GetRow(),"acc1_cd"),&
							this.GetItemString(this.GetRow(),"acc2_cd"))
end if

if this.GetColumnName() = "acc_yy" then
	IF this.GetText() = "" OR IsNull(this.GetText()) THEN Return
	
	Wf_DbChk(this.GetItemString(this.GetRow(),"saupj"),	this.GetText(),&
							this.GetItemString(this.GetRow(),"dept_cd"),&
							this.GetItemString(this.GetRow(),"acc1_cd"),&
							this.GetItemString(this.GetRow(),"acc2_cd"))
end if
if this.GetColumnName() = 'dept_cd' then
	sCdept = this.GetText()
	if isnull(sCdept) or trim(sCdept) = "" then Return
	
	select deptcode	into :sCdept	from kfe03om0 where deptcode = :sCdept ;
	IF Sqlca.Sqlcode <> 0 then 	
	   F_MessageChk(20,'[예산부서]')						
		this.SetItem(this.GetRow(), 'dept_cd', snull)
		return 1
	end if 

	Wf_DbChk(this.GetItemString(this.GetRow(),"saupj"),&
				this.GetItemString(this.GetRow(),"acc_yy"),&
				sCdept,&
				this.GetItemString(this.GetRow(),"acc1_cd"),&
				this.GetItemString(this.GetRow(),"acc2_cd"))
end if

if this.GetColumnName() = 'acc1_cd' then 
	sAcc1 = this.GetText()
	IF sAcc1 = "" OR IsNull(sAcc1) THEN Return
	
	sAcc2 = this.Getitemstring(this.Getrow(),"acc2_cd")
	IF sAcc2 = "" OR IsNull(sAcc2) THEN Return
	
	SELECT "ACC1_NM"||NVL("YACC2_NM",'')   		INTO :sAccName
		FROM "KFZ01OM0"  
		WHERE "ACC1_CD" = :sAcc1 and "ACC2_CD" = :sAcc2 and 
				("YESAN_GU" = 'A' OR "YESAN_GU" = 'Y');
	If sqlca.sqlcode = 0 then
		dw_ip.Setitem(dw_ip.Getrow(),"accname", sAccName)		  
	else
		F_MessageChk(20,'[계정과목]')
		dw_ip.Setitem(dw_ip.Getrow(),"acc1_cd",sNull)
		dw_ip.Setitem(dw_ip.Getrow(),"acc2_cd",sNull)
		dw_ip.Setitem(dw_ip.Getrow(),"accname",sNull)
		Return 1
	end if
	Wf_DbChk(this.GetItemString(this.GetRow(),"saupj"),&
				this.GetItemString(this.GetRow(),"acc_yy"),&
				this.GetItemString(this.GetRow(),"dept_cd"),sAcc1,sAcc2)
end if

if this.GetColumnName() = 'acc2_cd' then 
	sAcc2 = this.GetText()
	IF sAcc2 = "" OR IsNull(sAcc2) THEN Return
	
	sAcc1 = this.Getitemstring(this.Getrow(),"acc1_cd")
	IF sAcc1 = "" OR IsNull(sAcc1) THEN Return
	
	SELECT "ACC1_NM"||NVL("YACC2_NM",'')   		INTO :sAccName
		FROM "KFZ01OM0"  
		WHERE "ACC1_CD" = :sAcc1 and "ACC2_CD" = :sAcc2 and 
				("YESAN_GU" = 'A' OR "YESAN_GU" = 'Y');
	If sqlca.sqlcode = 0 then
		dw_ip.Setitem(dw_ip.Getrow(),"accname", sAccName)		  
	else
		F_MessageChk(20,'[계정과목]')
		dw_ip.Setitem(dw_ip.Getrow(),"acc1_cd",sNull)
		dw_ip.Setitem(dw_ip.Getrow(),"acc2_cd",sNull)
		dw_ip.Setitem(dw_ip.Getrow(),"accname",sNull)
		dw_ip.SetColumn("acc1_cd")
		Return 1
	end if
	Wf_DbChk(this.GetItemString(this.GetRow(),"saupj"),&
				this.GetItemString(this.GetRow(),"acc_yy"),&
				this.GetItemString(this.GetRow(),"dept_cd"),sAcc1,sAcc2)
end if

end event

event rbuttondown;
IF this.GetColumnName() = "acc1_cd" THEN 
	SetNull(gs_code)

	IF IsNull(gs_code) then
		gs_code =""
	end if
	
	Open(W_KFE01OM0_POPUP)
	
	if gs_code <> "" and Not IsNull(gs_code) then
		dw_ip.SetItem(dw_ip.GetRow(), "acc1_cd", Left(gs_code,5))
		dw_ip.SetItem(dw_ip.GetRow(), "acc2_cd", Mid(gs_code,6,2))
		this.TriggerEvent(ItemChanged!)
	end if
END IF

end event

event itemerror;return 1
end event

event buttonclicked;string sMsgParm, ls_bgk_txt

if dwo.name = 'bb_bgk_txt' then 
	
	SetNUll(lstr_jpra.saupjang);	SetNUll(lstr_jpra.BalDate);	SetNUll(lstr_jpra.dept);
	SetNUll(lstr_jpra.acc1);		SetNUll(lstr_jpra.acc2);
	
	lstr_jpra.saupjang = this.GetItemString(row, 'saupj')        /* 사업장 */
	lstr_jpra.BalDate  = this.GetItemString(row, 'acc_yy')       /* 회계년도 */
	lstr_jpra.dept     = this.GetItemString(row, 'dept_cd')      /* 배정부서 */
	lstr_jpra.acc1     = this.GetItemString(row, 'acc1_cd')      /* 계정과목 */  
	lstr_jpra.acc2     = this.GetItemString(row, 'acc2_cd')      /* 분류항목 */
	ls_bgk_txt =         this.GetItemString(row,"bgk_txt")       /* 편성근거 */
	
	if isnull(lstr_jpra.saupjang) or trim(lstr_jpra.saupjang) ='' then
   	F_MessageChk(1, "[사업장]")	
		this.SetColumn("saupj")
		return
	end if
	if isnull(lstr_jpra.BalDate) or trim(lstr_jpra.BalDate) = '' then 
   	F_MessageChk(1, "[회계년도]")					
		this.SetColumn("acc_yy")
		return 
	end if
	if isnull(lstr_jpra.dept) or trim(lstr_jpra.dept) = '' then 
   	F_MessageChk(1, "[배정부서]")							
		this.SetColumn("dept_cd")
		return 
	end if
	
	if isnull(lstr_jpra.acc1) or trim(lstr_jpra.acc1) = '' then 
   	F_MessageChk(1, "[계정과목]")									
		this.SetColumn("acc1_cd")
		return 
	end if
	
	if isnull(lstr_jpra.acc2) or trim(lstr_jpra.acc2) = '' then 
   	F_MessageChk(1, "[분류항목]")											
		this.SetColumn("acc2_cd")
		return 	
	end if
	
	OpenWithParm(w_kbga01_01, ls_bgk_txt)
	
	sMsgParm = Message.StringParm
	
	IF Left(sMsgParm,1) = '1' THEN											/*적요 변경 YES*/
		ib_any_typing = True
	END IF		
	
	this.SetItem(this.GetRow(),"bgk_txt",Trim(Mid(sMsgParm,2,90)))
end if

end event

event getfocus;this.AcceptText()
end event

type dw_ins from u_key_enter within w_kbga40
integer x = 64
integer y = 192
integer width = 4480
integer height = 1988
integer taborder = 20
boolean bringtotop = true
string dataobject = "dw_kbga40_2"
boolean vscrollbar = true
boolean border = false
end type

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;call super::itemchanged;this.SetItem(this.GetRow(),"status",'M')
end event

