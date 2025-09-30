$PBExportHeader$w_imt_04690.srw
$PBExportComments$매입마감 요약(거래처별)
forward
global type w_imt_04690 from w_standard_print
end type
type pb_1 from u_pb_cal within w_imt_04690
end type
type pb_2 from u_pb_cal within w_imt_04690
end type
type rr_1 from roundrectangle within w_imt_04690
end type
type rr_2 from roundrectangle within w_imt_04690
end type
end forward

global type w_imt_04690 from w_standard_print
integer height = 2500
string title = "매입마감 요약(거래처별)"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
rr_2 rr_2
end type
global w_imt_04690 w_imt_04690

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string sYm, sIttyp, smaip,sSaupj, sTitle, sAmt1, sAmt2, sGu, sGunm, sGubn

IF dw_ip.AcceptText() = -1 THEN RETURN -1

sYm  	 = trim(dw_ip.GetItemString(1, "ym"))
sIttyp = dw_ip.GetItemString(1, "ittyp")
ssaupj = dw_ip.GetItemString(1, "saupj")
sMaip  = dw_ip.GetItemString(1, "maip")
sGubn  = dw_ip.GetItemString(1, "gubun")

if IsNull(sIttyp) or trim(sIttyp) = ''	THEN sIttyp = '%'

if IsNull(sym) or sym = "" then 
	f_message_chk(30, "[마감년월]")
	dw_ip.setcolumn('ym')
	dw_ip.setfocus()
	return -1
end if	

dw_print.setredraw(false)
if sGubn = '0' then 
	dw_list.dataobject =  'd_imt_04690_1'    
	dw_print.dataobject = 'd_imt_04690_1_p'
else
	dw_list.dataobject =  'd_imt_04690_2'    
	dw_print.dataobject = 'd_imt_04690_2_p'
end if
dw_print.settransobject(sqlca) 
dw_print.setredraw(true)

if sGubn = '1' then
	if dw_print.Retrieve(sYm) <= 0 then
		f_message_chk(50,'[거래처별 마감 요약]')
		dw_ip.Setfocus()
		return -1
	end if
	dw_print.Modify( "t_ym.Text='" + String(sym, '@@@@.@@') + "'")

Else	
		if dw_print.Retrieve(sYm, sMaip, sIttyp) <= 0 then
			f_message_chk(50,'[거래처별 마감 요약]')
			dw_ip.Setfocus()
			return -1
		end if
		
		if sMaip = 'S' then
			sTitle = '월 사급매출 내역'
			sAmt1  = '원자재' 
			sAmt2  = '원자재 외' 
		Else
			sTitle = '월 입고 내역'
			sAmt1  = '입고금액' 
			sAmt2  = '불량금액' 
		End if
		
		if sMaip = 'S' then
			sGunm = ' '
		Else
			if sIttyp = '%' then 
				sGunm = '(품목 : 전체)' 
			Else
				select trim(rfna1) into :sGu 
				  from reffpf 
				 where sabu = :gs_sabu and rfcod = '05' and rfgub = :sIttyp;
				sGunm = '(품목 : ' + sGu + ')'
			End if
		End if
			
		dw_print.Modify( "t_ym.Text='" + String(sym, '@@@@.@@') + "'")
		dw_print.Modify( "t_title.Text='" + sTiTle + "'")
		dw_print.Modify( "t_amt1.Text='" + samt1 + "'")
		dw_print.Modify( "t_amt2.Text='" + samt2 + "'")
		dw_print.Modify( "t_ittyp.Text='" + sgunm + "'")
		dw_list.Modify( "t_amt1.Text='" + samt1 + "'")
		dw_list.Modify( "t_amt2.Text='" + samt2 + "'")
End if
dw_print.sharedata(dw_list)
Return 1


end function

on w_imt_04690.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.rr_1
this.Control[iCurrent+4]=this.rr_2
end on

on w_imt_04690.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event ue_open;call super::ue_open;is_today = f_today()

dw_ip.SetTransObject(sqlca)
dw_list.SetTransObject(sqlca)
dw_print.SetTransObject(sqlca)

dw_ip.InsertRow(0)
dw_ip.SetItem(1, 'ym', Left(is_today,6))

/* 부가 사업장 */
//f_mod_saupj(dw_ip,'saupj')

/* MRO 부서인 경우 */
string sdepot

//select cvcod into :sdepot from vndmst
// where cvgu = '5' and juprod = 'Z' and deptcode in ( Select deptcode  from p1_master where empno = :gs_empno ) and rownum = 1;
//
//if sqlca.sqlcode = 0 then
//	dw_ip.setitem(1,'house',sdepot)
//	dw_ip.Object.house.protect = '1'
//end if
//
//dw_ip.SetFocus()
//dw_ip.SetColumn('dategubun')
end event

type p_xls from w_standard_print`p_xls within w_imt_04690
end type

type p_sort from w_standard_print`p_sort within w_imt_04690
end type

type p_preview from w_standard_print`p_preview within w_imt_04690
integer taborder = 60
end type

type p_exit from w_standard_print`p_exit within w_imt_04690
integer taborder = 80
end type

type p_print from w_standard_print`p_print within w_imt_04690
integer taborder = 70
end type

type p_retrieve from w_standard_print`p_retrieve within w_imt_04690
integer taborder = 30
end type







type st_10 from w_standard_print`st_10 within w_imt_04690
end type



type dw_print from w_standard_print`dw_print within w_imt_04690
string dataobject = "d_imt_04690_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_04690
integer x = 37
integer y = 52
integer width = 2117
integer height = 204
string dataobject = "d_imt_04690"
boolean livescroll = false
end type

event dw_ip::rbuttondown;//SetNull(Gs_Code)
//SetNull(Gs_CodeName)
//
//Choose Case this.GetColumnName() 
// Case "scvcod"
//	Gs_gubun = '1' 
//	
//	Open(w_vndmst_popup)
//	
//	IF gs_code ="" OR IsNull(gs_code) THEN RETURN
//	
//	this.SetItem(1,"scvcod",gs_code)
//	this.SetItem(1,"cvname",gs_codename)
//end choose
end event

event itemerror;
Return 1
end event

event dw_ip::itemchanged;string	sMaip, sNull, sname, sname2 
Int      iReturn

SetNull(sNull)

IF this.GetColumnName() = 'maip' THEN
	sMaip  = this.gettext()
	
	IF sMaip = 'Y'  then 
//		this.setitem(1, "ittyp", 'A')
	End if
End if
end event

type dw_list from w_standard_print`dw_list within w_imt_04690
integer x = 32
integer y = 320
integer width = 4549
integer height = 1976
integer taborder = 50
string dataobject = "d_imt_04690_1"
boolean border = false
end type

type pb_1 from u_pb_cal within w_imt_04690
boolean visible = false
integer x = 3520
integer y = 272
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('sdate')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'sdate', gs_code)



end event

type pb_2 from u_pb_cal within w_imt_04690
boolean visible = false
integer x = 3959
integer y = 292
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('edate')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'edate', gs_code)



end event

type rr_1 from roundrectangle within w_imt_04690
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 18
integer y = 32
integer width = 2528
integer height = 236
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_imt_04690
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 300
integer width = 4585
integer height = 2012
integer cornerheight = 40
integer cornerwidth = 55
end type

