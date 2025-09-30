$PBExportHeader$w_preview_option2.srw
$PBExportComments$액셀 다운로드 - 송
forward
global type w_preview_option2 from window
end type
type cb_3 from commandbutton within w_preview_option2
end type
type cb_2 from commandbutton within w_preview_option2
end type
type dw_2 from datawindow within w_preview_option2
end type
type cb_1 from commandbutton within w_preview_option2
end type
type cbx_1 from checkbox within w_preview_option2
end type
type dw_1 from datawindow within w_preview_option2
end type
type gb_1 from groupbox within w_preview_option2
end type
end forward

global type w_preview_option2 from window
integer width = 2555
integer height = 1564
boolean titlebar = true
string title = "액셀 다운로드"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
cb_3 cb_3
cb_2 cb_2
dw_2 dw_2
cb_1 cb_1
cbx_1 cbx_1
dw_1 dw_1
gb_1 gb_1
end type
global w_preview_option2 w_preview_option2

type prototypes
FUNCTION UInt FindWindowA( Ulong className, string winName ) LIBRARY "user32.dll" alias for "FindWindowA;Ansi" 
FUNCTION UInt SetFocus( int winHand ) LIBRARY "user32.dll" 
FUNCTION boolean DeleteFileA(ref string filename) LIBRARY "Kernel32.dll" alias for "DeleteFileA;Ansi" 

end prototypes

type variables
long					ilrow, ilrow2, ilclr
string				iscol
w_print_preview	iwin
end variables

forward prototypes
public subroutine wf_distribute_objects (datawindow adwfr, ref datawindow adwto)
public function integer wf_down_excel ()
public subroutine wf_collect_objects (datawindow adwfr, ref datawindow adwto)
public subroutine wf_excel_export (datawindow ar_dw)
public function integer wf_down_excel2 (datawindow adwsrc, datawindow adwref)
public subroutine wf_filtering_objects (datawindow adwfr, ref datawindow adwto, string aband)
end prototypes

public subroutine wf_distribute_objects (datawindow adwfr, ref datawindow adwto);//-----------------------------------------------------------------------------
//	object 를 정렬하고 그룹화 한다.
//-----------------------------------------------------------------------------
long		i=1, j, lrow
string	ls_objs

//adwto.setsort("ypos A, xpos A")
adwto.setsort("xpos A, ypos A")
adwto.sort()

//FOR lrow = 1 TO adwto.rowcount()
//	iypos  = integer(adwfr.Describe(scol+".y"))
//	ixpos  = integer(adwfr.Describe(scol+".x"))
//	iwidth = integer(adwfr.Describe(scol+".width"))
//	iheight= integer(adwfr.Describe(scol+".height"))


//messagebox('min xpos',adwfr.describe(

//DO WHILE TRUE
//	lrow = adwto.insertrow(0)
//	j = pos(ls_objs,"~t",i)
//	if j = 0 or isnull(j) then
//		adwto.setitem(lrow,'name',mid(ls_objs,i))
//		exit
//	else
//		adwto.setitem(lrow,'name',mid(ls_objs,i,j -i))
//	end if
//	i=j+1	
//LOOP
end subroutine

public function integer wf_down_excel ();/////////////////////////////////////////////////////////////////////////
// 1. DATAWINDOW CREATE
long		lrow, lrowcnt
string	ERRORS, sql_syntax, sql_columns
string	presentation_str, dwsyntax_str 
string	sdtype

lrowcnt = dw_1.rowcount()
if lrowcnt < 1 then
	messagebox('확인','액셀 저장할 정보가 없습니다')
	return 0
end if

setpointer(hourglass!)

FOR lrow = 1 TO lrowcnt
	sdtype= dw_1.getitemstring(lrow,'dtype')
	if pos(sdtype,'char') > 0 then
		sql_columns = sql_columns + "'" + space(200) + "', "
	elseif pos(sdtype,'string') > 0 then
		sql_columns = sql_columns + "'" + space(200) + "', "
	else
		sql_columns = sql_columns + string(00000000000.000) + ", "
	end if	
NEXT

sql_columns = left(sql_columns,len(sql_columns)-2)

sql_syntax = "SELECT "+sql_columns+" FROM DUAL "

presentation_str = "style(type=grid)"

dwsyntax_str = SQLCA.SyntaxFromSQL(sql_syntax,presentation_str,ERRORS)
IF Len(ERRORS) > 0 THEN
	MessageBox("Caution","SyntaxFromSQL caused these errors: "+ERRORS)
	RETURN -1
END IF

dw_2.Create(dwsyntax_str,ERRORS)
IF Len(ERRORS) > 0 THEN
	MessageBox("Caution","Create cause these errors: "+ERRORS)
	RETURN -1
END IF


/////////////////////////////////////////////////////////////////////////
// 2. DATAWINDOW SETITEM
long		lrow2, lrowcnt2, lins
string	scol, stype, svalue
decimal{3}	dvalue

lrowcnt2 = iwin.dw_list.rowcount()
FOR lrow2 = 1 TO lrowcnt2
	
	lins = dw_2.insertrow(0)
	
	FOR lrow = 1 TO lrowcnt
		scol  = dw_1.getitemstring(lrow,'name')
		sdtype= dw_1.getitemstring(lrow,'dtype')
		stype = dw_1.getitemstring(lrow,'type')
		
		if stype = 'column' then
			if pos(sdtype,'char') > 0 then
				svalue = iwin.dw_list.describe("evaluate('lookupdisplay("+scol+")', "+string(lrow2)+")")
				dw_2.setitem(lins,lrow,svalue)
			elseif pos(sdtype,'string') > 0 then
				svalue = iwin.dw_list.describe("evaluate('lookupdisplay("+scol+")', "+string(lrow2)+")")
				dw_2.setitem(lins,lrow,svalue)
			else
				dvalue = iwin.dw_list.getitemnumber(lrow2,scol)
				dw_2.setitem(lins,lrow,dvalue)
			end if
		else
			if pos(sdtype,'char') > 0 then
				svalue = iwin.dw_list.getitemstring(lrow2,scol)
				dw_2.setitem(lins,lrow,svalue)
			elseif pos(sdtype,'string') > 0 then
				svalue = iwin.dw_list.getitemstring(lrow2,scol)
				dw_2.setitem(lins,lrow,svalue)
			else
				dvalue = iwin.dw_list.getitemnumber(lrow2,scol)
				dw_2.setitem(lins,lrow,dvalue)
			end if
		end if
		
	NEXT	
NEXT

dw_2.insertrow(1)

/////////////////////////////////////////////////////////////////////////
// 3. EXCEL SAVE
integer	li_rc
string	ls_filepath, ls_filename
boolean	lb_fileexist

li_rc = GetFileSaveName("저장할 파일명을 선택하세요." , ls_filepath , &
											  ls_filename , "XLS" , "Excel Files (*.xls),*.xls")												
IF li_rc = 1 THEN	
	IF lb_fileexist THEN
		li_rc = MessageBox("파일저장" , ls_filepath + " 파일이 이미 존재합니다.~r~n" + &
												 "기존의 파일을 덮어쓰시겠습니까?" , Question! , YesNo! , 1)
		IF li_rc = 2 THEN 
			RETURN 0
		END IF
	END IF

	setpointer(HourGlass!)
 	If dw_2.SaveAs(ls_filepath,Excel!,FALSE) <> 1 Then
		return -1
		//MessageBox('확인','엑셀파일 저장이 완료 되었습니다.')
	End If

END IF


/////////////////////////////////////////////////////////////////////////
// 4. Head Setting 
// OLE 연결 부분 
//uo_xlobject uo_xl
//
//setpointer(HourGlass!)
//
//uo_xl = create uo_xlobject
//		
////엑셀과 연결
//uo_xl.uf_excel_connect(ls_filepath, false , 3) // 1-normal, 2-min, 3-max 
//
//FOR lrow = 1 TO lrowcnt
//	svalue = trim(dw_1.getitemstring(lrow,'title'))
//	if isnull(svalue) or svalue = '' then continue
//	
//	uo_xl.uf_set_format(1,lrow,"Text")
//	uo_xl.uf_setvalue(1,lrow,svalue)
//
//NEXT
//
//uo_xl.uf_excel_Disconnect() 
//Destroy uo_xl

//MessageBox('확인','엑셀파일 저장이 완료 되었습니다.')

return 1
end function

public subroutine wf_collect_objects (datawindow adwfr, ref datawindow adwto);//-----------------------------------------------------------------------------
//	object 목록을 가져온다.
//-----------------------------------------------------------------------------
long		i=1, j, lrow
string	ls_objs

ls_objs = iwin.dw_list.describe("datawindow.objects")


DO WHILE TRUE
	lrow = adwto.insertrow(0)
	j = pos(ls_objs,"~t",i)
	if j = 0 or isnull(j) then
		adwto.setitem(lrow,'name',mid(ls_objs,i))
		exit
	else
		adwto.setitem(lrow,'name',mid(ls_objs,i,j -i))
	end if
	i=j+1	
LOOP
end subroutine

public subroutine wf_excel_export (datawindow ar_dw);Datawindow ldw

ldw = ar_dw

//변수 선언 
int object_count, object_index, object_max 
string objects, object_name, object_list[], object_select, object_band, object_type 
string detail_object_spec, detail_objects[], detail_object_labels, s_header, header_text[] 
string s_trailer1, s_trailer1_object[], s_footer, s_footer_object[], s_footer_data 
boolean object_visible, b_detail = false, b_trailer1= false, b_summury = false, b_footer = false 
int i_trailer1_count = 0, i_detail_count = 0, i_footer_count = 0 


//데이터윈도우의 모든 오브젝트를 읽어온다. 
objects = ldw.describe("Datawindow.Objects" ) 

int i_pos, i, i_target, j, i_target_row, i_row = 1 

object_max = 1 
i_pos = 1 

//오브젝트들을 탭을 구분으로 하나씩 분리해 저장한다. 
do while(true) 
i_target = pos(objects, '~t', i_pos) 
if i_target = 0 then 
object_list[object_max] = mid(objects, i_pos, len(objects)) 
exit 
end if 
object_list[object_max] = mid(objects, i_pos, i_target - i_pos) 
i_pos = i_target + 1 
object_max++ 
loop 

//각 오브젝트들이 속해 있는 밴드와 타입, visible여부를 알아내어서 
//오브젝트의 갯수와 각 변수들에 저장을 한다. 
for object_index = 1 to object_max 
object_name = trim(object_list[object_index]) 
object_band = upper(ldw.describe( object_name + ".band" )) 
object_type = upper(ldw.describe( object_name + ".type" )) 
//유선이가 막음object_visible = ldw.describe( object_name + ".visible" ) = "1" 

object_visible = ldw.describe( object_name + "_t.visible" ) <> '!' 

if object_visible then //보이는 오브젝트만 처리 
choose case object_band 
case "TRAILER.1" //그룹밴드 
b_trailer1 = true 
if (object_type = "COLUMN" or object_type = "COMPUTE" or object_type = "TEXT") then 
i_trailer1_count++ 
s_trailer1_object[i_trailer1_count] = object_name 
end if 
case "DETAIL" //Detail 밴드 
if (object_type = "COLUMN" or object_type = "COMPUTE") then 
object_select = object_select + "/" + object_name 
i_detail_count++ 
end if 
case "FOOTER" //Footer 밴드 
b_footer = true 
if (object_type = "COLUMN" or object_type = "COMPUTE" or object_type = "TEXT") then 
i_footer_count++ 
s_footer_object[i_footer_count] = object_name 
end if 
end choose 
end if 
next 

i_target = 0 ; i_pos = 1 ; object_max = 1 

ldw.SetRedraw(false) 

//컬럼의 순서를 알아내기 위한 작업을 한다. 
object_select = '1/1' + object_select 
ldw.modify("datawindow.selected= '" + object_select + "'") 

object_select = ldw.describe("datawindow.selected") 
detail_object_spec = right(object_select, len(object_select) - 4) 
detail_object_spec = detail_object_spec + '/' 
ldw.modify(" datawindow.selected=''") 
ldw.SetRedraw(true) 

i_pos = 1 
object_max = 1 

//각 컬럼의 이름을 배치된 순서대로 다시 저장한다. 
do while(true) 
i_target = pos(detail_object_spec, '/', i_pos) 
if i_target = 0 then 
detail_objects[object_max] = mid(detail_object_spec,i_pos, len(detail_object_spec)) 
exit 
end if 
detail_objects[object_max] = mid(detail_object_spec,i_pos, i_target - i_pos) 
i_pos = i_target + 1 
object_max++ 
loop 

//int initlen 
string ls_temp 
integer li_pos 

//헤드에 있는 텍스트들의 text값을 저장한다. 
for object_index = 1 to object_max 
object_name = detail_objects[object_index] 
if detail_object_labels <> '' then detail_object_labels = detail_object_labels + '~t' 

if ldw.describe( object_name + "_t.visible" ) <> '!' then 
//multiline edit의 ctrl+enter key value를 string에서 제거한다.---------start(2001.09.28) 
li_pos = POS(Trim(ldw.describe(object_name + "_t.text")),Char(double(13))) 
IF (li_pos > 0 ) THEN 
ls_temp = Trim(Replace(Trim(ldw.describe(object_name + "_t.text")), li_pos , 1, "")) 
detail_object_labels = detail_object_labels + ls_temp 
else 
detail_object_labels = detail_object_labels + ldw.describe(object_name + "_t.text") 
end if 
//multiline edit의 ctrl+enter key value를 string에서 제거한다.---------end(2001.09.28) 
else 
detail_object_labels = detail_object_labels + "?" 
end if 
next 
//요기까지 detail 밴드의 화면상에 보이는 컬럼들만 detail_objects에 담는다. 

detail_object_labels = detail_object_labels + "~r~n" 

//엑셀과 연결 시작 
oleobject export_object 
uint excel_handle, excel_state 
string excel_title 

export_object = create oleobject 

export_object.connecttonewobject("excel.application") 

excel_title = export_object.Application.Caption 

export_object.Application.Visible = True 
excel_handle = FindWindowA( 0, excel_title ) 
SetFocus( excel_handle ) 

//파일작성 
long row_count, start_row 
string data_buffer, s_select, filename_2_2, s_syn, s_trailer1_data 
int file_num, ii 

filename_2_2 = "c:\export.txt" 
start_row = 1 

row_count = ldw.rowcount() 
if row_count = 0 then Return 

if fileexists(filename_2_2) then 
DeleteFileA(filename_2_2) 
end if 

file_num = fileopen(filename_2_2, streammode!, write!, lockreadwrite!, append!) 

//각 로우별로 데이터를 읽어서 파일에 기록한다. 
for start_row = 1 to row_count 
s_select = string(start_row) + "/" + string(start_row) + "/" +detail_object_spec 
ldw.modify(" Datawindow.selected = '" + s_select + "'") 
data_buffer = ldw.describe("datawindow.selected.data") + "~r~n" 
if start_row = 1 then data_buffer = detail_object_labels + data_buffer 
if b_trailer1 then //그룹이 존재한다면 
i_target_row = ldw.FindGroupChange(start_row, 1) - 1 
if i_target_row = start_row then 
for i = 1 to i_trailer1_count 
if upper(ldw.describe( s_trailer1_object[i] + ".type" )) = "COMPUTE" then 
s_syn = ldw.describe(s_trailer1_object[i] + ".expression") 
s_syn = ldw.Describe("Evaluate('" + s_syn + "'," + string(start_row) + ")") 
if i = 1 then 
for ii = 1 to i_detail_count - i_trailer1_count - 1 
s_trailer1_data = s_trailer1_data + '~t' 
next 
end if 
s_trailer1_data = s_trailer1_data + '~t' + s_syn 
elseif upper(ldw.describe( s_trailer1_object[i] + ".type" )) = "COLUMN" then 
s_syn = ldw.Describe("Evaluate('LookUpDisplay(" + s_trailer1_object[i] + ") '," + & 
string(start_row) + ")") 
if i = 1 then 
for ii = 1 to i_detail_count - i_trailer1_count - 1 
s_trailer1_data = s_trailer1_data + '~t' 
next 
end if 
s_trailer1_data = s_trailer1_data + '~t' + s_syn 
elseif upper(ldw.describe( s_trailer1_object[i] + ".type" )) = "TEXT" then 
s_syn = ldw.Describe(s_trailer1_object[i] + ".text") 
if i = 1 then 
for ii = 1 to i_detail_count - i_trailer1_count - 1 
s_trailer1_data = s_trailer1_data + '~t' 
next 
end if 
s_trailer1_data = s_trailer1_data + '~t' + s_syn 
end if 
next 
data_buffer = data_buffer + "~r~n" + s_trailer1_data + "~r~n" 
end if 
end if 
filewrite(file_num, data_buffer) 
setnull(data_buffer) 
s_trailer1_data = '' 
next 

//Footer 밴드를 마지막으로 파일에 덧붙힌다. 
if b_footer then 
for i = 1 to i_footer_count 
if upper(ldw.describe( s_footer_object[i] + ".type" )) = "COMPUTE" then 
s_syn = ldw.describe(s_footer_object[i] + ".expression") 
s_syn = ldw.Describe("Evaluate('" + s_syn + "'," + string(row_count) + ")") 
if i = 1 then 
for ii = 1 to i_detail_count - i_footer_count - 1 
s_footer_data = s_footer_data + '~t' 
next 
end if 
s_footer_data = s_footer_data + '~t' + s_syn 
elseif upper(ldw.describe( s_footer_object[i] + ".type" )) = "COLUMN" then 
s_syn = ldw.Describe("Evaluate('LookUpDisplay(" + s_footer_object[i] + ") '," + & 
string(row_count) + ")") 
if i = 1 then 
for ii = 1 to i_detail_count - i_footer_count - 1 
s_footer_data = s_footer_data + '~t' 
next 
end if 
s_footer_data = s_footer_data + '~t' + s_syn 
elseif upper(ldw.describe( s_footer_object[i] + ".type" )) = "TEXT" then 
s_syn = ldw.Describe(s_footer_object[i] + ".text") 
if i = 1 then 
for ii = 1 to i_detail_count - i_footer_count - 1 
s_footer_data = s_footer_data + '~t' 
next 
end if 
s_footer_data = s_footer_data + '~t' + s_syn 
end if 
next 
data_buffer = "~r~n" + s_footer_data 
filewrite(file_num, data_buffer) 
end if 

fileclose(file_num) 

export_object.statusbar = "Importing data...." 
export_object.workbooks.opentext(filename_2_2) 
export_object.windows("export.txt").caption = "Export Workbook" 

//엑셀파일의 포맷을 실시한다. 

//자동 칸맞춤을 적용한다. 
export_object.Worksheets[1].Columns.AutoFit 

//헤드 줄은 bold로 지정한다. 
export_object.rows("1:1").select 
export_object.selection.font.bold = true 
export_object.selection.font.italic = false 


export_object.statusbar = " Formatting labels....." 
export_object.rows("1:1").select 
//셀들의 줄맞춤을 실시한다. 
export_object.selection.wraptext = true 
export_object.selection.horizontalalignment = true 
export_object.selection.verticalalignment = true 

//미리보기에서 헤드셀들은 반복되어 나타나게 한다. 
export_object.Activesheet.PageSetup.PrintTitleRows = "$1:$1" 

export_object.DisConnectObject() //연결종료 
Destroy export_object //오브젝트 제거 

end subroutine

public function integer wf_down_excel2 (datawindow adwsrc, datawindow adwref);long		lrowcnt

lrowcnt = adwref.rowcount()
if lrowcnt < 1 then
	messagebox('확인','액셀로 저장할 컬럼이 없습니다')
	return 0
end if

setpointer(hourglass!)


/////////////////////////////////////////////////////////////////////////
// 1.데이타윈도우 값을 읽어서 파일에 저장
long		lrow, lrow2, lrowcnt2, lins
string	scol, stype, sdtype, scolspec, svalue
string	srowdata, sfilepath="c:\export.txt"
integer	ifnum
decimal{3}	dvalue

if fileexists(sfilepath) then 
	DeleteFileA(sfilepath) 
end if 

ifnum = fileopen(sfilepath, streammode!, write!, lockreadwrite!, append!)

FOR lrow = 1 TO lrowcnt
	svalue = adwref.getitemstring(lrow,'title')
	if isnull(svalue) or svalue = '' then svalue = ' '
	srowdata = srowdata + svalue + "~t"
NEXT
srowdata = left(srowdata,len(srowdata)-1)+"~r~n"
filewrite(ifnum,srowdata)
srowdata = ''

adwsrc.setredraw(false)

lrowcnt2 = adwsrc.rowcount()
FOR lrow2 = 1 TO lrowcnt2	
	FOR lrow = 1 TO lrowcnt
		scol  = adwref.getitemstring(lrow,'name')
		sdtype= adwref.getitemstring(lrow,'dtype')
		stype = adwref.getitemstring(lrow,'type')

		if stype = 'column' then
			if pos(sdtype,'char') > 0 then
				svalue = adwsrc.describe("evaluate('lookupdisplay("+scol+")', "+string(lrow2)+")")
				srowdata = srowdata + svalue + "~t"
			elseif pos(sdtype,'string') > 0 then
				svalue = adwsrc.describe("evaluate('lookupdisplay("+scol+")', "+string(lrow2)+")")
				srowdata = srowdata + svalue + "~t"
			else
				dvalue = adwsrc.getitemnumber(lrow2,scol)
				If isNull(dvalue) then dvalue = 0
				srowdata = srowdata + string(dvalue) + "~t"
			end if
		else
			if pos(sdtype,'char') > 0 then
				svalue = adwsrc.getitemstring(lrow2,scol)
				srowdata = srowdata + svalue + "~t"
			elseif pos(sdtype,'string') > 0 then
				svalue = adwsrc.getitemstring(lrow2,scol)
				srowdata = srowdata + svalue + "~t"
			else
				dvalue = adwsrc.getitemnumber(lrow2,scol)
				If isNull(dvalue) then dvalue = 0
				srowdata = srowdata + string(dvalue) + "~t"
			end if
		end if		
	NEXT
	
	if lrow2 = lrowcnt2 then
		srowdata = left(srowdata,len(srowdata)-1)
	else
		srowdata = left(srowdata,len(srowdata)-1)+"~r~n"
	end if
	filewrite(ifnum,srowdata)
	srowdata = ''
NEXT

fileclose(ifnum)
adwsrc.setredraw(true)

/////////////////////////////////////////////////////////////////////////
//	2.엑셀과 연결 시작 
oleobject 	export_object 
uint 			excel_handle, excel_state 
string 		excel_title 

setpointer(hourglass!)

export_object = create oleobject
export_object.connecttonewobject("excel.application") 

excel_title = export_object.Application.Caption 

export_object.Application.Visible = True 
excel_handle = FindWindowA( 0, excel_title ) 
SetFocus( excel_handle ) 

export_object.statusbar = "Importing data...." 
export_object.workbooks.opentext(sfilepath) 
export_object.windows("export.txt").caption = "Export Workbook" 

//엑셀파일의 포맷을 실시한다. 

//자동 칸맞춤을 적용한다. 
export_object.Worksheets[1].Columns.AutoFit 

//헤드 줄은 bold로 지정한다. 
export_object.rows("1:1").select 
export_object.selection.font.bold = true 
export_object.selection.font.italic = false 


export_object.statusbar = " Formatting labels....." 
export_object.rows("1:1").select 
//셀들의 줄맞춤을 실시한다. 
export_object.selection.wraptext = true 
export_object.selection.horizontalalignment = true 
export_object.selection.verticalalignment = true 

//미리보기에서 헤드셀들은 반복되어 나타나게 한다. 
export_object.Activesheet.PageSetup.PrintTitleRows = "$1:$1" 

export_object.DisConnectObject() //연결종료 
Destroy export_object //오브젝트 제거 

return 1
end function

public subroutine wf_filtering_objects (datawindow adwfr, ref datawindow adwto, string aband);//-------------------------------------------------------------------------------------------
// ** PB Version Check
//-------------------------------------------------------------------------------------------
long		lrow, lrow2, lrowcnt2, llen, lmaxlen
string	sdwobject, sband, scol, scoltype, stitle, stype
integer	ixpos, iwidth, iypos, iheight, iband_h

sdwobject = adwfr.dataobject

//-----------------------------------------------------------------------------
//		불필요한 object 를 제거한다.
//		1. 해당 band object 가 아닌 경우
//		2. object type 이 column, compute 가 아닌 경우
//		3. object visible 이 true 가 아닌 경우
//		4. object y position 이 band height 를 벗어나는 경우
//-----------------------------------------------------------------------------
lrowcnt2 = adwfr.rowcount()

FOR lrow = adwto.rowcount() TO 1 STEP -1
	scol = adwto.getitemstring(lrow,'name')

	sband = adwfr.Describe(scol+".band")

	
//	adwto.setitem(lrow,'band',sband)
	
	// 1.
	if upper(sband) <> upper(aband) then 
		adwto.deleterow(lrow)
		continue
	end if
	// 2.
	stype = adwfr.Describe(scol+".type")
	if stype <> "column" and stype <> "compute" then 
		adwto.deleterow(lrow)
		continue
	end if
	// 3.
	if adwfr.Describe(scol+".visible") = "0" then 
		adwto.deleterow(lrow)
		continue
	end if
	// 4.
	iypos = integer(adwfr.Describe(scol+".y"))
	iband_h= integer(adwfr.Describe("datawindow."+aband+".height"))
	if iypos > iband_h then 
		adwto.deleterow(lrow)
		continue
	end if

	ixpos = integer(adwfr.Describe(scol+".x"))
	iwidth= integer(adwfr.Describe(scol+".width"))
	iheight= integer(adwfr.Describe(scol+".height"))
	scoltype= adwfr.Describe(scol+".coltype")

	adwto.setitem(lrow,'xpos',ixpos)
	adwto.setitem(lrow,'width',iwidth)
	adwto.setitem(lrow,'ypos',iypos)
	adwto.setitem(lrow,'height',iheight)
	adwto.setitem(lrow,'dtype',scoltype)
	adwto.setitem(lrow,'type',stype)
	

	// 헤드 타이틀	
	select dw_header into :stitle from erpsys_dwexcel
	 where dw_object = :sdwobject and dw_column = :scol ;
	
	if sqlca.sqlcode <> 0 then
		if adwfr.Describe(scol+"_t.type") = "!" or &
			adwfr.Describe(scol+"_t.type") = "?" then
			continue
		elseif adwfr.Describe(scol+"_t.type") = "text" then
			stitle = adwfr.Describe(scol+"_t.text")
		else
			if pos(scoltype,'char') > 0 then
				stitle = adwfr.getitemstring(1,scol+"_t")
			else
				stitle = string(adwfr.getitemnumber(1,scol+"_t"))
			end if
		end if
	end if
	
	adwto.setitem(lrow,'title',stitle)

NEXT
end subroutine

on w_preview_option2.create
this.cb_3=create cb_3
this.cb_2=create cb_2
this.dw_2=create dw_2
this.cb_1=create cb_1
this.cbx_1=create cbx_1
this.dw_1=create dw_1
this.gb_1=create gb_1
this.Control[]={this.cb_3,&
this.cb_2,&
this.dw_2,&
this.cb_1,&
this.cbx_1,&
this.dw_1,&
this.gb_1}
end on

on w_preview_option2.destroy
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.dw_2)
destroy(this.cb_1)
destroy(this.cbx_1)
destroy(this.dw_1)
destroy(this.gb_1)
end on

event open;iwin = message.powerobjectparm

f_window_center(This)

//MessageBox('', string(iwin.dw_list.rowcount()))

//-----------------------------------------------------------------------------
//	object 목록을 가져온다.
//-----------------------------------------------------------------------------
setpointer(hourglass!)
wf_collect_objects(iwin.dw_list,dw_1)
wf_filtering_objects(iwin.dw_list,dw_1,'detail')
wf_distribute_objects(iwin.dw_list,dw_1)

cbx_1.checked = true
cbx_1.triggerevent(clicked!)
end event

event close;iwin.dw_list.modify(iscol+".color="+string(ilclr))

end event

type cb_3 from commandbutton within w_preview_option2
integer x = 2011
integer y = 44
integer width = 425
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "취  소"
end type

event clicked;close(parent)
end event

type cb_2 from commandbutton within w_preview_option2
boolean visible = false
integer x = 2638
integer y = 40
integer width = 393
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "진현이엑셀"
end type

event clicked;wf_excel_export(iwin.dw_list)
end event

type dw_2 from datawindow within w_preview_option2
boolean visible = false
integer x = 2944
integer y = 140
integer width = 1129
integer height = 808
integer taborder = 20
boolean titlebar = true
string title = "none"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_preview_option2
integer x = 1550
integer y = 44
integer width = 425
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "엑셀 저장"
end type

event clicked;long		lrow, lcnt
string	sdwobject, scolumn, stitle

dw_1.accepttext()
sdwobject = iwin.dw_list.dataobject

setpointer(hourglass!)
FOR lrow = 1 TO dw_1.rowcount()
	scolumn= trim(dw_1.getitemstring(lrow,'name'))
	stitle = trim(dw_1.getitemstring(lrow,'title'))
	
	select count(*) into :lcnt from erpsys_dwexcel
	 where dw_object = :sdwobject and dw_column = :scolumn ;
	
	if lcnt = 0 then
		insert into erpsys_dwexcel
		(	dw_object,			dw_column,			dw_header	)
		values
		(	:sdwobject,			:scolumn,			:stitle		) ;
	else
		update erpsys_dwexcel
			set dw_header = :stitle
		 where dw_object = :sdwobject
		   and dw_column = :scolumn ;
	end if
NEXT

commit ;

if wf_down_excel2(iwin.dw_list,dw_1) = -1 then
	messagebox('확인','액셀 저장 실패!!!')
	return
end if

close(parent)
end event

type cbx_1 from checkbox within w_preview_option2
integer x = 146
integer y = 72
integer width = 850
integer height = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "액셀 저장시 SKIP 항목은 제외"
boolean checked = true
end type

event clicked;if this.checked then
	dw_1.setfilter("isskip='N'")
else
	dw_1.setfilter("")
end if
dw_1.filter()
end event

type dw_1 from datawindow within w_preview_option2
integer x = 64
integer y = 204
integer width = 2418
integer height = 1164
integer taborder = 10
string dragicon = "DosEdit5!"
string title = "none"
string dataobject = "d_band_analyze1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event dragwithin;if row <= 0 then return
if row = this.getselectedrow(0) then return

this.selectrow(0,false)
this.selectrow(row,true)

//ilrow2 = row
end event

event dragdrop;if row <= 0 then return

this.RowsMove(ilrow,ilrow,primary!,this,row,primary!)

ilrow = row
this.drag(end!)
end event

event clicked;if row <= 0 then return

long	lclr

this.selectrow(0,false)
this.selectrow(row,true)

//////////////////////////////////////////////////////////////////////
iwin.dw_list.modify(iscol+".color="+string(ilclr))

iscol = this.getitemstring(row,'name')
lclr = long(iwin.dw_list.describe(iscol+".color"))
if lclr <> RGB(128,0,128) then
	ilclr = lclr
	iwin.dw_list.modify(iscol+".color="+string(RGB(128,0,128)))
end if
//////////////////////////////////////////////////////////////////////

if dwo.name = 'isskip' or dwo.name = 'title' then return

ilrow = row
this.drag(begin!)

end event

event itemchanged;if this.getcolumnname() = 'isskip' then
	cbx_1.postevent(clicked!)
end if
	
end event

event rowfocuschanged;this.selectrow(0,false)
this.selectrow(currentrow,true)
end event

type gb_1 from groupbox within w_preview_option2
integer x = 69
integer width = 1038
integer height = 188
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
end type

