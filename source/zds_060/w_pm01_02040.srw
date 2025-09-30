$PBExportHeader$w_pm01_02040.srw
$PBExportComments$주간생산계획 소요량 전개
forward
global type w_pm01_02040 from w_inherite
end type
type dw_process from u_key_enter within w_pm01_02040
end type
type st_runmsg from statictext within w_pm01_02040
end type
end forward

global type w_pm01_02040 from w_inherite
integer width = 1769
integer height = 1060
string title = "생산계획 소요량 전개"
string menuname = ""
boolean controlmenu = false
boolean minbox = false
windowtype windowtype = response!
dw_process dw_process
st_runmsg st_runmsg
end type
global w_pm01_02040 w_pm01_02040

type variables
string  srunmsg , is_gbn
integer il, icnt

end variables

forward prototypes
public subroutine wf_message (string smessage)
public subroutine wf_clear ()
public function integer wf_create_plan ()
public function integer wf_add_plan (integer arg_actno)
public function integer wf_protect (string arg_gub, string arg_date)
end prototypes

public subroutine wf_message (string smessage);//w_pdt_01030_1.st_1.text = smessage

w_mdi_frame.sle_msg.Text = smessage

end subroutine

public subroutine wf_clear ();//dw_insert.object.step1[1] = 'N'
//dw_insert.object.step1[2] = 'N'
//dw_insert.object.step1[3] = 'N'
//dw_insert.object.step1[4] = 'N'
//dw_insert.object.step1[5] = 'N'
//dw_insert.object.step1[6] = 'N'

//dw_insert.object.step1[1] = 'N'
//dw_insert.object.step2[1] = 'N'
//dw_insert.object.step3[1] = 'N'
//dw_insert.object.step4[1] = 'N'
//dw_insert.object.step5[1] = 'N'
//dw_insert.object.step6[1] = 'N'

//dw_insert.object.stime11[1] = ''
//dw_insert.object.stime21[1] = ''
//dw_insert.object.stime31[1] = ''
//dw_insert.object.stime41[1] = ''
//dw_insert.object.stime51[1] = ''
//dw_insert.object.stime61[1] = ''
//
//dw_insert.object.stime12[1] = ''
//dw_insert.object.stime22[1] = ''
//dw_insert.object.stime32[1] = ''
//dw_insert.object.stime42[1] = ''
//dw_insert.object.stime52[1] = ''
//dw_insert.object.stime62[1] = ''
//
//sle_msg.text = ''
//
end subroutine

public function integer wf_create_plan ();// 주간 계획자료를 MRP 자료로 컨버젼
String sDate, sYymm, sgijun

sgijun = String(dw_process.object.gijun[1])

// 주간 생산계획
If sgijun = '3' Then
	sDate = Trim(dw_process.GetItemString(1, 'giyymm'))
	If f_dateChk(sDAte) <> 1 Then Return -1
	
	// 기존생성자료가 있을 경우 삭제한다 
	sYymm = Left(sDate,6)
	
	DELETE FROM MONPLN_DTL
	 WHERE SABU = :gs_sabu
		AND MONYYMM = :sYymm;
	If SQLCA.SQLCODE <> 0 Then
		MessageBox(String(SQLCA.SQLCODE),SQLCA.SQLERRTEXT)
		ROLLBACK;
		Return -1
	End If
	
	/* Lot 수량을 적용 */
	If dw_process.GetItemString(1, 'lotok') = 'Y' Then
		update pm02_weekplan_sum
			set ddqty1 = lotqty1, ddqty2 = lotqty2, ddqty3 = lotqty3,
				 ddqty4 = lotqty4, ddqty5 = lotqty5, ddqty6 = lotqty6, ddqty7 = lotqty7
		 where yymmdd = :sDate and mogub in ( '0', '1');
		 
		If SQLCA.SQLCODE <> 0 Then
			MessageBox(String(SQLCA.SQLCODE),SQLCA.SQLERRTEXT)
			ROLLBACK;
			Return -1
		End If
	End If
	
	// 생성
	INSERT INTO MONPLN_DTL
	  ( SABU, MONYYMM, PLNYYMM, MOSEQ, ITNBR,
		 MONQTY01, MONQTY02, MONQTY03, MONQTY04, MONQTY05, MONQTY06, MONQTY07,
		 MONQTY08, MONQTY09, MONQTY10, MONQTY11, MONQTY12, MONQTY13, MONQTY14,
		 MONQTY15, MONQTY16, MONQTY17, MONQTY18, MONQTY19, MONQTY20, MONQTY21,
		 MONQTY22, MONQTY23, MONQTY24, MONQTY25, MONQTY26, MONQTY27, MONQTY28,
		 MONQTY29, MONQTY30, MONQTY31, MOGUB )
	select sabu, monyymm, substr(yymmdd,1,6) as plnyymm, moseq, itnbr,
			 sum(decode(substr(yymmdd,7,2),'01', qty, 0)) as monqty01,
			 sum(decode(substr(yymmdd,7,2),'02', qty, 0)) as monqty02,
			 sum(decode(substr(yymmdd,7,2),'03', qty, 0)) as monqty03,
			 sum(decode(substr(yymmdd,7,2),'04', qty, 0)) as monqty04,
			 sum(decode(substr(yymmdd,7,2),'05', qty, 0)) as monqty05,
			 sum(decode(substr(yymmdd,7,2),'06', qty, 0)) as monqty06,
			 sum(decode(substr(yymmdd,7,2),'07', qty, 0)) as monqty07,
			 sum(decode(substr(yymmdd,7,2),'08', qty, 0)) as monqty08,
			 sum(decode(substr(yymmdd,7,2),'09', qty, 0)) as monqty09,
			 sum(decode(substr(yymmdd,7,2),'10', qty, 0)) as monqty10,
			 sum(decode(substr(yymmdd,7,2),'11', qty, 0)) as monqty11,
			 sum(decode(substr(yymmdd,7,2),'12', qty, 0)) as monqty12,
			 sum(decode(substr(yymmdd,7,2),'13', qty, 0)) as monqty13,
			 sum(decode(substr(yymmdd,7,2),'14', qty, 0)) as monqty14,
			 sum(decode(substr(yymmdd,7,2),'15', qty, 0)) as monqty15,
			 sum(decode(substr(yymmdd,7,2),'16', qty, 0)) as monqty16,
			 sum(decode(substr(yymmdd,7,2),'17', qty, 0)) as monqty17,
			 sum(decode(substr(yymmdd,7,2),'18', qty, 0)) as monqty18,
			 sum(decode(substr(yymmdd,7,2),'19', qty, 0)) as monqty19,
			 sum(decode(substr(yymmdd,7,2),'20', qty, 0)) as monqty20,
			 sum(decode(substr(yymmdd,7,2),'21', qty, 0)) as monqty21,
			 sum(decode(substr(yymmdd,7,2),'22', qty, 0)) as monqty22,
			 sum(decode(substr(yymmdd,7,2),'23', qty, 0)) as monqty23,
			 sum(decode(substr(yymmdd,7,2),'24', qty, 0)) as monqty24,
			 sum(decode(substr(yymmdd,7,2),'25', qty, 0)) as monqty25,
			 sum(decode(substr(yymmdd,7,2),'26', qty, 0)) as monqty26,
			 sum(decode(substr(yymmdd,7,2),'27', qty, 0)) as monqty27,
			 sum(decode(substr(yymmdd,7,2),'28', qty, 0)) as monqty28,
			 sum(decode(substr(yymmdd,7,2),'29', qty, 0)) as monqty29,
			 sum(decode(substr(yymmdd,7,2),'30', qty, 0)) as monqty30,
			 sum(decode(substr(yymmdd,7,2),'31', qty, 0)) as monqty31,
			 mogub
	  from (	select sabu, substr(yymmdd,1,6) as monyymm, yymmdd as yymmdd, itnbr, moseq, mogub, ddqty1 as qty
			  	  from pm02_weekplan_sum where yymmdd = :sDate and mogub in ( '0', '1')
				union all
				select sabu, substr(yymmdd,1,6),to_char(to_date(yymmdd,'yyyymmdd') + 1,'yyyymmdd'), itnbr, moseq, mogub, ddqty2
				  from pm02_weekplan_sum where yymmdd = :sDate and mogub in ( '0', '1')
				union all
				select sabu, substr(yymmdd,1,6),to_char(to_date(yymmdd,'yyyymmdd') + 2,'yyyymmdd'), itnbr, moseq, mogub, ddqty3
				  from pm02_weekplan_sum where yymmdd = :sDate and mogub in ( '0', '1')
				union all
				select sabu, substr(yymmdd,1,6),to_char(to_date(yymmdd,'yyyymmdd') + 3,'yyyymmdd'), itnbr, moseq, mogub, ddqty4
				  from pm02_weekplan_sum where yymmdd = :sDate and mogub in ( '0', '1')
				union all
				select sabu, substr(yymmdd,1,6),to_char(to_date(yymmdd,'yyyymmdd') + 4,'yyyymmdd'), itnbr, moseq, mogub, ddqty5
				  from pm02_weekplan_sum where yymmdd = :sDate and mogub in ( '0', '1')
				union all
				select sabu, substr(yymmdd,1,6),to_char(to_date(yymmdd,'yyyymmdd') + 5,'yyyymmdd'), itnbr, moseq, mogub, ddqty6
				  from pm02_weekplan_sum where yymmdd = :sDate and mogub in ( '0', '1')
				union all
				select sabu, substr(yymmdd,1,6),to_char(to_date(yymmdd,'yyyymmdd') + 6,'yyyymmdd'), itnbr, moseq, mogub, ddqty7
				  from pm02_weekplan_sum where yymmdd = :sDate and mogub in ( '0', '1') )
	 group by sabu, monyymm, substr(yymmdd,1,6) , itnbr, moseq, mogub;
	
	If SQLCA.SQLCODE <> 0 Then
		MessageBox(String(SQLCA.SQLCODE),SQLCA.SQLERRTEXT)
		ROLLBACK;
		Return -1
	End If
	
	COMMIT;
End If

Return 1
end function

public function integer wf_add_plan (integer arg_actno);// 주간 계획자료를 MRP 자료로 컨버젼
String sDate, sYymm

sDate = Trim(dw_process.GetItemString(1, 'giyymm'))
If f_dateChk(sDAte) <> 1 Then Return -1

// 기존생성자료가 있을 경우 삭제한다 
sYymm = Left(sDate,6)

DELETE FROM pm02_weekplan_sum
 WHERE SABU = :gs_sabu
   AND YYMMDD = :sDate
	AND MOGUB = '2';
If SQLCA.SQLCODE <> 0 Then
	MessageBox(String(SQLCA.SQLCODE),SQLCA.SQLERRTEXT)
	ROLLBACK;
	Return -1
End If

// 생성
insert into pm02_weekplan_sum
 ( SABU, YYMMDD, ITNBR, MOSEQ,
   DDQTY1, DDQTY2, DDQTY3, DDQTY4, DDQTY5, DDQTY6, DDQTY7,
   MCHDAN, MOGUB, JAEGO, SHRAT, MINQTY, MIDSAF, JAEGONG,
   LOTQTY1, LOTQTY2, LOTQTY3, LOTQTY4, LOTQTY5, LOTQTY6, LOTQTY7 )
select :gs_sabu, :sDate, x.itnbr, 1,
       sum(decode(idx,1, mrpqt,0)) as ddqty1,sum(decode(idx,2, mrpqt,0)) as ddqty2,sum(decode(idx,3, mrpqt,0)) as ddqty3,
       sum(decode(idx,4, mrpqt,0)) as ddqty4,sum(decode(idx,5, mrpqt,0)) as ddqty5,sum(decode(idx,6, mrpqt,0)) as ddqty6,
       sum(decode(idx,7, mrpqt,0)) as ddqty7,
       0 as mchdan, '2' as mogub,
       y.jego_qty as jaego, y.shrat as shrat, y.minqt as minqty, y.minmid as midsaf, 0 as jaegong,
       sum(decode(idx,1, mrpqt,0)) as lotqty1,sum(decode(idx,2, mrpqt,0)) as lotqty2,sum(decode(idx,3, mrpqt,0)) as lotqty3,
       sum(decode(idx,4, mrpqt,0)) as lotqty4,sum(decode(idx,5, mrpqt,0)) as lotqty5,sum(decode(idx,6, mrpqt,0)) as lotqty6,
       sum(decode(idx,7, mrpqt,0)) as lotqty7
  from (select itnbr, to_date(dudat,'yyyymmdd') - to_date(:sDate,'yyyymmdd')+1 as idx, dudat, mrpqt from PLNDTL
		 where sabu = :gs_sabu
		   and actno = :arg_actno
		   and mrpgu = 3
		   and rctyp = 'G'   ) x, mrpint y
 where y.sabu = :gs_sabu
   and y.actno = :arg_actno
   and y.mrpgu = 2
   and y.itnbr = x.itnbr
 group by x.itnbr, y.jego_qty , y.shrat, y.minqt, y.minmid;

If SQLCA.SQLCODE <> 0 Then
	MessageBox(String(SQLCA.SQLCODE),SQLCA.SQLERRTEXT)
	ROLLBACK;
	Return -1
End If

COMMIT;

Return 1
end function

public function integer wf_protect (string arg_gub, string arg_date);Long lcount
String sJocod

sJocod = Trim(dw_process.GetItemString(1, 'jocod'))
If IsNull(sJocod) Or sJocod = '' Then sJocod = ''

// 마감여부
If arg_gub = '3' Then

	SELECT COUNT(*) INTO :lcount FROM PM02_WEEKPLAN_SUM A, ITEMAS B
	 WHERE A.SABU = :gs_sabu AND A.YYMMDD = :arg_date AND A.MOSEQ = 0
	   AND A.ITNBR = B.ITNBR
		AND A.JOCOD LIKE :sJocod||'%';
Else
	SELECT COUNT(*) INTO :lcount
	 FROM PM01_MONPLAN_SUM A, ITEMAS B
	WHERE A.SABU = :gs_sabu AND A.MONYYMM = :arg_date AND A.MOSEQ = 0 
	  AND A.ITNBR = B.ITNBR
	  AND A.JOCOD LIKE :sJocod||'%';
End If

if lcount > 0 then 
	messagebox("확 인", "생산계획이 확정되어 있으므로 수정 및 삭제 할 수 없습니다.")
	p_search.picturename = 'C:\erpman\image\생성_d.gif'
	p_del.picturename = 'C:\erpman\image\삭제_d.gif'
					
	p_search.enabled = false
	p_del.enabled = false
else
	p_search.picturename = 'C:\erpman\image\생성_up.gif'
	p_del.picturename = 'C:\erpman\image\삭제_up.gif'
					
	p_search.enabled = true
	p_del.enabled = true
end if

return 1
end function

on w_pm01_02040.create
int iCurrent
call super::create
this.dw_process=create dw_process
this.st_runmsg=create st_runmsg
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_process
this.Control[iCurrent+2]=this.st_runmsg
end on

on w_pm01_02040.destroy
call super::destroy
destroy(this.dw_process)
destroy(this.st_runmsg)
end on

event open;call super::open;// mrp기준(2:월,3:주간)
is_gbn = message.stringparm
If IsNull(is_gbn) Or is_gbn > '3' Then is_gbn = '3'

f_window_center_response(this)
PostEvent("ue_open")
end event

event ue_open;call super::ue_open;String sym, sDate, eDate
Long   lmaxseq

gs_codename2 = 'x'

dw_process.settransobject(sqlca)
dw_process.reset()
dw_process.insertrow(0)
dw_insert.insertrow(0)

dw_process.setitem(1, "mrprun", f_today())

wf_protect(is_gbn, sym)

p_search.enabled = true
p_search.PictureName = 'C:\erpman\image\생성_up.gif'

/* 월 계획 */
dw_process.SetItem(1, 'gijun',Integer(is_gbn))
dw_process.PostEvent(ItemChanged!)

//SELECT MAX(MONYYMM) INTO :sym FROM pm01_monplan_sum;
//lMaxseq = 1
//
//dw_process.setitem(1, "giyymm", sym)
//dw_process.setitem(1, "gseq",   lmaxseq)
//
//SELECT MIN(WEEK_SDATE) INTO :sDate FROM PDTWEEK WHERE SUBSTR(WEEK_SDATE,1,6) = :sym;
//dw_process.object.sidat[1] = sDate
//
//SELECT MAX(WEEK_EDATE) INTO :eDate FROM PDTWEEK WHERE SUBSTR(WEEK_SDATE,1,6) = to_char(add_months(to_date(:sym,'yyyymm'),2),'yyyymm');
//dw_process.object.eddat[1] = eDate
//
//
end event

type dw_insert from w_inherite`dw_insert within w_pm01_02040
boolean visible = false
integer x = 82
integer y = 660
integer width = 1829
integer height = 1676
integer taborder = 0
string dataobject = "d_pm01_02040_2"
boolean border = false
end type

type p_delrow from w_inherite`p_delrow within w_pm01_02040
boolean visible = false
integer x = 2569
integer y = 28
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_pm01_02040
boolean visible = false
integer x = 2395
integer y = 28
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_pm01_02040
integer x = 1138
integer y = 0
string pointer = "C:\erpman\cur\create2.cur"
boolean enabled = false
string picturename = "C:\erpman\image\생성_d.gif"
end type

event p_search::clicked;/* MRP Server procedure 를 실행
   step마다 error check를 실행하여 error가 발생할 경우 해당시점에서
	중단 */
String sgijun, sgyymm, serror, smsgtxt, scalgu, sTxt, sstdat, seddat, scheck, sLoop, sGiDate
String temp_calgu, sPordno, sJocod
integer dseq, dCnt, dMaxno, dAddNo, irtn

if dw_process.accepttext() = -1 then return 	

sgijun = String(dw_process.object.gijun[1])
sGiDate= trim(dw_process.object.giyymm[1])
sgyymm = Left(trim(dw_process.object.giyymm[1]),6)
dseq   = dw_process.object.gseq[1]
scalgu = dw_process.object.gcalgu[1]
sstdat = trim(dw_process.object.sidat[1])
seddat = trim(dw_process.object.eddat[1])

sJocod = trim(dw_process.object.jocod[1])
//If IsNull(sJocod) Or sJocod = '' Then
//	f_message_chk(1400, '생산팀')
//	Return
//End If

/* 월계획 */
If sgijun = '2' then 
	if isnull(sgyymm) or sgyymm = "" then
		f_message_chk(30,'[기준년월]')
		dw_process.Setcolumn('giyymm')
		dw_process.SetFocus()
		return
	end if
	smsgtxt = left(sgyymm ,4)+ '년 ' + right(sgyymm,2) + '월 ' &
	          + '소요량 전개 처리를 하시겠습니까?'
	
	dSeq	= 0
	sPordno = sgyymm + string(dseq,'00')
/* 주간 생산계획 */
else
	if isnull(sgyymm) or sgyymm = "" then
		f_message_chk(30,'[기준주차]')
		dw_process.Setcolumn('giyymm')
		dw_process.SetFocus()
		return
	end if
	smsgtxt = left(sgyymm ,4)+ '년 ' + right(sgyymm,2) + '월 ' &
	          + Right(sGiDate,2) + '일 소요량 전개 처리를 하시겠습니까?'
	
	// 주차
	SELECT MON_JUCHA INTO :dseq FROM PDTWEEK WHERE WEEK_SDATE = :sstdat;
	sPordno = sgyymm + string(dseq,'00')
end if	

if messagebox("확 인", smsgtxt, Question!, YesNo!, 2) = 2 then return   
sLoop = 'N'

setpointer(hourglass!)

wf_clear()

serror = 'X'
icnt = 0
dw_insert.object.step1[1]   = '1'
dw_insert.object.stime11[1] = f_totime()

// Mrp History Create
/* MRP실행이력의 최대 실행순번을 구한다 */
SELECT MAX(ACTNO)	
  INTO :dmaxno
  FROM MRPSYS
 WHERE SABU = :gs_sabu;

if isnull(dmaxno) then dmaxno = 0;

dMaxno = dmaxno + 1

/* MRP이력을 작성한다 */
sTXT  = 'FACTOR적용안함';
INSERT INTO MRPSYS (SABU, ACTNO, MRPRUN, MRPGIYYMM, MRPDATA, MRPCUDAT, MRPSIDAT,
						  MRPEDDAT, MRPTXT, MRPSEQ, MRPCALGU, MRPPDTSND, MRPMATSND, MRPDELETE)
		VALUES(:gs_sabu, :dMAXNO, TO_CHAR(SYSDATE, 'YYYYMMDD'), :sGyymm, :sgijun,
				 TO_CHAR(SYSDATE, 'YYYYMMDD'), :sstdat, :seddat, :stxt, :dseq, 'N','N','N','N');
If sqlca.sqlcode <> 0 then
	ROLLBACK;
	sle_msg.text = ""
	f_message_chk(41,'[MRP RUN-Mrp History Create]' + '~n' + sqlca.sqlerrtext)
	dw_process.setfocus()
	return
END If

w_mdi_frame.sle_msg.text = "자재 소요량 전개(MRP)처리중. .............."

srunmsg = "자재 소요량 전개(MRP)처리중. .............." + "MRP Initial Create"

wf_message(srunmsg)
irtn = sqlca.leewon_mrp_1(gs_sabu, sgyymm, dseq, sPordno, sJocod);
If isnull(irtn) or irtn < 1 then
	w_mdi_frame.sle_msg.text = serror
	f_message_chk(41,'[MRP RUN-Mrp Initial]' + '~n' + sqlca.sqlerrtext)
	dw_process.setfocus()
	return
END IF

srunmsg = "자재 소요량 전개(MRP)처리중. .............." + "Plan Recode Create"

wf_message(srunmsg)
irtn = sqlca.leewon_mrp_2(gs_sabu, sgyymm, dseq, sPordno, sJocod);

If isnull(irtn) or irtn < 1 then
	w_mdi_frame.sle_msg.text = serror
	f_message_chk(41,'[Plan Recode Create]' + '~n' + sqlca.sqlerrtext)
	dw_process.setfocus()
	return
END IF

/* MRP계산이 정상적으로 종료되었다는 표시를 한다 */
Update mrpsys
   set mrpcalgu = 'Y', mrppdtsnd = 'Y'
 Where sabu = :gs_sabu and actno = :dmaxno;

If sqlca.sqlcode <> 0 then
	ROLLBACK;
	w_mdi_frame.sle_msg.text = ""
	f_message_chk(41,'[계산이력 작성중 오류발생]'+ '~n' + sqlca.sqlerrtext)
	dw_process.setfocus()
	return
END If 

Update reffpf
   set rfna2 = to_char(:dmaxno)
 where sabu = '1' and rfcod = '1A' and rfgub = '1';

COMMIT;

messagebox("소요량 계산", "정상종료되었읍니다")

w_mdi_frame.sle_msg.text = "실행번호 -> " + string(dmaxno)
dw_process.setfocus()

gs_codename2 = 'o'
end event

event p_search::ue_lbuttondown;call super::ue_lbuttondown;this.PictureName =  'C:\erpman\image\생성_dn.gif'
end event

event p_search::ue_lbuttonup;call super::ue_lbuttonup;this.PictureName =  'C:\erpman\image\생성_up.gif'
end event

type p_ins from w_inherite`p_ins within w_pm01_02040
boolean visible = false
integer x = 2222
integer y = 28
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_pm01_02040
integer x = 1509
integer y = 0
end type

type p_can from w_inherite`p_can within w_pm01_02040
boolean visible = false
boolean enabled = false
end type

type p_print from w_inherite`p_print within w_pm01_02040
boolean visible = false
integer x = 1874
integer y = 28
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_pm01_02040
boolean visible = false
integer x = 2048
integer y = 28
boolean enabled = false
end type

type p_del from w_inherite`p_del within w_pm01_02040
integer x = 1326
integer y = 0
end type

event p_del::clicked;call super::clicked;String sgijun, sgyymm, serror, smsgtxt, scalgu, sTxt, sstdat, seddat, scheck, sLoop, sGiDate
String temp_calgu, sPordno, sJocod
integer dseq, dCnt, dMaxno, dAddNo, irtn

if dw_process.accepttext() = -1 then return 	

sgijun = String(dw_process.object.gijun[1])
sGiDate= trim(dw_process.object.giyymm[1])
sgyymm = Left(trim(dw_process.object.giyymm[1]),6)
dseq   = dw_process.object.gseq[1]
scalgu = dw_process.object.gcalgu[1]
sstdat = trim(dw_process.object.sidat[1])
seddat = trim(dw_process.object.eddat[1])

sJocod = trim(dw_process.object.jocod[1])
If IsNull(sJocod) Or sJocod = '' Then
	f_message_chk(1400, '반')
	Return
End If

/* 월계획 */
If sgijun = '2' then 
	if isnull(sgyymm) or sgyymm = "" then
		f_message_chk(30,'[기준년월]')
		dw_process.Setcolumn('giyymm')
		dw_process.SetFocus()
		return
	end if
	smsgtxt = left(sgyymm ,4)+ '년 ' + right(sgyymm,2) + '월 ' &
	          + '소요량 전개 자료를 삭제 하시겠습니까?'
	
	dSeq	= 0
	sPordno = sgyymm + string(dseq,'00')
/* 주간 생산계획 */
else
	if isnull(sgyymm) or sgyymm = "" then
		f_message_chk(30,'[기준주차]')
		dw_process.Setcolumn('giyymm')
		dw_process.SetFocus()
		return
	end if
	smsgtxt = left(sgyymm ,4)+ '년 ' + right(sgyymm,2) + '월 ' &
	          + Right(sGiDate,2) + '일 소요량 전개 자료를 삭제 하시겠습니까?'
	
	// 주차
	SELECT MON_JUCHA INTO :dseq FROM PDTWEEK WHERE WEEK_SDATE = :sstdat;
	sPordno = sgyymm + string(dseq,'00')
end if	

if messagebox("확 인", smsgtxt, Question!, YesNo!, 2) = 2 then return   
sLoop = 'N'

setpointer(hourglass!)

wf_clear()

serror = 'X'
icnt = 0
dw_insert.object.step1[1]   = '1'
dw_insert.object.stime11[1] = f_totime()
		 
/* MRP실행이력의 최대 실행순번을 구한다 */
SELECT MAX(ACTNO)	
  INTO :dmaxno
  FROM MRPSYS
 WHERE SABU = :gs_sabu and MRPGIYYMM = :sgyymm and mrpseq = :dSeq;

if isnull(dmaxno) then dmaxno = 0;
If dMaxNo <= 0 Then
	MessageBox('확인','삭제할 자료가 없습니다.!!')
	Return
End If

w_mdi_frame.sle_msg.text = "자재 소요량 전개(MRP) 삭제중. .............."

/* 기존 계산된 내역은 삭제 */
DELETE FROM MOMAST_COPY_LOTSIM A
  WHERE A.SABU = :gs_sabu AND A.master_no =  :sPordno;
//	 AND EXISTS ( SELECT * FROM ITEMAS I WHERE I.ITNBR = A.ITNBR AND I.JOCOD LIKE :sJocod||'%' );
If sqlca.sqlcode <> 0 Then
	MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
	rollback;
	Return
End If

DELETE FROM PM01_MONPLAN_DTL A
  WHERE A.SABU = :gs_sabu AND A.MONYYMM = :sgyymm AND A.MOGUB = '2' AND JOCOD LIKE :sJocod||'%';
//	 AND EXISTS ( SELECT * FROM ITEMAS I WHERE I.ITNBR = A.ITNBR AND I.JOCOD LIKE :sJocod||'%' );
If sqlca.sqlcode <> 0 Then
	MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
	rollback;
	Return
End If

/* MRP계산이 정상적으로 삭제되었다는 표시를 한다 */
Update mrpsys
   set mrppdtsnd = 'N'
 Where sabu = :gs_sabu and actno = :dmaxno and mrpseq = :dSeq;

If sqlca.sqlcode <> 0 then
	ROLLBACK;
	w_mdi_frame.sle_msg.text = ""
	f_message_chk(41,'[계산이력 작성중 오류발생]'+ '~n' + sqlca.sqlerrtext)
	dw_process.setfocus()
	return
END If 

COMMIT;

messagebox("소요량 삭제", "정상종료되었읍니다")

w_mdi_frame.sle_msg.text = "실행번호 -> " + string(dmaxno)

dw_process.setfocus()

gs_codename2 = 'x'
end event

type p_mod from w_inherite`p_mod within w_pm01_02040
boolean visible = false
integer x = 2743
integer y = 28
boolean enabled = false
end type

type cb_exit from w_inherite`cb_exit within w_pm01_02040
integer x = 4206
integer y = 1976
integer taborder = 30
boolean enabled = false
end type

type cb_mod from w_inherite`cb_mod within w_pm01_02040
integer x = 549
integer y = 2508
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within w_pm01_02040
integer x = 187
integer y = 2508
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_pm01_02040
integer x = 910
integer y = 2508
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_pm01_02040
integer x = 1271
integer y = 2508
boolean enabled = false
end type

type cb_print from w_inherite`cb_print within w_pm01_02040
integer x = 1632
integer y = 2508
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_pm01_02040
end type

type cb_can from w_inherite`cb_can within w_pm01_02040
integer x = 1993
integer y = 2508
boolean enabled = false
end type

type cb_search from w_inherite`cb_search within w_pm01_02040
integer x = 2354
integer y = 2508
boolean enabled = false
end type





type gb_10 from w_inherite`gb_10 within w_pm01_02040
integer x = 18
end type

type gb_button1 from w_inherite`gb_button1 within w_pm01_02040
end type

type gb_button2 from w_inherite`gb_button2 within w_pm01_02040
end type

type dw_process from u_key_enter within w_pm01_02040
integer x = 14
integer y = 184
integer width = 1742
integer height = 732
integer taborder = 10
string dataobject = "d_pm01_02040_1"
boolean border = false
end type

event itemchanged;String sDate, eDate, sym, sGijun, syymm
Long   lcount

Choose case GetColumnName()
	Case 'gijun'
		sGijun = Trim(GetText())
		
		/* 월 계획 */
		If sGijun = '2' Then
			SELECT MAX(MONYYMM) INTO :sym FROM pm01_monplan_sum;
			
			dw_process.setitem(1, "giyymm", sym)
			
			SELECT MIN(WEEK_SDATE) INTO :sDate FROM PDTWEEK WHERE SUBSTR(WEEK_SDATE,1,6) = :sym;
			dw_process.object.sidat[1] = sDate
			
			SELECT MAX(WEEK_EDATE) INTO :eDate FROM PDTWEEK WHERE SUBSTR(WEEK_SDATE,1,6) = to_char(add_months(to_date(:sym,'yyyymm'),2),'yyyymm');
			dw_process.object.eddat[1] = eDate
			
			Post wf_protect('3', sym)
		/* 주간 계획 */
		Else
			SELECT MAX(YYMMDD) INTO :sym FROM pm02_weekplan_sum;
			
			dw_process.setitem(1, "giyymm", sym)
			
			SELECT WEEK_SDATE, WEEK_LDATE INTO :sDate, :eDate FROM PDTWEEK WHERE WEEK_SDATE = :sym;
			dw_process.object.sidat[1] = sDate

			syymm = Left(sym,6)
			SELECT MAX(WEEK_LDATE) INTO :eDate FROM PDTWEEK WHERE SUBSTR(WEEK_SDATE,1,6) = to_char(add_months(to_date(:syymm,'yyyymm'),2),'yyyymm');
			dw_process.object.eddat[1] = eDate
			
			Post wf_protect('3', sym)
		End If
	case 'giyymm'
		sYm = Trim(GetText())
		
		/* 월 계획 */
		If String(GetItemNumber(1, 'gijun')) = '2' Then
			SELECT MIN(WEEK_SDATE) INTO :sDate FROM PDTWEEK WHERE SUBSTR(WEEK_SDATE,1,6) = :sym;
			dw_process.object.sidat[1] = sDate
			
			SELECT MAX(WEEK_EDATE) INTO :eDate FROM PDTWEEK WHERE SUBSTR(WEEK_SDATE,1,6) = to_char(add_months(to_date(:sym,'yyyymm'),2),'yyyymm');
			dw_process.object.eddat[1] = eDate
			
			// 마감여부
			Post wf_protect('2', sym)
			
		/* 주간 계획 */
		Else
			SELECT WEEK_SDATE, WEEK_LDATE INTO :sDate, :eDate FROM PDTWEEK WHERE WEEK_SDATE = :sym;
			dw_process.object.sidat[1] = sDate
			
			syymm = Left(sym,6)
			SELECT MAX(WEEK_LDATE) INTO :eDate FROM PDTWEEK WHERE SUBSTR(WEEK_SDATE,1,6) = to_char(add_months(to_date(:syymm,'yyyymm'),2),'yyyymm');
			dw_process.object.eddat[1] = eDate
			
			// 마감여부
			Post wf_protect('3', sym)
		End If
	case 'jocod'
		sYm = Trim(GetItemString(1, 'giyymm'))
		
		/* 월 계획 */
		If String(GetItemNumber(1, 'gijun')) = '2' Then

			
			// 마감여부
			Post wf_protect('2', sym)
			
		/* 주간 계획 */
		Else
			
			// 마감여부
			Post wf_protect('3', sym)
		End If
End choose

end event

event itemerror;return 1
end event

type st_runmsg from statictext within w_pm01_02040
boolean visible = false
integer x = 41
integer y = 2104
integer width = 1705
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean italic = true
long backcolor = 12632256
boolean enabled = false
alignment alignment = right!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

