$PBExportHeader$w_kfia80.srw
$PBExportComments$어음수표책 등록
forward
global type w_kfia80 from w_inherite
end type
type dw_1 from datawindow within w_kfia80
end type
type dw_2 from u_d_select_sort within w_kfia80
end type
type rr_1 from roundrectangle within w_kfia80
end type
type dw_cond from u_key_enter within w_kfia80
end type
end forward

global type w_kfia80 from w_inherite
string tag = "어음수표책 등록"
string title = "어음수표책 등록"
dw_1 dw_1
dw_2 dw_2
rr_1 rr_1
dw_cond dw_cond
end type
global w_kfia80 w_kfia80

type variables
boolean itemerr
s_us_in lstr_us_in                 //어음수표

end variables

forward prototypes
public function integer wf_reqchk ()
public subroutine wf_access_kfz04om0 (string scheckno, string sprocgbn, string schkgbn)
end prototypes

public function integer wf_reqchk ();String sUseGbn, sGdate, sPdate

sUseGbn = dw_1.GetItemString(1,"kfm06ot0_use_gu")
sGdate  = dw_1.GetItemString(1,"kfm06ot0_g_date")
sPdate  = dw_1.GetItemString(1,"kfm06ot0_p_date")

if sUseGbn = '1' then
	if IsNull(dw_1.GetItemString(1,"kfm06ot0_saupj")) or dw_1.GetItemString(1,"kfm06ot0_saupj") = ''	 then
		F_MessageChk(1,'[사업장]')
		dw_1.SetColumn("kfm06ot0_saupj")
		dw_1.SetFocus()
		Return -1
	end if
	if IsNull(dw_1.GetItemString(1,"kfm06ot0_chk_cus")) or dw_1.GetItemString(1,"kfm06ot0_chk_cus") = ''	 then
		F_MessageChk(1,'[거래처]')
		dw_1.SetColumn("kfm06ot0_chk_cus")
		dw_1.SetFocus()
		Return -1
	end if
	if IsNull(dw_1.GetItemString(1,"kfm06ot0_chk_bal_dat")) or dw_1.GetItemString(1,"kfm06ot0_chk_bal_dat") = ''	 then
		F_MessageChk(1,'[발행일자]')
		dw_1.SetColumn("kfm06ot0_chk_bal_dat")
		dw_1.SetFocus()
		Return -1
	end if
	if IsNull(dw_1.GetItemString(1,"kfm06ot0_chk_man_dat")) or dw_1.GetItemString(1,"kfm06ot0_chk_man_dat") = ''	 then
		F_MessageChk(1,'[결제/회수일자]')
		dw_1.SetColumn("kfm06ot0_chk_man_dat")
		dw_1.SetFocus()
		Return -1
	end if
	if IsNull(dw_1.GetItemNumber(1,"kfm06ot0_chk_amt")) or dw_1.GetItemNumber(1,"kfm06ot0_chk_amt") = 0	 then
		F_MessageChk(1,'[사용금액]')
		dw_1.SetColumn("kfm06ot0_chk_amt")
		dw_1.SetFocus()
		Return -1
	end if
elseif sUseGbn = '2' then
	if IsNull(sGdate) or sGdate = ''	 then
		F_MessageChk(1,'[견질일자]')
		dw_1.SetColumn("kfm06ot0_g_date")
		dw_1.SetFocus()
		Return -1
	end if
elseif sUseGbn = '3' then
	if IsNull(sPdate) or sPdate = ''	 then
		F_MessageChk(1,'[폐기일자]')
		dw_1.SetColumn("kfm06ot0_p_date")
		dw_1.SetFocus()
		Return -1
	end if
end if

Return 1
end function

public subroutine wf_access_kfz04om0 (string scheckno, string sprocgbn, string schkgbn);Integer i,iRowCount
String  sBnkCd,sCheckGbn,sNo,snull

SetNull(snull)

IF sprocgbn = '99' THEN
	
	IF sChkGbn = '1' THEN
//		F_MulT_Custom(scheckno,snull,'93',snull,snull,snull,snull,sProcGbn)
	ELSE
//		F_MulT_Custom(scheckno,snull,'94',snull,snull,snull,snull,sProcGbn)
	END IF
ELSE
	iRowCount = dw_2.RowCount()
	
	FOR i = 1 TO iRowCount
		sBnkCd = dw_2.GetItemString(i,"kfm06ot0_check_bnk")
		sNo    = dw_2.GetItemString(i,"kfm06ot0_check_no")
		sCheckGbn = dw_2.GetItemString(i,"kfm06ot0_check_gu")
		
		IF sCheckGbn = '1' THEN
			sCheckGbn = '수표'
//			F_MulT_Custom(sNo,sNo,'93',sCheckGbn,sBnkCd,snull,snull,sProcGbn)
		ELSEIF sCheckGbn = '2' THEN
			sCheckGbn = '어음'
//			F_MulT_Custom(sNo,sNo,'94',sCheckGbn,sBnkCd,snull,snull,sProcGbn)
		END IF
	NEXT
END IF
end subroutine

on w_kfia80.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_2=create dw_2
this.rr_1=create rr_1
this.dw_cond=create dw_cond
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.rr_1
this.Control[iCurrent+4]=this.dw_cond
end on

on w_kfia80.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.rr_1)
destroy(this.dw_cond)
end on

event open;call super::open;dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)

dw_cond.SetTransObject(SQLCA)
dw_cond.Reset()
dw_cond.InsertRow(0)
dw_cond.SetItem(1,"pur_fdate", Left(F_Today(),6)+'01')
dw_cond.SetItem(1,"pur_tdate", F_Today())

dw_1.Reset()
dw_1.InsertRow(0)

dw_2.Reset()

p_mod.Enabled = False
p_mod.PictureName = "C:\erpman\image\저장_d.gif"

p_del.Enabled = False
p_del.PictureName = "C:\erpman\image\삭제_d.gif"

ib_any_typing = False

p_ins.setfocus()
end event

type dw_insert from w_inherite`dw_insert within w_kfia80
boolean visible = false
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kfia80
boolean visible = false
integer x = 4027
integer y = 2744
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kfia80
boolean visible = false
integer x = 3854
integer y = 2744
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kfia80
boolean visible = false
integer x = 3429
integer y = 140
integer taborder = 0
string picturename = "C:\erpman\image\자료조회_up.gif"
end type

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\자료조회_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\자료조회_up.gif"
end event

event p_search::clicked;call super::clicked;//long dis_row
//
//Open(W_kfia10_POPUP2)
//
//lstr_us_in = Message.PowerObjectParm
//
//IF lstr_us_in.flag = '1' THEN
//   SetRedraw(False)
//   dw_2.Retrieve(lstr_us_in.schk_bnk, lstr_us_in.schk_bnk2, lstr_us_in.spur_date, &
//                 lstr_us_in.spur_date2, lstr_us_in.schk_gu, lstr_us_in.schk_no1, & 
//    				  lstr_us_in.schk_no2, lstr_us_in.suse_gu ) 
//	dis_row =dw_2.RowCount()
//	dw_2.ScrollToRow(dis_row)
//	SetRedraw(True)
//END IF
//dw_2.setfocus()
end event

type p_ins from w_inherite`p_ins within w_kfia80
integer x = 3552
integer y = 28
integer taborder = 70
string pointer = "C:\erpman\cur\create2.cur"
string picturename = "C:\erpman\image\생성_up.gif"
end type

event p_ins::ue_lbuttondown;PictureName = "C:\erpman\image\생성_dn.gif"
end event

event p_ins::ue_lbuttonup;PictureName = "C:\erpman\image\생성_up.gif"
end event

event p_ins::clicked;call super::clicked;
Open(W_kfia80a)
	
lstr_us_in = Message.PowerObjectParm

IF lstr_us_in.flag = '1' THEN
	
	dw_cond.SetItem(1,"kfm06ot0_check_gu",  lstr_us_in.schk_gu)
	dw_cond.SetItem(1,"kfm06ot0_use_gu",  lstr_us_in.suse_gu)
	dw_cond.SetItem(1,"kfm06ot0_check_bnk", lstr_us_in.schk_bnk)
	
   SetRedraw(False)
   dw_2.Retrieve(lstr_us_in.schk_bnk, lstr_us_in.spur_date, lstr_us_in.spur_date2, lstr_us_in.schk_gu, lstr_us_in.suse_gu ) 
	SetRedraw(True)
	
//	Wf_Access_Kfz04om0('','11','')
	
	commit;
	
	ib_any_typing =True
END IF
dw_2.setfocus()

ib_any_typing =False
end event

type p_exit from w_inherite`p_exit within w_kfia80
end type

type p_can from w_inherite`p_can within w_kfia80
integer taborder = 60
end type

event p_can::clicked;call super::clicked;
dw_1.SetRedraw(FALSE)
dw_2.SetRedraw(FALSE)

dw_1.Reset()
dw_1.InsertRow(0)

dw_2.Reset()
dw_1.SetRedraw(TRUE)
dw_2.SetRedraw(TRUE)

dw_1.Enabled = False

p_mod.Enabled = False
p_mod.PictureName = "C:\erpman\image\저장_d.gif"

p_del.Enabled = False
p_del.PictureName = "C:\erpman\image\삭제_d.gif"

ib_any_typing = False

p_ins.Enabled = True
p_ins.PictureName = "C:\erpman\image\생성_up.gif"

p_ins.setfocus()
end event

type p_print from w_inherite`p_print within w_kfia80
boolean visible = false
integer x = 3333
integer y = 2744
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kfia80
integer x = 3749
integer y = 28
integer taborder = 20
end type

event p_inq::clicked;call super::clicked;
IF dw_cond.AcceptText() = -1 then return 

lstr_us_in.schk_bnk   = Trim(dw_cond.GetitemString(1, "kfm06ot0_check_bnk"))
IF lstr_us_in.schk_bnk ="" OR ISNULL(lstr_us_in.schk_bnk) THEN lstr_us_in.schk_bnk = '%'

lstr_us_in.spur_date = Trim(dw_cond.GetitemString(1, "pur_fdate"))
lstr_us_in.spur_date2= Trim(dw_cond.GetitemString(1, "pur_tdate"))
IF lstr_us_in.spur_date ="" OR ISNULL(lstr_us_in.spur_date) THEN
	F_MessageChk(1,'[매입일자]')
   dw_cond.SetColumn("pur_fdate")
   dw_cond.SetFocus()
   Return 
ELSE
	IF f_datechk(lstr_us_in.spur_date) = -1 THEN
		MessageBox("확인", "매입일자를 확인하십시오.!!")
		dw_cond.SetColumn("pur_fdate")
		dw_cond.SetFocus()
		Return 
	END IF	
END IF         

IF lstr_us_in.spur_date2 ="" OR ISNULL(lstr_us_in.spur_date2) THEN
	F_MessageChk(1,'[매입일자]')
   dw_cond.SetColumn("pur_tdate")
   dw_cond.SetFocus()
   Return 
ELSE
	IF f_datechk(lstr_us_in.spur_date2) = -1 THEN
		MessageBox("확인", "매입일자를 확인하십시오.!!")
		dw_cond.SetColumn("pur_tdate")
		dw_cond.SetFocus()
		Return 
	END IF	
END IF         

lstr_us_in.schk_gu = Trim(dw_cond.GetitemString(1, "kfm06ot0_check_gu"))
lstr_us_in.suse_gu = Trim(dw_cond.GetitemString(1, "kfm06ot0_use_gu"))
IF lstr_us_in.suse_gu ="" OR ISNULL(lstr_us_in.suse_gu) THEN lstr_us_in.suse_gu = '%'

IF dw_2.Retrieve(lstr_us_in.schk_bnk, lstr_us_in.spur_date, &
                    lstr_us_in.spur_date2, lstr_us_in.schk_gu, lstr_us_in.suse_gu ) <= 0  THEN
	F_MessageChk(14,'')
	return  
END IF

end event

type p_del from w_inherite`p_del within w_kfia80
integer taborder = 50
end type

event p_del::clicked;call super::clicked;string s_RowNbr,sChkGbn
long iCurRow

IF dw_2.GetSelectedRow(0) <=0 THEN Return

IF F_DbConFirm('삭제') = 2 THEN Return

DO WHILE true
	iCurRow = 	dw_2.GetSelectedRow(0)
	If iCurRow = 0 then EXIT
	
	s_RowNbr = dw_2.GetitemString(iCurRow, "kfm06ot0_check_no" )   	
	sChkGbn  = dw_2.GetitemString(iCurRow, "kfm06ot0_check_gu" )   	
	
	dw_2.deleterow(iCurRow)	
	IF dw_2.Update() = 1 THEN
//		Wf_Access_Kfz04om0(s_RowNbr,'99',sChkGbn)
	ELSE
		F_MessageChk(12,'')
		Rollback;
		Return 
	END IF
Loop
Commit;

dw_1.Enabled = False

p_mod.Enabled = False
p_mod.PictureName = "C:\erpman\image\저장_d.gif"

p_del.Enabled = False
p_del.PictureName = "C:\erpman\image\삭제_d.gif"

p_ins.Enabled = True
p_ins.PictureName = "C:\erpman\image\생성_up.gif"

ib_any_typing = False

dw_1.SetRedraw(FALSE)
dw_1.Reset()
dw_1.InsertRow(0)
dw_1.SetRedraw(TRUE)

p_ins.setfocus()
end event

type p_mod from w_inherite`p_mod within w_kfia80
integer taborder = 40
end type

event p_mod::clicked;call super::clicked;long dis_row

IF dw_1.AcceptText() = -1 THEN 
	f_messagechk( 13,"") 
	RETURN
END IF  

IF Wf_ReqChk() = -1 then Return

IF dw_1.Update() = 1 THEN
	COMMIT;	
	w_mdi_frame.sle_msg.text ="자료를 저장하였습니다.!!!"
	
	dw_1.SetRedraw(FALSE)
	dw_2.SetRedraw(FALSE)
	
   dw_1.Reset()
   dw_1.InsertRow(0)
	
	dw_2.Retrieve(lstr_us_in.schk_bnk, lstr_us_in.spur_date, &
                 lstr_us_in.spur_date2, lstr_us_in.schk_gu, lstr_us_in.suse_gu ) 
	dis_row =dw_2.RowCount()
	dw_2.ScrollToRow(dis_row)
	
   dw_1.SetRedraw(TRUE)
   dw_2.SetRedraw(TRUE)
	
ELSE
	ROLLBACK;
   f_messagechk( 13,"")
	Return
END IF

//dw_1.Enabled = False

//p_ins.Enabled = True
//
//p_mod.Enabled = False
//p_del.Enabled = False

ib_any_typing = False

p_ins.setfocus()
end event

type cb_exit from w_inherite`cb_exit within w_kfia80
boolean visible = false
integer x = 2926
integer y = 2756
end type

type cb_mod from w_inherite`cb_mod within w_kfia80
boolean visible = false
integer x = 1847
integer y = 2760
end type

type cb_ins from w_inherite`cb_ins within w_kfia80
boolean visible = false
integer x = 1413
integer y = 2752
string text = "추가(&A)"
end type

type cb_del from w_inherite`cb_del within w_kfia80
boolean visible = false
integer x = 2208
integer y = 2760
end type

type cb_inq from w_inherite`cb_inq within w_kfia80
boolean visible = false
integer x = 1170
integer y = 2412
end type

event cb_inq::clicked;call super::clicked;//string s_RowNbr 
//long dis_row
//
//s_RowNbr = dw_2.GetitemString(dw_2.getrow(), "kfm06ot0_check_no" )   
//
//IF MessageBox("확인","용지번호 "+s_RowNbr+" 번을 삭제하시겠습니까?",Question!,YesNo!) &
//    = 2 THEN RETURN
//
//dw_1.SetRedraw ( FALSE )
//
//dw_1.deleterow(0)
//IF dw_1.Update() = 1 THEN
//	
//	Wf_Access_Kfz04om0(s_RowNbr,'99')
//	
//	COMMIT;
//	
//	sle_msg.text ="자료가 삭제되었습니다.!!!"
//	dw_1.SetRedraw(FALSE)
//	dw_2.SetRedraw(FALSE)
//   dw_1.Reset()
//   dw_1.InsertRow(0)
//	dw_2.Retrieve(lstr_us_in.schk_bnk, lstr_us_in.schk_bnk2, lstr_us_in.spur_date, &
//                 lstr_us_in.spur_date2, lstr_us_in.schk_gu, lstr_us_in.schk_no1, & 
//    				  lstr_us_in.schk_no2, lstr_us_in.suse_gu ) 
//	dis_row =dw_2.RowCount()
//	dw_2.ScrollToRow(dis_row)
//   dw_1.SetRedraw(TRUE)
//   dw_2.SetRedraw(TRUE)
//ELSE
//	ROLLBACK;
//	f_messagechk(12,"") 
//	Return 
//END IF
//
//dw_1.SetRedraw ( TRUE )
//
//dw_1.Enabled = False
//cb_ins.Enabled = True
//cb_search.Enabled = True
//cb_mod.Enabled = False
//cb_del.Enabled = False
//ib_any_typing = False
//cb_ins.setfocus()
end event

type cb_print from w_inherite`cb_print within w_kfia80
boolean visible = false
integer x = 1527
integer y = 2412
end type

type st_1 from w_inherite`st_1 within w_kfia80
boolean visible = false
integer width = 279
end type

type cb_can from w_inherite`cb_can within w_kfia80
boolean visible = false
integer x = 2569
integer y = 2760
end type

type cb_search from w_inherite`cb_search within w_kfia80
boolean visible = false
integer x = 919
integer y = 2752
end type

type dw_datetime from w_inherite`dw_datetime within w_kfia80
boolean visible = false
end type

type sle_msg from w_inherite`sle_msg within w_kfia80
boolean visible = false
integer x = 315
integer width = 2523
end type

type gb_10 from w_inherite`gb_10 within w_kfia80
boolean visible = false
end type

type gb_button1 from w_inherite`gb_button1 within w_kfia80
boolean visible = false
integer x = 887
integer y = 2700
integer width = 887
end type

type gb_button2 from w_inherite`gb_button2 within w_kfia80
boolean visible = false
integer x = 1819
integer y = 2704
end type

type dw_1 from datawindow within w_kfia80
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 3118
integer y = 192
integer width = 1509
integer height = 1724
integer taborder = 30
string dataobject = "dw_kfia802"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event editchanged;w_mdi_frame.sle_msg.text =""

ib_any_typing =True
end event

event itemchanged;String snull,sSaupNo,sSaupName

SetNull(snull)

IF this.GetColumnName() ="kfm06ot0_saupj" THEN
	IF this.GetText() ="" OR IsNull(this.GetText()) THEN RETURN 
	
	IF IsNull(F_Get_Refferance('AD',this.GetText())) THEN
		f_messagechk(20,"사업장")
		dw_1.SetItem(1,"kfm06ot0_saupj",snull)
		Return 1
   END IF
END IF

IF this.GetColumnName() ="kfm06ot0_check_bnk" THEN
	sSaupNo = this.GetText()
	IF sSaupNo ="" OR IsNull(sSaupNo) THEN RETURN 
	
	sSaupName = F_Get_PersonLst('2',sSaupNo,'%')
	IF sSaupName = '' or IsNull(sSaupName) THEN
		f_messagechk(20,"[금융기관]")
		dw_1.SetItem(1,"kfm06ot0_check_bnk",snull)
		Return 1
   END IF
END IF

IF this.GetColumnName() ="kfm06ot0_chk_cus" THEN
	sSaupNo = this.GetText()
	IF sSaupNo ="" OR IsNull(sSaupNo) THEN RETURN 
	
	sSaupName = F_Get_PersonLst('1',sSaupNo,'%')
	IF sSaupName = '' or IsNull(sSaupName) THEN
		f_messagechk(20,"거래처")
		dw_1.SetItem(1,"kfm06ot0_chk_cus",snull)
		dw_1.SetItem(1,"kfz04om0_person_nm",snull)
		Return 1
	ELSE
		dw_1.SetItem(1,"kfz04om0_person_nm",sSaupName)
   END IF
END IF

IF this.GetColumnName() ="kfm06ot0_g_date" THEN
	IF this.GetText() ="" OR IsNull(this.GetText()) THEN RETURN 
	
	IF f_datechk(this.GetText()) = -1 THEN 
		f_messagechk(20,"견질일자")
		dw_1.SetItem(1,"kfm06ot0_g_date",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="kfm06ot0_p_date" THEN
	IF this.GetText() ="" OR IsNull(this.GetText()) THEN RETURN 
	
	IF f_datechk(this.GetText()) = -1 THEN 
		f_messagechk(20,"폐기일자")
		dw_1.SetItem(1,"kfm06ot0_p_date",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="kfm06ot0_chk_bal_dat" THEN
	IF this.GetText() ="" OR IsNull(this.GetText()) THEN RETURN 
	
	IF f_datechk(this.GetText()) = -1 THEN 
		f_messagechk(20,"발행일자")
		dw_1.SetItem(1,"kfm06ot0_chk_bal_dat",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="kfm06ot0_chk_man_dat" THEN
	IF this.GetText() ="" OR IsNull(this.GetText()) THEN RETURN 
	
	IF f_datechk(this.GetText()) = -1 THEN 
		f_messagechk(20,"결제/회수일자")
		dw_1.SetItem(1,"kfm06ot0_chk_man_dat",snull)
		Return 1
	END IF
END IF





end event

event itemerror;return 1
end event

event rbuttondown;String snull

SetNull(snull)

IF this.GetColumnName() ="kfm06ot0_chk_cus" THEN
	
	SetNull(lstr_custom.code)
	SetNull(lstr_custom.name)
	
	lstr_custom.code = dw_1.GetItemString(1,"kfm06ot0_chk_cus")
	
	IF IsNull(lstr_custom.code) THEN lstr_custom.code = ""
	
	OpenWithParm(W_KFZ04OM0_POPUP,'1')
	
	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
	
	this.SetItem(this.GetRow(),"kfm06ot0_chk_cus",lstr_custom.code)
	this.SetItem(this.GetRow(),"kfz04om0_person_nm", lstr_custom.name)
END IF

end event

type dw_2 from u_d_select_sort within w_kfia80
integer x = 59
integer y = 200
integer width = 3045
integer height = 2016
integer taborder = 0
boolean bringtotop = true
string dataobject = "dw_kfia803"
boolean border = false
end type

event clicked;If Row <= 0 then
	b_flag =True
ELSE
	b_flag = False
	
	w_mdi_frame.sle_msg.text =""
	
	dw_1.Retrieve(dw_2.getitemstring(row,"kfm06ot0_check_no"))
	
	p_mod.Enabled = True
	p_mod.PictureName = "C:\erpman\image\저장_up.gif"
	
	p_del.Enabled = True
	p_del.PictureName = "C:\erpman\image\삭제_up.gif"

	p_ins.Enabled = False
	p_ins.PictureName = "C:\erpman\image\생성_d.gif"
	
	dw_1.Enabled = True

END IF

CALL SUPER ::CLICKED
end event

event rbuttondown;IF Row <=0 THEN Return

SelectRow(Row,False)
end event

type rr_1 from roundrectangle within w_kfia80
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 192
integer width = 3072
integer height = 2036
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_cond from u_key_enter within w_kfia80
integer x = 41
integer y = 36
integer width = 3479
integer height = 136
integer taborder = 10
string dataobject = "dw_kfia801"
boolean border = false
end type

