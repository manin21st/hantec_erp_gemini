$PBExportHeader$w_pdt_t_10220.srw
$PBExportComments$년 비가동손실비용 현황
forward
global type w_pdt_t_10220 from w_standard_print
end type
type rr_1 from roundrectangle within w_pdt_t_10220
end type
end forward

global type w_pdt_t_10220 from w_standard_print
string title = "년 비가동 손실비용 현황"
string menuname = ""
boolean maxbox = true
rr_1 rr_1
end type
global w_pdt_t_10220 w_pdt_t_10220

forward prototypes
public function integer wf_retrieve ()
public function string wf_aftermonth (string syymm, integer n)
end prototypes

public function integer wf_retrieve ();IF dw_ip.AcceptText() = -1 THEN Return -1

String	ls_ssmm, ls_ssmm1, ls_porgu 

ls_ssmm = dw_ip.GetItemString(1, 'from_month')
ls_porgu = dw_ip.GetItemString(1, 'porgu')

IF ls_ssmm = '' OR IsNull(ls_ssmm) THEN
	f_message_chk(30, '[기준년도]')
	dw_ip.SetFocus()
	Return -1
END IF

dw_list.reset()
dw_list.SetRedraw(False)

dw_list.SetFilter("")
dw_list.filter()

IF dw_list.Retrieve(ls_ssmm, ls_porgu) <= 0 THEN
	f_message_chk(50, '[ 년 비가동 손실비용 현황 ]')
	Return -1
END IF

// title 년월 설정
dw_list.Object.st_m11.text = wf_aftermonth(ls_ssmm,-11)
dw_list.Object.st_m10.text = wf_aftermonth(ls_ssmm,-10)
dw_list.Object.st_m9.text  = wf_aftermonth(ls_ssmm, -9)
dw_list.Object.st_m8.text  = wf_aftermonth(ls_ssmm, -8)
dw_list.Object.st_m7.text  = wf_aftermonth(ls_ssmm, -7)
dw_list.Object.st_m6.text  = wf_aftermonth(ls_ssmm, -6)
dw_list.Object.st_m5.text  = wf_aftermonth(ls_ssmm, -5)
dw_list.Object.st_m4.text  = wf_aftermonth(ls_ssmm, -4)
dw_list.Object.st_m3.text  = wf_aftermonth(ls_ssmm, -3)
dw_list.Object.st_m2.text  = wf_aftermonth(ls_ssmm, -2)
dw_list.Object.st_m1.text  = wf_aftermonth(ls_ssmm, -1)
dw_list.Object.st_m0.text  = wf_aftermonth(ls_ssmm,  0)

dw_list.SetFilter("status = '1'")
dw_list.filter()

dw_list.SetSort("pdtgu A, jocod A, wkctr A, status A")
dw_list.Sort()

//tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(deptcode) ', 1)"))
//If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_print.Modify("txt_steamcd.text = '"+tx_name+"'")
//
//tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(areacode) ', 1)"))
//If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_print.Modify("txt_sarea.text = '"+tx_name+"'")
//
//tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(sale_emp) ', 1)"))
//If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_print.Modify("tx_sale_emp.text = '"+tx_name+"'")
//
//dw_print.sharedata(dw_print)
//dw_print.SetRedraw(True)

dw_list.SetRedraw(True)

Return 1


end function

public function string wf_aftermonth (string syymm, integer n);string stemp

stemp = f_aftermonth(syymm,n)

stemp = Mid(stemp,1,4) + '년' + Right(stemp,2) + '월'

return stemp
end function

on w_pdt_t_10220.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pdt_t_10220.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;String ls_befo_month

select TO_CHAR(ADD_MONTHS(SYSDATE,-11),'YYYYMM') 
into :ls_befo_month
From dual;

dw_ip.SetItem(1,'from_month', Left(f_today(),6))
//dw_ip.SetItem(1,'to_month', ls_befo_month )
end event

type p_preview from w_standard_print`p_preview within w_pdt_t_10220
boolean visible = false
integer x = 3141
integer y = 44
end type

type p_exit from w_standard_print`p_exit within w_pdt_t_10220
end type

type p_print from w_standard_print`p_print within w_pdt_t_10220
boolean visible = false
integer x = 3314
integer y = 44
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_t_10220
integer x = 4270
end type







type st_10 from w_standard_print`st_10 within w_pdt_t_10220
end type



type dw_print from w_standard_print`dw_print within w_pdt_t_10220
string dataobject = "d_pdt_09010_1"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_t_10220
integer x = 18
integer y = 24
integer width = 1888
integer height = 152
string dataobject = "d_pdt_t_10220_h"
end type

event dw_ip::itemchanged;call super::itemchanged;
String ls_befo_month, ls_curr_month

If GetColumnName() = "from_month" Then
	
	If IsNull(data) or data ="" Then
		ls_curr_month = Left(f_today(),6)
	End if
	
	Select TO_CHAR(ADD_MONTHS(TO_DATE(:data ,'YYYYMM'),-11),'YYYYMM')
	into :ls_befo_month
	From dual;
	
	If SQLCA.sqlcode = 0 Then
		//this.SetItem(1,'to_month', ls_befo_month )
	Else
		MessageBox("알림", "입력하신 년월이 유효하지 않습니다.")
		this.setFocus()
		this.setColumn("from_month")
		this.SetItem(1,"from_month", "")
	End If

End If
end event

type dw_list from w_standard_print`dw_list within w_pdt_t_10220
event ue_mousemove pbm_mousemove
integer x = 46
integer y = 216
integer width = 4558
integer height = 2096
string dataobject = "d_pdt_t_10220_d"
boolean border = false
end type

event dw_list::ue_mousemove;String ls_Object
Long	 ll_Row

IF this.Rowcount() < 1 then return 

ls_Object = Lower(This.GetObjectAtPointer())

IF mid(ls_Object, 1, 9)  = 'sort_name' THEN 
   ll_Row = long(mid(ls_Object, 11, 5))
	this.setrow(ll_row)
	this.setitem(ll_row, 'opt1', '1')
//ELSEIF mid(ls_Object, 1, 7)  = 'ntime_t' THEN 
//   ll_Row = long(mid(ls_Object, 8, 5))
//	this.setrow(ll_row)
//	this.setitem(ll_row, 'opt', '2')
//ELSEIF mid(ls_Object, 1, 7)  = 'ktime_t' THEN 
//   ll_Row = long(mid(ls_Object, 8, 5))
//	this.setrow(ll_row)
//	this.setitem(ll_row, 'opt', '3')
//ELSEIF mid(ls_Object, 1, 7)  = 'ttime_t' THEN 
//   ll_Row = long(mid(ls_Object, 8, 5))
//	this.setrow(ll_row)
//	this.setitem(ll_row, 'opt', '4')
//ELSEIF mid(ls_Object, 1, 7)  = 'jtime_t' THEN 
//   ll_Row = long(mid(ls_Object, 8, 5))
//	this.setrow(ll_row)
//	this.setitem(ll_row, 'opt', '5')	
ELSE
	this.setitem(this.getrow(), 'opt1', '0')
END IF
end event

event dw_list::clicked;call super::clicked;String  	ls_Object, ls_pdtgu, ls_jocod, ls_status, ls_opt2, ls_filter
Long	  	ll_Row, i 
Boolean	lb_isopen
Window	lw_window
	
this.AcceptText()

IF this.Rowcount() < 1 then return 

IF row < 1 then return 

ls_Object = Lower(This.GetObjectAtPointer())

//MessageBox("Row", String(row))

ls_status = this.getItemString(row, 'status')
ls_pdtgu = this.getItemString(row, "pdtgu")
ls_jocod = this.getItemString(row, "jocod")
ls_opt2 = this.getItemString(row, "opt2")

dw_list.SetRedraw(false)


IF mid(ls_Object, 1, 9)  = 'sort_name' and ls_status <> '3' THEN 

	If ls_status = '1' Then

		If ls_opt2 ='0' Then

			For i = 1 to dw_list.RowCount()
				If ls_status = '1' Then
					dw_list.SetItem(i, "opt2", "0")
				End If
			Next
			
			dw_list.SetItem(row, "opt2", "1")
			
			this.setFilter("")
			this.filter()
			
			ls_filter = " status = '1' or ( status = '2' and pdtgu ='" + ls_pdtgu + "')"
			dw_list.SetFilter(ls_filter)
			dw_list.filter()
			
		Else
			For i = 1 to dw_list.RowCount() 
				dw_list.SetItem(i, "opt2", "0")
			Next 
			
			this.setFilter("")
			this.filter()
			
			ls_filter = "status = '1'"
			dw_list.SetFilter( ls_filter )
			dw_list.filter()
			
		End If

Elseif ls_status = '2' Then

		If ls_opt2 ='0' Then

			For i = 1 to dw_list.RowCount()
				If dw_list.getItemString(i, "status") = '2' Then
					dw_list.SetItem(i, "opt2", "0")
				End If
			Next

			dw_list.SetItem(row, "opt2", "1")
			
			ls_filter = " status = '1' or  ( ( status = '2' and pdtgu ='" + ls_pdtgu + "')" + " or ( status = '3' and pdtgu ='" + ls_pdtgu + "' and jocod = '" + ls_jocod + "'))" 
			
			this.setFilter("")
			this.filter()			
		
			dw_list.SetFilter( ls_filter )
			dw_list.filter()
			
		Else

			dw_list.SetItem(row, "opt2", "0")
			
			this.setFilter("")
			this.filter()
			
			ls_filter = " status = '1' or ( status = '2' and pdtgu ='" + ls_pdtgu + "')" 
			dw_list.SetFilter( ls_filter )
			dw_list.filter()

		End If
	End If

End If

dw_list.SetSort("pdtgu A, jocod A, wkctr A, status A")
dw_list.Sort()

dw_list.SetRedraw(true)
end event

type rr_1 from roundrectangle within w_pdt_t_10220
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 208
integer width = 4576
integer height = 2112
integer cornerheight = 40
integer cornerwidth = 55
end type

