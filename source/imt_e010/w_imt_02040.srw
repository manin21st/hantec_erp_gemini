$PBExportHeader$w_imt_02040.srw
$PBExportComments$** 발주수정
forward
global type w_imt_02040 from w_inherite
end type
type dw_1 from datawindow within w_imt_02040
end type
type pb_1 from u_pb_cal within w_imt_02040
end type
type pb_2 from u_pb_cal within w_imt_02040
end type
type rr_1 from roundrectangle within w_imt_02040
end type
end forward

global type w_imt_02040 from w_inherite
string title = "발주수정"
dw_1 dw_1
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_imt_02040 w_imt_02040

type variables
string is_pspec, is_jijil
end variables

forward prototypes
public function integer wf_baljpno_chk ()
public function integer wf_required_chk (integer i)
public subroutine wf_reset ()
end prototypes

public function integer wf_baljpno_chk ();int    k, iseq, get_count
string sbaljpno

FOR k=1 TO dw_insert.rowcount()
	sbaljpno = dw_insert.getitemstring(k, 'baljpno')
	iseq     = dw_insert.getitemnumber(k, 'balseq')
	
	SELECT COUNT(*)
     INTO :get_count  
     FROM "POLCDT"  
    WHERE ( "POLCDT"."SABU" = :gs_sabu ) AND  
          ( "POLCDT"."BALJPNO" = :sbaljpno ) AND  
          ( "POLCDT"."BALSEQ" = :iseq )   ;

	if get_count > 0 then 
		dw_insert.setitem(k, 'opt', 'N')
	end if
NEXT

return 1
end function

public function integer wf_required_chk (integer i);//if isnull(dw_insert.GetItemString(i,'itcls')) or &
//	dw_insert.GetItemString(i,'itcls') = "" then
//	f_message_chk(1400,'[ '+string(i)+' 행 대분류코드]')
//	dw_insert.ScrollToRow(i)
//	dw_insert.SetColumn('itcls')
//	dw_insert.SetFocus()
//	return -1		
//end if	

dw_insert.setitem(i, "unamt", dw_insert.getitemnumber(i, 'cunamt'))


Return 1
end function

public subroutine wf_reset ();dw_1.setredraw(false)
dw_insert.setredraw(false)

dw_1.reset()
dw_insert.reset()

dw_1.insertrow(0)
dw_1.SetFocus()

p_search.enabled = false
p_search.picturename = 'c:\erpman\image\특기사항등록_d.gif'

dw_1.setredraw(true)
dw_insert.setredraw(true)

end subroutine

on w_imt_02040.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.pb_2
this.Control[iCurrent+4]=this.rr_1
end on

on w_imt_02040.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event open;call super::open;///////////////////////////////////////////////////////////////////////////////////
// 발주단위 사용에 따른 화면 변경
sTring sCnvgu, sCnvart

/* 발주단위 사용여부를 환경설정에서 검색함 */
select dataname
  into :sCnvgu
  from syscnfg
 where sysgu = 'Y' and serial = 12 and lineno = '3';
If isNull(sCnvgu) or Trim(sCnvgu) = '' then
	sCnvgu = 'N'
End if

if sCnvgu = 'Y' then // 발주단위 사용시
	dw_insert.dataobject = 'd_imt_02040_1_1'
Else						// 발주단위 사용안함
	dw_insert.dataobject = 'd_imt_02040_1'	
End if

dw_insert.SetTransObject(sqlca)
dw_1.SetTransObject(sqlca)
dw_1.insertrow(0)
dw_1.SetFocus()


IF f_change_name('1') = 'Y' then 
	is_pspec = f_change_name('2')
	is_jijil = f_change_name('3')
	dw_insert.object.ispec_t.text = is_pspec
	dw_insert.object.jijil_t.text = is_jijil
END IF

end event

event key;// Page Up & Page Down & Home & End Key 사용 정의
choose case key
	case keypageup!
		dw_insert.scrollpriorpage()
	case keypagedown!
		dw_insert.scrollnextpage()
	case keyhome!
		dw_insert.scrolltorow(1)
	case keyend!
		dw_insert.scrolltorow(dw_insert.rowcount())
	case KeyupArrow!
		dw_insert.scrollpriorrow()
	case KeyDownArrow!
		dw_insert.scrollnextrow()		
end choose


end event

type dw_insert from w_inherite`dw_insert within w_imt_02040
integer x = 82
integer y = 396
integer width = 4503
integer height = 1900
integer taborder = 20
string dataobject = "d_imt_02040_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::ue_pressenter;Send(Handle(this),256,9,0)
Return 1

end event

event dw_insert::itemchanged;String sData, sPrvdata, scvcod, sPordno, get_pdsts, sProject, Scode, get_nm, get_nm2
Decimal {5} dPrvdata, dData
int     ireturn 

IF this.getcolumnname() = 'balsts' then
	sPrvdata = this.getitemstring(row, 'old_balsts')
	sData = gettext()
	IF sData = '2' then
		f_message_chk(304, '[발주상태]')
		setitem(row, "balsts", sPrvdata)
		return 1
	ELSEIF sData = '1' and (sPrvdata = '3' or sPrvdata = '4') then
		sPordno = this.getitemstring(row, 'pordno')
		If not ( sPordno = '' or isnull(sPordno) ) then 
		   SELECT PDSTS  
			  INTO :get_pdsts  
			  FROM MOMAST  
			 WHERE SABU = :gs_sabu AND PORDNO = :sPordno  ;
			 
         if sqlca.sqlcode = 0 then
				if get_pdsts = '6' then 
					MessageBox("확 인","작업지시가 취소 상태입니다. 자료를 확인하세요" + "~n~n" +&
											 "발주상태를 변경시킬 수 없습니다.", StopSign! )
					this.setitem(row, "balsts", sPrvdata)
					Return 1
				end if
			else	
				MessageBox("확 인","작업지시번호를 확인하세요" + "~n~n" +&
										 "발주상태를 변경시킬 수 없습니다.", StopSign! )
				this.setitem(row, "balsts", sPrvdata)
				Return 1
			end if	
		End if	
	END IF
ELSEIF getcolumnname() = 'balqty' then
	dPrvdata = getitemdecimal(row, 'balqty')
	dData = Dec(gettext())
	if dData < getitemdecimal(row, "rcqty") or &
	   dData < getitemdecimal(row, "lcoqty") then
		f_message_chk(305, '[발주수량]')
		setitem(row, "balqty", dPrvdata)
		return 1
	end if
	if dData < 1 then
		f_message_chk(30, '[발주수량]')
		setitem(row, "balqty", dPrvdata)
		return 1
	end if		
	
	// 변환계수에 의한 수량변환
	if getitemdecimal(row, "poblkt_cnvfat") = 1  then
		setitem(row, "poblkt_cnvqty", dData)
	elseif getitemstring(row, "poblkt_cnvart") = '/' then
		if dData = 0 then
			setitem(row, "poblkt_cnvqty", 0)
		Else
			setitem(row, "poblkt_cnvqty", round(dData / getitemdecimal(row, "poblkt_cnvfat"), 3))
		End if
	else
		setitem(row, "poblkt_cnvqty", round(dData * getitemdecimal(row, "poblkt_cnvfat"), 3))
	end if
	
	Setitem(row, "poblkt_cnvamt", getitemdecimal(row, "poblkt_cnvprc") * &
										   getitemdecimal(row, "poblkt_cnvqty"))	
											
end if

if getcolumnname() = 'unprc' then
	dPrvdata = getitemdecimal(row, 'unprc')
	dData = Dec(gettext())
	if dData <= 0 then
		f_message_chk(30, '[발주금액]')
		setitem(row, "unprc", dPrvdata)
		return 1
	end if	
	
	// 변환계수에 의한 단가변환
	if getitemdecimal(row, "poblkt_cnvfat") = 1   then
		setitem(row, "poblkt_cnvprc", dData)
	elseif getitemstring(row, "poblkt_cnvart") = '*'  then
		IF ddata = 0 then
			setitem(row, "poblkt_cnvprc", 0)			
		else
			setitem(row, "poblkt_cnvprc", ROUND(dData / getitemdecimal(row, "poblkt_cnvfat"),5))
		end if
	else
		setitem(row, "poblkt_cnvprc", ROUND(dData * getitemdecimal(row, "poblkt_cnvfat"),5))
	end if
	setitem(row, "poblkt_cnvamt", Round(getitemdecimal(row, "poblkt_cnvqty") * &
												   getitemdecimal(row, "poblkt_cnvprc"), 2))

end if

if this.getcolumnname() = 'nadat' then
	sPrvdata = this.getitemstring(row, 'nadat')
	sData = gettext()
	if isnull(sdata) or trim(sdata) ='' or f_datechk(sdata) = -1 then
		Messagebox("확인", "유효한 일자를 입력하십시요", stopsign!)
		dw_insert.setitem(row, "nadat", sPrvdata)
		dw_insert.SetColumn('nadat')
		dw_insert.SetFocus()
		return 1		
	end if	
ELSEIF this.getcolumnname() = "project_no"	then
	sProject = trim(this.gettext())
	
	if sProject = '' or isnull(sproject) then return 
	
	SELECT "VW_PROJECT"."SABU"  
     INTO :sCode
     FROM "VW_PROJECT"  
    WHERE ( "VW_PROJECT"."SABU"  = :gs_sabu ) AND  
          ( "VW_PROJECT"."PJTNO" = :sProject )   ;

	IF sqlca.sqlcode <> 0 	THEN
		f_message_chk(33, '[프로젝트 번호]')
		this.setitem(Row, "project_no", '')
	   return 1
	END IF
	
END IF


end event

event dw_insert::itemerror;return 1
end event

event dw_insert::updatestart;/* Update() function 호출시 user 설정 */
long k, lRowCount

lRowCount = this.RowCount()

FOR k = 1 TO lRowCount
   IF NewModified! = this.GetItemStatus(k, 0, Primary!) THEN
 	   This.SetItem(k,'crt_user',gs_userid)
   ELSEIF DataModified! = this.GetItemStatus(k, 0, Primary!) THEN 		
	   This.SetItem(k,'upd_user',gs_userid)
   END IF	  
NEXT


end event

event dw_insert::rbuttondown;long	lRow
lRow  = this.GetRow()	

gs_code = ''
gs_codename = ''
gs_gubun = ''

if this.getcolumnname() = "project_no" 	then
	gs_gubun = '1'
	open(w_project_popup)
	if isnull(gs_code)  or  gs_code = ''	then	return
	this.setitem(lRow, "project_no", gs_code)
END IF



end event

event dw_insert::buttonclicked;string ls_baljpno
integer li_balseq

setnull(gs_code)
setnull(gs_gubun)

if dwo.name = "btn" then 
   ls_baljpno = this.getitemstring( 1, "baljpno" ) 
	li_balseq =  this.getitemnumber( row, "balseq" )

   gs_code = ls_baljpno
	gs_gubun = string(li_balseq)
	
	open(w_imt_02040_popup) 
	
end if
end event

type p_delrow from w_inherite`p_delrow within w_imt_02040
integer x = 3991
integer y = 3272
end type

type p_addrow from w_inherite`p_addrow within w_imt_02040
integer x = 3817
integer y = 3272
end type

type p_search from w_inherite`p_search within w_imt_02040
integer x = 3273
integer y = 20
integer width = 306
boolean enabled = false
string picturename = "C:\erpman\image\특기사항등록_d.gif"
end type

event p_search::clicked;call super::clicked;if dw_1.AcceptText() = -1 then return 

gs_code = trim(dw_1.GetItemString(1,'baljpno'))

if isnull(gs_code) or gs_code = "" then
	f_message_chk(30,'[발주번호]')
	dw_1.Setcolumn('baljpno')
	dw_1.SetFocus()
	return
end if	

open(w_imt_02041)
end event

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\특기사항등록_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\특기사항등록_up.gif"
end event

type p_ins from w_inherite`p_ins within w_imt_02040
integer x = 3643
integer y = 3272
end type

type p_exit from w_inherite`p_exit within w_imt_02040
integer x = 4430
end type

type p_can from w_inherite`p_can within w_imt_02040
integer x = 4256
end type

event p_can::clicked;call super::clicked;wf_reset()
ib_any_typing = FALSE



end event

type p_print from w_inherite`p_print within w_imt_02040
boolean visible = false
integer x = 3570
integer y = 20
integer width = 306
string pointer = "C:\erpman\cur\point.cur"
boolean enabled = false
boolean originalsize = true
string picturename = "C:\erpman\image\일괄발주취소_up.gif"
end type

event p_print::clicked;call super::clicked;string sBalsts, sOpt
long   k

FOR k=1 TO dw_insert.rowcount()
	sBalsts = dw_insert.getitemstring(k, 'balsts')
	sOpt    = dw_insert.getitemstring(k, 'opt')
	
	if sbalsts = '2' or sopt = 'N' then continue
	
	dw_insert.setitem(k, 'balsts', '4')
	
NEXT

end event

event p_print::ue_lbuttondown;PictureName = "C:\erpman\image\일괄발주취소_dn.gif"
end event

event p_print::ue_lbuttonup;PictureName = "C:\erpman\image\일괄발주취소_up.gif"
end event

type p_inq from w_inherite`p_inq within w_imt_02040
integer x = 3909
end type

event p_inq::clicked;call super::clicked;string s_empno

if 	dw_1.AcceptText() = -1 then return 

s_empno = trim(dw_1.GetItemString(1,'baljpno'))

if 	isnull(s_empno) or s_empno = "" then
	f_message_chk(30,'[발주번호]')
	dw_1.Setcolumn('baljpno')
	dw_1.SetFocus()
   	cb_search.enabled = false
	return
end if	

if 	dw_insert.Retrieve(gs_sabu, s_empno) <= 0 then 
	f_message_chk(50,'')
	dw_1.Setcolumn('baljpno')
	dw_1.SetFocus()
else
	wf_baljpno_chk()
	dw_insert.accepttext()
end if	
	
// 내자발주인 경우에는 통화단위 수정불가
if 	dw_1.getitemstring(1, "pomast_bal_suip") = '1' then
//	dw_insert.object.poblkt_tuncu.background.color = 79741120
	dw_insert.object.poblkt_tuncu.protect = 1
end if
	
ib_any_typing = FALSE

p_search.enabled = true
p_search.picturename = 'c:\erpman\image\특기사항등록_up.gif'



end event

type p_del from w_inherite`p_del within w_imt_02040
integer x = 4338
integer y = 3272
end type

type p_mod from w_inherite`p_mod within w_imt_02040
integer x = 4082
end type

event p_mod::clicked;call super::clicked;Int i

if dw_insert.AcceptText() = -1 then return 
if dw_1.AcceptText() = -1 then return 

if dw_insert.rowcount() <= 0 then
	return 
end if	

FOR i = 1 TO dw_insert.RowCount()
	IF wf_required_chk(i) = -1 THEN RETURN
NEXT

if f_msg_update() = -1 then return

if dw_1.update() = 1 then
	if dw_insert.update() = 1 then
		w_mdi_frame.sle_msg.text = "자료가 저장되었습니다!!"
		ib_any_typing= FALSE
		commit ;
	else
		rollback ;
		messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
		return 
   end if	
else
	rollback ;
	messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
	return 
end if	

p_inq.TriggerEvent(Clicked!) 
end event

type cb_exit from w_inherite`cb_exit within w_imt_02040
integer x = 3406
integer y = 3152
integer taborder = 70
end type

type cb_mod from w_inherite`cb_mod within w_imt_02040
integer x = 2702
integer y = 3152
integer taborder = 50
end type

type cb_ins from w_inherite`cb_ins within w_imt_02040
integer x = 613
integer y = 2368
string text = "추가(&A)"
end type

event cb_ins::clicked;call super::clicked;//int  i, il_currow, il_rowcount
//string s_gub, s_lms, s_large, s_mid
//
//if dw_1.AcceptText() = -1 then return 
//
//s_lms = dw_1.GetItemString(1,'lmsgub')
//s_gub = dw_1.GetItemString(1,'sittyp')
//
//if isnull(s_gub) or s_gub = "" then
//	f_message_chk(30,'[품목구분]')
//	dw_1.SetColumn('sittyp')
//	dw_1.SetFocus()
//	return
//end if	
//
//if s_lms = 'L' then
//	
//	FOR i = 1 TO dw_insert.RowCount()
//		IF wf_required_chk(i) = -1 THEN RETURN
//	NEXT
//	
//	IF dw_insert.RowCount() <=0 THEN
//		il_currow = 0
//		il_rowCount = 0
//	ELSE
//		il_currow = dw_insert.GetRow()
//		il_RowCount = dw_insert.RowCount()
//		
//		IF il_currow <=0 THEN
//			il_currow = il_RowCount
//		END IF
//	END IF
//	
//	il_currow = il_currow + 1
//	dw_insert.InsertRow(il_currow)
//	
//	dw_insert.setitem(il_currow, 'ittyp', s_gub )
//	
//	dw_insert.ScrollToRow(il_currow)
//	dw_insert.SetColumn('itcls')
//	dw_insert.SetFocus()
//	
//elseif s_lms = 'M' then
//	
//	s_large = dw_1.GetItemString(1,'large')
//	
//	if isnull(s_large) or s_large = "" then
//		f_message_chk(30,'[대분류코드]')
//    	dw_1.SetColumn('large')
//		dw_1.SetFocus()
//		return
//	end if	
//
//	FOR i = 1 TO dw_insert.RowCount()
//		IF wf_required_chk(i) = -1 THEN RETURN
//	NEXT
//	
//	IF dw_insert.RowCount() <=0 THEN
//		il_currow = 0
//		il_rowCount = 0
//	ELSE
//		il_currow = dw_insert.GetRow()
//		il_RowCount = dw_insert.RowCount()
//		
//		IF il_currow <=0 THEN
//			il_currow = il_RowCount
//		END IF
//	END IF
//	
//	il_currow = il_currow + 1
//	dw_insert.InsertRow(il_currow)
//	
//	dw_insert.setitem(il_currow, 'ittyp', s_gub )
//   dw_insert.setitem(il_currow, 'itcls', s_large )
//		
//   dw_insert.ScrollToRow(il_currow)
//	dw_insert.SetColumn('mtcls')
//	dw_insert.SetFocus()
//elseif s_lms = 'S' then
//	s_mid = dw_1.GetItemString(1,'mid')
//	
//	if isnull(s_mid) or s_mid = "" then
//		f_message_chk(30,'[중분류코드]')
//    	dw_1.SetColumn('mid')
//		dw_1.SetFocus()
//		return
//	end if	
//
//	FOR i = 1 TO dw_insert.RowCount()
//		IF wf_required_chk(i) = -1 THEN RETURN
//	NEXT
//	
//	IF dw_insert.RowCount() <=0 THEN
//		il_currow = 0
//		il_rowCount = 0
//	ELSE
//		il_currow = dw_insert.GetRow()
//		il_RowCount = dw_insert.RowCount()
//		
//		IF il_currow <=0 THEN
//			il_currow = il_RowCount
//		END IF
//	END IF
//	
//	il_currow = il_currow + 1
//	dw_insert.InsertRow(il_currow)
//	
//	dw_insert.setitem(il_currow, 'ittyp', s_gub )
//   dw_insert.setitem(il_currow, 'itcls', s_mid )
//		
//   dw_insert.ScrollToRow(il_currow)
//	dw_insert.SetColumn('stcls')
//	dw_insert.SetFocus()
//end if
//
end event

type cb_del from w_inherite`cb_del within w_imt_02040
integer x = 2542
integer y = 2376
boolean enabled = false
end type

event cb_del::clicked;call super::clicked;//long i, irow, irow2
//long get_count, i_seq
//string s_lms, s_itcls, s_gub, sbaljpno
//
//if dw_insert.AcceptText() = -1 then return 
//if dw_1.AcceptText() = -1 then return 
//
//if dw_insert.rowcount() <= 0 then return 
//
//string sopt
//
//sopt = dw_insert.getitemstring(dw_insert.getrow(), 'opt')
//
//if sopt = 'N' then 
//	messagebox("확 인", "구매 L/C 에 등록된 자료는 삭제할 수 없습니다!!")
//   return 
//end if
//
//irow = dw_insert.getrow() - 1
//irow2 = dw_insert.getrow() + 1
//if irow > 0 then   
//	FOR i = 1 TO irow
//		IF wf_required_chk(i) = -1 THEN RETURN
//	NEXT
//end if	
//
//FOR i = irow2 TO dw_insert.RowCount()
//	IF wf_required_chk(i) = -1 THEN RETURN
//NEXT
//
//if dw_insert.rowcount() > 1 then 
//	if MessageBox("삭 제","삭제 하시겠습니까?",Question!, YesNo!, 2) <> 1 then return
//else
//	if MessageBox("삭 제", "마지막 자료를 삭제하시면 발주에 모든 자료가 삭제됩니다. ~n~n" + &
//		              "삭제 하시겠습니까?",Question!, YesNo!, 2) <> 1 then return
//end if	
//
//dw_insert.SetRedraw(FALSE)
//dw_insert.DeleteRow(0)
//
//if dw_insert.Update() = 1 then
//	if dw_insert.rowcount() < 1 then 
//		sbaljpno = dw_1.getitemstring( 1, 'baljpno')
//		
//		DELETE FROM PORMKS  WHERE SABU = :gs_sabu AND BALJPNO =  :sbaljpno   ;
//
//      DELETE FROM POMAST  WHERE SABU = :gs_sabu AND BALJPNO =  :sbaljpno   ;
//
//      if sqlca.sqlcode <> 0 then 
//			rollback ;
//			messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
//			wf_reset()
//			dw_insert.SetRedraw(TRUE)
//			return 
//		end if	
//		commit ;
//		wf_reset()
//		sle_msg.text =	"자료를 삭제하였습니다!!"	
//		ib_any_typing = false
//		dw_insert.SetRedraw(TRUE)
//		return 
//	end if	
//	sle_msg.text =	"자료를 삭제하였습니다!!"	
//	ib_any_typing = false
//	commit ;
//else
//	rollback ;
//   messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
//	wf_reset()
//end if	
//
//dw_insert.SetRedraw(TRUE)
//
end event

type cb_inq from w_inherite`cb_inq within w_imt_02040
integer x = 1824
integer y = 3144
integer taborder = 30
end type

type cb_print from w_inherite`cb_print within w_imt_02040
integer x = 2176
integer y = 3144
integer width = 507
integer taborder = 40
string text = "일괄 발주취소"
end type

type st_1 from w_inherite`st_1 within w_imt_02040
integer x = 23
end type

type cb_can from w_inherite`cb_can within w_imt_02040
integer x = 3054
integer y = 3152
end type

type cb_search from w_inherite`cb_search within w_imt_02040
integer x = 3767
integer y = 3156
integer width = 434
boolean enabled = false
string text = "특기사항등록"
end type

type dw_datetime from w_inherite`dw_datetime within w_imt_02040
integer x = 2866
end type

type sle_msg from w_inherite`sle_msg within w_imt_02040
integer x = 375
end type

type gb_10 from w_inherite`gb_10 within w_imt_02040
integer x = 142
integer y = 3124
integer height = 144
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

type gb_button1 from w_inherite`gb_button1 within w_imt_02040
end type

type gb_button2 from w_inherite`gb_button2 within w_imt_02040
end type

type dw_1 from datawindow within w_imt_02040
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 64
integer y = 20
integer width = 3077
integer height = 368
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_imt_02040_a"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;string snull, sbaljno, get_nm, sgbn

setnull(snull)

IF this.GetColumnName() ="baljpno" THEN
	sbaljno = trim(this.GetText())
	
	IF	Isnull(sbaljno)  or  sbaljno = ''	Then
		wf_reset()
		RETURN 
   END IF

  SELECT "POMAST"."BALJPNO", 
  			"POMAST"."BALGU" 
    INTO :get_nm, :sgbn  
    FROM "POMAST"  
   WHERE ( "POMAST"."SABU" = :gs_sabu ) AND  
         ( "POMAST"."BALJPNO" = :sbaljno )   ;

	IF SQLCA.SQLCODE <> 0 then 
		this.triggerevent(rbuttondown!)
		IF gs_code ="" OR IsNull(gs_code) THEN
   		wf_reset()
      END IF
      RETURN 1
	Elseif sgbn = '3' then
		Messagebox("발주내역", "외주발주 내역은 수정할 수 없읍니다", stopsign!)
  		wf_reset()		
		return 1
   ELSE
      this.retrieve(gs_sabu, sbaljno)
		cb_inq.triggerevent(clicked!)
	END IF
END IF

end event

event itemerror;return 1
end event

event rbuttondown;setnull(gs_code)
setnull(gs_codename)

IF this.GetColumnName() = "baljpno" THEN
	gs_gubun = '1' //발주지시상태 => 1:의뢰
	
	open(w_poblkt_popup)
	
	IF isnull(gs_Code)  or  gs_Code = ''	then  RETURN

   this.retrieve(gs_sabu, gs_code)

   TriggerEvent(itemchanged!)

END IF	
end event

type pb_1 from u_pb_cal within w_imt_02040
integer x = 905
integer y = 112
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_1.SetColumn('pomast_baldate')
IF IsNull(gs_code) THEN Return
ll_row = dw_1.GetRow()
If ll_row < 1 Then Return
dw_1.SetItem(ll_row, 'pomast_baldate', gs_code)



end event

type pb_2 from u_pb_cal within w_imt_02040
integer x = 2761
integer y = 268
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_1.SetColumn('pomast_plnopn')
IF IsNull(gs_code) THEN Return
ll_row = dw_1.GetRow()
If ll_row < 1 Then Return
dw_1.SetItem(ll_row, 'pomast_plnopn', gs_code)



end event

type rr_1 from roundrectangle within w_imt_02040
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 69
integer y = 388
integer width = 4530
integer height = 1920
integer cornerheight = 40
integer cornerwidth = 55
end type

