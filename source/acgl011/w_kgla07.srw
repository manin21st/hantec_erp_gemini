$PBExportHeader$w_kgla07.srw
$PBExportComments$월할 선급비용 등록
forward
global type w_kgla07 from w_inherite
end type
type dw_1 from datawindow within w_kgla07
end type
type cb_1 from commandbutton within w_kgla07
end type
type cb_2 from commandbutton within w_kgla07
end type
type dw_2 from datawindow within w_kgla07
end type
type st_2 from statictext within w_kgla07
end type
type rr_1 from roundrectangle within w_kgla07
end type
end forward

global type w_kgla07 from w_inherite
string title = "월할 선급비용 등록"
dw_1 dw_1
cb_1 cb_1
cb_2 cb_2
dw_2 dw_2
st_2 st_2
rr_1 rr_1
end type
global w_kgla07 w_kgla07

forward prototypes
public function integer wf_requiredchk ()
end prototypes

public function integer wf_requiredchk ();String  sDate, sSaupj, sAcc1, sAcc2,sCdeptCd,sRacCode,sStart,sEnd,sDescr, sBalDate     
long    lJunNo, lLinNo,lBJunNo,iCount
Double  dAmt

dw_1.AcceptText()
sSaupj   = dw_1.GetItemString(1,"saupj") 
sDate    = dw_1.GetItemString(1,"acc_date")
lJunNo   = dw_1.GetItemnumber(1,"jun_no")
lLinNo   = dw_1.GetItemnumber(1,"lin_no")
sBalDate = dw_1.GetItemString(1,"bal_date")
lBJunNo  = dw_1.GetItemnumber(1,"bjun_no")
sAcc1    = dw_1.GetItemString(1,"acc1_cd")
sAcc2    = dw_1.GetItemString(1,"acc2_cd")

sCdeptCd = dw_1.GetItemString(1,"cdept_cd")
dAmt     = dw_1.GetItemNumber(1,"amt")
sDescr   = dw_1.GetItemString(1,"descr")

sRacCode = dw_1.GetItemString(1,"racc_cd")
sStart   = dw_1.GetItemString(1,"k_symd")
sEnd     = dw_1.GetItemString(1,"k_eymd")

if sModStatus = 'I' then
	select Count(*)	into :iCount									/*중복체크*/
		from kfz31ot0
		where saupj = :sSaupj and acc_date = :sDate and upmu_gu = 'A' and jun_no = :lJunNo and
				lin_no = :lLinNo and bal_date = :sBalDate and bjun_no = :lBjunNo;
	if iCount <> 0 then
		F_MessageChk(10,'')
		dw_1.SetColumn("jun_no")
		dw_1.SetFocus()
		Return -1
	end if
end if

IF sSaupj = "" OR IsNull(sSaupj) THEN
	F_MessageChk(1,'[사업장]')
	dw_1.SetColumn("saupj")
	dw_1.SetFocus()
	Return -1
END IF

IF sDate = "" OR IsNull(sDate) THEN
	F_MessageChk(1,'[회계일자]')
	dw_1.SetColumn("acc_date")
	dw_1.SetFocus()
	Return -1
ELSE
	IF sBalDate = '' OR IsNull(sBalDate) THEN
		dw_1.SetItem(1,"bal_date",  sDate)
	END IF
END IF 

IF lJunNo = 0 OR IsNull(lJunNo) THEN
	F_MessageChk(1,'[전표번호]')
	dw_1.SetColumn("jun_no")
	dw_1.SetFocus()
	Return -1
ELSE
	IF lBJunNo = 0 OR IsNull(lBJunNo) THEN
		dw_1.SetItem(1,"bjun_no", lJunNo)
	END IF
END IF 

IF lLinNo = 0 OR IsNull(lLinNo) THEN
	F_MessageChk(1,'[라인번호]')
	dw_1.SetColumn("lin_no")
	dw_1.SetFocus()
	Return -1
END IF 

IF sAcc1 = "" OR IsNull(sAcc1) THEN
	F_MessageChk(1,'[계정과목]')
	dw_1.SetColumn("acc1_cd")
	dw_1.SetFocus()
	Return -1
END IF

IF sAcc2 = "" OR IsNull(sAcc2) THEN
	F_MessageChk(1,'[계정과목]')
	dw_1.SetColumn("acc2_cd")
	dw_1.SetFocus()
	Return -1
END IF

//IF sCdeptCd = "" OR IsNull(sCdeptCd) THEN
//	F_MessageChk(1,'[원가부문]')
//	dw_1.SetColumn("cdept_cd")
//	dw_1.SetFocus()
//	Return -1
//END IF

IF dAmt = 0 OR IsNull(dAmt) THEN
	F_MessageChk(1,'[전표금액]')
	dw_1.SetColumn("amt")
	dw_1.SetFocus()
	Return -1
END IF

IF sDescr = "" OR IsNull(sDescr) THEN
	F_MessageChk(1,'[적요]')
	dw_1.SetColumn("descr")
	dw_1.SetFocus()
	Return -1
END IF

IF sStart = "" OR IsNull(sStart) THEN
	F_MessageChk(1,'[기산일]')
	dw_1.SetColumn("k_symd")
	dw_1.SetFocus()
	Return -1
END IF

IF sEnd = "" OR IsNull(sEnd) THEN
	F_MessageChk(1,'[만기일]')
	dw_1.SetColumn("k_eymd")
	dw_1.SetFocus()
	Return -1
END IF

IF sStart > sEnd THEN
	F_MessageChk(26,'[기산일>만기일]')
	dw_1.SetColumn("k_symd")
	dw_1.SetFocus()
	Return -1
END IF

IF sRacCode = "" OR IsNull(sRacCode) THEN
	F_MessageChk(1,'[대체계정]')
	dw_1.SetColumn("racc_cd")
	dw_1.SetFocus()
	Return -1
END IF

Return 1
end function

on w_kgla07.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.cb_1=create cb_1
this.cb_2=create cb_2
this.dw_2=create dw_2
this.st_2=create st_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.cb_2
this.Control[iCurrent+4]=this.dw_2
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.rr_1
end on

on w_kgla07.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.dw_2)
destroy(this.st_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_1.settransobject(sqlca)
dw_1.Reset()
dw_1.insertrow(0)

dw_1.SetItem(1, "saupj",    Gs_Saupj)
dw_1.SetItem(1, "acc_date", f_today())
dw_1.SetItem(1, "bal_date", f_today())

dw_1.setfocus()

IF F_Authority_Chk(Gs_Dept) = -1 THEN							/*권한 체크- 현업 여부*/
	dw_1.Modify("saupj.protect = 1")
ELSE
	dw_1.Modify("saupj.protect = 0")
END IF	

dw_2.settransobject(sqlca)

sModStatus = 'I'


end event

type dw_insert from w_inherite`dw_insert within w_kgla07
boolean visible = false
integer x = 0
integer y = 2608
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kgla07
boolean visible = false
integer x = 2862
integer y = 2880
end type

type p_addrow from w_inherite`p_addrow within w_kgla07
boolean visible = false
integer x = 2688
integer y = 2880
end type

type p_search from w_inherite`p_search within w_kgla07
integer x = 3451
integer y = 28
string picturename = "C:\Erpman\image\검색_up.gif"
end type

event p_search::clicked;call super::clicked;Integer  iCount

dw_1.SetRedraw(True)
dw_2.SetRedraw(True)

if dw_1.AcceptText() = -1 then return 
if dw_1.getrow() <= 0 then return

setnull(lstr_jpra.saupjang);		setnull(lstr_jpra.baldate);		setnull(lstr_jpra.bjunno);
setnull(lstr_jpra.sortno);			setnull(lstr_jpra.upmugu);			setnull(lstr_jpra.accdate);		setnull(lstr_jpra.junno);

OpenWithParm(w_kgla071, Trim(dw_1.GetItemString(1,"acc_date")))

if isnull(lstr_jpra.baldate) or trim(lstr_jpra.baldate) = '' then return 

IF dw_1.retrieve(lstr_jpra.saupjang,lstr_jpra.accdate,lstr_jpra.upmugu,lstr_jpra.junno,lstr_jpra.sortno,lstr_jpra.baldate,lstr_jpra.bjunno) <=0 then

	dw_1.InsertRow(0)
	
	dw_1.SetItem(1, "saupj",    Gs_Saupj)
	dw_1.SetItem(1, "acc_date", f_today())
	dw_1.SetItem(1, "bal_date", f_today())
	
	IF F_Authority_Chk(Gs_Dept) = -1 THEN							/*권한 체크- 현업 여부*/
		dw_1.Modify("saupj.protect = 1")
//		dw_1.Modify("saupj.background.color ='"+String(RGB(192,192,192))+"'")
	ELSE
		dw_1.Modify("saupj.protect = 0")
//		dw_1.Modify("saupj.background.color ='"+String(RGB(190,225,184))+"'")
	END IF	

	dw_1.setfocus()
	
	dw_2.Reset()
	
	sModStatus = 'I'
	Return
ELSE
	select Count(*)		into :iCount
		from kfz10ot0
		where saupj   = :lstr_jpra.saupjang and acc_date = :lstr_jpra.accdate and upmu_gu  = :lstr_jpra.upmugu and
				jun_no  = :lstr_jpra.junno    and lin_no   = :lstr_jpra.sortno  and bal_date = :lstr_jpra.baldate and
				bjun_no = :lstr_jpra.bjunno ;
	if sqlca.sqlcode = 0 and iCount > 0 then
		dw_1.SetItem(1,"sflag",'J')
	else
		dw_1.SetItem(1,"sflag",'M')
	end if
	
	dw_1.Modify("saupj.protect = 1")
//	dw_1.Modify("saupj.background.color ='"+String(RGB(192,192,192))+"'")

	sModStatus = 'M'
END IF

if dw_2.retrieve(dw_1.getitemstring(1,"saupj"), &
					  dw_1.getitemstring(1,"acc_date"), &
					  dw_1.getitemstring(1,"upmu_gu"), &
					  dw_1.getitemnumber(1,"jun_no"), &
					  dw_1.getitemnumber(1,"lin_no"),  &
					  dw_1.getitemstring(1,"bal_date"), &
					  dw_1.getitemNumber(1,"bjun_no"))    > 0 then
	if dw_2.GetItemNumber(1,"bal_count") = 0 OR IsNull(dw_2.GetItemNumber(1,"bal_count")) then
		p_inq.Enabled = True
		p_inq.PictureName = "C:\Erpman\image\표자동계산_up.gif"
		
	else
		p_inq.Enabled = False
		p_inq.PictureName = "C:\Erpman\image\표자동계산_d.gif"
	end if
end if

dw_2.ScrollToRow(1)
dw_2.setcolumn("k_symd")
dw_2.SetFocus()

ib_any_typing = False



end event

event p_search::ue_lbuttondown;PictureName = "C:\Erpman\image\검색_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\Erpman\image\검색_up.gif"
end event

type p_ins from w_inherite`p_ins within w_kgla07
boolean visible = false
integer x = 2514
integer y = 2880
end type

type p_exit from w_inherite`p_exit within w_kgla07
end type

type p_can from w_inherite`p_can within w_kgla07
end type

event p_can::clicked;call super::clicked;dw_1.SetRedraw(False)
dw_1.reset()
dw_1.insertrow(0)
dw_1.SetItem(1, "saupj",    Gs_Saupj)
dw_1.SetItem(1, "acc_date", f_today())
dw_1.SetItem(1, "bal_date", f_today())
dw_1.setfocus()
dw_1.SetRedraw(True)

IF F_Authority_Chk(Gs_Dept) = -1 THEN							/*권한 체크- 현업 여부*/
	dw_1.Modify("saupj.protect = 1")
//	dw_1.Modify("saupj.background.color ='"+String(RGB(192,192,192))+"'")
ELSE
	dw_1.Modify("saupj.protect = 0")
//	dw_1.Modify("saupj.background.color ='"+String(RGB(190,225,184))+"'")
END IF	

dw_2.reset()
ib_any_typing = False
p_inq.Enabled = True
p_inq.PictureName = "C:\Erpman\image\표자동계산_up.gif"

sModStatus = 'I'


end event

type p_print from w_inherite`p_print within w_kgla07
boolean visible = false
integer x = 3026
integer y = 2896
end type

type p_inq from w_inherite`p_inq within w_kgla07
integer x = 3621
integer width = 306
boolean originalsize = true
string picturename = "C:\Erpman\image\표자동계산_up.gif"
end type

event p_inq::clicked;call super::clicked;//long    tot_Days, fr_year, fr_month, fr_day, to_year, to_month, to_day,ll_jun_no, ll_lin_no, ll_monamt,i,iRow,ll_bjunno
//String  s_fr_year, s_fr_month, s_fr_day, s_to_year, s_to_month, s_to_day, ls_frdate, ls_todate, &
//        ls_saupj, ls_acc_date, ls_upmu_gu, ls_acc1_cd, ls_acc2_cd, ls_bal_date
//double  ll_amt, cal_amt

Double    dAmount
String    sFromDate,sToDate,sSaupj,sAccDate,sUpmuGbn,sBalDate,sAcc1,sAcc2
Long      lJunNo,lbJunNo
Integer   iRtn,iRow,i,iLinNo

IF dw_2.RowCount() > 0 then
	if MessageBox('확 인','자료를 삭제 후 다시 계산합니다...계속하시겠습니까?',Question!,YesNo!) = 2 then Return
	
	iRow = dw_2.RowCount()
	for i = iRow TO 1 Step -1
		dw_2.Deleterow(i)
	next
	if dw_2.Update() <> 1 then 
		F_MessageChk(12,'')
		Rollback;
		Return
	end if
	Commit;
	
end if

IF dw_1.accepttext() = -1 THEN Return
IF Wf_RequiredChk() = -1 THEN Return

sSaupj    = dw_1.getitemstring(1,"saupj")    
sAccDate = dw_1.getitemstring(1,"acc_date")  
sUpmuGbn  = dw_1.getitemstring(1,"upmu_gu")  
lJunNo   = dw_1.getitemnumber(1,"jun_no")   
iLinNo   = dw_1.getitemnumber(1,"lin_no")   
sBalDate = dw_1.getitemstring(1,"bal_date")   
lbJunNo   = dw_1.getitemnumber(1,"bjun_no")   

dAmount   = dw_1.getitemnumber(1,"amt")      
sFromDate = dw_1.getitemstring(1,"k_symd")   
sToDate   = dw_1.getitemstring(1,"k_eymd")   
sAcc1  = dw_1.getitemstring(1,"acc1_cd")   
sAcc2  = dw_1.getitemstring(1,"acc2_cd")   

iRtn = Sqlca.AcFn040(sSaupj,sAccDate,sUpmuGbn,lJunNo,iLinNo,sBalDate,lbJunNo,sAcc1,sAcc2,sFromDate,sToDate,dAmount)
IF iRtn <> 1 THEN
	MessageBox('error',String(iRtn))
	Rollback;
ELSE
	Commit;
	
	dw_2.Retrieve(sSaupj,sAccDate,sUpmuGbn,lJunNo,iLinNo,sBalDate,lbJunNo)
END IF
return  


//fr_Year  = long(Left(sFromDate,4))      
//fr_Month = long(Mid(sFromDate,5,2))
//fr_Day   = long(Right(sFromDate,2))
//to_Year  = long(Left(sToDate,4))
//to_Month = long(Mid(sToDate,5,2))
//to_Day   = long(Right(sToDate,2))
//
//s_fr_Year  = Left(sFromDate,4) 
//s_fr_Month = Mid(sFromDate,5,2)
//s_fr_Day   = Right(sFromDate,2)
//s_to_Year  = Left(sToDate,4)
//s_to_Month = Mid(sToDate,5,2)
//s_to_Day   = Right(sToDate,2)
//
////////////////////////////////////////////////////////////////////
//date date1, date2
//
//date1 = Date(s_fr_Year + '-' + s_fr_Month + '-' + s_fr_Day)
//date2 = Date(s_To_Year + '-' + s_To_Month + '-' + s_To_Day) 
//
//tot_Days = long(DaysAfter(date1, date2) + 1)     //총일수
////////////////////////////////////////////////////////////////////
//long   l_yymm, l_yymm2, l_yy, l_yy2, l_mm, l_mm2, l_dd, l_dd2
//integer m, n, k, ay[120],am[120],ad[120]
//Integer iChai,j,il_Cnt
//
//l_yymm  = long(Left(sFromDate,6))
//l_yymm2 = long(Left(sToDate,6))
//l_yy    = long(Left(sFromDate,4))
//l_yy2   = long(Left(sToDate,4))
//l_mm    = long(mid(sFromDate,5,2))
//l_mm2   = long(mid(sToDate,5,2))
//l_dd    = long(right(sFromDate,2))
//l_dd2   = long(right(sToDate,2))
//
//m = 0
////배열에 차월의 값을 순서대로 저장함 m=배열수, n=배열값
//if l_yy = l_yy2 then  //년도가 동일할 경우
//  m = 0
//  for n = l_mm to l_mm2 step 1
//	 m = m + 1
//    ay[m] = l_yy
//    am[m] = n
//	 if integer(right(f_last_date(string(ay[m]) + string(am[m],'00')),2)) = l_dd2 or n <> l_mm2 then
//		 ad[m] = integer(right(f_last_date(string(ay[m]) + string(am[m],'00')),2))
// 	 else
//		 ad[m] = l_dd2
//	 end if	
//  next
//end if
//
//if l_yy <> l_yy2 then  //년도가 다를 경우
//  m = 0
//  for n = l_mm to 12 step 1						/*시작년도*/
//	 m = m + 1
//	 ay[m] = l_yy
//	 am[m] = n
//	 ad[m] = integer(right(f_last_date(string(ay[m]) + string(am[m],'00')),2))
//  next
//  
//  iChai = l_yy2 - l_yy - 1										/*중간년도*/
//  for j = 1 to iChai
//    for il_Cnt = 1 to 12
//		m = m + 1
//	   ay[m] = l_yy + j
//      am[m] = il_cnt
// 	   ad[m] = integer(right(f_last_date(string(ay[m]) + string(am[m],'00')),2))
//	 next
//  next
//  
//  for n = 1 to l_mm2 step 1							/*종료년도*/
//	 m = m + 1
//	 ay[m] = l_yy2
//    am[m] = n
// 	 ad[m] = integer(right(f_last_date(string(ay[m]) + string(am[m],'00')),2))
//  next
//end if
//
////월별로 기간일수를 구하여 기간별 금액계산후 dw에 insert처리함
//k = 0
//cal_amt = 0
//For n = 1 to m
//   dw_2.insertrow(0)
//	k = k + 1
//	if k = 1 then     //최초월일 경우
//      dw_2.setitem(n,"div_amt", round((dAmount * (ad[k] - l_dd + 1)) / tot_days,0))
//		dw_2.setitem(n,"k_symd", sFromDate)
//		dw_2.setitem(n,"k_eymd", string(ay[k]) + string(am[k],'00') + string(ad[k],'00'))
//		cal_amt = cal_amt + round((dAmount * (ad[k] - l_dd + 1)) / tot_days,0)
//   elseif k = m then //최종월일 경우
//      dw_2.setitem(n,"div_amt", dAmount - cal_amt)
//		dw_2.setitem(n,"k_symd", string(ay[k]) + string(am[k],'00') + '01')
//		dw_2.setitem(n,"k_eymd", sToDate)
//	else              //중간월일 경우
//      dw_2.setitem(n,"div_amt", round((dAmount * ad[k]) / tot_days,0))
//		dw_2.setitem(n,"k_symd", string(ay[k]) + string(am[k],'00') + '01')
//		dw_2.setitem(n,"k_eymd", string(ay[k]) + string(am[k],'00') + string(ad[k],'00'))
//		cal_amt = cal_amt + round((dAmount * ad[k]) / tot_days,0)
//	end if
//	
//	dw_2.setitem(n,"acc_yy",   string(ay[k]))	
//	dw_2.setitem(n,"acc_mm",   string(am[k],'00'))
//	dw_2.setitem(n,"saupj",    sSaupj)	
//	dw_2.setitem(n,"acc_date", sAccDate)	
//	dw_2.setitem(n,"upmu_gu",  sUpmuGbn)	
//	dw_2.setitem(n,"jun_no",   lJunNo)	
//	dw_2.setitem(n,"lin_no",   iLinNo)	
//	dw_2.setitem(n,"bal_date", sBalDate)	
//	dw_2.setitem(n,"bjun_no",  lbJunNo)	
//	dw_2.setitem(n,"acc1_cd",  sAcc1)	
//	dw_2.setitem(n,"acc2_cd",  sAcc2)		
//	dw_2.setitem(n,"bal_gu",   'N')		
//next
//
//dw_2.ScrollToRow(1)
//dw_2.setcolumn("k_symd")
//dw_2.SetFocus()
//
end event

event p_inq::ue_lbuttondown;PictureName = "C:\Erpman\image\표자동계산_dn.gif"
end event

event p_inq::ue_lbuttonup;PictureName = "C:\Erpman\image\표자동계산_up.gif"
end event

type p_del from w_inherite`p_del within w_kgla07
end type

event p_del::clicked;call super::clicked;Integer iCount,k,iDw1Flag,iDw2Flag

iCount = dw_2.RowCount()
IF iCount <=0 THEN Return

if messagebox("삭 제","삭제하시겠습니까?", question!, yesno!, 2) = 2 then 	return

dw_1.SetRedraw(False)
dw_2.SetRedraw(False)

dw_1.deleterow(0)
iDw1Flag = dw_1.Update()

FOR k= iCount TO 1 STEP -1
	dw_2.DeleteRow(k)	
NEXT
iDw2Flag = dw_2.Update()

dw_1.SetRedraw(True)
dw_2.SetRedraw(True)
	
IF iDw1Flag = 1 AND iDw2Flag = 1 THEN
	commit using sqlca;
	w_mdi_frame.sle_msg.text = "자료가 삭제되었습니다!!"
	ib_any_typing = false
else 
	rollback;
	Return
end if		

dw_1.SetRedraw(False)
dw_1.Reset()
dw_1.InsertRow(0)
dw_1.SetItem(1, "saupj",    Gs_Saupj)
dw_1.SetItem(1, "acc_date", f_today())
dw_1.SetItem(1, "bal_date", f_today())

dw_1.SetColumn("jun_no")
dw_1.setfocus()
dw_1.SetRedraw(True)

dw_2.Reset()

sModStatus = 'I'



end event

type p_mod from w_inherite`p_mod within w_kgla07
end type

event p_mod::clicked;call super::clicked;int    k
string s_saupj,s_date,into_SAUPJ,into_ACC_DATE,snull, s_frdate, s_todate
long   l_junno,l_linno,into_JUN_NO,into_LIN_NO,inull

setnull(snull)
setnull(inull)

//IF dw_2.RowCount() <=0 THEN Return

IF dw_1.AcceptText() = -1 THEN Return
IF Wf_RequiredChk() = -1 THEN Return

s_saupj  = dw_1.GetItemString(1,"saupj") 
s_date   = dw_1.GetItemString(1,"acc_date")
l_junno  = dw_1.GetItemnumber(1,"jun_no")
l_linno  = dw_1.GetItemnumber(1,"lin_no") 
s_frdate = dw_1.getitemstring(1,"k_symd")
s_todate = dw_1.getitemstring(1,"k_eymd")
  
  
IF MESSAGEBOX("저 장","저장 하시겠습니까?",question!,yesno!,1) = 2 then Return

If dw_1.update() = 1 and dw_2.update() = 1 then
	commit;
	ib_any_typing = false
	w_mdi_frame.sle_msg.text = '자료를 저장하였습니다!!'
else
	rollback;
	ib_any_typing = true
	return
end if

dw_1.SetRedraw(False)
dw_1.Reset()
dw_1.InsertRow(0)
dw_1.SetItem(1, "saupj",    Gs_Saupj)
dw_1.SetItem(1, "acc_date", f_today())
dw_1.SetItem(1, "bal_date", f_today())
dw_1.SetColumn("jun_no")
dw_1.setfocus()

dw_1.SetRedraw(True)
dw_2.Reset()

sModStatus = 'I'



end event

type cb_exit from w_inherite`cb_exit within w_kgla07
boolean visible = false
integer x = 3095
integer y = 2676
integer taborder = 70
end type

type cb_mod from w_inherite`cb_mod within w_kgla07
boolean visible = false
integer x = 2290
integer y = 2676
integer taborder = 40
end type

event cb_mod::clicked;call super::clicked;int    k
string s_saupj,s_date,into_SAUPJ,into_ACC_DATE,snull, s_frdate, s_todate
long   l_junno,l_linno,into_JUN_NO,into_LIN_NO,inull

setnull(snull)
setnull(inull)

IF dw_2.RowCount() <=0 THEN Return

IF dw_1.AcceptText() = -1 THEN Return
IF Wf_RequiredChk() = -1 THEN Return

s_saupj  = dw_1.GetItemString(1,"saupj") 
s_date   = dw_1.GetItemString(1,"acc_date")
l_junno  = dw_1.GetItemnumber(1,"jun_no")
l_linno  = dw_1.GetItemnumber(1,"lin_no") 
s_frdate = dw_1.getitemstring(1,"k_symd")
s_todate = dw_1.getitemstring(1,"k_eymd")
  
IF MESSAGEBOX("저 장","저장 하시겠습니까?",question!,yesno!,1) = 2 then Return

If dw_1.update() = 1 and dw_2.update() = 1 then
	commit;
	ib_any_typing = false
	sle_msg.text = '자료를 저장하였습니다!!'
else
	rollback;
	ib_any_typing = true
	return
end if

dw_1.SetRedraw(False)
dw_1.Reset()
dw_1.InsertRow(0)
dw_1.SetItem(1, "saupj",    Gs_Saupj)
dw_1.SetItem(1, "acc_date", f_today())
dw_1.SetItem(1, "bal_date", f_today())
dw_1.SetColumn("jun_no")
dw_1.setfocus()

dw_1.SetRedraw(True)
dw_2.Reset()



end event

type cb_ins from w_inherite`cb_ins within w_kgla07
boolean visible = false
integer x = 914
integer y = 2904
integer width = 430
string text = "행추가(&I)"
end type

event cb_ins::clicked;call super::clicked;//Integer  iCurRow,iFunctionValue
//
//sle_msg.text =""
//
//IF dw_1.AcceptText() = -1 THEN RETURN
//IF Wf_RequiredChk() = -1 THEN Return
//
//IF dw_2.RowCount() > 0 THEN
//	iFunctionValue = Wf_RequiredChk()
//	IF iFunctionValue <> 1 THEN RETURN
//ELSE
//	iFunctionValue = 1	
//END IF
//
//IF iFunctionValue = 1 THEN
//	iCurRow = dw_2.InsertRow(0)
//
//	dw_2.ScrollToRow(iCurRow)
////	dw_2.SetItem(iCurRow,'person_gu',sPersonGbn)
//	dw_2.SetItem(iCurRow,'sflag','I')
//	dw_2.SetColumn("person_cd")
//	dw_2.SetFocus()
//	
//	ib_any_typing =False
//
//END IF
//
end event

type cb_del from w_inherite`cb_del within w_kgla07
boolean visible = false
integer x = 2638
integer y = 2676
integer taborder = 50
end type

event cb_del::clicked;call super::clicked;Integer iCount,k,iDw1Flag,iDw2Flag

iCount = dw_2.RowCount()
IF iCount <=0 THEN Return

if messagebox("삭 제","삭제하시겠습니까?", question!, yesno!, 2) = 2 then 	return

dw_1.SetRedraw(False)
dw_2.SetRedraw(False)

dw_1.deleterow(0)
iDw1Flag = dw_1.Update()

FOR k= iCount TO 1 STEP -1
	dw_2.DeleteRow(k)	
NEXT
iDw2Flag = dw_2.Update()

dw_1.SetRedraw(True)
dw_2.SetRedraw(True)
	
IF iDw1Flag = 1 AND iDw2Flag = 1 THEN
	commit using sqlca;
	sle_msg.text = "자료가 삭제되었습니다!!"
	ib_any_typing = false
else 
	rollback;
	Return
end if		

dw_1.SetRedraw(False)
dw_1.Reset()
dw_1.InsertRow(0)
dw_1.SetItem(1, "saupj",    Gs_Saupj)
dw_1.SetItem(1, "acc_date", f_today())
dw_1.SetItem(1, "bal_date", f_today())

dw_1.SetColumn("jun_no")
dw_1.setfocus()
dw_1.SetRedraw(True)

dw_2.Reset()



end event

type cb_inq from w_inherite`cb_inq within w_kgla07
boolean visible = false
integer x = 1358
integer y = 2904
integer width = 430
string text = "행삭제(&E)"
end type

event cb_inq::clicked;call super::clicked;//sle_msg.text = ''
//
//IF dw_2.GetRow() <=0 THEN
//	messagebox("확 인","삭제할 행이 없습니다. ~n~n삭제할 행을 선택하고 [삭제]하세요!!")
//	Return
//END IF
//
//IF Messagebox("삭 제 ","삭제하시겠습니까?", question!, yesno!) = 2 then Return
//
//dw_2.DeleteRow(dw_2.getrow())
//
//IF dw_2.Update() = 1  THEN
//	COMMIT USING SQLCA;
//  	sle_msg.text = '삭제되었습니다!!'
//ELSE
//	ROLLBACK USING SQLCA;
//END IF 
//
//dw_2.ScrollToRow(dw_2.RowCount())
//dw_2.setcolumn("k_symd")
//dw_2.SetFocus()
end event

type cb_print from w_inherite`cb_print within w_kgla07
integer x = 581
integer y = 2904
end type

type st_1 from w_inherite`st_1 within w_kgla07
boolean visible = false
integer y = 2880
end type

type cb_can from w_inherite`cb_can within w_kgla07
boolean visible = false
integer x = 2985
integer y = 2676
integer taborder = 60
end type

event cb_can::clicked;call super::clicked;dw_1.SetRedraw(False)
dw_1.reset()
dw_1.insertrow(0)
dw_1.SetItem(1, "saupj",    Gs_Saupj)
dw_1.SetItem(1, "acc_date", f_today())
dw_1.SetItem(1, "bal_date", f_today())
dw_1.setfocus()
dw_1.SetRedraw(True)

IF F_Authority_Chk(Gs_Dept) = -1 THEN							/*권한 체크- 현업 여부*/
	dw_1.Modify("saupj.protect = 1")
	dw_1.Modify("saupj.background.color ='"+String(RGB(192,192,192))+"'")
ELSE
	dw_1.Modify("saupj.protect = 0")
	dw_1.Modify("saupj.background.color ='"+String(RGB(190,225,184))+"'")
END IF	

dw_2.reset()
ib_any_typing = False
cb_1.Enabled = True


end event

type cb_search from w_inherite`cb_search within w_kgla07
boolean visible = false
integer x = 535
integer y = 2684
integer width = 434
end type

event cb_search::clicked;call super::clicked;Integer  iCount

dw_1.SetRedraw(True)
dw_2.SetRedraw(True)

if dw_1.AcceptText() = -1 then return 
if dw_1.getrow() <= 0 then return

setnull(lstr_jpra.saupjang);		setnull(lstr_jpra.baldate);		setnull(lstr_jpra.bjunno);
setnull(lstr_jpra.sortno);			setnull(lstr_jpra.upmugu);			setnull(lstr_jpra.accdate);		setnull(lstr_jpra.junno);

OpenWithParm(w_kgla071, Trim(dw_1.GetItemString(1,"acc_date")))

if isnull(lstr_jpra.baldate) or trim(lstr_jpra.baldate) = '' then return 

IF dw_1.retrieve(lstr_jpra.saupjang,lstr_jpra.accdate,lstr_jpra.upmugu,lstr_jpra.junno,lstr_jpra.sortno,lstr_jpra.baldate,lstr_jpra.bjunno) <=0 then

	dw_1.InsertRow(0)
	
	dw_1.SetItem(1, "saupj",    Gs_Saupj)
	dw_1.SetItem(1, "acc_date", f_today())
	dw_1.SetItem(1, "bal_date", f_today())
	
	IF F_Authority_Chk(Gs_Dept) = -1 THEN							/*권한 체크- 현업 여부*/
		dw_1.Modify("saupj.protect = 1")
		dw_1.Modify("saupj.background.color ='"+String(RGB(192,192,192))+"'")
	ELSE
		dw_1.Modify("saupj.protect = 0")
		dw_1.Modify("saupj.background.color ='"+String(RGB(190,225,184))+"'")
	END IF	

	dw_1.setfocus()
	
	dw_2.Reset()
	Return
ELSE
	select Count(*)		into :iCount
		from kfz10ot0
		where saupj   = :lstr_jpra.saupjang and acc_date = :lstr_jpra.accdate and upmu_gu  = :lstr_jpra.upmugu and
				jun_no  = :lstr_jpra.junno    and lin_no   = :lstr_jpra.sortno  and bal_date = :lstr_jpra.baldate and
				bjun_no = :lstr_jpra.bjunno ;
	if sqlca.sqlcode = 0 and iCount > 0 then
		dw_1.SetItem(1,"sflag",'J')
	else
		dw_1.SetItem(1,"sflag",'M')
	end if
	
	dw_1.Modify("saupj.protect = 1")
	dw_1.Modify("saupj.background.color ='"+String(RGB(192,192,192))+"'")
END IF

if dw_2.retrieve(dw_1.getitemstring(1,"saupj"), &
					  dw_1.getitemstring(1,"acc_date"), &
					  dw_1.getitemstring(1,"upmu_gu"), &
					  dw_1.getitemnumber(1,"jun_no"), &
					  dw_1.getitemnumber(1,"lin_no"),  &
					  dw_1.getitemstring(1,"bal_date"), &
					  dw_1.getitemNumber(1,"bjun_no"))    > 0 then
	if dw_2.GetItemNumber(1,"bal_count") = 0 OR IsNull(dw_2.GetItemNumber(1,"bal_count")) then
		cb_1.Enabled = True
	else
		cb_1.Enabled = False
	end if
end if

dw_2.ScrollToRow(1)
dw_2.setcolumn("k_symd")
dw_2.SetFocus()

ib_any_typing = False



end event

type dw_datetime from w_inherite`dw_datetime within w_kgla07
boolean visible = false
integer y = 2876
end type

type sle_msg from w_inherite`sle_msg within w_kgla07
boolean visible = false
integer y = 2880
end type

type gb_10 from w_inherite`gb_10 within w_kgla07
boolean visible = false
integer y = 2828
end type

type gb_button1 from w_inherite`gb_button1 within w_kgla07
boolean visible = false
integer x = 503
integer y = 2628
integer width = 507
end type

type gb_button2 from w_inherite`gb_button2 within w_kgla07
boolean visible = false
integer x = 1673
integer y = 2620
integer width = 2030
end type

type dw_1 from datawindow within w_kgla07
event ue_key pbm_dwnkey
event ue_enterkey pbm_dwnprocessenter
integer x = 37
integer y = 248
integer width = 1723
integer height = 1572
integer taborder = 10
string dataobject = "dw_kgla07_01"
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) or keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_enterkey;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;String   snull, sSaupj, sAcc1_Cd, sAcc2_Cd, sDate,sAccName,sGbn1, sRaccode,sRacname,sSaupNo,sSaupName

SetNull(snull)

IF this.GetColumnName() = "saupj" THEN
	sSaupj = this.GetText()
	IF sSaupj = "" OR IsNull(sSaupj) THEN RETURN
	
	IF IsNull(F_Get_Refferance('AD',sSaupj)) THEN
		F_MessageChk(20,'[사업장]')
		this.SetItem(1,"saupj",sNull)
		Return 1
	END IF
END IF

IF	this.getcolumnname() = "acc_date" THEN
	sDate = Trim(this.GetText())
	IF sDate = '' OR IsNull(sDate) THEN Return
	
	IF f_datechk(sDate) = -1 then
		F_MessageChk(21,'[회계일자]')
		this.setitem(1, "acc_date", sNull)
		this.setfocus()
		return 1
	ELSE
		IF this.GetItemString(1,"bal_date") = '' OR IsNull(this.GetItemString(1,"bal_date")) THEN
			this.SetItem(1,"bal_date",  sDate)		
		END IF
	END IF
end if

IF this.GetColumnName() = "jun_no" THEN
	IF this.GetText() = '' OR IsNull(this.GetText()) THEN Return
	
	IF this.GetItemNumber(1,"bjun_no") = 0 OR IsNull(this.GetItemNumber(1,"bjun_no")) THEN
		this.SetItem(1,"bjun_no",  Long(this.GetText()))		
	END IF
END IF
IF this.GetColumnName() = "acc1_cd" THEN
	sAcc1_Cd = this.GetText()
	IF sAcc1_Cd = "" OR IsNull(sAcc1_Cd) THEN	
	   this.setitem(1,"acc2_cd",snull)
		this.setitem(1,"kfz01om0_acc2_nm",snull)
		this.setitem(1,"kfz01om0_gbn1",   snull)
		Return 
	END IF
	
 	sAcc2_Cd = this.getitemstring(1,"acc2_cd") 
	IF sAcc2_Cd = "" OR IsNull(sAcc2_Cd) THEN	
		Return 
	END IF
	
   SELECT "ACC2_NM",			NVL("GBN1",'%')	    INTO :sAccName,	:sGbn1
	   FROM "KFZ01OM0"  
   	WHERE "ACC1_CD" = :sAcc1_Cd AND "ACC2_CD" = :sAcc2_Cd ;
	if sqlca.sqlcode = 0 then
		this.setitem(1,"kfz01om0_acc2_nm",sAccName)
		this.setitem(1,"kfz01om0_gbn1",   sGbn1)
	else
//     F_MessageChk(28,'[계정과목]')
	  this.setitem(1,"acc1_cd",snull)
	  this.setitem(1,"acc2_cd",snull)	
	  this.setitem(1,"kfz01om0_acc2_nm",snull)
	  this.setitem(1,"kfz01om0_gbn1",snull)
	  return 
   end if
end if	

IF this.GetColumnName() = "acc2_cd" THEN
	sAcc2_Cd = this.GetText()
	IF sAcc2_Cd = "" OR IsNull(sAcc2_Cd) THEN	
		this.setitem(1,"acc1_cd",snull)
		this.setitem(1,"kfz01om0_acc2_nm",snull)
		this.setitem(1,"kfz01om0_gbn1",   snull)
		Return 
	END IF
	
  	sAcc1_Cd = this.getitemstring(1,"acc1_cd")
	IF sAcc1_Cd = "" OR IsNull(sAcc1_Cd) THEN
		Return 
	END IF
	
	SELECT "ACC2_NM",			"GBN1"	    INTO :sAccName,	:sGbn1
	   FROM "KFZ01OM0"  
   	WHERE "ACC1_CD" = :sAcc1_Cd AND "ACC2_CD" = :sAcc2_Cd ;
	if sqlca.sqlcode = 0 then
		this.setitem(1,"kfz01om0_acc2_nm",sAccName)
		this.setitem(1,"kfz01om0_gbn1",   sGbn1)
	else
//     F_MessageChk(28,'[계정과목]')
	  this.setitem(1,"acc1_cd",snull)
	  this.setitem(1,"acc2_cd",snull)	
	  this.setitem(1,"kfz01om0_acc2_nm",snull)
	  this.setitem(1,"kfz01om0_gbn1",   snull)
	  return 
   end if
end if	

IF this.GetColumnName() = "saup_no" THEN
	sSaupNo = this.GetText()
	IF sSaupNo = '' OR IsNull(sSaupNo) THEN
		this.SetItem(1,"saupname",sNull)
		Return
	END IF
	
	sSaupName = F_Get_PersonLst(this.GetItemString(1,"kfz01om0_gbn1"),sSaupNo,'%')
	IF IsNull(sSaupName) OR sSaupName = '' THEN
		this.setitem(1,"saup_no",   snull)
	  	this.setitem(1,"saupname",  snull)
		Return 
	END IF
	this.setitem(1,"saupname",  sSaupName)	
END IF

IF	this.getcolumnname() = "k_symd" THEN
	sDate = Trim(this.gettext())
	IF sDate = '' OR IsNull(sDate) THEN Return
	
	IF f_datechk(sDate) = -1 then
		F_MessageChk(21,'[기산일자]')
		this.setitem(1, "k_symd", sNull)
		this.setfocus()
		return 1
	END IF
end if

IF	this.getcolumnname() = "k_eymd" THEN
	sDate = Trim(this.gettext())
	IF sDate = '' OR IsNull(sDate) THEN Return

	IF f_datechk(sDate) = -1 then
		F_MessageChk(21,'[만기일자]')
		this.setitem(1, "k_eymd", sNull)
		this.setfocus()
		return 1
	END IF
end if

IF this.GetColumnName() = "racc_cd" THEN
	sRacCode = this.GetText()
	IF sRacCode = "" OR IsNull(sRacCode) THEN
		this.SetItem(1,"raccname",snull)
		Return
	END IF
	sRacName = F_Get_PersonLst('80',sRacCode,'1')
	IF IsNull(sRacName) THEN
//		F_MessageChk(27,'[대체계정]')
		this.SetItem(1,"racc_cd",snull)
		this.SetItem(1,"raccname",snull)
		Return 
	END IF
	this.SetItem(1,"raccname",sRacName)
END IF

ib_any_typing = True
end event

event itemerror;return 1
end event

event rbuttondown;this.accepttext()

IF this.GetColumnName() = "acc1_cd" THEN
	
	SetNull(lstr_account.acc1_cd)
	SetNull(lstr_account.acc2_cd)
	SetNull(lstr_account.gbn1)

	lstr_account.acc1_cd = this.GetItemString(this.GetRow(),"acc1_cd")
	lstr_account.acc2_cd = this.GetItemString(this.GetRow(),"acc2_cd")
	
	IF IsNull(lstr_account.acc1_cd) THEN lstr_account.acc1_cd = ''
	IF IsNull(lstr_account.acc2_cd) THEN lstr_account.acc2_cd = ''
	
	Open(W_Kfz01om0_PopUp)
	
	IF IsNull(lstr_account.acc1_cd) THEN Return
	
	this.SetItem(this.GetRow(),"acc1_cd",lstr_account.acc1_cd)
	this.SetItem(this.GetRow(),"acc2_cd",lstr_account.acc2_cd)
	this.SetItem(this.GetRow(),"kfz01om0_acc2_nm",lstr_account.acc2_nm)
//	this.TriggerEvent(ItemChanged!)
//	return
ELSEIF this.GetColumnName() ="saup_no" THEN
	SetNull(lstr_custom.code)			
	SetNull(lstr_custom.name)
	
	lstr_custom.code = this.getitemstring(this.getrow(), "saup_no")
	
	if lstr_account.gbn1 = "" or isnull(lstr_account.gbn1) then lstr_account.gbn1 = '%'

	OpenWithParm(W_KFZ04OM0_POPUP,lstr_account.gbn1)
	
	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
	
	this.SetItem(this.GetRow(),"saup_no",   lstr_custom.code)
	this.SetItem(this.GetRow(),"saupname",  lstr_custom.name)
ELSEIF this.GetColumnName() ="racc_cd" THEN
	SetNull(lstr_custom.code)
	SetNull(lstr_custom.name)

	lstr_custom.code = this.GetItemString(this.GetRow(),"racc_cd")
	
	IF IsNull(lstr_custom.code) THEN
		lstr_custom.code = ""
	END IF

	OpenWithParm(W_KFZ04OM0_POPUP,'80')
	
	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
	
	this.SetItem(this.GetRow(),"racc_cd",lstr_custom.code)
	this.SetItem(this.GetRow(),"raccname", lstr_custom.name)
END IF

ib_any_typing = True
end event

event retrieverow;IF row > 0 THEN
	this.SetItem(row,'sflag','M')
END IF
end event

event editchanged;ib_any_typing = True
end event

type cb_1 from commandbutton within w_kgla07
boolean visible = false
integer x = 1710
integer y = 2676
integer width = 567
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "표자동계산(&A)"
end type

event clicked;//long    tot_Days, fr_year, fr_month, fr_day, to_year, to_month, to_day,ll_jun_no, ll_lin_no, ll_monamt,i,iRow,ll_bjunno
//String  s_fr_year, s_fr_month, s_fr_day, s_to_year, s_to_month, s_to_day, ls_frdate, ls_todate, &
//        ls_saupj, ls_acc_date, ls_upmu_gu, ls_acc1_cd, ls_acc2_cd, ls_bal_date
//double  ll_amt, cal_amt

Double    dAmount
String    sFromDate,sToDate,sSaupj,sAccDate,sUpmuGbn,sBalDate,sAcc1,sAcc2
Long      lJunNo,lbJunNo
Integer   iRtn,iRow,i,iLinNo

IF dw_2.RowCount() > 0 then
	if MessageBox('확 인','자료를 삭제 후 다시 계산합니다...계속하시겠습니까?',Question!,YesNo!) = 2 then Return
	
	iRow = dw_2.RowCount()
	for i = iRow TO 1 Step -1
		dw_2.Deleterow(i)
	next
end if

IF dw_1.accepttext() = -1 THEN Return
IF Wf_RequiredChk() = -1 THEN Return

sSaupj    = dw_1.getitemstring(1,"saupj")    
sAccDate = dw_1.getitemstring(1,"acc_date")  
sUpmuGbn  = dw_1.getitemstring(1,"upmu_gu")  
lJunNo   = dw_1.getitemnumber(1,"jun_no")   
iLinNo   = dw_1.getitemnumber(1,"lin_no")   
sBalDate = dw_1.getitemstring(1,"bal_date")   
lbJunNo   = dw_1.getitemnumber(1,"bjun_no")   

dAmount   = dw_1.getitemnumber(1,"amt")      
sFromDate = dw_1.getitemstring(1,"k_symd")   
sToDate   = dw_1.getitemstring(1,"k_eymd")   
sAcc1  = dw_1.getitemstring(1,"acc1_cd")   
sAcc2  = dw_1.getitemstring(1,"acc2_cd")   

iRtn = Sqlca.AcFn040(sSaupj,sAccDate,sUpmuGbn,lJunNo,iLinNo,sBalDate,lbJunNo,sAcc1,sAcc2,sFromDate,sToDate,dAmount)
IF iRtn <> 1 THEN
	MessageBox('error',String(iRtn))
	Rollback;
ELSE
	Commit;
	
	dw_2.Retrieve(sSaupj,sAccDate,sUpmuGbn,lJunNo,iLinNo,sBalDate,lbJunNo)
END IF
return  


//fr_Year  = long(Left(sFromDate,4))      
//fr_Month = long(Mid(sFromDate,5,2))
//fr_Day   = long(Right(sFromDate,2))
//to_Year  = long(Left(sToDate,4))
//to_Month = long(Mid(sToDate,5,2))
//to_Day   = long(Right(sToDate,2))
//
//s_fr_Year  = Left(sFromDate,4) 
//s_fr_Month = Mid(sFromDate,5,2)
//s_fr_Day   = Right(sFromDate,2)
//s_to_Year  = Left(sToDate,4)
//s_to_Month = Mid(sToDate,5,2)
//s_to_Day   = Right(sToDate,2)
//
////////////////////////////////////////////////////////////////////
//date date1, date2
//
//date1 = Date(s_fr_Year + '-' + s_fr_Month + '-' + s_fr_Day)
//date2 = Date(s_To_Year + '-' + s_To_Month + '-' + s_To_Day) 
//
//tot_Days = long(DaysAfter(date1, date2) + 1)     //총일수
////////////////////////////////////////////////////////////////////
//long   l_yymm, l_yymm2, l_yy, l_yy2, l_mm, l_mm2, l_dd, l_dd2
//integer m, n, k, ay[120],am[120],ad[120]
//Integer iChai,j,il_Cnt
//
//l_yymm  = long(Left(sFromDate,6))
//l_yymm2 = long(Left(sToDate,6))
//l_yy    = long(Left(sFromDate,4))
//l_yy2   = long(Left(sToDate,4))
//l_mm    = long(mid(sFromDate,5,2))
//l_mm2   = long(mid(sToDate,5,2))
//l_dd    = long(right(sFromDate,2))
//l_dd2   = long(right(sToDate,2))
//
//m = 0
////배열에 차월의 값을 순서대로 저장함 m=배열수, n=배열값
//if l_yy = l_yy2 then  //년도가 동일할 경우
//  m = 0
//  for n = l_mm to l_mm2 step 1
//	 m = m + 1
//    ay[m] = l_yy
//    am[m] = n
//	 if integer(right(f_last_date(string(ay[m]) + string(am[m],'00')),2)) = l_dd2 or n <> l_mm2 then
//		 ad[m] = integer(right(f_last_date(string(ay[m]) + string(am[m],'00')),2))
// 	 else
//		 ad[m] = l_dd2
//	 end if	
//  next
//end if
//
//if l_yy <> l_yy2 then  //년도가 다를 경우
//  m = 0
//  for n = l_mm to 12 step 1						/*시작년도*/
//	 m = m + 1
//	 ay[m] = l_yy
//	 am[m] = n
//	 ad[m] = integer(right(f_last_date(string(ay[m]) + string(am[m],'00')),2))
//  next
//  
//  iChai = l_yy2 - l_yy - 1										/*중간년도*/
//  for j = 1 to iChai
//    for il_Cnt = 1 to 12
//		m = m + 1
//	   ay[m] = l_yy + j
//      am[m] = il_cnt
// 	   ad[m] = integer(right(f_last_date(string(ay[m]) + string(am[m],'00')),2))
//	 next
//  next
//  
//  for n = 1 to l_mm2 step 1							/*종료년도*/
//	 m = m + 1
//	 ay[m] = l_yy2
//    am[m] = n
// 	 ad[m] = integer(right(f_last_date(string(ay[m]) + string(am[m],'00')),2))
//  next
//end if
//
////월별로 기간일수를 구하여 기간별 금액계산후 dw에 insert처리함
//k = 0
//cal_amt = 0
//For n = 1 to m
//   dw_2.insertrow(0)
//	k = k + 1
//	if k = 1 then     //최초월일 경우
//      dw_2.setitem(n,"div_amt", round((dAmount * (ad[k] - l_dd + 1)) / tot_days,0))
//		dw_2.setitem(n,"k_symd", sFromDate)
//		dw_2.setitem(n,"k_eymd", string(ay[k]) + string(am[k],'00') + string(ad[k],'00'))
//		cal_amt = cal_amt + round((dAmount * (ad[k] - l_dd + 1)) / tot_days,0)
//   elseif k = m then //최종월일 경우
//      dw_2.setitem(n,"div_amt", dAmount - cal_amt)
//		dw_2.setitem(n,"k_symd", string(ay[k]) + string(am[k],'00') + '01')
//		dw_2.setitem(n,"k_eymd", sToDate)
//	else              //중간월일 경우
//      dw_2.setitem(n,"div_amt", round((dAmount * ad[k]) / tot_days,0))
//		dw_2.setitem(n,"k_symd", string(ay[k]) + string(am[k],'00') + '01')
//		dw_2.setitem(n,"k_eymd", string(ay[k]) + string(am[k],'00') + string(ad[k],'00'))
//		cal_amt = cal_amt + round((dAmount * ad[k]) / tot_days,0)
//	end if
//	
//	dw_2.setitem(n,"acc_yy",   string(ay[k]))	
//	dw_2.setitem(n,"acc_mm",   string(am[k],'00'))
//	dw_2.setitem(n,"saupj",    sSaupj)	
//	dw_2.setitem(n,"acc_date", sAccDate)	
//	dw_2.setitem(n,"upmu_gu",  sUpmuGbn)	
//	dw_2.setitem(n,"jun_no",   lJunNo)	
//	dw_2.setitem(n,"lin_no",   iLinNo)	
//	dw_2.setitem(n,"bal_date", sBalDate)	
//	dw_2.setitem(n,"bjun_no",  lbJunNo)	
//	dw_2.setitem(n,"acc1_cd",  sAcc1)	
//	dw_2.setitem(n,"acc2_cd",  sAcc2)		
//	dw_2.setitem(n,"bal_gu",   'N')		
//next
//
//dw_2.ScrollToRow(1)
//dw_2.setcolumn("k_symd")
//dw_2.SetFocus()
//
end event

type cb_2 from commandbutton within w_kgla07
boolean visible = false
integer x = 2578
integer y = 44
integer width = 297
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "oracle"
end type

event clicked;long   tot_Days, fr_year, fr_month, fr_day, to_year, to_month, to_day,ll_jun_no, ll_lin_no, ll_monamt,ll_bjunno
String s_fr_year, s_fr_month, s_fr_day, s_to_year, s_to_month, s_to_day, ls_frdate, ls_todate, &
       ls_saupj, ls_acc_date, ls_upmu_gu, ls_acc1_cd, ls_acc2_cd, ls_cdept_cd,ls_bal_date
double ll_amt, cal_amt
Integer iRtn,iRow,i

IF dw_2.RowCount() > 0 then
	if MessageBox('확 인','자료를 삭제 후 다시 계산합니다...계속하시겠습니까?',Question!,YesNo!) = 2 then Return
	
	iRow = dw_2.RowCount()
	for i = iRow TO 1 Step -1
		dw_2.Deleterow(i)
	next
	dw_2.Update()
	commit;
end if

dw_1.accepttext()

ll_amt      = dw_1.getitemnumber(1,"amt")      //전표금액
ls_frdate   = dw_1.getitemstring(1,"k_symd")   //기산일
ls_todate   = dw_1.getitemstring(1,"k_eymd")   //마감일
ls_saupj    = dw_1.getitemstring(1,"saupj")    //사업장
ls_acc_date = dw_1.getitemstring(1,"acc_date")   //회계일
ls_upmu_gu  = dw_1.getitemstring(1,"upmu_gu")   //업무구분
ll_jun_no   = dw_1.getitemnumber(1,"jun_no")   //전표번호
ll_lin_no   = dw_1.getitemnumber(1,"lin_no")   //라인번호
ls_bal_date = dw_1.getitemstring(1,"bal_date")   //작성일
ll_bjunno   = dw_1.getitemnumber(1,"bjun_no")   //전표작성번호
ls_acc1_cd  = dw_1.getitemstring(1,"acc1_cd")   //계정코드1
ls_acc2_cd  = dw_1.getitemstring(1,"acc2_cd")   //계정코드2
ls_cdept_cd  = dw_1.getitemstring(1,"cdept_cd")   //계정코드2

//iRtn = Sqlca.AcFn040(ls_saupj,ls_acc_date,ls_upmu_gu,ll_jun_no,ll_lin_no,ls_bal_date,ll_bjunno,ls_acc1_cd,&
//							ls_acc2_cd,ls_frdate,ls_todate,ll_amt)
IF iRtn <> 1 THEN
	MessageBox('error',String(iRtn))
	Rollback;
ELSE
	Commit;
	
	dw_2.Retrieve(ls_saupj,ls_acc_date,ls_upmu_gu,ll_jun_no,ll_lin_no)
END IF

return  


end event

type dw_2 from datawindow within w_kgla07
integer x = 1838
integer y = 280
integer width = 2729
integer height = 2032
integer taborder = 20
string dataobject = "dw_kgla07_02"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event editchanged;ib_any_typing = True
end event

type st_2 from statictext within w_kgla07
integer x = 1902
integer y = 232
integer width = 457
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "월할 분할 내역"
alignment alignment = center!
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_kgla07
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1824
integer y = 256
integer width = 2770
integer height = 2060
integer cornerheight = 40
integer cornerwidth = 46
end type

