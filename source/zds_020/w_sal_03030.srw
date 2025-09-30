$PBExportHeader$w_sal_03030.srw
$PBExportComments$운반비 기준등록
forward
global type w_sal_03030 from w_inherite
end type
type gb_3 from groupbox within w_sal_03030
end type
type gb_2 from groupbox within w_sal_03030
end type
type dw_key from u_key_enter within w_sal_03030
end type
type rr_3 from roundrectangle within w_sal_03030
end type
end forward

global type w_sal_03030 from w_inherite
integer height = 2404
string title = "운반비 기준등록"
gb_3 gb_3
gb_2 gb_2
dw_key dw_key
rr_3 rr_3
end type
global w_sal_03030 w_sal_03030

type variables

end variables

forward prototypes
public function integer wf_key_protect (boolean gb)
end prototypes

public function integer wf_key_protect (boolean gb);Choose Case gb
	Case True
		dw_key.Modify('cvcod.protect = 1')
		dw_key.Modify('frunit.protect = 1')
//      dw_key.Modify("cvcod.background.color = 80859087") // button face
//      dw_key.Modify("frunit.background.color = 80859087") // button face
	Case False
		dw_key.Modify('cvcod.protect = 0')
		dw_key.Modify('frunit.protect = 0')
//      dw_key.Modify("cvcod.background.color = '"+String(Rgb(255,255,0))+"'")	 // yellow
//      dw_key.Modify("frunit.background.color = '"+String(Rgb(255,255,255))+"'")
End Choose

Return 1
end function

on w_sal_03030.create
int iCurrent
call super::create
this.gb_3=create gb_3
this.gb_2=create gb_2
this.dw_key=create dw_key
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_3
this.Control[iCurrent+2]=this.gb_2
this.Control[iCurrent+3]=this.dw_key
this.Control[iCurrent+4]=this.rr_3
end on

on w_sal_03030.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_3)
destroy(this.gb_2)
destroy(this.dw_key)
destroy(this.rr_3)
end on

event ue_open;call super::ue_open;dw_key.SetTransObject(sqlca)
dw_insert.SetTransObject(sqlca)

p_can.Post PostEvent(Clicked!)

end event

event open;call super::open;PostEvent("ue_open")
end event

type dw_insert from w_inherite`dw_insert within w_sal_03030
integer x = 667
integer y = 396
integer width = 2322
integer height = 1636
string dataobject = "d_sal_03030"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event dw_insert::itemchanged;string s_Sarea,s_rfgub

Choose Case GetColumnName()
	Case 'frarea','toarea'
		s_sarea = Trim(GetText())
		
		SELECT "REFFPF"."RFGUB" INTO :s_rfgub
        FROM "REFFPF"  
       WHERE ( "REFFPF"."SABU" = '1'  ) AND  
             ( "REFFPF"."RFCOD" = '37' ) AND  
             ( "REFFPF"."RFGUB" = :s_sarea ) ;

      If IsNull(s_rfgub) Or Trim(s_rfgub) = '' Then
			f_message_chk(101,'[지역코드]')
			Return 2
		End If
End Choose



end event

event dw_insert::itemerror;Return 1
end event

type p_delrow from w_inherite`p_delrow within w_sal_03030
integer x = 3922
end type

event p_delrow::clicked;call super::clicked;string s_frarea
int    row

If dw_insert.RowCount() > 0 Then
	row   = dw_insert.GetRow()
	s_frarea = dw_insert.GetItemSTring(row,'frarea')
   IF MessageBox("삭 제",string(row) +"번째가 삭제됩니다." +"~n~n" +&
                     	 "삭제 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN RETURN
     
	If dw_insert.DeleteRow(row)  = 1 Then
		If dw_insert.Update() = 1 Then
		   commit;
		   sle_msg.text =	"자료를 삭제하였습니다!!"	
	   Else
		   Rollback ;
	   End If		
	End If	
   cb_inq.PostEvent(Clicked!)
End If

end event

type p_addrow from w_inherite`p_addrow within w_sal_03030
integer x = 3749
end type

event p_addrow::clicked;call super::clicked;int    rcnt,nRow
string s_cvcod,s_frunit,s_frarea,s_toarea
Double dfrprice

If dw_key.AcceptText() <> 1 Then Return
If dw_key.RowCount() <= 0 Then Return
If dw_insert.AcceptText() <> 1 Then Return

s_cvcod  = dw_key.GetItemString(1,'cvcod')
s_frunit = dw_key.GetItemString(1,'frunit')

If IsNull(s_cvcod) Or s_cvcod = '' Then
   f_message_chk(1400,'[운송업체]')
	Return -1
End If

If IsNull(s_frunit) Or s_frunit = '' Then
   f_message_chk(1400,'[운송단위]')
	Return -1
End If

nRow = dw_insert.RowCount()
If nRow > 0 Then
   s_frarea = dw_insert.GetItemString(nRow,'frarea')
   s_toarea = dw_insert.GetItemString(nRow,'toarea')
   dfrprice = dw_insert.GetItemNumber(nRow,'frprice')

   If IsNull(s_frarea) Or s_frarea = '' Then
     f_message_chk(1400,'[출발지역]')
	  dw_insert.SetFocus()
	  dw_insert.ScrollToRow(nRow)
	  dw_insert.SetRow(nRow)
	  dw_insert.SetColumn('frarea')
	  Return
   End If
	
   If IsNull(s_toarea) Or s_toarea = '' Then
     f_message_chk(1400,'[도착지역]')
	  dw_insert.SetFocus()
	  dw_insert.ScrollToRow(nRow)
	  dw_insert.SetRow(nRow)
	  dw_insert.SetColumn('toarea')
	  Return
   End If

   If IsNull(dfrprice) Or dfrprice = 0 Then
     f_message_chk(1400,'[기준운반비]')
	  dw_insert.SetFocus()
	  dw_insert.ScrollToRow(nRow)
	  dw_insert.SetRow(nRow)
	  dw_insert.SetColumn('frprice')
	  Return
   End If
End If

nRow = dw_insert.InsertRow(0)
dw_insert.SetItem(nrow,'cvcod',s_cvcod)
dw_insert.SetItem(nrow,'frunit',s_frunit)
dw_insert.SetItemStatus(nrow, 0,Primary!, NotModified!)
dw_insert.SetItemStatus(nrow, 0,Primary!, New!)
dw_insert.SetFocus()
dw_insert.ScrollToRow(nRow)
dw_insert.SetRow(nrow)
dw_insert.SetColumn('frarea')

If nRow =  1 Then wf_key_protect(true)

end event

type p_search from w_inherite`p_search within w_sal_03030
boolean visible = false
integer x = 3867
integer y = 528
end type

type p_ins from w_inherite`p_ins within w_sal_03030
boolean visible = false
integer x = 4233
integer y = 520
end type

type p_exit from w_inherite`p_exit within w_sal_03030
end type

type p_can from w_inherite`p_can within w_sal_03030
end type

event p_can::clicked;call super::clicked;int row

dw_key.Reset()
dw_insert.Reset()

row = dw_key.InsertRow(0)
wf_key_protect(false)

dw_key.SetFocus()
dw_key.SetRow(row)
dw_key.SetColumn('cvcod')

ib_any_typing = false
end event

type p_print from w_inherite`p_print within w_sal_03030
boolean visible = false
integer x = 4041
integer y = 528
end type

type p_inq from w_inherite`p_inq within w_sal_03030
integer x = 3575
end type

event p_inq::clicked;call super::clicked;int    rcnt,nRow
string s_cvcod, s_frunit

If dw_key.AcceptText() <> 1 Then Return

nRow = dw_key.RowCount()
If nRow <= 0 Then Return

s_cvcod  = dw_key.GetItemString(nRow,'cvcod')
s_frunit = dw_key.GetItemString(nRow,'frunit')

If IsNull(s_cvcod) Or s_cvcod = '' Then
   f_message_chk(1400,'[운송업체]')
	Return -1
End If

If IsNull(s_frunit) Or s_frunit = '' Then
   f_message_chk(1400,'[운송단위]')
	Return -1
End If

If dw_insert.Retrieve(s_cvcod,s_frunit) > 0 Then	
   wf_key_protect(true)
Else
	sle_msg.Text = '조회된 건수가 없습니다.!!'
End If
end event

type p_del from w_inherite`p_del within w_sal_03030
boolean visible = false
integer x = 4421
integer y = 512
end type

type p_mod from w_inherite`p_mod within w_sal_03030
integer x = 4096
end type

event p_mod::clicked;call super::clicked;int    rcnt,nRow,ix
string s_cvcod,s_frunit,s_frarea,s_toarea
Double dfrprice

If dw_key.AcceptText() <> 1 Then Return
If dw_insert.AcceptText() <> 1 Then Return

nRow = dw_key.RowCount()
If nRow <= 0 Then Return

s_cvcod = dw_key.GetItemString(nRow,'cvcod')
s_frunit = dw_key.GetItemString(nRow,'frunit')

If IsNull(s_cvcod) Or s_cvcod = '' Then
   f_message_chk(1400,'[운송업체]')
	Return -1
End If

If IsNull(s_frunit) Or s_frunit = '' Then
   f_message_chk(1400,'[운송단위]')
	Return -1
End If

nRow = dw_insert.RowCount()
If nRow <= 0 Then Return

   s_frarea = dw_insert.GetItemString(nRow,'frarea')
   s_toarea = dw_insert.GetItemString(nRow,'toarea')
	dfrprice = dw_insert.GetItemNumber(nRow,'frprice')

   If IsNull(s_frarea) Or s_frarea = '' Then
     f_message_chk(1400,'[출발지역]')
	  dw_insert.SetFocus()
	  dw_insert.ScrollToRow(nRow)
	  dw_insert.SetRow(nRow)
	  dw_insert.SetColumn('frarea')
	  Return
   End If
	
   If IsNull(s_toarea) Or s_toarea = '' Then
     f_message_chk(1400,'[도착지역]')
	  dw_insert.SetFocus()
	  dw_insert.ScrollToRow(nRow)
	  dw_insert.SetRow(nRow)
	  dw_insert.SetColumn('toarea')
	  Return
   End If

   If IsNull(dfrprice) Or dfrprice = 0 Then
     f_message_chk(1400,'[기준운반비]')
	  dw_insert.SetFocus()
	  dw_insert.ScrollToRow(nRow)
	  dw_insert.SetRow(nRow)
	  dw_insert.SetColumn('frprice')
	  Return
   End If


if dw_insert.Update() = 1 then
	sle_msg.text =	"자료를 저장하였습니다!!"			
	ib_any_typing = false
	commit ;
else
	rollback ;
	return 
end if

end event

type cb_exit from w_inherite`cb_exit within w_sal_03030
integer x = 2350
integer y = 2204
integer taborder = 70
boolean enabled = false
end type

type cb_mod from w_inherite`cb_mod within w_sal_03030
integer x = 1294
integer y = 2204
integer taborder = 40
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within w_sal_03030
integer x = 453
integer y = 2204
boolean enabled = false
string text = "추가(&I)"
end type

type cb_del from w_inherite`cb_del within w_sal_03030
integer x = 1646
integer y = 2204
integer taborder = 50
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_sal_03030
integer x = 805
integer y = 2204
integer taborder = 30
boolean enabled = false
end type

type cb_print from w_inherite`cb_print within w_sal_03030
integer x = 1774
integer y = 2344
integer taborder = 90
end type

type st_1 from w_inherite`st_1 within w_sal_03030
end type

type cb_can from w_inherite`cb_can within w_sal_03030
integer x = 1998
integer y = 2204
boolean enabled = false
end type

type cb_search from w_inherite`cb_search within w_sal_03030
integer x = 2496
integer y = 2344
integer taborder = 100
end type







type gb_button1 from w_inherite`gb_button1 within w_sal_03030
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_03030
end type

type gb_3 from groupbox within w_sal_03030
boolean visible = false
integer x = 1234
integer y = 2132
integer width = 1481
integer height = 236
integer taborder = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
end type

type gb_2 from groupbox within w_sal_03030
boolean visible = false
integer x = 393
integer y = 2132
integer width = 823
integer height = 236
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
end type

type dw_key from u_key_enter within w_sal_03030
integer x = 722
integer y = 244
integer width = 2235
integer height = 92
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_sal_03030_key"
boolean border = false
end type

event itemchanged;String s_cvnas

Choose Case GetColumnName()
	Case 'cvcod'
   	select fun_get_cvnas(:data) into :s_cvnas from dual;
		If Trim(s_cvnas) = '' Or IsNull(s_cvnas) Then
         f_message_chk(33,'[거래처]')
			Return 1
		Else	
	      This.SetItem(1,GetColumnName()+'nm',s_cvnas)
			cb_inq.TriggerEvent(Clicked!)
      End If			
End Choose

end event

event rbuttondown;string s_colnm
SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

s_colnm = GetColumnName() 
Choose Case s_colnm
	Case "cvcod"      // 거래처 선택
   	Open(w_vndmst_popup)
		If IsNull(gs_code) Then Return 1
		
		this.SetItem(row,s_colnm,gs_code)
		this.SetItem(row,s_colnm+'nm',gs_codename)
//		cb_inq.TriggerEvent(Clicked!)
END Choose
end event

event itemerror;return 1
end event

type rr_3 from roundrectangle within w_sal_03030
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 667
integer y = 208
integer width = 2363
integer height = 156
integer cornerheight = 40
integer cornerwidth = 55
end type

