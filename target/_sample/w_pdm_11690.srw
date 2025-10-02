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
end forward

global type w_pdm_11690 from w_standard_print
integer width = 3835
integer height = 2372
string title = "표준 공정 조회 출력"
rb_item rb_item
rb_job rb_job
rb_1 rb_1
rb_2 rb_2
rb_group rb_group
gb_1 gb_1
gb_2 gb_2
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
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_item
this.Control[iCurrent+2]=this.rb_job
this.Control[iCurrent+3]=this.rb_1
this.Control[iCurrent+4]=this.rb_2
this.Control[iCurrent+5]=this.rb_group
this.Control[iCurrent+6]=this.gb_1
this.Control[iCurrent+7]=this.gb_2
end on

on w_pdm_11690.destroy
call super::destroy
destroy(this.rb_item)
destroy(this.rb_job)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_group)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event resize;r_2.width = this.width - 60
dw_ip.width = this.width - 778

r_1.width = this.width - 60
r_1.height = this.height - r_1.y - 65
dw_list.width = this.width - 70
dw_list.height = this.height - dw_list.y - 70
end event

type dw_list from w_standard_print`dw_list within w_pdm_11690
integer width = 3725
integer height = 1964
string dataobject = "d_pdm_11690_01"
end type

event dw_list::doubleclicked;//
end event

type cb_print from w_standard_print`cb_print within w_pdm_11690
end type

type cb_excel from w_standard_print`cb_excel within w_pdm_11690
end type

type cb_preview from w_standard_print`cb_preview within w_pdm_11690
end type

type cb_1 from w_standard_print`cb_1 within w_pdm_11690
end type

type dw_print from w_standard_print`dw_print within w_pdm_11690
integer x = 3657
string dataobject = "d_pdm_11690_01_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdm_11690
integer x = 745
integer width = 3017
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

type r_1 from w_standard_print`r_1 within w_pdm_11690
integer width = 3733
end type

type r_2 from w_standard_print`r_2 within w_pdm_11690
long fillcolor = 12639424
integer width = 3733
end type

type rb_item from radiobutton within w_pdm_11690
integer x = 59
integer y = 132
integer width = 279
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12639424
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



end event

type rb_job from radiobutton within w_pdm_11690
integer x = 343
integer y = 128
integer width = 338
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12639424
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
long backcolor = 12639424
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
long backcolor = 12639424
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

end event

type rb_group from radiobutton within w_pdm_11690
boolean visible = false
integer x = 101
integer y = 188
integer width = 402
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


end event

type gb_1 from groupbox within w_pdm_11690
integer x = 37
integer y = 56
integer width = 686
integer height = 184
integer taborder = 50
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12639424
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
long backcolor = 12639424
string text = "선택"
end type

