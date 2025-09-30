$PBExportHeader$w_sal_05550.srw
$PBExportComments$영업일자별 수주/판매실적 그래프
forward
global type w_sal_05550 from w_standard_dw_graph
end type
type dw_view from datawindow within w_sal_05550
end type
end forward

global type w_sal_05550 from w_standard_dw_graph
string title = "영업일자별 수주/판매실적 그래프"
dw_view dw_view
end type
global w_sal_05550 w_sal_05550

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();/* 일자별 판매금액(w_sal_05560)과 동일함 */

String  symd, ym, sdd, st_dd, sPym, sIlsu,ls_sarea,tx_name
Long    cnt, t_cnt, ix, nRow
Integer iIlsu
Double  dAmt, dNuAmt, dChrAmt[27]

If dw_ip.AcceptText() <> 1 Then Return -1

symd = f_today()

ym   = Trim(dw_ip.GetItemString(1,'sym'))
sPym = f_aftermonth(ym,-1)
ls_sarea = trim(dw_ip.getitemstring(1,'sarea'))

if	(ym = '') or isNull(ym) then
	f_Message_Chk(35, '[기준년월]')
	dw_ip.setcolumn('sym')
	dw_ip.setfocus()
	Return -1
end if

if ls_sarea = "" or isnull(ls_sarea) then ls_sarea='%'

//messagebox("",ls_sarea)
dw_list.SetRedraw(False)

/* 전3개월 평균수주금액 */
dAmt = 0; dNuAmt = 0
dw_view.Retrieve(gs_sabu, f_aftermonth(ym,-4)+'01',f_aftermonth(ym,-1)+'31',ls_sarea )
For ix = 1 To dw_view.RowCount()
	nRow = dw_list.InsertRow(0)
	
	dw_list.SetItem(nRow, 'gubun', '1')
	dw_list.SetItem(nRow, 'title', '3개월평균')
	
	sIlsu = dw_view.GetItemString(ix,'ilsu')
	dw_list.SetItem(nRow, 'ilsu', sIlsu+'일차')
	
	dAmt = dw_view.GetItemNumber(ix, 'order_amt')/3
	dNuAmt += dAmt
	
	dw_list.SetItem(nRow, 'amt', dAmt)
	
	/* 평균누계 */
	nRow = dw_list.InsertRow(0)
	
	dw_list.SetItem(nRow, 'gubun', '4')
	dw_list.SetItem(nRow, 'title', '평균누계')
	dw_list.SetItem(nRow, 'ilsu', sIlsu+'일차')
	dw_list.SetItem(nRow, 'amt', dNuAmt)
Next

/* 전월 수주금액 */
dAmt = 0; dNuAmt = 0
dw_view.Retrieve(gs_sabu, sPym+'01',sPym+'31',ls_sarea)
For ix = 1 To dw_view.RowCount()
	nRow = dw_list.InsertRow(0)
	
	dw_list.SetItem(nRow, 'gubun', '2')
	dw_list.SetItem(nRow, 'title', Right(sPym,2)+'월')
	
	sIlsu = dw_view.GetItemString(ix,'ilsu')
	dw_list.SetItem(nRow, 'ilsu', sIlsu+'일차')
	
	dAmt = dw_view.GetItemNumber(ix, 'order_amt')
	dw_list.SetItem(nRow, 'amt', dAmt)

	/* 전월 누계 */
	dNuAmt += dAmt
	nRow = dw_list.InsertRow(0)
	
	dw_list.SetItem(nRow, 'gubun', '5')
	dw_list.SetItem(nRow, 'title', Right(sPym,2)+'월누계')
	dw_list.SetItem(nRow, 'ilsu',  sIlsu+'일차')
	dw_list.SetItem(nRow, 'amt',   dNuAmt)
	
	/* 전월대비차액 */
	If IsNumber(sIlsu) Then
		iIlsu = Integer(sIlsu)
		dChrAmt[iIlsu] = dNuamt
	End If
Next

/* 당월 수주금액 */
dAmt = 0; dNuAmt = 0
dw_view.Retrieve(gs_sabu, ym+'01',ym+'31',ls_sarea)
For ix = 1 To dw_view.RowCount()
	nRow = dw_list.InsertRow(0)
	
	dw_list.SetItem(nRow, 'gubun', '3')
	dw_list.SetItem(nRow, 'title', Right(ym,2)+'월')
	
	sIlsu = dw_view.GetItemString(ix,'ilsu')
	dw_list.SetItem(nRow, 'ilsu', sIlsu+'일차')
	
	dAmt = dw_view.GetItemNumber(ix, 'order_amt')
	dw_list.SetItem(nRow, 'amt', dAmt)
	
	nRow = dw_list.InsertRow(0)
	dNuamt += damt
	
	dw_list.SetItem(nRow, 'gubun', '6')
	dw_list.SetItem(nRow, 'title', Right(ym,2)+'월누계')
	dw_list.SetItem(nRow, 'ilsu',  sIlsu+'일차')
	dw_list.SetItem(nRow, 'amt',   dNuAmt)
	
	/* 전월대비차액 */
	If IsNumber(sIlsu) Then
		iIlsu = Integer(sIlsu)
		dChrAmt[iIlsu] = dNuamt - dChrAmt[iIlsu]
		
		dw_list.Modify("st_ch"+string(iIlsu)+".text = '" +String(dChrAmt[iIlsu]) + "'")
	End If
Next

dw_list.SetSort('gubun,ilsu')
dw_list.Sort()

dw_list.SetRedraw(True)

Select Count(*) Into :cnt From p4_calendar
Where substr(cldate,1,6) = :ym and cldate <= :symd and salehdaygu = 'N';
if isnull(cnt) then
	cnt = 0
end if
sdd = string(cnt)

Select Count(*) Into :t_cnt From p4_calendar
Where substr(cldate,1,6) = :ym and salehdaygu = 'N';
if isnull(t_cnt) then
	t_cnt = 0
end if
st_dd = string(t_cnt)

dw_list.object.r_ym.Text = Left(ym,4) + '.' + Right(ym,2)
dw_list.object.r_ymd.Text = '작성일자 : '+Left(symd,4)+'년 '+Mid(symd,5,2)+'월 '+&
                            Right(symd,2)+'일 ('+sdd+'일 경과 / '+st_dd+'일 근무일수)'
									 
tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(sarea) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_list.Modify("tx_sarea.text = '"+tx_name+"'")

return 1
end function

on w_sal_05550.create
int iCurrent
call super::create
this.dw_view=create dw_view
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_view
end on

on w_sal_05550.destroy
call super::destroy
destroy(this.dw_view)
end on

event open;call super::open;dw_view.SetTransObject(sqlca)
dw_ip.setitem(1,'sym',left(f_today(),6))


end event

type p_exit from w_standard_dw_graph`p_exit within w_sal_05550
end type

type p_print from w_standard_dw_graph`p_print within w_sal_05550
end type

type p_retrieve from w_standard_dw_graph`p_retrieve within w_sal_05550
end type

type st_window from w_standard_dw_graph`st_window within w_sal_05550
end type

type st_popup from w_standard_dw_graph`st_popup within w_sal_05550
integer x = 1947
integer y = 2372
integer height = 72
end type

type pb_title from w_standard_dw_graph`pb_title within w_sal_05550
end type

type pb_space from w_standard_dw_graph`pb_space within w_sal_05550
end type

type pb_color from w_standard_dw_graph`pb_color within w_sal_05550
end type

type pb_graph from w_standard_dw_graph`pb_graph within w_sal_05550
end type

type dw_ip from w_standard_dw_graph`dw_ip within w_sal_05550
integer x = 14
integer width = 2574
integer height = 160
string dataobject = "d_sal_05550_01"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;call super::itemchanged;string ls_gubun,ls_name,snull,ls_date

ls_name = This.GetColumnName()
SetNull(sNull)

Choose Case ls_name
	// 기준일자 유효성 Check
   Case "sym"
		ls_date = Trim(Gettext())
		ls_date = ls_date + '01' 
		if f_DateChk(ls_date) = -1 then
			this.SetItem(1, "sym", sNull)
			f_Message_Chk(35, '[기준월]')
			return 1
		end if
	Case "gubun"
		ls_gubun = Trim(Gettext())
		
		dw_list.setredraw(false)
		IF ls_gubun = '1' then
			dw_list.dataobject = 'd_sal_05550'
			dw_view.dataobject = 'd_sal_055502'
		else
			dw_list.dataobject = 'd_sal_05560'
			dw_view.dataobject = 'd_sal_055601'
		End if
		
		dw_list.settransobject(Sqlca)
		dw_view.settransobject(Sqlca)
		dw_list.setredraw(true)
End choose


end event

type sle_msg from w_standard_dw_graph`sle_msg within w_sal_05550
end type

type dw_datetime from w_standard_dw_graph`dw_datetime within w_sal_05550
end type

type st_10 from w_standard_dw_graph`st_10 within w_sal_05550
end type

type gb_3 from w_standard_dw_graph`gb_3 within w_sal_05550
end type

type dw_list from w_standard_dw_graph`dw_list within w_sal_05550
integer y = 232
integer width = 4558
string dataobject = "d_sal_05550"
end type

type gb_10 from w_standard_dw_graph`gb_10 within w_sal_05550
end type

type rr_1 from w_standard_dw_graph`rr_1 within w_sal_05550
integer y = 220
integer width = 4590
end type

type dw_view from datawindow within w_sal_05550
boolean visible = false
integer x = 142
integer y = 2372
integer width = 1499
integer height = 360
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_sal_055502"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

