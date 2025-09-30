$PBExportHeader$w_pdt_01015.srw
$PBExportComments$** 연동 생산계획(외주 발주 생성)
forward
global type w_pdt_01015 from window
end type
type p_create from picture within w_pdt_01015
end type
type p_exit from picture within w_pdt_01015
end type
type st_1 from statictext within w_pdt_01015
end type
type dw_update from datawindow within w_pdt_01015
end type
type dw_ip from datawindow within w_pdt_01015
end type
end forward

global type w_pdt_01015 from window
integer x = 850
integer y = 364
integer width = 1577
integer height = 1804
boolean titlebar = true
string title = "외주 발주 생성"
windowtype windowtype = response!
long backcolor = 32106727
p_create p_create
p_exit p_exit
st_1 st_1
dw_update dw_update
dw_ip dw_ip
end type
global w_pdt_01015 w_pdt_01015

type variables

end variables

event open;f_window_center(this)
dw_ip.settransobject(sqlca)
dw_ip.InsertRow(0)

string syymm 
int    get_seq, irtn

f_mod_saupj(dw_ip, 'saupj')
f_child_saupj(dw_ip, 'empno', gs_saupj)

//syymm = f_aftermonth( left(f_today(), 6) , 1)
syymm = gs_code
SELECT max("MONPLN_SUM"."MOSEQ")  
  INTO :get_seq  
  FROM "MONPLN_SUM"  
 WHERE ( "MONPLN_SUM"."SABU" = :gs_sabu ) AND  
		 ( "MONPLN_SUM"."MONYYMM" = :syymm )   ;

if isnull(get_seq) or get_seq = 0 then 
	messagebox("확 인", ""+left(syymm,4)+"년 " + mid(syymm,5,2) +"월 연동생산 계획 자료가" + &
	                    " 존재하지 않습니다. ~n~n 연동생산 계획 자료를 생성 후 작업하십시요."  )
	p_exit.triggerevent(clicked!)
	return 
end if

dw_ip.setitem(1, 'yymm', syymm)
dw_ip.setitem(1, 'seq', get_seq)

dw_ip.setfocus()

end event

on w_pdt_01015.create
this.p_create=create p_create
this.p_exit=create p_exit
this.st_1=create st_1
this.dw_update=create dw_update
this.dw_ip=create dw_ip
this.Control[]={this.p_create,&
this.p_exit,&
this.st_1,&
this.dw_update,&
this.dw_ip}
end on

on w_pdt_01015.destroy
destroy(this.p_create)
destroy(this.p_exit)
destroy(this.st_1)
destroy(this.dw_update)
destroy(this.dw_ip)
end on

type p_create from picture within w_pdt_01015
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 1184
integer y = 24
integer width = 178
integer height = 144
string pointer = "C:\erpman\cur\create2.cur"
string picturename = "C:\erpman\image\생성_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;this.PictureName = 'C:\erpman\image\생성_dn.gif'
end event

event ue_lbuttonup;this.PictureName = 'C:\erpman\image\생성_up.gif'
end event

event clicked;String syymm, sempno, steam, sfitnbr, stitnbr, siempno, sdeptno, errchk, sdelgub, sestno, ssaupj
int    iseq

if dw_ip.AcceptText() = -1 then return 

ssaupj  = dw_ip.getitemstring(1, "saupj")
if isnull(ssaupj) or ssaupj = "" then
	f_message_chk(30,'[사업장]')
	return
end if	

syymm  = dw_ip.getitemstring(1, "yymm")
if isnull(syymm) or syymm = "" then
	f_message_chk(30,'[기준년월]')
	return
end if	

iseq   = dw_ip.getitemnumber(1, "seq")
if isnull(iseq) or iseq = 0 then
	f_message_chk(30,'[확정/조정구분]')
	return
end if	

sempno = dw_ip.getitemstring(1, "empno")
if isnull(sempno) or sempno = "" then
	f_message_chk(30,'[외주담당자]')
	dw_ip.Setcolumn('empno')
	dw_ip.SetFocus()
	return
end if	

steam  = dw_ip.getitemstring(1, "steam")
if isnull(steam) or steam = "" then
	f_message_chk(30,'[생산팀]')
	dw_ip.Setcolumn('steam')
	dw_ip.SetFocus()
	return
end if	

sfitnbr = dw_ip.getitemstring(1, "fr_itnbr")
if isnull(sfitnbr) or sfitnbr = "" then sfitnbr = '.'

stitnbr = dw_ip.getitemstring(1, "to_itnbr")
if isnull(stitnbr) or stitnbr = "" then stitnbr = 'zzzzzzzzzzzzzzz'

siempno  = dw_ip.getitemstring(1, "iempno")
if isnull(siempno) or siempno = "" then
	f_message_chk(30,'[의뢰담당자]')
	dw_ip.Setcolumn('iempno')
	dw_ip.SetFocus()
	return
end if	

sdeptno  = dw_ip.getitemstring(1, "ideptno")
if isnull(sdeptno) or sdeptno = "" then
	f_message_chk(30,'[의뢰부서]')
	dw_ip.Setcolumn('ideptno')
	dw_ip.SetFocus()
	return
end if	

sDelgub  = dw_ip.getitemstring(1, "delgub")
if sDelgub = '' or isnull(sDelgub) then sDelgub = 'N'

if messagebox("확 인", '외주발주 자료를 생성하시겠습니까?', &
              Question!, YesNo!, 2) = 2 then return   

SetPointer(HourGlass!)
st_1.text = "외주발주 자료 생성 中 .......... "

errchk = 'X' 
sestno = 'X'

sqlca.erp000000400(gs_sabu, syymm, iseq, sempno, steam, sfitnbr, stitnbr, sdeptno, siempno, sdelgub, ssaupj, errchk)

IF errchk = 'N' THEN
	commit ;
	st_1.text = ''
	if isnull(sestno) then sestno = '없음'
   messagebox("확 인", "외주발주 자료가 처리되었습니다. ")	
ELSEIF errchk = 'Y' then 
   st_1.text = ""
	f_message_chk(41,'')
	ROLLBACK;
ELSEIF errchk = 'C' then 
   st_1.text = ""
	f_message_chk(51,'')
	ROLLBACK;
ELSEif errchk = 'B' then 
	commit ;
	st_1.text = ''
   messagebox("확 인", "조건에 맞는 처리 자료가 없습니다.")	
ELSE 
   st_1.text = ""
	f_message_chk(41,'')
	ROLLBACK;
END IF

end event

type p_exit from picture within w_pdt_01015
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 1367
integer y = 24
integer width = 178
integer height = 144
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;this.PictureName = 'C:\erpman\image\닫기_dn.gif'
end event

event ue_lbuttonup;this.PictureName = 'C:\erpman\image\닫기_up.gif'
end event

event clicked;close(parent)
end event

type st_1 from statictext within w_pdt_01015
integer x = 32
integer y = 1628
integer width = 1518
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_update from datawindow within w_pdt_01015
boolean visible = false
integer x = 695
integer y = 2020
integer width = 494
integer height = 360
string dataobject = "d_pdm_01555_2"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_ip from datawindow within w_pdt_01015
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 23
integer y = 180
integer width = 1536
integer height = 1428
integer taborder = 10
string dataobject = "d_pdt_01015"
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF

end event

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemchanged;string	sCode, sName,	sname2, sdept, sdeptnm
int      ireturn 

IF this.GetColumnName() = "ideptno" THEN
	scode = this.GetText()								
   ireturn = f_get_name2('부서', 'Y', scode, sname, sname2)    //1이면 실패, 0이 성공	

	this.setitem(1, 'ideptno', scode)
	this.setitem(1, 'ideptnm', sName)
   return ireturn 
ELSEIF this.GetColumnName() = "iempno" THEN

	scode = this.GetText()								
   ireturn = f_get_name2('사번', 'Y', scode, sname, sname2)    //1이면 실패, 0이 성공	

	this.setitem(1, 'iempno', scode)
	this.setitem(1, 'iempnm', sname)
	if ireturn = 0 and scode > '.' then 
		SELECT "P1_MASTER"."DEPTCODE", "VNDMST"."CVNAS2"  
		  INTO :sdept, :sdeptnm
		  FROM "P1_MASTER", "VNDMST"  
	 	 WHERE ( "P1_MASTER"."DEPTCODE" = "VNDMST"."CVCOD" (+)) AND 
				 ( "P1_MASTER"."EMPNO" = :scode  ) ;   
		this.setitem(1, 'ideptno', sdept)
		this.setitem(1, 'ideptnm', sdeptnm)
	end if
   return ireturn 
ELSEIF this.GetColumnName() = "saupj" THEN
	scode = this.GetText()								
	f_child_saupj(dw_ip, 'empno', scode)
END IF
end event

event rbuttondown;SetNull(Gs_Gubun)
SetNull(Gs_code)
SetNull(Gs_codename)

Choose case this.getcolumnname()
		 case 'ideptno'
				Open(w_vndmst_4_popup)
				
				if gs_code ='' or isnull(gs_code) then return 
				
				this.setitem(1, "ideptno", gs_code)
				this.setitem(1, "ideptnm", gs_codename)
		 case 'iempno'
				Open(w_sawon_popup)

				if gs_code ='' or isnull(gs_code) then return 
				
				this.setitem(1, "iempno", gs_code)
				this.setitem(1, "iempnm", gs_codename)

				this.setitem(1, "ideptno", gs_gubun)
				
				string sdata
				Select deptname2 Into :sData From p0_dept where deptcode = :gs_gubun;
				this.setitem(1, "ideptnm", sdata)
		 case 'fr_itnbr'
				open(w_itemas_popup)
				
				if isnull(gs_code) or gs_code = "" then return
				
				this.SetItem(1,"fr_itnbr",gs_code)
		 case 'to_itnbr'
				open(w_itemas_popup)
				
				if isnull(gs_code) or gs_code = "" then return
				
				this.SetItem(1,"to_itnbr",gs_code)
End choose


end event

event itemerror;RETURN 1
end event

