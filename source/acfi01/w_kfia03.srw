$PBExportHeader$w_kfia03.srw
$PBExportComments$지급어음 등록
forward
global type w_kfia03 from w_inherite
end type
type gb_5 from groupbox within w_kfia03
end type
type dw_2 from datawindow within w_kfia03
end type
type dw_1 from u_key_enter within w_kfia03
end type
type pb_2 from picturebutton within w_kfia03
end type
type pb_3 from picturebutton within w_kfia03
end type
type dw_list from datawindow within w_kfia03
end type
type dw_3 from u_d_popup_sort within w_kfia03
end type
type st_2 from statictext within w_kfia03
end type
type sle_1 from singlelineedit within w_kfia03
end type
type rr_1 from roundrectangle within w_kfia03
end type
type rr_2 from roundrectangle within w_kfia03
end type
type rr_3 from roundrectangle within w_kfia03
end type
type ln_1 from line within w_kfia03
end type
end forward

global type w_kfia03 from w_inherite
string title = "지급어음 등록"
boolean maxbox = true
gb_5 gb_5
dw_2 dw_2
dw_1 dw_1
pb_2 pb_2
pb_3 pb_3
dw_list dw_list
dw_3 dw_3
st_2 st_2
sle_1 sle_1
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
ln_1 ln_1
end type
global w_kfia03 w_kfia03

type variables

end variables

forward prototypes
public function integer wf_requiredchk (integer icurrow)
public subroutine wf_setting_retrievemode (string mode)
public subroutine wf_init ()
public function integer wf_insert_kfz12otc ()
end prototypes

public function integer wf_requiredchk (integer icurrow);String  sBillNo,sBalDate,sManDate,sBnkCd,sStatus,sGubn,sSaupj,sAccDate,sBal,sUpmugu
Double  dAmount
Long    lBJunNo
Integer iLinNo

dw_1.AcceptText()
sBillNo  = dw_1.GetItemString(iCurRow,"bill_no")
sBalDate = Trim(dw_1.GetItemString(iCurRow,"bbal_dat") )
sManDate = Trim(dw_1.GetItemString(iCurRow,"bman_dat"))
sBnkCd   = dw_1.GetItemString(iCurRow,"bnk_cd")
dAmount  = dw_1.GetItemNumber(iCurRow,"bill_amt") 
sStatus  = dw_1.GetItemString(iCurRow,"status")
sGubn    = dw_1.GetItemString(iCurRow,"alc_gu")

sSaupj   = dw_1.GetItemString(iCurRow,"saupj")
sAccDate = Trim(dw_1.GetItemString(iCurRow,"acc_date"))
sBal     = Trim(dw_1.GetItemString(iCurRow,"bal_date"))
sUpmugu  = dw_1.GetItemString(iCurRow,"upmu_gu")
lBJunNo  = dw_1.GetItemNumber(iCurRow,"bjun_no")
iLinNo   = dw_1.GetItemNumber(iCurRow,"lin_no")

IF sBillNo = "" OR IsNull(sBillNo) THEN 
	F_MessageChk(1,'[어음번호]')
	dw_1.SetColumn("bill_no")
	dw_1.SetFocus()
	Return -1
END IF
IF sBalDate = "" OR IsNull(sBalDate) THEN 
	F_MessageChk(1,'[발행일자]')
	dw_1.SetColumn("bbal_dat")
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
IF sStatus = "" OR IsNull(sStatus) THEN 
	F_MessageChk(1,'[어음상태]')
	dw_1.SetColumn("status")
	dw_1.SetFocus()
	Return -1
END IF
IF sGubn = "" OR IsNull(sGubn) THEN 
   F_MessageChk(1,'[승인구분]')
	dw_1.SetColumn("alc_gu")
	dw_1.SetFocus()
	Return -1
END IF
IF sSaupj = "" OR IsNull(sSaupj) THEN 
	F_MessageChk(1,'[사업장]')
	dw_1.SetColumn("saupj")
	dw_1.SetFocus()
	Return -1
ELSE
	dw_1.SetItem(1,"owner_saupj",sSaupj)
END IF
IF sAccDate = "" OR IsNull(sAccDate) THEN 
	F_MessageChk(1,'[회계일자]')
	dw_1.SetColumn("acc_date")
	dw_1.SetFocus()
	Return -1
END IF
IF sBal = "" OR IsNull(sBal) THEN 
	F_MessageChk(1,'[발행일자]')
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

IF lBJunNo = 0 OR IsNull(lBJunNo) THEN 
	F_MessageChk(1,'[전표번호]')
	dw_1.SetColumn("bjun_no")
	dw_1.SetFocus()
	Return -1
ELSE
	dw_1.SetItem(1,"jun_no",lBJunNo)
END IF

IF iLinNo = 0 OR IsNull(iLinNo) THEN 
	F_MessageChk(1,'[라인번호]')
	dw_1.SetColumn("lin_no")
	dw_1.SetFocus()
	Return -1
END IF

Return 1

end function

public subroutine wf_setting_retrievemode (string mode);dw_1.SetRedraw(False)
IF mode ="M" THEN
	dw_1.SetTabOrder("bill_no",0)
//	dw_1.Modify("bill_no.background.color = '"+String(Rgb(192,192,192))+"'")
	
	dw_1.SetColumn("saup_no")
	
	p_del.Enabled =True
	p_del.PictureName = "C:\erpman\image\삭제_up.gif"
ELSE
	dw_1.SetTabOrder("bill_no",10)
//	dw_1.Modify("bill_no.background.color = 65535")	
	
	dw_1.SetColumn("bill_no")
	
	p_del.Enabled =False
	p_del.PictureName = "C:\erpman\image\삭제_d.gif"
END IF
dw_1.SetFocus()
dw_1.SetRedraw(True)
end subroutine

public subroutine wf_init ();String snull,sOwner
Int il_rowcount,lnull

SetNull(snull)
SetNull(lnull)

dw_2.Reset()

dw_1.SetRedraw(False)

dw_1.Reset()
dw_1.InsertRow(0)

il_rowcount =dw_1.GetRow()

dw_1.SetItem(il_rowcount, "BBAL_DAT",   f_today())
dw_1.SetItem(il_rowcount, "BMAN_DAT",   f_today())
dw_1.SetItem(il_rowcount, "saupj",      gs_saupj)
dw_1.SetItem(il_rowcount,"owner_saupj", gs_saupj)

//IF F_Authority_Fund_Chk(Gs_Dept)	 = -1 THEN							/*권한 체크- 현업 여부*/	
//	dw_1.Modify("from_saupj.protect = 1")
//	dw_1.Modify("from_saupj.background.color ='"+String(RGB(192,192,192))+"'")
//ELSE
//	dw_1.Modify("from_saupj.protect = 0")
//	dw_1.Modify("from_saupj.background.color ='"+String(RGB(190,225,184))+"'")
//END IF	

/*발행인*/
SELECT substr("SYSCNFG"."DATANAME",1,20)  	INTO :sOwner  
	FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 1 ) AND  
         ( "SYSCNFG"."LINENO" = '80' )   ;			
dw_1.SetItem(il_rowcount, "bill_nm", sOwner)

dw_1.SetColumn("bill_no")
dw_1.SetFocus()

dw_1.SetRedraw(True)

ib_any_typing =False
smodstatus ="M"
wf_setting_retrievemode(smodstatus)

end subroutine

public function integer wf_insert_kfz12otc ();String sBillNo,sSaupj,sBalDate,sUpmuGu,sFullJunNo
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
		from kfz12otc
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
	dw_list.SetItem(dw_list.getrow(),"status",				dw_1.GetItemString(dw_1.getrow(),"status"))
	
//	dw_list.SetItem(dw_list.getrow(),"remark1",				)
	dw_list.SetItem(dw_list.getrow(),"owner_saupj",			sSaupj)
	dw_list.SetItem(dw_list.getrow(),"alc_gu",				dw_1.GetItemString(dw_1.getrow(),"alc_gu"))
	dw_list.SetItem(dw_list.getrow(),"acc_date",				dw_1.GetItemString(dw_1.getrow(),"acc_date"))
	dw_list.SetItem(dw_list.getrow(),"jun_no",				lJunNo)
	dw_list.SetItem(dw_list.getrow(),"remark1",				dw_1.GetItemString(dw_1.getrow(),"remark1"))
	dw_list.SetItem(dw_list.getrow(),"bill_gbn",				dw_1.GetItemString(dw_1.getrow(),"bill_gbn"))
	
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
	dw_list.SetItem(dw_list.getrow(),"status",				dw_1.GetItemString(dw_1.getrow(),"status"))
	
	dw_list.SetItem(dw_list.getrow(),"owner_saupj",			sSaupj)
	dw_list.SetItem(dw_list.getrow(),"alc_gu",				dw_1.GetItemString(dw_1.getrow(),"alc_gu"))
	dw_list.SetItem(dw_list.getrow(),"acc_date",				dw_1.GetItemString(dw_1.getrow(),"acc_date"))
	dw_list.SetItem(dw_list.getrow(),"jun_no",				lJunNo)
	dw_list.SetItem(dw_list.getrow(),"remark1",				dw_1.GetItemString(dw_1.getrow(),"remark1"))
	IF dw_list.Update() = 1 THEN
		Return 1
	ELSE
		Return -1
	END IF
END IF
Return 1
end function

event open;call super::open;
dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)

dw_3.settransobject(sqlca)
dw_3.sharedata(dw_1)
dw_3.retrieve()

IF dw_3.RowCount() <=0 then
	Wf_Init()
	smodstatus ="I"
else
	smodstatus ="M"
end if

wf_setting_retrievemode(smodstatus)

end event

on w_kfia03.create
int iCurrent
call super::create
this.gb_5=create gb_5
this.dw_2=create dw_2
this.dw_1=create dw_1
this.pb_2=create pb_2
this.pb_3=create pb_3
this.dw_list=create dw_list
this.dw_3=create dw_3
this.st_2=create st_2
this.sle_1=create sle_1
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
this.ln_1=create ln_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_5
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.pb_2
this.Control[iCurrent+5]=this.pb_3
this.Control[iCurrent+6]=this.dw_list
this.Control[iCurrent+7]=this.dw_3
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.sle_1
this.Control[iCurrent+10]=this.rr_1
this.Control[iCurrent+11]=this.rr_2
this.Control[iCurrent+12]=this.rr_3
this.Control[iCurrent+13]=this.ln_1
end on

on w_kfia03.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_5)
destroy(this.dw_2)
destroy(this.dw_1)
destroy(this.pb_2)
destroy(this.pb_3)
destroy(this.dw_list)
destroy(this.dw_3)
destroy(this.st_2)
destroy(this.sle_1)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
destroy(this.ln_1)
end on

event key;//Override

GraphicObject which_control
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
				  scode = "%"+ls_string+"%"
				End Choose
			
		    End If	
			
      
        iRow = dw_3.Find("kfm01ot0_bill_no like '" + scode +"'",1,dw_3.RowCount())
		  
		  if iRow>0 then
		     
	     else
	        iRow = dw_3.Find("kfm01ot0_saup_no like '" + scode +"'",1,dw_3.RowCount())
			 if iRow>0 then
		
		    else	

		     iRow = dw_3.Find("kfz04om0_person_nm like '" + scode +"'",1,dw_3.RowCount())
		    if iRow>0 then
			 end if 
			  
		    end if
	     end if			 

		 
		 
		  if iRow > 0 then
         	dw_3.ScrollToRow(iRow)
	         dw_3.SelectRow(iRow,True)
		  else 
		      MessageBox('어음번호선택',"선택하신 자료가 없습니다. 다시 선택하신후 작업하세요")  
	     end if	
		   
		 //dw_3.setFocus()
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

type dw_insert from w_inherite`dw_insert within w_kfia03
integer x = 494
integer y = 2732
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kfia03
boolean visible = false
integer x = 4197
integer y = 2776
end type

type p_addrow from w_inherite`p_addrow within w_kfia03
boolean visible = false
integer x = 4023
integer y = 2776
end type

type p_search from w_inherite`p_search within w_kfia03
boolean visible = false
integer x = 3328
integer y = 2776
end type

type p_ins from w_inherite`p_ins within w_kfia03
integer x = 3749
end type

event p_ins::clicked;call super::clicked;int    icurrow
String sOwner

iCurRow = dw_1.InsertRow(0)

dw_1.ScrollToRow(iCurRow)

dw_1.SetItem(iCurRow, "BBAL_DAT",   f_today())
dw_1.SetItem(iCurRow, "BMAN_DAT",   f_today())
dw_1.SetItem(iCurRow, "saupj",      gs_saupj)
dw_1.SetItem(iCurRow,"owner_saupj", gs_saupj)

//발행인
SELECT substr("SYSCNFG"."DATANAME",1,20)  	INTO :sOwner  
	FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 1 ) AND  
         ( "SYSCNFG"."LINENO" = '80' )   ;	

dw_1.SetItem(iCurRow, "bill_nm", sOwner)

dw_1.SetFocus()

dw_3.SelectRow(0,False)
dw_3.SelectRow(iCurRow,True)

dw_3.ScrollToRow(iCurRow)

p_ins.Enabled = False
p_ins.PictureName = "C:\erpman\image\추가_d.gif"

sModStatus = 'I'
wf_setting_retrievemode(smodstatus)


end event

type p_exit from w_inherite`p_exit within w_kfia03
end type

type p_can from w_inherite`p_can within w_kfia03
end type

event p_can::clicked;call super::clicked;
dw_3.retrieve()

IF dw_3.RowCount() <=0 then
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

type p_print from w_inherite`p_print within w_kfia03
boolean visible = false
integer x = 3502
integer y = 2776
end type

type p_inq from w_inherite`p_inq within w_kfia03
integer x = 3575
end type

event p_inq::clicked;call super::clicked;String sbill_no,acc1,acc2,get_acc_nm, sbal_date, sman_date 

w_mdi_frame.sle_msg.text =""

dw_1.AcceptText()
sbill_no =dw_1.GetItemString(dw_1.GetRow(),"bill_no")
sbal_date = dw_1.getitemstring(dw_1.getrow(), "bbal_dat")
sman_date = dw_1.getitemstring(dw_1.getrow(), "bman_dat")

IF sBill_No = "" OR IsNull(sBill_No) THEN 
	F_MessageChk(1,'[어음번호]')
	dw_1.SetColumn("bill_no")
	dw_1.SetFocus()
	Return -1
END IF

IF dw_1.Retrieve(sbill_no) <= 0 THEN
	WF_INIT()
	f_messagechk(14,'') 
	Return
ELSE
	dw_2.retrieve(sbill_no)
	
	smodstatus ="M"
	ib_any_typing =False
	wf_setting_retrievemode(smodstatus)
END IF

end event

type p_del from w_inherite`p_del within w_kfia03
end type

event p_del::clicked;call super::clicked;String sbill_no
Int lsql_cnt

String syear

w_mdi_frame.sle_msg.text =""

dw_1.AcceptText()

sbill_no =dw_1.GetItemString(dw_1.getrow(),"bill_no")

SELECT Count("KFZ12OT0"."KWAN_NO")  
	INTO :lsql_cnt  
   FROM "KFZ12OT0"  
   WHERE "KFZ12OT0"."SAUP_NO" = :sbill_no  ;
IF SQLCA.SQLCODE  = 0 AND lsql_cnt <> 0 THEN
	w_mdi_frame.sle_msg.text ="이 코드로 발행된 전표가 존재합니다.!!"
	MessageBox("확 인","삭제할 수 없는 자료입니다.!!")
	Return
ELSE
	SELECT "KFM01OT0"."BAL_YY"  
   	INTO :syear  
    	FROM "KFM01OT0"  
   	WHERE "KFM01OT0"."BILL_NO" = :sbill_no   ;
	IF SQLCA.SQLCODE = 0 THEN
		w_mdi_frame.sle_msg.text ="이 코드로 발행된 전표가 존재합니다.!!"
		MessageBox("확 인","삭제할 수 없는 자료입니다.!!")
		Return
	END IF
END IF

IF f_dbconfirm("삭제") = 2 THEN RETURN

dw_1.SetRedraw(False)
dw_1.DeleteRow(0)

IF dw_1.Update() = 1 THEN
	
	delete from kfz12otc where bill_no = :sBill_No;	
	
	COMMIT;
	dw_1.SetRedraw(True)	
	w_mdi_frame.sle_msg.text ="자료가 삭제되었습니다.!!!"	
ELSE
	f_messagechk(12,'')
	dw_1.SetRedraw(True)
	ROLLBACK;
	Return
END IF
ib_any_typing = False

dw_3.retrieve()
IF dw_3.RowCount() <=0 then
	Wf_Init()
	smodstatus ="I"
else
	smodstatus ="M"
end if

wf_setting_retrievemode(smodstatus)

dw_3.SelectRow(0, FALSE)
dw_3.SelectRow(dw_3.GetRow(),TRUE)


end event

type p_mod from w_inherite`p_mod within w_kfia03
end type

event p_mod::clicked;call super::clicked;
String sbill_no,ssql

w_mdi_frame.sle_msg.text =""

IF dw_1.AcceptText() = -1 then return 

sbill_no = dw_1.GetItemString(dw_1.GetRow(),"bill_no")

IF dw_1.GetRow() <=0 THEN Return

IF Wf_RequiredChk(dw_1.GetRow()) = -1 THEN Return

//KFM01OM0(지급어음) 검색//
IF smodstatus="M" THEN
ELSE		
	SELECT "KFM01OT0"."BILL_NO"  
    	INTO :ssql  
    	FROM "KFM01OT0"  
   	WHERE "KFM01OT0"."BILL_NO" = :sbill_no   ;

	IF SQLCA.SQLCODE =0 THEN
		f_messagechk(10,"")
		Return
	END IF
END IF

IF f_dbconfirm("저장") = 2 THEN RETURN

IF dw_1.Update() = 1 THEN
	IF Wf_Insert_Kfz12otc() = -1 THEN
		F_MessageChk(13,'[지급어음 이력]')
		Rollback;
		Return
	END IF
	
	COMMIT;
	
	p_ins.Enabled =True
	p_ins.PictureName = "C:\erpman\image\추가_up.gif"
	w_mdi_frame.sle_msg.text ="자료가 저장되었습니다.!!!"		
ELSE
	f_messagechk(13,"")
	ROLLBACK;
	RETURN
END IF
ib_any_typing = False

dw_3.retrieve()
IF dw_3.RowCount() <=0 then
	Wf_Init()
	smodstatus ="I"
else
	smodstatus ="M"
end if

wf_setting_retrievemode(smodstatus)

dw_3.SelectRow(0, FALSE)
dw_3.SelectRow(dw_3.GetRow(),TRUE)
end event

type cb_exit from w_inherite`cb_exit within w_kfia03
integer x = 3159
integer y = 2692
integer width = 293
integer taborder = 60
end type

type cb_mod from w_inherite`cb_mod within w_kfia03
integer x = 2185
integer y = 2692
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

//KFM01OM0(지급어음) 검색//
IF smodstatus="M" THEN
ELSE		
	SELECT "KFM01OT0"."BILL_NO"  
    	INTO :ssql  
    	FROM "KFM01OT0"  
   	WHERE "KFM01OT0"."BILL_NO" = :sbill_no   ;

	IF SQLCA.SQLCODE =0 THEN
		f_messagechk(10,"")
		Return
	END IF
END IF

IF f_dbconfirm("저장") = 2 THEN RETURN

IF dw_1.Update() = 1 THEN
	IF Wf_Insert_Kfz12otc() = -1 THEN
		F_MessageChk(13,'[지급어음 이력]')
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

type cb_ins from w_inherite`cb_ins within w_kfia03
integer x = 1120
integer y = 2444
integer width = 293
end type

event cb_ins::clicked;call super::clicked;wf_init()
end event

type cb_del from w_inherite`cb_del within w_kfia03
integer x = 2510
integer y = 2692
integer width = 293
integer taborder = 30
end type

event cb_del::clicked;call super::clicked;String sbill_no
Int lsql_cnt

String syear

sle_msg.text =""

dw_1.AcceptText()

sbill_no =dw_1.GetItemString(1,"bill_no")

SELECT Count("KFZ12OT0"."KWAN_NO")  
	INTO :lsql_cnt  
   FROM "KFZ12OT0"  
   WHERE "KFZ12OT0"."SAUP_NO" = :sbill_no  ;
IF SQLCA.SQLCODE  = 0 AND lsql_cnt <> 0 THEN
	sle_msg.text ="이 코드로 발행된 전표가 존재합니다.!!"
	MessageBox("확 인","삭제할 수 없는 자료입니다.!!")
	Return
ELSE
	SELECT "KFM01OT0"."BAL_YY"  
   	INTO :syear  
    	FROM "KFM01OT0"  
   	WHERE "KFM01OT0"."BILL_NO" = :sbill_no   ;
	IF SQLCA.SQLCODE = 0 THEN
		sle_msg.text ="이 코드로 발행된 전표가 존재합니다.!!"
		MessageBox("확 인","삭제할 수 없는 자료입니다.!!")
		Return
	END IF
END IF

IF f_dbconfirm("삭제") = 2 THEN RETURN

dw_1.SetRedraw(False)
dw_1.DeleteRow(0)

IF dw_1.Update() = 1 THEN
	
	delete from kfz12otc where bill_no = :sBill_No;
	
	
	COMMIT;
	WF_INIT()
	dw_1.SetRedraw(True)	
	sle_msg.text ="자료가 삭제되었습니다.!!!"	
ELSE
	f_messagechk(12,'')
	dw_1.SetRedraw(True)
	ROLLBACK;
END IF
end event

type cb_inq from w_inherite`cb_inq within w_kfia03
integer x = 37
integer y = 2692
integer width = 293
integer taborder = 40
end type

event cb_inq::clicked;call super::clicked;String sbill_no,acc1,acc2,get_acc_nm, sbal_date, sman_date 

sle_msg.text =""

dw_1.AcceptText()
sbill_no =dw_1.GetItemString(dw_1.GetRow(),"bill_no")
sbal_date = dw_1.getitemstring(dw_1.getrow(), "bbal_dat")
sman_date = dw_1.getitemstring(dw_1.getrow(), "bman_dat")

IF sBill_No = "" OR IsNull(sBill_No) THEN 
	F_MessageChk(1,'[어음번호]')
	dw_1.SetColumn("bill_no")
	dw_1.SetFocus()
	Return -1
END IF

IF dw_1.Retrieve(sbill_no) <= 0 THEN
	WF_INIT()
	f_messagechk(14,'') 
	Return
ELSE
	dw_2.retrieve(sbill_no)
	
	smodstatus ="M"
	ib_any_typing =False
	wf_setting_retrievemode(smodstatus)
END IF

end event

type cb_print from w_inherite`cb_print within w_kfia03
integer x = 2729
integer y = 2416
integer width = 293
end type

type st_1 from w_inherite`st_1 within w_kfia03
integer width = 297
end type

type cb_can from w_inherite`cb_can within w_kfia03
integer x = 2834
integer y = 2692
integer width = 293
integer taborder = 50
end type

event cb_can::clicked;call super::clicked;wf_init()
end event

type cb_search from w_inherite`cb_search within w_kfia03
integer x = 2263
integer y = 2428
integer width = 425
end type

event cb_search::clicked;call super::clicked;//Open(w_kfia03a)
//IF is_button_chk ="조회" THEN
//	cb_ins.Enabled =False
//ELSE
//	cb_ins.Enabled =True
//END IF
//
//dw_1.SetFocus()
end event

type dw_datetime from w_inherite`dw_datetime within w_kfia03
integer x = 2853
integer width = 745
end type

type sle_msg from w_inherite`sle_msg within w_kfia03
integer x = 334
integer width = 2519
end type

type gb_10 from w_inherite`gb_10 within w_kfia03
integer width = 3598
end type

type gb_button1 from w_inherite`gb_button1 within w_kfia03
integer x = 0
integer y = 2636
integer width = 384
end type

type gb_button2 from w_inherite`gb_button2 within w_kfia03
integer x = 2135
integer y = 2636
integer width = 1362
end type

type gb_5 from groupbox within w_kfia03
boolean visible = false
integer x = 2917
integer width = 338
integer height = 160
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "자료선택"
end type

type dw_2 from datawindow within w_kfia03
integer x = 2025
integer y = 1500
integer width = 2578
integer height = 688
boolean bringtotop = true
string dataobject = "d_kfia031"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_1 from u_key_enter within w_kfia03
event ue_key pbm_dwnkey
integer x = 1998
integer y = 168
integer width = 2670
integer height = 1312
integer taborder = 10
string dataobject = "d_kfia03"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) or keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event editchanged;w_mdi_frame.sle_msg.text =""
ib_any_typing =True
end event

event itemchanged;String   snull,ssql,ssano,scolvalue
Integer  lnull

SetNull(snull)  
SetNull(lnull)

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

IF this.GetColumnName() ="bnk_cd" THEN
	sColValue = this.GetText()
	if sColValue = '' or IsNull(sColValue) then Return
	
	SELECT "KFZ04OM0"."PERSON_NM"  INTO :ssql  
			FROM "KFZ04OM0"  
			WHERE ( "KFZ04OM0"."PERSON_CD" = :scolvalue ) AND  
					(( "KFZ04OM0"."PERSON_GU" = '2' ) )  ;	
	IF SQLCA.SQLCODE <> 0 THEN
		f_messagechk(20,"지급은행")
		dw_1.SetItem(row,"bnk_cd",snull)
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

IF this.GetColumnName() ="status" THEN
	sColValue = this.GetText()
	if sColValue = '' or IsNull(sColValue) then Return
	
	SELECT "REFFPF"."RFNA1"  
    	INTO :ssql  
    	FROM "REFFPF"  
   	WHERE ( "REFFPF"."RFCOD" = 'RS' ) AND  
         	( "REFFPF"."RFGUB" = :scolvalue )   ;
	IF SQLCA.SQLCODE <> 0 THEN
		f_messagechk(20,"어음상태")
		dw_1.SetItem(row,"status",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="bbal_dat" THEN
	sColValue = this.GetText()
	if sColValue = '' or IsNull(sColValue) then Return
	
	IF f_datechk(scolvalue) = -1 THEN 
		f_messagechk(20,"발행일자")
		dw_1.SetItem(row,"bbal_dat",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="bman_dat" THEN
	sColValue = this.GetText()
	if sColValue = '' or IsNull(sColValue) then Return
	
	IF f_datechk(scolvalue) = -1 THEN 
		f_messagechk(20,"만기일자")
		dw_1.SetItem(row,"bman_dat",snull)
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
		dw_1.SetItem(1,"bal_date", sColValue)
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

event rbuttondown;String snull

SetNull(snull)

this.accepttext()

//IF this.GetColumnName() ="bill_no" THEN
//	SetNull(gs_code)
//	SetNull(gs_codename)
//
//	gs_code =Trim(dw_1.GetItemString(dw_1.GetRow(),"bill_no"))
//	IF IsNull(gs_code) THEN gs_code =""
//	
//	OPEN(W_KFM01OT0_POPUP)
//	
//	IF Not IsNull(gs_code) THEN
//		IF dw_1.Retrieve(gs_code) <=0 THEN
//		ELSE
//			dw_2.Retrieve(gs_code)
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
	
	lstr_custom.code = this.GetItemstring(this.GetRow(),"saup_no")
	
	IF IsNull(lstr_custom.code) THEN
		lstr_custom.code = ""
	END IF
	
	OpenWithParm(W_KFZ04OM0_POPUP,'1')
	
	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
	
	this.SetItem(this.GetRow(),"saup_no",lstr_custom.code)
	this.SetItem(this.GetRow(),"person_nm", lstr_custom.name)
END IF
end event

event itemfocuschanged;call super::itemfocuschanged;Long wnd

wnd =Handle(this)

IF dwo.name ="bill_nm"  THEN
	f_toggle_kor(wnd)
ELSE
	f_toggle_eng(wnd)
END IF
end event

type pb_2 from picturebutton within w_kfia03
boolean visible = false
integer x = 2967
integer y = 56
integer width = 82
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "C:\erpman\image\first.gif"
alignment htextalign = left!
end type

event clicked;String sBillNo,sGetBillNo

dw_1.AcceptText()
IF ib_any_typing = True THEN
	MessageBox("확 인","저장하지 않은 자료가 존재합니다!!")
	Return
END IF

sBillNo = dw_1.GetItemString(dw_1.GetRow(),"bill_no")

SELECT MAX("KFM01OT0"."BILL_NO")  	INTO :sGetBillNo
   FROM "KFM01OT0"
	WHERE "KFM01OT0"."BILL_NO" < :sBillNo ;
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

type pb_3 from picturebutton within w_kfia03
boolean visible = false
integer x = 3099
integer y = 56
integer width = 82
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "C:\erpman\image\next.gif"
alignment htextalign = left!
end type

event clicked;String sBillNo,sGetBillNo

dw_1.AcceptText()
IF ib_any_typing = True THEN
	MessageBox("확 인","저장하지 않은 자료가 존재합니다!!")
	Return
END IF

sBillNo = dw_1.GetItemString(dw_1.GetRow(),"bill_no")

SELECT MIN("KFM01OT0"."BILL_NO")  	INTO :sGetBillNo
   FROM "KFM01OT0"
	WHERE "KFM01OT0"."BILL_NO" > :sBillNo;
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

type dw_list from datawindow within w_kfia03
boolean visible = false
integer y = 844
integer width = 494
integer height = 360
boolean bringtotop = true
boolean titlebar = true
string title = "지급어음-이력"
string dataobject = "d_kfia032"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type dw_3 from u_d_popup_sort within w_kfia03
integer x = 128
integer y = 196
integer width = 1842
integer height = 1984
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_kfia033"
boolean vscrollbar = true
boolean border = false
end type

event rowfocuschanged;call super::rowfocuschanged;If currentrow <= 0 then
	dw_1.SelectRow(0,False)

ELSE

	SelectRow(0, FALSE)
	SelectRow(currentrow,TRUE)
	
	dw_1.ScrollToRow(currentrow)
	
	dw_2.retrieve(dw_1.object.bill_no[currentrow])
END IF

end event

event clicked;call super::clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	dw_1.ScrollToRow(row)
	
//	Lb_AutoFlag = False
	
	b_flag = False
	
	dw_2.retrieve(dw_1.object.bill_no[row])
	
//	smodstatus="M"
//	wf_setting_retrievemode(smodstatus)
END IF

CALL SUPER ::CLICKED


end event

type st_2 from statictext within w_kfia03
integer x = 142
integer y = 72
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

type sle_1 from singlelineedit within w_kfia03
integer x = 448
integer y = 64
integer width = 567
integer height = 64
integer taborder = 30
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

type rr_1 from roundrectangle within w_kfia03
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2016
integer y = 1492
integer width = 2606
integer height = 708
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_2 from roundrectangle within w_kfia03
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 114
integer y = 184
integer width = 1874
integer height = 2016
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_3 from roundrectangle within w_kfia03
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 114
integer y = 16
integer width = 987
integer height = 148
integer cornerheight = 40
integer cornerwidth = 46
end type

type ln_1 from line within w_kfia03
integer linethickness = 1
integer beginx = 453
integer beginy = 136
integer endx = 1015
integer endy = 136
end type

