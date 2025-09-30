$PBExportHeader$w_kfic03.srw
$PBExportComments$부도어음 이자 청구서 조회출력
forward
global type w_kfic03 from w_standard_print
end type
type rr_1 from roundrectangle within w_kfic03
end type
end forward

global type w_kfic03 from w_standard_print
string title = "부도어음 이자 청구서조회출력"
rr_1 rr_1
end type
global w_kfic03 w_kfic03

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_bill_no, ls_rmandate, ls_rgubun, ls_rymd, ls_aymd, ls_bman_dat, ls_cymd
decimal ld_r_amt, ld_bill_amt, ld_eja, ld_samt, ld_seja
long ll_hymd, ll_bymd, ll_mymd, ll_ilsu, ll_row
integer i

if dw_ip.accepttext() = -1 then return -1

ls_bill_no = dw_ip.getitemstring(1, "bill_no")

if ls_bill_no = "" or isnull(ls_bill_no) then
	messagebox("확인", "어음번호를 확인하십시오.!!")
	dw_ip.setfocus()
	return -1
end if

dw_print.setTransObject(sqlca)
ll_row = dw_print.retrieve(ls_bill_no)

if ll_row <= 0 then
	f_messagechk(14, "")
	dw_ip.setfocus()
	return -1 
end if 

i = dw_print.getrow()

for i = 1 to ll_row
	
	ls_aymd = dw_print.getitemstring(i, "kfm02t_aymd")
	ls_cymd = dw_print.getitemstring(i, "kfm02t_cymd")
	ls_bman_dat = dw_print.getitemstring(i, "kfm02ot0_bman_dat")
	ls_rmandate = dw_print.getitemstring(i, "kfm02t1_r_mandate")
	ls_rgubun = dw_print.getitemstring(i, "kfm02t1_r_gubun")
	ls_rymd = dw_print.getitemstring(i, "kfm02t1_rymd")
	ll_ilsu = dw_print.getitemnumber(i, "ilsu")
	
	ll_hymd = f_dayterm(ls_cymd,ls_rymd)
   ll_bymd = f_dayterm(ls_bman_dat,ls_rmandate)
   ll_mymd = f_dayterm(ls_bman_dat,ls_rymd)
	
	if ls_aymd > ls_bman_dat then
		if ls_rgubun = '1' then	
			ll_ilsu = ll_hymd		
		else					
			ll_ilsu = ll_bymd
		end if
	else
		ll_ilsu = ll_bymd
		if ls_cymd < ls_rymd and ls_rymd < ls_bman_dat then
			if ls_rgubun = '1' then	   
				ll_ilsu = ll_mymd
			end if
		end if	
	end if
	dw_print.setitem(i, "ilsu", ll_ilsu)
next

dw_print.sharedata(dw_list)

return 1
end function

on w_kfic03.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kfic03.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

type p_preview from w_standard_print`p_preview within w_kfic03
integer taborder = 40
end type

type p_exit from w_standard_print`p_exit within w_kfic03
integer taborder = 60
end type

type p_print from w_standard_print`p_print within w_kfic03
integer taborder = 50
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfic03
integer taborder = 20
end type







type st_10 from w_standard_print`st_10 within w_kfic03
end type



type dw_print from w_standard_print`dw_print within w_kfic03
string dataobject = "d_kfic03_2"
end type

type dw_ip from w_standard_print`dw_ip within w_kfic03
integer x = 0
integer y = 20
integer width = 928
integer height = 244
integer taborder = 10
string dataobject = "d_kfic03_1"
boolean livescroll = false
end type

event dw_ip::rbuttondown;this.accepttext()

IF this.GetColumnName() ="bill_no" THEN
	SetNull(gs_code)
	SetNull(gs_codename)

	gs_code =Trim(this.GetItemString(this.GetRow(),"bill_no"))
	gs_codename = this.getitemstring(this.getrow(),"aymd")
	IF IsNull(gs_code) THEN
		gs_code =""
	END IF
	OPEN(W_KFM02OT0_POPUP)
	IF Not IsNull(gs_code) THEN
		this.SetItem(this.GetRow(),"bill_no",gs_code)
		this.setitem(this.getrow(),"aymd",gs_codename)
	END IF
	Return
END IF


end event

event dw_ip::itemchanged;call super::itemchanged;string ls_bill_no, ls_aymd, snull

setnull(snull)

if this.getcolumnname() = "bill_no" then
	ls_bill_no = this.gettext()
	if ls_bill_no = "" or isnull(ls_bill_no) then 
		this.setitem(1, "aymd", snull)
		return
	else
	
	  SELECT "KFM02T"."AYMD"  
       INTO :ls_aymd  
       FROM "KFM02T"  
      WHERE "KFM02T"."BILL_NO" = :ls_bill_no ;
		
		this.setitem(1, "bill_no", ls_bill_no)
		this.setitem(1, "aymd", ls_aymd)
	end if
end if

end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

event dw_ip::ue_key;call super::ue_key;IF keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

type dw_list from w_standard_print`dw_list within w_kfic03
integer width = 4549
integer height = 2012
integer taborder = 30
string dataobject = "d_kfic03_2"
boolean border = false
end type

type rr_1 from roundrectangle within w_kfic03
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 280
integer width = 4608
integer height = 2064
integer cornerheight = 40
integer cornerwidth = 55
end type

