$PBExportHeader$w_pdt_t_10250.srw
$PBExportComments$** 비가동 금액집계
forward
global type w_pdt_t_10250 from w_standard_print
end type
type p_create from picture within w_pdt_t_10250
end type
type p_delete from picture within w_pdt_t_10250
end type
type rr_1 from roundrectangle within w_pdt_t_10250
end type
end forward

global type w_pdt_t_10250 from w_standard_print
string title = "비가동 금액집계"
p_create p_create
p_delete p_delete
rr_1 rr_1
end type
global w_pdt_t_10250 w_pdt_t_10250

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();
String sYYMM, sGubn, snull, scvcod, scodeto

setnull(snull)

If 	dw_ip.AcceptText() <> 1 then Return 1

sYYMM       	= trim(dw_ip.GetItemString(1,"ntyymm"))
scvcod   		= trim(dw_ip.GetItemString(1,"cvcod"))
scodeTo     	= trim(dw_ip.GetItemString(1,"cvcodto"))

IF 	sYYMM ="" OR IsNull(sYYMM) THEN sYYMM =  left(f_today(),6)


IF 	scvcod = "" OR isnull(scvcod) THEN
  	SELECT MIN("VNDMST"."CVCOD")  
	    	INTO :scvcod  
  	 	FROM "VNDMST"  
	   	WHERE ( "VNDMST"."SABU" = :gs_sabu ) AND  
            ( "VNDMST"."CVGU" IN ('1' ,'2')) ;                           // - 거래처 ( 1: 국내 , 2:국외)
END IF

IF 	scodeTo = "" OR isnull(scodeTo) THEN
	SELECT MAX("VNDMST"."CVCOD")  
	    	INTO :scodeTo  
  	 	FROM "VNDMST"  
	   	WHERE ( "VNDMST"."SABU" = :gs_sabu ) AND  
            ( "VNDMST"."CVGU" IN ('1', '2') )   ;                        // - 거래처 ( 1: 국내 , 2:국외)
END IF	

IF	( scvcod > scodeTo  )	  then
	MessageBox("확인","거래처의 범위를 확인하세요!")
	dw_ip.setcolumn('cvcod')
	dw_ip.setfocus()
	Return -1
END IF

p_delete.enabled 		= false
p_delete.PictureName	= "C:\erpman\image\삭제_d.gif"   

IF 	dw_print.Retrieve(gs_sabu, sYYMM ,scvcod, scodeto) <=0 THEN
	f_message_chk(50,'')
   	dw_ip.setcolumn('ntYYMM')
	dw_ip.SetFocus()
	Return -1
END IF

p_delete.enabled 		= true
p_delete.PictureName 	= "C:\erpman\image\삭제_up.gif"   

dw_print.sharedata(dw_list)
Return 1




end function

on w_pdt_t_10250.create
int iCurrent
call super::create
this.p_create=create p_create
this.p_delete=create p_delete
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_create
this.Control[iCurrent+2]=this.p_delete
this.Control[iCurrent+3]=this.rr_1
end on

on w_pdt_t_10250.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.p_create)
destroy(this.p_delete)
destroy(this.rr_1)
end on

event open;call super::open;
dw_ip.setitem(1, "ntyymm", left(f_today(),6))

dw_ip.Setfocus()


end event

type p_preview from w_standard_print`p_preview within w_pdt_t_10250
integer x = 4073
end type

type p_exit from w_standard_print`p_exit within w_pdt_t_10250
integer x = 4439
end type

type p_print from w_standard_print`p_print within w_pdt_t_10250
integer x = 4256
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_t_10250
integer x = 3890
end type











type dw_print from w_standard_print`dw_print within w_pdt_t_10250
integer x = 2990
integer y = 48
string dataobject = "d_pdt_t_10250_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_t_10250
integer x = 293
integer y = 84
integer width = 2587
integer height = 124
string dataobject = "d_pdt_t_10250_1"
end type

event dw_ip::itemerror;
Return 1
end event

event dw_ip::rbuttondown;Long i

SetNull(gs_code)
SetNull(gs_codename)

i = this.GetRow()

Choose   Case this.getcolumnname()
	Case 	"cvcod"
   		gs_gubun = '1'   
		gi_page = -1 
		Open(w_vndmst_popup)
		gi_page = 0 
		IF isnull(gs_Code)  or  gs_Code = ''	then  return
		SetItem(i, "cvcod", gs_Code)
		this.TriggerEvent(ItemChanged!)
	Case 	"cvcodto"
   		gs_gubun = '1'   
		gi_page = -1 
		Open(w_vndmst_popup)
		gi_page = 0 
		IF isnull(gs_Code)  or  gs_Code = ''	then  return
		SetItem(i, "cvcodto", gs_Code)
		this.TriggerEvent(ItemChanged!)
End Choose

end event

event dw_ip::itemchanged;string snull, syymm, sCvcod, sname1, sname2
int    ireturn 

SetNull(snull)

IF 	this.GetColumnName() = "cvcod"	THEN
	sCvcod 	= trim(this.gettext())
	ireturn		= f_get_name2('V0', 'Y', sCvcod, sname1, sname2)    //1이면 실패, 0이 성공	
	this.setitem(1, 'cvcod', sCvcod)
	this.setitem(1, 'cvnas2',  sname1)
	return ireturn
ELSEIF this.GetColumnName() = "cvcodto"	THEN
	sCvcod 	= trim(this.gettext())
	ireturn		= f_get_name2('V0', 'Y', sCvcod, sname1, sname2)    //1이면 실패, 0이 성공	
	this.setitem(1, 'cvcodto', sCvcod)
	this.setitem(1, 'cvnas2to',  sname1)
	return ireturn
END IF 

return
end event

type dw_list from w_standard_print`dw_list within w_pdt_t_10250
integer x = 293
integer y = 344
integer width = 4027
integer height = 1952
string dataobject = "d_pdt_t_10250_2"
boolean border = false
boolean hsplitscroll = false
end type

event dw_list::itemchanged;call super::itemchanged;string sChk, sMayymm

sMayymm 	= this.GetItemString(row, 'mayymm')
IF 	this.GetColumnName() = 'chk' THEN
	sChk 		= this.gettext()
   	IF 	sChk 	= 'Y'   and  Not isnull(sMayymm) THEN 
		Messagebox("삭제취소확인","매입마감 처리되었습니다. ", stopsign!)
		RETURN 1
   END IF
End If
end event

event dw_list::itemerror;call super::itemerror;return 1
end event

type p_create from picture within w_pdt_t_10250
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 3525
integer y = 24
integer width = 178
integer height = 144
boolean bringtotop = true
string picturename = "C:\erpman\image\생성_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;PictureName = 'C:\erpman\image\생성_dn.gif'
end event

event ue_lbuttonup;PictureName = 'C:\erpman\image\생성_up.gif'
end event

event clicked;Long 	cnt , ld_seq
String	ls_yymm, ls_max

If dw_ip.AcceptText() <> 1 then Return

ls_yymm 		= dw_ip.GetItemString(1,'ntyymm')

/* 작업된 [비가동 집계]가  존재하는지 유무 Check */
Select max(ntseq), Count(*) Into :ls_max, :cnt  From NTTABL_SUM
 	Where sabu = :gs_sabu and ntyymm = :ls_yymm ;
		 
If 	cnt > 0 then
	// 이미 작업되어 있으면
	If 	MessageBox('Warning', '"' + ls_yymm + '"' + '월의 [비가동 집계]가 이미 수립되어 있습니다. ' + '~n~n' + &
					  '추가 [집계]작업 생성하겠습니까?', question!,yesno!, 2) = 2 THEN  
					  Return
	end if				  
End if	
					  
//SetPointer(HourGlass!)

If 	isnull(ls_max) then	
	ld_seq = 1
ElseIf  	integer(ls_max) = 0 	then 	
		MessageBox('확인', '"' + ls_yymm + '"  '  +'월의  ' + ls_max + '"' + ' 번의 [비가동 집계]에 작업순번. ' + '~n~n' + &
	                      '확인 하여주세요 !!')
		return
	Else		  
		ld_seq = integer(ls_max) + 1
End If	

ls_max = string(ld_seq)
w_mdi_frame.sle_msg.Text = '비가동 금액 집계 . 생성중입니다 !!!' 


INSERT INTO NTTABL_SUM
   SELECT  SABU, NTYYMM, :ld_seq as NTSEQ, CVCOD, JOCOD, NTAMT, NTCNT, null as MAYYMM, 0 AS MAYYSQ
          FROM
		  (SELECT   A.SABU AS SABU, SUBSTR(A.NTDAT,1,6) as NTYYMM  ,A.DPTNO as cvcod,  
		                A.JOCOD as jocod ,SUM(A.SAMOUNT) as ntamt , COUNT(*) as ntcnt 
					FROM 		NTTABL A, VNDMST V
                    WHERE   A.SABU = :gs_sabu   AND SUBSTR(A.NTDAT,1,6) = :ls_yymm
                        AND (A.NTYYMM IS NULL OR A.NTYYMM = '')
                        AND A.DPTNO = V.CVCOD   AND V.CVGU  IN ('1', '2')        
                    GROUP BY A.SABU, SUBSTR(A.NTDAT,1,6), A.DPTNO, A.JOCOD);
				// - 거래처 ( 1: 국내 , 2:국외)

w_mdi_frame.sle_msg.Text = ''

If sqlca.sqlcode <> 0 Then
	MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
	rollback;
	Return
End If

/* 작업된 [비가동 집계]가  존재하는지 유무 Check */
Select  Count(*) Into :cnt  From NTTABL_SUM
 	Where sabu = :gs_sabu and ntyymm = :ls_yymm and ntseq = :ld_seq ; 

if 	cnt > 0 then 
	// -- 비가동 내역의 처리사항은 읽어온것으로 처리 (이중 처리방지 목적)
	UPDATE NTTABL SET 	NTYYMM 	= :ls_yymm, 
								NTSEQ	= :ld_seq,
								CVCOD   	= DPTNO
		 WHERE   SABU = :gs_sabu   AND SUBSTR(NTDAT,1,6) = :ls_yymm
									AND (NTYYMM IS NULL OR NTYYMM = '');
	If sqlca.sqlcode <> 0 Then
		MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
		rollback;
		Return
	End If
	//+++++++++++++++++++++++++++++++++++++++++++++++
	f_message_Chk(202, '[비가동 금액 집계 생성]')	
     p_retrieve.TriggerEvent(Clicked!)
Else	  
	MessageBox('확인', '"' + ls_yymm + '"'  + '월의 자료가 없습니다 . ')
	return
End If



Commit;

end event

type p_delete from picture within w_pdt_t_10250
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 3707
integer y = 24
integer width = 178
integer height = 144
boolean bringtotop = true
boolean enabled = false
string picturename = "C:\erpman\image\삭제_d.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;PictureName = "C:\erpman\image\삭제_dn.gif"

end event

event ue_lbuttonup;PictureName = "C:\erpman\image\삭제_up.gif"

end event

event clicked;string 		sChk , sNtyymm, sCvcod, sJocod
integer 	nRow, nNtseq, ll_row, LSqlcode

w_mdi_frame.sle_msg.text =""
dw_list.AcceptText()

IF dw_list.GetRow() <=0 THEN
	f_message_chk(36,'')
	Return
END IF

nRow 		= dw_list.GetRow()

sChk 		= dw_list.GetItemString(nRow, "chk")

sNtyymm	= dw_list.GetItemString(nRow, "ntyymm")
nNtseq 	= dw_list.GetItemNumber(nRow, "ntseq")
sCvcod	= dw_list.GetItemString(nRow, "cvcod")
sJocod	= dw_list.GetItemString(nRow, "jocod")

if	sChk = "Y"	then
	////기존의 입력된 data와 중복되는 것을 피하기 위해 (primary key)///////////////////////////////////
	SELECT COUNT(*)                     
	  INTO :ll_row                               
	  FROM 	NTTABL
	 WHERE 	NTYYMM 	= :sNtyymm AND
			 	NTSEQ 	= :nNtseq and                  
			 	CVCOD 	= :sCvcod and
			 	JOCOD	= :sJocod;
	
	If ll_row > 0 then
		update NTTABL
			set 	NTYYMM 	= NULL,
				 	NTSEQ 	= 0,
				 	CVCOD 	= NULL
	 	WHERE 	NTYYMM 	= :sNtyymm AND
			 		NTSEQ 	= :nNtseq and                  
			 		CVCOD 	= :sCvcod and
			 		JOCOD	= :sJocod;
		if Sqlca.sqlcode = 0 then
			commit using sqlca;
		else
			MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
			rollback using sqlca ;
			return
		end if
	End If
	
	//+++++++++++++++++++
	dw_list.DeleteRow(0)

	dw_list.ScrollToRow(dw_list.RowCount())
	dw_list.Setfocus()
	
	//++++++++++++++++++++[ 입력 데이타 확인 ] 
	if 	dw_list.update() = -1 then
	   	rollback;		
		LSqlcode = dec(sqlca.sqlcode)
		f_message_chk(LSqlcode,'[자료삭제]') 
		return
	else
		commit;
	end if
	
End If

end event

type rr_1 from roundrectangle within w_pdt_t_10250
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 247
integer y = 312
integer width = 4087
integer height = 2000
integer cornerheight = 40
integer cornerwidth = 55
end type

