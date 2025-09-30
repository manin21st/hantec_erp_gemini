$PBExportHeader$w_sal_05033.srw
$PBExportComments$세금계산서 발행(일괄발행:건별)
forward
global type w_sal_05033 from w_inherite
end type
type dw_list from datawindow within w_sal_05033
end type
type dw_ip from datawindow within w_sal_05033
end type
type rb_new from radiobutton within w_sal_05033
end type
type rb_old from radiobutton within w_sal_05033
end type
type ds_print from datawindow within w_sal_05033
end type
type rr_1 from roundrectangle within w_sal_05033
end type
type rr_2 from roundrectangle within w_sal_05033
end type
type dw_saleh from datawindow within w_sal_05033
end type
type pb_1 from u_pb_cal within w_sal_05033
end type
type pb_2 from u_pb_cal within w_sal_05033
end type
type cbx_sale from checkbox within w_sal_05033
end type
type cbx_1 from checkbox within w_sal_05033
end type
type cbx_2 from checkbox within w_sal_05033
end type
type cbx_3 from checkbox within w_sal_05033
end type
type cbx_4 from checkbox within w_sal_05033
end type
type cbx_5 from checkbox within w_sal_05033
end type
type dw_auto from datawindow within w_sal_05033
end type
end forward

global type w_sal_05033 from w_inherite
integer height = 3772
string title = "세금계산서 발행 - 일괄"
dw_list dw_list
dw_ip dw_ip
rb_new rb_new
rb_old rb_old
ds_print ds_print
rr_1 rr_1
rr_2 rr_2
dw_saleh dw_saleh
pb_1 pb_1
pb_2 pb_2
cbx_sale cbx_sale
cbx_1 cbx_1
cbx_2 cbx_2
cbx_3 cbx_3
cbx_4 cbx_4
cbx_5 cbx_5
dw_auto dw_auto
end type
global w_sal_05033 w_sal_05033

type variables

end variables

forward prototypes
public function integer wf_calc_checkno (string sabu, string sdate)
end prototypes

public function integer wf_calc_checkno (string sabu, string sdate);integer	nMAXNO

SELECT NVL(seqno, 0)
  INTO :nMAXNO
  FROM checkno
 WHERE ( sabu = :gs_sabu ) AND
		 ( base_yymm = :sdate ) for update;
		
Choose Case sqlca.sqlcode 
  Case is < 0 
			return -1
  Case 100 
    nMAXNO = 1

    INSERT INTO checkno ( sabu,base_yymm, seqno )
        VALUES ( :gs_sabu, :sDate, :nMaxNo ) ;  
  Case 0
	 nMAXNO = nMAXNO + 1

	 UPDATE checkno
   	 SET seqno = :nMAXNO
	  WHERE ( sabu = :gs_sabu ) AND
			  ( base_yymm = :sDate );
END Choose

If sqlca.sqlcode <> 0 Then	Return -1

RETURN nMAXNO

end function

on w_sal_05033.create
int iCurrent
call super::create
this.dw_list=create dw_list
this.dw_ip=create dw_ip
this.rb_new=create rb_new
this.rb_old=create rb_old
this.ds_print=create ds_print
this.rr_1=create rr_1
this.rr_2=create rr_2
this.dw_saleh=create dw_saleh
this.pb_1=create pb_1
this.pb_2=create pb_2
this.cbx_sale=create cbx_sale
this.cbx_1=create cbx_1
this.cbx_2=create cbx_2
this.cbx_3=create cbx_3
this.cbx_4=create cbx_4
this.cbx_5=create cbx_5
this.dw_auto=create dw_auto
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list
this.Control[iCurrent+2]=this.dw_ip
this.Control[iCurrent+3]=this.rb_new
this.Control[iCurrent+4]=this.rb_old
this.Control[iCurrent+5]=this.ds_print
this.Control[iCurrent+6]=this.rr_1
this.Control[iCurrent+7]=this.rr_2
this.Control[iCurrent+8]=this.dw_saleh
this.Control[iCurrent+9]=this.pb_1
this.Control[iCurrent+10]=this.pb_2
this.Control[iCurrent+11]=this.cbx_sale
this.Control[iCurrent+12]=this.cbx_1
this.Control[iCurrent+13]=this.cbx_2
this.Control[iCurrent+14]=this.cbx_3
this.Control[iCurrent+15]=this.cbx_4
this.Control[iCurrent+16]=this.cbx_5
this.Control[iCurrent+17]=this.dw_auto
end on

on w_sal_05033.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_list)
destroy(this.dw_ip)
destroy(this.rb_new)
destroy(this.rb_old)
destroy(this.ds_print)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.dw_saleh)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.cbx_sale)
destroy(this.cbx_1)
destroy(this.cbx_2)
destroy(this.cbx_3)
destroy(this.cbx_4)
destroy(this.cbx_5)
destroy(this.dw_auto)
end on

event open;call super::open;PostEvent("ue_open")
end event

event ue_open;call super::ue_open;string sDate

sDate = f_today()
/* saleh */
dw_ip.SetTransObject(SQLCA)
dw_ip.InsertRow(0)
dw_ip.SetItem(1,'sdatef',left(sDate,6)+'01')
dw_ip.SetItem(1,'sdatet',sDate)

/* Imhist */
dw_auto.SetTransObject(SQLCA)

/* saleh */
dw_saleh.SetTransObject(SQLCA)
dw_insert.SetTransObject(SQLCA)
dw_insert.InsertRow(0)

/* 세금계산서 거래처별 조회용 datastore */
ds_print.SetTransObject(sqlca)

/* 세금계산서 일괄발행용 출력양식*/
dw_list.SetTransObject(SQLCA)

/* User별 관할구역 Setting */
String sarea, steam, saupj

// 영업팀 권한 설정
If f_check_sarea(sarea, steam, saupj) = 1 Then
	dw_ip.Modify("sarea.protect=1")
	dw_ip.Modify("steamcd.protect=1")
	
	dw_ip.SetItem(1, 'sarea', sarea)
	dw_ip.SetItem(1, 'steamcd', steam)
End If

// 부가세 사업장 설정
f_mod_saupj(dw_ip, 'saupj')

end event

type dw_insert from w_inherite`dw_insert within w_sal_05033
boolean visible = false
integer x = 3643
integer y = 172
integer width = 530
integer height = 332
integer taborder = 0
string dataobject = "d_sal_020602"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_insert::itemerror;
Return 1
end event

type p_delrow from w_inherite`p_delrow within w_sal_05033
boolean visible = false
integer x = 3177
integer y = 5000
end type

type p_addrow from w_inherite`p_addrow within w_sal_05033
boolean visible = false
integer x = 3003
integer y = 5000
end type

type p_search from w_inherite`p_search within w_sal_05033
integer x = 3758
integer y = 12
boolean originalsize = true
string picturename = "C:\erpman\image\조회_up.gif"
end type

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\조회_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\조회_up.gif"
end event

event p_search::clicked;call super::clicked;String sFrdate, sTodate, sTeamcd, sArea, sCvcod, sSaupj, sGubun, sSale, sIogbn[], sIogbn2[], sIogbnall
Long   Lrow, Lchk 

w_mdi_frame.sle_msg.text = ''

If dw_ip.AcceptText() <> 1 Then Return

sFrdate = dw_ip.GetItemString(1,'sdatef')
sTodate = dw_ip.GetItemString(1,'sdatet')
steamcd = dw_ip.GetItemString(1,'steamcd')
sArea   = dw_ip.GetItemString(1,'sarea')
sCvcod  = dw_ip.GetItemString(1,'scvcod')
sSaupj  = dw_ip.GetItemString(1,'saupj')
sGubun  = dw_ip.GetItemString(1,'gubun')

If cbx_sale.Checked Then
	sSale = 'Y'
Else
	sSale = 'N'
End If

dw_ip.SetFocus()
IF sFrDate ="" OR IsNull(sFrDate) THEN
	f_message_chk(30,'[매출일자]')
	dw_ip.SetColumn("sdatef")
	Return 
END IF

IF sToDate ="" OR IsNull(sToDate) THEN
	f_message_chk(30,'[매출일자]')
	dw_ip.SetColumn("sdatet")
	Return 
END IF

IF sSaupj = "" OR IsNull(sSaupj) THEN
	f_message_chk(30,'[부가사업장]')
	dw_ip.SetColumn("saupj")
	Return 
END IF

If IsNull(steamcd) Then steamcd = ''
If IsNull(sarea) 	 Then sarea = ''
If IsNull(scvcod)  Then scvcod = ''

/* 수불구분 추가 '20.09.25 BY BHKIM */
Lchk = 0
sIogbn[1] = '.'
sIogbn[2] = '.'
sIogbn[3] = '.'
sIogbn[4] = '.'
sIogbn2[1] = '.'
sIogbn2[2] = '.'
sIogbn2[3] = '.'
sIogbn2[4] = '.'

if cbx_1.Checked = true then
	Lchk = Lchk + 1
	sIogbn[Lchk] = 'O02'
end if

if cbx_2.Checked = true then
	Lchk = Lchk + 1
	sIogbn[Lchk] = 'OY3'
end if

if cbx_3.Checked = true then
	Lchk = Lchk + 1
	sIogbn[Lchk] = 'OY2'
end if

if cbx_4.Checked = true then
	Lchk = Lchk + 1
	sIogbn[Lchk] = 'O47'
end if

if cbx_5.Checked = true then
	sIogbn2[1] = 'O02'
	sIogbn2[2] = 'OY3'
	sIogbn2[3] = 'OY2'
	sIogbn2[4] = 'O47'
end if

if Lchk = 0 then	
	if cbx_5.Checked = true then
		SIogbnall = '.'
	else
		sIogbnall = '%'
	end if
else
	if cbx_5.Checked = true then
		SIogbnall = '.'
	else
		sIogbnall = 'C'
	end if
end if

SetPointer(HourGlass!)

p_inq.Enabled = False
p_inq.PictureName = "C:\erpman\image\일괄발행_d.gif"
dw_auto.Reset()
dw_saleh.setredraw(False)
If dw_saleh.Retrieve(gs_sabu,steamcd+'%',sarea+'%',sCvcod+'%',sFrdate,sTodate, sSaupj, sGubun, sSale, sIogbn, sIogbn2, sIogbnall) <= 0 Then 
	f_message_chk(130,'')
	dw_saleh.setredraw(True)
	Return
End If

If rb_new.Checked = True Then
	For Lrow = 1 to dw_saleh.rowcount()
		 dw_saleh.setitem(Lrow, "saledt", sTodate)
	Next
	
	p_print.Enabled = True
	p_print.PictureName = "C:\erpman\image\인쇄_up.gif"
	p_inq.Enabled = True
	p_inq.PictureName = "C:\erpman\image\일괄발행_up.gif"
Else
	p_print.Enabled = True
	p_print.PictureName = "C:\erpman\image\인쇄_up.gif"
	p_can.Enabled = True
	p_can.PictureName = "C:\erpman\image\일괄취소_up.gif"
End If

dw_saleh.setredraw(True)

SetPointer(Arrow!)
end event

type p_ins from w_inherite`p_ins within w_sal_05033
boolean visible = false
integer x = 2830
integer y = 5000
end type

type p_exit from w_inherite`p_exit within w_sal_05033
integer x = 4457
integer y = 12
end type

type p_can from w_inherite`p_can within w_sal_05033
integer x = 4105
integer y = 12
boolean enabled = false
string picturename = "C:\erpman\image\일괄취소_d.gif"
end type

event p_can::ue_lbuttondown;PictureName = "C:\erpman\image\일괄취소_dn.gif"
end event

event p_can::ue_lbuttonup;PictureName = "C:\erpman\image\일괄취소_up.gif"
end event

event p_can::clicked;call super::clicked;Long lrow
String sSaledt, sSaleNo, sCheckno, sMsg

If dw_saleh.RowCount() <= 0 Then
	MessageBox('확 인','발행될 내역이 없습니다.!!')
	Return
End If

IF MessageBox("확  인","매출기간동안 발행된 세금계산서가 삭제됩니다." +"~n~n" +&
                       "삭제 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN RETURN

SetPointer(HourGlass!)

/* 매출기간동안 일괄발행된 세금계산서 내역 - 미전표 발행 */	  
For Lrow = 1 to dw_saleh.rowcount()
	If dw_saleh.GetItemString(lrow, 'chk') <> 'Y' Then Continue
	
	ssaledt = dw_saleh.getitemstring(Lrow, "saledt")
	ssaleno = string(dw_saleh.getitemDECIMAL(Lrow, "saleno"))
	scheckno = dw_saleh.getitemstring(Lrow, "checkno")

	If IsNull(sSaleDt) Or Trim(sSaleDt) = '' Then 
		RollBack;
		MessageBox('오류','[발행일자]')
		Return
	End If
	
	If IsNull(sSaleNo) Or Trim(sSaleNo) = '' Then 
		RollBack;
		MessageBox('오류','[발행번호]')
		Return
	End If
	
	If IsNull(sCheckNo) Or Trim(sCheckNo) = '' Then 
		RollBack;
		MessageBox('오류','[계산서일련번호]')
		Return
	End If
	
	/* Update Imhist */

   UPDATE "IMHIST"  
      SET "CHECKNO" = null,
			 "YEBI4"   = null 
    WHERE "IMHIST"."SABU" = :gs_sabu AND
		      "IMHIST"."CHECKNO" = :sCheckNo;	

   If sqlca.sqlcode <> 0 Then
		sMsg = string(sqlca.sqlcode)+' '+ sqlca.sqlerrtext
		RollBack;
		MessageBox(sCheckNo,sMsg)
		Return
	End If
	
	/* Delete Saleh */
   DELETE FROM "SALEH"
    WHERE ( "SALEH"."SABU" = :gs_sabu ) AND  
          ( "SALEH"."SALEDT" = :sSaleDt ) AND  
          ( "SALEH"."SALENO" = :sSaleNo ) AND  
          ( "SALEH"."BAL_DATE" is null );

   If sqlca.sqlcode <> 0 Then
		sMsg = string(sqlca.sqlcode)+' '+ sqlca.sqlerrtext
		RollBack;
		MessageBox('오류 '+ sSaleNo,sMsg)
		Return
	End If
Next

Commit;

p_search.TriggerEvent(Clicked!)

w_mdi_frame.sle_msg.text = '정상적으로 취소 처리되었습니다.!!'

//f_message_chk(210,'')

end event

type p_print from w_inherite`p_print within w_sal_05033
integer x = 4283
integer y = 12
end type

event p_print::clicked;call super::clicked;String sDatef, sDateT, sSteamCd, sSarea, sCvcod, sSaupj, sCheckNo
Long   nCnt, nFind, ix
	
If rb_new.Checked = True Then
	If dw_list.RowCount() > 0 Then
		gi_page = dw_list.GetItemNumber(1,"last_page")
		OpenWithParm(w_print_options, dw_list)
	Else
		f_message_chk(300,'')
		Return
	End if
	
	p_search.TriggerEvent(Clicked!)
Else
	If dw_ip.AcceptText() <> 1 Then Return
		
	sDatef = Trim(dw_ip.GetItemString(1,'sdatef'))
	sDatet = Trim(dw_ip.GetItemString(1,'sdatet'))
	sSteamCd = Trim(dw_ip.GetItemString(1,'steamcd'))
	ssArea = Trim(dw_ip.GetItemString(1,'sarea'))
	sCvcod = Trim(dw_ip.GetItemString(1,'scvcod'))
	sSaupj = Trim(dw_ip.GetItemString(1,'saupj'))
	If IsNull(sSaupj) Or sSaupj = '' Then
		f_message_chk(1400,'[부가사업장]')
		Return
	End If
	
	If IsNull(sSteamCd) or sSteamCd = '' Then sSteamCd = ''
	If IsNull(ssArea) or ssArea = '' Then ssArea = ''
	If IsNull(sCvcod) or sCvcod = '' Then sCvcod = ''
	
	nCnt = dw_list.Retrieve(gs_sabu, sDatef, sDateT, sSteamCd+'%', sSarea+'%', sCvcod+'%', sSaupj)
	If nCnt > 0 Then
		/* 선택하지 않은 계산서는 삭제 */
		For ix = 1 To dw_saleh.RowCount()
			If dw_saleh.GetItemString(ix, 'chk') = 'Y' Then Continue
			
			sCheckNo = dw_saleh.GetItemString(ix, 'checkno')
			nFind = dw_list.Find("saleh_checkno = '" + sCheckNo + "'", 1, dw_list.RowCount())
			If nFind > 0 Then	dw_list.DeleteRow(nfind)
		Next

		If dw_list.RowCount() > 0 then
			gi_page = dw_list.GetItemNumber(1,"last_page")
			OpenWithParm(w_print_options, dw_list)
		Else
			f_message_chk(300,'')
			Return
		End If
	Else
		f_message_chk(300,'')
		Return
	End If
End If
end event

type p_inq from w_inherite`p_inq within w_sal_05033
integer x = 3931
integer y = 12
boolean enabled = false
string picturename = "C:\erpman\image\일괄발행_d.gif"
end type

event p_inq::ue_lbuttondown;PictureName = "C:\erpman\image\일괄발행_dn.gif"
end event

event p_inq::ue_lbuttonup;PictureName = "C:\erpman\image\일괄발행_up.gif"
end event

event p_inq::clicked;call super::clicked;Long    nRow,iMaxSaleNo,iMaxCheckNo,nRowCnt,ix,iy,iCnt, iz
Long    sRow,eRow, nSkipCnt=0
string  sCvcod,sPum,sFrdate,sToDate,sArea,sTeamCd,sIspec, sSaleCod, saledt
double  dGonAmt,dVatAmt,dIoPrc,dIoqty,dSum_GonAmt,dSum_vatamt
string  sCustName, sCustSano, sCustUpTae, sCustUpjong, sCustOwner
String  sTaxGu, sCustResident, sCustAddr, sCustGbn  ,sSkipCust, sSaupj, sChk, sSalegu, sTaxNo, sVatgbn, sSale

dw_list.Reset()
w_mdi_frame.sle_msg.text = ''

If dw_ip.AcceptText() <> 1 Then Return
							 
sFrdate = dw_ip.GetItemString(1,'sdatef')
sTodate = dw_ip.GetItemString(1,'sdatet')
steamcd = dw_ip.GetItemString(1,'steamcd')
sArea   = dw_ip.GetItemString(1,'sarea')
sSaupj  = dw_ip.GetItemString(1,'saupj')
sSalegu  = dw_ip.GetItemString(1,'gubun')

IF MessageBox("확  인","선택된 자료가 세금계산서로 발행됩니다." +"~n~n" +&
                       "발행 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN RETURN

// 부가세 구분코드
If sSalegu = '3' Then
	sTaxNo = '24' //매출세금계산서(영수율)
Else
	sTaxNo = '21' //매출세금계산서(일반과세)
End If

// 부가세 업종구분
SELECT MIN(SUBSTR("REFFPF"."RFGUB",3,1)) INTO :sVatgbn
 FROM "REFFPF"  
WHERE ( "REFFPF"."RFCOD" = 'AW' ) AND  
		( "REFFPF"."RFGUB" <> '00') AND
		( SUBSTR("REFFPF"."RFGUB",1,2) = :sSaupj );

dw_ip.SetFocus()
IF sFrDate ="" OR IsNull(sFrDate) THEN
	f_message_chk(30,'[매출일자]')
	dw_ip.SetColumn("sdatef")
	Return 
END IF

IF sToDate ="" OR IsNull(sToDate) THEN
	f_message_chk(30,'[매출일자]')
	dw_ip.SetColumn("sdatet")
	Return 
END IF

If IsNull(steamcd) Then steamcd = ''
If IsNull(sarea) Then sarea = ''
If IsNull(scvcod) Then scvcod = ''

If dw_saleh.GetItemNumber(1,'chkcnt') <= 0 Then
	MessageBox('확 인','발행될 내역이 없습니다.!!')
	Return
End If

SetPointer(HourGlass!)

ds_print.Reset()
p_print.Enabled = False
p_print.PictureName = "C:\erpman\image\인쇄_d.gif"
For iz = 1 To dw_saleh.RowCount()
	sChk = Trim(dw_saleh.GetItemString(iz, 'chk'))
	If IsNull(sChk) Or sChk = '' Then sChk = 'N'
	
	If  sChk <> 'Y' Then Continue

	sCvcod  	= dw_saleh.GetItemString(iz, 'cvcod')
	sSaleCod = dw_saleh.GetItemString(iz, 'salescod')
	Saledt   = dw_saleh.GetItemString(iz, 'saledt')
	sSale    = dw_saleh.GetItemString(iz, 'gbn')		// 실적거래처 집계여부
	
	/* 실적거래처가 없으면 발행불가 */
	If IsNull(sSaleCod) Or Trim(sSaleCod) = '' Then	Continue
	
	/* 계산서 일자check */
	If f_datechk(Saledt) = -1 then
		MessageBox("계산서일자", "일자가 부정확합니다", stopsign!)
		dw_saleh.setitem(iz, "saledt", f_today())
		dw_saleh.setrow(iz)
		dw_saleh.scrolltorow(iz)
		dw_saleh.setfocus()
		return
	End if
			
	/* 품목정보 조회 */
	If	dw_auto.Retrieve(gs_sabu,steamcd+'%',sarea+'%',sCvcod+'%', sFrdate, sTodate, sSaupj, sSalegu, sSale) <= 0 Then
		dw_saleh.Reset()
		f_message_chk(130,'')
		Return
	End If

	/* ----------------------------- */
	/* 품목정보를 가지고 계산서 발행 */
	/* ----------------------------- */
	dw_auto.SetSort('cvcod')
	dw_auto.Sort()
	dw_auto.GroupCalc()
	
	sSaupj  = dw_auto.GetItemString(1,'saupj')
	
	/* --------------------------------------------------------------------- */
	sRow = 1
	eRow = 0
	Do While True
		/* 그룹(거래처)의 start row와 end row를 구분 */
		sRow = eRow + 1
		eRow = dw_auto.FindGroupChange( sRow + 1, 1)

		If eRow <=0 Then 
		  eRow = dw_auto.RowCount()
		Else
		  eRow = eRow - 1
		End If
		If sRow > dw_auto.RowCount() Then Exit
	
		/* 거래처 정보 */
		SELECT "VNDMST"."CVNAS",         "VNDMST"."SANO", 		 		"VNDMST"."UPTAE",   
				 "VNDMST"."JONGK",  		   "VNDMST"."OWNAM",				"VNDMST"."RESIDENT",   
				 NVL("VNDMST"."ADDR1",' ')||NVL("VNDMST"."ADDR2",' '),"VNDMST"."CVGU",
				 "VNDMST"."TAX_GU"
		  INTO :sCustName,   			  :sCustSano,   					:sCustUpTae,
				 :sCustUpjong,   			  :sCustOwner,   					:sCustResident,
				 :sCustAddr,   													:sCustGbn,
				 :sTaxGu
		  FROM "VNDMST"  
		 WHERE "VNDMST"."CVCOD" = :sSaleCod;
	
		w_mdi_frame.sle_msg.text = sCustName + ' 처리중...'
		
		/* 세금계산서의 거래처정보 미등록시 제외 */
		If ( IsNull(sCustSano) or Trim(sCustSano) = '' ) and & 
			( IsNull(sCustResident) or Trim(sCustResident) = '' ) Then
			nSkipCnt++
			
			sSkipCust += ('['+sCvcod+': ' + Trim(sCustName) + ']' + '~r~n' )
			Continue
		End If
		
		/* 거래처명,업태,업종,주소 */
		If ( IsNull(sCustName)   or Trim(sCustName)   = '' )   Or &
			( IsNull(sCustUpTae)  or Trim(sCustUpTae)  = ''  )  Or &
			( IsNull(sCustUpjong) or Trim(sCustUpjong) = ''  )  Or &
			( IsNull(sCustAddr)   or Trim(sCustAddr)   = ''  )  Then 
			nSkipCnt++
			
			sSkipCust += ('['+sCvcod+': ' + Trim(sCustName) + ']' + '~r~n')
			Continue
		End If
		
		/* 계산서 발행구분 */
		If IsNull(sTaxGu) Then sTaxGu = '2'
		
		Choose Case Trim(sTaxGu)
		/* 건별 발행 */
			Case '1'
				/* 항목을 4건씩 끊어 발행 */
				For ix = sRow To eRow Step 4
					/* 전표번호 채번 */
					iMaxSaleNo = sqlca.fun_junpyo(gs_sabu,saledt,'G0')
					IF iMaxSaleNo <= 0 THEN
					  f_message_chk(51,'')
					  rollback;
					  Return 1
					END IF
					
					commit;
		
					/* 계산서 일련번호 채번 */
					iMaxCheckNo = wf_calc_checkno(gs_sabu,Left(saledt,6))
					IF iMaxCheckNo <= 0 Or iMaxCheckNo > 9999 THEN
					  f_message_chk(51,'[일련번호]')
						rollback;
					  Return 1
					END IF
					
					commit;
		
					nRow = dw_insert.InsertRow(0)
					dw_insert.SetItem(nRow,"sabu",     gs_sabu)
					dw_insert.SetItem(nRow,"saledt",   saledt)
					dw_insert.SetItem(nRow,"saleno",   iMaxSaleNo)
					dw_insert.SetItem(nrow,"checkno",  Left(saledt,6)+ Trim(String(iMaxCheckNo,'0000')))
					dw_insert.SetItem(nRow,'cvcod',    sCvcod)
					dw_insert.SetItem(nRow,'salecod',  sSaleCod)
					dw_insert.SetItem(nRow,"sano",     sCustSano)
					dw_insert.SetItem(nRow,"cvnas",    sCustName)
					dw_insert.SetItem(nRow,"ownam",    sCustOwner)
					dw_insert.SetItem(nRow,"resident", sCustresident)
					dw_insert.SetItem(nRow,"uptae",    sCustUptae)
					dw_insert.SetItem(nRow,"jongk",    sCustUpjong)
					dw_insert.SetItem(nRow,"addr1",    sCustAddr)
					dw_insert.SetItem(nRow,'autobal_yn','M')    /* 자동발행 여부 */
					dw_insert.SetItem(nRow,'tax_no',sTaxNo)
					dw_insert.SetItem(nRow,'vatgbn','1')			/* 부가세업종구분 */
					
					dw_insert.SetItem(nRow,'chysgu','0')   		/* 청구 */
					dw_insert.SetItem(nRow,'saupj',	  sSaupj)   /* 부가사업장 */
					dw_insert.SetItem(nRow,'salegu',	  sSalegu)  /* 일반/AS/ES매출구분 */
			
					/* 항목 4건단위로 기록 */
					iCnt = 0
					dSum_GonAmt = 0
					dSum_vatamt = 0
					For iy = ix To ix + 3
						If iy > eRow Then Exit
				
						dIoQty = dw_auto.GetItemNumber(iy,'ioqty') 
						dIoPrc = dw_auto.GetItemNumber(iy,'ioprc')
						dGonAmt = dw_auto.GetItemNumber(iy,'gonamt') /* 공급가액 */
						dVatAmt = dw_auto.GetItemNumber(iy,'vatamt') /* 부가세액 */
						If sSalegu = '3' Then	dVatAmt = 0				/* Local인 경우 없음 */
						
						sPum    = dw_auto.GetItemString(iy,'pum')
						sIspec  = dw_auto.GetItemString(iy,'ispec')
						
						iCnt += 1
						dw_insert.SetItem(nRow,'mmdd'+string(iCnt,'0'),Mid(saledt,5))
						dw_insert.Setitem(nRow,'qty'+string(iCnt,'0'),dIoqty)
						dw_insert.Setitem(nRow,'uprice'+string(iCnt,'0'),dIoPrc) 
						dw_insert.Setitem(nRow,'pum'+string(iCnt,'0'),sPum)
						dw_insert.Setitem(nRow,'size'+string(iCnt,'0'),sIspec)
						dw_insert.SetItem(nRow,'gonamt'+string(iCnt,'0'),dGonAmt)
						dw_insert.SetItem(nRow,'vatamt'+string(iCnt,'0'),dVatAmt)
						
						dSum_GonAmt += dGonAmt
						dSum_vatamt += dVatAmt
						/* 자동발행으로 생성된 경우 : imhist에 세금계산서 출력됨을 기록한다 */
						dw_auto.SetItem(iy,'checkno',Left(saledt,6)+ Trim(String(iMaxCheckNo,'0000')))
						dw_auto.SetItem(iy,'yebi4',  saledt)
					Next
			
					dw_insert.SetItem(nRow,'gon_amt',TRUNCATE(dsum_GonAmt, 0))  //집계후 절사 - 2007.07.20 BY SHINGOON
					dw_insert.SetItem(nRow,'vat_amt',dsum_VatAmt)
				Next

				/* Local인 경우 없음 */
				If sSalegu = '3' Then	
					dVatAmt = 0				
					dw_insert.Setitem(nRow,'vouc_gu','1')
					dw_insert.SetItem(nRow,'expgu','2')
				Else
					dw_insert.SetItem(nRow,'expgu','1')
				End If

				/* 반드시 IMHIST먼저 저장한다 */
				IF dw_auto.Update() <> 1 THEN
					ROLLBACK;
					p_search.TriggerEvent(Clicked!)
					Return
				END IF
				
				IF dw_insert.Update() <> 1 THEN
					ROLLBACK;
					p_search.TriggerEvent(Clicked!)
					Return
				END IF
						
				commit;
		 
				/* 출력 */
				nRowCnt = ds_print.Retrieve(gs_sabu, saledt,iMaxSaleNo, sSaupj)
				If nrowCnt > 0 then
					ds_print.RowsCopy(1, ds_print.RowCount(), Primary!, dw_list, 999999, Primary!)
				End If
			/* -------------------- */
			/* 월별 발행            */
			/* -------------------- */
			Case '2'
				/* 전표번호 채번 */
				iMaxSaleNo = sqlca.fun_junpyo(gs_sabu,saledt,'G0')
				IF iMaxSaleNo <= 0 THEN
					f_message_chk(51,'')
					rollback;
					Return 1
				END IF
				commit;
	
				/* 계산서 일련번호 채번 */
				iMaxCheckNo = wf_calc_checkno(gs_sabu,Left(saledt,6))
				IF iMaxCheckNo <= 0 Or iMaxCheckNo > 9999 THEN
					f_message_chk(51,'일련번호')
					rollback;
					Return 1
				END IF
				commit;
	
				/* 전체선택 */
				For ix = 1 To dw_auto.rowcount()
					dw_auto.SetItem(ix,'chk','Y')
				Next
				 
				nRow = dw_insert.InsertRow(0)
				dw_insert.SetItem(nRow,"sabu",     gs_sabu)
				dw_insert.SetItem(nRow,"saledt",   saledt)
				dw_insert.SetItem(nRow,"saleno",   iMaxSaleNo)
				dw_insert.SetItem(nrow,"checkno",  Left(saledt,6)+ Trim(String(iMaxCheckNo,'0000')))
				dw_insert.SetItem(nRow,'cvcod',    sCvcod)
				dw_insert.SetItem(nRow,'salecod',  sSaleCod)
				dw_insert.SetItem(nRow,"sano",     sCustSano)
				dw_insert.SetItem(nRow,"cvnas",    sCustName)
				dw_insert.SetItem(nRow,"ownam",    sCustOwner)
				dw_insert.SetItem(nRow,"resident", sCustresident)
				dw_insert.SetItem(nRow,"uptae",    sCustUptae)
				dw_insert.SetItem(nRow,"jongk",    sCustUpjong)
				dw_insert.SetItem(nRow,"addr1",    sCustAddr)
				dw_insert.SetItem(nRow,'autobal_yn','M') /* 자동발행 여부 */
				dw_insert.SetItem(nRow,'tax_no',sTaxNo)
				dw_insert.SetItem(nRow,'vatgbn','1')			/* 부가세업종구분 */
				
				dw_insert.SetItem(nRow,'chysgu','0')     /* 청구 */
				
				dGonAmt = dw_auto.GetItemNumber(srow,'sum_gonamt_group') /* 공급가액 */
				dVatAmt = dw_auto.GetItemNumber(srow,'sum_vatamt_group') /* 부가세액 */
				If sSalegu = '3' Then	
					dVatAmt = 0				/* Local인 경우 없음 */
					dw_insert.Setitem(nRow,'vouc_gu','1')
					dw_insert.SetItem(nRow,'expgu','2')
				Else
					dw_insert.SetItem(nRow,'expgu','1')
				End If
				
				sPum    = dw_auto.GetItemString(srow,'pum') + ' 외 ' + string((erow - srow + 1) - 1)
				
				dw_insert.SetItem(nRow,'mmdd1',Mid(saledt,5))
				dw_insert.Setitem(nRow,'pum1',sPum)
				dw_insert.SetItem(nRow,'gonamt1', round(truncate(dGonAmt, 0), 0)) //소수점 절사 - by shingoon 2007.12.20
				dw_insert.SetItem(nRow,'vatamt1',dVatAmt)
				dw_insert.SetItem(nRow,'saupj',	  sSaupj)   /* 부가사업장 */
				dw_insert.SetItem(nRow,'salegu',	  sSalegu)  /* 일반/AS/ES매출구분 */					
				
				For iy = srow To erow	
					/* 자동발행으로 생성된 경우 : imhist에 세금계산서 출력됨을 기록한다 */
					dw_auto.SetItem(iy,'checkno',Left(saledt,6)+ Trim(String(iMaxCheckNo,'0000')))
					dw_auto.SetItem(iy,'yebi4',  saledt)
				Next
				
				dw_insert.SetItem(nRow,'gon_amt',round(TRUNCATE(dGonAmt, 0), 0))  //집계후 절사 - 2007.07.20 BY SHINGOON
				dw_insert.SetItem(nRow,'vat_amt',dVatAmt)

				/* 반드시 IMHIST먼저 저장한다 */
				IF dw_auto.Update() <> 1 THEN
					ROLLBACK;
					p_search.TriggerEvent(Clicked!)
					Return
				END IF
				
				IF dw_insert.Update() <> 1 THEN
					ROLLBACK;
					p_search.TriggerEvent(Clicked!)
					Return
				END IF
	
				COMMIT;
	 
				/* 출력 */
				nRowCnt = ds_print.Retrieve(gs_sabu, saledt,iMaxSaleNo, sSaupj)
				
				If nrowCnt > 0 then
					ds_print.RowsCopy(1, ds_print.RowCount(), Primary!, dw_list, 1, Primary!)
				End If
		End Choose
	Loop
Next

If nSkipCnt > 0 Then
	MessageBox('거래처정보 미비로 발행되지 않은 거래처입니다', &
	           sSkipCust+'~r~n이상 '+ string(nSkipCnt) + '건')
End If

If dw_list.RowCount() > 0 Then
	p_print.Enabled = true
	p_print.PictureName = "C:\erpman\image\인쇄_up.gif"
	f_message_chk(202,'')

	p_print.TriggerEvent(Clicked!)
	w_mdi_frame.sle_msg.text = '세금계산서 발행완료 되었습니다.!!'
Else
	p_print.Enabled = false
	p_print.PictureName = "C:\erpman\image\인쇄_d.gif"
	
	p_search.TriggerEvent(Clicked!)
	w_mdi_frame.sle_msg.text = '발행된 건수가 없습니다.!!'
End If
end event

type p_del from w_inherite`p_del within w_sal_05033
boolean visible = false
integer x = 3525
integer y = 5000
end type

type p_mod from w_inherite`p_mod within w_sal_05033
boolean visible = false
integer x = 3351
integer y = 5000
end type

type cb_exit from w_inherite`cb_exit within w_sal_05033
integer x = 1810
integer y = 5000
integer taborder = 40
end type

type cb_mod from w_inherite`cb_mod within w_sal_05033
integer x = 2921
integer y = 5000
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within w_sal_05033
integer x = 2921
integer y = 2396
integer height = 132
boolean enabled = false
string text = "자동 발행(&I)"
end type

type cb_del from w_inherite`cb_del within w_sal_05033
integer x = 2921
integer y = 2692
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_sal_05033
integer x = 526
integer y = 5000
integer width = 407
boolean enabled = false
string text = "일괄발행(&R)"
end type

type cb_print from w_inherite`cb_print within w_sal_05033
integer x = 1431
integer y = 5000
integer taborder = 10
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_sal_05033
end type

type cb_can from w_inherite`cb_can within w_sal_05033
integer x = 978
integer y = 5000
integer width = 407
boolean enabled = false
string text = "일괄취소(&C)"
end type

type cb_search from w_inherite`cb_search within w_sal_05033
integer x = 160
integer y = 5000
integer width = 334
string text = "조회(&W)"
end type







type gb_button1 from w_inherite`gb_button1 within w_sal_05033
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_05033
end type

type dw_list from datawindow within w_sal_05033
boolean visible = false
integer x = 3296
integer y = 12
integer width = 411
integer height = 236
boolean bringtotop = true
boolean titlebar = true
string title = "세금계산서 출력양식(일괄)"
string dataobject = "d_sal_05030_list1"
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_ip from datawindow within w_sal_05033
event ue_pressenter pbm_dwnprocessenter
integer x = 347
integer y = 24
integer width = 2990
integer height = 312
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_sal_05033_1"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;String  sDateFrom,snull
String  sarea, steam, sCvcod, scvnas, sSaupj, sName1

SetNull(snull)

Choose Case GetColumnName() 
 Case "sdatef" , "sdatet"
	sDateFrom = Trim(this.GetText())
	IF sDateFrom ="" OR IsNull(sDateFrom) THEN RETURN
	
	IF f_datechk(sDateFrom) = -1 THEN
		f_message_chk(35,'[매출일자]')
		this.SetItem(1,GetColumnName() ,snull)
		Return 1
	END IF
/* 영업팀 */
 Case "steamcd"
	SetItem(1,'sarea',sNull)
	SetItem(1,"scvcod",snull)
	SetItem(1,"scvcodnm",snull)
/* 관할구역 */
 Case "sarea"
	SetItem(1,"scvcod",snull)
	SetItem(1,"scvcodnm",snull)
	
	sarea = this.GetText()
	IF sarea = "" OR IsNull(sarea) THEN RETURN
	
	SELECT "SAREA"."SAREA" ,"SAREA"."STEAMCD" 	INTO :sarea  ,:steam
		FROM "SAREA"  
		WHERE "SAREA"."SAREA" = :sarea   ;
		
   SetItem(1,'steamcd',steam)
	/* 거래처 */
	Case "scvcod"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"scvcodnm",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'scvcod', sNull)
			SetItem(1, 'scvcodnm', snull)
			Return 1
		ELSE		
			SetItem(1,"steamcd",   steam)
			SetItem(1,"sarea",   sarea)
			SetItem(1,"scvcodnm",	scvnas)
		END IF
	/* 거래처명 */
	Case "scvcodnm"
		scvnas = Trim(GetText())
		IF scvnas ="" OR IsNull(scvnas) THEN
			SetItem(1,"scvcod",snull)
			Return
		END IF
		
		If f_get_cvnames('2', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'scvcod', sNull)
			SetItem(1, 'scvcodnm', snull)
			Return 1
		ELSE
			SetItem(1,"steamcd", steam)
			SetItem(1,"sarea", sarea)
			SetItem(1,'scvcod', sCvcod)
			SetItem(1,"scvcodnm", scvnas)
			Return 1
		END IF
END Choose
end event

event rbuttondown;SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

Choose Case this.GetColumnName() 
	/* 거래처 */
	Case "scvcod", "scvcodnm"
		gs_gubun = '1'
		If GetColumnName() = "scvcodnm" then
			gs_codename = Trim(GetText())
		End If
		Open(w_vndmst_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"scvcod",gs_code)
		SetColumn("scvcod")
		TriggerEvent(ItemChanged!)
END Choose
end event

event itemerror;Return 1
end event

type rb_new from radiobutton within w_sal_05033
integer x = 64
integer y = 64
integer width = 242
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "생성"
boolean checked = true
end type

event clicked;dw_list.Reset()
p_inq.Enabled = True
p_inq.PictureName = "C:\erpman\image\일괄발행_up.gif"
p_print.Enabled = False
p_print.PictureName = "C:\erpman\image\인쇄_d.gif"
p_can.Enabled = False
p_can.PictureName = "C:\erpman\image\일괄취소_d.gif"

/* 수불구분 추가 '20.09.25 BY BHKIM */
cbx_1.Visible = true
cbx_2.Visible = true
cbx_3.Visible = true
cbx_4.Visible = true
cbx_5.Visible = true

dw_saleh.DataObject = 'd_sal_05033_2'
dw_saleh.SetTransObject(sqlca)

dw_ip.object.sdate_t.text = '매출기간'
end event

type rb_old from radiobutton within w_sal_05033
integer x = 64
integer y = 140
integer width = 242
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "수정"
end type

event clicked;dw_list.Reset()
p_inq.Enabled = false
p_inq.PictureName = "C:\erpman\image\일괄발행_d.gif"
p_print.Enabled = False
p_print.PictureName = "C:\erpman\image\인쇄_d.gif"
p_can.Enabled = False
p_can.PictureName = "C:\erpman\image\일괄취소_d.gif"

/* 수불구분 추가 '20.09.25 BY BHKIM */
cbx_1.Visible = false
cbx_2.Visible = false
cbx_3.Visible = false
cbx_4.Visible = false
cbx_5.Visible = false

dw_saleh.DataObject = 'd_sal_05033_ds'
dw_saleh.SetTransObject(sqlca)

ds_print.Reset()
dw_list.Reset()
dw_ip.object.sdate_t.text = '발행기간'
end event

type ds_print from datawindow within w_sal_05033
boolean visible = false
integer x = 503
integer y = 5000
integer width = 41
integer height = 36
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "세금계산서 출력양식(건별)"
string dataobject = "d_sal_05030_list"
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rr_1 from roundrectangle within w_sal_05033
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 340
integer width = 4594
integer height = 1992
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_sal_05033
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 18
integer y = 28
integer width = 325
integer height = 300
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_saleh from datawindow within w_sal_05033
integer x = 27
integer y = 348
integer width = 4571
integer height = 1972
integer taborder = 30
string dataobject = "d_sal_05033_2"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;Long 	 nRow, ix, nCnt
String sChk, sIoCust, sNull, sIocustName, sData

nRow = GetRow()
If nRow <= 0 Then Return

SetNull(sNull)

Choose Case GetColumnName()
	Case 'chk'
		If rb_new.Checked = True Then
			sChk = GetText()
		End If
	/* 실적거래처 */
	Case "salescod"
		sIoCust = Trim(GetText())
		IF sIoCust ="" OR IsNull(sIoCust) THEN
			this.SetItem(1,"salescodnm",snull)
			Return
		END IF
		
		SELECT "VNDMST"."CVNAS2"
		  INTO :sIoCustName
		  FROM "VNDMST"
		 WHERE "VNDMST"."CVCOD" = :sIoCust;
		
		IF SQLCA.SQLCODE <> 0 THEN
			TriggerEvent(RbuttonDown!)
			Return 2
		ELSE
			SetItem(nRow,"salescodnm",  sIoCustName)
		END IF
	Case 'saledt'
		sChk = GetText()
		if f_datechk(sChk) = -1 then
			MessageBox("계산서일자", "일자가 부정확 합니다", stopsign!)
			setitem(nRow, "saledt", f_today())
			return 1
		End if
End Choose
end event

event rbuttondown;string sIoCustName, sIoCustArea,	sDept,sNull
Long   nRow

nRow = GetRow()
If nRow <= 0 Then Return

SetNull(sNull)
SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

Choose Case this.GetColumnName() 
	Case "salescod"
		Open(w_agent_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
	
		SetItem(nRow, "salescod", gs_code)
		SetItem(nRow, "salescodbn", gs_codename)
END Choose

end event

type pb_1 from u_pb_cal within w_sal_05033
integer x = 1015
integer y = 60
integer height = 76
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('sdatef')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'sdatef', gs_code)

end event

type pb_2 from u_pb_cal within w_sal_05033
integer x = 1481
integer y = 52
integer width = 96
integer height = 88
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('sdatet')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'sdatet', gs_code)

end event

type cbx_sale from checkbox within w_sal_05033
integer x = 2514
integer y = 156
integer width = 544
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "실적거래처 집계"
end type

type cbx_1 from checkbox within w_sal_05033
integer x = 421
integer y = 236
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "판매출고"
end type

type cbx_2 from checkbox within w_sal_05033
integer x = 814
integer y = 236
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "판매소급"
end type

type cbx_3 from checkbox within w_sal_05033
integer x = 1216
integer y = 236
integer width = 411
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "유상사급출고"
end type

type cbx_4 from checkbox within w_sal_05033
integer x = 1728
integer y = 236
integer width = 521
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "유상사급판매반품"
end type

type cbx_5 from checkbox within w_sal_05033
integer x = 2336
integer y = 236
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "기타"
end type

type dw_auto from datawindow within w_sal_05033
boolean visible = false
integer x = 2565
integer y = 16
integer width = 434
integer height = 356
boolean bringtotop = true
string dataobject = "d_sal_05030_auto"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event updatestart;Long ix

For ix = 1 To This.RowCount()
	Choose Case GetItemStatus(ix,0,Primary!)
		Case NewModified!
			This.SetItem(ix,'crt_user',gs_userid)
		Case DataModified!
			This.SetItem(ix,'upd_user',gs_userid)
	End Choose
Next
end event

