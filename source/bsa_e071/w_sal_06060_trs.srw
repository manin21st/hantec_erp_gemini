$PBExportHeader$w_sal_06060_trs.srw
$PBExportComments$수출비용 회계전송
forward
global type w_sal_06060_trs from window
end type
type pb_2 from u_pb_cal within w_sal_06060_trs
end type
type pb_1 from u_pb_cal within w_sal_06060_trs
end type
type p_2 from uo_picture within w_sal_06060_trs
end type
type p_1 from uo_picture within w_sal_06060_trs
end type
type dw_2 from datawindow within w_sal_06060_trs
end type
type dw_1 from datawindow within w_sal_06060_trs
end type
type rr_1 from roundrectangle within w_sal_06060_trs
end type
end forward

global type w_sal_06060_trs from window
integer x = 101
integer y = 252
integer width = 2565
integer height = 1664
boolean titlebar = true
string title = "수출비용 회계전표 전송"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
pb_2 pb_2
pb_1 pb_1
p_2 p_2
p_1 p_1
dw_2 dw_2
dw_1 dw_1
rr_1 rr_1
end type
global w_sal_06060_trs w_sal_06060_trs

on w_sal_06060_trs.create
this.pb_2=create pb_2
this.pb_1=create pb_1
this.p_2=create p_2
this.p_1=create p_1
this.dw_2=create dw_2
this.dw_1=create dw_1
this.rr_1=create rr_1
this.Control[]={this.pb_2,&
this.pb_1,&
this.p_2,&
this.p_1,&
this.dw_2,&
this.dw_1,&
this.rr_1}
end on

on w_sal_06060_trs.destroy
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.p_2)
destroy(this.p_1)
destroy(this.dw_2)
destroy(this.dw_1)
destroy(this.rr_1)
end on

event open;f_window_center_response(this)

dw_1.settransobject(sqlca)
dw_2.settransobject(sqlca)
dw_2.insertrow(0)
dw_2.setitem(1, "sdate", Left(f_today(), 6) + '01')
dw_2.setitem(1, "edate", f_today())
dw_2.setfocus()
end event

type pb_2 from u_pb_cal within w_sal_06060_trs
integer x = 1518
integer y = 64
integer width = 78
integer height = 80
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_2.SetColumn('sdate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_2.SetItem(1, 'sdate', gs_code)

end event

type pb_1 from u_pb_cal within w_sal_06060_trs
integer x = 2043
integer y = 64
integer width = 78
integer height = 80
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_2.SetColumn('edate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_2.SetItem(1, 'edate', gs_code)

end event

type p_2 from uo_picture within w_sal_06060_trs
integer x = 2341
integer y = 20
integer width = 178
string pointer = "C:\erpman\cur\create.cur"
string picturename = "C:\erpman\image\처리_up.gif"
end type

event clicked;call super::clicked;/* ---------------------------------------------------- */
/* 수출비용을 전송또는 삭제한다.			                 */
/* EXPCOSTH -> EXPCOSTD                                 */
/* ---------------------------------------------------- */
String sCostno, sgubun, sac_move, scho
Decimal diseq, ncnt

dw_2.accepttext()
scho = dw_2.getitemstring(1, "cho")

if dw_1.accepttext() <> 1 then return

Long Lrow

For Lrow = 1 to dw_1.rowcount()
	 sCostNo   = dw_1.getitemstring(Lrow, "costno")
	 diseq     = dw_1.getitemdecimal(Lrow, "iseq") 
	 sac_move  = dw_1.getitemstring(Lrow, "ac_move")
 	 sgubun	  = dw_1.getitemstring(Lrow, "sel")

	ncnt = 0
	if sac_move = 'Y' and sgubun = 'Y' then
		SELECT COUNT(*) INTO :ncnt
		  FROM "KIF06OT0"  
		 WHERE ( "KIF06OT0"."SABU"   = :gs_sabu ) AND  
				 ( "KIF06OT0"."COSTNO" = :sCostNo )  AND  
				 ( "KIF06OT0"."SEQNO"  = :diseq )  AND  				 
				 ( "KIF06OT0"."BAL_DATE" IS NOT NULL )   ;
		
		If nCnt > 0 Then
			f_message_chk(38,'[전표발행 되었습니다]')
			Return 
		End If
  
		/* 기존 Interface 내용 삭제 */
		DELETE FROM "KIF06OT0"
		 WHERE ( "KIF06OT0"."SABU"   = :gs_sabu ) AND  
				 ( "KIF06OT0"."COSTNO" = :sCostNo )  AND 
				 ( "KIF06OT0"."SEQNO"  = :diseq )  AND  				 				 
				 ( "KIF06OT0"."BAL_DATE" is Null )   ;
		 
		if sqlca.sqlcode <> 0 Then 
			rollback;
			MessageBox("전송취소", "전송취소가 실패하였읍니다", stopsign!)
			return 0
		End If 
		 
		Update expcosth Set ac_move = 'N' 
		 Where sabu = :gs_sabu And costno = :sCostNo and iseq = :diseq;

		if sqlca.sqlcode = 0 Then 
			COMMIT;
		Else
			rollback;
			MessageBox("전송취소", "전송취소가 실패하였읍니다", stopsign!)
			return 0
		End If
	Elseif sac_move = 'N' and sgubun = 'Y' then
		/* 기존 Interface 내용 추가 */
		INSERT INTO "KIF06OT0" 
		VALUE ( "SABU",     "COSTNO",       "SEQNO",			 "EXDEPT_CD",    "COSTDT",    "COSTGU",   
				  "COSTCD",   "COSTJGU",      "COSTAMT",      "VATGU", 
				  "COSTVAT",  "COSTFORAMT",   "CURR",         "EXCHRATE",  "COSTVND", 
				  "COSTBIGO", "ALC_GU",			"SAUPJ",  
				  "JACOD",    "GYUL_DATE",    "GYUL_METHOD",  "SEND_BANK", "SEND_DEP",
				  "SEND_NM",  "EDEPT_CD",     "CDEPT_CD",     "SCODGU",    "SACC1_CD",  "SACC2_CD", "CROSSNO",
				  "DEPOTNO" )
		 SELECT "SABU",     "COSTNO",       "ISEQ",			 :gs_dept,       "COSTDT",    "COSTGU",   
				  "COSTCD",   "COSTJGU",      NVL("COSTAMT",0),      "TAXGU",
				  NVL("COSTVAT",0),  NVL("COSTFORAMT",0),   "CURR",         NVL("EXCHRATE",0),  "COSTVND", 
				  "COSTBIGO", 'N',				"SAUPJ",  
				  "JACOD",    "GYUL_DATE",    "GYUL_METHOD",  "SEND_BANK", "SEND_DEP",
				  "SEND_NM",  "EDEPT_CD",     "CDEPT_CD",     "SCODGU",    "SACC1_CD",  "SACC2_CD", "CROSSNO",
				  "AB_DPNO"
			FROM "EXPCOSTH" 
		  WHERE "SABU" = :gs_sabu and "COSTNO" = :sCostNo AND "ISEQ" = :diseq;
		
		If sqlca.sqlcode <> 0 Then
			MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
			ROLLBACK;
			f_message_chk(89,'[Interface Error 0]')
			Return -1
		End If
		
		Update expcosth Set ac_move = 'Y' 
		 Where sabu = :gs_sabu And costno = :sCostNo and iseq = :diseq;
		
		if sqlca.sqlcode = 0 Then 
			COMMIT;
		Else
			rollback;
			MessageBox("전송완료", "전송이 실패되었읍니다", information!)
			return 0
		End If		

	End if
	
NExt

if scho = 'N' then
	MessageBox("전송처리", "전송처리가 완료되었읍니다", stopsign!)
Else
	MessageBox("전송처리", "전송취소가 완료되었읍니다", stopsign!)
End if

close(parent)
end event

type p_1 from uo_picture within w_sal_06060_trs
integer x = 2167
integer y = 20
integer width = 178
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event clicked;call super::clicked;if dw_2.accepttext() <> 1 then return

String sgubun, sdate, edate
sgubun = dw_2.getitemstring(1, "cho")
sdate  = dw_2.getitemstring(1, "sdate")
edate  = dw_2.getitemstring(1, "edate")

if dw_1.retrieve(gs_sabu, sdate, edate, sgubun) < 1 then
	Messagebox("수출비용", "수출비용을 조회 할 자료가 없읍니다", stopsign!)
	return
end if
end event

type dw_2 from datawindow within w_sal_06060_trs
integer x = 32
integer y = 40
integer width = 2144
integer height = 128
integer taborder = 10
string title = "none"
string dataobject = "d_sal_06060_trs_opt"
boolean border = false
boolean livescroll = true
end type

type dw_1 from datawindow within w_sal_06060_trs
integer x = 46
integer y = 212
integer width = 2459
integer height = 1332
integer taborder = 10
string title = "none"
string dataobject = "d_sal_06060_trs"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_sal_06060_trs
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 200
integer width = 2482
integer height = 1352
integer cornerheight = 40
integer cornerwidth = 55
end type

