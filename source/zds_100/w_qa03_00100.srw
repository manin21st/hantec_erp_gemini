$PBExportHeader$w_qa03_00100.srw
$PBExportComments$** CLAIM접수 DDS
forward
global type w_qa03_00100 from w_inherite
end type
type dw_1 from u_key_enter within w_qa03_00100
end type
type p_1 from uo_picture within w_qa03_00100
end type
type p_2 from uo_picture within w_qa03_00100
end type
type p_3 from picture within w_qa03_00100
end type
type shl_1 from statichyperlink within w_qa03_00100
end type
type st_2 from statictext within w_qa03_00100
end type
type rr_1 from roundrectangle within w_qa03_00100
end type
end forward

global type w_qa03_00100 from w_inherite
integer height = 2500
string title = "CLAIM 접수"
windowstate windowstate = maximized!
dw_1 dw_1
p_1 p_1
p_2 p_2
p_3 p_3
shl_1 shl_1
st_2 st_2
rr_1 rr_1
end type
global w_qa03_00100 w_qa03_00100

type prototypes


end prototypes

type variables
String is_sort
uo_xlobject uo_xl
string is_cvcod, is_yymm

end variables

forward prototypes
public function integer wf_required_chk ()
public function integer wf_set_kia ()
public function integer wf_set_mobis ()
public function integer wf_set_gmdat ()
public function integer wf_set_ilban ()
public function integer wf_set_cvcod (string arg_gbn)
end prototypes

public function integer wf_required_chk ();////필수입력항목 체크
//Long i, j
//Real qty
//String sdate, jpno
//
//sdate = f_today() //시스템일자
//jpno = String(SQLCA.FUN_JUNPYO(gs_sabu, sdate, 'E0'), "0000") //문서번호
//
////LOT No가 Null이고 QTY가 Null이면 삭제 
//for i = dw_lot.RowCount() to 1 step -1 
//	if (IsNull(Trim(dw_lot.object.cl_lotno[i])) or Trim(dw_lot.object.cl_lotno[i]) = "") and &
//	   IsNull(dw_lot.object.cl_qty[i]) then
//		dw_lot.DeleteRow(i)
//	end if
//next
//
//for i = 1 to dw_lot.RowCount() 
//	dw_lot.object.sabu[i] = gs_saupj
//	if rb_new.checked = True then  //문서번호
//	   dw_lot.object.cl_jpno[i] = sdate + jpno
//	else
//		dw_lot.object.cl_jpno[i] = Trim(dw_insert.object.cl_jpno[1])
//	end if	
//	dw_lot.object.cl_seq[i] = i
//	if IsNull(Trim(dw_lot.object.cl_lotno[i])) or Trim(dw_lot.object.cl_lotno[i]) = "" then
//		 dw_lot.object.cl_lotno[i] = "Unknown"
//	end if
//
//	if dw_lot.object.cl_lotno[i] < '.' or dw_lot.object.cl_lotno[i] > 'zzzzzz' then
//    	MessageBox("LOT No 범위 확인","LOT No는 문자나 숫자를 입력하세요!")
//		dw_lot.ScrollToRow(i) 
//	   dw_lot.SetColumn('cl_lotno')
//	   dw_lot.SetFocus()
//	   return -1
//	end if	
//	
//	if IsNull(dw_lot.object.cl_qty[i]) or dw_lot.object.cl_qty[i] <= 0 then
//    	MessageBox("LOT No 확인(1)","LOT No는 적어도 하나 이상이 입력되어야 합니다")
//		dw_lot.ScrollToRow(i) 
//	   dw_lot.SetColumn('cl_qty')
//	   dw_lot.SetFocus()
//	   return -1
//	end if	
//next
//
//dw_insert.object.sabu[1] = gs_saupj //사업장구분
//
//if rb_new.checked = True then  //문서번호
//	dw_insert.object.cl_jpno[1] = sdate + jpno
//end if	
//
//if Isnull(Trim(dw_insert.object.cl_jpno[1])) or Trim(dw_insert.object.cl_jpno[1]) = "" then
//  	f_message_chk(1400,'[문서번호]')
//	dw_insert.SetColumn('cl_jpno')
//	dw_insert.SetFocus()
//	return -1
//elseif Isnull(Trim(dw_insert.object.daecod[1])) or Trim(dw_insert.object.daecod[1]) = "" then
//  	f_message_chk(1400,'[거래처(판매처)]')
//	dw_insert.SetColumn('daecod')
//	dw_insert.SetFocus()
//	return -1
//elseif Isnull(Trim(dw_insert.object.cust_no[1])) or Trim(dw_insert.object.cust_no[1]) = "" then
//  	f_message_chk(1400,'[고객번호]')
//	dw_insert.SetColumn('cust_no')
//	dw_insert.SetFocus()
//	return -1
//elseif Isnull(Trim(dw_insert.object.snddtp[1])) or Trim(dw_insert.object.snddtp[1]) = "" then
//  	f_message_chk(1400,'[접수부서]')
//	dw_insert.SetColumn('snddtp')
//	dw_insert.SetFocus()
//	return -1
//elseif Isnull(Trim(dw_insert.object.sndemp[1])) or Trim(dw_insert.object.sndemp[1]) = "" then
//  	f_message_chk(1400,'[접수담당자]')
//	dw_insert.SetColumn('sndemp')
//	dw_insert.SetFocus()
//	return -1
//elseif Isnull(Trim(dw_insert.object.clrdat[1])) or Trim(dw_insert.object.clrdat[1]) = "" then
//  	f_message_chk(1400,'[접수일자]')
//	dw_insert.SetColumn('clrdat')
//	dw_insert.SetFocus()
//	return -1
//elseif Isnull(Trim(dw_insert.object.qcrdat[1])) or Trim(dw_insert.object.qcrdat[1]) = "" then
//  	f_message_chk(1400,'[발송일자]')
//	dw_insert.SetColumn('qcrdat')
//	dw_insert.SetFocus()
//	return -1
//elseif Isnull(Trim(dw_insert.object.itnbr[1])) or Trim(dw_insert.object.itnbr[1]) = "" then
//  	f_message_chk(1400,'[품번]')
//	dw_insert.SetColumn('itnbr')
//	dw_insert.SetFocus()
//	return -1
//elseif Isnull(dw_insert.object.clqty[1]) or dw_insert.object.clqty[1] <= 0 then
//  	f_message_chk(1400,'[수량]')
//	dw_insert.SetColumn('clqty')
//	dw_insert.SetFocus()
//	return -1
//end if	
//
return 1
end function

public function integer wf_set_kia ();long i, irow
string ls_pathname, ls_input, ls_filename
string ls_temp
int li_filenum

string ls_ctype, ls_clcod

delete from clamst_kia where yymm = :is_yymm and cvcod = :is_cvcod ;

i=0
If GetFileOpenName('Select Upload File', ls_pathname, ls_filename, 'TXT', 'Data Files (*.TXT),*.TXT') <> 1 Then Return -1

li_filenum = FileOpen( ls_pathname, LineMode!  )

Do While( FileRead( li_filenum, ls_input) > 0 )

	
	ls_clcod	=	trim(f_Get_Token(ls_input,'~t'))
	ls_ctype =  trim(f_Get_Token(ls_input,'~t'))
	
	if not isnumber(left(ls_clcod,6)) then continue
	if isnumber(ls_ctype) then continue	
	
	i++	
	irow = dw_insert.insertrow(0)
	dw_insert.setitem( irow, 'yymm', 		is_yymm)
	dw_insert.setitem( irow, 'cvcod', 		is_cvcod)	
	dw_insert.setitem( irow, 'no', 			string(i,'0000'))
	dw_insert.setitem( irow, 'cl_jpno', 	ls_clcod)
	dw_insert.setitem( irow, 'c_type', 		ls_ctype)
	dw_insert.setitem( irow, 'nation', 		trim(f_Get_Token(ls_input,'~t')) )	
	dw_insert.setitem( irow, 'carcode', 	trim(f_Get_Token(ls_input,'~t')) )
	dw_insert.setitem( irow, 'carname', 	trim(f_Get_Token(ls_input,'~t')) )
	dw_insert.setitem( irow, 'itnbr', 		trim(f_Get_Token(ls_input,'~t')) )
	dw_insert.setitem( irow, 'itdsc', 		trim(f_Get_Token(ls_input,'~t')) )
	dw_insert.setitem( irow, 'ro_no', 		trim(f_Get_Token(ls_input,'~t')) )
	dw_insert.setitem( irow, 'vin_no', 		trim(f_Get_Token(ls_input,'~t')) )
	dw_insert.setitem( irow, 'run_dist', 	dec(trim(f_Get_Token(ls_input,'~t'))) )
	dw_insert.setitem( irow, 'prod_dt', 	trim(f_Get_Token(ls_input,'~t')) )
	dw_insert.setitem( irow, 'bal_dt', 		trim(f_Get_Token(ls_input,'~t')) )
	dw_insert.setitem( irow, 'use_range', 	dec(trim(f_Get_Token(ls_input,'~t'))) )
	dw_insert.setitem( irow, 'c_cod', 		trim(f_Get_Token(ls_input,'~t')) )
	dw_insert.setitem( irow, 'n_cod', 		trim(f_Get_Token(ls_input,'~t')) )
	dw_insert.setitem( irow, 'vbp_amt', 	dec(trim(f_Get_Token(ls_input,'~t'))) )
	dw_insert.setitem( irow, 'vgi_amt', 	dec(trim(f_Get_Token(ls_input,'~t'))) )
	dw_insert.setitem( irow, 'vwj_amt', 	dec(trim(f_Get_Token(ls_input,'~t'))) )
	dw_insert.setitem( irow, 'vtt_amt', 	dec(trim(f_Get_Token(ls_input,'~t'))) )
	dw_insert.setitem( irow, 'bupum_amt', 	dec(trim(f_Get_Token(ls_input,'~t'))) )
	dw_insert.setitem( irow, 'gongim_amt', dec(trim(f_Get_Token(ls_input,'~t'))) )
	dw_insert.setitem( irow, 'wai_amt', 	dec(trim(f_Get_Token(ls_input,'~t'))) )
	dw_insert.setitem( irow, 'tot_amt', 	dec(trim(f_Get_Token(ls_input,'~t'))) )
	
Loop
FileClose( li_filenum )


return 1
end function

public function integer wf_set_mobis ();long i, irow
string ls_pathname, ls_input, ls_filename
string ls_temp
int li_filenum


string ls_ctype, ls_clcod


delete from clamst_mobis where yymm = :is_yymm and cvcod = :is_cvcod ;



i=0
If GetFileOpenName('Select Upload File', ls_pathname, ls_filename, 'TXT', 'Data Files (*.TXT),*.TXT') <> 1 Then Return -1

li_filenum = FileOpen( ls_pathname, LineMode!  )

Do While( FileRead( li_filenum, ls_input) > 0 )

	
	ls_clcod	=	trim(f_Get_Token(ls_input,'~t'))
	ls_ctype =  trim(f_Get_Token(ls_input,'~t'))
	
	if not isnumber(left(ls_clcod,6)) then continue
	if isnumber(ls_ctype) then continue	
	
	i++	
	irow = dw_insert.insertrow(0)
	dw_insert.setitem( irow, 'yymm', 		is_yymm)
	dw_insert.setitem( irow, 'cvcod', 		is_cvcod)	
	dw_insert.setitem( irow, 'no', 			string(i,'0000'))
	dw_insert.setitem( irow, 'cl_jpno', 	ls_clcod)
	dw_insert.setitem( irow, 'c_type', 		ls_ctype)
	dw_insert.setitem( irow, 'carcode', 		trim(f_Get_Token(ls_input,'~t')) )	
	dw_insert.setitem( irow, 'exchg_itnbr', 	trim(f_Get_Token(ls_input,'~t')) )	
	dw_insert.setitem( irow, 'itnbr', 			trim(f_Get_Token(ls_input,'~t')) )	
	dw_insert.setitem( irow, 'itdsc', 			trim(f_Get_Token(ls_input,'~t')) )	
	dw_insert.setitem( irow, 'gh_no', 			trim(f_Get_Token(ls_input,'~t')) )	
	dw_insert.setitem( irow, 'cd_no', 			trim(f_Get_Token(ls_input,'~t')) )
	dw_insert.setitem( irow, 'c_cod', 			trim(f_Get_Token(ls_input,'~t')) )	
	dw_insert.setitem( irow, 'n_cod', 			trim(f_Get_Token(ls_input,'~t')) )	
	
	dw_insert.setitem( irow, 'prod_dt', 		trim(f_Get_Token(ls_input,'~t')) )
	dw_insert.setitem( irow, 'sale_dt', 		trim(f_Get_Token(ls_input,'~t')) )
	
	dw_insert.setitem( irow, 'suri_dt2', 		trim(f_Get_Token(ls_input,'~t')) )
	dw_insert.setitem( irow, 'run_dist2', 		trim(f_Get_Token(ls_input,'~t')) )
	dw_insert.setitem( irow, 'share_rate', 	dec(trim(f_Get_Token(ls_input,'~t'))) )
	dw_insert.setitem( irow, 'bupum_amt', 		dec(trim(f_Get_Token(ls_input,'~t'))) )
	dw_insert.setitem( irow, 'gongim_amt', 	dec(trim(f_Get_Token(ls_input,'~t'))) )
	dw_insert.setitem( irow, 'etc_amt', 		dec(trim(f_Get_Token(ls_input,'~t'))) )
	dw_insert.setitem( irow, 'tot_amt', 		dec(trim(f_Get_Token(ls_input,'~t'))) )
	dw_insert.setitem( irow, 'req_amt', 		dec(trim(f_Get_Token(ls_input,'~t'))) )

	
Loop
FileClose( li_filenum )


return 1
end function

public function integer wf_set_gmdat ();long i, irow
string ls_pathname, ls_input, ls_filename
string ls_temp, s_gubun
int li_filenum
string ls_ctype, ls_clcod

If dw_1.AcceptText() <> 1 Then return -1

// 접수구분
s_gubun = dw_1.GetItemstring(1, 'gubun')

Choose Case s_gubun
	Case '1'
		delete from dsmc_field where yymm = :is_yymm and cvcod = :is_cvcod;
	Case '2'
		delete from dsmc_returns where yymm = :is_yymm and cvcod = :is_cvcod;
	Case '3'
		delete from dsmc_rewrok where yymm = :is_yymm and cvcod = :is_cvcod;
	Case Else
		Return -1
End Choose

i=0
If GetFileOpenName('Select Upload File', ls_pathname, ls_filename, 'TXT', 'Data Files (*.TXT),*.TXT') <> 1 Then Return -1

li_filenum = FileOpen( ls_pathname, LineMode!  )

i=0
Do While( FileRead( li_filenum, ls_input) > 0 )	
	
	if i= 0 then
		i++
		continue;
	end if
	
	i++
	irow = dw_insert.insertrow(0)
		
	dw_insert.setitem( irow, 'yymm', 		is_yymm)
	dw_insert.setitem( irow, 'cvcod', 		is_cvcod)	
	dw_insert.setitem( irow, 'no', 			string(i,'0000'))

	Choose Case s_gubun
		Case '1'	// Field Claim
			dw_insert.setitem( irow, 'vndcod',	 	trim(f_Get_Token(ls_input,'~t')) )
			dw_insert.setitem( irow, 'sitecod', 	trim(f_Get_Token(ls_input,'~t')) )
			dw_insert.setitem( irow, 'sitegub', 	trim(f_Get_Token(ls_input,'~t')) )
			dw_insert.setitem( irow, 'itnbr', 		trim(f_Get_Token(ls_input,'~t')) )
			dw_insert.setitem( irow, 'itdsc', 		trim(f_Get_Token(ls_input,'~t')) )
			dw_insert.setitem( irow, 'clqty',	 	dec(trim(f_Get_Token(ls_input,'~t'))) )
			dw_insert.setitem( irow, 'clamt',	 	dec(trim(f_Get_Token(ls_input,'~t'))) )
			dw_insert.setitem( irow, 'boamt',	 	dec(trim(f_Get_Token(ls_input,'~t'))) )
			dw_insert.setitem( irow, 'cnamt',	 	dec(trim(f_Get_Token(ls_input,'~t'))) )
		Case '2'	// 공정반송
			dw_insert.setitem( irow, 'vndcod',	 	trim(f_Get_Token(ls_input,'~t')) )
			dw_insert.setitem( irow, 'plnt',	 		trim(f_Get_Token(ls_input,'~t')) )
			dw_insert.setitem( irow, 'itnbr', 		trim(f_Get_Token(ls_input,'~t')) )
			dw_insert.setitem( irow, 'itdsc', 		trim(f_Get_Token(ls_input,'~t')) )
			dw_insert.setitem( irow, 'carcode',		trim(f_Get_Token(ls_input,'~t')) )
			dw_insert.setitem( irow, 'gate',	 		trim(f_Get_Token(ls_input,'~t')) )
			dw_insert.setitem( irow, 'cljpno', 		trim(f_Get_Token(ls_input,'~t')) )
			dw_insert.setitem( irow, 'cldate', 		trim(f_Get_Token(ls_input,'~t')) )
			dw_insert.setitem( irow, 'clqty',	 	dec(trim(f_Get_Token(ls_input,'~t'))) )
			dw_insert.setitem( irow, 'bulcod', 		trim(f_Get_Token(ls_input,'~t')) )
			dw_insert.setitem( irow, 'gongprc',	 	dec(trim(f_Get_Token(ls_input,'~t'))) )
			dw_insert.setitem( irow, 'gongamt',	 	dec(trim(f_Get_Token(ls_input,'~t'))) )
			dw_insert.setitem( irow, 'wanqty',	 	dec(trim(f_Get_Token(ls_input,'~t'))) )
		Case '3'	// rework
			dw_insert.setitem( irow, 'carcode',		trim(f_Get_Token(ls_input,'~t')) )
			ls_temp = trim(f_Get_Token(ls_input,'~t'))
			ls_temp = Left(ls_temp,4)+Mid(ls_temp,6,2)+right(ls_temp,2)
			
			dw_insert.setitem( irow, 'cldate', 		ls_temp )
			dw_insert.setitem( irow, 'bul_pos',		trim(f_Get_Token(ls_input,'~t')) )
			dw_insert.setitem( irow, 'bul_type', 	trim(f_Get_Token(ls_input,'~t')) )
			dw_insert.setitem( irow, 'bul_cause',	trim(f_Get_Token(ls_input,'~t')) )
			dw_insert.setitem( irow, 'clqty',	 	dec(trim(f_Get_Token(ls_input,'~t'))) )
			dw_insert.setitem( irow, 'clmnhr',	 	dec(trim(f_Get_Token(ls_input,'~t'))) )
			dw_insert.setitem( irow, 'dptv',		 	dec(trim(f_Get_Token(ls_input,'~t'))) )
			dw_insert.setitem( irow, 'rhtv',		 	dec(trim(f_Get_Token(ls_input,'~t'))) )
			dw_insert.setitem( irow, 'sucod', 		trim(f_Get_Token(ls_input,'~t')) )
			dw_insert.setitem( irow, 'suemp', 		trim(f_Get_Token(ls_input,'~t')) )
			dw_insert.setitem( irow, 'gumqty',	 	dec(trim(f_Get_Token(ls_input,'~t'))) )
	End Choose
Loop
FileClose( li_filenum )


return 1
end function

public function integer wf_set_ilban ();long i, irow
string ls_pathname, ls_input, ls_filename
string ls_temp
int li_filenum


string ls_ctype, ls_clcod


delete from clamst_ilban where yymm = :is_yymm and cvcod = :is_cvcod ;



i=0
If GetFileOpenName('Select Upload File', ls_pathname, ls_filename, 'TXT', 'Data Files (*.TXT),*.TXT') <> 1 Then Return -1

li_filenum = FileOpen( ls_pathname, LineMode!  )

Do While( FileRead( li_filenum, ls_input) > 0 )

	
	ls_clcod	=	trim(f_Get_Token(ls_input,'~t'))
	ls_ctype =  trim(f_Get_Token(ls_input,'~t'))
	
	if not isnumber(left(ls_clcod,6)) then continue
	if isnumber(ls_ctype) then continue	
	
	i++	
	irow = dw_insert.insertrow(0)
	dw_insert.setitem( irow, 'yymm', 		is_yymm)
	dw_insert.setitem( irow, 'cvcod', 		is_cvcod)	
	dw_insert.setitem( irow, 'no', 			string(i,'0000'))
	dw_insert.setitem( irow, 'cl_jpno', 	ls_clcod)
	dw_insert.setitem( irow, 'c_type', 		ls_ctype)
	dw_insert.setitem( irow, 'carcode', 	trim(f_Get_Token(ls_input,'~t')) )	
	dw_insert.setitem( irow, 'itnbr', 		trim(f_Get_Token(ls_input,'~t')) )	
	dw_insert.setitem( irow, 'itdsc', 		trim(f_Get_Token(ls_input,'~t')) )	
	dw_insert.setitem( irow, 'c_cod', 		trim(f_Get_Token(ls_input,'~t')) )	
	dw_insert.setitem( irow, 'n_cod', 		trim(f_Get_Token(ls_input,'~t')) )	
	dw_insert.setitem( irow, 'prod_dt', 	trim(f_Get_Token(ls_input,'~t')) )	
	dw_insert.setitem( irow, 'run_dist', 	dec(trim(f_Get_Token(ls_input,'~t'))) )
	dw_insert.setitem( irow, 'bupum_amt', 	dec(trim(f_Get_Token(ls_input,'~t'))) )
	dw_insert.setitem( irow, 'gongim_amt', dec(trim(f_Get_Token(ls_input,'~t'))) )
	dw_insert.setitem( irow, 'etc_amt', 	dec(trim(f_Get_Token(ls_input,'~t'))) )
	dw_insert.setitem( irow, 'tot_amt', 	dec(trim(f_Get_Token(ls_input,'~t'))) )
	
Loop
FileClose( li_filenum )


return 1
end function

public function integer wf_set_cvcod (string arg_gbn);string ls_kia, ls_mobis, ls_gmdat, ls_ilban, s_cod, ls_cvnas


ls_kia	= '00511'
ls_mobis	= '00511'
ls_gmdat = '00511'
ls_ilban = ''

choose case upper(arg_gbn)
	case '1'
		dw_1.setitem(1,'cvcod', ls_kia)
	case '2'
		dw_1.setitem(1,'cvcod', ls_mobis)
	case '3'
		dw_1.setitem(1,'cvcod', ls_gmdat)
	case 'E'
		dw_1.setitem(1,'cvcod', ls_ilban)
end choose

s_cod = dw_1.object.cvcod[1]

Select cvnas 
  Into :ls_cvnas 
  From vndmst
  Where cvcod = :s_cod ;
	
If sqlca.sqlcode <> 0 Then
	dw_1.Object.cvnas[1] = ""
	Return -1
End If
dw_1.Object.cvnas[1] = ls_cvnas


return 1
end function

on w_qa03_00100.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.p_1=create p_1
this.p_2=create p_2
this.p_3=create p_3
this.shl_1=create shl_1
this.st_2=create st_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.p_1
this.Control[iCurrent+3]=this.p_2
this.Control[iCurrent+4]=this.p_3
this.Control[iCurrent+5]=this.shl_1
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.rr_1
end on

on w_qa03_00100.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.p_1)
destroy(this.p_2)
destroy(this.p_3)
destroy(this.shl_1)
destroy(this.st_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_1.SetTransObject(SQLCA)

dw_1.SetRedraw(False)
dw_1.Reset()
dw_1.InsertRow(0)

dw_1.Object.sdate[1] = left(is_today, 6)

dw_1.SetRedraw(True)

dw_insert.SetRedraw(False)
dw_insert.DataObject = 'd_qa03_00100_field'
dw_insert.SetTransObject(SQLCA)
dw_insert.Reset()
dw_insert.SetRedraw(True)

wf_set_cvcod('K')

dw_1.SetFocus()





end event

type dw_insert from w_inherite`dw_insert within w_qa03_00100
integer x = 37
integer y = 360
integer width = 4530
integer height = 1944
integer taborder = 40
string dataobject = "d_qa03_00100_field"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemerror;return 1
end event

event dw_insert::clicked;call super::clicked;String ls_sort

If row > 0 Then
	this.SelectRow(0,false)
	this.SelectRow(row,true)
Else
	this.SelectRow(0,false)
End If

If Right(dwo.Name, 2) = '_t' Then
	ls_sort = left(dwo.Name, Pos(dwo.Name, '_t') - 1) + ' A'
	If ls_sort <> is_sort Then
		is_sort = ls_sort
		SetSort(is_sort)
		Sort()
	End If
End If
end event

type p_delrow from w_inherite`p_delrow within w_qa03_00100
boolean visible = false
integer x = 3680
integer y = 3524
integer taborder = 0
string picturename = "C:\erpman\image\up.gif"
end type

type p_addrow from w_inherite`p_addrow within w_qa03_00100
boolean visible = false
integer x = 3502
integer y = 3520
integer taborder = 0
string picturename = "C:\erpman\image\up.gif"
end type

type p_search from w_inherite`p_search within w_qa03_00100
boolean visible = false
integer x = 3753
integer y = 3372
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_qa03_00100
boolean visible = false
integer x = 3904
integer taborder = 0
end type

event p_ins::clicked;call super::clicked;
dw_insert.InsertRow(dw_insert.Rowcount() + 1)

dw_insert.ScrollToRow(dw_insert.Rowcount() + 1)

dw_insert.SetFocus()
end event

type p_exit from w_inherite`p_exit within w_qa03_00100
integer x = 4402
integer taborder = 90
end type

type p_can from w_inherite`p_can within w_qa03_00100
integer x = 4229
integer taborder = 80
end type

event p_can::clicked;call super::clicked;dw_1.SetTransObject(SQLCA)

dw_1.SetRedraw(False)
dw_1.Reset()
dw_1.InsertRow(0)

dw_1.Object.sdate[1] = left(is_today, 6)

dw_1.SetRedraw(True)

dw_insert.SetRedraw(False)
dw_insert.DataObject = 'd_qa03_00100_field'
dw_insert.SetTransObject(SQLCA)
dw_insert.Reset()
dw_insert.SetRedraw(True)

wf_set_cvcod('K')

dw_1.SetFocus()
end event

type p_print from w_inherite`p_print within w_qa03_00100
boolean visible = false
integer x = 3927
integer y = 3372
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_qa03_00100
integer x = 3707
integer taborder = 20
end type

event p_inq::clicked;call super::clicked;String ls_vndgb , ls_balgb,ls_balgb1 ,ls_balgb2 
String ls_sdate , ls_fdate, ls_fcvcod, ls_tcvcod

if dw_1.accepttext() = -1 then return

ls_vndgb  = Trim(dw_1.Object.gubun[1])
ls_sdate  = Trim(dw_1.Object.sdate[1])
ls_fcvcod  = Trim(dw_1.Object.cvcod[1])


If isNull(ls_sdate) Or ls_sdate = '' Then 
  	f_message_chk(1400,'[접수년월]')
	dw_1.SetColumn('sdate')
	dw_1.SetFocus()
	return -1
end if	


if isnull(ls_fcvcod) or ls_fcvcod = '' then 
  	f_message_chk(1400,'[거래처]')
	dw_1.SetColumn('cvcod')
	dw_1.SetFocus()
	return -1
end if	

dw_insert.setredraw(false)

If dw_insert.Retrieve(ls_sdate, ls_fcvcod) > 0 then
	
else
   f_message_chk(50, '[Claim Import List]')
end if

dw_insert.setredraw(true)



end event

type p_del from w_inherite`p_del within w_qa03_00100
integer x = 4055
integer taborder = 70
end type

event p_del::clicked;call super::clicked;If dw_insert.AcceptText() < 1 Then Return
If dw_insert.RowCount() < 1 Then Return

Long i , ll_rcnt ,ii=0
String ls_new , ls_chk 
ll_rcnt = dw_insert.RowCount()

For i = ll_rcnt To  1 Step -1
	ls_chk  = Trim(dw_insert.Object.chk[i])
	ls_new  = Trim(dw_insert.Object.is_new[i])
	
	If ls_chk = 'Y' Then
		dw_insert.DeleteRow(i)
		ii++
		If ls_new = 'N' Then
			If dw_insert.Update() = 1 Then
				Commit;
			Else
				Rollback ;
				f_message_chk(31,'')
				Return
			End If
		End If
	End if
Next

If ii < 1 Then
	MessageBox('확인','삭제할 행을 선택하세요.')
	Return
End If

end event

type p_mod from w_inherite`p_mod within w_qa03_00100
integer x = 3881
integer taborder = 60
end type

event p_mod::clicked;call super::clicked;If dw_insert.AcceptText() = -1 Then Return 
If dw_insert.RowCount() < 1 Then Return
If f_msg_update() < 1 then Return

String ls_date , ls_jpno , ls_rono, ls_clcode, ls_no, ls_CL_JPno
Long i, ll_cnt, ll_seq
string ls_max_seq

//ls_date = f_today() //시스템일자
//
//ls_jpno = String(SQLCA.FUN_JUNPYO(gs_sabu, ls_date, 'E0'), "0000") //문서번호
//
//
//select to_number(substr(max(cl_jpno),-3)) into :ll_seq
//from CLAMST_DD
//where cl_jpno like :ls_date || '%';
//
//if isnull(ll_seq) or ll_seq < 0 THEN ll_seq = 0
//
//
//For i = 1 To dw_insert.RowCount()
//	ls_no = Trim(dw_insert.Object.no[i])
//	If ls_no = '' Or isNull(ls_no) Then
//		dw_insert.Object.no[i] = string(i)
//	End If	
//	ls_CL_JPno = Trim(dw_insert.Object.cl_jpno[i])	
//	
//	If ls_CL_JPno = '' Or isNull(ls_CL_JPno) Then	
//		ll_seq ++
//		dw_insert.Object.cl_jpno[i] = ls_date+ls_jpno+String(ll_seq,'000')
//	end if
//	
//	ls_clcode = Trim(dw_insert.Object.cl_code[i])
//	If ls_clcode = '' Or isNull(ls_clcode) Then
//		dw_insert.Object.cl_code[i] = dw_insert.object.cl_jpno[i]
//	End If
//	
//	ls_CL_JPno = Trim(dw_insert.Object.cl_jpno[i])
//	wf_save_gbn(ls_CL_JPno, i)
//Next

dw_insert.AcceptText()

IF dw_insert.Update()  = 1  THEN	
	COMMIT;
	
	w_mdi_frame.sle_msg.Text = "저장 되었습니다!"
	p_inq.TriggerEvent(Clicked!)
ELSE
	ROLLBACK;
	//messagebox('',sqlca.sqlerrText)
	f_message_chk(32, "[저장실패]")
	w_mdi_frame.sle_msg.Text = "저장작업 실패!"
END IF

ib_any_typing = False //입력필드 변경여부 No




//If dw_insert.AcceptText() = -1 Then Return 
//If dw_insert.RowCount() < 1 Then Return
//If f_msg_update() < 1 then Return
//
//String ls_date , ls_jpno , ls_rono
//Long i, ll_cnt
//
//ls_date = f_today() //시스템일자
//
//ls_jpno = String(SQLCA.FUN_JUNPYO(gs_sabu, ls_date, 'E0'), "0000") //문서번호
//
//For i = 1 To dw_insert.RowCount()
//	
//	ls_rono = Trim(dw_insert.Object.ro_no[i])
//	If ls_rono = '' Or isNull(ls_rono) Then
//		MessageBox('확인','RO No 가 없습니다.')
//		Return
//	End If
//	
//	Select Count(*) Into :ll_cnt
//	  From CLAMST_LW   
//	 Where SABU = :gs_saupj 
//	   AND RO_NO = :ls_rono ;
//	
//	If ll_cnt > 0 Then
//		MessageBox(String(i)+'행 확인','RO No : '+ls_rono+'~t~t~t'+&
//		                       '~n~r~n~r해당 클레임문서는 등록된 문서입니다. 확인 후 다시 시도하세요. ')
//		Return
//	End If
//	
////	dw_insert.Object.sabu[i] = gs_saupj
//	dw_insert.Object.cl_jpno[i] = ls_date+ls_jpno+String(i,'000')
//Next
//
//dw_insert.AcceptText()
//
//IF dw_insert.Update()  = 1  THEN	
//	COMMIT;
//	w_mdi_frame.sle_msg.Text = "저장 되었습니다!"
//	
//	dw_1.Object.sdate[1] = ls_date
//	dw_1.Object.fdate[1] = ls_date
//	p_inq.TriggerEvent(Clicked!)
//	
//
//ELSE
//	ROLLBACK;
//	//messagebox('',sqlca.sqlerrText)
//	f_message_chk(32, "[저장실패]")
//	w_mdi_frame.sle_msg.Text = "저장작업 실패!"
//END IF
//
//ib_any_typing = False //입력필드 변경여부 No
//
end event

type cb_exit from w_inherite`cb_exit within w_qa03_00100
integer x = 2825
integer y = 3288
end type

type cb_mod from w_inherite`cb_mod within w_qa03_00100
integer x = 1783
integer y = 3288
end type

type cb_ins from w_inherite`cb_ins within w_qa03_00100
integer x = 846
integer y = 2788
end type

type cb_del from w_inherite`cb_del within w_qa03_00100
integer x = 2130
integer y = 3288
end type

type cb_inq from w_inherite`cb_inq within w_qa03_00100
integer x = 1435
integer y = 3292
end type

type cb_print from w_inherite`cb_print within w_qa03_00100
end type

type st_1 from w_inherite`st_1 within w_qa03_00100
long backcolor = 12632256
end type

type cb_can from w_inherite`cb_can within w_qa03_00100
integer x = 2478
integer y = 3288
end type

type cb_search from w_inherite`cb_search within w_qa03_00100
integer x = 1230
integer y = 2792
end type



type sle_msg from w_inherite`sle_msg within w_qa03_00100
long backcolor = 12632256
end type

type gb_10 from w_inherite`gb_10 within w_qa03_00100
long backcolor = 12632256
end type

type gb_button1 from w_inherite`gb_button1 within w_qa03_00100
end type

type gb_button2 from w_inherite`gb_button2 within w_qa03_00100
end type

type dw_1 from u_key_enter within w_qa03_00100
event ue_key pbm_dwnkey
integer x = 23
integer y = 32
integer width = 2103
integer height = 252
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_qa03_00100_1"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;String  s_cod, ls_cvnas

s_cod = Trim(this.GetText())
If GetColumnName() = "gubun" Then
	
	If IsNull(s_cod) or s_cod = "" Then Return
	
	dw_insert.SetRedraw(False)
	Choose Case upper(s_cod)
		Case '1'
			dw_insert.DataObject = 'd_qa03_00100_field'
		case '2'
			dw_insert.DataObject = 'd_qa03_00100_returns'
		Case '3'
			dw_insert.DataObject = 'd_qa03_00100_rework'
//		Case 'E'
//			dw_insert.DataObject = 'd_qa03_00100_ilban'
	End Choose
	
	wf_set_cvcod(s_cod)
	
	dw_insert.SetTransObject(SQLCA)
	dw_insert.SetRedraw(True)

End If

If GetColumnName() = "cvcod" Then
	If s_cod = '' Or isNull(s_cod)  Then 
		This.Object.cvcod[1] = ""
		This.Object.cvnas[1] = ""
		Return 2
	end if
	
	Select cvnas 
	  Into :ls_cvnas 
	  From vndmst
	  Where cvcod = :s_cod ;
	
	If sqlca.sqlcode <> 0 Then
		This.Object.cvcod[1] = ""
		This.Object.cvnas[1] = ""
		Return 2
	End If

	This.Object.cvnas[1] = ls_cvnas
end if
end event

event itemerror;return 1
end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

if	this.getcolumnname() = "cvcod" then
	open(w_vndmst_popup)
	if not ( isnull(gs_code) or gs_code = '' ) then
		this.object.cvcod[1] = gs_code
		this.triggerevent(itemchanged!)
	end if
end if	
end event

type p_1 from uo_picture within w_qa03_00100
boolean visible = false
integer x = 3730
integer y = 168
integer width = 178
integer taborder = 100
boolean bringtotop = true
string pointer = "C:\erpman\cur\addrow.cur"
string picturename = "C:\erpman\image\행추가_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\행추가_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\행추가_up.gif"
end event

type p_2 from uo_picture within w_qa03_00100
boolean visible = false
integer x = 3904
integer y = 168
integer width = 178
integer taborder = 110
boolean bringtotop = true
string pointer = "C:\erpman\cur\delrow.cur"
string picturename = "C:\erpman\image\행삭제_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\행삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\행삭제_up.gif"
end event

type p_3 from picture within w_qa03_00100
integer x = 2144
integer y = 32
integer width = 178
integer height = 144
boolean bringtotop = true
string picturename = "C:\erpman\image\엑셀변환_up.gif"
boolean focusrectangle = false
end type

event clicked;string ls_docname, ls_named ,ls_line 
Long   ll_FileNum ,ll_value
String ls_gubun , ls_col ,ls_line_t , ls_data[]
Long   ll_xl_row , ll_r , i


If dw_1.AcceptText() = -1 Then Return


setnull(is_cvcod)
setnull(is_yymm)

ls_gubun = Trim(dw_1.Object.gubun[1])
is_yymm  = Trim(dw_1.Object.sdate[1])
is_cvcod = Trim(dw_1.Object.cvcod[1])


if Isnull(is_yymm) or is_yymm = '' then
  	f_message_chk(1400,'[접수년월]')
	dw_1.SetColumn('sdate')
	dw_1.SetFocus()
	return -1
end if	
if Isnull(is_cvcod) or is_cvcod = '' then
  	f_message_chk(1400,'[거래처]')
	dw_1.SetColumn('cvcod')
	dw_1.SetFocus()
	return -1
end if	


if dw_insert.retrieve(is_yymm, is_cvcod ) > 0 then
	if messagebox("",'접수 받은 데이타 가 존재 합니다. ~r~n 삭제후 생성 하시겠습니까?',Question!,YesNo! ,2) = 2 then return -1
end if

dw_insert.Reset()

Setpointer(Hourglass!)

Choose Case ls_gubun
	Case "K"
		wf_set_kia()
	Case 'M'
		wf_set_mobis()
	Case '1','2','3'
		wf_set_gmdat()
	Case 'E'		
		wf_set_ilban()
End Choose

MessageBox('확인',' CLAIM DATA IMPORT 를 완료하였습니다.')

dw_insert.AcceptText()

end event

type shl_1 from statichyperlink within w_qa03_00100
integer x = 59
integer y = 292
integer width = 256
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 134217856
long backcolor = 32106727
string text = "전체선택"
boolean focusrectangle = false
end type

event clicked;String ls_chk
Long   i

If dw_insert.RowCount() < 1 Then Return

If This.text = '전체선택' Then
	ls_chk = 'Y'
	This.text = '전체해제'
Else
	ls_chk = 'N'
	This.text = '전체선택'
End If

For i =1 To dw_insert.RowCount()
	dw_insert.Object.chk[i] = ls_chk
Next


end event

type st_2 from statictext within w_qa03_00100
integer x = 2162
integer y = 208
integer width = 1495
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 33027312
string text = "* 엑셀문서를 텍스트(탭으로 분리)로 변환후 등록하세요!!"
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_qa03_00100
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 352
integer width = 4562
integer height = 1964
integer cornerheight = 40
integer cornerwidth = 55
end type

