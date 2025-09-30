$PBExportHeader$w_mat_03570.srw
$PBExportComments$** 생산팀별 자재재고금액집계
forward
global type w_mat_03570 from w_standard_print
end type
type rr_1 from roundrectangle within w_mat_03570
end type
end forward

global type w_mat_03570 from w_standard_print
string title = "생산팀별 자재재고금액현황"
rr_1 rr_1
end type
global w_mat_03570 w_mat_03570

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String  sittyp, spdtgu, sgubun2, spdtnm, scuryymm, snull

IF dw_ip.AcceptText() = -1 THEN RETURN -1

SetNull(snull)

sittyp   = TRIM(dw_ip.GetItemString(1,"ittyp"))
spdtgu   = TRIM(dw_ip.GetItemString(1,"pdtgu"))
sgubun2  = TRIM(dw_ip.GetItemString(1,"gubun2"))
scuryymm = TRIM(left(f_today(),6))

if spdtgu = '' or isnull(spdtgu) then spdtgu = '%'
if sittyp = '' or isnull(sittyp) then sittyp = '%'

//IF dw_list.Retrieve(gs_sabu, spdtgu, sgubun2, sittyp, scuryymm) < 1 THEN
//	f_message_chk(50,'')
//	dw_ip.Setfocus()
//	return -1
//end if

IF dw_print.Retrieve(gs_sabu, spdtgu, sgubun2, sittyp, scuryymm) < 1 THEN
	dw_list.Reset()
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)

return 1



end function

on w_mat_03570.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_mat_03570.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

type p_preview from w_standard_print`p_preview within w_mat_03570
end type

type p_exit from w_standard_print`p_exit within w_mat_03570
end type

type p_print from w_standard_print`p_print within w_mat_03570
end type

type p_retrieve from w_standard_print`p_retrieve within w_mat_03570
end type







type st_10 from w_standard_print`st_10 within w_mat_03570
end type



type dw_print from w_standard_print`dw_print within w_mat_03570
string dataobject = "d_mat_03570_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_mat_03570
integer y = 24
integer width = 2208
integer height = 216
string dataobject = "d_mat_03570_a"
end type

event dw_ip::itemchanged;//string gubun1,snull
//
//setnull(snull)
//
//IF this.GetColumnName() ="gubun1" THEN
//	gubun1 = trim(this.GetText())
//	
//	if gubun1 = "" or isnull(gubun1) then	return 
//	
//   if gubun1 = '2' or gubun1 = '3' then 
//		SetItem(1, "pdtgu", sNull)
//		this.object.pdtgu.Protect = 1
//		return 
//	else
//		SetItem(1, "pdtgu", '1')
//		this.object.pdtgu.Protect = 0
//	end if
//
//END IF
//
end event

event dw_ip::itemerror;Return 1

end event

type dw_list from w_standard_print`dw_list within w_mat_03570
integer x = 50
integer y = 276
integer width = 4517
integer height = 2040
string dataobject = "d_mat_03570_1"
boolean border = false
end type

type rr_1 from roundrectangle within w_mat_03570
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 268
integer width = 4544
integer height = 2060
integer cornerheight = 40
integer cornerwidth = 55
end type

