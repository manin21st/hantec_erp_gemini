$PBExportHeader$w_cia00250.srw
$PBExportComments$�������Ը��� ���������Ȳ ��
forward
global type w_cia00250 from w_standard_print
end type
type rr_1 from roundrectangle within w_cia00250
end type
end forward

global type w_cia00250 from w_standard_print
string title = "�������Ը��� �����Ȳ ��"
rr_1 rr_1
end type
global w_cia00250 w_cia00250

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sFromym


dw_ip.AcceptText()
sFromym  = Trim(dw_ip.GetITemString(1,"sfromym"))

IF sFromym = '' or isnull(sFromym) THEN
   f_messagechk(1,'[���������]')
	dw_ip.SetColumn("sfromym")
	dw_ip.SetFocus()
	Return -1	
ELSE
	IF F_DATECHK(sFromym + '01') = -1 THEN
		f_messagechk(21,'[���������]')
	   dw_ip.SetColumn("sfromym")
	   dw_ip.SetFocus()
	   Return -1	 
  END IF	
END IF

IF dw_print.Retrieve(sFromym)  <= 0 THEN
   f_messagechk(14,"") 
	Return -1 	
END IF	
dw_print.ShareData(dw_list)

dw_list.SetFilter("")
dw_list.Filter()

Return 1
end function

on w_cia00250.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_cia00250.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetITem(1,"sfromym",Left(f_today(),6))
dw_ip.SetItem(1,"stoym",left(f_today(),6))
dw_ip.SetColumn("sfromym")
dw_ip.setFocus()
end event

type p_preview from w_standard_print`p_preview within w_cia00250
boolean visible = false
integer x = 3845
integer y = 0
end type

type p_exit from w_standard_print`p_exit within w_cia00250
integer y = 0
end type

type p_print from w_standard_print`p_print within w_cia00250
boolean visible = false
integer x = 4018
integer y = 0
end type

type p_retrieve from w_standard_print`p_retrieve within w_cia00250
integer x = 4270
integer y = 0
end type







type st_10 from w_standard_print`st_10 within w_cia00250
end type



type dw_print from w_standard_print`dw_print within w_cia00250
integer x = 3598
integer y = 16
string dataobject = "dw_cia002502"
end type

type dw_ip from w_standard_print`dw_ip within w_cia00250
integer x = 27
integer y = 12
integer width = 3493
integer height = 144
string dataobject = "dw_cia002501"
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

event dw_ip::itemchanged;String sGbun,snull

SetNUll(snull)

IF this.GetColumnName() = "sgubn" THEN
	sGbun    = this.GetText()
	
	if sGbun = '1' then
		dw_list.SetFilter("ioqty10 <> ioqty_imhist")
	elseif sGbun = '2' then		/*����*/
		dw_list.SetFilter("amt10 <> amt_imhist")
	else
		dw_list.SetFilter("")
	end if
	dw_list.Filter()

END IF


end event

event dw_ip::ue_key;call super::ue_key;IF keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

type dw_list from w_standard_print`dw_list within w_cia00250
integer x = 69
integer y = 176
integer width = 4549
integer height = 2028
string dataobject = "dw_cia002502"
boolean border = false
end type

type rr_1 from roundrectangle within w_cia00250
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 168
integer width = 4576
integer height = 2056
integer cornerheight = 40
integer cornerwidth = 55
end type

