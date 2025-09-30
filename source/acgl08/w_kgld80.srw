$PBExportHeader$w_kgld80.srw
$PBExportComments$선급비용 명세서 조회출력
forward
global type w_kgld80 from w_standard_print
end type
type dw_proclst from datawindow within w_kgld80
end type
type rr_1 from roundrectangle within w_kgld80
end type
end forward

global type w_kgld80 from w_standard_print
string title = "선급비용 명세서 조회출력"
dw_proclst dw_proclst
rr_1 rr_1
end type
global w_kgld80 w_kgld80

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sSaupj,sBaseYm,sAcc1,sAcc2,sAccDay,saupj_nm

sle_msg.text = ''

If dw_ip.AcceptText() = -1 Then Return -1

sSaupj  = Trim(dw_ip.GetItemString(dw_ip.GetRow(),'saupj'))
sBaseYm = Trim(dw_ip.GetItemString(dw_ip.GetRow(),'acc_yymm'))
sAcc1   = dw_ip.GetItemString(dw_ip.GetRow(),'acc1_cd')
sAcc2   = dw_ip.GetItemString(dw_ip.GetRow(),'acc2_cd')

IF sSaupj = "" OR IsNull(sSaupj) THEN
	F_MessageChk(1,'[사업장]')
	dw_ip.SetColumn("saupj")
	dw_ip.SetFocus()
	Return -1
END IF

IF sBaseYm = "" OR IsNull(sBaseYm) THEN
	F_MessageChk(1,'[기준년월]')
	dw_ip.Setcolumn('acc_yymm')
	dw_ip.SetFocus()
	Return -1
END IF

SELECT "REFFPF"."RFNA1"  
		 INTO :saupj_nm  
		 FROM "REFFPF"  
		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND  
				( "REFFPF"."RFGUB" = :ssaupj )   ;
				
IF sAcc1 = "" OR IsNull(sAcc1) THEN sAcc1 = '%'
IF sAcc2 = "" OR IsNull(sAcc2) THEN sAcc2 = '%'

dw_list.Reset()
dw_list.SetRedraw(False)

dw_print.object.saupj.text = saupj_nm

IF dw_print.Retrieve(sabu_f,sabu_t,sBaseYm,sAcc1,sAcc2) <= 0 THEN
	MessageBox("확 인","처리할 자료가 없습니다.!!")
	dw_list.insertrow(0)
	dw_ip.Setcolumn('acc_yymm')
	dw_ip.Setfocus()
	//Return -1
END IF
dw_print.sharedata(dw_list)
sle_msg.text = "자료조회를 완료하였습니다.!!!"

dw_list.SetRedraw(True)

Return 1
end function

on w_kgld80.create
int iCurrent
call super::create
this.dw_proclst=create dw_proclst
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_proclst
this.Control[iCurrent+2]=this.rr_1
end on

on w_kgld80.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_proclst)
destroy(this.rr_1)
end on

event w_kgld80::open;call super::open;dw_proclst.SetTransObject(SQLCA)

dw_ip.SetTransObject(SQLCA)

dw_ip.SetItem(dw_ip.Getrow(),"saupj",   Gs_Saupj)
dw_ip.SetItem(dw_ip.Getrow(),"acc_yymm",Left(f_today(),6))

dw_ip.SetColumn("saupj")
dw_ip.SetFocus()

dw_proclst.Settransobject(sqlca)
end event

type p_preview from w_standard_print`p_preview within w_kgld80
integer taborder = 0
end type

type p_exit from w_standard_print`p_exit within w_kgld80
integer taborder = 0
end type

type p_print from w_standard_print`p_print within w_kgld80
integer taborder = 0
end type

type p_retrieve from w_standard_print`p_retrieve within w_kgld80
integer taborder = 0
end type

type st_window from w_standard_print`st_window within w_kgld80
boolean visible = false
end type

type sle_msg from w_standard_print`sle_msg within w_kgld80
boolean visible = false
long textcolor = 8388608
long backcolor = 80269524
end type

type dw_datetime from w_standard_print`dw_datetime within w_kgld80
boolean visible = false
end type

type st_10 from w_standard_print`st_10 within w_kgld80
boolean visible = false
end type

type gb_10 from w_standard_print`gb_10 within w_kgld80
boolean visible = false
end type

type dw_print from w_standard_print`dw_print within w_kgld80
integer width = 133
string dataobject = "dw_kgld802_p"
end type

event dw_print::retrieveend;call super::retrieveend;//Integer i
//
//sle_msg.text = "자료 조회 중 ..."
//
//FOR i = 1 TO rowcount
//	IF dw_proclst.Retrieve(this.GetItemString(i,"kfz31ot0_saupj"),&
//								  this.GetItemString(i,"kfz31ot0_acc_date"),&
//								  this.GetItemString(i,"kfz31ot0_upmu_gu"),&
//								  this.GetItemNumber(i,"kfz31ot0_jun_no"), &
//								  this.GetItemNumber(i,"kfz31ot0_lin_no"),&
//								  this.GetItemString(i,"kfz31ot0_bal_date"),&
//								  this.GetItemNumber(i,"kfz31ot0_bjun_no"), &
//								  dw_ip.GetItemString(1,"acc_yymm")) > 0 THEN
//		this.SetItem(i,"gi_amt",dw_proclst.GetItemNumber(1,"sum_div"))	
//	ELSE
//		this.SetItem(i,"gi_amt",0)	
//	END IF
//NEXT
end event

type dw_ip from w_standard_print`dw_ip within w_kgld80
integer x = 59
integer y = 12
integer width = 3538
integer height = 164
integer taborder = 0
string dataobject = "dw_kgld801"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;string snull

setnull(snull)

this.accepttext()

IF this.GetColumnName() = 'acc1_cd' THEN
	
	SetNull(lstr_account.acc1_cd)
	SetNull(lstr_account.acc2_cd)
	
	lstr_account.acc1_cd = this.GetItemString(this.GetRow(),"acc1_cd")
	
	IF IsNull(lstr_account.acc1_cd) THEN lstr_account.acc1_cd = ''
	IF IsNull(lstr_account.acc2_cd) THEN lstr_account.acc2_cd = ''
	
	Open(W_Kfz01om0_PopUp_Sungub)
	
	IF IsNull(lstr_account.acc1_cd) THEN 
		this.SetItem(this.GetRow(),"acc1_cd",snull)
		this.SetItem(this.GetRow(),"acc2_cd",snull)
		this.SetItem(this.GetRow(),"acc2_nm",snull)
		Return
	END IF
	
	this.SetItem(this.GetRow(),"acc1_cd",lstr_account.acc1_cd)
	this.SetItem(this.GetRow(),"acc2_cd",lstr_account.acc2_cd)
	this.SetItem(this.GetRow(),"acc2_nm",lstr_account.acc2_nm)
END IF
end event

event dw_ip::getfocus;this.Accepttext()
end event

event dw_ip::itemchanged;String  sAcc1_cd,sAcc2_cd,sAccName,sYearMonth,snull

SetNull(snull)

IF this.GetColumnName() = 'acc_yymm' THEN
	sYearMonth = Trim(this.GetText())
	IF sYearMonth = "" OR IsNull(sYearMonth) THEN RETURN
	
	IF F_DateChk(sYearMonth+'01') = -1 THEN
		F_MessageChk(21,'[기준년월]')
		this.SetItem(1,'acc_yymm',snull)
		Return 1
	ELSE
		this.SetItem(1,'acc_yymm', sYearMonth)
	END IF
END IF

IF this.GetColumnName() = 'acc1_cd' THEN
	sAcc1_Cd = this.GetText()
	
	IF sAcc1_Cd = "" OR IsNull(sAcc1_Cd) THEN
		this.SetItem(1,'acc2_cd',snull)
		this.SetItem(1,'acc2_nm',snull)
		Return 
	END IF
	
	sAcc2_Cd = this.GetItemString(1,'acc2_cd')
	IF sAcc2_Cd = "" OR IsNull(sAcc2_Cd) THEN RETURN
	
	SELECT "KFZ01OM0"."ACC2_NM"  INTO :sAccName  
   	FROM "KFZ01OM0"  
     WHERE ( "KFZ01OM0"."ACC1_CD" = :sAcc1_Cd ) AND ( "KFZ01OM0"."ACC2_CD" = :sAcc2_Cd );
	IF SQLCA.SQLCODE <> 0 THEN
//		F_MessageChk(20,'[계정과목]')
//		this.SetItem(1,'acc1_cd',snull)
//		this.SetItem(1,'acc2_cd',snull)
//		this.SetItem(1,'acc2_nm',snull)
//		Return 1
	ELSE
		this.SetItem(1,'acc2_nm', sAccName)
	END IF
END IF

IF this.GetColumnName() = 'acc2_cd' THEN
	sAcc2_Cd = this.GetText()
	
	IF sAcc2_Cd = "" OR IsNull(sAcc2_Cd) THEN
		this.SetItem(1,'acc1_cd',snull)
		this.SetItem(1,'acc2_nm',snull)
		Return 
	END IF
	
	sAcc1_Cd = this.GetItemString(1,'acc1_cd')
	IF sAcc1_Cd = "" OR IsNull(sAcc1_Cd) THEN RETURN
	
	SELECT "KFZ01OM0"."ACC2_NM"  INTO :sAccName  
     FROM "KFZ01OM0"  
    WHERE ( "KFZ01OM0"."ACC1_CD" = :sAcc1_Cd ) AND ( "KFZ01OM0"."ACC2_CD" = :sAcc2_Cd );
	IF SQLCA.SQLCODE <> 0 THEN
//		F_MessageChk(20,'[계정과목]')
//		this.SetItem(1,'acc1_cd',snull)
//		this.SetItem(1,'acc2_cd',snull)
//		this.SetItem(1,'acc2_nm',snull)
//		this.SetColumn('acc1_cd')
//		this.SetFocus()
//		Return 1
	ELSE
		this.SetItem(1,'acc2_nm',sAccName)
	END IF
END IF

end event

event dw_ip::ue_key;call super::ue_key;//IF key = keytab! or key = keyf1! THEN
//	TriggerEvent(RbuttonDown!)
//END IF
end event

type dw_list from w_standard_print`dw_list within w_kgld80
integer x = 69
integer y = 204
integer width = 4521
integer height = 2040
integer taborder = 0
string dataobject = "dw_kgld802"
boolean border = false
end type

type dw_proclst from datawindow within w_kgld80
boolean visible = false
integer x = 818
integer y = 2360
integer width = 1253
integer height = 96
boolean bringtotop = true
boolean titlebar = true
string title = "선급비용월할 기처리액"
string dataobject = "dw_kgld803"
boolean minbox = true
boolean maxbox = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rr_1 from roundrectangle within w_kgld80
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 196
integer width = 4553
integer height = 2060
integer cornerheight = 40
integer cornerwidth = 55
end type

