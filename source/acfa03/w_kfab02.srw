$PBExportHeader$w_kfab02.srw
$PBExportComments$고정자산처분명세서 조회 출력
forward
global type w_kfab02 from w_standard_print
end type
type cb_1 from commandbutton within w_kfab02
end type
type dw_excel from datawindow within w_kfab02
end type
type rr_1 from roundrectangle within w_kfab02
end type
end forward

global type w_kfab02 from w_standard_print
integer x = 0
integer y = 0
string title = "고정자산처분명세서 조회 출력"
cb_1 cb_1
dw_excel dw_excel
rr_1 rr_1
end type
global w_kfab02 w_kfab02

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();long   row_num
string DKFACDAT, DTFACDAT, yy, TEMP_YMD, Ssaupj
int ii, mm ,JJ ,DKFACSEQ
decimal dkfamt, dkfdeamt, dkfrde, DKFCAMT, DRAMT[12], CRAMT[12], deamt[12], rdeamt[12]
DECIMAL DCOMPUTE_1, DCOMPUTE_2, DCOMPUTE_3, TOTDKFRDE, TOTRDEAMT[12]

setpointer(hourglass!)

sle_msg.text =""
dw_ip.AcceptText()
row_num = dw_ip.GetRow()

DKFACDAT = Trim(dw_ip.GetItemString(row_num,"KFACDAT"))
DTFACDAT = Trim(dw_ip.GetItemString(row_num,"TFACDAT"))
sSaupj   = Trim(dw_ip.GetItemString(row_num,"SAUPJ"))

IF sSaupj = "" OR IsNull(sSaupj) THEN
	F_MessageChk(1,'[사업장]')
	dw_ip.SetColumn("saupj")
	dw_ip.SetFocus()
	Return -1
END IF

if Ssaupj = "99" then Ssaupj = '%'

if IsNUll(DKFACDAT) then DKFACDAT = ""
if IsNUll(DTFACDAT) then DTFACDAT = ""

if DTFACDAT = "" then
   DTFACDAT = DKFACDAT
   dw_ip.SetItem(row_num,"TFACDAT",DTFACDAT)
end if

if DKFACDAT > DTFACDAT then
   Messagebox("확 인","처분일의 범위를 확인하시오. !")
   dw_ip.SetFocus()
   dw_ip.SetColumn(3)
   return -1
end if

TEMP_YMD = LEFT(DKFACDAT, 4) + '/' + MID(DKFACDAT, 5 ,2) + '/' + RIGHT(DKFACDAT, 2)
if NOT ISDATE(TEMP_YMD) Then
   Messagebox("확 인","FROM 처분일자는 유효한 일자 아닙니다. !")
   dw_ip.SetFocus()
   dw_ip.SetColumn(3)
   return -1
end if

TEMP_YMD = LEFT(DTFACDAT, 4) + '/' + MID(DTFACDAT, 5 ,2) + '/' + RIGHT(DTFACDAT, 2)
if NOT ISDATE(TEMP_YMD) Then
   Messagebox("확 인","TO 처분일자는 유효한 일자 아닙니다. !")
   dw_ip.SetFocus()
   dw_ip.SetColumn(6)
   return -1
end if

row_num = dw_print.Retrieve(DKFACDAT,DTFACDAT,SSAUPJ)
if row_num <= 0 then
   Messagebox("확 인","출력범위에 해당하는 자료가 없습니다. !")
   return -1
end if

dw_print.sharedata(dw_list)
dw_print.sharedata(dw_excel)

Return 1
end function

on w_kfab02.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.dw_excel=create dw_excel
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.dw_excel
this.Control[iCurrent+3]=this.rr_1
end on

on w_kfab02.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.dw_excel)
destroy(this.rr_1)
end on

event open;call super::open;
dw_ip.SetItem(1, "KFACDAT",Left(f_Today(),4)+'0101')
dw_ip.SetItem(1, "TFACDAT",f_Today())

dw_ip.SetItem(1, "saupj",   Gs_Saupj)

//dw_ip.Modify("saupj.protect = 1")
//dw_ip.Modify("saupj.background.color ='"+String(RGB(192,192,192))+"'")

end event

type p_xls from w_standard_print`p_xls within w_kfab02
end type

type p_sort from w_standard_print`p_sort within w_kfab02
end type

type p_preview from w_standard_print`p_preview within w_kfab02
end type

type p_exit from w_standard_print`p_exit within w_kfab02
end type

type p_print from w_standard_print`p_print within w_kfab02
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfab02
end type







type st_10 from w_standard_print`st_10 within w_kfab02
end type



type dw_print from w_standard_print`dw_print within w_kfab02
string dataobject = "dw_kfab02_2_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kfab02
integer x = 18
integer y = 32
integer width = 2126
integer height = 152
string dataobject = "dw_kfab02_1"
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

type dw_list from w_standard_print`dw_list within w_kfab02
integer x = 50
integer y = 192
integer width = 4553
integer height = 2072
string dataobject = "dw_kfab02_2"
boolean border = false
end type

type cb_1 from commandbutton within w_kfab02
integer x = 3433
integer y = 48
integer width = 398
integer height = 108
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "Excel 저장"
end type

event clicked;String docname, named
Long value
value = GetFileSaveName("Select File",	docname, named, "excel",  &
								" Excel Files (*.xls), *.xls")
SETPOINTER(HOURGLASS!)		
IF value = 1 THEN 			
	dw_excel.saveasascii(docname, '	', '')
END IF
end event

type dw_excel from datawindow within w_kfab02
boolean visible = false
integer x = 2350
integer y = 80
integer width = 704
integer height = 80
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "dw_kfab02_2_excel"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;SetTransObject(SQLCA)

end event

type rr_1 from roundrectangle within w_kfab02
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 188
integer width = 4585
integer height = 2084
integer cornerheight = 40
integer cornerwidth = 55
end type

