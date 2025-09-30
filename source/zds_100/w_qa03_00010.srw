$PBExportHeader$w_qa03_00010.srw
$PBExportComments$** CLAIM접수
forward
global type w_qa03_00010 from w_inherite
end type
type dw_1 from u_key_enter within w_qa03_00010
end type
type p_1 from uo_picture within w_qa03_00010
end type
type p_2 from uo_picture within w_qa03_00010
end type
type p_3 from picture within w_qa03_00010
end type
type cbx_chk from checkbox within w_qa03_00010
end type
type dw_2 from datawindow within w_qa03_00010
end type
type pb_1 from u_pb_cal within w_qa03_00010
end type
type rb_1 from radiobutton within w_qa03_00010
end type
type rb_2 from radiobutton within w_qa03_00010
end type
type rb_3 from radiobutton within w_qa03_00010
end type
type cb_1 from commandbutton within w_qa03_00010
end type
type st_2 from statictext within w_qa03_00010
end type
type rb_t1 from radiobutton within w_qa03_00010
end type
type rb_t2 from radiobutton within w_qa03_00010
end type
type rb_t3 from radiobutton within w_qa03_00010
end type
type rb_t4 from radiobutton within w_qa03_00010
end type
type st_3 from statictext within w_qa03_00010
end type
type cbx_claim from checkbox within w_qa03_00010
end type
type gb_1 from groupbox within w_qa03_00010
end type
type gb_2 from groupbox within w_qa03_00010
end type
type gb_3 from groupbox within w_qa03_00010
end type
type rr_1 from roundrectangle within w_qa03_00010
end type
end forward

global type w_qa03_00010 from w_inherite
integer width = 5755
integer height = 2500
string title = "매출 CLAIM 접수"
windowstate windowstate = maximized!
dw_1 dw_1
p_1 p_1
p_2 p_2
p_3 p_3
cbx_chk cbx_chk
dw_2 dw_2
pb_1 pb_1
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
cb_1 cb_1
st_2 st_2
rb_t1 rb_t1
rb_t2 rb_t2
rb_t3 rb_t3
rb_t4 rb_t4
st_3 st_3
cbx_claim cbx_claim
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
rr_1 rr_1
end type
global w_qa03_00010 w_qa03_00010

type prototypes
FUNCTION boolean DeleteFileA(ref string filename) LIBRARY "Kernel32.dll" alias for "DeleteFileA;Ansi"

end prototypes

type variables
String is_sort
uo_xlobject uo_xl

end variables

forward prototypes
public function integer wf_required_chk ()
public subroutine wf_filter ()
public subroutine wf_excel (datawindow fdw)
end prototypes

public function integer wf_required_chk ();////필수입력항목 체크
//Long i, j
//Real qty
//String sdate, jpno
//
//sdate = f_today() //시스템일자
//jpno = String(SQLCA.FUN_JUNPYO(gs_sabu, sdate, 'E0'), "0000") //문서번호
//
////LOT No가 Null이고 QTY가 Null이면 삭제 
//for i = dw_lot.RowCount() to 1 step -1 
//	if (IsNull(Trim(dw_lot.object.cl_lotno[i])) or Trim(dw_lot.object.cl_lotno[i]) = "") and &
//	   IsNull(dw_lot.object.cl_qty[i]) then
//		dw_lot.DeleteRow(i)
//	end if
//next
//
//for i = 1 to dw_lot.RowCount() 
//	dw_lot.object.sabu[i] = gs_saupj
//	if rb_new.checked = True then  //문서번호
//	   dw_lot.object.cl_jpno[i] = sdate + jpno
//	else
//		dw_lot.object.cl_jpno[i] = Trim(dw_insert.object.cl_jpno[1])
//	end if	
//	dw_lot.object.cl_seq[i] = i
//	if IsNull(Trim(dw_lot.object.cl_lotno[i])) or Trim(dw_lot.object.cl_lotno[i]) = "" then
//		 dw_lot.object.cl_lotno[i] = "Unknown"
//	end if
//
//	if dw_lot.object.cl_lotno[i] < '.' or dw_lot.object.cl_lotno[i] > 'zzzzzz' then
//    	MessageBox("LOT No 범위 확인","LOT No는 문자나 숫자를 입력하세요!")
//		dw_lot.ScrollToRow(i) 
//	   dw_lot.SetColumn('cl_lotno')
//	   dw_lot.SetFocus()
//	   return -1
//	end if	
//	
//	if IsNull(dw_lot.object.cl_qty[i]) or dw_lot.object.cl_qty[i] <= 0 then
//    	MessageBox("LOT No 확인(1)","LOT No는 적어도 하나 이상이 입력되어야 합니다")
//		dw_lot.ScrollToRow(i) 
//	   dw_lot.SetColumn('cl_qty')
//	   dw_lot.SetFocus()
//	   return -1
//	end if	
//next
//
//dw_insert.object.sabu[1] = gs_saupj //사업장구분
//
//if rb_new.checked = True then  //문서번호
//	dw_insert.object.cl_jpno[1] = sdate + jpno
//end if	
//
//if Isnull(Trim(dw_insert.object.cl_jpno[1])) or Trim(dw_insert.object.cl_jpno[1]) = "" then
//  	f_message_chk(1400,'[문서번호]')
//	dw_insert.SetColumn('cl_jpno')
//	dw_insert.SetFocus()
//	return -1
//elseif Isnull(Trim(dw_insert.object.daecod[1])) or Trim(dw_insert.object.daecod[1]) = "" then
//  	f_message_chk(1400,'[거래처(판매처)]')
//	dw_insert.SetColumn('daecod')
//	dw_insert.SetFocus()
//	return -1
//elseif Isnull(Trim(dw_insert.object.cust_no[1])) or Trim(dw_insert.object.cust_no[1]) = "" then
//  	f_message_chk(1400,'[고객번호]')
//	dw_insert.SetColumn('cust_no')
//	dw_insert.SetFocus()
//	return -1
//elseif Isnull(Trim(dw_insert.object.snddtp[1])) or Trim(dw_insert.object.snddtp[1]) = "" then
//  	f_message_chk(1400,'[접수부서]')
//	dw_insert.SetColumn('snddtp')
//	dw_insert.SetFocus()
//	return -1
//elseif Isnull(Trim(dw_insert.object.sndemp[1])) or Trim(dw_insert.object.sndemp[1]) = "" then
//  	f_message_chk(1400,'[접수담당자]')
//	dw_insert.SetColumn('sndemp')
//	dw_insert.SetFocus()
//	return -1
//elseif Isnull(Trim(dw_insert.object.clrdat[1])) or Trim(dw_insert.object.clrdat[1]) = "" then
//  	f_message_chk(1400,'[접수일자]')
//	dw_insert.SetColumn('clrdat')
//	dw_insert.SetFocus()
//	return -1
//elseif Isnull(Trim(dw_insert.object.qcrdat[1])) or Trim(dw_insert.object.qcrdat[1]) = "" then
//  	f_message_chk(1400,'[발송일자]')
//	dw_insert.SetColumn('qcrdat')
//	dw_insert.SetFocus()
//	return -1
//elseif Isnull(Trim(dw_insert.object.itnbr[1])) or Trim(dw_insert.object.itnbr[1]) = "" then
//  	f_message_chk(1400,'[품번]')
//	dw_insert.SetColumn('itnbr')
//	dw_insert.SetFocus()
//	return -1
//elseif Isnull(dw_insert.object.clqty[1]) or dw_insert.object.clqty[1] <= 0 then
//  	f_message_chk(1400,'[수량]')
//	dw_insert.SetColumn('clqty')
//	dw_insert.SetFocus()
//	return -1
//end if	
//
return 1
end function

public subroutine wf_filter ();dw_insert.SetRedraw(False)

String 	ls_str, ls_str2

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

	/* 클레임 기준정보 적용 */
	if cbx_claim.checked then
		ls_str = ls_str + " and is_filt = 'Y' "
	end if

ElseIf rb_2.Checked Then
	rb_t1.Checked = True
	rb_t1.Enabled = False
	rb_t2.Enabled = False
	rb_t3.Enabled = False
	rb_t4.Enabled = False
	
	ls_str = "jasagb = 'N'"

	/* 클레임 기준정보 적용 */
	if cbx_claim.checked then
		ls_str = ls_str + " and is_filt = 'Y' "
	end if

Else
	rb_t1.Checked = True
	rb_t1.Enabled = False
	rb_t2.Enabled = False
	rb_t3.Enabled = False
	rb_t4.Enabled = False
	ls_str = ""
	
	/* 클레임 기준정보 적용 */
	if cbx_claim.checked then
		ls_str = " is_filt = 'Y' "
	end if
End If

dw_insert.SetFilter(ls_str)
dw_insert.Filter()

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

end subroutine

on w_qa03_00010.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.p_1=create p_1
this.p_2=create p_2
this.p_3=create p_3
this.cbx_chk=create cbx_chk
this.dw_2=create dw_2
this.pb_1=create pb_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.cb_1=create cb_1
this.st_2=create st_2
this.rb_t1=create rb_t1
this.rb_t2=create rb_t2
this.rb_t3=create rb_t3
this.rb_t4=create rb_t4
this.st_3=create st_3
this.cbx_claim=create cbx_claim
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.p_1
this.Control[iCurrent+3]=this.p_2
this.Control[iCurrent+4]=this.p_3
this.Control[iCurrent+5]=this.cbx_chk
this.Control[iCurrent+6]=this.dw_2
this.Control[iCurrent+7]=this.pb_1
this.Control[iCurrent+8]=this.rb_1
this.Control[iCurrent+9]=this.rb_2
this.Control[iCurrent+10]=this.rb_3
this.Control[iCurrent+11]=this.cb_1
this.Control[iCurrent+12]=this.st_2
this.Control[iCurrent+13]=this.rb_t1
this.Control[iCurrent+14]=this.rb_t2
this.Control[iCurrent+15]=this.rb_t3
this.Control[iCurrent+16]=this.rb_t4
this.Control[iCurrent+17]=this.st_3
this.Control[iCurrent+18]=this.cbx_claim
this.Control[iCurrent+19]=this.gb_1
this.Control[iCurrent+20]=this.gb_2
this.Control[iCurrent+21]=this.gb_3
this.Control[iCurrent+22]=this.rr_1
end on

on w_qa03_00010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.p_1)
destroy(this.p_2)
destroy(this.p_3)
destroy(this.cbx_chk)
destroy(this.dw_2)
destroy(this.pb_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.cb_1)
destroy(this.st_2)
destroy(this.rb_t1)
destroy(this.rb_t2)
destroy(this.rb_t3)
destroy(this.rb_t4)
destroy(this.st_3)
destroy(this.cbx_claim)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.rr_1)
end on

event open;call super::open;dw_1.SetTransObject(SQLCA)

rb_t1.Enabled = True
rb_t2.Enabled = True
rb_t3.Enabled = True
rb_t4.Enabled = True

dw_1.SetRedraw(False)
dw_1.Reset()
dw_1.InsertRow(0)

dw_1.Object.sdate[1] = Left(is_today,6)

dw_1.SetRedraw(True)

dw_insert.SetRedraw(False)
dw_insert.DataObject = 'd_qa03_00010_a'
dw_insert.SetTransObject(SQLCA)
dw_insert.Reset()
dw_insert.SetRedraw(True)

dw_1.SetFocus()

end event

type dw_insert from w_inherite`dw_insert within w_qa03_00010
integer x = 55
integer y = 396
integer width = 4521
integer height = 1904
integer taborder = 40
string dataobject = "d_qa03_00010_a"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event dw_insert::itemerror;return 1
end event

event dw_insert::clicked;call super::clicked;String ls_sort

If Right(dwo.Name, 2) = '_t' Then
	ls_sort = left(dwo.Name, Pos(dwo.Name, '_t') - 1) + ' A'
	If ls_sort <> is_sort Then
		is_sort = ls_sort
		SetSort(is_sort)
		Sort()
	End If
End If
end event

event dw_insert::rbuttondown;call super::rbuttondown;If row < 1 Then Return

SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

//거래처 선택
Choose Case dwo.name
	Case 'end_yn'
		gs_gubun = '1'
		Open(w_vndmst_popup)
		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
		
		This.SetItem(row, 'end_yn', gs_code)
		
End Choose
end event

type p_delrow from w_inherite`p_delrow within w_qa03_00010
boolean visible = false
integer x = 3680
integer y = 3524
integer taborder = 0
string picturename = "C:\erpman\image\up.gif"
end type

type p_addrow from w_inherite`p_addrow within w_qa03_00010
boolean visible = false
integer x = 3502
integer y = 3520
integer taborder = 0
string picturename = "C:\erpman\image\up.gif"
end type

type p_search from w_inherite`p_search within w_qa03_00010
boolean visible = false
integer x = 3753
integer y = 3372
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_qa03_00010
integer x = 3904
integer taborder = 0
end type

event p_ins::clicked;call super::clicked;
dw_insert.InsertRow(dw_insert.Rowcount() + 1)

dw_insert.ScrollToRow(dw_insert.Rowcount() + 1)

dw_insert.SetFocus()
end event

type p_exit from w_inherite`p_exit within w_qa03_00010
integer x = 4425
integer taborder = 90
end type

type p_can from w_inherite`p_can within w_qa03_00010
integer x = 4251
integer taborder = 80
end type

event p_can::clicked;call super::clicked;dw_1.SetRedraw(False)
dw_1.Reset()
dw_1.InsertRow(0)

dw_1.Object.sdate[1] = Left(is_today,6)

dw_1.SetRedraw(True)

dw_insert.SetRedraw(False)

dw_insert.Reset()
dw_insert.SetRedraw(True)
end event

type p_print from w_inherite`p_print within w_qa03_00010
boolean visible = false
integer x = 3927
integer y = 3372
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_qa03_00010
integer x = 3557
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

type p_del from w_inherite`p_del within w_qa03_00010
integer x = 4078
integer taborder = 70
end type

event p_del::clicked;call super::clicked;If dw_insert.AcceptText() < 1 Then Return
If dw_insert.RowCount() < 1 Then Return

Long i , ll_rcnt ,ii=0
String ls_new , ls_chk ,ls_jpno
ll_rcnt = dw_insert.RowCount()

For i = ll_rcnt To  1 Step -1
	ls_chk  = Trim(dw_insert.Object.is_chk[i])
	ls_new  = Trim(dw_insert.Object.is_new[i])
	ls_jpno = Trim(dw_insert.Object.cl_jpno[i])
	
	If ls_chk = 'Y' Then
		
		dw_insert.DeleteRow(i)
		ii++
	
	End if
Next

If ii < 1 Then
	MessageBox('확인','삭제할 행을 선택하세요.')
	Return
End If

If dw_insert.Update() = 1 Then
	Commit;
Else
	Rollback ;
	f_message_chk(31,'')
	Return
End If


end event

type p_mod from w_inherite`p_mod within w_qa03_00010
integer x = 3730
integer taborder = 60
end type

event p_mod::clicked;call super::clicked;If dw_insert.AcceptText() = -1 Then Return 
If dw_insert.RowCount() < 1 Then Return
If f_msg_update() < 1 then Return

String ls_jpno , ls_rono , ls_itnbr ,ls_date ,ls_new
Long  i , ll_cnt

ls_date = Trim(dw_1.object.sdate[1])

If ls_date = '' or isNull(ls_date) or f_datechk(ls_date+'01') < 1 Then
	f_message_chk(30 , "[통보년월]")
	dw_1.SetFocus()
	dw_1.setcolumn("sdate")
	Return
End If

ls_date = f_last_date(ls_date)
	
ls_jpno = String(SQLCA.FUN_JUNPYO(gs_sabu, ls_date, 'E0'), "0000") //문서번호

For i = 1 To dw_insert.RowCount()
	
//	ls_rono = Trim(dw_insert.Object.ro_no[i])
//	If ls_rono = '' Or isNull(ls_rono) Then
//		MessageBox('확인','RO No 가 없습니다.')
//		Return
//	End If
//	
//	Select Count(*) Into :ll_cnt
//	  From CLAMST_BOOGOOK 
//	 Where SABU = :gs_saupj 
//	   AND RO_NO = :ls_rono ;
//	
//	If ll_cnt > 0 Then
//		MessageBox(String(i)+'행 확인','RO No : '+ls_rono+'~t~t~t'+&
//		                       '~n~r~n~r해당 클레임문서는 등록된 문서입니다. 확인 후 다시 시도하세요. ')
//		Return
//	End If
   
	ls_new = Trim(dw_insert.object.is_new[i])
	
	If ls_new = 'N' Then Continue ;
	
	ls_itnbr = Trim(dw_insert.Object.itnbr[i])
	If ls_itnbr = '' Or isNull(ls_itnbr) Then 
		dw_insert.object.jasagb[i] = 'N'
	Else
	
		Select Count(*) Into :ll_cnt
		  From ITEMAS
		 Where ITNBR = :ls_itnbr  ;
		
		If ll_cnt > 0 Then
			dw_insert.object.jasagb[i] = 'Y'
		Else
			dw_insert.object.jasagb[i] = 'N'
		End If
	End If
	
	dw_insert.Object.sabu[i] = gs_saupj
	dw_insert.Object.cl_jpno[i] = ls_date+ls_jpno+String(i,'000')
Next

IF dw_insert.Update()  = 1  THEN	
	COMMIT;
	w_mdi_frame.sle_msg.Text = "저장 되었습니다!"
	
	p_inq.TriggerEvent(Clicked!)
	
ELSE
	ROLLBACK;
	//messagebox('',sqlca.sqlerrText)
	f_message_chk(32, "[저장실패]")
	w_mdi_frame.sle_msg.Text = "저장작업 실패!"
END IF

ib_any_typing = False //입력필드 변경여부 No

end event

type cb_exit from w_inherite`cb_exit within w_qa03_00010
integer x = 2825
integer y = 3288
end type

type cb_mod from w_inherite`cb_mod within w_qa03_00010
integer x = 1783
integer y = 3288
end type

type cb_ins from w_inherite`cb_ins within w_qa03_00010
integer x = 846
integer y = 2788
end type

type cb_del from w_inherite`cb_del within w_qa03_00010
integer x = 2130
integer y = 3288
end type

type cb_inq from w_inherite`cb_inq within w_qa03_00010
integer x = 1435
integer y = 3292
end type

type cb_print from w_inherite`cb_print within w_qa03_00010
end type

type st_1 from w_inherite`st_1 within w_qa03_00010
long backcolor = 12632256
end type

type cb_can from w_inherite`cb_can within w_qa03_00010
integer x = 2478
integer y = 3288
end type

type cb_search from w_inherite`cb_search within w_qa03_00010
integer x = 1230
integer y = 2792
end type



type sle_msg from w_inherite`sle_msg within w_qa03_00010
long backcolor = 12632256
end type

type gb_10 from w_inherite`gb_10 within w_qa03_00010
long backcolor = 12632256
end type

type gb_button1 from w_inherite`gb_button1 within w_qa03_00010
end type

type gb_button2 from w_inherite`gb_button2 within w_qa03_00010
end type

type dw_1 from u_key_enter within w_qa03_00010
event ue_key pbm_dwnkey
integer x = 23
integer y = 32
integer width = 2958
integer height = 248
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_qa03_00010_1"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;String  s_cod

s_cod = Trim(this.GetText())

Choose Case GetColumnName()
	Case "sdate"
		This.object.cl_cod[row] = s_cod +'1'+ Trim(This.object.gbn[row])
	Case "gbn"
		This.object.cl_cod[row] = Trim(This.object.sdate[row]) +'1'+ s_cod
end Choose

//If GetColumnName() = "gubun" Then
//	If IsNull(s_cod) or s_cod = "" Then Return
//	
//	dw_insert.SetRedraw(False)
//	
//	Choose Case s_cod 
//		Case 'H','K','L','E'
//			dw_insert.DataObject = 'd_qa03_00010_a'
//		Case 'M'
//			dw_insert.DataObject = 'd_qa03_00010_b'
//		
//	End Choose
//	
//	dw_insert.SetTransObject(SQLCA)
//	
//	dw_insert.SetRedraw(True)
//
//End If
end event

event itemerror;return 1
end event

event rbuttondown;//SetNull(gs_code)
//SetNull(gs_codename)
//SetNull(gs_gubun)
//
//if	this.getcolumnname() = "daecod" then //대리점
//	open(w_vndmst_popup)
//	this.object.daecod[1] = gs_code
//	this.object.daename[1] = gs_codename
//	return
//elseif this.getcolumnname() = "cust_no" then //고객번호
//	open(w_cust_popup)
//   this.object.cust_no[1] = gs_code
//   this.object.cust_name[1] = gs_codename
//	return
//end if	
end event

type p_1 from uo_picture within w_qa03_00010
boolean visible = false
integer x = 3730
integer y = 168
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

type p_2 from uo_picture within w_qa03_00010
boolean visible = false
integer x = 3904
integer y = 168
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

type p_3 from picture within w_qa03_00010
integer x = 3003
integer y = 24
integer width = 178
integer height = 144
boolean bringtotop = true
string picturename = "C:\erpman\image\from_excel.gif"
boolean focusrectangle = false
end type

event clicked;string ls_docname, ls_named ,ls_line 
Long   ll_FileNum ,ll_value
String ls_gubun , ls_col ,ls_line_t , ls_data[]
Long   ll_xl_row , ll_r , i

String ls_balgb , ls_cl_cod , ls_date 

If dw_1.AcceptText() = -1 Then Return

ll_value = GetFileOpenName("VAN Claim 데이타 가져오기", ls_docname, ls_named, & 
             "XLS", "XLS Files (*.XLS),*.XLS,")

If ll_value <> 1 Then Return
//UserObject 생성
ls_gubun = Trim(dw_1.Object.gubun[1])

dw_insert.Reset()

w_mdi_frame.sle_msg.Text = "EXCEL DATA IMPORT 중입니다..........."

Setpointer(Hourglass!)

uo_xl = create uo_xlobject
		
//엑셀과 연결
uo_xl.uf_excel_connect(ls_docname, false , 3)

Choose Case ls_gubun
	Case "H" , "K"
		//Sheet 선택
		uo_xl.uf_selectsheet(1)
		
		//Data 시작 Row Setting
		ll_xl_row =8
		
		ls_balgb = Trim(dw_1.object.bal_gb2[1])
		ls_cl_cod = Trim(dw_1.object.cl_cod[1])
		ls_date = Trim(dw_1.object.sdate[1])
		
		Do While(True)
			
			//Data가 없을경우엔 Return...........
			ls_line = trim(uo_xl.uf_gettext(ll_xl_row,1))
			if isnull(uo_xl.uf_gettext(ll_xl_row,1)) or trim(uo_xl.uf_gettext(ll_xl_row,1)) = '' then exit
			ll_r = dw_insert.InsertRow(0) 
			
			//dw_insert.Selectrow(0,false)
			dw_insert.Scrolltorow(ll_r)
			//dw_insert.Selectrow(ll_r,true)
			
			//사용자 ID(A,1)
			//Data를 읽을 경우 해당하는 셀서식을 지정해야만 글자가 깨지지 않음....이유는 모르겠음....
			For i =1 To 27
				uo_xl.uf_set_format(ll_xl_row,i, '@' + space(50))
			Next
			
			If (ls_gubun = '' or isNull(ls_gubun)) or ( ls_gubun <> Trim(uo_xl.uf_gettext(ll_xl_row,1)))  Then 
				dw_1.object.gubun[1] = Trim(uo_xl.uf_gettext(ll_xl_row,1))
				ls_gubun = Trim(uo_xl.uf_gettext(ll_xl_row,1))
			End If
			
			dw_insert.object.vnd_gb[ll_r]      =  Trim(uo_xl.uf_gettext(ll_xl_row,1))
			
			If (ls_balgb = '' or isNull(ls_balgb)) or ( ls_balgb <> Trim(uo_xl.uf_gettext(ll_xl_row,2)))  Then 
				dw_1.object.bal_gb2[1] = Trim(uo_xl.uf_gettext(ll_xl_row,2))
				ls_balgb = Trim(uo_xl.uf_gettext(ll_xl_row,2))
			End If
			
			dw_insert.object.bal_gb[ll_r]      =  Trim(uo_xl.uf_gettext(ll_xl_row,2))
			
			If ls_cl_cod = '' or isNull(ls_cl_cod) Then 
				dw_1.object.cl_cod[1] = Trim(uo_xl.uf_gettext(ll_xl_row,3))
				ls_cl_cod = Trim(uo_xl.uf_gettext(ll_xl_row,3))
			End If
			
			If ls_date <> Left(ls_cl_cod , 6 ) Then 
				dw_1.object.sdate[1] = Left(ls_cl_cod , 6 )
				ls_date =  Left(ls_cl_cod , 6 )
			End If
			
			dw_insert.object.cl_cod[ll_r]      =  Trim(uo_xl.uf_gettext(ll_xl_row,3))
			
			dw_insert.object.boogook_cod[ll_r]  =  Trim(uo_xl.uf_gettext(ll_xl_row,4))           
			dw_insert.object.cl_seq[ll_r]      =  Dec(uo_xl.uf_gettext(ll_xl_row,5))
			dw_insert.object.ro_yymm[ll_r]     =  Trim(uo_xl.uf_gettext(ll_xl_row,6))              
			dw_insert.object.ro_no[ll_r]       =  Trim(uo_xl.uf_gettext(ll_xl_row,7))                
			dw_insert.object.vin_no[ll_r]      =  Trim(uo_xl.uf_gettext(ll_xl_row,8))               
			dw_insert.object.c_type[ll_r]      =  Trim(uo_xl.uf_gettext(ll_xl_row,9))               
			dw_insert.object.car_gb[ll_r]      =  Trim(uo_xl.uf_gettext(ll_xl_row,10))               
			dw_insert.object.itnbr[ll_r]       =  Left(Trim(uo_xl.uf_gettext(ll_xl_row,11)),5)+&
			                                  '-'+Right(Trim(uo_xl.uf_gettext(ll_xl_row,11)),5)               
			dw_insert.object.itdsc2[ll_r]      =  Trim(uo_xl.uf_gettext(ll_xl_row,12))               
			dw_insert.object.jujakup_cod[ll_r] =  Trim(uo_xl.uf_gettext(ll_xl_row,13))          
			dw_insert.object.c_cod[ll_r]       =  Trim(uo_xl.uf_gettext(ll_xl_row,14))                
			dw_insert.object.n_cod[ll_r]       =  Trim(uo_xl.uf_gettext(ll_xl_row,15))                
			dw_insert.object.pdt_dt[ll_r]      =  Trim(uo_xl.uf_gettext(ll_xl_row,16))               
			dw_insert.object.repair_dt[ll_r]   =  Trim(uo_xl.uf_gettext(ll_xl_row,17))            
			dw_insert.object.sale_dt[ll_r]     =  Trim(uo_xl.uf_gettext(ll_xl_row,18))              
			dw_insert.object.use_gigan[ll_r]   =  Dec(uo_xl.uf_gettext(ll_xl_row,19))            
			dw_insert.object.use_range[ll_r]   =  Dec(uo_xl.uf_gettext(ll_xl_row,20)) 
			
			dw_insert.object.pwa[ll_r]   =  Trim(uo_xl.uf_gettext(ll_xl_row,21)) 
			
			dw_insert.object.deliv_rate[ll_r]  =  Dec(uo_xl.uf_gettext(ll_xl_row,22))   
			
			dw_insert.object.share_rate[ll_r]  =  Dec(uo_xl.uf_gettext(ll_xl_row,23))           
			dw_insert.object.apply_rate[ll_r]  =  Dec(uo_xl.uf_gettext(ll_xl_row,24))           
			dw_insert.object.it_amt[ll_r]      =  Dec(uo_xl.uf_gettext(ll_xl_row,25))               
			dw_insert.object.trans_amt[ll_r]   =  Dec(uo_xl.uf_gettext(ll_xl_row,26))            
			dw_insert.object.wai_amt[ll_r]     =  Dec(uo_xl.uf_gettext(ll_xl_row,27))              
			
			ll_xl_row ++
			
		Loop
		
//	Case 'M'
//		//Sheet 선택
//		String ls_balgb ,ls_exchgnbr
//		Dec ld_exchg_sum
//		
//		ls_balgb = Trim(dw_1.Object.bal_gb[1])
//		
//		If ls_balgb = '' Or isNull(ls_balgb) Then
//			MessageBox('확인','발생구분을 선택하세요.')
//			dw_1.SetFocus()
//			dw_1.SetColumn(2)
//			uo_xl.uf_excel_Disconnect()
//			Return
//		End If
//		
//		uo_xl.uf_selectsheet(1)
//		
//		//Data 시작 Row Setting
//		ll_xl_row =7
//		
//		Do While(True)
//			
//			//Data가 없을경우엔 Return...........
//			//청구금액 이 없을 경우 Exit
//			if isnull(uo_xl.uf_gettext(ll_xl_row,25)) or Trim(uo_xl.uf_gettext(ll_xl_row,25)) = '' then Exit
//			
//			ll_r = dw_insert.InsertRow(0) 
//			
//			//dw_insert.Selectrow(0,false)
//			dw_insert.Scrolltorow(ll_r)
//			//dw_insert.Selectrow(ll_r,true)
//			
//			For i =1 To 25
//				uo_xl.uf_set_format(ll_xl_row,i, '@' + space(50))
//			Next
//			
//						
//			If (Trim(uo_xl.uf_gettext(ll_xl_row,2))='' Or isNull(Trim(uo_xl.uf_gettext(ll_xl_row,2)))) And &
//			   Dec(uo_xl.uf_gettext(ll_xl_row,25)) > 0 Then
//				
//				dw_insert.object.vnd_gb[ll_r]      =  dw_insert.object.vnd_gb[ll_r - 1]          
//				dw_insert.object.bal_gb[ll_r]      =  dw_insert.object.bal_gb[ll_r - 1]          
//				
//				dw_insert.object.boogook_cod[ll_r]  =  dw_insert.object.leewon_cod[ll_r - 1]      
//				dw_insert.object.cl_seq[ll_r]      =  dw_insert.object.cl_seq[ll_r - 1]          
//				dw_insert.object.ro_no[ll_r]       =  dw_insert.object.ro_no[ll_r - 1]           
//				dw_insert.object.itnbr[ll_r]       =  dw_insert.object.itnbr[ll_r - 1]           
//														 
//				dw_insert.object.it_amt[ll_r]      =  dw_insert.object.it_amt[ll_r - 1]          
//				dw_insert.object.trans_amt[ll_r]   =  dw_insert.object.trans_amt[ll_r - 1]       
//				dw_insert.object.etc_amt[ll_r]     =  dw_insert.object.etc_amt[ll_r - 1]         
//																															
//				dw_insert.object.share_rate[ll_r]  =  dw_insert.object.share_rate[ll_r - 1]      
//				dw_insert.object.req_amt[ll_r]     =  dw_insert.object.req_amt[ll_r - 1]         
//				dw_insert.object.bal_site[ll_r]    =  dw_insert.object.bal_site[ll_r - 1]        
//				dw_insert.object.itdsc2[ll_r]      =  dw_insert.object.itdsc2[ll_r - 1]          
//				dw_insert.object.n_cod[ll_r]       =  dw_insert.object.n_cod[ll_r - 1]           
//				dw_insert.object.c_cod[ll_r]       =  dw_insert.object.c_cod[ll_r - 1]           
//				dw_insert.object.car_no[ll_r]      =  dw_insert.object.car_no[ll_r - 1]          
//				dw_insert.object.pdt_dt[ll_r]      =  dw_insert.object.pdt_dt[ll_r - 1]          
//				dw_insert.object.use_range[ll_r]   =  dw_insert.object.use_range[ll_r - 1]       
//				dw_insert.object.pre_range[ll_r]   =  dw_insert.object.pre_range[ll_r - 1]       
//				dw_insert.object.repair_dt[ll_r]   =  dw_insert.object.repair_dt[ll_r - 1]       
//				dw_insert.object.prebal_dt[ll_r]   =  dw_insert.object.prebal_dt[ll_r - 1]       
//				dw_insert.object.prero_no[ll_r]    =  dw_insert.object.prero_no[ll_r - 1]        
//				dw_insert.object.req_dt[ll_r]      =  dw_insert.object.req_dt[ll_r - 1]          
//
//			Else
//				dw_insert.object.vnd_gb[ll_r]      =  ls_gubun
//				dw_insert.object.bal_gb[ll_r]      =  ls_balgb
//				dw_insert.object.boogook_cod[ll_r]  =  'XXXX'
//				dw_insert.object.cl_seq[ll_r]      =  Dec(uo_xl.uf_gettext(ll_xl_row,1))
//				dw_insert.object.ro_no[ll_r]       =  Trim(uo_xl.uf_gettext(ll_xl_row,2))                
//				dw_insert.object.itnbr[ll_r]       =  Left(Trim(uo_xl.uf_gettext(ll_xl_row,3)),5)+&
//															'-'+Right(Trim(uo_xl.uf_gettext(ll_xl_row,3)),5)
//				dw_insert.object.it_amt[ll_r]      =  Dec(uo_xl.uf_gettext(ll_xl_row,4))               
//				dw_insert.object.trans_amt[ll_r]   =  Dec(uo_xl.uf_gettext(ll_xl_row,5))            
//				dw_insert.object.etc_amt[ll_r]     =  Dec(uo_xl.uf_gettext(ll_xl_row,6))            
//				
//				dw_insert.object.share_rate[ll_r]  =  Dec(uo_xl.uf_gettext(ll_xl_row,8))           
//				dw_insert.object.req_amt[ll_r]     =  Dec(uo_xl.uf_gettext(ll_xl_row,9))            
//				dw_insert.object.bal_site[ll_r]    =  Trim(uo_xl.uf_gettext(ll_xl_row,10))              
//				dw_insert.object.itdsc2[ll_r]      =  Trim(uo_xl.uf_gettext(ll_xl_row,11))               
//				dw_insert.object.n_cod[ll_r]       =  Trim(uo_xl.uf_gettext(ll_xl_row,12))                
//				dw_insert.object.c_cod[ll_r]       =  Trim(uo_xl.uf_gettext(ll_xl_row,13))                
//				dw_insert.object.car_no[ll_r]      =  Trim(uo_xl.uf_gettext(ll_xl_row,14))              
//				dw_insert.object.pdt_dt[ll_r]      =  Trim(uo_xl.uf_gettext(ll_xl_row,15))               
//				dw_insert.object.use_range[ll_r]   =  Dec(uo_xl.uf_gettext(ll_xl_row,16))
//				dw_insert.object.pre_range[ll_r]   =  Dec(uo_xl.uf_gettext(ll_xl_row,17))
//				dw_insert.object.repair_dt[ll_r]   =  Trim(uo_xl.uf_gettext(ll_xl_row,18))
//				dw_insert.object.prebal_dt[ll_r]   =  Trim(uo_xl.uf_gettext(ll_xl_row,19))
//				dw_insert.object.prero_no[ll_r]    =  Trim(uo_xl.uf_gettext(ll_xl_row,20))                
//				dw_insert.object.req_dt[ll_r]      =  Trim(uo_xl.uf_gettext(ll_xl_row,21))               
//			End If
//			
//			dw_insert.object.exchg_itnbr[ll_r] =  Left(Trim(uo_xl.uf_gettext(ll_xl_row,22)),5)+ &
//			                                  '-'+Right(Trim(uo_xl.uf_gettext(ll_xl_row,22)),5)
//			dw_insert.object.exchg_itdsc2[ll_r]=  Trim(uo_xl.uf_gettext(ll_xl_row,23))               
//			dw_insert.object.exchg_qty[ll_r]   =  Dec(uo_xl.uf_gettext(ll_xl_row,24))                
//			dw_insert.object.reqdan_amt[ll_r]  =  Dec(uo_xl.uf_gettext(ll_xl_row,25))               
//			
//			ll_xl_row ++
//			dw_insert.AcceptText()
//		Loop
		
End Choose

//MessageBox('확인',String(ll_r)+'건의 CLAIM DATA IMPORT 를 완료하였습니다.')

uo_xl.uf_excel_Disconnect()
dw_insert.AcceptText()
w_mdi_frame.sle_msg.Text = "DATA 를 저장 중입니다..........."
// 데이타 바루 저장 

If dw_insert.RowCount() < 1 Then Return


String ls_jpno , ls_rono , ls_itnbr
Long  ll_cnt

ls_date = Trim(dw_1.object.sdate[1])
ls_date = f_last_date(ls_date)
	
ls_jpno = String(SQLCA.FUN_JUNPYO(gs_sabu, ls_date, 'E0'), "0000") //문서번호

For i = 1 To dw_insert.RowCount()
	
	ls_rono = Trim(dw_insert.Object.ro_no[i])
	If ls_rono = '' Or isNull(ls_rono) Then
		MessageBox('확인','RO No 가 없습니다.')
		Return
	End If
	
	Select Count(*) Into :ll_cnt
	  From CLAMST_BOOGOOK 
	 Where SABU = :gs_saupj 
	   AND RO_NO = :ls_rono ;
	
	If ll_cnt > 0 Then
		MessageBox(String(i)+'행 확인','RO No : '+ls_rono+'~t~t~t'+&
		                       '~n~r~n~r해당 클레임문서는 등록된 문서입니다. 확인 후 다시 시도하세요. ')
		Return
	End If
	
	ls_itnbr = Trim(dw_insert.Object.itnbr[i])
	If ls_itnbr = '' Or isNull(ls_itnbr) Then 
		dw_insert.object.jasagb[i] = 'N'
	Else
	
		Select Count(*) Into :ll_cnt
		  From ITEMAS
		 Where ITNBR = :ls_itnbr  ;
		
		If ll_cnt > 0 Then
			dw_insert.object.jasagb[i] = 'Y'
		Else
			dw_insert.object.jasagb[i] = 'N'
		End If
	End If
	
	dw_insert.Object.sabu[i] = gs_saupj
	dw_insert.Object.cl_jpno[i] = ls_date+ls_jpno+String(i,'000')
Next

dw_insert.AcceptText()

IF dw_insert.Update()  = 1  THEN	
	COMMIT;
	w_mdi_frame.sle_msg.Text = "저장 되었습니다!"
	
	p_inq.TriggerEvent(Clicked!)
	
ELSE
	ROLLBACK;
	//messagebox('',sqlca.sqlerrText)
	f_message_chk(32, "[저장실패]")
	w_mdi_frame.sle_msg.Text = "저장작업 실패!"
END IF
w_mdi_frame.sle_msg.Text = String(ll_r)+'건의 CLAIM DATA IMPORT 를 완료하였습니다.'
MessageBox('확인',String(ll_r)+'건의 CLAIM DATA IMPORT 를 완료하였습니다.')

ib_any_typing = False //입력필드 변경여부 No


end event

type cbx_chk from checkbox within w_qa03_00010
integer x = 105
integer y = 308
integer width = 375
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "전체선택"
end type

event clicked;String ls_chk
Long   i

If This.Checked Then
	ls_chk = 'Y'
Else
	ls_chk = 'N'
End If

If dw_insert.RowCount() < 1 Then Return

For i =1 To dw_insert.RowCount()
	
	dw_insert.Object.is_chk[i] = ls_chk
Next

dw_insert.AcceptText()
	
end event

type dw_2 from datawindow within w_qa03_00010
boolean visible = false
integer x = 2784
integer y = 124
integer width = 357
integer height = 152
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_qa03_00010_etc"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type pb_1 from u_pb_cal within w_qa03_00010
integer x = 699
integer y = 68
integer width = 91
integer taborder = 120
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_1.SetColumn('sdate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_1.SetItem(1, 'sdate', Left(gs_code,6))

dw_1.object.cl_cod[1] = Left(gs_code,6) + +'1'+Trim(dw_1.object.gbn[1])


end event

type rb_1 from radiobutton within w_qa03_00010
integer x = 1449
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
end type

event clicked;wf_filter()

end event

type rb_2 from radiobutton within w_qa03_00010
integer x = 1029
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

type rb_3 from radiobutton within w_qa03_00010
integer x = 608
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
boolean checked = true
end type

event clicked;wf_filter()

end event

type cb_1 from commandbutton within w_qa03_00010
integer x = 3867
integer y = 296
integer width = 718
integer height = 88
integer taborder = 140
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "SAVE AS EXCLE !!"
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

type st_2 from statictext within w_qa03_00010
boolean visible = false
integer x = 4859
integer y = 416
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

type rb_t1 from radiobutton within w_qa03_00010
boolean visible = false
integer x = 4818
integer y = 508
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

type rb_t2 from radiobutton within w_qa03_00010
boolean visible = false
integer x = 4818
integer y = 588
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

type rb_t3 from radiobutton within w_qa03_00010
boolean visible = false
integer x = 4809
integer y = 660
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

type rb_t4 from radiobutton within w_qa03_00010
boolean visible = false
integer x = 4809
integer y = 740
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

type st_3 from statictext within w_qa03_00010
integer x = 3013
integer y = 208
integer width = 1184
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
string text = "* EXCEL Sheet 는 첫번째 것만 읽습니다."
boolean focusrectangle = false
end type

type cbx_claim from checkbox within w_qa03_00010
integer x = 2075
integer y = 312
integer width = 1477
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "클레임기준 초과자료만 표시 (보증기간,주행거리)"
end type

event clicked;wf_filter()

end event

type gb_1 from groupbox within w_qa03_00010
integer x = 55
integer y = 272
integer width = 434
integer height = 108
integer taborder = 130
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
end type

type gb_2 from groupbox within w_qa03_00010
integer x = 503
integer y = 272
integer width = 1449
integer height = 108
integer taborder = 130
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
end type

type gb_3 from groupbox within w_qa03_00010
boolean visible = false
integer x = 4663
integer y = 376
integer width = 905
integer height = 440
integer taborder = 160
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
end type

type rr_1 from roundrectangle within w_qa03_00010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 388
integer width = 4553
integer height = 1924
integer cornerheight = 40
integer cornerwidth = 55
end type

