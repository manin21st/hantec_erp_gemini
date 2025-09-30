$PBExportHeader$w_sort.srw
$PBExportComments$공통정렬 : Datawindow 정렬
forward
global type w_sort from window
end type
type dw_2 from datawindow within w_sort
end type
type dw_1 from datawindow within w_sort
end type
type st_4 from statictext within w_sort
end type
type st_3 from statictext within w_sort
end type
type shl_2 from statichyperlink within w_sort
end type
type shl_1 from statichyperlink within w_sort
end type
type st_2 from statictext within w_sort
end type
type st_1 from statictext within w_sort
end type
type ln_1 from line within w_sort
end type
end forward

global type w_sort from window
integer width = 2085
integer height = 1476
boolean titlebar = true
string title = "정렬 하세요."
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
string icon = "AppIcon!"
boolean center = true
dw_2 dw_2
dw_1 dw_1
st_4 st_4
st_3 st_3
shl_2 shl_2
shl_1 shl_1
st_2 st_2
st_1 st_1
ln_1 ln_1
end type
global w_sort w_sort

type variables
// determines if left mouse button is down for employees datawindow
boolean    ib_down

// determines if left mouse button is down for employee details datawindow
boolean   ib_detail_down

// determines if message to drag detail employee is displayed
boolean   ib_detail_message

// Test if any employees status has been changed.
boolean   ib_changed

datawindow dw_org
end variables

on w_sort.create
this.dw_2=create dw_2
this.dw_1=create dw_1
this.st_4=create st_4
this.st_3=create st_3
this.shl_2=create shl_2
this.shl_1=create shl_1
this.st_2=create st_2
this.st_1=create st_1
this.ln_1=create ln_1
this.Control[]={this.dw_2,&
this.dw_1,&
this.st_4,&
this.st_3,&
this.shl_2,&
this.shl_1,&
this.st_2,&
this.st_1,&
this.ln_1}
end on

on w_sort.destroy
destroy(this.dw_2)
destroy(this.dw_1)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.shl_2)
destroy(this.shl_1)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.ln_1)
end on

event open;dw_org = create datawindow
dw_org = message.Powerobjectparm

int		i_cnt, i_st_cnt, i = 0, i_row, i_find, xxx
string	s_1[], s_t, s_obj, s_s, s_sf, s_kjh
string	s_h_1[], s_sort, s_st[]


s_sort = dw_org.Describe("DataWindow.Table.Sort")
s_sort = s_sort + ","

s_obj = dw_org.describe("datawindow.objects")
s_obj = s_obj + "~t"


DO WHILE i = 0
	
	s_t   = mid(s_obj,1,pos(s_obj,"~t",1) -1)    // column value read
	s_obj = mid(s_obj,pos(s_obj,"~t",1) +1)
	
	s_s    = mid(s_sort,1,pos(s_sort,",",1) -1)  // sort setting value read
	s_sort = mid(s_sort,pos(s_sort,",",1) +1)
	
	if len(s_s) > 0 then
		i_st_cnt = i_st_cnt + 1
   	s_st[i_st_cnt] = s_s
	end if

	if len(s_t) > 0 then
		if mid(s_t,1,4) <> "obj_" then
			if pos(s_t,"_t") < 1 then 
				i_cnt = i_cnt + 1		
				s_1[i_cnt] = s_t			
				s_t = s_t + "_t" + ".text"
				//----------------------------------
				s_kjh = dw_org.describe(s_t)

				if mid(s_kjh,1,1) = '~r' then
					s_kjh = mid(s_kjh,2,len(s_kjh) - 1)
				end if 
				//"없애기 
				if pos(s_kjh,'"',1) > 0 then
			    	xxx = pos(s_kjh,'"',1)
					s_kjh = mid(s_kjh,1,xxx - 1) + mid(s_kjh,xxx + 1, len(s_kjh))
				end if
			
				if pos(s_kjh,'"',1) > 0 then
			    	xxx = pos(s_kjh,'"',1)
					s_kjh = mid(s_kjh,1,xxx - 1) + mid(s_kjh,xxx + 1, len(s_kjh))
				end if
			
				//~r 없애기..가운데..
				if pos(s_kjh,'~r',1) > 0 then
			    	xxx = pos(s_kjh,'~r',1)
					s_kjh = mid(s_kjh,1,xxx - 1) + mid(s_kjh,xxx + 2, len(s_kjh))
				end if
				
				if pos(s_kjh,'~r',1) > 0 then
			    	xxx = pos(s_kjh,'~r',1)
					s_kjh = mid(s_kjh,1,xxx - 1) + mid(s_kjh,xxx + 2, len(s_kjh))
				end if
				
				s_h_1[i_cnt] = s_kjh
				//----------------------------------
	  			//s_h_1[i_cnt] = dw_org.describe(s_t)						
		   end if	
		end if
	else
		i = 1
	end if

LOOP


i_row = UpperBound(s_1)
INT i_ii

FOR i=1 TO i_row
  	if Trim(s_h_1[i])	<> '!' then 
	    i_ii = dw_1.insertrow(0)
    	 dw_1.SetItem(i_ii,"a",s_1[i])
    	 dw_1.SetItem(i_ii,"a_t",s_h_1[i])	
	    dw_1.SetItem(i_ii,"a_num",i)		
   end if
NEXT


i_row = UpperBound(s_st)


for i = 1 to i_row
   if len(s_st[i]) > 0 then
		
		s_sf = "a = " + "~'" + trim(mid(s_st[i],1,len(s_st[i]) - 2)) + "~'" 
		i_find = dw_1.Find(s_sf, 1,dw_1.RowCount( ))

		if right(s_st[i],1) = "A" then
			dw_1.setitem(i_find,"a_check","Y")
		else
			dw_1.setitem(i_find,"a_check","N")
		end if		
		
      dw_1.RowsMove( i_find,i_find , primary!,dw_2, dw_2.rowcount() + 1, Primary!)	   
		
	end if
	
next

end event

event key;IF key = keyescape! THEN 
	shl_2.TriggerEvent("Clicked")
END IF

end event

type dw_2 from datawindow within w_sort
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
event ue_mousemove pbm_mousemove
integer x = 992
integer y = 316
integer width = 1061
integer height = 1048
integer taborder = 20
string title = "none"
string dataobject = "d_sort_target"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_lbuttondown;ib_detail_down = true
end event

event ue_lbuttonup;ib_detail_down = false
end event

event ue_mousemove;//////////////////////////////////////////////////////////////////////
// if left mouse button is down and user moves the mouse and 
// the pointer is over the employee picture, initiate drag mode.
//////////////////////////////////////////////////////////////////////

string	ls_emp_fname, &
			ls_emp_lname

// if message is not already being displayed, display it
if not ib_detail_message then
		ib_detail_message = true
end if
if ib_detail_down then
	this.Drag (begin!)
end if
if ib_detail_message then
	ib_detail_message = false
end if

end event

event clicked;if row > 0 then
   this.SelectRow(0,False)
   this.SelectRow(row,True)
   this.setfocus()
end if
end event

event doubleclicked;if row > 0 then
	This.RowsMove(row, row, Primary!, dw_1, This.object.a_num[row], Primary!)
end if

dw_1.SetSort("a_num")
dw_1.Sort()

end event

event dragdrop;DragObject	ldo_control
int			li_row

ldo_control = DraggedObject()

if ldo_control = dw_1 then
	li_row = dw_1.GetRow()
	if li_row > 0 then
      dw_1.RowsMove(li_row,li_row, Primary!,dw_2, dw_2.rowcount() + 1, Primary!)		
	end if
end if


end event

event losefocus;this.SelectRow(0,False)
end event

event rowfocuschanged;if currentrow > 0 then 
	selectrow(0,false)
	selectrow(1,true)
end if

end event

type dw_1 from datawindow within w_sort
event ue_buttondown pbm_lbuttondown
event ue_buttonup pbm_lbuttonup
event ue_mousemove pbm_mousemove
integer x = 18
integer y = 316
integer width = 965
integer height = 1048
integer taborder = 10
string title = "none"
string dataobject = "d_sort_source"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_buttondown;ib_down = true
end event

event ue_buttonup;ib_down = false

end event

event ue_mousemove;if ib_down then
	this.Drag (begin!)
end if

end event

event clicked;if row > 0 then
   this.SelectRow(0,False)
   this.SelectRow(row,True)
   this.setfocus()
end if

end event

event dragdrop;DragObject	ldo_control
int			li_row

ldo_control = DraggedObject()

if ldo_control = dw_2 then
	li_row = dw_2.GetRow()
	if li_row > 0 then
		dw_2.RowsMove(li_row,li_row, Primary!,dw_1, &
         		dw_2.GetItemNumber(li_row,"a_num"), Primary!)		
	end if
end if

end event

event losefocus;this.SelectRow(0,False)

end event

event rowfocuschanged;if currentrow > 0 then 
	selectrow(0,false)
	selectrow(currentrow,true)
end if

end event

event doubleclicked;if row > 0 then
	This.RowsMove(row, row, Primary!, dw_2, dw_2.RowCount()+1, Primary!)		
end if

end event

type st_4 from statictext within w_sort
integer x = 992
integer y = 224
integer width = 475
integer height = 68
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 32106727
string text = "정렬순서"
boolean focusrectangle = false
end type

type st_3 from statictext within w_sort
integer x = 18
integer y = 224
integer width = 457
integer height = 68
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 32106727
string text = "항목"
boolean focusrectangle = false
end type

type shl_2 from statichyperlink within w_sort
integer x = 1765
integer y = 92
integer width = 283
integer height = 68
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 255
long backcolor = 32106727
string text = "취소"
alignment alignment = center!
boolean focusrectangle = false
end type

event clicked;close(parent)

end event

type shl_1 from statichyperlink within w_sort
integer x = 1472
integer y = 92
integer width = 251
integer height = 68
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 134217856
long backcolor = 32106727
string text = "확인"
alignment alignment = center!
boolean focusrectangle = false
end type

event clicked;if dw_2.RowCount() < 1 then 
   dw_org.SetSort("")
   dw_org.sort()
   close(parent)	
	return
end if
	

long l_row
string s_col,s_check

FOR l_row=1 TO dw_2.Rowcount()
	s_check = dw_2.GetItemstring(l_row,"a_check")	
	IF s_check = "Y" then 
	   s_col   = s_col + dw_2.GetItemstring(l_row,"a") + " " + "A" + ","
	else
	   s_col   = s_col + dw_2.GetItemstring(l_row,"a") + " " + "D" + ","
	end if
NEXT

s_col = mid(s_col,1,len(s_col) - 1)

dw_org.SetSort(s_col)
dw_org.sort()
close(parent)

end event

type st_2 from statictext within w_sort
integer x = 18
integer y = 92
integer width = 896
integer height = 68
integer textsize = -11
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 32106727
string text = "오른편으로 들여 놓으십시오!"
boolean focusrectangle = false
end type

type st_1 from statictext within w_sort
integer x = 18
integer y = 16
integer width = 795
integer height = 68
integer textsize = -11
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 32106727
string text = "원하는 항목을 클릭하여"
boolean focusrectangle = false
end type

type ln_1 from line within w_sort
long linecolor = 16777215
integer linethickness = 8
integer beginx = -59
integer beginy = 192
integer endx = 2386
integer endy = 192
end type

