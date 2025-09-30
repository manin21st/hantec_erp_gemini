$PBExportHeader$w_cia00260.srw
$PBExportComments$노무비와 급상여대장 비교
forward
global type w_cia00260 from w_standard_print
end type
type st_1 from statictext within w_cia00260
end type
type dw_detail from datawindow within w_cia00260
end type
type st_2 from statictext within w_cia00260
end type
type rr_1 from roundrectangle within w_cia00260
end type
type rr_2 from roundrectangle within w_cia00260
end type
end forward

global type w_cia00260 from w_standard_print
string title = "노무비 집계내역 확인"
st_1 st_1
dw_detail dw_detail
st_2 st_2
rr_1 rr_1
rr_2 rr_2
end type
global w_cia00260 w_cia00260

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sFromym,sAcCd,sGbn


dw_ip.AcceptText()
sFromym  = Trim(dw_ip.GetITemString(1,"sfromym"))
sGbn     = Trim(dw_ip.GetITemString(1,"sgubn"))

IF sFromym = '' or isnull(sFromym) THEN
   f_messagechk(1,'[원가계산년월]')
	dw_ip.SetColumn("sfromym")
	dw_ip.SetFocus()
	Return -1	
ELSE
	IF F_DATECHK(sFromym + '01') = -1 THEN
		f_messagechk(21,'[원가계산년월]')
	   dw_ip.SetColumn("sfromym")
	   dw_ip.SetFocus()
	   Return -1	 
  END IF	
END IF

IF sGbn = '1' THEN 				/*급여*/
	select substr(dataname,1,7) into :sAcCd from syscnfg 
		where sysgu = 'A' and serial = 85 and lineno = '1';			
ELSE
	select substr(dataname,1,7) into :sAcCd from syscnfg 
		where sysgu = 'A' and serial = 85 and lineno = '2';
END IF

IF dw_print.Retrieve(sFromym,sAcCd)  <= 0 THEN
   f_messagechk(14,"") 
	Return -1 	
END IF	
dw_print.ShareData(dw_list)

Return 1
end function

on w_cia00260.create
int iCurrent
call super::create
this.st_1=create st_1
this.dw_detail=create dw_detail
this.st_2=create st_2
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.dw_detail
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.rr_1
this.Control[iCurrent+5]=this.rr_2
end on

on w_cia00260.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.dw_detail)
destroy(this.st_2)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_ip.SetITem(1,"sfromym",Left(f_today(),6))
dw_ip.SetItem(1,"stoym",left(f_today(),6))
dw_ip.SetColumn("sfromym")
dw_ip.setFocus()

dw_detail.SetTransObject(Sqlca)
end event

type p_preview from w_standard_print`p_preview within w_cia00260
boolean visible = false
integer x = 3845
integer y = 0
end type

type p_exit from w_standard_print`p_exit within w_cia00260
integer y = 0
end type

type p_print from w_standard_print`p_print within w_cia00260
boolean visible = false
integer x = 4018
integer y = 0
end type

type p_retrieve from w_standard_print`p_retrieve within w_cia00260
integer x = 4270
integer y = 0
end type







type st_10 from w_standard_print`st_10 within w_cia00260
end type



type dw_print from w_standard_print`dw_print within w_cia00260
integer x = 3598
integer y = 16
string dataobject = "dw_cia002602"
end type

type dw_ip from w_standard_print`dw_ip within w_cia00260
integer x = 37
integer y = 12
integer width = 3150
integer height = 144
string dataobject = "dw_cia002601"
end type

event dw_ip::rbuttondown;SetNull(lstr_account.acc1_cd)
SetNull(lstr_account.acc2_cd)

this.AcceptText()

IF this.GetColumnName() = "acc1" OR this.GetColumnName() = "acc2" THEN
	lstr_account.acc1_cd = this.object.acc1[1]
	
	Open(W_KFZ01OM0_POPUP)

	IF IsNull(lstr_account.acc1_cd) OR lstr_account.acc1_cd = "" THEN Return
	
	THIS.SetItem(THIS.GetRow(), "acc1", lstr_account.acc1_cd)
	THIS.SetItem(THIS.GetRow(), "acc2", lstr_account.acc2_cd)
	THIS.SetItem(THIS.GetRow(), "acc_name1", lstr_account.acc2_nm)
	
END IF
end event

event dw_ip::itemerror;Return 1
end event

event dw_ip::itemchanged;String snull

SetNUll(snull)

IF this.GetColumnName() = "sgubn" THEN
	CHOOSE CASE data
		CASE '1'
			dw_detail.DataObject ="dw_cia0026021"
			dw_detail.SetTransObject(SQLCA)
		CASE '2'
			dw_detail.DataObject ="dw_cia0026031"
			dw_detail.SetTransObject(SQLCA)
	END CHOOSE
	dw_list.Reset()
	
	w_mdi_frame.sle_msg.text =""
END IF


end event

event dw_ip::ue_key;call super::ue_key;IF keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

type dw_list from w_standard_print`dw_list within w_cia00260
integer x = 73
integer y = 236
integer width = 1509
integer height = 1968
string dataobject = "dw_cia002602"
boolean hscrollbar = false
boolean border = false
end type

event dw_list::clicked;call super::clicked;

dw_detail.Retrieve(dw_ip.GetItemString(1,"sfromym"),this.GetItemString(row,"cost_cd"))
end event

event dw_list::rowfocuschanged;call super::rowfocuschanged;dw_detail.Retrieve(dw_ip.GetItemString(1,"sfromym"),this.GetItemString(currentrow,"cost_cd"))
end event

type st_1 from statictext within w_cia00260
integer x = 96
integer y = 176
integer width = 517
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "노무비 집계 내역"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_detail from datawindow within w_cia00260
integer x = 1632
integer y = 236
integer width = 2962
integer height = 1968
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "dw_cia0026021"
boolean border = false
boolean livescroll = true
end type

type st_2 from statictext within w_cia00260
integer x = 1664
integer y = 176
integer width = 553
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "급여/상여 지급내역"
alignment alignment = center!
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_cia00260
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 55
integer y = 200
integer width = 1536
integer height = 2012
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_cia00260
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1614
integer y = 204
integer width = 2994
integer height = 2008
integer cornerheight = 40
integer cornerwidth = 55
end type

