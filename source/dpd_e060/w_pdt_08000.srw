$PBExportHeader$w_pdt_08000.srw
$PBExportComments$외주발주수정
forward
global type w_pdt_08000 from w_inherite
end type
type gb_3 from groupbox within w_pdt_08000
end type
type gb_2 from groupbox within w_pdt_08000
end type
type dw_1 from datawindow within w_pdt_08000
end type
type p_acancel from uo_picture within w_pdt_08000
end type
type p_special from uo_picture within w_pdt_08000
end type
type rr_1 from roundrectangle within w_pdt_08000
end type
type rr_2 from roundrectangle within w_pdt_08000
end type
end forward

global type w_pdt_08000 from w_inherite
string title = "외주발주수정"
gb_3 gb_3
gb_2 gb_2
dw_1 dw_1
p_acancel p_acancel
p_special p_special
rr_1 rr_1
rr_2 rr_2
end type
global w_pdt_08000 w_pdt_08000

type variables

end variables

forward prototypes
public function integer wf_required_chk (integer i)
public function integer wf_baljpno_chk ()
public subroutine wf_reset ()
public function integer wf_delete (integer ix)
end prototypes

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

public subroutine wf_reset ();dw_1.setredraw(false)
dw_insert.setredraw(false)

dw_1.reset()
dw_insert.reset()

dw_1.insertrow(0)
dw_1.SetFocus()

p_special.enabled = false
p_special.PictureName = "C:\Erpman\image\특기사항등록_d.gif"



dw_1.setredraw(true)
dw_insert.setredraw(true)

end subroutine

public function integer wf_delete (integer ix);int    iseq, get_count
string sbaljpno, ls_balsts
Long  dSeq
//dwItemStatus l_status

//FOR 	k=1 TO dw_insert.rowcount()
//	ls_balsts	=	dw_insert.getitemstring(k, "balsts")
//	IF 	ls_balsts <> '4' 	then continue
//	l_status = dw_insert.GetItemStatus(k, "balsts", Primary!)
//     Choose Case l_status
//	 	Case datamodified!    // 기존상태가 변경된경우는 계속진행.
//
//		Case Else
//			 continue
//	End Choose
//	 
	sbaljpno 	= dw_insert.getitemstring(ix, 'baljpno')
	iseq     	= dw_insert.getitemnumber(ix, 'balseq')
	 // 구매의뢰 내역에 대한 자료를 수정
	 // 의뢰수량을 취소수량으로 변경
	 // 상태를 의뢰로 변경
	 UPDATE "ESTIMA"  
		 SET "BLYND" 	= '1',   
			  "BALJUTIME" = NULL,
			  "BALJPNO"   = NULL,
			  "BALSEQ"    = 0
	 WHERE ( "ESTIMA"."SABU" 	 = :gs_sabu ) AND  
			 ( "ESTIMA"."BALJPNO" = :sBaljpno ) AND  
			 ( "ESTIMA"."BALSEQ"  = :iSeq )   ;

	 If 	sqlca.sqlcode <> 0  then
		 Rollback;
		 Messagebox("확 인", "구매의뢰 자료 저장중 오류발생", stopsign!)
		 return -1
	 END IF	 		

					 
	 // 구매 취소 이력
	 dseq = 0
	 Select max(calseq) into :dseq from podel_history
	  where sabu = :gs_sabu and baljpno = :sbaljpno and balseq = :iSeq;
		  
	 if isnull(dseq) then dseq = 0
	 dseq = dseq + 1
		 
    INSERT INTO "PODEL_HISTORY"  
				( "SABU",        		"BALJPNO",       		"BALGU",       		"BALDATE",       	"CVCOD",   
				  "BAL_EMPNO",   	"BAL_SUIP",      		"PLNOPN",      	"PLNCRT",        	"PLNAPP",   
				  "PLNBNK",      		"BGUBUN",        		"BALSEQ",      	"ITNBR",         	"PSPEC",   
				  "OPSEQ",       		"GUDAT",         		"NADAT",       		"BALQTY",        	"RCQTY",   
				  "BFAQTY",      		"BPEQTY",        		"BTEQTY",      	"BJOQTY",        	"BCUQTY",   
				  "LCOQTY",      		"BLQTY",         		"ENTQTY",      	"LCBIPRC",       	"LCBIAMT",   
				  "ORDER_NO",    	"BALSTS",        		"ESTGU",       	"ESTNO",         	"SAYEO",   
				  "FNADAT",      		"TUNCU",         		"UNPRC",       	"UNAMT",         	"LSIDAT",   
				  "BQCQTYT",     		"BIPWQTY",       		"PORDNO",      	"CRT_DATE",      	"CRT_TIME",   
				  "CRT_USER",    		"UPD_DATE",      		"UPD_TIME",    	"UPD_USER",      "IPDPT",   
				  "CNVFAT",      		"CNVART",        		"CNVQTY",      	"CNVIPG",        	"CNVFAQ",   
				  "CNVBPE",      		"CNVBTE",        		"CNVBJO",      	"CNVQCT",        	"CNVCUQ",   
				  "CNVPRC",      		"CNVAMT",        		"CNVBLQ",      	"CNVENT",        	"CNVLCO",   
				  "CANDAT",             	"CALSEQ",      		"CANQTY",        	"CANCNV" )  
		 SELECT A.SABU, 	     		A.BALJPNO,       		B.BALGU, 	    	B.BALDATE, 	   	B.CVCOD, 
		       B.BAL_EMPNO, 	  	B.BAL_SUIP, 	    		B.PLNOPN,    	B.PLNCRT,     	B.PLNAPP,
				 B.PLNBNK, 		  	B.BGUBUN,		 	A.BALSEQ,	    	A.ITNBR,		   	A.PSPEC,	
				 A.OPSEQ,		  	A.GUDAT,			 	A.NADAT,	    		A.BALQTY,	     A.RCQTY,
				 A.BFAQTY,		  	A.BPEQTY,		 	A.BTEQTY,	    	A.BJOQTY,	     A.BCUQTY,
				 A.LCOQTY,		  	A.BLQTY,			 	A.ENTQTY,	    	A.LCBIPRC,	     A.LCBIAMT,
				 A.ORDER_NO,	  	A.BALSTS,		 	NULL,          		NULL,            	A.SAYEO,
				 A.FNADAT,       		A.TUNCU,		    		A.UNPRC,		 	A.UNAMT,		   	A.LSIDAT,
				 A.BQCQTYT, 	  	A.BIPWQTY, 	    		A.PORDNO,		 
				 TO_CHAR(SYSDATE, 'YYYYMMDD'), 	 	TO_CHAR(SYSDATE, 'HHMMSS'), 
				 :gs_userid,	  		NULL,				 	NULL,			 	NULL, 			   	A.IPDPT,	
				 A.CNVFAT,       		A.CNVART,        		A.CNVQTY,      	A.CNVIPG,        	A.CNVFAQ,
				 A.CNVBPE,		  	A.CNVBTE,        		A.CNVBJO,      	A.CNVQCT,        	A.CNVCUQ, 
				 A.CNVPRC,       		A.CNVAMT, 		 	A.CNVBLQ,      	A.CNVENT,        	A.CNVLCO, 
				 TO_CHAR(SYSDATE, 'YYYYMMDD'),	 	:dseq,         		A.BALQTY,        	A.CNVQTY 
		  FROM POBLKT A, POMAST B
		 WHERE A.SABU 	= :gs_sabu
			AND A.BALJPNO	= :SBALJPNO
			AND A.BALSEQ	= :iSeq
			AND A.SABU		= B.SABU
			AND A.BALJPNO	= B.BALJPNO;	 
				
		 If 	sqlca.sqlcode <> 0 or sqlca.sqlnrows < 1 then
			 Rollback;
			 Messagebox("구매취소이력", "구매취소 이력 자료저장중 오류발생", stopsign!)
			 return -1
		 END IF	 		
	  
//	  DELETE FROM "POBLKT"  
//		WHERE ( "POBLKT"."SABU" 	= :gs_sabu ) AND  
//				( "POBLKT"."BALJPNO" = :sBaljpno ) AND  
//				( "POBLKT"."BALSEQ" 	= :iSeq )   ;
//		
//	 If 	sqlca.sqlcode <> 0 or sqlca.sqlnrows < 1 then
//		 Rollback;
//		 Messagebox("구매의뢰 변경", "자료저장중 오류발생", stopsign!)
//		 return -1
//	 else	 
//		select count(*) into :get_count from poblkt 
//		 where sabu = :gs_sabu and baljpno = :sBaljpno ;
//
//		 if 	get_count < 1 then 
//     			DELETE FROM "POMAST"  
//			  WHERE ( "POMAST"."SABU" = :gs_sabu ) AND  
//				     ( "POMAST"."BALJPNO" = :sBaljpno )   ;
//					  
//  			 If 	sqlca.sqlcode <> 0  then
//				Rollback;
//				Messagebox("발주삭제", "발주자료 삭제중 오류발생", stopsign!)
//				return -1
//			 END IF	 		
//
//		 end if
//	 end if
//	
//NEXT

return 1
end function

on w_pdt_08000.create
int iCurrent
call super::create
this.gb_3=create gb_3
this.gb_2=create gb_2
this.dw_1=create dw_1
this.p_acancel=create p_acancel
this.p_special=create p_special
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_3
this.Control[iCurrent+2]=this.gb_2
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.p_acancel
this.Control[iCurrent+5]=this.p_special
this.Control[iCurrent+6]=this.rr_1
this.Control[iCurrent+7]=this.rr_2
end on

on w_pdt_08000.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_3)
destroy(this.gb_2)
destroy(this.dw_1)
destroy(this.p_acancel)
destroy(this.p_special)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_insert.SetTransObject(sqlca)
dw_1.SetTransObject(sqlca)
dw_1.insertrow(0)
dw_1.SetFocus()
IF f_change_name('1') = 'Y' then 
//	dw_insert.Object.ispec_t.text =  f_change_name('2')
//	dw_insert.Object.jijil_t.text =  f_change_name('3')
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

type dw_insert from w_inherite`dw_insert within w_pdt_08000
integer x = 183
integer y = 416
integer width = 4187
integer height = 1852
integer taborder = 20
string dataobject = "d_pdt_08000"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event dw_insert::ue_pressenter;Send(Handle(this),256,9,0)
Return 1

end event

event dw_insert::itemchanged;String sData, sPrvdata, scvcod, sPordno, get_pdsts, sproject, scode
Decimal {5} dPrvdata, dData

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
	
End if
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

type p_delrow from w_inherite`p_delrow within w_pdt_08000
boolean visible = false
integer x = 3867
integer y = 2928
end type

type p_addrow from w_inherite`p_addrow within w_pdt_08000
boolean visible = false
integer x = 3694
integer y = 2928
end type

type p_search from w_inherite`p_search within w_pdt_08000
boolean visible = false
integer x = 4256
integer y = 2944
end type

type p_ins from w_inherite`p_ins within w_pdt_08000
boolean visible = false
integer x = 3520
integer y = 2928
end type

type p_exit from w_inherite`p_exit within w_pdt_08000
end type

type p_can from w_inherite`p_can within w_pdt_08000
end type

event p_can::clicked;call super::clicked;wf_reset()
ib_any_typing = FALSE



end event

type p_print from w_inherite`p_print within w_pdt_08000
boolean visible = false
integer x = 4407
integer y = 2948
end type

type p_inq from w_inherite`p_inq within w_pdt_08000
integer x = 3323
integer y = 28
end type

event p_inq::clicked;call super::clicked;string s_empno

if dw_1.AcceptText() = -1 then return 

s_empno = trim(dw_1.GetItemString(1,'baljpno'))

if isnull(s_empno) or s_empno = "" then
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
	
ib_any_typing = FALSE

p_special.enabled = true
p_special.PictureName = "C:\Erpman\image\특기사항등록_up.gif"



end event

type p_del from w_inherite`p_del within w_pdt_08000
boolean visible = false
integer x = 4050
integer y = 2932
end type

type p_mod from w_inherite`p_mod within w_pdt_08000
integer x = 4096
end type

event p_mod::clicked;call super::clicked;Int i , ix
String ls_balsts, ls_oldsts, sbaljpno
dwItemStatus l_status

if dw_insert.AcceptText() = -1 then return 
if dw_1.AcceptText() = -1 then return 

if dw_insert.rowcount() <= 0 then
	return 
end if	

FOR i = 1 TO dw_insert.RowCount()
	IF 	wf_required_chk(i) = -1 THEN RETURN
NEXT

if	f_msg_update() = -1 then return

		//------------------------------- 발주취소에 따른 관련 의뢰사항도 삭제.
          i = 0
		FOR 	ix=1 TO dw_insert.rowcount()
			ls_balsts	=	dw_insert.getitemstring(ix, "balsts")
			ls_oldsts 	=	dw_insert.getitemstring(ix, "old_balsts")
			IF 	ls_balsts <> '4' 	then 
				i++
				continue
			End If
			If	ls_balsts = ls_oldsts	then continue	
			IF 	wf_delete(ix) = -1 THEN 
				RollBack;
				dw_INSERT.ScrollToRow (ix)
				dw_insert.SetColumn("balsts")
				dw_insert.SetFocus()
				messagebox("저장실패", "발주데이타 취소 처리가 실패하였습니다.")
				RETURN
			End If
			dw_insert.SetItem(ix, "chk", 'N')

		Next
		IF	dw_insert.rowcount() = 0 then
			sbaljpno 	= dw_1.getitemstring(1, 'baljpno')
     			DELETE FROM "POMAST"  
			  WHERE ( "POMAST"."SABU" = :gs_sabu ) AND  
				     ( "POMAST"."BALJPNO" = :sBaljpno )   ;
					  
  			 If 	sqlca.sqlcode <> 0  then
				Rollback;
				Messagebox("발주삭제", "발주자료 삭제중 오류발생", stopsign!)
				return -1
			 END IF	 		
		End If	
		COMMIT;
	/*---------------------------------------------------------------------*/
//If	i > 0	then	         // --- 취소처리하지 않는것에 대해서는 update하여야 하므로.
	if 	dw_1.update() = 1 then
		if 	dw_insert.update() = 1 then
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
//End If

p_inq.TriggerEvent(Clicked!)
end event

type cb_exit from w_inherite`cb_exit within w_pdt_08000
boolean visible = false
integer x = 3241
integer y = 2832
integer taborder = 70
end type

type cb_mod from w_inherite`cb_mod within w_pdt_08000
boolean visible = false
integer x = 2537
integer y = 2832
integer taborder = 50
end type

event cb_mod::clicked;call super::clicked;Int i

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
		sle_msg.text = "자료가 저장되었습니다!!"
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

cb_inq.TriggerEvent(Clicked!)
end event

type cb_ins from w_inherite`cb_ins within w_pdt_08000
boolean visible = false
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

type cb_del from w_inherite`cb_del within w_pdt_08000
boolean visible = false
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

type cb_inq from w_inherite`cb_inq within w_pdt_08000
boolean visible = false
integer x = 105
integer y = 2832
integer taborder = 30
end type

event cb_inq::clicked;call super::clicked;string s_empno

if dw_1.AcceptText() = -1 then return 

s_empno = trim(dw_1.GetItemString(1,'baljpno'))

if isnull(s_empno) or s_empno = "" then
	f_message_chk(30,'[발주번호]')
	dw_1.Setcolumn('baljpno')
	dw_1.SetFocus()
   cb_search.enabled = false
	return
end if	

if dw_insert.Retrieve(gs_sabu, s_empno) <= 0 then 
	f_message_chk(50,'')
	dw_1.Setcolumn('baljpno')
	dw_1.SetFocus()
else
	wf_baljpno_chk()
	dw_insert.accepttext()
end if	
	
ib_any_typing = FALSE

cb_search.enabled = true



end event

type cb_print from w_inherite`cb_print within w_pdt_08000
boolean visible = false
integer x = 457
integer y = 2832
integer width = 507
integer taborder = 40
string text = "일괄 발주취소"
end type

event cb_print::clicked;call super::clicked;string sBalsts, sOpt
long   k

FOR k=1 TO dw_insert.rowcount()
	sBalsts = dw_insert.getitemstring(k, 'balsts')
	sOpt    = dw_insert.getitemstring(k, 'opt')
	
	if sbalsts = '2' or sopt = 'N' then continue
	
	dw_insert.setitem(k, 'balsts', '4')
	
NEXT

end event

type st_1 from w_inherite`st_1 within w_pdt_08000
integer x = 23
end type

type cb_can from w_inherite`cb_can within w_pdt_08000
boolean visible = false
integer x = 2889
integer y = 2832
end type

event cb_can::clicked;call super::clicked;wf_reset()
ib_any_typing = FALSE



end event

type cb_search from w_inherite`cb_search within w_pdt_08000
boolean visible = false
integer x = 2263
integer y = 3096
integer width = 434
integer height = 312
integer taborder = 80
boolean enabled = false
string text = "특기사항등록"
end type

event cb_search::clicked;call super::clicked;if dw_1.AcceptText() = -1 then return 

gs_code = trim(dw_1.GetItemString(1,'baljpno'))

if isnull(gs_code) or gs_code = "" then
	f_message_chk(30,'[발주번호]')
	dw_1.Setcolumn('baljpno')
	dw_1.SetFocus()
	return
end if	

open(w_imt_02041)
end event

type dw_datetime from w_inherite`dw_datetime within w_pdt_08000
integer x = 2866
end type

type sle_msg from w_inherite`sle_msg within w_pdt_08000
integer x = 375
end type

type gb_10 from w_inherite`gb_10 within w_pdt_08000
integer x = 18
integer y = 2756
integer height = 144
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

type gb_button1 from w_inherite`gb_button1 within w_pdt_08000
end type

type gb_button2 from w_inherite`gb_button2 within w_pdt_08000
end type

type gb_3 from groupbox within w_pdt_08000
boolean visible = false
integer x = 2482
integer y = 2784
integer width = 1138
integer height = 176
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 79741120
end type

type gb_2 from groupbox within w_pdt_08000
boolean visible = false
integer x = 69
integer y = 2784
integer width = 933
integer height = 176
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 79741120
end type

type dw_1 from datawindow within w_pdt_08000
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 201
integer y = 44
integer width = 2999
integer height = 336
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

event itemchanged;string snull, sbaljno, get_nm, sGubun 

setnull(snull)

IF this.GetColumnName() ="baljpno" THEN
	sbaljno = trim(this.GetText())
	
	IF	Isnull(sbaljno)  or  sbaljno = ''	Then
		wf_reset()
		RETURN 
   END IF

  SELECT "POMAST"."BALJPNO", 
  			"POMAST"."BALGU" 
    INTO :get_nm, :sGubun  
    FROM "POMAST"  
   WHERE ( "POMAST"."SABU" = :gs_sabu ) AND  
         ( "POMAST"."BALJPNO" = :sbaljno )   ;

	IF SQLCA.SQLCODE <> 0 Then
		this.triggerevent(rbuttondown!)
		IF gs_code ="" OR IsNull(gs_code) THEN
   		wf_reset()
      END IF
      RETURN 1
	ElseIF sGubun <> '3' Then
		Messagebox("발주번호", "외주발주내역이 아닙니다", stopsign!)
      RETURN 1		
   ELSE
      this.retrieve(gs_sabu, sbaljno)
		p_inq.triggerevent(clicked!)
	END IF
END IF

end event

event itemerror;return 1
end event

event rbuttondown;setnull(gs_code)
setnull(gs_codename)

String sGubun

IF this.GetColumnName() = "baljpno" THEN
	gs_gubun = '1' //발주지시상태 => 1:의뢰
	gs_code  = '3' //발주구분 => 외주
	open(w_poblkt_popup)
	
	IF isnull(gs_Code)  or  gs_Code = ''	then  RETURN
	
  SELECT "POMAST"."BALGU" 
    INTO :sGubun  
    FROM "POMAST"  
   WHERE ( "POMAST"."SABU" = :gs_sabu ) AND  
         ( "POMAST"."BALJPNO" = :gs_code )   ;

	IF SQLCA.SQLCODE <> 0 Then
		IF gs_code ="" OR IsNull(gs_code) THEN
   		wf_reset()
      END IF
      RETURN 1
	ElseIF sGubun <> '3' Then
		Messagebox("발주번호", "외주발주내역이 아닙니다", stopsign!)
      RETURN 1			
	end if
	
   this.retrieve(gs_sabu, gs_code)

   cb_inq.TriggerEvent(Clicked!)

   return 1 

END IF	
end event

type p_acancel from uo_picture within w_pdt_08000
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 3794
integer y = 28
integer width = 306
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\erpman\image\일괄발주취소_up.gif"
end type

event ue_lbuttondown;PictureName = "C:\erpman\image\일괄발주취소_dn.gif"
end event

event ue_lbuttonup;PictureName = "C:\erpman\image\일괄발주취소_up.gif"
end event

event clicked;call super::clicked;string sBalsts, sOpt
long   k

FOR k=1 TO dw_insert.rowcount()
	sBalsts = dw_insert.getitemstring(k, 'balsts')
	sOpt    = dw_insert.getitemstring(k, 'opt')
	
	if sbalsts = '2' or sopt = 'N' then continue
	
	dw_insert.setitem(k, 'balsts', '4')
	
NEXT

end event

type p_special from uo_picture within w_pdt_08000
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 3497
integer y = 28
integer width = 306
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\Erpman\image\특기사항등록_up.gif"
end type

event ue_lbuttondown;PictureName = "C:\erpman\image\특기사항등록_dn.gif"
end event

event ue_lbuttonup;PictureName = "C:\erpman\image\특기사항등록_up.gif"
end event

event clicked;call super::clicked;if dw_1.AcceptText() = -1 then return 

gs_code = trim(dw_1.GetItemString(1,'baljpno'))

if isnull(gs_code) or gs_code = "" then
	f_message_chk(30,'[발주번호]')
	dw_1.Setcolumn('baljpno')
	dw_1.SetFocus()
	return
end if	

open(w_imt_02041)
end event

type rr_1 from roundrectangle within w_pdt_08000
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 192
integer y = 36
integer width = 3022
integer height = 356
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_2 from roundrectangle within w_pdt_08000
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 174
integer y = 412
integer width = 4219
integer height = 1908
integer cornerheight = 40
integer cornerwidth = 46
end type

