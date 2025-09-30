$PBExportHeader$w_kfia20.srw
$PBExportComments$자금수지코드 등록
forward
global type w_kfia20 from w_inherite
end type
type dw_2 from datawindow within w_kfia20
end type
type gb_1 from groupbox within w_kfia20
end type
type dw_1 from datawindow within w_kfia20
end type
type cbx_1 from checkbox within w_kfia20
end type
type rr_1 from roundrectangle within w_kfia20
end type
end forward

global type w_kfia20 from w_inherite
string title = "자금수지코드 등록"
dw_2 dw_2
gb_1 gb_1
dw_1 dw_1
cbx_1 cbx_1
rr_1 rr_1
end type
global w_kfia20 w_kfia20

type variables
Boolean itemerr =False
end variables

forward prototypes
public function integer wf_requiredchk (integer curr_row)
public subroutine wf_setting_retrievemode (string mode)
public subroutine wf_init ()
end prototypes

public function integer wf_requiredchk (integer curr_row);String finance_cd,finance_name
       
   finance_cd = dw_1.GetItemString(curr_row,"finance_cd")
	IF finance_cd ="" OR IsNull(finance_cd) THEN
	   f_messagechk(1,"자금코드")
		dw_1.SetColumn("finance_cd")
		dw_1.SetFocus()
		RETURN -1
	END IF   	

	finance_name = dw_1.GetItemString(curr_row,"finance_name")
	IF finance_name ="" OR IsNull(finance_name) THEN
		f_messagechk(1,"자금코드명")
		dw_1.SetColumn("finance_name")
		dw_1.SetFocus()
		RETURN -1
	END IF	

Return 1
end function

public subroutine wf_setting_retrievemode (string mode);//************************************************************************************//
// **** FUNCTION NAME :WF_SETTING_RETRIEVEMODE(DATAWINDOW 제어)      					  //
//      * ARGUMENT : String mode(수정mode 인지 입력 mode 인지 구분)						  //
//		  * RETURN VALUE : 없슴 																		  //
//************************************************************************************//

dw_1.SetRedraw(False)
p_ins.Enabled =True
p_mod.Enabled =True
IF mode ="조회" THEN							//수정
	dw_1.SetTabOrder("FINANCE_CD",0)
	dw_1.SetColumn("FINANCE_NAME")
	p_del.Enabled =True
ELSEIF mode ="등록" THEN					//입력
	dw_1.SetTabOrder("FINANCE_cd",10)
	dw_1.SetColumn("FINANCE_CD")
	p_del.Enabled =False
END IF
dw_1.SetFocus()
dw_1.SetRedraw(True)
end subroutine

public subroutine wf_init ();String snull

SetNull(snull)

dw_1.SetRedraw(False)
dw_1.Reset()
dw_1.InsertRow(0)
dw_1.SetRedraw(True)
//dw_1.SetItem(1,"finance_cd",snull)
//dw_1.SetItem(1,"finance_name",snull)
//dw_1.SetItem(1,"add_cd1",snull)
//dw_1.SetItem(1,"add_cd2",snull)
//dw_1.SetItem(1,"add_cd3",snull)
//dw_1.SetItem(1,"add_cd4",snull)
//dw_1.SetItem(1,"add_cd5",snull)
//dw_1.SetItem(1,"sub_cd1",snull)
//dw_1.SetItem(1,"sub_cd2",snull)
//dw_1.SetItem(1,"sub_cd3",snull)
//dw_1.SetItem(1,"sub_cd4",snull)
//dw_1.SetItem(1,"sub_cd5",snull)
//
dw_1.SetColumn("finance_cd")
dw_1.SetFocus()
end subroutine

on w_kfia20.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.gb_1=create gb_1
this.dw_1=create dw_1
this.cbx_1=create cbx_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.gb_1
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.cbx_1
this.Control[iCurrent+5]=this.rr_1
end on

on w_kfia20.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_2)
destroy(this.gb_1)
destroy(this.dw_1)
destroy(this.cbx_1)
destroy(this.rr_1)
end on

event open;call super::open;dw_1.SetTransObject(SQLCA)

dw_2.SetTransObject(SQLCA)
dw_2.Retrieve()

wf_init()

ib_any_typing =False
smodstatus ="I"
WF_SETTING_RETRIEVEMODE(smodstatus)


end event

type dw_insert from w_inherite`dw_insert within w_kfia20
boolean visible = false
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kfia20
boolean visible = false
integer x = 2825
integer y = 2984
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kfia20
boolean visible = false
integer x = 2651
integer y = 2984
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kfia20
boolean visible = false
integer x = 1957
integer y = 2984
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_kfia20
integer x = 3730
end type

event p_ins::clicked;call super::clicked;wf_init()
dw_2.SelectRow(0,False)

smodstatus ="I"
wf_setting_retrievemode(smodstatus)

end event

type p_exit from w_inherite`p_exit within w_kfia20
integer x = 4430
integer taborder = 60
end type

type p_can from w_inherite`p_can within w_kfia20
integer x = 4256
integer taborder = 50
end type

event p_can::clicked;call super::clicked;wf_init()
dw_2.SelectRow(0,False)

smodstatus ="I"
wf_setting_retrievemode(smodstatus)

end event

type p_print from w_inherite`p_print within w_kfia20
boolean visible = false
integer x = 2130
integer y = 2984
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kfia20
boolean visible = false
integer x = 2304
integer y = 2984
integer taborder = 0
end type

type p_del from w_inherite`p_del within w_kfia20
integer x = 4082
integer taborder = 40
end type

event p_del::clicked;call super::clicked;Int il_DeleteRow,il_scrolltorow

il_DeleteRow =dw_2.GetSelectedRow(0)

IF il_DeleteRow <=0 THEN
	f_messagechk(11,"")
	Return
END IF

IF MessageBox("확인","삭제하시겠습니까?",Question!,YesNo!) = 2 THEN RETURN

dw_2.DeleteRow(il_deleterow)

IF dw_2.Update() = 1 THEN
	COMMIT;
	dw_2.Retrieve()
	dw_2.ScrolltoRow(il_DeleteRow - 1)
	dw_1.Reset()
	dw_1.InsertRow(0)
	
	smodstatus ="I"
	ib_any_typing =False
ELSE
	f_messagechk(12,"")
	ROLLBACK;
	smodstatus ="M"
END IF

WF_SETTING_RETRIEVEMODE(smodstatus)


end event

type p_mod from w_inherite`p_mod within w_kfia20
integer x = 3909
integer taborder = 30
end type

event p_mod::clicked;call super::clicked;String scode,snull,ssql_data,sSearchStr, scod, sname
Int il_scrolltorow, istart, icount
string sadd[5], ssub[5]

SetNull(snull)

IF dw_1.AcceptText() = -1 THEN RETURN

scode =dw_1.GetItemString(1,"finance_cd")

IF smodstatus ="M" THEN
ELSE
	SELECT "KFM10OM0"."FINANCE_NAME"  
    	INTO :ssql_data
    	FROM "KFM10OM0"  
   	WHERE ( "KFM10OM0"."FINANCE_CD" = :scode )   ;
	IF SQLCA.SQLCODE =0 THEN
		f_messagechk(10,"")
		wf_init()
		Return
	END IF

END IF


sadd = {"add_cd1","add_cd2","add_cd3","add_cd4","add_cd5"}
ssub = {"sub_cd1","sub_cd2","sub_cd3","sub_cd4","sub_cd5"}

FOR istart = 1 TO 5
	scod = dw_1.getitemstring(1,sadd[istart])
	IF scod ="" OR IsNull(scod) THEN 
	ELSE	
      SELECT "KFM10OM0"."FINANCE_NAME"  
        INTO :SNAME  
        FROM "KFM10OM0"  
       WHERE "KFM10OM0"."FINANCE_CD" = :scod ;
      
		
		IF SQLCA.SQLCODE <> 0 THEN
		   f_messagechk(20,"자료")
         icount =  istart + 2
	      dw_1.SetColumn(icount)
			dw_1.SetFocus()
		   Return 1
	   END IF
   END IF
NEXT

FOR istart = 1 TO 5
	scod = dw_1.getitemstring(1,ssub[istart])
	IF scod ="" OR IsNull(scod) THEN 
	ELSE	
      SELECT "KFM10OM0"."FINANCE_NAME"  
        INTO :SNAME  
        FROM "KFM10OM0"  
       WHERE "KFM10OM0"."FINANCE_CD" = :scod ;
   
	   IF SQLCA.SQLCODE <> 0 THEN
		   f_messagechk(20,"자료")
         icount =  istart + 7
	      dw_1.SetColumn(icount) 
		   dw_1.SetFocus()
		   Return 1
	   END IF
   END IF
NEXT

IF wf_requiredchk(dw_1.GetRow()) = -1 THEN RETURN

IF dw_1.Update() = 1 THEN
	dw_2.Retrieve()
	sSearchStr ="FINANCE_cd ='"+scode+"'"
	il_scrolltorow =dw_2.Find(sSearchStr,1,dw_2.RowCount())
	dw_2.Scrolltorow(il_scrolltorow)
	dw_1.Reset()
	dw_1.InsertRow(0)
	wf_init()
	w_mdi_frame.sle_msg.text ="자료를 저장하였습니다.!!!"
	COMMIT;
	smodstatus ="I"
	ib_any_typing =False
ELSE
	f_messagechk(13,"")
	smodstatus ="M"
	ROLLBACK;
END IF

WF_SETTING_RETRIEVEMODE(smodstatus)

end event

type cb_exit from w_inherite`cb_exit within w_kfia20
boolean visible = false
integer x = 3570
integer y = 2984
end type

type cb_mod from w_inherite`cb_mod within w_kfia20
boolean visible = false
integer x = 2501
integer y = 2984
end type

type cb_ins from w_inherite`cb_ins within w_kfia20
boolean visible = false
integer x = 2149
integer y = 2988
string text = "추가(&A)"
end type

type cb_del from w_inherite`cb_del within w_kfia20
boolean visible = false
integer x = 2857
integer y = 2984
end type

type cb_inq from w_inherite`cb_inq within w_kfia20
boolean visible = false
integer x = 1554
integer y = 2552
end type

event cb_inq::clicked;call super::clicked;//String sgubun
//
//IF dw_1.Accepttext() = -1 THEN RETURN
//
//sgubun =dw_1.GetItemString(dw_1.GetRow(),"person_gu")
//
//IF dw_2.Retrieve(sgubun) <=0 THEN
//	F_MESSAGECHK(sle_msg,14,"")
//	dw_1.SetFocus()
//	Return
//END IF
//
end event

type cb_print from w_inherite`cb_print within w_kfia20
boolean visible = false
integer x = 1911
integer y = 2548
end type

type st_1 from w_inherite`st_1 within w_kfia20
boolean visible = false
end type

type cb_can from w_inherite`cb_can within w_kfia20
boolean visible = false
integer x = 3214
integer y = 2984
end type

type cb_search from w_inherite`cb_search within w_kfia20
boolean visible = false
integer x = 1029
integer y = 2548
end type

type dw_datetime from w_inherite`dw_datetime within w_kfia20
boolean visible = false
end type

type sle_msg from w_inherite`sle_msg within w_kfia20
boolean visible = false
end type

type gb_10 from w_inherite`gb_10 within w_kfia20
boolean visible = false
end type

type gb_button1 from w_inherite`gb_button1 within w_kfia20
boolean visible = false
integer x = 608
integer y = 2692
integer width = 402
end type

type gb_button2 from w_inherite`gb_button2 within w_kfia20
boolean visible = false
integer x = 2322
integer y = 2720
integer width = 1467
end type

type dw_2 from datawindow within w_kfia20
event clicked pbm_dwnlbuttonclk
integer x = 73
integer y = 516
integer width = 4512
integer height = 1800
string dataobject = "dw_kfia20_2"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;IF row <=0 THEN RETURN

dw_2.SelectRow(0,False)
dw_2.SelectRow(row,True)

dw_1.Retrieve(dw_2.GetItemString(row,"finance_cd"))
smodstatus ="M"
WF_SETTING_RETRIEVEMODE(smodstatus)
cb_ins.Enabled =False
end event

type gb_1 from groupbox within w_kfia20
integer x = 3744
integer y = 188
integer width = 855
integer height = 168
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
borderstyle borderstyle = styleraised!
end type

type dw_1 from datawindow within w_kfia20
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 55
integer y = 20
integer width = 3607
integer height = 480
integer taborder = 10
string dataobject = "dw_kfia20_1"
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

event editchanged;ib_any_typing =True
end event

event itemchanged;String snull, scode, sname

SetNull(snull)
w_mdi_frame.sle_msg.text =""

IF dwo.name ="sfin_cd" OR dwo.name = "add_cd1" OR dwo.name ="add_cd2" OR dwo.name ="add_cd3" OR &
		dwo.name ="add_cd4" OR dwo.name ="add_cd5" OR dwo.name ="sub_cd1" OR &
			dwo.name ="sub_cd2" OR dwo.name ="sub_cd3" OR dwo.name ="sub_cd4" OR dwo.name ="sub_cd5" THEN
	
	IF data ="" OR IsNull(data) THEN RETURN 
	
	SELECT "FINANCE_CD" INTO :snull
		FROM "KFM10OM0"
		WHERE "KFM10OM0"."FINANCE_CD" = :data ;
			
	CHOOSE CASE dwo.name
		CASE "sfin_cd"
			this.SetItem(1,"sfin_cd",snull)
		CASE "add_cd1"
			this.SetItem(1,"add_cd1",snull)
		CASE "add_cd2"
			this.SetItem(1,"add_cd2",snull)
		CASE "add_cd3"
			this.SetItem(1,"add_cd3",snull)
		CASE "add_cd4"
			this.SetItem(1,"add_cd4",snull)
		CASE "add_cd5"
			this.SetItem(1,"add_cd5",snull)
		CASE "sub_cd1"
			this.SetItem(1,"sub_cd1",snull)
		CASE "sub_cd2"
			this.SetItem(1,"sub_cd2",snull)
		CASE "sub_cd3"
			this.SetItem(1,"sub_cd3",snull)
		CASE "sub_cd4"
			this.SetItem(1,"sub_cd4",snull)
		CASE "sub_cd5"
			this.SetItem(1,"sub_cd5",snull)
	END CHOOSE
	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox("확 인","등록된 자금수지코드가 아닙니다!!")
		Return 1
	END IF
END IF
	
	
	
end event

event itemerror;Return 1
end event

event rbuttondown;
String ls_cd

SetNull(gs_code)
SetNull(gs_codename)

IF this.GetColumnName() ="sfin_cd" THEN
	ls_cd =dw_1.GetItemString(1,"sfin_cd")
	IF IsNull(ls_cd) then
   	ls_cd = ""
	end if
 	gs_code = Trim(ls_cd)
	 
	OpenWithParm(W_KFM10OM0_POPUP,'%')
	
	IF IsNull(gs_code) THEN RETURN
	
	dw_1.SetItem(1,"sfin_cd",gs_code)
	
ELSEIF this.GetColumnName() ="add_cd1" THEN
	ls_cd =dw_1.GetItemString(1,"add_cd1")
	
	IF IsNull(ls_cd) then
   	ls_cd = ""
	end if
	
 	gs_code = Trim(ls_cd)
	 
	OpenWithParm(W_KFM10OM0_POPUP,'%')
	
	IF IsNull(gs_code) THEN RETURN
	
	dw_1.SetItem(1,"add_cd1",gs_code)
	
ELSEIF this.GetColumnName() ="add_cd2" THEN
	ls_cd =dw_1.GetItemString(1,"add_cd2")
	IF IsNull(ls_cd) then
   	ls_cd = ""
	end if
 	gs_code = Trim(ls_cd)
	 
	OpenWithParm(W_KFM10OM0_POPUP,'%')
	
	IF IsNull(gs_code) THEN RETURN
	dw_1.SetItem(1,"add_cd2",gs_code)
ELSEIF this.GetColumnName() ="add_cd3" THEN
	ls_cd =dw_1.GetItemString(1,"add_cd3")
	IF IsNull(ls_cd) then
   	ls_cd = ""
	end if
 	gs_code = Trim(ls_cd)
	
	OpenWithParm(W_KFM10OM0_POPUP,'%')
	
	IF IsNull(gs_code) THEN RETURN
	dw_1.SetItem(1,"add_cd3",gs_code)
ELSEIF this.GetColumnName() ="add_cd4" THEN
	ls_cd =dw_1.GetItemString(1,"add_cd4")
	IF IsNull(ls_cd) then
   	ls_cd = ""
	end if
 	gs_code = Trim(ls_cd)
	 
	OpenWithParm(W_KFM10OM0_POPUP,'%')
	
	IF IsNull(gs_code) THEN RETURN
	dw_1.SetItem(1,"add_cd4",gs_code)
ELSEIF this.GetColumnName() ="add_cd5" THEN
	ls_cd =dw_1.GetItemString(1,"add_cd5")
	IF IsNull(ls_cd) then
   	ls_cd = ""
	end if
 	gs_code = Trim(ls_cd)
	 
	OpenWithParm(W_KFM10OM0_POPUP,'%')
	
	IF IsNull(gs_code) THEN RETURN
	dw_1.SetItem(1,"add_cd5",gs_code)
ELSEIF this.GetColumnName() ="sub_cd1" THEN
	ls_cd =dw_1.GetItemString(1,"sub_cd1")
	IF IsNull(ls_cd) then
   	ls_cd = ""
	end if
 	gs_code = Trim(ls_cd)
	 
	OpenWithParm(W_KFM10OM0_POPUP,'%')
	
	IF IsNull(gs_code) THEN RETURN
	dw_1.SetItem(1,"sub_cd1",gs_code)
ELSEIF this.GetColumnName() ="sub_cd2" THEN
	ls_cd =dw_1.GetItemString(1,"sub_cd2")
	IF IsNull(ls_cd) then
   	ls_cd = ""
	end if
 	gs_code = Trim(ls_cd)
	 
	OpenWithParm(W_KFM10OM0_POPUP,'%')
	
	IF IsNull(gs_code) THEN RETURN
	dw_1.SetItem(1,"sub_cd2",gs_code)
ELSEIF this.GetColumnName() ="sub_cd3" THEN
	ls_cd =dw_1.GetItemString(1,"sub_cd3")
	IF IsNull(ls_cd) then
   	ls_cd = ""
	end if
 	gs_code = Trim(ls_cd)
	 
	OpenWithParm(W_KFM10OM0_POPUP,'%')
	
	IF IsNull(gs_code) THEN RETURN
	dw_1.SetItem(1,"sub_cd3",gs_code)
ELSEIF this.GetColumnName() ="sub_cd4" THEN
	ls_cd =dw_1.GetItemString(1,"sub_cd4")
	IF IsNull(ls_cd) then
   	ls_cd = ""
	end if
 	gs_code = Trim(ls_cd)
	 
	OpenWithParm(W_KFM10OM0_POPUP,'%')
	
	IF IsNull(gs_code) THEN RETURN
	dw_1.SetItem(1,"sub_cd4",gs_code)
ELSEIF this.GetColumnName() ="sub_cd5" THEN
	ls_cd =dw_1.GetItemString(1,"sub_cd5")
	IF IsNull(ls_cd) then
   	ls_cd = ""
	end if
 	gs_code = Trim(ls_cd)
	 
	OpenWithParm(W_KFM10OM0_POPUP,'%')
	
	IF IsNull(gs_code) THEN RETURN
	dw_1.SetItem(1,"sub_cd5",gs_code)
END IF
end event

event itemfocuschanged;Long wnd

wnd =Handle(this)

IF dwo.name ="finance_name" THEN
	f_toggle_kor(wnd)
ELSE
	f_toggle_eng(wnd)
END IF
end event

type cbx_1 from checkbox within w_kfia20
integer x = 3867
integer y = 252
integer width = 608
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "자금수지코드 출력"
end type

event clicked;open(w_kfia20a)
cbx_1.Checked =False
end event

type rr_1 from roundrectangle within w_kfia20
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 508
integer width = 4544
integer height = 1816
integer cornerheight = 40
integer cornerwidth = 55
end type

