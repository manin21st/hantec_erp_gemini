$PBExportHeader$w_qa90_00320.srw
$PBExportComments$정기검사 현황
forward
global type w_qa90_00320 from w_standard_print
end type
type pb_1 from u_pb_cal within w_qa90_00320
end type
type pb_2 from u_pb_cal within w_qa90_00320
end type
type rr_1 from roundrectangle within w_qa90_00320
end type
end forward

global type w_qa90_00320 from w_standard_print
integer width = 4677
integer height = 2752
string title = "정기 검사 현황"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_qa90_00320 w_qa90_00320

type prototypes



end prototypes

type variables
boolean lb_src_down, lb_dsc_down
String s_row
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String ls_cvcod , ls_syymm , ls_eyymm
String ls_gcgub, ls_gubun, ls_pdtgu
String ls_factory, ls_itnbr, ls_eoemp

if dw_ip.AcceptText() = -1 then 
	dw_ip.SetFocus()
	return -1
End if	

ls_cvcod   = Trim(dw_ip.Object.cvcod[1])
ls_syymm   = Trim(dw_ip.Object.syymm[1])
ls_eyymm   = Trim(dw_ip.Object.eyymm[1])
ls_gubun   = Trim(dw_ip.Object.gubun[1])
ls_pdtgu   = dw_ip.Object.pdtgu[1]
ls_factory = dw_ip.Object.factory[1]
ls_itnbr   = dw_ip.Object.itnbr[1]
ls_eoemp   = dw_ip.Object.eoemp[1]

If ls_cvcod = '' Or isNull(ls_cvcod) Then ls_cvcod = '%%'

If isNull(ls_syymm) or ls_syymm = '' or f_dateChk(ls_syymm+'01') < 1 Then
	f_message_chk(35 , '[검사월]')
	dw_ip.SetFocus()
	dw_ip.SetColumn("syymm")
	Return -1 
End If

If isNull(ls_eyymm) or ls_eyymm = '' or f_dateChk(ls_eyymm+'01') < 1 Then
	f_message_chk(35 , '[검사월]')
	dw_ip.SetFocus()
	dw_ip.SetColumn("eyymm")
	Return -1 
End If

If Trim(ls_factory) = '' OR IsNull(ls_factory) Then ls_factory = '%'
If Trim(ls_itnbr) = '' OR IsNull(ls_itnbr) Then ls_itnbr = '%'
If Trim(ls_eoemp) = '' OR IsNull(ls_eoemp) Then ls_eoemp = '%'

if dw_list.Retrieve(ls_cvcod , ls_syymm  ,ls_eyymm, ls_gubun, gs_saupj, ls_factory, ls_itnbr, ls_eoemp) <= 0 then
	f_message_chk(50,"[정기 검사 현황]")
	dw_ip.Setfocus()
	Return -1
End If

Return 1
	
end function

on w_qa90_00320.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.rr_1
end on

on w_qa90_00320.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.Object.syymm[1] = Left(is_today , 6)
dw_ip.Object.eyymm[1] = Left(is_today , 6)

end event

type p_xls from w_standard_print`p_xls within w_qa90_00320
boolean visible = true
integer x = 4215
integer y = 32
string picturename = "C:\erpman\image\엑셀변환_d.gif"
end type

type p_sort from w_standard_print`p_sort within w_qa90_00320
end type

type p_preview from w_standard_print`p_preview within w_qa90_00320
integer x = 4041
integer y = 32
end type

type p_exit from w_standard_print`p_exit within w_qa90_00320
integer x = 4389
integer y = 32
integer taborder = 110
end type

type p_print from w_standard_print`p_print within w_qa90_00320
boolean visible = false
integer x = 3054
integer y = 40
integer taborder = 70
end type

type p_retrieve from w_standard_print`p_retrieve within w_qa90_00320
integer x = 3867
integer y = 32
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



type sle_msg from w_standard_print`sle_msg within w_qa90_00320
boolean displayonly = true
end type



type st_10 from w_standard_print`st_10 within w_qa90_00320
end type



type dw_print from w_standard_print`dw_print within w_qa90_00320
string dataobject = "d_qa90_00320_p"
end type

type dw_ip from w_standard_print`dw_ip within w_qa90_00320
integer x = 32
integer y = 32
integer width = 2994
integer height = 260
string dataobject = "d_qa90_00320_1"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;String  ls_col , ls_cod ,ls_nam , ls_null, ls_cvcod, ls_cvnas
Setnull(ls_null)
ls_col = Lower(GetColumnName())
ls_cod = Trim(GetText())

Choose Case ls_col
  
	Case 'cvcod'
		If ls_cod = '' Or isNull(ls_cod) Then
			this.setitem(1,'cvcod',ls_null)
			this.setitem(1,'cvnas',ls_null)
			Return 
		End If
		
		select cvnas into :ls_nam 
		  from vndmst
	 	 where cvcod = :ls_cod ;
	 
		if sqlca.sqlcode = 0 then
			this.setitem(1,'cvnas',ls_nam)
		else
			f_message_chk(33, "[업체코드]")
			this.setitem(1,'cvcod',ls_null)
			this.setitem(1,'cvnas',ls_null)
			return 1
		end if
		
	 Case 'syymm' , 'eyymm'
		If f_datechk(ls_cod+'01') < 1 Then
			f_message_chk(35 , '[검사월]')
			this.setitem(1,ls_col,ls_null)
			Return 1
		End If
		
	Case 'factory'
		
		if ls_cod = '.' or isnull(ls_cod) or ls_cod = '' then return
		
		select a.rfna2 , b.cvnas
		  into :ls_cvcod, :ls_cvnas
		  from reffpf a, vndmst b
		 where a.rfcod = '2A' and a.rfgub = :ls_cod and a.rfna2 = b.cvcod ;
		
		If sqlca.sqlcode <> 0 Then
			This.Object.cvcod[GetRow()] = ""
			This.Object.cvnas[GetRow()] = ""
			Return 1
		End If

		This.Object.cvcod[GetRow()] = ls_cvcod
		This.Object.cvnas[GetRow()] = ls_cvnas
End Choose
end event

event dw_ip::rbuttondown;call super::rbuttondown;String ls_col

setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)
ls_col = Lower(GetColumnName())

Choose Case ls_col
	
	Case 'cvcod' 
		open(w_vndmst_popup)
		if isnull(gs_code) or gs_code = '' then return
		
		This.setitem(1,ls_col,gs_code)
	   This.TriggerEvent(itemchanged!)
	
	
	
End Choose

end event

type dw_list from w_standard_print`dw_list within w_qa90_00320
integer x = 55
integer y = 300
integer width = 4498
integer height = 1944
string dataobject = "d_qa90_00320_a"
boolean border = false
end type

event dw_list::clicked;call super::clicked;If Row <= 0 then
	SelectRow(0,False)
ELSE
	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
END IF
end event

type pb_1 from u_pb_cal within w_qa90_00320
integer x = 640
integer y = 156
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('syymm')
IF IsNull(gs_code) THEN Return
dw_ip.SetItem(1, 'syymm', left(gs_code,6))
end event

type pb_2 from u_pb_cal within w_qa90_00320
integer x = 1070
integer y = 156
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('eyymm')
IF IsNull(gs_code) THEN Return
dw_ip.SetItem(1, 'eyymm', left(gs_code,6))
end event

type rr_1 from roundrectangle within w_qa90_00320
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 292
integer width = 4521
integer height = 1968
integer cornerheight = 40
integer cornerwidth = 55
end type

