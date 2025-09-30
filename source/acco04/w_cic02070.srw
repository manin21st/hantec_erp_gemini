$PBExportHeader$w_cic02070.srw
$PBExportComments$매출원가계산서
forward
global type w_cic02070 from w_standard_print
end type
end forward

global type w_cic02070 from w_standard_print
integer width = 4695
integer height = 3220
string title = "매출원가계산서"
end type
global w_cic02070 w_cic02070

type variables
string is_fyymm, is_tyymm, is_saupj
DatawindowChild idwc_saupj
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();//string snull
//SetNull(snull)
//
//if IsNull(is_fyymm) or is_fyymm = "" or IsNull(is_tyymm) or is_tyymm = "" then
//	 messagebox("확인","조회년월을 입력하세요!")
//	 dw_ip.SetColumn("fyymm")
//	 dw_ip.Setfocus()
//	 return -1
//end if
//
//IF is_saupj = '%' THEN
//	dw_print.modify("saupj_t.text = '"+'전체'+"'")
//ELSE
//   dw_print.modify("saupj_t.text = '" + Trim(dw_ip.Describe("Evaluate('LookUpDisplay(saupj)', 1)")) + "'")
//END IF
//
//if dw_print.Retrieve(is_saupj, is_fyymm, is_tyymm) < 1 then
//	 w_mdi_frame.sle_msg.text = "조회할 자료가 없습니다!"
//   return -1
//end if
//
return 1
end function

on w_cic02070.create
call super::create
end on

on w_cic02070.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;//dw_ip.Setitem(1,"saupj", gs_saupj)
//dw_ip.Setitem(1, "fyymm", left(f_today(),4) +'01')
//dw_ip.Setitem(1, "tyymm", left(f_aftermonth(f_today(), -1),6))
//
//is_fyymm = left(f_today(),4) +'01'
//is_tyymm = left(f_aftermonth(f_today(), -1),6)
//is_saupj = gs_saupj
String sWorkym

//사업장 Datawindows Child
dw_ip.getChild('saupj', idwc_saupj)
idwc_saupj.SettransObject(sqlca)
idwc_saupj.Retrieve()
dw_ip.SetTransObject(sqlca)
dw_ip.Reset()
dw_ip.InsertRow(0)
idwc_saupj.InsertRow(1)
idwc_saupj.SetItem(1,'rfna1','') //''를 선택하면 전체조회를 시킬 것임
idwc_saupj.SetItem(1,'rfgub','')


dw_ip.SetTransObject(SQLCA)
dw_ip.Reset()
dw_ip.InsertRow(0)

dw_list.SetTransObject(SQLCA)

//IF F_Authority_Chk(Gs_Dept) = -1 THEN			/*권한 체크- 현업 여부*/
//	IF F_Change_Saupj_Chk(Gs_Empno) = -1 THEN			
//		dw_ip.Modify("saupj.protect = 1")
//		//dw_ip.Modify("sawon.protect = 1")		
//	else 
//		dw_ip.Modify("saupj.protect = 0")
//		//dw_ip.Modify("sawon.protect = 0")		
//	end if 
//ELSE
//	dw_ip.Modify("saupj.protect = 0")
//	//dw_ip.Modify("sawon.protect = 0")	
//END IF	

SELECT  nvl(max(workym),substr(to_char(sysdate,'yyyymmdd'),1,6))
   INTO  :sWorkym
   FROM  cic0100;
	
//dw_ip.SetItem(1, 'fyymm', f_aftermonth( Left(f_today(),6), -1))
//dw_ip.SetItem(1, 'tyymm', f_aftermonth( Left(f_today(),6), -1))
dw_ip.SetItem(1, 'fyymm', sWorkym)
dw_ip.SetItem(1, 'tyymm', sWorkym)
end event

type p_xls from w_standard_print`p_xls within w_cic02070
end type

type p_sort from w_standard_print`p_sort within w_cic02070
end type

type p_preview from w_standard_print`p_preview within w_cic02070
end type

type p_exit from w_standard_print`p_exit within w_cic02070
end type

type p_print from w_standard_print`p_print within w_cic02070
end type

type p_retrieve from w_standard_print`p_retrieve within w_cic02070
end type

event p_retrieve::clicked;call super::clicked;String sworkym_f, sworkym_t, sSaupj
Long	 lRowcnt

If dw_ip.Accepttext() = -1 Then Return

sworkym_f = Trim(dw_ip.GetItemString(dw_ip.GetRow(), 'fyymm'))
is_fyymm = sworkym_f
If sworkym_f = "" Or IsNull(sworkym_f) Then
	f_messagechk(1, '[조회년월-From]')
	dw_ip.SetColumn('workym_f')
	dw_ip.SetFocus()
	Return
End If

sworkym_t = Trim(dw_ip.GetItemString(dw_ip.GetRow(), 'tyymm'))
is_tyymm = sworkym_t
If sworkym_t = "" Or IsNull(sworkym_t) Then
	f_messagechk(1, '[조회년월-To]')
	dw_ip.SetColumn('workym_t')
	dw_ip.SetFocus()
	Return
End If



sSaupj = Trim(dw_ip.GetItemString(dw_ip.GetRow(), 'Saupj'))
If sSaupj = "" Or IsNull(sSaupj) Then
   sSaupj = '%'
End If


w_mdi_frame.sle_msg.Text = "조회 중입니다.!!!"
SetPointer(HourGlass!)
dw_list.SetRedraw(False)
lRowcnt = dw_list.Retrieve(sSaupj, sworkym_f, sworkym_t)
If lRowcnt <=0 Then
	f_messagechk(14, '')
	dw_ip.SetFocus()
	dw_list.SetRedraw(True)
	w_mdi_frame.sle_msg.text = ""
	SetPointer(Arrow!)
	Return
Else
	dw_list.sharedata(dw_print)
	dw_list.SetFocus()
End If


//ShareData로 사용하여 dw_print를 조회시키기때문에 Share되지 않는 아규먼트 데이터 처리는 여기서 해줌
//dw_print.object.t_arg_item.text = "조회년월 : " + left(sworkym_f,4) + '.' + right(sworkym_f,2) + " - " + & 
//                                                  left(sworkym_t,4) + '.' + right(sworkym_t,2)
if sSaupj='%' then 
   dw_print.object.t_arg_saupJ.text = "사업장 : 전체"
else
   dw_print.object.t_arg_saupJ.text = "사업장 : " + idwc_saupj.GetItemString(idwc_saupj.Getrow(), 'rfna1')
end if


dw_list.SetRedraw(True)
w_mdi_frame.sle_msg.text = "조회가 완료되었습니다.!!!"
SetPointer(Arrow!)
end event







type st_10 from w_standard_print`st_10 within w_cic02070
end type



type dw_print from w_standard_print`dw_print within w_cic02070
string dataobject = "dw_cic02070_2_p"
end type

type dw_ip from w_standard_print`dw_ip within w_cic02070
integer width = 2555
integer height = 216
string dataobject = "dw_cic02070_1"
end type

event dw_ip::itemchanged;call super::itemchanged;string snull
SetNull(snull)

if dw_ip.Accepttext() = -1 then return

if This.GetColumnName() = "fyymm" then
	is_fyymm = data
	if IsNull(is_fyymm) or is_fyymm = "" then 
	 	 messagebox("확인","년월을 입력하세요!")
		 dw_ip.SetItem(1,"fyymm", snull)
		 dw_ip.SetColumn("fyymm")
		 dw_ip.Setfocus()
		 return
	end if

	if f_datechk(is_fyymm+'01') = -1 then
		messagebox("확인","년월을 확인하세요!")
		dw_ip.SetItem(1,"fyymm", snull)
		dw_ip.SetColumn("fyymm")
		dw_ip.Setfocus()
		return
	end if	
end if	

if This.GetColumnName() = "tyymm" then
	is_tyymm = data
	if IsNull(is_tyymm) or is_tyymm = "" then 
	 	 messagebox("확인","년월을 입력하세요!")
		 dw_ip.SetItem(1,"tyymm", snull)
		 dw_ip.SetColumn("tyymm")
		 dw_ip.Setfocus()
		 return
	end if

	if f_datechk(is_tyymm+'01') = -1 then
		messagebox("확인","년월을 확인하세요!")
		dw_ip.SetItem(1,"tyymm", snull)
		dw_ip.SetColumn("tyymm")
		dw_ip.Setfocus()
		return
	end if	
end if	

if is_fyymm > is_tyymm then
	 messagebox("확인","시작년월이 종료년월보다 클 수 없습니다!")
	 dw_ip.SetItem(1,"fyymm", snull)
	 dw_ip.SetColumn("fyymm")
	 dw_ip.Setfocus()
	 return
end if


if This.GetColumnName() = "saupj" then
	is_saupj = This.Gettext()
	if IsNull(is_saupj) or is_saupj = "" then is_saupj = '%'
end if


end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_cic02070
integer y = 232
integer height = 2020
string dataobject = "dw_cic02070_2"
end type

