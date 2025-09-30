$PBExportHeader$w_pdm_01040_kvnd.srw
$PBExportComments$** 거래처 등록(관련업체 등록)
forward
global type w_pdm_01040_kvnd from window
end type
type p_exit from uo_picture within w_pdm_01040_kvnd
end type
type p_del from uo_picture within w_pdm_01040_kvnd
end type
type p_mod from uo_picture within w_pdm_01040_kvnd
end type
type dw_detail from datawindow within w_pdm_01040_kvnd
end type
end forward

global type w_pdm_01040_kvnd from window
integer x = 1221
integer y = 676
integer width = 1563
integer height = 888
boolean titlebar = true
string title = "관련업체 등록 및 수정"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_exit p_exit
p_del p_del
p_mod p_mod
dw_detail dw_detail
end type
global w_pdm_01040_kvnd w_pdm_01040_kvnd

type variables
str_customer istr_cust

// 자료변경여부 검사
boolean  ib_any_typing
end variables

on w_pdm_01040_kvnd.create
this.p_exit=create p_exit
this.p_del=create p_del
this.p_mod=create p_mod
this.dw_detail=create dw_detail
this.Control[]={this.p_exit,&
this.p_del,&
this.p_mod,&
this.dw_detail}
end on

on w_pdm_01040_kvnd.destroy
destroy(this.p_exit)
destroy(this.p_del)
destroy(this.p_mod)
destroy(this.dw_detail)
end on

event open;f_window_center(this)

istr_cust = Message.PowerObjectParm

dw_detail.settransobject(sqlca)

if isnull(istr_cust.st_tag) or istr_cust.st_tag = "" then
	dw_detail.InsertRow(0)
	dw_detail.setitem(1, 'cust_no', istr_cust.st_custno)
	dw_detail.setitem(1, 'flag', '1')
   dw_detail.setcolumn('kwacod') 	
   dw_detail.setfocus() 	
else
   dw_detail.retrieve(istr_cust.st_custno, istr_cust.st_tag) 
   dw_detail.setfocus() 	
end if	
	
	
	

end event

type p_exit from uo_picture within w_pdm_01040_kvnd
integer x = 1317
integer y = 8
integer width = 178
integer taborder = 40
string pointer = "c:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;
close(parent)
end event

type p_del from uo_picture within w_pdm_01040_kvnd
integer x = 1143
integer y = 8
integer width = 178
integer taborder = 30
string pointer = "c:\erpman\cur\delete.cur"
string picturename = "C:\erpman\image\삭제_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;string s_custno, s_kwacod

if dw_detail.AcceptText() = -1 then return 

if f_msg_delete() = -1 then return

s_custno = trim(dw_detail.GetItemString(1,'cust_no'))  //고객번호   => 관련업체코드
s_kwacod = trim(dw_detail.GetItemString(1,'kwacod'))   //관련업체코드 => 고객번호

dw_detail.deleterow(0)

DELETE FROM "CUST_KWAVND"  
 WHERE ( "CUST_KWAVND"."CUST_NO" = :s_kwacod ) AND  
		 ( "CUST_KWAVND"."KWACOD" = :s_custno )   ;

IF dw_detail.Update() = 1 THEN
	COMMIT;
ELSE
	ROLLBACK;
	RETURN
END IF

close(parent)

end event

type p_mod from uo_picture within w_pdm_01040_kvnd
integer x = 969
integer y = 8
integer width = 178
integer taborder = 20
string pointer = "c:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;string s_kwacod, s_custno, s_gub, s_cstemp, s_kwemp, get_nm
double d_amt

if dw_detail.AcceptText() = -1 then return 

s_custno = trim(dw_detail.GetItemString(1,'cust_no'))  //고객번호   => 관련업체코드
s_kwacod = trim(dw_detail.GetItemString(1,'kwacod'))   //관련업체코드 => 고객번호
s_gub    = trim(dw_detail.GetItemString(1,'kwa_gu'))   //매입 => 매출
s_cstemp = trim(dw_detail.GetItemString(1,'custemp'))  //고객담당자 => 관련업체담당자
s_kwemp  = trim(dw_detail.GetItemString(1,'kwaemp'))   //관련업체담당자 => 고객담당자
d_amt    = dw_detail.GetItemNumber(1,'geamt')          //금액 => 금액

if isnull(s_kwacod) or s_kwacod = "" then
	f_message_chk(1400,'[관련업체코드]')
	dw_detail.SetColumn('kwacod')
	dw_detail.SetFocus()
	return 		
end if	

if isnull(s_gub) or s_gub = "" then
	f_message_chk(1400,'[관련구분]')
	dw_detail.SetColumn('kwa_gu')
	dw_detail.SetFocus()
	return 		
end if	

IF MessageBox("확인", "저장하시겠습니까?", question!, yesno!) = 2	THEN	RETURN

IF dw_detail.Update() > 0	THEN
   //관련업체를 등록시에는 그 관련업체에서도 자료를 등록시켜야 함
	//따라서 조회에서 등록되어 있으면 수정하고 없으면 추가 
	//고객번호와 관련업체코드를 반대로
   if s_gub = '1' then //1:매입, 2:매출
		s_gub = '2'
	else
		s_gub = '1'
	end if	
		
	SELECT "CUST_KWAVND"."CUST_NO"  
     INTO :get_nm  
     FROM "CUST_KWAVND"  
    WHERE ( "CUST_KWAVND"."CUST_NO" = :s_kwacod ) AND   
          ( "CUST_KWAVND"."KWACOD" = :s_custno )   ;

   if sqlca.sqlcode = 0 then
 	   UPDATE "CUST_KWAVND"  
         SET "KWA_GU" = :s_gub, "GEAMT" = :d_amt, "CUSTEMP" = :s_kwemp, "KWAEMP" = :s_cstemp  
		 WHERE ( "CUST_KWAVND"."CUST_NO" = :s_kwacod ) AND  
				 ( "CUST_KWAVND"."KWACOD" = :s_custno )   ;
	else
		 INSERT INTO "CUST_KWAVND"  
				 ( "CUST_NO",  "KWACOD",  "GEAMT", "KWA_GU", "CUSTEMP", "KWAEMP" )  
	    VALUES ( :s_kwacod, :s_custno, :d_amt,  :s_gub,   :s_kwemp, 	  :s_cstemp )  ;
		 
   end if	

	IF sqlca.sqlcode = 0 Then
		COMMIT USING sqlca;	
		ib_any_typing =False
	ELSE
		ROLLBACK USING sqlca;
		Return
	END IF
ELSE
	ROLLBACK USING sqlca;
	Return
END IF

dw_detail.retrieve(s_custno, s_kwacod)

end event

type dw_detail from datawindow within w_pdm_01040_kvnd
event ue_key pbm_dwnkey
event ue_presenter pbm_dwnprocessenter
integer x = 9
integer y = 132
integer width = 1504
integer height = 644
integer taborder = 10
string dataobject = "d_pdm_01040_kvnd"
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF

end event

event ue_presenter;Send( Handle(this), 256, 9, 0 )
Return 1

end event

event dberror;String  sMsg, sErrorcode, sErrorsyntax, sReturn, sNewline
Integer iPos, iCount

iCount			= 0
sNewline			= '~r'
sReturn			= '~n'
sErrorcode 		= Left(sqlerrtext, 9)
iPos 		  		= Len(sqlerrtext) - Pos(sqlerrtext, "No changes made to database.", 1)
sErrorSyntax	= tRIM(Mid(sqlerrtext, 11, Len(sqlerrtext) - iPos - 11))

For iPos = Len(sErrorSyntax) to 1 STEP -1
	 sMsg = Mid(sErrorSyntax, ipos, 1)
	 If sMsg   = sReturn or sMsg = sNewline Then
		 iCount++
	 End if
Next

sErrorSynTax  	= Left(sErrorSyntax, Len(sErrorsyntax) - iCount)


str_db_error db_error_msg
db_error_msg.rowno 	 				= row
db_error_msg.errorcode 				= sErrorCode
db_error_msg.errorsyntax_system	= sErrorSyntax
db_error_msg.errorsyntax_user		= sErrorSyntax
db_error_msg.errorsqlsyntax			= sqlsyntax
OpenWithParm(w_error, db_error_msg)


/*sMsg = "Row No       -> " + String(row) 			 + '~n' + &
		 "Error Code   -> " + sErrorcode			    + '~n' + &
		 "Error Syntax -> " + sErrorSyntax			 + '~n' + &
		 "SqlSyntax    -> " + Sqlsyntax
	MESSAGEBOX("자료처리중 오류발생", sMsg) */

RETURN 1
end event

event editchanged;ib_any_typing = true
end event

event itemerror;return 1
end event

event itemchanged;string snull, sempno, sget_name, s_custno, get_no

setnull(snull)

IF this.GetColumnName() ="kwacod" THEN
	
	sempno = this.GetText()
	
	IF sempno ="" OR IsNull(sempno) THEN 
		this.SetItem(1,"cust_name",snull)
		RETURN
	END IF
	
  SELECT "CUSTOMER"."CUST_NAME"  
    INTO :sget_name  
    FROM "CUSTOMER"  
   WHERE "CUSTOMER"."CUST_NO" = :sempno   ;

	IF SQLCA.SQLCODE = 0 THEN
		this.SetItem(1,"cust_name",sget_name)
 
      s_custno =  this.getitemstring(1, 'cust_no') 
 
      if sempno = s_custno then 
			f_message_chk(44,'[관련업체코드]') 
			this.SetItem(1,"kwacod",snull)
			this.SetItem(1,"cust_name",snull)
			RETURN  1
      else		
		  SELECT "CUST_KWAVND"."CUST_NO"  
			 INTO :get_no  
			 FROM "CUST_KWAVND"  
			WHERE ( "CUST_KWAVND"."CUST_NO" = :s_custno ) AND  
					( "CUST_KWAVND"."KWACOD" = :sempno )   ;

         if sqlca.sqlcode = 0 then
				f_message_chk(37,'[관련업체코드]') 
				this.SetItem(1,"kwacod",snull)
				this.SetItem(1,"cust_name",snull)
				RETURN  1
			end if	
		end if  			
   ELSE
		this.TriggerEvent(RbuttonDown!)
		IF gs_code ="" OR IsNull(gs_code) THEN
			this.SetItem(1,"kwacod",snull)
			this.SetItem(1,"cust_name",snull)
		END IF
	
		Return 1	
	END IF
END IF
end event

event rbuttondown;string snull, s_custno, get_no

SetNull(snull)
SetNull(Gs_code)
SetNull(Gs_codename)

IF  this.GetColumnName() = "kwacod" THEN
	Open(w_cust_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then  return

	this.SetItem(1, "kwacod", gs_Code)
	this.SetItem(1, "cust_name", gs_Codename)

   s_custno = this.getitemstring(1, 'cust_no')

      if gs_code = s_custno then 
			f_message_chk(44,'[관련업체코드]') 
			this.SetItem(1,"kwacod",snull)
			this.SetItem(1,"cust_name",snull)
			RETURN  1
      else		
		  SELECT "CUST_KWAVND"."CUST_NO"  
			 INTO :get_no  
			 FROM "CUST_KWAVND"  
			WHERE ( "CUST_KWAVND"."CUST_NO" = :s_custno ) AND  
					( "CUST_KWAVND"."KWACOD" = :gs_code )   ;

         if sqlca.sqlcode = 0 then
				f_message_chk(37,'[관련업체코드]') 
				this.SetItem(1,"kwacod",snull)
				this.SetItem(1,"cust_name",snull)
				RETURN  1
			end if	
		end if  			
END IF	

end event

