$PBExportHeader$w_cia00015.srw
$PBExportComments$원가수불코드 등록
forward
global type w_cia00015 from w_inherite
end type
type dw_1 from datawindow within w_cia00015
end type
type dw_2 from datawindow within w_cia00015
end type
type sle_1 from singlelineedit within w_cia00015
end type
type st_2 from statictext within w_cia00015
end type
type rr_1 from roundrectangle within w_cia00015
end type
type rr_2 from roundrectangle within w_cia00015
end type
type ln_1 from line within w_cia00015
end type
end forward

global type w_cia00015 from w_inherite
string title = "원가수불코드 등록"
dw_1 dw_1
dw_2 dw_2
sle_1 sle_1
st_2 st_2
rr_1 rr_1
rr_2 rr_2
ln_1 ln_1
end type
global w_cia00015 w_cia00015

forward prototypes
public function integer wf_reqchk ()
public function integer wf_checkref (string l_code, string l_gubn)
public function integer wf_warndataloss (string as_titletext)
public function integer wf_dupchk (string ACC_1, string ACC_2)
end prototypes

public function integer wf_reqchk ();String siogbn, sionam, siosp

If dw_2.AcceptText() <> 1 Then Return -1

siogbn = dw_2.GetItemString(1,"iogbn")
sionam = dw_2.GetItemString(1,"ionam")
siosp = dw_2.GetItemString(1,"iosp")

IF siogbn = '' OR ISNULL(siogbn) THEN
	f_messagechk(1,'[수불코드]')
	dw_2.SetColumn("iogbn")
	dw_2.SetFocus()
	Return -1
END IF	
IF sionam = '' OR ISNULL(sionam) THEN
	f_messagechk(1,'[수불명]')
	dw_2.SetColumn("ionam")
	dw_2.SetFocus()
	Return -1
END IF	
IF siosp = '' OR ISNULL(siosp) THEN
	f_messagechk(1,'[I-O구분]')
	dw_2.SetColumn("iosp")
	dw_2.SetFocus()
	Return -1
END IF	

Return 1 
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

public function integer wf_dupchk (string ACC_1, string ACC_2);lONG sCnt

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

on w_cia00015.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_2=create dw_2
this.sle_1=create sle_1
this.st_2=create st_2
this.rr_1=create rr_1
this.rr_2=create rr_2
this.ln_1=create ln_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.sle_1
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.rr_1
this.Control[iCurrent+6]=this.rr_2
this.Control[iCurrent+7]=this.ln_1
end on

on w_cia00015.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.sle_1)
destroy(this.st_2)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.ln_1)
end on

event open;call super::open;dw_1.SetTransObject(sqlca)
dw_2.SetTransObject(sqlca)
dw_1.retrieve()

p_can.TriggerEvent(Clicked!)
end event

event key;GraphicObject which_control
string ls_string,sAcc2, sAnm,sAnm1
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
				 	sAnm= ls_string + '%'
					iRow = dw_1.Find("iogbn like '" + sAnm +"'",1,dw_1.RowCount())
				//문자 - 명칭
				Case is >= 127
					sAnm= '%' +ls_string+ '%'
					iRow = dw_1.Find("ionam like '" + sAnm +"'",1,dw_1.RowCount())
				End Choose
			End If	  
         
//			choose case ls_string
//	         case sAnm1
//				     iRow = dw_1.Find("iogbn= '" + sAnm1 +"'",1,dw_1.RowCount())
//         	case sAnm
//			        iRow = dw_1.Find("ionam= '" + sAnm +"'",1,dw_1.RowCount())
//			end choose			
        
		  if iRow > 0 then
         	dw_1.ScrollToRow(iRow)
	         dw_1.SelectRow(iRow,True)
		  else 
		      MessageBox('원가수불명선택',"선택하신 자료가 없습니다. 다시 선택하신후 작업하세요")  
	     end if	
		   
		 //dw_1.setFocus()
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

type dw_insert from w_inherite`dw_insert within w_cia00015
boolean visible = false
integer x = 123
integer y = 2544
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_cia00015
boolean visible = false
integer x = 3927
integer y = 2688
end type

type p_addrow from w_inherite`p_addrow within w_cia00015
boolean visible = false
integer x = 3753
integer y = 2688
end type

type p_search from w_inherite`p_search within w_cia00015
integer x = 3749
string picturename = "C:\Erpman\image\자료복사_up.gif"
end type

event p_search::clicked;call super::clicked;
If MessageBox("자료복사","물류의 IO MATRIX로부터 추가된 자료를 받으시겠습니까?", question!, yesno!, 2) = 2 Then 
	Return
End If
 
 INSERT INTO "CIAIOGBN"  
         ( "IOGBN",             "IONAM",              "IOSP",              "CALVALUE",   
           "STKVALUE",          "MAIPGU",             "SALEGU",            "MGUBUN",   
           "HGUBUN",            "FGUBUN",             "GGUBUN",            "EGUBUN",   
           "MTA",               "HTA",                "FTA",               "GTA",   
           "ETA",               "MPAC",               "HPAC",              "FPAC",   
           "GPAC",              "EPAC",               "MMAC",              "HMAC",   
           "FMAC",              "GMAC",               "EMAC",              "ETC1",   
           "ETC2",              "ETC3" )  
    SELECT "IOGBN",   	        "IONAM",              "IOSP",              "CALVALUE",   
           "STKVALUE",          DECODE("TYPGBN",'1','Y','N'),   	         DECODE("TYPGBN",'3','Y','N'),            'N',   
           'N',   	           'N',   	            'N',   	            'N',   
           'N',   	           'N',   	            'N',   	            'N',   
           'N',   	           NULL,   	            NULL,   	            NULL,   
           NULL,   	           NULL,   	            NULL,   	            NULL,   
           NULL,   	           NULL,   	            NULL,   	            DECODE("SUGBN",'4','Y','N'),   
           'N',   	           NULL
    FROM ERPMAN."IOMATRIX"
   WHERE NOT EXISTS ( SELECT * FROM "CIAIOGBN"
                       WHERE "IOGBN" = "IOMATRIX"."IOGBN" );

If sqlca.sqlcode <> 0 Then
	rollback;
  	w_mdi_frame.sle_msg.text = "자료 복사 도중 에러가 발생하였습니다."
Else
	Commit;
	p_can.TriggerEvent(Clicked!)
	w_mdi_frame.sle_msg.text = "자료가 복사되었습니다.!!"
End If


end event

event p_search::ue_lbuttondown;PictureName = "C:\Erpman\image\자료복사_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\Erpman\image\자료복사_up.gif"
end event

type p_ins from w_inherite`p_ins within w_cia00015
integer x = 3575
end type

event p_ins::clicked;call super::clicked;If dw_2.AcceptText() <> 1 Then Return

If dw_2.ModifiedCount() > 0 Then
	If MessageBox('확 인','변경된 사항이 있습니다~r~n계속하시겠습니까?',Question!, YesNo!,2) = 2 Then	
		Return
	End If
End If

p_can.TriggerEvent(Clicked!)
end event

type p_exit from w_inherite`p_exit within w_cia00015
end type

type p_can from w_inherite`p_can within w_cia00015
end type

event p_can::clicked;call super::clicked;
/* 조회 */
dw_1.Retrieve()
dw_2.SetRedraw(False)
dw_2.Reset()
dw_2.InsertRow(0)
dw_2.SetRedraw(True)

dw_2.SetFocus()
end event

type p_print from w_inherite`p_print within w_cia00015
boolean visible = false
integer x = 3232
integer y = 2688
end type

type p_inq from w_inherite`p_inq within w_cia00015
boolean visible = false
integer x = 3406
integer y = 2688
end type

type p_del from w_inherite`p_del within w_cia00015
end type

event p_del::clicked;call super::clicked;IF F_DbConFirm('삭제') = 2 THEN RETURN

IF wf_reqchk() = -1 THEN
	Return 
END IF	

dw_2.SetRedraw(False)
dw_2.DeleteRow(dw_2.GetRow())

IF dw_2.Update() = 1 THEN
	commit;
	ib_any_typing = False
	w_mdi_frame.sle_msg.text ="자료가 삭제되었습니다.!!!"
ELSE
	ROLLBACK;
	f_messagechk(12,'')
END IF

p_can.TriggerEvent(Clicked!)

dw_2.SetRedraw(True)
end event

type p_mod from w_inherite`p_mod within w_cia00015
end type

event p_mod::clicked;call super::clicked;String sGbn,l_acc1_cd,l_acc2_cd

IF F_DbConFirm('저장') = 2  THEN RETURN

If dw_2.AcceptText() <> 1 Then Return

IF wf_reqchk() = -1 THEN
	Return 
END IF	

//dw_2.SetItemStatus(1, 0, primary!, new!)

IF dw_2.Update() > 0	THEN
	COMMIT;															 
ELSE
	ROLLBACK;
	f_messagechk(13,'')
	Return 
END IF

//p_can.TriggerEvent(Clicked!)
w_mdi_frame.sle_msg.text = '자료를 저장하였습니다!!'
end event

type cb_exit from w_inherite`cb_exit within w_cia00015
integer x = 3063
integer y = 2680
integer taborder = 70
end type

event cb_exit::clicked;//sle_msg.text =""
IF wf_warndataloss("종료") = -1 THEN 	RETURN

close(parent)

end event

type cb_mod from w_inherite`cb_mod within w_cia00015
integer x = 2231
integer y = 2680
integer taborder = 40
end type

event cb_mod::clicked;call super::clicked;String sGbn,l_acc1_cd,l_acc2_cd

IF F_DbConFirm('저장') = 2  THEN RETURN

If dw_2.AcceptText() <> 1 Then Return

IF wf_reqchk() = -1 THEN
	Return 
END IF	

//dw_2.SetItemStatus(1, 0, primary!, new!)

IF dw_2.Update() > 0	THEN
	COMMIT USING sqlca;															 
ELSE
	ROLLBACK USING sqlca;
	f_messagechk(13,'')
	Return 
END IF

cb_can.TriggerEvent(Clicked!)
sle_msg.text = '자료를 저장하였습니다!!'
end event

type cb_ins from w_inherite`cb_ins within w_cia00015
integer x = 192
integer y = 2680
end type

event cb_ins::clicked;call super::clicked;If dw_2.AcceptText() <> 1 Then Return

If dw_2.ModifiedCount() > 0 Then
	If MessageBox('확 인','변경된 사항이 있습니다~r~n계속하시겠습니까?',Question!, YesNo!,2) = 2 Then	
		Return
	End If
End If

cb_can.TriggerEvent(Clicked!)
end event

type cb_del from w_inherite`cb_del within w_cia00015
integer x = 2587
integer y = 2680
integer taborder = 50
end type

event cb_del::clicked;call super::clicked;IF F_DbConFirm('삭제') = 2 THEN RETURN

IF wf_reqchk() = -1 THEN
	Return 
END IF	

dw_2.SetRedraw(False)
dw_2.DeleteRow(dw_2.GetRow())

IF dw_2.Update() = 1 THEN
	commit;
	ib_any_typing = False
	sle_msg.text ="자료가 삭제되었습니다.!!!"
ELSE
	ROLLBACK;
	f_messagechk(12,'')
END IF

cb_can.TriggerEvent(Clicked!)

dw_2.SetRedraw(True)
end event

type cb_inq from w_inherite`cb_inq within w_cia00015
integer x = 1275
integer y = 2696
integer taborder = 80
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

type cb_print from w_inherite`cb_print within w_cia00015
integer x = 1815
integer y = 2660
end type

type st_1 from w_inherite`st_1 within w_cia00015
end type

type cb_can from w_inherite`cb_can within w_cia00015
integer x = 2944
integer y = 2680
integer taborder = 60
end type

event cb_can::clicked;call super::clicked;
/* 조회 */
dw_1.Retrieve()
dw_2.SetRedraw(False)
dw_2.Reset()
dw_2.InsertRow(0)
dw_2.SetRedraw(True)

dw_2.SetFocus()
end event

type cb_search from w_inherite`cb_search within w_cia00015
integer x = 558
integer y = 2680
integer width = 485
integer taborder = 90
string text = "자료복사(&P)"
end type

event cb_search::clicked;call super::clicked;
If MessageBox("자료복사","물류의 IO MATRIX로부터 추가된 자료를 받으시겠습니까?", question!, yesno!, 2) = 2 Then 
	Return
End If
 
 INSERT INTO "CIAIOGBN"  
         ( "IOGBN",             "IONAM",              "IOSP",              "CALVALUE",   
           "STKVALUE",          "MAIPGU",             "SALEGU",            "MGUBUN",   
           "HGUBUN",            "FGUBUN",             "GGUBUN",            "EGUBUN",   
           "MTA",               "HTA",                "FTA",               "GTA",   
           "ETA",               "MPAC",               "HPAC",              "FPAC",   
           "GPAC",              "EPAC",               "MMAC",              "HMAC",   
           "FMAC",              "GMAC",               "EMAC",              "ETC1",   
           "ETC2",              "ETC3" )  
    SELECT "IOGBN",   	        "IONAM",              "IOSP",              "CALVALUE",   
           "STKVALUE",          "MAIPGU",   	         "SALEGU",            'Y',   
           'Y',   	           'Y',   	            'Y',   	            'Y',   
           'Y',   	           'Y',   	            'Y',   	            'Y',   
           'Y',   	           NULL,   	            NULL,   	            NULL,   
           NULL,   	           NULL,   	            NULL,   	            NULL,   
           NULL,   	           NULL,   	            NULL,   	            NULL,   
           NULL,   	           NULL
    FROM "IOMATRIX"
   WHERE NOT EXISTS ( SELECT * FROM "CIAIOGBN"
                       WHERE "IOGBN" = "IOMATRIX"."IOGBN" );

If sqlca.sqlcode <> 0 Then
	rollback;
  	sle_msg.text = "자료 복사 도중 에러가 발생하였습니다."
Else
	Commit;
	cb_can.TriggerEvent(Clicked!)
	sle_msg.text = "자료가 복사되었습니다.!!"
End If


end event

type dw_datetime from w_inherite`dw_datetime within w_cia00015
integer x = 2871
end type

type sle_msg from w_inherite`sle_msg within w_cia00015
integer width = 2487
end type



type gb_button1 from w_inherite`gb_button1 within w_cia00015
integer x = 151
integer y = 2624
integer width = 937
end type

type gb_button2 from w_inherite`gb_button2 within w_cia00015
integer x = 2190
integer y = 2624
end type

type dw_1 from datawindow within w_cia00015
integer x = 155
integer y = 208
integer width = 1243
integer height = 1992
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_cia00015_1"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;String siogbn, sionam, siosp
Long ll_Row

w_mdi_frame.sle_msg.text = ''
if row <= 0 then return

this.SelectRow(0,False)
this.SelectRow(row,True)

siogbn = GetItemString(row,"iogbn")
sionam = GetItemString(row,"ionam")
siosp  = GetItemString(row,"iosp")
			 
dw_2.SetItem(1,"iogbn",siogbn)
dw_2.SetItem(1,"ionam",sionam)
dw_2.SetItem(1,"iosp",siosp)

ll_Row = dw_2.Retrieve(siogbn)
IF ll_Row = 0 THEN
	dw_2.InsertRow(0)
END IF	


        

end event

event rowfocuschanged;If currentrow > 0 then
	this.SelectRow(0,False)
	this.SelectRow(currentrow,True)
	

	dw_2.SetRedraw(False)
	if dw_2.Retrieve(GetItemString(currentrow,"iogbn")) <=0 then
		dw_2.InsertRow(0)
		dw_2.SetItem(1,"iogbn", this.GetItemString(currentrow,"iogbn"))

	end if
	dw_2.SetRedraw(True)


END IF



end event

type dw_2 from datawindow within w_cia00015
event ue_enter pbm_dwnprocessenter
integer x = 1531
integer y = 228
integer width = 2638
integer height = 1944
integer taborder = 20
boolean bringtotop = true
string dataobject = "dw_cia00015_2"
boolean border = false
boolean livescroll = true
end type

event ue_enter;Send(Handle(this),256,9,0)
Return 1
end event

event itemerror;Return 1
end event

event itemchanged;String scod,sname,snull, s_gbn, get_nm

SetNull(snull)

w_mdi_frame.sle_msg.text =""

IF GetColumnName() = "iogbn" THEN
	s_gbn = Trim(GetText())

	IF s_gbn = "" OR IsNull(s_gbn) THEN RETURN
	
	SELECT IONAM
	  INTO :get_nm
	  FROM CIAIOGBN
	 WHERE IOGBN = :s_gbn  ;

	IF SQLCA.SQLCODE = 0 THEN
		Retrieve(s_gbn) 
		setcolumn('ionam')
		setfocus()
		ib_any_typing = FALSE
	END IF
ELSEIF GetColumnName() = "ionam" THEN
	scod = Gettext()
	if scod = "" or Isnull(scod) then 
		messagebox("필수입력","수불코드를 입력하십시요!")
		return
	end if
ELSEIF GetColumnName() = "iosp" THEN
	scod = Gettext()
	if scod = "" or Isnull(scod) then 
		messagebox("필수입력","수불코드를 입력하십시요!")
		return
	end if
END IF

//ELSEIF GetColumnName() = "maacod" THEN
//	scod = GetText()
//		
//	SELECT "KFZ01OM0"."ACC2_NM"
//		INTO :sname
//	  	FROM "KFZ01OM0"  
//	  	WHERE ( "KFZ01OM0"."ACC1_CD" = substr(:scod,1,5))AND
//		      ( "KFZ01OM0"."ACC2_CD" = substr(:scod,6,7) ) ;
//				
//	If Sqlca.Sqlcode = 0 then
//		Setitem(getrow(),"maname",sname)
//	else
//		f_messageChk(20,'[계정과목]')
//		Setitem(getrow(),"maccod",snull)
//		Setitem(getrow(),"maname",snull)
//		Return 1
//	end if
//ELSEIF GetColumnName() = "haacod" THEN
//	scod = GetText()
//		
//	SELECT "KFZ01OM0"."ACC2_NM"
//		INTO :sname
//	  	FROM "KFZ01OM0"  
//	  	WHERE ( "KFZ01OM0"."ACC1_CD" = substr(:scod,1,5))AND
//		      ( "KFZ01OM0"."ACC2_CD" = substr(:scod,6,7) ) ;
//				
//	If Sqlca.Sqlcode = 0 then
//		Setitem(getrow(),"haname",sname)
//	else
//		f_messageChk(20,'[계정과목]')
//		Setitem(getrow(),"haccod",snull)
//		Setitem(getrow(),"haname",snull)
//		Return 1
//	end if
//ELSEIF GetColumnName() = "faacod" THEN
//	scod = GetText()
//		
//	SELECT "KFZ01OM0"."ACC2_NM"
//		INTO :sname
//	  	FROM "KFZ01OM0"  
//	  	WHERE ( "KFZ01OM0"."ACC1_CD" = substr(:scod,1,5))AND
//		      ( "KFZ01OM0"."ACC2_CD" = substr(:scod,6,7) ) ;
//				
//	If Sqlca.Sqlcode = 0 then
//		Setitem(getrow(),"faname",sname)
//	else
//		f_messageChk(20,'[계정과목]')
//		Setitem(getrow(),"faccod",snull)
//		Setitem(getrow(),"faname",snull)
//		Return 1
//	end if
//ELSEIF GetColumnName() = "gaacod" THEN
//	scod = GetText()
//		
//	SELECT "KFZ01OM0"."ACC2_NM"
//		INTO :sname
//	  	FROM "KFZ01OM0"  
//	  	WHERE ( "KFZ01OM0"."ACC1_CD" = substr(:scod,1,5))AND
//		      ( "KFZ01OM0"."ACC2_CD" = substr(:scod,6,7) ) ;
//				
//	If Sqlca.Sqlcode = 0 then
//		Setitem(getrow(),"ganame",sname)
//	else
//		f_messageChk(20,'[계정과목]')
//		Setitem(getrow(),"gaccod",snull)
//		Setitem(getrow(),"ganame",snull)
//		Return 1
//	end if
//ELSEIF GetColumnName() = "eaacod" THEN
//	scod = GetText()
//		
//	SELECT "KFZ01OM0"."ACC2_NM"
//		INTO :sname
//	  	FROM "KFZ01OM0"  
//	  	WHERE ( "KFZ01OM0"."ACC1_CD" = substr(:scod,1,5))AND
//		      ( "KFZ01OM0"."ACC2_CD" = substr(:scod,6,7) ) ;
//				
//	If Sqlca.Sqlcode = 0 then
//		Setitem(getrow(),"eaname",sname)
//	else
//		f_messageChk(20,'[계정과목]')
//		Setitem(getrow(),"eaccod",snull)
//		Setitem(getrow(),"eaname",snull)
//		Return 1
//	end if
//
//
end event

event editchanged;ib_any_typing = True
end event

type sle_1 from singlelineedit within w_cia00015
integer x = 663
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

type st_2 from statictext within w_cia00015
integer x = 174
integer y = 92
integer width = 489
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "원가수불명조회"
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_cia00015
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 146
integer y = 204
integer width = 1294
integer height = 2016
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_2 from roundrectangle within w_cia00015
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 146
integer y = 36
integer width = 1106
integer height = 148
integer cornerheight = 40
integer cornerwidth = 46
end type

type ln_1 from line within w_cia00015
integer linethickness = 1
integer beginx = 672
integer beginy = 152
integer endx = 1225
integer endy = 152
end type

