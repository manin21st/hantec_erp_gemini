$PBExportHeader$w_kglb013.srw
$PBExportComments$부서별 예산내역 조회
forward
global type w_kglb013 from window
end type
type p_exit from uo_picture within w_kglb013
end type
type cb_inq from commandbutton within w_kglb013
end type
type dw_ret from datawindow within w_kglb013
end type
type dw_ip from datawindow within w_kglb013
end type
type rr_1 from roundrectangle within w_kglb013
end type
end forward

global type w_kglb013 from window
integer x = 393
integer y = 212
integer width = 4402
integer height = 2300
boolean titlebar = true
string title = "부서별 예산 조회"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
event keyup pbm_keyup
p_exit p_exit
cb_inq cb_inq
dw_ret dw_ret
dw_ip dw_ip
rr_1 rr_1
end type
global w_kglb013 w_kglb013

type variables
String LsYeGu
end variables

event open;String sCdeptCode,sControlGbn

f_window_center_Response(this)

dw_ip.settransobject(sqlca)
dw_ip.Reset()
dw_ip.InsertRow(0)

sCdeptCode =Message.StringParm

dw_ip.SetItem(dw_ip.GetRow(),"saupj",  lstr_jpra.saupjang)
dw_ip.SetItem(dw_ip.GetRow(),"dept_cd",sCdeptCode)
dw_ip.SetItem(dw_ip.GetRow(),"acc1_cd",lstr_jpra.acc1)
dw_ip.SetItem(dw_ip.GetRow(),"accname",lstr_jpra.acc1_nm)

/*예산 구분*/
SELECT "KFZ01OM0"."YE_GU"      INTO :LsYeGu  
	FROM "KFZ01OM0"  
   WHERE ( "KFZ01OM0"."ACC1_CD" = :lstr_jpra.acc1 ) AND ( "KFZ01OM0"."ACC2_CD" = :lstr_jpra.acc2 )   ;

dw_ip.Modify("txt_yegu.text = "+"('"+F_Get_Refferance('AB',LsYeGu)+"')")

dw_ip.SetItem(dw_ip.GetRow(),"acc_yy",Left(lstr_jpra.baldate,4))
dw_ip.SetItem(dw_ip.GetRow(),"acc_mm",Mid(lstr_jpra.baldate,5,2))

dw_ret.settransobject(sqlca)

cb_inq.TriggerEvent(Clicked!)
end event

on w_kglb013.create
this.p_exit=create p_exit
this.cb_inq=create cb_inq
this.dw_ret=create dw_ret
this.dw_ip=create dw_ip
this.rr_1=create rr_1
this.Control[]={this.p_exit,&
this.cb_inq,&
this.dw_ret,&
this.dw_ip,&
this.rr_1}
end on

on w_kglb013.destroy
destroy(this.p_exit)
destroy(this.cb_inq)
destroy(this.dw_ret)
destroy(this.dw_ip)
destroy(this.rr_1)
end on

type p_exit from uo_picture within w_kglb013
integer x = 4169
integer y = 24
integer width = 178
integer taborder = 1
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;close(parent)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type cb_inq from commandbutton within w_kglb013
boolean visible = false
integer x = 3077
integer y = 36
integer width = 293
integer height = 108
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "조회(&R)"
end type

event clicked;string  sSaupj,sAccYy,sAccMm,sCdeptCd,sAcc1
Integer iFindRow

dw_ip.AcceptText()

sSaupj   = dw_ip.Getitemstring(dw_ip.Getrow(),"saupj")
sAccYy   = dw_ip.Getitemstring(dw_ip.Getrow(),"acc_yy")
sAccMm   = dw_ip.Getitemstring(dw_ip.Getrow(),"acc_mm")

sCdeptCd = dw_ip.Getitemstring(dw_ip.Getrow(),"dept_cd")
sAcc1    = dw_ip.Getitemstring(dw_ip.Getrow(),"acc1_cd")

if sSaupj = "" or IsNull(sSaupj) then
   F_MessageChk(1,'[사업장]')
	dw_ip.SetColumn("saupj")
	dw_ip.SetFocus()
   return
end if

if sAccYy = "" or IsNull(sAccYy) then
   F_MessageChk(1,'[회계년도]')
	dw_ip.SetColumn("acc_yy")
	dw_ip.SetFocus()
   return
end if

if sAccMm = "" or IsNull(sAccMm) then
   F_MessageChk(1,'[회계월]')
	dw_ip.SetColumn("acc_mm")
	dw_ip.SetFocus()
   return
end if

if sCdeptCd = "" or IsNull(sCdeptCd) then
   F_MessageChk(1,'[배정부서]')
	dw_ip.SetColumn("dept_cd")
	dw_ip.SetFocus()
   return
end if

if sAcc1 = ""  or IsNull(sAcc1) then
   sAcc1 = "%"
END IF

IF dw_ret.Retrieve(sSaupj,sAccYy,sAccMm,sCdeptCd,sAcc1,lsyegu) <=0 THEN 
   F_MessageChk(14,'')
   return
end if

iFindRow = dw_ret.Find("acc1_cd = '"+lstr_jpra.acc1 + "' and acc2_cd = '" + lstr_jpra.acc2 + "'",1,dw_ret.RowCount())
IF iFindRow > 0 THEN
	dw_ret.ScrollToRow(iFindRow)
	dw_ret.SelectRow(0,False)
	dw_ret.SelectRow(iFindRow,True)
END IF
	
end event

type dw_ret from datawindow within w_kglb013
integer x = 32
integer y = 224
integer width = 4315
integer height = 1948
string dataobject = "dw_kglb013_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type dw_ip from datawindow within w_kglb013
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 5
integer width = 2715
integer height = 212
string dataobject = "dw_kglb013_1"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;
Send(Handle(this),256,9,0)
Return 1
end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;string ls_acc1_cd, sqlfd

dw_ip.AcceptText()
ls_acc1_cd = dw_ip.Getitemstring(dw_ip.Getrow(),"acc1_cd")

SELECT "KFZ01OM0"."ACC1_NM"  
       INTO :sqlfd
       FROM "KFZ01OM0"  
       WHERE ( "KFZ01OM0"."ACC1_CD" = :ls_acc1_cd ) using sqlca ;
if sqlca.sqlcode <> 100 then
   dw_ip.Setitem(dw_ip.Getrow(),"accname",sqlfd)
else
   dw_ip.Setitem(dw_ip.Getrow(),"accname","")
end if
end event

event rbuttondown;Int ll_barnum

SetNull(gs_code)
SetNull(gs_codename)

dw_ip.AcceptText()

IF this.GetColumnName() = "acc1_cd" THEN
	gs_code= Trim(dw_ip.GetItemString(dw_ip.GetRow(), "acc1_cd"))
	
	if IsNull(gs_code) then
		gs_code =" "
	end if
	
	Open(w_kfe01om0_popup)
	
	if IsNull(gs_code) then
		dw_ip.SetItem(dw_ip.GetRow(), "accname", gs_code)
	ELSE
		ll_barnum =Pos(gs_codename,"-")
		
		dw_ip.SetItem(dw_ip.GetRow(), "acc1_cd", Left(gs_code,5))
		dw_ip.SetItem(dw_ip.GetRow(), "accname", Mid(gs_codename,1,ll_barnum - 1))  
	end if
	dw_ip.SetFocus()
END IF
end event

event itemerror;Return 1
end event

type rr_1 from roundrectangle within w_kglb013
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 216
integer width = 4338
integer height = 1964
integer cornerheight = 40
integer cornerwidth = 55
end type

