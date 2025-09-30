$PBExportHeader$w_kfia53.srw
$PBExportComments$월자금 소요계획 조회 및 출력
forward
global type w_kfia53 from w_standard_print
end type
type rr_1 from roundrectangle within w_kfia53
end type
end forward

global type w_kfia53 from w_standard_print
integer x = 0
integer y = 0
string title = "월 자금 수지계획"
rr_1 rr_1
end type
global w_kfia53 w_kfia53

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string  sSaupj, sDeptCode, sYearMonth, sGubun,snull
long    ll_row

SetNull(snull)

dw_list.Reset()

ll_row = dw_ip.GetRow()
If ll_row < 1 then   return -1

If dw_ip.AcceptText() = -1 then return -1
sYearMonth = dw_ip.GetItemString(ll_row, 'acc_yymm')
sSaupj     = dw_ip.GetItemString(ll_row, 'saupj')
sDeptCode  = dw_ip.GetItemString(ll_row, 'dept')
sGubun	  = dw_ip.GetItemString(ll_row, 'gubun')

if trim(sYearMonth) = '' or isnull(sYearMonth) then 
	F_MessageChk(1, "[회계년월]")
	return -1
Else
	If F_dateChk(sYearMonth +'01') = -1 then 
		MessageBox("확 인", "유효한 회계년월이 아닙니다.!!")
		return -1
	End If
End If

If trim(sSaupj) = '' or IsNUll(sSaupj) or sSaupj = '99' then sSaupj = '%'
If trim(sDeptCode) = '' or IsNull(sDeptCode) then	sDeptCode = '%'
if sGubun = '1' then sGubun = '%'

If dw_print.retrieve(sYearMonth, sSaupj, sDeptCode,sGubun) < 1 then 
	F_MessageChk(14, "")
	dw_ip.SetColumn('acc_yymm')
	dw_ip.SetFocus()
	dw_list.insertrow(0)
	//return -1
End If
  dw_print.sharedata(dw_list)
Return 1

end function

event open;call super::open;Integer iRtnVal

sle_msg.text = ""

sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 세로방향"

dw_ip.SetItem(dw_ip.GetRow(), 'acc_yymm', left(f_today(), 6))

dw_ip.SetItem(1,"dept",gS_dept)
dw_ip.SetItem(1,"saupj",gS_saupj)

IF Upper(Mid(is_window_id,4,2)) = 'BG' THEN							   /*예산*/
	IF F_Valid_EmpNo(Gs_EmpNo) = 'N' THEN									/*권한 체크- 현업 여부*/
		dw_ip.SetItem(dw_ip.GetRow(),"saupj",   Gs_Saupj)
		
		dw_ip.Modify("saupj.protect = 1")
//		dw_ip.Modify("saupj.background.color ='"+String(RGB(192,192,192))+"'")
	ELSE
		dw_ip.Modify("saupj.protect = 0")
//		dw_ip.Modify("saupj.background.color ='"+String(RGB(190,225,184))+"'")
	END IF
ELSE
	IF Upper(Mid(is_window_id,4,2)) = 'FI' THEN							/*자금*/
		iRtnVal = F_Authority_Fund_Chk(Gs_Dept)	
	ELSE
		iRtnVal = F_Authority_Chk(Gs_Dept)
	END IF
	IF iRtnVal = -1 THEN															/*권한 체크- 현업 여부*/
		dw_ip.SetItem(dw_ip.GetRow(),"saupj",   Gs_Saupj)
		
		dw_ip.Modify("saupj.protect = 1")
//		dw_ip.Modify("saupj.background.color ='"+String(RGB(192,192,192))+"'")
		dw_ip.Modify("dept.protect = 1")
//		dw_ip.Modify("dept.background.color ='"+String(RGB(192,192,192))+"'")
		
	ELSE
		dw_ip.Modify("saupj.protect = 0")
//		dw_ip.Modify("saupj.background.color ='"+String(RGB(255,255,255))+"'")
		dw_ip.Modify("dept.protect = 0")
//		dw_ip.Modify("dept.background.color ='"+String(RGB(255,255,255))+"'")
	END IF	
END IF

dw_ip.SetColumn('acc_yymm')
dw_ip.SetFocus()

end event

on w_kfia53.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kfia53.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

type p_preview from w_standard_print`p_preview within w_kfia53
end type

type p_exit from w_standard_print`p_exit within w_kfia53
end type

type p_print from w_standard_print`p_print within w_kfia53
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfia53
end type

type st_window from w_standard_print`st_window within w_kfia53
integer x = 2382
end type

type sle_msg from w_standard_print`sle_msg within w_kfia53
integer width = 1984
end type

type dw_datetime from w_standard_print`dw_datetime within w_kfia53
integer x = 2839
end type



type gb_10 from w_standard_print`gb_10 within w_kfia53
integer y = 5000
integer width = 3589
integer height = 152
integer textsize = -12
fontcharset fontcharset = defaultcharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
end type

type dw_print from w_standard_print`dw_print within w_kfia53
string dataobject = "dw_kfia53_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kfia53
integer x = 0
integer y = 0
integer width = 2039
integer height = 316
string dataobject = "dw_kfia53_01"
end type

event dw_ip::itemchanged;string ls_saupj, ls_dept, ls_acc_yymm, snull

If this.GetColumnName() = 'saupj' then
	ls_saupj = this.GetText()
	If trim(ls_saupj) = '' or IsNUll(ls_saupj) then
		ls_saupj = '%'
	else
		this.SetItem(1,"gubun",'2')
	End If
End If

If this.GetColumnName() = 'dept' then
	ls_dept = this.GetText()
	If trim(ls_dept) = '' or IsNull(ls_dept) then
		ls_dept = '%'
	else
		this.SetItem(1,"gubun",'2')		
	End If
End If

If this.GetColumnName() = 'acc_yymm' then
	ls_acc_yymm = this.GetText()
	If trim(ls_acc_yymm) = '' or isnull(ls_acc_yymm) then 
		F_MessageChk(1, "[회계년월]")
		return 1
	Else
		If F_dateChk(ls_acc_yymm +'01') = -1 then 
			MessageBox("확 인", "유효한 회계년월이 아닙니다.!!")
			return 1
		End If
	End If
End If
end event

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_kfia53
integer x = 50
integer y = 352
integer width = 4539
integer height = 1892
string dataobject = "dw_kfia53_02"
boolean border = false
end type

type rr_1 from roundrectangle within w_kfia53
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 320
integer width = 4599
integer height = 1948
integer cornerheight = 40
integer cornerwidth = 55
end type

