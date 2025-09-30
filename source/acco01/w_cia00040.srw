$PBExportHeader$w_cia00040.srw
$PBExportComments$원가배부율 등록(공통->보조->부문->직접)
forward
global type w_cia00040 from w_inherite
end type
type dw_2 from datawindow within w_cia00040
end type
type dw_3 from datawindow within w_cia00040
end type
type dw_ym from u_key_enter within w_cia00040
end type
type dw_1 from u_d_popup_sort within w_cia00040
end type
type rr_1 from roundrectangle within w_cia00040
end type
type rr_2 from roundrectangle within w_cia00040
end type
end forward

global type w_cia00040 from w_inherite
integer height = 2436
string title = "원가배부율 등록"
dw_2 dw_2
dw_3 dw_3
dw_ym dw_ym
dw_1 dw_1
rr_1 rr_1
rr_2 rr_2
end type
global w_cia00040 w_cia00040

type variables
String  lucost_cd,lcost_gu3,lcost_gu4,lcost_gu5, LsIoYeraMonth,LsIoYeraMonthT
String  LsCostSaupj,LsCostGbn,LsBabuMode
end variables

forward prototypes
public function integer wf_reqchk ()
public function integer wf_warndataloss (string as_titletext)
public subroutine wf_comper ()
end prototypes

public function integer wf_reqchk ();String sCust_Cd,sBaBu

dw_2.AcceptText()

sCust_Cd  = dw_2.GetItemString(1,"cia02m_cost_cd")  /*상위부문*/
sBaBu     = dw_2.GetItemString(1,"cia04t_babu")     /*배부기준부문*/
				
IF sCust_Cd = '' OR ISNULL(sCust_Cd) THEN
	f_messagechk(1,'[상위부문]')
	dw_2.SetColumn("cia02m_cost_cd")
	dw_2.SetFocus()
	Return -1
END IF	
IF sBaBu = '' OR ISNULL(sBaBu) THEN
	f_messagechk(1,'[배부기준]')
	dw_2.SetColumn("cia04t_babu")
	dw_2.SetFocus()
	Return -1
END IF	


Return 1
end function

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

		dw_2.SetFocus()						// yes 일 경우: focus 'dw_detail' 
		RETURN -1									

	END IF

END IF
																
RETURN 1												// (dw_detail) 에 변경사항이 없거나 no일 경우
														// 변경사항을 저장하지 않고 계속진행 

end function

public subroutine wf_comper ();Double dCur_BabuNum,dSum_BabuNum,dPer,dSum_Per
Long K,ll_Row

dw_3.AcceptText()
ll_Row = dw_3.RowCount()

IF ll_row <=0 THEN Return
dSum_BabuNum = dw_3.GetItemNumber(1,"sum_babu")
IF IsNull(dSum_BabuNum) THEN dSum_BabuNum = 0

FOR K = 1  TO ll_Row
   dCur_BabuNum = dw_3.GetItemNumber(K,"babu_num") /* 현재Row의 배부기준값*/
   if isnull(dCur_BabuNum) then
	   dCur_BabuNum = 0
	end if	  
	if dSum_BabuNum = 0 then
		dPer = 0
	else
		dPer  = Round((dCur_BabuNum / dSum_BabuNum) * 100,6)
	end if
	dw_3.SetITem(k,"babu_rate",dPer) 
	
	if k = ll_row then
		dSum_Per = dw_3.GetItemNumber(dw_3.RowCount(),"sum_per")
		
		if dSum_BabuNum = 0 then
			dw_3.SetITem(k,"babu_rate",dPer) 	
		else
			dw_3.SetITem(k,"babu_rate",dPer + (100 - dSum_Per)) 
		end if
	end if
NEXT  
end subroutine

on w_cia00040.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.dw_3=create dw_3
this.dw_ym=create dw_ym
this.dw_1=create dw_1
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.dw_3
this.Control[iCurrent+3]=this.dw_ym
this.Control[iCurrent+4]=this.dw_1
this.Control[iCurrent+5]=this.rr_1
this.Control[iCurrent+6]=this.rr_2
end on

on w_cia00040.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_2)
destroy(this.dw_3)
destroy(this.dw_ym)
destroy(this.dw_1)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;Long rtncode

dw_ym.SetTransObject(sqlca)
dw_1.SetTransObject(sqlca)
dw_2.SetTransObject(sqlca)
dw_3.SetTransObject(sqlca)

dw_1.Reset()
dw_2.Reset()
dw_3.Reset()

select nvl(dataname,'1') into :LsBabuMode from syscnfg where sysgu = 'A' and serial = 84 and lineno = '1';

LsIoYeraMonth = Left(F_Today(),6)

dw_ym.Reset()
dw_ym.InsertRow(0)
dw_ym.SetItem(1,"io_yymm",   LsIoYeraMonth)
dw_ym.SetItem(1,"io_yymmt",   LsIoYeraMonth)

LsCostSaupj = Gs_Saupj
LsCostGbn   = 'C'

dw_ym.SetItem(1,"cost_saup", LsCostSaupj)

DataWindowChild state_child

rtncode = dw_2.GetChild('cia04t_babu', state_child)
state_child.SetTransObject(SQLCA)
state_child.Retrieve("C2")

rtncode = dw_2.GetChild('cia02m_cost_cd', state_child)
state_child.SetTransObject(SQLCA)
IF state_child.Retrieve(LsCostSaupj,LsCostGbn) <=0 THEN
	state_child.InsertRow(0)
END IF

dw_2.InsertRow(0)

dw_ym.SetFocus()

end event

type dw_insert from w_inherite`dw_insert within w_cia00040
boolean visible = false
integer x = 69
integer y = 2568
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_cia00040
integer x = 3922
integer taborder = 50
end type

event p_delrow::clicked;call super::clicked;Long   ToTal_Row

IF F_DbConFirm('삭제') = 2 THEN RETURN

dw_3.DeleteRow(dw_3.GetRow())

wf_comper()  /* 배부기준값에 따른 배부율 다시 계산*/

IF dw_3.Update() = 1 THEN
	commit;
	ib_any_typing = False
	w_mdi_frame.sle_msg.text ="자료가 삭제되었습니다.!!!"

   ToTal_Row = dw_3.RowCount()
	IF ToTal_Row  = 0 THEN
		
		dw_1.Retrieve(LsIoYeraMonth,LsIoYeraMonthT,LsCostSaupj,LsCostGbn)
		
		dw_2.SetRedraw(False)
		dw_2.Reset()
		dw_2.InsertRow(0)
		dw_2.SetRedraw(True)
	END IF	
ELSE
	ROLLBACK;
	f_messagechk(12,'')
END IF

end event

type p_addrow from w_inherite`p_addrow within w_cia00040
integer x = 3749
end type

event p_addrow::clicked;call super::clicked;Integer  iCurRow,iFunctionValue,iRowCount

w_mdi_frame.sle_msg.text =""

iRowCount = dw_3.RowCount()

IF iRowCount > 0 THEN
	iFunctionValue = Wf_ReqChk()
	IF iFunctionValue <> 1 THEN RETURN
ELSE
	iFunctionValue = 1	
	
	iRowCount = 0
END IF

IF iFunctionValue = 1 THEN
	iCurRow = iRowCount + 1
	
	dw_3.InsertRow(iCurRow)

	dw_3.SetItem(iCurRow,"flag",'1')
	
	dw_3.SetItem(iCurRow,"io_yymm",  LsIoYeraMonth)
	dw_3.SetItem(iCurRow,"io_yymmt",  LsIoYeraMontht)
	dw_3.SetItem(iCurRow,"ucost_cd", dw_2.GetItemString(1,"cia02m_cost_cd"))
	dw_3.SetItem(iCurRow,"cost_gu2", dw_2.GetItemString(1,"cia04t_cost_gu2"))
 	 
	dw_3.SetItem(iCurRow,"cost_gbn", dw_2.GetItemString(1,"cost_gbn"))
	dw_3.SetItem(iCurRow,"babu",     dw_2.GetItemString(1,"cia04t_babu"))
	dw_3.SetItem(iCurRow,"data_gu",  dw_2.GetItemString(1,"data_gu"))

	dw_3.ScrollToRow(iCurRow)
	
	dw_3.SetColumn("cost_cd")
	dw_3.SetFocus()
	
	ib_any_typing =False

END IF

end event

type p_search from w_inherite`p_search within w_cia00040
integer x = 3397
integer taborder = 100
string picturename = "C:\erpman\image\복사_up.gif"
end type

event p_search::clicked;call super::clicked;Integer iCount


if dw_ym.AcceptText() = -1 then Return

LsIoYeraMonth  = Trim(dw_ym.GetItemstring(1,"io_yymm"))
LsIoYeraMonthT = Trim(dw_ym.GetItemstring(1,"io_yymmt"))
LsCostSaupj    = Trim(dw_ym.GetItemstring(1,"cost_saup"))
LsCostGbn      = Trim(dw_ym.GetItemstring(1,"costgu"))

if MessageBox('확 인','당월의 수동생성기준값을 모두 삭제하고 전달의 수동생성기준값으로 생성합니다'+'~r'+&
							 '계속하시겠습니까?',Question!,YesNo!) = 2 then Return
							 
select Count(*) into :iCount 	from cia04t 
	where io_yymm = :LsIoYeraMonth and io_yymmt = :LsIoYeraMonthT and data_gu = 'M';
if sqlca.sqlcode = 0 then
	if IsNull(iCount) then iCount = 0
else
	iCount = 0
end if

delete from from cia04t where io_yymm = :LsIoYeraMonth and io_yymmt = :LsIoYeraMonthT and data_gu = 'M';
commit;

insert into cia04t
	(io_yymm,				io_yymmt,				ucost_cd,				cost_cd,				cost_gu2,			cost_gbn,	
	 babu,					babu_num,				babu_rate,			data_gu)
select :LsIoYeraMonth,	:LsIoYeraMontht,		ucost_cd,				cost_cd,				cost_gu2,			cost_gbn,	
		 babu,				babu_num,				babu_rate,			data_gu
	from cia04t
	where io_yymm||io_yymmt = (select max(io_yymm||io_yymmt) from cia04t 
								where io_yymm||io_yymmt < :LsIoYeraMonth||:LsIoYeraMontht and data_gu = 'M') and 
			data_gu = 'M' ;
commit;

p_inq.TriggerEvent(Clicked!)



end event

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\복사_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\복사_up.gif"
end event

type p_ins from w_inherite`p_ins within w_cia00040
boolean visible = false
integer x = 4055
integer y = 3000
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_cia00040
integer taborder = 90
end type

type p_can from w_inherite`p_can within w_cia00040
integer taborder = 80
end type

event p_can::clicked;call super::clicked;ib_any_typing = False

dw_2.Reset()
dw_3.Reset()

dw_2.InsertRow(0)

dw_2.SetColumn("cia02m_cost_cd")
dw_2.SetFocus()


dw_1.Retrieve(lsioyeramonth,lsioyeramontht,LsCostSaupj,LsCostGbn)

end event

type p_print from w_inherite`p_print within w_cia00040
boolean visible = false
integer x = 3858
integer y = 2996
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_cia00040
integer x = 3575
end type

event p_inq::clicked;call super::clicked;
Long     rtncode

if dw_ym.AcceptText() = -1 then Return

LsIoYeraMonth  = Trim(dw_ym.GetItemstring(1,"io_yymm"))
LsIoYeraMonthT = Trim(dw_ym.GetItemstring(1,"io_yymmt")) 
LsCostSaupj    = Trim(dw_ym.GetItemstring(1,"cost_saup"))
LsCostGbn      = Trim(dw_ym.GetItemstring(1,"costgu"))

if LsIoYeraMonth = '' or IsNull(LsIoYeraMonth) then
	F_MessageChk(1,'[원가년월]')
	dw_ym.SetColumn("io_yymm")
	dw_ym.SetFocus()
	Return
end if

if LsIoYeraMontht = '' or IsNull(LsIoYeraMontht) then
	F_MessageChk(1,'[원가년월]')
	dw_ym.SetColumn("io_yymmt")
	dw_ym.SetFocus()
	Return
end if

if LsCostSaupj = '' or IsNull(LsCostSaupj) then
	F_MessageChk(1,'[원가사업부]')
	dw_ym.SetColumn("cost_saup")
	dw_ym.SetFocus()
	Return
end if

dw_1.Retrieve(LsIoYeraMonth,LsIoYeraMonthT,LsCostSaupj,LsCostGbn)

dw_2.SetRedraw(False)
dw_2.Reset()

DataWindowChild state_child

rtncode = dw_2.GetChild('cia04t_babu', state_child)
state_child.SetTransObject(SQLCA)
state_child.Retrieve("C2")

rtncode = dw_2.GetChild('cia02m_cost_cd', state_child)
state_child.SetTransObject(SQLCA)
state_child.Retrieve(LsCostSaupj,LsCostGbn)

dw_2.InsertRow(0)
dw_2.SetRedraw(True)

dw_3.Reset()
end event

type p_del from w_inherite`p_del within w_cia00040
boolean visible = false
integer x = 4279
integer y = 2964
integer taborder = 0
boolean originalsize = true
boolean focusrectangle = true
end type

type p_mod from w_inherite`p_mod within w_cia00040
integer x = 4096
integer taborder = 70
end type

event p_mod::clicked;call super::clicked;Integer  k,iRowCount

IF dw_2.AcceptText() = -1 THEN Return

IF WF_REQCHK() = -1 THEN RETURN

If dw_3.AcceptText() = -1 Then Return

IF F_DbConFirm('저장') = 2  THEN RETURN

iRowCount = dw_3.RowCount()

FOR k = 1 TO iRowCount
	dw_3.SetItem(k,"io_yymm",  LsIoYeraMonth)
	dw_3.SetItem(k,"io_yymmt",  LsIoYeraMontht)
	dw_3.SetItem(k,"ucost_cd", dw_2.GetItemString(1,"cia02m_cost_cd"))
	dw_3.SetItem(k,"cost_gu2", dw_2.GetItemString(1,"cia04t_cost_gu2"))
 	 
	dw_3.SetItem(k,"cost_gbn", dw_2.GetItemString(1,"cost_gbn"))
	dw_3.SetItem(k,"babu",     dw_2.GetItemString(1,"cia04t_babu"))
	dw_3.SetItem(k,"data_gu",  dw_2.GetItemString(1,"data_gu"))		
NEXT

if dw_3.Update() <> 1 then
	Rollback;
	F_MessageChk(12,'')
else
	Commit;
	ib_any_typing = False
	w_mdi_frame.sle_msg.text ="자료가 저장되었습니다.!!!"
	
	p_can.TriggerEvent(Clicked!)
end if


end event

type cb_exit from w_inherite`cb_exit within w_cia00040
integer x = 2949
integer y = 2812
end type

type cb_mod from w_inherite`cb_mod within w_cia00040
integer x = 2473
integer y = 2812
end type

event cb_mod::clicked;call super::clicked;Integer  k,iRowCount

IF dw_2.AcceptText() = -1 THEN Return

IF WF_REQCHK() = -1 THEN RETURN

If dw_3.AcceptText() = -1 Then Return

IF F_DbConFirm('저장') = 2  THEN RETURN

iRowCount = dw_3.RowCount()

FOR k = 1 TO iRowCount
	dw_3.SetItem(k,"io_yymm",  LsIoYeraMonth)
	dw_3.SetItem(k,"ucost_cd", dw_2.GetItemString(1,"cia02m_cost_cd"))
	dw_3.SetItem(k,"cost_gu2", dw_2.GetItemString(1,"cia04t_cost_gu2"))
 	 
	dw_3.SetItem(k,"cost_gbn", dw_2.GetItemString(1,"cost_gbn"))
	dw_3.SetItem(k,"babu",     dw_2.GetItemString(1,"cia04t_babu"))
	dw_3.SetItem(k,"data_gu",  dw_2.GetItemString(1,"data_gu"))		
NEXT

if dw_3.Update() <> 1 then
	Rollback;
	F_MessageChk(12,'')
else
	Commit;
	ib_any_typing = False
	sle_msg.text ="자료가 저장되었습니다.!!!"
	
	cb_can.TriggerEvent(Clicked!)
end if


end event

type cb_ins from w_inherite`cb_ins within w_cia00040
integer x = 1646
integer y = 2812
integer width = 393
string text = "행추가(&A)"
end type

event cb_ins::clicked;call super::clicked;Integer  iCurRow,iFunctionValue,iRowCount

sle_msg.text =""

iRowCount = dw_3.RowCount()

IF iRowCount > 0 THEN
	iFunctionValue = Wf_ReqChk()
	IF iFunctionValue <> 1 THEN RETURN
ELSE
	iFunctionValue = 1	
	
	iRowCount = 0
END IF

IF iFunctionValue = 1 THEN
	iCurRow = iRowCount + 1
	
	dw_3.InsertRow(iCurRow)

	dw_3.ScrollToRow(iCurRow)
	dw_3.SetItem(iCurRow,"flag",'1')
	
	dw_3.SetItem(iCurRow,"io_yymm",  LsIoYeraMonth)
	dw_3.SetItem(iCurRow,"ucost_cd", dw_2.GetItemString(1,"cia02m_cost_cd"))
	dw_3.SetItem(iCurRow,"cost_gu2", dw_2.GetItemString(1,"cia04t_cost_gu2"))
 	 
	dw_3.SetItem(iCurRow,"cost_gbn", dw_2.GetItemString(1,"cost_gbn"))
	dw_3.SetItem(iCurRow,"babu",     dw_2.GetItemString(1,"cia04t_babu"))
	dw_3.SetItem(iCurRow,"data_gu",  dw_2.GetItemString(1,"data_gu"))

	dw_3.SetColumn("cost_cd")
	dw_3.SetFocus()
	
	ib_any_typing =False

END IF

end event

type cb_del from w_inherite`cb_del within w_cia00040
integer x = 2062
integer y = 2812
integer width = 393
string text = "행삭제(&D)"
end type

event cb_del::clicked;call super::clicked;Long   ToTal_Row

IF F_DbConFirm('삭제') = 2 THEN RETURN

dw_3.DeleteRow(dw_3.GetRow())

wf_comper()  /* 배부기준값에 따른 배부율 다시 계산*/

IF dw_3.Update() = 1 THEN
	commit;
	ib_any_typing = False
	sle_msg.text ="자료가 삭제되었습니다.!!!"

   ToTal_Row = dw_3.RowCount()
	IF ToTal_Row  = 0 THEN
		dw_1.Retrieve(LsIoYeraMonth)
		
		dw_2.SetRedraw(False)
		dw_2.Reset()
		dw_2.InsertRow(0)
		dw_2.SetRedraw(True)
	END IF	
ELSE
	ROLLBACK;
	f_messagechk(12,'')
END IF

end event

type cb_inq from w_inherite`cb_inq within w_cia00040
integer x = 37
integer y = 2812
end type

event cb_inq::clicked;call super::clicked;
Long     rtncode

if dw_ym.AcceptText() = -1 then Return

LsIoYeraMonth = Trim(dw_ym.GetItemstring(1,"io_yymm"))
if LsIoYeraMonth = '' or IsNull(LsIoYeraMonth) then
	F_MessageChk(1,'[기준년월]')
	dw_ym.SetColumn("io_yymm")
	dw_ym.SetFocus()
	Return
end if

dw_1.Retrieve(LsIoYeraMonth)

dw_2.SetRedraw(False)
dw_2.Reset()

DataWindowChild state_child

rtncode = dw_2.GetChild('cia04t_babu', state_child)
state_child.SetTransObject(SQLCA)
state_child.Retrieve("C2")
dw_2.InsertRow(0)
dw_2.SetRedraw(True)

dw_3.Reset()
end event

type cb_print from w_inherite`cb_print within w_cia00040
integer x = 2661
integer y = 2696
end type

type st_1 from w_inherite`st_1 within w_cia00040
end type

type cb_can from w_inherite`cb_can within w_cia00040
integer x = 2830
integer y = 2812
end type

event cb_can::clicked;call super::clicked;ib_any_typing = False

dw_2.Reset()
dw_3.Reset()

dw_2.InsertRow(0)

dw_2.SetColumn("cia02m_cost_cd")
dw_2.SetFocus()
//dw_2.SetITem(1,"data_gu",'M')  /*자료생성구분 */
dw_1.Retrieve(lsioyeramonth)

end event

type cb_search from w_inherite`cb_search within w_cia00040
integer x = 2117
integer y = 2684
end type

type dw_datetime from w_inherite`dw_datetime within w_cia00040
integer x = 2871
end type

type sle_msg from w_inherite`sle_msg within w_cia00040
integer width = 2487
end type



type gb_button1 from w_inherite`gb_button1 within w_cia00040
integer x = 0
integer y = 2756
integer width = 407
end type

type gb_button2 from w_inherite`gb_button2 within w_cia00040
integer x = 1609
integer y = 2760
integer width = 1952
end type

type dw_2 from datawindow within w_cia00040
event ue_enter pbm_dwnprocessenter
integer x = 2779
integer y = 224
integer width = 1586
integer height = 624
integer taborder = 40
boolean bringtotop = true
string dataobject = "dw_cia00040_2"
boolean border = false
boolean livescroll = true
end type

event ue_enter;Send(Handle(This),256,9,0)
Return 1
end event

event itemchanged;String  sUcost_Cd,sCost_Gu2,sCost_Gbn,sBabu,sCostGu6,sCostLev,snull
Long    ll_Row,rtncode

DataWindowChild state_child

SetNull(snull)

dw_3.Reset()

IF this.GetColumnName() = "cia02m_cost_cd" THEN
	sUcost_Cd  = this.GetText()
   IF sUcost_Cd = '' OR ISNULL(sUcost_Cd) THEN RETURN	

	select cost_gu2,		cost_gu3,		cost_gu4,		cost_gu5,		cost_gu6
		into :sCost_Gu2,	:lcost_gu3,		:lcost_gu4,		:lcost_gu5,		:sCostGu6
		from cia02m
		where cost_cd = :sUcost_Cd and usegbn = '1';
	if sqlca.sqlcode <> 0 or sCostGu6 = 'Y' then
    	MessageBox("확 인"," 코    드   : "+String('') +"~n"+&
							 " 메 세 지  : " + ''+''+'직접부문여부가 "N" 인 자료만 사용할수 있습니다.' +  "~n~n" +&
							 " 처리방안 : "+'상위부문을 확인하세요!!', Exclamation! )
		this.SetITem(1,"cia02m_cost_cd",snull)
		Return 1		
	end if	
	this.SetItem(this.GetRow(),"cia04t_cost_gu2",sCost_Gu2)
	
	IF lcost_gu3 = 'Y' THEN
		sCostLev = '1'		
	ELSEIF lcost_gu4 = 'Y' THEN
		sCostLev = '2'		
	ELSEIF lcost_gu5 = 'Y' THEN
		sCostLev = '3'		
	END IF
	
	this.SetITem(this.GetRow(),"cost_gbn",sCostLev)
	
	rtncode = dw_3.GetChild('cost_cd', state_child)
	state_child.SetTransObject(SQLCA)
	
	IF LsBabuMode = '1' then				/*직접부문에 배부*/
		state_child.Retrieve(LsCostGbn,LsCostSaupj,3)
	ELSE
		state_child.Retrieve(LsCostGbn,LsCostSaupj,Integer(sCostLev))
	END IF
	
	sCost_Gbn = this.GetItemString(1,"cost_gbn")        /*비용*/
	sBabu     = this.GetItemString(1,"cia04t_babu")     /*배부*/
	
 	dw_3.Retrieve(LsIoYeraMonth,LsIoYeraMonthT,sUcost_Cd,sCost_Gu2,sCost_Gbn,sBabu)
	
END IF	

if this.GetColumnName() = "cia04t_babu" then
	sBabu = this.GetText()
	if sBabu = '' or IsNull(sBabu) then Return
	
	dw_3.Retrieve(LsIoYeraMonth,		&
					  LsIoYeraMonthT,   &
					  this.GetItemString(1,"cia02m_cost_cd"), &
					  this.GetItemString(1,"cia04t_cost_gu2"),&
					  this.GetItemString(1,"cost_gbn"), sBabu)
end if

end event

event retrievestart;DataWindowChild dw_child
Int il_row

IF lcost_gu3 = 'Y' THEN
   IF dw_2.GetChild("cia04t_babu",dw_child) = 1 THEN
	   dw_child.SetTransObject(SQLCA)
	   IF dw_child.Retrieve('C1') <=0 THEN RETURN 1
   END IF		
ELSEIF lcost_gu4 = 'Y' THEN		
	IF dw_2.GetChild("cia04t_babu",dw_child) = 1 THEN
	   dw_child.SetTransObject(SQLCA)
	   IF dw_child.Retrieve('C2') <=0 THEN RETURN 1
   END IF		
ELSEIF lcost_gu5 = 'Y' THEN			
	IF dw_2.GetChild("cia04t_babu",dw_child) = 1 THEN
	   dw_child.SetTransObject(SQLCA)
	   IF dw_child.Retrieve('C3') <=0 THEN RETURN 1
   END IF		
END IF	


end event

event itemerror;Return 1
end event

event editchanged;ib_any_typing = true
end event

type dw_3 from datawindow within w_cia00040
event ue_enter pbm_dwnprocessenter
integer x = 2779
integer y = 852
integer width = 1664
integer height = 1344
integer taborder = 60
boolean bringtotop = true
string dataobject = "dw_cia00040_3"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_enter;Send(Handle(This),256,9,0)
Return 1
end event

event retrievestart;//String sCost_cd
//DataWindowChild dw_child
//Int il_row
//
//dw_2.AcceptText()
//
//sCost_cd = dw_2.GetItemString(dw_2.GetRow(),"cia02m_cost_cd")
//
// IF dw_3.GetChild("cia02m_cost_cd",dw_child) = 1 THEN
//    dw_child.SetTransObject(SQLCA)
//	 IF dw_child.Retrieve(sCost_cd) <=0 THEN RETURN 1
// END IF		
//
//
end event

event itemerror;Return 1
end event

event itemchanged;String   sHa_Cd,sNull
Integer  lReturnRow

SetNull(snull)

this.AcceptText()
IF This.GetColumnName() = "babu_num" THEN  														/*배부기준값*/
	Wf_ComPer()
END IF	

IF This.GetColumnName() = "cost_cd" THEN
   sHa_Cd  = This.GetText() 
   lReturnRow = this.find("cost_cd = '" + sHa_Cd + "'",1,this.rowcount())
	
	  IF (Row <> lReturnRow) and (lReturnRow <> 0) then 
	     messagebox("확 인","입력하신 코드로 이미 자료가 저장되어 있습니다!!")
	     THIS.SetItem(this.GetRow(), "cost_cd",snull)
	     Return 1
	  END IF
END IF
end event

event editchanged;ib_any_typing = true
end event

type dw_ym from u_key_enter within w_cia00040
integer x = 146
integer y = 28
integer width = 3118
integer height = 144
integer taborder = 20
boolean bringtotop = true
string dataobject = "dw_cia00040_0"
boolean border = false
end type

event itemchanged;call super::itemchanged;DataWindowChild state_child
Integer   rtncode

if this.GetColumnName() = 'cost_saup' then
	LsCostSaupj = this.GetText()
	if LsCostSaupj = '' or IsNull(LsCostSaupj) then LsCostSaupj = '%'
end if

if this.GetColumnName() = 'costgu' then
	LsCostGbn = this.GetText()
	if LsCostGbn = '' or IsNull(LsCostGbn) then LsCostGbn = '10'
end if

rtncode = dw_2.GetChild('cia02m_cost_cd', state_child)
state_child.SetTransObject(SQLCA)
state_child.Retrieve(LsCostSaupj,LsCostGbn)
end event

type dw_1 from u_d_popup_sort within w_cia00040
integer x = 165
integer y = 208
integer width = 2528
integer height = 2008
integer taborder = 0
boolean bringtotop = true
string dataobject = "dw_cia00040_1"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event clicked;String          l_ucost_cd
Integer         rtncode
DataWindowChild state_child

If Row <= 0 then
	SelectRow(0,False)
	b_flag = True
ELSE
	
	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	b_flag = False

	dw_2.SetItem(dw_2.GetRow(),"cia02m_cost_cd",  this.GetItemString(Row,"cia04t_ucost_cd"))
	dw_2.SetItem(dw_2.GetRow(),"cia04t_cost_gu2", this.GetItemString(Row,"cia04t_cost_gu2"))
	dw_2.SetItem(dw_2.GetRow(),"cost_gbn",        this.GetItemString(Row,"cia04t_cost_gbn"))
	dw_2.SetItem(dw_2.GetRow(),"cia04t_babu",     this.GetItemString(Row,"cia04t_babu"))
	dw_2.SetItem(dw_2.GetRow(),"data_gu",         this.GetItemString(Row,"cia04t_data_gu"))
	
	l_ucost_cd = this.GetItemString(Row,"cia04t_ucost_cd") 										/*상위부문*/

	rtncode = dw_3.GetChild('cost_cd', state_child)
	state_child.SetTransObject(SQLCA)
	
	if LsBabuMode = '1' then				/*직접부문에 배부*/
		state_child.Retrieve(LsCostGbn,LsCostSaupj,3)
	else
		state_child.Retrieve(LsCostGbn,LsCostSaupj,Integer(this.GetItemString(Row,"cia04t_cost_gbn")))
	end if
	
	dw_3.Retrieve(LsIoYeraMonth,  &
					  LsIoYeraMonthT, &
					  l_ucost_cd, 		&
					  dw_2.GetItemString(1,"cia04t_cost_gu2"), &
					  dw_2.GetItemString(1,"cost_gbn"), 		 &
					  dw_2.GetItemString(1,"cia04t_babu"))		 
END IF

CALL SUPER ::CLICKED
end event

type rr_1 from roundrectangle within w_cia00040
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 155
integer y = 204
integer width = 2551
integer height = 2024
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_2 from roundrectangle within w_cia00040
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2734
integer y = 208
integer width = 1733
integer height = 2000
integer cornerheight = 40
integer cornerwidth = 46
end type

