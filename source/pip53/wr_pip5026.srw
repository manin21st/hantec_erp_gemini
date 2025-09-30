$PBExportHeader$wr_pip5026.srw
$PBExportComments$** 근로소득원천징수영수증 출력
forward
global type wr_pip5026 from w_standard_print
end type
type rb_empwholetag from radiobutton within wr_pip5026
end type
type rb_empmantag from radiobutton within wr_pip5026
end type
type rb_year from radiobutton within wr_pip5026
end type
type rb_part from radiobutton within wr_pip5026
end type
type gb_5 from groupbox within wr_pip5026
end type
type gb_6 from groupbox within wr_pip5026
end type
type rb_1 from radiobutton within wr_pip5026
end type
type rb_2 from radiobutton within wr_pip5026
end type
type rb_3 from radiobutton within wr_pip5026
end type
type dw_1 from datawindow within wr_pip5026
end type
type rb_kunmutag from radiobutton within wr_pip5026
end type
type rb_sauptag from radiobutton within wr_pip5026
end type
type rb_jikjongtag from radiobutton within wr_pip5026
end type
type gb_1 from groupbox within wr_pip5026
end type
type rr_2 from roundrectangle within wr_pip5026
end type
end forward

global type wr_pip5026 from w_standard_print
string title = "근로소득 원천징수영수증 출력"
rb_empwholetag rb_empwholetag
rb_empmantag rb_empmantag
rb_year rb_year
rb_part rb_part
gb_5 gb_5
gb_6 gb_6
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
dw_1 dw_1
rb_kunmutag rb_kunmutag
rb_sauptag rb_sauptag
rb_jikjongtag rb_jikjongtag
gb_1 gb_1
rr_2 rr_2
end type
global wr_pip5026 wr_pip5026

type variables

end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String S_SAUPNO, S_JURNO, S_SANAME, S_PRESIDENT, S_ADDR
String	ls_smname, ls_name, ls_name2, ls_empno, ls_temp, ls_paydate, ls_year, ls_tag, ls_yymm
string   idt_todate, retiredate, ldt_enterdate, ls_left, ls_mid, ls_right, sSaup, sJikjong, sKunmu
String ls_crview
Long		row, i, row2 
Integer	rt, li_family

if dw_1.Accepttext() = -1 then return -1

Setpointer(hourglass!)

ls_paydate = dw_1.GetitemString(1,'ydate')
ls_yymm   =  dw_1.GetitemString(1,'yymm')
ls_empno = dw_1.GetitemString(1,'empno')
ls_year = left(ls_yymm,4) + "0101"
ls_smname = dw_1.GetitemString(1,'semu')
sKunmu = trim(dw_1.GetitemString(1,'kunmu'))
sSaup = trim(dw_1.GetItemString(1,"saup"))
sJikjong = trim(dw_1.GetItemString(1,"jikjong"))

IF sSaup = '' OR IsNull(sSaup) THEN sSaup = '%'
IF sJikjong = '' OR IsNull(sJikjong) THEN sJikjong = '%'
IF sKunmu = '' OR IsNull(sKunmu) THEN sKunmu = '%'
IF ls_empno = '' OR IsNull(ls_empno) THEN ls_empno = '%'

IF f_datechk(ls_yymm + "01") = -1 THEN
	Messagebox("확 인", "작업년월을 입력하세요!!")
	dw_1.Setcolumn('yymm')
	dw_1.SetFocus()
	Return -1 
END IF

//if ls_smname = "" or isnull(ls_smname) then 
//	Messagebox("확 인", "세무서를 입력하세요.!!")
//	dw_1.Setcolumn('semu')
//	dw_1.SetFocus()
//	return -1
//end if	
//
//IF f_datechk(ls_paydate) = -1 THEN
//   MessageBox("확 인","영수일자를 확인하세요!!")
//   dw_1.Setcolumn('ydate')
//	dw_1.SetFocus()
//	Return -1
//END IF		


if rb_year.Checked then	// 연말정산
	ls_tag = '1'
else 
	ls_tag = '2'	  	 // 중도정산
end if


///*부양가족수와 관련하여 출력할 페이지수를 참조할 뷰 생성*/
//ls_crview = "CREATE OR REPLACE VIEW VW_ACNT_EMPNO(EMPNO,PAGENUM) AS &
//SELECT A.EMPNO, B.NUM &
//  FROM &
//			(SELECT A.EMPNO, NVL(B.CNT,1) AS CNT &
//			 FROM P3_ACNT_TAXCAL_DATA A, &
//					(SELECT EMPNO, CEIL(COUNT(*)/7) AS CNT &
//						FROM P3_ACNT_FAMILY &
//						  WHERE WORKYEAR = '" + left(ls_yymm,4) + "' AND &
//								  GUBUN <> 0 &
//					 GROUP BY EMPNO) B  &
//			WHERE A.EMPNO = B.EMPNO(+) AND  &
//			A.WORKYEAR = '" + left(ls_yymm,4) + "' AND &
//			A.WORKMM = '" + right(ls_yymm,2) + "' AND  &
//			A.TAG = '" + ls_tag + "') A, &
//			(SELECT 1 AS NUM FROM DUAL &
//			 UNION &
//			 SELECT 2 AS NUM FROM DUAL &
//			 UNION &
//			 SELECT 3 AS NUM FROM DUAL &
//			 UNION &
//			 SELECT 4 AS NUM FROM DUAL &
//			 UNION &
//			 SELECT 5 AS NUM FROM DUAL &
//			) B &
//WHERE B.NUM <= A.CNT"
//
//declare start_sp_pi_crview procedure for sp_pi_crview(:ls_crview);
//execute start_sp_pi_crview;
//
//IF SQLCA.SQLCODE = -1 THEN
//	Messagebox('VIEW 생성 실패','VIEW 생성에 실패하였습니다!!')
//	return -1
//END IF

	/* Start of Most Outer IF-Statement */
//IF rb_empmantag.Checked THEN	// 개인일 경우
//  idt_todate = f_last_date(ls_yymm)
//  dw_1.Accepttext()
//  
//  ls_empno = dw_1.GetitemString(1,'empno')
//
//  if ls_empno = "" or isnull(ls_empno) then 
//	  messagebox("확 인", "성명을 입력하세요!!")
//	  dw_1.Setcolumn('empno')
//	  dw_1.SetFocus( )
//     return -1
//  end if	
//
//  select retiredate into :retiredate from p1_master 
//   where companycode = :gs_company and empno = :ls_empno 
//   using sqlca;
//
//  dw_list.SetRedraw(False)		
//  row = dw_list.Retrieve(gs_company,ls_yymm, ls_empno, ls_paydate, ls_tag, sSaup, sJikjong, sKunmu)
//	
//	if ls_tag = '2' then
//		dw_list.SetItem(1, "ctodate", retiredate)
//	else
//		dw_list.SetItem(1, "ctodate", idt_todate)
//	end if
//
//	SELECT	ENTERDATE	INTO :ldt_enterdate
//	FROM		P1_MASTER
//	WHERE		COMPANYCODE	= :gs_company
//	  AND		EMPNO			= :ls_empno;
//	if left(ldt_enterdate, 4) = left(ls_year, 4) then
//		rt = dw_list.SetItem(1, "cfromdate", ldt_enterdate)
//	else
//		dw_list.SetItem(1, "cfromdate", ls_year)
//	end if

//	If Row = 1 Then
//
//		row2 = dw_ip.Retrieve(gs_company,ls_yymm, ls_empno)
//		If row2 > 0 Then
//			dw_list.SetItem(1, "cprev1_name", dw_ip.GetItemString(1, "companyname"))
//			dw_list.SetItem(1, "cprev1_no", dw_ip.GetItemString(1, "companyno"))
//			dw_list.SetItem(1, "cprev1_totalpay", dw_ip.GetItemNumber(1, "paytotal"))
//			dw_list.SetItem(1, "cprev1_totalbonus", dw_ip.GetItemNumber(1, "bonustotal"))
//			dw_list.SetItem(1, "prev1_injungbonus", dw_ip.GetItemNumber(1, "injungbonusamt"))
//			If row2 = 2 Then
//				dw_list.SetItem(1, "cprev2_name", dw_ip.GetItemString(2, "companyname"))
//				dw_list.SetItem(1, "cprev2_no", dw_ip.GetItemString(2, "companyno"))
//				dw_list.SetItem(1, "cprev2_totalpay", dw_ip.GetItemNumber(2, "paytotal"))
//				dw_list.SetItem(1, "cprev2_totalbonus", dw_ip.GetItemNumber(2, "bonustotal"))
//				dw_list.SetItem(1, "prev2_injungbonus", dw_ip.GetItemNumber(2, "injungbonusamt"))
//			End If
//			If row2 > 2 Then
//				ls_temp = dw_list.GetItemString(1, "pay_acnt_taxcal_data.empno")
//				MessageBox("확 인", "사번 " + ls_temp + "의 전근무지 데이터가 3개이상입니다.")
//			End If
//		End If
//		dw_list.SetItem(1, "cetc_name", ls_smname)
//
//	  SELECT C.SAUPNO, C.JURNO, C.JURNAME, C.CHAIRMAN, C.ADDR
//		 INTO :S_SAUPNO,			//사업자번호
//				:S_JURNO,			//주민(법인)번호
//				:S_SANAME,			//사업장명
//				:S_PRESIDENT,		//대표자명
//				:S_ADDR				//사업장주소
//		 FROM "P1_MASTER" A, "P0_DEPT" B, "P0_SAUPCD" C
//		WHERE (A.COMPANYCODE = :Gs_Company AND
//				 A.COMPANYCODE = B.COMPANYCODE AND
//				 A.COMPANYCODE = C.COMPANYCODE AND
//				 A.DEPTCODE		= B.DEPTCODE AND
//				 B.SAUPCD		= C.SAUPCODE) AND
//				(A.EMPNO = :ls_empno);
//
//		IF Sqlca.SqlCode <> 0 THEN
//			MessageBox('확인','사업장 정보를 조회할 수 없습니다.')
//		ELSE
//			dw_list.SetItem(1, "ccsno", S_SAUPNO)
//			dw_list.SetItem(1, "crno", S_JURNO)
//			dw_list.SetItem(1, "ccname", S_SANAME)
//			dw_list.SetItem(1, "caddr", S_ADDR)
//			dw_list.SetItem(1, "cdpman", S_PRESIDENT)
//		END IF
//		
//      dw_list.SetRedraw(true)		
//   
//   ELSE
//	   MessageBox("확 인","조회한 자료가 없습니다!!")
//		dw_list.Insertrow(0)
//      dw_list.SetRedraw(true)		
//      return -1
//	End If
//
//ELSE									// 전체,근무구분별일 경우
   idt_todate = f_last_date(ls_yymm) 

   dw_list.SetRedraw(False)		
   row = dw_list.Retrieve(gs_company, ls_yymm, ls_empno, ls_paydate, ls_tag, sSaup, sJikjong, sKunmu,'%')

	If Row > 0 Then
		For i = 1 To row
		ls_empno = dw_list.GetItemString(i, "p3_acnt_taxcal_data_empno")
		if ls_tag = '2' then
			select retiredate into :retiredate from p1_master 
			where companycode = :gs_company and empno = :ls_empno 
			using sqlca;
			dw_list.SetItem(i, "ctodate", retiredate)
		else
			dw_list.SetItem(i, "ctodate", idt_todate)
		end if

		SELECT	ENTERDATE	INTO :ldt_enterdate
		FROM		P1_MASTER
		WHERE		COMPANYCODE	= :gs_company
		  AND		EMPNO			= :ls_empno;
		if left(ldt_enterdate, 4) = left(ls_year, 4) then
			dw_list.SetItem(i, "cfromdate", ldt_enterdate)
		else
			dw_list.SetItem(i, "cfromdate", ls_year)
		end if
		
		row2 = dw_ip.Retrieve(gs_company,ls_yymm, ls_empno)
			If row2 > 0 Then
				dw_list.SetItem(i, "cprev1_name", dw_ip.GetItemString(1, "companyname"))
				dw_list.SetItem(i, "cprev1_no", dw_ip.GetItemString(1, "companyno"))
				dw_list.SetItem(i, "cprev1_totalpay", dw_ip.GetItemNumber(1, "paytotal"))
				dw_list.SetItem(i, "cprev1_totalbonus", dw_ip.GetItemNumber(1, "bonustotal"))
				dw_list.SetItem(i, "prev1_injungbonus", dw_ip.GetItemNumber(1, "injungbonusamt"))
					If row2 = 2 Then
						dw_list.SetItem(i, "cprev2_name", dw_ip.GetItemString(2, "companyname"))
						dw_list.SetItem(i, "cprev2_no", dw_ip.GetItemString(2, "companyno"))
						dw_list.SetItem(i, "cprev2_totalpay", dw_ip.GetItemNumber(2, "paytotal"))
						dw_list.SetItem(i, "cprev2_totalbonus", dw_ip.GetItemNumber(2, "bonustotal"))
						dw_list.SetItem(i, "prev2_injungbonus", dw_ip.GetItemNumber(2, "injungbonusamt"))
					End If
						If row2 > 2 Then
							ls_temp = dw_list.GetItemString(i, "pay_acnt_taxcal_data.empno")
							MessageBox("확 인", "사번 " + ls_temp + "의 전근무지 데이터가 3개이상입니다.")
						End If
			End If
			dw_list.SetItem(i, "cetc_name", ls_smname)

	  SELECT C.SAUPNO, C.JURNO, C.JURNAME, C.CHAIRMAN, C.ADDR
		 INTO :S_SAUPNO,			//사업자번호
				:S_JURNO,			//주민(법인)번호
				:S_SANAME,			//사업장명
				:S_PRESIDENT,		//대표자명
				:S_ADDR				//사업장주소
		 FROM "P1_MASTER" A, "P0_DEPT" B, "P0_SAUPCD" C
		WHERE (A.COMPANYCODE = :Gs_Company AND
				 A.COMPANYCODE = B.COMPANYCODE AND
				 A.COMPANYCODE = C.COMPANYCODE AND
				 A.DEPTCODE		= B.DEPTCODE AND
				 B.SAUPCD		= C.SAUPCODE) AND
				(A.EMPNO = :ls_empno);

		IF Sqlca.SqlCode <> 0 THEN
			MessageBox('확인','사업장 정보를 조회할 수 없습니다.')
		ELSE
			dw_list.SetItem(i, "ccsno", S_SAUPNO)
			dw_list.SetItem(i, "crno", S_JURNO)
			dw_list.SetItem(i, "ccname", S_SANAME)
			dw_list.SetItem(i, "caddr", S_ADDR)
			dw_list.SetItem(i, "cdpman", S_PRESIDENT)
		END IF

      Next
    	dw_list.SetRedraw(True)
   ELSE 
	   MessageBox("확 인","조회한 자료가 없습니다!!")
		dw_list.Insertrow(0)
      dw_list.SetRedraw(true)		
      return -1
   End If

//End If	/* End of Most Outer IF-Statement */


if rb_1.checked = true then
	dw_list.object.st_name.text = '[발행자 보관용]'
elseif rb_2.checked = true then
   dw_list.object.st_name.text = '[발행자 보고용]' 
else
	dw_list.object.st_name.text = '[소득자 보관용]' 
end if

return 1

end function

on wr_pip5026.create
int iCurrent
call super::create
this.rb_empwholetag=create rb_empwholetag
this.rb_empmantag=create rb_empmantag
this.rb_year=create rb_year
this.rb_part=create rb_part
this.gb_5=create gb_5
this.gb_6=create gb_6
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.dw_1=create dw_1
this.rb_kunmutag=create rb_kunmutag
this.rb_sauptag=create rb_sauptag
this.rb_jikjongtag=create rb_jikjongtag
this.gb_1=create gb_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_empwholetag
this.Control[iCurrent+2]=this.rb_empmantag
this.Control[iCurrent+3]=this.rb_year
this.Control[iCurrent+4]=this.rb_part
this.Control[iCurrent+5]=this.gb_5
this.Control[iCurrent+6]=this.gb_6
this.Control[iCurrent+7]=this.rb_1
this.Control[iCurrent+8]=this.rb_2
this.Control[iCurrent+9]=this.rb_3
this.Control[iCurrent+10]=this.dw_1
this.Control[iCurrent+11]=this.rb_kunmutag
this.Control[iCurrent+12]=this.rb_sauptag
this.Control[iCurrent+13]=this.rb_jikjongtag
this.Control[iCurrent+14]=this.gb_1
this.Control[iCurrent+15]=this.rr_2
end on

on wr_pip5026.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_empwholetag)
destroy(this.rb_empmantag)
destroy(this.rb_year)
destroy(this.rb_part)
destroy(this.gb_5)
destroy(this.gb_6)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.dw_1)
destroy(this.rb_kunmutag)
destroy(this.rb_sauptag)
destroy(this.rb_jikjongtag)
destroy(this.gb_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_list.ShareDataOff()
dw_list.InsertRow(0)
dw_1.Settransobject(sqlca)
dw_1.insertrow(0)
dw_1.Setitem(1,'yymm', left(f_today(),6))


rb_empwholetag.Triggerevent(Clicked!)

is_saupcd = gs_saupcd
end event

type p_preview from w_standard_print`p_preview within wr_pip5026
integer x = 4069
end type

event p_preview::clicked;OpenWithParm(w_print_preview, dw_list)	
end event

type p_exit from w_standard_print`p_exit within wr_pip5026
integer x = 4416
end type

type p_print from w_standard_print`p_print within wr_pip5026
integer x = 4242
end type

event p_print::clicked;IF dw_list.rowcount() > 0 then 
	gi_page = dw_list.GetItemNumber(1,"last_page")
ELSE
	gi_page = 1
END IF
OpenWithParm(w_print_options, dw_list)
end event

type p_retrieve from w_standard_print`p_retrieve within wr_pip5026
integer x = 3895
end type

type st_window from w_standard_print`st_window within wr_pip5026
boolean visible = false
integer x = 2400
integer y = 3184
end type

type sle_msg from w_standard_print`sle_msg within wr_pip5026
boolean visible = false
integer x = 425
integer y = 3184
end type

type dw_datetime from w_standard_print`dw_datetime within wr_pip5026
boolean visible = false
integer x = 2894
integer y = 3184
end type

type st_10 from w_standard_print`st_10 within wr_pip5026
boolean visible = false
integer x = 64
integer y = 3184
end type

type gb_10 from w_standard_print`gb_10 within wr_pip5026
boolean visible = false
integer x = 50
integer y = 3148
end type

type dw_print from w_standard_print`dw_print within wr_pip5026
string dataobject = "dr_pip5026_2"
end type

type dw_ip from w_standard_print`dw_ip within wr_pip5026
boolean visible = false
integer x = 1010
integer y = 2564
integer width = 622
integer height = 104
boolean titlebar = true
string title = "전근무지자료"
string dataobject = "dr_pip5026_1"
boolean vscrollbar = true
end type

type dw_list from w_standard_print`dw_list within wr_pip5026
integer x = 165
integer y = 332
integer width = 3643
integer height = 1928
string dataobject = "dr_pip5026_2"
end type

event dw_list::clicked;//OVERRIDE

end event

event dw_list::rowfocuschanged;//OVERRIDE
end event

type rb_empwholetag from radiobutton within wr_pip5026
integer x = 1870
integer y = 68
integer width = 256
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "전 체"
boolean checked = true
end type

event clicked;String snull
SetNull(snull)

dw_1.object.empno_t.visible = false
dw_1.object.empno.visible = false
dw_1.object.empname.visible = false
dw_1.object.p_1.visible = false

dw_1.object.t_gubun.visible = false
dw_1.object.saup.visible = false
dw_1.object.jikjong.visible = false
dw_1.object.kunmu.visible = false
dw_1.object.saup[1] = ''
dw_1.object.jikjong[1] = ''
dw_1.object.kunmu[1] = ''


dw_1.SetItem(dw_1.GetRow(), 'saup', Snull)
dw_1.Modify('saup.protect = 0')
is_saupcd = '%'
end event

type rb_empmantag from radiobutton within wr_pip5026
integer x = 1870
integer y = 212
integer width = 251
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "개 인"
end type

event clicked;String snull
SetNull(snull)

dw_1.object.empno_t.visible = true
dw_1.object.empno.visible = true
dw_1.object.empname.visible = true
dw_1.object.p_1.visible = true

dw_1.object.t_gubun.visible = false
dw_1.object.saup.visible = false
dw_1.object.jikjong.visible = false
dw_1.object.kunmu.visible = false
dw_1.object.saup[1] = ''
dw_1.object.jikjong[1] = ''
dw_1.object.kunmu[1] = ''

dw_1.SetItem(dw_1.GetRow(), 'saup', snull)
dw_1.Modify('saup.protect = 0')
is_saupcd = '%'
end event

type rb_year from radiobutton within wr_pip5026
integer x = 2642
integer y = 140
integer width = 325
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "연말정산"
boolean checked = true
boolean automatic = false
end type

event clicked;rb_part.checked=false
rb_year.checked=true
end event

type rb_part from radiobutton within wr_pip5026
integer x = 2642
integer y = 68
integer width = 325
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "퇴직정산"
boolean automatic = false
end type

event clicked;rb_year.checked=false
rb_part.checked=true
end event

type gb_5 from groupbox within wr_pip5026
integer x = 1829
integer y = 8
integer width = 750
integer height = 288
integer taborder = 10
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "인원구분"
end type

type gb_6 from groupbox within wr_pip5026
integer x = 2592
integer y = 8
integer width = 434
integer height = 288
integer taborder = 20
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "작업구분"
end type

type rb_1 from radiobutton within wr_pip5026
integer x = 3095
integer y = 68
integer width = 457
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "발행자 보관용"
boolean checked = true
end type

type rb_2 from radiobutton within wr_pip5026
integer x = 3095
integer y = 140
integer width = 457
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "발행자 보고용"
end type

type rb_3 from radiobutton within wr_pip5026
integer x = 3095
integer y = 212
integer width = 457
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "소득자 보관용"
end type

type dw_1 from datawindow within wr_pip5026
event ue_key pbm_dwnkey
event ue_enter pbm_dwnprocessenter
integer x = 110
integer width = 1714
integer height = 304
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "dr_pip5026_3"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_enter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;string sempname, sempno, snull, ls_Name
int il_count
SetNull(snull)

this.AcceptText()

IF this.GetColumnName() = 'saup' THEN
	is_saupcd = this.GetText()
	
	IF is_saupcd = '' OR IsNull(is_saupcd) THEN is_saupcd = '%'
END IF

if This.GetColumnName() = 'empno' then
	sempno = this.Gettext()

   IF sempno ="" OR IsNull(sempno) THEN RETURN   

	SELECT count(*) INTO :il_count
	  FROM "P1_MASTER"
	 WHERE "P1_MASTER"."EMPNO" = :sempno;

	IF il_Count > 0 THEN
		SELECT "EMPNAME" INTO :sempname
		  FROM "P1_MASTER"
		 WHERE "P1_MASTER"."EMPNO" = :sempno;
	ELSE
		Messagebox("확 인","등록되지 않은 사번이므로 조회할 수 없습니다!!")
		dw_1.setitem(1,'empno', snull)
		dw_1.setitem(1,'empname', snull)
		dw_1.SetColumn('empno')
		dw_1.SetFocus()
		return
	END IF
	
	dw_1.Setitem(1,'empname', sempname)
	
end if
IF GetColumnName() = "empname" then
  sEmpName = GetItemString(1,"empname")

   ls_name = wf_exiting_saup_name('empname',sEmpName, '1', is_saupcd)	 
	 if IsNull(ls_name) then 
		 Setitem(1,'empname',ls_name)
		 Setitem(1,'empno',ls_name)
		 return 1
    end if
	 Setitem(1,"empno",ls_name)
	 ls_name = wf_exiting_saup_name('empno',ls_name, '1', is_saupcd)
	 Setitem(1,"empname",ls_name)
	 return 1
END IF


end event

event itemerror;return 1
end event

event rbuttondown;string sempname, sempno, snull
int il_count

SetNull(Gs_codename)
SetNull(Gs_code)
SetNull(Gs_gubun)

IF rb_sauptag.checked = true THEN
	Gs_gubun = is_saupcd
	if This.GetColumnName() = 'empno' then
	
		open(w_employee_saup_popup)
			
		IF IsNull(Gs_code) THEN RETURN
		 
		dw_1.SetITem(1,"empno",Gs_code)
		dw_1.SetITem(1,"empname",Gs_codename)
		
	end if
ELSE
	if This.GetColumnName() = 'empno' then
	
		open(w_employee_popup)
			
		IF IsNull(Gs_code) THEN RETURN
		 
		dw_1.SetITem(1,"empno",Gs_code)
		dw_1.SetITem(1,"empname",Gs_codename)
		
	end if
END IF



end event

type rb_kunmutag from radiobutton within wr_pip5026
integer x = 2158
integer y = 212
integer width = 361
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "근무구분별"
end type

event clicked;String snull
SetNull(snull)

dw_1.object.empno_t.visible = false
dw_1.object.empno.visible = false
dw_1.object.empname.visible = false
dw_1.object.p_1.visible = false

dw_1.object.saup.visible = false
dw_1.object.jikjong.visible = false
dw_1.object.kunmu.visible = true
dw_1.object.kunmu[1] = '10'

dw_1.object.t_gubun.text = '근무구분'
dw_1.object.t_gubun.visible = true


dw_1.SetItem(dw_1.GetRow(), 'saup', snull)
dw_1.Modify('saup.protect = 0')
is_saupcd = '%'
end event

type rb_sauptag from radiobutton within wr_pip5026
integer x = 2158
integer y = 68
integer width = 361
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "사업장별"
end type

event clicked;dw_1.object.empno_t.visible = false
dw_1.object.empno.visible = false
dw_1.object.empname.visible = false
dw_1.object.p_1.visible = false

dw_1.object.saup.visible = true
dw_1.object.jikjong.visible = false
dw_1.object.kunmu.visible = false
dw_1.object.saup[1] = '10'

f_set_saupcd(dw_1, 'saup', '1')
is_saupcd = gs_saupcd

dw_1.object.t_gubun.text = '사 업 장'
dw_1.object.t_gubun.visible = true
end event

type rb_jikjongtag from radiobutton within wr_pip5026
integer x = 2158
integer y = 140
integer width = 361
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "직종구분별"
end type

event clicked;String snull
SetNull(snull)

dw_1.object.empno_t.visible = false
dw_1.object.empno.visible = false
dw_1.object.empname.visible = false
dw_1.object.p_1.visible = false

dw_1.object.saup.visible = false
dw_1.object.jikjong.visible = true
dw_1.object.kunmu.visible = false
dw_1.object.jikjong[1] = '1'

dw_1.object.t_gubun.text = '직종구분'
dw_1.object.t_gubun.visible = true

dw_1.SetItem(dw_1.GetRow(), 'saup', snull)
dw_1.Modify('saup.protect = 0')
is_saupcd = '%'
end event

type gb_1 from groupbox within wr_pip5026
integer x = 3040
integer y = 8
integer width = 562
integer height = 288
integer taborder = 20
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "출력구분"
end type

type rr_2 from roundrectangle within wr_pip5026
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 16777215
integer x = 151
integer y = 320
integer width = 3675
integer height = 1952
integer cornerheight = 40
integer cornerwidth = 46
end type

