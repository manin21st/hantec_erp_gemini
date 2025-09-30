$PBExportHeader$w_kfac30.srw
$PBExportComments$감가상각비조정명세서(정율법)
forward
global type w_kfac30 from w_standard_print
end type
type st_wait from statictext within w_kfac30
end type
type rr_1 from roundrectangle within w_kfac30
end type
end forward

global type w_kfac30 from w_standard_print
integer x = 0
integer y = 0
string title = "감가상각비 조정명세서(정율법)"
st_wait st_wait
rr_1 rr_1
end type
global w_kfac30 w_kfac30

type variables
String proc_gu
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();long    row_num
string  ls_year, ls_fromdate, ls_todate, ls_saupj

setpointer(hourglass!)
sle_msg.text =""

dw_ip.AcceptText()
row_num = dw_ip.GetRow()

ls_fromdate  = dw_ip.GetItemString(row_num,"fromdate")
ls_todate  = dw_ip.GetItemString(row_num,"todate")
ls_saupj  = dw_ip.GetItemString(row_num,"kfsacod")

if IsNUll(ls_fromdate) or IsNUll(ls_todate) then 
   Messagebox("확 인","사업연도 범위를 정확히 입력하십시오 !")
   dw_ip.SetFocus()
   dw_ip.SetColumn(1)
   return -1
end if

IF ls_saupj = "" OR IsNull(ls_saupj) THEN
	F_MessageChk(1,'[사업장]')
	dw_ip.SetColumn("kfsacod")
	dw_ip.SetFocus()
	Return -1
END IF

//사업장이 null이면 모든자료처리함//
if ls_saupj = '99' then ls_saupj = '%'

//회기연도값을 구함// 
ls_year  = left(ls_fromdate,4)

string sangho, saupno, ls_code,ls_name, ls_sano
SetNull(ls_code)
SetNull(ls_name)
SetNull(ls_sano)

//기본값의 상호, 사업자번호를 구함//
	//회사의 상호를 구함//
  SELECT "SYSCNFG"."DATANAME"  
    INTO :sangho  
    FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'C' ) AND  
         ( "SYSCNFG"."SERIAL" = 1 ) AND  
         ( "SYSCNFG"."LINENO" = '3' )   ;
   //사업자번호를 구함//			
  SELECT "SYSCNFG"."DATANAME"  
    INTO :saupno  
    FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'C' ) AND  
         ( "SYSCNFG"."SERIAL" = 1 ) AND  
         ( "SYSCNFG"."LINENO" = '2' )   ;
			
//특정 사업장의 경우 별도로 상호 및 사업자번호를 구함//
if IsNull(ls_saupj) then	
  SELECT "REFFPF"."RFNA2"  
    INTO :ls_code
    FROM "REFFPF"  
   WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND  
         ( "REFFPF"."RFGUB" = :ls_saupj )   ;
			
  SELECT "VNDMST"."SANO","VNDMST"."CVNAS"  
    INTO :ls_sano, :ls_name  
    FROM "VNDMST"  
   WHERE "VNDMST"."CVCOD" = :ls_code   ;
	
  if Not IsNull(ls_name) then
	  sangho = ls_name
  end if
  if Not IsNull(ls_sano) then
	  saupno = ls_sano
  end if
end if

row_num = dw_print.Retrieve(ls_year,ls_saupj,ls_fromdate,ls_todate)
if row_num <= 0 then
   Messagebox("확 인","해당하는 자료가 없습니다. !")
   return -1
end if

dw_list.Modify("st_coname.text = '"+sangho+"'")
dw_list.Modify("st_no1.text = '"+mid(saupno,1,1)+"'")
dw_list.Modify("st_no2.text = '"+mid(saupno,2,1)+"'")
dw_list.Modify("st_no3.text = '"+mid(saupno,3,1)+"'")
dw_list.Modify("st_no4.text = '"+mid(saupno,4,1)+"'")
dw_list.Modify("st_no5.text = '"+mid(saupno,5,1)+"'")
dw_list.Modify("st_no6.text = '"+mid(saupno,6,1)+"'")
dw_list.Modify("st_no7.text = '"+mid(saupno,7,1)+"'")
dw_list.Modify("st_no8.text = '"+mid(saupno,8,1)+"'")
dw_list.Modify("st_no9.text = '"+mid(saupno,9,1)+"'")
dw_list.Modify("st_no10.text = '"+mid(saupno,10,1)+"'")

ST_WAIT.VISIBLE = FALSE
setpointer(ARROW!)
dw_print.sharedata(dw_list)
Return 1
end function

on w_kfac30.create
int iCurrent
call super::create
this.st_wait=create st_wait
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_wait
this.Control[iCurrent+2]=this.rr_1
end on

on w_kfac30.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_wait)
destroy(this.rr_1)
end on

event open;call super::open;Int iRtnval

lstr_jpra.flag =True

dw_datetime.settransobject(sqlca)
dw_ip.SetTransObject(SQLCA)
dw_ip.Reset()
dw_ip.InsertRow(0)

dw_list.settransobject(sqlca)

sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 가로방향"
dw_ip.SetItem(dw_ip.GetRow(),"kfcod1","1")
dw_ip.SetItem(dw_ip.GetRow(), "fromdate",left(f_Today(),6) + '01')
dw_ip.SetItem(dw_ip.GetRow(), "todate",f_Today())

IF Upper(Mid(is_window_id,4,2)) = 'BG' THEN							   /*예산*/
	IF F_Valid_EmpNo(Gs_EmpNo) = 'N' THEN							/*권한 체크- 현업 여부*/
		dw_ip.SetItem(dw_ip.GetRow(),"kfsacod",   Gs_Saupj)
		
		dw_ip.Modify("kfsacod.protect = 1")
//		dw_ip.Modify("kfsacod.background.color ='"+String(RGB(192,192,192))+"'")
	ELSE
		dw_ip.Modify("kfsacod.protect = 0")
//		dw_ip.Modify("kfsacod.background.color ='"+String(RGB(190,225,184))+"'")
	END IF
ELSE
	dw_ip.SetItem(dw_ip.GetRow(),"kfsacod",   Gs_Saupj)
		
	IF Upper(Mid(is_window_id,4,2)) = 'FI' THEN							/*자금*/
		iRtnVal = F_Authority_Fund_Chk(Gs_Dept)	
	ELSE
		iRtnVal = F_Authority_Chk(Gs_Dept)
	END IF
	IF iRtnVal = -1 THEN							/*권한 체크- 현업 여부*/
		
		dw_ip.Modify("kfsacod.protect = 1")
//		dw_ip.Modify("kfsacod.background.color ='"+String(RGB(192,192,192))+"'")
	ELSE
		dw_ip.Modify("kfsacod.protect = 0")
//		dw_ip.Modify("kfsacod.background.color ='"+String(RGB(255,255,255))+"'")
	END IF	
END IF

end event

type p_xls from w_standard_print`p_xls within w_kfac30
end type

type p_sort from w_standard_print`p_sort within w_kfac30
end type

type p_preview from w_standard_print`p_preview within w_kfac30
boolean visible = false
integer x = 2958
integer y = 72
integer taborder = 0
end type

type p_exit from w_standard_print`p_exit within w_kfac30
integer taborder = 0
end type

type p_print from w_standard_print`p_print within w_kfac30
integer taborder = 0
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfac30
integer x = 4096
integer taborder = 0
end type

type st_window from w_standard_print`st_window within w_kfac30
integer x = 2363
end type

type sle_msg from w_standard_print`sle_msg within w_kfac30
integer width = 1970
end type



type st_10 from w_standard_print`st_10 within w_kfac30
end type



type dw_print from w_standard_print`dw_print within w_kfac30
string dataobject = "dw_kfac30_2"
end type

type dw_ip from w_standard_print`dw_ip within w_kfac30
integer x = 50
integer width = 3630
integer height = 160
integer taborder = 0
string dataobject = "dw_kfac30_1"
end type

event dw_ip::rbuttondown;char dkfcod1
long dkfcod2, row_num, retrieve_row 

SetNull(gs_code)
SetNull(gs_codename)

dw_ip.AcceptText()

IF this.GetColumnName() ="kfcod2" THEN 	
	row_num  = dw_ip.Getrow()

	dkfcod1 = dw_ip.GetItemString( row_num, "kfcod1")
	dkfcod2 = dw_ip.GetItemNumber( row_num, "kfcod2")

	IF Isnull(dkfcod1) then dkfcod1 = ""
	if Isnull(dkfcod2) then dkfcod2 = 0

	gs_code = dkfcod1
	gs_codename = String(dkfcod2)

	open(w_kfaa02b)
	
	IF IsNull(gs_code) THEN RETURN
	
   dw_ip.setitem(dw_ip.Getrow(),"kfcod1",gs_code)
   dw_ip.Setitem(dw_ip.Getrow(),"kfcod2",Long(gs_codename))
END IF

IF this.GetColumnName() ="tfcod2" THEN 	
	row_num  = dw_ip.Getrow()

	dkfcod1 = dw_ip.GetItemString( row_num, "tfcod1")
	dkfcod2 = dw_ip.GetItemNumber( row_num, "tfcod2")

	IF Isnull(dkfcod1) then dkfcod1 = ""
	if Isnull(dkfcod2) then dkfcod2 = 0

	gs_code = dkfcod1
	gs_codename = String(dkfcod2)

	open(w_kfaa02b)
	
	IF IsNull(gs_code) THEN RETURN
	
   dw_ip.setitem(dw_ip.Getrow(),"tfcod1",gs_code)
   dw_ip.Setitem(dw_ip.Getrow(),"tfcod2",Long(gs_codename))
END IF

dw_ip.setfocus()


end event

event dw_ip::itemchanged;
IF dwo.name ="kfcod1" THEN
	dw_list.SetRedraw(False)
	IF data = "1" THEN       //정율법 상각부인액//
		dw_list.DataObject ="dw_kfac30_2"
		dw_print.DataObject ="dw_kfac30_2"
	ELSEif data = "2" THEN   //정율법 시인부족액//
		dw_list.DataObject ="dw_kfac30_3"
		dw_print.DataObject ="dw_kfac30_3"
	else                     //전체//
		dw_list.DataObject ="dw_kfac30_4"
		dw_print.DataObject ="dw_kfac30_4"
	END IF
	dw_list.SetRedraw(True)
	dw_list.SetTransObject(SQLCA)
	dw_print.SetTransObject(SQLCA)
END IF
end event

event dw_ip::itemerror;Return 1
end event

type dw_list from w_standard_print`dw_list within w_kfac30
integer x = 64
integer y = 196
integer width = 4521
integer height = 2008
integer taborder = 0
string dataobject = "dw_kfac30_2"
boolean border = false
end type

event dw_list::clicked;w_mdi_frame.sle_msg.text = ''
end event

event dw_list::rowfocuschanged;w_mdi_frame.sle_msg.text = ''
end event

type st_wait from statictext within w_kfac30
boolean visible = false
integer x = 18
integer y = 2276
integer width = 1938
integer height = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 28144969
long backcolor = 32106727
boolean enabled = false
string text = "당기상각액을 계산하고 있습니다. 잠시만 기다리십시오 ! "
alignment alignment = center!
boolean border = true
long bordercolor = 255
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_kfac30
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 16777215
integer x = 46
integer y = 184
integer width = 4567
integer height = 2040
integer cornerheight = 40
integer cornerwidth = 55
end type

