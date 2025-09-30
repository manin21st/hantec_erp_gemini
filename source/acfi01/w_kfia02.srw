$PBExportHeader$w_kfia02.srw
$PBExportComments$받을어음등록
forward
global type w_kfia02 from w_inherite
end type
type gb_5 from groupbox within w_kfia02
end type
type dw_1 from u_key_enter within w_kfia02
end type
type p_1 from picture within w_kfia02
end type
type p_2 from picture within w_kfia02
end type
type dw_2 from u_d_popup_sort within w_kfia02
end type
type rr_2 from roundrectangle within w_kfia02
end type
type dw_list from datawindow within w_kfia02
end type
type st_2 from statictext within w_kfia02
end type
type sle_1 from singlelineedit within w_kfia02
end type
type rr_1 from roundrectangle within w_kfia02
end type
type rr_3 from roundrectangle within w_kfia02
end type
type ln_1 from line within w_kfia02
end type
end forward

global type w_kfia02 from w_inherite
string title = "받을어음 등록"
gb_5 gb_5
dw_1 dw_1
p_1 p_1
p_2 p_2
dw_2 dw_2
rr_2 rr_2
dw_list dw_list
st_2 st_2
sle_1 sle_1
rr_1 rr_1
rr_3 rr_3
ln_1 ln_1
end type
global w_kfia02 w_kfia02

type variables

end variables

forward prototypes
public function integer wf_requiredchk (integer icurrow)
public subroutine wf_setting_retrievemode (string mode)
public function integer wf_insert_kfz12otd ()
public subroutine wf_init ()
end prototypes

public function integer wf_requiredchk (integer icurrow);String  sBillNo,sBalDate,sManDate,sBnkCd,sBillGbn,sSaupj,sUpmuGu,sAccDate,sAlcGbn
Double  dAmount
Long    lJunNo,iLinNo

dw_1.AcceptText()
sBillNo  = dw_1.GetItemString(iCurRow,"bill_no")
sManDate = Trim(dw_1.GetItemString(iCurRow,"bman_dat"))
sBnkCd   = dw_1.GetItemString(iCurRow,"bnk_cd")
dAmount  = dw_1.GetItemNumber(iCurRow,"bill_amt") 

sBillGbn = dw_1.GetItemString(iCurRow,"status")

sAlcGbn  = dw_1.GetItemString(iCurRow,"alc_gu")
sSaupj   = dw_1.GetItemString(iCurRow,"saupj")
sAccDate = Trim(dw_1.GetItemString(iCurRow,"acc_date"))
sBalDate = Trim(dw_1.GetItemString(iCurRow,"bal_date"))
sUpmuGu  = dw_1.GetItemString(iCurRow,"upmu_gu")
lJunNo   = dw_1.GetItemNumber(iCurRow,"bjun_no")
iLinNo   = dw_1.GetItemNumber(iCurRow,"lin_no")

IF sBillNo = "" OR IsNull(sBillNo) THEN 
	F_MessageChk(1,'[어음번호]')
	dw_1.SetColumn("bill_no")
	dw_1.SetFocus()
	Return -1
END IF
IF sManDate = "" OR IsNull(sManDate) THEN 
	F_MessageChk(1,'[만기일자]')
	dw_1.SetColumn("bman_dat")
	dw_1.SetFocus()
	Return -1
END IF
IF sBnkCd = "" OR IsNull(sBnkCd) THEN 
	F_MessageChk(1,'[지급은행]')
	dw_1.SetColumn("bnk_cd")
	dw_1.SetFocus()
	Return -1
END IF
IF dAmount = 0 OR IsNull(dAmount) THEN 
	F_MessageChk(1,'[어음금액]')
	dw_1.SetColumn("bill_amt")
	dw_1.SetFocus()
	Return -1
END IF

IF sBillGbn = "" OR IsNull(sBillGbn) THEN 
	F_MessageChk(1,'[어음상태]')
	dw_1.SetColumn("status")
	dw_1.SetFocus()
	Return -1
END IF

IF sAlcGbn = 'Y' AND (sAccDate = '' OR IsNull(sAccDate)) THEN
	F_MessageChk(1,'[회계일자]')
	dw_1.SetColumn("acc_date")
	dw_1.SetFocus()
	Return -1	
END IF

IF sSaupj = "" OR IsNull(sSaupj) THEN 
	F_MessageChk(1,'[사업장]')
	dw_1.SetColumn("saupj")
	dw_1.SetFocus()
	Return -1
END IF

IF sBalDate = "" OR IsNull(sBalDate) THEN 
	F_MessageChk(1,'[작성일자]')
	dw_1.SetColumn("bal_date")
	dw_1.SetFocus()
	Return -1
END IF
IF sUpmuGu = "" OR IsNull(sUpmuGu) THEN 
	F_MessageChk(1,'[전표구분]')
	dw_1.SetColumn("upmu_gu")
	dw_1.SetFocus()
	Return -1
END IF
IF lJunNo = 0 OR IsNull(lJunNo) THEN 
	F_MessageChk(1,'[전표번호]')
	dw_1.SetColumn("bjun_no")
	dw_1.SetFocus()
	Return -1
END IF

IF iLinNo = 0 OR IsNull(iLinNo) THEN 
	F_MessageChk(1,'[전표번호]')
	dw_1.SetColumn("lin_no")
	dw_1.SetFocus()
	Return -1
END IF
Return 1

end function

public subroutine wf_setting_retrievemode (string mode);dw_1.SetRedraw(False)
IF mode ="M" THEN
//	dw_1.SetTabOrder("bill_no",0)
//	dw_1.Modify("bill_no.background.color = '"+String(Rgb(192,192,192))+"'")
	dw_1.SetColumn("saup_no")
	
	p_del.Enabled =True
	p_del.PictureName = "C:\erpman\image\삭제_up.gif"
ELSE
//	dw_1.SetTabOrder("bill_no",10)
//	dw_1.Modify("bill_no.background.color = 65535")	
	
	dw_1.SetColumn("bill_no")
	p_del.Enabled =False
	p_del.PictureName = "C:\erpman\image\삭제_d.gif"
END IF
dw_1.SetFocus()
dw_1.SetRedraw(True)
end subroutine

public function integer wf_insert_kfz12otd ();String sBillNo,sSaupj,sBalDate,sUpmuGu,sFullJunNo
Long   lJunNo,iLinNo,LSeqNo,iRowCount

dw_1.AcceptText()
sBillNo = dw_1.GetItemString(dw_1.getrow(),"bill_no")

sSaupj   = dw_1.GetItemString(dw_1.getrow(),"saupj")
sBalDate = dw_1.GetItemString(dw_1.getrow(),"bal_date")
sUpmuGu  = dw_1.GetItemString(dw_1.getrow(),"upmu_gu")
lJunNo   = dw_1.GetItemNumber(dw_1.getrow(),"bjun_no")
iLinNo   = dw_1.GetItemNumber(dw_1.getrow(),"lin_no")
	
iRowCount = dw_list.Retrieve(sBillNo)
IF iRowCount <=0 THEN
	select max(nvl(to_number(substr(full_junno,1,5)),0))		into :LSeqNo
		from kfz12otd
		where bill_no = :sBillNo;
	IF SQLCA.SQLCODE <> 0 THEN
		LSeqNo = 0
	ELSE
		IF IsNull(LSeqNo) THEN LSeqNo = 0
	END IF
	LSeqNo = LSeqNo + 1
	
	sFullJunNo = String(LSeqNo,'00000')+ String(Integer(sSaupj),'00')+sBalDate+sUpmuGu+String(lJunNo,'0000')+String(iLinNo,'000')
	
	dw_list.InsertRow(0)
	dw_list.SetItem(dw_list.getrow(),"saupj",			sSaupj)
	dw_list.SetItem(dw_list.getrow(),"bal_date",		sBalDate)
	dw_list.SetItem(dw_list.getrow(),"upmu_gu",		sUpmuGu)
	dw_list.SetItem(dw_list.getrow(),"bjun_no",		lJunNo)
	dw_list.SetItem(dw_list.getrow(),"lin_no",		iLinNo)
	dw_list.SetItem(dw_list.getrow(),"full_junno",	sFullJunNo)

	dw_list.SetItem(dw_list.getrow(),"bill_no",				dw_1.GetItemString(dw_1.getrow(),"bill_no"))
	dw_list.SetItem(dw_list.getrow(),"saup_no",				dw_1.GetItemString(dw_1.getrow(),"saup_no"))
	dw_list.SetItem(dw_list.getrow(),"bnk_cd",				dw_1.GetItemString(dw_1.getrow(),"bnk_cd"))
	dw_list.SetItem(dw_list.getrow(),"bbal_dat",				dw_1.GetItemString(dw_1.getrow(),"bbal_dat"))
	dw_list.SetItem(dw_list.getrow(),"bman_dat",				dw_1.GetItemString(dw_1.getrow(),"bman_dat"))
	dw_list.SetItem(dw_list.getrow(),"bill_amt",				dw_1.GetItemNumber(dw_1.getrow(),"bill_amt"))
	dw_list.SetItem(dw_list.getrow(),"bill_nm",				dw_1.GetItemString(dw_1.getrow(),"bill_nm"))
	dw_list.SetItem(dw_list.getrow(),"bill_ris",				dw_1.GetItemString(dw_1.getrow(),"bill_ris"))
	dw_list.SetItem(dw_list.getrow(),"bill_gu",				dw_1.GetItemString(dw_1.getrow(),"bill_gu"))
	dw_list.SetItem(dw_list.getrow(),"bill_jigu",			dw_1.GetItemString(dw_1.getrow(),"bill_jigu"))
	dw_list.SetItem(dw_list.getrow(),"status",				dw_1.GetItemString(dw_1.getrow(),"status"))
	dw_list.SetItem(dw_list.getrow(),"bill_ntinc",			dw_1.GetItemString(dw_1.getrow(),"bill_ntinc"))
	dw_list.SetItem(dw_list.getrow(),"bill_change_date",	dw_1.GetItemString(dw_1.getrow(),"bill_change_date"))
	
//	dw_list.SetItem(dw_list.getrow(),"remark1",				)
	dw_list.SetItem(dw_list.getrow(),"owner_saupj",			dw_1.GetItemString(dw_1.getrow(),"owner_saupj"))
	dw_list.SetItem(dw_list.getrow(),"alc_gu",				dw_1.GetItemString(dw_1.getrow(),"alc_gu"))
	dw_list.SetItem(dw_list.getrow(),"acc_date",				dw_1.GetItemString(dw_1.getrow(),"acc_date"))
	IF dw_list.Update() = 1 THEN
		Return 1
	ELSE
		Return -1
	END IF
ELSEIF iRowCount = 1 THEN
	dw_list.SetItem(dw_list.getrow(),"saupj",					sSaupj)
	
	dw_list.SetItem(dw_list.getrow(),"saup_no",				dw_1.GetItemString(dw_1.getrow(),"saup_no"))
	dw_list.SetItem(dw_list.getrow(),"bnk_cd",				dw_1.GetItemString(dw_1.getrow(),"bnk_cd"))
	dw_list.SetItem(dw_list.getrow(),"bbal_dat",				dw_1.GetItemString(dw_1.getrow(),"bbal_dat"))
	dw_list.SetItem(dw_list.getrow(),"bman_dat",				dw_1.GetItemString(dw_1.getrow(),"bman_dat"))
	dw_list.SetItem(dw_list.getrow(),"bill_amt",				dw_1.GetItemNumber(dw_1.getrow(),"bill_amt"))
	dw_list.SetItem(dw_list.getrow(),"bill_nm",				dw_1.GetItemString(dw_1.getrow(),"bill_nm"))
	dw_list.SetItem(dw_list.getrow(),"bill_ris",				dw_1.GetItemString(dw_1.getrow(),"bill_ris"))
	dw_list.SetItem(dw_list.getrow(),"bill_gu",				dw_1.GetItemString(dw_1.getrow(),"bill_gu"))
	dw_list.SetItem(dw_list.getrow(),"bill_jigu",			dw_1.GetItemString(dw_1.getrow(),"bill_jigu"))
	dw_list.SetItem(dw_list.getrow(),"status",				dw_1.GetItemString(dw_1.getrow(),"status"))
	dw_list.SetItem(dw_list.getrow(),"bill_ntinc",			dw_1.GetItemString(dw_1.getrow(),"bill_ntinc"))
	dw_list.SetItem(dw_list.getrow(),"bill_change_date",	dw_1.GetItemString(dw_1.getrow(),"bill_change_date"))
	
	dw_list.SetItem(dw_list.getrow(),"owner_saupj",			dw_1.GetItemString(dw_1.getrow(),"owner_saupj"))
	dw_list.SetItem(dw_list.getrow(),"alc_gu",				dw_1.GetItemString(dw_1.getrow(),"alc_gu"))
	dw_list.SetItem(dw_list.getrow(),"acc_date",				dw_1.GetItemString(dw_1.getrow(),"acc_date"))
	
	IF dw_list.Update() = 1 THEN
		Return 1
	ELSE
		Return -1
	END IF
END IF

Return 1
end function

public subroutine wf_init ();String snull
Int il_rowcount,lnull

SetNull(snull)
SetNull(lnull)

dw_1.SetRedraw(False)

dw_1.Reset()
dw_1.InsertRow(0)

il_rowcount =dw_1.GetRow()

dw_1.SetItem(il_rowcount, "BBAL_DAT",    f_today())
dw_1.SetItem(il_rowcount, "BMAN_DAT",    f_today())
dw_1.SetItem(il_rowcount, "saupj",       gs_saupj)
dw_1.SetItem(il_rowcount, "owner_saupj", gs_saupj)

//IF F_Authority_Fund_Chk(Gs_Dept)	 = -1 THEN							/*권한 체크- 현업 여부*/	
//	dw_1.Modify("from_saupj.protect = 1")
//	dw_1.Modify("from_saupj.background.color ='"+String(RGB(192,192,192))+"'")
//ELSE
//	dw_1.Modify("from_saupj.protect = 0")
//	dw_1.Modify("from_saupj.background.color ='"+String(RGB(190,225,184))+"'")
//END IF	

dw_1.SetItem(il_rowcount, "alc_gu", 'Y')

dw_1.SetColumn("bill_no")
dw_1.SetFocus()

dw_1.SetRedraw(True)

ib_any_typing =False
smodstatus ="M"
wf_setting_retrievemode(smodstatus)

dw_list.Reset()
end subroutine

event open;call super::open;
dw_1.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)
dw_2.settransobject(sqlca)

dw_2.sharedata(dw_1)
dw_2.retrieve()

IF dw_2.RowCount() <=0 then
	Wf_Init()
	smodstatus ="I"
else
	smodstatus ="M"
end if

wf_setting_retrievemode(smodstatus)



end event

on w_kfia02.create
int iCurrent
call super::create
this.gb_5=create gb_5
this.dw_1=create dw_1
this.p_1=create p_1
this.p_2=create p_2
this.dw_2=create dw_2
this.rr_2=create rr_2
this.dw_list=create dw_list
this.st_2=create st_2
this.sle_1=create sle_1
this.rr_1=create rr_1
this.rr_3=create rr_3
this.ln_1=create ln_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_5
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.p_1
this.Control[iCurrent+4]=this.p_2
this.Control[iCurrent+5]=this.dw_2
this.Control[iCurrent+6]=this.rr_2
this.Control[iCurrent+7]=this.dw_list
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.sle_1
this.Control[iCurrent+10]=this.rr_1
this.Control[iCurrent+11]=this.rr_3
this.Control[iCurrent+12]=this.ln_1
end on

on w_kfia02.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_5)
destroy(this.dw_1)
destroy(this.p_1)
destroy(this.p_2)
destroy(this.dw_2)
destroy(this.rr_2)
destroy(this.dw_list)
destroy(this.st_2)
destroy(this.sle_1)
destroy(this.rr_1)
destroy(this.rr_3)
destroy(this.ln_1)
end on

event key;GraphicObject which_control
string ls_string,scode, sname
long iRow

which_control = getfocus()

if  TypeOf(which_control)=SingleLineEdit! then
   if sle_1 = which_control then
    
	  Choose Case key
		Case KeyEnter!	
	       ls_string =trim(sle_1.text)
	      if isNull(ls_string) or ls_string="" then return
	       
		   If Len(ls_string) > 0 Then
				Choose Case Asc(ls_string)
				//숫자 - 코드
				Case is < 127
          
				 scode = ls_string+"%"
							
//				//문자 - 명칭
				Case is >= 127
				 scode =  "%"+ls_string+"%"
				End Choose
			End If	
			
  			
        iRow = dw_2.Find("kfm02ot0_bill_no like '" + scode +"'",1,dw_2.RowCount())
		  
		  if iRow>0 then
		     
	     else
	        iRow = dw_2.Find("kfm02ot0_saup_no like '" + scode +"'",1,dw_2.RowCount())
			 if iRow>0 then
		
		    else	

		     iRow = dw_2.Find("kfz04om0_person_nm like '" + scode +"'",1,dw_2.RowCount())
		    if iRow>0 then
			 end if 
			  
		    end if
	     end if			 

        
		  
		  
		  if iRow > 0 then
         	dw_2.ScrollToRow(iRow)
	         dw_2.SelectRow(iRow,True)
		  else 
		      MessageBox('어음번호선택',"선택하신 자료가 없습니다. 다시 선택하신후 작업하세요")  
	     end if	
		   
		 //dw_2.setFocus()
		 sle_1.text=""
	  End Choose
   end if
else
	Choose Case key
	Case KeyW!
		p_print.TriggerEvent(Clicked!)
	Case KeyQ!
		p_inq.TriggerEvent(Clicked!)
	Case KeyT!
		p_ins.TriggerEvent(Clicked!)
	Case KeyA!
		p_addrow.TriggerEvent(Clicked!)
	Case KeyE!
		p_delrow.TriggerEvent(Clicked!)
	Case KeyS!
		p_mod.TriggerEvent(Clicked!)
	Case KeyD!
		p_del.TriggerEvent(Clicked!)
	Case KeyC!
		p_can.TriggerEvent(Clicked!)
	Case KeyX!
		p_exit.TriggerEvent(Clicked!)
End Choose
	
end if
end event

type dw_insert from w_inherite`dw_insert within w_kfia02
boolean visible = false
integer x = 69
integer y = 2672
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kfia02
boolean visible = false
integer x = 3035
integer y = 28
end type

type p_addrow from w_inherite`p_addrow within w_kfia02
boolean visible = false
integer x = 2862
integer y = 28
end type

type p_search from w_inherite`p_search within w_kfia02
boolean visible = false
integer x = 3511
integer y = 3068
end type

type p_ins from w_inherite`p_ins within w_kfia02
integer x = 3749
end type

event p_ins::clicked;integer icurrow

iCurRow = dw_1.InsertRow(0)

dw_1.ScrollToRow(iCurRow)
	
dw_1.SetFocus()

dw_2.SelectRow(0,False)
dw_2.SelectRow(iCurRow,True)

dw_2.ScrollToRow(iCurRow)

dw_1.SetItem(iCurRow, "BBAL_DAT",    f_today())
dw_1.SetItem(iCurRow, "BMAN_DAT",    f_today())
dw_1.SetItem(iCurRow, "saupj",       gs_saupj)
dw_1.SetItem(iCurRow, "owner_saupj", gs_saupj)

//p_ins.Enabled = False
//p_ins.PictureName = "C:\erpman\image\추가_d.gif"

sModStatus = 'I'


end event

type p_exit from w_inherite`p_exit within w_kfia02
end type

type p_can from w_inherite`p_can within w_kfia02
end type

event p_can::clicked;call super::clicked;dw_2.retrieve()

IF dw_2.RowCount() <=0 then
	Wf_Init()
	smodstatus ="I"
else
	smodstatus ="M"
end if

wf_setting_retrievemode(smodstatus)

p_ins.Enabled =True
p_ins.PictureName = "C:\erpman\image\추가_up.gif"

ib_any_typing = False

end event

type p_print from w_inherite`p_print within w_kfia02
boolean visible = false
integer x = 3685
integer y = 3068
end type

type p_inq from w_inherite`p_inq within w_kfia02
integer x = 3575
end type

event p_inq::clicked;call super::clicked;String sbill_no,acc1,acc2,get_acc_nm

w_mdi_frame.sle_msg.text =""

dw_1.AcceptText()
sbill_no =dw_1.GetItemString(dw_1.GetRow(),"bill_no")
IF sBill_No = "" OR IsNull(sBill_No) THEN
	F_MessageChk(1,'[어음번호]')
	dw_1.SetColumn("bill_no")
	dw_1.SetFocus()
	Return 
END IF

dw_1.SetRedraw(False)
IF dw_1.Retrieve(sbill_no) <= 0 THEN
	WF_INIT()
	f_messagechk(14,'') 
	Return
END IF
dw_1.SetRedraw(True)
dw_list.Retrieve(sBill_no)

smodstatus ="M"
ib_any_typing =False
wf_setting_retrievemode(smodstatus)

end event

type p_del from w_inherite`p_del within w_kfia02
end type

event p_del::clicked;call super::clicked;String  sbill_no
Integer icnt

String syear

w_mdi_frame.sle_msg.text =""

dw_1.AcceptText()
sbill_no =dw_1.GetItemString(dw_1.getrow(),"bill_no")

select Count(*) into :iCnt		from kfz12ot0 where kwan_no = :sBill_No;
if sqlca.sqlcode = 0 and icnt <> 0 then
	F_MessageChk(20017,'[전표에 사용]')
	Return
end if

IF f_dbconfirm("삭제") = 2 THEN RETURN

dw_1.SetRedraw(False)
dw_1.DeleteRow(0)
IF dw_1.Update() = 1 THEN
	
	delete from kfz12otd where bill_no = :sBill_No;
	
	COMMIT;
	w_mdi_frame.sle_msg.text ="자료가 삭제되었습니다.!!!"	
ELSE
	f_messagechk(12,'')
	ROLLBACK;
	Return
END IF
ib_any_typing = False
dw_2.retrieve()
IF dw_2.RowCount() <=0 then
	Wf_Init()
	smodstatus ="I"
else
	smodstatus ="M"
end if

wf_setting_retrievemode(smodstatus)

dw_2.SelectRow(0, FALSE)
dw_2.SelectRow(dw_2.GetRow(),TRUE)


end event

type p_mod from w_inherite`p_mod within w_kfia02
end type

event p_mod::clicked;call super::clicked;
String sbill_no,ssql

w_mdi_frame.sle_msg.text =""

IF dw_1.AcceptText() = -1 then return 

sbill_no = dw_1.GetItemString(dw_1.GetRow(),"bill_no")

IF dw_1.GetRow() <=0 THEN Return

IF Wf_RequiredChk(dw_1.GetRow()) = -1 THEN Return

//KFM02OM0(받을어음) 검색//
IF smodstatus="M" THEN
ELSE		
	SELECT "KFM02OT0"."BILL_NO"  
    	INTO :ssql  
    	FROM "KFM02OT0"  
   	WHERE "KFM02OT0"."BILL_NO" = :sbill_no   ;

	IF SQLCA.SQLCODE =0 THEN
		f_messagechk(10,"")
		Return
	END IF
END IF

IF f_dbconfirm("저장") = 2 THEN RETURN

IF dw_1.Update() = 1 THEN
	
	IF Wf_Insert_Kfz12otd() = -1 THEN
		F_MessageChk(13,'[받을어음 이력]')
		Rollback;
		Return
	END IF
	COMMIT;
	
	p_ins.Enabled =True
	p_ins.PictureName = "C:\erpman\image\추가_up.gif"
ELSE
	f_messagechk(13,"") 
	ROLLBACK;
	RETURN
END IF
ib_any_typing = False

dw_2.retrieve()
IF dw_2.RowCount() <=0 then
	Wf_Init()
	smodstatus ="I"
else
	smodstatus ="M"
end if

wf_setting_retrievemode(smodstatus)

dw_2.SelectRow(0, FALSE)
dw_2.SelectRow(dw_2.GetRow(),TRUE)








end event

type cb_exit from w_inherite`cb_exit within w_kfia02
boolean visible = false
integer x = 3022
integer y = 2516
integer width = 293
integer taborder = 60
end type

type cb_mod from w_inherite`cb_mod within w_kfia02
event ue_chusim_setting pbm_custom01
event ue_budo_setting pbm_custom02
event ue_bsaup_setting pbm_custom03
boolean visible = false
integer x = 2048
integer y = 2516
integer width = 293
integer taborder = 20
end type

event cb_mod::clicked;call super::clicked;
String sbill_no,ssql

sle_msg.text =""

IF dw_1.AcceptText() = -1 then return 

sbill_no = dw_1.GetItemString(dw_1.GetRow(),"bill_no")

IF dw_1.GetRow() <=0 THEN Return

IF Wf_RequiredChk(dw_1.GetRow()) = -1 THEN Return

//KFM02OM0(받을어음) 검색//
IF smodstatus="M" THEN
ELSE		
	SELECT "KFM02OT0"."BILL_NO"  
    	INTO :ssql  
    	FROM "KFM02OT0"  
   	WHERE "KFM02OT0"."BILL_NO" = :sbill_no   ;

	IF SQLCA.SQLCODE =0 THEN
		f_messagechk(10,"")
		Return
	END IF
END IF

IF f_dbconfirm("저장") = 2 THEN RETURN

IF dw_1.Update() = 1 THEN
	
	IF Wf_Insert_Kfz12otd() = -1 THEN
		F_MessageChk(13,'[받을어음 이력]')
		Rollback;
		Return
	END IF
	COMMIT;
	WF_INIT()
	sle_msg.text ="자료가 저장되었습니다.!!!"	
	
ELSE
	f_messagechk(13,"") 
	ROLLBACK;
	RETURN
END IF







end event

type cb_ins from w_inherite`cb_ins within w_kfia02
event uevent_enabled pbm_custom01
event uevent_chusim pbm_custom02
event uevent_budo pbm_custom03
event uevent_bsaup pbm_custom04
boolean visible = false
integer x = 1879
integer y = 2532
integer width = 293
end type

event cb_ins::uevent_enabled;call super::uevent_enabled;//String ls_billno,ls_bal_bil,ls_man_bil,ls_saup,ls_bnk,get_bill,get_saup,get_bnk,ls_jigu,ls_saupnm
//String bil_year,bil_mon,bil_day,man_year,man_mon,man_day,ls_alc,ls_bil_gu,bil_nm,ls_saupj
//Double amt
//dw_1.AcceptText()
//
//ls_billno =dw_1.GetItemString(dw_1.GetRow(),"bill_no")
//ls_saup =dw_1.GetItemString(dw_1.GetRow(),"saup_no")
//ls_bnk =dw_1.GetItemString(dw_1.GetRow(),"bnk_cd")
//bil_year =dw_1.GetItemString(dw_1.GetRow(),"bbal_yy")
//bil_mon =dw_1.GetItemString(dw_1.GetRow(),"bbal_mm")
//bil_day =dw_1.GetItemString(dw_1.GetRow(),"bbal_dd")
//man_year =dw_1.GetItemString(dw_1.GetRow(),"bman_yy")
//man_mon =dw_1.GetItemString(dw_1.GetRow(),"bman_mm")
//man_day =dw_1.GetItemString(dw_1.GetRow(),"bman_dd")
//bil_nm =dw_1.GetItemString(dw_1.GetRow(),"bill_nm")
//ls_bil_gu =dw_1.GetItemString(dw_1.GetRow(),"bill_gu")
//ls_jigu =dw_1.GetItemString(dw_1.GetRow(),"bill_jigu")
//amt =dw_1.GetItemNumber(dw_1.GetRow(),"bill_amt")
//ls_saupj =dw_1.GetItemString(dw_1.GetRow(),"saupj")
//ls_alc =dw_1.GetItemString(dw_1.GetRow(),"alc_gu")
//
//IF ls_saup="" OR IsNull(ls_saup) THEN
//	MessageBox("확 인","거래처를 입력하세요.!!!")
//	dw_1.SetColumn("saup_no")
//	dw_1.SetFocus()
//	cntflag =False
//	Return
//ELSE
//	 SELECT "VNDMST"."CVNAS"  
//    	INTO :ls_saupnm  
//    	FROM "VNDMST"  
//   	WHERE (( "VNDMST"."CVGU" = '3' ) OR  
//         	( "VNDMST"."CVGU" = '4' )) AND  
//         	( "VNDMST"."CVCOD" = :ls_saup )   ;
//	IF SQLCA.SQLCODE <> 0 THEN
//		MessageBox("확 인","매출처가 아닙니다.매출처를 입력하세요.!!!")
//		cntflag =False
//		dw_1.SetColumn("saup_no")
//		dw_1.SetFocus()
//		Return	
//	END IF
//END IF
//
//IF ls_bnk="" OR IsNull(ls_bnk) THEN
//	MessageBox("확 인","지급은행를 입력하세요.!!!")
//	cntflag =False
//	dw_1.SetColumn("bnk_cd")
//	dw_1.SetFocus()
//	Return
//END IF
//
//ls_bal_bil =bil_year+"/"+bil_mon+"/"+bil_day
//ls_man_bil =man_year+"/"+man_mon+"/"+man_day
//
//IF amt=0 OR IsNull(amt) THEN
//	MessageBox("확  인","어음금액을 입력하세요.!!!")
//	cntflag =False
//	dw_1.SetColumn("bill_amt")
//	dw_1.SetFocus()
//	Return
//END IF
//
//IF ls_bal_bil ="" OR IsNull(ls_bal_bil) THEN
//	MessageBox("확  인","어음 발행 일자를 입력하세요.!!!")
//	cntflag =False
//	dw_1.SetColumn("bbal_yy")
//	dw_1.SetFocus()
//	Return
//ELSE
//	IF IsDate(ls_bal_bil) THEN
//	ELSE
//		MessageBox("확  인","어음 발행 일자를 확인하세요.!!!")
//		cntflag =False
//		dw_1.SetColumn("bbal_yy")
//		dw_1.SetFocus()
//		Return
//	END IF
//END IF
//
//IF ls_man_bil ="" OR IsNull(ls_man_bil) THEN
//	MessageBox("확  인","어음 만기 일자를 입력하세요.!!!")
//	cntflag =False
//	dw_1.SetColumn("bman_yy")
//	dw_1.SetFocus()
//	Return
//ELSE
//	IF IsDate(ls_man_bil) THEN
//	ELSE
//		MessageBox("확  인","어음 만기 일자를 확인하세요.!!!")
//		dw_1.SetColumn("bman_yy")
//		cntflag =False
//		dw_1.SetFocus()
//		Return
//	END IF
//END IF
//
//IF DaysAfter(Date(ls_bal_bil),Date(ls_man_bil)) <= 0 	THEN
//	MessageBox("확  인","만기일자가 발행일자보다 빠릅니다.확인하세요.!!!")
//	cntflag =False
//	dw_1.SetColumn("bman_yy")
//	dw_1.SetFocus()
//	Return
//END IF
//
//IF bil_nm ="" OR IsNull(bil_nm) THEN
//	MessageBox("확  인","발행인을 입력하세요.!!!")
//	cntflag =False
//	dw_1.SetColumn("bill_nm")
//	dw_1.SetFocus()
//	Return
//END IF
//
//IF IsNull(ls_bil_gu) OR ls_bil_gu ="" THEN
//	MessageBox("확  인","어음 구분을 입력하세요.!!!")
//	dw_1.SetColumn("bill_gu")
//	cntflag =False
//	dw_1.SetFocus()
//	Return
//ELSE
//	IF Integer(ls_bil_gu) > 3 THEN
//		MessageBox("확  인","어음 구분을 확인하세요.!!!")
//		cntflag =False
//		dw_1.SetColumn("bill_gu")
//		dw_1.SetFocus()
//		Return
//	END IF
//END IF
//
//IF ls_jigu ="" OR IsNull(ls_jigu) THEN
//	MessageBox("확  인","지급구분을 입력하세요.!!!")
//	cntflag =False
//	dw_1.SetColumn("bill_jigu")
//	dw_1.SetFocus()
//	Return
//END IF
//
//IF ls_saupj ="" OR IsNull(ls_saupj) THEN
//	MessageBox("확  인","사업장을 확인하세요.!!!")
//	dw_1.SetColumn("saupj")
//	cntflag =False
//	dw_1.SetFocus()
//	Return
//END IF
//
//IF ls_alc ="Y" OR ls_alc ="N" THEN
//ELSE
//	MessageBox("확  인","승인구분을 확인하세요.!!!")
//	cntflag =False
//	dw_1.SetColumn("alc_gu")
//	dw_1.SetFocus()
//	Return
//END IF
//
//
end event

event cb_ins::uevent_chusim;call super::uevent_chusim;//String ls_chu,ls_chu_bnk,ls_jigu
//
//dw_chusim.AcceptText()
//ls_chu =dw_chusim.GetItemString(dw_chusim.GetRow(),"chu_ymd")
//ls_chu_bnk =dw_chusim.GetItemString(dw_chusim.GetRow(),"chu_bnk")
//
//IF ls_chu ="" OR IsNull(ls_chu) THEN
//	MessageBox("확  인","추심일자를 입력하세요.!!!")
//	cntflag =False
//	dw_chusim.SetColumn("chu_ymd")
//	dw_chusim.SetFocus()
//	Return
//ELSE
//	ls_chu =Left(ls_chu,4)+"/"+Mid(ls_chu,5,2)+"/"+Right(ls_chu,2)
//	IF IsDate(ls_chu) THEN
//	ELSE
//		MessageBox("확  인","추심일자를 확인하세요.!!!")
//		cntflag =False
//		dw_chusim.SetColumn("chu_ymd")
//		dw_chusim.SetFocus()
//		Return
//	END IF
//END IF
//
//IF ls_chu_bnk ="" OR IsNull(ls_chu_bnk) THEN
//	MessageBox("확  인","추심은행을 입력하세요.!!!")
//	cntflag =False
//	dw_chusim.SetColumn("chu_bnk")
//	dw_chusim.SetFocus()
//	Return
//ELSE
//END IF
//
//dw_1.SetItem(dw_1.GetRow(),"chu_ymd",Left(ls_chu,4)+Mid(ls_chu,6,2)+Right(ls_chu,2))
//dw_1.SetItem(dw_1.GetRow(),"chu_bnk",ls_chu_bnk)
//
//	
end event

event cb_ins::uevent_budo;call super::uevent_budo;//Double budo_amt
//
//dw_budo.AcceptText()
//budo_amt =dw_budo.GetItemNumber(dw_budo.GetRow(),"budo_amt")
//
//IF budo_amt =0 OR IsNull(budo_amt) THEN
//	MessageBox("확  인","부도입금액을 입력하세요.!!!")
//	cntflag =False
//	dw_budo.SetColumn("budo_amt")
//	dw_budo.SetFocus()
//	Return
//END IF
//
//dw_1.SetItem(dw_1.GetRow(),"budo_amt",budo_amt)
//
end event

event cb_ins::uevent_bsaup;call super::uevent_bsaup;//String ls_saup
//
//dw_bsaup.AcceptText()
//
//ls_saup =dw_bsaup.GetItemString(dw_bsaup.GetRow(),"bill_ntinc")
//IF ls_saup ="" OR IsNull(ls_saup) THEN
//	MessageBox("확  인","변동거래처를 입력하세요.!!!")
//	cntflag =False
//	dw_bsaup.SetColumn("bill_ntinc")
//	dw_bsaup.SetFocus()
//	Return
//END IF
//dw_1.SetItem(dw_1.GetRow(),"bill_ntinc",ls_saup)
end event

event cb_ins::clicked;call super::clicked;wf_init()
end event

type cb_del from w_inherite`cb_del within w_kfia02
boolean visible = false
integer x = 2373
integer y = 2516
integer width = 293
integer taborder = 30
end type

event cb_del::clicked;call super::clicked;String  sbill_no
Integer icnt

String syear

sle_msg.text =""

dw_1.AcceptText()
sbill_no =dw_1.GetItemString(1,"bill_no")

select Count(*) into :iCnt		from kfz12ot0 where kwan_no = :sBill_No;
if sqlca.sqlcode = 0 and icnt <> 0 then
	F_MessageChk(20017,'[전표에 사용]')
	Return
end if

IF f_dbconfirm("삭제") = 2 THEN RETURN

dw_1.SetRedraw(False)
dw_1.DeleteRow(0)
IF dw_1.Update() = 1 THEN
	
	delete from kfz12otd where bill_no = :sBill_No;
	
	COMMIT;
	WF_INIT()
	sle_msg.text ="자료가 삭제되었습니다.!!!"	
ELSE
	f_messagechk(12,'')
	ROLLBACK;
END IF
end event

type cb_inq from w_inherite`cb_inq within w_kfia02
boolean visible = false
integer x = 41
integer y = 2516
integer width = 293
end type

event cb_inq::clicked;call super::clicked;String sbill_no,acc1,acc2,get_acc_nm

sle_msg.text =""

dw_1.AcceptText()
sbill_no =dw_1.GetItemString(dw_1.GetRow(),"bill_no")
IF sBill_No = "" OR IsNull(sBill_No) THEN
	F_MessageChk(1,'[어음번호]')
	dw_1.SetColumn("bill_no")
	dw_1.SetFocus()
	Return 
END IF

dw_1.SetRedraw(False)
IF dw_1.Retrieve(sbill_no) <= 0 THEN
	WF_INIT()
	f_messagechk(14,'') 
	Return
END IF
dw_1.SetRedraw(True)
dw_list.Retrieve(sBill_no)

smodstatus ="M"
ib_any_typing =False
wf_setting_retrievemode(smodstatus)

end event

type cb_print from w_inherite`cb_print within w_kfia02
boolean visible = false
integer x = 2633
integer y = 2528
integer width = 293
end type

type st_1 from w_inherite`st_1 within w_kfia02
integer width = 311
end type

type cb_can from w_inherite`cb_can within w_kfia02
boolean visible = false
integer x = 2697
integer y = 2516
integer width = 293
integer taborder = 40
end type

event cb_can::clicked;call super::clicked;wf_init()
end event

type cb_search from w_inherite`cb_search within w_kfia02
boolean visible = false
integer x = 2190
integer y = 2528
integer width = 425
end type

event cb_search::clicked;call super::clicked;Open(w_kfia02a)
IF smodstatus ="M" THEN
	cb_ins.Enabled =False
ELSE
	cb_ins.Enabled =True
END IF

dw_1.SetFocus()
end event

type dw_datetime from w_inherite`dw_datetime within w_kfia02
boolean visible = false
integer x = 2853
integer width = 745
end type

type sle_msg from w_inherite`sle_msg within w_kfia02
boolean visible = false
integer x = 347
integer width = 2505
end type

type gb_10 from w_inherite`gb_10 within w_kfia02
boolean visible = false
end type

type gb_button1 from w_inherite`gb_button1 within w_kfia02
boolean visible = false
integer x = 0
integer y = 2460
integer width = 379
end type

type gb_button2 from w_inherite`gb_button2 within w_kfia02
boolean visible = false
integer x = 2007
integer y = 2460
integer width = 1349
end type

type gb_5 from groupbox within w_kfia02
boolean visible = false
integer x = 2368
integer y = 28
integer width = 338
integer height = 164
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "자료선택"
end type

type dw_1 from u_key_enter within w_kfia02
event ue_key pbm_dwnkey
integer x = 2194
integer y = 192
integer width = 2441
integer height = 1436
integer taborder = 10
string dataobject = "d_kfia02"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) or keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;String   snull,ssql,ssano,scolvalue
Integer  lnull

SetNull(snull); SetNull(lnull);

IF this.GetColumnName() ="saup_no" THEN
	sColValue = this.GetText()
	if sColValue = '' or IsNull(sColValue) then 
		dw_1.SetItem(row,"person_nm",snull)
		Return
	end if
	
	SELECT "KFZ04OM0"."PERSON_NM"  
   	INTO :ssql  
   	FROM "KFZ04OM0"  
   	WHERE ( "KFZ04OM0"."PERSON_CD" = :scolvalue ) AND  
      	   (( "KFZ04OM0"."PERSON_GU" = '1' ) OR ( "KFZ04OM0"."PERSON_GU" = '99' ))  ;
		
	IF SQLCA.SQLCODE <> 0 THEN
//		f_messagechk(20,"거래처")
		dw_1.SetItem(row,"saup_no",snull)
		dw_1.SetItem(row,"person_nm",snull)
		Return 
	ELSE
		dw_1.SetItem(row,"person_nm",ssql)
	END IF
END IF

IF this.GetColumnName() ="bill_ntinc" THEN
	sColValue = this.GetText()
	if sColValue = '' or IsNull(sColValue) then Return
	
	if dw_1.GetItemSTring(row,"status") = '4' then
		SELECT "KFZ04OM0"."PERSON_NM"  INTO :ssql  
			FROM "KFZ04OM0"  
			WHERE ( "KFZ04OM0"."PERSON_CD" = :scolvalue ) AND  
					(( "KFZ04OM0"."PERSON_GU" = '2' ) )  ;	
	else
		SELECT "KFZ04OM0"."PERSON_NM"  INTO :ssql  
			FROM "KFZ04OM0"  
			WHERE ( "KFZ04OM0"."PERSON_CD" = :scolvalue ) AND  
					(( "KFZ04OM0"."PERSON_GU" = '1' ) OR ( "KFZ04OM0"."PERSON_GU" = '99' ))  ;			
	end if
	IF SQLCA.SQLCODE <> 0 THEN
		f_messagechk(20,"변동거래처")
		dw_1.SetItem(row,"bill_ntinc",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="chu_bnk_1" THEN
	sColValue = this.GetText()
	if sColValue = '' or IsNull(sColValue) then Return
	
	SELECT "KFZ04OM0"."PERSON_NM"  INTO :ssql  
			FROM "KFZ04OM0"  
			WHERE ( "KFZ04OM0"."PERSON_CD" = :scolvalue ) AND  
					(( "KFZ04OM0"."PERSON_GU" = '2' ) )  ;	
	IF SQLCA.SQLCODE <> 0 THEN
		f_messagechk(20,"추심은행")
		dw_1.SetItem(row,"chu_bnk_1",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="bill_amt" THEN
	IF Double(this.GetText()) = 0 or IsNull(this.GetText()) THEN 
		sle_msg.text ="어음금액이 '0'입니다.!!"
		MessageBox("확 인","어음금액을 확인하세요.!!")
		dw_1.SetItem(row,"bill_amt",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="bill_gu" THEN
	sColValue = this.GetText()
	if sColValue = '' or IsNull(sColValue) then Return
	
	SELECT "REFFPF"."RFNA1"  
    	INTO :ssql  
    	FROM "REFFPF"  
   	WHERE ( "REFFPF"."RFCOD" = 'BJ' ) AND  
         	( "REFFPF"."RFGUB" = :scolvalue )   ;
	IF SQLCA.SQLCODE <> 0 THEN
		f_messagechk(20,"어음종류")
		dw_1.SetItem(row,"bill_gu",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="upmu_gu" THEN
	sColValue = this.GetText()
	if sColValue = '' or IsNull(sColValue) then Return
	
	SELECT "REFFPF"."RFNA1"  
    	INTO :ssql  
    	FROM "REFFPF"  
   	WHERE ( "REFFPF"."RFCOD" = 'AG' ) AND  
         	( "REFFPF"."RFGUB" = :scolvalue )   ;
	IF SQLCA.SQLCODE <> 0 THEN
		f_messagechk(20,"전표구분")
		dw_1.SetItem(row,"upmu_gu",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="bill_jigu" THEN
	sColValue = this.GetText()
	if sColValue = '' or IsNull(sColValue) then Return
	
	SELECT "REFFPF"."RFNA1"  
    	INTO :ssql  
    	FROM "REFFPF"  
   	WHERE ( "REFFPF"."RFCOD" = 'BG' ) AND  
         	( "REFFPF"."RFGUB" = :scolvalue )   ;
	IF SQLCA.SQLCODE <> 0 THEN
		f_messagechk(20,"어음구분") 
		dw_1.SetItem(row,"bill_jigu",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="status" THEN
	sColValue = this.GetText()
	if sColValue = '' or IsNull(sColValue) then Return
	
	SELECT "REFFPF"."RFNA1"  
    	INTO :ssql  
    	FROM "REFFPF"  
   	WHERE ( "REFFPF"."RFCOD" = 'AS' ) AND  
         	( "REFFPF"."RFGUB" = :scolvalue )   ;
	IF SQLCA.SQLCODE <> 0 THEN
		f_messagechk(20,"어음상태")
		dw_1.SetItem(row,"status",snull)
		Return 1
	END IF
END IF

//어음발행일자//
IF this.GetColumnName() ="bbal_dat" THEN
	sColValue = this.GetText()
	if sColValue = '' or IsNull(sColValue) then Return
	
	IF f_datechk(scolvalue) = -1 THEN 
		f_messagechk(20,"발행일자")
		dw_1.SetItem(row,"bbal_dat",snull)
		Return 1
	END IF
END IF

//어음만기일자//
IF this.GetColumnName() ="bman_dat" THEN
	sColValue = this.GetText()
	if sColValue = '' or IsNull(sColValue) then Return
	
	IF f_datechk(scolvalue) = -1 THEN 
		f_messagechk(20,"만기일자")
		dw_1.SetItem(row,"bman_dat",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="bill_change_date" THEN
	sColValue = this.GetText()
	if sColValue = '' or IsNull(sColValue) then Return
	
	IF f_datechk(scolvalue) = -1 THEN 
		f_messagechk(20,"변동일자일자")
		dw_1.SetItem(row,"bill_change_date",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="chu_ymd" THEN
	sColValue = this.GetText()
	if sColValue = '' or IsNull(sColValue) then Return
	
	IF f_datechk(scolvalue) = -1 THEN 
		f_messagechk(20,"추심일자")
		dw_1.SetItem(row,"chu_ymd",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="acc_date" THEN
	sColValue = this.GetText()
	if sColValue = '' or IsNull(sColValue) then Return
	
	IF f_datechk(scolvalue) = -1 THEN 
		f_messagechk(20,"회계일자")
		dw_1.SetItem(row,"acc_date",snull)
		Return 1
	else
		dw_1.SetItem(row,"bal_date", sColValue)
	END IF
END IF

IF this.GetColumnName() ="bal_date" THEN
	sColValue = this.GetText()
	if sColValue = '' or IsNull(sColValue) then Return
	
	IF f_datechk(scolvalue) = -1 THEN 
		f_messagechk(20,"작성일자")
		dw_1.SetItem(row,"bal_date",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="alc_gu" THEN
	sColValue = this.GetText()
	if sColValue = '' or IsNull(sColValue) then Return
	
	IF scolvalue <> "Y" AND scolvalue <> "N" THEN
		f_messagechk(20,"승인구분")
		dw_1.SetItem(row,"alc_gu",snull)
		dw_1.SetColumn("alc_gu")
		Return 1
	END IF
END IF

IF this.GetColumnName() ="saupj" THEN
	sColValue = this.GetText()
	if sColValue = '' or IsNull(sColValue) then Return
	
	IF scolvalue = "99" THEN
		f_messagechk(20,"사업장")
		dw_1.SetItem(row,"saupj",snull)
		dw_1.SetColumn("saupj")
		Return 1
	ELSE
		IF IsNull(F_Get_Refferance('AD',sColValue)) THEN
			f_messagechk(20,"사업장")
			dw_1.SetItem(row,"saupj",snull)
			dw_1.SetColumn("saupj")
			Return 1
		END IF
		dw_1.SetItem(row,"owner_saupj",sColValue)
	END IF
END IF
end event

event itemerror;
Return 1
end event

event rbuttondown;String snull,sBillGbn

SetNull(snull)
SetNull(gs_code)
SetNull(gs_codename)

this.accepttext()

//IF this.GetColumnName() ="bill_no" THEN
//	gs_code =Trim(dw_1.GetItemString(dw_1.GetRow(),"bill_no"))
//	IF IsNull(gs_code) THEN gs_code =""
//	
//	OPEN(W_KFM02OT0_POPUP)
//	
//	IF Not IsNull(gs_code) THEN
//		IF dw_1.Retrieve(gs_code) <=0 THEN
//		ELSE
//			dw_list.Retrieve(Gs_Code)
//			
//			smodstatus ="M"
//			WF_SETTING_RETRIEVEMODE(smodstatus)
//		END IF
//	END IF
//	Return
//END IF

IF this.GetColumnName() ="saup_no" THEN
	
	SetNull(lstr_custom.code)
	SetNull(lstr_custom.name)

	lstr_custom.code = this.GetItemString(this.GetRow(),"saup_no")
	
	IF IsNull(lstr_custom.code) THEN lstr_custom.code = ""
	
	OpenWithParm(W_KFZ04OM0_POPUP,'1')
	
	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
	
	this.SetItem(this.GetRow(),"saup_no",lstr_custom.code)
	this.SetItem(this.GetRow(),"person_nm", lstr_custom.name)
END IF

IF this.GetColumnName() ="bill_ntinc" THEN

	sBillGbn = this.GetItemString(this.GetRow(),"status")
	IF sBillGbn = "" OR IsNull(sBillGbn) THEN Return
	
	SetNull(lstr_custom.code)
	SetNull(lstr_custom.name)

	lstr_custom.code = this.GetItemString(this.GetRow(),"bill_ntinc")
	
	IF IsNull(lstr_custom.code) THEN
		lstr_custom.code = ""
	END IF
	
	IF sBillGbn = '4' THEN											/*할인*/
		OpenWithParm(W_KFZ04OM0_POPUP,'2')
	ELSEif sBillGbn = '5' THEN	
		OpenWithParm(W_KFZ04OM0_POPUP,'1')
	END	IF
	
	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
	
	this.SetItem(this.GetRow(),"bill_ntinc",lstr_custom.code)
END IF

IF this.GetColumnName() ="chu_bnk_1" THEN

	SetNull(lstr_custom.code)
	SetNull(lstr_custom.name)

	lstr_custom.code = this.object.chu_bnk[this.getrow()]
	
	IF IsNull(lstr_custom.code) THEN
		lstr_custom.code = ""
	END IF
	
	OpenWithParm(W_KFZ04OM0_POPUP,'2')
	
	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
	
	this.SetItem(this.GetRow(),"chu_bnk",lstr_custom.code)
END IF


end event

event editchanged;ib_any_typing =True
end event

event getfocus;this.AcceptText()
end event

event itemfocuschanged;call super::itemfocuschanged;
Long wnd

wnd =Handle(this)

IF dwo.name ="bnk_cd" OR dwo.name ="bill_nm" OR dwo.name ="bill_ris" THEN
	f_toggle_kor(wnd)
ELSE
	f_toggle_eng(wnd)
END IF
end event

type p_1 from picture within w_kfia02
boolean visible = false
integer x = 2423
integer y = 104
integer width = 55
integer height = 48
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\erpman\image\prior.gif"
boolean focusrectangle = false
end type

event clicked;String sBillNo,sGetBillNo

dw_1.AcceptText()
IF ib_any_typing = True THEN
	MessageBox("확 인","저장하지 않은 자료가 존재합니다!!")
	Return
END IF

sBillNo = dw_1.GetItemString(dw_1.GetRow(),"bill_no")

SELECT MAX("KFM02OT0"."BILL_NO")  	INTO :sGetBillNo
   FROM "KFM02OT0"
	WHERE "KFM02OT0"."BILL_NO" < :sBillNo ;
IF SQLCA.SQLCODE <> 0 THEN
	MessageBox('확 인','더이상 자료가 없습니다.')
	Return
ELSE
	If IsNull(sGetBillNo) THEN
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	END IF
	
	dw_1.SetItem(dw_1.GetRow(),"bill_no",sGetBillNo)
	
	cb_inq.TriggerEvent(Clicked!)
END IF
	
end event

type p_2 from picture within w_kfia02
boolean visible = false
integer x = 2587
integer y = 104
integer width = 55
integer height = 48
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\erpman\image\next.gif"
boolean focusrectangle = false
end type

event clicked;String sBillNo,sGetBillNo

dw_1.AcceptText()
IF ib_any_typing = True THEN
	MessageBox("확 인","저장하지 않은 자료가 존재합니다!!")
	Return
END IF

sBillNo = dw_1.GetItemString(dw_1.GetRow(),"bill_no")

SELECT MIN("KFM02OT0"."BILL_NO")  	INTO :sGetBillNo
   FROM "KFM02OT0"
	WHERE "KFM02OT0"."BILL_NO" > :sBillNo;
IF SQLCA.SQLCODE <> 0 THEN
	MessageBox('확 인','더이상 자료가 없습니다.')
	Return
ELSE
	If IsNull(sGetBillNo) THEN
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	END IF
	
	dw_1.SetItem(dw_1.GetRow(),"bill_no",sGetBillNo)
	
	cb_inq.TriggerEvent(Clicked!)
END IF
	
end event

type dw_2 from u_d_popup_sort within w_kfia02
integer x = 55
integer y = 200
integer width = 2112
integer height = 2012
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_kfia022"
boolean vscrollbar = true
boolean border = false
end type

event clicked;call super::clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	dw_1.ScrollToRow(row)
	
//	Lb_AutoFlag = False
	
	b_flag = False
	
	dw_list.retrieve(dw_1.object.bill_no[row])
	
//	smodstatus="M"
//	wf_setting_retrievemode(smodstatus)
END IF

CALL SUPER ::CLICKED


end event

event rowfocuschanged;call super::rowfocuschanged;If currentrow <= 0 then
	dw_1.SelectRow(0,False)

ELSE

	SelectRow(0, FALSE)
	SelectRow(currentrow,TRUE)
	
	dw_1.ScrollToRow(currentrow)
	
	dw_list.retrieve(dw_1.object.bill_no[currentrow])
END IF
end event

type rr_2 from roundrectangle within w_kfia02
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 192
integer width = 2139
integer height = 2032
integer cornerheight = 40
integer cornerwidth = 46
end type

type dw_list from datawindow within w_kfia02
integer x = 2199
integer y = 1636
integer width = 2409
integer height = 580
boolean bringtotop = true
string dataobject = "d_kfia021"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_kfia02
integer x = 73
integer y = 92
integer width = 366
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "어음조회"
boolean focusrectangle = false
end type

type sle_1 from singlelineedit within w_kfia02
integer x = 379
integer y = 84
integer width = 567
integer height = 64
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
boolean border = false
textcase textcase = upper!
end type

type rr_1 from roundrectangle within w_kfia02
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2190
integer y = 1628
integer width = 2432
integer height = 596
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_3 from roundrectangle within w_kfia02
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 46
integer y = 36
integer width = 987
integer height = 148
integer cornerheight = 40
integer cornerwidth = 46
end type

type ln_1 from line within w_kfia02
integer linethickness = 1
integer beginx = 384
integer beginy = 156
integer endx = 946
integer endy = 156
end type

