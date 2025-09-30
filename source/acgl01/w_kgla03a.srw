$PBExportHeader$w_kgla03a.srw
$PBExportComments$기초자료관리: 부가세 조회
forward
global type w_kgla03a from window
end type
type p_exit from uo_picture within w_kgla03a
end type
type p_inq from uo_picture within w_kgla03a
end type
type dw_cond from u_key_enter within w_kgla03a
end type
type dw_2 from datawindow within w_kgla03a
end type
type rr_1 from roundrectangle within w_kgla03a
end type
end forward

global type w_kgla03a from window
integer x = 73
integer y = 48
integer width = 4402
integer height = 2400
boolean titlebar = true
string title = "부가세 조회"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
windowtype windowtype = response!
long backcolor = 32106727
p_exit p_exit
p_inq p_inq
dw_cond dw_cond
dw_2 dw_2
rr_1 rr_1
end type
global w_kgla03a w_kgla03a

type variables
s_JunPoy str_kfz17ot0
end variables

event open;
f_window_center(this)

dw_2.SetTransObject(SQLCA)

dw_cond.SetTransObject(SQLCA)
dw_cond.Reset()
dw_cond.InsertRow(0)

dw_cond.SetItem(dw_cond.GetRow(),"bal_date",Left(F_today(),6) + '01')
dw_cond.SetItem(dw_cond.GetRow(),"gey_date",F_today())

dw_cond.SetColumn("saupj")
dw_cond.SetFocus()
end event

on w_kgla03a.create
this.p_exit=create p_exit
this.p_inq=create p_inq
this.dw_cond=create dw_cond
this.dw_2=create dw_2
this.rr_1=create rr_1
this.Control[]={this.p_exit,&
this.p_inq,&
this.dw_cond,&
this.dw_2,&
this.rr_1}
end on

on w_kgla03a.destroy
destroy(this.p_exit)
destroy(this.p_inq)
destroy(this.dw_cond)
destroy(this.dw_2)
destroy(this.rr_1)
end on

type p_exit from uo_picture within w_kgla03a
integer x = 4183
integer y = 4
integer width = 178
integer taborder = 30
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;String sparm
Int ll_clickedrow

ll_clickedrow =dw_2.GetSelectedrow(0)

IF ll_clickedrow <=0 THEN 
	SetNull(Str_Kfz17ot0.saupjang)
	SetNull(Str_Kfz17ot0.baldate)
	SetNull(Str_Kfz17ot0.upmugu)
	SetNull(Str_Kfz17ot0.bjunno)
	SetNull(Str_Kfz17ot0.linno)
	SetNull(Str_Kfz17ot0.seqno)
ELSE
	Str_Kfz17ot0.saupjang = dw_2.GetItemString(ll_clickedrow,"saupj")
	Str_Kfz17ot0.baldate  = dw_2.GetItemString(ll_clickedrow,"bal_date")
	Str_Kfz17ot0.upmugu   = dw_2.GetItemString(ll_clickedrow,"upmu_gu")
	Str_Kfz17ot0.bjunno   = dw_2.GetItemNumber(ll_clickedrow,"bjun_no")
	Str_Kfz17ot0.linno    = dw_2.GetItemNumber(ll_clickedrow,"lin_no")
	Str_Kfz17ot0.seqno    = dw_2.GetItemNumber(ll_clickedrow,"seq_no")
END IF
		
CloseWithReturn(parent,Str_kfz17ot0)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type p_inq from uo_picture within w_kgla03a
integer x = 4009
integer y = 4
integer width = 178
integer taborder = 20
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event clicked;call super::clicked;
String sJasaCd,sDate,eDate,sTax,sVatGisu

dw_cond.AcceptText()
sJasaCd = dw_cond.GetItemString(1,"jasa_cd")
sDate = dw_cond.GetItemString(1,"bal_date")
eDate = dw_cond.GetItemString(1,"gey_date")
sTax  = dw_cond.GetItemString(1,"tax_no")
sVatGisu = dw_cond.GetItemString(1,"vatgisu")

IF sDate = "" OR IsNull(sDate) THEN
	F_MessageChk(1,'[회계일자]')
	dw_cond.SetColumn("bal_date")
	dw_cond.SetFocus()
	Return
END IF

IF eDate = "" OR IsNull(eDate) THEN
	F_MessageChk(1,'[회계일자]')
	dw_cond.SetColumn("gey_date")
	dw_cond.SetFocus()
	Return
END IF

IF sJasaCd = "" OR IsNull(sJasaCd) THEN sJasaCd = "%"
IF sTax ="" OR IsNull(sTax) THEN sTax ="%"
IF sVatGisu = "" OR IsNull(sVatGisu) THEN sVatGisu = '%'

IF dw_2.Retrieve(sJasaCd,sDate,eDate,sTax,sVatGisu) <=0 THEN
	F_MessageChk(14,'')
	Return
END IF

dw_2.SelectRow(0,False)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조회_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조회_up.gif"
end event

type dw_cond from u_key_enter within w_kgla03a
integer x = 46
integer y = 16
integer width = 3941
integer height = 140
integer taborder = 10
string dataobject = "dw_kgla03a2"
boolean border = false
end type

event itemchanged;String sVatGisu,sStart,sEnd,sNull

SetNull(snull)

IF this.GetColumnName() = "vatgisu" THEN
	sVatGiSu = this.GetText()
	IF sVatGisu = "" OR IsNull(sVatGiSu) THEN 
		this.SetItem(this.GetRow(),"bal_date",sNull)
		this.SetItem(this.GetRow(),"gey_date",sNull)	
		Return
	END IF
	
	IF IsNull(F_Get_Refferance('AV',sVatGiSu)) THEN
		F_MessageChk(20,'[부가세기수]')
		this.SetItem(this.GetRow(),"vatgisu",snull)
		Return 1
	ELSE
		SELECT SUBSTR("REFFPF"."RFNA2",1,8),	SUBSTR("REFFPF"."RFNA2",9,8)  /*부가세 기수에 해당하는 거래기간*/
			INTO :sStart,								:sEnd  
   		FROM "REFFPF"  
		   WHERE ( "REFFPF"."SABU" = :gs_saupj ) AND ( "REFFPF"."RFCOD" = 'AV' ) AND  
      		   ( "REFFPF"."RFGUB" = :sVatGisu ) ;
		this.SetItem(this.GetRow(),"bal_date",sStart)
		this.SetItem(this.GetRow(),"gey_date",sEnd)	
	END IF
END IF
end event

event getfocus;this.AcceptText()
end event

event itemerror;Return 1
end event

type dw_2 from datawindow within w_kgla03a
integer x = 55
integer y = 164
integer width = 4279
integer height = 2112
string dataobject = "dw_kgla03a1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;IF row <= 0 THEN RETURN

this.SelectRow(0,False)
this.SelectRow(row,True)


end event

event doubleclicked;
IF row <=0 THEN Return

this.SelectRow(0,False)
this.SelectRow(row,True)

Str_Kfz17ot0.saupjang = this.GetItemString(row,"saupj")
Str_Kfz17ot0.baldate  = this.GetItemString(row,"bal_date")
Str_Kfz17ot0.upmugu   = this.GetItemString(row,"upmu_gu")
Str_Kfz17ot0.bjunno   = this.GetItemNumber(row,"bjun_no")
Str_Kfz17ot0.linno    = this.GetItemNumber(row,"lin_no")
Str_Kfz17ot0.seqno    = this.GetItemNumber(row,"seq_no")

CloseWithReturn(parent,Str_kfz17ot0)

end event

type rr_1 from roundrectangle within w_kgla03a
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 156
integer width = 4311
integer height = 2128
integer cornerheight = 40
integer cornerwidth = 55
end type

