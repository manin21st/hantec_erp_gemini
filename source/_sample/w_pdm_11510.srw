$PBExportHeader$w_pdm_11510.srw
$PBExportComments$** 거래처현황 출력
forward
global type w_pdm_11510 from w_standard_print
end type
type rr_2 from roundrectangle within w_pdm_11510
end type
end forward

global type w_pdm_11510 from w_standard_print
string title = "거래처 조회 출력"
rr_2 rr_2
end type
global w_pdm_11510 w_pdm_11510

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String scodef,snamef,scodet,snamet,sguf,sgunamef,sgut,sgunamet,ssort_gu, sfilter, &
		 scd_min,scd_max,sgu_min,sgu_max, saleyn, sgumaeyn, soyjuyn, soyjugayn, syongyn
Long   lLen		 
		 
IF dw_ip.AcceptText() = -1 THEN RETURN -1

SELECT MIN("VNDMST"."CVCOD"),MAX("VNDMST"."CVCOD"),  
       MIN("VNDMST"."CVGU"),MAX("VNDMST"."CVGU")  
	INTO :scd_min,:scd_max,   
        :sgu_min,:sgu_max  
   FROM "VNDMST"   ;
	
scodef =dw_ip.GetItemString(1,"scvcod")
scodet =dw_ip.GetItemString(1,"ecvcod")

IF scodef ="" OR IsNull(scodef) THEN
	scodef =scd_min
	SELECT "VNDMST"."CVNAS2"         
		INTO :snamef
  		FROM "VNDMST"  
   	WHERE "VNDMST"."CVCOD" =:scodef;
ELSE
	snamef =dw_ip.GetItemString(1,"snamef")
END IF

IF scodet ="" OR IsNull(scodet) THEN
	scodet =scd_max
	SELECT "VNDMST"."CVNAS2"         
		INTO :snamet
  		FROM "VNDMST"  
   	WHERE "VNDMST"."CVCOD" =:scodet;
ELSE
	snamet =dw_ip.GetItemString(1,"snamet")
END IF

sguf   =dw_ip.GetItemString(1,"scvgu")
sgut   =dw_ip.GetItemString(1,"ecvgu")

IF sguf ="" OR IsNull(sguf) THEN
	sguf = sgu_min
END IF

SELECT "REFFPF"."RFNA1"  
  INTO :sgunamef  
  FROM "REFFPF"  
  WHERE ( "REFFPF"."SABU" = '1' ) AND  
        ( "REFFPF"."RFCOD" = '18' ) AND  
        ( "REFFPF"."RFGUB" = :sguf )   ;

IF sgut ="" OR IsNull(sgut) THEN
	sgut =sgu_max
END IF
SELECT "REFFPF"."RFNA1"  
  INTO :sgunamet  
  FROM "REFFPF"  
  WHERE ( "REFFPF"."SABU" = '1' ) AND  
        ( "REFFPF"."RFCOD" = '18' ) AND  
        ( "REFFPF"."RFGUB" = :sgut )   ;

if scodef > scodet then 
	f_message_chk(34,'[거래처코드]')
	dw_ip.Setcolumn('scvcod')
	dw_ip.SetFocus()
	return -1
end if	

saleyn    = dw_ip.GetItemString(1,"saleyn")
sgumaeyn  = dw_ip.GetItemString(1,"gumaeyn")
soyjuyn   = dw_ip.GetItemString(1,"oyjuyn")
soyjugayn = dw_ip.GetItemString(1,"oyjugayn")
syongyn   = dw_ip.GetItemString(1,"yongyn")

sfilter = ""

IF saleyn    = "Y"  THEN sfilter = "saleyn = 'Y' or "
IF sgumaeyn  = "Y"  THEN sfilter = sfilter + "gumaeyn = 'Y' or "
IF soyjuyn   = "Y"  THEN sfilter = sfilter + "oyjuyn = 'Y' or "
IF soyjugayn = "Y"  THEN sfilter = sfilter + "oyjugayn = 'Y' or "
IF syongyn   = "Y"  THEN sfilter = sfilter + "yongyn = 'Y' or "

lLen = len(sfilter)
sfilter = left(sfilter, lLen - 3)

dw_list.SetFilter(sfilter)
dw_list.Filter( )

IF dw_print.Retrieve(scodef,scodet,sguf,sgut,snamef,snamet,sgunamef,sgunamet) <=0 THEN
	f_message_chk(50,"")
	Return -1
END IF

dw_print.sharedata(dw_list)

Return 1
end function

on w_pdm_11510.create
int iCurrent
call super::create
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
end on

on w_pdm_11510.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_2)
end on

type p_xls from w_standard_print`p_xls within w_pdm_11510
boolean visible = true
integer x = 4247
integer y = 24
boolean enabled = false
string picturename = "C:\erpman\image\엑셀변환_d.gif"
end type

type p_sort from w_standard_print`p_sort within w_pdm_11510
end type

type p_preview from w_standard_print`p_preview within w_pdm_11510
integer x = 4073
end type

type p_exit from w_standard_print`p_exit within w_pdm_11510
integer x = 4421
end type

type p_print from w_standard_print`p_print within w_pdm_11510
boolean visible = false
integer x = 3589
integer y = 40
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdm_11510
integer x = 3899
end type

event p_retrieve::clicked;//

if is_Upmu = 'A' then
	
	if dw_ip.AcceptText() = -1 then return  

	w_mdi_frame.sle_msg.text =""
	
	sabu_f =Trim(dw_ip.GetItemString(1,"saupj"))
	
	SetPointer(HourGlass!)
	IF sabu_f ="" OR IsNull(sabu_f) OR sabu_f ="99" THEN	//사업장이 전사이거나 없으면 모든 사업장//
		sabu_f ="10"
		sabu_t ="98"
		SELECT "REFFPF"."RFNA1"  
		 INTO :sabu_nm  
		 FROM "REFFPF"  
		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND  
				( "REFFPF"."RFGUB" = '99' )   ;
	ELSE
		sabu_t =sabu_f
		SELECT "REFFPF"."RFNA1"  
		 INTO :sabu_nm  
		 FROM "REFFPF"  
		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND  
				( "REFFPF"."RFGUB" = :sabu_f )   ;
	END IF
end if

IF wf_retrieve() = -1 THEN
	p_xls.Enabled =False
	p_xls.PictureName = 'C:\erpman\image\엑셀변환_d.gif'

	p_preview.enabled = False
	p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
	SetPointer(Arrow!)
	Return
Else
	p_xls.Enabled =True
	p_xls.PictureName =  'C:\erpman\image\엑셀변환_up.gif'
	p_preview.enabled = true
	p_preview.PictureName = 'C:\erpman\image\미리보기_up.gif'
END IF
dw_list.scrolltorow(1)
dw_list.SetFocus()
SetPointer(Arrow!)	

w_mdi_frame.sle_msg.text =""

///-----------------------------------------------------------------------------------------
// by 2006.09.30 font채 변경 - 신
String ls_gbn
SELECT DATANAME
  INTO :ls_gbn
  FROM SYSCNFG
 WHERE SYSGU  = 'C'
   AND SERIAL = '81'
   AND LINENO = '1' ;
If ls_gbn = 'Y' Then
	//wf_setfont()
	WindowObject l_object[]
	Long i
	gstr_object_chg lstr_object		
	For i = 1 To UpperBound(Control[])
		lstr_object.lu_object[i] = Control[i]  //Window Object
		lstr_object.li_obj = i						//Window Object 갯수
	Next
	f_change_font(lstr_object)
End If

///-----------------------------------------------------------------------------------------


end event

type st_window from w_standard_print`st_window within w_pdm_11510
integer x = 2775
integer y = 2676
end type

type sle_msg from w_standard_print`sle_msg within w_pdm_11510
integer x = 800
integer y = 2676
end type

type dw_datetime from w_standard_print`dw_datetime within w_pdm_11510
integer x = 3269
integer y = 2676
end type

type st_10 from w_standard_print`st_10 within w_pdm_11510
integer x = 439
integer y = 2676
end type

type gb_10 from w_standard_print`gb_10 within w_pdm_11510
integer x = 425
integer y = 2640
end type

type dw_print from w_standard_print`dw_print within w_pdm_11510
integer x = 3790
integer y = 116
string dataobject = "d_pdm_11510_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdm_11510
integer x = 37
integer y = 0
integer width = 3803
integer height = 220
string dataobject = "d_pdm_11510_a"
end type

event dw_ip::itemchanged;String ssort_gu, scode, sname, sname2
Int ireturn

IF this.GetColumnName() = "scvcod" THEN
	scode = this.GetText()
	
	ireturn = f_get_name2('V0', 'N', scode, sname, sname2)
	dw_ip.SetItem(1,"scvcod",scode)
	dw_ip.SetItem(1,"snamef",sname)
   return ireturn 
ELSEIF this.GetColumnName() = "ecvcod" THEN
	scode = this.GetText()
	
	ireturn = f_get_name2('V0', 'N', scode, sname, sname2)
	dw_ip.SetItem(1,"ecvcod",scode)
	dw_ip.SetItem(1,"snamet",sname)
   return ireturn 
ELSEIF this.GetColumnName() = "sort_gu" THEN 
	
	ssort_gu = this.GetText()
	
	dw_list.SetRedraw(False)
	IF ssort_gu ="1" THEN
		dw_list.SetSort("vndmst_cvgu A,vndmst_cvcod A")
	ELSE
		dw_list.SetSort("vndmst_cvgu A,vndmst_cvnas A")
	END IF
	dw_list.Sort()
	dw_list.SetRedraw(True)
END IF
end event

event dw_ip::rbuttondown;IF this.GetColumnName() <> "scvcod" AND this.GetColumnName() <> "ecvcod" THEN RETURN

SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

OPEN(W_VNDMST_POPUP)

if gs_code = '' or isnull(gs_code) then return 

IF this.GetColumnName() ="scvcod" THEN
	dw_ip.SetItem(1,"scvcod",gs_code)
	dw_ip.SetItem(1,"snamef",gs_codename)
ELSE
	dw_ip.SetItem(1,"ecvcod",gs_code)
	dw_ip.SetItem(1,"snamet",gs_codename)
END IF


end event

event dw_ip::ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemerror;
Return 1
end event

type dw_list from w_standard_print`dw_list within w_pdm_11510
integer x = 46
integer y = 232
integer width = 4539
integer height = 2072
string dataobject = "d_pdm_11510"
boolean border = false
end type

type rr_2 from roundrectangle within w_pdm_11510
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 224
integer width = 4562
integer height = 2092
integer cornerheight = 40
integer cornerwidth = 55
end type

