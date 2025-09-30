$PBExportHeader$w_qct_05530.srw
$PBExportComments$자체교정검사성적서
forward
global type w_qct_05530 from w_standard_print
end type
type dw_1 from datawindow within w_qct_05530
end type
type p_sheet from uo_picture within w_qct_05530
end type
type rr_1 from roundrectangle within w_qct_05530
end type
end forward

global type w_qct_05530 from w_standard_print
integer height = 2408
string title = "자체 교정 검사 성적서"
dw_1 dw_1
p_sheet p_sheet
rr_1 rr_1
end type
global w_qct_05530 w_qct_05530

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string frdate, todate, mchno1, mchno2, sdata, buncd, buncd1

if dw_ip.accepttext() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

frdate  = Trim(dw_ip.GetItemString(1,'frdate'))
todate  = Trim(dw_ip.GetItemString(1,'todate'))
//mchno1  = Trim(dw_ip.GetItemString(1,'mchno1'))
//mchno2  = Trim(dw_ip.GetItemString(1,'mchno2'))
buncd  = trim(dw_ip.object.buncd[1])
buncd1 = trim(dw_ip.object.buncd1[1])

IF	IsNull(frdate) or frdate = '' then frdate = "10000101" 
IF	IsNull(todate) or todate = '' then todate = "99991231"
//IF	IsNull(mchno1) or mchno1 = '' then mchno1 = "."
//IF	IsNull(mchno2) or mchno2 = '' then mchno2 = "ZZZZZZ"
if (IsNull(buncd) or buncd = "" ) then buncd = '.'
if (IsNull(buncd1) or buncd1 = "" ) then buncd1 = 'zzzzzzzzzzzzz' 

//if dw_list.retrieve(gs_sabu, frdate, todate, buncd, buncd1 ) <= 0	then
//	f_message_chk(50,"[자체 교정 검사 성적서]")
//	p_sheet.Enabled = False
//	return -1
//end if

IF dw_print.retrieve(gs_sabu, frdate, todate, buncd, buncd1 ) <= 0	then
	f_message_chk(50,"[자체 교정 검사 성적서]")
	dw_list.Reset()
	dw_ip.SetFocus()
	dw_list.SetRedraw(true)
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)

select dataname into :sdata from syscnfg
 where sysgu = 'C' and serial = 7 and lineno = '1';

dw_print.object.txt_c71.text = Trim(sdata);
//dw_list.object.txt_c71.text = Trim(sdata);

select v.cvnas2 into :sdata from syscnfg s, vndmst v
 where s.sysgu = 'C' and s.serial = 4 and s.lineno = '1'
   and v.cvcod = s.dataname;

p_sheet.Enabled = True

Return 1

end function

on w_qct_05530.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.p_sheet=create p_sheet
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.p_sheet
this.Control[iCurrent+3]=this.rr_1
end on

on w_qct_05530.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.p_sheet)
destroy(this.rr_1)
end on

event open;call super::open;sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 가로방향"

dw_1.settransObject(sqlca)
end event

type p_preview from w_standard_print`p_preview within w_qct_05530
end type

type p_exit from w_standard_print`p_exit within w_qct_05530
integer taborder = 70
end type

type p_print from w_standard_print`p_print within w_qct_05530
end type

event p_print::clicked;Long lRtn,nRow, lseq
String sMchno
Integer RetVal, ix

IF dw_list.rowcount() > 0 then 
	gi_page = dw_list.GetItemNumber(1,"last_page")
ELSE
	gi_page = 1
END IF

OpenWithParm(w_print_options, dw_list)
lrtn = message.DoubleParm
If lRtn = -1 Then Return

dw_list.SetFocus()
	
OLEObject myoleobject
myoleobject = CREATE OLEObject

For ix = 1 To dw_list.RowCount()
	sMchNo = dw_list.GetItemString(ix, 'meskwa_mchno')
	lSeq   = dw_list.GetItemNumber(ix, 'meskwa_seq')

	If dw_1.retrieve(gs_sabu ,sMchNo, lSeq) > 0 Then
		dw_1.OLEActivate ( 1, 'mexcel', 1)
	
		IF myoleobject.ConnectToObject("", "excel.application") <> 0 THEN
			MessageBox('OLE Error','Unable to start an OLE server process!',Exclamation!)
			Return
		END IF
		
		MyOleObject.Application.Workbooks(1).PrintOut
		MyOleObject.Application.Workbooks(1).close
	End If
Next

MyOleObject.Application.Quit
      
RetVal = MyOleObject.DisconnectObject()
       
If RetVal < 0 then
	MessageBox("ERROR","DisconnectObject Failed")
End If

Destroy myoleobject
end event

type p_retrieve from w_standard_print`p_retrieve within w_qct_05530
end type







type st_10 from w_standard_print`st_10 within w_qct_05530
end type



type dw_print from w_standard_print`dw_print within w_qct_05530
integer x = 2533
integer y = 68
string dataobject = "d_qct_05530_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_05530
integer x = 471
integer y = 40
integer width = 1783
integer height = 208
string dataobject = "d_qct_05530_01"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_gubun)
setnull(gs_codename)

gs_code = '계측기'
Choose Case GetColumnName()
//	Case 'mchno1' 
//   	OPEN(w_mchno_popup)
//	   dw_ip.object.mchno1[1] = gs_code
//		dw_ip.object.mchnm1[1] = gs_codename
//	Case 'mchno2' 
//   	OPEN(w_mchno_popup)
//	   dw_ip.object.mchno2[1] = gs_code
//		dw_ip.object.mchnm2[1] = gs_codename
   Case "buncd" 
		gs_gubun = 'ALL'
		gs_code = '계측기'
		gs_codename = '계측기관리번호'
		open(w_mchno_popup)
		if isnull(gs_code) or gs_code = '' then return
		this.object.buncd[1] = gs_code
		
	Case "buncd1" 
		gs_gubun = 'ALL'
		gs_code = '계측기'
		gs_codename = '계측기관리번호'
		open(w_mchno_popup)
		if isnull(gs_code) or gs_code = '' then return
		this.object.buncd1[1] = gs_code		
End choose
end event

event dw_ip::itemchanged;String s_cod, s_nam, ls_buncd

s_cod = Trim(this.getText())

if this.GetColumnName() = "frdate" then 	
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[시작일자]")
		this.object.frdate[1] = ""
		return 1
	end if	
elseif this.GetColumnName() = "todate" then 	
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[끝일자]")
		this.object.todate[1] = ""
		return 1
	end if	
end if


end event

type dw_list from w_standard_print`dw_list within w_qct_05530
integer x = 494
integer y = 260
integer width = 3712
integer height = 2000
string dataobject = "d_qct_05530_02"
boolean border = false
end type

event dw_list::retrievestart;This.SetRedraw(False)
end event

event dw_list::retrieveend;This.SetRedraw(True)
end event

type dw_1 from datawindow within w_qct_05530
boolean visible = false
integer x = 2670
integer y = 56
integer width = 535
integer height = 104
integer taborder = 30
boolean bringtotop = true
boolean titlebar = true
string dataobject = "d_qct_05530_04"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type p_sheet from uo_picture within w_qct_05530
boolean visible = false
integer x = 3616
integer y = 24
integer width = 311
integer taborder = 90
boolean bringtotop = true
boolean enabled = false
string picturename = "C:\erpman\image\Sheet보기_up.gif"
end type

event clicked;Long nRow, lseq
String sMchno

dw_list.SetFocus()
//nRow = dw_list.GetRow()

nRow = Long(dw_list.describe("DataWindow.FirstRowOnPage" ))
If nRow <= 0 Then Return

sMchNo = dw_list.GetItemString(nRow, 'meskwa_mchno')
lSeq   = dw_list.GetItemNumber(nRow, 'meskwa_seq')

If dw_1.retrieve(gs_sabu,sMchNo, lSeq) > 0 Then
	dw_1.OLEActivate ( 1, 'mexcel', 0 )
Else
	MessageBox('확인', '조회된 자료가 없습니다.!!')
End If

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\Sheet보기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\Sheet보기_up.gif"
end event

type rr_1 from roundrectangle within w_qct_05530
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 480
integer y = 248
integer width = 3739
integer height = 2028
integer cornerheight = 40
integer cornerwidth = 55
end type

