$PBExportHeader$w_qa03_00020.srw
$PBExportComments$** CLAIM 이의제기
forward
global type w_qa03_00020 from w_inherite
end type
type dw_1 from u_key_enter within w_qa03_00020
end type
type p_1 from uo_picture within w_qa03_00020
end type
type p_2 from uo_picture within w_qa03_00020
end type
type dw_detail from datawindow within w_qa03_00020
end type
type rb_1 from radiobutton within w_qa03_00020
end type
type rb_2 from radiobutton within w_qa03_00020
end type
type rb_3 from radiobutton within w_qa03_00020
end type
type cb_1 from commandbutton within w_qa03_00020
end type
type rb_t1 from radiobutton within w_qa03_00020
end type
type st_2 from statictext within w_qa03_00020
end type
type rb_t2 from radiobutton within w_qa03_00020
end type
type rb_t3 from radiobutton within w_qa03_00020
end type
type rb_t4 from radiobutton within w_qa03_00020
end type
type pb_1 from u_pb_cal within w_qa03_00020
end type
type gb_2 from groupbox within w_qa03_00020
end type
type gb_1 from groupbox within w_qa03_00020
end type
type rr_1 from roundrectangle within w_qa03_00020
end type
end forward

global type w_qa03_00020 from w_inherite
integer height = 2500
string title = "매출 CLAIM 이의제기"
windowstate windowstate = maximized!
dw_1 dw_1
p_1 p_1
p_2 p_2
dw_detail dw_detail
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
cb_1 cb_1
rb_t1 rb_t1
st_2 st_2
rb_t2 rb_t2
rb_t3 rb_t3
rb_t4 rb_t4
pb_1 pb_1
gb_2 gb_2
gb_1 gb_1
rr_1 rr_1
end type
global w_qa03_00020 w_qa03_00020

type prototypes

FUNCTION boolean DeleteFileA(ref string filename) LIBRARY "Kernel32.dll" alias for "DeleteFileA;Ansi"
end prototypes

type variables
String is_sort
uo_xlobject uo_xl

end variables

forward prototypes
public subroutine wf_setfilter ()
public subroutine wf_filter ()
public subroutine wf_excel (datawindow fdw)
end prototypes

public subroutine wf_setfilter ();If dw_1.AcceptText() < 1 Then Return
If dw_1.RowCount() < 1 Then Return

String ls_useyn , ls_use_f ,  ls_gure , ls_gure_f , ls_share , ls_share_f ,ls_filter



ls_useyn  = Trim(dw_1.Object.end_gb[1])
ls_gure   = Trim(dw_1.Object.guar_gb[1])
ls_share  = Trim(dw_1.Object.share_gb[1])


//(useyn <> '0' and isNull(itemas_itnbr ) ) And (use_gigan > it_gure_gigan Or use_range >  it_gure_range ) And (share_rate >  it_share_rate )


If ls_useyn = 'Y' Then
	ls_use_f = " (useyn <> '0' and isNull(itemas_itnbr ) ) and  "
Else
	ls_use_f = ""
End If
If ls_gure = 'Y' Then
	ls_gure_f = " (use_gigan > it_gure_gigan Or use_range >  it_gure_range ) and  "
Else
	ls_gure_f = ""
End If
If ls_share = 'Y' Then
	ls_share_f = " (share_rate >  it_share_rate ) "
Else
	ls_share_f = " share_rate >= 0 "
End If

ls_filter = ls_use_f +ls_gure_f+ls_share_f

dw_insert.SetFilter(ls_filter)
dw_insert.Filter()
//dw_insert.SetFilter("")







end subroutine

public subroutine wf_filter ();dw_insert.SetRedraw(False)

String ls_str

If rb_1.Checked Then

	rb_t1.Enabled = True
	rb_t2.Enabled = True
	rb_t3.Enabled = True
	rb_t4.Enabled = True
	
	ls_str = "jasagb = 'Y'"
	If rb_t2.Checked Then
		ls_str = ls_str + " and useyn = '0' "
	ElseIf rb_t3.Checked Then
		ls_str = ls_str + " and useyn = '1' "
	ElseIf rb_t4.Checked Then
		ls_str = ls_str + " and useyn = '2' "
	Else
		
	End If
ElseIf rb_2.Checked Then
	rb_t1.Checked = True
	rb_t1.Enabled = False
	rb_t2.Enabled = False
	rb_t3.Enabled = False
	rb_t4.Enabled = False
	
	ls_str = "jasagb = 'N'"
Else
	rb_t1.Checked = True
	rb_t1.Enabled = False
	rb_t2.Enabled = False
	rb_t3.Enabled = False
	rb_t4.Enabled = False
	ls_str = ""
	
End If
dw_insert.SetFilter(ls_str)
dw_insert.Filter()

dw_insert.SetSort(" cl_cod a , cl_seq a ")
dw_insert.Sort()

dw_insert.SetRedraw(True)


end subroutine

public subroutine wf_excel (datawindow fdw);//변수 선언
int object_count, object_index, object_max
string objects, object_name, object_list[], object_select, object_band, object_type
string detail_object_spec, detail_objects[], detail_object_labels, s_header, header_text[]
string s_trailer1, s_trailer1_object[], s_footer, s_footer_object[], s_footer_data
boolean object_visible, b_detail = false, b_trailer1= false, b_summury = false, b_footer = false
int i_trailer1_count = 0, i_detail_count = 0, i_footer_count = 0

Long li_rtn 
String ls_pathname , ls_filename 

li_rtn = GetFileSaveName("파일저장경로를 선택하세요", ls_pathname, ls_filename, &
                        "Excel", " Excel Files (*.xls),*.xls" )
IF li_rtn = -1 THEN
	MessageBox("GetFileSaveName Error!", "저장 경로를 다시 선택하십시오.")
	Return 
End If


//데이터윈도우의 모든 오브젝트를 읽어온다.
objects = fdw.describe("Datawindow.Objects" )

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
object_band = upper(fdw.describe( object_name + ".band" ))
object_type = upper(fdw.describe( object_name + ".type" ))
object_visible = fdw.describe( object_name + ".visible" ) = "1" 
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

fdw.SetRedraw(false)
//컬럼의 순서를 알아내기 위한 작업을 한다.
object_select = '1/1' + object_select
fdw.modify("datawindow.selected= '" + object_select + "'")

object_select = fdw.describe("datawindow.selected")

detail_object_spec = right(object_select, len(object_select) - 4)

detail_object_spec = detail_object_spec + '/'
fdw.modify(" datawindow.selected=''")
fdw.SetRedraw(true)


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

//헤드에 있는 텍스트들의 text값을 저장한다.
for object_index = 1 to object_max 
	object_name = detail_objects[object_index]
	if detail_object_labels <> '' then detail_object_labels = detail_object_labels + '~t'
	 if fdw.describe( object_name + "_t.visible" ) <> '!' then
		iF upper(fdw.describe( object_name + "_t.type" )) = 'TEXT' Then
	  		detail_object_labels = detail_object_labels + fdw.describe(object_name + "_t.text")
		Elseif upper(fdw.describe( object_name + "_t.type" )) = 'COMPUTE' Then
			detail_object_labels = detail_object_labels + fdw.GetitemString(1 , object_name + "_t")
		Else
			detail_object_labels =  detail_object_labels + "?"
		End if
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

export_object.Application.Visible = False
//excel_handle = FindWindowA( 0, excel_title )
//SetFocus( excel_handle )

//파일작성
long row_count, start_row
string data_buffer, s_select, filename, s_syn, s_trailer1_data
int file_num, ii

//filename = "c:\ERPMAN\"+f_today()+f_totime()+".txt"
filename = ls_pathname
start_row = 1

row_count = fdw.rowcount()
if row_count = 0 then Return 

if fileexists(filename) then 
	DeleteFileA(filename)
end if

file_num = fileopen(filename, streammode!, write!, lockreadwrite!, append!)

//각 로우별로 데이터를 읽어서 파일에 기록한다.
for start_row = 1 to row_count
  s_select = string(start_row) + "/" + string(start_row) + "/" +detail_object_spec
 fdw.modify(" Datawindow.selected = '" + s_select + "'")
   data_buffer = fdw.describe("datawindow.selected.data") + "~r~n"
 if start_row = 1 then data_buffer = detail_object_labels + data_buffer
   if b_trailer1 then //그룹이 존재한다면
  i_target_row = fdw.FindGroupChange(start_row, 1) - 1
    if i_target_row = start_row then
   for i = 1 to i_trailer1_count
     if upper(fdw.describe( s_trailer1_object[i] + ".type" )) = "COMPUTE" then
      s_syn = fdw.describe(s_trailer1_object[i] + ".expression")
              s_syn = fdw.Describe("Evaluate('" + s_syn + "',"  + string(start_row) + ")")
              if i = 1 then
      for ii = 1 to i_detail_count - i_trailer1_count - 1
       s_trailer1_data = s_trailer1_data + '~t'
        next
      end if
      s_trailer1_data = s_trailer1_data + '~t' + s_syn  
      elseif upper(fdw.describe( s_trailer1_object[i] + ".type" )) = "COLUMN" then
      s_syn = fdw.Describe("Evaluate('LookUpDisplay(" + s_trailer1_object[i] + ") '," + &
                          string(start_row) + ")")
              if i = 1 then
       for ii = 1 to i_detail_count - i_trailer1_count - 1
        s_trailer1_data = s_trailer1_data + '~t'
       next
      end if
      s_trailer1_data = s_trailer1_data + '~t' + s_syn           
      elseif upper(fdw.describe( s_trailer1_object[i] + ".type" )) = "TEXT" then
      s_syn = fdw.Describe(s_trailer1_object[i] + ".text")
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
    if upper(fdw.describe( s_footer_object[i] + ".type" )) = "COMPUTE" then
     s_syn = fdw.describe(s_footer_object[i] + ".expression")
       s_syn = fdw.Describe("Evaluate('" + s_syn + "',"  + string(row_count) + ")")
         if i = 1 then
    for ii = 1 to i_detail_count - i_footer_count - 1
      s_footer_data = s_footer_data + '~t'
      next
     end if
   s_footer_data = s_footer_data + '~t' + s_syn  
    elseif upper(fdw.describe( s_footer_object[i] + ".type" )) = "COLUMN" then
   s_syn = fdw.Describe("Evaluate('LookUpDisplay(" + s_footer_object[i] + ") '," + &
                         string(row_count) + ")")
         if i = 1 then
    for ii = 1 to i_detail_count - i_footer_count - 1
      s_footer_data = s_footer_data + '~t'
      next
     end if          
     s_footer_data = s_footer_data + '~t' + s_syn           
    elseif upper(fdw.describe( s_footer_object[i] + ".type" )) = "TEXT" then
   s_syn = fdw.Describe(s_footer_object[i] + ".text")
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
export_object.DisConnectObject() //연결종료
Destroy export_object //오브젝트 제거 
MessageBox('확인','엑셀파일 저장을 완료하였습니다.')
Return

//export_object.statusbar = "Importing data...."
//export_object.workbooks.opentext(filename)
//export_object.windows(filename).caption = "Export Workbook"
//
////엑셀파일의 포맷을 실시한다.
//
////자동 칸맞춤을 적용한다.
//export_object.Worksheets[1].Columns.AutoFit
//
////헤드 줄은 bold로 지정한다.
//export_object.rows("1:1").select
//export_object.selection.font.bold = true
//export_object.selection.font.italic = false
//
//
//export_object.statusbar = " Formatting labels....."
//export_object.rows("1:1").select
////셀들의 줄맞춤을 실시한다.
//export_object.selection.wraptext  = true
//export_object.selection.horizontalalignment = true
//export_object.selection.verticalalignment = true
//
////미리보기에서 헤드셀들은 반복되어 나타나게 한다.
//export_object.Activesheet.PageSetup.PrintTitleRows = "$1:$1"
//
//export_object.DisConnectObject() //연결종료
//Destroy export_object //오브젝트 제거 
//
//MessageBox('확인3','엑셀파일 저장을 완료하였습니다.')
end subroutine

on w_qa03_00020.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.p_1=create p_1
this.p_2=create p_2
this.dw_detail=create dw_detail
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.cb_1=create cb_1
this.rb_t1=create rb_t1
this.st_2=create st_2
this.rb_t2=create rb_t2
this.rb_t3=create rb_t3
this.rb_t4=create rb_t4
this.pb_1=create pb_1
this.gb_2=create gb_2
this.gb_1=create gb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.p_1
this.Control[iCurrent+3]=this.p_2
this.Control[iCurrent+4]=this.dw_detail
this.Control[iCurrent+5]=this.rb_1
this.Control[iCurrent+6]=this.rb_2
this.Control[iCurrent+7]=this.rb_3
this.Control[iCurrent+8]=this.cb_1
this.Control[iCurrent+9]=this.rb_t1
this.Control[iCurrent+10]=this.st_2
this.Control[iCurrent+11]=this.rb_t2
this.Control[iCurrent+12]=this.rb_t3
this.Control[iCurrent+13]=this.rb_t4
this.Control[iCurrent+14]=this.pb_1
this.Control[iCurrent+15]=this.gb_2
this.Control[iCurrent+16]=this.gb_1
this.Control[iCurrent+17]=this.rr_1
end on

on w_qa03_00020.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.p_1)
destroy(this.p_2)
destroy(this.dw_detail)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.cb_1)
destroy(this.rb_t1)
destroy(this.st_2)
destroy(this.rb_t2)
destroy(this.rb_t3)
destroy(this.rb_t4)
destroy(this.pb_1)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.rr_1)
end on

event open;call super::open;dw_1.SetTransObject(SQLCA)
dw_detail.SetTransObject(SQLCA)
dw_insert.SetTransObject(SQLCA)

rb_t1.Enabled = True
rb_t2.Enabled = True
rb_t3.Enabled = True
rb_t4.Enabled = True

dw_1.Setredraw(False)
dw_1.ReSet()
dw_1.InsertRow(0)

dw_1.Object.sdate[1] = Left(is_today,6)

dw_1.Setredraw(True)

dw_detail.Setredraw(False)
dw_detail.ReSet()
dw_detail.InsertRow(0)
dw_detail.Setredraw(True)

dw_insert.Setredraw(False)
dw_insert.ReSet()
dw_insert.Setredraw(True)

dw_1.SetFocus()

end event

type dw_insert from w_inherite`dw_insert within w_qa03_00020
integer x = 50
integer y = 400
integer width = 4530
integer height = 1640
integer taborder = 40
string dataobject = "d_qa03_00020_a"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemerror;return 1
end event

event dw_insert::clicked;call super::clicked;String ls_sort
String ls_itnbr

If Row < 1 Then Return

ls_itnbr = Trim(This.Object.itnbr[row])

If dw_detail.Retrieve(gs_sabu , ls_itnbr) < 1 Then
	dw_detail.InsertRow(0)
End If

If Right(dwo.Name, 2) = '_t' Then
	ls_sort = left(dwo.Name, Pos(dwo.Name, '_t') - 1) + ' A'
	If ls_sort <> is_sort Then
		is_sort = ls_sort
		SetSort(is_sort)
		Sort()
	End If
End If
end event

event dw_insert::itemchanged;call super::itemchanged;AcceptText()
String ls_getdata
Choose Case GetColumnName()
	Case 'object_dt'
		ls_getdata = GetText()
		
		If f_datechk(ls_getdata) < 1 Then
			f_message_chk(35,'[이의제기 날짜]')
			Return 1
		End If
End Choose
end event

type p_delrow from w_inherite`p_delrow within w_qa03_00020
boolean visible = false
integer x = 3680
integer y = 3524
integer taborder = 0
string picturename = "C:\erpman\image\up.gif"
end type

type p_addrow from w_inherite`p_addrow within w_qa03_00020
boolean visible = false
integer x = 3502
integer y = 3520
integer taborder = 0
string picturename = "C:\erpman\image\up.gif"
end type

type p_search from w_inherite`p_search within w_qa03_00020
boolean visible = false
integer x = 3753
integer y = 3372
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_qa03_00020
boolean visible = false
integer x = 3625
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_qa03_00020
integer x = 4425
integer taborder = 90
end type

event p_exit::clicked;//
close(parent)
end event

type p_can from w_inherite`p_can within w_qa03_00020
integer x = 4251
integer taborder = 80
end type

event p_can::clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

dw_1.Setredraw(False)
dw_1.ReSet()
dw_1.InsertRow(0)

dw_1.Object.sdate[1] = Left(is_today,6)

dw_1.Setredraw(True)

dw_insert.Setredraw(False)
dw_insert.ReSet()
dw_insert.Setredraw(True)

dw_1.SetFocus()
end event

type p_print from w_inherite`p_print within w_qa03_00020
boolean visible = false
integer x = 3927
integer y = 3372
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_qa03_00020
integer x = 3904
integer taborder = 20
end type

event p_inq::clicked;call super::clicked;String ls_vndgb , ls_balgb,ls_balgb1 ,ls_balgb2 ,ls_itnbr
String ls_sdate , ls_fdate

if dw_1.accepttext() = -1 then return

ls_vndgb  = Trim(dw_1.Object.gubun[1])

ls_balgb = Trim(dw_1.Object.bal_gb2[1])  // 국내,해외

ls_sdate  = Trim(dw_1.Object.sdate[1])
ls_fdate   = Trim(dw_1.Object.cl_cod[1])
ls_itnbr  = Trim(dw_1.Object.itnbr[1])

//If ls_vndgb = 'M' Then
//	ls_balgb = ls_balgb1
//Else
//	ls_balgb = '%'+ls_balgb2+'%'
//End If

If isNull(ls_sdate) Or ls_sdate = '' Then ls_sdate = '%'
If isNull(ls_fdate) Or ls_fdate = '' Then ls_fdate = '%'
If isNull(ls_itnbr) Or ls_itnbr = '' Then ls_itnbr = '%'

dw_insert.setredraw(false)

If dw_insert.Retrieve(gs_saupj,ls_vndgb , ls_balgb ,ls_sdate+'%' , ls_fdate+'%' , ls_itnbr + '%') > 0 then
else
   f_message_chk(50, '[Claim 통보 내역]')
end if

dw_insert.setredraw(true)



end event

type p_del from w_inherite`p_del within w_qa03_00020
boolean visible = false
integer x = 3474
integer taborder = 70
end type

type p_mod from w_inherite`p_mod within w_qa03_00020
integer x = 4078
integer taborder = 60
end type

event p_mod::clicked;call super::clicked;If dw_insert.AcceptText() = -1 Then Return 
If dw_insert.RowCount() < 1 Then Return
If f_msg_update() = -1 then Return

dw_insert.AcceptText()

IF dw_insert.Update() > 0 THEN	
	COMMIT;
	w_mdi_frame.sle_msg.Text = "저장 되었습니다!"
	p_inq.TriggerEvent(Clicked!)
ELSE
	ROLLBACK;
	f_message_chk(32, "[저장실패]")
	w_mdi_frame.sle_msg.Text = "저장작업 실패!"
END IF

ib_any_typing = False //입력필드 변경여부 No

end event

type cb_exit from w_inherite`cb_exit within w_qa03_00020
integer x = 2825
integer y = 3288
end type

type cb_mod from w_inherite`cb_mod within w_qa03_00020
integer x = 1783
integer y = 3288
end type

type cb_ins from w_inherite`cb_ins within w_qa03_00020
integer x = 846
integer y = 2788
end type

type cb_del from w_inherite`cb_del within w_qa03_00020
integer x = 2130
integer y = 3288
end type

type cb_inq from w_inherite`cb_inq within w_qa03_00020
integer x = 1435
integer y = 3292
end type

type cb_print from w_inherite`cb_print within w_qa03_00020
end type

type st_1 from w_inherite`st_1 within w_qa03_00020
long backcolor = 12632256
end type

type cb_can from w_inherite`cb_can within w_qa03_00020
integer x = 2478
integer y = 3288
end type

type cb_search from w_inherite`cb_search within w_qa03_00020
integer x = 1230
integer y = 2792
end type



type sle_msg from w_inherite`sle_msg within w_qa03_00020
long backcolor = 12632256
end type

type gb_10 from w_inherite`gb_10 within w_qa03_00020
long backcolor = 12632256
end type

type gb_button1 from w_inherite`gb_button1 within w_qa03_00020
end type

type gb_button2 from w_inherite`gb_button2 within w_qa03_00020
end type

type dw_1 from u_key_enter within w_qa03_00020
event ue_key pbm_dwnkey
integer x = 23
integer y = 24
integer width = 2944
integer height = 252
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_qa03_00020_1"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemerror;return 1
end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

If	Getcolumnname() = "cl_jpno" Then 
	
	open(w_qa03_00020_popup)
	
	If isNull(gs_code) And isNull(gs_gubun) Then Return
	
	This.object.cl_jpno[1] = left(gs_code ,12)
   This.object.gubun[1] = gs_gubun
	
	Return

End If	
end event

type p_1 from uo_picture within w_qa03_00020
boolean visible = false
integer x = 3584
integer y = 144
integer width = 178
integer taborder = 100
boolean bringtotop = true
string pointer = "C:\erpman\cur\addrow.cur"
string picturename = "C:\erpman\image\행추가_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\행추가_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\행추가_up.gif"
end event

type p_2 from uo_picture within w_qa03_00020
boolean visible = false
integer x = 3767
integer y = 144
integer width = 178
integer taborder = 110
boolean bringtotop = true
string pointer = "C:\erpman\cur\delrow.cur"
string picturename = "C:\erpman\image\행삭제_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\행삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\행삭제_up.gif"
end event

type dw_detail from datawindow within w_qa03_00020
integer x = 37
integer y = 2068
integer width = 4576
integer height = 260
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_qa03_00020_c"
boolean border = false
boolean livescroll = true
end type

type rb_1 from radiobutton within w_qa03_00020
integer x = 1010
integer y = 308
integer width = 379
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "자사품번"
boolean checked = true
end type

event clicked;wf_filter()

end event

type rb_2 from radiobutton within w_qa03_00020
integer x = 576
integer y = 308
integer width = 379
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "타사품번"
end type

event clicked;wf_filter()

end event

type rb_3 from radiobutton within w_qa03_00020
integer x = 142
integer y = 308
integer width = 379
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "전체"
end type

event clicked;wf_filter()

end event

type cb_1 from commandbutton within w_qa03_00020
integer x = 3419
integer y = 288
integer width = 718
integer height = 88
integer taborder = 150
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "SAVEAS EXCLE!"
end type

event clicked;
//Long li_rtn 
//String ls_pathname , ls_filename 
//
//li_rtn = GetFileSaveName("파일저장경로를 선택하세요", ls_pathname, ls_filename, &
//                        "Excel", " Excel Files (*.xls),*.xls" )
//IF li_rtn = -1 THEN
//	MessageBox("GetFileSaveName Error!", "저장 경로를 다시 선택하십시오.")
//	Return 
//End If

wf_excel(dw_insert)
end event

type rb_t1 from radiobutton within w_qa03_00020
integer x = 1883
integer y = 308
integer width = 256
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "전체"
boolean checked = true
end type

event clicked;wf_filter()

end event

type st_2 from statictext within w_qa03_00020
integer x = 1568
integer y = 312
integer width = 306
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "품번구분:"
boolean focusrectangle = false
end type

type rb_t2 from radiobutton within w_qa03_00020
integer x = 2181
integer y = 308
integer width = 256
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "사용"
end type

event clicked;wf_filter()

end event

type rb_t3 from radiobutton within w_qa03_00020
integer x = 2478
integer y = 308
integer width = 256
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "B/OUT"
end type

event clicked;wf_filter()

end event

type rb_t4 from radiobutton within w_qa03_00020
integer x = 2775
integer y = 308
integer width = 517
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "사용중지(단종)"
end type

event clicked;wf_filter()

end event

type pb_1 from u_pb_cal within w_qa03_00020
integer x = 699
integer y = 60
integer width = 91
integer taborder = 130
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_1.SetColumn('sdate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_1.SetItem(1, 'sdate', Left(gs_code,6))


end event

type gb_2 from groupbox within w_qa03_00020
integer x = 50
integer y = 272
integer width = 1449
integer height = 108
integer taborder = 140
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
end type

type gb_1 from groupbox within w_qa03_00020
integer x = 1509
integer y = 272
integer width = 1883
integer height = 108
integer taborder = 150
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
end type

type rr_1 from roundrectangle within w_qa03_00020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 392
integer width = 4562
integer height = 1664
integer cornerheight = 40
integer cornerwidth = 55
end type

