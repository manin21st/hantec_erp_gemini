$PBExportHeader$w_cia00005.srw
$PBExportComments$계정과목별배부기준등록
forward
global type w_cia00005 from w_inherite
end type
type dw_2 from datawindow within w_cia00005
end type
type dw_3 from datawindow within w_cia00005
end type
type rr_1 from roundrectangle within w_cia00005
end type
end forward

global type w_cia00005 from w_inherite
string title = "계정별 배부기준 등록"
dw_2 dw_2
dw_3 dw_3
rr_1 rr_1
end type
global w_cia00005 w_cia00005

forward prototypes
public function integer wf_warndataloss (string as_titletext)
public function integer wf_checkref (string l_code, string l_gubn)
public function integer wf_dupchk (string acc_1, string acc_2)
public function integer wf_reqchk (integer il_row)
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

		dw_2.SetFocus()						// yes 일 경우: focus 'dw_detail' 
		RETURN -1									

	END IF

END IF
																
RETURN 1												// (dw_detail) 에 변경사항이 없거나 no일 경우
														// 변경사항을 저장하지 않고 계속진행 

end function

public function integer wf_checkref (string l_code, string l_gubn);Long sCount

  SELECT count("REFFPF"."RFCOD")
    INTO :sCount
    FROM "REFFPF"  
   WHERE "REFFPF"."RFCOD" =:l_code AND
         "REFFPF"."RFGUB" =:l_gubn   ;

IF sCount = 0 THEN
   Return -1
END IF	

Return 1
end function

public function integer wf_dupchk (string acc_1, string acc_2);lONG sCnt

SELECT COUNT(*) 
  INTO :sCnt  
  FROM "CIA01M" 
 WHERE "CIA01M"."ACC1_CD" = :ACC_1 AND
	    "CIA01M"."ACC2_CD" = :ACC_2 ;
IF sCnt >= 1 THEN
	 f_messageChk(10,'[계정과목]') 
	 Return -1
END IF	

Return 1
end function

public function integer wf_reqchk (integer il_row);String sAcc1_cd,sAcc2_cd

dw_2.AcceptText()

sAcc1_cd = dw_2.GetItemString(il_row,"acc1_cd")
sAcc2_cd = dw_2.GetItemString(il_row,"acc2_cd")

IF sAcc1_cd = '' OR ISNULL(sAcc1_cd) THEN
	f_messagechk(1,'[계정과목]')
	dw_2.SetColumn("acc1_cd")
	dw_2.SetFocus()
	Return -1
END IF	
IF sAcc2_cd = '' OR ISNULL(sAcc2_cd) THEN
	f_messagechk(1,'[계정과목]')
	dw_2.SetColumn("acc2_cd")
	dw_2.SetFocus()
	Return -1
END IF	

Return 1 
end function

on w_cia00005.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.dw_3=create dw_3
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.dw_3
this.Control[iCurrent+3]=this.rr_1
end on

on w_cia00005.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_2)
destroy(this.dw_3)
destroy(this.rr_1)
end on

event open;call super::open;
dw_3.SetTransObject(sqlca)
dw_3.InsertRow(0)

dw_2.SetTransObject(sqlca)
dw_2.Retrieve('1')
end event

type dw_insert from w_inherite`dw_insert within w_cia00005
boolean visible = false
integer x = 270
integer y = 2564
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_cia00005
boolean visible = false
integer x = 4110
integer y = 2728
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_cia00005
boolean visible = false
integer x = 3936
integer y = 2728
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_cia00005
integer x = 3415
integer y = 0
integer width = 306
integer taborder = 80
boolean originalsize = true
string picturename = "C:\erpman\image\계정과목가져오기_up.gif"
end type

event p_search::clicked;call super::clicked;String  sAcGbn,sFrAcc,sToAcc

dw_3.AcceptText()
sAcGbn = dw_3.GetItemString(1,"acgbn")
if sAcGbn = '' or IsNull(sAcGbn) then
	F_MessageChk(1,'[계정구분]')
	dw_3.SetColumn("acgbn")
	dw_3.SetFocus()
	Return
else
	select substr(rfna2,1,7), substr(rfna2,8,7) into :sFrAcc, :sToAcc from reffpf where rfcod = 'C8' and rfgub = :sAcGbn;
end if

if dw_2.RowCount() > 0 then
	If MessageBox('확 인','자료를 삭제후 다시 생성합니다.계속하시겠습니까?',Question!,YesNo!) = 2 then Return
	
	delete from cia01m where acc_gbn = :sAcGbn ;
	Commit;

end if

w_mdi_frame.sle_msg.text = '계정과목 읽는 중...'
SetPointer(HourGlass!)

insert into cia01m
	(acc1_cd,	acc2_cd,	acc_gbn,		babu1,	babu2,	babu3,	ele_gbn,	ele_gbn2,ele_gbn3, method)
select acc1_cd,acc2_cd, :sAcGbn,		'01',		'01',		'01',		'30',		null,		null,		 '1'
	from kfz01om0
	where acc1_cd||acc2_cd >= :sFrAcc and acc1_cd||acc2_cd <= :sToAcc  and acc2_cd = '00' ;
if sqlca.sqlcode <> 0 then
	rollback;
	F_MessageChk(13,'')
	Return
end if
Commit;

w_mdi_frame.sle_msg.text = '저장 완료'
SetPointer(Arrow!)

dw_2.Retrieve(sAcGbn)

end event

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\계정과목가져오기_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\계정과목가져오기_up.gif"
end event

type p_ins from w_inherite`p_ins within w_cia00005
integer x = 3739
integer y = 0
end type

event p_ins::clicked;call super::clicked;Integer  iCurRow,iFunctionValue,iGetRow

w_mdi_frame.sle_msg.text =""

IF dw_2.RowCount() > 0 THEN
	iFunctionValue = Wf_ReqChk(dw_2.GetRow())
	IF iFunctionValue <> 1 THEN RETURN
	
	iGetRow = dw_2.GetRow()
ELSE
	iFunctionValue = 1	
	
	iGetRow = 0
END IF

IF iFunctionValue = 1 THEN
	iCurRow = iGetRow + 1
	
	dw_2.InsertRow(iCurRow)

	dw_2.ScrollToRow(iCurRow)
	
	dw_2.SetItem(iCurRow,"acc_gbn",dw_3.GetItemString(1,"acgbn"))
	dw_2.SetColumn("acc1_cd")
	dw_2.SetFocus()
	
	ib_any_typing =False

END IF

end event

type p_exit from w_inherite`p_exit within w_cia00005
integer x = 4434
integer y = 0
integer taborder = 70
end type

type p_can from w_inherite`p_can within w_cia00005
integer x = 4261
integer y = 0
integer taborder = 60
end type

event p_can::clicked;call super::clicked;
dw_2.Retrieve(dw_3.GetItemString(1,"acgbn"))
end event

type p_print from w_inherite`p_print within w_cia00005
boolean visible = false
integer x = 3570
integer y = 2732
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_cia00005
boolean visible = false
integer x = 1810
integer y = 4
integer taborder = 0
end type

event p_inq::clicked;call super::clicked;String sAcc1_cd,sAcc2_cd
Long ll_Row

dw_2.AcceptText()

sAcc1_cd = dw_2.GetItemString(1,"acc1_cd")
sAcc2_cd = dw_2.GetItemString(1,"acc2_cd")

IF sAcc1_cd  <> '' AND sAcc2_cd <> '' THEN
   ll_Row = dw_2.Retrieve(sAcc1_cd,sAcc2_cd)
END IF
IF ll_Row = 0 THEN
	
	dw_2.InsertRow(0)
END IF	
end event

type p_del from w_inherite`p_del within w_cia00005
integer x = 4087
integer y = 0
integer taborder = 50
end type

event p_del::clicked;call super::clicked;IF F_DbConFirm('삭제') = 2 THEN RETURN

dw_2.DeleteRow(0)

IF dw_2.Update() = 1 THEN
	commit;
	ib_any_typing = False
	
	w_mdi_frame.sle_msg.text ="자료가 삭제되었습니다.!!!"
ELSE
	ROLLBACK;
	f_messagechk(12,'')
END IF

end event

type p_mod from w_inherite`p_mod within w_cia00005
integer x = 3913
integer y = 0
integer taborder = 40
end type

event p_mod::clicked;call super::clicked;String sGbn,l_acc1_cd,l_acc2_cd

IF F_DbConFirm('저장') = 2  THEN RETURN

dw_2.AcceptText()

ib_any_typing = False

IF wf_reqchk(dw_2.GetRow()) = -1 THEN
	Return 
END IF	

IF dw_2.Update() > 0	THEN
	COMMIT;															 
ELSE
	ROLLBACK;
	f_messagechk(13,'')
	Return 
END IF

p_can.TriggerEvent(Clicked!)
w_mdi_frame.sle_msg.text = '자료를 저장하였습니다!!'
end event

type cb_exit from w_inherite`cb_exit within w_cia00005
integer x = 2939
integer y = 2636
end type

event cb_exit::clicked;//sle_msg.text =""
IF wf_warndataloss("종료") = -1 THEN 	RETURN

close(parent)

end event

type cb_mod from w_inherite`cb_mod within w_cia00005
integer x = 2107
integer y = 2636
end type

type cb_ins from w_inherite`cb_ins within w_cia00005
integer x = 1280
integer y = 2564
end type

type cb_del from w_inherite`cb_del within w_cia00005
integer x = 2464
integer y = 2636
end type

type cb_inq from w_inherite`cb_inq within w_cia00005
integer x = 50
integer y = 2636
end type

event cb_inq::clicked;call super::clicked;String sAcc1_cd,sAcc2_cd
Long ll_Row

dw_2.AcceptText()

sAcc1_cd = dw_2.GetItemString(1,"acc1_cd")
sAcc2_cd = dw_2.GetItemString(1,"acc2_cd")

IF sAcc1_cd  <> '' AND sAcc2_cd <> '' THEN
   ll_Row = dw_2.Retrieve(sAcc1_cd,sAcc2_cd)
END IF
IF ll_Row = 0 THEN
	
	dw_2.InsertRow(0)
END IF	
end event

type cb_print from w_inherite`cb_print within w_cia00005
integer x = 1577
integer y = 2772
end type

type st_1 from w_inherite`st_1 within w_cia00005
end type

type cb_can from w_inherite`cb_can within w_cia00005
integer x = 2821
integer y = 2636
end type

type cb_search from w_inherite`cb_search within w_cia00005
integer x = 2007
integer y = 2760
end type

type dw_datetime from w_inherite`dw_datetime within w_cia00005
integer x = 2871
end type

type sle_msg from w_inherite`sle_msg within w_cia00005
integer width = 2487
end type



type gb_button1 from w_inherite`gb_button1 within w_cia00005
integer x = 18
integer y = 2584
integer width = 407
end type

type gb_button2 from w_inherite`gb_button2 within w_cia00005
integer x = 2066
integer y = 2580
end type

type dw_2 from datawindow within w_cia00005
event ue_enter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 69
integer y = 176
integer width = 4530
integer height = 2020
integer taborder = 30
boolean bringtotop = true
string dataobject = "dw_cia00005_2"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_enter;Send(Handle(this),256,9,0)
Return 1
end event

event ue_key;if keydown(keyF1!) or keydown(keytab!) then
	triggerevent(rbuttondown!)
end if
end event

event itemerror;Return 1
end event

event rbuttondown;Long  sCnt

SetNull(lstr_account.acc1_cd)
SetNull(lstr_account.acc2_cd)

dw_2.AcceptText()

IF this.GetColumnName() = "acc1_cd" OR this.GetColumnName() = "acc2_cd" THEN
	lstr_account.acc1_cd = this.GetItemString(this.GetRow(),"acc1_cd")
	
	Open(W_KFZ01OM0_POPUP1)

	IF IsNull(lstr_account.acc1_cd) OR lstr_account.acc1_cd = "" THEN Return
	
	THIS.SetItem(THIS.GetRow(), "acc1_cd", lstr_account.acc1_cd)
	THIS.SetItem(THIS.GetRow(), "acc2_cd", lstr_account.acc2_cd)
	THIS.SetItem(THIS.GetRow(), "kfz01om0_acc2_nm", lstr_account.acc2_nm)
	
END IF
end event

event itemchanged;String sAcc1,sAcc2,sAcc2Name,snull
String Acc_Gbn

SetNull(snull)

sle_msg.text =""

this.AcceptText()

IF this.GetColumnName() = "ele_gbn"   THEN  /*원가요소구분*/  
   Acc_Gbn = this.GetText()
   IF Acc_Gbn  = '' OR ISNULL(Acc_Gbn) THEN RETURN
   IF WF_CHECKREF('C4',Acc_Gbn) = -1 THEN
		THIS.SetITem(row,"ele_gbn",snull)
		f_messagechk(20,'[원가요소구분]')
		Return 1
   END IF
END IF
IF this.GetColumnName() = "ele_gbn2"  THEN  /*손익요소구분*/   
   Acc_Gbn = this.GetText()
   IF Acc_Gbn  = '' OR ISNULL(Acc_Gbn) THEN RETURN
   IF WF_CHECKREF('C5',Acc_Gbn) = -1 THEN
		THIS.SetITem(row,"ele_gbn2",snull)
		f_messagechk(20,'[손익요소구분]')
		Return 1
   END IF
END IF
IF this.GetColumnName() = "ele_gbn3"  THEN  /*공사요소구분*/   
   Acc_Gbn = this.GetText()
   IF Acc_Gbn  = '' OR ISNULL(Acc_Gbn) THEN RETURN
   IF WF_CHECKREF('C6',Acc_Gbn) = -1 THEN
		THIS.SetITem(row,"ele_gbn3",snull)
		f_messagechk(20,'[공사요소구분]')
		Return 1
   END IF
END IF
IF this.GetColumnName() = "babu1" THEN /*전체공통비 배부기준*/
   Acc_Gbn = this.GetText() 
   IF Acc_Gbn  = '' OR ISNULL(Acc_Gbn) THEN RETURN
   IF WF_CHECKREF('C1',Acc_Gbn) = -1 THEN
		THIS.SetITem(row,"babu1",snull)
		f_messagechk(20,'[전체공통비 배부기준]')
		Return 1
   END IF
END IF
IF this.GetColumnName() = "babu2" THEN    /*부문공통비 배부기준*/
   Acc_Gbn = this.GetText() 
   IF Acc_Gbn  = '' OR ISNULL(Acc_Gbn) THEN RETURN
   IF WF_CHECKREF('C2',Acc_Gbn) = -1 THEN
		THIS.SetITem(row,"babu2",snull)
		f_messagechk(20,'[부문공통비 배부기준]')
		Return 1
   END IF 
END IF

IF this.GetColumnName() = "babu3" THEN    /*보조부문비 배부기준*/
   Acc_Gbn = this.GetText() 
   IF Acc_Gbn  = '' OR ISNULL(Acc_Gbn) THEN RETURN
   IF WF_CHECKREF('C3',Acc_Gbn) = -1 THEN
		THIS.SetITem(row,"babu3",snull)
		f_messagechk(20,'[보조부문비 배부기준]')
		Return 1
   END IF 
END IF


IF this.GetColumnName() = "acc1_cd" THEN
	sAcc1 = this.GetText()
	IF sAcc1 = "" OR IsNull(sAcc1) THEN RETURN
	
	sAcc2 = this.GetItemString(this.GetRow(),"acc2_cd")
	IF sAcc2 = "" OR IsNull(sAcc2) THEN RETURN
	
	SELECT "KFZ01OM0"."ACC2_NM"
		INTO :sAcc2Name
	  	FROM "KFZ01OM0"  
	  	WHERE ( "KFZ01OM0"."ACC1_CD" = :sAcc1 ) AND ( "KFZ01OM0"."ACC2_CD" = :sAcc2 ) AND
		  		( "KFZ01OM0"."BAL_GU" <> '4');
	If Sqlca.Sqlcode = 0 then
		this.Setitem(this.getrow(),"kfz01om0_acc2_nm",sAcc2Name)
		if wf_dupchk(sAcc1,sAcc2) = -1 then
			this.Setitem(this.getrow(),"acc1_cd",snull)
			this.Setitem(this.getrow(),"acc2_cd",snull)
			this.Setitem(this.getrow(),"kfz01om0_acc2_nm",snull)
			this.SetColumn("acc1_cd")
			this.SetFocus()
			Return 1
		end if  
//	else
//		f_messageChk(20,'[계정과목]')
//		this.Setitem(this.getrow(),"acc1_cd",snull)
//		this.Setitem(this.getrow(),"acc2_cd",snull)
//		this.Setitem(this.getrow(),"kfz01om0_acc2_nm",sNull)
//		Return 1
	end if
END IF
lONG sCnt

IF this.GetColumnName() = "acc2_cd" THEN
	sAcc2 = this.GetText()
	IF sAcc2 = "" OR IsNull(sAcc1) THEN RETURN
	
	sAcc1 = this.GetItemString(this.GetRow(),"acc1_cd")
	IF sAcc1 = "" OR IsNull(sAcc2) THEN RETURN
	
	SELECT "KFZ01OM0"."ACC2_NM"
		INTO :sAcc2Name
	  	FROM "KFZ01OM0"  
	  	WHERE ( "KFZ01OM0"."ACC1_CD" = :sAcc1 ) AND ( "KFZ01OM0"."ACC2_CD" = :sAcc2 ) ;
	If Sqlca.Sqlcode = 0 then
		this.Setitem(this.getrow(),"kfz01om0_acc2_nm",sAcc2Name)
		if wf_dupchk(sAcc1,sAcc2) = -1 then
			this.Setitem(this.getrow(),"acc1_cd",snull)
			this.Setitem(this.getrow(),"acc2_cd",snull)
			this.Setitem(this.getrow(),"kfz01om0_acc2_nm",snull)
			this.SetColumn("acc1_cd")
			this.SetFocus()
			Return 1
		end if  
	else
//		f_messageChk(20,'[계정과목]')
//		this.Setitem(this.getrow(),"acc1_cd",snull)
//		this.Setitem(this.getrow(),"acc2_cd",snull)
//		this.Setitem(this.getrow(),"kfz01om0_acc2_nm",snull)
//		Return 1
		this.SetColumn("acc1_cd")
		this.SetFocus()
	end if
END IF
end event

event editchanged;ib_any_typing = True
end event

type dw_3 from datawindow within w_cia00005
integer x = 23
integer y = 8
integer width = 978
integer height = 132
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "dw_cia00005_1"
boolean border = false
boolean livescroll = true
end type

event itemchanged;String  sAcGbn
 
if this.GetColumnName() = 'acgbn' then
	sAcGbn = this.GetText()
	
	if sAcGbn = '1' then
		dw_2.object.t_6.text = '*원가요소'
	else
		dw_2.object.t_6.text = '*손익요소'
	end if
	
	dw_2.Retrieve(sAcGbn)
end if
end event

type rr_1 from roundrectangle within w_cia00005
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 168
integer width = 4553
integer height = 2044
integer cornerheight = 40
integer cornerwidth = 55
end type

