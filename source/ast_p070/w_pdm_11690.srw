$PBExportHeader$w_pdm_11690.srw
$PBExportComments$** 표준 공정 현황
forward
global type w_pdm_11690 from w_standard_print
end type
type rb_item from radiobutton within w_pdm_11690
end type
type rb_job from radiobutton within w_pdm_11690
end type
type rb_1 from radiobutton within w_pdm_11690
end type
type rb_2 from radiobutton within w_pdm_11690
end type
type rb_group from radiobutton within w_pdm_11690
end type
type gb_1 from groupbox within w_pdm_11690
end type
type gb_2 from groupbox within w_pdm_11690
end type
type rr_1 from roundrectangle within w_pdm_11690
end type
type rr_2 from roundrectangle within w_pdm_11690
end type
end forward

global type w_pdm_11690 from w_standard_print
string title = "표준 공정 조회 출력"
rb_item rb_item
rb_job rb_job
rb_1 rb_1
rb_2 rb_2
rb_group rb_group
gb_1 gb_1
gb_2 gb_2
rr_1 rr_1
rr_2 rr_2
end type
global w_pdm_11690 w_pdm_11690

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string cod1, cod2, ls_choic
String sPdtgu, sJocod, sUseyn

if dw_ip.AcceptText() = -1 then return -1

cod1 = trim(dw_ip.object.cod1[1])
cod2 = trim(dw_ip.object.cod2[1])
ls_choic = trim(dw_ip.object.choice[1])
sUseyn	= trim(dw_ip.object.useyn[1])

if (IsNull(cod1) or cod1 = "")  then cod1 = "0"
if (IsNull(cod2) or cod2 = "")  then cod2 = "ZZZZZZ"
if (IsNull(sUseyn) or sUseyn = "") then sUseyn = "0"

sPdtgu = Trim(dw_ip.GetItemString(1, 'pdtgu'))
If IsNull(sPdtgu) Then sPdtgu = ''

sJocod = Trim(dw_ip.GetItemString(1, 'jocod'))
If IsNull(sJocod) Then sJocod = ''

//if rb_item.checked = true then
//
//  if ls_choic='1' then
//	  dw_list.Dataobject="d_pdm_11690_01_1"
//  else
//	  dw_list.Dataobject="d_pdm_11690_01"
//  end if
//
//else
//	
//	if ls_choic='1' then
//	  dw_list.Dataobject="d_pdm_11690_02_1"
//   else
//	  dw_list.Dataobject="d_pdm_11690_02"
//   end if
//	
//end if	
dw_list.SetTransobject(sqlca)

if dw_print.Retrieve(cod1, cod2, sPdtgu+'%', sJocod+'%', sUseyn) <= 0 then
	f_message_chk(50,'[표준공정현황]')
	dw_ip.Setfocus()
	return -1
end if

dw_print.sharedata(dw_list)

// Argument 표시
String tx_name

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(pdtgu) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_pdtgu.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.GetItemString(1, 'jonam'))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_jocod.text = '"+tx_name+"'")

return 1

end function

on w_pdm_11690.create
int iCurrent
call super::create
this.rb_item=create rb_item
this.rb_job=create rb_job
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_group=create rb_group
this.gb_1=create gb_1
this.gb_2=create gb_2
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_item
this.Control[iCurrent+2]=this.rb_job
this.Control[iCurrent+3]=this.rb_1
this.Control[iCurrent+4]=this.rb_2
this.Control[iCurrent+5]=this.rb_group
this.Control[iCurrent+6]=this.gb_1
this.Control[iCurrent+7]=this.gb_2
this.Control[iCurrent+8]=this.rr_1
this.Control[iCurrent+9]=this.rr_2
end on

on w_pdm_11690.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_item)
destroy(this.rb_job)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_group)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.rr_1)
destroy(this.rr_2)
end on

type p_xls from w_standard_print`p_xls within w_pdm_11690
boolean visible = true
integer x = 4238
integer y = 24
boolean enabled = false
string picturename = "C:\erpman\image\엑셀변환_d.gif"
end type

type p_sort from w_standard_print`p_sort within w_pdm_11690
integer y = 20
end type

type p_preview from w_standard_print`p_preview within w_pdm_11690
integer x = 4064
string pointer = "c:\erpman\cur\preview.cur"
end type

type p_exit from w_standard_print`p_exit within w_pdm_11690
integer x = 4411
string pointer = "c:\erpman\cur\close.cur"
end type

type p_print from w_standard_print`p_print within w_pdm_11690
boolean visible = false
integer x = 3058
integer y = 16
string pointer = "c:\erpman\cur\print.cur"
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdm_11690
integer x = 3890
string pointer = "c:\erpman\cur\retrieve.cur"
end type

event p_retrieve::clicked;call super::clicked;if is_Upmu = 'A' then
	
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
//	p_print.Enabled =False
//	p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'
	p_xls.Enabled = False
	p_xls.PictureName = 'C:\erpman\image\엑셀변환_d.gif'

	p_preview.enabled = False
	p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
	SetPointer(Arrow!)
	Return
Else
//	p_print.Enabled =True
//	p_print.PictureName =  'C:\erpman\image\인쇄_up.gif'
	p_xls.Enabled = True
	p_xls.PictureName = 'C:\erpman\image\엑셀변환_up.gif'

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







type st_10 from w_standard_print`st_10 within w_pdm_11690
end type



type dw_print from w_standard_print`dw_print within w_pdm_11690
integer x = 3657
string dataobject = "d_pdm_11690_01_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdm_11690
integer x = 795
integer y = 52
integer width = 3017
integer height = 180
string dataobject = "d_pdm_11690_03"
end type

event dw_ip::itemchanged;string s_cod, s_nam1, s_nam2, sData, sname, snull
integer i_rtn

s_cod = Trim(this.GetText())

SetNull(sNull)

//if this.Getcolumnname() = "choice" then
//
//	s_cod = Trim(this.GetText())
//	
//		if s_cod = '1' then
//			 
//				if rb_item.checked = true then	
//				
//						dw_list.Setredraw(False)
//						dw_list.DataObject = "d_pdm_11690_01_1"
//						dw_list.SetTransObject(SQLCA)
//						dw_list.Reset()
//						dw_list.Setredraw(True)
//																	
//				else
//					
//						dw_list.Setredraw(False)
//						dw_list.DataObject = "d_pdm_11690_02_1"
//						dw_list.SetTransObject(SQLCA)
//						dw_list.Reset()
//						dw_list.Setredraw(True)
//						
//												
//				end if
//		else
//			     
//				  if rb_item.checked = true then	
//						dw_list.Setredraw(False)
//						dw_list.DataObject = "d_pdm_11690_01"
//						dw_list.SetTransObject(SQLCA)
//						dw_list.Reset()
//						dw_list.Setredraw(True)
//					else
//					
//						dw_list.Setredraw(False)
//						dw_list.DataObject = "d_pdm_11690_02"
//						dw_list.SetTransObject(SQLCA)
//						dw_list.Reset()
//						dw_list.Setredraw(True)
//					end if
//
//		end if	
//end if
//


if rb_item.checked then
   if this.getcolumnname() = 'cod1' then   
	   i_rtn = f_get_name2("품번", "N", s_cod, s_nam1, s_nam2)
		this.setitem(1,"cod1",s_cod)		
		this.setitem(1,"nam1",s_nam1)
		this.setitem(1,"cod2",s_cod)
		this.setitem(1,"nam2",s_nam1)
		return i_rtn
	elseif this.getcolumnname() = 'cod2' then   
	   i_rtn = f_get_name2("품번", "N", s_cod, s_nam1, s_nam2)
		this.setitem(1,"cod2",s_cod)		
		this.setitem(1,"nam2",s_nam1)
		return i_rtn
   end if	
else
	if this.getcolumnname() = 'cod1' then   
	   i_rtn = f_get_name2("작업장", "N", s_cod, s_nam1, s_nam2)
		this.setitem(1,"cod1",s_cod)		
		this.setitem(1,"nam1",s_nam1)
		this.setitem(1,"cod2",s_cod)		
		this.setitem(1,"nam2",s_nam1)
		return i_rtn
   elseif this.getcolumnname() = 'cod2' then   
	   i_rtn = f_get_name2("작업장", "N", s_cod, s_nam1, s_nam2)
		this.setitem(1,"cod2",s_cod)		
		this.setitem(1,"nam2",s_nam1)
		return i_rtn
   end if
end if

Choose Case GetColumnName()
	Case 'jocod'
		sData = this.gettext()
		Select jonam into :sName From jomast
		Where jocod = :sData;
		if sqlca.sqlcode <> 0 then
		f_message_chk(33,'[반코드]')
			setitem(1, "jocod", sNull)
			setitem(1, "jonam", sNull)
			setcolumn("jocod")
			setfocus()
			Return 1					
		End if
		setitem(1, "jonam", sName)
End Choose
end event

event dw_ip::rbuttondown;String sData
long lrow

SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

if rb_item.checked then
   IF	this.getcolumnname() = "cod1"	THEN		
	   open(w_itemas_popup)
	   this.SetItem(1, "cod1", gs_code)
	   this.SetItem(1, "nam1", gs_codename)
		return
   ELSEIF this.getcolumnname() = "cod2" THEN		
	   open(w_itemas_popup)
	   this.SetItem(1, "cod2", gs_code)
	   this.SetItem(1, "nam2", gs_codename)
		return
   END IF
elseif rb_job.checked then
   IF	this.getcolumnname() = "cod1"	THEN		
	   open(w_workplace_popup)
	   this.SetItem(1, "cod1", gs_code)
	   this.SetItem(1, "nam1", gs_codename)
		return
   ELSEIF this.getcolumnname() = "cod2" THEN		
	   open(w_workplace_popup)
	   this.SetItem(1, "cod2", gs_code)
	   this.SetItem(1, "nam2", gs_codename)
		return
   END IF
end if

Choose Case GetColumnName()
	 Case 'jocod'
			Open(w_jomas_popup)
			SetItem(1,'jocod',gs_code)
			SetItem(1,'jonam',gs_codename)
End Choose
end event

event dw_ip::itemerror;return 1
end event

event dw_ip::ue_key;call super::ue_key;SetNull(gs_code)
SetNull(gs_codename)
if rb_item.Checked = False then return
IF keydown(keyF2!) THEN
   IF	this.getcolumnname() = "cod1"	THEN		
	   open(w_itemas_popup2)
	   this.SetItem(1, "cod1", gs_code)
	   this.SetItem(1, "nam1", gs_codename)
	   return 
   ELSEIF this.getcolumnname() = "cod2" THEN		
	   open(w_itemas_popup2)
	   this.SetItem(1, "cod2", gs_code)
	   this.SetItem(1, "nam2", gs_codename)
	   return 
   END IF
END IF  
end event

type dw_list from w_standard_print`dw_list within w_pdm_11690
integer x = 50
integer y = 284
integer width = 4507
integer height = 1996
string dataobject = "d_pdm_11690_01"
boolean border = false
end type

type rb_item from radiobutton within w_pdm_11690
integer x = 110
integer y = 120
integer width = 279
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "품목별"
boolean checked = true
end type

event clicked;if rb_1.checked = true then
	dw_list.setredraw(false)
	dw_list.DataObject = "d_pdm_11690_01_1" 
	dw_list.SetTransObject(SQLCA)
	dw_list.reset()
	dw_list.Setredraw(True)
	
	dw_print.DataObject = "d_pdm_11690_01_1_p" 
	dw_print.SetTransObject(SQLCA)
	
   dw_ip.Setredraw(False)
	dw_ip.DataObject = "d_pdm_11690_03"
	dw_ip.SetTransObject(SQLCA)
	dw_ip.Reset()
	dw_ip.InsertRow(0)
	dw_ip.SetFocus()
	dw_ip.Setredraw(True)
else
	dw_list.setredraw(false)
	dw_list.DataObject = "d_pdm_11690_01" 
	dw_list.SetTransObject(SQLCA)
	dw_list.reset()
	dw_list.Setredraw(True)
	
	dw_print.DataObject = "d_pdm_11690_01_p" 
	dw_print.SetTransObject(SQLCA)
	
   dw_ip.Setredraw(False)
	dw_ip.DataObject = "d_pdm_11690_03"
	dw_ip.SetTransObject(SQLCA)
	dw_ip.Reset()
	dw_ip.InsertRow(0)
	dw_ip.SetFocus()
	dw_ip.Setredraw(True)
	
end if

p_print.Enabled =False
p_preview.enabled = False



end event

type rb_job from radiobutton within w_pdm_11690
integer x = 393
integer y = 116
integer width = 338
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "작업장별"
end type

event clicked;if rb_1.checked = true then
	dw_list.setredraw(false)
	dw_list.DataObject = "d_pdm_11690_02_1" 
	dw_list.SetTransObject(SQLCA)
	dw_list.reset()
	dw_list.Setredraw(True)
	
	dw_print.DataObject = "d_pdm_11690_02_1_p" 
	dw_print.SetTransObject(SQLCA)
	
   dw_ip.Setredraw(False)
	dw_ip.DataObject = "d_pdm_11690_04"
	dw_ip.SetTransObject(SQLCA)
	dw_ip.Reset()
	dw_ip.InsertRow(0)
	dw_ip.SetFocus()
	dw_ip.Setredraw(True)
else
	dw_list.setredraw(false)
	dw_list.DataObject = "d_pdm_11690_02" 
	dw_list.SetTransObject(SQLCA)
	dw_list.reset()
	dw_list.Setredraw(True)
	
	dw_print.DataObject = "d_pdm_11690_02_p" 
	dw_print.SetTransObject(SQLCA)
	
   dw_ip.Setredraw(False)
	dw_ip.DataObject = "d_pdm_11690_04"
	dw_ip.SetTransObject(SQLCA)
	dw_ip.Reset()
	dw_ip.InsertRow(0)
	dw_ip.SetFocus()
	dw_ip.Setredraw(True)
	
end if

p_print.Enabled =False
p_preview.enabled = False

p_print.PictureName ="C:\erpman\image\인쇄_d.gif"
p_preview.PictureName = "C:\erpman\image\미리보기_d.gif"


end event

type rb_1 from radiobutton within w_pdm_11690
boolean visible = false
integer x = 3758
integer y = 184
integer width = 608
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "금형/치공구 포함"
end type

event clicked;if rb_item.checked = true then
	dw_list.setredraw(false)
	dw_list.DataObject = "d_pdm_11690_01_1" 
	dw_list.SetTransObject(SQLCA)
	dw_list.reset()
	dw_list.Setredraw(True)
	
	dw_print.DataObject = "d_pdm_11690_01_1_p" 
	dw_print.SetTransObject(SQLCA)
else
	dw_list.setredraw(false)
	dw_list.DataObject = "d_pdm_11690_02_1" 
	dw_list.SetTransObject(SQLCA)
	dw_list.reset()
	dw_list.Setredraw(True)
	
	dw_print.DataObject = "d_pdm_11690_02_1_p" 
	dw_print.SetTransObject(SQLCA)
end if
p_print.Enabled =False

p_preview.enabled = False


end event

type rb_2 from radiobutton within w_pdm_11690
boolean visible = false
integer x = 3031
integer y = 184
integer width = 581
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "금형/치공구 제외"
boolean checked = true
end type

event clicked;if rb_item.checked = true then
	dw_list.setredraw(false)
	dw_list.DataObject = "d_pdm_11690_01" 
	dw_list.SetTransObject(SQLCA)
	dw_list.reset()
	dw_list.Setredraw(True)
	
	dw_print.DataObject = "d_pdm_11690_01_p" 
	dw_print.SetTransObject(SQLCA)
else
	dw_list.setredraw(false)
	dw_list.DataObject = "d_pdm_11690_02" 
	dw_list.SetTransObject(SQLCA)
	dw_list.reset()
	dw_list.Setredraw(True)
	
	dw_print.DataObject = "d_pdm_11690_02_p" 
	dw_print.SetTransObject(SQLCA)
end if

p_print.Enabled =False
p_preview.enabled = False

end event

type rb_group from radiobutton within w_pdm_11690
boolean visible = false
integer x = 151
integer y = 176
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "작업그룹별"
boolean automatic = false
end type

event clicked;dw_list.setredraw(false)
dw_list.DataObject = "d_pdm_11690_07" 
dw_list.SetTransObject(SQLCA)
dw_list.reset()
dw_list.Setredraw(True)

dw_print.DataObject = "d_pdm_11690_07_p" 
dw_print.SetTransObject(SQLCA)

dw_ip.Setredraw(False)
dw_ip.DataObject = "d_pdm_11690_06"
dw_ip.SetTransObject(SQLCA)
dw_ip.Reset()
dw_ip.InsertRow(0)
dw_ip.SetFocus()
dw_ip.Setredraw(True)

p_print.Enabled =False
p_preview.enabled = False

p_print.PictureName ="C:\erpman\image\인쇄_d.gif"
p_preview.PictureName = "C:\erpman\image\미리보기_d.gif"


end event

type gb_1 from groupbox within w_pdm_11690
integer x = 87
integer y = 44
integer width = 686
integer height = 184
integer taborder = 50
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "출력구분"
end type

type gb_2 from groupbox within w_pdm_11690
boolean visible = false
integer x = 2715
integer y = 144
integer width = 1810
integer height = 128
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "선택"
end type

type rr_1 from roundrectangle within w_pdm_11690
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 55
integer y = 32
integer width = 3771
integer height = 216
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pdm_11690
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 272
integer width = 4539
integer height = 2020
integer cornerheight = 40
integer cornerwidth = 55
end type

