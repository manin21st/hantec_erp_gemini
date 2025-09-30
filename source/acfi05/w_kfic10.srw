$PBExportHeader$w_kfic10.srw
$PBExportComments$리스대장 등록
forward
global type w_kfic10 from w_inherite
end type
type gb_button3 from groupbox within w_kfic10
end type
type cb_1 from commandbutton within w_kfic10
end type
type dw_print from datawindow within w_kfic10
end type
type dw_1 from datawindow within w_kfic10
end type
type p_1 from uo_picture within w_kfic10
end type
type dw_2 from u_d_popup_sort within w_kfic10
end type
type st_2 from statictext within w_kfic10
end type
type sle_1 from singlelineedit within w_kfic10
end type
type rr_2 from roundrectangle within w_kfic10
end type
type rr_3 from roundrectangle within w_kfic10
end type
type ln_1 from line within w_kfic10
end type
end forward

global type w_kfic10 from w_inherite
string title = "리스대장등록"
gb_button3 gb_button3
cb_1 cb_1
dw_print dw_print
dw_1 dw_1
p_1 p_1
dw_2 dw_2
st_2 st_2
sle_1 sle_1
rr_2 rr_2
rr_3 rr_3
ln_1 ln_1
end type
global w_kfic10 w_kfic10

forward prototypes
public function integer wf_requiredchk ()
public function integer wf_kfz04om0_update ()
public function integer wf_update_etc (string slsno)
end prototypes

public function integer wf_requiredchk ();string slsno, slsco, slsgydate, slsshdate, slsmadate

if dw_1.accepttext() = -1 then return -1 

slsno = dw_1.getitemstring(dw_1.getrow(), "lsno")
slsco = dw_1.getitemstring(dw_1.getrow(), "lsco")
slsgydate = dw_1.getitemstring(dw_1.getrow(), "lsgydate")
slsmadate = dw_1.getitemstring(dw_1.getrow(), "lsmadate")

if slsno = "" or isnull(slsno) then
	messagebox("확인", "자사리스번호를 입력하십시오.")
	dw_1.setcolumn("lsno")
	dw_1.setfocus()
	return -1
end if

if slsco = "" or isnull(slsco) then
	messagebox("확인", "리스회사를 입력하십시오.")
	dw_1.setcolumn("lsco")
	dw_1.setfocus()
	return -1
end if

if slsgydate = "" or isnull(slsgydate) then
	messagebox("확인", "리스계약일을 입력하십시오.")
	dw_1.setcolumn("lsgydate")
	dw_1.setfocus()
	return -1
end if

if slsmadate = "" or isnull(slsmadate) then
	messagebox("확인", "리스만기일을 입력하십시오.")
	dw_1.setcolumn("lsmadate")
	dw_1.setfocus()
	return -1
end if

return 1
end function

public function integer wf_kfz04om0_update ();String scode,sname,sgu,sbnkcd

dw_1.AcceptText()

scode  =dw_1.GetItemString(dw_1.GetRow(),"lsno")
sname  =dw_1.GetItemString(dw_1.GetRow(),"lsgyno")
sbnkcd =dw_1.GetItemString(dw_1.GetRow(),"lscono")
sgu ='11'

IF f_mult_custom(scode,sname,sgu,'',sbnkcd,'','','') = -1 THEN RETURN -1

Return 1
end function

public function integer wf_update_etc (string slsno);String sDate

dw_1.AcceptText()
sDate = dw_1.GetItemString(dw_1.getrow(),"lshjdate")
IF sDate = '' OR IsNull(sDate) THEN 						/*상환계획.자료상태 = NULL*/
	UPDATE "KFM20T2"  
   	SET "ETC1" = null  
   	WHERE ( "KFM20T2"."LSNO" = :slsno ) ;

ELSE																	/*상환계획.자료상태 = '1'(해지)*/
	UPDATE "KFM20T2"  
   	SET "ETC1" = '1' 
   	WHERE ( "KFM20T2"."LSNO" = :slsno ) and
				( "KFM20T2"."SHDATE" >= :sDate) ;
	
END IF
IF SQLCA.SQLCODE = 0 THEN
	Return 1
ELSE
	Return -1
END IF
end function

on w_kfic10.create
int iCurrent
call super::create
this.gb_button3=create gb_button3
this.cb_1=create cb_1
this.dw_print=create dw_print
this.dw_1=create dw_1
this.p_1=create p_1
this.dw_2=create dw_2
this.st_2=create st_2
this.sle_1=create sle_1
this.rr_2=create rr_2
this.rr_3=create rr_3
this.ln_1=create ln_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_button3
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.dw_print
this.Control[iCurrent+4]=this.dw_1
this.Control[iCurrent+5]=this.p_1
this.Control[iCurrent+6]=this.dw_2
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.sle_1
this.Control[iCurrent+9]=this.rr_2
this.Control[iCurrent+10]=this.rr_3
this.Control[iCurrent+11]=this.ln_1
end on

on w_kfic10.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_button3)
destroy(this.cb_1)
destroy(this.dw_print)
destroy(this.dw_1)
destroy(this.p_1)
destroy(this.dw_2)
destroy(this.st_2)
destroy(this.sle_1)
destroy(this.rr_2)
destroy(this.rr_3)
destroy(this.ln_1)
end on

event open;call super::open;dw_1.settransobject(sqlca)
dw_print.settransobject(sqlca)

//p_search.enabled = false
p_search.PictureName = "C:\erpman\image\상환계획등록_d.gif"

//p_1.enabled = false
p_1.PictureName = "C:\Erpman\image\리스설비등록_d.gif"

//p_print.enabled = false
p_print.PictureName = "C:\erpman\image\리스대장출력_d.gif"

ib_any_typing = False

dw_2.settransobject(sqlca)
dw_2.sharedata(dw_1)
if dw_2.retrieve() < 1 then
	dw_1.insertrow(0)
	dw_1.setfocus()
end if





end event

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
  				 scode = ls_string
				
//				//문자 - 명칭
				Case is >= 127
				 
				 scode = '%'+ls_string
      
            End Choose
			End If	
         
			iRow=dw_2.Find("lsno like '" + scode+'%'+"'",1,dw_2.RowCount())
		  
		  if iRow>0 then
		     
	     else
	        iRow=dw_2.Find("lsco like '" + scode+'%'+"'",1,dw_2.RowCount())
			 if iRow>0 then
		
		    else	

		     iRow=dw_2.Find("lsgyno like '" + scode+'%'+"'",1,dw_2.RowCount())
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

type dw_insert from w_inherite`dw_insert within w_kfic10
boolean visible = false
integer x = 110
integer y = 3112
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kfic10
boolean visible = false
integer x = 3781
integer y = 3300
end type

type p_addrow from w_inherite`p_addrow within w_kfic10
boolean visible = false
integer x = 3607
integer y = 3300
end type

type p_search from w_inherite`p_search within w_kfic10
integer x = 3026
integer width = 306
string picturename = "C:\erpman\image\상환계획등록_up.gif"
end type

event p_search::clicked;call super::clicked;string s_lsno

if dw_1.accepttext() = -1 then return 

s_lsno = dw_1.getitemstring(dw_1.getrow(), "lsno")

if s_lsno = "" or isnull(s_lsno) then
	f_messagechk(1, "[자사리스번호]")
	dw_1.setcolumn("lsno")
	dw_1.setfocus()
	return
end if

openwithparm(w_kfic12, s_lsno)
end event

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\상환계획등록_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\상환계획등록_up.gif"
end event

type p_ins from w_inherite`p_ins within w_kfic10
integer x = 2857
end type

event p_ins::clicked;call super::clicked;integer icurrow

iCurRow = dw_1.InsertRow(0)

dw_1.ScrollToRow(iCurRow)
	
dw_1.SetFocus()

dw_2.SelectRow(0,False)
dw_2.SelectRow(iCurRow,True)

dw_2.ScrollToRow(iCurRow)

p_ins.Enabled = False
p_ins.PictureName = "C:\erpman\image\추가_d.gif"


end event

type p_exit from w_inherite`p_exit within w_kfic10
end type

type p_can from w_inherite`p_can within w_kfic10
end type

event p_can::clicked;call super::clicked;dw_1.reset()
dw_1.insertrow(0)

p_search.enabled = false
p_search.PictureName = "C:\erpman\image\상환계획등록_d.gif"

p_1.enabled = false
p_1.PictureName = "C:\Erpman\image\리스설비등록_d.gif"

p_print.enabled = false
p_print.PictureName = "C:\erpman\image\리스대장출력_d.gif"

//cb_del.enabled = false

ib_any_typing = False

//dw_2.retrieve()
end event

type p_print from w_inherite`p_print within w_kfic10
integer x = 3621
integer width = 306
boolean originalsize = true
string picturename = "C:\erpman\image\리스대장출력_up.gif"
boolean focusrectangle = true
end type

event p_print::clicked;call super::clicked;string s_lsno

if dw_1.accepttext() = -1 then return

s_lsno = dw_1.getitemstring(dw_1.getrow(), "lsno")

dw_print.reset()

if dw_print.retrieve(s_lsno) <= 0 then
	messagebox("확인", "출력할 자료가 존재하지 않습니다.")
	return
end if

openwithparm(w_print_options, dw_print)
end event

event p_print::ue_lbuttonup;PictureName = "C:\erpman\image\리스대장출력_up.gif"
end event

event p_print::ue_lbuttondown;PictureName = "C:\erpman\image\리스대장출력_dn.gif"
end event

type p_inq from w_inherite`p_inq within w_kfic10
integer x = 2683
end type

event p_inq::clicked;call super::clicked;string s_lsno, s_lsgydate

if dw_1.accepttext() = -1 then return

s_lsno = dw_1.getitemstring(dw_1.getrow(), "lsno")
if s_lsno = "" or isnull(s_lsno) then
	f_messagechk(1,"[자사리스번호]")
   dw_1.setcolumn("lsno")
	dw_1.setfocus()
	return
end if


w_mdi_frame.sle_msg.Text = '조회 중...'

SetPointer(HourGlass!)
dw_1.SetRedraw(False)
IF dw_1.Retrieve(s_lsno) <=0 THEN
//	F_MESSAGECHK(14,"")
	dw_1.insertrow(0)
	dw_1.SetFocus()
	dw_1.setitem(dw_1.getrow(), "lsno", s_lsno)
	dw_1.SetRedraw(True)
	w_mdi_frame.sle_msg.text = ''
	SetPointer(Arrow!)
	Return
ELSE
	p_search.enabled = True
	p_search.PictureName = "C:\erpman\image\상환계획등록_up.gif"
	
	p_1.enabled = True
	p_1.PictureName = "C:\Erpman\image\리스설비등록_up.gif"
	
	p_print.enabled = True
	p_print.PictureName = "C:\erpman\image\리스대장출력_up.gif"
	
//	cb_del.enabled = true
	dw_1.SetColumn("lsgyno")
	dw_1.SetFocus()
END IF
dw_1.SetRedraw(True)

w_mdi_frame.sle_msg.text = '조회 완료'

SetPointer(Arrow!)
end event

type p_del from w_inherite`p_del within w_kfic10
end type

event p_del::clicked;call super::clicked;String slsno

w_mdi_frame.sle_msg.text =""

dw_1.AcceptText()

slsno =dw_1.GetItemString(dw_1.getrow(), "lsno")

IF f_dbconfirm("삭제") = 2 THEN RETURN

dw_1.Setredraw(False)
dw_1.DeleteRow(0)
IF dw_1.Update() = 1 THEN
	IF f_mult_custom(slsno,'','11','','','','','99') = -1 THEN
		Messagebox("확 인","경리거래처 갱신 실패!!")
		ROLLBACK;
		Return
	END IF
	COMMIT;
	dw_1.Reset()
	dw_1.insertrow(0)
	dw_1.setcolumn("lsno")
	dw_1.Setredraw(True)
	dw_1.SetFocus()
	
	ib_any_typing = false
	
	w_mdi_frame.sle_msg.text = "자료가 삭제되었습니다.!!!"	
	p_search.enabled = false
	p_search.PictureName = "C:\erpman\image\상환계획등록_d.gif"
	
	p_1.enabled = false
	p_1.PictureName = "C:\Erpman\image\리스설비등록_d.gif"
	
	p_print.enabled = false
	p_print.PictureName = "C:\erpman\image\리스대장출력_d.gif"

//   cb_del.enabled = false
ELSE
	f_messagechk(12,'')
	dw_1.Setredraw(True)
	ROLLBACK;
	Return
END IF

if dw_2.retrieve() < 1 then
	dw_1.insertrow(0)
	return
end if

end event

type p_mod from w_inherite`p_mod within w_kfic10
end type

event p_mod::clicked;call super::clicked;String slsno

w_mdi_frame.sle_msg.text =""

IF dw_1.AcceptText() = -1 then return 

slsno = dw_1.GetItemString(dw_1.GetRow(), "lsno")

IF dw_1.GetRow() <=0 THEN Return

if wf_requiredchk() = -1 then return

IF f_dbconfirm("저장") = 2 THEN RETURN

IF dw_1.Update() = 1 THEN
	IF Wf_Update_etc(slsno) = -1 THEN
		Rollback;
		F_MessageChk(13,'[리스상환계획]')
		Return
	END IF
	IF wf_kfz04om0_update() = -1 THEN
		Messagebox("확 인","경리거래처 갱신 실패!!")
		ROLLBACK;
		Return
	END IF
	
	COMMIT;
	
	w_mdi_frame.sle_msg.text ="자료가 저장되었습니다.!!!"	
	
	ib_any_typing = false
	
	p_search.enabled = True
	p_search.PictureName = "C:\erpman\image\상환계획등록_up.gif"
	
	p_ins.enabled = True
	p_ins.PictureName = "C:\erpman\image\추가_up.gif"
	
	p_1.enabled = True
	p_1.PictureName = "C:\Erpman\image\리스설비등록_up.gif"
	
	p_print.enabled = True
	p_print.PictureName = "C:\erpman\image\리스대장출력_up.gif"

	dw_1.SetRedraw(False)
   dw_1.reset()
   dw_1.insertrow(0)
	dw_1.setcolumn("lsno")
	dw_1.SetRedraw(True)
	dw_1.setfocus()
	
ELSE
	f_messagechk(13,"") 
	ROLLBACK;
	
	p_search.enabled = false
	p_search.PictureName = "C:\erpman\image\상환계획등록_d.gif"
	
	p_ins.enabled = false
	p_ins.PictureName = "C:\erpman\image\추가_d.gif"
	
	p_1.enabled = false
	p_1.PictureName = "C:\Erpman\image\리스설비등록_d.gif"
	
	p_print.enabled = false
	p_print.PictureName = "C:\erpman\image\리스대장출력_d.gif"
	
	RETURN
END IF

dw_2.retrieve()







end event

type cb_exit from w_inherite`cb_exit within w_kfic10
boolean visible = false
integer x = 2971
integer y = 2788
integer taborder = 80
end type

type cb_mod from w_inherite`cb_mod within w_kfic10
boolean visible = false
integer x = 2135
integer y = 2788
end type

event cb_mod::clicked;call super::clicked;String slsno

sle_msg.text =""

IF dw_1.AcceptText() = -1 then return 

slsno = dw_1.GetItemString(dw_1.GetRow(), "lsno")

IF dw_1.GetRow() <=0 THEN Return

if wf_requiredchk() = -1 then return

IF f_dbconfirm("저장") = 2 THEN RETURN

IF dw_1.Update() = 1 THEN
	IF Wf_Update_etc(slsno) = -1 THEN
		Rollback;
		F_MessageChk(13,'[리스상환계획]')
		Return
	END IF
	IF wf_kfz04om0_update() = -1 THEN
		Messagebox("확 인","경리거래처 갱신 실패!!")
		ROLLBACK;
		Return
	END IF
	
	COMMIT;
	
	sle_msg.text ="자료가 저장되었습니다.!!!"	
	
	ib_any_typing = false
	
	cb_search.enabled = true
	cb_1.enabled = true
	cb_print.enabled = true

	dw_1.SetRedraw(False)
   dw_1.reset()
   dw_1.insertrow(0)
	dw_1.setcolumn("lsno")
	dw_1.SetRedraw(True)
	dw_1.setfocus()
	
ELSE
	f_messagechk(13,"") 
	ROLLBACK;
	
	cb_search.enabled = false
	cb_1.enabled = false
	cb_print.enabled = false
	
	RETURN
END IF







end event

type cb_ins from w_inherite`cb_ins within w_kfic10
boolean visible = false
integer x = 1829
integer y = 2908
end type

type cb_del from w_inherite`cb_del within w_kfic10
boolean visible = false
integer x = 2491
integer y = 2788
integer taborder = 50
end type

event cb_del::clicked;call super::clicked;String slsno

sle_msg.text =""

dw_1.AcceptText()

slsno =dw_1.GetItemString(dw_1.getrow(), "lsno")

IF f_dbconfirm("삭제") = 2 THEN RETURN

dw_1.Setredraw(False)
dw_1.DeleteRow(0)
IF dw_1.Update() = 1 THEN
	IF f_mult_custom(slsno,'','11','','','','','99') = -1 THEN
		Messagebox("확 인","경리거래처 갱신 실패!!")
		ROLLBACK;
		Return
	END IF
	COMMIT;
	dw_1.Reset()
	dw_1.insertrow(0)
	dw_1.setcolumn("lsno")
	dw_1.Setredraw(True)
	dw_1.SetFocus()
	
	ib_any_typing = false
	
	sle_msg.text = "자료가 삭제되었습니다.!!!"	
	cb_search.enabled = false
   cb_1.enabled = false
   cb_print.enabled = false
//   cb_del.enabled = false
ELSE
	f_messagechk(12,'')
	dw_1.Setredraw(True)
	ROLLBACK;
	Return
END IF


end event

type cb_inq from w_inherite`cb_inq within w_kfic10
boolean visible = false
integer x = 105
integer y = 2788
integer taborder = 40
end type

event cb_inq::clicked;call super::clicked;string s_lsno, s_lsgydate

if dw_1.accepttext() = -1 then return

s_lsno = dw_1.getitemstring(dw_1.getrow(), "lsno")
if s_lsno = "" or isnull(s_lsno) then
	f_messagechk(1,"[자사리스번호]")
   dw_1.setcolumn("lsno")
	dw_1.setfocus()
	return
end if


sle_msg.Text = '조회 중...'

SetPointer(HourGlass!)
dw_1.SetRedraw(False)
IF dw_1.Retrieve(s_lsno) <=0 THEN
//	F_MESSAGECHK(14,"")
	dw_1.insertrow(0)
	dw_1.SetFocus()
	dw_1.setitem(dw_1.getrow(), "lsno", s_lsno)
	dw_1.SetRedraw(True)
	sle_msg.text = ''
	SetPointer(Arrow!)
	Return
ELSE
	cb_search.enabled = true
   cb_1.enabled = true
   cb_print.enabled = true
//	cb_del.enabled = true
	dw_1.SetColumn("lsgyno")
	dw_1.SetFocus()
END IF
dw_1.SetRedraw(True)

sle_msg.text = '조회 완료'

SetPointer(Arrow!)
end event

type cb_print from w_inherite`cb_print within w_kfic10
boolean visible = false
integer x = 1499
integer y = 2788
integer width = 553
string text = "리스대장출력(&P)"
end type

event cb_print::clicked;call super::clicked;string s_lsno

if dw_1.accepttext() = -1 then return

s_lsno = dw_1.getitemstring(dw_1.getrow(), "lsno")

dw_print.reset()

if dw_print.retrieve(s_lsno) <= 0 then
	messagebox("확인", "출력할 자료가 존재하지 않습니다.")
	return
end if

openwithparm(w_print_options, dw_print)
end event

type st_1 from w_inherite`st_1 within w_kfic10
boolean visible = false
integer x = 37
integer y = 3248
integer height = 40
end type

type cb_can from w_inherite`cb_can within w_kfic10
boolean visible = false
integer x = 2853
integer y = 2788
end type

event cb_can::clicked;call super::clicked;dw_1.reset()
dw_1.insertrow(0)

cb_search.enabled = false
cb_1.enabled = false
cb_print.enabled = false
//cb_del.enabled = false
end event

type cb_search from w_inherite`cb_search within w_kfic10
boolean visible = false
integer x = 526
integer y = 2788
integer width = 466
integer taborder = 90
string text = "상환계획등록"
end type

event cb_search::clicked;call super::clicked;string s_lsno

if dw_1.accepttext() = -1 then return 

s_lsno = dw_1.getitemstring(dw_1.getrow(), "lsno")

if s_lsno = "" or isnull(s_lsno) then
	f_messagechk(1, "[자사리스번호]")
	dw_1.setcolumn("lsno")
	dw_1.setfocus()
	return
end if

openwithparm(w_kfic12, s_lsno)
end event

type dw_datetime from w_inherite`dw_datetime within w_kfic10
boolean visible = false
integer y = 3096
end type

type sle_msg from w_inherite`sle_msg within w_kfic10
boolean visible = false
integer x = 329
integer y = 3144
end type

type gb_10 from w_inherite`gb_10 within w_kfic10
boolean visible = false
integer y = 3044
end type

type gb_button1 from w_inherite`gb_button1 within w_kfic10
boolean visible = false
integer x = 498
integer y = 2736
integer width = 1582
end type

type gb_button2 from w_inherite`gb_button2 within w_kfic10
boolean visible = false
integer x = 2103
integer y = 2736
integer width = 1477
end type

type gb_button3 from groupbox within w_kfic10
boolean visible = false
integer x = 64
integer y = 2736
integer width = 411
integer height = 192
integer taborder = 20
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

type cb_1 from commandbutton within w_kfic10
boolean visible = false
integer x = 1010
integer y = 2788
integer width = 466
integer height = 108
integer taborder = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "리스설비등록"
end type

event clicked;
string s_lsno

if dw_1.accepttext() = -1 then return

s_lsno = dw_1.getitemstring(dw_1.getrow(), "lsno")

if s_lsno = "" or isnull(s_lsno) then
	f_messagechk(1, "[자사리스번호]")
	dw_1.setcolumn("lsno")
	dw_1.setfocus()
	return
end if

openwithparm(w_kfic11, s_lsno)
end event

type dw_print from datawindow within w_kfic10
boolean visible = false
integer x = 987
integer y = 2916
integer width = 709
integer height = 104
boolean bringtotop = true
boolean titlebar = true
string title = "리스대장출력"
string dataobject = "d_kfic10_2"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_1 from datawindow within w_kfic10
event ue_key pbm_dwnkey
event ue_enterkey pbm_dwnprocessenter
integer x = 1655
integer y = 204
integer width = 3282
integer height = 1956
integer taborder = 10
string dataobject = "d_kfic10_1"
boolean border = false
boolean livescroll = true
end type

event ue_key;if keydown(keyf1!) or keydown(keytab!) then
	triggerevent(rbuttondown!)
end if
end event

event ue_enterkey;if this.GetColumnName() = 'lsthing'  then return 

Send(Handle(this),256,9,0)
Return 1
end event

event editchanged;ib_any_typing = true
end event

event getfocus;this.accepttext()
end event

event rbuttondown;setnull(gs_code)
setnull(gs_codename)

this.accepttext()

//if this.getcolumnname() = "lsno" then
////   gs_code = dw_1.getitemstring(dw_1.getrow(), "lsno")
//	if isnull(gs_code) then gs_code = ""
//	
//	open(w_kfic10_popup)
//	
//	if isnull(gs_code) then return
//	
//	dw_1.setitem(dw_1.getrow(), "lsno", gs_code)
//	p_inq.TriggerEvent(clicked!)	
//end if
	
if this.getcolumnname() = "lscono" then
	gs_code = dw_1.getitemstring(dw_1.getrow(), "lscono")
   gs_codename = dw_1.getitemstring(dw_1.getrow(), "lsco")
	if isnull(gs_code) then gs_code = ""
	
	open(w_kfic10_popup1)
	
	if isnull(gs_code) then return
	
	dw_1.setitem(dw_1.getrow(), "lscono", gs_code)
	dw_1.setitem(dw_1.getrow(), "lsco", gs_codename)
//	p_inq.TriggerEvent(clicked!)
	
end if	
	
	
	
end event

event itemerror;return 1
end event

event itemchanged;string ls_lsno, ls_lscono, ls_lsco, snull 
integer ll_row

setnull(snull)

//if this.getcolumnname() = "lsno" then
//	ls_lsno = this.gettext()
//	ll_row = dw_1.retrieve(ls_lsno)
//	
//	if ll_row <= 0 then
//		dw_1.insertRow(0)
//		dw_1.setitem(this.getrow(), "lsno", ls_lsno)
////		F_MESSAGECHK(14,"")
//	else
//		p_search.enabled = True
//		p_search.PictureName = "C:\erpman\image\상환계획등록_up.gif"
//		
//		p_1.enabled = True
//		p_1.PictureName = "C:\Erpman\image\리스설비등록_up.gif"
//		
//		p_print.enabled = True
//		p_print.PictureName = "C:\erpman\image\리스대장출력_up.gif"
//	end if
//end if

if this.getcolumnname() = "lscono" then
	ls_lscono = this.gettext()
	if ls_lscono = "" or isnull(ls_lscono) then
		this.setitem(this.getrow(), "lsco", snull)
		return
	end if 
	
	SELECT LSCO
	  INTO :ls_lsco
	  FROM KFM20M
	 WHERE LSCONO = :ls_lscono ;
	 
	if sqlca.sqlcode = 0 then
		this.setitem(this.getrow(), "lsco", ls_lsco)
	else
//		messagebox("확인", "리스회사를 확인하십시오")
		this.setitem(this.getrow(), "lscono", snull)
		this.setitem(this.getrow(), "lsco", snull)
		this.setcolumn("lscono")
		this.setfocus()
		return
	end if
end if
		 
end event

event itemfocuschanged;Long wnd

wnd =Handle(this)

IF dwo.name ="lsthing" THEN
	f_toggle_kor(wnd)
ELSE
	f_toggle_eng(wnd)
END IF
end event

type p_1 from uo_picture within w_kfic10
integer x = 3323
integer y = 24
integer width = 306
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\Erpman\image\리스설비등록_up.gif"
boolean focusrectangle = true
end type

event clicked;call super::clicked;
string s_lsno

if dw_1.accepttext() = -1 then return

s_lsno = dw_1.getitemstring(dw_1.getrow(), "lsno")

if s_lsno = "" or isnull(s_lsno) then
	f_messagechk(1, "[자사리스번호]")
	dw_1.setcolumn("lsno")
	dw_1.setfocus()
	return
end if

openwithparm(w_kfic11, s_lsno)
end event

event ue_lbuttonup;PictureName = "C:\Erpman\image\리스설비등록_up.gif"
end event

event ue_lbuttondown;PictureName = "C:\Erpman\image\리스설비등록_dn.gif"
end event

type dw_2 from u_d_popup_sort within w_kfic10
integer x = 37
integer y = 228
integer width = 1614
integer height = 1872
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_kfic10_3"
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
	
END IF

end event

type st_2 from statictext within w_kfic10
integer x = 101
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
string text = "리스조회"
boolean focusrectangle = false
end type

type sle_1 from singlelineedit within w_kfic10
integer x = 407
integer y = 88
integer width = 567
integer height = 64
integer taborder = 40
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

type rr_2 from roundrectangle within w_kfic10
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 220
integer width = 1623
integer height = 1892
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_3 from roundrectangle within w_kfic10
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 73
integer y = 40
integer width = 987
integer height = 148
integer cornerheight = 40
integer cornerwidth = 46
end type

type ln_1 from line within w_kfic10
integer linethickness = 1
integer beginx = 411
integer beginy = 156
integer endx = 974
integer endy = 156
end type

