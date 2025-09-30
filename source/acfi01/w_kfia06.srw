$PBExportHeader$w_kfia06.srw
$PBExportComments$받을어음 수탁 등록
forward
global type w_kfia06 from w_inherite
end type
type dw_1 from datawindow within w_kfia06
end type
type cb_2 from commandbutton within w_kfia06
end type
type gb_1 from groupbox within w_kfia06
end type
type rb_1 from radiobutton within w_kfia06
end type
type rb_2 from radiobutton within w_kfia06
end type
type rr_1 from roundrectangle within w_kfia06
end type
type dw_2 from u_d_popup_sort within w_kfia06
end type
end forward

global type w_kfia06 from w_inherite
string title = "받을어음 수탁 처리"
dw_1 dw_1
cb_2 cb_2
gb_1 gb_1
rb_1 rb_1
rb_2 rb_2
rr_1 rr_1
dw_2 dw_2
end type
global w_kfia06 w_kfia06

type variables
String    sUpmuGbn = 'Z'
end variables

forward prototypes
public subroutine wf_setting_data (integer ll_row, string chk_gu)
public function integer wf_insert_kfz12otd ()
public function string wf_bef_status (string sbillno)
end prototypes

public subroutine wf_setting_data (integer ll_row, string chk_gu);String symd,sbnk,snull

SetNull(snull)

symd = Trim(dw_1.GetItemString(dw_1.Getrow(),"chu_ymd"))
sbnk = dw_1.GetItemString(dw_1.GetRow(),"chu_bnk")

IF rb_1.Checked = True THEN									/*수탁 처리*/
	IF chk_gu ='1' THEN
		dw_2.SetItem(ll_row,"chu_ymd",symd)
		dw_2.SetItem(ll_row,"chu_bnk",sbnk)
		dw_2.SetItem(ll_row,"status",'3')
	ELSE
		dw_2.SetItem(ll_row,"chu_ymd",snull)
		dw_2.SetItem(ll_row,"chu_bnk",snull)
		dw_2.SetItem(ll_row,"status", dw_2.GetItemString(ll_row,"old_status"))
	END IF
ELSE																	/*수탁 취소 처리*/		
	IF chk_gu ='1' THEN
		dw_2.SetItem(ll_row,"chu_ymd",snull)
		dw_2.SetItem(ll_row,"chu_bnk",snull)
		dw_2.SetItem(ll_row,"status", Wf_Bef_Status(dw_2.GetItemString(ll_row,"bill_no")))
	ELSE
		dw_2.SetItem(ll_row,"chu_ymd",dw_2.GetItemString(ll_row,"old_chu_ymd"))
		dw_2.SetItem(ll_row,"chu_bnk",dw_2.GetItemString(ll_row,"old_chu_bnk"))
		dw_2.SetItem(ll_row,"status", dw_2.GetItemString(ll_row,"old_status"))
	END IF
END IF

end subroutine

public function integer wf_insert_kfz12otd ();Integer k,iCurRow
Long    lJunNo,iLinNo,lSeqNo
String  sBillNo,sSaupj,sBalDate,sFullJunNo
	
IF rb_1.Checked = True THEN									/*받을어음 수탁 처리*/
	dw_1.AcceptText()
	sBalDate = dw_1.GetItemString(1,"chu_ymd")
	sSaupj   = Gs_Saupj
	
	lJunNo = Sqlca.Fun_Calc_JunNo('B',sSaupj,sUpmuGbn,sBalDate)						/*전표번호 채번*/
	iLinNo = 1
	
	FOR k = 1 TO dw_2.RowCount()
		IF dw_2.GetItemString(k,"chk") = '1' THEN				/*추심 선택*/
			sBillNo = dw_2.GetItemString(k,"bill_no")
	
			select max(nvl(to_number(substr(full_junno,1,5)),0))		into :LSeqNo
				from kfz12otd
				where bill_no = :sBillNo;
			IF SQLCA.SQLCODE <> 0 THEN
				LSeqNo = 0
			ELSE
				IF IsNull(LSeqNo) THEN LSeqNo = 0
			END IF
			LSeqNo = LSeqNo + 1
				
			sFullJunNo = String(LSeqNo,'00000')+ String(Integer(sSaupj),'00')+sBalDate+sUpmuGbn+String(lJunNo,'0000')+String(iLinNo,'000')
		
			iCurRow = dw_insert.InsertRow(0)
			dw_insert.SetItem(iCurRow,"saupj",					sSaupj)
			dw_insert.SetItem(iCurRow,"bal_date",				sBalDate)
			dw_insert.SetItem(iCurRow,"upmu_gu",				sUpmuGbn)
			dw_insert.SetItem(iCurRow,"bjun_no",				lJunNo)
			dw_insert.SetItem(iCurRow,"lin_no",		   		iLinNo)
			dw_insert.SetItem(iCurRow,"full_junno",			sFullJunNo)
		
			dw_insert.SetItem(iCurRow,"bill_no",				dw_2.GetItemString(k,"bill_no"))
			dw_insert.SetItem(iCurRow,"saup_no",				dw_2.GetItemString(k,"saup_no"))
			dw_insert.SetItem(iCurRow,"bnk_cd",					dw_2.GetItemString(k,"bnk_cd"))
			dw_insert.SetItem(iCurRow,"bbal_dat",				dw_2.GetItemString(k,"bbal_dat"))
			dw_insert.SetItem(iCurRow,"bman_dat",				dw_2.GetItemString(k,"bman_dat"))
			dw_insert.SetItem(iCurRow,"bill_amt",				dw_2.GetItemNumber(k,"bill_amt"))
			dw_insert.SetItem(iCurRow,"bill_nm",				dw_2.GetItemString(k,"bill_nm"))
			dw_insert.SetItem(iCurRow,"bill_ris",				dw_2.GetItemString(k,"bill_ris"))
			dw_insert.SetItem(iCurRow,"bill_gu",				dw_2.GetItemString(k,"bill_gu"))
			dw_insert.SetItem(iCurRow,"bill_jigu",				dw_2.GetItemString(k,"bill_jigu"))
			
			dw_insert.SetItem(iCurRow,"chu_ymd",				dw_2.GetItemString(k,"chu_ymd"))
			dw_insert.SetItem(iCurRow,"chu_bnk",				dw_2.GetItemString(k,"chu_bnk"))
			
			dw_insert.SetItem(iCurRow,"status",					dw_2.GetItemString(k,"status"))
			dw_insert.SetItem(iCurRow,"bill_ntinc",			dw_2.GetItemString(k,"bill_ntinc"))
			dw_insert.SetItem(iCurRow,"bill_change_date",	dw_2.GetItemString(k,"bill_change_date"))

			dw_insert.SetItem(iCurRow,"remark1",				'추심')
			dw_insert.SetItem(iCurRow,"owner_saupj",			dw_2.GetItemString(k,"owner_saupj"))
			dw_insert.SetItem(iCurRow,"alc_gu",					'Y')
			dw_insert.SetItem(iCurRow,"acc_date",				sBalDate)
			dw_insert.SetItem(iCurRow,"jun_no",					lJunNo)
			iLinNo = iLinNo + 1
		END IF	
	NEXT
	IF dw_insert.Update() = 1 THEN
		Return 1
	ELSE
		Return -1
	END IF	
ELSE																	/*받을어음 수탁 취소 처리*/
	FOR k = 1 TO dw_2.RowCount()
		IF dw_2.GetItemString(k,"chk") = '1' THEN				/*취소 선택*/
			sBillNo  = dw_2.GetItemString(k,"bill_no")
			sBalDate = dw_2.GetItemString(k,"old_chu_ymd")		
			
			SELECT "KFZ12OTD"."FULL_JUNNO"      INTO :sFullJunNo
			   FROM "KFZ12OTD"  
   			WHERE ( "KFZ12OTD"."BILL_NO"  = :sBillNo ) AND  ( "KFZ12OTD"."BAL_DATE" = :sBalDate ) AND  
			         ( "KFZ12OTD"."UPMU_GU"  = :sUpmuGbn ) ;
			IF SQLCA.SQLCODE = 0 THEN
				delete from kfz12otd
					where full_junno = :sFullJunNo;
			ELSE
				Return -1
			END IF
		END IF	
	NEXT
END IF
Return 1
end function

public function string wf_bef_status (string sbillno);String sStatus,sCurJunNo,sFullJunNo

select Max(full_junno)	into :sFullJunNo
	from kfz12otd
	where bill_no  = :sBillNo ;
IF SQLCA.SQLCODE <> 0 THEN
	sFullJunNo = '0'
ELSE
	IF IsNull(sfullJunNo) THEN sFullJunNo = '0'
END IF

select Max(full_junno)	into :sCurJunNo
	from kfz12otd
	where bill_no  = :sBillNo and full_junno < :sFullJunNo;
IF SQLCA.SQLCODE <> 0 THEN
	sCurJunNo = '0'
ELSE
	IF IsNull(sCurJunNo) THEN sCurJunNo = '0'
END IF	

IF sCurJunNo = '0' then
	sStatus = '3'
else
	select status	into :sStatus
		from kfz12otd
		where bill_no  = :sBillNo and full_junno = :sCurJunNo ;
end if

Return sStatus
end function

on w_kfia06.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.cb_2=create cb_2
this.gb_1=create gb_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rr_1=create rr_1
this.dw_2=create dw_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.gb_1
this.Control[iCurrent+4]=this.rb_1
this.Control[iCurrent+5]=this.rb_2
this.Control[iCurrent+6]=this.rr_1
this.Control[iCurrent+7]=this.dw_2
end on

on w_kfia06.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.cb_2)
destroy(this.gb_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rr_1)
destroy(this.dw_2)
end on

event open;call super::open;String sbnk_min

dw_insert.SetTransObject(SQLCA)

dw_1.SetTransObject(SQLCA)
dw_1.InsertRow(0)


SELECT MIN("KFZ04OM0"."PERSON_CD") 
	INTO :sbnk_min  
   FROM "KFZ04OM0"  
   WHERE ( "KFZ04OM0"."PERSON_GU" = '2' )   ;
				
dw_1.SetItem(dw_1.GetRow(),"sman_date",String(today(),"yyyymm")+"01")
dw_1.SetItem(dw_1.GetRow(),"eman_date",String(today(),"yyyymmdd"))

dw_1.SetItem(dw_1.GetRow(),"chu_ymd",String(today(),"yyyymmdd"))

dw_1.SetItem(dw_1.GetRow(),"chu_bnk",sbnk_min)

dw_2.SetTransObject(SQLCA)

dw_1.SetColumn("sman_date")
dw_1.Setfocus()

end event

type dw_insert from w_inherite`dw_insert within w_kfia06
boolean visible = false
integer x = 722
integer y = 2384
integer height = 100
integer taborder = 0
string dataobject = "d_kfia021"
end type

type p_delrow from w_inherite`p_delrow within w_kfia06
boolean visible = false
integer x = 3470
integer y = 2736
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kfia06
boolean visible = false
integer x = 3296
integer y = 2736
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kfia06
boolean visible = false
integer x = 2601
integer y = 2736
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_kfia06
boolean visible = false
integer x = 3122
integer y = 2736
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_kfia06
integer y = 0
integer taborder = 50
end type

type p_can from w_inherite`p_can within w_kfia06
boolean visible = false
integer x = 3991
integer y = 2736
integer taborder = 0
end type

type p_print from w_inherite`p_print within w_kfia06
boolean visible = false
integer x = 2775
integer y = 2736
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kfia06
integer x = 4096
integer y = 0
end type

event p_inq::clicked;call super::clicked;
String sdate,edate,sStatus1,sStatus2

w_mdi_frame.sle_msg.text =""

dw_1.AcceptText()
sdate =dw_1.GetItemString(dw_1.Getrow(),"sman_date")
edate =dw_1.GetItemString(dw_1.Getrow(),"eman_date")

IF rb_1.Checked = True THEN					/*수탁 처리*/
	sStatus1 = '1';		sStatus2 = '8';
ELSE
	sStatus1 = '3';		sStatus2 = '3';
END IF

dw_2.SetFilter("")
dw_2.FilTer()

IF dw_2.Retrieve(sdate,edate,sStatus1,sStatus2) <= 0 THEN
	F_MessageChk(14,'')
	Return
END IF




end event

type p_del from w_inherite`p_del within w_kfia06
boolean visible = false
integer x = 3817
integer y = 2736
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_kfia06
integer x = 4270
integer y = 0
integer taborder = 40
end type

event p_mod::clicked;call super::clicked;
w_mdi_frame.sle_msg.text =""

dw_2.AcceptText()

dw_2.SetFilter("chk = '1'")
dw_2.FilTer()
	
IF dw_2.Update() <> 1 THEN
	F_MessageChk(13,'')
	ROLLBACK;
	Return
END IF
IF Wf_Insert_Kfz12otd() = -1 THEN
	F_MessageChk(13,'[받을어음 이력]')
	Rollback;
	Return
END IF
Commit;

p_inq.TriggerEvent(Clicked!)

w_mdi_frame.sle_msg.text ="받을어음 수탁 처리 완료"
end event

type cb_exit from w_inherite`cb_exit within w_kfia06
boolean visible = false
integer x = 3639
integer y = 2496
end type

type cb_mod from w_inherite`cb_mod within w_kfia06
boolean visible = false
integer x = 1230
integer y = 2504
end type

type cb_ins from w_inherite`cb_ins within w_kfia06
boolean visible = false
integer x = 178
integer y = 2504
end type

type cb_del from w_inherite`cb_del within w_kfia06
boolean visible = false
integer x = 891
integer y = 2504
end type

type cb_inq from w_inherite`cb_inq within w_kfia06
boolean visible = false
integer x = 2935
integer y = 2492
end type

type cb_print from w_inherite`cb_print within w_kfia06
boolean visible = false
integer x = 1605
integer y = 2504
end type

type st_1 from w_inherite`st_1 within w_kfia06
boolean visible = false
integer x = 0
integer y = 2876
integer width = 302
end type

type cb_can from w_inherite`cb_can within w_kfia06
boolean visible = false
integer x = 1979
integer y = 2508
end type

type cb_search from w_inherite`cb_search within w_kfia06
boolean visible = false
integer x = 2331
integer y = 2508
end type

type dw_datetime from w_inherite`dw_datetime within w_kfia06
boolean visible = false
integer x = 2843
integer y = 2876
end type

type sle_msg from w_inherite`sle_msg within w_kfia06
boolean visible = false
integer x = 320
integer y = 2876
integer width = 2533
end type

type gb_10 from w_inherite`gb_10 within w_kfia06
boolean visible = false
integer y = 2852
end type

type gb_button1 from w_inherite`gb_button1 within w_kfia06
boolean visible = false
integer x = 165
integer y = 2444
integer width = 421
end type

type gb_button2 from w_inherite`gb_button2 within w_kfia06
boolean visible = false
integer x = 1344
integer y = 2712
integer width = 809
end type

type dw_1 from datawindow within w_kfia06
event ue_pressenter pbm_dwnprocessenter
integer x = 50
integer y = 16
integer width = 3022
integer height = 128
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_kfia061"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemerror;
Return 1
end event

event itemchanged;String ssql,snull

SetNull(snull)

IF dwo.name ="sman_date" THEN
	
	IF Trim(data) ="" OR IsNull(Trim(data)) THEN RETURN 1
	
	IF f_datechk(Trim(data)) = -1 THEN 
		f_messagechk(20,"만기일자")
		dw_1.SetItem(1,"sman_date",snull)
		Return 1
	END IF
END IF

IF dwo.name ="eman_date" THEN
	
	IF Trim(data) ="" OR IsNull(Trim(data)) THEN RETURN 1
	
	IF f_datechk(Trim(data)) = -1 THEN 
		f_messagechk(20,"만기일자") 
		dw_1.SetItem(1,"eman_date",snull)
		Return 1
	END IF
END IF

IF dwo.name ="chu_ymd" THEN
	
	IF Trim(data) ="" OR IsNull(Trim(data)) THEN RETURN 1
	
	IF f_datechk(Trim(data)) = -1 THEN 
		f_messagechk(20,"수탁일자")
		dw_1.SetItem(1,"chu_ymd",snull)
		Return 1
	END IF
END IF

//지급은행//
IF dwo.name ="chu_bnk" THEN
	
	IF data ="" OR IsNull(data) THEN RETURN 
	
	SELECT "KFZ04OM0"."PERSON_NM"  
   	INTO :ssql  
    	FROM "KFZ04OM0"  
   	WHERE ( "KFZ04OM0"."PERSON_CD" = :data ) AND  
         	( "KFZ04OM0"."PERSON_GU" = '2' )   ;
	IF SQLCA.SQLCODE <> 0 THEN
		f_messagechk(20,"수탁은행")
		dw_1.SetItem(1,"chu_bnk",snull)
		Return 1
	END IF
END IF






end event

event getfocus;this.AcceptText()
end event

type cb_2 from commandbutton within w_kfia06
boolean visible = false
integer x = 3291
integer y = 2492
integer width = 334
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "처리(&P)"
end type

type gb_1 from groupbox within w_kfia06
integer x = 3109
integer width = 969
integer height = 148
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
string text = "작업선택"
borderstyle borderstyle = stylelowered!
end type

type rb_1 from radiobutton within w_kfia06
integer x = 3141
integer y = 52
integer width = 430
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "수탁 처리"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;dw_2.Reset()
end event

type rb_2 from radiobutton within w_kfia06
integer x = 3598
integer y = 52
integer width = 439
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "수탁취소 처리"
borderstyle borderstyle = stylelowered!
end type

event clicked;dw_2.Reset()
end event

type rr_1 from roundrectangle within w_kfia06
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 156
integer width = 4553
integer height = 2072
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_2 from u_d_popup_sort within w_kfia06
integer x = 73
integer y = 168
integer width = 4521
integer height = 2052
integer taborder = 30
string dataobject = "d_kfia062"
boolean vscrollbar = true
boolean border = false
end type

event itemchanged;String snull,symd,sbnk

SetNull(snull)

dw_1.AcceptText()

IF dwo.name ="chk" THEN
	IF rb_2.Checked = True and data = '1' THEN
		IF Wf_Bef_Status(this.GetItemString(row,"bill_no")) = '3' THEN
			this.SetItem(row,"chu_ymd",   this.GetItemString(row,"old_chu_ymd"))
			this.SetItem(row,"chu_bnk",   this.GetItemString(row,"old_chu_bnk"))
			this.SetItem(row,"status",    this.GetItemString(row,"old_status"))
			Return 2	
		END IF
	END IF
	wf_setting_data(dw_2.Getrow(),data)
	
END IF
end event

event clicked;
If Row <= 0 then
	b_flag = True
ELSE

	b_flag = False
END IF

call super ::clicked
end event

