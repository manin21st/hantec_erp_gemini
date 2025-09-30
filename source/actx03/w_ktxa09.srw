$PBExportHeader$w_ktxa09.srw
$PBExportComments$매입·매출 부가세 명세서 조회 및 출력
forward
global type w_ktxa09 from w_standard_print
end type
type rr_1 from roundrectangle within w_ktxa09
end type
end forward

global type w_ktxa09 from w_standard_print
integer x = 0
integer y = 0
string title = "매입·매출 부가세 명세서 조회 출력"
rr_1 rr_1
end type
global w_ktxa09 w_ktxa09

forward prototypes
public subroutine wf_choosedw (string sflag)
public function integer wf_retrieve ()
end prototypes

public subroutine wf_choosedw (string sflag);
dw_list.SetRedraw(false)
if sFlag = "1" then
	dw_list.DataObject = "dw_ktxa092"
	dw_print.DataObject = "dw_ktxa092_p"
   dw_list.title = "매입 부가세 명세서"
elseif sFlag = "2" then	
	dw_list.DataObject = "dw_ktxa093"
	dw_print.DataObject = "dw_ktxa093_p"
   dw_list.title = "매출 부가세 명세서"
elseif sFlag = "3" then
	dw_list.DataObject = "dw_ktxa094"
	dw_print.DataObject = "dw_ktxa094_p"
	dw_list.title = "매입 매출 부가세 명세서"
end if

dw_list.SetRedraw(true)

dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

end subroutine

public function integer wf_retrieve ();string ls_saupj, ls_gey_datef, ls_gey_datet, ls_jasa_cd, ls_tax_no, &
       ls_io_gu, ls_vatgbn
string get_saupj, get_ja, get_at, get_date

string snull
long ll_row

dw_list.reset()

if dw_ip.AcceptText() = -1 then return -1

ll_row = dw_ip.GetRow()

if ll_row < 1 then return -1

ls_gey_datef = Trim(dw_ip.GetItemString(ll_row, 'gey_datef'))
ls_gey_datet = Trim(dw_ip.GetItemString(ll_row, 'gey_datet'))
ls_jasa_cd   = dw_ip.GetItemString(ll_row, 'jasa_cd')
ls_tax_no    = dw_ip.GetItemString(ll_row, 'tax_no')
ls_io_gu     = dw_ip.GetItemString(ll_row, 'prtgbn')


if ls_gey_datef = '' or isnull(ls_gey_datef) then
	F_MessageChk(1, "[계산서 일자(FROM)]")
	dw_ip.SetColumn('gey_datef')
	dw_ip.SetFocus()
	return -1
else
	if f_datechk(ls_gey_datef) = -1 then 
		F_MessageChk(21, "[계산서 일자(FROM)]")		
		dw_ip.SetColumn('gey_datef')
		dw_ip.SetFocus()
		return -1
	end if
end if

if ls_gey_datet = '' or isnull(ls_gey_datet) then
	F_MessageChk(1, "[계산서 일자(TO)]")
	dw_ip.SetColumn('gey_datet')
	dw_ip.SetFocus()
	return -1
else
	if f_datechk(ls_gey_datet) = -1 then 
		F_MessageChk(21, "[계산서 일자(TO)]")		
		dw_ip.SetColumn('gey_datet')
		dw_ip.SetFocus()
		return -1
	end if
end if

if ls_gey_datef > ls_gey_datet then 
	MessageBox("확 인", "계산서 시작일자가 ~r~r 종료일자보다 클 수 없습니다.!!")
	dw_ip.SetColumn('gey_datef')
	dw_ip.SetFocus()
	return -1
end if

if trim(ls_jasa_cd) = '' or isnull(ls_jasa_cd) then 
   ls_jasa_cd = '%'
else
	SELECT "REFFPF"."RFGUB"  
	INTO :get_saupj
	FROM "REFFPF"
	WHERE "REFFPF"."RFCOD" = 'JA' and "REFFPF"."RFGUB" = :ls_jasa_cd ;
	if sqlca.sqlcode <> 0 then
		Messagebox("확 인","자사코드를 확인하십시오")
		dw_ip.SetItem(ll_row, "jasa_cd", snull)
		dw_ip.SetColumn('jasa_cd')
		dw_ip.SetFocus()
		return -1
	end if
end if

if trim(ls_tax_no) = '' or isnull(ls_tax_no) then 
   ls_tax_no = '%'
else
	SELECT "REFFPF"."RFGUB"  
	INTO :get_at
	FROM "REFFPF"
	WHERE "REFFPF"."RFCOD" = 'AT' and
			"REFFPF"."RFGUB" = :ls_tax_no and 
			"REFFPF"."RFGUB" <> '00'	;
	if sqlca.sqlcode <> 0 then
		Messagebox("확 인","자사코드를 확인하십시오")
		dw_ip.SetItem(ll_row, "tax_no", snull)
		dw_ip.SetColumn('tax_no')
		dw_ip.SetFocus()
		return -1
		
	end if
end if

//dw_list.Object.acc_yymm_t.text = trim(left(f_today(), 4)) + '.' + &
//                                 trim(mid(f_today(), 5, 2))
//											
//dw_list.Object.fromto_t.text = trim(left(ls_gey_datef, 4)) + '.' + &
//										 trim(mid(ls_gey_datef, 5, 2)) + '.' + &	
//										 trim(right(ls_gey_datef, 2)) + '-' + &
//                               trim(left(ls_gey_datet, 4)) + '.' + &
//										 trim(mid(ls_gey_datet, 5, 2)) + '.' + &	
//										 trim(right(ls_gey_datet, 2))

get_date = string(ls_gey_datef, '@@@@.@@.@@') + ' - ' + string(ls_gey_datet, '@@@@.@@.@@')
										 
dw_list.SetRedraw(false)

dw_print.object.fromto_t.text = get_date

if dw_print.retrieve(ls_gey_datef, ls_gey_datet,ls_jasa_cd, ls_tax_no, ls_io_gu) < 1 then
   F_MessageChk(14, "")
	dw_ip.SetColumn('gey_datet')
	dw_ip.Setfocus()
   dw_list.SetRedraw(true)	
	//return -1
end if
dw_list.SetRedraw(true)	

dw_print.sharedata(dw_list)

return 1
end function

on w_ktxa09.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_ktxa09.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;
dw_ip.SetItem(1, 'saupj', '1')
dw_ip.SetItem(1, 'gey_datef', trim(left(f_today(), 6)) + '01')
dw_ip.SetItem(1, 'gey_datet', f_today())


end event

type p_preview from w_standard_print`p_preview within w_ktxa09
integer x = 4091
integer taborder = 30
string pointer = ""
end type

type p_exit from w_standard_print`p_exit within w_ktxa09
integer taborder = 50
string pointer = ""
end type

type p_print from w_standard_print`p_print within w_ktxa09
integer taborder = 40
string pointer = ""
end type

type p_retrieve from w_standard_print`p_retrieve within w_ktxa09
integer taborder = 20
string pointer = ""
end type







type st_10 from w_standard_print`st_10 within w_ktxa09
end type



type dw_print from w_standard_print`dw_print within w_ktxa09
string dataobject = "dw_ktxa092_p"
end type

type dw_ip from w_standard_print`dw_ip within w_ktxa09
integer x = 46
integer y = 28
integer width = 3515
integer height = 232
integer taborder = 10
string dataobject = "dw_ktxa091"
end type

event dw_ip::itemchanged;string ls_saupj, ls_gey_datef, ls_gey_datet, ls_jasa_cd, ls_tax_no, &
       get_saupj, get_ja, get_at,sPrtGbn
string snull

SetNull(snull)

if this.GetColumnName() = 'gey_datef' then 
	ls_gey_datef = trim(this.GetText())
   if ls_gey_datef = '' or isnull(ls_gey_datef) then
      F_MessageChk(1, "[계산서 일자(FROM)]")
		return 1
	end if
	if f_datechk(ls_gey_datef) = -1 then 
      F_MessageChk(21, "[계산서 일자(FROM)]")		
		return 1
	end if
end if

if this.GetColumnName() = 'gey_datet' then 
	ls_gey_datet = trim(this.GetText())
	ls_gey_datef = trim(this.GetItemString(this.GetRow(), 'gey_datef'))
	
   if ls_gey_datet = '' or isnull(ls_gey_datet) then
      F_MessageChk(1, "[계산서 일자(TO)]")
		return 1
	end if
	if f_datechk(ls_gey_datet) = -1 then 
      F_MessageChk(21, "[계산서 일자(TO)]")		
		return 1
	end if
	
	if ls_gey_datef > ls_gey_datet then
		MessageBox("확 인", "계산서 시작일자가 ~r~r종료일자보다 클 수 없습니다.!!")
		return 1
	end if
end if

if this.GetColumnName() = 'jasa_cd' then 
   ls_jasa_cd = this.GetText()
	
	if trim(ls_jasa_cd) = '' or isnull(ls_saupj) then 
		return 1
	end if
	
	SELECT "REFFPF"."RFGUB"     INTO :get_ja
	   FROM "REFFPF"
   	WHERE "REFFPF"."RFCOD" = 'JA' and "REFFPF"."RFGUB" = :ls_jasa_cd and 
				"REFFPF"."RFGUB" <> '00'	;
   if sqlca.sqlcode <> 0 then
      Messagebox("확 인","자사 코드를 확인하십시오")
      this.SetItem(row, "jasa_cd", snull)
      return 1
   end if
end if

if this.GetColumnName() = 'tax_no' then 
	
   ls_tax_no = this.GetText()
	
	if trim(ls_tax_no) = '' or isnull(ls_tax_no) then 
		return 1
	end if
	
	SELECT "REFFPF"."RFGUB"     INTO :get_at
	   FROM "REFFPF"
   	WHERE "REFFPF"."RFCOD" = 'AT' and "REFFPF"."RFGUB" = :ls_tax_no and 
				"REFFPF"."RFGUB" <> '00'	;
   if sqlca.sqlcode <> 0 then
      Messagebox("확 인","자사 코드를 확인하십시오")
      this.SetItem(row, "tax_no", snull)
      return 1
   end if	
end if

if this.GetColumnName() = 'prtgbn' then 	
   sPrtGbn = this.GetText()
	
	Wf_ChooseDw(sPrtGbn)
end if





end event

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_ktxa09
integer x = 59
integer y = 272
integer width = 4530
integer height = 2032
string title = "매입 부가세 명세서"
string dataobject = "dw_ktxa092"
boolean border = false
boolean hsplitscroll = false
end type

type rr_1 from roundrectangle within w_ktxa09
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 260
integer width = 4562
integer height = 2056
integer cornerheight = 40
integer cornerwidth = 55
end type

