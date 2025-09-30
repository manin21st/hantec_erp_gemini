$PBExportHeader$w_pdm_11737.srw
$PBExportComments$외주bom-정전개/역전개현황
forward
global type w_pdm_11737 from w_standard_print
end type
type rb_drilldown from radiobutton within w_pdm_11737
end type
type rb_drillup from radiobutton within w_pdm_11737
end type
type gb_1 from groupbox within w_pdm_11737
end type
end forward

global type w_pdm_11737 from w_standard_print
string title = "외주BOM-정전개/역전개"
rb_drilldown rb_drilldown
rb_drillup rb_drillup
gb_1 gb_1
end type
global w_pdm_11737 w_pdm_11737

type variables
long    il_row
int       check_box
string  is_Gubun, Isbom
str_itnct lstr_sitnct
datastore ds_bom


end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();dw_list.reset()

String scvcod, sfitnbr, stitnbr, sbdate, sporgu, ls_rfna1, ls_rfna2

if dw_ip.accepttext() = -1 then return -1

scvcod  = dw_ip.getitemstring(1, "ittyp")
sfitnbr = dw_ip.getitemstring(1, "fr_itnbr")
stitnbr = dw_ip.getitemstring(1, "to_itnbr")
sbdate  = dw_ip.getitemstring(1, "bdate")
sporgu  = dw_ip.getitemstring(1, "porgu")

SELECT "REFFPF"."RFNA1"  ,
       "REFFPF"."RFGUB"
Into :ls_rfna1, :ls_rfna2
FROM "REFFPF"  
WHERE ( "REFFPF"."SABU" = '1' ) AND  
      ( "REFFPF"."RFCOD" = 'AD' ) AND  
     ( "REFFPF"."RFGUB" NOT IN ('00','99') )
AND "REFFPF"."RFGUB" = :sporgu;

if sporgu ='%' Then
	dw_print.object.t_18.text = '전체'
ElseIf sporgu = ls_rfna2 Then
	dw_print.object.t_18.text = ls_rfna1
End If

if isnull( scvcod  ) or trim( scvcod  ) = '' then scvcod  = '%'
if isnull( sfitnbr ) or trim( sfitnbr ) = '' then sfitnbr = '.'
if isnull( stitnbr ) or trim( stitnbr ) = '' then stitnbr = 'ZZZZZZ'
if isnull( sbdate  ) or trim( sbdate  ) = '' then sbdate  = f_today()

if dw_print.retrieve(sfitnbr, stitnbr, scvcod, sbdate, sporgu)  < 1 then
	return -1
end if

dw_print.ShareData ( dw_list )

w_mdi_frame.sle_msg.text = ''

dw_list.scrolltorow(1)
dw_list.setredraw(true)
setpointer(arrow!)

Return 1
end function

on w_pdm_11737.create
int iCurrent
call super::create
this.rb_drilldown=create rb_drilldown
this.rb_drillup=create rb_drillup
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_drilldown
this.Control[iCurrent+2]=this.rb_drillup
this.Control[iCurrent+3]=this.gb_1
end on

on w_pdm_11737.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_drilldown)
destroy(this.rb_drillup)
destroy(this.gb_1)
end on

event open;call super::open;dw_ip.setitem(1, "bdate", f_today())
end event

type p_preview from w_standard_print`p_preview within w_pdm_11737
end type

type p_exit from w_standard_print`p_exit within w_pdm_11737
end type

type p_print from w_standard_print`p_print within w_pdm_11737
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdm_11737
end type

event p_retrieve::clicked;
IF wf_retrieve() = -1 THEN
	p_print.Enabled =False
	p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

	p_preview.enabled = False
	p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
	SetPointer(Arrow!)
	Return
Else
	p_print.Enabled =True
	p_print.PictureName =  'C:\erpman\image\인쇄_up.gif'
	
	p_preview.enabled = true
	p_preview.PictureName = 'C:\erpman\image\미리보기_up.gif'
END IF
dw_list.scrolltorow(1)
SetPointer(Arrow!)

//dw_list.object.datawindow.print.preview="yes"



	
end event







type st_10 from w_standard_print`st_10 within w_pdm_11737
end type



type dw_print from w_standard_print`dw_print within w_pdm_11737
integer x = 4407
integer y = 184
integer width = 178
integer height = 144
string dataobject = "d_pdm_11737_p_single"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type dw_ip from w_standard_print`dw_ip within w_pdm_11737
integer x = 32
integer y = 188
integer width = 3712
integer height = 148
string dataobject = "d_pdm_11737_1"
end type

event dw_ip::itemchanged;call super::itemchanged;string scode

if THIS.GetColumnName() = "fr_itnbr" THEN
	sCode = This.GetText()
	
	IF sCode = '' OR ISNULL(sCode) THEN return 
	
	this.setitem(1, 'to_itnbr', sCode)
END IF	
end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

event dw_ip::rbuttondown;call super::rbuttondown;string sittyp

setnull(gs_gubun)
setnull(gs_code)
setnull(gs_codename)

this.accepttext()
if this.GetColumnName() = 'ittyp' then

	Open(w_vndmst_popup)
	
	this.SetItem(1,"ittyp", gs_code)

elseif this.GetColumnName() = 'fr_itnbr' then
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"fr_itnbr",gs_code)
	this.SetItem(1,"to_itnbr",gs_code)
elseif this.GetColumnName() = 'to_itnbr' then
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"to_itnbr",gs_code)
end if	


end event

event dw_ip::ue_key;call super::ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
	open(w_itemas_popup2)
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1, "itnbr", gs_code)
   RETURN 1
END IF

end event

type dw_list from w_standard_print`dw_list within w_pdm_11737
string dataobject = "d_pdm_11737_single"
end type

event dw_list::clicked;call super::clicked;if row > 0 then
	if dw_list.getitemstring(row, "gidat") < dw_list.getitemstring(row, "efrdt") or &
		dw_list.getitemstring(row, "gidat") > dw_list.getitemstring(row, "eftdt") then
		Messagebox("일자", "유효기간경과") 
	end if
end if
end event

type rb_drilldown from radiobutton within w_pdm_11737
integer x = 110
integer y = 72
integer width = 247
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "정전개"
boolean checked = true
end type

event clicked;dw_print.dataobject = 'd_pdm_11737_p_single'
dw_list.dataobject  = 'd_pdm_11737_single'
dw_list.settransobject(sqlca)
dw_print.settransobject(sqlca)
end event

type rb_drillup from radiobutton within w_pdm_11737
integer x = 402
integer y = 72
integer width = 274
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "역전개"
end type

event clicked;dw_print.dataobject = 'd_pdm_11737_p_single_1'
dw_list.dataobject  = 'd_pdm_11737_single_1'
dw_print.settransobject(sqlca)
dw_list.settransobject(sqlca)
end event

type gb_1 from groupbox within w_pdm_11737
integer x = 55
integer y = 28
integer width = 667
integer height = 132
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "전개방법"
end type

