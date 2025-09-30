$PBExportHeader$w_sal_02000_10.srw
$PBExportComments$원가비교(제조원가)
forward
global type w_sal_02000_10 from w_inherite_popup
end type
type st_2 from statictext within w_sal_02000_10
end type
type em_1 from editmask within w_sal_02000_10
end type
type gb_1 from groupbox within w_sal_02000_10
end type
end forward

global type w_sal_02000_10 from w_inherite_popup
integer x = 146
integer y = 324
integer width = 3575
integer height = 1864
string title = "원가비교"
event ue_open pbm_custom01
st_2 st_2
em_1 em_1
gb_1 gb_1
end type
global w_sal_02000_10 w_sal_02000_10

type variables
datawindow  idw
string  original_select,original_group = ''
end variables

event open;call super::open;/* ---------------------------------------------------------- */
/* arg : Message.PowerObjectParm - 수주,pi 등록 데이타 원도우 */
/*       gs_code  - 년월                                      */
/*       gs_gubun - 환율 (pi)                                 */
/* ---------------------------------------------------------- */

int nRow,nPos
string sTemp

idw = Message.PowerObjectParm
If Not IsValid(idw) Then Return

nRow = idw.RowCount()
If nRow <= 0 then 
	Close(w_sal_02000_10)
	return
end if

original_select = dw_1.Describe("DataWindow.Table.Select")

nPos = Pos(original_select, 'group by c.itnbr',1)

original_group = Mid(original_select, nPos )
original_select = Left(original_select, nPos -1)

f_window_center_response(this)
end event

on w_sal_02000_10.create
int iCurrent
call super::create
this.st_2=create st_2
this.em_1=create em_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.em_1
this.Control[iCurrent+3]=this.gb_1
end on

on w_sal_02000_10.destroy
call super::destroy
destroy(this.st_2)
destroy(this.em_1)
destroy(this.gb_1)
end on

type dw_1 from w_inherite_popup`dw_1 within w_sal_02000_10
integer width = 3497
string dataobject = "d_sal_02000_10"
end type

type sle_2 from w_inherite_popup`sle_2 within w_sal_02000_10
boolean visible = false
integer x = 1874
integer y = 24
end type

type cb_1 from w_inherite_popup`cb_1 within w_sal_02000_10
boolean visible = false
end type

type cb_return from w_inherite_popup`cb_return within w_sal_02000_10
integer x = 1669
integer y = 1544
integer width = 361
integer taborder = 60
string text = "종료(&X)"
end type

event cb_return::clicked;close(parent)
end event

type cb_inq from w_inherite_popup`cb_inq within w_sal_02000_10
integer x = 1280
integer y = 1544
integer width = 361
integer taborder = 50
end type

event cb_inq::clicked;string s_itnbr
string itnbr_clause,mod_string, spinbr, ssabu
double d_amt,d_prc,d_qty
int    ix,nCnt,nRow,cost_rate
string rc
decimal {2} drate

If IsNumber(gs_gubun) Then      //환율
  drate = Dec(gs_gubun)
Else
  drate = 1
End If

// 품번을 읽어옴
For ix = 1 To idw.Rowcount()
	If idw.DataObject = 'd_sal_06020_d' then // pi 등록
	 s_itnbr = idw.GetItemString(ix,'itnbr')
   Else                                     // 수주등록
	 s_itnbr = idw.GetItemString(ix,'itnbr')
   End If

   If IsNull(s_itnbr) then continue
	
	s_itnbr = "~~~'" + s_itnbr + "~~~'"
	
   If ix = 1 Then
		itnbr_clause += ( s_itnbr )
	Else
		itnbr_clause += ( "," +  s_itnbr  )
	End If
Next

mod_string = "DataWindow.Table.Select='" 	+ original_select + &
             " AND ~~~"A~~~".~~~"ITNBR~~~" IN ( " + itnbr_clause + " )  " + &
         	 original_group + "'"

rc = dw_1.Modify(mod_string)

dw_1.SetRedraw(False)

IF rc = "" THEN
	nCnt = dw_1.Retrieve(gs_code )        //조회 : 년월
ELSE
	MessageBox("Status", "Modify Failed" + rc + '~r~n' + mod_string)
	dw_1.SetRedraw(true)
	Return
END IF

If ncnt = 0 then
	f_message_chk(50,'')
	dw_1.SetRedraw(true)
	Return
End If

cost_rate = Integer(em_1.Text)
If IsNull(cost_rate) Then 
	cost_rate = 0
	em_1.Text = '0'
End If

For ix = 1 To nCnt
  s_itnbr = dw_1.GetItemString(ix,'itnbr')

  nRow = idw.find("itnbr ='" + s_itnbr + "'",1,idw.Rowcount())
  If nRow <= 0 Then continue
  
  If idw.DataObject = 'd_sal_06020_d' then // pi 등록
	 d_qty = idw.GetItemNumber(nRow,'piqty')
	 if isnull(drate) or drate < 1 then
		 drate = 1
	 end if
	 
	 d_prc = Truncate(idw.GetItemNumber(nRow,'piprc') * drate, 0)
	 d_amt = truncate(idw.GetItemNumber(nRow,'piAMT') * drate, 0)
  Else                                     // 수주등록
	 d_qty = idw.GetItemNumber(nRow,'order_qty')
	 d_prc = idw.GetItemNumber(nRow,'order_prc')
	 d_amt = idw.GetItemNumber(nRow,'order_amt')
  End If
  
  /* 단가 10단위에서 사사오입 */
  d_prc = Truncate(d_prc,0)
  
  dw_1.SetItem(ix,'sales_qty',d_qty)
  dw_1.SetItem(ix,'sales_prc',d_prc)
  dw_1.SetItem(ix,'sales_amt',d_amt)
  dw_1.SetItem(ix,'cost_rate',cost_rate)
Next

dw_1.SetRedraw(true)
end event

type sle_1 from w_inherite_popup`sle_1 within w_sal_02000_10
boolean visible = false
integer x = 1449
integer y = 12
long backcolor = 1090519039
integer limit = 3
end type

type st_1 from w_inherite_popup`st_1 within w_sal_02000_10
integer width = 736
string text = "매출액 대비 판매관리비율"
end type

type st_2 from statictext within w_sal_02000_10
integer x = 1015
integer y = 40
integer width = 82
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "%"
boolean focusrectangle = false
end type

type em_1 from editmask within w_sal_02000_10
integer x = 800
integer y = 24
integer width = 197
integer height = 76
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "###"
end type

type gb_1 from groupbox within w_sal_02000_10
integer x = 1198
integer y = 1492
integer width = 923
integer height = 204
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

