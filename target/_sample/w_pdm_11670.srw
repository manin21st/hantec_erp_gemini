$PBExportHeader$w_pdm_11670.srw
$PBExportComments$** 작업장 조회 출력
forward
global type w_pdm_11670 from w_standard_print
end type
type cbx_1 from checkbox within w_pdm_11670
end type
type rb_1 from radiobutton within w_pdm_11670
end type
type rb_2 from radiobutton within w_pdm_11670
end type
type st_1 from statictext within w_pdm_11670
end type
type rb_3 from radiobutton within w_pdm_11670
end type
end forward

global type w_pdm_11670 from w_standard_print
integer height = 2524
string title = "작업장마스타 출력"
cbx_1 cbx_1
rb_1 rb_1
rb_2 rb_2
st_1 st_1
rb_3 rb_3
end type
global w_pdm_11670 w_pdm_11670

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string	sFrom, sTo, ls_porgu, ls_rfna1, ls_rfna2

//////////////////////////////////////////////////////////////////
IF dw_ip.accepttext() = -1 THEN RETURN -1

//조회 조건에서 사업장 추가 시작
ls_porgu = dw_ip.getItemString(1, "porgu")

SELECT "REFFPF"."RFNA1"  ,
       "REFFPF"."RFGUB"
Into :ls_rfna1, :ls_rfna2
FROM "REFFPF"  
WHERE ( "REFFPF"."SABU" = '1' ) AND  
      ( "REFFPF"."RFCOD" = 'AD' ) AND  
      ( "REFFPF"."RFGUB" NOT IN ('00','99') ) AND
      ( "REFFPF"."RFGUB" = :ls_porgu ) ;

//조회 조건에서 사업장 추가 끝

sFrom = trim(dw_ip.getitemstring(1, 's_from'))
sTo = trim(dw_ip.getitemstring(1, 's_to'))

if sFrom = "" or isnull(sFrom) then	
	SELECT MIN("WRKCTR"."WKCTR")
	  INTO :sFrom  
	  FROM "WRKCTR"  ;
END IF
	
IF sTo   = ""	or isnull(sTo) then	
	SELECT MAX("WRKCTR"."WKCTR")
	  INTO :sTo  
	  FROM "WRKCTR"  ;
END IF

IF	( sFrom > sTo  )	  then
	MessageBox("확인","작업장코드의 범위를 확인하세요!")
	dw_ip.setcolumn('s_from')
	dw_ip.setfocus()
	Return -1
END IF

/////////////////////////////////////////////////////////////////
if rb_3.checked = true then
	dw_list.DataObject = 'd_pdm_11670_5'
	dw_print.DataObject = 'd_pdm_11670_5_p'
elseIF cbx_1.checked = true		THEN				// 대체품

	IF rb_1.checked = true	THEN
		dw_list.DataObject = 'd_pdm_11670_1'
		dw_print.DataObject = 'd_pdm_11670_1_p'
	ELSE
		dw_list.DataObject = 'd_pdm_11670_3'
		dw_print.DataObject = 'd_pdm_11670_3_p'
	END IF
	
ELSE
	
	IF rb_1.checked = true	THEN
		dw_list.DataObject = 'd_pdm_11670_2'
		dw_print.DataObject = 'd_pdm_11670_2_p'
	ELSE
		dw_list.DataObject = 'd_pdm_11670_4'
		dw_print.DataObject = 'd_pdm_11670_4_p'
	END IF
	
END IF

if ls_porgu ='%' Then
	dw_print.object.t_100.text = '전체'
ElseIf ls_porgu = ls_rfna2 Then
	dw_print.object.t_100.text = ls_rfna1
End If

dw_list.SetTransObject(sqlca)
dw_print.SetTransObject(sqlca)
////////////////////////////////////////////////////////////////
if dw_print.retrieve(sFrom, sTo, ls_porgu ) < 1	then
	f_message_chk(50,"")
	dw_ip.setcolumn('s_from')
	dw_ip.setfocus()
	return -1
end if

dw_print.sharedata(dw_list)

Return 1
end function

on w_pdm_11670.create
int iCurrent
call super::create
this.cbx_1=create cbx_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.st_1=create st_1
this.rb_3=create rb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_1
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.rb_3
end on

on w_pdm_11670.destroy
call super::destroy
destroy(this.cbx_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.st_1)
destroy(this.rb_3)
end on

event open;call super::open;f_mod_saupj(dw_ip, 'porgu')

end event

type dw_list from w_standard_print`dw_list within w_pdm_11670
integer y = 324
integer height = 1964
string dataobject = "d_pdm_11670_1"
end type

type cb_print from w_standard_print`cb_print within w_pdm_11670
end type

type cb_excel from w_standard_print`cb_excel within w_pdm_11670
end type

type cb_preview from w_standard_print`cb_preview within w_pdm_11670
end type

type cb_1 from w_standard_print`cb_1 within w_pdm_11670
end type

type dw_print from w_standard_print`dw_print within w_pdm_11670
integer x = 3909
integer y = 152
string dataobject = "d_pdm_11670_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdm_11670
integer y = 56
integer height = 216
string dataobject = "d_pdm_11670_a"
end type

event dw_ip::rbuttondown;setnull(gs_code)
setnull(gs_codename)

if this.GetColumnName() = 's_from' then
	gs_code = dw_ip.GetText()
	open(w_workplace_popup)
	if isnull(gs_code) or gs_code = "" then return
	dw_ip.SetItem(1,"s_from",gs_code)
	dw_ip.SetItem(1,"s_frnm",gs_codename)
	
	dw_ip.SetColumn('s_to')
	dw_ip.SetFocus()
elseif this.GetColumnName() = 's_to' then
	gs_code = dw_ip.GetText()
	open(w_workplace_popup)
	if isnull(gs_code) or gs_code = "" then return
	dw_ip.SetItem(1,"s_to",gs_code)
	dw_ip.SetItem(1,"s_tonm",gs_codename)
end if	
end event

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;string s_itnbr, snull, s_name

setnull(snull)

if this.getcolumnname() = 's_from' then   
	
	s_itnbr = this.gettext()
	
	if s_itnbr = "" or isnull(s_itnbr) then 
		this.setitem(1,"s_from",snull)
		this.setitem(1,"s_frnm",snull)		
		return
	end if
	
  SELECT "WRKCTR"."WCDSC"  
    INTO :s_name  
    FROM "WRKCTR"  
   WHERE "WRKCTR"."WKCTR" = :s_itnbr   ;

	if sqlca.sqlcode = 0 then
		this.setitem(1,"s_frnm",s_name)
	else
		this.SetItem(1,"s_frnm",snull)	
      return 
   end if
elseif this.getcolumnname() = "s_to" then   
	
	s_itnbr = this.gettext()
	
	if s_itnbr = "" or isnull(s_itnbr) then 
		this.setitem(1,"s_to",snull)
		this.setitem(1,"s_tonm",snull)		
		return
	end if
	
  SELECT "WRKCTR"."WCDSC"  
    INTO :s_name  
    FROM "WRKCTR"  
   WHERE "WRKCTR"."WKCTR" = :s_itnbr   ;
	 
	if sqlca.sqlcode = 0 then
		this.setitem(1,"s_tonm",s_name)
	else
		this.setitem(1,"s_tonm",snull)	
      return 
	end if
end if

end event

type r_1 from w_standard_print`r_1 within w_pdm_11670
integer y = 320
end type

type r_2 from w_standard_print`r_2 within w_pdm_11670
integer height = 224
end type

type cbx_1 from checkbox within w_pdm_11670
integer x = 1385
integer y = 176
integer width = 439
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12639424
string text = "대체작업장"
boolean checked = true
end type

type rb_1 from radiobutton within w_pdm_11670
integer x = 347
integer y = 184
integer width = 325
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "굴림"
long backcolor = 12639424
string text = "작업장별"
boolean checked = true
end type

event clicked;cbx_1.visible = true

end event

type rb_2 from radiobutton within w_pdm_11670
integer x = 695
integer y = 184
integer width = 274
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "굴림"
long backcolor = 12639424
string text = "블럭별"
end type

event clicked;cbx_1.visible = true
end event

type st_1 from statictext within w_pdm_11670
integer x = 87
integer y = 184
integer width = 256
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12639424
boolean enabled = false
string text = "출력조건"
boolean focusrectangle = false
end type

type rb_3 from radiobutton within w_pdm_11670
integer x = 1001
integer y = 184
integer width = 274
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "굴림"
long backcolor = 12639424
string text = "설비별"
end type

event clicked;cbx_1.visible = false
end event

