$PBExportHeader$w_pdt_03900.srw
$PBExportComments$출고등록(할당-품목별) | 조회화면
forward
global type w_pdt_03900 from w_inherite
end type
type dw_1 from u_key_enter within w_pdt_03900
end type
type dw_imhist from datawindow within w_pdt_03900
end type
type cbx_1 from checkbox within w_pdt_03900
end type
type dw_print from datawindow within w_pdt_03900
end type
type cbx_2 from checkbox within w_pdt_03900
end type
type dw_imhist_in from datawindow within w_pdt_03900
end type
type dw_3 from datawindow within w_pdt_03900
end type
type rr_1 from roundrectangle within w_pdt_03900
end type
type dw_2 from u_d_select_sort within w_pdt_03900
end type
type rr_2 from roundrectangle within w_pdt_03900
end type
end forward

global type w_pdt_03900 from w_inherite
string title = "출고 등록-[할당/품목별]"
dw_1 dw_1
dw_imhist dw_imhist
cbx_1 cbx_1
dw_print dw_print
cbx_2 cbx_2
dw_imhist_in dw_imhist_in
dw_3 dw_3
rr_1 rr_1
dw_2 dw_2
rr_2 rr_2
end type
global w_pdt_03900 w_pdt_03900

type variables
string is_date
str_itnct lstr_sitnct
end variables

forward prototypes
public function integer wf_imhist_create (ref string arg_jpno)
end prototypes

public function integer wf_imhist_create (ref string arg_jpno);////////////////////////////////////
//											 //
//	* 등록모드                     //
//	1. 입출고HISTORY 생성          //
//	2. 전표채번구분 = 'C0'         //
// 3. 전표생성구분 = '002'        //
//                                //  
////////////////////////////////////
string	sJpno, sProject, 	&
			sDate, sToday,	sQcgub,	sOutside, &
			sHouse, sEmpno, sRcvcod, siogubun, snull, ssaleyn, soutstore, shold_no, sopseq
long		lRow, lRowHist, lRowHist_In, lCOUNT, dSeq, dInseq, old_dseq, i, k, l 
dec{3}	dOutQty

if dw_1.AcceptText() = -1 then return -1
if dw_insert.accepttext() = -1 then return -1

dw_imhist.reset()

sDate = trim(dw_1.GetItemString(1, "edate")) // 출고일자
dSeq = SQLCA.FUN_JUNPYO(gs_Sabu, sDate, 'C0')

IF dSeq < 0	THEN
	rollback;
	RETURN -1
end if

dInSeq = SQLCA.FUN_JUNPYO(gs_Sabu, sDate, 'C0')
IF dInSeq < 0 THEN
	rollback;
	RETURN -1
end if
COMMIT;

////////////////////////////////////////////////////////////////////

sJpno    = sDate + string(dSeq, "0000")
sHouse   = dw_1.GetItemString(1, "house")
sEmpno   = dw_1.GetItemString(1, "empno")

//무검사 데이타 가져오기
SELECT "SYSCNFG"."DATANAME"  
  INTO :sQcgub  
  FROM "SYSCNFG"  
 WHERE ( "SYSCNFG"."SYSGU" = 'Y' ) AND  
		 ( "SYSCNFG"."SERIAL" = 13 ) AND  
		 ( "SYSCNFG"."LINENO" = '2' )   ;
if sqlca.sqlcode <> 0 then
	sQcgub = '1'
end if

i = 0 //출고전표 채번용
k = 0 //채번 순번
l = 0 //입고전표 채번용

lcount = dw_insert.RowCount()

FOR	lRow = 1		TO		lCount 

	dOutQty = dw_insert.GetItemDecimal(lRow, "outqty")

	IF dOutQty > 0		THEN
      if i > 997 then 
			exit 
		end if

      sOutstore = dw_insert.GetItemString(lRow,  "out_store")
	
		//////////////////////////////
		//                          //
		// ** 입출고HISTORY 생성 ** //
		//                          //
		//////////////////////////////
		lRowHist = dw_imhist.InsertRow(0)
      i++ 		
		
		dw_imhist.SetItem(lRowHist, "io_confirm", 'N')			// 수불승인여부
		dw_imhist.SetItem(lRowHist, "ioqty", dw_insert.GetItemDecimal(lRow, "outqty")) 	// 수불수량=입고수량
		dw_imhist.SetItem(lRowHist, "io_date",  sDate)		// 수불승인일자=입고의뢰일자
		dw_imhist.SetItem(lRowHist, "io_empno", sempno)		// 수불승인자

		dw_imhist.SetItem(lRowHist, "sabu",		gs_Sabu)
		dw_imhist.SetItem(lRowHist, "jnpcrt",	'002')			// 전표생성구분
		dw_imhist.SetItem(lRowHist, "inpcnf",  'O')				// 입출고구분
		dw_imhist.SetItem(lRowHist, "iojpno", 	sJpno + string(i, "000") )
		dw_imhist.SetItem(lRowHist, "iogbn",   dw_insert.GetItemString(lRow, "hold_gu")) // 수불구분=요청구분
	
		dw_imhist.SetItem(lRowHist, "sudat",	sdate)			// 수불일자=출고일자
		dw_imhist.SetItem(lRowHist, "itnbr",	dw_insert.GetItemString(lRow, "itnbr")) // 품번
		dw_imhist.SetItem(lRowHist, "pspec",	dw_insert.GetItemString(lRow, "pspec")) // 사양
		dw_imhist.SetItem(lRowHist, "depot_no",sHouse) 			// 기준창고=출고창고
		dw_imhist.SetItem(lRowHist, "cvcod",	soutstore) 	// 거래처창고=입고처
		dw_imhist.SetItem(lRowHist, "ioreqty",	dw_insert.GetItemDecimal(lRow, "outqty")) 	// 수불의뢰수량=출고수량		
		dw_imhist.SetItem(lRowHist, "insdat",	sDate)			// 검사일자=출고일자	
		dw_imhist.SetItem(lRowHist, "iosuqty",	dw_insert.GetItemDecimal(lRow, "outqty")) 	// 합격수량=출고수량		
		dw_imhist.SetItem(lRowHist, "io_confirm",	'Y')			// 수불승인여부
		
		sHold_no = dw_insert.GetItemString(lRow, "hold_no")
		dw_imhist.SetItem(lRowHist, "ip_jpno", sHold_no) 	// 할당번호(입고번호에 저장)
		
		dw_imhist.SetItem(lRowHist, "opseq", '9999') 	// 공정순서
		
		dw_imhist.SetItem(lRowHist, "filsk",   'Y') // 재고관리유무
		dw_imhist.SetItem(lRowHist, "botimh",	'N')				// 동시출고여부
		dw_imhist.SetItem(lRowHist, "itgu",    dw_insert.GetItemString(lRow, "itemas_itgu")) 	// 구입형태
		dw_imhist.SetItem(lRowHist, "outchk",  dw_insert.GetItemString(lRow, "hosts")) 			// 출고의뢰완료
		dw_imhist.SetItem(lRowHist, "jakjino", dw_insert.GetItemString(lRow, "pordno"))

		dw_imhist.SetItem(lRowHist, "lotsno",  dw_insert.GetItemString(lRow, "lotno"))
		
		// 상대 창고에 대한 입고의뢰 자동 생성
		sIogubun = dw_insert.getitemstring(lrow, "hold_gu")
		
		setnull(srcvcod)
		SELECT RCVCOD, OUTSIDE_IN
		  INTO :sRcvcod, :sOutside
		  FROM IOMATRIX
		 WHERE SABU = :gs_Sabu		AND
				 IOGBN = :sIOgubun ;
				  
		if sqlca.sqlcode <> 0 then
			f_message_chk(208, '[출고구분]')
		end if
		
		/* 생산 창고이동 출고인 경우 상대 입고구분을 검색 
			-. 단 외주사급출고인 경우에는 제외 */
		if sOutside = 'Y' then
		else
				if isnull(srcvcod) or trim(srcvcod) = '' then
					messagebox("상대창고", "입고구분이 없습니다.")
					return -1
				end if		
				
				lRowHist_In = dw_imhist_in.InsertRow(0)
			   l++
				// 수불승인여부는 해당 창고의 승인여부를 기준으로 한다
				// 단 재고관리 대상이 아닌 것은 자동승인'Y'으로 설정
				Setnull(sSaleyn)
				SELECT HOMEPAGE
				  INTO :sSaleYN
				  FROM VNDMST
				 WHERE ( CVCOD = :sOutstore ) ;	
		
				IF isnull(sSaleyn) or trim(ssaleyn) = '' then
					Ssaleyn = 'N'
				end if			 
				 
				IF sSaleYn = 'Y' then
					dw_imhist_in.SetItem(lRowHist_in, "ioqty", dw_insert.GetItemDecimal(lRow, "outqty")) 	// 수불수량=입고수량
					dw_imhist_in.SetItem(lRowHist_in, "io_date",  sdate)		// 수불승인일자=입고의뢰일자
					dw_imhist_in.SetItem(lRowHist_in, "io_empno", sNull)		// 수불승인자=NULL
				ELSE
					dw_imhist_in.SetItem(lRowHist_in, "ioqty", 0) 	// 수불수량=입고수량
					dw_imhist_in.SetItem(lRowHist_in, "io_date",  sNull)		// 수불승인일자=입고의뢰일자
					dw_imhist_in.SetItem(lRowHist_in, "io_empno", sNull)		// 수불승인자=NULL
				END IF	
				dw_imhist_in.SetItem(lRowHist_in, "io_confirm",	ssaleyn)			// 수불승인여부

				// 2000/11/10 유상웅 수정 => 자재출고는 작업공정이 아니고 무조건 공정이 '9999'
				dw_imhist_in.SetItem(lRowHist_in, "opseq", '9999') 	// 공정순서
				
				dw_imhist_in.SetItem(lRowHist_In, "sabu",		gs_sabu)
				dw_imHist_in.SetItem(lRowHist_in, "jnpcrt",	'011')			// 전표생성구분
				dw_imHist_in.SetItem(lRowHist_in, "inpcnf",  'I')				// 입출고구분
				dw_imHist_in.SetItem(lRowHist_in, "iojpno", 	sDate + string(dInSeq, "0000") + string(l, "000") )
				dw_imHist_in.SetItem(lRowHist_in, "iogbn",   srcvcod) 		// 수불구분=창고이동입고구분
		
				dw_imHist_in.SetItem(lRowHist_in, "sudat",	sdate)			// 수불일자=출고일자
				dw_imHist_in.SetItem(lRowHist_in, "itnbr",	dw_insert.GetItemString(lRow, "itnbr")) // 품번
				dw_imHist_in.SetItem(lRowHist_in, "pspec",	dw_insert.GetItemString(lRow, "pspec")) // 사양
				dw_imHist_in.SetItem(lRowHist_in, "depot_no",dw_insert.GetItemString(lRow, "out_store")) 	// 기준창고=입고처
				dw_imHist_in.SetItem(lRowHist_in, "cvcod",	sHouse) 			// 거래처창고=출고창고
		
				dw_imHist_in.SetItem(lRowHist_in, "ioreqty",	dw_insert.GetItemDecimal(lRow, "outqty")) 	// 수불의뢰수량=출고수량		
				dw_imHist_in.SetItem(lRowHist_in, "insdat",	sDate)			// 검사일자=출고일자	
				dw_imHist_in.SetItem(lRowHist_in, "qcgub",	sQcgub)			// 검사방법=> 무검사
				dw_imHist_in.SetItem(lRowHist_in, "iosuqty",	dw_insert.GetItemDecimal(lRow, "outqty")) 	// 합격수량=출고수량		
				dw_imHist_in.SetItem(lRowHist_in, "filsk",   'N') // 재고관리유무
				dw_imHist_in.SetItem(lRowHist_in, "botimh",	'N')				// 동시출고여부
				dw_imHist_in.SetItem(lRowHist_in, "itgu",    dw_insert.GetItemString(lRow, "itemas_itgu")) 	// 구입형태
		
				dw_imHist_in.SetItem(lRowHist_in, "ioredept",dw_insert.GetItemString(lRow, "holdstock_req_dept"))		// 수불의뢰부서=할당.부서
				dw_imHist_in.SetItem(lRowHist_in, "ioreemp",	sEmpno)			// 수불의뢰담당자=담당자	
				dw_imHist_in.SetItem(lRowHist_in, "ip_jpno", sJpno + string(i, "000"))  // 입고전표번호=출고번호		
				
				dw_imhist_in.SetItem(lRowHist_in, "lotsno", dw_insert.GetItemString(lRow, "lotno"))
		end if				
		
	END IF

NEXT

if dw_imhist.update() <> 1 or dw_imhist_in.update() <> 1 then
	rollback;
	f_rollback()		
	return -1
end if

commit;

if k > 0 then 
	MessageBox("전표번호 확인", "전표번호 : " +sDate+ '-' + string(old_dSeq,"0000")+	' 부터' +	&
										 string(dSeq,"0000")+	' 까지' +	&
										 "~r~r생성되었습니다.")
else
	MessageBox("전표번호 확인", "전표번호 : " +sDate+ '-' + string(dSeq,"0000")+		&
										 "~r~r생성되었습니다.")
end if

arg_jpno = sJpno

RETURN 1
end function

on w_pdt_03900.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_imhist=create dw_imhist
this.cbx_1=create cbx_1
this.dw_print=create dw_print
this.cbx_2=create cbx_2
this.dw_imhist_in=create dw_imhist_in
this.dw_3=create dw_3
this.rr_1=create rr_1
this.dw_2=create dw_2
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_imhist
this.Control[iCurrent+3]=this.cbx_1
this.Control[iCurrent+4]=this.dw_print
this.Control[iCurrent+5]=this.cbx_2
this.Control[iCurrent+6]=this.dw_imhist_in
this.Control[iCurrent+7]=this.dw_3
this.Control[iCurrent+8]=this.rr_1
this.Control[iCurrent+9]=this.dw_2
this.Control[iCurrent+10]=this.rr_2
end on

on w_pdt_03900.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_imhist)
destroy(this.cbx_1)
destroy(this.dw_print)
destroy(this.cbx_2)
destroy(this.dw_imhist_in)
destroy(this.dw_3)
destroy(this.rr_1)
destroy(this.dw_2)
destroy(this.rr_2)
end on

event open;call super::open;// datawindow initial value
dw_1.settransobject(sqlca)
dw_2.settransobject(sqlca)
dw_insert.settransobject(sqlca)
dw_imhist.settransobject(sqlca)
dw_imhist_in.settransobject(sqlca)
dw_print.settransobject(sqlca)

//dw_imhist.settransobject(sqlca)
is_Date = f_Today()

dw_1.insertrow(0)
dw_1.SetItem(1, "edate", is_Date)
end event

type dw_insert from w_inherite`dw_insert within w_pdt_03900
boolean visible = false
integer x = 50
integer y = 460
integer width = 4549
integer height = 1844
integer taborder = 0
string dataobject = "d_pdt_03900_4"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event dw_insert::doubleclicked;call super::doubleclicked;selectrow(0, false)
if row > 0 then
	selectrow(row, true)
end if
end event

type p_delrow from w_inherite`p_delrow within w_pdt_03900
boolean visible = false
integer x = 4069
integer y = 3268
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_pdt_03900
boolean visible = false
integer x = 3895
integer y = 3268
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_pdt_03900
boolean visible = false
integer x = 3200
integer y = 3268
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_pdt_03900
boolean visible = false
integer x = 3721
integer y = 3268
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_pdt_03900
integer taborder = 60
end type

type p_can from w_inherite`p_can within w_pdt_03900
integer taborder = 50
end type

event p_can::clicked;call super::clicked;dw_imhist.reset()
dw_3.visible = false
dw_insert.visible = false

p_mod.enabled = False
p_mod.PictureName = 'c:\erpman\image\저장_d.gif'

dw_2.visible = true
dw_1.visible = true
dw_1.setfocus()
end event

type p_print from w_inherite`p_print within w_pdt_03900
boolean visible = false
integer x = 3374
integer y = 3268
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_pdt_03900
integer x = 3922
integer taborder = 20
end type

event p_inq::clicked;call super::clicked;string sedate, spdtgu, shouse, sittyp, sempno, sitcls, sitnbr, sitdsc, sispec, sjijil, sispec_code

if dw_1.accepttext() = -1 then return

sedate = dw_1.getitemstring(1, "edate")
spdtgu = dw_1.getitemstring(1, "pdtgu")
shouse = dw_1.getitemstring(1, "house")
sittyp = dw_1.getitemstring(1, "ittyp")
sempno = dw_1.getitemstring(1, "empno")
sitcls = dw_1.getitemstring(1, "project")
sitnbr = dw_1.getitemstring(1, "itnbr")
sitdsc = dw_1.getitemstring(1, "itdsc")
sispec = dw_1.getitemstring(1, "ispec")
sjijil = dw_1.getitemstring(1, "jijil")
sispec_code = dw_1.getitemstring(1, "ispec_code")

if isnull(sedate) or trim(sedate) = '' or f_datechk(sedate) = -1 then
	Messagebox("출고일자", "출고일자는 필수입니다", stopsign!)
	dw_1.setfocus()
	return
end if

if isnull(shouse) or trim(shouse) = '' then
	Messagebox("출고창고", "출고창고는 필수입니다", stopsign!)
	dw_1.setfocus()
	return
end if

if isnull(sempno) or trim(sempno) = '' then
	Messagebox("출고담당", "출고담당자는 필수입니다", stopsign!)
	dw_1.setfocus()
	return
end if

if isnull(spdtgu) or trim(spdtgu) = '' then
	Messagebox("생산팀", "생산팀은 필수입니다", stopsign!)
	dw_1.setfocus()
	return
end if

if isnull(spdtgu) or trim(spdtgu) = '' then 
	spdtgu = '%'
end if

if isnull(sittyp) or trim(sittyp) = '' then 
	sittyp = '%'
end if

if isnull(sitcls) or trim(sitcls) = '' then 
	sitcls = '%'
else
	sitcls = sitcls + '%'
end if

if isnull(sitnbr) or trim(sitnbr) = '' then 
	sitnbr = '%'
else
	sitnbr = sitnbr + '%'
end if

if isnull(sitdsc) or trim(sitdsc) = '' then 
	sitdsc = '%'
else
	sitdsc = '%' + sitdsc + '%'
end if

if isnull(sispec) or trim(sispec) = '' then 
	sispec = '%'
else
	sispec = '%' + sispec + '%'
end if

if isnull(sjijil) or trim(sjijil) = '' then 
	sjijil = '%'
else
	sjijil = '%' + sjijil + '%'
end if

if isnull(sispec_code) or trim(sispec_code) = '' then 
	sispec_code = '%'
else
	sispec_code = '%' + sispec_code + '%'
end if

if dw_2.retrieve(gs_sabu, sedate, spdtgu, sittyp, sitcls, sitnbr, sitdsc, sispec, sjijil, sispec_code) < 1 then
	Messagebox("조회", "조회한 자료가 없읍니다", stopsign!)
	dw_1.setfocus()
	return
end if

p_mod.enabled = true
p_mod.PictureName = 'c:\erpman\image\저장_up.gif'
end event

type p_del from w_inherite`p_del within w_pdt_03900
boolean visible = false
integer x = 4416
integer y = 3268
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_pdt_03900
integer x = 4096
integer taborder = 40
boolean enabled = false
string picturename = "C:\erpman\image\저장_d.gif"
end type

event p_mod::clicked;call super::clicked;SetPointer(HourGlass!)

IF dw_insert.RowCount() < 1			THEN 	RETURN 

string	sDate, sarg_sdate, shold_no, sBuwan, sOld_buwan
sdate  = trim(dw_1.GetItemstring(1, "Edate"))			

//////////////////////////////////////////////////////////////////////////////////
//		
//		1. 수량 = 0		-> RETURN
//		2. 입출고HISTORY : 전표채번구분('C0')
//
//////////////////////////////////////////////////////////////////////////////////
dec	dSeq
long	  lcount, k

IF Messagebox('완료저장','완료저장 하시겠습니까?',Question!,YesNo!,1) <> 1 THEN Return

lcount = dw_insert.rowcount()

FOR k = 1 TO lcount 
	sHold_no   = dw_insert.GetItemString(k, "hold_no")
	sBuwan     = dw_insert.GetItemString(k, "buwan")
	sold_Buwan = dw_insert.GetItemString(k, "old_buwan")
	
	if isnull(sOld_buwan) then sOld_buwan = 'N'
	if isnull(sbuwan) then sbuwan = 'N'
	IF sBuwan <> sOld_buwan THEN 
		UPDATE "HOLDSTOCK"  
			SET "BUWAN" = :sBuwan  
		 WHERE ( "HOLDSTOCK"."SABU" = :gs_sabu ) AND  
				 ( "HOLDSTOCK"."HOLD_NO" = :shold_no )   ;

		if sqlca.sqlcode < 0 or sqlca.sqlnrows < 1 then 
			messagebox("확 인", "할당자료 저장을 실패하였습니다.")
			rollback; 
		end if	
	END IF		
NEXT

COMMIT;

IF f_msg_update() = -1 	THEN	RETURN

/////////////////////////////////////////////////////////////////////////
//	1. 등록시 전표번호 생성
/////////////////////////////////////////////////////////////////////////

if wf_imhist_create(sarg_sdate) = -1 then return
	
if cbx_1.checked then 
	dw_print.setfilter("ioseq <> '999'")
	dw_print.filter()	
	dw_print.retrieve(gs_sabu, sArg_sDate, sArg_sDate)
	dw_print.print()
end if      										 

////////////////////////////////////////////////////////////////////////

p_can.TriggerEvent("clicked")	

SetPointer(Arrow!)


end event

type cb_exit from w_inherite`cb_exit within w_pdt_03900
integer x = 4155
integer y = 3132
end type

type cb_mod from w_inherite`cb_mod within w_pdt_03900
integer x = 3406
integer y = 3132
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within w_pdt_03900
integer x = 78
integer y = 3272
end type

type cb_del from w_inherite`cb_del within w_pdt_03900
integer x = 439
integer y = 3276
end type

type cb_inq from w_inherite`cb_inq within w_pdt_03900
integer x = 3054
integer y = 3132
end type

type cb_print from w_inherite`cb_print within w_pdt_03900
integer x = 791
integer y = 3272
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_pdt_03900
end type

type cb_can from w_inherite`cb_can within w_pdt_03900
integer x = 3781
integer y = 3132
end type

type cb_search from w_inherite`cb_search within w_pdt_03900
integer x = 1138
integer y = 3276
end type







type gb_button1 from w_inherite`gb_button1 within w_pdt_03900
end type

type gb_button2 from w_inherite`gb_button2 within w_pdt_03900
end type

type dw_1 from u_key_enter within w_pdt_03900
event ue_key pbm_dwnkey
integer x = 32
integer y = 28
integer width = 3776
integer height = 420
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pdt_03900_1"
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event ue_key;
IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;call super::itemchanged;string	sDate, sConfirm,		&
			sDept, sDeptName, 	&
			sHouse,					&
			sEmpno,sEmpname,		&
			sHist_jpno,	&
			sProject,				&
			sNull, scode, sname, sname2, spass, sbalgu, s_itt, get_nm
int      ireturn 			


SetNull(sNull)

/////////////////////////////////////////////////////////////////////////////
IF this.GetColumnName() = 'edate' THEN

	sDate = trim(this.gettext())
	
	if isnull(sDate) or sDate = '' then return 
	
	IF f_datechk(sDate) = -1	then
		f_message_chk(35,'[출고일자]')
		this.setitem(1, "edate", sNull)
		return 1
	END IF
	
ELSEIF this.GetColumnName() = 'house' THEN
	sHouse = this.gettext()
	
	SELECT DAJIGUN
	  INTO :sPass
	  FROM VNDMST
	 WHERE CVCOD = :sHouse AND 
	 		 CVGU = '5'		  AND
			 CVSTATUS = '0' ;
	 
	if sqlca.sqlcode <> 0 	then
		f_message_chk(33,'[출고창고]')
		this.setitem(1, "house", sNull)
		this.setitem(1, "empno", sNull)
		this.setitem(1, "name", sNull)
		return 1
	end if

	IF not (sPass ="" OR IsNull(sPass)) THEN
		OpenWithParm(W_PGM_PASS,spass)
		
		IF Message.StringParm = "CANCEL" THEN 
			this.setitem(1, "house", sNull)
			this.setitem(1, "empno", sNull)
			this.setitem(1, "name", sNull)
			return 1
      END IF		
	END IF

	this.setitem(1, "empno", sNull)
	this.setitem(1, "name", sNull)
	
ELSEIF this.GetColumnName() = "empno" THEN

	scode = this.GetText()								
	
   if scode = '' 	or isnull(scode) then 
		this.setitem(1, 'name', sname)
      return 
   end if
   this.accepttext()
	
	sname2 = this.getitemstring(1, 'house')
	
	if sname2 = '' or isnull(sname2) then 
	   messagebox("확 인", "창고를 먼저 입력하세요")
		this.setitem(1, "empno", sNull)
		this.setitem(1, "name", sNull)
		return 1
	end if
	
   ireturn = f_get_name2('출고승인자', 'Y', scode, sname, sname2)    //1이면 실패, 0이 성공	

	this.setitem(1, 'empno', scode)
	this.setitem(1, 'name', sname)
   return ireturn 
ELSEIF this.GetColumnName() = 'project' THEN
	sname = this.gettext()
   s_itt  = this.getitemstring(1, 'ittyp')
   IF sname = "" OR IsNull(sname) THEN 	
		This.setitem(1, 'deptname', snull)
		RETURN 
	END IF
	
  SELECT "ITNCT"."TITNM"  
    INTO :get_nm  
    FROM "ITNCT"  
   WHERE ( "ITNCT"."ITTYP" = :s_itt ) AND  
         ( "ITNCT"."ITCLS" = :sname ) AND  
         ( "ITNCT"."LMSGU" <> 'L' )   ;

	IF SQLCA.SQLCODE <> 0 THEN
		this.TriggerEvent(rbuttondown!)
		if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then 
			This.setitem(1, 'project', snull)
			This.setitem(1, 'deptname', snull)
			RETURN 1
      else
			this.SetItem(1,"project",lstr_sitnct.s_ittyp)
			this.SetItem(1,"deptname", lstr_sitnct.s_titnm)
         Return 1			
      end if
   ELSE
		This.setitem(1, 'deptname', get_nm)
   END IF	
END IF

end event

event itemerror;call super::itemerror;RETURN 1
end event

event rbuttondown;call super::rbuttondown;string  shouse, spass, sgubun, sname, snull

gs_code = ''
gs_codename = ''
gs_gubun = ''

SetNull(sNull)

// 출고승인담당자
IF this.GetColumnName() = 'empno'	THEN
	this.accepttext() 
   gs_gubun = '4' 
	gs_code = this.getitemstring(1, 'house')
	shouse  = gs_code

	Open(w_depot_emp_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

   If isnull(shouse) or shouse = '' or shouse <> gs_gubun then 
		SELECT DAJIGUN
		  INTO :sPass
		  FROM VNDMST
		 WHERE CVCOD = :gs_gubun AND 
				 CVGU = '5'		  AND
				 CVSTATUS = '0' ;
		 
		if sqlca.sqlcode <> 0 	then
			f_message_chk(33,'[출고창고]')
			return 
		end if
	
		IF not (sPass ="" OR IsNull(sPass)) THEN
			OpenWithParm(W_PGM_PASS,spass)
			IF Message.StringParm = "CANCEL" THEN 
				return 
			END IF		
		END IF
   End if
	
	SetItem(1,"house",gs_gubun)
	SetItem(1,"empno",gs_code)
	SetItem(1,"name",gs_codename)
elseif this.GetColumnName() = 'project' then
   this.accepttext()
	sname = this.GetItemString(1, 'ittyp')
	OpenWithParm(w_ittyp_popup, sname)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_sumgub) or lstr_sitnct.s_sumgub = "" then 
		this.SetItem(1,"project",snull)  
		this.SetItem(1,"deptname", snull)		
		return 
	end if
	
	this.SetItem(1,"project",lstr_sitnct.s_sumgub)  
	this.SetItem(1,"deptname", lstr_sitnct.s_titnm)
	this.SetColumn('project')
	this.SetFocus()
	RETURN 1	
ElseIF this.GetcolumnName() ="itnbr" THEN
	Open(w_itemas_popup)
	this.SetItem(1,"itnbr",gs_code)
ELSEIF this.GetColumnName() = "itdsc"	THEN
	open(w_itemas_popup)
	this.SetItem(1,"itnbr",gs_code)
ELSEIF this.GetColumnName() = "ispec"	THEN
	Open(w_itemas_popup)
	this.SetItem(1,"itnbr",gs_code)
ELSEIF this.GetColumnName() = "jijil"	THEN
	Open(w_itemas_popup)
	this.SetItem(1,"itnbr",gs_code)	
end if

end event

type dw_imhist from datawindow within w_pdt_03900
boolean visible = false
integer x = 18
integer y = 3128
integer width = 411
integer height = 120
boolean bringtotop = true
string title = "none"
string dataobject = "d_pdt_imhist"
boolean border = false
boolean livescroll = true
end type

type cbx_1 from checkbox within w_pdt_03900
integer x = 3945
integer y = 224
integer width = 654
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "출고증 자동출력 여부"
end type

type dw_print from datawindow within w_pdt_03900
boolean visible = false
integer x = 443
integer y = 3128
integer width = 411
integer height = 120
boolean bringtotop = true
string title = "none"
string dataobject = "d_mat_03550_03"
boolean border = false
boolean livescroll = true
end type

type cbx_2 from checkbox within w_pdt_03900
integer x = 3945
integer y = 300
integer width = 654
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "부품출고완료 제외"
end type

type dw_imhist_in from datawindow within w_pdt_03900
boolean visible = false
integer x = 864
integer y = 3128
integer width = 411
integer height = 120
boolean bringtotop = true
string title = "none"
string dataobject = "d_pdt_imhist"
boolean border = false
boolean livescroll = true
end type

type dw_3 from datawindow within w_pdt_03900
boolean visible = false
integer x = 32
integer y = 28
integer width = 3776
integer height = 420
integer taborder = 70
string title = "none"
string dataobject = "d_pdt_03900_3"
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_pdt_03900
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 448
integer width = 4576
integer height = 1860
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_2 from u_d_select_sort within w_pdt_03900
integer x = 50
integer y = 456
integer width = 4549
integer height = 1844
integer taborder = 30
string dataobject = "d_pdt_03900_2"
boolean border = false
end type

event doubleclicked;call super::doubleclicked;decimal {2} doutjego, douthold, doutvalid, dhldjego, dhldhold, dhldvalid
String  sitnbr, sdepot_no, spdtgu, sholdno

if row > 0 then
   dw_3.reset()
	dw_insert.reset()
	dw_3.insertrow(0)
	dw_3.setitem(1, "itnbr", 		getitemstring(row, "itnbr"))
	dw_3.setitem(1, "itdsc", 		getitemstring(row, "itdsc"))
	dw_3.setitem(1, "ispec", 		getitemstring(row, "ispec"))
	dw_3.setitem(1, "jijil", 		getitemstring(row, "jijil"))
	dw_3.setitem(1, "ispec_code", getitemstring(row, "ispec_code"))
	
	dw_3.visible = true
	dw_insert.visible = true
	dw_2.visible = false
	dw_1.visible = false
	
	// 출고창고	재고
	sdepot_no = dw_1.getitemstring(1, "house")
	sitnbr    = getitemstring(row, "itnbr")
	Select sum(jego_qty), sum(hold_qty), sum(valid_qty) into :doutjego, :douthold, :doutvalid
	  From stock
	 Where depot_no = :sdepot_no and itnbr = :sitnbr;
	dw_3.setitem(1, "outjego",  doutjego)
	dw_3.setitem(1, "outhold",  douthold)
	dw_3.setitem(1, "outvalid", doutvalid)
	
	// 생산창고	재고
	sholdno = ''
	spdtgu = dw_1.getitemstring(1, "pdtgu")
	select cvcod into :sholdno from vndmst where jumaeip = :spdtgu;
	Select sum
	(jego_qty), sum(hold_qty), sum(valid_qty) into :dhldjego, :dhldhold, :dhldvalid
	  From stock
	 Where depot_no = :sholdno and itnbr = :sitnbr;
	dw_3.setitem(1, "hldjego",  dhldjego)
	dw_3.setitem(1, "hldhold",  dhldhold)
	dw_3.setitem(1, "hldvalid", dhldvalid)	
	
	if cbx_2.checked then
		dw_insert.setfilter("buwan = 'N'")
		dw_insert.filter()
	Else
		dw_insert.setfilter("")
		dw_insert.filter()
	end if
	
	dw_insert.retrieve(gs_sabu, sitnbr, sdepot_no)
	dw_insert.setfocus()
end if
end event

type rr_2 from roundrectangle within w_pdt_03900
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 3909
integer y = 192
integer width = 713
integer height = 196
integer cornerheight = 40
integer cornerwidth = 55
end type

