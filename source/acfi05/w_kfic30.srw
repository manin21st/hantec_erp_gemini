$PBExportHeader$w_kfic30.srw
$PBExportComments$회사채등록
forward
global type w_kfic30 from w_inherite
end type
type rr_1 from roundrectangle within w_kfic30
end type
type dw_2 from datawindow within w_kfic30
end type
type cb_kfm22t from commandbutton within w_kfic30
end type
type st_2 from statictext within w_kfic30
end type
type sle_1 from singlelineedit within w_kfic30
end type
type dw_1 from u_d_popup_sort within w_kfic30
end type
type gb_1 from groupbox within w_kfic30
end type
type rr_3 from roundrectangle within w_kfic30
end type
type ln_1 from line within w_kfic30
end type
end forward

global type w_kfic30 from w_inherite
string title = "회사채 등록"
rr_1 rr_1
dw_2 dw_2
cb_kfm22t cb_kfm22t
st_2 st_2
sle_1 sle_1
dw_1 dw_1
gb_1 gb_1
rr_3 rr_3
ln_1 ln_1
end type
global w_kfic30 w_kfic30

type variables
string sCb_code
end variables

forward prototypes
public function integer wf_requirechk (integer icurrow)
end prototypes

public function integer wf_requirechk (integer icurrow);string  sCbcode,sCb_Nm,sCb_Type,sCb_Baldate
string  sCb_Mandate,sCb_Manager,sCb_Agency,sCb_Wonagen,sCb_Currgbn,sCb_Rewon,sCb_Ija
integer iCb_Billamt,iCb_Disrate,iCb_Balamt,iCb_Rate,iCb_Balrate,iCb_Baldan,iCb_Baldate,iCb_Mandate,iCb_Borate

dw_2.AcceptText()

sCbcode     = dw_2.GetItemString(icurrow,"cb_code")
sCb_Nm       = dw_2.GetItemString(icurrow,"cb_nm")
sCb_Type     = dw_2.GetItemString(icurrow,"cb_type")
iCb_Billamt  = dw_2.GetItemNumber(icurrow,"cb_billamt")
iCb_Disrate  = dw_2.GetItemNumber(icurrow,"cb_disrate")
iCb_Balamt   = dw_2.GetItemNumber(icurrow,"cb_balamt")
iCb_Rate     = dw_2.GetItemNumber(icurrow,"cb_rate")
iCb_Balrate  = dw_2.GetItemNumber(icurrow,"cb_balrate") 
iCb_Baldan   = dw_2.GetItemNumber(icurrow,"cb_baldan")
sCb_Baldate  = dw_2.GetItemString(icurrow,"cb_baldate") 
sCb_Mandate  = dw_2.GetItemString(icurrow,"cb_mandate")
sCb_Manager  = dw_2.GetItemString(icurrow,"cb_manager")
sCb_Agency   = dw_2.GetItemString(icurrow,"cb_agency")
iCb_Borate   = dw_2.GetItemNumber(icurrow,"cb_borate")
sCb_Wonagen  = dw_2.GetItemString(icurrow,"cb_wonagen") 
sCb_Currgbn  = dw_2.GetItemString(icurrow,"cb_currgbn")
sCb_Rewon    = dw_2.GetItemString(icurrow,"cb_rewon")
sCb_Ija      = dw_2.GetItemString(icurrow,"cb_ija")

IF sCbcode = "" OR IsNull(sCbcode) THEN
	F_MessageChk(1,'[회사채코드]')
	dw_2.SetColumn("cb_code")
	dw_2.SetFocus()
	Return -1
END IF

IF sCb_NM = "" OR IsNull(sCb_Nm) THEN
	F_MessageChk(1,'[회사채명]')
	dw_2.SetColumn("cb_nm")
	dw_2.SetFocus()
	Return -1
END IF

IF sCb_Type = "" OR IsNull(sCb_Type) THEN
	F_MessageChk(1,'[회사채종류]')
	dw_2.SetColumn("cb_type")
	dw_2.SetFocus()
	Return -1
END IF

IF iCb_Billamt = 0 OR IsNull(iCb_Billamt) THEN
	F_MessageChk(1,'[권면금액]')
	dw_2.SetColumn("cb_billamt")
	dw_2.SetFocus()
	Return -1
END IF

IF iCb_Disrate = 0 OR IsNull(iCb_Disrate) THEN
	F_MessageChk(1,'[발생할인율]')
	dw_2.SetColumn("cb_Disrate")
	dw_2.SetFocus()
	Return -1
END IF

IF iCb_Balamt = 0 OR IsNull(iCb_Balamt) THEN
	F_MessageChk(1,'[발행총액]')
	dw_2.SetColumn("cb_Balamt")
	dw_2.SetFocus()
	Return -1
END IF

IF iCb_Rate = 0 OR IsNull(iCb_Rate) THEN
	F_MessageChk(1,'[표면이율]')
	dw_2.SetColumn("cb_Rate")
	dw_2.SetFocus()
	Return -1
END IF

IF iCb_Balrate = 0 OR IsNull(iCb_Balrate) THEN
	F_MessageChk(1,'[발행수익율]')
	dw_2.SetColumn("cb_Balrate")
	dw_2.SetFocus()
	Return -1
END IF

IF iCb_Baldan = 0 OR IsNull(iCb_Baldan) THEN
	F_MessageChk(1,'[발행단가]')
	dw_2.SetColumn("cb_Baldan")
	dw_2.SetFocus()
	Return -1
END IF

IF sCb_Baldate = "" OR IsNull(sCb_Baldate) THEN
	F_MessageChk(1,'[발행일자]')
	dw_2.SetColumn("cb_Baldate")
	dw_2.SetFocus()
	Return -1
END IF

IF sCb_Mandate = "" OR IsNull(sCb_Mandate) THEN
	F_MessageChk(1,'[만기일자]')
	dw_2.SetColumn("cb_Mandate")
	dw_2.SetFocus()
	Return -1
END IF

IF sCb_Manager = "" OR IsNull(sCb_Manager) THEN
	F_MessageChk(1,'[주간사]')
	dw_2.SetColumn("cb_Manager")
	dw_2.SetFocus()
	Return -1
END IF

IF sCb_Agency = "" OR IsNull(sCb_Agency) THEN
	F_MessageChk(1,'[보증기관]')
	dw_2.SetColumn("cb_Agency")
	dw_2.SetFocus()
	Return -1
END IF

IF iCb_Borate = 0 OR IsNull(iCb_Borate) THEN
	F_MessageChk(1,'[보증요율]')
	dw_2.SetColumn("cb_Borate")
	dw_2.SetFocus()
	Return -1
END IF

IF sCb_Wonagen = "" OR IsNull(sCb_Wonagen) THEN
	F_MessageChk(1,'[원리금지급대행기관]')
	dw_2.SetColumn("cb_Wonagen")
	dw_2.SetFocus()
	Return -1
END IF

IF sCb_Currgbn = "" OR IsNull(sCb_Currgbn) THEN
	F_MessageChk(1,'[통화구분]')
	dw_2.SetColumn("cb_Currgbn")
	dw_2.SetFocus()
	Return -1
END IF

IF sCb_Rewon = "" OR IsNull(sCb_Rewon) THEN
	F_MessageChk(1,'[원금상환방법]')
	dw_2.SetColumn("cb_Rewon")
	dw_2.SetFocus()
	Return -1
END IF

IF sCb_Ija = "" OR IsNull(sCb_Ija) THEN
	F_MessageChk(1,'[이자지급방법]')
	dw_2.SetColumn("cb_ija")
	dw_2.SetFocus()
	Return -1
END IF

return 1
end function

on w_kfic30.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.dw_2=create dw_2
this.cb_kfm22t=create cb_kfm22t
this.st_2=create st_2
this.sle_1=create sle_1
this.dw_1=create dw_1
this.gb_1=create gb_1
this.rr_3=create rr_3
this.ln_1=create ln_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.cb_kfm22t
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.sle_1
this.Control[iCurrent+6]=this.dw_1
this.Control[iCurrent+7]=this.gb_1
this.Control[iCurrent+8]=this.rr_3
this.Control[iCurrent+9]=this.ln_1
end on

on w_kfic30.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.dw_2)
destroy(this.cb_kfm22t)
destroy(this.st_2)
destroy(this.sle_1)
destroy(this.dw_1)
destroy(this.gb_1)
destroy(this.rr_3)
destroy(this.ln_1)
end on

event open;call super::open;string  sCb_cod
integer iRow,ll_row,ls_row

dw_1.SetTransObJect(sqlca)
dw_2.SetTransObJect(sqlca)
dw_1.sharedata(dw_2)
if dw_1.retrieve() < 1 then
	dw_2.insertrow(0)
	dw_2.setfocus()
end if
//ls_row = dw_1.Retrieve()
////dw_2.InsertRow(0)
//
//if ls_row > 0 then 
//	dw_1.SelectRow(0,False)
//   dw_1.SelectRow(1,True)
//
//   sCb_cod = dw_1.GetItemString(1,"cb_code")
//			 
//   dw_2.SetItem(1,"cb_code",sCb_cod)
//
//   ll_Row = dw_2.Retrieve(sCb_cod)
//   IF ll_Row = 0 THEN
//	   dw_2.InsertRow(0)
//   END IF	
//else
//	dw_2.InsertRow(0)
//   dw_2.SetColumn("cb_code")
//   dw_2.SetFocus()	
//end if
//cb_del.Enabled = False
p_inq.Enabled = False
p_inq.PictureName = "C:\erpman\image\조회_d.gif"


end event

event key;call super::key;GraphicObject which_control
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
          
				 scode = ls_string + '%'
				 iRow = dw_1.Find("cb_code like '" + scode +"'",1,dw_1.RowCount())
							
				//문자 - 명칭
				Case is >= 127
					sname = '%' + ls_string + '%'
					iRow = dw_1.Find("cb_nm like '" + sname +"'",1,dw_1.RowCount())
				End Choose
			End If	
			    
        if iRow > 0 then
         	dw_1.ScrollToRow(iRow)
	         dw_1.SelectRow(iRow,True)
		  else 
		      MessageBox('어음번호선택',"선택하신 자료가 없습니다. 다시 선택하신후 작업하세요")  
	     end if	
		   
		 //dw_1.setFocus()
		 sle_1.text=""
	  End Choose
   end if
end if
end event

type dw_insert from w_inherite`dw_insert within w_kfic30
boolean visible = false
integer x = 101
integer y = 2752
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kfic30
boolean visible = false
integer x = 3799
integer y = 2776
end type

type p_addrow from w_inherite`p_addrow within w_kfic30
boolean visible = false
integer x = 3625
integer y = 2776
end type

type p_search from w_inherite`p_search within w_kfic30
integer x = 3621
integer width = 306
integer taborder = 130
boolean originalsize = true
string picturename = "C:\Erpman\image\상환계획등록_up.gif"
boolean focusrectangle = true
end type

event p_search::clicked;call super::clicked;string sCb_Cod,sCb_Nm  

SetNull(sCb_Nm)

sCb_Cod = dw_2.GetItemString(dw_2.GetRow(),"cb_code")

	SELECT "KFM22M"."CB_NM" INTO :sCb_Nm
	             FROM "KFM22M"
					WHERE "KFM22M"."CB_CODE" = :sCb_Cod;

IF sCb_Nm = "" OR IsNull(sCb_Nm) then
	F_MessageChk(14,'[저장 후 작업]')
	dw_2.SetColumn("cb_code")
	dw_2.SetFocus()
	Return -1
END IF

IF sCb_Cod = "" OR IsNull(sCb_Cod) then
	F_MessageChk(1,'[회사채코드]')
	dw_2.SetColumn("cb_code")
	dw_2.SetFocus()
	Return -1
END IF

OpenWithParm(W_Kfic32,sCb_Cod)


end event

event p_search::ue_lbuttondown;PictureName = "C:\Erpman\image\상환계획등록_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\Erpman\image\상환계획등록_up.gif"
end event

type p_ins from w_inherite`p_ins within w_kfic30
integer x = 3451
end type

event p_ins::clicked;call super::clicked;long    iCurRow,iCurRow1
integer iFunctionValue

  IF dw_1.RowCount() > 0 THEN
	  iFunctionValue = Wf_RequireChk(dw_2.GetRow())
	  IF iFunctionValue <> 1 THEN RETURN
  ELSE
  	iFunctionValue = 1	
  END IF

  IF iFunctionValue = 1 THEN

	  iCurRow = dw_2.InsertRow(0)

	  dw_2.ScrollToRow(iCurRow)
		
	  dw_2.SetColumn("cb_code")
	  dw_2.SetFocus()

	  dw_2.SetItem(dw_2.GetRow(),"cb_billamt",0)
	  dw_2.SetItem(dw_2.GetRow(),"cb_disrate",0)
	  dw_2.SetItem(dw_2.GetRow(),"cb_balamt",0)
	  dw_2.SetItem(dw_2.GetRow(),"cb_rate",0)
	  dw_2.SetItem(dw_2.GetRow(),"cb_balrate",0)
	  dw_2.SetItem(dw_2.GetRow(),"cb_baldan",0)
	  dw_2.SetItem(dw_2.GetRow(),"cb_borate",0)
	  dw_2.SetItem(dw_2.GetRow(),"cb_junamt",0)
	  dw_2.SetItem(dw_2.GetRow(),"cb_manrate",0)
	  dw_2.SetItem(dw_2.GetRow(),"cb_insurate",0)
	  dw_2.SetItem(dw_2.GetRow(),"cb_baserate",0)
	
	
//	  iCurRow1 = dw_1.InsertRow(0)
	  dw_1.ScrollToRow(iCurRow)
	
	  dw_1.SelectRow(0,False)
	  dw_1.SelectRow(iCurRow,True)

     p_del.Enabled =True
	  p_del.PictureName = "C:\erpman\image\삭제_up.gif"

 END IF
//	dw_2.Setitem(iCurRow,"sflag",'0')
	
	
end event

type p_exit from w_inherite`p_exit within w_kfic30
integer taborder = 110
end type

type p_can from w_inherite`p_can within w_kfic30
integer taborder = 90
end type

event p_can::clicked;call super::clicked;string  sCb_Cd
integer ll_row

w_mdi_frame.sle_msg.text =""

dw_2.SetReDraw(False)
dw_2.Reset()
dw_1.Reset()

ll_row = dw_1.Retrieve()

if ll_row > 0 then
   dw_1.SelectRow(0,False)
   dw_1.SelectRow(1,True)
   sCb_Cd = dw_1.GetItemString(dw_1.GetRow(),"cb_code")

   dw_2.SetReDraw(False)
   dw_2.Reset()
	dw_2.Retrieve(sCb_Cd)
   p_del.Enabled =True
	p_del.PictureName = "C:\erpman\image\삭제_up.gif"
else
   dw_2.InsertRow(0)
   dw_2.SetColumn("cb_code")
   dw_2.SetFocus()	
   p_del.Enabled =False
	p_del.PictureName = "C:\erpman\image\삭제_d.gif"
end if

dw_2.SetReDraw(True)


end event

type p_print from w_inherite`p_print within w_kfic30
boolean visible = false
integer x = 3447
integer y = 2776
integer taborder = 140
end type

type p_inq from w_inherite`p_inq within w_kfic30
boolean visible = false
integer x = 2327
integer taborder = 0
end type

event p_inq::clicked;call super::clicked;String sCbcode
Long ll_Row

dw_2.AcceptText()

sCbcode  = dw_2.GetItemString(1,"cb_code")
ll_Row = dw_2.Retrieve(sCbcode)
IF ll_Row = 0 THEN
	dw_2.InsertRow(0)
END IF	

p_del.Enabled =True
p_del.PictureName = "C:\erpman\image\삭제_up.gif"

end event

type p_del from w_inherite`p_del within w_kfic30
integer taborder = 70
end type

event p_del::clicked;call super::clicked;Integer k,IRow,ll_row
string sCb_Cd,sDel_Cd
IF dw_2.GetRow() <= 0 THEN
	f_messagechk(11,'')
	Return 
END IF

IF F_DbConFirm('삭제') = 2 THEN RETURN

sDel_Cd = dw_2.GetItemString(dw_2.GetRow(),"cb_code")
dw_2.DeleteRow(0)

IF dw_2.Update() = 1 THEN

	DELETE FROM "KFM22T" WHERE "KFM22T"."CB_CODE" = :sDel_Cd;
	commit;
	
	w_mdi_frame.sle_msg.text ="자료가 삭제되었습니다.!!!"

   dw_2.SetReDraw(False)
   dw_2.Reset()
   dw_1.Reset()

   ll_row = dw_1.Retrieve()
   if ll_row > 0 then
      dw_1.SelectRow(0,False)
      dw_1.SelectRow(1,True)

      sCb_Cd = dw_1.GetItemString(dw_1.GetRow(),"cb_code")

  	   dw_2.SetReDraw(False)
      dw_2.Reset()
	   dw_2.Retrieve(sCb_Cd)
	else
      dw_2.InsertRow(0)
	end if
   dw_2.SetColumn("cb_code")
   dw_2.SetFocus()	
	dw_2.SetReDraw(True)

ELSE
	ROLLBACK;
	f_messagechk(12,'')
END IF

end event

type p_mod from w_inherite`p_mod within w_kfic30
end type

event p_mod::clicked;call super::clicked;Integer k,iRtnValue,iFunctionValue
string  sSflag,sCb_Cd

  IF dw_2.AcceptText() = -1 THEN Return

  IF dw_2.RowCount() > 0 THEN
	  iFunctionValue = Wf_RequireChk(dw_2.GetRow())
	  IF iFunctionValue <> 1 THEN RETURN
  ELSE
  	iFunctionValue = 1	
  END IF

  IF iFunctionValue = 1 THEN
     IF f_dbConFirm('저장') = 2 THEN RETURN

      IF dw_2.Update() = 1 THEN
	      commit;
	
         dw_1.Reset()
         dw_1.Retrieve()
         dw_1.SelectRow(0,False)
         dw_1.SelectRow(1,True)

         sCb_Cd = dw_1.GetItemString(dw_1.GetRow(),"cb_code")
         w_mdi_frame.sle_msg.text ="자료가 저장되었습니다.!!!"

  	      dw_2.SetReDraw(False)
         dw_2.Reset()          /*입력후 clear*/
         if Not IsNull(sCb_Cd) then
				dw_2.Retrieve(sCb_Cd)
			else
           dw_2.InsertRow(0)
		   end if

       		
			p_ins.Enabled = True
			p_ins.PictureName = "C:\erpman\image\추가_up.gif"
			p_inq.Enabled = False
			p_inq.PictureName = "C:\erpman\image\조회_d.gif"
			
         dw_2.SetReDraw(True) 
     ELSE
	      ROLLBACK;
	     f_messagechk(13,'') 
   END IF
END IF

end event

type cb_exit from w_inherite`cb_exit within w_kfic30
boolean visible = false
integer x = 3232
integer y = 2592
integer taborder = 100
end type

type cb_mod from w_inherite`cb_mod within w_kfic30
boolean visible = false
integer x = 2149
integer y = 2592
end type

event cb_mod::clicked;call super::clicked;Integer k,iRtnValue,iFunctionValue
string  sSflag,sCb_Cd

  IF dw_2.AcceptText() = -1 THEN Return

  IF dw_2.RowCount() > 0 THEN
	  iFunctionValue = Wf_RequireChk(dw_2.GetRow())
	  IF iFunctionValue <> 1 THEN RETURN
  ELSE
  	iFunctionValue = 1	
  END IF

  IF iFunctionValue = 1 THEN
     IF f_dbConFirm('저장') = 2 THEN RETURN

      IF dw_2.Update() = 1 THEN
	      commit;
	
         dw_1.Reset()
         dw_1.Retrieve()
         dw_1.SelectRow(0,False)
         dw_1.SelectRow(1,True)

         sCb_Cd = dw_1.GetItemString(dw_1.GetRow(),"cb_code")
         sle_msg.text ="자료가 저장되었습니다.!!!"

  	      dw_2.SetReDraw(False)
         dw_2.Reset()          /*입력후 clear*/
         if Not IsNull(sCb_Cd) then
				dw_2.Retrieve(sCb_Cd)
			else
           dw_2.InsertRow(0)
		   end if

         cb_ins.Enabled = True
         cb_inq.Enabled = False
         dw_2.SetReDraw(True) 
     ELSE
	      ROLLBACK;
	     f_messagechk(13,'') 
   END IF
END IF

end event

type cb_ins from w_inherite`cb_ins within w_kfic30
boolean visible = false
integer x = 443
integer y = 2592
string text = "추가(&A)"
end type

event cb_ins::clicked;call super::clicked;long    iCurRow,iCurRow1
integer iFunctionValue

  IF dw_1.RowCount() > 0 THEN
	  iFunctionValue = Wf_RequireChk(dw_2.GetRow())
	  IF iFunctionValue <> 1 THEN RETURN
  ELSE
  	iFunctionValue = 1	
  END IF

  IF iFunctionValue = 1 THEN

	  iCurRow = dw_2.InsertRow(0)

	  dw_2.ScrollToRow(iCurRow)
		
	  dw_2.SetColumn("cb_code")
	  dw_2.SetFocus()

	  dw_2.SetItem(dw_2.GetRow(),"cb_billamt",0)
	  dw_2.SetItem(dw_2.GetRow(),"cb_disrate",0)
	  dw_2.SetItem(dw_2.GetRow(),"cb_balamt",0)
	  dw_2.SetItem(dw_2.GetRow(),"cb_rate",0)
	  dw_2.SetItem(dw_2.GetRow(),"cb_balrate",0)
	  dw_2.SetItem(dw_2.GetRow(),"cb_baldan",0)
	  dw_2.SetItem(dw_2.GetRow(),"cb_borate",0)
	  dw_2.SetItem(dw_2.GetRow(),"cb_junamt",0)
	  dw_2.SetItem(dw_2.GetRow(),"cb_manrate",0)
	  dw_2.SetItem(dw_2.GetRow(),"cb_insurate",0)
	  dw_2.SetItem(dw_2.GetRow(),"cb_baserate",0)
	
	
	  iCurRow1 = dw_1.InsertRow(0)
	  dw_1.ScrollToRow(iCurRow1)
	
	  dw_1.SelectRow(0,False)
	  dw_1.SelectRow(iCurRow1,True)

     cb_del.Enabled = True

 END IF
//	dw_2.Setitem(iCurRow,"sflag",'0')
	
	
end event

type cb_del from w_inherite`cb_del within w_kfic30
boolean visible = false
integer x = 2510
integer y = 2592
end type

event cb_del::clicked;call super::clicked;Integer k,IRow,ll_row
string sCb_Cd,sDel_Cd
IF dw_2.GetRow() <= 0 THEN
	f_messagechk(11,'')
	Return 
END IF

IF F_DbConFirm('삭제') = 2 THEN RETURN

sDel_Cd = dw_2.GetItemString(dw_2.GetRow(),"cb_code")
dw_2.DeleteRow(0)

IF dw_2.Update() = 1 THEN

	DELETE FROM "KFM22T" WHERE "KFM22T"."CB_CODE" = :sDel_Cd;
	commit;
	
	sle_msg.text ="자료가 삭제되었습니다.!!!"

   dw_2.SetReDraw(False)
   dw_2.Reset()
   dw_1.Reset()

   ll_row = dw_1.Retrieve()
   if ll_row > 0 then
      dw_1.SelectRow(0,False)
      dw_1.SelectRow(1,True)

      sCb_Cd = dw_1.GetItemString(dw_1.GetRow(),"cb_code")

  	   dw_2.SetReDraw(False)
      dw_2.Reset()
	   dw_2.Retrieve(sCb_Cd)
	else
      dw_2.InsertRow(0)
	end if
   dw_2.SetColumn("cb_code")
   dw_2.SetFocus()	
	dw_2.SetReDraw(True)

ELSE
	ROLLBACK;
	f_messagechk(12,'')
END IF

end event

type cb_inq from w_inherite`cb_inq within w_kfic30
boolean visible = false
integer x = 87
integer y = 2592
integer taborder = 80
end type

event cb_inq::clicked;call super::clicked;String sCbcode
Long ll_Row

dw_2.AcceptText()

sCbcode  = dw_2.GetItemString(1,"cb_code")
ll_Row = dw_2.Retrieve(sCbcode)
IF ll_Row = 0 THEN
	dw_2.InsertRow(0)
END IF	

cb_del.Enabled = True

end event

type cb_print from w_inherite`cb_print within w_kfic30
integer x = 1015
integer y = 2960
end type

type st_1 from w_inherite`st_1 within w_kfic30
end type

type cb_can from w_inherite`cb_can within w_kfic30
boolean visible = false
integer x = 2871
integer y = 2592
integer taborder = 60
end type

event cb_can::clicked;call super::clicked;string  sCb_Cd
integer ll_row

sle_msg.text =""

dw_2.SetReDraw(False)
dw_2.Reset()
dw_1.Reset()

ll_row = dw_1.Retrieve()

if ll_row > 0 then
   dw_1.SelectRow(0,False)
   dw_1.SelectRow(1,True)
   sCb_Cd = dw_1.GetItemString(dw_1.GetRow(),"cb_code")

   dw_2.SetReDraw(False)
   dw_2.Reset()
	dw_2.Retrieve(sCb_Cd)
   cb_del.Enabled = True
else
   dw_2.InsertRow(0)
   dw_2.SetColumn("cb_code")
   dw_2.SetFocus()	
   cb_del.Enabled = False
end if

dw_2.SetReDraw(True)


end event

type cb_search from w_inherite`cb_search within w_kfic30
integer x = 1367
integer y = 2956
end type







type gb_button1 from w_inherite`gb_button1 within w_kfic30
boolean visible = false
integer x = 46
integer y = 2536
end type

type gb_button2 from w_inherite`gb_button2 within w_kfic30
boolean visible = false
integer x = 2112
integer y = 2516
end type

type rr_1 from roundrectangle within w_kfic30
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 334
integer y = 216
integer width = 1399
integer height = 1952
integer cornerheight = 40
integer cornerwidth = 46
end type

type dw_2 from datawindow within w_kfic30
event ue_key pbm_dwnkey
event ue_enterkey pbm_dwnprocessenter
integer x = 1746
integer y = 188
integer width = 2665
integer height = 2116
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_kfic30_b"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_key;IF keydown(keyF1!) or keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF

end event

event ue_enterkey;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;String sCbCode,sCb_Type,sCb_Type_Nm,sCb_Wonagen,sCb_Wonagen_Nm 
String sNull,sCb_Manager,sCb_Manager_Nm,sCb_Agency,sCb_Agency_Nm
String sCb_BalDate,sCb_ManDate,sCb_Jsdate,sCb_Nm
Long ll_Row

SetNull(sNull)

THIS.AcceptText()

IF this.GetColumnName() = "cb_code" THEN
	sCbCode = this.GetText() 
   if sCbCode = '' or isnull(sCbCode) then return
   SELECT "KFM22M"."CB_NM"
	  INTO :sCb_nm
	  FROM "KFM22M"
	 WHERE "KFM22M"."CB_CODE" = :sCbCode;
    If Sqlca.Sqlcode = 0 then
  		f_messagechk(10,'[회사채코드]')
		Return 1
	 END IF	
END IF

IF this.GetColumnName() = "cb_type" THEN         /*회사채종류*/         
   sCb_Type = this.GetText()
		
   SELECT "REFFPF"."RFGUB"
     INTO :sCb_Type_Nm
     FROM "REFFPF"  
    WHERE "REFFPF"."RFCOD" ='FB' AND
          "REFFPF"."RFGUB" =:sCb_Type  ; 

   If Sqlca.Sqlcode <> 0 then
		f_messagechk(20,'[회사채 종류]')
      this.Setitem(this.getrow(),"cb_type",sNull)
		Return 1
	END IF	
END IF

IF this.GetColumnName() = "cb_manager" THEN         /*주간사*/         
   sCb_Manager = this.GetText()
	
	if scb_manager = ''  or isnull(scb_manager) then 
		this.Setitem(this.getrow(),"cb_manager_nm",sNull)
		Return 
	end if

   SELECT "KFZ04OM0"."PERSON_NM"
     INTO :sCb_Manager_Nm
     FROM "KFZ04OM0"  
    WHERE "KFZ04OM0"."PERSON_CD" = :sCb_Manager
	   AND "KFZ04OM0"."PERSON_GU" = '2';
   If Sqlca.Sqlcode = 0 then
	      this.Setitem(this.getrow(),"cb_manager_nm",sCb_Manager_Nm)
	else
//  		f_messagechk(11,'[주간사]')
      this.Setitem(this.getrow(),"cb_manager",sNull)
      this.Setitem(this.getrow(),"cb_manager_nm",sNull)
		Return 
	END IF	
END IF

IF this.GetColumnName() = "cb_baldate" THEN
   sCb_Baldate = this.GetText()
END IF

IF this.GetColumnName() = "cb_mandate" THEN
   sCb_Mandate = this.GetText()

   if sCb_Baldate > sCb_Mandate then
  		f_messagechk(21,'[발행일>만기일]')
      this.Setitem(this.getrow(),"cb_mandate",sNull)
		return 1
   end if
END IF

IF this.GetColumnName() = "cb_jsdate" THEN         /*중도상환일 비교*/         
   sCb_JsDate = this.GetText()
	IF sCb_JsDate = '' OR ISNULL(sCb_JsDate)  THEN  RETURN

//   sCb_Baldate = this.GetItemString(this.GetRow(),"cb_baldate")
   if sCb_Baldate > sCb_Jsdate then
  		f_messagechk(21,'[발행일>중도상환일]')
      this.Setitem(this.getrow(),"cb_jsdate",sNull)
		return 1
   end if

   if sCb_Mandate < sCb_Jsdate then
  		f_messagechk(21,'[만기일<중도상환일]')
      this.Setitem(this.getrow(),"cb_jsdate",sNull)
		return 1
   end if
END IF

IF this.GetColumnName() = "cb_agency" THEN         /*보증기관*/         
   sCb_Agency = this.GetText()
	IF sCb_Agency = '' OR ISNULL(sCb_Agency)  THEN  
		this.Setitem(this.getrow(),"cb_agency_nm",sNull)
		Return
   END IF
	
   SELECT "KFZ04OM0"."PERSON_NM"
     INTO :sCb_Agency_Nm
     FROM "KFZ04OM0"  
    WHERE "KFZ04OM0"."PERSON_CD" = :sCb_Agency
	   AND "KFZ04OM0"."PERSON_GU" = '2';
   If Sqlca.Sqlcode = 0 then
	      this.Setitem(this.getrow(),"cb_agency_nm",sCb_Agency_Nm)
	else
//  		f_messagechk(11,'[보증기관]')
      this.Setitem(this.getrow(),"cb_agency",sNull)
      this.Setitem(this.getrow(),"cb_agency_nm",sNull)
		Return 
	END IF	
END IF

IF this.GetColumnName() = "cb_wonagen" THEN         /*원리금지급대행기관*/         
   sCb_Wonagen = this.GetText()
	IF sCb_Wonagen = '' OR ISNULL(sCb_Wonagen)  THEN  
		this.Setitem(this.getrow(),"cb_wonagen_nm",sNull)
		Return
	END IF
	
   SELECT "KFZ04OM0"."PERSON_NM"
     INTO :sCb_Wonagen_Nm
     FROM "KFZ04OM0"  
    WHERE "KFZ04OM0"."PERSON_CD" = :sCb_Wonagen
	   AND "KFZ04OM0"."PERSON_GU" = '2';
   If Sqlca.Sqlcode = 0 then
	      this.Setitem(this.getrow(),"cb_wonagen_nm",sCb_Wonagen_Nm)
	else
//  		f_messagechk(11,'[대행기관]')
      this.Setitem(this.getrow(),"cb_wonagen",sNull)
      this.Setitem(this.getrow(),"cb_wonagen_nm",sNull)
		Return 
	END IF	
END IF

end event

event rbuttondown;this.accepttext()

SetNUll(lstr_custom.code)
SetNUll(lstr_custom.name)

IF this.GetColumnName() = "cb_manager" THEN
	
   lstr_custom.code = this.GetItemString(this.GetRow(),"cb_manager")
	IF IsNull(lstr_custom.code) THEN lstr_custom.code = ''

	OpenWithParm(w_kfz04om0_popup, '2')
	
   if Not IsNUll(lstr_custom.code) then
	   this.SetItem(this.GetRow(),'cb_manager', lstr_custom.code)
		this.SetItem(this.GetRow(),'cb_manager_nm', lstr_custom.name)
//      this.TriggerEvent(ItemChanged!)
	end if
	return
END IF
	
IF this.GetColumnName() = "cb_agency" THEN
	
   lstr_custom.code = this.GetItemString(this.GetRow(),"cb_agency")
	IF IsNull(lstr_custom.code) THEN lstr_custom.code = ''

	OpenWithParm(w_kfz04om0_popup, '2')
	
   if Not IsNUll(lstr_custom.code) then
      this.SetItem(this.GetRow(),'cb_agency', lstr_custom.code)
		this.SetItem(this.GetRow(),'cb_agency_nm', lstr_custom.name)
//      this.TriggerEvent(ItemChanged!)
	end if
	return
END IF
	
IF this.GetColumnName() = "cb_wonagen" THEN
	
   lstr_custom.code = this.GetItemString(this.GetRow(),"cb_wonagen")
	IF IsNull(lstr_custom.code) THEN lstr_custom.code = ''

	OpenWithParm(w_kfz04om0_popup, '2')
	
   if Not IsNUll(lstr_custom.code) then
      this.SetItem(this.GetRow(),'cb_wonagen', lstr_custom.code)
		this.SetItem(this.GetRow(),'cb_wonagen_nm', lstr_custom.name)
//      this.TriggerEvent(ItemChanged!)
   end if
	return
END IF

end event

event itemerror;return 1
end event

type cb_kfm22t from commandbutton within w_kfic30
boolean visible = false
integer x = 1266
integer y = 2592
integer width = 498
integer height = 108
integer taborder = 120
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "상환계획등록"
end type

event clicked;string sCb_Cod,sCb_Nm  

SetNull(sCb_Nm)

sCb_Cod = dw_2.GetItemString(dw_2.GetRow(),"cb_code")

	SELECT "KFM22M"."CB_NM" INTO :sCb_Nm
	             FROM "KFM22M"
					WHERE "KFM22M"."CB_CODE" = :sCb_Cod;

IF sCb_Nm = "" OR IsNull(sCb_Nm) then
	F_MessageChk(14,'[저장 후 작업]')
	dw_2.SetColumn("cb_code")
	dw_2.SetFocus()
	Return -1
END IF

IF sCb_Cod = "" OR IsNull(sCb_Cod) then
	F_MessageChk(1,'[회사채코드]')
	dw_2.SetColumn("cb_code")
	dw_2.SetFocus()
	Return -1
END IF

OpenWithParm(W_Kfic32,sCb_Cod)


end event

type st_2 from statictext within w_kfic30
integer x = 361
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
string text = "회사채조회"
boolean focusrectangle = false
end type

type sle_1 from singlelineedit within w_kfic30
integer x = 667
integer y = 88
integer width = 567
integer height = 64
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
boolean border = false
textcase textcase = upper!
end type

type dw_1 from u_d_popup_sort within w_kfic30
integer x = 338
integer y = 224
integer width = 1376
integer height = 1924
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_kfic30_a"
boolean border = false
end type

event clicked;call super::clicked;If Row <= 0 then
	dw_2.SelectRow(0,False)
	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	dw_2.ScrollToRow(row)

//	Lb_AutoFlag = False
	
	b_flag = False
	
//	smodstatus="M"
//	wf_setting_retrievemode(smodstatus)
END IF

CALL SUPER ::CLICKED


end event

event rowfocuschanged;call super::rowfocuschanged;If currentrow <= 0 then
	dw_2.SelectRow(0,False)

ELSE
   
	
	SelectRow(0, FALSE)
	SelectRow(currentrow,TRUE)
	
	dw_2.ScrollToRow(currentrow)
	
END IF
end event

type gb_1 from groupbox within w_kfic30
boolean visible = false
integer x = 1216
integer y = 2536
integer width = 608
integer height = 192
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

type rr_3 from roundrectangle within w_kfic30
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 334
integer y = 40
integer width = 987
integer height = 148
integer cornerheight = 40
integer cornerwidth = 46
end type

type ln_1 from line within w_kfic30
integer linethickness = 1
integer beginx = 672
integer beginy = 156
integer endx = 1234
integer endy = 156
end type

