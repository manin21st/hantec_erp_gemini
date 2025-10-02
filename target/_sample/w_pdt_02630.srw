$PBExportHeader$w_pdt_02630.srw
$PBExportComments$생산미완료현황_작업장기준(open order)
forward
global type w_pdt_02630 from w_standard_print
end type
type ddlb_select from dropdownlistbox within w_pdt_02630
end type
type st_1 from statictext within w_pdt_02630
end type
type dw_jidat from datawindow within w_pdt_02630
end type
type dw_sort from u_d_popup_sort within w_pdt_02630
end type
end forward

global type w_pdt_02630 from w_standard_print
integer width = 5047
string title = "OPEN ORDER현황"
ddlb_select ddlb_select
st_1 st_1
dw_jidat dw_jidat
dw_sort dw_sort
end type
global w_pdt_02630 w_pdt_02630

forward prototypes
public function integer wf_retrieve_02630 ()
public function integer wf_retrieve_02640 ()
public function integer wf_retrieve_02650 ()
public function integer wf_retrieve_02635 ()
end prototypes

public function integer wf_retrieve_02630 ();
String sFrom,sTo, ls_jidat1, ls_jidat2

dw_ip.AcceptText()
dw_jidat.AcceptText()
sFrom       = trim(dw_ip.GetItemString(1,"wkctr"))
sTo         = trim(dw_ip.GetItemString(1,"wkctrto"))

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

ls_jidat1    = trim(dw_jidat.GetItemString(1,"jidat1"))
ls_jidat2    = trim(dw_jidat.GetItemString(1,"jidat2"))

If IsNull(ls_jidat1) or ls_jidat1 ='' Then ls_jidat1 = '10000101'
If IsNull(ls_jidat2) or ls_jidat2 ='' Then ls_jidat2 = '99991231'

IF	( sFrom > sTo  )	  then
	MessageBox("확인","작업장코드의 범위를 확인하세요!")
	dw_ip.setcolumn('wkctr')
	dw_ip.setfocus()
	Return -1
END IF

IF dw_print.Retrieve(gs_sabu,sFrom,sTo,ls_jidat1,ls_jidat2) <=0 THEN
	f_message_chk(50,'')
   dw_ip.setcolumn('wkctr')
	dw_ip.SetFocus()
	Return -1
END IF

dw_print.sharedata(dw_list)
dw_list.sharedata(dw_sort)
Return 1

end function

public function integer wf_retrieve_02640 ();
String sFrom,sTo, ls_jidat1, ls_jidat2

dw_ip.AcceptText()
dw_jidat.AcceptText()

sFrom       = trim(dw_ip.GetItemString(1,"pordno"))
sTo         = trim(dw_ip.GetItemString(1,"pordnoto"))

if isnull(sFrom) then
	sFrom = '.'
end if
if isnull(sTo) then
	sTo = 'ZXZZZZZ'
end if

IF	( sFrom > sTo  )	  then
	MessageBox("확인","작업지시번호의 범위를 확인하세요!")
	dw_ip.setcolumn('pordno')
	dw_ip.setfocus()
	Return -1
END IF

ls_jidat1    = trim(dw_jidat.GetItemString(1,"jidat1"))
ls_jidat2    = trim(dw_jidat.GetItemString(1,"jidat2"))

If IsNull(ls_jidat1) or ls_jidat1 ='' Then ls_jidat1 = '10000101'
If IsNull(ls_jidat2) or ls_jidat2 ='' Then ls_jidat2 = '99991231'

IF dw_print.Retrieve(gs_sabu,sFrom,sTo,ls_jidat1,ls_jidat2) <=0 THEN
	f_message_chk(50,'')
   dw_ip.setcolumn('pordno')
	dw_ip.SetFocus()
	Return -1
END IF

dw_print.sharedata(dw_list)
//dw_print.sharedata(dw_sort)
dw_list.sharedata(dw_sort)
Return 1

end function

public function integer wf_retrieve_02650 ();
String sFrom,sTo, ls_jidat1, ls_jidat2

dw_ip.AcceptText()
dw_jidat.AcceptText()

sFrom       = trim(dw_ip.GetItemString(1,"itnbr"))
sTo         = trim(dw_ip.GetItemString(1,"itnbrto"))

if sFrom = "" or isnull(sFrom) then	
	SELECT MIN("ITEMAS"."ITNBR")
	  INTO :sFrom  
	  FROM "ITEMAS"  ;
END IF
	
IF sTo   = ""	or isnull(sTo) then	
	SELECT MAX("ITEMAS"."ITNBR")
	  INTO :sTo  
	  FROM "ITEMAS"   ;
END IF

IF	( sFrom > sTo  )	  then
	MessageBox("확인","품목코드의 범위를 확인하세요!")
	dw_ip.setcolumn('itnbr')
	dw_ip.setfocus()
	Return -1
END IF

ls_jidat1    = trim(dw_jidat.GetItemString(1,"jidat1"))
ls_jidat2    = trim(dw_jidat.GetItemString(1,"jidat2"))

If IsNull(ls_jidat1) or ls_jidat1 ='' Then ls_jidat1 = '10000101'
If IsNull(ls_jidat2) or ls_jidat2 ='' Then ls_jidat2 = '99991231'

IF dw_print.Retrieve(gs_sabu,sFrom,sTo,ls_jidat1,ls_jidat2) <=0 THEN
	f_message_chk(50,'')
   dw_ip.setcolumn('itnbr')
	dw_ip.SetFocus()
	Return -1
END IF

dw_print.sharedata(dw_list)
//dw_print.sharedata(dw_sort)
dw_list.sharedata(dw_sort)
Return 1

end function

public function integer wf_retrieve_02635 ();
String sFrom,sTo, ls_jidat1, ls_jidat2

dw_ip.AcceptText()
dw_jidat.AcceptText()
sFrom    	= trim(dw_ip.GetItemString(1,"wkctr"))
sTo         	= trim(dw_ip.GetItemString(1,"wkctrto"))

if 	sFrom = "" or isnull(sFrom) then	
	sFrom 	= '.'
END IF
	
IF 	sTo   = ""	or isnull(sTo) then	
	sTo 	= 'ZZZZZZ'
END IF

ls_jidat1    = trim(dw_jidat.GetItemString(1,"jidat1"))
ls_jidat2    = trim(dw_jidat.GetItemString(1,"jidat2"))

If IsNull(ls_jidat1) or ls_jidat1 ='' Then ls_jidat1 = '10000101'
If IsNull(ls_jidat2) or ls_jidat2 ='' Then ls_jidat2 = '99991231'

IF	( sFrom > sTo  )	  then
	MessageBox("확인","공정코드의 범위를 확인하세요!")
	dw_ip.setcolumn('wkctr')
	dw_ip.setfocus()
	Return -1
END IF

IF 	dw_print.Retrieve(gs_sabu,sFrom,sTo,ls_jidat1,ls_jidat2) <=0 THEN
	f_message_chk(50,'')
   	dw_ip.setcolumn('wkctr')
	dw_ip.SetFocus()
	Return -1
END IF

dw_print.sharedata(dw_list)
dw_list.sharedata(dw_sort)
Return 1

end function

on w_pdt_02630.create
int iCurrent
call super::create
this.ddlb_select=create ddlb_select
this.st_1=create st_1
this.dw_jidat=create dw_jidat
this.dw_sort=create dw_sort
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.ddlb_select
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.dw_jidat
this.Control[iCurrent+4]=this.dw_sort
end on

on w_pdt_02630.destroy
call super::destroy
destroy(this.ddlb_select)
destroy(this.st_1)
destroy(this.dw_jidat)
destroy(this.dw_sort)
end on

event open;call super::open;ddlb_select.text = '작업장기준'
dw_ip.Setfocus()

dw_jidat.reset()
dw_jidat.insertRow(0)

dw_jidat.SetItem(1,'jidat1',Left(f_today(),6) + '01')
dw_jidat.SetItem(1,'jidat2',f_today())
end event

event ue_retrieve;int ireturn
Choose	Case 	ddlb_select.text
	Case 	'작업장기준' 
		ireturn = wf_retrieve_02630()
	Case 	'작업지시번호기준' 
		ireturn = wf_retrieve_02640()	
	Case 	'품목기준' 
		ireturn = wf_retrieve_02650()	
	Case 	'공정기준' 
		ireturn = wf_retrieve_02635()	
end Choose

IF 	ireturn  = -1 THEN
	//p_print.Enabled =False
	//p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

//	cb_ruler.Enabled = false
	//p_preview.enabled = False
	//p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
	SetPointer(Arrow!)
	Return
Else
	//p_print.Enabled =True
	//p_print.PictureName = 'C:\erpman\image\인쇄_up.gif'
//	if 	wf_objectcheck() = 1 then
//		//p_preview.enabled = true
//		//p_preview.PictureName = 'C:\erpman\image\미리보기_up.gif'
//	else
//		//p_preview.enabled = False
//		//p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
//	end if
	
END IF
dw_list.scrolltorow(1)
SetPointer(Arrow!)
end event

event resize;r_2.width = this.width - 60
dw_ip.width = this.width - 70

r_1.width = this.width - 60
r_1.height = this.height - r_1.y - 65
dw_list.width = this.width - 70
dw_list.height = this.height - dw_list.y - 70

dw_sort.height = dw_list.height
end event

type dw_list from w_standard_print`dw_list within w_pdt_02630
integer x = 3543
integer width = 741
integer height = 228
string title = "작업장 기준"
string dataobject = "d_pdt_02630_1"
end type

type cb_print from w_standard_print`cb_print within w_pdt_02630
integer x = 2263
integer y = 1156
end type

type cb_excel from w_standard_print`cb_excel within w_pdt_02630
integer x = 1595
integer y = 1156
end type

type cb_preview from w_standard_print`cb_preview within w_pdt_02630
integer x = 1929
integer y = 1156
end type

type cb_1 from w_standard_print`cb_1 within w_pdt_02630
integer x = 1262
integer y = 1156
end type

type dw_print from w_standard_print`dw_print within w_pdt_02630
integer x = 3392
integer y = 128
string dataobject = "d_pdt_02630_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_02630
integer y = 56
integer height = 188
string dataobject = "d_pdt_02630_0"
end type

event dw_ip::itemerror;
Return 1
end event

event dw_ip::rbuttondown;SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

Choose	Case	this.GetColumnName()
	Case 	"wkctr" 
		if	ddlb_select.text = '작업장기준'	then
			Open(w_workplace_popup)
			IF 	gs_code ="" OR IsNull(gs_code) THEN RETURN
			this.SetItem(1,"fname",Gs_CodeName)
			this.SetItem(1,"wkctr",gs_code)
			this.TriggerEvent(ItemChanged!)
			Return
		End If
	Case	"wkctrto" 
		if	ddlb_select.text = '작업장기준'	then
			Open(w_workplace_popup)
			IF gs_code ="" OR IsNull(gs_code) THEN RETURN
			this.SetItem(1,"tname",Gs_CodeName)
			this.SetItem(1,"wkctrto",gs_code)
			this.TriggerEvent(ItemChanged!)
			Return
		End If
	Case 	"pordno"		
		open(w_jisi_popup)
		if isnull(gs_code) or gs_code = "" then return
		this.SetItem(1, "pordno", gs_Code)
		return 1
	Case 	"pordnoto"	
		open(w_jisi_popup)
		if isnull(gs_code) or gs_code = "" then return
		this.SetItem(1, "pordnoto", gs_Code)
		return 1
	Case	"itnbr" 
		Open(w_itemas_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		this.SetItem(dw_ip.GetRow(),"itnbr",gs_code)
		Return
	Case	"itnbrto" 
		Open(w_itemas_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		this.SetItem(dw_ip.GetRow(),"itnbrto",gs_code)
		Return
END Choose

end event

event dw_ip::itemchanged;string swkctr, snull, s_name

setnull(snull)
swkctr = this.gettext()

Choose	Case	this.getcolumnname()
	Case 	"wkctr"
		if 	swkctr = "" or isnull(swkctr) then 
			this.setitem(1,"wkctr",snull)
			this.setitem(1,"fname",snull)		
			return
		end if
		
		if	ddlb_select.text = '작업장기준'	then
		  SELECT "WRKCTR"."WCDSC"  
			 INTO :s_name  
			 FROM "WRKCTR"  
			WHERE "WRKCTR"."WKCTR" = :swkctr   ;
		
			if 	sqlca.sqlcode = 0 then
				this.setitem(1,"fname",s_name)
			else
				this.SetItem(1,"fname",snull)	
				return 
			end if
		Else				// 공정기준.....
			SELECT "REFFPF"."RFNA1"  
			  INTO :s_name  
			  FROM "REFFPF"  
			 WHERE ( "REFFPF"."SABU" = '1' ) AND  
					 ( "REFFPF"."RFCOD" = '21' ) AND  
					 ( "REFFPF"."RFGUB" = :swkctr )   ;
		
			IF SQLCA.SQLCODE <> 0 THEN
				this.SetItem(1,"fname",sNull)
			ELSE	
				this.SetItem(1,"fname", left(s_name, 20))
			END IF
		end if
		
	Case 	"wkctrto"
		if 	swkctr = "" or isnull(swkctr) then 
			this.setitem(1,"wkctrto",snull)
			this.setitem(1,"tname",snull)		
			return
		end if
		
		if	ddlb_select.text = '작업장기준'	then
		  SELECT "WRKCTR"."WCDSC"  
			 INTO :s_name  
			 FROM "WRKCTR"  
			WHERE "WRKCTR"."WKCTR" = :swkctr   ;
			 
			if 	sqlca.sqlcode = 0 then
				this.setitem(1,"tname",s_name)
			else
				this.setitem(1,"tname",snull)	
				return
			end if
		Else				// 공정기준.....
			SELECT "REFFPF"."RFNA1"  
			  INTO :s_name  
			  FROM "REFFPF"  
			 WHERE ( "REFFPF"."SABU" = '1' ) AND  
					 ( "REFFPF"."RFCOD" = '21' ) AND  
					 ( "REFFPF"."RFGUB" = :swkctr )   ;
		
			IF SQLCA.SQLCODE <> 0 THEN
				this.SetItem(1,"tname",sNull)
			ELSE	
				this.SetItem(1,"tname", left(s_name, 20))
			END IF
		end if
End Choose

end event

type r_1 from w_standard_print`r_1 within w_pdt_02630
end type

type r_2 from w_standard_print`r_2 within w_pdt_02630
end type

type ddlb_select from dropdownlistbox within w_pdt_02630
integer x = 379
integer y = 64
integer width = 741
integer height = 396
integer taborder = 10
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
boolean vscrollbar = true
integer limit = 3
string item[] = {"작업장기준","작업지시번호기준","품목기준","공정기준"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;dw_print.setredraw(false)
dw_ip.setredraw(false)

Choose	Case 	ddlb_select.text
	Case 	'작업장기준'
		dw_ip.dataobject 	= 'd_pdt_02630_0'
		dw_list.dataobject 	= 'd_pdt_02630_1'
		dw_sort.dataobject 	= 'd_pdt_02630_1'
		dw_print.dataobject 	= 'd_pdt_02630_1_p'
		dw_list.title = '작업장기준'
	Case 	'작업지시번호기준' 
		dw_ip.dataobject 	= 'd_pdt_02640_0'
		dw_list.dataobject 	= 'd_pdt_02640_1'
		dw_sort.dataobject 	= 'd_pdt_02640_1'
		dw_print.dataobject 	= 'd_pdt_02640_1_p'	
		dw_list.title = '작업지시번호기준'
	Case 	'품목기준'
		dw_ip.dataobject 	= 'd_pdt_02650_0'
		dw_list.dataobject 	= 'd_pdt_02650_1'
		dw_sort.dataobject 	= 'd_pdt_02650_1'
		dw_print.dataobject 	= 'd_pdt_02650_1_p'	
		dw_list.title = '품목기준'	
	Case 	'공정기준'
		dw_ip.dataobject 	= 'd_pdt_02630_5'
		dw_list.dataobject 	= 'd_pdt_02630_6'
		dw_sort.dataobject 	= 'd_pdt_02630_6'
		dw_print.dataobject 	= 'd_pdt_02630_6_p'
		dw_list.title = '공정기준'
End Choose

dw_ip.settransobject(sqlca)
dw_list.settransobject(sqlca)
dw_sort.settransobject(sqlca)
dw_print.settransobject(sqlca)
dw_ip.insertrow(0)

dw_print.setredraw(true)
dw_ip.setredraw(true)
dw_ip.setfocus()

//p_print.Enabled =False
//p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

//p_preview.enabled = False
//p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'

end event

type st_1 from statictext within w_pdt_02630
integer x = 119
integer y = 76
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
string text = "출력구분"
boolean focusrectangle = false
end type

type dw_jidat from datawindow within w_pdt_02630
integer x = 105
integer y = 148
integer width = 997
integer height = 80
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_pdt_02630_date"
boolean border = false
boolean livescroll = true
end type

type dw_sort from u_d_popup_sort within w_pdt_02630
integer x = 37
integer y = 284
integer width = 3488
integer height = 1964
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_pdt_02630_1"
boolean border = false
end type

type rr_1 from roundrectangle within w_pdt_02630
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 96
integer y = 40
integer width = 1047
integer height = 188
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pdt_02630
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 87
integer y = 260
integer width = 4480
integer height = 2060
integer cornerheight = 40
integer cornerwidth = 55
end type

