$PBExportHeader$w_report_sort.srw
$PBExportComments$REPORT SORT
forward
global type w_report_sort from window
end type
type cb_2 from commandbutton within w_report_sort
end type
type dw_2 from datawindow within w_report_sort
end type
type dw_1 from datawindow within w_report_sort
end type
type cb_1 from commandbutton within w_report_sort
end type
end forward

global type w_report_sort from window
integer x = 457
integer y = 348
integer width = 2213
integer height = 1024
boolean titlebar = true
string title = "정렬"
boolean controlmenu = true
boolean minbox = true
windowtype windowtype = popup!
long backcolor = 79741120
cb_2 cb_2
dw_2 dw_2
dw_1 dw_1
cb_1 cb_1
end type
global w_report_sort w_report_sort

type variables
datawindow dwname
datawindow  dw_source, dw_target

int            drag_start_row, drag_end_row, oldrow
String       drag_start_col
boolean    ib_down
end variables

forward prototypes
public function integer wf_copy_to_target (integer srow, integer erow)
end prototypes

public function integer wf_copy_to_target (integer srow, integer erow);If sRow <= 0 Then Return 0

eRow = dw_target.InsertRow(sRow)

dw_target.SetItem(eRow, 'col',  dw_source.GetItemString(sRow, 'col'))
dw_target.SetItem(eRow, 'name', dw_source.GetItemString(sRow, 'name'))

dw_source.RowsDiscard(sRow, sRow, Primary!)

Return eRow
end function

on w_report_sort.create
this.cb_2=create cb_2
this.dw_2=create dw_2
this.dw_1=create dw_1
this.cb_1=create cb_1
this.Control[]={this.cb_2,&
this.dw_2,&
this.dw_1,&
this.cb_1}
end on

on w_report_sort.destroy
destroy(this.cb_2)
destroy(this.dw_2)
destroy(this.dw_1)
destroy(this.cb_1)
end on

event open;Long rowcnt, ix, nrow
String sCol, sName

dwname = Message.powerobjectparm

rowcnt = Long(dwname.Describe("DataWindow.Column.Count"))

For ix = 1 To rowcnt
	nRow = dw_1.InsertRow(0)
	
	sCol  =  Trim(dwname.Describe("#"+string(ix)+".name"))
	sName =  Trim(dwname.Describe(sCol+'_t.text'))
	If IsNull(sName) Or sName = '!' Then
		sName = Trim(dwname.Describe("Lookupdisplay(" + sCol+"_t.Expression)"))
		If IsNull(sName) Or sName = '!' Then
			sName = sCol
		End If
	End If
	
	dw_1.SetItem(nRow, 'col',  sCol)
	dw_1.SetItem(nRow, 'name', sName)
Next

f_window_center_response(this)
end event

type cb_2 from commandbutton within w_report_sort
integer x = 1595
integer y = 820
integer width = 274
integer height = 108
integer taborder = 30
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "정렬(&S)"
end type

event clicked;String sSort = ''
Long   ix

If dw_2.RowCount() <= 0 Then Return

For ix = 1 To dw_2.RowCount()
	If dw_2.GetItemString(ix, 'st') = 'A' Then
		sSort += ( Trim(dw_2.GetItemString(ix, 'col')) + ' A, ')
	Else
		sSort += ( Trim(dw_2.GetItemString(ix, 'col')) + ' D, ')
	End If
Next

sSort = Left(sSort,Len(sSort) -2 )

dwname.SetSort(sSort)
dwname.Sort()
dwname.GroupCalc()
end event

type dw_2 from datawindow within w_report_sort
event ue_mousemove pbm_mousemove
event ue_bup pbm_lbuttonup
event ue_bdown pbm_lbuttondown
integer x = 974
integer width = 1211
integer height = 796
integer taborder = 20
string dragicon = "Rectangle!"
string dataobject = "d_report_sort2"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_mousemove;/* --------------------------------------------------------------- */
/* 마우스를 누른체 움직일 경우 drag                                */
/* --------------------------------------------------------------- */
string  ls_col,ls_colnm

int		li_row,li_pos

ls_col = this.GetObjectAtPointer() 

if Len (ls_col) > 0 then
	drag_start_row = 0
	li_pos = Pos (ls_col, '~t')

   /* row와 column name을 구분 */ 
	if li_pos > 0 then
		li_row = Integer (Right (ls_col, Len (ls_col) - li_pos))
		ls_colnm = Trim(Left(ls_col,li_pos - 1))
	Else
		Return
	end if

   If li_row <= 0 Then Return
	
	/* 마으스버튼이 눌릴경우 ue_bdown */
	if ib_down then
		this.Drag (begin!)
		
		dw_source = this
      drag_start_row = li_row
		drag_start_col = ls_colnm
	end if

end if
end event

event ue_bup;ib_down = false

This.Drag(End!)
end event

event ue_bdown;string  ls_col,ls_colnm
int		li_row,li_pos

ls_col = this.GetObjectAtPointer() 

if Len (ls_col) > 0 then
	drag_start_row = 0
	li_pos = Pos (ls_col, '~t')

	if li_pos > 0 then
		li_row = Integer (Right (ls_col, Len (ls_col) - li_pos))
		ls_colnm = Trim(Left(ls_col,li_pos - 1))
	Else
		Return
	end if

   If li_row > 0 Then
		If Right(ls_colnm,2) <> '_t' Then
			SetRow(li_row)
	   	ib_down = true
		End If
	End If
End if
end event

event dragdrop;dw_target    = this
drag_end_row = row
ib_down      = true

If dw_target = dw_source Then Return

Post wf_copy_to_target(drag_start_row, drag_end_row)
end event

type dw_1 from datawindow within w_report_sort
event ue_mousemove pbm_mousemove
event ue_bup pbm_lbuttonup
event ue_bdown pbm_lbuttondown
integer width = 951
integer height = 796
integer taborder = 10
string dragicon = "Rectangle!"
string dataobject = "d_report_sort1"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_mousemove;/* --------------------------------------------------------------- */
/* 마우스를 누른체 움직일 경우 drag                                */
/* --------------------------------------------------------------- */
string  ls_col,ls_colnm

int		li_row,li_pos

ls_col = this.GetObjectAtPointer() 

if Len (ls_col) > 0 then
	drag_start_row = 0
	li_pos = Pos (ls_col, '~t')

   /* row와 column name을 구분 */ 
	if li_pos > 0 then
		li_row = Integer (Right (ls_col, Len (ls_col) - li_pos))
		ls_colnm = Trim(Left(ls_col,li_pos - 1))
	Else
		Return
	end if

   If li_row <= 0 Then Return
	
	/* 마으스버튼이 눌릴경우 ue_bdown */
	if ib_down then
		this.Drag (begin!)
		
		dw_source = this
      drag_start_row = li_row
		drag_start_col = ls_colnm
	end if

end if


end event

event ue_bup;ib_down = false

This.Drag(End!)
end event

event ue_bdown;string  ls_col,ls_colnm
int		li_row,li_pos

ls_col = this.GetObjectAtPointer() 

if Len (ls_col) > 0 then
	drag_start_row = 0
	li_pos = Pos (ls_col, '~t')

	if li_pos > 0 then
		li_row = Integer (Right (ls_col, Len (ls_col) - li_pos))
		ls_colnm = Trim(Left(ls_col,li_pos - 1))
	Else
		Return
	end if

   If li_row > 0 Then
		If Right(ls_colnm,2) <> '_t' Then
			SetRow(li_row)
	   	ib_down = true
		End If
	End If
End if
end event

event dragdrop;dw_target    = this
drag_end_row = row
ib_down      = true

If dw_target = dw_source Then Return

Post wf_copy_to_target(drag_start_row, drag_end_row)
end event

type cb_1 from commandbutton within w_report_sort
integer x = 1893
integer y = 820
integer width = 274
integer height = 108
integer taborder = 30
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "종료(&X)"
end type

event clicked;CLOSE(PARENT)
end event

