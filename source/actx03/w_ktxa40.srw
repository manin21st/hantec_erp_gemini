$PBExportHeader$w_ktxa40.srw
$PBExportComments$부가세 신고서 조회 출력
forward
global type w_ktxa40 from w_inherite
end type
type tab_vat from tab within w_ktxa40
end type
type tabpage_print1 from userobject within tab_vat
end type
type rr_2 from roundrectangle within tabpage_print1
end type
type dw_print from datawindow within tabpage_print1
end type
type tabpage_print1 from userobject within tab_vat
rr_2 rr_2
dw_print dw_print
end type
type tabpage_print2 from userobject within tab_vat
end type
type rr_3 from roundrectangle within tabpage_print2
end type
type dw_print2 from datawindow within tabpage_print2
end type
type tabpage_print2 from userobject within tab_vat
rr_3 rr_3
dw_print2 dw_print2
end type
type tab_vat from tab within w_ktxa40
tabpage_print1 tabpage_print1
tabpage_print2 tabpage_print2
end type
type dw_ip from u_key_enter within w_ktxa40
end type
end forward

global type w_ktxa40 from w_inherite
string title = "부가세 신고서 조회 출력"
tab_vat tab_vat
dw_ip dw_ip
end type
global w_ktxa40 w_ktxa40

type variables
Int ll_row
String s_jasacode,sRptPath,sApplyFlag
end variables

event open;call super::open;dw_ip.SetTransObject(SQLCA)
tab_vat.tabpage_print1.dw_print.SetTransObject(SQLCA)
tab_vat.tabpage_print2.dw_print2.SetTransObject(SQLCA)

dw_ip.Reset()
dw_ip.InsertRow(0)

dw_ip.SetItem(dw_ip.GetRow(),"procgbn","2")

tab_vat.SelectedTab = 1
end event

on w_ktxa40.create
int iCurrent
call super::create
this.tab_vat=create tab_vat
this.dw_ip=create dw_ip
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_vat
this.Control[iCurrent+2]=this.dw_ip
end on

on w_ktxa40.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_vat)
destroy(this.dw_ip)
end on

type dw_insert from w_inherite`dw_insert within w_ktxa40
boolean visible = false
integer x = 293
integer y = 2248
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_ktxa40
boolean visible = false
integer x = 3753
integer y = 2528
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_ktxa40
boolean visible = false
integer x = 3579
integer y = 2528
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_ktxa40
boolean visible = false
integer x = 2885
integer y = 2528
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_ktxa40
boolean visible = false
integer x = 3406
integer y = 2528
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_ktxa40
integer x = 4416
integer y = 20
integer taborder = 0
end type

type p_can from w_inherite`p_can within w_ktxa40
boolean visible = false
integer x = 4274
integer y = 2528
integer taborder = 0
end type

type p_print from w_inherite`p_print within w_ktxa40
integer x = 4242
integer y = 20
integer taborder = 0
end type

event p_print::clicked;call super::clicked;if tab_vat.tabpage_print1.dw_print.RowCount() > 0 then
	gi_page = tab_vat.tabpage_print1.dw_print.GetItemNumber(1,"last_page")
	OpenWithParm(w_print_options,tab_vat.tabpage_print1.dw_print)	
end if

if tab_vat.tabpage_print2.dw_print2.RowCount() > 0 then
	gi_page = tab_vat.tabpage_print2.dw_print2.GetItemNumber(1,"last_page")
	OpenWithParm(w_print_options,tab_vat.tabpage_print2.dw_print2)	
end if
end event

type p_inq from w_inherite`p_inq within w_ktxa40
integer x = 4069
integer y = 20
integer taborder = 0
end type

event p_inq::clicked;call super::clicked;string ls_vatgisu, ls_sdate, ls_edate, ls_procgbn, ls_jasacode, ls_commjasa, ls_flag, sSaupj
string ls_sano

dw_ip.accepttext()

p_print.Enabled = False

//조건 accept
ls_vatgisu = dw_ip.GetItemString(dw_ip.GetRow(),"vatgisu") 		//부가세기수
IF ls_vatgisu ="" OR IsNull(ls_vatgisu) THEN
	f_messagechk(1,"부가세 기수")
	dw_ip.SetColumn("vatgisu")
	dw_ip.SetFocus()
	RETURN
END IF

ls_sdate   = Trim(dw_ip.GetItemString(dw_ip.GetRow(),"sdate"))	//거래기간
IF ls_sdate ="" OR IsNull(ls_sdate) THEN
	f_messagechk(1,"거래기간(FROM)")
	dw_ip.SetColumn("sdate")
	dw_ip.SetFocus()
	RETURN
END IF

ls_edate   = Trim(dw_ip.GetItemString(dw_ip.GetRow(),"edate"))
IF ls_edate ="" OR IsNull(ls_edate) THEN
	f_messagechk(1,"거래기간(END)")
	dw_ip.SetColumn("edate")
	dw_ip.SetFocus()
	RETURN
END IF

ls_procgbn = dw_ip.GetItemString(dw_ip.GetRow(),"procgbn")		//납부구분

ls_jasacode = dw_ip.GetItemString(dw_ip.GetRow(),"jasa_cd")		//자사코드
IF ls_jasacode ="" OR IsNull(ls_jasacode) THEN
	f_messagechk(1,"자사코드")
	dw_ip.SetColumn("jasa_cd")
	dw_ip.SetFocus()
	RETURN
END IF

IF ls_procgbn = '1' THEN	/* 총괄납부 */
	ls_jasacode = '%'
	ls_flag = '1'

	SELECT "SYSCNFG"."DATANAME"  
		INTO :ls_commjasa
		FROM "SYSCNFG"  
		WHERE ( "SYSCNFG"."SYSGU" = 'C' ) AND ( "SYSCNFG"."SERIAL" = 4 ) AND  
				( "SYSCNFG"."LINENO" = '1' )   ;
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(56,'[자사코드(C-4-1)]')
		dw_ip.setfocus()
		Return
	ELSE
		IF IsNull(ls_commjasa) OR ls_commjasa = "" THEN
			F_MessageChk(56,'[자사코드(C-4-1)]')
			dw_ip.setfocus()
			Return
		END IF
	END IF
ELSE
	ls_commjasa = ls_jasacode
	ls_flag = '%'
END IF

select rfna3	into :sSaupj from reffpf where rfcod = 'JA' and rfgub = :ls_commjasa;
if sSaupj = '' or IsNull(sSaupj) then sSaupj = '10'
	
if tab_vat.tabpage_print1.dw_print.retrieve(ls_commjasa,ls_jasacode,ls_vatgisu,ls_sdate, ls_edate,'%',sSaupj) < 1 then
	f_messagechk(14,"")
	tab_vat.tabpage_print1.dw_print.SetFocus()
	Return
else
	SELECT "VNDMST"."SANO"     	INTO :ls_sano
		FROM "VNDMST"  
		WHERE "VNDMST"."CVCOD" = :ls_commjasa;
	IF SQLCA.SQLCODE = 0 THEN
		tab_vat.tabpage_print2.dw_print2.Modify("s1.text  ='"+Mid(ls_sano,1,1)+"'")
		tab_vat.tabpage_print2.dw_print2.Modify("s2.text  ='"+Mid(ls_sano,2,1)+"'")
		tab_vat.tabpage_print2.dw_print2.Modify("s3.text  ='"+Mid(ls_sano,3,1)+"'")
		tab_vat.tabpage_print2.dw_print2.Modify("s4.text  ='"+Mid(ls_sano,4,1)+"'")
		tab_vat.tabpage_print2.dw_print2.Modify("s5.text  ='"+Mid(ls_sano,5,1)+"'")
		tab_vat.tabpage_print2.dw_print2.Modify("s6.text  ='"+Mid(ls_sano,6,1)+"'")
		tab_vat.tabpage_print2.dw_print2.Modify("s7.text  ='"+Mid(ls_sano,7,1)+"'")
		tab_vat.tabpage_print2.dw_print2.Modify("s8.text  ='"+Mid(ls_sano,8,1)+"'")
		tab_vat.tabpage_print2.dw_print2.Modify("s9.text  ='"+Mid(ls_sano,9,1)+"'")
		tab_vat.tabpage_print2.dw_print2.Modify("s10.text ='"+Mid(ls_sano,10,1)+"'")
	END IF
	if tab_vat.tabpage_print2.dw_print2.retrieve(ls_jasacode,ls_vatgisu,ls_sdate,ls_edate,ls_flag) <=0 then
		tab_vat.tabpage_print2.dw_print2.InsertRow(0)
	end if 
end if	

p_print.Enabled = True
end event
type p_del from w_inherite`p_del within w_ktxa40
boolean visible = false
integer x = 4101
integer y = 2528
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_ktxa40
event ue_work_maichul_list pbm_custom01
event ue_work_maiip_list pbm_custom02
boolean visible = false
integer x = 4069
integer y = 20
integer taborder = 30
string pointer = "C:\erpman\cur\create.cur"
boolean enabled = false
string picturename = "C:\erpman\image\처리_up.gif"
end type

type cb_exit from w_inherite`cb_exit within w_ktxa40
boolean visible = false
integer x = 3630
integer y = 2740
integer width = 311
end type

type cb_mod from w_inherite`cb_mod within w_ktxa40
event ue_work_maichul_list pbm_custom02
event ue_work_maiip_list pbm_custom03
boolean visible = false
integer x = 2930
integer y = 2740
string text = "처리(&S)"
end type

type cb_ins from w_inherite`cb_ins within w_ktxa40
boolean visible = false
integer x = 635
integer y = 2912
end type

type cb_del from w_inherite`cb_del within w_ktxa40
boolean visible = false
integer x = 1349
integer y = 2912
end type

type cb_inq from w_inherite`cb_inq within w_ktxa40
boolean visible = false
integer x = 3218
integer y = 20
end type

type cb_print from w_inherite`cb_print within w_ktxa40
boolean visible = false
integer x = 3282
integer y = 2740
end type

type st_1 from w_inherite`st_1 within w_ktxa40
boolean visible = false
integer x = 9
integer y = 2180
end type

type cb_can from w_inherite`cb_can within w_ktxa40
boolean visible = false
integer x = 2418
integer y = 2912
end type

type cb_search from w_inherite`cb_search within w_ktxa40
boolean visible = false
integer x = 2775
integer y = 2912
end type

type dw_datetime from w_inherite`dw_datetime within w_ktxa40
boolean visible = false
integer x = 2825
integer y = 2112
end type

type sle_msg from w_inherite`sle_msg within w_ktxa40
boolean visible = false
integer y = 2112
integer width = 2455
end type

type gb_10 from w_inherite`gb_10 within w_ktxa40
boolean visible = false
integer y = 2060
end type

type gb_button1 from w_inherite`gb_button1 within w_ktxa40
boolean visible = false
integer x = 2075
integer y = 2676
end type

type gb_button2 from w_inherite`gb_button2 within w_ktxa40
boolean visible = false
integer x = 2889
integer y = 2692
integer width = 1083
integer height = 180
end type

type tab_vat from tab within w_ktxa40
integer x = 73
integer y = 296
integer width = 4521
integer height = 2000
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean raggedright = true
boolean boldselectedtext = true
alignment alignment = center!
integer selectedtab = 1
tabpage_print1 tabpage_print1
tabpage_print2 tabpage_print2
end type

on tab_vat.create
this.tabpage_print1=create tabpage_print1
this.tabpage_print2=create tabpage_print2
this.Control[]={this.tabpage_print1,&
this.tabpage_print2}
end on

on tab_vat.destroy
destroy(this.tabpage_print1)
destroy(this.tabpage_print2)
end on

type tabpage_print1 from userobject within tab_vat
integer x = 18
integer y = 96
integer width = 4485
integer height = 1888
long backcolor = 32106727
string text = "부가세신고서-1장"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_2 rr_2
dw_print dw_print
end type

on tabpage_print1.create
this.rr_2=create rr_2
this.dw_print=create dw_print
this.Control[]={this.rr_2,&
this.dw_print}
end on

on tabpage_print1.destroy
destroy(this.rr_2)
destroy(this.dw_print)
end on

type rr_2 from roundrectangle within tabpage_print1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 24
integer width = 4434
integer height = 1844
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_print from datawindow within tabpage_print1
integer x = 41
integer y = 36
integer width = 4407
integer height = 1824
integer taborder = 20
boolean bringtotop = true
string dataobject = "dw_ktxa40p"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type tabpage_print2 from userobject within tab_vat
integer x = 18
integer y = 96
integer width = 4485
integer height = 1888
long backcolor = 32106727
string text = "부가세신고서-2장"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_3 rr_3
dw_print2 dw_print2
end type

on tabpage_print2.create
this.rr_3=create rr_3
this.dw_print2=create dw_print2
this.Control[]={this.rr_3,&
this.dw_print2}
end on

on tabpage_print2.destroy
destroy(this.rr_3)
destroy(this.dw_print2)
end on

type rr_3 from roundrectangle within tabpage_print2
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 24
integer width = 4434
integer height = 1844
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_print2 from datawindow within tabpage_print2
integer x = 41
integer y = 32
integer width = 4407
integer height = 1824
integer taborder = 20
boolean bringtotop = true
string dataobject = "dw_ktxa40p1"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type dw_ip from u_key_enter within w_ktxa40
integer x = 73
integer y = 32
integer width = 2446
integer height = 240
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_ktxa401"
boolean border = false
end type

event getfocus;this.AcceptText()
end event

event itemerror;Return 1
end event

event itemchanged;call super::itemchanged;String ls_saupno,ls_sanho, ls_name, ls_uptae, ls_upjong, ls_addr1,ls_addr2,&
		 sVatGisu, sStart,   sEnd,    sProcGbn, sCommJasa, sGbn,	   snull

SetNull(snull)

IF this.GetColumnName() = "vatgisu" THEN
	sVatGiSu = this.GetText()
	IF sVatGisu = "" OR IsNull(sVatGiSu) THEN Return
	
	IF IsNull(F_Get_Refferance('AV',sVatGiSu)) THEN
		F_MessageChk(20,'[부가세기수]')
		this.SetItem(this.GetRow(),"vatgisu",snull)
		Return 1
	ELSE
		SELECT SUBSTR("REFFPF"."RFNA2",1,4),	SUBSTR("REFFPF"."RFNA2",5,4)  /*부가세 기수에 해당하는 거래기간*/
			INTO :sStart,								:sEnd  
   		FROM "REFFPF"  
		   WHERE ( "REFFPF"."RFCOD" = 'AV' ) AND  ( "REFFPF"."RFGUB" = :sVatGisu ) ;
		this.SetItem(this.GetRow(),"sdate",Left(f_Today(),4)+sStart)
		this.SetItem(this.GetRow(),"edate",Left(f_Today(),4)+sEnd)	
	END IF
END IF

IF this.GetColumnName() ="sdate" THEN
	IF f_datechk(Trim(this.GetText())) = -1 THEN 
		f_messagechk(20,"거래기간")
		this.SetItem(1,"sdate",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="edate" THEN
	IF f_datechk(Trim(this.GetText())) = -1 THEN 
		f_messagechk(20,"거래기간")
		this.SetItem(1,"edate",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "procgbn" THEN
	sProcGbn = this.getText()
	IF sProcGbn = '2' THEN								/*개별납부*/
		this.SetItem(this.GetRow(),"jasa_cd",snull)
	ELSE
		SELECT "SYSCNFG"."DATANAME"  
	   	INTO :sCommJasa  
   	 	FROM "SYSCNFG"  
   		WHERE ( "SYSCNFG"."SYSGU" = 'C' ) AND ( "SYSCNFG"."SERIAL" = 4 ) AND  
         		( "SYSCNFG"."LINENO" = '1' )   ;
		IF SQLCA.SQLCODE <> 0 THEN
			F_MessageChk(56,'[자사코드(C-4-1)]')
			this.SetItem(this.GetRow(),"jasa_cd",snull)
			Return 1
		ELSE
			IF IsNull(sCommJasa) OR sCommJasa = "" THEN
				F_MessageChk(56,'[자사코드(C-4-1)]')
				this.SetItem(this.GetRow(),"jasa_cd",snull)
				Return 1
			END IF
		END IF		
		
		this.SetItem(this.GetRow(),"jasa_cd",sCommJasa)
	END IF
END IF
end event

