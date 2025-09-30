$PBExportHeader$w_cic00220.srw
$PBExportComments$자재투입명세와 제조원가명세서 비교
forward
global type w_cic00220 from w_standard_print
end type
type rr_1 from roundrectangle within w_cic00220
end type
end forward

global type w_cic00220 from w_standard_print
string title = "자재투입명세와 제조원가명세서 비교"
rr_1 rr_1
end type
global w_cic00220 w_cic00220

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sFromym


dw_ip.AcceptText()
sFromym  = Trim(dw_ip.GetITemString(1,"sfromym"))

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

IF dw_print.Retrieve(sFromym)  <= 0 THEN
   f_messagechk(14,"") 
	Return -1 	
END IF	
dw_print.ShareData(dw_list)

dw_list.SetFilter("")
dw_list.Filter()

Return 1
end function

on w_cic00220.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_cic00220.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetITem(1,"sfromym",Left(f_today(),6))
dw_ip.SetItem(1,"stoym",left(f_today(),6))
end event

type p_preview from w_standard_print`p_preview within w_cic00220
boolean visible = false
integer x = 3845
integer y = 0
integer taborder = 0
end type

type p_exit from w_standard_print`p_exit within w_cic00220
integer y = 0
integer taborder = 40
end type

type p_print from w_standard_print`p_print within w_cic00220
boolean visible = false
integer x = 4018
integer y = 0
integer taborder = 0
end type

type p_retrieve from w_standard_print`p_retrieve within w_cic00220
integer x = 4270
integer y = 0
end type







type st_10 from w_standard_print`st_10 within w_cic00220
end type



type dw_print from w_standard_print`dw_print within w_cic00220
integer x = 3598
integer y = 16
string dataobject = "dw_cic002202"
end type

type dw_ip from w_standard_print`dw_ip within w_cic00220
integer x = 18
integer y = 0
integer width = 2830
integer height = 172
string dataobject = "dw_cic002201"
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
	
	if sGbun = '2' then		/*재료비*/
		dw_list.SetFilter("om10 <> m22")
	elseif sGbun = '3' then		/*노무비*/
		dw_list.SetFilter("ol10 <> l22")
	elseif sGbun = '4' then		/*경비*/
		dw_list.SetFilter("oo10 <> o22")
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

type dw_list from w_standard_print`dw_list within w_cic00220
integer x = 50
integer y = 184
integer width = 4562
integer height = 2028
string dataobject = "dw_cic002202"
boolean border = false
end type

type rr_1 from roundrectangle within w_cic00220
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 176
integer width = 4590
integer height = 2056
integer cornerheight = 40
integer cornerwidth = 55
end type

