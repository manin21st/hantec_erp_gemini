$PBExportHeader$w_kfia04.srw
$PBExportComments$유가증권등록
forward
global type w_kfia04 from w_inherite
end type
type dw_1 from u_key_enter within w_kfia04
end type
type dw_2 from u_d_popup_sort within w_kfia04
end type
type st_2 from statictext within w_kfia04
end type
type sle_1 from singlelineedit within w_kfia04
end type
type rr_2 from roundrectangle within w_kfia04
end type
type rr_3 from roundrectangle within w_kfia04
end type
type ln_1 from line within w_kfia04
end type
end forward

global type w_kfia04 from w_inherite
string title = "유가증권 등록"
dw_1 dw_1
dw_2 dw_2
st_2 st_2
sle_1 sle_1
rr_2 rr_2
rr_3 rr_3
ln_1 ln_1
end type
global w_kfia04 w_kfia04

type variables
String LsFirstId = 'J'
end variables

forward prototypes
public function integer wf_data_chk (string scolname, string scolvalue)
public function integer wf_requiredchk (integer icurrow)
public function string wf_no (string sjzid)
public subroutine wf_setting_retrievemode (string mode)
public function integer wf_chk_unrequired ()
public function integer wf_kfz04om0_update ()
public subroutine wf_init ()
end prototypes

public function integer wf_data_chk (string scolname, string scolvalue);String ssql,syu_chk,snull,satgb,sacc

SetNull(snull)

IF scolname ="bnk_cd" THEN
  SELECT "KFZ04OM0"."PERSON_NM"  
    INTO :ssql  
    FROM "KFZ04OM0"  
    WHERE ( "KFZ04OM0"."PERSON_GU" = '2' ) AND  
          ( "KFZ04OM0"."PERSON_CD" = :scolvalue )   ;
	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox("확  인","예탁은행이 등록된 은행이 아닙니다.확인하세요.!!!")
		dw_1.SetItem(dw_1.getrow(),"bnk_cd",snull)
		dw_1.SetColumn("bnk_cd")
		dw_1.SetFocus()
		Return -1
	END IF
END IF

IF scolname ="acc1_cd" THEN
	sacc =dw_1.GetItemString(dw_1.GetRow(),"acc2_cd")
	
	IF sacc ="" OR IsNull(sacc) THEN RETURN 1
	
	SELECT "KFZ01OM0"."ACC2_NM",   
          "KFZ01OM0"."YU_GU"  
   	INTO :ssql,   
           :syu_chk  
    	FROM "KFZ01OM0"  
   	WHERE ( "KFZ01OM0"."ACC1_CD" = :scolvalue ) AND  
      	   ( "KFZ01OM0"."ACC2_CD" = :sacc )   ;
	IF SQLCA.SQLCODE <> 0 THEN 
		f_messagechk(20,"계정과목")
		dw_1.SetItem(dw_1.GetRow(),"acc1_cd",snull)
		dw_1.SetItem(dw_1.GetRow(),"acc2_cd",snull)
		dw_1.SetItem(dw_1.GetRow(),"accname",snull)
		dw_1.SetColumn("acc1_cd")
		dw_1.SetFocus()
		Return -1
	ELSE
		IF syu_chk <> "Y" THEN
			sle_msg.text ="유가증권을 등록할 수 없는 계정입니다.!!"
			Messagebox("확 인","계정과목을 확인하세요.!!")
			dw_1.SetItem(dw_1.GetRow(),"acc1_cd",snull)
			dw_1.SetItem(dw_1.GetRow(),"acc2_cd",snull)
			dw_1.SetItem(dw_1.GetRow(),"accname",snull)
			dw_1.SetColumn("acc1_cd")
			dw_1.SetFocus()
			Return -1
		ELSE
			dw_1.SetItem(dw_1.GetRow(),"accname",ssql)
		END IF
	END IF
END IF

IF scolname ="acc2_cd" THEN
	sacc =dw_1.GetItemString(dw_1.GetRow(),"acc1_cd")
	
	IF sacc ="" OR IsNull(sacc) THEN RETURN 1
	
	SELECT "KFZ01OM0"."ACC2_NM",   
          "KFZ01OM0"."YU_GU"  
   	INTO :ssql,   
           :syu_chk  
    	FROM "KFZ01OM0"  
   	WHERE ( "KFZ01OM0"."ACC1_CD" = :sacc ) AND  
      	   ( "KFZ01OM0"."ACC2_CD" = :scolvalue)   ;
	IF SQLCA.SQLCODE <> 0 THEN 
		f_messagechk(20,"계정과목") 
		dw_1.SetItem(dw_1.GetRow(),"acc1_cd",snull)
		dw_1.SetItem(dw_1.GetRow(),"acc2_cd",snull)
		dw_1.SetItem(dw_1.GetRow(),"accname",snull)
		dw_1.SetColumn("acc1_cd")
		dw_1.SetFocus()
		Return -1
	ELSE
		IF syu_chk <> "Y" THEN
			sle_msg.text ="유가증권을 등록할 수 없는 계정입니다.!!"
			Messagebox("확 인","계정과목을 확인하세요.!!")
			dw_1.SetItem(dw_1.GetRow(),"acc1_cd",snull)
			dw_1.SetItem(dw_1.GetRow(),"acc2_cd",snull)
			dw_1.SetItem(dw_1.GetRow(),"accname",snull)
			dw_1.SetColumn("acc1_cd")
			dw_1.SetFocus()
			Return -1
		ELSE
			dw_1.SetItem(dw_1.GetRow(),"accname",ssql)
		END IF
	END IF
END IF

IF scolname ="jz_bald" THEN
	IF f_datechk(scolvalue) = -1 THEN
		MessageBox("확  인","발행일자를 확인하세요.!!!")
		dw_1.SetItem(dw_1.getrow(),"jz_bald",snull)
		dw_1.SetColumn("jz_bald")
		Return -1
	END IF
END IF

IF scolname ="jz_mand" THEN
	IF f_datechk(scolvalue) = -1 THEN
		MessageBox("확  인","만기일자를 확인하세요.!!!")
		dw_1.SetItem(dw_1.getrow(),"jz_mand",snull)
		dw_1.SetColumn("jz_mand")
		Return -1
	END IF
END IF

IF scolname ="jz_aamt" THEN
	IF Double(scolvalue) = 0 THEN
		MessageBox("확  인","액면금액을 입력하세요.!!!")
		dw_1.SetColumn("jz_aamt")
		Return -1
	END IF
END IF

IF scolname ="jz_guid" THEN
	IF f_datechk(scolvalue) = -1 THEN
		MessageBox("확  인","구매일자를 확인하세요.!!!")
		dw_1.SetItem(dw_1.getrow(),"jz_guid",snull)
		dw_1.SetColumn("jz_guid")
		Return -1
	END IF
END IF

IF scolname ="jz_nbr" THEN
	IF Double(scolvalue) =0 THEN
		MessageBox("확  인","구입매수을 입력하세요.!!!")
		dw_1.SetColumn("jz_nbr")
		Return -1
	END IF
END IF

IF scolname ="jz_camt" THEN
	IF Double(scolvalue) =0 THEN
		MessageBox("확  인","취득가액을 입력하세요.!!!")
		dw_1.SetColumn("jz_camt")
		Return -1
	END IF
END IF

IF scolname ="jz_samt" THEN
	IF dw_1.GetItemNumber(1,"jz_camt") < Double(scolvalue) THEN
		sle_msg.text ="상환금액이 취득가액보다 크면 안됩니다.!!"
		MessageBox("확 인","상환금액을 확인하세요.!!")
		dw_1.SetItem(dw_1.getrow(),"jz_samt",0)
		dw_1.SetColumn("jz_samt")
		dw_1.Setfocus()
		Return -1
	END IF
END IF
IF scolname ="jz_jeng" THEN
	IF scolvalue <> "Y" AND scolvalue <> "N" THEN
		f_messagechk(20,"상환완료여부")
		dw_1.SetItem(dw_1.getrow(),"jz_jeng",snull)
		dw_1.SetColumn("jz_jeng")
		Return -1
	ELSEIF scolvalue = "N" THEN
		IF dw_1.GetItemNumber(dw_1.getrow(),"jz_camt") = dw_1.GetItemNumber(dw_1.getrow(),"jz_samt")  THEN
			sle_msg.text ="취득가액과 상환금액이 같으면 상환상태는 Y여야 합니다.!!"
			MessageBox("확 인","상환완료여부를 확인하세요.!!")
			dw_1.SetItem(1,"jz_jeng",snull)
			dw_1.SetColumn("jz_jeng")
			Return -1
		END IF
	END IF
END IF

IF scolname ="alc_gu" THEN
	IF scolvalue <> "Y" AND scolvalue <> "N" THEN
		f_messagechk(20,"승인구분")
		dw_1.SetItem(dw_1.getrow(),"alc_gu",snull)
		dw_1.SetColumn("alc_gu")
		Return -1
	END IF
END IF

IF scolname ="saupj" THEN
	IF scolvalue = "99" THEN
		f_messagechk(20,"사업장")
		dw_1.SetItem(dw_1.getrow(),"saupj",snull)
		dw_1.SetColumn("saupj")
		Return -1
	END IF
END IF

Return 1


end function

public function integer wf_requiredchk (integer icurrow);String  sJzName,sBal,sGbn,sBnkCd,sCode,sSaup,sSungIn,sGuibDate,sManDate,sKaeJong,sKaeJong2,sBalName
Double  dRate,dJzCamt,sGuib,sAmt

dw_1.AcceptText()

sJzName   = dw_1.GetItemString(dw_1.GetRow(),"jz_name")
sBnkCd    = dw_1.GetItemString(dw_1.GetRow(),"bnk_cd")
sbal      = dw_1.GetItemString(dw_1.GetRow(),"jz_bald")
sGbn      = dw_1.GetItemString(dw_1.GetRow(),"jz_jeng")

dRate     = dw_1.GetItemNumber(dw_1.GetRow(),"jz_rat")
dJzCamt   = dw_1.GetItemNumber(dw_1.GetRow(),"jz_camt")
sCode     = dw_1.GetItemString(dw_1.GetRow(),"jz_illd")
sSaup	    = dw_1.GetItemString(dw_1.GetRow(),"saupj")
sSungIn	 = dw_1.GetItemString(dw_1.GetRow(),"alc_gu")
sGuib     = dw_1.GetItemNumber(dw_1.GetRow(),"jz_nbr")  				
sGuibDate = dw_1.GetItemString(dw_1.GetRow(),"jz_guid") 
sManDate  = dw_1.GetItemString(dw_1.GetRow(),"jz_mand") 
sKaeJong  = dw_1.GetItemString(dw_1.GetRow(),"acc1_cd") 
sKaeJong2 = dw_1.GetItemString(dw_1.GetRow(),"acc2_cd") 
sBalName  = dw_1.GetItemString(dw_1.GetRow(),"jz_ibal")
sAmt      =	dw_1.GetItemNumber(dw_1.GetRow(),"jz_aamt") 

IF sCode = "" OR IsNull(sCode) THEN
   F_MessageChk(1,'[증권코드]')
	dw_1.SetColumn("jz_illd")
	dw_1.SetFocus()
	Return -1
END IF				 
				 
IF sJzName ="" OR IsNull(sJzName) THEN
	F_MessageChk(1,'[증권명]')
	dw_1.SetColumn("jz_name")
	dw_1.SetFocus()
	Return -1
END IF
//IF sBnkCd ="" OR IsNull(sBnkCd) THEN
//	F_MessageChk(1,'[예탁은행]')
//	dw_1.SetColumn("bnk_cd")
//	dw_1.SetFocus()
//	Return -1
//END IF
IF sKaeJong ="" OR IsNull(sKaeJong) THEN
	F_MessageChk(1,'[계정과목]')
	dw_1.SetColumn("acc1_cd")
	dw_1.SetFocus()
	Return -1
END IF 
IF sKaeJong2 = "" OR IsNull(sKaeJong2) THEN
	F_MessageChk(1,'[계정과목]')
	dw_1.SetColumn("acc2_cd")
	dw_1.SetFocus()
	Return -1
END IF 
//IF sBalName = "" OR IsNull(sBalName) THEN
//  	F_MessageChk(1,'[발행처명]')
//	dw_1.SetColumn("jz_ibal")
//	dw_1.SetFocus()
//	Return -1
//END IF 

IF sBal ="" OR IsNull(sBal) THEN
	F_MessageChk(1,'[발행일자]')
	dw_1.SetColumn("jz_bald")
	dw_1.SetFocus()
	Return -1
END IF
IF sManDate = "" OR IsNull(sManDate) THEN
	F_MessageChk(1,'[만기일자]')
	dw_1.SetColumn("jz_mand")
	dw_1.SetFocus()
	Return -1
END IF 
IF sAmt = 0 OR IsNull(sAmt) THEN
  	F_MessageChk(1,'[액면가액]')
	dw_1.SetColumn("jz_aamt")
	dw_1.SetFocus()
	Return -1
END IF 
//IF sGuibDate = "" OR IsNull(sGuibDate) THEN
//	F_MessageChk(1,'[구입일자]')
//	dw_1.SetColumn("jz_guid")
//	dw_1.SetFocus()
//	Return -1
//END IF 

//IF dJzCamt =0 OR IsNull(dJzCamt) THEN
//	F_MessageChk(1,'[취득금액]')
//	dw_1.SetColumn("jz_camt")
//	dw_1.SetFocus()
//	Return -1
//END IF
IF sGuib = 0 OR IsNull(sGuib) THEN
   F_MessageChk(1,'[구입매수]')
	dw_1.SetColumn("jz_nbr")
	dw_1.SetFocus()
	Return -1
END IF 

IF sGbn ="" OR IsNull(sGbn) THEN
	F_MessageChk(1,'[상환완료여부]')
	dw_1.SetColumn("jz_jeng")
	dw_1.SetFocus()
	Return -1
END IF
IF sSungIn ="" OR IsNull(sSungIn) THEN
   F_MessageChk(1,'[승인구분]')
	dw_1.SetColumn("alc_gu")
	dw_1.SetFocus()
	Return -1
END IF 

//IF dRate =0 OR IsNull(dRate) THEN
//	F_MessageChk(1,'[이율]')
//	dw_1.SetColumn("jz_rat")
//	dw_1.SetFocus()
//	Return -1
//END IF

IF sSaup = "" OR IsNull(sSaup) THEN
   F_MessageChk(1,'[사업장]')
	dw_1.SetColumn("saupj")
	dw_1.SetFocus()
	Return -1
END IF

Return 1


end function

public function string wf_no (string sjzid);String sFirst,sLast

sFirst = Left(sJzId,1)
  
SELECT MAX("KFM05OT0"."JZ_ILLD")    INTO :sLast  
	FROM "KFM05OT0";
If SQLCA.SQLCODE <> 0 THEN
	sLast = '0'
ELSE
	IF IsNull(sLast) OR sLast = '' THEN sLast = '0'
END IF

sLast = 'J' + String(long(right(sLast,5)) + 1,'00000')

Return sLast
end function

public subroutine wf_setting_retrievemode (string mode);
dw_1.SetRedraw(False)
IF mode ="M" THEN
	dw_1.SetTabOrder("jz_illd",0)
	dw_1.SetColumn("jz_name")
	
	cb_del.Enabled =True
ELSE
	dw_1.SetTabOrder("jz_illd",0)
	dw_1.SetColumn("jz_name")
	cb_del.Enabled =True
END IF
dw_1.SetFocus()
dw_1.SetRedraw(True)
end subroutine

public function integer wf_chk_unrequired ();String snull,sbal,sman
Double ldb_aamt,ldb_samt
Date sdate,edate

SetNull(snull)

sbal     = dw_1.GetItemString(dw_1.GetRow(),"jz_bald")
sman     = dw_1.GetItemString(dw_1.GetRow(),"jz_mand")
ldb_aamt = dw_1.GetItemNumber(dw_1.GetRow(),"jz_aamt")
ldb_samt = dw_1.GetItemNumber(dw_1.GetRow(),"jz_samt")

sdate =Date(Left(sbal,4)+"/"+Mid(sbal,5,2)+"/"+Right(sbal,2))
edate =Date(Left(sman,4)+"/"+Mid(sman,5,2)+"/"+Right(sman,2))

IF DaysAfter(sdate,edate) < 0 	THEN
	MessageBox("확  인","발행일자가 만기일자보다 빨라야 합니다.확인하세요.!!!")
	dw_1.SetItem(dw_1.getrow(),"jz_mand",snull)
	dw_1.SetColumn("jz_mand")
	dw_1.SetFocus()
	Return -1
END IF

IF ldb_aamt = ldb_samt  AND dw_1.GetItemString(dw_1.getrow(),"jz_jeng") ='N' THEN
	MessageBox("확인","취득가액과 상환금액이 같으면 상환상태는 Y여야 합니다.!!!")
	dw_1.SetColumn("jz_jeng")
	dw_1.SetFocus()
	Return -1
END IF

Return 1
end function

public function integer wf_kfz04om0_update ();String scode,sname,sgu,sbnkcd,sacc1,sacc2,sJzBal,sJzBalD,sKwanNo

dw_1.AcceptText()

scode   = dw_1.GetItemString(dw_1.GetRow(),"jz_illd")
sname   = dw_1.GetItemString(dw_1.GetRow(),"jz_name")
sbnkcd  = dw_1.GetItemString(dw_1.GetRow(),"bnk_cd")
sJzBal  = Trim(dw_1.GetItemString(dw_1.GetRow(),"jz_ibal"))
sJzBalD = dw_1.GetItemString(dw_1.GetRow(),"jz_bald")
sacc1   = dw_1.GetItemString(dw_1.GetRow(),"acc1_cd")
sacc2   = dw_1.GetItemString(dw_1.GetRow(),"acc2_cd")
sgu ='7'

IF IsNull(sJzBal) THEN sJzBal = ''

sKwanNo = Left(Trim(String(sJzBalD,'@@@@.@@.@@') + sJzBal),20)
IF f_mult_custom(scode,sname,sgu,sKwanNo,sbnkcd,sacc1,sacc2,'') = -1 THEN RETURN -1

Return 1
end function

public subroutine wf_init ();
String snull
Int lnull

SetNull(snull)
SetNull(lnull)

dw_1.SetRedraw(False)

dw_1.Reset()
dw_1.InsertRow(0)

sle_msg.text =""

dw_1.SetItem(dw_1.GetRow(),"jz_bald",f_today())
dw_1.SetItem(dw_1.GetRow(),"jz_guid",f_today())

dw_1.SetItem(dw_1.GetRow(),"saupj",gs_saupj)


dw_1.SetColumn("jz_illd")
dw_1.SetFocus()

dw_1.SetRedraw(True)

smodstatus ="M"
wf_setting_retrievemode(smodstatus)
ib_any_typing =False
end subroutine

event open;call super::open;
dw_1.SetTransObject(SQLCA)

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

on w_kfia04.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_2=create dw_2
this.st_2=create st_2
this.sle_1=create sle_1
this.rr_2=create rr_2
this.rr_3=create rr_3
this.ln_1=create ln_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.sle_1
this.Control[iCurrent+5]=this.rr_2
this.Control[iCurrent+6]=this.rr_3
this.Control[iCurrent+7]=this.ln_1
end on

on w_kfia04.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.st_2)
destroy(this.sle_1)
destroy(this.rr_2)
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
          
				 scode = "%"+ls_string+"%"
			
//				//문자 - 명칭
				Case is >= 127
				  scode = ls_string+"%"

	         End Choose
			End If	
		
		
		iRow=dw_2.Find("kfm05ot0_jz_illd like '" + scode +"'",1,dw_2.RowCount())
		  
		  if iRow>0 then
		     
	     else
	      iRow=dw_2.Find("kfm05ot0_jz_name like '" + scode +"'",1,dw_2.RowCount())
			
			 if iRow>0 then
		
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

type dw_insert from w_inherite`dw_insert within w_kfia04
boolean visible = false
integer x = 283
integer y = 2928
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kfia04
boolean visible = false
integer x = 4041
integer y = 2520
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kfia04
boolean visible = false
integer x = 3867
integer y = 2520
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kfia04
boolean visible = false
integer x = 3173
integer y = 2520
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_kfia04
integer x = 3739
integer taborder = 0
end type

event p_ins::clicked;call super::clicked;integer icurrow

iCurRow = dw_1.InsertRow(0)
dw_1.SetItem(iCurRow,"jz_bald",f_today())
dw_1.SetItem(iCurRow,"jz_guid",f_today())

dw_1.SetItem(iCurRow,"saupj",  gs_saupj)
dw_1.ScrollToRow(iCurRow)
	
dw_1.SetFocus()

dw_2.SelectRow(0,False)
dw_2.SelectRow(iCurRow,True)

dw_2.ScrollToRow(iCurRow)

//p_ins.Enabled = False
//p_ins.PictureName = "C:\erpman\image\추가_d.gif"
sModStatus = 'I'
wf_setting_retrievemode(smodstatus)


end event

type p_exit from w_inherite`p_exit within w_kfia04
integer x = 4434
integer taborder = 60
end type

type p_can from w_inherite`p_can within w_kfia04
integer x = 4261
integer taborder = 50
end type

event p_can::clicked;call super::clicked;dw_2.retrieve()

IF dw_2.RowCount() <=0 then
	Wf_Init()
	smodstatus ="I"
else
	smodstatus ="M"
end if
ib_any_typing = False

wf_setting_retrievemode(smodstatus)

dw_2.SelectRow(0, FALSE)
dw_2.SelectRow(dw_2.GetRow(),TRUE)

end event

type p_print from w_inherite`p_print within w_kfia04
boolean visible = false
integer x = 3346
integer y = 2520
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kfia04
integer x = 3566
end type

event p_inq::clicked;call super::clicked;String ls_jung,acc1,acc2,get_acc_nm

sle_msg.text =""

dw_1.AcceptText()
ls_jung = dw_1.GetItemString(dw_1.GetRow(),"jz_illd")
IF ls_jung = "" OR IsNull(ls_jung) THEN
   F_MessageChk(1,'[증권코드]')
	dw_1.SetColumn("jz_illd")
	dw_1.SetFocus()
	Return -1
END IF

IF dw_1.Retrieve(ls_jung) <= 0 THEN
	WF_INIT()
	f_messagechk(14,'')
	Return
ELSE
	acc1 =dw_1.GetItemString(dw_1.GetRow(),"acc1_cd")
	acc2 =dw_1.GetItemString(dw_1.GetRow(),"acc2_cd")
	
	SELECT "KFZ01OM0"."ACC2_NM"  
   	INTO :get_acc_nm  
    	FROM "KFZ01OM0"  
   	WHERE ( "KFZ01OM0"."ACC1_CD" = :acc1 ) AND ( "KFZ01OM0"."ACC2_CD" = :acc2 ) ; 
				
	dw_1.SetItem(dw_1.GetRow(),"accname",get_acc_nm)
	smodstatus ="M"
	wf_setting_retrievemode(smodstatus)
END IF
ib_any_typing =False

end event

type p_del from w_inherite`p_del within w_kfia04
integer x = 4087
integer taborder = 40
end type

event p_del::clicked;call super::clicked;String sjz_illd
Int lsql_cnt

sle_msg.text =""

dw_1.AcceptText()

sjz_illd =dw_1.GetItemString(dw_1.getrow(),"jz_illd")

IF f_dbconfirm("삭제") = 2 THEN RETURN

SELECT Count("KFZ12OT0"."SAUP_NO")  
	INTO :lsql_cnt  
   FROM "KFZ12OT0"  
   WHERE "KFZ12OT0"."SAUP_NO" = :sjz_illd   ;
IF SQLCA.SQLCODE  = 0 AND lsql_cnt <> 0 THEN
	sle_msg.text ="이 코드로 발행된 전표가 존재합니다.!!"
	MessageBox("확 인","삭제할 수 없는 자료입니다.!!")
	Return
END IF
dw_1.SetRedraw(False)
dw_1.DeleteRow(0)
IF dw_1.Update() = 1 THEN
	IF f_mult_custom(sjz_illd,'','7','','','','','99') = -1 THEN
		ROLLBACK;
		Messagebox("확 인","경리거래처 갱신 실패!!")
		
	ELSE
		COMMIT;
		w_mdi_frame.sle_msg.text ="자료가 삭제되었습니다.!!!"	
	END IF
	
ELSE
	ROLLBACK;
	f_messagechk(12,'') 
	
	Return
END IF
dw_1.SetRedraw(True)
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

type p_mod from w_inherite`p_mod within w_kfia04
integer x = 3913
integer taborder = 30
end type

event p_mod::clicked;call super::clicked;
String    sjz_illd
Integer   iCount

sle_msg.text =""

IF dw_1.GetRow() <=0 THEN Return

IF dw_1.AcceptText() = -1 then return 
sjz_illd = dw_1.GetItemString(dw_1.GetRow(),"jz_illd")

IF smodstatus <> "M" THEN
	
	select Count(*) 	into :iCount		from kfm05ot0		where jz_illd = :sjz_illd;
	if sqlca.sqlcode = 0 and iCount <> 0 then
		F_MessageChk(10,'[증권코드]')
		Return
	end if
	sJz_illd = Wf_No('')
	
	dw_1.SetItem(dw_1.GetRow(),"jz_illd",sJz_illd)
	
END IF

IF Wf_RequiredChk(dw_1.GetRow()) = -1 THEN Return
IF wf_chk_unrequired() = -1 THEN RETURN					//UNREQUIRED FIELD CHECK

IF f_dbconfirm("저장") = 2 THEN RETURN

IF dw_1.Update() = 1 THEN
	IF wf_kfz04om0_update() = -1 THEN
		ROLLBACK;
		Messagebox("확 인","경리거래처 갱신 실패!!")
		
	ELSE
		COMMIT;
		w_mdi_frame.sle_msg.text ="자료가 저장되었습니다.!!!"	
	END IF
	
ELSE
	ROLLBACK;
	f_messagechk(13,"") 
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

type cb_exit from w_inherite`cb_exit within w_kfia04
boolean visible = false
integer x = 2793
integer y = 2604
integer width = 293
end type

type cb_mod from w_inherite`cb_mod within w_kfia04
boolean visible = false
integer x = 1847
integer y = 2604
integer width = 293
end type

type cb_ins from w_inherite`cb_ins within w_kfia04
boolean visible = false
integer x = 965
integer y = 2804
integer width = 293
end type

event cb_ins::clicked;call super::clicked;WF_INIT()
end event

type cb_del from w_inherite`cb_del within w_kfia04
boolean visible = false
integer x = 2162
integer y = 2604
integer width = 293
end type

type cb_inq from w_inherite`cb_inq within w_kfia04
boolean visible = false
integer x = 1527
integer y = 2604
integer width = 293
end type

type cb_print from w_inherite`cb_print within w_kfia04
boolean visible = false
integer x = 1275
integer y = 2804
integer width = 293
end type

type st_1 from w_inherite`st_1 within w_kfia04
boolean visible = false
integer y = 3216
integer width = 306
end type

type cb_can from w_inherite`cb_can within w_kfia04
event ue_init pbm_custom01
boolean visible = false
integer x = 2478
integer y = 2604
integer width = 293
end type

on cb_can::ue_init;call w_inherite`cb_can::ue_init;String ls_null

SetNull(ls_null)
dw_1.SetItem(dw_1.GetRow(),"saupj","1")
dw_1.SetItem(dw_1.GetRow(),"alc_gu","N")
dw_1.SetItem(dw_1.GetRow(),"jz_nbr",1)
dw_1.SetItem(dw_1.GetRow(),"jz_san1",5)
dw_1.SetItem(dw_1.GetRow(),"jz_san2",0)

dw_1.SetItem(dw_1.GetRow(),"jz_illd","")
dw_1.SetItem(dw_1.GetRow(),"jz_name","")
dw_1.SetItem(dw_1.GetRow(),"bnk_cd","")
dw_1.SetItem(dw_1.GetRow(),"acc1_cd","")
dw_1.SetItem(dw_1.GetRow(),"acc2_cd","")
dw_1.SetItem(dw_1.GetRow(),"jz_bald","")
dw_1.SetItem(dw_1.GetRow(),"jz_mand","")
dw_1.SetItem(dw_1.GetRow(),"jz_aamt",ls_null)
dw_1.SetItem(dw_1.GetRow(),"jz_ibal","")
dw_1.SetItem(dw_1.GetRow(),"jz_guid","")
dw_1.SetItem(dw_1.GetRow(),"jz_camt",ls_null)
dw_1.SetItem(dw_1.GetRow(),"jz_rat",ls_null)
dw_1.SetItem(dw_1.GetRow(),"jz_samt",ls_null)
dw_1.SetItem(dw_1.GetRow(),"jz_jeng","")
dw_1.SetItem(dw_1.GetRow(),"accname","")

end on

type cb_search from w_inherite`cb_search within w_kfia04
boolean visible = false
integer x = 1586
integer y = 2808
integer width = 425
end type

event cb_search::clicked;call super::clicked;//Open(w_kfia04a)
//IF is_button_chk ="조회" THEN
//	cb_ins.Enabled =False
//ELSE
//	cb_ins.Enabled =True
//END IF
//
//dw_1.SetFocus()
//is_button_chk="등록"
end event

type dw_datetime from w_inherite`dw_datetime within w_kfia04
boolean visible = false
integer y = 3216
integer width = 745
end type

type sle_msg from w_inherite`sle_msg within w_kfia04
boolean visible = false
integer x = 343
integer y = 3216
integer width = 2496
end type

type gb_10 from w_inherite`gb_10 within w_kfia04
boolean visible = false
integer y = 3164
end type

type gb_button1 from w_inherite`gb_button1 within w_kfia04
boolean visible = false
integer x = 110
integer y = 2232
integer width = 393
end type

type gb_button2 from w_inherite`gb_button2 within w_kfia04
boolean visible = false
integer x = 2144
integer y = 2232
integer width = 1312
end type

type dw_1 from u_key_enter within w_kfia04
event ue_key pbm_dwnkey
integer x = 1390
integer y = 200
integer width = 3095
integer height = 2048
integer taborder = 20
string dataobject = "d_kfia04"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) or keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;String sJzNo,sNull,ssql,syu_chk,satgb,sacc,sColValue
decimal d_amt, d_nbr

SetNull(snull)

w_mdi_frame.sle_msg.text = ""

IF this.GetColumnName() ="jz_illd" THEN
	sColValue = this.GetText()
	if sColValue = '' or IsNull(sColValue) then Return
	
	select jz_illd 	into :sJzNo
		from kfm05ot0
		where jz_illd = :sColValue;
	if sqlca.sqlcode = 0 then
		dw_1.Retrieve(sColValue)
		sModStatus = 'M'
		WF_SETTING_RETRIEVEMODE(smodstatus)
	end if
END IF

IF this.GetColumnName() ="bnk_cd" THEN
	sColValue = this.GetText()
	if sColValue = '' or IsNull(sColValue) then Return
	
  SELECT "KFZ04OM0"."PERSON_NM"  
    INTO :ssql  
    FROM "KFZ04OM0"  
    WHERE ( "KFZ04OM0"."PERSON_GU" = '2' ) AND  
          ( "KFZ04OM0"."PERSON_CD" = :scolvalue )   ;
	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox("확  인","예탁은행이 등록된 은행이 아닙니다.확인하세요.!!!")
		dw_1.SetItem(row,"bnk_cd",snull)
		dw_1.SetColumn("bnk_cd")
		dw_1.SetFocus()
		Return 1
	END IF
END IF

IF this.GetColumnName() ="acc1_cd" THEN
	scolvalue = data
	sacc =dw_1.GetItemString(dw_1.GetRow(),"acc2_cd")
	
	if scolvalue = '' or isnull(scolvalue) then
		dw_1.SetItem(dw_1.GetRow(),"acc2_cd",snull)
		dw_1.SetItem(dw_1.GetRow(),"accname",snull)
		return
	end if
	
	IF sacc ="" OR IsNull(sacc) THEN RETURN 
	
	SELECT "KFZ01OM0"."ACC2_NM",   
          "KFZ01OM0"."YU_GU"  
   	INTO :ssql,   
           :syu_chk  
    	FROM "KFZ01OM0"  
   	WHERE ( "KFZ01OM0"."ACC1_CD" = :scolvalue ) AND  
      	   ( "KFZ01OM0"."ACC2_CD" = :sacc )   ;
	IF SQLCA.SQLCODE <> 0 THEN 
//		f_messagechk(20,"계정과목")
		dw_1.SetItem(dw_1.GetRow(),"acc1_cd",snull)
		dw_1.SetItem(dw_1.GetRow(),"acc2_cd",snull)
		dw_1.SetItem(dw_1.GetRow(),"accname",snull)
		dw_1.SetColumn("acc1_cd")
		dw_1.SetFocus()
		Return 
	ELSE
		IF syu_chk <> "Y" THEN
			sle_msg.text ="유가증권을 등록할 수 없는 계정입니다.!!"
			Messagebox("확 인","계정과목을 확인하세요.!!")
			dw_1.SetItem(dw_1.GetRow(),"acc1_cd",snull)
			dw_1.SetItem(dw_1.GetRow(),"acc2_cd",snull)
			dw_1.SetItem(dw_1.GetRow(),"accname",snull)
			dw_1.SetColumn("acc1_cd")
			dw_1.SetFocus()
			Return 1
		ELSE
			dw_1.SetItem(dw_1.GetRow(),"accname",ssql)
		END IF
	END IF
END IF

IF this.GetColumnName() ="acc2_cd" THEN
	scolvalue = data
	sacc =dw_1.GetItemString(dw_1.GetRow(),"acc1_cd")
	
	if scolvalue = '' or isnull(scolvalue) then
		dw_1.SetItem(dw_1.GetRow(),"accname",snull)
		return
	end if
	
	IF sacc ="" OR IsNull(sacc) THEN RETURN 
	
	SELECT "KFZ01OM0"."ACC2_NM",   
          "KFZ01OM0"."YU_GU"  
   	INTO :ssql,   
           :syu_chk  
    	FROM "KFZ01OM0"  
   	WHERE ( "KFZ01OM0"."ACC1_CD" = :sacc ) AND  
      	   ( "KFZ01OM0"."ACC2_CD" = :scolvalue)   ;
	IF SQLCA.SQLCODE <> 0 THEN 
//		f_messagechk(20,"계정과목") 
		dw_1.SetItem(dw_1.GetRow(),"acc1_cd",snull)
		dw_1.SetItem(dw_1.GetRow(),"acc2_cd",snull)
		dw_1.SetItem(dw_1.GetRow(),"accname",snull)
		dw_1.SetColumn("acc1_cd")
		dw_1.SetFocus()
		Return 
	ELSE
		IF syu_chk <> "Y" THEN
			sle_msg.text ="유가증권을 등록할 수 없는 계정입니다.!!"
			Messagebox("확 인","계정과목을 확인하세요.!!")
			dw_1.SetItem(dw_1.GetRow(),"acc1_cd",snull)
			dw_1.SetItem(dw_1.GetRow(),"acc2_cd",snull)
			dw_1.SetItem(dw_1.GetRow(),"accname",snull)
			dw_1.SetColumn("acc1_cd")
			dw_1.SetFocus()
			Return 1
		ELSE
			dw_1.SetItem(dw_1.GetRow(),"accname",ssql)
		END IF
	END IF
END IF

IF this.GetColumnName() ="jz_bald" THEN
	sColValue = this.GetText()
	if sColValue = '' or IsNull(sColValue) then Return
	
	IF f_datechk(scolvalue) = -1 THEN
		MessageBox("확  인","발행일자를 확인하세요.!!!")
		dw_1.SetItem(row,"jz_bald",snull)
		dw_1.SetColumn("jz_bald")
		Return 1
	END IF
END IF

IF this.GetColumnName() ="jz_mand" THEN
	sColValue = this.GetText()
	if sColValue = '' or IsNull(sColValue) then Return
	
	IF f_datechk(scolvalue) = -1 THEN
		MessageBox("확  인","만기일자를 확인하세요.!!!")
		dw_1.SetItem(row,"jz_mand",snull)
		dw_1.SetColumn("jz_mand")
		Return 1
	END IF
END IF

IF this.GetColumnName() ="jz_aamt" THEN	
	IF Double(this.gettext()) = 0 or IsNull(this.gettext()) THEN
		MessageBox("확  인","액면금액을 입력하세요.!!!")
		dw_1.SetColumn("jz_aamt")
		Return 1
	END IF
END IF

IF this.GetColumnName() ="jz_guid" THEN
	sColValue = this.GetText()
	if sColValue = '' or IsNull(sColValue) then Return
	
	IF f_datechk(scolvalue) = -1 THEN
		MessageBox("확  인","구매일자를 확인하세요.!!!")
		dw_1.SetItem(row,"jz_guid",snull)
		dw_1.SetColumn("jz_guid")
		Return 1
	END IF
END IF

IF this.GetColumnName() ="jz_nbr" THEN
	d_amt = this.getitemdecimal(row, "jz_aamt")
	d_nbr = Double(data)
	IF d_nbr = 0 THEN
		MessageBox("확  인","구입매수를 입력하세요.!!!")
		dw_1.SetColumn("jz_nbr")
		Return 1
	END IF
	this.setitem(row, "jz_camt", d_amt * d_nbr )
END IF

IF this.GetColumnName() ="jz_camt" THEN
	IF Double(this.GetText()) =0 THEN
		MessageBox("확  인","취득가액을 입력하세요.!!!")
		dw_1.SetColumn("jz_camt")
		Return 1
	END IF
END IF

IF this.GetColumnName() ="jz_samt" THEN
	IF dw_1.GetItemNumber(row,"jz_camt") < Double(this.GetText()) THEN
		sle_msg.text ="상환금액이 취득가액보다 크면 안됩니다.!!"
		MessageBox("확 인","상환금액을 확인하세요.!!")
		dw_1.SetItem(row,"jz_samt",0)
		dw_1.SetColumn("jz_samt")
		dw_1.Setfocus()
		Return 1
	END IF
END IF
IF this.GetColumnName() ="jz_jeng" THEN
	sColValue = this.GetText()
	if sColValue = '' or IsNull(sColValue) then Return
	
	IF scolvalue <> "Y" AND scolvalue <> "N" THEN
		f_messagechk(20,"상환완료여부")
		dw_1.SetItem(row,"jz_jeng",snull)
		dw_1.SetColumn("jz_jeng")
		Return 1
	ELSEIF scolvalue = "N" THEN
		IF dw_1.GetItemNumber(row,"jz_camt") = dw_1.GetItemNumber(row,"jz_samt")  THEN
			sle_msg.text ="취득가액과 상환금액이 같으면 상환상태는 Y여야 합니다.!!"
			MessageBox("확 인","상환완료여부를 확인하세요.!!")
			dw_1.SetItem(row,"jz_jeng",snull)
			dw_1.SetColumn("jz_jeng")
			Return 1
		END IF
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
	END IF
END IF

IF this.GetColumnName() ="jz_gbn" THEN
	sColValue = this.GetText()
	IF isnull(scolvalue) or scolvalue = "" THEN
		MessageBox("확  인","증권종류를 입력하세요.!!!")
		dw_1.SetColumn("jz_gbn")
		Return 1
	END IF
END IF
end event

event itemerror;
Return 1
end event

event rbuttondown;String snull

SetNull(snull)

this.accepttext()

//IF this.GetColumnName() ="jz_illd" THEN
//	SetNull(gs_code)
//	SetNull(gs_codename)
//
//	gs_code = Trim(dw_1.GetItemString(dw_1.GetRow(),"jz_illd"))
//	
//	IF IsNull(gs_code) THEN
//		gs_code =""
//	END IF
//	
//	OPEN(W_KFM05OT0_POPUP)
//	
//	IF Not IsNull(gs_code) THEN
//		IF dw_1.Retrieve(gs_code) <=0 THEN
//		ELSE
//			sModStatus = 'M'
//			WF_SETTING_RETRIEVEMODE(smodstatus)
//		END IF
//	END IF
//ELSE
IF this.GetColumnName() ="acc1_cd" THEN
	SetNull(lstr_account.acc1_cd)
	SetNull(lstr_account.acc2_cd)	

	lstr_account.acc1_cd = this.object.acc1_cd[getrow()]
	lstr_account.acc2_cd = this.object.acc2_cd[getrow()]

	IF IsNull(lstr_account.acc1_cd) then lstr_account.acc1_cd = ""
	IF IsNull(lstr_account.acc2_cd) then lstr_account.acc2_cd = ""

	Openwithparm(W_KFZ01OM0_POPUP_gbn, '7')
	
	IF IsNull(lstr_account.acc1_cd) AND IsNull(lstr_account.acc2_cd) THEN RETURN
	
	IF lstr_account.yu_gu ="Y" THEN
		dw_1.SetItem(this.getrow(),"acc1_cd",lstr_account.acc1_cd)
		dw_1.SetItem(this.getrow(),"acc2_cd",lstr_account.acc2_cd)

		dw_1.SetItem(this.getrow(),"accname",lstr_account.acc2_nm)
	ELSE
		MessageBox("확 인","유가증권을 등록할 수 있는 계정이 아닙니다.!!")
		dw_1.SetItem(this.getrow(),"acc1_cd",snull)
		dw_1.SetItem(this.getrow(),"acc2_cd",snull)
		dw_1.SetItem(this.getrow(),"accname",snull)
		dw_1.SetColumn("acc1_cd")
		dw_1.SetFocus()
	END IF
END IF
end event

event editchanged;ib_any_typing =True
end event

event getfocus;this.AcceptText()
end event

type dw_2 from u_d_popup_sort within w_kfia04
integer x = 238
integer y = 220
integer width = 1106
integer height = 1988
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_kfia041"
boolean vscrollbar = true
boolean border = false
end type

event rowfocuschanged;call super::rowfocuschanged;If currentrow <= 0 then
	dw_1.SelectRow(0,False)

ELSE

	SelectRow(0, FALSE)
	SelectRow(currentrow,TRUE)
	
	dw_1.ScrollToRow(currentrow)
END IF

end event

event clicked;call super::clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	dw_1.ScrollToRow(row)
	
	b_flag = False
	
//	smodstatus="M"
//	wf_setting_retrievemode(smodstatus)
END IF

CALL SUPER ::CLICKED


end event

type st_2 from statictext within w_kfia04
integer x = 293
integer y = 96
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
string text = "증권조회"
boolean focusrectangle = false
end type

type sle_1 from singlelineedit within w_kfia04
integer x = 599
integer y = 88
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

type rr_2 from roundrectangle within w_kfia04
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 229
integer y = 208
integer width = 1134
integer height = 2020
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_3 from roundrectangle within w_kfia04
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 265
integer y = 40
integer width = 987
integer height = 148
integer cornerheight = 40
integer cornerwidth = 46
end type

type ln_1 from line within w_kfia04
integer linethickness = 1
integer beginx = 603
integer beginy = 160
integer endx = 1166
integer endy = 160
end type

