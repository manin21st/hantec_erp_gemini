$PBExportHeader$w_kfia33.srw
$PBExportComments$지급어음 예정결제 현황 조회 출력
forward
global type w_kfia33 from w_standard_print
end type
type rr_1 from roundrectangle within w_kfia33
end type
end forward

global type w_kfia33 from w_standard_print
integer x = 0
integer y = 0
integer height = 2444
string title = "지급어음 예정결제현황 조회 출력"
rr_1 rr_1
end type
global w_kfia33 w_kfia33

type prototypes
FUNCTION long ShellExecuteA &
    (long hwnd, string lpOperation, &
    string lpFile, string lpParameters,  string lpDirectory, &
    integer nShowCmd ) LIBRARY "SHELL32"

end prototypes
type variables

end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string sbnkf, sbnkt, sdatef, sdatet

IF dw_ip.AcceptText() = -1 THEN RETURN -1

sbnkf  =dw_ip.GetItemString(dw_ip.Getrow(),"bankf")
sbnkt  =dw_ip.GetItemString(dw_ip.Getrow(),"bankt")

sdatef = Trim(dw_ip.GetItemString(dw_ip.Getrow(),"datef"))
sdatet = Trim(dw_ip.GetItemString(dw_ip.Getrow(),"datet"))

IF sbnkf > sbnkt THEN
	MessageBox("확  인","지급은행 범위가 잘못 지정되었습니다. 확인하세요.!!!")
	Return -1
END IF
	
IF DaysAfter(Date(Left(sdatef,4)+"/"+Mid(sdatef,5,2)+"/"+Right(sdatef,2)),&
				 Date(Left(sdatet,4)+"/"+Mid(sdatet,5,2)+"/"+Right(sdatet,2))) < 0 THEN
	MessageBox("확  인","날짜 범위가 잘못 지정되었습니다. 확인하세요.!!!")
	dw_ip.SetColumn("datet")
	dw_ip.SetFocus()
	Return -1
END IF

IF dw_print.Retrieve(sdatef,sdatet, sbnkf, sbnkt) <=0 THEN
	F_MessageChk(14,"") 
//	Return -1
	dw_list.insertrow(0)
END IF

dw_print.sharedata(dw_list)

Return 1
end function

on w_kfia33.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kfia33.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;String sbnk_min,sbnk_max

SELECT MIN("KFZ04OM0"."PERSON_CD"),MAX("KFZ04OM0"."PERSON_CD")  
   INTO :sbnk_min,:sbnk_max
   FROM "KFZ04OM0"  
   WHERE ( "KFZ04OM0"."PERSON_GU" = '2' ) ;

dw_ip.SetItem(dw_ip.GetRow(),"bankf",sbnk_min)
dw_ip.SetItem(dw_ip.Getrow(),"bankt",sbnk_max)

dw_ip.SetItem(dw_ip.GetRow(),"datef",String(today(),"yyyymm")+'01')
dw_ip.SetItem(dw_ip.GetRow(),"datet",String(today(),"yyyymmdd"))
dw_ip.SetColumn("bankf")
dw_ip.Setfocus()
end event

type p_xls from w_standard_print`p_xls within w_kfia33
boolean visible = true
integer x = 3749
integer y = 0
end type

event p_xls::clicked;String	ls_path, ls_file
Int		li_rc 

li_rc = GetFileSaveName('Save As', ls_path, ls_file,  'xls',  'Excel Files (*.xls),*.xls' )

IF li_rc <> 1 THEN Return -1

u_SaveAsExcel luo_excel

li_rc = luo_excel.uf_DwToExcel(dw_print, ls_path)

if li_rc > 0 then
	if luo_excel.uf_RunExcel(ls_path) < 1 then
		MessageBox("Execute Error" , ls_path + " Execute File Error." , Exclamation!)
		return -1
	end if
else
	MessageBox("Error" , "Conversion Error!" , Exclamation!)
	return -1
end if
end event

type p_sort from w_standard_print`p_sort within w_kfia33
end type

type p_preview from w_standard_print`p_preview within w_kfia33
integer y = 4
end type

type p_exit from w_standard_print`p_exit within w_kfia33
integer y = 4
end type

type p_print from w_standard_print`p_print within w_kfia33
integer y = 4
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfia33
integer y = 4
end type

type st_window from w_standard_print`st_window within w_kfia33
boolean visible = false
end type

type sle_msg from w_standard_print`sle_msg within w_kfia33
boolean visible = false
end type

type dw_datetime from w_standard_print`dw_datetime within w_kfia33
boolean visible = false
end type

type st_10 from w_standard_print`st_10 within w_kfia33
boolean visible = false
end type

type gb_10 from w_standard_print`gb_10 within w_kfia33
boolean visible = false
end type

type dw_print from w_standard_print`dw_print within w_kfia33
string dataobject = "d_kfia33_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kfia33
integer x = 32
integer y = 8
integer width = 3671
integer height = 156
string dataobject = "d_kfia33_0"
end type

event dw_ip::itemchanged;String snull

SetNull(snull)

IF dwo.name ="datef" THEN
	
	IF Trim(data) ="" OR IsNull(Trim(data)) THEN RETURN
	
	IF f_datechk(Trim(data)) = -1 THEN 
		f_messagechk(20,"날짜")
		dw_ip.SetItem(dw_ip.Getrow(),"datef",snull)
		Return 1
	END IF
END IF

IF dwo.name ="datet" THEN
	
	IF Trim(data) ="" OR IsNull(Trim(data)) THEN RETURN
	
	IF f_datechk(Trim(data)) = -1 THEN 
		f_messagechk(20,"날짜")
		dw_ip.SetItem(dw_ip.Getrow(),"datet",snull)
		Return 1
	END IF
END IF

IF dwo.name = "gubun" THEN
	dw_ip.SetRedraw(False)
	IF data = '1' THEN
		dw_list.Title ="지급어음 예정결제현황(요약)"
		dw_list.DataObject ="d_kfia33_1"
		dw_print.DataObject ="d_kfia33_1_p"
	ELSEIF data = '2' THEN
		dw_list.Title ="지급어음 예정결제현황(상세)"
		dw_list.DataObject ="d_kfia33_2"
		dw_print.DataObject ="d_kfia33_2_p"
	END IF
	dw_ip.SetRedraw(True)
	dw_list.SetTransObject(SQLCA)
	dw_print.SetTransObject(SQLCA)
	dw_print.object.datawindow.print.preview = "yes"
END IF
end event

event dw_ip::itemerror;Return 1
end event

type dw_list from w_standard_print`dw_list within w_kfia33
integer x = 41
integer y = 176
integer width = 4576
integer height = 2068
string dataobject = "d_kfia33_1"
boolean border = false
end type

type rr_1 from roundrectangle within w_kfia33
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 172
integer width = 4599
integer height = 2084
integer cornerheight = 40
integer cornerwidth = 55
end type

