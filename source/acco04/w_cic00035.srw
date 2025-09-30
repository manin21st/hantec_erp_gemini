$PBExportHeader$w_cic00035.srw
$PBExportComments$자재로스율 등록
forward
global type w_cic00035 from w_inherite
end type
type dw_1 from datawindow within w_cic00035
end type
type dw_2 from datawindow within w_cic00035
end type
type p_new from uo_picture within w_cic00035
end type
type dw_5 from datawindow within w_cic00035
end type
type r_1 from rectangle within w_cic00035
end type
end forward

global type w_cic00035 from w_inherite
integer width = 4695
integer height = 2556
string title = "자재로스율 등록"
dw_1 dw_1
dw_2 dw_2
p_new p_new
dw_5 dw_5
r_1 r_1
end type
global w_cic00035 w_cic00035

type variables
string is_yymm, is_saupj, is_ittyp
end variables

on w_cic00035.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_2=create dw_2
this.p_new=create p_new
this.dw_5=create dw_5
this.r_1=create r_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.p_new
this.Control[iCurrent+4]=this.dw_5
this.Control[iCurrent+5]=this.r_1
end on

on w_cic00035.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.p_new)
destroy(this.dw_5)
destroy(this.r_1)
end on

event open;call super::open;dw_1.SettransObject(sqlca)
dw_2.SettransObject(sqlca)
dw_5.SettransObject(sqlca)


dw_1.Insertrow(0)
dw_1.Setitem(1,"yymm", left(f_today(),6))
dw_1.SetItem(1,"saupj",  gs_saupj)


is_yymm = left(f_today(),6)
is_ittyp = '3'
end event

type dw_insert from w_inherite`dw_insert within w_cic00035
integer y = 2476
end type

type p_delrow from w_inherite`p_delrow within w_cic00035
integer x = 3913
boolean originalsize = true
end type

event p_delrow::clicked;call super::clicked;
long   ll_seqno, lrow ,  chk, k, i

lrow   = dw_2.getrow()



chk   = messagebox('','선택 항목을 삭제하시겠습니까?',QUESTION!,okcancel!,2)

dw_2.deleterow(lrow)



If dw_2.Update() = 1 Then
   ib_any_typing = False
	w_mdi_frame.sle_msg.text ="자료를 삭제하였습니다!!"
	commit using sqlca;
		
Else
   messagebox("확인","자료삭제시 에러!")
	Rollback;
end If


w_mdi_frame.sle_msg.text ="자료를 삭제하였습니다!!"
		
end event

type p_addrow from w_inherite`p_addrow within w_cic00035
integer x = 3735
end type

event p_addrow::clicked;call super::clicked;int li_row



dw_2.insertrow(0)

dw_2.Setitem(dw_2.Rowcount(), "workym",   is_yymm )


end event

type p_search from w_inherite`p_search within w_cic00035
integer x = 3081
integer y = 28
boolean originalsize = true
string picturename = "C:\erpman\image\일괄적용_up.gif"
end type

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\일괄적용_dn.gif" 
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\일괄적용_up.gif" 
end event

event p_search::clicked;call super::clicked;double ll_rat, ll_brat
int i

dw_1.Accepttext()

ll_rat = dw_1.GetitemNumber(1, "rat")
ll_brat = dw_1.GetitemNumber(1, "brat")

if IsNull(ll_rat) or IsNull(ll_brat) then
	messagebox("확인","로스율이나, 부산물 발생율을 입력하세요")
	return
end if

if IsNull(ll_rat) then	
	For  i = 1 to dw_2.Rowcount()	 
		  dw_2.Setitem(i, "resi_rat", ll_brat) 			
	Next
end if 	

if IsNull(ll_brat) then	
	For  i = 1 to dw_2.Rowcount()	 
		 dw_2.Setitem(i, "loss_rat", ll_rat)
	Next

end if
end event

type p_ins from w_inherite`p_ins within w_cic00035
boolean visible = false
integer x = 4882
integer y = 384
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_cic00035
boolean originalsize = true
end type

type p_can from w_inherite`p_can within w_cic00035
boolean originalsize = true
end type

event p_can::clicked;call super::clicked;p_inq.Triggerevent(Clicked!)
end event

type p_print from w_inherite`p_print within w_cic00035
boolean visible = false
integer x = 4709
integer y = 384
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_cic00035
integer x = 3557
boolean originalsize = true
end type

event p_inq::clicked;call super::clicked;string snull
SetNull(snull)

if dw_1.Accepttext() = -1 then return

is_yymm = dw_1.GetItemString(1, "yymm")

if IsNull(is_yymm) or is_yymm = "" then 
   messagebox("확인","년월을 입력하세요!")
   dw_1.SetItem(1,"yymm", snull)
   dw_1.SetColumn("yymm")
   dw_1.Setfocus()
   return
end if

if f_datechk(is_yymm+'01') = -1 then
   messagebox("확인","년월을 확인하세요!")
   dw_1.SetItem(1,"yymm", snull)
   dw_1.SetColumn("yymm")
   dw_1.Setfocus()
   return
end if	

if dw_2.Retrieve(is_yymm, is_ittyp) < 1 then
   w_mdi_frame.sle_msg.text = "조회할 자료가 없습니다!"
   return
end if
end event

type p_del from w_inherite`p_del within w_cic00035
boolean visible = false
integer x = 5074
integer y = 388
boolean enabled = false
end type

type p_mod from w_inherite`p_mod within w_cic00035
integer x = 4091
boolean originalsize = true
end type

event p_mod::clicked;call super::clicked;

If dw_2.Update() = 1 Then
   ib_any_typing = False
	w_mdi_frame.sle_msg.text ="자료를 저장하였습니다!!"
	commit using sqlca;
		
Else
   messagebox("확인","자료저장시 에러!")
	Rollback;
end If


w_mdi_frame.sle_msg.text ="자료를 저장하였습니다!!"
end event

type cb_exit from w_inherite`cb_exit within w_cic00035
end type

type cb_mod from w_inherite`cb_mod within w_cic00035
end type

type cb_ins from w_inherite`cb_ins within w_cic00035
end type

type cb_del from w_inherite`cb_del within w_cic00035
end type

type cb_inq from w_inherite`cb_inq within w_cic00035
end type

type cb_print from w_inherite`cb_print within w_cic00035
end type

type st_1 from w_inherite`st_1 within w_cic00035
end type

type cb_can from w_inherite`cb_can within w_cic00035
end type

type cb_search from w_inherite`cb_search within w_cic00035
end type







type gb_button1 from w_inherite`gb_button1 within w_cic00035
end type

type gb_button2 from w_inherite`gb_button2 within w_cic00035
end type

type dw_1 from datawindow within w_cic00035
integer x = 59
integer y = 32
integer width = 3022
integer height = 188
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "dw_cic0035_1"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;If This.GetColumnName() = "ittyp" then
   is_ittyp = this.Gettext()
end if

end event

type dw_2 from datawindow within w_cic00035
integer x = 73
integer y = 240
integer width = 4526
integer height = 2064
integer taborder = 60
boolean bringtotop = true
string title = "none"
string dataobject = "dw_cic0035_2"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event rowfocuschanged;If CurrentRow <= 0 then
	this.SelectRow(0,False)
ELSE
	SelectRow(0, FALSE)
	SelectRow(CurrentRow,TRUE)	
END IF
end event

event rbuttondown;String ls_itnbr, ls_titnm, ls_itdsc
SetNull(gs_gubun)

gs_gubun = is_ittyp
Open(w_itemas_popup10_cic)

if gs_gubun <> 'Y' OR ISNULL(gs_Gubun)  then  REturn 

dw_5.SettransObject(sqlca)
dw_5.ReSet()
dw_5.ImportClipboard()

string ls_filter
Int  li_row, li_Trow, li_seq
ls_filter = "flag = 'Y'"
dw_5.SetFilter(ls_filter)
dw_5.filter()

li_Trow = dw_5.Rowcount()

li_row = 1
For li_row = 1 to li_Trow
	 ls_itnbr = dw_5.GetitemString(li_row, "itemas_itnbr")
	 ls_titnm = dw_5.GetitemString(li_row, "itemas_itdsc")
	 ls_itdsc = dw_5.GetitemString(li_row, "itemas_ispec")
	
 
	 dw_2.Setitem(dw_2.rowcount(), "itnbr", ls_itnbr)	 
	 dw_2.Setitem(dw_2.rowcount(), "vw_itdsc", ls_titnm)
	 dw_2.Setitem(dw_2.rowcount(), "vw_ispec", ls_itdsc)
 	 dw_2.Setitem(dw_2.rowcount(), "workym", is_yymm)	  

	 if li_row <> li_Trow then
	    dw_2.insertrow(0)
	 end if		
	
Next


end event

type p_new from uo_picture within w_cic00035
integer x = 3378
integer y = 24
integer width = 178
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\erpman\image\생성_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\생성_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\생성_up.gif'
end event

event clicked;call super::clicked;

if messagebox("확인","초기화후 전월데이타를 복사하여 생성합니다 생성하시겠습니까?", Question!, YesNo!) =2 then return

dw_2.reset()


delete from cic0020 a
where a.itnbr = (select itnbr from cic_itemas_vw where itnbr = a.itnbr and ittyp = :is_ittyp ) and workym = :is_yymm;

commit;



String sold_sql, swhere_clause, snew_sql


			  
sold_sql =  "SELECT 'N' Flag,   a.ITNBR,    a.ITDSC,    a.ISPEC,    a.JIJIL,      ITNCT.TITNM,          a.USEYN " + &
				"FROM CIC_ITEMAS_VW a ,  ITNCT "  + &
				"WHERE a.ITTYP = ITNCT.ITTYP(+)  and "   + &
				"      a.ITCLS = ITNCT.ITCLS(+) "  
			
swhere_clause = ""


swhere_clause = swhere_clause + "AND A.ITTYP ='"+is_ittyp+"'"

dw_5.SetFilter("")
dw_5.filter()

snew_sql = sold_sql + swhere_clause
dw_5.SetSqlSelect(snew_sql)	
dw_5.Retrieve()


int li_Trow, li_row
string ls_itnbr, ls_titnm, ls_itdsc

li_Trow = dw_5.Rowcount()

li_row = 1
For li_row = 1 to li_Trow
	 ls_itnbr = dw_5.GetitemString(li_row, "itemas_itnbr")
	 ls_titnm = dw_5.GetitemString(li_row, "itemas_itdsc")
	 ls_itdsc = dw_5.GetitemString(li_row, "itemas_ispec")
	
 
	 dw_2.Setitem(dw_2.rowcount(), "itnbr", ls_itnbr)	 
	 dw_2.Setitem(dw_2.rowcount(), "vw_itdsc", ls_titnm)
	 dw_2.Setitem(dw_2.rowcount(), "vw_ispec", ls_itdsc)
 	 dw_2.Setitem(dw_2.rowcount(), "workym", is_yymm)	  


	 if li_row <> li_Trow then
	    dw_2.insertrow(0)
	 end if		
	
Next




	



end event

type dw_5 from datawindow within w_cic00035
boolean visible = false
integer x = 151
integer y = 956
integer width = 2181
integer height = 400
integer taborder = 90
boolean bringtotop = true
boolean enabled = false
string dataobject = "d_itemas_popup10_detail_cic"
boolean border = false
boolean livescroll = true
end type

type r_1 from rectangle within w_cic00035
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 69
integer y = 232
integer width = 4539
integer height = 2120
end type

