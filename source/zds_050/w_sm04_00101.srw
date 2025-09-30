$PBExportHeader$w_sm04_00101.srw
$PBExportComments$추정 손익 현황
forward
global type w_sm04_00101 from w_inherite
end type
type dw_ip from u_key_enter within w_sm04_00101
end type
type dw_3 from datawindow within w_sm04_00101
end type
type st_2 from statictext within w_sm04_00101
end type
type st_3 from statictext within w_sm04_00101
end type
type rr_1 from roundrectangle within w_sm04_00101
end type
type rr_2 from roundrectangle within w_sm04_00101
end type
type dw_1 from datawindow within w_sm04_00101
end type
type dw_2 from datawindow within w_sm04_00101
end type
type st_4 from statictext within w_sm04_00101
end type
type dw_print from datawindow within w_sm04_00101
end type
type pb_1 from u_pb_cal within w_sm04_00101
end type
end forward

global type w_sm04_00101 from w_inherite
string title = "추정손익 현황"
dw_ip dw_ip
dw_3 dw_3
st_2 st_2
st_3 st_3
rr_1 rr_1
rr_2 rr_2
dw_1 dw_1
dw_2 dw_2
st_4 st_4
dw_print dw_print
pb_1 pb_1
end type
global w_sm04_00101 w_sm04_00101

type variables
string is_upmu
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sYymm, sdate, edate, sPlnt, sGrpNam, tx_name, tx_name1, arg_ym
String sSaupj
int    ii, jj

If dw_ip.AcceptText() <> 1 Then Return -1

sYymm = Trim(dw_ip.GetItemString(1, 'yymm'))
If IsNull(sYymm) Or sYymm = '' Then
	f_message_chk(1400,'')
	Return -1
End If
//해당 sm04_00100 table update
//dw_1.reset()
//dw_2.reset()

st_4.visible = True
SetPointer(HourGlass!)

 DECLARE sp_sm04_00100 procedure for sp_sm04_00100(:gs_userid, :syymm, 'Y') ;
 Execute sp_sm04_00100;
 close   sp_sm04_00100;
 
// FETCH SM03_CREATE_DATA_GMDAT INTO :iRtn;
// Choose Case iRtn
//	  Case 1
//			MessageBox('확인', '정상 완료')
//	  Case -1
//			MessageBox('확인', '삭제 실패')
//	  Case -2
//			MessageBox('확인', '자료생성 실패')
// End Choose
// 
// COMMIT;
// 
//
//IF dw_1.Retrieve(syymm) < 1 THEN
//	f_message_chk(50,'')
//	dw_ip.Setfocus()
//	return -1
//end if
//
//
//delete from sm04_00100 where userid = :gs_userid;
//commit;
//
//dw_2.retrieve(gs_userid)
//
//for ii = 1 to dw_1.rowcount() 
//	 jj = dw_2.insertrow(0)
//	 dw_2.Setitem(jj,'userid',gs_userid)
//	 dw_2.Setitem(jj,'grp',   dw_1.getItemString(ii, 'grp'))
//	 dw_2.Setitem(jj,'sor',   dw_1.getItemString(ii, 'sor'))
//	 dw_2.Setitem(jj,'acc',   dw_1.getItemString(ii, 'acc'))
//	 dw_2.Setitem(jj,'gb_nm', dw_1.getItemString(ii, 'gb_nm'))
//	 dw_2.Setitem(jj,'amt1',  dw_1.getItemNumber(ii, 'amt1'))
//	 dw_2.Setitem(jj,'amt2',  dw_1.getItemNumber(ii, 'amt2'))
//Next
//
//IF dw_2.Update() <> 1 THEN
//	MessageBox('자료생성실패(dw_2) ',sqlca.sqlerrText)
//	ROLLBACK;
//   return 1
//END IF
//
//insert into sm04_00100
//	  (select :gs_userid,'C','00','00','제조원가',sum(amt1), sum(amt2),0,0,0,0,0,0,0,0,0,0,0
//		  from sm04_00100
//		 where userid = :gs_userid
//		   and grp    in('D','E','F')
//     union
//		select :gs_userid,'D','00','00','재료비',sum(amt1), sum(amt2),0,0,0,0,0,0,0,0,0,0,0
//		  from sm04_00100
//		 where userid = :gs_userid
//		   and grp    = 'D'
//     union
//		select :gs_userid,'E','00','00','노무비',sum(amt1), sum(amt2),0,0,0,0,0,0,0,0,0,0,0
//		  from sm04_00100
//		 where userid = :gs_userid
//		   and grp    = 'E'
//     union
//		select :gs_userid,'E','50','99','    소계',sum(amt1), sum(amt2),0,0,0,0,0,0,0,0,0,0,0
//		  from sm04_00100
//		 where userid = :gs_userid
//		   and grp    = 'E'
//			and sor    between '41' and '49'
//     union
//		select :gs_userid,'E','90','99','    소계',sum(amt1), sum(amt2),0,0,0,0,0,0,0,0,0,0,0
//		  from sm04_00100
//		 where userid = :gs_userid
//		   and grp    = 'E'
//			and sor    between '60' and '90'
//     union
//		select :gs_userid,'F','00','00','경비',sum(amt1), sum(amt2),0,0,0,0,0,0,0,0,0,0,0
//		  from sm04_00100
//		 where userid = :gs_userid
//		   and grp    = 'F'
//     union
//		select :gs_userid,'G','00','00','영업이익',
//		        sum(decode(grp,'B',amt1,amt1 * -1)), 
//				  sum(decode(grp,'B',amt2,amt2 * -1)),0,0,0,0,0,0,0,0,0,0,0
//		  from sm04_00100
//		 where userid = :gs_userid
//		   and grp    between 'B' and 'F'
//     union
//		select :gs_userid,'J','00','00','경상이익',
//		        sum(decode(grp,'B',amt1,'H',amt1,amt1 * -1)), 
//				  sum(decode(grp,'B',amt2,'H',amt2,amt2 * -1)),0,0,0,0,0,0,0,0,0,0,0
//		  from sm04_00100
//		 where userid = :gs_userid
//		   and grp    between 'B' and 'I') ;
//commit;
//
SetPointer(Arrow!)
IF dw_insert.Retrieve(gs_userid) < 1 THEN
	f_message_chk(50,'')
	dw_ip.Setfocus()
	return -1
end if
st_4.visible = False

tx_name  = Left(sYymm,4) + '.' + Mid(sYymm,5,2)
tx_name1 = Left(sYymm,4) + '.01 - ' + Left(sYymm,4) + '.' + Mid(sYymm,5,2)
//dw_print.Modify("t_ym.text = '"+tx_name+"'")
//dw_print.Modify("t_yy.text = '"+tx_name1+"'")

return 1
end function

on w_sm04_00101.create
int iCurrent
call super::create
this.dw_ip=create dw_ip
this.dw_3=create dw_3
this.st_2=create st_2
this.st_3=create st_3
this.rr_1=create rr_1
this.rr_2=create rr_2
this.dw_1=create dw_1
this.dw_2=create dw_2
this.st_4=create st_4
this.dw_print=create dw_print
this.pb_1=create pb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_ip
this.Control[iCurrent+2]=this.dw_3
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.rr_1
this.Control[iCurrent+6]=this.rr_2
this.Control[iCurrent+7]=this.dw_1
this.Control[iCurrent+8]=this.dw_2
this.Control[iCurrent+9]=this.st_4
this.Control[iCurrent+10]=this.dw_print
this.Control[iCurrent+11]=this.pb_1
end on

on w_sm04_00101.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_ip)
destroy(this.dw_3)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.st_4)
destroy(this.dw_print)
destroy(this.pb_1)
end on

event open;call super::open;String syymm

dw_1.SetTransObject(sqlca)
dw_2.SetTransObject(sqlca)
dw_ip.SetTransObject(sqlca)
dw_print.SetTransObject(sqlca)
dw_ip.insertrow(0)
dw_insert.SetTransObject(sqlca)
st_4.visible = False
p_search.enabled = False
///* 최종계획년월 */
//SELECT MAX(MONYYMM) INTO :syymm FROM PM01_MONPLAN_SUM;
//dw_1.SetItem(1, 'syymm', sYymm)
dw_ip.SetItem(1, 'yymm', Left(gs_today,6))
end event

type dw_insert from w_inherite`dw_insert within w_sm04_00101
integer x = 69
integer y = 232
integer width = 2007
integer height = 2028
string dataobject = "d_sm04_00100_1"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event dw_insert::itemerror;call super::itemerror;return 1
end event

event dw_insert::rbuttondown;call super::rbuttondown;Integer iCurRow

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

iCurRow = this.GetRow()

end event

event dw_insert::buttonclicked;String syymm, sGrp, sSor, syymmt, sacc1, sacc2, sAcc, snm1, snm2
Long   nCnt
Double dAmt1

if dw_ip.AcceptText() = -1 then return 
if dw_insert.AcceptText() = -1 then return 

syymm  = trim(dw_ip.GetItemString(1,'yymm'))
sGrp   = trim(dw_insert.GetItemString(row,'grp'))
sAcc   = trim(dw_insert.GetItemString(row,'acc'))
sSor   = trim(dw_insert.GetItemString(row,'sor'))

	//if messagebox("확 인", '자료를 삭제하시겠습니까?', Question!, YesNo!, 2) = 2 then return
syymmt = syymm + '32'	
snm2   = ' 상세 내역'

IF sGrp = 'A' THEN
	st_2.text = '매출액' + snm2
	dw_3.DataObject = 'd_sm04_00100_sale'
	dw_3.SetTransObject(sqlca)
   dw_3.retrieve(syymm)
	
ElseIF sGrp = 'B' THEN
		st_2.text = '생산실적' + snm2
		dw_3.DataObject = 'd_sm04_00100_sang'
		dw_3.SetTransObject(sqlca)
		dw_3.retrieve(syymm)
	
ElseIF sGrp = 'D' and sSor = '31' then
		 st_2.text = '부재료비' + snm2 + '(재료비 상세:Double Click)'
		
		 dw_3.DataObject = 'd_sm04_00100_jaje2'
		 dw_3.SetTransObject(sqlca)
		 dw_3.retrieve(syymm)
	
ElseIF sGrp = 'D' and sSor = '32' then     //외주가공비
		 st_2.text = '외주가공비' + snm2
		
		 dw_3.DataObject = 'd_sm04_00100_wai'
		 dw_3.SetTransObject(sqlca)
		 dw_3.retrieve(syymm)
	
ElseIF sGrp = 'E' then     //노무비
		 st_2.text = '노무비' + snm2
		
		 dw_3.DataObject = 'd_sm04_00100_pay'
		 dw_3.SetTransObject(sqlca)
		 dw_3.retrieve(syymm,sGrp,sSor)
	
ElseIF sGrp = 'F' THEN
	if sAcc <> '00' then
		select rfna1 into :snm1  from reffpf where sabu = '1' and rfcod = 'AZ' and rfna2 = :sAcc and rfgub like '4%';
		st_2.text = Trim(snm1) + snm2
		select rfgub into :sacc1 from reffpf where sabu = '1' and rfcod = 'AZ' and rfna2 = :sAcc and rfgub like '4%';
		select rfgub into :sacc2 from reffpf where sabu = '1' and rfcod = 'AZ' and rfna2 = :sAcc and rfgub like '5%';
		
		dw_3.DataObject = 'd_sm04_00100_acc'
		dw_3.SetTransObject(sqlca)
		dw_3.retrieve(sGrp,syymm,syymmt,sacc1,sacc2)
		if dw_3.Getrow() <= 0 then
			if sAcc = '111' then
				select to_char(max(rfna4),'999,999,999') into :snm2 from reffpf where rfcod = 'AZ' and rfna2 = '111';
				messagebox("",'감가상각은 ' + snm2 + ' 원 적용 합니다!참조(AZ-111)')
			Else
				messagebox("",'해당 자료가 없습니다!')
			End if
		End if
	End if
	
ElseIF sGrp = 'H' THEN
	st_2.text = '영업외수익' + snm2
	sacc1 = '44000'
	sacc2 = '44999'
	
	dw_3.DataObject = 'd_sm04_00100_acc'
	dw_3.SetTransObject(sqlca)
   dw_3.retrieve(sGrp,syymm,syymmt,sacc1,sacc2)
	
ElseIF sGrp = 'I' THEN
	st_2.text = '영업외비용' + snm2
	sacc1 = '45000'
	sacc2 = '45999'
	
	dw_3.DataObject = 'd_sm04_00100_acc'
	dw_3.SetTransObject(sqlca)
   dw_3.retrieve(sGrp,syymm,syymmt,sacc1,sacc2)
	
ElseIF sGrp = 'Z' then     //유상사급
		 st_2.text = '유상사급' + snm2
		
		 dw_3.DataObject = 'd_sm04_00100_sagub'
		 dw_3.SetTransObject(sqlca)
		 dw_3.retrieve(syymm)

Else
	st_2.text = ' ' + snm2
	dw_3.DataObject = 'd_sm04_00100_base'
	dw_3.SetTransObject(sqlca)
	
End If

end event

event dw_insert::clicked;call super::clicked;If row > 0 Then
	this.SelectRow(0,false)
	this.SelectRow(row,true)
Else
	this.SelectRow(0,false)
End If
end event

type p_delrow from w_inherite`p_delrow within w_sm04_00101
boolean visible = false
integer x = 2985
integer y = 40
end type

type p_addrow from w_inherite`p_addrow within w_sm04_00101
boolean visible = false
integer x = 2569
integer y = 40
end type

event p_addrow::ue_lbuttondown;PictureName = 'C:\erpman\image\행추가_dn.gif'
end event

event p_addrow::ue_lbuttonup;PictureName = 'C:\erpman\image\행추가_up.gif'
end event

type p_search from w_inherite`p_search within w_sm04_00101
boolean visible = false
integer x = 2213
integer y = 40
string picturename = "C:\erpman\image\생성_up.gif"
end type

event p_search::ue_lbuttondown;p_search.picturename = 'C:\erpman\image\생성_dn.gif'
end event

event p_search::ue_lbuttonup;p_search.picturename = 'C:\erpman\image\생성_up.gif'
end event

event p_search::clicked;call super::clicked;string s_yymm, s_toym
int    i_seq, nCnt

if dw_1.AcceptText() = -1 then return 
s_yymm = trim(dw_1.GetItemString(1,'syymm'))
i_seq  = dw_1.GetItemNumber(1,'jjcha')

if isnull(s_yymm) or s_yymm = "" then
	f_message_chk(30,'[계획년월]')
	dw_1.Setcolumn('syymm')
	dw_1.SetFocus()
	return
end if

s_toym = left(f_today(), 6) 
if s_yymm < s_toym then

	messagebox("확인", "현재 이전 년월은 처리할 수 없습니다!!")

	dw_1.setcolumn('syymm')
	dw_1.setfocus()
	return 
end if

/* 주문변경 유무 */
String sDate, eDate, sjocod

sjocod = dw_1.GetItemString(1,'jocod')

SELECT MIN(WEEK_SDATE), MAX(WEEK_EDATE) INTO :SDATE, :EDATE
  FROM PDTWEEK 
 WHERE SUBSTR(WEEK_SDATE,1,6) BETWEEN :S_YYMM AND TO_CHAR(ADD_MONTHS(TO_DATE(:S_YYMM,'YYYYMM'),2),'YYYYMM');
		  
//SELECT COUNT(*) INTO :nCnt
//  FROM SORDER A
// WHERE A.SABU = :gs_sabu
//   AND A.CUST_NAPGI BETWEEN :sdate AND :edate
//   AND A.SPECIAL_YN <> 'Y'
//	AND A.WEB = 'Y'
//	AND A.SAUPJ = :gs_saupj
//	AND EXISTS ( SELECT 'X' FROM ITEMAS WHERE ITNBR = A.ITNBR AND JOCOD = :sjocod AND ITTYP < '3' AND ITGU = '5' );
//If nCnt > 0 Then
//	MessageBox('확인','주문내역중 변경된 사항이 존재합니다.!!~r~n생산계획 변경을 먼저 처리하세요.!!')
//	Return
//End If

if isnull(i_seq) or i_seq = 0 then
	f_message_chk(30,'[확정/조정 구분]')
	dw_1.Setcolumn('jjcha')
	dw_1.SetFocus()
	return
end if	

gs_code = s_yymm
gs_codename = string(i_seq) 
		
Open(w_pm01_01010_1)
end event

type p_ins from w_inherite`p_ins within w_sm04_00101
boolean visible = false
integer x = 3168
integer y = 32
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_sm04_00101
end type

type p_can from w_inherite`p_can within w_sm04_00101
end type

event p_can::clicked;
dw_ip.enabled = true

p_search.picturename = 'C:\erpman\image\생성_up.gif'
p_addrow.picturename = 'C:\erpman\image\행추가_up.gif'
p_delrow.picturename = 'C:\erpman\image\행삭제_up.gif'
p_mod.picturename = 'C:\erpman\image\저장_up.gif'
p_inq.picturename = 'C:\erpman\image\조회_up.gif'

p_inq.enabled = true
p_search.enabled = true
p_addrow.enabled = false
p_delrow.enabled = false
p_mod.enabled = false
p_print.enabled = false

ib_any_typing = FALSE

dw_ip.setfocus()

st_2.text = ' '
dw_3.DataObject = 'd_sm04_00100_base'
dw_3.SetTransObject(sqlca)
dw_insert.reset()
end event

type p_print from w_inherite`p_print within w_sm04_00101
integer x = 3630
boolean enabled = false
end type

event p_print::clicked;call super::clicked;String sYymm, sdate, edate, sPlnt, sGrpNam, tx_name, tx_name1, arg_ym
String sSaupj
int    ii, jj

If dw_ip.AcceptText() <> 1 Then Return -1

sYymm = Trim(dw_ip.GetItemString(1, 'yymm'))
If IsNull(sYymm) Or sYymm = '' Then
	f_message_chk(1400,'')
	Return -1
End If

IF dw_print.Retrieve(gs_userid) < 1 THEN
	f_message_chk(50,'')
	dw_ip.Setfocus()
	return -1
Else
	tx_name  = Left(sYymm,4) + '.' + Mid(sYymm,5,2)
	tx_name1 = Left(sYymm,4) + '.01 - ' + Left(sYymm,4) + '.' + Mid(sYymm,5,2)
	dw_print.Modify("t_ym.text = '"+tx_name+"'")
	dw_print.Modify("t_yy.text = '"+tx_name1+"'")

	dw_print.object.datawindow.print.preview="yes"
	
	gi_page = dw_print.GetItemNumber(1,"last_page")
	OpenWithParm(w_print_options, dw_print)

end if

return 1
end event

type p_inq from w_inherite`p_inq within w_sm04_00101
integer x = 4096
end type

event p_inq::clicked;
st_2.text = ' '
dw_3.DataObject = 'd_sm04_00100_base'
dw_3.SetTransObject(sqlca)
dw_insert.reset()

IF wf_retrieve() = -1 THEN
	p_print.Enabled =False
	p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

	p_mod.Enabled =False
	p_mod.PictureName = 'C:\erpman\image\저장_d.gif'
	p_inq.Enabled = True
	p_inq.PictureName = 'C:\erpman\image\조회_up.gif'
	
	SetPointer(Arrow!)
	dw_ip.enabled = true
	Return
Else
	p_print.Enabled = True
	p_print.PictureName =  'C:\erpman\image\인쇄_up.gif'

	p_mod.Enabled = True
	p_mod.PictureName = 'C:\erpman\image\저장_up.gif'
	p_inq.Enabled = False
	p_inq.PictureName = 'C:\erpman\image\조회_d.gif'
	
	dw_ip.enabled = False
	
END IF
SetPointer(Arrow!)	
end event

type p_del from w_inherite`p_del within w_sm04_00101
boolean visible = false
integer x = 2391
integer y = 40
end type

type p_mod from w_inherite`p_mod within w_sm04_00101
boolean visible = false
integer x = 4096
end type

type cb_exit from w_inherite`cb_exit within w_sm04_00101
end type

type cb_mod from w_inherite`cb_mod within w_sm04_00101
end type

type cb_ins from w_inherite`cb_ins within w_sm04_00101
end type

type cb_del from w_inherite`cb_del within w_sm04_00101
end type

type cb_inq from w_inherite`cb_inq within w_sm04_00101
end type

type cb_print from w_inherite`cb_print within w_sm04_00101
end type

type st_1 from w_inherite`st_1 within w_sm04_00101
end type

type cb_can from w_inherite`cb_can within w_sm04_00101
end type

type cb_search from w_inherite`cb_search within w_sm04_00101
end type







type gb_button1 from w_inherite`gb_button1 within w_sm04_00101
end type

type gb_button2 from w_inherite`gb_button2 within w_sm04_00101
end type

type dw_ip from u_key_enter within w_sm04_00101
integer x = 69
integer y = 48
integer width = 1760
integer height = 124
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_sm04_00100"
boolean border = false
end type

event itemerror;call super::itemerror;return 1
end event

type dw_3 from datawindow within w_sm04_00101
integer x = 2098
integer y = 316
integer width = 2414
integer height = 1944
integer taborder = 120
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm04_00100_base"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = styleraised!
end type

event doubleclicked;String syymm, sGrp, sSor, syymmt, sacc1, sacc2, sAcc, snm1, snm2, sitnbr, sitdsc
Long   nCnt
Double dAmt1

if dw_ip.AcceptText() = -1 then return 
//if dw_insert.AcceptText() = -1 then return 
if dw_3.AcceptText() = -1 then return 

syymm  = trim(dw_ip.GetItemString(1,'yymm'))
//sGrp   = trim(dw_insert.GetItemString(row,'grp'))
//sAcc   = trim(dw_insert.GetItemString(row,'acc'))
//sSor   = trim(dw_insert.GetItemString(row,'sor'))

IF dw_3.DataObject = 'd_sm04_00100_jaje2' then
	If row > 0 Then
		this.SelectRow(0,false)
		this.SelectRow(row,true)
	Else
		this.SelectRow(0,false)
	End If

   sitnbr  = trim(dw_3.GetItemString(row,'itnbr'))
   sItdsc  = trim(dw_3.GetItemString(row,'ispec'))

	gs_gubun = syymm
	gs_code  = sItnbr
	gs_codename = sItnbr +'   '+sitdsc
	open(w_sm04_00101_popup)
End If


end event

type st_2 from statictext within w_sm04_00101
integer x = 2199
integer y = 248
integer width = 1842
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
boolean focusrectangle = false
end type

type st_3 from statictext within w_sm04_00101
integer x = 2107
integer y = 252
integer width = 87
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "▶"
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_sm04_00101
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 224
integer width = 4471
integer height = 2044
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_sm04_00101
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 24
integer width = 1815
integer height = 172
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_1 from datawindow within w_sm04_00101
boolean visible = false
integer x = 2354
integer y = 72
integer width = 686
integer height = 400
integer taborder = 120
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm04_00100_ptt"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

type dw_2 from datawindow within w_sm04_00101
boolean visible = false
integer x = 3118
integer y = 56
integer width = 686
integer height = 400
integer taborder = 130
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm04_00100_tab"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type st_4 from statictext within w_sm04_00101
integer x = 434
integer y = 720
integer width = 1403
integer height = 136
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 134217728
string text = "[ 당월 및 년 누계 자료 집계 중 입니다 .. ]"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type dw_print from datawindow within w_sm04_00101
boolean visible = false
integer x = 2926
integer y = 92
integer width = 686
integer height = 400
integer taborder = 130
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm04_00100_p"
boolean livescroll = true
borderstyle borderstyle = styleraised!
end type

type pb_1 from u_pb_cal within w_sm04_00101
integer x = 677
integer y = 52
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('yymm')
IF IsNull(gs_code) THEN Return 
dw_ip.SetItem(1, 'yymm', Left(gs_code,6))


end event

