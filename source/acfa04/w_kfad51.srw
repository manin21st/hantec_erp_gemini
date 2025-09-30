$PBExportHeader$w_kfad51.srw
$PBExportComments$감가상각명세서 조회 출력
forward
global type w_kfad51 from w_standard_print
end type
type st_wait from statictext within w_kfad51
end type
type rr_1 from roundrectangle within w_kfad51
end type
end forward

global type w_kfad51 from w_standard_print
integer x = 0
integer y = 0
string title = "감가상각명세서 조회 출력"
st_wait st_wait
rr_1 rr_1
end type
global w_kfad51 w_kfad51

type variables
String proc_gu
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String  sKfsaCod,sKfCod1,sFrym,sToYm

setpointer(hourglass!)

w_mdi_frame.sle_msg.text =""

dw_ip.AcceptText()

sKfsaCod = dw_ip.GetItemString(dw_ip.GetRow(),"kfsacod")
sFrYm    = Trim(dw_ip.GetItemString(dw_ip.GetRow(),"frym"))
sToYm    = Trim(dw_ip.GetItemString(dw_ip.GetRow(),"toym"))
sKfCod1  = dw_ip.GetItemString(dw_ip.GetRow(),"kfcod1")

if sKfsaCod = '' or IsNull(sKfSaCod) then
	F_MessageChk(1,'[사업장]')
	dw_ip.SetColumn("kfsacod")
	dw_ip.SetFocus()
	Return -1
end if
if sFrYm = '' or IsNull(sFrYm) then
	F_MessageChk(1,'[기간]')
	dw_ip.SetColumn("frym")
	dw_ip.SetFocus()
	Return -1
end if
if sToYm = '' or IsNull(sToYm) then
	F_MessageChk(1,'[기간]')
	dw_ip.SetColumn("toym")
	dw_ip.SetFocus()
	Return -1
end if
if sKfCod1 = '' or IsNull(sKfCod1) then sKfCod1 = '%'

if dw_print.Retrieve(sKfSacod,sFrym,sToYm,sKfcod1) <= 0 then
	F_MessageChk(14,'')
	Return -1
else
	dw_print.ShareData(dw_list)
end if
setpointer(ARROW!)

Return 1
end function

on w_kfad51.create
int iCurrent
call super::create
this.st_wait=create st_wait
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_wait
this.Control[iCurrent+2]=this.rr_1
end on

on w_kfad51.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_wait)
destroy(this.rr_1)
end on

event open;call super::open;Integer iRtnVal

dw_ip.SetItem(dw_ip.GetRow(), "frym", Left(f_Today(),6)+'01')
dw_ip.SetItem(dw_ip.GetRow(), "toym", f_Today())

dw_ip.SetItem(dw_ip.GetRow(), "kfsacod",gs_saupj)

IF Upper(Mid(is_window_id,4,2)) = 'BG' THEN							   /*예산*/
	IF F_Valid_EmpNo(Gs_EmpNo) = 'N' THEN							/*권한 체크- 현업 여부*/
		dw_ip.SetItem(dw_ip.GetRow(),"kfsacod",   Gs_Saupj)
		
		dw_ip.Modify("kfsacod.protect = 1")
	ELSE
		dw_ip.Modify("kfsacod.protect = 0")
	END IF
ELSE
	IF Upper(Mid(is_window_id,4,2)) = 'FI' THEN							/*자금*/
		iRtnVal = F_Authority_Fund_Chk(Gs_Dept)	
	ELSE
		iRtnVal = F_Authority_Chk(Gs_Dept)
	END IF
	IF iRtnVal = -1 THEN							/*권한 체크- 현업 여부*/
		dw_ip.SetItem(dw_ip.GetRow(),"kfsacod",   Gs_Saupj)
		
		dw_ip.Modify("kfsacod.protect = 1")
	ELSE
		dw_ip.Modify("kfsacod.protect = 0")
	END IF	
END IF

end event

type p_preview from w_standard_print`p_preview within w_kfad51
integer y = 0
end type

type p_exit from w_standard_print`p_exit within w_kfad51
integer y = 0
end type

type p_print from w_standard_print`p_print within w_kfad51
integer y = 0
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfad51
integer y = 0
end type







type st_10 from w_standard_print`st_10 within w_kfad51
end type



type dw_print from w_standard_print`dw_print within w_kfad51
string dataobject = "dw_kfad512_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kfad51
integer x = 27
integer y = 20
integer width = 3191
integer height = 116
string dataobject = "dw_kfad511"
end type

event dw_ip::itemchanged;call super::itemchanged;String sKfCod1, sKfSacod, sYm,sNull

SetNull(snull)

IF this.GetColumnName() = "kfsacod" THEN
	sKfsaCod = this.GetText()
	IF sKfSaCod = "" OR IsNull(sKfSaCod) THEN Return

	If IsNull(F_Get_Refferance('AD',sKfSaCod)) THEN
		F_MessageChk(20,'[사업장]')
		this.SetItem(this.GetRow(),"kfsacod",snull)
		Return 1
	END IF
END IF

if this.GetColumnName() = "frym" then
	sYm = Trim(this.GetText())
	if sYm = '' or IsNull(sYm) then Return
	
	if F_DateChk(sYm) = -1 then
		F_Messagechk(21,'[기간]')
		this.SetItem(this.GetRow(),"frym", sNull)
		Return 1
	end if
end if
if this.GetColumnName() = "toym" then
	sYm = Trim(this.GetText())
	if sYm = '' or IsNull(sYm) then Return
	
	if F_DateChk(sYm) = -1 then
		F_Messagechk(21,'[기간]')
		this.SetItem(this.GetRow(),"toym", sNull)
		Return 1
	end if
end if
IF this.GetColumnName() = "kfcod1" THEN
	sKfCod1 = this.GetText()
	IF sKfCod1 = "" OR IsNull(sKfCod1) THEN Return
	
	If IsNull(F_Get_Refferance('F1',sKfCod1)) THEN
		F_MessageChk(20,'[고정자산구분]')
		this.SetItem(this.GetRow(),"kfcod1",snull)
		Return 1
	END IF
END IF

end event

event dw_ip::itemerror;call super::itemerror;Return 1
end event

type dw_list from w_standard_print`dw_list within w_kfad51
integer x = 41
integer y = 164
integer width = 4571
integer height = 2032
string dataobject = "dw_kfad512"
boolean border = false
end type

type st_wait from statictext within w_kfad51
boolean visible = false
integer x = 18
integer y = 2264
integer width = 1947
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 28144969
long backcolor = 32106727
boolean enabled = false
string text = "당기상각액을 계산하고 있습니다. 잠시만 기다리십시오 ! "
alignment alignment = center!
boolean border = true
long bordercolor = 255
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_kfad51
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 156
integer width = 4594
integer height = 2060
integer cornerheight = 40
integer cornerwidth = 55
end type

