$PBExportHeader$w_sm40_0057.srw
$PBExportComments$월간 검수
forward
global type w_sm40_0057 from w_inherite
end type
type dw_detail from datawindow within w_sm40_0057
end type
type p_1 from picture within w_sm40_0057
end type
type rb_1 from radiobutton within w_sm40_0057
end type
type rb_2 from radiobutton within w_sm40_0057
end type
type cb_cvcod from commandbutton within w_sm40_0057
end type
type cb_mobis from commandbutton within w_sm40_0057
end type
type dw_imhist from datawindow within w_sm40_0057
end type
type cb_hkmc from commandbutton within w_sm40_0057
end type
type hpb_1 from hprogressbar within w_sm40_0057
end type
type st_bar from statictext within w_sm40_0057
end type
type st_bigo from statictext within w_sm40_0057
end type
type p_2 from uo_picture within w_sm40_0057
end type
type p_3 from uo_picture within w_sm40_0057
end type
type cbx_1 from checkbox within w_sm40_0057
end type
type p_4 from uo_excel_down within w_sm40_0057
end type
type gb_1 from groupbox within w_sm40_0057
end type
type rr_1 from roundrectangle within w_sm40_0057
end type
end forward

global type w_sm40_0057 from w_inherite
integer width = 5586
integer height = 2632
string title = "매출확정"
dw_detail dw_detail
p_1 p_1
rb_1 rb_1
rb_2 rb_2
cb_cvcod cb_cvcod
cb_mobis cb_mobis
dw_imhist dw_imhist
cb_hkmc cb_hkmc
hpb_1 hpb_1
st_bar st_bar
st_bigo st_bigo
p_2 p_2
p_3 p_3
cbx_1 cbx_1
p_4 p_4
gb_1 gb_1
rr_1 rr_1
end type
global w_sm40_0057 w_sm40_0057

type variables
int ii_horizontal_y

str_code is_strcode
end variables

forward prototypes
public subroutine wf_change ()
public function string wf_confirm (string ar_saupj, string ar_date, string ar_gubun)
end prototypes

public subroutine wf_change ();DataWindowChild ldwc_fact

If rb_1.Checked Then
//	dw_insert.DataObject = "d_sm40_0057_a"
	dw_insert.DataObject = "d_sm40_0057_a_new"
	
	dw_detail.GetChild("factory", ldwc_fact)
	ldwc_fact.SetTransObject(SQLCA)
	ldwc_fact.Retrieve("H","K")
	
	p_1.visible = False
//	cb_mobis.visible = False
//	cb_hkmc.visible = True
//	cb_hkmc.x = cb_mobis.x
//	cb_hkmc.y = cb_mobis.y
	st_bigo.visible = True
	
	dw_detail.Modify("t_9.Visible = false iogbn.Visible = false")

Else
	dw_insert.DataObject = "d_sm40_0057_b"
	
	dw_detail.GetChild("factory", ldwc_fact)
	ldwc_fact.SetTransObject(SQLCA)
	ldwc_fact.Retrieve("M","Z")
	
	p_1.visible = True
//	cb_mobis.visible = True
//	cb_hkmc.visible = False
	st_bigo.visible = False
	
	dw_detail.Modify("t_9.Visible = true iogbn.Visible = true")

End if

dw_insert.SetTransObject(SQLCA)




end subroutine

public function string wf_confirm (string ar_saupj, string ar_date, string ar_gubun);long ll_cnt = 0 
String ls_rtn 
IF ar_gubun = 'HKMC' then
	
	select count(*) into :ll_cnt
	  from sale_magam x
	 where x.mayymm = :ar_date
	   and exists (select 'x' from imhist a , iomatrix b
									 where a.sabu = b.sabu
										and a.iogbn = b.iogbn
										and b.salegu = 'Y'
										and a.io_date like :ar_date||'%'
										and a.yebi1 like :ar_date||'%'
										and a.saupj = :ar_saupj
										and a.facgbn <> 'L1'
										and exists ( select 'X' from van_hkcd0_ne where factory = a.facgbn) 
										and a.iojpno = x.iojpno) ;
										
else
	select count(*) into :ll_cnt
	  from sale_magam x
	 where x.mayymm = :ar_date
	   and exists (select 'x' from imhist a , iomatrix b
									 where a.sabu = b.sabu
										and a.iogbn = b.iogbn
										and b.salegu = 'Y'
										and a.io_date like :ar_date||'%'
										and a.yebi1 like :ar_date||'%'
										and a.saupj = :ar_saupj
										and a.facgbn = 'L1'
										and exists ( select 'X' from van_hkcd0_ne where factory = a.facgbn) 
										and a.iojpno = x.iojpno
						union all
						select 'x' from imhist a , 
											 iomatrix b 
									 where a.sabu = b.sabu
										and a.iogbn = b.iogbn
										and b.salegu = 'Y'
										and a.sabu = '1'
										and a.saupj = :ar_saupj 
										and substr(a.io_date,1,6) = :ar_date
										and not exists ( select 'X' from van_hkcd0_ne where factory = a.facgbn) 
										and a.iojpno = x.iojpno) ;
						
										
end if 			
										
if ll_cnt > 0 Then
	
	dw_detail.object.confirm[1] = 'Y'
	
	ls_rtn = 'Y'
	
else
	dw_detail.object.confirm[1] = 'N'
	ls_rtn = 'N'
end if

return ls_rtn
								
	
	
end function

on w_sm40_0057.create
int iCurrent
call super::create
this.dw_detail=create dw_detail
this.p_1=create p_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.cb_cvcod=create cb_cvcod
this.cb_mobis=create cb_mobis
this.dw_imhist=create dw_imhist
this.cb_hkmc=create cb_hkmc
this.hpb_1=create hpb_1
this.st_bar=create st_bar
this.st_bigo=create st_bigo
this.p_2=create p_2
this.p_3=create p_3
this.cbx_1=create cbx_1
this.p_4=create p_4
this.gb_1=create gb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_detail
this.Control[iCurrent+2]=this.p_1
this.Control[iCurrent+3]=this.rb_1
this.Control[iCurrent+4]=this.rb_2
this.Control[iCurrent+5]=this.cb_cvcod
this.Control[iCurrent+6]=this.cb_mobis
this.Control[iCurrent+7]=this.dw_imhist
this.Control[iCurrent+8]=this.cb_hkmc
this.Control[iCurrent+9]=this.hpb_1
this.Control[iCurrent+10]=this.st_bar
this.Control[iCurrent+11]=this.st_bigo
this.Control[iCurrent+12]=this.p_2
this.Control[iCurrent+13]=this.p_3
this.Control[iCurrent+14]=this.cbx_1
this.Control[iCurrent+15]=this.p_4
this.Control[iCurrent+16]=this.gb_1
this.Control[iCurrent+17]=this.rr_1
end on

on w_sm40_0057.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_detail)
destroy(this.p_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.cb_cvcod)
destroy(this.cb_mobis)
destroy(this.dw_imhist)
destroy(this.cb_hkmc)
destroy(this.hpb_1)
destroy(this.st_bar)
destroy(this.st_bigo)
destroy(this.p_2)
destroy(this.p_3)
destroy(this.cbx_1)
destroy(this.p_4)
destroy(this.gb_1)
destroy(this.rr_1)
end on

event open;call super::open;wf_change()
dw_imhist.settransobject(SQLCA)
dw_insert.settransobject(SQLCA)
dw_detail.settransobject(SQLCA)

dw_detail.InsertRow(0)

String ls_mondt
//select To_char(ADD_MONTHS(sysdate , -1),'YYYYMM') Into :ls_mondt from dual ;
//마감이 되면 마감된 다음 월을 표시 - BY SHINGOON 2007.04.26 (노상호BJ요청)
SELECT TO_CHAR(ADD_MONTHS(TO_DATE(MAX(MAYYMM), 'YYYYMM'), 1), 'YYYYMM') 
  INTO :ls_mondt 
  FROM SALE_MAGAM ;

dw_detail.Object.sdate[1] = ls_mondt

setnull(gs_code)
If f_check_saupj() = 1 Then
	dw_detail.SetItem(1, 'saupj', gs_code)
   if gs_code <> '%' then
   	dw_detail.Modify("saupj.protect=1")
		dw_detail.Modify("saupj.background.color = 80859087")
   End if
End If

dw_detail.SetFocus()
dw_detail.SetColumn(1)

st_bar.visible = False
hpb_1.visible = False

end event

type dw_insert from w_inherite`dw_insert within w_sm40_0057
integer x = 46
integer y = 332
integer width = 4521
integer height = 1960
integer taborder = 20
string dataobject = "d_sm40_0057_a_new"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event dw_insert::clicked;call super::clicked;//If row <= 0 then
//	this.SelectRow(0,False)
//	Return
//ELSE
//	this.SelectRow(0, FALSE)
//	this.SelectRow(row,TRUE)
//END IF

if row > 0 then
	dw_detail.setitem(1,'itnbr',this.getitemstring(row,'itnbr'))
end if

f_multi_select(This)
end event

event dw_insert::doubleclicked;call super::doubleclicked;If row < 1 Then Return
If dw_detail.AcceptText() < 1 Then Return

String ls_null
String ls_saupj , ls_itnbr ,ls_sdate , ls_edate , ls_factory, ls_cvcod
Dec    ld_ioqty , ld_ioamt

SetNull(ls_null)

is_strcode.code[1] = ls_null
is_strcode.sgubun1[1] = ls_null
is_strcode.sgubun2[1] = ls_null
is_strcode.sgubun3[1] = ls_null

If rb_1.Checked Then
	
	ls_saupj   = Trim(dw_detail.object.saupj[1])
	ls_itnbr   = Trim(this.object.itnbr[row])
	ls_sdate   = Trim(dw_detail.object.sdate[1])+ '01'
   ls_Edate   = Trim(dw_detail.object.sdate[1])+ '31'
	ls_factory = Trim(This.object.factory[row])
	ls_cvcod   = Trim(This.Object.cvcod[row])
	
	is_strcode.code[1] = Trim(this.object.itnbr[row])
	is_strcode.sgubun1[1] = Trim(This.object.factory[row])
	is_strcode.sgubun2[1] = Trim(dw_detail.object.sdate[1])
	is_strcode.sgubun3[1] = Trim(dw_detail.object.saupj[1])
	gi_page = this.Getitemnumber(row, "iptamt")
	
	openwithparm(w_sm40_0057_popup , is_strcode)
	
//	  SELECT nvl(sum(A.ioqty*B.CALVALUE),0) , nvl(Round(sum(A.ioqty*B.CALVALUE*A.IOPRC),0),0)
	  SELECT NVL(SUM(DECODE(A.IOGBN, 'O41', A.IOFAQTY, A.IOQTY) * B.CALVALUE), 0), NVL(SUM(A.IOAMT * B.CALVALUE), 0)
	    INTO :ld_ioqty, :ld_ioamt
		 FROM IMHIST   A,
				IOMATRIX B
		WHERE A.SABU   = :gs_sabu
		  AND A.SAUPJ  = :ls_saupj
		  AND A.ITNBR  = :ls_itnbr
		  AND A.YEBI1  BETWEEN :ls_sdate AND :ls_edate
		  AND A.FACGBN = :ls_factory
		  AND A.CVCOD  = :ls_cvcod
		  AND B.SALEGU = 'Y'
		  AND A.SABU   = B.SABU
		  AND A.IOGBN  = B.IOGBN ;
		  
  dw_insert.object.gmqty[row] = ld_ioqty
  dw_insert.object.gmamt[row] = ld_ioamt
	

End if

end event

event dw_insert::itemerror;call super::itemerror;return 1
end event

event dw_insert::itemchanged;call super::itemchanged;string	sVendor, sVendorname, sNull

SetNull(sNull)

If rb_2.Checked Then
	
	// 거래처
	IF this.GetColumnName() = 'cvcod'		THEN
	
		sVendor = this.gettext()
		SELECT CVNAS2
		  INTO :sVendorName
		  FROM VNDMST
		 WHERE CVCOD = :sVendor 	AND
				 CVSTATUS = '0' ;
		 
		if sqlca.sqlcode <> 0 	then
			f_message_chk(33,'[거래처]')
			this.setitem(row, "cvcod", sNull)
			this.setitem(row, "cvnas", sNull)
			return 1
		end if
	
		this.setitem(row, "cvnas", sVendorName)
	
	END IF
End if
end event

event dw_insert::rbuttondown;call super::rbuttondown;gs_gubun = ''
gs_code  = ''
gs_codename = ''

If rb_2.Checked Then

	// 전표번호
	IF this.GetColumnName() = 'cvcod'	THEN
		gs_gubun = '1' 
		Open(w_vndmst_popup)
		if Isnull(gs_code) or Trim(gs_code) = "" then return
	
		SetItem(1, "cvcod",		gs_code)
		SetItem(1, "cvnas",gs_codename)
	
	END IF
End if
	
end event

type p_delrow from w_inherite`p_delrow within w_sm40_0057
boolean visible = false
integer x = 1888
integer y = 2420
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_sm40_0057
boolean visible = false
integer x = 1714
integer y = 2420
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_sm40_0057
boolean visible = false
integer x = 1385
integer y = 2424
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_sm40_0057
boolean visible = false
integer x = 1541
integer y = 2420
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_sm40_0057
integer x = 4416
end type

event p_exit::clicked;Close(parent)
end event

type p_can from w_inherite`p_can within w_sm40_0057
integer x = 4242
end type

event p_can::clicked;call super::clicked;dw_insert.reset()

dw_detail.InsertRow(0)

dw_detail.Object.sdate[1] = f_afterday(f_today(),-30)
dw_detail.Object.edate[1] = f_today() 

dw_detail.SetFocus()
dw_detail.SetColumn(1)



end event

type p_print from w_inherite`p_print within w_sm40_0057
boolean visible = false
integer x = 4626
end type

type p_inq from w_inherite`p_inq within w_sm40_0057
integer x = 3895
end type

event p_inq::clicked;call super::clicked;string ls_saupj ,ls_sdate, ls_factory, ls_itnbr , snull, ls_ittyp, ls_iogbn
String ls_gubun, ls_cvcod

if dw_detail.accepttext() = -1 then return

ls_saupj  = trim(dw_detail.getitemstring(1, "saupj"))
ls_sdate  = trim(dw_detail.getitemstring(1, "sdate"))
ls_factory  = trim(dw_detail.getitemstring(1, "factory"))
ls_itnbr= trim(dw_detail.getitemstring(1, "itnbr"))
ls_ittyp= trim(dw_detail.getitemstring(1, "ittyp"))
ls_cvcod= trim(dw_detail.getitemstring(1, "cvcod"))
ls_iogbn= trim(dw_detail.getitemstring(1, "iogbn"))

if isnull(ls_sdate) or trim(ls_sdate) = '' then
	f_message_chk(30, '[검수월]')
	dw_detail.SetColumn("sdate")
	dw_detail.SetFocus()
	return
end if

if isnull(ls_factory) or trim(ls_factory) = '.' then ls_factory = '%'
if isnull(ls_itnbr) or trim(ls_itnbr) = '' then ls_itnbr = ''
if isnull(ls_ittyp) or trim(ls_ittyp) = '' then ls_ittyp = '%'
if isnull(ls_cvcod) or trim(ls_cvcod) = '' then ls_cvcod = '%'
if isnull(ls_iogbn) or trim(ls_iogbn) = '' then ls_iogbn = '%'

String ls_cust
SELECT FUN_GET_REFFPF_VALUE('AD', :ls_saupj, '4')
  INTO :ls_cust
  FROM DUAL ;
If Trim(ls_cust) = '' OR IsNull(ls_cust) Then ls_cust = 'P655'

dw_insert.setredraw(false)
dw_insert.modify("datawindow.detail.height=72")
/*if dw_insert.Retrieve(ls_saupj , ls_sdate, ls_factory , ls_itnbr+'%', ls_ittyp, ls_cvcod ) > 0 then*/
if dw_insert.Retrieve(gs_sabu, ls_saupj , ls_sdate, ls_factory , ls_itnbr+'%', ls_ittyp, ls_cvcod, ls_cust, ls_iogbn ) > 0 then
	
	if rb_1.Checked then
		ls_gubun = 'HKMC'
	else
		ls_gubun = 'X'
	end if
	
	wf_confirm( ls_saupj , ls_sdate , ls_gubun ) 
	
end if
dw_insert.setredraw(true)

end event

type p_del from w_inherite`p_del within w_sm40_0057
integer x = 4416
integer y = 168
end type

event p_del::clicked;call super::clicked;Long ll_rcnt , i
String ls_facgbn , ls_iogbn , ls_iojpno ,ls_itnbr , ls_gubun , ls_rtn
string ls_saupj ,ls_sdate, ls_factory

ls_saupj  = trim(dw_detail.getitemstring(1, "saupj"))
ls_sdate  = trim(dw_detail.getitemstring(1, "sdate"))
ls_factory  = trim(dw_detail.getitemstring(1, "factory"))

if isnull(ls_sdate) or trim(ls_sdate) = '' then
	f_message_chk(30, '[검수월]')
	dw_detail.SetColumn("sdate")
	dw_detail.SetFocus()
	return
end if

if rb_1.Checked then
	ls_gubun = 'HKMC'
else
	ls_gubun = 'X'
end if

ls_rtn = wf_confirm( ls_saupj , ls_sdate , ls_gubun ) 

if ls_rtn = 'Y' Then
	MessageBox('확인','이미 확정된 매출전표입니다. 삭제 불가능합니다.') 
	return 
end if


if rb_1.Checked Then
	
	If f_msg_Delete() < 1 Then Return
	
	if dw_detail.accepttext() = -1 then return
	
	if isnull(ls_sdate) or trim(ls_sdate) = '' then
		f_message_chk(30, '[검수월]')
		dw_detail.SetColumn("sdate")
		dw_detail.SetFocus()
		return
	end if
	
	If ls_factory = '' or isNUll(ls_factory) Then ls_factory = '%'
	
	Delete From imhist where iogbn in ( 'OZ5','OZ6','OY5','OY6') 
	                     and io_date like :ls_sdate ||'%'
								and pjt_cd = 'HKMC' ;
	
	If sqlca.sqlcode <> 0 Then
		Rollback;
		Messagebox('확인','삭제 실패')
		Return
	End if


	Commit ;
	
	p_inq.TriggerEvent(Clicked!)
	
	Messagebox('확인','삭제 완료하였습니다.')
	
Else

	ll_rcnt = dw_insert.RowCount()
	
	If ll_rcnt < 1 Then Return
	
	If f_msg_Delete() < 1 Then Return
	
	For i = ll_rcnt to 1 Step -1
		If dw_insert.isSelected(i) Then
			
			ls_facgbn = Trim(dw_insert.object.facgbn[i])
			ls_iogbn  =  Trim(dw_insert.object.iogbn[i])
			ls_itnbr =  Trim(dw_insert.object.itnbr[i])
			
			If ls_facgbn = 'M1' or ls_facgbn = 'M2' or ls_facgbn = 'M3' or &
				ls_facgbn = 'M4' or ls_facgbn = 'M5' or ls_facgbn = 'M6' or &
				ls_facgbn = 'M7' or ls_facgbn = 'M8' or ls_facgbn = 'M9' or & 
				ls_iogbn = 'OZ5' or ls_iogbn = 'OZ6' Then
				
				ls_iojpno = Trim(dw_insert.object.iojpno[i])
				
				Delete From imhist where sabu = :gs_sabu
											and iojpno = :ls_iojpno ;
				If sqlca.sqlcode <> 0 Then
					MessageBox('1' ,sqlca.sqlerrText )
					Rollback;
					Return
				End if
										
				Delete From imhist where sabu = :gs_sabu
											and iogbn in ('OZ5','OZ6') 
											and itnbr = :ls_itnbr
											and ip_jpno = :ls_iojpno ;
				If sqlca.sqlcode <> 0 Then
					MessageBox('2' ,sqlca.sqlerrText )
					Rollback;
					Return
				End if
											
				dw_insert.DeleteRow(i)
			Else
				MessageBox('확인','모비스(AUTO) 임의 생성 자료만 삭제 가능합니다. 삭제 불가 합니다.')
			End if
		End If
	Next

	Commit ;
End if

end event

type p_mod from w_inherite`p_mod within w_sm40_0057
integer x = 4069
end type

event p_mod::clicked;call super::clicked;if dw_detail.RowCount() < 1 then return
if dw_detail.AcceptText() < 1 then return
If dw_insert.AcceptText() < 1 Then Return
If dw_insert.RowCount() < 1 Then Return

If rb_1.Checked Then 
	
	MessageBox('확인','기타업체 매출조정(매출확정일,단가 수정)에만 사용가능합니다.')
	Return
end if

string ls_saupj ,ls_sdate ,ls_rtn

ls_saupj  = trim(dw_detail.getitemstring(1, "saupj"))
ls_sdate  = trim(dw_detail.getitemstring(1, "sdate"))

if isnull(ls_sdate) or trim(ls_sdate) = '' then
	f_message_chk(30, '[검수월]')
	dw_detail.SetColumn("sdate")
	dw_detail.SetFocus()
	return
end if

ls_rtn = wf_confirm( ls_saupj , ls_sdate , 'X' ) 

if ls_rtn = 'Y' Then
	MessageBox('확인','이미 확정된 매출전표입니다. 저장 불가능합니다.') 
	return 
end if


Long	 	i ,ll_f

String 	sdate1, sdate2 ,scvcod , ssdate , sedate

If f_msg_update() < 1 Then Return

String   ls_txt

For i=1 To dw_insert.RowCount()
	sdate1 = dw_insert.getitemstring(i,'io_date_old')
	sdate2 = dw_insert.getitemstring(i,'io_date')
	
	ls_txt = dw_insert.GetItemString(i,'bigo')
	If Trim(ls_txt) = '' OR IsNull(ls_txt) Then
		ls_txt = ''
	Else
		ls_txt = ls_txt + '/'
	End If
	
	dw_insert.setitem(i,'yebi1',sdate2 )
	
	if sdate1 <> sdate2 then
		//dw_insert.setitem(i,'bigo',ls_txt + '매출일자 조정  ')
		dw_insert.setitem(i, 'bigo', sdate1 + '->' + sdate2 + ' 일자 조정  ')
	end if
	
	if dw_insert.getitemnumber(i,'ioprc') > 0 and &
		dw_insert.getitemnumber(i,'ioprc') <> dw_insert.getitemnumber(i,'ioprc_old') then

		dw_insert.setitem(i,'ioamt',Truncate(dw_insert.getitemnumber(i,'ioqty') * dw_insert.getitemnumber(i,'ioprc'),0))
//		dw_insert.setitem(i,'ioamt',Round(dw_insert.getitemnumber(i,'ioqty') * dw_insert.getitemnumber(i,'ioprc'),0))
		string a, b
		a = string(dw_insert.getitemnumber(i,'ioprc_old'))
		b = string(dw_insert.getitemnumber(i,'ioprc'))
		dw_insert.setitem(i, 'bigo', dw_insert.getitemstring(i,'bigo') + a + '->' + b + '단가 갱신')
	end if
	
Next

dw_insert.AcceptText() 
if dw_insert.update() <> 1 then
	rollback ;
	messagebox('저장실패','매출 조정 실패!!!')
	return
end if

Commit;

p_inq.TriggerEvent(Clicked!)

dw_insert.setredraw(true)

 
	
	
end event

type cb_exit from w_inherite`cb_exit within w_sm40_0057
end type

type cb_mod from w_inherite`cb_mod within w_sm40_0057
integer x = 672
integer y = 2452
integer taborder = 40
end type

type cb_ins from w_inherite`cb_ins within w_sm40_0057
integer x = 311
integer y = 2452
integer taborder = 30
end type

type cb_del from w_inherite`cb_del within w_sm40_0057
integer x = 1033
integer y = 2452
integer taborder = 50
end type

type cb_inq from w_inherite`cb_inq within w_sm40_0057
integer x = 1403
integer y = 2460
integer taborder = 60
end type

type cb_print from w_inherite`cb_print within w_sm40_0057
integer x = 1755
integer y = 2452
integer taborder = 70
end type

type st_1 from w_inherite`st_1 within w_sm40_0057
end type

type cb_can from w_inherite`cb_can within w_sm40_0057
end type

type cb_search from w_inherite`cb_search within w_sm40_0057
end type







type gb_button1 from w_inherite`gb_button1 within w_sm40_0057
end type

type gb_button2 from w_inherite`gb_button2 within w_sm40_0057
end type

type dw_detail from datawindow within w_sm40_0057
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 23
integer y = 16
integer width = 3438
integer height = 248
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_sm40_0057_1"
boolean border = false
boolean livescroll = true
end type

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;
IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;string	sVendor, sVendorname, sNull

SetNull(sNull)

This.AcceptText()

// 거래처
IF this.GetColumnName() = 'cvcod'		THEN

	sVendor = this.gettext()
	SELECT CVNAS2
	  INTO :sVendorName
	  FROM VNDMST
	 WHERE CVCOD = :sVendor 	AND
	 		 CVSTATUS = '0' ;
	 
	if sqlca.sqlcode <> 0 	then
		f_message_chk(33,'[거래처]')
		this.setitem(1, "cvcod", sNull)
		this.setitem(1, "cvnas", sNull)
		return 1
	end if

	this.setitem(1, "cvnas", sVendorName)

// 공장
ELSEIF this.GetColumnName() = 'factory'		THEN

	this.setitem(1, "itnbr", sNull)
	
	String ls_name
	String ls_fac
	
	ls_fac = This.GetItemString(1, 'factory')
	SELECT RFNA2
	  INTO :ls_name
	  FROM REFFPF
	 WHERE RFCOD = '2A'
	   AND RFGUB = :ls_fac ;
	If Trim(ls_name) = '' OR IsNull(ls_name) Then
		This.SetItem(1, 'cvcod', sNull)
		This.SetItem(1, 'cvnas', sNull)
		Return
	End If
	
	This.SetItem(1, 'cvcod', ls_name)
	This.SetItem(1, 'cvnas', f_get_name5('11', ls_name, ''))
END IF




end event

event itemerror;RETURN 1
end event

event losefocus;this.accepttext()
end event

event rbuttondown;gs_gubun = ''
gs_code  = ''
gs_codename = ''

// 전표번호
IF this.GetColumnName() = 'cvcod'	THEN
   gs_gubun = '1' 
	Open(w_vndmst_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1, "cvcod",		gs_code)
	SetItem(1, "cvnas",gs_codename)

END IF


end event

type p_1 from picture within w_sm40_0057
integer x = 4069
integer y = 168
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "HyperLink!"
string picturename = "C:\erpman\image\단가갱신_up.gif"
boolean focusrectangle = false
end type

event clicked;long		lrow
string	sitnbr, scvcod, sdate , ls_curr ,  ls_ckd , ls_factory , ls_gubun
decimal {2}	dunprc	 

If dw_insert.RowCount() < 1 Then Return

if messagebox('확인','단가정보를 갱신합니다.',question!,yesno!,1) = 2 then return

setpointer(hourglass!)

FOR lrow = 1 TO dw_insert.rowcount()
	
	sitnbr = dw_insert.getitemstring(lrow,'itnbr')
	scvcod = dw_insert.getitemstring(lrow,'cvcod')
	sdate  = trim(dw_insert.getitemstring(lrow,'io_date'))
		
   ls_ckd  = trim(dw_insert.object.lotsno[lrow])
	ls_factory = trim(dw_insert.object.facgbn[lrow])
	ls_gubun = '1'
	
	If ls_factory = 'MAS' or ls_factory = 'MAS1' Then
		If left(ls_ckd,2) = 'EH' or   left(ls_ckd,2) = 'EK' Then
			ls_gubun = '3'
		End if
	End if
	
//	select Fun_Erp100000012_2(:sdate,:scvcod,:sitnbr,:ls_gubun) 
	/* 2016.01.05 - 위 구문 오류로 단가갱신 안되어 아래 구문으로 대체 함 */
	select Fun_Erp100000012_1(:sdate,:scvcod,:sitnbr,:ls_gubun) 
	  into :dunprc from dual ;
	if sqlca.sqlcode = 0 then dw_insert.setitem(lrow,'ioprc',dunprc)
	
//	MESSAGEBOX('A',STRING(DUNPRC))
	
//	if dw_insert.getitemnumber(lrow,'ioprc') > 0 and &
//		dw_insert.getitemnumber(lrow,'ioprc') <> dw_insert.getitemnumber(lrow,'ioprc_old') then
//		dw_insert.setitem(lrow,'is_chek','Y')
//	end if
NEXT

messagebox('확인','단가정보 갱신 완료!!!')
end event

type rb_1 from radiobutton within w_sm40_0057
integer x = 3506
integer y = 64
integer width = 334
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "HKMC"
boolean checked = true
end type

event clicked;wf_change()

string ls_saupj ,ls_sdate

if dw_detail.accepttext() = -1 then return

ls_saupj  = trim(dw_detail.getitemstring(1, "saupj"))
ls_sdate  = trim(dw_detail.getitemstring(1, "sdate"))

wf_confirm( ls_saupj , ls_sdate , 'HKMC' )

end event

type rb_2 from radiobutton within w_sm40_0057
integer x = 3506
integer y = 156
integer width = 334
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "기타업체"
end type

event clicked;wf_change()

string ls_saupj ,ls_sdate

if dw_detail.accepttext() = -1 then return

ls_saupj  = trim(dw_detail.getitemstring(1, "saupj"))
ls_sdate  = trim(dw_detail.getitemstring(1, "sdate"))

wf_confirm( ls_saupj , ls_sdate , 'X' )
end event

type cb_cvcod from commandbutton within w_sm40_0057
boolean visible = false
integer x = 5134
integer y = 60
integer width = 736
integer height = 84
integer taborder = 90
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "거래처코드 일괄변경"
end type

event clicked;
If dw_detail.AcceptText() < 1 Then Return

String ls_null
String ls_saupj , ls_itnbr ,ls_sdate , ls_edate , ls_factory
Dec    ld_ioqty , ld_ioamt

SetNull(ls_null)

is_strcode.code[1] = ls_null
is_strcode.sgubun1[1] = ls_null


is_strcode.code[1] = Trim(dw_detail.object.saupj[1])
is_strcode.sgubun1[1] = Trim(dw_detail.object.sdate[1])

openwithparm(w_sm40_0057_popup2 , is_strcode)



end event

type cb_mobis from commandbutton within w_sm40_0057
boolean visible = false
integer x = 5134
integer y = 144
integer width = 736
integer height = 84
integer taborder = 100
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "모비스(AUTO)  마감생성"
end type

event clicked;string ls_saupj ,ls_sdate, ls_factory, ls_itnbr , snull , ls_iojpno , ls_nextdt
String ls_iojpno1 , ls_iojpno2
String ls_iogbn , ls_jnpcrt , ls_jpno
Long   ll_r , ll_cnt , ll_seq
String ls_cvcod , ls_depot_no , ls_sudat  

Dec  ld_qty , ld_silqty , ld_bqty , ld_price

if dw_detail.accepttext() = -1 then return

ls_saupj  = trim(dw_detail.getitemstring(1, "saupj"))
ls_sdate  = trim(dw_detail.getitemstring(1, "sdate"))

if isnull(ls_sdate) or trim(ls_sdate) = '' then
	f_message_chk(30, '[검수월]')
	dw_detail.SetColumn("sdate")
	dw_detail.SetFocus()
	return
end if

/* 매출마감 여부 체크  ========================================== */
SELECT COUNT(*)  INTO :ll_cnt
  FROM "JUNPYO_CLOSING"  
WHERE ( "JUNPYO_CLOSING"."SABU" = :gs_sabu ) AND  
		( "JUNPYO_CLOSING"."JPGU" = 'G0' ) AND  
		( "JUNPYO_CLOSING"."JPDAT" >= substr(:ls_sdate,1,6) );
		
If ll_cnt >= 1 then
	f_message_chk(60,'[매출마감]')
	Return
End if
//================================================================

SetPointer(HourGlass!)

SetNull(ls_jpno)

ls_sudat = f_last_date(ls_sdate+'01')
ll_seq = sqlca.fun_junpyo(gs_sabu,ls_sudat,'C0')
IF ll_seq <= 0 THEN
	f_message_chk(51,'')
	ROLLBACK;
	Return 1
END IF
commit;
ls_jpno = ls_sudat+String(ll_seq,'0000')

dw_imhist.Reset()

Declare mon_cur Cursor For 

SELECT a.factory ,
       a.itnbr ,
	    MAX(a.iojpno) ,
       SUM(a.ioqty) ,
	    SUM(a.silqty)
FROM (SELECT facgbn      AS factory ,
				 itnbr       AS itnbr , 
				 MAX(iojpno) AS iojpno ,
				 SUM(ioqty)  AS ioqty,
				 0           AS silqty
		  FROM imhist
		 WHERE io_date LIKE :ls_sdate||'%'
			AND iogbn IN ('OY2','O02')
			AND saupj = :ls_saupj
			AND facgbn IN ( 'M1','M2','M3','M4','M5','M6','M7','M8','M9') 
		GROUP BY facgbn , itnbr 
		UNION ALL
		SELECT factory , 
				 mitnbr AS itnbr,
				 '' AS iojpno ,
				 0 AS ioqty ,
				 SUM( item1 +  item2 +  item3 +  item4 +  item5 +  item6 +  item7 +  item8 +  item9 +  item10 + 
					   item11 +  item12 +  item13 +  item14 +  item15 +  item16 +  item17 +  item18 +  item19 +  item20 + 
					   item21 +  item22 +  item23 +  item24 +  item25 +  item26 +  item27 +  item28 +  item29 +  item30 +  item31 ) AS silqty 
		  FROM VAN_MOBIS_AUTO_SIL 
		 WHERE saupj = :ls_saupj
			AND sil_mon = :ls_sdate 
		GROUP BY factory , mitnbr
		) a
GROUP BY a.factory , a.itnbr  ;

open mon_cur ;

// 입고 창고 검색
SELECT min(cvcod)  into :ls_depot_no
  From vndmst
 where cvgu = '5'
   and ipjogun = :ls_saupj
	and soguan = '1' ;
	
If ls_depot_no = '' Or isNull(ls_depot_no) Then
	If gs_saupj = '10' Then
		ls_depot_no = 'Z015'
	Else
		ls_depot_no = 'Z025'
	End iF
End If

Do While True
	Fetch mon_cur Into :ls_factory , :ls_itnbr ,:ls_iojpno, :ld_qty , :ld_silqty ;
	
	If SQLCA.SQLCODE <> 0 Then Exit
	ll_cnt = 0 
	Select Count(*) Into :ll_cnt
	  From imhist
	 Where iogbn in ( 'OZ5' , 'OZ6')
	   and io_date = :ls_sudat
		and itnbr = :ls_itnbr 
		and facgbn = :ls_factory ;
		
	If ll_cnt > 0 Then Continue ;
	
	If ld_silqty <> ld_qty Then
		
		ld_bqty = ld_qty - ld_silqty
		
		If ld_bqty > 0 Then
			
			ls_iogbn     = 'OZ5' 
			ls_jnpcrt    = '005'
			
			ll_r = dw_imhist.InsertRow(0)
			
			ls_iojpno1 = ls_jpno+String(ll_r,'000')
			
			Select Decode(:ls_saupj , 
			             '10' ,
			              Substr(fun_get_reffpf_value('1G',:ls_factory , '1'),1,6) ,
							  Substr(fun_get_reffpf_value('1G',:ls_factory , '1'),-6,6) )
			  Into :ls_cvcod 
			  From dual ;
			
			Select fun_erp100000012_2(:ls_sudat , :ls_cvcod , :ls_itnbr , '1' ) Into :ld_price
			  From dual ;
	
			dw_imhist.SetItem(ll_r,"iojpno", 	 ls_iojpno1)
			dw_imhist.SetItem(ll_r,"iogbn", 		 ls_iogbn )
			dw_imhist.SetItem(ll_r,"sudat", 		 ls_sudat)
			dw_imhist.SetItem(ll_r,"itnbr", 		 ls_itnbr)
			dw_imhist.SetItem(ll_r,"cvcod",      ls_cvcod)
			dw_imhist.SetItem(ll_r,"depot_no",   ls_depot_no)
			dw_imhist.SetItem(ll_r,"ioqty",      ld_bqty )
			dw_imhist.SetItem(ll_r,"ioprc",      ld_price )
		
			dw_imhist.SetItem(ll_r,"ioamt",      TrunCate(ld_price * ld_bqty,0))
			dw_imhist.SetItem(ll_r,"ioreqty",    ld_bqty )
			dw_imhist.SetItem(ll_r,"iosuqty",    ld_bqty )
			dw_imhist.SetItem(ll_r,"insdat",     ls_sudat )
			dw_imhist.SetItem(ll_r,"insemp",     gs_empno)
		
			dw_imhist.SetItem(ll_r,"io_confirm", 'Y')
			dw_imhist.SetItem(ll_r,"io_date",    ls_sudat)
			dw_imhist.SetItem(ll_r,"io_empno",    gs_empno)
		
			dw_imhist.SetItem(ll_r,"filsk", 'Y'  )
			dw_imhist.SetItem(ll_r,"decisionyn", 'Y')
			
			dw_imhist.SetItem(ll_r,"yebi1",      ls_sudat)  // 검수하지 않는 업체이면 출고일자가 검수일자
		
			dw_imhist.SetItem(ll_r,"ioreemp",    gs_empno)
			dw_imhist.SetItem(ll_r,"saupj",      ls_saupj )
			dw_imhist.SetItem(ll_r,"inpcnf", 'O')   // 입출고구분(출고)
			dw_imhist.SetItem(ll_r,"botimh",'')
			dw_imhist.SetItem(ll_r,"outchk",'N')
		
			dw_imhist.SetItem(ll_r,"qcgub",'1')
			dw_imhist.SetItem(ll_r,"bigo",'마감-> 이월반품')
			dw_imhist.SetItem(ll_r,"jnpcrt", ls_jnpcrt )
			dw_imhist.SetItem(ll_r,"facgbn", ls_factory)
		
		
			ls_iogbn     = 'OZ6'
			ls_jnpcrt    = '024'
			
			ll_r = dw_imhist.InsertRow(0)
			
			ls_iojpno2 = ls_jpno+String(ll_r,'000')
			
			ls_nextdt = f_afterday(ls_sudat,1)
			
			Select fun_erp100000012_2(:ls_nextdt , :ls_cvcod , :ls_itnbr , '1' ) Into :ld_price
			  From dual ;
	
			dw_imhist.SetItem(ll_r,"iojpno", 	 ls_iojpno2)
			dw_imhist.SetItem(ll_r,"iogbn", 		 ls_iogbn )
			dw_imhist.SetItem(ll_r,"sudat", 		 ls_nextdt)
			dw_imhist.SetItem(ll_r,"itnbr", 		 ls_itnbr)
			dw_imhist.SetItem(ll_r,"cvcod",      ls_cvcod)
			dw_imhist.SetItem(ll_r,"depot_no",   ls_depot_no)
			dw_imhist.SetItem(ll_r,"ioqty",      ld_bqty )
			dw_imhist.SetItem(ll_r,"ioprc",      ld_price )
		
			dw_imhist.SetItem(ll_r,"ioamt",      TrunCate(ld_price * ld_bqty,0))
			dw_imhist.SetItem(ll_r,"ioreqty",    ld_bqty )
			dw_imhist.SetItem(ll_r,"iosuqty",    ld_bqty )
			dw_imhist.SetItem(ll_r,"insdat",     ls_nextdt )
			dw_imhist.SetItem(ll_r,"insemp",     gs_empno)
		
			dw_imhist.SetItem(ll_r,"io_confirm", 'Y')
			dw_imhist.SetItem(ll_r,"io_date",    ls_nextdt)
			dw_imhist.SetItem(ll_r,"io_empno",    gs_empno)
		
			dw_imhist.SetItem(ll_r,"filsk", 'Y'  )
			dw_imhist.SetItem(ll_r,"decisionyn", 'Y')
			
			dw_imhist.SetItem(ll_r,"yebi1",      ls_nextdt)  // 검수하지 않는 업체이면 출고일자가 검수일자
		
			dw_imhist.SetItem(ll_r,"ioreemp",    gs_empno)
			dw_imhist.SetItem(ll_r,"saupj",      ls_saupj )
			dw_imhist.SetItem(ll_r,"inpcnf", 'O')   // 입출고구분(출고)
			dw_imhist.SetItem(ll_r,"botimh",'')
			dw_imhist.SetItem(ll_r,"outchk",'N')
		
			dw_imhist.SetItem(ll_r,"qcgub",'1')
			dw_imhist.SetItem(ll_r,"jnpcrt", ls_jnpcrt )
			dw_imhist.SetItem(ll_r,"facgbn", ls_factory)
			dw_imhist.SetItem(ll_r,"ip_jpno", ls_iojpno1)
			dw_imhist.SetItem(ll_r,"bigo",'마감-> 이월입고')
		
		ElseIf ld_bqty < 0 Then
			
			ls_iogbn     = 'OZ6'
			ls_jnpcrt    = '024'
			
			ld_bqty = abs(ld_bqty)
			
			ll_r = dw_imhist.InsertRow(0)
			
			ls_iojpno1 = ls_jpno+String(ll_r,'000')
			
			Select Decode(:ls_saupj , 
			             '10' ,
			              Substr(fun_get_reffpf_value('1G',:ls_factory , '1'),1,6) ,
							  Substr(fun_get_reffpf_value('1G',:ls_factory , '1'),-6,6) )
			  Into :ls_cvcod 
			  From dual ;
			
			Select fun_erp100000012_2(:ls_sudat , :ls_cvcod , :ls_itnbr , '1' ) Into :ld_price
			  From dual ;
	
			dw_imhist.SetItem(ll_r,"iojpno", 	 ls_iojpno1)
			dw_imhist.SetItem(ll_r,"iogbn", 		 ls_iogbn )
			dw_imhist.SetItem(ll_r,"sudat", 		 ls_sudat)
			dw_imhist.SetItem(ll_r,"itnbr", 		 ls_itnbr)
			dw_imhist.SetItem(ll_r,"cvcod",      ls_cvcod)
			dw_imhist.SetItem(ll_r,"depot_no",   ls_depot_no)
			dw_imhist.SetItem(ll_r,"ioqty",      ld_bqty )
			dw_imhist.SetItem(ll_r,"ioprc",      ld_price )
		
			dw_imhist.SetItem(ll_r,"ioamt",      TrunCate(ld_price * ld_bqty,0))
			dw_imhist.SetItem(ll_r,"ioreqty",    ld_bqty )
			dw_imhist.SetItem(ll_r,"iosuqty",    ld_bqty )
			dw_imhist.SetItem(ll_r,"insdat",     ls_sudat )
			dw_imhist.SetItem(ll_r,"insemp",     gs_empno)
		
			dw_imhist.SetItem(ll_r,"io_confirm", 'Y')
			dw_imhist.SetItem(ll_r,"io_date",    ls_sudat)
			dw_imhist.SetItem(ll_r,"io_empno",    gs_empno)
		
			dw_imhist.SetItem(ll_r,"filsk", 'Y'  )
			dw_imhist.SetItem(ll_r,"decisionyn", 'Y')
			
			dw_imhist.SetItem(ll_r,"yebi1",      ls_sudat)  // 검수하지 않는 업체이면 출고일자가 검수일자
		
			dw_imhist.SetItem(ll_r,"ioreemp",    gs_empno)
			dw_imhist.SetItem(ll_r,"saupj",      ls_saupj )
			dw_imhist.SetItem(ll_r,"inpcnf", 'O')   // 입출고구분(출고)
			dw_imhist.SetItem(ll_r,"botimh",'')
			dw_imhist.SetItem(ll_r,"outchk",'N')
		
			dw_imhist.SetItem(ll_r,"qcgub",'1')
			dw_imhist.SetItem(ll_r,"bigo",'마감-> 입고')
			dw_imhist.SetItem(ll_r,"jnpcrt", ls_jnpcrt )
			dw_imhist.SetItem(ll_r,"facgbn", ls_factory)
		
			ls_iogbn     = 'OZ5' 
			ls_jnpcrt    = '005'
			
			ll_r = dw_imhist.InsertRow(0)
			
			ls_iojpno2 = ls_jpno+String(ll_r,'000')
			
			ls_nextdt = f_afterday(ls_sudat,1)
			
			Select fun_erp100000012_2(:ls_nextdt , :ls_cvcod , :ls_itnbr , '1' ) Into :ld_price
			  From dual ;
	
			dw_imhist.SetItem(ll_r,"iojpno", 	 ls_iojpno2)
			dw_imhist.SetItem(ll_r,"iogbn", 		 ls_iogbn )
			dw_imhist.SetItem(ll_r,"sudat", 		 ls_nextdt)
			dw_imhist.SetItem(ll_r,"itnbr", 		 ls_itnbr)
			dw_imhist.SetItem(ll_r,"cvcod",      ls_cvcod)
			dw_imhist.SetItem(ll_r,"depot_no",   ls_depot_no)
			dw_imhist.SetItem(ll_r,"ioqty",      ld_bqty )
			dw_imhist.SetItem(ll_r,"ioprc",      ld_price )
		
			dw_imhist.SetItem(ll_r,"ioamt",      TrunCate(ld_price * ld_bqty,0))
			dw_imhist.SetItem(ll_r,"ioreqty",    ld_bqty )
			dw_imhist.SetItem(ll_r,"iosuqty",    ld_bqty )
			dw_imhist.SetItem(ll_r,"insdat",     ls_nextdt )
			dw_imhist.SetItem(ll_r,"insemp",     gs_empno)
		
			dw_imhist.SetItem(ll_r,"io_confirm", 'Y')
			dw_imhist.SetItem(ll_r,"io_date",    ls_nextdt)
			dw_imhist.SetItem(ll_r,"io_empno",    gs_empno)
		
			dw_imhist.SetItem(ll_r,"filsk", 'Y'  )
			dw_imhist.SetItem(ll_r,"decisionyn", 'Y')
			
			dw_imhist.SetItem(ll_r,"yebi1",      ls_nextdt)  // 검수하지 않는 업체이면 출고일자가 검수일자
		
			dw_imhist.SetItem(ll_r,"ioreemp",    gs_empno)
			dw_imhist.SetItem(ll_r,"saupj",      ls_saupj )
			dw_imhist.SetItem(ll_r,"inpcnf", 'O')   // 입출고구분(출고)
			dw_imhist.SetItem(ll_r,"botimh",'')
			dw_imhist.SetItem(ll_r,"outchk",'N')
		
			dw_imhist.SetItem(ll_r,"qcgub",'1')
			dw_imhist.SetItem(ll_r,"jnpcrt", ls_jnpcrt )
			dw_imhist.SetItem(ll_r,"facgbn", ls_factory)
			dw_imhist.SetItem(ll_r,"ip_jpno", ls_iojpno1)
			dw_imhist.SetItem(ll_r,"bigo",'마감-> 이월반품')
		
		End if 
	End if
	
Loop

Close mon_cur;

If dw_imhist.RowCount() > 0 Then
	if dw_imhist.Update() <> 1 Then
		Rollback;
		MessageBox('확인','저장실패')
		Return
	End If
	
	Commit ;
End if

p_inq.TriggerEvent(Clicked!)

MessageBox('확인','모비스(AUTO) 마감자료 생성 완료')



end event

type dw_imhist from datawindow within w_sm40_0057
boolean visible = false
integer x = 251
integer y = 1188
integer width = 4073
integer height = 620
integer taborder = 110
boolean bringtotop = true
boolean titlebar = true
string title = "none"
string dataobject = "d_sm40_0010_imhist"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean border = false
boolean livescroll = true
end type

type cb_hkmc from commandbutton within w_sm40_0057
boolean visible = false
integer x = 5134
integer y = 228
integer width = 736
integer height = 84
integer taborder = 110
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "HKMC 마감자료 일괄생성"
end type

event clicked;string ls_saupj ,ls_sdate, ls_factory, ls_itnbr , snull , ls_iojpno , ls_jpno
String ls_iojpno1 , ls_iojpno2
String ls_iogbn1 , ls_jnpcrt1 
String ls_iogbn2 , ls_jnpcrt2 
String ls_ipsource1 , ls_bigo1
String ls_ipsource2 , ls_bigo2
Long   ll_r , ll_cnt , ll_seq 
String ls_cvcod , ls_depot_no , ls_sudat  

Dec  ld_ioqty , ld_iptqty , ld_lipqty , ld_vipqty ,ld_tqty , ld_bqty , ld_price
Dec  ld_lamt , ld_vamt
Dec  ld_cl_qty  , ld_cv_qty  ,ld_cvamt  ,ld_clamt

Long i , ll_rcnt , ii ,ll_bar
String ls_fdt , ls_tdt , ls_premon , ls_lvgb , ls_yebi1

String ls_gubun , ls_rtn

if dw_detail.accepttext() = -1 then return

ls_saupj  = trim(dw_detail.getitemstring(1, "saupj"))
ls_sdate  = trim(dw_detail.getitemstring(1, "sdate"))

if isnull(ls_sdate) or trim(ls_sdate) = '' then
	f_message_chk(30, '[검수월]')
	dw_detail.SetColumn("sdate")
	dw_detail.SetFocus()
	return
end if

if rb_1.Checked then
	ls_gubun = 'HKMC'
else
	ls_gubun = 'X'
end if

ls_rtn = wf_confirm( ls_saupj , ls_sdate , ls_gubun ) 

if ls_rtn = 'Y' Then
	MessageBox('확인','이미 확정된 매출전표입니다. 매출자료 수정 불가능합니다.') 
	return 
end if


/* 매출마감 여부 체크  ========================================== */
SELECT COUNT(*)  INTO :ll_cnt
  FROM "JUNPYO_CLOSING"  
WHERE ( "JUNPYO_CLOSING"."SABU" = :gs_sabu ) AND  
		( "JUNPYO_CLOSING"."JPGU" = 'G0' ) AND  
		( "JUNPYO_CLOSING"."JPDAT" >= substr(:ls_sdate,1,6) );
		
If ll_cnt >= 1 then
	f_message_chk(60,'[매출마감]')
	Return
End if
//================================================================

SetPointer(HourGlass!)

SetNull(ls_jpno)

ls_sudat = f_last_date(ls_sdate+'01')
ll_seq = sqlca.fun_junpyo(gs_sabu,ls_sudat,'C0')
IF ll_seq <= 0 THEN
	f_message_chk(51,'')
	ROLLBACK;
	Return 1
END IF
commit;
ls_jpno = ls_sudat+String(ll_seq,'0000')

dw_imhist.Reset()

DataStore lds_io 

lds_io = Create DataStore ;

lds_io.DataObject = "d_sm40_0057_popup"
lds_io.SetTransObject(SQLCA)

ls_fdt = ls_sdate + '01'
ls_tdt = f_last_date(ls_fdt)
ls_premon = f_aftermonth(ls_sdate , 1 )

// 입고 창고 검색
SELECT min(cvcod)  into :ls_depot_no
  From vndmst
 where cvgu = '5'
   and ipjogun = :ls_saupj
	and soguan = '1' ;
	
If ls_depot_no = '' Or isNull(ls_depot_no) Then
	If gs_saupj = '10' Then
		ls_depot_no = 'Z015'
	Else
		ls_depot_no = 'Z025'
	End iF
End If

//  수입 , 수출 구분 입출고 이력 ============================================================

hpb_1.visible = True
st_bar.visible = True
hpb_1.maxposition =  100
hpb_1.setstep = 1
hpb_1.position = 0
ll_bar = dw_insert.RowCount()

FOR i = 1 To ll_bar
	
	Yield()
	hpb_1.position = int((i/ll_bar)*100)
	
	ls_factory = Trim(dw_insert.object.factory[i])
	ls_itnbr = Trim(dw_insert.object.itnbr[i])
	
	st_bar.Text = "공장 : " + ls_factory + " / 품번 : " + ls_itnbr
	ll_cnt = 0 
	
	Select Count(*) Into :ll_cnt
	  From imhist
	 Where iogbn in ( 'OZ5' , 'OZ6')
	   and io_date = :ls_sudat
		and itnbr = :ls_itnbr 
		and facgbn = :ls_factory ;
		
	If ll_cnt > 0 Then Continue ;
	
	ld_iptqty = dw_insert.object.iptqty[i]
	ld_ioqty  = dw_insert.object.ioqty[i]
	
	If ( ld_iptqty <> ld_ioqty )  or ( ld_iptqty =0 and ld_ioqty = 0 ) Then Continue ;
	
	 SELECT 	SUM(DECODE(IPSOURCE,'L',IPTQTY, 0 )) AS L_IPTQTY ,
				SUM(DECODE(IPSOURCE,'V',IPTQTY, 0 )) AS V_IPTQTY 
		Into :ld_lipqty , :ld_vipqty 
	    FROM VAN_HKCD9
	   WHERE CUSTCD = fun_get_reffpf_value('AD',:ls_saupj,'4')
		  AND SUBSTR(DOCCODE,3,6) = :ls_premon
		  AND FACTORY = :ls_factory
		  AND MITNBR = :ls_itnbr ;
	If sqlca.sqlcode <> 0 Then
		MessageBox('확인',sqlca.sqlerrText)
		hpb_1.visible = False
		st_bar.visible = False
		Return
	End if
	
	ll_rcnt = lds_io.retrieve(gs_sabu,  ls_factory, ls_itnbr , ls_fdt , ls_tdt , ls_saupj )
	
	If ll_rcnt <= 0 Then Continue ;
	
	ld_cl_qty = lds_io.getitemDecimal(1, "cl_qty")
	ld_cv_qty = lds_io.getitemDecimal(1, "cv_qty")
	
	If ld_lipqty  = ld_cl_qty or ld_vipqty = ld_cv_qty Then
		Continue ;
	ElseIf ( ld_cl_qty + ld_cv_qty ) = ld_lipqty Then
		
		Update imhist Set lclgbn = 'L'
		            Where sabu = :gs_sabu 
						  and iogbn in ('OY2','O02')
						  and facgbn = :ls_factory
						  and io_date like :ls_sdate||'%'
						  and itnbr = :ls_itnbr ;
		If sqlca.sqlcode <> 0 Then
			Rollback;
			MessageBox('확인',ls_itnbr + ' 저장에러1')
			hpb_1.visible = False
			st_bar.visible = False
			Return
		End if
//		Messagebox('확인','저장건수 : '+ String(sqlca.sqlnrows)) 
		Continue ;
	ElseIf ( ld_cl_qty + ld_cv_qty ) = ld_vipqty Then
		
		Update imhist Set lclgbn = 'V'
		            Where sabu = :gs_sabu 
						  and iogbn in ('OY2','O02')
						  and facgbn = :ls_factory
						  and io_date like :ls_sdate||'%'
						  and itnbr = :ls_itnbr ;
		If sqlca.sqlcode <> 0 Then
			Rollback;
			MessageBox('확인',ls_itnbr + ' 저장에러1')
			hpb_1.visible = False
			st_bar.visible = False
			Return
		End if	
		Continue ;
	End if
	
	Select Decode(:ls_saupj , 
						 '10' ,
						  Substr(fun_get_reffpf_value('1G',:ls_factory , '1'),1,6) ,
						  Substr(fun_get_reffpf_value('1G',:ls_factory , '1'),-6,6) )
		  Into :ls_cvcod 
		  From dual ;
	

	ld_bqty = ld_lipqty - ld_cl_qty
	
	If ld_bqty < 0 Then
		ls_iogbn1     = 'OZ5' 
		ls_jnpcrt1    = '005'
		ls_iogbn2     = 'OZ6' 
		ls_jnpcrt2    = '024'
		ls_ipsource1 = 'L'
		ls_ipsource2 = 'V'
		ls_bigo1 = 'LOCAL 수출 마감조정-수출반품'
		ls_bigo2 = 'LOCAL 수출 마감조정-내수출고'
	
	Else
		ls_iogbn1     = 'OZ6' 
		ls_jnpcrt1    = '024'
		ls_iogbn2     = 'OZ5' 
		ls_jnpcrt2    = '005'
		ls_ipsource1 = 'L'
		ls_ipsource2 = 'V'
		ls_bigo1 = 'LOCAL 수출 마감조정-수출출고'
		ls_bigo2 = 'LOCAL 수출 마감조정-내수반품'
	
	End if
	
	Select fun_erp100000012_2(:ls_sudat , :ls_cvcod , :ls_itnbr , '1' ) Into :ld_price
			  From dual ;

	ld_bqty = abs(ld_bqty)
	
	ll_r = dw_imhist.InsertRow(0)
	
	ls_iojpno1 = ls_jpno+String(ll_r,'000')
	

	dw_imhist.SetItem(ll_r,"iojpno", 	 ls_iojpno1)
	dw_imhist.SetItem(ll_r,"iogbn", 		 ls_iogbn1 )
	dw_imhist.SetItem(ll_r,"sudat", 		 ls_sudat)
	dw_imhist.SetItem(ll_r,"itnbr", 		 ls_itnbr)
	dw_imhist.SetItem(ll_r,"cvcod",      ls_cvcod)
	dw_imhist.SetItem(ll_r,"depot_no",   ls_depot_no)
	dw_imhist.SetItem(ll_r,"ioqty",      ld_bqty )
	dw_imhist.SetItem(ll_r,"ioprc",      ld_price )

	dw_imhist.SetItem(ll_r,"ioamt",      TrunCate(ld_price * ld_bqty,0))
	dw_imhist.SetItem(ll_r,"ioreqty",    ld_bqty )
	dw_imhist.SetItem(ll_r,"iosuqty",    ld_bqty )
	dw_imhist.SetItem(ll_r,"insdat",     ls_sudat )
	dw_imhist.SetItem(ll_r,"insemp",     gs_empno)

	dw_imhist.SetItem(ll_r,"io_confirm", 'Y')
	dw_imhist.SetItem(ll_r,"io_date",    ls_sudat)
	dw_imhist.SetItem(ll_r,"io_empno",    gs_empno)

	dw_imhist.SetItem(ll_r,"filsk", 'Y'  )
	dw_imhist.SetItem(ll_r,"decisionyn", 'Y')
	
	dw_imhist.SetItem(ll_r,"yebi1",      ls_sudat)  // 검수하지 않는 업체이면 출고일자가 검수일자

	dw_imhist.SetItem(ll_r,"ioreemp",    gs_empno)
	dw_imhist.SetItem(ll_r,"saupj",      ls_saupj )
	dw_imhist.SetItem(ll_r,"inpcnf", 'O')   // 입출고구분(출고)
	dw_imhist.SetItem(ll_r,"botimh",'')
	dw_imhist.SetItem(ll_r,"outchk",'N')

	dw_imhist.SetItem(ll_r,"qcgub",'1')
	dw_imhist.SetItem(ll_r,"bigo" , ls_bigo1)
	dw_imhist.SetItem(ll_r,"jnpcrt", ls_jnpcrt1 )
	dw_imhist.SetItem(ll_r,"facgbn", ls_factory)
	dw_imhist.SetItem(ll_r,"lclgbn", ls_ipsource1)
	dw_imhist.SetItem(ll_r,"pjt_cd",'HKMC')

	ll_r = dw_imhist.InsertRow(0)
	
	ls_iojpno2 = ls_jpno+String(ll_r,'000')

	dw_imhist.SetItem(ll_r,"iojpno", 	 ls_iojpno2)
	dw_imhist.SetItem(ll_r,"iogbn", 		 ls_iogbn2 )
	dw_imhist.SetItem(ll_r,"sudat", 		 ls_sudat)
	dw_imhist.SetItem(ll_r,"itnbr", 		 ls_itnbr)
	dw_imhist.SetItem(ll_r,"cvcod",      ls_cvcod)
	dw_imhist.SetItem(ll_r,"depot_no",   ls_depot_no)
	dw_imhist.SetItem(ll_r,"ioqty",      ld_bqty )
	dw_imhist.SetItem(ll_r,"ioprc",      ld_price )

	dw_imhist.SetItem(ll_r,"ioamt",      TrunCate(ld_price * ld_bqty,0))
	dw_imhist.SetItem(ll_r,"ioreqty",    ld_bqty )
	dw_imhist.SetItem(ll_r,"iosuqty",    ld_bqty )
	dw_imhist.SetItem(ll_r,"insdat",     ls_sudat )
	dw_imhist.SetItem(ll_r,"insemp",     gs_empno)

	dw_imhist.SetItem(ll_r,"io_confirm", 'Y')
	dw_imhist.SetItem(ll_r,"io_date",    ls_sudat)
	dw_imhist.SetItem(ll_r,"io_empno",    gs_empno)

	dw_imhist.SetItem(ll_r,"filsk", 'Y'  )
	dw_imhist.SetItem(ll_r,"decisionyn", 'Y')
	
	dw_imhist.SetItem(ll_r,"yebi1",      ls_sudat)  // 검수하지 않는 업체이면 출고일자가 검수일자

	dw_imhist.SetItem(ll_r,"ioreemp",    gs_empno)
	dw_imhist.SetItem(ll_r,"saupj",      ls_saupj )
	dw_imhist.SetItem(ll_r,"inpcnf", 'O')   // 입출고구분(출고)
	dw_imhist.SetItem(ll_r,"botimh",'')
	dw_imhist.SetItem(ll_r,"outchk",'N')
	
	dw_imhist.SetItem(ll_r,"qcgub",'1')
	dw_imhist.SetItem(ll_r,"bigo" , ls_bigo2)
	dw_imhist.SetItem(ll_r,"jnpcrt", ls_jnpcrt2 )
	dw_imhist.SetItem(ll_r,"facgbn", ls_factory)
	dw_imhist.SetItem(ll_r,"lclgbn", ls_ipsource2)
	dw_imhist.SetItem(ll_r,"pjt_cd",'HKMC')
	dw_imhist.SetItem(ll_r,"ip_jpno", ls_iojpno1)

	
Next
	
If dw_imhist.RowCount() > 0 Then
	if dw_imhist.Update() <> 1 Then
		Rollback;
		MessageBox('확인','저장실패')
		hpb_1.visible = False
	st_bar.visible = False
		Return
	End If
	
	Commit ;
End if

commit ;


// 단가 소급 데이타 ====================================================
SetNull(ls_jpno)

ll_seq = sqlca.fun_junpyo(gs_sabu,ls_sudat,'C0')
IF ll_seq <= 0 THEN
	f_message_chk(51,'')
	ROLLBACK;
	Return 1
END IF
commit;
ls_jpno = ls_sudat+String(ll_seq,'0000')

hpb_1.maxposition =  100
hpb_1.setstep = 1
hpb_1.position = 0
ll_bar = dw_insert.RowCount()

dw_imhist.Reset()

FOR i = 1 To ll_bar
	
	Yield()
	hpb_1.position = int((i/ll_bar)*100)
	
	ls_factory = Trim(dw_insert.object.factory[i])
	ls_itnbr = Trim(dw_insert.object.itnbr[i])
	
	st_bar.Text = "공장 : " + ls_factory + " / 품번 : " + ls_itnbr
	ll_cnt = 0 

	Select Count(*) Into :ll_cnt
	  From imhist
	 Where iogbn in ( 'OY5' , 'OY6')
	   and io_date = :ls_sudat
		and itnbr = :ls_itnbr 
		and facgbn = :ls_factory ;
		
	If ll_cnt > 0 Then Continue ;
	
	ld_iptqty = dw_insert.object.iptqty[i]
	ld_ioqty  = dw_insert.object.ioqty[i]
	
	If ( ld_iptqty <> ld_ioqty )   Then Continue ;
	
	 SELECT 	SUM(DECODE(IPSOURCE,'L',IPTQTY, 0 )) AS L_IPTQTY ,
				SUM(DECODE(IPSOURCE,'V',IPTQTY, 0 )) AS V_IPTQTY ,
				SUM(DECODE(IPSOURCE,'L',IPTAMT, 0 )) AS L_IPTAMT ,
				SUM(DECODE(IPSOURCE,'V',IPTAMT, 0 )) AS V_IPTAMT 
		Into :ld_lipqty , :ld_vipqty , :ld_lamt , :ld_vamt
	    FROM VAN_HKCD9
	   WHERE CUSTCD = fun_get_reffpf_value('AD',:ls_saupj,'4')
		  AND SUBSTR(DOCCODE,3,6) = :ls_premon
		  AND FACTORY = :ls_factory
		  AND MITNBR = :ls_itnbr ;
	If sqlca.sqlcode <> 0 Then
		MessageBox('확인',sqlca.sqlerrText)
		hpb_1.visible = False
		st_bar.visible = False
		Return
	End if

	ll_rcnt = lds_io.retrieve(gs_sabu,  ls_factory, ls_itnbr , ls_fdt , ls_tdt , ls_saupj )
	
	If ll_rcnt <= 0 Then 
		ld_cl_qty = 0
		ld_cv_qty = 0
		
		ld_cvamt = 0
		ld_clamt = 0
	Else
		ld_cl_qty = lds_io.getitemDecimal(1, "cl_qty")
		ld_cv_qty = lds_io.getitemDecimal(1, "cv_qty")
		
		ld_cvamt = lds_io.GetItemDecimal(1, "cv_amt")
		ld_clamt = lds_io.GetItemDecimal(1, "cl_amt")
	End if 
	
	If (ld_vipqty <> ld_cv_qty) or (ld_lipqty <> ld_cl_qty) Then Continue ;

	If ld_vamt = ld_cvamt and ld_lamt = ld_clamt Then Continue ;
	
	Select Decode(:ls_saupj , 
					 '10' ,
					  Substr(fun_get_reffpf_value('1G',:ls_factory , '1'),1,6) ,
					  Substr(fun_get_reffpf_value('1G',:ls_factory , '1'),-6,6) )
	  Into :ls_cvcod 
	  From dual ;

	If  ld_vamt <> ld_cvamt  Then
		
//		If ld_cv_qty = 0 and ld_vamt <> 0 Then 
		If ld_cv_qty = 0 Then 
			ld_cv_qty = 1 
		End if	
		
		For ii = 1 TO 2
			
			ll_r = dw_imhist.InsertRow(0)
			dw_imhist.SetItem(ll_r,"sabu",       gs_sabu)
			dw_imhist.SetItem(ll_r,"iojpno",     ls_jpno+String(ll_r,'000'))
			
			If ii= 1  Then
				dw_imhist.SetItem(ll_r,"iogbn", 		 'OY6')
				dw_imhist.SetItem(ll_r,"ioqty",       ld_cv_qty * -1 )
				dw_imhist.SetItem(ll_r,"ioreqty",     ld_cv_qty * -1)
				dw_imhist.SetItem(ll_r,"iosuqty",     ld_cv_qty * -1)
				dw_imhist.SetItem(ll_r,"ioamt",       ld_cvamt  )
				dw_imhist.SetItem(ll_r,"ioprc",       Round(ld_cvamt/ld_cv_qty,5))
				dw_imhist.SetItem(ll_r,"inpcnf", 'I')
			Else
				dw_imhist.SetItem(ll_r,"iogbn", 		 'OY5')
				dw_imhist.SetItem(ll_r,"ioqty",       ld_cv_qty )
				dw_imhist.SetItem(ll_r,"ioreqty",     ld_cv_qty)
				dw_imhist.SetItem(ll_r,"iosuqty",     ld_cv_qty)
				dw_imhist.SetItem(ll_r,"ioamt",      ld_vamt)
				dw_imhist.SetItem(ll_r,"ioprc",      Round(ld_vamt/ld_cv_qty,5))
				dw_imhist.SetItem(ll_r,"inpcnf", 'O')
			End If
			
			dw_imhist.SetItem(ll_r,"sudat", 		 ls_sudat )
			dw_imhist.SetItem(ll_r,"cvcod",      ls_cvcod )
			dw_imhist.SetItem(ll_r,"depot_no",   ls_depot_no)
			
			dw_imhist.SetItem(ll_r,"itnbr",      ls_itnbr) 
			dw_imhist.SetItem(ll_r,"insdat",     ls_sudat)
		
			dw_imhist.SetItem(ll_r,"io_confirm", 'Y')
			dw_imhist.SetItem(ll_r,"io_date",    ls_sudat)
			dw_imhist.SetItem(ll_r,"filsk",      'N')
			dw_imhist.SetItem(ll_r,"decisionyn", 'Y')
			dw_imhist.SetItem(ll_r,"yebi1",      ls_sudat)
			
			dw_imhist.SetItem(ll_r,"ioreemp",    gs_empno)
			dw_imhist.SetItem(ll_r,"saupj",      ls_saupj )
			dw_imhist.SetItem(ll_r,"facgbn",     ls_factory  )
			dw_imhist.SetItem(ll_r,"lclgbn",     'V' )
			
			dw_imhist.SetItem(ll_r,"botimh",'')
			dw_imhist.SetItem(ll_r,"outchk",'N')
			dw_imhist.SetItem(ll_r,"qcgub",'1')
			dw_imhist.SetItem(ll_r,"jnpcrt",'036')
			dw_imhist.SetItem(ll_r,"bigo",'마감 단가소급')
			dw_imhist.SetItem(ll_r,"pjt_cd",'HKMC')
		Next
		
	End if
	
	If  ld_lamt <> ld_clamt  Then
		
		If ld_cl_qty = 0  and ld_lamt <> 0 Then
			
			ld_cl_qty = 1 
		End if
		
		For ii = 1 TO 2
		
			ll_r = dw_imhist.InsertRow(0)
			dw_imhist.SetItem(ll_r,"sabu",       gs_sabu)
			dw_imhist.SetItem(ll_r,"iojpno",     ls_jpno+String(ll_r,'000'))
			
			If ii= 1  Then
				dw_imhist.SetItem(ll_r,"iogbn", 		 'OY6')
				dw_imhist.SetItem(ll_r,"ioqty",       ld_cl_qty * -1 )
				dw_imhist.SetItem(ll_r,"ioreqty",     ld_cl_qty * -1)
				dw_imhist.SetItem(ll_r,"iosuqty",     ld_cl_qty * -1)
				dw_imhist.SetItem(ll_r,"ioamt",      ld_clamt  )
				dw_imhist.SetItem(ll_r,"ioprc",      Round(ld_clamt/ld_cl_qty,5))
				dw_imhist.SetItem(ll_r,"inpcnf", 'I')
			Else
				dw_imhist.SetItem(ll_r,"iogbn", 		 'OY5')
				dw_imhist.SetItem(ll_r,"ioqty",       ld_cl_qty )
				dw_imhist.SetItem(ll_r,"ioreqty",     ld_cl_qty)
				dw_imhist.SetItem(ll_r,"iosuqty",     ld_cl_qty)
				dw_imhist.SetItem(ll_r,"ioamt",      ld_lamt)
				dw_imhist.SetItem(ll_r,"ioprc",      Round(ld_lamt/ld_cl_qty,5))
				dw_imhist.SetItem(ll_r,"inpcnf", 'O')
			End If
			
			dw_imhist.SetItem(ll_r,"sudat", 		 ls_sudat )
			dw_imhist.SetItem(ll_r,"cvcod",      ls_cvcod)
			dw_imhist.SetItem(ll_r,"depot_no",   ls_depot_no)
			
			dw_imhist.SetItem(ll_r,"itnbr",     ls_itnbr) 
			dw_imhist.SetItem(ll_r,"insdat",     ls_sudat)
		
			dw_imhist.SetItem(ll_r,"io_confirm", 'Y')
			dw_imhist.SetItem(ll_r,"io_date",    ls_sudat)
			dw_imhist.SetItem(ll_r,"filsk",      'N')
			dw_imhist.SetItem(ll_r,"decisionyn", 'Y')
			dw_imhist.SetItem(ll_r,"yebi1",      ls_sudat)
			
			dw_imhist.SetItem(ll_r,"ioreemp",    gs_empno)
			dw_imhist.SetItem(ll_r,"saupj",      ls_saupj )
			dw_imhist.SetItem(ll_r,"facgbn",     ls_factory )
			dw_imhist.SetItem(ll_r,"lclgbn",     'L' )
			
			dw_imhist.SetItem(ll_r,"botimh",'')
			dw_imhist.SetItem(ll_r,"outchk",'N')
			dw_imhist.SetItem(ll_r,"qcgub",'1')
			dw_imhist.SetItem(ll_r,"jnpcrt",'036')
			dw_imhist.SetItem(ll_r,"bigo",'마감 단가소급')
			dw_imhist.SetItem(ll_r,"pjt_cd",'HKMC')
		Next
		
	End if
	
Next
	
If dw_imhist.RowCount() > 0 Then
	if dw_imhist.Update() <> 1 Then
		Rollback;
		MessageBox('확인','저장실패')
		hpb_1.visible = False
	   st_bar.visible = False
		Return
	End If
	
	Commit ;
End if

commit ;



//=====================================================================
hpb_1.visible = False
st_bar.visible = False
p_inq.TriggerEvent(Clicked!)

MessageBox('확인','HKMC 수출입 마감자료 생성 완료')



end event

type hpb_1 from hprogressbar within w_sm40_0057
integer x = 1518
integer y = 904
integer width = 1573
integer height = 80
boolean bringtotop = true
unsignedinteger maxposition = 100
unsignedinteger position = 50
integer setstep = 10
end type

type st_bar from statictext within w_sm40_0057
integer x = 1518
integer y = 1004
integer width = 1573
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 32106727
string text = "* 데이타를 읽고 있습니다....."
alignment alignment = center!
boolean focusrectangle = false
end type

type st_bigo from statictext within w_sm40_0057
integer x = 41
integer y = 264
integer width = 2025
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
string text = "* 검수수량과 출고수량이 상이하면 마감자료 일괄생성에서 제외 됩니다."
alignment alignment = center!
boolean focusrectangle = false
end type

type p_2 from uo_picture within w_sm40_0057
boolean visible = false
integer x = 4933
integer y = 376
integer width = 178
boolean bringtotop = true
string picturename = "C:\erpman\image\확정_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\확정_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\확정_up.gif"
end event

event clicked;call super::clicked;
string ls_saupj ,ls_sdate, ls_factory, ls_itnbr , snull
String ls_gubun , ls_rtn

if dw_detail.accepttext() = -1 then return

ls_saupj  = trim(dw_detail.getitemstring(1, "saupj"))
ls_sdate  = trim(dw_detail.getitemstring(1, "sdate"))
ls_factory  = trim(dw_detail.getitemstring(1, "factory"))
ls_itnbr= trim(dw_detail.getitemstring(1, "itnbr"))

if dw_Insert.RowCount() < 1 Then return 

if rb_1.Checked then
	ls_gubun = 'HKMC'
else
	ls_gubun = 'X'
end if

ls_rtn = wf_confirm( ls_saupj , ls_sdate , ls_gubun ) 

if ls_rtn = 'Y' Then
	MessageBox('확인','이미 확정된 매출전표입니다.') 
	return 
end if

Int ll_rtn
ll_rtn = MessageBox("확인", "매출전표를 확정 하시겠습니까?", Exclamation!, OKCancel!, 2)

pointer oldpointer 
oldpointer = SetPointer(HourGlass!)


IF ll_rtn <>  1 THEN Return 
// HKMC 매출확정 =======================================================================
if rb_1.Checked Then
	
	Update imhist x set x.sale_mayymm = :ls_sdate
					  where exists (select 'x'
										  from imhist a ,iomatrix b
										 where a.sabu = b.sabu
											and a.iogbn = b.iogbn
											and b.salegu = 'Y'
											and a.yebi1 like :ls_sdate||'%'
											and a.saupj = :ls_saupj
									/*		and a.facgbn <> 'L1' */
											and exists ( select 'X' from van_hkcd0_ne where factory = a.facgbn) 
											and a.iojpno = x.iojpno ) ;
	
	if sqlca.sqlcode <> 0 or sqlca.sqlnrows < 1 then
		rollback ;
		MessageBox("확정실패1" , "확정실패")
		return
	else
		
		Insert into SALE_MAGAM
		Select :ls_sdate as mayymm ,
		       a.iojpno ,
				 a.cvcod  ,
				 a.itnbr ,
				 a.ioamt ,
				 a.facgbn 
		  from imhist a ,iomatrix b
		 where a.sabu = b.sabu
			and a.iogbn = b.iogbn
			and b.salegu = 'Y'
			and a.yebi1 like :ls_sdate||'%'
			and a.saupj = :ls_saupj
		/*	and a.facgbn <> 'L1' */
			and exists ( select 'X' from van_hkcd0_ne where factory = a.facgbn) ;
												
		if sqlca.sqlcode <> 0 or sqlca.sqlnrows < 1 then
			rollback ;
			MessageBox("확정실패2" , "확정실패")
			return
		else
			commit;
			
			dw_detail.object.confirm[1] = 'Y'
			w_mdi_frame.sle_msg.text ="매출전표를 확정완료 하였습니다."
		end if
		
	end if
else
// 기타업체 매출확정 ========================================================================
	Update imhist x set x.sale_mayymm = :ls_sdate
					  where exists (select 'x'
										  from imhist a ,iomatrix b
										 where a.sabu = b.sabu
											and a.iogbn = b.iogbn
											and b.salegu = 'Y'
											and a.io_date like :ls_sdate||'%'
											and a.saupj = :ls_saupj
											/*and a.facgbn = 'L1'*/
											and exists ( select 'X' from van_hkcd0_ne where factory = a.facgbn) 
											and a.iojpno = x.iojpno 
										 union all
										 Select 'x'
										  from imhist a ,iomatrix b
										 where a.sabu = b.sabu
											and a.iogbn = b.iogbn
											and b.salegu = 'Y'
											and a.sabu = '1'
											and a.saupj = :ls_saupj 
											and substr(a.io_date,1,6) = :ls_sdate
											and not exists ( select 'X' from van_hkcd0_ne where factory = a.facgbn) 
											and a.iojpno = x.iojpno  ) ;

		
	if sqlca.sqlcode <> 0 or sqlca.sqlnrows < 1 then
		rollback ;
		MessageBox("확정실패" , "확정실패")
		return
	else
		
		Insert into SALE_MAGAM
		Select :ls_sdate as mayymm ,
		       a.iojpno ,
				 a.cvcod  ,
				 a.itnbr ,
				 a.ioamt ,
				 a.facgbn 
		  from imhist a ,iomatrix b
		 where a.sabu = b.sabu
			and a.iogbn = b.iogbn
			and b.salegu = 'Y'
			and a.io_date like :ls_sdate||'%'
			and a.saupj = :ls_saupj
		/*	and a.facgbn = 'L1' */
			and exists ( select 'X' from van_hkcd0_ne where factory = a.facgbn) 
		union all
		Select :ls_sdate as mayymm ,
		       a.iojpno ,
				 a.cvcod  ,
				 a.itnbr ,
				 a.ioamt ,
				 a.facgbn 
		  from imhist a ,iomatrix b
		 where a.sabu = b.sabu
			and a.iogbn = b.iogbn
			and b.salegu = 'Y'
			and a.sabu = '1'
			and a.saupj = :ls_saupj 
			and substr(a.io_date,1,6) = :ls_sdate
			and not exists ( select 'X' from van_hkcd0_ne where factory = a.facgbn)
		;
												
		if sqlca.sqlcode <> 0 or sqlca.sqlnrows < 1 then
			rollback ;
			MessageBox("확정실패" , "확정실패")
			return
		else
			commit;
			dw_detail.object.confirm[1] = 'Y'
			w_mdi_frame.sle_msg.text ="매출전표를 확정완료 하였습니다."
		end if
		
	end if
end if

SetPointer(oldpointer)


end event

type p_3 from uo_picture within w_sm40_0057
boolean visible = false
integer x = 5106
integer y = 376
integer width = 178
boolean bringtotop = true
string picturename = "C:\erpman\image\확정취소_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\확정취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\확정취소_up.gif"
end event

event clicked;call super::clicked;
string ls_saupj ,ls_sdate, ls_factory, ls_itnbr , snull
String ls_gubun , ls_rtn

if dw_detail.accepttext() = -1 then return

ls_saupj  = trim(dw_detail.getitemstring(1, "saupj"))
ls_sdate  = trim(dw_detail.getitemstring(1, "sdate"))
ls_factory  = trim(dw_detail.getitemstring(1, "factory"))
ls_itnbr= trim(dw_detail.getitemstring(1, "itnbr"))

if dw_Insert.RowCount() < 1 Then return 

if rb_1.Checked then
	ls_gubun = 'HKMC'
else
	ls_gubun = 'X'
end if

ls_rtn = wf_confirm( ls_saupj , ls_sdate , ls_gubun ) 

if ls_rtn = 'N' Then
	MessageBox('확인','확정된 매출전표가 존재하지 않습니다.') 
	return 
end if

Int ll_rtn
ll_rtn = MessageBox("확인", "매출전표를 확정취소 하시겠습니까?", Exclamation!, OKCancel!, 2)

IF ll_rtn <>  1 THEN Return 

pointer oldpointer 
oldpointer = SetPointer(HourGlass!)

if rb_1.Checked Then
	
	Delete from SALE_MAGAM x 
	      where mayymm = :ls_sdate
			  and exists ( 
								Select'x'
								  from imhist a ,iomatrix b
								 where a.sabu = b.sabu
									and a.iogbn = b.iogbn
									and b.salegu = 'Y'
									and a.yebi1 like :ls_sdate||'%'
									and a.saupj = :ls_saupj
									and a.facgbn <> 'L1'
									and exists ( select 'X' from van_hkcd0_ne where factory = a.facgbn) 
									and a.iojpno = x.iojpno ) ;
									
	if sqlca.sqlcode <> 0 or sqlca.sqlnrows < 1 then
		rollback ;
		MessageBox("확정취소실패1" , "확정취소실패")
		return
	else
		
		Update imhist x set x.sale_mayymm = null
					  where exists (select 'x'
										  from imhist a ,iomatrix b
										 where a.sabu = b.sabu
											and a.iogbn = b.iogbn
											and b.salegu = 'Y'
											and a.yebi1 like :ls_sdate||'%'
											and a.saupj = :ls_saupj
											and a.facgbn <> 'L1'
											and exists ( select 'X' from van_hkcd0_ne where factory = a.facgbn) 
											and a.iojpno = x.iojpno ) ;
											
		if sqlca.sqlcode <> 0 or sqlca.sqlnrows < 1 then
			rollback ;
			MessageBox("확정취소실패2" , "확정취소실패")
			return
		else
			commit;
			dw_detail.object.confirm[1] = 'N'
			w_mdi_frame.sle_msg.text ="매출전표를 확정취소 하였습니다."
		end if;
		                   
	end if 
			
else
	
   Delete from SALE_MAGAM x 
	      where mayymm = :ls_sdate
			  and exists ( Select'x'
								  from imhist a ,iomatrix b
								 where a.sabu = b.sabu
									and a.iogbn = b.iogbn
									and b.salegu = 'Y'
									and a.io_date like :ls_sdate||'%'
									and a.saupj = :ls_saupj
									and a.facgbn = 'L1'
									and exists ( select 'X' from van_hkcd0_ne where factory = a.facgbn) 
									and a.iojpno = x.iojpno 
								union all
								Select 'x'
								  from imhist a ,iomatrix b
								 where a.sabu = b.sabu
									and a.iogbn = b.iogbn
									and b.salegu = 'Y'
									and a.sabu = '1'
									and a.saupj = :ls_saupj 
									and a.io_date like :ls_sdate||'%'
									and not exists ( select 'X' from van_hkcd0_ne where factory = a.facgbn)
									and a.iojpno = x.iojpno ) ;
	
	if sqlca.sqlcode <> 0 or sqlca.sqlnrows < 1 then
		rollback ;
		MessageBox("확정취소실패1" , "확정취소실패")
		return
	else
		
		Update imhist x set x.sale_mayymm = null
					  where exists (select 'x'
										  from imhist a ,iomatrix b
										 where a.sabu = b.sabu
											and a.iogbn = b.iogbn
											and b.salegu = 'Y'
											and a.io_date like :ls_sdate||'%'
											and a.saupj = :ls_saupj
											and a.facgbn = 'L1'
											and exists ( select 'X' from van_hkcd0_ne where factory = a.facgbn) 
											and a.iojpno = x.iojpno 
										 union all
										select 'x'
										  from imhist a ,iomatrix b
										 where a.sabu = b.sabu
											and a.iogbn = b.iogbn
											and b.salegu = 'Y'
											and a.io_date like :ls_sdate||'%'
											and a.saupj = :ls_saupj
											and not exists ( select 'X' from van_hkcd0_ne where factory = a.facgbn) 
											and a.iojpno = x.iojpno ) ;
											
		if sqlca.sqlcode <> 0 or sqlca.sqlnrows < 1 then
			rollback ;
			MessageBox("확정취소실패2" , "확정취소실패"+ sqlca.sqlerrText )
			return
		else
			commit;
			dw_detail.object.confirm[1] = 'N'
			w_mdi_frame.sle_msg.text ="매출전표를 확정취소 하였습니다."
			p_inq.TriggerEvent(Clicked!)
		end if;
		                   
	end if 
								
										
end if
SetPointer(oldpointer)

end event

type cbx_1 from checkbox within w_sm40_0057
integer x = 3127
integer y = 260
integer width = 457
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "소계만 표시"
end type

event clicked;dw_insert.setredraw(false)
dw_insert.modify("datawindow.detail.height=0")
dw_insert.setredraw(true)
end event

type p_4 from uo_excel_down within w_sm40_0057
integer x = 4242
integer y = 168
boolean bringtotop = true
boolean originalsize = false
end type

event clicked;If this.Enabled Then uf_excel_down(dw_insert)
end event

type gb_1 from groupbox within w_sm40_0057
integer x = 3470
integer width = 411
integer height = 252
integer taborder = 90
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
end type

type rr_1 from roundrectangle within w_sm40_0057
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 320
integer width = 4567
integer height = 1988
integer cornerheight = 40
integer cornerwidth = 55
end type

