$PBExportHeader$w_kgld14.srw
$PBExportComments$현금출납장 조회/출력
forward
global type w_kgld14 from w_standard_print
end type
type rr_1 from roundrectangle within w_kgld14
end type
end forward

global type w_kgld14 from w_standard_print
integer x = 0
integer y = 0
string title = "현금출납장 조회 출력"
rr_1 rr_1
end type
global w_kgld14 w_kgld14

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string sacc_ymd, eacc_ymd, symd_text,eymd_text,ref_saup,sSaupj,sCashCode	
		
dw_ip.AcceptText()

sacc_ymd = Trim(dw_ip.GetItemString(1,"k_symd")) 
IF sAcc_Ymd = "" OR IsNull(sAcc_Ymd) THEN
	F_MessageChk(1,'[회계일자]')
	dw_ip.SetColumn("k_symd")
	dw_ip.SetFocus()
	Return -1
ELSE
	IF f_datechk(sacc_ymd) = -1 THEN
		f_messagechk( 23, "")
		dw_ip.SetColumn("k_symd")
		dw_ip.SetFocus()
		Return -1
	END IF
END IF
symd_text = left(sacc_ymd, 4) + '.'+ mid(sacc_ymd,5,2) + '.' + right(sacc_ymd,2)

eacc_ymd = Trim(dw_ip.GetItemString(1,"k_eymd"))                
IF eAcc_Ymd = "" OR IsNull(eAcc_Ymd) THEN
	F_MessageChk(1,'[회계일자]')
	dw_ip.SetColumn("k_eymd")
	dw_ip.SetFocus()
	Return -1
ELSE
	IF f_datechk(eacc_ymd) = -1 THEN
		f_messagechk(23, "") 
		dw_ip.SetColumn("k_eymd")
		dw_ip.SetFocus()
		Return -1
	END IF
END IF
eymd_text = left(eacc_ymd, 4) + '.'+ mid(eacc_ymd,5,2) + '.' + right(eacc_ymd,2)

if long(sacc_ymd) > long(eacc_ymd) then
	f_messagechk(24,"") 
	dw_ip.SetColumn("k_symd")
	dw_ip.SetFocus()
	return -1
end if	
 
dw_print.modify("symd.text ='"+symd_text+"'")
dw_print.modify("eymd.text ='"+eymd_text+"'")

if sabu_f = '10' and sabu_t = '98' then
	sSaupj = '99'
	select rfna1 into :ref_saup from reffpf where rfcod = 'AD' and rfgub = :sSaupj;
else
	sSaupj = sabu_f
	select rfna1 into :ref_saup from reffpf where rfcod = 'AD' and rfgub = :sabu_f;
end if

dw_print.modify("saup.text ='"+ref_saup+"'") // 사업명 move

setpointer(hourglass!)

/*현금계정과목*/
select substr(dataname,1,7)	into :sCashCode	from syscnfg where sysgu = 'A' and serial = 1 and lineno = '1' ;

dw_list.SetRedraw(false)
if dw_print.retrieve(sSaupj,Left(sAcc_Ymd,4),sabu_f,sabu_t,sacc_ymd,eacc_ymd,sCashCode) <= 0 then
	F_MessageChk(14,'')
   dw_list.SetRedraw(true)	
	return -1	  
END IF
dw_print.sharedata(dw_list)
dw_list.SetRedraw(true)	
setpointer(arrow!)

return 1
end function

on w_kgld14.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kgld14.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;
dw_ip.SetItem(1,"k_symd", Left(f_today(), 6)+'01')
dw_ip.SetItem(1,"k_eymd", f_today())
dw_ip.SetItem(1,"saupj",  gs_saupj)
dw_ip.SetFocus()


IF F_Authority_Chk(Gs_Dept) = -1 THEN							/*권한 체크- 현업 여부*/
	dw_ip.SetItem(dw_ip.GetRow(),"saupj",   Gs_Saupj)
	
	dw_ip.Modify("saupj.protect = 1")
ELSE
	dw_ip.Modify("saupj.protect = 0")
END IF	
end event

type p_preview from w_standard_print`p_preview within w_kgld14
integer x = 4082
integer y = 12
end type

type p_exit from w_standard_print`p_exit within w_kgld14
integer x = 4430
integer y = 12
end type

type p_print from w_standard_print`p_print within w_kgld14
integer x = 4256
integer y = 12
end type

type p_retrieve from w_standard_print`p_retrieve within w_kgld14
integer x = 3909
integer y = 12
end type

type st_window from w_standard_print`st_window within w_kgld14
integer x = 2409
integer width = 457
end type

type sle_msg from w_standard_print`sle_msg within w_kgld14
integer width = 2016
end type

type dw_datetime from w_standard_print`dw_datetime within w_kgld14
integer x = 2866
end type

type st_10 from w_standard_print`st_10 within w_kgld14
end type

type gb_10 from w_standard_print`gb_10 within w_kgld14
integer width = 3607
end type

type dw_print from w_standard_print`dw_print within w_kgld14
string dataobject = "dw_kgld142_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kgld14
integer x = 46
integer y = 24
integer width = 2299
integer height = 152
string dataobject = "dw_kgld141"
end type

type dw_list from w_standard_print`dw_list within w_kgld14
integer x = 59
integer y = 192
integer width = 4530
integer height = 2052
string title = "현금 출납장"
string dataobject = "dw_kgld142"
boolean border = false
end type

type rr_1 from roundrectangle within w_kgld14
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 184
integer width = 4553
integer height = 2072
integer cornerheight = 40
integer cornerwidth = 55
end type

