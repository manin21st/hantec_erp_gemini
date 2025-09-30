$PBExportHeader$w_flow_preview_option.srw
$PBExportComments$미리보기 옵션
forward
global type w_flow_preview_option from window
end type
type pb_2 from picturebutton within w_flow_preview_option
end type
type pb_1 from picturebutton within w_flow_preview_option
end type
type dw_po from datawindow within w_flow_preview_option
end type
type gb_1 from groupbox within w_flow_preview_option
end type
end forward

global type w_flow_preview_option from window
integer width = 2158
integer height = 1368
boolean titlebar = true
string title = "인쇄설정"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
pb_2 pb_2
pb_1 pb_1
dw_po dw_po
gb_1 gb_1
end type
global w_flow_preview_option w_flow_preview_option

type variables
w_print_preview	idw_list
end variables

forward prototypes
public subroutine wf_pagecalc ()
public subroutine wf_modify ()
end prototypes

public subroutine wf_pagecalc ();if idw_list.dw_list.rowcount() > 0 then
	dw_po.Object.totalpage[1] = Long(idw_list.dw_list.Describe("evaluate('pagecount()', 1)"))
else	
   dw_po.Object.totalpage[1] = 0
end if

end subroutine

public subroutine wf_modify ();long	ll_row

dw_po.accepttext()

idw_list.dw_list.object.datawindow.print.copies = trim(dw_po.object.copies[1])
idw_list.dw_list.object.datawindow.print.color= dw_po.object.color[1]
idw_list.dw_list.object.datawindow.print.page.rangeinclude = "0"
idw_list.dw_list.object.datawindow.print.page.range = ''

choose case dw_po.object.rangeinclude[1]
	
   case "0" //전체 
     idw_list.ddlb_range.text='전체' 
		  
	case "1" //짝수쪽 
     
	  idw_list.ddlb_range.text='짝수쪽' 
 	
   case "2" //홀수쪽  
     idw_list.ddlb_range.text='홀수쪽' 
  
   case "3" //현재
//		ll_row = long(idw_list.dw_list.describe("datawindow.firstrowonpage"))
//		idw_list.dw_list.object.datawindow.print.page.range = idw_list.dw_list.describe("evaluate('page()', " + idw_list.dw_list.object.datawindow.firstrowonpage + ")")
	   idw_list.ddlb_range.text='현재' 

   case "4" //부분
		idw_list.dw_list.object.datawindow.print.page.range = trim(dw_po.object.range[1])
	   idw_list.ddlb_range.text=trim(dw_po.object.range[1]) 		
  
   case else
		idw_list.dw_list.object.datawindow.print.page.rangeinclude = dw_po.object.rangeinclude[1]
		idw_list.dw_list.object.datawindow.print.page.range = ''
end choose


end subroutine

on w_flow_preview_option.create
this.pb_2=create pb_2
this.pb_1=create pb_1
this.dw_po=create dw_po
this.gb_1=create gb_1
this.Control[]={this.pb_2,&
this.pb_1,&
this.dw_po,&
this.gb_1}
end on

on w_flow_preview_option.destroy
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.dw_po)
destroy(this.gb_1)
end on

event open;f_window_center(This)

idw_list = message.powerobjectparm
//idw_list.dw_po.sharedata(dw_po)

dw_po.insertrow(0)

dw_po.object.orient[1]  = string(idw_list.dw_list.object.datawindow.print.orientation)
dw_po.object.papersize[1] = idw_list.dw_list.object.datawindow.print.paper.size
dw_po.object.mtop[1]    = long(idw_list.dw_list.object.datawindow.print.margin.top)
dw_po.object.mbottom[1] = long(idw_list.dw_list.object.datawindow.print.margin.bottom)
dw_po.object.mleft[1]   = long(idw_list.dw_list.object.datawindow.print.margin.left)
dw_po.object.mright[1]  = long(idw_list.dw_list.object.datawindow.print.margin.right)
dw_po.object.zoom[1]    = string(idw_list.dw_list.object.datawindow.print.preview.zoom) //화면배율
dw_po.object.scale[1]   = string(idw_list.dw_list.object.datawindow.zoom) 				  //출력배율
//dw_po.object.outputdate[1] = date(data)
dw_po.object.outputdate[1] = today()

if idw_list.dw_list.rowcount() > 0 then
	dw_po.object.totalpage[1] = long(idw_list.dw_list.describe("evaluate('pagecount()', 1)"))
else	
   dw_po.object.totalpage[1] = 0
end if
end event

event close;DESTROY nvo_PowerPrn
end event

type pb_2 from picturebutton within w_flow_preview_option
integer x = 1047
integer y = 1076
integer width = 320
integer height = 120
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "c:\erpman\image\6424_취소.jpg"
alignment htextalign = left!
end type

event clicked;close(parent)

end event

type pb_1 from picturebutton within w_flow_preview_option
integer x = 727
integer y = 1076
integer width = 320
integer height = 120
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean originalsize = true
string picturename = "c:\erpman\image\6424_확인.jpg"
alignment htextalign = left!
end type

event clicked;wf_modify()
close(parent)
end event

type dw_po from datawindow within w_flow_preview_option
integer x = 69
integer y = 60
integer width = 2002
integer height = 932
integer taborder = 10
string title = "none"
string dataobject = "dt_flow_printoption"
boolean border = false
boolean livescroll = true
end type

event itemchanged;choose case dwo.name
	case "zoom"
		idw_list.dw_list.object.datawindow.print.preview.zoom = data
	case "scale"
		if data <> '0' then
			idw_list.dw_list.object.datawindow.zoom = data
		else
			integer li_print_rate
			u_dw_syntax luo_dw_syntax
			li_print_rate = luo_dw_syntax.uf_calc_print_rate(idw_list.dw_list)
			idw_list.dw_list.object.datawindow.zoom = li_print_rate
		end if
	case "preview"
		if idw_list.dw_list.rowcount() > 0 then
			setpointer(hourglass!)
			idw_list.dw_list.setredraw(false)
			idw_list.dw_list.object.datawindow.print.preview = data
			idw_list.dw_list.setredraw(true)
			wf_pagecalc()
			setpointer(arrow!)
		end if
	case "rulers"
		if idw_list.dw_list.rowcount() > 0 then
			setpointer(hourglass!)
			idw_list.dw_list.setredraw(false)
			idw_list.dw_list.object.datawindow.print.preview.rulers = data
			idw_list.dw_list.setredraw(true)
			setpointer(arrow!)
		end if
	case "mleft"
		idw_list.dw_list.object.datawindow.print.margin.left = data
		//idw_list.dw_list.event ue_margine()
	case "mright"
		idw_list.dw_list.object.datawindow.print.margin.right = data
		//iwm_report.dw_1.event ue_margine()
	case "mtop"
		idw_list.dw_list.object.datawindow.print.margin.top = data
		//iwm_report.dw_1.event ue_margine()
	case "mbottom"
		idw_list.dw_list.object.datawindow.print.margin.bottom = data
		//iwm_report.dw_1.event ue_margine()
	case "orient"
		idw_list.dw_list.object.datawindow.print.orientation = data
	case "papersize"
		idw_list.dw_list.object.datawindow.print.paper.size = data
	case "rangeinclude"
		if long(data) <> 4  then object.range[1] = ''
	case "range"
		if trim(data) <> '' then object.rangeinclude[1] = '4'
	case "outputdate"
		//gv_env.outputdate = date(data)
        dw_po.object.outputdate[1] = today()  
end choose

end event

event itemfocuschanged;choose case lower(dwo.name)
	case 'range'
		post setitem(1,'rangeinclude', '4')
end choose

end event

type gb_1 from groupbox within w_flow_preview_option
integer x = 718
integer y = 1044
integer width = 658
integer height = 160
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = styleraised!
end type

